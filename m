Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B77914A4E6;
	Tue, 20 Feb 2024 21:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464613; cv=none; b=qcE7Qn0o6NpaJ8dd0MStuVUTmJT2/EXhOuqISsymWFm+PMZuoKVVUSCDqu9REBaT19A17NNCH5rgMyTNa/qrETqWcMPZ0U1cko2LLg2gF3DCzos29+0QfouWxzF9zN2mTjYZxUUJudaLzJIw6F4xFvlwnRSbkVaWB6bJaVwma8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464613; c=relaxed/simple;
	bh=pGZL3ISmAjolod7TzH/TUYuc9f6HI72FYRRvtp5DT50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQE1ZFN0p+rD+LeiqIFcpYV5EY6eHmYlZHr88B9kN6ghyX8pj5eIWleBLJ6U/xDUGrbV726om3ddUxYE5N5RJdNdeljZ857ePcsYtsqf9KaRilYpqzyaGGtD5gh1aF7vO3RYmM/7XnUL7TV0wl7MFmZDyGiIe7Ylik38G6xzFLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i8DQwBvA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i8DQwBvA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C61CC433F1;
	Tue, 20 Feb 2024 21:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464613;
	bh=pGZL3ISmAjolod7TzH/TUYuc9f6HI72FYRRvtp5DT50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i8DQwBvAjQXqh47NF66RydYiIeanJQ2o1B1mOY3gDcLcBppvU93LIYhkkFsCqz+nE
	 rY3iOqx+GuUAGrtk1oRV8TaZOS/k2O6qNNwmPP+lBuiBxVHwjid6KOLTzjPC6Kii0q
	 F3jxAgIcnWHi2nEQZO6cJeuLIJyeTyZ+PlX0/Ciw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luka Guzenko <l.guzenko@web.de>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.7 080/309] ALSA: hda/realtek: Enable Mute LED on HP Laptop 14-fq0xxx
Date: Tue, 20 Feb 2024 21:53:59 +0100
Message-ID: <20240220205635.701639979@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luka Guzenko <l.guzenko@web.de>

commit f0d78972f27dc1d1d51fbace2713ad3cdc60a877 upstream.

This HP Laptop uses ALC236 codec with COEF 0x07 controlling the
mute LED. Enable existing quirk for this device.

Signed-off-by: Luka Guzenko <l.guzenko@web.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240128155704.2333812-1-l.guzenko@web.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9840,6 +9840,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8786, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8787, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8788, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x87b7, "HP Laptop 14-fq0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87e5, "HP ProBook 440 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87e7, "HP ProBook 450 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),


