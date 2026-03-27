Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F57364940
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 23:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774655095; cv=fail; b=a3oQn/wu1sdoEvXwihWHP7e9XL5DhZeFO+aZllky52tEjlpMvzl0cIqFOndlQwsTB/NkZxEdR9k8Sbq7nM4jEf+kJimU5ug9bWKlN635lq5Ku+5gXEHiCKgTREqL3bK0cqMv0j5IkfFnmRD3wHP18FGHSbrWnTA/mrBr8l8l5xA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774655095; c=relaxed/simple;
	bh=eczL7kf6qmsDb+HBnwtx2n4YYpSAPebIXIA/4Bz/TZA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=H81ctsk4J6t1vsE1XEsXQA8f3cbUl6ekKub+E2XsPCHWhg6z98aAgaMMgvoVG0BHSEsrdQMglbpoF0oORjKztElDXmMnZakEz2MJqn+OlGKg48C7s0Z/brLOViQGaZVqrrclwZgimU/IJVZlfsDSnVVsQSBdg1UtdM0ulgfidVY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R3/9MIvm; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R3/9MIvm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774655093; x=1806191093;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=eczL7kf6qmsDb+HBnwtx2n4YYpSAPebIXIA/4Bz/TZA=;
  b=R3/9MIvmvlcuZsyVAJGuyD6GAcWU03avXrfr2/cPmNuH2cl6Nem7j2u/
   mGF4HSBIOD8pAzYB5TkzOxLdd5yc4s1krpGPzDTU/5k9dBXMg7bPXI+0S
   x6zxFvSqz1/SsbwYeHPHSlsKwCZtsONiZsQR/gz6YzyffBhvz7iCW9NEc
   bTIiTU2QUdoT2OUSAXNxqGCmk89HGok+XZ9w7cG09Awkb6TOJ/dwK+zi4
   9QO4pw19v2SHQlg0VAFYGYaHSaYk4EQQtoO6Ei/McaMZrKSsO9/J4MXLC
   Cw5z+fSapUuXBAkwkXJB5R3rcFwOlzCtcwYy7jELDfpdhUw97VYBcDBmt
   g==;
X-CSE-ConnectionGUID: jGmc7QDISUyhxK9Yqio6vA==
X-CSE-MsgGUID: oHwnX5S6RMWNsOIKYzqk9Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="75849358"
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="75849358"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:44:53 -0700
X-CSE-ConnectionGUID: dkfw9Qq+TFyTuMHNrwWtwQ==
X-CSE-MsgGUID: OJ8yvehfSzyLpP0MQwGBqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="229526312"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:44:51 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 16:44:50 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 27 Mar 2026 16:44:50 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.71) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 16:44:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mKFvZPSbCIfl2BO1pESQtxWlo7Z98NjR/wLcjpBBF5o/rWJFztaaYfHjXpNDjsWetU+7+kPyKgy0jZAti2q/CwPyAAQY407ENKpEnuRM9Oq6nG9T+D80tygiBa/k3NFJ60TxtukrJHYCNWEBXmlQXfi9dDfsrJJeBVglzxEq20HyxtW8UyeVdDmT7YJrlYW4GtIgu5HbA10UNvUCO021zrbtq9qZWVlzq88DPnZi4UxcvsVwphSV4kxJttWcHuQO7W4foD2+z7xWPkNIukVljKITyw8+WYlS1Uk4dLXpLNTPMy6U/lQ0ryS+d+Di2dXujhA9yj9MngIQZm06jGe2hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=98Yw+D1wIHX9kXNuJIDCCCR0wIiCv9pGUCetuWhXL0w=;
 b=XVPqDX7EbJOn71BRJm/ju/K6vy11DWT6zBkY7tKfYnFej4jU5yCYkB8rBzn9+Jq8ubXmQwiV+59Fm02Dco1dyqWvdLRpzks7IMw6PWKPXtxtAil0586PNImwP1cgeXkU6hNA/pxIGIDviRzUcQwrSUZEcjUzb2GV+H+VMT8beO9lotQfUwQrmiUl33ND3plyipsff8Avkjy9M980JfkOMmQSh9JiaYVVdghIDqw4kQkZ51zc3fFns1L3Q+c8ZhTdTZuzdIj9mx6N36TtdASJ1GFAGBkgE1kfIPVNyc3/4D5KMJNMXoO9NGoJG6qv04afoh2iVLrv6AxnrJtjJpl3xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA1PR11MB8254.namprd11.prod.outlook.com (2603:10b6:806:251::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 23:44:43 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026%7]) with mapi id 15.20.9745.019; Fri, 27 Mar 2026
 23:44:43 +0000
