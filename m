Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116313B795;
	Mon,  4 Mar 2024 21:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587751; cv=none; b=H2zowV+kBg7uhQFaPSd2v3p/1FD8tKn7j2CTNcuICqgA4Z0yVMCVEt2603sDZZlSZ530Sv9g6jjRPBQOpkRibpPub6LO3gb0MMMMWwc3f2Mn/hoTkY/UrAMlfcGiFltdPaQaBMQXVmp70mH+F2iO7nxmRqxoNBz1zJJHjovYThg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587751; c=relaxed/simple;
	bh=ghaL+iTToi8S7z4VXPWfYrZDYqtb3KfnXHFMDJ6s4zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MGcIqPgfukIE8LVaLqtylniWS+H1QKE458mH/vz0dlYdoKJh94PiX/g/zByo0dUoV2Jooj+sgPiQXapoKvNCdYI1KgB54jnpfnxmBzTUlRUPv4tIEdw+eUYidAPaamOrtnoC7f8XSsP9kpn0K02ucFzch5C1YHMAewDDYdVh2dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZJBCHIp3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZJBCHIp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F969C433C7;
	Mon,  4 Mar 2024 21:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587750;
	bh=ghaL+iTToi8S7z4VXPWfYrZDYqtb3KfnXHFMDJ6s4zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZJBCHIp3DBR0dXDPAxp9UTJt2Zec99n3obj8lJsyT2Uj+3/Esn8u2XmEWno7oPPGl
	 re338DYnwSR4nCe1IYS7xE7iqHo7kHUep+CRk2GHAbkk05NMm0axxzL717VzmzNUVH
	 93s1RaItgzXeMSPn8ZNN5nDzbgFNi0nCg/s7uPiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Ajit Mate <jay.mate15@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.7 076/162] ALSA: hda/realtek: Fix top speaker connection on Dell Inspiron 16 Plus 7630
Date: Mon,  4 Mar 2024 21:22:21 +0000
Message-ID: <20240304211554.287568830@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jay Ajit Mate <jay.mate15@gmail.com>

commit 89a0dff6105e06067bdc57595982dbf6d6dd4959 upstream.

The Dell Inspiron 16 Plus 7630, similar to its predecessors (7620 models),
experiences an issue with unconnected top speakers. Since the controller
remains unchanged, this commit addresses the problem by correctly
connecting the speakers on NID 0X17 to the DAC on NIC 0x03.

Signed-off-by: Jay Ajit Mate <jay.mate15@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240219100404.9573-1-jay.mate15@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9733,6 +9733,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1028, 0x0c1c, "Dell Precision 3540", ALC236_FIXUP_DELL_DUAL_CODECS),
 	SND_PCI_QUIRK(0x1028, 0x0c1d, "Dell Precision 3440", ALC236_FIXUP_DELL_DUAL_CODECS),
 	SND_PCI_QUIRK(0x1028, 0x0c1e, "Dell Precision 3540", ALC236_FIXUP_DELL_DUAL_CODECS),
+	SND_PCI_QUIRK(0x1028, 0x0c28, "Dell Inspiron 16 Plus 7630", ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS),
 	SND_PCI_QUIRK(0x1028, 0x0c4d, "Dell", ALC287_FIXUP_CS35L41_I2C_4),
 	SND_PCI_QUIRK(0x1028, 0x0cbd, "Dell Oasis 13 CS MTL-U", ALC289_FIXUP_DELL_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1028, 0x0cbe, "Dell Oasis 13 2-IN-1 MTL-U", ALC289_FIXUP_DELL_CS35L41_SPI_2),


