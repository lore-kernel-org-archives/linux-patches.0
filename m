Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930A038A70C;
	Tue, 10 Mar 2026 11:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142032; cv=none; b=d9+7VcaP3LSs//rWo9T028iv00BrTAwk9GGvn9Ut8IrB8yxGjbChg56yS/TBBnLrhA2MiJpMWhHzt6RfB19hkkIy7kj6aZpN4kx+Pdx8IfYciHduGLYNEwL5f9tjbJVLKSUYTf1ZffYCkz2LWJtStJwzDR8qAaTYZQXl3fhA/es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142032; c=relaxed/simple;
	bh=i9vTgBhdGYtSgbHedKvlPjzhpLm4qwhBEduqgROpz6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EHQbhwaq001r8SYc4LeJoI5qXtlWnf0viaS8teEG8Ff+McR9zKTHSqz/TqJ+n51/z8AaRaZoj4ZivD+1BUXyMKfvbvopwD2K4wD6F2WmX099SXtDLnNeuka0TQL2wEEBsr1eycxDetrs+oLKJ8CCObDjrAaFH5kt8CFQlShU/AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g/O0mqjH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g/O0mqjH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA5EC2BC86;
	Tue, 10 Mar 2026 11:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142032;
	bh=i9vTgBhdGYtSgbHedKvlPjzhpLm4qwhBEduqgROpz6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g/O0mqjH4e0VzZM7r//unHS5imMYnG2bQhtsgIFpoeIN//c60jHZjU9IXkKh7M/ng
	 CVeWUM4cIcnbTDKWMe6BE13ljfGuCBFziLiq1eiuGNJ9KP18TrnhhjdLfzPMt/aMBi
	 UHoWEqi2QwmU2t+NYReWQTms1/8Aj5GJREm1MeYeW28v6yoqshSG34sbsmvVEo1bHn
	 H6oTV7b1w6N+bErUVdT6w7Ct1MPx+Ep8NHVk2HlhqTlASprcV+qZN75tcWRdQTb1S7
	 e3Ptis5suV2ygb97R+6RlvPeJdWTAGEnFC5+rb6P1iqLhc06mx5+ZarldnZkrJwVFu
	 uBrPtL5pYd5MQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Panagiotis Foliadis <pfoliadis@posteo.net>,
	Charalampos Mitrodimas <charmitro@posteo.net>,
	Takashi Iwai <tiwai@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 159/314] ALSA: hda/realtek: Add quirk for Acer Aspire V3-572G
Date: Tue, 10 Mar 2026 07:16:58 -0400
Message-ID: <686a34e921378b458570d4bc9c0f8a2f9588fcfc.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Panagiotis Foliadis <pfoliadis@posteo.net>

commit cbddd303416456db5ceeedaf9e262096f079e861 upstream.

The Acer Aspire V3-572G has a combo jack (ALC283) but the BIOS
sets pin 0x19 to 0x411111f0 (not connected), so the headset mic
is not detected.

Add a quirk to override pin 0x19 as a headset mic and enable
headset mode.

Cc: stable@vger.kernel.org
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221075
Suggested-by: Charalampos Mitrodimas <charmitro@posteo.net>
Signed-off-by: Panagiotis Foliadis <pfoliadis@posteo.net>
Reviewed-by: Charalampos Mitrodimas <charmitro@posteo.net>
Link: https://patch.msgid.link/20260221-fix-detect-mic-v1-1-b6e427b5275d@posteo.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 11c526d94858d..a094d60194b53 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6451,6 +6451,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x079b, "Acer Aspire V5-573G", ALC282_FIXUP_ASPIRE_V5_PINS),
 	SND_PCI_QUIRK(0x1025, 0x080d, "Acer Aspire V5-122P", ALC269_FIXUP_ASPIRE_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x0840, "Acer Aspire E1", ALC269VB_FIXUP_ASPIRE_E1_COEF),
+	SND_PCI_QUIRK(0x1025, 0x0943, "Acer Aspire V3-572G", ALC269_FIXUP_ASPIRE_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x100c, "Acer Aspire E5-574G", ALC255_FIXUP_ACER_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x1025, 0x101c, "Acer Veriton N2510G", ALC269_FIXUP_LIFEBOOK),
 	SND_PCI_QUIRK(0x1025, 0x102b, "Acer Aspire C24-860", ALC286_FIXUP_ACER_AIO_MIC_NO_PRESENCE),
-- 
2.51.0

