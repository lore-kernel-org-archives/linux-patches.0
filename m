Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0913F21773D;
	Tue,  8 Jul 2025 16:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992566; cv=none; b=WkAgskyja8piHqjhQowYFFE4cnRsBXjBPbSRVleq0JFvpWjd7tBE+xAqtC4odMmjqvVlxraUtuCw4r8d4TWhNmQeIfrCbMHt4cFpLJdw4aGZtrWVrHxJ/rwFU7GnDGSC636FuQnFi9APr+FSHexGV9c2nTvbdDTY4xunEWM4XOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992566; c=relaxed/simple;
	bh=qyOtmWy/4PrZyeu/BI9ysobgKkFPofmX8RjN+2m6kBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HCFV+aKHroNn9XpLBLMT+mGYtOe1Oum5TZu2OaBquVgYUa497Hvh+j/HzClV1fZN22AeMlWtU+fRiRVL8KLNcxcyPx3JAO05rSKPSNNnQb1r5Ry0f6L2AZNuPAEtveHnzdBNq2WZZv24vPjV/JBlwR6/jWCtMkf91K1Jh1S2WbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W7h6Pq+y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W7h6Pq+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8376DC4CEED;
	Tue,  8 Jul 2025 16:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992565;
	bh=qyOtmWy/4PrZyeu/BI9ysobgKkFPofmX8RjN+2m6kBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W7h6Pq+yUFSgvjgdOyQPPCCvtecWBKO9TQTy/LcLZtfXuFl4LdZw91cAhUZQvVOcU
	 blOx0hQarF4m2XFfTkJvmUub20fcb/gKAUXiCaLCKeOwAO2eohaGk//OHe4MWhV4Wh
	 g+DtjmZhOfVm59j+V5x8ToN0Bt0/uHJF8g9COSOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilton Perim Neto <niltonperimneto@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 113/132] Input: xpad - support Acer NGR 200 Controller
Date: Tue,  8 Jul 2025 18:23:44 +0200
Message-ID: <20250708162233.877951609@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

From: Nilton Perim Neto <niltonperimneto@gmail.com>

commit 22c69d786ef8fb789c61ca75492a272774221324 upstream.

Add the NGR 200 Xbox 360 to the list of recognized controllers.

Signed-off-by: Nilton Perim Neto <niltonperimneto@gmail.com>
Link: https://lore.kernel.org/r/20250608060517.14967-1-niltonperimneto@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -174,6 +174,7 @@ static const struct xpad_device {
 	{ 0x05fd, 0x107a, "InterAct 'PowerPad Pro' X-Box pad (Germany)", 0, XTYPE_XBOX },
 	{ 0x05fe, 0x3030, "Chic Controller", 0, XTYPE_XBOX },
 	{ 0x05fe, 0x3031, "Chic Controller", 0, XTYPE_XBOX },
+	{ 0x0502, 0x1305, "Acer NGR200", 0, XTYPE_XBOX },
 	{ 0x062a, 0x0020, "Logic3 Xbox GamePad", 0, XTYPE_XBOX },
 	{ 0x062a, 0x0033, "Competition Pro Steering Wheel", 0, XTYPE_XBOX },
 	{ 0x06a3, 0x0200, "Saitek Racing Wheel", 0, XTYPE_XBOX },
@@ -514,6 +515,7 @@ static const struct usb_device_id xpad_t
 	XPAD_XBOX360_VENDOR(0x045e),		/* Microsoft Xbox 360 controllers */
 	XPAD_XBOXONE_VENDOR(0x045e),		/* Microsoft Xbox One controllers */
 	XPAD_XBOX360_VENDOR(0x046d),		/* Logitech Xbox 360-style controllers */
+	XPAD_XBOX360_VENDOR(0x0502),		/* Acer Inc. Xbox 360 style controllers */
 	XPAD_XBOX360_VENDOR(0x056e),		/* Elecom JC-U3613M */
 	XPAD_XBOX360_VENDOR(0x06a3),		/* Saitek P3600 */
 	XPAD_XBOX360_VENDOR(0x0738),		/* Mad Catz Xbox 360 controllers */


