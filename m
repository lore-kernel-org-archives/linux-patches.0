Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA522556E
	for <patches@lists.linux.dev>; Thu,  6 Nov 2025 00:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762387777; cv=fail; b=MSQ6cFuEVD4N7CPuJ8GdeXPzQlj7MtrO5GKMmpyOf+cI8T+6lygwausdsjl4ZGTEW0yIWenx6zDROA6QB9dIfTG1hINbJcyPSBpZL0YiiIo8TftQD+y86yYS8dgbrLGlMwHW9Rz0aYnxpkLIsmpstO0gaC02dnA1gUJ50WNUZZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762387777; c=relaxed/simple;
	bh=2RRsgUQyzq+GgRFyCXKfpSuI2GBMGntdKokG4iQ60zc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VeNbqRKWqZgaC+aZOL5rVKSOiM7IoMrNS6KxSTMJe6GV3ngnZQC6wRmeyQLSWt7QTfEJ4OqP+0JRJxEEr0FWHEizn/E4UkHhKtwf5VcBIq/9t0T4Mdw6OI8RxmetW0Q/kVDai4JzEERXV1ED36Prdp2mWDKaf/tSuuuzaByrUmM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AbehGc56; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AbehGc56"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762387775; x=1793923775;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2RRsgUQyzq+GgRFyCXKfpSuI2GBMGntdKokG4iQ60zc=;
  b=AbehGc56h2Vv2kKaPLQSf6bzRShnrHCaxb5QfYCyZM+ONPQJWTvFPfe1
   NsciOWQoHnw37UyKGVVRBI9LOl7UvZh1grGUpHY6VCofHaQjkhMQu2C6e
   a1ezhQxURrhBlfLVCno3L71JtMrEba+4imQt3fotl8rHTsfmtexzrU9b1
   u1jAHUDfQ96bHPA6L6Sg1ZzgJd+BWf6gocK3MJkleulma7nslUN7Q6hhd
   bu47kU+HY14YoFd8Za1h3anmJie1wTnr14E3QRADdF3I2gl2V/+Dd30Fc
   6hQvxedQ3Gy6cd1Q3yXdKLXg1zFGR4XVQLL1PlSuIIdHbEwZpRg0iTj4V
   A==;
X-CSE-ConnectionGUID: 2qC5muMmQkGUx1u/FMc7bA==
X-CSE-MsgGUID: 4LzzPwrPRGWpSTcwoZzsfA==
X-IronPort-AV: E=McAfee;i="6800,10657,11604"; a="68376802"
X-IronPort-AV: E=Sophos;i="6.19,283,1754982000"; 
   d="scan'208";a="68376802"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 16:09:35 -0800
X-CSE-ConnectionGUID: NFFp6HZxToGjsYkzF068Fw==
X-CSE-MsgGUID: 2WXas65oSqq0jJjj5s/hmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,283,1754982000"; 
   d="scan'208";a="187306833"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 16:09:35 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 16:09:34 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 5 Nov 2025 16:09:34 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.43) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 16:09:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rWNEphteqJrPKA5pPIjSz7t4KHjoeSD61Zt2A8cklxosDiK7rQ6mTgiYz/hacaMERB8b/scYlSNjVnKgQWrLSZEQ3be2benjroUREQ2+CWli7u7Kj9dUS+TgYvHLvwOjNFGf+IyIxv6QClMZKSHbeQiCoUhLvEbWkuiU6JCVAYBfsuWtZhVH6oySw/t+k7bK/OKL6XPltsreoZOVIx0/WxuyQtOPIlWju+liK+P4aZQPr2ph6VhZaI9aJShWFPFkKyuv8bis+JdmQE0a6fryvG6fLkRG+9eqo0oND/kI1Z1DKrYPae5iozynBfvAbGEm9xJrYUFOK9XaUFYwr5TI3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cir8zX/mqLoxM2kkc1TV1dKU7x+sbBAsH/607r+jSUU=;
 b=l3c2eBGMvJR5T/OuYDA/g1R6sKwB+Hx3jNDLBbd1X3D89tlX74bZAcWKZfkZW6b1evuYd9gDsEggqL1Bx8JAXr8/5BNKWDlrR0yPagrOBG2WhyDQlSzhB98imnb0Ex8DK4zJentnNAh90yxDg0+uGOtTRb/0D7bzyZr5uCdV+n5XfVHG68fRM6kAg+Qlkv9viLPLhhqHyZoWkFxJnDsc+knUpVwMtTxUpBTe2jyEzYq9Zx3wxNsOdMbG8fzOHbamtSV6jsuRqmQTiRhHdhogKW12jAJ2eXxwSIFKcjG9aIy7igOv4tO4KvF1aCl5g5l8ml+c7RVISeFZA7/UBp1ulA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM4PR11MB6168.namprd11.prod.outlook.com (2603:10b6:8:ab::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Thu, 6 Nov
 2025 00:09:31 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9275.015; Thu, 6 Nov 2025
 00:09:31 +0000
Message-ID: <3bf7f52c-80e2-470a-9225-36077a37d7d0@intel.com>
Date: Wed, 5 Nov 2025 16:09:28 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 12/32] x86,fs/resctrl: Support binary fixed point
 event counters
