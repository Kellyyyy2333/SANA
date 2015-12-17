CC = g++

#CXXFLAGS = -Wall -fno-inline -O2 -std=c++11 -g
CXXFLAGS = -Wall -std=c++11 -O3 -march=native

INCLUDES = 
LFLAGS = 
LIBS = 

ARGUMENTS_SRC = 										\
	src/arguments/ArgumentParser.cpp					\
	src/arguments/ModeSelector.cpp						\
	src/arguments/MeasureSelector.cpp					\
	src/arguments/MethodSelector.cpp					\
	src/arguments/GraphLoader.cpp

MEASUSES_SRCS = 				 						\
	src/measures/EdgeCorrectness.cpp 					\
	src/measures/GoAverage.cpp      					\
	src/measures/GoCoverage.cpp      					\
	src/measures/InducedConservedStructure.cpp			\
	src/measures/InvalidMeasure.cpp             		\
	src/measures/LargestCommonConnectedSubgraph.cpp		\
	src/measures/Measure.cpp							\
	src/measures/MeasureCombination.cpp					\
	src/measures/NodeCorrectness.cpp                    \
	src/measures/ShortestPathConservation.cpp           \
	src/measures/SymmetricSubstructureScore.cpp         \
	src/measures/WeightedEdgeConservation.cpp           \
	src/measures/localMeasures/EdgeDensity.cpp          \
	src/measures/localMeasures/GenericLocalMeasure.cpp  \
	src/measures/localMeasures/GoSimilarity.cpp         \
	src/measures/localMeasures/Graphlet.cpp             \
	src/measures/localMeasures/GraphletLGraal.cpp       \
	src/measures/localMeasures/Importance.cpp           \
	src/measures/localMeasures/LocalMeasure.cpp         \
	src/measures/localMeasures/NodeDensity.cpp          \
	src/measures/localMeasures/Sequence.cpp			
	
METHODS_SRC =                                           \
	src/methods/GreedyLCCS.cpp                          \
	src/methods/HillClimbing.cpp                        \
	src/methods/HubAlignWrapper.cpp                     \
	src/methods/LGraalWrapper.cpp                       \
	src/methods/Method.cpp                              \
	src/methods/NoneMethod.cpp                          \
	src/methods/RandomAligner.cpp                       \
	src/methods/SANA.cpp                                \
	src/methods/TabuSearch.cpp                          \
	src/methods/WeightedAlignmentVoter.cpp              \

MODES_SRC = 											\
	src/modes/AlphaEstimation.cpp                       \
	src/modes/Experiment.cpp                            \
	src/modes/ParameterEstimation.cpp                   \
	src/modes/NormalMode.cpp							\
	src/modes/DebugMode.cpp								\
	src/modes/ClusterMode.cpp
	

OTHER_SRC =                                             \
	src/Alignment.cpp                                   \
	src/ComplementaryProteins.cpp                       \
	src/computeGraphlets.cpp                            \
	src/Graph.cpp                                       \
	src/main.cpp                                        \
	src/NormalDistribution.cpp                          \
	src/templateUtils.cpp                               \
	src/Timer.cpp                                       \
	src/utils.cpp										\
	src/RandomSeed.cpp									\
	src/Report.cpp
	

SRCS = $(MEASUSES_SRCS) $(METHODS_SRC) $(ARGUMENTS_SRC) $(MODES_SRC) $(OTHER_SRC)
OBJDIR = _objs
OBJS = $(addprefix $(OBJDIR)/, $(SRCS:.cpp=.o))

#MAIN = sana_dbg
MAIN = sana

.PHONY: depend clean

all:    $(MAIN)

$(MAIN): $(OBJS) 
	$(CC) $(CXXFLAGS) $(INCLUDES) -o $(MAIN) $(OBJS) $(LFLAGS) $(LIBS)

#.c.o:
#	$(CC) $(CXXFLAGS) $(INCLUDES) -c $<  -o $@
	
#$(OBJDIR)/%.o: %.c
#    $(CC) $(CXXFLAGS) $(INCLUDES) -c -o $@ $<

$(OBJDIR)/%.o: %.cpp
	mkdir -p $(dir $@)
	$(CC) -c $(INCLUDES) -o $@ $< $(CXXFLAGS) 

# TEST_SRC is anyting that ends in _UT (unit test)
TEST_SRC = $(wildcard test/*_UT.cpp)
# TEST_DEPENDS is all the OBJS without main and Gtest 
_MAIN_OBJ = $(OBJDIR)/src/main.o
TEST_DEPENDS = $(filter-out $(_MAIN_OBJ), $(OBJS)) 
GTEST_OBJS = test/gtest/gtest-main.o test/gtest/gtest-all.o
TEST_OBJS = $(addprefix $(OBJDIR)/, $(TEST_SRC:.cpp=.o))
TEST_MAIN = unit_test
TEST_CXXFLAGS = $(CXXFLAGS) -lpthread # add pthread for Gtest

regresion_test:
	./regresionTest.sh

test_all: $(TEST_OBJS) $(GTEST_OBJS) $(TEST_DEPENDS)
	$(CC) $(TEST_CXXFLAGS) $(INCLUDES) -o $(OBJDIR)/$(TEST_MAIN) $(TEST_OBJS) $(GTEST_OBJS) $(TEST_DEPENDS) $(LFLAGS) $(LIBS)
	./$(OBJDIR)/$(TEST_MAIN)
	
test: test/$(tg).o $(GTEST_OBJS) $(TEST_DEPENDS)
	$(CC) $(TEST_CXXFLAGS) $(INCLUDES) -o $(OBJDIR)/$(tg) test/$(tg).o $(GTEST_OBJS) $(TEST_DEPENDS) $(LFLAGS) $(LIBS)
	./$(OBJDIR)/$(tg)
	
$(GTEST_OBJS):
	cd test/gtest && make

clean: clear_cache
	$(RM) -rf $(OBJDIR)
	$(RM) $(MAIN)

clear_cache:
	rm -rf matrices/autogenerated
	rm -rf tmp
	rm -rf networks/*/autogenerated

depend: $(SRCS)
	makedepend $(INCLUDES) $^


	

