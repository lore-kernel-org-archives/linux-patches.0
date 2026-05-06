Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5851C861D
	for <patches@lists.linux.dev>; Wed,  6 May 2026 20:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778100789; cv=fail; b=se1tf74SrVImkBAxPfbggtdgQwlxG7D2IYtPqo6twr1caxCIdZTyet7OXN0NLGD/gnL8FM8E3oroh4wGDjINzKG8C0kgVI8iGKYaLA0RYVZikUniRcbICwQ6wSnxcRfz/w8ng0Vovz9s7XU8qOLl1lfIYZjS4QHvn8JlxJX/76I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778100789; c=relaxed/simple;
	bh=5axneQ3z7lac8qtHss/485Y2qe45k8ZXJWQMdHWd4IE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=faggwf9HrcgBAU/DAAO/35mMneB2qszOBcSh85WjXQxKDxVC1ZMq3ThUXC/0IxE79lhwGh0mYT/FysHDf87EL36iz8LrdBggJLvmThGB8GqV3hKoDONLptqHPcYT/yZLSeNThk/NvsXBZVZVuOrZqkvhGY8IP0Cp57VvOBNzK9s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iGLUGUdg; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iGLUGUdg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778100788; x=1809636788;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5axneQ3z7lac8qtHss/485Y2qe45k8ZXJWQMdHWd4IE=;
  b=iGLUGUdg6EhqL3abrVEVLoZ87aM+LkHs99f/SkKSvWJbJoT+jTgiunqp
   E64rEAZjwm/D12+0+uEWf7RAGtZRih7dDno8/eDYjcDi8XrfGH3KHzmmy
   IaaepZ854ayokkNW13vplkfIwbTyonxLgnFYqu3mA69COoGbZg05tQtod
   OJVtmm6BfUCsGUqW2YrvH9l+lBj67dQ7qpg1K7G0PG5X/7ZeyIJrvASR5
   tjro0CRDZk026/YrHcUXlpnw7IIp6mDA/Pgy6+JdRrVBraQK+C+mphSiR
   QoSYccv01fzye1jWGjmshJXPwjPq9P3HeEF2BNWyfI9QYeJoBf5F7aHmb
   Q==;
X-CSE-ConnectionGUID: 7VNBsSsvRr6qGCx1liqIJQ==
X-CSE-MsgGUID: 249HkbZmTjyRK3sxtYhW5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11778"; a="104504669"
X-IronPort-AV: E=Sophos;i="6.23,220,1770624000"; 
   d="scan'208";a="104504669"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 13:52:23 -0700
X-CSE-ConnectionGUID: CTxG/YVlQuuZOXEADNisVg==
X-CSE-MsgGUID: M4ACCMTLSZyLAjjWTtdGmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,220,1770624000"; 
   d="scan'208";a="235399066"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 13:52:23 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 6 May 2026 13:52:22 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 6 May 2026 13:52:22 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.44) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 6 May 2026 13:52:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oZhwj7bT8/5xuJEVhGP7867ifLyXgWIkgxWQtvAdl10G3KLzmnOL9PbCdT0BZpopDtkrSZI7J9RU9zj0KBFAQSfic3p120fYjyYcMgJGf6LrU6gGNcQs5n7tsPgYn8brQzvhA5kCydjuZXwjBBbdnI5wnd2VIURkZnsJlwpP7RP0Oj1Gkfh1EaA7Q2SFv4kkFK3vmB5Zb28+PZ89LpNrNVId/YUo0fDXaPxS7QIsry6zbrYheeQuikBMuOA53pip5SpXllRRogzo6iIzNAKT8bstqghmZyhL/JhTsPNn8dDEHWWPL+bVBXbMKTcxGL/rIcEdqUPJQdG6wJDjg5lF9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5axneQ3z7lac8qtHss/485Y2qe45k8ZXJWQMdHWd4IE=;
 b=DM1/ZRPQL/G5z1SFGXeiHgYhIzfo5IneSuN3XYhS/uFMtMf994aIbSPjMWlfTCOzyeJbke8qd+RQ9oNbhp5OcZY4lhYJpfcjZNsZYojHXtfnZo3sWR/uTmwTFKqj2NAI54te8JBr3PN7TzpdEZ8qqbLAWCxDxxSipeueugAxc1UZvs86d9yuqFsBtVfTtw1jtYHUb6OlVYMA5vYBysEWR15Om9oK7w54pC/MvaH3fsDboIFTeMNWhf4Uvs2/DYUnCtG6+p6TmIdNwKualnTbr26+PrMGbNLBOdOh+JC/ZIVdSDThsaLxsXfBeTyT9KPa543tbHmfuVNCNsOq1J9oSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by CH3PR11MB7177.namprd11.prod.outlook.com (2603:10b6:610:153::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.27; Wed, 6 May
 2026 20:52:18 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9891.008; Wed, 6 May 2026
 20:52:18 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: Borislav Petkov <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, Fenghua
 Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH] fs/resctrl: Fix use-after-free in
 resctrl_offline_mon_domain()
