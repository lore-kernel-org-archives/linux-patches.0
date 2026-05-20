Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF42328DC4;
	Wed, 20 May 2026 17:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298488; cv=none; b=LuFdX3nFonUhRA8qYV4WEpdrPTKOtIxhz/KmTticU15HIy+IyStzP+buo1V1Sr1Rg1hFKGjT7aoOVeVYE5GJolu4d+Ymc4xvLKShpmqQmyCOUfqJUkIJdLSFMT61duTqlvbYRxELPiG2+tV5w/PNZO3O9/8kEcBT5e62Anl5jeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298488; c=relaxed/simple;
	bh=nKDxqauD8K3Xp5HaS4K1AWDt+3RDYxljnprNHS8RG9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9VsdKBBS0u++ip7TibruH4xoRKnhlOZ0WSnknPvVwK/hyDsZ/F5lK3y8r2cf+1iS3y1/Jy1lQN7lEUNGDiiZTf2W/CNnZyuf8kD1Rc8aFJ7t8xA0IUzHG71Gtq38XFbYoquMSFVMUOTbczxOo+3ZgYQAaMBc/eFjBuii+nQEMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ea/Q64zu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ea/Q64zu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E15D1F000E9;
	Wed, 20 May 2026 17:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298486;
	bh=qUv9aDFJ0Cpb3rcuF9+2wOKZJYn3ssgRT8eiVo/bIzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ea/Q64zuNEv5He9uWFkhrsDa0EG3ZBjQX8L0xznZ3hBwZzu2Fg4ctC+iuywmfTjXB
	 tomX1UHDllLDegWwySAfscGEtPk3BKkDWZOQ7yIMYWPte4+Av+Q+ii1+kmpn1OpKqF
	 CzTMXm5c3UzYMVQFzGLrgDBVnKZ4q29CoUdFuxsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 428/957] soc/tegra: cbb: Fix incorrect ARRAY_SIZE in fabric lookup tables
Date: Wed, 20 May 2026 18:15:11 +0200
Message-ID: <20260520162143.804161203@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Sumit Gupta <sumitg@nvidia.com>

[ Upstream commit 499f7e5ebbdd9ff0c4d532b1c432f8a61ff585b3 ]

Fix incorrect ARRAY_SIZE usage in fabric lookup tables which could
cause out-of-bounds access during target timeout lookup.

Fixes: 25de5c8fe0801 ("soc/tegra: cbb: Improve handling for per SoC fabric data")
Signed-off-by: Sumit Gupta <sumitg@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/cbb/tegra234-cbb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/tegra/cbb/tegra234-cbb.c b/drivers/soc/tegra/cbb/tegra234-cbb.c
index 518733a066588..626e0e820329b 100644
--- a/drivers/soc/tegra/cbb/tegra234-cbb.c
+++ b/drivers/soc/tegra/cbb/tegra234-cbb.c
@@ -881,7 +881,7 @@ static const struct tegra234_fabric_lookup tegra234_cbb_fab_list[] = {
 				 ARRAY_SIZE(tegra234_common_target_map) },
 	[T234_AON_FABRIC_ID] = { "aon-fabric", true,
 				 tegra234_aon_target_map,
-				 ARRAY_SIZE(tegra234_bpmp_target_map) },
+				 ARRAY_SIZE(tegra234_aon_target_map) },
 	[T234_PSC_FABRIC_ID] = { "psc-fabric" },
 	[T234_BPMP_FABRIC_ID] = { "bpmp-fabric", true,
 				 tegra234_bpmp_target_map,
@@ -1160,7 +1160,7 @@ static const struct tegra234_fabric_lookup tegra241_cbb_fab_list[] = {
 	[T234_CBB_FABRIC_ID]  = { "cbb-fabric", true,
 				  tegra241_cbb_target_map, ARRAY_SIZE(tegra241_cbb_target_map) },
 	[T234_BPMP_FABRIC_ID] = { "bpmp-fabric", true,
-				  tegra241_bpmp_target_map, ARRAY_SIZE(tegra241_cbb_target_map) },
+				  tegra241_bpmp_target_map, ARRAY_SIZE(tegra241_bpmp_target_map) },
 };
 static const struct tegra234_cbb_fabric tegra241_cbb_fabric = {
 	.fab_id = T234_CBB_FABRIC_ID,
-- 
2.53.0



