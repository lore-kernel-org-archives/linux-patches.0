Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101A51420A8
	for <patches@lists.linux.dev>; Fri, 13 Dec 2024 10:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734084603; cv=fail; b=DR/ZHtLVZYrkUtRFA3Di7JpnXWojF5lBkDtaluQXLbc5rEw0ePKI8UNr7WFKczri83hEyNiPPSF4UGLDgs7K1CV1h4FGvUpW6WbnHuiqWLp+XaTScmJFkVs2GqyKCxFRf+n9tAkKhqdNLKbOqJM/Q9ruX1HwDs0q69GNFVt0Xc4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734084603; c=relaxed/simple;
	bh=pzUmEbFvgt9SgLQa0Kep8CcF9qOqvOznPjg9nXSvK9k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CU+UQkmTtmzn5Y3/C8cJLY1wTD0Vd0QojhnGP2uWJympTh9GNo31IBY/yLTNM1zEAKo1qRpZy3UfWvWd1lisXjkh3Cp3A5TPzfM3Ac6LLOQNFpkdZRmfWGmtUKFBD0hxVM4tiBLI2HVuK1oXPfF6vI6y0jAd88MuIjN8VR78U8M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sZcGv3RT; arc=fail smtp.client-ip=40.107.220.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sZcGv3RT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rh7941EaXY3zv2RuqOvEHAa8TeH2jbvGXLIaR+hAJNo6M6QXaG6Rz9tvY/3x7gpgBfXH0DJ0p1M1QU2OTZnGqFxmKwxFfmgxwnAIeHEQYSILj5NspAIrgRAsL+uCH5zvhGeErZIkNoauKjFNdmaL5UpjzGkGTg+Qou/axMrpp7Xi8XAShdljKzH06f1MPuH8QSSQl0yn/X89TeQAyUj7w2KgAgafCjO8b4yPzC3QUtay+wjRoh+9jHs+OVfNNqVTd5DLEbVzQSXf1DIypB39ee2A3YduyGsJv4mzXyLwLN3tXYmvaZ185ykIG5h5IYq3Ug0/K1+ervw+vEfth2pvYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EmNBV+aO7lnNXOhWND5iUeHkYkighzZQhH1OGbaIotU=;
 b=g9pzOIfEf6D0u12TqI3gbhCDpzag4hVREIkzCI9V7V8Cg1ChRxAXa3VIGujez4cEemBa7ohdg8u0sB1qzN15snxoWzUTtXN6/8c3tN29f9mBVMze8oef7YsVEYH3Gt2InZZdqR+iO4LpNIUgxb25OvKuigpXOxYBCgQCQshoY7VmEFl940nIPpD6GmJPnIpJ15Jo9qq086T7MBdgBkrP0NIoGLPECs9thqwOVQ+/IixQuoyHryGxjk4wVssR54FbsIRrNcOh2Gu+3rXi3ift9ui/Vwq9fylzzJBuVpmxRU1gy2uzBn0qxzlAV/CChQ2u+6cSLY+bwhGpDp5lUJ+Xzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EmNBV+aO7lnNXOhWND5iUeHkYkighzZQhH1OGbaIotU=;
 b=sZcGv3RTMTHIR+7W7I+sna98FpeUiEMP2tK6EmLV9XsaGB3KenuCgT9/J+nsgd13H6zWsZorqK3gZKTKavzK+PCoy1jxAuKHOMf+ODO9qtE8bzah18Nc2jQO20HKIhAlZ8Ome0jRpZCM73KHz50wIH0qIomPtkz5cYS/vl+a4KcME206XM+bXsKhp3ewd/vcSj0gq2W8TGk3z47TdyfrhM+AvJ9sNb+IHmQWLc6nt1ViENfNzrvH1y3rr6fo32y/rJXVeBkCutzEpp6vq1Sqe71go6Vi0QNXROgJqQxAArdKyZu1J4l5Z6dNS/OlEIaS6eCiP5E/sIFEfqmhldzRmw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by PH7PR12MB7259.namprd12.prod.outlook.com (2603:10b6:510:207::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.14; Fri, 13 Dec
 2024 10:09:59 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%2]) with mapi id 15.20.8230.016; Fri, 13 Dec 2024
 10:09:59 +0000
