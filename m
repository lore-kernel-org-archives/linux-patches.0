Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034585;
	b=Cxptdh9+CnKpr1pVrc8vYLJiS2fnLCBWc0Cz68vRdbew62o6uLcNIh73fp0uPyOey0Kz
	 9AfS5GpjPXu8vjtLC/PE8j3gi4pk5NhyV7RA/AnlJiOzJxuks6XvUPfQcF7VsGRT8Nrmd
	 lh4jB9v0vRrtiN3F56brUYVcwb6PnNNtl6I/u9q9Z5T2Lb6qdlvbwXn1cdWLyBB7CGK0x
	 p79Wg4Rm0rRgtuPe0gOLUQRrk/CShQ3JtUQ77M1AggrfknhGZuMMTRSk32N3w61tpkwu2
	 qlIr2kBLKkaxHU1XFUMK2+r4kwRK0MuKicuigGOitDGEheqzMOHug6dxGSIVod9N6NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034585;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w4s5Yy6LsuORLrlVMx1+62C3LN4yqs0YA7nYEkDVwTk=;
	b=rvtEqLmSSlFPOkiWbOPwJYb0Kisn7iaR05VHWR51l1FZly+yr1zX2OCBjWax5OY93qME
	 eNQjEnANFTxlITiOBvJP99sdLLt1V3QL1/04MF7AFoDl0s8s+cBocVqIMg5sTA2Z7bGb6
	 Ebka00BHhr1C2ZQ1nNa6Dg+bf9jadPX+waUjmzXlL42K4cuZRaPvzqFz3kFxhfG03cAwU
	 wi/iYJ0R5VCwgn2RbS9aFBM3gFHyPTTlRGkMm2cdPV/hTVolyi10VHz5Dt0jRx4izNinJ
	 yTCmwXheQ0kTnOCSTU/d4ceOiMa3gaiIoiGdIQb3wZxV4+qhG7TdIuTZhdiCApYPu3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dvTQ1V5h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F292606A325;
	Wed, 18 Nov 2026 20:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dvTQ1V5h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763731F000C4;
	Wed, 18 Nov 2026 20:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034585;
	bh=w4s5Yy6LsuORLrlVMx1+62C3LN4yqs0YA7nYEkDVwTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dvTQ1V5hnk4e91jcq8Z4PIJxKZtZUdhX70Fndepv+BJlLGNygPoz02g45se9c656U
	 w15r6dgbqLOPl7RzWsPymL6ykmS8tNP03hlpXOaG+ihbNfyBUsDme0jW10UBi3eBAR
	 6q3Sx8MDRD2n9eCrfcX4WWn03NRdR24AYfjLtX0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Glenn Judd <gmj@meta.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0420/3318] net/mlx5e: do not HW-GRO coalesce small frames
Date: Wed, 18 Nov 2026 15:17:22 +0100
Message-ID: <20261118150329.159522893@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Glenn Judd <gmj@meta.com>

[ Upstream commit e2466392a0b8496000e12181cb1ee1535eb0da25 ]

When hardware GRO (SHAMPO) coalesces a small IPv4/TCP segment that was
padded up to the 60-byte minimum Ethernet frame, the trailing padding is
folded into the merged payload causing padding to be delivered
to the user as payload.

Detecting and reproducing the issue: the selftest
tools/testing/selftests/drivers/net/gro.py subtest
hw_ipv4_data_lrg_1byte sends {100, 1} expecting to receive {101}.
In current code, it receives {106} (100 + 1 payload + 5 pad) instead.

This patch avoids giving the user padding as payload by simply not
coalescing small packets (which fails the subtest; the same approach
and behavior as sw gro). This gains code simplicity at the cost of
more computation (passing an extra skb up the stack) for small packets
that could be coalesced.

The threshold is chosen as ETH_ZLEN + 2 * VLAN_HLEN. This is the largest
frame that may still contain minimum-frame padding (+ 2 VLAN tags), so
anything larger is safe to consider for coalesce. (We do not include
ETH_FCS_LEN in that threshold computation as netdev_fix_features()
drops NETIF_F_GRO_HW whenever NETIF_F_RXFCS is set, so retained FCS
can't reach this path.)

Fixes: 92552d3abd32 ("net/mlx5e: HW_GRO cqe handler implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Glenn Judd <gmj@meta.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260816064259.3279548-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Adapted the hunk context to the older fixed-page-size code and added a flush && *skb NULL check so the trailing flush can't dereference an skb already passed up the stack. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 11a75a9917f9c..5df1ec397ddac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2376,6 +2376,11 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 		goto mpwrq_cqe_out;
 	}
 
+	if (unlikely(cqe_bcnt <= ETH_ZLEN + 2 * VLAN_HLEN)) {
+		match = false;
+		flush = true;
+	}
+
 	stats->gro_match_packets += match;
 
 	if (*skb && (!match || !(mlx5e_hw_gro_skb_has_enough_space(*skb, data_bcnt)))) {
@@ -2415,7 +2420,7 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 	}
 
 	mlx5e_shampo_complete_rx_cqe(rq, cqe, cqe_bcnt, *skb);
-	if (flush)
+	if (flush && *skb)
 		mlx5e_shampo_flush_skb(rq, cqe, match);
 free_hd_entry:
 	if (likely(head_size))
-- 
2.53.0