Thread-Topic: [PATCH] fs/resctrl: Fix use-after-free in
 resctrl_offline_mon_domain()
Thread-Index: AQHc2bKUdc4/WN+WbUyjxuEkqyLnwrX9/UIAgACARQCAAGFyAIAAytUAgABOY4CAABxYAIABQzoAgAAbgYCAAAiVAIAAA3YA
Date: Wed, 6 May 2026 20:52:18 +0000
Message-ID: <SJ1PR11MB6083F439B6D0054FD9AAE478FC3F2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20260501213611.25600-1-tony.luck@intel.com>
 <2236fae5-7e66-43fb-ba05-76fd4434e2c9@intel.com>
 <afkizhrSwJkiLD3j@agluck-desk3>
 <3f13c7e4-3812-447d-8c42-b28fd6b9d0fa@intel.com>
 <afoesuWB8RezVLrN@agluck-desk3>
 <7fad1d7d-c892-416e-b97a-a230fd43f2a4@intel.com>
 <afp4OkwtPpyIwAC1@agluck-desk3>
 <d065f7b7-daac-4e45-b7c9-69175dfb43a7@intel.com>
 <afuecal0x8_2jcUq@agluck-desk3>
 <389bd92c-47ba-46af-81cb-9b669533b1fe@intel.com>
