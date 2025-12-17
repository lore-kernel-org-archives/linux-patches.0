Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D0E3590CE
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 13:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765979380; cv=fail; b=a/bxQqkoGbqsckLEVBmfocRwPzl5NbI8dzZXaa2yxvxihWBMRRfa0WxlPNxx/dJpo2P2ikc5RhpmhZiEs+K/Ka3SNtxTtzXo7FblX42W88AQHKjIJh6O2ytF/nohVvV5ISCMNM+KljqpQmrkHbFjWn2BXIytvNKJqTYKWEIBhw0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765979380; c=relaxed/simple;
	bh=0BNS8B+fu6Q8DQGFyPoiwOcIi/Z2HmmHG/UFNNQWOxs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PyFVgmlMObfe5RvxF1zjhgFqoZQQzWsVGOXRClX5XeT112HEYavJeIcA1el2s1teHxS4H8GbIosZEMUuYXPI4Txqf14Z57KEcWQ/vSzER2BCH6LYoZwFRoZx5OpAzG4955E8ha7CdVxIT1cSu14eGMYTk4khzf9yoga/VzHS7Uk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=A0vNpclA; arc=fail smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="A0vNpclA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B403C113D0
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 13:49:39 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="A0vNpclA"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Wed, 17 Dec 2025 13:49:36 +0000
Resent-Message-ID: <aUK08A0Efa9pLeFP@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by 172-238-120-221.ip.linodeusercontent.com (Postfix) with ESMTPS id 9B45F231EE
	for <broonie@sirena.co.uk>; Wed, 17 Dec 2025 13:26:44 +0000 (UTC)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8FE7C601A5
	for <broonie@sirena.co.uk>; Wed, 17 Dec 2025 13:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 5C5BFC116B1; Wed, 17 Dec 2025 13:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5D75BC4CEF5
	for <broonie@kernel.org>; Wed, 17 Dec 2025 13:26:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 5D75BC4CEF5
