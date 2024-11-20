Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC758AD27
	for <patches@lists.linux.dev>; Wed, 20 Nov 2024 01:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732064933; cv=fail; b=OzZLnaZhERfgRmlqfJRH8/cVIA3Qup7FCt6TMQPdumwMnxoIMdJRd90Vor8cM+wm0GnQLj5/BDj+4Ufn6GKm6ZGi6LAhR6w/9vpsSBD98YwfFC7i/KutJCFti0YKc75InUUqu5HJS+2Xps0gE5jKvfeGxIyX6BMaGVDmxqVkqIA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732064933; c=relaxed/simple;
	bh=rzu/9acDqxdD8J6A51TDMv5hWYizQLE/hwiURUVHx0A=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eCmV+yApUsa/UvdOtj6SuvChubPiWVyjtd6Ru2rR7ap7X8ZVmlrImRFlluqHfTVi3UoiSHWrsT2Zu+yKBIDtkSZjNDSsXXiv9edXnit6T6rCO//ZH5i5USpx84k3BD3Q0PEMSVNNWWvH8MG13L10CW5GjEP7RsKOU9FAYsyopEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W9NW/N6F; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W9NW/N6F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732064932; x=1763600932;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rzu/9acDqxdD8J6A51TDMv5hWYizQLE/hwiURUVHx0A=;
  b=W9NW/N6FbYI3X/Nfju9Qbtkfr9UJRRzmbC8Jd8vxsudOan4+Wg4E/kh9
   3LaXIyl65NK78ZlSfFd7i9eCHkPeJBCMTx8b2WM3g0390fCT1Y7hCfr7o
   1HKcavKGAfqgS6VnSzogHOwEbyCmNKWpv+sMmytTzQK8+TlK8tybVg7Ib
   +caPX7xwjlguFOHqmABiTCAMpln3kT3ztUBeyaLMTJ3SMtNtmDW26t/u1
   paaUxg3RCPLm6+eg2DWsyl4rfeAeFaWSFLYnRmWc5Ss6Qbf3f88BLgrA3
   twkwEhCYwkKIfobKerMp/oIE0jtuzj5Nx84GNBlm/FEST86bwU/4pX0cZ
   w==;
X-CSE-ConnectionGUID: yOs3U/o8RcOxlQi84JLTlA==
X-CSE-MsgGUID: 6tgZ4D8VST+NiZXmrXTZww==
X-IronPort-AV: E=McAfee;i="6700,10204,11261"; a="32212352"
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="32212352"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 17:08:51 -0800
X-CSE-ConnectionGUID: 9CczjyGmQPGUV/6XANIXpA==
X-CSE-MsgGUID: 73UBwA5cQyebjhLM5kFIMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="94819219"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Nov 2024 17:08:51 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 19 Nov 2024 17:08:49 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 19 Nov 2024 17:08:49 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 19 Nov 2024 17:08:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BRGyCIgCSN5AJ27TbEojq08XZfTNtOzOpRJ9cW37X3tM7zbd1hcFFZiH2o6wmH6w/nzxY9v/O9hye6Xrl+KpbFtwPwrfsPIknioAO2h92UgtR2YFdUvv84Qi8RygvkFFbjRzslAno2i5mkte2tQGcccGOj5YX6CJR0N5hwZ+YQvjZl2yRA3LObw89/GyohhftAqX7mLx4gouY4IuzJX7i7uTgACqQJ/cldWmWW9psOeLejjZemjU7R//dBBbwJEYvgYdKdOGZ/XIjVeaYw87e73dQcL4T+JchDPToYJpyyhvwzGoKJlTzP8rw9FW+86wd95WaK4kDhuS5kTU/rvQ/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AJ0pdzrYZSBnmEyFZrKKqhaEdXB4NpHIOtWOGrJZQM8=;
 b=EiaH6lYwl9/zlBrlgObDUZ3uEXeCpMlFau1JRGPaMD/hGlADyjqsdOUDa0lrk5PISoZcGjlCHWmQJbukAXJEgtTHPkWftRL5J5nxGqeIpDMZNp8lo7iSEFA0BdGagvNSLq9nD35El8O1BpOFKhkQksZHJuEgBJ8gTMMYPpikcWlZrVE7nQfLybYVH+4hsCYRWnSwJWNs7tTWf/A+zpjNyIHPJb8nwIEE1LdEab+Yak2/SMfaGgtM1IIgXBXfWVam+RSO8u2sJ11x7ZNBPRQdoX1j2G6a+bXtfQxFOLQ2bfX4qbl+eTrE8sS/UYeBUW+yIj0dfDdYzHUPV+zO7LdZzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CH0PR11MB8190.namprd11.prod.outlook.com (2603:10b6:610:188::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.23; Wed, 20 Nov
 2024 01:08:44 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%7]) with mapi id 15.20.8158.019; Wed, 20 Nov 2024
 01:08:44 +0000
