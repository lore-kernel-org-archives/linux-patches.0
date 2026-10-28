Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216877;
	b=5S0uxD/d2WSLhI2hvQ86TmKkNtL05PZDgfOmRe5yuJgIjzcGIaB11OK/OFM5PTVY9WEJ
	 VdzBCiNV8J+7TP4ACjhYDIvDW1t3PVd96p1QMbJyldVIxrKC8BFreHktgdvgEE8FPcIF8
	 KvOh0AQAXZyw9AXS+bFmTw2DvbycEw9mfGOrPzjif5ZOuWS3RjaMYxw/BoVjgAMmA6p1n
	 ZrPW0gRFsbLSI/QZODFRdHzJB5DLBw8P1GR4X3R/MeNZBTpTgiRic5zIFLFfx6/sAhmdQ
	 8+oQkOmjvq+axcD+3dxrzCGPR9lZGwKc/aVdDAmMWfLjTOm0wJohyYxMvjzbMrTF0TA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216877;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qhlm2H67mtX7Y7m1F08MiXakDjxEuLYH26/+QV4eXHs=;
	b=t82pihfPw65eHWdTjKM4DNRG3IKU5YMs/Z/axX1mJoEo4ExCEWh5m6CEvJmGXrvzSU9n
	 tgrtp3kvWO3Y+u+1N9uQY7ZzhP3c9QYPSf9Ri0j6lm/vzrI3VzF6Fxa7dCmML4C4xNgJp
	 bwhiU2d5F3pf/ST64gkGWYyjKxoF9vJJWQqlHfYfLLEfjcxM2UhqRSU2uyqvAKCF0Vvjj
	 lM8HrT/4NaFQ0kMYZ7wtf3Lts+tNXqinKIV0RFYHLSmewwGXu4Jn/uaUK4BGa7L6R5psA
	 CZvIkY4iHglOXAebvrlD0Xgd7a3fk1gmgIdCrmT8P/iTrLD/BP+3O3lHmFFHXg3Xf0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="o1i9F5U/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C94606A31C;
	Wed, 28 Oct 2026 19:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o1i9F5U/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359251F01825;
	Wed, 28 Oct 2026 19:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216876;
	bh=qhlm2H67mtX7Y7m1F08MiXakDjxEuLYH26/+QV4eXHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o1i9F5U/URh05vS0e4nO4VEwfYqm17s6nqnSRyy3sHcd49CKaS0xZVSfmXRJK1wwd
	 snS5Fn3wu9T9L37pHJpzhb9VqKCrjs1B3PZw91VUIeqEvRHeowmAlGqSsdc1eO4dDN
	 KE596WMKFBgAExYtcBzTfguVv1uY3Fxy7yHTo2gY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1710/1887] ASoC: cs42l56: Put the Limiter Cushion control on the limiter register
Date: Wed, 28 Oct 2026 18:03:26 +0100
Message-ID: <20261028170538.371255343@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 203436d2aeb7093290459e344e1912a418a6ebfd ]

The Limiter Cushion control writes bits 4:2 of the ALC Thresholds
register. Those bits are ALCMIN, which the ALC MIN control owns. The
datasheet puts CUSH at bits 4:2 of the Limit Thresholds Control
register, next to LMAX, which the Limiter MAX control already uses.

So setting the limiter cushion changes the ALC minimum threshold, and
the cushion itself cannot be set.

Use CS42L56_LIM_THRESHOLD_CTL.

Fixes: 272b5edd3b8f ("ASoC: Add support for CS42L56 CODEC")
Link: https://statics.cirrus.com/pubs/proDatasheet/CS42L56_F2.pdf
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20261008130953.2446692-2-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l56.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l56.c b/sound/soc/codecs/cs42l56.c
index 3b0e715549c9c..206c45318ad4c 100644
--- a/sound/soc/codecs/cs42l56.c
+++ b/sound/soc/codecs/cs42l56.c
@@ -449,7 +449,7 @@ static const struct snd_kcontrol_new cs42l56_snd_controls[] = {
 			0, 0x3f, 0, 0),
 	SOC_SINGLE_TLV("Limiter MAX", CS42L56_LIM_THRESHOLD_CTL,
 			5, 0x07, 1, alc_tlv),
-	SOC_SINGLE_TLV("Limiter Cushion", CS42L56_ALC_THRESHOLD,
+	SOC_SINGLE_TLV("Limiter Cushion", CS42L56_LIM_THRESHOLD_CTL,
 			2, 0x07, 1, alc_tlv),
 
 	SOC_SINGLE("NG Switch", CS42L56_NOISE_GATE_CTL, 6, 1, 1),
-- 
2.53.0



