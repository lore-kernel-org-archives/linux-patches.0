Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD3D1F4727;
	Wed,  6 Nov 2024 12:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897624; cv=none; b=aElayJgKkZhRWUgkUJul5elDi1yAkFyov8IaUH90ZpFc9AzcSBv+1kO3/O0IoFqYiT7ai4e+V4xYVXjrnbFTg6tBfVLHVSAISst44UnuOaldYDT96sEKtnRPcKC/TgsTq+7W8k/z1dxlHCJwqTXH503Weth811VOOCpfTP6QUXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897624; c=relaxed/simple;
	bh=kxlhaeODGm+H4PevcX2/1CtR3T+NOQj7rM6YgaDWnwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pZFpdDtJ8Iw66t7BeVizbVQljiB6UzdQ+ybsSPVGzB/t/lxnClWxIoYiFuBfIJbix8047Zk5D5XGXE33AD7uHSYPPMH7Bpc0SNQLCVAPkg3HYdXAyWTRgGjL7ySu0xc6n/tZKQa3WWv8zl4YhFp0IQo0WIHvYMBDUe9wSrOGLTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RqOo+Dc1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RqOo+Dc1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5447EC4CECD;
	Wed,  6 Nov 2024 12:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897624;
	bh=kxlhaeODGm+H4PevcX2/1CtR3T+NOQj7rM6YgaDWnwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RqOo+Dc1L6pd4+XToSePcdg4NACjsoSIwXdsjnbHBXXyPdrEhrkIYQyaCJ8SwwyRx
	 52TVEXyG35OuJ0c+H9N3f+EI98f0Ootf0OgQUsh4y3Zt7j5tilcI12cZn/TV2QPaai
	 oEED9oHctWZR9KAdTL3Kqb9ys/F7rgToqi8LpOAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20Sch=C3=A4r?= <jan@jschaer.ch>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 080/151] ALSA: usb-audio: Add quirks for Dell WD19 dock
Date: Wed,  6 Nov 2024 13:04:28 +0100
Message-ID: <20241106120311.057750098@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Schär <jan@jschaer.ch>

commit 4413665dd6c528b31284119e3571c25f371e1c36 upstream.

The WD19 family of docks has the same audio chipset as the WD15. This
change enables jack detection on the WD19.

We don't need the dell_dock_mixer_init quirk for the WD19. It is only
needed because of the dell_alc4020_map quirk for the WD15 in
mixer_maps.c, which disables the volume controls. Even for the WD15,
this quirk was apparently only needed when the dock firmware was not
updated.

Signed-off-by: Jan Schär <jan@jschaer.ch>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241029221249.15661-1-jan@jschaer.ch
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -3465,6 +3465,9 @@ int snd_usb_mixer_apply_create_quirk(str
 			break;
 		err = dell_dock_mixer_init(mixer);
 		break;
+	case USB_ID(0x0bda, 0x402e): /* Dell WD19 dock */
+		err = dell_dock_mixer_create(mixer);
+		break;
 
 	case USB_ID(0x2a39, 0x3fd2): /* RME ADI-2 Pro */
 	case USB_ID(0x2a39, 0x3fd3): /* RME ADI-2 DAC */


