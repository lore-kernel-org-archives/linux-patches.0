Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2073.outbound.protection.outlook.com [40.107.223.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA531531F9;
	Tue,  9 Sep 2025 03:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757388319; cv=fail; b=urP7/5RR8+8y7tvoO4Ldk740ijZ53p5OHplfuLyMDAz3JLb5Hc1W42bpc6ucudXpnUDTQQNDqZxvsKI4gps1aCqi7aMF3gNXoNHCeZS/dr027F7VUeAtVuK95Ktzz2cKqsmlGzpE5o7r7SA1NBTzKki1GEHjeUa/xSyevGMQW20=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757388319; c=relaxed/simple;
	bh=pl4TCeiuUMupKdChhKGUSO+bG++K805a9UOY8M2UbWU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Bn65JsVI44NBlM6dM4HO7Q5m+E9w0CaQ4yFrnsh9maYbZk6YFcPu8c4PPYXUKHzebgbjrNI0IPu/ZXDQeZ1+A98UjEJaVtQ3+d6kG6WzXdTWctILFeiid5mFY9LAa8LnX26vPX+cadZx8LY/YDyQwOpI7OPomOEEJ8qzNUTawIQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ciVFL3YB; arc=fail smtp.client-ip=40.107.223.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ciVFL3YB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FAyISZMSOT2LASbltyQu8RA4km71cUjHFga0WWZ0sBaOfYMHBzpZACGyVVMDL1rncYcamEuOKT5IBrGdTqkc+q2RZQHXyGhLH2IDDfiWRh4SrGrumqJqqWlWllwAfhHrbO5fvJFmP7DTr/r8SOjocIqouOeVmf3ShdLy5oPt0uXeqyxbY7ITMT0cqYwtQsmDMInOHlYBgf6mlLOVUSiPCqMCg2CRpZQvaGGf+nODkbCUupaJHkxaBp37COQMdGnaD44cy9Xx8SulosNnm5CZgofuhxh6ToQS8LHyXzAsRGNVnaUlyALRWP5n8vss+2XTZGXykmG11o5xpLP2MbE1Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U+8iZAbbQU1CjOmGV/5+LBFBCqt5rGFJK44TMa8xz+A=;
 b=pBTKNUSKJ8QPE5x6zPVs0t1C4NR6sejLV1FsnZDkFmuR2bOH5+UVgeJPhNZEfcDZt2VnT648Ndvb6dCaoPTmsxrAVa3vslKXuNOc7gPJJAcO0g1Ncjzd2CCuc1CymPZ1710HvLHQbAuvA1kdP+FEkD5GQcPmuu9NocM3TBj/PuKrflG6cxrolNM6tvqxcwhyJTfCTextTPHsLbRlTBfoKh5DkabOT4xEflryGqpUErU8Nqyy4WyUQqQXzvZT/UYPSwy6nvVL96D8J5Yjr2TO2CJ6CVJh20rLza7YCBFiEXBY+UBqVKfrB5PaZDIujr+bFWwu86avUciFBHNNtJ1Rsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+8iZAbbQU1CjOmGV/5+LBFBCqt5rGFJK44TMa8xz+A=;
 b=ciVFL3YBIL1CZsb2tK7BZILaNOoSjgRjvIly9/sjLhC8vdMXj3nh/Z4HGW/eE0qBJEPc+Fb//TnNpEdPhOIRzWXlNMMareLrFfU8LhMNPbKnIvSHnczjDV5F7PuXVVLNLX2uaKfBMSpsmE1NfiIRLoe5p9Q4Nz289LaT52tw4z5oU6m5hPjKPN52cs5/Usdb5hVL66xIuRHBb4MhHyG3WQSNbVOo/Esw3d6ewk79Dbr88wXgAjm4QTaJuz7UrbwCphRNmpBk8hznYS8rfuQpfBaEIXmaKQSvVR9NAQw9aB/ghIoTbAPohzm5rTSITDkKA78As21o7kwl4dl0dGtD4Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by MW3PR12MB4362.namprd12.prod.outlook.com (2603:10b6:303:5d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.21; Tue, 9 Sep
 2025 03:25:12 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 03:25:12 +0000
Message-ID: <5c1874e5-e096-40b1-b104-6906aa66ebc7@nvidia.com>
Date: Tue, 9 Sep 2025 13:25:07 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rfcv2 2/8] iommu/arm-smmu-v3: Explicitly set
 smmu_domain->stage for SVA
To: Nicolin Chen <nicolinc@nvidia.com>, jgg@nvidia.com, will@kernel.org,
 robin.murphy@arm.com
