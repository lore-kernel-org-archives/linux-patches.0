Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09DE1DF265;
	Mon, 18 Aug 2025 13:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522916; cv=none; b=eXkZ5z7kcPrRsDSZXR0ZIIEiSi+QYWomq6hmcxr9y3LBS0kPqSLlkLaVR9sgn13Jp2DwfAofOSQlm/umEQcJdOnrZtBtsx6kIQ4HyeUiSxPDhhuO7Q3X7Fo1Y4iIZWXQKdrs3WFiW6ibzA20opqoiWdU5rapEkG2fVnG6FTMdEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522916; c=relaxed/simple;
	bh=/uCUNb+H6oBDmYQlxUu4gaVb2kII+k5kVP3g0a7EwR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YEP3yRtQZ5jpAbC1yPe/WtfphmV2BV4SLYk9p5zGTzcBejNZnH5d/0WK9YdCrgbdSZXfDNDCyE7U+SVqx4a0QlveHt8uOjDDorZRUeIqaGgAPLe0TK67FY8u0mHskxGrXD9qeagk8EK1SCAnMlZMQQwFSMaWrIS6nySVWTGRxAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zUobrCTI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zUobrCTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E17C4CEEB;
	Mon, 18 Aug 2025 13:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522916;
	bh=/uCUNb+H6oBDmYQlxUu4gaVb2kII+k5kVP3g0a7EwR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zUobrCTI3beLqD88yuNOUgzwfCIpAAMf21kr87+3gXHyPIOhQ2ybjx471aYZjTaIq
	 Xdu3dOoyhdiB4j8CMHIVlqQKrw/reHgxmfx5BE76Eg0OJfOBqTK8Gr4pEuTDMrwAQ6
	 72p1VSkGxePIU9UsPak9al7/Y+RnhhVl12dXvSr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.15 007/515] ALSA: hda/realtek: Fix headset mic on HONOR BRB-X
Date: Mon, 18 Aug 2025 14:39:53 +0200
Message-ID: <20250818124458.613416082@linuxfoundation.org>
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

From: Vasiliy Kovalev <kovalev@altlinux.org>

commit b26e2afb3834d4a61ce54c8484ff6014bef0b4b7 upstream.

Add a PCI quirk to enable microphone input on the headphone jack on
the HONOR BRB-X M1010 laptop.

Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250811132716.45076-1-kovalev@altlinux.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11405,6 +11405,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1d72, 0x1901, "RedmiBook 14", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1945, "Redmi G", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1947, "RedmiBook Air", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1ee7, 0x2078, "HONOR BRB-X M1010", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1f66, 0x0105, "Ayaneo Portable Game Player", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x2014, 0x800a, "Positivo ARN50", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x2782, 0x0214, "VAIO VJFE-CL", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),


