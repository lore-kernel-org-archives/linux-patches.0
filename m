Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9BE1A9B2A;
	Wed, 20 Nov 2024 12:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107530; cv=none; b=pwpIrNgyeH15zA/Gjst4ByYJCL+8/9HTbTXETawnOxRVtxoBrAZxLp0W0r+k9KzdohXXogY2rIJd6YNCbRDRQZZU7XoymwPNCXs2Wz2UG2zr4LF6TvtJggxdpR/GHLPp3RHE1BFExF+OclRtmV6bTaVKxeEVjYOPgBNISW7QQok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107530; c=relaxed/simple;
	bh=vIAaEV7X0yiEGbhNmeZqqktxlPM9dALCzGasAB4Wcx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p690zSBEDZGlt2mPWNpiNmEtP9BHzgAzBfdied1D1SufA9dhRcNV6A5cODwNOWFaOPc6J/W4xY96Gib6qSvqbpiwHV6n45+mAGAYyRl6Uh1FynbeeuY+FryHlVvnI2yVOr/wkxHQX4tEfA3TTGH0aKyWfIBQIyMNRfL/BmeqhGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GvA1qFkl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GvA1qFkl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C305AC4CED6;
	Wed, 20 Nov 2024 12:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107529;
	bh=vIAaEV7X0yiEGbhNmeZqqktxlPM9dALCzGasAB4Wcx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GvA1qFklW/h+bfqtauzhGJh0ppv1RXZLaFWj3euTdTUKdCYITsF9YnMivoCcB3PFO
	 nxJ/TIm3H+TBWInSSoE+t/Ar4/3LjQeIRJJQdpwdEGgGWkofJyP9ONGxH9OrUOvj8O
	 i+I4fcn/twwyGzFAjHWjC+1dbXspWibkARoNRoRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.11 062/107] ALSA: hda/realtek - Fixed Clevo platform headset Mic issue
Date: Wed, 20 Nov 2024 13:56:37 +0100
Message-ID: <20241120125631.076088829@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit 42ee87df8530150d637aa48363b72b22a9bbd78f upstream.

Clevo platform with ALC255 Headset Mic was disable by default.
Assigned verb table for Mic pin will enable it.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/b2dcac3e09ef4f82b36d6712194e1ea4@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11664,6 +11664,8 @@ static const struct snd_hda_pin_quirk al
 		{0x1a, 0x40000000}),
 	SND_HDA_PIN_QUIRK(0x10ec0256, 0x1043, "ASUS", ALC2XX_FIXUP_HEADSET_MIC,
 		{0x19, 0x40000000}),
+	SND_HDA_PIN_QUIRK(0x10ec0255, 0x1558, "Clevo", ALC2XX_FIXUP_HEADSET_MIC,
+		{0x19, 0x40000000}),
 	{}
 };
 


