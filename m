Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258237BAF7
	for <patches@lists.linux.dev>; Wed, 22 May 2024 21:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716413061; cv=fail; b=L50z5Y1WVFPiNjQY/IhVrM59OHONawVwOtNQQ+1YjhRW5c+X0wxtycjAd30rrz36NSt0WEJgmByMdrZSlnlfSyXYXKh45lRUiajSuLYBpAh0r9NLz5txmmVPpH5ZtSAvTRKyuI38Fp3cHJb86irY1mm7b1Xr7NUDjMJi9b+xXAM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716413061; c=relaxed/simple;
	bh=5a6J5br8fwfhqsBS6qBCJ5Bp+xhcKSvt445jUuiMdm4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fHKk6yNP++DGPZAk50jCytTmOkdCzfEvahiCrxlKt2xIcQyCC9y50SUzw7U5sQQPqFIUH6TsvK3bu7i87TYOwC/e8VT4y9mbgy9rbRztinv1indE2IJ88ghtB3VYZ88bZQXUrCzEwO7F20dy/6nbiEjM6mSd+RowQajkwgWUPEs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NcCWSvsx; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NcCWSvsx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716413060; x=1747949060;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5a6J5br8fwfhqsBS6qBCJ5Bp+xhcKSvt445jUuiMdm4=;
  b=NcCWSvsx/PpV/WqPk1zg/7uOd07l1aDoTKYhiJhrF+LvRRCDSfE7bwct
   sjXJSMAwxBy9fu2TU+mpVv9LB71qY4R1mBdwuuPOWFq1WO1NXtoozya/6
   YZLFJDjn71ktVgVbV/D+eJ4QFAUB7a7TZ0XEcdFNJIjeyvVAWmzPOM+W/
   CGK/5ttKiY68jFeyKd90pTPhSyg3UBmQPqQl846+U+dWPdtgFDbJZp6oE
   BjjVbDaAq5dm7jaTEe1WBLOC4Y8Dj58jCSHckZcx2ZJhQnPqASy+fYV4F
   mwT3xV9nWLpUTg8M7Y0Cv5wiY6Hqv/R0BosDFW8QITgd5Ap1LYeMqbhNF
   w==;
X-CSE-ConnectionGUID: h3ZKeBZISDm9qdu5zXMIjg==
X-CSE-MsgGUID: LnO9MQB+R5OpGrsVhKWIMA==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="35206638"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="35206638"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 14:24:19 -0700
X-CSE-ConnectionGUID: gIyuGEAoT5+FHUnmVSAM2Q==
X-CSE-MsgGUID: 6qdpTMYFQrKFkdfgTpnGyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="70824553"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 14:24:18 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 14:24:17 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 14:24:17 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 14:24:17 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 14:24:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=amNhv58gK0Q42Ph5HpXedPcRiXTMn+s7XkNTGE28RQfswXKNJY0j1LgM2zFE4ITcjDZHa0YYkAWNW9tIRZKQmWiRIURg64u0Vt42PUUoy8qYvwikncJ/onL6LgBnhF1Xd7BLiF1VK96HHgQOzmCSIZB0+VzJMLIc8hBxBKOGsoSXc/CEvGBAG7ZMQaEnQQN1qCUIiCXuiMyJRdXZz3mDFkhBU89ozqTdc0/ihJaKsIo1BkdIP+ajeRa/OPAYi8aOZYyz1VNWUmmMp0xcAKIwUAnxvNz2X7C/SvIFIZxtgfyhwFOGj3bpETfxftfWeevRMDvrxjNshDwJwkPceUhzKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e978tpVbAivZ3kL7DC3gCVUkkUr3smEKGqJ1POO0AMw=;
 b=B/ZZ9VsEGQEW8rAoTGqWylGpM0rp4aKEZ3+OsiLK9bY63eImnw61aEsPW2FC77eExfrSCC1Jjp70nejmV68IYsXoXRmD1F/XNBh24/VrHrkxgrKZQZdCd5iuM3UCzHfHwjS4cZMEBMZhNwUAVxn49qaF6Qm8rxOVT1Om1J8s1lnlcIoTWX5MB+TeZ/SfMlFwlcfHlOqh+X678XSS1oUHFKZDawoh2aFjs/86dwkn74YhNEhr8ZgSzQ+0G2FFmsBKvvVMSvp7DUiRUtwHvm/mHyXi3X44sANTv7+3sDH26XftuDqlQ+lCTbwIgBgPUbH2HC7WxC6V7Xhp40STdHgZyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MW4PR11MB7056.namprd11.prod.outlook.com (2603:10b6:303:21a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Wed, 22 May
 2024 21:24:14 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7611.016; Wed, 22 May 2024
 21:24:14 +0000
Message-ID: <ccd5df99-4d7e-4224-a07e-3897e370b53e@intel.com>
Date: Wed, 22 May 2024 14:24:12 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 14/17] x86/resctrl: Sum monitor data acrss Sub-NUMA
 (SNC) nodes when needed
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Maciej
 Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240515222326.74166-1-tony.luck@intel.com>
 <20240515222326.74166-15-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240515222326.74166-15-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P221CA0029.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::34) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MW4PR11MB7056:EE_
