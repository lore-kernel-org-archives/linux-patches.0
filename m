Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625337;
	b=OxiCgb65xcv5ZVB6FzTBVpYJPtc/ZtBr6yr6KxReVOC28nJOo5nxBlnRaLw6Ly+UXfME
	 NtuLitizboPkpdETlvtI3nFJCWefq+ChHkqqWdMn8PaZcGUYMKQGWL0IxYSjUbtHIMMPT
	 yWy5KzJFsQSsUeokfaPIpv/wa5engTigcu2LM9SGNRD5LbPG9l5vTNmRMB+fiGyQTTaDf
	 JhgyMeHyRKinVnXpaek1S0K8qlrag50aKs7jHs4eeoCu2aHIRKHP+baTKGfb2lNx2tlOh
	 20HEBbI90Txs+a27AuznF0NpC+zBwj5FJqpiFX8u43I0YREwnognoM0QroYWlMwVyUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625337;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=04UwIaiak5C7ii8Wyn97xXwP05PBJ6/KxK4RHx+DeZc=;
	b=Rd1lbFb9WvzQv2gPfVVQw2174d4NHUSUef13NgEyMzfOmVf2OWbXJk/G/UkBn1s1zDm4
	 aSYrhZFAxA43mrdYfoTXNO4+p0A2Hye9vvGLkhc/MKA5doVmH0vFODV/cDRzirDvsaLxt
	 PNkOfZ3ELcO8Pu92FQWlXkkvhOo5Pnh61zl5bhSu+mJMlbx9t3lZHqee9nv4bku7M2u9x
	 NifOSoioodJArLJeqZwYp6yXkQX5WrPk+Zw6EcwWtg2JfktZEsqyNZhFydOFUuH5Kwrch
	 TjT+OMBF3jt0TqoIY06eJxFmneFlqcvgeCN/T2gC8BGJ8SaJJ6Cd2c45nIrQlkQ6Hlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vsmyu+ZY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BE9606A323;
	Wed, 25 Nov 2026 16:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vsmyu+ZY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545231F000C4;
	Wed, 25 Nov 2026 16:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625336;
	bh=04UwIaiak5C7ii8Wyn97xXwP05PBJ6/KxK4RHx+DeZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vsmyu+ZYD0YPk9ci/EyIxdH0iE87H4/FGy/xT4hF1tD1dYjm1Hpj53B18KPt0Tsn2
	 CoO4DV6SWFUMOxoaQP0v3h3Qke/P8FTkXhOnTEJs2MJ5jHIEdbIzD1Q6F95T5/MT7i
	 FoM2fWqL8Y7/va3vsceTFLah74DqJZ5J6Zn7O6lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 483/816] mailbox: qcom-ipcc: Remove redundant mbox_controller_unregister() on probe failure
Date: Wed, 25 Nov 2026 15:33:51 +0100
Message-ID: <20261125143900.374830937@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>

[ Upstream commit da988ac6afe152f802140ccaa0ad5e8f675b8814 ]

qcom_ipcc_probe() registers the mailbox controller via
devm_mbox_controller_register(), which automatically calls
mbox_controller_unregister() through devres when the device is removed
or probe fails. If devm_request_irq() subsequently fails, the
err_req_irq: label also manually calls mbox_controller_unregister(),
resulting in a double call that corrupts the global mailbox controller
list and causes a kernel panic.

Remove the redundant manual call and rely on devres for cleanup.

Fixes: e9d50e4b4d04 ("mailbox: qcom-ipcc: Dynamic alloc for channel arrangement")
Signed-off-by: Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>
Reviewed-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
[ sashal: Adjusted context to keep the existing braces and dev_err() around the goto in qcom_ipcc_probe(), which the upstream hunk lacked. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/qcom-ipcc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/mailbox/qcom-ipcc.c b/drivers/mailbox/qcom-ipcc.c
index c619dfb24cd0e..c37ce8258da71 100644
--- a/drivers/mailbox/qcom-ipcc.c
+++ b/drivers/mailbox/qcom-ipcc.c
@@ -321,16 +321,13 @@ static int qcom_ipcc_probe(struct platform_device *pdev)
 			       IRQF_NO_THREAD, name, ipcc);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to register the irq: %d\n", ret);
-		goto err_req_irq;
+		goto err_mbox;
 	}
 
 	platform_set_drvdata(pdev, ipcc);
 
 	return 0;
 
-err_req_irq:
-	if (ipcc->num_chans)
-		mbox_controller_unregister(&ipcc->mbox);
 err_mbox:
 	irq_domain_remove(ipcc->irq_domain);
 
-- 
2.53.0



