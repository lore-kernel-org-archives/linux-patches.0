Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B457A266B72
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 22:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757456014; cv=fail; b=Q0gu7k05FUz5V6JEBa1fLbgGglru/s1pyGX8B6yQ5HJVrSfXaVBQ8vqUFo3Ciyx1IQq+rUNOHEe6nWMq8XVogV9ppiyqg136roLdvDFZIpzNopBzAtPnuNYLqx8ypQkhXCm+wejy3iDbOgF3LhExGSDfeG4LhsajO8+jwBEfEKM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757456014; c=relaxed/simple;
	bh=2JMEavz0YOGvSwpI653OODirSa3MuMVOneR2Pn5MwgY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YFpITG8B/ziVuJdUXMLsWiPWyy2n5eQiF0l/sT04sRqlBU0kkMoLSG1mfdcBW+xn4ExZbt4OnXs6kZrE7dAUxtCiVEBAydV/Tc8fH43bw9gDa1SPTtNwhckPflNvC8e7lPvJAh82lbxZGFcFnSQ18yNyzR+MO8xZfGFg3Jqw+iU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MrttD2Kg; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MrttD2Kg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757456013; x=1788992013;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2JMEavz0YOGvSwpI653OODirSa3MuMVOneR2Pn5MwgY=;
  b=MrttD2KgfTcvwqnGMMlhkeNkaw69xiyGklLS09i/opjM5kZXEkIAnwXc
   vNq6tdfBXeQuLMT6okFze05FKGGP0wL70X4o7qOO+st+gHExBq1nXC/+B
   DUAnvZvHYBO3pWuY4IIrPckSD+Pds1S2ixoLV3mykzEb/N8n9BnYZ437k
   PBQPJqSVPOLThNx0O99wUVx2T/duLjfQmoVwLKmtaM7wgyvXvdLDm6IdU
   tV2pNn9vKE2zIPbIYapfTb2H4x0c//NxkAYY8Gx4t7KlgFvSPSB/n1BT6
   kDxB5fHPwyqxGwfSk8tGRaL3QTBM8Oa+06ls69k8Hk/yCR1TC6zMALzLe
   w==;
X-CSE-ConnectionGUID: InN6nXg/Qnesta+8/9J33A==
X-CSE-MsgGUID: N/z3av7XRhKTu06xJfaAOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="59900124"
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="59900124"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 15:13:19 -0700
X-CSE-ConnectionGUID: eMR9XAMtQayUN5iAhCJxWg==
X-CSE-MsgGUID: OUuMg3ijSaOC+J/tvL2xwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="204198590"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 15:13:14 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 15:13:13 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 9 Sep 2025 15:13:13 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.68)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 15:13:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SzoFJoXNOrfEZuhx+B+mm6yZn2xPuRIbmf0nIU82DmsHixMX1FAULgkX5o9ARlvG2Nj5qm31/Wwod+gYpBFELoB6gdTpVG+EjIGy//zUOVamr3PcwxQ5Tl6Tc29oPMWxWcsjSUP/GmkuZDNtwD/qxN1pZxT/Rz+JzYLcdKhLAQgbr85neLjJYvbTRwr7QXpv5XxlUXoay+ZfkrZHxXvK4C7qSvt3VvL/JdGo3sRutFe1QckuQoHRQu0XF5V2pVo1FrGyihM77iZaRAe6UNqvJSQTHMQ3xKMS4fLofkU0ErYIFITg4p+1vPp1dm5t0j/AiT/vUmXwff/lvzIWWedevA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DAJWp71PJDKtxKXwZdIta9GiLIgG+Lvyj4XQC0GgAjw=;
 b=CbS1HGtVhanpEIx3o8Kp78Pjzxkrj0Cip8hjOqFsUH5tMtu03zHjaHPsQk5x0nZekrNnpEv33CzXWSVes2VMxpLA2vXoAu4UDtnIfbl6zJToNYN84MVCjQq3CO6l+Qpp3xNlGIYmfhTPGZGZRFNllAZIwNN5elpxo4CqNBLKnBFSUoLS3jXUXSPgPCPHYJGZPd1Hfmw8lGJpvLdj9k/+30OdTWRHivEXd5hPbZ5lG8Op4F4HsGfnaCyelZsfzcPIB8+tKJdtGupTS3CrE5o6t1wH54xm4tca5cOLtA1HRjFaKsrIDogxAb++XEP3BVlSrWYThho+yuhM0yri5e6c9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CO1PR11MB4836.namprd11.prod.outlook.com (2603:10b6:303:9d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 22:13:12 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 22:13:12 +0000
Message-ID: <e1b5c213-22cd-4aca-90fd-c8d97e2ad66f@intel.com>
Date: Tue, 9 Sep 2025 15:13:10 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 14/31] x86,fs/resctrl: Support binary fixed point event
 counters
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250829193346.31565-1-tony.luck@intel.com>
 <20250829193346.31565-15-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250829193346.31565-15-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0327.namprd04.prod.outlook.com
 (2603:10b6:303:82::32) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CO1PR11MB4836:EE_
X-MS-Office365-Filtering-Correlation-Id: b1f3223f-291c-4594-eaa0-08ddefee10b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Q1RGSFFYTWIzYlRnNUFvVnBmMWtpa0ExYWcvckl1SElhbUJVaVdLYjBWejVV?=
 =?utf-8?B?Y1d4Q09RSks0TnExVCtmVXVNVjJoY1dWOFVsTU4zVjUxS1J1cDlzS1F2cG5z?=
 =?utf-8?B?RjE2c3lkZ1I0cTJGZnhheW9CR3BPdDlrSTZVS2ttaTZsN0tyUmQwcndHOW1l?=
 =?utf-8?B?K1JqWTFURGhaK3dpWDRNbUJGakFiMUJDSXNVSVROMzJBTjFvTGxjSmxUa1cz?=
 =?utf-8?B?aG1aY0lqTzhhL1JEVWwxbzVYY1VxOTBPcFJaUU82U2hXa1hSZU1reW5aOEdq?=
 =?utf-8?B?MmxBSU1pUlJ1L29qQU04UEhuZ3pIYmVKN3ZIOGlZci96aG9hL0taKzRjVm1W?=
 =?utf-8?B?Mk1ReGlZbGVRaVBBc1ZkS2ZZQS96RzZ3K3RQdFE0SHUzSXhMa0JHUEZxZFkw?=
 =?utf-8?B?K0NSZGNwRDRPUDdKUCtVdnEvOU5TeFRvZ2FXK1I3MXFFQ3FCRjNMcHlBVERL?=
 =?utf-8?B?WlBkaVF3emxlaGN5NVQyUDZEM1h5ZFZKUXppMHpKUUJKR0ZyRWd1ZUJFbkdn?=
 =?utf-8?B?aVBZSUVZUkNnczE4ejl2b0RiK0JFc3I0bjhqYnlnMDFneVYzalduditGQUxt?=
 =?utf-8?B?ZCtDWHRrQWIzWHgvRW9HSlJIamZFYUx3UngxR3FBZ2hvM3l4WlhHSC9RWFBP?=
 =?utf-8?B?Um9yQ25NVXZjbDM4L0p0NVgwNHgzZ2pza21mamJOQ3AwQnpuZ3NtRzA3YzFx?=
 =?utf-8?B?ODNVUktnNXRZRkJrWk5JTnZWdkY1STJNSDM5ZzZONVVPbzcwa3Zrald2ZGly?=
 =?utf-8?B?T2h6NDR3cWYvZDdMYjNRRjVqT0hobDBOaVFxVnMyVlk3OWxrVHJCa01HZ3dC?=
 =?utf-8?B?clRxYlJ4bGNMc3ZYTEp5N3ZJY2xHUjB3T3dVdTloMnMvY2lDeStJaWhjT0lr?=
 =?utf-8?B?MnNCVlY2ZnkyZ05LQWxTRlRSNTFLN2M2OXVaWVFmTENRdm9MNStuc1dtdnlG?=
 =?utf-8?B?ckw1OEdlVkl4VGxtV1FGZ2MzUWZWOEI1VGtmZFFGcE1HWnZ2c1plQ3NIOEg1?=
 =?utf-8?B?TVpHa2xsUS8zdFZFbHNZZXdkU3Y3NkpuVEFhNTE4L1BGRG1QUTVoeDZIV2lt?=
 =?utf-8?B?cnNyOGxaNExkYXZvOElSNml2TTN0cHpqZjhUb3g1OEt3TEI2YkNYMFBYT2RU?=
 =?utf-8?B?Y2FXZUU0WUdZb0w0Um9nZitKbmxYTVlURXpBT21qOVdheGVJV2JLNit3Rmli?=
 =?utf-8?B?N2plWFAzV2IwZWE3RjF0UFl3bzVMNVcxYzBMNjBKQTdSeFNSSGk4cGEwYkk1?=
 =?utf-8?B?dzJKSVZsMHdnZnQ1REorekYrR3BidzlYV0pkZVdGTGpvY0Uwd3FSZHdZaHhK?=
 =?utf-8?B?RUMvWDhaeHQ0YSsyN2NMeUREL3UwdkhpY1JEeDkxcFJuamJIUlZlRHVYcHlt?=
 =?utf-8?B?NENuVVU2d052aC9icUdheTZFV0hUVXFtY2ZRZ3B2OEhKMjlnSW5MSlRMWndP?=
 =?utf-8?B?VHZuZlVaZWhsbDZndHl5SmZoK1ZDVXRXZG9FYTdHMEsxc0NYQWhDR1dRZEpi?=
 =?utf-8?B?VFduS0xGZVVETWxNTnpWQWJscU0xSThKenovNnl4bUp2Rk9CZVNwajUxZmxu?=
 =?utf-8?B?ZjdhQjdBUXVPWWVEaktmV3k4L0FSRWUycnNrVWtKM0Q1ZlhmdFVWWEpUY2V0?=
 =?utf-8?B?TTJkMEllODJtMFpJWjZlQnNJUEszZk1zZ0dLbE9qbVU2Q3BRNVJ5SllubzZL?=
 =?utf-8?B?cjl6QjJ0SHpoNlovOEI2aitLclYzOXlQNnljQnVsbHhTVEU0WFl1N0laVjM4?=
 =?utf-8?B?R09KSStOOGE4cFB5NkxSZTVnMWUrV05lMWRZa1RiSlFDeWpGcHhOdW1GdXBX?=
 =?utf-8?B?VDFVRmxrL0YwMkxMeDJrTWhsdDg5VFJwNkhSNmk4N1BPR0RRTkExeVVUOWI0?=
 =?utf-8?B?dnQvRm9Kd3FCYjMxV1JjVkEyWU5EeDROLzVVNTI3S0lKUmNFTzlFTVA5djVt?=
 =?utf-8?Q?MOCNYlm56mA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SGZidTczbkk1TTlmcFQvcXFabk9xSnNMaDU1eVh6TkRiRjArMEpDQ3VuSmU2?=
 =?utf-8?B?NUJmcjd2WU14V0syN0NlUTZJblZPVlVCMHlRd1ZHcW1rR3c1K2dyZWRFSXlz?=
 =?utf-8?B?VlN6d052L1NVSWNvU0hzK2RZM3JlSmhzLzg1MkJha2lMS25OcmV0aW9sSlk3?=
 =?utf-8?B?OG95eEpyVm5YYk43NFlKQnRLbVg0L29IdEtNWmd3WlZxcE91dmh6azZ2SEdT?=
 =?utf-8?B?Y0J3UmhLZUdWeGNnV3hKdnphMEVuanpkZ0pvYitNM3h2UlB2Q0VzMHl6MDlK?=
 =?utf-8?B?ajBpM2VNVXB6WU9JSTlLYUI5SklQbHduT1E1aUJOVkRRdWZTdDdvTEh6dXND?=
 =?utf-8?B?bXpEOCtFekR2YVdmMkhUcXdxVGIvR0ZNc2dNVTVXVFZlNWwwVUhiVElyWEtN?=
 =?utf-8?B?MnB6eFRZR29QZTZISFNpZzd4N2kzT2FiTzAvMGdJUm5PMDBodWVIaXo0UHd4?=
 =?utf-8?B?bWYzOTZvblVSOC9hMENEQVkvWkduR2F6QUdEM1lKaVl1RTJUbHdybW95Qm1U?=
 =?utf-8?B?ZkdDZ0VYdFNhK0FYQmxjR0szeG9zc1g1a2JGTkNyanJYcjR2Vm0wWHlmcFpt?=
 =?utf-8?B?QjhaZ1diSTdCWVlnVkxyVUorSlI5dDhMQ1d6TmJIZXA3WFJQSkJZTUxpWjNK?=
 =?utf-8?B?QXE0VkhxL1l6T00xSUIvVnIvNzF2bDJpMzVxU3o4cmV4NTB1YWs4TTF0clNU?=
 =?utf-8?B?Q1o4T3JOdWptbWhOQlF0ckJuMHhlN0t6L2dEWVVCWmJJNUVDczN3WUo5L1du?=
 =?utf-8?B?Z0ZLV1Npb2l6eEdJOTBXL1h5ZTJMaFBCc1NFdWk1em5uNGpQcHpLbjdybE5m?=
 =?utf-8?B?d1dxRE4vYy9QMVIzeWNwVFR1VXM1NVE4U1RpdElNS2JWT0E3YVBMcEVXZHNO?=
 =?utf-8?B?VDNORTRtUDFmUFBPazltODJMRExzNnNTTmJHMlI4TSswT2hwOFBZYjBIQmxS?=
 =?utf-8?B?LzZEcmRINEZjdndvU3BTL2NUK2FmaEJBUW5uUlhVOTJoajRPeXQyckZ6WEVx?=
 =?utf-8?B?bDM5b0tKS2JvVlhZZnRiS29vNlhnaktkZnUzOWNnQ0VlT0pHRnZOU0VVc1FI?=
 =?utf-8?B?a0xQRCtEOGdSNnQvdC82UTVEQkltc242SXQ3ZVpDMys5STZWenZYR2lRWEtw?=
 =?utf-8?B?Vm1WYVkxdmUzNlhyTFd0SVBuc3N1YVZYcU5QWWdmYUNrbXIwcDBmWlFHbFYx?=
 =?utf-8?B?RTNia0ZCaVlQTklJK0M4V1NPYVpiZnZGaXRXUUR2cmZNV1g2cEE3VW1URXlX?=
 =?utf-8?B?SHJsOHlZb0J5WjdCbjhobnZZUGhkMFIvTWo5VjFZREFsTWVKMkdVZDZpN2tU?=
 =?utf-8?B?OVNjdmxLT1MvWEdSRzB3a0RaekE3V1dCRzBHaE9WSnFhcnhvOU1KVGhBU3Jm?=
 =?utf-8?B?Y29hcTlnR0ZVQm9wNTU5WjR3QkZTTmRmL3hFWjBvdmQ0YUYzcTJYcnJXVzkv?=
 =?utf-8?B?d3BGSjlhLzhGeEVlTnhsZ3NGTnBkMFRyMDAvZkxpM0g3SkRyWHBEckRvR0lJ?=
 =?utf-8?B?LzluNU1LYkk5eExLdmtUR29mSklSeVdkcUcyU3ZqYU8rV0U4aDBBN2NTSDZm?=
 =?utf-8?B?eDFQcVNFUmI1dlc4TWZvTlJaUGlWQy9nZ0IrSVBGOUZ4RWRMZWJWK2lPVlds?=
 =?utf-8?B?MkJyVkFqS2xpRGVWeFQxREEzRkZiUWFMdnZsaTN0WVlqYk1QMFlsYmdFclpV?=
 =?utf-8?B?NGorMUp3NXlFbFhqdjVGcTB1YU5jVGNzaDBNQktmMDZaVnE4RWFOVDdQbE01?=
 =?utf-8?B?NXJtblMrazBhM2N6ZDZGNVV6RjJoS01ndk5PN1RLRVlLdHZtc0lxN04rVHJm?=
 =?utf-8?B?a3lNMk5RSkIwb2dEeFVEVjhITE1rT0lvVmhqUHVST0NlMGU5eGM4WWxoWjd5?=
 =?utf-8?B?MnlpVXN6THVKbjZOR3BpMGZHV2J1R2lMclU2azMySlF2MEc0RjFNWmRwUVhu?=
 =?utf-8?B?Y0lzWGljVmZZbkY3T2gza1d2WUQzV1B2ZjhSaGRnaXRBTEtndlJXdS81VFdD?=
 =?utf-8?B?Y1BxVWNJazlHRk5nSU5ZbXdadnpJRUxhcmorTTR5VGh2YW1uMUpxaG5UeGQz?=
 =?utf-8?B?S3JGSE9tMnFLS0daaVdOMXhkQ251NXJ3VUJDY2JSbVRnSDZ3ZTIxckxqUUVF?=
 =?utf-8?B?enRZcGRKY0ZTTlVUQWZ2Sm9OVmJ3TWRNOXlLS1FxelQxK243eXpZREpPd3p4?=
 =?utf-8?B?VkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b1f3223f-291c-4594-eaa0-08ddefee10b3
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 22:13:11.9109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1HWS7iSFIPRb2WHooje/IbpLv9M4rmpA4M62AMuswM02JOfWQvjoqV9RaEF0XwhTqXlm21qaGlHcQdJEAdLJxdfc16eOOyhMJVlUHZPZ/y4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4836
X-OriginatorOrg: intel.com

Hi Tony,

On 8/29/25 12:33 PM, Tony Luck wrote:
> resctrl assumes that all monitor events can be displayed as unsigned
> decimal integers.
> 
> Hardware architecture counters may provide some telemetry events with
> greater precision where the event is not a simple count, but is a
> measurement of some sort (e.g. Joules for energy consumed).
> 
> Add a new argument to resctrl_enable_mon_event() for architecture code
> to inform the file system that the value for a counter is a fixed-point
> value with a specific number of binary places.
> Only allow architecture to use floating point format on events that the
> file system has marked with mon_evt::is_floating_point.
> 
> Display fixed point values with values rounded to an appropriate number
> of decimal places for the precision of the number of binary places
> provided. Add one extra decimal place for every three additional binary
> places, except for low precision binary values where exact representation
> is possible:
> 
>   1 binary place is 0.0 or 0.5.			=> 1 decimal place

nit: "0.5." -> "0.5"

>   2 binary places is 0.0, 0.25, 0.5, 0.75	=> 2 decimal places
>   3 binary places is 0.0, 0.125, etc.		=> 3 decimal places
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

| Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

