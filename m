Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.17
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792530114;
	b=SCn4QJsMpaY5sWljByS9ifmDCW1NYHxFxYKV3nWim36lNtaQKMmT1KZ+03zZPMHsAURo
	 iku4MzYB35tM3cPUuHW3VbLtKY7Errsk4XPe4wi8IKSbaa4oQMvVcS0Eh57Cl9OavN5kO
	 FQ6brHg6wRUVG9hRjHarMpdqhq8xPzYhePL8Pc5nw9XkMLSckgKThKlh9o6boPhIM1ST+
	 fW7TQK2uDNdg8n70+JYJkWMHtlNM8oq6PWJn7CWyd28QsNHH2Kt8KqeJWwHJLveoAlS3/
	 lAzj6WSniPQGX3PsEXV1+DzhxPGnUJ8T1Rz3vNtYPYYMQzW8Co3CnHV+TuyxrTN8BMw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792530114;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Message-ID:Date:User-Agent:Subject:To:CC:
	 References:From:Content-Language:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=0nPDO8yW2jkaxCTkNtR9glDZrVjVaHp67JVW0AvfGJk=;
	b=F/vOA5Ocm7eHL7khnymgxwV4wbYer5qBTuxhycRnIaw+BFS7fW3z8J+gFXgbV5yul1f2
	 4QnrISfHraRcmNRluo60+LXHovRjT/pA4xKng3bevXJDyks6/taToFOopBYl9lt+aYAG9
	 +7wSYMHlnEIUDENDaEYusslsNdRTCFybt8GGICr0K4s6Z7WKjZd1RK/QkyK/LNoGBVgAf
	 YXzDlomEwkehd4wsp2nrBVWujZZywdXyt7ozu4VroauZCqhHk6EU0MOXTVIlu7FQtUMdr
	 jImhw6WcGm2NLtob257ShXnawuk28sGN+4yZS2MPP0ACReDpHOJbFI+y7X0GFSwIKVQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=SD5NM86Y;
	arc=fail smtp.remote-ip=198.175.65.17
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E91606A31A
	for <patches@lists.linux.dev>; Tue, 20 Oct 2026 21:01:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77E91606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=SD5NM86Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792530113; x=1824066113;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AjPhiYWJWakbeN9Ic9jkFok7n50kqmDHfCfG/Q/kcxc=;
  b=SD5NM86YbbXwSG/drxA4QpqwPvLyiMoX156mcL7OSdcrNhuxfhLcOi5C
   shZ4RB/ccm/l8UrS6vd/cwNJ8+qmEhGGvMwBQiB9ORSkVvase+8Lb7vxS
   6HsPRY41fT4n5VdAidrtpgZPwV8S6U3a3vwP/7E+VOWqN7OZKuZnrMajd
   KhHKvvmoK1v0VxEx8/dIr69I3JEP1kdsBXtPJ1vzQ1XJPBdytQKRJ3KF5
   zUKUy8XjG8SBGrK68Cg6v3WpEE/0+MoHYPdK5ccY9wR9t5I2rBT0p8cCj
   YtN8gZ5xu9WO266zB+eKaN9YkCwpluYIES9i0hwMX6qEms/NXFqHSEg0i
   A==;
X-CSE-ConnectionGUID: ou0MIz1nQq2z9rfn1UghoA==
X-CSE-MsgGUID: ask+duM6RDy4MMjWDMtywQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11941"; a="1260245"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1260245"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2026 14:01:52 -0700
X-CSE-ConnectionGUID: Oqg61nCjTFW561oJOWvhoQ==
X-CSE-MsgGUID: UuGCbaccTae/BBiYhd6w1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="3249145"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2026 14:01:51 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 20 Oct 2026 14:01:50 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Tue, 20 Oct 2026 14:01:50 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.53) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 20 Oct 2026 14:01:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pI1tn7+lHI8+3IZQaaDuYUELVaHZ3rxf9nskV4VoeA357xWcWIz9ajBfknCM1MfwWPGnO6nxu36FtreX4oWIz20O2gblDuc+bvItks7l31EdLEUQi6FTxLC4gc3EUE2scwGdqnzotgyUOmzsp+ZgZx9MXneyISRhm+TzMsrq38rwPEyBdLSCU8Uj9DxxslQ3iYsGfzz8eARMcl/6COPjl/Ql21oZxXg4HroM2QMyGqiDer3vmdBMZOw/bFKMyaGFqJMKw130v/5TEvkVgK16zvk7irW0lBaFlRPwgHONZ829/mtGVWyENAsWC3VshKef/TzNMKBeyW3u7wHX9rYYXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0nPDO8yW2jkaxCTkNtR9glDZrVjVaHp67JVW0AvfGJk=;
 b=C7JXRZcYoBZgDAjyaELkGrL/sNW2kXChfLAKjbscQHM7vtFRc/OIoKdrAGZkFPtxepR0WpcD69l1mbyDkgOM4xmkH6vAyLGSKo5Uu49pWNgFomtg7YW2h5ASxHPABHGkvVFHE5Hub/sXbKhIxRVUMoSFFmvk/rqta5hLEAKEO5p5T2cAjAMw5f4gZt8pOm87ogsFmq8JrUE0ZdiWUjpU+l7NBpbCtnzqOsr7urOpa0vzpSBVbScC14YXopOWrJCAH0dLOZv00+p8sQtjo3YCQecC3/6INZugeetDw+10oinr1Su1kNGBQ3EgmDn+6rXwU3aSWgNu0Qn1OVIpUIZNqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by CY5PR11MB6464.namprd11.prod.outlook.com (2603:10b6:930:30::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Tue, 20 Oct
 2026 21:01:35 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%6]) with mapi id 15.21.0522.017; Tue, 20 Oct 2026
 21:01:34 +0000
Message-ID: <fc6d7f3e-1f14-4387-8c48-f3c065aec4da@intel.com>
Date: Tue, 20 Oct 2026 14:01:32 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] x86,fs/resctrl: Move MSR_IA32_L{2,3}_QOS_CFG scope
 property to x86 resource
To: Chen Yu <yu.c.chen@intel.com>
CC: Chen Yu <chen.yu@linux.dev>, <tony.luck@intel.com>, <ben.horgan@arm.com>,
	<james.morse@arm.com>, <Dave.Martin@arm.com>, <babu.moger@amd.com>,
	<bp@alien8.de>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <fustini@kernel.org>,
	<fenghuay@nvidia.com>, <peternewman@google.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1791406459.git.reinette.chatre@intel.com>
 <c873c62e78f335df6f7b99cb0cf0ccbcdd62b09e.1791406459.git.reinette.chatre@intel.com>
 <atUEpF4pd4YBncbL@three-body>
 <f054255d-f34a-4f8d-87e1-e7d296bef93f@intel.com>
 <atcEoIz4kkQFyEgx@chenyu-dev>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <atcEoIz4kkQFyEgx@chenyu-dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:303:8f::32) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|CY5PR11MB6464:EE_
X-MS-Office365-Filtering-Correlation-Id: 51fbf143-c6e9-4570-812a-08df2eed5323
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|6133799003|18002099003|22082099003|10067099003|4143699003|261009223027099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: EKTcj85SbXlC8h+oaVE/zoaIRRPd/mT+b3+3DMarOYE07pPcJGv5lstaBW8KV+/DPT2Ndf2ykPnPjG13HDyBAaKCwx3ihJ07ThbA3QmPmbBpjDe7T18/5Dqew+A1ojQx90FtszrIbxbK+bifxBciPmF8/Qw0Ag4z4+odFGuxzv4YAD5PCN+n5ZtK5DOe7wZ/4LpV8e71509FSDelbL4f9uwPkjCqXjqfoK9QCsKmS7322vootA6tdO5LSh7URIT6xwR9lxs3GbfgUFYNazcUl5HAqWpIkWyS+kpst0lHgllW3BqNhdReNfHp115hLXFlMqEA+5GEeR02W5UNfNneiNQAIzHFUIUF6LGaNQzbYiRJMKJ0e/TlNyFueet2ZbSqATtKVmYsMcu315EMQ5Che+Yi6qw2hOoOTUsSunnBlN4W1vq+apzzbDNvaKG5r/pf5J7H6BSEEthlQqLKpETEhSpAj3QNEIxWdJO+Pk+HyTc0kkyZuEytsPkFgsEzITSwrTdpHDHEXQMVVRaNsQ+gzLb7UyGtCQWSUcR87/C2VfxVombzS+Dm7aUX1lcvOSTt2H5lNo7xpKhscviC/eScocRGxmxGxk859FH2PYGgv6uBUWllwNjJeZp/S0BJ34LsH4kCbH7m7/2CTgiEGutKXL6KbVHZG8PxcGckMXK7lR0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(6133799003)(18002099003)(22082099003)(10067099003)(4143699003)(261009223027099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NUlCWEU4WUg0dWJzUVlVMmliVXUxbGt3ekhjZGVCMDYvQWN3aWw4R3dCZ0dV?=
 =?utf-8?B?TFQwVmZUYlFhSlRyR05TcHF2UWptSXBjRjZCZ3llMzh1YkZSVGNWSHJudVFa?=
 =?utf-8?B?M3ZwcWxjWTdVRlVEQXZIWWhDNVExQlM0c2xXbkg4Skxub2crdEpxUVJMTCt2?=
 =?utf-8?B?dnA5MTB1T2FNNmFrUUpaN3pHajIweHJEUmtPd0ZISzlMMFYwRUpicXJlem5M?=
 =?utf-8?B?YnlLUHNFWEhiZ29SUi9ES3dBNGVLSmxmajV5MkZyWkdjVzZSZkZJblZqUWNR?=
 =?utf-8?B?OVpTcVhocGJwL2Noc3d3OG1mZnZZRzlhbmFEeWx4MTJGQ25GK01VaUVkSUFp?=
 =?utf-8?B?Y3hGRFBzbitudDBlNkt5SDVqZ2xPUU54VXVGQU5yUHg3T3FJZGt3OWNkTDBs?=
 =?utf-8?B?Z010TlJFZlJrZ1AzaVRZemMreEk1dXpaZFc4Sm55Qjg4alBDWWc1YW1nb0Fo?=
 =?utf-8?B?cVFJdGdxbnIxRUxkYWxZUld3cTdBS09lQ3R4TXpmTldTUVRabC90TitscE1v?=
 =?utf-8?B?cnN0T3dXR2FBSHNiS2dlcXJZWTU5SlVtZlhCSlBmVUxqZEYvL1BaRmlkNUE3?=
 =?utf-8?B?TzdZZ2ZaYWk2Vmc3VDQyRnFhUTlON0ViZkQ1blRWV0V3WmIvYXI3ZXFQMmdU?=
 =?utf-8?B?K0tvajlxelJqVzRQTmt1cHVOUnBJVjNzN29RenFjTmJGNnZuMWQ3a0RWUURT?=
 =?utf-8?B?RVBiSjd3TXRVOWhZbEh4OEh1S3VsV3ZNNG9GeXVZbktoQSszTy94akFna0h2?=
 =?utf-8?B?RmJDZ2xBSG9Yc2d0K1F0QUlHaDdBVjNxcXhMWHFHSVRaNlcrTWxrSmszSGVj?=
 =?utf-8?B?WE5oeERWejlmK3AwOUVWb0RhMWJocUpCK3JKTDF0TktCTUJFOXVKdGNpdERi?=
 =?utf-8?B?SmxUcHcyQ3N5L1BHaW5NMGdMbFpjNDJoLzBnRDcrNnhaMjNPcm9ZS05iUmUx?=
 =?utf-8?B?a3R3TEsyVExpQ202bEZyRjJBV3puY09zMkkxLy93dG1WbGtjUkJsWHIyUEdQ?=
 =?utf-8?B?bm9seGZPZWNpd0dxdEl6RVJUWWdoc1RFKzZXU2xuNkcwb2g0NVMzaXVORGRr?=
 =?utf-8?B?S1p5UVNrVFhwVUZYOE85VmpiT1JrSGc1RHJsSUZNK0YwRjAvVGIzb0VvU2Y4?=
 =?utf-8?B?UHJPSWlGYzdjV2h5YU5HS3pIZ2ZUU0tXK3RERmk3enJOSEdWb2JOZDZxL3VW?=
 =?utf-8?B?bU04K2FrdmFXYUFacHJyNThGbFkyWDQ3NTc2WXpYQXNjVEtHdXNrSVgzM2tk?=
 =?utf-8?B?OWVQUXR2aVYySzFSdGZkNXhveXhzVG4rSHB5d3V5MXV1MjhYay9VVUk1OEc3?=
 =?utf-8?B?WmM4bytSOHdyd2lZMk1ubDhjS2xZUWdzcnJvWStHUXpWandHZE9LR042d0xn?=
 =?utf-8?B?TzE2bnkrMUZhNHFnSW85S2tURzdrU1dHRnhhMHI3TSs2M1o4TG9mNXhDVlpZ?=
 =?utf-8?B?SzFGOUlPbmJCc3NvdHUzZnE4cFIzRWx6YW1YQ2Y0TUdnMXlkZHEweEU2dHE0?=
 =?utf-8?B?aUw3R0l6QW1BR1RRUHhxRVBDV2ZSSkgyYlJJM3p2TlVaenpOb3Z0MTRRMCtz?=
 =?utf-8?B?OUVoZ21ObFVnMVptcnNuclFPTFRxSWdYa1NuOHdLREZ6OFkrZ0FnSllxMFdh?=
 =?utf-8?B?dEU0djF0bHl0SE9rbVNGdlNWZEl3WDJKcTRYSy95ZWZZUUw4MktIL29WSFJK?=
 =?utf-8?B?WjRoTGN1RTUzTzJUR0I2ZDFlcTZzYzJqUjkxWWFiRGZpVHV4UFVpSGRoaEZn?=
 =?utf-8?B?OTFXTy9nR0JwMjJRQXFUb1lJbVlTZllGcDZDSmhTRk5kRnNDQzJDY01IWGw2?=
 =?utf-8?B?dUFBSWZHdGJ2OWVFSHE4aTdBZHFMOXI2WW5makIwbDhBS1F3OXFLZ3QvR2do?=
 =?utf-8?B?Z3FuRGFkTWFUUEpGVkE4VjJOZ2lLd3UxZzBuY25CRXNGbjVwTDg3VTlNekJv?=
 =?utf-8?B?Y3U5bDE1Sk1QdkRxYUxGdGdOckEwMFpXbXNkdDBva1o0Vmt1MUdYczVpRUJr?=
 =?utf-8?B?TU5HMmxXbHIxRWZWSGdwM1hGUjBMTGVUcCtvdkthVTlwaHlmeDQxSWQwdHRC?=
 =?utf-8?B?S2JBVFFPRmI2V3hBck9BUHNBd1RCUEpNMnFyYTgrTGxuZ2paZlZkM2xnZi90?=
 =?utf-8?B?NjRtYkdVc1FGRVRwbFQya1RSZFNrNFFDT2tzd015YWV1WG5ubERYS2JpUVd3?=
 =?utf-8?B?YmtxVVkvSHIvcHBwd3RTOGRkOUhZc2xweDVjbTNEbnVsREx4VjlWSngvdUg1?=
 =?utf-8?B?NmdjT3ZwTjYzSEJTYTE1cWhIUFVoTklxRytXT0VmNzBLTUs5QWFPZlM4Qm5v?=
 =?utf-8?B?ajg4cUFvd0hSeVhJbzVKZTdrYmx2Mm5DTnljdlZxeEVQQWh6VlBsbFBXWUpK?=
 =?utf-8?Q?aCr0YKzp6/nI+wbY=3D?=
X-Exchange-RoutingPolicyChecked: cVSmr9xb/eKu7dCVvsUIwIbF8PDwSFDZ5ALauiFc1c9UvkRQnBf6f4jArfINYRr4Ycv68hr+JuGIDk6FZqV9FGcnaMDqR2Hb4gYH0Qbux8GAsLkyICIz4HCTEyBe2XAabrlcBtVpLQK9mwFRI+hFhgdFccclAvNro4E44MAjLCTSE+4QxeTrf8jPIG4k0br6CQitBI/FTU7Xf6fiu2dq6mGZaAZ13/IikbszO6hp0tW1Tk6wMXxgK4k7ZJGGLijmS/YB8SYDZRegkEa2Ly099YiRI8P2VJy4fmqGMAjUw5vmStqYM8pRwvgP173/S1PQyzvK2UVUjLKVaUpKp4tymQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 51fbf143-c6e9-4570-812a-08df2eed5323
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 21:01:34.8577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XXPuUkBwENX85S8BccVoCRyHpdH00dVh7gV3BgJD0Fe4EBWc5QCkHR6iCMoqyJ5HO77DgFQgsy6STDccoe+lpNetNrLii88SFmMhluMfZYU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6464
X-OriginatorOrg: intel.com

Hi Chenyu,

On 10/19/26 11:05 PM, Chen Yu wrote:
> On Mon, Oct 19, 2026 at 04:06:35PM -0700, Reinette Chatre wrote:
>> On 10/18/26 10:40 AM, Chen Yu wrote:
>>> On Wed, Oct 07, 2026 at 02:06:45PM -0700, Reinette Chatre wrote:

...

>>>> @@ -140,6 +143,7 @@ struct rdt_hw_resource {
>>>>  	unsigned int		mon_scale;
>>>>  	unsigned int		mbm_width;
>>>>  	bool			cdp_enabled;
>>>> +	bool			qos_cfg_has_cpu_scope;
>>>>  	bool			mbm_cntr_assign_enabled;
>>>>  	bool			sdciae_enabled;
>>>>  };
>>>
>>> It seems that some flags are in resource scope, while others are in the controller's scope,
>>> cache's flags are in the resource scope, MB's flags are in controller's scope, for example "linear".
>>
>> The goal of this change is to move this information into the only (x86) architectural driver where it
>> is relevant.
>>
>> These "flags" are different in a couple of ways:
>> a) qos_cfg_has_cpu_scope is specific to x86 architecture (thus located in struct rdt_hw_resource of
>>    x86 driver, not struct rdt_resource belonging to resctrl fs) - this information is not exposed
>>    to user space nor is it of use to resctrl filesystem. This is just information internal to
>>    architecture whether the x86 MSR has CPU or domain scope to accommodate this difference between
>>    AMD and Intel.
>> b) the MB controller flags like scalar and linear are associated with the controller,
>>    exposed to user space, and managed by resctrl filesystem.
>>
> 
> I see, the hardware-specific attributes/indicators could be in the hardware resource
> scope(and usually they are global settings), while the MB controller's flag is not hardware
> specific, and they are not global settings.
> 
>> To me this qos_cfg_has_cpu_scope flag is closer to the architectural support you are working on
>> that contains within x86 architecture driver the decision whether it should use ACPI or MSR than
>> it is to control flags.
>>
> 
> It seems to be a little different in the control_mode case, currently control_mode is in the
> struct rdt_resource, but its callback resctrl_arch_control_mode_set() is x86 architecture driver
> specific.

Yes, this is different from control mode. I was actually referring to the CMT ERDT enabling
you are working on where the decision whether to use MMIO as discovered via ACPI or MSR is internal
to x86 driver.

...

>>  
>>> Review-by: Chen Yu <yu.c.chen@intel.com>
>> Thanks, but I do not think we have the same view of this change. Please let me know if you
>> still feel this patch is ok after this discussion.
>>
> 
> Yes, thanks for the detailed explanation. This patch is OK with me.
Thank you very much.

Reinette

