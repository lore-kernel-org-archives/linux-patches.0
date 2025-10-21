Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012054.outbound.protection.outlook.com [52.101.53.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D10C2F49EE;
	Tue, 21 Oct 2025 13:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761052834; cv=fail; b=TTdAxOUSMcyqKdG//Ioj7z1gopmLWAihxneG1s7uGfoPw7QkI6nNbKB/69TDm3gGR3Xi1DGRyFTTeWebdk+S0Cn6aq4pokhT02ryhB3eovtOYBiovm43L0YJdSzWPRQ8pQMClt0KzL5aLoABBGh73ew2xIeAU7KLmr1S7aPrLv8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761052834; c=relaxed/simple;
	bh=fXTOOTSw2K5q9oo4LXWMr03RsbF8s+kiOv/uSw8qRHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nZ5h5UUJ5eCj6ts6R46D9D80fHYsZAihP3K0oZRMDxHg5SEbtI5hoeCsfuDyzB9CsIvpXTqloavNSiArUTJ9Wb1Q/GknVeZVl8VgcUXD5AG5Pmp0kMSGsYIXkCJgHpaHbI5FPrRLpra7V7ekNxsFlK5OOoEQtKxvnDqwrvxH7gU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LXIomkg9; arc=fail smtp.client-ip=52.101.53.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LXIomkg9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uXZEviJtyPf20Gew36BJM0NAMhwOPgZzZs2pVB/94SfZwEPCTIgz1LT4iA8yGkkAu8ZmmIwGjns9oy7SCvYYQiuWDUsXydP5zODSBQlwrg5HG34J/3mugqc1eU1jL3kmuffYVBRFXjqmzplBeChJmfyx34GGVu2+MtuUl9PpdABZSoopzjycor08G3mFUupzlwcMUKteZTcVkI/DrxbgfoVBKPvYv+FFkyCfoY/Mz2T774E280FZaZkfyMAWXgIFeboFna6SwEQQkJ2qTBJN60pSbz8WUNkpfrtMI/974Xi95bfy67uJJIhgEQkXRzNHGT64cwKCSKide+OhvRazog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z+bheatoejKMUnpmdECThZ/vQwIw6xa8K9ab3ghEN1k=;
 b=YUC6Oe5K8aNFhWMwfhhosl+oRu8j6bCqK9RiSxR5EmK2lM3LmtFRkbriaKaROI8dlTS4G2c4W15ptzWNWzLLtooVHc0BvBfA5x16PGnkOsb3WoFtq5egrfjvMAjyCplcgXEJFgeR5m9FLN/9w3lQAOW1gZEI/3ZAtN9qyCWuwM/ap18S+BBI3XV+DPYYuSGbbnotpFLVa49nrUWLP0whznAXEIkW+7HNRKFjVAcTcnQ7ekIO0aQcvwf1dVzkhyLN8pV/dDGyp00segQ3twkjh/M+fuI2pdwdD7MWn7dN6X/P13q2/5l/BeOEeF0wBnSh48aeE2PiziznWKTcgKJTtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z+bheatoejKMUnpmdECThZ/vQwIw6xa8K9ab3ghEN1k=;
 b=LXIomkg9TEMq1kFz1ClUEGnnlHlckpUljUaLp2tv92s4AQ42ZjYd6wMrbZObypWG+D9DFZKpsaxjxlQO/61P1Pkz9+DDNEj9AblGAX5O2Jba4zHup9tJ9e9OvfrKjpbZkPHptgeeACTSPWkohuZyREaIM/OvPvX7RQUXlz45zIHLy7hNtrWytRhzMD8gmICHh84c8ErL+KD7UKJH67hhh/AButMPoMZDLwnGhNb4rvV/PYs0ArJugSHIxSTgVMr4XQVFaWwy0OJojwxqsOx86wWA+9ApLW+0e/MVOyF+pkXO4nOvHgOEbWYZaypuEiYZ7/QiZu62mPSCutfXK+PnQw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BN8PR12MB3604.namprd12.prod.outlook.com (2603:10b6:408:45::31)
 by IA1PR12MB7520.namprd12.prod.outlook.com (2603:10b6:208:42f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Tue, 21 Oct
 2025 13:20:28 +0000
Received: from BN8PR12MB3604.namprd12.prod.outlook.com
 ([fe80::9629:2c9f:f386:841f]) by BN8PR12MB3604.namprd12.prod.outlook.com
 ([fe80::9629:2c9f:f386:841f%5]) with mapi id 15.20.9228.015; Tue, 21 Oct 2025
 13:20:28 +0000
Date: Tue, 21 Oct 2025 10:20:24 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Tina Zhang <tina.zhang@intel.com>, Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH v2 03/10] iommupt: Use the incoherent start/stop
 functions for PT_FEAT_DMA_INCOHERENT
Message-ID: <20251021132024.GB712833@nvidia.com>
References: <0-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
 <3-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
 <BL1PR11MB5271D3D720A50EDFAEE52CE38CEBA@BL1PR11MB5271.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BL1PR11MB5271D3D720A50EDFAEE52CE38CEBA@BL1PR11MB5271.namprd11.prod.outlook.com>
X-ClientProxiedBy: BY3PR05CA0028.namprd05.prod.outlook.com
 (2603:10b6:a03:254::33) To BN8PR12MB3604.namprd12.prod.outlook.com
 (2603:10b6:408:45::31)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8PR12MB3604:EE_|IA1PR12MB7520:EE_
X-MS-Office365-Filtering-Correlation-Id: 4eec56d6-eed9-4b13-c211-08de10a499a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c3hUK1pURGc4K1BYR2h1UHJDUHJCNk5TUytpemFiQTZVa2FqaE5EbGNyVDVp?=
 =?utf-8?B?ZUYzMXoyVlhhOStBbHcxOFRyaWl4WEtvcWlaTElFS3JKdDN1YWt0amJ2T0Ru?=
 =?utf-8?B?bmpLRXFPSVVoM25qUDgzeU4yNDNKaU5UU3o1L2tQZ0VNNXc3QUNOSTRlbWlw?=
 =?utf-8?B?YzhRcWsrTmc3emRXakZNWmtJZXdITXZPSnNzWWQxSnhQemlMelZLQTltU0pB?=
 =?utf-8?B?QkdtV0t6R1YwNGtaVyt5Q25aM2d5N3VDcXRsUUtTbmZ3UmUvUDBqNC9mUW4y?=
 =?utf-8?B?RURLMVRFSDhjUThtN2FqL0R4UFRuWTcvV05KQlhxV0xDVTlMWGVrUWZrd3dX?=
 =?utf-8?B?Z1dWN1RweitTZGhqN0Zrc3pFWVFYQ1FHcHEzYUJBQ1VRWGpjcTlZRlBqR0tW?=
 =?utf-8?B?MmdMUGZsU1NwdzV1SWZ5N3dQUGlMMFpkMyt1azg0YlhDWSs3MTRDUytuVDR4?=
 =?utf-8?B?eWpxTG5YQVJ3V2gvRjl4SWhQMERTMjcvdXhzZ1lHVVB1Y2tSSTA0cXV0N2xQ?=
 =?utf-8?B?WEZ0YlU0MVJUT3VQY2Q2QnVvei92RGlXMUlXSFU2Vm42cms0NitMQ2tsOWNU?=
 =?utf-8?B?QWl2MGZIdEwxN1VNMlJwY2duUWxOUTlTUU5BbDNyM2twa3B6UHJnakFIajQv?=
 =?utf-8?B?Kzdob3R0Z1BBNjNFandickk5a0gxRUFaT0RnV1U0YS9Ma3gxOElQMGlhWnVn?=
 =?utf-8?B?YmNQVE80SzY4WjltM1BGcDhDcGtvVmI2TWJyL3dwb0Y3bHhZbC9jYW0zOUY1?=
 =?utf-8?B?blp0cUpZaTNvc3N1TWovTmlVUklOVFVFbnEzczk1SlVSRE1yVFJhQXAyUU1q?=
 =?utf-8?B?MElNakdsQnhIcEt2VStINWZEMDFINFM2NTZFWUdmOHdHVG05VTF3dlF6eXFX?=
 =?utf-8?B?K3ZsTFAwbEMxQzJrZlMwc1VKY05zWHdYRVFDdGhuUExQbWF6UDJ3ditSMDhh?=
 =?utf-8?B?UW5DMWczOGQwRFJDbnVIc1ZhN2ZncDVBdkRlWFA5MlJZak9hcHhNUFNXb216?=
 =?utf-8?B?aE5hRDdNV2xrREl1Uy82aW1LMEoySWp5bmU3SGx6bE1KRDdGOERaUWtZOTl5?=
 =?utf-8?B?cWt0c2VxYXJ3aHUwR1F1bjhldkgwTTFETEZJaEJKZ3Z3VmhRMldFdkxqRmVF?=
 =?utf-8?B?QjdrZ1RpZGtlb2hwcGZtYzRVbGNmczlhS3lSSHFqOXhJWU8xdU9lT2hSbjVO?=
 =?utf-8?B?Mm5ZRW90YWxWamZ2WXVpZHpKQUY0L0IxNi8wYnBqdktRSUNhSFdwS2x4SzN4?=
 =?utf-8?B?ck4rdXlDV2pzdi9TbDdIRmlhRjlBZkRVRnZYZXVtZmlvTTVkL01YS2JNZlJE?=
 =?utf-8?B?QnBUV055ZlYyQ3hGS0c4ME9mZTNNNXFTcjV1U3VEOGFmZXlESTIwMXU0TkNC?=
 =?utf-8?B?UG1QRHB1OC9tRDBQMlNUZEEzWHdmU2srRlI2c2ZpWEozNDZDQ0IvbmpBNjl3?=
 =?utf-8?B?N256aFhYV1o1NnVWbGRFZnVhTTY5Z0k1dWFhbzFCSkRabVJpaVJDOEZySHpB?=
 =?utf-8?B?bzBMWHp1SjBiakdWTExLUElreDdrUkplNytpd1MyTU9HcWhoa0prUEJlL25J?=
 =?utf-8?B?cnJadnJ0NStKZXJIUENVNUdlc1MvTXhTdFp2OXY4S29heHo0Mmt0NEhKY09F?=
 =?utf-8?B?SlNKbGVvK05rakliYkZFYm1NMGV2bnYxL0kydDVUQ1g2OVdGdDhzSnZvUUJY?=
 =?utf-8?B?dGxlVEYrOUd6eTZnVlViOHhqZk5FRFhZT1Y2eGRmUVFHN0RFZnJMdXRRbXpP?=
 =?utf-8?B?TkVqWmZpUXlBaEVYdnlMd3gwNk96bkpBWXh4N3Rkd2lBT2d0V1NBMi9sWHdW?=
 =?utf-8?B?SWRsVFVDbVI3S1JsT0RPVWs4dGYvR1VJZUU2RHJHM0dmckxvS2dHSm9wWUY1?=
 =?utf-8?B?S1h0K0xoeWQrdmJnYTV2L2pyMTR5aVI1TkQ5cnVNc2t4UXlmVTVPRkJMdHFu?=
 =?utf-8?Q?1E1GEy1lrfyB4TXNmB2vlFSV9sHE/BXF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3604.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dW4vODFYMEhTR3RpaXczUWlnQnd5RTVITXlyNVBxTVQvdTc3VVc2K2MwTy9X?=
 =?utf-8?B?NXRYWERub0tGcTNwVWZWZmJ6d2dwdVZnYnA5S28xS20yS0YzWmVhMFczd00r?=
 =?utf-8?B?akU3ZTZWL3Q3YllMenFjSEZJeEFCNy84WTFneWtTQmdPeWxoOUQ3ZzkrNVdL?=
 =?utf-8?B?cThqdFYzUXdnUEpEM1hFclFzbWpxMTJNY2RQcUJtWEo1RCtoSWE2dGRINkVF?=
 =?utf-8?B?SS95Q3htVnpMbGdnTUQ4OXR4Qjl2cG1QR1BOMi81dllLKzMyNTNjRGhWT3Vo?=
 =?utf-8?B?SXp3K2FTaDNKREw2TTRlR29JNkgybnJHdU1RUUZIM1k5cWhhS2xmOE16ZGl5?=
 =?utf-8?B?TEg3SGFCWDhCd0x6Mk1hbjJVSzN5SFhHQmJxR25PcmRuQWpKVE1LN0hod2Uy?=
 =?utf-8?B?UzZKZzlMOXNVdHNYOXpUc2pPK0Jjbjd0NEZCQUs2UGpUWWNJcVlQTnRwZUY0?=
 =?utf-8?B?MTg1Qmw5amJ4cHhsUXhHR0RpbjBrTHB3SlhyTTZWMGZtWlhITUdZcE9PTG5z?=
 =?utf-8?B?UDIwNGRXTnZYc3ZLdmlQKzFaYlQxOHFGREIxdG5UaE1UMW5GQW5HY3VLVmNt?=
 =?utf-8?B?NktyRE1pNFNjb3VYZU4yaDh5eGpqbWQ3cWQzMzhZaTU4bW4veDBMTTlQRkx4?=
 =?utf-8?B?em9tclhpSjRiVUpoUzN1aUZEQ2ZlNG5FcjZ1cUlVSGRGbSs4U1lyMHg1ZHc3?=
 =?utf-8?B?eGkwZXplUGdacWxFQnVtOFh5SmZMdC91V2dUakF0NlhmOTQyaElhNFhncFVB?=
 =?utf-8?B?bDZnN20valpiQnVnZEJPQ1ZGUFc3ZUhjMTVYZ25ETkZzbWJaT3o2N3Z4YUtP?=
 =?utf-8?B?RU12SU5Kd0x4TTcybVVKaUFpTFE0TzNLaGc0UzBMdEloTEpJZnRXWktJdW9q?=
 =?utf-8?B?YiszaGlPVXV6anpycm40eDdFTkFpR2kxSzRqaXFvSjhieDJISWNyZUg5VnVC?=
 =?utf-8?B?emo4VXJLNlRRMllMZ3JqVFlLK2Voc1QrVjBTRSt2bjlHSUhaeGhzRUozejdw?=
 =?utf-8?B?QkNPVzMwalhvWXI4RDlIVnlNKytUT3p6dXhwemxsb21UTlljOVhheW1TcFJR?=
 =?utf-8?B?YW1HZ09vaFE2dnBVL1k5RXkvQW9Vd0hZdTY4OStYTjVWOU5VZVc0TE5VdkhG?=
 =?utf-8?B?QktTeUZENTVmMmxGbDd1MzVpak5RdEdqK2NlWlNLNEpLQVc3VmV0SFVPOFJF?=
 =?utf-8?B?ay9oc2ZVZWxlRjAzWDFZd0tpN1BDUDR6VTc5c0RGOEhESUIveEZHY0VHcjRj?=
 =?utf-8?B?YU5JOHhWbDBOUU9NZ1Y2NDBjaFJBZ2wzdmRvcEw3aUFsMlZuTkZxU0h0bEVY?=
 =?utf-8?B?aExLSmszK1pNWkgyeWtBaFFYOHR6aG1YVUJhYUdyMmh6bEptTEFzaVpTb1FZ?=
 =?utf-8?B?aWVEOTJkcXhXWGxrY2RjRW1VQ0pjQVdJWWVKYjZtbGFqS3lVQ0FNMWFNNFhE?=
 =?utf-8?B?bnovNkRUYmtRUi8wZFFUdmllemhKa0VndG5xQ0Zvbjl6aFhZTUlPUEtHQitt?=
 =?utf-8?B?V1g1cDF2ZXRvR3d6ZVZaQVAvRGwvRVE2eFRBMmlTWURibzhYWWpRaGoveHlW?=
 =?utf-8?B?OHkrRHlydm1jV1lsOE82bHBad0VoK01ZUDg4RitJcXNCL3VRd3hJRmZSbUM0?=
 =?utf-8?B?cVhDUDAzTHFRTGpPbVFRT3VleVRxRHZnRzVteXdnMUJOdzNxeFRXeUpXOFY0?=
 =?utf-8?B?aTlNbkpxMmwzaWdWdCt3aEgyTXF3bFB2emo5OFhkWG1hRUp5bkpSczMrV2pV?=
 =?utf-8?B?TURsSjMzeTdqamx1RWE5T3NlSXZ0OEFmY05FUFN0YmhRY2dFSTZBTUdPY3dD?=
 =?utf-8?B?SVEvcHdLekxhNFRudHFIQ3d1RWxQVEM0a2NleDUvcEdEeHdQcGE5M2VZNS9F?=
 =?utf-8?B?L0tVWmtrTE81cGFHYzJ4ZHhKSm5mT2JmWEh0dUJRKzIwRXdmajlJRjVJSGRE?=
 =?utf-8?B?WEpmckU0Wks5VTA0VmVrcXB4dTB0RGRmekp6bHBWMjRDb3RRc0wyd1d4YjlI?=
 =?utf-8?B?WTZXcnMwWGNqQ3BSVGZiMVFDeTBuUy9RMUtPZ2pEdW9vWnVHRjFSVmpWeDlv?=
 =?utf-8?B?YVJrdkQ5TW5aUys2b2ZLZWk4SzUvTmsyWDgwdmx4Qm9Xdmd3Y1ZUazViNDVH?=
 =?utf-8?Q?qEF8+IMXlgW5OgqEYheO0tgsS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4eec56d6-eed9-4b13-c211-08de10a499a5
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3604.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 13:20:27.9475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tapCwQTF31PleRYtmDuODsXkwDlNvb7e/HjtN8wQKq8BkuvlmTVbmLeTnPzIm08Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7520

On Tue, Oct 14, 2025 at 07:51:58AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, August 27, 2025 1:26 AM
> >
> > +enum alloc_mode {ALLOC_NORMAL, ALLOC_KEEP_INCOHERENT};
> 
> Is it clearer to call it ALLOC_DEFER_FLUSH? I can see what KEEP_INCOHERENT
> means, but only after some thinking. 😊

Lots of things called flush so;

enum alloc_mode {ALLOC_NORMAL, ALLOC_DEFER_COHERENT_FLUSH};

> > @@ -55,6 +55,9 @@ enum {
> >  	PT_ORIG_SUPPORTED_FEATURES = PT_SUPPORTED_FEATURES,
> >  	PT_DEBUG_SUPPORTED_FEATURES =
> >  		UINT_MAX &
> > +		~((PT_ORIG_SUPPORTED_FEATURES &
> > BIT(PT_FEAT_DMA_INCOHERENT) ?
> > +			   0 :
> > +			   BIT(PT_FEAT_DMA_INCOHERENT))) &
> 
> also update the comment that DMA_INCOHERENT can be enabled in
> debug mode only if the fmt supports it.

/*
 * When in debug mode we compile all formats with all features. This allows the
 * kunit to test the full matrix. SIGN_EXTEND can't co-exist with DYNAMIC_TOP or
 * FULL_VA. DMA_INCOHERENT requires a SW bit that not all formats have
 */

Thanks,
Jason
