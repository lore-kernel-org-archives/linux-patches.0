Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043203;
	b=FqUx7QIE8bwfRY/u6k0AHpGtL+Lu6jza9OwHso3Gsq/HTdAC4kiv7D4t1zAN1axVo7xL
	 vR2THmm/ZTF3kahc8yFwjMd9j+0r1uhdL/9L8klaTaKcvSijNzamlTTtoWwPE8Qyb1OaX
	 rLFPU7+G0tRc8nygwtUmwLwomZFiafY0wnwCM4ArDXTIIukgF1xAPRyBfJC/F3Z4qgEKe
	 kS+CR8HgqyBocnc+t5XOLWYvG+IYOlcQWF11sSC3Fl4yKCnQI2Z2VbpBYH+UG5keUOHOt
	 xn92cZMGXw9Ji7On4f1l6NY9Ad6l3piIC2gdLb+2Ep2BkimIYlwZ2SWiJzOoHyHocGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043203;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=XE/UwXq17OJ4974KOQpQNhAvdlgsXTXCeKYwGbtueOs=;
	b=lFVlQuSMoXD9coSwrW+ddApnGEFcpEPsHUD1LXYTZM2gHtu16WwfzbjGnPar4UubnwNy
	 bqA/TInjtLrIOoAPkhVkIkorTCQVTxtc6y5On6LkgRHt6yb0/3U0vaJxtQQJkPYRiwf4U
	 AQ4HwNizOawRjqDxe85SfXDTwUBRZQvxa3jNL21u4Zo5+WpV4hCJZejAoBsdhxPflc8Ju
	 9eqQ/Ndv5jkNf4IX6sqhSwag5j5dBy1V2EEoTQ1o/81NS469ZJpbG0QAMgTtJ2Je/4Wn+
	 byXt3gvWQWMcXpfR5DuLn8Zbkv4mtQTOERlg3PMI/8Nw+rfgW17a/+CKOHknIrQ3CNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HT+ozEW6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466E4606A32C;
	Wed, 18 Nov 2026 23:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HT+ozEW6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966F81F000C4;
	Wed, 18 Nov 2026 23:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043203;
	bh=XE/UwXq17OJ4974KOQpQNhAvdlgsXTXCeKYwGbtueOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HT+ozEW67lhUxfOyrZQPpoPRJu9uUjKa2+cbuTC/z1KxPnTbmUk/BP7KcAed12/LE
	 UBZGq9iV2GoBE9wA67ONysrjtXsKf49k5ckdV5QjdM8twJHRzrGYo45RqfJ23nSmuq
	 WkcUBI5/iVA/OcUE1FsgD1SQA7Vx2284fCosLRf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nizar Al-Kabbani <nizar.m.kabbani@gmail.com>,
	Denis Benato <denis.benato@linux.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0127/2857] platform/x86: asus-nb-wmi: map ProArt key (0x8b) to KEY_PROG3
Date: Wed, 18 Nov 2026 15:19:21 +0100
Message-ID: <20261118150205.923635455@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cba515ce3444d..2fd4ff8ff0f52 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -565,6 +565,7 @@ static const struct key_entry asus_nb_wmi_keymap[] = {
 	{ KE_KEY, 0x86, { KEY_PROG1 } }, /* MyASUS Key */
 	{ KE_KEY, 0x88, { KEY_RFKILL  } }, /* Radio Toggle Key */
 	{ KE_KEY, 0x8A, { KEY_PROG1 } }, /* Color enhancement mode */
+	{ KE_KEY, 0x8B, { KEY_PROG3 } }, /* ProArt key (PX13/HN7306) */
 	{ KE_KEY, 0x8C, { KEY_SWITCHVIDEOMODE } }, /* SDSP DVI only */
 	{ KE_KEY, 0x8D, { KEY_SWITCHVIDEOMODE } }, /* SDSP LCD + DVI */
 	{ KE_KEY, 0x8E, { KEY_SWITCHVIDEOMODE } }, /* SDSP CRT + DVI */
-- 
2.53.0



