Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3884140E34
	for <patches@lists.linux.dev>; Fri,  1 Nov 2024 22:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730498893; cv=fail; b=s3/3uuGNiSjl8aGsYZv4Zi2ggyZabYMZbKSylA84uK+KaVfw2srcDQnPtmIRbGhmLHMFZ23gk+3xPuFYiJ2nw5GRbX3RmbIUs5CjyANgrSyzEd3aiETyF3tRsIAu68MALwGvUPKY1M5Na4Bh8HG+l0kM28dGJuBKYQKJAncFI/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730498893; c=relaxed/simple;
	bh=rZd1J7goQ7G6VFtBcN9JsOzl46u8mCYzw9NmdBKov4I=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=o2rJLOBudUC+az+VmnfBF3aCqqAuDC2ckG83eGpCh2AiYhwK8uY+7JiG9eg3spvySfXFucQUCx+kmdIQcpsbX2Bpr5qKZPLC/cyGTDJMJTENQKzW/TfTALqTV90gSklwSPIvUMplfwKw728+BGZl17k90jtL/qY/JGanI0XHRJk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Aw2zj7zT; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Aw2zj7zT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730498892; x=1762034892;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rZd1J7goQ7G6VFtBcN9JsOzl46u8mCYzw9NmdBKov4I=;
  b=Aw2zj7zTzXuVL/mAGBiwoo7tLB46roVzKFgQIvuSc9oNWbJSsN46VE8W
   7PLqk6LBlv2XbIbHFPkWZ+P4IqPCibsqTrqhUH7QQjhjs8Ohpo8rynLWN
   HXJ4FXM+WNKxG5muTcn52Oz19e/X/VzZXgiOsHreNdpOHEo+gTA8ywXBw
   4+6kTHr5sB6bNlSpSHwyBH5iM4pc/aDPWtjm6aeY7a7rVNW0CNcByKHLp
   7zAkcPQtITAWlIE5aVAtluBKBPQMzepO+WWOkCiOxEhFZRdW2k8p5wJfv
   BsoPIJQ1LIzFEJFNlG//7fAOyXHx3i0233BWtKFT26k8pMRnidUCkXyJ8
   w==;
X-CSE-ConnectionGUID: QDYW2ZSgRm2Kn1//5cMUuQ==
X-CSE-MsgGUID: fqGL+6glTeGmyLfeeWLGdw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30044466"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30044466"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2024 15:08:12 -0700
X-CSE-ConnectionGUID: BKPP6md+S52maCrlxc0bVQ==
X-CSE-MsgGUID: TkiX864NR6yOtvKuOcyevg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,251,1725346800"; 
   d="scan'208";a="87611915"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Nov 2024 15:08:11 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 1 Nov 2024 15:08:10 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 1 Nov 2024 15:08:10 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 1 Nov 2024 15:08:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ACiHoQZ8C8imqwUH7ByjI6lKseuI2yZPL1sj0FCmgnotX5xOVWQ1XK5SIqURMZ92iOVP8THO/S6g/Gzw/Rpg3VE4PNKrUy0UURCzJhLxwjNumagrkzeHFL/2JOH85cO6mQK/iyhFAdl8YZ+ON2nlWRAJwOZjhreg9qaXnetk/qq3FcaOPslgtrqZUM/LPRThfQhV9Rt5kpzRkpZ5IWbCcNNMhQiSPfjgooEKEDl47714lmuoRgYpfLTHk+bGekMG3O1GWl+imQoqymBKfj7vkTLNWtNyAp1qYiyLNrc3UEXgVAR0XPstbHjhma00Yap/lD0WVi74L+DVPcAdqFyjzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=84TwujXyLjn0IYgeMhiYdt1w9u3bV6bA7Xmi6XlyqlE=;
 b=s4n9f2lLwqe3VIM2a3v0VNTv5vt1euZIFXAjsgfVm3PWCI4FDmFGpu0D4JiXG/C+4fngAApq9KTDyj0U7+g+iaGVfXXNgaPZbT4NJENd3MvUmp3M1lrWaOdT2wisN3ZSJfSlZX3isWy2vguTzDMlk1FfMnixbmCcWTfJLXRFSNoocTsmwTNuFu6+1gOgJANu02NmDnXs3Pzz7N9shWdMyJjFcexCrxTQrKDGz9q/EpACQddm3NOhtc5sqnc+aRstrVeZcqXqD4KxS9JalBpYz0BX0AlAPrMtx2ur6h4uHHmFU8RkD112yEykmVedZGG59RnVnRHZz0MGscAFJ0i4QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB6097.namprd11.prod.outlook.com (2603:10b6:208:3d7::17)
 by DM4PR11MB8160.namprd11.prod.outlook.com (2603:10b6:8:189::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.20; Fri, 1 Nov
 2024 22:08:07 +0000
Received: from IA1PR11MB6097.namprd11.prod.outlook.com
 ([fe80::8f29:c6c9:9eb2:6392]) by IA1PR11MB6097.namprd11.prod.outlook.com
 ([fe80::8f29:c6c9:9eb2:6392%4]) with mapi id 15.20.8114.020; Fri, 1 Nov 2024
 22:08:07 +0000
Message-ID: <2ed76893-ac65-d9a2-aeea-c927ebd2a1e8@intel.com>
Date: Fri, 1 Nov 2024 15:08:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH v8 3/7] x86/resctrl: Refactor mbm_update()
Content-Language: en-US
To: Tony Luck <tony.luck@intel.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Peter Newman <peternewman@google.com>, "Jonathan
 Corbet" <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	<x86@kernel.org>
