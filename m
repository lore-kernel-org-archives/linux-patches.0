Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEE11A70A
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 09:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YtNW1yQK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52509C433C8;
	Mon, 16 Oct 2023 09:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446825;
	bh=he7WCbd9Nz1X2aXkbp/iy3seowpJcnbXFOqHUOTLj8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YtNW1yQK+kb01gA6YFPcCu5Py+uRPUYca6cVMzFgLlnS5ip8b4CWZM8amRX0QuKVu
	 FYskLBi8rsV88ftx4t+lKByxu7fyw27MkJq8XVVQdv2GDNjs4h5OGzfGzpVzNUMT22
	 QRCYjOP6ibvRWg3PaRgtlkgJc7KoZeVkl1iPYcls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingxing Luo <xingxing.luo@unisoc.com>
Subject: [PATCH 6.1 079/131] usb: musb: Modify the "HWVers" register address
Date: Mon, 16 Oct 2023 10:41:02 +0200
Message-ID: <20231016084002.021772351@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
References: <20231016084000.050926073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xingxing Luo <xingxing.luo@unisoc.com>

commit 6658a62e1ddf726483cb2d8bf45ea3f9bd533074 upstream.

musb HWVers rgister address is not 0x69, if we operate the
wrong address 0x69, it will cause a kernel crash, because
there is no register corresponding to this address in the
additional control register of musb. In fact, HWVers has
been defined in musb_register.h, and the name is
"MUSB_HWVERS", so We need to use this macro instead of 0x69.

Fixes: c2365ce5d5a0 ("usb: musb: replace hard coded registers with defines")
Cc: stable@vger.kernel.org
Signed-off-by: Xingxing Luo <xingxing.luo@unisoc.com>
Link: https://lore.kernel.org/r/20230922075929.31074-1-xingxing.luo@unisoc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/musb_debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/musb/musb_debugfs.c
+++ b/drivers/usb/musb/musb_debugfs.c
@@ -39,7 +39,7 @@ static const struct musb_register_map mu
 	{ "IntrUsbE",	MUSB_INTRUSBE,	8 },
 	{ "DevCtl",	MUSB_DEVCTL,	8 },
 	{ "VControl",	0x68,		32 },
-	{ "HWVers",	0x69,		16 },
+	{ "HWVers",	MUSB_HWVERS,	16 },
 	{ "LinkInfo",	MUSB_LINKINFO,	8 },
 	{ "VPLen",	MUSB_VPLEN,	8 },
 	{ "HS_EOF1",	MUSB_HS_EOF1,	8 },


