Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924CE1A5BB4
	for <patches@lists.linux.dev>; Tue, 16 Dec 2025 21:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765921601; cv=fail; b=Pf55T9mddPGvyr34IB4o9ItuHm/DVG2zGvjnE4jlYFJX3ZSqYp94UA3q/Afqfqm7c+If37ftb64YuYvO7lg46PFj4IqTDtzmhOT1zlUfEwuqw3LENKHee7JKM8g/Sp6a/WdzT+Es6NsMROP46C5QG9l73KlJk6/bVnshGiXsE2Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765921601; c=relaxed/simple;
	bh=kxtuRvEVfs3Z63WJILyGhelkA6sQPeFKTr30tjYGPqo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=M9BlgyxQkGxbV4s57+zeSynL4inbYCc8JnSUaVoOf+qY7kejqTtL9xHxvfrFZE5JFPlFMhSmK88QJ6Sy82E64mZBRbKAe6/l/HtQpXzsfH5m80YWFnud7J9ubtpQy901GKAnXEPK4toQ4JcEziLKQ6UIs1irAW+gWHpl30dVbXc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=krQ2npYt; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="krQ2npYt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765921598; x=1797457598;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kxtuRvEVfs3Z63WJILyGhelkA6sQPeFKTr30tjYGPqo=;
  b=krQ2npYtPAtXvE9486kWT2dnuuQWpiBYBPUt/8V4VXfOsD2YN6OmBdu7
   lAxV6PYDQxJunf0pbHE4/Nx32d1P9mkEiY/hyjBnd4ZYK4dCdQ7pSBFG2
   neaBhNs6PotnFCREgqwNluA8TmMI74xsN+zv3GMVe1Do0uxC86L5d4InG
   eMntZwfoVL8xpdV7E7OWraJdx8jHmg0MYFm1yY/ST+ahDSH7jXvL1QQIY
   n0VD9MEdaHD9F2TxfcrbDgdGOB939809gqcSqDG6x+lR2y5HFdAelhH2G
   y4k7H9/E1YD/quF+ux+qeB6+FPFsBzty8eWv5B8U3+PmvOgCNboAbCcHo
   A==;
X-CSE-ConnectionGUID: mQ2GzkRhSSyHlCQBYJ958w==
X-CSE-MsgGUID: JRGLIh6YRpWEY0Zx90fOSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11644"; a="67045634"
X-IronPort-AV: E=Sophos;i="6.21,154,1763452800"; 
   d="scan'208";a="67045634"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 13:46:36 -0800
