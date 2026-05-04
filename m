Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012014.outbound.protection.outlook.com [52.101.53.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73674168BD;
	Mon,  4 May 2026 04:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777869427; cv=fail; b=bN9euE3LySSEsAQ7c4dVi515pxRZ5EOHws4N+9Gjqp/cxNOLr/SLKMld7zvaI8XE0esB7dY+u5DnG8lEbFZVyS0bG431VeB4faZmzNXqUL1dFP/KVY4xiwMfDFJsC7650CP+mFFBSj8+NNPd8EeQoKx/ZbFgRpSMgCvj0qXOYoY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777869427; c=relaxed/simple;
	bh=n71YEIfr7Sx+1jVQz0bjyZvG7fFUNwVKsspllFRTOtM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XZzBYG0FPeZLcmi4WDIRlvJM0PGhoow63t4abvfdePwPqr24lv82ZxNpRijSLWCnseepJGQnHZ7dk0dFFqcIJFPHlWyh9Ui2YztLoTvyrT7uD0tp8OVC8WB1coApzQEOAn1eKvw1QSh2htFxtbvCeOF2fZLOOSIWoNhU/BBKl3I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vurWnwt8; arc=fail smtp.client-ip=52.101.53.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vurWnwt8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q4rAoQ2Am4vh1yRey1rpbVLSN0PbZwOL38P5jrFR7h1HMViHCqwvyUM/WspUSUx3nQyTfa3mSXfVyiUco48aG2LDWohJRBeq816RQsnHWZvXy4Sebk3/oC8WFKf8l9w/GyKmtF3Gk074QQV5/c414UZVyvH+zZpsUuSmowT+5GqcgK4BieaxHooXzDa0Mz/qeFWKR+AnflLuro89kskKa84tSRu2b+7OkHnpemPROhm2/MlX+VqDbsevRU5Rkv89iEGmodhydLIdjsMtnAN7E2BUt3Rm+2Ko2g/krCtMmnLYAbky4jGcKsj21iURUggssf8Cl90CEopx8XxjmjmD9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ROPy80AktZU+RRUwR49aJuOs7dQOHkJ/WtfVmvoyVhY=;
 b=Yvz0CfYPgSqXLZ8MsXpwD4dfaXbgAqpQBFHGWBfmRiAqtKPfC08l1LAR8Dsjb/0VihAaZTjeJN46EQCNjV5O9nxLBB0/+m2f1ZqI8YAm13oc3jVJvO+XZ/Bgx4GHG4INes5hL6RvkZkEn4jTEKc2JQsV/t5A0e71XICjcb+DborMla7z4J4cDz4TWZZIpeCy6B05HpMin/4UpSob0MEeVrqS2ZZooj+q0D6XXDwrqqZ1IJPHxRrb6pr8TQpTxRM/hu5DK9pKn8W4DOxUYqbLSSn+KnntYGlOwJFHaxP3rWf95j3Ga4iaGbAoVIJiNv9xs1F3/o2g0y3hN5nxdhcnEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ROPy80AktZU+RRUwR49aJuOs7dQOHkJ/WtfVmvoyVhY=;
 b=vurWnwt8h7GM26Z1gWF+gH1U6UFKYcTxyiGSov8kMVpjis7m3J2mFLgBRZGMx4F6BXPOaNtyR75N7EH5CC/Hmo7Hbj68MUivqftdh4qm4eIdZ2q2w4nMAccFvZWxOJSQ5em9Aqq3Ymmdau/9wTMJcezl3hMtbbrAmZ/GHz/n+X4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5754.namprd12.prod.outlook.com (2603:10b6:208:391::20)
 by BN7PPF08EEA05B5.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6c5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 4 May
 2026 04:37:03 +0000
Received: from BL1PR12MB5754.namprd12.prod.outlook.com
 ([fe80::b080:4c1a:f6e5:4564]) by BL1PR12MB5754.namprd12.prod.outlook.com
 ([fe80::b080:4c1a:f6e5:4564%5]) with mapi id 15.20.9870.023; Mon, 4 May 2026
 04:37:03 +0000
Message-ID: <61f5186a-39be-464f-961f-8f783c848182@amd.com>
Date: Mon, 4 May 2026 10:06:55 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iommu/amd: Fix precedence order in set_dte_passthrough()
To: Weinan Liu <wnliu@google.com>, iommu@lists.linux.dev, jgg@nvidia.com,
 joro@8bytes.org, suravee.suthikulpanit@amd.com
Cc: will@kernel.org, patches@lists.linux.dev, robin.murphy@arm.com,
 santosh.shukla@amd.com, chrisl@kernel.org
References: <20260430225414.205094-1-wnliu@google.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <20260430225414.205094-1-wnliu@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0270.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1f2::8) To DS7PR12MB5766.namprd12.prod.outlook.com
 (2603:10b6:8:75::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5754:EE_|BN7PPF08EEA05B5:EE_
X-MS-Office365-Filtering-Correlation-Id: 7adeeab0-7a16-4fdf-fa9d-08dea996c9b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	P9fuVMDZq3+xA6dFrbZaCJRJbo2J1/fHiVi8683hE8xyua3agEe7FM8Obb0kUxub6n4agD6qENSQKBZswqNo6x24dMPxoIGDkdmEjfEMOF7c9TrG5tW5xV2w/Yu6eg6qdU3df5IVJQpWru6SoFCypvhceUxkagj+pcbNkvmMRZ/ps7MOa57XRIpU/4iCJm3HQZSzYiwc30Hp563CP6dQd1Vryg7tg09MLVqZjoHQcEkrod/75aiGM9iBJJzoCjFsQc8lp9l7INeMe9bG9a2lRMxxo1LIgAOLV795Dq/DewkO+aUrZQuTkNqU6zcux3zYtRam6hbTKqLuHVF7uOETTyQemDLO91XxUZS3h0/VDc+S8EHFSBivCINAmhlEzdPHC4M32HurcWozFROzC92gZLaF9VTbqmyWYmmidIzLqGQuu2zRL0i75uP+inx38hd0VolkYY4ZNkUdEQ/PHiLTLiAc23PkPFdrczYNjK/FQxH+0EzsJZppExyMJH4WqqYQo/vGhs53FVQJJ4WmLvAFJM5yNy1GCIsyPjYeNeX+2+Xc8sRRK4UmU27KpH2vKKDVSNWyWeBQs7JzFnBYTUKKkFsO4FfJw8N7qLNSaFMQVhRfriw+6RJbKlXeHEFIpGmOAwj3uijSRJmBgg+1ocROK/Tfi1mGCq5hPWFivOlh08LdKID9AfgCyBcCbKWk7T0F
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5754.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T0NPWUc3YklEWXZkRVZyYXR5OEpXRXhiY1RUbmlFajdOZk81NzJkSWRkNlph?=
 =?utf-8?B?VldqbXpPYWptTWQvc01hcTRyNWc2azNKSHNZQzFJLzQzbTRjZjNuRVJvd3dr?=
 =?utf-8?B?SkRPZnJrREw5a1IxcHI3a1dvRjlDaC9IZDNkbWtOUjQxZ05nVnBlQVB3aU94?=
 =?utf-8?B?dDFGcjdnZGY2TGdYb0w0NEk0QjdnNUJxbFBJTmZQSHA0eWhqYU9jUFB5dU12?=
 =?utf-8?B?RDhFMVVMeEg1Ry9ialNKMElldE4rTlBCVDlyT1ZTcjNOUWVmYXNleHNNSVJ2?=
 =?utf-8?B?cXlnbDBzays3V25wQzVPaHVhb1NJOHh1YlZGb0VPclIwdnJQMGVPMDFSUnl0?=
 =?utf-8?B?ZVQrVmxtME1vVzZ6OE5lTGk1UGYyUGJVaS9EYTJDNVpSNklQOE1GT01UMlo5?=
 =?utf-8?B?aE1NMW9oU05NV1ZGOGEycGVsTlJNd1NLRkM5dHlMY3IyUlBKdi9wUEFHWFVW?=
 =?utf-8?B?STg1UFVEMVduQ3JpL2RoZXVxODk2aHN0TGw4ZWFVRDJsbjJWMkgvMjQwZmtk?=
 =?utf-8?B?c1MwN1F4MkpyajIzNklUVk9SUjRNdWRuRTVxSU01OW5rbTdxV0swQTVGZjBY?=
 =?utf-8?B?bXJLSC8zcmcwbXMxSnFnSkt5NFlQc3F5RHhGc3FReG9teERPRW4xQ2FDS0Yz?=
 =?utf-8?B?b1lBajR0TEVRMTE3MkdkaFNQOGxQdzJ5MWhydXBMUy93QjB4WkxQWE4rcll3?=
 =?utf-8?B?QnZYREQvTVVpeVgyRjR2MDVVMjJZb0JGMXh6Z29vdHdTakdKNWNmY0RPa3V1?=
 =?utf-8?B?SytUaFBtYjhZM0FHZ3hyQnVTd1psR0dpQ0MxRlh4OEVHeWpYTVdHWm9RdFpD?=
 =?utf-8?B?am9heDNTeUZ0dG9zUGx2cHRMVXIvaVZVZ0x5ZDJ3eElYdURHNEVRN2htbVgv?=
 =?utf-8?B?UTNsQkN1WGtVUHF1SUpYQ2xaaHFYZW1hUGNMZkFNOFpKcGpsMSt6UjFhSlg2?=
 =?utf-8?B?VEw0ODl4cE9YcVVXcGxXazY2c2JlOHRTSkc4bVkwQlZXemhEbktUMm9lREFj?=
 =?utf-8?B?N3NpQUJJT0RBeEJYR2g1WDNNeFBQa1k4T1RHVy9OZGxVb0lidWhyaGk0L3JX?=
 =?utf-8?B?Nm9rekdPbUNpd3dHTlZrV2lSUzB4cE5GaldocEpyMlMwbm1xUzBTbUg3dmdR?=
 =?utf-8?B?bHpFbzV0NVpkVFdlODBBc1M4WWFkdmFwekhIUFBvNWpsVHoxaHF2SnM1eHVQ?=
 =?utf-8?B?NEtZcENHb2xKQnBQQTc3RWliNFlBdXMvR0VPZnVRUDl1K2hNS1NIVStkb3Bm?=
 =?utf-8?B?S2ErV0I0djFGWFo3bjZGNUV5ZHd5Tk1Tc3RUZXFnQVc1bEJGSmFPVklJY3lm?=
 =?utf-8?B?WThidCswVUhiYjRxVVhOTHpNK1dmWTFnT0V2YWtnSWxkcHpuUzlBN0N2K0lX?=
 =?utf-8?B?RVBYeHcyRFJFZVdKR0FhY2R0eVBWamVwUGp1UzRpemNqazJNaFNQVG1vY2hW?=
 =?utf-8?B?SXgrbjljTnRtcjBiL0tOM2xQeng1RVZBZ2tHWEN5aXBWSWtydDdxL1pHWFJ0?=
 =?utf-8?B?L0FRcityeDFPaDJOOWZoK2NsV0tYcWk3YlpmVXJqM0RZT1hEYkxNT3N1OERI?=
 =?utf-8?B?Y0VXRENUSVNDRnlWS21XVVdUbnlqUnNtZ0k2TE13WFFSUS9JNEw4UEhoSVdj?=
 =?utf-8?B?ejZaMGNjcHIwZHFkSTRiTHlsQVpEUlNYU3NDNG5hMmFPNVI4Vmx0bVpjdzlq?=
 =?utf-8?B?c3dmL0s3Q2VuMzI3SWxhUU02Rzh2UXF4NURUczJjYTFYZTlUUXE2ODRtY0FL?=
 =?utf-8?B?OEpyTDhFUUZDUk0xQVVnaldnaUZEbGI1NE9RVktqSFBvTnFSR2dlSituQkY2?=
 =?utf-8?B?c1cwN1dNbkJWUnRPWFFXcS93RzdkYjB5R0Q2Q2E2WHo4WWdrRHBPd2ZxYVVY?=
 =?utf-8?B?L0J0YWsvQS9qb09OK3M5MkZPWXUweGdLN0JuSEJJY0JHRTRESlJaUVYzMVEv?=
 =?utf-8?B?NWRZbnVhbnN4dndBQmViUXpwR2o3Z2R2ZDI5RHZhemNsNytiQStqS054T2Jj?=
 =?utf-8?B?NU5NdE9LWkoxTWN1Zlg5cEZ0bHg4eEVHdUZSd0FKdUtGK1hVT1YwWnRZSDBz?=
 =?utf-8?B?dkxKbjFqa0JBK28vSVB3SDQ1YkZkNGZ6TlBMbm56bkR6K0ExSTRuUjBGblVL?=
 =?utf-8?B?MGFBY0c0VzIxcC96KzRycllEMjdCdHRWczdLd2ZJOGhrWXhCVUE0Q016ZkN3?=
 =?utf-8?B?RmZKQVNKeTRucmxYM09URXV4SkVvQWZFSzAvR3NaY1dKejUvUDYvZlYwdjhV?=
 =?utf-8?B?S1RDTFlsd3pSdEZWMUxyYkZ5eThJS2JFTnNNbEt5Z3dPaWIvbk1wUmtJME5m?=
 =?utf-8?B?eDVlOHpha3hhMks0aDhYdDA1bXRGZFlxcEQycEdGUXlHRU5VQXJFQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7adeeab0-7a16-4fdf-fa9d-08dea996c9b7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB5766.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2026 04:37:03.6751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HnyRYzi7zRkhLOGTdrwr3TjZD++GoidFZWTdXtuM1BHXlvTdEyaEr5beKlsD2BKo0R7tN9hgXz9sp5oy+02aIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF08EEA05B5



On 5/1/2026 4:24 AM, Weinan Liu wrote:
> Bitwise OR | operator has a higher precedence than the ternary ?:
> operatior. It will be incorrectly evaluated as:
> 
> new->data[1] |= (FIELD_PREP(...) | dev_data->ats_enabled) ? DTE_FLAG_IOTLB : 0;
> 
> Wrap the conditional operation in parentheses to enforce the
> correct evaluation order.
> 
> Fixes: 93eee2a49c1b ("iommu/amd: Refactor logic to program the host page table in DTE")
> Signed-off-by: Weinan Liu <wnliu@google.com>

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant

