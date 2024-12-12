Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73997212F9E;
	Thu, 12 Dec 2024 15:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017589; cv=none; b=J4Wb56/Tw+Wy8uiXlsY1LwMaBm/1Ysg9JQmVgU7038RhMDwuq9I9H1hdX1JluO7Ove/zj1VM5EppN/EghxXmVP9TTIn4vmNzj6Qh4S8VwRbBS9nKkjwJGRgkDBpilKl+bP3f2Lhm+DxauK6rkKbusUsGUX69Dv0tv5JWl1fXbmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017589; c=relaxed/simple;
	bh=2A5EAs1lcK/sUFCd8GCKz4M8bPsuunPa25kAVD4MmjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7liWmphNOgeeJS/j482+PwmxmoWsXIfGbNajQ+su4PEV4h30/hW5Zs+kVCcSdINVShnp6PRQgFlzUmglFFkIH7ussgRljHsVEN5CWZnzZ4BGqY0z6L1mwFRkiwlCXe1c80JqqEGFSfmF6kLd9yeGyxAametc/63a9H2Dd1sOBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xrbDz7Ls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xrbDz7Ls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3513C4CECE;
	Thu, 12 Dec 2024 15:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017589;
	bh=2A5EAs1lcK/sUFCd8GCKz4M8bPsuunPa25kAVD4MmjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xrbDz7Lse14LrrZsGg+FekpfbWGKI7uoBZyiJmub61tBkthGZ0bFSqr0RQviTev1T
	 OpLL/V4bjzPZ/MBmcudpFYvsGdLGwPzVedk1urjVyjxJ7RysjLUNcgIp65aiLfu3dk
	 fleJQBDtZnifJP4LyOkvJBsU1ShzkB6b4uuO1HIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Cohen <amcohen@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/356] mlxsw: spectrum_acl_flex_keys: Add ipv4_5b flex key
Date: Thu, 12 Dec 2024 15:56:14 +0100
Message-ID: <20241212144246.803955106@linuxfoundation.org>
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

[ Upstream commit c6caabdf3e0cc50ba4a44bebc82cda5551d81d4f ]

The previous patch replaced the key block 'ipv4_4' with 'ipv4_5'. The
corresponding block for Spectrum-4 is 'ipv4_4b'. To be consistent, replace
key block 'ipv4_4b' with 'ipv4_5b'.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 217bbf156f93 ("mlxsw: spectrum_acl_flex_keys: Use correct key block on Spectrum-4")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c    | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
index cc00c8d69eb77..7d66c4f2deeaa 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
@@ -321,8 +321,8 @@ static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_mac_5b[] = {
 	MLXSW_AFK_ELEMENT_INST_EXT_U32(SRC_SYS_PORT, 0x04, 0, 9, -1, true), /* RX_ACL_SYSTEM_PORT */
 };
 
-static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv4_4b[] = {
-	MLXSW_AFK_ELEMENT_INST_U32(VIRT_ROUTER, 0x04, 13, 12),
+static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv4_5b[] = {
+	MLXSW_AFK_ELEMENT_INST_U32(VIRT_ROUTER, 0x04, 20, 12),
 };
 
 static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv6_2b[] = {
@@ -339,7 +339,7 @@ static const struct mlxsw_afk_block mlxsw_sp4_afk_blocks[] = {
 	MLXSW_AFK_BLOCK(0x38, mlxsw_sp_afk_element_info_ipv4_0),
 	MLXSW_AFK_BLOCK(0x39, mlxsw_sp_afk_element_info_ipv4_1),
 	MLXSW_AFK_BLOCK(0x3A, mlxsw_sp_afk_element_info_ipv4_2),
-	MLXSW_AFK_BLOCK(0x35, mlxsw_sp_afk_element_info_ipv4_4b),
+	MLXSW_AFK_BLOCK(0x36, mlxsw_sp_afk_element_info_ipv4_5b),
 	MLXSW_AFK_BLOCK(0x40, mlxsw_sp_afk_element_info_ipv6_0),
 	MLXSW_AFK_BLOCK(0x41, mlxsw_sp_afk_element_info_ipv6_1),
 	MLXSW_AFK_BLOCK(0x47, mlxsw_sp_afk_element_info_ipv6_2b),
-- 
2.43.0



