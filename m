Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D3A2AD00;
	Wed, 19 Feb 2025 13:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739970499; cv=fail; b=ThOKsNO8twhGnVaLDwVPYvOKjeO5WWeCPSCvCqmng1rGyBfkBFpEmevsOdGMGmUKb3moFXB0yES2QdkuMoSwseu5pQ8ed+f8AhzdIcR8ELcDEA0vQEHwVNOBguCglmLpdifFCk8/kI5DpkKtRooeStKXytG8KhBBibZzjeZvzuc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739970499; c=relaxed/simple;
	bh=nKB48RH193FkgC3eR4WFbpHIdeKOGW0lca0pUkSKFgE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oPMaOYFSVVoBuQxGeLpHWCEsoiqcRyKyxsTZhC4BvUwoQ9fiQd7Dyndmw8qnSSu2+BCLlVpaManSXpRRUPx5E9QUmkuQ9eIdJ8RgE1ry6U+tuGXuSO1HzPiEipZkHzRNqQqhUWFVH4qJbNuVL0QpSdIQuZHr3g2qG+ib2pk34TY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bxR0skp2; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bxR0skp2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739970497; x=1771506497;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nKB48RH193FkgC3eR4WFbpHIdeKOGW0lca0pUkSKFgE=;
  b=bxR0skp2LJKtLtBELw8pA4JIz+fkWKxQnrVn3+YqarIjV5Gtg9cs6rTn
   SnTJ48urd6PWBZcoJm1xtIYC/6+xlFRig4i0tR8QpJds1zOEoQFGQdQyR
   9/uIKo49Ct157ZJUPyA6DiAGCFq1YD/XS3pu6gKXdtg+B4Ezaa3DfqrsO
   UtrxdeCwdSgjTL9K4c/biDFGFXo9zrcu5BHNymAi0LKMb57ls6pLQ54K/
   b8mB8K0BddYOrsBEaM/Ni3ABjElFvutiunNX3uAnUAWqeMOm3a/UEs76j
   0Ud7Caa8zLiCidVzbn5gvw+dD6kcO23pfFhHxjgfLs2aNP5zs0GCIE3B7
   g==;
X-CSE-ConnectionGUID: OfCFU7LLRjaqqsauSH6C1Q==
X-CSE-MsgGUID: lxWXKDUVQN6ovYqg6H4DDQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11350"; a="40570177"
X-IronPort-AV: E=Sophos;i="6.13,299,1732608000"; 
   d="scan'208";a="40570177"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2025 05:05:10 -0800
X-CSE-ConnectionGUID: s6Fpd8fZRui9mGgMEqx8/A==
X-CSE-MsgGUID: QLDm/2MORDa/+7PuDD2MvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="114575773"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Feb 2025 05:05:10 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 19 Feb 2025 05:05:09 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 19 Feb 2025 05:05:09 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 19 Feb 2025 05:05:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d3OLi2EjpZq5IuxcNZD4/L8kXQ36aSsQ88zvHHFrCC5vKLtkHdoto3SGW3IlskN4w/hdXQMe4e4vhW+Idqm60ay6nBSFxMBpDcQZyK1bscp3KwxDQsJRskdiTOWsvStCijKm8qLfo8SiuuYslZxak6cf9IEYFzaLmbjaF+yUbCONRPF1o6IUqXvsvXzZe1Zqn3wzlVyWdDjnCrFNsJ21c1gAIG5uN09G4pn2l7MEVDv0e4jRvW7D1K9+1ronAr9VKMqUjLs+5LGmaN5NNeBoSc+nzvBO1YpJe7FMMTRwLmMYWTuyIXKrwiTNj37vkbPgocCIYbkkO7FKNlmWgY6D/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3WdnEm/2UnQ8DEXG8ty/s41ik4x53PLTtEm0+TOvcXA=;
 b=HGXg0y6wQ4SfZA3ibJib+9pd7r+sROHhL5NjS81yh5A7rsZLUqH/TF//E8YwzQ5s4bJTo7qjpqzoKCY3aJCNmyBVIGEUW8+CE7r2uLbqAgCA6nY5qZa4nhrSfuG/aKu+nz6DjTKFAnNklWmvMV5MllFO6OYJEZXG+6ZKkSdzJHgR2/VYVvWaWSAhbpR7Eq+qdNqYC0ElDRAWNgawoamUgZs8q3sAh0Op9JcM9Hvf0Y6UZvrU2wy0Oz6M0Az1OpFkAB6M+QgtSwuxWUhnWQr+PjkGLKFB8Zg/YjX4P7BXsII6BV4fqxf+FdfEhPbTQpDAPKT+AFCLYKv7+71Cg5MarQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CO1PR11MB5028.namprd11.prod.outlook.com (2603:10b6:303:9a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.14; Wed, 19 Feb
 2025 13:04:54 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8445.013; Wed, 19 Feb 2025
 13:04:54 +0000
