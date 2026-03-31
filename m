Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8670E3176E0
	for <patches@lists.linux.dev>; Tue, 31 Mar 2026 17:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774978780; cv=fail; b=O2CXFuJTFnvK+PXKirOOy1zkJvSUu9meV2Uao5a+1ubwZoZZWNsvKRP9CV5+x2W+kwXMFxWr9Uvkqwu9WdGu4QwpKURcpnjDtRJtCkWZW/tv6gi5m1pkJs0/Xhcl0iSXoQjgOvBuNgN/7Jk8jeyoDmZbP9jsfDvvElUFuT6ydRU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774978780; c=relaxed/simple;
	bh=1vzcXGnxmejfMybaOwOX230NIHsSlAkZuDaH/d/Ws0k=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=T2rRwWX5rjF4CnlbGsT/wnUL70F6aCDfM0TYP76CZ/H1iVTzEHwaG0AWhpJpelrBMqULwqTuD2+ntfPtg+lcU9u2yvYgD/h8KL2e1fTVtvALCjHMBod9J9DkRGruTCyPecGOg7PeofyW1wsEN/kEgfWBY5Gr4fMCH7LfnIxsAW0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=groX/zkU; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="groX/zkU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774978779; x=1806514779;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=1vzcXGnxmejfMybaOwOX230NIHsSlAkZuDaH/d/Ws0k=;
  b=groX/zkUrXQAcOmWH4GUfLaCL3eB5gajgNqOBzFs6h4NUWAxGCb8oMPz
   0Fr5XytVgjhmpwueha9TImnAamUsdXW4bcOEhe9uYs2dajZkTJi3mMT4z
   RKgWPRB6clGuuHJE/hS3YX+GpfEbnKm2KQbBoVVCzXDBjZiwGv0KYYz2i
   +WewSjgsf9HA8NvkaSogwCXnlSdIPEZACNO/bGAEyHu5g2JBEZ1oHhrDX
   MsDTddnR7ZBf+BKQkFm0NuABtDimmcn5cNCh3szY0KGzDF/m/hAUngbDz
   mohATv/B1r7YhTWXgvOnJM6j1gRxAGq4maEn1h3BaIgztN+U+s2wbggeZ
   Q==;
X-CSE-ConnectionGUID: 54Y1xmwrSfarswXBkvLl7Q==
X-CSE-MsgGUID: kg5IEYg/Q7ul0CrreKp84A==
X-IronPort-AV: E=McAfee;i="6800,10657,11745"; a="75036524"
X-IronPort-AV: E=Sophos;i="6.23,152,1770624000"; 
   d="scan'208";a="75036524"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 10:39:33 -0700
X-CSE-ConnectionGUID: zN9jH5lwSy6QehU0+48ybg==
X-CSE-MsgGUID: gqnuWgbFQpijLt+Ilt2wsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,152,1770624000"; 
   d="scan'208";a="225432657"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 10:39:33 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 31 Mar 2026 10:39:32 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 31 Mar 2026 10:39:32 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.64) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 31 Mar 2026 10:39:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Am5NWE41jIA/ohrkOuH61MTJoxXzzql8EUm63/jpajYr0NcFKhE9mp7LbPrIjxOWrl/NA/d0xCnYwTjbvVPehweepntZBWTISazEdKuSHA2a+1ZiAdZH5HHHMWn9bvQC+WTwC7X3BNcSKFKiVnDxFUrsxRMuD+/rgF3nobiYDPZoc7lppwdLwuLc/mdwmEo0ddBaERe4nSPuLGAuaUQHnST46+VAHc9EV6tY+5LFIXI+qV1Mb8TU2aM2rla5+7ZUHCMO1E+fBtNJ40WK8hsp45/GEm0geP0hrc1OTvxieFv6Tiv25q08Rn8QhlKEsD1KUn4l9ZGJWiWuPcLZFClgDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bXnio/tus3y7KMhCdd5q/pSA6eTievQ9uSjcl8mPDVM=;
 b=TeRQx3B3YmpwjkxdWHqy53AQ8DB7qU97fwzvNJu9gwHCAH3ZRy3UK4zyf2cl+R/qbTxt3WEkWQEP8hC1/pANtOQ2r/noLwutiwefW3TZFwsB7kF5gs92LyIO/xs0JfNzaR7EGKiB/jcihIpiDdPWXx5OjyYK4HflEnBKxkikbWrCa/RA1W2b7Ej+0UrV/OHwwmgXybxfl/Ez2zbQMBi61u+FJIOYlf6MrLLmRwSfyq4unsMH5RuYyLCKPZQ1z8seKjSYHg881lnAaucUzV1FGEopgpX0GhEKrBqdSBslAoupQtk47muxQETFXzmZqeXa4FOLhH4cQpAv60JM4m85Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by CY5PR11MB6438.namprd11.prod.outlook.com
 (2603:10b6:930:35::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 31 Mar
 2026 17:39:29 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::7d4b:a049:aed5:d2b0]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::7d4b:a049:aed5:d2b0%8]) with mapi id 15.20.9723.018; Tue, 31 Mar 2026
 17:39:29 +0000
