Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454651FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:17:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82D3C433EF;
	Fri,  3 Feb 2023 10:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419442;
	bh=lHqXY8BP9PluxY4FmrLgcaVVPxYBjoSn6ptrU+YrONU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rn81KPHGzRmfvAqw1MQG2DTb7WEDjrNdi99YNsvFftFxrJ2Ehy8Gir6Y7Z5oT5t8d
	 FBFadtVLzpMuQv/Ho572O+Umb4ha5CumsE6sBu93Eu33Tp5suiazRrqovMPoghYRr2
	 dI40Y82BGjB6BpHCh7I6AxM0Ajs82rMjL4ygbhSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Kaehlcke <mka@chromium.org>,
	Peter Chen <peter.chen@nxp.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 4.14 62/62] usb: host: xhci-plat: add wakeup entry at sysfs
Date: Fri,  3 Feb 2023 11:12:58 +0100
Message-Id: <20230203101015.639554272@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101012.959398849@linuxfoundation.org>
References: <20230203101012.959398849@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Chen <peter.chen@nxp.com>

commit 4bb4fc0dbfa23acab9b762949b91ffd52106fe4b upstream.

With this change, there will be a wakeup entry at /sys/../power/wakeup,
and the user could use this entry to choose whether enable xhci wakeup
features (wake up system from suspend) or not.

Tested-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200918131752.16488-6-mathias.nyman@linux.intel.com
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-plat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -252,7 +252,7 @@ static int xhci_plat_probe(struct platfo
 			*priv = *priv_match;
 	}
 
-	device_wakeup_enable(hcd->self.controller);
+	device_set_wakeup_capable(&pdev->dev, true);
 
 	xhci->clk = clk;
 	xhci->main_hcd = hcd;


