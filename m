Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4B52FD7C3;
	Sat, 12 Sep 2026 13:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220729; cv=none; b=IBPRG0rUgVXZQCJN+XVEcPD8qf62BC0SAif6n8IzXzvYU3Hqqx+PbRyfBHl3+d7+E/FhfN01Suh7edBXzISCk0Cz0AOMzBaqsXC154zRJPiP6nj/bpV1brJA0Oqw/gVbb0DQSg23detVmYcwU7H1jlwzPDLOCYjCTOlamXrlbMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220729; c=relaxed/simple;
	bh=Tnr29aYo9JNgGZYShIfLLOHakiS20P7kwQf6oR/1mVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rax7Dsah4ICrVbHbiQ+A97B8el4PaSOpW4JvF5Ehd8jT5+MTlHWQV8N7/lH9DHi0kaDDzuMYNNCWbzm93sBGGz90YwO83H3TRk6BJYIXZmZ/1OaK9PM64xohjvCfZYmDi1SvwRyJIFpFoyOi0yMtrcSSiu3iczfhq6vmbuRgg18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ib0Mjb7v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ib0Mjb7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189CA1F000FF;
	Sat, 12 Sep 2026 13:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220728;
	bh=4Ew1W1qzeBU9WxTDRsS6UX2dIMW2ifLZMjEBHzdzqxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ib0Mjb7vexGh7AJSR5VxkSDBrrQTRM53iMyxFYKus711nj1HvxegePHu+OrztsU2v
	 UcUM6Yqvi78Bx765peNV8Ei0lwt/5AwBcVhbDdxivSyvOD8tmZUdtMgh+I3gT1wWej
	 pKUgy8HcjiGNcePlEpKQSOJ4epCM4e4TV9D5eoOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 0236/1424] platform/x86: ISST: Just allow 2 bits for SST feature enable
Date: Sat, 12 Sep 2026 08:44:28 +0200
Message-ID: <20260912065612.566760006@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 0f377f2b47646abe6ec3616ae6a8670d9ff7eb86 upstream.

Currently only 2 features SST-TF and SST-BF are supported, so only allow
bit 0 and bit 1.

Fixes: ea009e4769fa3 ("platform/x86: ISST: Add SST-PP support via TPMI")
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260811221514.3905817-7-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -686,6 +686,7 @@ static long isst_if_clos_assoc(void __us
 
 #define SST_PP_FEATURE_STATE_START	8
 #define SST_PP_FEATURE_STATE_WIDTH	8
+#define SST_PP_FEATURE_STATE_VALID_MASK	GENMASK(1, 0)
 
 #define SST_BF_FEATURE_SUPPORTED_START	12
 #define SST_BF_FEATURE_SUPPORTED_WIDTH	1
@@ -806,6 +807,9 @@ static int isst_if_set_perf_feature(void
 	if (!power_domain_info)
 		return -EINVAL;
 
+	if (perf_feature.feature & ~SST_PP_FEATURE_STATE_VALID_MASK)
+		return -EINVAL;
+
 	_write_pp_info("perf_feature", perf_feature.feature, SST_PP_CONTROL_OFFSET,
 		       SST_PP_FEATURE_STATE_START, SST_PP_FEATURE_STATE_WIDTH,
 		       SST_MUL_FACTOR_NONE)


