Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21435FB86;
	Tue, 13 Feb 2024 17:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845096; cv=none; b=hXw1KcNSnbEBdmKJ9QfWYnL2Hx9PG9DX6o3aqfoeASZkauvt7GWJFk9x491glB6WZICrSVpSCGrVjBwdnnt0UIItraeS4E9yFwKNghx1mLFbtXD3SF9pl+S/U2AAAO/IXxYE5LzWRBensGwuRfcFyGAYgDudJvTxr/pS2IyK3+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845096; c=relaxed/simple;
	bh=fqo85R6LP6aLnBN3Gwaf7l7KnEXDvnsErtsfLUHLeUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfj0y4TzAc7J+2db7us6YYofg3D98R2CEnN8v+K4KIR+Epb7N5b4vSNqo/CXGdJwdKFV8TjpO5EebdE9XBLZ42E+7Y4B0RjLVFTQ1RTc7vdI7SMX9x9ul+vKxSORqJKtStePUqqtuGPFjJOJRs1XzOXQJqUtkLv8rJvvV99j8/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f/v93+jy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f/v93+jy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57CE8C433C7;
	Tue, 13 Feb 2024 17:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845095;
	bh=fqo85R6LP6aLnBN3Gwaf7l7KnEXDvnsErtsfLUHLeUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f/v93+jy7obON2GwWwQOy/8ZQ1eO5Wm+nr3LrJmwmgEoJN12Q4r80VexieLEJozDC
	 qV/BAGdl74yZizFJmn0vEb3JUeria9OZO5Qoa4PlOcgyNFViZE9vBKv29t6nZ4BW19
	 T2fO5TblyNHQb3cuQ4S2NUdbIhPVyx4k+jeBY66Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Tsoy <alexander@tsoy.me>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 45/64] ALSA: usb-audio: Add delay quirk for MOTU M Series 2nd revision
Date: Tue, 13 Feb 2024 18:21:31 +0100
Message-ID: <20240213171846.160580034@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Tsoy <alexander@tsoy.me>

commit d915a6850e27efb383cd4400caadfe47792623df upstream.

Audio control requests that sets sampling frequency sometimes fail on
this card. Adding delay between control messages eliminates that problem.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217601
Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Tsoy <alexander@tsoy.me>
Link: https://lore.kernel.org/r/20240124130239.358298-1-alexander@tsoy.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2071,6 +2071,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x0763, 0x2031, /* M-Audio Fast Track C600 */
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
+	DEVICE_FLG(0x07fd, 0x000b, /* MOTU M Series 2nd hardware revision */
+		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x08bb, 0x2702, /* LineX FM Transmitter */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x0951, 0x16ad, /* Kingston HyperX */


