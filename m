Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0638B78283
	for <patches@lists.linux.dev>; Wed, 22 May 2024 21:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716412542; cv=fail; b=sCN1+FFBN7YGTaFpO85w2owHFurl4I+SNkexAuwzFxgQLxiHsL8C4M3LVv1Z+G0wYeaFvQltuTy2h/fY5eWppOAk9Q2kgDBjkT4CwdMf7WHLTKPp9TNG9VN2EK1Lr/LtpOJvjOk2eodSJrC36LgvpBw/pafFNt3870hB6fgTho8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716412542; c=relaxed/simple;
	bh=9PhlJuHhX8evA66HEglYjC0u3QMqsTV4ohXes4WqwRU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CCbxeAuTYM5i2Xmux55Ms/PAp/njny3MJyJ2GfjPsbGvzSlQ3vTqYWwwuE41ss+Ady4dAVl/D7hBYrhObay5zoY9NaWGPR3tVlGGUA6G6v+N5EV4mL8TPud8a6ijcqXn1rKwDIuEKObeBIW3EbPk7Uegbxes96xlVgG/aCGbMa0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L7AcvChd; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L7AcvChd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716412541; x=1747948541;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9PhlJuHhX8evA66HEglYjC0u3QMqsTV4ohXes4WqwRU=;
  b=L7AcvChdNynGnC+72ikj77jcI+vUn8Mf63GsYWshGdldJe0b7NpnN0G+
   yxjiGne9vHCbAuiK8xZaxsQRk3ThU2C9NEjWbq2NtRYtj1mJI6GZcLkvo
   ZGBodopBa5UZn7xrLxHr7qiZSp+QLAsMD0rfr9IOtOSKxyXCdXuCiXFdZ
   rfCAm9C+GddloU6nSGhvSqffkRGGoWLp697geFSeRu+srYJbZUF4z4HyO
   EANDNQ47vvGTU328pW61RelnetCEj5QJDtF4iUi3k+3kTQV9Obylm0iHN
   RlHJjctJWq6hwd6sx86cj8H9KAFt4CHJtqCWi/kwixQXLDognwUZgYha1
   A==;
X-CSE-ConnectionGUID: E7+Bka+zQVSwiCUCy2aPUw==
X-CSE-MsgGUID: 2iZP16j7R8aL89dOOdNRtQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="35205642"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="35205642"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 14:15:41 -0700
X-CSE-ConnectionGUID: ZrueFlVCRliCw8B72fj2tA==
X-CSE-MsgGUID: 4A6HYlXwStSSYnG4LI8vqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="70821892"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 14:15:40 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 14:15:40 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 14:15:40 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 14:15:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dxq5rT6Rqo6+JerRkGdHdXGIXlBjQYvvjqSeHtWWSOacSf84sn3AAr2VJ4Ii5z3mH40208PM3G7MUxfg/muGs4C46tqWSY/F+vFs4/XratnhWl1U0sfN3Vr3ly2G6rslFnu99TQm9Ow7ucfciFZFs867imBNUS5ewxJl5vmght8L5vwGW3Lji50WkYjBWrzNJxXQgouEMC6Hr9/9hLDv0IsDFIGolRD/huvC1YxJWL7dWyPbUMAlyqXKyIqnKxiMeKnJx4XT+zYcxooadYW8kLXUfNuGdYBwhr/j6qYmmIVx87tT/531JTUiu/Le3XSj5FeK7WA8kjAfZQySI8B5wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iHNnK32yYqPs0HjScTWc8YFF5KOVSSpQ8D1sxzAR8pI=;
 b=Fc9Ty7XUlkGKAvVPcsBFqXpZJozZxYO3auNDfGu0jbfEQouW6Y/syNwvTHQzFXQ+nVKYi7WhYKXo7U04SLitk6KgnlvFHqQ/qAczEgmg5CrLrWtXw/Z1zVJE265M35zXXy5rvXvMi0HzvtYoBSGpYbkPEEw2lAZRVWRXfmZkz381aXAEZYIKHGaOXXYQGntDCuW1FgFFhPdhnqfVlVSOyOOjK5Zrng45k4WAZ/+fXqgHhOIGflaFVIte51ugxP/UCY4c71jn82lhJxXWZZsA8jbW7SQntSubmK/ORZFWr5JS0SZglYspguZn8KwiAMSm0szhmgJVuggKm4JmhKXFLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ2PR11MB7671.namprd11.prod.outlook.com (2603:10b6:a03:4c4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.18; Wed, 22 May
 2024 21:15:35 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7611.016; Wed, 22 May 2024
 21:15:35 +0000
Message-ID: <e107e6bc-3fa0-4ad7-8749-498defe87094@intel.com>
Date: Wed, 22 May 2024 14:15:33 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 10/17] x86/resctrl: Refactor mkdir_mondata_subdir()
 with a helper function
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	"Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240515222326.74166-1-tony.luck@intel.com>
 <20240515222326.74166-11-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240515222326.74166-11-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0129.namprd04.prod.outlook.com
 (2603:10b6:303:84::14) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ2PR11MB7671:EE_
