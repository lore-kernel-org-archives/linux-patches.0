Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67F8273810
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 21:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755208565; cv=fail; b=SdIyHQA0AX1FjhleCQnmSkOL4C8QzvLRkB5Cr60IjawK0ub7nVqMWNizECgamQQdfC6POojCCvx1B5OWFbHciRFbxE+Toy4MncUaZlRqT2sD1rbBJ9+96KvV41AGm6bsWa+ho5ZwuCs3/EiySgMIkNSR5wkymF+xfv2noh/QgkY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755208565; c=relaxed/simple;
	bh=QSU/5j6/bQ3GauCjlhUyyAZKao/H7x0/qifCiO1YKnM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iwD6fgGU5DPVBKff6oU1ZtCaEaoReWuwxmUJ2scANY1zO8MvUjklJw1p/LM2PskprBUUIurbzypYvxqJx4nEnb8pPX+yroW4hXwRc16vLO/flGoyuVoyc81aKWVQjVMiOGsKxZD1bLk3UgEuuM0Eaxqq8mbhL7uXfp4OljmTiuI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T5bouFTx; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T5bouFTx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755208561; x=1786744561;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QSU/5j6/bQ3GauCjlhUyyAZKao/H7x0/qifCiO1YKnM=;
  b=T5bouFTxMF+0+WC4hFWSBejSWF7uGGYLnsRgd8RhAgCpQX8CzyCx26bV
   gX9Iel/290N6q//9rRtUzzy7pKW44pYm+Xdg94iHKTkrs3RZO2ZhNKrHz
   OebzWp8l6qpJSioBErNd28eGOtBJzy6//aU0hZ/0ECtW6wxoysFugN4x/
   YlMWVgC6yidtwYA727Elzl5nFfZeF3HFOTo72o6cadvImm8XBNEg+xecb
   c7hBriPegm+P6/7H8ZPDYlpI07Oa+ES+nrxMGcfQVKVA9gxYPcehBaScw
   JWYV6MzgDtaim/b4D5HvIZm91V/LAz6hx1D+Xu4L/w2a8q81QNI1l3tEV
   A==;
X-CSE-ConnectionGUID: v63uPM4IT4OuDlqFNtz3Mg==
X-CSE-MsgGUID: V0pK99sdQKKDT1bC7qzxQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="57686313"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="57686313"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:56:00 -0700
X-CSE-ConnectionGUID: 22Pbh+ErTfS2O/Gb2OVnqQ==
X-CSE-MsgGUID: AtAkX8OKSvGV9UY/Bdsb+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="172197915"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:56:00 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:55:59 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 14:55:59 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.65)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:55:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pGQnYOgKzk8D+8TV0k55AxYONOfDiKzA+AoHyg0bhlMANueArPwt+IBsxObAJNHvgpoEhD+Ib+EBiGN8VuJ1LVFtZ8qPFwapqgGJBBGmWPu4yQJuKxd9saDk2Q7IqEh+AcSVroRK2S5JbTyr98rRkGqD5Cyd6kh0LR4QnD4QJ9eH58I0KptfT23s8tud7bEphAcCQU4vISHzokFkRSbm5o00GtDVyq+gZYOusnKaapVuLAWeIS2JwjYceFN5MN4K06tlY9vuG+zq1F7/vEGzf+BeCKTMJlwJLKen54kGoGZ5Xm4b+c4qez+KjsB5CaWuQmMduOHKXsAEmBO7WglF1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MSGpIa7BDOA2ktZLz8c2TwZzNhbUhPoMTPHv02fOjj4=;
 b=iLc5ct6Ke4uQSR5NmCHAOls4Alr8bVdPHPq4Js7+bNkFLfQ1rr2ZnncEE+bjyr/m1McKtwawH8N0XoIN8IOXmhx6SeU82xcV8TvysaACVJpD6RABpwr8JEAgukp5wSSi8RgqJnl5S9rT/zHA6iasrATcbKTELVWIE9Qxr+rV4pt82rYxCkfSIQ0rWhiOziWg2/k37LA41y3bHUHpsmPgfamZ5WnzwJSodE2vk+Spy9h21SBL5BpGFayO00Mw0MWbmMIuwPQLHdscCOx5Z8noY8AvXz5C1+6UzaS2XshDqnhPY7Vwwju3lT+YAH3tId2PaO0q900lQF00q4jGY8ecbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CH3PR11MB8467.namprd11.prod.outlook.com (2603:10b6:610:1bd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Thu, 14 Aug
 2025 21:55:57 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 21:55:57 +0000
Message-ID: <d03f4e7b-0afd-42d8-a181-f1820a694f9c@intel.com>
Date: Thu, 14 Aug 2025 14:55:55 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 27/32] fs,x86/resctrl: Compute number of RMIDs as
 minimum across resources
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <20250811181709.6241-28-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250811181709.6241-28-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR02CA0006.namprd02.prod.outlook.com
 (2603:10b6:303:16d::12) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CH3PR11MB8467:EE_
X-MS-Office365-Filtering-Correlation-Id: 84b267d4-3846-4ee4-111a-08dddb7d594d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UzJmZFhEMGdZVDBFV2ZEUnlvZUQveER6Ym5ZZmdQWWRFNXY0cENlNkZnWHVy?=
 =?utf-8?B?TllMSk5XTnZGWnRpaXNRR0JzQXFqOThjSVdoTkhYOVBqdWJLbC82T2xvMzlI?=
 =?utf-8?B?Zk9zWWRsNDBuNmRscG5NZGVTTEVobFBPNDhZOFIyakw1MXJFSEl3NjE3SlFt?=
 =?utf-8?B?NG91c3lLZWYzMjZQOG5yencyK0RqNG40UGZOQ1dTVldEYlFqQWs3NHN1Tk9M?=
 =?utf-8?B?TXJPWUNHOWNPcWt2MkhBZ0pUWnp0NzhqSUU3V2JuMU9veDU1U3pSM3FZSVVW?=
 =?utf-8?B?WXgvRmpPcWVocm1Pclo5SUJkaWk0Vml6K0MrU1FPbzR0M09JN2pnbytOZThW?=
 =?utf-8?B?UVAyeWxzUS9KRFNtN1g0M1lvWlVXdWF6eEx3bFI3R3ZzdzdvSVNzb2wyS0pr?=
 =?utf-8?B?elM5Z01jSWtSckJDOW5sVERGRWRSSmh6U25UOHFESTZQVEZXeFJTUzJtTW12?=
 =?utf-8?B?SUFxUVlFaStSTFI1SERKRkJxa095MFJ0ZXl0NVF1SUNjVXJaMFdqTDQwR0t5?=
 =?utf-8?B?d3FqQnRxaFU0R0lWWTZ2bm5wbE1hbFZwdnpoUEw0Y1V2Y1o2UkJzeGRUUytP?=
 =?utf-8?B?dFlEaUZTY2lZNC9pUUY0U1I3Z3ByUnY3UkVieHhCUWwzaDFGRlkyUUpCQ1Ix?=
 =?utf-8?B?V0IyMGFjSFVRTmt5S0xsQTVOY2RsdVI2WHJuamRDVVpURWxtQnVBTWF1clpX?=
 =?utf-8?B?ajEyTzBQQTYrTzI0djZoS0t5elN1ZmpqZ0g4M0FicENiVDBSdThHWmJET1FN?=
 =?utf-8?B?b0Y0cGIyTzJWd3J4SWsxSlYxNkVuaDlnb1M0SGFSNUhsL0U3c3JDa0tZbWta?=
 =?utf-8?B?NlhhQ0JCUjV1ZVZpVEZDVGI4ME1GN0kzWHd6Ym0xdGMzbG5zS1cySVhiTnVD?=
 =?utf-8?B?QUY0OTlVN1Iwa1Q4YUtPeEJ2UVlMbExHQitsYmNjS1lqR2x0ODhDN1lDUXl2?=
 =?utf-8?B?K3F4WDFzeFpmZkJjR1RWLzkwQ29TcnJjeXBPMHA4VWI5UnB1ZVc3UC8zczZx?=
 =?utf-8?B?L1B0eW9nUElYeFNRNGY0UkNNYWI4cjA4bWQ0RVpEbTFzRndvZHpQSWhtV1JF?=
 =?utf-8?B?UkZFUVpscjNKTUF2Z0VtK2pMZGhMY2dBaXUwNkRHRkJLUzF4SE9CdmVJVXJj?=
 =?utf-8?B?Q0UxU2dIUmVtVkdjS0c4Wk1zUEdwZEhrMUV6SVhjd0xHTnNMZzljUFNpT1hn?=
 =?utf-8?B?OWxNaWk2Q2k5VWtNbWJvMDV0NzdIbC9wUytOL044Zk4yczY2SXFXUUNHRWZL?=
 =?utf-8?B?L3dYSm1TQjRZZmd1cTJZN2xWRGNPY1c4VUdkcFc2bTJZOUFiTUFZdDFEayt2?=
 =?utf-8?B?dDJNY3M0azJXUVdrNE16WFRjZmkrRmhwaEFJVFNMY0ZnYlVJRk12UCtWbElx?=
 =?utf-8?B?NUp4Y0lISDVXcXhtblhONHFmTkZVMmdIbXhadnVmRkRhZWxDZjAwNzI1ZXBr?=
 =?utf-8?B?cGpnaVdtS0dxelpnZURQd05kMFNvdGZlQW9IUkQreXFXSTBUak1MTGlxUmRN?=
 =?utf-8?B?V1l6V25pWUZENzd0Vy9lSEFwNXRHekdkdEdhQ2ZuaEY4cC9tbC9BemswWXVx?=
 =?utf-8?B?TWFIa0JCeStWbXV2dUxLcmZ6Vy9BSkJPWk90V3NhSU8yTUp2YUdyZCtwU3Qy?=
 =?utf-8?B?QlZ0NzJ6SmFaSTA5SlRncVhESHR1K1FmSUh1UUp5RWhKSHh2d1h3S0I2bWtX?=
 =?utf-8?B?SG95M3BLSTVnT2lNdUFkaFFhanovaVdvWTdtSkNHWlpZWWRjMVpGTkVmcFQr?=
 =?utf-8?B?bVpPeFg0UEZxNFRnaUdCSUJXWUtLZ1NmdjByYksyRUF3VVliWVV3ampCdVFw?=
 =?utf-8?B?VXBLSTF5dkYzYUtKUk5WcktVWUVVM1BiZ05GeGlVTmo4UW1WeEc4UHNpN3VN?=
 =?utf-8?B?QW5ZUVArQzBrYktMTEJnOG51NUQ5aWNEMlRSeTNzbzZ4NkNYbFRZUS81NzZR?=
 =?utf-8?Q?DiRBC6a3O1I=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UlhzMUZ6ejRSR2RxQlpCYWJxSTdvNEpzMHdHUjNNL3RTSTlGR08yU1pCcnpp?=
 =?utf-8?B?bEl1RDI1RDZ2cVFJckRQajNPeGRqMkFyNzdpRkY1M0ZkM3RGU1liS2Fram1Q?=
 =?utf-8?B?b1pWT2xjUjg2cEZRMzRNcXhyeHF1em9SeWJ2SEVJblM4RHpkcHJSa1ZmSjA4?=
 =?utf-8?B?UzlSKzEyeHc5TEFsbnFwZ29xWnpKb2syL3BWaWhQaTQwYUR1TXh2TkNPc3FT?=
 =?utf-8?B?Yy9lbmh5WUdtVzlHcFNDcEcvVmJ1MFFoZWgzcEM5bC9yOVZVeUlWZnRia1hk?=
 =?utf-8?B?VSsxU0VGYThkUFFKZHVTenRUd2hmZkk4Q1hSZlBQNzV1eFJodVFjQlNRWDBC?=
 =?utf-8?B?dEw1UGVYSjM1Q3pweCtMUWFsZDcwdlBSQ01YUGxBaERrTnFheUc0R3djOTho?=
 =?utf-8?B?aVVzZmEwZ0RIeHN6MFkySE40OGNneEZKTU4xYUF5NkV3cUtJbDFSZ0NUUU02?=
 =?utf-8?B?c0cxbDJVemdCOWk3S1JkTUJpdFB3eDkzaXN6aHNZVHU1aEVNTTFGTUJHWk1P?=
 =?utf-8?B?ZHlDZURRa2l3akZxSFQ2SU04NXdPYzk1MC8xeVFJNG1rWFVBZzlLTllVaGxF?=
 =?utf-8?B?eGJ6cGtudmxyZExCYVo4MG5RNEltUlNHRmM4L041N0N4TXRYN3dYQTJ6c1dL?=
 =?utf-8?B?eDJvZ09JVU9SQW9TekZKK21KeG90UXE5U3gxQlNiemc1ZTBFcFVLUmNCdStR?=
 =?utf-8?B?SS96V0ZLMk1rb3NrT0YxeGlJSmNpUEd5emNRSnpCU0x3blh1aUsvZzl4bUhl?=
 =?utf-8?B?S0JuTS8wWndpZW16bUVuMWtHdU12endra0xHZVV5TW04Z2ZteXZtK2h5RjNG?=
 =?utf-8?B?bkZaK2NpTmNoMzlhQmpQWGpPQm54S2YxY1JrU0tQWEpWTU52Z1c5UTRuWTQr?=
 =?utf-8?B?SW91OE1zNEVtamFaczlTNWJGZlZpZlY4b2VUdnZCR1oyYnU1QXBleXN1Vlh1?=
 =?utf-8?B?dWJDa1JBOUYvaTlkTEozTUc0ZVBYL2o5WGF4V3lZM01FanF5OEkzZWlZNW5G?=
 =?utf-8?B?aXRNUHZJWlRlQ1BJY1cyZ0R2b0lzc3J2aDBpeHQ0WEwzcWh3anJhdTNCQUJr?=
 =?utf-8?B?QTNUd3hVbkwyVmQ1c2UzaTI2UGczalE0YkZkajFOUzlFUVNxSm1PV0p2V0hM?=
 =?utf-8?B?d1FnR2l1MTNZRE13d2FBczFFcmpIcFphVVcyWnRWbWxZMDk4WHNUMy9ZYkx6?=
 =?utf-8?B?M29SRjcxR0NtMTd5Y0h1RWloUUI2SW5FSkpZQnNYNnhEREIzdzVGNzhESjU2?=
 =?utf-8?B?RVpxU1E2UFFqeFlRRlNncFZWQlFRT09Nd2p3dlFxVVJhaEpxRzRNUzdXWWV2?=
 =?utf-8?B?eFN3aEI0emFhN1RrTXQ0UFd2bDhxd0FJTlN0L25LNzRwZEZ5RldmQ1l4U2xo?=
 =?utf-8?B?b0NFMGFmbVoyVGNsaXNSWFVxNnZHS3EzT0FxSWNmb1VMdHVBTGlmWXhZUkZn?=
 =?utf-8?B?djNJL1NQRUdBc05JR0VsZ2JlRUlsR1ZSM1BHMWVHSFdhR2tnRDFndG8rRDdN?=
 =?utf-8?B?L1JEYWxaRFQ5MjMzTjh2TzZtNlRLYXNpd0VFY3lwVU41cTFTWnp0Y2Mvb3pN?=
 =?utf-8?B?ell3VzlZenVWNC9qOFBaSGRlQUhHL1lLVTNPd2ZCcG5SaDZLREZGVFZHaDFG?=
 =?utf-8?B?bE1NRVprTzVISnhKaGtpeVU2S1FZTmlSSXkrYmpvdjIyTGFNOUFhdFNENXJz?=
 =?utf-8?B?ZGF1Mkl1WGZIbVRLMWhlR2M0WDhUdTNHUmtpWTA4YU9mc1VReHZjMlZXZU5l?=
 =?utf-8?B?NTgvcjgyN3VEWnFEV2ZCbkh0amE1ZUdmQ3pYR1ZtWkV0bkVyald3QWI2OGJB?=
 =?utf-8?B?RmQ4OExMWlMrUUVBd08xWTlpM2pyVityYnROV2hJOW94Vmo2N3o1TWJZT3Vu?=
 =?utf-8?B?Szg5S2ZZS1l1MDUvc2ZVL1dZcVVuOXRySFQzR2pPMGJtVVZIVXdXbHpVVGkw?=
 =?utf-8?B?NVN4WXd3N1dkd042UzNkTDN1MllXTmhMY1lwRTh4d2V4T1ZISGV1b1NqU0E5?=
 =?utf-8?B?R0VvdVlmOGFKcDlLNi9zbTN5S3RyU1dEN0JmVS8yZ0FBUVB0WDF3RnUwUGVy?=
 =?utf-8?B?NEFFVXRMU1FvQ0x5Sm1WYVE1d2hpSDgwczRpZUpnazhuanpoVVh5OXAzWXdE?=
 =?utf-8?B?WVFSUUVQeFZubUZlSkNTbTZSMW8vUjJVTGczRFp6c0tmUFk4dHRFRzBUWDhi?=
 =?utf-8?B?U0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 84b267d4-3846-4ee4-111a-08dddb7d594d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 21:55:57.3290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cWAbNu9kLFNhacT7AMTKxPTc2m3vNbTVFnOnWSb4aTNW8pltlaxNIkLRIDYzg4er71iYzxM7fJrrTAxxLiYUaWRy+IUetviubhZaY2k1y3U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8467