Message-ID: <fe031eac-5ef8-4ba2-82f1-6a6705b2c41e@intel.com>
Date: Wed, 19 Feb 2025 21:10:14 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] iommu/virtio: Move to domain_alloc_paging()
To: Jean-Philippe Brucker <jean-philippe@linaro.org>, Yu Zhang
	<zhangyu1@linux.microsoft.com>
CC: <jacob.pan@linux.microsoft.com>, Easwar Hariharan
	<eahariha@linux.microsoft.com>, "zhangyu1@microsoft.com"
	<zhangyu1@microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>,
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, <virtualization@lists.linux.dev>, Will Deacon
	<will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	<patches@lists.linux.dev>
References: <0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <3-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <20250212112235.714b0a14@DESKTOP-0403QTC.>
 <20250212233053.GV3754072@nvidia.com>
 <67ad876d.170a0220.3c21dc.85ceSMTPIN_ADDED_BROKEN@mx.google.com>
 <20250213094601.GA243081@myrica>
 <5irmuy6xwrjsrdjy7tmfzlnotxqdoqagjdsdtqjrrit673zaka@r43nyvc5gcyf>
 <20250213180919.GC243081@myrica>
 <cu7lznx5bxnqoavt3ri4dtzwt7lu3loitn7a344rbnmahpnc6h@2e2dknchxjmd>
 <20250219103518.GA513544@myrica>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20250219103518.GA513544@myrica>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG3P274CA0010.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::22)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CO1PR11MB5028:EE_
