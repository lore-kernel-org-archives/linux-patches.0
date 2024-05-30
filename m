Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082CE14AD3B
	for <patches@lists.linux.dev>; Thu, 30 May 2024 12:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717071381; cv=fail; b=stc5r5ND6nklv2gO/b6a1AqpOUI10jJGuJ2SNaR46iJgDhi2dmsr3vM53oQNaLW5p1g9URW8FiyRJLjihxmGiFLNz0cq5SDfbno86CSSQsBFe/tS2VJVn1Ud7DObFOpBRbwBdrUrMGf9cAPNsWCWm0ezLyuNVLtGIZMd13uUOFM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717071381; c=relaxed/simple;
	bh=3mPPMOVWzkQkZ1/Z61ODUMn7MdiEKmIg4WGiCNPdX6E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mVJWvrYQgVJ8w50vNPrIHxmlX2HKmahYWWd1wpAfOpf5KJidEObtc8FixUgeKb06Rnp8qt90oWXXudEaLZdLc0b17/9IslwlZ7l8cuOONBcav17jFv1diOFV1PSPj/0o5rjswMe2xBFJer73RpateDpLsRfW1ZKykW2f7f46yU4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Xjsqrl1V; arc=fail smtp.client-ip=40.107.94.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Xjsqrl1V"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dZtpwJmG+SAD1obJkxVh3O65CEhS8GUwG5TjZWjPzHi2OCxw/IHsJhqYwSRzj8k9UIXRIiPx+bIJX43r68UD5pOdOgnENGwwznLTyNX1302Bg273fl+nKIN05nVC3ki3px3XF5BwLfponjyvoOmblq4XbtJ2GVGkp8Go5oCHihEWdrCKdX2qi/fSR3MECdarckH55uPUaMPOq8RYAft5wZHT/slDGVTG2CxC2Qthh1LSMylIgB7wSKLgk8keFVqqc99Z7GmP4jxbrH9juV+wqKHU7UGk2+tcuFwYWeT5xENRx0DSh5aXpszCt6lg5QxJZQPmqUThVc96uF44g3B0eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MRqpnDNBSciK4aHhKY9/lbqdOrosQtKDpOyTbhOrKJU=;
 b=j1pejDR13toX2TX3Eoy/v4DytBoAZuQlEj35z0M4ohJbAk77UgvUN75eXoCGkZx9iQ3MuipYgCCuHHYE1VGKuLBa8lqjfI/0M2oO0OZocx3q6cBE+YzMmscG7tQjOcUOn0xegb0MgGiKT50Uet09POJUD14L4E22ki98Ep11CxN3TVkuiolvYvVvFF8gm9j+usJyQ+jCeEv95KQ4gIEzX+dCDtnC6RrLmW+15Sa/zY57qMeXk6U7+hIC2PoLYvBUDJZrkfpJd3XIJJfo3czVik66IpnrgaD/CEoUPVJ1AV5BQozycxC3rccXbn8qbv70N4op4QFEJvdknSQ7dc7UVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MRqpnDNBSciK4aHhKY9/lbqdOrosQtKDpOyTbhOrKJU=;
 b=Xjsqrl1V6D1w5CVMajc7KVLzaNgWX4+ZPl6VTwgK62L8eSro4RBfqI8U5dh3k0cModMOl8QUGw+zdguvG9kEFVafiH4AsByKaespU8NqnDaJrF2+8sMm9Fz32tC2cCfqJEoWK4H8XPm1u9bfpHBZIfPE+EWCn4uGU2RJ+7dvXt4FOO2iAtYsoWP1dMDLaZ0G1RYGzU7iFu5/5uWaZbo7efz1sBbyRlk7MIOwzDU5vTBQYsKfOEJLwB1fFsj3pt+RywLJXrzKdsRVAxgwNhPQbbyRaqagWSq94SlsgEzuAMhGh3MD9mXrwmV5dVJ2bZyHLalE1s34CoACM6rnFTdWsw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 SA1PR12MB8742.namprd12.prod.outlook.com (2603:10b6:806:373::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.22; Thu, 30 May 2024 12:16:15 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ae68:3461:c09b:e6e3]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ae68:3461:c09b:e6e3%5]) with mapi id 15.20.7587.035; Thu, 30 May 2024
 12:16:15 +0000
