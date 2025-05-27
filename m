Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F48A182D7;
	Tue, 27 May 2025 17:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366170; cv=none; b=EEuPcbpGunB8l7YoakDp6qHs5C9NzeUS7Vfs6UZYlzuEPw0ftPL28xAfMWgajD8a5PtXGR9Q2+ijdLWhqPGozGl09bgWGrwE7FOt1pbqRO9BMyft5IqFRLJSaCOQyw+i1cwuyH0rbjhzNm9I/zPhjCQ0Z/bMo/x2a0cBjJdJqFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366170; c=relaxed/simple;
	bh=STOaDNMcUs5G+Sz6u0OCuBRrtQRq3FhNbDm+GUcSFUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=osOy3eZlcSgaJG+cmzykhGEUjPcdtTQumdZLEYNvLu+3f4hWYAi6KzNJE5uqoEm4OuNsYxwTYwM8qJadnStss/jzcgV8iaiUi1luUnC23ltpVwgRmRUJS83kR8H1HPzJ8V3c5qFaMcaj/rIMBUGNDTMORqthc0G0MxMp/gPWLnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rGQ48TVU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rGQ48TVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2527CC4CEE9;
	Tue, 27 May 2025 17:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366170;
	bh=STOaDNMcUs5G+Sz6u0OCuBRrtQRq3FhNbDm+GUcSFUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rGQ48TVU77nANxGgKXgQ22m0XElwnmxb8f2Mii7wItVIXI0EDg4gt/Vr+nue+BJGi
	 QjoCxZNz3nUkJzuF3ggVTloYhTkT8zB5Gk/8J4z3lir2pKdYE0BWaKKPVJRPVMXJAU
	 stUPLj5ReV4pECTrSl3NQechw/zZHeAizfrGfKdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ed Burcher <git@edburcher.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 580/626] ALSA: hda/realtek: Add quirk for Lenovo Yoga Pro 7 14ASP10
Date: Tue, 27 May 2025 18:27:53 +0200
Message-ID: <20250527162508.544276780@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -11182,6 +11182,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x17aa, 0x38fa, "Thinkbook 16P Gen5", ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x38fd, "ThinkBook plus Gen5 Hybrid", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
+	SND_PCI_QUIRK(0x17aa, 0x390d, "Lenovo Yoga Pro 7 14ASP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3913, "Lenovo 145", ALC236_FIXUP_LENOVO_INV_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x391f, "Yoga S990-16 pro Quad YC Quad", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3920, "Yoga S990-16 pro Quad VECO Quad", ALC287_FIXUP_TAS2781_I2C),


