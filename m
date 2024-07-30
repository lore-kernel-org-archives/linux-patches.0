Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D37A1A76A1;
	Tue, 30 Jul 2024 17:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360315; cv=none; b=BnPcJ/jqYCzQuQRhp1AHeJOEjpJlJPbbf7E4Z5sf4UnOKiUD2QCFka9M2QX6/b3Tv9/vSnREvyqs5L3OAMybVeR4wpVdAiJgKWx+J+YwenKAlteJ1hTVO5qQ0DkjGYxGbyCVmTzEqn4tYR2Yf3Mc7bazdsjX7EcG5IfaXxJcIGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360315; c=relaxed/simple;
	bh=c/5BlpkKVM2WQ28IABw+bi2dOkCqYF5G9bAZM9EDfjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qk4o414Qc2kUettRgLy38M0DtnFJrWadztjcrYo1Hu/dj7CczHbLyYlYq3StM4GNtUJyQNY7xV9dJ8w2QW9SumBBXfSS4CBICz9Jq5m5s1kSQn+IDTCSpG/6vGe1W+8m4/1PPR/4ZNo4ds8KjoTNCRzSTNHVIAkvTMr6RV41LC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CD4NHPML; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CD4NHPML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E365AC32782;
	Tue, 30 Jul 2024 17:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360315;
	bh=c/5BlpkKVM2WQ28IABw+bi2dOkCqYF5G9bAZM9EDfjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CD4NHPMLhNOGEimMoKZlNZViYHCyLKGX/PWK3bAI3FEgr+sB5XBq7hNAMURLqr1eH
	 PubldixxA1Cf9tGrjHHzUDS/D9ibqZWOtIqv15KorRfFlpjCVjFZrQcdMSymcDFTkU
	 nK9bOqDJj59SQgwKj3wOEoHv+IdlvuU4cjFU7O/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 630/809] ALSA: usb-audio: Move HD Webcam quirk to the right place
Date: Tue, 30 Jul 2024 17:48:26 +0200
Message-ID: <20240730151749.725273594@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 7010d9464f7ca3ee2d75095ea2e642a9009a41ff upstream.

The quirk_flags_table[] is sorted in the USB ID order, while the last
fix was put at a wrong position.  Adjust the entry at the right
position.

Fixes: 74dba2408818 ("ALSA: usb-audio: Fix microphone sound on HD webcam.")
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240722080605.23481-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2167,6 +2167,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x19f7, 0x0035, /* RODE NT-USB+ */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
+	DEVICE_FLG(0x1bcf, 0x2281, /* HD Webcam */
+		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x1bcf, 0x2283, /* NexiGo N930AF FHD Webcam */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x2040, 0x7200, /* Hauppauge HVR-950Q */
@@ -2225,8 +2227,6 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_ALIGN_TRANSFER),
 	DEVICE_FLG(0x534d, 0x2109, /* MacroSilicon MS2109 */
 		   QUIRK_FLAG_ALIGN_TRANSFER),
-	DEVICE_FLG(0x1bcf, 0x2281, /* HD Webcam */
-		   QUIRK_FLAG_GET_SAMPLE_RATE),
 
 	/* Vendor matches */
 	VENDOR_FLG(0x045e, /* MS Lifecam */


