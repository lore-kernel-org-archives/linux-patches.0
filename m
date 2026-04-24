Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F3A23E356;
	Fri, 24 Apr 2026 13:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037624; cv=none; b=GOsBOreVFlkRoKGqZozVWxXaqXel1KhKxk1QJwjo087QdKRfS6zmyFSXSIXAOEKhvUrSzv2XbgoGHJlB5AUyuq4sEy35CqDfD41bUU0hrjF2csdJ7GEFGZDFBfaZsFHIMmMgTkmpcmsHBHLL0ocR74bJMCJ5QcWKzR6m2j+Qatw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037624; c=relaxed/simple;
	bh=6N5GuEd+X0HneLfGG2BYi5i2fDn3XscjbMTA1V2+aNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHO1QzA2gbh9CEA2CqpQzZ3NfvVGf6Uaw+42RCHLBjo2LYOH7gDjl9I24mcG/Zf2ysgoVc4/VihgiWccmbAh2EuMo8/o7r3uPZevEFkOAeb7n/hQc3v7qJ07gjqQmfS4lwEMT1XjeDkfpipzepSaI+xuNIq/0oTWCgo20CT0z1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TbMYqZ+c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TbMYqZ+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769D9C19425;
	Fri, 24 Apr 2026 13:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037623;
	bh=6N5GuEd+X0HneLfGG2BYi5i2fDn3XscjbMTA1V2+aNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TbMYqZ+cSxEd+7l1CICgizsBavGbkrDslydDudGnFxGZd/wv+hmAyUeKp6zIi8qJx
	 +NLFiwvy4rLnWqEeJ0YSJuI9I8TkdxTYgD/IMIXOBdz9oqCKVPAbFHmv5/JTtMyKcQ
	 Eq4dncq9mVlSxdDe4mZWop+sMqTpGOtxeECRTtMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Naim <dnaim@cachyos.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.0 35/42] ALSA: hda/realtek: Add quirk for Legion S7 15IMH
Date: Fri, 24 Apr 2026 15:31:00 +0200
Message-ID: <20260424132427.786241385@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132420.410310336@linuxfoundation.org>
References: <20260424132420.410310336@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Naim <dnaim@cachyos.org>

commit 67f4c61a73e9b17dc9593bf27badc6785ecadd78 upstream.

Fix speaker output on the Lenovo Legion S7 15IMH05.

Cc: stable@vger.kernel.org
Signed-off-by: Eric Naim <dnaim@cachyos.org>
Link: https://patch.msgid.link/20260413154818.351597-1-dnaim@cachyos.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7605,6 +7605,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x17aa, 0x3801, "Lenovo Yoga9 14IAP7", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	HDA_CODEC_QUIRK(0x17aa, 0x3802, "DuetITL 2021", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3802, "Lenovo Yoga Pro 9 14IRP8", ALC287_FIXUP_TAS2781_I2C),
+	SND_PCI_QUIRK(0x17aa, 0x3811, "Legion S7 15IMH05", ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3813, "Legion 7i 15IMHG05", ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3818, "Lenovo C940 / Yoga Duet 7", ALC298_FIXUP_LENOVO_C940_DUET7),
 	SND_PCI_QUIRK(0x17aa, 0x3819, "Lenovo 13s Gen2 ITL", ALC287_FIXUP_13S_GEN2_SPEAKERS),


