Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D857C143C5F;
	Tue, 23 Apr 2024 21:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908508; cv=none; b=dlRmBX2pg+zjU4ld+v9rMTHn8L+bKsgKT2zAGZZ3kualMhDW8zHLmUD9xvvMtUyH2XYwDpQONvenqpD5dk9DxJBajvy8R1h0l4jGqdU1e0dBFuf7zoy0LFPZ8c4iNuVepaJ+jyDkZON0NBUlK/cAsFmBqbCvZStR0ynMvcYOVjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908508; c=relaxed/simple;
	bh=t0g2+Sh36IZt1BtuSgL5MVZFAtcQ9MDN0y2huZBVdHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nhLTsIAGenwyg3AA9fjFsl4rVFX7bp+Ttqg8jxRd16PZG3RTFaJVp2CdE5U/r1MSBsaIO68624FsRBx8Yk5e1iSiV7t9yPJQ4GxHtJq39uEZKQ5fHBk/J1Cgjik7Axd4sbEl4NJ6D4rNULXJItHbAVh2qTWTCsGuTTFmzbKBG1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UU5OuED+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UU5OuED+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC59BC116B1;
	Tue, 23 Apr 2024 21:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908508;
	bh=t0g2+Sh36IZt1BtuSgL5MVZFAtcQ9MDN0y2huZBVdHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UU5OuED+TLCz1+4u8eiuLGvPmxpD96bP0oqVb6GXg8TBnsNIgWpLRzkAiwE4Ner1/
	 eW0rYyw5boJ451V+xGyvS3dy/ro6NRP6swx3NclDV+RWP65pjRk13oQIqryOXp36ka
	 MPBcomjt9vxIf3OyWJ7ANQk4OPzSgKUDhtLx5944=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.8 092/158] ALSA: hda/realtek: Add quirks for Huawei Matebook D14 NBLB-WAX9N
Date: Tue, 23 Apr 2024 14:38:34 -0700
Message-ID: <20240423213858.944980722@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab@kernel.org>

commit 7caf3daaaf0436fe370834c72c667a97d3671d1a upstream.

The headset mic requires a fixup to be properly detected/used.

As a reference, this specific model from 2021 reports
the following devices:
	https://alsa-project.org/db/?f=1a5ddeb0b151db8fe051407f5bb1c075b7dd3e4a

Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: <stable@vger.kernel.org>
Message-ID: <b92a9e49fb504eec8416bcc6882a52de89450102.1713370457.git.mchehab@kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10215,6 +10215,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1462, 0xb120, "MSI Cubi MS-B120", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb171, "Cubi N 8GL (MS-B171)", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x152d, 0x1082, "Quanta NL3", ALC269_FIXUP_LIFEBOOK),
+	SND_PCI_QUIRK(0x152d, 0x1262, "Huawei NBLB-WAX9N", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1558, 0x0353, "Clevo V35[05]SN[CDE]Q", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x1323, "Clevo N130ZU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x1325, "Clevo N15[01][CW]U", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),


