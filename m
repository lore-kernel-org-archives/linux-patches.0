Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486671BBBEB;
	Thu, 30 Jan 2025 14:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245717; cv=none; b=fa/q8lIE92CmSo7o2GNnniaTDOjETugYzgRunvZipiJEPjEhKY9TZDFhk6n3G4UWyLvGt3Vjg3Scg3NW5iSDZk3TZ52ALsbVtsN226KDJixR9c67wSfn3dxergVmPZNWHyhw+oXvxlDkNIhGuKjCr4/mKKwMHmieLn5y/KsVxLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245717; c=relaxed/simple;
	bh=PxRJGV/1GWe6cDSZDCGeU1chXldas1bBchnevNYtjTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2ZJiBuJ9sWAhcEWh1nDCtTPbuajtw0pzW8crxsmW3lpPcxNLA4OC9NOgNS2XB6qjSl1zFeCAftiS1dp+T8VMeVq7W3rx1BdKsINwZublF6bObM4ix6YWB7U0McagGrF4LQmpL0HXvW+zCwAXHsn5RjxKsuvajFV8BY0YkRRZiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Al5/RjnZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Al5/RjnZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9047C4CED2;
	Thu, 30 Jan 2025 14:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245717;
	bh=PxRJGV/1GWe6cDSZDCGeU1chXldas1bBchnevNYtjTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Al5/RjnZc4mgIou9LFL1mFxIorIeibJmBngm5Yfrl456Q4bt3N7KwfS391zu31P15
	 xUJgCot3vPvOD+otP9ycw2krzjtSbu6nIGQjkQIe8cndpFO5y3nDYX6yVzDu6d+uAY
	 zQ2ol/UziiJgtAG46AtfiR6TmSZj1qIpMDA4iQFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Pierre-Loup A. Griffais" <pgriffais@valvesoftware.com>,
	Vicki Pfau <vi@endrift.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 37/40] Input: xpad - add QH Electronics VID/PID
Date: Thu, 30 Jan 2025 14:59:37 +0100
Message-ID: <20250130133501.193363514@linuxfoundation.org>
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

From: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>

commit 92600f3295ff571890c981d886c6544030cc05f3 upstream.

Add support for QH Electronics Xbox 360-compatible controller

Signed-off-by: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>
Signed-off-by: Vicki Pfau <vi@endrift.com>
Link: https://lore.kernel.org/r/20250116012518.3476735-1-vi@endrift.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -306,6 +306,7 @@ static const struct xpad_device {
 	{ 0x1689, 0xfe00, "Razer Sabertooth", 0, XTYPE_XBOX360 },
 	{ 0x17ef, 0x6182, "Lenovo Legion Controller for Windows", 0, XTYPE_XBOX360 },
 	{ 0x1949, 0x041a, "Amazon Game Controller", 0, XTYPE_XBOX360 },
+	{ 0x1a86, 0xe310, "QH Electronics Controller", 0, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0002, "Harmonix Rock Band Guitar", 0, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0003, "Harmonix Rock Band Drumkit", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0130, "Ion Drum Rocker", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360 },
@@ -516,6 +517,7 @@ static const struct usb_device_id xpad_t
 	XPAD_XBOX360_VENDOR(0x1689),		/* Razer Onza */
 	XPAD_XBOX360_VENDOR(0x17ef),		/* Lenovo */
 	XPAD_XBOX360_VENDOR(0x1949),		/* Amazon controllers */
+	XPAD_XBOX360_VENDOR(0x1a86),		/* QH Electronics */
 	XPAD_XBOX360_VENDOR(0x1bad),		/* Harmonix Rock Band guitar and drums */
 	XPAD_XBOX360_VENDOR(0x20d6),		/* PowerA controllers */
 	XPAD_XBOXONE_VENDOR(0x20d6),		/* PowerA controllers */


