Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2053.outbound.protection.outlook.com [40.107.101.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78CE17CA1B
	for <patches@lists.linux.dev>; Thu,  8 May 2025 09:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746697738; cv=fail; b=l9bMHplc/0Jbn9WDA9q1g/XPltDbuLu//BEN5KGvT4vxn0mUP0SyZAML0HWmfmmh5yDxyCWejr7UJaI3Clsx7BHZ6td/JIyZxRFmx1Ftm0KVjNmhFzHj2WRh+O9NTeunFhKgEDb1stRfN0ycogi64XJSyxPDxgPfbqFn0KXg368=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746697738; c=relaxed/simple;
	bh=00ZLAfXQltaVIrGlm7GX+GbBtJDo9W02av/Hqj3uRoI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZLxBPA0AHYaDPa0HW1RyruZiHb9RdC7YW8PeK4oUK+q/ssxnUkNEQa3TGfi/+0eYaFBTHzZi7cCZAk09N7G8fHbvSaX3AS9OOgSSP+TCai4Of3Zl/ykohifAnh+170zL1OoUkvKr0UFAwC48TkoonLcTjC54LI+3/vjtf5zDzUk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ch5nDLEQ; arc=fail smtp.client-ip=40.107.101.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ch5nDLEQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PKrJSrXGgSiHsnLoqgee5o3MAzpJlRQqSABTe4JxGOp9BCkSfDy+qN6VefRRUCt+z5JiOYaCrLbbPpwdsIhBWmOIb379J3xBkRDp5o/F3cDjNT3KD4sJt+BKq+WUG9RHXI338O7fPZBZzUWt05In5t6F2rGDgUynuYcw1GOkKd58w0cYbrRjiEKHxM/1CrE2u+lPvngQFXaMuxivksXBFrgl5oQuw4D10oH4zyW0NbtZ+JxdOjCa1krXMwBvJWOL/pdWw006fh0lBVwqyZHZz0mmT8rk2ep6+xeY/Kb3RaJG2ZC+ugJj2dm01SvGcJ4+cHQxH5w0eLrsGNF2MwbXJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=olfGIS9l/d0nV8zfMQClldLMLiXGkmdWSqO2vR+/o+M=;
 b=gTYNGNjcv+Sja1KRk4UmXptFNiHB1dPdi7KmQsP4Ri0uP4XwCnBC182Fw59qfqJtP0x9zg02RoRfn1vCui1a0QDoBLRM8xRInG7S2PX4kab1CcK3q32PhvRA4FC7JCZuCoWqgPBvavL88CYWUHt5oYkaWp/kwvvLzRbKrhDJCSOjFpa+IPtBNH4jEnwIbRJgVZCZEhUoNsg/Xz5Cd8B7DOku+S6xFms1NUGFZAkP74Ca/I/KYRLU0xVmiBvYPTwIqBYPptIhSMaE66QKgSu66rCAswY9MUa0ZbS5bQYZQJdYtM/mTlXDy633dSq0gbpK7AuOtIIzyYcDIdQUnYLWYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=olfGIS9l/d0nV8zfMQClldLMLiXGkmdWSqO2vR+/o+M=;
 b=Ch5nDLEQPFAvpQThMjad8Jc7nhG+Orag1wgN2drUyCLOW2CzI3njeRhesra6sA5fnaFDbfrs+3UOM1UQmFnxh9RQ3vE8+c3NPG2gJZiEEu3oSH836F/PiwtL3xExkSxDDQ7ccVohQJqv5pi98r3aMVPO6Qog/KKTPw2TFcfspruSxKMwwL+QKI82L0kGtiS4g+X/yc2pDvcfqQMEpSnvKlcWOgP+MBGTjPdkJGbNgZ+Ld25qjVopATvv+YdGpbWFYYfMNn08UaaZvlmjJ30OWmeMMffyNaGAC5uX37ltstP5aaaPlpO2DoLPgKaF3Zq4wdfarbeSa7VbxPTaH+GP2w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by CH3PR12MB8332.namprd12.prod.outlook.com (2603:10b6:610:131::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Thu, 8 May
 2025 09:48:49 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%3]) with mapi id 15.20.8699.022; Thu, 8 May 2025
 09:48:49 +0000
