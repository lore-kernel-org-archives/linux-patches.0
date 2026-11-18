Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022389;
	b=wVFhUjfgXGPWjJy8aNVVC+4rz1FFO00Bne+n8Uw02iwPTQCZMJARv0Gov38+6qqLNM1i
	 EH8Pxg7+YD7RW3/ltrlKBq+3hhwjPdlED11K+Ie7g2T86HVEH9BYINqmatWkS01G09iTw
	 vzwCsrtwqCHaAw+frprtccyTgqiQaSvPlzqiYwC9wb+HKcZbjHUAFvao6JyY/lfk8m9Kh
	 auir7MLYBS1Zrrksg/81hzTdaljQ84LQt0wHbDOZrGFH27dpmFQlOL8F+s8OLQLvFAVyH
	 lutCQMmvlUqBH3Tmv2ZgLzFbfNhKg1F4dNND7zHM7Dty2YndKuKNf2xUJ9IlPeC6YZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022389;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZYgkf/LjzeLvMFL0eSnlRrUEq84IJ4hPAfUBAehR4Bc=;
	b=utYyaI8/Zq82ncPUYytBNYreTPofWbkA5SdPyK7j+FCd27pIYXe7cylvWQKtzPhjQEcI
	 gru5kQyytGIoenFr2T4UqtpT8awxljwPDYT8paIXd+xh3C/w0tIVZ+wLvG/PVKXQ2coSl
	 SLoIy5MflfuNVQUoaHM5pV0K4eUBDReGuoBcD9ds93Ksy8P7tNyCtzuqHUrWYUpqp73BS
	 yn7U4fGdreIj0ilQ+piPwFhSpWi/O8aQGOv3t1UqXPmFlTYuUTHI+jiAz9XFnWZMiujwj
	 8OqX9HYYXFOX8JBGU0rtFAYSKaAxHfY/vioSlaSOdBnrzJVLblPySbzFswRUUhA/hNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P6fgGaRH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DEB6606A31C;
	Wed, 18 Nov 2026 17:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P6fgGaRH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466051F000C4;
	Wed, 18 Nov 2026 17:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022388;
	bh=ZYgkf/LjzeLvMFL0eSnlRrUEq84IJ4hPAfUBAehR4Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P6fgGaRH7lE1Jc8rYe0XLqB7nTltXRc2zuzR1W81d6zxDn12f60AvsbtIAQ1znADS
	 t/EXMZPxntfj1TDQ6NymPuHzmCwlHrRlt2xZWZ62pKi/FV+v9qiQOo20uHXl/Tdb/E
	 gQrnMAC+PbIBut79JeFcRwHhbaHpVgftIa1h4Nns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.3 2644/2651] ALSA: usb-audio: Correct a typo in UMC404HD model comment
Date: Wed, 18 Nov 2026 16:04:44 +0100
Message-ID: <20261118150419.276870353@linuxfoundation.org>
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

commit 73e38d178bbd28fe2c30443e6c0cf74e3f584bdb upstream.

The recently added quirk code has a comment for 1397:0509 as if it
were UMC204HD, but it's UMC404HD.  Correct it.

Fixes: e88f4749c02f ("ALSA: usb-audio: Avoid applying boot quirk for Behringer UMC204HD")
Suggested-by: Gergo Koteles <soyer@irl.hu>
Link: https://patch.msgid.link/20261024080011.2258391-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1709,7 +1709,7 @@ int snd_usb_apply_boot_quirk_once(struct
 		/* the quirk seems breaking on some Behringer devices */
 		switch (id) {
 		case USB_ID(0x1397, 0x0508): /* UMC204HD */
-		case USB_ID(0x1397, 0x0509): /* UMC204HD */
+		case USB_ID(0x1397, 0x0509): /* UMC404HD */
 			return 0;
 		}
 		return snd_usb_cm1a_boot_quirk(dev);


