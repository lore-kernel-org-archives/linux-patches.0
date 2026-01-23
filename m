Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011009.outbound.protection.outlook.com [52.101.52.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EED311C33;
	Fri, 23 Jan 2026 01:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769130482; cv=fail; b=ZfnrIZtLMvL5SWxN8HhM/4Ybeujjw8JluSvxDrFMl9cGPjdQXeYTjlqbMCVw8LQb+wD12x9KKMKPFo8A0DVHUoJur5KTLpqfKmaf7zzmYcD1OGbyGCGJUcJ5rsC3lHu2iYXuZPYBZ2vSJ6GtgrzomWGoXFEWakbXD4581TgkKyw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769130482; c=relaxed/simple;
	bh=G5tMSZDbidT07ZdMDMVCUJ2YOjJIeRYSZbbpkrgAuD4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iogbQBn6M3k032NUowlBlMchyWB03jr7qle0DH/TdhWdMFuM8tbueACiYToifEMseBBZQ4cD1OEguY0uEliMOnEe2CFmabWhm1uXTFSfeZd1d8owlIBJJwsz7Bu6jW9vfn3S+Uj/5DLVeSVkXetbQU3JR/y1REaFx9gpXZtB2kM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=x6q2pZYI; arc=fail smtp.client-ip=52.101.52.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="x6q2pZYI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RcuxounpKitZ9PMK00BmzHajjeakjzTGPuGJCTsH7pxn1D30tL2tTTBqFslxqfPtYomSbXoc1u1FrGxtmv1b8/2C6KS7xsfMrgouCXBwDNDCKTVFhaQb7DYFXFKPRTAgdvVMiUXk7rc8HuUPU3sZCINGlPOyr2LP7XsyT9BisOP9uYFoxYt1O4zif5MgeC8bhcDr0LAzDaAweTmcWrVJzUQ4gGv5O99imvEKSQzCCXomO653u/dywLmfNkspsaMz/0EflLeYz6U17eF+tS9lGCQnJ9dupXVsbEbQOkfkuNlzU5cak1PDSo2fngpNaml3Wc5W7wnieAfnn/O1B7kugw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SYrhYi3iw0hbjfwdj3mGxPlOn1TG7k02knqwi3/UMzM=;
 b=m1GqiAc81ZD7tSF1P+hPlTX11sHN6efohAZZMp2OI/TP3Th6EOmc192k9xFhWyUZbeUNYDJilyQYsiuSpJTmaLvJpl0aYG4ZFdlulS76goqFpni51Mguteq5EI2wwFzYjx0ZbbT7N+pO7SUb6Oy+U7ywvWfMrrQ6Z2w3yiKl1CgCbUD6TrnhVyq2hEJShNUDSRJr6Q1LELxD8PxkfAV8zKvSL/pmkS0CiZk6C5FQIr9mXGs678rq/zIJ3LuCT09+pfX5+xMvQAOf+tYm6Np20w+OjybquWCqXTD1iur7A8syXHgjlqHw2BKYdi0Kj9pI2pfms+G0dailwdfKFk6R5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYrhYi3iw0hbjfwdj3mGxPlOn1TG7k02knqwi3/UMzM=;
 b=x6q2pZYIUBVru2YI+QUx2JhLNTVf6tJYTIeE+jPIMd09dosH0dE2WJUICCESHDtmqNTBtMxi+q89n99HtigTOatLRGwBWjHekmCDZ4j5rDpxZm0SOBBmKYB/7iFesLkBJ2BWsjOdTFMr9zyM1is4wP61Q1bvAiVLM5ZRkuspUwI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by SJ0PR12MB8140.namprd12.prod.outlook.com (2603:10b6:a03:4e3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Fri, 23 Jan
 2026 01:07:43 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%4]) with mapi id 15.20.9542.010; Fri, 23 Jan 2026
 01:07:43 +0000
Message-ID: <0295a5bb-2567-48f8-9806-0467907143d5@amd.com>
Date: Fri, 23 Jan 2026 12:07:26 +1100
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
 <e0514ec6-b428-4367-9e0d-cfb53cc64379@amd.com>
 <20260119173734.GL1134360@nvidia.com>
 <e8cb2549-6a17-47ce-8e9f-96c576890262@amd.com>
 <20260121170931.GG1134360@nvidia.com>
 <5a3dfc0a-eca4-4de1-96cd-b4034f0b8e06@amd.com>
 <20260122141240.GM1134360@nvidia.com>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20260122141240.GM1134360@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P282CA0107.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:20b::12) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|SJ0PR12MB8140:EE_
