Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591502;
	b=Fhe0Ek9uYYaMLm54KdnZnaX4HnFa6LEPiyamvetVHtY3keGNHrmSHok1Ru2k5OzLiVih
	 UjgAmGtzgGxPqSYosoDfFmrOxbtpFjU/HikWDa76NHFVASxRFGPk5Er9p9qUd4CNFzYxn
	 hpC+pDxNwIJ7uyrAbxi1RXcvMVzfqrxmNQKVZzhyYPBJXKuulRxO8hu57DjU5pXEnY/Om
	 /b94Jd4RJC9QK+bOPqPKyoq8cyWkmB5ZlSKEKjLIw79cXiEor4qMYU6sIVSx2eRBq0VYy
	 Pycx6XaPZChvqfErWxnaoFoG4MLV24QqlnRSC46cVnQOzg2HFMBsuTBQVrnGbGqHJHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591502;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4Zlf/uSWLjOsNZEILpYGNVSokz/LduYpcgK9BBsczDw=;
	b=SLYqhOOIZXtXJCaxGbWgcEmSmvbsQ2AnsvNMwSHC63G/Bdysm9He1rHDoHAxI5ZMo6m3
	 VZRygHPPniVVzGm05wx8Aa03LfqC8hCQazU6oTT74Pg1b5pIzkTHuZgBKmMse8OilI+f+
	 CTD02O/IRdhnT9me2Uz5QisLzlFo6c95DqAaDbNaZxWcBW/h2meCi7ILt/adUmndJl3aC
	 Umdy5wV9IH25v7HIopBULKallGPDHUAbMfnaAX2D83OWbX3dLA+XyAaJMLEGNk4AIrrtJ
	 Rn70geJhPxEuwHwaYQWtAioU39oBBCxIf/IJKduFTuyWDUexKbRKgRxPwE8sPOArJnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GuonlMp7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23EF7606D491;
	Fri, 13 Nov 2026 17:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GuonlMp7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A081F000C4;
	Fri, 13 Nov 2026 17:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591502;
	bh=4Zlf/uSWLjOsNZEILpYGNVSokz/LduYpcgK9BBsczDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GuonlMp7EW1W9SiAjgsxMaUsx7TQfzjjXp4+7w7AH1lXkwUB2bh+RNp10zS+DJRUJ
	 4vgMjy3x7kerHP9ZMEuZmBm08yE5OHCJcI/fvWHmft6IrFt06fUTSe5fFTW8K1A60Q
	 IR7pl96x6sblRMN96xqRCdM3jUgX5M5KUMzeH/ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackie Dong <xy-jackie@139.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 577/670] ASoC: amd: acp: Add DMI quirk for Lenovo Yoga Pro 7 15ASH11
Date: Fri, 13 Nov 2026 10:52:21 -0500
Message-ID: <20261113153831.402765229@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jackie Dong <xy-jackie@139.com>

[ Upstream commit fc12cf16df9af867e1455b011cdd9310474a612e ]

Lenovo Yoga Pro 7 15ASH11 with AMD RYZEN AI MAX+ 388 (Strix Halo, ACP
7.0) uses Realtek ALC287 series codec and no any DMIC connected by ACP.
All DMICs directly connet with ALC codec.

Without this quirk, Input Device of Gnome Sound settings shows Internal
Stereo Microphone and Digital Microphone by default. In fact, Digital
Microphone of ACP doesn't work due to no connecting with ALC287 codec,
the Internal Stereo Microphone as analog device based on snd_hda_intel
driver can work well.

Add a DMI quirk to override the flag to 0, consistent with the existing
entry for the HN7306EA.

Signed-off-by: Jackie Dong <xy-jackie@139.com>
Link: https://patch.msgid.link/20260527102005.58528-1-xy-jackie@139.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 38cb2ef26b64 ("ASoC: amd: acp-config: force SoundWire probe on Dell 14S DS14265")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp-config.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/acp-config.c b/sound/soc/amd/acp-config.c
index cc3620db62bf1..a46b9a029cbb0 100644
--- a/sound/soc/amd/acp-config.c
+++ b/sound/soc/amd/acp-config.c
@@ -37,6 +37,13 @@ static const struct dmi_system_id acp70_acpi_flag_override_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Zenbook S16 UM5606GA"),
 		},
 	},
+	{
+		/* Lenovo Yoga Pro 7 15ASH11 (Strix Halo, ACP 7.0) */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83W5"),
+		},
+	},
 	{}
 };
 
-- 
2.53.0