Message-ID: <b2dc17ff-faa6-4ada-a807-ce2a64c9fa29@nvidia.com>
Date: Thu, 30 May 2024 13:11:47 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/23] 5.15.160-rc1 review
To: NeilBrown <neilb@suse.de>
Cc: Chuck Lever III <chuck.lever@oracle.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Chris Packham <Chris.Packham@alliedtelesis.co.nz>,
 linux-stable <stable@vger.kernel.org>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Andrew Morton <akpm@linux-foundation.org>, Guenter Roeck
 <linux@roeck-us.net>, "shuah@kernel.org" <shuah@kernel.org>,
 "patches@kernelci.org" <patches@kernelci.org>,
 "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
 "pavel@denx.de" <pavel@denx.de>, "f.fainelli@gmail.com"
 <f.fainelli@gmail.com>,
 "sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>,
 "srw@sladewatkins.net" <srw@sladewatkins.net>,
 "rwarsow@gmx.de" <rwarsow@gmx.de>, "conor@kernel.org" <conor@kernel.org>,
 "allen.lkml@gmail.com" <allen.lkml@gmail.com>,
 "broonie@kernel.org" <broonie@kernel.org>,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <> <58fa929b-1713-472e-953f-7944be428049@nvidia.com>
 <171701638769.14261.14189708664797323773@noble.neil.brown.name>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <171701638769.14261.14189708664797323773@noble.neil.brown.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0397.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:189::6) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|SA1PR12MB8742:EE_
