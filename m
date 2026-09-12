Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA33627EC7C;
	Sat, 12 Sep 2026 10:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208703; cv=none; b=NfZyjxps28vuTtWOF/7vqqlTSSNE62rMoKy4ZScxbl7SFGOzFXHfZp61YWw4TUbj26VgbRbBwa+C1UFCSOXwgtV/qm1fMswcdouNVHmJ8S1P84ObPJU8aSTxTW61vbDYNLVjZm8FA2eN5JYp8h3u7BKRx+IuEnfoowE7RnnSwbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208703; c=relaxed/simple;
	bh=Xe7ki832FN2fRw/Lnk3vYxKO7EpCXAsWbhJlW5TCLb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WoYnsqGTlQPgnUMZFIdm3s2t2CBKtWEQ0/kTgdrbNtCmGxo9xt+2fAbHYWrIHu39H1affVu9cB0kiqQYXojV3awuI7yNmfoxeVcdQcbK82tGvBdTt3u/MKHRq1zGmMRU3B882sKOnu/cbqCerv2mCwnwJQkUIdNIkbW76sPCC40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8oQYE2S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8oQYE2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF901F000FF;
	Sat, 12 Sep 2026 10:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208702;
	bh=sxSCzQspTaAHPiDpnp7CyTEdcM2Ir+2k+nTE9sfy3hU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d8oQYE2Sui3OQfvPZMKADaMWkKLvW9aVjUh1T+k1CXgVuY8paUELS2v9OkdctqgAs
	 ElaCMT6fLIcKqk7jM3MGVW7hiEH40Z+uYLLQadgp8n7VYiTVvGuNQ+SvJhOZNawjsH
	 TOBeRiwz9o+ZMcNU9LPhJaxMcBe2YBtoCDMqONVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Yuvaraj Ranganathan <yuvaraj.ranganathan@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0671/1518] firmware: qcom: scm: instrument SMC call path with tracepoints
Date: Sat, 12 Sep 2026 08:47:20 +0200
Message-ID: <20260912065638.614182134@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



