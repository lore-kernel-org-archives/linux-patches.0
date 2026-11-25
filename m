Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618003;
	b=o8c1+/1RWoEUM3qgTRIf4yC5d+KOaFdCCisjQXkqBJ8zZJNGf1cr9CivyJRrSO9e6py0
	 aYJ+FMshft+j64Jf5DiKJfeZBR50k9D8UXzfnhiFvJPg7TA9rMPw7UH4XNgZd3wMGc0wi
	 hlHDanTvugquRiIIUOZKU62XoM1VjLZ+50GGOA+xmokeQtBYsAAN7uQXnri+a/yi6SCeC
	 yAr1sAKyH56DCjW3uZpT+0/xyTw9XKSlXxQ+ci2FKWbFtNWkSVl/i6+P8elj591oaGCss
	 O3967UWvZlSYGTlrF7SHyCMrmhFxf/GSDyQpJaUPguD8H2bkl74N+FEzylaS3Xdr3jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=893VIqBtoG3p4zKh6DBox1Yg1vV5A8JGEzo3HNsgr6A=;
	b=jHPxKljsRk1f5s5A6KgwhGaO3CUZk+i+2doI223IbZKXYZcvUvtMy/Bh+lHNWrVGvxZA
	 wPx0bF/IyrUkwCh0RKpF7k0SxmsnHwD5XkcBH23tK4NNAGtQwNiUnOAPp/+DYVIBRIUuX
	 +moCpqjqSVnm7quqCS0hyaoRwhk7qJRa/F3mv9yKzRq9xw1rdtvQ9ps9wIlAOZnCNtAHw
	 HM1fCQuckgIyRAhZrIhrD92LosN2ae3xz97rwpJ+l6E9XpHsgCHKGIZb35uWE+cyB2xBp
	 Gtu60k54H0Ok/QWqXv9Deoc6U1QRlOtdg52FA0+oMPnq3QPfGl5xp8h6fAysoF2gsHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zxY76hn8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEA2606A684;
	Wed, 25 Nov 2026 14:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zxY76hn8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C151F000D8;
	Wed, 25 Nov 2026 14:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618002;
	bh=893VIqBtoG3p4zKh6DBox1Yg1vV5A8JGEzo3HNsgr6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zxY76hn8kp5+nywf3D0Y/snh26B5zf4HkgJOGd033hGWJwu17ClNJlg69FODCecw6
	 mSYpisgSKWsklfGYJwWNvz1GY32SykVaxk2p6Ke0MirJLiuBOvGdUjG7LiPCoTF7EJ
	 98bNQr5hGAwV+T9ocb+YZ/LxbyRHGZkwhRqW9I7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giuseppe Piscitelli <ooonea@gmail.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0142/1005] ata: libata-core: Check device support before querying power state
Date: Wed, 25 Nov 2026 15:24:40 +0100
Message-ID: <20261125143825.065512371@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Giuseppe Piscitelli <ooonea@gmail.com>

[ Upstream commit ec585ac78742527f80495dd8f451dcda7e9e7f59 ]

The standby path queries the power state before checking whether the
device accepts ATA power-management commands. This sends CHECK POWER MODE
to ATAPI devices, including the QEMU DVD-ROM, which rejects it.

Run the existing taskfile initialization and device-class check first,
as the active-power path already does.

Fixes: 9cec467d0502 ("ata: libata-core: Do not call ata_dev_power_set_standby() twice")
Signed-off-by: Giuseppe Piscitelli <ooonea@gmail.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Link: https://lore.kernel.org/r/20261026202513.669084-1-ooonea@gmail.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 30572ca510de9..e61bc880dc4e4 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2059,6 +2059,10 @@ void ata_dev_power_set_standby(struct ata_device *dev)
 	struct ata_taskfile tf;
 	unsigned int err_mask;
 
+	/* Issue STANDBY IMMEDIATE command only if supported by the device */
+	if (!ata_dev_power_init_tf(dev, &tf, false))
+		return;
+
 	/* If the device is already sleeping or in standby, do nothing. */
 	if ((dev->flags & ATA_DFLAG_SLEEPING) ||
 	    !ata_dev_power_is_active(dev))
@@ -2077,10 +2081,6 @@ void ata_dev_power_set_standby(struct ata_device *dev)
 	    system_entering_hibernation())
 		return;
 
-	/* Issue STANDBY IMMEDIATE command only if supported by the device */
-	if (!ata_dev_power_init_tf(dev, &tf, false))
-		return;
-
 	ata_dev_notice(dev, "Entering standby power mode\n");
 
 	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0, 0);
-- 
2.53.0



