Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189301C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D997C433D2;
	Wed, 28 Dec 2022 16:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246219;
	bh=mpxhm3WwiWR1yI6Z7dfSSCK3d/XpiW+WSTrFtijRPgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cXeyCxOrQM2O0XmlQ+a9GhIHFye2SMrV0FEpwasCU9KWERREvQ5nJGK9973dM6OJi
	 qXlRG/VOWc2cNFSijX1dAlhZiMWkdyqDrWBEo8iu0rQy6Kj70uSfeJZ3D7UU7+9Xle
	 w9+/K82OC/MH1sXrU/EY0vh9v/FakAQYem5EIZkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 6.0 1033/1073] usb: xhci-mtk: fix leakage of shared hcd when fail to set wakeup irq
Date: Wed, 28 Dec 2022 15:43:41 +0100
Message-Id: <20221228144356.250740190@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

commit 03a88b0bafbe3f548729d970d8366f48718c9b19 upstream.

Can not set the @shared_hcd to NULL before decrease the usage count
by usb_put_hcd(), this will cause the shared hcd not released.

Fixes: 04284eb74e0c ("usb: xhci-mtk: add support runtime PM")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/20221128063337.18124-1-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mtk.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/host/xhci-mtk.c
+++ b/drivers/usb/host/xhci-mtk.c
@@ -639,7 +639,6 @@ static int xhci_mtk_probe(struct platfor
 
 dealloc_usb3_hcd:
 	usb_remove_hcd(xhci->shared_hcd);
-	xhci->shared_hcd = NULL;
 
 dealloc_usb2_hcd:
 	usb_remove_hcd(hcd);