X-OriginatorOrg: intel.com

Hi Tony,

On 8/11/25 11:17 AM, Tony Luck wrote:
> resctrl assumes that only the L3 resource supports monitor events, so
> it simply takes the rdt_resource::num_rmid from RDT_RESOURCE_L3 as
> the number of RMIDs.

There does not seem to be anything wrong with "taking num_rmid ... as
the number of RMIDs". How about:
"the number of RMIDs" -> "the system's number of RMIDs"?

> 
> The addition of telemetry events in a different resource breaks that
> assumption.
> 
> Compute the number of available RMIDs as the minimum value across
> all mon capable resources (analogous to how the number of CLOSIDs

"mon capable" -> "monitoring capable" or "mon_capable" 

> is computed across alloc capable resources).

"alloc capable" -> "allocation capable" or "alloc_capable"

> 
> Note that mount time enumeration of the telemetry resource means that
> this number can be reduced. If this happens, then some memory will
> be wasted as the allocations for rdt_l3_mon_domain::states[] will be

"rdt_l3_mon_domain::states[]" -> "rdt_l3_mon_domain::mbm_states[] and
rdt_l3_mon_domain::rmid_busy_llc created during resctrl initialization"

> larger than needed.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/core.c | 15 +++++++++++++--
>  fs/resctrl/rdtgroup.c              |  5 +++++
>  2 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 2b011f9efc73..0284da075ea6 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -110,12 +110,23 @@ struct rdt_hw_resource rdt_resources_all[RDT_NUM_RESOURCES] = {
>  	},
>  };
>  
> +/**
> + * resctrl_arch_system_num_rmid_idx - Compute number of supported RMIDs
> + *				      (minimum across all mon capable resource)

"mon capable" -> "monitoring capable" or "mon_capable"

> + *
> + * Return: Number of supported RMIDs at time of call. Note that mount time
> + * enumeration of resources may reduce the number.
> + */
>  u32 resctrl_arch_system_num_rmid_idx(void)
>  {
> -	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> +	u32 num_rmids = U32_MAX;
> +	struct rdt_resource *r;
> +
> +	for_each_mon_capable_rdt_resource(r)
> +		num_rmids = min(num_rmids, r->num_rmid);
>  
>  	/* RMID are independent numbers for x86. num_rmid_idx == num_rmid */
> -	return r->num_rmid;
> +	return num_rmids == U32_MAX ? 0 : num_rmids;
>  }
>  
>  struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 55ad99bd77d2..5352480eb55c 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -4116,6 +4116,11 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
>   * During boot this may be called before global allocations have been made by
>   * resctrl_mon_l3_resource_init().
>   *
> + * This routine is called at resctrl init time. The number of supported RMIDs
> + * may be reduced if additional mon capable resources are enumerated at mount

"mon capable" -> "monitoring capable" or "mon_capable"

> + * time. This means the rdt_l3_mon_domain::states[] allocations may be larger

"rdt_l3_mon_domain::states[]" -> "rdt_l3_mon_domain::mbm_states[] and rdt_l3_mon_domain::rmid_busy_llc"

> + * than needed.
> + *
>   * Returns 0 for success, or -ENOMEM.
>   */
>  static int domain_setup_l3_mon_state(struct rdt_resource *r, struct rdt_l3_mon_domain *d)

Reinette
