Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A77246760
	for <patches@lists.linux.dev>; Mon,  6 Oct 2025 21:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759786452; cv=fail; b=tbQbi8SUQWQ3BMZU8QeC/Gl4K6R9mQMw+v7pr1xSnN2+fB2CRIggCbHvEdmdeqMmeJqiP0A4SXMZXklKKu2NDZxhUx2NX2PCBoiTpWGf+JZ2+KqXQdKukVMscRTpXJ4sP+YtKxlZvFM6gV8Df/SphtSVhzVONQKd3H92jPINfZw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759786452; c=relaxed/simple;
	bh=i4TqFp02uooCEkDLyWs8knTIe0WfcI3jQcPJypxCucw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BdMiKCeQ1QsbNKtic4HXyeC9KGdYcFMTf1IkPXEK5QGvBUvUIUa/kZilR+pASynFILBH/pZWO7rsKUF5hmRSx0+N23OTUhJ9hU/qyfmjOCfokAROAw8rw2rzesiUZx9+Rnj1gUNb1gqVN9pwcocW0Fv+dfg/1vRLy4KXHY8Ybmg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YMbKITA2; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YMbKITA2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759786450; x=1791322450;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=i4TqFp02uooCEkDLyWs8knTIe0WfcI3jQcPJypxCucw=;
  b=YMbKITA2Z1LqYmhJU+DDJgdTuUBjY8IEohpqlDwl2kANRAZ2XNGbNoas
   s3Bl5BFKqSC6nLpTCp5qnWpTtmB3CAxNueq1KCelD2EknOUoLqWOYrgZr
   uCmjOovFwzD803Xs73ODJ7nyEd5qhIpnnTfISiWeVoKIisSUkLyEcfhM3
   /kkZ7NsFjaipIOuysxl4qDkA/abVN4j+n4e0Sb1yyFyO14wUYwVRbGkbn
   Y1JbrUUZ9lj/bBsQnw2h9gDlszBWTDSYQwMcSItloj/l+U3gcrXYgBaZW
   xiybdM6jknMMeIvzOJFq7rLR6ROYTNSL23KcUhH3DKohaZfF4POhPCQnW
   Q==;
X-CSE-ConnectionGUID: /u/1lQKCS7K33OReIxyhrA==
X-CSE-MsgGUID: bmdt8NMUQi6NjaMLHeMwiw==
X-IronPort-AV: E=McAfee;i="6800,10657,11574"; a="72582082"
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="72582082"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 14:34:10 -0700
X-CSE-ConnectionGUID: E8FXh8UESNmC4C4DJRznOg==
X-CSE-MsgGUID: uTUexXmBRwWpx8xFNgJVJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="185267240"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 14:34:10 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 14:34:08 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 6 Oct 2025 14:34:08 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.52) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 14:34:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UExbMZ7poKZlD2Tbk3FNQ8T+73nR6xSPiLvNGLgNNvbWepub0cBKXuXG7+v6TuU10kz+rxOCRbBjypL+AN/KnXpycAd7+vpfs+s9Jxg4u6DpuWYgkeMtxrMnC4KWf1e+Hk+2J1g2i5XU+wvFfK0YTLCQ5/Azkh6nZpEspZ/xv3TmXKCS9N+giwAjofu7qE48Q1eauNe6uXqT0d7AQe0YXw9lJQWvESrrQnLJWJtRDK1Uc9HtnqLQMC4SXkXJ/FKfZgJz5bs6g+v8FFdhS/af+s/WmcLanARKmnRFzKDihlFOCvU5YB+zKE7o1GPMQlDWhStKChdqqaNUiRuiRX0YFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gJxteyvXGyROQinBxMsjQ7fYGpcrq24OpwsCcPrIYVM=;
 b=cj9r5sI6gW0LCw+5W/944e6/4gbPGzl7UYRN1JZdDZKTjbcb0nvHr+Pxx8WL6OBb2rnvBtWqzsRViJKg4Gms9Fm9ISMCtYS2tlKWF1DNtdgpnSsQ5ZVdGVjsTlPcxbUr98ma/px4B7wLpiG9y8JTWTyw8tGuloobIMvV9iLPMECQd5u4RozS9gEFljs2lTUnBVqj1Az2z3PFPuo120yk4LzpeDEN9iaHZKSk9EPCRaB5rF/TQfAk8TuPcO1dB9EKptUdgJX7Kuhnnfuk+ltP3T0lGH37Jqihhz+CsTa8Dekx64LvbumIoTvnzoBTN2mZJmtIgP4E599OvCBTzKyhTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB4958.namprd11.prod.outlook.com (2603:10b6:a03:2ae::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Mon, 6 Oct
 2025 21:34:03 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9182.017; Mon, 6 Oct 2025
 21:34:03 +0000
Message-ID: <bf071a10-0f21-45b8-929f-60e864f57a41@intel.com>
Date: Mon, 6 Oct 2025 14:34:01 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 31/31] fs/resctrl: Some kerneldoc updates
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-32-tony.luck@intel.com>
 <105e491a-475e-4d6a-a1cd-88d500d8fea4@intel.com>
 <aOP0KPfZYd11XoTq@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aOP0KPfZYd11XoTq@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0373.namprd04.prod.outlook.com
 (2603:10b6:303:81::18) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB4958:EE_
