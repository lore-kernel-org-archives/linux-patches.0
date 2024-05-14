Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1810F18133B
	for <patches@lists.linux.dev>; Tue, 14 May 2024 20:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715718613; cv=fail; b=C1TbuyUcqt3/pWG1Dk1ZF7yq7cPEZ8t03jjleqWhgHJdvSCsednSrl6EN9t5MtZr+bvOdtpqyKdruX5NZkFXyCrAg8gDBR2J7fhz1fjiA8O37mtgRtqSCGmkEviHMu8Bwthfm8/+y0s3nQ4jf22nm/WpARaEd5LKqlka3hUIWFU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715718613; c=relaxed/simple;
	bh=0m4+Xbr6e+9ozatJIk+KCKBRR7y2V368B5oGiN+6bso=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WiRnHJC9FwB5iqfe61iJcOtDG70fy/UFVN1MvGN4Ta/Upq2arqn9y5T7HADXF8JeW7aoarQ5bd/oLYa8nDoJLthfI2C+p2ItZNbhISLXZdOW449rfgBgSnQBKJvyZ3Mb5h2C13bl4liRJ84jO99caiB6u+wJxm9HAKbxWJArph0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JX1OcmSU; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JX1OcmSU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715718612; x=1747254612;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0m4+Xbr6e+9ozatJIk+KCKBRR7y2V368B5oGiN+6bso=;
  b=JX1OcmSU+YuQrL4OCAfuUebZpxGHqgDXXPoHe+eYIRLAtid55pwOuLw0
   o/nOt/Yq3DEpCI2iTZVArzc0+oZvE/2w4bUBXlhTXgtNSiyvkMMy2YO85
   yO7zFk/YmA/xcADnC0F93BY7vTE8t2WIl9diewMaAlvM1Mv9xakukfbc/
   6TSL7wNUH2xJWvsSgp0/nL1Ex40gR1iH749RBxsOb86Jw4H+FTUqYV2QM
   swJapf3ssZ79yIIIKn21Ft2A7cisaa/q8NgtzuRRPUnuv3l/TbLX59qH1
   XRj0SG9MgYMn5LEIYvCrqu6JmW6NQpBtL60g2WVVOKACCumtj0TgiFmSI
   g==;
X-CSE-ConnectionGUID: sOpRn41PTzeGieIb6DCJXQ==
X-CSE-MsgGUID: eaVugG8iT5KDmUIIelDAEg==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="11851098"
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="11851098"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 13:30:12 -0700
X-CSE-ConnectionGUID: BuhIHvw7TyOOX9BxfMwyfQ==
X-CSE-MsgGUID: eTxmQf7HTa21diJgBb10ZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="35333965"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 May 2024 13:30:11 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 14 May 2024 13:30:10 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 14 May 2024 13:30:10 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 14 May 2024 13:30:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I/gFXmhZxps+QJCybPqlsu0yAYRF4NAYotmFZ/GmLpfr1u+i0BCrL5/wgQrtUEG1q33dTd3yFeyvezkB3KGvgQr9T6cz0oPdNhJuWAQjcnNTR1m/GwwqbeN4XcEe/fskDBCLu+0YJc9W1naa3K9IlblqR0Emzwb8RE90Lz/IQTUmgIY0f+/v5uHqnWNc2AXUvKxgTdwtDqtz89x4veV/B2F6rpdGvyG+iNBrVFdkAtSg04iobhuD0Sc5nW3f8S35d/w/u18Md37zl1wTtPvodXZL1u+kg2x0UcnEJhDqEYZK/qG4roR6AteeEOjqHBEnIX7bHWWuZ5z06vz5fgM/+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CemipY4oMbOw9IFK/xhWHhpeJlde+ky4LTmVEok7DZM=;
 b=VZ+Zuxb38ARri9QN/yqjxtQHSjSI6BF9hoWoh0Xla8qV0aoTV8en3nXTtxTHoFQOX5hWXM4Ld0MSiW6M353AIED1xXiPnX5ICGk5FVH8u1znDHjF8C/4wMZXkLFJYmDJKPNW6PGENciBY/zJm9SdqYKUnFBN0o2OEl/nvHkXrJs9WZxzCCz6D8BMlhJAzCeIfrHFzlv3KICUlkpXgvxSx4vhxW590mkyAZ+wAZRHT9JNNcXXf0nbHzFOJOhcB5jbN5woB7UdMKTJzgyFAooP+EhgdTh6YRYoHvRO0c2VKheFKVuhbjytx0pOaLAg4lMD4ViO4xnZ5g3NfkOxOpXWUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB7919.namprd11.prod.outlook.com (2603:10b6:208:3fa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Tue, 14 May
 2024 20:30:07 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::b394:287f:b57e:2519]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::b394:287f:b57e:2519%4]) with mapi id 15.20.7544.052; Tue, 14 May 2024
 20:30:07 +0000
