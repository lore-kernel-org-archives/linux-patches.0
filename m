Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49A013B2A5
	for <patches@lists.linux.dev>; Thu, 13 Jun 2024 20:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718310738; cv=fail; b=vDxWGLnXWwQ/mVN38BJIkY5TJ/CbDvWH3XruUJDaSsuymeam5l40HPXVARkR1r44YcdZ4S7cF8JhN2q8Ho75dhaXz/ONTxiNpU7quhDjcz8GXtgpMFDb5O/ZzcfKfSN3TSJaB43kO1Nz2RNlnEjAS4q5eIrhBUzOHT2eAbUTdpA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718310738; c=relaxed/simple;
	bh=0HhHiwCA684l6tmcLeCe3YeMMdhyida9wjwglIU6oM4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NJNwa4oTEwf3lbNwVQ4MWT2UP6bxvXkPfztiIUCFk/1slvUlZ6HfDqjNqUwrXpq2rCYVF83onOIhsDnLPCyQrt43+FuYR2htH2xL5xvutxL1rv15faZ7gm2rScP5xpFibv9RLXP+wIpx0qLeb92MYnPT5rbOleyv9oNfIljOCLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ycc0US8z; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ycc0US8z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718310737; x=1749846737;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0HhHiwCA684l6tmcLeCe3YeMMdhyida9wjwglIU6oM4=;
  b=Ycc0US8zoHRhc0mqciVufK53t64vtagj0zfthrYYLd9t5Fitwr9+0KSH
   ALTodpoDqP8djp0UD0pZmdsRj6655hL8CrDslSpk7u5EAuAF0t7xhbGih
   Wkl2Xg0OjRo9tDHHzO1N2TPD87eMl7D5nsR5+P7h8hrb3TGcXhhX4+e6U
   Ayf/TTT6z7p4bVkDpJAPLdFfAGrQ2s8tl7glK3zv9WM1k6RnZDE62ozrg
   bWRZdrwOpjlB/mxi2DW3cYgrZf0ghZKfgXlUBjUKKq+r/hJyF2n+yaBGq
   WTGdA7VoPY67N7fDnR387nptdmS8PYpIw0B4kllRidRp0ewezD9RcSFoy
   w==;
X-CSE-ConnectionGUID: AijhwGjgRcyvD5lIC28mBQ==
X-CSE-MsgGUID: vhRMaHCQQlKwW9DtYhonNQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11102"; a="18094361"
X-IronPort-AV: E=Sophos;i="6.08,236,1712646000"; 
   d="scan'208";a="18094361"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2024 13:32:16 -0700