In-Reply-To: <389bd92c-47ba-46af-81cb-9b669533b1fe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|CH3PR11MB7177:EE_
x-ms-office365-filtering-correlation-id: 1cf62b6e-482b-4391-fe74-08deabb15ca1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021|22082099003|18002099003|56012099003;
x-microsoft-antispam-message-info: GK2Ij2ny2AchyFfw/y+6wVG7bEIKsl3B433diouVjPBvw0vzGvi+sv++LrMoXIv2f/peJ74VZon4HYPTrtMqA2WIQh0GLZgTp2E+VvE9bZBIApuasinSLfcbKnhZ4Z7pT7S1EDzh7bwnHcyKbE/ShCTbP9bi5U4A1vidW0Qp05hjWcfp6BevNCQBNo+oajpSefAf8UqcmIEf8kcGllp+byduZeJsh8zGZFa9DLrSuymEupOaRRF/xJw4XPfKUO6Kjy+wzcGcSO0dI07VePz8kyXuGvvn3hd8eFL5HqyudNhIcJtO17DIgB14IeFrsLJpVTZGcNA1X8f7kVQmioZfthU2PRiJ6wVrHBF9IwOiIYoJCwtovtbPZ2NXnQFkcBkH9ZEwYIbOuOBMWeubs52NVQhgw+6CBmxE/X1zvdXIw7Yp/dP4XTrSpudGIcMd79GKTMXBulYETngHV3vfLbq0wBmfGsaLizBtRg+c9qCbLh6mJOVGbbg0sr/JwxrX1ARi/UhHnPwexEx++dt36oluz1dOslpvlRTK/uTvT67V1nla3yX2nUmRF2rNI6v+xgMgPsGwN+JQZJC/BYXRtqQj0QUq28x+EvXQvdIeKFrBFdNKeltQLlGeWFAa1yQJjJRcEQNGSFq7K6daeEttSfYAhAcS6W+42Qwz4SIgJBM4MPnMv7MDP73Loy2io20bWx/okpJogEAs6yBpg9ES8chHz04pK+OL+KeA+98JQfEuyqhOPi+4Zh6w5qo9PdbzKwP6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SlpmUlc5TDc1Z2gvcUpxRk41T0dLbmVEaDJxWFQzZXgycWRtL2N6TDgrMk55?=
 =?utf-8?B?RkNpaEF6cE5ubnhrUS9rbWdrcjZYNTZlMjN5V3pyenZLaUxiM1FBYXZFRDFn?=
 =?utf-8?B?c1ZzOVVQT013enByWlh5a3daQ3JLalV5MFQvSGd5ZHlrOE1salV2VldVUURH?=
 =?utf-8?B?S0J5Z3NUbmYvNTUwTzVuaUxwUWNobXhJN3k0aWNvVW1pYWEvWVJKYXVsYkNW?=
 =?utf-8?B?R2hBa2h3VWVnYWM2aG5FZGF1bzhJWFZRWWhGaFhVUlp2L3VLalZsb2tDcmhC?=
 =?utf-8?B?S3RBNDZoSUkybG4wdzdyK1E0MmpiVStLczlVRXlFeE85dDhQblBsWWU4clg5?=
 =?utf-8?B?TExtSlVtckJ1NnFqVEQveFFMV1V5bHI3bVFBZ0NOKytINlA2elg4ZCs4ZTBp?=
 =?utf-8?B?TFNYZEZJWlhkSnBNdDFzZDl6TDFIQWhlcjZMV1A5b1p6dk1BTWJ1eldjUHg0?=
 =?utf-8?B?RXJNOHUyMGlBcS9oZXdvR1A5RitQRy9FRFNoUVEvRGkzYnhZbkhlSU9HUkY1?=
 =?utf-8?B?VkdHdjVTZnRqSnVMcUpNRGx2bUwvN1RZNXp6TDVMQW9EcVpoN2Jab3JOWERk?=
 =?utf-8?B?bG5FOEFjVitiN2ZZVEJtTk9uaVZsVnFMUlFkN0hsWGZPd29EOTNYYkluVzk5?=
 =?utf-8?B?ZStJYittTGVldVNNSGVFZjhSVGRRdjd0WG10YitHWVZhcHZlMS9zaGpNMm90?=
 =?utf-8?B?a2xCa0grSS9wSENGVEU4cGVCRWNla2t6NWRDNWRldGhDdFZEYTcycGN2QXNY?=
 =?utf-8?B?Z0NGYTkyWkRaNzN2Q3RUbGRHZ2VyTFN3d2MzVmFxNml2MS9hMVM2bnhXQ3dB?=
 =?utf-8?B?WXp2dW5zOWg5endPWm5PcVR5ZWxOM1NLdFNkT0F6aHNZYW84em1NbWtUMFhO?=
 =?utf-8?B?LzBaOVVtbjBkSkNzSUk4eHgwL0RzMDE3RmR3eWRqMTJ5OUhweFFTNVZwaGxZ?=
 =?utf-8?B?WjQ3dHJrUkxUNnE5NFF0T1ZLS3JqTVJpSU9EeThuSkdyQ0RlTmtIbjFSbE9s?=
 =?utf-8?B?VXN6ZlUrNmhqNkt2aGRJWlFzdW1iVTZTTFR2VVpHMklGUjdJNU43MFB3dEZO?=
 =?utf-8?B?MUlIaGdQMkNMN3RGZFlHRVhRajVIZmk4MW9vSkxocmowQ3MrRzluRFBuL3p3?=
 =?utf-8?B?RDhXUW1qMWVpZ1FsNzhZcDd5WWQ3cUMrM0VSTm9xQXBkWFk0a3J6UnVCamd3?=
 =?utf-8?B?d0hIMHUzSm1XWG9sZDY5MjA2WXpodkxrdFhEa25aNUFUM0ZWNDhLaVBQRGVU?=
 =?utf-8?B?ajB1UjVrVk8zRmtmandPZnRqL29GVmdQejhSZDdmVWlYbTZ1YU04Y2xubEc4?=
 =?utf-8?B?eTcwWFJLaGZqdHFlRmdFdmNJNUlQNzU3M3VSWnBFaFYrREhOcjlSdGhzaWtB?=
 =?utf-8?B?MEdTU2g5WFo1dy8yVm0rMjMyN2U3djhmNk95ZTNVL0szemxJcVEzNTllYVdn?=
 =?utf-8?B?ejVnTDh1ZVNvRFl2N3RPd1dqRmMxaFNxVnZjbXFKc0xCTjJyRUpkdlQ0d0Ur?=
 =?utf-8?B?Yi9qQU5zdVIrYzBZVnpGZElDVVo0OUs3RHM4R2UwRG5zSFEvVTNha2M1SHJm?=
 =?utf-8?B?U0dKZFdsWG92MzZqYzRwZ2FkZllHRmFhRUZheGdNMmdoczFpQXgvRXdJOWFC?=
 =?utf-8?B?VzZJcHIvem5XUysweDlET2lVMmtLdWhSNURTbjZoT2M4NVF6UDZybG0rcVVP?=
 =?utf-8?B?bmdFdkdJQy9QVVhiNHVNNFRxaUNYYU5DbFJBZStNSy9WN1pNU3B5MldTMi8z?=
 =?utf-8?B?QkhiWnJUVlhybVg3SXN3VHpVY1JVdWZTOG1aOVpHbzZSanQ4SmJZRUFXVFlO?=
 =?utf-8?B?TWdTNUUrNnZyRmp3anJLTmQ1eFczZzRGcDVPUGVBcWY1djJBZjROdWpWYUt1?=
 =?utf-8?B?R1R5UkhYN3pseG44ZUNBdnc5NVFYTW81ZjB2bkVVYlhjZE5DR0FVWXdNRE5p?=
 =?utf-8?B?QmJuRmtTS1RNNXAvMktSR0FXVzk2N3BhRmtVblk1OUZsS3dNM09VQWZqOUV6?=
 =?utf-8?B?Tks1aGZBUC93Zy9kVGlaVm1NZHJacFQ1UEFaS3NJME9IN3lJMFJkaTYxNzAy?=
 =?utf-8?B?MytrQzRRQjZEQzdrNVJpZGkvbUNzY1E4MXFqUUU0UXNIRWtXQmtBaTFYZDBM?=
 =?utf-8?B?OEtBaEdVeFd6YXA4QUhVKzIva0tla3VzQzJEbXZGeTBhVGhCWkJtOWZoZjNo?=
 =?utf-8?B?d3NMekFGaExoMUI1TnVJbGhYdExWeVIrUUxUVlU4cWx3Y0M0TmMrNDd3Ympv?=
 =?utf-8?B?UVBvWkI1N0dBeFFkQUo5Z0MyZVRVWFFsNTlPbS9QWmlTWFF6eVhjSVhIQUJD?=
 =?utf-8?Q?OO9hqUGNt+Q3PGYPyh?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: DrCGSyeCcUVCdn6cNhzbhiNfzqdmzUfBfq/d5o8cTyhmTSclgWOJKogV2xDFNNmILhTrKJTiPRkbvX/yvPS5hrnBo4I0ndElmORLvbHC26qewFKn/LXUkVE5Hm2c+7BQkTmNtkJYAAX0ysgsnH6bxYLevqQnwZCOGMEDSlEIwMNIcWPB7l7fSDNZ6PMeK4x66ZEqvlOe7qAVYSggeOps4ru5HpUMAo7IpJTT9RjjmTueUTRswQQ7siFXq4RY58l72B+lLGYi4/ubbQ0OZDG1i3FQcjLdY8ITxVx3Z4p7M7Hcm7QCEy7icPpJ1mFtZd4IF1MjMQ3+GR08zQjAtdbWOg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cf62b6e-482b-4391-fe74-08deabb15ca1
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2026 20:52:18.4413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NSqavkqkln1lLhpM9QJdiRhtQPNQCX4S3duYjJg+LB+yp0eJaO6lOQADMUm57Ey1SvpD7U3Wa/CohL9VAOcGJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7177
X-OriginatorOrg: intel.com

