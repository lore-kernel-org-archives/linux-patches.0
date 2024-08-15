Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCC31684AC;
	Thu, 15 Aug 2024 14:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730455; cv=none; b=CFkEXa8Dex24rMPqg4nyE5lR0mbo3XFqnq5lFM85lzgDWK5LU4CbEBSKXuHvw6zyksiQWpVk/c/aMpIFFN+V9AdrssGP1StCtJjx7Xn0jHGfGLEPRhUTmy6Z2AvuXjta1Kb9BYIPVVJ1vQ/AnGEt9vWDufJ5HBIzYXqPp+d4ShQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730455; c=relaxed/simple;
	bh=1NeDNCmDZ7O2wiuNX16+MsdeeK1xZRZDBFRrYqVnNNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ALasg+dK9+qBaLwgw65gV1Fln763uqpkGedLSkfaMdhsCPBoMt9FxrIudxY7UKMEPW8XcMoo4QtTcudQeghePEJy6QhYVS0n3n8GLH6lf0aogLu5xxdXoEs2IqtYXMVdUJgNWW4/0UiPXbR7Ya8r0dh9vnWfGSDFbY6b15/myyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vi3mK++3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vi3mK++3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107A0C32786;
	Thu, 15 Aug 2024 14:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730455;
	bh=1NeDNCmDZ7O2wiuNX16+MsdeeK1xZRZDBFRrYqVnNNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vi3mK++3WM29HMtZm0J0SyJCxwWnapLbfgxQoTtcdiNSncIQmngQZgDNznvgylXwE
	 YtZ3nZx752wxq9Q0NKJDID+Xcm4EnrtcvcWcijYUW83vZ46daNto583Ev7Fe2ScHRl
	 tvunfxI/BbDVUyaN0wOR/t1mRM4ux4MMGfl8cbY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 414/484] ALSA: usb-audio: Re-add ScratchAmp quirk entries
Date: Thu, 15 Aug 2024 15:24:32 +0200
Message-ID: <20240815131957.445216667@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 03898691d42e0170e7d00f07cbe21ce0e9f3a8fa ]

At the code refactoring of USB-audio quirk handling, I assumed that
the quirk entries of Stanton ScratchAmp devices were only about the
device name, and moved them completely into the rename table.
But it seems that the device requires the quirk entry so that it's
probed by the driver itself.

This re-adds back the quirk entries of ScratchAmp, but in a
minimalistic manner.

Fixes: 5436f59bc5bc ("ALSA: usb-audio: Move device rename and profile quirks to an internal table")
Link: https://patch.msgid.link/20240808081803.22300-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks-table.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 6d332c9eb4445..b03d671f218d6 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2594,6 +2594,10 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	}
 },
 
+/* Stanton ScratchAmp */
+{ USB_DEVICE(0x103d, 0x0100) },
+{ USB_DEVICE(0x103d, 0x0101) },
+
 /* Novation EMS devices */
 {
 	USB_DEVICE_VENDOR_SPEC(0x1235, 0x0001),
-- 
2.43.0