X-CSE-ConnectionGUID: qD9/7TRMRkidVQ4sg6s+QA==
X-CSE-MsgGUID: LhjZkFK4Rr68UP478Cw3Kw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,236,1712646000"; 
   d="scan'208";a="40759473"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Jun 2024 13:32:16 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 13 Jun 2024 13:32:15 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 13 Jun 2024 13:32:15 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 13 Jun 2024 13:32:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TSn5I0p8tsp4LxoXbsRKlZq2OEz++v7583gcauyuhdaSXQ1W96b2EhtvBeb/WsyMSGthIdDeIe7uT1gnLFa080fvp6IjJZktEohHUk1Wbszj4pzx613CExfDLRlK7MdQx3eGzj+CbWZEVf+2XDLQjgd0cZ+gESkQsI8n+uAU9y/0+NxEkabtiEHlkLFJ5NgwYOY/oWCC4lr0eIUM5y3DAf2wL7r7vLBitly7fz+8/+hJ3xR8Dd0sPC4RInAuK+LsYZ+qjnE3FlHssW7cg15I9mGZF0j/4mXGYzUZm7IcfdFMnvxiM3bAd7OSMoUsKdNfLv5Pvb+LDcAAIKN9gR2VYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NoAnnjG//hVESNwVBzR5O1QkCwW4LYoIFZE0ElF7T88=;
 b=Tv44bKMOhK5h6AL+UQ96V9nvH0/V9FF+kHclm8CmIScF5ykczo0BSWPE5+fVWNMIqZvA120AW+E511qDb4jnd1VnJqCDVd6yWb9PmxJzPq2oVym+MU3TMei6F1sTFJiDTr2XDX5jzH601PBTMgNM5oEQ9+E0fl9oClLTgpOXk+CJM43i9T0FJ2eymxQKoNuQUUH/x4q4ei7kT8Rm/g0QUkyiXz6UjXOpCZqBXpeN3FYiFduI99pn0U7gT5kt2t3Zd+n1fWfP5rswKo+hpFQZWxzk2+WMsnhtukTwncPd3yO/w+OkCYTBrMOijfWdI5kkQR44NDiSxthgTPpYRlz73A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS7PR11MB6038.namprd11.prod.outlook.com (2603:10b6:8:75::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.25; Thu, 13 Jun 2024 20:32:13 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7677.019; Thu, 13 Jun 2024
 20:32:13 +0000
Message-ID: <bc52a051-4296-48ac-9a83-29139855553f@intel.com>
Date: Thu, 13 Jun 2024 13:32:10 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 00/18] Add support for Sub-NUMA cluster (SNC) systems
To: <babu.moger@amd.com>, Tony Luck <tony.luck@intel.com>, Fenghua Yu
	<fenghua.yu@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Drew Fustini <dfustini@baylibre.com>,
	"Dave Martin" <Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <658d9869-ef22-48a7-876a-5bbba4f134ff@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <658d9869-ef22-48a7-876a-5bbba4f134ff@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0186.namprd03.prod.outlook.com
 (2603:10b6:303:b8::11) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS7PR11MB6038:EE_
X-MS-Office365-Filtering-Correlation-Id: eae61046-2636-46a1-fb64-08dc8be7e828
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230035|376009|1800799019|366011;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RnVJbjVQVUUzWWVjZkVZVFVRNEtTVEVMNlM5Z1lGUTZrSU5Qb2w5elpYdThh?=
 =?utf-8?B?akR5N0VzeFc4WW1IalVwK2pKZGcyTFFLa0RBNUI5MHVqTXViZkd3c1pUcWxF?=
 =?utf-8?B?K2JMZ3ROUkI0RFZEeEFzeHoySlh3enVDZjl3ajhyOXpic3BGbytjenE0eVhx?=
 =?utf-8?B?S1ZQQWNkcnRaMVBMTzM4MHZBS0JnckMxSkpid1hqdkt4UVh6TElUV003ZktQ?=
 =?utf-8?B?R2tFNnZSNHkxOFM4aFl2R3Vqb2ZLOW04T3ZtMU9rSG1JQ2tPRzQ4dTE2YjBy?=
 =?utf-8?B?YTZxSEpZMmF0eXNucDhhdlhlMksxYXZGVHBSdzFPM21ZUUtFblVCak84L29O?=
 =?utf-8?B?YUNvNXYwTjkvbjBPYW00K0FGei91ZTZDMGFKTUUyVzJ2UEIvSUhmK2VrTkZM?=
 =?utf-8?B?ZTlvTklmVVV4Ujg2allteFdXZllDY041TUhvQXpqM3NJcjVnbTBnRG9CMG5D?=
 =?utf-8?B?dkE2MHpPY1d3MVg0L2pGdlgrMHRJUllFRHZMRllaZ3hCdDVCbXdoanFJaFZz?=
 =?utf-8?B?MkljYjh0NWpRd3NsTjJDN0ZYZWJzUHhVQThYditER1NwTlh1U1JqYjF2Y2h3?=
 =?utf-8?B?R0E2cEVqM045Y3lhaUhHcWlwemtFT2l1VE9SYTJGbURzejhndDQ4bDNJRWFS?=
 =?utf-8?B?UU40aDRxRHBrNkpRZHp3YWtwekptQitVT0RqWDBIN0p2VmtBM3FScVplSVpQ?=
 =?utf-8?B?K2tYL3c4TUYxK1JUVVhsWGFmT0swMlBqSFlUa1lxTmYxQVVIRHJqVGZkYU0y?=
 =?utf-8?B?bnZ2Nk5QbzFsaEJ3S0o5d1k0L1lsQ2N6NU1GQUozQmJEN1Bkd2xCVDJlMDIx?=
 =?utf-8?B?REJMWXJxTmJiOFRRMVM4UUpOc29wM1B2bUhNMjBBZ3R5WEZiSzNsRDYzT1p4?=
 =?utf-8?B?L1lFclFySmxQSUdJRlhVRHFqeUVsM2lpYmx0eXpvVy9Mb01BZlo1VUlabzRF?=
 =?utf-8?B?RVdGb2ZkTllYdHFmV2xlcE9WbzhFWVdNWGdsdjRwRnBOQk1NdlFYaVMvcW1U?=
 =?utf-8?B?QXk0ZXVpTzZxbUFqUFpnR0QrVVI4QVZzT2xXTVRyWmloT2lLV0RVRmUwUVYv?=
 =?utf-8?B?QU9wOGExMWhGbzZIbXFZd2dRWTVkKzAzc05RRnduRkx0eEhaRnhRc2JyOXRF?=
 =?utf-8?B?MkJFMDZaRXRuam40Y2czeEZHdG9ScVlSZktvdUtVaTFmdXU3b05udy9KQjF5?=
 =?utf-8?B?Ui9say9TL29qNXBpMjlrTkdlOVVEVEI3dEd4VlRuQks3QVpLdzN5YW9wRDQy?=
 =?utf-8?B?bnoycUFXMjVrNVZKcDMrM1krUWQ4VXBPU1ZVNzYwczMycEt6cTNjMGFwNjgr?=
 =?utf-8?B?WHE4WXkxS3p5eitkRGdOcFRQZ1JvcmlaemVkUDJzcTdhbVU4citPMGdJSmE5?=
 =?utf-8?B?YnpBZk0wSi81Q1Vpemc4UUxnUDRjYm5wRHVVbzBXU0ZMSlFMWld6VWNxdS8z?=
 =?utf-8?B?TFlMSFlVNHJacU9VdDMvOWdpUDZiSW9vYlVDWHNsV3R0Qy9hUVFKTmo4TzRG?=
 =?utf-8?B?NVFSUnJIdXZad0dZNTk2c1BOOVBKUCtiNm5pazlYSFFxUmNOckgrKzR5VkV5?=
 =?utf-8?B?TkhPNTZDNlRpamlaVXQ2QUtHUkRsYnNtcEtTVjNwMWkvZDcvVU5yRmVvUVFF?=
 =?utf-8?B?VFlSU3FGS1RXVzdnc3lITjB0YzZrSEZyVUlDUXloRGRha3RPc0xRZXQvY2ZF?=
 =?utf-8?B?VndadzZQb004OXZic0tTSmpJcmpaWUEvSTYwVGFuUjI3NFdxQk41dHVnaXZE?=
 =?utf-8?Q?jouUktfvLUBV0XQcPTY8qi7Qd+wuTHk57gh4JJq?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(376009)(1800799019)(366011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?elNkOXh6N2VyYnNXRGJxVjZoSytJclpRYzVGbFZhcno0TU91NVVNcnNjbkc0?=
 =?utf-8?B?Mi9XSXdneU9jVEY4bXBQRUIxS0djbElTTG5nQjVnZTdhV1dTbnlFRUhUakwx?=
 =?utf-8?B?TWcwMlBCRFJ4MzZyeXQ4UlIxcE5VUFdZSUxhRG80a2hnNFZBRmd3enFQWllB?=
 =?utf-8?B?Wk0ycXl1Wmx2UEhOZmpWNCtIVkI2M012UUkySmdPZ0hPWnF2d0VVdWpZTUxQ?=
 =?utf-8?B?aS85Q2N5dU82M2VRY2l2cHNqQWp4VFF6bTN1RURoRWF5cmV3eG9FYnJkT0dJ?=
 =?utf-8?B?d09PbXdVaWpiNFVPR1c2Vmxhc3YwQ25kc0lzTU82R1hia2VreVBwUGFEZFBC?=
 =?utf-8?B?Wnk1ZlZpR2hYT1c4T1h6TnlmU0cvRFN2dFlXYTJydi9KU3M2T2RqZzJLem92?=
 =?utf-8?B?VmV4TnVNeXFRbXRJWWJjRkpmdXRnVllOMVBLOFJIYkR0dG9LZm9VM1RXZ05G?=
 =?utf-8?B?QlV1b1ExU3pHQTZhdGFsQkN1elc0NnhvOEV2RDNGb1B6amZkYlRYWGdPRTlU?=
 =?utf-8?B?Skc3VUNIVTNoVFhPeVJjVHVkakt6am5mVWpsM2VZVEdKYkxJOU1oVEFwMEZ0?=
 =?utf-8?B?ZEo2Nm52dE01QS9ONDdGOWJxQ0h2UWNKdWkySFBVdGxLWjJBWStSRit6citn?=
 =?utf-8?B?SWtvTVpScDVsc2hCNkNlUlFML2FJamxiWHppbEtKd2J0Qk95VmsyWHQrcXBQ?=
 =?utf-8?B?ZC84UWowRC80L2pLU3FvaEdkVmNqT3N3YWwrTUlSMVA3STg0TDNuU1FkSEhH?=
 =?utf-8?B?cWZIajB5QWxUMUpJVVNUSXUwYUR4aG5tUTJ1ODBPL2ZFdklhbnZSM09FcmNR?=
 =?utf-8?B?d1FPMWlnUTFJTUF5a0tZUENRZjFFV1RuZllUNk54TFM0NkhJMGl5emdnZ3d3?=
 =?utf-8?B?WVZMUTJIQkVjMEtRb1Y1czk2d3drWWpONW94VGZtNDBwYnZkb1FIUVdISDkz?=
 =?utf-8?B?QmE1UmY4K1pxVkFvd0d5NXpVNlhUK2RjTFp5R2dPWGRsclNMK0JseGNidlov?=
 =?utf-8?B?K3BuczY4YWprMy9URURURi9HUWlDMjdKemhhKzlya0RHMk5TZjdSaTZkckpo?=
 =?utf-8?B?Q0YxcW5GRkluOUpObTlWYWRQL3NEa0FLVDRIUXk5YkF6bUxLbjVmcGFpeDZL?=
 =?utf-8?B?RXhBQ0lqTXRWczdCWlVLdmtBSnFwSXRlelZwMUZrYVpwM1Jndm5RK3Z2U2xN?=
 =?utf-8?B?eERiTjRlaFEwamlEYzlMNk9ZUmxsMXB5ZzhHZ21pd1V5NkJmUG91NTk5Q0lz?=
 =?utf-8?B?cGtqVW5qcXZuc3V4S25UZDBCTldQZlhjQnM5cU5ORUFtOGgveEpWOG1mdW54?=
 =?utf-8?B?Qnc0NHFzcnZsWE1wNnV6ZTh0QWRDclQ3eTJIY0hjcjlrQ0VUU0s3ODJWWURo?=
 =?utf-8?B?SXoxazhsczRCaGpsS2YzMTRabnpuMkhOZFFuT1NmcUh5M2hHVzloMjNoNlR3?=
 =?utf-8?B?NHArSTE3UklOUXlPa29CVjhJMzl2eTFxOU4yd1E4WnBIY2JpeGVUeVBxaXdl?=
 =?utf-8?B?bTZBZUl3akRYZ2pLaGN4TzJJYzBWWWQxK0d4T3pZM2E1b2RCVHoySE44aFkx?=
 =?utf-8?B?NHpsOXlUTGNGeWNrYnFYM1d6Y0FkNGJNVEw3VVRrc0Jpd2ovRzFLVWNBRWZK?=
 =?utf-8?B?MUo5RlU2RU9BWHB0RWNNMjN6aWN2L1FBZ2JPeEx4VG5OT1QzVVpFRVB1L0dh?=
 =?utf-8?B?V1h4MGIzYzZoaGVXQkRzaEZIR25VaXd5RnZrMDJxTWplVGdJVHhqajVzdGwx?=
 =?utf-8?B?azRjemozZmhBU25iTDd1SmMzVWJOUmtJK09zejgvaTVDbVdRVkZiTG5rZERP?=
 =?utf-8?B?R3JaTWt2SWk5QWxhcTBXQ3MwaHVVb291U1hVUktuZ2tnOUdQY1dYUTJNVVR1?=
 =?utf-8?B?NjN0bFQyRHVZVXcxZ1k5TitHY3ZUcHowTjYyUWtWSEpyZDFFZzVkbHlXRk1w?=
 =?utf-8?B?NWFnZkdtYWVZbXhBWGM0MjhEQjBjVFg3TjNUYlJVTzU3cDZWbFhiNEhWaDdU?=
 =?utf-8?B?MlU0dkJydWRmZTFwbmtYZ1lSK25NWUc5UjJSOTRlcXEvNU04dkdHS3dRVm9z?=
 =?utf-8?B?VWtOQVdqQzBKR3NiMy8yZng4QVJqRTNkQVg1cW94c3l1Zytoemc5NWloR21J?=
 =?utf-8?B?RkFNdEZMallOUXJYQ1N6Y1A4OUI3RUkvdVBxd2RQb1dxK0l5K0Z1ME9vS1Va?=
 =?utf-8?B?b2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eae61046-2636-46a1-fb64-08dc8be7e828
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2024 20:32:12.9721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3waXZ466r/chJ3u9YJaZUkFcC/rayPztCtFDnjGoYX9PfH4DtVKWMjPSSdJ90plFAS3tAuVtlAz9dizvu7DlNmRUlzU7B98jTjVCSnqTPWM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6038
X-OriginatorOrg: intel.com

Hi Babu,

On 6/13/24 12:17 PM, Moger, Babu wrote:
> I may be little bit out of sync here. Also, sorry to come back late in the
> series.
> 
> Looking at the series again, I see this approach adds lots of code.
> Look at this structure.
> 
> 
> @@ -187,10 +196,12 @@ struct rdt_resource {
>   	bool			alloc_capable;
>   	bool			mon_capable;
>   	int			num_rmid;
> -	enum resctrl_scope	scope;
> +	enum resctrl_scope	ctrl_scope;
> +	enum resctrl_scope	mon_scope;
>   	struct resctrl_cache	cache;
>   	struct resctrl_membw	membw;
> -	struct list_head	domains;
> +	struct list_head	ctrl_domains;
> +	struct list_head	mon_domains;
>   	char			*name;
>   	int			data_width;
>   	u32			default_ctrl;
> 
> There are two scope fields.
> There are two domains fields.
> 
> These are very confusing and very hard to maintain. Also, I am not sure if
> these fields are useful for anything other than SNC feature. This approach
> adds quite a bit of code for no specific advantage.
> 
> Why don't we just split the RDT_RESOURCE_L3 resource
> into separate resources, one for control, one for monitoring.
> We already have "control" only resources (MBA, SMBA, L2). Lets create new
> "monitor" only resource. I feel it will be much cleaner approach.
> 
> Tony has already tried that approach and showed that it is much simpler.
> 
> v15-RFC :
> https://lore.kernel.org/lkml/20240130222034.37181-1-tony.luck@intel.com/
> 
> What do you think?
> 

Some highlights of my thoughts in response to that series, but the whole thread
may be of interest to you:
https://lore.kernel.org/lkml/78c88c6d-2e8d-42d1-a6f2-1c5ac38fb258@intel.com/
https://lore.kernel.org/lkml/59944211-d34a-4ba3-a1de-095822c0b3f0@intel.com/

Reinette
