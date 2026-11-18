Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060485;
	b=QgZilx9itlaGIc1zOyJA+KHa0vk1zNbZf3og5OBZo9TkcZHmlb4MQjTjvLuWrUV085IQ
	 hZZOFJDDPv12a203fliYK3EzlpGAtXjS9K2HXrXkSs0oKk0XKE5WYBm66fMC98YXuoGDb
	 sHmRRbCYCGX4ULTws0vH3B0bgLIlJsWMKpGevoyFe43BTk7dLa92lPv5owmOAzx9N0pDk
	 OmJm4LNnYdBwHbL4o00p9IxZldvqSMmiXttqN+PxGYkFtBY6JxM7jYLU4iC6dwjV3rpRK
	 ZVUgcdqrlrlXX2VkyRzTzYWTSlQP5B8GaHRnginRKxBpG1az+GQj40ywzXdvLOBXswQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060485;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3M3uKE5pexSHETL4yEmA7Qh4C0sA4etm5Ej2U/nfYbU=;
	b=48/QAhucQacXpV0SXx8ykkwJUyOFZBNrt9f3g8Xvfg6/6WqWdXbQRnAVfb9xKabiz8C1
	 ZwMaRvbaVJ80PyuhEHiTd5t+sHfsMtPGEQz6Skn5GPohrkyjARVmrK4JN5H74b6K5uGA/
	 LA5N6r5zMUZeb7tGkYLOU6fwCHQgIXRmsw53a3eiHZxes1rgJStaaF/uuDR5yckktYvXr
	 viSqUsmq/BRMXoQpfcfYsX1TPykamoDnUcWIehbxt3zdKaZqp8NtoRBTcHIGk0aJc22KS
	 YFOBN/gCair1NaDewqmdwOmWNox53oz5O2n2Swvmi6bdV11Hq/HoAU8u7v1M458yzvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cCa4u8+J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DFE606A32F;
	Thu, 19 Nov 2026 03:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cCa4u8+J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0BE1F000C5;
	Thu, 19 Nov 2026 03:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060485;
	bh=3M3uKE5pexSHETL4yEmA7Qh4C0sA4etm5Ej2U/nfYbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cCa4u8+JRH6e94eep5I970gkUER3Z3GdpqIiEnPnZ/WyhCJ8GHZSddL7x3M5PJJ2d
	 cyw4rnmLq5+Nu0iDnghm+jo0Bpep4jgBJ6DvlRZKywM2Gza0oZMXPWfe8dkyz9ApOO
	 slvvT4MuJyET5zlpMQ/+NYtW7IHTB+0JNk09VddU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a83a5a1ba9ff57935171@syzkaller.appspotmail.com,
	Keisuke Tsukuda <tkdkei@outlook.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1216/1848] usb: gadget: composite: avoid warning on aborted delayed status
Date: Wed, 18 Nov 2026 15:54:14 +0100
Message-ID: <20261118150010.882630453@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keisuke Tsukuda <catnyaaan@outlook.com>

[ Upstream commit 048884b782b137229399b9f727b6437d9b4f1071 ]

A SET_CONFIGURATION request that disables the current configuration, or a
disconnect, can abort a control transfer whose status stage was delayed by
a function driver. The asynchronous function work can nevertheless finish
later and call usb_composite_setup_continue() after reset_config() has
cleared delayed_status.

This is an expected consequence of aborting the old control transfer, and
does not require a kernel warning. Keep the diagnostic available under
dynamic debug and ignore the obsolete completion as before.

Fixes: 2bac51a1827a ("usb: gadget: composite: reset delayed_status on reset_config")
Reported-by: syzbot+a83a5a1ba9ff57935171@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a83a5a1ba9ff57935171
Signed-off-by: Keisuke Tsukuda <tkdkei@outlook.jp>
Link: https://patch.msgid.link/20260908203348.95825-2-tkdkei@outlook.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/composite.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 02cbb83cbed62..38ecb4d42ca6b 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -2504,7 +2504,7 @@ void usb_composite_setup_continue(struct usb_composite_dev *cdev)
 	spin_lock_irqsave(&cdev->lock, flags);
 
 	if (cdev->delayed_status == 0) {
-		WARN(cdev, "%s: Unexpected call\n", __func__);
+		DBG(cdev, "%s: Ignoring obsolete call\n", __func__);
 
 	} else if (--cdev->delayed_status == 0) {
 		DBG(cdev, "%s: Completing delayed status\n", __func__);
-- 
2.53.0