To: "Luck, Tony" <tony.luck@intel.com>, Dave Martin <Dave.Martin@arm.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Chen Yu <yu.c.chen@intel.com>,
	<x86@kernel.org>, <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-13-tony.luck@intel.com>
 <aQtiSmZ14b+U/J4U@e133380.arm.com> <aQveOz66Pd3R0FfI@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aQveOz66Pd3R0FfI@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0022.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::27) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM4PR11MB6168:EE_
X-MS-Office365-Filtering-Correlation-Id: 84bc8cfd-9be1-4756-5e6e-08de1cc8c234
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WTY2a0VodEZabk9STVVCa29PUWtQaHdSMkpPUXhTWWdJMmQ1ajlTclB5RWtx?=
 =?utf-8?B?b1laNG5aS0oyTEtMMXkvN2xxUzMwVEtTeXMrbE0vSng3eVNtQTduK1I0NjhH?=
 =?utf-8?B?bTY4RStnaXFxbFdvN1ZMdXRlMjdvelRWeDdETCtYaFhmbGhXSUdyYmMwRUEz?=
 =?utf-8?B?WmY3Y3R6UEg5WFBIa3ZtWm9mYlhaYlB6b0VwNFhSOHZHRitweGZtZWlxSENn?=
 =?utf-8?B?Wjk3aUViNEZtWmN6Ym5RQTZ1aEg4RnJab2M0di9lQjFwUkM0TFBVckgxc05U?=
 =?utf-8?B?dm93ME5UN0EwclhhYS9meFBndWhDWWd4a0NrcjI5Ti82OURHS041RDdpRzFZ?=
 =?utf-8?B?UG56T2NPM21jUUxPMmkrS0lXUEFzc1doUk02U0xZakpNUFhCdkxjYXpQN0RF?=
 =?utf-8?B?ZHdsTHpmQ3pEVzFsZExaUzMvREh6elgxa3lsTHNqNmM2NnBDMitMUVR2K3dV?=
 =?utf-8?B?d3VFUlM4YzhkT0ZrNnRXdHlScFhjT0k4UXRRWUN6bGpUVzFCUzNieGUxOUJu?=
 =?utf-8?B?bEluTDhyazBOV3lVZmt5Yjk0MlZjbWdMRUVFSXdrdnJmTDlURUNlUGVpZGEx?=
 =?utf-8?B?V1dsb2FGcUQ2Z3RCbzVzUkRKS0cvZmtiRGNCQi9kOEJJYTFieUs1OUNzTjdE?=
 =?utf-8?B?dCtXQU1iMkNhT0xSMlhIR1kzT3NyN2ZIWTNnenJrQzlpclVCMXJyN3VWWkl0?=
 =?utf-8?B?ZjRQWDk3U2VqWEJOTkIxUllDYUhiYk52c0tzeVFESzN1dVJ4UXBFWWtuVjV3?=
 =?utf-8?B?aTJYR0Q2Kzk0YWtVS09ybUxFMms1RzlDN2F2NFVLaDVncmQ2ZzBOeXB4V25K?=
 =?utf-8?B?Wk92Rk1Sakw2a3h6VndJeE1ML3lZbjJMMkVTQlhXd202Z0FnV3JIUVFZMkU4?=
 =?utf-8?B?U2todWRDRGNLM0hXRE5xeFp5eXBnbHYvVFkxZVJoM25LblNVSUppaTRLMkNw?=
 =?utf-8?B?ODNDamxlSXhEWmg0eTFCOEpIZms2WGtDeGVRWVdmQnNoSVdibWtISFRHeTVH?=
 =?utf-8?B?b2Z2Z2F5Vm4wMXVUaHY0VmtFa0ppTExGaWd3Uk1CbmhvejhMUWVMT1NYTHA0?=
 =?utf-8?B?NFQ0bnN3QXB0Rk5ZaHdmdytCcndTSW0xRnJkMnZOVis0L0FzUzNRaG11TmlH?=
 =?utf-8?B?NTNFM0VHK3J5UWR2akFhMm15YjI0aDZKTHpmSW5reG82Rm1MZzdaR1FoTzFM?=
 =?utf-8?B?NXNRVkdhblBpb25GZEs1QktTSzVqTGNMVnlIczVGY0pvbVJ6SWZQRXhCMkJF?=
 =?utf-8?B?dFNxSU54ak1GZEorNnQ3NTZNTzZuSzlraHJJNVgrV1poNEFYUEpZdGlBb1hZ?=
 =?utf-8?B?VGZob2hEQlkxMXpZbTJsbUgrWEpFYU1LckZwUzc4QWdHcFlFaUFhOXJEaVV3?=
 =?utf-8?B?OTdzQnZ3NDFoemJlamtCVXZWNVg1Z09sN1B6cUovbytscGFCRXFPTkVmNGQ3?=
 =?utf-8?B?UEF0aW4wc0VIK242T09wb1JmZ0UxZ3d0Mk1IZ3gwOXpiU21ReTl1UUIxdllX?=
 =?utf-8?B?TlM2YkFmRGd0Qy9nNHczRzEzWVRFVnpDbjNhZUJBQ1JlZ2FwK0haa3hCMWgr?=
 =?utf-8?B?OGJMKzZVcktPZWhscjJrbzRpSXV2K1FJNytRZW0yY1p2RmpNUDVLa0RPVE5S?=
 =?utf-8?B?SmdRVVlWekYxc2lmWmZaSzVRTWdWOUR1UTI0aWhTUkFXV0o5Zlo3dGZKYnR1?=
 =?utf-8?B?czlrUDMwVVdMcjd4TFpPMU9rYVo1Z3ZPeXVQSkl4NFpxenRmVlJYRXJzSXdC?=
 =?utf-8?B?NXV2cldXRkM5eGZjaUtieGpxMzVuZGZXVlY0L3VJUlVrbjFCYkVwNzRPbzlD?=
 =?utf-8?B?VFRNb0xNWEFhV3lYSk9mZVRCcHVaWTBXV0p3N3hPSWl4aW9tV1ZaOHJlOEtF?=
 =?utf-8?B?Zlpyd2pYaFc1Z3ZTdG9PQ1VpRTRhRWxTTEVMeWM2VFhVR0ttaUxDaFB3blJN?=
 =?utf-8?Q?BTwk19Zm5zCLJOnCDjYMGA7cykKEsvwg?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dVNwK0ZiZWZFUmtQWTRqK0czZEp1V3JzMGg2dS9ZQVdPaVNFVjRaUWs2OE5W?=
 =?utf-8?B?MURYenVpTmFYQ0wzQ2JDMHU5ZHhIMVNtQkxRU21tdjAyaFZjcEFJRjgxRmRY?=
 =?utf-8?B?bHZTQyt5VlRnOGNDTVR1MTBucXh2MndEK0dkcVBMNEF0ZllOTnptQjNJR1A0?=
 =?utf-8?B?NS9HQ0ppZkxOeFRLaXMvbDR6YzdBZEdPMUUwSUcydklONEdMM3hyU2xYaHZK?=
 =?utf-8?B?KzBObk41L2t4UVhNWGNEaUhjZkNNeEtqMnJqVHB1KzNpQzl6blZydng3dGFC?=
 =?utf-8?B?dmFhRHovKzhndnNiRzZQUUpIN0YzV3o1b2RTL2Z1U00vei9QT2thdCtzQUgv?=
 =?utf-8?B?SSs4RUNiR2o3TnJyUS9rb0gySGhoQ0p3d0FSSlRiWTgwanpCNHNKZTUvdzJK?=
 =?utf-8?B?SElRWkdnUU9LNVNiSkNEbWRPVXFtSkJBemx2VUo5TE9PZXZCTEZGRnJDQ2tT?=
 =?utf-8?B?YkFnRnR1cU1QTGNwZk9SMlFwdU43a1o3MWJXRTZ5RlcwYm5EU21TQ0pZZHlF?=
 =?utf-8?B?M2RuTVhCNlB1dXZDWGhRc1JqaE53VHJMS3R5b09lbms1a1dGUVpvVnRLa3pP?=
 =?utf-8?B?R3hmeVhMbXlXM1I1a0F5KzAxZjBkcUdoR0FvM3RBZkxJQXNzWDgyQ0p4Zks0?=
 =?utf-8?B?OWNBUUh2NE9CblpUSERxWW5JUWFrZXBDZ2g5Y0lOQlRVUE45QjZDMVpwQXVB?=
 =?utf-8?B?N050cDRmY1NxOGZHMGtrdmFZSUtoOUdxTWQ3MmlUMnJXaUVwaVBqc0lBRG1y?=
 =?utf-8?B?RjkyVlgvZEFBZVBXK1BKVXZPTDQxcTBZVk1lQ09XYjRYYU10WEprRHovVDlE?=
 =?utf-8?B?eXhmbnlFQkcxbDVoTDhYbXJrVTBHaE4vanpocDJSdHdlOGpCSVltMHBxNTRC?=
 =?utf-8?B?VUpOYUVXN0wxN3NTSitHRTNPeGh0OE1VeVN0aE9ZL0lrUnkzZ3dEWnFnRTUw?=
 =?utf-8?B?cFd1a1pNMmNoOFdCbjRJc1pjZkE4SURaSFRBcjd2K3pyak5rdUl0dnRmQ2VI?=
 =?utf-8?B?VXMwa2VXQ0pBMVVrb0lZakk0ekliVHpkdmNmM1RybFBCQjM5Z0pGbjVWaVFy?=
 =?utf-8?B?K2REV0M2dkt5Z2o5VWtCZGpKeTFKM25zc1h6Vmc5YllYWWlrV0gyZHR0SFlN?=
 =?utf-8?B?Sk8xd1g1OFd1cEZ0aFhrZFZGbitJNFNwYkFZNllWZ2gxeWxGckdhTTZUemk2?=
 =?utf-8?B?RUMvMkQ3WndCeERqMXhTMlhlT1RYVlJoU2I5b2dUdGVPRnA3OTgxRlVPSlhE?=
 =?utf-8?B?Y01obHNETVlVWHBvQk9JNUNJN0RiZUNtbGZ3czBjclcvU0dUNFNvbFV5WnlS?=
 =?utf-8?B?OTJDdmtmT2pKUGpjVEFsNUZkZ2hiVlhVRWFmVGR2S0tqVXIvM1RTbVNmUVAz?=
 =?utf-8?B?eVRXZWxxbVFXRTczTVhHMmtNTm85OFNlSVFoZlBoMzQvZ29aOFZNUWI5K2Z4?=
 =?utf-8?B?eHpTMjFML3Z2Z25WZFRFbnM2TkNwa1c1clFzSEdlTWFvUFMvVzFvdHVUS2dv?=
 =?utf-8?B?UVZQbGRxR1RtV3VuZzNBdVM0TS9rN2JjaUFKb3FRUlNJblBKNDVjMjdUSU51?=
 =?utf-8?B?NWtTb2hmRzk4QWtBRlNFOGs4U2xiWEhMUm55ZXpjYXFseTVsbVlrV0FUdXJJ?=
 =?utf-8?B?eHM3bjVCemkyenBGa21hVlN6WmVhWDgxRU5CQlVCdVlkV2h2V09zRWp5ekRQ?=
 =?utf-8?B?cEErOXlkeXJlYnAzUnQ0cW5nRGNQNi9jblVDeUJabTdrdkhJOHhGcnpiN1di?=
 =?utf-8?B?UHdWWXhncUR0THFROFBrekFjRytQbGpwbS9IVHVMT2tlbWI5cHBINkhqVmJs?=
 =?utf-8?B?OVJOSm9VMHBxcytkQXVjZjI0aE9zNHJoWFdvWDR3S2h1cDBnNTRBWDRydzZ0?=
 =?utf-8?B?MWwwbVFnbEN5VENlbWFTcGY2WW5paXFDVTJWQyt1Snk4NDRuQllRY1JLK0tG?=
 =?utf-8?B?cFI1VkdRZndDWC8ybGVFZjR2TnpJVFA0aGN0Y3ViRE53MUhBQmVqWVBxL2Jp?=
 =?utf-8?B?d1h3aS9XWXFpSVRwMkVIdm9Zc2hNSUNkN3NPd3BxNXFod3hyRjJ5WnEvNm05?=
 =?utf-8?B?WTdEang0QWt6S2RoTGxubmFMdWE3bVJGZjlyVkdreGljYi9EK04vR2hCWnVI?=
 =?utf-8?B?TFE4dWFuZkZNZEtiSjhSV1YxUHh4ejZpU2pYMkQ2NnA1Q2R5NmdiWHZmVUNL?=
 =?utf-8?B?RkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 84bc8cfd-9be1-4756-5e6e-08de1cc8c234
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 00:09:31.4861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MM+fJJO5xwe1Nn+jg8HwLswQpBq8gsvpGBQazcsraa8IMUyT+dnXdXN2CtoblIMpjSyu9wKyVFcoTgnrSjgxN2/od7llLDK2M+mYP3aVb3Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6168
X-OriginatorOrg: intel.com

