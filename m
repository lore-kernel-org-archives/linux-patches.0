Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB034FB9A6;
	Wed, 30 Sep 2026 15:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783092; cv=none; b=bfCtSQfNqmdhtjuuEn4vy5vurZdhRlzRHUWwg7IhxO2XFV7pt1B56O3QXHtvtqzlD5Z0R7Wy8uBoxXbfw0p2aBNvSLG9dpuXFA5mew8+0IhHZSjNKDc7PuvmvoXnM6zgGXQEjm4tqry5PMPqaFfz9lL+/H2CyoUpoC34e/ZpYGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783092; c=relaxed/simple;
	bh=qh39BJsi3S1Jwg+Z6a2wK4sU5CKL4WIzLP+Zeeo+ck4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bqa3BC42LiIQL4fb0Q9My7rT0Hpa886lPqWgXj/6LnspQT/du2DF/Wjl+q7XVhQ7cmyzBHluyDlcOWjb6Sibdn+AjRVufEOdiX5Iv3+v906p3e3c6pe9sSoLPpRPISMBoAi33Z50ehMOqMgMXBsUJHt2VFAGdB03uV+FK1vy1Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ulDqv3kT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ulDqv3kT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8851F00893;
	Wed, 30 Sep 2026 15:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783083;
	bh=3X5NPR2ssWh7pJKKXSq6mtOEPB1ID13wLZnt91FNTrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ulDqv3kTtvWBLlJENI2DHFqp9pySZ+xDxxY2bIlVKWuts+keedVS34peZm+FnE92V
	 rWAmp9mEA54pfjql0xAwCJLpn6O+6NtY71cP+LpaMwqw6nWQ+CKExD+75VKp9R340U
	 KpRX627L0e3R4dvZ/9SyFuTH68cMCLXfjfvSYifg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 257/595] ASoC: bcm: bcm63xx: Publish the OF module aliases
Date: Wed, 30 Sep 2026 17:22:30 +0200
Message-ID: <20260930152353.237625403@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: hpp.iscas <hppiscas@163.com>

[ Upstream commit 32689f0fc54fd801f1cd11637666e534984cb04a ]

The BCM63xx I2S platform driver matches brcm,bcm63xx-i2s using
snd_soc_bcm_audio_match. With SND_BCM63XX_I2S_WHISTLER=m, the platform
bus emits an OF modalias but snd-soc-63xx does not publish that table.

Export the existing OF IDs for module autoloading. The PCM companion
and the probe path remain unchanged.

Fixes: 88eb404ccc3e ("ASoC: brcm: Add DSL/PON SoC audio driver")
Signed-off-by: hpp.iscas <hppiscas@163.com>
Link: https://patch.msgid.link/20260905133103.63432-1-hppiscas@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/bcm/bcm63xx-i2s-whistler.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/bcm/bcm63xx-i2s-whistler.c b/sound/soc/bcm/bcm63xx-i2s-whistler.c
index 246a57ac66799..cf8a6cb47697d 100644
--- a/sound/soc/bcm/bcm63xx-i2s-whistler.c
+++ b/sound/soc/bcm/bcm63xx-i2s-whistler.c
@@ -299,6 +299,7 @@ static const struct of_device_id snd_soc_bcm_audio_match[] = {
 	{.compatible = "brcm,bcm63xx-i2s"},
 	{ }
 };
+MODULE_DEVICE_TABLE(of, snd_soc_bcm_audio_match);
 #endif
 
 static struct platform_driver bcm63xx_i2s_driver = {
-- 
2.53.0



