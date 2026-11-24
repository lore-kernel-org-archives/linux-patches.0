Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.22
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795480833;
	b=IIWdSa2pMQVVdh+uaJ7bBWqoZbfbxcF33WDtN6Ty/4uJvmH/yId3Ms1veMumiacdCS6S
	 sucNuQ7NNI+CkYSHpHoDCWGOtBxRGJ4suwfEi/aKilWIDzROsBfpv2lxcrc2AVlOJK+wL
	 m/5h+NZ9xdnQ2t0tq/zchROa/oViphYREhQxcvH5b2hgeuHFAneRI20y4u9pe1++MqJoC
	 KIG4QV4QTc4HRA/YCvQ7ver6d9gzGBeKtvXFd2IJTAzTGLr9mTQb753XKVkO62BSE2TD4
	 6ky97EeICpmZSEYznXa0CwwCqtMWjd+k0JE3yfkP43m7MkPQAY9bworQYVwZEr1v55A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795480833;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=3ICQWh5B5bLQ18fouiEV7EH48XJS5Cy6rqnVw2pkUVs=;
	b=fU86GayvvHjARm9mgzrOUEuRZi3n3mIrill/h1GIvytnJgMe/jouyEArwaLQ6umRT/LS
	 gfCaBmwBDqpXMH9uxFXXibKXeBL++flu2y5v11rulnivN4/Qej5CBXtFGp4g6fXwwXE+z
	 EmOFWtcdo+JBw8laW3WgQK5lLPYjx9tqi9JGJaH9rQA44Q9H6lgcC7HjdKGBqXksOpRLf
	 DLiSxWEd0umpDCy+FMAOc8bCbW+UWeAUSzZS8SpHPcWNGULeowbZeNIuQWPSvRUTYERUy
	 CXnX9z0EDUn64xReVM9tUaOvZrGn/nrOGdpkrU/p79u4tREejr+hOafif8ss9tbRTXw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=yzdLBwd8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.22
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012022.outbound.protection.outlook.com [52.101.48.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3A2606A321;
	Tue, 24 Nov 2026 00:40:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B3A2606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=yzdLBwd8
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YI3i5YHzZ7Zav2Lmd1yJur2qRo1Qmcl5YIOI3PXwyvFl1zr/8rzUxdA2ukLS+uYViUELWlxtpG9po9QS6Ccv0qr9kLR2EfmSW9RQDXV+26K9ozXlVm0LKFRawF1zra5YWt2Uj5SpUDOg/mPVNtX4StVXed86ihh+EFgQMlmIxPl6GwFQPzMh8TmRlnacMJhCGxy6RxGr23qSbFvLw6RPb7rFcCw50gsDWCQEjASzig9kRmxSu7IXLjauG5gChljNDdaIxtVNPmABrrdyTOcBTfAzw11OvMO+3XRrm5I8W4whAuZcxYEfcFnfZ2JxPwj6HJZJsQHj6Wi5cjjJmGs7Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3ICQWh5B5bLQ18fouiEV7EH48XJS5Cy6rqnVw2pkUVs=;
 b=ZamMxdEbKiVMDZ2FLrKKXhli1iYE3UVwsEXUwyaKqXN33IlPpQdty336nFVj2Ze2LTrtj0RFxmDVJzhHG1Eo50QxiqT/wfFs7l/B0fZylXoTxxyINgU53F6OJV9t1se2KVmb8YZg0ZKVXltdgvh7CTpYHa15H3VKyUxJrgNulIPH2dEF8Ec81kbeFjtwxm69x8Gt6xItLyKS7IFd+nGKK5EC2oxixBSs3MzQk43Q1QOsioTSxVrSCVnluDgv+Rzcj4DhM4EWwBlUIbEzg/UuDV20kxkfr++x19VQdyVxM9BFjwObnYQNH1oq/dcKRzbhJcoxsgCqH0nYGgdhN+BYjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ICQWh5B5bLQ18fouiEV7EH48XJS5Cy6rqnVw2pkUVs=;
 b=yzdLBwd8QGOGWzPrl+EPPbf6R1ugaUbRiXpyGJlIeCuMSNg37OQIh67NzDimb0sgfxKiyittqJMiq+VUQOSxHm+9DT770wXCN0eicgMYhvJy+x4o5vJf5cGpyAobT4stvpHtcVCV7RUE0WyY+lL2X6Y7QpdNORW/i/Tpo1tSNXw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 (2603:10b6:806:4db::10) by DM4PR12MB9069.namprd12.prod.outlook.com
 (2603:10b6:8:b8::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 00:40:26 +0000
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3]) by SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3%6]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 00:40:26 +0000
Message-ID: <9f92f7ed-5198-45aa-9cef-515ccbf98398@amd.com>
Date: Tue, 24 Nov 2026 11:40:16 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 02/10] coco: tsm: Register the TSM class before device
 drivers
