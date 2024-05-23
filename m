Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F365B8061F
	for <patches@lists.linux.dev>; Thu, 23 May 2024 23:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716508129; cv=fail; b=dGxoFNGOkcxTdy9NqRSj27LN2qfckSHWiPZwQ6U6rt4jfrIQn4wGbt6uUdkt3QRkuGgxY59mEZWbM3mX4HynT7VAbDFh+QlyRpaVukFiw0KVqNP8DRfjyEY47cqTlzZRIr2DwSLPlHJNt2bFZK4p1Wfhg2TaXH3MPJbHoS/iHS8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716508129; c=relaxed/simple;
	bh=r03fkcpnSjxc2wcf0b+xbK9kW6WbGtLr/k48qYTiuEs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=g+CYVyVDEnYOA4EdW8HP60tGMjA/qivXhz4bsNA9TdL769/wbMLzgEx+v/STfPp2F2JLUPYs04dKkIaY+ujkl8TF4JnlDMbPqngABZgsHwWW5LyyT4K4ziygGF9S9vGlQTPjA17UwGqfNxooYm05y9Uang8o1AEjKB+v2e35PwU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EU0k7xpG; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EU0k7xpG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716508128; x=1748044128;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r03fkcpnSjxc2wcf0b+xbK9kW6WbGtLr/k48qYTiuEs=;
  b=EU0k7xpGnQnzAAFmzIbwn2n0r0mNw6r9nMLakX6sKM/uDQf+xZd+6g9h
   oV6XqxzJ6pqVc9ZvrLse/BTUWP1JqKl/rnSxkSOlEF/R91C3cylx6RJ1Y
   NIgcWoxaPrd9I5iZ+qmSBiipEUubEv8w4MXsPVK4JGJOQ1R5CzdmUs8c/
   dV6/yTS2iNppmzDxlHcXsvmIoWghGrF1jxriFxrCw5k7AmlZ7gB3BaEo5
   /A8EQbZTSxnXf8QFMGroYYuMlJu/NHRBMNVL0pcaNK3sUbBOWOtqFUwCC
   imPmspFDTT0EUITkIFHORyyVUP6q/mxU9go10/kftDnVrDyRAi8EMgU3b
   Q==;
X-CSE-ConnectionGUID: O/O4LrMkSdGM654ZNEZSUg==
X-CSE-MsgGUID: eaemmrFxSKqKatj+c+3pcQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="16655216"
X-IronPort-AV: E=Sophos;i="6.08,183,1712646000"; 
   d="scan'208";a="16655216"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 16:48:48 -0700
