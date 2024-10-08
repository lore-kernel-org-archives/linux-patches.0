Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD261DF74A;
	Tue,  8 Oct 2024 12:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390532; cv=none; b=BjBaP/zID/80cEvuOrFODnjp336w8U+uskKrSKakApDhau9TG767fhWIFXdDZal87Tm8y/HAXTNpD1YgfBAgW1968SJT0tfqTFyF78gbGKOu5loOauLhN2Mbs0JRgrk3uOKxUPPFL//0pVqYN3oCR6BWqlxY4JGS94FSyuyAHHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390532; c=relaxed/simple;
	bh=G3qQnRZz07HCi7YzHQ0zqv9TId5+RtwcAwGHyZiTGeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gO/dT1P1rPK4iAipyeVpGfKZe+6hNTg+5C9eCFhPUbVBu30cKcnKZ7zI5Xvq1IsQyimK7/BauO3N8rzgIZXMQdMdFbESkR3abpi9eY6jRY5RhpKrupQCO/qo6UR2u+xTuiYTX+Zfhas/XMwqy6l5fqbSedgip1CYB8HCt8Nw+MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iTUOx8mU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iTUOx8mU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E048C4CED4;
	Tue,  8 Oct 2024 12:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390532;
	bh=G3qQnRZz07HCi7YzHQ0zqv9TId5+RtwcAwGHyZiTGeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iTUOx8mUMgLfk6P6X+oHSt87Ixs7zHOIkSYzo0nx80EpC4b7A6qMW/wdgZJfjpWIH
	 sxSPEATN+hT2YLd1Qw3ENRqjmBHRGK/pCieHna1z9i5b/3Wo8r2gCOkZgrUy4qb9j+
	 h4rKaq5WZHA3fH3/+O6Ta1m8vuJqs68UfamMMi1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Lalinsky <lalinsky@c4.cz>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 317/482] ALSA: usb-audio: Add native DSD support for Luxman D-08u
Date: Tue,  8 Oct 2024 14:06:20 +0200
Message-ID: <20241008115700.907716482@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


