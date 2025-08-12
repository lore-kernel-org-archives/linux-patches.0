Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6931729BD9D;
	Tue, 12 Aug 2025 19:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026851; cv=none; b=QB8yD120LgPDeJMwjcejMnUXSGHa5a96TWmVfaLpgZVlCm64bQE3D5WN3frY3ZD7ITdCry2MT5UWFGSfNVIwMenLygTnhBiF9bWHQLrePTVTaPq43aqPCaER/h67tUepopGKddahJKpPTob0K75TT6acBhsRpYboS+WMBMLF/AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026851; c=relaxed/simple;
	bh=Q2q1TsuBAaUxUgfQVN4zx/LZ4Sw5mO1abhf9IU0QtH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chlanFKwAD5VNG/WfrTco93kotrqN6cUUozqBXvA4QCNoEvkyKr+22c18wZsmEv4II2kRR5cskCOX4wSsExEROxuZr4A40lXkwCOuQW/Oszmthf3iNtNVuDDGBWtJX0P9W9OKQVCRvQAEBbVQcz9RS1fMuwGPbd2mgAnBkvDvUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X3/NLTAF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X3/NLTAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FA2C4CEF0;
	Tue, 12 Aug 2025 19:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026851;
	bh=Q2q1TsuBAaUxUgfQVN4zx/LZ4Sw5mO1abhf9IU0QtH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X3/NLTAF8Y3AzJI7T2zT1O0lNC79tNvKntGxFv4S5HFaT8lnWtq742PS+PJk63G5O
	 IwZPPNbuHDzrxsc8ww0gICwZ1Rn1i4Ln7C38oQ7U0YDhw+kQSQ55FKo9+2MzT65AUF
	 qI3ogKgzQQsbij7P9EZrHmbO952J0bRAme6H+8ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edip Hazuri <edip@medip.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.15 459/480] ALSA: hda/realtek - Fix mute LED for HP Victus 16-r1xxx
Date: Tue, 12 Aug 2025 19:51:07 +0200
Message-ID: <20250812174416.326979796@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edip Hazuri <edip@medip.dev>

commit bd7814a4c0fd883894bdf9fe5eda24c9df826e4c upstream.

The mute led on this laptop is using ALC245 but requires a quirk to work
This patch enables the existing quirk for the device.

Tested on Victus 16-r1xxx Laptop. The LED behaviour works
as intended.

Cc: <stable@vger.kernel.org>
Signed-off-by: Edip Hazuri <edip@medip.dev>
Link: https://patch.msgid.link/20250725151436.51543-2-edip@medip.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10851,6 +10851,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8c91, "HP EliteBook 660", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c96, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8c97, "HP ZBook", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8c99, "HP Victus 16-r1xxx (MB 8C99)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8c9c, "HP Victus 16-s1xxx (MB 8C9C)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8ca1, "HP ZBook Power", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ca2, "HP ZBook Power", ALC236_FIXUP_HP_GPIO_LED),