To: Jason Gunthorpe <jgg@ziepe.ca>,
 "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 Xu Yilun <yilun.xu@linux.intel.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Steven Price
 <steven.price@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Lukas Wunner <lukas@wunner.de>, Ashish Kalra <ashish.kalra@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, driver-core@lists.linux.dev,
 linux-pci@vger.kernel.org, kvm@vger.kernel.org, patches@lists.linux.dev
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-3-aneesh.kumar@kernel.org>
 <20261123152903.GG179082@ziepe.ca>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20261123152903.GG179082@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P282CA0028.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:202::14) To SA1PR12MB999228.namprd12.prod.outlook.com
 (2603:10b6:806:4db::10)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR12MB999228:EE_|DM4PR12MB9069:EE_
X-MS-Office365-Filtering-Correlation-Id: 4729cdf4-27d7-4109-463e-08df49c3885b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|18002099003|22082099003|261009223027099003|261022105027099003|261026140227099003|261022075727099003|261026121527099003|261028144727099003|10067099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	shjVWaZGU+SOSVxaZPAya69bIqlqh0yc3gvOEmDYbUKv5zxhpjm1w4THQDxv6qA8jpLWtuWynt2kVp8RklHj3+vYs9YAQixZCRnj5kktarEsgaUY75aeNfgi2gKf/AbahtXk767hLI0OLooLGK5AwVLnMwLJ3eeLTPk6K97jYjnDkaW3ogV97FSu1veDbVfNCzsXi0qHiLD2OmF9dOD/wy3QE6UYvA1zhZKohJlYFMgnXhgrzgwFobj25N+CKE4JXolD7ffPN5nqFO26QzOKeTtlWUW3uPxdfswLX5gUbtJWz7DbmpgGJ4yMSN8ErSl+Wcp6y+RYwkNGc6K2WuIbZ8w6FU082wbePxXnH/7FNyBIVsyZ4vqvvYsqOYuzxd+izOlMFvhhRymO1U+B0C2EdbzgCPScewjO4Z+661qMV1etBDIeFKTsBLHpLthbsiJyvMxRp/8LzuSySqZ7UePwmf5wKk+D41iLrYExcxw+UYUw7558O16jrGcJ6DHVDu32tYuAYk4zhkTTofcCvK5IjEGtZisxi7Oiar9Nm3R4kngO22c0Tj35zcw9Nx0hQfbZkVZ8Ynqu/BQW4ZRKacGWwWw5AShxb06Yr0xwYUn/Hg6IIgqDlPcZ//MhowLqWRvWEyxSfEknwDRLjoS2lGkb9v+6dGPOtCAkX0kgCGIZmvw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB999228.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(18002099003)(22082099003)(261009223027099003)(261022105027099003)(261026140227099003)(261022075727099003)(261026121527099003)(261028144727099003)(10067099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eXEzcHY5RWh4VXF2Tlc0TEFmUWJxMlhBVTRYTWk0UVpHeTVDbXlaa3ZlcklV?=
 =?utf-8?B?U3c3aEZVLytDWDhianprZWc2UU8zRXpJak9OY3VJdWM4Z2ZjcU9ReDBoTlJ4?=
 =?utf-8?B?Z2dUcDNYclFpN2pJRjJYUytvRkQ2ZStrL2ZLOVNpTUk2d003ci9jdm8yRlZH?=
 =?utf-8?B?ZWtKRGU5dDF5cU4rN1VVT1BsRFVvbDd3OWxDUTUwQlhIcVJYM1ZCb0VXeXFh?=
 =?utf-8?B?eHY1TXcvbDVtN3JZalVCSEg0OHF5N1NvWUFHMGI0NFRsdGNhTVZVdS9ZWE8r?=
 =?utf-8?B?L1JwejRSamlSQW5PVC9vdVJRb2RxOWgweFJjb1ZUYkI2a3FNckVBUmI3azV0?=
 =?utf-8?B?Yk5YZm9Xd3BBSXM2RzVYRmJqQy9tdnhiYUFOcmdibEZUOGtBdkNFRTRRRnNX?=
 =?utf-8?B?UlBjSFVYZ0J0VEVndjhzS2hjMU1iQzdXbDBqRjRnTG4yV05ZSkNVUjF3VzBO?=
 =?utf-8?B?RkRwYlNSRFRvVk9ySDFTOUM0RUJ6VGtaYzY2ZTVrNVAxYW9GM0FNQmFqR0Rl?=
 =?utf-8?B?bktPVEFkSVFydTVZbVhnUlBmMGVwdnVheHl0aDJnUEV1bHp3ZGZWV0pRdkJ2?=
 =?utf-8?B?NEVuYURDN01jTlpUdHJNa0ExWkYrcHdHUVNHSEJzVFlJbjJ0RVhmSE1vTXJl?=
 =?utf-8?B?UFh5cm9VdDlZNnpjUk9VYVRhKzlDZE9KY0NyOCs4a0EvcktPY2l0SkdQTU4y?=
 =?utf-8?B?TnJMOE0wU3BQZDdSZmo0Y0IzSE9LRGplQk42WEZteXpSV01qS0Z5RXFKaTBr?=
 =?utf-8?B?SWovRGpPdzc2dlRLU3pPUURJcnRBdEVaWWdhRms2dVJSWSszSVBEMWNTK1BN?=
 =?utf-8?B?dWVLWU9qQ0VCUFdVeGpPMkFCWHZ1RlMxQ0pmWmlBemRrdzl5RS9GcWdDeU1B?=
 =?utf-8?B?R2NzeS90MUhWWHFvU2JuTjUrSHBjMnRTZTB4RzQvMWZ5SmJGVzNkenhVSjB4?=
 =?utf-8?B?K1NtenQyLzdscXd2dGN2YmYzWkVyWlUwdmZSUHUybEczM0llNmtiNXpJdndP?=
 =?utf-8?B?MTNZL2RGYjNrWHRhZmJJaldDTzV4RUJsV1JJeGlhb084Mms3aHZXMjNPTVhN?=
 =?utf-8?B?YXpsejcxTWoxTldUMFlFdnpxallMaXF4YXQzNnlXY0orQjJYVU5OcWZmWXJa?=
 =?utf-8?B?RU0yT3lvRFlCSUpWQ0pQc21zMWRyTXpjMVo3R1N4blZmZFBCcmV0OUxIemdQ?=
 =?utf-8?B?UTVNQUgweC9UVGpoSU5JTlBVOG95czljemRaZ0JVY3J2RGRlSW9HakF6M2Qy?=
 =?utf-8?B?d2EzVGQrTk8zUVMvSEpZeTNEZ2hCSDdhZ0FtdnpCTWppZUx0L1pDWnhQSW9R?=
 =?utf-8?B?ellveXozYWQrQ2JTVDlkL3U0RVhiYXFjbkNGWkFqeWxQMGl6Y3MyVEE4V0dj?=
 =?utf-8?B?ek5jQnl1VjhFNjg4MlFzZnEzRVVjS3RPWEhoT2cyeENJcFc0a2RLK1l3K1lS?=
 =?utf-8?B?czdvUmExemQ3ZFY4ejhJYklsWDdhbFEvdFI4ZVdTUW1yc295UnpOR0J0OTdY?=
 =?utf-8?B?Wk51eDZ1TXR1VVJ2d01xZWhhT3lmaGVaaTZBdlE3dDVpTzVNNjFrMmt6aVBh?=
 =?utf-8?B?QnhLTWVQOEpwYnJLSTNmdTBxNlBSQkFITjl1aHpsa2Q3MjZBVWwzbkthUmph?=
 =?utf-8?B?MVlMb2lqRXFqaWIxVUo1aXRWbGc1bnVqWFRZTlA2bGQzeVJQdmNJYTJlOURk?=
 =?utf-8?B?N1FVcmVQVTVsQnJFNHZocDJ2RE5BTUwyQS81Smk1WThPNnV3c0ZUa1hHemNs?=
 =?utf-8?B?T1VUOXREdHI1ZGxvYmZDUUdWSmVFbEFGM2FaaDVxa3JQMjMyUnI0T1UzS21U?=
 =?utf-8?B?RUpnK3pnd3dUUUthcnF6cUdqb1pHQjN2TlhZMUplQllIMVM3Tzd1YmovYnFP?=
 =?utf-8?B?Uitjd1pVY05QcGY4SFpYcmdpR21YMXZvdXkxdWppb1F4SXBnNFJhNUk0TEVy?=
 =?utf-8?B?a1pSY1Rwb2tTaTYwRE9ZTmM4RWpHcGxiY2M3bWw3a3Y1c2Y3bEg3eGpyU0Jl?=
 =?utf-8?B?OU14V2hGbTd1OHppdXRsbFVDeW1QSlhhbmFEK0VjUFpmZmRRNEFYMk5kazFo?=
 =?utf-8?B?WWhVSEtkaDZrOG9VQUdDbEg4NnBkZnp2MFVyWXVPSXJ4VWxDRFlZSnhDMjRD?=
 =?utf-8?B?RnFlc05MZkZ4UkFHZW5HeHMvc0J5cEJvb3dKZWdhY1krNFAvR0hkTjBGZ283?=
 =?utf-8?B?cDI2YnRRbGQ3SGR5KzBmZWVpMXVyc3MyVG5mZFpjZFBVS1RvSDl2VDNBZEdN?=
 =?utf-8?B?bzdTejEyMHNYUGQzK0c0aDlYdGhmOHNydDAxQVBZR3ZVQzlxQ1hzSWZ0TEJ4?=
 =?utf-8?Q?KciAqHMw6HXD7dpA5H?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4729cdf4-27d7-4109-463e-08df49c3885b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB999228.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 00:40:26.7506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: quX57Cg8G4/pKplcHY3tWfRPMntBt2dXU+bAcHzb2yLsdgNzXpOMzVP7FISiD/a7w+ETWQnBssuG7TURNfebaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB9069

On 24/11/26 02:29, Jason Gunthorpe wrote:
> On Mon, Nov 23, 2026 at 02:03:29PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> Register the built-in TSM class with subsys_initcall() so it exists
>> before a platform TSM driver probes, independently of object link order.
>> CONFIG_TSM is boolean; remove the unused module exit path.
> 
> Why isn't it modular? This is going to force alot of stuff to be
> non-modular.

The TSM core registers a class. The platform TSM drivers register TSM devices of that class. If a platform module loads before the TSM code - the class is not registered yet so it fails. We could either teach modprobe or have dependencies in the module or do this:

https://github.com/AMDESE/linux-kvm/commit/9eaa9c95824e69d0f852c20d7aa33a8ccb5af2ce

or just make it built-in which it's been for ages. I did try making it a module when I started but lost that battle. It did not do much but I guess I'll revisit this because of ctlv. Thanks,



> 
> Jason

-- 
Alexey

