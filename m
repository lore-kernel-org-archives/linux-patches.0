Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7AA6FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A74C433C9;
	Sun, 17 Sep 2023 20:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981116;
	bh=JnwDWx9NktCnztmqlX9SspKb3LKzqMKaMxDT6XP5by0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TfjbC/piI7ucQk6jdgicSdB8wQwytkyk30bJfNmD4VB6S+jQ13AbLGteUpjMZth9r
	 tX3vMfeFWAdgZsNhOZokU8sy+LcOCNBYlFz7j3C4XFBGOzSedUvfCriCcqv3vvdpZD
	 cJvcYMThb699h0VGXZAitLtsBy67+Y8e1gAXswnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kajol Jain <kjain@linux.ibm.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Disha Goel <disgoel@linux.ibm.com>,
	Ian Rogers <irogers@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 075/219] perf vendor events: Drop some of the JSON/events for power10 platform
Date: Sun, 17 Sep 2023 21:13:22 +0200
Message-ID: <20230917191043.696947543@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kajol Jain <kjain@linux.ibm.com>

[ Upstream commit e104df97b8dcfbab2e42de634b99bf03f0805d85 ]

Drop some of the JSON/events for power10 platform due to counter
data mismatch.

Fixes: 32daa5d7899e0343 ("perf vendor events: Initial JSON/events list for power10 platform")
Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Disha Goel <disgoel@linux.ibm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: linuxppc-dev@lists.ozlabs.org
Link: https://lore.kernel.org/r/20230814112803.1508296-2-kjain@linux.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arch/powerpc/power10/floating_point.json           |  7 -------
 tools/perf/pmu-events/arch/powerpc/power10/marked.json | 10 ----------
 tools/perf/pmu-events/arch/powerpc/power10/others.json |  5 -----
 .../perf/pmu-events/arch/powerpc/power10/pipeline.json | 10 ----------
 .../pmu-events/arch/powerpc/power10/translation.json   |  5 -----
 5 files changed, 37 deletions(-)
 delete mode 100644 tools/perf/pmu-events/arch/powerpc/power10/floating_point.json

diff --git a/tools/perf/pmu-events/arch/powerpc/power10/floating_point.json b/tools/perf/pmu-events/arch/powerpc/power10/floating_point.json
deleted file mode 100644
index 54acb55e2c8c6..0000000000000
--- a/tools/perf/pmu-events/arch/powerpc/power10/floating_point.json
+++ /dev/null
@@ -1,7 +0,0 @@
-[
-  {
-    "EventCode": "0x4016E",
-    "EventName": "PM_THRESH_NOT_MET",
-    "BriefDescription": "Threshold counter did not meet threshold."
-  }
-]
diff --git a/tools/perf/pmu-events/arch/powerpc/power10/marked.json b/tools/perf/pmu-events/arch/powerpc/power10/marked.json
index 131f8d0e88317..f2436fc5537ce 100644
--- a/tools/perf/pmu-events/arch/powerpc/power10/marked.json
+++ b/tools/perf/pmu-events/arch/powerpc/power10/marked.json
@@ -19,11 +19,6 @@
     "EventName": "PM_MRK_BR_TAKEN_CMPL",
     "BriefDescription": "Marked Branch Taken instruction completed."
   },
-  {
-    "EventCode": "0x20112",
-    "EventName": "PM_MRK_NTF_FIN",
-    "BriefDescription": "The marked instruction became the oldest in the pipeline before it finished. It excludes instructions that finish at dispatch."
-  },
   {
     "EventCode": "0x2C01C",
     "EventName": "PM_EXEC_STALL_DMISS_OFF_CHIP",
@@ -64,11 +59,6 @@
     "EventName": "PM_L1_ICACHE_MISS",
     "BriefDescription": "Demand instruction cache miss."
   },
-  {
-    "EventCode": "0x30130",
-    "EventName": "PM_MRK_INST_FIN",
-    "BriefDescription": "marked instruction finished. Excludes instructions that finish at dispatch. Note that stores always finish twice since the address gets issued to the LSU and the data gets issued to the VSU."
-  },
   {
     "EventCode": "0x34146",
     "EventName": "PM_MRK_LD_CMPL",
diff --git a/tools/perf/pmu-events/arch/powerpc/power10/others.json b/tools/perf/pmu-events/arch/powerpc/power10/others.json
index e691041ee8678..36c5bbc64c3be 100644
--- a/tools/perf/pmu-events/arch/powerpc/power10/others.json
+++ b/tools/perf/pmu-events/arch/powerpc/power10/others.json
@@ -29,11 +29,6 @@
     "EventName": "PM_DISP_SS0_2_INSTR_CYC",
     "BriefDescription": "Cycles in which Superslice 0 dispatches either 1 or 2 instructions."
   },
-  {
-    "EventCode": "0x1F15C",
-    "EventName": "PM_MRK_STCX_L2_CYC",
-    "BriefDescription": "Cycles spent in the nest portion of a marked Stcx instruction. It starts counting when the operation starts to drain to the L2 and it stops counting when the instruction retires from the Instruction Completion Table (ICT) in the Instruction Sequencing Unit (ISU)."
-  },
   {
     "EventCode": "0x10066",
     "EventName": "PM_ADJUNCT_CYC",
diff --git a/tools/perf/pmu-events/arch/powerpc/power10/pipeline.json b/tools/perf/pmu-events/arch/powerpc/power10/pipeline.json
index 449f57e8ba6af..799893c56f32b 100644
--- a/tools/perf/pmu-events/arch/powerpc/power10/pipeline.json
+++ b/tools/perf/pmu-events/arch/powerpc/power10/pipeline.json
@@ -194,11 +194,6 @@
     "EventName": "PM_TLBIE_FIN",
     "BriefDescription": "TLBIE instruction finished in the LSU. Two TLBIEs can finish each cycle. All will be counted."
   },
-  {
-    "EventCode": "0x3D058",
-    "EventName": "PM_SCALAR_FSQRT_FDIV_ISSUE",
-    "BriefDescription": "Scalar versions of four floating point operations: fdiv,fsqrt (xvdivdp, xvdivsp, xvsqrtdp, xvsqrtsp)."
-  },
   {
     "EventCode": "0x30066",
     "EventName": "PM_LSU_FIN",
@@ -269,11 +264,6 @@
     "EventName": "PM_IC_MISS_CMPL",
     "BriefDescription": "Non-speculative instruction cache miss, counted at completion."
   },
-  {
-    "EventCode": "0x4D050",
-    "EventName": "PM_VSU_NON_FLOP_CMPL",
-    "BriefDescription": "Non-floating point VSU instructions completed."
-  },
   {
     "EventCode": "0x4D052",
     "EventName": "PM_2FLOP_CMPL",
diff --git a/tools/perf/pmu-events/arch/powerpc/power10/translation.json b/tools/perf/pmu-events/arch/powerpc/power10/translation.json
index 3e47b804a0a8f..961e2491e73f6 100644
--- a/tools/perf/pmu-events/arch/powerpc/power10/translation.json
+++ b/tools/perf/pmu-events/arch/powerpc/power10/translation.json
@@ -4,11 +4,6 @@
     "EventName": "PM_MRK_START_PROBE_NOP_CMPL",
     "BriefDescription": "Marked Start probe nop (AND R0,R0,R0) completed."
   },
-  {
-    "EventCode": "0x20016",
-    "EventName": "PM_ST_FIN",
-    "BriefDescription": "Store finish count. Includes speculative activity."
-  },
   {
     "EventCode": "0x20018",
     "EventName": "PM_ST_FWD",
-- 
2.40.1



