Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162D326A091;
	Wed, 28 May 2025 08:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748422096; cv=fail; b=nf8HWda7JTloP0xSYrwm1x2fB8gr885/YqKe4RLBMyTJLi8aCSHi5Bjn+4DFRV/2vZC8ZNpBcokhv/2IQs15RoyIPzwYMCcPusqRcSZy3DPRzr/9zt14mKKMgp8YYOFZvM4MLj64Asx9rvk+cBUCVGOHto2NfJOufBhkmihC8bg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748422096; c=relaxed/simple;
	bh=Zn79XNMt0LyhWSsMJUZBPv6kyHLkG1heZ57VYJB3tV8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pu9YXgZHjhEcbgpu0Ny3E3TSPNkaLYkP+tjut6S4Uqps+apb8TTE6HsPOjBUtql2XUI4VJCC2AQ8Pf5N13Jkeef2umoLyN6wIFgIlhT0Zm0Hcqo4ox1f9PjCJQQp3IzQnDvIAz6/3CvGME9fDcnigFDn5RmNewlvguFo0+hQGUU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uq2uTEF9; arc=fail smtp.client-ip=40.107.244.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uq2uTEF9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EfGDgPhU89duaKn6p8B4drRD+y0XQ28FTZCOYKYD62jwgefRKl+SQ6HwJCSMAX7QJC5HH6ptg0WosvWOAImw3J5xVAQI00MvMU91PnKO+88YZewG8366IpF3/MMMhmOOMSFLJGWcXtd9GTjWyu1XOAIsAJXSQfeIn0ftUNyjNNCjso5GLYmJnZlx8RN6liLLjNVOmRhp23NsJlzV0M5juTdICWmj0u2e9lyhwNVLuauLxMOj8ijZRZlgAd/pi801Tns8wGVOe7bcUjXfiPwcJH+pyMn+8zOyAokkvqdwDJ6uknZAbNYBA/9mUmO7sZB76GZMB5rHrcmJW/87P8v7dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1RoWipx2W4pN518CHVjrdLg/ppDkA8m3RYN039u4Rp8=;
 b=GY05fjmn342UoOtaoinM1doPeJPLsglnYmBkmsbMsZQIQJwUoNpOmkptX4Z0t/v3IG2NL+9aVi4wnq9hhUjCy8WtSCEgvzzeyZv7Pv407FP03aTilRzkDO17YaeQ3Hav0TXftLo065a4Bj0Ms2FZ2C90L+xXLOK/NbefnJHQrJjYLbXCoD920zSupYg3zAdqWHc77vc4Ih+DtGXoUNR68/amhJ/TZMZkSqSAv24LrLhvIFYiXpL6D3t/USJsTB9fuPsJZuw4kBLo40qv7Z8+x2cscpCYUtSrDF9pQ/CUtluOT4uXr1vYauPx/ZDjWA2QE/124Q1XYrDQS6xyLEfwRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1RoWipx2W4pN518CHVjrdLg/ppDkA8m3RYN039u4Rp8=;
 b=uq2uTEF9zK28nFHn1lSkcueyxrDtmqCwdNz7kGtXGFCRwAlsvdRIo6ba1t4jnWFGK1/P/iuGyZKw7lHqVy9tEy1kyUvk7S4KhW8xUgz9/BERKV4Glk4Dd1pomMmRRy86QdzgNrJaJUlybgi/S6S9ttx5amHKnulzrvOLh0OrPq8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 SJ1PR12MB6074.namprd12.prod.outlook.com (2603:10b6:a03:45f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.26; Wed, 28 May
 2025 08:48:11 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%4]) with mapi id 15.20.8769.022; Wed, 28 May 2025
 08:48:11 +0000
Message-ID: <8858d4d6-d360-4ef0-935c-bfd13ea54f42@amd.com>
Date: Wed, 28 May 2025 14:17:56 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rc] iommu/amd: Fix geometry.aperture_end for V2 tables
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
 Joerg Roedel <jroedel@suse.de>, Jerry Snitselaar <jsnitsel@redhat.com>,
 patches@lists.linux.dev,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
