Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030347;
	b=xrdSEY/zQXigmxCXaUjowg+x8ELmBhTdhbAJP+J45e/IEalsGnBfh5gIkPdFrg6tgawU
	 Qk1Mh6krkzMxI0q7eh/GpXMUq1Z5LfZGWpdijHwfAEGh70f7lPh5iihkoZQ904NxUhm27
	 /gL55stK0Ul5PH+bvTZb14k3yQZwHNCzaJSti7Asmg2w8atbIf7EmzeJgarq13qI/Xh69
	 yRqt9Z1tS5vkEH7dNTIvD1s29UxqoG/+oL2BwUCT2m/EXvHCBledREBhiTqpGVeFhGMZB
	 Cjm3xYPQE5JLx+wQFV2utt2O0t40kNMSUD7h19saVYFNHqTsp/Lx5u4HkoFsHGzuQoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B+kdV32Bt7mhLVEqNDyAI5fN3Uf6v4LD99JLWmw+3L4=;
	b=BEkw6WF+bACDsJVJ7U1JDaQyFrZ769no0tcuw4QQ5ZIYIApYhU1beuE7xtzbdMVBXgW+
	 7fjDoAdboq3ipBLsrcBhvFL0yJs+wmhf5ou/gsYwtKLgvN91JbNn5DTDttYBb6mLDJgef
	 /1jU3y8WSGcRjhcbfKQRPt+TSpyphkkp5VcqmjHvIVuRWBvkeLTvMsdQ5lXkm/bWCAIV3
	 E4iry/1Ur/78L1YbAgYUJCKUWqXcIIBw8pCJ0ZWGjSYfGJrfpy8R1whPtXgW0hZHbThQ+
	 IkikCE0yYH6sd8rXkUfG8dvMxLgzUxETrtbjZ8aV5S/VEhb9J3rwnZO/XlrUXtkO17Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UCHZ8+yD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDFE606A33A;
	Wed, 18 Nov 2026 19:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UCHZ8+yD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1117A1F000C4;
	Wed, 18 Nov 2026 19:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030347;
	bh=B+kdV32Bt7mhLVEqNDyAI5fN3Uf6v4LD99JLWmw+3L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UCHZ8+yDtIISN8rd8OIOSvU2xX7R2pyYyEXiTsPpPAxWlrpSvW3hn+6Lq0byb55iw
	 ZeKD3lhDPladDM/sGfj877kDm2A5SRaDdChMyJCRmvpQLCVeYJ7wZgn65zBzk9gmuj
	 O/aTO3SGW2ia/kQSVZuI2ZwcVXugpD424l2ABAgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0672/1756] RDMA/mlx5: Restore mr->pi_mr after temporary stack-local assignment
Date: Wed, 18 Nov 2026 15:46:39 +0100
Message-ID: <20261118150036.029903856@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 9728effe43d8fc4d58e12b697d0d6127355abdd5 ]

In handle_reg_mr_integrity, when mr->pi_mr is NULL (physical-address
optimization path), the code points mr->pi_mr at a stack-local pa_pi_mr
so set_pi_umr_wr can read it during this call. The pointer is never
restored, so after the function returns mr->pi_mr dangles at a freed stack
frame. A second IB_WR_REG_MR_INTEGRITY posted on the same MR without
remapping reads the stale pointer and dereferences it.

Save the original pi_mr (captured at function entry) and restore it on
the out path.

Fixes: 2563e2f30acb ("RDMA/mlx5: Use PA mapping for PI handover")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://patch.msgid.link/20260919100848.2442-1-lirongqing@baidu.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/wr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/wr.c b/drivers/infiniband/hw/mlx5/wr.c
index 9947feb7fb8a0..1748c633213ed 100644
--- a/drivers/infiniband/hw/mlx5/wr.c
+++ b/drivers/infiniband/hw/mlx5/wr.c
@@ -925,6 +925,7 @@ static int handle_reg_mr_integrity(struct mlx5_ib_dev *dev,
 	qp->next_fence = MLX5_FENCE_MODE_INITIATOR_SMALL;
 
 out:
+	mr->pi_mr = pi_mr;
 	return err;
 }
 
-- 
2.53.0



