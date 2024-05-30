Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F42021BC58
	for <patches@lists.linux.dev>; Thu, 30 May 2024 20:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717100859; cv=fail; b=hr2qKeQVJHZEe3eZ/Pvmb0tRNNyFtdJ86Ffwqqd+xTkO1lX3lnC3wuV7dIakd7I5i1lk6nrcfldO2BjFY64mTdMa99z3EiSfe7b7QvvV8CO5b6FwcksUdYF6mhB+uUNS1Y6RIiZT3zKWYrLF4VnfaWTzKoPJgXy8hqzyu7uAfrw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717100859; c=relaxed/simple;
	bh=vauAuFb1gF+FAR5bnyMzAJi4VN2dTPtzRgOdpC/4JRI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cuFofIBK3k+VGBXRfugTzgBBvjlDCjufwbkRb5DOzBVkloGMZfJV+0/Bd1l7OerYa+nA+2Zaqde6vo5B4Mj6ZPvdBFyj6qdjntc3zPUHoOdxqZqWpWp6YgBXcn1oYTWKyzKpXsj1Ngsg8u8HVPy+j1RIeGedK7299UY9/vuwt6Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DNUII23v; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DNUII23v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717100858; x=1748636858;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vauAuFb1gF+FAR5bnyMzAJi4VN2dTPtzRgOdpC/4JRI=;
  b=DNUII23vyz4UMxQ7ssNyEo4z9SVKgHYwFpAvtYNRPVEVjhR6vlXuUoDx
   VMkP2N2I4m0LUnKISJVaeN+BFggdJVDY63VW0XYKMBPmleqtOKVD3H/Kv
   NMAyeb32Aar/NPfw0Psq/IzGa+KUAxPmnKu2WaThsBFvB+GevBia34+KN
   Z3dnK4xtzYbiqL/oTM0kkvXUdESR7Ilu248ALdr/AfPJhrBfrxRYZmBji
   2/merZMSWMOQ8WH/m1jP1oqurg6fjZhWnmacFJNnxuUoAcGk+LWvXZwRo
   lAXsGAM23yHOXz2BukYy0tpVSRJfokT5I/eTBDlHuGWeRtdXP3PdQdDXO
   A==;