Message-ID: <515914f2-501d-4df3-894a-2d255d18be1c@intel.com>
Date: Tue, 19 Nov 2024 17:08:42 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/9] x86/resctrl: Prepare for per-ctrl_mon group
 mba_MBps control
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, "Peter
 Newman" <peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>,
	<x86@kernel.org>
CC: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20241114001712.80315-1-tony.luck@intel.com>
 <20241114001712.80315-3-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20241114001712.80315-3-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0162.namprd04.prod.outlook.com
 (2603:10b6:303:85::17) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CH0PR11MB8190:EE_
X-MS-Office365-Filtering-Correlation-Id: f9ac8178-f9d1-4de5-9528-08dd08ffe102
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dTAxSG5vQkZSNXJMMWFwU1NqT3lBKzZEQ25TK3EwUHNCSmx0dHQ2QjM0WVNZ?=
 =?utf-8?B?cWdsQndKVVdLSzJjcXRzbXV2MS8wdmR3cTVaeGhTdGtERlpxbEZjVkdsM0VH?=
 =?utf-8?B?SnB4VTJ5UGtKK0krNXVYOE5YSjJtRUFzNUp1dEJOL3pUSkladzlDSlpBdXZ2?=
 =?utf-8?B?U1c4cy9EL202UCt6Q1Bma3ZGS0QrVWw1RWYxaHV0TDBaQm1OdVNTcXBhUzBV?=
 =?utf-8?B?SncxSmdJTThwZCt6WHYyNk5rN3lzRXY4dmpCTFI4QmwvVWVhdzdTbDBJMkU4?=
 =?utf-8?B?RG1EbHpBQkxzS1c0OVhlVVRNMDV6VWM0Vk1sejhhV1JCRDBWOGZCZDdKY1d4?=
 =?utf-8?B?VGdUVmJKOElxcnFBbHNEUnFIeUtJSnlQQjlYL3pIaUV0Tm41V2sxUEM3WlNr?=
 =?utf-8?B?MXg5bXRHbnR4RkVUMUZoK1NTWEF1Vk5nRnhodFkyYngxNURTTTBnbWVXcHly?=
 =?utf-8?B?Q0hhWXJ4Q3pMVWJoRjJlMU13N3VFTWtzUWZPOUt2QThnenc1T2h1dkJOdlov?=
 =?utf-8?B?K0kvWmF5SFMyb2hNVnI1djA1WmxTTjRMNERHaE5zOENCTDNPeGtNc2prbFB5?=
 =?utf-8?B?S01RZlplTE96NVdpNmdYZk44eS9GZXVIVXQ3L1gzMitnVkR4TGU5OGNMbmg4?=
 =?utf-8?B?N2x5ZFc4UXYrcE5vSndmWkhDOEYvNzRiZVZMdTVEVW1GcmVtTWMyTGxuTzBh?=
 =?utf-8?B?SFgzSGZVcWZQalVkWEZ4M0gyYWJIT3ZQcWZQb2hYZWJwd0ozTGFFdmY5YUhy?=
 =?utf-8?B?TllITC91L2V0YWZvYVE4Mm1JTlMyeDRuMk1yR01XaExCRlFwSFRHYXE3VVVj?=
 =?utf-8?B?bFljcWlsakNGY3JGZmo3REQ3VmJxYW0zbFJIWFlOb0VTalFZeG5QQjVicGlr?=
 =?utf-8?B?UVIwZjFCWTJFNTlyTC9aczBGYUlkT3NVMHBrZ2RRcEhnOThjWjFlMUp0cy9m?=
 =?utf-8?B?ejE2dEY3S3ZOd05sek02eU5uNUE3NExIQ3p6UmpDSjNLc0N1M0FRck1CS1Fm?=
 =?utf-8?B?QStnSEM4VnNFdnhnTW5wUzg2bUhhdEpzbmpzN2UyeEsxU0ovV29ZSUp3OHFa?=
 =?utf-8?B?b0paWU40NCtkeWMwemE0RzFveUcxbUVvQVdBSm1UNTlaNDQrcklQK29DL0hj?=
 =?utf-8?B?SGMrZHl1THpBZHdHSVcxZldjRlVHWEZqU3RSUkQ4eEx5M1lFTUlUeTZ3VHkr?=
 =?utf-8?B?SXZnL0hhdUtWeEx2dHlFbDNiSU9QRzc3Wkd4M20rckl1TnA0dG50dmJmTHpR?=
 =?utf-8?B?bWQzZ0ZGOWsxTkhBaFcxY1VSaUptWHlOVDNEcnYzODNWRWxZV25QM0h4RkxX?=
 =?utf-8?B?Q21BRTlibDFVdUdZU25qY0pjREZQZ2MxR3Q0SlJhR1BNWjMzcGErWTJBZHdU?=
 =?utf-8?B?QXp5eUk3Szk5R0xmaHhleHhPVHVUVzQ1TVIvZnoxUVQ3Rjhwb2V3c2tkaW96?=
 =?utf-8?B?UHlzWEdCeFNiV3Z4QXZGNzdFcnFsQ1BqMnRFLzErTWE4SDhycnBWK0liSjJi?=
 =?utf-8?B?SG9QU2d0eHlET1JBYWFpU3hQc3RxQk5FN1ZVcnlhbGEwZk5ic2JBOGU0MTV2?=
 =?utf-8?B?ZzJHQ0Y3NUlQVG5UNzFxblJVRFpzeVZ6V0VyVE42RkU0NHlENFR3Nk52SDY0?=
 =?utf-8?B?ZVF6Z2owNk9OK0dtNk5VOHdIRmhnendSbHZTc0hCci9wWEM3ZURLNlV3bTRJ?=
 =?utf-8?B?T1dLS0tzRWtLbnNuNkVaZWNMQjBFeW9QcXVQdDBZbFU2cVRSbTNnOFlFUDZp?=
 =?utf-8?Q?WFlNrwWrdmuRRioQmM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ODNnU2VyeVZrYldrLzhueUZFcjNUZW5Ha3R5LzE5UWxYK29XZnJKaVc0ZmJH?=
 =?utf-8?B?ZS9VYTA3eEtaNERzU2QzUXFrKzF3dWpLenkrcVNySndyZFM5ZDNzWGJxWFJJ?=
 =?utf-8?B?SmdmQVdCZXZRNFVlYWM2UlJQMkprOW55b3ZZenB0UGlHMWtMZXNtalBaTnZN?=
 =?utf-8?B?bzhXNjUxRVVyVDZNZCtiQjRFVVN3KzAvRzU4WUxBNEgrZkRIZ0lUUTIxdmdW?=
 =?utf-8?B?cUpscjJhNnNIWXRVS3gwK1VUWndDdU5INVdHdzc1ZDR1ak40OGNQUDRvMy9H?=
 =?utf-8?B?VGFhMXNhWDdhWGp0ckEwNmhNREZtOUN0Vzc2eWIwdldZWTNzTllIU3B4cEFX?=
 =?utf-8?B?Z29nMExIT0g2RVVLMDdyOHNNMGkzMzJnTEpzQmVXWStVTGkvRXE3ZHVEYm9r?=
 =?utf-8?B?VEpWb3dXaGZhNlVCS2dIazBEQnFURllScEIreVZHOFNtVkZZcDdXRXVvazVS?=
 =?utf-8?B?MVZBbUlTMmZsd0xGOFN1TURISUsxZ1dDaFJXRmlvd2x1OHN2emUrVkpUbnVh?=
 =?utf-8?B?SnFQZWN4QWtiUVdwRDBlRm5MbjA0U3RtMTFwRDZicWUvdlIyRzNRTXNSbmRh?=
 =?utf-8?B?V2pEK0kyWGhSajB4L3dyM2xwcU9EVkp2KzJFWWsyazY3SUtRY0ZHUkNCVno4?=
 =?utf-8?B?SHBUci9YdjBiYUd6TTNzUzlmWTJHUm11YWNocE9tUHNmSjZMbjU5TVljOHpo?=
 =?utf-8?B?TFlIZjhZS3FiU2l6b0R2TjlvdUN1djB6YStSZXdZNThrbkVVZUxscGRTWlMw?=
 =?utf-8?B?elJuUGhyNG5vN2IvQWx2RTFUWHV5Ukp0SWFQSXhiQldpcFRXN005dCtaNEd6?=
 =?utf-8?B?SnYvZUhIRlRMT3BlcWtFc2tLY0J1M2w1b0ZQRlE0ZC9qbmVZSktJd2Q1MS9N?=
 =?utf-8?B?L2VUV3VhVkg0MXFmc2xpTFVha1ZOQWJCUk9RZ0xyOUd0WDUyelg3akVkREkx?=
 =?utf-8?B?WjdUR05Sekc3VFNJOGNWLzRjazBhUXNnS1ZLa2tzb1lkblp4Nit4anRpRWFW?=
 =?utf-8?B?YVRKekZDQ1FOVm5NU3hNRk5pNDVKV1pWdnh0UDlmUFJrb3hqdklyN0tEVFAx?=
 =?utf-8?B?TTJKbVJ6WFMrSmR2L3NZU2toTTl0WklYM3pLTmZsOXVUd2FRRVZSbkFEaXBR?=
 =?utf-8?B?T3B3RTdqSHJ6YkZaZS9ET2pWNVh3V2w5dVlwczJqMmRoeFdJcjJ4VVBOcDVE?=
 =?utf-8?B?cFpvUE9iQkEzV0pMOVpEd1FpampzdjBHVXc3bldCYjUrSWZYNDlFRkMra3pm?=
 =?utf-8?B?eW9qdkhIeGh3cHFFQjlOTE54ZzBaTm44eTlxaUYwTnlFUHZsUlU1WkRwMFMv?=
 =?utf-8?B?Q0NMTXhRcXZxRFNtWjFKMzhvMDd0eFEyYzhKaFozRk1yVjlNZWl0VEN1UkVy?=
 =?utf-8?B?TEZPSk1zaG9idmQ4ZFk5cU1GM25jdTV0VzF3RXZVNlozb2EwQlNWaVBPOWpB?=
 =?utf-8?B?RTlndkRzem0xSFkxQ3JRcVIwSE5LcExzMVFSeDAxTlNRdDFhQzRWOUVMd3gx?=
 =?utf-8?B?c3A5K0ZnZlNOeGNYOFl6SVZTa3hvbE9WU1VUZEVlM2lrdjlONi9Xa3hDLzJa?=
 =?utf-8?B?dVBWRitPanA0dXRkQy8wNm5kMDFqQi82Wk9ZN1NkTFZQYThBdzFqbmczTU50?=
 =?utf-8?B?Y3JZZTJYUzNRdWtrc0QxZEpheVk3aGFkODQxSGtsWjdTWTdrVDRJLzJkN3RU?=
 =?utf-8?B?ZlNtSjlLZS8ybnNjdWtJUEg3dnpMZUN2RTlJN3NuMFB4V2wvUlEyQ2RVOU5k?=
 =?utf-8?B?ZkVEdkJGT0VWRVIyN0FXa3Bydm00QTZFbFlIRE1Sc1FHY2pSbUlKRUlSM3Qz?=
 =?utf-8?B?QWpER1lqcEJ2aDdvV0xKOU5BOHVmTFY2RFZhKzVGNHIyM2FiMlBVVGl3Wnlo?=
 =?utf-8?B?Z3lJcmY4NUwrRVRmM2hvdkNqQ0lmNVA0TjVQUmFBMDlWSlp0S2VSbUJBNStv?=
 =?utf-8?B?am13aTU1dHVySHJBdWw3ZzB0MWlYN3gzaTBzMGxSV0NuSWFMeWJMZVN0V2ZX?=
 =?utf-8?B?ZUpoMzEvZ2F6OUhTNnhXbXNhSmlONWtkM3ZzSFErZ2NoZFgyeTlYdE9mcTFV?=
 =?utf-8?B?d00zaDRDOTRzKzg4SmU2S0djOVoxKy96U3RkbWd1RUNER2JWRWhjWkRLd1hk?=
 =?utf-8?B?eWdTNFptOTJKcDh5ajRVWjRIQ2RZUm9VbFZtbUUzNjkzeDFRMk5CSWFPRk82?=
 =?utf-8?B?SlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f9ac8178-f9d1-4de5-9528-08dd08ffe102
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2024 01:08:44.2649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0zqLaKNoY+b0ivgMtcIK04GUol5uqAGv8VWwtv+eDl2C5aXOCG2FnWHqeE06O9BWHIO+WOhv7IKC4d0TlmqyFmI5kKYRgYlXyoSXGX4KhhA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8190
X-OriginatorOrg: intel.com

