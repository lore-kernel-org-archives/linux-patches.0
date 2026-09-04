Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148A537DAD0;
	Fri,  4 Sep 2026 05:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499829; cv=none; b=PasLFgIBFUm7+8urSdS/eGQc8k4F0eJjka0QX18QiLzRsQ/MsS/sC3s6rTickRNetLqcCFNffQs1Uzca9vMHD4c+TlAI80SgNgWswDumh/qEcCokdwIxSLE3h6b+ELPI/rtByebK2VkubnzADYUYViPSyo7U3YHrz7md0dpwprA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499829; c=relaxed/simple;
	bh=mvAOH4UkAY3j6kLpax+ZWNJDAU+pRDjWPrGVtfS10u4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ay1Z2cOiP2I7eTMpNZgrpIYXD3jlvaJZkVwHua7zHc0cq2f5jpgkO91U1LOGLYPDpQBPa00coR1Ng01p8KumhfSTz7HhPBLbM3Qo2jNPwj8Veqjzx+GgRGRj2wOLGL11507OfXshfflFLIxQP5x/2ytKNSUVG0xwd2nNHWeN1+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2PH//7j9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2PH//7j9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0841F00A3E;
	Fri,  4 Sep 2026 05:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499828;
	bh=qS/5qmnsbA3SyVr9xj1Tid/XeH9lux/Cvie3Mf4jRLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2PH//7j9TFs3wdWIYF+oN0WJm3uU+35taEP5k9tQCzfESaLSTGFG5tK6rhMwuL6a7
	 +I+6EgdOrSOxKm4aGWsPYC495FmzHSpYO3rywtal5xw6wcE6zwZmoKp+wP091bpym0
	 O/wSB02rW+Zg6j9DIDrDpd8xtgLteU+CAPaa+g0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 7.2 556/713] platform/x86: ISST: Just allow 2 bits for SST feature enable
Date: Fri,  4 Sep 2026 06:58:44 +0200
Message-ID: <20260904045816.283603250@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -847,6 +847,7 @@ static long isst_if_clos_assoc(void __us
 
 #define SST_PP_FEATURE_STATE_START	8
 #define SST_PP_FEATURE_STATE_WIDTH	8
+#define SST_PP_FEATURE_STATE_VALID_MASK	GENMASK(1, 0)
 
 #define SST_BF_FEATURE_SUPPORTED_START	12
 #define SST_BF_FEATURE_SUPPORTED_WIDTH	1
@@ -997,6 +998,9 @@ static int isst_if_set_perf_feature(void
 	if (power_domain_info->write_blocked || !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	if (perf_feature.feature & ~SST_PP_FEATURE_STATE_VALID_MASK)
+		return -EINVAL;
+
 	_write_pp_info("perf_feature", perf_feature.feature, SST_PP_CONTROL_OFFSET,
 		       SST_PP_FEATURE_STATE_START, SST_PP_FEATURE_STATE_WIDTH,
 		       SST_MUL_FACTOR_NONE)


