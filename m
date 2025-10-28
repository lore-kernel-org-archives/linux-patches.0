Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A3A2D9EE2
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 23:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761695729; cv=fail; b=ZWSmIBOV2ukTC0G9B859xI4rYB/CR803f9GUTLIu97gLJP5tXNYGrKz4Y8Wm9jTGtxq7d3lKS831jwLaVWaN6lFyTlCxPhLJxbEKl8KhIG+1MM2wCUAFRJt5xOU17waeNkQVhRkE1WU5PPmafNweuwZy9Id9o6NW9eOiaENq9GM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761695729; c=relaxed/simple;
	bh=jyGpYUwjZ5+7xCkGJEVQ4ChWOxltea5yL0+NJQM5Nn0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tEr7Zcxsf+y7ad7mwYZiKTXsSjWuPVTSts70sUMtSVLNyFRv43ZRy410qtGeouRRoI4k3hnG2yT2IDQEr//nXHbn++tn1KwFChaPVVJil/fXPGHYdTZGnBPFhzUCcIvrILSuB/Mb5At3SRmfdSo28hDeSKdrzHQJc8HO/bsbeJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j8ww+0Tz; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j8ww+0Tz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761695727; x=1793231727;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jyGpYUwjZ5+7xCkGJEVQ4ChWOxltea5yL0+NJQM5Nn0=;
  b=j8ww+0Tz+npk9Q9gbUy5W2eDKkov4ChZKL4nbRYk45S7a4UT+Axj3A3M
   ddkVrCU27XHBns7ErkyZ5fmDHiFa+KUqOlQ7rDB6+f4Kcjh004wOZTMPR
   dVqRPxY/kObD3UyGjAFAmfw8aZgMliaG+rjPyCe5rdskCDL8Qg5YZyp7l
   9lCUjAtE17OLzlXUJIhOf24oRpNRr2LeqW6/uOZ81zGqjxa0Izuq4g/+0
   OdZXqqjJP3lpOi6VkC4lcEjqTVwmVxOXiZubsPG4spkQfUyLcSgh5LrUW
   QmnTJeycXW2lsUFvQZjOoXupwyEueQ+C1UlF0CZZjfvHFEhl1C/13Ek0U
   Q==;
