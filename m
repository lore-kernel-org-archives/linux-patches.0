Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA3B804
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CBD7C433D2;
	Mon, 12 Jun 2023 10:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566246;
	bh=v+8V7IHgjudlXBSY5/7wBPN1jlBhuKfo4IMnQFJmWtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQZn3gPqE9VFL0sjVH5RHGKJ8SKJchUzdUcKes+Gc7LwKpFDxFXbcf49Z/jJi8+7I
	 9OYNzH2/roh9JWrr+v1kQN4kr5aP6KGzRY0VoY6opyyq2YRSnv6dm0ZaIW3qqc2iKZ
	 s8ag15Pw2WScehBJmsjfeyD3aeWRzsFHoSwHwDf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Crawford <tcrawford@system76.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 51/91] ALSA: hda/realtek: Add quirk for Clevo NS50AU
Date: Mon, 12 Jun 2023 12:26:40 +0200
Message-ID: <20230612101704.199882968@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101702.085813286@linuxfoundation.org>
References: <20230612101702.085813286@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tim Crawford <tcrawford@system76.com>

commit da209f7a80dd633a32cbcbafe9e9f778933119c1 upstream.

Fixes headset detection on Clevo NS50AU.

Signed-off-by: Tim Crawford <tcrawford@system76.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230605163834.24653-1-tcrawford@system76.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9205,6 +9205,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1558, 0x5101, "Clevo S510WU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x5157, "Clevo W517GU1", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x51a1, "Clevo NS50MU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x51b1, "Clevo NS50AU", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x5630, "Clevo NP50RNJS", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x70a1, "Clevo NB70T[HJK]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x70b3, "Clevo NK70SB", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),


