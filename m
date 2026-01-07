Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED65738F241
	for <patches@lists.linux.dev>; Wed,  7 Jan 2026 17:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767806983; cv=fail; b=Q0mIFSCn7oiPr1axBgO1t5jtjDBomzX5EG8iCIpbfECSxS0kVz7kNDEDiRSNpe4RpGEoY1UMAKmZenWUfNSJI/ibliSo4XKhdVRovIv0h9yYUxlkkHChn6oG/x16MiOO88eLs60HA5coXIHVq+yxDdYPBFQRp7aC+OY2HwYnSPI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767806983; c=relaxed/simple;
	bh=RJS7id4su3T2pf0VG59UEqHMFDnsg+zaIy+U/aqdGCs=;
	h=Message-ID:Date:From:Subject:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Hj82ZvPMm6TAiPJPEoLcZI8eee7Rabt1lU7jsOUM1a1Xa65A8HK+P8+xoUg3B/7Wz7E8ZYdabO0Nh1fo3OUj991YE6PubispgCzxNtysEQnkbFiCQkxo6iYHdHJVfJ9t850glZ/iVjbCrLJ+lOv/KtISEuQuYhxPG/p9YRucKYY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gz45CT0A; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gz45CT0A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767806979; x=1799342979;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RJS7id4su3T2pf0VG59UEqHMFDnsg+zaIy+U/aqdGCs=;
  b=Gz45CT0AJvxvyVmi8XA2jx6caMDCavlMRjNzJqQf9IvIWyCrn5UjGu9C
   TLn+7X7UrSiQ0PyvBSKIC62jBSqkCfjUhxW97nj3Qdy8FBcfUoo0HI5W7
   gb9HeskZ23D2avnbkByPMnwMMaONmV4NTqyXEb5B3+R2byIO0IY/UIWoX
   Dvx93PVzOu1vI6rBzOWPENH3boIy3CPCzEoiwvwj1kynwfksry+2Gfm2D
   Z1vwFlbnRrFq2BX51Hz8S7+4rE4QUPhhmPH4L2jNdJ549BBgWcqkZTWfN
   MwEX5D53lasWHM1YeUxaMjZfMlqCJDwtE+IF99RQ5ORanXECPYQiD097n
   g==;
X-CSE-ConnectionGUID: lQY/+VfUROKxjDW7O9sxXQ==
X-CSE-MsgGUID: lUIM7+TfT6WWCh6sZu0PYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="79904381"
X-IronPort-AV: E=Sophos;i="6.21,208,1763452800"; 
   d="scan'208";a="79904381"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 09:29:34 -0800
X-CSE-ConnectionGUID: 17F3XXE4Sk6WAj35W/27Lg==
X-CSE-MsgGUID: 5uaTiUheTOKza1k5uuBZPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,208,1763452800"; 
   d="scan'208";a="234127015"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 09:29:34 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 09:29:33 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 7 Jan 2026 09:29:33 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.3) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 09:29:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=avQd6P+7pBENZcKzdFh/Ig7ssrGhEiVmt0+bAhxKJ9/ii4wUNuo1XiTpHmnaCg/gk8I2U/Jh8L/ZaJYC66xr4P4qUpPPSDET3NtKJ6cKQUklUdJwMR2QNGZRLtvYcF3UQ0JsLYUpRUKrQEOFJxWmkhAo90jdtVoNE284vTnjIqFSqFNXXqCpxMTzfhOvRbAx6S9LvQxY2Bh5mrKwK0a68AWcZ1r3HAgRjJwovUnszCxiR0guKq9FQ+ZrN8GfS7sT/tYmF9UNhmqEkqcuJQUlvkIxzWbt9+hQYLdT5UeQWJz6Tw2bvcWZuugf03UY1iXH+ybYvIk3fPHwRgljLAEXuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OtdA5isYbhhsqkQy5nIbdDS7Q+Vdcmw9sXg8M61WD04=;
 b=rnUYt6VnsNys6AIjKKhTP7TomT3yRJw0xYpQY7y9xfczMgpeDRnXl2xX+cJyz77Z3vJuuwpwCJ/t4zhkhdU+5fawVTMm1BH/lkY3lL+rkK0Nt79kwIdhMcwhgeyKmlz22UWHQ+ywvTpTA80Q+LZWMwU6Y8RaF/8Msfav2KJ8M5AgyPUzYOcc+jhYbbpJaMztSitnDKCJFJI2sUAdy8B5OqVsk62zYhrwKvLHW2+bnnWtS1UnocHl7bsZMlyaRtYB/KfX8TG2QUJ+WAZk7wKDopSdhjhf/4JOnsDgwAN+Mjrf0eBIj9uJFiUhJDeYDSZn05HeBBLwZ8te6R4OZuODPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB7020.namprd11.prod.outlook.com (2603:10b6:806:2af::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Wed, 7 Jan
 2026 17:29:31 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 17:29:30 +0000
Message-ID: <f3253bf3-6a3f-4cf4-b3fd-dc55e7bc71a9@intel.com>
Date: Wed, 7 Jan 2026 09:29:27 -0800
User-Agent: Mozilla Thunderbird
From: Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: [PATCH v17 13/32] x86,fs/resctrl: Add an architectural hook
 called for each mount
To: "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
References: <20251217172121.12030-1-tony.luck@intel.com>
 <20251217172121.12030-14-tony.luck@intel.com>
 <20260105191711.GBaVwON5nZn-uO6Sqg@fat_crate.local>
 <aVwTcX7V_HN2j6SW@agluck-desk3>
 <20260105200435.GCaVwZU2gFV3LhJnMR@fat_crate.local>
 <SJ1PR11MB60837B0B18CA663282190AE8FC86A@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Language: en-US
In-Reply-To: <SJ1PR11MB60837B0B18CA663282190AE8FC86A@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0202.namprd04.prod.outlook.com
 (2603:10b6:303:86::27) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB7020:EE_
X-MS-Office365-Filtering-Correlation-Id: 8edf55b0-be69-4051-47f5-08de4e125098
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RE5VRWhUVmVaSFJMb1JrbUFhYzJ1YVZUOE5XS1FENmxaYTA4MWxFRTE5b214?=
 =?utf-8?B?TTVlL2JrbXVBU1I4cnAzNFU5NnUyWUdUbDJWblB0Qzk4WlJEOTBjODdLb2NQ?=
 =?utf-8?B?TjQ3cmtwT3ErS0p4enB4ZkVjQ1hvbFFZTjZrSm8rVndESWNvUjNqa2IxZzR5?=
 =?utf-8?B?U2hXY0V0ZlpzM2tidTk0K1BiWWVwZExJZ1AvNW1pUktzcENFRE9TRkZxV29v?=
 =?utf-8?B?MEFQTDNjMXhmd0VRbVdTdHlBU0g2eUlvRmZQNnY2V2ZsY0tXNkhpeFljQVJz?=
 =?utf-8?B?RkZGZW8xajZOams4bFFYbXJ5VC9SYXJRSDkvOURXcnJaMmhaYVFBckhEMFMv?=
 =?utf-8?B?RWFQSGMwTGt2WGZpREFCT3lOQWZzU25wUHhlTDZWWVFLZlhEU3FRbitRY2pp?=
 =?utf-8?B?OFFSODQ1RTZHOWk5T2phSlFpZzVibnJMNFU1endLZDQrQmpDQ2U2bTVldEds?=
 =?utf-8?B?ODRxNUNIRk5xWGNpYkVicHZQaFZXdkw4Nm1lNXIzaHphMGE3V1MwL1dTZ0g2?=
 =?utf-8?B?Zk5GZTgwZHhyMm95SUpXdFpKYW14dHlveCt4NDAxV1ZnbnhvMjYrL1VEZE4v?=
 =?utf-8?B?eEVGeVhqanBTN1dwTElMY0JOek5uUGdXcmpoNnF6T2kvYXVkTnMyVW9FbXVn?=
 =?utf-8?B?d21sUit0UnlxeENKS1BzMTBLQlRiM3U3MUw3WHpmRWs5akpkSGZ1UDZmZzZD?=
 =?utf-8?B?WjNyVTRlWXJJYmhONkJxbzdmNy9QYjR1NlRTMndWZEtFN3dwM1BrdjBWOGox?=
 =?utf-8?B?V1JTRWYxOW1UTXBoZ29pdUNaWkxyQlhhdy9rOTJWcWRnQ3hCekdKTWgyYTdT?=
 =?utf-8?B?N0RLVXBuZURHcVQwMGt0QXQxSnFheHltOHVrNlF2SFE1RjJvZStUUzJiQVBr?=
 =?utf-8?B?MDdqd1FrcTB6Y2QxbXhsdXREM2JQS3ByRUdEWDBxQnk4QnUxaHh5RGtOSnJa?=
 =?utf-8?B?cUtJeDY1L0lTSGpLd2JCTHhmZml3a1ByQzhUUXFuNE9mdlpkQzRya2F6YTY1?=
 =?utf-8?B?dE5YdEVCLy9USkVCNTZDd1ZPeFk1THlzNFoyYVJVYVpKZUlKUDR1eS9mNDJz?=
 =?utf-8?B?QWFrMWZ3eUlNTUpmWW95aDMzWmJFcXNsYi9hM0dDRzc4N1Z5Q0kydzZlU2VG?=
 =?utf-8?B?ay9KV3NKNUFQZ2hWbDZCVUZsb29XOTZhcTF3cEJORkpLUDRKR1krcWx0NVZu?=
 =?utf-8?B?bG5KWU5LMjNnS0dYbFhRVEFnTVA5czc2QUZZMzh2c0k1SzE3ZkdUZjk2dkRX?=
 =?utf-8?B?Wi9OcnVDSFMrVWFxSlVYdEpPNmZJTkljbm1UMUJvTDEyWlFXcVlvWVFOWHh2?=
 =?utf-8?B?VlBKbGJDWmZ4bFdqM2lCM3hYZ0JpSjQ2VXFjT1ZLUkFMQ2ZyTXZTUFhrQWRp?=
 =?utf-8?B?b1NkTUJmK3BBcDYvZmlxV002SnNJUEc1dVdvYTNuOTBIc1FsU3pCaldCMEFP?=
 =?utf-8?B?WktQdmlDREE3NGo0RVJYdW5VNUJrNFJhRXVGUzI4MzhCYXRNODY5S0h3YTha?=
 =?utf-8?B?YVBJRGU5bzVmT3BLdDBwTjlpTTRTYjJHZHQ1WFB3TTRTek1mTkh5dDNRS0kr?=
 =?utf-8?B?aTF6ZEhxTUZFcE8zanA0NGtmSUs4QXV6T3BIRnIzT3AzVzdVQ01xWWorOVVD?=
 =?utf-8?B?VnZ5VjEwM0p6SlYvN0QxNElWMmVaSlBZUWFwQ01TYnB1aVR5bE5JdDVIYXJi?=
 =?utf-8?B?VVFzTnA1YnNYckpWMHRrOFV0L0lkRE1YWEtZaUoxbmlnUllPL2VVTXR4WTBh?=
 =?utf-8?B?NkZXd082ejNxRnYzT01EblF1QVBRTVJmRXphbVNjcVJ6ZUtzdEVOMG54Z0ZP?=
 =?utf-8?B?eERBUy9DR2kraFU2NHB2YndUTDRrODJuRGtBclQrbUtKU1RXMmlWeSs0aXg3?=
 =?utf-8?B?dWppc1Z5U0psVzN5YXVmdjJSajRGZkRIUStJN1poaFhwUEFocHExWGdiNHFD?=
 =?utf-8?Q?kmiCKF+UnAwvCk2iQBH+HoeDMNcMZq1J?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T2hseUhsRWNlUVhwU1NYL0hEK1dIRXNGdTlPd2NLK0swL1JDdkNaS2xhcXAx?=
 =?utf-8?B?NFZXamFTNzl0bUF1c2JXZnV1REREOVhRV3pTQnZoTnpVbXdGQTBDQlM3ME5S?=
 =?utf-8?B?Tm9ka09ZcXFBSkI1d1I1SmJ1T1hlY0FIYzVTZkg4VjZRK0JVbnovWURaTHVE?=
 =?utf-8?B?aE1GWk52ZzY0MXRGUDlkMXJoK2ltMGR5QjhsTmJvYkFuOXpzK1hHZE9tb2tO?=
 =?utf-8?B?VUdZMHN5NzZ5M2pyOUI3c21Kakk0cWNUVkpKQkMrSzVnRHppdGFtcHd2RW1B?=
 =?utf-8?B?LzJCeC9VbzJBS1p0VUQzZFV3cDZsNVlNdnlyR25QZmpRSFZMVjhTcDFqUDlv?=
 =?utf-8?B?Z1NzQ0o0TFFxU1hmbGxaNmpxQnZQc2MwTTVWMnRJM3I1eUxkdkhYQi9rRFJp?=
 =?utf-8?B?MVlXbzd4WG1INVQzREwreElublM0SFFvejVNUDVMTGRIeERFR2JkbWdNb2x6?=
 =?utf-8?B?NGxjWGtvL1Y3aTZFRXVEcmRxYTlxRnhjZ3hPYjFqcTJSMndEOHBGeFA3TkdW?=
 =?utf-8?B?S0FMYm1qbXlQaGZBSzhlWHVIc1piaHN0SnpDaEUxOHNEZCt3QS9yRXJLUXMy?=
 =?utf-8?B?cERDMDY0WVlpSVdkRXd1aEhuNmNWalphenJFMHVHWXZOd3JBcTc4amN4Yjgr?=
 =?utf-8?B?N01lK0Q3WnZqWHhqWnNCaCtGTXc0dlF5SVNiMWtEcUk2eHFLOE1sWjBXQjk4?=
 =?utf-8?B?TTBIdjhGTFFkQUw5VFRxcnJlWUZhcStzanNVaTRsQ0VHVFFtTjRZZmVDOWNJ?=
 =?utf-8?B?RUYzQzEzT2dSZFR6MThWVERVNDM4ODNJODZCKzdMSC9CLytkdHI1VzJ2OGJz?=
 =?utf-8?B?Q2dZWUYrZDY3RlJnUzhHRThjT2FJamZnWUZzRmZsVDdMVTMzV0NIMGtCVUVt?=
 =?utf-8?B?bGxuZlhkOTVzc2wzaE9SZlh2Y3o4b0VnUGliN0JhZ2o3NnJSSWpFUkN2SDYz?=
 =?utf-8?B?QUdpckJjdVQ1Z3JiVi9sQjlldFdxVlkybFJ4cTFXZGxndEI3NGhVOWt6Mzdq?=
 =?utf-8?B?U1h4dVZDL1ZTUmhkU01PdVp1SW1kdDlnQ0E1djcrVm8wTHQ1V0czZGZxUzF1?=
 =?utf-8?B?ekdoaTdHc1paeWNKbXByeDNQMG5BUFFJeXRTZHNoT21MR0YyTEhnaFRYZjZQ?=
 =?utf-8?B?WDBNNklEdFVic2pYQkY0Yi9VTG9JSjl5UU5HYTNTVTJpdkVmRFg2YlZFK2hI?=
 =?utf-8?B?OWgvSlBrS09lTzlaUTZaREVHQWxzWkNxWTdXMVRNaG5DTm95SzAwcDY2SnYr?=
 =?utf-8?B?bTJCZDEzM3htTys5STdLdjdpaUNqVFlmL2Y0Vm5ES1RYdnBCN1Y1dUhiNWEx?=
 =?utf-8?B?TGRiMDYxN0loQmN4U0ErZEh3NTN4cmZYM1RhdjlOSE0zRll4bTBFU3p0cmVs?=
 =?utf-8?B?TElMcU9wMnQ4NTZVeGZSaGhpMUUzcXJJd1VXWkNWQnNHU21ERGJBdCsxQURK?=
 =?utf-8?B?ODZBTTVvckFnV0YySWpLMjJ6Q21wckR1L3NVZk5pRllwVmwwUzhzSG90d082?=
 =?utf-8?B?S25kR3JNZ2FFdU4yeWVzUmJ2WVpxekZzVUdxUVZCSjhiY2xNa3BUWWh4bWVO?=
 =?utf-8?B?OXhBRmdUL2d2L1NWN3JJQUthQXg0N0M3d3lqZzZTTjIwbyt1OWNQQmVDbUJF?=
 =?utf-8?B?SFhiNmZwbWEwWk9Ua2RjanVVeHIvdmMvLy90M3pmNUFqaFZzem81WVRPQmR0?=
 =?utf-8?B?NVB1bTlmblBSeUdQOHhGYTY1RktTNU55S21vVkhVaVlLVlRJY1lCWU1WeWlQ?=
 =?utf-8?B?OHJzQXZpMlJhajdUOTNNeS9Rd2ZURjkwNDYvTGIwU2pPVklnQURObWpCUDk1?=
 =?utf-8?B?RXVwdFg2V0hENFI4MWRWTEpPWHZIZjg4UWVHSkJ1VzZITTRtWFJ1SDNveENE?=
 =?utf-8?B?RW9MdGFmWmZVdHZmK05Rc3RPUmwyUVlpT3hEZ2MzaUJ3UzN3Zm9WZ01tQUtL?=
 =?utf-8?B?RS9RZ3NTZjdCOXQrU08zWlRQM0ovNmVPVTNLWE9SMVNWMmJ0MVFDWEZLS0VY?=
 =?utf-8?B?cXVVSEdOOURzdUFJVW9SSkVOYWRFUlgveklGam5sbTBocmJtM09hRXBLQjMz?=
 =?utf-8?B?ZHZET2RwTzRQdkg4SW5hYU85WlJSbnhCcjlCeHJuUno2WW9KYW5uRURKdktu?=
 =?utf-8?B?ZnRsZ1JRMkZvdXZXVXVTMm9iTzU1aXVxQjJlem5kRitrZS9Udkh3MW1kemtw?=
 =?utf-8?B?YUVzeDRkTGZGM29zWVBUY1d0Rnc2RjRKQ1RIYUlqR0Zsb2tOVnlVOEpGVmNt?=
 =?utf-8?B?a0J3OGFWUlVvZU41TklpSHlhNzhWVy9NK0tjSnB5cG95SW92clVWejd3ejZE?=
 =?utf-8?B?VjluSnRUVHRFUnVUdXk2NFpSRW5DLzdjNDRXMEJRUzh5OUZ6akUzeE9hYU5m?=
 =?utf-8?Q?7DJ7mCprkk8pb2G4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8edf55b0-be69-4051-47f5-08de4e125098
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 17:29:30.6559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZBoPPBfe5v869JqIjmzAfODbZIMrPBy+eRy0AxmHneRxzT4VxOyh+ZT9aRdHEvvo7z9KV9EuuknhbeC65P2TwD8IjvFYe/XsDx2WlgZFazA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7020
X-OriginatorOrg: intel.com

Hi Tony,

On 1/5/26 12:15 PM, Luck, Tony wrote:
>> Ok, if it works and passes testing, I could wait for you to send me an updated
>> patch and drop this one.
> 
> Building and testing now.
> 
> Reinette: When originally developing this you suggested that rdt_get_tree()
> should call resctrl_arch_pre_mount() on *every* mount (to make it generally
> useful should future changes need something to be done in architecture code
> on each mount).

I'm digging through the history just to refresh on why I made that comment. From what I can
tell this work always called the AET init on every mount attempt. One difference is that during
v2 it did so by taking some extra locks before doing so, but still did the AET init before
resctrl's "resctrl_mounted" check. The move to current spot (before extra locks) was made in v3,
and looking at v2 comments I could just find a request to use a generic resctrl_arch_* helper in
fs code instead of the arch specific rdt_get_intel_aet_mount() called from fs code.

> 
> That flexibility isn't needed for enumerating telemetry events. Boris' suggestion
> to use DO_ONCE_SLEEPABLE() would revert to what I had in some earlier
> version where rdt_get_tree() only calls this hook on first mount.

I think I am missing something here - even the original RFC calls the AET init on
every mount. Which version are you referring to? I am also missing why DO_ONCE_SLEEPABLE()
requires a flow change.

> 
> Are you OK with this? Or do you still think that the hook should be called on
> every mount?

To be specific, the current implementation calls the resctrl_arch_pre_mount() hook on
every mount *attempt*. For the hook to be called on every mount it should be after the
resctrl_mounted check. This would change resctrl_arch_pre_mount() to be called with
rdtgroup_mutex held though but that seems trouble since resctrl_arch_pre_mount() currently
follows lock ordering of domain_list_lock then rdtgroup_mutex to match lock ordering
during resctrl init.

Reinette
