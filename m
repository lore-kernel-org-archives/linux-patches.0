Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016000;
	b=xWFYospY3x9HNgHmgN0K4n/nH8uFCE8B0IBIn7w6JtldhRxadaSu3/QimPui6Ocaqp/D
	 Ouau+kkEWylXJQR9CVNM375nX0ys/cmzzyi4sNnBJDzYHDy9zn3pqSldZI5NfsVQbmK03
	 OjFya0upMIr5aT0f4U45MfqMsD5opsJ01PCLRHYuWpEIN7LRbDuWqQinch427BxkFNGX9
	 0m/BqLBy2JzLIS7DUgh2moLqt/ul0zTVeBygmDPFwvzzkKqw2lqbSJU4eO+qxj/oP71oO
	 qbFr5zR1DQ0TFh3niT1nAOxbM/l4PZEyj6lhq5W9d7ofL4cxx3/x2gcffYcqnLl9Wtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016000;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WMu0piMvcf9aiHPeAzO77heVzzk3TYcBNrxmdm8ap6E=;
	b=tvpGHsDOtKzChW2udmB1ZntiW3jMUUpHBzZIXjq7sOsRE8xTmuZoebUQTrF1rr/UUgwn
	 OjMFo7vNtl9mYar1ZjkNuW+xgVJ7mlJZw4jtx+44sUVWvdUSYgob7Ljs516FS+tl1x6xc
	 4OPqcb+elZzWutTO8cLhXDOCV23ORN2jxwLg2pcYRqMbhfy82+dJkd/smIszEVNGa/WY4
	 bc8O/jO+YWkqbGX8Aio0RhcjPXMGzDKWIhuTjzjx6GtqZo9ImzfZXtOVqnYjkYYTv3ur8
	 NX6vf2vE+MI4xm2n4iO59wGXCXic4kgaWlGsG8gJ1k1dXVn9UvzWyi4Xsz5yF40+4eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2OoSdX2K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6007B606A320;
	Wed, 18 Nov 2026 15:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2OoSdX2K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FA41F000C4;
	Wed, 18 Nov 2026 15:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016000;
	bh=WMu0piMvcf9aiHPeAzO77heVzzk3TYcBNrxmdm8ap6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2OoSdX2KcepYlXPjfBP/WyEUIiPwhVeRziTI78DgrFxge97z/iUw+g5l8FGEu4pt+
	 zWc38x+MQ3YkJAbCOMPEDj9xuKr9+MKFa7Wx9o8e8R0S6NMak1EE5sgdkySWo9tzgR
	 6y/huMHketw06wi2T2767w7VLWvRJd9n7oSOCXBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Wang <wangjia@ultrarisc.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0372/2651] dmaengine: dw-axi-dmac: Fix LLI dump out-of-bounds access
Date: Wed, 18 Nov 2026 15:26:52 +0100
Message-ID: <20261118150301.223636704@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jia Wang <wangjia@ultrarisc.com>

[ Upstream commit e6b49f8016ee8b642e8e495d1704342ee0b35d72 ]

axi_chan_list_dump_lli() uses the channel-wide descs_allocated count to
walk the hw_desc[] array of a single transaction. If multiple
transactions have allocated LLIs, the channel count can exceed the
transaction-local nr_hw_descs and make the DMA error path read past the
end of hw_desc[].

Use the descriptor-local nr_hw_descs count when dumping LLIs.

Fixes: ef6fb2d6f1ab ("dmaengine: dw-axi-dmac: simplify descriptor management")
Signed-off-by: Jia Wang <wangjia@ultrarisc.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260902-dma-fix-v3-2-414c6449fbcc@ultrarisc.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
index ea26ebc328bcf..2d7d490170029 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -1052,10 +1052,7 @@ static void axi_chan_dump_lli(struct axi_dma_chan *chan,
 static void axi_chan_list_dump_lli(struct axi_dma_chan *chan,
 				   struct axi_dma_desc *desc_head)
 {
-	int count = atomic_read(&chan->descs_allocated);
-	int i;
-
-	for (i = 0; i < count; i++)
+	for (unsigned int i = 0; i < desc_head->nr_hw_descs; i++)
 		axi_chan_dump_lli(chan, &desc_head->hw_desc[i]);
 }
 
-- 
2.53.0



