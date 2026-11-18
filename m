Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019472;
	b=Z5maVof8jFtxXnxjJyS5Im1XJutwotkEIkyGLaZvkqyTWpt9lMjxQBMQl3kOk0jeOAOv
	 EwFQQ+7BWl/IoVS/8/znmwvBcjdN24X2URqufWxFLPi8jHWDUmuI8eHhn1lLNrBOUTNJU
	 ciH7zGv+Zjpo3hUPgKca3a8z3D7WoXoHig8Pe63vPxrLrIeLqNDyDC6FNg7e3habfyVP1
	 Pf2UzC5oWnTv0biGwvGVZpA8Yj3z2x0mFYhYC2MSt11OVse2WoH3LD4RWL7Z/lzqj46Sv
	 yzzuK+YBgxqcjDOZdOx7IoLEEE2mGGJE/uLdPoXVbR50XTkgHac+nBJYX3SYqlhoKkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019472;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lRUbxxIKFclvB8rH6s7YLyP69FX6nM5c2F3RigqJ3is=;
	b=47yYyn1WGearD5PbNFug2Qx70oWOIt86VZXKJyiutUgPhwa64pxw30AV5XjKRKPMwSJx
	 YhO+cbhDPr8i6RuTzkl5SiWCdGrDYpjcInW7uLyQ49uUT+5XPeOfx6M+OW/pe4gbvuwPS
	 ehQiPse2K6K/7N23ZYoC2hgK8fQs/32ylYrXRKR3sNvPbYwFMEnIAAzjEYIYpTU82ESDK
	 yq0mebVIT+JPwvLM8AJXldhMfuw2S8efw+tKw4EbnOgRpSBcjBCEUE8TGWZl7m0pLucxR
	 XNwea6zW+LUGuQq2aUvCWMmivbTxP/mpaOYx5WQtgBVHMnxOImGE+p82OYSYC7f0bkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zURFwSx7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489BE606A7C4;
	Wed, 18 Nov 2026 16:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zURFwSx7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41001F000C4;
	Wed, 18 Nov 2026 16:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019472;
	bh=lRUbxxIKFclvB8rH6s7YLyP69FX6nM5c2F3RigqJ3is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zURFwSx749jTlDq+uezdmeu84XDKSMNpMzzxUTBxvfEgZl/Dj3a/HWjNX3o5oo5KZ
	 YFGbMTchHS2D1c1H1BuM4GTJC1ZYpumZIc7uFQkz0uP9192+FNkGyNFKPelYQ2/Ol+
	 JAgarwXpXRD4X/2zvUMDoth8E1oCTyobdq2+hD9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1607/2651] mailbox: qcom-ipcc: Remove redundant mbox_controller_unregister() on probe failure
Date: Wed, 18 Nov 2026 15:47:27 +0100
Message-ID: <20261118150345.685483740@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