Date: Tue, 31 Mar 2026 12:43:23 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, <dave.jiang@intel.com>
CC: <patches@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<alison.schofield@intel.com>, <Smita.KoralahalliChannabasappa@amd.com>
Subject: Re: [PATCH 8/9] tools/testing/cxl: Simulate auto-assembly failure
Message-ID: <69cc07bb84547_17924f10089@iweiny-mobl.notmuch>
References: <20260327052821.440749-1-dan.j.williams@intel.com>
 <20260327052821.440749-9-dan.j.williams@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260327052821.440749-9-dan.j.williams@intel.com>
X-ClientProxiedBy: MW4PR02CA0025.namprd02.prod.outlook.com
 (2603:10b6:303:16d::11) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|CY5PR11MB6438:EE_
X-MS-Office365-Filtering-Correlation-Id: 28f4730c-c46e-4365-0a9d-08de8f4c75b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info: wG8WF5BggtrhC/QnInMTrRmJsPL3jHFnzCwYlGE6Nq0F7KP9VTO5nEJtUW8J8gcVu5In0vBv8wcRwV+Gojd5i1ZfZqjnnWgkdqZhpLMPVS0evZW/ONPBUawOTgn4WRrOlJnognHYlHVT/Jc4NcUJ8ZTD+iECrHQrqejvdo99DqJShgyjB0byD1oEK35lzyJyBgJ0K3jAxdclroXZWKtwxqoKgfjsQGvkvKbeaS5cGTNvL10SW23nX5yVTpvr0e7A2gGo02ajNhxSK+fDjSrVzYSJUAt9e+iIuJq8h2TRRMyQnM/Spwch00B2RHdMhmHeMrSFy2DL3VDjlvr+J3dGfquETvkyl0G8lsoXB9ktw6pn64pv/Ek61TDcJEj5bkEHGEvdHjBIi7PArzXQ4GzlKCB9ckyhPpu+Kf9hB3nBBNMxc5VG2x1/oNPAKmqZYiP9GJBwlsBFtrLtUcBoqG40MupOXPvv28wQZGbdo6VmxeGtbDXGgiKGATMOPOsG53Jioyo2c124RSHjNJSgEC3BLLZ+AUfLe6ibH5pv6umf01IKEKt2FIxlXC5Zb9Srn2sf0X7rbnys1nAIfE62qeFr41D5c4/I76buPWGh86dy3jfkmAc5AK5Gh0O+OY3SCzKNJWAFTBfWWqPKiK6sr8fSkhZdd1ifhIHEJIYN0SN+4+V9NUljz4FwtEXsvJGXmo9cHKTg3NGRf1h55qtdjUcrjvTejSQDp/9cR2rEp7Gse+s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Sm2lc5x6jRdZ7HNKjG9l7h9+f937wIjdafXr2s035fe+k66XD6uiXDbhhXR+?=
 =?us-ascii?Q?SST7A1qgGodwxO0+nYQAYgFxJJsRpntyr4ZQriULh0jB/TW1mDSh6A2KjB45?=
 =?us-ascii?Q?s2FPtu35ykqkafEzTbjLyNNL10XzMc6HM4+2UC4DiH1w1AkK+ffpL0ZLX4X7?=
 =?us-ascii?Q?xKgsuGITJFGVUhJ9NhB/xSCS4QjNK09+8LX8HB/xPpPrZ5EzOSXq/BXYjDVw?=
 =?us-ascii?Q?pbnTdzFYh7W5E34mmsEzTQWiafRqsCYqp1afnSyzQJqZgAK++eSNAS7+Q4Dh?=
 =?us-ascii?Q?gPu40Qmi0+yPNBBvRy3nZMwgKpNY1AifXcbFbGbvCvbRgmqKh9N6iKBg4hAr?=
 =?us-ascii?Q?K6NYU39r7TB4Sj5cZ99TsIIXHQrgoNa/WDwkBjTk8b789jnTI5NVy81qVvc7?=
 =?us-ascii?Q?cOIW3Bl8ms0Sm2/SVOTp56UYjr5TMIs5qNQDidUZFh+bNXpGATdNkIIMF0sy?=
 =?us-ascii?Q?fzm8omRxb2AoFti29w25YbA55ViEK/Y90bEk4g2W/fb5691yrfrxE5EG7m50?=
 =?us-ascii?Q?9ASajhrl5H+2nhr/Gspny+M3OtnkXap6toZkZ8fBkEhzGIb1j0lIAhCF3yTK?=
 =?us-ascii?Q?Nk09RLcEe2GP8kFLYPCp5DQDKWgRuu+qJQDT3Jlxrfpu7MTGYRR6yGN+cAgm?=
 =?us-ascii?Q?zH3JVMiVKTgQFvZGjYv8ct6mE4IeWfTCj4NGNkJzJxlHiCnNJT99zhMBOKvo?=
 =?us-ascii?Q?UGHaP1E9NlglEk4nvJFjx1VG0tJevoRTm+FCgbvi32X13NXwJVGkFGozdYF/?=
 =?us-ascii?Q?s2VESLDa2owFaEHJkMQKzgaqnxXjIs88S9WlFsQ9oogbgRGZoQkvoWF0jfSd?=
 =?us-ascii?Q?YfxBfMaEKu/t1fD8T5skn7VpkysMb8X6BRysSir9DoqpV1V6TC6mWGIWYWqc?=
 =?us-ascii?Q?NLlG4bwb5n8YR4GL/rZMndGVPDU0QNU/kzD7g4t/ghXM/9m+uMFoSy8Cd3IB?=
 =?us-ascii?Q?UuL6cWVw1K+Sq2PUc/r9aLS59yuNi3mZNAJ4fbT6iRPN3S+GV4HE3vo2efhC?=
 =?us-ascii?Q?+xIGYkSHahqhDMRJL15CWNivBBb7FFKFPKI9ZIcU2+9NYz9kRbtYIf5sj+cA?=
 =?us-ascii?Q?+s9dzVaj+lBX8oYL/Xv0IZrskGA0r3mhpmp/V0dfoZ8pp/Gck11p8wKpAMIZ?=
 =?us-ascii?Q?xsHXv9tO96JWzMPOXaHwY0B518AT7rw7cO6J4HGj4G98cUFd35LgrInutMkx?=
 =?us-ascii?Q?hg7VHz/hnCgNoaozLhgxEWR/FrIec7hBJrri51LV4Ht3rhbf6wPVcJKO6pvq?=
 =?us-ascii?Q?IYLoXxvN8iRxeXMzwulv8VK1n4Ie9xmCYahbkkg6vBspYMl952uz4PoggHwX?=
 =?us-ascii?Q?5vzL0UiNWjPtsrlE8d12Q5LJxPXk1Wpbo4y/wRWB9d/pulCv1PmQCcgI6jlA?=
 =?us-ascii?Q?qvquNzkAYh0ZzLBEm+HMQ0JSGmvZgEz5Obc84oU8qCod/6Tq1FqLPLvTRsF2?=
 =?us-ascii?Q?w4QKcc8aPknMwatFS5SEh62U90h5qNCEykMqQxrg3ffJMco8PnWSLKPuhEAI?=
 =?us-ascii?Q?4hqMWMZO3KVdF+2TE27L5JcJdJBAPQYyFBO11WCLBrCrki+KdcU46VB9gyp9?=
 =?us-ascii?Q?+kIU08gVphkmK698v2RhyhFeMgai6CROsDEPRR7biQL6YibjOvM8dESZzqjX?=
 =?us-ascii?Q?e9nTxFb/4XztChHQh4dWsHwZ0FX805+l8IO7m1HPrbdtpWUDiTcC+mATB73O?=
 =?us-ascii?Q?36pt4MeupwEzMwEYLCT7KMSNh2fdXAIPYZJZtlSilW0GGe4xrjaOZkcia5Ll?=
 =?us-ascii?Q?cUuUx92D9g=3D=3D?=
