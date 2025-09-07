Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6864D1CDFAC;
	Sun,  7 Sep 2025 20:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275883; cv=none; b=BJrI7oaWazxIPh5u8Hv32vMw91hyZzbpJ3QJvzG84ZQt273t6d2owgHN0baXElWEHpkdEasbApjNawU1jpKPAWldiYuzGwqObl8E6JWvsFBwvz0ITc6q7eTX8HZ+lcTSs+clpNL7zU4FRo6qYUUlJ3W+wCaFVK0uZUZsXtPZhaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275883; c=relaxed/simple;
	bh=FE6LBM8IYPRDsYLu/8JcPMBe/VfKf7dt3rFHgRW7AmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIIeB4fltS1pcKany55sKRW5G+bW5QevcUg+xcID3ukrTtDjjCtZ6yzV3e5GspSoppwGWER2uCWqgCR5HtDTN1bTPYwvH37aLiCPWSlyAbiExMTYADGhUOg1ktpRhOC4TaLZXRq+F68NPjQN+zCKApbu+VSRE6spABLJx0kJ3FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DUrSjERO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DUrSjERO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2291C4CEF0;
	Sun,  7 Sep 2025 20:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275883;
	bh=FE6LBM8IYPRDsYLu/8JcPMBe/VfKf7dt3rFHgRW7AmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DUrSjEROZ4TaD8J8kY3cCsVYAd9+FSHp3LinSkHL8k4lh1SMQZ01Vrub01a2wqNQN
	 YbZdI8/lwmLm01/RAoMgj4KyHQ64lacWFSQOBjnp3SaDXXNL56lzj2s/OgRzUTaN7y
	 AzB+dAxQUd6tyk+Vhs8n7eHQ/BxtJCcR6KeJdS4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 39/45] ALSA: hda/hdmi: Add pin fix for another HP EliteDesk 800 G4 model
Date: Sun,  7 Sep 2025 21:58:25 +0200
Message-ID: <20250907195602.135851376@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195600.953058118@linuxfoundation.org>
References: <20250907195600.953058118@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit bcd6659d4911c528381531472a0cefbd4003e29e upstream.

It was reported that HP EliteDesk 800 G4 DM 65W (SSID 103c:845a) needs
the similar quirk for enabling HDMI outputs, too.  This patch adds the
corresponding quirk entry.

Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250901115009.27498-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_hdmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1820,6 +1820,7 @@ static int hdmi_add_cvt(struct hda_codec
 static const struct snd_pci_quirk force_connect_list[] = {
 	SND_PCI_QUIRK(0x103c, 0x83e2, "HP EliteDesk 800 G4", 1),
 	SND_PCI_QUIRK(0x103c, 0x83ef, "HP MP9 G4 Retail System AMS", 1),
+	SND_PCI_QUIRK(0x103c, 0x845a, "HP EliteDesk 800 G4 DM 65W", 1),
 	SND_PCI_QUIRK(0x103c, 0x870f, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x871a, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x8711, "HP", 1),


