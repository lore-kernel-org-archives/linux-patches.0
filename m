Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058276;
	b=VhelAlxFXXIdBLC9twQMEM/gSEHBlYyGWiUt6AleHZaXpRkugGGaj4expZzw4FQ0VxtG
	 ESQ3wxYG4x/6imUhcE5xZsXwHhRJyxK7C/4DtgKqylarfisYkXzNbIHjxonDLPUk82KvK
	 1x1MMBaKDgXTRiphbB2I/RJ94O1In6yAu1E8m3vTqqm9LxWdqUYyPhRVo4+pEk9F2QweB
	 Scn8etv0IISco4d4UZ61Vp8VPtb/cOMEsOXzic4INEIoIeiO8yILsZts7PoP3qbWa+h2v
	 7ZDWD+z1YDsCWYieCfRlqrz2tNYCKZY2thCSxtqQTdVB291fGwm/iqF4wcQbbFCm//A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058276;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5ks5Nyh4Cv6TjOOFOaf1bfRVdiegKtK9cxe1QowrJAE=;
	b=o7IVEaWn5AZOEKvuiVq1beJGQoFJEkRdfvi25hf+2tzAnW9yP2WgXT5C3G0C/fMhmg4A
	 aQF+xF6I2XDI2glmwJ4H0pfekLn9C2QXIL/GqrOds4K20UzIaaJJ3UiSXCnAHSsYkMOCh
	 H/63YUfcwPRY3rsaWET15gIJKWpxHi1D2QbIEKuUESWnwveW8G8yuUaW+oheAmGQnRmMN
	 6NIYsjcws2qVRXYRA4J26rl3wW6iYPnvn+S6LiGBcv6Btkfr5+dq3eXAFSa3NCJE/U3br
	 jSHY2pzFxN7y8vBdT50FT2AsxBFFnvt6FfQDzzEjiD+6/CZ6EhxDYxcLAdUdklZjtRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FfEqCN4P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527AD606A320;
	Thu, 19 Nov 2026 03:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FfEqCN4P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD61A1F000C4;
	Thu, 19 Nov 2026 03:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058276;
	bh=5ks5Nyh4Cv6TjOOFOaf1bfRVdiegKtK9cxe1QowrJAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FfEqCN4PVfvdq6aOwkkQSiqkgr4tOUItj1qhwLUyX15iqxbXNsBnFFh7z7SabWcjB
	 ONcI5H3kfTKVr86kC8m/IRbPnYIz0MM5Or6RkMqsFbxLuQ5RiKQIy711dZk7Xmju+C
	 dNnNWmG4vIxTtPM/gZ+nfIhsUwq26GQjbVANCPOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0427/1848] media: au0828: Fix media device leak in au0828_usb_probe()
Date: Wed, 18 Nov 2026 15:41:05 +0100
Message-ID: <20261118145932.016856380@linuxfoundation.org>
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



