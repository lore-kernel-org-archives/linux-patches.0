Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036073;
	b=lyDv5WRICYHNi/iHzNQXXeO0lz4s219uRzuP5EygZ3wlKfc4v5df8hg4rQ7iOtdOaXhk
	 lNxrSpRJm30g7g7Q0EeEU49mGFI/veAms6P8UyZjo6cJH5CS2/VgvOk7n2l9TfP6z/GsF
	 0z9dhWZqGaFkGkUjS//YmULQT4dBW2HqJ5KiAjRF58M4a0TQuMlRLr6aSSv5+Z7TiRaA1
	 1OXfYjbBRaDSHhm1SelnBnp7xP6o+SsZdbCcIJofGzKl60hu1Qn6xL5H/MS6aGTYqHq3w
	 JmOK7/CIErUbY2gcSQOsJS5i+juhFf7s36matPml0cPTS7Ycvqvc/CnWIBlxtxHADQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036073;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zifeLYPdZQT+FsAbFfuuopOnYtCoGHLPz6aWY1h9fQw=;
	b=l3Cx4eTnJrruHrQvB9RAJSvVjWvoAEwwTLtNWVAOMY6c/SSoBeie2/bGR1h/yj8PCGeq
	 mmfVJKDuw67M9RConDC+GB9wGZaVMvvG00Qmdpjp3Ml0qv1yjAy1zUcXQaR5E3Ri78+Vf
	 UJiqCzGoeeGM/2WtlwEftkWzRFGvKtRZFak8VutNHmC4U3OdBShL3QzeEMOhjAHGWoNqo
	 1tf1M5524JDqwFrtiXzJlZMGDetim9z3nDCBqlI4O9vdxLZaMaH4l2DtIGOyjK1826rlP
	 SmQBwqRK8jfMUgBAviix2zA7lDkpUUXtmqSUyTK3kigX9ley6De07byr+e7kNie/RUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GKIGqbXd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2094606A31C;
	Wed, 18 Nov 2026 21:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GKIGqbXd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541F61F000C4;
	Wed, 18 Nov 2026 21:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036072;
	bh=zifeLYPdZQT+FsAbFfuuopOnYtCoGHLPz6aWY1h9fQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GKIGqbXdhNBwFL5la66VN9As4imSlNJmQIBNmQAlK07RYV+jB+lbpoeaOUG6Wa/gA
	 eoX4S/2S1gRvwOmP9IQjIssPp51zDnbK0pt7C893hgH688Kwx0XvRq9rxPHMEIuUgC
	 9BxNs4sz7BhzVvfPhljfCCv3RspS6w8+TTj+u0gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0922/3318] media: au0828: Fix media device leak in au0828_usb_probe()
Date: Wed, 18 Nov 2026 15:25:44 +0100
Message-ID: <20261118150347.191589980@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 7b7a69c91c0537d48150942d9707614a4fdd3766 ]

au0828_media_device_init() takes a reference to a media device with
media_device_usb_allocate().  When au0828_v4l2_device_register()
fails right after, the error path only unregisters the entities and
frees au0828_dev, so that reference is never released.

Release it with media_device_delete() on that path.

Fixes: 812658d88d26 ("media: change au0828 to use Media Device Allocator API")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/au0828/au0828-core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 1e246b47766dd..c7ff52044bd25 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -697,6 +697,10 @@ static int au0828_usb_probe(struct usb_interface *interface,
 	retval = au0828_v4l2_device_register(interface, dev);
 	if (retval) {
 		au0828_usb_v4l2_media_release(dev);
+#ifdef CONFIG_MEDIA_CONTROLLER
+		media_device_delete(dev->media_dev, KBUILD_MODNAME,
+				    THIS_MODULE);
+#endif
 		mutex_unlock(&dev->lock);
 		kfree(dev);
 		return retval;
-- 
2.53.0



