Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0254B1F890D;
	Mon, 21 Oct 2024 10:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507020; cv=none; b=V4KwBkbstoLNusG4S/2Zhq8YhnkeJD4Gb9OXot2TpEq+FyCcH8MjgBM8TdNWO7SZrOjt3EiDY5N6BiaTiKvCBudtMy346QIpSXrjegDLdePtYDN46Vv3sKfAkFmAkUyHLCe9sswxGQslLNC1B01l65NpKJ/pQnqToIQrb2MnIvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507020; c=relaxed/simple;
	bh=y/xcYOOZDTCYbX2E3cbQFrIE1PcwXpNh4JRhLf4IDTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lvRkknuOennxwP9GlMFgK8jNViwQRnFkhUxuZzQWTVfUQjJE/q4ZJSFWBDw/oRdsBP+GpqWfOyYkt71G8VGwGjJXt5JV1z48Xy3xSkDCet1/CVx8HU/uADFOXM7ci+me9bJn/IEwutlMribEyai/DrejsK+wAvOnD/cirG9qDgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V59HM2qj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V59HM2qj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72DBCC4CEC3;
	Mon, 21 Oct 2024 10:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507019;
	bh=y/xcYOOZDTCYbX2E3cbQFrIE1PcwXpNh4JRhLf4IDTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V59HM2qjxxD/nGfXE3lJmnDHb2hruwA+suZkJyyxxX7O91m283xN/DIFgoPhAMJbW
	 6cpV1mKAtlDyLYuBXIsvvi/PKqk0kZCTZ4kE4LRIfM4E4I+z2G9Ft9llRxKcRNp0hf
	 HTEHpEUhv6ayaaOsoeMhQ9GsisGHyfD/IdmO4rhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Edwards <uejji@uejji.net>,
	"Derek J. Clark" <derekjohn.clark@gmail.com>,
	Christopher Snowhill <kode54@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 063/124] Input: xpad - add support for MSI Claw A1M
Date: Mon, 21 Oct 2024 12:24:27 +0200
Message-ID: <20241021102259.171669200@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: John Edwards <uejji@uejji.net>

commit 22a18935d7d96bbb1a28076f843c1926d0ba189e upstream.

Add MSI Claw A1M controller to xpad_device match table when in xinput mode.
Add MSI VID as XPAD_XBOX360_VENDOR.

Signed-off-by: John Edwards <uejji@uejji.net>
Reviewed-by: Derek J. Clark <derekjohn.clark@gmail.com>
Reviewed-by: Christopher Snowhill <kode54@gmail.com>
Link: https://lore.kernel.org/r/20241010232020.3292284-4-uejji@uejji.net
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -217,6 +217,7 @@ static const struct xpad_device {
 	{ 0x0c12, 0x8810, "Zeroplus Xbox Controller", 0, XTYPE_XBOX },
 	{ 0x0c12, 0x9902, "HAMA VibraX - *FAULTY HARDWARE*", 0, XTYPE_XBOX },
 	{ 0x0d2f, 0x0002, "Andamiro Pump It Up pad", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX },
+	{ 0x0db0, 0x1901, "Micro Star International Xbox360 Controller for Windows", 0, XTYPE_XBOX360 },
 	{ 0x0e4c, 0x1097, "Radica Gamester Controller", 0, XTYPE_XBOX },
 	{ 0x0e4c, 0x1103, "Radica Gamester Reflex", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX },
 	{ 0x0e4c, 0x2390, "Radica Games Jtech Controller", 0, XTYPE_XBOX },
@@ -486,6 +487,7 @@ static const struct usb_device_id xpad_t
 	XPAD_XBOX360_VENDOR(0x07ff),		/* Mad Catz Gamepad */
 	XPAD_XBOXONE_VENDOR(0x0b05),		/* ASUS controllers */
 	XPAD_XBOX360_VENDOR(0x0c12),		/* Zeroplus X-Box 360 controllers */
+	XPAD_XBOX360_VENDOR(0x0db0),		/* Micro Star International X-Box 360 controllers */
 	XPAD_XBOX360_VENDOR(0x0e6f),		/* 0x0e6f Xbox 360 controllers */
 	XPAD_XBOXONE_VENDOR(0x0e6f),		/* 0x0e6f Xbox One controllers */
 	XPAD_XBOX360_VENDOR(0x0f0d),		/* Hori controllers */


