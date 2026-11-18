Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021054;
	b=Y1flq1goP4t2iKlsYqz6/zOI2Shta2w4B0XUMd56nOu2ha4KXnXDi5JB6RZHjQPur0LA
	 ZnY/clqT/Vo2IpRhNkwZaOEyX21tjh6I+CNw1hudnABi1g9qD+6W0z2Jk6TwFgSw7zO8F
	 5V2y0r8Ei8zWf3yQ8h+ZlYM4ZcmqX8+7Y1Uvyk7dfCfpLXHAWYraqBYPCTnYfG/LQxFvZ
	 Rde+sK7VYekypohiawQevSU6pohNwgrGz9h4GsKg733kJ+zrCk8dnxdG8KIfXpExaDWKl
	 o3TdePQw4VRT8gR8yS5RucltDppn63reAN+kHX1k/25084Qq+M/mvRgUDI1gau0yx6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021054;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qdIDOQnKRQeg39LLp7d+H7U8KhHoEx4l2KUB1VpwthY=;
	b=TcAthJGzosqfy5FXIG27VOZKAzns5nOrRAj97Km4K8GCtNCfljr8HgoyKvfRXVFCrNE/
	 6Dc5XdCmMRVFZatCF9jOmAW4oQJfR180mToEO24nWD1wPn8NIqNw+5HyHvKpUg08xwOME
	 BsZOwzkP1HM5yWyfnlgwgLgPoEmyxU+CYfM35T7ikiuHq0C9zYCAPkUrk3R0iC5kRviTx
	 3ehg9zLuDYo5vILc/+hEZfabzyzajCnGUHrrDHHONRNzaDDPMpAIwxqfYbNOXxcJ+ZdTA
	 qCzCnkz4t+KyBVVzzFH07FIzLxOHkJsJyS/UsaUrbit6FMuTpZ/Y1nVe33yeUBDiolQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rBQhRyLU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51F5606A325;
	Wed, 18 Nov 2026 16:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rBQhRyLU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B3C1F000C4;
	Wed, 18 Nov 2026 16:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021054;
	bh=qdIDOQnKRQeg39LLp7d+H7U8KhHoEx4l2KUB1VpwthY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rBQhRyLUbxNAuw2zaYjeOJMNeCuNuUtijlteeo7/WTyrDwjjH/AEMnI/4b/aMstEE
	 4SvoOjNZS6Saqgv57oDANkWhoaD6cT/RAEH8MuZuMbnZlzGhjsTwkgNVOrtE1li4hA
	 9eVFQpzzR1KXqBTW+epb0pydlgxP5Q6R4Ea7cnaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Bush <will@willbush.dev>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2170/2651] ALSA: usb-audio: Avoid applying boot quirk for Behringer UMC204HD
Date: Wed, 18 Nov 2026 15:56:50 +0100
Message-ID: <20261118150403.933634673@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit e88f4749c02fba11c62e880c29d35d254b7e69d0 ]

There have been reports about a regression with the recent boot quirk
for Behringer devices; it broke UMC204HD models(1397:0508 and
1397:0509).  The quirk was to just run usb_get_descriptor(), so I
expected it rather harmful, but in this case, it doesn't look so,
resulting in an error like 'failed to read device descriptor: -110'
that leads to a fatal probe error.

As a quick workaround, skip the quirk for those UMC204HD models.

Fixes: b5c4823cf3e4 ("ALSA: usb-audio: Apply boot quirk for Behringer models generically")
Reported-by: Will Bush <will@willbush.dev>
Closes: https://lore.kernel.org/45162613-2802-401c-84c9-742f9c8c68e6@app.fastmail.com
Closes: https://bugzilla.suse.com/show_bug.cgi?id=1285896
Link: https://patch.msgid.link/20261019102347.2425406-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index b96cb3421cc15..c11ea08fbf6ac 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1705,8 +1705,15 @@ int snd_usb_apply_boot_quirk_once(struct usb_device *dev,
 	}
 
 	/* Behringer devices may need explicit device descriptor read at boot */
-	if (USB_ID_VENDOR(id) == 0x1397)
+	if (USB_ID_VENDOR(id) == 0x1397) {
+		/* the quirk seems breaking on some Behringer devices */
+		switch (id) {
+		case USB_ID(0x1397, 0x0508): /* UMC204HD */
+		case USB_ID(0x1397, 0x0509): /* UMC204HD */
+			return 0;
+		}
 		return snd_usb_cm1a_boot_quirk(dev);
+	}
 
 	return 0;
 }
-- 
2.53.0



