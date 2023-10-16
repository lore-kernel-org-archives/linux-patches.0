Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD03014288
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NbnPrgCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE31C433C9;
	Mon, 16 Oct 2023 14:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467774;
	bh=RtOU1IA90ZK6oMO/nvUNyXaYn3hgdjmGZSbcbcCN+fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NbnPrgCK+4+C0BTQHBAkfsc2bFc21bvnDzw4OoAET+i5l7nU3PF3/AYulObcd4Ugm
	 b8bbCnRK4x9ZspOxRLrvi9+G/r5AoZjEJHJIgfcGpnpV1zXc2DBYLaEka+igo7yk5F
	 xsTphOUZOitUZSoWcZ0a9DUJ0kiPIFJUwWbjq2qU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Petr Machata <petrm@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 063/191] mlxsw: fix mlxsw_sp2_nve_vxlan_learning_set() return type
Date: Mon, 16 Oct 2023 10:40:48 +0200
Message-ID: <20231016084016.870833590@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index bb8eeb86edf75..52c2fe3644d4b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
@@ -310,8 +310,8 @@ const struct mlxsw_sp_nve_ops mlxsw_sp1_nve_vxlan_ops = {
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



