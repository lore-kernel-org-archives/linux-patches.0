Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D062A1494AC;
	Tue, 27 Aug 2024 14:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769704; cv=none; b=DbP3qZb7+MY3eLHjX5Isb334f1/rtQl3A86+XK+inf8zRrg5CgiQIXtg5uS+LxsyrO8xtHuksUW3hr1BuDykJDaEWOrgVcAXLdzyGOXQOXqp/FdtpeI6rXaWepqxnJ4IPLWDaCVIfj2p3McPIJPBPX3M7nQapFE1EJpX+cbkq0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769704; c=relaxed/simple;
	bh=3oZLKrIH0eDzkdsV8+VgKcSsv6ns8xrY6NsTDm9Grgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BOfYpHsCqcEyUdzCWT+m2bqqaZrPr8eWDHMUS78oMs3QUQFRxCahJMKtURhSt0RNUIgqLtJLCBm/07hGysdzv2sDhdP8bWfK3242u59/eLvanSoTSLmUiZ6onXblGzn5ot4rlNuCCoMRBXwS5e7BBusIAZZY4c7PGRF8+Ky2oXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Sl44p/7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Sl44p/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA718C4AF15;
	Tue, 27 Aug 2024 14:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769704;
	bh=3oZLKrIH0eDzkdsV8+VgKcSsv6ns8xrY6NsTDm9Grgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Sl44p/7qtuKxyyLuWlD+Yak6SvqgXofk/4gtj1uMwt4NvRjtfgBOMcu2hcuD5jlS
	 9HSkgQkDDNx1Bm0+P+ViW6+xBNxhMX1xzfv1Setn1YKMyGmjuW4CAtznZ+VHp09GkR
	 x343ZKUioXNwgza7ROqmtVzo6E1eujqDoBFQaRqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Juan=20Jos=C3=A9=20Arboleda?= <soyjuanarbol@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 012/341] ALSA: usb-audio: Support Yamaha P-125 quirk entry
Date: Tue, 27 Aug 2024 16:34:03 +0200
Message-ID: <20240827143843.872328996@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