Hi Tony,

On 11/13/24 4:17 PM, Tony Luck wrote:
> Resctrl uses local memory bandwidth event as input to the feedback
> loop when the mba_MBps mount option is used. This means that this
> mount option cannot be used on systems that only support monitoring
> of total bandwidth.
> 
> Prepare to allow users to choose the input event independently for
> each ctrl_mon group.

The lack of detail on design and implementation leaves a lot for the
reader to decipher. For example,
* the change appears to create a contract that rdtgroup.mba_mbps_event
  is only valid if mba_sc is enabled, this is "documented" in the
  structure member comment but not connected to the rest of implementation, not
  here nor later in series.
* the patch uses *three* different checks to manage new variables:
  is_mbm_local_enabled(), is_mba_sc(), and supports_mba_mbps(). Reader is
  left to decipher that all checks are built on is_mbm_local_enabled()
  and thus it is ok to use these checks before using the value that is only
  assigned when is_mbm_local_enabled().
* clearly mba_mbps_default_event cannot always have a value making reader wonder
  if enum resctrl_event_id needs a "0", takes some deciphering to get confidence
  that its assignment when is_mbm_local_enabled() fits under the contract
  that values are only value when is_mba_sc() and thus any code following contract by
  first checking for mba_sc should never encounter a 0.
