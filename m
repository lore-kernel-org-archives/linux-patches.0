Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829742;
	b=TQu7//FvGLTenvKVss5T9aRfpV/F4GyLsNmHye7ZKsz5XLqjasvypeMmwDMr3Sk3DT/i
	 w5z2FVcviBnrIDsRIPLo+Zk8mLwPuhOjauTVs4xSV81UMgDcomDGp1ucUzM6XzTHzTjvr
	 njk7D8toxCFQYEavOSYQcP4aTxF93eniPLcYICqEcMvTmeLu6YSBMht70fB9ycAfX9RT+
	 8fY9zRMHP/fBmVgKKKie25wvaIAXnBDfvFv9dG16kj4NZ1fn91hXRiKgjW0kesF6UZ1Qc
	 z0OlkoyKR516xt/z2OymV0e7PpkWRkwoeDFTdeEbGBeymIITKihPAgmGm50aJX58CJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829742;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=86hB8Qx5uFRRlpNPePmcDZ9Y1r+kkpo0SdqtSIbhCD0=;
	b=Y6rCJYOsmCxHDR3h5iNx3ZQdqQEr2izaPjvJUa+h2sW+yA51Ji+EE2bOtM/53mpCW6t7
	 q18K+f/oYSGN4szW2f/fO88RG5UZBRCRW7m0g+6tEtZmBk3zWl4l5y9gHKqczeotNf4q5
	 jvOBq5+L8Pq64nEfiWgKgzimDlRn7EXw/5O2tpI+l0ByO4838mlcAm6DLBmKGd6OjtEN/
	 SImSDfbyRKX2FbGYu8GmNkqgmDizePSTWKhJ/UiisvPJ6bv6UCxyiwMSKNoU8SUR+IQqg
	 d78b8LoEz1XwIF2Q1ZY2dDIN+d9P6wOrL99l/EMp2oJwg7cCWD9gA8AfFvcVvIEc6sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lASqwpjZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E218606BA25;
	Wed,  4 Nov 2026 22:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lASqwpjZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FAB1F00A15;
	Wed,  4 Nov 2026 22:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829741;
	bh=86hB8Qx5uFRRlpNPePmcDZ9Y1r+kkpo0SdqtSIbhCD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lASqwpjZ984Ut439RjMeW5rnDIkgLxfih6R6Pfu9MF4vs8jjmmodhDsGrIIRvImBU
	 EnCi45m9GKMirI1xOHbU4gxUJJ34mBhmZAsaX0e0m+yUrMPIJuAK5dhr+NJonTLou6
	 qjmSUjBAF6/oikXOjqjikslf0gIH4bHLdgrrVbkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Ma <mapengyu@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0315/1005] HID: quirks: Add ALWAYS_POLL quirk for Beitong BTP-KP20D dongle
Date: Wed,  4 Nov 2026 16:00:48 -0500
Message-ID: <20261104211052.760644039@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Ma <mapengyu@gmail.com>

[ Upstream commit bfff246b3a31cb45ec297ca5e2a77c1410b207ac ]

The BTP-KP20D dongle in Direct/HID mode (20dd:5159) re-enumerates every
few seconds because usbhid never submits its interrupt-IN URB: no HID
driver binds to the vendor-specific report descriptor, so the device is
never opened, and the firmware treats the idle endpoint as a lost link.

Add HID_QUIRK_ALWAYS_POLL to keep the interrupt-IN URB submitted from
probe time.

Signed-off-by: Aaron Ma <mapengyu@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 3 +++
 drivers/hid/hid-quirks.c | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index a9db2b30be9bd..c1a7f5558ccd1 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -262,6 +262,9 @@
 #define USB_VENDOR_ID_BAANTO		0x2453
 #define USB_DEVICE_ID_BAANTO_MT_190W2	0x0100
 
+#define USB_VENDOR_ID_BEITONG		0x20dd
+#define USB_DEVICE_ID_BEITONG_KP20D	0x5159
+
 #define USB_VENDOR_ID_BELKIN		0x050d
 #define USB_DEVICE_ID_FLIP_KVM		0x3201
 
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 9d18b962e0ea6..3de594ee25c38 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -45,6 +45,7 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ATEN, USB_DEVICE_ID_ATEN_CS682), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ATEN, USB_DEVICE_ID_ATEN_CS692), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ATEN, USB_DEVICE_ID_ATEN_UC100KM), HID_QUIRK_NOGET },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_BEITONG, USB_DEVICE_ID_BEITONG_KP20D), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_MULTI_TOUCH), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_PIXART_USB_OPTICAL_MOUSE), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_PIXART_USB_OPTICAL_MOUSE2), HID_QUIRK_ALWAYS_POLL },
-- 
2.53.0