X-CSE-ConnectionGUID: E/yFfM3RRoGCPCzku8FO/A==
X-CSE-MsgGUID: zd0WnDIIQd6F4FOFumMz9Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="13815728"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="13815728"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 13:27:37 -0700
X-CSE-ConnectionGUID: 1G1CqMvFQGGBjSvGl6Mrxw==
X-CSE-MsgGUID: CgXx1nBbTCqawZit/rETpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="40852442"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 May 2024 13:27:37 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 13:27:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 13:27:36 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 30 May 2024 13:27:36 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 30 May 2024 13:27:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XPsAorsAz8/+pinXjltfx1PU4MBuZueKKxfD3syNzGaBeQEgjlxeDKp+6GTVFGcoSFeUuiuEI0pD6qHLJ5u+6gQmNRjdxiT1UBwywD9l2VKEBGCcgGbmqrCFNa4oGU4i7hQ6CoyvIhsRYcd/HWpHllHt+bpvz+uuiwBTnf7YK582bjJZ3i/A0yyyYXG/3cj/0gh1tFb2UtNU/pnVasOAqHRdy4+WT38xkO9W4eQXLonBae6JSeCSnwtnYrBvwl2zHXKWLqDAXJaw8YM9AsN0ZZqDrLFFuy9xHCOnnxSQwk7LLRaNyGSUjjxyvvkucEa7B66N/a1pIJoiLyIL+1l8jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Srg/abVOwDG8FAMk7JNAZsf0fmQB1Dg59/XV4IB/mq0=;
 b=YNNowqCYRMM1VJgN1fhLDItOIsaNACtpbVtfhhQ2eWg4TGlkDMczB5+tTT0AUDL1HF6fSOp/D18YL1g8MFB1LJDHMAnMP28q+KjJyWiIqMFn4XnqYppJyCqjhZt659xzwqO19Rmpvw4CQpTHKqRTrujOfwYjA5f6dzJVjSntcxxy13c/K1mxbruwwO0zT1qpxAxH5GcQ0NfXXpo0PPHYWcYTvPEcDv+GncqPj/WwVstOOnHNfl35zwx1+YabD4IS6Gh3i1hAUj0C1wgTrx8HKnemI5JdAwIbRsD8dZsPxv3ktTNjyHlvsft8jqoeNn4SN+rAQE0SrQvaenYj5IHUhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB7317.namprd11.prod.outlook.com (2603:10b6:208:427::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Thu, 30 May
 2024 20:27:34 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7633.017; Thu, 30 May 2024
 20:27:34 +0000
Message-ID: <66468aa6-e0a2-4c41-99b1-741f574c5fc1@intel.com>
Date: Thu, 30 May 2024 13:27:31 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 18/20] x86/resctrl: Enable RMID shared RMID mode on
 Sub-NUMA Cluster (SNC) systems
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Maciej
 Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240528222006.58283-1-tony.luck@intel.com>
 <20240528222006.58283-19-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240528222006.58283-19-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0211.namprd04.prod.outlook.com
 (2603:10b6:303:87::6) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB7317:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d5c0946-4dd8-4e3c-4f83-08dc80e6f036
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?M3hsN3h0Q1ZhZW9oRDY0andaU3hkcHVna1IxMFJqTXBFS1grTVlCOGVlUXlY?=
 =?utf-8?B?clBmZW5pYW13Y1drZmJBaUJFRzkxbDVNTGkrMkprRDlQTlVDdTlGR1IvWUc2?=
 =?utf-8?B?UEY5djgyZi95dXVMWlRjNGExVFNJcndkOFNucUV6TVFDTHZWL2xzTGdLWVM3?=
 =?utf-8?B?MnF1Wm9nZUVqQ1hUM1Zoem93S25QY0U2UnR1U3pxT2U0NkNCeDFSVERLdTg3?=
 =?utf-8?B?akJqUGlRaGJIYTM3bFhIU0Y2UlN0WnRUSVJqY1dNdEp5aGlyUmNxeHRrdXB0?=
 =?utf-8?B?R1psR0JoR2VscVlrNkF3R2FwNmxtUXJHU1dGZnFXQlRGNXpqaEprZUtwOU4w?=
 =?utf-8?B?Q0RtL09yNlQxSCtvTTNOdGk2cGV0LzJGLzhKamZrbG9RTVJMK25YeisyNkxS?=
 =?utf-8?B?eC9MT2tWT2FWWm5EZG5TdGdHdlY2Z3dETjVjLzRteCtPWVMweGUzZ3Jma2JU?=
 =?utf-8?B?OWoxYWgvRkF0bG5FQWtUZXRqTS9ObTVROGlpV3ovdk02TW1qckZhSWdEVk45?=
 =?utf-8?B?ZXZPTWhpQ29Xd3B1eUJrQmFGTHRMNWNLS0w3NW5RbWFaeUhVTU4vekRxKzFN?=
 =?utf-8?B?d0N2dnpmRTJKTDIzZm1lNkEvMVBrUVlkbXp4a0hpT2NSSTNidG95by8ySTBp?=
 =?utf-8?B?SGdFd2tiZGVaWnBGS3pIN0lrdDArRTc4OHB5SnlUbkQ2V1pHL0xkdVZoRDRx?=
 =?utf-8?B?ZEFQcUhId1ZwL1E2MTVxb0ZaSTgveHpZMWJEbFY1cWR6bWNHS0FxeEdIRzdu?=
 =?utf-8?B?aldxOHUrV25aVFFPM1hWZGJVTjkwUFBabHlhMlVhMVFZaXpGa21JVXhYbWFD?=
 =?utf-8?B?NmxGT3ZrQ1RvdlhsblUwSUJ3VEhGcjhZRldGTXo0UHBseGNka09vSHBCN28z?=
 =?utf-8?B?N0NFcklDMnZCbEtzenBhbTM2NmExV01jc2JTa3RoK1hHcFlBUmFBc0FPcll2?=
 =?utf-8?B?b2pXTDlBRDNhNExiR0ZvRDFtc2lIUmxIWUdFRTJXTXVuUWk5RG94WDJDbDlw?=
 =?utf-8?B?aGkyUHNEUlNKWUdZTm93QmpXOXcvTUZEMjY3UitwWVY4QmYrR2Vlb3RGU0l4?=
 =?utf-8?B?MjMwenk0SEN3bGQ1b1gvU3BIeWZWZ2pyWHpPVWdQYitaRkQrcFV0RmdFMWJH?=
 =?utf-8?B?NHFPcU1Yc2RycjdrNkdFREhGZDJsTEdRTDdhMU1KYVdYMEI0SzRRZlhTYUx6?=
 =?utf-8?B?ekV1bHdWRGptMHBDWUM0MVBQbldFZEUzNlZuK2VMelhhU2VubWNQYzBVbzBu?=
 =?utf-8?B?dngxRkRPL0kzN0wzM0VLbE5OR3RFQVNiU3lsVGU2UzYvV203a0FPb2xkTWpW?=
 =?utf-8?B?K0lkcWJrd0haaTQyZzVnUmJ0WFZ3NlVhbU9meVpUVENnTW1va3Zad1dpUkI0?=
 =?utf-8?B?aHQrMkhUUlpvUmtzNmZNVTd0WVlwcE1NQWNGLzlENnRSZE1YRGMrS3lpU0FB?=
 =?utf-8?B?d29JQzlLOTNacnZGTmJCSHJYSm9TTWxrbXczTXd0RVRoNXJiMk1rQk1KbkxR?=
 =?utf-8?B?ZHdRRTBQWmN3WXpsUE05VUkwcmNGRWxBcnRadWR4NTA5VnAyZHpzSmQ1V0Rp?=
 =?utf-8?B?bzdxUVcvUVYyTkU5cnAwd0xNRXovWkhneE1TdGRnQ1M0V1BsMklEY3dENit4?=
 =?utf-8?B?ZFV3djUzaDZzRUJIMm1iRFI0bGFZTHF4dEdoSzRCUTRpQjhuZWpYUUlBYnZZ?=
 =?utf-8?B?OGIrTlRKVUlPVDVhMFRmaVZ4QXQvM2xxMlNqZTE2QW91eG9FRXVSRU5RPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N0J3UUFGM0p4R3E5QWxqdmtOeXd0YmxYVHVPSE1mM3h2UWgzWmpUN0ZTL2NG?=
 =?utf-8?B?N2M0ZTZCYjFONE52YjArOVVOWWx1TzBTM3lnZ1NPdmZad3plTmF2WU1WNUZM?=
 =?utf-8?B?TjF6anZ2MnlyaHhqOVV6M24xQm5pRHRKdXl3clluV3U3UWhoY1l4WmFaNXd5?=
 =?utf-8?B?V2pxMFJHUkRkeDJIaFFjRS9HUEJ4dDFKOFNCSVR5R1FhQlpqMk1KMFJNTXdW?=
 =?utf-8?B?TlVsdGZ2Z3pJeEFwbGRsbWtieS9uckdGa0Z0ZzA2Z245MWRXYXl6Q2x6WG5C?=
 =?utf-8?B?QWZHTHRZUjBRcWJ1RHNLNEFsUVF6Mks2UGFIU2I1STJBMXZNbkt5aVk1QzJo?=
 =?utf-8?B?RERCWDNydEw2bDdxbmZRTmhNMFFmdkhPS09zTXBSR09YdGRkbmFiMGphYzNp?=
 =?utf-8?B?Ni9rZkxDOEdtK0Njdm10NVF5VXd2NXFYZ0FTcnArNStld2VGQy9sclQrL2Zv?=
 =?utf-8?B?N0xybkp3UEV0RlZ4eFU5Y2VOcFFSL0oxbDZsMnlIWVR3dmw4WGQxcW94MlNN?=
 =?utf-8?B?cWJVeDVROUg2ODZ2cFBKcG1KTUxQS2QzYXIxMjE0RGF3UzlhbGVza29XYXdF?=
 =?utf-8?B?ZjVZQnFmTnRqRVB1dFgxbnlXS0Znb1BDeFI3ZnlWWElITE9CemRLdTR5RmVl?=
 =?utf-8?B?dUd1QzlFN3V4RDJiVFpyWEpZOUxVblZkUVJvUm1USnZ3TUgyMUFzMlR1VlhN?=
 =?utf-8?B?MXdNNUNZSU1KakliRkJ1SjNtZ0JnaU1rT0ZMZ291K0wzQ3pKdkRkdmRWd0VN?=
 =?utf-8?B?Si9pajllUkZKR21uZU1ZYWJ2ZVJLWE9VS2ZjVlp0WTJ4TmZjbHJZOUgrRW5G?=
 =?utf-8?B?T3MrZnVVa3RzRnB1cy9yUUhBaXlYc3dSY2VydkwzaUZTdXFQVFhzZmg4VEFq?=
 =?utf-8?B?NnI5ai9UUWE4OGlScFlzTm9FcXEzRWQ3eWd1MlpDU3JHZlVBZzFod0swTWdL?=
 =?utf-8?B?TnpEMmU5ODZBcWV0L0lDSFdDZWdodmEyNHZhNW8rOEhOL3Y2N1A5ajg2K25K?=
 =?utf-8?B?dU85VGNlSHBxZTlSV1R5ZnZwUnB5UTFBMUFCVEZhR1NCUnpERHF5alkxeTVV?=
 =?utf-8?B?eXEwYWNiNUwvdkhQSGFESHVwdGtHdXhKbTdjZmZ0bnlRdzZHQW9jWGZOcnpl?=
 =?utf-8?B?ck5QblF3eCtDd2wxVE11WGNja1lzWUJYZlpKc2Y3eDYrY1RQZnhkVjhUdmUz?=
 =?utf-8?B?ekxmNDdBUmhhZW1Rd1VjVzU0YVFqSy84L3FTa1hxVzM0NlpjWjJxUHl2TGVJ?=
 =?utf-8?B?bnpocEx4Q0YvN0FJbFFTNmRxeGZwZzF1c2NqS0NrbSt2K3o1RkhHV1BDUjJL?=
 =?utf-8?B?UXpPYVljSzgwZkdRaXJPSlBBS0tTODFlNTBocU1KM0FlUWgrR1VkcWo2cnVu?=
 =?utf-8?B?SjdGWjViZk1PcTZMRFFyZzNVa1BrSm5QSnNycndPK0t3WTF0SE42WG1CZmx5?=
 =?utf-8?B?SHBZL2tkemp0WGZDNEowbXY2QmRmSnI5Qmowei9aSWlFbWM1YXUxTXpmRjU0?=
 =?utf-8?B?R0tBRVkvN2UzdDNHVEU3SDh0OUo0c3dYbjJjSHo5U3JwTHJsWWFLQnVtRjQv?=
 =?utf-8?B?L2xGS0x2Um50QUkrQlJxTkdYWGZ5ZUlVamUvVTBCMFlWc3ZjUGx4cDlFQXlK?=
 =?utf-8?B?c0EvZHBKbEFOcEtySzJTM2l1Ti82NW1ZVDZTU3hLQzBKc2FqL2ZPZU5OUllZ?=
 =?utf-8?B?dVlzQnB3NDFDVG9Dc29sdWd6QkRaRDdybGhZeFlsZzA4VTAvcmdsT3pBVFFl?=
 =?utf-8?B?amcyVldEQ29XSlpNeFA5UXppZ0hySWpaK3FNQzVpUTRtRmpzRXRXY1RvRkI1?=
 =?utf-8?B?WGVienVFS2V6b1hPRlFlcHl2aXBrNytXNmNiU0tDc24ycDg5cXp4WHo2Q2RS?=
 =?utf-8?B?Q0VpMDcxN3FVRVlINHZLSVNRb0VDMGtSSlA5ZU5RZTVmSy9vUEh3ME45RFVE?=
 =?utf-8?B?MSthWmxoR2hvT2N6dVpDbDNoTWpITVg2ci8zWXIxQ205U1VhQVNGUzkzY0Fn?=
 =?utf-8?B?UzJpOHk0MmUrMXJmRldqNGxTUDhxQk9CSTlmZHlFVTgwZHJnckYydFhJUWU0?=
 =?utf-8?B?V0d3a0FYZTFyRDZlQXFadWhaSlFIVE93VlVTcHNySUJRZWk5SmFtaGM0Wmxp?=
 =?utf-8?B?S2FSdy9GVUsraktaL1JPV1g3Qkc5V0JubUhjMEtYRWJJRHcybHd4ZEZTTXI5?=
 =?utf-8?B?NEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d5c0946-4dd8-4e3c-4f83-08dc80e6f036
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 20:27:34.1808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SADCpj9dp8HjMWR515OnKLwFZh4w4KS10wocqmoPIc+R7wrdQN0vToSZAatfQlE88xVXIpk9HKE1aewkc4n5HBln/ZvVEk7YrdEzuaL4+EU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7317
X-OriginatorOrg: intel.com

