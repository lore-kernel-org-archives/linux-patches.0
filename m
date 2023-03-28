Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9FA8BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:10:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61781C433EF;
	Tue, 28 Mar 2023 15:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680016235;
	bh=SZD2Uqk7lzpzQejhqNU3qpNtjO2T4UECxmKjCx03kz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KcXpfZvd5xM7bfNAT10KnYaea3fCDQrY1Lzubqo7vwaceXuKFZC2DiC8Yx21kXmri
	 pPFEtKtt90xKcMdDzIdZsoA1NWlEYVv7KLJSzqHJ/5YYeiLfiFwEcd2+bc7oDdHSKV
	 5IO9v4/cugf2QJdaQQAieUPYXydRY4M2HjT08aII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enrico Sau <enrico.sau@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/146] net: usb: cdc_mbim: avoid altsetting toggling for Telit FE990
Date: Tue, 28 Mar 2023 16:43:06 +0200
Message-Id: <20230328142606.741992033@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Enrico Sau <enrico.sau@gmail.com>

[ Upstream commit 418383e6ed6b4624a54ec05c535f13d184fbf33b ]

Add quirk CDC_MBIM_FLAG_AVOID_ALTSETTING_TOGGLE for Telit FE990
0x1081 composition in order to avoid bind error.

Signed-off-by: Enrico Sau <enrico.sau@gmail.com>
Link: https://lore.kernel.org/r/20230306115933.198259-1-enrico.sau@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cdc_mbim.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/cdc_mbim.c b/drivers/net/usb/cdc_mbim.c
index c0b8b4aa78f37..a3ccf0cee093c 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -664,6 +664,11 @@ static const struct usb_device_id mbim_devs[] = {
 	  .driver_info = (unsigned long)&cdc_mbim_info_avoid_altsetting_toggle,
 	},
 
+	/* Telit FE990 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x1bc7, 0x1081, USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
+	  .driver_info = (unsigned long)&cdc_mbim_info_avoid_altsetting_toggle,
+	},
+
 	/* default entry */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
 	  .driver_info = (unsigned long)&cdc_mbim_info_zlp,
-- 
2.39.2



