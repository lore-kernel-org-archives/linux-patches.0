Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409971AC44D;
	Mon, 14 Oct 2024 15:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919295; cv=none; b=JOKBEC5xONvwvLYSkLy2ZVkyWD6V41tx37KR9JXuXxlmgPbOWj2fem4lZ9QjFL31V/JFsLhYVhA5xgHjCo7p4G0wBhu92Rgs4vx8X0ZkS5JEcnZNoTyddQN3JZmH8JM+4oXriQGJB+Dg3MLidF74WXPqh9lESY1ocVQDEnOW98w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919295; c=relaxed/simple;
	bh=qtSvVnm/nZcr7PZriW4iJ6QubyO8C7Wm5kQ2KwAYZ+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FzEFQ7C/4RIZxTvQb+w1FufS9RbkuVmAmq5ILeMnlTTQWeLz3uyMJVJ1WWRSkwfTEVib35zPFE4N4ldf+YfzSnoO5sYHXz2+jfPD7MdlZIFBv3Y0ejKf6TWUzSeEnSw5Pf8xmzmbocPodSRdHuO1aFOO1EjcjPQ8FF7WIjhYEtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FGJsId12; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FGJsId12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9406C4CEC3;
	Mon, 14 Oct 2024 15:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919295;
	bh=qtSvVnm/nZcr7PZriW4iJ6QubyO8C7Wm5kQ2KwAYZ+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FGJsId127aR3Of1oNvgox3FwSaHIsJrkTEgtAvhmI+PxWtY7cQ+5a3HRaDuHA1fPQ
	 RmcONpF8fMC6HJXkmkb2th3Fs3QnbRSu/95DXfgH1sohAnSCJFL5Vjpc+euSAGU7JW
	 jsh8dIRMla34v22UkO9Ug3Us0Xw68AqBfbMI4bOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Lalinsky <lalinsky@c4.cz>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 537/798] ALSA: usb-audio: Add native DSD support for Luxman D-08u
Date: Mon, 14 Oct 2024 16:18:11 +0200
Message-ID: <20241014141239.094962519@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2121,6 +2121,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_DISABLE_AUTOSUSPEND),
 	DEVICE_FLG(0x17aa, 0x104d, /* Lenovo ThinkStation P620 Internal Speaker + Front Headset */
 		   QUIRK_FLAG_DISABLE_AUTOSUSPEND),
+	DEVICE_FLG(0x1852, 0x5062, /* Luxman D-08u */
+		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY),
 	DEVICE_FLG(0x1852, 0x5065, /* Luxman DA-06 */
 		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY),
 	DEVICE_FLG(0x1901, 0x0191, /* GE B850V3 CP2114 audio interface */


