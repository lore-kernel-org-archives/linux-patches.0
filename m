Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026988;
	b=rzWx56herMHpiYsuaGTqM2E5knnt6diHpnbKbnC2KqEI20yMyVo2D2X3GZUROOwtdftZ
	 70dFyx0WIX0JsEj2lvnihcFFosJgHBDYnuml9HYXcnmpu0lsdVi5XXzYcFMtrxl6NHxC6
	 rdFPvIXJlvWx5ZEUtMI7SBH0YItgqiDVfG8eX/Ir0a2+NBeH2FFK69axEGX/j1/Geu3i+
	 4p+9gjzdGGM8Lzx7wxhhGEx3iNjuo/rUKmoIeI9sJ1oxw00/H1rPqoX5IaEQyB9drUsBU
	 TSIyr6yeaLpuqPqRuk99rjNP5OhtuKdDIeFEF05Tyv85BmpIzU7B9WKSIjbiAAq+6Gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026988;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=zBH2Jg0R3Y6XzIIocW0yraKiHTX2j+GXMyS48agyX4s=;
	b=z89bCUsX5J92XmyjezY8fHkC3JYbr/uhkc3rr4Ng/3pgG6LwU8wyCxGSiwmouDA5yYNz
	 uFVgRuQmuByTI77TGWOANG0g6/MvIYiagUiy3le0Kv5/yzL0MWHSKQxahg/UF39LmNipi
	 QuoGJNz43xmBCJ7z8FJalPUi58KPnSqOPttvzC830z5zFRLtfKCBm9GGUA3laxOrdvR99
	 E4me9Be/6h7j85312jzHbUcWfD6IADIuyHIaUfG6iJn4q6Q6lqZ7OK2DNMZfcBMpQK2yd
	 t+SQ8bkRMzR/CdOp3mNDM2JUxId9xoFe44RbJdU5mEZ/dA5vU/X05QKkzBKtH0SRYug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qGsSIM1I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C430A606A325;
	Wed, 18 Nov 2026 18:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qGsSIM1I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB2A1F000C5;
	Wed, 18 Nov 2026 18:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026988;
	bh=zBH2Jg0R3Y6XzIIocW0yraKiHTX2j+GXMyS48agyX4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qGsSIM1IT99qbC9ojucZ5dYZ6JTVNKM/UFaF/84ynznqhuQLBxEhgzxS0q3PKDOpC
	 97yX9s/f9J7cq/eIoFCFQV/bl88k+X2s07QuS5X8ctL9VDLQtVYpohdkd32PKgSGO6
	 QK46p+uSURdDEFymiUj2DAgMkCvUHq0tI/K/IVxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1629/2151] ASoC: soc-ac97: Fix error handling in snd_soc_new_ac97_component()
Date: Wed, 18 Nov 2026 15:56:04 +0100
Message-ID: <20261118150221.212200399@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amadeusz Sławiński <amade@asmblr.net>

[ Upstream commit fc081cdfc6b370f6b6853cdeb4313f92561770d1 ]

If call to snd_soc_ac97_init_gpio() fails, proper removal procedure
should mirror snd_soc_free_ac97_component() behaviour and call
device_del() before put_device().

Fixes: 9bf5c3d11f1f ("ASoC: ac97: add gpio chip")
Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>
Link: https://patch.msgid.link/20261014200608.118770-6-amade@asmblr.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-ac97.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/soc-ac97.c b/sound/soc/soc-ac97.c
index 37486d6a438e4..d177f8c5ab6f1 100644
--- a/sound/soc/soc-ac97.c
+++ b/sound/soc/soc-ac97.c
@@ -241,10 +241,12 @@ struct snd_ac97 *snd_soc_new_ac97_component(struct snd_soc_component *component,
 
 	ret = snd_soc_ac97_init_gpio(ac97, component);
 	if (ret)
-		goto err_put_device;
+		goto err_del_device;
 
 	return ac97;
 
+err_del_device:
+	device_del(&ac97->dev);
 err_put_device:
 	put_device(&ac97->dev);
 	return ERR_PTR(ret);
-- 
2.53.0



