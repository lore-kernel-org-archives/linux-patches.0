Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012000.outbound.protection.outlook.com [52.101.53.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2E2371068;
	Sat,  9 May 2026 16:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778345652; cv=fail; b=kMVbHDngqBpYAQglOMBAdsfR1N19RPnyUFcXyrfVXmXpc+UJL1eujoK2dVRhXc+OmPs+/xsfy3Vi/6HCleC6YN26FgWR2yzocvwHz7bkDXByftC0FM86SZLmuQcm406v1XbaNQtDVdeE61rid0barai9zwWHz+69DGc2KLxZUFs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778345652; c=relaxed/simple;
	bh=SQGnMjZXV0WEv24+RAnzRCnscF6SkgJ59XH5FPt7uQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GtdyiaDZCPNLTWAYqQEWY+h5LxCqNzdH0bskg3hY00NnyFnMKjH2brOMeHuPvmoJxlXeDfUwkMB6b/zo2DxCM5gFd4hXBVz+osrgAr5rtsi9iSlJm0E6AKHtxlRx9wWzGrdYRKFJQAksKDlkH6jsAhqo7WC8medUbKkV4Xs6uZU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=a1RU1Rdx; arc=fail smtp.client-ip=52.101.53.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="a1RU1Rdx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uDEYNyvG75T+B3eK6BpvhL5YtVejT+DVI+U2hn3R2Ou0rC9r+EcSICniY272My/zk0Oath5IHKEjF2+cpKQccBULu05GpLxr9DM3hlK29ejnI0aMJ1Nc6qKBQ/jChX10Lk8g4ay5VYDAKsj1yQEpilIAV4dKpK9JsG0bECNybuBDHIB5sxImqWwm/SCjO2o1nVT2+FfWv6QDSYqqGkwlI53WIAUHr0SHG05n6c5shAbN3ryCNw59wBcPp/FxztOj3Di/AV0ibIlNtYj/FbHyekFs1TDYb243nTBRqnZvVGJaH4NCMhbM4Hb1Te443Sl6jpP7SB7zSqhwGRXaPoD1RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+306wj3e1bAWNCJw5Soq2MlQFgMYoSZG5jLsfZ1UUxo=;
 b=hWb3pRKoDMYAmDy5dOFTjeVyaWIu0eyaNsSz8/aBMTCdQZL4O6tG6sitvbsb2lBSWIfZHbj8CcufT1ifqpkMUmsvoRKCS3gWqk5Qr+RHcdUyDle6FlRpsIgBBQ5KRa8q9YPYLhBFhP65cZsw/HzOKDBxi6TdwS65/jhPyqdTEIzzUQaIGegRsNVkfsEEEs7CwyoRC30QBwhJ8vm5nRu7EV3MqTU8TmHtqEbztcRuhHlicUqmTTL9/5AjapZx7IARsFI4dIr+BTVYyXfzqCd6/yVFQk+6oVlp2Xg+Szc/4QvtQWb1/Qmx8MIgLwioIoyXEamkyVMh5yI+Lw8BvzJaRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+306wj3e1bAWNCJw5Soq2MlQFgMYoSZG5jLsfZ1UUxo=;
 b=a1RU1RdxZzNr1/qJOsJZXaY3tCrU9iRRlY0dCyeq9GDTWvRLdhmuQPKtpF3zzi3cMmwozGOduLXcmhk+Ec3IZ3m2iK8qSReunF8kZCvfDE7Eocj/StoUanWv6LE4NWp8WA+bziExj6OFlkpmdDP26w1pV8ZseR8bRdkV7da39ZkJJn6w6UIcX7bQzHKAKTrfru3vVFfdePbtsHnX9LX3LAiT/+Zw4RkZHsvdnKusAIDbhoG/S+LVmzNBpKS/NfwRTPfjU9mVGSYemF5/5M8xelnoSzf0GykbTahaRHvwcVTMqUIMdcFw/E8owh9ath7BKGwx0Kl+7k+yrckz3lBn6w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SN7PR12MB7978.namprd12.prod.outlook.com (2603:10b6:806:34b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.21; Sat, 9 May
 2026 16:54:02 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9891.019; Sat, 9 May 2026
 16:54:02 +0000
Date: Sat, 9 May 2026 13:54:01 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pranjal Shrivastava <praan@google.com>
Cc: iommu@lists.linux.dev, Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Krishna Reddy <vdumpa@nvidia.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 7/9] iommu/arm-smmu-v3: Directly encode CMDQ_OP_ATC_INV
Message-ID: <20260509165401.GL9254@nvidia.com>
References: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <7-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <af3NH0cihPUQ8PST@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af3NH0cihPUQ8PST@google.com>
X-ClientProxiedBy: YT4PR01CA0038.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fe::29) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SN7PR12MB7978:EE_
X-MS-Office365-Filtering-Correlation-Id: 89eb2f74-eab6-4aed-0ad6-08deadeb92ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	LU/wZE0NuvXEV/NPi9SqNnGGPFTWqLVNPB8FcH99NuCS2dIVwWDiRRn3Ve72cgdTeOq5E7YitLYcaqhOZb0gKTH+USRnCyheVwUd83UkqaPkAoGhpf4N+KLjCd4U9uzJf86to0JL8oPXQZSRf3/f1N2fulu5siwLOPbASEvy3wAfnBL1eP2BCs84DZWAPDX65M78A9SnZI6GwbOCxennXnLgZSykxBniT1x/Y7xIAKq/URGt5qswT+5BmOoTFldtgpNpZ+VepTQIDuDfzt+c8UZXG1gb2qB/E4olIPkCoAIk71FHobOot7nD/Lnu+yBY/9icC9ZO9K0OF5kJKi/nUQvdKpFmI/Q6f+Rhpzlq7LdpOvE86bvd5kSAPa+cHiv5/gGTNzxXMmK5xdwajOUdMrlm8EXulvahdbqYo++MoJMxqTZSDwliutXZvjMW0yyLiBJLG02cT1LHn42e0CJP4T5KUSBCpCc2vX0nmn8sixJmclBVUQdbVO7tOnmDvwF3zq90FMtud/tY0X7QZj25owFLcUMqYWg05CFIZqVKfMN46OL1Iq1ykaFwKSNgM0sFBqTr6mRT7V4VKhNFWfOrMHZ4Kg+yeyyLcNMDBH3npUUSfe0r1y0mvfwGHA0OBwvlT+mdJc6OUkpwaedxQk5AJ70KvofyOPKBQrtVJ6ceJAzsJVOj22GUZ+kRGYpLzBvo
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z7aU3lNItMNFPieCxLXvW+mSkmQ/5bsbQKB1IIXA6UObC2YwpZ50KWOBJL3C?=
 =?us-ascii?Q?OZ8MldO7VznQLE2e6HRQmA/hKUgsCOqVtsOYKhZNIKwCkzG3Z3VS3mGcU8Z8?=
 =?us-ascii?Q?GhcQV+Hy5YiMKyCOHNlEV8SRYc+jaMREjz1ZsmZHo07KA6rNcjnp08nVVXa0?=
 =?us-ascii?Q?AYo9IYAqLHkBXZAH1f1RKazHckrDz4Yc7Io9W4D7nAQRTh+kgf5YM+PLiZtk?=
 =?us-ascii?Q?8Qm3SRgL2G4SOQfGrdKTOjUt/MBh0Z2wOiNk3UvUEziivOILJvwUOlfNHoaR?=
 =?us-ascii?Q?/eJlDYqaZR/rTOrBuVm/up6jpR+I2nghvwGxPq7oHnBxgrSYSkCWOMbmFG96?=
 =?us-ascii?Q?y7WfystgkiHr3camxR5O/dHwyyheCNNsTVk/LjPXVCPZJaL7eEakY3lUsqeS?=
 =?us-ascii?Q?gIxl+ksA2FkUtqW/xBJQ5bkxWW6jS4QopLY4TnK/QFRbdwDSj9xtzjSztbea?=
 =?us-ascii?Q?6ZHA76dl/hYz2oI9sUzxYJzTj9l24GAhIHg0wHpEydUxctOYFVks9kc8Mp8l?=
 =?us-ascii?Q?T9Fr0BpzN0Zipl8LEygoIS+dLHTbsdI3SVl+i4QtfzJEWph468+q+qvpkCkC?=
 =?us-ascii?Q?pULu8PtlBtBfHw64tp66JNOm/ORqkA1AzvGPHToekLXZZ9mbZkjesLRu6nkq?=
 =?us-ascii?Q?laKV1tYEs4gyTI9rGRSjjwWCBRysei/g+38BR10ifpvDP5a7YInbxGiwWcZo?=
 =?us-ascii?Q?fsspDkIbiG87bEvND9O9JLj63zl3JT3Upw2q3RNrZONRj+AX/DNzpqyQcXoU?=
 =?us-ascii?Q?W3z2wENr5AFH8lFS6R/FpTHOkLWN5PVKMJ3cqUgZKfo3gp44Q2ZAD8pWiRb9?=
 =?us-ascii?Q?aIbZ87IVOqdnARTgrEk8q1/qwRW1Fqy0svMwZg912IDzj5zzjEsDWsHCM3tL?=
 =?us-ascii?Q?iMnl98cmepKrxQWfBhOCsWa0gh53jTpU0/0dhAX7H/cyPf18xizxCHk7LdXL?=
 =?us-ascii?Q?635mQgLOyb0OQcIirkGgQUeNcoaNhR3LxmKGQ2JmGO/TfotYJ8SdqCYCyjvO?=
 =?us-ascii?Q?nL0jOALorRBw1u4czoSGM1QvZDkq+iXSVcqIB+rBMvIU8GURjOpiOpodcy2s?=
 =?us-ascii?Q?T+Of0k42kosVAgCchhK7rdt3XjjDlwhxmReDIpc8tfDnN99EboHHP1DPCrZx?=
 =?us-ascii?Q?qliEODEyoLEMgjZbcFrCjBZPQE6dR3kpTiQahDpxsVFz7FKI1gjNGMX0cbTj?=
 =?us-ascii?Q?ecxdW2nYMj8P9XG49R8sl3aDqX/PLTmm19TKSl0LENYa64A4K3fZC0gAjO6H?=
 =?us-ascii?Q?lYbseBJkt5wzvGf1fkPKklXQxSFJ4Qxgu23V4W9VkbVGSQfVknUGQh66rxiO?=
 =?us-ascii?Q?I038TRWaATQ7K74V+LDszQRJ8mdeqv6Zd/JZgF5obrwzrJTrOXszAnKCPy3B?=
 =?us-ascii?Q?aY0zNJEyM6xqmIs2sxc12T9OXugveXAGHo8C1L3yNOZB8kSd0ko55Cd8/eBd?=
 =?us-ascii?Q?Y2gjCbb8pllE998v4rCZFy0OXzE0FnBu3iEaqrSzyYmFnPUm/b+CLqhDX4rt?=
 =?us-ascii?Q?cl6MRJNHyULKOeApv2O3NGEdnnLmTLxId3FnmIJwJeCI4NWnYIKSPNl8OOpQ?=
 =?us-ascii?Q?aReHALNOFYb4esXKY5Zvxhn0Zcoq8527j5Qr2T+MvGaf7iME4k4fviWStZzz?=
 =?us-ascii?Q?IwOMzKJD2ftfLKLpBmwVvzZjakCTN6Q0YMJsiHNg0Cv74u0pPQd8fL5wRJaz?=
 =?us-ascii?Q?SS6ayOxRgo/wI7mYOsOv7cdMzpY8yZxKPjUj4CsGioTmRq4i?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89eb2f74-eab6-4aed-0ad6-08deadeb92ca
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2026 16:54:02.7082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K5MGMuVS6fhslcrf2CKHQJnXHFJ86Q2+4+YqmWmx2Ypxtb84d23qYDYovywKm6u8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7978

On Fri, May 08, 2026 at 11:46:39AM +0000, Pranjal Shrivastava wrote:
> On Fri, May 01, 2026 at 11:29:16AM -0300, Jason Gunthorpe wrote:
> > Add a new command make function and convert all the places using
> > ATC_INV.
> > 
> > Split out full invalidation to directly make the cmd instead of
> > overloading size=0 to mean full invalidation.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> 
> Nit: I guess it's worth mentioning that we remove CMDQ_ATC_0_GLOBAL as
> we don't set ent->atc.global = true anywhere in the driver anymore.

I added this:

In section "3.9.1 ATS Interface" of F.b the specification says:

  When the SMMU returns an ATS Translation Completion for a request that
  had a PASID, the Global bit of the Translation Completion Data Entry
  must be zero.

Even though it faithfully forwards the G bit through to the ATS
invalidation command there is no way to create G mappings so there is
never any need to send a G invalidation. Thus don't expose global in the
new helpers and leave CMDQ_ATC_0_GLOBAL unused.

Jason
