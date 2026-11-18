Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026648;
	b=lxMaR1jMg388oIB0OLfSMx5V+8CsO8cMDeoAkZk5VfbboNOfOkioXbOYFAeldlObbFti
	 Ggn+D8UdN9tRE7ArfWjTgdZj56gjl4OKGj6DzciOT81aa28XZ3fRBqvzKWDYwUeuBdgXB
	 iJdt6HIY+bLwdomqo6AWyv3YIUwLDzpbSi/tBIZXupJeIrCcLvHMfl196BzKnOZFZzQjA
	 Cs8Hv1RiLI8VfBxDOmePAVajX72JwnAnsCK7eepgsoBur8NdXvxRvUf3XJwMlWSqXEiWm
	 I+FEqOPDm/ePsBYhlcZ/Y2wCPppVgRnVGwA0+SmK0For8uQsMMAGRnirtc8+3MV5DRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026648;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JAHQyZxfu0iktEpq/o3Uce0KepuljYNJThcBJbd2OX4=;
	b=YuoK8imGFGlVzMxkAqhp5V1HL4jnOc9cUGU+yBYTpt6A+4w1HJVXpg4juskJ0pV3y8GE
	 Tg3p4U1SGOME8uSLReJVe9Qd+MFnWAIuIBmE7B2KBVFoBd5EGtEdhhfgpMAAX8qEEOEgS
	 wpRCel2BhNzMaGLRxpI7A0dR1wPjiGzAtILFWcfX4yI1J31lx/FDCqho7ugoKSOhvc+ah
	 LQRcRGE+VT6vSj3qDgrl8sAazFITLWTD7kpvVJpHZHu/wqmvfbAnyqI6meGR3DjrcJW2h
	 ZHE+gcbK+08saz3uoinxqgDwwUsEQyBKl7niCS3BnwamUZeP2fz2P3SUG0SowjMwMlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZbiWQtpA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410ED606A31C;
	Wed, 18 Nov 2026 18:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZbiWQtpA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C4E1F000C4;
	Wed, 18 Nov 2026 18:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026648;
	bh=JAHQyZxfu0iktEpq/o3Uce0KepuljYNJThcBJbd2OX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZbiWQtpA99xVrNz2GljMmzgJxYhYA6/U/9m9bjwWi3eGA616zz37HsnSLNMw3jWFh
	 v1CJGXY2xgoZQTY30vyfWqq3QaUGBuFGjqbrqYbiebRD9Izw+bnzCQXqYxcTQuFI3S
	 Aml65OzO2+IeFVHl9K/8zVuJ4XOudj9e847sXJnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1507/2151] ASoC: codecs: wm8983: Fix definition of ADC 128x Oversampling control
Date: Wed, 18 Nov 2026 15:54:02 +0100
Message-ID: <20261118150216.764760761@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit c1af9e2272f025ff75be76e03413074d5e7801c9 ]

ADC 128x oversampling (ADCOSR128) is at bit 3 of ADC Control, not at
bit 8, which is the high pass filter enable (HPFEN).

Fixes: 6b3860b0a20a ("ASoC: WM8983: Initial driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/d6a5bbab35e1fd2bec5b13d30951546080d493a8.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8983.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8983.c b/sound/soc/codecs/wm8983.c
index 6a83afe6400bb..1e5442ad145ef 100644
--- a/sound/soc/codecs/wm8983.c
+++ b/sound/soc/codecs/wm8983.c
@@ -234,7 +234,7 @@ static const struct snd_kcontrol_new wm8983_snd_controls[] = {
 			 8, 1, 0, pga_boost_tlv),
 
 	SOC_DOUBLE("ADC Inversion Switch", WM8983_ADC_CONTROL, 0, 1, 1, 0),
-	SOC_SINGLE("ADC 128x Oversampling Switch", WM8983_ADC_CONTROL, 8, 1, 0),
+	SOC_SINGLE("ADC 128x Oversampling Switch", WM8983_ADC_CONTROL, 3, 1, 0),
 
 	SOC_DOUBLE_R_TLV("Playback Volume", WM8983_LEFT_DAC_DIGITAL_VOL,
 			 WM8983_RIGHT_DAC_DIGITAL_VOL, 0, 255, 0, dac_tlv),
-- 
2.53.0



