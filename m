Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF9F257423
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 22:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764800846; cv=fail; b=d9UnlPrQm6hKVg5LZmjr4qfhxjhlrSdSCAmUuaNnP+aaPZN4S7oAePWvWzHIEAHdKO4qghbDZDCCyGm1wvZ93B6UeuxVEoopcg6SIiW6LNiug7Z0GeNmRkerO9r+skcLILIaKK4002Mz0uJPVfqdKuP4siiHhnL87BmSxVpvTck=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764800846; c=relaxed/simple;
	bh=RlphrM8RmjzcMl4l+tX+cUZHSBVDCGXFXd/Mt21tPDI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gCrfm5PKKjUkHspzaHts+EI+pdlfSNqvdiYsPjKrTz3kb6Yqec/2/eG7v36Z7H47vBoxI2fw40A2ByFHxMICDDemGyxyHgtB4uqPDmmu0Mr/UTwK3t2sbtA2DcZ2Q47bNNzW1Im8MNbITQ/0E77nAhxHyIdtwJmcWjeFr8nu+VQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fEafNz6p; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fEafNz6p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764800845; x=1796336845;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=RlphrM8RmjzcMl4l+tX+cUZHSBVDCGXFXd/Mt21tPDI=;
  b=fEafNz6pESDnQ1D2TcnAXbrkaE281qA7PCj+xWS5jsjj4CiSBf+xXYct
   WgRiErPVTlUDeI061mRSryOm+OYAPB7CuyevzphFiEkaeSt67EycrWLsM
   N/VihjZIeMi/xbu5K32ACwM7In0R68O2njZL9xkFjtQse5NAmfwQQZe1x
   /7iVjS73uNbcQqXVINjSFTTyNc47zwoPeNDCjBYX11fObahbvrcm0jK0J
   MoUbC5qIjzaqEMZevDY2K2m63hBh3w8zvrrfamPlPiJydoBLguyq+GUCO
   FPz2eleMOj9Y/ST1Nsqb9BkECIbziB/kK4O+rw8YdpPSwXGIepRqf+EzQ
   A==;
X-CSE-ConnectionGUID: GW2bIA7hQvKuUrskNZi4Sg==
X-CSE-MsgGUID: 4eq7Kf+SRqSa/mtgCEiiQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="66773809"
X-IronPort-AV: E=Sophos;i="6.20,247,1758610800"; 
   d="scan'208";a="66773809"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 14:27:24 -0800
X-CSE-ConnectionGUID: CSyiZNaCRxyOOLOGarQ0dw==
X-CSE-MsgGUID: 9lG/uXKTSDWB/nkIok4NDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,247,1758610800"; 
   d="scan'208";a="198980147"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 14:27:24 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 3 Dec 2025 14:27:23 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 3 Dec 2025 14:27:23 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.48) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 3 Dec 2025 14:27:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KaWSm2c/C78V4R443yU1hHQBdipGTQML+wd4u+kzEDWIoDhKoepbYhtKcgoPXAdSjFO+N9itINHT+g0kmykX+9vyHi09zKcnWIWArVGw8zD1iJkBHEGSw/um5+9qtpT3nYaOAaDmeOsS2CvB75706kLqyAAkYgI9TiaMR4W5RmyWtU2fp9Sn3joEjXJ1jWC54ka7ee1szir7aJOX4l1fQbeY2JjqUoBa1GfHmQt3iG21AAtU5nNPb1PRjway9jjp4UJ0qlCOnudkbS05KgpbUk+1u4wLxiARc95kMyYh1nqB221TzMBYHhtSVRpRT/2sFH7PINVjbJTMKZAX2oJ2tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X+HrFeR+P5mQH0xbNrlR4/JIk4Hj5tzBL0GvGZKlhOw=;
 b=fFPN0lwOF3HZuFwJvqjz59N0i39DadbYbMRrJKjOoo9JIIbQrwPvx/28bQPMjE6BWRIKi/pGzcyt2c8D0MLwC/DIKE3KWoXH4FBjwmckYi9sg2ZtK+JSU586hkucadsvlM3RuMZpJ3Q8oBad5J5LdiM4ZKDDw/k3J3Hh1ll7XqHwD5mLNTjOyxyvBbnShIwPgcXSG7bY7VdN4XDApHVs1quTfPcCW0AHhBt6gY6nFyKX1oEUeUGYSODeliXlTZIJ69OJ5Hta60tkYWOSLcGzt9XVRB4haRlqZWGeP5qoqnxgLdhtWUPYV1Eh5sFkm1RZOiyGTEELLMsU+uJcmDZx2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH7PR11MB8275.namprd11.prod.outlook.com (2603:10b6:510:1ae::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Wed, 3 Dec
 2025 22:27:18 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9366.012; Wed, 3 Dec 2025
 22:27:18 +0000
Date: Wed, 3 Dec 2025 14:27:16 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v14 24/32] x86/resctrl: Add energy/perf choices to rdt
 boot option
