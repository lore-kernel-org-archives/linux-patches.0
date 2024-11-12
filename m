Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E3C2141C4;
	Tue, 12 Nov 2024 10:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407410; cv=none; b=b8yegdELYQW0HbEkt9b58IqhS88jDxLNGKBd9ABGRwJwN/8k1jxd24gdUI7QRICCwHMG/HNsenRea/k0lb9wxfNOIUZyQ9gfyEImfowFA/MIKcUbXYfsbVF0OwdDKPfoq6fIC518UlXPdjEO9JcnKgO89Q34XRDDNDfUD0KPL2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407410; c=relaxed/simple;
	bh=zl6yLi0vwcZMz5lY5G8rpwQR+ezInt5Nrx0GL+1/NC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f37wM/ROvtfHEKmJZV1WbKynEyeCrODDOME0jo+SOaaAdfYa9gmQ8QPPDaXZI5QPltbDxgxvcatJKYjstz4ZlpD70Ofq3D3LIFf87eX15P1PV+d7B7YsqDqLXfoqlmkkrGvjbt2Jaf1a/AuS8vO/F5J2AvNXyTRWw12xROLJy9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kCBb1OGL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kCBb1OGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54AC7C4CED4;
	Tue, 12 Nov 2024 10:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407409;
	bh=zl6yLi0vwcZMz5lY5G8rpwQR+ezInt5Nrx0GL+1/NC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kCBb1OGL+1XRpi/WxNNyz5GNlrQuIqYiMP9Ez8qjDvWfhi/J9tQaqWgnHaYNjMy3F
	 3bqrFAjwgdY/XWRpwsE3V/przmQGYmabiDQGOZwpg8w/oZVZHJ7CKtMtlzPoZStVLn
	 Ala/NlSyWcDmV8b2X7EF7kj3o0EKUEnO1OWTr3Cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 67/98] ALSA: hda/realtek: Fix headset mic on TUXEDO Gemini 17 Gen3
Date: Tue, 12 Nov 2024 11:21:22 +0100
Message-ID: <20241112101846.810829818@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoffer Sandberg <cs@tuxedo.de>

commit 0b04fbe886b4274c8e5855011233aaa69fec6e75 upstream.

Quirk is needed to enable headset microphone on missing pin 0x19.

Signed-off-by: Christoffer Sandberg <cs@tuxedo.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241029151653.80726-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10015,6 +10015,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1558, 0x1403, "Clevo N140CU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x1404, "Clevo N150CU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x14a1, "Clevo L141MU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x28c1, "Clevo V370VND", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1558, 0x4018, "Clevo NV40M[BE]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x4019, "Clevo NV40MZ", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x4020, "Clevo NV40MB", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),


