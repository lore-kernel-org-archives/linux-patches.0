Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6C426A1CF;
	Mon, 13 Apr 2026 16:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096808; cv=none; b=I+AvRUDkPEjTq49TOjMOtQ+WC3qvds6ocxDZHvlirrkBHy+qIb1sPtCteO5CA61RLFzY3F6ourT+60XlwHfKEl5JuNzHhScuVyq+3DCmwWm9V7QQzBApQXuEaPKCeef7upJDVuyyW7d1UPdQoKauGqkftMPehwmmpZ+V6K/i0g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096808; c=relaxed/simple;
	bh=wxUsXBK/v6RMyPdexYtcRMOMCjzbiFcpcaElTWeY4TI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6zZew8VXLd21mSpqvgATYwobV9/wTr0vZz2iNsQQIcI8ha2JER0ogN2aef23CFbpUg8U4xKs6U2Wkuw58rIE/L0VG9LbZ4KOzQ0U/aPqC+tyRcYkXtKnqvDBdOsTHeFoPnx3NUPGzC/lD18azZOnDvLxWqCWWNOkvyTS+sZ0aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VOCnTkGU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VOCnTkGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FC6C2BCAF;
	Mon, 13 Apr 2026 16:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096808;
	bh=wxUsXBK/v6RMyPdexYtcRMOMCjzbiFcpcaElTWeY4TI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VOCnTkGUv8ozG6ZJ6QYO7+T6kurYXuKc50wCrsrlCVpHas30SWfGkFQWJZYdcvIwZ
	 7N4CSmDs60PXYHUqCN0lwUTfeZ+clB1ZFHkgBKSrfpAxZaeyge0mPAgqSHDxb1mYNY
	 TzqKK4V5XgM/cIxK/OG2liOuvyOAbOH8kVIhdU5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Erhardt <aer@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 70/70] ALSA: hda/hdmi: Add quirk for TUXEDO IBS14G6
Date: Mon, 13 Apr 2026 18:01:05 +0200
Message-ID: <20260413155730.789275541@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
References: <20260413155728.181580293@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Erhardt <aer@tuxedocomputers.com>

commit d649c58bcad8fb9b749e3837136a201632fa109d upstream.

Depending on the timing during boot, the BIOS might report wrong pin
capabilities, which can lead to HDMI audio being disabled. Therefore,
force HDMI audio connection on TUXEDO InfinityBook S 14 Gen6.

Signed-off-by: Aaron Erhardt <aer@tuxedocomputers.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20260218213234.429686-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_hdmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1999,6 +1999,7 @@ static const struct snd_pci_quirk force_
 	SND_PCI_QUIRK(0x1043, 0x86ae, "ASUS", 1),  /* Z170 PRO */
 	SND_PCI_QUIRK(0x1043, 0x86c7, "ASUS", 1),  /* Z170M PLUS */
 	SND_PCI_QUIRK(0x1462, 0xec94, "MS-7C94", 1),
+	SND_PCI_QUIRK(0x1558, 0x14a1, "TUXEDO InfinityBook S 14 Gen6", 1),
 	SND_PCI_QUIRK(0x8086, 0x2060, "Intel NUC5CPYB", 1),
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", 1),
 	{}


