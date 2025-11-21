Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0533332904;
	Fri, 21 Nov 2025 13:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731058; cv=none; b=ssM6RqXcTdTK58vlWi+G2L5i9o0MJDF3rwykuwnnNSQBGcu6irWoXYzX5BhYPsj4BtprmhtEO5WqCnQHaSlatFqR7s0Rluu9VUMxmHVqdH4RguIn+mRh/j5VO519pv8/BFXKxGBYuxDZeVWAMn+XD2jWAd3iN0V7KhN9ChfsIMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731058; c=relaxed/simple;
	bh=59PzSM126wNUHUUp4dUXQBji+f/ZsF0kcuqF8z7leyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eR+mdcpHEF1WGdt2l3sHY11xjIWnlufZfmsaqvlJeZUPPYmK7ziGhNaRTr3fyo867Q9xkeAqyN5wNF8FHLef6qFgNsPJVgsm45nmOBtXaixfSeEw7e9DkBFBmvbd8VNlYhpQPhdAGXgXaQRIyBeILoJWi+yKurhBUGtnAqX0XGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XXq+zu4Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XXq+zu4Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407DEC4CEFB;
	Fri, 21 Nov 2025 13:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731057;
	bh=59PzSM126wNUHUUp4dUXQBji+f/ZsF0kcuqF8z7leyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XXq+zu4ZEkQK+64UjnrITrMOWFSMj4L1O4y3ZALKuGnLYSPT92f2Ap9oM8AaGj+yl
	 UcVhv2CFRZHSUIJniLAqDQlbWwiCa5JprFXlgyjVAwI/NNG3nOqphQqpMfvLdBm0KK
	 tqvIL7t8QaxFkrrvIHi1H58WZGvHASLEslGW0yL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Carolina Jubran <cjubran@nvidia.com>,
	Jianbo Liu <jianbol@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 074/247] net/mlx5e: Fix missing error assignment in mlx5e_xfrm_add_state()
Date: Fri, 21 Nov 2025 14:10:21 +0100
Message-ID: <20251121130157.254225659@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit 0bcd5b3b50cc1fcbf775479322cc37c15d35a489 ]

Assign the return value of mlx5_eswitch_block_mode() to 'err' before
checking it to avoid returning an uninitialized error code.

Fixes: 22239eb258bc ("net/mlx5e: Prevent tunnel reformat when tunnel mode not allowed")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202510271649.uwsIxD6O-lkp@intel.com/
Closes: http://lore.kernel.org/linux-rdma/aPIEK4rLB586FdDt@stanley.mountain/
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1762681073-1084058-2-git-send-email-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 0a4fb8c922684..35d9530037a65 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -804,7 +804,8 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 		goto err_xfrm;
 	}
 
-	if (mlx5_eswitch_block_mode(priv->mdev))
+	err = mlx5_eswitch_block_mode(priv->mdev);
+	if (err)
 		goto unblock_ipsec;
 
 	if (x->props.mode == XFRM_MODE_TUNNEL &&
-- 
2.51.0



