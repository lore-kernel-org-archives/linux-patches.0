Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A669446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:45:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3FEC433C7;
	Sun, 13 Aug 2023 21:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691963132;
	bh=8XstUszOUuydCBG8NLru81gTAfM/BcWF0b+uMxKBUvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kwDH7sCUBx/fJTB0qXS/+UsRENpyH8CvXmi2BV+gaywWsqj5TIB2EsWkR6NdLBmPi
	 G1/nRBPuCnHti2EJLiwo45w6Ybmqm4H3Tf29yGoCk9bKJw++t2haImxJaVABqNq63V
	 1j35Dbn66bBOcY/ElgctPIJEIC98PR9vYtdEafuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Jurgens <danielj@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.15 65/89] net/mlx5: Allow 0 for total host VFs
Date: Sun, 13 Aug 2023 23:19:56 +0200
Message-ID: <20230813211712.733304261@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211710.787645394@linuxfoundation.org>
References: <20230813211710.787645394@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Jurgens <danielj@nvidia.com>

commit 2dc2b3922d3c0f52d3a792d15dcacfbc4cc76b8f upstream.

When querying eswitch functions 0 is a valid number of host VFs. After
introducing ARM SRIOV falling through to getting the max value from PCI
results in using the total VFs allowed on the ARM for the host.

Fixes: 86eec50beaf3 ("net/mlx5: Support querying max VFs from device");
Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -256,8 +256,7 @@ static u16 mlx5_get_max_vfs(struct mlx5_
 		host_total_vfs = MLX5_GET(query_esw_functions_out, out,
 					  host_params_context.host_total_vfs);
 		kvfree(out);
-		if (host_total_vfs)
-			return host_total_vfs;
+		return host_total_vfs;
 	}
 
 done:


