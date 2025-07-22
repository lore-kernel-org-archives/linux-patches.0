Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9192E36E8;
	Tue, 22 Jul 2025 13:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192648; cv=none; b=OIdV6aroUGyjwSyWM0Lq1uVoHYZswW7COm5uWjLBkwyG1wGGY6gW/j/bL4VNz/L20GZMnF2iNkmlSR/sX/qDpXRUcG0FHxz0YZleXojmMvQYfd3dynJ619I3hACgSXDxlTqKe145mPx0c4hgymQB8p5plCe4WzNgti4VPFYYMFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192648; c=relaxed/simple;
	bh=1jfcH3mxA2OlURl0O/DKnn699VEB7gFoRitgLGJ0CRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uAZhb0iVyywgI1Ma6Kro1SiFIQklcLG+UVyfKp+qEBkCmKMv69fyELSga9u1PnaUxhhmr1ivCEdGlreJzv8Nl4GRnReCKNlAcVc0x20eXuNB1s6haapkiyl8KTMBn7EZ275XwbzLs6F46776Qm/RilqQMestMBKjvi/03wFortg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IzDw96Pq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IzDw96Pq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BC7C4CEEB;
	Tue, 22 Jul 2025 13:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192648;
	bh=1jfcH3mxA2OlURl0O/DKnn699VEB7gFoRitgLGJ0CRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IzDw96PqlJMSjUEIedmh6IBPI7SiXc0PZ2MMsvh0gl9HWG9OLMHlmgpYKvrXVBGWT
	 b3B4iziChrVF2/wnmTOdYzVFaqpogO7ykHndGnEM5Y0NMfCA2qfJVMqhLSmwMGcVvI
	 1Px7kQ27px9PyTTRZn21rGcXWBgxwP8yJL90REWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Nilton Perim Neto <niltonperimneto@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 017/158] Input: xpad - set correct controller type for Acer NGR200
Date: Tue, 22 Jul 2025 15:43:21 +0200
Message-ID: <20250722134341.372917470@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

From: Nilton Perim Neto <niltonperimneto@gmail.com>

commit bcce05041b21888f10b80ea903dcfe51a25c586e upstream.

The controller should have been set as XTYPE_XBOX360 and not XTYPE_XBOX.
Also the entry is in the wrong place. Fix it.

Reported-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Nilton Perim Neto <niltonperimneto@gmail.com>
Link: https://lore.kernel.org/r/20250708033126.26216-2-niltonperimneto@gmail.com
Fixes: 22c69d786ef8 ("Input: xpad - support Acer NGR 200 Controller")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -169,12 +169,12 @@ static const struct xpad_device {
 	{ 0x046d, 0xca88, "Logitech Compact Controller for Xbox", 0, XTYPE_XBOX },
 	{ 0x046d, 0xca8a, "Logitech Precision Vibration Feedback Wheel", 0, XTYPE_XBOX },
 	{ 0x046d, 0xcaa3, "Logitech DriveFx Racing Wheel", 0, XTYPE_XBOX360 },
+	{ 0x0502, 0x1305, "Acer NGR200", 0, XTYPE_XBOX360 },
 	{ 0x056e, 0x2004, "Elecom JC-U3613M", 0, XTYPE_XBOX360 },
 	{ 0x05fd, 0x1007, "Mad Catz Controller (unverified)", 0, XTYPE_XBOX },
 	{ 0x05fd, 0x107a, "InterAct 'PowerPad Pro' X-Box pad (Germany)", 0, XTYPE_XBOX },
 	{ 0x05fe, 0x3030, "Chic Controller", 0, XTYPE_XBOX },
 	{ 0x05fe, 0x3031, "Chic Controller", 0, XTYPE_XBOX },
-	{ 0x0502, 0x1305, "Acer NGR200", 0, XTYPE_XBOX },
 	{ 0x062a, 0x0020, "Logic3 Xbox GamePad", 0, XTYPE_XBOX },
 	{ 0x062a, 0x0033, "Competition Pro Steering Wheel", 0, XTYPE_XBOX },
 	{ 0x06a3, 0x0200, "Saitek Racing Wheel", 0, XTYPE_XBOX },


