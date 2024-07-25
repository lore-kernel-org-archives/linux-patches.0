Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5981E895;
	Thu, 25 Jul 2024 14:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918763; cv=none; b=VBJ66Df6rt+5txYuA0BJUUHXUENxtGHfo+7v6G1I3lAwZhKCfX1iUGHJDBYixAY37a9dheHeHiopmfaN4EF5H63e6SpCREx6D9twMROYZtmifyd6TlAtH31habF7nJNkcLdgq7ZUQCFhw3MTc4i+z8UOPL1HZtCnVcO9G1B7t7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918763; c=relaxed/simple;
	bh=a4eK0DPmUMQurPZSuqCxjciPV3HsBVIjl8BTkCmphME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDUcT4h8zpRtqjfkkMY/c10yIfBUpO8x6kGQS2VQ0+dKcPlr1HC7NOLrohzhYvurQvWQYR/0rtE1/MSUzsF7G7jYr+TQB5qp5cA+cB46VGc34iw+3bxwPKmAcgmGuvNz81bg/F4hMqf/fAapiJRguXsPD0J7sdIbMYW/aXLWX7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FlQPNikn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FlQPNikn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5CDC116B1;
	Thu, 25 Jul 2024 14:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918762;
	bh=a4eK0DPmUMQurPZSuqCxjciPV3HsBVIjl8BTkCmphME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FlQPNikn3IDn4EPRC0OI4PdTy7//qEO96Jpk4vdF3szW5N1BY+zYf7XstoqP363bm
	 W4c7CeporAq8krvTNn8SJCtxNwoL97IuRv71979boncoIU6zgM4/RP71mDFhGVR4+r
	 /QR3ojNWfLBTnJx/AFRr4QQ5Yxq1c/Fo7f1mYvUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seunghun Han <kkamagui@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.9 10/29] ALSA: hda/realtek: Fix the speaker output on Samsung Galaxy Book Pro 360
Date: Thu, 25 Jul 2024 16:37:20 +0200
Message-ID: <20240725142732.066325756@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142731.678993846@linuxfoundation.org>
References: <20240725142731.678993846@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -10348,6 +10348,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x144d, 0xc189, "Samsung Galaxy Flex Book (NT950QCG-X716)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc18a, "Samsung Galaxy Book Ion (NP930XCJ-K01US)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc1a3, "Samsung Galaxy Book Pro (NP935XDB-KC1SE)", ALC298_FIXUP_SAMSUNG_AMP),
+	SND_PCI_QUIRK(0x144d, 0xc1a4, "Samsung Galaxy Book Pro 360 (NT935QBD)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc1a6, "Samsung Galaxy Book Pro 360 (NP930QBD)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc740, "Samsung Ativ book 8 (NP870Z5G)", ALC269_FIXUP_ATIV_BOOK_8),
 	SND_PCI_QUIRK(0x144d, 0xc812, "Samsung Notebook Pen S (NT950SBE-X58)", ALC298_FIXUP_SAMSUNG_AMP),


