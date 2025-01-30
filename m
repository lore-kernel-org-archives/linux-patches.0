Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918D7383;
	Thu, 30 Jan 2025 14:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246589; cv=none; b=Mm4Y+vDLq8LJfeYQuMUr/s9VKUa21UCrCGtSxyIAhzBOTGSF8q3xIehHeZ4KRx2t1rsqP96uPPkYikRe5a0vclA1d+YD9GDPYTqFYJwiCUIsZPjET45QT3ycuu6V0sv+h8VP56Hfa+7OOX4t9seqwXuj5GRAKP07STS7dPTN0wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246589; c=relaxed/simple;
	bh=rOw6j/txI+s4P+1OdVV8okKMxQaOQF3Oq2bk/zIPEf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VwC7otwj7+T7CoYVQN+Y02WfaCtJ+Z9Ik4jNQgqNFvlf2ztM4ULIzfkrnbauiE90Ip+n8drfa2X+VNuz/8bLeWpnFK2xRJQGW74DjLE6KsRBJ4iz18j/2/IqLmkokTUPoEZ3/oSdtFKSpIec/S92CPg/OQBKw4DrqNgSGa4G8HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ccOjpuNw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ccOjpuNw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20680C4CED2;
	Thu, 30 Jan 2025 14:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246589;
	bh=rOw6j/txI+s4P+1OdVV8okKMxQaOQF3Oq2bk/zIPEf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ccOjpuNwYqKK4jxjUd1nG/uhUst2CItpP2tx6GhwLIWgJFOYzeZImbwomOd5fhFx4
	 ZAEUdjfDhxkCTxQIlyL6uU16oONw6KkcwY/yh2sSOIC5yT97XgjnDD/UmUXHMGtvTi
	 +K18t/10EHKdR3XYbeIi9L/dpAaa2Ln9yHQ90MnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Greiner <jack@emoss.org>,
	Pavel Rojtberg <rojtberg@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 43/43] Input: xpad - add support for wooting two he (arm)
Date: Thu, 30 Jan 2025 14:59:50 +0100
Message-ID: <20250130133500.624992998@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133458.903274626@linuxfoundation.org>
References: <20250130133458.903274626@linuxfoundation.org>
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

From: Jack Greiner <jack@emoss.org>

commit 222f3390c15c4452a9f7e26f5b7d9138e75d00d5 upstream.

Add Wooting Two HE (ARM) to the list of supported devices.

Signed-off-by: Jack Greiner <jack@emoss.org>
Signed-off-by: Pavel Rojtberg <rojtberg@gmail.com>
Link: https://lore.kernel.org/r/20250107192830.414709-3-rojtberg@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -381,6 +381,7 @@ static const struct xpad_device {
 	{ 0x31e3, 0x1200, "Wooting Two", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1210, "Wooting Lekker", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1220, "Wooting Two HE", 0, XTYPE_XBOX360 },
+	{ 0x31e3, 0x1230, "Wooting Two HE (ARM)", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1300, "Wooting 60HE (AVR)", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1310, "Wooting 60HE (ARM)", 0, XTYPE_XBOX360 },
 	{ 0x3285, 0x0607, "Nacon GC-100", 0, XTYPE_XBOX360 },


