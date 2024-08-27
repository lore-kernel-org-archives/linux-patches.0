Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415DB1CDA3C;
	Tue, 27 Aug 2024 15:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771837; cv=none; b=RLYzl2C0xkkrYDuXctcNVRv3SRtRDjLhotUyw3QyN/qIJOAap/rTJ7smQC+vUedK6I+nt6+btE5qRx2YI9Ne5QUzKX+R5nMZwoLJLYN+JwO1t66TxsnK543sW5h8IfVXHrNcoIYlzB0r3zjfQuwijKzeTNxclTtPFM9cPpAzFe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771837; c=relaxed/simple;
	bh=JKjFVYbu2jTrpin9JiqI69OQNP7MRRdG1vrYwbP6620=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J/I6yK0Dm9zF7k4yndqoe4mv9ZQHA4iCubdYtvT4qva18JIqT0WHyVrHNl1jIJ7q5REBKCRrvSx3kJ+Qud5g5zRGU9aue2Ek8ggPSqGFB7+YkSyJZcZXLwbFiDuFsbXVlkcuv4fCi4RCuzI3MPqybfR9a5OOWgtXz666nVsjllc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UhOJ3Gdz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UhOJ3Gdz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A31C4E694;
	Tue, 27 Aug 2024 15:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771837;
	bh=JKjFVYbu2jTrpin9JiqI69OQNP7MRRdG1vrYwbP6620=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UhOJ3GdzeQLJ/GTf6U0WSaWnYMMzg8SP+L5jrsGqr3OVro3V1KzoWzcEjplLplQjJ
	 WGCljBQWI8wFdBetvej16nNlwjqG0Qp+KMk5q85lnfA9vrkzLilLeT0BFWu6nQHhtH
	 4hnK827CwNYI8WO65aTnym+8zmhGWNukSmr/cvTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Juan=20Jos=C3=A9=20Arboleda?= <soyjuanarbol@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 007/321] ALSA: usb-audio: Support Yamaha P-125 quirk entry
Date: Tue, 27 Aug 2024 16:35:15 +0200
Message-ID: <20240827143838.478079203@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


