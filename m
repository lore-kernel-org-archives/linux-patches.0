Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55235337B81;
	Wed,  8 Apr 2026 18:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674397; cv=none; b=poaWoBlr5TQRRCoTBl6P2sfEJ4+fPyg2wJmHw4dBnZOf/xP9FTmY65DCFTSGctLMFnt3Py2hhDu1DcGi9jMlUOqJB770CwJXNf4XKIpAZEPJ6VJ2y6SfXERTMiE/Gbw6+tKj4YzKc3pcp5k/FaytSt0hrkHQ6NIVZN9XRoFbMyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674397; c=relaxed/simple;
	bh=0IaUfkxg7y12BYEzImPc6J+YD0k+Hnw3JWWIClV9rcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jVwZBt+5JRmi3LnbOXiaESmohZEpDGrcSCld0cF04h8SyjFUz82Ks+20njNTJ5vE4OuOGG/v3LhdDjPph0e4u1fEChuoimrNLAG5NY3Rylbd57QQLOMjC7pQKwTuOD+TtwVsG+VkdrsH45Bp5EJMf4dfnjY+h/h/uC7yubbg3wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UT+Gaymg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UT+Gaymg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F5EC19421;
	Wed,  8 Apr 2026 18:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674397;
	bh=0IaUfkxg7y12BYEzImPc6J+YD0k+Hnw3JWWIClV9rcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UT+Gaymgy8aAw4BJpkLOh+KIbMG52/KG+ibz3Xg/5WGtrRy1OHoEmLBlO3FCNaZL5
	 5fENv+ZQr/rRxH0BG8tWeTXgsRFwTEFTK4bhBqjBmEQaPlFMFVdbMEoUDIfnSU8f3p
	 +/cnvD69tBkPB1AoWlEGPJ7Bc3rfEpEMNzN88zrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 082/311] ALSA: usb-audio: Exclude Scarlett 2i2 1st Gen (8016) from SKIP_IFACE_SETUP
Date: Wed,  8 Apr 2026 20:01:22 +0200
Message-ID: <20260408175942.474181083@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geoffrey D. Bennett <g@b4.vu>

[ Upstream commit a0dafdbd1049a8ea661a1a471be1b840bd8aed13 ]

Same issue as the other 1st Gen Scarletts: QUIRK_FLAG_SKIP_IFACE_SETUP
causes distorted audio on this revision of the Scarlett 2i2 1st Gen
(1235:8016).

Fixes: 38c322068a26 ("ALSA: usb-audio: Add QUIRK_FLAG_SKIP_IFACE_SETUP")
Reported-by: lukas-reineke [https://github.com/geoffreybennett/linux-fcp/issues/54]
Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Link: https://patch.msgid.link/acytr8aEUba4VXmZ@m.b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index f0554f023d3cb..a56fb8ef987ea 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2427,6 +2427,7 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_VALIDATE_RATES),
 	DEVICE_FLG(0x1235, 0x8006, 0), /* Focusrite Scarlett 2i2 1st Gen */
 	DEVICE_FLG(0x1235, 0x800a, 0), /* Focusrite Scarlett 2i4 1st Gen */
+	DEVICE_FLG(0x1235, 0x8016, 0), /* Focusrite Scarlett 2i2 1st Gen */
 	DEVICE_FLG(0x1235, 0x801c, 0), /* Focusrite Scarlett Solo 1st Gen */
 	VENDOR_FLG(0x1235, /* Focusrite Novation */
 		   QUIRK_FLAG_SKIP_IFACE_SETUP),
-- 
2.53.0



