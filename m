Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052478;
	b=uESsqd+hXcevGnnnfQwRU5QxmLsIxjPo17M+B1a8wPMGmrKubPAW4+V+uuzj69tf/I+l
	 zojqzi00srTaPlTTu5eWGV+jP0NGxM4l1eTuQBsbRoGl8lOMQmLjiU969yxFB2RWChmFf
	 M+uEZU63QIUohnYkb0GeTHd5MQNs5C3/HOr6KjZaNhvHhwaoo4ZvJgyF2SWPbSUSUT9b7
	 sNM8BgSXHgIH+IRZS2t+3ZSmZZSriEvUuIZm4nc0A1z9MogErZ+bhONo9JcVKTGCSrgsJ
	 X3hkXdsUZ1hMj/H08ANyKDA7VkPv/RpHn7/CrIBW5ZeUk6UGxrFIvwrQzINdDWQik+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052478;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BaHLVA2uyKteusw9ZzGOQw6tLrkAwKmEismwcBWgUfA=;
	b=mBfs5jH/pAnkC1odrqqmfafN8q1P9sdwb1hIBvz9j5H12OZzPx8Dsy15jojynSZlxNia
	 N54wES8N5TuGfNM/IsgAP9eR7xdHrsmEAEqIPYHJyBARSZfouuaAZ8OKQu2n8vY1uwEGw
	 l1rzhaJb2KhgiO3imt8XpnPDdmnU2KB/QXRXaRIpvyLnWIckcRk9xXwHC57qM/Or4iSIW
	 SZDFKajSSU5ff8TUw5MmuxiVHzdDeDJEnCTwAUhUsMmAUq5uFDzxkds+k0XoFo/S5nejj
	 qOFT7mp1WAZjSPDMsNnj4MUP8Tj3Cq1R6Gg+cRUQ/z7c9VuUiE5QjZUno3nG2bA5lpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IdSgOqV9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C90606A325;
	Thu, 19 Nov 2026 01:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IdSgOqV9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306BC1F000C4;
	Thu, 19 Nov 2026 01:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052477;
	bh=BaHLVA2uyKteusw9ZzGOQw6tLrkAwKmEismwcBWgUfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IdSgOqV98GaXNwyckvoSCuXhydnEVjMkL62KyWyqnGTUuA7hTEwsKjgXV4oRX+aF0
	 bRhrmgHikJSAKk7jdaLZb0InmCmW41p3EF+NTuQCc54bJVMltayJJKBrytVdQpXqAr
	 Ipzaa7o9RjrrCq/ELNvwsy6YLdqYzR2bh6Z+BVMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0528/2214] media: au0828: Fix media device leak in au0828_usb_probe()
Date: Wed, 18 Nov 2026 15:36:44 +0100
Message-ID: <20261118150032.192493006@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index caefac07af927..ee8525a7ece76 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -702,6 +702,10 @@ static int au0828_usb_probe(struct usb_interface *interface,
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



