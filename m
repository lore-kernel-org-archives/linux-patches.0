Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE618462;
	Tue, 26 Aug 2025 12:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212575; cv=none; b=P7iA6S7+m+rDYSdIuiMS3psUBtC6HN4vy/6Lz655Sre6WcMO4tdRvAhvQ3ctzzK1pfXo+yzTCiQpjJG3g/7U7oyqef+3qKw5YxEVAX9qpiv5TM34WJdpfxWiSQaSq637gUw/sx2OPRYjbjmEwepVS9Ti0Pl4JuJ+L6Ms72wL1ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212575; c=relaxed/simple;
	bh=EAHvik88xiM9US9CIQ7ee4bxqMIhT+OZzP9jGCG/OcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKBbLD5Y+bAiPcr4GcZbUtY4oQKlKQdHtvEtGED07gB1sqZSrYNWcIS8O25n/H+kaogMaHimTQezwJtBKLqvNHraKpwLLcCiux5UbgOH01HhjmHAwuUQOqpevz4b9LhsTRela1CQrwVUi9ODWqxULKrK70n7u4u3IVY/u2Di5YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iwav+DMf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iwav+DMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5C0C4CEF1;
	Tue, 26 Aug 2025 12:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212575;
	bh=EAHvik88xiM9US9CIQ7ee4bxqMIhT+OZzP9jGCG/OcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iwav+DMfJXS9kFPaKbYlNCG2iHMZY3L0FCa/VdJW0sQ0X5oAtqSSFBUl8hfZ2/BJY
	 wQTr/1yaGHB/MukRsn38DS36O3jvdHkau/ZRMVBWlVyTaG6GIeJ/QahKn115nxXCgg
	 G4nvjPY0MamhXlMqaJtFx6o8htzdCBvh+oiamHKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Eby <kreed@kreed.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 005/587] ALSA: hda/realtek: Add Framework Laptop 13 (AMD Ryzen AI 300) to quirks
Date: Tue, 26 Aug 2025 13:02:34 +0200
Message-ID: <20250826110953.083155077@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher Eby <kreed@kreed.org>

commit 0db77eccd964b11ab2b757031d1354fcc5a025ea upstream.

Framework Laptop 13 (AMD Ryzen AI 300) requires the same quirk for
headset detection as other Framework 13 models.

Signed-off-by: Christopher Eby <kreed@kreed.org>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250810030006.9060-1-kreed@kreed.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10652,6 +10652,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0xf111, 0x0001, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x0006, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x0009, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0xf111, 0x000b, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x000c, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 
 #if 0