X-MS-Office365-Filtering-Correlation-Id: eac58891-9773-4aba-d1d1-08de05201217
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SzFQbFpVcWowaG5lRzV2QnROT1g3bkExZStVc2U1Y2t4cVhrY3oxQVMzbXlB?=
 =?utf-8?B?bmIzR0wvNGtwTktpNFlXM2ZjajhENUN3YXF1SmpscGpNMzZzSmJPQzdoVDVq?=
 =?utf-8?B?MGVZY2x4Y1lOdmduK1Y4eEdYTHJTZjVHUkNvMVR4LzFoZ3pNQlRKZWxkekhS?=
 =?utf-8?B?TlVRL0dBbndsWmdrUUs3cHZLenVKdWNJSGRKQTMrSUZzenNuYlYyeHJBQnJL?=
 =?utf-8?B?S1pNTld5V2N0Rlg4SnZEZllrRExQa0R2TWV4UXdQd1dEUXlMdWhjcjM3cVlT?=
 =?utf-8?B?Mi90WDJGb3JXNHRrZldQMWtkYXlGNkZQV0EzQlErNDVqaXZWaEdPOHNEZDg3?=
 =?utf-8?B?SU15ckZHalFEN1lITTVHdVRLWSs1TEV6WDRYaERFSHFHM1RXazdEZVFjUkxn?=
 =?utf-8?B?SFk1WnhoVTZRRG9DRWxVcTZGbWhiM3RXUEhGUmMxZWQ5dXRKZlFjRFIrb0JT?=
 =?utf-8?B?Mkl0dEFTN1dVYW54OWlqY21FSEorUjh2Sk5uT09mSVg2V3U0Vy9oY3pmUXVk?=
 =?utf-8?B?MFMwOVFpczRRSjhTcmJ1OGVIWWRzNlhab1VjYWJYM1JzMDZ3OFIxdVFQRk1Y?=
 =?utf-8?B?S1djTTA4bmZFRUxCNkZuNEVMblpvaVQyY2xVa214SUxVWGpGaHhXbVVsbDVJ?=
 =?utf-8?B?MW1jNkZtRFIvajYzbDJWNG15NnlMWVhYK2kveEl3b0hmSlpITDZNS0t6eWkw?=
 =?utf-8?B?RFVhd1ZmV2dOT1dUSEl4TTFEYVhEeUNDRFVtWHNxbGNuNTlpMkdVRU0zRXEz?=
 =?utf-8?B?aGRlT0JUVWlVazRnb3VScWdWNDZsajloWU1Pd0RoKzY4TjMySUZ0dzhlOXJ1?=
 =?utf-8?B?YkkwL3RtcEZBOUxUdHpNclZpU0F5cDdJZ1NWRUIyQW5wcUo0V3VWY2hqV3Zv?=
 =?utf-8?B?aTZHdVN6a21RWC9yNUI5MDFvR21LdmEyTnJSSEJMK3VzNGNROHRrTndoZVJR?=
 =?utf-8?B?MHdUTzhLeFp3bURSak55Nzc0NUpqMUU4YjNkT0NNbmtqU3VzcGZZZEdJcnBm?=
 =?utf-8?B?WEUvT0Q0YzVBdFhzelNPTUVsTURJUnpvUENGMXd0ZXZZOE8xRFUzeDdCeW5z?=
 =?utf-8?B?ejVXNkRZeGpobGVCc2R5R0wvK3RQQUhOTU9nTkJGeDNCbXduQ1F6QVgvMWlT?=
 =?utf-8?B?WXRwVTRKbUNMZnFSYlBuaXFqa2J1U1AwaW5WM2NXTStPMkllRGYrdUEvVzhq?=
 =?utf-8?B?SDNKcEFuVElzMVozcXZ0aXB6ZU5KanpwWVc0cDJYM00zeE5aVmNJTko1cEVu?=
 =?utf-8?B?aUp4cUZWTDRDZzBPZEVNVjFSUzV2VS9NSnpBaVpQTDRvNnZUdmROYVcxVktr?=
 =?utf-8?B?b2s0ektFQ1JxNC8yQktVWm5CdzRqRVR3MW95aEl0azJDdmRuTnN5aTNvRGtw?=
 =?utf-8?B?TTZyUEpETGlOQ0h0b3Z4akhSZjlJeFJiMlBFdithT1NUR1N6L3JmOE9iLzZT?=
 =?utf-8?B?cXVtZnY5eG5OVHNydVJVMGp2dXRCREJYREVrbnZWNm43cGlNMG1QUkdIM01K?=
 =?utf-8?B?UStkWkgvNzYvdEU5Um5YTjU0Si9rY0Q1blRDV2dGVkx2ZVhnc01STEVRVHJ4?=
 =?utf-8?B?Q3k0VkMvNThhWkxJYTRMVkJDR2szWTRkOHVqRWtlT3VCb1NXdElpdlRUZ3c2?=
 =?utf-8?B?ZExlbS9iLzc1ZTlJVHFaMDRpVmUrS3RNclFPTldWQzcxRytXVFozenl3ZGQ3?=
 =?utf-8?B?R0ZiaGxoYXNoM1lrTXV5bmZHcTIyWG5QU1J4eDVPZG4xWWpZcDNXNG45anJx?=
 =?utf-8?B?WUlIN29VZTMzRDdvVHpteEQvM0lFeWJOcXVkdVRveVJmcnhpK1lXRC8rb3Vp?=
 =?utf-8?B?STNNcEFaYWVCTXprL25oaVczMDdtTEVyUU9sbUZuQW4wT0FzTmJObVpNZkFV?=
 =?utf-8?B?OXNjOG1XWGs0UGVSeWN3OE4wb1A0L2NSeHMvbTNlQU1UenMxUzZSOHd2QThO?=
 =?utf-8?Q?odJ/81uOQTaZbT/JFaNgy+LEVZjioHCX?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Yi90eEtYaGN1alNXR0FVUmFTWkNYZUIyU0NFenVoekNmenNBb2NRaEgxVGtw?=
 =?utf-8?B?MzJGcUEzNDNqWjY0RVRFd3FlSmVIbXJscDM3eE9jazdsdnpuY0d6VEF1QTVZ?=
 =?utf-8?B?UTIzS3dwNDh2QTVHekI5azZWeFZPY1BTeTR4YmNxM3JYVXljdDZMTFplTU5D?=
 =?utf-8?B?b0hCc083NDE2TWFTU0d5N2xFbS9PeEFIenAvYmxNV0UxRmxBVEZrNXZlcUlZ?=
 =?utf-8?B?NHFlYldUMFJENjR0VmwvTlJqZTIyWG5mZlNvcW5JRG1hQzBYZENCbC92c2Fv?=
 =?utf-8?B?Q3UwczNxVnJhelJuZDhUc2ZVMlh1bytUbmhKL01kVmF6Sm5PYW00VDFvb0h4?=
 =?utf-8?B?aUg1NThVNmN2RFdzSEhUVVRGZUM5dUlBOTI1MmtmUHRUeXhBWXZRR3lmRTFB?=
 =?utf-8?B?T0d5TGQwNkN3dm82ZEM4YUk1SFFFR1Y4WTA5bUpKZ3J1ZmJtbHR4dW03SkJH?=
 =?utf-8?B?cHRnQTZlVEpiZ3g3eUhSVzRCWVBPbW4zc1dKRnlISmVyblBNWlROV2FNNE51?=
 =?utf-8?B?ZEdKSm8yRWU1S3RZYmFoY0QxN0RmelVYSUhCQkU2ZkJHZ29BMGRDT0E5UnVk?=
 =?utf-8?B?c21rUmJ2N2cxSHdkTkY4VHNHREp6T2hsdXp6OU8xRy9maCt4aXBIOXpoUFVX?=
 =?utf-8?B?SmRReklZT0lnSmp1QjFWTm1ldk5oRVY3UUNSb1QzaUtYR0dwalVoeUZiNXEr?=
 =?utf-8?B?dlBpQzJqbXVZeHV3cm1BNUpOVGI2aHBveFVCNGxLMnhLSmQwN2xTY2NYaFBn?=
 =?utf-8?B?Z3VQSG5HcnIwdE5MekVFUU9FNTRZNXc5N1d2VEUwTzBXYjJ0MHo0UTVZVCtZ?=
 =?utf-8?B?dmpod3F2aE51NjRUcnJUOHBCMGNEa2NiOExOTE51UHFRVy9CcEQ4VG16bmZD?=
 =?utf-8?B?U21ReUlDRXJTK1VHeGpoQjdXZjc2cHZHWGltdGk2TlgvbUpLYmZLZE1oNDVV?=
 =?utf-8?B?eCs5RndkODdUb3FNb2NjN3NxZ3dMMm5McXdNdStJRGpscjc5LzVXcm1tQlVj?=
 =?utf-8?B?aVdrT3N2TGwrbVlHM2p4M3d0ZUM1Qy9BWWJxYWRpdWlHRjdsc2RJeStrS3M2?=
 =?utf-8?B?My9IVE0rckk4RkJEYjFqK0pwWVRQaHBBZXROcTVTVEx2Vy9aZzZ0d1AyMEg1?=
 =?utf-8?B?V2ZXL2pGSkxsdFRZWEpESGFyeGs2aXM4WHlmNi9TZDFKU2xRTDZVdDFHU1My?=
 =?utf-8?B?aVJCWXVLM3dUYXZHVTFFbm1IY3VQcVBGb0VQRXREZzkyWHRtZmxmM0k3cDF1?=
 =?utf-8?B?RE5Fb2xpOXFTSGNaamxsY2hiRk5scWFiKzhOMytLZGt2U3ZuM2NxQ01HK1BB?=
 =?utf-8?B?WE5lTkVLbkFWUXRGNDdreEcwQk85YkV6STcva0ZOS0NXL3dvRWpZMWVGN1VM?=
 =?utf-8?B?djNjYTVOYU5mMXhPTGFnYjMxenJiaExUSzZUUHRuQUVlbDhnSVFhdDlnc2dk?=
 =?utf-8?B?TytDVEV5cFc5djZWcWc3MDNFT1dUYTBwTHpQazJIQkgrZVFRQkFaOWNZQy90?=
 =?utf-8?B?MTdYZXRNZm9rK1JnYVZOK1ZUclhWVWRPSjY2dVA5SUloQXV2U1Z6bm56c3k3?=
 =?utf-8?B?VjdNbS9la1BMY3V2ZDZsN0ZTV1VRRXJKU1ZqNDhXdE5UVlFvbHFTNmlSM09p?=
 =?utf-8?B?T2JwekNCTDVvaUNCdXREQ2hvMkRTVVhuK28vR2EwQzRqS2dYRk15Y1N5NHZ6?=
 =?utf-8?B?azFmYmp0bG5BbG5FSW1mdUZBbExYT3p5VG00dkRJeEJqMDR1YTlSYnRZOGE3?=
 =?utf-8?B?UkFrVC9UQTlHSG5uaFV2SllqSGpzWUlqcWxoMWlORHRORnZVa2Nuelh0SnZM?=
 =?utf-8?B?YVlrbDJzNkpyOVZ6aDRpU1d6RGVJLzJlNWc2YTVBMFlpOHVPdXR1MUV1Nyt5?=
 =?utf-8?B?ZG1NallhZUtqTjdmeVMvczdpdHM3NWRlRGtHQkRwTFhqOElDVStNYkhyWFZa?=
 =?utf-8?B?OWVJMTRudDB2ODFoeURVTnJsNWU4bGZhWE9FQkhQcEdKcU9mS1UxUHRuRmxX?=
 =?utf-8?B?WWRwQjR0OTNMUjh5eCtPcnMydkxlMUdDa0RIVktsSFpWODFkK1VRc3Z6dngv?=
 =?utf-8?B?RTQ0UVc5TlhhaWFOU2F5U29MRjh0RVZuZkx5amtVT3Yxb0xMQm45c2trWWl1?=
 =?utf-8?B?aEwvOGYyTGpQRHdOekpNN2k5eXRocVhaSExuMVhFS3ZqYWpGZjFCRGRuaXYw?=
 =?utf-8?B?MXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eac58891-9773-4aba-d1d1-08de05201217
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2025 21:34:03.5178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kWfC0PL0Ubo1t/Om3/lQF3BHXkyk0MI9092FBvJoSxQLJhRsKEFu4aJ90b3be/1gaayVX7wkoBU6ItMfAiVrqOD36wI35ysfBX+RaKWrjQ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4958
X-OriginatorOrg: intel.com

