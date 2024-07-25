Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846931E895;
	Thu, 25 Jul 2024 14:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918740; cv=none; b=uCe4yBHejrQ1Ga1aLBqkIs+ke2OWK4tzhYbaHnh0yPbf29w5XZ6LYzjp+ynn5YLnoTwKvvv6GRM8D9bH3LvnfDD+it2NcijmklovlGfJ3d67foUB8ln6vvv4Vsth1FOEK09+d/OY6KI4DzXrxctGRyW5yBtfsj3VZI5am5nqr1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918740; c=relaxed/simple;
	bh=S4BhtPdGoHqVhjqXaYCdmNLQF4L+y4BTBnRdyjtIB4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWjb8MoGocPVsRJjqbq6KfHVn5BKO9qO+sgC01XCzV3UibHcTugeqGwt/ogorE0wjuDdqrX3ARp4MMNaxbEfjDdqmM2kGO3qkqkc+Cex8ZGZS8p4jH2hxLTk0gbsN86xdSNXmlzNG9UysquWxP4XH7jJIorxPr7CAnCMcWbMe6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eP97zmrI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eP97zmrI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09192C116B1;
	Thu, 25 Jul 2024 14:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918740;
	bh=S4BhtPdGoHqVhjqXaYCdmNLQF4L+y4BTBnRdyjtIB4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eP97zmrIFcyegLpxegWZxrMCzqZHPvgK0sBVvGmjQ7ABNsttIln7IS2EBGLtlfQqz
	 W+cNK9YpfVzgW/GIjfDjAetEYt0WErirKJ5TsvPMYclSJ8SQAA7QaHzMk59HcsELbw
	 6tA8nbr4+G+ekfRatR2rO7pm0RfG61us7EHknD4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seunghun Han <kkamagui@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 08/16] ALSA: hda/realtek: Fix the speaker output on Samsung Galaxy Book Pro 360
Date: Thu, 25 Jul 2024 16:37:21 +0200
Message-ID: <20240725142729.218458718@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.905379352@linuxfoundation.org>
References: <20240725142728.905379352@linuxfoundation.org>
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

From: Seunghun Han <kkamagui@gmail.com>

commit d7063c08738573fc2f3296da6d31a22fa8aa843a upstream.

Samsung Galaxy Book Pro 360 (13" 2022 NT935QDB-KC71S) with codec SSID
144d:c1a4 requires the same workaround to enable the speaker amp
as other Samsung models with the ALC298 codec.

Signed-off-by: Seunghun Han <kkamagui@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240718080908.8677-1-kkamagui@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10106,6 +10106,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x144d, 0xc189, "Samsung Galaxy Flex Book (NT950QCG-X716)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc18a, "Samsung Galaxy Book Ion (NP930XCJ-K01US)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc1a3, "Samsung Galaxy Book Pro (NP935XDB-KC1SE)", ALC298_FIXUP_SAMSUNG_AMP),
+	SND_PCI_QUIRK(0x144d, 0xc1a4, "Samsung Galaxy Book Pro 360 (NT935QBD)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc1a6, "Samsung Galaxy Book Pro 360 (NP930QBD)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc740, "Samsung Ativ book 8 (NP870Z5G)", ALC269_FIXUP_ATIV_BOOK_8),
 	SND_PCI_QUIRK(0x144d, 0xc812, "Samsung Notebook Pen S (NT950SBE-X58)", ALC298_FIXUP_SAMSUNG_AMP),


