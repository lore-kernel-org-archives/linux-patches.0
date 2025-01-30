Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D591E3DF8;
	Thu, 30 Jan 2025 14:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245720; cv=none; b=iBLFxUsiAXVq4Q2Eydalg24s3JO7RjBKK7UoSW479QqezjyTUO6Svbq6cdtWv+XLnpnzCRhaCoxBx13MQoDPQPTFQV+Z57U5cjn+PjsGMWRdDZpdkJ1pTdT5KAQh5c6gVHYd0gKPyV41z118VTQ87ETg1/sQXDmQhMFb7dptsIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245720; c=relaxed/simple;
	bh=On8IxywVXAx4BwQzkbH//yux45S3CUBAVvSAV9EEaw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/nuzc0nLXxYDDGNlaig5oZSU7JuDOdNOdLCTrl4BzFOQswGk09kvBih84DMOYRS+aXkSJJeous5l+JIulknBKWUJbkAY9+LVJnbrXJungpOI7CAQqHckhzn2rMH9CklbkhEQ9cOGNSvAScVKGzL1YtloVCI79K5KcZ09bG4POo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hGgLNwWM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hGgLNwWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEBBDC4CED2;
	Thu, 30 Jan 2025 14:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245720;
	bh=On8IxywVXAx4BwQzkbH//yux45S3CUBAVvSAV9EEaw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hGgLNwWMpDu6baq3pTAqO6s8CVaSNRS8nllVnTLRIMybOZ2SX10w77xp+xpFpcfH3
	 HL7pvgtsQW1pqKAoMmubVAaAPWi+Qh8TahVNxT5pRkufcm+LdUfm/igDeIOh+KuPeV
	 j6xyszqXXMJ/fc3M+9X1JBRkcdV9Uu+aqIx8TBT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leonardo Brondani Schenkel <leonardo@schenkel.net>,
	Pavel Rojtberg <rojtberg@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 38/40] Input: xpad - improve name of 8BitDo controller 2dc8:3106
Date: Thu, 30 Jan 2025 14:59:38 +0100
Message-ID: <20250130133501.232381405@linuxfoundation.org>
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

From: Leonardo Brondani Schenkel <leonardo@schenkel.net>

commit 66372fa9936088bf29c4f47907efeff03c51a2c8 upstream.

8BitDo Pro 2 Wired Controller shares the same USB identifier
(2dc8:3106) as a different device, so amend name to reflect that and
reduce confusion as the user might think the controller was misdetected.

Because Pro 2 Wired will not work in XTYPE_XBOXONE mode (button presses
won't register), tagging it as XTYPE_XBOX360 remains appropriate.

Signed-off-by: Leonardo Brondani Schenkel <leonardo@schenkel.net>
Signed-off-by: Pavel Rojtberg <rojtberg@gmail.com>
Link: https://lore.kernel.org/r/20250107192830.414709-2-rojtberg@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -375,7 +375,7 @@ static const struct xpad_device {
 	{ 0x294b, 0x3303, "Snakebyte GAMEPAD BASE X", 0, XTYPE_XBOXONE },
 	{ 0x294b, 0x3404, "Snakebyte GAMEPAD RGB X", 0, XTYPE_XBOXONE },
 	{ 0x2dc8, 0x2000, "8BitDo Pro 2 Wired Controller fox Xbox", 0, XTYPE_XBOXONE },
-	{ 0x2dc8, 0x3106, "8BitDo Pro 2 Wired Controller", 0, XTYPE_XBOX360 },
+	{ 0x2dc8, 0x3106, "8BitDo Ultimate Wireless / Pro 2 Wired Controller", 0, XTYPE_XBOX360 },
 	{ 0x2dc8, 0x310a, "8BitDo Ultimate 2C Wireless Controller", 0, XTYPE_XBOX360 },
 	{ 0x2e24, 0x0652, "Hyperkin Duke X-Box One pad", 0, XTYPE_XBOXONE },
 	{ 0x31e3, 0x1100, "Wooting One", 0, XTYPE_XBOX360 },