References: <0-v1-6925ece6b623+296-amdv2_geo_jgg@nvidia.com>
 <d5a653df-9b43-4f13-8b1b-c3268c356592@amd.com>
 <20250424140613.GR1648741@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <20250424140613.GR1648741@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0046.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:279::7) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|SJ1PR12MB6074:EE_
X-MS-Office365-Filtering-Correlation-Id: d3e55a94-cfa3-4815-3a53-08dd9dc46001
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eUVYZ0UvQTNmRjEramlvMkFVbzluTm1XcW11YmM4VldRYXdDTVF5eWRHVDlr?=
 =?utf-8?B?d1FKY2Q2alFpdmNzRmFmS1NoK0ZyNm9lWGtZWWtTT09CRlJzOEVCMjFXODZB?=
 =?utf-8?B?YjllZXZrVFc0dGd5OW9DSnpWdnJiZ3V0TnVqeVdrWGVzS1JvMVdaQ0hJd3Bn?=
 =?utf-8?B?SHdtSkg1a0hJK1gwS2ZoUmxHU2IwN0pLQ2FPTHRva2VhdER5V3hCRXlrY0Nu?=
 =?utf-8?B?OFhhdm5EclQrRW45Uy9EK1NCYUZBc3hIRkJJUlNiZi8vYjZSMTlkeXFuNE5Y?=
 =?utf-8?B?Y3RLMVlBWnZ3M1VIdk9IRDRiVlFJbTl2YjhmQjVVRXJBdlRZd1R2dDlDV3Ro?=
 =?utf-8?B?N3BKZ1NYUWVXZVBVL3Avby90S0hBUDlmM01kOHh6NHdUVVRsQVZHVDdCT2w1?=
 =?utf-8?B?akovQmUyRXJweHYrUmV5eW5tQ205QmwxVjAxUWxCdmtidnpJZ1NmQ3o0TU45?=
 =?utf-8?B?ZXZFQVFBQUsrd1AyN0tldW9zZDRpSG05elF0L1h0U3hoNkp1eTIyNDY2UWd4?=
 =?utf-8?B?N0FhRDluR3hrRU9XSmFWZ1dLaW90M3lYWFIrTW9iWk9uU1B1TS9pTy9TWnlF?=
 =?utf-8?B?eUdJc2R5Z2dFUFlaTnk3b2VSd01BSG5QZG1qOVJ5YS9wcFBmemlOaklWdGJm?=
 =?utf-8?B?dm92cW9KUkptL1YzQWNXUG81ak10eWttYnRjVUNjWFJMeU8yUkxORFd2a3Ny?=
 =?utf-8?B?OVFQWkhDcC9ibys0RnIvU0JRU0hmc09lZ2FxdkFySkZxU3pwcldScjRacTh0?=
 =?utf-8?B?dkV5alJrRzFOKzJ5SEttdjV3SjhxS0F1T2x0U1FTYi9udXltQzR3Z2VuM054?=
 =?utf-8?B?SVFXYnhPWDF2QWU4aE80d05ZLytzeHJJMHFvV2diYUFRYWUrU1lONDI5L25F?=
 =?utf-8?B?Mm1pS2VmYk9EbGhhK2hrL1NUS00rb21EYWJic2RHQkNlUW1RanlHT1VzV21z?=
 =?utf-8?B?UC9xL0l4dkgybng5VDE3Mzl4Z01yZi80ck1XaWU2VmN0T3RxT20wQUtXeFVH?=
 =?utf-8?B?UWs1WXJpZUFwVDFaa0RiNHVUazhXT1BidFQyRkdMTWxORFI2NmhmZHRyRHFG?=
 =?utf-8?B?RFJnNzEyOXppS3R6ZDBsdXF4RUdBSGo5UmZHYjR0WE53YVdiekgxT2JWZU9a?=
 =?utf-8?B?ejlveGh6WDgrTFNnK3BJbW9EZFVidld1dHE0dTAyRE9jRVFibWUzZC9zdG9K?=
 =?utf-8?B?aTBINWE5bThUa0FhVU9sT1djVXd1bm5YaVV4cjlDelZpVjBxSFBucWRaL3Nh?=
 =?utf-8?B?eUoyQUlJa0I4SWZVU1MxbklxZmk1Q3hrdnRoR3Q1YnhlZEdYL3c3V212MXVW?=
 =?utf-8?B?RW8xNSsrTTBUVkRyYVFCYnc5Z2MvRVJxc3RLSGNnaUpCRlArK2NSaUJNc3FG?=
 =?utf-8?B?WmpzczNDTXBnUmlwVXRkUG9pS2Z5VDZCdUd2RThyaWJsS0NoTURrVTdZN2JI?=
 =?utf-8?B?Qm53eGdaVUZkZzkyQ0ZyMXdYY3NYWjhQRHZuTFZ1L21XZHRqNVMrNDFPZnNZ?=
 =?utf-8?B?c3F1Yi83R2RlbWFLbC85c1RCRjEwelVaTU5uV1BKTmN1TUdiVHJNcjBZTDRl?=
 =?utf-8?B?b29EcXpnSkt4NWVsd0Jqbmh0dHJIMDRhTTlSYnJKalYxeUtkUFhISWwxSDFa?=
 =?utf-8?B?Y0w3TEdZT0ROTzJIdG5iN2QzVUVQYXFtTEY2M2tyVUdGb0dLSXE4aEFZMDFT?=
 =?utf-8?B?VThPMnJYejFJTHdRRzNXRURaQzRKNHN3alpIRnQzdnBJdGZQdFZSMWdxZkQx?=
 =?utf-8?B?SVY2RWpvcWNQbG92QzZMZjJpWlhPb2QrWnY3Q2FOK0VSWFhVU01Hb0FxNEcv?=
 =?utf-8?B?TWlCT2Q5eC9FYUxXMHRZM1V6UVlxaFlrOXgvbGJhZUhiSmVPV1NlMldYNk1q?=
 =?utf-8?B?VWFqeVlBMldkOWhVZWQ3Zk8yYTFRb01sYVFkS2srempZZ2wwUHczMkc3QmNq?=
 =?utf-8?Q?l8PnDRLMyvQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?czVlT1R6Y1VpZ0U2cTlYUHNkVWNVTWVaS1l4MUdlemNXRjJTMHA5aVVOcnlS?=
 =?utf-8?B?RzUzaXV1SHRqdE0zZkt2WlpnSzNUNjUvWmFvd0FLeHd3SjFtRVdJeTdwOW52?=
 =?utf-8?B?L1lQNEp5Mi9HNk5vNlZzR3RSbXBUN2hyY21sWU01dkc5WEtuYTJzbGYyRUd0?=
 =?utf-8?B?T3lhZUpGVTl6SHk4Wnp2RVgwcnBzTVN1SXo4QXhMRVJpUWVzNjhyazdRM1Ir?=
 =?utf-8?B?OUtrSldRZjhkdlQzZmF1bUZuVkhDMTdQZzhBNm1UUnhPUlUweEl2bnpKdVN5?=
 =?utf-8?B?QTI1MUp3V3NCaGt5Z0lOTUVteTBpNkl2dGJRMDFCN1R0RzJHQkxHUlBPbXJu?=
 =?utf-8?B?MkZtQzFyb3JuN2ZwSTdNMzErWC9GYkhwTWgyeW1QTDJLUXhCTEFFZHRyZVFy?=
 =?utf-8?B?SzVKMk5hejluTENhdFJ0QmcxUWlDVUt2eTM2RjFENm1zTEtTaVRIT1VrWEt2?=
 =?utf-8?B?UEx1bjl3dUI2bTQ3SHN2VndBQnBmeU5KWEEvSDNtQWZ3VU1mc3JYa24xK3B3?=
 =?utf-8?B?M3R1SG1PRlREV0UyR0JzQ0FtdHVHc0hFQzVKbmNTTnhUOFIybUxnQ1BJdUhQ?=
 =?utf-8?B?R210MXc3VVdMT0Y1bDJOdVFMek1xZFMyVytFZnpZczh4YjNyNysxYVFmUjVY?=
 =?utf-8?B?VkNyb3ZGOFBmbFE0aEk1VVdKRitKdklyQ21yaHRTelRlYlp2VGdvUjZTdnVP?=
 =?utf-8?B?OFljVHpGQm10NXNXUEtlMW9kamlhNDlOQnpKZ05uM21ibGgrb3RJREEwRkNL?=
 =?utf-8?B?MnViZGh3QWRQWTkwL0U1bGtENTI0WW9kZE5IZ0NidzRtMUh6cTdLSXJFNzVE?=
 =?utf-8?B?RHh4MGVxQTU1SXV0cnlXallzZ1o4S282VFBROHg0NndFbTZNOE54eVNFb1p4?=
 =?utf-8?B?UElqdG9BcmFjMnZOa2dSbndKNGNXVzVkYXNyb3hkQkFSTXFEeDdkdEMyZ2pP?=
 =?utf-8?B?Y240eUtRbjc1QmxleklBcGNLb3RtVXYyaXhMK2NtUUtDUkEvQXlYcmk3S0d4?=
 =?utf-8?B?RmwvOTRZa0pjclVBc084SUFHL2tSdWE2MEhaREIrQkhXaG54MEFXL0tuS0VR?=
 =?utf-8?B?SWVneWlvQjlvbStYSm9KVHVlQ1BFdUh5RnV1bmxmT2w5WXB0MlpKeGlxbVJu?=
 =?utf-8?B?MTMva2xJbm1xYVRVQzV1SWx5MW9UdDI4aXI1VmxGT0t3Z01WTGNrdVFOWFVv?=
 =?utf-8?B?NzJVYUVpYUJLa0pPbmtzZ1I2b0lNdWdPYndxaU84eG12NmYrZit6QmlDOVln?=
 =?utf-8?B?cVZTSHVKMzJKMjdHS3dGYTVPY2E2aTkxeVpWQSs4VWxuUStyeERDY2krSDlI?=
 =?utf-8?B?aDQwcnZzN2FBNDFhbmN4UjcrWG1ORmxLcHBiaHhUYVhJL3AyMDdFYkZaSU9C?=
 =?utf-8?B?U3Z2YjBGWW1UTGRlNU5NKzNwcFVqOWw2L0FJQlhpMlhhZnA4OGxncm9KRnYr?=
 =?utf-8?B?QWhvMUh5YXdnTnRXN3VHNCtjQUdIc0x3b1UrVTFKR0xNa2ZrL1RNTW9KVW1o?=
 =?utf-8?B?aU04Nkh2SzlQS3pXMndOMDh4ZDRYRlZlUHhoUncrd05yeWtiRFpnakx6YXF4?=
 =?utf-8?B?dlVHeHFvbmtkUy9KZmRkWnJVL045bFJRcWU2TTVKZmJFOW1lNHkvc1RCOXdN?=
 =?utf-8?B?UUZNTWNXWlQ0QnYrdHRuTmZqcld4NlovWEtRMHlpSWd5VDhhV244MGhHQUhF?=
 =?utf-8?B?M3I0MUZyM1h4TVY0cVlTM1ZpZExTN09XYlRyTGxmWnVMWXhlNHpyNG9PTjFm?=
 =?utf-8?B?RUNiYXhpOE83K3k1d01QbCtJWG5adkg4blBPTTh4MlZRaHZjTkFrbkxIc09U?=
 =?utf-8?B?YnR1eHR1aWU2WkR1QkxXNXhjRmwralFvOVhUYTNSMVNzYXdmeWpITlBFVG5G?=
 =?utf-8?B?a1h2RU1BRWgweVI0SnpDREszTFZPbVZGNEdLM3F3Umdlc2VuMHpGSGlYd2FD?=
 =?utf-8?B?blNUbm9tem1ocDVCVjBuNVlBL0VrS0VrOU50WVdEOUo1elU3UngxdUNFTng0?=
 =?utf-8?B?THRNK3NpUXZ6bkNlLy9nL1BIanltT3N3UDAralNFTm55MWhqOHE5REhJcU43?=
 =?utf-8?B?cGhiN0hjZ2tlWlRRbUphWUZ3MlFjSW5SdDNCWUFhcU1RaE9jZmRScHk3ZEdl?=
 =?utf-8?Q?9q/pYeJfwANWuRMM+EEYXZ5/M?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3e55a94-cfa3-4815-3a53-08dd9dc46001
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2025 08:48:11.0598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HGhNE0u2Oe12Lat2htlibr02TON1Mj3IpHmxqeMZmnABmwpDOE86GCgueTRSv+kDIEuUbSre1NGSBpCy1oO5kQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6074

