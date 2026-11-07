Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064580;
	b=tSX7Yrk2VzNsnyOQ432hlRZhivAQM6I6Hesh643UYOJ2qQ6JU6jL3FQpTFOz/srWCeQo
	 Lbe7jRVJDfXOcyzkQE2MwyhT9E3gWUj9+nNMv5XgndAZwiHrZdtFBZHyXuXfsBNiVZf6O
	 r8NXhLtbm8Rh8fIGHoNplOQqDrRqoOTGqzOQqq07Nv12GFMVm4KUBVbmTGR1JN5rNg6BE
	 Tmt0qz4MBiK5952r5ms0jUDWizf81rMRi5QtI+C27k+S5a2KdE22ZnGQOGx9pyG7haXuW
	 088dOnb5cFG4vXfI1w1pVTM3tB4FW0OHVFrWY2ByFTycrIKQm/HTgHmbZDnzJ32S/ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064580;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YbUk4QQzOzpCclUdpLQ7Mou9wrVHt80ko4gDkFpJ4T8=;
	b=VvUO9ihyAoeLiRfQnqZWgeseHivC9a7t5j4O0TNHH38xIGMLnAtZ8K+MVzlWVEw+OU4x
	 nhQrUoBysnmDsmynUXPluuv2ApiJJxwAo3+X2gE1z7UGXgJPLoQePRNA41VHSzaX7KyoH
	 F61/kNx7lBx8JV3I7IUG51xlYfoFEQMSnQpfi1gvPlmcqtUL0pPG8pr29A9v4teLWxKEq
	 EXBw424x9PrY+HdmE+bf7SBNlUE+gKyKO2YAX+RMOBUtcec6M5GJDC7D0Gay4ooXDUKf6
	 Ug8HRlilX56NAiiAqq1LA5OEJazxW0pH2qJpIPJAMckCLdGTIozlWdHlY83dIJ9c5xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qawWv2jV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A004606D809;
	Sat,  7 Nov 2026 15:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qawWv2jV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE161F0089F;
	Sat,  7 Nov 2026 15:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064580;
	bh=YbUk4QQzOzpCclUdpLQ7Mou9wrVHt80ko4gDkFpJ4T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qawWv2jVm0Gg2dxzXoN7PZj/K3uynjyuKJWq4WqpFhe8vAsD6aLRR7a/yNWty+syM
	 +ni+Zh62+mH11E2G59MibFCusDGxJC6sMExtcaLrF3rBFA+ZUqgq6LVWGd00JWfQB2
	 e3P4U9Oj58nHQ4zvFcfOGQPTjikWjn+afshSDyrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Kaloudoff <olivier.kaloudoff@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0599/1257] ALSA: usb-audio: Add mic resolution quirk for Logitech Webcam C200
Date: Sat,  7 Nov 2026 08:48:15 -0500
Message-ID: <20261107134955.865822527@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Kaloudoff <olivier.kaloudoff@gmail.com>

[ Upstream commit 874323b68c93c6808e034dc0113681e822e6fb42 ]

The C200 (046d:0802) reports a mic capture volume range of
1536..7680 with a resolution of 1 (6144 steps), triggering
"Warning! Unlikely big volume step count (=6144), linear volume or
wrong cval->res?" at probe and exposing a uselessly fine-grained
mixer control.  This is the same firmware behavior as the other
UVC-era Logitech webcams already carrying QUIRK_FLAG_MIC_RES_384
(C500, C600, C210, C270, C310, C510, C525, ...), so apply the same
quirk: CTL_MSG_DELAY_1M (which the Logitech VENDOR_FLG would provide
if the device-specific entry did not short-circuit the lookup) plus
MIC_RES_384.

Verified on real hardware: with the quirk the warning disappears and
the driver logs "set resolution quirk: cval->res = 384".

Signed-off-by: Olivier Kaloudoff <olivier.kaloudoff@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261008230844.11246-1-olivier.kaloudoff@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index a54fabce7920d..b9e89e94e95f5 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2251,6 +2251,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_DISABLE_AUTOSUSPEND),
 	DEVICE_FLG(0x045e, 0x070f, /* MS LifeChat LX-3000 Headset */
 		   QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
+	DEVICE_FLG(0x046d, 0x0802, /* Logitech Webcam C200 */
+		   QUIRK_FLAG_CTL_MSG_DELAY_1M | QUIRK_FLAG_MIC_RES_384),
 	DEVICE_FLG(0x046d, 0x0807, /* Logitech Webcam C500 */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M | QUIRK_FLAG_MIC_RES_384),
 	DEVICE_FLG(0x046d, 0x0808, /* Logitech Webcam C600 */
-- 
2.53.0



