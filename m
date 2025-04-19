Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FACF26AF3
	for <patches@lists.linux.dev>; Sat, 19 Apr 2025 05:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745040681; cv=fail; b=a4O8WnqIDstbPE196AB7FMrSOwDr8ymotte6RsliKvtrkD+JZSiU6rQ23twKCVhQKQ24ZaJNqZWf7TBy0/Q6wRQwgIaahdxr5bmnkWCkAkpn2g0VJ5NHPxYZvH4w1zZ92vm48YOuiTSrMwPwZXIPgjAGCxJQEOjnU+oCEdvJkIs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745040681; c=relaxed/simple;
	bh=qQLRaIsZ7aviHwzkYGIvjLXh+iBR1085I/RHH7oFdxM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Kq7OTpRdTtBWcdH8QPxOm34UeufODDghOvp7wXeq9Pizfg1d/VFyctOJhgwRiQ4ymHY6cv0B6LxFFD4RyCCQ/RP/EpnDtVNrPMFCEcUTx+nkXmbNTDoX31skmtAsqVaCHoPT7EV79YXAyCOxxHVQnegBmBlbLCNFCjMX1S4Lnrk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q5Q1KVHE; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q5Q1KVHE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745040680; x=1776576680;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qQLRaIsZ7aviHwzkYGIvjLXh+iBR1085I/RHH7oFdxM=;
  b=Q5Q1KVHEytX1rxnj8ecSI9np1VYgZgFelkwjkboA31h4C1wF/LmTG/kn
   5LEC7/FNR2n6p6/HOlb4j+UDZxBF46jcVtEPFODK1FQCYHbktksB1Buro
   3wjI3y03hyqAAWUR+Wj/KobBYwSZjEl4nqwX4ZRCurV7aKisUBeGqb8Zn
   qJttHj1Xv8kuGviYMNiLIITMbsxVzDJpxPqt2Gtt1SyrGm2GWdweQs2vw
   /i5N5K7JB/pRtTuXCiDaF0gYIEhKXnN7A7tfhpj/MJ9EGwtC5Nvq3fKD6
   NXEYciYq34cNGiU3mzwUDGbdLiIIjUz3HYC3WLfDP+y7tPu+SOrYhYye2
   A==;
X-CSE-ConnectionGUID: GLyGmAoiTra2VAatkL4heg==
X-CSE-MsgGUID: tR92uX8wSYKgC484JFif/w==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="56842041"
X-IronPort-AV: E=Sophos;i="6.15,223,1739865600"; 
   d="scan'208";a="56842041"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 22:31:19 -0700
X-CSE-ConnectionGUID: DDec1beLRt6H12JV0MRCRA==
X-CSE-MsgGUID: 58SsStDzSaaWtHKzSl99yw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,223,1739865600"; 
   d="scan'208";a="131821305"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 22:31:20 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 18 Apr 2025 22:31:18 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 18 Apr 2025 22:31:18 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 18 Apr 2025 22:31:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gWPAcbb+u7YfEP+s8J6hNicZRlLls/WI/oang8yTudxaAIAILD6ylagYGUmCaflwYxHhxtJNHepgltblxfaUy05z3RlV3mnhTbsjlGDFYjRa9pxxNTtswiipKB8LjPlwi3yj+fVECXWKtuettRSf4eYqdFoZ2oIanLLVi3weW1d7avKgNmDAZrCSjbheJD/bzMX1RwvNP8fj+gnPYMOjy410MYXwpCJmvLlIHMz9mwkyiB86Jn4cZp48yixI5W/ii1hKZxiA2+WxosBerVvLJKleB+wrvYG0MAHXB2Jpkmg1HJcufjCJu59PWOjzoFrVU56CiiH+H99MSLJUbkNN2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s/PR6SJyPgZo9nsdzK/veyUOQJkShoZCeEyugH2af/Q=;
 b=SBliQxP5MjhKq3IEbsRVii87Q0zqu42ctDHsgJse2VWQ7MYypU0eugV2uZ8wULTDXbybVVNyqE+phisD6r6CzBIhXaLhr0PV4YpG0TOXM3vOvZ8W4mL7TFdwA0HrUXmRfwrLifPd9GwcoA3hseXE9jnj+xa4qyVj/g2ZT/2V+J7R53pzIqGzktEVJOZDrOxaFtQvc6Jli6uJ5ft4dk0bYQXa9gkJmGpNFofHSmE00vp6LGeewrwVFc4Z1jH4Fqj0LNSvtHAs7At9qoMblJ/zktEhnOxQ9QmXS0i1sQc0p6AvNDoy6SRTFDNi0eAadkwLJrhIkCXbFkYEguSnZxKeLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MW4PR11MB6570.namprd11.prod.outlook.com (2603:10b6:303:1e3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.27; Sat, 19 Apr
 2025 05:30:56 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8632.030; Sat, 19 Apr 2025
 05:30:56 +0000
Message-ID: <f3de26aa-334e-4c01-b9c1-97f3934a035f@intel.com>
Date: Fri, 18 Apr 2025 22:30:54 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 25/26] fs-x86/resctrl: Add detailed descriptions for
 Clearwater Forest events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-26-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250407234032.241215-26-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0081.namprd04.prod.outlook.com
 (2603:10b6:303:6b::26) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MW4PR11MB6570:EE_
