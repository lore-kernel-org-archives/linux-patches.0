Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4FB343893;
	Sat, 12 Sep 2026 12:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214790; cv=none; b=NNFruxlJpa3w07dcOeqKStMOjaAJH2o6w5JfzlX6NQqhyiFe0a8LBcx19iUT9k57Ld4fWkie1kbuebezwyaSzj7+sqAagR1b5nnpoa3q7mr1GvFACfGxlAQCY5iAejdXMWmux7C0A4ivuBy3BAW0EIGuULjYubNwRxX4pdWMrMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214790; c=relaxed/simple;
	bh=OIaxdGirB57ZVsyHE3mwF2jb+fC4QbtTHVTpnaNromo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXcxVA3z1kPXyvmRHaV6soG3GnAi6ap1CO2n7qzu95eQkICKDnFR15TdaxNfv8FERel5MC22aYv/wnfdOuBThgUQb1/BvH5dEbPiSigA6iagq6FKSwsIvJCYTHItB5qmFGM3YG/GVoihVwZcjzrxjl88NpKGj9VxtZ0RYp9DdD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AkQhCEp2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AkQhCEp2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E961F000FF;
	Sat, 12 Sep 2026 12:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214789;
	bh=eY3nCRKE9bYTeMKlOVIUs3grB21E8cOqpaMwIzEwaTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AkQhCEp208g8xzvyA0ertFM3LJ0+nib4Ymo85UGCvQIzoTrselksHMWfcC7v8/kI4
	 QxS6FpUVtOj7WjdQ5hFyIztCHnLX/36sRnYIPTDolAd5fJt4nG8SJX6icm4cPXZkVy
	 WwYA/LZFZKjh1H3TRHgaLs7hRVK0MwN3L8qWP5Gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0398/1376] perf vendor events amd: Update Zen 5 core events
Date: Sat, 12 Sep 2026 08:47:04 +0200
Message-ID: <20260912065616.414159963@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sandipan Das <sandipan.das@amd.com>

[ Upstream commit 047979af3bf6a118066c81099162d518de63abb1 ]

Update definitions for the following events.
  * PMCx00A - Add missing unit masks
  * PMCx00B - Add missing unit masks and fix descriptions
  * PMCx00C - Add missing unit masks
  * PMCx00D - Add missing unit masks
  * PMCx025 - Add missing unit masks and fix descriptions

Fixes: 45c072f2537a ("perf vendor events amd: Add Zen 5 core events")
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arch/x86/amdzen5/floating-point.json      | 130 +++++++++++++++---
 .../arch/x86/amdzen5/load-store.json          |   8 +-
 2 files changed, 120 insertions(+), 18 deletions(-)

diff --git a/tools/perf/pmu-events/arch/x86/amdzen5/floating-point.json b/tools/perf/pmu-events/arch/x86/amdzen5/floating-point.json
index 9204bfb1d69e0..569975b53cc33 100644
--- a/tools/perf/pmu-events/arch/x86/amdzen5/floating-point.json
+++ b/tools/perf/pmu-events/arch/x86/amdzen5/floating-point.json
@@ -179,6 +179,30 @@
     "BriefDescription": "Retired scalar floating-point blend ops.",
     "UMask": "0x09"
   },
+  {
+    "EventName": "fp_ops_retired_by_type.scalar_mov",
+    "EventCode": "0x0a",
+    "BriefDescription": "Retired scalar floating-point MOV ops.",
+    "UMask": "0x0a"
+  },
+  {
+    "EventName": "fp_ops_retired_by_type.scalar_shuffle",
+    "EventCode": "0x0a",
+    "BriefDescription": "Retired scalar floating-point shuffle ops (may include instructions not necessarily thought of as including shuffles e.g. horizontal add, dot product, and certain MOV instructions).",
+    "UMask": "0x0b"
+  },
+  {
+    "EventName": "fp_ops_retired_by_type.scalar_bfloat",
+    "EventCode": "0x0a",
+    "BriefDescription": "Retired scalar floating-point bfloat ops.",
+    "UMask": "0x0c"
+  },
+  {
+    "EventName": "fp_ops_retired_by_type.scalar_logical",
+    "EventCode": "0x0a",
+    "BriefDescription": "Retired scalar floating-point logical ops.",
+    "UMask": "0x0d"
+  },
   {
     "EventName": "fp_ops_retired_by_type.scalar_other",
     "EventCode": "0x0a",
@@ -245,12 +269,24 @@
     "BriefDescription": "Retired vector floating-point blend ops.",
     "UMask": "0x90"
   },
+  {
+    "EventName": "fp_ops_retired_by_type.vector_mov",
+    "EventCode": "0x0a",
+    "BriefDescription": "Retired vector floating-point MOV ops.",
+    "UMask": "0xa0"
+  },
   {
     "EventName": "fp_ops_retired_by_type.vector_shuffle",
     "EventCode": "0x0a",
     "BriefDescription": "Retired vector floating-point shuffle ops (may include instructions not necessarily thought of as including shuffles e.g. horizontal add, dot product, and certain MOV instructions).",
     "UMask": "0xb0"
   },
