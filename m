Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770DB13212F
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 23:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719358205; cv=fail; b=WgC2bE88+9IFUOhYYrtxA/FYiz4N9FXbv62vJnDkckvm8/ztAJu7UlDqEYY8u02HtKf7NleqiMgv+FSIzQ/L6vtOoeNlOEpcrT5GNRRZPymKJqEJIS87XbOhOuO9D8NLEsqmSzyE7Wa8jf1ypR7ZtfWAFvjED38AeGc9kAbhoBU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719358205; c=relaxed/simple;
	bh=KO94vITOB2AyOCJzQO5S8E3Wtd8HpbJMYzAju0QSp4o=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I0ViPQxd+9MRBQIeNM8LaAXoUFLnbfMXICLMa+ncydx7lI+Xae8PhIOAX/wOS05qt/7nFxJpiX05YnwCRwHIsxBmA2GdAcOi5RPagULpQWHcOjht9I1buyqFvOU99P1c9pOhMd6oONe9acYahVd/YLaKRgQZ6PekzLU7eiOSQAc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yv/vwJJC; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yv/vwJJC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719358202; x=1750894202;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KO94vITOB2AyOCJzQO5S8E3Wtd8HpbJMYzAju0QSp4o=;
  b=Yv/vwJJC4Q4CJh3TfPsRaoKiYnQLrmZUYRwZazEbf+MT/CAfUYlXUuOr
   BdKASUvLmh18V/DY3j0edLNYIJpn/egmbY1RvNouLqT2liSA0Dj/DuEcr
   L8CM0ZblScaxfgCrXnty72wKFMNIu0c1tf9vqeTcEcFZ7pXGsgDnTBq5K
   SWfWTJ09Xr7X9kylwZ42mHS8kzz8nKKl1Tsww31K8nEpSv1QTrVNl1sBp
   q1PMT5/86OGUpJxjz8wkqT99E1SfbDj6Yvg1uE3ks/bXRSBX3qlvyQzmF
   TwMT4MV7/mnpoxL6eAQNYZ/GLO0OjBwF+zqmrD8hkH7OGP0Q+/HRmizSb
   Q==;
