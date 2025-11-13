Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E26423BD02
	for <patches@lists.linux.dev>; Thu, 13 Nov 2025 04:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763007131; cv=fail; b=poT632ZuEa9sWWvZYoIDLxLO1IyivmY6xlLHj/MR0kvDS8kimR5qGo86Hx9/aW2MxyntvrdHE+aBZaGIzBIwkuk1xLkY2Li5GJpKW/sYwy5HOQEvPFm97xiUwCTeBhy6XGiok9pYWaZ9noGwqRAl8pzrwGFLXyp2PrYw3wuM2X8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763007131; c=relaxed/simple;
	bh=g3BuLH4by0l+haBa1QIGaxkAe3pMIJXEL7Oq7dbM6oM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=J6NfVDD6IrEdKK5hxGGOUnoxxIjazg2CTosSPCbUGXXFm7uIncicXmTLqWsNo2BUhiUXE9cNMxO8QrYYIcmbxQ4mNaH6WZOdE27Z8UBm0iLozkWoLbyie8dkb6ZRwqARkLSNjkLxnkCTRHkkDaSKBxY6U7AA6q/iIS2e6yhythE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cejdhMPX; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cejdhMPX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763007129; x=1794543129;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=g3BuLH4by0l+haBa1QIGaxkAe3pMIJXEL7Oq7dbM6oM=;
  b=cejdhMPXZ6kkN1UFMFutyBkiiVhUQkb29IvBkNbtozaoGYkGckf2SNAH
   jwGr2SeppwNtxXXj28xsEl/QhinbRfN2yyenF6Kd9LbMFeAtPI11u0dvD
   SjGQe3cGpsMBolnapEtf/tlgpGWCRGwc+/Phzvuy1pWgKUolttse6aiuU
   LkBf8F9RkooUnXUkcDvFnFkZ6wPOVSfZ4IZSAoewRZWxzeNvgdi8LBUfA
   VEGTj7himD4d8oUMBOfVFJtIT0qa4hosQzpOcQKSiv0XjAjA+4+tX7rlG
   +NLFY3yYPIXutYbzV9hhFPowJo54afKUIAorvs2KyNLS7h/k9QahUJmPQ
   Q==;
X-CSE-ConnectionGUID: HcXdVVIHQDWGzb5aUwbD/w==
X-CSE-MsgGUID: ZgZ9z5IIRoeUpV6BnJc16g==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="76542631"
X-IronPort-AV: E=Sophos;i="6.19,301,1754982000"; 
   d="scan'208";a="76542631"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 20:12:09 -0800