X-MS-Office365-Filtering-Correlation-Id: 51f92e9d-2bcb-41ef-2290-08dc80a24d8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|7416005|376005|366007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z2VNbWczbTh2M2dKQ0hhNUp6TUlaVEIvVTk3WCtWT2R3OFh2UFNhamlwWitn?=
 =?utf-8?B?QjdqcnhNa2E0RExqOUN2cWV3V2daVzBReHFIampLZjFSMHEvekJvb2NXbklD?=
 =?utf-8?B?dzhodDdFdThDKzI3NU9HT3k2djJaVlpqalRqMlhrNkNtN3ZXalNrbzJMdzEy?=
 =?utf-8?B?Mkx3N0pxUUlmazlyMXpIZ2ZBZzNycGZNVDd6UmFoaDdlemhnUC81TElzdlJ0?=
 =?utf-8?B?aC9BRmFnSitCVk5GNEZRQVZydXpBRXhxWnRwRER2czVvQ1R3eXo4U2VzMTZu?=
 =?utf-8?B?R2pON3hHbXNLL1Zpcy9wd09Yend5ZGNveW9sU2FaaXIyUVFOZ00rMmZRaFR1?=
 =?utf-8?B?b3BBUW9jTG5JMzZVUmovZWVHYVFXRkNuOTl2aldhZFJPNFE0enp1Wjl1U3ZU?=
 =?utf-8?B?WHdPRkhOWWg5UU14Q3hhOUxFSDhYRE5CYzBJRmhsMm84bnhib0tiSEhtcGhp?=
 =?utf-8?B?ZHdnbHdUb1ZMeDVQbjFxR05MU01DSUFsbDRhMEtOVnM1UkFnak5NNTZnK0FO?=
 =?utf-8?B?L0psRDlZZm1RU09SQUNQaURoRitpSmIxZHZKaFBWMVYxNExPVG9Jb1FjU2Y0?=
 =?utf-8?B?ZEhJUkNhODNSV1RxaDlhSjJjdWVnbnk3T0pIRm1VeGFtcERGc0xHVUlnSXkv?=
 =?utf-8?B?cmV4cW4vTnBDYUY3UkNNNldmSVZ0TXlsK0dLdmoxbnd0UDZtOUpURnJNSXZV?=
 =?utf-8?B?ckZqc0pOdTAvaWlJZ2p0eFlXNTRYZ1RPbXMwQjVlallaVDNJaXV5d3drWlRE?=
 =?utf-8?B?cXhwZ3VZYThRaVJXNk1rbjZEYzJlM1pxbTRIWU51ZHg2UDErY3o0UlZZMTVp?=
 =?utf-8?B?TEswYUVyUWNZN09YT3pwOXdMTmtNWG9wNm52UXFxUzRWYm5qanYrTVg1V0xk?=
 =?utf-8?B?blRpZDZ3ZTNPZTk0dGN5S2tQR291dUp3ZkFidXVEbUxtWlJoYTRXZFlkSnhQ?=
 =?utf-8?B?SCtGd3g3TGFPdnU1TXkrdjJIMnB4MlNIa2JlcWlseW5tR3JNZWpKMWZJMXlF?=
 =?utf-8?B?YmdoK3hKU2c0Z2dnR3NWM3J1QmV2VXkzaWU2UmpPQXVJV09YQW1vemI4dDRN?=
 =?utf-8?B?WlBzNHFKSXJWR3pIbVJ6QktmZ3QvZ0R3Sm9KL3FlUEdXam9DY1dwdGhzaGlS?=
 =?utf-8?B?WndRVHpKVUhqd3BvRXRRMFFWVHFKcTQ0dUQ1VVdDZ0NjZlRENDZXZUtkUUFk?=
 =?utf-8?B?aXp1UEtyZlFBOXl5c1ZLd3l3WFhoekxTYkl2YzBDK2oweHpFbEhISUt0OGo1?=
 =?utf-8?B?L2ordzNSSTVKWXNpb2ZnQldhMHZLeDh5akhaSEQvRWczN2NkSlByZFdHYmNy?=
 =?utf-8?B?NjhidWphQjJYSERHRmZmaVRSMEgyOWptWEkwMHRzMVg5MDdHY1pEVEtEQ2R2?=
 =?utf-8?B?Z2JpVDJVQjJab2dRZ2QvRWdqYjNSOWhBSm41TlFrdWYrWGZVYk1GRlVOZUh1?=
 =?utf-8?B?VmR5VklHeFoyYXNlOGR5Zi9aajJoZlZjdkJRYjRVbGxhSmpWQzZmMW1rOGpV?=
 =?utf-8?B?QmkwWWlueXNOQWNLZVNSUE9aV2tCNGM1MTdlNExwZmpEVTNVZGRYVi91MExl?=
 =?utf-8?B?bU0xWkVGaTQwUWdBL1J3SjVPMUw1NmJBU1BFYnFZNDlwSTM4ZHpHbFlwMkpj?=
 =?utf-8?B?SUZaK2xZa09jUUIrdEFHOVgxVHNyditTSmRBbEJidTlRYVVBbjIybDFQMmV5?=
 =?utf-8?B?TEVUanFCYzB2U2JJc2FZeXBzc0tlVnY0VUIrbkZOWTljVmRYMmhpRnV3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UFp2dmV2QlBYQUtFWWZCeStVclRhL1RUejdkK2hiSnlKZ24vN1oyT3MxZit5?=
 =?utf-8?B?cFdIUWN3WG9iL3REaWZ2N1AyTy9JSlhUK1dFa3hyOEhTSFhBcU5UOWw4clR4?=
 =?utf-8?B?M1NJKzc3V0Q2OS9rcnY5MmVQOWFhNElwWkNmNXBIc1BQRUd2dWN1SDhndzBw?=
 =?utf-8?B?N3Z0cmw1MFV2UjBVcE5VWGMzUE5aOWlYcDdMN3p2cmpVSDhzcFVnRE9odU92?=
 =?utf-8?B?RjBOQXVXalRwbjk1bmxiT3cxMGpnM3N3OFMwaVcxV2lOK0FJaFpSZm5LV3RU?=
 =?utf-8?B?V0w3M2IzS2NGSml2UStiaEhUQUNHZi8xckgyZEZZUkxVVFVuKzQzT2Ztd1BC?=
 =?utf-8?B?cFRIc0NDMWh1TkpvRTR1cnBvcmZ5Zk5CSzRYcGFpMndDUG9pcDVRSnE0QzFa?=
 =?utf-8?B?TXF4c2N6eU5zL3FEbXNUTThHL3NIaHgzMUhjdW05cEUzaUhzQ05xUFl2Z0M3?=
 =?utf-8?B?ZDVIVjJuK0tlemppQi9mNnVxMG1zNFdraVB2SzhmZU02RjNvNWFLZi9BSlBB?=
 =?utf-8?B?QUowU3VlZ2hZa09TSWkwNmhvaEwxR0Rib0dHcGFkbzllNE9PUDNjbFcyVFpt?=
 =?utf-8?B?ZzVFKzNBVS9sdFBXMzY5TUtZRXdBRXMzL09CMU1QN3M1dE9WL1FSQXZQZS9a?=
 =?utf-8?B?MDlIQ1YrZmMvcjNad2VzblMrbVlDaG45OTZCbTVtaUtTUHl0c0ZTempWV3N0?=
 =?utf-8?B?SnFneEgzSDc4NmNCelk1OVBJTmdDbUdxNW5CK09EbC9MZW1yWGJsc3VLMlg4?=
 =?utf-8?B?ZSt1L1o4cFkvL1VBQk5KYkQ2L1c1OE9zTUNRbzRuNENDS0JIMzhlMHQvQlc3?=
 =?utf-8?B?VUp4MnoxcDBGY1FTQnV5V2daRFRNVnVzRFpZQkxDK0l0cUhpdXVXbFA1UGJM?=
 =?utf-8?B?Zjl4eG84aU1vcDMwbDc0WVBvUFhrYklndUc4NDFyTElqcTV0d3hISDIrbjFY?=
 =?utf-8?B?NkhmK0tmYVQ0OFFPNE1KSjBVY2RqQmc0b0NHblZIWTJzMCtZYndJMS9DYkRr?=
 =?utf-8?B?TmJTQ2lZMy84ZjlZeXZ3Sko1VVZsY3NjUkYyU0locEE0RndvUE93K0dXeTRk?=
 =?utf-8?B?VTI4anBOREIwQTdjQ1NBZjFCUVBXZ29XaUNWWHhzb1N0SHFCV3doMlFLZWtO?=
 =?utf-8?B?Y1hJU0FBOVdLMlU1Y3d1QU02b0lDL2tCUzZRd0VzQ2FRbUl3NENjQUpXc296?=
 =?utf-8?B?dzAraEcrWUhhamkvalErVHVQWmR0MXFRMDBvQnpFbTMyTDYvaWp2cytzeno4?=
 =?utf-8?B?bWhLd1N5MktKcEJ1akMzODVBc0RDdFQ2elV1MGxleWljRFlIUWFFUXR2V0h4?=
 =?utf-8?B?Zm5DMkwwdk4yQXJBM0Qza25WcnBxeDRPTStiUDFMMXJYK1lTYm1nVm42RElJ?=
 =?utf-8?B?SXNBOWs1Ujl4VVlVR0NLazhCZjBXU1lhOFhQejNhU1dQTmZLaDRpNlFweEVh?=
 =?utf-8?B?bXd6Z3NIMDB4WmJrdmp5MHZqNkJtK292NEhIR2U1UHdwOEVZeDdWcy92Ymtj?=
 =?utf-8?B?VWxybHpMVVpUZjR1Rk1QUlZwK05FRFdET3ZoTHdrNndjNVpNRG5pSEpHbW5E?=
 =?utf-8?B?TU92UWlVRUp2N3hCbnZITWpNZlBoMnRVV1A2QkhaMkNFeStWZjNGa0t4Q3pJ?=
 =?utf-8?B?bW1kSGZDUHpKa3JqNGRHdEl1S2hTRHNxczNvYWIySGhJWGJVWnRCVTJKZEN3?=
 =?utf-8?B?b1V1bEp0Nkk2NkVGZjFJaW1lTEJYZXBsWnhQbURmN0pwVkd1OWNXWXFxQkNT?=
 =?utf-8?B?WGVrUkRWeW9zc3R6blE5MVJVYXdVc21MdTJaeElaQnZCMFkrUFU4SW9WL21o?=
 =?utf-8?B?Yzc3SHhlWjBURjVYd1lrTzVKR3FHeVdIM1ZkQ04wbldzS2kvdmZmVnV3cXlY?=
 =?utf-8?B?UTdLQkNPUCtLOFAzQnN0SXJRRDRJWUNVNEhYV2ZpSllRY2l2b1dFK3NKc0hG?=
 =?utf-8?B?SWFYVnkrYnFxNEh4TExUQmdXZVRjM2JHT2hkV1VrOG14NVRpZm01Ulh0V3A4?=
 =?utf-8?B?RXBDRk1PbEkyRi9kZ1gwNlBtZnZ0KzNwODdWQTgxMjdwOVNSSktGcnZwaXZJ?=
 =?utf-8?B?b2szMStiZVd0Q29oLzQ4QXc5RitjVDJHUm5rWlpXcUxxa2JKYWh6QkdNUnY4?=
 =?utf-8?Q?Z6Aa5vF90nA3Fl3yho5wyHmMQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51f92e9d-2bcb-41ef-2290-08dc80a24d8c
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 12:16:15.5790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZvS5b/yKwXZEEkRzntfFI+Roeey5Fy25l5y5RnArvlAYN9W9EWKM37lH6jhYE3hEBn3X3/BLNJww3Y4gv4oP1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8742


