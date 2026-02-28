Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD72F340A59
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301066; cv=none; b=EGc1/+u5Eo08YRQ6ITX1AVZWKg/I+l9c690l7GAVfwB75+4PVWAVDacKLkcqhfzeLP5Msrd/8drNG5Umitks8HSsNFd5aZF7uNiZ7+YDBJ71494hezNys81lcG2vrSXvpQ/KkYBQtKmsKl2E6cqhxmnTPEFaPivyXGlw+tfM2CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301066; c=relaxed/simple;
	bh=2C3PvQ3oNtjqA1jHbZObfAZmPYi9fmUQxfmXYKyqRNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBs+cs4NJNrdDlecoGlFV5fd36yMwGickYQXBcQzu+LG9yKwgb4iiBO0hZHuf5QW2/a3dZJMymcnkHOQTzSZmRpmIYAB2ku+5jFQTqLQAeEpUw/XVFPbV1ArcB0gTkQs/qQjbRF8ao5X4Um9D8NVDi/ZHL8e9e7gtd9avKQlAls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VUnJ4LA8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VUnJ4LA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B013C19425;
	Sat, 28 Feb 2026 17:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301066;
	bh=2C3PvQ3oNtjqA1jHbZObfAZmPYi9fmUQxfmXYKyqRNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VUnJ4LA8fGaP7N3r7Qbc4JWo6v2dychv9rsq9xyH6b7QNoxg9maO4M6w3Eusq+4JN
	 JDcM7YJ9s0HEROseZBUCH7iSU109QS9ER2ykgQHfm8YLItHy3zSePq3iQWVQJMdclV
	 UvYDh1mZHGba7gBEH5nw5wDJ4M+lx7HVrlcbWDJ7gsNt2tZlk3fZ2ub7w4hhVe0DRE
	 JnzFFTtQNpL7s3yUDASAePLGZV0TUC3MaWyQeyoaecNP4prsfg0NSfNuzHaCYhRp94
	 JtJrPwUru110/ni9B3WDSbIDwjPwXDpZ668dJnIfvTk5RH3DC64GC3YA5rxKE1k5LN
	 B5L2Tr6s60Ifw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Lianqin Hu <hulianqin@vivo.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 210/752] ALSA: usb-audio: Add iface reset and delay quirk for AB13X USB Audio
Date: Sat, 28 Feb 2026 12:38:41 -0500
Message-ID: <20260228174750.1542406-210-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Lianqin Hu <hulianqin@vivo.com>

[ Upstream commit ac656d7d7c70f7c352c7652bc2bb0c1c8c2dde08 ]

Setting up the interface when suspended/resumeing fail on this card.
Adding a reset and delay quirk will eliminate this problem.

usb 1-1: New USB device found, idVendor=001f, idProduct=0b21
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1: Product: AB13X USB Audio
usb 1-1: Manufacturer: Generic
usb 1-1: SerialNumber: 20210926172016

Signed-off-by: Lianqin Hu <hulianqin@vivo.com>
Link: https://patch.msgid.link/TYUPR06MB6217522D0DB6E2C9DF46B56ED265A@TYUPR06MB6217.apcprd06.prod.outlook.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 8a646891ebb44..6860b5bd55f1e 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2147,6 +2147,8 @@ struct usb_audio_quirk_flags_table {
 
 static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 	/* Device matches */
+	DEVICE_FLG(0x001f, 0x0b21, /* AB13X USB Audio */
+		   QUIRK_FLAG_FORCE_IFACE_RESET | QUIRK_FLAG_IFACE_DELAY),
 	DEVICE_FLG(0x03f0, 0x654a, /* HP 320 FHD Webcam */
 		   QUIRK_FLAG_GET_SAMPLE_RATE | QUIRK_FLAG_MIC_RES_16),
 	DEVICE_FLG(0x041e, 0x3000, /* Creative SB Extigy */
-- 
2.51.0

