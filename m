Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7A92153FC;
	Thu, 12 Dec 2024 15:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017581; cv=none; b=bCcXNpLo1QFGWCTcyRh28sOlAw+qhpIkFV3Z1MK/oTIihFZf4daoTTj1Awli1arA7MjlGzsB8W88Q4nwabx+OQCTP5U5c6Q/2HiCo2kuCgh8WpnZ9p5onRepixp/AguRpVBiniBYxAMEqfsurp0q9myPFUktBeRZ56hvidN5IDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017581; c=relaxed/simple;
	bh=xYUufvMJp451qWzE0WO/DzoOPD9oiOH+i+ZTSYZV9i4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XyWwzt8Sq+z2UwlUTTz5c5vXz2LVDyVYnuSomb7/QS+8Co2/swGjRtkZ0QVxsOPs+RLXM1xd+HSFtWHS770TVzGsSFKWzjqSQr1w139vqhb1eqgYBqHqt/+hihcWFgWTR9bOz843zV064EgID/sRwfBuEkAQYzkYdu/rB3rgHGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x7kPrPjz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x7kPrPjz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E82C4CECE;
	Thu, 12 Dec 2024 15:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017580;
	bh=xYUufvMJp451qWzE0WO/DzoOPD9oiOH+i+ZTSYZV9i4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x7kPrPjzR0ziXQauXKkk0vIC57DOxrH9eGzG1gqYK3pjsOo1AmFGsqXm3YnEApXvj
	 Jih2CDOWusmkeu+1S9IODnEMEAViG1CXcc63Kb/4XD90Af1UJTnoycXIVs+b/q+ySe
	 +NbslUOqTCeZIQi8ueuFn3R5FotqRPXex8bySkZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Cohen <amcohen@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/356] mlxsw: Add ipv4_5 flex key
Date: Thu, 12 Dec 2024 15:56:13 +0100
Message-ID: <20241212144246.764073178@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Amit Cohen <amcohen@nvidia.com>

[ Upstream commit c2f3e10ac4ebf23e177226b9b4d297bfe2fb6b20 ]

Currently virtual router ID element is broken to two sub-elements -
'VIRT_ROUTER_LSB' and 'VIRT_ROUTER_MSB'. It was broken as this field is
broken in 'ipv4_4' flex key which is used for IPv4 in Spectrum < 4.
For Spectrum-4, we use 'ipv4_4b' flex key which contains one field for
virtual router, this key is not supported in older ASICs.

Add 'ipv4_5' flex key which is supported in all ASICs and contains one
field for virtual router. Then there is no reason to use 'VIRT_ROUTER_LSB'
and 'VIRT_ROUTER_MSB', remove them and add one element 'VIRT_ROUTER' for
this field.

The motivation is to get rid of 'ipv4_4' flex key, as it might be chosen
for IPv6 multicast forwarding region. This will not allow the improvement
in a following patch. See more details in the cover letter and in a
following patch.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 217bbf156f93 ("mlxsw: spectrum_acl_flex_keys: Use correct key block on Spectrum-4")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlxsw/core_acl_flex_keys.c    |  3 +--
 .../ethernet/mellanox/mlxsw/core_acl_flex_keys.h    |  3 +--
 .../net/ethernet/mellanox/mlxsw/spectrum2_mr_tcam.c | 13 ++++---------
 .../mellanox/mlxsw/spectrum_acl_flex_keys.c         | 10 ++++------
 4 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
