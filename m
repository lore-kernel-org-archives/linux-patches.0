Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130321DA60C;
	Tue,  8 Oct 2024 12:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391149; cv=none; b=okzsy9kIoyKeQ+rn41BKLC7qY1D8iRa/FteJSzCiUvFoE/qzRTdY29cMQuHMTAZ2sEjMLr/fDb84Jun29weNPhJMo/EN/u8PIMYo6BHRK7XA40Rloq4r3s3xWwHcchuabu6dCUPPmDfpoYWgIRMumDq8f4i+NBQ8gsNJSVPw0wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391149; c=relaxed/simple;
	bh=1WhKxZVfRdnq5lPXscrnDyhYCUAGUgR0Yktk/3h1Fa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebK+W1rLb7cQ869qQ8FHhVj1ELF8VE/mPdqdN8umT217jE9Izmp4Xntx9wzvb/xJjykYvc9uI5iQ4irHPUUJv8D31DvctCn3fjuarpDxN2GXCfv2hYu4fQEDYVkYo6J3QzKF9IOWKfJqhbg+BKyATSJMW8Zv5oocbavKSLgSDWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ze+N7St6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ze+N7St6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD0EC4CEC7;
	Tue,  8 Oct 2024 12:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391148;
	bh=1WhKxZVfRdnq5lPXscrnDyhYCUAGUgR0Yktk/3h1Fa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ze+N7St6HVRBtcmAYUKruaK3Xn48j7IyN5gXw+Y/QATxo+F4n/s6rPw+rqIq2Pn+Y
	 S1eBOfv6wJ0KQnLrBpsKXIFyrkgxUNPxpZ3ACEA+5gv3+gfj2NpwzCwCXWzLavI0pE
	 fvWUtZd6QeaevyPAs1m98ZmkhUOBvNhJJqOy4mBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elena Salomatkina <esalomatkina@ispras.ru>,
	Simon Horman <horms@kernel.org>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 022/558] net/mlx5e: Fix NULL deref in mlx5e_tir_builder_alloc()
Date: Tue,  8 Oct 2024 14:00:52 +0200
Message-ID: <20241008115703.097688548@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Elena Salomatkina <esalomatkina@ispras.ru>

[ Upstream commit f25389e779500cf4a59ef9804534237841bce536 ]

In mlx5e_tir_builder_alloc() kvzalloc() may return NULL
which is dereferenced on the next line in a reference
to the modify field.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: a6696735d694 ("net/mlx5e: Convert TIR to a dedicated object")
Signed-off-by: Elena Salomatkina <esalomatkina@ispras.ru>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tir.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c
index d4239e3b3c88e..11f724ad90dbf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c
@@ -23,6 +23,9 @@ struct mlx5e_tir_builder *mlx5e_tir_builder_alloc(bool modify)
 	struct mlx5e_tir_builder *builder;
 
 	builder = kvzalloc(sizeof(*builder), GFP_KERNEL);
+	if (!builder)
+		return NULL;
+
 	builder->modify = modify;
 
 	return builder;
-- 
2.43.0



