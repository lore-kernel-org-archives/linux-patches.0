Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2053.outbound.protection.outlook.com [40.107.101.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB11947B;
	Mon, 29 Apr 2024 14:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714400952; cv=fail; b=B2pKo5b38thK28W2W67bqLpSnLrsZbjrXeZRsmXeArWUbSH1++Vg4m2ep3txTZVQimKLJLNo2bnkz38N1uV8AfeKaV5+yCaXjz5DHClkxv+VDzywqlESWxxdD2KGmh5+sLZ6BI6C2HyCvEaBVpHpXOaG4cn0eaaQ2xbpU7olu9c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714400952; c=relaxed/simple;
	bh=ob1aaEevkSVg57P83p5dN18/tSLn74aWOeA8OasXRZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=I9+LmNr1hlIF5KchhufZtXElqsJu6ThdNHBYzDdc+lddlt+74mpTYLZwYU8xlg8XVHF3YaxZ24OpSLVt//2Sqa0pxSHqWmOI4e717blc7LJSO/pGRQqhS28Xg0XPO9Yx7r/Nqa4kpDJy2AV5YflykVR93+7eTjK6mnMHEvGNzTI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rSDjMV2+; arc=fail smtp.client-ip=40.107.101.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rSDjMV2+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cfvl/aH0mYxK0JkRBSpqpjDIfvpbcK1oYFiMau4b1c0FY0ajjhBahCeWgqjFBUsu4VGjpsXiTKpGKT/eDRiXeZd0BMdiX5aZ6rsAaN1FX5Usv2x7Mu7/6ntjl9tJpnLSqfQ8RoF10Dv8SsGYQoI4/WkDyYFERmoFzxt6kWAUcFLX9eijoMok5HBudX7g4C4uyJE99pwRnDJTaJCVWaOlZn+5jgf/5EAznLped5J95NUmoNrv7X1cW4IK9ZWa639tMSHzTFlCwb/J/hI7TREQDuR/S7eflyuoU5elH/M7FX/2VF0JgszekGj3e0IBkJhr5y333Z8sMhwHj5DRf0ZSKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U0YATmDWLNaEUZszE96GhMUzn8JO1l8JtGgvJVaTsIE=;
 b=DTWWbbGMWJIWcOg6bfsPpRoI1geUZ3us5lFa9SzheCA52J9cyJA/iI3OKCCrF00BrfIJua6uyp1iSeJ2qIOaKibUBFogtZqH58ue9Xg/2U6EudWAqwKX1PcfK+QLd6TuDBnqM0BZJnJlS6k5yCvtUCkmTHKxBnAybhjqMfpYucbOLDqNKBpWX3f9pcY+OPbM3hj6wOtpotutVbSOFe702U3YspB4ABMDOC9GI/xNpS6PnppORWJTvD0LXbj+TaVDaG6+pmfbpfcG8w+VdfSIpKNFz03X9QK/mwyoCvhxAaKbMDFpfzxfqNZCfm1q9oXPib1+dOgFmwcCK59wTDN19Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U0YATmDWLNaEUZszE96GhMUzn8JO1l8JtGgvJVaTsIE=;
 b=rSDjMV2+g41qcprNDPuoB2aoDPIcuaArofT1vhkfJtWW+ltE0iVGiG0q6+/u36e9dCm323C5ky/3p+1+6UUhzoKtYwgSwmoPbr7FA5S4wXy8GO/1rDpVds5BENNozD7m2qQt3W40ft1nlfnvYoGh4FX6SuC5Kiet5j737F613mogAxa6FNC+uEkysTn8PS2/YqzQA65lgZKENG1lmnpnkByRNpZGyI0whxGQTR3rhaPwPxk8jp9Ux8HNWOj6Ekoy9Hwv7m3lyVnB1639k7k49Lwok70be2qLoHW5304aJJJe/pEZ/fimOQ2I0Uw9zQBJ0lltJId5X/CEVQLxi2Uj3Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH7PR12MB6936.namprd12.prod.outlook.com (2603:10b6:510:1ba::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Mon, 29 Apr
 2024 14:29:07 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.031; Mon, 29 Apr 2024
 14:29:07 +0000
Date: Mon, 29 Apr 2024 11:29:05 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 2/9] iommu/arm-smmu-v3: Make CD programming use
 arm_smmu_write_entry()
Message-ID: <20240429142905.GF941030@nvidia.com>
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <2-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <ZiLdB6nVg9S65Q1G@google.com>
 <20240422132954.GB49823@nvidia.com>
 <Zi13eaOCQFdMO1ut@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zi13eaOCQFdMO1ut@google.com>
X-ClientProxiedBy: MN2PR07CA0011.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::21) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB6936:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ce4cc68-72b6-4640-ed76-08dc6858ba36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V2o3bEU4dGtHam13czdmOW9IR29qTkNmcnBPWDg1UDlMaFhqUXRBbmNUUWdI?=
 =?utf-8?B?TjQ1bS9kdFozOU1tTGZkZklmQ2d6aWJ3dTliWWMyeHVsREdqQldWUHI1aHVJ?=
 =?utf-8?B?U25jSTVOR3dudGdxMllQamxsVnJYcHA2a0NVek1zOW5qSHA0bEhRRlJ1MUJq?=
 =?utf-8?B?bnlWT2dxcWpZczk4eGhORkRXelEzNkNiWEhrUk1aNUpxcWgwOWUzeS9RSWdh?=
 =?utf-8?B?L2xyS3hwVHVBVDg0cktOdHRjdmlDcXVUUnFCSDN4MGJOSnY2dkVWMzhOaVhi?=
 =?utf-8?B?eGdqS3BYVWRQMERrQVhkZE9DekV2OGl0cUI0RTE2ZVZzT2NNdHBJZ1ptek5Z?=
 =?utf-8?B?cTVOMm1kbHlqaGNCTEV0akloNXVPQjJESzhiVXBSQTlJajYzV1Y5ekxvTlRB?=
 =?utf-8?B?NmZST1kyVkV2R1BLanhQemJlZVFJekFWSEVGUEF5L3FlR3F1VFFKV0gvaGJR?=
 =?utf-8?B?VTQ2dG9GKzRDODMvSzRzazhMd1JlMlZ4M24vNm5xdVlUQVJLOFdKa21Bb2dR?=
 =?utf-8?B?NVBvbDVGYldjZjFzcURQZ2dDWDlxRUVkYUM2dmFDekZwOW5UZTJ1ZkNVMStz?=
 =?utf-8?B?ZjRoRGpLUHVVOGxsQWQxcGRSRWptUkdJZW9Yb3VRd2RBNnR6dVdzWWo5d0hk?=
 =?utf-8?B?UGs2UlhtN050TG4yTVFpUXVoQURLMDBaRldxbmRsa2VXck5sV0IvNEt4ZS8z?=
 =?utf-8?B?Yk5YSjZ4bnl6MHpFUy9rQ3Bib2hCTisxbXZ3S3JsZmpTZ0ZRSGxtZ1lvd1FL?=
 =?utf-8?B?cktuUDJ3YUFIenVwWjBHTDd1K0FyVktlQ0dYUk5QYUFhOG96RVlJTmNHOC9q?=
 =?utf-8?B?a3owMHg3QktDWVNEMnZ3Zkl0SU9wTmVsaTZIM2o0WDZ2R0E3L0N5MlpLLysw?=
 =?utf-8?B?aE93ZFltbXRaMlM5QXB4d0RESXRwVDd3NlMwenpuRXFIK0dZdDBPaUQ3eS9o?=
 =?utf-8?B?bWlTVnNCeG5BdjVwaWdvcDZzaUdrNks3cGRITGc3am1jUmc5d2E4OC9jSEw0?=
 =?utf-8?B?NGI0dVhQYTNNd3VlaE1nKzllRzI3M3djQmlrWnUxUGt6V1dxT0QvYStIcjc5?=
 =?utf-8?B?OHBXSEdIRTkyRzgyL3d2cXh0amZsRWpab1ZtdVlxc3VJZHhRMHlTd01EME9E?=
 =?utf-8?B?ZC9rbVRVTTVIcmk0RW1aTG5lSDlPbjI1UC9zL1RpTjUzdVJVYVFLTThtc0lV?=
 =?utf-8?B?eXRZa01Zdi9vdmxlUEZ4aFpQRit2WExOalV6Tmt3U1o2M05Ga2F3SEFadUIy?=
 =?utf-8?B?K1ZFeGFvWmp0NFFFdHZQYmRLRitpb0VzYm1WcGV4STdKS3RqWkdxSW5pRG5a?=
 =?utf-8?B?RFpQWVZQUnpYYmtyelQ2VVh0VW0xYmlZbGlqUUxFa20zVmNxK09XZDdWQ1cw?=
 =?utf-8?B?VFZlYUtFTWJkdjEwL1k5RTF1WjVlc2NhbnM1bFRLczdoWFZYR01UN3gxZXJl?=
 =?utf-8?B?ejRlOEtCL1ViQ0kvdkFtOWtHSjd6K1JidVRPUHlMd1BjUk5USEtVdG9XZVlp?=
 =?utf-8?B?NUhBTGk2MkJDNGF3SlAvQVJIYk9NZEtpeXI2dnVzcTcwRzgySmdOelUrdUNq?=
 =?utf-8?B?RzZpaWRFa2Q4KzR4WXcvTVFicE1Ga0gxcG1Ob1hoL2dIcitoK09hWngzMFdR?=
 =?utf-8?B?eldsNnYrUkx0WHljY1VrUTNxVlB6eFZHbklEVGVRWU5namtwY3ZkeGR1V1pl?=
 =?utf-8?B?bk8yQXNzQXRZeEdmdW5PcnNGNnNvUVhOYzRKWTNrVHcwck93YmxuenN3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NndmVTBvUTVPZEN1eWd0ajcrTWZ5VkNSdHI2TFFQcitCMkYzOGIwVFo0dXEr?=
 =?utf-8?B?L281TEtkZ3kvVXhlRGRqTytwSFBZbUZNVXJzdmZ4Z3VoRTZXK2EzRWRkZFV1?=
 =?utf-8?B?OFhtSzkxRmZZS2tLczZzN08wZC9OZlMvUEtyRnRNUHpZbWVaQ2hYb2tyR3g3?=
 =?utf-8?B?ZEVIdXg3dk04eHZIWkxPRGVMK1JLakxrbmdOT1gwbVlJTXFvOTNhK0VER251?=
 =?utf-8?B?NVhGeGNMaEVqMkplUWlGRENXUWtPbnpjd0x4dGw3NHdHaW56YUJ0dGl1V280?=
 =?utf-8?B?T3E2MzFDTml0WkU5THo0WUNWMWQrSjQ2c1R5amh0ZWwvTzNpR2ZuK1Y0dE1q?=
 =?utf-8?B?RFJHNTg3cE5HV2oybndlTUh6bDVOY0FnNFJZSjg2bmRqeldVUHlTSGRsTmpC?=
 =?utf-8?B?ZlJLL3VvMjllWG9IZ0kwQnRKZDZBRHdZOVJVWFRSd0YveklpT2hicVZsYklU?=
 =?utf-8?B?RU80VXpKTHVLZEtXK3liNDBpZmVxQ3RqYkZCWXdvVngxdmNIaTJCSnZkL2RP?=
 =?utf-8?B?YTEyeGViTzJuNEorRmxxSTVWRjN3QXlaamNwSlFoZUs4eHNXTEJjRU1aV3FQ?=
 =?utf-8?B?bDNOdExmV3U2dy90Wnd0YWNLbnBUKzRiYnpDeW42NnFGa1BHVTRkTzZUVVBt?=
 =?utf-8?B?aCtxTnJid3FpMHB1ZHZrU2FwQWZWZlFpN3RBRFZZaWpQb0NCNGVwTUJLYkJi?=
 =?utf-8?B?N0c0c1g3bTZWVzB4b3RjT1NxMkUzZGRUSFFJV2hDQ05VNjJMRDM5N1pnT2dl?=
 =?utf-8?B?Q08rWmhtQm9XT1RRNTMwNzk2ajNMRGl3N0k2VkNMME91YU9qREk0VXZLd1RR?=
 =?utf-8?B?dlA5L29TLzR0K0lJT01DWFRnWU5xUk5sclZ0TDN5c3Z5QTdxcCt3YVNucFZW?=
 =?utf-8?B?NWNCYk9YN0dNS2NFL2RzVGpvQzFicXBMWm1kZ2orQWVrZXBHb1UvclVtbXlZ?=
 =?utf-8?B?T0pod0dqSVhLWThWeVR4ZlErcjNobXgyQ1BoOC9MVWpFWll2Qmt0cTRlenVz?=
 =?utf-8?B?MzRQcnEyUG50QWJMWFdYdDhXQTdkYjJyOHlxblppMlhYTWZDVGpVampJVDhS?=
 =?utf-8?B?RjRPRFNSYWM1aWFkQWU0Tm1YVjV6cG5NV2gzS3VpU3FPZEdjdHg3b2dMd1lo?=
 =?utf-8?B?QXhsMzVQa212UTRJTGtjdDFPVDQ3OGJxS0F1VzVMeTVZYXJuZjlhK2cvVW5q?=
 =?utf-8?B?cVlzUmQrSnZ4UDVFQjRSTzZxWlJVQnBnMFBzK2FWRVZmK3lTSTUvQ1FyYWZa?=
 =?utf-8?B?NXJaWklDV1Z0QW5YVGhSbk5wV1FSQzMyWkFrelpmUWd5RGdONGRlYVhVMnJx?=
 =?utf-8?B?NDNIRDhEdXlJdXMyVTJqbVZTaDBiSmVWNmJ3b3BaaWprQ1NDVHc4OFBOb0Y3?=
 =?utf-8?B?U3IySDdQNW9SUVZXVm81M1VHS0dMT0NHUCttL1dEZWpMYXRHSkhRSUhzRmJC?=
 =?utf-8?B?NUlJLy9TTlV1YkJjOURJT1NuKzBHOFdCOUJjeEREU2IyUmFIRSsrY1YrTkhR?=
 =?utf-8?B?MElpT0syVkltbTVsWWJXSTNMTHpKdUFXS2J2ZTVTdHorSXoyUjBDYkpGL1Y1?=
 =?utf-8?B?YjBOZFBGQ2dJRmEyUWdPeE0vREE4Q3JGVURhRFpUdjE1T1hQcmRXYlNGR01p?=
 =?utf-8?B?bEdzQmlzSG5sZHVJQ3FwY1o3K3JrazFoRmtUTlBCMVR6QU5VYkpNZHJvS2Fv?=
 =?utf-8?B?Mi8vMk9JdFBKdTFFVjlsU0Joa1RJYVlkYTNMN2kxeGM2bCtlRzA1OGk2elNl?=
 =?utf-8?B?aitESWNPcXJuNDlaUm40TC9QTzRXcHg4andTUE1RNjVDcUhVQ1libS9iUy9z?=
 =?utf-8?B?YVFzbXlBaWo1cFBRTU00SWVnM0xWNElYcC94dlVuc2gvbTJzT09ON1dQdXdj?=
 =?utf-8?B?czBjaDlaZ1RFQkt2Q01PbFBSNDBwUjVjSURLdUFyaVhsZk80MklRZUpLOWxN?=
 =?utf-8?B?YmZGQ3BNQkQ1NDFQMVRkaHptd1FaakFUdWc4VXRLYjZobHVqZHdMTEgxc0M3?=
 =?utf-8?B?RlZqZ2h3RDdLVmdMUm9MelFJdWVMaGp5K1A3N1Q2UzJESmJpbGNKQUNUVHdX?=
 =?utf-8?B?cmxvSHNuNEdIdGJDTklZWVlVb2NxN3JUbDEwTnNENmx6K1VIVTB4Y3RZMVlS?=
 =?utf-8?Q?97DYmzmgbKDsX/joVv+gmQsJ1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ce4cc68-72b6-4640-ed76-08dc6858ba36
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2024 14:29:07.1877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CZfiih9huv16dKn8OtOmY7LHRYmEXpwHs3+20fmTNc5qUYIoYTbcPahnAmgSQwuJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6936

On Sat, Apr 27, 2024 at 10:08:57PM +0000, Mostafa Saleh wrote:
> > The issue is the old logic constructs the new CD by manipulating the
> > existing CD in various ways "in place" that ends up creating CDs that
> > don't meet the requirements for the new programmer. For instance EPD0
> > will be set and the TTB0 will also be left programmed.
> > 
> 
> I see, but what I don’t understand is why doesn't the function construct
> the CD correctly, as from

Why? Because it never had to before. It made minimal edits to minimize
the code.

> 	} else if (cd == &quiet_cd) { /* (4) */
> 		if (!(smmu->features & ARM_SMMU_FEAT_STALL_FORCE))
> 			val &= ~(CTXDESC_CD_0_S | CTXDESC_CD_0_R);
> 		val |= CTXDESC_CD_0_TCR_EPD0;
> 		// populate the rest of the CD correctly here.
> 	}

What you are asking for is this:

        cd_live = !!(val & CTXDESC_CD_0_V);
 
        if (!cd) { /* (5) */
+               memset(cdptr, 0, sizeof(*cdptr));
                val = 0;
        } else if (cd == &quiet_cd) { /* (4) */
+               val &= ~(CTXDESC_CD_0_TCR_T0SZ | CTXDESC_CD_0_TCR_TG0 |
+                        CTXDESC_CD_0_TCR_IRGN0 | CTXDESC_CD_0_TCR_ORGN0 |
+                        CTXDESC_CD_0_TCR_SH0);
                if (!(smmu->features & ARM_SMMU_FEAT_STALL_FORCE))
                        val &= ~(CTXDESC_CD_0_S | CTXDESC_CD_0_R);
                val |= CTXDESC_CD_0_TCR_EPD0;
+               cdptr->data[1] &= ~cpu_to_le64(CTXDESC_CD_1_TTB0_MASK);
        } else if (cd_live) { /* (3) */
                val &= ~CTXDESC_CD_0_ASID;
                val |= FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid);

I think.. I've been staring at this a while now and I *think* it
covers all the cases and we won't hit the WARN_ON?

So sure, lets do it that way, the code is all deleted anyhow ..

> As I  don’t think the right approach is to populate the CD incorrectly
> and then clear the parts not needed for EPD0.

It is very easy to see that such a simple algorithm will not trigger
the WARN_ON. The above is somewhat trickier.

> Also, TTB0 is ignored anyway in that case, no?

Only by HW, there is a protective WARN_ON that will trigger in the
programmer, that is what this is trying to avoid. For bisection.

Jason
