Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D9118D636;
	Fri,  4 Sep 2026 05:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501465; cv=none; b=PHF54VYMsotwQbHchnA26/0qtDB7IH+QOS/apxgVeElaJsQe4z3IyY3Ej5C/7Zg5nJCvDyBPmCJv/dpa5g/2arB6mOtSiNF5oAlUUQhI1t9dl31L7LuKP0+CSkTMUocf1oYQJ6U8pBRibLvMssSQtZQhALM1fbMR2X6PzReJMMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501465; c=relaxed/simple;
	bh=neyHnX2UlKjaDVcR9PYHtI3hc21b727LfvfzpMCzU14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G1pFo8DpStbc0a8C0uAhkpMSqD50UeCsOrk8PfcYfw1was/JRjZ+IQBCH0kVMSBPMT9gYfTwbp7yS0jCOfNb06s/ITTjEMB6j3OfKfiDwZXbJiHl/gGwGpc1a80mPOsG4MxPXocj++7I75ODCDzyPrRclSkWTOwt4S66IOEZX7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oBMa82DP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oBMa82DP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA011F00A3D;
	Fri,  4 Sep 2026 05:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501463;
	bh=vD290Ck2Yauuoa78OQa6FN1OA6lW7HjiZNtKvSv7fJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oBMa82DPTZbxPFXSullXR23VTprr78YHki8QgPmoYuozm+B5Dhw5OqUfjdUovBXNJ
	 RFOwMDdumpGLHcUBo8NLaRVrUufjRSpvUjHvMpxZEiPu7qeZVMvZEFT3GOR/CeKhZs
	 I9nZDJO7D0T2GywRVOA16iWBPUXcA94Qhl1ebOSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 419/552] platform/x86: ISST: Just allow 2 bits for SST feature enable
Date: Fri,  4 Sep 2026 06:59:36 +0200
Message-ID: <20260904045800.110488775@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -846,6 +846,7 @@ static long isst_if_clos_assoc(void __us
 
 #define SST_PP_FEATURE_STATE_START	8
 #define SST_PP_FEATURE_STATE_WIDTH	8
+#define SST_PP_FEATURE_STATE_VALID_MASK	GENMASK(1, 0)
 
 #define SST_BF_FEATURE_SUPPORTED_START	12
 #define SST_BF_FEATURE_SUPPORTED_WIDTH	1
@@ -996,6 +997,9 @@ static int isst_if_set_perf_feature(void
 	if (power_domain_info->write_blocked)
 		return -EPERM;
 
+	if (perf_feature.feature & ~SST_PP_FEATURE_STATE_VALID_MASK)
+		return -EINVAL;
+
 	_write_pp_info("perf_feature", perf_feature.feature, SST_PP_CONTROL_OFFSET,
 		       SST_PP_FEATURE_STATE_START, SST_PP_FEATURE_STATE_WIDTH,
 		       SST_MUL_FACTOR_NONE)


