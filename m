Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF541D0492;
	Tue, 15 Oct 2024 11:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993408; cv=none; b=uovVv6Yt3wHr5BgqwTpsSKMJd/oBP/NeUJxU6Y0CSf2XMjTkD2T+0pg8yoBhOMYp0a2zFapfFxHMw+r6PzeTl8SBbpE7kgncNb6JzD/e+p1n1mT1ooPHgWMR0Y5FiEZglR14EE0Cbs72wLpnDcCj9FrKOWow67PqDcZzgN/hgvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993408; c=relaxed/simple;
	bh=FuFPZueiUPOWFtE4JmKq0791RR/tPZjxqnAXqANVBNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/rrnQbf4M4qQ/Ihnl1Mar+IXmiFdEMgo/sB2PWiW9FFxKJ9ToXySb2cDxVHtUTqWGa5oO53QBg1h293nbCIooup5b4rVD+KHkGKmJSsvfLzZ9PgLNQxgSKs57qwe9xVXKJGqb2ehbho8H/ZSbY+7Rf+KeC2iAbLzxyKtIfxjjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EYLV4x4E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EYLV4x4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1043DC4CEC6;
	Tue, 15 Oct 2024 11:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993408;
	bh=FuFPZueiUPOWFtE4JmKq0791RR/tPZjxqnAXqANVBNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EYLV4x4EEBwdHQliiHSx0MGUy6B4yZZHHylYKArVJwapoDsam+BGm4JLxw4kdgJNX
	 4WXYpWmuDnwk06q5d9hO3hxKxuftJp81WO3xblTj5pAjoxfA9GaKEkiquOHsmQSCxa
	 GvgFl2TznbB/CUdIqtDrLv8XD7cMFcHccNUntPGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oder Chiou <oder_chiou@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 402/691] ALSA: hda/realtek: Fix the push button function for the ALC257
Date: Tue, 15 Oct 2024 13:25:50 +0200
Message-ID: <20241015112456.293770228@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Oder Chiou <oder_chiou@realtek.com>

[ Upstream commit 05df9732a0894846c46d0062d4af535c5002799d ]

The headset push button cannot work properly in case of the ALC257.
This patch reverted the previous commit to correct the side effect.

Fixes: ef9718b3d54e ("ALSA: hda/realtek: Fix noise from speakers on Lenovo IdeaPad 3 15IAU7")
Signed-off-by: Oder Chiou <oder_chiou@realtek.com>
Link: https://patch.msgid.link/20240930105039.3473266-1-oder_chiou@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 7e035d69f9de5..422d65f9179ba 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -577,6 +577,7 @@ static void alc_shutup_pins(struct hda_codec *codec)
 	switch (codec->core.vendor_id) {
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x10ec0257:
 	case 0x19e58326:
 	case 0x10ec0283:
 	case 0x10ec0285:
-- 
2.43.0



