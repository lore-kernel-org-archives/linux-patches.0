Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A349D507
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:58:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFA1C433D2;
	Mon, 15 May 2023 17:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173509;
	bh=F0D29cH+R5sLsaxDjg/0W1w+R8wbJpNL23Fn3mRPq0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHPzOfbIPwEdgQRw26y0DHf2lg0Fd29NyFYu1UkHqlVNKOkcYehPZJw4HeLUml50K
	 jdLUI0mFgxm7qjj6p9dYVb5Lu+Fw3eeLfyJrRLNdl2Vc7+uOj0L5o3JsVGOTIH2voH
	 SLzg7xdrDB4g8WkcciSAOfyXKK4nYk/T8THMHhbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 118/282] usb: host: xhci-rcar: remove leftover quirk handling
Date: Mon, 15 May 2023 18:28:16 +0200
Message-Id: <20230515161725.775408125@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 5d67f4861884762ebc2bddb5d667444e45f25782 ]

Loading V3 firmware does not need a quirk anymore, remove the leftover
code.

Fixes: ed8603e11124 ("usb: host: xhci-rcar: Simplify getting the firmware name for R-Car Gen3")
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://lore.kernel.org/r/20230307163041.3815-10-wsa+renesas@sang-engineering.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-rcar.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/usb/host/xhci-rcar.c b/drivers/usb/host/xhci-rcar.c
index 3da75b367f952..5d78352992454 100644
--- a/drivers/usb/host/xhci-rcar.c
+++ b/drivers/usb/host/xhci-rcar.c
@@ -74,7 +74,6 @@ MODULE_FIRMWARE(XHCI_RCAR_FIRMWARE_NAME_V3);
 
 /* For soc_device_attribute */
 #define RCAR_XHCI_FIRMWARE_V2   BIT(0) /* FIRMWARE V2 */
-#define RCAR_XHCI_FIRMWARE_V3   BIT(1) /* FIRMWARE V3 */
 
 static const struct soc_device_attribute rcar_quirks_match[]  = {
 	{
@@ -147,8 +146,6 @@ static int xhci_rcar_download_firmware(struct usb_hcd *hcd)
 
 	if (quirks & RCAR_XHCI_FIRMWARE_V2)
 		firmware_name = XHCI_RCAR_FIRMWARE_NAME_V2;
-	else if (quirks & RCAR_XHCI_FIRMWARE_V3)
-		firmware_name = XHCI_RCAR_FIRMWARE_NAME_V3;
 	else
 		firmware_name = priv->firmware_name;
 
-- 
2.39.2