X-CSE-ConnectionGUID: Di0YHnvRQJ+ir8JSaUDkcg==
X-CSE-MsgGUID: +AGemEodTG+2iw0UEg+zJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,301,1754982000"; 
   d="scan'208";a="220154990"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 20:12:08 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 20:12:08 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 12 Nov 2025 20:12:08 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.0) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 20:12:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EBMJ0CWsuU0O2CXtaKAPE/DDJl24XmK9yiX0CnbSn0nMHGWJCjs5JN7Yu7+oGtczrM354oeB2WGGjvWPVSZgQVuXXHNPwsNUpQmILFtEXP6jJvTdGoXHDtKt2cLNsPbwabkyVYfioQUjh4nn2k66ahqk8aOvjSNkOY/CQKL1pXujOsQ/6pqNsxL/4UJ+1Qvg8yMMRtoxd4x2jVNG5Fq9xghHrPR/VZsZkoMeS+10vrlobZxhp183YqYfAzxCOoFsN0qFRGvx6eJDbBdihst+kUYQcITNE7QomHKNNSD1xEGKi5MHWu6tmoOLoiqpV8zjpxhjzSIEeGny1qmT9rhQ6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QpRJ4XXtHlRcfH6jeXiZqrxZTsE727gq0USb/wRSzeA=;
 b=wkFrB+BgxxM2Y5/dO/79vmqu6OKgnWbhabn/+SxBjd6q5SQV4V12nErCwRMhwbRQ4V96x5WoedwJ1S6QW3Ec8mH877rw0CXnDEVemYO5YTKzjgoWoZwmflotPiY8Vxm1nW5vfSjyG68V3wkjSZPm0ddUZohAl3vlVegfKsTb4DxO/xhoBsn89Nsh9N6W0mI2CAi/7GfoXqQPtaQFPzid/RDTCichmPqZ72RyItER07AnxkUPKFEVY5tHnTuvYz+z02j+n/fu95WOBB3rgKTIdMLTqXpJtlkrPYgnhUOLt71J8LtX2VmL/JLoEKK9/ZSp3wqgUUwFpqkH5dtJKjW0HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM3PPF341F90799.namprd11.prod.outlook.com (2603:10b6:f:fc00::f19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 04:12:01 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 04:12:01 +0000
Message-ID: <7deaa25a-ecd6-478c-91f4-273aa1f049d2@intel.com>
Date: Wed, 12 Nov 2025 20:11:58 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 16/32] x86/resctrl: Discover hardware telemetry events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-17-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251029162118.40604-17-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P221CA0002.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::7) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM3PPF341F90799:EE_
X-MS-Office365-Filtering-Correlation-Id: 613cc39f-c7ee-4e97-c174-08de226acb8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|13003099007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RUxDWVBQTC9ZQkw3V3RHdTU5cGJ3aDJpV2ZpaGZQMWNEdDh3TXJvN1NwalRu?=
 =?utf-8?B?MTZOWGNMdGZYWUhaNUZiNFhVcGgxUklaOVN3cG9vWnNZMXMyaFI5SVhnTWZq?=
 =?utf-8?B?UWhKWTZYbld5d0dBK3JNaFFGcUtQMGdibHhOSHcyemtSY2xlM0doQTgzTWxl?=
 =?utf-8?B?SmF2K2MyUmtaUUVQZXJzUjQwSUFUcGFkb3hBdUVQa1pXNEFOVnh3MTlSaHNE?=
 =?utf-8?B?dFZvOHFKM2NYV1lvNktLaUpNWFo1aDczVStQakk5MUUzeWRLZXYwWmx0WSt5?=
 =?utf-8?B?N0dZZjJ1VElMK2JDL1hwNlRibnBCZzI2NHcrY25UWHdhd3RGTWtKNFQ1aHdY?=
 =?utf-8?B?RHd5VEJjMFRxZ2paQitpTjNrakJBbDNYalVWbGFGWlRvNnNUL3gvR2t5VjI4?=
 =?utf-8?B?RVc4UHlVVjNidEdLYytnZmU5cm5HL1RBUHFSeUt5NTN0NW16eHAyemxLQ1BW?=
 =?utf-8?B?NkNweU0rYkVueUdmUmxuRFdHTUhlbUZsV1o5cExqMXpZSjRubXBVQjhlQVhY?=
 =?utf-8?B?ZHNnV20yZE1LUitnNk5aOG9LNG5wcFJPc3o4UWptY05JdFhqRGxYMGlsR0xu?=
 =?utf-8?B?NlZyOUpBKzBzY2ZBdXhzYkJoYXVDNENJOU1nWGFqMGpLNnN1T0lRdmxITytZ?=
 =?utf-8?B?NGhTK2EyUjZYcWJvR2ZPTm85MHI2b2MySkNSaTZRN29VQXYyYXcvL1hjOVVI?=
 =?utf-8?B?dFV3TFZKNnlIb21HNmwvSzVpaWVMZjQ0aUlDTUFmL3ZZKzVWVllLZUtLbDQ1?=
 =?utf-8?B?enNMUkU5ZHNsMnhydWVjZndyTjlKaXZSV3lVQjlBb3dPdXprSElBelVNUFd6?=
 =?utf-8?B?Rjl4VkgrZko0SmlNRnRLK3JGcy9GZFRTZ3VOSFluejBzRzIzU212d0NaK0x1?=
 =?utf-8?B?REtGb0hrQzdCeEtyOWhVRG5VaFk0REpWUGZVclJlNVpkWjJrQndlbnZ1cm51?=
 =?utf-8?B?eHpFZXdGZDVjL0VmTVNQUkJPNzNhd1pQWUVYRkVzV2R5SjFBTFNicWo3WnZi?=
 =?utf-8?B?K0VkcEFTQ1RocGZWbWRKbzNYYnQzVDl0T3hiTis1dm54elMrSlJDRlpvYWpW?=
 =?utf-8?B?ZWFSSXhic2Nvc2M0dGg2a3l4c2xoVVBZU1U5dkI4am1kakNIL09HckJyamIx?=
 =?utf-8?B?bFQwRHlpaGw0K0Fva1VTY1pHeXdkZ25EMk9KcjNONEx0TXRYWWg3UFVONThP?=
 =?utf-8?B?NXd3NHAyQXlBRGJ0NGV6eGdvaEVTa2JUWkVBRjVXbnE2WWxEYnYxd282TjYv?=
 =?utf-8?B?VDN1VG1mRW5oU0VtY2dGaW44a29LSGYzVEVlRUJZVjE0VC9vWFp0WEU1QnNO?=
 =?utf-8?B?dlNkZzJ0YTRUam5TTHc0eWRIayttREl6aEtpNURWOVVYb3ByeW9wUDEvMnQy?=
 =?utf-8?B?ZUFVZTNzTTJSMS9iU3paM0FJaUdvd0JndXNWejNsakxwMkF5OUI5L1E5TU05?=
 =?utf-8?B?T1VoY1ByMzdQT0VqK3oyc1NhRlowaGZRdStLWFNsVk1yZUdlTU9jQ0tuTTMy?=
 =?utf-8?B?UmMrTXJCR3pzbjBDa2lwbUZiZU5MajdCYXArdnhhckdWNGFmZU1ET0lUMEYw?=
 =?utf-8?B?bnE0bGlxZkN3VHppLzdyQXo4OVNudWYrRjVlRHpsZGRoaE9Xell5NVM2WFhT?=
 =?utf-8?B?dVQ3alN5ekpJTkpBYWVibXF5UEp1dSttRlZ5WmRMQlZPWmpOS3NYTnQ3eExW?=
 =?utf-8?B?VEJEVzR6cS9aMXZyUlpTTGcyZjBLQzlsTjFFaXVJbFgwRXFFczVxMDk2Y1Yz?=
 =?utf-8?B?cFpuL3Z3MTR0WStYeWlDUnIxNVVSa0tkeXRybEdjcHVJRUE0MEtIRXRUdFVP?=
 =?utf-8?B?aGgwMVpndHZndjRoKzB2d1NjYzhvS1FhaGxSZ29tT3cyN2RXZUwybThZRUJD?=
 =?utf-8?B?RFVmZU83OUNtY1I4QkwwQ2RXdkg5RGkrczdBeFJFeFpJdlI2aE9OcXhlY1Jr?=
 =?utf-8?B?eXhzOWwvd01YZGhGTmdObmlGQjZkb2xZREl3K2w0eVhRd1lLTEwxUk5aYVJs?=
 =?utf-8?B?NUQraVc5MWF3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cnIzbmsveFlYN3NlUUgzVWhGMWs4TnFyMEoyTDVQdXBUQlZlM2R1UTFNOVBw?=
 =?utf-8?B?L2hVNjFZVjdEUndJb21yUHIvdWZiSmt2ZjZLRlZuQlRUSVlEWGlMWXJHQ054?=
 =?utf-8?B?b29HYXRyaG5zSWg5bGVHZkMwMEZNNFRoSkRDNTBTMTBlelJtQkdPRUx5aUx2?=
 =?utf-8?B?NkJzVTk2NlIwbkRucGwvdXRBYTREdlh5K2ZuQlVLNGRQZFJVMHVoU0pxWmdP?=
 =?utf-8?B?Wm80UEdvZ1V5U01XRXBIWG9GMWxuMXRDT0ZVRlM5SzF4U0I0NUNIaDVMSGpL?=
 =?utf-8?B?ZzB3Nnk4VGNnTDZuOExxcTBJZGVLU3VoMWJHZ0dzUTJSWmlpVW96U2tldnhq?=
 =?utf-8?B?czFTb29taDh2RzhuQkcwdEc2SFZrYnd1N3BVVDcvTExRekxiWGg3dE9CdnFt?=
 =?utf-8?B?ZStrck5Bazd4TkRac1o4WjBZQmlzVGZ5WklvUWMzMVlDdUJoZWF3djFaTTFz?=
 =?utf-8?B?T05yUHYxTEUvNU9PTnFPTnRBSTI3NDVoc1BoUjRUWjBKaDk3TUFObk0vYWVO?=
 =?utf-8?B?aE14Y0p2Z1lkTGJvSlhOMGxZc005Wit1bVdMTEloZnEyYXZJY2xzYzhHS29o?=
 =?utf-8?B?MHYrYjZuZUliRE5JR21oZDdtNDc1bU1KN0pYVkhUemNYMUVQVEhyMURRdmla?=
 =?utf-8?B?RHZKZlVWTGVmd01sN0pnMVF4S0hQU1Z2Vks3NVA1YUtGMzREcVZrNnRyWWl2?=
 =?utf-8?B?MnVrbTB1ZTBLM0N1VHBqTHJzZW5RUU9JaENzUmE2K1duemdqZlRpSHJjQ1ZZ?=
 =?utf-8?B?RVA2a3crT3M3MEJrK0U2dXVsajE0R1ZkT2ZLQWdnd0xhTmtxVEphVTRMYXRZ?=
 =?utf-8?B?Qjh0dysxSTgvWkUxZEtVRmw1ODFtTkt6aTVIc2RvR1VUMnhpcFMrT29Id2NH?=
 =?utf-8?B?VTRmS2ZRY2d3eDZQQkdXMVltWlg2QWU1SEhLR2dTZzdxajRLaHJmbTdLVHVY?=
 =?utf-8?B?TVRXc1puaC8yYnR6VUtoRVZKeHE3OCtZZ2U2ZC9nT1FHOWlDVklqSEVVdytJ?=
 =?utf-8?B?OVNSdGdCWTByZG9SSHhsL3NIZ25RRmZ0SHAyTEZNUW0yd25Dc0tjN0FnazI5?=
 =?utf-8?B?SjVHYWJwdndoSzk0NU9wRXZuRWZiMHZSaitzencvK2M4ak9wclJPOGxLQkY5?=
 =?utf-8?B?VE51bE4raFBKazJ0Rm9KT2NyUWg1WUk2dWRXU21wV2dlNEFlYTMxYUc3bXAw?=
 =?utf-8?B?MDBISHBWeklUQUdnUHpLek9PV0hPeEhKRENuaW5Bd3FndGZKSDd5bjlSL002?=
 =?utf-8?B?TU1TaVJ2UWNxZ294Q1VNT00zamR6bS9KSUo5YlEwOVBOTGdWZ3ZiR1FyY0xD?=
 =?utf-8?B?YS9uYVBKV09zL1ZCZ3FUbTJQdVllblRnbkd1cmlOaGhSTEhoNU1zNG0vTHhV?=
 =?utf-8?B?aDB3bXN0QmFEdFFIMmdvUTN1ckxhREh4Q21oaDNZWkErQUlsLy9sNUp0MzNr?=
 =?utf-8?B?ZC9nUUxSdWZEZUdlUGlJQkhRd0pvLzVTNTBTK21LbHlodWF1dTRTRGYySUNP?=
 =?utf-8?B?VlNZem93L3oyYU1oRDRPampIUGUyNkxNNDBtZ2g2aUErdWM5RUhLdEdWNUtV?=
 =?utf-8?B?N05qRVlPbTA3WU9VdDREOHp0U1I0WGp2MU1VR0dtZndTVFFvYlN5TC9kVlFU?=
 =?utf-8?B?WTY0RzFibkovaU1WQ1dVa1dZZzRtcXVhS1hmTkNoa2hlb3dpOTQ4bDZycDd2?=
 =?utf-8?B?Ni9XYVNML1dPWmUrL1B2anRnM1VKYTFSMHM2c2ptbktZbndNWTFQRkVCdFdu?=
 =?utf-8?B?VmRHRVYwVklBa04xY0NQVEswTW42a2JJUlVBQnNLSTVzV3NHdnNtcm5QRG05?=
 =?utf-8?B?SldvbkxDWkpHUzN0Nk9oTkMvRHdQMlI4WStvbXc2UUlrdHBMREs1SkMxeWQ1?=
 =?utf-8?B?MUpGa3ZxbVF0Sm5oaFRhVHFMODdNOTdmVW5DMEpvUWxPQWYwcERpelRKcGVw?=
 =?utf-8?B?NGZDQ2tkWTdLWDE3V2pFL0FWVzd4TGR2RGt3cE1UOFZpQTNCSGFFYzJmZTRT?=
 =?utf-8?B?WXZzSHZwMUtvb0FjazBnenRvRXh0MzhTYi81eHI3d1RiaVpBa0JweXM4WUt1?=
 =?utf-8?B?eUhSOGxsVFFsQ1NQcmZWZklpOXhZNlgwVkhGSXByVlR6Sk5yZzhaWTN2b0Vo?=
 =?utf-8?B?NW1lV0NFd3lMeDB4T2gvWXpJUVd5MDdENno1WDRBSEY3OFRlRDhIT2E0UmNU?=
 =?utf-8?B?TkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 613cc39f-c7ee-4e97-c174-08de226acb8b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 04:12:01.2031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qpdoCNsj3lIeRih9ckqnPmKWaPEJI2U+m1lkOSKlVL9MmnbvpSTbT3XQz2xsmqzQCK1pqsXldl8XmTqtnw27nnqaRtYul52s1XkpylRUAKA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF341F90799
X-OriginatorOrg: intel.com

Hi Tony,

On 10/29/25 9:20 AM, Tony Luck wrote:
> Each CPU collects data for telemetry events that it sends to the nearest
> telemetry event aggregator either when the value of MSR_IA32_PQR_ASSOC.RMID
> changes, or when a two millisecond timer expires.
> 
> There is a guid and an MMIO region associated with each aggregator. The

Could this be:
	There is a feature type ("energy" or "perf"), guid, and MMIO region
	associated with each aggregator. This combination links to an XML ...

> combination of the guid and the size of the MMIO region link to an XML description
> of the set of telemetry events tracked by the aggregator. XML files are published
> by Intel in a GitHub repository [1].
> 
> The telemetry event aggregators maintain per-RMID per-event counts of the
> total seen for all the CPUs. There may be multiple telemetry
> event aggregators per package.
> 
> There are separate sets of aggregators for each type of event, but all

"type of event" -> "feature type, for example "perf" or "energy". All ..."

Would this be accurate:
	There are separate sets of aggregators for each feature type. Aggregators
	in a set may have different guids. All aggregators with the same feature
	type and guid are symmetric ...

> aggregators with the same guid are symmetric keeping counts for the same
> set of events for the CPUs that provide data to them.
> 
> The XML file for each aggregator provides the following information:

