Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F118027FD5B
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 16:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774285024; cv=fail; b=ov2JGwGVE95Sq11rMgsk0ENz6CVki+GxgKe1leLrCZJs1Qq2151/+NV1UbkaPQfcP5ClsLs4/O+Uh+UDcbYVfI3uyVmNu9kQ/In450j7kaQi6nkZshx2J9rpm+nTSKsRI7hCaXqodUNyry4zo2X6MQLZA/rqEu4C2JZ8hIV0fAo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774285024; c=relaxed/simple;
	bh=K8Ojm7Na1btpEit+C2pz43yMYttUh5E4nCrFECTb8/8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=j8MemuLDi/3UaWxPexpX1stsbAnISNtHXOTcSaBh7tnUXmffw18r4HRfiFW8ADxLCzxZ1s+WQK3X7q8hCHQ3cg41Z8pcruZyMzjoRZ5gbSbocj784/AWcvEapWnL400oY5nwfxgwNzWdmIUXfCo8STdmVACCDo2/cRgs3h1BOsQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=diKXp46+; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="diKXp46+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774285023; x=1805821023;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=K8Ojm7Na1btpEit+C2pz43yMYttUh5E4nCrFECTb8/8=;
  b=diKXp46+baUzX7+86Gi0gQVEVwZvnclFodqTmv1AHxar3leKMFwsOASV
   ItEHT+0oNPZHja9aSEaBlJ/j2GliMg1sofkqbqt08+PBTvKVQGJUHxYzy
   42n8E+Ig4DJuRHC2nS7HhA2JBGupafMySh0H/DrsEkiWicoaLXvAuzqGD
   tZw4VfCAEjbd5Gw0e0mCqIfwvuJEivPVtYzhu5qm4740CdPqO7rVnXCpH
   RvghuqR3rcYvhYJQFhqQzEqT8PkW4l2qR62uGOlpH6W84/duI2S+pgrYE
   J/ZDoaFOuzTToyI4nS1Z99DHduVXKYC+YpHJSQhOtlLUpobvVB9oVx03+
   g==;
X-CSE-ConnectionGUID: VOsRN1JeT6K7RBgvrwpG1g==
X-CSE-MsgGUID: B4cN3xqwRjus84lN/ThZXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11738"; a="92667374"
X-IronPort-AV: E=Sophos;i="6.23,137,1770624000"; 
   d="scan'208";a="92667374"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 09:57:02 -0700
X-CSE-ConnectionGUID: pQsjJCFnTRe3zdSgDdz58A==
X-CSE-MsgGUID: jtge/CcUQZy5ILVzuAr7ig==
X-ExtLoop1: 1
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 09:57:01 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 23 Mar 2026 09:57:00 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 23 Mar 2026 09:57:00 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.70) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 23 Mar 2026 09:57:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hBqEMNm7T0Fa04QW34tFMICdx6kZSRo0pt5t2HFWT+0ZVkf/Up3I2aC7dGH0hlhZ51l75V0OfoBSdk0QZTAnUQXjICdNEp7DSDBMQGfSZPC8oMDIEyeS6O7P7xrycw3Ggtp/1WT3daowgBvsug/0cnenAC+2xsfOlR77PH0Xl87ZjAzqUp5v/dp3EN8q3JzU1jejWMJXU45ndCdFF1hR+LgBa/ZnNF2nwctH1kP89/VSJcMilNB0xp+lNYsp/yfgrI5nsnbwc1qY7XUY64TfQWhClTDZMMie4JuGHen2jte8i5oj6FfPRvTSU+qtzkt00zcLYozQdFScftsXzsYn6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IeYBxlaG1UH+Q2HK+dqAPWV7wIgxWNZbqKmG0iYsbLU=;
 b=bVBZJG7lZxLzl7JBFLUsOHT6vKOfTLuk7dvVLt7vBphhro5GuWOBSvQmmgFPjkU9Rt9Lw+siAKD0U8RIe1jUfATfUWM8fKfTlx/8678CA+t5qtctGwxvuQbFwdR8hg3mo0MZgbdf2NDrqnW9/XezQ+BD+cmOw8F/Ql1DZz8wVr6h2L3i4M3Bb9EoXdC0YNe3D3nItbhrZ79lJjFCVeFXPx+1c0/Rey+UvDo6pydXDIeHkWNf+I6DsM8W5KZDrEAwWVMw+KMA15zoJpdR3yI1uXvqmrgmFvsCONk5/OINqHcPvGMmemp/RnTJ3YNC3YlOkEoDHWg7o+wV6hzH/ixKqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH8PR11MB7069.namprd11.prod.outlook.com (2603:10b6:510:217::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Mon, 23 Mar
 2026 16:56:57 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9745.019; Mon, 23 Mar 2026
 16:56:57 +0000
Message-ID: <ff39b7a5-6279-45df-a025-810c3f17e68d@intel.com>
Date: Mon, 23 Mar 2026 09:56:54 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/14] fs/resctrl: Add last_cmd_status support for
 writes to max_threshold_occupancy
