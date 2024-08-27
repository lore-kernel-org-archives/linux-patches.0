Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCF11A08A3;
	Tue, 27 Aug 2024 15:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770861; cv=none; b=uwRf5MBZs5h3X0Y/YXlk2ujUROGmmnaD8wLd0928p6SCwUIndUE4nDeWLdSjP/2k1qRnM3N3yrkHd6G2sbDJenWWOQ4HtoI3NtTK3d9x3aJkWW2Fd1ILcMaajVCgiHiuhigT+wEhl8JAGgGXR3ZdiaZZOz/qsbWJhn8x6QavyyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770861; c=relaxed/simple;
	bh=kL5qmHEXTqgiUk1SdPjnQNkRhBgp8nKKb3xO3DIcDNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B+bwTrxE0qoqLc9V/dgNDtor9gUzqwAzHGmr8DmqUTNjzSoHPWLqHB99A+3fYojTSRQwRP0DNxNFksxF/jo1b/hXUANGsfC4RaIs9qpNB3fVMiVAgZt0sy6xi5QWkd3mWmcelpDjjZKcBzqbEoQsKetNOgMidMVKQm8pKiRWMH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QKuaon5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QKuaon5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445CFC4AF1C;
	Tue, 27 Aug 2024 15:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770860;
	bh=kL5qmHEXTqgiUk1SdPjnQNkRhBgp8nKKb3xO3DIcDNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QKuaon5JTpicM7Wy4icPXzJ81vSpPDCLmV5/DDDz9xbs2JS0JrqVC7ReV5yiPGjCD
	 kY/2ORTvxHpCUPsqFV9PZpQQcCkwUlq7B3DpkPzFLL30xv85C3/jqNuNT8aDb/8Pr/
	 PNEEdN70TerKSi5puZkCHcrH4QS6KogGTfP+kwR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Juan=20Jos=C3=A9=20Arboleda?= <soyjuanarbol@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 015/273] ALSA: usb-audio: Support Yamaha P-125 quirk entry
Date: Tue, 27 Aug 2024 16:35:39 +0200
Message-ID: <20240827143833.967000889@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juan José Arboleda <soyjuanarbol@gmail.com>

commit c286f204ce6ba7b48e3dcba53eda7df8eaa64dd9 upstream.

This patch adds a USB quirk for the Yamaha P-125 digital piano.

Signed-off-by: Juan José Arboleda <soyjuanarbol@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240813161053.70256-1-soyjuanarbol@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks-table.h |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -273,6 +273,7 @@ YAMAHA_DEVICE(0x105a, NULL),
 YAMAHA_DEVICE(0x105b, NULL),
 YAMAHA_DEVICE(0x105c, NULL),
 YAMAHA_DEVICE(0x105d, NULL),
+YAMAHA_DEVICE(0x1718, "P-125"),
 {
 	USB_DEVICE(0x0499, 0x1503),
 	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {


