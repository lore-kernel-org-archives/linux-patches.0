Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2047.outbound.protection.outlook.com [40.107.223.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4457F1E0091;
	Tue,  7 Jan 2025 09:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736243022; cv=fail; b=Lnhd2kD4sRZeBCVeZXoBRfialCXLN+e3sKrctY0NGcxQ/1UR6ai/tAILdxrnbjIh9elGz8LUX/xe7a+Hl2vLjV24sONNxCDhedI8Bm/29rDnXciRP/oy+2w2w3bRNvSU7uqy3I+qziOk7Eal0TAte8lFPp7bmBZk5IqMilHklBo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736243022; c=relaxed/simple;
	bh=jw0hYmps2Brn3QREB0cLKYv2KK6KLiiVK+G8o2E8fMk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=C3/J8DCcXq33bw/do7RvIaCN+32/xHQNYXfJkveW4ljZs8jKZJ7cQo8FLSLbhIiBtV2ZXc6MkPNMb735MBNWGShhl4VcovbCok5PasynGvBFyRRASQwmxrW8Qj7QwrQeSZRSRdeAofetWFcHsRmr4VtFYXGDa9Sy1LLUCKyVJ3U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5Nc9Mdcx; arc=fail smtp.client-ip=40.107.223.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5Nc9Mdcx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qQub13kbV5ZMiz5TbP993yIin8rE8RQcaDRfeZ5TL/1CocwUwEqRm+JGrUDmgaB7R1VEu3yxQ3cMayOyFznOGVfkPlTjHYksJe/9ktK2ti5GxxVMphJSGrzp3colUa4zSnRsazdGZkcaQA0/gvMlMoiOgian3xXty+u7mBYqJRBEeCKpMihQscXu7qnd/7ah6H3xi4IU2yeBfRy0va41EK+iWoCdtKdGLspQVTD9ZHV6YGPLV+vlt1DC9pBAqKsdhTaUFocgfEImh9eAES5+2pQGnOlDNio97ldbG8QpPDPHaeioCGCrrAeWBbOLeIpmbajjpBwyfZv/bDYSy8SnoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=36TY0v+SfhBTl3UcNzGY4/6RbTFuSfwPLbc954XhIZE=;
 b=quGNOlq3jE0xPnN2ZxKOBvy22dvYXv6ovS735YlOcBkORmLs+2kFLXXlrFK+R+E3GDC3YmHVAc//eU0ahkRdUQeLLp4nrcg0B3d2S56BiUa+SVgR7MDGXhPLYlI1Np2+v/s+mnkrAkk97lkeuiuGXzuED6pjQG8r6ZKFX0jNy36lKQm1QAuOIsskNqdBAP/6xZCA3E9KXuT5rNlW0V0BBy13UTRDEF2/OSflqMRzm4+Am54OTgcnTLJ6WVW5UqbcDUGHMu5SVd5elWr7ygxxILN3UF0NeSfUGh8ggCcvCMgwCDxuQ/1BIqxuLlGuOGO2jPzs1JckhvjkX3dIIsYmrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=36TY0v+SfhBTl3UcNzGY4/6RbTFuSfwPLbc954XhIZE=;
 b=5Nc9Mdcx2n1H0pHd/2f3Bg0hvuvjrAvZsHcgpw0mBXLtKmTl9z+0tm2tVe5NIXQTuYt0sGqgL58RJWJUN8GS/+pultBPcUuwVe+qDFD8uScOChDBc27xOsObATW2S8y0tNnv8UuFIE+NbmdzFOVNUS+zJ/Z97aFZnw6S5HCQ6HU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 CH3PR12MB8187.namprd12.prod.outlook.com (2603:10b6:610:125::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.17; Tue, 7 Jan 2025 09:43:33 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%6]) with mapi id 15.20.8335.011; Tue, 7 Jan 2025
 09:43:33 +0000
