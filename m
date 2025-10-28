Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F488342CB0
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 16:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761667259; cv=fail; b=JYvaaSfTZfydLC6c32SBAGuDc6cb68fIg4ZMh9ILiL8OcSMUPsGyTNMtk92of8NO1frvcLsXWQQQR4EFpHIxYGV16IaSsN6GFES7LT8CSQcOyBx8j/jRZl+ejc/I3plmTg61buhIrlCtsIhjmJOiahtUQszRZDzquYqKE0oAgN8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761667259; c=relaxed/simple;
	bh=vo2NQ+0xejdvx26o4nTX/IMZmiED+mJMRdqlEeSYQhQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mQg22BEZEdpDxQ6/N8reLGogIiAyD6GtbLjrqt9Dw2JReycICeRDmsYlONs+8C3p3gSspanCVl7VC3Gmn96uZtCDNsuaTEooArUHwufsdeeIvhWBRogEeeLtFAQkrqk4k+IBzg439qtznR+tqfJ2nF7K819gboJ7ht9lNXrfraA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VhgApcoz; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VhgApcoz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761667258; x=1793203258;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vo2NQ+0xejdvx26o4nTX/IMZmiED+mJMRdqlEeSYQhQ=;
  b=VhgApcozHgycSvGv7WJGXkeXah5oICdtsj5zeuFinnruljBiCjdx9fu8
   3v/r3AYDCcsxa1d9BAOC3f0KIY6DRQVS/aLv43NvMuxp/6R/+LZOjICtO
   53ywpRhyr0oMeV8061TzTB1zt4Oto5lDPymevjTMOhxqsRtJKG+nlBehK
   v44WiLRFt0/HyTu4hoYng7HzXfJf1DSMkk45Pxxv/dBjHwxrkz1J3S3l/
   NY46MdyiOHcBdlgXcnrYDn8lruLGGYDfadez+OhejYCrIblL+KFA8yWui
   roEjjiAESbgehV3v3WY2t+yQ6SQRPTnX3EnQUNuxl1D1QsSu7giEU/hT6
   Q==;
X-CSE-ConnectionGUID: 5DT62zHHTEqna7o70J/nXg==
X-CSE-MsgGUID: diAP30lRTdyvm7OJKFedaw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="75219614"
X-IronPort-AV: E=Sophos;i="6.19,261,1754982000"; 
   d="scan'208";a="75219614"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 09:00:55 -0700
X-CSE-ConnectionGUID: pDnjVAtFTpCBsaMOGJp+Bg==
X-CSE-MsgGUID: msjIMJsYQbyH0+jdLSMu/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,261,1754982000"; 
   d="scan'208";a="185719939"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 09:00:53 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 28 Oct 2025 09:00:52 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 28 Oct 2025 09:00:52 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.21) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 28 Oct 2025 09:00:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oRtB0FJ9RBxgoxuMhDGuA3p9MZsoUmzFSxWWSdXqLZ2LLbjLkOYCaGHbiJJk/H5can4rADRi07xUOiViAbZqWEpU9wOuj+CE5fb+nu8K13NJEhT8smqY4N33CbjNI+6R3jP31d9XHDlRh8B/AWjVLFKzNWTH9xwRLflck8sFVmcAHzllwQbka5QXrgO1a0nDWYUo0pzO2jp1Yg2QxgxVEp8zrAsdSnqQ4AppeUELJ7g6XaL86MbGrWlcjLHT8GX8xI7Q+e0tI6AuzjIUmUgZH8+IFUfmazMgmnMNeVOmN9Xft+8Ww1uGzRFIW4teRFih3W64RzNcG2nXGqwvvfzc8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9lgp6KRY1m0TkG2ansgIgRfaGbam9oVwJvBUNWU0GhA=;
 b=Wk3XqxopJHmkKGL+6aeofJDKxzy7/3OtTFNubwiuPWC+TRyF/lq1UjC54j1AX187yLm1d3pFAVyOvtaVZ9EFwiAgQq0oIQCzYW5EOsmSmJIv8xzRh/etOpJ2+W2zG8837Ochp2tFvInKc90K17mPDWGCzRQ1aJjobUoUJj5fmUQco0LTj6bxCKX64+1xer8uYd9S0Zv+lsBNTkaQFX4nLxtQp4bEZ9vlRyXEVMhxGp4mgKl548ZobCHAlgKTr2FY0O1nrUYu2tonxezn8Y+ibls+mfIisNd2rRFF5M/AcALnpz1HoC0P2wjUwwCm7K2riJi4UGxWvF7n6dhN5K0zNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA3PR11MB7612.namprd11.prod.outlook.com (2603:10b6:806:31b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.12; Tue, 28 Oct
 2025 16:00:49 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.015; Tue, 28 Oct 2025
 16:00:49 +0000
Message-ID: <b4921b96-3f86-45d8-a353-471c8f20e2b1@intel.com>
Date: Tue, 28 Oct 2025 09:00:46 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 20/31] fs/resctrl: Refactor mkdir_mondata_subdir()
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-21-tony.luck@intel.com>
 <4bcb8320-687f-4c43-b4b7-150d503b9890@intel.com>
 <aP_5eW_GHwXebeyq@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aP_5eW_GHwXebeyq@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0204.namprd04.prod.outlook.com
 (2603:10b6:303:86::29) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA3PR11MB7612:EE_