X-MS-Office365-Filtering-Correlation-Id: d06dee70-2ce9-4ebd-152b-08de5a1bcfd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aHdwYTVtK0VQeGNLdFNHS3ltRUk0SjJnQ1pxWHh3MjNuUDFFVHhxYUl5R1gv?=
 =?utf-8?B?S3FlV1FMSFNNVU1BdkhBMmk4dTUvUTl2N0JrRnYveW1BK2ppRzc1NG5RSzlP?=
 =?utf-8?B?OG5Mc1VaVkM3ZEFkRUMrTGwwdG8vcTZiTHk3bGM3SG13cDJaQkZtTnZlN25F?=
 =?utf-8?B?SysxbXlzSVJJektIL244NWp5UEV6dm95eUptUThiMFVmeERwTy9KV0gxWWE1?=
 =?utf-8?B?NlFnZmI1QjZGdjhzUlQ4VDBuQ0pvcDRHV2xFRk1OMVJIVytkVERaM243bDdS?=
 =?utf-8?B?RkFPY2YzVk5HMjhHV2dBU1UyYkh4Q1FOT0RoTWdqcHhrZW40Vi9la2V0S1dF?=
 =?utf-8?B?Zm43S1NoSDF0NjVmb2p4dTJ3OG9rRCtydUtNWUFXdHdWM21hbHBYalFZOHd4?=
 =?utf-8?B?bWhCSktnbWJhZThZRVdSa0FwSllId0V3bXNUek9Ec1VqZHgyVXNPVklUV2ho?=
 =?utf-8?B?VkNSMGVjUTVJTnA5V3NKUlcwcW9SUndaNk9JRGVTZVNPVmtzY3M0N0kxVk9B?=
 =?utf-8?B?cHpoVTNobkdFNU9KM1hLSWVrWFhCcDBBSTFtcVNlL2hOTldXcmlrVEkzVWZu?=
 =?utf-8?B?elpWSFJJVTZXa3lFd3NKM1RLdy9RQUdEMWxZNC9tVHhicnJIMmFDYThPTmNt?=
 =?utf-8?B?ZDIrZHRXZEZ6WGtIanltM1Q3VktZQlpCNjkrOUV6N24yTExGNVFObnBoMUJ6?=
 =?utf-8?B?b1JUK0N5cVQxVndhTmV5eVBsd01hNGFJS0plTlB3eDFJdnVrN0hxalEyZFhL?=
 =?utf-8?B?WTkvS21GWENWK3BDVGR6dWQrUk90UDdMcVE3YUI1M2JoMDFlSjVPQkI3bktE?=
 =?utf-8?B?bU5lWG4wYzk1T0YvSldzMnhEd0dVQWluVWhHaWthbFNIQWM5Yk1lczZKcTRI?=
 =?utf-8?B?bkVyMEx6KzIwNWw3dTdzbzJBRGNIVS8zaThmQWtZZXdKQmFXQmxyOUMxMUNW?=
 =?utf-8?B?cFVVc1lONWM1U3JZdXl1MklQZnd6UTdPQUs2aWxSdHhqUkRHamNneXF6Y0Iz?=
 =?utf-8?B?RWZiRG5PWjlOOUxNS1JEN0xoRVF1ekhtSVhId3BEZFJxUytRRS9yYkNuYXRY?=
 =?utf-8?B?YXJBa0FUOEhUbjdndFFJSnVrVFRNOHEzNmszcUJJd1ByUXlrcmtOVUkwNmN0?=
 =?utf-8?B?dFkzNHFYOGFOdXVlTXZvMHpwbGZ6N2t1OWFqaEJXVm9zaUFxdXdCd3ZmTTJ2?=
 =?utf-8?B?dm9EUkhGeFlCL2RsekpPcFMzbU8vaXRKNFF5dkU2QU5QVEoxR3NmUDB1SElt?=
 =?utf-8?B?bm41MDlwNzMyU0M4OTM2cjluWWM4cGhMRWtqdGkyU2oxOHppeDVIKzkydDUy?=
 =?utf-8?B?bVV4NlNRbEVCcFlXRmtpYUlJdnRCU3VuK3M0Slc0MlRCZWtTNXRUdWZ5RTVh?=
 =?utf-8?B?aVRWZk5uQ2I2ak9tSVM5NzZXMHNNelVFR1lMV0tRL3BaMVZjKzFIa0NwNFVE?=
 =?utf-8?B?NldGYnEzWktyaWVzYkFjSFZlUUMyd3htOTVhcGQxMmVpSDc2Y2c5cHBwREll?=
 =?utf-8?B?NVc2bXNLUFp1NGRFWVBNTHNlZzBpVzhTVEdsYjBaK1piNkZmRGcrWjJnai9E?=
 =?utf-8?B?M1NFdXJyOWlqTmJyUnpJVHlZN2VZRHRheFQyOTNDTTF0bnpQSDBaNDFHN250?=
 =?utf-8?B?RGQ4N3NyNVlPYytqREtxQUdkcU4xcEpOUEtZZzYrcWs5bFZ1NVVnUTlOVWFm?=
 =?utf-8?B?SnNYdjBzM244L3g2Y245cktvS0RTVVE4Tm5zcDYyQXpsbkpEbUxIZndtUVBm?=
 =?utf-8?B?RjhuRDlqOWx3SThYTW5tT0hJclZkT0wxV3pzcHV1WGNGNmtXakVkTE9tZ0xw?=
 =?utf-8?B?YW9yaFdFcUJhUW9DMXdYZXNmcW1Fei8yNXhlU1pyaDU0ZWJhOW14MzNmc2ZD?=
 =?utf-8?B?UXAyc2dLL2IyNStGTDB1QkRERHNqL3NRbkZNVmVEbWlFMkxsWVNsNWswTndL?=
 =?utf-8?B?d1EvM3h5RUc1SEhsSXd1cWFJOUNQWnpQZmFIa3kwTlVmSCszYU9YbThUWlEw?=
 =?utf-8?B?THlJazFRM1MzQ1o5VFl6ZVVlcmJUcFp1MWNnQWI2bEpPWlFGbk9kYllEZGdq?=
 =?utf-8?B?cFhkSElCb0Z6QUdPR09nY2gxVnJlZDllT2MyaTJsVkYxVGhLa2o4V3VDcHdq?=
 =?utf-8?Q?IPvE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZnJQcTdqbVRBaDB4ZGJPVlYwZklrOU5WSWpQcCtDL041azRrbmdOUVgrTjZR?=
 =?utf-8?B?WitqWnZoZ3lRWVFuYk5pcDV5MkdzOFk2MmhVT3NkWVFwZzNGV2ZxV0N2NU11?=
 =?utf-8?B?M2tiQ3ByMGRaVG80b0R2dTVpYzJhVjl3NnFiaTYwaTNSeHBkNTVJaEF2T0wr?=
 =?utf-8?B?M2xLVGJYdERjL0ZMWU5KRXJNUXBQWFBQRDdRbEpQdXdoRWhucUZyWkh4NWJh?=
 =?utf-8?B?RFVxRnZsTXpTcFNIdGVpYTcxelEvM0ZhNzhydldER3hPZmxqbm52d21KZkIv?=
 =?utf-8?B?SC9DeS9kQzhiMzdQUTJIVWNobjRzcC80MUFXaDY1ZDFjaWUvMFp1Qm84NzBI?=
 =?utf-8?B?TGpLbmhTVXZQdFRLaFAwTjBMN3NTL05MQWhJMy9LRGZqVDlOV0oydjM2SCtj?=
 =?utf-8?B?WkU1Y1VYUHB3ZWxjdlJBNFNPcmoyampvbld1SjdBTFBJUTlWWWJJeG5WWHVn?=
 =?utf-8?B?TVFCZUpNSytRZzhSVTM2RDc5YitQNURmU213U3JVRHBkNEVNYnRUaUN3cUoz?=
 =?utf-8?B?cUpLd2N0QlMxeGJKWVNUWC9JY1hZQll1Vi9xTTdIZ0VLNENFSmJFUVpkSDFz?=
 =?utf-8?B?RjcvZTFUNkxhS3RKRXFDUFJGRjVPYjFlejhSNDlxQlc1ZnBVZ2kweUYzK2VU?=
 =?utf-8?B?UkswM3pJa1BrUWhnS29PNGFKUWFmQzYwYjRwa2R1TEhZM2dEN1dyNi93TlV6?=
 =?utf-8?B?b0hDT2xYZlg1Q1orU0RzNHovNCtzQmplaUppenBER1NSVVlIRWRPWEpUaXBt?=
 =?utf-8?B?cmlaQUJOYWJiSzRaM09rdG9BdkZNeDAycW9WUXRFMHg4VGhhN2RHUlZkNXhr?=
 =?utf-8?B?Wnp2UXI3Q2hxd3htWVVwN2JqT2JmNzFrT1NXZ2JoWG96aUZ3ZnRQME1qbTdZ?=
 =?utf-8?B?K2xtQVRNRUY5dVIwbnQzd3dPb1ZQd1dnbWd2K2JyZFVFQm5NQ3R5aXZiUXlZ?=
 =?utf-8?B?bS9TeHhwN0FXVVgzMDJEcnV4OW1DNmJPVEU2MDRIcUhsVThqRTlsdjhnN3lp?=
 =?utf-8?B?M1lNMG1yby9xU0RmQWdBNVZBZkJhdmJFbGo4dUpFUWVyZzJCdEdMWm5ZczJQ?=
 =?utf-8?B?NjhJdzYxV09iQ09UQkxKQVVRU3gvS2p2UWpsRHBXSVVNR2FEdW9Rck42Q1Jr?=
 =?utf-8?B?T1lpaUdoVzREaW9GZTVWSS9RR3FBQXdHS3R4WFIyZ25vNnVuQ3E1WngwdHRn?=
 =?utf-8?B?WlFldDFIU3R2aVZuVHNoS1REN0NQSUhOSEhsbm1XUW9ENXRoVlQ2NUZxNFNY?=
 =?utf-8?B?OFZ3anZ6cWdTRVh5TmFBaTV1bENyQWVmWmczRjhMUzFKK0dKeTFUdFRSdTln?=
 =?utf-8?B?ZWVZVVVhcWMxY29QMVI4M0sxaFlKNEd3cm92dE9NQTlmMXZDWndIOWxsazBw?=
 =?utf-8?B?eDZEaTByVXZmbm5FZHVBWDA2UTVuRVpqVDdEYndlYklVQ3VtTnhKQmFqaFBx?=
 =?utf-8?B?RXhxZXcvL3pEVk94SE4xQXNRazBLbVpZS0FQZ1FHcjF3cGo5Ry9kK3dJekFY?=
 =?utf-8?B?Wm5reWhkTC9JdjBadkpHVjhxa0czaWdIWWlvMUZPWU41TGNhWnFXdk80dWZG?=
 =?utf-8?B?aEVjbmxoQ1pxZTZ2RnJIM2JKaDFmalpPK1o4K0xLVU5Mdmk2eGU0Qk16WUVs?=
 =?utf-8?B?ZkdtaktmZEVQZndsd296SU9CaG14SngycHJaMWFydXZBVlZKMnRQTEJBSFI5?=
 =?utf-8?B?UnpvUWY4L1BHWTIwdC84Y1JaNW9VcFNJL21kMERHdmJlTHJWeVdBWDhnRmxH?=
 =?utf-8?B?Yll2Rng2anlxcFJaYlVZT3RmeHdzRTdPRUFMLzlYNE5INTlFTktJbTFVSVYy?=
 =?utf-8?B?bTBnSmFtZFhiNGlPaVllaDVWd2lZWGI1bHRpRmx2eElxdEk0YUhjcWZOajAz?=
 =?utf-8?B?Q1hXTUVkUE9XSjVGT2ZaNWozejU0M2lydTJmaDNjeFJqemhJdC9leFlHcXJ1?=
 =?utf-8?B?bzU4My8rY25xcC9iZU8xZmxhQldUZzhnK2huaDhSdVdpazRZbE84SVhHV3dZ?=
 =?utf-8?B?bmdEM3o5eEE0SW9IUDNYTnlhdERUUDlsNHpHQkdvSUFtNWM5L3Z4WFhOdkxv?=
 =?utf-8?B?c0l0TmtEd0Ixa3U2TEpNcVBOQkdZR24wd2lIcXR5M3BhQlJCOHVpTHZYZWZL?=
 =?utf-8?B?eEloajBkNWZQc2E2SjUxQm9wb25lVkN1aThmM3FDWDNqV0w1TVF5VWdaUVRZ?=
 =?utf-8?B?U3czZ2Y4THIxQS9FMEFwbW1DSWNFeHMvQzBXcERsTUNwWG01ZFQ2TzAyL215?=
 =?utf-8?B?SklubHZzcFFWYzdqYkhsOGhPOW43bm13aTkvTzRtdEp4WFNBSUYzbTBIRklk?=
 =?utf-8?Q?QRriWC+odYGVFOGVCc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d06dee70-2ce9-4ebd-152b-08de5a1bcfd7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 01:07:43.5141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZL6PqB14mOwcjFjgyfTkPBuzE9eu6fCsznGy4ok9KpdFCBh+CrVERfocHqPDtUv51ZvH/6a0E7m3wQDPRHzLEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8140



