Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74E0191F98
	for <patches@lists.linux.dev>; Tue, 31 Mar 2026 18:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774980828; cv=fail; b=KW08fA/+fkDUXVZf2ZkFFxeV6wwGaZuWC4QrcTKya3UnaReFqC1QcR4/9VvZe9/sdMxnPr5DEFcgcAWj7G3PVAlXZTEZtz5WxuRCdf8h3boxg5Vu2BnTPJVtU5rGChFLSvIezDs7dCxBOUPtfcxZFAL38KaoZ/V4M8m0Ps1S26w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774980828; c=relaxed/simple;
	bh=VGwh4uGZcPSWBjBRXkkMrOxLcROR40oT7vlBz8/91fA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YknFQUG9jfYwQDCKT9YHKL9UfxOGeequ8hfZMilHbpeiqDxaX4JOZicVrQbEBcFMDD5Vg5ghf1fdYXhjwIFm7HwsB9mGkweCmr6rFwe0/YqnqjPiBIkJnqpWFsGHfwl4pZneM5AkFG3ohbuxg67dW091MbeEKYk9Xxeb/B8GijE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gqYgo9NF; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gqYgo9NF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774980826; x=1806516826;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=VGwh4uGZcPSWBjBRXkkMrOxLcROR40oT7vlBz8/91fA=;
  b=gqYgo9NFRjV2sAl1vBpNlZwZng9x2vnW2Szit/Gw4Dw+l2R6rInRaw6D
   dN6pU+31cUQGw+qH90SurhwAeFFRZCklxNpCnK2E9ZkuEijMcO3aWSCKY
   Q5acN8fUgj3HrJ/Varf/3OtJV/oUIVNNCf10i4BMdMRmiItsZ2+B9clmx
   6HuwwrQJ0AE7pH7tpAFhcwy6x721wOJb8Fvy+VHv1IFFQCW5zpOPp03Mc
   6pZebytJxfvO2O6mWN5bZdfWaAPPFf3lReT/fIDROSWgrA+z2kezrKUJ5
   AFfRvAHiBxtRcHhI3gtWzao/xaPQjaG+It9AoWvWAg8uyKpl+xdcJ96kB
   Q==;
X-CSE-ConnectionGUID: 4rm385U3SRGEk25H8msncw==
X-CSE-MsgGUID: FY3euLFNTiqlkYqHHUDCmA==
X-IronPort-AV: E=McAfee;i="6800,10657,11745"; a="93586933"
X-IronPort-AV: E=Sophos;i="6.23,152,1770624000"; 
   d="scan'208";a="93586933"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 11:13:45 -0700
X-CSE-ConnectionGUID: 29F6hwdPTKm00ab1TexqDA==
X-CSE-MsgGUID: tts/FzsLQeaXeEre71Tjxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,152,1770624000"; 
   d="scan'208";a="228041671"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 11:13:45 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 31 Mar 2026 11:13:44 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 31 Mar 2026 11:13:44 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.66) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 31 Mar 2026 11:13:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MjYwp7oxLpFhGRD2ew3bAIe5kXW+JLG/tCoq2+WsveJZjs7Z0pf9dfbZHP6qc4OZ5m2T5902HPdBgLyWAFIaNyEj8zuQ/nHdbLFbjvcjcQAQ1Vj/7Z3rm1Af0pIRAsE3jfqRR0tc+1b/0GqvjFSvoMNZiy0JSwlj67E3juJHsqbrk7arF7NHuNW/RgUat9PnlEGJjLMutRdhrrWDzGf/GnUh7zI+pKNqYJVx5yEz26ZA62R1+PyZNEvbOud/i7e1YsxxLlqde0+TV87aBvceRNVa5/UxtaoDFKlR4sVcnTQ2pYNnVrUVPmfahjukzpYsXuVhFz68OH8ye+UAPHQLjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0qZ/eqE8zYuxq9y3LkXwaRO2kVS8lGw94lsFLj/NPeo=;
 b=Zv4HZ9MruO/OZ5/39mgLxwFFffnBPeQDhWdZpXDZgglJQOYF/X9IBLBQvCgz4YkbWvIsn6D4Lroerg6ImqfsQq9yJ6zlmIZYaG5jCgNeocnOMedrWDjYn3dWIhG67puJpbUMfdt7VCwGHgvAAetLoUGX7GQi6OrLaafcUGZpRXriBHPt+fh8Ifa7QhOTqqqlj5t1P9eKa7wPuWiNdDs73pX0kITsDxY+o/BZ26TAom8axRntFjWMqB+A40HNCDzSGNONeHMz2WsobsTxADoESJnsYyraxwZHiwtMl3NCk1BVSkgtUXl7hnRF0YllsAgu3qIsJSzQhwntQJGnWuscJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b) by SA1PR11MB6686.namprd11.prod.outlook.com
 (2603:10b6:806:259::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 31 Mar
 2026 18:13:41 +0000
Received: from SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::1879:7c61:49b4:b2b3]) by SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 ([fe80::1879:7c61:49b4:b2b3%3]) with mapi id 15.20.9769.014; Tue, 31 Mar 2026
 18:13:41 +0000
