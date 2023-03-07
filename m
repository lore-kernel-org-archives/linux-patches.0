Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4746BA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:36:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F925C433EF;
	Tue,  7 Mar 2023 17:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210576;
	bh=ydGuym6RW3WZLSqSRqt3EtLsYeZwA9ltFogTz021gRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c0aOZxpvAzNHqkbYo2A5Odcmp5ygJV0A9RTIgE5L28rX3BvjcV81Zf7I49f4xUaR6
	 WAzNIcGH1lxf5TWvWrdtj9JNMroC0S8knLK+5Oh2DR5a6h9mDZzWmdIiGZyA80SOCs
	 EW4NYdQGimA/UQl6Kr68Dnnx4xSSYi54AKGh+8Gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <Sergey.Semin@baikalelectronics.ru>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0558/1001] dmaengine: dw-edma: Fix readq_ch() return value truncation
Date: Tue,  7 Mar 2023 17:55:30 +0100
Message-Id: <20230307170045.700958464@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit 5fdca4a995bcd4cf61bda40af154a730589dc524 ]

Previously, readq_ch() did a 64-bit readq(), but truncated the result by
storing it in the u32 "value".  Change "value" to u64 to avoid the
truncation.

Note: the method is currently unused, so the bug hasn't caused any problem
so far.

Fixes: 04e0a39fc10f ("dmaengine: dw-edma: Add writeq() and readq() for 64 bits architectures")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-edma/dw-edma-v0-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/dw-edma/dw-edma-v0-core.c b/drivers/dma/dw-edma/dw-edma-v0-core.c
index 77e6cfe52e0a3..a3816ba632851 100644
--- a/drivers/dma/dw-edma/dw-edma-v0-core.c
+++ b/drivers/dma/dw-edma/dw-edma-v0-core.c
@@ -192,7 +192,7 @@ static inline void writeq_ch(struct dw_edma *dw, enum dw_edma_dir dir, u16 ch,
 static inline u64 readq_ch(struct dw_edma *dw, enum dw_edma_dir dir, u16 ch,
 			   const void __iomem *addr)
 {
-	u32 value;
+	u64 value;
 
 	if (dw->chip->mf == EDMA_MF_EDMA_LEGACY) {
 		u32 viewport_sel;
-- 
2.39.2



