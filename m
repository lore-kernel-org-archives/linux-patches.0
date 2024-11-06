Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A47D1F16B
	for <patches@lists.linux.dev>; Wed,  6 Nov 2024 00:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730853676; cv=fail; b=QIihA4IxC4hnjDYlgGp2huSTUUoW8Rpj980mymq4u00aGHQ8isjndBNY6zBFoR2FtShPkzpbdKGrd7SandIQIsHEAVtwV4GPtxhKL1X/0DM9rIbCo+yl6qFCGoWux8n8sw2SYYxUbJvz6F9lbwhPuO7mmBddWcyW5LWd16rHyyA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730853676; c=relaxed/simple;
	bh=Xw8Qj0QuNcHTzaeevyl4ynasuMXcSKXNcg9kA8d6qoo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bmdvtXuCnTMZV6V93jtTzkDkLH+SURkCXVY1JO/MBhQBql8OyNW9PiF8mpnYrPWUoNcwc/EaDMK/HoqwVkaCYCOznheQqbhBhnP917ajm7m0BUDNYkG5rdmQlWgCzwtWpXctKAITdPEsepf2UYyViMc9q/PUqYdcRBMqRj3Pgjg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hlsTeqsV; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hlsTeqsV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730853674; x=1762389674;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Xw8Qj0QuNcHTzaeevyl4ynasuMXcSKXNcg9kA8d6qoo=;
  b=hlsTeqsVakgqj18GizdDKHU4aSg6x4asFoSi5CdWAfwYo+UB4Kg/SmrD
   SWQNpsmG/VBvHIZIPJx4aIIuYsMkghRAfVBy5A28SAO99/ioZw5M5TvEI
   JxhKdu8csTgHWpws7SdnI6exQyP0zJCKp81a4lA161iOv4NZQKD1Mam20
   E3HCWdAWeAvWMGzbcwLNr6k/A9q7v4m77twO4NM/tmbkomLgrdcP6l7uj
   zOnD9GcQCeR0NjcGS7qv9SQ6SGkyMVEXT6nTZFF9T09xVrOvSSN0qdOP6
   xoKv6yrtRICihIVqh1qszV3wLO497mF6xCcPcoP8XlqXXlpuA4s+ALA3s
   w==;
X-CSE-ConnectionGUID: hndtKRVRQMaq3tt2DNBeWw==
X-CSE-MsgGUID: CsRuAt9KQmKttDfNxeSPWQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="30851976"
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="30851976"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 16:41:14 -0800
X-CSE-ConnectionGUID: g4C4Mm8+SVqMLvS7kRpIHA==
X-CSE-MsgGUID: kmvOwho4TIKFXdBlBe0KLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="84569984"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Nov 2024 16:41:13 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 5 Nov 2024 16:41:13 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 5 Nov 2024 16:41:13 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 5 Nov 2024 16:41:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PGlcyXQwW4ebGo6gWX73neepqIp+toWnbR2Hawb+pa8CR6qnav4JfbY4nHXlN3fOoeB3Yd6FVsUzA3obbutCuo5+a8MDGOKEXo9lwH846nMgEw3IBl9/S07OWBkel0sWzy4esePIoihLibVL5Cn32cCmGtHOUU/9JyVddDZsaeQ74iIFFn6BvPoZdtNJ00JkbnrEQX1Rd85hTPyCVG0EIsJkP4vmxVjG47Q9O5xPI3g/AmXiad22mgqXaL6GKrCc/15ivT7/UA5vZKQtw7iIskWew5TbkmVjdY4vmUfonm+AmLdt6CnZPp0giwkyPW6W+Thpngx4IP/Rsx9aCUsvYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=23aAXhkFgOpqb2WPJ8uOgZW4wBaDcKp9dLJz7mZ3NpI=;
 b=RVYif9Pj8jbOKK7xOlUpS0zQa4FNtUeTbi4koCbBsQjxXj4ai8fNMywh8QsY+gYzaA3U8PMCoaf3gGR/2PCJEmA053JYfzFHE9m5DOzmppSeHqvp9s5TyE+mDe8N9guM6ZjAsZGmu2YYdZM7tgjQ9nHJ8tyXuylOClQfLWK+BzPHmKIc+8so2CksU9Oa6AzKmjpGP4Fh1b89T4Q87TG48OfTc50gHFOETeGR/hlBY3wkxveRkN79F1NntopgyFHxErID9vjc6w4QKumj7KCzrfLmJyQpmlFdMvLaeRvgFHw3Ibqgb4B462Oe7D6cyzdeOJv5hEqV0CpeZ6W4HRux0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31; Wed, 6 Nov
 2024 00:41:10 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%7]) with mapi id 15.20.8114.028; Wed, 6 Nov 2024
 00:41:10 +0000
