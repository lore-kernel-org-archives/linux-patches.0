Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023779;
	b=dmGAwSLpIAIGX/PyPSWAxOvVZyBEyeU0WXVSv5J2wuiz+pU/nXy9AN5hu4H2bwRxWM5e
	 i4/Tt3KswHsL3vMquGq3mhzePfLnXm20VGMHgclvIKu8JFv24RjPuTZ24NqiSjpCvYz8L
	 hyPOJcaaD7Xd5rHfZJHTuDiW86zYLD2FNME10o2Vn9wis+z/fKIdcsKm+7Zf+63xAgSoA
	 LXfDp3WPYMDQhhuHAeg6CEPpKe3XAwAkLr10FNQvyu6jqEj63FdihsgmGvMEIZxNlEqQu
	 jUIlfbRK20/qWZYE/NEGfFt5lX5wYQ306AOzj/ulwrn/l6saSRHgzHf4LzxHicTvxLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023779;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FCNBHfKcpf2NeADWx4nN+CkUwDoMoSeNiSve+OQYICk=;
	b=I1lVRUzZjiOAjzUxiloAdVlNp4rDqqv5EZXCTgTVDGRTd/TX8IPRiIprUME0cWYpbqyI
	 n9ffwE1CcyS2lPgnAgE2iJ3p4zyzLt5mJ1ifakI90UE8fbo0MbZgIMfKEo/Vdnn8X5Y38
	 tyys0yycl42N8nYu0wX+QphFfvyGC4Ffrip19YzAAH864kex+XS15W4nYv2LchfDlyuiA
	 9fe2uSPCi5vubMOZ3NRgJfdRF7huuoYzlkb/xyM+0J3McWAB2ZF+oC/CPISW9ROOfoAyL
	 bgN+gFbm+gT0mAC0MiVSsXLBSYytNfymY8nx5VKBnhOlNwBcWvxIyCykQLijPeFDphA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1yb04qdp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE15606A325;
	Wed, 18 Nov 2026 17:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1yb04qdp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1531F000C4;
	Wed, 18 Nov 2026 17:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023779;
	bh=FCNBHfKcpf2NeADWx4nN+CkUwDoMoSeNiSve+OQYICk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1yb04qdpLGoG+9fJoIeO8+PGj+1teArh0YwHIQ+6SrFKfWzu+w3pdkDUhwOaC/usm
	 PrLmkb+wfqRQ8R+f9TGXOyg6aaM8uKut3/M7DYHAKI3Ui4WStOVafz1byG5ZzqeW2f
	 M1OQY0R1+zHwjX++8Auw5vpdoayqun5uA58SU5As=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Valla <francesco@valla.it>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0491/2151] spi: virtio: fix max frequency setting
Date: Wed, 18 Nov 2026 15:37:06 +0100
Message-ID: <20261118150139.941806561@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Francesco Valla <francesco@valla.it>

[ Upstream commit 26f42ca8becd01877e762916865a168c1b6c4ff4 ]

The maximum transfer frequency is read from the virtio config space but
never propagated to the SPI framework logic. Fix this behavior and drop
the useless setting copy from the driver's private data.

Fixes: f98cabe3f6cf ("SPI: Add virtio SPI driver")
Signed-off-by: Francesco Valla <francesco@valla.it>
Link: https://patch.msgid.link/20260915-virtio-spi-fix2-v1-1-7a474cb1b13b@valla.it
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-virtio.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/spi/spi-virtio.c b/drivers/spi/spi-virtio.c
index 06845bd3fe832..c92ea19881183 100644
--- a/drivers/spi/spi-virtio.c
+++ b/drivers/spi/spi-virtio.c
@@ -33,8 +33,6 @@ struct virtio_spi_priv {
 	struct virtqueue *vq;
 	/* Copy of config space mode_func_supported */
 	u32 mode_func_supported;
-	/* Copy of config space max_freq_hz */
-	u32 max_freq_hz;
 };
 
 static void virtio_spi_msg_done(struct virtqueue *vq)
@@ -305,7 +303,7 @@ static void virtio_spi_read_config(struct virtio_device *vdev)
 		virtio_cread32(vdev, offsetof(struct virtio_spi_config,
 					      bits_per_word_mask));
 
-	priv->max_freq_hz =
+	ctrl->max_speed_hz =
 		virtio_cread32(vdev, offsetof(struct virtio_spi_config,
 					      max_freq_hz));
 }
-- 
2.53.0



