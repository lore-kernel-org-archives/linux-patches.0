Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043380;
	b=PqzEE3tl1pPjjGw6fzKOzPVO66Rn9jWWIVEfXTKWG6CRAYx9xqr/EoT0IhPiElPDDEhm
	 7fxVC9PllziTfE1znQ5OfIdc7oAnqEW7ItEEJdOnI2PrMyL3A5MxzaDR1zdz8/gKWatG/
	 rv85vl73RKS+gE9kHL9CceY6tdZFsbGMY0JLAM6xNzvl7eT8jX68XpzHVFU41rcOzmEWq
	 dSVriXhjTfsNtQeGbrqtx1/P7J5QAQVdDq/hKlSuih4/fAWGgQeMUm7NAkWe54oQzPFOr
	 sq+bOhTZH/xEZ54hvulwLrpJ9Dz5uSGEzxf6D3DPLLh84slgYsKfrrYtkC5ZxobCVew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043380;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cibSdoGxmAdAJpf+RNNepgpukQ7Y7Cm8hB7cCgnrg0g=;
	b=QJasTQNiNK7reJWDrHGPJFZe4FN6U2XJGUn9s513gGRhNMpF66/lcZ6pLXNOqqX63kzd
	 0UCCUdIKHRB9IjoRqG9l4vrqd0JnaE6/jGksBac9add0kNglKOUl9kgeD0lnbssWQ20nz
	 nattkJXw06IR0uorlehh/BS/AbVKEzpPIHBRMDo9LBcOQiAOtlgU3M0cxAOV/6lAGWoSY
	 UXylLPtgobOr+4rUliPQw7pJjS4hattw3eYGzqQgxR1p8McZwWJdNFv4wPfh3oedC6ZSU
	 sDjFYT/QP+rV5+LUOZDo4aAPDexvhQ912hRmGviLFIoFSGf7iCf5Au4S95VvaUv8How==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EG5J4bje;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DE7606A320;
	Wed, 18 Nov 2026 23:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EG5J4bje
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CDA31F000C4;
	Wed, 18 Nov 2026 23:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043380;
	bh=cibSdoGxmAdAJpf+RNNepgpukQ7Y7Cm8hB7cCgnrg0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EG5J4bje7gFpBM0EE7MnIbFZjar3T9mNsvEgayfILMJTTKfkXJ17ulVcFTHdTa4kb
	 FbJ23Q0lyt5SpIqsqUCZi7P9S3Uc7LgBp30Oa1HANlA1BdoGMT3eFKu9eL0H0Tebhk
	 bmQM11L+IEJ8pIl9tFOrcqMa08WTLhOdudWkhrV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Ma <mapengyu@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0188/2857] HID: quirks: Add ALWAYS_POLL quirk for Beitong BTP-KP20D dongle
Date: Wed, 18 Nov 2026 15:20:22 +0100
Message-ID: <20261118150208.115054616@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 310ba8c01c101..4d185a3a4d2ad 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -247,6 +247,9 @@
 #define USB_VENDOR_ID_BAANTO		0x2453
 #define USB_DEVICE_ID_BAANTO_MT_190W2	0x0100
 
+#define USB_VENDOR_ID_BEITONG		0x20dd
+#define USB_DEVICE_ID_BEITONG_KP20D	0x5159
+
 #define USB_VENDOR_ID_BELKIN		0x050d
 #define USB_DEVICE_ID_FLIP_KVM		0x3201
 
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 3dc6101680cc5..683b3a2251ed6 100644
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



