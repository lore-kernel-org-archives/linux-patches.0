Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017735;
	b=WhwL46AsB7gwN+S3mLQzLL5uWBrrVlLE9ms7TBoyrggmI99IntIG1uo3Bdh5INoFfBEH
	 TKGTLT872BqPqpnCXve6vP/8pG+xIX44a8mJ0ei5ylgWXVkJ0XTL3NO32LbZuPF9hp5un
	 dS1eh69dRaYGvnTIm6eiAlzHzguPdKrboPG4+jQ7yCL9FGOev6/jQVpVDxQp5VGgfUTIW
	 Mh0LzG3tm7O7aWt+T2SHmlMF5/QUZ41Vo7bB8XMQXufMM3wh/gFd3oYtNV8ZzoISC8iOa
	 Ujc86D87ECf5l0KfbeYp+h+CXm1WMSnxfKaRzPemQgXol5w5h+uyIIRVh9/0Xc09FAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017735;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A99lVRkxo7cD2HtLvjpwPSHcn0s6ItsjCkfvUvb0png=;
	b=X+QoAiPF5iFVNL2Ek9ufPFXvKqdYUrrHBw7qddSD/3YA499YWYoOiqRv+0jpD6iE+CUv
	 kSjuRlfpcYm24Irjevi7/8IyXmcdLh6LxFKQXVHZqsuD/PlMomKSPLcIIMzUJLoZJqAwy
	 MY8Zt+OfqMMufsmzfojXTsTaogdFW+WVQfoRuo5ql4yHrq5tr4cCYQcJkJ7YAkMX6q8Ds
	 YUvZom0u+8FgEDUj5HjM7R3vjMz1lf0vFO7IbGsjhL5xQPys3G2rOPfhbsxuonp8jRDVD
	 Yjx5Pj6Rj77tQ+Yab856qkMoiQWFTUm5bDyL0y2XrPG9biLSF7hw9OhLnnOsducLDGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="EmPE3CI/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9954606A31C;
	Wed, 18 Nov 2026 16:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EmPE3CI/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089B21F000C4;
	Wed, 18 Nov 2026 16:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017735;
	bh=A99lVRkxo7cD2HtLvjpwPSHcn0s6ItsjCkfvUvb0png=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EmPE3CI/fd8HVgwIFvvIRY4Tc3c8FkF3zrSrl/tDS6/bQH1MedGlfB8iDoLmoJJS0
	 OG0+3O85ZMS6AAjcUBycSnRGB+C1HssiTIpc5p4dEOaEK+DUhH+VHZYi6URh/SuraV
	 MObXRdnYHsUIJaqP2F0c9AinVKLUwta1l7PGr4Qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0989/2651] RDMA/mlx5: Restore mr->pi_mr after temporary stack-local assignment
Date: Wed, 18 Nov 2026 15:37:09 +0100
Message-ID: <20261118150323.506641098@linuxfoundation.org>
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
index fca9e1d9d5e9b..bb2c60380fe21 100644
--- a/drivers/infiniband/hw/mlx5/wr.c
+++ b/drivers/infiniband/hw/mlx5/wr.c
@@ -927,6 +927,7 @@ static noinline_for_stack int handle_reg_mr_integrity(struct mlx5_ib_dev *dev,
 	qp->next_fence = MLX5_FENCE_MODE_INITIATOR_SMALL;
 
 out:
+	mr->pi_mr = pi_mr;
 	return err;
 }
 
-- 
2.53.0