X-MS-Office365-Filtering-Correlation-Id: 62c8e8fb-7492-4510-3365-08dc7aa587b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YXFocksvQ283U1E3WU5kUVg2K21EWjJEcys1VU5PS3pMb3FZSng4amdoaHJT?=
 =?utf-8?B?YkZudFFqWHU3UnlOV1FORW8yZURDeGtEM3dIMEFDYjkrMk1OS01mVzVpTHFh?=
 =?utf-8?B?VGdsKzZYWXhjMTVTOXNESWlkaG9ybXl3cWx1UmdBSFIwYzYvVGR6UU4wUmRx?=
 =?utf-8?B?RUlvemV1aTU4c1N4VEN3eTZ5QjFkZHFhQ1R4cS9CazJvbm1STm1uS0ljakI4?=
 =?utf-8?B?RWc4bjFhemw5QWV3dFhaOVo3RUErbVBwWGxJZzYzbnFSeFFvemRHWmd5Y3pC?=
 =?utf-8?B?dWhqUE5Vc2t0aVczbkRKUkh1NEhMbzkxL3EveHhwOWpWY01LQVpsaituWnN3?=
 =?utf-8?B?bHBqeXo4eXNMOG5ZZXQycDVUSmtyVHIzM1FDa3lBakRpaWd3cmcrcFNiZS9q?=
 =?utf-8?B?TkNKUlJkemcwbFptbjFLcG5xQkN3ZHJ2R05VblpzMmF0eGJZMTExZ2t5cVp2?=
 =?utf-8?B?ZG45a3JKOXFtMUhJaTViN2dZM3pjT1NxaXQ0VWNjSnZFSmJ5T0MvNWJCZktz?=
 =?utf-8?B?U1pyRU1FMGcrdXdRSUF4ejYrYndYZWNwa3diOVFrb3EwU2FYQmVEdjhXZWdL?=
 =?utf-8?B?OElnS1hLZDNVQUJkWHBibmtJeklHUC93YXI1bWR3Z2FLU2pRSy80MnRWVzN3?=
 =?utf-8?B?RUJjNVJCb2xYZUMrbTAzZlJwNVZXT0tRZzFtUlV2RmVHVXlMWU9sSEtKTlBI?=
 =?utf-8?B?T2kyb0lMellUV0d0ZklCQXowUXBTL05adlBEdW9SQVRVZ1ZJUVJnTkNOQjhC?=
 =?utf-8?B?b0p1RzZZWVJoc1VxeWdMVUJ5bSs4REROdFBmK1RNSjZiaUhscW9WZ1FwWngw?=
 =?utf-8?B?QVBpMEdMMXl2YXROTXVhRVlyakR2enlyTGVPaVYyRnlwOEZ3TTRGUmxLWlpl?=
 =?utf-8?B?ODF4eFZod2xzYXB3ZjVvcnM3UFE3Y1d1bHhMOHZWVlRYUVRONTI1YmNuR3g0?=
 =?utf-8?B?cm9qTU50NGUxT2ZqMTNzbzl5YUx0ZlAzVEVabnYyMzNteVZYK3VGdlNnNHU2?=
 =?utf-8?B?a1NKOWF6UXFYeVl6aklWbkpVSjI2cVlWTEViVnhWd3FzR2U2cm95aHpXKzZ5?=
 =?utf-8?B?TmswamRJakt5TXhUUzFCSzdXd1dEOUpVT3FKY2pUazJqUzdabEFsZ1E3eFk4?=
 =?utf-8?B?OXVDQ29ObHFvL05QeG5QNStDcENEcm5MOWxpTmtlK0NWd083cVM5WVVFVC85?=
 =?utf-8?B?V1Voc0l0a0k2U0tmYWxaNGM1TENvZ3I0bDJKa3hJV0dtc2tIeUo3QkthK2la?=
 =?utf-8?B?aTZJOU9ZYXFKUE9sMlhOUi9mUWlRU3VEaUpyRkQrVWVFVExhUGpZaDUvdVFh?=
 =?utf-8?B?a3hQU1A3SWJsTm9RWldFK0Q5V1AzaldXT1NDVHFIMFNzMTJQUmxCZWVud0hQ?=
 =?utf-8?B?Rmc2eVR2YlpaWTVXWUppVWVVT3F5a3o5WUQ1V0c3bExiNSszOGNuNksrRm5O?=
 =?utf-8?B?WmtOeExYNFJrajQweWU0REp5NzlyWCsrMHpxUk1aTXowMzl3ODNTVnB1bHp4?=
 =?utf-8?B?V096Tkl1WDduOTJESXZRb1lGZis4ZlFRRGVWU3o1RHRvQ21Da09aSHEyT0U2?=
 =?utf-8?B?NXVDVGV3WXlhbm1FQlZZa3FMUFk4MFFEV0NJbVJvK2gwSGtScjh2Z1kwWVVR?=
 =?utf-8?B?TlZGMFNKa3JuaENuQzNyN3ptNWFORWVMenVsdFBkcFNDem9XT0dXK3k0Z1Jh?=
 =?utf-8?B?b3JkWVBDMWhVY2kwc3NKNEc1eUN0UU5KOGEzazg5cnFqZGpCb1VFV1hRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?blZVbjdIMEVqcnNCUWNpUmthcTFRQ3gvNHo4OXNZMTNIamQvekVlT2RvdHBD?=
 =?utf-8?B?MkIxVEVFT1FJTVZhMjdnWURiRUVpQnlQc1BKRERUQi9ubWlZbVRXYzVOYlhQ?=
 =?utf-8?B?elFzYVZPMjlwbVdzdDBBMGxtdFlXeWMvbG9HQi93dk41b09wLzlpMVZKcjBO?=
 =?utf-8?B?MW1kNGVVWEZLZlBkeklHaTdUT25rSCthM0NiNCtVck9CVXd3WGgxazZEWnRZ?=
 =?utf-8?B?YnZPTDJRMkl6eGVYeEVJMU56ckN4Z2ZFSlhIb1FWR3c1c25XYmtVVzJhS0hZ?=
 =?utf-8?B?aU42TXhkK3Rpa2pXQTBJelRwRUkzMHQ0L3NCZnFpTVlDZ2VNSFlkQ3UrSmtC?=
 =?utf-8?B?RU1xZzVlb2ZURklHMVBvRjZMOHdnd3JyVkJWOVN4MDZ1aEpiSTNLQURDM1BB?=
 =?utf-8?B?NHZoRUUwbGxuVEFncXI2bkszUVI2dFkrVUpuNHlWcThEWVVHMUNrMkpJUDNx?=
 =?utf-8?B?bG54OWFGQWs0SXZQZmd5ZVVaNUJmVFk2RHpEdERVK1NMRDdWTXlWdGU0ODZS?=
 =?utf-8?B?emRjUmZsVkVTLzhadGhuM1IzUUc4Z2ExRjJQOHg1bXViSjY2bGtYdXQvcmE1?=
 =?utf-8?B?eGpvU21VVTJ0QjRaVklzUmMyOGRlTHc5OExGYkk0VnJud0F2RG5xZFFDQjBN?=
 =?utf-8?B?Q3pOeVJEa3RGRXo3YXdTRWdHNE1waEROZUdpZUV5RElTaG5BbUNjQms5ZmFO?=
 =?utf-8?B?Ty9laUR3SlJ6QThFZCtoTXlFS2Z0aWxlUk96N2o5RGp1b0NIek1VRS83Ulhu?=
 =?utf-8?B?clB5bW4vNlhldXp1TG1zanlJVlJ1b2pjWkRoMFVXaTBKbE5VY0JtTWNzUytX?=
 =?utf-8?B?bHRmZGdEbFlLOEZycGJnWTEzeWtCOGN2V0V1ZWtpV2FXVXRqRWVWVHNBWWF6?=
 =?utf-8?B?c3RsWkw0clVGL3A3OXpvSWt4M1JXbHRUaGlPQnpmRGgzcHRFL3JRS2JVQWhN?=
 =?utf-8?B?RXlVU1B6NjQva2ZPbnpYejJ6RHVUd0R5RWdjT1NLWmpCVXYvd2xEbDIwV1E0?=
 =?utf-8?B?WXJsZFhWR3d0NlBHTzFXcG5CTHRyUDFPNGFVbnI0QWhaUTh1U0YzT0pxcitT?=
 =?utf-8?B?WkJFTDlleHNocjlGVHBjbU5JNUEvdU14WGozWEhIY1RXZUlqNnRQWWZNSW1n?=
 =?utf-8?B?bWtRMXpzZllsa1JBUVlvdi8yTkd0alJxU0RML0xYZTRKMWFVbnA5VkFVbEpR?=
 =?utf-8?B?Mk1FaFdxTGhEdGJQckpTU2Q3NWF0TmROMUIzcXFWSmJwc3R2QjV5OEF2VlBJ?=
 =?utf-8?B?ajhLTmVtb3NWZDdNVWtabnRWQjRiZ2R3dVNxMjl5L3JDdmtENG4yaU1YMzV5?=
 =?utf-8?B?dU1SVzA1SGpPRmJtcStrMjN1Y3ltWTlSQ2xDcFJjV2ZYZmRRZ0YvQ2RTOEkz?=
 =?utf-8?B?U0VJZmgvZmRPc2JIbzVDbUQ4OTJBQW05bWlILzVJSVpNajJ3aksySVhOcmZU?=
 =?utf-8?B?SVNwVWtuK20wVDErUXRBRDlRR1hWN0xrd3lacjg4Z2lzdTRUbFlva3ZFckQz?=
 =?utf-8?B?MlQ1STNsMmlWZUVvZEpvaE9yalNlWXI5cThWa1loRTY2VjZDQUVBUFN2cEJn?=
 =?utf-8?B?cTVrQzJhL2FaaFMrb0pJbUtPMmcwUnYxbHZCbE1tdEU1SkM0ZTZFQXNBS1FK?=
 =?utf-8?B?WWZKUjRSb012MitiOG9WY0FZNG8xcmh5YkFia3IyOWlKNFVxYzZLYktxT0dK?=
 =?utf-8?B?cU9mak9oc3doVzFSMTFSeFJ0Lyt2RTJoMlZzVGtsckJFYjZ3QkRTMFVhc0Nu?=
 =?utf-8?B?K0FUcldPVjhCdDgzOFBEUXpGVm44T1B6V3VaK243a1Y2VE1KL2VVejg1YXVV?=
 =?utf-8?B?c1p4ZHErQnpXQ1lxQVFmaERIU0pqcVZ2ZTV6WkJpYVl3TEVjbFV1OUdBUUU1?=
 =?utf-8?B?WnNxY1haODZvMUNhN2doZjRKZDM1bXVTaGo4TU0xUEMzVGJBQ0d1K3l6UHRk?=
 =?utf-8?B?Q0ZFQnZOOGgraDZzS3lPRy9QOUdlQlVDbnF0bVRNTE91ejFORjdCWU94U3Ew?=
 =?utf-8?B?RWVhYnc4K21yV2tVZDdQclpIQmpwYWFhd05BUFR3MDlUOXhCTlZxZ0FEcEg0?=
 =?utf-8?B?dTdndHBhSk90cHBFQ3hVR2NIM0lubE1QajNBeUtrL1ZCOWtXOXBHN0U5MTNm?=
 =?utf-8?B?Q080UDFRdWZRVzFEWTZGMCttZ3kzb0hWdWxnTG5vQUxvRE1yNlA3Z1VmRCtH?=
 =?utf-8?B?Vmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 62c8e8fb-7492-4510-3365-08dc7aa587b8
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 21:24:14.7366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CTrlnYBinaEn7vFOEuM6DsbApkreE7wWMNx0vBiYBSt9OE08oS5NdnMZuHCiq7DWyBfA169uF/4UPC0Djz3AMqiY6JAfEAIyocvfK1EVZyQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7056
X-OriginatorOrg: intel.com

Hi Tony,

shortlog: acrss -> across?

On 5/15/2024 3:23 PM, Tony Luck wrote:
> When the sumdomains fields is set in the rmid_read structure, walk
> the list of domains in this resource to find all that share an L3
> cache id (rr->display_id).

"L3 cache id" vs "monitor display scope"?

> 
> Adjust the RMID value based on which SNC domain is being accessed.

Thinking generously this changelog contains two brief descriptions of code
snippets. There is no context or explanation of what the goal of this change
is and why it chooses to implement things the way it does ... implementations
that definitely needs some explanation.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/ctrlmondata.c | 20 +++++++++++---
>  arch/x86/kernel/cpu/resctrl/monitor.c     | 33 ++++++++++++++++++++++-
>  2 files changed, 48 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> index 3b9383612c35..7ab788d47ad3 100644
> --- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> +++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> @@ -575,15 +575,27 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>  	resid = md.u.rid;
>  	domid = md.u.domid;
>  	evtid = md.u.evtid;
> -
> +	rr.sumdomains = md.u.sum;
>  	r = &rdt_resources_all[resid].r_resctrl;
> -	hdr = rdt_find_domain(&r->mon_domains, domid, NULL);
> -	if (!hdr || WARN_ON_ONCE(hdr->type != RESCTRL_MON_DOMAIN)) {
> +
> +	if (rr.sumdomains) {
> +		rr.display_id = domid;
> +		list_for_each_entry(d, &r->mon_domains, hdr.list) {
> +			if (d->display_id == domid)
> +				goto got_domain;
> +		}
>  		ret = -ENOENT;
>  		goto out;
> +	} else {
> +		hdr = rdt_find_domain(&r->mon_domains, domid, NULL);
> +		if (!hdr || WARN_ON_ONCE(hdr->type != RESCTRL_MON_DOMAIN)) {
> +			ret = -ENOENT;
> +			goto out;
> +		}
> +		d = container_of(hdr, struct rdt_mon_domain, hdr);
>  	}
> -	d = container_of(hdr, struct rdt_mon_domain, hdr);
>  
> +got_domain:
>  	mon_event_read(&rr, r, d, rdtgrp, evtid, false);

This looks more like "wedging things until it works". In the "sumdomains" case
it just picks the first matching domain without any explanation why it would
be ok. The only reason why mon_event_read() needs the domain is so that
it can use it to determine which CPUs it should read the counters from and it looks
like this code is written to take advantage of just that. It is a hack based on
knowledge of internals of mon_event_read() to just get the reader to run on a
CPU that works for SNC where another quirk awaits to override the domain
when the counter is _actually_ read so that it can get the correct architectural
state.

I was expecting here to at least see some documentation/comments
to explain why the code behaves the way it is. Optimistically it can
be documented as an "optimization" for the sumdomains case that is only
used by SNC where it is ok to read counters from any domain in the
"monitor display scope".

Apart from the documentation I do not think this code should wedge itself
in like this. 

To make it obvious what this code does I think the non-SNC case should
set rr.d and mon_event_read() should take a CPU mask as parameter
instead of a struct rdt_domain. This means that in SNC case rr.d will be
NULL and make the code flow more obvious.

>  
>  	if (rr.err == -EIO)
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index 0f66825a1ac9..668d2fdf58cd 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -546,7 +546,7 @@ static struct mbm_state *get_mbm_state(struct rdt_mon_domain *d, u32 closid,
>  	}
>  }
>  
> -static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
> +static int ___mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>  {
>  	struct mbm_state *m;
>  	u64 tval = 0;
> @@ -569,6 +569,37 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>  	return 0;
>  }
>  
> +static u32 get_node_rmid(struct rdt_resource *r, struct rdt_mon_domain *d, u32 rmid)
> +{
> +	int cpu = cpumask_any(&d->hdr.cpu_mask);
> +
> +	return rmid + (cpu_to_node(cpu) % snc_nodes_per_l3_cache) * r->num_rmid;

Is this missing a "if (snc_nodes_per_l3_cache > 1)" ?

I do not think this belongs in resctrl fs code though. Should this algorithm be forced
on all architectures? It seems more appropriate for the arch specific code.

> +}
> +
> +static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
> +{
> +	struct rdt_mon_domain *d;
> +	u32 node_rmid;
> +	int ret = 0;
> +
> +	if (!rr->sumdomains) {
> +		node_rmid = get_node_rmid(rr->r, rr->d, rmid);
> +		return ___mon_event_count(closid, node_rmid, rr);
> +	}
> +

/*
 * rr->sumdomains is only set by SNC mode where the event
 * counters of a monitoring domain can be read from a CPU belonging
 * to a different monitoring domain that shares the same monitoring
 * display domain. Optimize counter reads when needing to sum the
 * values by reading the counter for several domains from
 * the same CPU instead of sending IPI to one CPU of each monitoring
 * domain.
 */

Please feel free to improve, please do help folks trying to understand
what this code does.

> +	list_for_each_entry(d, &rr->r->mon_domains, hdr.list) {
> +		if (d->display_id != rr->display_id)
> +			continue;
> +		rr->d = d;
> +		node_rmid = get_node_rmid(rr->r, d, rmid);
> +		ret = ___mon_event_count(closid, node_rmid, rr);
> +		if (ret)
> +			break;
> +	}
> +
> +	return ret;
> +}
> +
>  /*
>   * mbm_bw_count() - Update bw count from values previously read by
>   *		    __mon_event_count().

Reinette
