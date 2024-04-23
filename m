Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1391F20B3E;
	Tue, 23 Apr 2024 21:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908525; cv=none; b=vCpW+SUHQ1JkBZvs4Za47MR1y9OzhGO+e3ju6BUb4YEpQf1qMwY7pKg+XeLzmE/pCfsRe5G8F72uFkzHV09fdYNgcr6bYmu6SrJyGHjInqAFYghMMzTkTuehPPg9A78+aOBCZf2rDG5SEBDOScEmeewFeDfiYC2J4OG90OQSd5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908525; c=relaxed/simple;
	bh=gKT03Iqv9FxluPDj37fvqaLenWrSz9T3q+P3/Ik9eR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bo42WxR8tjfn5P6WvwZSnk4PvP65NrbNNxqtcgQ9GDEJl/P5ljUFotE8ozQcxlQp8qYDOYnuJOEcbJqQxiLjwSJ24hh3j9X0PSMb+cqtrEybm+42OZdVU3DnkfB5gei+zJGBQzhcOipsan0l09zIrBxHnC4qh/VJ6pS1ouEnJW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zVIzrY9n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zVIzrY9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4ACC32781;
	Tue, 23 Apr 2024 21:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908524;
	bh=gKT03Iqv9FxluPDj37fvqaLenWrSz9T3q+P3/Ik9eR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zVIzrY9ncMwZkLd/b+DfrJdyKbrqqrOLdSs+Q10bhKlSdMuXa85/gdGc5fxwhEm4e
	 z7AHc8vielvPshtuQBzTVIhnBQ9E0Wru/KHSwIKsnWGxxOC4gO7HgxR1nujUdKNb80
	 ciWP4ngqg94mpKW0SM1eOfdOwUo9apbUflFyeekU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Ding <shenghao-ding@ti.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.8 091/158] ALSA: hda/tas2781: Add new vendor_id and subsystem_id to support ThinkPad ICE-1
Date: Tue, 23 Apr 2024 14:38:33 -0700
Message-ID: <20240423213858.912930865@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -10320,6 +10320,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x222e, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x2231, "Thinkpad T560", ALC292_FIXUP_TPT460),
 	SND_PCI_QUIRK(0x17aa, 0x2233, "Thinkpad", ALC292_FIXUP_TPT460),
+	SND_PCI_QUIRK(0x17aa, 0x2234, "Thinkpad ICE-1", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x2245, "Thinkpad T470", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x2246, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x2247, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),


