Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA2C1E47C4;
	Thu, 30 Jan 2025 14:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245726; cv=none; b=N4ty0BpvO862rGL1dEI9RKNVQp40AW6CWLWqusfvzi+AltKUAFftZjCh5yR9X6ehnYTWBtm/Ls9/Vjjelzk0IxeI/zFNjyRf4Xj3NOXHvFa3IPoLpwbBCO8amK5s0Vq8c4g+MFO3WX3z+/A4wuJWvnXdwn0fdvwSfPgDRP+ZmAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245726; c=relaxed/simple;
	bh=6rXS5hRHzdgkhVaaoTDvky54xvKw/D9Ar6S2PKSpF7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p2s9X/U2+lDsCVLkhcTfjwYSYey2q4KIyMN1iVmoJZjPjMvSEp/HkrGjP58gw/7Y4V4jQ6LdGqve7PSTUuBb+huVhffrXGC0cCbhoCuxs1fgemA0e16Zk2yEGkBjovPUy/Sp3IZ84QyEsQBtB9ssRYjrzwfBSnKhjYUBnQRA0/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H7Y65ZeZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H7Y65ZeZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A894C4CED2;
	Thu, 30 Jan 2025 14:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245725;
	bh=6rXS5hRHzdgkhVaaoTDvky54xvKw/D9Ar6S2PKSpF7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H7Y65ZeZpHbr1lKeRyPuLBp315Jdx678mmghBTETZuGyhEMoolxKYHo7IFISm2U7x
	 KEYKB1DYZM2mRfS+YDgZY2Rbxf4xPPKFpGyR2ZyfnogUsHFCaonFEmckOl+34OVqLC
	 W5ix1gfT5DMy6FUU6PmrhuZrQ7vvcTr53ZKedoKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Greiner <jack@emoss.org>,
	Pavel Rojtberg <rojtberg@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 40/40] Input: xpad - add support for wooting two he (arm)
Date: Thu, 30 Jan 2025 14:59:40 +0100
Message-ID: <20250130133501.313475053@linuxfoundation.org>
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
@@ -382,6 +382,7 @@ static const struct xpad_device {
 	{ 0x31e3, 0x1200, "Wooting Two", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1210, "Wooting Lekker", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1220, "Wooting Two HE", 0, XTYPE_XBOX360 },
+	{ 0x31e3, 0x1230, "Wooting Two HE (ARM)", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1300, "Wooting 60HE (AVR)", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1310, "Wooting 60HE (ARM)", 0, XTYPE_XBOX360 },
 	{ 0x3285, 0x0607, "Nacon GC-100", 0, XTYPE_XBOX360 },


