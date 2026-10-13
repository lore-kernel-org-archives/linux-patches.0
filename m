Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B4D4B95C0;
	Tue, 13 Oct 2026 11:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791891965; cv=none; b=CNUBMoD9qfD+XP35Or3EmnmtR4CO1hwxmyG/23TN5JT1YCy2rLOeZhjB3X/3Uow23U4kbi5K8SgUxqLkuBgMeTp6xCI27CfbiDZh5jRjsPM2+pWGkNI0HYRZLU/8e/yS5wbP3LEqANsS+Fqr5iZi9S/g9v4E9v10WEdVyvW2tQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791891965; c=relaxed/simple;
	bh=f4v+vxPxveEGyDzzq+jGUoCZofUEpyOd9kckYgnxw/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=px6ANvj0+x3QxoQG0uN6XCsPB/bd/c93y+aCCSJSyVbxavO5dIwCiTEKgiXC10CFp6saoaCItJ9hbkCht0zkuOppzo4lo5DadcfyADlSObEbzyHD6g1Qe+01w+VbbpvBzCsp5mG2+5pv16iqya0CCnQ/hID3Df/96MWbsYgROQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k4vanO59; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k4vanO59"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29ECE1F000FF;
	Tue, 13 Oct 2026 11:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791891964;
	bh=x8GAwuYGxAk/mDKFjfVXvXg7NVK0/E0m5o/yhatOijE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k4vanO59/Gv1RcLpt3WkHJ/bZWsmGQ8j9H9KjpXfStL47WatAoQRyDc9rCzUT72xP
	 yEdgehoeRv2z0CczjlIYZKwX7B6ZCogR2ZTKdCwrog4ryMAqdxZqtVqRIsNMUndTHz
	 U+vrlDGfHcWLPglQRkTmJVv+lISSVOSnWTQ94Q4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bihaan Sen <stevewholikesthings@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.2 016/281] Input: xpad - add support for 8BitDo Pro 2 Wired Controller for Xbox
Date: Tue, 13 Oct 2026 13:35:32 +0200
Message-ID: <20261013112855.442935462@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -379,6 +379,7 @@ static const struct xpad_device {
 	{ 0x2993, 0x2001, "TECNO Pocket Go", 0, XTYPE_XBOX360 },
 	{ 0x2dc8, 0x2000, "8BitDo Pro 2 Wired Controller fox Xbox", 0, XTYPE_XBOXONE },
 	{ 0x2dc8, 0x200f, "8BitDo Ultimate 3-mode Controller for Xbox", MAP_SHARE_BUTTON, XTYPE_XBOXONE },
+	{ 0x2dc8, 0x201e, "8BitDo Pro 2 Wired Controller for Xbox", MAP_SHARE_BUTTON, XTYPE_XBOXONE },
 	{ 0x2dc8, 0x3106, "8BitDo Ultimate Wireless / Pro 2 Wired Controller", 0, XTYPE_XBOX360 },
 	{ 0x2dc8, 0x3109, "8BitDo Ultimate Wireless Bluetooth", 0, XTYPE_XBOX360 },
 	{ 0x2dc8, 0x310a, "8BitDo Ultimate 2C Wireless Controller", 0, XTYPE_XBOX360 },