X-MS-Office365-Filtering-Correlation-Id: a2a4ca70-2c19-4753-4fee-08dd7f035bc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|13003099007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZzN4WERiQWgxUmpjS3NqTWdxZGMxWStGMFBnM1l3VkhoNHFEQmRPZGtoS251?=
 =?utf-8?B?b0RteTNYcyszdFJpczExdE9ZYjRQc2VUOCtuOGRqVnJmZWJiZzBUMFUwYTRw?=
 =?utf-8?B?Y0F6WnVscWpqV1NiSnh4TVRTUTVlNWxCeGFQSXBIRlhldkowT3hwWXFZYzBG?=
 =?utf-8?B?bFAvejdHUURvUVpLTGIzN0lNSWxnQSsvZE82QUF6TzhUWm91NStqSDN5SXNJ?=
 =?utf-8?B?ZXlOZFB3V1hIMktmNTNsSVMrdkU4VnoxMTZ3YnNQaHY0OHlUMFFUYTBrZVRn?=
 =?utf-8?B?M2lWZ25zUE1tSXduMm4vVmxyT2o4UnNEYVZLc3NIREFzZkhpUHFwdHRFcWlz?=
 =?utf-8?B?bEU5dDRPT3ZPVXBodVhSQURPWXhtQTBZNnRpZ1pEOHp3TE1KRjVZQlZGT3Z5?=
 =?utf-8?B?Nlo3a3BzWFhPVERDRzFHajBmc2l2M3J3YnloMmM4ejlhWjlvUjQxc0tmNWsz?=
 =?utf-8?B?Tmx5aUxsVkdjNjREeXJZUGh2UkhHZEhMdVlqNjV6VE53b25yREg2WUpPUUtu?=
 =?utf-8?B?SUN0UGIwYm84UjFuQWc1YVpUc2FTSkFmVXZYU1RNVFVWWXd1bDdXSlJpTjY1?=
 =?utf-8?B?bVozelM2T2dweTA5UktOdEptWDdQa0dEY1ZEb3NaRWdDODhiVTBuU3MwMTY4?=
 =?utf-8?B?bzNpNlM1aElGVXpmeTdpdmxVbXZ4dEhXSFBCOVhUL2VLYlZ6anFxZjlaTUxm?=
 =?utf-8?B?THJZWCs5a09DVEZVd0x1TktRWW9rZUpQOTZPQVErUmEzWnBTcFpmRCtBdzY2?=
 =?utf-8?B?MWYxNkhqL2FsVkR5eXNpbi9uSktSTmgwTHpTa2tCVXM0c1I1cndpNW1wQTh3?=
 =?utf-8?B?VG16SW1IOFpoV3psenQ2YTFTK3ZWSWxOcDI4NVN3cC82ZjQ1c1BmQXVFa2JC?=
 =?utf-8?B?akpicmlNNnJGSGJEbytvMDhjQzhMV2JYcFNCaVZwWkEzeVZGNjh1NXphRCtM?=
 =?utf-8?B?Wjhzc0N5TnYzcjFXUlF5anRscUwyUkdicUVldlhlSEs2TzBTU0F3dlhVdzdv?=
 =?utf-8?B?M3VEN2o2dGpPWjBRMmVJYzFSV2VDNTdaYzk1Uyt3V1VDOG9NeWtjUTJjVkQ4?=
 =?utf-8?B?ZklNRnlLWFVvYWVzbGphSnhrVkZaNjBkdzlBV1BJK2w5UFFZTmFGS2hHRGxp?=
 =?utf-8?B?c01UcUZRWFFVS2d2QTRrWXRXYXBOLzhCNDVwY3FyTWxnbjFJMkZxVWkxdllJ?=
 =?utf-8?B?WmdmZkJkb3p5NkdyY3BLK05icTVRMWpCVVRDTjVNR0VaYi9vWTc1R2hKM2Z3?=
 =?utf-8?B?S09QQ1dRc2lNL21scDhneTBSTGtHYnc2SXluMnBHS3Jidy9Zc2czeWQ4eWZX?=
 =?utf-8?B?ODdMSk5ZNDN5QmlmNmpGZGRzc0xHTzZVekY1RklSRi9XN2xXZit1U2RXQjBT?=
 =?utf-8?B?aGJYQTMwRWNBVDc2eWY2Q1Y0cGdYYXRHYmhZdlQwdU9leVZnZFlHWHhKbDFi?=
 =?utf-8?B?S1hyOGwxQ3R3dXhqMlhWTlA1bWFQR0xyZjJMRFVpZHNqd1pXaTRMMlpaSTZ4?=
 =?utf-8?B?RU9KUnZqVmdacUtMdmpsektJQytobkQxc1NGaFlZd2dNZC95Yk9BWnVQQVdV?=
 =?utf-8?B?bnJQOSt0NDU5WjJ5d3c0RWY5bkZWNWVVN2p6cGU4VWFEUDk1RkNOMzR5VzRk?=
 =?utf-8?B?Z2c5UHVuTE1oYmtiVVQwcXpoUDNaZ21rMG9SVUVEZVJQMWozSSt6NlljNy9D?=
 =?utf-8?B?aDgvQzFSQ3J0RWc4KzJWYTYramhlOXJDS1dSMXRtMlQ3VFdubEQxaExkVUNz?=
 =?utf-8?B?ckVrYWo5OVAyMTlYNEU1YytscGpHeXZBWUpSWnlFajF0Kzl6dUJTN2xvaHgr?=
 =?utf-8?B?RENGZ1NDK2wwdlZiTjlBcUs1L1hoVEl5U0pOMzFFZVo2c0h5MDI1bGEySDlp?=
 =?utf-8?B?aTFWT0s3d3ozQ0VVMTBPSFBlMlVCa1BJYnlMYUJvS0w4QTlmQmJHL3NhZUFX?=
 =?utf-8?Q?XskXqUcFEOM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WTh4Nmx5UzllY3pLbzExR2QwVE1mTjFMekxlWGxuMSs3S1g1emVINlFPWTZW?=
 =?utf-8?B?dXZLdGdPWk1uTkFxMHpVSm54TXVkazZnYVlMMlpiMXFLRmhvbXkwK1ZuT0pu?=
 =?utf-8?B?bmZRcTJyYTVSSFdKQ0F6RkFKMGNpL3h0TU1aVm1iWFlkNzdtQlJLOGI1ZzlS?=
 =?utf-8?B?bDJUK3NuckJRbk9lTWlKZHFzZTN1S2dNL0pUYjJYQ3VCMmN0UXRSUi92Q2Rx?=
 =?utf-8?B?QTN2OFlhUHpWRHNUL2JncEVqT2F2dGc0aXcyclliRTRJQys3bUJ2cEJNWWZo?=
 =?utf-8?B?ei9RNUNBZ21GYXE2ZkZQRkE3ZWNQNUE0QnIvUnZGUkJ2YjB5M2M4WXhzZmRy?=
 =?utf-8?B?bkg0Q1A2cDFxdWFUVGJLRHViS2MzeitJTTB0bUtjd0lRZ051OGVSRW4wcGw4?=
 =?utf-8?B?azc4Vk4wTUh6TjMzWWtJYnM5WUhrQzhaODR6cmNoVUxGdlhrSzE5SVFINVNE?=
 =?utf-8?B?V0RYWTRzVHJKbW5sTk05aHRqMkVJdmQwdFpZc3NNTTh1OXErNzNPUGVmVkpR?=
 =?utf-8?B?ZTE1SHVMdGd3YWxBVXVac1hyb1F1WW56M3cwd0FPRWhyVkpRa00xT3BsaVN4?=
 =?utf-8?B?d1c5eEpSSVZkRUw1SThsdjlqRllld1V0MnV4UjFGc3VqbFRJc2Vvemo5TnE5?=
 =?utf-8?B?dTB6c1dlSmJPeU9rSHJDMDQrZCtJY2VtejluL3lFeFpwby9HMExlc0h0QUp0?=
 =?utf-8?B?OW56WUc4Z044ZEJTekVjTmFzcmVyN05STTFXYmtVMEdVbmRFZFNqRUdLY2RP?=
 =?utf-8?B?ZDNrQVBmK3Z3UWNrZVowbmE2QzNzaWc3SkczaTFFMDhOZjg0VlphR1hxK21S?=
 =?utf-8?B?Sm8wYUZjdzJta2t2WVJONlZJNFh2dmhRTGZwL0N5Z0R1LzJNS3VsOXA2RTBv?=
 =?utf-8?B?N09Ud2t3azJJWHdKMWJlQVJKbjNtY3drVjVtN3pOUFhUcXBYTHVYeDJyVjRo?=
 =?utf-8?B?enFRR1FLaCtNOUhtbFdZb2hQcENCWGdvUFViMSt3Q0I5S2dwNCttUDYvUmJ2?=
 =?utf-8?B?WWxlTTlvOTJBLzRQY296Sy9FWEk0a0pLSWhINWNnNVlPcWJDQUU3WHNPaEl5?=
 =?utf-8?B?OWJxRGRoSlYrMThwZzdQRmNWcmlmSkEzYWZxU0pRL0lwcHZFc0x0dEYyb3Z6?=
 =?utf-8?B?d3BwNVc1ekpDQXpZYmNuVDZ1dnE0cEJGUVBWT2hSQnpIdDY1SThVaWRheFVH?=
 =?utf-8?B?aHdwOGdEakt3Z0prSm1meGJ3UmZVYWJjbUw5OUkrN29LWGRvWlJvZHkyNzFL?=
 =?utf-8?B?Zk9NVkQrR3ZQT09mbms3OGh4R1R3TnJ4MmNQRGhGNGNOM3lERHBQUDZCZkUr?=
 =?utf-8?B?eTg5UEMwWFVZRDN6NHV3c3liblN1ZndRMWYybVZqcEhoN3hxbnpQNTN5VlZ2?=
 =?utf-8?B?K0MzYTRmTnVPdXRyR1ZvY2xkeHNSK0FMMVRmc3MwY0pwUWRkcGF4ditBZEFn?=
 =?utf-8?B?aXAzZXNkOW1INHlWK1l0cEJkc2NwcWoySkhFRWtlSW5YZ2dTcTJ1TXNHOTVl?=
 =?utf-8?B?MGY0Y0tncFNtcE9ZbzdFK2lvS0V1WVlrV1ViTE5PZ1VDV3oxU2dYWEhHQXls?=
 =?utf-8?B?cVVJa1VNa0sya3NRRHZ6Q0VuZXBuekY1Z3YxaUt0T1ZJeWZCWEl2RTBCd3BL?=
 =?utf-8?B?TjFBNTlTZ3BjN3l0U3NERUVGWXpxSDR2OXJTaWYzbzgrNCtGMUJNSkx6WFBH?=
 =?utf-8?B?NmxkWVZLaXBMalN0cFYxUEJydzBiM1ZqRXFIUUl5cXRGSnhONzJKb21BMlJk?=
 =?utf-8?B?L25hYklscW83RlpLT2tuOUx2YTRFSWU2anA5R2pncW9Ed0NtVTQvQm1rcHNv?=
 =?utf-8?B?MllaLzNpMC9GSG1wbkQrcTZOd2lVdEFxRXZ2dDZLemtoMTdmdFRVajd4c05w?=
 =?utf-8?B?bCswd0lZOWRkemFXZzNIWHNRMFhvM2hWb3dsOXRrR2tGR3hLdndjU3FxVksw?=
 =?utf-8?B?OExZY0xQc01lOU5QSEs4SmlvbXVsbi9oWkRBYTkzSkROYVcyZGEyUmdkVCtQ?=
 =?utf-8?B?OHZxcnZvNVczMDFwNElTajBKbERtZ0JKZVY1SngzaVpsdU5hajE3aUpjRWMz?=
 =?utf-8?B?VUI0eGhycENNOGEvOFdjdXJiWHJQZWVmOEZKUVRZQ01vUEVaeUVEL2tNdTAx?=
 =?utf-8?B?SS9peER1WVdObGl3TW5uQ3l6RzBvazdpYzFnMFRmNTMySTZTaExraVRyUVNT?=
 =?utf-8?B?VVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a2a4ca70-2c19-4753-4fee-08dd7f035bc3
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2025 05:30:55.9325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y4D1a3+o18xkSWksoNaIy1oh9nUm3QA9JtXzdffWJnk3npoXLoRyA1EtWz6oxxSuwRiPJx/GscnQfKPNc1uYsM8Kk9fvsk0rRknkcMoxV/4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6570
X-OriginatorOrg: intel.com

