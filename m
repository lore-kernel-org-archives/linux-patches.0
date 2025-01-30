Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0141E3DF8;
	Thu, 30 Jan 2025 14:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245723; cv=none; b=NrAtXF9Tz17GhmWHt7EXT1YKHM+X6GAsEonBgLXXNu5zOzDXsg+VfQb1OY5ngYQ6RNTwbqFxGvZSdx4b1zwDT+PeDuzCXzBPB3tVLC8Jwbcjw/oGebt4oQoeNKgG9Fs+tylUhC0sV+dIcFB/HCQz367j56hwTZbCBonCHEdDQ0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245723; c=relaxed/simple;
	bh=t/KmDtZ1H0U3NS5RNeMKgG5VonH4lLaX6aRKLxxm0/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KkA8hdt/6+yGnRHr5MKQk0dPmz2czqjPV69w4cvesx78zUYIy0LlVrA+wL8kCD4xig6csZsAJzv4SYNhqIzZotC46U9FbZOcc1L3U+ePm6iOKMSlLf7LrUaZGwJ6yQVB1zZJvoqnBNz+pT7MBoDlcBvtjpTGl4a3udn10y6wVwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vNOQMpXA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vNOQMpXA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B32C4CED2;
	Thu, 30 Jan 2025 14:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245723;
	bh=t/KmDtZ1H0U3NS5RNeMKgG5VonH4lLaX6aRKLxxm0/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vNOQMpXAC3bNsgeIS1r8lN8+HjJqKlH0Plw9uzwq/RM4wDjQORH78JIZOBE7Gymkr
	 j3/cHQoJwEE4LFc3tMATXvZ6TCZQ/S1Na/su0Az7Sq1sEvtzxdtpZVLtOU9wLRREdS
	 9fHVvhpAMZMKgfD2bcB4kTmaI+4/bTUsNp9owNDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matheos Mattsson <matheos.mattsson@gmail.com>,
	Pavel Rojtberg <rojtberg@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 39/40] Input: xpad - add support for Nacon Evol-X Xbox One Controller
Date: Thu, 30 Jan 2025 14:59:39 +0100
Message-ID: <20250130133501.273984317@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133459.700273275@linuxfoundation.org>
References: <20250130133459.700273275@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matheos Mattsson <matheos.mattsson@gmail.com>

commit 3a6e5ed2372bcb2a3c554fda32419efd91ff9b0c upstream.

Add Nacon Evol-X Xbox One to the list of supported devices.

Signed-off-by: Matheos Mattsson <matheos.mattsson@gmail.com>
Signed-off-by: Pavel Rojtberg <rojtberg@gmail.com>
Link: https://lore.kernel.org/r/20250107192830.414709-9-rojtberg@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -386,6 +386,7 @@ static const struct xpad_device {
 	{ 0x31e3, 0x1310, "Wooting 60HE (ARM)", 0, XTYPE_XBOX360 },
 	{ 0x3285, 0x0607, "Nacon GC-100", 0, XTYPE_XBOX360 },
 	{ 0x3285, 0x0646, "Nacon Pro Compact", 0, XTYPE_XBOXONE },
+	{ 0x3285, 0x0663, "Nacon Evol-X", 0, XTYPE_XBOXONE },
 	{ 0x3537, 0x1004, "GameSir T4 Kaleid", 0, XTYPE_XBOX360 },
 	{ 0x3767, 0x0101, "Fanatec Speedster 3 Forceshock Wheel", 0, XTYPE_XBOX },
 	{ 0xffff, 0xffff, "Chinese-made Xbox Controller", 0, XTYPE_XBOX },
@@ -534,6 +535,7 @@ static const struct usb_device_id xpad_t
 	XPAD_XBOX360_VENDOR(0x2f24),		/* GameSir controllers */
 	XPAD_XBOX360_VENDOR(0x31e3),		/* Wooting Keyboards */
 	XPAD_XBOX360_VENDOR(0x3285),		/* Nacon GC-100 */
+	XPAD_XBOXONE_VENDOR(0x3285),		/* Nacon Evol-X */
 	XPAD_XBOX360_VENDOR(0x3537),		/* GameSir Controllers */
 	XPAD_XBOXONE_VENDOR(0x3537),		/* GameSir Controllers */
 	{ }