On 23/1/26 01:12, Jason Gunthorpe wrote:
> On Thu, Jan 22, 2026 at 09:58:04PM +1100, Alexey Kardashevskiy wrote:
>>> This issue with the RMP is no different, if you get a 2M IOPTE then
>>> the HW should check the RMP and load in a 4K IOPTE to the IOTLB if
>>> that is what the RMP requires.
>>> That the HW doesn't do that means you have all these difficult
>>> problems.
>>
>> Got it. Interestingly the HW actually does that, almost. Say, for
>>> =2MB IO pages it checks if RMP==2MB and puts a 2MB IO TLB entry if
>> RMP==2MB, and for 4KB..1MB IO pages - a 4K IO TLB entry and RMP==4K
>> check. But it does not cross the 2MB boundary in RMP. Uff :-/
> 
> Not sure I understand this limitation, how does any aligned size cross
> a 2MB boundary?

Sorry, probably wrong wording. SNP allows a guest page to be backed by only a 4K or 2M host page, IOMMU always rounds page size down to the nearest 4K or 2M boundary. 4M IO pages can work with 2M RMP but not 4K RMP.

> Sounds like it was thought about, is it a HW bug some cases don't
> work?

Nah, this is intentional, I just do not understand all consequences of allowing 4K RMP to work with 8MB IO page :)