X-CSE-ConnectionGUID: 1LRJIecOQ46aotIlcSOvLQ==
X-CSE-MsgGUID: k0sECh1ZRSGYo19cm5Tjfg==
X-IronPort-AV: E=McAfee;i="6700,10204,11114"; a="16551574"
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="16551574"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 16:30:02 -0700
X-CSE-ConnectionGUID: yIXvPUgMTYK08ioWicS28w==
X-CSE-MsgGUID: leDvu94FR5KPXk4x7lDN8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="43918077"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jun 2024 16:30:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 25 Jun 2024 16:30:02 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 25 Jun 2024 16:30:02 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 25 Jun 2024 16:30:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=leoE28ZIUwb8aNoSvvbKu0NsDR/Sm270Txdc3r275mJkp9oemJ8YgymTGQINVPXMK4ADGbZ5eAf2KF9dUDrLiFo25cRfVRMqUikE2Xu/yxMpgXul6dDaIMTKEejWk8ZybwQgbZ5A4RmIQgI+Slyc67SZ+LAG3reLChg0gVFy+Tc4mQvPgsCNJYWgcU5RlqD3soinZXvdfS8F1vyAvw7nfR2bFB/X38H4PhiFRLq0ylOHxCMR6LEovWTp8ne3Oj1y1uQSe/cLExYrjd72qwBLOvzjmiOfIwqsiuRNJxdQb2CNrL9czqmicr02vxARNwD246w6NACUATJ40tWdSOxdRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7+8RYPh0PvixDihQNjssCrjpyCQDy7sqpGLPI2TilWs=;
 b=oOWq1JaMmHCpZjBw/KA9zg+d6eceFQQHsi90eFT5HmjM3dVDjCUrX+RqeR1UZ0ZSqu8apdGbE0QkukZJDm9SI7YzmollYzXJ1CSoN0wF+/EQ0AhtHGGvkoR70Ltus+1NalOuav4jlBsv1gcVj3DCprJIc2VfDbUd941xYln6Tz6n4Npr6XjdDb30dVVv6xT7pST79t/SVz+3ru5/9l7uaH07tFP3gOREdgInhQsZWLlowaNn5JP5jzkBbsR6XaVvzugbq1adDLZgeZT53AJylXh6EgSWu5e+XRtJPvt0C6akFF4b0t/OYE4UQ92oLKoxVZ0eon73nRBn6lbbM/PfEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY8PR11MB7170.namprd11.prod.outlook.com (2603:10b6:930:91::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.30; Tue, 25 Jun
 2024 23:30:00 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 23:30:00 +0000
Message-ID: <d7ee790e-07e2-48f7-af7a-194760ce9b79@intel.com>
Date: Tue, 25 Jun 2024 16:29:57 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 11/18] x86/resctrl: Allocate a new field in union
 mon_data_bits
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	"Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240621223859.43471-1-tony.luck@intel.com>
 <20240621223859.43471-12-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240621223859.43471-12-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0033.namprd03.prod.outlook.com
 (2603:10b6:303:8e::8) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY8PR11MB7170:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e25c3d6-8ff7-4e8f-761c-08dc956ebb4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230038|366014|376012|1800799022;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OExPTzRiNmNLQUtUT3FPRVEvWXcwbUN3eSt5RG5lR0ZqOGk0K0pKdjFRTmNN?=
 =?utf-8?B?SEFDODJpMDExZG1kY0IwMkxMdVYwT3JQZTZ2OTh5dTBlMFljMUw0QjRYbDg3?=
 =?utf-8?B?S0Q3TUMyODlkNy90QzFYNWdGK05JemQwMnRKNlJuZExLOEg5cHNHN3BHeE9s?=
 =?utf-8?B?cUdkREN1aGtuTXlvZ0E2ZTZwUi9FTko2WGJHR21oeTVKM2l0QzFnTW1uRTQx?=
 =?utf-8?B?QU44Z2NkVDdTMWVYdlNvYnBvazhFYUt6ckRWanpmRkxVVTlwS0xFdVY4N2xj?=
 =?utf-8?B?V0NKNG9uMElNd3JLVTFwejhXaUFuQ2RDUmhtclNya3d6SElMRnp1SkpwblBO?=
 =?utf-8?B?WnhvcnZtZ1RRL0dXdlZHb083RlIrR2V6L0hHYXJFd05hS3NuZTRZN1dpdVZN?=
 =?utf-8?B?QWYvUjRXbTZPOFVYS0dMaXRyR2JKNkJRYzRuZ0Vpc3Q0WnJYQXRiejBlUmdL?=
 =?utf-8?B?dE54Y1NDd2JZOGswM2FIZ0pvbFphRDB4eS83UWEwN1pOeDhReHlLby8wUEIw?=
 =?utf-8?B?SjBOOUpMTkpkZmEwSythSDE1ZnBSOUNJTzd5NmZNbWVRZnkxUlB6c3IxWGhV?=
 =?utf-8?B?TUdDZ083RmdRbm1WcHVGZ2NXbHh6RmNxNU0rcE9pamt6VkQrVXlRc2RWWDA2?=
 =?utf-8?B?YUtGeWNlWUE1TVBOcGZONktKVzlFSnM5bTRtbmo5b0NMVWRMcjNYa1NsQmhU?=
 =?utf-8?B?dVMwa01LTHJxSUQ3VzNvQXMwdWJzamJLcENiZlY0NTc5MEkxci9jVnZJTERE?=
 =?utf-8?B?SUpNMlMxOHNEZjhid0p5LzQ2Sm5EKzJEV2lrWHdzRnBPVUdUL2FWd0RuTFdq?=
 =?utf-8?B?blBHbmNJNmMxMlp1emFZRDNhVUl5dVJGSUg0aFE0SHArcDV2c1EveVVtTU83?=
 =?utf-8?B?VjU5VjBBbzFkVHdzQkJyeW9BSHE5akIrUDB0NTRORksweFBmTGVwaXpCRXla?=
 =?utf-8?B?UkdNODU4ajNjeGpSUUhJdnhqQzVpdzg0bUdaUDFDMjd4NVduNFJLdHZUNkJx?=
 =?utf-8?B?WFpzdmlkRmdZcko2ek5KOHdUVHYrR0ZhNGdkUUFNaWpjM1hycU9yRkVTdGx2?=
 =?utf-8?B?STlEc0lJWjh2U01XaGFzKzNYMnF1ZkVndHdmRXd3SHVUR3BZb3J4L1o3UWho?=
 =?utf-8?B?Z0h0SFhSV3NCRlMzaVJaRFFLQm1pcnFTYmpFbkN2OVUyaVlSeVBYMTVodkpO?=
 =?utf-8?B?djJIdWxDTUtVT3pKMGUrUFJuRXJadUtIKzV5WmtFSU5pNlJHbVVkNSttZHdZ?=
 =?utf-8?B?bW9iUXNZYUtDZy9LSFIxSzNtdmpCZHlpRGFxTUhzZ1I0TzMxajVGVHdJOFZE?=
 =?utf-8?B?UWo4a0dsRlVsR2laVlF2ZXB2MUI0ckhtWnlKY2hSSExad2V1ZU5jdWhuUWlj?=
 =?utf-8?B?RU5xcUhlRFpyVXYybTg1Ry9TV1RlU0JTa3hXKy9sK21wdEEvblg1dVE5clpn?=
 =?utf-8?B?eFhvcWcwcDdZUDVFL0ljcks1Z2dRZFZOblA5NXVCZlNxQ205RVlGTEVFeGxv?=
 =?utf-8?B?UFdxTS8zUWxjdEovbUxDTStmUExteHo5emx3eXBrOHJYUlYrT3B1N09uOTFH?=
 =?utf-8?B?bHFJRTByenZFZlAxVDllQWZvMVZWK2FZYk9DMHJ2MXNOdzhWRjlSY2N6L2dT?=
 =?utf-8?B?WjI4dEllQkpBMGNqUHVJYi9qZjJDRTJzSHpvbzYyNHBDWVJKLzhndHpFc1Nl?=
 =?utf-8?B?a2NyWE9hY2Jaemdad3VJQW8rT1hyekZLUHZoUEFab3BEdUxlMGppZklKa1VD?=
 =?utf-8?B?M0N0MDc4VnFJdlJIbXY5TG1UMWYyMFM0MU15RW82USt3Z3B1K1BMZGVadlBP?=
 =?utf-8?B?OGUvdHhyb0sxdTM0c0J5Zz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230038)(366014)(376012)(1800799022);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RGtrRVJrUkpFbE9LUW1jZ2xKUHdBQmJVNEZsMlZucE9uMmFVd08vcWdTNVd3?=
 =?utf-8?B?NzJKQ1RKQlplcVlqdGphVDRZWU51M1p0bGluWXJ1Q3J5VitndXdUM2F0OXpk?=
 =?utf-8?B?dHBYWTJRUVhtZmJrKzlNdUl2Y04zbjVBc3QyMFJXOEtXZm13U0ZzWU8wWHZ6?=
 =?utf-8?B?OFJFQjFqYWp1YXlSNW9tWlRBM2NZYmxPRGk5VWQxZWFxQ1BXaU5sZ0dHaHFZ?=
 =?utf-8?B?d3hCbzN4cGZaT1hJWThwOTV0QmRHRHB6ZXZlUVhXVEV6YUdUTjRLV0NYNzBJ?=
 =?utf-8?B?L0FMVHdwY2dZMGlRR3FPYXhFVlpiSGtzamNJSGNuWWhkZGZDMGZ3VlZPd0Yx?=
 =?utf-8?B?NzVJSkQwY2lMZXFnS1hDODRRcENaaHQyYWZBbStBV3Y1UkFaVlBhS0hKUEZQ?=
 =?utf-8?B?MGQ4N2tKZmNubFNDSks1SEJJZmp4MFRZUkpvODRNYk1DMTkxa2dYRnpXMW05?=
 =?utf-8?B?NGF2bXpCeWhXSEdtV1h6VUlhcWwxTDRuWGFUdC9hbFYxejFvU2lzMVBWWkEy?=
 =?utf-8?B?NDBPNE1IdC9RdmV0SEFTQ1V5dWtteEVWRHpmWUx0d3ZOUmVsRmhydCt3WlZT?=
 =?utf-8?B?TklsNGd5QVJsbjF4RVlDSUxFYnV2ZkdLTWUzTGx6ckkvRjJOOVVyVFRqQ0xE?=
 =?utf-8?B?VDJtS094SmY1M1djZkk5VFhpRnJDN0J4eG1xcVBrZzVlZHdxQTVETkhsSW9V?=
 =?utf-8?B?OC9UMDFjWDRTV2dLcG5wUVBieTFPR1ZrWXAwZDJiY25hMVlHT2FlUXpWaWNI?=
 =?utf-8?B?eUNMYVM0MVFBeURFY3V1QzNGdmsveUdSNzRHR0hFNU45SGo2dHVWRVNvcFBJ?=
 =?utf-8?B?eDVaMGkzeXpCU0sxckhNSmdWRUlLaEVDRG9jWDNsd2dFbXNrVFpQM09IVWtK?=
 =?utf-8?B?QnY1Qkh2bjhMSjVYZkhpblhwMnFMM0dJQlFWd3Y0bFBqM3Q2amgvUXh3ZjA4?=
 =?utf-8?B?L1VzTjJYMzAwcGVPbm1uOHNVaDArR1ZpalpEcG9TNUljS2xqWVNHY1pzNUhr?=
 =?utf-8?B?L1lOM2RrazdaUWxsbUl5YXg0WlZPL2xSeXhEck5Ocm9sM25Qd21BZi9kZWdY?=
 =?utf-8?B?TmpMUGYxQ1lrOVlZbTNOWENEc3FXT20yaGxRNnllcWdqcE5wVldyTTF5eDJj?=
 =?utf-8?B?WlR1MmlIU1FTeGVwcVFSRVZZb0MzbFlRTjVKK1JzQjJpdlFsdXlVSGdVbVl4?=
 =?utf-8?B?MEQ3dnU5cW5FMmpUZVBkSnEzWmJnL2d0Vjc0Z1RNazZhcTlhLzl6T2RmZlUw?=
 =?utf-8?B?VGpLdWxraXB3R3J2dlYyb1E3RXI5N3dUQnNmV2ZJNWVXcklicGEyQXNRbkZn?=
 =?utf-8?B?RzdPNkdFcTdrczZjbi9KQ3dlMy9yY04wUTZFWHNEU2tONDhYNmVJeXB5WTlx?=
 =?utf-8?B?a2NyL3VGUmY4VGFrL2pVaVpyeENDZ0hGL2c0MnhuMkVYSjdJQWZ4VmdZMmlV?=
 =?utf-8?B?eUZDQVdRSHNzdnNQMFBqRmJ4Z084QVZFMmp5cTdHSkJXT0tyeVZONmVPQzBR?=
 =?utf-8?B?VnoySFJvWFNrbWlnOGpWQ3pBQlQraS9UZ3NFSVNUOFEvL2V5aDVLa21NaXh1?=
 =?utf-8?B?QjQ5RTIwbERSZUxMUTJEK2Q0Y2hudXBrbU1yWWVuNUc4YlN2bUZWOHR0VG5Q?=
 =?utf-8?B?Uk15eGt3QU5DU29BbjNWbFZaNDFQcG1EdUFQNlMxMHluSHJVam5wbUU4QnIv?=
 =?utf-8?B?STJnWWFRRGxDN0tsaUtpSi9LTHorWU40SEZRTi9EVTdpMUdPei9YMUlMUVRx?=
 =?utf-8?B?YXlZa1AxRXBlSVdOUkxoUXAySWhFNGJDWTVLWG1FaVI4ckM0ajJmdGRxL2hy?=
 =?utf-8?B?Y1RlUU5LTGkwem1SM0gwV25kbVMvcHZ6MEpQU3lLcVNBbFZIYTBFNlM3TXkw?=
 =?utf-8?B?VWdWdlMrVXA4YUlDMmJDTHRtZ0ltUlJOblpOSFNOam1kODl6b0NWL21xVytv?=
 =?utf-8?B?YVQwNm9iR1d4NFBCWGhudXJvUlZPR3h5U1o2REpkQVhmV3FTZ1FzRTZTbnBl?=
 =?utf-8?B?TEhUeTk3RVVRTEh4akV1aHBuTEpCOWJielY5V1JYcTFMLzlRbzA5T2kyL2pv?=
 =?utf-8?B?V2JVbHkzTm92dFNNR2RndmF0MTRncW5pOXNGb3JlOVJPMG5rMjBiZXBFZ0o2?=
 =?utf-8?B?MmF1L3hiTDBpbnhiMHhvaFpRNGNQa3dzbEo2aHVUNVN1RmZRK2NHcU5EMEVH?=
 =?utf-8?B?MkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e25c3d6-8ff7-4e8f-761c-08dc956ebb4e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 23:30:00.2456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SmrCcdLxgFDPOhm1vRf8aG5YGBwN1gplb/Rb4oz62NXGbOiOA6lrPv2OKcr6YFIos41GnM67u/wU8wWawISf2Gl4JznUMBlKv/iIm9E5gXc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7170
