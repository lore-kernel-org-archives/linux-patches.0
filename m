Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80522E613A;
	Tue,  8 Jul 2025 16:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993804; cv=none; b=V0Mn6QshqdcjuTLTJwgGfyGRJJS8CRd0uQpx+lWhRBrG4P3g2qndTNV0k0JsmHnN+N7UZ7SSu6ux+Dcu47IzLR8S4etQMSpSGq2dPk3MKOVGcVveDuFKmK+fmJmBSyCPg9N0TxADLAebhgE/uNDKdiuZ8fHB0sIGPl2tbE0ZOdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993804; c=relaxed/simple;
	bh=k/ZVTmiumx+U16qe+IZpsNiDM1Mc6HGTetf0nznwxcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r2QqYNSG3bg82oD96BB6PaXbvfP9Frr0m2xQSNoDqSx3GYOl57w54LTwCmh6/98JHsOaliWbAnu/fwsRkQF7UwtQtgPBzMgBhq2gS4fJREe0ZwZ4Qpq26wsiXyQQK2Is3Qaeaz7W9HVLNLcJTlDFPgLO6x4jr58fP5qYYj3H2+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oUu92QhG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oUu92QhG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70EF5C4CEF5;
	Tue,  8 Jul 2025 16:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993803;
	bh=k/ZVTmiumx+U16qe+IZpsNiDM1Mc6HGTetf0nznwxcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oUu92QhG9zhDLgeyioNlqbVa6DbzCdE7QTTxBbayNZ5XmKgeMYWXVqZG1IP1xXwin
	 h7VYe45AsK0YX8eYwaJzKasVn0O8f7nYdFw7uS70z/GceRRZrtwC40IAHB0mT90QHV
	 8AIbLB1iUumQXMu5UaoZ9e6BcmL61NJKPw4WATYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/160] ALSA: usb-audio: Add a quirk for Lenovo Thinkpad Thunderbolt 3 dock
Date: Tue,  8 Jul 2025 18:21:01 +0200
Message-ID: <20250708162232.180131613@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 488fcdbb6a2d4..f24a334316a29 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1877,6 +1877,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
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



