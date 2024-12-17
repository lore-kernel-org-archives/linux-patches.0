Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC091F890A;
	Tue, 17 Dec 2024 17:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456330; cv=none; b=FXJqZUMW+6mAkW/q99xbAGB0WrP8LoQMOKdJRoS689UQoizdq0EEMn5n/v3fv1A/8rJfFOeTjKqsE/M80hunaR6Ll/JFoQbxMmArXfyGebYZutmFeGitfrZL+MArFh1LyTJUIZdeMGk0LL07quBEXGNYmf0IQzvwvmiLGmecr8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456330; c=relaxed/simple;
	bh=4jPoor+D+na11J9DamygzIdmn1Q6GX19sykb9hrhzIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I93o+EfjwHrlgfvCoraOqaqIHqCjlMHC5Hz0iQfuehaEgVUQy+xidU1ueCGtZCef07bjjfvPf/xoRNv1UglwpX5pnLz5mlM1bdnoKz8vSSIpxVCUb0BmhV0NT0sezHbsJhOCLEVXPa5Vx5ELouhoqhPDfD6PM7qqqR00cB1nh2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0q61+wB8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0q61+wB8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02743C4CED3;
	Tue, 17 Dec 2024 17:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456329;
	bh=4jPoor+D+na11J9DamygzIdmn1Q6GX19sykb9hrhzIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0q61+wB8kwvVZ0KDcWQzvQeqsPnsjTgEwpfc9aBe01afT3PYodCOR2RsDebhGSDPF
	 y7E4L3Vq9G6YIVb61IG5Y1lNxs/HJNvNS2f1FYKGGpRLWIFKNu3RkuZpROHkusF6jf
	 1puBwQYR5oDeAm9zD1yDmupbGb4rSBCQdmNIrM/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaakko Salo <jaakkos@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 025/172] ALSA: usb-audio: Add implicit feedback quirk for Yamaha THR5
Date: Tue, 17 Dec 2024 18:06:21 +0100
Message-ID: <20241217170547.304134488@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2179,6 +2179,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M | QUIRK_FLAG_MIC_RES_384),
 	DEVICE_FLG(0x046d, 0x09a4, /* Logitech QuickCam E 3500 */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M | QUIRK_FLAG_IGNORE_CTL_ERROR),
+	DEVICE_FLG(0x0499, 0x1506, /* Yamaha THR5 */
+		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x0499, 0x1509, /* Steinberg UR22 */
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x0499, 0x3108, /* Yamaha YIT-W12TX */