Hi Tony,

On 10/6/25 9:54 AM, Luck, Tony wrote:
> On Fri, Oct 03, 2025 at 05:26:45PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 9/25/25 1:03 PM, Tony Luck wrote:
>>> resctrl event monitoring on Sub-NUMA Cluster (SNC) systems sums the
>>> counts for events across all nodes sharing an L3 cache.
>>>
>>> Update the kerneldoc for rmid_read::sum and the do_sum argument to
>>> mon_get_kn_priv() to say these are only used on the RDT_RESOURCE_L3
>>> resource.
>>
>> This is clear from the patch. Why is this needed as part of
>> telemetry event enabling? Perhaps this can be combined with the
>> unrelated SNC warnings found in "x86/resctrl: Handle domain creation/deletion
>> for RDT_RESOURCE_PERF_PKG" to be a patch dedicated to addressing SNC
>> topics related to telemetry events? 
> 
> I will add an SNC cleanup patch to the series and make these changes there.

Thank you very much.

>>
>>>
>>> Add Return: value description for l3_mon_domain_mbm_alloc(),
>>> resctrl_l3_mon_resource_init(), and domain_setup_l3_mon_state()
>>
>> Appreciate the cleanups but please have series start with cleanups instead of end.
> 
> Can I bundle these cleanups with patch 8 that renames these functions?

Good question. It is ok with me. I am not aware of concerns with doing something like
this.

Reinette