PiA+IFF1ZXN0aW9uPw0KPiA+DQo+ID4+ICsgIGlmICghaXNfcGVyY3B1X3RocmVhZCgpKSB7DQo+
ID4+ICsgICAgICAgICAgbGlzdF9mb3JfZWFjaF9lbnRyeShkLCAmci0+bW9uX2RvbWFpbnMsIGhk
ci5saXN0KSB7DQo+ID4+ICsgICAgICAgICAgICAgICAgICBpZiAoZC0+bWJtX3dvcmtfY3B1ID09
IG5yX2NwdV9pZHMpDQo+ID4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgIG1ibV9zZXR1cF9v
dmVyZmxvd19oYW5kbGVyKGQsIE1CTV9PVkVSRkxPV19JTlRFUlZBTCwgUkVTQ1RSTF9QSUNLX0FO
WV9DUFUpOw0KPiA+DQo+ID4gU2hvdWxkIHRoYXQgIk1CTV9PVkVSRkxPV19JTlRFUlZBTCIgYmUg
IjAiPyBUaGlzIHdvcmtlciBpcyBwcmVzdW1hYmx5DQo+ID4gYWxyZWFkeSBzbGlnaHRseSBsYXRl
IGJlY2F1c2Ugb2YgdGhlIG9mZmxpbmUgQ1BVIG92ZXJoZWFkIGFuZCB0aW1lIHRvDQo+ID4gYmUg
cGlja2VkIHVwIGJ5IGFub3RoZXIgQ1BVLiBNYXliZSBpdCBzaG91bGQgcnVuIHJpZ2h0IGF3YXkg
b24gd2hhdGV2ZXINCj4gPiBuZXcgQ1BVIGluIHRoZSBkb21haW4gaXMgcGlja2VkPw0KPg0KPiBU
aGUgZGVsYXkgaXMgaW50ZW50aW9uYWxseSBfbm90XyB6ZXJvIGFuZCB0aGVyZSBzaG91bGQgcHJv
YmFibHkgYmUgYSBjb21tZW50DQo+IHRvIG1ha2UgdGhhdCBjbGVhci4gTXkgbW9kdWxlIGV4cGVy
aW1lbnQgZGVtb25zdHJhdGVkIHRoYXQgd2hlbiB0aGUgd29yayBhc3NvY2lhdGVkDQo+IHdpdGgg
dGhlIHdvcmtfc3RydWN0IGlzIGFscmVhZHkgcnVubmluZyB0aGVuIG5vIG1hdHRlciB3aGljaCBD
UFUgaXMgcHJvdmlkZWQgYXMgcGFyYW1ldGVyDQo+IHRvIHNjaGVkdWxlX2RlbGF5ZWRfd29ya19v
bigpIHRoZSB3b3JrcXVldWUgaGFuZGxpbmcgd2lsbCBzY2hlZHVsZSB0aGUgd29yayBvbiB0aGUg
c2FtZQ0KPiBDUFUgYXMgdGhlIGN1cnJlbnRseSBleGVjdXRpbmcgd29yay4gU2Vjb25kIHRpbWUg
YXJvdW5kIGlzX3BlcmNwdV90aHJlYWQoKSB3aWxsIHN0aWxsIGJlDQo+IGZhbHNlIGJ1dCB0aGlz
IHRpbWUgbWJtX3dvcmtfY3B1IHdpbGwgYmUgc2V0IHRvIENQVSBpdCBzaG91bGQgaGF2ZSBiZWVu
IHNjaGVkdWxlZCB0byBhbmQNCj4gd29yayB3aWxsIGV4aXQgd2l0aG91dCByZS1hcm1pbmcgdGhl
IHdvcmtlciBhbmQgdGhlIGFzc29jaWF0ZWQgZG9tYWluIGxvc2VzIGl0cyB3b3JrZXIuDQo+DQo+
IEJ5IHNldHRpbmcgdGhlIGRlbGF5IHRvIE1CTV9PVkVSRkxPV19JTlRFUlZBTCBpdCBndWFyYW50
ZWVzIHRoYXQgdGhlIGN1cnJlbnQgZXhlY3V0aW5nDQo+IHdvcmtlciB3aWxsIGJlIGRvbmUgYnkg
dGhlIHRpbWUgdGhlIG5ld2x5IHNjaGVkdWxlZCB3b3JrZXIgc2hvdWxkIHJ1biBhbmQgdGh1cw0K
PiBiZSBzY2hlZHVsZWQgb24gY29ycmVjdCBDUFUuIEkgYXNzdW1lIHlvdSBhcmUgaGludGluZyB0
aGF0IGlmIHRoZSBtZW1vcnkgYmFuZHdpZHRoIGlzDQo+IHVuZGVyIHByZXNzdXJlIHRoZXJlIG1h
eSB0aHVzIGJlIGEgcmlzayB0aGF0IGFuIG92ZXJmbG93IG9jY3VycmVkPyBQZXJoYXBzDQo+IE1C
TV9PVkVSRkxPV19JTlRFUlZBTCBpcyB0b28gYmlnIC0gdGhlIGRlbGF5IG9ubHkgbmVlZHMgdG8g
YmUgYmlnIGVub3VnaCB0byBlbnN1cmUgdGhhdA0KPiBjdXJyZW50IHdvcmtlciBpcyBkb25lIGJl
Zm9yZSBuZXcgd29ya2VyIGlzIHNjaGVkdWxlZC4gRG8geW91IGhhdmUgc3VnZ2VzdGlvbnM/DQoN
CkknZCBtaXNzZWQgdGhhdCAiMCIgbWVhbnMgImlnbm9yZSBjcHUgYW5kIHJ1biB0aGlzIHJpZ2h0
IGF3YXkiLiBJJ2xsIGtlZXAgaXQgYXQgTUJNX09WRVJGTE9XX0lOVEVSVkFMDQooYW5kIHVzZSBD
UU1fTElNQk9DSEVDS19JTlRFUlZBTCBmb3IgdGhlIGNxbV9saW1ibyBjYXNlKS4NCg0KV2hpbGUg
cnVubmluZyBsYXRlIGlzIG5vdCBpZGVhbCwgdGhlIE1CTV9PVkVSRkxPV19JTlRFUlZBTCB3YXMg
Y2hvc2VuIGluIGEgY29uc2VydmF0aXZlDQp3YXkgZm9yIG9sZGVyIEludGVsIHN5c3RlbXMgd2l0
aCAyNC1iaXQgTUJNIGNvdW50ZXJzLiBBIGdhcCBvZiB0d2ljZSB0aGF0IGlzIHVubGlrZWx5IHRv
IGNhdXNlIGlzc3Vlcw0Kb24gdGhvc2Ugc3lzdGVtcy4gTW9kZXJuIChJY2VsYWtlIGFuZCBuZXdl
cikgSW50ZWwgc3lzdGVtcyBoYXZlIDMyLWJpdCBjb3VudGVycyBhbmQgYXJlDQpjb21wbGV0ZWx5
IHNhZmUsIEkgYmVsaWV2ZSB0aGF0IEFNRCBjb3VudGVycyBhcmUgYWxzbyB3aWRlIGVub3VnaCB0
aGF0IGEgMi1zZWNvbmQgaW50ZXJ2YWwgaXMNCnNhZmUuIEJhYnU/Pz8NCg0KLVRvbnkNCg==
