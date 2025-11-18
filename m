Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB1629D29C
	for <patches@lists.linux.dev>; Tue, 18 Nov 2025 18:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763489489; cv=fail; b=P0C3OzVq5Pjd3thu0BZNG2d0Qfsxsw4e/Bp6X05z0EgPiYUHfz2vChz/7XayjHMVQW51svJ9KB0HmJjjCOElnbW5GqokE7CLl1r650wCQ/hR4+yj4VKD3ymV5051HesKmFrX3bIX30Ih52D6mQMbJ7EbfBqvOVzaSfJ0IV+w7bA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763489489; c=relaxed/simple;
	bh=jhn3TuSi66kmNV62/22MyUKEfW280C6st2OM5lI/YPk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=m75Hx9kRoz7u3Vx4LhQ5Z5BhGMboalcz8Md1R8XXn9PEOwHtSGS55z4jrd1kUc1QUFA0uz5NgnJGHwkq8vH+a5Fq9jgLXh8YRFWQaNaH0E5FD6ABcSauvfNfVThGep5v6ZHA3QAa6UNpZm9plGeZApwDuai4GNKbHIzNjch6kBg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h1vKlX8+; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h1vKlX8+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763489488; x=1795025488;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jhn3TuSi66kmNV62/22MyUKEfW280C6st2OM5lI/YPk=;
  b=h1vKlX8+i/BXurTgQHocxL9LjgF7Rvz0Oa0JofCDmzs9FP/U/mGn7Yp4
   ajmJZ8VencB1vjzgg7P1BsGXpn00ZVG5HjHiFZFZIfwQDM6kvrRYMkdcJ
   lMiaTtwFvnFdInxH7BGln37jrGCG+ZaWDYRnMjTQSI/Do2lbQcZtPge1x
   AthcEFfg4KOz04jMivMWyR61/AGflWRjqa2LynPfBBJbP5EXm8dCsTS4q
   RkrQRNGNNhpTxBHzPtLpddytrDXlspdvgAazPqpyw+Dpvez5m/sDxYCwi
   Ni4h3ugA5Z3If3BrOCPflZh0XuYtoBohPVPMusyj5TbWqXtXW0YyPM1Tk
   w==;
X-CSE-ConnectionGUID: VS1HphSkSgqhv8M6QpAn5g==
X-CSE-MsgGUID: Euhta+n8Tt+sK9g8J0Gvtw==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="76977328"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="76977328"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 10:11:24 -0800
X-CSE-ConnectionGUID: //dlo4tMTdCdcgKfOqc0eA==
X-CSE-MsgGUID: rrgonkOuTmyjw26mCxWCuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="190085406"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 10:11:23 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 10:11:22 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 18 Nov 2025 10:11:22 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.46) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 10:11:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QLJlziuY+IGJ+bO1wH2Z5YL8kVM1SctpWboMrU9x4xRDBjfyo+g91u0qPs6GRBz11848dgeoPhbeZF0oDoUY8hF0wkzRMfYv/9/JUndoP8Ig6sziFkGDgXghBWXNoTK9LAPuq/qJ8TdcZR+HR1WKj+3OE3ARYMaOa3rM43vbb792JDbCrlrILHjzUxX4y+CdKfpeW8SiO7rXJa1BKno1HRIEJqiCIN/GO0Gd6uhzL+M96HJg+2Utaw+R7aBUprtnHTSBgodQ25ppPpmheSnNx5ONDvW/n9+STiVRa+TKm2IzPZjiVnyOG0eENzgxy9+6KNroaugu96JcYFV+UJHdQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JXeY/0W9G1thgGGl3jAqtsUMhwmqAAnKmmbiN4/W2j8=;
 b=S1AB14EboXe2FNKmKNstYOUBh7NRg1ZEdKesRBCze/J8UNcalM7PnhqojoamBOxYETXuYavdpAa4VFkBJypLG5sb6YLOZbksYbvMeBoVCT5zQhOMfT6Ca7PtrG/UfwFCSYNofTdEkXxfKeIHHBC3hNh0M4mWl2H5YvNJdgfXTrgtALPpxQ4G7DLPNUgsNnFjeqbKTA7H2q/guyNoC4xF2J+HWL1L8fg2vrCCFBCwRZ1w/rWgCsJUxLFh6j2B60AT645lNLVpkFefmjOWJ8+Ps7PpkVVULkvS8M/Y5FbUhvNc+m1EwhZU0a9mv85q3unSDDojpG5Wv2Ih9eOW9gBIBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7566.namprd11.prod.outlook.com (2603:10b6:806:34d::7)
 by CO1PR11MB4945.namprd11.prod.outlook.com (2603:10b6:303:9c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Tue, 18 Nov
 2025 18:11:20 +0000
Received: from SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::2b7:f80e:ff6b:9a15]) by SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::2b7:f80e:ff6b:9a15%5]) with mapi id 15.20.9320.021; Tue, 18 Nov 2025
 18:11:20 +0000