Message-ID: <8e388173-5e39-4b7f-be7c-f471c9639d3b@nvidia.com>
Date: Fri, 13 Dec 2024 10:09:52 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/356] 6.6.66-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241212144244.601729511@linuxfoundation.org>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0191.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::35) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|PH7PR12MB7259:EE_
X-MS-Office365-Filtering-Correlation-Id: 47802db6-5dc8-400c-998a-08dd1b5e4d10
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?anpHYWt2d3hsbUQxVDc1NEtyQUlVcUViTElSVXZ0Z2dQK0lnSEZFNmtlcVlO?=
 =?utf-8?B?dDlGRDVGV2UzVGdpeTF1bFFMRFg4eklmSUl6dlZpSFNFc2VSRkd1aVFiSk9Z?=
 =?utf-8?B?aWMzYW4vcDB5VVQ0N1kzSGRzTThTalNUa21KdnczbG05Vk5EUTJ2R0M5eFZ4?=
 =?utf-8?B?MjlhODI3UVZQdnB6YzJ3WFV2M0t5dnhzZGZXTWVja0xpVXNLSjBXb0VGcXM0?=
 =?utf-8?B?RFI1Ris2emF6UURJckVVdnVDTXhDdTZ6ZUtuMzNZRUdyZG1HODFTWnMzaHoz?=
 =?utf-8?B?L2Z5Rnh1M1VlNHphWnozMTR1Y1RueVUwMHVnR3BOUGxQRTNWN04wQ1JtOUlI?=
 =?utf-8?B?RnV4aGJmczhhZmVrMVhWU1hpZW1ZWU9ybFZ2QmlSaVlTanRQN2dWMGR3SmVt?=
 =?utf-8?B?QzM2R0pQOGpQUzF6eXFVc1ZJVVljelhydmptVHp6cnFNbWk3SzNnUU9Gcnk4?=
 =?utf-8?B?ZG5SOGpmY1hHTnFocmN6bURiMzY3dTFLdDJlOGRhWnJMSG53ZlVMR21TWmln?=
 =?utf-8?B?VGtDdmVkbExJZkNLOVhidnpiaEY4WTJvSStVUnhoaWJIV0MzdGhMZStrcHJW?=
 =?utf-8?B?RWFZdHFTQ202RVZLTTNQNys2aHk5bXlaQUE4UWV2dzFRTjBvQkYzTmppQzVo?=
 =?utf-8?B?d1FiSzF5WmpuUEtoUzRxcTBCcGdwaTF1bGJWL1NMYTFEaTNXeW45bkgxSUJ3?=
 =?utf-8?B?eXBMOUdYUWRxNVdleFJYYTc2MWhxb0F1dHNpanpZbkxUYUI1dElsVDhnZlFH?=
 =?utf-8?B?NkNOcUF6UTRmYlRlTzlyOGxjMUxEbE1LQVREV1RpQ1FDQTU4TkNxN0VCUHB1?=
 =?utf-8?B?MVErYmNpenNwdmVkV2NTN2hXRHhLRlFkMlNXQU1mT0VvV000ZHlGSXBKQTg5?=
 =?utf-8?B?aE5EdzdCNTQ1WUNZbkw4RFBMMVNuSVBVL29aOUpJTloxR08vVDdTN2k5SDRN?=
 =?utf-8?B?MDJlZjdqMFlPaGFwOVhZOFB1MnB4VW5HTUZMcHJHb3RjbVFPSyt2K1lXNnRL?=
 =?utf-8?B?V3EwalBjTjZsTkRYdGczT1VhaUQvOHp1UHpJZEhGZlhMdkY1bTdTMDNRaEdP?=
 =?utf-8?B?SURsU3IzK0wwT1lVMzIwQlJzYm5DQXMvTUFYRDM5cW1UV3IvdEFabXh3Y3Bz?=
 =?utf-8?B?b0VrR0tpYS9DcThVUkVDcmZNcy9DZm1pUDNvUTJ2UVRuc2ZQQWVTcUhrdEkz?=
 =?utf-8?B?ei9SN3BtNDBySG1mM2hYemlrclo3NXoydnMvNXluMklGOFZEWFFOODJ3K09R?=
 =?utf-8?B?VFdnWE4xa1BrQ1BqbVdrUEJYQzZ2V09VNGlHNjRJdEZ1OFZXa09PcThpMHZJ?=
 =?utf-8?B?SVpsdUxPRFlQaFVyWE95THAyWXBrdWFLd0tyYzZwM3JueVZobGdNcjgxSTZV?=
 =?utf-8?B?ZlBUOGw3NitLd2dwYy9xeDV6bHVJSXgzOFZndnk2Zm9oT2pSbHJkUW04dlda?=
 =?utf-8?B?NUZvSkdBWE1oYUxlTG5IYVJld1BOM1NqZEdhbjRBZXA2N1l1TUtsSHE3dnZq?=
 =?utf-8?B?T0N4ckdydXAvZG8rOGZSSTBYTlM0WVJEeldMZWhCWjV5Tk14dHkvdzJCcFZ6?=
 =?utf-8?B?WHBPR0d4eTQ4MHRiVDA5MVhWWlZNSmxvb0ZZNHdiOFUrRFN1U3FPOU5BWTRV?=
 =?utf-8?B?N0JhbElBT09LQmZFTVBjU3BadjNURzdrU2NHN1JhVk81TS8wRUhTdldCVTNG?=
 =?utf-8?B?Tm1kdjNJQW1yY3NIOE5MQkNXWDdKQ1VpZXdYaUc3RXcxd2F6OWU4REFTdlBJ?=
 =?utf-8?B?Tm0xS09wbUVGSUZzdUFFaktqZUUzYmNURklmUTcxWmM2M1JqRUF2T0NBY3VW?=
 =?utf-8?Q?npPH4hHnh991shGqamZ2LYAP5p7oDOwSa1mKk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZVZLa3J5T2p0UmZqY1N1Y2s2SGhjbmd1ZTRyMDNwR2FtTUxGVWVuaTRUSllj?=
 =?utf-8?B?b0IydHVCNmpBMjdxb2ZoRjVkUVpOaUpnZ0hzVHVoczROeXNGWlNvSk1MMGlN?=
 =?utf-8?B?Yk9tMThSbGNqaW9BWkZOSWFleWdCSzBSRnhSQUlyWk1sV3R1dlYwSVkzL2Vp?=
 =?utf-8?B?b2lodmV5N0QrMnFuTmVNQUlmcXVpSVY3K3V1NzdLZHpWcm4wVVVCWmZHN2pH?=
 =?utf-8?B?dUxTdXhYekhnYjR1QW5xT2dQZCtHYVYwem1ESm5iUWlObWNVRjduc0tWR1Rl?=
 =?utf-8?B?Mi9IWG0zNDlhelJESVprZXVVQlZaZDhYU3lEYUlGdmlZdjlRN2dqMTVkUkJO?=
 =?utf-8?B?bExQZXU0eWlXa1YrczhKdVMxallpcjhNbExtb3dsWDF6NmtWVlh2REk3ZjVT?=
 =?utf-8?B?akUwRHJld3BBZFo3MitpMjJnSEdKVVB1S3FZMzI1VEZDV2MzMFJOTWg2bllZ?=
 =?utf-8?B?TXgvRW54V0xSa3NlMUJoQzE3R2ZmNjY3bDd0NWdOYkRxYkNqWGZzbzlPcGs1?=
 =?utf-8?B?elhQemxsS29iQ0xzc0p4MVFKRWJTMkh0S2o1SEgvUDAwTHpseWdZVHVqWURI?=
 =?utf-8?B?Vm9GWG1OTWs1RGpDZGJvMW5LSkN1N0owdFQwcUZveHdSTGhvRTB5QVRvKzRr?=
 =?utf-8?B?TFJPRGZ6eGUveVRuMDNEMXk1UVhnNmpMdk8rN2ROUTVkMm5pVUlKU2I2UFVF?=
 =?utf-8?B?dzhKaWp1Q1ZYV21DK01VTFpWLzB6SzJvdXUwSk9CUUdSZzFkWnhiTlpXUW9R?=
 =?utf-8?B?RFV5TzBLVTV6cEcvZ1NFQ2FQNG9XbVRuVG1SUTlVaENTSWdtK0phMjlFMHY2?=
 =?utf-8?B?NmpOSEw2dm9PdkNwN0MxdzdUM1A0UGR4WkVOdUtIdGVVUHMxYWpGd0NUUkFa?=
 =?utf-8?B?Nm5SSmJCUlJ3NXBPd3pvL0dRc0NOZ2x0YVl1M2l5blkrOFVOMEkrMDVLV3JP?=
 =?utf-8?B?YnV4em81amNzZ1FjMFFmLys3eHJZdkRFanNDMDZQeTMyODZMS0ZlQ09RejBC?=
 =?utf-8?B?aFE3ZzMxeG9IOEVxMWIxd2F6Wjk3dzg0SDZZN2VpdWg5c29NQ2lNcVlmSFdS?=
 =?utf-8?B?QmgyY0s2ZzZyNU5TYnZwR3hGNnQrWWMyY3RHWkVSaTRMTmdlOXZNVEFORlZt?=
 =?utf-8?B?cnF6ZVk4S0Z3TUN1RE1OZjNYUHVaZ0lGb1VjcEhMaCtRS0NnTEdoRU91cXhN?=
 =?utf-8?B?ejlkWUozU0k3ajUwSW5HM29YdDQxRGNmQ3BCMkROc2pkckNKaXJFbVMzZStD?=
 =?utf-8?B?Nkk4THg5OHUrdGNlbDZxWVhEY0R3TWYzdmpJREl1dHozUnppWXQvV3FXQkt0?=
 =?utf-8?B?Q1R6NlBWbURGdVZMRjJ0MjVSMjYrN2VLbzRKdThpdFU4aTc3bzZpQ2NIMHVp?=
 =?utf-8?B?NGEvTkRDOTduR0ZQcW1CY2RVcG9ZK05yM1VWQ2JQcnBtWU5VZVcvNDNQVjlZ?=
 =?utf-8?B?djczcFVRZGRMamhqcVFScldxWWJiUEZ0ak1qZEp1S2IzU1gwMFVYcTh1cmx5?=
 =?utf-8?B?TjM1Y0hQYytYM2NMN3NobzNScU9sSklGcDE5Y2U2ZnlBUzR6K1Bjd3VBQk9X?=
 =?utf-8?B?QUpZT3NreG1QOU52czBkODVyNUZReDBrMHFNRjZOUFliYVdpZ1duWU16UmV1?=
 =?utf-8?B?OEttYkVRQ1VqekRtclVZMWVNamRPSHNhMUkzKytWY2JxVFluSVp5ZUFvemla?=
 =?utf-8?B?c3Jvc1UxcDN3K3JvMTlBMVVTTWM1K2JvYi8vMWUxSVlDYjhFK0M5ZWwrZ2I2?=
 =?utf-8?B?bDFRSGt2Wi9oTDZZY1h3MGFHc3pXVWhIZE4zcXdRMVdhbTkvUVBtb291ZE96?=
 =?utf-8?B?TjFpa1VzREpITTFnVnZiVThsMlNIK2psbFRkcGFiODhNRmsrMDQ4KzBQclUr?=
 =?utf-8?B?cDN5MzFOaFJNZVk0RGRVaHIrRlZFTnFSTFRielh2cmsveU8rM0VZRFNITlVn?=
 =?utf-8?B?bldTOWIzWVJvclRpajZQQ3VRSEhGTXZaSDZtejBiRjJtcmhWMXoyRnc4eEhW?=
 =?utf-8?B?WXkxblViK0VCcFYvR0IxY2hTcU56dXo0dnh3QlQ2ZFJrUTZUYUVyaUtDTmU4?=
 =?utf-8?B?UmNDR0MrTXdLTzNOSmxBNU81UlU4NXVwZTVZMEYxNHp3bWVHenpuM1FxdnRu?=
 =?utf-8?B?ZVc0R2JNNnFKRzVLbjNzMFArckJwQmw2MFV5Nm44S2JaczZQbXp5NkNmZEZF?=
 =?utf-8?Q?jtiivWfoxcx0h6g53fGL1hTPkT4WrL7ri9paVahG1dOT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47802db6-5dc8-400c-998a-08dd1b5e4d10
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2024 10:09:59.2572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mLkVfNs/SaXHoGkTS9Y77sjXvKtIbzqX6U7TO9z1YKjE7DsGr0V6rF1XXYI6O/K0ABoXrZ6xqTfeVfCNDDqmwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7259


On 12/12/2024 14:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.66 release.
> There are 356 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.66-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


No new regressions for Tegra ...

Test results for stable-v6.6:
     10 builds:	10 pass, 0 fail
     26 boots:	26 pass, 0 fail
     116 tests:	115 pass, 1 fail

Linux version:	6.6.66-rc1-gae86bb742fa8
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                 tegra20-ventana, tegra210-p2371-2180,
                 tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra186-p2771-0000: pm-system-suspend.sh


Tegra186 tests are failing randomly but there is a fix now in the 
mainline ...

4c49f38e20a5 ("net: stmmac: fix TSO DMA API usage causing oops")

Let me know if you want me to send a separate request to include in this 
in stable.

Otherwise ...

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks
Jon

-- 
nvpublic

