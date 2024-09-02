Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D933382;
	Mon,  2 Sep 2024 05:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725256377; cv=fail; b=RSQbb3aHilTHKlI6yCpDcKRguThLE5kkkdVEQtjXSHWFcj9kY+GL+QqHMGtn9sAWOgTDc0xTVmRK/+ingiNMvlN/3SUWs1UHzpRSDaHwYvDcLSI/lygW2nCwSsmI0sjH/C6t3Ccd3N9Rm7Jhz9PxJeMkqd02yS36lztrWPV+t6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725256377; c=relaxed/simple;
	bh=i6RmtlC8uol0gOv1lvTL2rrRS+0ZunVcUIn3PMxmCvM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SlnPCOqeDIT4G06ORGzJaAM6elpjegQJOZUsWhD20U5EpxNhF0GAM9HvB62qbSZX34eyucQgrkzmL8b6EHdLX2futi+Gkpe3W1cagQviZgBefahzDDjoBsMq7D+c3ZXhzcFmYbBSvJbOpNaVH05/l5EkuxSVlXIpIDn3etZg0Nw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qJ8SkHEu; arc=fail smtp.client-ip=40.107.94.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qJ8SkHEu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MCxZwhGJsgxnWJ/0QnTGMpXgO/wpaI3XZUeQh3C9R2olamEQyULQURaxTOF89ApTFwMjDOcJI6t0ipJiDNP3rR4SEfXeQiVDSCLA8LIGu4ZS8mEPw/cOLPDzKbNvGyvj7VhcQhFazDWwD53LWkF+ImQRhEEJ5P+RZqm1AglJT4j5uAO++AAeQHg1+f+Q0ajSlnrbXjM9taqnpkV+12jiolvqOOEj7bKC4opohBfp1aoLsSKgrTFleha3Cda+Ivwc5Tw4HQ/1qaEc01DIbqQxm35RfzGnIdrWfnbN367WPjB2Nzpj1XdRCIh6m5WcQFz2FXqiqpFpXwLcL9sdcHU7Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aKWOHgkP1sdlZv1wjfl8u17ouFpB1n1SDOzQyiGB5ak=;
 b=JM/vYLBlMhdK4hTbdec4Hr2BjngeXs/7xJvlL9uraPg0WIcYSxB1m7DXOlnQk+sJAWPm5E8MdQwnjFzTXKYQD/IOdCJRP0178L6b9WN/5Jne3qoW8gobzeJoLs805XPT2je0Qg6YiWAMnowbiguWiEwIIaMW2m1B+IBZcyjjIpYk+xtuz1MqSKbZy3nTt5AxpvAYSZv1twzO6wTCqjwKHg091kKBDyOpLOrL6m7SUE7VipsOygeHHGzNOHcDG3q9/zLmqvawqNQEa9wRh2GgPTJXh4g3S1oZLV64xCV3hypIMP6d3dFfO1cwCm48pqtj/O2nJcUD2TeIocXU9xA6wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aKWOHgkP1sdlZv1wjfl8u17ouFpB1n1SDOzQyiGB5ak=;
 b=qJ8SkHEu9j3Ow56r3AO3BkYLgp4WlIiGGRgUCSx23oi7JfiifnmfI3ugLSPZrbECA9dfXaCFb7y/o0owVf+VD8aZ/DRuSmBf+obez2RCd+c2goEBJ3wZL3UT7pQ1r5CviGEb+2ZQy7yKtJgn8UF0VMn4ncHhLoCI+LBm3MDl6+w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 CY8PR12MB8268.namprd12.prod.outlook.com (2603:10b6:930:6c::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.24; Mon, 2 Sep 2024 05:52:53 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.7918.024; Mon, 2 Sep 2024
 05:52:53 +0000
Message-ID: <e0e27f51-cba3-4c42-81a5-369bd34f69d1@amd.com>
Date: Mon, 2 Sep 2024 11:22:44 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/14] iommu/amd: Store the nid in io_pgtable_cfg
 instead of the domain
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Joao Martins <joao.m.martins@oracle.com>, Joerg Roedel <jroedel@suse.de>,
 patches@lists.linux.dev
