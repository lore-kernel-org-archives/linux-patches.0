Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA35277CAF;
	Wed, 30 Jul 2025 09:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868315; cv=none; b=pwPJvjTR/TmHqJQgUpGguwJWY7R+FlCwkN17kr4c3UwbuFDPGiiVik2qEAJzRDOLQ3e3OuEaQNBBF+/uO4jie5TZdwxAhDqckATEIXrZ8SEoiFkyDg1FrWFdopRuZ95HsdVnNSJjUk+iFzM6NDo6uC5eTbMvq3uDPt0mncG+v+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868315; c=relaxed/simple;
	bh=8kY1zHeaeIk5Mb6HajwsjzWylEA1xet6Ew+MhmQKoDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWh7lXN0q78w6AdgAw640hWHUnc6u6Sp1f5JGxxuIOiqRjgg3XC73lvVNfQDgw20EWuuAc9l5eMSnSS6tDU4BKPKfzqwbfVK2OPbqXjsh4OyECjqfOQOGiyKk88SejG8AcaRATfI7t+uhd6XARQP87hbYA5h7rFfrzjTU6PJM8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JtS+U/Vi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JtS+U/Vi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD53AC4CEE7;
	Wed, 30 Jul 2025 09:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868315;
	bh=8kY1zHeaeIk5Mb6HajwsjzWylEA1xet6Ew+MhmQKoDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JtS+U/ViNEfaiCah58RbOkLqsoRNBQb+YlxnXIYQWYQQJ8r9MmjTjenMRSFBQ3xom
	 3kZEyFHBQ9V9PiU8R/nzVTmD8XwXfJSU/3awfZ2pntlbRxQrpn0cMVxV56P2VpuaUe
	 VdWKbwTYMlS5ZjTZaIrk4UQzxyNdGr8nJIE9hqAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawid Rezler <dawidrezler.patches@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 34/76] ALSA: hda/realtek - Add mute LED support for HP Pavilion 15-eg0xxx
Date: Wed, 30 Jul 2025 11:35:27 +0200
Message-ID: <20250730093228.162867790@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
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

From: Dawid Rezler <dawidrezler.patches@gmail.com>

commit 9744ede7099e8a69c04aa23fbea44c15bc390c04 upstream.

The mute LED on the HP Pavilion Laptop 15-eg0xxx,
which uses the ALC287 codec, didn't work.
This patch fixes the issue by enabling the ALC287_FIXUP_HP_GPIO_LED quirk.

Tested on a physical device, the LED now works as intended.

Signed-off-by: Dawid Rezler <dawidrezler.patches@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250720154907.80815-2-dawidrezler.patches@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10103,6 +10103,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8788, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x87b7, "HP Laptop 14-fq0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x87cc, "HP Pavilion 15-eg0xxx", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87d3, "HP Laptop 15-gw0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87df, "HP ProBook 430 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87e5, "HP ProBook 440 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),