X-MS-Office365-Filtering-Correlation-Id: e76b45df-6ef4-49d6-6f9e-08dc7aa45262
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aWxyc0RKc2tRK1ZiQzV2MzV2UURlR2dSLzVCWXhyc1ltaFFBRFQ5ZnlXbldK?=
 =?utf-8?B?SWFtM3kzeTZEMTNONWg4eGVJK1czVUtESU5IMXViZFdocWhLM2FIalVBN3dI?=
 =?utf-8?B?YUpKUnN2MUNGYmdtUVU0THBLb0U2WjJkL1hvQWhmNU96TVJqSmRCSzJpSTIz?=
 =?utf-8?B?Umg4dHkwdmtKOVY5L3I3dlczVzR1T2ZGU3Vsb0xZN3JzVnNsS2xyUkdUb1Bq?=
 =?utf-8?B?YllnNjk3TUJCSWF0MlFqVmlZZEpwWmxmNXZOUUlaRmplcytyRVNQSjgrczF2?=
 =?utf-8?B?NHdtYUdjZXd1WVRoeFBmSUpCWXpLaG9WUHlrZ3pKWW9uSDV6VHVKY3Z4M2Jq?=
 =?utf-8?B?Z3lna09NRklvZlF1a1hVdjJVcHBIcndDekhUdjl5RHFqSHhkSnM2Q2FVcWg3?=
 =?utf-8?B?aXIyNDZrcFFEMWZuMmFPWmhoVVVQUmlCbTdXTlh5bHhsQm9zTmgvUDJYREow?=
 =?utf-8?B?elZhNFBiWDVmRTBmRFowYVluTk9HQitLaUIxaHJXUHhJajlQbm5DdEpnRnZt?=
 =?utf-8?B?aWQ5c2dKUHJUbmNXRVhJMTFPbWRjc3RiQUVKajBRR25RckhXRVJRU2VFUHFa?=
 =?utf-8?B?RnVIWUdzQjBFdFEvUHZuNzAxK2dDZ0R5dzZ0Tm5YQUpZUjhrNFFweFptSUlP?=
 =?utf-8?B?VElDRXlVRE9nWkthQmd3eExVaEo4SmRkSGt4M2JwSlV2Y0VzNUQ1UGRKclpy?=
 =?utf-8?B?ZnBLT2lpakhoSjUvQk5pV0lCYVBQdXNMeVE0Tk95b1orZGFVWlFwSEF5emhD?=
 =?utf-8?B?OHlURnU1MUJjRFBTSnR5dEphVnB1eFVMdDBRbzVSRXFLNTJ6WHdyUkxDeksx?=
 =?utf-8?B?NFVHZ0IxZnFXM3JqZU9uMGgyNE16MFdmZ0lNZDVIUi91TDRhaXpHL2ZUUmo2?=
 =?utf-8?B?dTRubmlIUUNPVmtpOUl0c3J3ZDZsSnpvVW5BZE8rZ29hU0hyVVpocHRCWkMv?=
 =?utf-8?B?RHZjOGwyaHcxV3k0dzNQSzFWK24vWGZZLzMzdDJOYlFIaHd5RWRmZEhMZERL?=
 =?utf-8?B?Q2N3bUdMdklLK3pXd0s2NnlEY2xGbFAvaVJGYU0yak9Jc09HbG12WlRUSnB1?=
 =?utf-8?B?cXkxZEkzOU9aSkdobW9xZU1PbFNuWWdkME50UHFpQVZ6QXA5bkNzcllES2Z4?=
 =?utf-8?B?R3UvNWNqN3VhMSttQ2w3bEZka1hOVHgvNVBSczg5UTlxYWtzaTA0NGE0UzY1?=
 =?utf-8?B?dVR6WnBCdTFuYXB0a21XczRpbFhrYnZLZG1SODRWWG9uaEVzZzltcTVndkRG?=
 =?utf-8?B?ZXhSSENicm5tN1ZmS0FacWZSYUtCRFA3b0c0Uk1FaWYxSkhmbGRoU0hsS2lH?=
 =?utf-8?B?LzNqV0cwMkNUdnR1MUNMMWxTb0hMbm1ycUFqbGR0bGlrc3lTQnNoZElXSm5C?=
 =?utf-8?B?aktIbmVHN295ME8rS1QzYVhyQ2trR3BmR0REWFdKMnhkMXlPeWVPVDhROHE5?=
 =?utf-8?B?U2Q5VTllVmxpVEtjeUlEVkZNUUhNYlAzUVNEVnBPZlFaYm1WVTZYajlrWFFX?=
 =?utf-8?B?dmZoUWI5dFIwRVVuMUtYSjZsYVg1cUdhclVOUTNCSkFteUo3bTJ0SklmUTFV?=
 =?utf-8?B?Z2NUVWNSbHoxVW5aZStBUURpVXZhNXlvVWxlcmFTNENnbjdVSWdNVHpPSEpv?=
 =?utf-8?B?Z3FrMHdRdWtmSjdsTllqWlk4aVF2MHkyWjdxVVEwcTBEaHB4Z0RUZGJISVl5?=
 =?utf-8?B?c2o4N3hVeUsvSWhSaFBHc21VQmhTdVp5akUxenFQWEM1SXl3MVVOaUh3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WXcrQjZ5QXVkSThYUXc4OFJDQmxVQVZGRnUyL0hxd0V5bmxyN3pNV3ovcC9q?=
 =?utf-8?B?WmE5aThORzJUM2xyZmpIbzVnOGUraU00VmxhSWpIekdtZjhJU3lIUit6aEl5?=
 =?utf-8?B?YXlmQWNGVGkrb091M0V4QmZ4MmFyNFROOXU5aGtwc3RuVTM0N1Mwd2lwbnh0?=
 =?utf-8?B?SUN0UlpGMUF3UngyM3hUcnRmTXhudGM4cmNFbDJoUWh1d1h1UkdRRmRBVGRt?=
 =?utf-8?B?ajFlakc0aTFSUVByYi9pQnY4bHduekQ2MXIwU0NwMWduamdYTE5BYjI0R011?=
 =?utf-8?B?aUpOQ3JkL1R0ODdNaTBqeW0yS0pBSkk5MXQreEhWK2dKZytuNVhsLzhBRGp1?=
 =?utf-8?B?V2pIU1pLSnpURnZHWWVUK3R6VVFGTjNNUjFkM3JmK3dLZ0VWeEUwQ2tTUXY0?=
 =?utf-8?B?TFZockhCUFF1K0hqZ3R6ZkttNVM2YytiYm5iM0k0NllNcit2NXBERFY5SFE1?=
 =?utf-8?B?cmF1R2JRbHp2cWt1ZU9DUzZ0L0VFd3d6L3g3TWVnZjJVSERqV3VqVnZtUWJL?=
 =?utf-8?B?dndyTk82WWtzVysyZjA3OUdCNUhCU3liemZCbGFaVG01c1RtVGgraXR6Qmgr?=
 =?utf-8?B?NUpkYjkyZWRBTmo2RGhFdkhWMkdGM0psUldHbWJ1cituOFFUZTdZQko2TkJm?=
 =?utf-8?B?WVM1K0tmMjRuMk1GMGRjVmE2K2NqMXJYcVNKRUd6VlpxMDJUUnlFdnVNNVFx?=
 =?utf-8?B?b2hFYVo1N1lKZnJOeFZZN01UZUlvcXhSeWdVSmhEQklmMmJ4RDJNTUNLdWN0?=
 =?utf-8?B?NXB3MDF4S3BSanAxVzBCVlpkdlRiS2F5S0U0N3g2UG1GSlR0NDVrNVpGUXVC?=
 =?utf-8?B?ZzYvbkJnZWdTV3EvUUx1dkJLVXkybHFYcE1qbEtoUEZoRnVsdUNGcUtZdFV6?=
 =?utf-8?B?TzM3V3V5UUNCQ1hGRW00RGorUk1qS29aTEo2d1grL2pJUWRES29DOXFyUmZK?=
 =?utf-8?B?SllvcUl0NzAzQ0t1dHRlaDNiTVM0VW1sQUk3QWh2SjBNcFphUGdQS1U3RHZD?=
 =?utf-8?B?WDM4T1liZU5qNitpanVUMC9PYXlmNDh1RHZqVGdkY2FZeGNiTEwrY3RIb1or?=
 =?utf-8?B?T1h0YjVtdlZtbDJwa1pmVHVlMkMxTStuNjNpek5sSURxTXRZOEZsdGRJNmdK?=
 =?utf-8?B?MVJPemc1OGxQWWcrYTZnYUpnb2hyNTM5ZnU5TDNxMnFzZUc5NGIyWVhHZXUx?=
 =?utf-8?B?WjdmL1FtRE54cDRrZTRiTEQ2QVJJRlhyTE5QNGdMSUdzWmhTelZqcGU1bHNI?=
 =?utf-8?B?NVp4WkNQN3V1TFFVRTZyMVJBVkgwQmF5dzVYNkdEZ0ttRFB1ck14Z1J5VWNh?=
 =?utf-8?B?Mm5Fc0duWHFrcEFhaTc1VldhTkwzYS9tVXZiZS9TM1ZOWU9SQ2puZnRVNGMr?=
 =?utf-8?B?NUtBRDZ3M2QrYktLU0UvTnBsenNnR21IYlcwT3Jia1J6OCtzVitLSmZPekVa?=
 =?utf-8?B?UDQvRzdCOTh1N1R6d3VobExVandmOEFISk0zUzVrMFlINGdEbHpOc0VHK1k2?=
 =?utf-8?B?Z3JaVU0za0w2QWI3ek5ENnFkdjJXUEZ2eml4VEliUDJ6b1htZGU3bmlXM1pX?=
 =?utf-8?B?TUp2QWtJcDFwVUNKNXFqNDVNMnN2bzVGU3YvSTg4Q3NKNGJaOGszdlNkQTA4?=
 =?utf-8?B?SXF6LzdlU1ZVL0p0QXkreDRrNzQyMDA0aWVhNENERUF6RUU0bXlNWlhwY1ZQ?=
 =?utf-8?B?VTdDaXp3UDFWL3VBZVlmVGFSKzR4Qm9tNkVFNGFZeHN3a1hJWmJZbXdJWHZY?=
 =?utf-8?B?TXdTc29zSUZrQWt5U0JMMTdlYVJtYUpCL3FkdDdaL0ROSmhMOUJwK1dpVkRQ?=
 =?utf-8?B?RHZnM2FmcGJnWlQ0SEQrV21GR2NFVlBiQVk5bUppTFFpR1JwekdHV3RnbWd2?=
 =?utf-8?B?bmVTVjdUSTJ2SUdzaW5IUVhlWWU4a3NjeURJUlRhODdXVDk2VThFYUh6UDFE?=
 =?utf-8?B?SW8wV25wVStma3U0RUk3Lzh3bnJvWnB2ajRoNTY5ZEdJYXdBTlBuQlRtU2NC?=
 =?utf-8?B?TDRnMnd3ekQrMlJrUHZqRGtZTkp6MnFFbDhOMjdkblliQ3NMS2xBMGhqZW9t?=
 =?utf-8?B?SmE4R29wSkR3Z2JvRzYrRWZ4b2toZzF5Q1RJNGNwQ21HWUJGcHVUUEdlNkhm?=
 =?utf-8?B?REI1eFdSbnZQOEpoQjJORC9JMHB5ZmN6aHZHTDk2M20yRXhpc1JiRTRSVENp?=
 =?utf-8?B?VUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e76b45df-6ef4-49d6-6f9e-08dc7aa45262
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 21:15:35.6911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 292nXlOfCYW5kv/3/O7QKQYXAMyj3KTkP5pS0r9BDPp/gqFKo4mNu2mdCuvLKZjsmGUjWvUA83YV1IFWSW9llvsLorxY6Jk/WW4Ol+dNihc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7671
X-OriginatorOrg: intel.com

Hi Tony,

On 5/15/2024 3:23 PM, Tony Luck wrote:
> Move the creation of monitoring files into a helper function.

Could you please elaborate why this is needed using a changelog 
following x86 customs?

Reinette