Date: Tue, 31 Mar 2026 11:13:38 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <dave.jiang@intel.com>, <patches@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, <Smita.KoralahalliChannabasappa@amd.com>
Subject: Re: [PATCH 9/9] tools/testing/cxl: Test dax_hmem takeover of CXL
 regions
Message-ID: <acwO0hGK6vv5g7iT@aschofie-mobl2.lan>
References: <20260327052821.440749-1-dan.j.williams@intel.com>
 <20260327052821.440749-10-dan.j.williams@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260327052821.440749-10-dan.j.williams@intel.com>
X-ClientProxiedBy: SJ0PR05CA0038.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::13) To SJ5PPF0D43D62C4.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::80b)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PPF0D43D62C4:EE_|SA1PR11MB6686:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a5a59c1-ff09-4a3d-274e-08de8f513ce1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info: tY8av03nkcy+CQR0OQQyLGb0U/jrmoOK0tjiRhqZwlumxQdI/pnhU21Pv+MAmd5i34Tdx/IwM8+NYfWJjh8AcHkQ37v6/PJbVEyMibht5XGKb75/ZTJ6eMwyB46O+H07JF3XZdRCG/fHMZXKVJ98uxjkbwvg5AJHRCtVfYrkAKv6uy56b6IPp4LoHkGQROj5wpdoNLrEXy7+gxVVKqUT+F01qldctQbrF1oO2R0RZAPaQSzG3NMmjfAHjiALuyjCAcJptFXts0T4GFgddvq5asMaSvd2V6BfrLHTZXbfy280su9CpHMzELqRH9T40NxCF2mNqdnOaCc+6J/LmUMz9D9gJ/PPCTweBQS/Fj1Vq/EPaEtm/osIDqJbI0Lp6wB/px2XnKZ5eyRPW6SsKb/S7Nh/CD6IeZ+xgGCpg/QleKDiNLzQXqaDnBEo4DzYUM3cguW+PfB4zkFjF45EsQB9cTrMzREUX94dBGeKAGPMjgfoQ4uz7Ozt6w6vxp0XtJNmYKrDQ6wnT6z9qQ/o9UdtT6splTo73dJpt4hjwbiqLknMp1//HQMggNiIwoFLHnP5nKwtdsjVOyZ+fJcmAj3BJbEcoc4YXrWs8ol7+iBBvOe4cEuyMVN4W+6rKWVxX3EBzcqxuhxDg3/tmMYB2Z+1A4ryFesF4VJWwwBzkUH19gE1b/UBcbpIklQb7fZhhqyEacvPNA3JaxGbS1NObZxBXkjzOFZ6sXy3xWGDYospfOQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ5PPF0D43D62C4.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AHAQtx7RDlQWNyw2gj2zWiFJ9o61fBM/23Cq3pO7VIPmcThnpRvn1+Dvm90+?=
 =?us-ascii?Q?cqVMJ6Hf7ErZidR3hcQRelFmCD6G/A6g/DYEmkbxl5Dc7qZZwfqtNtUyVCZ8?=
 =?us-ascii?Q?WuXoda3sRWfYnf0I2upH0aqbdcmYrqIPRxsF+RhugoRU/uhLaa0znFncSysN?=
 =?us-ascii?Q?pu+Yu1EUnTq/Pa7vVirLnBeBC206x8Uu7SfLXGjpF+NV+aUYB/DW+rzbK32m?=
 =?us-ascii?Q?hQKVf1dDkHB5n+HgRmtK18T8OhWucapW6ycJ4dBHmLna8yqiBEMMOp7Dsykq?=
 =?us-ascii?Q?ckiBeMNzW29iUgm0Xm6jcWrzHXkACqGTTmvXYNfxWK0hI5/OuyC+1fDVWZqY?=
 =?us-ascii?Q?ryXpRKSWunQUepwKcetR9/Wso0LX1P5eHidBX9iJNvcfB3P7ex8HHckTpKdN?=
 =?us-ascii?Q?ou66Zed2Fyo544UCsb3f6S9XSA3rwlL6ISyTOatTUVaXcxb5CJ7CxVec1/PG?=
 =?us-ascii?Q?A4pXXdGFUpjQ0Dw3T1GRqnFYdNEWqSg46kzmchoGcHQif/StCAKPBVu+Z/c9?=
 =?us-ascii?Q?41BtDmEYznjMoEIlpJ5y46buZ80AlmssgNev6pv42MQ1HFtm/Tu4SOQwRV68?=
 =?us-ascii?Q?GbJKtGZEtYEkapIEM2OKeqf5VC4XboBtodPMxsl5SfZwL5UpwPHLl+/pP6bh?=
 =?us-ascii?Q?qobPzbULF8Hhl6RkY0KxPet1YRw9r025F48uW4rz8urlz8rJu2+Qj+qEv9KO?=
 =?us-ascii?Q?QwSw+aUafMhV3kOHyiPj13zht8v8sf7/HTi//Ufi972S5ZZ2JJs2vaMfu7Sn?=
 =?us-ascii?Q?MY5eLQCkokVobO7127Ng56SiC8fT6NtqHCYWUTO3fPTY9cLhbDhF/dEOP7z5?=
 =?us-ascii?Q?pj3QnEqIG18DPBOsOnuJS+PY/fjBUxQN5BkhQhLCTj5cok6uV6HoXuXqosoZ?=
 =?us-ascii?Q?3RFo00MYZRhBSReTOCs5Esqb7fvQ6whVGLqPosJbY0lqNgyzA8P6JXGEOAN/?=
 =?us-ascii?Q?68xo5kKgX55K0OJLqqT3qJsHfRMz7odwuhZcyae6n1ahyUTSZw6MAQbS0Zr/?=
 =?us-ascii?Q?QYe2xcgLXccLmmDZTW0LssSRkF4tGe/k78QB1gJD+BgGB+X4ddnVMb18SYUV?=
 =?us-ascii?Q?o9HgjNwnGNJhZr8wF0o9TqoXTdKAzKl9uTyAt5jmckozAtbULkToHpQRgVu4?=
 =?us-ascii?Q?EWMahCgEXLljRi2I2cihkTDh1S6lasTfvQsic/KhbK9ArnGvwcQRkFxygC8C?=
 =?us-ascii?Q?vKerEcq3Cor5El2BflVypqu1th+9qEIRhtaDoVk3B8CmMZzaczeHXEQ6BipV?=
 =?us-ascii?Q?/bqYweCncUr88CLRM4gQ1Ocw6sL3rOMNFVVhGn8LPHy5Wne+BuXPCbeIgp0c?=
 =?us-ascii?Q?GNEes0pgHt2vG3Sg7M9V2EzBFl0n2R9hV11rDJNZ/grSXUX470/oeUKTCnYw?=
 =?us-ascii?Q?wM+bWiafLcLreTvB2Gv7zg/95LSumZbAgqPra2C860eTnbxWBra8LPG+7DZs?=
 =?us-ascii?Q?UlRu1YDXZOoExPGcH3YKRWPUCBHPgv8K21tV8d+GxgYLmMWVzqzAZG9GlB+I?=
 =?us-ascii?Q?rgKrhgPE+cUkh4N/Nyh4s30xNRo91Rf9s/i/GgBdNzug8l55mOAuCwcxiohJ?=
 =?us-ascii?Q?6zAMVQdldW2jztlLpHdhBST1LRP2d4yb6Fyv4/OL1/wZGYdXE7XCbF7Xa0bc?=
 =?us-ascii?Q?qIh7UF1agEZ/BpKBce/zKJvz96+LnN53KNK9sxwl5bHFqUA97UFI4cS3oPdl?=
 =?us-ascii?Q?UD03iiKbYhm1E8XfLcalKHW+iH7XvkuJwIvpBTRJniRGjZXcPKe4YL8H2GOD?=
 =?us-ascii?Q?Fk9eHQYnSMf3c02QYePvkOVdWKzG8uc=3D?=
