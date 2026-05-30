Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDAA26738C;
	Sat, 30 May 2026 18:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166335; cv=none; b=rinsWHPsptEYpsqbSb4CXmi/LjXp6AquzFu3BpUKrfjCx8cxa+JnmZAaoi3iETRlgpDRUF2vlg14PCTat2SzixJfJRCfrSRWu/vSqe7FeExMx0zTA10x92QjY3Ok8TwXRuJSJSIcPleHoe/0m+icDFYkDQD4Ke3CGaVSjfkUcJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166335; c=relaxed/simple;
	bh=nECAMRPOPT2P9yOlB3BVMfQYo0TyUdv/e/VyYYgHYbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVmHC9iGmHUC+i4th7fccGHrpEZaOuAb+4O9kZRtm7ph2h0xszATunJTSnc1dAsIxF2gNo7BydYnpOsr1VXUrwmV6dtpPWNi8LgVUc+F3dYmzmCAPj6jb4yjKmZZtpHhnf+6EGS2XbbZggE/o8lyFaLvz2U//MRoBzEG3wUhea4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TVGL7AgK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TVGL7AgK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF221F00893;
	Sat, 30 May 2026 18:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166333;
	bh=uEK3iGaQJsOhhcLBdArg6UbZg3robb5OtDlcYEljjK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TVGL7AgK93p5VUZ9nW9dOjz7NpM9GjW/nV3gSBXHCZmp5sSsV3FCRVn/T6+jQzM2i
	 weH9KG7uZ5M8dK/DV6tjfwCCUU64jk3rJjaL4bf+8o9WpD97bzzcNLQ99fF/2/BwVP
	 P2hDbx21Fy02QIT1f7Bzx+11PmKoqSvprZyKo/pM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luke D. Jones" <luke@ljones.dev>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 342/589] ALSA: hda/realtek: Whitespace fix
Date: Sat, 30 May 2026 18:03:43 +0200
Message-ID: <20260530160233.879338821@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

From: Luke D. Jones <luke@ljones.dev>

[ Upstream commit 72cea3a3175b50a4875b3c112fb13df20c6218a5 ]

Remove an erroneous whitespace.

Fixes: 31278997add6 ("ALSA: hda/realtek - Add headset quirk for Dell DT")
Signed-off-by: Luke D. Jones <luke@ljones.dev>
Link: https://lore.kernel.org/r/20230704044619.19343-6-luke@ljones.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: d1888bf848ad ("ALSA: hda/realtek: fix code style (ERROR: else should follow close brace '}')")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index d673e8934b775..4eddc032b3d9a 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5954,7 +5954,7 @@ static void alc_fixup_headset_mode_alc255_no_hp_mic(struct hda_codec *codec,
 		struct alc_spec *spec = codec->spec;
 		spec->parse_flags |= HDA_PINCFG_HEADSET_MIC;
 		alc255_set_default_jack_type(codec);
-	} 
+	}
 	else
 		alc_fixup_headset_mode(codec, fix, action);
 }
-- 
2.53.0



