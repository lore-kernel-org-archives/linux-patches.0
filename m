Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E726714BF98
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 12:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719317030; cv=fail; b=PZbXCJbGQ1EACBms3IGEGDQl7hHpCU8nuwdub/zEZZmwdSQzuuQOpkQLFKSldn18PkDBamQy4AVTI+ab6jplZ8Tlc/NGXKuc/C5uQU2UhFUVKd+frtkR+xyHpDtGsUAq896HVv+OeM7fZ1ycFjrOm9cwzW9mxLPYYij5Cp3DWWU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719317030; c=relaxed/simple;
	bh=AFQaEFOxInuONYuqn0FBed+Lngj9XzoRW0EpqfaWum0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WtWP7uXRX2FPOz1rkPffFhTa6tvBnABcVeUIxRI+XxhmnTxWA3nZyLjz+g63Hfk/oRZuPvJ7MvOrceWgZrBKWj8wU7EKmvOY9ZP1L5EjtTVTuWctBPdYlWCGseeq1xqhC6Q2JV9KTygOi7NdECaov3TrfSovPU7gd5F9/rekErA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NXxuSopm; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NXxuSopm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719317027; x=1750853027;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=AFQaEFOxInuONYuqn0FBed+Lngj9XzoRW0EpqfaWum0=;
  b=NXxuSopmKeVJ2eTP/zm94bxp4I3xt/XfkxDXn0BMFFOtB8Txw+GNRHmC
   VBtWYD3LDcpp6sgFGcHWp3HvhyHZ+ZDhW5QUfSs5kb1vLyplDrzFwLu46
   fybMmTVwIrZbUROJEzGSI8IG7ZVIhgAAv5Amt6HA2ZoMM/s1P/sShM7dA
   +DlPa9MMx8mDoby1r7ari3svjKjaNcIDbcSHZT/82rv7Et549JafR5N0C
   AP7xvEaUCB64o4yQd2GdIl7GisA5W8eGByAAF20XVOjH5YD1bE+DEDsLQ
   d4EwJB2UdM7wxqU+7b2MajpI2x36jz7OjxxQ7KyB+mwH8gdK8d6QZiJbT
   w==;
X-CSE-ConnectionGUID: qRkk3A2UR72xUmo1l3qqzQ==
X-CSE-MsgGUID: B1WBIyBfTZivt+Jk8/LGTg==
X-IronPort-AV: E=McAfee;i="6700,10204,11113"; a="20105662"
X-IronPort-AV: E=Sophos;i="6.08,264,1712646000"; 
   d="scan'208";a="20105662"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 05:03:44 -0700