Message-ID: <b718c70b-21ea-4c4d-9ecf-387b8276a721@intel.com>
Date: Tue, 14 May 2024 13:30:05 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 7/9] x86/resctrl: Add new monitor files for Sub-NUMA
 cluster (SNC) monitoring
To: "Luck, Tony" <tony.luck@intel.com>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	"x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
References: <20240503203325.21512-1-tony.luck@intel.com>
 <20240503203325.21512-8-tony.luck@intel.com>
 <0178e84e-d55f-47bf-b8b0-58e05fcaa108@intel.com>
 <ZkJIZdU2knEUJN7Q@agluck-desk3>
 <f49931b0-d9bf-45f0-ab35-93b1a78f6b97@intel.com>
 <ZkKupOKRu5S7Rkgx@agluck-desk3>
 <2efcae46-736a-4809-8530-7dde3977f3ce@intel.com>
 <SJ1PR11MB60838E2DB2984EF95D34C692FCE32@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <SJ1PR11MB60838E2DB2984EF95D34C692FCE32@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P220CA0017.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::22) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB7919:EE_
X-MS-Office365-Filtering-Correlation-Id: 09ff54f7-c72f-4cc4-02ee-08dc7454a529
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dGVvcWVVVzlkR1p3bnA1MDNJTXo4RmE3MFZLNHdVNWNPSERTREtBdElia2do?=
 =?utf-8?B?OW1CeVZIaFFiMklaYnpFWFpKYkhTa2o1dFJ2OGhYcGtEcHNBbFNqZW1IeXB6?=
 =?utf-8?B?MGFadnpiNjVRNSswMittaTEzZnNSOU0yZ1NmY0tEenI2SGRnVG5IdzcxVTVi?=
 =?utf-8?B?QXJ4OVFsYm94eGdVQ3c1djdXTE5HZEJjTXRFUHVMazYzVGJMT2tTMkZsUFIz?=
 =?utf-8?B?dU5mYzlTd3JVL0hqcGFTYlVxNEtlazkyTmppYmRrdVFJMUE3aGJUaDg4bmdv?=
 =?utf-8?B?TlpRYk1XdUpORk54bVI4NzJQOEQ3ZUY0SlFTWlh3VG9MeGdqVEJ4S0NnRHN0?=
 =?utf-8?B?YUdidWpGMXJYVW5hNUVEQmlDbk9KQmE1L09ncGtmbnB5UVdQN0FVeXZxd3JJ?=
 =?utf-8?B?UVVBdldYVTFkUjR2cENVc1ZSSjRMN2V0N3JKMXFOZDB1Nkw2Nmk0Snd3em1X?=
 =?utf-8?B?UG5uaGh4aTlvR1ZCQWFsRkdNbmhWdWNSWDV1b1BpWUlQY3ltYzZpWkJ0eEJZ?=
 =?utf-8?B?VzZKN0xYT2tmOGdDVnp5U21ZN1g0VUxYbXdqV3BtYjlPeWQvdTZkT2lYaHZY?=
 =?utf-8?B?QTB6ZFFxR2IvcXEwaHZuSGs5VEQrR1FGQm42K1BtY0NiamRPTFI5R1JsQXFz?=
 =?utf-8?B?Qm44UnhnbDJ0RzdSUjdwL2pLMnZ6ZVAzL01SSWRiSXVQQnZCNlo1RGptMUNW?=
 =?utf-8?B?WjlCbnc3NHFUaGVNN2ErL0YxQnZBb1FsZXViMXZXWUsxVXdoQ1hwQU9rQjdL?=
 =?utf-8?B?YXM4VS9QaXdaa1VwMFNreTZybmtyY2QzY1RLdjdjQy9jQkx2cGlNMzJXWUtG?=
 =?utf-8?B?OVdKeTN6VmFjTmd5bHRSUGw0YkJtckhyQXJuSEZZZ1gyclNPUGxDeU9iWVVV?=
 =?utf-8?B?bERjb2VIMEoraTFWUXNXQXZGVzc1Z3NZWmlyOHFIL2F0TnJPV1hWcDJnMjRV?=
 =?utf-8?B?Vnc3UHNKbnV6SXQzYWplT2xvRTdHZExFb2VXcXp6R1duczl3Nk5mUmJFd0R2?=
 =?utf-8?B?WVNvd0Q1VkwzMy8rZEh0U3hiV0llUzE1S3FDbHloMFh4WmdVS3FDSW1MaFpC?=
 =?utf-8?B?bGx4VzVLbU1OUGVqSWcwRXR3T0VOTEM3SmV0cU1yT3djMTVVT0ovTXNTQzRt?=
 =?utf-8?B?NnBPQ1g2YnFyQno5L3pjUHNmMncyYXorbVJXRmh0ZTZWTzRyamRhTzdZa2tS?=
 =?utf-8?B?eStqNTBzc3RBWGYvOXk5b3UrV3Q4V09mTjVsTUFGMGJSaENSbCtpOWxqdHdk?=
 =?utf-8?B?M0d1eUNOeE5lc2pXVG52VjdQWGxiZTYzb2hCemc3NndJamtkRXYxeFdkZE9q?=
 =?utf-8?B?K0RVU1ZXcDdlT0VnN3YvekFwU3ZEOENvWENMcFM0ZWNTbGIrQlJOcWV4TnIw?=
 =?utf-8?B?YUZGNFJXcktnRFRMNjBZVUg4d2dHWnFZZk04UnVCNGpWam01WUZyUkcvU1ZJ?=
 =?utf-8?B?TDlUMUdpOXNEOHdvd3dIT1A4WWRudGxnbVBTb2VvMXljY1RpdkZzM0dOYnR4?=
 =?utf-8?B?dnpqa0x0SjJ4ZE1sK1JEb1ltUVVaSzQ0V2U1YW9zaWZxUDRvUERKR1JoUFFW?=
 =?utf-8?B?ZDlUb3M4RWRRWUpSK3ZKL3FwNjNnS0orL1RkaEFmVjRKM0ZhMWtLRUYxVFpI?=
 =?utf-8?B?SWxZcnlLdzdQd05kZXZWUTl2QW9jYlFzVEFMV0hLOW1hZC9TSVNVSlRVMzMz?=
 =?utf-8?B?NnhsNFJPajJPSlZzYldXNTREK0FpTi9ETlZuYmhoZzczd0NWM0M3YWpnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZE5vU3hMalhPeW93R1RsYVo0cUUvdGNicXdLR1BYeGQ0QndsbjUzMERjcWkz?=
 =?utf-8?B?R0Z0ZE96cDNRWm5CVUNJZGJkQ0FndEJrMmFrUWtnZko3d1hicE5xRmw1M0ha?=
 =?utf-8?B?UFNNSHFybVVKbWFGelQ5QTQ3VllzUDdOeWU1d0NQbmI0bnZhWWdlamw1Q1Ni?=
 =?utf-8?B?NHAxVmhPbEs1eWhlRnA1NzFHQXBmNHJoeXpndTQveEkxZS8rZnNKZmpxdS96?=
 =?utf-8?B?bHBGVnNLRFgrZjdKczFSTmpPZjh6SjQycWVnSnViRTNHS0s3UjhEbFNpZlFN?=
 =?utf-8?B?R2o5ZDQ1TjFGU0orczJiSmk3eGExNWtxb3VMOER1Ni9keFJldHBicFFlekJw?=
 =?utf-8?B?V3lBbCtOUUUzUmRpMWcwcFFKRGNNYjMzSlgxQ1BYMHhqSGxvTG5zWFp6N3Vp?=
 =?utf-8?B?Ly9pc2dnZmtNM29LSGRwdTAzY3diaExpUzA0KzJaTlJmTVZ1OGpsQWppUHRX?=
 =?utf-8?B?bENwM1hiYjlQVW5jd1ZOU1NJQmdnUTd6cmtzcmFhUCtFU1pXWGdvUTRNZkFh?=
 =?utf-8?B?Ui9qOFRzNGQ3cWVOSDlweFE2MXhQa2J0cXFmaGxmOHlpc0VmWlI1K3lIa0xR?=
 =?utf-8?B?K0FHM25BSGIxRUxBbjZnK0s4UmFicmVrWHlXRXBUbC81NHdZcU1tN1dldlFO?=
 =?utf-8?B?bXd0T3g5dWdtSUpnOUlsME16UHZzTUV1SEY0VW5oY0J1Q0tITjZsZ3Q4ckd4?=
 =?utf-8?B?cFlkZmYrK3pqWHViZThiNFMwZnMzM2MzMWFjYTNuR05MSmVYUXEyR3V4NmFt?=
 =?utf-8?B?VEZxVGVHMC9hS1kzUlN0QjVxeFdPVFlhOVQ3cEhFS3ArRkdMUzVmRGJYbjY5?=
 =?utf-8?B?a2FNY1NjV1NlaXdhaWFDWGgxSUhCdkFKNUIvR2xTL1hpZThJSUFsU21oVVUv?=
 =?utf-8?B?VjdDWkc4bk9vbWg3L2pLSkllcFlxLzVWUFpaWHFUcTAzYXR0V0lRYkRmejhB?=
 =?utf-8?B?REtiQU9jMTV4eWJxYnlLQ3JMdEhPdTR2MktVaEUzVThhQVlSdHVxK2ovTW51?=
 =?utf-8?B?SkNEWE5wK0pSWmJqOEo2VnE4LzFLeElzVGpxWksrNVJYQVBoVDcwZFJNR0Qr?=
 =?utf-8?B?VDQvdUFjc3QzOW1DbnRicjBHaEhGWGdnMzdVZlZNT1djeVdqRWxPSzg1clpC?=
 =?utf-8?B?OUtKZkYxTWJhZGtxQXhENW9xbzNGbytocDdiVk5TQUN1cTRGT05CdVJkU0c4?=
 =?utf-8?B?TmIwRWNtTDhzYWoyUGgvZHhab0VyOW9zczdrWk1UWnNWT3BEZFNGS2Q0YU5s?=
 =?utf-8?B?ZTFxTm1QS0hpMTByR3hiZHJqT3U4c2ZsczduMTkxV0JheWVFZ0dKQjcwUFpr?=
 =?utf-8?B?aEc5Q3lFZU15WHNiVTI2VENoWnpRVUhLNzF1VzFDVTRvSURHZEo0ZkU5UDJa?=
 =?utf-8?B?OGJzK21Mck1EeFBha29Mdkh0SDViK1JTQTZsNmVNNUI0T0MxeFlDMjQ2Ym9X?=
 =?utf-8?B?TkF6eFdlUjNHQWNDK0xpcWZ5WGp0ZTAwd21RMnVZZkZCZGp5MExhcVorZ0JY?=
 =?utf-8?B?aXVpMzNpU0NXQ2hWQnZoVVVWUXpqOWJyT2t6WU56aFlEd1JXRFVxOFoybktm?=
 =?utf-8?B?SitPdUpqSlNaT2l6dGd6c3huVThnMHVNb3V3Tjd4L0lZSEM4SjBhZjNNSHhh?=
 =?utf-8?B?OEdkSjloYWF3MkExamEydUVtaEF4dVpSNnZqYWx0bUszWmhkOGE5ZGdWNUQ1?=
 =?utf-8?B?azBuTk9Od0pFT2VKbC9UUVdjRnJjcm5QU2M3NWs2d1ErazdlU3V6bVJKMzRq?=
 =?utf-8?B?bDBOMGFVbzlJRlpoMDB6REpZWjBzV1VPTWhzbEYxMW9MMG5NOU5SYTNQa09S?=
 =?utf-8?B?cjA4NjA1bTBMVk40WG5RM1RJMzN4NjRIUjJqTGxTMEdhd0pQS054RjYyMFFi?=
 =?utf-8?B?WVE1cHlJQ2h5L2psRVloMjRWUjZDT09majBMQVZRUEk4eEVrMWpQZXR0MW1M?=
 =?utf-8?B?TkhocTZER2ZUeVhjWHdPQnNBZlNyS0pQY0lqT2NhQW45OGVrRUZmVXMwR2dj?=
 =?utf-8?B?NEl4MUFSQkl6RXR3V3Bqb0psS1pNMUV1cldsVURQM3phMnh3SDRoSmsxS2RU?=
 =?utf-8?B?NTVTcmtTUytFc083YUNXcSszK1R0Vk81d0VDWk5lSlF1bzVZeHZyU011dHBN?=
 =?utf-8?B?ZllENVhsSDhDeUZSZXJEeVZId3FlK2pYcmIyT003cHIyOUpWT083MXB1d1VL?=
 =?utf-8?B?TWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 09ff54f7-c72f-4cc4-02ee-08dc7454a529
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2024 20:30:07.8555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qjR8MaPi9+KU+GzVKlK+XJnHRjb8H4N25soTG5ne2Kykum6iq4STPi9KFycJnJYxAHGIrZme7nKkLkJ/6FqmVsBwAJV0n/u45Mj2DYInyrE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7919
X-OriginatorOrg: intel.com

