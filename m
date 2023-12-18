Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F6215AC0;
	Mon, 18 Dec 2023 13:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oG4nzlnX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F93EC433C8;
	Mon, 18 Dec 2023 13:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702907950;
	bh=oRfCFDIRRslQaCF9G7FSdoVLtVL5Q03x8AYqHI+BhwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oG4nzlnX1hoB9x5+dBBSt4Cofvj/HkIf5Qabvh677R0rCGVpVII72BWyKmevhPV2p
	 33xuNr3Yxbp3B6I+wDYBks5o+xp8yGqyQkPieM87I+/zZk2gh0WiIBYEAvY9rfYp7L
	 GvjWMvXh7fE0Y2lpClUDci4OGkuyO/JizcO1Ji9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hayes Wang <hayeswang@realtek.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 106/106] r8152: fix the autosuspend doesnt work
Date: Mon, 18 Dec 2023 14:52:00 +0100
Message-ID: <20231218135059.608478325@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135055.005497074@linuxfoundation.org>
References: <20231218135055.005497074@linuxfoundation.org>
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

From: Hayes Wang <hayeswang@realtek.com>

commit 0fbd79c01a9a657348f7032df70c57a406468c86 upstream.

Set supports_autosuspend = 1 for the rtl8152_cfgselector_driver.

Fixes: ec51fbd1b8a2 ("r8152: add USB device driver for config selection")
Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/r8152.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9940,6 +9940,7 @@ static struct usb_device_driver rtl8152_
 	.probe =	rtl8152_cfgselector_probe,
 	.id_table =	rtl8152_table,
 	.generic_subclass = 1,
+	.supports_autosuspend = 1,
 };
 
 static int __init rtl8152_driver_init(void)


