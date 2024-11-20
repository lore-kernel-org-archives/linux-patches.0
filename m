Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82FC81AB6C3;
	Wed, 20 Nov 2024 12:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107565; cv=none; b=BnQQBgHpYJafOCd8zMWA++ALV5YOdE40FVCpDDE38BeqH+eDsomcHNfVRe2brShEkzS2gDsgr/1drVKvrm92LFHEZHEyFFY1gM8Cs/p3o5HHuQMWrXkYuj++74BUBRJ6dIcZlRjtsWw7oINj5VU4q2PTELJU6jyBegIHErf1jKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107565; c=relaxed/simple;
	bh=GNosdIyCgzUKjlDpI8OnrIJMcAWAvhXDN9jd1EoUGA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dy3i1uRixacRz38BDo4z/Cu/SS/tWB/Tw2tDjaGLNCfO1ifCd0avF0VQAx6kGkxMjOnhNmC6roArRusZ14guITtZZXw9jqOFqYFxSPU2TNpX2VC+whUNuRnxD0kSPmwYhCBC5mipj9VUsH8ive4+c83yh+0CgqA9FccdbChnBrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Go10IHtE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Go10IHtE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5963BC4CED8;
	Wed, 20 Nov 2024 12:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107565;
	bh=GNosdIyCgzUKjlDpI8OnrIJMcAWAvhXDN9jd1EoUGA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Go10IHtEZ+GjC0ByZGmqS9CxaGP9Qss3RVuDjBv72vu431KKcX0NQi9Pus/O+Gs07
	 VR33n7hEI5EcDJmmm2TNnRimXby4A88GXdm4cW3/OdjRfxJ0rjYfOGotaaQ+4Vv/m0
	 uXyri39RkAWKcW6NGRULbyS3LxBuofp87d7532ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Sibi Sankar <quic_sibis@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.11 079/107] mailbox: qcom-cpucp: Mark the irq with IRQF_NO_SUSPEND flag
Date: Wed, 20 Nov 2024 13:56:54 +0100
Message-ID: <20241120125631.465209485@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sibi Sankar <quic_sibis@quicinc.com>

commit d2fab3fc27cbca7ba65c539a2c5fc7f941231983 upstream.

The qcom-cpucp mailbox irq is expected to function during suspend-resume
cycle particularly when the scmi cpufreq driver can query the current
frequency using the get_level message after the cpus are brought up during
resume. Hence mark the irq with IRQF_NO_SUSPEND flag to fix the do_xfer
failures we see during resume.

Err Logs:
arm-scmi firmware:scmi: timed out in resp(caller:do_xfer+0x164/0x568)
cpufreq: cpufreq_online: ->get() failed

Reported-by: Johan Hovold <johan+linaro@kernel.org>
Closes: https://lore.kernel.org/lkml/ZtgFj1y5ggipgEOS@hovoldconsulting.com/
Fixes: 0e2a9a03106c ("mailbox: Add support for QTI CPUCP mailbox controller")
Signed-off-by: Sibi Sankar <quic_sibis@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Cc: stable@vger.kernel.org
Message-ID: <20241030125512.2884761-7-quic_sibis@quicinc.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mailbox/qcom-cpucp-mbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/qcom-cpucp-mbox.c b/drivers/mailbox/qcom-cpucp-mbox.c
index e5437c294803..44f4ed15f818 100644
--- a/drivers/mailbox/qcom-cpucp-mbox.c
+++ b/drivers/mailbox/qcom-cpucp-mbox.c
@@ -138,7 +138,7 @@ static int qcom_cpucp_mbox_probe(struct platform_device *pdev)
 		return irq;
 
 	ret = devm_request_irq(dev, irq, qcom_cpucp_mbox_irq_fn,
-			       IRQF_TRIGGER_HIGH, "apss_cpucp_mbox", cpucp);
+			       IRQF_TRIGGER_HIGH | IRQF_NO_SUSPEND, "apss_cpucp_mbox", cpucp);
 	if (ret < 0)
 		return dev_err_probe(dev, ret, "Failed to register irq: %d\n", irq);
 
-- 
2.47.0



