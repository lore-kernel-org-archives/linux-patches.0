Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038057;
	b=fPJHfLiGqdXz/ngLKtAvR4jZ429s32p7ii6erezceOzjIes6K4W6naXCHDz99c+JoEuz
	 xVsrJ24/FlwO8NgIgedKI+tfghNnmv7ooaL1MFk51x6FR44SicMhCIzuHpOLMdtmhUWN0
	 Kpb9eD/FAFb6mH7dcd2X2LCtpEh0Ud8YepzmzELAemz9tDEu7vJz97hy2+vu5NjpriBAx
	 5o1uunExeePiA7fT9vh2IM3twO6ZPUfvfadqmXWYRBT2KXcmIrxWnT/+sv5ME11q3zwOT
	 6JnAAuRsQZfKHJ1DSXD3NKmcWD2V83+mEEFwlEJVdKKhrtbPSuEX4T/UiqnpHKnr9Fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038057;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/KyXLXxZXGlfZX6s++2OYHXWU2kcVe7xJbDNbqo46Kg=;
	b=wNFJaZUB5lvv9BnuQE6LrGDfR+vAC2VnyhjBD9f5PNu07/DDWrLGrvGOuIU6PySliivD
	 jUwBuF2Kw5aQdfuawXW49w/78vB5crkc1+6oYIoIp43eBsqnTVQObtXhNiJLPIMcIbUu9
	 B06WkJaBnkENUXqAkKKdZo0diGgQn72eAkgMxXcKrgk91WfcjyctN/y/uwp/mbFTFa0a9
	 eWRje6rkdGe77T+SX9KLuMsMcM6gD1jceHnVah4DSLAw/3iiCn1hkjAogfPzval6+HxwQ
	 /AUTbn2HEGACfRs/09RGbr09IXZpM9PGWDN4IfhhQTVfgwl0Deq8PzcK/aw08l7xwig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LC6NFQIQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA60A606A32F;
	Wed, 18 Nov 2026 21:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LC6NFQIQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7B51F000C4;
	Wed, 18 Nov 2026 21:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038057;
	bh=/KyXLXxZXGlfZX6s++2OYHXWU2kcVe7xJbDNbqo46Kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LC6NFQIQGyRjG6bRxxwRyouCifGI4Us8alV2M1BPbUo2T8lysaeK3iKsM2QMwAzPI
	 eytH7Jsu+Xf8PAbzwnWcWkfNgkJfRv2RDvKiTx8LYiwuoh1tvrx4P4DlU+4Z0wN13j
	 QshzSCKYzYFwAtPrq787itZ4mpHG+Llkiufzf3LY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1604/3318] media: meson-ir-tx: Ensure rc_free_device() is called on unbind
Date: Wed, 18 Nov 2026 15:37:06 +0100
Message-ID: <20261118150409.298670829@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit 32999b8a9d5c4f497c9739e70ac4ee390cd650a7 ]

Make rc_dev devm managed.

Fixes: dccc0c3ddf8f ("media: rc: fix race between unregister and urb/irq callbacks")
Signed-off-by: Sean Young <sean@mess.org>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/meson-ir-tx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/meson-ir-tx.c b/drivers/media/rc/meson-ir-tx.c
index 94208f76bb33a..2824e2c69ac38 100644
--- a/drivers/media/rc/meson-ir-tx.c
+++ b/drivers/media/rc/meson-ir-tx.c
@@ -349,7 +349,7 @@ static int __init meson_irtx_probe(struct platform_device *pdev)
 	if (ret)
 		return dev_err_probe(dev, ret, "irq request failed\n");
 
-	rc = rc_allocate_device(RC_DRIVER_IR_RAW_TX);
+	rc = devm_rc_allocate_device(dev, RC_DRIVER_IR_RAW_TX);
 	if (!rc)
 		return -ENOMEM;
 
@@ -362,10 +362,8 @@ static int __init meson_irtx_probe(struct platform_device *pdev)
 	rc->s_tx_duty_cycle = meson_irtx_set_duty_cycle;
 
 	ret = devm_rc_register_device(dev, rc);
-	if (ret < 0) {
-		rc_free_device(rc);
+	if (ret < 0)
 		return dev_err_probe(dev, ret, "rc_dev registration failed\n");
-	}
 
 	return 0;
 }
-- 
2.53.0



