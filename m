Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DEC1DF240;
	Mon,  6 Jan 2025 15:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178412; cv=none; b=cruQhjSUjVaWQsU8deckx9itE+ehrtz2QtZGfLB1HljDUxzzta6BB+vUHhxsfimYA9afdX7dQftHRSaeZxJ+tUz3bi+UDeM7Iy9YpGOAcTCYZCX18Q6J7i/iMoIZUGKPRCfgNRe1AqXkfPleMLHfhndJbTzxUrQ7JpYLdBnysVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178412; c=relaxed/simple;
	bh=R01u+wuWLUHiLGn7fZIhxMqPIVbmQrJ9sgzdh36S/w0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KvH3m2jrouB7l4xQX5R8j+VSyDXidvzfgsaRLhKi2NGMGBDZXAxgp8WE8rXLTzy6iZZETDaOmI2Rzx0mzuOFkH1mkuNuYcTdHV1En4jMqZxOyybsb9t7RHSS6edgJYWwBadVaIxdoF9GeqsiUKxd0jziMH0mzSZ1i02wuYT80MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bl0Y5RNw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bl0Y5RNw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE161C4CED2;
	Mon,  6 Jan 2025 15:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178412;
	bh=R01u+wuWLUHiLGn7fZIhxMqPIVbmQrJ9sgzdh36S/w0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bl0Y5RNwWvjWtqu9Gt6UaHCe6LWJ6iScar1zmWRr8aEH8d/eJRBg4WotPLfVM0r1w
	 iMm8D+X+2bKw3IlT+9uEjGAEJLYyD5/+6qZKqr8gMxp63d9SbmxVR71Or3vEA07/e7
	 vPS8xdQO44UdAf/rXTd7ANmyk4KvsInfWOKR5T9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanya Agarwal <tanyaagarwal25699@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/138] ALSA: usb-audio: US16x08: Initialize array before use
Date: Mon,  6 Jan 2025 16:17:13 +0100
Message-ID: <20250106151137.355629624@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tanya Agarwal <tanyaagarwal25699@gmail.com>

[ Upstream commit b06a6187ef983f501e93faa56209169752d3bde3 ]

Initialize meter_urb array before use in mixer_us16x08.c.

CID 1410197: (#1 of 1): Uninitialized scalar variable (UNINIT)
uninit_use_in_call: Using uninitialized value *meter_urb when
calling get_meter_levels_from_urb.

Coverity Link:
https://scan7.scan.coverity.com/#/project-view/52849/11354?selectedIssue=1410197

Fixes: d2bb390a2081 ("ALSA: usb-audio: Tascam US-16x08 DSP mixer quirk")
Signed-off-by: Tanya Agarwal <tanyaagarwal25699@gmail.com>
Link: https://patch.msgid.link/20241229060240.1642-1-tanyaagarwal25699@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_us16x08.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/mixer_us16x08.c b/sound/usb/mixer_us16x08.c
index bd63a9ce6a70..3959bbad0c4f 100644
--- a/sound/usb/mixer_us16x08.c
+++ b/sound/usb/mixer_us16x08.c
@@ -687,7 +687,7 @@ static int snd_us16x08_meter_get(struct snd_kcontrol *kcontrol,
 	struct usb_mixer_elem_info *elem = kcontrol->private_data;
 	struct snd_usb_audio *chip = elem->head.mixer->chip;
 	struct snd_us16x08_meter_store *store = elem->private_data;
-	u8 meter_urb[64];
+	u8 meter_urb[64] = {0};
 
 	switch (kcontrol->private_value) {
 	case 0: {
-- 
2.39.5



