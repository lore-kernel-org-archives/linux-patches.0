Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C4B38423B;
	Sat, 12 Sep 2026 07:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197697; cv=none; b=DVP0IxnW+MWdhYgq1Tn/EdPgRXymjDyBxowXRfCTeoLhTQtF129YfKsf9VLoIYqSeEehpQrn3h0ZXB/uqGVxaIe7bdoBOwXxSgjYAT/OjGHQ2PQZdJpaoqENc6nIKt69MaV/Xs0uBddYs9KeuWws7Gj/yAeKOQcuGQkDNoOzGt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197697; c=relaxed/simple;
	bh=RXxRUdva+CYUa86YTLyOfXVRFnO9a7XzTy4WdAXxPUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JyJGl/KQF5v2mlW+5ZM397RiQspyg7hZkpa9EuE9hJONwGJs96ZA8vk0EqswpfG1Z69wXgTyD5bZn2D9s9WEDbpLaQ+5gKWaV1Rj4jPmz9KzYi59h5w5wM+d8QQx7qVgraVqVHqbwH02O/cPf5gM2CzhLDRKXG4L06FvdEPNOFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oh2IOETh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oh2IOETh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CCFB1F000FF;
	Sat, 12 Sep 2026 07:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197695;
	bh=vxaA5xR94xh0ijEYRIQoXUiC3TcNFdwS56yrZvlsXVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oh2IOEThBAyXn401FFR2F0xPw4mLAy3vgwEkuThMrVs4uWoNBjbrvCTIWxrveflY7
	 NFZZ1sPreG/kRO9kq1z49ZIu85VvUh+M5SUVCHKCpHvJ/nLSoXqZ3huNlDu1Z4USIg
	 CEyvF5qsYHZtFMb4qX3E2pXHXDyZVV22mIjuqwO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0186/1815] perf vendor events amd: Update Zen 6 core events
Date: Sat, 12 Sep 2026 08:32:16 +0200
Message-ID: <20260912065653.375659104@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sandipan Das <sandipan.das@amd.com>

[ Upstream commit 6744430f106b0e46d6318d44a99cb27b0ee937ae ]

Update definitions for the following events.
  * PMCx00A - Fix descriptions
  * PMCx00C - Add missing unit masks
  * PMCx00D - Add missing unit masks and fix descriptions
  * PMCx013 - Fix incorrect unit masks

Fixes: 2f42fb0661d9 ("perf vendor events amd: Add Zen 6 core events")
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arch/x86/amdzen6/floating-point.json      | 34 ++++++++++++++++---
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/tools/perf/pmu-events/arch/x86/amdzen6/floating-point.json b/tools/perf/pmu-events/arch/x86/amdzen6/floating-point.json
index 03cb039434dee..71b883776f37b 100644
--- a/tools/perf/pmu-events/arch/x86/amdzen6/floating-point.json
+++ b/tools/perf/pmu-events/arch/x86/amdzen6/floating-point.json
@@ -212,7 +212,7 @@
   {
     "EventName": "fp_ops_ret_by_type.scalar_logical",
     "EventCode": "0x0a",
-    "BriefDescription": "Retired scalar floating-point move uops.",
+    "BriefDescription": "Retired scalar floating-point logical uops.",
     "UMask": "0x0d"
   },
   {
@@ -665,6 +665,12 @@
     "BriefDescription": "Retired 256-bit packed floating-point shuffle uops (may include instructions not necessarily thought of as including shuffles e.g. horizontal add, dot product, and certain MOV instructions).",
     "UMask": "0xb0"
   },
+  {
+    "EventName": "fp_pack_ops_ret.fp256_bfloat",
+    "EventCode": "0x0c",
+    "BriefDescription": "Retired 256-bit packed floating-point bfloat uops.",
+    "UMask": "0xc0"
+  },
   {
     "EventName": "fp_pack_ops_ret.fp256_logical",
     "EventCode": "0x0c",
@@ -758,7 +764,7 @@
   {
     "EventName": "fp_pack_int_ops_ret.int128_vnni",
     "EventCode": "0x0d",
-    "BriefDescription": "Retired 128-bit packed integer VNNI ops.",
+    "BriefDescription": "Retired 128-bit packed integer VNNI uops.",
     "UMask": "0x0c"
   },
   {
@@ -803,12 +809,30 @@
     "BriefDescription": "Retired 256-bit packed integer multiply-accumulate uops.",
     "UMask": "0x40"
   },
+  {
+    "EventName": "fp_pack_int_ops_ret.int256_aes",
+    "EventCode": "0x0d",
+    "BriefDescription": "Retired 256-bit packed integer AES uops.",
+    "UMask": "0x50"
+  },
+  {
+    "EventName": "fp_pack_int_ops_ret.int256_sha",
+    "EventCode": "0x0d",
+    "BriefDescription": "Retired 256-bit packed integer SHA uops.",
+    "UMask": "0x60"
+  },
   {
     "EventName": "fp_pack_int_ops_ret.int256_cmp",
     "EventCode": "0x0d",
     "BriefDescription": "Retired 256-bit packed integer compare uops.",
     "UMask": "0x70"
   },
+  {
+    "EventName": "fp_pack_int_ops_ret.int256_cvt",
+    "EventCode": "0x0d",
+    "BriefDescription": "Retired 256-bit packed integer convert or pack uops.",
+    "UMask": "0x80"
+  },
   {
     "EventName": "fp_pack_int_ops_ret.int256_shift",
     "EventCode": "0x0d",
@@ -1083,19 +1107,19 @@
     "EventName": "fp_nsq_read_stalls.fp_prf",
     "EventCode": "0x13",
     "BriefDescription": "Cycles when reads of the NSQ and writes to the floating-point or SIMD schedulers are stalled due to insufficient free physical register file (FP-PRF) entries.",
-    "UMask": "0x0e"
+    "UMask": "0x02"
   },
   {
     "EventName": "fp_nsq_read_stalls.k_prf",
     "EventCode": "0x13",
     "BriefDescription": "Cycles when reads of the NSQ and writes to the floating-point or SIMD schedulers are stalled due to insufficient free mask physical register file (K-PRF) entries.",
-    "UMask": "0x0e"
+    "UMask": "0x04"
   },
   {
     "EventName": "fp_nsq_read_stalls.fp_sq",
     "EventCode": "0x13",
     "BriefDescription": "Cycles when reads of the NSQ and writes to the floating-point or SIMD schedulers are stalled due to insufficient free scheduler entries.",
-    "UMask": "0x0e"
+    "UMask": "0x08"
   },
   {
     "EventName": "fp_nsq_read_stalls.all",
-- 
2.53.0



