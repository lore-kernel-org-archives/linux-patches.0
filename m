Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B872428F92E
	for <patches@lists.linux.dev>; Mon, 11 Aug 2025 23:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754956729; cv=fail; b=i9QQuSgGRD6S5gAyMTE6fAvSfW27q6QP0cpaBCBLpipbmSBKBHfWU4Bts8XK33w7U0vg/dcawRt35zAVj6R5KNnKuplrWXbPnk4al1oQ9OFzdEBZYjp1axDUDLzrJs7hv8K0BPmu+sV4yFgAq5kiSRvwA7ELqwwga3kEcS+wl8o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754956729; c=relaxed/simple;
	bh=Ds3HKsq57U7TkzIroDO1eLhTbHZUUGhc49jgMt07Eok=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JIxvN58LUc/vNflYo7ERjWrbjHhNBT9ohOuOz1G8InonmNaJ0J2mTWB4WMTPqAOhHCs7N3NT/pLS9GllEXHkmUDHWEdiQs7KUNFqv32U4vnigWXJzE6FyxUWJMdZaML2XGDxAyv4sGgTPAcIUz3M5GzvyNMgN0n96uPknrWZQ5I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MbyKpJDX; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MbyKpJDX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754956727; x=1786492727;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ds3HKsq57U7TkzIroDO1eLhTbHZUUGhc49jgMt07Eok=;
  b=MbyKpJDXaW0bIzpzeb1Erg9mqZJ9pK/fbhJCHgQ/FGtmIWSdjsLZMwYu
   dtJz3TCVX94Ce3RVZrN19kqAYXiIUBwlzd1Pr2fArztVS0ODJCsqP/GAX
   VnQX0HsaXuUPY+ikgBnoH/U3hOO7pGDrli/qzBvjdAMQPR1ZBSWbin8E2
   EBQfB/rYgn5dylCNtQLgkOnQwDIkgt1e5vfjiWmCn5pM6QROA2zVM+o3T
   VFQ1Nrv4x4+UQE5AlPd1aCrGEWx8wv7VmHwbp/hrdsDK/g4DDIeQfstW7
   SB9ZGLB/9Xkfxjp9VKLwYR1nrLjeU+eS8A5qTPKX9qgN395gdmLsj8LX5
   A==;
X-CSE-ConnectionGUID: 9Z2iRp+gSV67+dNlqg2Xng==
X-CSE-MsgGUID: sBGolSHXQjKvybYNiOleag==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="44804107"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="44804107"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 16:58:42 -0700
X-CSE-ConnectionGUID: Z/FsBPy0R4G96H3V7lB5RA==
X-CSE-MsgGUID: VFy6AfAQR0uIA+tvNunQVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="171395978"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 16:58:42 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 16:58:41 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 11 Aug 2025 16:58:41 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.43)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 16:58:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CiG0VCf+7NkQxBJqSK40rEU52YIHddTdSYQccWS6lwraF7nbTL9zowTfzHhXa7bgBRwPuO1vtGRzSHB77paMa5tZzU4twjyvSeZ6puJ3Mtq5RDLP1joTfea0qrocHGHPwzy9Y0YDCr+XFg9Afj9JTWt/bkKjTYz4DdFICeQ5X+HH6YQ7G5M4rN3t3vCIhfzgzhX4+X5X+r9RhtZlVAXczgOjiTHhJUqA8yfsvYsRu6t2kj7U/NNsQ0c+/EdJxlIItM/porKSNFSzRwPdILjNFQSI4xpKEuBnZXRz80CmqhmmQF4MQ/1e/TyXpNqC7gfDtsh06gk9ijE5PVrPdFhR2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UQCEw7NeIcQoXYord4MEEM/izeylQjACGtAmVTST9Ow=;
 b=FWX0S7e7LdA7l/35VcUZ57Oh8lVWvWAY5oWMDZ1Ocqdq3W289D+sY+AQOs+GhMg+XA6T19KqMrDJ7SRaDsgTeG/mJFUJpn2DICGUcNUx+4IaTjuxhAvD7QQ1rKByrPPR/VUNlAjpzQD+ai0f59xgHZcuGvcokInP44r9qBpUz3m5u/CHTJc3G1O0cgkUhqDw3zqYR77qikpNxBNzLCjDvOsauU8gi1dOJjNPstU7m9mK8scoeqA0/15Q+j4GLxW+0Mote8IXyu+A8egSRMadtaQxs8tcdyT8CBokuh/LKQ7fgGALEHRgs7utRe3pC242pa5rTkC/LJ5WvDmpOer6gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7997.namprd11.prod.outlook.com (2603:10b6:8:125::14)
 by DS0PR11MB7457.namprd11.prod.outlook.com (2603:10b6:8:140::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 23:58:38 +0000
Received: from DS0PR11MB7997.namprd11.prod.outlook.com
 ([fe80::9105:2b7c:b256:7a6c]) by DS0PR11MB7997.namprd11.prod.outlook.com
 ([fe80::9105:2b7c:b256:7a6c%6]) with mapi id 15.20.9009.021; Mon, 11 Aug 2025
 23:58:38 +0000
Message-ID: <956ba4ef-1ebb-4466-a584-5b06076bcf81@intel.com>
Date: Mon, 11 Aug 2025 16:58:36 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/cpu: Rename and move CPU model entry for Diamond
 Rapids
Content-Language: en-US
To: Tony Luck <tony.luck@intel.com>, <x86@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250811213345.7029-1-tony.luck@intel.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <20250811213345.7029-1-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0049.namprd05.prod.outlook.com
 (2603:10b6:a03:74::26) To DS0PR11MB7997.namprd11.prod.outlook.com
 (2603:10b6:8:125::14)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7997:EE_|DS0PR11MB7457:EE_
X-MS-Office365-Filtering-Correlation-Id: 53cfb7b3-fb55-4f69-84ff-08ddd932fdbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TnBmUVZweUtXK0h4R0Q0VElYOUx1ckV0ZnVCQi9FQU5kQ0FHZmhId3p3c2U0?=
 =?utf-8?B?OFVYSTBlZTBEQnluRkF1YjJUSC9nNXVaQXp4UDV1MlBQU2RYUldIa2hvWkZL?=
 =?utf-8?B?ZkRLR1p1Sm4rbFA2YzJwcnlNTXplN2c3RlR4NGhXVzVBdnZrTmhGYW9QV1Yy?=
 =?utf-8?B?L2loSXNHNGt6c3dwMnBVV2FnL05lMC9WRm5ud0ZxclBDSGtaYUlXZ1Vzb3Ev?=
 =?utf-8?B?bDlyeXo2dHduWGRpTmVVeVI4M0dPT3BSMmoyK0xKWnlGMkxIY3pqbnBwQzVa?=
 =?utf-8?B?b1dBRkR2OXlFUS9CcFJQNGRZQU1HbmlmMkg2UHFJbnZtbnJLdVpKL2paL0s4?=
 =?utf-8?B?L2ZXSzBTK1ZRZDFvTitSTFZnRElnZ0tGSlVIUWo1M0hEaWJSWlE0RFVnbTI4?=
 =?utf-8?B?NnQrSmxaQm00UldFZVdOQWFUNDN0Nkt0N2ZCTk9zZkFDWURaWmtzTStyUk94?=
 =?utf-8?B?WEwzTDY2Y213N0phSFlkNDJtbHVtdXh0ejduU2x1NEFYRTFCb0gwWDl6Nk9x?=
 =?utf-8?B?Uis2UFg5V2xTdXhVc0lLWitXQWV5bUdtUTVmYmIxWEw4aVRTMzFvTmEzN085?=
 =?utf-8?B?MGNUSnJLMUsvdHg5bnBYYTBTWHdYYjdhTlFNTE9udkJQOGVHR2RacFg2aUt5?=
 =?utf-8?B?S1AzRndWSE5ReFdTTklaTjVpR1RWa3pPMmN6WTkvakJmbXUzOUhyVi9zTVA3?=
 =?utf-8?B?NFBUZ0V6VWVKWFlFVXhadFFSVWlMUTZReWtkQjFIMzVFU0h4QzZObklGRnBx?=
 =?utf-8?B?MzRGajBMU3ZHSGU1UWJid0NwRlAxbExqcDFFazRXQWNqczRCNzZRcHBwdFEx?=
 =?utf-8?B?Q0l4cWJERWZ0ZHEwc0hXN2JFejNBQnRnRFFHcHF2a0lhN3dGa0VQYUpqRW1p?=
 =?utf-8?B?RGtBdW5mQldLNlQzMXlCdXBoM0M1MXNMMmtLYitqbW9pR1ROc0RLSnJha2dX?=
 =?utf-8?B?SkN4SFhhL0dUKzEzQ2U1TE1PeHZ1d201TVovWHJBcUxNclZPYzFiWSt2LzE2?=
 =?utf-8?B?Y3IyL3RPREtlR2FoTmU2ZHFvNVZLZ2RvUzd4aVljbTRVU25SYzV0SW4xck1y?=
 =?utf-8?B?RElaOEp4NGFMZ3ZHTHRENHpFZDYxYXNkSlhRRFZiQjV3Rm9EeElWS2FIbnNx?=
 =?utf-8?B?dDhpQWlMN3VsZGhkUSthM3ErSHVlb1YyRSsreTNOQXc2QWUrWHhFTWkrbEVD?=
 =?utf-8?B?OWRkMGxmaUFaVHF2SG9TTHFQdlZyS0N0WHVxbHpRNHpKWEJzV1ZPWUlodHBF?=
 =?utf-8?B?U1Y1RzVZV1hJV2IyWU1TZWZxOWo2TUs1ZW14dm51SFZNWVNuRmpXR2Ivdkta?=
 =?utf-8?B?QWZUMG5qNTZsbHp0MnVyaTV6UW13Y2NlUmNyU25Dc2E3Kyt4S0hQa2FlWE5m?=
 =?utf-8?B?NS9WbElWWXZiQ2pHdWc0clFmSVhIMW5ReStjRW0rRHE2Y1FUb3BWYXhwN0Z0?=
 =?utf-8?B?RjR5Mkhhc042RzQzK1llTkUvR0ZqOGFKaDhjV1cxUXdOWnZSRTA5VHdXRmMv?=
 =?utf-8?B?aHBhSU0rVmF4R3o1RytNY1FveURLS3VxRkJQbDAwSWhFbGllY0V1TTRPdkRJ?=
 =?utf-8?B?TnBtZjBFM09raGxVdFVlM0Nmd3VxRmdrbFZsaXlXbnA3OFNKMmRRQVY1YU5Z?=
 =?utf-8?B?ZnVlMzZvZSswK3NYUlJmem91MnNuRWF3bUUrb3UwTEJuWGRlSWxYanNMS2tW?=
 =?utf-8?B?UzVKQnVTUzkzMFh0V1I2RmlsTG45U0pwZmhpTEczbzVvd25IL3RYcng1eGJL?=
 =?utf-8?B?V2JuR3ZHeHg1dStBZk5SVmJrQ2VqR0ZueHJSTHVKcU9NUGFmQnNxZklqMnhi?=
 =?utf-8?B?YzJERWg4VDAvZWJvZDk5c2g5MnU4M2NNL3F5dnZvajBXdTFpL2ZYUFpUZjBC?=
 =?utf-8?B?SlAzMnVHUlRjN2V4dk1NRGJ3SUo3RFBhNUtNM1dqdG1QS1VMd2FJcVR6VXha?=
 =?utf-8?Q?2/ARuVGr3oE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7997.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OGNPNk5hZmo4dlJlcVVrbDhuRHN5Z056VDRrNVZOZDVmQXRSL3h1eSthOFhY?=
 =?utf-8?B?dmR4RWFQRnpEQzZPMDBPekdVK1dyWVdaekpqY3NvcnVDQzZzeFliWVZUQWY0?=
 =?utf-8?B?S1NlWTIyVEZQc29aMU9Nd3hjcThORk5XUzdvTGViNkRWYVlWMVV4Y3FDQ0ZB?=
 =?utf-8?B?ejhYRVRNQi9kK2FoTzVHaTZ5L2xTb0FURWFxdWNGNVp1b25CbU9kUlVacXJS?=
 =?utf-8?B?UHFyRmtxNmo4bTI1bnYzWkdwcVJ2SGJ2MFl2ZURTOWVpTXZhWkF3Y3ZUZFJQ?=
 =?utf-8?B?VWhpeDdDaE9kTEphQzdTL0YrN2ZtaWVrcFBITDIwbHAyM2FuV0dmSnlLRGJT?=
 =?utf-8?B?QmNsdDJtNTVsRkYrZnMxZis2U3BzVUlQelNwT1dlbUNFWWxOMUFwRGNPNWp4?=
 =?utf-8?B?azNrUFBIWjlIaGxvYWRxNS9meXVZb0FKR0xEUmNZam1FRHBzUHRJS2pFZTFW?=
 =?utf-8?B?UEpUQWtOREJHNzFvVGtuUHh4NUVSUzM2bk1TT09nVG9ic1RGbHNhV3R6UVZQ?=
 =?utf-8?B?bjA5bjlwSlpvQVdiYWtpQ3BnUGhjRXFWWGs1bDVYSSt1UU14MCtzaFBlc3JC?=
 =?utf-8?B?ekFqUFZMWHYydjFuVGtSQ0kwbmFlY2x6bi9JK25wekx3ekc4MGNNdjlBeWFq?=
 =?utf-8?B?V2gxaHlDYzdyUFhib1pMaE1JT01DOVBUZzhVYnRtVzNEQVZMcmkyVnFLWExy?=
 =?utf-8?B?VU9YdzhRRG5FZHpSbGpvU29mNFo2TDNBcHlDTXVuem9xRlQ4aTVIWFZoSC9G?=
 =?utf-8?B?bVRaTEVRMnREMWZUcVRTdGxqZEJkZG5WbW5CS0dpRzRSL2I5NjRHTjBMMnNh?=
 =?utf-8?B?V3oyYitVZm9xVmVGL0t1STl1Ymc4dVE4QjFlMHVyTjdqV29rcnR5YnU3d29u?=
 =?utf-8?B?KzdyaEpDdGRmK3ExeU5BZUNXTjN6WTZKWTRFanhSWkplc2VaMlVZWjY0UWZX?=
 =?utf-8?B?R2lxVnl5WWxZektoQzFpRDhPMml0YXZBYjM5YjR3KzBZSEVPVVY4ZElic2FV?=
 =?utf-8?B?QU16d3l0TCtMSEJRTklTSzREd2xoRHdIdGNQMFQ3ZUFqejkxQjNsV2lCZ0Rq?=
 =?utf-8?B?K0RZU1AzL3lIcjhpRmpldVBuZ3dHelIrbGtUcTBrK2pyZ0wzTVdlNjdzSWN3?=
 =?utf-8?B?V2g5UzRST25teGFkT0QxRlpYU2dIcTlVdzA1Ti96dE5wL0tZYmd5OEZmcGoz?=
 =?utf-8?B?RzEyZE4ycS9COXlUYnhhOUM0R2pvcjdmZW9mLzdtdmJVb09vU3lnbkVBRDRB?=
 =?utf-8?B?cUpqYzJsLzIzU1ZidDdoMlB6eUM1QzZkUUhwZS9uNW8veHVPZFRRcmg0M2N2?=
 =?utf-8?B?QUdyZXQwc2lFcUpjQlFMcjB3bElyQUdOK1k2dWZxU0pkKzVkSGs5dHpCY0dL?=
 =?utf-8?B?N3dCZDY2ZlZkdnRxd09uQjJ1SDJrTVVoOXpkL2RpOWk2Z2pzOGEyNHZxTVJj?=
 =?utf-8?B?UmIybXJMUnltc01LeldReWNybERNYVN4SzB6WlkwNWhPZUhEc1lBY2I1bGEw?=
 =?utf-8?B?WHUxaDg5dmwrakRzZHFwVU9CRXgzeGI1T05FSCt4WHg4Rk1Ub0VBNHdPbzlV?=
 =?utf-8?B?djA5dldMMStnc01oMHRoejJmeStIS010cGRWaG1LK0Y0TnBaVWxMcTZPd0Zs?=
 =?utf-8?B?dmpQM0ZwZzhPY0kzamRpNTVYQ3ZwMmhuYnY5c0ZYeUVrVGc2QUx6ZzdtWmp3?=
 =?utf-8?B?Q2lNNDc2V1NlcUl5UHhhSUdrTklYRWl5cCtiQUlnSmFvZTZOVmlycHc2M0xi?=
 =?utf-8?B?VWhZR0hCRmFFRHcrUDdQeTVkVU1MODQ3UFlzUHRlZTI4NVY0MC8wbXdCZC85?=
 =?utf-8?B?OVlBeEY3by9uc1RvNnZjQnMwR3JQUHd1K1pjYzVRZmdyRWExWlBzS2V2bVVv?=
 =?utf-8?B?WU5lazBLL0k5QklXNWdLVUUyWkZrZzRudjl6dTlYLzJuV012Y21UdmFwc2pJ?=
 =?utf-8?B?YU5EUXZod0NXcUNETWUzMlNiQkhzUXNmdmxvNEZpV1dHbFV3bDBicWxBTC9K?=
 =?utf-8?B?SlZwaG5wS2ZwU1UvSVBjcnlST1VBd3A1M2lWMGdxZUlxam1RcTRYZk1kUzRI?=
 =?utf-8?B?MmtOaXlJS2RSNG9PREcvc1pBNWk5VzNDOE10NmdUL1RRYUhoV1F2WmpUL1VZ?=
 =?utf-8?Q?pPBswIRC4q2evIJ3O1dlsOqcX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 53cfb7b3-fb55-4f69-84ff-08ddd932fdbb
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7997.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 23:58:38.6977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cyl9SoYtaois223G4u4b76F4s/07PMFjNT5Gh/2X5MsJ1juCwHUMSXCO6gpnxomiBTlzxdWQRh1t6Tf08vejwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7457
X-OriginatorOrg: intel.com

On 8/11/2025 2:33 PM, Tony Luck wrote:
...

> PeterZ agreed and posted a patch[1] to fix the name and move it in
> sequence with other Xeon servers. But without a commit description or
> sign-off the patch wasn't ever applied.
> 
> Patch updated to cover one additional use of the #define by turbostat
> and to 

Some of this patch handling information doesn't seem relevant to the
commit message. It can probably go below the --- line or skipped while
applying the patch.

...

> 
> Originally-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Sohil Mehta <sohil.mehta@intel.com>


