Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C39256C89
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 22:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757456282; cv=fail; b=CM+hyk0aG0qA/OpLtZ+zSb3ZtowcKU4O8tWSk5YWOrkqdvCtDH268k3TkKHlgZLWW6SqP48wBuDByhEZ8PggQ/tX38anW/069O2b30ZmJ5gBoyy9P/B5mhc8upa/GzzW0Fka/r1XExl1xjW3UX1qvJh6hVtJzop75CJSJOEyHG0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757456282; c=relaxed/simple;
	bh=jSNMKUTN6lt+Eo1QhxJt/YEqEDLvuz7FPw5T9eu56IY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=t4PBmfjYrK9/HyQ1fKNARY8x8fn7YSkWMtq8QZRWCK6Ukl3tzielufjfvB5OtWyV9td1yhxyOgRv+PE5dsrXWgeaqYO4wHWfrWj5sIc2NoYLG3SClFmQdkP52xUtjFniCpoptsFgZdjhPOdbW/DAnD7CVfnrIVxnsrUtu7RFepM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W40Pe9R5; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W40Pe9R5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757456281; x=1788992281;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jSNMKUTN6lt+Eo1QhxJt/YEqEDLvuz7FPw5T9eu56IY=;
  b=W40Pe9R5rakSL73w9DfUTtxemYNWfxxO/Et1fIkEvBEYx68M0JJU0XrF
   OKnyAO5RsGsIYhkGX/Gl9N3OyeSHlGYdqChnOlunPWXelRy/jY3cUl5rS
   SPW7tWo0em3wFKMe0n85DciP4UHoaJ22OlZbEs7jhDWT4p7ymO+gB2rIm
   iAvakciSi4xUMg30RemVLpDytjas7bgOdhLbMaOA1TVttF/Qg/GUlXCBe
   JhN1lp01NbEpI96FspL6OW9AwwJ+FY4jwgpqhTwtL7fmZ1+3hpiY1NJ/V
   ugU14ITJq3vBXxMa57HEnyH7qYdLlkLHX0bp+WHMsSZgkDweXw2TyXZ7n
   g==;
