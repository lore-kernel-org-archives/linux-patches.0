Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4CB1B042E;
	Tue, 17 Feb 2026 20:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361086; cv=none; b=N76Ds1aSGvLocLInSwjc1bFAfDf8/KY6ns65wc6ZdtyOBkzH2Y9YI48RgCFmSTu0b7z9veRkATMdRV9I1rXXmdvmZ9CPh7jMklHY6pLoVeGwAF8NPY+u0KRildAGcNKiQqPfAfjlsaLKQxFXQyFmb+UkuM+PfLGp9QM51OqXQCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361086; c=relaxed/simple;
	bh=RCBcu65t1E2sAIquLy+16+GTd4f7uOn1bcRfIlSQP0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLxedV/jfamId2xSiofua4KvheJedsHNqElqMiBEBzVP+BYs8D4e0UwdTjKNBkjBCTSWzH25qzgcBGMHcGsrnnbgCIqeHAv7yoGlp4EnGbZGF63wg1/FlBCPjInDDIOuuJ7P1nvh4y6qUtYjRiAL3FwXeW7Y9QHnHWfENDlV4tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gCnsfFp0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gCnsfFp0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50179C4CEF7;
	Tue, 17 Feb 2026 20:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361086;
	bh=RCBcu65t1E2sAIquLy+16+GTd4f7uOn1bcRfIlSQP0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gCnsfFp0kXO1u4KgLfnQ1aP4JfwPJjtvSj1tQC6kdI7AEmasQOzB9hlleBZ/NngnA
	 o9VVU6y0nSvlvbMnn521Z5Llwnaz0zXwRiwnnNF1StXkmh91s9Lpz/1x4PjNSnvd4O
	 pjzuNfZSij+fHxVfICL/m+Ea5roNRyShtdK2ZPVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Guttzeit <t.guttzeit@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 09/39] ALSA: hda/realtek: Fix headset mic for TongFang X6AR55xU
Date: Tue, 17 Feb 2026 21:31:18 +0100
Message-ID: <20260217200003.288021978@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200002.929083107@linuxfoundation.org>
References: <20260217200002.929083107@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Guttzeit <t.guttzeit@tuxedocomputers.com>

[ Upstream commit b48fe9af1e60360baf09ca6b7a3cd6541f16e611 ]

Add a PCI quirk to enable microphone detection on the headphone jack of
TongFang X6AR55xU devices.

Signed-off-by: Tim Guttzeit <t.guttzeit@tuxedocomputers.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20260119151626.35481-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 839a7e957d42a..72d9ea5171bbd 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10133,6 +10133,10 @@ static const struct snd_hda_pin_quirk alc269_pin_fixup_tbl[] = {
 		{0x12, 0x90a60140},
 		{0x19, 0x04a11030},
 		{0x21, 0x04211020}),
+	SND_HDA_PIN_QUIRK(0x10ec0274, 0x1d05, "TongFang", ALC274_FIXUP_HP_HEADSET_MIC,
+		{0x17, 0x90170110},
+		{0x19, 0x03a11030},
+		{0x21, 0x03211020}),
 	SND_HDA_PIN_QUIRK(0x10ec0282, 0x1025, "Acer", ALC282_FIXUP_ACER_DISABLE_LINEOUT,
 		ALC282_STANDARD_PINS,
 		{0x12, 0x90a609c0},
-- 
2.51.0