Message-ID: <e466dab3-be67-494e-bd73-41652108151c@intel.com>
Date: Tue, 18 Nov 2025 10:11:17 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 25/32] x86/resctrl: Handle number of RMIDs supported
 by RDT_RESOURCE_PERF_PKG
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-26-tony.luck@intel.com>
 <50149b02-d6ea-4fb2-806a-f16e80d3d52b@intel.com>
 <aRelbFgQ4-11Xwg2@agluck-desk3>
 <8ca676bf-7b50-4898-baf1-92241712f871@intel.com>
 <aRtPL9IQXWiKfhEk@agluck-desk3>
 <cdbc23f6-cf4b-4e83-a037-0aaf7c076e8c@intel.com>
 <aRtu0J4os4bXTLV2@agluck-desk3>
 <f3ec7e8b-b042-4d38-823f-4f4174cb9d09@intel.com>
 <aRyuY_TF5d6Me7MD@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aRyuY_TF5d6Me7MD@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::6) To SN7PR11MB7566.namprd11.prod.outlook.com
 (2603:10b6:806:34d::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7566:EE_|CO1PR11MB4945:EE_
X-MS-Office365-Filtering-Correlation-Id: 7704d73b-aa3a-4646-bd06-08de26cddfe7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZmFTMEJrVGk0cnd1VUVOS25aU1J3K044c2IzTnRRcUp4V2RmS3NKY2s4L1Vh?=
 =?utf-8?B?NFdGNllvQ29adFdWek03MFR4bG5aSitsZi9sS0s5K0NCQ3UzS1RJdVpnWUdw?=
 =?utf-8?B?YW83WHVKQVc4U2hXb2ljejllYUxiUENBVTRwaUF2bUxjbjY5T01nZlJQU2tM?=
 =?utf-8?B?UkpuZFdOYUNaTTlyRVZST28zNVdIVXhmRG5lb0NuM05hMEFiak1xaGhjdDNP?=
 =?utf-8?B?WG52YUwxWnNiT1lFdVF3V3pDc2lQUXVFRTVPNlgzWTNXRzdvYmx6WE56MzR4?=
 =?utf-8?B?UkJRalhSMC80bi9DbDVvUnpuSkNvQVB1SDhRVnhpSW42b1VTTzdNbkNNTnhJ?=
 =?utf-8?B?NlpiZ2FMc2xSREZaYmExR1psVFV6NW05N21FOVJrRjVRc2FvN1llTzZlanIv?=
 =?utf-8?B?eU9jQnZ3bkJ2SmdvUDZuR2hFZEVKcCt2UzhnZG51UzNWaFg3amRSMzdIbnNB?=
 =?utf-8?B?S1dDaHhLdzd0S1ZLUkdzTUltWUZOYlE0Vjcvc2lQRHMrdjQ2TEZIY1U5YjAx?=
 =?utf-8?B?OENSTENVdnJ4UGxxblh4dTZSV0NDZ3Q3ME5WTjhENVNIRko5TStxdEVycUhq?=
 =?utf-8?B?OWk5c0o1M1ZCdlVSNWVwVHI2ajhvUUVLUm15SWt6OFNEaGVXNEMzdUIzVkd2?=
 =?utf-8?B?V0Vuc0RqelBXNFMxUXVCdjlGTGs5SjR2WC9sSHBYQ0QxYlRGZnVPYkxZZE04?=
 =?utf-8?B?UkdXN0tPRi9UY1hLb251SCtha3E4a2lxOFBmMGQwZDJjOGZuSjlOdGZYOHZ5?=
 =?utf-8?B?K2FZOHdEc3MrTlNtRkJUNFpOUkpibDlsVGpJcXJCYlVsR001R2VoQTdOMmt0?=
 =?utf-8?B?Rk5qTm5FM3JFUjJCUkh5TGZ3SDg5UU11aWJ6SFZrcDJwMUJ2Uy9uL1d0TEpC?=
 =?utf-8?B?cUpQY216RmdGbkkyUTh6dCtTdGU5WksrRWYvZ2djYWpLRkp4YUxhdUloZzlE?=
 =?utf-8?B?OVZ1OHQzemZoNE5iOExERzBzNkJvQTBidDJwY2dhQWVxUytHUmd5ZW8zeDF5?=
 =?utf-8?B?bnBSbGNsTFR5czFOR0ZqYmZQZU1jTVlsczBwU2dNSUExNkgxbTZiY1JxaEJ5?=
 =?utf-8?B?KzVpSklTOHA0ZW1ubWxKdUVhRXdoQnVYc0dZY293Y25YaHdrNnRIb2FjRUhY?=
 =?utf-8?B?WWwxeEpnZ0RPZ2N3YTdKR3IrSWZvNmxTMm9ESEI0QjVGWkMrZUNEUjQzeWRz?=
 =?utf-8?B?UTVDa2NQbDdRc3dOK1RKV1NiWW1wTmFIWGVnTUtrVkMwL3BxU0ViRzFwWU9L?=
 =?utf-8?B?VEp5ZHdwTVFVdmdDTk4xd3JRblY1ZDV3YWJvQWVJUTY3dStuMFFMMEppaDhH?=
 =?utf-8?B?YnoxMWVGT1BaMGhxUW5SZy9GNHo3aXV2OUtwOXczRXNNd3ZScGFYSTd5MzFI?=
 =?utf-8?B?OGtYWGFYMmk0cXEvN0gwYjJDMGZOZXVvNmpRWjFQSDJzWDBsOVFJS2g1R2E4?=
 =?utf-8?B?QWxyQUNYa1NRdlBrUU1Od1RZRW45enpyM29rVlVRc1ZLYUlzK2FnVnRBc2di?=
 =?utf-8?B?aXlNQ29qVVdSZUJrTlkvTlF3N1VrWHNXWSsxM0FObjZQWVlmYVhxdHIzVXQx?=
 =?utf-8?B?b3BCWHMvRkl0RHJ4WVlWZ3N0SzVka1dReTBzOENjYXZSd1lLTUthb0pnZlJE?=
 =?utf-8?B?SzNmT01VMDY4dWRzVkVGYUZLMkZ6ajB1UnFVNEM2SU9nTTB6T0F2WjRqZ1dY?=
 =?utf-8?B?UDBUSHB4dFFKQTVYdnJiTElXUG9aU21Kd280a0hTL0NiWVk4elp5R1Zod1VY?=
 =?utf-8?B?NVpVcG9aclI5Vk0ybWtNRjhKcDRpaC92b0NpOTRwY3hQUG5yems3ak5iVFhE?=
 =?utf-8?B?MEZZVTk3NTl4emhCT0ZjdlBBb0dZanJJZ2VHWmZ0U0FmWWkrMlFEYjVjeUFF?=
 =?utf-8?B?bFkzOEpOa00vcWVSaWJGZmM0MHZYS0hCTUFBVUFkbVkzNU1NYk5xN3NGTXNP?=
 =?utf-8?Q?iwP+/IfinTM2+QBoyTOCKh1APpC/W4ts?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7566.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bTRLS2ZQL2RUUUhpQ1YrZEpaNmt4NVFSMk1FNlZMT3BnQlBQL01yQW45R1V6?=
 =?utf-8?B?SXAzOGJuUnVLVnhSblZLTUd3cGxWK3l5aW9td0hhSmJJbE5JTHlwbUdIZlpk?=
 =?utf-8?B?NFpuTG93VUxsSnlRQ01tRHJPdXlSL1JjMHlqUlgxNDdmQVU2R2krVktIYmNa?=
 =?utf-8?B?aFhiSE9TRHpIeGRFMjByVFhtUDkzVFdrb3kwalhKNkdkcnFDOGVnSmpPRGJG?=
 =?utf-8?B?VU1rN3NVT0haVUU0QVVLUm5QTERXSmttN2RCcHZQaEJRdTBsTlpmY3F0bCs3?=
 =?utf-8?B?TXI2alF6U0UxQ2FJYUZoRmwrTlI5YnBSV3lVY2ppemZsbXlxcU5Md2ZwdUds?=
 =?utf-8?B?ZXNsZTZxc3V2MlptNUQzQUI1UjM3ZS9ONmZxSWloakNRamlIRVIzelp0K1kx?=
 =?utf-8?B?WWQ1WWo3QkpEVWxsbEZCdS9FUXdZekk0T0Rjd0N4VlJUYi9Edm5vZ2htQ1Bl?=
 =?utf-8?B?TnJiNjVRdmx4SlRWS1ZLb216UThTWVpEMzR5cFlLbHlvdGNMYlJMNm5ZSWNL?=
 =?utf-8?B?Q20yNm5RZUJYem16RWJrMnRIRTBsZmVPMk10ODRqMGl5MzErMlB0Rm1GNTZm?=
 =?utf-8?B?UXhHVHduVkp4L2MxRWYwU3NxR2o0UWpxSW9HNGRraUZYbU4yRVMwT3I1Y2Fr?=
 =?utf-8?B?aUVmZXUxMFYwMFo3amZtRWc1enFhZzVKTVA2ZWVyQXRmUENFaStpdlYyanZG?=
 =?utf-8?B?UWN3S0dDS2FsT2U4VFVGNUQ3MTc1cEVFK2k0WXRBcEhXbGZXaTNvT203RlZo?=
 =?utf-8?B?NW5YK2VrNjU0OTdKNVJCaVFpR2hJZWhVVHhyNmRLYUJZVThiRlg5UDduYkpr?=
 =?utf-8?B?TGcwdXl0WWpNZWxqR1l3SnRsUnFjWWM5UFYvU2IrZVNuTFB4eHdpVDM1TTdY?=
 =?utf-8?B?cUIySldMclR5My9WWVl1WTlzTkxpUGwyS3A4UUJFV01tZlFjZWZjOFJRb0d1?=
 =?utf-8?B?aStXQkJzWGVUOFEreWw4WCtZM0JTQ2Y4QTJJQS9WenR0b3VCSmZYNWhGTjlV?=
 =?utf-8?B?cmVuRFJ1L3I3VmhqZ3hBTHo1dGpJRGxhZHIvdndQYUJlMTFEK3BoMkdoVVdy?=
 =?utf-8?B?ZFRwc0haZkRUSEN5bkRzZGN5b2VPMm1nVTdJeVR5VGNjSlc3R0o1eGd0U2Q2?=
 =?utf-8?B?VDdUaVRJTTE0bkx6ZHJoaVFoWHJnVXo4QTllekhJNTRNU3JlZ013OGxYeUo1?=
 =?utf-8?B?aTVGS1MvWTZJZXdwVmZaK2tWWmtVd3VFb3cxRkVlVUQ4R0pzRmJId2E1MERX?=
 =?utf-8?B?dHl2Rm0yREYrdFVocFJaRmdlNGxXa1Y4dUl5SGU3SWg4YWpYaE44c3FIVmYw?=
 =?utf-8?B?cGE1ZTFNblR4VFg2NFoyRjNya2ZUV2c4aFA0RWVLMG5iNE92K05JaVFSMzhP?=
 =?utf-8?B?NWtiZWswKzJDUHhvSXY4dFNaWHN6dWY1T3crb2xxeEF1ZWovQkZxTUtMSEJj?=
 =?utf-8?B?YWhmS2NYeGhjamk0Wlp2RjlxVGp2VjhPdktjTEZKRjQ0QmRWYUNPZk9maVY0?=
 =?utf-8?B?TG1TMGkyakJ6aSsyQi9FTkkwdmdTYXoyRUJwOGR5YXVpNjhIYVAzc3FXQm5w?=
 =?utf-8?B?eFB5VXVHV0d6Ym81S2xCMmNZMDkxeWF1T0VxenpCRzZOV1JqVkZteWFJajdh?=
 =?utf-8?B?bkh5Sk1hWjExVUw4aUEvR0NzbGVtSmVoQkZMSkltM3RvdncxVzNKbVhIYnd4?=
 =?utf-8?B?dGxwWDkrS3JMQ2ZiZ3BVVDNQbEdhTDd4RXhaKzRzWnVFZ2JFbHlBa2Z3N2FC?=
 =?utf-8?B?RE9QcDhoVWI2L09MeVJnVkJFQnFrckt2alpubUIrOHdnOXY0dWlidjlxS05l?=
 =?utf-8?B?NDEvMy9kOCs4UVlIRjIyakxKYzZBZzloWWY3WEhpa09oNk5wS1E5cHFKZklB?=
 =?utf-8?B?aldvSFd3dENPZkpza1doNnNhZmxKcjJVbnJ3MXdhcU9sa3JLa0M3RUhsRVAv?=
 =?utf-8?B?ZW42V1FmNXllSU9DbHVTK0ZCZ2V0dEU1aXdNZ1d6L0cvdFdKa2ZBd1NWbGVt?=
 =?utf-8?B?ODA0aVZsd3RHY241ZUllT1hUN3N5S2Zjek9ZeGRGamlsYUlKQndHeC9TTVJZ?=
 =?utf-8?B?MkEwemJzSjQzbW9hOUR0aStLZjJ0WDhJR3FpWXlsTms4cjQxYlhoeEdWbWVJ?=
 =?utf-8?B?L3kwTmdJV1F5UGd0dUFwUEt5Y084VVl0SzBYRmhpREJPdnN6N1MxU2xDNE0r?=
 =?utf-8?B?cVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7704d73b-aa3a-4646-bd06-08de26cddfe7
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7566.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 18:11:20.2113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rOGNgJdbVcj4dir5VDvLi7BlLWBYfHvjKfD4Hup1045RcLe9AIHUdFOEPp5MiobXY07Lj9hSahW8pzUGAlslkPz7OMOqwHg+tj+lK3XC2gU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4945
X-OriginatorOrg: intel.com

Hi Tony,

On 11/18/25 9:35 AM, Luck, Tony wrote:
> On Tue, Nov 18, 2025 at 08:48:18AM -0800, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 11/17/25 10:52 AM, Luck, Tony wrote:
>>> On Mon, Nov 17, 2025 at 09:31:41AM -0800, Reinette Chatre wrote:
>>>> On 11/17/25 8:37 AM, Luck, Tony wrote:
>>>>> On Fri, Nov 14, 2025 at 03:26:42PM -0800, Reinette Chatre wrote:
>>>>>> On 11/14/25 1:55 PM, Luck, Tony wrote:
>>>>>> How a system with two guid of the same feature type would work is not clear to me though. Looks
>>>>>> like they cannot share events at all since an event is uniquely associated with a struct pmt_event
>>>>>> that can belong to only one event group. If they may share events then enable_events()->resctrl_enable_mon_event()
>>>>>> will complain loudly but still proceed and allow the event group to be enabled.
>>>>>
>>>>> I can't see a good reason why the same event would be enabled under
>>>>> different guids present on the same system. We can revisit my assumption
>>>>> if the "Duplicate enable for event" message shows up.
>>>>
>>>> This would be difficult to handle at that time, no? From what I can tell this would enable
>>>> an unusable event group to actually be enabled resulting in untested and invalid flows.
>>>> I think it will be safer to not enable an event group in this scenario and seems to math your
>>>> expectation that this would be unexpected. The "Duplicate enable for event" message will still
>>>> appear and we can still revisit those assumptions when they do, but the systems encountering
>>>> them will not be running with enabled event groups that are not actually fully enabled.
>>>
>>> There's a hardware cost to including an event in an aggregator.
>>> Inclusing the same event in mutliple aggregators described by
>>> different guids is really something that should never happen.
>>> Just printing a warning and skipping the event seems an adequate
>>> defense.
>>
>> My concern is that after skipping the event there is a deceiving message that the event group was
>> enabled successfully.
> 
> I can change resctrl_enable_mon_event() to return a "bool" to say
> whether each event was successfully enabled.
> 
> Then change to:
> 
> 	int skipped_events = 0;
> 
> 	for (int j = 0; j < e->num_events; j++) {
> 		if (!resctrl_enable_mon_event(e->evts[j].id, true,
> 					      e->evts[j].bin_bits, &e->evts[j]))
> 			skipped_events++;
> 	}
> 
> 	if (e->num_events == skipped_events) {
> 		pr_info("No events enabled in %s %s:0x%x\n", r->name, e->name, e->guid);
> 		return false;
> 	}
> 
> 	if (skipped_events)
> 		pr_info("%s %s:0x%x monitoring detected (skipped %d events)\n", r->name,
> 			r->name, e->name, e->guid, skipped_events);
> 	else
> 		pr_info("%s %s:0x%x monitoring detected\n", r->name, e->name, e->guid);

This looks good to me. Thank you. I am not able to tell from this snippet but since enabling of
an event group can fail at this point I think the r->mon.num_rmid initialization should
now be moved later so that a failing event group will not impact the number of RMIDs the
resource can use.

Reinette