>> on the other hand, without swiotlb, dma_map() in the guest for
>> untrusted device is likely to be lot less than 2MB and going to
>> share another handful of pages but this activity is not that rare
>> compared to my certificates example. If only there was a way to
>> somehow bundle such allocations/mappings... :-/
> 
> ARM is pushing a thing where encrypt/decrypt has to work on certain aligned
> granual sizes > PAGE_SIZE, you could use that mechanism to select a 2M
> size for AMD too and avoid this.

2M minimum on every DMA map?

>>> That's a completely grotesque solution!
>>>
>>> It violates all of our software layers. The IOMMU and RMP are not
>>> controled by the same software entity and you propose to have a FW
>>> call that edits *both* together somehow? How is that even going to
>>> work safely?
>>>
>>> Can't you do things in a sequence?
>>>
>>> Change the iommu from 2M to 4K, flush, then change the RMP from 2M to
>>> 4K?
>>
>> Sure we could unless there is ongoing DMA between "flush" and "then
>> change" and then DMA will fail because of mismatching page sizes
>> (that 2MB crossing thing above).
> 
> I'm confused, if the IOMMU has 4K and the RMP has 2M it doesn't work?

I have not tried this, IOMMU pages are usually the biggest on AMD platform, often 8MB.

> Then why was I told the 4k page size kernel parameter fixes
> everything?

