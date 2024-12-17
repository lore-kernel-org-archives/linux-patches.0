Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD13B1F8906;
	Tue, 17 Dec 2024 17:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455575; cv=none; b=N47GLpq8MEMKIow+UKOkWjL5mZl734zTZv0CAQ8v3o7eVJ9Ov/ZCUpBN7YIThZngfJuV6REyo0TX0UwijjfGp92bC2M1iupDO9GMdg+dh/zCgndWuS6uyof9N9lNTEqsvW2Y0Nlfa7qiAx8u+PHK5BFLimKI6TvLhElzhqT2lLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455575; c=relaxed/simple;
	bh=KVClIpPJqMJS6pKl646sdHvwBnPmP/yTF5NYt2mXL1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RPasSu2cZa6gSnvNPcZpNytT5W7tuG3MPfv4Ozv34ec6ViIaKUN0NNpDPajv+HS59qmlFXCnJ2y/E1C3XEmkTRmleEz4p2pZ0pmH35/V8G95tcuc/KCg3pHRoyw+oCQg3YxKD7lq3lZxbSp90vcwqi/bihVOT67k9Mr2BaDWnhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YgZJbVlb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YgZJbVlb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F54BC4CEDD;
	Tue, 17 Dec 2024 17:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455575;
	bh=KVClIpPJqMJS6pKl646sdHvwBnPmP/yTF5NYt2mXL1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YgZJbVlbrh3B4oSwwojWvhBBUVmebdBwmJJJaDygOOzXRMUxEtuI+1BMCFM4cJg9R
	 eCPnEXR5pFPdKYfxb9oozY4xPuPkTkEF2Sg6ZjQn/sx/BbELx3kioCQzAoSx86PFdP
	 5VDnbLvdwtoZ6PlaReG1KHO1fueGR/auiUTW+jx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaakko Salo <jaakkos@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 02/51] ALSA: usb-audio: Add implicit feedback quirk for Yamaha THR5
Date: Tue, 17 Dec 2024 18:06:55 +0100
Message-ID: <20241217170520.407162057@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.301972474@linuxfoundation.org>
References: <20241217170520.301972474@linuxfoundation.org>
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

From: Jaakko Salo <jaakkos@gmail.com>

commit 82fdcf9b518b205da040046fbe7747fb3fd18657 upstream.

Use implicit feedback from the capture endpoint to fix popping
sounds during playback.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=219567
Signed-off-by: Jaakko Salo <jaakkos@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241206164448.8136-1-jaakkos@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1768,6 +1768,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M | QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x046d, 0x09a4, /* Logitech QuickCam E 3500 */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M | QUIRK_FLAG_IGNORE_CTL_ERROR),
+	DEVICE_FLG(0x0499, 0x1506, /* Yamaha THR5 */
+		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x0499, 0x1509, /* Steinberg UR22 */
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x0499, 0x3108, /* Yamaha YIT-W12TX */