Message-ID: <aTC5ROCmAcQXNnec@agluck-desk3>
References: <20251124185412.24155-1-tony.luck@intel.com>
 <20251124185412.24155-25-tony.luck@intel.com>
 <ce70e96d-7960-4e00-bf26-8f61424e3171@intel.com>
 <aTB7rsMggy9nRgbR@agluck-desk3>
 <6fb0d504-b8f2-4b16-9d49-b97e41d8a697@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6fb0d504-b8f2-4b16-9d49-b97e41d8a697@intel.com>
X-ClientProxiedBy: BYAPR06CA0072.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::49) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|PH7PR11MB8275:EE_
X-MS-Office365-Filtering-Correlation-Id: db532a23-3134-488b-d519-08de32bb1e2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?XqHq8gnOIG0NUkG2Gc6f3m67rOYklC68X6Zj3DRECJt5BNK2brwnXbP9o/DY?=
 =?us-ascii?Q?CpR/mjEll07McCrNBNvDehY3N8XSGdIUgHGpSGSqKx/POf0qmZz8D4IgGHv/?=
 =?us-ascii?Q?trwkB6yvpHBtqoDuwo3IQXVZY/h1U9mUVZe9oFFE49NfDWz5hpBVYzs6C60B?=
 =?us-ascii?Q?ErtjvQLaSX4ik/kuk4t8Ytj9WoLo6SbLBPOrLNYM0HIqyfppBku3+B4MDac5?=
 =?us-ascii?Q?z32NST4NUHRJ2n+T2ht2DuQcMC0lK6t8vCzRZ+DZKZRKHDxw/LUEjEo4EM/r?=
 =?us-ascii?Q?nuaD/TylkEyfuYp8w0DPLSbin50941pwKKwY6B6NTNtpLEaMrqmfM91il3HU?=
 =?us-ascii?Q?xkmHefr8lGaZHiCpFECJeVvZpAKqCUrWpOa1DZAB3wFpbehD6f4f3HaIPxad?=
 =?us-ascii?Q?RPHcrPq5tZKtF5qPM7+MrOzpmpCwdjg+JRN/Es3Vpa9zAEBTfYjGIrG6V3CN?=
 =?us-ascii?Q?CCo4JjwbI1PEa4GkU+StdMj8pNZSUA0MLiPdba8FhGOAzEKKW4yVDSk2UmIN?=
 =?us-ascii?Q?nC2wPVRVAxRTDUp9obVnYov/wwffQjwrPh3Hyc+49IqXMiOne/t829O0wznx?=
 =?us-ascii?Q?0RkU33cpHp3QIEf4hB8EZ1+gRMsdKN2fVodOjW5e+1unqaJ7+Yt4GqAv2Lnr?=
 =?us-ascii?Q?1OKwlCW/C1sAvnnxX34kGv14iq6gra5PXOxMYDwMHg2PaPZe/UL1or5+Nyqw?=
 =?us-ascii?Q?eYD4b7akON9V8xVgTo4kPgDBXYkgd3oGeQaYZmIu/JSR18pFPIcXKqHGtS/M?=
 =?us-ascii?Q?JRk3f6nbPnORYgYjmZ+wVPgU12FxrlK8d1yfc22GnJD4q84SFwC9UmzcykH8?=
 =?us-ascii?Q?NCSDJ+8JSvw2f7Gsi7pFyqCWuKZJD5sBxqnnxV3tZL2s3ab26fKCcI7t3HPX?=
 =?us-ascii?Q?hLgoSKxvi9BUJbruGXGeW6zvn7FZtGqfAVKqTZiPesym3SkpJ87Zf8//+kCD?=
 =?us-ascii?Q?JNpCZFYxkNcS8uo0llV+fCZVS/RKVJG0cSF870HxccD3/ibagiLtdmc4NBNM?=
 =?us-ascii?Q?ljN5O3LaRUnkYuc+cCtDOBfBti9QNogcWYa3b7f5p4D7rLSY9VDB/oggLVfG?=
 =?us-ascii?Q?R9kQzoEpEBkSyyHpb1kP+MuT/irKvPzlHPdDPtVo0GCfaEiaY8BWX9vBrLvG?=
 =?us-ascii?Q?XLmXZRb1b07rkjd6Fmw3mLaAJR+V4eEWjELj9PWN/CgFG6WqxQfg4J2C84aw?=
 =?us-ascii?Q?RQ37JzXErg7G9nIqzPhv8PmK6gQCXG/DCdMrWg6IcoaN3TnRzz50yWc/cnCp?=
 =?us-ascii?Q?/Nn7RZjDplBdOH1kLOOSN1MIpXZrEuRgcQHXjKr1mt+bg980o/z4DBMibica?=
 =?us-ascii?Q?I1S8sH0WjRDzmylroLlctM7DZWHLtHqdj2c5UdH6/CSVzWbxbZ81QqPapwuF?=
 =?us-ascii?Q?KrD0rlWMRvEaGHbzPWpd/W5Ci7vqASgotZtwIEkuFEGO+jblnYqAfDJYdrpz?=
 =?us-ascii?Q?vq7y5O3bjrG0zJr+yOeSloHvsmvl7cDg?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ms6RWndnjIOoJxlrgPY9KiwcysUs7HlW8/oqM8HrWrqMaSL+fr89XSKRURtq?=
 =?us-ascii?Q?hyAJQTS40TiptjZcYhZMlGJoBSGaetBXQAjKBC0iGDjxzNSs/1KSiGbzpyQM?=
 =?us-ascii?Q?dk4p5vtd8CIustSGQyIGjSZGyCuq2hRubgymzzEajXk2qmS/joFwW9ZPLJTq?=
 =?us-ascii?Q?hypAZJb8HUfO1ZON40TUn4b3qqua6LFrT82wSJXvCNnjXueJOhGqpt0AQqRN?=
 =?us-ascii?Q?zkt2VE3N+PooNKQ3jBHs0rrjXxLEyrvQ7BoF4v+MtiFB6qZWrV10nV9cb2lo?=
 =?us-ascii?Q?kLNKrQgb3TZp7bvk85RQsTDGTdHUfg2vzvwQuOeXb1HGuRo8OcgueKXl6bWX?=
 =?us-ascii?Q?cg7wyIv1fp9PM6sH4Ld/t29wRIPmx5eYuD8gEjR/RVcZhU9cNzNYodE9dy5U?=
 =?us-ascii?Q?Ia8WaAgyXuVQgR6dzOltlaUb4a24jg7WrEh/rSigGW8K6NW+C4fStk71XaFi?=
 =?us-ascii?Q?wp+9LTpohgr/qd1/PsJYpqjaL7ckY/IHKJsnpJQcCVOXGEONQT261tZ4sjop?=
 =?us-ascii?Q?zo102iWiT1Kdj7OAGvG7XmWxCIhFhM8xBSBSbBwMYvVNM8sUZfgxO32gzmqt?=
 =?us-ascii?Q?FFX3CpOSYSk0S9yxdUdZ5Mee9ZyqPTEfeZd3mAoU2UcVTS91ZtWkTbF4DHiq?=
 =?us-ascii?Q?3LdRLsBmkX1tDeLyqhg/cwGWj4fYPQxvi7JUbcRyswR3KdwZk1j9uzsmciow?=
 =?us-ascii?Q?gvUAfAM7GKmJOQEqc4iC6XBE/tKOj5/y76TFYFkzWy4IMDX+8Tjmy8K0CVjr?=
 =?us-ascii?Q?Uza1qTDm9lJVqI7pJUgxDo1GtCrRV++sgnLFJlrrhzsSkqEoBshvTf2shGnU?=
 =?us-ascii?Q?bYY/7qLRGj6cAlCj1fTxnguNZGNWJp34qXsgpQxO/IO9qr8Io6QlCKyX6KMC?=
 =?us-ascii?Q?U3/V9cSOB66tuorHcZWjZu8ZhWZ2Viqbt/zV3lJ5p57O0Dv8OjsdodtL9s3E?=
 =?us-ascii?Q?fh9e4sLyACmm2nWfinRyppfFA26NjpaHDU1PJwqRNnSyczS+RGW4auQW3I4H?=
 =?us-ascii?Q?u5xQJ+dq+meYI4OIBmspb0/JEB7SK3+s9merSrvAO+gQTVebhYUh5JzVo+QF?=
 =?us-ascii?Q?a5/WEoyCeeKBJ06WFf8BYHzOJnXk2CgnO2t5F5tsYMBTrML6U+1Ucd3tjk2s?=
 =?us-ascii?Q?e5TIGs3q7kT/bKlPSLy+N/WUTN/e2kcob1fE3xa0OIFD5fZgQTPeUg2dYeAi?=
 =?us-ascii?Q?SZTrHY04kS/n3yC2xXZ8zJ5rCMpgvt99Zrcbnbj9NMwVXErWQO6BQVlLLR/o?=
 =?us-ascii?Q?FWBfpAWUJDExZwO6G+5Cq+I1vb2I0r0dckmRIYB0Idn5gwYHKnXtf6NzV4dt?=
 =?us-ascii?Q?6tBinPEfkQdQIDD+TbvIw6XxsAJCPjA/R960EtG5wj+2yfjNNf3LjZJpdsrG?=
 =?us-ascii?Q?j9IsMuvhxxvsWYe5idSl3HKTYQH7SvoCpHz5k9UZHHUPoiupxfdjxnOCsJRD?=
 =?us-ascii?Q?LyIt7zKSNHUdb66DR1ItFnpAg0+bxBDC3kFOaNqzxc/q7P5eVabsOi6+nNFp?=
 =?us-ascii?Q?dutJdt9wv8/OPDcXFwV3Ag+puYjWr9rhut+kYGdrU2OOZamW23NNhxQ/4L2p?=
 =?us-ascii?Q?wnVNfYu4okXPBp+OWVr2UU4045diw62DRTcYgHmg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: db532a23-3134-488b-d519-08de32bb1e2b
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2025 22:27:18.0975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PTilbGnuFPZXtzjrkffk5eMsWVd7S6xk+l/IP2hA6QmJ71yen2Q4bx+Gf3oOSD2pUUutptVsocegQBLLhixCOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8275
X-OriginatorOrg: intel.com

