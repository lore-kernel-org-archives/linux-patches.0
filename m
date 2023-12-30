Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95078801;
	Sat, 30 Dec 2023 12:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JfnYaNsa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70289C433C8;
	Sat, 30 Dec 2023 12:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937872;
	bh=bJvDoy9APKxsqHEaQwtgXjrHOiRxqwMEBdzsSAS3mpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JfnYaNsarhOC8wm0BhzTa1m/zTF3ECsWi3ysL9HvbcQkeDuHUzb8EbmjUaFFWGq/Y
	 bn/m9dlx21A60C4SCxh3yCYg2mRer3aQlKJ9f2TdjHht3H2pT0qTb3G1DCZGFXYqdB
	 YLUUZCaWPMzxkab7Ku0wDR1gjueoag/u6QaCm1rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremie Knuesel <knuesel@gmail.com>,
	Alexander Tsoy <alexander@tsoy.me>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 096/156] ALSA: usb-audio: Increase delay in MOTU M quirk
Date: Sat, 30 Dec 2023 11:59:10 +0000
Message-ID: <20231230115815.495737257@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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
@@ -1387,7 +1387,7 @@ free_buf:
 
 static int snd_usb_motu_m_series_boot_quirk(struct usb_device *dev)
 {
-	msleep(2000);
+	msleep(4000);
 
 	return 0;
 }
@@ -1630,7 +1630,7 @@ int snd_usb_apply_boot_quirk_once(struct
 				  unsigned int id)
 {
 	switch (id) {
-	case USB_ID(0x07fd, 0x0008): /* MOTU M Series */
+	case USB_ID(0x07fd, 0x0008): /* MOTU M Series, 1st hardware version */
 		return snd_usb_motu_m_series_boot_quirk(dev);
 	}
 


