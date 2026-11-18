Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061232;
	b=x/9UQ56Ar5Np3HBu//AUPZsppfB37EZX7K1Vn7qGk1FDE5DBbafLmTd2/Nl4yDbS7Ogo
	 R0k8UaiuBCXAhgwWQnkbxs+XF69gWRCzMGG+TSL1a8J9aalRdiJxKQneK8QWJEW8aWGXV
	 2n0NuaqU4/FF83N/RcAE52LRSsKjm5NCApcZVnnZhQDSoHXOFopiJQcMyx3xhdOjvvTbn
	 Zyuq1frmb1Mt4SqZbb4LhQiTrSheu5pHFBcKItgArKu6WqIjUAuZr0BnDQ9wOsOCjEQxm
	 TowwXPT5UOx9YXr13WiwzOrNnZ9SiCOWKdq6AUkN7NVi0oPo6X8QFWkFDHrGp2pWaiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061232;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CGRlIu1FRsFgEtFbwBWHYDTrcmfLOcnw8Sk8nGEzRAI=;
	b=u4nxDbEmwcqYbEMKGWf74iXlGbcHXpMlnAaQrBR4HCmuzI8BhwX2a+EZVbGchv130moY
	 g0hamS/UXjpLIrCcp3OSKZAugsY56l6ChCv/N8qUyZlz8+KGL6xzVdR2yHo2LAOppgKqZ
	 3242uxDEBEVNXuSY9xTKBwKbydG77UvwFnt2Pcu4PTSh6s9zyBjOe46SXKcR61YTgM1zb
	 3TZ3Z2Vap/Q/KCCG3Jg3+KwzYnqIG9qINLDRrU0nwE1LtberqqfPK9cuJWB9HiOTnvGlb
	 4AWchUYFsmoDaktxkaTMNeBhhhA6yYNVhfy1KyqGlULbX/sKp10TwFtJ5358wVekBgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PxjNybQu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0C4606A320;
	Thu, 19 Nov 2026 04:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PxjNybQu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3754D1F000C4;
	Thu, 19 Nov 2026 04:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061232;
	bh=CGRlIu1FRsFgEtFbwBWHYDTrcmfLOcnw8Sk8nGEzRAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PxjNybQuRDBykej+KFnhSeeHj02DF/pCqrqGNmIWg/mapNTQ5YzCa3BB6ex/iVzHo
	 z24hFs8zTL2agxo7ukpKq5mIULyP5h6yFu1Ofex1TlDc/8R/P989N6GDD9lnUXfQPX
	 OJyCQ5sHGn4lYpLULGLDTuw7UGtKKnUuDitFcWhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1480/1848] dmaengine: ste_dma40: Fix physical cyclic capability
Date: Wed, 18 Nov 2026 15:58:38 +0100
Message-ID: <20261118150021.233453734@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 11101a8e3e42273a5910a149f6324040b88f4747 ]

d40_dmaengine_init() configures dma_both for physical channels that can
handle both slave and memcpy transfers. Physical DMA40 channel setup has
supported cyclic LLIs since cyclic transfer support was added, but the
DMA_CYCLIC capability is set on dma_slave a second time instead of
dma_both.

Set DMA_CYCLIC on dma_both so d40_ops_init() installs
device_prep_dma_cyclic and physical channels advertise cyclic support.

Fixes: 0c842b551063 ("dma40: cyclic xfer support")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-1-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 4c306dd13e865..5efc4ee2f242f 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2886,7 +2886,7 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 	dma_cap_zero(base->dma_both.cap_mask);
 	dma_cap_set(DMA_SLAVE, base->dma_both.cap_mask);
 	dma_cap_set(DMA_MEMCPY, base->dma_both.cap_mask);
-	dma_cap_set(DMA_CYCLIC, base->dma_slave.cap_mask);
+	dma_cap_set(DMA_CYCLIC, base->dma_both.cap_mask);
 
 	d40_ops_init(base, &base->dma_both);
 	err = dmaenginem_async_device_register(&base->dma_both);
-- 
2.53.0