Message-ID: <211cfc6c-302a-47b1-bf93-85ab95c6e3bd@intel.com>
Date: Tue, 5 Nov 2024 16:41:08 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/resctrl: Support Sub-NUMA cluster mode SNC6
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	"Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20241031220213.17991-1-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20241031220213.17991-1-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0219.namprd04.prod.outlook.com
 (2603:10b6:303:87::14) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH0PR11MB4965:EE_
X-MS-Office365-Filtering-Correlation-Id: dc1f3dfb-5386-4334-3016-08dcfdfbb594
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZmlVQVI4QU1rTGRMOVpzV3lXWm90WTc2cDdhMThuQ0dmTllWUGw3d0czaVox?=
 =?utf-8?B?WkNXRkcrRlBCZHZGVXZFQy90NDcrVGVLdDY3ajhHZmZ2bkdDS1ZUelg5ZnNn?=
 =?utf-8?B?UkszNlg4eHhmVFRLZGR3MlkwbVlteGVPcnB5dDhaQXJOTWNPc0dsMUJsVUJO?=
 =?utf-8?B?Tm5vK1M4OVd1S2NRRnFoZ0dNZFJJYWlpRDEvZ2wrYUxmdDFvREdma2F2anYx?=
 =?utf-8?B?VS9YNzdjeFl4U2JNdUhoT0E0c0pJazZ6YUNiZFRmUk9uNXRldi9jNytmenFH?=
 =?utf-8?B?ZGtLNm9ENmR1S0tieDIzTXdkZ0s1eElGbUlxQjdyYWdlUDg5aENQUUNQengv?=
 =?utf-8?B?aEMwVU13YWlXQmlBbWU4Uk5hbnVlNVV6b0VXRWdQR0paMjcrYXdRc0V5VHpX?=
 =?utf-8?B?cExYSGdSU2RPL3YwQk8yMlFGUk1UdHkvUjV6WDc4eUU5YjFyQWFXamFPUmN6?=
 =?utf-8?B?cG9oNlBrYWRDTm9XbS93T1VYVUNVUElZdHptL1FtcEt6SjA1ekhVS1g1eHhw?=
 =?utf-8?B?QkRpd3NGRDNEdzhtMWdlTVNRcVJCN2Q1UUFLZElSUzFCNWozbHBibllJbmlH?=
 =?utf-8?B?NEtOam1UOFo3bDFJbS9yVS81TFNIRTBScWhFTm9INWhNUWdhMEhaQnIyZzdY?=
 =?utf-8?B?ZFpQeVgxOGZ1RlhFekg4SFpLWWJkbU1vVUdKVmEwWndqU0Y3MTRQdnBjY1Fa?=
 =?utf-8?B?SitnTnN1UDlWUFRGczUza0xHT1B4dmVJTmFScVhlbnlQRlhGbEVOckRwZDNW?=
 =?utf-8?B?ZFBEdE92MzBYMm81TUNJM3BRdUJPZ3BhYkRlWWhKRWFRSGFWU3dKbkVVSkJy?=
 =?utf-8?B?NTFNVE5sQXZkUHJEQjVCUmw5N3Y1dm9CTjdwYWVrdWt3azkxSnpYV1FKSFdr?=
 =?utf-8?B?aFZycDRwRmQ0SFNQTXR3Wm1sdndSRm9hYld6RlBIdCtUUTJydjIxejd6U2FN?=
 =?utf-8?B?NDUxbUtIQk1UZU96VXZqbGxkNVkvMVNMbWt0d2tIakZUZW1VbTFQSWlObk9X?=
 =?utf-8?B?TDUyUTNTWUFCZ05ZT1VZTXNwQ1UzdDAycmVybU11NkVVZFZxNThEY1kzSXBZ?=
 =?utf-8?B?RTJmY21IK0xya21qYy9YZXgzZTVVMEd3VTh5SjVsdTFvR2kyUU9HamgvMVhl?=
 =?utf-8?B?empDNXdxaHQ3THRobXZUd2NDZnVtRkJ4T1BtWmZubkp5RG1xcG5kbkU3MVY5?=
 =?utf-8?B?b2ZxVnZyWkhUeTRRQU8yVUpYaHE4WmtjUjJYMitRdWFuZWROZVFtNFFqaUVw?=
 =?utf-8?B?K0JIaDRxSExiZnFMVEh4Y0l6d3VwWVhYMzBzQ3Ewc3hHMUgzUUozUTFZZnZX?=
 =?utf-8?B?MjU0YXA4ZVREVUJiTzZjSVQ5TVlZVUlmM3ZDZyt0Vkl2Wmp2WnNkK3RXVGIv?=
 =?utf-8?B?Mnc0TC8xY3pGZVBVblpGZlhkcEVlNWpuQlcwUmZSUEVoYU5IS3FrWnQ5T3JJ?=
 =?utf-8?B?YTM5L29vamUySGhsOVBOYnY2NkxVczNIYzl1blNGVnRxM2FHTXE0Z0tKUS90?=
 =?utf-8?B?MFZ1UEhzRGNMU2swMzhrVWU4UFF4cVNlb3hnbGRpWXZOVmlRZ0NGOUY0c0Fo?=
 =?utf-8?B?blVDMEpncTU4ajBUMlFVdDJsckpMck5vMXNlOW1NU0VFTUMwcnRXcjE0WTJV?=
 =?utf-8?B?MDVVbDhEOGFIMGNRRUlHaThLUi9KY0x4WFBSSWF0NGZ6RHJZODdlM1p1ZGJj?=
 =?utf-8?B?Zk11WkVHcDArYjZQWk94S3dFV1NIdDFydTFyeEkxNWw0ZzBpUWxHTE9CWjZ5?=
 =?utf-8?Q?sKmxF+lv2z5OyuhwS+Rkyyco7sdbQIxlEdKOu+Y?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TXN3K1ZhTit4NmxQeWowZlYrV0N1eGlFVjFOc0p5QUFoQTRlTzZsbzBLUXNr?=
 =?utf-8?B?Y0hoaExPS042L1JOVkI0U2w0cHpMb0Ewak1temFNaTV0a2p0bDRhaThRRGRO?=
 =?utf-8?B?S0c5ZHdGbjVpbGVaS0Y5SEVERThKbFlLbldrSDBYSGd6OGJCR2EzcVRXd2lo?=
 =?utf-8?B?OVAvVitxZTBTbnFIZ2FrcnRqTGlQRHZGNWJEdVp3a1o5a3Vab0dmOWp6RTkx?=
 =?utf-8?B?dmNnQUVBdlNndVcwZFJlQy9rd2FNRXQ2ZVJOY0crSlExY2dIVDQyMUJQaHdw?=
 =?utf-8?B?ZW1jZ0dUdTVvc3VQNkZUVHNXY2ZaSTVhWkNTUEFGNVRFVG16aWZaaSt5WGVX?=
 =?utf-8?B?NTR3MEdCU3JUZytVRXMxWTdQbTIvc1MvbjZiU0NFTG5ST01mSUExSW9Icmda?=
 =?utf-8?B?WGxnY2w4Tmh3ZjNua2E4S0NTbW5ERk9tYmJEL1pLSWxNN1A2OGVadkt1NkpQ?=
 =?utf-8?B?aVJGSFczS25CS2tnVXFxVUpkTUF4VWhEdnpRRDBEQzhmVm5BR1FFS2Y2WUMv?=
 =?utf-8?B?NnVZTlJaNFBjTjRHYzhFMG1GWW9QL1N6d2xRZmg3NUNIdENEQmFLYjk3dzA5?=
 =?utf-8?B?eUNMaGhzR3ZOS1pZVnNMNXFXdlNrbjA4czVSTm1nakptbHdGV1FJZ0hxUlRU?=
 =?utf-8?B?aDlkM2t3eVoveHFtNG9aajM0VnJ2U1crNFAzZ0hyVi9kUW15TmsyUmJtRmF2?=
 =?utf-8?B?MlpFWm1Ta1I3U0x1ZHZ4M3pncGdNREtTZXYrbHVHWGJkWmd5TkIrdnlkazgz?=
 =?utf-8?B?OXpPY05QUFZZNFpEZldPdHpqOEE1MEhhU04vdjZYQTZrejRneHVPc2p0YldV?=
 =?utf-8?B?Sit1ejM0R0E5ZG9DenVWVWVoMzdRV0Q5Y3N0QkFoTjZNUHRCU0U5QXYxWDF5?=
 =?utf-8?B?N1JEcmxwRkEzT1VuUEFHM2RhQXNXSEE1cEhyNHhWaW1SZ1FkUGtSdURNMEZM?=
 =?utf-8?B?ck16RHVuVHEwM1kzNjQ3YU9mY3JyKy9LaDREeVRMYXNhUktmTUdZRHJqYTdv?=
 =?utf-8?B?azJDR1JZY0xaM3N0MFB2Sy9hbmpSWDlaeDJPQW9OK2dvdDVFWW5xTitJRi9P?=
 =?utf-8?B?NE8xR1hzekdqUG5ybEVLMStQZW9pOXN0M3poTlBVZVM2YmdyWGFZd3JmOUl3?=
 =?utf-8?B?eTNOdG5FaFI4SDIyaDR2RE1Wd2p6Wis5MWY1OWcrVGZXd0g3SDMzUE5RK3py?=
 =?utf-8?B?RDB3NVY3OUp0NzVkNVRxYkU4N1RCdm9abVhLaGxiNlp2T1I4VWo0ZFFOZ09K?=
 =?utf-8?B?RW5lYU5sbHBOTzl1VmlOdHBTQy9LdUdnQjZhdFNZL09WbGdiM3YzUkFtWHM0?=
 =?utf-8?B?L1N6WG9qYUdaY3FEV012S09ERTgxekljdUoxZDh4QTBnYVFIaERxZVlLZ2RO?=
 =?utf-8?B?WDBTTzIxOEZzaUREN3k0NjR5ZC95R0JvTGdpZnpkd1JrTFAyYUh5SkFzNTh5?=
 =?utf-8?B?YW9IMmtlUHVvNlhLNzEzNUdRNVcvTS9TL2hNeWQrN0FBRDROQzlCNFB4VFZQ?=
 =?utf-8?B?ZGg5M3JoR3pKWlZQU2thR1ZQeWZvczZrNGtUaU9RMjJGVCtrOTEwZWRiZzlo?=
 =?utf-8?B?S2RLVWE4ZjlvSDF0Q2EvV0swMUZuT0tiZytDSHppZGlrRS80SGFnU3FnUDE0?=
 =?utf-8?B?UlNqZmlLZGU4SWVTTDc2c0NOQ05EVFdwUXMrZjRDbThqLzVhdVRPd21EYi9W?=
 =?utf-8?B?SU8veWVZYjM2T284R2Z2cjNFdjRZVVc2RVprdDc5ZHhzM2FwczgzTDZzbDJX?=
 =?utf-8?B?NitkaW9PZnFXRnQwYVNRM2NYSU9nbmhmMlhuK045SnBXczRvR3FEN0Jmc21i?=
 =?utf-8?B?L0J3TWx1VDhZdldsYnZFUktDRHVpZzBZa2pDbFR1VlFyTVNOL1RZQm0yT1VC?=
 =?utf-8?B?TWgwRjF1TEJwT05QMTMwbGRLcHpxdU9UVWx6TlhDbWhrblY4N2FqUGc5WmJC?=
 =?utf-8?B?Y2tZZ1EzdFlJREJtV0NaK1hLUGtwUFpOMFR3SkhsdTJsaGF6b1hpbW9qWE11?=
 =?utf-8?B?TTY5bTAySkZVS3dlMWNDelBZbCtCNnloeS8vUXpja05JSVdQUnd3VG9hUFc4?=
 =?utf-8?B?bHVKTFh0SXhJR203YS9KbW1ITEFGamhaL3NvdnJubnBaWlc2L2xmT0Z0eXZJ?=
 =?utf-8?B?Qzhwa2dMaVN3V2QwckNzZGlxbVNQY1RwUm91d09wamxhdmUvRktlcVo2VWRC?=
 =?utf-8?B?WHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dc1f3dfb-5386-4334-3016-08dcfdfbb594
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2024 00:41:10.7750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kVJiy1uBtmJKx9uHGS03EYIbHQPckQpObwG7fvBZ8gKySHmqiHZqhrwVIR4nXHHflxJFbmIctuGw9MzLNtlBcH8ucWkuQSseUD7X3RTELTE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4965
X-OriginatorOrg: intel.com

Hi Tony,

On 10/31/24 3:02 PM, Tony Luck wrote:
> Support Sub-NUMA cluster mode with 6 nodes per L3 cache (SNC6) on some
> Intel platforms.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
