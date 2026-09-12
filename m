Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84703386C21;
	Sat, 12 Sep 2026 12:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215061; cv=none; b=HWBSHHFLbxFRaJ1FwxEBNykLV+BJOXXaJkzvqcMG3fvzT5LwQRFpb1Y+/UVYWDWUJYyHOdvEGgpfseRz6moXaC4yhC7Nyg9ErOhYq7696d+o3u8YBXNO3LQ7ZRcAM3VFpEDQeNLs1M9jRb6S0T/X+qLbuw/GeHNuH26zFx356yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215061; c=relaxed/simple;
	bh=a4Jss6wPozHTJXveJNxsYR9OjLdMmjJY/Rx/EBlcNPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KU37ixT68GrU90QP7+azLpiy/6HochRWR/Hqf7M+Lm6De4trePnV+wf9uZ1a4fOvFUQKKHB4kMDZCybYWTwMZjpBwnj+PkPXrsK/oeQH/Z12acQhuR8zRQiV2uIouIfFUvMHs3QcgVGO1o/QXt3iQRzA/znlpCy1FNRXNHn89BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X59yxzyv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X59yxzyv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD8E1F000FF;
	Sat, 12 Sep 2026 12:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215060;
	bh=u1gZT+UUpUK2B64RT+1NYuvc1mWPOvFX41VqkBwaJ+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X59yxzyvSmz/dNK6l7Ag0T0xRAqu5Qkh7rvg0IFMBa4x17Bsr0Zmj+uwIHByB97sX
	 x2IEcuFklWbTMhut8JnVYWYzM61Q2fIFcqHjrdTFUWzGOZmsUT8b4d0ZVn4VflE7QA
	 W3j4TsxWHw666JCFfHw20zT+rUMSEmOmV9JmDI0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0453/1376] perf vendor events amd: Reintroduce deprecated Zen 5 core events
Date: Sat, 12 Sep 2026 08:47:59 +0200
Message-ID: <20260912065617.630006896@linuxfoundation.org>
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

[ Upstream commit eda39f98bbc5ce8b7b0be10193d2de38ed59da6c ]

Maintain backward compatibility by reintroducing the events that were
previously removed by commit 047979af3bf6 ("perf vendor events amd:
Update Zen 5 core events"). Also set the deprecated flag and update
the descriptions to point users to the correct alternative.

Reported-by: Ian Rogers <irogers@google.com>
Closes: https://lore.kernel.org/all/CAP-5=fV_czvd-z4N7K+_SabxuOm9UUHRyBxNuchrtAgJL3OqOw@mail.gmail.com/
Fixes: 047979af3bf6 ("perf vendor events amd: Update Zen 5 core events")
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arch/x86/amdzen5/floating-point.json      | 42 +++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/tools/perf/pmu-events/arch/x86/amdzen5/floating-point.json b/tools/perf/pmu-events/arch/x86/amdzen5/floating-point.json
index 569975b53cc33..50d38434f8d3d 100644
--- a/tools/perf/pmu-events/arch/x86/amdzen5/floating-point.json
+++ b/tools/perf/pmu-events/arch/x86/amdzen5/floating-point.json
@@ -383,6 +383,13 @@
     "BriefDescription": "Retired MMX integer VNNI ops.",
     "UMask": "0x0c"
   },
+  {
+    "EventName": "sse_avx_ops_retired.mmx_pack",
+    "EventCode": "0x0b",
+    "BriefDescription": "This event is deprecated. Refer to new event sse_avx_ops_retired.mmx_vnni",
+    "Deprecated": "1",
+    "UMask": "0x0c"
+  },
   {
     "EventName": "sse_avx_ops_retired.mmx_logical",
     "EventCode": "0x0b",
@@ -449,6 +456,13 @@
     "BriefDescription": "Retired SSE and AVX integer convert or pack ops.",
     "UMask": "0x80"
   },
+  {
+    "EventName": "sse_avx_ops_retired.sse_avx_clm",
+    "EventCode": "0x0b",
+    "BriefDescription": "This event is deprecated. Refer to new event sse_avx_ops_retired.sse_avx_cvt",
+    "Deprecated": "1",
+    "UMask": "0x80"
+  },
   {
     "EventName": "sse_avx_ops_retired.sse_avx_shift",
     "EventCode": "0x0b",
@@ -473,6 +487,13 @@
     "BriefDescription": "Retired SSE and AVX integer VNNI ops.",
     "UMask": "0xc0"
   },
+  {
+    "EventName": "sse_avx_ops_retired.sse_avx_pack",
+    "EventCode": "0x0b",
+    "BriefDescription": "This event is deprecated. Refer to new event sse_avx_ops_retired.sse_avx_vnni",
+    "Deprecated": "1",
+    "UMask": "0xc0"
+  },
   {
     "EventName": "sse_avx_ops_retired.sse_avx_logical",
     "EventCode": "0x0b",
@@ -731,6 +752,13 @@
     "BriefDescription": "Retired 128-bit packed integer convert or pack ops.",
     "UMask": "0x08"
   },
+  {
+    "EventName": "packed_int_op_type.int128_clm",
+    "EventCode": "0x0d",
+    "BriefDescription": "This event is deprecated. Refer to new event packed_int_op_type.int128_cvt",
+    "Deprecated": "1",
+    "UMask": "0x08"
+  },
   {
     "EventName": "packed_int_op_type.int128_shift",
     "EventCode": "0x0d",
@@ -755,6 +783,13 @@
     "BriefDescription": "Retired 128-bit packed integer VNNI ops.",
     "UMask": "0x0c"
   },
+  {
+    "EventName": "packed_int_op_type.int128_pack",
+    "EventCode": "0x0d",
+    "BriefDescription": "This event is deprecated. Refer to new event packed_int_op_type.int128_vnni",
+    "Deprecated": "1",
+    "UMask": "0x0c"
+  },
   {
     "EventName": "packed_int_op_type.int128_logical",
     "EventCode": "0x0d",
@@ -845,6 +880,13 @@
     "BriefDescription": "Retired 256-bit packed integer VNNI ops.",
     "UMask": "0xc0"
   },
+  {
+    "EventName": "packed_int_op_type.int256_pack",
+    "EventCode": "0x0d",
+    "BriefDescription": "This event is deprecated. Refer to new event packed_int_op_type.int256_vnni",
+    "Deprecated": "1",
+    "UMask": "0xc0"
+  },
   {
     "EventName": "packed_int_op_type.int256_logical",
     "EventCode": "0x0d",
-- 
2.53.0



