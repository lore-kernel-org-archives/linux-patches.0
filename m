Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4400F2C9A;
	Tue, 22 Jul 2025 14:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193198; cv=none; b=D6E0VxDO1Z/z7esz0Fp9PwHq+Q9vfdH77SQPxT4owlO2iG2gHMwLDm2sj7g+4WljDhNcjwth/+EeP04QUN9p4xEIveuLVmUgs2E/WNtAn4T16UjmftGxXEm7gvYNv2H2FTUC7FlsKmYQNhDkBDFthNUFKpZQBWmyzjMRpa/M7fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193198; c=relaxed/simple;
	bh=0PCrTE+xIX3q1UZ2Fhlv8ir6BD8HjZxm4LFZUn6mmhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2l5yEB4jZI30mqNL7W178GFAt2HeL100fY7CXVlVXorgxzWuPQkjTarHVGNJxnLuyRtZ9P2Zu+fTpeDlKkpBauV4Yp0icO4tHWc8dbxeRGdoFd+4jpmXTpFHAFd/fMueO3IZDdL/5jVtH3XjdN7E+EdX47FO+tXE+0pkOb2U/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nwxu3a5T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nwxu3a5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF826C4CEF1;
	Tue, 22 Jul 2025 14:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193198;
	bh=0PCrTE+xIX3q1UZ2Fhlv8ir6BD8HjZxm4LFZUn6mmhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nwxu3a5TfyPBGCHglfXqH2HVkLhsZq+F57qABDuJyr9KSbCvj1j7gsMOBbZ4f2njO
	 YZvCXbR5wkUpnfm4fv4+wutfPeadQQ53hOmR6dShv0yVF225jgJpX0vVvSm8Vf66mx
	 yhx+HFB7DK4o+89SscNN9O/nhPHHPkq++t6jkitA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Nilton Perim Neto <niltonperimneto@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.15 020/187] Input: xpad - set correct controller type for Acer NGR200
Date: Tue, 22 Jul 2025 15:43:10 +0200
Message-ID: <20250722134346.505690720@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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


