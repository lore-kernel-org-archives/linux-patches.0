Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064106;
	b=g/nS8MoHuGLrIDH2yG3bpUOm6Um1b9HhCfkk4Y7HUSpt18k3inHfaBegdUBUffyJGVtj
	 TGnVlf3qyozxeljCrWkT3+wSYe8aAMWpH33/R0xvEf/vv2plfZOrkWzn20JAqhzBdNBEj
	 s9Bsb7yiPIp4rnIkNwMtvtcOgDUL3EhdpEEgOSO0G2V+LG55Xlnv3OQ7EB2CE5nXjBTRi
	 7YE25hAVD6KIsW2q2VEc6hUNki9wiqgLc5d7N7W+SQfY3Yn3Z03Y+0WleofusvtPAXRMk
	 Zok9i3OUZHCryx4bXsLX8zd0iwIwVF+2h29IS7J9wmUMOxAlNaiEZ3ugXwYev8cNUWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064106;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZACM12doc+Sxrv21En+GkIalK1P/biOF5tZRuC5sZys=;
	b=gRAdzdT0Q6w76TmEq7dk1VBRBAg9AvDQlK8UqnifQylY/1gHyLxlWyvamS9r7WL22gOH
	 +x80npYs8KrTq+GXuuhQs7ZhrmHTQl5YKWmTRpc8egQU4gKcSrdcgnzBvNBT/CBoVbamo
	 hiYxbuiPmIOtsTyoF0gyxn7o8PnJjG3/ETOssTljEiX64LWIaIekrZCCgCDdRU7Ibl3Z3
	 PXaFNa2XqmAngnehUItijmXiqlTrWrE6ucz8SIwd1W02WmqgIYwPGRS7u7by8Yl4YcJuv
	 06/EcKI2DJZA7KH3OCQ0vKSzySEyHa+wJoqeTjZFWeRWrWkzufHLfJU90rkTdpUIKVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wtric4zl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECED606B882;
	Sat,  7 Nov 2026 15:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wtric4zl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFCD41F0089F;
	Sat,  7 Nov 2026 15:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064106;
	bh=ZACM12doc+Sxrv21En+GkIalK1P/biOF5tZRuC5sZys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wtric4zlVum15fhUfPEA5rvCjdICusitgROdKDLgR1WA3nAWU6urhg0cO40Qu1pnW
	 Vv8tH7p4waL2qMqhMQAyO4FHvz9hqMFAYRFz/f07C+1WKImttSLGukhPKFbq03F1PS
	 TRrnnUYHO/WdsTR9GHJrLy9A/brZXEjVKbsv71Xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0266/1257] media: au0828: Fix media device leak in au0828_usb_probe()
Date: Sat,  7 Nov 2026 08:42:42 -0500
Message-ID: <20261107134946.841935969@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 445cbeb7abaee..c3826b3b8a2eb 100644
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



