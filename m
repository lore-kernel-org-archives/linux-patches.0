Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81F28825;
	Sat, 30 Dec 2023 12:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZ3V6B31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60EC4C433C7;
	Sat, 30 Dec 2023 12:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937730;
	bh=E9xEh/D8HR7RGby1czfRaGYBMndXXwv2/rvVxHVzMeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZ3V6B31jh03Djg8YO/tPgfF/b7rGkT2cYdgq1KW7oiWYCOFdNZELbzribtUSDt8V
	 R2EzEzYOOygITWrJGwBDuePBJ/A/WQqfG6bw3itoAt92j6OqmVNTHXtEf8W3o8Sd8C
	 lASv/+bGuPXtGMtD1T1c3Ocaf3ZN6d8GkiLG1E7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/156] net/mlx5e: Fix error codes in alloc_branch_attr()
Date: Sat, 30 Dec 2023 11:58:15 +0000
Message-ID: <20231230115813.705496308@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit d792e5f7f19b95f5ce41ac49df5ead4d280238f4 ]

Set the error code if set_branch_dest_ft() fails.

Fixes: ccbe33003b10 ("net/mlx5e: TC, Don't offload post action rule if not supported")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 2cfbacf77535c..25e44ee5121a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3776,7 +3776,8 @@ alloc_branch_attr(struct mlx5e_tc_flow *flow,
 		break;
 	case FLOW_ACTION_ACCEPT:
 	case FLOW_ACTION_PIPE:
-		if (set_branch_dest_ft(flow->priv, attr))
+		err = set_branch_dest_ft(flow->priv, attr);
+		if (err)
 			goto out_err;
 		break;
 	case FLOW_ACTION_JUMP:
@@ -3786,7 +3787,8 @@ alloc_branch_attr(struct mlx5e_tc_flow *flow,
 			goto out_err;
 		}
 		*jump_count = cond->extval;
-		if (set_branch_dest_ft(flow->priv, attr))
+		err = set_branch_dest_ft(flow->priv, attr);
+		if (err)
 			goto out_err;
 		break;
 	default:
-- 
2.43.0