Hi Tony,

On 5/28/24 3:20 PM, Tony Luck wrote:
> There is an MSR which configures how RMIDs are distributed across SNC
> nodes. When SNC is enabled bit 0 of this MSR must be cleared.

Missing explanation why bit 0 of this MSR must be cleared.

> 
> Add an architecture specific hook into domain_add_cpu_mon() to call
> a function to set the MSR.

Can this explain more than what the code already tells us?

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   arch/x86/include/asm/msr-index.h       |  1 +
>   arch/x86/kernel/cpu/resctrl/internal.h |  2 ++
>   arch/x86/kernel/cpu/resctrl/core.c     |  2 ++
>   arch/x86/kernel/cpu/resctrl/monitor.c  | 26 ++++++++++++++++++++++++++
>   4 files changed, 31 insertions(+)
> 
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index e022e6eb766c..3cb8dd6311c3 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -1164,6 +1164,7 @@
>   #define MSR_IA32_QM_CTR			0xc8e
>   #define MSR_IA32_PQR_ASSOC		0xc8f
>   #define MSR_IA32_L3_CBM_BASE		0xc90
> +#define MSR_RMID_SNC_CONFIG		0xca0
>   #define MSR_IA32_L2_CBM_BASE		0xd10
>   #define MSR_IA32_MBA_THRTL_BASE		0xd50
>   
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 7957fc38b71c..08520321f5d0 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -532,6 +532,8 @@ static inline bool resctrl_arch_get_cdp_enabled(enum resctrl_res_level l)
>   
>   int resctrl_arch_set_cdp_enabled(enum resctrl_res_level l, bool enable);
>   
> +void arch_mon_domain_online(struct rdt_resource *r, struct rdt_mon_domain *d);

I expect that this function will be called from the already
architecture specific code so needing an architecture specific hook as the changelog
mentions does not seem appropriate.

Reinette