X-Exchange-RoutingPolicyChecked: LMVMozPmOxarbGLcqwwRJO6qlH882/ivRNaDFqRAKsZz953VuMoked30R/bIslv6ABgHOpMMtjCXvOsdZwdIS3IlLnfUSQIop0UjO9ifoH9ESatokC4b7QzQP+GN68CMv4BmbjO8SekysjSeAHqxZDAE1X4jLRhcYTb+RUCZMUNSlyc22dvRhN9sjizvPnicBnXVtl1Zxpvxth5Nm7RUFfGtzx/OXm+cg4fk68Qt4ujVniiPs1v052Q4oN/unuIks+kXtMeCFf29gsGoQSQZCB/Zp1PD3lq9h+i98p2N4pz3EfqqeCUEU9uUHJUjTRzEUwB9SUcJ8SqY2J+9VFx7AQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 28f4730c-c46e-4365-0a9d-08de8f4c75b8
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 17:39:29.0208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hMLzjjtziIGpliAp50Fkp+3oSjGufSjiOonPyHEPkB0dkadDot5wjqBOo1LA744enpPl9mkOnHZSCS7ZKly6fA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6438
X-OriginatorOrg: intel.com

Dan Williams wrote:
> Add a cxl_test module option to skip setting up one of the members of the
> default auto-assembled region.
> 
> This simulates a device failing between firmware setup and OS boot, or
> region configuration interrupted by an event like kexec.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]
