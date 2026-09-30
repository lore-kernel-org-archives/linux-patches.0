Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C3250EC1C;
	Wed, 30 Sep 2026 16:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786439; cv=none; b=fRuQzCg/LOYWwHrwyWIjJEK5oduYqFCTzGCMDJWT4KiRFo2OoNMX422sUwz/hWg6Y9HvTJdZQI+qoripH65c1AZwg1CSWz3i4gzyGkjpjdFvQiCzpZNT0N7JjVVb4AVXmn/SkjxZPPnht22BF4TwvK4sGGKtM+ff4KFjDOIwHTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786439; c=relaxed/simple;
	bh=k/U+6tR6/CTysOAkNk6rVY1UMlU0pR3QguvgEiIInvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWJMCTSKgXdvTCGDBMXMoZ/BxzE+Vkps2VK3/exRE6iQ1bxViyWfYghz5wQMJ5R1HHBz6n5Pk4oBW41Pfz4SF5+FrEvQNBAiQhZxOelmBqA1LZQW3wFXqmo/vNBGsEoFd2/CBFJHVte6F50ZGNzOyMIuwoI8kIe7k4CiwAsaaa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TZnId4XV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TZnId4XV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF13F1F000FF;
	Wed, 30 Sep 2026 16:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786438;
	bh=AL7Xy72IUkc+GcQR5a/2L2t2v7LJ6m3enOI/rsU9XDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TZnId4XVlNYqsACwq/VSOXBqlfVh6rS/kniCXq/pPSq8MvM5iRIjVM0s5Ojrrce8C
	 j1/XyGuhbvffWPMhNbO2Jo4H/PvBNvfZ1He3YUrLiVESWeFet8ArZyR02imMD3jk3Q
	 JJEqxEqne+nk+6dOUIcRW3pqhYXWVm2cykRRpPQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Buslov <vladbu@nvidia.com>,
	Maor Dickman <maord@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 861/982] net/mlx5: Add mlx5_ifc definitions for bridge multicast support
Date: Wed, 30 Sep 2026 17:26:37 +0200
Message-ID: <20260930152435.241189419@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Buslov <vladbu@nvidia.com>

[ Upstream commit e5688f6fb9e3d0254a8fb1c714c38e407f0baa64 ]

Add the required hardware definitions to mlx5_ifc: fdb_uplink_hairpin,
fdb_multi_path_any_table_limit_regc, fdb_multi_path_any_table.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: 35e6f970f553 ("net/mlx5: Bridge, don't fail switchdev events of sibling eswitch ports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mlx5/mlx5_ifc.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 9610b325f2b61..5fa2e164d0d42 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -865,7 +865,12 @@ enum {
 
 struct mlx5_ifc_flow_table_eswitch_cap_bits {
 	u8      fdb_to_vport_reg_c_id[0x8];
-	u8      reserved_at_8[0xd];
+	u8      reserved_at_8[0x5];
+	u8      fdb_uplink_hairpin[0x1];
+	u8      fdb_multi_path_any_table_limit_regc[0x1];
+	u8      reserved_at_f[0x3];
+	u8      fdb_multi_path_any_table[0x1];
+	u8      reserved_at_13[0x2];
 	u8      fdb_modify_header_fwd_to_table[0x1];
 	u8      fdb_ipv4_ttl_modify[0x1];
 	u8      flow_source[0x1];
-- 
2.53.0