Would this be accurate? 

 "0) Feature type of the events ("perf" or "energy")"?

> 1) Which telemetry events are included in the group.

"included in the group" -> "tracked by the aggregator"?

> 2) The order in which the event counters appear for each RMID.
> 3) The value type of each event counter (integer or fixed-point).
> 4) The number of RMIDs supported.
> 5) Which additional aggregator status registers are included.
> 6) The total size of the MMIO region for an aggregator.
> 
> The resctrl implementation condenses the relevant information from the
> XML file into some of the fields of struct event_group.

(above implies struct event_group already exists)

How about:
"Introduce struct event_group that condenses the relevant information
from an XML file. Hereafter an "event group" refers to a group of events of
a particular feature type ("energy" or "perf") with a particular guid."

(Above also tries to give definition to "event group" mentioned in v12, please
do correct and feel free to improve)
> The INTEL_PMT_TELEMETRY driver enumerates support for telemetry events.  This
> driver provides intel_pmt_get_regions_by_feature() to list all available telemetry
> event aggregators of a given enum pmt_feature_id type. The list includes the
(at this point it should be clear what "feature type" means).
"enum pmt_feature_id type" -> "feature type"

> "guid", the base address in MMIO space for the region where the event counters
> are exposed, and the package id where the all the CPUs that report to this
> aggregator are located.
> 

The example below describes behavior of implementation in a particular scenario before introducing
the implementation self. I think the general changelog can help to explain that such a scenario is
possible and I tried to do so with the earlier sample text. If you feel that this example is
still helpful then I would propose it be placed at the end of the changelog, after general
description of implementation, with a heading that reader can use to decide whether to read or
skip what follows. Placing it in maintainer notes is also an option.
 

> A theoretical example struct pmt_feature_group returned from the INTEL_PMT_TELEMETRY
> driver for events of type FEATURE_PER_RMID_PERF_TELEM could look like this:
> 
>  +-------------------------------+
>  | count = 6                     |
>  +-------------------------------+
>  | [0] guid_1 size_1 pkg1 addr_1 |
>  +-------------------------------+
>  | [1] guid_1 size_1 pkg2 addr_2 |
>  +-------------------------------+
>  | [2] guid_2 size_2 pkg1 addr_3 |
>  +-------------------------------+
>  | [3] guid_2 size_2 pkg1 addr_4 |
>  +-------------------------------+
>  | [4] guid_2 size_2 pkg2 addr_5 |
>  +-------------------------------+
>  | [5] guid_2 size_2 pkg2 addr_6 |
>  +-------------------------------+
> 
> This provides details for "perf" aggregators with two guids. If resctrl
> has an event_group for both of these guids it will get two copies of this
> struct pmt_feature_group by calling intel_pmt_get_regions_by_feature()
> once for each. event_group::pfg will point to the copy acquired from
> each call.
> 
> On the call for guid1 it will see there is just one aggregator per package for
> guid_1. So resctrl can read event counts from the MMIO addr_1 on package 1 and
> addr_2 on package 2.
> 
> There are two aggregators listed on each package for guid_2. So resctrl must
> read counters from addr_3 and addr_4 and sum them to provide result for package" t
> 1. Similarly addr_5 and addr_6 must be read and summed for event counts on
> package 2.
> 
> resctrl will silently ignore unknown guid values.
> 
> Add a new Kconfig option CONFIG_X86_CPU_RESCTRL_INTEL_AET for the Intel specific
> parts of telemetry code. This depends on the INTEL_PMT_TELEMETRY and INTEL_TPMI
> drivers being built-in to the kernel for enumeration of telemetry features.
> 

