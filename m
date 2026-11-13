Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591636;
	b=xsOp60ENCeFgDyOsnVpEGDVEWsp7ueAr+49ZndLiKrtyF6bD+JOb7vxW2cqxA/T3MMTo
	 gw9kAo5jOsaFUl+RFiTwFQlL0dj1QVCpJ4/JRmzoK0gD8WVxuFz7v5YNOYfYWLoKy1o7j
	 2Vyoho7PUOK7bmEpXvX90rvxBPncLzy35KFjZBOsaIsGPd2oyjL0xZpFl3CJ5/EQ8sW6g
	 mI2LC+HJC4Smf9BsMgkG7l1hiK+TZfk2knsvM6Zj1chgXr0uMOvJBgRRPjtZhqV2XU04B
	 f+vMys4hyOBdlb9z4u4oJSDMvP5VGteytLB7RfEKJZI65kQIkygeQeyLokGZTtUQ8OQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591636;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m78E9RxYjpijJWvkzD3JmIoNCLrVwmDPXks9Du2BIjM=;
	b=Dyff3wZZ7MtleBhpneIpD9vRHIn96bE2ORfxJzXmbOthIXeIvGwWQcfZl9DVQApd9a7p
	 fBV/rfh6bgEZr9hRZ+0s5eDJhl/wG5OaqVCOKokak+SzwSNqJ/0wjeFLrwB0UoNPVlJT6
	 lXgEjBox5UBh9pY1ftNYtbKf2D3rzgLCZ6AIJK0ftanVqAMxt+ecL1q7fQ92TOEyZX5KQ
	 L4DtzFBhbLFbv1bk/1odJnLsd32C15CWnAPk4aRwaR+fGnSwMwIUZCvEUjXZAPGWtTbRG
	 u+aRofnANjKAaPoqOii2pkxfwCidzOtcY7ELp7cerb6W9eFFprvWpCYEGAS4WgFPXEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GFXfDHcc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A99606B45C;
	Fri, 13 Nov 2026 17:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GFXfDHcc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC941F000C6;
	Fri, 13 Nov 2026 17:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591636;
	bh=m78E9RxYjpijJWvkzD3JmIoNCLrVwmDPXks9Du2BIjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GFXfDHccA372r8ZsHcQUnfVp/9Pa9k7LFzKjSr1mQ8v1QzvASnDfrCxtoNipqUGYu
	 IyhpeLg4nnxwGTU3TalXJ8m2x1BKPGlkUrBebpvr29++FVIZsZPVdIGxscS0WorGmy
	 JYJUZFhI/s7NujxaXApaG5USq2Rcx3Zg/8DZTvec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Kaloudoff <olivier.kaloudoff@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 655/670] ALSA: usb-audio: Add mic resolution quirk for Logitech Webcam C200
Date: Fri, 13 Nov 2026 10:53:39 -0500
Message-ID: <20261113153834.110018986@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cfcf9f845ee36..5a69bd87628a9 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2160,6 +2160,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
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



