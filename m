Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E98E36BCDE;
	Sat, 12 Sep 2026 08:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200426; cv=none; b=r3xbzsy0H+UmjAG/B60D9a5bVlIczFrcpxwKfJyh4ZJj5Vr6ad4UaK5Ef9dOGaVZDHWZLbkn3EHbCw9dLqNoRcWPt8agFfXrHPLxSf4VVapbdi7gnZmzpDsh1HkixMYAz5k9A5F10v6GvxVFZyoup+bitx/GMY4CGkUyMd5TP/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200426; c=relaxed/simple;
	bh=g2BxVNHhlrmsoMNtFBwnUPPoqgw9PssI6pqGhsSxuKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4NXb/nEIXWP1lwouXCmIMux5N7VjphXnfe72ln4QIJPXIpp9gbBpzVI5q/Sbg/6aOSuMSZ7iS7I9wVRwDNaKf3L/tuhAsUYuC8USTezSBic3OAC3B2rxmN8AWGEn0ZqiwFxP+rtZI8yoJZABIoy6h3nJJW1bXSCjr0Dbz7UHWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ghv0x40h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ghv0x40h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 474DC1F000FF;
	Sat, 12 Sep 2026 08:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200423;
	bh=oTRQBY4nQozthEHvNceO3ss/hNx2fcc60Jq2H7k0fAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ghv0x40h7KahIZDoDRlj1qOvtZNNEjYBkh5Ei8gzRft1nVEMq+Btn9awEDv6rlwzK
	 l7BZMLkkpMynF3qT/hiz82zzRANflqDK1GCSKe9K/K76jX7VLaZrw0SuZbE4HYfb2q
	 LNDEHH45nrHPq7IRqxHoi93mcy+KpMIzVblpludg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Yuvaraj Ranganathan <yuvaraj.ranganathan@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0788/1815] firmware: qcom: scm: instrument SMC call path with tracepoints
Date: Sat, 12 Sep 2026 08:42:18 +0200
Message-ID: <20260912065707.406509576@linuxfoundation.org>
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

From: Yuvaraj Ranganathan <yuvaraj.ranganathan@oss.qualcomm.com>

[ Upstream commit 41329e72363c02facfeae063ef304aa7ced68c3b ]

Wire the five tracepoints defined in qcom_scm_trace.h into the SMC
execution path by including the header with CREATE_TRACE_POINTS.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Yuvaraj Ranganathan <yuvaraj.ranganathan@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260522-scm-tracepoints-v2-2-e27cdbe0c585@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 966d23c7e68e ("firmware: qcom: scm: Fix NULL dereference in IRQ handler before __scm is published")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom/Makefile       |  1 +
 drivers/firmware/qcom/qcom_scm-smc.c | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/firmware/qcom/Makefile b/drivers/firmware/qcom/Makefile
index 0be40a1abc13c..b679d3fc2c267 100644
--- a/drivers/firmware/qcom/Makefile
+++ b/drivers/firmware/qcom/Makefile
@@ -5,6 +5,7 @@
 
 obj-$(CONFIG_QCOM_SCM)		+= qcom-scm.o
 qcom-scm-objs += qcom_scm.o qcom_scm-smc.o qcom_scm-legacy.o
+CFLAGS_qcom_scm-smc.o := -I$(src)
 obj-$(CONFIG_QCOM_TZMEM)	+= qcom_tzmem.o
 obj-$(CONFIG_QCOM_QSEECOM)	+= qcom_qseecom.o
 obj-$(CONFIG_QCOM_QSEECOM_UEFISECAPP) += qcom_qseecom_uefisecapp.o
diff --git a/drivers/firmware/qcom/qcom_scm-smc.c b/drivers/firmware/qcom/qcom_scm-smc.c
index 574930729ddd7..01999c22659cb 100644
--- a/drivers/firmware/qcom/qcom_scm-smc.c
+++ b/drivers/firmware/qcom/qcom_scm-smc.c
@@ -24,6 +24,9 @@ struct arm_smccc_args {
 	unsigned long args[8];
 };
 
+#define CREATE_TRACE_POINTS
+#include "qcom_scm_trace.h"
+
 static DEFINE_MUTEX(qcom_scm_lock);
 
 #define QCOM_SCM_EBUSY_WAIT_MS 30
@@ -44,6 +47,7 @@ static void __scm_smc_do_quirk(const struct arm_smccc_args *smc,
 	quirk.state.a6 = 0;
 
 	do {
+		trace_scm_smc_request(a0, smc);
 		arm_smccc_smc_quirk(a0, smc->args[1], smc->args[2],
 				    smc->args[3], smc->args[4], smc->args[5],
 				    quirk.state.a6, smc->args[7], res, &quirk);
@@ -83,6 +87,7 @@ int scm_get_wq_ctx(u32 *wq_ctx, u32 *flags, u32 *more_pending)
 	if (ret)
 		return ret;
 
+	trace_scm_waitq_get_wq_ctx(get_wq_res.a1, get_wq_res.a2, get_wq_res.a3);
 	*wq_ctx = get_wq_res.a1;
 	*flags  = get_wq_res.a2;
 	*more_pending = get_wq_res.a3;
@@ -105,10 +110,12 @@ static int __scm_smc_do_quirk_handle_waitq(struct device *dev, struct arm_smccc_
 			wq_ctx = res->a1;
 			smc_call_ctx = res->a2;
 
+			trace_scm_waitq_sleep(wq_ctx, smc_call_ctx);
 			ret = qcom_scm_wait_for_wq_completion(wq_ctx);
 			if (ret)
 				return ret;
 
+			trace_scm_waitq_resume(smc_call_ctx);
 			fill_wq_resume_args(&resume, smc_call_ctx);
 			smc = &resume;
 		}
@@ -201,6 +208,9 @@ int __scm_smc_call(struct device *dev, const struct qcom_scm_desc *desc,
 	}
 
 	ret = __scm_smc_do(dev, &smc, &smc_res, atomic);
+
+	trace_scm_smc_done(ret, smc.args[0], &smc_res);
+
 	if (ret)
 		return ret;
 
-- 
2.53.0



