Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3C01DDA2E;
	Mon,  6 Jan 2025 15:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178379; cv=none; b=FdV5DamcWkkoPauVktvgYJxtsSx8thjcQ60rqNNNMtUg6vvNQ7afd5j9NolxP68nhh6OpotGewdC+uNOtsHY8Xyd0rCpDHHSam+t+rn+DJhi7xmPMDEPKDb1fa+9wZgW37s8td6CeGNnTp9zSj+T+HQGWpIQ3teWTftb5+BCUcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178379; c=relaxed/simple;
	bh=v6vV8t3+5Ljm8YKn6GsqJdDCBLd1PPIfSKjhtXibaBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dj2Et6YYWzuSYCHxWCIqhwfAmABd7u25ElF1BQj3Rvsq+3gJf4svRcwP70KXJW/O/OiNAy/zRX3mJC3qOib6ap8lU4B0yeB0eSzkN/1O3eEXFodXEpVMcxGQjRppmbJ12R6Fx3YGn2QcAEE56ojqTKRrZZmLd6onkbCHiqsbcQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z5VS13Qn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z5VS13Qn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211AAC4CEE2;
	Mon,  6 Jan 2025 15:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178379;
	bh=v6vV8t3+5Ljm8YKn6GsqJdDCBLd1PPIfSKjhtXibaBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z5VS13QnjZa8KOevhYh+wIzBQl6o/1ZsBtEy/RJ72cfRvemxkAP0BBzjE5GJOTVXM
	 5H8SrjuzdGsAHBPsobyLD9XEy97HFWZZ7DTIh5AZHVbEm6uMKEGwg++TAgVmnOXTMN
	 WlqdbXGUHozGloX6nFWy51oOsDLD1Tx+rRcJrpcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parav Pandit <parav@nvidia.com>,
	Bodong Wang <bodong@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/138] net/mlx5: Make API mlx5_core_is_ecpf accept const pointer
Date: Mon,  6 Jan 2025 16:17:03 +0100
Message-ID: <20250106151136.980890753@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit 3b1e58aa832ed537289be6a51a2015309688a90c ]

Subsequent patch implements helper API which has mlx5_core_dev
as const pointer, make its caller API too const *.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Bodong Wang <bodong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: e05feab22fd7 ("RDMA/mlx5: Enforce same type port association for multiport RoCE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mlx5/driver.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 2cd89af4dbf6..30d7716675b4 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1142,7 +1142,7 @@ static inline bool mlx5_core_is_vf(const struct mlx5_core_dev *dev)
 	return dev->coredev_type == MLX5_COREDEV_VF;
 }
 
-static inline bool mlx5_core_is_ecpf(struct mlx5_core_dev *dev)
+static inline bool mlx5_core_is_ecpf(const struct mlx5_core_dev *dev)
 {
 	return dev->caps.embedded_cpu;
 }
-- 
2.39.5



