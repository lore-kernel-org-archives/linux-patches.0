Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA561DE8B2;
	Thu, 30 Jan 2025 13:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245600; cv=none; b=BDR8smEXEkkDkESpHDutztytnD7kycvijfQY7+qAOS5rvseeuPAjcsBDFzJjfQXwMsyouuutIkQppSvD4gotUcUwu2qCOM/b405Vsb8e/81nWaqa3bNmkMg7Gs1jW0WNxAsgrQQU/PLDHMh6edjoZXAAEG+QlUTJBKo4P5VI8JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245600; c=relaxed/simple;
	bh=dyGQu6fRxHevsEfx+60LUozqHyl2SwUZTJwU+lx+Vss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9GE8J96J+9YLTp0LFr5pv06+wvgl/aTdSwCLWPPzkFkMdomV6SybDR+nEq9/6LCV5Th9A/05iJ4hVIP+eFWCkKOLe+JpevwbNHGQF1NXOa4/GNe2OpgWWz96WZOG351QyMpta2y//yaJr8fGiG2gdo3723F+mOchPXkhwk6OBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AuBRFMsu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AuBRFMsu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739CCC4CED2;
	Thu, 30 Jan 2025 13:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245599;
	bh=dyGQu6fRxHevsEfx+60LUozqHyl2SwUZTJwU+lx+Vss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AuBRFMsupWTXO3i1bixXTYusSc3Vzho/la+dv8eZrj6fhSqttasnPH5lGe5IVWzkg
	 x8Usfg4Fr+/iq2byiGUN6ZucPzleKmQp4GSjBcWcA8bR7QSpFOZkH5y9V4WP1SPB0j
	 kKLt/7AVEAVBohmMXKtO/mpGyLu95AQIBP0/tuN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilton Perim Neto <niltonperimneto@gmail.com>,
	Pavel Rojtberg <rojtberg@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.13 21/25] Input: xpad - add unofficial Xbox 360 wireless receiver clone
Date: Thu, 30 Jan 2025 14:59:07 +0100
Message-ID: <20250130133457.788487095@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133456.914329400@linuxfoundation.org>
References: <20250130133456.914329400@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilton Perim Neto <niltonperimneto@gmail.com>

commit e4940fe6322c851659c17852b671c6e7b1aa9f56 upstream.

Although it mimics the Microsoft's VendorID, it is in fact a clone.
Taking into account that the original Microsoft Receiver is not being
manufactured anymore, this drive can solve dpad issues encontered by
those who still use the original 360 Wireless controller
but are using a receiver clone.

Signed-off-by: Nilton Perim Neto <niltonperimneto@gmail.com>
Signed-off-by: Pavel Rojtberg <rojtberg@gmail.com>
Link: https://lore.kernel.org/r/20250107192830.414709-12-rojtberg@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -150,6 +150,7 @@ static const struct xpad_device {
 	{ 0x045e, 0x028e, "Microsoft X-Box 360 pad", 0, XTYPE_XBOX360 },
 	{ 0x045e, 0x028f, "Microsoft X-Box 360 pad v2", 0, XTYPE_XBOX360 },
 	{ 0x045e, 0x0291, "Xbox 360 Wireless Receiver (XBOX)", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360W },
+	{ 0x045e, 0x02a9, "Xbox 360 Wireless Receiver (Unofficial)", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360W },
 	{ 0x045e, 0x02d1, "Microsoft X-Box One pad", 0, XTYPE_XBOXONE },
 	{ 0x045e, 0x02dd, "Microsoft X-Box One pad (Firmware 2015)", 0, XTYPE_XBOXONE },
 	{ 0x045e, 0x02e3, "Microsoft X-Box One Elite pad", MAP_PADDLES, XTYPE_XBOXONE },


