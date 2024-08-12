Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE07187FE9;
	Mon, 12 Aug 2024 16:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480423; cv=none; b=FZV6WOvaSTY0KWwh775G11q8KspOFuh16plIGw/vEPkytw3lnYzmc7FYofJYHDNd4jVDAZOVsin25cM7DKZaZmJqbrDWVCK78vemtgnsiZWneKCdR6J6tIecpsC4ZNAep4EZMZmfullzUbgM5cX+JXVQKacXuZRSEJspF16j0PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480423; c=relaxed/simple;
	bh=Qjnls5N9pSpsF8Xl0QUORNTTON1vHuTpI/HeObLolow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c8XMXYVIOmQrz3qEtJmKY88wb24MJsJ/QtDCnzwXGTioBZunnTPNu4JyUPWeYvibabf27zhw9RF2ZdUVM2DYXwL5M+AlZJcMGZH/jNy6mT8QSXDkP8+XC+8f0HN0Dfa9w/xM63TznZRXK1pwMayNAA/6+l2teRno51msKJLHVZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vObRVIsK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vObRVIsK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8C6C32782;
	Mon, 12 Aug 2024 16:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480423;
	bh=Qjnls5N9pSpsF8Xl0QUORNTTON1vHuTpI/HeObLolow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vObRVIsKHaktkdK8KIMbDYwKIvytHwAOQ/S1l96gGxjKmU+45klzNGvHnly9B4PUu
	 l46yrrwvvL+73wYtqowcYh6yEneqB60aTc46DBq2otWoJE3LXIozJb4svPdPNICfjW
	 yTuhjixucRc/1wSzTtw6Gmv/mSX7dqu0DkbYoS0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dustin L. Howett" <dustin@howett.net>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 184/263] ALSA: hda/realtek: Add Framework Laptop 13 (Intel Core Ultra) to quirks
Date: Mon, 12 Aug 2024 18:03:05 +0200
Message-ID: <20240812160153.590374063@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -10671,6 +10671,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x8086, 0x3038, "Intel NUC 13", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0xf111, 0x0001, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x0006, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0xf111, 0x0009, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 
 #if 0
 	/* Below is a quirk table taken from the old code.


