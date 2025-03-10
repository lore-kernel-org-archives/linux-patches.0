Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21E51BBBFD;
	Mon, 10 Mar 2025 18:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630626; cv=none; b=FWkHhVUQpICxngc7Cwyi4HXibc9u4Cyey2Tzpvxp7jtySeCl/AgXAa4WuGna2HGDIsuzOFnf5H8wx9cpxir1plDvnziirhKcVg0QbSUcdhFL8iJyUF3H85AnG7n24KZI1DhcbQ5izjaR9R0HSQZ8UZYqtGYSE/vWwhfecZlUEOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630626; c=relaxed/simple;
	bh=MRZIb4ghWiIiQzYiTK0oYn7BsMIVMEBCDLD6GNJncjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/bSrtRUN2K4l4jjawUQlmTHoYnzQSrghxCSi9C45l7QC7VQfAcOE41EPuTzIPTPEPrhii9Uqer6/Dz2buztmAkReQUWFMt1JGYq0yvJzJ/ArtZop0dgJl3GWwYjRUfSlMjacynSKDPk/PcEpuDdzQabjdEgRTQAxkOgjwlQkPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMOmDRAZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMOmDRAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375D2C4CEE5;
	Mon, 10 Mar 2025 18:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630626;
	bh=MRZIb4ghWiIiQzYiTK0oYn7BsMIVMEBCDLD6GNJncjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yMOmDRAZOw92c0EZpZLybfsE0r63yuT40gbYVUBcP4uICo9fvd70r4O3nDeym4NEx
	 4eZlgx+W1xgpDZV50ICFM0edBXdvfhqT8SP2hSCNvlkhT1O9dAcjMzFaHRttj3/wWd
	 fS8Vn07cNLFRc6I2qTjbRSPihTkOXisXugU8bDiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Veness <john-linux@pelago.org.uk>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 479/620] ALSA: hda/conexant: Add quirk for HP ProBook 450 G4 mute LED
Date: Mon, 10 Mar 2025 18:05:25 +0100
Message-ID: <20250310170604.482563062@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Veness <john-linux@pelago.org.uk>

commit 6d1f86610f23b0bc334d6506a186f21a98f51392 upstream.

Allows the LED on the dedicated mute button on the HP ProBook 450 G4
laptop to change colour correctly.

Signed-off-by: John Veness <john-linux@pelago.org.uk>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/2fb55d48-6991-4a42-b591-4c78f2fad8d7@pelago.org.uk
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_conexant.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1098,6 +1098,7 @@ static const struct snd_pci_quirk cxt506
 	SND_PCI_QUIRK(0x103c, 0x814f, "HP ZBook 15u G3", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x8174, "HP Spectre x360", CXT_FIXUP_HP_SPECTRE),
 	SND_PCI_QUIRK(0x103c, 0x822e, "HP ProBook 440 G4", CXT_FIXUP_MUTE_LED_GPIO),
+	SND_PCI_QUIRK(0x103c, 0x8231, "HP ProBook 450 G4", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x828c, "HP EliteBook 840 G4", CXT_FIXUP_HP_DOCK),
 	SND_PCI_QUIRK(0x103c, 0x8299, "HP 800 G3 SFF", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x829a, "HP 800 G3 DM", CXT_FIXUP_HP_MIC_NO_PRESENCE),


