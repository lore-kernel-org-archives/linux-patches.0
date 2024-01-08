Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4396D6DC;
	Mon,  8 Jan 2024 15:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3lVlXIp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32708C43391;
	Mon,  8 Jan 2024 15:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726819;
	bh=xu1cSC75a8Wf/pF8I4z1KIUTLMTa+I9DPfaKsjpE3KM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M3lVlXIpRvUiWJ0LHJ+Qve+FAxSbmr2+XvElUez5o7VZs/3f6U76qCzvnCSEG/JNA
	 k9u9D3kalpU9y1k4D8gTH6SGIS/Gv1rIvt5IS+r1PyMYzbxN8N/yPSo1aW5u77D67s
	 wAguRLP0uqnmaCknDUQfmGYhANrQOEx9bmIWpb7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/124] asix: Add check for usbnet_get_endpoints
Date: Mon,  8 Jan 2024 16:08:05 +0100
Message-ID: <20240108150605.673748735@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3777c7e2e6fc0..e47bb125048d4 100644
--- a/drivers/net/usb/ax88172a.c
+++ b/drivers/net/usb/ax88172a.c
@@ -161,7 +161,9 @@ static int ax88172a_bind(struct usbnet *dev, struct usb_interface *intf)
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



