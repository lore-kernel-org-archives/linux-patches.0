Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011026.outbound.protection.outlook.com [40.107.208.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75983368971;
	Fri, 27 Feb 2026 01:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772156394; cv=fail; b=hKWpNznOrpqRXOL+ZI4cqIsixBDXvZT9coPQgiGyl5zLj2KIbde/3t1Y7HiWFZlSwSFxhnSr2GmskNMfjqwYuvjyN9hptX9HyZV79MAspJdyU199k22SV9JpnlraWlWq+eorK73+geKphJ85cC7w8PyhKnnXSegwi+p9xKp52nw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772156394; c=relaxed/simple;
	bh=inyR8nDqeqqaKNBpMcHOg1eo7zb/JrdjPRhnUpA0FkM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Koyip9y9vqAaTtNFHkGe96cCTEd0iRqKtX1ATOxezCCE4WSmsf2M0p5HSyNcEhZpY3aIhTXUJ+bpQQK1udV+dKvMgL4yq0elb+xC10UMh1D9DTkEWckUXZeHATuYPXn2B4YtX9cBYASnUtqBKVEt5gTio2UofdkQJGUkf8iPnVQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XOTHE1bL; arc=fail smtp.client-ip=40.107.208.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XOTHE1bL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ygBWG0xMN66E/S0/Voct5d+rIgrHmpGf9fKiP2OkYTgfYHXXLMWDpkugaCbGCVBNU8YJX1PRRbb5Hly7WK4eBvQgiT9gASfN9DaKOUh/dbC9mOsB3yx1Kbh34SrNiqZQKhqRdQ+n4ULNP3BZd+Ve1xfAgxL7yyBywrUsTUnDo3Pt+lJl642e1Epc8+U8L4FiRVptJoTsMc5/gP7ArvYoCJ11oq3lxy29q03fYpm7UK0CJanjW6ZRcZ3L6zsZmI+ezB44QyYSjWQVG8MnWfHO3YqnBaNcWCRmmxjz24S6d1D5r59YA7kPEpYxUHro83Fp3DoeL4HtC2C/yBlNI2nEpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QG3KPo2Zi7zpNxDyimrJHl1x2mFjafcrqYjxpOuhn/Q=;
 b=LjsDLG9WOhiFfQ5qyaipRJNi44Dyc7RBYms90AVw5BFAuoOgcl+Ca12n0x+K4+N1JqzVPwt++3pRLs1kNMkqFezbVhxBrIMaz5NhbB7pEiYb2My9OhkK4HCp6kI+EweK+vNx4l376+0lXkkaECuIh5KZCRfbuRgmAU6v1QKp7Z7PldfZ+IPK1VRC+uGQrAVOwCTLAmh9FT6k82JwGMi8+TFIOUhgZOAUCCJgKTdsfjJKjym1gtQ3hMxNN4GFCOS/QbxgaUZsgWFk6AilIIDdquqxOwnemes/8Ollvq4TP5ldDxCpSPK+zLkUSKYLQfbpdTlIKjTxFdV4U64fnFE3ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QG3KPo2Zi7zpNxDyimrJHl1x2mFjafcrqYjxpOuhn/Q=;
 b=XOTHE1bLSdQS8+zAhREyEFpkfv2midUsRY/+7qv4Iptu2cw2Uhz2kJcVlDAjGtu37C99XhN2pcXGgXopk9aicWOj2NeBHR5QpsYIDhJjaGHN4Cwge/S4/r/pCoOu2+PvrCkm1mep94CJdD5Wr9QpTVZbkWKUZPe+JuSIJxzc4+A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by SJ0PR12MB8168.namprd12.prod.outlook.com (2603:10b6:a03:4e7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.15; Fri, 27 Feb
 2026 01:39:49 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%4]) with mapi id 15.20.9654.014; Fri, 27 Feb 2026
 01:39:49 +0000
