Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010064.outbound.protection.outlook.com [52.101.193.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBCA30DEA5;
	Fri,  8 May 2026 15:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778255682; cv=fail; b=aP6LvAmcjUWo+OcDaXQEmvVGgSEUY2YcQXkkyN4YkePkrwulF/jkK/sG2ZVtAqG+vCmPd7eX0MQ9nmjFUxH4Lzoqvxm/cAvTq4YvbZY9MsWYEbWhTnjp2CCFYQRA3ZUpn3dpEQyJnl5C7FYqsEDmcIRxHxfX5g/2zegl+xqXznI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778255682; c=relaxed/simple;
	bh=q0YA0VDliaaKfaCH+OwHa22HSYCKu2plIKaAceMFqVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CJS1RkJWZflM5k5PpvO5aNhbahAi+lry6DkH6ElJG6c62cHUoLpRtzZv5WnLbGu0DqVmhDqb1JUwMd9maSDtLUNE4GE7TnYud7PmDPf+i0/5Mz55lCO/Bn/oAUiRtWVfAOMYUJIknKeRwnEHKld6WFvcR+GSUlrXtJm2yL2n9QQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=R+GH02+2; arc=fail smtp.client-ip=52.101.193.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="R+GH02+2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KwvSFHnVeVmU+vs96PDfW0q00p2+v/MtAkrIEdvLbLwkO/aWdTEHRBFriRZDiWtzAT99ajZEEOtzxBBh6SoD97J/RXZanhRU1YR6WGZ94Ce1bK5Mu6qGdVbEyMjEnQ1zt9szr23Q1TlqzIyI1t754MDglWpz2usMcQ4D3fHuXz2pCKOajRNs7jA2d7ZSY220wKRxlCo4DaakSWAxOlVX5wEa3sBWg0A05F7ojrh1G+FW9sOWQg7E5+0rdrJz/FE6t0FnOPHZIdTUbXIFCsKNCn8row/nBUMMo8GC9nqQ4oNLq5FsvnugADdrwBXUvhMSrmZ+IJ/eu3wXOBM7ZHYWiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VKcA3DV9vqMoAj+PdGsNg7jOSjZ6wYE8FR26Smnim6k=;
 b=qxuHR4Qzb6pfXWHWJXnwqHXjyd3SNXSU3GwMJyysU+dZnwD6AMexQHUtf91urqoWbuO0ssOmtF8M3PqVssRzQUOLLsnTvgKHxn/jTob1OCHSvQB7CDCdHMhZM4om3DyOqg2Z+9iSg8Gmq9YqYMxodFxawk8TCJ57VpnS1uYn5UvuoPTEfbwqI5Qr3jFLCLGBavPJ0hNesJVHop2dP1eHKws37l+vlmfLv+4/PqhKluKcC1hX5O88//sVQXF904ZXEwFUOMZpH7RjOa/nuB0F4K7W3r8eiLi4XNFAXS/N1Zk76K17Zyz73lZSPxrCDFcbH/kdkCz6pFjUIp6HLK9Ltw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VKcA3DV9vqMoAj+PdGsNg7jOSjZ6wYE8FR26Smnim6k=;
 b=R+GH02+29evqKztfG547OXIoxJ8qsiLiW8XX1OiA7Q14nitT5Q3aBk8T/v9Uq9n8XyhQaJgNs+UJh4y3bRyu4OYD4YJ+kGsUOACcMyrgs9zNc2sg34cP0riEgOo33BeIoTSeWSqpJxxcAWiYdlZ9BTfZ28wpa/v2TBahpTgjq4vTfbHI7xLZmtmFAxw4BGyK1PdTjURu4dkKUr4dHw/xFB5JMwRcR0CLr/omOO9S3hp8xSboieJiOjhrk/h/pdJsQ+AcltjnqwpZAsREmI03BszvQarPQBn4he2/4KZOQHGgwmjNX5rTs33G9Ha72Sv/hI5BXeGH6bEkWLKvTQ95dg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by BY5PR12MB4178.namprd12.prod.outlook.com (2603:10b6:a03:20e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.19; Fri, 8 May
 2026 15:54:33 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9891.017; Fri, 8 May 2026
 15:54:33 +0000
Date: Fri, 8 May 2026 12:54:32 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pranjal Shrivastava <praan@google.com>
Cc: iommu@lists.linux.dev, Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Krishna Reddy <vdumpa@nvidia.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 2/9] iommu/arm-smmu-v3: Use the HW arm_smmu_cmd in cmdq
 selection functions
Message-ID: <20260508155432.GE9254@nvidia.com>
References: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <2-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <af2VIXhI0ryEbWn7@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af2VIXhI0ryEbWn7@google.com>
X-ClientProxiedBy: BL1PR13CA0151.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::6) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|BY5PR12MB4178:EE_
X-MS-Office365-Filtering-Correlation-Id: cb10b6b6-3651-4b94-efc1-08dead1a1928
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	nz7n/Irg5f00Ddu3m/4JHYQr5zhUIsbnG3/oedwWhfDf4OwISqvP+WZJEGj0VZBTtyXcQjBmLj9DBIhIT6Q34oIJ2VX97thRxQYEXmufCSrEYTF+S4VvrwIU1xGLbYck3JehhF4t3/U23YNu70mK2oBXp5WHo1c2kJZ8hO2jXSDS3g0PycbePoyCrFd79Xmn2WcteR9RtZ3At9/5p4L8azwaZ/X7K87zJ3cxkOHeZgahpZve6gEV9B5T9c6f/UhIoJA8hfiA0FTT8K/UeaLT8B7GOkIYH6VLWq3pMxZ/j/rg5/4uLBVmyBE3potTVzk4lP6BvUY9AQJux8MUfvbATvb+dWZDi0WXvLQTj2oIt2sFgYHr3sgIlxuLfARQLONV+iUqH9d4G5rSnt91g51vOzTApLH/qxkEgMD9gl75eoy/l88tyI2Pv2VHzECskD1fd/db6tDDE2uK0LEUCNXuuuVV5+ujOQ60uPXQNDPKL/pHIIrEmuViNMRJ2f94YqWhXfRXkfH1+rEZDINBaVa6m1wNm0NtMplqkhczS1kY4gFfFvyGCtSKSxXD1E3E0UPmugP3K3C1WGfKs0hW0ZQh6Aax/IMkUFOgiachBRaFVQFNN0BKzc0FePS++mF0bp6biO65QtOoay9aQGKjHGez1eKeeHZPPEccsvBmmWnz24kK2ZJxVfvWY3BA3aZmE28Q
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RlMLcUYsPxqeSAjNfkVe3M6Rs80TdO1622eIddzijVRzAOzSJnKx2bqpgmXD?=
 =?us-ascii?Q?d6VWEAvYSp7w6wQogrS4wfwlP8WiP/01I4NyD3m7CZ1UdYZxHNx+7A31Ww51?=
 =?us-ascii?Q?v+vjIEqgZWE0Zy5/e2FjuQGsmUN6zqKDpSiBtMXWKKogZM+oLd8mqZ7qLlil?=
 =?us-ascii?Q?AnXsUGplNoBWTdvKifYwQBnGRPDZCrtBRvMRAHV2y1X6o4BCpP9AbipxGUgP?=
 =?us-ascii?Q?KaU01nDFO+iNleVfvt4Q/gUvR5Nh6BRsg9DW0rjevlVqw1yYGAKmu8oxX8Ap?=
 =?us-ascii?Q?o/7kCcshvXaVhVYOr2i4YbyIe9u7hmTWbAp5FR/0OLU+KyDwsLt0f0eiLEgz?=
 =?us-ascii?Q?W1ea7rVTlvnzIUSHrY2zBMdwa/rm+LSLIHPlITcD4RJ375l7iS24jj6xsRkM?=
 =?us-ascii?Q?1gqfRpihQW9lFSacMGwuZzjGvsu4byc1BGHPE9bR7ooWLYSUzsUqbUu+VO0o?=
 =?us-ascii?Q?J2XLGCsrEU6NLfGLDeO6e+7jgqGFxEEp6cFa/md/IH8Cg4MaVI6I2n3i0IO3?=
 =?us-ascii?Q?Yk1mzx+BQRS1ENDsG2Wr8me1Yn1RPVy4GzOgWA+27eX8GY3fz2Z+OJ0Hy4KM?=
 =?us-ascii?Q?XE0Aysk7LyHuXya+o/C1RgAhAMQXir4O9PIF2jDoQbs4U+FhCEqTV6unB+R7?=
 =?us-ascii?Q?wChajsCeJU/hM/KZOTpbiVFugKKQi4LKbmhLlXp7eoTFG6dplZIbMbstmH+c?=
 =?us-ascii?Q?fU0NmA2goSJuJUyCMzZVWi/cX0OUh9Ce/3Zjd8xz9wu7QCyMMOtMBfgcYNEE?=
 =?us-ascii?Q?lw8YFSco+M6HVLdI799T5MHiTdM6DsJWpC5+LGiulYmol6ulpm70UUoMS1LE?=
 =?us-ascii?Q?uZzxYJWQ4HCptg3Li19Njgf69cS6INyS/CQWn46L22OnRngIyrbtqqrWLd++?=
 =?us-ascii?Q?EBxdDDO7KiWWhVbEy4cWExCla4sm/ODMmCg4P0pSg/l5i9yrTXlngtaD16FW?=
 =?us-ascii?Q?O6p+1aIg+NXJVOjIVWI6NC4zjpWFl1dRNIUMGPSTmXX2YqdE8o0Mnr+zh11p?=
 =?us-ascii?Q?bZKEvCTmTOuKkdBtLpWqZ9dfitiptJ3zu7UtnMl7TuXTHneZ+5VKCGDKY75J?=
 =?us-ascii?Q?iW+HMug/fqXZHBYm1cTuB0TZpVBeVPCFdXkPvK9IHFhKHUhUOOxQAjEAs5B6?=
 =?us-ascii?Q?0Xswq67VtUuDDnRKJy8831NmH1/Hw4XnVjAUSLjiLEWEa1gfObpHW8cLeX70?=
 =?us-ascii?Q?0piMv7NjrlpD0rv08fpwjJ7AYRoX0g2Zd2mV6aLJsbm8YS91iXxq/WImZrRF?=
 =?us-ascii?Q?hYvYmGgpOrt7l7ft9Xun+yJ7jfUhybUXg/2RzVreEL/CUYYO0c7W3COkxpp7?=
 =?us-ascii?Q?DsnaTkew3t2EfLkQXy5WBA4XZLAGUAo4WG/IM9rkynRFaQblSZk4o118CfqO?=
 =?us-ascii?Q?5WqxjLwIJohw+TXuavUZPG/5jtU22uljyy98Y4GvZMDQ/Uhy/RpgmJnvOIUj?=
 =?us-ascii?Q?wwBgSvo4rk606JUgoSZ+/i1HaTWz/o6kfnAg4uqUDLgJbbaGFEWOgu9u+nK0?=
 =?us-ascii?Q?VvdusgFn2aELZ/o3f6+M5uvj1+HpTH6s82IwQCwFY9VXMOHktNrEu/OBihgr?=
 =?us-ascii?Q?892WeQPUVdMMjbw2hO1ZtQMmaSER/XokUud4wMYGpcqWVjFgmBsds10ye+/e?=
 =?us-ascii?Q?vMmmsBTs2zjAfwYbRmDFPbi9JTybD7s+pKrMC6JS7JhnRxHUoPTRBasAzE0A?=
 =?us-ascii?Q?4oq0TUJ8lbTN1hMlEBkj6IoEL5xzYuBb/D2yuAaoq3Wgkuwi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb10b6b6-3651-4b94-efc1-08dead1a1928
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2026 15:54:33.7676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qlNpsVMZovhv12LtxBasU/fJwrKoom/A1UPO9U9LK7lJgrVQpo36llKFNS8BW1oI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4178

On Fri, May 08, 2026 at 07:47:45AM +0000, Pranjal Shrivastava wrote:
> On Fri, May 01, 2026 at 11:29:11AM -0300, Jason Gunthorpe wrote:
> > Start removing the use of struct arm_smmu_cmdq_ent, starting at the
> > lower levels of the call chain. Change the functions that determine what
> > cmdq to issue the batch to into using struct arm_smmu_cmd directly.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 47 ++++++++++++-------
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  8 ++--
> >  .../iommu/arm/arm-smmu-v3/tegra241-cmdqv.c    |  8 ++--
> >  3 files changed, 38 insertions(+), 25 deletions(-)
> 
> [...]
> 
> >  	index = cmds->num * CMDQ_ENT_DWORDS;
> > -	if (unlikely(arm_smmu_cmdq_build_cmd(&cmds->cmds[index], cmd))) {
> > -		dev_warn(smmu->dev, "ignoring unknown CMDQ opcode 0x%x\n",
> > -			 cmd->opcode);
> > -		return;
> > -	}
> > -
> > +	memcpy(&cmds->cmds[index], cmd.data, sizeof(cmd.data));
> >  	cmds->num++;
> >  }
> 
> The memcpy is a temporary step and goes way in Patch 4.

To be clear patch 4 still has the memcpy:

-	index = cmds->num * CMDQ_ENT_DWORDS;
-	memcpy(&cmds->cmds[index], cmd.data, sizeof(cmd.data));
-	cmds->num++;
+	cmds->cmds[cmds->num++] = cmd;
                           ^^^^^^^^^^^

The compiler just builds it.

The flow evolution is:

Now:
 struct arm_smmu_cmdq_ent (stack) -> arm_smmu_cmdq_build_cmd (batch) -> memcpy (queue)
Here:
 struct arm_smmu_cmdq_ent (stack) -> arm_smmu_cmdq_build_cmd (stack) -> memcpy (batch) -> memcpy (queue)
Done:
 struct arm_smmu_cmd (stack) -> memcpy (batch) -> memcpy (queue)

So the net result is the same before/after this series, we just carry
an extra stack copy till the last patch.

Thanks,
Jason
