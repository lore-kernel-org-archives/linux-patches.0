Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02EF183CD9;
	Mon, 12 Aug 2024 16:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479022; cv=none; b=q172iLK749JGSlJdS5/JL3hkAWmoXx5Yxv1nJNMr8EtSxaIOJjKe3nTgFLUAGxOySu7kDGLdTK5n5IqNj7iYvp26aXSjatGEe+R8kNvcVO409Qh76DapwnLN9nZp6V6QA8SlQ0xQBLMKkb6PsxMWH4uPJr6SlkolqLhEgq4VU5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479022; c=relaxed/simple;
	bh=OcvdtBAXjDP6IyosCMpEBFWDUQS2ObuwIm9+QvfO8Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BUtE79+jx5TBc5l2tnQJfH98cTAR3Um2DmHDKti1uWlI2lYlX4YTlcdSYqPy8icuSbbqiuimWBRP911VTu4E0CCuXLI3691gTWf8+8H8gP/iEbJi6DZVk7xHSH1s5YJMK4TnAVjW+rVstcGrgTzyemB6JaGnQaFPHgWyIPLFocA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nsmOZl4n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nsmOZl4n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2462C32782;
	Mon, 12 Aug 2024 16:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479022;
	bh=OcvdtBAXjDP6IyosCMpEBFWDUQS2ObuwIm9+QvfO8Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nsmOZl4nzx77yyRxWCq3zEDotv+6D/pNQ5JUGGnff8zm2rv+17m6dWncMqKiwl1Lq
	 oZyPKF75sjlFIJgSwZZfd+BMv55PF6nLfUdxngVwYjFjJHZuO801feF6LO+hY1ZFZi
	 7hMLgDJgRiob+8GOibBXqg7kSuvS+H3ihlBzG/Gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dustin L. Howett" <dustin@howett.net>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 091/150] ALSA: hda/realtek: Add Framework Laptop 13 (Intel Core Ultra) to quirks
Date: Mon, 12 Aug 2024 18:02:52 +0200
Message-ID: <20240812160128.676794744@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

From: Dustin L. Howett <dustin@howett.net>

commit eb91c456f3714c336f0812dccab422ec0e72bde4 upstream.

The Framework Laptop 13 (Intel Core Ultra) has an ALC285 that ships in a
similar configuration to the ALC295 in previous models. It requires the
same quirk for headset detection.

Signed-off-by: Dustin L. Howett <dustin@howett.net>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240806-alsa-hda-realtek-add-framework-laptop-13-intel-core-ultra-to-quirks-v1-1-42d6ce2dbf14@howett.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10173,6 +10173,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x8086, 0x3038, "Intel NUC 13", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0xf111, 0x0001, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x0006, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0xf111, 0x0009, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 
 #if 0
 	/* Below is a quirk table taken from the old code.


