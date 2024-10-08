Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D49D1DF99C;
	Tue,  8 Oct 2024 13:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393798; cv=none; b=hleq11vxRRWYaA2GbHIVnmEYkW+H2VmsS4SEoy7mkROCSd7Qk9RrPbGlLET9DAF27uxDjpGseOHoTtfPBjkfxbE1YC/o1RMBfCj3vhu8dCGuvDX6oIqv+qjzSdJPEqwI3TF953Z7g30TsfwAm3BcuQjYH/LERCXswLP8AEbnul8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393798; c=relaxed/simple;
	bh=qyuSjVzMPKYmSkS9Dr1xg6QPS1115hx8IP1QiKFIl4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQIE6qt5VjSv4PTOlbCTZerPKdrsdMtCMiS6uSgTYDMPBWDlGUqXWMRO1pVqfWA6dhVxYJ5ol4oq6y0tofqYtbg3cWNS2C/DQkG5pWJfkWZGEM2NC/VacG//a9lYJXbJOXeHiPSMcsd4KhqA6Zt8fpglv741hFjq4ysum/xl0WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WHkPn+CO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WHkPn+CO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C368C4CEC7;
	Tue,  8 Oct 2024 13:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393798;
	bh=qyuSjVzMPKYmSkS9Dr1xg6QPS1115hx8IP1QiKFIl4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WHkPn+COeCF4qlIRvbnCK2cLNHtwLMNoelSvFZBurpY3YWhb6RFy51XQzqmaVfwYp
	 D5dKDkjdsM9KTpcMF1n0SwHrwx2rZjh6tIzHQgMrtisWeqie7jUVg2RerwsccvjbbE
	 tRCuvCNkYn+M4vD2oh25rjCdb3gdAYmzHXgUwotc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Lalinsky <lalinsky@c4.cz>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 227/386] ALSA: usb-audio: Add native DSD support for Luxman D-08u
Date: Tue,  8 Oct 2024 14:07:52 +0200
Message-ID: <20241008115638.337718377@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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
@@ -2123,6 +2123,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_DISABLE_AUTOSUSPEND),
 	DEVICE_FLG(0x17aa, 0x104d, /* Lenovo ThinkStation P620 Internal Speaker + Front Headset */
 		   QUIRK_FLAG_DISABLE_AUTOSUSPEND),
+	DEVICE_FLG(0x1852, 0x5062, /* Luxman D-08u */
+		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY),
 	DEVICE_FLG(0x1852, 0x5065, /* Luxman DA-06 */
 		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY),
 	DEVICE_FLG(0x1901, 0x0191, /* GE B850V3 CP2114 audio interface */


