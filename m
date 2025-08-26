Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A4638DEC;
	Tue, 26 Aug 2025 12:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212573; cv=none; b=hfK6Sa4gAmDZvoy+FL8f68cPH6Famgdcyux9uiyA2nbOYnHL9/qpm2cTAu7X5+4a8paHfLcxcLJMQUf31BC9oWOe4wQba28altMpVCC1XXLN1HL6qW1z+1P5818AfxGEt/qSflC/w8L15uhqqriHdkE57jzmDolRS9D5XtAlVDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212573; c=relaxed/simple;
	bh=M+yyXNwJ1PGsLUGKUzUYyx6/1860uepEEWBOtYsl34c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETyaMCG2NYVZnNwI8qZvRacN2ec2VaafdygM92WYaR8+RnDQC+xzd8AOZpYbHB48XhrFxi/O0SbWIz/SJ7ljd3vqc/qS3GtTIYH1LN0ty9+QwthOnmDCAPSYrZOjJ9BdnWaZ588KgW81SVVkjOxQJE807Skecy2usToFqsqp4R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PdRD6yy4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PdRD6yy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85FA5C4CEF1;
	Tue, 26 Aug 2025 12:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212572;
	bh=M+yyXNwJ1PGsLUGKUzUYyx6/1860uepEEWBOtYsl34c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PdRD6yy4uXw2agIF+mlHYfBjAbJT8xNooze0tNywFKG9njRVaxjPfktz95uR7hN3O
	 AHmRtFiEX8OSekRpwAr+S9v/9yOd2vLRR9m4ZA/kLKzyGnTAHtvenjy6YWCqmJtbnn
	 dnJnUfKNcFSUkyGoDMaEVykeO9WT+jHxoZhf+cjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 004/587] ALSA: hda/realtek: Fix headset mic on HONOR BRB-X
Date: Tue, 26 Aug 2025 13:02:33 +0200
Message-ID: <20250826110953.058361978@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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
@@ -10636,6 +10636,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1d72, 0x1901, "RedmiBook 14", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1945, "Redmi G", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1947, "RedmiBook Air", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1ee7, 0x2078, "HONOR BRB-X M1010", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1f66, 0x0105, "Ayaneo Portable Game Player", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x2014, 0x800a, "Positivo ARN50", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x2782, 0x0214, "VAIO VJFE-CL", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),


