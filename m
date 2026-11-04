Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829520;
	b=uqVrAkWWy34z5UtkxXpYIvLMScUv3+RrD6iMTZLG5GZan3fPVI5B8rixHcy35ngQ1Ykd
	 D3Z3DvzIYS5/3h3Yt1s5QaBJICpmes6QzU9s+h7d0kBCzBDD/0ZUpv9PZdqu0TeocB3Pz
	 28tqxc02YzCTnqLBVEZkjLmeOAFv7yVL2PkreBWBBjs8dR4briBdIrPBiLJbPK7lCmG9S
	 O9MfslE30qOoIBpDTY6Khejh8uUJk38N0c7TOdf1vqC1mxoa7yeQaQsQvV2oNeJUCwmuP
	 g/VEk/2vUsdT0hXwesPXCjunkcpqm+f6XMiCqF8cgAOsr4UtgispzHvrGVkbZtkT8kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829520;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VWjh/8VwumtGyKhLaXbBoL1uZhJYvmqSvCjJtlE63YY=;
	b=Nw6c5yXlM2D3V2FEyZ6vB2ws+P7WREpFTLPGG5+yQzvPq9rus0tv1Zo9iBw3/UsXdgv2
	 LvrE3WX0RCcOJrKExMbkCcEbxll0Z8HOoEHsnZkk5xlUw5tewWYUAJy1Q3wR4PvA9jZBX
	 rm5TlXwq6gr61j2l5i0quV2ZugrSKm0rIkU0Hd2qhbxJpsrjRZQSkXTsnuLPAM7o7TacX
	 Dy/OetF8g7g28p/GtV6elek8rtgLiN6Xxu9z3fUQRd4vDR0QAkpGGisf0UCR5WsJHHsEr
	 zVXmTi4XAijbqZcCvyXIeudzlqSI/izQukbQFqkxorZuM1UbKAk7GqOTPmeT4H0l47Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aphv03XI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170A5606AB3D;
	Wed,  4 Nov 2026 21:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aphv03XI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5021F00A15;
	Wed,  4 Nov 2026 21:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829519;
	bh=VWjh/8VwumtGyKhLaXbBoL1uZhJYvmqSvCjJtlE63YY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aphv03XIxyarlzdUFscpcu5vBQF9QIgwhOzoqktL7iIrnQwvKrDPD76hWIeTc7osW
	 7M99aLDUj21l7w4r8bZ8jJpO6H84E+V7GpS+rIXdTThBNwVat8AvaWxyEwawALPsbw
	 Eb68+0T/EpuKoRqkI94JT/GPkjur197s0lnPZ4mY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0138/1005] media: em28xx: dev_info->pr_info since dev has been freed
Date: Wed,  4 Nov 2026 15:57:51 -0500
Message-ID: <20261104211047.564516061@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Hans Verkuil <hverkuil+cisco@kernel.org>

[ Upstream commit c132b07f7e5853c0df35a9b94b8e204cdc6afdef ]

In em28xx_free_device() dev_info passed &dev->intf->dev,
but that device can be freed already.

Just use pr_info instead.

Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Tested-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index b8e207443770e..af2c06a05084d 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3556,7 +3556,7 @@ void em28xx_free_device(struct kref *ref)
 {
 	struct em28xx *dev = kref_to_dev(ref);
 
-	dev_info(&dev->intf->dev, "Freeing device\n");
+	pr_info("%s: Freeing device\n", dev->name);
 
 	if (!dev->disconnected)
 		em28xx_release_resources(dev);
-- 
2.53.0



