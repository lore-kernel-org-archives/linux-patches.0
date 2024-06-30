Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBAE38382;
	Sun, 30 Jun 2024 06:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719728405; cv=fail; b=YkGt/g+YNF9QNsRMZ8+5IkinMszrLDrHDa8l/upeZdS5BdekiiGX80y/kxbTnbi0R4IstZgkg5PDBQeGYIz6Xv3S8Qd4rDS4b1nMbiQHmC1pZ8JOXvZ5qDNfaRUdwgqmJk9pmZLrDeZBth6fbtvmtVldAqLO0gGdSRibQHx3v+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719728405; c=relaxed/simple;
	bh=YoqkPzHwqKWjjQlVDwudqTX6yXtRru8PHWZP/fz9dSk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lPD0k19hApwxgdEj7ANhdeWVfwMt2HaGDbgKuRQuf2vaW5aAEDOiBTNylK7M98RZazMw4R2ht0aldqeiF2ObAhNyVVXfHFYfo1oMEBVMASsUt0tAz8EDZc46Z1btJxIOSUvpSHoDhBUfVwsRAIhpXOIqUoaqRZCv5D8Xt7gs1cw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DsS8V9H4; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DsS8V9H4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719728404; x=1751264404;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YoqkPzHwqKWjjQlVDwudqTX6yXtRru8PHWZP/fz9dSk=;
  b=DsS8V9H41jOrvq2HEhy1H62iSkvfJRJXee7H9s6gMDEQmumwQ5xdrFzy
   Oc9n6cr2AOMdzU00mQb0NlFzQ2bDJnNBzikUA2cC6ys9hFLzSnhvBPrJo
   +TGMCr17sipg176ZJu08eY8BsUqG1LcvkjKYgDAoFGzqWQWsYt6lN1rqb
   xRBnPQutx7GyeJe5R5o8HX5Nit/A/0Z2NeOj5DczbeftLMAGInH3DHN+F
   NRKXdTxI/ECXK8iPm7gn49HcQDPUujrp22LvEW1qJdYzrCHKmWkY97dnG
   QpkQ4z5f2bMFNXWRywlcCyWZGiLJkPQXL5B4Yn/J1TrJ1IdiSw5qdh10i
   g==;
X-CSE-ConnectionGUID: fm089eh2S1uvMNRJUeByXw==
X-CSE-MsgGUID: VdjVKg59Q5apjATpYGr5zA==
X-IronPort-AV: E=McAfee;i="6700,10204,11118"; a="17084835"
X-IronPort-AV: E=Sophos;i="6.09,173,1716274800"; 
   d="scan'208";a="17084835"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2024 23:20:03 -0700
