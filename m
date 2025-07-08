Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F722E5416;
	Tue,  8 Jul 2025 16:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992313; cv=none; b=lIytGt2pmimjC82CEUU1iPHLXkLvYx8cP6rUXZ9O3SFU4MIgNGAis7Wtr6H2BHbd6TR0CFFY4o4z9gnfl72022Yl+Y9QXfg3wJRF0UvHxCpjFt8sCTUFQ1QQhgcLcf91/bdW5s5WZ8F29/ZCYhm6QMT/Rfj5IHqAvrynZDQNyHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992313; c=relaxed/simple;
	bh=z+m5yWShR3mAmTy6BVyryfZH/KRxTczfvq/BVeKvTI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mkWXV+5JzmcUZysob0Ijr1A56WzHWcSUjJ1+LwxkXb/0/DVc6YuDJFdSEN04aok5DK+XWgO473asZFrt5OWBFmy/k9jNwASP2ajpwypxca+7QcpBYQjaCtIvk8RfedFatRqA1jtDlpEF5N3NLLaVeR0izKTXX4SyMTxYHiBLae8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eyFCLRX9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eyFCLRX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAEFC4CEED;
	Tue,  8 Jul 2025 16:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992313;
	bh=z+m5yWShR3mAmTy6BVyryfZH/KRxTczfvq/BVeKvTI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eyFCLRX9EffdK5Ql1+DhPZuky5Verl+6ARg8M3eeK428M+gWl6YPUfUbDQRm9Nvnr
	 Ii6dAT2YurrslJAC/+beTQLDsCGtrcLbJgML2Gf2YevhTU1HT4Xy9xihi3qT9th/kF
	 jpga+bT18QoN8/aV9XaPUD3qErO76b+wKqZuCtVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	David Thompson <davthompson@nvidia.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/132] platform/mellanox: mlxbf-tmfifo: fix vring_desc.len assignment
Date: Tue,  8 Jul 2025 18:22:10 +0200
Message-ID: <20250708162231.290260429@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Thompson <davthompson@nvidia.com>

[ Upstream commit 109f4d29dade8ae5b4ac6325af9d1bc24b4230f8 ]

Fix warnings reported by sparse, related to incorrect type:
drivers/platform/mellanox/mlxbf-tmfifo.c:284:38: warning: incorrect type in assignment (different base types)
drivers/platform/mellanox/mlxbf-tmfifo.c:284:38:    expected restricted __virtio32 [usertype] len
drivers/platform/mellanox/mlxbf-tmfifo.c:284:38:    got unsigned long

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202404040339.S7CUIgf3-lkp@intel.com/
Fixes: 78034cbece79 ("platform/mellanox: mlxbf-tmfifo: Drop the Rx packet if no more descriptors")
Signed-off-by: David Thompson <davthompson@nvidia.com>
Link: https://lore.kernel.org/r/20250613214608.2250130-1-davthompson@nvidia.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlxbf-tmfifo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c b/drivers/platform/mellanox/mlxbf-tmfifo.c
index 39828eb84e0ba..1015948ef43eb 100644
--- a/drivers/platform/mellanox/mlxbf-tmfifo.c
+++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
@@ -281,7 +281,8 @@ static int mlxbf_tmfifo_alloc_vrings(struct mlxbf_tmfifo *fifo,
 		vring->align = SMP_CACHE_BYTES;
 		vring->index = i;
 		vring->vdev_id = tm_vdev->vdev.id.device;
-		vring->drop_desc.len = VRING_DROP_DESC_MAX_LEN;
+		vring->drop_desc.len = cpu_to_virtio32(&tm_vdev->vdev,
+						       VRING_DROP_DESC_MAX_LEN);
 		dev = &tm_vdev->vdev.dev;
 
 		size = vring_size(vring->num, vring->align);
-- 
2.39.5