Message-ID: <2a83d6a6-9e80-4c78-94a6-5dedd3326367@nvidia.com>
Date: Thu, 8 May 2025 10:48:43 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/97] 6.1.138-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20250507183806.987408728@linuxfoundation.org>
 <864a7a10-ed68-4507-a67c-60344c57753a@rnnvmail203.nvidia.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <864a7a10-ed68-4507-a67c-60344c57753a@rnnvmail203.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0286.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::34) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|CH3PR12MB8332:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f8c17cd-4f16-4295-382f-08dd8e15889c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TFkzNEJqdHlya1hpN1hCeXcwM2lndGRGMWNFV054NXlaV1dzaENId3ZKb056?=
 =?utf-8?B?ZGZkcjY0VVM1cmE1ZUJwT21uWUsvNkgwNWNSdWhQRFZkbndFcWMwVnJVc1lW?=
 =?utf-8?B?azZNWWNubGxMR2U1MlV3WFFlVXNsbGVpN2pkVlFhaGpxUmJFMzJ6Qzc1b29K?=
 =?utf-8?B?dnFqWVVLQ0RXVklKNlVDeHBGNmQ0OVpDWVc4REhBUjJHTVdSRy9FcUJUVTF2?=
 =?utf-8?B?RndpYXRyZzFzaDRXRGxsMks4S3lXTXpxVGlMcnVRa29nRUtnaC9JOXUyMkt5?=
 =?utf-8?B?VmR0SDRwYjFRcis4VDBQV1NiY2lKOExIWjdySkJmV2VGU2w5elVLQjB2SkU0?=
 =?utf-8?B?Um84M011ZEhnZGZWRjFjdUhydTRPN0JDdHo4S2R5UEhSbHlISUpYTW12QmxO?=
 =?utf-8?B?MmIreGtJUTdIN2JIdFhzNjNKRjdFNzBCQVh3dXFKZUdnQ2dNS0RZU2N0RFA5?=
 =?utf-8?B?TnRMaEJNTVJKVytIRGhxV3UvVkRoam5KckRwOW9ucVFydDVSTzhRUnBFVU42?=
 =?utf-8?B?emt4NTloa3hhdnk2Y3ZMdVMzMEZTNitnVjMxSGJYTGtrNm9LcGsyYmUvMWJS?=
 =?utf-8?B?RjkzMHoveEpYZ2ZOb0FuQndIaVNmaS9vWDdmYWh2VExBenlPY1FwMDQzS0pz?=
 =?utf-8?B?TnJoRmdXUVFHSVMrZE1oL0lNYnFWYnF2ZC9ndjJBODVsaGxrdVRlMG5LT2lS?=
 =?utf-8?B?NTN4NTdyU2p2ek5wZlZTZk9WSGNLWFJwbGg0ZXN4cGpGTnE0aytwVGNLNThS?=
 =?utf-8?B?ODhTaC80Qm0yeTFBYW9MTUJBSXg2MVJ5RjRaZUJHcmlKckROWHBnU1hSZXIr?=
 =?utf-8?B?SU1LOFlFQnJQVE9NMkVPMXJFcTJMWG5KSlRIZGFjSHVEcVZqN0ZsOG1vOFNG?=
 =?utf-8?B?U0RHcnZSL2xnbERiU1RtVG5tbWZFZ2p5S3RrUEhpczY0OGFrSlZxajVEQW4r?=
 =?utf-8?B?L1Jja2FtQlhYaWdoM2lBWVRQTVRwMmNIZk1WYXdsdEZDOTltZ3dxbVVudGR1?=
 =?utf-8?B?eDVaWWsxeHFlTTdRWWtkRzNVQlpJRzFSZlRnTHZOQnl0dFdwN3hjZGcxbWVD?=
 =?utf-8?B?Z0dJUEpIbE9CaUFWQnBtdkhIUUNSd1JXZ1FPWlVqaUdEOUQwVEdiVk1FYUNI?=
 =?utf-8?B?aVhGa2hOcTVJdDk2NDhZUllCTytuSE16N052NHJUZGpiVjVwZW1OK0NBOHg4?=
 =?utf-8?B?RVNiekdCWUlzUWtVQ1duRXNCdjlvU2YwUEZaREV4VW9sT1RBclJOcUExbHF2?=
 =?utf-8?B?M1Zqbm9naGhzSjBGNTJWcmNQZHc0VHJrVWtvYURXaFNHYlVDdnpReHZaZEVw?=
 =?utf-8?B?SVUwSzVHOTZwbmRJblN0NkdwUnZaRldLSUhTMUgyZnJXZ1kwVXRTQnRnZ0to?=
 =?utf-8?B?Rm9UUHRZU2FGdy9JbTVMamRYQzFLc1BnVTdoQTcyL3Roem5IR3dVUUpYcEdi?=
 =?utf-8?B?N3BVZFpSUVprNUFERytLLzdwUWpZSWpsaUJMSE5USnZvVmp5ZmcwdUpXR2hx?=
 =?utf-8?B?NlFSV2FhWCsrODRLZ0R3bjNURnVTOEtjc0t1dzdOK05BYWFEYlJyQk1IaUQy?=
 =?utf-8?B?ZEE4OTJPM2NoVUhIRTJScUFNdEwzY0JpVEE4b1NoZmo1UGJGczJZeXYwU1Ex?=
 =?utf-8?B?bk5DR3V0Ty9FY0VTMVJ5OFNQM0wrczR0OFJWeFdTZmNicmVUcnhYNGZUS2c5?=
 =?utf-8?B?WnIwSUFsUUVJTmxXaFFoSS9MbDZ4QXdYYk1KTS9RMlordVdsS1JyTkgxT3Mv?=
 =?utf-8?B?YW01LzhoSGl3WCt5Z0R6blpOR29ER0trSXlDZ29CeWpsNnJOMFJ2SWQ1M214?=
 =?utf-8?B?OEZzSHJtbForTFV3Y2tJd2ZJWThmc2F6VGg5VFBHdGdGZTJxQXRRdGZQTFRT?=
 =?utf-8?B?OXhaV1R4WFRFbm9xRzJmZUExeU9DYk44K0kxZS84WHpIWWdiekE5b0NVMHo5?=
 =?utf-8?Q?0WQJPZuEpTI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bHlraFI3SW9EckFFeVl1THB1dVZiYSs3OEN3YTNiS3NCa1JGY1lqUHRCM21X?=
 =?utf-8?B?M29YdEJqYVdTT2svdFBadURkTVpkeVY0M1Fqd29ES3pZWGl4L1FqYUtuWlR0?=
 =?utf-8?B?QUUveEdydWZNbHB5UWhmcVQ3K0s0TmVLWnRBbEI5eUpNNld3THhDbW5lbzUx?=
 =?utf-8?B?M3ZkV2lPSU5GUE9oVFpGSjczVE0yd1lvS1o3M0xHS1FFMWZTS2tqZ3FOcVdQ?=
 =?utf-8?B?NDkrdHlxYWQwUkxndE1yalhnM1FTQlpFODBTOG02eWl6dVZpa3BVK0tEWUlw?=
 =?utf-8?B?WGlDWjdpVFJoZkYrcmI4c01vZlVnM1BjdGMrQTVaMUFDR0trdEtocTVqWkcx?=
 =?utf-8?B?SEljQlBENDgya2FHaVRzZFprNDRmd2JLYTFNOG9oR0lKM00xeVRLVkU4c3ZR?=
 =?utf-8?B?YTNtdTY3amFJZFlUM2RwMXF1OVBHZFBoblNsZWhmYTJvYjE0THZmZ0tnNEVt?=
 =?utf-8?B?YU9EYmxBOERtT3FKRStwS09HMDk1QUlQcnJ3bTB1dE1sdUMraVVmeTM0czh0?=
 =?utf-8?B?VjJPTEVGQXFMM0dZMUxoRXY1T2JaZERUSC96d1BuZmhvWkFGbktmUUJhTnZJ?=
 =?utf-8?B?R2RZeFEwWnZRSno0Z01nV0JaN3JVUUkvaTFlTVhMUmdlbWwvNVEzeDRjWnZD?=
 =?utf-8?B?M2FuNFR0R0NxTTVBQXJ0MURSNE54N3JjcG1oY3lkL09iUXByWkMxNytFdXNz?=
 =?utf-8?B?YTZQS0VEYzVQTmFMOWF1eE9Od0NQeHRpa094b1pBZlcwaHRTa0E1a1NSc25t?=
 =?utf-8?B?MS9OUkNQSmQ1c2JHK2ZrZnZOSmxkZnZPNHJacHFIdVVMSEl5QzVxVUtKRmc4?=
 =?utf-8?B?UnMxUDVyTUZvYWU2dTRVRzhBMWMzWE10dXFyZ1FkSUpoNlpjSFFoTS9uVy9E?=
 =?utf-8?B?RzFuSzhJb3I0MnlGeFRYOEFPRjNBZjJpUVVDYnYzOCtxQUNNWC9qT08vL1Va?=
 =?utf-8?B?K3YzWDkrYTFMaVRmTG1YdFIyclE1TjNUeTMveWcwWEJ2OFdmdm1qQ1NLaVNh?=
 =?utf-8?B?Zk52clQrdFZmYjZPRDhzYk5PT3dibzRWZ3c1L3RGNmVQVzBlMjJFUEhiUk4v?=
 =?utf-8?B?UzlOZjcvMUpnWTBROUx1ZXN3d0JSL09aYjFZRm5xSEpoRGZXWkZCQi9ETWdp?=
 =?utf-8?B?YjIrT1paS045c2pmRk4xQXN1K2hzTU5qSlRCLzdMTE9tby9jWnNlcDIwTjM4?=
 =?utf-8?B?TDlIRzRKZzJZQ3I4WjlRWUtzNzVZcGp5UTFiZTFDUzQzYUlia05CR3ZqeWtR?=
 =?utf-8?B?Y3dERFAwM25od0o4UTJQWTAreWpSNEVxQ1gzT2ZkR0tydk9yak8xemhIajVm?=
 =?utf-8?B?bmw1QnRlU0wzMzlCY29RZ08xZHh1bk9zYko0aFR6N2VNQ01ZL0hXbU9lZkdH?=
 =?utf-8?B?Zm1TVDVqcStTL1U5U2FxSUtFRG9jak9tZ3N6Nm5BaXdQTldjQjVNZ3UycFhQ?=
 =?utf-8?B?ZG81NHBvK09vaXlzWHd1K1UrOGllV3huSWtHcEszZHdXeWgrTmdDR0lJNTZl?=
 =?utf-8?B?M0JDUmYrSFF0RVBEcm5IY2hzcVZyUDVwMVJOblFKWllBUWJwM3VVSDV3UE1M?=
 =?utf-8?B?L2VaNHZrZVZEMUlMKzRSbkdSWDc4dW5GYUhoOTM3OXVCMHdNdlhQTkx1anB6?=
 =?utf-8?B?dnNJSWN4YkZROWYydFIxT0xsQVZVQ05Xa05hYW00RGk4Q2tQaUd5RWZLYTVN?=
 =?utf-8?B?TzMvUUNDWjhOQ3lnYnd3RTEyM3hhSW0wNWV2MWUwN1ZEdEF3M3Z6dWpXa25M?=
 =?utf-8?B?Tk82UzZqZlY1Szl1aGloVFNCRDl0cHluUXRvNzNQMVp4T2JGTWxIajgyNjhY?=
 =?utf-8?B?Rm5NdGNOWFI5Y0VwbzdMNWJFdERYdWVsVTNROUNSeXQxQXU4Z2xwL3hsV1B0?=
 =?utf-8?B?WWRiNWhBd3Nsa3pDOXlhZVJMa2hzZXlWdzIrNTdRblJNNTI2Z3V0TEhiN1da?=
 =?utf-8?B?ZmpEY295emI1VDdVWkhBT1p6bmZsZTAzQnlkbmxCT1RGb2diK0NCWHFuZEp4?=
 =?utf-8?B?bkNlR1VpazBFSHFQa3lyMkxIcnpKM1p6djNleXNqRzFlTERZR0RQTGRXTXZt?=
 =?utf-8?B?clFWSGtYZVFtQ2ZBazRocVZzWnN3ZmpCckdwZmdjMGprb1huUC8rbmxpb2xI?=
 =?utf-8?B?RHcybGh1N2NrNVNJR042YzEvSU5aZUllSlhkdTFiSTE2TUlTS0JveU9qUU0z?=
 =?utf-8?B?OHc9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f8c17cd-4f16-4295-382f-08dd8e15889c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 09:48:49.4927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jPosBHQxhWfjgizxXaeDsL22rmPWE7Hvos28gJE+fqS2JfWJVBmfqzlIUDUe/12bc2kNorLjxFEkXmyC8qjLWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8332