X-CSE-ConnectionGUID: IBgjkRoUTiyWyR6bL8pqAA==
X-CSE-MsgGUID: GHRJHBpARPOrQQN8BVYytQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="67646954"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="67646954"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 16:55:27 -0700
X-CSE-ConnectionGUID: /bUnGD1ZR6Cqv75lgtMB/w==
X-CSE-MsgGUID: 71jfs8udSMmzD0kCRWf/6Q==
X-ExtLoop1: 1
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 16:55:27 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 28 Oct 2025 16:55:26 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 28 Oct 2025 16:55:26 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.69) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 28 Oct 2025 16:55:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lNMvIPenhWxBSP9JLShy4HryAD/ssygDENGrPyIDp8UanEz3odE7bJy+RB/WYuemOZBL+ilmd71ziUK1da1XcnpVV9iWUesHa2kgGIXbbM97ANPp9WHD+bAQe9Z14+Nh8Gs6DpY34swT3qjRBTiTNSgQ+J6aUEAP8qmmzo9wech+DCbgos4fyG8pJaTsjRHTxNaInhWHrInVp87+T3YUbZ3TzhVWDXVGTwUCJDLXn0ArizEjxhSRem40S4IsCxqDGxTm2rvSXKagjfNBaPvtoocSBgptcqWzQf13Jq4rljXT1KRg8RrIYYBCF38J+8U76IlU9zPm7056Dilh/dDRsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HO/nfpMYBvI0CildxZW6OBPWtrN0bSJQAOFJqCWXNAE=;
 b=alS4KtZKHhPckDYNyvGvFaYhJJqxKbiwfXfxh6Y6fRcHVJtwakPqnq1+ESXNZ0wTRNib51xzeK+mKwZUbRyE75PG2QY8k9QKy+v2FwQEqmDvyCJQQa6pkI7+pasChc+gOCSOFQFLPxECXAcBu2o2n4y37PRkY+VE4jZ103SvXOFDc5hZq9PZ3mur7Z1KHw8j8Dup8p6S1tKgOyGP0szHVsm4ldDYfK/4hZD9SZxXR8rRGntLaNmUt4TvVgb4tIszK7ATq4stQHyFSW4nuUaMs+EJNhJTvXGmNeKnPxzrgcFb+GfklLtjc6fI+HmfNGAHrju2E66hkOAojNQNHlcN2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA0PR11MB4560.namprd11.prod.outlook.com (2603:10b6:806:93::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.13; Tue, 28 Oct
 2025 23:55:24 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.015; Tue, 28 Oct 2025
 23:55:24 +0000
Message-ID: <a97d3a33-23c4-43c5-b3d0-4b211f120986@intel.com>
Date: Tue, 28 Oct 2025 16:55:22 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 20/31] fs/resctrl: Refactor mkdir_mondata_subdir()
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-21-tony.luck@intel.com>
 <4bcb8320-687f-4c43-b4b7-150d503b9890@intel.com>
 <aP_5eW_GHwXebeyq@agluck-desk3>
 <b4921b96-3f86-45d8-a353-471c8f20e2b1@intel.com>
 <aQD560ppyTDob_Wd@agluck-desk3>
 <820cd2b6-b71b-435b-bc67-c35318f869e2@intel.com>
 <aQEOIfMFo1Dqv-sP@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aQEOIfMFo1Dqv-sP@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0171.namprd03.prod.outlook.com
 (2603:10b6:303:8d::26) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA0PR11MB4560:EE_
