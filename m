Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146161E5206;
	Mon, 23 Jun 2025 22:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716000; cv=none; b=Z+3Oxd734P5HtpdTY6KOzI0KikBPjNEWwyK6G5Id6PSPboqPDm7HjaAotZnoLysvUfdsgEazF61CfI3CW0cm9VBG7bs86Xkn1E+NR1Z0KIiNxFT25DPICjrnAXFnhn6lu6odkYeHDfIOI/N4WiAIgreWVuao8Nt/LN7YNgJdq0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716000; c=relaxed/simple;
	bh=hBatiPfj5xX6DU9xlcEstGk3MI/PyXc/LZGsXZWDFkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAuYtgSyuGEZIFwtV3Mgi6wMrNN7QRNeTSOSR47tiYbWAPBAtsYPaaGahVbcQjJGcIOkL5EUNGyNRU6T0bVtg+xfm4EPZklmqg+NnLjpDNGesLVppAeQo5eMpW2694iqy1phBPKk6pANkJIKJUARaGNFaJ9c5XjjaJxuBv5vAWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FqAtTL41; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FqAtTL41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00EFC4CEEA;
	Mon, 23 Jun 2025 21:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715999;
	bh=hBatiPfj5xX6DU9xlcEstGk3MI/PyXc/LZGsXZWDFkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FqAtTL41zDaRzGiXlcIVRyijM5k0OMe9Ckz4xNyx3CWsz5gEKZ4SLQFZEH70D5HkU
	 PnzMieLRkPm2VhKtm65s/cehfVGq4gkVrQlvZaREV4EyL0DUYZlTAsvBnJPWhpLVY4
	 tifjIjQrwxG34TNSfgtsD7J3pkdVHL7eqNSSkxL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 234/290] ALSA: hda/intel: Add Thinkpad E15 to PM deny list
Date: Mon, 23 Jun 2025 15:08:15 +0200
Message-ID: <20250623130633.964485639@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit c987a390f1b3b8bdac11031d7004e3410fe259bd upstream.

Lenovo Thinkpad E15 with Conexant CX8070 codec seems causing ugly
noises after runtime-PM suspend.  Disable the codec runtime PM as a
workaround.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220210
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250608091415.21170-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_intel.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2266,6 +2266,8 @@ static const struct snd_pci_quirk power_
 	SND_PCI_QUIRK(0x1734, 0x1232, "KONTRON SinglePC", 0),
 	/* Dell ALC3271 */
 	SND_PCI_QUIRK(0x1028, 0x0962, "Dell ALC3271", 0),
+	/* https://bugzilla.kernel.org/show_bug.cgi?id=220210 */
+	SND_PCI_QUIRK(0x17aa, 0x5079, "Lenovo Thinkpad E15", 0),
 	{}
 };
 #endif /* CONFIG_PM */


