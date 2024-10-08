Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3AA1DE89D;
	Tue,  8 Oct 2024 12:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392296; cv=none; b=c1QiYOS3q/YR+TgGIKk6w8Kf1aSG6UgNMtlhCJsA5/O84fasFBetk08GXy7Esv9WrmhQuaYmRotqV8HP9JDCjqnyXHUpbGwV60bPEAF5Ls+y7By/TqI13rMxzU63XwzRqHMQIQjd96rUgNWWhpOSTffLGuwjnZ3xT0RgjWO5f8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392296; c=relaxed/simple;
	bh=C7iGIHDpD1kJIkMPoK1zyEORLcflsUUJctma+Mh8jVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HfMXC82hFpmR2zYJpZxR1UEZoxTFV5K+aEZCoRrhB1jY6hEV/+H68Gl5DRZIAE7FLvai2LqjKWj59oHzK29sEOyOoCiXWx7YV8YyyBH4l+SjUwzhCF+WiTLYUSenKFokBiwlUOs36vOhJRVfa/9UaWo6Tmb1HQsbBdUKF5rkyFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gjf4tvtG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gjf4tvtG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AAEEC4CECC;
	Tue,  8 Oct 2024 12:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392295;
	bh=C7iGIHDpD1kJIkMPoK1zyEORLcflsUUJctma+Mh8jVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gjf4tvtG632Wcwb+kxyOmbut21GWQGq3r/C1MDv6vTzGgVlWfEHNKvTY/999sYwJL
	 gbR0ZCU2697QMhSNIiV0J2YhaSEuXbvTwHsRhRdgji/bp2hSd7BC8KjsYO5N4A77zb
	 YT1IsE3plEjkm/CiQF4SriPUQW3rREXTLlyHilI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baojun Xu <baojun.xu@ti.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.11 372/558] ALSA: hda/tas2781: Add new quirk for Lenovo Y990 Laptop
Date: Tue,  8 Oct 2024 14:06:42 +0200
Message-ID: <20241008115716.934667015@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baojun Xu <baojun.xu@ti.com>

commit 49f5ee951f11f4d6a124f00f71b2590507811a55 upstream.

Add new vendor_id and subsystem_id in quirk for Lenovo Y990 Laptop.

Signed-off-by: Baojun Xu <baojun.xu@ti.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240919075743.259-1-baojun.xu@ti.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10892,6 +10892,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x38cd, "Y790 VECO DUAL", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38d2, "Lenovo Yoga 9 14IMH9", ALC287_FIXUP_YOGA9_14IMH9_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x38d7, "Lenovo Yoga 9 14IMH9", ALC287_FIXUP_YOGA9_14IMH9_BASS_SPK_PIN),
+	SND_PCI_QUIRK(0x17aa, 0x38df, "Y990 YG DUAL", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38f9, "Thinkbook 16P Gen5", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x38fa, "Thinkbook 16P Gen5", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),