X-CSE-ConnectionGUID: DBV/4JMsRdW/WjP3skNACA==
X-CSE-MsgGUID: LV/cjs2AThOxOa0II71siw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,183,1712646000"; 
   d="scan'208";a="33842875"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 May 2024 16:48:43 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 23 May 2024 16:48:41 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 23 May 2024 16:48:41 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 23 May 2024 16:48:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m6pkl8zzMPHIU8fzhDM34Nm1xVu4UhH4noZx4+F5NZtpzilHR253MkoS3JU2i5N8gQZFre1iuOQr/0wluo5XaqyZ+Ikeu9xquQjCJ+/HmY3QHiQhkVuBjir2E3JrVKa+/YPVDf6KnbGn0PGUxsimLwRm7feaGjoqmVZNIMyUZP2T/LwXNXz5ADjL4blfFqV2L2PRma3kqEdcTOJAxAlaTKnepOg+Nuz8g8yeczNnQ+ZYOUXkFFS83G81ed3cW5Ma5yLzNla/AlkQ0H4y0rl+0IHbXlTxUMTjcW60q3tijyZYTpFsa3SLtm0PVyA3sJ+0rXrMf0urZvsMieeZ0Sr1XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GnQ2R1IjBWlYlgX86TZVjKv2NZT15mhprJ22d/vad08=;
 b=R4g7Uf2EkYZSezXdSkjYoeeV0R6sXlsdyF+p/pXL83LMRwhoBjjmOPZlzOIbNkODhMTfD3GFAn0KUTXxB5jr33JA5FaXiQSzERn5DDJYYNbInoljCx4NtbxwsDe5UGR1Fw/w11M0PJNFt+BSN8HglyTfj8KMGrMJmXD8CZelJgDG02zNnde4RGoBNAgL5CC8QFKwd/viZx0onwPYndmQdJoApa00r0pFggYGZvmrbJ2D4E14bwNMGuzKTJaBnTy1EILGJySVhkle7PBf3Za/4ZzmIjfUKHD3We0cnlz0OZGG3Tiy6AsNipOD3BKD0ycLPQ4cTysrKI6tS8Hmj3OswA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB6329.namprd11.prod.outlook.com (2603:10b6:510:1ff::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Thu, 23 May
 2024 23:48:34 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7611.016; Thu, 23 May 2024
 23:48:34 +0000
Message-ID: <12e0979c-fec1-40bb-954f-2233c6b4a003@intel.com>
Date: Thu, 23 May 2024 16:48:32 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 06/17] x86/resctrl: Introduce snc_nodes_per_l3_cache
To: "Luck, Tony" <tony.luck@intel.com>, "Yu, Fenghua" <fenghua.yu@intel.com>,
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
References: <20240515222326.74166-1-tony.luck@intel.com>
 <20240515222326.74166-7-tony.luck@intel.com>
 <beee3369-0075-462e-8449-88fee807463e@intel.com>
 <SJ1PR11MB6083117715CD53FA4360C56CFCF42@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <013c9532-cacf-4604-b1d9-e90fdc80e7dd@intel.com>
 <SJ1PR11MB6083C6A9DFFF58FE305A33F3FCF42@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <f326387d-9636-4377-b82f-10e8d335c6ff@intel.com>
 <SJ1PR11MB60832095AC783D064541F0E3FCF42@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <SJ1PR11MB60832095AC783D064541F0E3FCF42@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
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
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB6329:EE_
X-MS-Office365-Filtering-Correlation-Id: 11981c6e-1c09-48ac-6e09-08dc7b82dbab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015|921011;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SWhBWWZmUXlOamtZbVpRdklmYjdJMlpRNzdMV2pRZXp1SHhXR1VmYnJVdWc2?=
 =?utf-8?B?S1hETEcvTEhTR2M3QlUxcTdRNmZpVmhlNTRXRnRab0NrdzR0S1dyUi9TMzZU?=
 =?utf-8?B?b2hhUFlwdkZLZ1JlMXBsK0RMODVTTXRxa3d6NmhseVQ5N1Bad1c4RTRMUjVS?=
 =?utf-8?B?djVVQWx2dTVJZ1ZjaGpUWmlCRkhQai9oRTBLSDJxdUtTbmZyVi91eWRrWXBE?=
 =?utf-8?B?YnJ3QmwyVW9PSjE4UnQ1azNKM05VaE01KzJDcnp4ekZpMDhQYjBJbFVTU0gv?=
 =?utf-8?B?NnhkNDlzalpmVnVEUDFGOG1GOWlMc3VDcTFGWUtBYjRhWnlTdXJ1NXJWZ0Y1?=
 =?utf-8?B?U2g4YVRFQllUVHNMVlRodjlGTEs4eTFhWWRqUWttdzRUY0tMb3MwUXR0Zjg1?=
 =?utf-8?B?ajl1aGMya3ZZYmEwLzJodVdrZ3FuWmw4c3ovUzlMVmNIL2FuVlhXSllxem52?=
 =?utf-8?B?clpBZ3craTlWYzV6UFZ1UEpNSE5hOWVoN2JPNGc3TG5rR1hjRDJYc3d2QmVT?=
 =?utf-8?B?K0RGNVZJZTI0OTdjTE9nTEcrOXIzRzFJZTNrMmxlRTkrUFl4NjR3a0YwMkNv?=
 =?utf-8?B?UGEzdWNlYXFZL3RxaDRFZVduN1VYRjBpMXhMU3Naa3M4L25TSEFjRzI4bTN1?=
 =?utf-8?B?ZmxrK3F6S3lqY2pTVUc1alhucDREYVhvWVNPRzdVeUNLZUpsVkJnNWFQQXRD?=
 =?utf-8?B?OXBIVFlpbHo4RXBISFlmUmQ1bVc1NEVTWmM5THFqZzE0OTB5Qjg2TERqcHBN?=
 =?utf-8?B?NTdmOWJkTDFoUzBBM0lOTW1BOURUNk1pbmNsQmFYQXQ4NzNZKzZDNVgyM2hR?=
 =?utf-8?B?OS9BUGFvSkxTR0VxazlPU0RkcUwwZG5RWVlmeTRDNFp2T0ZvNDJqSmRzMWow?=
 =?utf-8?B?QldubzlhQlB1UFJ5MUkvZjREQ0xMSUpmZVFkaW10YzhvMGdzTC9HeUcrcjcw?=
 =?utf-8?B?MVFseHdtcGVUOHRvTW9FVWN0R0Z1aW0wWElFZE9MZStlSmNZYWJ3YXVoV2kr?=
 =?utf-8?B?NjJVaXRybngwQjVsMzdrK3pkZkc0Rzlnby9mVE54bXNKMEorZkxWUTVsY3Ju?=
 =?utf-8?B?elNYMjFWODZHMVVVZWp6MWZWZUhiRVQ5TUJKaTZEWDRPM0dTTUgyMHpKRjd1?=
 =?utf-8?B?T216Q1JmUHhoMjJ0QVJOY1g5YTVGVVhkOFQydCtjRHJuc3VBU21wVFc3WFds?=
 =?utf-8?B?akZORWt1S1FKZERZQWpnZ1VWVHgxdTE5cWJnamcwS3J5T0o4L1dHRmFkMEJB?=
 =?utf-8?B?WmtINmdSNFFHb3ZFV2JIQXNXTnJRZnNDSHFGZlVINzdzVzNUUUZ3N3VEQ2x3?=
 =?utf-8?B?NDh5dmN4SXNYNTc1RUcvWlF6U2pLczQ4ZWJRUlAxRURCbWVQQ0xSWUdsZ2ls?=
 =?utf-8?B?dWJjT0xPSWJWa2dvdEZqUkpMRDdMVU41UURRa3FySGNPYi83V2dwZE5tY0t6?=
 =?utf-8?B?MjF0NDR5Y1pkTXJCZHo0eEpCWUVYM2srSUlya3dBVzlXUnN1eUNFMVhDczg2?=
 =?utf-8?B?Z29kUW41M05YRFpHTS85NHhOZXA2cHZuMW5PbVpEWFM4RGluTERHdk1JY0JI?=
 =?utf-8?B?YjUrbHZLbTVmZjJvRThwZTYwMzd5Qk4yT001b3pUSjFpMXFjcjZOUE9oUTRw?=
 =?utf-8?B?Y3BNZE5XMXJWTW9LYUtPL0ozUTdpd0o0azdIalRZd0dCbzFURTd5dDU2a1My?=
 =?utf-8?B?WnlkYVFDUjhaTi9iSUFRRjNxMVdDcG0vY1NBNzlXUWVvL0ppaGdvMHd4K2cr?=
 =?utf-8?Q?+unCzIIvH8TWNLRl8sTUNyqTMuKSRMV9yoeAk38?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Yk8ySzBGZnAzQWUyV09NSU9uWXJGMUM0YVFEaXVtRmErR0VJdEJ5VmFOcUtH?=
 =?utf-8?B?MWN0M0JBZlFUckdNSXhjdUloUFd6SzhaNGZNUWpQZGFHVXNUSUR2VFJUd2s4?=
 =?utf-8?B?bVVvbVVpd29UbjcrMjJKQlpjQTVBZVZ3QUJTRDBramM0ODQydTkzNmZlU05M?=
 =?utf-8?B?S0NHY1hIa0M2UWhmRnc0cTBQK2toMmh0TURWcHJmTGdXT1o0OWdRSWdiUXQy?=
 =?utf-8?B?bmZmb2tkZjV2RGx0cXNDVUIrNHBCRUdsckdUaVRWVFY4OXVsM2t2S1l1RTFV?=
 =?utf-8?B?RVJ3ZXg3OUE0Z2dyeGtwMGZrSFJQRG5XeExFWXk2T3N6Vml4N2NFbTNRMXVO?=
 =?utf-8?B?bUZNa2VyR2sxSzRncVRQQm8xODNtVldJWW5jZlJtbHpBazB4MngzR0Y4Tzd6?=
 =?utf-8?B?aW4vY3JYY0Z5eEx6Zkp1MDd1MGZucjJaNTVkOTVBcUZPVVhaOU53LzQ1TXBQ?=
 =?utf-8?B?OStOS2d6UWV6dS9ydzZiQ3YwcWpmTU9RSS93d0FTZFJWbkN1MHRrM0pEUXlB?=
 =?utf-8?B?TGk0SUVxNkIwSkNxVzJOc290ZXdnbzdlNlRubVBYTUJld1ZUUjFsaXo4MCth?=
 =?utf-8?B?enZhMko2L05YWlowZEZkaDFKRnNucTVWdkMxSDM1Z1ljZ3lMbG9LOGVwelhn?=
 =?utf-8?B?bW9DVElnNVJwM0V1UlM4UmV5ejRCaGtqYjJWY1BFQ0w2aHljSlZtZHpuUm93?=
 =?utf-8?B?V1pHQ09oMmw5L2FwNG41cEFDa3FwY1M2bW82NEZsalE1SEFEbjhCS1paeldl?=
 =?utf-8?B?WDB5dXd0WUZ0aWhlL085M21Ld2pvZ3ZsSzRUT1kwbjFYYXRFaDgwaTFScmVu?=
 =?utf-8?B?MzI4dVdqMWJqV0dubnJLTlFzZmFtdlpka0ZTQnMvN1VFLzZoRm56SWdTcFRQ?=
 =?utf-8?B?UDNhSjhjT1VZWXRwL1ZEZG1jTXZxTG40VCtaN3ljRHE2eHhCYm5wY09DYnpy?=
 =?utf-8?B?UERmR1B2d2UrNUl4dDRGWE1HSzVTMS9veEFIcVZ3WFJrU1NrdlNNbGcvV3pV?=
 =?utf-8?B?R01EanNnSGVkWERtR1FSNlhrcXFtZVRBZ3Zad0oyMGFDdGhEMHlkblFzblRM?=
 =?utf-8?B?SFl4S3ZxVC9Od3pBU1k5Q2tuVVBxMDAzRVgva3ZtbFpTeklWbGtqQWx3L01o?=
 =?utf-8?B?cWVGM3VTVEJ2dUplZFB2MDdxTEc0QmROM1RmQThRUmxQY0p4VUFpc2h2dVZ1?=
 =?utf-8?B?N3p3VDNtYnRYc2RBcUJDcUpFYzhJTlQ4aFhQb2haajA3S01vVkZPMHFtOVF4?=
 =?utf-8?B?MmkxZElYTTBtZlhEdnhHZjFhRVlvV0ErTWswZndnam5Va2Y5bG9EcHM5YVVx?=
 =?utf-8?B?YmVlMlh5OUdlek1sV3hMUFNYdldQZ0VHdTczRFNZRjhURUt1VEZRYWNqcFd2?=
 =?utf-8?B?cXVNL3RWTDErZ2h3ZUpGQWM3YlUxQU5xU1VWOGFwb0h3Y0xhN2x5N1lXd29H?=
 =?utf-8?B?YUVTdmZnRE4xdUhKNExZKytQN2gwNkg1bTVKWjMwazJHT3Y2ZTRLdkIyOFl6?=
 =?utf-8?B?NkpQR2FZaU8zcDdQSFRyRlVpM09UUjFNdlZMZnYxdWpINmh3TjVBbTV1Qk91?=
 =?utf-8?B?dnM3T2xHNXRIT25zMHBMeFdFYW53d1FGWXhaZDZ4K1lkRXZBYStodmt3cmgw?=
 =?utf-8?B?VnVrclU4akxYYmRrRTVmRzE2YVQ1RG04elJXSWsvcTFqdmRna0VEVDZydTdN?=
 =?utf-8?B?OFZBendRZlpUdk5tVm1GdTA0WDg1Ykg1V2UrUXZFcTR5T1djMEdseFJlbEtY?=
 =?utf-8?B?cEdjNlF2Y1MyMk96bERIZ2JibHF1L1JwVTVEby9HNTRlanFRdTB3NlB4UGVE?=
 =?utf-8?B?Y2cxMGVENFg0QmkrUjB2S0RQajY5SDNRdkJQZmJmdVV6WXhQWE9KWnErMllX?=
 =?utf-8?B?T3YrNzZxTkcwclhhSGNkVVJ0Sit0QnhEdnhvTEhzc1prSDlJbUxaQlQ4bDlp?=
 =?utf-8?B?alJYOUVSZU4yR2EvcnJLM2c5aWZ0bUgvRkM3bTZKZGFlcEJXUStkckNiUWZv?=
 =?utf-8?B?Mko0dzR3NmdmRFBscU9NbEIrOUVWaHBhUnNWaW5KN2M4NWpGR25hL0NrVE5z?=
 =?utf-8?B?WGUyR2tjVm9kM0RBSzZ2N3N6NWs1cE9JVjZYTVhUdHJYZ3dabGt1SENKY0VH?=
 =?utf-8?B?L20rRmpGTXR5TWI2S2E0VXZOblltdnRkdmFJVGJXOFh3bW93UTJoSG90R0VY?=
 =?utf-8?B?OEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 11981c6e-1c09-48ac-6e09-08dc7b82dbab
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 23:48:34.2210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ieu+KjePMCYiNygu8X+wdXDA2FZWtEJO2iQOxffGCNbBw3hAOcxCAkP0mNrnjQMEXsu5m9qpcWnnDtsWigi3jgZPV30xTT+dUT3Q8V0wnG8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6329
X-OriginatorOrg: intel.com