To: "Chen, Yu C" <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<tony.luck@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<bp@alien8.de>
References: <cover.1774043709.git.reinette.chatre@intel.com>
 <1477243b7c470baa920d94477b30d41405fce45c.1774043709.git.reinette.chatre@intel.com>
 <a3e604f4-42b9-4a10-9829-928bc9fd7b4d@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <a3e604f4-42b9-4a10-9829-928bc9fd7b4d@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0120.namprd03.prod.outlook.com
 (2603:10b6:303:b7::35) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH8PR11MB7069:EE_
X-MS-Office365-Filtering-Correlation-Id: b9784135-86a3-4647-97d7-08de88fd31aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info: LkxieGkahwy5oSRWmLxT4vOztFxAPOFvVq/DeQmCWop0bmMvOYYaxDlKX2AMrubJAWssm9t1HLU//3dMER3TFj0DOPFON5bFPZLBPcl+tVNtDulXRhFMu47GrAqMOTntAdP3KhOV60fCG+3JeVf64OFvLBCpIIgT+0Z5hT8cLErQ6x5MPddNK9sOmUDKe9AQXLZlIHnqOqNhUJ5jxNtKlJIGgJdSIZexo3Z20l7VbdwtzqFp8849Wh5luztMNSY+uYIDVs9q1zze5t6UibyqLydBS84nkxkXHG6HyarZaPbWIfAOZ16FCXdRSjFWNBEMHklFXVKgW+5qVkToI9GRWlDNHCDgjORCIw8n9kfBUGeW/6sLK3W/YawijCcyTlFXlq5zRDnrAk+dd85qf159DkYaR8urN59/XmA9H9PsgNV1mQYYa5KkF4QR4jXHPsgGBqVi6lkg3eAWk6bB0teU41bynNxzO1P85guUyy4aY4A8LaB4y55OHcWSt7dDOc17ziHwm+PcWDR1NXDkZlFRTSpcSqVz32YI6R6/fVXuZGH/HK19xmZvmd/gTOgSubT4hSJ327FxfJmrMjh6DyqFaXnPu2QNTODGN1ZYFB1JiO07Xifq7c25x6B8S//2eKJ4j10F22UGloSnxtbyjddQ91R6QHaA+vgl3aH7eIY7n1/4Ukmk+xlYb0oUCsFNibSNDchxC2o743LuG+N++hK+xUbW5MzrUD539aQhwgdYVSw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qk8rTFFQZVZEWFpaM3pqeDUxNTl0czBhd205b2JLOGgzR0p4NzdXTlJ0L1hJ?=
 =?utf-8?B?OURaUEVnbkp2NkZNNW9ZM2xLOEFxTUpyWHJZa1hya0plQkdremU1QndycGhv?=
 =?utf-8?B?T3Nab2tQdzB2VlpWb1dsTTVKUUZSNXJscjJkdmpIcnlEdUh5YUtaNW9iVXFw?=
 =?utf-8?B?cmYydCtocTVIQmd5Z1VncWlaRlh3VVd1SHVtTmpzQjVFU1JFRXlXOE8xMXU5?=
 =?utf-8?B?NlJJNHF1eTB4VjIwdnEyZVhGeTlvUUZGOUNQalFNQUdTK1lxNXgyVGhYdHh6?=
 =?utf-8?B?YjFGT3NDNjVETEN6eldxNkNUQWRqUU5VWUdtVHpZMXRYbTBTZjJ5TVJSWmZs?=
 =?utf-8?B?azRaM1lVTE9qS0pNelJRUXU4ZnVQVjMxWXpYN2N3QWRNU0FJeUxiL01HYWw5?=
 =?utf-8?B?dUt0aXlSWk1USWFFUE9hYkR4Nmo5Wm9FdGszdnBpNHIrOHVXYTNrMlptbkNY?=
 =?utf-8?B?UlhBaCtsZlFuWkJUVGpWbTlQRzV1c1Y4ci9qU3g1c1dSRi9nNVVVNDc5Z0JF?=
 =?utf-8?B?Qm01Y1RPbE0wc043cWNNL205TzRYWmhDOUxaSFlGMEUzVy93TjExZzlRS2Nx?=
 =?utf-8?B?cnJTYUp3Y1lQYnlVKzhYSDhZZlpiWFV4cmZuenk0UUhNWGxRS251UW16bVJa?=
 =?utf-8?B?c0VFSGdIQTdEYXhQSzRDMGJQaSs1allzbmRqNTZpRnBzZWlEODE4WnFKc1Jv?=
 =?utf-8?B?Wm1OMkhtbDRCV0lKZ0pjZnY2UUVHWUMxQk4xVDZBaTdleXJ3Wnl2SUdIWVRx?=
 =?utf-8?B?SER5WU5GVFZCcXdCYkgvenJUbnZFb0k0UTZDZG1FVmdhZGxyZXJZRjdIeVFC?=
 =?utf-8?B?QmgrazlUTEQxdnRzVEJ2bDRsRXp4QXJObjZSYnAyS1BFbEg1NlhwYVJPeEgr?=
 =?utf-8?B?d0hFUG90bSswUW1KZkdDU2o4ZFdzWkVIM3cvZ2doMm8xMDM1bmlQOEl0MzQ4?=
 =?utf-8?B?c2kvTTFtOTBnWHdaajRObGZUdGp1eWMrNlJzSyt1RlV4RzZGTnpJWm5aMWRW?=
 =?utf-8?B?cFg0YWhHMWlYZ28rMjBtZko2U1VYV0pGVjRZck5yVS8wTlc2VVV2VUR3WDdW?=
 =?utf-8?B?MTZ5SjFaeWI3YUZtREg0VWJycnhJaE9DZURGeDU1N0VwRlVZQUtZemtXeVhz?=
 =?utf-8?B?RFBsbmltR2tCejlhbm1vUzd0VjI5MWtVRmpLSUw4TDFyekxWZ1JqcytzKzlU?=
 =?utf-8?B?RUxnVWo2SVBSRnFlYnJCRVdBWkxqZ0E3a0owOHhWVFpBdWZlcndkdlA5M0JH?=
 =?utf-8?B?Snlpb0xYOXNIOFhZaG9hYkFlVGluRnBNYzdjMlZSMHdtMXJwUjkwR1gvV0Zh?=
 =?utf-8?B?c0t3RGVHcERMSHhQYXlJeHcwdkFhRVkwRnZ6Z3lWbUFERnRobHdkK2ViV3VR?=
 =?utf-8?B?ak01Zm8zUS9FUlhsMlRqK05hQkdtajlVd29EQ2hkcFNONXBHWjVRL3RrUW53?=
 =?utf-8?B?NEtrVHR4YTNDNVVQSlJtV0VuNnZidXFrVW9GT3NkM1JTenUyL1RtNkl1N2pi?=
 =?utf-8?B?M2NqZitWTmpQdTN5ZDBXZFMvbUpOazh6WjVWb3hmZ1pDclBoRUp3ZEZTMFZQ?=
 =?utf-8?B?NUE0c0E1c3dDVkJMaDJpbGJvUWlSb0VWVGJKc0V5R285dSs1bjJDakNVTGd3?=
 =?utf-8?B?WHJzWG4zMExOYVVaTFlZMWZVMXdIRzVnbE5vRzJqQ1ByaVdibVZIdUp0WEJm?=
 =?utf-8?B?UmVtUlZ6bW1wc2x0TkFIU0gyaE5YREZPZVlqajVOMzZkSG1vTFgvT3dRL2Nz?=
 =?utf-8?B?QW1nblZOOHhJUllkSzB6T1hFdTdIVHVKdEQyOEk4bjk3V2NkZFF4T0orM3Q1?=
 =?utf-8?B?SGFtaEJldjVuUldRbUFyUVNqczE4YksxRHltNDVwL3FVb3pRb3h4b255Zitz?=
 =?utf-8?B?d1hUTEFzWG01ek56SkpnSXpTaVM4dTkrMTZkMHpBVEE4RmFudUk0Tm5IT2I2?=
 =?utf-8?B?MWRtVDRLaUZPR1QveXdVeXpPVnVZemVjN2xwRllvNDYzMVU4YmF1Tm9KOFlJ?=
 =?utf-8?B?WjZwQ0U2bDU0bDBsL0VjZE5Zek1ZM0NBYmxoU0g0dlNUSmkyV0s3K293TGR6?=
 =?utf-8?B?SUROdEVmRXBVaDBtVURvVzVFZ0hIOXF6V2RrV0sya01pd2Nac2l4MDNIbXQy?=
 =?utf-8?B?YmU0Ym5sYWpRMkU2amhhbVBOYUk3cUJyUnM2cEdPbDdFNVlUdmhDV3o4T2NM?=
 =?utf-8?B?K0NaRWV4QmtaQVd6a3hma2Y3cFFPMWRoM00zMkI3YXJJTXdpMjdBZ09GRzQ3?=
 =?utf-8?B?SklGU1Ryd3Q2UWxqT2ZPT1BJbFVLcnZ2Q2h4VzJTTWNiRXBEaTlkR0QxQ2kz?=
 =?utf-8?B?cGtoMkNvMlUzN0ZQTmNBMW9ub2JBTUZIVGZhTVAvZmhrQlFNUzcyVWl3eDhT?=
 =?utf-8?Q?Fp3vAFQLgYNlmSgU=3D?=
X-Exchange-RoutingPolicyChecked: gcaTAPQAklW4hB4gfHlCPpqbEhnxhgd8/h3syJsvlF6kmCPlWWpUXvcFkx/AVAG0LXc/WwhCGJkyn4gQtYJUR68urA3kxS+yRQ7ZYLCPFE5UnU0IkddANeEZjWcgZRmgEUewWaLdnoZs2qvzO8+nqpxZZDG0sw7LVXx+1VE39Plns99iYE7Za0iRzlZnbVPHhkqbaYO24VGy+UbnfVzK2VGBVZJxInltjBFQWUjATEHycXbSD3UEhcJXwjDYnif2NxZAunT7E7qPKgdiQGYIKcZ9iiqOkQxCzUYI/jIu5zcHPIJyPEt819BNGfcP8uQFqJzOs8kr1mumBK2tJzygoQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: b9784135-86a3-4647-97d7-08de88fd31aa
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 16:56:57.6832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: plpW4qgnMFSPi8eQxbgBLP2L0GflVLrz+7UaNBsTHGqpLOGYAwv3FrUaOFmzmlGs5bmo3IG2DGw/JjyGYjyGJtPNaIdn+JOt4mC42/Rx80k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7069
X-OriginatorOrg: intel.com

Hi Chenyu,

On 3/23/26 2:14 AM, Chen, Yu C wrote:
> On 3/21/2026 6:03 AM, Reinette Chatre wrote:
>> info/last_cmd_status is intended to contain more information if a write to
>> any resctrl file fails. Writes to max_threshold_occupancy did not receive
>> last_cmd_status support during initial last_cmd_status enabling. Add it now.
>>
>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
>> Reviewed-by: Ben Horgan <ben.horgan@arm.com>
>> ---
>> Changes since v1:
>> - Add Ben's RB tag.
>> ---
>>   fs/resctrl/rdtgroup.c | 21 ++++++++++++++++-----
>>   1 file changed, 16 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
>> index 111bff8e33fd..6fa5c8f14e3a 100644
>> --- a/fs/resctrl/rdtgroup.c
>> +++ b/fs/resctrl/rdtgroup.c
>> @@ -1238,16 +1238,27 @@ static ssize_t max_threshold_occ_write(struct kernfs_open_file *of,
>>       unsigned int bytes;
>>       int ret;
>>   +    mutex_lock(&rdtgroup_mutex);
> 
> Maybe guard(mutex)(&rdtgroup_mutex) and return ret when failed
> so we can get rid of goto out_unlock

Will do. There is no plan to switch existing patterns to use guard(), but using it in
cases like this where it is a new introduction to a function that does not already
use goto should be fine.

Reinette