Authentication-Results: smtp.kernel.org; dmarc=fail (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xGQ/Jk+SZHVJVw0fpHf7RZj90KMeJV7YGWYLe8+qsYLrtOJbTH52odW5tkcdtiZ6ZXt4cd5QS9I/VGEjcXn5fcwXxyPeZOkOKN5NKT8jUFGaoKYd+ZmwdndPoaw4zUViRHolqRU4rmaY6W5tSmgKaOUomW4PD5bLRzoRo+wfZP1JoyW2Mtr6MxIIhfjyq6oZIv/gfv5exWDyIixE8L7SHvFZzG25lUw32kdKzhcZx0zvvTyZdxBdyvrpbbVhwfQ8E53wQ1fBkODzYyBISnZtc9snz8YQy25RhWp8ThhZfFu4RIFTLDQudxnpjMtTrzQxGWc8tgTJQhXXFEb5Z8pHXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K+TerinaU+XT5QWtYMDcXaRW73ldHLXbGQh+LzqzUWg=;
 b=a+VmzXuTGAn3GnRBKkulwNHiOS2c9j6LmISsd1U2SMuCj1DS208yEnwGIg/GhV/A4dC4b09b6jExUEL0mxUQ0v5p5eCZwgdoAJTen5munpPT0QuUKBTW0nF4WOAoEVuluq64d4W7FGAqSLi74coqnMs+QCP9Mr4aDbirrRQhbg4XPSBOqAOhcMw7jLIReVjy2+yaFfP/hxYVt+SFdic/NNY6IygsvTok8BJtbx7tYuac1UN6Tia7WaiN1osC5nXmY3LDwBkIt+3bE0j9kz0Jm5xlXplXnFgZaVoV+po9+27Hp3G+bLos6nacFJ5vtv+05JH7exztKogkDKN6R2j5UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K+TerinaU+XT5QWtYMDcXaRW73ldHLXbGQh+LzqzUWg=;
 b=A0vNpclAZBQFf27Cwbf5ylczYj+ERP4PpF+z78avwV7FcRR/g6g+l4n5eUba0yZl0/aHUrCveob+/Cfy057yv05Sys7ILH24nSwrwk3w0H8NJgWjO4x48sJNke4Uab/GkLLAvgP/F2WHX/BCUPCrpjiJMSjdhh+s2ubJGbPCBOvzo2lVfNKhWhDBYTDbCL4jXHP/+2C6UR8FNNXKNqcYeh59K8g/W7WMadM3PJWvifIm4gABoaikXPovemcAzsynLvHb1zzp8o7ItWRvWe8NqjLGWmT01hTf6vzZAnOtDwMWn8ANcjrW5rzVIrbJYxlYRzPQYLR75kx2+QI+HvZN1Q==
Received: from CH0PR13CA0022.namprd13.prod.outlook.com (2603:10b6:610:b1::27)
 by SA1PR12MB7318.namprd12.prod.outlook.com (2603:10b6:806:2b3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 13:26:38 +0000
Received: from CH2PEPF0000009B.namprd02.prod.outlook.com
 (2603:10b6:610:b1:cafe::65) by CH0PR13CA0022.outlook.office365.com
 (2603:10b6:610:b1::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6 via Frontend Transport; Wed,
 17 Dec 2025 13:26:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH2PEPF0000009B.mail.protection.outlook.com (10.167.244.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Wed, 17 Dec 2025 13:26:35 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 17 Dec
 2025 05:26:16 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 17 Dec
 2025 05:26:16 -0800
Received: from sheetal.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Wed, 17 Dec 2025 05:26:12 -0800
From: "Sheetal ." <sheetal@nvidia.com>
To: <linux-sound@vger.kernel.org>, Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>, Thierry Reding <thierry.reding@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>, Charles Keepax
	<ckeepax@opensource.cirrus.com>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, sheetal <sheetal@nvidia.com>
Subject: [PATCH] ASoC: tegra: Revert fix for uninitialized flat cache warning in tegra210_ahub
Date: Wed, 17 Dec 2025 18:55:24 +0530
Message-ID: <20251217132524.2844499-1-sheetal@nvidia.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009B:EE_|SA1PR12MB7318:EE_
X-MS-Office365-Filtering-Correlation-Id: d192aef0-4bd9-4e5c-3f52-08de3d6fe6fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3Dg8KwrzYiun8j5A9Y2RnCAm4J3GBoDN/yJbfcga4/Q9W8RQTT6pptIzHRc5?=
 =?us-ascii?Q?ueuGm9OXd+6+6miwoc6WGp/q8zsactleU4so+RNE4lCpfW7zv0YWfAjRFOdQ?=
 =?us-ascii?Q?dnpeu9oCVB2p2vzKn7DxMxSqHuYQpJlG1XJAD0uN9kkYbNUNEXjlvOotA6g0?=
 =?us-ascii?Q?ykBmJmAeLk4NR6rUg5PAOBaW+AyK4Nrmd91V9XXufRWduufYOiTwFM9w25OK?=
 =?us-ascii?Q?NmBhHpodaXOINNTeHPNoendZ6VerTTqdCiCLcIjKtLGMx/ESFjMi7fm10t7X?=
 =?us-ascii?Q?/AEIHMhzFRBgXo2IxGP/S8XqrIVKDCtAUWHTa5g0QUGfxwyK19jKPiPYdMh1?=
 =?us-ascii?Q?FgDYJu4zlfoSOh97+aLTRry/05BXaOibSuSxqxRK9cstNHNu5/ooen+HexIG?=
 =?us-ascii?Q?6EzAbhcwk9/v/r2Ds0XmKUgrESfxuk8CDAeSz/SFdOE5Vm2x3Vzb/qA1JAjJ?=
 =?us-ascii?Q?L2/qxZog8cIp/9QUyg0nJ++TH1RV0O3D04kcSk30NF+PqKHlBok0ktK00zyU?=
 =?us-ascii?Q?U/C4klwaLwR8bf9veV7HXy7qBm3x5zc3Omhc9vrcYwkfSs0424clTcVYfcIF?=
 =?us-ascii?Q?fycckOoqcCsTtetTbMrHJ9HLq7Ppng0OsUNDhKQlp+Zgy1rlK2XG8sdYTcBd?=
 =?us-ascii?Q?Rel2si9ult+xS4M0XovmAyR+tnI/L7BqIz+K8ouQErcx5iAzq6hh743Tv7PW?=
 =?us-ascii?Q?Lb2m6K7/1WMJ2vO95yW3TGrd4fZqyrolm4DiwnirA67MAmlyPvVJtL7s4+p6?=
 =?us-ascii?Q?O3SH8xvnuIcw+iLHfdlo2lYUTLHFp3f3MfmPWJz9eMlnWFk55Wju+nxTvpzN?=
 =?us-ascii?Q?pd/1wqBGeWYkFx6ddnwBiBBd3DgDSZNiatd7hmZYLOPB8czVP1JBWkruvQiS?=
 =?us-ascii?Q?us6JmMQW1ueCthqLaLAAh+toj8NFu427MqX8yH4Eqg03iM9n+BmGeBd8ZCmz?=
 =?us-ascii?Q?LX8E/sf90zXDtjchnQNsbw9Z0AOu1fGzX0dHeu9usncgm/wupY9Wsozzy92q?=
 =?us-ascii?Q?wWVsHHmmwcOZCzYb22cH6+36h9xcFJTC32aaGd0y5DhUNhJZy1Kceod7tm6O?=
 =?us-ascii?Q?KpjpMf7/K5bJBi7Fu+qO9YiSFeYlcp+xuUmWf6ZC9No1mquJT6aFRk0+Yw7X?=
 =?us-ascii?Q?7SMlgghU/j4qz49cr4ozJohcS6cQUztH+btbiH/tYicqFaCq+dwMmsLD01QC?=
 =?us-ascii?Q?tWlL6rdKc4QipediUQJY7o60p/RtzyOtvTW7BaOevSm+02xWHMl49itQRRPp?=
 =?us-ascii?Q?ym2brZksJaJZDy+XjMUkYifhAZ3QgI7n/VMItitfTowNP1HuJwMeDiGKLjZQ?=
 =?us-ascii?Q?sEUJ6o9gy0TdsodhKZYGU5ya0y3cwIMRMuMZfyzjKLJn21W5UoUqa45Uskkg?=
 =?us-ascii?Q?AxLa6crUr0R048UmiIkBiI8uJijkQjYkFTwbjFNdwUs64MRY7ihvaMw5sEzz?=
 =?us-ascii?Q?qz8FDK92tS6Gr4pp7Kjz5LXBi+7BXmRUpD9iV82SaJeur5zoZ3vk3mihfW5E?=
 =?us-ascii?Q?GbO9AFhlmw3UQyYT03Gd/zz1XOHf3+KfWM5lsZ/Dq6PNgw/gMqpbuPoV0BfX?=
 =?us-ascii?Q?pQhqOH+MRpxaWnGj+Nc=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 13:26:35.7561
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d192aef0-4bd9-4e5c-3f52-08de3d6fe6fc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7318

From: sheetal <sheetal@nvidia.com>

Commit 4d4021b0bbd1 ("ASoC: tegra: Fix uninitialized flat cache warning
in tegra210_ahub") attempted to fix the uninitialized flat cache warning
that is observed for the Tegra210 AHUB driver. However, the change broke
various audio tests because an -EBUSY error is returned when accessing
registers from cache before they are read from hardware. Revert this
change for now, until a proper fix is available.

Fixes: 4d4021b0bbd1 ("ASoC: tegra: Fix uninitialized flat cache warning in tegra210_ahub")
Signed-off-by: sheetal <sheetal@nvidia.com>
---
 sound/soc/tegra/tegra210_ahub.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/tegra/tegra210_ahub.c b/sound/soc/tegra/tegra210_ahub.c
index 261d9067d27b..e795907a3963 100644
--- a/sound/soc/tegra/tegra210_ahub.c
+++ b/sound/soc/tegra/tegra210_ahub.c
@@ -2077,7 +2077,7 @@ static const struct regmap_config tegra210_ahub_regmap_config = {
 	.val_bits		= 32,
 	.reg_stride		= 4,
 	.max_register		= TEGRA210_MAX_REGISTER_ADDR,
-	.cache_type		= REGCACHE_FLAT_S,
+	.cache_type		= REGCACHE_FLAT,
 };
 
 static const struct regmap_config tegra186_ahub_regmap_config = {
@@ -2085,7 +2085,7 @@ static const struct regmap_config tegra186_ahub_regmap_config = {
 	.val_bits		= 32,
 	.reg_stride		= 4,
 	.max_register		= TEGRA186_MAX_REGISTER_ADDR,
-	.cache_type		= REGCACHE_FLAT_S,
+	.cache_type		= REGCACHE_FLAT,
 };
 
 static const struct regmap_config tegra264_ahub_regmap_config = {
@@ -2094,7 +2094,7 @@ static const struct regmap_config tegra264_ahub_regmap_config = {
 	.reg_stride		= 4,
 	.writeable_reg		= tegra264_ahub_wr_reg,
 	.max_register		= TEGRA264_MAX_REGISTER_ADDR,
-	.cache_type		= REGCACHE_FLAT_S,
+	.cache_type		= REGCACHE_FLAT,
 };
 
 static const struct tegra_ahub_soc_data soc_data_tegra210 = {
-- 
2.34.1