X-CSE-ConnectionGUID: aBhSTB3ISbaSYfjkmoFqTQ==
X-CSE-MsgGUID: zQ1jHHVATOCYlTWaTQGBNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,264,1712646000"; 
   d="scan'208";a="48798607"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jun 2024 05:03:44 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 25 Jun 2024 05:03:43 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 25 Jun 2024 05:03:43 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 25 Jun 2024 05:03:43 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 25 Jun 2024 05:03:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dk6YosfvvPD0ZJk34STv6BaQG+cRGylUwSHpF1zL+2G2Onky0rryeOSn+mF6TEf6TRbF0H7RRdC0/zaCUxFCIqxrtKfwYWaS4WLu4E/a++sHSPJ6DkKyDxabGaZH7cBRvEBzw7ds0gkuPVwEODYMHhyO46UeQn9BzbWl7v3l0yyTuxRWc7mgslRWRIV9QJD08Ud9ASSvC+ID0SgBD6SV6CYqEaJFHu+5hGiFA2hJPuJnEtxw2aHv4VC5oAhqSf40iQ8dPa+sQLdgrP52OL0KQSkUr3JIYzNDR8t98anBRYvEnkM4QVe0mS8GDIdSEnHjEpMtPYqz4vm+SkEkHwQxkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1aahexOMyrga8paEsOcjGxRQK/ySEslyDJ28gMl7+q0=;
 b=cJN8ZRhomLhu6z5w+yJtqy+1bihsB+pURixECfOHh3hmvcw/dXk7VlnGp+JV7gexRMoKPs8n+3x1aZf+T1RuuUngOlnfeS4mDM1SkP8sGnibE1cLW3n8R+qfC4DiLYfOngIRkPKpEAxKxZ9XBnW69CdNLxwiw5dgOUI/4s6m05dy7DVpeX548zhWOvL2VkD/UW4Ppqa7WMc4CW2gHIfsP2yx/Y+UAQ9EpXbcXpHdNPa73vcHhb0NEKbekP/nvNwJrAlHQHGemtw4Aevgt2DRW8nGdoPznaUQdRYiLJTSH0ih7C47Pc7aTkDir/cAP7bGTDKffS7gdKaCtIB3pmQ1rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB2854.namprd11.prod.outlook.com (2603:10b6:a02:c9::12)
 by CY8PR11MB6890.namprd11.prod.outlook.com (2603:10b6:930:5d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.31; Tue, 25 Jun
 2024 12:03:40 +0000
Received: from BYAPR11MB2854.namprd11.prod.outlook.com
 ([fe80::8a98:4745:7147:ed42]) by BYAPR11MB2854.namprd11.prod.outlook.com
 ([fe80::8a98:4745:7147:ed42%5]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 12:03:40 +0000
Date: Tue, 25 Jun 2024 08:03:37 -0400
From: Rodrigo Vivi <rodrigo.vivi@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Airlie
	<airlied@gmail.com>, "Vetter, Daniel" <daniel.vetter@intel.com>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>, Matthew Brost
	<matthew.brost@intel.com>, Francois Dugast <francois.dugast@intel.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>, Sasha
 Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.9 238/250] drm/xe: Use ordered WQ for G2H handler
Message-ID: <ZnqyGW7Z9i5kJICs@intel.com>
References: <20240625085548.033507125@linuxfoundation.org>
 <20240625085557.190548833@linuxfoundation.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240625085557.190548833@linuxfoundation.org>
X-ClientProxiedBy: BYAPR05CA0104.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::45) To BYAPR11MB2854.namprd11.prod.outlook.com
 (2603:10b6:a02:c9::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB2854:EE_|CY8PR11MB6890:EE_
X-MS-Office365-Filtering-Correlation-Id: 9874c127-3772-49d6-2951-08dc950ed9f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|1800799021|366013|376011;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?4cGb+TuMo9TUcl3f8/e5lA0J+tMI4B5nBmouZ1QxZHtgUpB23GQTFfWbBM?=
 =?iso-8859-1?Q?dr3gdbchHp0dTL+vt1uVMYhy1blMvN64tOBoST1bp39yw6tPWTE4RqgLl2?=
 =?iso-8859-1?Q?daEYnKBDZbl0Y//zq524QpWNjUvQLT5Jyt3MnXV4dcvEo3VjJrjoQRiAkh?=
 =?iso-8859-1?Q?pHOR5x9EwM7n3uO81EmHJEWSLxX6rNyjBPpp7v4DRelFAignpffHvFFQTe?=
 =?iso-8859-1?Q?aFIfHZvo8rYnMjgBjPxwf6BZZoWEG3lfKCUhKI13ZpTviVLQHQkWOAToiD?=
 =?iso-8859-1?Q?Y3hX5xzYKqtWAnPImVRaiSYAYhV1Vf/6lMqVgpl7y8RBx+49zmwmHikN3d?=
 =?iso-8859-1?Q?OdcQ5Gmp2Hf6j/6Nr9FLGtQvHS1QHme2zEEzWrr9d3Hbk2THNDhUgx24+S?=
 =?iso-8859-1?Q?G//L7YnJ7uP9KLRznY43rPnseCpFKupBmFuBntFKePhtjeXnE5VnN76cE3?=
 =?iso-8859-1?Q?HIj+Vl4rBFaXdXT2FQsMjcz1lQb/jfEfEcSqHvkPbB8ncEn1Ck2YNbsK/z?=
 =?iso-8859-1?Q?kgXEJx4fb92/dDCPRAgW7RHSf9/2YPM4zEk/Pppo0q/dHD/5Tmt1pR91Zx?=
 =?iso-8859-1?Q?6oe4FwjHACKYkMSsjxyIOntU4MjOat+bj+Y+fZXX+odBjbqev6+2/U1Qfs?=
 =?iso-8859-1?Q?dNZQ+OEDfwS74/vuzg11MtNnErID75wbcgwPZFKb0s78OJH9ZUAluiFiUH?=
 =?iso-8859-1?Q?EkEUCTsZOeJxoNvQcjb2jno3M8Ndzh72uEnwG9NQdiIWmEmKgHPgoyei9Y?=
 =?iso-8859-1?Q?Z43SLZ2pMJRySdwDm0TtAUEIhiwpaYIvNqn01OemuiFjA07l5w+Y34E+WB?=
 =?iso-8859-1?Q?Z32x87Eq8K24vGMLFXfEdvYzJhXQ8AjkPIKnGcNI+GSRCpBlIr+p7dWAqN?=
 =?iso-8859-1?Q?rEje7WOcvriRG7DU/Jl7dJ1TCivTJjGUFwQvQkamrRTyhlnGQs3UWPvAsK?=
 =?iso-8859-1?Q?GQ2q7fc70pLtPS8BdD3+H/1eHr/OQwIyp4nwDMxhifulSbVNXNHkqWqiiP?=
 =?iso-8859-1?Q?wpIQiNnynX9yUNe9DSfJ5GOawdbNanLsj33CqreLHsBxrAJsORa9sz0i/h?=
 =?iso-8859-1?Q?OPxF0CHYwb7T8/yPDFdyS/ii5dQ8FT5IVbhhyp9OKPg3awGkqrwc6cZCkn?=
 =?iso-8859-1?Q?KMFJEW96aSMVgGtoDb1KleygESpPlqh4/AAih0ZL/k/Xwzx5SfUJS5Hyjh?=
 =?iso-8859-1?Q?FdjLfuC8idnIbvEvIda7vzqgSNkpgrtEPXMSQnLrCxD1H7ByHciZVf1J9z?=
 =?iso-8859-1?Q?BUmKCO+fKfcl3jJCpxG04kNk12+wljE1w6zsk/EBHTvUQx5/EHlSk9LZEH?=
 =?iso-8859-1?Q?ca00Xx2UXfe3/6G4NMq/+A54KA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2854.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(366013)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?3w/LZKCPL4c4ldRtRDg5+bGicbhAgYOvOsDKQK/vzPuVl05bKZ8A8LOQFQ?=
 =?iso-8859-1?Q?feYHz3TY1Tn515xT9Ws+OVYE5XVVPEBliMBk6559R02t0Q4jpFFRW4K/2w?=
 =?iso-8859-1?Q?nTPkQX5oh01keuDtqZCdkqc7u89zQKQugIZZuif0GXhRNitVyrviRrgC62?=
 =?iso-8859-1?Q?erfSjxlkrgpQFBt2VoYt+QjFojwe/y2UaaBFpEcfFzlCAk9S5sf2IP0GW0?=
 =?iso-8859-1?Q?kGO23S5pXqsyC7iceTiRgDZ18BNAngqNowKIRh2J+OideueGtxhAgrdfsE?=
 =?iso-8859-1?Q?U3ncSFJmGg/06cjAL8LYnRAmaN2hO9Q3SZVtM3AljpP/fwO+gh2rT2/gyM?=
 =?iso-8859-1?Q?L5GmSbPVUUOeQrfsAr7WE/87Wuz8exQQb0EoxHpfHNIxcH9VrI2iiX9C2L?=
 =?iso-8859-1?Q?IzLwyNkxdQHlWc2RLnNv8ozNYq5JEBXDNqeTtKuKIjcQ9vNvYTzuUlIpwx?=
 =?iso-8859-1?Q?Qne0YLMlY6nmKSYDmcBSu3u8O314a+PgK2Qb5Avg6zivr6DqJmtWCBUPWV?=
 =?iso-8859-1?Q?YZUZ61fp5kHj+lYwyGfYPPLqpggqRH4lvI12iqT6bg+Xb6XYxrVk4NvXaf?=
 =?iso-8859-1?Q?Z1eELOzclZJd3N6ncsK8UO4QjaohbmZm16ii8RF71XEezcuqB6K3/ND628?=
 =?iso-8859-1?Q?iIHrJZ5AOUuqpV2ZiMQtHWJDzRfWnMyEx8tX/YmRQlUCDMveA89C4cMVA/?=
 =?iso-8859-1?Q?F/3+myueUTJ8EHMpVADCWiVGQGBkKjHO3LiJA12PmHDmoAaSvF8iL0O3b/?=
 =?iso-8859-1?Q?xoDkHvEObrjqcnC6Ar2J7rDZRGLfwCc8PStiJe+ipm7PFfGWwPRoxzIx1B?=
 =?iso-8859-1?Q?6Fz8rJVCNAsYZyZEqTvsgZEUZcCe/o+WkkdCQrREJXGNAqZJ4tjSRrUr8H?=
 =?iso-8859-1?Q?3/Jftdww4Q41rffS2dvfzmXpzsjNNP9znQKAxkymPR4QeV4/qIX/hcSexa?=
 =?iso-8859-1?Q?VkdtpDElcxLkBIDDjAdR/2kaElbyuyqRCb1bAkXUKClo5/fqTad68y1txI?=
 =?iso-8859-1?Q?1tsNlthjs/PLXolzYvc1cTFFq6Xlh9ggXblHfsmXCAl309JsEdz8YI+wH3?=
 =?iso-8859-1?Q?5azApFbuogRiNWdDMIS8gf1eFxiuGIwqS+xi9ufKpXyswWzMqq/SiqioKM?=
 =?iso-8859-1?Q?tJv1MURBHi8fPFf5bLdXAnTncwDbC6AWbWw959id2/N0ScHfFFlWtPKC58?=
 =?iso-8859-1?Q?wyRKBJuSyRe3o0ikkib3YyXz0BhgaUYBZjU4W6MHx0TlYNHrfm5x6sA1Cs?=
 =?iso-8859-1?Q?USk8Mol0eLzQs/aFoKuAeWnZYDt0uynPYYYvPRe1tmp+3WdB6uz89WfPeR?=
 =?iso-8859-1?Q?2c8Sb5bokYvsXTtCLOQ0p3AzR4pu32m5krG8+JASMkqttUbKUMmlSBsMZe?=
 =?iso-8859-1?Q?lMnohvSb3SyrVqzDDcCel1rwGECs0kuLwWaabiC8yCCHHnlj51sV3F8YWy?=
 =?iso-8859-1?Q?gtO4W89BxmTp4qWgounnRgGavxkkU935IR7B2Z0uqTPmtDCXVjGOaOWSaQ?=
 =?iso-8859-1?Q?zpSJbFQMfERAXNHTJVmU/iKTFMBK0IpzBWJm64rA278jAnkZMLSMYDV6pn?=
 =?iso-8859-1?Q?ufGhCgD1HEK7Nm4QHb+WyYgLrSKrGCAYHUjkDGaEMCWT9vf+GB+yl6mESI?=
 =?iso-8859-1?Q?ES7GuAWQENvK7ZZyycG5ZCWQkRDTZ25aZmlgHQBjsprQBefwy/42+UYw?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9874c127-3772-49d6-2951-08dc950ed9f8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2854.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 12:03:40.1233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fyBwcuhZikCwBCO1YwgXTv6pmUwEUgJB7lr5+gEHP6xZ88MuDwn3S14S3p78pjqjexZjIga88V0b25ZK5yrtFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6890
X-OriginatorOrg: intel.com

On Tue, Jun 25, 2024 at 11:33:16AM +0200, Greg Kroah-Hartman wrote:
> 6.9-stable review patch.  If anyone has any objections, please let me know.

Please drop this patch.

Same as:

https://lore.kernel.org/stable/2024061946-salvaging-tying-a320@gregkh/raw

> 
> ------------------
> 
> From: Matthew Brost <matthew.brost@intel.com>
> 
> [ Upstream commit 2d9c72f676e6f79a021b74c6c1c88235e7d5b722 ]
> 
> System work queues are shared, use a dedicated work queue for G2H
> processing to avoid G2H processing getting block behind system tasks.
> 
> Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> Reviewed-by: Francois Dugast <francois.dugast@intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20240506034758.3697397-1-matthew.brost@intel.com
> (cherry picked from commit 50aec9665e0babd62b9eee4e613d9a1ef8d2b7de)
> Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/xe/xe_guc_ct.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/gpu/drm/xe/xe_guc_ct.c b/drivers/gpu/drm/xe/xe_guc_ct.c
> index 8bbfa45798e2e..6ac86936faaf9 100644
> --- a/drivers/gpu/drm/xe/xe_guc_ct.c
> +++ b/drivers/gpu/drm/xe/xe_guc_ct.c
> @@ -146,6 +146,10 @@ int xe_guc_ct_init(struct xe_guc_ct *ct)
>  
>  	xe_assert(xe, !(guc_ct_size() % PAGE_SIZE));
>  
> +	ct->g2h_wq = alloc_ordered_workqueue("xe-g2h-wq", 0);
> +	if (!ct->g2h_wq)
> +		return -ENOMEM;
> +
>  	ct->g2h_wq = alloc_ordered_workqueue("xe-g2h-wq", 0);
>  	if (!ct->g2h_wq)
>  		return -ENOMEM;
> -- 
> 2.43.0
> 
> 
> 