index bf140e7416e19..5fa3800940c89 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
@@ -33,8 +33,7 @@ static const struct mlxsw_afk_element_info mlxsw_afk_element_infos[] = {
 	MLXSW_AFK_ELEMENT_INFO_U32(IP_TTL_, 0x18, 0, 8),
 	MLXSW_AFK_ELEMENT_INFO_U32(IP_ECN, 0x18, 9, 2),
 	MLXSW_AFK_ELEMENT_INFO_U32(IP_DSCP, 0x18, 11, 6),
-	MLXSW_AFK_ELEMENT_INFO_U32(VIRT_ROUTER_MSB, 0x18, 17, 4),
-	MLXSW_AFK_ELEMENT_INFO_U32(VIRT_ROUTER_LSB, 0x18, 21, 8),
+	MLXSW_AFK_ELEMENT_INFO_U32(VIRT_ROUTER, 0x18, 17, 12),
 	MLXSW_AFK_ELEMENT_INFO_BUF(SRC_IP_96_127, 0x20, 4),
 	MLXSW_AFK_ELEMENT_INFO_BUF(SRC_IP_64_95, 0x24, 4),
 	MLXSW_AFK_ELEMENT_INFO_BUF(SRC_IP_32_63, 0x28, 4),
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h
index 2eac7582c31a8..75e9bbc361701 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h
@@ -33,8 +33,7 @@ enum mlxsw_afk_element {
 	MLXSW_AFK_ELEMENT_IP_TTL_,
 	MLXSW_AFK_ELEMENT_IP_ECN,
 	MLXSW_AFK_ELEMENT_IP_DSCP,
-	MLXSW_AFK_ELEMENT_VIRT_ROUTER_MSB,
-	MLXSW_AFK_ELEMENT_VIRT_ROUTER_LSB,
+	MLXSW_AFK_ELEMENT_VIRT_ROUTER,
 	MLXSW_AFK_ELEMENT_FDB_MISS,
 	MLXSW_AFK_ELEMENT_L4_PORT_RANGE,
 	MLXSW_AFK_ELEMENT_MAX,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum2_mr_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum2_mr_tcam.c
index b1178b7a7f51a..2efcc9372d4e6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum2_mr_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum2_mr_tcam.c
@@ -45,8 +45,7 @@ static int mlxsw_sp2_mr_tcam_bind_group(struct mlxsw_sp *mlxsw_sp,
 }
 
 static const enum mlxsw_afk_element mlxsw_sp2_mr_tcam_usage_ipv4[] = {
-		MLXSW_AFK_ELEMENT_VIRT_ROUTER_MSB,
-		MLXSW_AFK_ELEMENT_VIRT_ROUTER_LSB,
+		MLXSW_AFK_ELEMENT_VIRT_ROUTER,
 		MLXSW_AFK_ELEMENT_SRC_IP_0_31,
 		MLXSW_AFK_ELEMENT_DST_IP_0_31,
 };
@@ -89,8 +88,7 @@ static void mlxsw_sp2_mr_tcam_ipv4_fini(struct mlxsw_sp2_mr_tcam *mr_tcam)
 }
 
 static const enum mlxsw_afk_element mlxsw_sp2_mr_tcam_usage_ipv6[] = {
-		MLXSW_AFK_ELEMENT_VIRT_ROUTER_MSB,
-		MLXSW_AFK_ELEMENT_VIRT_ROUTER_LSB,
+		MLXSW_AFK_ELEMENT_VIRT_ROUTER,
 		MLXSW_AFK_ELEMENT_SRC_IP_96_127,
 		MLXSW_AFK_ELEMENT_SRC_IP_64_95,
 		MLXSW_AFK_ELEMENT_SRC_IP_32_63,
@@ -189,11 +187,8 @@ mlxsw_sp2_mr_tcam_rule_parse(struct mlxsw_sp_acl_rule *rule,
 
 	rulei = mlxsw_sp_acl_rule_rulei(rule);
 	rulei->priority = priority;
-	mlxsw_sp_acl_rulei_keymask_u32(rulei, MLXSW_AFK_ELEMENT_VIRT_ROUTER_LSB,
-				       key->vrid, GENMASK(7, 0));
-	mlxsw_sp_acl_rulei_keymask_u32(rulei,
-				       MLXSW_AFK_ELEMENT_VIRT_ROUTER_MSB,
-				       key->vrid >> 8, GENMASK(3, 0));
+	mlxsw_sp_acl_rulei_keymask_u32(rulei, MLXSW_AFK_ELEMENT_VIRT_ROUTER,
+				       key->vrid, GENMASK(11, 0));
 	switch (key->proto) {
 	case MLXSW_SP_L3_PROTO_IPV4:
 		return mlxsw_sp2_mr_tcam_rule_parse4(rulei, key);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
index cb746a43b24b3..cc00c8d69eb77 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
@@ -171,9 +171,8 @@ static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv4_2[] = {
 	MLXSW_AFK_ELEMENT_INST_U32(IP_PROTO, 0x04, 16, 8),
 };
 
-static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv4_4[] = {
-	MLXSW_AFK_ELEMENT_INST_U32(VIRT_ROUTER_LSB, 0x04, 24, 8),
-	MLXSW_AFK_ELEMENT_INST_EXT_U32(VIRT_ROUTER_MSB, 0x00, 0, 3, 0, true),
+static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv4_5[] = {
+	MLXSW_AFK_ELEMENT_INST_EXT_U32(VIRT_ROUTER, 0x04, 20, 11, 0, true),
 };
 
 static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv6_0[] = {
@@ -220,7 +219,7 @@ static const struct mlxsw_afk_block mlxsw_sp2_afk_blocks[] = {
 	MLXSW_AFK_BLOCK(0x38, mlxsw_sp_afk_element_info_ipv4_0),
 	MLXSW_AFK_BLOCK(0x39, mlxsw_sp_afk_element_info_ipv4_1),
 	MLXSW_AFK_BLOCK(0x3A, mlxsw_sp_afk_element_info_ipv4_2),
-	MLXSW_AFK_BLOCK(0x3C, mlxsw_sp_afk_element_info_ipv4_4),
+	MLXSW_AFK_BLOCK(0x3D, mlxsw_sp_afk_element_info_ipv4_5),
 	MLXSW_AFK_BLOCK(0x40, mlxsw_sp_afk_element_info_ipv6_0),
 	MLXSW_AFK_BLOCK(0x41, mlxsw_sp_afk_element_info_ipv6_1),
 	MLXSW_AFK_BLOCK(0x42, mlxsw_sp_afk_element_info_ipv6_2),
@@ -323,8 +322,7 @@ static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_mac_5b[] = {
 };
 
 static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv4_4b[] = {
-	MLXSW_AFK_ELEMENT_INST_U32(VIRT_ROUTER_LSB, 0x04, 13, 8),
-	MLXSW_AFK_ELEMENT_INST_U32(VIRT_ROUTER_MSB, 0x04, 21, 4),
+	MLXSW_AFK_ELEMENT_INST_U32(VIRT_ROUTER, 0x04, 13, 12),
 };
 
 static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv6_2b[] = {
-- 
2.43.0



