Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E07347C11A;
	Sat, 12 Sep 2026 12:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216566; cv=none; b=h0NdJL1u8gZHu/+cw/vSz9jrtbKvHaLhWvdCwDOyknkhsGavksgLHIWDbYz6nn2Yw5G5rNrkKak3KSSe0N0P79oOTc1KnrSoTRc7t3tW/YOceFd+wQQtAvOu13krp6lb+rCtysjQz6m0/Yy3yWQjW6EovEDdvqKe30Z2ZUoNM+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216566; c=relaxed/simple;
	bh=BSQAhnJl0ir5WdxhWbrNPV02l4m//24s+tZpcLenWN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hY6G69/KeI/6akaH9FkjHDtKxjTf40ScrGUZj6/LYZjR36o9fD/KvG5G5GyvSIbvK2ioh6celnr/qCW1lA9NhU+NlXcXPh3itLkfE4QpqDZjgBXhM1dhtjKu17OSDn6yZ0QqbcaL7Zf72NpcsC9aAXdsC1CYx4kti+U+IT48Ucg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PivP+DQZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PivP+DQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B9E1F000FF;
	Sat, 12 Sep 2026 12:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216564;
	bh=S52tyh3kY4fIBcaPUC0Ld37AX6h2wnOxL1wLFKLfa0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PivP+DQZiDAfUQbeEZUxMQ8xTri9zhUJ2IZ5Pt4a/qymeNrbungPf4ZE17oerbyZ+
	 rH7kHJWY7ArDvohjbGPPENw1AcE4A8sGAxqnhMjueJ9P8M2Qcjb8zjdpcWfREoyF4Y
	 vmhA37MIYIW44bhUNaAVIXPBnR+0Lw+d66cHLVoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Yuvaraj Ranganathan <yuvaraj.ranganathan@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0762/1376] firmware: qcom: scm: instrument SMC call path with tracepoints
Date: Sat, 12 Sep 2026 08:53:08 +0200
Message-ID: <20260912065624.523706452@linuxfoundation.org>
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
index 3f10b23ec941b..56fe0d4f0c623 100644
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
@@ -200,6 +207,9 @@ int __scm_smc_call(struct device *dev, const struct qcom_scm_desc *desc,
 	}
 
 	ret = __scm_smc_do(dev, &smc, &smc_res, atomic);
+
+	trace_scm_smc_done(ret, smc.args[0], &smc_res);
+
 	if (ret)
 		return ret;
 
-- 
2.53.0



