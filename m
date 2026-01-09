Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BC51A840A;
	Fri,  9 Jan 2026 18:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767983036; cv=fail; b=TkcUEv47e0MMn6f7ESnrHR3pNDbgl2qkizsFm8Bvp2sqWtgQCdubjT3T7wEZpHLYWA2FRLHUHZUA/SMWXNUenSeooRadkxs3M2Qo0I8JPnGvpEHuud0RBrjVQSDvU3XSgspou0DhEKUgLwL6Poo2bl353DETxqHLWPex27DDcnU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767983036; c=relaxed/simple;
	bh=/SkRx4YWRR8pWdHxYcd77T7z20Q2X1V/sQBZAaZWpqc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rziG8JMYWoC6mM33a8BiGVsz/iekjcwiX7KB9Sxg1msKsNW8kUXXwcuLdstAda49UBSGAuv1AfVikdDUb1bEivj23nGadvFn8NJ5AK6bKvYc2o+wXKgsV8tjygCqW5j1V3fGpOSjMzHdFWP7QtketxF1sz3T9M+Qa1ZCqu+5/6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kTCBEUhS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rYJNum5n; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kTCBEUhS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rYJNum5n"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 609HiHSS4077106;
	Fri, 9 Jan 2026 18:23:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=w3hTvbwzF1VWiKG+ldZ7s+3uk1/gOWtf1fvKsfAcawM=; b=
	kTCBEUhSnZdCTL/mVhrETX12f7tFeUlC1c5fvM1vrLxbzia1EINN6Xx8WgKcUSWu
	LfTSAXwHpMkeJgdLycbTZf7L5xiu8qodzH2gPJ99AtfjQ5xUQW9EnB8sfjkloQ4L
	1qB2uD8xF7/62M6tkPff4RhwK6UzA4xBm1Zzo3L9Xm+RZ0kRPlN7EzkhTTGQDdHB
	cxdjRocvjXB0fPNrvIadxFWCxPa/QdlBGdB9vAmDz/cjanC5AO3lxCi+3vSKl+aP
	0RysMyqjAzILIsCredHHZNzBYzEV8HwJL0z+w0Fy/5E+UvtT10z/G5RPKbyzxv2I
	ufnXRxZiJarn5ar9JEQ2Tg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bk6ba81v8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 09 Jan 2026 18:23:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 609GMFoM027341;
	Fri, 9 Jan 2026 18:23:39 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013042.outbound.protection.outlook.com [40.107.201.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besjcdh4a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 09 Jan 2026 18:23:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BWIed30CsSRtD3pZcZH320Seb5CCZAO31F4o4YSx8GHWQNZeCdpJ3gtrfBJ8v02+0duqKev/ktcIbJpdHGP5AlTqThEhsAWrQ0jFgX1JnTaL4Vw4SD/AApzSwpPi1ziEXMO6nOXlrUULPqIEqooo2T0Q63VCMtXWK9nglzYAPy/l/9Zxa8GXpTPGg8zBb1i4cmGDYbUBod/CKywQv7aQ2WhIGwFzZBfGcOAVe+dZbxwPrGs204BAT9O0Qxewcb7vqBYhU62+ovoK2b3rY3AereU2prI4rVrPXviHnZJd2VH1XcO2dBlre4JCOClZbE3nPQ+aTThTflyUZ/1DBlBJFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w3hTvbwzF1VWiKG+ldZ7s+3uk1/gOWtf1fvKsfAcawM=;
 b=kOfI3F+kxSW2KyYe4hY7VZEmWqOWPLVex8DZZScTGzyxg1Bz0N82mZpOuxWMuna8yQDWUE/cak1p0sPtMJL9wzhbecjBmXbYZw1vrWZG8kespyJhj7zH52v9PDykAgpUngAOWKG8Zx+5CR8zqyZUrdO9up7NZWk3n7sTevNU5HDaB81Kk01ckmWhfcNTrmT1FWfoN5lYVUudgSeoZp2x+y3/VQezdRfD8j/4S/g4CCJB5JMGcPTa/9b36Y38Fcar3rc7CKYVZsccQZa09nqbD72SpDt92lVqeODrNKszrehwStrGyVITsuKBhoWmxR4n5drR9m8h0h6/lhBFjI10nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w3hTvbwzF1VWiKG+ldZ7s+3uk1/gOWtf1fvKsfAcawM=;
 b=rYJNum5n8m+2u/MGelPnXb+muT2QbhZY2g4v5CcJzk6oT/T6DLMDE12smO5eyWsLfUs9mYfafAjthoPSJMjg1IGIKV4DlqDyyBOgqHt3wEOkoUdqNIE2hyiaJI8/tL3XYyrGl+77S4/3RfaukiUGh5B/R7G9lvtznnRKWJSyFKU=
Received: from BLAPR10MB5041.namprd10.prod.outlook.com (2603:10b6:208:30e::6)
 by PH7PR10MB6177.namprd10.prod.outlook.com (2603:10b6:510:1f3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 18:23:36 +0000
Received: from BLAPR10MB5041.namprd10.prod.outlook.com
 ([fe80::2c19:641c:14b9:b1b4]) by BLAPR10MB5041.namprd10.prod.outlook.com
 ([fe80::2c19:641c:14b9:b1b4%4]) with mapi id 15.20.9499.004; Fri, 9 Jan 2026
 18:23:36 +0000
Message-ID: <f2ac2a90-8aa1-44b2-a41a-31560a254674@oracle.com>
Date: Fri, 9 Jan 2026 13:23:31 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rc 1/3] iommupt: Fix the kunit building
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
        Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Joerg Roedel <joerg.roedel@amd.com>, Kevin Tian <kevin.tian@intel.com>,
        kernel test robot <lkp@intel.com>, Nicolin Chen <nicolinc@nvidia.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
        Samiullah Khawaja <skhawaja@google.com>
References: <1-v1-946859fdf97e+1bc-iommupt_kconfig_jgg@nvidia.com>
 <81de8774-535e-407e-8b01-5676c2cfd204@oracle.com>
 <20260108144902.GD23056@nvidia.com>
Content-Language: en-US
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
In-Reply-To: <20260108144902.GD23056@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8PR07CA0009.namprd07.prod.outlook.com
 (2603:10b6:510:2cd::27) To BLAPR10MB5041.namprd10.prod.outlook.com
 (2603:10b6:208:30e::6)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5041:EE_|PH7PR10MB6177:EE_
X-MS-Office365-Filtering-Correlation-Id: 55ecd950-bbbf-4f7b-f1fb-08de4fac341a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K2tNR2RrWVFNVGoxWkhyaVAzNmg3Qk42U3VVMVJCS3dvUElOQmVXRlptZmlU?=
 =?utf-8?B?UlpMVnd2TnhqSEU3S3V3dE0rd2I0MmY5c2gyNGdqaURLeU0zUWRMQ2cwbmkx?=
 =?utf-8?B?VCtMYTM2bndCeUhsWEN5dnMwRUhnWVAzSVNpLzNhcXYwS0lNV1FKNVQyVTRT?=
 =?utf-8?B?eUplcFBkNGwycG5EVkFvQlZqTWphSldScXdObTdUWDc4dmJQMTZ6WkxBZlpL?=
 =?utf-8?B?K05UckdCWkxURnR2L3NlK3B1bHEzc2lrVUQ5bE1uSzFMNUNoY0JZNkZzbkFP?=
 =?utf-8?B?MUJzZjVueHBSMThxL1JRb2ZCd1BwUzJFSzJkWmFiMENxYlVPSTVKQjN1UkFG?=
 =?utf-8?B?SzVueEVKWCt6dG1lNDFvZWhvZkRNMXQ5WUVvcjVEZVg3VytxYTM0dTVJWE01?=
 =?utf-8?B?UnU2NlBBU01WY3F5Nm1tQTFUSlBlY0JSR1RGcC9XZEIzeUM4SythSG5MUHIr?=
 =?utf-8?B?QUpkSWZnTkdQZ0tZdlk3akszRU1SWUt3aW5BcE54UkliYjM0T0Rjenoycm42?=
 =?utf-8?B?QndBOG1kd2xScXhlNmdadFMrT2lBTVVhWkJHbWNINjkybnZkeTNUSXZSWmFi?=
 =?utf-8?B?dnVlYitYeVJXYXQzd0gybWtaeW1sSlBudUsxZlhsYzV5SE5hUVNiakpJWDNp?=
 =?utf-8?B?SlRtNkNrTC8xVU8wOVMxa0wzc1VPSUtSckxNRm1ZcFdKZkNOYnNTOERYaWMx?=
 =?utf-8?B?ZVNhK0lCTFBLK09kNVQrUVRtTE9xS3dZN3RpSHpWWkZ0cWdKTmJYV0w4anEv?=
 =?utf-8?B?cjRuMGptSTVGbklQek8wTXBkOVd5NXRTKzFoZFVyMWlLNDJxSll6cEJjeUF0?=
 =?utf-8?B?NFpUeHBCV25oeWpsUGZaNGJaaUZTa1R3aGhSSUY2Qi9IZU0vSVNuUkRhcm5C?=
 =?utf-8?B?cktrTU1LTi9hbnZQRWlOSVV5WTNCSG9XTTlOcEdIaWZoSzVFMUpLZE1DbkVq?=
 =?utf-8?B?N3lnaC9GMVJkRkl3dGtyV3RoZmFhL0hDZnM5WklXQnhqOUlqd2tBRWp4QUVD?=
 =?utf-8?B?NmNXWkEreWNQNWtOV0hZb1k2eXdiejdoZVQ4VnN2VUZCMDBRTzhvUkdGMVg5?=
 =?utf-8?B?bUNMQ1dzNVZQNDVmaFBZazkreE14VXV4cHBKSnJVMzBZb1ZZQkMrR2RuMEQx?=
 =?utf-8?B?OXZVU0JSWFZCYy9EY0c0czVxK010L1BVUXpYSjZtV2RWV0VzQnlGcE43WUdP?=
 =?utf-8?B?M1VXTnhLcjNzR2pDNWk2Q24wSHdqZC93cFRKK3hmaTM1a0c1YUMwL3hQV09S?=
 =?utf-8?B?R05RL1ZmUEJQWUppVlhVdjZlcFVROURvTHRXY3hmWmp4SGdsejlSOSsyRmJF?=
 =?utf-8?B?bDltcHJSdk1LREIvSjN6a1NRN1c1NTU2dml3YVQwVzdETFRmS2RFWUZXU2Jy?=
 =?utf-8?B?eGJiZ21Jb1EzaDVzUUtEaVl2Nm0xeVBha05YMkRVMDdMMHJLTFEwVUJUbTV3?=
 =?utf-8?B?QXY0MzNNeURqbm5FWmdMU3JkdmYxVUFEL21jNFFnaVhpc0ZoZjI1M3VVZXRz?=
 =?utf-8?B?b285OXkrcXBwWmFlZTNRVFc0NEU2NVoybEtaT0VCdHpHSEtqd1pwK01VOWRG?=
 =?utf-8?B?amVRZkVRV0xrUTU3ajZxeGRjM2I1Z0oxenowZGNEWEpsQVUwUm5lUkt3UEhE?=
 =?utf-8?B?SjJHeHY0Mm1reE02bTJ6cnZTSFI0ellSRmdwVkc5L1YwL2dnM282b0ZZUUdm?=
 =?utf-8?B?eVBGbEpHWGF5cFR3SXB2TlFDL1NPeWdsYUFFd3RXL1BlQ2FkMnIxNzI0MExR?=
 =?utf-8?B?WFdmdklEdURiTDkrWDhjOWo2RDV5U3lZMU1OVWxQdmN2RE5HTWJFV2tMNFhy?=
 =?utf-8?B?YjFVVzdjY3dzbktTWXVCaXBNdHlYT21KdzMzVlFDMWduSHh3MDAzcFlFR20y?=
 =?utf-8?B?UGNZRDFPN2lmMmRRUjNwTXpZZ21CMDVSUG5XYjlncFlQdCtLVE9DM1RxVVNF?=
 =?utf-8?Q?bcMX9+qsDLjhYlCwgKq1UZVufkeGyKZX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5041.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZEw1Tm5IQkMrak9MS0hwbzRlVFA4K0ZMVHF4bmxETU5nSUkwQnZ5TFJQdEdN?=
 =?utf-8?B?NmR4cDk2K0ZnVG9nRk9vZm5YMTVJcmo0eE9zTnZhNUpwZkdZYllObENrS3FM?=
 =?utf-8?B?dzltelp2U2dyNUFhUnJDWjFQWWQzdUtPZFU2OGliMWdCNy9DMC9kUyswTjlF?=
 =?utf-8?B?STNvZzQ1VUcybWdZSXdDclBrU3kzZThlaEFlZUxFTG53UjVGZVp1WitiY1M5?=
 =?utf-8?B?ZlNZRkkzTGpIYTFTTGFBdkMrSnp5VkF2Wk9udXA1YmlPYjh2dEZaaE0wZ3gx?=
 =?utf-8?B?VkluN0FWTzNxS2twRlNvbWpnMnZPOTlQeXdCcDhsMGlPTzBiQk5rWEIzUWU4?=
 =?utf-8?B?RVJqMHVnZHpVOElzcFhLQXBCbGtzRVMrZW5ZTURWVGh1ZkJoM0haOG1KQVNB?=
 =?utf-8?B?N2IxSlBabWNwK0pIZzlPR1BpckdXVkFyS0sxVzAvenVJM0RCaFI1WkU3L0ky?=
 =?utf-8?B?bDl4L25TT2tiY1AxOGVGNElxd0Z4c3Z0VXA4VTdobnpUbnBLdE8rOEsrZDFN?=
 =?utf-8?B?WUxnQlNhRWhoRFFDU05KQTVpREs0QmtQSDBNcWJ6ek1tY2pQUC9YUVBmZDEw?=
 =?utf-8?B?WGZtb1ZQRTliRWU5U0VaeVcwZE0zeVBKTEZnUVJjWnVyMFlkWWk1Y3lQUGxO?=
 =?utf-8?B?N3g5Yzk5UmxmaUFLUjBxMFlsd1hpa1hlWUtra1BwZDk0dFo0V1FJM3pnYkZX?=
 =?utf-8?B?SjZrZDFjYVJmaUhQditqN0dEaEFzV0E5THk1YW1UTmR0cGRTdllRc2d1LzBJ?=
 =?utf-8?B?Y0IrU3FzWFNyOXAwR0RXN1NxUHo0NEhWU1dreXUrbTVBK3JJbmY5cGFxTGE0?=
 =?utf-8?B?VmhzNzJUWDA0bXIzWVFIUlVIS21QSEo3SHNSTmNyM0twbTc1djJraHZZY3ZE?=
 =?utf-8?B?MUp2WmViRWpTdDE5N0FRMTZ6dkdRUnVzRExLZ053K0ErVVp1SXZ0bWlHeVpH?=
 =?utf-8?B?VkVzSmJqVm90VUxDYVZzM3VnZGtwei8vZytjSHhpNlRvOFlRb293MGJDOXFi?=
 =?utf-8?B?ZnBTZWp2bkxOanI5SVZidmx3V0dycTJJbjEzb1A1U2hyYVcxalozOHMwcVRD?=
 =?utf-8?B?cDVJTlp6TEZ2SEpQeXRpRHJ0SkhNbEdiSDkwZHdvRkJvMG53VEY5bEdYVlp5?=
 =?utf-8?B?V1N3WUVqT1E2Y0NUNGw1Q24zNk1ld0QrazlpQm83MWJ6TW1ta2JidndIWC92?=
 =?utf-8?B?NTMzUXdMUllzSTRpYUlRUjVHcDJ2Ni9hV2dpR0NSckdrOTZ2WG5NOUtMQ1U4?=
 =?utf-8?B?TXVPbGw3VTMzTGNXMEJjNFhDc3hNWGFWdjRFa1dSRGY5N25jUG44dkQ3SVgx?=
 =?utf-8?B?QjRhUFFFaXdiMkVVaXdneUNNdTFlc1NzbGhQMjVXRU84cG5rbFNONWU3L3ZO?=
 =?utf-8?B?NDdjOEVKYXBHODNOZWNtczcyN1YybCtrc20yek1lR2MreFVqc25ZbERJR0gx?=
 =?utf-8?B?Z3NMYStHUEVOemMrZjIzR1hUT0VQQTgxbTVUc0JNQm9HV1AvNUJDUW8xRmN4?=
 =?utf-8?B?QWNGaE9vRzUwYTJRRFRuYWQrZ1BlQlJtdmZXU3h3NmZZSXFaZjNoYWp3bmRl?=
 =?utf-8?B?VGZSaE1rNDlMNnRCUEpUWUUyVlZEeWNKZkF1cFdMOEZXOXJaNWJhcituN2Fk?=
 =?utf-8?B?b2RKMVRsNkxGWkM5MldyNXhiVGpmRnJsUGRKK2hXeFRFajhPNEw4VmxML0lm?=
 =?utf-8?B?YXZ5MU1JeW1JUXd1RGMyRy91UGZyREd5SDBaZHUzYWJRVkxkLzlhVmorTnlR?=
 =?utf-8?B?MklMNGNHWUVtV1VIWDBjUm9ZSnIzQXpPSHNEcnNoZ1FhZEUrZ3pXbmkzczU2?=
 =?utf-8?B?UUxIUTRaTW1OcG42N3FscGdMSUcwcVdOa2FhejVIVk9WQ3dUUllhZ3hlSFVV?=
 =?utf-8?B?UUJuS0tGTVpTOU9OY0lya01TOEIvSWFyREhrVnF1YU5MdElaR0xQV1VkMm1J?=
 =?utf-8?B?eE1DR28xQ3NjYXJaUkFzb0NHT3d4MThHWCt3Y1BpRDFHeDdoVHZTbmJERzNW?=
 =?utf-8?B?STZrNG1YdXlQQmg1bkhNS0hza0JLSFVPa1BiTW5uY2xyeWlISWpGT09tNzFl?=
 =?utf-8?B?NjRsTThabE16QkJuQVI0b2R5S3RVelk3REtnZkpyRzZzaG9ZZ2I4Q3hZUzU1?=
 =?utf-8?B?ck9BTldaaGhlMnpvU3lkNUwzZ0k1UWdnMUNOeW9pM1M3c0lHdlQzNmw5ckRD?=
 =?utf-8?B?LzdBdTllWHRKQ2FSTFFOMXpOaHp6Y29IVy80Tno4L3l3bFRDdFc0ODEyMGc0?=
 =?utf-8?B?Z2lvbCtLVENmL3c2TVZRS3FDSHJVb05YTHllTHVmNFU4empEdGcrcUJITGpX?=
 =?utf-8?B?aTgwR0p3T09EYmo2K214ZHhnUEZHUGtvbHdhOE96K1hsU2hBV01rOXl0UW9O?=
 =?utf-8?Q?Ua6oGVJjB4X2xmas=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GWizQ0P8Fl2s7bx18IOaeWo5yAw6EOIO9MRiO8C39gSsOyscg1DjUtE5qWob5BrV+f2zKhUc/5oAO4WgSEpRNptXsX+hIujdxn9iErbFONWlTT4ISsE82O+zrYKsbgKaNLnNqfEtYankhi/Uhd7PVCdhXawTX6rXKIMFA2mebdpdUrE/hhv8Qy1A8Z3ACKfrxEppZ0Sl+m74EszC4s5f+VnomLP7q6/g93+Y0BrTLcB7h73bcLxUaeVRSH7JCdMgnRmeD/yTmTlvYwmpHJU3wsotvB2yYCIRAkyRs7ux7s+te0dwZU+W5ziAwvFI0c4ABqvv9i+teaWwzImQFT7ORHclKrC/TcDCQEvR3otGAdmq2SPp+p6hYzfsyAQ375NAsna9qamHzR9s4XxfBErTx3O23E+Ph6U2D+6eXdSikcrFYPJ0WB/PC01XwW9Ass1C7y2FX0AAZ+wW9s+Nvqs44LvsZQS7Pbm0VD/DFpXTFy1vhLMzjwha/q1zchEiUHsiA0zKoZvB5h99uj03LN5gX3hacxH6jmcRXAnkzVW9P+lZzsQsNw0Lo6y5IzHGzKonXK5JZg2wfQhfOb3YGnvzbb+mrtyonShpE10k5PinHcs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55ecd950-bbbf-4f7b-f1fb-08de4fac341a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5041.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 18:23:36.2645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DeAMsuDZTPxwrJgRyWxcOolK0oG4WkBCjNpAjrxIuQLrnnaQiz3LRTaX+OmZlfA3dfPrXUCKBJPD6YI+TyBO+zB5TWMjQ0Ir0WJSZ5h3EcU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6177
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-09_05,2026-01-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601090141
X-Authority-Analysis: v=2.4 cv=XPE9iAhE c=1 sm=1 tr=0 ts=696147ac cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=HuCAh595bFuPgeVg_QYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: NVGugGJ-h8RStvYnwTw8S7lWcX24rfRi
X-Proofpoint-ORIG-GUID: NVGugGJ-h8RStvYnwTw8S7lWcX24rfRi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA5MDE0MSBTYWx0ZWRfX4bntjCGVr/+8
 uAVCGqLSdiddUca1Ab6yQMMopnheUbSdmxcGqsI1ScRhEk//r8PH24jhssTQoypVYPCJqHzXAh/
 CdWIs/sKKn1mLdFwkgJ4BuKzn8BezfVsHgx51DfMqqygEK6E666M2fw3/6kmABaG+XD9RctS31z
 yi7ZcOj6UCZLrC5LBXPoeMbzoeKBFIope+/85OjneAkHggWCwOTRHKOiT23ZhstsewfMT+k3AxI
 5YJVPxQSMvsqQ91IwP8VaQCzxY1oGtOrs0PZg1k/y06JWWU7arEMP199Q8nPCqIRqi6yeyfCbNt
 kTACTlnInHWAYgrZe4AfmuDm3QhgQrW2vmaamSrm0uP1UdzKGsVbu5rGB+HcclroJcJj4yoSrAu
 K/FT6RESfej6KXnT1xyuqMZ8YsyUB0+/WIvy5LswwHXFI9L7LItbTKpFWp+X/tdXYcqAT0F7Mxs
 uxgxKastUUOiyxwgRnQ==



On 1/8/26 9:49 AM, Jason Gunthorpe wrote:
> On Thu, Jan 08, 2026 at 09:37:17AM -0500, Alejandro Jimenez wrote:
>>> diff --git a/drivers/iommu/generic_pt/.kunitconfig b/drivers/iommu/generic_pt/.kunitconfig
>>> index 52ac9e661ffd2b..a78b295f264d23 100644
>>> --- a/drivers/iommu/generic_pt/.kunitconfig
>>> +++ b/drivers/iommu/generic_pt/.kunitconfig
>>> @@ -1,4 +1,5 @@
>>>   CONFIG_KUNIT=y
>>> +CONFIG_COMPILE_TEST=y
>>
>> I was wondering if there are any side effects from enabling COMPILE_TEST. I
>> see that Geert had the same question on:
> 
> On it's own COMPILE_TEST isn't supposed to make any functional
> changes, just enable more drivers.
> 
Yes, I thought it might make the "building" stage of running the kunit
slower, but that is negligible.

> IMHO the .kunitconfig fragments are really only for direct use by the
> kunit.py, if some distro wanted to enable kunits on top of a
> production kernel they should not just blindly import the
> .kunitconfigs into the .config..
> 
>> and that you agreed with his proposed approach to do:
>>
>>  menuconfig GENERIC_PT
>> -       bool "Generic Radix Page Table" if COMPILE_TEST
>> +       bool "Generic Radix Page Table" if COMPILE_TEST || KUNIT
>>
>> (which also works as long as CONFIG_IOMMUFD_TEST=y is removed).
>> Is there a problem with making GENERIC_PT visible on KUNIT=y?
> 
> Ah, I may have forgot about this, I don't have a strong opinion either
> way.
> 
As far as I have tested, either approach works.

Reviewed-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>

> Jason