Hi Tony,

On 5/23/24 4:18 PM, Luck, Tony wrote:
>>> So (in arch/x86/kernel/cpu/resctrl/monitor.c)
>>>
>>> static int snc_nodes_per_l3_cache = 1;
>>>
>>> Set and use only in this (arch specific) file.
>>
>> Since this series initializes this value in
>> arch/x86/kernel/cpu/resctrl/core.c it is not clear to
>> me from just this one line how you envision the changes.
> 
> v18 did the initialization in core.c. But since SNC is all about monitor
> features it looks more logical to do this here:
> 
> resctrl_late_init()
>      get_rdt_resources()
> 	get_rdt_mon_resources()
> 	    rdt_get_mon_l3_config()  <<<< Do SNC enumeration here
> 	

ok.

> 
>> Just to be clear ... when I refer to arch specific and
>> filesystem code I am considering how this series integrates with [1]
>> since that is the direction resctrl is headed in.
>> Being "arch specific" thus does not require that it be moved into
>> monitor.c - it could be added to arch/x86/kernel/cpu/resctrl/internal.h
>> where it can remain after the fs/arch split.
> 
> The logical place to convert from logical RMID to physical RMID looks
> to be in __rmid_read(). Just need to pass in the domain pointer (from
> both resctrl_arch_reset_rmid() and resctrl_arch_rmid_read().

This is not obvious to me. Do you need domain pointer to figure out
which node the domain belongs to? It looks to me as though these
calls are already running on a CPU belonging to the domain so perhaps
smp_processor_id() is sufficient?

>> It will be very helpful if you view your series while taking
>> [1] into account. For example, when looking at [1] you will see that
>> mon_event_count() and __mon_event_count() are resctrl filesystem
>> functions. When you consider that it should be clear that adding
>> an arch specific get_node_rmid() between these functions will make
>> the arch/fs split more difficult.
> 
> I'll try to keep that in mind as I rework my series. In v18 my "sum" code
> went into __mon_event_count().  I'll see if I can push that down another
> level.

Thank you

Reinette