Message-ID: <00169247-d97d-4d29-ad63-b39efe364a93@amd.com>
Date: Tue, 7 Jan 2025 15:13:21 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] iommu/amd: Move the nid to pdom_setup_pgtable()
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 patches@lists.linux.dev
References: <6-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <6-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0175.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:de::20) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|CH3PR12MB8187:EE_
X-MS-Office365-Filtering-Correlation-Id: 1eb8e10e-fa8f-4137-44cc-08dd2effbfe5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dlBqeHg5bHFCKzdKbVYzZ1BoeWZSMjArNi9YR2J2eHQ3RW4vYzU2dkt6TE1k?=
 =?utf-8?B?ZlJERXByemJVejJ6SmJlWEVzVUgyNXpaY09XWGtaSlhxSzJaTG82NjczU1lZ?=
 =?utf-8?B?UEZRT1hLNG05M0RPQlVwZm1GQ2s0dHJscGxONzNycVZqQ09ZNElaSmxycHRn?=
 =?utf-8?B?NkJpRERRUVB6RnA0WHFNeDdQVDRXUWEvb0czeFVodUk2R0w0bG5BeVpncTVj?=
 =?utf-8?B?UGZDems5U1NmVVo3N202aUJkT01EN250SGVaYkFCdUVNNXJESGIxNjB1L3VU?=
 =?utf-8?B?c0FWQkFuSGJaSDljZFU2MXlTR3dTQjE2eUFSelNtYlZ2eU9WMUdIb3FiZGxL?=
 =?utf-8?B?aEhudTVYcTdUYzdPNVp6RWd0eFBmUG90OGRoUTIzYUhyT28rWElON3hoZzY4?=
 =?utf-8?B?bk1jb1lYZFVwTDN6OXdnc0VZV0VSMWxCOVZ4ZEJXTWd1Ymx4dEZRREw0OEpv?=
 =?utf-8?B?cndPWEJNZ282NjhzNlEzUTZmY2pTUU9lcGJqR3NEUGc1Z3Bxdnh1OW5aUklS?=
 =?utf-8?B?KytrU1l6dC9tNS9aRHlaTncraGtjbHB3b2N3UFE0NGVHcWJpeWlNejZtV3FZ?=
 =?utf-8?B?RGNvT2d0Z1FVTEVaUkhCTC9nVlpRUGlVV0xNZE1pN0c1M1RXYzdTZ085dG9n?=
 =?utf-8?B?WmxIeTV2RmxrMFlOTlg3QmVvUy94YndtcXl6dmJPSlVlallKRUphRlg0QldF?=
 =?utf-8?B?TVl5QTJMMnBsVkJVRnVlU3dlZFYwb1NIYzZPMFd1RVJnbGJBci84V2tVZnFQ?=
 =?utf-8?B?OUFlcktjSXR0OGdLdjBVWDUzUENJdzBMZVJHcTY4dURpdVZ0TFJERnB4RFo4?=
 =?utf-8?B?UWFPVW0rb2w2MHl5M1NwYjFibFJOR1hVd3Q3WmxZS0d0aDRYUW02Nm1WSGs4?=
 =?utf-8?B?YW1tMWV1cnhPZjlKTmFldmYrcXVOdjJxbm5ZR3d6Q09vN1JVdmZRK293bmZK?=
 =?utf-8?B?WENibXlsbGZFUDFuNEVhd3ZYaDRDVnZCV0FlVG9iclVkVExnUmdVUmRHdDdH?=
 =?utf-8?B?b1VnQURhRVpsN09pMTN4MWxvblBNdnluZFhMRzZDM2JEclkyN1dUcWowWEs0?=
 =?utf-8?B?ME9DUWV1N2FGTTdtSnlvQVVIcmNxVEFKd0s3R2NJMUszUGd3WTNLd3N1TWl0?=
 =?utf-8?B?dUcyTWZSOHNhbkdTUkFPb1l5SC9RSWt4S2lVT2VZVTl4enFJalRWenB6RWlS?=
 =?utf-8?B?YXpoWFFSVUU0U0xMWWRqcjZmczYwcDdubi9TejdVd0NkWGVlRDJBREx0bXNw?=
 =?utf-8?B?aVBtSVlBMTlqRElYUldqUU03QlFQYUVNaDJHejl3clBZRmlzdTFRZHluRlB0?=
 =?utf-8?B?U1Z3MkpsWXVpbkZrMTJ5QmlVOEZiM0FHV0x6elVVbjBPcWZlV2hqb1NuTVc3?=
 =?utf-8?B?THFsbjF3RWNDTnIzZDJVenZ0V3Qycnl2ejNUL2hiQzZtdmJxNDVBUXVhUFNa?=
 =?utf-8?B?OTgxUHA1cFRpWnM4LzJCejViWFpEL2ErSzVKVjBpcjBvQzMwb2xXTytNNXdv?=
 =?utf-8?B?dVhPNmRVQ3ROQVg1R2VRT3ZCT0NZeXRGd0RHWUNZT3o2NlhwdFdtSlIrRFh4?=
 =?utf-8?B?YnY2cmh1WklTRys5VGR2REZzSFk2ajRta29aZk16V0IyREc0clFMZ21FU3Zy?=
 =?utf-8?B?K3BDTTNVdC9PWENvLytwaUkvTGY1UFliL2RudlJuaHRqZUFsZ1QxUWk1Qmc2?=
 =?utf-8?B?cDlhb0htNmZuWCtrTnM2azNzLzk0UDhaU1BjOTR5ME5TeWZpZlAzdnBBYUVH?=
 =?utf-8?B?MUh5RXg4djI3S25jd3gwcnNmb2VlYlFMQkpHaFl3SitodXhZTzFxNUg3ZDBK?=
 =?utf-8?B?WWRQaHduRW5NRjBzYzlCWWw1VG8rRFQ3UThyQTltM0xoMlVRb0NDaUdsaUhn?=
 =?utf-8?Q?PgZ6IQQ052yjP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aTRVUGZkUXdWc05kV1AweUt2WU42ZHhhbUVyOW9YS3RBU3docUx6SGV5OUpl?=
 =?utf-8?B?MC9QU3J0Zml4T0pVWUQ1c3NOdEljN2R6bS9LSXZrbFN5S0JsSVk0cCtZUDhW?=
 =?utf-8?B?Z25adlJnZHY2cUNyYkN4YmcyamQ4dWdhVTJKL3FmWVVzRTJMbk5oMEZmL25x?=
 =?utf-8?B?c2xRem0rV1hJaDVVbEwvNFlVZERlSElOb1RJQzIxZG00dWFReHR2TGdETHN6?=
 =?utf-8?B?eVU3SWxUc0FBTFBSZHU1UVJnYmZ5WU1IUDRQd0hZNlJRTnk3Mm5RNVVxaW0y?=
 =?utf-8?B?ZFlhb0hPc1Avc1dyWjNxYWxkV0JhS1o5NTBZdVZFQU1OTFhYSTRJUVlWMGZG?=
 =?utf-8?B?YWh6MWFYZmpPTm92M05pa3N1c1dEVUNhWS80WkVFeHZDVCtDKzg1NXd1TVRm?=
 =?utf-8?B?N3NreGszSXVEWS9YYTZWNVNOVWJ0ejRnVTNWYVFkVGh6YjYyNEdETFRiMVZW?=
 =?utf-8?B?Ymd1VnpUTjE0SHMzeU4xRjdOc0djRUlyaXpyK3hoKytsNXNCMnVNWnk0Tlgr?=
 =?utf-8?B?S1dnN0pOM1NEdXRlUHd5eUFHMG0zM0VUdUpzREY1OS9uVWNiQThGMXpOWkFw?=
 =?utf-8?B?RjdlZEJNV21YY1N4MGJaWS9kZmZ5dWlwck10VlIrOGQxMDJhUXM3a3k2Mi9B?=
 =?utf-8?B?R2ZmcGF5eWVYNktzSVBOQmp4MERZY3dIcUFSK29TanNjb1ozSk00OEJLb1Rl?=
 =?utf-8?B?TGhyYUhnTzFwME54ZE9JR2E0SVdlTGkyMlJKeFJXdldwMHJiaHczNHQ1Tmtt?=
 =?utf-8?B?SkNDaTZIM0F0VXN0SW9nT1dPQWVJK0FiYkNzQUFBRlVza0Vkbm52eHFoWjN2?=
 =?utf-8?B?a3Vzc0V3SFZreUhsQlEwbEp6b2JDb3h5aXQzRFJaNG1ZQzYwenhENE0yNXlN?=
 =?utf-8?B?emQrTHVVakxZTDdPSEc1Nk1tSXpJYTBzTkxPaUZub1JvWUV4MEQwWWJNQnVO?=
 =?utf-8?B?M3N1RWkxejNyQnB4cFdkMnlLMTJwLytmU01QM3ZrMFFrM1FrU1NLWXo4MzdN?=
 =?utf-8?B?V2RLYlFaU1hEcXFodlZkWW8zMlRaMkZtR3RZZnNLRjRtUTdlRTJsNjExVlh2?=
 =?utf-8?B?TldBKzNPUjZTcXgxZFBsa1B2czBXbW1SSFJ2TU5xL1NPRUY2UTBHZDhGT2xy?=
 =?utf-8?B?REJXQjcyZ2lDWERWQThTU2NWYmxaY1k4VVY2dGhCVjFmcExBKzhTRFVoRnhF?=
 =?utf-8?B?VFFRNlN5Q1NzQnh6alh4ck11dE9FOG45MDVqQld0dzlKcmdkZVFQV1dLd2Y0?=
 =?utf-8?B?djZkaWQvNk5rMEN4OWl5cnEyVmQ5RHN6UFhpUU1EL0NoWDY0TDE1Zy95NkpE?=
 =?utf-8?B?czZOMzVDRjhSWWtpcm5Ha0liWFVhNnNGYTRGVEZZeU9jczE5UzZVLzVwNnA5?=
 =?utf-8?B?dHRUOERUOEhRZWtWaEtGMFdNaXJpNktubDJubFVVb0xrTlo5SjRiU2tSTEs3?=
 =?utf-8?B?eWl0K1pvSWh4WHRwdlEwT0lsU2NiMUpROGQ5cXd0NkFjNVk0MUdoTnc2ZXUy?=
 =?utf-8?B?eUc5bVNPbWpLeDJrLzNYaVJCWG1jUkxBYVhsa2Y5MHJLY1RROGJaZG12L3Ar?=
 =?utf-8?B?RUU3U0VQNW9ZNEtKTEpQZWVzR1NoMHVFMkZkVkx1dHZidHUzT002bHdGVTU5?=
 =?utf-8?B?anlKcGVHZnRIckcySENHTmJTUlRaU1phQXF0TkdONDFNVmxuNmQ5VlZiMHlk?=
 =?utf-8?B?UGJzalZjdkVqMnNvbFdTYXViV0FOd1hFYVpBeGRpMGlEOUI1ank4ZFFYUjBV?=
 =?utf-8?B?cUxMZE80Qk9IdXByQ0hlT1BvZnU1ZFpQOGNQMVEyL21KQ29kOXBFUFhYVm00?=
 =?utf-8?B?cndlemhKa01aVE1XY1dKNGcycGordGxHSnVyRjE0cVdyOHhJRUZ4eG5JRkg1?=
 =?utf-8?B?Mkw5eUpYZ3dwN1ZJUVltRUVKTW0rdk9xNDhCUVBSRGRhL3NEQ0IrZmRpOXBC?=
 =?utf-8?B?WEp2am1xWldieDNsUEt4NFJicFh4OVpiQkJBc0lRbUlUeld1RGczSUNhQmFR?=
 =?utf-8?B?MURHd1RuR3dIUWlIbE5kRkQ5d1pEN2EzVTV2WEx6VzRyWDlwaUY0T1RTMjJy?=
 =?utf-8?B?WEdVdTR0MDR6Z1NrbUR3OWpaUmtPUVVLVFNFNlFqSnlKekNCc1R6RURQUi9X?=
 =?utf-8?Q?cEwXDnT1rT1yrZIAUsMfob2Jh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eb8e10e-fa8f-4137-44cc-08dd2effbfe5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 09:43:33.1002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LuDv3TJ8aO1B8jSFvK2QIqcKaPxeSnRLNeA/Vsrdpt8KoBQlrzcK02Dns8LN8KY48CYQGd3XyuQAxoQcFVNqjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8187



On 12/6/2024 5:53 AM, Jason Gunthorpe wrote:
> The only thing that uses the nid is the io_pgtable code, and it should be
> set before calling alloc_io_pgtable_ops() to ensure that the top levels
> are allocated on the correct nid.
> 
> Since dev is never NULL now we can just do this trivially and remove the
> other uses of nid. SVA and identity code paths never use it since they
> don't use io_pgtable.

Right. Also in attach device path we rely on IOMMU NODE to setup GCR3 table.
This patch looks good.

> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant

