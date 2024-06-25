Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9495B149C4F;
	Tue, 25 Jun 2024 09:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309356; cv=none; b=ZnLlyHIZr0EH3XJU8CqziAzAV02Meuea+GzXsSf6mLHbuxYNk1wsshBHP2vQn/k8tJwRJQhIx159U36bXFqeDEZag3NX5F0xilAehtCVTiGtqtjkMqpS+MBSkVprBAMEIEMrmBbWSWKlhmfqm7oHsudCfOKPdYnbjqruFI4uk80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309356; c=relaxed/simple;
	bh=wP4R0GDtFd0Xaouzn38AhQMpcuA+7Roobh7eW9ynfi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=se46IiUvb+xi1MJIAsPP3DRyEeDPlh7a7dnlXC4t0yE2aXth/9gT4P+Xln5o5Lj3G0/1ktGRE9215jYkSVmZp0bTdVXb5RKBMhBOWiRU5+8IfQQ7Gx/F6U/QKo3Mo3Wst8ROEaCQ8Tlhv4pLNMSAOnqcsL6skrdvhLDxB1vtIKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nG6pRlGd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nG6pRlGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB31C32781;
	Tue, 25 Jun 2024 09:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309356;
	bh=wP4R0GDtFd0Xaouzn38AhQMpcuA+7Roobh7eW9ynfi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nG6pRlGd2i8Ih8JEqT49maFV/bLBGA3mjV5MpXto+kF/0em/KnQa7X4beN7SGzMm5
	 3f1r2+3T2srfuHP766IOKSaTNJIv2Yu2/mOPb9IBpq32eeFs5wBTb8fkprYX3GKGDq
	 KjJAxwi/bJGlvoSAzamyB1uzGeiYR5fNm09mwprw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pablo=20Ca=C3=B1o?= <pablocpascual@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 151/192] ALSA: hda/realtek: Add quirk for Lenovo Yoga Pro 7 14AHP9
Date: Tue, 25 Jun 2024 11:33:43 +0200
Message-ID: <20240625085542.955562473@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Caño <pablocpascual@gmail.com>

commit ad22051afdad962b6012f3823d0ed1a735935386 upstream.

Lenovo Yoga Pro 7 14AHP9 (PCI SSID 17aa:3891) seems requiring a similar workaround like Yoga 9 model and Yoga 7 Pro 14APH8 for the bass speaker.

Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/all/20231207182035.30248-1-tiwai@suse.de/
Signed-off-by: Pablo Caño <pablocpascual@gmail.com>
Link: https://patch.msgid.link/20240620152533.76712-1-pablocpascual@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10270,6 +10270,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x3882, "Lenovo Yoga Pro 7 14APH8", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3884, "Y780 YG DUAL", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3886, "Y780 VECO DUAL", ALC287_FIXUP_TAS2781_I2C),
+	SND_PCI_QUIRK(0x17aa, 0x3891, "Lenovo Yoga Pro 7 14AHP9", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x38a7, "Y780P AMD YG dual", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38a8, "Y780P AMD VECO dual", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38ba, "Yoga S780-14.5 Air AMD quad YC", ALC287_FIXUP_TAS2781_I2C),