Date: Fri, 27 Mar 2026 16:44:39 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <dave.jiang@intel.com>, <patches@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, <Smita.KoralahalliChannabasappa@amd.com>
Subject: Re: [PATCH 2/9] dax/cxl: Fix HMEM dependencies
Message-ID: <accWZ6Io3QtoYH0m@aschofie-mobl2.lan>
References: <20260327052821.440749-1-dan.j.williams@intel.com>
 <20260327052821.440749-3-dan.j.williams@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260327052821.440749-3-dan.j.williams@intel.com>
X-ClientProxiedBy: SJ0PR03CA0050.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::25) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA1PR11MB8254:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ffef332-b781-4ed7-5609-08de8c5ad1f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info: gicokmnZHgnQjUGqsWxXtQ3T4Wk8lxEFtho3+MeQ7V6Q/D2OFz2mKe2AQvsaWwfbDyUvaPpJHN2/ChQKZx6g3m9eBnqOM0LVM2NQxCutxd8FUzGsPtBjcBFGkwUHIvX/nbGxWLuEUMlxvRxULpOEbRAPBIxLnrcwC4PHh1fQ4fRacEaANE1cKaImJtTOrgLLZ6/08kngVJzXGL1YG8Rum2tqXvnaM7ucyrHQH2+rfNOdzIUvWHxQTGaB98UQ3tv7I7q7AqnyGL8CqWRImsQbsYbhJc2u+pRopERtVIbc7pp72+CifdOWGfy6yF5XEXzRfbBfMQA59265sVDthyyMvnf1Fn1b3BHCatZObe7UezgrYjK3UNAoWJvy/T1rsOScPTu4y1PiEF6jqiUUkNTxfEq6nzPhYVA2GHxaXa08VSjAOVSSTfoS5pWA9yR42817PjKljW7z4MfG4aC8YCt+z4ytLJX1pN1b9HmEKthsvt5sqDPPLH1SQijvl+7E8fclFELB6YSgyy+2xtswoC0e+W/Z9ON2o9bfNxryuYlj8qkOFmoaS+mBLWlnwEXr1QhxTCHs/o6m2PVizu0aAydHvfQ0yz/aJvgJ+peyOEp2Co7nUJo1Ge1vXw88dO3O/8f27Ggv9b+OZNTGNWCuTcGN6sFi0UZYvY+0rH7K9N9TrYKhkSMt2CkZ8ZZp0KcqfSXswR/ODhR4J7jiSp20Rcy3jQHV7jeHPfQfyinzvyMlSg8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?myFXm/L3GWx1iAi1ndcXr3d24AnBqHpF5NL9xr4S4cMNlapGHwoKTbUc+fqa?=
 =?us-ascii?Q?5U0v770AcSG+mZWk0d7OgBEYhGpWlepx+1GS+8NpJ6lFjmO93Q8M9DAjgKx+?=
 =?us-ascii?Q?xrRHWdLldgOHYsRapR2lg7q8/NdkKLb95if3J8KdqdFlSPqYaH48cVIF5OqF?=
 =?us-ascii?Q?q4v8aipRXG12MG3eTSp+w++O/mOerZ4SAEjengRsONjr6xwBHS9ksmoi1svO?=
 =?us-ascii?Q?Og9IrtCetl25B/eTQuX0/lUKnNGclbmzK+xfloooUYvyWKj40UxhfZRrNwSH?=
 =?us-ascii?Q?hU2cYpsnFotuRpRrf1MryWorpwbKuhRXjr4Yp+AmQirJD62dWPJfHUHSnfat?=
 =?us-ascii?Q?Z5hCwFxi4H/94fMktP9PkPiypXxDG8Y43NNVrI/hTT8lMaSwJmEzyfTgpuiM?=
 =?us-ascii?Q?1GQ/S47LEyc9MfmGC1AUSOmeBOllpeKOqZFU7Jfk0Mn4xW8yKPWUVVChbZhe?=
 =?us-ascii?Q?umET2SHILZ5Bpl4vsGl5a3OcQCrpwiwT/l0zYKbRwov3nUFS0kQyGksNsYHV?=
 =?us-ascii?Q?0lKsYXv64lfFfiOnWOg3uRNeXi//Pt6BYUCOK+ZMvKP8bH3egof+IvAVCncj?=
 =?us-ascii?Q?rG736Y1dvLdRU/NNAXrkR7V9npqM3dJAkyJIFoSz2KRrs2R0/ATYk25H0A6z?=
 =?us-ascii?Q?oY33qOAaTNN/M22qHrRaglqY8Ex0v1isCEqSQFrLyW5b33Lw2zk7LNZBW/ej?=
 =?us-ascii?Q?at1PnLttBRrNMQuIqdHGpq3En7jrHiiUBeprQaoyarGNyhSqujmHjOoYuylO?=
 =?us-ascii?Q?xR9EzCu6GCq4+9a74m15u3hl5gjUxJfcprQlewqAhjs71H61M1n4476VHsF8?=
 =?us-ascii?Q?E/phLPlWM3xMd0jgd862xmU3x5F6wEYfp8F21uERPTwLKdCcHliiu5ZlrtW+?=
 =?us-ascii?Q?7+GOp+2XiK9g5eoSpFJHJIxGLGvrigjmyZtOO2UcLtmTHk1fqwDB1rA7s1wa?=
 =?us-ascii?Q?ErMj/jlVEknoC8hPz4e56zNhOwQHfZubhgKzQXYT36r8uZ4NdKivSjw+dh2+?=
 =?us-ascii?Q?494e6BznTFJDUE4dotJ5VWCEE1j9qYXJEdVs3Mx7r1y3PPjkFOqGMrbvU7jW?=
 =?us-ascii?Q?GWEMu+7fQoU7dEGn+67Bs9MbuSGscAO+00CFUpT0GGNP2gyKXxjZYzVaswCQ?=
 =?us-ascii?Q?Lcsi5ZiUA7DKCbGqIKKseLu/WJSX7eZ8qU+CKRMSm5gLB3wlVHsdqThni0cm?=
 =?us-ascii?Q?8crI7bqhp0soDadzP6KiMq97lmNpehFMBXylUlH0aLboQcqSQQgSe4qKkXMX?=
 =?us-ascii?Q?Uvu1MISCTlsIXoz67TflhWhXwOZZ1Q55hVOM40Pn1Tc773OpHAQIZVZXRj6M?=
 =?us-ascii?Q?F0QRbv0tORHfduUPeoS8JeNVlHn523DbidiH8Qol5jPO37yTbCuO3+xwMGwG?=
 =?us-ascii?Q?aKGk8uzQ7NGP7x5gw9o6+wNOdaYOzMMmFm7jrxSey98CqSYOFtZekYpHHNnb?=
 =?us-ascii?Q?1X7DcvD6ZYsoW4nsLuD7gpSejv6v6jYVMiDjBxqXuewqmvvWr4QyepfKurMO?=
 =?us-ascii?Q?3Ig9BsMlU+3WUeP/G9wKtXObPkFeJHseSrFMwdyywo/G/395MHIF0NnzkjQA?=
 =?us-ascii?Q?GK36KHIKlJ6WeKhlFsvh87W435rxu3AvDhXJcK19FOgWWO+xXLjJ5rShkUN5?=
 =?us-ascii?Q?Pp8bBYhsOZvXBqsHBx4YxFWcKjRsNSezb8Bcb9KmcLoyRU2tmHI0E+lezXqo?=
 =?us-ascii?Q?Ug9qUs3xPp9kinrEjaJDp4D+kcJnBUETp7kwCmtTLhCGTLghYMeuKPjDpmFS?=
 =?us-ascii?Q?ZzxIBH9U3bVG/2XaDOvxkhVuaG7P9d4=3D?=