On Wed, Dec 03, 2025 at 01:21:56PM -0800, Reinette Chatre wrote:
> Hi Tony,
> 
> On 12/3/25 10:04 AM, Luck, Tony wrote:
> > On Tue, Dec 02, 2025 at 08:28:56AM -0800, Reinette Chatre wrote:
> >>> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> >>> index 46c64419ec10..50c8b4c50790 100644
> >>> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> >>> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> >>> @@ -57,12 +57,16 @@ struct pmt_event {
> >>>   * struct event_group - Events with the same feature type ("energy" or "perf") and guid.
> >>>   * @feature:		Type of events, for example FEATURE_PER_RMID_PERF_TELEM or
> >>>   *			FEATURE_PER_RMID_ENERGY_TELEM, in this group.
> >>> + * @name:		Name for this group (used by boot rdt= option)
> >>
> >> This needs a new definition since multiple groups can have the same name now.
> > 
> > How about this:
> > 
> >  * @type:               Type (energy or perf) of this group.
> 
> I find this to be confusing when considering it together with existing @feature and its
> definition that also refers to itself as a "type" using perf and energy terms.

Agreed. The two fields duplicate the same basic function.

> > 
> > That covers how different instances have the same string where "name"
> > was confusing.
> > 
> Essentially this is the name used for @feature and for this there is already
> pmt_feature_names[]. Is it needed to create a new name? This would mean that the
> kernel parameters become "per_rmid_energy_telemetry" and "per_rmid_perf_telemetry" which
> is much longer though. The only limiting factor I am aware of is the command line size which
> is defined in arch/x86/include/asm/setup.h as 2048. Here I do not know if there are customs on
> whether kernel parameters need to be brief or not ... some kernel parameters seem to be quite
> verbose while others are cryptic.

Personally I prefer brief names (as it isn't always possible to cut and
paste to a remote serial console window to add them in grub edit mode).
> 
> The safest may be to stick with the separate names but I am curious about your opinion.

Short names are good.

> Even so, it seems unnecessary to force each new instance of struct event_group to
> set a parameter that is required to be of particular value based on value of event_group::feature.
> If not using pmt_feature_names[] then intel_aet.c could have its own private array
> that maps pmt_feature_id to "energy" or "perf". I find that doing so would make it obvious
> what this property is/should be.
> 
> What do you think?

I agree with one value and a mapping function. But I'm using the string
name eight times, and the event_group::feature just once.  So I think
I'd like to keep the string name in the structure, and just do a lookup
of the enum in order to call intel_pmt_get_regions_by_feature().

So new proposal. New name event_group::pfname for the string:

 @pfname:            PMT feature type (energy or perf) of this event group.

static enum pmt_feature_id lookup_pfid(char *pfname)
{
	if (!strcmp(pfname, "energy"))
		return FEATURE_PER_RMID_ENERGY_TELEM;
	else if (!strcmp(pfname, "perf"))
		return FEATURE_PER_RMID_PERF_TELEM;

	pr_warn("Unknown PMT feature name '%s'\n", pfname);

	return FEATURE_INVALID;
}

There are only two options, and no sign of additional ones. So this
if/else style seems simplest, rather than creating a lookup table to
iterate through looking for the feature name.

-Tony
