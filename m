Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060809;
	b=RMBR9XeemkI+bfWh1y0VSOY41Lt90o6iGqKycGSxANteK/NqLcyUwZJFAYBI16sm6/fD
	 sIZdEH7xESe6HqIXvYq43U3JBdmBFkRqrRM9GicDtnGfexoaOTG3TGTMQisGl9gKbt0Wx
	 VAmnZWwppXXfepXNdJwhAUFUte3bTtMG0OEXyZ/nwGCHOLqO7kPPCdMzcqci3HGFsGxOk
	 hA6FSe/U+g7HgUwuUMwiGdIXdh859y4+sXOO2KMX5qmG/IXp+FqNjfRc5ki0n7oP7oZnb
	 /84tWhMYhjjvKLYDQgewUf7pnmyJ1aU3PgyRh8A0LbpbvdQMrDvnrlhx5QuXOq/b+Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060809;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=o/FhgvVv4w8DwxvlSqjn82tyNX/vmV8ByoXib98UWuw=;
	b=kzA9L2L23y5l/8PhlnUUV/YE5qi1eXMf7qz3MiH644wTatqJ7UrfzLacstOIH3EG4Mdo
	 d85uHWsAyRUBtAyw4yJvs2ttfnis/LVYNVh63X2oYadrogGTPqmeJE9fAyAOl99d4UKev
	 kyhQ74elyqesoCTYpsoj4oo3BNmofp5J7UIk6PD4TDG33v8y/T5UMW8lQaEoqcGrOyOji
	 bjNvE8fomww0mTf78r1X9TRhsKfzVv1Nf1EZpsht3KPgfvSvOf8pBgYNZfTeE92fiedRo
	 MGw7gUjgQBQf1zWPi6vHKu+1D/ppe7NFLYk1nYB+aq+UfOtEgXckbn82yid8rlb+E0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R5Y+UF4E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6EA606A326;
	Sat,  7 Nov 2026 14:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R5Y+UF4E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB651F0089F;
	Sat,  7 Nov 2026 14:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060809;
	bh=o/FhgvVv4w8DwxvlSqjn82tyNX/vmV8ByoXib98UWuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R5Y+UF4EJI77kps8v+mtZU4I2jNB0qUFhnFfCRqrJpQfL2PNXOlGQMbT+lzwaZJbY
	 H0GVU+hVt39KnhpTuTMCb9QEDxQe3t8RQtLMXnmuGsK3gBQuDjdoz29GaifNP9ALNR
	 Y4nZsIFTuGDmf++eIPGNCmeXP69KZco7R8REPUaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nizar Al-Kabbani <nizar.m.kabbani@gmail.com>,
	Denis Benato <denis.benato@linux.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0169/1536] platform/x86: asus-nb-wmi: map ProArt key (0x8b) to KEY_PROG3
Date: Sat,  7 Nov 2026 08:36:25 -0500
Message-ID: <20261107135002.410514793@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 10bdb1a431819..0d3b8c1a50a4d 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -621,6 +621,7 @@ static const struct key_entry asus_nb_wmi_keymap[] = {
 	{ KE_KEY, 0x86, { KEY_PROG1 } }, /* MyASUS Key */
 	{ KE_KEY, 0x88, { KEY_RFKILL  } }, /* Radio Toggle Key */
 	{ KE_KEY, 0x8A, { KEY_PROG1 } }, /* Color enhancement mode */
+	{ KE_KEY, 0x8B, { KEY_PROG3 } }, /* ProArt key (PX13/HN7306) */
 	{ KE_KEY, 0x8C, { KEY_SWITCHVIDEOMODE } }, /* SDSP DVI only */
 	{ KE_KEY, 0x8D, { KEY_SWITCHVIDEOMODE } }, /* SDSP LCD + DVI */
 	{ KE_KEY, 0x8E, { KEY_SWITCHVIDEOMODE } }, /* SDSP CRT + DVI */
-- 
2.53.0



