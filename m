Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5592B18953C;
	Tue, 10 Sep 2024 09:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961505; cv=none; b=cLb9Jl4AAZlgO9E0hwY4bLPeO8tt7ki0TnmOGY4P0OWAZwIw6v9Z33+kT3IJR/rgldIGWLA5SEr3Gox96axAi+9/eQeB5/dOKzi1kCILPXMzilkw6e0uyVs6pgZTlyS2ISLPk0gV5BRD44XQgoIbOkWoRvZDPhcR9xwlMIRhMTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961505; c=relaxed/simple;
	bh=QGB4i23Fw5hkPUR1+9bx1IOWqUn4gRUgontVFmxKQy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BINVs3zoYvELxjInBvtQsTbTBnBj4SGdvRlhwBq0WQ+97f3jLHfnvzwLh34gX4Ab3HK5k+NFq/3vXnQPOf5FwWfXt2IOx97E9Hm167d6+WDpq7Xe4vBpBCXT9GsUXMHePbKp7/4arNlJmgBpKg7lqv0sraZc1ZL/JPwueeTvZHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=my2AoB8G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="my2AoB8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E93C4CEC3;
	Tue, 10 Sep 2024 09:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961505;
	bh=QGB4i23Fw5hkPUR1+9bx1IOWqUn4gRUgontVFmxKQy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=my2AoB8GQUxnKHk9M2ODDU8dvcE5QzdhG6JwXC8pyWMyi/tsK3HcVkMkF8nEqh4Am
	 AWyD8QbSP+s0uchaLmJsqL3LQ7bOY6Ye8Mr884vYNsunG2eW9BEpAxFWgMfO6shbS7
	 duT79GJFALQzBhPGxPEBJFPMZKywilz094Xid2OU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 092/375] ALSA: hda/realtek: extend quirks for Clevo V5[46]0
Date: Tue, 10 Sep 2024 11:28:09 +0200
Message-ID: <20240910092625.335866886@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>

commit 562755501d44cfbbe82703a62cb41502bd067bd1 upstream.

The mic in those laptops suffers too high gain resulting in mostly (fan
or else) noise being recorded. In addition to the existing fixup about
mic detection, apply also limiting its boost. While at it, extend the
quirk to also V5[46]0TNE models, which have the same issue.

Signed-off-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240903124939.6213-1-marmarek@invisiblethingslab.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7526,6 +7526,7 @@ enum {
 	ALC256_FIXUP_CHROME_BOOK,
 	ALC287_FIXUP_LENOVO_14ARP8_LEGION_IAH7,
 	ALC287_FIXUP_LENOVO_SSID_17AA3820,
+	ALC245_FIXUP_CLEVO_NOISY_MIC,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -9857,6 +9858,12 @@ static const struct hda_fixup alc269_fix
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc287_fixup_lenovo_ssid_17aa3820,
 	},
+	[ALC245_FIXUP_CLEVO_NOISY_MIC] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc269_fixup_limit_int_mic_boost,
+		.chained = true,
+		.chain_id = ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -10496,7 +10503,8 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1558, 0xa600, "Clevo NL50NU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0xa650, "Clevo NP[567]0SN[CD]", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0xa671, "Clevo NP70SN[CDE]", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
-	SND_PCI_QUIRK(0x1558, 0xa763, "Clevo V54x_6x_TU", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0xa741, "Clevo V54x_6x_TNE", ALC245_FIXUP_CLEVO_NOISY_MIC),
+	SND_PCI_QUIRK(0x1558, 0xa763, "Clevo V54x_6x_TU", ALC245_FIXUP_CLEVO_NOISY_MIC),
 	SND_PCI_QUIRK(0x1558, 0xb018, "Clevo NP50D[BE]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0xb019, "Clevo NH77D[BE]Q", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0xb022, "Clevo NH77D[DC][QW]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),


