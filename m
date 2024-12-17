Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6226814A4E7;
	Tue, 17 Dec 2024 17:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456025; cv=none; b=NB+AgOpS12JCHKvXU2c2c6S//nEXUqJpgFdneqoRrvCn7Gs0Kw5PjPMB2jFzJtogvhr2qWg5NS/aJODSqxETanH+8OhRG4G2Azd0wDpzoaGW+DO3NSRzQSKNgZt+GR0bPevtsqZsAiKLvGKs4fAoe7CdeFnuhf34KbzB8i5g+f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456025; c=relaxed/simple;
	bh=QDWlfXNB7+9uC6bGGutk4vJ8F34B7aG/Sg27rAID8/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ejZKlNiEjf4A+VFicURUIGdLPIfrO1w0FK1GthoUJ4P9P7nvNep1j7LSL7ismOUfBN1BjXqusinRH3WfPyU0vDLPEQmUaLLTddpj24gPOKPPe2OKMFT8a678iPIDkeZwFbq+zFJeKMJ9QgJSwQkcuS/LLoZYelTJBVfLBkW0pbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JZ5FxVQO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JZ5FxVQO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A87C4CED3;
	Tue, 17 Dec 2024 17:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456025;
	bh=QDWlfXNB7+9uC6bGGutk4vJ8F34B7aG/Sg27rAID8/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JZ5FxVQOTPiEbQaPWz9Q+0qCSTw4r224uop2tcRPgtXhANqxV2sWIA26CwNDgOQZz
	 AmRjqk78Y/87Ri04+ygbXlYAzwyRhZ3sc4YQUDFZGMMha7oJegrsrhCRc4kY0QNyZ0
	 kDj58mc/sS0/VDq+d5lXd0/iJEfdZw7GGJYlHWl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaakko Salo <jaakkos@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 008/109] ALSA: usb-audio: Add implicit feedback quirk for Yamaha THR5
Date: Tue, 17 Dec 2024 18:06:52 +0100
Message-ID: <20241217170533.702486768@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2067,6 +2067,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M | QUIRK_FLAG_MIC_RES_384),
 	DEVICE_FLG(0x046d, 0x09a4, /* Logitech QuickCam E 3500 */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M | QUIRK_FLAG_IGNORE_CTL_ERROR),
+	DEVICE_FLG(0x0499, 0x1506, /* Yamaha THR5 */
+		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x0499, 0x1509, /* Steinberg UR22 */
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x0499, 0x3108, /* Yamaha YIT-W12TX */


