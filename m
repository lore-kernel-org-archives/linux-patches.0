Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2BB199E9F;
	Thu, 25 Jul 2024 14:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918307; cv=none; b=qn9GswpdE8ZWB2zhPeORrqEzlDUG3zJHkpIkMUgWNYTKQYvT2SjHqb15Bg/NhPddKFKyN/bvKL+fDce6ewhaO/VBesRmLynUWVT+fCZEE5ASabHTkgWNimsgWbkExRU5wWiq4ZJasO7fZF7yT/YuDgtMsObJKJPXxYUCvJ8E2vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918307; c=relaxed/simple;
	bh=DdI9xwhuiVKQDhrhnoeywGa5muiHYLVjP7AfXD3E5Do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HOoXMb+aRkj/JWNaGFtqg0t0+AdYQwrcKR9IfugZDHZpBIxkms96xxulCrMhoZALCZtdgn+WJKuhQ90z73U1u5ggT7Hs4QEAeXUoGcOdKKZKEfR3JWOcIhOgCJKBVByMcauF2ZqEsBpv/MhhYY6/h6GxmoL0Ddwp9BCsTk/KXDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=te1oQ8Es; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="te1oQ8Es"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD42C116B1;
	Thu, 25 Jul 2024 14:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918307;
	bh=DdI9xwhuiVKQDhrhnoeywGa5muiHYLVjP7AfXD3E5Do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=te1oQ8EsXJI+MBk8h1VpjVcQcIXSgSJRfNHI6/h3OhINVwxgeGI/PkWY5qDJIRu/W
	 gQkvkGC2qtkMOeCXcBqKyVgrDvfHow1qCRdJEuEsjT5sTnQQ7wJ5WsAf0hxKZtZvzm
	 CVxzPR0Yvcb5lkv0aM40pEcpXMo246zNQb87alr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seunghun Han <kkamagui@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 10/29] ALSA: hda/realtek: Fix the speaker output on Samsung Galaxy Book Pro 360
Date: Thu, 25 Jul 2024 16:36:26 +0200
Message-ID: <20240725142732.204539198@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142731.814288796@linuxfoundation.org>
References: <20240725142731.814288796@linuxfoundation.org>
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
@@ -10399,6 +10399,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x144d, 0xc189, "Samsung Galaxy Flex Book (NT950QCG-X716)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc18a, "Samsung Galaxy Book Ion (NP930XCJ-K01US)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc1a3, "Samsung Galaxy Book Pro (NP935XDB-KC1SE)", ALC298_FIXUP_SAMSUNG_AMP),
+	SND_PCI_QUIRK(0x144d, 0xc1a4, "Samsung Galaxy Book Pro 360 (NT935QBD)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc1a6, "Samsung Galaxy Book Pro 360 (NP930QBD)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc740, "Samsung Ativ book 8 (NP870Z5G)", ALC269_FIXUP_ATIV_BOOK_8),
 	SND_PCI_QUIRK(0x144d, 0xc812, "Samsung Notebook Pen S (NT950SBE-X58)", ALC298_FIXUP_SAMSUNG_AMP),


