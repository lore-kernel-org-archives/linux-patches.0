Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5607221DA4;
	Thu, 12 Dec 2024 17:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023274; cv=none; b=gzWp5YdKYYd4JMsHxQWwZ2iRjjA7GSJzWY/RAeSYe/NHbKy23Z6VytZ0JEOIumfaO7TbUnlQTuYBUovS9du5FBGScAgBTJ2XRTARbCko8lIKuAjAbPGdHRVR1UbL8PtbyHKsUWTa67/TFw7wfutl9tsbdVhj+PmtcIsgbvoCpRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023274; c=relaxed/simple;
	bh=EjGJR0EHtTX4bWezpDrBQPsieeSB8MdSDCUXqwCaA1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gus+R5LXozPTSwv9IMPjVmL6zgbWnPky1AJzkDjIi6PxVXVRIyN7pI9C5to4EJzNtxywRhLcb6ORkJY285hT3sOVUx1sVdrDB7ZD7IANMix2VspEV9dwc2vEP+PsU/h0tZ8g8+5r4V840AWAksDFW8I9P+u8YYOFPbveMFzLJQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ED445Vuc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ED445Vuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0CAC4CECE;
	Thu, 12 Dec 2024 17:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023274;
	bh=EjGJR0EHtTX4bWezpDrBQPsieeSB8MdSDCUXqwCaA1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ED445VuckiX2A7uwyMycVoGbQJj7eUK515s9MOIyGmYCtsCMz9+RyYfF6oVOW7kno
	 I5Buc2oUqQ3Uy9haIHVIk3miAQsx7Ba3bkhIsrbBODmWy6YRgzZ6qxVHjfzg0+WiLd
	 O1rVlVYB7V+puf2/N6dnC2KNlNrGKaAh8hTBlxf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nazar Bilinskyi <nbilinskyi@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 451/565] ALSA: hda/realtek: Enable mute and micmute LED on HP ProBook 430 G8
Date: Thu, 12 Dec 2024 16:00:46 +0100
Message-ID: <20241212144329.548523771@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nazar Bilinskyi <nbilinskyi@gmail.com>

commit 3a83f7baf1346aca885cb83cb888e835fef7c472 upstream.

HP ProBook 430 G8 has a mute and micmute LEDs that can be made to work
using quirk ALC236_FIXUP_HP_GPIO_LED. Enable already existing quirk.

Signed-off-by: Nazar Bilinskyi <nbilinskyi@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241130231631.8929-1-nbilinskyi@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9212,6 +9212,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x87b7, "HP Laptop 14-fq0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87d3, "HP Laptop 15-gw0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
+	SND_PCI_QUIRK(0x103c, 0x87df, "HP ProBook 430 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87e5, "HP ProBook 440 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87e7, "HP ProBook 450 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f1, "HP ProBook 630 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),


