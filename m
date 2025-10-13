Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7EC330E0C7;
	Mon, 13 Oct 2025 15:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370142; cv=none; b=LrOSsOEtNtuYXKBJPnY1lUSUMTC2+WJU80JbRNMwSQEWWWy4r6er5ARG7RMclw7G4qeQjrbkdDlSdNvw9mpHXOZkBSy+gDj4AqhPRkvGZCfV8zohEdQvQ7fYWf3IzC/Pz0qvI2izjs1BEjEocY4xbB172GZ3j7BMNDgUdDW7U+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370142; c=relaxed/simple;
	bh=+o+0bQUUOCbSylMWvL/EcsZJsNKbzm12344QEbja4Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ITvkVgmG17/h2S9fB21FxAp86jslLI3+IiJPyzL4yWtaK0q59Zs3z2RJL3pB8VDM6m1BG87JTv/L5EjF016SUn7DPzPwvDM7nuN6uApAOUetJtp91ZJhi4GibBJO3qb/Mk8mcQMtcSej3yN8u99+7Z5o/qpcUrn6dCEXSFP7UPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JKx/Jkr+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JKx/Jkr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F7CC4CEE7;
	Mon, 13 Oct 2025 15:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370142;
	bh=+o+0bQUUOCbSylMWvL/EcsZJsNKbzm12344QEbja4Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JKx/Jkr+TB9wB/wxWEFgJ7Gg6VOzBbYr5WRSw14Ba5kVtOFNZb5TNEfokGme908ZY
	 +rDPpYSWBiImrjyG6nkMq+Abq8ddewWihu0SJtJSU0J5uMtQbr4BkTbeYx+X9h47Ve
	 PjmkR1RC5wjxbL8RuzcSaeFl38IyMFGt1ac3QVGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Steve Kendall <skend@chromium.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.17 494/563] ALSA: hda/hdmi: Add pin fix for HP ProDesk model
Date: Mon, 13 Oct 2025 16:45:55 +0200
Message-ID: <20251013144429.190471407@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven 'Steve' Kendall <skend@chromium.org>

commit 74662f9f92b67c0ca55139c5aa392da0f0a26c08 upstream.

The HP ProDesk 400 (SSID 103c:83f3) also needs a quirk for
enabling HDMI outputs.  This patch adds the required quirk
entry.

Signed-off-by: Steven 'Steve' Kendall <skend@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/hdmi/hdmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/hdmi/hdmi.c
+++ b/sound/hda/codecs/hdmi/hdmi.c
@@ -1583,6 +1583,7 @@ static const struct snd_pci_quirk force_
 	SND_PCI_QUIRK(0x103c, 0x83e2, "HP EliteDesk 800 G4", 1),
 	SND_PCI_QUIRK(0x103c, 0x83ef, "HP MP9 G4 Retail System AMS", 1),
 	SND_PCI_QUIRK(0x103c, 0x845a, "HP EliteDesk 800 G4 DM 65W", 1),
+	SND_PCI_QUIRK(0x103c, 0x83f3, "HP ProDesk 400", 1),
 	SND_PCI_QUIRK(0x103c, 0x870f, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x871a, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x8711, "HP", 1),