X-MS-Office365-Filtering-Correlation-Id: fa2b2c28-4581-4820-6b04-08dd50e6009b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OE9OaklOUUFQaEtpSnRMUkNmR2ZDYlZhQzNod0RZSUVvbU5rWFBUNnFSZVgw?=
 =?utf-8?B?dnk1NTlaS3E1bXIybWk1anAwb0xuZjZ2S1JoSHBTdTBTeVFoS2o3blRkK1Vt?=
 =?utf-8?B?dnd6NDc2NGdnWjRMRWxlaldYNXJ3NmNVem5xMmhVVTZsaHNyV01rMmV4bHdL?=
 =?utf-8?B?YWRlTFcwajV4NWJYWk9ia2pNUjY4dnEzNU9TTGpqazlZOURsSXZTR0lxN3dR?=
 =?utf-8?B?eDdHQlZnYkdCVkQvdU9HNzdNMEJNVU9VbkdLSDJPbnRlRXpwME4xUmE5QS9l?=
 =?utf-8?B?cXRmTS9sSURQTFBLU21KWVp2RFJkMWhQNHVwd0xqYzZVQ1N0dGtROU9kenFX?=
 =?utf-8?B?QjZ2MVN0Wng2eTdnZldGbUNCN0ludHQ2MXN4L2ZxNjFQbDdCZkJtMW9aODZl?=
 =?utf-8?B?bXBTQ3QyYm9ENmR5UGR5dTB5Y21vUDBkWHlXODJXaDRkaWt2eDdrRFNXYytz?=
 =?utf-8?B?OW0vK244LytOK3Y0cU1QK2dEL09qQ1lUT1dqWFRhaXhrUzlCZisveW9TMGhq?=
 =?utf-8?B?WkVOcVFYSHdlTTJmbG4wQVducmx0UmdicjR0V20yTGVrUzRFVnpvTGhWaGRL?=
 =?utf-8?B?ZTBSRXcvcHhhZnMrRDRQV1RtQ2NZbHZaYnpjSitoUjM4MlpIWm9nbFhDN1FR?=
 =?utf-8?B?V0o4Y0diRFI5aHd1bHdmc0lOSHlJRmNJTWVmUmtRN0Y1bWVHZEpIOGpXZllC?=
 =?utf-8?B?YlBVdHBQYXJhTnIzWXVsb2xramdqUm9LTTM1ZHg1REhqQ1kxNHdPYUNCMGRr?=
 =?utf-8?B?amlEbndYcDZpNEtQVmErUWM1bVYxRHV1bXNMdHpRRlJhYjRlN3FURkVpWVVx?=
 =?utf-8?B?enRaU0dhNXI4VFNKVFRtWTZBSXlsNFJGNWNDMDNsY3NzdWdvcmJuWG8xRlBT?=
 =?utf-8?B?Rm55cjlZL2ZJWTRkeGxEYk1qODROKzFYRTZCelo0eE43MXdpYjltcDNpUGo1?=
 =?utf-8?B?VUJ5Tk13RzVDbUMxNVFBV1Q4NnpEa3I5NDZEMkVNODdEazBUZnptK3g3TGZW?=
 =?utf-8?B?VE9UY1kvQkZaQnhlY0ZuK2U2OVRzcURxYzVKMllrTjFoZXJ2dHhvWnowaWN3?=
 =?utf-8?B?OWVOTXRRRDBTTUEySmdvait0RUZzbkc2OEg4REd3K3hLSmxKS0oyTnpHcUhj?=
 =?utf-8?B?MUt1dkI1VXo5a01qMUJnNnkrb0RodGpxSkduQUl4R3ZEUERkOHFTTkd2VXRp?=
 =?utf-8?B?cUdVejJLQ0lwQWhnTW90ZWpXeWVzL1hzcE5QeWVqbFVXc3JZWFJBLzdVZERP?=
 =?utf-8?B?aktDZVZ2VzRmdW0xb1ByWEt3M1FNMGV6OGZKZi9DbzdvOGJPVGJWR0hjcitU?=
 =?utf-8?B?VXZyckZOckZEVjk2VnlMbjBtd1hWM3NFWktaTVNTYVppRm5mNjk1endMbHpy?=
 =?utf-8?B?eDVFYWJMZEl0MjFKUjJEUjRMamNrQ3hwVC9saEkwUk1qbUhlbG9jNWMyZTVQ?=
 =?utf-8?B?VnUwc0VtaWJkWlM5ejQzcUxTd3RQVjFxSFJ2SWZheWxTTUwvM0JDZXN3ZDNY?=
 =?utf-8?B?azlOR0lFaHZqMVR4VWVIQjBHdTY2NzZ6ZVY5TkdNcVZISWRzQ3k3NGhyUnN3?=
 =?utf-8?B?MnAvbVdnNXNZZXRIYnd6a1hVeW9mZEp2eDdwK2lVTHBuREpsZ1hMcUdodGxo?=
 =?utf-8?B?MUNHcTNHUjl1M1dTVUllTkQ0OE4zU1pSMlZQejR1a3NLRzA3RmdlRnlRRzFR?=
 =?utf-8?B?SUFNS1hYaGRna1JZdW1yakRxWDRVWmFSclZaaVc0MElndXlJWG9aYnBhWjdq?=
 =?utf-8?B?clJrc2UwVTloK2Jub1NGc1U4Rk1HUE40RHNDQW1qNlNablpiS0RsTkNyUVk4?=
 =?utf-8?B?RUpPd0hlN0xHemk0R2dPQVVSc2JWcDMvVGIrQVFiZWRWdXZZMW9FQ082WjRG?=
 =?utf-8?B?dEdiRXpoaWN2Si83Q09yNm1NeFJueWEwVTZRNGJMc0NaTnc9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QlR2cWVrVG5DY1lyWDFJZlNmMHZnZWV2cUZqN1NyZHZVL1JkZzBoUGlqYVow?=
 =?utf-8?B?QWJSaGxMRWIxQ0lzQkxVZWdNNHNmZkhGanZzL3YvL2VLeUtDODVROW1DbzU3?=
 =?utf-8?B?RHkvdjdvb2toN3owL3g2L0JwOTlPQTRheVArK0ZhSVA5TnA3M0xSZUQ4S0lR?=
 =?utf-8?B?VGQ3dHcyN1Vpa0R1NDdUNGhodTF4NGxWNGtTUXVqd0tHYjE3a2g0cGVHNzlE?=
 =?utf-8?B?UEJwY05nSm9WaDdVcFEvc0ZyVFJlNG5jY1UvcXhCQmZQL1hMcEFUTWZ4cEFU?=
 =?utf-8?B?NWtReG5zN3pwMkllNTdvL25abkc1UDVEaWpLUTVqd3lPaWtDOWpIYVFzbWZC?=
 =?utf-8?B?cnVyUDNGVHpaYlhOOHJ0VDkxYnFHaGM1bXNyaWM2QlBHYlhla3I3NEZ4M2dt?=
 =?utf-8?B?VDdIYkJGKy9jNjl2RW9sNTUvN2VmVC9zUndsYnpoeDhPQzRzenBvVjBsVWtZ?=
 =?utf-8?B?WWNZbkRhdmJXMWd1STBBSk9kc0tqSHRpVHhIS1lORTZwMFNOekhTbmpmSDdr?=
 =?utf-8?B?RXdwSDdMNHArYlc1TkdJWFpoaG9zMzBBZDNVaU5Cek5rQTVkUEpSOVp0cmwz?=
 =?utf-8?B?U09nODgrZDdaSWZJeHVLME1SZWNnQlZWSmF3RWlqOTZLbzVKUzZyczBFNmd5?=
 =?utf-8?B?c3l0bGFJcUkydm1WWlkwUnF5T1J2eSs4dmlac3NUYlFUdFlRcGhIdjhocS8y?=
 =?utf-8?B?cXZQTHFDZkVxZnU2cnpSc2xjRXpIVlZ5TkpxdHNyTlN5UmhISURLOWJkQWI3?=
 =?utf-8?B?T3ZoR1A3MkVJUmdaVzYzUmlBSmdjaFZyVlVYYTlRTFFTSGR3ZWk0ckNQMElW?=
 =?utf-8?B?cExFcXZLRUdpY0Nacm45dEdHZkxLeldlMWJPd1IxVElyR0FIRWZqNWJDOVc3?=
 =?utf-8?B?eGV4NkxGMllkTTdHRFFueVZOVXNMNlZjVkU1RlYxWnhOeTY2U09uM3V0aXJi?=
 =?utf-8?B?Vm1QMTZEN0J4WWprQzJHQXJKMU1TbWVqRjN5dkFlR2xvV0Uvc2VaN2lUbDdY?=
 =?utf-8?B?QnZ0SW1IM0Z2M3hRUVpFVU1VOU42c0ROZW1Ib3lpWEtod3REV3ljcm81aG9q?=
 =?utf-8?B?clpSSjhYcG05NndkUit1bWFHRVNtTHhCSUhjcFRvNUJFZXFaL3lZRyt2eTZO?=
 =?utf-8?B?NGUzcDJOUjhDRE8zUDlVY0RtS1E2dnNaNTByL3dZQmxCMGJNOFFSQTRUWGYz?=
 =?utf-8?B?d0hPTERYUzBNVGJjcUtVY2U2Sk9hNVlJaVRaNy9rUCthdTU4QityOGtmTmk5?=
 =?utf-8?B?OFBmUnNDcXRCK0h4aGVVWlRwK0lJbE1rR2NsNXkrYzhFeE53ZHpkaURocUNP?=
 =?utf-8?B?cVoycnYzeG5NL0NSa1E1cUlpWVVkUzc1UWIwR3FRS1hhMUhjMUhTMHJCZWNp?=
 =?utf-8?B?TTJ4L2duT1VOTVU0T3QzaHczWVdVSkt0VkdXa3htTGRvUnMxWmhscUhtcXBo?=
 =?utf-8?B?UDJwS1VmdWxtZUZ0dDlTVFh1ZS9mclJ4bCtuMTZpeHBlME42alA5L1FacSt1?=
 =?utf-8?B?RnBjWnozMTQzbTBscjVpME9LWTNwbGQ0K0ozVFBZZERjTnU4TVgvdEpEZlpM?=
 =?utf-8?B?SHlrQ0hlMmk1N0dNYzJiam1nY0xZMzhGVHY3VlVvTmM4NWVqSWxMMXM3UTJP?=
 =?utf-8?B?WXFTdHVSZFVFZ08rYmJ6elZ4NXR4WW5nRS8xWEZwcFljdFNTdFk1WUl1ZGY1?=
 =?utf-8?B?ZHYwUzVDMzJGaHVINmVTTkdXUFdubGNWOHNWTTVkOXZYUHJwNWl4OWQxelNv?=
 =?utf-8?B?QkJ2WmNHSGZVVTBzckhydU5WS2IvbGtBa1JIbWJoOUFpbWk2WDdlb2s3bEFZ?=
 =?utf-8?B?WGFJd1lrN0pUVmUyVXJ0UnI4UENKbE1GOWF4NU5HSlEvNnE2Tm8yOWJ4U1ZP?=
 =?utf-8?B?dURVeC96Zkw5REpvSHZrYUxMb0llYUdEcUVNeGJGZFl0ckRlbUZYbUlQRXVX?=
 =?utf-8?B?UGhFcnBWeC9LTy9TMzk5aEk4RU5VK2pnaDZyeDZtY3FEdDlibUJCYVB4bTBZ?=
 =?utf-8?B?aDcveW1nVDBrZjlMZjBPeGcxa2loVEdQbVM4b1JZb2F5WStZWmJub2hza0hE?=
 =?utf-8?B?UHA0ZDZxSEVpTFVoSS9SSlBOYjUzWWNiLytQbkJZeTBoa0JzaFV0UTBJdW1L?=
 =?utf-8?Q?K7EDLBvZaTBk0WHyR8v5C+epC?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fa2b2c28-4581-4820-6b04-08dd50e6009b
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 13:04:54.2598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qd3oPuFuv6VkbLAadx9S0LkpiJCUfIKRWEKYpDVdIkozZazxroWN/40VtH3HOgL+CQRS1jHwt1sBPL01kYkOrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5028
X-OriginatorOrg: intel.com

