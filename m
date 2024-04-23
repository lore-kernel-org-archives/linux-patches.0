Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC53B143888;
	Tue, 23 Apr 2024 21:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908638; cv=none; b=O6tVfhjWSlgK0+31nZpCIG+xdzqvwRlNokEYc1+uO4gOigHtpflz7vGOdufOwQUgmDaLQihVpwFzEEr7hb/h/IdHHR9xSDq9VS9xF6M0zf4PmBsr7D4Yajr4rEFX7LlvCbu0jw5sRm1kBTwKoH7p94LKtjU2Bm0RR6Tgb+B4rIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908638; c=relaxed/simple;
	bh=T4uVqet01Sdq9W5TsXoIhPokB3VQJVnQSVk2ljGEf0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nypPMnMbueO4VleiofiF7/1Vcd37XMAMvIz6r45/jGn9O5LOLaM71OVp8hIBHIkTv7mQ6hkp+0A4lCYhBW83UFVqRJXw44NbwdpDO5TGsBTmNu1GRtlzgSKnN2PjJqdxFKo1/tntYcmSmVE7sCr3e82zEtLWqs95orJyLDDzg48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HqibRayN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HqibRayN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4BEEC32781;
	Tue, 23 Apr 2024 21:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908637;
	bh=T4uVqet01Sdq9W5TsXoIhPokB3VQJVnQSVk2ljGEf0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HqibRayN79s4Kzr/Ab0OMsBw/C+kv1MqOYdkQs1hsux4lpYoC5rGZBzcG22MWFJUt
	 ycTKHRIELlEOOjc9LxpTAbGcc9MpbdLyPBxmTmNwvvJ2f2Ql6GH1ZPAQTHeldiRwxm
	 xbzmWPT8G0k8JceMipy1BSM0a739SgcWnNLwRbfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Ding <shenghao-ding@ti.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 102/158] ALSA: hda/tas2781: Add new vendor_id and subsystem_id to support ThinkPad ICE-1
Date: Tue, 23 Apr 2024 14:38:59 -0700
Message-ID: <20240423213859.071268737@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shenghao Ding <shenghao-ding@ti.com>

commit f74ab0c5e5947bcb3a400ab73d837974e76fad23 upstream.

Add new vendor_id and subsystem_id to support new Lenovo laptop
ThinkPad ICE-1

Signed-off-by: Shenghao Ding <shenghao-ding@ti.com>
Cc: <stable@vger.kernel.org>
Message-ID: <20240411091823.1644-1-shenghao-ding@ti.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10203,6 +10203,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x222e, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x2231, "Thinkpad T560", ALC292_FIXUP_TPT460),
 	SND_PCI_QUIRK(0x17aa, 0x2233, "Thinkpad", ALC292_FIXUP_TPT460),
+	SND_PCI_QUIRK(0x17aa, 0x2234, "Thinkpad ICE-1", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x2245, "Thinkpad T470", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x2246, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x2247, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),


