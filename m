Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20DC312821;
	Tue,  2 Sep 2025 13:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819694; cv=none; b=MSkkxUJkFuXD4F/R1ZZlfaQZ/thF1c+e4U/dTc/eMMReOc6G1ayBGcXOA02lG+LepXGYbe7Zv7cKj97pUXu896zNqhcZWrZPA5tGM+UIuStjkA51YGy+Wp7m/pRvEsjjncKRLqK9m9+CipWSBRM53ZNFmWlzDwszvHmBxLnP5iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819694; c=relaxed/simple;
	bh=1PHxLMRWMz49/N2GbyLBQxopn/st2nzz+C7u5f21aIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sbbhxsQBpWz8TFODFQoW4llfXlGjxplM09vUt979SHAIMAjqqm2+TDfyWmhjUu8puZEkc9+tnNRPVj70DPd18q+LgEwun53cPXMp8WfqUuUNFlX6mIhpcllF1DQ0hD/rjJG2YwcJfGrssVzf7mMIOEc52DNnvStw1JYQpUna6qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ecmHNalG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ecmHNalG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E25FC4CEED;
	Tue,  2 Sep 2025 13:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819694;
	bh=1PHxLMRWMz49/N2GbyLBQxopn/st2nzz+C7u5f21aIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ecmHNalGZLqdNIMLsXuiGziOk/uvJGGOLDo+EkMLJbRysePk+T8m2L2rswIPZUvOc
	 cdfJgz+Q711Mgd3YYJp+pJEYpZ5QACABgJ0XnfFrWRIIGlskz49tZ0eKJgcdz8CzC+
	 1eW2+VXYJm0ZFlsu2nBKV4n5pCUm7ehvn9pfMdOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.16 112/142] HID: quirks: add support for Legion Go dual dinput modes
Date: Tue,  2 Sep 2025 15:20:14 +0200
Message-ID: <20250902131952.567010693@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antheas Kapenekakis <lkml@antheas.dev>

commit 1f3214aae9f49faf495f3836216afbc6c5400b2e upstream.

The Legion Go features detachable controllers which support a dual
dinput mode. In this mode, the controllers appear under a single HID
device with two applications.

Currently, both controllers appear under the same event device, causing
their controls to be mixed up. This patch separates the two so that
they can be used independently.

In addition, the latest firmware update for the Legion Go swaps the IDs
to the ones used by the Legion Go 2, so add those IDs as well.

[jkosina@suse.com: improved shortlog]
Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ids.h    |    2 ++
 drivers/hid/hid-quirks.c |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -832,6 +832,8 @@
 #define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_6019	0x6019
 #define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_602E	0x602e
 #define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_6093	0x6093
+#define USB_DEVICE_ID_LENOVO_LEGION_GO_DUAL_DINPUT	0x6184
+#define USB_DEVICE_ID_LENOVO_LEGION_GO2_DUAL_DINPUT	0x61ed
 
 #define USB_VENDOR_ID_LETSKETCH		0x6161
 #define USB_DEVICE_ID_WP9620N		0x4d15
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -124,6 +124,8 @@ static const struct hid_device_id hid_qu
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_MOUSEPEN_I608X_V2), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_PENSKETCH_T609A), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LABTEC, USB_DEVICE_ID_LABTEC_ODDOR_HANDBRAKE), HID_QUIRK_ALWAYS_POLL },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_LEGION_GO_DUAL_DINPUT), HID_QUIRK_MULTI_INPUT },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_LEGION_GO2_DUAL_DINPUT), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_OPTICAL_USB_MOUSE_600E), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_608D), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_6019), HID_QUIRK_ALWAYS_POLL },


