Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF935322A0B
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 15:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757519805; cv=fail; b=IIYrf45hoqZewJJoM2f2a5dtTkwNCpIbFDXi/CdJPldtUXkFIV49Iq5aizwpt8jCQmbq+uixqb59m8+DXt/64qmH7sHlzo89kaGZJM9l3AXN3bo4sEuA6zVCxEpFvnUJFRpQJFlE8SC/rkq+hsIr9YtdVCxtxvUAHHDUA4SkW1o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757519805; c=relaxed/simple;
	bh=SoCPmeep5TAXSZ58IIKGBEscac/AIhAFD7OpVvz2D3M=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Emf9AncR/b78DpY1lXRmu7ywNYZ/JepHLK2iZvhmyRWcJL3AkiijRVAwsyUJwuFdfSkKFscfpNHQ7dQJqCdvsqaZ9akZf7HhbImpgwA+cHq9e9acXwytd1I0s+F+SXvMU9y/JOs9Ds97mKrsQodQQm5lNZo79IRDI1jf1DmS+to=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QGxhKLnr; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QGxhKLnr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757519804; x=1789055804;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SoCPmeep5TAXSZ58IIKGBEscac/AIhAFD7OpVvz2D3M=;
  b=QGxhKLnrsmZtpVWGETAwVNL/vSMwZFUbSGmvtv1rS4B8UbxGg2AGOxNV
   /ht2LlwxgqNabHWHPMuiP3tLdL/JbiQi7fWVtyhMsh92JMC5sP11vaRUj
   g8VZeNrHlsVo8F+ZvhM6S3TRIc98CUX0uhWLr8tEWA5L0vWoXVouDmOSa
   mMLXKIaIVUR8YCcIRDOQkTyDWUmBHV67VYL9liYXmX3x1C3/45p2nvLUH
   iGq46Jz9CxkQ5L7OGJkZf+HGLc8A4lACnU8urvGw+Jy0/Nin2BeB/fbi2
   jtaUJfxE+aySOfAnJkg/5AVQFCy7UyxBns5em4pP7FqpiRW9f8Pn5sr9b
   Q==;
X-CSE-ConnectionGUID: K2C6FYjzQgSlpg3nM4EixQ==
X-CSE-MsgGUID: PsHmjYwPSzWtAwnYHhiyxA==
X-IronPort-AV: E=McAfee;i="6800,10657,11549"; a="58877534"
X-IronPort-AV: E=Sophos;i="6.18,254,1751266800"; 
   d="scan'208";a="58877534"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 08:56:41 -0700
X-CSE-ConnectionGUID: JBfohUdXSsC3X1+MRKVYRg==
X-CSE-MsgGUID: Fdbz/V0yR86Ts02d7p/HiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,254,1751266800"; 
   d="scan'208";a="173512785"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 08:56:39 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 08:56:37 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 10 Sep 2025 08:56:37 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.51)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 08:56:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Na07jOFcgdyw/lO6ZIiiXUrgBWTW4KN4PS799Rn4XED00E9iPwiCZ0AhNMhpspFXkWyr0SO6zsPoevkqJ90lTc+uXchV18nrk744meXyecHh0HN0eKaews6KTsJVilp/QEWYV1jsvObKZiBLIdCRMElaO0saGDm1O6epJlmE07ZmY4FoK3AyCNKwM85Aq17XAmnwMmVkeULHJjral7LNr/x+HETcxFg87lCZR7FLkZM7sb1skxz+kP5HMts5gftm7rzo2Bgtq0XrwsIsx6lUoFLxdCFVu+Hi/9A9QxUvfOciUXJbkZLSATWYrlJ7iciyZWywWA9oVsggG7fdLTbIug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=klqe45IxTopS5+IM3/tpHSh0ioSe0k3wjahPidQsH/k=;
 b=vV2Q5Kj0vFfU6vjDs3ZOQxsvBBYKI1DfScCb1LN3gsJ//wWyBreP7jzelWOG2jYcc7K1/gXdWKBS0A9D5vW1ub+8xglM2TQ8Uxw5hP730lcVDq3m4gf07UQzWCOnQB3qJzMcyVhG9lc9i/oNlf+PoGuCwHAtCnuxSqfpr9TcB6UDkdN4gDQFpH7ohEV84SlEdPDFht4cZl43hmCNqXBBnSwBOOohEsGpE0jb4BwowqSgoDlewjMSwn03SUV/i5dcf1Jvb2i7v+1x/aMML2SpKB14Y2/VCmaXIoaxNMFyCPXpkCxvEbvCil99UkP2cStu2D1CW3UuiFM6bRQ3EEVOOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA2PR11MB4938.namprd11.prod.outlook.com (2603:10b6:806:fb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 15:56:35 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 15:56:34 +0000
Message-ID: <9915627e-5680-408d-855a-d4acf5d98e9e@intel.com>
Date: Wed, 10 Sep 2025 08:56:32 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 23/31] x86/resctrl: Add energy/perf choices to rdt boot
 option
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250829193346.31565-1-tony.luck@intel.com>
 <20250829193346.31565-24-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250829193346.31565-24-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0072.namprd16.prod.outlook.com
 (2603:10b6:907:1::49) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA2PR11MB4938:EE_
X-MS-Office365-Filtering-Correlation-Id: 45e84d5b-2757-4349-4b2d-08ddf0829e03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?b0pxaUQyM1BQMjROSVRLSXhlVS84dFYvNDZ1cm55QmRQVlVEQTFxeExUeDBU?=
 =?utf-8?B?WFRETk1XVTRtOGltejlRQkhjakhVbVF0cEtnNTJ2SjE5SDZWOXFFRU9HY0Er?=
 =?utf-8?B?U21mZFpPeVhYSW05bHhpUlkrV015NXlLVkc3Snc0Ymc5VkhjTnJ1NXV0Qzdl?=
 =?utf-8?B?T0gvNU5mQUdLK0t3VVBHL08yb3VBWDJ3b2ZFSEtnWDQ5WUlNRkkvaWRYYmVC?=
 =?utf-8?B?ZmQ3b1dZTXVnM3JlOStWaXEvdzhpVUs5VWpacXpJY0FXQlVJZUVmelQ1bWVR?=
 =?utf-8?B?bk9GZ1pKUXk1cGJGN3BMKzVFQUE0dU1tR1lyL0VRc2t0VE10MS8vbjMxS3A3?=
 =?utf-8?B?Nkgvc3VZR2RBbGhYd2IrN3hVdUM5TUpoUEhZamVqYUd5dTJxNVJKNGh5bVYv?=
 =?utf-8?B?bmIySEFWZGVBcXZQbHJnM2JiRDJxdSsyempqZWpNWDdsS3lLbFlTMlNGQk1i?=
 =?utf-8?B?VWVPT1N5VDd6VnB3aU1YOGZwWWFFUTV4TDFWeEo1ZksxcCtQcU1SWHNFRkQv?=
 =?utf-8?B?blNHRTZTaVJERzAvUmhIeGdrc3RnZ29UOHMvZFNLVmNUU08zbzArLzFKZlFv?=
 =?utf-8?B?NW5LRk5aOGgzYk5MakZPMURsUjJTQndHcDFzVWlDTitvVTRsZUhSRlNwdFRs?=
 =?utf-8?B?enVnckg0dG9LTWY4eURnQVJBaWxkMHBQbVcwdU41M3BUSXdtU2R2OTFidnhy?=
 =?utf-8?B?N1VWQlJPbmF3eEp0Mnk4QXQrOUVKSEd5Y1dMZXpUWFhWL2JZMEVrQ2Y3eDA2?=
 =?utf-8?B?QkhLa20vYUZvWFRwdFpyWENxeDJ4Z3AyWXdSUHJpUVZvRVVud3BvSXE4Zkxx?=
 =?utf-8?B?dUxIYXVaWldIVzNpS1VCOGFrbHVjUHkwYVNqQWdLNVlJSFdrNTFUV1JCaTdF?=
 =?utf-8?B?SFNpdlc5c1gwM3hRMnU5SHBNQWFvYmJNZkhRVHA1SWFMSmdEZmw4NFk0cDJH?=
 =?utf-8?B?ZncrWVEvSGtNQ21ycWtoUHQrbUp5RE9MYmIza0ZYTGMveFFXZytvM0d5Nm52?=
 =?utf-8?B?a1JKWldWR3JCVjZ6RTNpOFpBMFF4UXcvVDNWTk9lR1grMkl6SlRWWHdoTVBI?=
 =?utf-8?B?dDJNMzFLT1hFd0c4Q3Q4SnVrYzkyK3NFYmFpdzIxenRYQ3BDNHJhSjJjZG9z?=
 =?utf-8?B?U3NoUG5TMU5JdUpDL2dnSm8rNVVTL2VqN0dJR3hVcmRnemkrWngvaXVWT0pU?=
 =?utf-8?B?djVJWXhPRm93WXVYSHpnZS93NDFVWWFMRXhGeS8vajBYdHZPSTBDdjQxb1lK?=
 =?utf-8?B?RlpEYnVDeHlRWit6OEI4RDBBS0VKUUU4T1BoOWgyWWdIK1ZrNFBWektlOVo3?=
 =?utf-8?B?Z0VrMkVReE9ERmJxQVoyYmlhL2ZQUGVPc2hlMHBjMko3dXZkSUIvaW5JYVZ6?=
 =?utf-8?B?Wmd6MmlWUVRQS0RHK2dER2piWVpobkEzKzByK2YrNCs3UGhlb3FDUW5sVXpM?=
 =?utf-8?B?RVVQQTVVdHBFamg2TkZiY1BYT3RBK3FsRzhYT2dFNDdSdmpyK0NOdmlEdndX?=
 =?utf-8?B?NEZycDZmWng2MFpPcTdjYlc1Z2RVVkIza0NEcjBtNWRRd3ZKRUtjTkVnY3Vp?=
 =?utf-8?B?TGFoWDRpNkp1Z1V0MXIxeCtSRkNWRGEvREt2anRVdUVyT0VSWFRlS2lIc3hs?=
 =?utf-8?B?dXlRS3piOEl5MU83eHh2RVBLSUlKY0ZaVnpUT0RvTmdxTWFOaU14bFFkOXYz?=
 =?utf-8?B?dm93Rjk0SzhManNlc0NmWTZWSXRrNTVad3UxVTZJdTNUbkFxL0kzVDA3bzBJ?=
 =?utf-8?B?R3JtL3BkaHY2MENWdkdBNWxjS2lQb1hYTFIrSEsveUdUMkFjUk9lY1FEQlcv?=
 =?utf-8?B?djRjeDMxMlR0OXBweHcwbG9UWnNFSTRRWk9DeHRmODg0ZjRaOWh1MHAvMkVu?=
 =?utf-8?B?NXFuZzZkQmZxTW51UnM1MDUwOHYxRXNLdU92b2ZvK2w5UzdXRnBrVThFekhX?=
 =?utf-8?Q?qX+fTvVr2/8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZnVEc2Z4RDZRUitYSFhGK3phNTRZWTNRNjZMU1RrT3lONUQxRE5QNU1leVhD?=
 =?utf-8?B?MFR5N3VaZGFwQmdJWkxRLzM4cmlyQU1YZXVveG9hU2w2SG1ZVTdYbldEQ1ZW?=
 =?utf-8?B?K05VTFRqeWhkaExWempjZU51YnpsNWZSdkJZd2ZJcDBrRW9xWld0QWtQekNF?=
 =?utf-8?B?aFJsSVAzaG53MUNzRlQyd0k1WkFFUTMwTEdHU2dHcVpRbHRlSFdCUUhLWHJB?=
 =?utf-8?B?QXdSa1QwUXFocEtWcWlnc09IcjJmVGlkYkxjWkdoakJNay8vQStnZGpSTWdn?=
 =?utf-8?B?My9MQ3hUMHpTdmxSMTgwMnV2WVlKT3dhdVphSUt4WWx4VFJxdEFHWlFDN0xx?=
 =?utf-8?B?MXJoeENJd2ZVQnlyODNrdjhCTklUZ3gvemdqajVkUk9zZG1URHpBcVU2WGkx?=
 =?utf-8?B?N1g4aWxtUlh2dm9BSHFVMEFReGFwYmV6Z1g3bDhLL0MwR1A5cXNGUXZHYlpW?=
 =?utf-8?B?eWgvclVWTUExWXpHL3RpYzJPUDNxVmwzc1hYZjZXdkF5cWlFSTQwY21odzJF?=
 =?utf-8?B?aWtmRmxpYTZ0WitmZWVjRnY4em91VEtOVThNVSttVFRIakI2SkQxKzU4MUp1?=
 =?utf-8?B?alVLaTU0RGRia2drTS9MMWxCTEw1cENTWDhvUnhKNjd3NGQ5czBDSEZYZmtM?=
 =?utf-8?B?WXIvVUJpbEdzWnkxbS9rTHJSU1FFcGVMQjlHTW1QYk96TEw4bm13SUFoQXBP?=
 =?utf-8?B?endIQ2Mrd1BIcVVwMlVjT285aENKYUdIU3pwVGFZNW94RisxWjc4TjZBMU9Y?=
 =?utf-8?B?Q3ZJYzluYjRZQTk2OElTMHJ5K1FmbWVydmhhdEtobE9jRWRHT0pTcXdsV01L?=
 =?utf-8?B?TElrYkNtaDRvaE1VQ3B2S2JaSW1NL3FXSDU5d1JuSU1ReEZLckQ1ZFNmUFhz?=
 =?utf-8?B?Mm1aaWx4WlEzNEt1V2YyL2ZqSldiN3RWMWx6Q01rK2o5aWlFN3Q0VytOOVph?=
 =?utf-8?B?RGpxaGMxM0RSZVBIMi9mbEdVN1hkaHROR1BqMWxzaFJEc1JDbU9yZ3ZpLzV5?=
 =?utf-8?B?MzVrQTBtdzYybXVVWU9yc2c4eENmNXNCcExBQmxNVnJ2Wi91THhLTCsvRXZ1?=
 =?utf-8?B?eFRiU3BicjBDQ3BOWjEzYWl3YW9NOXlWaVZWUHZYNktSbStsSnh3VnRvTjNa?=
 =?utf-8?B?SEF3cUhjZllHNlo5ZnpOYllMMWRxY2ZnckpJYXU0NzhWUTVLZGxHSWFDZUlX?=
 =?utf-8?B?MjBBL0ttSG9TVTVxYkFZL2h5eFpzamNWQVNxZXR0U0RESWozeWcwVVBwOXgr?=
 =?utf-8?B?WG9ic0pkbUswWmo3NWpBQk1ZVWpGWVBwTXlTdmxEKzk0Q3JvMmVyVi9MTURU?=
 =?utf-8?B?S1YrdFBzVlRoSUNwZ1U0L0wybkNnaXFBQUhJZ0lzQml1cmp1T0ZsdkpEMzBr?=
 =?utf-8?B?VytHQko4T01TQjBEQ2hXR0NaUEtwZVU1aldUdU5uTzFnaVdwQUk5dWFiaVZK?=
 =?utf-8?B?MTBsZkhVT2thQlAzQUdKZ3lqemZGeTR3ZlFLeHJBWlJqc3hGNFFhODRrRzVz?=
 =?utf-8?B?YUk1eUpyTGFZTGZjaVZrZDM3M3hEekdBL3l3NW0xZkI4VmtnUU45ZzlFTUJ2?=
 =?utf-8?B?MjBiQytzQlNtT2JaMnAxS0FDTmRJV2NHM2VuVUt1cGNnQ1dFMU1EOFFvNmFM?=
 =?utf-8?B?ZThUdHJQMjVRdVpFNW9mbEJtQkJLVy9lbldDZFZ2cmhrL1NickY5dUNOdW4w?=
 =?utf-8?B?bnlFOVptTUs1bExHM1ViYjhQam9sN1ZQU2VYeEpTUXQreFYxdk9vbUZFNFZq?=
 =?utf-8?B?ZWFoMDNLd3RrTzFkMU5FSXZ2S1h6VVdMQzdPRXBEdW5JbDBzTEI0S1UzNUVm?=
 =?utf-8?B?LzkzVktpNUcwdUZDbHlSV0tCazBHUGcyeVB3dEVKSWdranEwMFV1VTkvL3kr?=
 =?utf-8?B?ckRCV3JtcWwwcTNZdFJMYmVDa1NCci9vQmplT20xYnlCYUtQaE93OTFHbmpJ?=
 =?utf-8?B?SEtlb3BQRHZZSUF0cnZmejZRQkJGTHdXeXRmV3pzalYvTk03amRiTmJ4M0p5?=
 =?utf-8?B?QzI5OG5GTWRacXA4dlpENUdianhZSll2aFpQbklxMStlckcvRzlrb3FDNDZy?=
 =?utf-8?B?Y1hod25xUjUwSVFZVExQZ29Ob1BkU25WY2tUTXJDT0tjdHZDVmNDRExzYStW?=
 =?utf-8?B?MGxmVG1SdC9UTFY3ZnRIUm16T3NQV3VrUDlVRXZRMG9iNFVSZUJ2Y21pRHZJ?=
 =?utf-8?B?aUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 45e84d5b-2757-4349-4b2d-08ddf0829e03
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 15:56:34.6441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yfXJ4ugTqhrqKydwvolYO1mpzAhE2Js3iwnm0X+h8uelaYHuXKZLzroWTdTBQbHiNm3+VtPYGVc0HGvQRUpMGNjMzk30NthFc3bfTaHFSR0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4938
X-OriginatorOrg: intel.com

Hi Tony,

On 8/29/25 12:33 PM, Tony Luck wrote:
> Legacy resctrl features are enumerated by X86_FEATURE_* flags. These
> may be overridden by quirks to disable features in the case of errata.
> 
> Users can use kernel command line options to either disable a feature,
> or to force enable a feature that was disabled by a quirk.

Above two sentences can be merged into a paragraph.

> 
> Provide similar functionality for hardware features that do not have an
> X86_FEATURE_* flag.
> 
> Unlike other features that are tied to X86_FEATURE_* flags, these must
> be queried by name. Add rdt_is_feature_enabled() to check whether quirks
> or kernel command line have disabled a feature.

Above two sentences can be merged into a paragraph.

> 
> Users may force a feature to be disabled. E.g. "rdt=!perf" will ensure
> that none of the perf telemetry events are enabled.
> 
> Resctrl architecture code may disable a feature that does not provide
> full functionality. Users may override that decision.  E.g. "rdt=energy"
> will enable any available energy telemetry events even if they do not
> provide full functionality.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> 
> starting # with '#' will be ignored, and an empty message
> aborts the commit.  # # Date:	   Mon Aug 11 09:36:45 2025
> -0700 # # On branch rdt-aet-v9-wip # Changes to be committed:
> modified:   arch/x86/kernel/cpu/resctrl/core.c #       modified:
> arch/x86/kernel/cpu/resctrl/internal.h # # Untracked files: #
> 20250811181709.6241-1-tony.luck@intel.com.mbx #       cscope-x86.out #
> cscope-x86.out.in #	  cscope-x86.out.po #	    v8/ #

Mangled changelog.

> ---
>  .../admin-guide/kernel-parameters.txt         |  2 +-
>  arch/x86/kernel/cpu/resctrl/internal.h        |  2 ++
>  arch/x86/kernel/cpu/resctrl/core.c            | 30 +++++++++++++++++++
>  3 files changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 747a55abf494..b600e1b47b0c 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -6154,7 +6154,7 @@
>  	rdt=		[HW,X86,RDT]
>  			Turn on/off individual RDT features. List is:
>  			cmt, mbmtotal, mbmlocal, l3cat, l3cdp, l2cat, l2cdp,
> -			mba, smba, bmec.
> +			mba, smba, bmec, energy, perf.
>  			E.g. to turn on cmt and turn off mba use:
>  				rdt=cmt,!mba
>  
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index b054c7cd13f1..6948803721e4 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -177,6 +177,8 @@ void __init intel_rdt_mbm_apply_quirk(void);
>  
>  void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
>  
> +bool rdt_is_feature_enabled(char *name);
> +
>  #ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
>  bool intel_aet_get_events(void);
>  void __exit intel_aet_exit(void);
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 5745c6979293..d6e7a9125a10 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -763,6 +763,8 @@ enum {
>  	RDT_FLAG_MBA,
>  	RDT_FLAG_SMBA,
>  	RDT_FLAG_BMEC,
> +	RDT_FLAG_ENERGY,
> +	RDT_FLAG_PERF,
>  };
>  
>  #define RDT_OPT(idx, n, f)	\
> @@ -788,6 +790,8 @@ static struct rdt_options rdt_options[]  __ro_after_init = {
>  	RDT_OPT(RDT_FLAG_MBA,	    "mba",	X86_FEATURE_MBA),
>  	RDT_OPT(RDT_FLAG_SMBA,	    "smba",	X86_FEATURE_SMBA),
>  	RDT_OPT(RDT_FLAG_BMEC,	    "bmec",	X86_FEATURE_BMEC),
> +	RDT_OPT(RDT_FLAG_ENERGY,    "energy",	0),
> +	RDT_OPT(RDT_FLAG_PERF,	    "perf",	0),
>  };
>  #define NUM_RDT_OPTIONS ARRAY_SIZE(rdt_options)
>  
> @@ -837,6 +841,32 @@ bool rdt_cpu_has(int flag)
>  	return ret;
>  }
>  
> +/*
> + * Hardware features that do not have X86_FEATURE_* bits.
> + * There is no "hardware does not support this at all" case.
> + * Assume that the caller has already determined that hardware
> + * support is present and just needs to check if the feature has been
> + * disabled by a quirk that has not been overridden by a command
> + * line option.

Another recurring topic. Please do not unnecessarily trim comments to be
so far under 80 columns.

> + */
> +bool rdt_is_feature_enabled(char *name)
> +{
> +	struct rdt_options *o;
> +	bool ret = true;
> +
> +	for (o = rdt_options; o < &rdt_options[NUM_RDT_OPTIONS]; o++) {
> +		if (!strcmp(name, o->name)) {
> +			if (o->force_off)
> +				ret = false;
> +			if (o->force_on)
> +				ret = true;
> +			break;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
>  bool resctrl_arch_is_evt_configurable(enum resctrl_event_id evt)
>  {
>  	if (!rdt_cpu_has(X86_FEATURE_BMEC))

Reinette
