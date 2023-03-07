Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B43ABA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D155C433D2;
	Tue,  7 Mar 2023 17:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210839;
	bh=1E3MlFuw2EYr6L9/PTkLdKzCnp/9OzMlQkB4hIeqx6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RQweprHkRttSyqc76pLAVNWmRIoiV6rHVsDD5OnNQ2uxN4k696i/cM9ILhDZ/grHO
	 q0Okc6qUOId4uXjLXH0oJefXwJKf7QX+Be1UnrDgb46QnIjO9+DbC7Qd6z4+UVuCUi
	 f8lly82xrGMZUgTKf4p8qsHxkMbkjXk76KuqZc8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0671/1001] net/mlx5: fw_tracer: Fix debug print
Date: Tue,  7 Mar 2023 17:57:23 +0100
Message-Id: <20230307170050.722420579@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 988c2352273997a242f15c4fc3711773515006a2 ]

The debug message specify tdsn, but takes as an argument the
tmsn. The correct argument is tmsn, hence, fix the print.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index 5b05b884b5fb3..d7b2ee5de1158 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -603,7 +603,7 @@ static int mlx5_tracer_handle_string_trace(struct mlx5_fw_tracer *tracer,
 	} else {
 		cur_string = mlx5_tracer_message_get(tracer, tracer_event);
 		if (!cur_string) {
-			pr_debug("%s Got string event for unknown string tdsm: %d\n",
+			pr_debug("%s Got string event for unknown string tmsn: %d\n",
 				 __func__, tracer_event->string_event.tmsn);
 			return -1;
 		}
-- 
2.39.2



