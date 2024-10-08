Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8EE189910;
	Tue,  8 Oct 2024 12:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392326; cv=none; b=K7bO5mC6BE38CvAubEicB/3cKbzmtcvxd/Ga6YFAmA8RsP9lLKeB8HA1xIfdZEZ+osck0BSswfd3/nOuTPXzQYf1O7NJNKWazeuYmW5ucQM0C/CoqubK7vgQe/Ido+Hl9ici1wsr7im9AN2nNp+rYpb2etwf0s5iBOB05aUsGPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392326; c=relaxed/simple;
	bh=FSk9bbmNyFnskSGusHlVxORArb/YQAv53OOPYRruw44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T70UggQ2iHBB5+p8vlojzFMu7pS2dNaRzIch6/ybXQsp88lpcQ0BVeKmxZQ03fEaBy521afFcAJphYgC57yHhldyWEQY/nVs0iC67xhIvoR7TgTxz3aevwvhDqHKbYr8WM6pWMXUcMO9vRV59o3fqFTQ4sXGBiaNMsiBq/IMpJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HAck8mvL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HAck8mvL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13428C4CEC7;
	Tue,  8 Oct 2024 12:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392326;
	bh=FSk9bbmNyFnskSGusHlVxORArb/YQAv53OOPYRruw44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HAck8mvLY+CKPRwvqufaznVAcaLUGe15DCX+17v+LWh7Lv/RE80Uz5LVxmmTDo1ck
	 KiF9uAD5xwyTEGQnmVOsmip3iwPDobS54p2gshPoznZXNtcvR0LREBKAlJm+GyU47e
	 Lwel+0gL9M74uKZW2mKiZpBVzBgE9NZ9PnLPWGFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Lalinsky <lalinsky@c4.cz>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.11 375/558] ALSA: usb-audio: Add native DSD support for Luxman D-08u
Date: Tue,  8 Oct 2024 14:06:45 +0200
Message-ID: <20241008115717.051507390@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Lalinsky <lalinsky@c4.cz>

commit 6b0bde5d8d4078ca5feec72fd2d828f0e5cf115d upstream.

Add native DSD support for Luxman D-08u DAC, by adding the PID/VID 1852:5062.
This makes DSD playback work, and also sound quality when playing PCM files
is improved, crackling sounds are gone.

Signed-off-by: Jan Lalinsky <lalinsky@c4.cz>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241003030811.2655735-1-lalinsky@c4.cz
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2221,6 +2221,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_DISABLE_AUTOSUSPEND),
 	DEVICE_FLG(0x17aa, 0x104d, /* Lenovo ThinkStation P620 Internal Speaker + Front Headset */
 		   QUIRK_FLAG_DISABLE_AUTOSUSPEND),
+	DEVICE_FLG(0x1852, 0x5062, /* Luxman D-08u */
+		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY),
 	DEVICE_FLG(0x1852, 0x5065, /* Luxman DA-06 */
 		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY),
 	DEVICE_FLG(0x1901, 0x0191, /* GE B850V3 CP2114 audio interface */


