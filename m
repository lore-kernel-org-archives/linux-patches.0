Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061131;
	b=xUzYbDZ3gdBdVOMR/TYuEzXfyv6pWxUvU1JtvAqJhZCFvu1QLWVkRmn3k31mFMBVxFq3
	 u6YbNYT7jcRS12v5Vyykwd0sZkV9gYIPy4sAyoZ8sxXJMx1gH04WXGSQriorYZxQLaKDt
	 aYoGzR0ALbRwzouIxjqxV+/4rjbKZfQJO5EOFmjTTuRoR4HyJhK/rN7cv2os8eiIUnJNS
	 J2lbgfSDObPfUTnVrPAhJzjIPG6gy/sgD+WSAWB44lcbgA0xIhC6b73PXTf+aLGsC/x5C
	 1r3IBxEkl3x9nrbdmALumlgNbJuQuU0Bo0KuiPpgIVoV3IYNsVI2hGGllLFJi7Kf+Sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061131;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hr7i+8cN1d/x0re1f+MCnnBhkwvVbwzd7cjpTIwAz2s=;
	b=kCOPYvrAkjfRzw6G0KgRK/jm4hYRLkJEYLkbrzpS9qEh0WTe1f77Tv145wixXMgmyB+2
	 HTM0MU7qy7Py0qPj9R9KE+5GmNl9u1+4h+BG23SNk8Nt6REf2LM7DNMJQQkOE7W36gZOj
	 tlFc+InVWJUclok5UDMP7DN55sCqMXiBa+rzElkerEqwbc77YNl8QL2T+S/nSvI2YkGa1
	 feEiT00VoGnQMS7wefSlIzARlEbAlcu8UCKyy0fQSHngjH2KkugjHeqKjuMWPgK91gRj7
	 CY5MMwYY2Eqb6pTNGuOvn6/kfrE62b2bp2A8+AhTBaLGcyWn6C1SRWXT9q46G2z0g0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A6MrQt4j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EB7606A332;
	Sat,  7 Nov 2026 14:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A6MrQt4j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551C91F0089F;
	Sat,  7 Nov 2026 14:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061130;
	bh=Hr7i+8cN1d/x0re1f+MCnnBhkwvVbwzd7cjpTIwAz2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A6MrQt4j+jvD79UY1LR8fRnT/jT4/DZYb+wwrqZLjzvjAKfHuWBAvv7QZVTG8hAUn
	 NjzALzwYdOQLHA/TBOTRuoeMP4ZWDOB84I4xlRI8Vb5HplON0oMTyxvkk+CIu+FjwF
	 kkzvHAxyiPnscwXLiPLtvIYjymC6HslVE5uEIMag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	KIM MinWoo <phrimm136@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0414/1536] ALSA: hda/realtek: Add quirk for Lenovo ThinkBook 16p Gen 3 ARH (21EK)
Date: Sat,  7 Nov 2026 08:40:30 -0500
Message-ID: <20261107135009.198205778@linuxfoundation.org>
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

From: KIM MinWoo <phrimm136@gmail.com>

[ Upstream commit 3867e38b2d4b844d89076f988c7b9741c87a9858 ]

The ThinkBook 16p Gen 3 ARH (SSID 17aa:3871) has a TI TAS2563
amplifier device on I2C, exposed by ACPI as INT8866, the same
arrangement as the Yoga 7 14ARB7 (SSID 17aa:3870). Without a quirk,
the codec falls back to the vendor-wide Lenovo quirk
(ALC269_FIXUP_LENOVO_XPAD_ACPI), the amplifier is never bound, and the
internal speakers stay silent while the headphone output works.

Reuse the Yoga 7 14ARB7 fixup, which binds the INT8866 device as a side
codec. ALC287_FIXUP_TAS2781_I2C does not work on this machine because it
looks for a TIAS2781 device.

Assisted-by: LLM
Signed-off-by: KIM MinWoo <phrimm136@gmail.com>
Link: https://patch.msgid.link/20260923013756.106033-1-phrimm136@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 8847d06fcba79..52aba6f9ce6f2 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11610,6 +11610,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	HDA_CODEC_QUIRK(0x17aa, 0x38a8, "Legion Pro 7 16ARX8H", ALC287_FIXUP_TAS2781_I2C), /* this must match before PCI SSID 17aa:386f below */
 	SND_PCI_QUIRK(0x17aa, 0x386f, "Legion Pro 7i 16IAX7", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3870, "Lenovo Yoga 7 14ARB7", ALC287_FIXUP_YOGA7_14ARB7_I2C),
+	SND_PCI_QUIRK(0x17aa, 0x3871, "Lenovo ThinkBook 16p Gen 3 ARH", ALC287_FIXUP_YOGA7_14ARB7_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3874, "Legion 7i 16IAX7", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3877, "Lenovo Legion 7 Slim 16ARHA7", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3878, "Lenovo Legion 7 Slim 16ARHA7", ALC287_FIXUP_CS35L41_I2C_2),
-- 
2.53.0