X-Exchange-RoutingPolicyChecked: SnWbW2D7VKnv9A4+Ru0NzJwNsQ/6ypowzmta4Co5qT63KrSXaAxoysTXI2BRqSzubt47lHhPdyf5HjCgwBphkA2HWEGMoak/mWXD4ttFFUH2O8YoY/BZyt7SsKgRlPocEh+fZD3qZBRYGSitjgLvfnR9pdwz9iTP5qDPMOdE4uQKPBUwumv7gHIScupvaU5d+rcvaEZpLw/1YmZC03RffgiIH1FCrzC5Gmb/cqFG2tI44OWKOcBcVxWggQl0nhwONgHolsjFmQvm0DYuG0/o8LJ57GYixUJwMEGXeqj8bbgpO5iRvtI+sDxygaPMmikzMzaqHJQGvqLz03S1QGNA9A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ffef332-b781-4ed7-5609-08de8c5ad1f4
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 23:44:43.1860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GjBT1Md56CBozfP4d3BWHrlmqMyLKidEVo/ar+0p7ACjHJx2pdad35ukdFdpEHj6nd8b6fntCuDxTCfePN6m8Hy396xqBOJYqSJ5+HUy5ZM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8254
X-OriginatorOrg: intel.com

On Thu, Mar 26, 2026 at 10:28:14PM -0700, Dan Williams wrote:
> The expectation is that DEV_DAX_HMEM=y should be disallowed if any of
> CXL_ACPI, or CXL_PCI are set =m. Also DEV_DAX_CXL=y should be disallowed if
> DEV_DAX_HMEM=m. Use "$config || !$config" syntax for each dependency.
> Otherwise, the invalid DEV_DAX_HMEM=m && DEV_DAX_CXL=y configuration is
> allowed.
> 
> Lastly, dax_hmem depends on the availability of the
> cxl_region_contains_resource() symbol published by the cxl_core.ko module.
> So, also prevent DEV_DAX_HMEM from being built-in when the cxl_core module
> is not built-in.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

