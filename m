Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051171;
	b=rT8QD3lOaptObtGG1wThsFmQmWzc2bJjDeEjs5vMzm0J27+AXZQ49gtZDfEYsaekLeQY
	 WBNV93qPfYAB62rZjHsjnXo+WntZce9dhKaQxoGHe0Rc2HNbLDNtcfNxrxchFSezj+UxZ
	 CBXgbC0byhOSfDg9KthqQ08XDNSVzSoo2DM3XfkMN7MyA1yvunHBVa09rBqt/Nr4av7nL
	 W8EzsKU4AqGhd4Dp4A/XTdo8zcjWgjFgrxjnUDManvsFVL7E1cdYsKy3vOZ6EhqWPuxXK
	 acakOFKj6WaMTpVd7u9ee8pBBIdE2FAJjfxhx/89vZzQRCUkU6pRTuvOxx64o3RPiRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051171;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=eAPGbM4cSeG0CWgwpD5MRnD9ACAdY7ihGQ6aJfvoDPw=;
	b=1UTuzl7AjkUwCVKHZ/8lk0m1b0g9KtEH7LQnYC5xJA6utn3VY70EcdgJcXWCdkTK1TTH
	 aWAhzKpfy6eC+r+9MxN1+Idn3ESMa6CsRFEtgNyzhtgkMvqDRQo7PdrgDhAKZQAkViXut
	 YFnTzHWiarwfoHF7juXV8wNeeAobqCcw+1yGGaisKS+mbD6lDGtoR0vz84rKWwBHDurER
	 nIezEMbZ0jN2xgTXwtdIA77U85Ivw6wpGv0ypT5AR23lnTQWVGLCkjcAthURXQkmcNDCT
	 zR4QQazpPO4PSM+gT+JzfBV1aeDe/Ze6ZpYnkKzOzE7jVNPAbMMjaESKPnbah8vHfxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xsWIdkG8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E44A606A330;
	Thu, 19 Nov 2026 01:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xsWIdkG8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D078A1F000C5;
	Thu, 19 Nov 2026 01:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051171;
	bh=eAPGbM4cSeG0CWgwpD5MRnD9ACAdY7ihGQ6aJfvoDPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xsWIdkG8kH8hu5ucCzDEr7xDrr4YF+XfWqHF9Rm2hpuCFdWJAxrthKOHuG46nzRjy
	 uRawWsVsacRAr6D48TbQRXaC+pnaN29da40pdPZ2RqBm1dEvoFY730OkRA+avIyite
	 wTp4gK2EkTBq8rw6mSKi9/yBj+GL8wVZ0QBtBczo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nizar Al-Kabbani <nizar.m.kabbani@gmail.com>,
	Denis Benato <denis.benato@linux.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0113/2214] platform/x86: asus-nb-wmi: map ProArt key (0x8b) to KEY_PROG3
Date: Wed, 18 Nov 2026 15:29:49 +0100
Message-ID: <20261118150014.431996747@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nizar Al-Kabbani <nizar.m.kabbani@gmail.com>

[ Upstream commit 6303451189a6d8f304221065c44ccd597e0acbe5 ]

The dedicated "ProArt" key on the ASUS ProArt PX13 (HN7306) emits ASUS
WMI event code 0x8b. This code is absent from the asus-nb-wmi sparse
keymap, so pressing the key only produces a "Unknown key code 0x8b"
message and does nothing in userspace.

On this model the key is exposed solely through the WMI interface and has
no HID scancode, so it can only be handled inside asus-nb-wmi. Map 0x8b
to KEY_PROG3 so the key emits a bindable event, consistent with the
existing KEY_PROG3 mapping used for the ASUS programmable/Armoury key.

Signed-off-by: Nizar Al-Kabbani <nizar.m.kabbani@gmail.com>
Reviewed-by: Denis Benato <denis.benato@linux.dev>
Link: https://patch.msgid.link/20260719090843.66777-1-nizar.m.kabbani@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 224c1f1c271bc..e843546f33851 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -551,6 +551,7 @@ static const struct key_entry asus_nb_wmi_keymap[] = {
 	{ KE_KEY, 0x82, { KEY_CAMERA } },
 	{ KE_KEY, 0x88, { KEY_RFKILL  } }, /* Radio Toggle Key */
 	{ KE_KEY, 0x8A, { KEY_PROG1 } }, /* Color enhancement mode */
+	{ KE_KEY, 0x8B, { KEY_PROG3 } }, /* ProArt key (PX13/HN7306) */
 	{ KE_KEY, 0x8C, { KEY_SWITCHVIDEOMODE } }, /* SDSP DVI only */
 	{ KE_KEY, 0x8D, { KEY_SWITCHVIDEOMODE } }, /* SDSP LCD + DVI */
 	{ KE_KEY, 0x8E, { KEY_SWITCHVIDEOMODE } }, /* SDSP CRT + DVI */
-- 
2.53.0



