Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026640;
	b=bXO3Y4dwZ5radBRgUs9xY8s4THhEh4GPko30sEhy6OzQFZKMSHNKb2/r1ySZiU0W8kFh
	 6sUBuO3W+dC4OcSZxvBEHUJikYHsXaD9nCDlmRMyF2HFhAb05uLpSnfX+BqANhpyRIUGV
	 WTxYirSXUig0fdV37kEd7SCm08f5TdkH9pwF2ifuRg0zrJRXWrtH74kzve2vUgAp/iB/S
	 iiTwt4Qb0O5ZDSxdLNStOphC7tT6aufBzIW79AG5xDOswsc5b5wEWPXDag+vlWY3XkVC/
	 1cji1DwsHJOl57O7YliJ5yB4H0s9BLSgOtG3ig6eJNOnwgQGNzgvccWrVSR1fZya93A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026640;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L7L14aZQs32j9ORY+sWbcMpoQ3CSsbhAulNFt8zs8c4=;
	b=sxyFFgKOidK1rC5C94X5/iZYogXSXfs2Rrc3cfq/FIZnkN+NR5QYSKhAn8I/uG2B7S7o
	 S3iDSB46Z1j/F3ER7LT8UiG1joK8PFm3DdsWQ0nV+itGtNXJHrchvtFxmauScWjburDMl
	 MuGftlIaH1+vJrl0uXPQRuZ4vhFk2D/yM5qkeQ/Juo1bHQUO84H9vd7QzWX9zzS1yIDik
	 NPwuN5hBrTMDUbmWPu2trujKzhgwMoPa/7no2wkQ6LNqVB8y0u7uyBWQAtpEgpeIaBjlG
	 GOHLOMxSm+sVk14e6U4HGohLNJPirnFlGX4efe668Lsbb2p7kNBiI/A0UWAFSDnx6kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tnxJxR6t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1988E606A320;
	Wed, 18 Nov 2026 18:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tnxJxR6t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253641F000C4;
	Wed, 18 Nov 2026 18:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026639;
	bh=L7L14aZQs32j9ORY+sWbcMpoQ3CSsbhAulNFt8zs8c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tnxJxR6tYjkdejwWrZZTtq8ILqXAaYPKzLIwODe/wjo3dD3TUCFBQBbUUR0ZkIafh
	 3zN04aHANVJxEj6uXz6Wb4vIx3620MLnj7sGeEiEzDtZJoZw9BfdkJok07ars0AIjG
	 uGuvKj3zFxyNpBInSLu4QVBDTdZr5MyQTuWFvn6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1504/2151] ASoC: codecs: wm8990: Fix definition of LOMIX AINLMUX Bypass Volume control
Date: Wed, 18 Nov 2026 15:53:59 +0100
Message-ID: <20261118150216.657160394@linuxfoundation.org>
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

[ Upstream commit 75e0b607e3456c9eb15dfb783984f814a89cbcaf ]

The LOMIX AINLMUX bypass volume (LLBLOVOL) is at bits 2:0 of Output
Mixer5, not at bits 5:3, which hold the AINRMUX bypass volume
(LRBLOVOL).

Fixes: f10485e79882 ("[ALSA] ASoC: Add WM8990 driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/87b3bfa7711b61d89c21044d02fb3242dd934385.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8990.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8990.c b/sound/soc/codecs/wm8990.c
index a4cf405aa6ad1..9b7cf493ec516 100644
--- a/sound/soc/codecs/wm8990.c
+++ b/sound/soc/codecs/wm8990.c
@@ -112,7 +112,7 @@ SOC_SINGLE_TLV("LOMIX RIN3 Bypass Volume", WM8990_OUTPUT_MIXER5,
 SOC_SINGLE_TLV("LOMIX AINRMUX Bypass Volume", WM8990_OUTPUT_MIXER5,
 	WM8990_LRBLOVOL_SHIFT, WM8990_LRBLOVOL_MASK, 1, out_mix_tlv),
 SOC_SINGLE_TLV("LOMIX AINLMUX Bypass Volume", WM8990_OUTPUT_MIXER5,
-	WM8990_LRBLOVOL_SHIFT, WM8990_LRBLOVOL_MASK, 1, out_mix_tlv),
+	WM8990_LLBLOVOL_SHIFT, WM8990_LLBLOVOL_MASK, 1, out_mix_tlv),
 
 /* ROMIX */
 SOC_SINGLE_TLV("ROMIX RIN3 Bypass Volume", WM8990_OUTPUT_MIXER4,
-- 
2.53.0