X-MS-Office365-Filtering-Correlation-Id: b9e415d5-8430-44d9-7110-08de163b298e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Qm5KVnFsc1AxaFEyeEI0R3BqZmJmWmM2SnVpZGhXNmptYjFNUzdYQXdFMFNp?=
 =?utf-8?B?SHV0UUJQS1VSc1hUSWdKdTJDbFVrQXA2RmxoVmV6ZUd1TTBqeHRsR0ZtQThD?=
 =?utf-8?B?Q0paZkJqSUdXanZLUjVYVTkxUFlscDFYYWlMU1JHNTBQMk5HNHNucWJ4RWVp?=
 =?utf-8?B?ZHp4czZYRldlVWRVaG5pT09sMWxSbTJybEtuaDNscTdTVFJuM0dReEdsV2sv?=
 =?utf-8?B?TldZNHRqVEgrNnV0dXdWV3VHMjFONEd4VTg2RUJlRjR2a3VOZFArVnVUd2Z6?=
 =?utf-8?B?d1ZteW5DNTl0NUVMK0dWQk5zamdaNnNpSXgvZzVYbGZPNUVhRjlGSi81cmVx?=
 =?utf-8?B?NkhOeXlVQWpzcU1EVzY5UWpWTHFJSDljZGl1ZXlkamwxWDdZK0dHR3A5Q1Z6?=
 =?utf-8?B?UmFqUEQ0WmhYTkxzbXRqdGxJVEplZ2o5MFBvU2NBOUlSOExLanZIN2ZHRFN2?=
 =?utf-8?B?R1VkTXRoTzBZbzFXSEpINDVtVGlMT2R4NC9JUzBtUmM3LzRMOUhCNUl4OGxv?=
 =?utf-8?B?c2YzVVRsV1lONXZSdVpvNHRzMHhySUlQTkx1aUU1MHJaUlB1b3FjNkd6anNV?=
 =?utf-8?B?QmxWcGVycE9lc010Q1V6Rlg0bkFvTVBTdXFyd05rWlBWTWM3K0xlVzlTK05l?=
 =?utf-8?B?QkZwUCtlZWVmODA0aWlrSDhzOWRYcXRQbGEwR1Y1UEtST1BtQU1icmpxV1hB?=
 =?utf-8?B?VFZUWE5VS2w0M0UvZkgraFc0dTYyeUlNUzF3MFZNTVNmRHFYTmxXSFFncEpi?=
 =?utf-8?B?dVF6b2FOSFN2clE5dUNVTForc2NYWDFraHo3UWJ3cStNSXpmb3A1N2JOY01w?=
 =?utf-8?B?eHhWN2JyeUNFd0xxdXExbjlUaXAxalFqbkFGSW1Kb3JBcndQcDFuMkg1Ky8y?=
 =?utf-8?B?M05wQXVHNmRmRE9JckhYWWRmOEFER0dNOHA0cWxObU5mNktFZ3RMQ0VhRy9x?=
 =?utf-8?B?TUFhOWV0SjNIZGtET1FhM1NGb2JVNnRNVGRzMEZMVjVCMThCRGtBTFNxNXdZ?=
 =?utf-8?B?UVZ2akNKZUYrZ0Qwb1U1L0QzamswOGx2TWFjd084U3IvY3BOR3BDdW15TlZa?=
 =?utf-8?B?UUd2Tk1ha2xncEZ4dnh0Tml2STR0K09mSmdEVndMbjdPUlloQ0NXdDNQY0NI?=
 =?utf-8?B?VTJBT2xzQjE5TDFJb2E4SW9HRVVVQmRIdlp6UFRMcTYrbDEzc3kza25lTmNJ?=
 =?utf-8?B?V3NWZHZMcXR6eFdZN21nTkdqN0Y2MlB4eDRpY3ZobGQ5eis3SG5uWG9RNmQy?=
 =?utf-8?B?TTBXcjJocUJ4OHhYdHM0Wkc1WnFUT0dYSjdhN29uSjVJWGZJSlZwUUd1ZEQ2?=
 =?utf-8?B?cjM1c0xLQS9iUGZYYjkxL3FoSHdtUVVTQm5RZkNpZGp1UWlURm9KRFRHYjRp?=
 =?utf-8?B?anN1N2FSNWloclRBMmNMMWlzN2UzZC9OMmFKQVVGcFJnVEg0eC9UL0xzd05H?=
 =?utf-8?B?ZEJEVmNSQ1FNTmJvS0JZYlpZaWtMQXAxTXF0akMwVjVVVmFQcUJ1VGRuc3RC?=
 =?utf-8?B?N1NlaHBOQmxMdTNZcndDOWZGTEFrUEJXMC9jcnZtek4rV3RkUzdaZjBVM3JR?=
 =?utf-8?B?WVB0ODA0Q0FwVEJoRjdFY2h2aE9FQnZoS3RyRmxEMXcya2FIbEdUa1diSlp5?=
 =?utf-8?B?SkkwVTRBekhOZzR6QzNVRTFSNGUvUEV3UnI0eVNYYjYrczVlOGdHSUMydGJt?=
 =?utf-8?B?R0plQkR3cHR2d2NqR0lZM2hNQ0svaUN0Z2VxR2pZQlIyMFBZRkpMZzRDcUdz?=
 =?utf-8?B?RXI2NXJqc3pxOVlZRnpDNFFvczYyaHJJV1BnREt2QmtHVTNMcjUrYmx5WEJp?=
 =?utf-8?B?YWROTkozclE0U095bW8ybzV1NkNuSnlzQWZNdUZIbGovM3BEYTliTUtRY3Yv?=
 =?utf-8?B?WE5XcWlWVk81ZzNpVDBKQjBWdHY5S0E2M09qdVE3RUtHOWdEcmVoSklieUwy?=
 =?utf-8?Q?wrX8itNXee3ID5JguXeiIR8AsA7ph8Uf?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXBveG9RbzBLbDI3VGlaOE9LNGY0TE1QMjRvdDR6NVQ1TzJBaWhJTDM2VHRC?=
 =?utf-8?B?VlRnakd4SnJIZTNza1VJTHRoK1dURlRRUnNGZ05QNWpzaTZKQ0RQdnpMTzBJ?=
 =?utf-8?B?b0t3K0NQVzlEWU1CNnpIS1M5cEJXOWtYVWU0RlUyMUpXWktEVXdFRXUxeXo0?=
 =?utf-8?B?WndQbFplTHF2a3NvUHlzOThGeVJoU0F2QkFKNnhjNUoxMXppQUF1TGFJVkVY?=
 =?utf-8?B?MjVlRFp4TVFSYkxOcHFWWW9ac2MyY2JxeGhnMHRaUkN2K3c4bXVjejFERDFo?=
 =?utf-8?B?NEkvVWM1aUU1UGZ5dkZQdjlZNzAwV2dGQUcvMThicHZOY0Jad05yTFFtRElM?=
 =?utf-8?B?NmdiSlVyYlB2SVpxSnVKM2hUejFXSEVPYUd1aTBEd2xMWUsvR2lHSmY2Nnpo?=
 =?utf-8?B?WVVWMmJheTFxMGIzMXFzQXlHb3JPS0hIY2FZNGh5TUNMZmE0b0JURVNSdWV0?=
 =?utf-8?B?YmozSjNSaTVraGVFV2xyTVNzZHY3dE56TkNKRVl2ZURMVHphUTI4ZE1RM0lj?=
 =?utf-8?B?OGVQbWs3VEJBYkl5MGxqSVBxT1l2ZUp2Q2xpS1hFaUcrb2Mzb2NRb3hveU5s?=
 =?utf-8?B?MW1HeEFmKzFralBHRFAwWkFsMVVGTjlTZllHQzZ3ZXhrVVM1cmZzQmlybnJC?=
 =?utf-8?B?dmRLMUxYU0VXWE0yaVBtWDZMSlVuS2Y4MTJmbUtFekZDZ05CRFdxM1MzbS9J?=
 =?utf-8?B?emY0ZW10d1dHKy84dTR2cHlZdkRIZnk0QzYvdm0yS1JYME9kMGlsSXZZUzdx?=
 =?utf-8?B?bFJBR1JudzEvVHVEalpscHYxZENSZm5nWkF4V0hZVjB1bVhGKytPR1E5QVdS?=
 =?utf-8?B?UzRCcUE2bStGcWVDR0tQMng2aStPbEJ1d2J2Q1lxcklYRFl3VURxcnRvZWcy?=
 =?utf-8?B?dk81QXh2RkdKS21ENERNalM1STYvdlYrZ2RpemZhWWdBMERleUVNdjkrY1J1?=
 =?utf-8?B?Yi92cWQzTkJxQTIzNEZvNENsaUVDaXUzRGZ6cmU0aGhqQk9ZekRwWlpDYzhV?=
 =?utf-8?B?R3IrVTNZTEcxTGI0TGxmVmVRdWN3RVdDcTJuV3JtUWhaZGN0RUtaYzBuTk53?=
 =?utf-8?B?eG9iZ3hEN3A4SzZMdFZnQmxON3RvNzVJR1ZLVFlLWExHUmRKTll6UTg1YzU5?=
 =?utf-8?B?VU42N3BzbkN2RVZwWjRRNWloMG9Ebi9GL1I2dEdxUkdTdDNuTUZES2FHMlhj?=
 =?utf-8?B?K2VNb0NhdUtpbWlxTFkxZFhVeVhmczYvRzJPQUN6QnhwSmNVZXFyUkFhYXIx?=
 =?utf-8?B?eVVxR2NXaXZ0YkFYN1NGVkh5dGFtMTUvOGFEVERSTjZxQ0dScG5kb2ZIdUJ5?=
 =?utf-8?B?RmpKWG9KSUpDbmk4eUlMVnVUb01DUXRMb2haZlZjWWJBQXR3YmtlcXdiNmpZ?=
 =?utf-8?B?M0hMbTFjSDM4elYydEhrbnhJWHo1UWNQZDF1WHBxL1d2YnZ1cUhScWZtdUxR?=
 =?utf-8?B?UXBrczZNcTlNMVhkWTZWNmM1NjhEUmRHYXBlMkNTYW1QRktMK08rbzUyUkk3?=
 =?utf-8?B?NFltNEZBeWpxWDNLcnR4ZmJlRE9Td01rYTlISHFRVmNOSnFGMjd5OGFzRHlv?=
 =?utf-8?B?Zm03MFJ4cXFXTTJVeWZLU2M4cmpMd3JvVWV2cmoxQXJFMjkwdUxvd1JETXBX?=
 =?utf-8?B?R1dadjFzL28yNXhpNXZ3K0poOFVaSGsySlNCNHJVYjBFbGtiUW1VeTNISXFy?=
 =?utf-8?B?UnRhNERJWnlMTXFwemlwL0Y2cUFzbmtPaFQ0K0p2eHZHTmwyLzg5bm5hTjJY?=
 =?utf-8?B?NWljRFBYYnFlTkcwcThEaWVNYUZJUlVhWHZvREpabUNjWmVYWHBDaUF2K2U3?=
 =?utf-8?B?bStudTZxd3JFd2lvOXhSaWlsMysvVnFJcldyUUFHZ3VyQ1hOTzQvTmIxdzAv?=
 =?utf-8?B?WmJDbmZoYm51MWdFZSswelZhaGlCTGNrUTlvb3JJRWp2YTB2T3RVRkZiLyty?=
 =?utf-8?B?Sm90Q2pXTVBGaGpNVnlucXVwd1FoL2JtTURBMzlnWUpkUk84NDhHeEFJRnow?=
 =?utf-8?B?cDFNWjdiRjRXOU51bXRMVEFMMWQxM0piWjZXMnQ1OE91TStWdHVhN25KNlBF?=
 =?utf-8?B?MnEzL1NpbFcwK09CNUVuWFJYcUZZU0t0WmF2TlpudUhjVGtNMFppVXgxVGhV?=
 =?utf-8?B?Vis3OXF0SUZ4UFEwMzlvVTZQZ2gyZDJlTE1NaXRETVVYUENUTWdBWVFJdjlZ?=
 =?utf-8?B?ZGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b9e415d5-8430-44d9-7110-08de163b298e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 16:00:49.0837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aG16LXts1kY4fgx5XQzGlslz2HMLN9P0T8mOHZgGXE6GIGjgysYIfUq+m+gTQ6d1KJcPZ7ZMaMjIy6DA7rGq1N3Yo5aIYPYTg4YxqlmVMbs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7612