Cc: joro@8bytes.org, jean-philippe@linaro.org, miko.lenczewski@arm.com,
 peterz@infradead.org, smostafa@google.com, kevin.tian@intel.com,
 praan@google.com, linux-arm-kernel@lists.infradead.org,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1757373449.git.nicolinc@nvidia.com>
 <390fe709e756a54168fcd43e1323998456f2d8d5.1757373449.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <390fe709e756a54168fcd43e1323998456f2d8d5.1757373449.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0P220CA0008.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::17) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|MW3PR12MB4362:EE_
X-MS-Office365-Filtering-Correlation-Id: d7df7121-8bcd-483f-9394-08ddef507c6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UmJLams0UUpyeGMxbVRzdC9EUmIvVDdZRmM4Uks5d1BvQkhGbWswL3QwT1RV?=
 =?utf-8?B?d1VYb1o5YlZOTk52Ny8rTForellFdGVTUmUrbWlQSUM3Qk5DOFdMOEs5VE1L?=
 =?utf-8?B?dkRLOXdQTnhEaEd3VlZrbm9wV1ZONlNsS2o0ZmdZSVRrK1JVY0hMbDJldUND?=
 =?utf-8?B?RVZlOThDWUJiMEl5OXQ2SEo0TlF3MHo1WitQUEF2bkRrbmV6a1NUWFFCNTN4?=
 =?utf-8?B?MVB0NTNrZi8wczB3VUE5VldlUS9ZL2tvYU85SjN6MDNKbklFUlVpUFJ4QzJB?=
 =?utf-8?B?eFA3eTJBUk9HTkFiL3pGYVFwc0hJY2dkQ2dJcGJ1cFN4Mnc5SkNZNkJaN0hh?=
 =?utf-8?B?bCtWN3RBaXh0SDdrb1o2c29oRVRxaCtPZ2ZNSWd1RlJ2eTFPVE9BZFFPcmo5?=
 =?utf-8?B?cm9xQmowUmJTVUFTTEhZcVlRUklEWVpaUXFlaXltc3djamNZMUprLzcvTmdX?=
 =?utf-8?B?Tm1yOEZ1dXVvZVdUSlJ5UHhJeGE4NTNqTVk2NXYxazFuY1NtUXY4SFdpKzFX?=
 =?utf-8?B?WGlQK1dRM1k1cURwNzlIdHR5ZGoxYnFtc0pKNTNxZTh2QW02WEI3VGRMVnpC?=
 =?utf-8?B?TTZqSk9pdWFlKzRVUlhWcGFmUjZqRjkvWHZhVjVBREQvektqaGRFL1ZuSmRv?=
 =?utf-8?B?TzZiTGZzZm0xa2QzVTcyVkdLeTd5dEpWb1lPcVU2QmpXais3S3A5cUE3NGxH?=
 =?utf-8?B?SGhJMjBEYVBKYzlpREM5U0JGWGh4MHg4RFNLNk9reFdWV0lpR0ttbTBDSE9B?=
 =?utf-8?B?VFNzMkxnUkRVWmRyWmYxVWREVlVRMHR4Y1J1YVNERDNRRGdUQitEZEliajdw?=
 =?utf-8?B?WDFUSjdJa0lVK3RTN1RST29ObUwyTDVubzhNMnN0QTZDZ2ozSU1RZ3hubFFL?=
 =?utf-8?B?Y05RbHRLN0M4Zmhtb1h6d1B1RFBxOFlnOGI4UjJScStTWjFxUTh5NUxBNVps?=
 =?utf-8?B?VWxXb25kang5YXg0Y3FhYm9lWkFuSGZMTmZYa2xKR0VNelRJamdnTE5wbFFj?=
 =?utf-8?B?NytoNXppV2hXUlBodjVuUDhGa1c1ZE1BYWkrTlZCOUExUHltaEVKQWNsMlRV?=
 =?utf-8?B?RzJxSU5ZWDhjMDYxOGZHbVJHVXBoamR6RnBES05TaTgxNnlHU1RZNjUxT003?=
 =?utf-8?B?UW1iaFgrNm4xQlNHbGlSeDJyUGdRTUtOSzZUTnhNdW56d3N3bkhjOU81Z0E4?=
 =?utf-8?B?ZlVzRWdBV2FFS3U3QjZ6alVyYUpDOWFjK3VETDluNWg2WWtSRXRWMzJUUXVl?=
 =?utf-8?B?dzVENEtYTEoweUtjRE5zREpPODBtdzk1cHEwekFUME1Xc1JuOHNseVRPckJI?=
 =?utf-8?B?c2ZlWWlVbnpUWSszNGZ4QVhHTXk0b2tHWkI4dlNFdlRITEsvWFBxSDBVSTU5?=
 =?utf-8?B?R2EvVXF3ajkvajJtbVNod2VzZFMwazkvTFkrREpxTUQ3dU5DcTdVNGYwZnM3?=
 =?utf-8?B?WnZNaTVneit5SEVCMm9xcmt2Sy93MkVpWU1TcXdTMlFnK1J6NXcvY0JPekw5?=
 =?utf-8?B?OTlwZDRzYzBCMmNqdElydkRDZzNRNmx0YVJqZWRNaXlWbHc4MU4za0sySGl2?=
 =?utf-8?B?dzlnNmZ3NlBXUTl1d29TeURhOHlsd3J6OVVEMVlVUjQyeTdpbWVQRm92aG1J?=
 =?utf-8?B?OWZWcXkrSzRtRmJ2d3ZITUJ6VGR1bDYrZU1iODlZWnZSMnViS040R2Z1elpW?=
 =?utf-8?B?NGdZNjJqdlpJTi9zODBOT3h6Nm1UTGJuZDNOZlB6M1NhcDRPQjRCd1ZmSUxy?=
 =?utf-8?B?UERpS1A0UTUydlBNWUo3MkpTbDZvZFhLVXh4UVVMKzRnNjBwVWY0c2thclJJ?=
 =?utf-8?B?R3R5aGYvWi9Yc3BrYVliTzk4N0dXb3M5NjhqVGJRMlZidWw2QXZtUnUxWlli?=
 =?utf-8?B?UnIyVFdMQ1hJaUJxUk9PNy9LZ2xReHh1akc3OFl1eW9BdEFtSHlBV0ZoSmdT?=
 =?utf-8?Q?8kq6muT2z4U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MS9IZEFWMGxuTXhQZXNaMXBxcU10bDg0MjZobG1FM0dVSVlKaFYrVEUrcUJv?=
 =?utf-8?B?TmRwUTlITEdiVlFpYzlCS0F3VFJRWGhVTGUxd2FUdXlqK1A3NmpSRVQ2ODVQ?=
 =?utf-8?B?TWNnaVFHQ1ErcmlDaGlDc2E5NG9VN3k1RzBtL3lyaHl4WkgvWngrN0t0Zi9r?=
 =?utf-8?B?UzU5NDJOMHJ5R0lxWGZRak4xdE1EU1NnVmpJamVwL21XMVhNYWRIOTkxR1l5?=
 =?utf-8?B?SFFudFZhMWEwWnpBVkpZS1k5WDlWR2lsL2puTDlJdlE4cFBlMjduMXU5WUVV?=
 =?utf-8?B?NVZiN2xueDhBWVVwc1FGc00yaytuOVZMVG1aYmhWSGZWVHJ3T2hucm4yZkZF?=
 =?utf-8?B?ZXMzZDhGb1cyd2E3UTV6U05tWG95clduUnl4cTdPeGZJZWpJSE1GMDlGdjVi?=
 =?utf-8?B?S2FJaCtQeWpDMHNFaXhqaUZ6dURvbmxyTEZQbkVCOE1lWmJqU0RiRElHY3J1?=
 =?utf-8?B?NXRuM3hJaStieVBJanA3bnNIbjhCK1c3cWVCT2pIUmRVdHFTYmRrdm5XYUZR?=
 =?utf-8?B?Tm5PRWNtYmU4VC93Mk1Gck5IdlFBRGZMMW0vTW5VSFlNNjZObGFZTmQ4Ym9Y?=
 =?utf-8?B?bHZJMDEzNVZkMVhxTjZ5SFJXclNGcnJORG9BcXoyYVJQSEtQdFpNeGJ3SFBI?=
 =?utf-8?B?L0N0cUZoR2FwUWRya3F3R3V4TTNaZEFBVG93ZXJRL3FvUVR0YkYvci9RY3dZ?=
 =?utf-8?B?Z29sUFJDTmwyMkNrdDN6anVxdkZYU0lRY0NNMzZ3Tkt1K0sxKzk3YVNzMTF3?=
 =?utf-8?B?RWRVaWxQRUx5Wm55cGZyV2V0Yis4N3R6UEw4QWorM0pRS2hXbjhKc1VZS2tJ?=
 =?utf-8?B?bndDL01EaHJ6YWpFczNzalNaTXorQmhjN1JJVENSMVdEdGpMYSs0OFNtTTV4?=
 =?utf-8?B?QTdUWE9LazVibWFLQ2FBa1ZsVjh0UWJNeDczdDlMRlptaWQwWElxK0EyM0Y1?=
 =?utf-8?B?Sm9MRHBqTWQ1N2ZXazZzcENVeGlSUUt6L2pJRG1NTkpMbzR3SlJsNDhLaitW?=
 =?utf-8?B?dmI3Y2lWZVc3QU16L3ViZ2dlQitCaDJXLzhTbGFwMHVLVWRORzVpaXJSSE9M?=
 =?utf-8?B?Zjk3cmRMQzZ0ZmZaYWdFc2Zla3RrWEZSSHNoNE9yNnFEU2svdkowejJucXdo?=
 =?utf-8?B?YmtscWI0czEvd0JCN1pwbVhMOWJubElueTdmTEZwY3VjUGlUL093VW9LUGZ3?=
 =?utf-8?B?bVRaOTBPNHFCcFRNVmE4S0I1bHhlK2NyVHJIMTFXaURMVG05TzhHSUdOK213?=
 =?utf-8?B?bU9EMEMyVFdpaVRJa2xWVjB4eVNna3pjckhBYXlxUnh4eXk1ZUk3TWtRQkhB?=
 =?utf-8?B?dURWSytteVgrRUxaeFM2MlJGVU0vcDlxc3ZSUnM1UmUyc09kclRFSHRGN2lo?=
 =?utf-8?B?YmJkclZWYlZmL1BIWkRYT2hSeEhBbFcwQ2k1Tko4cFRMTWdxVkU2R3hkWmRQ?=
 =?utf-8?B?VnN2UFdDK2FRaVQyR2RFTzlvSWRzWkZOV2RtNk9MY25IU2toRFgyNStJODZC?=
 =?utf-8?B?L0xBUnk0Uld1ejRJbUw0TWtxTmJtdEpZRjNlY0lYUzg5UUxlaWF3YUdUa0Nu?=
 =?utf-8?B?c21ObkFUWEZ3WjBzUDN0dlVXZ2RsRkNoU283blFUMzdnTU5KcXAzbDBtbnFS?=
 =?utf-8?B?bWcwQWxWdWlTRzJPNk1ZL1UzVzl1OWEzc3lhdjlkRFJnVDBqY25GK3lGcjAz?=
 =?utf-8?B?MGhEVm9sUi96emJ3a1pndFdWRVYyNGsvY3NpaUxLRzBhVXlkUkttRzNOUkdM?=
 =?utf-8?B?UUVOY1NYdmNzVUQ3bDkyTGhqTUc2c0NScUl1OHErbkptcG0rb0RyZStveVdr?=
 =?utf-8?B?eXJySTJRNDZkZm8wTWtvWGd6WW16UkN5R016bWFJQkcwTXhqb3VlNGQ0TEkr?=
 =?utf-8?B?QnFvQm5rc01PNkN1ekxTRGFqY01XaWpIazZpaFIwSksvMzBtU2ZSQkhnaW5F?=
 =?utf-8?B?MkVTR3krNTZZZXpnVkhZVEgvTjUzakVWQWNnbGN4TDMvNXJNQ3Q1dHdRb1Ez?=
 =?utf-8?B?YzBXK1BKWHpWc0gvbnhFbUlzenpoNnFHdzhPT090NWxkQnRGV1dpQ0dGN3R0?=
 =?utf-8?B?RXR1UXpseDNpdWk3bDk2blZQbWQrN2RZZDFoMFFOVjlNSzBIeStTQU1ScEtD?=
 =?utf-8?Q?zE2IOo63khP5U2Y6li0AREg01?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7df7121-8bcd-483f-9394-08ddef507c6d
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 03:25:12.2263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9KKu8kwmz0T3ZdcsWHF+8XgXzQw7pqUjMc+qusSi3O8qo4xpKUdejuRcv70ymb+mewflmbk8FIyXfcxabU+RBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4362

On 9/9/25 09:26, Nicolin Chen wrote:
> Both the ARM_SMMU_DOMAIN_S1 case and the SVA case use ASID, requiring ASID
> based invalidation commands to flush the TLB.
> 
> Define an ARM_SMMU_DOMAIN_SVA to make the SVA case clear to share the same
> path with the ARM_SMMU_DOMAIN_S1 case, which will be a part of the routine
> to build a new per-domain invalidation array.
> 
> There is no function change.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>

Acked-by: Balbir Singh <balbirs@nvidia.com>