The paragraph below seems better suited to follow right after the "The INTEL_PMT_TELEMETRY
driver enumerates support ..." paragraph.

> Call INTEL_PMT_TELEMETRY's intel_pmt_get_regions_by_feature() for each guid
> known to resctrl (using the appropriate enum pmt_feature_id argument for that
> guid) to obtain a private copy of struct pmt_feature_group that contains all

"each guid known to resctrl (using the appropriate enum pmt_feature_id argument for that
guid)" -> "each event group"?

> discovered/enumerated telemetry aggregator data for all event groups (known and
> unknown to resctrl) of that pmt_feature_id. Further processing on this structure
> will enable all supported events in resctrl.

I think the above tries to be too specific in what the code does while also trying to
explain the flow at a high level. I find the result difficult to parse. Consider something like:

	Call INTEL_PMT_TELEMETRY's intel_pmt_get_regions_by_feature() for each event group
	to obtain a private copy of that event group's aggregator data. Duplicate the aggregator
	data between event groups that have the same feature type but different guid. Further
	processing on this private copy will be unique to the event group.

	Return the aggregator data to INTEL_PMT_TELEMETRY at resctrl exit time.

  > 
> Return the struct pmt_feature_group to INTEL_PMT_TELEMETRY at resctrl exit time.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Link: https://github.com/intel/Intel-PMT # [1]
> ---
>  arch/x86/kernel/cpu/resctrl/internal.h  |   8 ++
>  arch/x86/kernel/cpu/resctrl/core.c      |   5 +
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 122 ++++++++++++++++++++++++
>  arch/x86/Kconfig                        |  13 +++
>  arch/x86/kernel/cpu/resctrl/Makefile    |   1 +
>  5 files changed, 149 insertions(+)
>  create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 14fadcff0d2b..886261a82b81 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -217,4 +217,12 @@ void __init intel_rdt_mbm_apply_quirk(void);
>  void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
>  void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
>  
> +#ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
> +bool intel_aet_get_events(void);
> +void __exit intel_aet_exit(void);
> +#else
> +static inline bool intel_aet_get_events(void) { return false; }
> +static inline void __exit intel_aet_exit(void) { }
> +#endif
> +
>  #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index af555dadf024..648f44cff52c 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -738,6 +738,9 @@ void resctrl_arch_pre_mount(void)
>  
>  	if (!atomic_try_cmpxchg(&only_once, &old, 1))
>  		return;
> +
> +	if (!intel_aet_get_events())
> +		return;
>  }
>  
>  enum {
> @@ -1095,6 +1098,8 @@ late_initcall(resctrl_arch_late_init);
>  
>  static void __exit resctrl_arch_exit(void)
>  {
> +	intel_aet_exit();
> +
>  	cpuhp_remove_state(rdt_online);
>  
>  	resctrl_exit();
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> new file mode 100644
> index 000000000000..02bbe7872fcf
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -0,0 +1,122 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Resource Director Technology(RDT)
> + * - Intel Application Energy Telemetry
> + *
> + * Copyright (C) 2025 Intel Corporation
> + *
> + * Author:
> + *    Tony Luck <tony.luck@intel.com>
> + */
> +
> +#define pr_fmt(fmt)   "resctrl: " fmt
> +
> +#include <linux/array_size.h>
> +#include <linux/cleanup.h>
> +#include <linux/cpu.h>
> +#include <linux/err.h>
> +#include <linux/init.h>
> +#include <linux/intel_pmt_features.h>
> +#include <linux/intel_vsec.h>
> +#include <linux/overflow.h>
> +#include <linux/resctrl.h>
> +#include <linux/stddef.h>
> +#include <linux/types.h>
> +
> +#include "internal.h"
> +
> +/**
> + * struct event_group - All information about a group of telemetry events.

Trying to answer my own question from v12. How about:
"Events with the same feature type ("energy" or "perf") and guid"


> + * @feature:		Argument to intel_pmt_get_regions_by_feature() to
> + *			discover if this event_group is supported.

"discover if this event_group is supported" - this does not seem accurate (and
contradicts the @pfg description)
How about just:
	"Type of events, for example FEATURE_PER_RMID_PERF_TELEM or FEATURE_PER_RMID_ENERGY_TELEM, in this group."


> + * @pfg:		Points to the aggregated telemetry space information
> + *			returned by the intel_pmt_get_regions_by_feature()
> + *			call to the INTEL_PMT_TELEMETRY driver that contains
> + *			data for all telemetry regions of a specific type.

"of a specific type" -> "of type @feature"

> + *			Valid if the system supports the event group.
> + *			NULL otherwise.
> + * @guid:		Unique number per XML description file.
> + */
> +struct event_group {
> +	/* Data fields for additional structures to manage this group. */
> +	enum pmt_feature_id		feature;
> +	struct pmt_feature_group	*pfg;
> +
> +	/* Remaining fields initialized from XML file. */
> +	u32				guid;
> +};
> +
> +/*
> + * Link: https://github.com/intel/Intel-PMT
> + * File: xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml
> + */
> +static struct event_group energy_0x26696143 = {
> +	.feature	= FEATURE_PER_RMID_ENERGY_TELEM,
> +	.guid		= 0x26696143,
> +};
> +
> +/*
> + * Link: https://github.com/intel/Intel-PMT
> + * File: xml/CWF/OOBMSM/RMID-PERF/cwf_aggregator.xml
> + */
> +static struct event_group perf_0x26557651 = {
> +	.feature	= FEATURE_PER_RMID_PERF_TELEM,
> +	.guid		= 0x26557651,
> +};
> +
> +static struct event_group *known_event_groups[] = {
> +	&energy_0x26696143,
> +	&perf_0x26557651,
> +};

Placing all event groups in same array is a great enhancement.

> +
> +#define for_each_event_group(_peg)						\
> +	for (_peg = known_event_groups;						\
> +	     _peg < &known_event_groups[ARRAY_SIZE(known_event_groups)];	\
> +	     _peg++)
> +
> +/* Stub for now */
> +static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
> +{
> +	return false;
> +}
> +
> +/*
> + * Make a request to the INTEL_PMT_TELEMETRY driver for a copy of the
> + * pmt_feature_group for each known feature. If there is one, the returned
> + * structure has an array of telemetry_region structures, each element of
> + * the array describes one telemetry aggregator.
> + * A single pmt_feature_group may include multiple different guids.
> + * Try to use every telemetry aggregator with a known guid.

Same feedback as v12.

> + */
> +bool intel_aet_get_events(void)
> +{

Reinette
