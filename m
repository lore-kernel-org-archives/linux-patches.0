Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263E11C1AAA;
	Tue, 12 Aug 2025 19:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025307; cv=none; b=Gu42jJr/2EW7wAVq8xYeLjWGH16yO4LRp8QVkPep+uLHqCj2QJxVtVwAxbZlm/tNwSmiI25lvrFIx7IPGVXR0XL6lNPQMEBNlr5BaJm8xldhnjxCSzpHqPjvLgMDPVfBn8hWqVajGMGMXHcUBYI9jm16vzRmeZfrgpvIQTKh/RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025307; c=relaxed/simple;
	bh=U7sJeUyvYbPUy+yWz+vQ5StxMx78o8BOXvBIKi/Nj5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ri97SOhCTRd98XpPdLlGbrYxMeIJ3B32M2IFxLUUle9d4zRZByTZkbLtc9ucm61br0h10UUU3UEaBSfN6/2zZ93BBNWQFSUwTi4I+qRR/AEHRiaOY1Ju1tDn7y3xduL1YkD1faBg8w+LI5EVYyAMgVmglEmwnZqro4AdTx8vZgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JoIa9iTX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JoIa9iTX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F00C4CEF0;
	Tue, 12 Aug 2025 19:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025304;
	bh=U7sJeUyvYbPUy+yWz+vQ5StxMx78o8BOXvBIKi/Nj5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JoIa9iTXI594Gb3uuWjVcliHXVnigNZgQsjLT6z0hD/rfKeHH2Av3g4LCHWPzdeDU
	 SWbVGEAS+B6O4Rq81NX4RuDXMsZwC9ODpd79ePOy/41AcZtZe+C10DqbHsuufBcs5K
	 ILGKQaIAhkr1rYh0FQhdrCVyKf2ovYQYjmCz4kjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edip Hazuri <edip@medip.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.16 601/627] ALSA: hda/realtek - Fix mute LED for HP Victus 16-d1xxx (MB 8A26)
Date: Tue, 12 Aug 2025 19:34:56 +0200
Message-ID: <20250812173454.731269716@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edip Hazuri <edip@medip.dev>

commit a9dec0963187d05725369156a5e0e14cd3487bfb upstream.

My friend have Victus 16-d1xxx with board ID 8A26, the existing quirk
for Victus 16-d1xxx wasn't working because of different board ID

Tested on Victus 16-d1015nt Laptop. The LED behaviour works
as intended.

Cc: <stable@vger.kernel.org>
Signed-off-by: Edip Hazuri <edip@medip.dev>
Link: https://patch.msgid.link/20250729181848.24432-4-edip@medip.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10764,6 +10764,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8a0f, "HP Pavilion 14-ec1xxx", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a20, "HP Laptop 15s-fq5xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8a25, "HP Victus 16-d1xxx (MB 8A25)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
+	SND_PCI_QUIRK(0x103c, 0x8a26, "HP Victus 16-d1xxx (MB 8A26)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8a28, "HP Envy 13", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a29, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a2a, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),