On 2025/2/19 18:35, Jean-Philippe Brucker wrote:
> On Wed, Feb 19, 2025 at 05:39:19PM +0800, Yu Zhang wrote:
>> On Thu, Feb 13, 2025 at 06:09:19PM +0000, Jean-Philippe Brucker wrote:
>>> On Fri, Feb 14, 2025 at 01:03:43AM +0800, Yu Zhang wrote:
>>>> On Thu, Feb 13, 2025 at 09:46:01AM +0000, Jean-Philippe Brucker wrote:
>>>>> Hi Jacob,
>>>>>
>>>>> On Wed, Feb 12, 2025 at 09:47:23PM -0800, Jacob Pan wrote:
>>>>>> Our code and backend support are still in the early stages, that is why
>>>>>> I am attempting to convert virtio-iommu driver to iommu_pt. Not sure if
>>>>>> anyone has done the QEMU part to support VIRTIO_IOMMU_F_ATTACH_TABLE?
>>>>>> @Jean @Eric Do you know?
>>>>>
>>>>> As far as I know Tina worked on this most recently:
>>>>> https://github.com/TinaZhangZW/qemu/commits/virtio-iommu/vt-d-pgtable/
>>>>> https://lore.kernel.org/all/20231106071226.9656-1-tina.zhang@intel.com/
>>>>
>>>> Thanks a lot for this information, Jean.
>>>> IIUC, these patches were trying to add VT-d IO page table support in
>>>> virtio-iommu, but it is not based on Jason's generic PT [1]. Just wondering,
>>>> does anyone have plan to do the incorporation?
>>>
>>> I'm not aware of anyone working on this at the moment. Something you will
>>> need for a portable pviommu is a library that manages PASID tables rather
>>> than page tables [1], because the Arm SMMUv3 arch only support assigning
>>> PASID tables to the guest. Alternatively you could implement opaque PASID
>>> table allocation via host calls, letting the guest allocate GPA space and
>>> the host manage the PASID table, but that idea didn't seem very popular at
>>> the time.
>>
>> Thank you, Jean. Just had a study of the spec. For ARM SMMUv3, letting
>> the guest manage the PASID table, and then assigning it directly to the
>> backend in ATTACH_TABLE request looks quite resonable. But for VT-d,
>> my understanding is the PASID table shall be managed by host. By "that
>> idea didn't seem very popular", do you mean that people also want the
>> ATTCH_TABLE request for VT-d also assign the PASID table(an virtual one
>> managed by the guest). If yes, why?
> 
> No, the proposal for managing the PASID table in the host was done before
> the VT-d architecture added Scalable mode, so at the time they also had to
> assign whole PASID tables to the guest and weren't keen on managing it in
> the host. I believe in revision 3 (2018) the architecture added support
> for Scalable mode and the ability to manage PASID tables in the host.

that's correct. It was called ECS mode and has already been deprecated.

> Nowadays it wouldn't make sense for a pvIOMMU to manage the VT-d PASID
> tables in the guest, because as I understand it there is no demand for
> supporting the legacy mode address translation of VT-d.

Conceptually, ATTACH_PASID_TABLE does not suit here as the PASID table is
maintained by host. It may need an ATTACH_PASID thing which is triggered
per guest PASID table entry setup/update/destroy.

-- 
Regards,
Yi Liu
