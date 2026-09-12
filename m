Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD88412276;
	Sat, 12 Sep 2026 11:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212161; cv=none; b=s41yHT7CNjsaZTLHBYl4eGARPkPUN3ZPdIGc6IpEDpk0nVzleI5DItTAs1p7cVJzmJ7SiV8ernIq71gdC+gPZxLlRkI19gdo/rRxD58hd1EvuBkArDn5kns8rLWhoWb6yu9VP/AN8cSizM7XrfVJCtXdxE6uFtvBpIBdfiw2e3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212161; c=relaxed/simple;
	bh=4UOCEWwYDAjx3tTRiDCDT91NIbDe8eYYOE0sZXDwd+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3cAJ51Dmwt52ZpdC0joM7DPDUErJidlEHgO7wwDlUVSpxds3LVYwwQG5DN1zz77Ff61gIsFFR1WWWOkeb3/vJXcXY/pFeDS3Vlg+wAvMyjaBH8RTOktt4VA29fePrn3jVuhvGz3bdDMJ5fTQuJMI/FxxDK8qyhzmlBf1T+FvCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yDw2nq50; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yDw2nq50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D078D1F000FF;
	Sat, 12 Sep 2026 11:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212160;
	bh=PGvogzOltB+KN0iGyipj1EXcP8SoNrSM6gRB1mUGduk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yDw2nq50dRyfQ2V5HXz2hf6+SeOf9tOI/3Zal4Rj5oU+gYQ850W3naZ0LSd/WPdS0
	 p6VTPPkB8JE9/vsBLTRU4yiPZfJP4/qtj4PhyUNsaLQ23bCY1FyCHClGWRauzoUP8u
	 H7NUDd665J8S22LIKsvzMmAcMqZzK9zlk4YPnPkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1337/1518] net/mlx5: Add max_tx_speed and its CAP bit to IFC
Date: Sat, 12 Sep 2026 08:58:26 +0200
Message-ID: <20260912065653.773913403@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Or Har-Toov <ohartoov@nvidia.com>

[ Upstream commit 3df5dd46fca4b20efc4767c61d8ecc7249e83f5b ]

Introduce the max_tx_speed field to the query and modify_vport_state
structures.

Add the esw_vport_state_max_tx_speed capability bit, indicating
the firmware support modifying the max_tx_speed field via the
MODIFY_VPORT_STATE command.

Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: ff0f9b7aa1c7 ("net/mlx5: E-Switch, use state lock for vport state changes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mlx5/mlx5_ifc.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 61257b866fb24..0250fdbe082c0 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1071,7 +1071,9 @@ struct mlx5_ifc_e_switch_cap_bits {
 	u8         esw_shared_ingress_acl[0x1];
 	u8         esw_uplink_ingress_acl[0x1];
 	u8         root_ft_on_other_esw[0x1];
-	u8         reserved_at_a[0xf];
+	u8         reserved_at_a[0x1];
+	u8         esw_vport_state_max_tx_speed[0x1];
+	u8         reserved_at_c[0xd];
 	u8         esw_functions_changed[0x1];
 	u8         reserved_at_1a[0x1];
 	u8         ecpf_vport_exists[0x1];
@@ -5443,7 +5445,8 @@ struct mlx5_ifc_query_vport_state_out_bits {
 
 	u8         reserved_at_40[0x20];
 
-	u8         reserved_at_60[0x18];
+	u8         max_tx_speed[0x10];
+	u8         reserved_at_70[0x8];
 	u8         admin_state[0x4];
 	u8         state[0x4];
 };
@@ -7776,7 +7779,7 @@ struct mlx5_ifc_modify_vport_state_in_bits {
 	u8         reserved_at_41[0xf];
 	u8         vport_number[0x10];
 
-	u8         reserved_at_60[0x10];
+	u8         max_tx_speed[0x10];
 	u8         ingress_connect[0x1];
 	u8         egress_connect[0x1];
 	u8         ingress_connect_valid[0x1];
-- 
2.53.0



