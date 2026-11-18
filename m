Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024769;
	b=RA4QU5khkcQEo5XYeWCVgVOUYn9ndvUBDq6p76pXU2mZv9pt23PvuB65kTo+kzq3FB54
	 qyFqzDUmy69MXJJCtERzg7Vde882AVVLlbksnFl0K4iTX0r3OYJMVem1dw7xTpOmZK1et
	 pkU6GX829fby5Kv0E0Y7nG4odzlbHB32hXLAFScrfXNCM4k5FthuYTA61RljyPlwCVlc0
	 +C0tiJT+31xA3I8n1Yiu9tKoQ8zzch3uH7fHJQ2NuW/b72L66hYO2ZuzGLdsHaRvMpTEm
	 bNK/gQyrGTTwtgRRjat9zPX050mkXZJIEXBn5pkh4W2iTgLbikbSdqfKLjAe082GCZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1a3X4LzP3VCF1+UBFzFfps+PWlxAfsaXWCK9rYkQLkY=;
	b=g0lOmmy0UCtqIEYF2KH4Z1BY1rWPP8+0+djtEuXqopBBTg94eFFYq5EMr8hf7AJHKvCU
	 l69bGzM+V5ctB443WgVd5QIjmz2uvZs1vOu2HZYx/QDm0RBvUPAhxQ0egm/5Jjy2PFLaj
	 6Yy3dFRkp9ICEOMyThEMMQzVHh6oq8j92gmD34fwftBlniIkk0BekA29oYV+yt1ZbFxji
	 SI5rOd/8mpx8YQ87oMGiFCTTJAGPlatNjI4O3Row0OO8TuAUBA5ioefH+FBUZhQFptUpk
	 9nPyt/doNrWpZy7nLiPnmcZgQBWNac0W6UgX2MYzcCVMA8K0GAEBATbTy+K7CJOpBqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YDJPq8NN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1B7606A33B;
	Wed, 18 Nov 2026 17:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YDJPq8NN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83561F000C4;
	Wed, 18 Nov 2026 17:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024769;
	bh=1a3X4LzP3VCF1+UBFzFfps+PWlxAfsaXWCK9rYkQLkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YDJPq8NNLuEJneMquuI4404315Bvzh+MnxtZbaVcIN88yETnbXmB++uuimUGDkN0d
	 wzcHWloz3QvtYEjdUBk4q8gBWu5bCBSrGD0LV6G1YK27+yDnoN4NVlP/SgCOOor/yS
	 e9d9dieoXVnzwpvb/wrK41JFPYu/g5f85NOVJhw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0843/2151] RDMA/mlx5: Restore mr->pi_mr after temporary stack-local assignment
Date: Wed, 18 Nov 2026 15:42:58 +0100
Message-ID: <20261118150152.964539401@linuxfoundation.org>
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



