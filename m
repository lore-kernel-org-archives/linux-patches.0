Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624625;
	b=gBcVD2Yy5zbuz4NkL+lugIVjKLYioG9qT6gyYeMsxOzmzVvzps5dgocQd+bbwPO7yqZ/
	 tk3aE+PZW5/6Z2M8OhAlwBe4KZU+Q+x5xZ+Oxk7qhNLviOWUNhQC47O2LbIaTN+h9cQOC
	 2D/ZNWfPyctEt53MiYw3hdshtrAnwScJ6NXe5EtL1C70ZOt7ihspqmOFCy5YdcUjnDVTk
	 FJQvazgEhKoRsl6gL87dmt+tKASW4k9wsnHUb26D6XFhmWq82HVzhy/KoU4d75i5+F2Hz
	 ynbJ9BFFCEzfJ3TyBTaNdvNLlizBgF1uOgRR157L6ubViBjxGPHF4OVCsAcwPsg2G3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624625;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RpOLTYyNSxcYRDTvepk0cd3pMJHR9dAhK4qyZSZLboI=;
	b=mTiljfutjsbklm+K8FNoCk4fxxkWQlfy8RUdqnj6nadtq5QW08rzqwbs3Wtr1BLfrlxO
	 otKpgLi+4fWPzpczeB1JVEjtKaKE8Y+xxGEBJBdTd+nCdfZv/kdZzMbUi2NJg2fmeASoV
	 +tR++lSOEVlZVMIGKROhVr7GUt9lsV27R0fMJtuLojU5VXhPFniEQGx8PlcW7/6YWQDup
	 hQSHa+UC9uIeySOx/QRvD9Qcha9PNEt115bSHO/OJddI3KhQzib+/Lb5tkjtI5lIh4jG3
	 LFnLOlS+cKrNyfXntqC6EcrxalJ/yBzK3OJmqHieypuR8ZRGFbOYJDUiWo8cKXA0FYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0T6E8xMv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090B3606A33B;
	Wed, 25 Nov 2026 16:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0T6E8xMv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A02A1F000C6;
	Wed, 25 Nov 2026 16:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624624;
	bh=RpOLTYyNSxcYRDTvepk0cd3pMJHR9dAhK4qyZSZLboI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0T6E8xMvC7ck10loFLWyuJj4/Kj9YeqxWAIX25h1+QQs6LmXNZyjM7iZK0GjwhpXD
	 fo3Hj3CyEa8/boWD3GOYxhVcIzA8AEmIoNIwx8iC/Rkq261N5WlKLsMA9ZSxOElVhl
	 m1x0fZFy+t6NTBEjcsi8VUlT7oNah23vzOyPyll8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 253/816] net/mlx5e: TC, Fix double free of branch in failure
Date: Wed, 25 Nov 2026 15:30:01 +0100
Message-ID: <20261125143855.066327257@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 31f9b43a3bb3d2201eadd147440252d0912dab21 ]

When allocating the false branch fails in parse_branch_ctrl(), the
already allocated true branch is freed but attr->branch_true is left
pointing to it. The caller parse_tc_actions() fails the flow, and
free_flow_post_acts(), mlx5_free_flow_attr_actions() which calls again
free_branch_attr() on attr->branch_true.

Clear the pointer after freeing it.

This bug is theoretical and was compile tested only.

Fixes: f86488cb4685 ("net/mlx5e: TC, initialize branch flow attributes")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Tested-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index a5ae179310672..531127dbe800e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4009,6 +4009,7 @@ parse_branch_ctrl(struct flow_action_entry *act, struct mlx5e_tc_act *tc_act,
 
 err_branch_false:
 	free_branch_attr(flow, attr->branch_true);
+	attr->branch_true = NULL;
 out_err:
 	return err;
 }
-- 
2.53.0



