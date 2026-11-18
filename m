Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059836;
	b=iM3OuDFsoeSNlgeYDoulw2/xtjki5FM6vRCGkxCvDxfHgLhLCVY2PWtaHVO1sC3d63NP
	 fGQBkyYrLJgTBcjfVgsV65voLumgyxcyakCHNaI4gaLX3e6GzuIf7v+B+w2D/NCxe2Pu2
	 +38JyXqkjWnQFzy+sKaDtOa7wNmgaXyySal3NPcwxEOLxTRdLHk9lD1RkBbw4I/QS1jPh
	 jBnDWsIBFo5Hp4qfs3ZRMPI72i+bbRbNYpt75SLkNrLsHzVfnB/VV89/58usd/4M/MJ8B
	 Q+VjWmookeTXugsIh8YoYR/A11cavPaCUIzXgNuxx24miK080OCOP/7eUjfFvc4ya+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059836;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GQCSN5BPs9o64HCEdpmxlhGCHX3o244W7NLHxDnk83E=;
	b=g7j41BBbkmj0GHvFHsW9ytJhYWzuFXcJ9qVKwfOpkh3Ywk3serkVh0HDw2HH4+jOW6p5
	 VildnkftqzzF75pqCGb5Cowmn7euBMIv/pbb4QPP+6oBGZSfoXety8yl3RzaM4yNR/5tX
	 8/IJ+7dGL+ZJG8vCynvdsddvHfp4hRDx9L8gJE94WYhgtuo2ocw1o+RPoct+NDsxyqGm0
	 pDX1RSjTKxzxe1tfv5wi4SpDjR+HNinkYei4oD3Ldcw8GzhkhcyG/6w18sVJtSup/uk6w
	 r+q18fNutkdlEIUd3p/c4vAn2Mvwbk+Izntv4SILQH8Cgs/5SE4gBpj5V6Kro2+DLbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T1K0BTGx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A69606A325;
	Thu, 19 Nov 2026 03:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T1K0BTGx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762B31F000C4;
	Thu, 19 Nov 2026 03:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059836;
	bh=GQCSN5BPs9o64HCEdpmxlhGCHX3o244W7NLHxDnk83E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T1K0BTGx3Q3ROkw7uogcQW405NL2NOeBBp1i3uhi3FIOVqGYrYSCIesM4hWQQkEvv
	 OBhN+gJtKdIsTbNWlPEfyOflGr5E8AnSMzcLKCl/I5hBgTvOow+j8U6TbP1zFU715K
	 +AtyK8+4pDjI3qhPLx8ewSCPsHGC3CRITrtorZec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Kaloudoff <olivier.kaloudoff@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0985/1848] ALSA: usb-audio: Add mic resolution quirk for Logitech Webcam C200
Date: Wed, 18 Nov 2026 15:50:23 +0100
Message-ID: <20261118145958.136443304@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced the quirk flag table entry with a USB_ID case in volume_control_quirks(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 7f64199139d31..48178272bf422 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1163,6 +1163,7 @@ static void volume_control_quirks(struct usb_mixer_elem_info *cval,
 		}
 		break;
 
+	case USB_ID(0x046d, 0x0802): /* Logitech Webcam C200 */
 	case USB_ID(0x046d, 0x0807): /* Logitech Webcam C500 */
 	case USB_ID(0x046d, 0x0808):
 	case USB_ID(0x046d, 0x0809):
-- 
2.53.0



