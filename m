Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F159446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:38:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A19C433C8;
	Sun, 13 Aug 2023 21:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962686;
	bh=60PpaRb8cKQRAV+Vmze+dGUb03Sey38P/DYp6hkOItA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KbMngy7oPPfwAac35w7zurU/Cafs1yelKNIbqxiETZlQvC2pGoBHxqT7Qetjp7zlv
	 S7ZY1vZGh6Q3fUgXj+Fgs8iZC9NitZIosjgIj9b1vUWKGtPRn3pVyiCVENq2ozuBi4
	 hmrVzInjLvfMiDYF1OnYJhK7VfUFSVt+/Kz4czk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 6.1 119/149] net/mlx5: Reload auxiliary devices in pci error handlers
Date: Sun, 13 Aug 2023 23:19:24 +0200
Message-ID: <20230813211722.300542392@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Moshe Shemesh <moshe@nvidia.com>

commit aab8e1a200b926147db51e3f82fd07bb9edf6a98 upstream.

Handling pci errors should fully teardown and load back auxiliary
devices, same as done through mlx5 health recovery flow.

Fixes: 72ed5d5624af ("net/mlx5: Suspend auxiliary devices only in case of PCI device suspend")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1794,7 +1794,7 @@ static pci_ers_result_t mlx5_pci_err_det
 
 	mlx5_enter_error_state(dev, false);
 	mlx5_error_sw_reset(dev);
-	mlx5_unload_one(dev, true);
+	mlx5_unload_one(dev, false);
 	mlx5_drain_health_wq(dev);
 	mlx5_pci_disable_device(dev);
 