X-OriginatorOrg: intel.com

Hi Tony,

On 10/27/25 4:00 PM, Luck, Tony wrote:
> On Thu, Oct 23, 2025 at 10:45:06AM -0700, Reinette Chatre wrote:
>>> +	sprintf(name, "mon_sub_%s_%02d", r->name, hdr->id);
>>> +	ckn = kernfs_create_dir(kn, name, parent_kn->mode, prgrp);
>>
>> Noting here that kn was created earlier with mode of parent_kn->mode. It thus looks to me like
>> above can also be written as:
>> 	ckn = kernfs_create_dir(kn, name, kn->mode, prgrp);
>>
>> The reason I mention this is that this patch adds a third copy of a very similar code snippet
>> (kernfs_create_dir(), rdtgroup_kn_set_ugid(), mon_add_all_files()) that looks like a good
>> candidate for a helper?
> 
> I looked at this. But the helper needs a lot of arguments to cover these
> three cases. Something like:
> 
> static struct kernfs_node *make_and_fill_mondir(struct kernfs_node *parent_kn,
> 						char *name, umode_t mode,

I aimed to preempt a response like this in the text you quoted that notes that
a "mode" argument does not seem necessary. Are you hinting that mode is indeed
required? If not, without "mode" there are six arguments which is just one more
than mon_add_all_files() that will be called by it.
What is the threshold for there being too many arguments? This series does not seem
to have trouble pushing an arch API call resctrl_arch_rmid_read() to eight arguments
while there is a concern with the number of arguments of this static call that has
fewer?

> 						struct rdtgroup *prgrp,
> 						struct rdt_domain_hdr *hdr,
> 						struct rdt_resource *r,
> 						int domid)
> {
> 	code here
> }
> 
> A subset of this repeated pattern (just the kernfs_create_dir(),
> rdtgroup_kn_set_ugid()) happens on every(?) mkdir. Perhaps a better helper (for
> cleanup patch unrelated to this series) would build the rdtgroup_kn_set_ugid()
> into a new rdtgroup_add_dir() helper?

rdtgroup_add_dir() sounds like a useful helper. It is not clear to me how its motivation
is unique though. That is, why use motivation "rdtgroup_add_dir() is a helper that supports
two calls that are often repeated: kernfs_create_dir() followed by rdtgroup_kn_set_ugid()."
while, what will follow, two calls that are often repeated rdtgroup_add_dir() followed by
mon_add_all_files() does not need a helper?

Reinette
