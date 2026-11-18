Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052280;
	b=B48ZQIMptqand1d5e+ewAdC1H1/Du8Iv5ps3XDwQOA3ocRZKebJewMhfFu7KG37YByvl
	 bwHKOvvybF0BPSfPtRRM5zVjWd37SysGRTquUq2i5zQoeSeuY7TBoKgdTEP0niU05gYio
	 ZJvfeHkDaoq5LYFhEIkLSvCgHgwfv39RKh+zODl8w9G/EF4YUEwIv8LJx9ANsmlORqapG
	 PCm54A96TmHV5IngXS2kv60t/AMO/pxGHUxNUkFXjbi7HTb5QRQo7zLfNGqp4U7p4pVjv
	 Qr3XmLIWOdC/YzBIU0/9abLwOY0tpsCx779K1DO5k4kgWqoyJOVjyPCb6cUMX5E07Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052280;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=63Bu2bEar7GgR8/C0MIUkXj/SbrATId7FVapkhQec+M=;
	b=dVzsz+MeG3sKZveDc1PgT8EIn8iJO5Zd8nEnWjRhy2y+oG/zVzY87PZeaj7LhjqUbaGS
	 +Dj3lBsJ8Mgt6yqxeiD4wfSCzMP7ET0KPpv3I8miOz1Vbc5vYO6YHMZEcWYgNoQ/9ORDw
	 LdxbVI9DjxFIyvRGHaHBcMSGtEekkHd3XTSAhgDTLuDIJAYxgVHnu+R3C4IRzQ+REGYLA
	 B0V2qcgvju8TGtl7eYkUIwJheeIv6CyI9gOMRDDTL8a2EXU64/hReQnze+3F7AuUlZjZJ
	 rFxdsTX1gbFkSW9KUExNhvAXSFltha6vjZEWCwUMgegD+l4q9fDgl2oul0RS0y44QHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fMqaG2rR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1A2606A31C;
	Thu, 19 Nov 2026 01:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fMqaG2rR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C1E1F000C4;
	Thu, 19 Nov 2026 01:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052280;
	bh=63Bu2bEar7GgR8/C0MIUkXj/SbrATId7FVapkhQec+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fMqaG2rR1bnARtjOtRLIweFxYlMvQR6gI1rIW3oE1DaO6l+1yivZyxfL7sXZT7Ng2
	 JJeGN/UqV0K0GqVb2Oxo4sfDQyBaw79uot8Z6SUpfJgINchHXaEWu2k2/HyI88R86T
	 0zA1yk9loNcA6QOfDBflaBascxzrr2P6QcFH+vj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0506/2214] ASoC: codecs: wm8994: Fix runtime PM leak in wm8994_mic_detect()
Date: Wed, 18 Nov 2026 15:36:22 +0100
Message-ID: <20261118150031.381750102@linuxfoundation.org>
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

[ Upstream commit b2c0e5bf750e33b0e1dcdfbb2df8103a06c7caab ]

wm8994_mic_detect() resumes the component before configuring the MICBIAS
pins, but the default case of the micbias switch returns -EINVAL right
after taking that reference, skipping the pm_runtime_put() on the
success path. This leaks a runtime PM reference on every call with an
invalid micbias.

Release the reference before returning -EINVAL.

Fixes: f5a2cda4f1db ("ASoC: wm8994: Ensure the device is resumed in wm89xx_mic_detect functions")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260917165130.2163278-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8994.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index e9037cf0f2c0f..8cd00e7d59b79 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -3533,6 +3533,7 @@ int wm8994_mic_detect(struct snd_soc_component *component, struct snd_soc_jack *
 		break;
 	default:
 		dev_warn(component->dev, "Invalid MICBIAS %d\n", micbias);
+		pm_runtime_put(component->dev);
 		return -EINVAL;
 	}
 
-- 
2.53.0