Because IOMMU becomes 4K only and there is no huge page support in the confidential KVM yet (well, in the upstream linux) so page size mismatch cannot occur.

> What happens if the guest puts 4K pages into it's AMDv2 table and RMP
> is 2M?

Is this AMDv2 - an NPT (then it is going to fail)? or nested IOMMU (never tried, in the works, I suspect failure)?

>>>> If I get it right, for other platforms, the entire IOMMU table is
>>>> going to live in a secure space so there will be similar FW calls so
>>>> it is not that different.
>>>
>>> At least ARM the iommu S2 table is in secure memory and the secure FW
>>> keeps it 1:1 with the KVM S2 table. So edits to the KVM automatically
>>> make matching edits to the IOMMU. Only one software layer is
>>> responsible for things.
> ?
>> Does KVM talk to the host IOMMU code for that (and then the IOMMU code calls the secure world)?
>> Or KVM goes straight to that secure world?
> 
> Straight to the secure world, there is no host IOMMU driver for the
> secure IOMMU.

QEMU will try mapping all guest memory and will call the host for this, or it won't, on ARM? No IOMMUFD in this case? Always guest-visible IOMMU? Thanks,


>> Is the host IOMMU code aware of the content of the secure IOMMU table?
> 
> No, it isn't even aware it exist.
>   
>> Does 2MB->4K smashing exist on ARM at all?
> 
> Every arch has cases where larger mappings need to be reduced to
> smaller ones, but ARM doesn't require synchronized coordination
> between multiple tables.
> 
> Jason

-- 
Alexey