* based on premise of this work reader may consider what happens if
  system does not support local MBM. more deciphering needed to get confidence
  that while mba_mbps_default_event will not be set, since is_mba_sc() still
  depends on local MBM this still fits under contract that mba_mbps_default_event
  cannot be used in this case.

Of course, it may just me that needs more help to understand what a patch is doing 
while having little insight into what it intends to do. I thought by sharing some of
the questions I felt needed to investigated may give some insight into the difficulty
a cryptic changelog creates. Review could be helped significantly if the changelog
provides insight into the design decisions. 

...

> @@ -3611,6 +3613,8 @@ static int rdtgroup_mkdir_ctrl_mon(struct kernfs_node *parent_kn,
>  			rdt_last_cmd_puts("kernfs subdir error\n");
>  			goto out_del_list;
>  		}
> +		if (is_mba_sc(NULL))
> +			rdtgrp->mba_mbps_event = mba_mbps_default_event;
>  	}
>  
>  	goto out_unlock;
> @@ -3970,6 +3974,8 @@ static void __init rdtgroup_setup_default(void)
>  	rdtgroup_default.closid = RESCTRL_RESERVED_CLOSID;
>  	rdtgroup_default.mon.rmid = RESCTRL_RESERVED_RMID;
>  	rdtgroup_default.type = RDTCTRL_GROUP;
> +	if (supports_mba_mbps())
> +		rdtgroup_default.mba_mbps_event = mba_mbps_default_event;
>  	INIT_LIST_HEAD(&rdtgroup_default.mon.crdtgrp_list);
>  
>  	list_add(&rdtgroup_default.rdtgroup_list, &rdt_all_groups);

I do not see the default resource group's mba_mbps_event ever being reset. This means
that if the user mounts resctrl, changes mba_mbps_event, umount resctrl, remount
resctrl, then the default resource group will not have the default mba_mbps_event
but whatever was set on previous mount. Is this intended? No mention of this behavior in
changelog.

Reinette
