Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31EC20E6E1;
	Mon, 18 Aug 2025 13:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522919; cv=none; b=DdgKp1hoATzzazp1RaHfb+h3T+tDw76wG6l+ZI5r0TmXo+YENvQbP0GrPhfMbhc3yM/iLj74BK/Umd6FdaYFLemzlbhqxHN/PJXbTEFnHG6fecQlh7xiE/QqcgSR/QH0kL51C/Dqpg4C6dpEMqwwN9FHD2paUYgNb3cWupI6LIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522919; c=relaxed/simple;
	bh=Hjg52v6yRKBe/aytDO+sdDEqHNAoMAMC+UGMMvrgQA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SPX/kAbbqVHtaZ/dWIDUDWNI3NqTS9fhVXYcaui0nU2LZdzSSb70pusrArrdp6+Z+PdHLio0ob5c/52UWKOhItQNVD6Uq/+Vkz6z3oV+/DWLtmPthkx3gJAJHSwwclmQ/eotbb3TShoiECrRvgRwqK04PeFNH1VVmiPYgIbJcUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PyWnevri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PyWnevri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D55C4CEEB;
	Mon, 18 Aug 2025 13:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522919;
	bh=Hjg52v6yRKBe/aytDO+sdDEqHNAoMAMC+UGMMvrgQA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PyWnevriJnM2eRp82jVTqTKd0DkCLYIZa3KtGHxW+X36RuvyW5yZZW9+tYtZoT6z1
	 GPL33w9Nt6QRtQt9qi7vtJIGgXPd6Q/H28cT7VtjXZriJKmw0EA6LzD3zmyCLBzsLS
	 zE+s54mhWYupA+IGPOHF6Z/t6mBIAi5JQ+p+DGiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Eby <kreed@kreed.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.15 008/515] ALSA: hda/realtek: Add Framework Laptop 13 (AMD Ryzen AI 300) to quirks
Date: Mon, 18 Aug 2025 14:39:54 +0200
Message-ID: <20250818124458.650029916@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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
@@ -11422,6 +11422,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0xf111, 0x0001, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x0006, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x0009, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0xf111, 0x000b, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x000c, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 
 #if 0


