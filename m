Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279041C291;
	Wed,  3 Jan 2024 17:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bo2YCvmZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9591FC433C8;
	Wed,  3 Jan 2024 17:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301475;
	bh=DUn0Back590IoL1tpLUjR3UAogT0u3AkjqBocftFrKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bo2YCvmZm39Xh8vNV/VniXnA877hbPe+XkGyrKWonk14iuWXeICEdSvZCW9H/40sw
	 Rz0Qsko94Tzvg9a81PGuC0OnaWva7EEFFlZ1H2wSE5+d6PF/Ayt/2yaXdp3ojwdoVQ
	 OJvv1Si6jrtpwiYNwKw3HOst2fxs1WDv3n5YqsvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremie Knuesel <knuesel@gmail.com>,
	Alexander Tsoy <alexander@tsoy.me>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 43/95] ALSA: usb-audio: Increase delay in MOTU M quirk
Date: Wed,  3 Jan 2024 17:54:51 +0100
Message-ID: <20240103164900.583780876@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164853.921194838@linuxfoundation.org>
References: <20240103164853.921194838@linuxfoundation.org>
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

From: Jeremie Knuesel <knuesel@gmail.com>

commit 48d6b91798a6694fdd6edb62799754b9d3fe0792 upstream.

Increase the quirk delay from 2 seconds to 4 seconds. This reflects a
change in the Windows driver in which the delay was increased to about
3.7 seconds. The larger delay fixes an issue where the device fails to
work unless it was powered up early during boot.

Also clarify in the quirk comment that the quirk is only applied to
older devices (USB ID 07fd:0008).

Signed-off-by: Jeremie Knuesel <knuesel@gmail.com>
Suggested-by: Alexander Tsoy <alexander@tsoy.me>
Cc: <stable@vger.kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=211975
Link: https://lore.kernel.org/r/20231217112243.33409-1-knuesel@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1125,7 +1125,7 @@ free_buf:
 
 static int snd_usb_motu_m_series_boot_quirk(struct usb_device *dev)
 {
-	msleep(2000);
+	msleep(4000);
 
 	return 0;
 }
@@ -1364,7 +1364,7 @@ int snd_usb_apply_boot_quirk_once(struct
 				  unsigned int id)
 {
 	switch (id) {
-	case USB_ID(0x07fd, 0x0008): /* MOTU M Series */
+	case USB_ID(0x07fd, 0x0008): /* MOTU M Series, 1st hardware version */
 		return snd_usb_motu_m_series_boot_quirk(dev);
 	}
 