Hi Jason,


On 4/24/2025 7:36 PM, Jason Gunthorpe wrote:
> On Thu, Apr 24, 2025 at 01:26:21PM +0530, Vasant Hegde wrote:
>> Hi Jason,
>>
>> On 4/17/2025 9:51 PM, Jason Gunthorpe wrote:
>>> The AMD IOMMU documentation seems pretty clear that the V2 table follows
>>> the normal CPU expectation of sign extension. This is shown in
>>>
>>>   Figure 25: AMD64 Long Mode 4-Kbyte Page Address Translation
>>>
>>> Where bits Sign-Extend [63:57] == [56]. This is typical for x86 which
>>> would have three regions in the page table: lower, non-canonical, upper.
>>>
>>> The manual describes that the V1 table does not sign extend in section
>>> 2.2.4 Sharing AMD64 Processor and IOMMU Page Tables GPA-to-SPA
>>>
>>> The iommu domain geometry does not directly support sign extended page
>>> tables. The driver should report only one of the lower/upper spaces. Solve
>>> this by removing the top VA bit from the geometry to use only the lower
>>> space.
>>>
>>> Adjust dma_max_address() to do this. It now returns:
>>>
>>> 5 Level:
>>>   Before 0x1ffffffffffffff
>>>   After  0x0ffffffffffffff
>>> 4 Level:
>>>   Before 0xffffffffffff
>>>   After  0x7fffffffffff
>>>
>>> Fixes: 11c439a19466 ("iommu/amd/pgtbl_v2: Fix domain max address")
>>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>>> ---
>>>  drivers/iommu/amd/iommu.c | 10 ++++++++--
>>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>>
>>> AMD folks: I'm just reading the documentation, it would be good to confirm
>>> this understanding. I'm a bit surprised nobody hit this, but given the domain
>>> aperture was wildly wrong up till 2023 maybe it never gets exercised
>>> carefully.
>>
>> We have tested this with 4 and 5 level w/ some bench marks as well as w/
>> forcedac=1. It works fine. My understanding is IOMMU uses bit 56/47 as well for
>> address translation.
> 
> Yes, it should use bit 56 for address translation, that is part of the
> page table architecture.

