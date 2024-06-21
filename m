Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A903C0D
	for <patches@lists.linux.dev>; Fri, 21 Jun 2024 01:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718935170; cv=fail; b=uymweAjsgKG6t/3aZonc4EDJyrIE2RWCfQHFW2EyFPapR3sxZ0gCZm/NrOTQhnQML51Vld+GWx/WoIU2Qs9glGNDsVDFmXD9uOVU3eWOyQAL73qmveAVSFv8wx4WX2xXIRx8IWBXZM7CiOvU1OOZLzMHPXJEHCvSWGlzRVPAyTA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718935170; c=relaxed/simple;
	bh=shsWCOdo1gzPcK3SqdD+r33MxB6WPCYtR25N9xQj4y0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BfAxXcLpgjl11h/wea95rN+j40irR7taCBTOpxF3T717GhyF2kAqNDuQXmuKXfPtrgSIupG/wZTLkBiguOyb4HCRFKKzGUvCydPRrt2s5LO8fjV9eA3z9JLMLd1rhpdc6ePSbgLVKCb1AYMhR08QKjXtNJ8ATQfUkFyx8Aj1zjQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TUzRepNh; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TUzRepNh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718935168; x=1750471168;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=shsWCOdo1gzPcK3SqdD+r33MxB6WPCYtR25N9xQj4y0=;
  b=TUzRepNhjMtLtSzaWShSjr6j/a0RakXq7pmTWeRrH0en8Ubt9OcS1+lf
   C89QddKqTURHwuCEhQ1zE5cl9HjnFcUWR5L2+28ZJV/yzluA2rumMhmnc
   kiRIY69hBykT9HjVeZe6U0mtrt6OpdAak2ysGrXPPkBECJFrqrfZa1jI8
   duoppZ6o8OhrTiJl5qxSrDliQmFXuOqTBNpDo0KLHNe7GA0NccIF8R4h3
   g0swuv0S7JmWRMzWkczLzO4BHxYWhhYz4KgIB9lB1ZrzkXv+6feulBY3Q
   DVCoKrmIfNxGqUkmtL1V3hFgg9Gfdlh+EU3YPyZ9E7ZCOZvkqHmPSNzfJ
   Q==;
X-CSE-ConnectionGUID: XjR5iWLHQAmdK8giVIzSOg==
X-CSE-MsgGUID: 2qJkEs3PSe6b2Kns+Za+9w==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="15713178"
X-IronPort-AV: E=Sophos;i="6.08,253,1712646000"; 
   d="scan'208";a="15713178"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 18:59:27 -0700
X-CSE-ConnectionGUID: EMBfOfo4SxWTJKL/hq8C/A==
X-CSE-MsgGUID: BJr2D6xQSdGMcbWH/oIrPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,253,1712646000"; 
   d="scan'208";a="42520954"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 18:59:27 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 18:59:26 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 18:59:26 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 18:59:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SHcKB8Lv1ExI6/XDqdtF+vy+/KbfjxgVf5pbOoUOkYfMpbn+7Tv0eOrwLI62iSUxwKtijhO+dZiPGH8Dl6KV6EAXMBugL1ZLSUmAIpWNpjgxrgIAny+LWm591R92Fby9NVT+gT94JslKc0nXkO7DS8TsW9OY38DvRnO+Mv3Da+9DeuKfNdfhlFV11D6XgfhdcZi5h5Mbij5DPtDE0HydaVzT6qGOySeVHb9NOEypIKrQMJjJas90xW+00vzUZVawbXWdJk4hbdbfvOcBmWiv0THd1rm2s7PuqjppXQ/aZ2BMDHshbPI+15G9bk1tntNP1RJQJbhYUcIUrA2qG/N2Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TfjN4csUO/5G2rf6Ew8FV4Ot2KCGwK8+RqOeUIj/LK4=;
 b=TMz3uLE8kp2gkxJGptA+V/ixD6UrJrUqFQPYv3ea0mQxBDuDviPmlDBcYE4HiVNSiVDdOC+xxLVu2Txj6ZzSTIR/0y3tOMN48SdmuUrySichk2+WY/rDg7H4J2uOaeG/78DabFGWM483vnwJFt9ySKU6b0YqcDg0rRBdnwMSMPS9hND1GXSKHCJi1ntvffCVL16laLickMpmeLjuT3u5ph34oBvEAiJPzqIPHbWGmGeFBM1JNkRQDYA3b64ln7D7uoj4KY5YCh8Ef+LWkrdMZNoQ6VQjIMVD+gyaUj/+PcdmPf4LLxr57TjIzvkb3+NOTFTOKEC6pp35XbKcE015zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB5165.namprd11.prod.outlook.com (2603:10b6:a03:2ad::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.19; Fri, 21 Jun
 2024 01:59:19 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.017; Fri, 21 Jun 2024
 01:59:19 +0000
Message-ID: <cd5c42db-2dea-4a01-bf02-b4316b0ba11d@intel.com>
Date: Thu, 20 Jun 2024 18:59:16 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 09/18] x86/resctrl: Add a new field to struct
 rmid_read for summation of domains
To: "Luck, Tony" <tony.luck@intel.com>, "Yu, Fenghua" <fenghua.yu@intel.com>,
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <20240610183528.349198-10-tony.luck@intel.com>
 <1bba8391-6ee3-48aa-935f-b9c08bee049b@intel.com>
 <SJ1PR11MB6083E7C6C3FB2345A2495480FCC82@SJ1PR11MB6083.namprd11.prod.outlook.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <SJ1PR11MB6083E7C6C3FB2345A2495480FCC82@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0166.namprd04.prod.outlook.com
 (2603:10b6:303:85::21) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB5165:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c2ae8c7-d0f6-4130-8f28-08dc9195c345
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|376011|1800799021|366013|921017;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OGorM3NMSCs0TjZmeXRWelBGQUhNb2tzQUwxQXlxdHBzekZxSlJMaUdybXBU?=
 =?utf-8?B?YWl1a0F4KzhaRmJvTHJJSWdjQ01UT242MFlFNURKbHlkTEFTeGZTRS9yMmoy?=
 =?utf-8?B?WUl4d0l4a3NSVHpRRXhQNFhhZFBCN3BVajlzTEk0alFaa0NkQW5lYUw0T2ZC?=
 =?utf-8?B?bE9CUkhKM082K3JlYVBNREhlbzhSa2VKd281N24zYk9uRVhlcjgvY1V2N0F4?=
 =?utf-8?B?bFpodjlqSEtPUjhGblNPZ3RkSVB6S3NyRlZDWlZRSUR5ZitZTTd6UmRkZWdO?=
 =?utf-8?B?M3Bxa1BmdHNadkdPWmVvVFMvRzMvMnlvbWtqc3hWNWZQcDZ5Zy9vcmFWTHJy?=
 =?utf-8?B?eHVrdVhZbDNmb2JmNXM5NjNkb0tGU3B0bTFiWTk3YjBOZUs1Z3AvVVo1T1BE?=
 =?utf-8?B?Ty9wRjg1ZDJXMTcrWFdBZ0pudkU1eGZCaEV0NEZRaS9rYmIvVEZyK1ZEb29W?=
 =?utf-8?B?L2Q3NndZRERWQjNTTXlCZ1VWd0N4V3BZVDhTcU8wU0QxeHVoSTBKSEZWdkxp?=
 =?utf-8?B?eU95OHZ3WGUxNGhCbXhqTXo4bzZlaEx4eVRScHhJU3h3a1BWZWNSOEFFbTYw?=
 =?utf-8?B?UStsbHlPSmZMVTFKYTRIMHpENWNEU2xkUytTMlhGVy9hTG1UR1BqUlJaaFFz?=
 =?utf-8?B?WlpXK21EcGdiM1llR3RURUtxdTgvVWJmNXBoOFpHYzF6UGpzbEp6bFRkWlhW?=
 =?utf-8?B?b0I4eWZPUHFmVk55VzdBeTRNV0RxT1o1bmVGeHFId1l1c1hBTmxPSmRNd2RW?=
 =?utf-8?B?a0NzeHdTKzB0R1lWcmJ1VHQ3MG9xRkwyTkI3dElheDJFREROZFprakJKQ095?=
 =?utf-8?B?VnBqNmNTUTl2NWlTY3BTc3JGSUI4VUZaYnVRQWdaeVM1aGF4WERBcXBmdW42?=
 =?utf-8?B?dUpTOXVsRVdNbXp6R2c5cnZpcE5qd1VYRXNOKzdtcHV3UzgwOGlkemJXQVJm?=
 =?utf-8?B?SmNmYi9mNHhrbk16bjFGZEtMTDlHRUduTG9wN2ZVdHZGckFXTmQ3NlZsWENk?=
 =?utf-8?B?b3d0SmZWejBxT1FUMGRPbjlQMldPUEdueEpzLy9aZk5nRDFSUGw2c0h6YUty?=
 =?utf-8?B?VEhrSVdsenZzZ2hsZmJ6WUJ4eXFUY1phOXNMdFhHOERMTEZ5cXp2UzZMMlJQ?=
 =?utf-8?B?Qi9KeU1UR0VlaHlHV3NYUjFoR1VHK3NTdlNmVFVmeEpWdHBYUlMyaXprUm9J?=
 =?utf-8?B?NzVTYytVOEViU2VWaUVqVHlEVVFWdEVBQVRFQk1kNWpXU0hsZkxySWQ2T01P?=
 =?utf-8?B?YWZNdS9OWmlhWjdUWWkrcnFnZFlxWng1RkpHVWFqM2xoL2VqOVdaWUxPejBI?=
 =?utf-8?B?TDkxV0RVbkxLM1VCNHgvWDdIT0hITkpzSEl1UDlLQWJNdUxueXNaS3NrWnVO?=
 =?utf-8?B?a0dKUzkwTU91Z2lOL1pQVER1eFIvTXhCT1I1L0IwV2tYTXlraDFjYjVramdL?=
 =?utf-8?B?TTBRSFdaY0tYZVRsUEFON2VrZ0srTTFSRkpPYUlIL00vUDdqMWFiT0djWHpT?=
 =?utf-8?B?Y0xXbnl0YjBlcnRZaU5mbzlDeTUrbCt0REozcGsxTmVabzE2YnVXYjBQcjlE?=
 =?utf-8?B?eUJ4REFIZkNxallJNnZTamlzOGVOdnFUd0wyeGpxNmJrWUIvNkd2QjE1cWJ6?=
 =?utf-8?B?OFdnM04yYWh2UmMrRzFKaHpiMEVGdXdpL3dwdnJITEEvbGxBT3Foc3Y0UytK?=
 =?utf-8?B?aUtwSVNwaUtrbWIrYStFUlNDMi8xdkxKc2t6dkpRZFM2L2NpT0NrSTY3MFdX?=
 =?utf-8?B?QjVrWmVjd2ZKNTNIZTdxa2hQbU00WFpJd2w5S2FkT3EvbjFNR1REbE9ncWsr?=
 =?utf-8?Q?DINZqUEG8Gn1P6qUw1j4Acx6MBuQduLl3Cc78=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(1800799021)(366013)(921017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WlVGalZEMjNBcDh4M1dYaEtIdm5nSjZPeXREQkVaZk9GVm9uMGx2cWl1TGwx?=
 =?utf-8?B?QmJheXhjRzdSYlB1cTVNdmljWEN2QXBZclJvR3RVc3IreXkxQjVkOXBnRUVz?=
 =?utf-8?B?cEtLUWg0WWNCcU1LSHIxcmFYVWtnbkwray9LTGJCVmhOQjRaUXQvelozaldR?=
 =?utf-8?B?OHZveWRlRVdlK010dXNuWFRTTnl3M2dnczBmMkhHcWZYR0M1ZndqaHJac3pD?=
 =?utf-8?B?cnZsRys1MlFOTGVSZXZTV2xMRk9OSWthckJiT3d3ZE54bENXNzhQWk13bzFv?=
 =?utf-8?B?Q1dXT3NHQXFueWU1N1pLSEVUY01hamRqUUVlUnY5RGovOEdSdXUrNU1hM1V2?=
 =?utf-8?B?ZWEybXFjZ1J4d20rbFVCVGppYWdtM3ZKMGR5TDNmRzJnVUtZd0Z2eE5hcW9N?=
 =?utf-8?B?Nld5Ui9Pc2d0M3J1MWZsVVArU082U05yM3l6ZlJUeGYyelJMOWNjTXFKamt1?=
 =?utf-8?B?bHlPZHZzcC83dU55ZTVOUm5RNjFuQnJoYVM5SW1YeDR2WWp3bnJoNTF3Smtr?=
 =?utf-8?B?WWlIUHZSZGRFU2pydG9sU1FIakkwL1Z5NVRDQThaYkRjUnFxNU9UQjhmRW1C?=
 =?utf-8?B?YS9rbGNNNWV2Wit1R1EyMEVqOFV6ZUZrR3RYSVVjelFNaC8xTmppWWIyQ2FY?=
 =?utf-8?B?cWU4V3h2MTRrNk9DckNlM1VFNUdQenBxVlZqQTFVQmpVcnlqdGRGWmVJNkNq?=
 =?utf-8?B?ckZpWldJc0lOOVVWWG9CaldxZkVUMGRiTVB4Sk44SHhDWWRDVWF2eUxQUU9V?=
 =?utf-8?B?U0ZGaWVMN2FQNkVrRjdBQmhVMnZ4SVp6QXBUanBXNnZpZlMrTlRISlFra0pQ?=
 =?utf-8?B?ZC8yOUQ2Tk1aOW9DRmdhRTVaQmk5SnpnWldKZzhIQWhLb1czRHdWRkdNVHhS?=
 =?utf-8?B?Mm1PODhiL2tGeFU3aVBHY3lYdFlRcmViaU5rT1grNHRET0FFZ2Vrak5ERTFy?=
 =?utf-8?B?bnRBK0RBb1lUZHhqWXZoLzdLdHczRWpKUDFBaU5ya3R0Tk1qNzl5RFArTDhM?=
 =?utf-8?B?R2NBeElTVnJ4WEl5ekFQeW5mZzFvMUxydHltSHI4N1lqVnZyQ2VQbGpWRmxB?=
 =?utf-8?B?QmdRRVRyRkhFY0hZM0I1V3VKbWhwNkFlNFp1cWFXb0N1cG9Pajg4ZHFKdFRq?=
 =?utf-8?B?L21aV1VkM3hsclRrVkw3T0Q1U2hwb2oxT2Joa3pSZzhneXhOTFZHQzVLVklp?=
 =?utf-8?B?VHZMRzN4Y0ZxdDdtMTc1cGRDcXF2NGtXNjRnZFlBUHNBMDBaYVhLb1BWVWVD?=
 =?utf-8?B?SG03TnpQNmRBMjhaWmh4Q3lHL0d5MU5vSFpZU2lNckVIWklsRC9XUUFiV1Az?=
 =?utf-8?B?QTRkUFVZdTNFaFRGTmRZZjFHVEJEdWJPcm83YXhTVExjVU1hRmFmWS9PcXVM?=
 =?utf-8?B?Z2dqVlpBcmdLUStKSGJ0RE1TS3g4WENRNGdFcGZTQ3hrN3cydVc4eXZEcURp?=
 =?utf-8?B?UUJvZmZsVElodFhDQ2c5VytnL3pTSGU3ZnVaNjFHbktuYTJYdDB0UDBhMzgw?=
 =?utf-8?B?S1d1TTAyL1pqWldxbU1jK2xiaHNQc0E1SVRHU3ViOTF2d2tya3lEQThjUnoz?=
 =?utf-8?B?aDZ0dmpUT0lieTBEbkJvWlAyWDdrWDB6QTRBM1FYenVQb2JLZzRyd1lwRkFs?=
 =?utf-8?B?WW1aOG01b2NQMDhlYThaTHZPSlVpc2g5T0dRUkJMYnF0M1BIaDdZZm1qUmw4?=
 =?utf-8?B?S0FsZGgwaEZUeHYxREZKOS8wS2cxZXdDbUJhdXFWMm9nakM0WGNEb0Z4OHlQ?=
 =?utf-8?B?cWZwcm1ibTdCY1h5dHp3SnZqOUg2SWh6OU5uVTNuMWNMaDVNMkxpTDg2K1Az?=
 =?utf-8?B?ak9PYlFVbDNjS3dlN3N1cEg4a3Q4ZzVvU2VyTTFIZUZWNmRlcTVndHlNWUxi?=
 =?utf-8?B?aDlJanEvdUpsb0tFa2NQQ0paUFBLRU9zWkV0d215VE1KY3ZNWWxXbE03QkY3?=
 =?utf-8?B?Y0VteWkzSzZ3TWFvY0JqK1JOcTZ6UDNmMWIybmwzVXNoN3Z5aUlOU1NWdEVm?=
 =?utf-8?B?anc2Zm96VWRWMHlFRmlTZFlBS2RwVGx0Y3F5T1VkMEt0eXJWWkNnVzREdzcw?=
 =?utf-8?B?anlYS3ppQVhXbzUxSHdibVhJUEQwczgyQ2JibnB3RFFmT09UU0pCWXNYcVpU?=
 =?utf-8?B?dFlDRnFwcXhxcDFLWVVvL1FZNkVvTy9PUHhUSHhpUSszSDJpMHQxdlNuT2VM?=
 =?utf-8?B?ZkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c2ae8c7-d0f6-4130-8f28-08dc9195c345
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 01:59:19.3067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1AjX7dM84qpgNglOEGE1urgS/sqghjjJjD98afKD4ZnmrLyB+fJhgRDuA7yTQ7+QgnO8XrSU2/SFmeMnkakcR/DIb0xv1Ri3LLi726h2yx0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5165
X-OriginatorOrg: intel.com

Hi Tony,

On 6/20/24 3:42 PM, Luck, Tony wrote:
>>> When a user reads a monitor file rdtgroup_mondata_show() calls
>>> mon_event_read() to package up all the required details into an rmid_read
>>> structure which is passed across the smp_call*() infrastructure to code
>>> that will read data from hardware and return the value (or error status)
>>> in the rmid_read structure.
>>>
>>> Sub-NUMA Cluster (SNC) mode adds files with new semantics. These require
>>> the smp_call-ed code to sum event data from all domains that share an
>>> L3 cache.
>>>
>>> Add a pointer to the L3 "cacheinfo" structure to struct rmid_read
>>> for the data collection routines to use to pick the domains to be
>>> summed.
>>>
>>> Reinette suggested that the rmid_read structure has become complex
>>> enough to warrant documentation of each of its fields. Add the kerneldoc
>>> documentation for struct rmid_read.
>>>
>>> Signed-off-by: Tony Luck <tony.luck@intel.com>
>>> ---
>>>    arch/x86/kernel/cpu/resctrl/internal.h | 13 +++++++++++++
>>>    1 file changed, 13 insertions(+)
>>>
>>> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
>>> index 99f601d05f3b..d29c7b58c151 100644
>>> --- a/arch/x86/kernel/cpu/resctrl/internal.h
>>> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
>>> @@ -145,12 +145,25 @@ union mon_data_bits {
>>>      } u;
>>>    };
>>>
>>> +/**
>>> + * struct rmid_read - Data passed across smp_call*() to read event count
>>> + * @rgrp:  Resctrl group
>>> + * @r:             Resource
>>> + * @d:             Domain. If NULL then sum all domains in @r sharing L3 @ci.id
>>> + * @evtid: Which monitor event to read
>>> + * @first: Initializes MBM counter when true
>>> + * @ci:            Cacheinfo for L3. Used when summing domains
>>> + * @err:   Return error indication
>>> + * @val:   Return value of event counter
>>> + * @arch_mon_ctx: Hardware monitor allocated for this read request (MPAM only)
>>> + */
>>
>> Thank you for adding the kerneldoc. I understand that this file is not
>> consistent on how these kerneldoc are formatted, but could you please
>> pick whether you think sentences need to end with a period and then stick
>> to it in this portion?
> 
> This is about the @d and @ci entries that have a "sentence" ending with period,
> and then more text that doesn't (matching other lines in this block).

