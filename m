Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC069569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC5EC433EF;
	Sun, 28 May 2023 19:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302114;
	bh=glwm0XPTDE45ot7si0Nl9OnZg9KN1zzQXht50iLz8QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aazISdy7z/5VYaEtfVmHk86hPuFpYRKSo3JNxgIT0SoYDbpv+TcBP6Z/nuKujVoAp
	 b9bJppCGQNdiu3fszrvo7rdVIXH4khR3HRAolz3QuMXfkTWVwq6ulnOL99j8yB/Sc+
	 gsBy1O/SdiOrbNZkt0Ls1NBW3wxU/but5HA7xn1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roi Dayan <roid@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.4 159/161] net/mlx5: Fix error message when failing to allocate device memory
Date: Sun, 28 May 2023 20:11:23 +0100
Message-Id: <20230528190841.872362475@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190837.051205996@linuxfoundation.org>
References: <20230528190837.051205996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Roi Dayan <roid@nvidia.com>

commit a65735148e0328f80c0f72f9f8d2f609bfcf4aff upstream.

Fix spacing for the error and also the correct error code pointer.

Fixes: c9b9dcb430b3 ("net/mlx5: Move device memory management to mlx5_core")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -887,7 +887,7 @@ static int mlx5_init_once(struct mlx5_co
 
 	dev->dm = mlx5_dm_create(dev);
 	if (IS_ERR(dev->dm))
-		mlx5_core_warn(dev, "Failed to init device memory%d\n", err);
+		mlx5_core_warn(dev, "Failed to init device memory %ld\n", PTR_ERR(dev->dm));
 
 	dev->tracer = mlx5_fw_tracer_create(dev);
 	dev->hv_vhca = mlx5_hv_vhca_create(dev);


