Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060880;
	b=i9QKYqepzdMvqmrRVnjHE/zOZBDZRUz2tkSPVW0z4N1JTol7yoBH3QGRVDuw9Xw3E6Q1
	 yMh6PjU6xwAg+oMemAZXlJ98ZwUegkqFVX3TA3+XNjBVKAyayEaqu9ye1w4HeDJzrzPPl
	 idhZnebiy1HQf7KTa/xy3RD6MfSUqVLqu7oB8MvyUqMXb9Uv4qEDONjziDjdTycJb5vHd
	 2iK9FSTLYtgTfP52uJRZDe0hyJ/lDsh9tcaeNtdP6IIQf254rkBjOYBpI6k0c05UR9YQ8
	 4MfmaobSWRnsZNvvUg3aIVAkqmeGmHsbm+BGPQSw9CTEcb7H06MY94HfMBQ9h+mKMOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tT7hH3hfaZF8zeZOY1xE5IT0cUsOF8HUTtQgKEGU3ek=;
	b=k2X3xDVoCRwxm0CQ/4gB1ymAtQ57KxDBUfXOeRgM7bvYmJV0r6Osy57JJE1AWdU/MugN
	 1s+mIdJa751zsYVb/gJ+ZL8GmZ2f+Qbz5MvDGspLFPnFper52Ig/ayQ0sJiHxSMp+Bb6J
	 kffWANDoRmzHj6cc5crhV4stFxYkt054GOUtVI9eknF5nOD2w2ubR5in3n3vEYjpe1/LV
	 XsAcKLQzoOmClWKgABn8O8iTGDJWI2Kfv6ilvIvI4QsKrKt9VQba/0SUH1QU0Nw/celYY
	 CEvjKrJIMS4LGnnFD9RZuLCCLkZLWUR7AuCX1ux4uFj4sLG4bIIAuBiYFgnpEtGNNPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=otRLu7lb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA6E606D80D;
	Sat,  7 Nov 2026 14:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=otRLu7lb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 754BD1F008A1;
	Sat,  7 Nov 2026 14:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060879;
	bh=tT7hH3hfaZF8zeZOY1xE5IT0cUsOF8HUTtQgKEGU3ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=otRLu7lbfIOTXXaQa3OrreGiXYgY7QwDzayrC1GEsKaESTO4Fwuo8xBI71xvEAxR0
	 OSPaWhB8Hj+nNcQM/WgQZnTjuv9IV/y/5OMNxaZZiCUqUxBVsZ9foij8miSKy/46B+
	 k/X2dIUSdGzzEk5fF/s8rY9f9Qt4ksEAAt0Ujvv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Ma <mapengyu@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0260/1536] HID: quirks: Add ALWAYS_POLL quirk for Beitong BTP-KP20D dongle
Date: Sat,  7 Nov 2026 08:37:56 -0500
Message-ID: <20261107135004.987034193@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 643e3d7a041d7..7d63306dccbd9 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -258,6 +258,9 @@
 #define USB_VENDOR_ID_BAANTO		0x2453
 #define USB_DEVICE_ID_BAANTO_MT_190W2	0x0100
 
+#define USB_VENDOR_ID_BEITONG		0x20dd
+#define USB_DEVICE_ID_BEITONG_KP20D	0x5159
+
 #define USB_VENDOR_ID_BELKIN		0x050d
 #define USB_DEVICE_ID_FLIP_KVM		0x3201
 
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index b95521c50d252..97722b8803ce6 100644
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



