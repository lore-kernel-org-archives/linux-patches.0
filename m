Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FECA15E84
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AG4MZu1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF10C433C7;
	Mon, 23 Oct 2023 11:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060626;
	bh=ZwGrSf2jXzGloojFx9tZih46rQLEz6GJmlh0aQyqlrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AG4MZu1MKy+ioFMZzMKqcDpzThxLg3wiMM2ifCvx6OHDI9WsHWZasjzy6Ch1sXgGH
	 Akz7CbsK98fhWrnjfwbA3iUGy0n3jxY1cN0IJBnVyBHv7k6PVMmITsHDZqckppVLG8
	 fv5X8pKwYfNSvU8RjuFQFH/1NA6DbDt4CkIk3M3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Petr Machata <petrm@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 012/123] mlxsw: fix mlxsw_sp2_nve_vxlan_learning_set() return type
Date: Mon, 23 Oct 2023 12:56:10 +0200
Message-ID: <20231023104818.155968264@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104817.691299567@linuxfoundation.org>
References: <20231023104817.691299567@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 1e0b72a2a6432c0ef67ee5ce8d9172a7c20bba25 ]

The mlxsw_sp2_nve_vxlan_learning_set() function is supposed to return
zero on success or negative error codes.  So it needs to be type int
instead of bool.

Fixes: 4ee70efab68d ("mlxsw: spectrum_nve: Add support for VXLAN on Spectrum-2")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
index 05517c7feaa56..a20ba23f0ed7a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
@@ -294,8 +294,8 @@ const struct mlxsw_sp_nve_ops mlxsw_sp1_nve_vxlan_ops = {
 	.fdb_clear_offload = mlxsw_sp_nve_vxlan_clear_offload,
 };
 
-static bool mlxsw_sp2_nve_vxlan_learning_set(struct mlxsw_sp *mlxsw_sp,
-					     bool learning_en)
+static int mlxsw_sp2_nve_vxlan_learning_set(struct mlxsw_sp *mlxsw_sp,
+					    bool learning_en)
 {
 	char tnpc_pl[MLXSW_REG_TNPC_LEN];
 
-- 
2.40.1



