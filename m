Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C5113FD67;
	Tue, 23 Apr 2024 21:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908586; cv=none; b=RLgpBjTTzPJkQOwY553jo2HjRQ/HfH4ZBY+6ZWa5cF7kyZesvke3uBK0wVgvC+L++QME808kRruDAC1Q9BJ7AKbJLZNsnny4lpoFsWMR5l4sCI/bOompNKZ+Yco1t3SN8EHTdNmyffkkSmReU+u2p+cWnzgIvipIL4GGLnqE3TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908586; c=relaxed/simple;
	bh=rk/fSAOpzS/oD0v4R4RxWd09UDVpByrihHWLGkysx3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRLk2DcHALHTI247PdcWg7zZ7GV9si/suO8pXeGNm5thkS2iTaY3c3+UZ1UvPsKuDd1FiXEOT3nbpD+r9jbHvA29CmmMRn9eA+ZkX7nyusmmHj3tPmZXvVr84sePEn0hTRN0YivUfTRDYH5+IzemUUbIcz9UOTuJ2ZHlCHlCuM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yVm4B7rz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVm4B7rz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98FA3C4AF07;
	Tue, 23 Apr 2024 21:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908585;
	bh=rk/fSAOpzS/oD0v4R4RxWd09UDVpByrihHWLGkysx3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yVm4B7rz7ECHldrT2uu35nbndJcUgXHnPVh/IIYVGqdIoHGoqCKnqvNiqLfWl+fvm
	 2TGbY8jkorQKQrZLdAkEE0nRFnXjZtcaF6e+WHf4TChu/9XRFyBlpstWXFp1zp9m5C
	 tuU5tQB1yOsY+Ee8tM7uN3Y3wekRq5cMS85gkCMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Maor Gottlieb <maorg@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/158] net/mlx5: Lag, restore buckets number to default after hash LAG deactivation
Date: Tue, 23 Apr 2024 14:37:59 -0700
Message-ID: <20240423213857.129605625@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 37cc10da3a50e6d0cb9808a90b7da9b4868794dd ]

The cited patch introduces the concept of buckets in LAG in hash mode.
However, the patch doesn't clear the number of buckets in the LAG
deactivation. This results in using the wrong number of buckets in
case user create a hash mode LAG and afterwards create a non-hash
mode LAG.

Hence, restore buckets number to default after hash mode LAG
deactivation.

Fixes: 352899f384d4 ("net/mlx5: Lag, use buckets in hash mode")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/20240411115444.374475-2-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index af3fac090b828..e51cac1e1811e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -703,8 +703,10 @@ int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 		return err;
 	}
 
-	if (test_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, &flags))
+	if (test_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, &flags)) {
 		mlx5_lag_port_sel_destroy(ldev);
+		ldev->buckets = 1;
+	}
 	if (mlx5_lag_has_drop_rule(ldev))
 		mlx5_lag_drop_rule_cleanup(ldev);
 
-- 
2.43.0



