Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132F415BD;
	Sat, 13 Jan 2024 09:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOKlzOmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DBABC43390;
	Sat, 13 Jan 2024 09:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705139653;
	bh=6tN77h4b+HtaItHfoFJiOnpRyJvjXBAePXtoe4cYkXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOKlzOmRNvxYb66gMg4mknQnuB4nZtCqC48JcdKEcyya+HU+SDQv070dpE2y5gGsn
	 6Bob4g/zsI0wEE9ik/auDS8iBpsy8KBf+ogGDtIg22YZ1Kemvi7Baur2YuZRTtRAP2
	 RyupKvlhuKXPMHvhEt2+9U8xNJRn/maGp89TyM78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 11/25] asix: Add check for usbnet_get_endpoints
Date: Sat, 13 Jan 2024 10:49:52 +0100
Message-ID: <20240113094205.391066193@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094205.025407355@linuxfoundation.org>
References: <20240113094205.025407355@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 909755ef71ac3..5881620e44365 100644
--- a/drivers/net/usb/ax88172a.c
+++ b/drivers/net/usb/ax88172a.c
@@ -198,7 +198,9 @@ static int ax88172a_bind(struct usbnet *dev, struct usb_interface *intf)
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



