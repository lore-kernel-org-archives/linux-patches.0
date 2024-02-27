Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A69354BD4;
	Tue, 27 Feb 2024 13:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042223; cv=none; b=pJiKQYnRWZV6snaV6PGahPK5S5sM+SBauVjmUw39wcS2yCpk9dw6UZrtJNScXl9BNWQU9t60ECu6ShsiOLnt39+1+dGBS4AE1E0gmeV8412u/W/E0dGzWiJkf+NdF0m932uUKEgGX9A+nBkY6XHCssFrsGX7jc6nR6nWL614fgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042223; c=relaxed/simple;
	bh=KOAjKEEH9u003kvICTRN0RcQnmW/mIctr+MIpihvHqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRWp9l3jwkoPLYw80g/20FTyinqixyUDBXCD6u7nOFGP1KhcAIw1HEqXzpKGyF7txHjL96V4MuFSWv1CYGXDzhxl5E+77ADrCrwiFE7TzSIMuO5mgQGbSKQ4x1fs4Lld5ml0QfPHnAmUE+hLbL7JVgsdieXitZY/ko9K+ZlpB00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TL9c//oG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TL9c//oG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA360C433F1;
	Tue, 27 Feb 2024 13:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042223;
	bh=KOAjKEEH9u003kvICTRN0RcQnmW/mIctr+MIpihvHqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TL9c//oGXR/pb7oVXlpGcAhUzQLuBdw34uSSQq1z79dG4O7Z+ffLfnpPCYW0qiFL7
	 JRU7+6b70gLlXmsdIk10nwDKCxnM2ziu3nz0j5UoqfVwVEffajf/i0Hz/+xW7EFxBC
	 pLiASdK4bmMw/8/Oi+lC/M5nwrP7a7W8LJ37sm9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Srouji <edwards@nvidia.com>,
	Mark Zhang <markzhang@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 214/299] IB/mlx5: Dont expose debugfs entries for RRoCE general parameters if not supported
Date: Tue, 27 Feb 2024 14:25:25 +0100
Message-ID: <20240227131632.670181978@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Mark Zhang <markzhang@nvidia.com>

[ Upstream commit 43fdbd140238d44e7e847232719fef7d20f9d326 ]

debugfs entries for RRoCE general CC parameters must be exposed only when
they are supported, otherwise when accessing them there may be a syndrome
error in kernel log, for example:

$ cat /sys/kernel/debug/mlx5/0000:08:00.1/cc_params/rtt_resp_dscp
cat: '/sys/kernel/debug/mlx5/0000:08:00.1/cc_params/rtt_resp_dscp': Invalid argument
$ dmesg
 mlx5_core 0000:08:00.1: mlx5_cmd_out_err:805:(pid 1253): QUERY_CONG_PARAMS(0x824) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0x325a82), err(-22)

Fixes: 66fb1d5df6ac ("IB/mlx5: Extend debug control for CC parameters")
Reviewed-by: Edward Srouji <edwards@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Link: https://lore.kernel.org/r/e7ade70bad52b7468bdb1de4d41d5fad70c8b71c.1706433934.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/cong.c | 6 ++++++
 include/linux/mlx5/mlx5_ifc.h     | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/cong.c b/drivers/infiniband/hw/mlx5/cong.c
index f87531318feb8..a78a067e3ce7f 100644
--- a/drivers/infiniband/hw/mlx5/cong.c
+++ b/drivers/infiniband/hw/mlx5/cong.c
@@ -458,6 +458,12 @@ void mlx5_ib_init_cong_debugfs(struct mlx5_ib_dev *dev, u32 port_num)
 	dbg_cc_params->root = debugfs_create_dir("cc_params", mlx5_debugfs_get_dev_root(mdev));
 
 	for (i = 0; i < MLX5_IB_DBG_CC_MAX; i++) {
+		if ((i == MLX5_IB_DBG_CC_GENERAL_RTT_RESP_DSCP_VALID ||
+		     i == MLX5_IB_DBG_CC_GENERAL_RTT_RESP_DSCP))
+			if (!MLX5_CAP_GEN(mdev, roce) ||
+			    !MLX5_CAP_ROCE(mdev, roce_cc_general))
+				continue;
+
 		dbg_cc_params->params[i].offset = i;
 		dbg_cc_params->params[i].dev = dev;
 		dbg_cc_params->params[i].port_num = port_num;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 51eb83f779388..643e9ba4e64bd 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1102,7 +1102,7 @@ struct mlx5_ifc_roce_cap_bits {
 	u8         sw_r_roce_src_udp_port[0x1];
 	u8         fl_rc_qp_when_roce_disabled[0x1];
 	u8         fl_rc_qp_when_roce_enabled[0x1];
-	u8         reserved_at_7[0x1];
+	u8         roce_cc_general[0x1];
 	u8	   qp_ooo_transmit_default[0x1];
 	u8         reserved_at_9[0x15];
 	u8	   qp_ts_format[0x2];
-- 
2.43.0