References: <8-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <8-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2P287CA0002.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:21b::10) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|CY8PR12MB8268:EE_
X-MS-Office365-Filtering-Correlation-Id: c739e11c-af34-4243-c0e9-08dccb137c5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q3JOSWpqWkhvenRFUXdTZHN6ZVVweG5MYUtzRHVQZUI4MnRGVExUd3QxZVRu?=
 =?utf-8?B?cVAwODA3UDU0Qm1ucDVaZzk1ak1COWxQVGg4NE0xTGRGWFV2Y0F4d0F2NExB?=
 =?utf-8?B?ME1TczRmT1BNbXN0cTVzMmRGTHBMQzhaeGJ1eXZDY0c4TmZVaXNiaFZQUVZP?=
 =?utf-8?B?bzF3bCs3Y1ZoYUMvS0FMYU4zS3VwYWpUaE5NcFU0QUt4ZGQxTlVQcjVVZ0RN?=
 =?utf-8?B?ZnpYdERJRVRCWkw1TEJ0RVpWSGovVXQ1aUU0Qm81UTRuNU1qcnFPTHV3TGc3?=
 =?utf-8?B?b1JGWXdORUdCempBK3YxOHRMQU9xOVZ4a1hIMk82Yzhvc0pGWnhWelh3UlFF?=
 =?utf-8?B?OU81UTl3OGdxZ0pIc0YyZ3E4WlV1OFVVemVOYlF1bHVaYkh4d1Mva0hRQVkw?=
 =?utf-8?B?a1prRERJWFZoalpNNFhoTktpZzBMaUNPdkxHVUMrOWxVVXJLalp1eHZUdjBX?=
 =?utf-8?B?TDc0Nmd5VGlrWnFaaDMwNFkreHJDTGxWQURlcGluc0hWeS83eGpweUx1cGJF?=
 =?utf-8?B?dWtLVFY3aGN3bXNVdVRGVlkxK2dUcjRRdjd2eWdxdUlaYll1Ziszd3BaWXJY?=
 =?utf-8?B?a0xPZFp1bS9lcVZaQ05oNTFuTzZIU3pLV21lemI4NFRwM3FRRjBySUxyNC9G?=
 =?utf-8?B?bzkraG5PU1lERndmd1JqYm9QaDRpZVorYVlyK2lGSkx6VnBJWEFPZlB3ZFVx?=
 =?utf-8?B?bXVXT29Nb3BaWmR3blNxMk1sQTkvRjM3SmFMZGlmWmpxUGtWaGZLbmxwUTdU?=
 =?utf-8?B?QlhZa2VkL0dHZjVKOWM4NmpNMXE4OEZhZU5KTUYvNGtEQk92NGQyTEFOdmhW?=
 =?utf-8?B?Y0hvdDFhQTErQ0RXQ3pBamNtaGE3TXpaVEd2NlVSSk85Q0dEVXhFa01GY0M4?=
 =?utf-8?B?OGNiQzlCRjBJWSs5eUViTUxzbTk5M2F5a1ZsZ1VoUlRKeTREcG9hWVFxUW9P?=
 =?utf-8?B?M2xSY0loeG9iS2NrQXFWNDJlRWxDa1V5WTl4RFhyUGVUaWVFaGRMT1VDYTNP?=
 =?utf-8?B?K0hzWTJFb1VBUG84K005ZzY2Q1lFWXgwc1VvUk1PSXEwWm4xVEliSVhDMERm?=
 =?utf-8?B?am8zeWRYNTBVQ0UyZlpaN3A4U3h5bXkvZm1zb2ZyMXdDWVExVUtJanhjY0cz?=
 =?utf-8?B?dUNEdDdJamlSQzRCK3RzQVBocEp1ekNXL0FJcDFVSGkwVkhzY3dmZzM0NCs1?=
 =?utf-8?B?Q0JiTThLSzJjRGpydnZJS2ZsOXlVYVlNSDUxUWVoNEtuTEJ2eVBoTGhubjk4?=
 =?utf-8?B?S0FNU3dnWllSWGVEL2F2MFgyMHN4VkdpLzV4THVhWWppeU1FQVVLV2Q1UzA0?=
 =?utf-8?B?cnpueWhxUzN4VmpOTVdPMWtnbFBpdTNUS1o0TndscnkxdGMrQnNkaVBXdmFj?=
 =?utf-8?B?eExSR09pNVVWaG96RUVrMkxidG54N2lINlJoTUJsTDZ1S202K1V1OFVFVU43?=
 =?utf-8?B?dHB0RGhGZjVmSjZ0dThqZnpkYVRBaVQwMlUvUHdhWEtVRm52TWZrR0VNZGFB?=
 =?utf-8?B?RmRBeEhHbmVmL3pCM1hlMDBxMTA0WjQ1ci9CVEw1QkprTXBsWjNERWtXSDdv?=
 =?utf-8?B?Mmk5M2J1WWtkMnFRdGhGUTIzeXh4dVdlRThZZEVIellWbVJQS3BKUTBhLzV0?=
 =?utf-8?B?eFlSZ1lGMG9JUU1XSTA3YlRPYjdpckVMUkxQQlFDOWIyN05wZTBNQ2N6dmpX?=
 =?utf-8?B?SzJ4ZHhhUWJDTC9xaVlqZHNrYjkxWXU2U0FwUEdBQkVvNTZNVXdVWVNMWEx5?=
 =?utf-8?B?UzdHRjJjQ3hXZmNlWjRPTXh3djVQdkdpZFkzMjFOeEhtNnZ1VXFOMmUvSFJC?=
 =?utf-8?B?bDhkYXZOMEpPenBoOVoyUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L3grU3hOR1J5NjdKMFRldGw1YkVLZ09SMVQ3b0xLY1VrazNPNDJlZVp5SWRQ?=
 =?utf-8?B?NjcvcUEvaGh5cU8vN2ltR2xrcXFYZFFGL2FBaWhCeVY2d0JLbkU3Vm5XVEpQ?=
 =?utf-8?B?eXJIMlBWeWlqRVY2WEhQZkhZMVdrMzVIVXd6cUw1UitCWGxSalFEVnU1YmZz?=
 =?utf-8?B?TTBRQ1RKZkw0U0dFSEhJZlpRVDFqV1NiWGFmVWx5L0dURGZrSUFHYlV1SE92?=
 =?utf-8?B?UE9USmZpMzBCbSthK01Fc3FFblpkT0xhTXpoRUtWdURYWDFlMXR6ZFhGY1hU?=
 =?utf-8?B?ZzlIU3hLTGw5dXU1eFNSUmZIZWNVWmxiTDdKM0JWZHFLVVc3NXA2NmZ3djBq?=
 =?utf-8?B?aG5XUXFlSGVWdWJvbDI3ZTIxa0xzbXNLNCt5a1FTb29TU1hBbmRYa2dKb01B?=
 =?utf-8?B?VGpwUXMwL1R4cU5xSHRXQmFVZFg2WGZYdGdhZXRQT0I1cHZta2s3SjRZZUNn?=
 =?utf-8?B?OTZ1NmhKS2VEb080RTNYajhOREZabEZFWW54QlFlVFhZZVd2N0FDT2Q1cy8z?=
 =?utf-8?B?TjdWL3VHYzhrOFNwTk10eklLUW9kekFxZDlJVGEwamNWSEFRR2tTcjZEVWNQ?=
 =?utf-8?B?OTJjblV4RFhxNTg3QnI3N3U1TTM0dW9reGk1RDFpRmU5dmR0dnM3NldQZGtw?=
 =?utf-8?B?bFU4TlFwWU1pTGxMQkFCR1ltd0JjcFcweTU5N0hBZldyUWd3NWZlQzNEQ0ZH?=
 =?utf-8?B?MjJSRllpVlFBQXkxWG1wbkNiTzZiZUI0SkFKWnhYbzk4azRMd2QyVTFkMytx?=
 =?utf-8?B?cXVrUm12UUhHSTQrVXU5Vks4ckNvb2syV0hGMXRoMHppVnB0bjFsWUNIVENP?=
 =?utf-8?B?cU15ZHFZRE5YR1l5VlFES2kxSmx5clVzTlZLZTlXNS9yTmE5UWV0elJIbFNE?=
 =?utf-8?B?a2xBRENoSWFOTm9QY2huUjJXcWVUT3lHTEpEL3d0TGhDQmZ3Z1JzYUpCbGxu?=
 =?utf-8?B?SFBOSVhpTGNoUngrc0lObnhxUGhiY25hOXAxeUx1VWE4WTVGL3liMGRWajZt?=
 =?utf-8?B?dFFGa3FmNi9KT3MxV2tlWDZRZzFSUVk5NUpUMC9RNi8zSUtmR0JPYVhsRUg3?=
 =?utf-8?B?RWhTM0FvdFE3U2NPMnFFTlFDREl6QVI5ckRZOUdqZ1Vic0dLcXpHekE4bklk?=
 =?utf-8?B?dlJCRkhuQTRYNm9mL0Q3bHFrdDhWQlhXQmFzUEg2bktMc0h1RHV0clRKYjN0?=
 =?utf-8?B?cmIrMGVodlRmNW5xdzhMMXBVaExPRXZNcG5jTnZkL2RnRG43cjR6b3k3Q0N0?=
 =?utf-8?B?b0JDckNHLzhtaXdVVzE4eTBJaWYxa2s1N21WWXM2czVYRGgwd1NyRDl5TnVE?=
 =?utf-8?B?QWE5M2F4ZzBIRGsrbVBkNU9qRGxEbFVzakRPRkwxcHNUb1hUSS81YXk0SVpQ?=
 =?utf-8?B?QnRiOTlwU3ZqcFBjZk80WFNySXV1ZFNGRnhKbWlNSGg1UzlEY1NZLzlGMytD?=
 =?utf-8?B?emYrRmFBcDFLSk80blJhWUVvQlJlZTc1Q0hBdHowUW9aazdKeGlCSkdNYWtJ?=
 =?utf-8?B?RHRBMERYSDFCTHUwZVl0Sk9nU2tUaFZTdmpwMHZ2Z1ZSSkpqeGtZMW81aG1z?=
 =?utf-8?B?SnVPRmRyekFOdEJuNVZNWlIvOVE3MTdOQklxZEx5eG9UTmcwYkpOcE14SGlm?=
 =?utf-8?B?T2NyOHpkbVN5cmhwMTFYQWs5YUpFTVJnUDJUTFNoS0hXSitkd1VNTzhlNmYx?=
 =?utf-8?B?NkRoRTdpdW1jdGJpTHVhYllLeEN2V1k5aEJ2R3FONzNrS2RycjQ3WTVMczNQ?=
 =?utf-8?B?endCS3gwbVZId3VJanJSOVZQSUhFbXFNb056QkpENGdCdzB3VnBiM0hCY3Fw?=
 =?utf-8?B?VWwvbWtWSDBRK2tKSGIvTmQ4c0UyZmxkZlVlaWF4T3lERzZXbDNoK0ZjYk1l?=
 =?utf-8?B?UEo2QlFMeTNXYVdNUUlidk9BWS84OHY1M1pGMURKK2QveEtvVVdkMUMyeWVn?=
 =?utf-8?B?ZTBXTEVtWVI1eTdnUlFBRFg2QWFiWS9ocms0VXBjbVdiQU9QTmRPenNIR2I3?=
 =?utf-8?B?ankvcy9lNDBHU245TTE0enRlT3V1Y0VWakVGU1Y3YXFjMmthd2VrS2h5QlJt?=
 =?utf-8?B?emRhMGh5TnU2K2o4dVRmaVlRQkd0bDdyaC9FQjNzczlzZk9BQW9ORGhBanNt?=
 =?utf-8?Q?WxgDl8iCbZcVGdgPswXF6Xp8P?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c739e11c-af34-4243-c0e9-08dccb137c5f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2024 05:52:53.4163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uOob7XRUcj1f30LJ316EJbFaMMNM+BaOl1SWK4QaIwiOHbUIT+dz0UWMSsh/yYTr+ZFCHbahQwjiyKxjd2bwuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8268



On 8/30/2024 5:36 AM, Jason Gunthorpe wrote:
> We already have memory in the union here that is being wasted in AMD's
> case, use it to store the nid.
> 
> Putting the nid here further isolates the io_pgtable code from the struct
> protection_domain.
> 
> Fixup protection_domain_alloc so that the NID from the device is provided,
> at this point dev is never NULL for AMD so this will now allocate the
> first table pointer on the correct NUMA node.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant
