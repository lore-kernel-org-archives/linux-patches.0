Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBA42EFD99;
	Thu,  3 Jul 2025 15:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555528; cv=none; b=f6JuRSbwgnC6nvx7hWUz4ufw9C0mCUdsFyU6l/ql7MCe2gsP+RK/8+bNOX6jzEnOFM7YRdt2gTfP6SUMz3zzs+QGN4wFD/+ex6GMQbG05WidjpbYe/PkYZExHVqAKDpUuNSJV66X1Xb4sKEUzoAlvMetii4PkoEq7VT8/tl7gtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555528; c=relaxed/simple;
	bh=OpzJK0psGjJaUZezE4RGRs2ELePCGxNCspSVjFAL//A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BZ1pJaJ1NSODnHyEFn6R6GVMrOvRLXBN4rZW/78Pe84M/eEZQtLW1t9uzRKSZpJ5Z8fE+/ZZKpT5dQ3M49Gu+zSF9GEY6YOirPQXm5vaOk68RKRrob3NflDPzCBwRSxRenSWT16v1h5srIAkI4RjJ/k+BPRqdP8rIN1gMV9P9HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aJCOtqDW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aJCOtqDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3932C4CEE3;
	Thu,  3 Jul 2025 15:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555528;
	bh=OpzJK0psGjJaUZezE4RGRs2ELePCGxNCspSVjFAL//A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aJCOtqDWfxrekA6yIjvoz2Wkh39CC+hoMJuHAmkazTqXsEH8aUzhCGic/OUq9qgoC
	 WCMYvEFxVUjLGWCilAJPpKBJ3SclxzJRf9VPG7kXkt1hJbFr7SyVKy9xu2MOuoc93X
	 XTKOESO4q3OjHrStXG48STmh6I9N1BhjZ+RDRi5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/139] ALSA: usb-audio: Add a quirk for Lenovo Thinkpad Thunderbolt 3 dock
Date: Thu,  3 Jul 2025 16:41:45 +0200
Message-ID: <20250703143942.820809503@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 4919353c7789b8047e06a9b2b943f775a8f72883 ]

The audio controller in the Lenovo Thinkpad Thunderbolt 3 dock doesn't
support reading the sampling rate.

Add a quirk for it.

Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20250527172657.1972565-1-superm1@kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 0b8b20550ab38..f19c808444c97 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2182,6 +2182,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_DISABLE_AUTOSUSPEND),
 	DEVICE_FLG(0x17aa, 0x104d, /* Lenovo ThinkStation P620 Internal Speaker + Front Headset */
 		   QUIRK_FLAG_DISABLE_AUTOSUSPEND),
+	DEVICE_FLG(0x17ef, 0x3083, /* Lenovo TBT3 dock */
+		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x1852, 0x5062, /* Luxman D-08u */
 		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY),
 	DEVICE_FLG(0x1852, 0x5065, /* Luxman DA-06 */
-- 
2.39.5