Hi Tony,

On 5/14/2024 11:26 AM, Luck, Tony wrote:
>> On 5/13/2024 5:21 PM, Tony Luck wrote:
>>> On Mon, May 13, 2024 at 11:53:17AM -0700, Reinette Chatre wrote:
>>>> On 5/13/2024 10:05 AM, Tony Luck wrote:
>>>>> On Fri, May 10, 2024 at 02:24:13PM -0700, Reinette Chatre wrote:
>>>>> Thanks for the review. Detailed comments below. But overall I'm
>>>>> going to split patch 7 into a bunch of smaller changes, each with
>>>>> a better commit message.
>>>>>
>>>>>> On 5/3/2024 1:33 PM, Tony Luck wrote:
>>>>>>
>>>>>> (Could you please start the changelog with some context?)
>>>>>>
>>>>>>> Add a field to the rdt_resource structure to track whether monitoring
>>>>>>> resources are tracked by hardware at a different scope (NODE) from
>>>>>>> the legacy L3 scope.
>>>>>>
>>>>>> This seems to describe @mon_scope that was introduced in patch #3?
>>>>>
>>>>> Not really. Patch #3 made the change so that control an monitor
>>>>> functions can have different scope. That's still needed as with SNC
>>>>> enabled the underlying data collection is at the node level for
>>>>> monitoring, while control stays at the L3 cache scope.
>>>>>
>>>>> This new field describes the legacy scope of monitoring, so that
>>>>> resctrl can provide correctly scoped monitor files for legacy
>>>>> applications that aren't aware of SNC. So I'm using this both
>>>>> to indicate when SNC is enabled (with mon_scope != mon_display_scope)
>>>>> or disabled (when they are the same).
>>>>
>>>> This seems to enforce the idea that these new additions aim to be
>>>> generic on the surface but the only goal is to support SNC.
>>>
>>> If you have some more ideas on how to make this more generic and
>>> less SNC specific I'm all ears.
>>
>> It may not end up being totally generic. It should not pretend to be
>> when it is not. It makes the flows difficult to follow when there are
>> these unexpected checks/quirks in what claims to be core code.
> 
> Do you want some sort of warning comments in pieces of code
> that are SNC specific?

