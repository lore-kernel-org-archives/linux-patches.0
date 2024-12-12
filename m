Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7792144C4;
	Thu, 12 Dec 2024 17:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024263; cv=none; b=eb+YMODZs4yJXL0z8BYvZXO3Bk3eHROnSqRlKmhyozdIUb3PpSxi1EKQ01LmNllTj5zEjr1cdN/Tw3nw+dapEqqDBq5B2OEuXwdwMBzg3SBrORxb8d9G5N84CHzzZvO4d34caYKdVQuHIMU7+brtXGg4VRW3PWfLea25EbSMG1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024263; c=relaxed/simple;
	bh=TvipWEvUnxkV5p0wKtkvFAVUiDXZqConNGrDw+SOdBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SsvBNZy+7rc7LtBz6DdLxGP8Mf35FMJILlROHEe0MpjW39M+4MWtQdlur2kBNFbV0BQKr0Nm6BAo5AyHdowD6gBsxrYfQJkLU56VQyDK80PhndvMtpMOvqnXyLMOFAptAfzUxCg9M5Lj4EkPtgSvs3IoGDPoIT0aq95Xs+o6SqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iZvm+HLH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iZvm+HLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D77EC4CECE;
	Thu, 12 Dec 2024 17:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024262;
	bh=TvipWEvUnxkV5p0wKtkvFAVUiDXZqConNGrDw+SOdBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iZvm+HLHIrruyKNuveQib22ypIIMUi7YtM3e80xYlFFl/ReLZNT+WZvgKcow4z+qy
	 mby31qwNMfaJlbtIaOzpRcqvZ1iYvQBUd6I3be7+if9oBxbv6UQJV1qzOMXmIL53Dr
	 Zb7h8vnzpXrZEQ1zeYmQopjgdBd/us10fnFk1Eas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 238/459] ALSA: hda/realtek - Add type for ALC287
Date: Thu, 12 Dec 2024 15:59:36 +0100
Message-ID: <20241212144302.979496047@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit 99cee034c28947fc122799b0b7714e01b047f3f3 ]

Add independent type for ALC287.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/r/2b7539c3e96f41a4ab458d53ea5f5784@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: cc3d0b5dd989 ("ALSA: hda/realtek: Update ALC256 depop procedure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index e9b7bf94aa3a8..b1dbb0b4c8158 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3168,6 +3168,7 @@ enum {
 	ALC269_TYPE_ALC257,
 	ALC269_TYPE_ALC215,
 	ALC269_TYPE_ALC225,
+	ALC269_TYPE_ALC287,
 	ALC269_TYPE_ALC294,
 	ALC269_TYPE_ALC300,
 	ALC269_TYPE_ALC623,
@@ -3204,6 +3205,7 @@ static int alc269_parse_auto_config(struct hda_codec *codec)
 	case ALC269_TYPE_ALC257:
 	case ALC269_TYPE_ALC215:
 	case ALC269_TYPE_ALC225:
+	case ALC269_TYPE_ALC287:
 	case ALC269_TYPE_ALC294:
 	case ALC269_TYPE_ALC300:
 	case ALC269_TYPE_ALC623:
@@ -10250,7 +10252,6 @@ static int patch_alc269(struct hda_codec *codec)
 	case 0x10ec0215:
 	case 0x10ec0245:
 	case 0x10ec0285:
-	case 0x10ec0287:
 	case 0x10ec0289:
 		spec->codec_variant = ALC269_TYPE_ALC215;
 		spec->shutup = alc225_shutup;
@@ -10265,6 +10266,12 @@ static int patch_alc269(struct hda_codec *codec)
 		spec->init_hook = alc225_init;
 		spec->gen.mixer_nid = 0; /* no loopback on ALC225, ALC295 and ALC299 */
 		break;
+	case 0x10ec0287:
+		spec->codec_variant = ALC269_TYPE_ALC287;
+		spec->shutup = alc225_shutup;
+		spec->init_hook = alc225_init;
+		spec->gen.mixer_nid = 0; /* no loopback on ALC287 */
+		break;
 	case 0x10ec0234:
 	case 0x10ec0274:
 	case 0x10ec0294:
-- 
2.43.0