X-Exchange-RoutingPolicyChecked: QTpbiKpCdppuEJCkiBgYCI1vTQOYPznIkgKUHfZCKAkiF2jQm1oML5LJ1BrcoTNwos9A6wrm7i9DJSldBERn4yOplA9j4nXknfa98LlOS9mjpZVAJN/SSjEiA8eXjXeyetleDrUl6nFryfv7KEZDKEWVeXjYGTB0gGKJtBhXFQpegIymKgK18wyFmQ0TF/znCku0HtvtJ/5hoxFvDqcvNvwqBHeT0FumPIupkOoj5Wwae2OeKoIbf+V65nyYYs0i4fTbbCX+qsXhkYmL2BfNypwigRicvCit6F+lCBdbCzJJylVfem3DcDUawa29mfpW5d1kLN5bANr9cUXNTWtL2w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a5a59c1-ff09-4a3d-274e-08de8f513ce1
X-MS-Exchange-CrossTenant-AuthSource: SJ5PPF0D43D62C4.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 18:13:41.1550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xtG/bCEZQg7oi95dgOJIuzhHOsxByPa1kQOqq/tSjGAquIiVuZyAo81Uhc6sdnKz3xBX7eMEY2jeSL/EO4LN5fB/OT5UsU3jWB29KQLMBHk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6686
X-OriginatorOrg: intel.com

On Thu, Mar 26, 2026 at 10:28:21PM -0700, Dan Williams wrote:
> When platform firmware is committed to publishing EFI_CONVENTIONAL_MEMORY
> in the memory map, but CXL fails to assemble the region, dax_hmem can
> attempt to attach a dax device to the memory range.
> 
> Take advantage of the new ability to support multiple "hmem_platform"
> devices, and to enable regression testing of several scenarios:
> 
> * CXL correctly assembles a region, check dax_hmem fails to attach dax
> * CXL fails to assemble a region, check dax_hmem successfully attaches dax
> * Check that loading the dax_cxl driver loads the dax_hmem driver
> * Attempt to race cxl_mock_mem async probe vs dax_hmem probe flushing.
>   Check that both positive and negative cases.

Tested-by: Alison Schofield <alison.schofield@intel.com>