I cannot think now where warnings will be appropriate but if you
find instances then please do. To start the quirks can at least be
documented. For example, "Only user of <feature> is SNC, which does
not require <custom> so simplify by <describe shortcut> ..."

> 
>>
>>>>>>>         }
>>>>>>> +
>>>>>>> +       return 0;
>>>>>>> +}
>>>>>>> +
>>>>>>> +static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>>>>>>> +                               struct rdt_mon_domain *d,
>>>>>>> +                               struct rdt_resource *r, struct rdtgroup *prgrp)
>>>>>>> +{
>>>>>>> +       struct kernfs_node *kn, *ckn;
>>>>>>> +       char name[32];
>>>>>>> +       bool do_sum;
>>>>>>> +       int ret;
>>>>>>> +
>>>>>>> +       do_sum = r->mon_scope != r->mon_display_scope;
>>>>>>> +       sprintf(name, "mon_%s_%02d", r->name, d->display_id);
>>>>>>> +       kn = kernfs_find_and_get_ns(parent_kn, name, NULL);
>>>>>>> +       if (!kn) {
>>>>>>> +               /* create the directory */
>>>>>>> +               kn = kernfs_create_dir(parent_kn, name, parent_kn->mode, prgrp);
>>>>>>> +               if (IS_ERR(kn))
>>>>>>> +                       return PTR_ERR(kn);
>>>>>>> +
>>>>>>> +               ret = rdtgroup_kn_set_ugid(kn);
>>>>>>> +               if (ret)
>>>>>>> +                       goto out_destroy;
>>>>>>> +               ret = mon_add_all_files(kn, d, r, prgrp, do_sum);
>>>>>>
>>>>>> This does not look right. If I understand correctly the private data
>>>>>> of these event files will have whichever mon domain came up first as
>>>>>> its domain id. That seems completely arbitrary and does not reflect
>>>>>> accurate state for this file. Since "do_sum" is essentially a "flag"
>>>>>> on how this file can be treated, can its "dom_id" not rather be
>>>>>> the "monitor scope domain id"? Could that not help to eliminate
>>>>>
>>>>> You are correct that this should be the "monitor scope domain id" rather
>>>>> than the first SNC domain that appears. I'll change to use that. I don't
>>>>> think it helps in removing the per-domain display_id.
>>>>
>>>> Wouldn't the file metadata then be the "display_id"?
>>>
>>> Yes. The metadata is the display_id for files that need to sum across
>>> SNC nodes, but the domain id for ones where no summation is needed.
>>
>> Right ... and there is a "sum" flag to tell which is which?
> 
> Yes. sum==0 means the domid field is the one and only domain to
> report for this resctrl monitor file. sum==1 means the domid field is
> the display_id - all domains with this display_id must be summed to
> provide the result to present to the user.
> 
> I've tried to capture that in the kerneldoc comment for struct mon_event.
> Here's what I'm planning to include in v18 (Outlook will probably mangle
> the formatting ... just imagine that the text lines up neatly):
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 49440f194253..3411557d761a 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -132,14 +132,19 @@ struct mon_evt {
>   *                     as kernfs private data
>   * @rid:               Resource id associated with the event file
>   * @evtid:             Event id associated with the event file
> - * @domid:             The domain to which the event file belongs
> + * @sum:               Set when event must be summed across multiple
> + *                     domains.
> + * @domid:             When @sum is zero this is the domain to which
> + *                     the event file belongs. When sum is one this
> + *                     is the display_id of all domains to be summed

Here is where I would like to understand why it cannot just be
"When sum is one this is the domain id of the scope at which (for which?)
the events must be summed." Although, you already mentioned this will be
clear in next posting.

>   * @u:                 Name of the bit fields struct
>   */
>  union mon_data_bits {
>         void *priv;
>         struct {
>                 unsigned int rid                : 10;
> -               enum resctrl_event_id evtid     : 8;
> +               enum resctrl_event_id evtid     : 7;
> +               unsigned int sum                : 1;
>                 unsigned int domid              : 14;
>         } u;
>  };
> 
> -Tony

Reinette