+  {
+    "EventName": "fp_ops_retired_by_type.vector_bfloat",
+    "EventCode": "0x0a",
+    "BriefDescription": "Retired vector floating-point bfloat ops.",
+    "UMask": "0xc0"
+  },
   {
     "EventName": "fp_ops_retired_by_type.vector_logical",
     "EventCode": "0x0a",
@@ -278,7 +314,7 @@
   {
     "EventName": "sse_avx_ops_retired.mmx_add",
     "EventCode": "0x0b",
-    "BriefDescription": "Retired MMX integer add.",
+    "BriefDescription": "Retired MMX integer add ops.",
     "UMask": "0x01"
   },
   {
@@ -299,16 +335,34 @@
     "BriefDescription": "Retired MMX integer multiply-accumulate ops.",
     "UMask": "0x04"
   },
+  {
+    "EventName": "sse_avx_ops_retired.mmx_aes",
+    "EventCode": "0x0b",
+    "BriefDescription": "Retired MMX integer AES ops.",
+    "UMask": "0x05"
+  },
+  {
+    "EventName": "sse_avx_ops_retired.mmx_sha",
+    "EventCode": "0x0b",
+    "BriefDescription": "Retired MMX integer SHA ops.",
+    "UMask": "0x06"
+  },
   {
     "EventName": "sse_avx_ops_retired.mmx_cmp",
     "EventCode": "0x0b",
     "BriefDescription": "Retired MMX integer compare ops.",
     "UMask": "0x07"
   },
+  {
+    "EventName": "sse_avx_ops_retired.mmx_cvt",
+    "EventCode": "0x0b",
+    "BriefDescription": "Retired MMX integer convert or pack ops.",
+    "UMask": "0x08"
+  },
   {
     "EventName": "sse_avx_ops_retired.mmx_shift",
     "EventCode": "0x0b",
-    "BriefDescription": "Retired MMX integer shift ops.",
+    "BriefDescription": "Retired MMX integer shift or rotate ops.",
     "UMask": "0x09"
   },
   {
@@ -324,9 +378,9 @@
     "UMask": "0x0b"
   },
   {
-    "EventName": "sse_avx_ops_retired.mmx_pack",
+    "EventName": "sse_avx_ops_retired.mmx_vnni",
     "EventCode": "0x0b",
-    "BriefDescription": "Retired MMX integer pack ops.",
+    "BriefDescription": "Retired MMX integer VNNI ops.",
     "UMask": "0x0c"
   },
   {
@@ -390,15 +444,15 @@
     "UMask": "0x70"
   },
   {
-    "EventName": "sse_avx_ops_retired.sse_avx_clm",
+    "EventName": "sse_avx_ops_retired.sse_avx_cvt",
     "EventCode": "0x0b",
-    "BriefDescription": "Retired SSE and AVX integer CLM ops.",
+    "BriefDescription": "Retired SSE and AVX integer convert or pack ops.",
     "UMask": "0x80"
   },
   {
     "EventName": "sse_avx_ops_retired.sse_avx_shift",
     "EventCode": "0x0b",
-    "BriefDescription": "Retired SSE and AVX integer shift ops.",
+    "BriefDescription": "Retired SSE and AVX integer shift or rotate ops.",
     "UMask": "0x90"
   },
   {
@@ -414,9 +468,9 @@
     "UMask": "0xb0"
   },
   {
-    "EventName": "sse_avx_ops_retired.sse_avx_pack",
+    "EventName": "sse_avx_ops_retired.sse_avx_vnni",
     "EventCode": "0x0b",
-    "BriefDescription": "Retired SSE and AVX integer pack ops.",
+    "BriefDescription": "Retired SSE and AVX integer VNNI ops.",
     "UMask": "0xc0"
   },
   {
@@ -497,12 +551,24 @@
     "BriefDescription": "Retired 128-bit packed floating-point blend ops.",
     "UMask": "0x09"
   },
+  {
+    "EventName": "fp_pack_ops_retired.fp128_mov",
+    "EventCode": "0x0c",
+    "BriefDescription": "Retired 128-bit packed floating-point MOV ops.",
+    "UMask": "0x0a"
+  },
   {
     "EventName": "fp_pack_ops_retired.fp128_shuffle",
     "EventCode": "0x0c",
     "BriefDescription": "Retired 128-bit packed floating-point shuffle ops (may include instructions not necessarily thought of as including shuffles e.g. horizontal add, dot product, and certain MOV instructions).",
     "UMask": "0x0b"
   },
+  {
+    "EventName": "fp_pack_ops_retired.fp128_bfloat",
+    "EventCode": "0x0c",
+    "BriefDescription": "Retired 128-bit packed floating-point bfloat ops.",
+    "UMask": "0x0c"
+  },
   {
     "EventName": "fp_pack_ops_retired.fp128_logical",
     "EventCode": "0x0c",
@@ -575,12 +641,24 @@
     "BriefDescription": "Retired 256-bit packed floating-point blend ops.",
     "UMask": "0x90"
   },
+  {
+    "EventName": "fp_pack_ops_retired.fp256_mov",
+    "EventCode": "0x0c",
+    "BriefDescription": "Retired 256-bit packed floating-point MOV ops.",
+    "UMask": "0xa0"
+  },
   {
     "EventName": "fp_pack_ops_retired.fp256_shuffle",
     "EventCode": "0x0c",
     "BriefDescription": "Retired 256-bit packed floating-point shuffle ops (may include instructions not necessarily thought of as including shuffles e.g. horizontal add, dot product, and certain MOV instructions).",
     "UMask": "0xb0"
   },
+  {
+    "EventName": "fp_pack_ops_retired.fp256_bfloat",
+    "EventCode": "0x0c",
+    "BriefDescription": "Retired 256-bit packed floating-point bfloat ops.",
+    "UMask": "0xc0"
+  },
   {
     "EventName": "fp_pack_ops_retired.fp256_logical",
     "EventCode": "0x0c",
@@ -648,15 +726,15 @@
     "UMask": "0x07"
   },
   {
-    "EventName": "packed_int_op_type.int128_clm",
+    "EventName": "packed_int_op_type.int128_cvt",
     "EventCode": "0x0d",
-    "BriefDescription": "Retired 128-bit packed integer CLM ops.",
+    "BriefDescription": "Retired 128-bit packed integer convert or pack ops.",
     "UMask": "0x08"
   },
   {
     "EventName": "packed_int_op_type.int128_shift",
     "EventCode": "0x0d",
-    "BriefDescription": "Retired 128-bit packed integer shift ops.",
+    "BriefDescription": "Retired 128-bit packed integer shift or rotate ops.",
     "UMask": "0x09"
   },
   {
@@ -672,9 +750,9 @@
     "UMask": "0x0b"
   },
   {
-    "EventName": "packed_int_op_type.int128_pack",
+    "EventName": "packed_int_op_type.int128_vnni",
     "EventCode": "0x0d",
-    "BriefDescription": "Retired 128-bit packed integer pack ops.",
+    "BriefDescription": "Retired 128-bit packed integer VNNI ops.",
     "UMask": "0x0c"
   },
   {
@@ -719,16 +797,34 @@
     "BriefDescription": "Retired 256-bit packed integer multiply-accumulate ops.",
     "UMask": "0x40"
   },
+  {
+    "EventName": "packed_int_op_type.int256_aes",
+    "EventCode": "0x0d",
+    "BriefDescription": "Retired 256-bit packed integer AES ops.",
+    "UMask": "0x50"
+  },
+  {
+    "EventName": "packed_int_op_type.int256_sha",
+    "EventCode": "0x0d",
+    "BriefDescription": "Retired 256-bit packed integer SHA ops.",
+    "UMask": "0x60"
+  },
   {
     "EventName": "packed_int_op_type.int256_cmp",
     "EventCode": "0x0d",
     "BriefDescription": "Retired 256-bit packed integer compare ops.",
     "UMask": "0x70"
   },
+  {
+    "EventName": "packed_int_op_type.int256_cvt",
+    "EventCode": "0x0d",
+    "BriefDescription": "Retired 256-bit packed integer convert or pack ops.",
+    "UMask": "0x80"
+  },
   {
     "EventName": "packed_int_op_type.int256_shift",
     "EventCode": "0x0d",
-    "BriefDescription": "Retired 256-bit packed integer shift ops.",
+    "BriefDescription": "Retired 256-bit packed integer shift or rotate ops.",
     "UMask": "0x90"
   },
   {
@@ -744,9 +840,9 @@
     "UMask": "0xb0"
   },
   {
-    "EventName": "packed_int_op_type.int256_pack",
+    "EventName": "packed_int_op_type.int256_vnni",
     "EventCode": "0x0d",
-    "BriefDescription": "Retired 256-bit packed integer pack ops.",
+    "BriefDescription": "Retired 256-bit packed integer VNNI ops.",
     "UMask": "0xc0"
   },
   {
diff --git a/tools/perf/pmu-events/arch/x86/amdzen5/load-store.json b/tools/perf/pmu-events/arch/x86/amdzen5/load-store.json
index 917f9d68f85a6..d1ac7ff52a4d7 100644
--- a/tools/perf/pmu-events/arch/x86/amdzen5/load-store.json
+++ b/tools/perf/pmu-events/arch/x86/amdzen5/load-store.json
@@ -8,9 +8,15 @@
   {
     "EventName": "ls_locks.bus_lock",
     "EventCode": "0x25",
-    "BriefDescription": "Retired Lock instructions which caused a bus lock.",
+    "BriefDescription": "Retired lock instructions which caused a bus lock.",
     "UMask": "0x01"
   },
+  {
+    "EventName": "ls_locks.all",
+    "EventCode": "0x25",
+    "BriefDescription": "Retired lock instructions of all types.",
+    "UMask": "0x1f"
+  },
   {
     "EventName": "ls_ret_cl_flush",
     "EventCode": "0x26",
-- 
2.53.0



