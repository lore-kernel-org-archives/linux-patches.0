Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE44F3222
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:52:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D03C433D2;
	Mon, 13 Feb 2023 14:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676299937;
	bh=W/KkIFTsSoUuaAV758FiC3EJgPmgOjNN6EP6O9Ev/+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oKARSBQsfYDSKY4QUcPW0dxAeKYXFbGtrtDbxfPiTTrdTE9i/AxIF1UYNBWtHl7Nf
	 kbrdONaXw8szphr6rj51eapMh6WoCvR3zEQsLxkNlGSUegJ+8//eObD7+IeU3QVSHR
	 cCIENPtm+PSJk7++td5jPwOTLB2Fbh+GQIsSfmSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Michael Kelley <mikelley@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 001/114] hv_netvsc: Allocate memory in netvsc_dma_map() with GFP_ATOMIC
Date: Mon, 13 Feb 2023 15:47:16 +0100
Message-Id: <20230213144742.284618491@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Kelley <mikelley@microsoft.com>

commit c6aa9d3b43cd11ac13a8220368a3b0483c6751d4 upstream.

Memory allocations in the network transmit path must use GFP_ATOMIC
so they won't sleep.

Reported-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/lkml/8a4d08f94d3e6fe8b6da68440eaa89a088ad84f9.camel@redhat.com/
Fixes: 846da38de0e8 ("net: netvsc: Add Isolation VM support for netvsc driver")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/1675714317-48577-1-git-send-email-mikelley@microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/hyperv/netvsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index e02d1e3ef672..79f4e13620a4 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -1034,7 +1034,7 @@ static int netvsc_dma_map(struct hv_device *hv_dev,
 
 	packet->dma_range = kcalloc(page_count,
 				    sizeof(*packet->dma_range),
-				    GFP_KERNEL);
+				    GFP_ATOMIC);
 	if (!packet->dma_range)
 		return -ENOMEM;
 
-- 
2.39.1



