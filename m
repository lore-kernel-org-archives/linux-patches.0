Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCCA1EBA1B
	for <patches@lists.linux.dev>; Fri,  1 Nov 2024 23:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730503611; cv=fail; b=I4DaOPK6DnxcnymRnnEerCdEZ80ptPjWuXPR8sWd3Qv8Li8Xmcdmed6c8K2fC4e4SA02899l9iUD8NO3UKMF4BpFQxVOZDIvT2QKAB20rIeiEGO1ECivP0E2ZXsupu8XaYEyHnTU+LxdiNtTCiFyGgPngqQMzJXuJIEGgrLB3H8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730503611; c=relaxed/simple;
	bh=5gGocfPh5dWMwXf7D6Q7Z6sfSiPPXO6U6VB5rxXrj/Q=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iBWPbFDr0POXJG3SdKD0ZFfDzsau/GweTeXikkXk6yy+9pce5ih+jewYay7qJygKX/hUGdYgeQ7Z2NSN2DgvXscUHSqsfryKvgwv2g0qm4SRPmdpABklf/HUHX+0WyvSZrtf63GksWIq/sMqPjZsVkGm7IBQp6kFqDQEN3AbJHI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GPGJo5vx; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GPGJo5vx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730503610; x=1762039610;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5gGocfPh5dWMwXf7D6Q7Z6sfSiPPXO6U6VB5rxXrj/Q=;
  b=GPGJo5vxlyzuxjRCo4WkgjrDsHxKugYv03TtzW9yqcZfW+3bjud15da1
   YkEKCmaK/Hc33Cn4ZeJxt5wrhcD4r6Tmw1uEH0KAbDhDJLPumH3iGGeAY
   0It5LQH7UJQU4kp3vFO9/ijWmfy/ZXFnTKPasCgRQsdUHKdKsWLDJf/pv
   svumVl87oedD9rXA1oYXenvtR41XXVCn29K1EnGv9YZ4E45TqdryBPTbs
   F872XgNBw80RvHd7u8qRyGXBstUy42GLg1/FfDVVqSeb4B00fP0JPLJYo
   h0cyVrZp09uFKOxt666EXLB8NY+5VbTXPjL2Gpm0EQyCImPm7NwlvImqt
   w==;
X-CSE-ConnectionGUID: JJ14YsiRTVS4dHbG4zaQ3Q==
X-CSE-MsgGUID: E2s+iX96SHqJqO+d6kLHXw==
X-IronPort-AV: E=McAfee;i="6700,10204,11243"; a="40905586"
X-IronPort-AV: E=Sophos;i="6.11,251,1725346800"; 
   d="scan'208";a="40905586"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2024 16:26:49 -0700
X-CSE-ConnectionGUID: wK35g2liTiyzO0YE2qk65w==
X-CSE-MsgGUID: l7W+UnbWRqKv3Cgf5rllmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,251,1725346800"; 
   d="scan'208";a="88235230"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Nov 2024 16:26:48 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 1 Nov 2024 16:26:47 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 1 Nov 2024 16:26:47 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 1 Nov 2024 16:26:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G788oSmDnc3kuIhPs3Wj2cAGDIC3OhFa71egyMH512OcffW5ixVFgBLUHuX+SXhpmQZ200WIJnSbP0iH19dKv1xfdNdxk5DX3zgE03aTIa8YW0YMa3ILDgD0jU8V5WZ1TOD1gAlDzMaBEMwHS6YUUysl6YNOYqYiQY5Ov5deupn4kcZTTFB0FuycBQEJWs1PKVvAKuQ2bjFXSxyalstbkMYv5ByywnSaPs6TCF5IZF3eTbyBTubTLLO4ouxSl2YNxVBCBE9Q/oCNxTQ1ioZqCbqdyRvUBMx0BecaGrdmWQ1pBOnGdb9gL254NC6iokPKGPJaY9zlbDloL5ru6PtwFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5mE8fOMwT+lo/raDeFaJzqpMeO2JQ4+57NhyJ9YavPc=;
 b=KZDL/fsmeQyCprhPFoOtPBtXJkeEJzNspRaBWVpi3SH1CUfzrp1hXPOfj+tKkj7DKaxpOLrzZZjbpTC4B4t2OeupwjLZAgyiG7jLYRzpgsvf5Fcour0LHH/7f2XgL01uYPC9GlH/dpC7tv8LG86Kh3A7dDpAhUv4IeDRvHO4WC44YmZSWt1Atc9ANuW06stzAaEmp9z/tyS8FzhWSfzOBgEhadbKDKnqR14G8fojh1Ny9mpC2A2aGV3IIEzr+Zdgji9fdlam1KvWSLemAf8q6aR44YaZZ21lw57wTIAG/N84UpyTfD2YkxmId4Guqq5LVQd4vL2hYfWVHdUuT9TaTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB6097.namprd11.prod.outlook.com (2603:10b6:208:3d7::17)
 by SA1PR11MB8426.namprd11.prod.outlook.com (2603:10b6:806:38d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Fri, 1 Nov
 2024 23:26:40 +0000
Received: from IA1PR11MB6097.namprd11.prod.outlook.com
 ([fe80::8f29:c6c9:9eb2:6392]) by IA1PR11MB6097.namprd11.prod.outlook.com
 ([fe80::8f29:c6c9:9eb2:6392%4]) with mapi id 15.20.8114.020; Fri, 1 Nov 2024
 23:26:39 +0000
Message-ID: <6a677a4b-7163-cc2d-a615-6b8c499eb281@intel.com>
Date: Fri, 1 Nov 2024 16:26:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH v8 6/7] x86/resctrl: Add write option to "mba_MBps_event"
 file
