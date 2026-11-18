Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061673;
	b=WA9EwOrpssYMmnLjLCsE6lTNLqQcNCGfEbVppfdOizdHDSOR+DSk+1EQcueg6OekmFkK
	 MYd04qNwdYptQOy9KblcJ8u/gOkKEJwxZPlwa9eWlHsWVXw0/7Bzc6sJGD7u202iBCmfi
	 vkisDGOPtC7gvg6oOSW4mg1v2ku0gs+H1dZmzNT/UT8z3dSGOy2C+nz081qPgzGeoc4bd
	 gZPSbo8XcrZ7MRH1uqmBsggWSc5/9SQ9qISvhwdbU4lqE4hKitX6q38OBmfJv73GgwKuH
	 cEVuIh3CcH6vGTCipF7hufPRX/vp92m3nbFhKwAXeExxOqJG6CSOY6fuLS78Aj7xMUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061673;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dd8ZrlDHxv2mGdghVTgbqhPt1/SWwIrA6MoYr8w6VYQ=;
	b=SzPlRvrC6IU+ImRw8OGioaFIusDIAvjEMzKXJVSRLzrbhQIhTfAre2dCR3FT5wDzO/oc
	 l/NJSLysEMKKZZYWbMFlJEfMU/3H5omkqjNHKy3Lo7Y20fQurpmyxuzz6+OzH5Zufv95E
	 H2HvFWWgYCPstuN0dhgfTGEJTb8+Z2+RaHVCEKEuuee69pOYde8t53wOOR5zd91g44fHZ
	 4NILIlA3zSTUSLG5nYZqaWoEnynlgva6w9q4ek0uf/FZAQs1qBbJqKeHpPJww76d5UrmT
	 sn2ZS5qtL54VrWPlQULJjKxc/rAokNJM8LvegNbUr0uQ6RWlBzdWqY9oi0ArYlLM5pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JBtD6o8r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BC4606A320;
	Thu, 19 Nov 2026 04:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JBtD6o8r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9791F000C4;
	Thu, 19 Nov 2026 04:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061673;
	bh=dd8ZrlDHxv2mGdghVTgbqhPt1/SWwIrA6MoYr8w6VYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JBtD6o8rGu9c+sMeUCCwPOVf+nMyYWSuZAdAcw7GO7rb2s8nJ+lTRaxbEc6ZEElx+
	 cWUAnYrKoO224WshUX/s3wHTgUhtTuVCk3qkqT4plNPtaSsrQ6x9aTdsuhqoSd7TmR
	 LEHughSlNOgJzNluTCqaF74mG1vwXowuVX2zdpuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1635/1848] ASoC: codecs: wm8991: Fix definition of LOMIX AINLMUX Bypass Volume control
Date: Wed, 18 Nov 2026 16:01:13 +0100
Message-ID: <20261118150028.017443776@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit fee722db39c2a1f18c944f747271fd1e131910a6 ]

The LOMIX AINLMUX bypass volume (LLBLOVOL) is at bits 2:0 of Output
Mixer5, not at bits 5:3, which hold the AINRMUX bypass volume
(LRBLOVOL).

Fixes: 203db220718c ("ASoC: WM8991: Add initial WM8991 driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/c6e230b0e7d7e3db2136cc751e0b563030dbc16d.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8991.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8991.c b/sound/soc/codecs/wm8991.c
index 79f7a64845f78..92275d7f9994b 100644
--- a/sound/soc/codecs/wm8991.c
+++ b/sound/soc/codecs/wm8991.c
@@ -184,7 +184,7 @@ static const struct snd_kcontrol_new wm8991_snd_controls[] = {
 	SOC_SINGLE_TLV("LOMIX AINRMUX Bypass Volume", WM8991_OUTPUT_MIXER5,
 		WM8991_LRBLOVOL_SHIFT, WM8991_LRBLOVOL_MASK, 1, out_mix_tlv),
 	SOC_SINGLE_TLV("LOMIX AINLMUX Bypass Volume", WM8991_OUTPUT_MIXER5,
-		WM8991_LRBLOVOL_SHIFT, WM8991_LRBLOVOL_MASK, 1, out_mix_tlv),
+		WM8991_LLBLOVOL_SHIFT, WM8991_LLBLOVOL_MASK, 1, out_mix_tlv),
 
 	/* ROMIX */
 	SOC_SINGLE_TLV("ROMIX RIN3 Bypass Volume", WM8991_OUTPUT_MIXER4,
-- 
2.53.0