X-MS-Office365-Filtering-Correlation-Id: 87d165d4-f2ad-46cf-237c-08de167d75f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VWptZml4K2dpZUdMN3E1SGg3UVYxTGxHaU9RaUJETExSUDJnL1RFTnlpdlBZ?=
 =?utf-8?B?emxCVWU4MWZWZStwcDAzZDFma3NEUk1oRlV0Tk00bGdzQ283SEZTWjFmd2pw?=
 =?utf-8?B?dlFUSjZmVGMvNWtQNzUwTmVVL1d2aFpqRlNmRVd6UGtMdVgvR2tsRWVLUWY4?=
 =?utf-8?B?RlQ0ZlAvMHN1eHp2ekdUclluZkRCZ0Izb1ZlaCtheWdvZysyNXk0M090eGVq?=
 =?utf-8?B?bVp3MzhCRkhKZTY5OGVXdjMya0NnUHNPbGdZR2FVTjBEcmFOMm5VZUR6U2FB?=
 =?utf-8?B?YUJ3NENNN3A3c3ZsWjZhY0ZleWtuejdmK1FOSWpqY1BNbVdMcnFxeHozaFZF?=
 =?utf-8?B?RWFYTlFDRUJTRGlkbXEwNlNxb0laSDF2UFN6YmttQmdMMkpYdlpQZzVOK3Ar?=
 =?utf-8?B?NWpWazdmYlV4WWhVQ2pTSDB5ZUx4bFRaTkQ3US9SVDE0cVNqek5rRTlJbDhp?=
 =?utf-8?B?UUhZQzdiNjJnNGgwN0dpdkY5TXQ3Tk1uZk1PWFZCcXhkc0E5NWlYNExxVldF?=
 =?utf-8?B?aXh3Zzc3Z1VhWlU1dWVhcTh0MkxUU0ZUcGg4TlJZMUZzaUVVR082MVNkaWN3?=
 =?utf-8?B?bThjSVBkRkptekxmT2RwRHhldHJwNUlWeG5RVjJrWFA1c3N6K20vbE9VUUxQ?=
 =?utf-8?B?eGtxdDVpRFNkcFRIMktwNTdqc2tvVDVQTWdGZXhKdUhkazlud2NlcGdGS2Q0?=
 =?utf-8?B?K28vTDA2bHVldDlHbVlGODUyNEhnRnI5cmZIdzBaWXZKTlVja0xOSjBtYWlk?=
 =?utf-8?B?dnp1b3FLSGc2NHFpRDRhaWtjeEN0RExBc1dScTcwa25iY0MwSnZLV2hGWXpU?=
 =?utf-8?B?bTFndEJhdXA1eE1CKzZXK2pDeERjN2RLQlFiZ09MNFYvOVdhbjZNM1BqOTRk?=
 =?utf-8?B?WExjVitHN0lZSHg5WkVxU3FjRVV0SXQxOGtCNFRJblFEdG9MYkpkQ0cyTEFt?=
 =?utf-8?B?dTF2VGg3VEFtSmpaQVg0bE1NVGo0VUtYT0hKclQ1dU1ZTVZXUi9pZWZDSDl5?=
 =?utf-8?B?aFhUSlB1ZEYrTGdPZ1NKQjV6bkRqZmFrbCs0eVB4NmtXMUxlaTFPZWYrMGRU?=
 =?utf-8?B?MGFPVDZvM0ZkYi9CVGh3YXY0NGkxNWtQS2FkNG0yS3U5KzhTcGFOcTNxcXF4?=
 =?utf-8?B?Q1lPZ1VWRUp4MTd1azI1OVM2SG12ZExmT1dNSmYwaUVIK2pldXJiQXJ3ZmVF?=
 =?utf-8?B?UUZMZSs3Yk5JVGhlNFBlTkxTV1JKejdsZHphdFRDWXFkRUZ1NzkrbXM5QUVi?=
 =?utf-8?B?amxLMmljbklMMkY4T0VISGNHR0ZxYkhrQUJHWGtVYTlzM3F5dU5Fd2tVUkt2?=
 =?utf-8?B?MjlTcVRUVzMvZlAxQW9jQ3RvSmJxZmxJWDNaMnA5QUhRS1pKdFZrU3pLZUow?=
 =?utf-8?B?Q3ZoeFRWTCtkL2pVRzI0V1VQdFlEb1hma2JHWmpWSG9OVndkL3B0ZHpwN3dJ?=
 =?utf-8?B?YS8rbTJ0TmVVT0taMHdzYmpBb29XUXQ1VDF6YU13bEN5OXFla2d2blUwVVhP?=
 =?utf-8?B?NEN2cXA5bkJtUzJhN05wYXl4aWs2U3l2WWp2cmFZbTVUKzhHWWNhZm9BQ1Rn?=
 =?utf-8?B?TDF3NENscHJuTVlPRFF3dkQ3SE1qWkJvQURGM3U2Qmhzd0dwQzdkTlNJQ3Jx?=
 =?utf-8?B?TXlpUXRTM203cmc4UzFmSDdLeGdub3BMZDk3MUhJUFVDQ1owNW41T3EvU3px?=
 =?utf-8?B?RHdVSGFWN3ZWNmowRjJLV0N2ODZwTjhDUXhKOWlpMUpSRFpKTmxKNmhZeTYv?=
 =?utf-8?B?NVBCNzROOWVCMEsvT252MkNMQkdsa1lQQ0JYQ3N5UzVybjNFci8wRGVqT2FE?=
 =?utf-8?B?ZTE0VWhwNTdUL2RXWjBXcHllQ3VLZkJYNDlOZkZwTzJ5cnBJOVh2Z3dRSmtx?=
 =?utf-8?B?SXFXYmZPOUhFcFRleVpSTFRXQjZOOU9FYTZDZnRLdVR5OGNDeEVQUEdxbE9n?=
 =?utf-8?Q?XuKFAB7TOBNP0UI0Zu7t6WIuvfJ2SPvL?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WGQ4RkJVQ1dLQUtQWnZrTzFmYkNQYU9WVFZuekNDbHhaNUhNeHZoRnBtOFhx?=
 =?utf-8?B?MzgwUi9ib3lyaEtUc3NQTVNtYkJyclZrRURNYXVNMHdQb09aaU5OVGtIV2d3?=
 =?utf-8?B?Wkh6QjV6WHBpQ2JYOEtuNEl5OTVkck5XS0dTamdiUXBuZlM5REgrWkd2b2c5?=
 =?utf-8?B?VXFQSlNoZXlVaVIra01qTUNEaFExZnVES28zNkxMS3VRdGFIbEdvWDU0SUVj?=
 =?utf-8?B?VGk5Qm0yUGNyc3Z1T3pONmtvTGEyWHZtalN1NGlaOXJFMWxvOXJ3NlROWFM4?=
 =?utf-8?B?RjMvd2MvM1VLcVpTcUwyNmd4OCtHbkhwNnJBRUZHY1dNeS83dVJIbHZhdnkx?=
 =?utf-8?B?anY5emo2SGVZNGhWc09OWStkR3VOb0lId2R3YUMyd0MyR2IzTDJpNDVjSk4v?=
 =?utf-8?B?Zk5ZMjJ0SFoxanBnQ2RTV1lZeU9TdkdvZGpRMWZzTWF2UDhGUTFXNGtVMHFo?=
 =?utf-8?B?MlhkTGtpQy9HemdUNWY2dmhDUVR2R1lJenhtQmFxTEk2dFZWR0VVbWhYQVhB?=
 =?utf-8?B?ekxMcjFFUUw3dmFZMVY0QlNVK2lKN3FwYUoxSTd0MGUwSzJSZkVseXcxNHdP?=
 =?utf-8?B?aDVGNHNsU3k5bXFRTmRLNHppK2NwdWpGR0xQd0ZLc1pDbXZMdXF5ZWhYWHNF?=
 =?utf-8?B?eXhhWklZdjdZNEtkUmhxc0UySllMbHYwS0lJWTFKZ3V3Q0hoUkRTd0p5MDh2?=
 =?utf-8?B?OGQzZThPL1d3RTlvamJreFlqd2JycHMveXN5YUhibmNCZFZldmkxUUtSWnYr?=
 =?utf-8?B?OUU2NTRWM3hYYjdONE8wNTdSQ2tKWFcxWGQyUllQQmluOHVkbnFjWXZ2dURX?=
 =?utf-8?B?VVA4SFdNdnovYk5RVzlORVpyN21aY3N2RjNBL0sxUGdoRWVjL2FrUzhoT0F1?=
 =?utf-8?B?RnZMbnJCM0dHSUg2dGw4c2FCeUJJSUQ2NlhpUFNBc0RJTzk1VGczamRIQk42?=
 =?utf-8?B?ZHhSeEc5cTRIZkN1R2Ivd1ZDVkVjbWR1WlZlNWRqRzlteEF0OEY1bnM3Zm1m?=
 =?utf-8?B?cW1ENnJIdzFzdDRzUzNyQ0VoQU1qazBPYm8za0x4Tk85b2VOVkJpcFppeXF1?=
 =?utf-8?B?emFMUmV6ZjNoOGdVT0lJSTAzZm5LUGhNRGs0ZFZ2ZUJhUlZrTnJESU9SKzNU?=
 =?utf-8?B?RFpQRnFKVDBhZHN6NmxsWmE1SnkyY3Y0TnI3UC9MSE9CemdmLzgyZlhHdGFS?=
 =?utf-8?B?dVF3a3RGcUVSVDhjQzRheHVLMVpCZ3ZRZWVrS0N3L1ozQ1lCTU5ZNEpaaHYz?=
 =?utf-8?B?MU9qZ1FSRHJZd01yZkFodWVscjJQQW82MHZTRUVJREdjRi84aHIyNVZKeDhS?=
 =?utf-8?B?dld1MEhQUkpHdWppVklsVk1jNlFrUm0xOWJCRkxYcnFkYmlseFA5VHorSlY4?=
 =?utf-8?B?MFNXcFhMTVJCWG1EUXVUVXc4TkN3Nys1endWa1NWd0tpbWNtckpQUXdrd2hE?=
 =?utf-8?B?MlRsRjhHZm1UaW5INmROckg2SjBXeTNKZ3NuN05pTEZoa2lMaEdkcjNXWkov?=
 =?utf-8?B?L2JCR2RJSlhuTjZHNnFsZnVFZWlpRWtMS09ObUsxYXE2VFNMekV1d04zR21W?=
 =?utf-8?B?RGdSeEhqak9TeXdHdTZzT0MzcC81Uml2amlDNVBwSE5Hb2JISTdOWFYrV2JX?=
 =?utf-8?B?djhSUUxUcEcwL2Z6bXErUkFUTHBpOVJOM1JjSDFJQjNyZ3p3YW1Ia3dxOUZI?=
 =?utf-8?B?a0hlOXF6cXM0M3NPS1BwSEFkYVpraGJUYmk4TXFDbVo4V1VGM3RCWm50Z0s3?=
 =?utf-8?B?NW9iQ212OXhDTEJWcjFEbTU1WmpJSEhVYXV6clRvY2hvcE10UGRkTnc2M29D?=
 =?utf-8?B?ckdmRXhwaXR5alZaZ1U1NFhZY3BjVVNGemlXajBlRko3ZlBpaGxlRHFYbDhX?=
 =?utf-8?B?WDNvR0YwenpqNWJ0MEJMcHpHTC92TC9YTmJNeWF1dXZnMjVtYzlYVlNVeVRP?=
 =?utf-8?B?d0Vva08xRUlkOU0yaUsrUGkwK0VxL2lLWUE1eHBYQVF0TUhXUFh2eE1tUWFw?=
 =?utf-8?B?SFdFV0o1dDhuQ0tDZDRLVHpRRzNObWJGN1B4eU5rZ25BUG1samdqdm5PVitM?=
 =?utf-8?B?WUxpK01GSCs0ZWJyYXdVQ0MyVjVQUE01bUhQZElubFNpaDJDbzZJSXFhb3ZW?=
 =?utf-8?B?OVNJQS84bDJlVzVucWcvVS9qbkpQcEtqWEI2aTd3Ynlab2toV3ZOUnRzVHoz?=
 =?utf-8?B?d2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 87d165d4-f2ad-46cf-237c-08de167d75f1
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 23:55:24.0215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B4ZMd1L/Rd8XiCQVR7KrvWCaXJD9FALpT8iPSOu8OsVHa4CBgJ8AHbt+g4aUbJ8yqs3dSijFNN43RSrRNEEoECbetzZgBTaDv+ASu25y2iI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4560
X-OriginatorOrg: intel.com

Hi Tony,

On 10/28/25 11:40 AM, Luck, Tony wrote:
> On Tue, Oct 28, 2025 at 10:40:44AM -0700, Reinette Chatre wrote:
>> Modifying mon_add_all_files() sounds good. I assume the node activation (kernfs_active())
>> will still be done by the caller which would have this new function return a struct kernfs_node *?
>> If so, I think it will make code easier to read if name implies that a new kn is created.
>> Since the caller is already mkdir_mondata_subdir(), what do you think of _mkdir_mondata_subdir()?
> 
> Reinette,
> 
> This section of fs/resctrl/rdtgroup.c now looks like this. Call sites
> are now free of duplicated code. Thanks for the nudge to do this.
> 

> 
> /*
>  * Create a directory for a domain and populate it with monitor files.

Could you please add a short snippet about the different meanings of @hdr? It does not
have to be entirely kernel-doc style, just a note for the developer trying to understand
this function. Something like: "Create summing monitors when @hdr is NULL. No need to
initialize summing monitors."

>  */

...

I find this new version much easier to parse. Thank you very much.

Reinette