Content-Language: en-US
To: Tony Luck <tony.luck@intel.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Peter Newman <peternewman@google.com>, "Jonathan
 Corbet" <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	<x86@kernel.org>
CC: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20241029172832.93963-1-tony.luck@intel.com>
 <20241029172832.93963-7-tony.luck@intel.com>
From: Fenghua Yu <fenghua.yu@intel.com>
In-Reply-To: <20241029172832.93963-7-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0025.namprd21.prod.outlook.com
 (2603:10b6:a03:114::35) To IA1PR11MB6097.namprd11.prod.outlook.com
 (2603:10b6:208:3d7::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB6097:EE_|SA1PR11MB8426:EE_
X-MS-Office365-Filtering-Correlation-Id: 12337921-6725-452b-b06b-08dcfacca332
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Z2RCem9CMnNwUFNZUmtJRGpqT0RaSzlGSVB0ZWlvMWtpN1ovNWpheTJoUVV1?=
 =?utf-8?B?eFNTSEdsNGI0Z292Q0U3NCs5OHFsTXI5N1R1OVpzUlFYOEJNSElxak12ejZU?=
 =?utf-8?B?RXpaaVhmWlVJU2MzbTRXSFlxdjV5R2I4U2NXSW5na2ZNMXdsMzNWTzJNMk1P?=
 =?utf-8?B?NXp4Q2tWZDM3V01vRnY0YmcrUGI1cU9vRGxmN0c4V21aUjRIK2JYWFZ4bHFm?=
 =?utf-8?B?M0lDbCt3a2haeDhHQjlmSTFFTEhsL3dBcGJaeE4yOFNxN1dPTDJrbHlscmdw?=
 =?utf-8?B?L2laOEFsSzJPeng1SXVDak0wUm0zb1NUa3hIQmQvd2syRG1FdElJSXU1VjIz?=
 =?utf-8?B?aWp0U29UamxIcHpkRXRjeVNIZWZBM3FFT2pOU2NpZ0lIVWd1NlJxeFQwejdE?=
 =?utf-8?B?UUNlZTEwb0pBbkhLZ0RrTUlaVmxFTkswMVcyaWE3T0dLekcyM2QrQkE3WVky?=
 =?utf-8?B?Kzh2Zkdxa0lJWC9uNGdPY3FhRkVyZzVlOGk5dWp2MStFZ3ZlekpJSTQwdCth?=
 =?utf-8?B?NkxCUXpCV01HajdSdzlkNDAwTGg5Y09EZG5OaktocStvcVBNODZzUENWR1g5?=
 =?utf-8?B?SVV0andDV2Z5TitrcFBnck5pVG1lUzgxQXh6aXdvancxZFVzVVNyWUxxWWE3?=
 =?utf-8?B?T2dpZllqTGF4ZG5rTWdBVUluVENBKzZvR1F3QjdJclBCcU9JT0p4RVB4bUVH?=
 =?utf-8?B?NzFPSUJwWFl2US9NVi9vakZIN3JGV2VHNjhaLzNoemhLQ0xSODZPUG1UMmJZ?=
 =?utf-8?B?YTFsQnpMUVlReURDUSs1ak5XWllnbGRiWUN0RUdkK0pDdUJZbjJnYUZXRGVM?=
 =?utf-8?B?MThJN0laWGRnaDBYVndpVlMvWjk0L0tERUM3VFZxUkdCSExZMzY2VWtSaUtX?=
 =?utf-8?B?UGtKRWVGM00ybkQ2Qi92aCt2NFEvbEhld0JZc3JLRTg5Mm5vbG5aNlVjTWFu?=
 =?utf-8?B?c0xtaGhad2J1UmhoRWk4V1U3Nlk5RE56ZlhSTVQ0NkhtbjYweS9RWStuaHBu?=
 =?utf-8?B?V1ZMV1lxYks3dHF6QnQ5cmFFaVBjSEd1VFZWWnhTblpQMTh3S2hIT2pYMlNW?=
 =?utf-8?B?blp6dEJmR1huQXduTk12L1JuYVc5OXltR3Uxc25SSXlsc1BoWXk5L1NrRU8z?=
 =?utf-8?B?Z1h6K2JHYnpSaldWUGpwc1VkM3VCZ3JIUHhXWmdxM1BzejZWK2RsOVZoYk54?=
 =?utf-8?B?K0pLY3BwUUgvZm1DSTZjQmQxU040TE1HTHpnRzBnUWp5QUJObEVqT1FCTXlL?=
 =?utf-8?B?VFJPbzBaUTFYVW42RkVQL2EzRUNlcmluSzB0SWpDWW43dzBzZ0E4M29kV0pX?=
 =?utf-8?B?MjZMNEdGU3JKRCtnNEJtZ2VlNytPZ1ArRHhsUExLdUtoQnc0TjZRcTl6bUdN?=
 =?utf-8?B?YitQOVc3cDJrcjJqakdGQWE0VUMvVVdtRVBqY0ZraFJSN3ByTXptZ21pc1hZ?=
 =?utf-8?B?WFU0dWFOZW1vTXczNU51R1BBbS93M1RmdGhHT2FTZGswaWtwbzd0Z3hwSWxT?=
 =?utf-8?B?TXhEcTYrWjNaREsvakI0Q2N1bWtUdStMdmtpcFh0UjNKK1pWU3hrbklhVFVV?=
 =?utf-8?B?aXFqU3BzOGZzblpWUnVZYXVQZlg1eW9YTVZDZzdjUDh5cEJ1aE93aUJ3Uk5H?=
 =?utf-8?B?UTBoZm5BbWJlY1l4UEpWdU90TDhZU0ZKMnk1OU9mR2krcDhhNzd3Zm03em5I?=
 =?utf-8?B?a2tsSFYzN2JDYWM2aE1EaUpmalFqVDJKNDFLMEwrQUlwSy95WTc0dlMvZHo2?=
 =?utf-8?Q?2+BkdAYEFmDD193uu8UYI948991a4LX2RmobJDl?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB6097.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3dwcmZZcGxOVDhsaHlwOCtBcXNGZytoYm5hTW0rM1NHRVVuTGorUmZDekwy?=
 =?utf-8?B?R0NsQ1pZWW5OVHEzODlEV05MWDgza3RjNmFwYmtHY2lST3pGRnN6cjNiZFV4?=
 =?utf-8?B?ZWV2NXZiQ1BZZVhEVEZmZDRmMnJyK1RHaUUxV3pOZEQyWjJVWUVaWVFlMURQ?=
 =?utf-8?B?OEwxc1h1aitqYzIwaGlDM21hUno4NU5lN3p1UmFHelRyaEhDTmJFYkxVcUF2?=
 =?utf-8?B?NEJVTHpud1FuZlVLcVA3RHp1T05CeFVXQmJoNkUvbENWSGc1VlN0U2FhRVdK?=
 =?utf-8?B?RWthb2xHdUdwOGd1c3k4TmVEY2dFQ1QrNG9uVmp0QnMxVXJZd0Fnb1pmbVZK?=
 =?utf-8?B?ZXBZaXIzTlNGaVNDYkM4dzR6cWozdFdmU1czWWdKSHIwaE1mUndOQ0o0UnUy?=
 =?utf-8?B?eWR5RXg3Rzc0RHNNckVkK05mSkczWUFRbGFZWU14ZFdLd2trdG5kV0pXR2tV?=
 =?utf-8?B?ektnWG9vOGRlanlTRTg0b1IwQmdHUzRyQXdFbUd0WW9Kdkkyc3pqV04rRlFs?=
 =?utf-8?B?SEd2NzJIdXQ1ZXdDUlFOakU1OTZ0Z1l3bmdiRjlKNjVQbDludnZha2lFcm1t?=
 =?utf-8?B?VFZjVnlsSUFkM25iU2Qvd1NETG9CMnlJLzVLZzluVGhsMUZmRUY4QWcwakhj?=
 =?utf-8?B?VllkSS9KSzcxbjFUUVZwSWoxMjFLSGYyRHdtbmZnMHJoLytsa2Z0QjVoWGN3?=
 =?utf-8?B?RXpZbHJQQmlLN2JURXJDbjlFVDFQQ0cvamhqYjV1NGY2T0prbEF3a2FOdTdC?=
 =?utf-8?B?NXpYOXpLdHlra0pLbEpyTEJRS1VRaHg5TytFdU1vRjFRck4wdGhOSXRCUUp0?=
 =?utf-8?B?aUNxNnk5VXE5b3pYVVZSbGVrdmlzSjQxRk1MTTg1bjZTcDhrbzUrY0lTbUcr?=
 =?utf-8?B?M2ZaSG9CVEFTVEE3cmxiWkpGcmNadjhEZkRVT0E2Q3FaUzdFYUlyNjcyeWt5?=
 =?utf-8?B?b2JaV3dVTDRyRVB5NW1XWXU4dEQvQTNBbmtsdUZDQ1ZkNzJrY0h2WGw2WEVw?=
 =?utf-8?B?VnMxVGtUQ01pSzFKSThRY1ErTjA5eW1JQ2lPRzhIRVptR3VLdE9VUzdUcFhM?=
 =?utf-8?B?dktYdklLSWRaSlZ5dkJuRjNPL0QyRWdFNWJLTnJvRzhtV0JCb1kyQlRyV0Zy?=
 =?utf-8?B?ZjA1emdvN0RKaUJhZlVJcGI2L0tPS0R4K1FGQ3ZSWC9QQzMwMVQzRlphVWwx?=
 =?utf-8?B?Q09Oam9QS1BxV3JOV3pHbVN6NC9UOWM0NTdVZXpwR0JqSEJReXBBQy9zNDcw?=
 =?utf-8?B?RHBBeThVcXNPUVBpUFlkWWVDOUkvdnlsenoySmNrRTNPNmJXa0ZwK2x3Znc3?=
 =?utf-8?B?U3RIU2Y4OVRINmdCYlUvWFRDdDRYbUlDNEJINHlVYy9yVm1SYUZpdkM3aDlO?=
 =?utf-8?B?cmtxNmtOamRsMWd5NUdySHRhS1JlRURCMmhjL3BKZy9PUjZid05HWXdPeG9h?=
 =?utf-8?B?ZTJVTng3QzRYVk5SZTNWbzBQbFdvVDJIZmovOENsUGtnbUtBckVGbGRabkZp?=
 =?utf-8?B?d2RGNTZGU1JnVjI0WWVBSisyK0NHVExVRlp4emZXWmVUV01FWVBqRzZRWitq?=
 =?utf-8?B?aHM0KzhJTGdQZFZzMkNTSEptVDJjVUhkMVMwU2tlTHFGRmJ4UmJoWHgxTzBD?=
 =?utf-8?B?UGtRYW1seFMrQlUzQzF3Y28xdkxBUVNPVXNmeCt3R3FlQTZoQTloaHhHcDhX?=
 =?utf-8?B?cW1penNxUW9VKzQ0WmtiaXJXK0k5R29tQlZoa2ZvUFhlY3p0MnpRUVQ5aCtP?=
 =?utf-8?B?NGcwZTNqNHhxTHBWTS9rU2Jta0tMclNZK0d6WFV3WitwMUlGWmtJNVE1VDc3?=
 =?utf-8?B?bE0wTmE3SFRZSHdnb1BQOG9NNE5mRUJESmhBSDUxSUNpYWxhQ0RCYWFXR0dv?=
 =?utf-8?B?WmdPWk5pVHFyZWlCRkZXczVCenhicE90VElwWnFLemFEcEo0cFMxTGxxRzgx?=
 =?utf-8?B?d1dwUDI2cW9CdWxBR2pUbHNkdkwwZVJnMys0Nm1qTW40VEJTYUVxRE5rMWFR?=
 =?utf-8?B?TEdDeHVWR2NtK0M5cDZRWDlhbGZtbjVoaEtRZ29zdk5Uc1pWYjFZRUhqUjRS?=
 =?utf-8?B?NmtVN1N1c3ZzMm5qVWVzT0cwU3J3aXhQVHJDcm9RSzBCQ3VLOE54dW1MTDdu?=
 =?utf-8?Q?Y3xZaVkSFK5tKR9GsfZVzoFnK?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 12337921-6725-452b-b06b-08dcfacca332
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB6097.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2024 23:26:39.9542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GCXUGcmxJ37pAJ5sCmTyYpLyK3M9eY+ZVBorROLqr0uv8VV5ChJndkdK6Pj4olKY0vTs2LUmZ0BwqcnWhCkOeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8426
X-OriginatorOrg: intel.com

Hi, Tony,

On 10/29/24 10:28, Tony Luck wrote:
> A user can choose any of the memory bandwidth monitoring events
> listed in /sys/fs/resctrl/info/L3_mon/mon_features independently
> for each ctrl_mon group by writing to the "mba_MBps_event" file.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   arch/x86/kernel/cpu/resctrl/internal.h    |  2 +
>   arch/x86/kernel/cpu/resctrl/ctrlmondata.c | 46 +++++++++++++++++++++++
>   arch/x86/kernel/cpu/resctrl/rdtgroup.c    |  1 +
>   3 files changed, 49 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 5f3438ca9e2b..35483c6615b6 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -609,6 +609,8 @@ ssize_t rdtgroup_schemata_write(struct kernfs_open_file *of,
>   				char *buf, size_t nbytes, loff_t off);
>   int rdtgroup_schemata_show(struct kernfs_open_file *of,
>   			   struct seq_file *s, void *v);
> +ssize_t rdtgroup_mba_mbps_event_write(struct kernfs_open_file *of,
> +				      char *buf, size_t nbytes, loff_t off);
>   int rdtgroup_mba_mbps_event_show(struct kernfs_open_file *of,
>   				 struct seq_file *s, void *v);
>   bool rdtgroup_cbm_overlaps(struct resctrl_schema *s, struct rdt_ctrl_domain *d,
> diff --git a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> index b9ba419e5c88..fc5585dc688f 100644
> --- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> +++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> @@ -518,6 +518,52 @@ static int smp_mon_event_count(void *arg)
>   	return 0;
>   }
>   
> +ssize_t rdtgroup_mba_mbps_event_write(struct kernfs_open_file *of,
> +				      char *buf, size_t nbytes, loff_t off)
> +{
> +	struct rdtgroup *rdtgrp;
> +	int ret = 0;
> +
> +	/* Valid input requires a trailing newline */
> +	if (nbytes == 0 || buf[nbytes - 1] != '\n')
> +		return -EINVAL;
> +	buf[nbytes - 1] = '\0';
> +
> +	rdtgrp = rdtgroup_kn_lock_live(of->kn);
> +	if (!rdtgrp) {
> +		rdtgroup_kn_unlock(of->kn);
> +		return -ENOENT;
> +	}
> +	rdt_last_cmd_clear();
> +
> +	if (!strcmp(buf, "mbm_local_bytes")) {
> +		if (is_mbm_local_enabled())
> +			rdtgrp->mba_mbps_event = QOS_L3_MBM_LOCAL_EVENT_ID;
> +		else
> +			ret = -ENXIO;
> +	} else if (!strcmp(buf, "mbm_total_bytes")) {
> +		if (is_mbm_total_enabled())
> +			rdtgrp->mba_mbps_event = QOS_L3_MBM_TOTAL_EVENT_ID;


User may think each time toggling the local/total event will effect MBA. 
And they may create usage case like frequently changing the events to 
maintain/adjust both total and local within bw boundary.

But toggling mba_mbps_event faster than 1sec doesn't have any effect on 
MBA SC because MBA SC is called every one second.

Maybe need to add a ratelimit of 1 second on calling this function? And 
adding info in the document that toggling speed should be slower than 1 
second?

> +		else
> +			ret = -ENXIO;
> +	} else {
> +		ret = -EINVAL;
> +	}
> +
> +	switch (ret) {
> +	case -ENXIO:
> +		rdt_last_cmd_printf("Unsupported event id '%s'\n", buf);
> +		break;
> +	case -EINVAL:
> +		rdt_last_cmd_printf("Unknown event id '%s'\n", buf);
> +		break;
> +	}
> +
> +	rdtgroup_kn_unlock(of->kn);
> +
> +	return ret ?: nbytes;
> +}
> +
>   int rdtgroup_mba_mbps_event_show(struct kernfs_open_file *of,
>   				 struct seq_file *s, void *v)
>   {
> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> index 3ba81963e981..6fa501ef187f 100644
> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> @@ -1947,6 +1947,7 @@ static struct rftype res_common_files[] = {
>   		.name		= "mba_MBps_event",
>   		.mode		= 0644,
>   		.kf_ops		= &rdtgroup_kf_single_ops,
> +		.write		= rdtgroup_mba_mbps_event_write,
>   		.seq_show	= rdtgroup_mba_mbps_event_show,
>   	},
>   	{

Thanks.

-Fenghua
