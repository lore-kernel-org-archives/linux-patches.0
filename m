Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2059.outbound.protection.outlook.com [40.107.236.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8EF521C167;
	Fri, 22 Aug 2025 14:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755874408; cv=fail; b=tR+ykUupOcx1Eyo1iKkdcFunKCWHfkDFxyndLLyoUl6W2IVjVM1S73dkyzeq04lBG4EMEuA+YRbr8kcEBWU5w/egAoixp1RwPkQlpk3RvGgKmezXf8EUKZc1uZZTzY1hBt6XKlo7FsMsk/F9Tj0C8sn4sof00XTN9UxNgweWw4I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755874408; c=relaxed/simple;
	bh=SLSV4trWl6cLQx3Wz2pjeUG+fWeOTBY8/VMfzS+avIw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ot6x5L2PH0DXHwEoTUPm7U1eCrkz0Pi9a3pSuqjy6R5WOecMCDXY2GA9UpfZWA8SPZZBMJjmh1cOGpfjUA+iSsLgxVqric/b+iPMibMwjJa7IKOI5fjEsSfmN+kJZmFfbjIAIsRAvb76h3ncBLqATlWzHZMBqUz0DjfgWIYHU+g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kpwCsa+j; arc=fail smtp.client-ip=40.107.236.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kpwCsa+j"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PTcMTuQgZLPZXBd3qSH0OSXgfvrjisN1NnMzPY6C4eZNlvhUoHpQ9hpEc8ElS+D3Org7DSunSOEcKlsTdY6rGDXosTVyDAZPYO5hAndT2S3RBQL52AobJw//l6I69zozjwilvAYY7uVzR/pNTXGH2Tfi+P+9x2bB2HLErpRLqcqPSoitLR0tEoy5dcr2W7zqQ92U65u89+K3X4Wq/5bgLpIDUs9w+1gR9YzuE4+AndyWrRrymw+KwHS9fbUgMXq67ifIFetlyoHv5BJ+UdxMe7ooBxv8Si2nUxEUxQkVaKuUlhDpQIiXKM0/MZMJTuRJ5i3Sa1qk2YSIrX05zQdF6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wCHToVyebJBlVtX8h0Lrbxks23P5u+FFiiwrfZ/LQqg=;
 b=dDCuTFd0te2E1gTMgES2WOKpQbeUPt2+ogj3KE8QPJ8x1f2rRRIklF8szSWGlFFvb+bsD3dZTeIXsiZLzeQNDmhbILJPJw2ln1YuRVeBArRYeP3I4kho9OoVZQY3JLXfK38hDaFsd0tejwsVAdj2LE8QjESfqcrVrblPncFVfCR+lzUcaWuBEisniBzk/U+/cZRN5ONqyiemgCL5JP0HcTmd2vabR/mc6l1d2goNF5f4XzpfN6iCnil5Qoma7zt3dzalF2HvcGp+rPgctaS3rd2otLXe+ok9IMk99JTCQjLcAMgx4pXqfMX+yMlQO0QhSZ9qOmIlzZKxLXULScsHfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wCHToVyebJBlVtX8h0Lrbxks23P5u+FFiiwrfZ/LQqg=;
 b=kpwCsa+jbv9uCEdSwF6w4DH2tLe9VoUkgoCnePbM38sdIwKNkk2eZTds/KtGelaUAp9Th8JNS+FSoOrsolkgKujGOjf/YsbAwlrK5JYGqa2EkgG/bdY+1pd2jSth1VzFU7zLH/zeYdWvGW+mjmiMQxgwh5j6SY042l8rUV/iPb2c5zAn7ycyCe5ef90E51OK2n2MkZPpZP5YQbhoTOWbAnautB9biWtyqd+DwROzcMvbIqZj1YXPSH8b/ht2L6/BQIfZIQlhZ1wwLURS4IyvED5FO2HVVoLnrNLma2QzRDKbCPDAfs1sChy5cqGQf+kDG9s0haW2Xq21MAi63s1IMw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by LV8PR12MB9082.namprd12.prod.outlook.com (2603:10b6:408:180::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.13; Fri, 22 Aug
 2025 14:53:23 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9052.014; Fri, 22 Aug 2025
 14:53:23 +0000
Date: Fri, 22 Aug 2025 11:53:21 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Tina Zhang <tina.zhang@intel.com>,
	"Wang, Wei W" <wei.w.wang@intel.com>
Subject: Re: [PATCH 5/9] iommupt: Add the Intel VT-D second stage page table
 format
Message-ID: <20250822145321.GA1405994@nvidia.com>
References: <0-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
 <5-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
 <BN9PR11MB52765178E74F075CA330F7E28C3DA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BN9PR11MB52765178E74F075CA330F7E28C3DA@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BN0PR03CA0059.namprd03.prod.outlook.com
 (2603:10b6:408:e7::34) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|LV8PR12MB9082:EE_
X-MS-Office365-Filtering-Correlation-Id: 240117c7-793f-404f-8a77-08dde18ba415
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZS9OdEJmdmEyajJ4cmpKWjl2UFhZT3FxTUkydEk1SFlDMjExTWNWeGgvMGpZ?=
 =?utf-8?B?V1FIODduc1Q5dkQ2akNXeFN1OXhXemNvWGlmVld2UUNEVk9OODlXSlgzV0xV?=
 =?utf-8?B?REZrT0tmT2dVV3hXOHhCc2IwT01ZQmZtTysxQ2FHQmtIQ0t6dnB6SW13N052?=
 =?utf-8?B?REtibENNbFB6YmZaM0dYb3pydVVNa2loNmVGQ2xhYW8zRmRGbFQ0UXpRTkZD?=
 =?utf-8?B?dlphTFRwc0Zva0VOU3Z3UWVaaW9NMWpJTGhCTHNTNnE0RXlKQzhsY2xNazFB?=
 =?utf-8?B?QS83bGlTYm9VbklGTklOL1MrcnpBTnd0UlFWVGhpTjNpb25OSmlCUnlIcGRI?=
 =?utf-8?B?QStZRmpBODVTSEc3b1pMT0ppRDYvRDlSRWYrUUYrMEpnSytnTWZrOXdyWXdX?=
 =?utf-8?B?MUZLWkNWNmVQcFgzckpEaGpVMlpnOXg2SFdCeEJ2LzhwL0l6dEw1MTF4b2RT?=
 =?utf-8?B?NzRhaDMrbHc1cUVONEg4KzdkVnJWaWpvT1MxREZjNmtaMS9ueWVNVEZCWUZs?=
 =?utf-8?B?V05FRTRWV2ZJbVpQV29DN1ZjdHZPbForVDRwTkIxUGlQaXVhN0NSaFZvYWVj?=
 =?utf-8?B?eDRMaG95bnZDMzBSQm45K2YrWHFuTTZNOEhIQm1jNzNuVkt0K2ZvTVFINzV6?=
 =?utf-8?B?NE85Tk9CL2ZGUmFVS09QeiszSmNPNFB4TXp6MHlmdU9RRUhVUW1landEb09B?=
 =?utf-8?B?bFB2cUYvTUFUUXQ0MS9Sb3dmdnJmWkdQSWhyZ3JPd0YzN0crMnlxZFdFc05E?=
 =?utf-8?B?U1M4eTNQK0dFb1lCK2crUkprSHZabWFsYWswVkhvUnhxZ0hoUVVXdDlnMUJE?=
 =?utf-8?B?ZmxmY0xBYjdHemlmVVdiSjJ5QkhnRDdNWTBKUTNTem1lcmJlVjBOSTcySUZu?=
 =?utf-8?B?ajVMTmFtMDhYbE9EYkE3K1liVE80ZzhDbE9QYjJldFBqQmNBWmErRE1ORGNm?=
 =?utf-8?B?ak50TmFaOU16UzJZMmdVL3RERmJUQXBVQzV1OHJsa3hZTjhiVkpldXJhc3Bh?=
 =?utf-8?B?T0ZZaEFsWXZMdnd2NjlWQW9Sb1h5a05RM2ducVhyRmRJa2FyeDAwM0V5cFdj?=
 =?utf-8?B?VC9zRUJwZStuMGk0L1hvOFMreGpLVVMxdmM0UHlKZ05BS1RPRDN0ZUFoUDRN?=
 =?utf-8?B?a3VaUTFCNUNHMEtZSDgzcUN5UHNlSVBYcnp3UGFoaHBCWTVyUFozM1EyT3lp?=
 =?utf-8?B?QkEvejNEbVcvT1ZnelNoVkxMd3RIN01LTnRmMEhqalNoeEV1bVFnUFNPQkdK?=
 =?utf-8?B?TTJoR0NtbHhnQ25FbnlDYjlTc2piaUFnRmVocGxJZ0loN2JjbkNNMzNxdGFR?=
 =?utf-8?B?UHdvYS9sTzRBM0NmUUkyYU5KeHpUZnVWK0pTbEZBaFJNMTZkMkhITWNJS1Mv?=
 =?utf-8?B?b0VObGptUG1zdTJMdGM2MHM4WGZJOFJLZUJhRGVuUlgya1NhSkdFTmZzbWZZ?=
 =?utf-8?B?MjN2ZmovU0RzNWpRWi9CS2ZkZzdSZVFJZ056OHZHYWNYNmEraEJUb3ZjUHBU?=
 =?utf-8?B?ZjBkamEzTzBlaXk4Y0gwS3hWQVNtbENtclVDQkxVN3B4dXIxWGhUZlp3MGZs?=
 =?utf-8?B?MGhvRlBGRlNXMkNJbTVTY1VnNDQ5QmdRUmZQZVZIQU5DUXZieE1EV2tic3Az?=
 =?utf-8?B?cDA1QW9uOFpOTklsL2xXNEJkSVp1a1JJYTM3bEs2dTdzbFFBWkE3NXg3WWw5?=
 =?utf-8?B?SFlHeW1abXJtOGVSdXoxbmNMWUUzZ1dKdkRjVlBmckF6ejZkbmFRMzd2OURl?=
 =?utf-8?B?MTlQV2RmKzN3dkRpejF5dDlYWDJxSGE5Vi9WM285ZVllOFRyL25yRUVkUGNt?=
 =?utf-8?B?MmFkOVZFbUhHcVRIWGJUUWVsdFZrc2phbm1JeW94TGl4dXYvRlV1bGZLVjBK?=
 =?utf-8?B?bDBJL1FVdXFhNUdBVWFVbWRZNXp6UWJOSW1ZUzlERWdTWkE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZWYxckxBQWcxNHFIRmc4VjRrS1JxdUxnQzRaQkNkZE1weFVGT09xdm16Wlor?=
 =?utf-8?B?Q1dSTDdINGwxM0F0Ym5yT0FZVExBMjhCT0I3N2dSTEcyeFArV05XU3M0NnI4?=
 =?utf-8?B?aWxQbHIvYWpJMmRBWlk4T0xSZTNsTCtKRnRhdjBCc1grOGlkWjNJWWFKbTMr?=
 =?utf-8?B?N2NzVHRJUjNmNk9uNzhQeEp3NDUzQVRTaHRpNFZ0Nkk1aEJCWmZubkpyRFAy?=
 =?utf-8?B?STFrWTJzejdvMmw5cFlpKzVxblgxRUk3QWNRRVhVOHFwSUxhR0lSd3l5K1JC?=
 =?utf-8?B?K2FDRkxGQ2RjaHV3S3BKUzZIRHlFdFRxV0pod25GVTMxQ0dYbTBXWDJBV0Y0?=
 =?utf-8?B?eTZ2Qng4eVQwV3lPbkJ1R2NsUGtvYUExVkk4OUZMc3l0TjBMR085aFk0ZXJj?=
 =?utf-8?B?ajc5c2ZtdXZvaU9Ob3JEbVNTTUlkSURMVTViSXovUEl4cnpDR2N1VUZ1a3Fq?=
 =?utf-8?B?c1R5NEFrM2VhTkluckpjTXJhTVZIU1Q5OE5FWmpzWEt1T3lWbmk4RzRQTWJV?=
 =?utf-8?B?WkZjemlpcTNrVGxrcVRCS3FtTE9JQ0FSbXBpR2wzdGY2VGNSb21hbDhJUEZp?=
 =?utf-8?B?OUwyelJyc0VSTU5XNll2RU96b3lQRDB0dm8xSGtCb01MUzgzc2JrMmZFbExi?=
 =?utf-8?B?UU9odlYwbnRPYTQ0bmVLWldYZTM3QUxYVVk0ekFiL0ZiV1p6NVhuZVNhYW1P?=
 =?utf-8?B?U3FwNTdMUmtRTGY0MnRZNUZaWWlONEVqck1IZmpWbmZEalBsYjlFSHVHWTNV?=
 =?utf-8?B?NTZsdDcxSkhlT2U4bTEvZ295cEtPREpGN1c3MnhUVnZCTytOY25PcktDTUht?=
 =?utf-8?B?NEpnc0MvOG5zQ09DNXVQNWRNQk9HTmRueTRGOURxSEl3UWpUbVdwWjVCWno1?=
 =?utf-8?B?UmVlMzFMUUVpb081SllhRmc1eXdFcThNQS9WRDlQMHVBdHZkby8waWZrREt2?=
 =?utf-8?B?eXFrOVpTRlNaMHN3dXlyWjlXUzhkci9WeGZXM01xdlJoaUYxeWlmb2pnWXFn?=
 =?utf-8?B?UktUNUJuVHA0SU94V2ZRNXM4U1JOZHdNV1psUnBkOHdYZVo0S3Z1RExVNEh0?=
 =?utf-8?B?N3UrZC9zRXpUaThRQjdZS1pQWkF3azZPMko0SStZWkxxa1M5cldjejFRRU4x?=
 =?utf-8?B?RTMyYnkrSjFwNk9lRmM5NVlCa040ZGN4aEJ4NWVmeStIMUZ3d0dsQzhjTDMx?=
 =?utf-8?B?VFlMUE5mVnVGNWw5UzdITEZJd0g5Mjg1T0cwRStHN1RlaHNJam9MRGhIbjdh?=
 =?utf-8?B?ZHJFcnM2elp3bzQyaHM4L0NaWHdXR3ZXYTdjWUhNMU9ZeGtFaTJ1RG5OTnNR?=
 =?utf-8?B?L1hkTkNQRFpTcEV0WXpRSlBGeWFWTW80NHo0Z0o2S2pqTC8wa1JwZFlGcGRC?=
 =?utf-8?B?eW1ZNU9BQnRrcjZvZGdWTk5abGlJaVRINkNxcEhMZ2g2MGhrUUJKN3FDM1M4?=
 =?utf-8?B?TUo2ZVIwZlpFMjZjcnhDeEFsUk9SRmtwb1I4TDFaeXFJQVRTbEJoMEZjbTN4?=
 =?utf-8?B?V0lVc0JuekJxeDRkajU1YTgreEVNOWNvR1ZYaFgxQmg3dkR2ejJzUEZxRHJN?=
 =?utf-8?B?QU0wVEVWSjdNWWJMWEF1M0Y3cFJRcHNzMjIvSEZtZjB5TGxlek11K3c1dThn?=
 =?utf-8?B?b2NPQityTHZ5ekx5QkVCcC96N1pkRzFqcFNwNkMzZUhNcy9jM1lNMXRHWUpC?=
 =?utf-8?B?TFg0Vlg0M3Z5NnNKbEZnSy9KVUY1cWNCdmNkeDJtQSs3ZVI2M1hDcUtsdU52?=
 =?utf-8?B?dEtLOUtKcyt4ZnBUcklzQmxyM3FoRGt5T2Jtak42ckNBRWdvMWU2dVZUdWxa?=
 =?utf-8?B?b2plaEkxb0MremczZW5GaVovT3YxWGcwdVJWeG1SNEV1cWN6ZURORU9JN2RO?=
 =?utf-8?B?cFhkbWVqNmUvRlBjdld6NHdXYW1JSWpnUk9NYWJ1cVBvbk5xMzdqOGtheFp3?=
 =?utf-8?B?R1ZUNUlrcGV1cHVuL1VURmNIQlR5OWU1cHhkZUJhZ3IrRURkNzUyaU9MREJ2?=
 =?utf-8?B?U2pqdWttUlI3SG1TSSt4ajBiZUxrR2xJVGdUbzc4a2JhRzF4T1lPY3drRm5w?=
 =?utf-8?B?ZmRwY3VCd3E3amU3bk5MV1o0UEJUd3h2LzlSdFNFL04xemI5QjNDYkJ1VVlE?=
 =?utf-8?Q?E4VSuX+MaBd2BEnyDgv55jjqL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 240117c7-793f-404f-8a77-08dde18ba415
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 14:53:22.8057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jzXYstpYYR1Q2kfy4GIxel2hqJstPAFYoZrUcGeHMiegMQ+TV6LxAtZXmsQzH7Es
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9082

On Fri, Aug 22, 2025 at 09:14:09AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, July 17, 2025 3:58 AM
> > 
> > The VT-D second stage format is almost the same as the x86 PAE format,
> > except the bit encodings in the PTE are different and a few new PTE
> > features, like force coherency are present.
> > 
> > Among all the formats it is unique in not having a designated present bit.
> > 
> > Comparing the performance of several operations to the existing version:
> > 
> > iommu_map()
> >    pgsz  ,avg new,old ns, min new,old ns  , min % (+ve is better)
> >      2^12,     53,66    ,      50,64      ,  21.21
> >      2^21,     59,70    ,      56,67      ,  16.16
> >      2^30,     54,66    ,      52,63      ,  17.17
> >  256*2^12,    384,524   ,     337,516     ,  34.34
> >  256*2^21,    387,632   ,     336,626     ,  46.46
> >  256*2^30,    376,629   ,     323,623     ,  48.48
> 
> It's a big win, thanks! Out of curiosity, is there a single aspect in the 
> new design contributing most of the improvement or is it just
> accumulated from many pieces?

I think this is principally from not rewalking so much. The new code
fills entire levels with leaf PTEs without rewalking back to the
level. This is somewhat tricky code.

> a side note - the variation between avg/min is getting bigger in the
> new code, but it's not that important for now compared to the
> overall gain. 😊

It could be a side effect of running in kvm..  I think the new code
has alot of instructions and branching so it is more sensitive to
cache performance.

> > +static inline u64 vtdss_pt_sw_bit(unsigned int bitnr)
> > +{
> > +	/* Bits marked Ignored in the specification */
> > +	switch (bitnr) {
> > +	case 0:
> > +		return BIT(10);
> > +	case 1 ... 10:
> > +		return BIT_ULL((bitnr - 1) + 52);
> 
> bit61 has a meaning now in the latest v5.0 spec, though it's not a
> good practice to repurpose an ignored bit.

"not a good practice" is an understatement.
 
> > +	case 11:
> > +		return BIT_ULL(63);
> > +	/* Remaing bits 9-3  are only available in some entries */
> 
> s/Remaing/remaining/
> 
> strictly speaking bit8 is A-bit in all entries. Probably no need to
> list each bit here or just remove the comment. People interested
> in the detail anyway will go to the spec.

I wanted to leave a note that this was not exhaustive

> btw bit2 is actually available for software usage.

That seems to be a spec mistake, it should be RSV since it used to be
X in earlier HW?
 
> > +
> > +	if (iommu_prot & IOMMU_READ)
> > +		pte |= VTDSS_FMT_R;
> > +	if (iommu_prot & IOMMU_WRITE)
> > +		pte |= VTDSS_FMT_W;
> > +	if (pt_feature(common, PT_FEAT_VTDSS_FORCE_COHERENCE))
> > +		pte |= VTDSS_FMT_SNP;
> > +
> > +	if (pt_feature(common, PT_FEAT_VTDSS_FORCE_WRITEABLE) &&
> > +	    !(iommu_prot & IOMMU_READ)) {
> 
> s/IOMMU_READ/IOMMU_WRITE/

oops got it

Thanks,
Jason
