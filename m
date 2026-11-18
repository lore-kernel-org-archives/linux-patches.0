Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041353;
	b=dIja+OvaHsfgxjJLlSwh1Lo8yZhegi2bpAN+nsG8NAHUQL4D218KKm6SzZQEWU1RwzCL
	 mfdN6xRdHJIlImJeEGprH+IJlsAH3TAxhr5P0TDRCwWZnM9LgVT9qVJCl7FKpmNihbcMM
	 t7HQ0FZX/S63duJL0ukyfJwq47SO/WkdBOwdQwkecM0CaTFXn1S62xIZCEx2OcLb5I5LI
	 IYuZJOGEU6BepS4bAnA2Xf2hL7BDcEkpwwhlnmrcrt31VI4w7g2xZ56qMpG80EMWwTwYu
	 RMrHyFsEROPp7MeeyMqjWgaFcVeItVZBl8cxweSknVjZ3RVbkUCS8X62aoU0UdFbb6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m3JqQMcu7nV8NsRsIR+20Vlj1uemUSkgP6lmGA9rwNk=;
	b=uiBB6norCxdCGrxxX+GpbSQ1jWs/xoC7NNA2PpyudQzdr4ZDsBG/O1AzR6fIi7KSrl3L
	 O+dStFWyH/kZ8sIWENTjBiMcwgeblB9lfVFISbQoK/iKKehSlmDsyuPWLdkG+c9Rv0u9r
	 87sfi6kMD9W6P4mu5q1j5LcVV+daWQfuqxvxeWSvDQPbybJBEwCdwYJyvDik+1sIAiDgu
	 tK8euaBLJj3xmbnxpxUosUCGxnsdvVqVQuIgaO0hYgQmrwNdk3hL9HN4XfuSY19r5zp2V
	 0iM/22fnnTASuEael2RkPrRjkKQK8KH34uyUX1/4gJoNR45OHPLOF1cjh87novsH/xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ySDI6D2d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44E5606A32C;
	Wed, 18 Nov 2026 22:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ySDI6D2d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066A81F000C4;
	Wed, 18 Nov 2026 22:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041352;
	bh=m3JqQMcu7nV8NsRsIR+20Vlj1uemUSkgP6lmGA9rwNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ySDI6D2dclZV5BBTLv0Ah8Oh1FKl2ocQvMTQm4vILxm3mhFT/9ClmcuN23Yq0hFy/
	 Sfl0vITSc0H3d0aEXqfw+uugp0bcUg38XvvnZPXITFXIXJdieegp75b2i8P0tSolEZ
	 7VFPje5mDUqyw22uf4uBczVy1Li8I0cXggC9vVFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2783/3318] serial: max310x: remove trailing whitespaces
Date: Wed, 18 Nov 2026 15:56:45 +0100
Message-ID: <20261118150444.187131175@linuxfoundation.org>
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

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit cee8e0cc9308ab55d4c3bd8eae5f6b4b65898e59 ]

Fix coding style. No functional changes.

Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20231011130317.3562401-1-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 4efacb600bf9 ("serial: max310x: fix breaks not reaching the wire in RS485 mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max310x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index 1b40dc2c66f36..4efa33b9c52c9 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -412,7 +412,7 @@ static int max14830_detect(struct device *dev)
 	ret = s->if_cfg->extended_reg_enable(dev, true);
 	if (ret)
 		return ret;
-	
+
 	regmap_read(s->regmap, s->if_cfg->rev_id_reg, &val);
 	s->if_cfg->extended_reg_enable(dev, false);
 	if (((val & MAX310x_REV_MASK) != MAX14830_REV_ID)) {
-- 
2.53.0



