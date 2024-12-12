Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84EE6F2FE;
	Thu, 12 Dec 2024 15:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017929; cv=none; b=hpDKm9SqdmYfgkLKrnXRlIH3IZ+0MTCQCEyb3/ZGsBkcIjLbZtSkXDAYF0p+zCNfoxj69ULoAy7nPDL1Zbr7bTWvO1ntP1h+9Acw7VyQg0NjXqDqyHVR6QhHv40uMTHiOMubEMxNP62a5xDBRe7iQnXivAwMhOP159Z3kzn9SIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017929; c=relaxed/simple;
	bh=EaWfMEtfgPy+PxjzgD7EkdHEiRMJ3uhpq/14rjDxi6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K8WRnfu0rnXMeJAQaDhrTCunLu/BMu65QGCN2Tf3Map2mhE8w6ivd4JOU8Eplc5kuACVzLRPjzGR+SO3ecmL1bfY18/38erMpwVx1zexO/45uuOEMZuSRKK0W8EuRSbQheH7jxHngX7Jo09Xgzxc5tnaxH9swIO1B7HvFwLaE1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m2bkfZTZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m2bkfZTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D96C4CECE;
	Thu, 12 Dec 2024 15:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017928;
	bh=EaWfMEtfgPy+PxjzgD7EkdHEiRMJ3uhpq/14rjDxi6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m2bkfZTZebOT/KR0anNojrJyMVI/UtGdesgnRq08HDVwJHvwDNe+VcGc4rT7mQE47
	 Uz5JxvYlhhbIW9o6gB9ExhxvFmcod28Y4K6rcKNYF++tJDGXyLU27Zvx4N4PUKbpQJ
	 73JHA3oL9RctIE5bC0b9Nch3+626n/dzY7wViW0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nazar Bilinskyi <nbilinskyi@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 150/356] ALSA: hda/realtek: Enable mute and micmute LED on HP ProBook 430 G8
Date: Thu, 12 Dec 2024 15:57:49 +0100
Message-ID: <20241212144250.567571517@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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
@@ -9922,6 +9922,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x87b7, "HP Laptop 14-fq0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87d3, "HP Laptop 15-gw0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
+	SND_PCI_QUIRK(0x103c, 0x87df, "HP ProBook 430 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87e5, "HP ProBook 440 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87e7, "HP ProBook 450 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f1, "HP ProBook 630 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),


