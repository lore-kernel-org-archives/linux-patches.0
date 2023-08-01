Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCE51FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:47:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E880C433C8;
	Tue,  1 Aug 2023 09:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883248;
	bh=kxfpY6qDGIo4B7YcmvoMoD87rCQNclqR231SwAZFGLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SE4wC1O8w8lPHCxlaSAPrUt9NGkmnBSsdt6buwUPhe9LRt/0D5uPgdJ1a4yiKubzf
	 J4NupTXJHo8U1cAWyV2ocIfgnkHD+U3rFITGHqMddFVccJ8cRereqZK3vd15zpM/sa
	 AbVfsFOs8vXnQfqEzfOXjNdHMlFB3HbqdUyDdJv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Zubin Mithra <zsm@chromium.org>,
	Ricardo Ribalda <ribalda@chromium.org>
Subject: [PATCH 6.4 169/239] usb: xhci-mtk: set the dma max_seg_size
Date: Tue,  1 Aug 2023 11:20:33 +0200
Message-ID: <20230801091931.733646688@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ricardo Ribalda <ribalda@chromium.org>

commit 9fd10829a9eb482e192a845675ecc5480e0bfa10 upstream.

Allow devices to have dma operations beyond 64K, and avoid warnings such
as:

DMA-API: xhci-mtk 11200000.usb: mapping sg segment longer than device claims to support [len=98304] [max=65536]

Fixes: 0cbd4b34cda9 ("xhci: mediatek: support MTK xHCI host controller")
Cc: stable <stable@kernel.org>
Tested-by: Zubin Mithra <zsm@chromium.org>
Reported-by: Zubin Mithra <zsm@chromium.org>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Link: https://lore.kernel.org/r/20230628-mtk-usb-v2-1-c8c34eb9f229@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mtk.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/xhci-mtk.c
+++ b/drivers/usb/host/xhci-mtk.c
@@ -592,6 +592,7 @@ static int xhci_mtk_probe(struct platfor
 	}
 
 	device_init_wakeup(dev, true);
+	dma_set_max_seg_size(dev, UINT_MAX);
 
 	xhci = hcd_to_xhci(hcd);
 	xhci->main_hcd = hcd;