Hi Dave and Tony,

On 11/5/25 3:31 PM, Luck, Tony wrote:
> On Wed, Nov 05, 2025 at 02:42:18PM +0000, Dave Martin wrote:
>> On Wed, Oct 29, 2025 at 09:20:55AM -0700, Tony Luck wrote:

...

>>> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
>>> index 40b76eaa33d0..f5189b6771a0 100644
>>> --- a/fs/resctrl/internal.h
>>> +++ b/fs/resctrl/internal.h
>>> @@ -62,6 +62,9 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
>>>   *			Only valid if @evtid is an MBM event.
>>>   * @configurable:	true if the event is configurable
>>>   * @any_cpu:		true if the event can be read from any CPU
>>> + * @is_floating_point:	event values are displayed in floating point format
>>
>> Nit: Maybe rebrand this as is_fixed_point, or is_fractional, or similar?
>>
>> The print syntax is just a decimal fraction, and the hardware
>> representation is fixed-point.  Nothing floats.
> 
> You are right. I can change from is_floating_point to is_fixed_point.
> 

This is a fs property though, not hardware, and highlights that the value is displayed in
floating point format which is the closest resctrl has to establish a "contract" with user
space on what format user space can expect when reading the data as backed with a
matching update to resctrl.rst for the events that have this hardcoded by the fs.
Whether an architecture uses fixed point format or some other mechanism to determine the
value eventually exposed to user space is unique to the architecture. 

Reinette  
