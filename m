Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63722183CA6;
	Mon, 12 Aug 2024 16:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479529; cv=none; b=ezTJaEPo8Z4c/rG+cfA6Vk80xvQ7o4J0T6Mu/8U+fRvtWSXtRiYvlBJEQZkrfWNB7wMYGS5h1UWIV4LDerOLhUjW+Ib2aj0QGEJ16Y0Q3M9/Jz+A2TtS2Upcj/fufLe+GcyBXMrJRVZxqnI9WxtBQ2SZ7K7qmhhXIvog9S5ofHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479529; c=relaxed/simple;
	bh=uTFhppyweZSZRoIe1x8+5C5wtKhxfnA8pcD/0Czr/gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JtPbQWKFpCGzltqM19l8P4TXLIjv8ECj5rNlGULtvwepxQL/TyL1Mzb3V1mnb5Ze0JRdXOgbV2OCjvsBUbluFsi1YDuRWPfVvX06kDJUYK3CAEQXXkkiSPlIhIzYbFcN5l6hdYdyFRJXGeaKKIxFhFFJ8BXDheyZ1xeiwgfZY2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aTRcaKo1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aTRcaKo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2336C32782;
	Mon, 12 Aug 2024 16:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479529;
	bh=uTFhppyweZSZRoIe1x8+5C5wtKhxfnA8pcD/0Czr/gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aTRcaKo10GXiMcjgy9WfF7z66/APg3lk7wHOVtLEsrIH7Ik4Fo4AMUAKKSHR97uT0
	 RTpHMV45IDzbPWQdmj3x1bQ1eAKUF7kW4G7vMKJ7rdpBOUmcyWrCsL24DdB3yfcx8W
	 XZrbY8u6jvQGh8SZcqkQvvhEb9aOkXTQgZeohUKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dustin L. Howett" <dustin@howett.net>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 115/189] ALSA: hda/realtek: Add Framework Laptop 13 (Intel Core Ultra) to quirks
Date: Mon, 12 Aug 2024 18:02:51 +0200
Message-ID: <20240812160136.565010154@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -10360,6 +10360,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x8086, 0x3038, "Intel NUC 13", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0xf111, 0x0001, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x0006, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0xf111, 0x0009, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 
 #if 0
 	/* Below is a quirk table taken from the old code.


