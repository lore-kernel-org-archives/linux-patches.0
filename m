Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1247A367B60;
	Sat, 12 Sep 2026 07:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198142; cv=none; b=BtE7kWGrUQ+hpdbdUdWy4PXiQk2P3XL9dWOZts/OWdX8r/Qi1HFIGydXUqVLU4qV49gCmp2giK1iZoBEl1WBJEbyyiGsdhIvjoa9jUVM3lDXyqD9Jc+EkW5zTQi9mK0ZEErTyjUdAsqYmzsvnJD0nTR42wzGjieZXVL53Xg1U3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198142; c=relaxed/simple;
	bh=W6Qs52Z88fwhAUB1I8GkHmAMiMu2IWsa890rfz0Bay8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fq6VxFQKCK8sIlgOmRqLbN2pe+tAySkTWVOae6v3pE62XSdE5Ku36KQh11NxBcAynrdcJfBJqBH+C+86j4Ny3FNDlsro4kYoQXlMFqEAdVJUiwfmfytgbHS/pLhkx5ig1ivKhd8wBzdG8e3y3tJ73oRy+Hy7Bm4/TzXSQNuI3uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZY8GkIw/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZY8GkIw/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2F01F000FF;
	Sat, 12 Sep 2026 07:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198140;
	bh=ZRoJ5Qr1VdJgzMa7OzO+3xSbp2S3v84y5ZyPWnwhOLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZY8GkIw/Rmd5o4k9wllINbapnnasPKjt4/rv10JNNqUJPnJYNBDcDnhfCgLorRwd6
	 cFaOFwmhznSbfSfFB/V0oV3e6P9f/E6jjy7szesXSvn07Cnnc/68yIk6UcdAtHamvO
	 rLTsYpMi9WGNdqVstmVx9QKZaFWxpe4qysELvAvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0277/1815] perf vendor events amd: Reintroduce deprecated Zen 5 core events
Date: Sat, 12 Sep 2026 08:33:47 +0200
Message-ID: <20260912065655.468427898@linuxfoundation.org>
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