X-CSE-ConnectionGUID: qgo2gsicTbWaKiwgwpeNLQ==
X-CSE-MsgGUID: i6KjX5Q/S8qqW8jok0oHOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,173,1716274800"; 
   d="scan'208";a="45274206"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Jun 2024 23:20:03 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sat, 29 Jun 2024 23:20:02 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sat, 29 Jun 2024 23:20:02 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sat, 29 Jun 2024 23:20:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=arKQF+/9c+v23xbQNd0S1XPZbBe/JfL1NlnKy3thIPpz20R/+EAO9CxHCuyFmzPodODXDxaTJmX8MUZFDQrGq18Sqa38aW6RvvDSdxfC6RnFqWMGG/obKVmbsEvvew/W0XqibEHcy03Cj+zX0rOfRSLx0P7A26B6UMPXWaAxOKE5T7++a9doHmTAzdGzI6V3fS+AGvjWxiex+osms7y4FxWzPNA+49cL0f4psIm3c4Nt4xPO0RpVl44UooFNTB17Zu/AvY1ByJB8m0WbSMp+WMfqLpWFW4ppiZeiDK4OzmQicm8C0uGyglTQCGg9uG+DJB29YbZXtp7qzoJ6K6t0yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N8Y+EXj5SQsr61KtxxkLucEFRyIJhvNzhKg5QDaupAs=;
 b=fQZIc9rUm1FnKfqqhtJC/mYh301XF+Gms0BL7banX83P254pxy6EQNwIoJwLY3iJkKLSlzOAGUFut3+34IeercU7lCgUaYfhceZRp/r/2+0LMvnRuVX+vxFk5o2396aoczWHI3zepbmDCSF0ZxABC2sf8pIM9xc2Z/awTpiYHLXU8L6xjsiao8FwbdrP7vQ3+HfnQpbYi76DzuWup14P2YIgg+cdsg2aRVrJhgY1Hu48sXQGRqCgYLt5DeqBvDzhuizfVoOjK8XuzhGbRDOu97Vx5kQ5NZt1/7c+96uAlcbYlChIpXwgWwVP7pbfd7tJt+Qn25BzcSQMLPmOihz3xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM6PR11MB4723.namprd11.prod.outlook.com (2603:10b6:5:2a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.28; Sun, 30 Jun
 2024 06:20:00 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.7719.022; Sun, 30 Jun 2024
 06:20:00 +0000
Message-ID: <bd249299-5125-44ca-9548-d6d7a7cb43d6@intel.com>
Date: Sun, 30 Jun 2024 14:23:56 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iommufd: Require drivers to supply the
 cache_invalidate_user ops
To: Nicolin Chen <nicolinc@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Kevin Tian <kevin.tian@intel.com>,
	<patches@lists.linux.dev>
References: <0-v1-e153859bd707+61-iommufd_check_ops_jgg@nvidia.com>
 <Zn8qpB6Xigupm+Ge@Asurada-Nvidia>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <Zn8qpB6Xigupm+Ge@Asurada-Nvidia>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0232.apcprd06.prod.outlook.com
 (2603:1096:4:ac::16) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DM6PR11MB4723:EE_
X-MS-Office365-Filtering-Correlation-Id: d5f00809-ff41-4121-80ac-08dc98ccabdb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SVRkNWVBRW5BOVVKaS9URmhQK3RLRTZIVDV5YWZFYXRyNzlXcEsrb0k4NFRZ?=
 =?utf-8?B?SDBBU0VTUWJYNytuS1ZYbURDSmlic1YyOFdtRlpHMTN6clNtcktCZ3U2blor?=
 =?utf-8?B?eitDTGRLMUhRakkvTFdaUmJiOEYzTEZRbWNSTDdvUjlFWklhbEpTdmU4d0ZG?=
 =?utf-8?B?N2hrSGc2Q1E4MXU0RG52MEpaL0lGMmk4b3ZPTGxHTHg4OHhHeFNZQWI4QWNM?=
 =?utf-8?B?dHlXMFBDcityOGRGVHYybmFNdW9KekZsM2t2THh5WkM0aGRvaFBHSVRSRmdt?=
 =?utf-8?B?cnBzZWVKT2xjVUdDYXJiVThmWEFoRG5ScE9oemdhZm0zZHY5T2d1NHJsM1V3?=
 =?utf-8?B?YlNOZ0lBYTJGd2hNSElMcFdGa3JYOG9rVTJWOVFlM2F6d3daM0JqZE42Tlda?=
 =?utf-8?B?N2hhYzlONkVzR2d1MmRpeDRCRGxwNHp2cFIxYk9mUWF2REZ1N2xoYXpZVXFz?=
 =?utf-8?B?WVhHMkNlbE9RQThYd2hWQXdDdUhsai9PM0pTNFR2UUtycW5LWE0rZVF1akJk?=
 =?utf-8?B?Q3JoYVM5YnJlYTkvbDZBNWFtZDVZaGl2Si81RkFtYnZrczZaMkUzQWNaZ3Bq?=
 =?utf-8?B?TlRwZnFoMUhmeVhXNVBtSE05Mi80UmtOd1oxVHZmQmI3TDdoS1Jlb1p5alJF?=
 =?utf-8?B?MHA5bERTS050RjM2V2MzOGpzUjdNMnJIQzcycHFSV05VVjJjNnBMNDBoUjl6?=
 =?utf-8?B?VWFYZEM1TUZJOUhiMU1EODhGZzZEb2U5VE9NZmZqTE9OMXBoR2grSm9KNkFM?=
 =?utf-8?B?cSt5YWJnQS9zMHAydTBtZnBlcHpOTEhWUk1SY2owQmIzMkVvdDNxQ3EyS0Qr?=
 =?utf-8?B?UEYxYldzZHlCYldpRGVqQ1Jrb2pRUjBsOEJSNnpyU3BGVXpZSFQ1ZUtST1Z3?=
 =?utf-8?B?YjRJbzFxRCtXa3NKNXdHU3hmOTdNdGFGN1lJNGVTbmcvMkxoQnRabExkaW1I?=
 =?utf-8?B?czFJQnRDT2hBcVcrZlBTdlloVU9uT24zayttZ3lIYU5OSzVoVjFKQVNRRWcw?=
 =?utf-8?B?MUh2NjZObm42K0FsSG9CNUh0WExTajJaTFl5UWtaVjVubEdnUkppeFYrR1E4?=
 =?utf-8?B?MXpVV0NocGltbGVBaEJjNGw1bXZCRjNLdURRTFAxbVcyaXlPMC9MSHB3ekZH?=
 =?utf-8?B?L0pvdHBwR0hrNGNLUkQzZ0ZoZzNYbTJZazV1dzB0VkVYQStjdHZ5cjNPR0lK?=
 =?utf-8?B?M1Z5NHYySlo2VFVLakZ3aFJPcEY4KzVmaEJTV0ZTNXo0THd6UCtOVlZZMW9w?=
 =?utf-8?B?L3ZiMTQyTkVkdDdlMCtmeHZLKzVLUUxpK1RzNnFsQWlzMENTKzZwL3plNFBX?=
 =?utf-8?B?c09KMjN4OFQrOUQ0NUVSVUx2czZlNUtpZUlPS2poVUd6Qks4RlQxTTRDZ2dF?=
 =?utf-8?B?WEEyUjZzcmlXMzJJTTRWQTJhT2JvVnhMN0VVak5PL1pnbXNuSU5YRER6blM0?=
 =?utf-8?B?K0dPL251Mis4dmZIeUl4S2ZxalNjRXd5aFBpanlOdndjMmh2QUNzSGFTbEo0?=
 =?utf-8?B?N0I3YzlaR0lCd2ZzTkFEcFJIbnhrajhLaFF5VEowVk1wU3N1RXF0akVXQnpC?=
 =?utf-8?B?cDZuMWZja3N3cHF6bUNNSk9XdGNWYy9HOU5LbVovem9KZlZTd2VwK0ttUm43?=
 =?utf-8?B?WVBOdkVzQXJEVWYyc2ZYZ3lMeGtiWmZST0hmOXZqK2NDcEF5NnJZbmNaOWpV?=
 =?utf-8?B?SnJEOXB4NTB1YVVZK3JSMVRxY1pBczJWY1NRL0xLQ1FSS3ZaOHhLRG03cjQ0?=
 =?utf-8?Q?DQusLKF37Yb0YppXfY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eU5PNXFZNmgxQ2Jrem9NZVVCdTRSM1lHMWllVW9yc3U3ZmlTQ3kwUGlnRXZX?=
 =?utf-8?B?ZGEvblZXUUFCUzVRUGFickFZdmxWQVN3YmxQTHQvZlp3eWJldjExRThleUg1?=
 =?utf-8?B?ZmRBOXIzOTAzUHRQcU9UZVBqUnMxN3pubGR6eFRyb0tsOG5ROFJPZ3hnNjg5?=
 =?utf-8?B?SG1TUWt5Z0l5UWdWWE1kOUJJc3pzYjBsVlJwV0wxVk0zWTcrTnFQOUJ0VlhU?=
 =?utf-8?B?WjhUalBTQjdyYkxmZzMzbmlvUXc1RmhVbW5UQWs0VWhBbllieE45d3hkRmx5?=
 =?utf-8?B?R3hFcEhOUkUxWDJOV1A1a3hGeWZGME13cFIvRWcyNUo3MmVTN0JCc01VNXh5?=
 =?utf-8?B?YWZ6YUF0dDh3VGVldXNCaGNIWlJQN3EwWDBaSXdDRENnM2xjNnFsb0dDdm5X?=
 =?utf-8?B?M3hOS0c3ZDM5QmxuQW0yc1JuQWlzWkpoZ251T2YzbTVqT2thQk5QT1R5ejRI?=
 =?utf-8?B?SFMzYkozZnRtR3EyWm9DRFNLSU1UUWZWRkJvRnhydnNBU0gwd3NDTXVqTnA2?=
 =?utf-8?B?OXVlYmJiRm5HR0VKVDRseG1RNTg5eHFWZW9rTWwwYWJWd1luVndPam5DVUNr?=
 =?utf-8?B?bzkwWlpuN2VOQXVwOFo1MDljM1V4K1hEUG1NUFVNL2hEdjB4a0FpTG5ZVllN?=
 =?utf-8?B?M3dKS3kyUS9sWEdNTU9PSE9keDdUUzJ1MnlqUnZ2NnFQSGlJQ09RNmRzRWo4?=
 =?utf-8?B?RVNGaFhPV3FzdGRLWkhIa3MrNG93MG9sbXhadzVBakpmRzhUWFRHbjZ0YU83?=
 =?utf-8?B?WFhMeXpsWDFqYnVVY1lORFpiZjNCcHArS0dheVRxQnlCNUh6VzA1R21tQXRs?=
 =?utf-8?B?N0dQZ0NyaGFXVmhzNFYrVjdlVDZuNThqSk03ZU54dU1uR2lmTWJDdzlLNTJi?=
 =?utf-8?B?RWxxR29qZnI2SVp6UWhNb3ZuVnd2UUJLRS9PU2sxWVM4QWlkbE5SUDdQVndV?=
 =?utf-8?B?NEFhc0pJbEdQMlU4WE5QVzBDYmFzTjVFUlk1OVR1cXgxamlYK1ZKcFU0UEpB?=
 =?utf-8?B?blJCWGErRjN0QlVaKy9FOGdCcW5sRDZqNm1iS2IyNWZRTFhrekNtNnlPaEFn?=
 =?utf-8?B?dUZlN1Roa1gycDlFaXVpMS9ka2htd3c1RjVXYW1pUTN1OUZ2RDVOQ1FiU1F2?=
 =?utf-8?B?ZTNPYm1EcEVjUHk0dDArMlVkNlVHckZEZFBUUW8rQVFoUmo2ZXdCcVBQK2ZK?=
 =?utf-8?B?bGQ2MkxCRzl4Y25iWEZ1b1Bad08wT1FDTW5NZ3NKME9OZWZxQ3J4RXVabW1j?=
 =?utf-8?B?VnpIcksrVkY2MURoUnNaaGFjeVJJcEh4TVR1QjBHejJhSC9jZ3F4UDF3VDdw?=
 =?utf-8?B?R3FsREs3Qllna05iL2REM2xLK21tVTJvRm5TOFRsQk5HN1liUFVVQ3lLbWxs?=
 =?utf-8?B?SkwzS2h2VEhrSXZwYWZvODhzSnhHUUprQVg0MExySnduUjhEVk1hb2QrSVlh?=
 =?utf-8?B?SXBhTVp0YlBwWGNyLzJSYnB2bGJCNEdXUkUvbkpzcUdoamN2SGRSWFVOeXpE?=
 =?utf-8?B?SENkMG1Uby9Cd1ZHRUI4eXlvZUlPL05uRzljbkIvcDJIcHBWNjFGWE1vdGJ1?=
 =?utf-8?B?U29HM24xNEh0SVpYSUQ1VjI4UE1ITDlCQSszUGg4Rkwvbm5ML1RHL0V4Q3JY?=
 =?utf-8?B?RWtMeEU2b1RtVEt3eTE1MXVSdUZiaFQvNmRoTk5TeW9ocVAwY2VVRGE3ZUZm?=
 =?utf-8?B?N2pCem1Da1dhVVFZRTgrTy9KamtSYk92T2tvdE5LdjNCODZOaWlxakhpUXZI?=
 =?utf-8?B?Q29iRVlMTzdDaDNYNnFDTGpZaG1LbFlvMGN3dmo4ajhzQVl4b0hqczZ2WWFT?=
 =?utf-8?B?ZDhkMk5OVjVPdUFNT09FUlJzT1pRcHZkSzdEZVhBUEp4N2dKUVlxRnA0QmZR?=
 =?utf-8?B?eThDdytjZ2laVE1vWkszSHdOUkF5ZHBSOExZaE1XckxEUlRpQXJ6MW4weTk5?=
 =?utf-8?B?cHc2eXNDSldHeVRTMTlVQXVIS0dBYmpCdXJTVThLOGxJZmlMeTN2aXBxdHU0?=
 =?utf-8?B?SmtiNG5Ca2xweU80YXNZKzJaaEhPa3Zic05VRG9iRUsvczJMVDRkc2NKTTd3?=
 =?utf-8?B?S3lWL2cyNVJaU1U5UHF3L1FnanJMdEFlQ2kxcW5EbUpEZ0xEYnIwWU04MVI2?=
 =?utf-8?Q?smRBLi98bwdK7SHShCf1pj1DD?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d5f00809-ff41-4121-80ac-08dc98ccabdb
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2024 06:20:00.6612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LvqEjpfIwJExAov5eu/tkAQRN0rTsWr62cX9QYtQ3usjTtzZq/6horvuEbuSP0Cw/sMWCQggwgPw35V/dQFIWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4723
X-OriginatorOrg: intel.com

On 2024/6/29 05:27, Nicolin Chen wrote:
> On Fri, Jun 28, 2024 at 01:11:11PM -0300, Jason Gunthorpe wrote:
> 
>> All existing drivers implement this op for nesting, this is mostly a
>> bisection aid.
>>
>> Fixes: 8c6eabae3807 ("iommufd: Add IOMMU_HWPT_INVALIDATE")
>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Yi Liu <yi.l.liu@intel.com>

>> ---
>>   drivers/iommu/iommufd/hw_pagetable.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
>> index 33d142f8057d70..a9f1fe44c4c0bd 100644
>> --- a/drivers/iommu/iommufd/hw_pagetable.c
>> +++ b/drivers/iommu/iommufd/hw_pagetable.c
>> @@ -236,7 +236,8 @@ iommufd_hwpt_nested_alloc(struct iommufd_ctx *ictx,
>>   	}
>>   	hwpt->domain->owner = ops;
>>   
>> -	if (WARN_ON_ONCE(hwpt->domain->type != IOMMU_DOMAIN_NESTED)) {
>> +	if (WARN_ON_ONCE(hwpt->domain->type != IOMMU_DOMAIN_NESTED ||
>> +			 !hwpt->domain->ops->cache_invalidate_user)) {
>>   		rc = -EINVAL;
>>   		goto out_abort;
> 
> Oh, we had that initially, yet lost it when splitting the series.
> 
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

yes, it was dropped in v7 per a bisect concern as well. :(

v7: 
https://lore.kernel.org/linux-iommu/20231221153948.119007-1-yi.l.liu@intel.com/
  - Remove domain->ops->cache_invalidate_user check in hwpt alloc path due
    to failure in bisect (Baolu)

-- 
Regards,
Yi Liu