X-CSE-ConnectionGUID: 9LOOjGsZT0CudXdq/VBAFQ==
X-CSE-MsgGUID: 5RPuuV6qR0CuVqTwHLq80g==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="85205649"
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="85205649"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 15:18:01 -0700
X-CSE-ConnectionGUID: muecoXN5SDaB2XsSIv5iPA==
X-CSE-MsgGUID: 4T4aejnhR9WRIFhRg5XeWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="172495525"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 15:18:00 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 15:18:00 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 9 Sep 2025 15:18:00 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.48) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 15:17:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b0/kSspOdcJfBUQ07FEGUhrt6A3PhOMweZ9iD9119zDmZHcxSFmib1viVAtBvWdUaE6X4X7x7HKIHRmmfWwO4L4nibkHy8iMppsbCL3AQIZLViajSFtxIz5i6+kPFdaMcHZZeih22IaJaZU9PD6bOha0B3Dtf282f85jn2o9Hsck9udCGQR+I9PN9GANauwipyYdQlsN52eJIoazOe5X3Ou8Jlyg/QTLfqZnxZY4Q7CUZbIO+NoiyGpfQdPjzl3p+eIaBiFHgC+VDACvWaHU2OKGTpKcQxhSFjiyK1HY3pixzrwO0mJA9QInCnwtiaGwYG856pY8UQvObMUR9hFCKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vyuawwDDVfxldri5Q0fPVPAFm9ZcztHQtI3zIjb20q0=;
 b=vM3NBRsVHhq9Zufr35C49DVXaEPjCZyW1F5QA425SnuOA40lORI5JSExjl/TlOdoB+dL6qac7Plz6H8/n1bJRSB4qSSau0JIFJIsV0SOnH62W8KQrcjKdG+9JWq1Rsi9/gSxxEt/zq0Y/ZfOdRrScHRRY6DKg5TtLmANF2cY0Ioj9kN50hPUCSQOvRelbKmn79DjNJDOtytoKR4rdVkULfgCqXh4HJv0nu2R8zJbGIZKvpYSvfToBo9ySpB7uin1cLUqFhEMehGLa6zmW+wRhGtuU6qq0VmXDe6uVzoikDbulK6usOuMaEFXttB9Mdw+S7IhX1e3jKbjyGWKODHs1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS0PR11MB8133.namprd11.prod.outlook.com (2603:10b6:8:15b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 22:17:57 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 22:17:57 +0000
Message-ID: <b9c3ed92-19b3-479e-b797-baebb858cfc5@intel.com>
Date: Tue, 9 Sep 2025 15:17:55 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 15/31] x86,fs/resctrl: Add an architectural hook called
 for each mount
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250829193346.31565-1-tony.luck@intel.com>
 <20250829193346.31565-16-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250829193346.31565-16-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0154.namprd04.prod.outlook.com
 (2603:10b6:303:85::9) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS0PR11MB8133:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a85725c-6526-48ef-a250-08ddefeebaa8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eUJjcXgycXlkMUpDTkFFREhvYlEzcExJdks1OFFlVlAyck9KMkdhcjNIZkVs?=
 =?utf-8?B?Q2J4T1hQWnJFVVFZS1g4QjVWTjRkQkdZVUorR3NnUWd0cGNEUDlhajF0YmEv?=
 =?utf-8?B?d2JYdVd1cFMrdm0vM3NiamloTFpRRTJMNnQzWFI1dTd3T1EyUzUyZ3V2UEdk?=
 =?utf-8?B?MXdqM1Y5dHVtWFphRlBubnZOaGhDZmdQaDhZdHFjb2JLWDVaM2prcy8xTE4r?=
 =?utf-8?B?NW40ZEZYaCtnTVZTQWpULy9PNS95cUxjajcyeTVMdVZjd1N4bmp2Z2VhUXR4?=
 =?utf-8?B?bzF5R2dpZldRL0JwK2ZZVk16Y3pQQjhYbWdDUURaaC9HKzVVVFRNMzlVQ3lQ?=
 =?utf-8?B?MURTVVlxOXp1OEhnYmxrczdaejVNNytNOGRJQWdrUXMyNm0zVnhrelExZHk2?=
 =?utf-8?B?cFRnVEpHRmRBVW5HYldGM3R1WXgwS2t3M2lueXRMVlk2blJwTGpubUN4TE1X?=
 =?utf-8?B?enV1SEQ1WEZtd0hkTGlyWFI0Y1AxV094Rjdzc3lVVDBoL1ZYaDhPSGNtUUtY?=
 =?utf-8?B?ZUtLV0R0Z0FSQTVYSWdOTnVXbEhJOHA2eFM4eSs5Y2E2aW1Hdnl4N25acTZy?=
 =?utf-8?B?Z2pJS2hTSzg5YXNOajBxa1c0Wnl2bnQ5Rm8yYTZBbk1GZ2JxQlNTMnlWNklH?=
 =?utf-8?B?OTJibC9mckp0S3FSV1RWcnVTaHoySGdsNGk4SVR3bGlXcDdESWVpdWZSb2NH?=
 =?utf-8?B?UTA5NFlLSE94RFFESUkvRU01YnhsTFdEb1BRU1d6UTduYTdmK2M2cUU2NUlL?=
 =?utf-8?B?Q2plMXd1R0RjdWlmNm1OV2htT2YyMW0reVBwWlQ0ZGhYM3VqNG1nWms2RUdy?=
 =?utf-8?B?OU9wSGkzQ201UVdJWGhqbXU0Mm02RkZLbGZ0MDAvWG5wdS9HTmFBdXJ0K3pk?=
 =?utf-8?B?OWNZaXNMZFhiOWVVM3VBR3dzNWx4UnBCdUpZZ3M4L3FBTGl5VnFCL01IZUh5?=
 =?utf-8?B?MkpONGdRc1VjVndSYkY2K2plVFlJbDBJaUxYeHdDbDVZYUttSmlXTDh3MjJj?=
 =?utf-8?B?YnJnTDVrbDZuZmFlOVVJaytKK2IrYVpYeGlBQkZqbU1SOS8wVDNPbXFHei9L?=
 =?utf-8?B?dVhMM3I4c1QzZlovR0tuanVIOWdCVkZDU243T2FEVk9vMWdLZkxYV2xBQ3Rt?=
 =?utf-8?B?V3pJLy8zZzEwNUlzbTUyeXZpaTlKS0w4WjhySlRZY2Y2cGFhckEwNzlGMlE0?=
 =?utf-8?B?cFhnNlNFY2ZGekRya01EUGI1bXUyT0tCdnplSkpjaHNTRXFpditCcmx6d0VP?=
 =?utf-8?B?cG9wUHdXRlVlYlZjL0xVMlZvRmpRbWxPV0NrSFZvMzllK3BHV2lxK3MyMUdG?=
 =?utf-8?B?cHY3eXRISVdsZ2RiMCthWms2M1d1S2pTck0raXlKNXFhR3NOTU9hK3kvRjQy?=
 =?utf-8?B?NmlyWlpTOGNhNDNOVSs2S1kvekdLdkRxMFZRUHRleDNSaGY1Q0kwamI5L3JV?=
 =?utf-8?B?OVNYZTlEQ2VWQjliOFBUUytqVTdQa2NBN2IzVnp4RkFpaDR1cFNCc2FObkZ2?=
 =?utf-8?B?QUgzZk1IU2Y2YllsTmFNQldvMjFlbFFlZ0JiVmF1bEtPbmxkeUVvWExwMHBs?=
 =?utf-8?B?YzBLRGMzK2I1emZHS1IySlNTbEQ5M3dObW43ejJRdnQ0bmxNbDFwTGpjT2RG?=
 =?utf-8?B?MU9FWStEWkZDaHUvMFpCNXhpOGYreVZKWGtnWm91YzNERXltcUEzeW9DeUg4?=
 =?utf-8?B?d0FJNWxwbndRZFBONW5sV1hjTEQrdHIwWERBWVpGeW9sSFcra3E2bkpTTVZy?=
 =?utf-8?B?WG5IaUd6T2NPdEhOV0Y5ZTlFeFN4OU0vZVA0THI4V3BwbjR5enVnU3Ayd1Qx?=
 =?utf-8?B?bnQzb3ZrWjk3dDNjS3Q1YlZEMWdvNU01SEdsYTRGQWdXZ2xRL3UrcGg3RXI2?=
 =?utf-8?B?Nmh3ekwxMDlCR2FYVjFwaTEvSjRjK3ZNWVRNVytMY0ovSkV2RC84Z1RyZWJZ?=
 =?utf-8?Q?2sEqplbldNA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aVVBVkVGbmxvWHBJdlVYaWNJWDlHZGRHNmdXb1FUZ1IwSUV5eFZ0eXJweUJh?=
 =?utf-8?B?cWU0c0U3aC91QkphK3U5cHVYdjRvM3Z6Y0RKMlVyNlVmMWFTMXBZcTFBNjZM?=
 =?utf-8?B?K01hYmlWWThKQmV1czBDRXg4VGFrSUNZenBKZFhvZTk1czRJWTE0OEZMSVg4?=
 =?utf-8?B?NnRXd1RicWlLcnV6N1ZyVEN2czNiYzBTN0d0ZExvS0UrUmsxQlJKNFZmTStS?=
 =?utf-8?B?MHJWcUJDVGluS1NzaTdJWXdSWFdKWmt1Q2U2bk1hbFVtVzBUMDZ2VWdicmdO?=
 =?utf-8?B?RU5YMk1DczhIbnVlNGh2KzRQUWovbUs0dlB2MmNyUDVDYlBxVVQ0N2ttUG1X?=
 =?utf-8?B?U1VrdmxqNy9VeStNRE9TcHdad2g2QWtvTmRiaVFvcm44Y3E4QXI3MHQwaUND?=
 =?utf-8?B?RmVLNEthWEZvemFvRkk5WWxzMm5raHFvTGVjN3BJbG5RVTVTbk9Cb0h6Mmsz?=
 =?utf-8?B?cUZTeE1wWFZVMHVoSzZ2dnZNWFBpZXo0NFJmU080aXFyOGtPcU53WlUzTHhL?=
 =?utf-8?B?aDFodVB2dWpmemJzMUJ5YkxTaFBaTTFrWWJHSjRzampBOGNUelhKUmpNaTJy?=
 =?utf-8?B?TVh5MTEyQ1pNa3F5ajlmQU8xSG8xTHYrRHRZaStPajM1WlpNWGY4b0RMUjE0?=
 =?utf-8?B?em5Xb3V1UU0wZm9HRXJHUWErK0VuejZmMXJrQ1V0a1BUTzNJNTBlWDlobW1U?=
 =?utf-8?B?R2RUdmxIWk9WVXFpbUlxZnFndEZCSzNvR3R4YitHWDdnQlM0cUN6MHhpVGwr?=
 =?utf-8?B?UnB4MHpFcXRHTFpqNE5OdzY1eFQyQ2RXdy9OcGZ5SVVCeWFodUdybklKTzY2?=
 =?utf-8?B?Z1dlWFdMRkJPVUh6ZVAvS0p4cU8yaVE0bXg4QytMNlRDaGJ4aUZWakNDVU1S?=
 =?utf-8?B?K1U0LzV2RnhBTmEyTUx4Nm9EZ1loU1pWekR6cDBrT0JFTUVGU2xOVUxHbXow?=
 =?utf-8?B?SE93azd5MHduUkV6dTgvWjkvVllYeUVWbnFzYTdLMUt6RFdtVkNyS0plVUlk?=
 =?utf-8?B?SEM1eEY5MmJPVTRJQ012cWZDOHRxYm95b2F0WFI1b1g3UCtzL2x6ZU9kOGZK?=
 =?utf-8?B?b3EwUG5ta0Jzb0ljNmp0L01qUzl0cTFoMWNtSU1PR01rLzNPMXlKQ0NWMHc4?=
 =?utf-8?B?Z3ZvTzFkSVJNUXJsbjFBVlBHdm5aTVlMQVZRWHZHNUQwSmNQUTBVSU94dXgy?=
 =?utf-8?B?SUc2R083SEVLd1dLY3NCajVNVEwrT3oxZCsyL09zbFhwZ0lCTm1IRkljOFRD?=
 =?utf-8?B?RWhFQ1BjV0VIekpzVmdiaUJrdDU5UEwwU3hvMmdoV2NJYURoaHNEUU1HNlNr?=
 =?utf-8?B?d0pzK01QRVlNOFBUckR2VjlPM2lqdW5RMzJnUExpNGp3NVM5bDJoRVJhdEND?=
 =?utf-8?B?UW5vMGN6RlBTWUFIbmRYWHV6S0I0UnF1Q1NaTEJyUjdKMlZMdXA1enUvRnhG?=
 =?utf-8?B?RkZVZDNkMDM1WTJQWUNsWDVaRjNmQjZJajhFaWxzTEpLTjdQMVd6UHBCMXEz?=
 =?utf-8?B?WVY0WWVBWjY1VElaMVVFU3NlSzVxTDl2ZnkyMnBVZWszMGxQVmtBV0Zwa3dJ?=
 =?utf-8?B?cHdnTEUwRGdrNmxDQTlMbklzTlNzZVNCTnN6YXVFRm9KYjRKMnQ3ay9WQVVo?=
 =?utf-8?B?bTNRSkwyV1MvT1dpRktKZjBkVDBVTlVHZHVlRFFkYlYrSG1UQ0xGeVpuMHRB?=
 =?utf-8?B?bUVyZmhkY3pwT1JYN3ZZQjVmdTRkOXN0NmhadHRERGpPUXl5TUUvZWxxNFNn?=
 =?utf-8?B?eXU0TlpFMnpTWDVnRlEwQW1zNXpoZTlwUlNBTFY3V3pSMmpHK0lxZzMvbnQw?=
 =?utf-8?B?ajlrZzRMSGF2Q2RSbDQzSFl2UnBlWkVab1FXWFBLNTBWZ2htU1ZxczNLRkhV?=
 =?utf-8?B?SitXalFaZmJOMjE5amZNL1pKeGhWblV4UEVaaUxaMVpCSFpibGJwcnFxUFNx?=
 =?utf-8?B?MEZXalZKOGZOVlJEY3poZDZacXV5dkZiL3lTeDIxcUpRSTc3TTRzOWc1ZkNJ?=
 =?utf-8?B?SUlwYXZxeGIyZ3dOSlpXRFJLNXRmVm44cWw1QmY0YktqRHpxZnhzTU9ncWxU?=
 =?utf-8?B?ZjRqTDdOdjkwOGtVWVZqcnJUSERVQ2J1RHpCS2tVOEl1VDdYamNkOGhHWmk2?=
 =?utf-8?B?WTR5ZlkrV0N1TjFNQ1FZbml3RHpNNG1PejhkaGY2dndleXNpbU9EcVRxMURr?=
 =?utf-8?B?ZVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a85725c-6526-48ef-a250-08ddefeebaa8
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 22:17:57.1145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bVAdZVBmoHTjDrH4mZ0ufU8QJf36JCmxLpCdnO8r8jhNU1JPoTrwImwvN08NaW7lyBvWbALQ59tWHSKT3sWPSnEypJ1waJ8q4VArdzX+zuY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8133
X-OriginatorOrg: intel.com

Hi Tony,

On 8/29/25 12:33 PM, Tony Luck wrote:
> Enumeration of Intel telemetry events is an asynchronous process involving
> several mutually dependent drivers added as auxiliary devices during
> the device_initcall() phase of Linux boot. The process finishes after
> the probe functions of these drivers completes. But this happens after
> resctrl_arch_late_init() is executed.
> 
> Tracing the enumeration process shows that it does complete a full seven
> seconds before the earliest possible mount of the resctrl file system
> (when included in /etc/fstab for automatic mount by systemd).
> 
> Add a hook at the beginning of the mount code that will be used
> to check for telemetry events and initialize if any are found.
> 
> Call the hook on every attempted mount. Expectations are that
> most actions (like enumeration) will only need to be performed
> on the first call.
> 
> resctrl filesystem calls the hook with no locks held. Architecture code
> is responsible for any required locking.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