X-CSE-ConnectionGUID: ncSNSfKjSJy/M7vuRakGBA==
X-CSE-MsgGUID: +WYcOjrPQqiqHbojXRdIWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,154,1763452800"; 
   d="scan'208";a="197874345"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 13:46:36 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 13:46:35 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 16 Dec 2025 13:46:35 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.30) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 13:46:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nLepoSWv0hz8I0bE2r32vbmAjK09cvsOo6o94O7cKYdgPojWhDeJGI4c4PYe6+Rrek9MNSr8f+/ldEOQyKuMw4yaVzhU9VIDCCoIo9Og1ZNySryYUHNK6absfoix75tlD5N/kBwqt2J12piPtbLEnwKHZuAiKEwj/deQUbfC4HDVw26XNLFaAVHb81sJ7EexZTtWCWSTrZR0r7ZZwdBHK+Jr2zL1k0e0cGmWVeUymbQPMU68KL+Sis+rjmvvg7hfTpf0KJopOu/WPpayjrpw8gnHvSfl8xNt7mwbBwRLuK6aX5LVJ++4Zq/8IQ2ISbC/aol+bh4PX23vo+dy3Eu+hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WxpMfjSkdpnp7afAJkY9F+0m8B80eyUhlqcuSxMb0WM=;
 b=Y0UtuvxcUcTfcBASeGDI/tUye+8wEp1KbVOp8S7uTA7mzvfrxn17Lts7J64FSF4GdRlVC7PLUgf74E3MyYLTkfmycOV0+7zSZiIP/i7Z3oKk7ACmPkJJq0zTUDhs43OUdseOOZ9njUvdUzYl/1ZuCLbud3aKbqKc2Ln0+l3vzMQXie90BpgIdZ0dqHWfXYZvArsl68NOl0RxEl63BY+kPUp8aq5EwEfuR8U3Szs5XMc4ou+wJfBWtXn53qY8MmIbmmxIeVk4d0S9Xc+sb3b4Fp/UBKFUScSyBVLapt1dfSvTycHzeCIz73YMmpZ3Ru1MQPIqzoY3axCiroLI+3AR6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CH3PR11MB7389.namprd11.prod.outlook.com (2603:10b6:610:14d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Tue, 16 Dec
 2025 21:46:31 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9434.001; Tue, 16 Dec 2025
 21:46:31 +0000
Message-ID: <b3562b29-f035-47df-a23c-508a4ce85f95@intel.com>
Date: Tue, 16 Dec 2025 13:46:29 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 24/32] x86/resctrl: Add energy/perf choices to rdt
 boot option
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251210231413.59102-1-tony.luck@intel.com>
 <20251210231413.59102-25-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251210231413.59102-25-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
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
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CH3PR11MB7389:EE_
X-MS-Office365-Filtering-Correlation-Id: bf4a077d-ed35-4a89-2fc4-08de3cec9335
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aVhuQ3JWVlBaNHF5Unk4ZkhEUTVjcVFIRDNPM1pzL3BLUmZxaGNZc3NlWENL?=
 =?utf-8?B?c2laMjU1ajROQ1NOM0FFVElCUkRmdmFQKzdWQVV4S2xOYXd2bElLMFJVWjBY?=
 =?utf-8?B?WXFIQjB3VUY4K3RNeXhFNVpqYUs5d3Z1aGlhVXJQa3JlWFc3Q0t3b1FuWGtB?=
 =?utf-8?B?ZklHYkd3ZnpTTVdvemtSbXdOcDlmczJ6NStpV0h0YU1Zd2VmbDRXZzJGczBK?=
 =?utf-8?B?S2hzc25EVXVqbmdkNEUzNGRROE4wOUx2MUVqWWlldnh6MkRwSWs5UThDSGhx?=
 =?utf-8?B?bzNlUXdKY01KKzdmWmtKRWZabC9QZGFvT3oxZXo1SENKSG9qL3c5dHdTMU5r?=
 =?utf-8?B?Y0p2L1hDNDBreCtMb08vM3BvZVhRTU1DWHpDd3Q4MTNUbXNjcFlZdmtldXVB?=
 =?utf-8?B?VjgveTRSVjh2WXArTHJEcG1YdjRlRDhiTSs5TlBmZE5XS1B4bjhYajQvZU1v?=
 =?utf-8?B?VFJ1bFBpRGNOQnVmRTUxbDcvdTdaQ0VhZkZlL1dWcmZydlo5bU9oM1RFTnBT?=
 =?utf-8?B?L3N1RjcvOGRsR1NneE9hZ2RNYnV0NDcwekNSK0ZTSm52bGswQjk4U0pOM043?=
 =?utf-8?B?SDB6dWtlanVjR1FOYjhrTlpjZTc4bkdqNFdnQXpYZjMzTmpkZUZFV3FvN25l?=
 =?utf-8?B?aXJ6R2hZbmtsMUh1RmEvc0k2Umh5NExuNDJ0VHN3cE9EaG9MRzVlNWVQRWdZ?=
 =?utf-8?B?YXp4bGloWFpkcU9lWFFPQW41Z0ZGTVorNFgyL1ozSE1tbmJCSjk1OXdCamxv?=
 =?utf-8?B?QndEamx1bnBlMXBWaXNqOTRxNUpPeUd2eUluS0sraW1XaXh5aU1SWlVLUG9L?=
 =?utf-8?B?cldmdnBJY0pNc1dZWm00cGtLSW1iS0xQVGJuZjRTRmJFdXdhODJRK1c0MkNN?=
 =?utf-8?B?RTJkVUpWTDg4OXVLVGZORXZ4WU5TRjkvNnNkVWpNQ1pxbEg1by9EWU1ZWm9K?=
 =?utf-8?B?L2lBc2E5d2R1OXF0dm1ONnl4a01GdzdRRUluaHJWYnA5M3JCZS9iZWxUMzlp?=
 =?utf-8?B?dzRNUzVCcEg0c2FrZVRGMkM4TWNza3FQWWRUdi9GNmFKemlKcFJqN2QrcENv?=
 =?utf-8?B?MkplNXUyMk9iSFJyQzRoM1NKWjBBZEJ1SnZaRmtEWmU2MFdNbzJHTXRScjQ1?=
 =?utf-8?B?QktNT3JuQTdGUGkyNlllZ1FPNVVUVnoxbGlWQTJ0bk9aK0ZMSFMzcnNsaWcr?=
 =?utf-8?B?b3o1TGpIMXNWNWJuaUVva2dzZCtDSGF5SEhFdkpVOXh5bmtldHJvZkFsanFh?=
 =?utf-8?B?eTJPNlFKem42cTh0TnE0OTBVZ3VPZ1VFRURTQ3dDRFpyNXpaRE9pM2Y2Tmpp?=
 =?utf-8?B?YnBZanhEWEs1VGw1SFJxazN4Zk9wcUpkR3NWLzFFSkhwMkxmT0d0dkxyR25q?=
 =?utf-8?B?RHZKTmRmN1NWOHZRc2FTaXlTMVNZUk5sUFRSdFJESVBtUFphbTVjbzRDejNH?=
 =?utf-8?B?UENjY1IwMHlFUFEwdGdEb0R3dWJadjRyM2R6Y0RhaUhtbHVJR0hmOWpGTngy?=
 =?utf-8?B?akFvNy9BNExqaFJyTHVvN3ZPaFJLcFFzY1Z1WDRoTjlCbTVHeDZFbkZ5QWp1?=
 =?utf-8?B?c0ljZmhQeG5vZTRYUnZuaU9IZi9JRDNYU2lZajBoZGZFbFNCMDh6bi9ETkZN?=
 =?utf-8?B?NXVkdFZqaWdKWUZXSklCeVRRYnFmdjB1SFJVODU5ZURuVXdBSHFUaHZLUVJr?=
 =?utf-8?B?Z1JLSGE1SmJ3ZXhidTFDSTFOT1dnaVA0NW9saUFud2ZTUXV0eEY2YitYT3RY?=
 =?utf-8?B?bERaOWYydS9lT1pZczg0VktQOXc4dVNjR284aEkxTW5pZGhiVkRqQ3FVNFpG?=
 =?utf-8?B?QWp3OVlGOElwbWNHbmxzRUo3MWN1cDdSRlk2NUZESFlXM2FneDc5UUVkd09T?=
 =?utf-8?B?SFRwbU5TY20wVFhZdHh3S3JJMWU4TlJsb0kvclJLaDBlNFNmK1BOUDM0QWVy?=
 =?utf-8?Q?356PEGtJSa9q+c1jmkxSZ7WbrVaT5cZi?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NG95YWNmZlBRZDJYd20xU2dKd0JPeEhrOGYzU3ZuaFZxeHFLRzJVdXpDSHdu?=
 =?utf-8?B?OTkzZ1drTk01dHRVb1FEV1Rydit2cmVoa3IwRzd6RlB4SjBIRnB5WEw5RHd5?=
 =?utf-8?B?aXRGaG95aFJGdnpWTFQ0bkN0bXRTOXBXb2VvZDJ6UnhPdll5TlhaUy9KdkUr?=
 =?utf-8?B?TFhKZC9sWHY1S0lRdVQ3MnVaYVFKYm82dFptUm1sVzRxL0RRR3Zha283eWcv?=
 =?utf-8?B?VDAwNzY4dEZQWWErbnJURTNTNnZJREtHb0FxbEZ1VVBGN2tpK2g1Zlk5ejFF?=
 =?utf-8?B?ajg4ZCsrcWdhaW51blJyN1RlQjhXMzRUcFczVGhtcGFOdHQ5ZlNyVW9TN0dN?=
 =?utf-8?B?dkMrL2k4ZDVtSjQwVGhKa2VEcXFpWlFhYU9nRXhtSmp6WDBYRmxCc0JqR2pq?=
 =?utf-8?B?RnF6clhFR2UwcHZiQk5DRmNHVUJCQlV2SkhBdEFQZ2VKbTRUMEIyd0RKWGpj?=
 =?utf-8?B?TDZLVVJEQ25rSTB3M0ZkWk9lUUlNU2FBL1QybEZXTGUxOWR3V29SYmI2Tjd6?=
 =?utf-8?B?SGh6b054UE42OGoxdG9IWnVEQnVCMHV4UXN2MlRDWTR2Wm1kRjByVy9oZndL?=
 =?utf-8?B?VzVmZVJ2OWI0ZFNqMExFbFdHK1FFYzdMYW5nYlBUOHllTWI0V3NsZ09wTjBm?=
 =?utf-8?B?ZWFwMC9BOHZlMFdFQjIrUW9Rd1BrZFZlZXhhMnZxOC9xdXRacWVtL0plcmdS?=
 =?utf-8?B?alBsaStPTytSY0hkZkRKcWgvczVyMTQvaHJYbmxrT2c2QWFDZGtBd2JSbVRq?=
 =?utf-8?B?cFRQblRnWFhpZ0dhR054UE85eHFkV2VhTFM5QmV1Qy9xRVNOdFVBb0RtMnBp?=
 =?utf-8?B?SThwZEhPMWJKWDZObFU5SXNqeTB5NG54SnlQcG96VzdKb0JvaDUvWjBZc0JC?=
 =?utf-8?B?cEFwVzJHYU5qMFdvSzJLbktiSnZpZWRSbWg5cW5IVnlpc3lZanZlWWxpbk5k?=
 =?utf-8?B?L1FyYXQvNmMzTUJkeXNNeDZRb250T1pKNHdQd1NrZ01uK2VIcHh6UnFuc2RG?=
 =?utf-8?B?dkRLMDZWenBOSWUyYmNjTExJYWdzaWYyV1E3Y1lUbmdSQ3ZCRnpnTjhXOGRF?=
 =?utf-8?B?WEdzVFNlTXpqNGJqMEhFQzl5K2E2YmdnVWppQ1FxYVdhSlFRMVlLUmg2a3Zl?=
 =?utf-8?B?czF1WTdUS1lBSWQrNnlzUDVMMFBOckxoYjJ1c1A2K1FXL0Q5U1NGdkNiRGtQ?=
 =?utf-8?B?cE44YWk0SUtYTzhXcnM2c0wyYnJ6RnNPZVg0RldpbHVvOHoreUVRQ3c4c0Fk?=
 =?utf-8?B?UFNTamdIandKZWNuaVZpWkxkbVJLQlNqRUlKdzF1SlY1azJ4L0NTRC8vUXJx?=
 =?utf-8?B?SDh0Q0xNK01TYlhEM3l5TnVsUmJHV3hNR1FKdnVEZ2doS1prS3BQM29LSEw0?=
 =?utf-8?B?QjQ1ZUdjWW5mSitXVFJJUVFibDFKMnVvY3I5dlJHV0pFWXB4Z2ErNTQzcTE5?=
 =?utf-8?B?WG1uV002WXJYNXFJaWdZRE5md0VmSXR3QXN5ejRCeHJvREY1SHBhcGhJNXV2?=
 =?utf-8?B?Z0FXcjdGemxTUWsvWnFBN214eGJMSk1GQ2xtR3VRMHUvNFhJdVFhQlJ5d1d5?=
 =?utf-8?B?VVZBbmNnV21IanUycFRlcEk5MEZDeDdNTHlFL0s4bkMzVi9YZUZtMk8xYjBO?=
 =?utf-8?B?ZzZrYjZLWmh4Vkx5MTlvUEJJc1FDenBFV1NNQzdtdFpVSURaczhzeGJqWExP?=
 =?utf-8?B?WVVVU0RlZmRUcGVTY1dGdWdSNjJzYlJGV3RwMGxVZkdHV3M5Y2NBOTV5NFh3?=
 =?utf-8?B?MjRwTDNNU1djWS9pWDV4cjIzMDUzUFNIQVZiUTZzYTBVMGxIaHo1bHZ3NXpQ?=
 =?utf-8?B?TmJQUGtTZXZRVmgvOWFTdXZVMXZaSWlOaDFEbWlmTUM1QnIyY3Ywa3RybXBx?=
 =?utf-8?B?SDB4bXJoaFZhbnhjZUQrUnF0eitNVjMyR1Z4ZTFzY1NnWWwwY1lmcnE3ZmpH?=
 =?utf-8?B?WkgxQWlma2N0Q1U2RkVXenB4STllczUwa1JHcnJ0R0szQTlRbklpa1d0TE1x?=
 =?utf-8?B?R05sUFJJNm0vRmM4NENkU2lyKzZQMjhYcmdrTU1odERBS2kwdmpWMzM0RkpH?=
 =?utf-8?B?dkdveWplMGdwUEQyakN5U2NpbTU2Z2NlVHFNbmdhTks0NmxaMWw2Zml0N1I0?=
 =?utf-8?B?OHhxdk4weEkvc3o3OFRadVUwT3JtWHFYZmx1R0o1N2pPNmZKNzNGeFNFZWZL?=
 =?utf-8?B?dFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bf4a077d-ed35-4a89-2fc4-08de3cec9335
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 21:46:31.3901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4cqyg9tXo8TpYAamghiic2A/UBd12YF8mP1TrwbCGBIqPOl4SRdVA866UBAkFi8NqMcCqJreshSQ8EuRgMQDxLN99NbuE49hS4CO9QrvmqQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7389
X-OriginatorOrg: intel.com

Hi Tony,

On 12/10/25 3:14 PM, Tony Luck wrote:
> Legacy resctrl features are enumerated by X86_FEATURE_* flags. These may be
> overridden by quirks to disable features in the case of errata.  Users can
> use kernel command line options to either disable a feature, or to force
> enable a feature that was disabled by a quirk.
> 
> A different approach is needed for hardware features that do not have an
> X86_FEATURE_* flag.
> 
> Update parsing of the "rdt=" boot parameter to call the telemetry driver
> directly to handle new "perf" and "energy" options that controls activation
> of telemetry monitoring of the named type. By itself a "perf" or "energy" option
> controls the forced enabling or disabling (with ! prefix) of all event groups of
> the named type. A ":guid" suffix allows for fine grain control per event group.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
