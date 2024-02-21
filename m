Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BC06F074;
	Wed, 21 Feb 2024 13:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522585; cv=none; b=Y+ASBTsjWORl+RgtP4ntVcoA48PkOebxd0cyAlNBBAAiq/VClFE1ZImR89YppGPz8whhU7Hdsoo7mbQwvmBG60QiJ41lOMsqB0yhEKKaqauUmHv5VQdw3FKU86srxN3YmUL70rWYCoICywnBZ/+xZvN+MoqMuux03I8G+y65ru8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522585; c=relaxed/simple;
	bh=O1OuDe6advn7nE6oKRSa532AiD4d2wNDbw2ouvu4TqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/u8K64S1WSGS9I6Kj0+9/BUnvVgJHzdpsJmPikJ27XKeeUGogN2Lu3iqYEWCe6yN58hdThhF5qgn99G4kOLzROE2cSn5Q4MDGX79zDj8EBqA4n9LGBZ0tLqQB/8s5nBQFRUvNISy32nR/V+QldtYyAdA7e3BA5NNYcwN8JN+zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DSeDh3OU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DSeDh3OU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF0AC433F1;
	Wed, 21 Feb 2024 13:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522585;
	bh=O1OuDe6advn7nE6oKRSa532AiD4d2wNDbw2ouvu4TqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DSeDh3OUhYrnXzauyA/FAVaPFCtKd86BI/eJJzSrC2EbiQgu9O5cNW5ClNDQ5/ayj
	 aJD0GSATQF8gJWMH9ntBc2SwO+wrK223sUld4eu6pc9pIk6/UpUMvwJ1Bexbe1Iz7x
	 ofTfS2AXbIN7OgWIOV8cfKx3cA13jZzELUNu+WuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Tsoy <alexander@tsoy.me>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 200/476] ALSA: usb-audio: Add delay quirk for MOTU M Series 2nd revision
Date: Wed, 21 Feb 2024 14:04:11 +0100
Message-ID: <20240221130015.312303475@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1796,6 +1796,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x0763, 0x2031, /* M-Audio Fast Track C600 */
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
+	DEVICE_FLG(0x07fd, 0x000b, /* MOTU M Series 2nd hardware revision */
+		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x08bb, 0x2702, /* LineX FM Transmitter */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x0951, 0x16ad, /* Kingston HyperX */


