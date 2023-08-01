Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC8E1F953
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580D9C433C7;
	Tue,  1 Aug 2023 09:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882121;
	bh=dojzx6+dVLfN4SetVQZcuZCSyACd+cAAYBbf8HQMuwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RjvKXDAye91JTg4iRxnTksXKVB9vDZJn2Wh2XIbtEKphAEGWwAyb02Mozu6+coTgG
	 0Jk0Uvv2ZqoqBkY7I3uhzpHjTNzyykFmIcuVOrL3ddND/H51VVn1eWLONQs0UGUdD3
	 tjoGWNQcTH9qFF8S/XCiSDuu2y+C3E+qGhvmLG3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Zubin Mithra <zsm@chromium.org>,
	Ricardo Ribalda <ribalda@chromium.org>
Subject: [PATCH 5.15 120/155] usb: xhci-mtk: set the dma max_seg_size
Date: Tue,  1 Aug 2023 11:20:32 +0200
Message-ID: <20230801091914.498263714@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
References: <20230801091910.165050260@linuxfoundation.org>
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
@@ -570,6 +570,7 @@ static int xhci_mtk_probe(struct platfor
 	}
 
 	device_init_wakeup(dev, true);
+	dma_set_max_seg_size(dev, UINT_MAX);
 
 	xhci = hcd_to_xhci(hcd);
 	xhci->main_hcd = hcd;