X-OriginatorOrg: intel.com

Hi Tony,

On 6/21/24 3:38 PM, Tony Luck wrote:
> When Sub-NUMA Cluster (SNC) mode is enabled the legacy monitor reporting
> files must report the sum of the data from all of the SNC nodes that
> share the L3 cache that is referenced by the monitor file.
> 
> Resctrl squeezes all the attributes of these files into 32-bits so they
> can be stored in the "priv" field of struct kernfs_node.
> 
> Currently only three monitor events are defined by enum resctrl_event_id
> so reducing it from 8-bits to 7-bits still provides more than enough
> space to represent all the known event types. But note that this choice
> was arbitrary. The "rid" field is also far wider than needed for the
> current number of resource id types.  This structure is purely internal
> to resctrl, no ABI issues with modifying it. Subsequent changes may
> rearrange the allocation of bits between each of the fields as needed.
> 
> Give the bit to a new "sum" field that indicates that reading this file
> must sum across SNC nodes. This bit also indicates that the domid field
> is the id of an L3 cache (instead of a domain id) to find which domains
> must be summed.
> 
> Fix up other issues in the kerneldoc description for mon_data_bits.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>   arch/x86/kernel/cpu/resctrl/internal.h | 20 +++++++++++++-------
>   1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index d04018b8b571..f66c7f12e91e 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -127,19 +127,25 @@ struct mon_evt {
>   };
>   
>   /**
> - * union mon_data_bits - Monitoring details for each event file
> + * union mon_data_bits - Monitoring details for each event file.
>    * @priv:              Used to store monitoring event data in @u
> - *                     as kernfs private data
> - * @rid:               Resource id associated with the event file
> - * @evtid:             Event id associated with the event file
> - * @domid:             The domain to which the event file belongs
> - * @u:                 Name of the bit fields struct
> + *                     as kernfs private data.
> + * @u.rid:             Resource id associated with the event file.
> + * @u.evtid:           Event id associated with the event file.
> + * @u.sum:             Set when event must be summed across multiple
> + *                     domains.
> + * @u.domid:           When @u.sum is zero this is the domain to which
> + *                     the event file belongs. When @sum is one this
> + *                     is the id of the L3 cache that all domains to be
> + *                     summed share.
> + * @u:                 Name of the bit fields struct.

Thank you for including a fix to the kerneldoc.

Reinette
