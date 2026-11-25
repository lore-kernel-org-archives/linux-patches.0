Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625339;
	b=TV59o+fv2IMulSjLWAIk7A7BHxdt9qMeIxSpLSrDQH3ZDp6oxBYI8YLM9K4DxFtH7FaF
	 S6V8mGbTo51dJJqlp77+2+Zb8X2UPSxWLShkA5nhbiqkDhpZJ6iqVRHIRci4FfwvWHpew
	 lnhpAkIQVC3msGF4NRXp5vBXXeaCk2TC8oLVGturWJTNouFcwrn+ZNDJedOEQ12dRPEUJ
	 EPAE31vkWrggnV/7WwVo1PR7jXBS9rtnO6BcRWs13oDCQnipGZkSNJWgjKRy9A4oLMTxj
	 DitBCLZDGRqk6IqNtI9Qpb+menQxO4zOw++EKyXIiOWV9LeyAj6h2UFcQ5HfOnXeZVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625339;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e4ILsRMYSmX59dewfdSQpN3IXr0deZ8C6sd3I3ljjws=;
	b=F+fBxGAyzNicHMF/1vim2ZUMaX0KlQ1NO7lMhei6fvG/fgxmG+lOOOLKmLDvLG6qapIA
	 Tp9OLf+PWyXRXb3LHX4NNx4iLyq37wcPbU+EBCJDO4OoBT8YgfSR0Nv/BBG5qU17g2z3D
	 L8p4XS5yh/MY0j7gO6WHJ9YFGPty56cMo0cx0GrzqfMCn00/EtjlJajFwXxNpIeCUvp2F
	 wg3uwmWGQCrsynZa0aUtLwfzocb00V3DDmPD5zz5rjCe14rDwdx3QpNAmuo3U/10G0FXr
	 tTxmdTGw2oacaLWywBBua7aY9f5nUD3OUqodSZiEGlTFtR7by8g20AYNkeeI2/Kz75g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XuIBV1u0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7E4606A31E;
	Wed, 25 Nov 2026 16:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XuIBV1u0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F8D1F000C0;
	Wed, 25 Nov 2026 16:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625339;
	bh=e4ILsRMYSmX59dewfdSQpN3IXr0deZ8C6sd3I3ljjws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XuIBV1u0qDMq6BGEKWLbdwQ0ZziHLKTQBcc6k1YYe8ARYll8me4Qi4e65U+WvkW1f
	 1JPohzh/RxIUG8oK468IbEHPMRuAp4Ty28ca+oFCbSmtbyz2av9SS79oPUG8/rYJ4i
	 mkP2oggiiopKFd11i3D10hQ0ibLQ2JFrEEclyfE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 484/816] mailbox: arm_mhu_db: Remove redundant mbox_controller_unregister() on probe failure
Date: Wed, 25 Nov 2026 15:33:52 +0100
Message-ID: <20261125143900.397505459@linuxfoundation.org>
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

[ Upstream commit 8228ed61b6cbd6e79531c9ebfcad233c35eae562 ]

mhu_db_probe() registers the mailbox controller via
devm_mbox_controller_register(), which automatically calls
mbox_controller_unregister() through devres when the device is removed
or probe fails. If devm_request_threaded_irq() subsequently fails in
the channel setup loop, the error path also manually calls
mbox_controller_unregister(), resulting in a double call that corrupts
the global mailbox controller list and causes a kernel panic.

Remove the redundant manual call and rely on devres for cleanup.

Fixes: 7002ca237b21 ("mailbox: arm_mhu: Add ARM MHU doorbell driver")
Signed-off-by: Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>
Reviewed-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
[ sashal: Kept the braces and the dev_err() line in the error branch, since a prerequisite cleanup is missing here, and removed only the mbox_controller_unregister() call. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/arm_mhu_db.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mailbox/arm_mhu_db.c b/drivers/mailbox/arm_mhu_db.c
index 27a510d469082..b6eeef867cbfc 100644
--- a/drivers/mailbox/arm_mhu_db.c
+++ b/drivers/mailbox/arm_mhu_db.c
@@ -319,7 +319,6 @@ static int mhu_db_probe(struct amba_device *adev, const struct amba_id *id)
 						IRQF_ONESHOT, "mhu_db_link", mhu);
 		if (err) {
 			dev_err(dev, "Can't claim IRQ %d\n", irq);
-			mbox_controller_unregister(&mhu->mbox);
 			return err;
 		}
 	}
-- 
2.53.0



