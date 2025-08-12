Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1820025B1EA;
	Tue, 12 Aug 2025 19:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025292; cv=none; b=Qk+sIvrzY0KCuDaKlNr98w46kR3N1YqCxhVLtBFFndczuIyZhV2hkfdvqPtv8bU9OCdpDLBlTZM4vz3CIzoIx/APoVHOjKselrDtZid5UZIXeQWmTxh+9qGrW1+BSo0WyDR779PDgTrLbLi/ukJl0pIU5pijglHvrTzkA/pMtXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025292; c=relaxed/simple;
	bh=pdT7G/ZcZB3jP3wgfclgaaANB6FEh4kBatIuXAIJoTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2/PgfGoD1ccnZqRLNfXnNO5EQhwMgvb3k/2I+Ghlzkfwy0SdBjuEOp1JopXNe0xjA0a1sJM0NL7SPbfjIlu5QsOqitVIjRQdpRNlbfKfZYCpz2tRt6KCSKLzbAoZmXDVEXdiVmATSya6t83WnsFQcZOf7xMXii81AyqXNZ292E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CKUvAPAL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CKUvAPAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A676C4CEF0;
	Tue, 12 Aug 2025 19:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025291;
	bh=pdT7G/ZcZB3jP3wgfclgaaANB6FEh4kBatIuXAIJoTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CKUvAPALhZzhAULE2IHKwMWVj2PWPaeauUNdUL6t1K/GN2qQLoaMR3wXRLSrlqv0y
	 lmJobqIFWCB19f4qHLIg1Nb9PeZr7q/gqo/hXou7CgoDSf2hx+bq6iu6Tb4wKh0sw3
	 Czmf0x0g+YGhNorgtN3pE9SmLRE8g/YvLGEoIqlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edip Hazuri <edip@medip.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.16 599/627] ALSA: hda/realtek - Fix mute LED for HP Victus 16-r1xxx
Date: Tue, 12 Aug 2025 19:34:54 +0200
Message-ID: <20250812173454.656127044@linuxfoundation.org>
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
@@ -10874,6 +10874,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8c91, "HP EliteBook 660", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c96, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8c97, "HP ZBook", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8c99, "HP Victus 16-r1xxx (MB 8C99)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8c9c, "HP Victus 16-s1xxx (MB 8C9C)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8ca1, "HP ZBook Power", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ca2, "HP ZBook Power", ALC236_FIXUP_HP_GPIO_LED),