Hi Greg,

On 08/05/2025 10:45, Jon Hunter wrote:
> On Wed, 07 May 2025 20:38:35 +0200, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.1.138 release.
>> There are 97 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 09 May 2025 18:37:41 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.138-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Failures detected for Tegra ...
> 
> Test results for stable-v6.1:
>      10 builds:	10 pass, 0 fail
>      28 boots:	28 pass, 0 fail
>      115 tests:	109 pass, 6 fail
> 
> Linux version:	6.1.138-rc1-gca7b19b902b8
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                  tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
>                  tegra194-p3509-0000+p3668-0000, tegra20-ventana,
>                  tegra210-p2371-2180, tegra210-p3450-0000,
>                  tegra30-cardhu-a04
> 
> Test failures:	tegra186-p2771-0000: cpu-hotplug
>                  tegra194-p2972-0000: pm-system-suspend.sh
>                  tegra210-p2371-2180: cpu-hotplug
>                  tegra210-p3450-0000: cpu-hotplug


I am seeing some crashes like the following ...

[  212.540298] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
[  212.549130] Mem abort info:
[  212.552008]   ESR = 0x0000000096000004
[  212.555822]   EC = 0x25: DABT (current EL), IL = 32 bits
[  212.561151]   SET = 0, FnV = 0
[  212.564213]   EA = 0, S1PTW = 0
[  212.567361]   FSC = 0x04: level 0 translation fault
[  212.572246] Data abort info:
[  212.575137]   ISV = 0, ISS = 0x00000004
[  212.578980]   CM = 0, WnR = 0
[  212.581945] user pgtable: 4k pages, 48-bit VAs, pgdp=0000000103824000
[  212.588394] [0000000000000000] pgd=0000000000000000, p4d=0000000000000000
[  212.595199] Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
[  212.601465] Modules linked in: snd_soc_tegra210_mixer snd_soc_tegra210_ope snd_soc_tegra186_asrc snd_soc_tegra210_adx snd_soc_tegra210_amx snd_soc_tegra210_mvc snd_soc_tegra210_sfc snd_soc_tegra210_admaif snd_soc_tegra186_dspk snd_soc_tegra210_dmic snd_soc_tegra_pcm snd_soc_tegra210_i2s tegra_drm drm_dp_aux_bus cec drm_display_helper drm_kms_helper snd_soc_tegra210_ahub tegra210_adma drm snd_soc_tegra_audio_graph_card snd_soc_audio_graph_card crct10dif_ce snd_soc_simple_card_utils at24 tegra_bpmp_thermal tegra_aconnect snd_hda_codec_hdmi snd_hda_tegra snd_hda_codec snd_hda_core tegra_xudc host1x ina3221 ip_tables x_tables ipv6
[  212.657003] CPU: 0 PID: 44 Comm: kworker/0:1 Tainted: G S                 6.1.138-rc1-gca7b19b902b8 #1
[  212.666306] Hardware name: NVIDIA Jetson TX2 Developer Kit (DT)
[  212.672221] Workqueue: events work_for_cpu_fn
[  212.676588] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  212.683546] pc : percpu_ref_put_many.constprop.0+0x18/0xe0
[  212.689036] lr : percpu_ref_put_many.constprop.0+0x18/0xe0
[  212.694520] sp : ffff80000a5fbc70
[  212.697832] x29: ffff80000a5fbc70 x28: ffff800009ba3750 x27: 0000000000000000
[  212.704970] x26: 0000000000000001 x25: 0000000000000028 x24: 0000000000000000
[  212.712105] x23: ffff8001eb1a1000 x22: 0000000000000001 x21: 0000000000000000
[  212.719240] x20: 0000000000000000 x19: 0000000000000000 x18: ffffffffffffffff
[  212.726376] x17: 00000000000000a1 x16: 0000000000000001 x15: fffffc0002017800
[  212.733510] x14: 00000000fffffffe x13: dead000000000100 x12: dead000000000122
[  212.740645] x11: 0000000000000001 x10: 00000000f0000080 x9 : 0000000000000000
[  212.747780] x8 : ffff80000a5fbc98 x7 : 00000000ffffffff x6 : ffff80000a19c410
[  212.754914] x5 : ffff0001f4d44750 x4 : 0000000000000000 x3 : 0000000000000000
[  212.762048] x2 : ffff8001eb1a1000 x1 : ffff000080a48ec0 x0 : 0000000000000001
[  212.769184] Call trace:
[  212.771628]  percpu_ref_put_many.constprop.0+0x18/0xe0
[  212.776769]  memcg_hotplug_cpu_dead+0x60/0x90
[  212.781127]  cpuhp_invoke_callback+0x118/0x230
[  212.785574]  _cpu_down+0x180/0x3b0
[  212.788981]  __cpu_down_maps_locked+0x18/0x30
[  212.793339]  work_for_cpu_fn+0x1c/0x30
[  212.797086]  process_one_work+0x1cc/0x320
[  212.801097]  worker_thread+0x2c8/0x450
[  212.804846]  kthread+0x10c/0x110
[  212.808075]  ret_from_fork+0x10/0x20
[  212.811657] Code: 910003fd f9000bf3 aa0003f3 97f9c873 (f9400260)
[  212.817745] ---[ end trace 0000000000000000 ]---

I will kick off a bisect now.

Jon

-- 
nvpublic

