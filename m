Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446F04F405F;
	Tue, 13 Oct 2026 12:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892834; cv=none; b=qvbsXN/NRyJwt2Yvsn16Txtl4Cp4QrI/Qrgj1HNGgnkLZVwhoYsbvaF50yWQGFXYMaH1DUeKh8/S2eP+DJg4JNgLw5xl2VjLFastIE1X4jBOfReCrg7yFLmw+VTnJfnrW16cZanRI8SGEjuQP3F22I2siZdehJUpng7w0DMBAKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892834; c=relaxed/simple;
	bh=XWgQxajHZlx84YAjIR2Y75cMY15k0RydykcT/EPhIAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOEBrnUWjFnljFRxFxBfRxdCBL2ozMlfjJsTmaw+8LI2PFKwoVEFP8nTGLzfC4h0NGFnuqaLM6Ne2lfjGeW4TStH1xRHoI1HeB3jnohu9TlCaL4BlMBqS5PDin8a6HcTJLjhlfKAB3RrVH8iy/lt+A/HfXKlUVCn6vFK8mNrgyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MsXGp41Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MsXGp41Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EEC31F000FF;
	Tue, 13 Oct 2026 12:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892833;
	bh=EDAauZiHuh020oz81jFQK/mLmlo8PZKvRnX2XPMVwMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MsXGp41YoIM3nrOr3MPtf7yUpAiZRjaq7rNdLshDRUD05p5SJtFYykvbfb+MHGMX5
	 uXZnPiLuBvKyfiQ3ZiXxoyS28EcQ6wfRdBIvUiHatcrH0YI1AflGF+UinNYLfCJrBX
	 hbQqATyBsXk4CZh1SwonYJSlr85K6RpA5h6+GVX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bihaan Sen <stevewholikesthings@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 024/621] Input: xpad - add support for 8BitDo Pro 2 Wired Controller for Xbox
Date: Tue, 13 Oct 2026 13:30:19 +0200
Message-ID: <20261013112921.440072637@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bihaan Sen <stevewholikesthings@gmail.com>

commit 41363c27b8509bd4efcba244803edac9ba25d1b5 upstream.

The 8BitDo Pro 2 Wired Controller for Xbox is already matched by the
vendor-wide XPAD_XBOXONE_VENDOR(0x2dc8) entry, but a later hardware
revision reports product ID 0x201e, which has no entry in the
xpad_device table. The device therefore binds and functions but is
exposed to userspace as "Generic X-Box pad".

Add the VID/PID pair so the controller is named correctly, and set
MAP_SHARE_BUTTON to expose the share button as KEY_RECORD.

Signed-off-by: Bihaan Sen <stevewholikesthings@gmail.com>
Link: https://patch.msgid.link/20260925114459.110253-1-stevewholikesthings@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -413,6 +413,7 @@ static const struct xpad_device {
 	{ 0x2993, 0x2001, "TECNO Pocket Go", 0, XTYPE_XBOX360 },
 	{ 0x2dc8, 0x2000, "8BitDo Pro 2 Wired Controller fox Xbox", 0, XTYPE_XBOXONE },
 	{ 0x2dc8, 0x200f, "8BitDo Ultimate 3-mode Controller for Xbox", MAP_SHARE_BUTTON, XTYPE_XBOXONE },
+	{ 0x2dc8, 0x201e, "8BitDo Pro 2 Wired Controller for Xbox", MAP_SHARE_BUTTON, XTYPE_XBOXONE },
 	{ 0x2dc8, 0x3106, "8BitDo Ultimate Wireless / Pro 2 Wired Controller", 0, XTYPE_XBOX360 },
 	{ 0x2dc8, 0x3109, "8BitDo Ultimate Wireless Bluetooth", 0, XTYPE_XBOX360 },
 	{ 0x2dc8, 0x310a, "8BitDo Ultimate 2C Wireless Controller", 0, XTYPE_XBOX360 },


