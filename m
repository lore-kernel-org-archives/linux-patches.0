Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F0730BF6E;
	Tue,  2 Sep 2025 13:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820299; cv=none; b=V3SeQYVJUbd0/8NAtaFtgktXWaKTmkiXtDEWrBiXSP55cLqCh7JF9RtFWfyNKWqoWRTHqnnK9ezCRIPvCt4ni+X78c2Y40wFNZPYB823qNpGVqBuk1RaVT0biYu8EMD+nfCrQ692a+XAZB4RNuHJm2JToLpz3IZaK7Ojriw3h1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820299; c=relaxed/simple;
	bh=s7R4hvmyRtQyON2Y/lMgNRmQ2ifPMGIxMnMwQ9k+2Do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rpr9Z3fdLOuVn9JWiAd15Ze6cqhNwPW4DAum6+gf613jx2/dAjV+2sw4csP4d4/y6b+ev4xO8Je7yo6B+2nBGLuLrG/IFx5HBgX0QpZusfQHWSopaMLPEhp8hMnR8QUwDvBkK3p8yfkb8ZMYOutTyakk2qshJDPFu0DM+sxKC8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rvr7kBjs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rvr7kBjs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D051DC4CEED;
	Tue,  2 Sep 2025 13:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820298;
	bh=s7R4hvmyRtQyON2Y/lMgNRmQ2ifPMGIxMnMwQ9k+2Do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rvr7kBjsRdr2w5V7tWCI/AEnpu6S8vVMVJ41yHE2XtTtOkimpTtT42zuEPGtRoeY7
	 mUmoqextaNylCnVeMpT5l01BwXGGG5S7ytVwOfINiap/Su2FveSP99Jo/3qPY1Lkhq
	 nVC+OtJQBYlufyFNjnK+9YhmN9PL+mfvh+bfaBYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 60/75] HID: quirks: add support for Legion Go dual dinput modes
Date: Tue,  2 Sep 2025 15:21:12 +0200
Message-ID: <20250902131937.468189641@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -818,6 +818,8 @@
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


