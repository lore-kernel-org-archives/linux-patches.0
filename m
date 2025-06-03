Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2057.outbound.protection.outlook.com [40.107.220.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585493D3B8;
	Tue,  3 Jun 2025 19:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748978091; cv=fail; b=h4jS39YTFuQEJlEkWWbFgXz3wMJogOZpYjaeKrrTJALPYw31plCUiFyU86wKmi1XnB9d0hNxtSrdwb2joqSnAVMcl1O7npbqtj3LOh2k7LOBNae7JgE0yiqrwVx+lCRgD5o0Wfpa76MrsaQxCNrDyDxNLpneHGsIpD08V2Q6jCI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748978091; c=relaxed/simple;
	bh=nxVTU9iHEs7UjiHVamMX0cjlGgN3c+DwtHYB0mw9B/A=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=MoRML26mjJRwr+cczNvmAa4eWQSjEDsFirU0K4bp512EL4+n5zkgYiJLxiGP3hVi4Tc6BEiRULSVnSDOORlcxLQfTPliZQOwgqKYw6FMPD+Kg7KnmGlPfi8IMMsC8rfavPUXd2SZzxQjVlRYMye7RDoBUGufnCe1R/i1NjN2n88=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ao0NrVPs; arc=fail smtp.client-ip=40.107.220.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ao0NrVPs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gkUW14Cqe595aLnYAw4WR13CG57p5fz1pGbwfOG0/KxQY1G1fDbeFKFBVxalKaZMdHf7wwc9Qy96eWjYVVA5IcsWGPBIl5F1xJ+UJOuiRz50SACTQhBUtqZyWGpqMhkxXgIXArEdxhgGsKsUGVU2/zrYw+QKmtEtwc1x0kHY8G9e/m0CaUCUYaDkpLb7VcxkqyJCj/1Vmm5B2osut4vMQTMcKpjp98TCXOtxfneaqQApW649AJuiAI4Gg+uWgNzjwaJKLYAW4pPwieQLI9K3HVcM1CH5Arf/TjkVAIzEq3bTHzWsTFi5tpBLEXdu54OW0p8s6rkfNUebqEy3oNnSlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4BawoQ/Uha0YiAo7iJQrr/3yAaKEvV3M8JwDXHRKSd4=;
 b=yP3Rknis5NMVkiayXRkbynF5Xd9gfyzLjqijsGQTbiTnbHoheRgxcjghcLNVipvax51DVBnNb+GOCwoap4Xd1Y9piwf24mgSa/6U2JRV5rW1d+MzVMmhCnohgE3Vt4pfSffU9OR0PueQFiJiYvTPl8YLZDx0T8SKMjugZ3DUwNYXGknwYWeNMFxQKT7Ic9QLG82xv/O5kJHl9H4OU7NPaiSGWqFpaJniKd8p9baaX3TWVq5nrZal/33UGXtOjfQHR+cTXu6ZwhILyuJ8KGqSLWcZ1tAgqlSj219aG6xmxhEYDp6jMu5njFm5gL+aPkGjwBl1jAanUkfHjB5olE6bCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4BawoQ/Uha0YiAo7iJQrr/3yAaKEvV3M8JwDXHRKSd4=;
 b=ao0NrVPszDPds2d15DGpD5cYfpQjZK5P7PJw6CgFJ9OoqvJFtckWYdcv7LEJNtcCmKJvN6HSSUuvdhbArMN8LGNw1zTA1+dzK7EhGzcyDfvivQOWFtQ8ld5OOfscboaMqZI1HwAdJ613ezzZHaeWGAC0IDJ9jD7/ueHlJBm9/qBzMuSqBmz2m3Qj1QBnzlPxEXehsB6315+xulDpvNlTt+GI4m/kipaBHmBUSmE7jynGWBEyzZIc+R03KnddEo4U8wQ1bWZa09EKhjmKvoXWN2/vnEvPEOYOKBc/PN33lTX0uhhuSNmzsstXKotStdSVScnutDp7lH6VefRYMuWKGA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BN5PR12MB9461.namprd12.prod.outlook.com (2603:10b6:408:2a8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.36; Tue, 3 Jun
 2025 19:14:47 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8792.034; Tue, 3 Jun 2025
 19:14:47 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	linux-tegra@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Krishna Reddy <vdumpa@nvidia.com>,
	Will Deacon <will@kernel.org>
Cc: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>,
	Joerg Roedel <jroedel@suse.de>,
	patches@lists.linux.dev
Subject: [PATCH rc] iommu/terga: Fix incorrect size calculation
Date: Tue,  3 Jun 2025 16:14:45 -0300
Message-ID: <0-v1-da7b8b3d57eb+ce-iommu_terga_sizeof_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:208:256::26) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BN5PR12MB9461:EE_
X-MS-Office365-Filtering-Correlation-Id: 6dde3141-dd3a-4012-197c-08dda2d2e789
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5GNhrG/eEAcqLjDS2zXp67CVhXL5tCHEUaRFvlAjm5Dhhf6oxTL+qyilcNto?=
 =?us-ascii?Q?zcIXmaEF66Fk9AlCi+4P6yffE3RErmSwM7fgAv16ZGiCoUexEA1H8xrkjA/Y?=
 =?us-ascii?Q?oCIyb2Pb05Udb4eKf8/X7HYSf3Z20bqF2Id1d4HgSu/mBP894SHJse3bn48d?=
 =?us-ascii?Q?ydB067BXN3VxI3nycdnCrwpf15rkjATvIe8VSBDB1nTcOt1Dd9/ICJinXlN8?=
 =?us-ascii?Q?B/bywc6Iem7jQpqx3iH1k6sQZLceW+0fvBftwOsFyZy5Z/gC6u4vBTt8GHhH?=
 =?us-ascii?Q?/bsvE+UExYQq3r2mutuB/PtsXBA8E4IK7bqCHiQWuNGzE/cdUWQcE6lYeGk1?=
 =?us-ascii?Q?Fv5u3paPAfx0cx1mO/31AxSR+QDWZHW+JXrockWmkBzQovI6S3Dm6f75RJgw?=
 =?us-ascii?Q?1QOOUngRr8PnXauCkKlz491F7JsTY2VEqJHO2qFmNtnk1KlDB72CD4vh149l?=
 =?us-ascii?Q?bfxDFkWACPM63Wr4BpC2hImJUPSo5lfG4FK06VSntEazm3ht2LtzljV2uVXN?=
 =?us-ascii?Q?Aw8cxvhpJ0ErtPpvX2PpE5q3l4Z3tYGsMfGTMa8VMCxj0mFDEEQOWofxeutK?=
 =?us-ascii?Q?TK06byt7EAIaXrWOYRpOBJM9Ytb3GOn6KFuJidfRfinuFN1hPALTuKEyO3Hy?=
 =?us-ascii?Q?MdprBr7hXND5Sw8zTY5ANM01BQNc4m0/zla4LvrooQiLPhQLQHcONqvrCbb3?=
 =?us-ascii?Q?L393H8HnPdEvje4vf9HUTjEtEzKZovLhQv84ZVDkrbAFgvzLL0UmWGHT0W0z?=
 =?us-ascii?Q?n3pfvbPfwFggORPHCwAS6OCAVg2/vErVQHCWFPI5Ayz9NykAUlIJrizmheeB?=
 =?us-ascii?Q?prSntPZZLjVBJse+yT944ReB7f76L+/r+nVm6SvWx4JzzgYmf4d1fWYJwCZR?=
 =?us-ascii?Q?/RWTID4eHw9sUc5umqU2Hsd5/3NC3W1+9GpOT8z7o+7GpNKnUdsrVRM4cbbP?=
 =?us-ascii?Q?7RwDLNJvO+ciE0IkJGU/4dR69W4x0uu+E6uQPThy6/1dAvNwjrF7lKorZIOY?=
 =?us-ascii?Q?NDO47Fpuv+B0jbu1IblP5pZPR+PSj1DV7Hd0BEgi3sKpIBCdx/hGsclLp7J0?=
 =?us-ascii?Q?JuMhs/k1zREb+DALYcOD4GwVjN70bBG5jCXy3YBGyBftx+CNsD3LL+vRxZ5T?=
 =?us-ascii?Q?izcAj9UZlmZjoTFCx9uyb1cVCMZocdW/S8yBTDgfB/Ph3tt91yDiw5Xmh2uT?=
 =?us-ascii?Q?O8HjfKrzKQwNcPj2YvRnNCMIc8bNVhzzB+4e640HqbrogrCyJGaN9mg6o3wV?=
 =?us-ascii?Q?PnkRxaOll/M+FbWWzsbOjGvy/GP9CJlCVrkxvh9zcXppj7SMiQsGIJsN/R5i?=
 =?us-ascii?Q?HZE8yoVLwnVVhTow5WjCrXzFQGR6WOZtpStgyQxQP6+v3g2Goi7ohyck5quw?=
 =?us-ascii?Q?TuHrxb/MCwWOA+1W4OMf/wgEUhcltivf+diJKPJ/l1hHfyzaK6ZsQk+qBk1l?=
 =?us-ascii?Q?rQwuR9Fy1oI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zT03BbXz/GnB7nVxmkEkNfrwyCo9XMlauKdzXpWAlqNk1KV6583D8zlOvIcx?=
 =?us-ascii?Q?1HPxg/MWUrkm0dQkkSNPRXQM3+p9QJlsyPs4s0Aoj0fDLMdjPAvXe/yH1uGa?=
 =?us-ascii?Q?wxqGtx2NNGQuDISYA5Fr9+A1W1XawepuMcoXqAOxWvNtyLAFTPw/sxy6hRTR?=
 =?us-ascii?Q?ZEoEpTCpwbHL/fIXzFkn+1efvLZEzTapmM0cBaHqEN0FsjzRxob5oQQSuAYo?=
 =?us-ascii?Q?kQUPG1eJHpcFMdir7swNC0fpsgCdJTtSD/eDMpYPOUT6rBWYCAiokymo9otX?=
 =?us-ascii?Q?9JBZgGU1qLKNHXCuTg8pdDAmZXLglfhoD8zO4UKzyHEbs3TeAzjf1iOiOZq3?=
 =?us-ascii?Q?1mtxC2sEED6A5AziT0pdshRuMhlpjtNf2dcqeVkVoeaFsxB+RHQUf+frYDZP?=
 =?us-ascii?Q?rmE6MUqufW99Xw0KHwWCBjLgIWSJEEz+0BFEKaa8Yw3/+T2dAyOFXnGrgvZR?=
 =?us-ascii?Q?Ns0hSbwVSaWbvFOV370bKPp87jziPY9y4JoHzjRwX8mnJ0hiJo1XFLQK9YJs?=
 =?us-ascii?Q?q0U7RbfYtq6mgJJn4c0AS15zBeVhrOiBZTVJ/Z2dczot73qLSM9gMKZP+qiV?=
 =?us-ascii?Q?MdIDLkrWvVQ6oBQkB5IKdAf3r14ZWocmf2XRJ+FbGuq5FTGMCe9nZ61bmsiZ?=
 =?us-ascii?Q?cVvVTuWTdtE7TlmrnAugQ4XtzJzgVFfTbQ4XXp+pc17DduEzFnkic4AymRfR?=
 =?us-ascii?Q?DWGpIpkihlF971CsEF8Of7BAWYZw71MqD9MfRWQm4JTJLu3B7tb9jf+phrl6?=
 =?us-ascii?Q?P4V0JZldUTKbK3JrBabCVXpwiuMN6aKNB5M9I/Xy2ZqjhhGd34x4ufe+oYno?=
 =?us-ascii?Q?kK9Kn08LrIBtHmEf0ePxj8ivvijO8aWRhhOD5krzU5353ees1WYhQi4+ejBs?=
 =?us-ascii?Q?ZBC8Qd8MI2f9g7+RicvCCJnC+5KUcIN8Jw2rWC9ld8lrKJv5QWtV2Ir0pYou?=
 =?us-ascii?Q?5xDp/CUDDyjKVEDQ8ENongMXe0XcG2IGykoIv2mXUIu+69D2IIcvu906dypf?=
 =?us-ascii?Q?pYdbjMzeKd7Fm7UzH8KApJ1nCsDhxWGfpsSMSxwFk8a8WgDzLCPlikSlacgo?=
 =?us-ascii?Q?pRp/DJ04DfSHxtvq1It6YY+3WzuP1xfhKY7xEaQPQ1y9DHOVkTQUUXRHsA3d?=
 =?us-ascii?Q?S3qF/IZXwijQLHekMTArPfT7aXE3qL9uAkwofAcbnetjA/4OKGqGhQZCYpbQ?=
 =?us-ascii?Q?fXlOn7WwQg0OoxDkIskNN5f6SYtNc3EpprkOmnSXmoHD9FBHY8TAyLB17p7F?=
 =?us-ascii?Q?cMV2BFXI1vA8GmudomRf+cF2hXVoc8Su8P3UvNiiU55ebVymycjspA3Cw0VA?=
 =?us-ascii?Q?BBL7RYvOnhcliQVy420zTxueeR3xMLQ2h/++SjqnlPVYwayrAZjYYRf8KXoo?=
 =?us-ascii?Q?ml+dMK7n/Y71i+Ngg98mlze/4bCBdOzKonNFQkgCk3aafvaaEeAU/Xs0HRen?=
 =?us-ascii?Q?PTdYQjt4Bp+63VgOWVhgxNcAloON8+qiHJwYeNW8kFE095VxZhZ2EiB8dckz?=
 =?us-ascii?Q?rcePmnnzWJoudpxEPZkYNz4CxxyW0Z/VrGvsrQC9tqOano3Gl2Qcj2AN7tzD?=
 =?us-ascii?Q?FEx9V2X4DOD9ugOY1w/uG4SHQb0/xW/gba3CVvyo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dde3141-dd3a-4012-197c-08dda2d2e789
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2025 19:14:47.0344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JY6jOSLDZtdY7MAnK9Ip8umbp/B/y1ESw0Vxe/OZ7pFxTYfmYKHuz+CoutML+ruE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9461

This driver uses a mixture of ways to get the size of a PTE,
tegra_smmu_set_pde() did it as sizeof(*pd) which became wrong when pd
switched to a struct tegra_pd.

Switch pd back to a u32* in tegra_smmu_set_pde() so the sizeof(*pd)
returns 4.

Fixes: 50568f87d1e2 ("iommu/terga: Do not use struct page as the handle for as->pd memory")
Reported-by: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
Closes: https://lore.kernel.org/all/62e7f7fe-6200-4e4f-ad42-d58ad272baa6@tecnico.ulisboa.pt/
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/tegra-smmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 61897d50162dd7..e58fe9d8b9e77e 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -559,11 +559,11 @@ static void tegra_smmu_set_pde(struct tegra_smmu_as *as, unsigned long iova,
 {
 	unsigned int pd_index = iova_pd_index(iova);
 	struct tegra_smmu *smmu = as->smmu;
-	struct tegra_pd *pd = as->pd;
+	u32 *pd = &as->pd->val[pd_index];
 	unsigned long offset = pd_index * sizeof(*pd);
 
 	/* Set the page directory entry first */
-	pd->val[pd_index] = value;
+	*pd = value;
 
 	/* The flush the page directory entry from caches */
 	dma_sync_single_range_for_device(smmu->dev, as->pd_dma, offset,

base-commit: 7d4dfa6140f75b67f8eff3ae6ebc9937be94c4d3
-- 
2.43.0