CC: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20241029172832.93963-1-tony.luck@intel.com>
 <20241029172832.93963-4-tony.luck@intel.com>
From: Fenghua Yu <fenghua.yu@intel.com>
In-Reply-To: <20241029172832.93963-4-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0189.namprd05.prod.outlook.com
 (2603:10b6:a03:330::14) To IA1PR11MB6097.namprd11.prod.outlook.com
 (2603:10b6:208:3d7::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB6097:EE_|DM4PR11MB8160:EE_
X-MS-Office365-Filtering-Correlation-Id: 4eaea0b1-bff2-45fc-e622-08dcfac1aa71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YkJrdjhkUWhTR0QrVUZxeWlENjJIUUVSYjVZclpCVTk1ckRPTDdlVlhJQ3J2?=
 =?utf-8?B?WnJBYXgrOWthL1g4blp0ZzhTVWpkWWYvSFRmUFJGK1ZkS1ZnQ0RpU013R0xi?=
 =?utf-8?B?a2R1LzlibXU1ZWdkNEFRZHNKaG53TDIrVVozWlRGeFlBQy9oYmptMUsvYjN4?=
 =?utf-8?B?RExQSE4vMzJ2VzJIMTlCRXIzUXRzeWZ3Qk5WZkJmeFN6aE8yZVhQcGFrZjNm?=
 =?utf-8?B?cUhJRmR2Y2pHd0d3WGZwMXFCVnZhQ0RzVU41ZXpOb3NWNlU0cVRlTHBSdTRJ?=
 =?utf-8?B?eFhvYVBxVWhqaEVZSml3Qk92WlhkRlNtUFdUVktVTGErYXVKa3dKMGxmekxM?=
 =?utf-8?B?NmNmMWR3NFJ0RG5pVWg2OVRUSERnRjA1R2VjOE4yaEV5YU1JRlJBRWtIQ0ox?=
 =?utf-8?B?ekJQYTJ5K2hLNjJGZGNtbXkyQzV0WG5sdlZyR3pWZ3lxK2Q5TXZhbHA0bnl0?=
 =?utf-8?B?STRNNFptenZLYVh5SWoxbzlJQjVQSUVaV2VCb2RKSlhUUlJsUm5DK1RkNVFi?=
 =?utf-8?B?Vk51WndYZGtVcXdkZG9XQTc0MmtnVGRYWmdJaG95M0tyTFE2ZGlkSWZ3WCtz?=
 =?utf-8?B?ekphR1djYWpxN0hDUUIyZzF3RnRRQkcrc2hkMVlMMG9FeWhEZDNlUU5vQXN4?=
 =?utf-8?B?S1JTUzk4S0hxenpTcVZ5OVgrbnA1WnN1LzcrNjJpdTZ3b2V4aG0wU0JzODVI?=
 =?utf-8?B?a2Q3dCtmVEUyRnZWZm5BZVk1M0grbGhPcEZmYkxXck5tMXZNNHNxaXhkRUkw?=
 =?utf-8?B?V25FckVGQ0daU0tqVkdPeGxVaTlPazVJc0Y3MmVBVDZUVjFuL1krRzRaYmhx?=
 =?utf-8?B?R2cwdnV3MVhkeWxPZFVTazlyeWJkRFh5MkV3ZWVITHFKWXhSaFhndXZQM1V6?=
 =?utf-8?B?d2hrZnVLdlViNmFiNDF5YjFLYWV5NW5aaGlwdkp2THdEWkpRWW4wWGZxWWgw?=
 =?utf-8?B?WExrV1o1UzRlRlJJaC9qeXBGend0M0hTakNFUzVpQVREbFl1c1YzeDlUc1Zx?=
 =?utf-8?B?UmxYcmkwaTgycGxVakVPS3cwME82MHkrdGg1T01qOGVIeEJrQzlJa1BwckxQ?=
 =?utf-8?B?bW1WUkloaCt1cWlZQ3JYa1JJeXlsbXBIbTJWeThRQm9haHhoRXNlNTNQUXUy?=
 =?utf-8?B?WEgrTzFTVWhvL3MvZmRuNjN1ek5zRHVKK1JoSTBGaGlIM1NnQ3FwQ1NJNmVH?=
 =?utf-8?B?TnpiRzRBV3hjYmN6eGVmMzBpWTg2R21ieU9HdVQvZUQ3dGdSTEtjbXZVSU5t?=
 =?utf-8?B?Tkc4OXVoTGlrZi95TTAyZjRpdHJmRnpiMUNjaDNGNzVmaWZWZVFMZm5FSUFY?=
 =?utf-8?B?bjF6VjVMM1VhNUNuTGo0dkQwY1JBY2JCbFM5UXJmcDZuWURVN096bzFGUGo2?=
 =?utf-8?B?RkU5MjBsZUNDR1c4am1laXlZSmVFS2EzTWZQK0orREpGSXZ2WXo4cm1UYXdC?=
 =?utf-8?B?N0lLRjRlRVlFVkVIcEVyS0hJSU5Ra290cm0wQmxTMGYycXpNL0RRLzRNQ085?=
 =?utf-8?B?bUlUbUREQko1Q0Y0djRtdXpCMDR4ckdnQkd6REhWaXAvRFRnbnFGNEQybHZD?=
 =?utf-8?B?NkM3cXk3WDgrSHdGN3MxY1YvMEFYQUQzY2trSHVXUEVJZCtWbW1FeTRZQ2J3?=
 =?utf-8?B?cHN1TGRScjdrU3djQ1cyZ3YwOEl0TlVTdm1JR0VLdFR2cHc3dFZKSTNOTmc3?=
 =?utf-8?B?bkh4V3ZIZ09Hdkx6SFl1QXh0bDVwcDg4UlVJcVpOelJSbkNYLzAwZmFMaEZS?=
 =?utf-8?Q?doJzKbhk8AxQ5EgLlPy2afpKIty33tHXvOYz+iN?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB6097.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YTc2NUp0NFlRR09WVTBhT1pUZzhWWHZDN1VCWHN1WHV2aEhJMWRibVQ5ME9t?=
 =?utf-8?B?ZUNxcmJlZG94cEhQaVYzc2tUUmRiRXFWc2Y0aVFRNm9DZHgrbDQvcVVCMFlD?=
 =?utf-8?B?Y0FOejBBR0hRaFBKVFZKcmV3YkpqNFpDQkc3NkN5N2dPNWh6NnNwZm1jaGli?=
 =?utf-8?B?UmZZMEdiaUtCd3hIaDNSTTlNQzMyYlJhQmRRbjFWQ0x5VmJWQzVzVlRKK0Rv?=
 =?utf-8?B?ejNLcmdCbW5wb1dZWW5QRnFQV3gvR001SWxrVGFnU3lvMUsxVEovQlZkeEZK?=
 =?utf-8?B?d0N0eVhDVUg2a2w1TVFSWTN4d3d5NDVUZ1JhQVJOdXMwdG5wNFhvUVVRcXpK?=
 =?utf-8?B?Mmc1Q25zSDNNdWhYeXNFeTRDTXhsNHVDcWpiWlhvVW14QVlVenFnR2lWNkFS?=
 =?utf-8?B?YUdxT0RGazdUZFB2SHFhUVNTZXU1cXRHQUtza1dqMzl6M2txSzRGR2hndHN1?=
 =?utf-8?B?TnZrTEFKQ2NkSzB4WkhMOUp1Znh5ZGxxOHJ3eUs0bmc4dy9DMm13T0NNOFph?=
 =?utf-8?B?aGtPZTNkWDBRTUcvd1BuTHNRSFVhSlRIOGlTMWtha0VNYU5sQjBYT1FTenVv?=
 =?utf-8?B?L3dDYUxYb05tTCtVZlZuUllpRG5mRFJhWkppNXlIamkvSW4zaHRHVk1GanZZ?=
 =?utf-8?B?cUV4dTRDUWd5cytEeTI1OVRwdnlRUjBmZ1d0NTN3SFJXbXNxbEdpcnQ3LzBQ?=
 =?utf-8?B?a2p5ak9rV2JLYkJCZG1oQ1A0VjVlUnR5TTg0cUQ2TkgxSkluMkIvNis4cm9m?=
 =?utf-8?B?YlFTVHZ2UHIyRE1tdGxpb1hnM2pXMVliQVdDNjVCbGhSaW5tVjdlMHppOFJY?=
 =?utf-8?B?VUpVWWRaL3FRSEppUnlNWVJpdURRa0hEeXBjZjREOUMvOUFTcDB5NWI2a2pB?=
 =?utf-8?B?bXI3RkJwTExLTFZKUS9ISVN4KzJJTmFvakZVWXpjdVlxaFNTbUE4UnF1RFkx?=
 =?utf-8?B?blR0SmVHMmFNdU0vNSs0VUdCTjVpY25pR3d5YS9YS0F0MzBiNkhCTWYyVytP?=
 =?utf-8?B?YVp1aE9kK0FkQ3R0UzZyQkhsNFhlOWJIYk8wWG5Fa1pHUWp4Q1h6OVhlekRr?=
 =?utf-8?B?YXlSWGEyRnB1VklaRkxZM1huT2NnRHY3elpBM2hBQXcwTU03VTJjRlFOTk5T?=
 =?utf-8?B?Nmx2TE04dFY4TFY3MjhRNEdlbjBkZ0FOb2lIS015UEpGSVlUajNFSUw5TGcy?=
 =?utf-8?B?bWcrTDA2UVh3dDBKZ1IwZUNJbXRGbUdFUDl1TXorZlRHZ0xscnFlRUZQdzV5?=
 =?utf-8?B?d0ZNckJXQkdWcXRhVldqbUdQUEFCZFhBNEQvaE0yWlpTRmk0UDdBMUJpOElL?=
 =?utf-8?B?QjAvdHhRUjNuZjRkeGp2cTNWUURtV09acHF0NHRtYjJjWUNXbWFhMnFsSnNh?=
 =?utf-8?B?VDliTkxSa3MyY0VVcURZL29lRlZkcWFJblJMVUZFbGdWVktIM2UvT2hJdUtP?=
 =?utf-8?B?THhPb01DTHlJaC9QL0dhbW5ZenJNOVJGeUNMQnRzRkNtWlg2L1Erb1FScEN5?=
 =?utf-8?B?a29DWmhQN0tKVGsvMnRBWkYrQlZ5S3NxN3BXKzlIakpvdDlCbmpINDlDMkZh?=
 =?utf-8?B?UVhaeFc4UThZb2R2Wi9aSUhTc3BJNlJkS0lxdDRleDV5dEVCQkY2alFqTW1Q?=
 =?utf-8?B?N0ZsMzkrbDM1dFdiamFLRWl0dGV5V3h3K1FEdnVRN3pBLzAzT3ZzL2FvRWl3?=
 =?utf-8?B?cjI2bjAvK2wwTTRzMDYwL29tT0EvbzVaMzltTjE0MzR5cjFIOGRaRFp0QVUz?=
 =?utf-8?B?aHJmdnVxektza0x4QXAxaG1xMVA2OFpxbnp3bkIzaGhmMjNhd0hqL3BIYmdp?=
 =?utf-8?B?d2haaXl6SzJkdVFTR1d0UXhoSTY0NVdHYlZkaWFxTER2UlJKczBxSVdjTzQ0?=
 =?utf-8?B?bjFvNjJGdEJQenRFa0duaXhzRWhWUVZ1d3M5VjA2dXZVTi9LdW40Tm5OZlZD?=
 =?utf-8?B?Sk1TSDA3NzMxNVFtZ1FacVRBbnBMTlhNWlpMRDZoMUtoUFh2SnB2WUwyVWtt?=
 =?utf-8?B?VkMzWmdwVSt6aGovUy9yRzVLOUdRbmNwbHY3REZPNW9xSUtXdzJ1SnMwR1Ex?=
 =?utf-8?B?Qml6Zlh0OFFYd1FoQVZBMUlIRlh2enR3dmNWd3pHOXVSQmw2OVB6MkZOZGhD?=
 =?utf-8?Q?JwL/5+NhUdUzKpMauC3oddaSN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4eaea0b1-bff2-45fc-e622-08dcfac1aa71
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB6097.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2024 22:08:07.6622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JyNwlerTs3pf4oECA22todmRIqmljEkThEDgOm5O8Eo5p4AsDVy5u1TZ894jmDd1sm/sIZEnPu/BFghxsKGlgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8160
X-OriginatorOrg: intel.com

Hi, Tony,

On 10/29/24 10:28, Tony Luck wrote:
> Computing memory bandwidth for all enabled events resulted in
> identical code blocks for total and local bandwidth in mbm_update().
> 
> Refactor with a helper function to eliminate code duplication.
> 
> No functional change.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   arch/x86/kernel/cpu/resctrl/monitor.c | 69 ++++++++++-----------------
>   1 file changed, 24 insertions(+), 45 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index 3ef339e405c2..1b6cb3bbc008 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -829,62 +829,41 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
>   	resctrl_arch_update_one(r_mba, dom_mba, closid, CDP_NONE, new_msr_val);
>   }
>   
> -static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
> -		       u32 closid, u32 rmid)
> +static void mbm_update_one_event(struct rdt_resource *r, struct rdt_mon_domain *d,
> +				 u32 closid, u32 rmid, enum resctrl_event_id evtid)
>   {
>   	struct rmid_read rr = {0};
>   
>   	rr.r = r;
>   	rr.d = d;
> +	rr.evtid = evtid;
> +	rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, rr.evtid);
> +	if (IS_ERR(rr.arch_mon_ctx)) {
> +		pr_warn_ratelimited("Failed to allocate monitor context: %ld",
> +				    PTR_ERR(rr.arch_mon_ctx));
> +		return;
> +	}
> +
> +	__mon_event_count(closid, rmid, &rr);
> +

