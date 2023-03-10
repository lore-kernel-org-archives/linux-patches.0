Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90A9847E
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:46:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA7AC4339C;
	Fri, 10 Mar 2023 13:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678455983;
	bh=MfPffJQlNQGEQ/nbI4rnjHwa4ya4/hXrHrtLE+9i1js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vmZfgLV3WtoqHlhPRBLJ0o4no/Mt37i5v4sM6Zz3S7tgjlOPJqM699+c6w9YYVP15
	 3tutCZCnpD/3tl3QceokMRsZhujTzrQFoR5Dx5Jf2fzqGBSn11gTRJz4tKevJEr4MI
	 PYdhLpquN3rW8eHuNtzXQqx1QrfXJiTrQL1R6I0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eran Ben Elisha <eranbe@nvidia.com>,
	Majd Dibbiny <majd@nvidia.com>,
	Jack Morgenstein <jackm@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 042/193] net/mlx5: Enhance debug print in page allocation failure
Date: Fri, 10 Mar 2023 14:37:04 +0100
Message-Id: <20230310133712.389436174@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jack Morgenstein <jackm@nvidia.com>

[ Upstream commit 7eef93003e5d20e1a6a6e59e12d914b5431cbda2 ]

Provide more details to aid debugging.

Fixes: bf0bf77f6519 ("mlx5: Support communicating arbitrary host page size to firmware")
Signed-off-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Majd Dibbiny <majd@nvidia.com>
Signed-off-by: Jack Morgenstein <jackm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index 9c3653e06886a..fc880c02459db 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -164,7 +164,8 @@ static int alloc_4k(struct mlx5_core_dev *dev, u64 *addr)
 	fp = list_entry(dev->priv.free_list.next, struct fw_page, list);
 	n = find_first_bit(&fp->bitmask, 8 * sizeof(fp->bitmask));
 	if (n >= MLX5_NUM_4K_IN_PAGE) {
-		mlx5_core_warn(dev, "alloc 4k bug\n");
+		mlx5_core_warn(dev, "alloc 4k bug: fw page = 0x%llx, n = %u, bitmask: %lu, max num of 4K pages: %d\n",
+			       fp->addr, n, fp->bitmask,  MLX5_NUM_4K_IN_PAGE);
 		return -ENOENT;
 	}
 	clear_bit(n, &fp->bitmask);
-- 
2.39.2