Correct.

> 
> Maybe some other punctuation to split the parts?  Do you like "colon"
> 
> * @d:         Domain: If NULL then sum all domains in @r sharing L3 @ci.id
> * @ci:        Cacheinfo for L3: Used when summing domains
> 
> of maybe "dash"
> 
> * @d:         Domain - If NULL then sum all domains in @r sharing L3 @ci.id
> * @ci:        Cacheinfo for L3 - Used when summing domains
> 
> Or something else?

I do not think there is a need to introduce new syntax. It will be easiest
to just have all sentences end with a period. The benefit of this is that it
encourages useful full sentence descriptions. For example, below is a _draft_ of
such a description. Please note that I wrote it quickly and hope it will be improved
(and corrected!). The goal of it being here is to give ideas on how this kerneldoc
can be written to be useful and consistent.

/**
  * struct rmid_read - Data passed across smp_call*() to read event count
  * @rgrp:  Resource group for which the counter is being read. If it is a parent
  *	   resource group then its event count is summed with the count from all
  *	   its child resource groups.
  * @r:	   Resource describing the properties of the event being read.
  * @d:	   Domain that the counter should be read from. If NULL then sum all
  *	   domains in @r sharing L3 @ci.id
  * @evtid: Which monitor event to read.
  * @first: Initialize MBM counter when true.
  * @ci:    Cacheinfo for L3. Only set when @d is NULL. Used when summing domains.
  * @err:   Error encountered when reading counter.
  * @val:   Returned value of event counter. If @rgrp is a parent resource group,
  *	   @val contains the sum of event counts from its child resource groups.
  *	   If @d is NULL, @val contains the sum of all domains in @r sharing @ci.id,
  *	   (summed across child resource groups if @rgrp is a parent resource group).
  * @arch_mon_ctx: Hardware monitor allocated for this read request (MPAM only).
  */

Reinette