I have checked with HW architects.

In DMA API mode (PASID=0), IOMMU HW does not use canonical addresses. It's safe
to use bit 56 (5 level page table) -OR- bit 47 (4 level page table) for address
translation (we don't need sign extension). However when PASID is *enabled*
(PASID != 0), then IOMMU expects canonical address bit[63-57] should match
bit[56]. Otherwise it will abort the request.

I have requested spec writer to add details in the spec.

-Vasant


> 
> The question is what happen if a device uses IOVA 0x0100000000000000
> with the iommu. This is a non-canonical address, so I think
> architecturally on x86 it should be rejected. I would not be surprised
> if some HW treats it the same as 0xFF00000000000000 - though that
> would be dangerous.
> 
> There is a significant correctness issue here with ATS, the IOMMU
> *must not* allow address aliases to exist, so if it responds to ATS
> queries at both 0x0100000000000000 and 0xFF00000000000000 with the
> same PTE then it is security broken. The device ATC is only flushed
> based on the canonical IOVA, so any aliases can remain in the ATC and
> trigger UAF issues. This can possibly be triggered by userspace when
> using VFIO :\
> 
> So the question is not about if bit 56/47 is used, but if the IOMMU hw
> is validating the sign extension. Assuming it is validating then we
> must not tell the iommu core code to use
>  0x0100000000000000 -> 0x01FFFFFFFFFFFFFF
> as IOVA since it is not legal IOVA. This is why the bit width is
> reduced by one when computing the aperture.
> 
> Given the security sensistivity with ATS the sign validation behavior
> should be understood because I do plan to come with a patch to enable
> the high address space for iommufd and if some AMD implementations
> need to block that we should know :)
> 
> Thanks,
> Jason