The comment (added in patch 2 and legacy code) is removed completely here.

Maybe it's better to remain the comment here?

> +	if (is_mba_sc(NULL))
> +		mbm_bw_count(closid, rmid, &rr);
> +
> +	resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
> +}
>   
> +static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
> +		       u32 closid, u32 rmid)
> +{
>   	/*
>   	 * This is protected from concurrent reads from user
>   	 * as both the user and we hold the global mutex.
>   	 */
> -	if (is_mbm_total_enabled()) {
> -		rr.evtid = QOS_L3_MBM_TOTAL_EVENT_ID;
> -		rr.val = 0;
> -		rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, rr.evtid);
> -		if (IS_ERR(rr.arch_mon_ctx)) {
> -			pr_warn_ratelimited("Failed to allocate monitor context: %ld",
> -					    PTR_ERR(rr.arch_mon_ctx));
> -			return;
> -		}
> -
> -		__mon_event_count(closid, rmid, &rr);
> -
> -		/*
> -		 * Call the MBA software controller only for the
> -		 * control groups and when user has enabled
> -		 * the software controller explicitly.
> -		 */

Same comment was added in patch 2 but is removed in the helper. Maybe 
it's better to add back the comment in the helper.

> -		if (is_mba_sc(NULL))
> -			mbm_bw_count(closid, rmid, &rr);
> -
> -		resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
> -	}
> -	if (is_mbm_local_enabled()) {
> -		rr.evtid = QOS_L3_MBM_LOCAL_EVENT_ID;
> -		rr.val = 0;
> -		rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, rr.evtid);
> -		if (IS_ERR(rr.arch_mon_ctx)) {
> -			pr_warn_ratelimited("Failed to allocate monitor context: %ld",
> -					    PTR_ERR(rr.arch_mon_ctx));
> -			return;
> -		}
> -
> -		__mon_event_count(closid, rmid, &rr);
> -
> -		/*
> -		 * Call the MBA software controller only for the
> -		 * control groups and when user has enabled
> -		 * the software controller explicitly.
> -		 */

This same comment is in legacy code and is removed in the helper.

> -		if (is_mba_sc(NULL))
> -			mbm_bw_count(closid, rmid, &rr);
> +	if (is_mbm_total_enabled())
> +		mbm_update_one_event(r, d, closid, rmid, QOS_L3_MBM_TOTAL_EVENT_ID);
>   
> -		resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
> -	}
> +	if (is_mbm_local_enabled())
> +		mbm_update_one_event(r, d, closid, rmid, QOS_L3_MBM_LOCAL_EVENT_ID);
>   }
>   
>   /*

Thanks.

-Fenghua
