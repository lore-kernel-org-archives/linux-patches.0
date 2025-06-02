Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432121C5D72;
	Mon,  2 Jun 2025 14:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874127; cv=none; b=KPJXnxVlp0vw1K05sXoAUzLwC1K2bxaeH3yvdrTZuFQjcQ4nmSP7H6z6hLuE7jCx/KWy0tazfhR25SKStCnuSRsawcqN0UR+DXBY5EmsZfjhg+KV1y8LnAVZU5QBFLPFh+9uboCshrJmYtEBQGZwksCa/f4hLCCN65NcJTbcVKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874127; c=relaxed/simple;
	bh=3kwBJDBkWEhFiu4+lu6rA8BcR9Xg8vSAiAQ94DHPGhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A32RYKEkAGsmTpU/ODAgy4nZ9dY5V2FTQv3TpP+KwBLUPX1TQuQYmM6LLUowx2SfLzarOe6BZf5l8ac1HMVkHRzNPJZPA7ipmJvJwRf88z3dXZPgTIcXoAMiMBekX8KQLbAPYCrdY4FAxPDS8lsdN+i6e5jAZAg+TCa5AGUXxeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+Qir80r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+Qir80r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A62C4CEEB;
	Mon,  2 Jun 2025 14:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874127;
	bh=3kwBJDBkWEhFiu4+lu6rA8BcR9Xg8vSAiAQ94DHPGhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x+Qir80rJdMlxKPpWjErtcpHfKZKE9Hv+jwFPhWj4O4PEUNBQmZTgaPvFvI6mGw1a
	 kZ3K3UQNUNwbaHtD+o/ndY/FuL9ZImjYhZkv7ExQSizQS2oGgqyocxOSmi8+S5UKUV
	 G0PXdrvSWGYzaUdAnadUCEqEK/PQJdLcE2yyHfCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ed Burcher <git@edburcher.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 365/444] ALSA: hda/realtek: Add quirk for Lenovo Yoga Pro 7 14ASP10
Date: Mon,  2 Jun 2025 15:47:09 +0200
Message-ID: <20250602134355.727382129@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

From: Ed Burcher <git@edburcher.com>

commit 8d70503068510e6080c2c649cccb154f16de26c9 upstream.

Lenovo Yoga Pro 7 (gen 10) with Realtek ALC3306 and combined CS35L56
amplifiers need quirk ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN to
enable bass

Signed-off-by: Ed Burcher <git@edburcher.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250519224907.31265-2-git@edburcher.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10574,6 +10574,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x17aa, 0x38f9, "Thinkbook 16P Gen5", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x38fa, "Thinkbook 16P Gen5", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
+	SND_PCI_QUIRK(0x17aa, 0x390d, "Lenovo Yoga Pro 7 14ASP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3913, "Lenovo 145", ALC236_FIXUP_LENOVO_INV_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x3977, "IdeaPad S210", ALC283_FIXUP_INT_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x3978, "Lenovo B50-70", ALC269_FIXUP_DMIC_THINKPAD_ACPI),


