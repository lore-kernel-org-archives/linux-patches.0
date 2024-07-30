Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C3A189919;
	Tue, 30 Jul 2024 16:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358417; cv=none; b=POIKH2xUecgpgEl67ccVU2BfgjTiGdzEtoTk05ihYjVtr0umZhOcPP2PQ4hZM7conredCZxs/gRHAvpn5KZicj6xANrya9ixxus28x+3xQ4mq42oNLlNa57xSq49krUfV/rx502eQv1lvg204o9WNg567XViNsFPmS/uKFGbexE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358417; c=relaxed/simple;
	bh=oYwHLgkLyF0CFdrzFV7ZD/OABm4vXX7Mbh7/eNdQPXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUYQmWZDCf1LZJjA4pNotd5AnbCEkFt/jayPtL0uOXebrIrykW4uveqe69X8bIIzBXvSMF/0lZ1RAorzbYia6Q6EuRCM7OiTSc944jMxfla20pQAGWAsGh9VjEkVxQmVbV4LuvkJMk8dWib2Rwk4unYDQpfJymAkjQYefeeqSMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uW7w38+7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uW7w38+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B968C32782;
	Tue, 30 Jul 2024 16:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358417;
	bh=oYwHLgkLyF0CFdrzFV7ZD/OABm4vXX7Mbh7/eNdQPXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uW7w38+7om2UNTbX/dnOdxoWOI/azJhCKIqBzrqGGLLLvDNyJr+yOuUSgXlhP7G4c
	 APmWoLxrU9XxVv6qolkHAZ6VLfvTgZQzMjcUi0hC+AG9+NUyPAlo0Sz4msav/a4M2P
	 dvjXyVFum84/Wnmq9YRgXykLZRZw7P/QS8CBgQ84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	James Clark <james.clark@arm.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Stephane Eranian <eranian@google.com>,
	Will Deacon <will@kernel.org>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Bhaskara Budiredla <bbudiredla@marvell.com>,
	Tuan Phan <tuanphan@os.amperecomputing.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 357/809] perf tests: Add some pmu core functionality tests
Date: Tue, 30 Jul 2024 17:43:53 +0200
Message-ID: <20240730151738.744687028@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 678be1ca30cc939e0180c85b4cc9150b3d5ef0c8 ]

