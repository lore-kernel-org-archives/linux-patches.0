Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FF17406A;
	Mon, 29 Jan 2024 17:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548573; cv=none; b=gMKw7IGXfC/bJaHkFCMIzmOdbZICPXEGzz0eLGfsD5KjsLgiDOyJVyU0Nec6TEP/ONg6sX0+xwaZbc/359wn1V55P7wK6Ng2lkO/wSmV/9QyJZoTPaUwHO1lEwqnltB3xDTngQqU1VScxZvOnubyC0hhFTuiSrGcem4wsdETYp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548573; c=relaxed/simple;
	bh=TYO5jOz4O3xTfTO5SXyq6ZxvSiAZSv3mU7EQtPknC/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZuh+CHWh32vQ9dohfAmtMhgZ1hI9zo5o/6lpY34h56/B9WaHEXRcDu6oQJhEISnJG51zOudNdIO8fWGYxVakOvttK0kdVoinswccMXnJMFJqMHL9C3/vulJQ/ybXWFRDCYLTFPIXeksb9IWrA4gKb9vqObKuOFHlDxBnCDsF3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zlJMmpJi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zlJMmpJi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DE3C43390;
	Mon, 29 Jan 2024 17:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548573;
	bh=TYO5jOz4O3xTfTO5SXyq6ZxvSiAZSv3mU7EQtPknC/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zlJMmpJiS97hE5HXZuGGLVv1c+SBCKpmCfrRMZiTYiSVglPXqAdRf4LpG7xu0eq7+
	 ARsyFJMfiraIRWqMW+cvJQTj/33jsAsuuVii79SfdkMvQZGzx77HPJKHtVCCf+Mfor
	 4Pz1mmL1XmrGi49ka9syUMRoyd7fJ+tGtoD0Zdz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Jianbo Liu <jianbol@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 199/331] net/mlx5: Use mlx5 device constant for selecting CQ period mode for ASO
Date: Mon, 29 Jan 2024 09:04:23 -0800
Message-ID: <20240129170020.702299377@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

[ Upstream commit 20cbf8cbb827094197f3b17db60d71449415db1e ]

mlx5 devices have specific constants for choosing the CQ period mode. These
constants do not have to match the constants used by the kernel software
API for DIM period mode selection.

Fixes: cdd04f4d4d71 ("net/mlx5: Add support to create SQ and CQ for ASO")
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
index 40c7be124041..58bd749b5e4d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
@@ -98,7 +98,7 @@ static int create_aso_cq(struct mlx5_aso_cq *cq, void *cqc_data)
 	mlx5_fill_page_frag_array(&cq->wq_ctrl.buf,
 				  (__be64 *)MLX5_ADDR_OF(create_cq_in, in, pas));
 
-	MLX5_SET(cqc,   cqc, cq_period_mode, DIM_CQ_PERIOD_MODE_START_FROM_EQE);
+	MLX5_SET(cqc,   cqc, cq_period_mode, MLX5_CQ_PERIOD_MODE_START_FROM_EQE);
 	MLX5_SET(cqc,   cqc, c_eqn_or_apu_element, eqn);
 	MLX5_SET(cqc,   cqc, uar_page,      mdev->priv.uar->index);
 	MLX5_SET(cqc,   cqc, log_page_size, cq->wq_ctrl.buf.page_shift -
-- 
2.43.0



