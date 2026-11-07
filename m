Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060877;
	b=wVouTZ23ymnvKKBSmkTgvp7z5teags0ZJBcXySYrlIn1GWdwOzEACz+ZG2jbRhrav1Yh
	 BftzIEhnZU+wNo6wEEwbD1eleWmVZ2Gk/L6+OmOTmEuhxoQ9WKj/V2ZZawb7FgqcenhdB
	 p8KeJoB8atqtttFJwemLS+g9JxQs2Cxf3gjyFyzUlaJJT3zEnY5sfBBJ6y7px9iShkNS5
	 tlKlCTnukTeqGn3gWd2klxafvQGBsLTwRQ3q+N9I3PHySOWH1LnydGpNFcgsB2HwEv1jp
	 dqh31a7upyUSTNKxBKklb0BSAzrJR3UIHOAWmdMwDcgiFT8WeqhLBN2hx81hCteAIPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060877;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jINyvYZKMvlqyQqwKDG/399GChbgr/ROuj6TqUyZRW8=;
	b=LHHVdMPBAY46FbokCEpD0FGZZw/uisogSK4M6agsSuBzsuq4bPlwjIkoQ/IrEBahOvxZ
	 IqwjCFd0R18leqHxWglpl1x56AUTN6Tjv2kTjeaTCn8Q5ezHJjiTfrBhcTsSpyAl4Fq6T
	 wMSXar6r62zQ0vpX5TaWcc1zKSh4YKnbTIRwYgObM3JMdDWsJg0edgLgLnVpi86EP2K9F
	 YGBftHyC7zVH1Pnp863cgPID+kNMcOMa7qKLasgn325PZRSaIhrdY7cw/kPwPeDS8QOsR
	 bywMy9YzuaIynpc1zZpOmvt66QF0YVVeYrjB+Kjz/51JOzM/i+bE7Ek6BZty6f9ue8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DCxMcwWy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4192D606D80D;
	Sat,  7 Nov 2026 14:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DCxMcwWy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F611F0089F;
	Sat,  7 Nov 2026 14:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060877;
	bh=jINyvYZKMvlqyQqwKDG/399GChbgr/ROuj6TqUyZRW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DCxMcwWy1Z78MFieWwKPCEwhfu48gyJmPW09LptK8ZESJ7rGQElTwtyVM4/U4eAiw
	 ZNii6DiyMikX85IQEHD0KmiFlm6RWhqn7ftsbNxV6fZsoi9F1dj40gz5rMPXJo8DDZ
	 Qr8PK/cYDZsoJO9yNzs6Qm1JGqhuAlQhskZRZybw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauricio Orozco <maudob@live.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0258/1536] ALSA: hda/realtek: Add quirk for ASUS VivoBook M515DA/X515DAP
Date: Sat,  7 Nov 2026 08:37:54 -0500
Message-ID: <20261107135004.931654350@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauricio Orozco <maudob@live.com>

[ Upstream commit a9fa2a016e805504223abf8c9b373ac9f7bfb9b3 ]

The ASUS VivoBook M515DA/X515DAP (subsystem ID 1043:1e3e)
requires the ALC256_FIXUP_ASUS_MIC_NO_PRESENCE fixup to
enable the internal microphone.

Without this quirk, the internal microphone captures only
silence under Linux, while it works correctly under Windows.

The fix has been verified on real hardware.
Tested on an ASUS VivoBook M515DA/X515DAP running Linux Mint
22.3 with Ubuntu HWE kernel 7.0.0-28.

Signed-off-by: Mauricio Orozco <maudob@live.com>
Link: https://patch.msgid.link/20260730033506.8958-1-mauoro3@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index eff234786c162..bb02bc8962713 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11291,6 +11291,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1df3, "ASUS UM5606WA", ALC294_FIXUP_BASS_SPEAKER_15),
 	SND_PCI_QUIRK(0x1043, 0x1e02, "ASUS UX3402ZA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1e10, "ASUS VivoBook X507UAR", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1043, 0x1e3e, "ASUS VivoBook M515DA/X515DAP", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1e11, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA502),
 	SND_PCI_QUIRK(0x1043, 0x1e12, "ASUS UM3402", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1e1f, "ASUS Vivobook 15 X1504VAP", ALC2XX_FIXUP_HEADSET_MIC),
-- 
2.53.0



