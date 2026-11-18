Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034012;
	b=d+tXRHXJiynQePAUOGSizC6fbaL9O5aBoK47rMRzProfOorEGqJAgNgU74X6keIr5oHt
	 E8nGLUy78vRpE7lbStu8HKMKzs/1dsPmsmk95NySTK4mIYlvmhGkRTbya16erct3Yknt5
	 RCIPK9RomGSLj93I+5barm6hlbUMsZOq4HJiWUKN8ax2nW+6fESI2Z8Lo//djFO0LbKOH
	 bFxKF9ESEg1JpJXWP8Ht+OJisQATsSXk99q1U+5/zRqmqo20ij8MeEp2Cirxmr/33E/ex
	 G6cJqi2bgZwITVi6bKQf9sjFd+tEOnbtaNw1YSXFrR4LeeaGrWgaHF+e8FSZr1pyYVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034012;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jfq796xoGvovvS2cJUwDYV5BTg0CfUDRHR+6GwI9yBY=;
	b=vYGTWxdzgpCGYzmph+x4LVtTVBBbMckW8/bg1dO19N+qrYB4Y7kVypKbcf9Qccq1AGtv
	 ZYsebw+W8lkA4fmU9/A0FLb6QamVdNmQ3jWaNKdY//YTaLWG5hLURKcyuo6rvhEBP2qJW
	 uFqm3Dbl/5KfXmlmcf6hF/vM5DmAK4wbmHmetuQSZs8va9QakMVgI+Ff2iMMf11ZnRKiz
	 0EivjQ1aWggIs6dEe7JzyTrSc64pLK6rqNfyBFoN1a+oofoirxT5kM6YFrjnjQJkuu8rx
	 PlgD9+BzSBglF90jXhA7JP2VMBB/CuwFGIWMQXG//gBmSW80HG91q2Q/JiRgVyXqFQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0lvSKSCt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201CD606A31C;
	Wed, 18 Nov 2026 20:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0lvSKSCt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DBE61F000C4;
	Wed, 18 Nov 2026 20:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034012;
	bh=jfq796xoGvovvS2cJUwDYV5BTg0CfUDRHR+6GwI9yBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0lvSKSCtnY2BZNf2V/tFjv2bcfncQYrob9/0cy9WaOn5qpQvok0Hxr59dLUpc9izV
	 Af5BNnltgZO5f4ArQ/ItAaioFnskCmhRWvoQEjHXcyZSmajRx8df5yaqihEaylQLw6
	 8a0H3IaLxmQabRbMtVNZk1MQuEwnbbEfmZFiRaJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuxiang Lin <mclyxfdw@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0219/3318] HID: quirks: add ALWAYS_POLL quirk for AULA Mini 60 HE Pro Dongle
Date: Wed, 18 Nov 2026 15:14:01 +0100
Message-ID: <20261118150321.548112909@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuxiang Lin <mclyxfdw@gmail.com>

[ Upstream commit 2884e21b18613708f050ec75330b265dd07ecc03 ]

The AULA Mini 60 HE Pro wireless keyboard dongle (USB ID
0c45:fefe) becomes unresponsive after roughly one minute of idle.
No error appears in dmesg; the only recovery is physically
replugging the dongle.

This has been reproduced across kernels 6.8, 6.14 and 7.1.3.

Testing shows HID_QUIRK_ALWAYS_POLL alone resolves the issue,
verified via usbhid.quirks=0x0c45:0xfefe:0x400.

Signed-off-by: Yuxiang Lin <mclyxfdw@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 1 +
 drivers/hid/hid-quirks.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 0a714af21056e..d98d04e9e0bdf 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -733,6 +733,7 @@
 #define USB_DEVICE_ID_JESS_YUREX	0x1010
 #define USB_DEVICE_ID_ASUS_MD_5112	0x5112
 #define USB_DEVICE_ID_REDRAGON_ASURA	0x760b
+#define USB_DEVICE_ID_AULA_MINI_60_HE_PRO 0xfefe
 
 #define USB_VENDOR_ID_JESS2		0x0f30
 #define USB_DEVICE_ID_JESS2_COLOR_RUMBLE_PAD 0x0111
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 97722b8803ce6..bca15dd628f5f 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -113,6 +113,8 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_1f4a), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_IDEACOM, USB_DEVICE_ID_IDEACOM_IDC6680), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_INNOMEDIA, USB_DEVICE_ID_INNEX_GENESIS_ATARI), HID_QUIRK_MULTI_INPUT },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_JESS, USB_DEVICE_ID_AULA_MINI_60_HE_PRO),
+		HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_PIXART_USB_OPTICAL_MOUSE_ID2), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M406), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M506), HID_QUIRK_MULTI_INPUT },
-- 
2.53.0



