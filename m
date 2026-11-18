Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054170;
	b=Ntue1yUggKu29u5eADmdMQTgNmWO+KojBB86UGRZNeQUzAXSbEKTlg9BqG+oyB1zq0tk
	 9O/juTzmIlPBiKFcfPX6D4wyVIzBD3DuL5INLHCbOZhBG4h7s2oQ5GcnPxbEShwK5XIG/
	 AgiBQ3PcqHhuoH3RsI5KotFUS65m2W/zs36UfKSapGzx1aK2/fvmnwDBF9jbEpzj/GCQz
	 ypyscJYYpZOCQB2jn5ZRpxyiI1GllJt47xf4/sVrT4KNdXbpdmQjbLT8PFI0Yo/7gvCv2
	 22UuQuxTGIfBCuyPnJRV+ZjzL5ycTTZ71KPHAhyZ+W6/tWcP59O6AHCguYAcAQCgD/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054170;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rD+6A+tFbfa5pHivJKq0QVdQ2HcgNxGsPxO073czMek=;
	b=iPmo23hg6T/1wVM6mN6RSOQex7868Us3M1qU94p0jviW733wyG0x7/29I7HkiQlAnpBo
	 lYu1DPz9GVasi0rBC/WLsaYcOhfHVmpbiEL59u1biOAnkG5q34nsoU4Qjdr0VrUiWFD4k
	 1LGzK1dMPt5kHLteEzaUD9/Y/S6TBvkMXhqZTuhGXQABC+fo4SFEMQLGL1nsZOyCiTCIh
	 Q7BzoU/XKF07jedz/Fagv+pA7OSTUiur+el8pUQoygcGYvi38Nb9vJ9sFIIhPpG4Ynfof
	 fyMsZL9jwCQJr05dwUEHzr82qu+Zd0r3EFYfPV71NyqhVzKgSRMSNZ5THzNEBIZprXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vjJicydc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F11606A320;
	Thu, 19 Nov 2026 02:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vjJicydc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38BA01F000C5;
	Thu, 19 Nov 2026 02:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054169;
	bh=rD+6A+tFbfa5pHivJKq0QVdQ2HcgNxGsPxO073czMek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vjJicydcWzxIOG24EyAOcxb6hfgdFDU0FjFs/OmBldydxjLWqDTNKScydpoGdNY40
	 0UlhOpkwfy8j8tMUb+FbmM/OOsUQoNUSGJQJkxZ2c9ie38uQApFoHTEZxGNMPh5Zs1
	 WeffmrGzvS0uvNwLqqUTVKVvi6MHAAdwdISGr52c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Kaloudoff <olivier.kaloudoff@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1179/2214] ALSA: usb-audio: Add mic resolution quirk for Logitech Webcam C200
Date: Wed, 18 Nov 2026 15:47:35 +0100
Message-ID: <20261118150059.116337472@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced the flag-based device entry with a USB_ID case in volume_control_quirks(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index fa2c740249e33..fdd3efd297c2b 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1169,6 +1169,7 @@ static void volume_control_quirks(struct usb_mixer_elem_info *cval,
 		}
 		break;
 
+	case USB_ID(0x046d, 0x0802): /* Logitech Webcam C200 */
 	case USB_ID(0x046d, 0x0807): /* Logitech Webcam C500 */
 	case USB_ID(0x046d, 0x0808):
 	case USB_ID(0x046d, 0x0809):
-- 
2.53.0



