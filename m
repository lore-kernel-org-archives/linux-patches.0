Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019475;
	b=jjMwu6EwV7GEg73i2gXghO0CikQgEkUqmRcyAJ9nEW4xYdhu4brGPVlAZxo1TmAf/6Vt
	 laTIGJZC12aYnOqrYRIyTVzugw27mP8+iCn8WLQYFLwDn6r2f9Q+eX74YfbZA3njKA0u4
	 uuNRwif/cS9cb+9z0aWSSB3lnc6mqOZfj19VR9xpc7v9ZMP4ynZoibLVsQpt2bpODgmo7
	 BrgfOEm8yP1H72bgaCrWmG3GrbXnK62YTUUnIV5SAHYVB8lW3ZWqiwVyShHlVsLkjzwWc
	 zXgOsgcRXZ+B3B7j2dWFNN23LSepouRJYGy2FAa6xgxjX35NaOkMOfeWXa2N6wzPsiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019475;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DEB9JLhaDEQDHsxQjSMUBMhShQTBV/zTXhYpZSXbUE8=;
	b=FQ/y4zJVTEi8H/eWgOMQiudjJnKKBcA164PrNyWfUOB/9DQCn5dP3Xm29lVmhCLky/58
	 1wMBZxOuccurO+5eP41xh1cvxibn1iRfkDglGiBbYB8L8NxD5Qhz5AT+FvMkDb2r2vJ1k
	 iIirgXDbMdf7L/AYjBzCrg5rZy7YrKH0ImRiUoLdTs4pK0DchCoPjefvGYnnxfxLWJnKv
	 iFErGSlMjEoLiWRRf74CAqMQ5o5BpHtlruYyimGqXB/+ybEZfPkWU61HTNeu079aJmYCV
	 k9oq1HIsntOzFVC+2aKEftzz/9s/W3Zw9X11w8syoXKX0doMqM7nHR1rZ7cHdMhwHwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zrku1Dhv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BB7606A33F;
	Wed, 18 Nov 2026 16:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zrku1Dhv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C6E1F000C7;
	Wed, 18 Nov 2026 16:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019474;
	bh=DEB9JLhaDEQDHsxQjSMUBMhShQTBV/zTXhYpZSXbUE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zrku1Dhv8k+x3mx+KvrQKCsV8xKiXKJNy7hpLli4+0AiNTXNyAWFf3p87S7uw3SIm
	 2OyKZzo6ODEHbOh6cV7JMfqu0rBa9KDoiPvCdtXrZehngnyAMdIuju4UpVsVwLIxK6
	 ezMaSrI9A2xKViYbubOep4Ow+0b0Mqr9Ou611QLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1608/2651] mailbox: arm_mhu_db: Remove redundant mbox_controller_unregister() on probe failure
Date: Wed, 18 Nov 2026 15:47:28 +0100
Message-ID: <20261118150345.721453294@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/arm_mhu_db.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/mailbox/arm_mhu_db.c b/drivers/mailbox/arm_mhu_db.c
index a39239e38a479..9f1c7bcfdcb40 100644
--- a/drivers/mailbox/arm_mhu_db.c
+++ b/drivers/mailbox/arm_mhu_db.c
@@ -317,10 +317,8 @@ static int mhu_db_probe(struct amba_device *adev, const struct amba_id *id)
 		err = devm_request_threaded_irq(dev, irq, NULL,
 						mhu_db_mbox_rx_handler,
 						IRQF_ONESHOT, "mhu_db_link", mhu);
-		if (err) {
-			mbox_controller_unregister(&mhu->mbox);
+		if (err)
 			return err;
-		}
 	}
 
 	dev_info(dev, "ARM MHU Doorbell mailbox registered\n");
-- 
2.53.0



