Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016455;
	b=4S+dWcMos0EwxrtlR+3DKc53mRrIYbqms5AuScR8HQ17r+g/REwZSfieel1Lw9x7woaw
	 xSVuA1+J6TBAzva3paIgr21HIQlKdtwvPmR917mNzOMqs/Psqxe53TQu3geXbWB6yTgJF
	 fM/vU4i3rSxiVTS7kPJqFok0LKqNiRmtspWJokzTA9ZSA3XS6HVje2ePXZY1MhQFWj2xV
	 Rw3Az1DWABV10g2fW9j4au6drFCFKwPcfZGcw3qvRvwzlYXk2897EZ0C4jFfSY5rSz4Aa
	 fCfUTR+zzGgYuV5NWCtBtW1171Zx+VvGBj5UFlJOnHUcG+4cHT2jl9IkOT7zd44e9XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016455;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yMgvpw03cs2ouN/HJZcIKTydOzhni5F0MGru2EaqFkE=;
	b=cKCwZAUcsX+JfnfCZrRiriMBe0dqb80y6Pyhu+g/8BsrtYwpvFwG5IwYyyFh6czY1C+w
	 FzUUVyuiRw6BVDpss11JBvjsuPHC/bJ0ftH8kCm7P7P7e7L4vNZOBDmUoUZ6LgKZmgDJD
	 EWxVl1EbxksJrgNy9VfVOtesC9MG9zlBw3xlA6ackW+KpUaFiaFLpQXlDMfqAPw5KG9F9
	 suE7FfBrJ2DiHWDHVo8U5Qca0XhUhm8xzM5K7F7kRY24S41pLXUvhYP83vHxgd7vieLpS
	 Npwkel4PUzkacX58M+C9fy4Dw9BX8SDACvZQ3wE1n66r9Ybi2dNpgfbDzY/FOhau+ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LcoxFAT2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDF1606A31C;
	Wed, 18 Nov 2026 15:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LcoxFAT2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786E51F000C4;
	Wed, 18 Nov 2026 15:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016455;
	bh=yMgvpw03cs2ouN/HJZcIKTydOzhni5F0MGru2EaqFkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LcoxFAT2TYoN6+f80CWJixH2qZ5AZtw71Z9R3PJjhcDxM8NGKxFG7SMP4a/gGF0bY
	 JrLTFc1Dj3l3oLwCYfMx8LNS1z9jUHe3dBK217Fa9zUe1Ue5sqq0Wn+YWh6gAqCn1u
	 kAbFF63MWS6b3ILdfWoSWPdRhP9Im9KnsMZz/tls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Valla <francesco@valla.it>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0535/2651] spi: virtio: fix max frequency setting
Date: Wed, 18 Nov 2026 15:29:35 +0100
Message-ID: <20261118150307.021243693@linuxfoundation.org>
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
index 3e181bd8bc94b..96cdaf1b3697b 100644
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
@@ -304,7 +302,7 @@ static void virtio_spi_read_config(struct virtio_device *vdev)
 		virtio_cread32(vdev, offsetof(struct virtio_spi_config,
 					      bits_per_word_mask));
 
-	priv->max_freq_hz =
+	ctrl->max_speed_hz =
 		virtio_cread32(vdev, offsetof(struct virtio_spi_config,
 					      max_freq_hz));
 }
-- 
2.53.0



