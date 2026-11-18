Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023006;
	b=szVMilKxsAVMqz1vyjlJZNV8T80wEA5WFZCXHyp4ESAJuKIq7M29wGPyYFOozrUYZR/u
	 RHX4rNY4tARBSND8Fy0SX2IZjpHHEBGjEaS3tfIv5rC+661EfTqAn/kVwa96Xu/zK2Ntz
	 TeDUN5HobPXseh7PpVa68EEZH3LAyZkiHvPJXmXMK1ai7FFqg3Bnb1qZem4uNiKDbxtDw
	 L9gmsESRUJtu+2z4/CKR+uh5cgY1tl4F7guYucoUot+RdzG/LgCSlptqMKj83enwEjyuA
	 w/wtKmxxU7IM8+dLzFBW6p8jgwJ/K0Q6p8Aag8U8daX0gLhQdREu1FR/R+Gkstf25rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023006;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zG72dAhnwH3Kap1ajN0hHttN+sGjA/5GIYGFEzPY71Q=;
	b=BEmyNlRr8y0ro6Ewva5k8aLLnv22/7ljvMpCgeW+V6d+umx9+L0edqjOI0YVpK4b3IIK
	 0J0/FBpIc9wczvk00WCrOx9MUAyeVmk6FmKwhIzwFFIIM0xLQMYUXWPXlWP9WUVgUxQc4
	 BV2qthWP9QFQkx/01nLFRRUZLjt+SCuCtarlFhZLqJXdxuV0ESCVosKyMa0LiWRttZVLW
	 tSQhGEg1py+npocGZYdjPvnml6ELajD3VeuyKqBv62Jlyf40ZLPxsCIZnrhQp2WFI1rhO
	 pQx8XS/BXEFAL3Fidf6HRLXtLylEQXn7NgA5xAaHKQ5jHTRPX0uwEMKacHgy9kLzT7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tdOelhjt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9261606A336;
	Wed, 18 Nov 2026 17:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tdOelhjt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D3A1F000C4;
	Wed, 18 Nov 2026 17:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023006;
	bh=zG72dAhnwH3Kap1ajN0hHttN+sGjA/5GIYGFEzPY71Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tdOelhjtjQOzIR0HsedrHz4K3EUk+7DCX4U5HBfumsGSGXOosookxSl9ivaiYZJM+
	 UOKdg70n/akrFFTNKNZ5DwMAb3ID9ugp4kUoqro7T/usnPYHx3qQ4fyJJYvZUB1oAF
	 45ekJJLG6dYf5+AmjIIo81nbvudoTkbICWkiWaQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orgad Shaneh <orgads@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0188/2151] staging: octeon: schedule the TX cleanup tasklet every 1024th packet
Date: Wed, 18 Nov 2026 15:32:03 +0100
Message-ID: <20261118150128.634929951@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Orgad Shaneh <orgads@gmail.com>

[ Upstream commit db57f6517bf65523968ae29cd34a790bfa7d32af ]

cvm_oct_xmit() means to schedule the cleanup tasklet once every 1024
packets, as its comment says, to cover the pathological case of heavy
traffic on one port delaying the cleanup of another port blocked
waiting for it.

The test is inverted: total_to_clean & 0x3ff is true for 1023 of every
1024 values, and false only on the multiples of 1024. So the tasklet is
scheduled on nearly every packet, and skipped on exactly the packet the
comment wants. That costs one TASKLET softirq per transmitted packet,
each walking every port and doing an FAU fetch-and-add per non-empty
queue, and it buys nothing for this port, which already frees its
completed skbs inline from the skb_to_free value it reads out of the
FAU.

Test the mask against zero. On a CN50XX board (2 cores at 300MHz)
carrying ~6.9k transmitted packets/s, TASKLET softirqs drop from 7133/s
to 597/s with no throughput change; the freeing work is conserved, so
this removes softirq entries, not work.

Fixes: 4898c560103f ("Staging: Octeon:  Free transmit SKBs in a timely manner")
Signed-off-by: Orgad Shaneh <orgads@gmail.com>
Reviewed-by: Dan Carpenter <error27@gmail.com>
Link: https://patch.msgid.link/20260820113239.8169-1-orgads@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/octeon/ethernet-tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
index 1b30fe1bcf43b..4cbed9d75de5e 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -482,7 +482,7 @@ netdev_tx_t cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev)
 			cvmx_fau_fetch_and_add32(FAU_TOTAL_TX_TO_CLEAN, 1);
 	}
 
-	if (total_to_clean & 0x3ff) {
+	if ((total_to_clean & 0x3ff) == 0) {
 		/*
 		 * Schedule the cleanup tasklet every 1024 packets for
 		 * the pathological case of high traffic on one port
-- 
2.53.0