Message-ID: <c6ac32f2-2531-4bd0-abaf-ff76e9cc864e@amd.com>
Date: Fri, 27 Feb 2026 12:39:28 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v8 07/15] iommupt: Add map_pages op
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Anup Patel <anup@brainfault.org>,
 Albert Ou <aou@eecs.berkeley.edu>, Jonathan Corbet <corbet@lwn.net>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Justin Stitt <justinstitt@google.com>, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org,
 llvm@lists.linux.dev, Bill Wendling <morbo@google.com>,
 Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Miguel Ojeda <ojeda@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <pjw@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Shuah Khan <shuah@kernel.org>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>,
 Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 James Gowans <jgowans@amazon.com>, Kevin Tian <kevin.tian@intel.com>,
 Michael Roth <michael.roth@amd.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
 Samiullah Khawaja <skhawaja@google.com>, Vasant Hegde <vasant.hegde@amd.com>
References: <7-v8-d50aeee4481d+55efb-iommu_pt_jgg@nvidia.com>
 <fc4f0354-4e6d-452d-abfb-fe24e53253a2@amd.com>
 <20260117154347.GF1134360@nvidia.com>
 <bc6817bd-4aa5-4033-b89d-88fef637de65@amd.com>
 <20260226150440.GB5933@nvidia.com>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20260226150440.GB5933@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5PR01CA0087.ausprd01.prod.outlook.com
 (2603:10c6:10:1f5::9) To LV3PR12MB9213.namprd12.prod.outlook.com
 (2603:10b6:408:1a6::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|SJ0PR12MB8168:EE_
X-MS-Office365-Filtering-Correlation-Id: 81792bcf-b0fc-473b-3328-08de75a117f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	esGhj8Tfq90sFgzjoGS5/uNvt4KCgTcfGVja7tyt3DOAoNrSz+nOuGrp7UPDGxXhfhGm/FqdgzPa6Gh+XEgmk/N+sUxXjPpPa7miHY+WW7Dxlqn5aQRnVnrqijm3giMOzwdko7Rsqa7uBy7/ASQ4r2668nZ5v2XzSmL3ePX50a/zNjda38DkGt0HrQeLb9e88C5AHpMoP4F899HJma2TwoURyR7CNkXFczpiUaarZWD8gH04eeb52VXxNwsym5dlU+9xHfTdrNe9Cvxik8vX4Toez24LslDgWwi9Ve82nrVXmYwxqJBTWTMTQEVQQNlY6VqrVWZDDDznhsyGEK2y9uGoPob2OP+OKoKFv7HJPTXCbCnGswyxc06EZ7049FTe9M1P8HLTrvWC0ZcWz1552PbjMD0x3gJLHiitdenSpRiIq/eUsiavcGP/P//s0OfZU+KDN7mst3lqS71WFiLq4bSACRfrDWbupK7zo9D4IF4w6yFUFLv1U7Ui+IDCt3dDP1dLDI1MPcb1rcZYCVVDdttS0AvV6A58c2P4b1D+qR2FoCE9umCcNTqLwxL0K5ZPgvCr3fMYHocwYSTxep8OA/1sr53EHlk2hq92skrcwWhbv4k50pLT3+ww1xx6GLY+oh7AzsYwsLmPlaFavQJ93N1I2TAXS//MvZFa6QjGj2CdhFTOwqDfuD1uA2BEj1ZX
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Tzc5MmZqalVCRWRzVEcrNmV5Y0l6Sk9Wb1V6T2txWS9STE45RUJibXM1VThn?=
 =?utf-8?B?TTRzNGJYelJaU3JzV3FZOWhTRDI2Uk8xckNXYnZDS1hXRElXMHlwYVJMcEJ6?=
 =?utf-8?B?OUpQc3hNVWFnWHdpQnIzWlZGSDhvSVVDRFdpNzhvSGVWTGlNdEo0WmhiWVh3?=
 =?utf-8?B?eTF4aDRrOEZoS2JCTmF1OGw4MCtMcHloODc3eFROZktzZDk3Q2ZMSVNkdXI2?=
 =?utf-8?B?dHFFbzRTd0pMbXJZNm91QjBmOW5EWThISFV3Qk9ONGJjYlpwZFI2am92UGhN?=
 =?utf-8?B?MWl4cklYT2lPOGtLMlNiZzNVa04rZjlXZlNsdXBCeTdRU3dPQTRUeXFjQnht?=
 =?utf-8?B?ZHZwYWJSUW5sZXAyYlRnc0pzQUxiWHYxNjdkWExuRTNGMU9HT1BqOE56MGp6?=
 =?utf-8?B?YjZoUXMvNStpMjU0NXdsWnBXRUNVbUFiZm5Oc0Rxdk80YmZWSFNBLzlvS2lu?=
 =?utf-8?B?L29XTlRxS3lTVmhZUjNWT05rZ2FvNTVRckF6dkYzcW03KzBSSnZQMEZtNUgz?=
 =?utf-8?B?NDlvWVVybXlSZm1xeUkzdVU0ZEpQbzFPTnFSMGZFekdWT2tJVzF0TFBHeEty?=
 =?utf-8?B?WEhRNXp6TDZDY1E3N2JVbVpVSkx2K2h2c09HTVQvR3pKSkVHa1BSQ2VDeE9p?=
 =?utf-8?B?VDhnbVVNUFJ2ZnNQRjlqMkFYUjkxdEZpNHJQMTltc3dmOXR6RWdIVUdtUEsz?=
 =?utf-8?B?WHRoZDZUeWlCbkJvVWVyLzNqTGptS3Nia2wzMThxQldxUU0wT3RwZHZVS2dw?=
 =?utf-8?B?VTZRSk03SU1ZR3NHVmNtdE5tZ2pZdVFRTnZlV2l1ZnNaUzM2RHBYMXZXSWhW?=
 =?utf-8?B?T09zNDNCN0tXRXk0UGQyaHdjcWRWdFJ4MW5SNmpZMDlKOTlmbXRjdXlCNm9R?=
 =?utf-8?B?TFFqRUxNanVveUswSmZpYlFZamVkNUVHOXdUU1pqM0dqc3NteUlnZ1J2dnox?=
 =?utf-8?B?QTNpeG1kWjBPbDhiZlRwdnZjUEp1aHlEUk1NMjR2eE10QlFUZ09ibEdRVFFP?=
 =?utf-8?B?RE55QXpYLzdIckhCZEpVUUovWDlNRFJoK1kyZmZFSjlpOUI3R3lFdDFPbHpF?=
 =?utf-8?B?dnJtN3lmZFhBcVptblBWSU5WT2JwQmp2NVh0YlowQ1dyQmk0ZTd3MjNLZmkv?=
 =?utf-8?B?VWF4b1BwY0tySFFSbEtOL2ZvZTlpL2tYOEc4Z0l3ZUU1ci9sM0VMNHNzMGZK?=
 =?utf-8?B?R3NKWXluODlsaXlXL3RadzFvVktvME5zRDV1NmlRZGV5ZEZVSDN5K2syZ0w0?=
 =?utf-8?B?d2QvM1I0Q3duVHlyVkJ1cFpXcTJWNHBFUkxFMlZkaS9CUUlZYXYxNHlmRFZo?=
 =?utf-8?B?eFBLd1lGM2Q1d0QvUXhLZ3dSVjA4RDNWYXV5a3ZqZmdEbE96ZHpyRUR0WE5t?=
 =?utf-8?B?UEpNV3NIbFdyeDYyYmx2MGlFOHJQMkp0MGlob0lmYmxuSzNUeExvdzQzNnN6?=
 =?utf-8?B?TFJFL08xbXFGd3FiNUNvaGF2ZWcySHhNY0xVVlZleGxiNTdHQXV5ckhZRnNN?=
 =?utf-8?B?MnhzS3BEbzA0dXc1czAwUktjeTRHQmxWcGN2UU14cWdXRHpVdnRabGtkWjRz?=
 =?utf-8?B?NjRGRUg3c0JBb2lSanV4Y3hobDRmV3hGdlMzTWxNTXA3UkxuOC9SeVdKcUpl?=
 =?utf-8?B?ek1CM01YcUtIZWd1WisyNlRwMTVYSWQvSDY5V1hPSFoxV2wvMEFxekUzeWo3?=
 =?utf-8?B?VWhDSHMwY2NtaWRVU2diQW1LQ1NEN0Q0OE91R2ZJU0JPa2txM2Rwdml6cmJM?=
 =?utf-8?B?YUYrdytJMU8ya2JUM0Y0ZnYwcGpQdnZ3VlpROWdvelNPV09KajdJY3VwbUxW?=
 =?utf-8?B?NFoyeGxYSFZQOXM2Q2Q1eE5BZXVWMFZrWVRSSUw3QjA1ZWpRcUJwdXF1cnJO?=
 =?utf-8?B?Mm42TENkdTdIblc2WmRFYmljUDZ6SDdFYktjSFNpTXhsTURsaDRRZ1ZpQ1lo?=
 =?utf-8?B?Z0k3aU1sTkt0Z0Yyamg0a2RMdDlhWUVuQXlzT3Vqa1BFVGprdDM3OGVZNGRX?=
 =?utf-8?B?cVE5M2szNERVdjFidjhUMWdsdHZIN1FYQXNDc3B6WXA2VE5vRitZTUthTVhT?=
 =?utf-8?B?cjB0S0duK05OelVremN3UFF2RS84bFR1ZWFwS1M0WUs4bEY2b3FFL21NWDU2?=
 =?utf-8?B?MS93Y1VRK3lFa0Jnd09QRHllQUJmOHhPSlAreDA0b016MmYva0lUS21xMnEx?=
 =?utf-8?B?VCtPeWhraFJRZDJNYU04YmNHZHhOZHpwck0yRlJGcjlUQTIrSUhqRVdnNU1H?=
 =?utf-8?B?Q0FJZDVyOW9ZaGI5OFpFUFNYcmpPMUhKY2FWUmg3YmJNZXlvQzYwWXVvUVpV?=
 =?utf-8?B?SWV1WEtZL2laYUdBVC9TakdoY29GRTNVNEtOazBZTEJmbU1nZUpyZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81792bcf-b0fc-473b-3328-08de75a117f3
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9213.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 01:39:49.0069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lSeYLy/78UNwtW1c2Zk2ZEFTbjSE+wqOFi9RBeqC9HdHnaii28ow63WFN9mI7dZasTgaCs4V0SnirfqFzSOs1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8168



On 27/2/26 02:04, Jason Gunthorpe wrote:
> On Thu, Feb 26, 2026 at 10:11:56AM +1100, Alexey Kardashevskiy wrote:
>>> The flow would be some thing like..
>>>    1) Create an IOAS
>>>    2) Create a HWPT. If there is some known upper bound on RMP/etc page
>>>       size then limit the HWPT page size to the upper bound
>>>    3) Map stuff into the ioas
>>>    4) Build the RMP/etc and map ranges of page granularity
>>>    5) Call iommufd to adjust the page size within ranges
>>
>> I am about to try this approach now. 5) means splitting bigger pages
>> to smaller and I remember you working on that hitless IO PDEs
>> smashing, do you have something to play with? I could not spot
>> anything on github but do not want to reinvent. Thanks,
> 
> I thought this thread had concluded you needed to use the HW engines

The HW engine has to be used for smashing while DMAing to 2M page being smashed. It is not needed when the insecure->trusted switch happens and IOMMU now needs to match already configured RMP.
> for this and if so then KVM should maintain the IOMMU S2 where it can
> synchronize things and access the HW engines?

I want to explore the idea of using the gmemfd->iommufd notification mechanism for smashing too (as these smashes are always the result of page state changes and this requires a notification on its own as we figured out) and plumb that HW engine to the IOMMU side, somewhere in the AMD IOMMU driver. Hard to imagine KVM learning about IOMMU.

> My draft for cut is here:
> 
> https://github.com/jgunthorpe/linux/commits/iommu_pt_all/
> iommupt: Add cut_mapping op

Thanks!

-- 
Alexey

