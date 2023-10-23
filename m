Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA2914A81
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ro0Mrc7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC815C433C8;
	Mon, 23 Oct 2023 11:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059121;
	bh=vz7sWriVUYyP2TIxIyaIGlvSI7s9Eq/Q4Dp2ZRD0vWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ro0Mrc7Cxpm6nGjriWb1rzyVUZASLdt3ds1v0sVKRGGtpNkU2O543c17P29NCP7+S
	 WG5btmzHPolDObHmADhztogwZhzHQtFdsM27LMy5JRuB7qrdhjT47QY/1fb0x2GczF
	 9cGW3tTkvvWS0Q5Zxg1qgPonasE5GxatBJB7LWGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.5 071/241] net: usb: smsc95xx: Fix an error code in smsc95xx_reset()
Date: Mon, 23 Oct 2023 12:54:17 +0200
Message-ID: <20231023104835.626544347@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit c53647a5df9e66dd9fedf240198e1fe50d88c286 upstream.

Return a negative error code instead of success.

Fixes: 2f7ca802bdae ("net: Add SMSC LAN9500 USB2.0 10/100 ethernet adapter driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/147927f0-9ada-45cc-81ff-75a19dd30b76@moroto.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/smsc95xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -897,7 +897,7 @@ static int smsc95xx_reset(struct usbnet
 
 	if (timeout >= 100) {
 		netdev_warn(dev->net, "timeout waiting for completion of Lite Reset\n");
-		return ret;
+		return -ETIMEDOUT;
 	}
 
 	ret = smsc95xx_set_mac_address(dev);


