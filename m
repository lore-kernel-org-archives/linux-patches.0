Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591341;
	b=CB525fgT/KNhwxFPkDE1yWUdKwKbH0ltKajICEoNUVGxsDiwcQ1FGHv+zbEP6+EHy4yK
	 XGFXyYa8o3HMk48C1pXLWUzO1Nc+BqocEeUy1ZAqUdxwsd58V8jtzyPzC5FPYKgEhbL5s
	 65pUf7/sjEj3n4tMNcq88jKvKxflS2Jlm0vxfkg2fg18Os1QTnx1i5Np7Zl4BAKOQrm/S
	 PUw33omwQgJF+c98/Vx4hFUCzN0riKURPrTUkxRjDyc1PhkTyBlkTzUfHoX796LBQhLtF
	 qZ1yVQMmFIa7oQ59ShFZn/ecIqyWxBr0IvausTDuuX2oy1LZNAy66HEqBRFrKVoZOuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591341;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tkAvN+TUGKcUI3mPbgZvoG7S9dShMoWn3LgsmvYVR4M=;
	b=qxfwnZaDAX88j08sWcFsVCu+Ogu6XMd1RagoWU/2Pi8dT7OVQAeGn5molY8ykA/RORGj
	 gOrEY19W3/YRId2/QkfT4sjQTuRVisGu1FaKsE7WbIFNIiUriqKAwpjk/F5j8IC70hGYy
	 yX9Fvq+j6zUvFXUQC6iP8idJAF/eZ3geJkBka6FH8AmQZJtmGolrYvcz/k26rzkzdfH7Y
	 zyk+j6OMs5bjwAq63CpgA9r37IeV8YQcZ84DKrqbuoPICL5QykRpq47Zik4f8LtoFftjj
	 Oc78nht/iz2vhTtFD+RHrRczdNdwTqhOjoX+/9CWWjx8Ap4nSJzV99E54HB/J8OL29w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J9QL37eu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D71606CED8;
	Fri, 13 Nov 2026 17:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J9QL37eu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8181F000C4;
	Fri, 13 Nov 2026 17:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591341;
	bh=tkAvN+TUGKcUI3mPbgZvoG7S9dShMoWn3LgsmvYVR4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J9QL37eu3TJ1F30DeSgQsN9FJ0A9msV6OkfEK9oS2qMndFv6UKPBrOmtTGlUX9kAE
	 5ifwhL83KJdn8IQIQsxkRU8i1a3rQkW3Q2+pwo8f7zDdvyH4Alb744CyiiBuafrHqu
	 Mog2WspkgVvCqPYV4cvZ1oN+WW+r9Gg58PofZ4/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ali Resool Tuama <aliresool567@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 450/670] USB: quirks: add USB_QUIRK_WINDOWS_CONFIG_REQ_SIZE for GameSir G7 SE
Date: Fri, 13 Nov 2026 10:50:14 -0500
Message-ID: <20261113153827.164189351@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Resool Tuama <aliresool567@gmail.com>

[ Upstream commit 40224df29729618ecd88c5c0077e71b1e82c7a3a ]

The GameSir G7 SE wired controller first enumerates as 3537:10a0 and
then re-enumerates in a mode it picks from how the host enumerated it.

When the configuration descriptor is fetched the Linux way, 9 bytes
followed by the full 80, the controller disconnects about 1 ms after
its string descriptors have been read, before SET_CONFIGURATION, and
comes back as 3537:1082, a generic HID gamepad without force feedback.

When the configuration descriptor is fetched in one 255-byte request,
as Windows does, it comes back as 3537:1010 in Xbox One (GIP) mode,
which xpad already supports, including rumble.

Skipping the device qualifier requests (USB_QUIRK_DEVICE_QUALIFIER)
makes no difference; the configuration descriptor request size alone
decides the mode. Add USB_QUIRK_WINDOWS_CONFIG_REQ_SIZE for the 10a0
identity, as is already done for the ShanWan Wireless Gamepad.

Cc: stable <stable@kernel.org>
Assisted-by: claude-opus-5-5
Signed-off-by: Ali Resool Tuama <aliresool567@gmail.com>
Link: https://patch.msgid.link/20261002-master-v2-1-24b05d8792b5@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 23d5c30332ffb..ee439a2ddf316 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -607,6 +607,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* ezcap401 - BOS descriptor fetch hangs at SuperSpeed Plus */
 	{ USB_DEVICE(0x32ed, 0x0401), .driver_info = USB_QUIRK_NO_BOS },
 
+	/* GameSir G7 SE */
+	{ USB_DEVICE(0x3537, 0x10a0), .driver_info = USB_QUIRK_WINDOWS_CONFIG_REQ_SIZE },
+
 	/* DELL USB GEN2 */
 	{ USB_DEVICE(0x413c, 0xb062), .driver_info = USB_QUIRK_NO_LPM | USB_QUIRK_RESET_RESUME },
 
-- 
2.53.0



