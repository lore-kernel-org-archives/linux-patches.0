Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026130;
	b=GRGchvMMeeLmCURvEUz/nL1yyp4PsGPeCHZR8A2HE5Cr5n3uNl7sxO98XT4rYYEvq765
	 3FjVNV5GoEobbnoDi8viXijSE3lAqWyCqAUB4Imn/InTngbLQZJFzq7nG7YGDkKIHgs6I
	 ESeCO7tX20EW3oEz+khKZjG9bST1s2y6jbmW7Y/OxtmgI9hW2nwPcqMGk3pckd2ufdG2K
	 r1C4MD3qvgWTuWkN30EcDDP0HSfRCgMgtje93tTDU/jfIS75ApChPmrYdYH9f1uzv9alv
	 e3s13OYLdYzBEXnnQ+12D9+QFAJ2Zw3DzyYG20rTg+qkMIXzViN8Ib2Q1vkEDch5tYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sQubHeJy+Ju++IQPJ928oM6Wov2QK2TkH5/UecJC41M=;
	b=0WamzWL+TP9qhRAC1WzpR7Ns+7TFSwhDFhZ+x0O6UWsvalFkzxdrgD4ATZ2attOONKZH
	 06q2RWEnZnoeJnPlK2JLRpsKhXYzS1H0kKI+0SwXY3wI97aATvKzDaWqJsWrO2ps3JRg8
	 uDsJCerWXcyKZw+4v3Hv6xN4N0onzKhjH0HQLn/gFmTREPIAxeSXVRL4KPn3vkJI3w3F8
	 jDpQOnUFSwUrPTaMcOpP6Z6Ew+3Jj9HC1xJFnuYfU5d3l29vvpHMuYBesvXM3xzvPXxwz
	 Rlg5qjufZqp2xVFPSvcFZToIrgjAovJ6+Juhujy9I2vDUakIrxnXWsYwyCVYCgrslwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XQXeRcnP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FF0606A320;
	Wed, 18 Nov 2026 18:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XQXeRcnP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02801F000C5;
	Wed, 18 Nov 2026 18:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026130;
	bh=sQubHeJy+Ju++IQPJ928oM6Wov2QK2TkH5/UecJC41M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XQXeRcnPy3bCtq0WJZdhv4q76zZJzKevCigm/RwfMVUM9hB4OuslMYKp0eHr3HM5t
	 xTPzUj4ya5PI0uP/SyuPxeYZc1LzItC939PmaVSxDXYIRUl4AHHvYPkxxUe6WHEwBF
	 Z+DcqNilXL3SSMaNwYPeTo/KCkq8Di4ikXlT+jMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1324/2151] mailbox: qcom-ipcc: Remove redundant mbox_controller_unregister() on probe failure
Date: Wed, 18 Nov 2026 15:50:59 +0100
Message-ID: <20261118150210.313743247@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/qcom-ipcc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/mailbox/qcom-ipcc.c b/drivers/mailbox/qcom-ipcc.c
index 387aa72aeedf1..43985fe6816c2 100644
--- a/drivers/mailbox/qcom-ipcc.c
+++ b/drivers/mailbox/qcom-ipcc.c
@@ -335,15 +335,12 @@ static int qcom_ipcc_probe(struct platform_device *pdev)
 			       IRQF_TRIGGER_HIGH | IRQF_NO_SUSPEND |
 			       IRQF_NO_THREAD, name, ipcc);
 	if (ret < 0)
-		goto err_req_irq;
+		goto err_mbox;
 
 	platform_set_drvdata(pdev, ipcc);
 
 	return 0;
 
-err_req_irq:
-	if (ipcc->num_chans)
-		mbox_controller_unregister(&ipcc->mbox);
 err_mbox:
 	irq_domain_remove(ipcc->irq_domain);
 
-- 
2.53.0



