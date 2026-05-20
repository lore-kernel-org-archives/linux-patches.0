Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3FD369D67;
	Wed, 20 May 2026 17:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298253; cv=none; b=sVR5anLB1PrwhCRYRGxel6PjY06OGHEqDunkLRbX1yHDkuCz8jjadQC9v2sWS1DrqSNGUIyq1xRW8B665mJnm+YD9G1iTXN1pdCFLYHj+aXfPB5l7Tavm9LZ+9peqaGjkUYpoOSAKXOzW7CkZTYzqujv4K9mIGNefRRr9MF/yiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298253; c=relaxed/simple;
	bh=Smrk8CanUMdpRxutJaWzTUTvkfQuFdpzq8lqw5B5so0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sfVqU7HGtRS1cVl7kSTiOniQdXv+1ukAk8y2orYixsBE5FMAoI42dgJrTdfUE+Ad19Wt9Prctz5z/CLROHrt0QhCzLhda/C+3+gmYPLnX+UYormDfN6o6sVnFjAfGph4GST/LE5OPMRnnNjToFMHNW1DkAE0d3YZXnnQLwD6Wp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TRbuX8B0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TRbuX8B0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8D11F000E9;
	Wed, 20 May 2026 17:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298252;
	bh=oKUn5C4VkEIeTf60FnZS8Xs+UKCMKnsGUn4qBiQkdTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TRbuX8B0gDJ4ZIeEvpgcfZdZWsBLXa8PzhptjnaIE5p6jA67d8WTqoihXyRvjhnpK
	 qUMGOJzbRoV8ochRQ9wpInlCEZCjLaOgZFCmrMcq1OJkBsFDNeDZZNNCGgXwPzss6J
	 8QAPE6v1zSpX5cSqPchPlAtusBlleIC/mapzBEyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 339/957] ALSA: usb-audio: Exclude Scarlett 18i20 1st Gen from SKIP_IFACE_SETUP
Date: Wed, 20 May 2026 18:13:42 +0200
Message-ID: <20260520162141.884141935@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geoffrey D. Bennett <g@b4.vu>

[ Upstream commit a47306a74c31557b1e5cab54642950bbb20294cb ]

Same issue as the other 1st Gen Scarletts: QUIRK_FLAG_SKIP_IFACE_SETUP
causes distorted audio on the Scarlett 18i20 1st Gen (1235:800c).

Fixes: 38c322068a26 ("ALSA: usb-audio: Add QUIRK_FLAG_SKIP_IFACE_SETUP")
Reported-by: tucktuckg00se [https://github.com/geoffreybennett/linux-fcp/issues/54]
Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Link: https://patch.msgid.link/ad0ozNnkcFrcjVQz@m.b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index a2c039a1b3cd6..f21e708675422 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2426,6 +2426,7 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_VALIDATE_RATES),
 	DEVICE_FLG(0x1235, 0x8006, 0), /* Focusrite Scarlett 2i2 1st Gen */
 	DEVICE_FLG(0x1235, 0x800a, 0), /* Focusrite Scarlett 2i4 1st Gen */
+	DEVICE_FLG(0x1235, 0x800c, 0), /* Focusrite Scarlett 18i20 1st Gen */
 	DEVICE_FLG(0x1235, 0x8016, 0), /* Focusrite Scarlett 2i2 1st Gen */
 	DEVICE_FLG(0x1235, 0x801c, 0), /* Focusrite Scarlett Solo 1st Gen */
 	VENDOR_FLG(0x1235, /* Focusrite Novation */
-- 
2.53.0