Hi Tony,

On 4/7/25 4:40 PM, Tony Luck wrote:
> There are two event groups one for energy reporting and another
> for "perf" events.

Please add context.

> 
> See the XML description files in https://github.com/intel/Intel-PMT
> in the xml/CWF/OOBMSM/{RMID-ENERGY,RMID-PERF}/ for the detailed
> descriptions that were used to derive these descriptions.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>

The url in text can be a "Link:" here.

> ---
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 57 +++++++++++++++++++++++++
>  1 file changed, 57 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 529f6d49e3a3..e1097767009e 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -42,6 +42,8 @@ struct pmt_event {
>  	enum resctrl_event_type	type;
>  };
>  
> +#define EVT(id, offset, _type) { .evtid = id, .evt_offset = offset, .type = _type }
> +
>  /**
>   * struct telem_entry - Summarized form from XML telemetry description
>   * @name:			Name for this group of events
> @@ -82,8 +84,63 @@ static struct evtinfo {
>  
>  #define EVT_OFFSET(evtid)	(evtinfo[evtid].pmt_event->evt_offset)
>  
> +/*
> + * https://github.com/intel/Intel-PMT
> + * xml/CWF/OOBMSM/RMID-ENERGY *.xml

This can be one line.

> + */
> +#define NUM_RMIDS_0x26696143	576
> +#define GUID_0x26696143		0x26696143
> +#define NUM_EVENTS_0x26696143	2
> +#define EVT_BYTES_0x26696143	(NUM_RMIDS_0x26696143 * NUM_EVENTS_0x26696143 * sizeof(u64))
> +
> +static struct telem_entry energy_0x26696143 = {
> +	.name				= "energy",
> +	.guid				= GUID_0x26696143,
> +	.size				= EVT_BYTES_0x26696143 + sizeof(u64) * 3,
> +	.num_rmids			= NUM_RMIDS_0x26696143,
> +	.overflow_counter_off		= EVT_BYTES_0x26696143 + sizeof(u64) * 0,
> +	.last_overflow_tstamp_off	= EVT_BYTES_0x26696143 + sizeof(u64) * 1,
> +	.last_update_tstamp_off		= EVT_BYTES_0x26696143 + sizeof(u64) * 2,
> +	.num_events			= NUM_EVENTS_0x26696143,
> +	.evts				= {
> +		EVT(PMT_EVENT_ENERGY, 0x0, EVT_TYPE_U46_18),
> +		EVT(PMT_EVENT_ACTIVITY, 0x8, EVT_TYPE_U46_18),
> +	}
> +};
> +
> +/*
> + * https://github.com/intel/Intel-PMT
> + * xml/CWF/OOBMSM/RMID-PERF *.xml

This can be one line.

> + */
> +#define NUM_RMIDS_0x26557651	576
> +#define GUID_0x26557651		0x26557651
> +#define NUM_EVENTS_0x26557651	7
> +#define EVT_BYTES_0x26557651	(NUM_RMIDS_0x26557651 * NUM_EVENTS_0x26557651 * sizeof(u64))
> +
> +static struct telem_entry perf_0x26557651 = {
> +	.name				= "perf",
> +	.guid				= GUID_0x26557651,
> +	.size				= EVT_BYTES_0x26557651 + sizeof(u64) * 3,
> +	.num_rmids			= NUM_RMIDS_0x26557651,
> +	.overflow_counter_off		= EVT_BYTES_0x26557651 + sizeof(u64) * 0,
> +	.last_overflow_tstamp_off	= EVT_BYTES_0x26557651 + sizeof(u64) * 1,
> +	.last_update_tstamp_off		= EVT_BYTES_0x26557651 + sizeof(u64) * 2,
> +	.num_events			= NUM_EVENTS_0x26557651,
> +	.evts				= {
> +		EVT(PMT_EVENT_STALLS_LLC_HIT, 0x0, EVT_TYPE_U64),
> +		EVT(PMT_EVENT_C1_RES, 0x8, EVT_TYPE_U64),
> +		EVT(PMT_EVENT_UNHALTED_CORE_CYCLES, 0x10, EVT_TYPE_U64),
> +		EVT(PMT_EVENT_STALLS_LLC_MISS, 0x18, EVT_TYPE_U64),
> +		EVT(PMT_EVENT_AUTO_C6_RES, 0x20, EVT_TYPE_U64),
> +		EVT(PMT_EVENT_UNHALTED_REF_CYCLES, 0x28, EVT_TYPE_U64),
> +		EVT(PMT_EVENT_UOPS_RETIRED, 0x30, EVT_TYPE_U64),
> +	}
> +};
> +
>  /* All known telemetry event groups */
>  static struct telem_entry *telem_entry[] = {
> +	&energy_0x26696143,
> +	&perf_0x26557651,
>  	NULL

Looks like a change from previous design to use telem_entry::num_events instead
of NULL entry. The NULL entry can thus be removed?

>  };
>  

Reinette