On 29/05/2024 21:59, NeilBrown wrote:

...

> Thanks for testing.
> I can only guess that you had an active NFSv4.1 mount and that the
> callback thread was causing problems.  Please try this.  I also changed
> to use freezable_schedule* which seems like a better interface to do the
> same thing.
> 
> If this doesn't fix it, we'll probably need to ask someone who remembers
> the old freezer code.
> 
> Thanks,
> NeilBrown
> 
>  From 518f0c1150f988b3fe8e5e0d053a25c3aa6c7d44 Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.de>
> Date: Wed, 29 May 2024 09:38:22 +1000
> Subject: [PATCH] sunrpc: exclude from freezer when waiting for requests:
> 
> Prior to v6.1, the freezer will only wake a kernel thread from an
> uninterruptible sleep.  Since we changed svc_get_next_xprt() to use and
> IDLE sleep the freezer cannot wake it.  we need to tell the freezer to
> ignore it instead.
> 
> To make this work with only upstream requests we would need
>    Commit f5d39b020809 ("freezer,sched: Rewrite core freezer logic")
> which allows non-interruptible sleeps to be woken by the freezer.
> 
> Fixes: 9b8a8e5e8129 ("nfsd: don't allow nfsd threads to be signalled.")
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>   fs/nfs/callback.c     | 2 +-
>   fs/nfsd/nfs4proc.c    | 3 ++-
>   net/sunrpc/svc_xprt.c | 4 ++--
>   3 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/nfs/callback.c b/fs/nfs/callback.c
> index 46a0a2d6962e..8fe143cad4a2 100644
> --- a/fs/nfs/callback.c
> +++ b/fs/nfs/callback.c
> @@ -124,7 +124,7 @@ nfs41_callback_svc(void *vrqstp)
>   		} else {
>   			spin_unlock_bh(&serv->sv_cb_lock);
>   			if (!kthread_should_stop())
> -				schedule();
> +				freezable_schedule();
>   			finish_wait(&serv->sv_cb_waitq, &wq);
>   		}
>   	}
> diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
> index 6779291efca9..e0ff2212866a 100644
> --- a/fs/nfsd/nfs4proc.c
> +++ b/fs/nfsd/nfs4proc.c
> @@ -38,6 +38,7 @@
>   #include <linux/slab.h>
>   #include <linux/kthread.h>
>   #include <linux/namei.h>
> +#include <linux/freezer.h>
>   
>   #include <linux/sunrpc/addr.h>
>   #include <linux/nfs_ssc.h>
> @@ -1322,7 +1323,7 @@ static __be32 nfsd4_ssc_setup_dul(struct nfsd_net *nn, char *ipaddr,
>   
>   			/* allow 20secs for mount/unmount for now - revisit */
>   			if (kthread_should_stop() ||
> -					(schedule_timeout(20*HZ) == 0)) {
> +					(freezable_schedule_timeout(20*HZ) == 0)) {
>   				finish_wait(&nn->nfsd_ssc_waitq, &wait);
>   				kfree(work);
>   				return nfserr_eagain;
> diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
> index b19592673eef..3cf53e3140a5 100644
> --- a/net/sunrpc/svc_xprt.c
> +++ b/net/sunrpc/svc_xprt.c
> @@ -705,7 +705,7 @@ static int svc_alloc_arg(struct svc_rqst *rqstp)
>   			set_current_state(TASK_RUNNING);
>   			return -EINTR;
>   		}
> -		schedule_timeout(msecs_to_jiffies(500));
> +		freezable_schedule_timeout(msecs_to_jiffies(500));
>   	}
>   	rqstp->rq_page_end = &rqstp->rq_pages[pages];
>   	rqstp->rq_pages[pages] = NULL; /* this might be seen in nfsd_splice_actor() */
> @@ -765,7 +765,7 @@ static struct svc_xprt *svc_get_next_xprt(struct svc_rqst *rqstp, long timeout)
>   	smp_mb__after_atomic();
>   
>   	if (likely(rqst_should_sleep(rqstp)))
> -		time_left = schedule_timeout(timeout);
> +		time_left = freezable_schedule_timeout(timeout);
>   	else
>   		__set_current_state(TASK_RUNNING);
>   


That did the trick! Suspend is now working again on top of v5.15.160-rc1 
with this change.

Feel free to add my ...

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks
Jon

-- 
nvpublic
