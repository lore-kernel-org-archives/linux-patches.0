Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A952C1848;
	Sat, 13 Jan 2024 09:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HV7itgxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27599C433C7;
	Sat, 13 Jan 2024 09:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705139885;
	bh=UbRLosD9JvY82v7lJQ8zGrQ6Zc8Xe4nDVkc6wmdcGp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HV7itgxgQOdiI9hzG3eZd5ekEBtFVVa/kUtLuAJuTDJhl/h5aNPII9MfooYbBTETv
	 WpGmKkmLp/bbeZAbB6RGqhk+qHelo6RCjIgMvwIz0xSlFTZSOWkUr2+aLXI+1hYL97
	 Y2Frr2g+syNkRHbW/nJ3qHfaEZ0LRQ239aLtvuvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 24/43] asix: Add check for usbnet_get_endpoints
Date: Sat, 13 Jan 2024 10:50:03 +0100
Message-ID: <20240113094207.686172598@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094206.930684111@linuxfoundation.org>
References: <20240113094206.930684111@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit eaac6a2d26b65511e164772bec6918fcbc61938e ]

Add check for usbnet_get_endpoints() and return the error if it fails
in order to transfer the error.

Fixes: 16626b0cc3d5 ("asix: Add a new driver for the AX88172A")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/ax88172a.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/ax88172a.c b/drivers/net/usb/ax88172a.c
index fd3a04d98dc14..2bdb163e458ad 100644
--- a/drivers/net/usb/ax88172a.c
+++ b/drivers/net/usb/ax88172a.c
@@ -175,7 +175,9 @@ static int ax88172a_bind(struct usbnet *dev, struct usb_interface *intf)
 	u8 buf[ETH_ALEN];
 	struct ax88172a_private *priv;
 
-	usbnet_get_endpoints(dev, intf);
+	ret = usbnet_get_endpoints(dev, intf);
+	if (ret)
+		return ret;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
-- 
2.43.0