Test behavior of PMU names and comparisons wrt suffixes using Intel
uncore_cha, marvell mrvl_ddr_pmu and S390's cpum_cf as examples.

Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: James Clark <james.clark@arm.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Cc: Bharat Bhushan <bbhushan2@marvell.com>
Cc: Bhaskara Budiredla <bbudiredla@marvell.com>
Cc: Tuan Phan <tuanphan@os.amperecomputing.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20240515060114.3268149-3-irogers@google.com
Stable-dep-of: 3e0bf9fde298 ("perf pmu: Restore full PMU name wildcard support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/pmu.c | 99 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)

diff --git a/tools/perf/tests/pmu.c b/tools/perf/tests/pmu.c
index 06cc0e46cb289..cc88b5920c3e2 100644
--- a/tools/perf/tests/pmu.c
+++ b/tools/perf/tests/pmu.c
@@ -3,6 +3,7 @@
 #include "evsel.h"
 #include "parse-events.h"
 #include "pmu.h"
+#include "pmus.h"
 #include "tests.h"
 #include "debug.h"
 #include "fncache.h"
@@ -340,10 +341,108 @@ static int test__pmu_event_names(struct test_suite *test __maybe_unused,
 	return ret;
 }
 
+static const char * const uncore_chas[] = {
+	"uncore_cha_0",
+	"uncore_cha_1",
+	"uncore_cha_2",
+	"uncore_cha_3",
+	"uncore_cha_4",
+	"uncore_cha_5",
+	"uncore_cha_6",
+	"uncore_cha_7",
+	"uncore_cha_8",
+	"uncore_cha_9",
+	"uncore_cha_10",
+	"uncore_cha_11",
+	"uncore_cha_12",
+	"uncore_cha_13",
+	"uncore_cha_14",
+	"uncore_cha_15",
+	"uncore_cha_16",
+	"uncore_cha_17",
+	"uncore_cha_18",
+	"uncore_cha_19",
+	"uncore_cha_20",
+	"uncore_cha_21",
+	"uncore_cha_22",
+	"uncore_cha_23",
+	"uncore_cha_24",
+	"uncore_cha_25",
+	"uncore_cha_26",
+	"uncore_cha_27",
+	"uncore_cha_28",
+	"uncore_cha_29",
+	"uncore_cha_30",
+	"uncore_cha_31",
+};
+
+static const char * const mrvl_ddrs[] = {
+	"mrvl_ddr_pmu_87e1b0000000",
+	"mrvl_ddr_pmu_87e1b1000000",
+	"mrvl_ddr_pmu_87e1b2000000",
+	"mrvl_ddr_pmu_87e1b3000000",
+	"mrvl_ddr_pmu_87e1b4000000",
+	"mrvl_ddr_pmu_87e1b5000000",
+	"mrvl_ddr_pmu_87e1b6000000",
+	"mrvl_ddr_pmu_87e1b7000000",
+	"mrvl_ddr_pmu_87e1b8000000",
+	"mrvl_ddr_pmu_87e1b9000000",
+	"mrvl_ddr_pmu_87e1ba000000",
+	"mrvl_ddr_pmu_87e1bb000000",
+	"mrvl_ddr_pmu_87e1bc000000",
+	"mrvl_ddr_pmu_87e1bd000000",
+	"mrvl_ddr_pmu_87e1be000000",
+	"mrvl_ddr_pmu_87e1bf000000",
+};
+
+static int test__name_len(struct test_suite *test __maybe_unused, int subtest __maybe_unused)
+{
+	TEST_ASSERT_VAL("cpu", pmu_name_len_no_suffix("cpu") == strlen("cpu"));
+	TEST_ASSERT_VAL("i915", pmu_name_len_no_suffix("i915") == strlen("i915"));
+	TEST_ASSERT_VAL("cpum_cf", pmu_name_len_no_suffix("cpum_cf") == strlen("cpum_cf"));
+	for (size_t i = 0; i < ARRAY_SIZE(uncore_chas); i++) {
+		TEST_ASSERT_VAL("Strips uncore_cha suffix",
+				pmu_name_len_no_suffix(uncore_chas[i]) ==
+				strlen("uncore_cha"));
+	}
+	for (size_t i = 0; i < ARRAY_SIZE(mrvl_ddrs); i++) {
+		TEST_ASSERT_VAL("Strips mrvl_ddr_pmu suffix",
+				pmu_name_len_no_suffix(mrvl_ddrs[i]) ==
+				strlen("mrvl_ddr_pmu"));
+	}
+	return TEST_OK;
+}
+
+static int test__name_cmp(struct test_suite *test __maybe_unused, int subtest __maybe_unused)
+{
+	TEST_ASSERT_EQUAL("cpu", pmu_name_cmp("cpu", "cpu"), 0);
+	TEST_ASSERT_EQUAL("i915", pmu_name_cmp("i915", "i915"), 0);
+	TEST_ASSERT_EQUAL("cpum_cf", pmu_name_cmp("cpum_cf", "cpum_cf"), 0);
+	TEST_ASSERT_VAL("i915", pmu_name_cmp("cpu", "i915") < 0);
+	TEST_ASSERT_VAL("i915", pmu_name_cmp("i915", "cpu") > 0);
+	TEST_ASSERT_VAL("cpum_cf", pmu_name_cmp("cpum_cf", "cpum_ce") > 0);
+	TEST_ASSERT_VAL("cpum_cf", pmu_name_cmp("cpum_cf", "cpum_d0") < 0);
+	for (size_t i = 1; i < ARRAY_SIZE(uncore_chas); i++) {
+		TEST_ASSERT_VAL("uncore_cha suffixes ordered lt",
+				pmu_name_cmp(uncore_chas[i-1], uncore_chas[i]) < 0);
+		TEST_ASSERT_VAL("uncore_cha suffixes ordered gt",
+				pmu_name_cmp(uncore_chas[i], uncore_chas[i-1]) > 0);
+	}
+	for (size_t i = 1; i < ARRAY_SIZE(mrvl_ddrs); i++) {
+		TEST_ASSERT_VAL("mrvl_ddr_pmu suffixes ordered lt",
+				pmu_name_cmp(mrvl_ddrs[i-1], mrvl_ddrs[i]) < 0);
+		TEST_ASSERT_VAL("mrvl_ddr_pmu suffixes ordered gt",
+				pmu_name_cmp(mrvl_ddrs[i], mrvl_ddrs[i-1]) > 0);
+	}
+	return TEST_OK;
+}
+
 static struct test_case tests__pmu[] = {
 	TEST_CASE("Parsing with PMU format directory", pmu_format),
 	TEST_CASE("Parsing with PMU event", pmu_events),
 	TEST_CASE("PMU event names", pmu_event_names),
+	TEST_CASE("PMU name combining", name_len),
+	TEST_CASE("PMU name comparison", name_cmp),
 	{	.name = NULL, }
 };
 
-- 
2.43.0



