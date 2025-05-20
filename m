Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BD624418D;
	Tue, 20 May 2025 14:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749826; cv=none; b=eOVmZHYCEBBfpdr+xuJMb50GKaEwSfxkgklXC7/4k9oFzSZN8zdHCbgSqEgLXULAtNkYwj7xJL6kjAMVt5ngnqZ9rpvEIrDQO1lfk7m4W/+QzgiIBI8o+hMTAYbbvc2Tod1dXB5MMQ01QIBkW3s4VNKRSpR5716/m5J3L8y+ZDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749826; c=relaxed/simple;
	bh=HV0mx6snSkKeCqwl9XqsCFxLBJNgxKFiRUGnlewCvZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sfbj33/dCwKEQlPtgePyssPbkm9J2NY2UfhpxN6M5aLsRuSmfaw0Au33OsJjJDo16EpZ+YuJZ/4ZNPfDnfguTYwanAd/ls9UouUJmXCYHLNk2mvFGcTsLV89OGJpirNTapnmOWttd+d6ZB/Josm2JORgD8CS89g6NduXYdZCEuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LhDkZOy9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LhDkZOy9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77EB8C4CEE9;
	Tue, 20 May 2025 14:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749825;
	bh=HV0mx6snSkKeCqwl9XqsCFxLBJNgxKFiRUGnlewCvZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LhDkZOy9VfmdcZ8Py55XZYTMlRv5rUREth5FJZHVFw2sFGfXSry0MGcdYFGYBGTR/
	 z9rl07ZQzg8A3g5aREb1lTXKhNnlUpbMjqevFm8ADu8T7249vk+O4WzSJ9sZp/QoHe
	 Y874ZVVAfdRNaxpCdC48Hia+ynw5zsZjq1MxkTS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Heusel <christian@heusel.eu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 072/117] ALSA: usb-audio: Add sample rate quirk for Audioengine D1
Date: Tue, 20 May 2025 15:50:37 +0200
Message-ID: <20250520125806.849362269@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

From: Christian Heusel <christian@heusel.eu>

commit 2b24eb060c2bb9ef79e1d3bcf633ba1bc95215d6 upstream.

A user reported on the Arch Linux Forums that their device is emitting
the following message in the kernel journal, which is fixed by adding
the quirk as submitted in this patch:

    > kernel: usb 1-2: current rate 8436480 is different from the runtime rate 48000

There also is an entry for this product line added long time ago.
Their specific device has the following ID:

    $ lsusb | grep Audio
    Bus 001 Device 002: ID 1101:0003 EasyPass Industrial Co., Ltd Audioengine D1

Link: https://bbs.archlinux.org/viewtopic.php?id=305494
Fixes: 93f9d1a4ac593 ("ALSA: usb-audio: Apply sample rate quirk for Audioengine D1")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Heusel <christian@heusel.eu>
Link: https://patch.msgid.link/20250512-audioengine-quirk-addition-v1-1-4c370af6eff7@heusel.eu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2148,6 +2148,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_FIXED_RATE),
 	DEVICE_FLG(0x0fd9, 0x0008, /* Hauppauge HVR-950Q */
 		   QUIRK_FLAG_SHARE_MEDIA_DEVICE | QUIRK_FLAG_ALIGN_TRANSFER),
+	DEVICE_FLG(0x1101, 0x0003, /* Audioengine D1 */
+		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x1224, 0x2a25, /* Jieli Technology USB PHY 2.0 */
 		   QUIRK_FLAG_GET_SAMPLE_RATE | QUIRK_FLAG_MIC_RES_16),
 	DEVICE_FLG(0x1395, 0x740a, /* Sennheiser DECT */


