Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015842;
	b=LnQuUh9P9fZMhxU5NjsrHocXNTktXIJtFZq2yILrwN8M5HSh2W0pYCLAxbeqz+un2v8S
	 NKb5fcdSeGL5nOR5Ev0+fl7T21ldM09FF/DriSEyny09bJxbBrFfEexiYuv7NkdS44Maq
	 IaZkgy9kizeiQ64ZwsyY4iRWJaQhDTjCtQDN77YAt9FqMP+4YY2z0qSiK2n5V1Yv4pUr2
	 FJhfoGPdjGy8hEd+22QAfXItlLelxP65xkWzaWfgjJQBJtGn15+jcBtKnFmA4vFOiyheg
	 rCb0gR/GoeAiqKgxf0J+kpgbCllhGOGzql978ACTmkdFpUh179xCxeeWsBm7RDVfZoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Pj3Zej8QHiNoHDwGy56ij3oXN4QtzSgGLj/pklEfKjI=;
	b=t8lsJl1RLcU0xZ1m1zz5oNpMJUhiM21K4T88yXrw/fNkJYWLrjZJ71N/oeywI025gOZr
	 t1bz8riF9gLTmUQsDpCMCC5HiQqQ+FVLOFgKkVAIhRJ5Dv0j0P1ffcPSN2EmhbVn+4QhJ
	 rqLjp+YHNjjbap7pS/tlSW+ZnXotobKAS2+WtyeYxA4H4yPfvSFTLeGYbzIh/YN+9Bv++
	 rACmyZF4D74XDqrBg1WMNCJXd5xjOnC30WaT1/vkdn6Sd/Vk0hEWzn0rZSntKtF64xDKx
	 /njZLQNV8G0lriMULHe5ZNLR6qTpk2BPIVOCk3HBOwtZMQj270+ek5m6vIGjJHqFFTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l4Y9Ufel;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829F360A2603;
	Wed, 18 Nov 2026 15:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l4Y9Ufel
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D820A1F000C5;
	Wed, 18 Nov 2026 15:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015842;
	bh=Pj3Zej8QHiNoHDwGy56ij3oXN4QtzSgGLj/pklEfKjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l4Y9Ufel4VdgUdgDR0MO7B87/ACt/m2KILIlKgvCFK7J8Gpj6eAQpdToxGQoWtn++
	 6kmmAwYQuYpHW5E7iNDQ+4qgeaaDqGDPouuW925lW86WRWVSjv8w1vPow2PIAfMtI6
	 LLQTyUsTXPRsN6Pa+4Mswn/Oret6BuxiAg3uSVCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0317/2651] wifi: ath12k: fix stale skb pointers after aligned TX payload shift
Date: Wed, 18 Nov 2026 15:25:57 +0100
Message-ID: <20261118150259.292229547@linuxfoundation.org>
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

From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

[ Upstream commit 6c40719489c8d799798989b15bc07b0700c132f8 ]

ath12k_wifi7_dp_tx() caches hdr, eth, and skb_cb from the skb before
calling ath12k_dp_tx_align_payload(). That function may shift skb->data
in place (when headroom or tailroom is sufficient) or reallocate the
buffer entirely via skb_realloc_headroom(), freeing the original skb.
In either case hdr, eth, and skb_cb are left pointing into stale memory.

After alignment, only hdr is refreshed, leaving eth and skb_cb stale.
skb_cb is written immediately after (storing DMA addresses), and eth is
re-read on every TCL ring retry via the tcl_ring_sel goto, so both
accesses are use-after-free or stale-pointer bugs depending on which
alignment path was taken.

Refresh eth (conditionally, to preserve the encap-mode distinction) and
skb_cb alongside hdr after ath12k_dp_tx_align_payload() returns, so all
three point into the live skb for all subsequent accesses.

Issue found during code review, compile tested only.

Fixes: 38055789d151 ("wifi: ath12k: use 128 bytes aligned iova in transmit path for WCN7850")
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260818-ath12k-uaf-for-aligned-tx-v1-1-d6ae195b15e7@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
index adeac4043b99b..02f509935fff6 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
@@ -313,10 +313,15 @@ int ath12k_wifi7_dp_tx(struct ath12k_pdev_dp *dp_pdev, struct ath12k_link_vif *a
 			goto map;
 		}
 
-		/* hdr is pointing to a wrong place after alignment,
-		 * so refresh it for later use.
+		/*
+		 * The payload may have been shifted or even the entire buffer may have
+		 * been reallocated for alignment. In that case, hdr, eth and skb_cb
+		 * are stale pointers. Refresh them now for later dereference.
 		 */
 		hdr = (void *)skb->data;
+		if (eth)
+			eth = (struct ethhdr *)skb->data;
+		skb_cb = ATH12K_SKB_CB(skb);
 	}
 map:
 	ti.paddr = dma_map_single(dp->dev, skb->data, skb->len, DMA_TO_DEVICE);
-- 
2.53.0



