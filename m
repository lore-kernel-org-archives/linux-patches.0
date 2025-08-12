Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DCF2F90FB;
	Tue, 12 Aug 2025 16:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755016226; cv=fail; b=smzpZOCqLm1fXndEh6JX3Q5D1TnHp0nZnhlf6JXAu9Ow7622Ljn7krkQ92rwKYieNLh1syq6cXV0sLLyhFtR7ZArHrpeQDOCFdsODh7uo6cv989RiRgaxWadbzc2ASpCJtcsya7pqg5wsKIEGgBn9BWrP0K3LG0pV3lcGh+jvtU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755016226; c=relaxed/simple;
	bh=zkD0uhIsdtbNwQuoBx0Ytzf87Y77B71LGBqxHLIdegE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I8IcBqgqTPk8YpnzXp6Bzi6hSpShfa6cRSGIza8Z2E9hSJO2OC1EQgniMcq5HbdskGTo9ue3xBw5UikufY2EOiO1v72NhIKSIuQZNPP4DSr33B35FGz9x99ybHzRue3V0MZh5SNR2/6MnQTyawi+o4Jk9jvzNFZBVRABVw3HbUE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C6NtQh7s; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C6NtQh7s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755016226; x=1786552226;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zkD0uhIsdtbNwQuoBx0Ytzf87Y77B71LGBqxHLIdegE=;
  b=C6NtQh7sy4HcOIB/yAvS/DFnoMVug8uBWnOP1ITKG6GmU76tp6ccUYQq
   0NQDEZ4Go/iinX3uKL0D9Yu9E06AQ82jMEvTyuzz4PEVbclOESr0AiFw/
   O9CQ2XWfdn0/+eR0PG9WtL7Y4RTwhkmABjTEd6zFdLgVQoyGOxynzS9vS
   Ve6HGw/M1mXL6HO+KRPk4S20l7XTg6ID2o4HoMYteJIRl80Ii/Edul8Tm
   geYjm4Z+OCefDHb1jDj4IP1nB3gu8zbXMcrxnid3Tb3WovfwoVTnuj9ek
   qAM28f/iViYOWvd+6dkNSMBcg2lQQrxjBAUKw838FiMwR2SgdJsE2m8gB
   g==;
X-CSE-ConnectionGUID: CbyI6C1lSaGW7dQCPy2KqA==
X-CSE-MsgGUID: ezYkOHI7Q9qINQB9Bime+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="57011768"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="57011768"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 09:30:25 -0700
X-CSE-ConnectionGUID: TElDqL4eTuqPUTeRH8p9nA==
X-CSE-MsgGUID: zMbKu3kyQmemj2kslqkpZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="170441464"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 09:30:25 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 12 Aug 2025 09:30:24 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 12 Aug 2025 09:30:24 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.88) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 12 Aug 2025 09:30:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gwdliEiv6PE7hRb/A9bG0I+TAgPSNB4xvVm0hJNG1ffBU7lU7YQw6Xswg5QUv/vyRp8SYrzChLW0ev1BUJGaTN+ALrMl6e+i3lAbYhVcHyhZgDc/Q6M8RPYVBrl7BgR4GBt/CkeaY1wrjbUKrIK/1I18YjV5PUTPzhXP9p7Dpat7/afF4qHCh4KIrSOPRsn7zAcAT18L5/BroM/DNErIgRcwRKrerRbsY9wdqW33pGD9+HuoIN3JoyKpZhLWyJUEQhwEq2zTS9RqA51wR7i+RgfQtpTyILgCQmORjE15zVd/q8ttmOuksZ/D9/0fsHND9oHjPed/0XiLtCtlWW815Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=83D3D4h5kvDbOWoQrnOIG78ZX5P99SRbOvopQREJxhc=;
 b=Uzf43ArUOIX0+slDTCN1xIyz8ZR9f+YAGKSa3bE8Pb6vjZgse4b+1OmRSO0+eTXkTXd+Ec7TIyD61YXJ51Qiu790UnjZZB63I8xG6pZdRJC6bZWe3wGvkhShi9T/sruVDNUTwlERKDV12nvRDcvLusrQvIbxYiKujBc64TumQ53qcs9o5Zh8GPXiwaEEN/noTB32nyYR3i7uK5oo2dGbYSLi3AFt4JQmNG5f4fLRVTXeruqUu9+RAEhGEHyLsmNdGJ3ofpz/QZ2fGrTOZs72p7rP0LJIOeLp9zGMcwiQQ+LElz6hKG4mctSG34TAOYcq7JIrOJD+Ktn4l1Nqbc65Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB8718.namprd11.prod.outlook.com (2603:10b6:8:1b9::20)
 by MW4PR11MB5822.namprd11.prod.outlook.com (2603:10b6:303:185::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Tue, 12 Aug
 2025 16:30:22 +0000
Received: from DS0PR11MB8718.namprd11.prod.outlook.com
 ([fe80::4b3b:9dbe:f68c:d808]) by DS0PR11MB8718.namprd11.prod.outlook.com
 ([fe80::4b3b:9dbe:f68c:d808%6]) with mapi id 15.20.9031.012; Tue, 12 Aug 2025
 16:30:22 +0000
Message-ID: <adb1b558-124c-4f7f-b193-bf44a6132fa2@intel.com>
Date: Tue, 12 Aug 2025 18:28:29 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] hardening: Require clang 20.1.0 for __counted_by
To: Nathan Chancellor <nathan@kernel.org>
CC: Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva"
	<gustavoars@kernel.org>, Bill Wendling <morbo@google.com>, Justin Stitt
	<justinstitt@google.com>, <linux-hardening@vger.kernel.org>,
	<llvm@lists.linux.dev>, <patches@lists.linux.dev>
References: <20250807-fix-counted_by-clang-19-v1-1-902c86c1d515@kernel.org>
 <a9c64598-41e9-4ec8-8ec1-add5a5f903b4@intel.com>
 <20250811210906.GA924329@ax162>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
Content-Language: en-US
In-Reply-To: <20250811210906.GA924329@ax162>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DB6PR0301CA0074.eurprd03.prod.outlook.com
 (2603:10a6:6:30::21) To DS0PR11MB8718.namprd11.prod.outlook.com
 (2603:10b6:8:1b9::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB8718:EE_|MW4PR11MB5822:EE_
X-MS-Office365-Filtering-Correlation-Id: d890b08a-3790-436c-b21a-08ddd9bd889d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WHl3Z1RHU3hxTCtYQVo2WkJQcERmeURZVUZBVFh1ZFVtYzZUOUVWbkx2NHd0?=
 =?utf-8?B?VEtvWHZCdkNGWVVpalBGVkdmSmpPK1lmb0ZDSlp4cWNSRS9ZZW9vK05aaWxq?=
 =?utf-8?B?NjE5K2FySFdDaGhINU0vUktWQlhOUUk5K29BbVJyV0tZZFpCanZxRGk1dTJi?=
 =?utf-8?B?VCtCVlE0WUdmQVo0MjBabUR1OUkzVkR5N0NnQWxvNTIzbTJLUmhxaWpjZmR1?=
 =?utf-8?B?T1R1SmZWOUVKQVBxSUR2aEpVRkNZYm84M3IxQTlqaUVraDFrRUFlUkczcUJJ?=
 =?utf-8?B?VDZVUHQ5ZHM0b0FDU1FCUDh5U1dHNU93S2ZISWZqWHhIY0Rxb01uMVB1RkVK?=
 =?utf-8?B?Y1JMYzdoUGpUQVNWWGY3YVV5TmlITlRmYnU1b1diYzFFdUl3Z1FoZ25rdFB3?=
 =?utf-8?B?QUZiV0FuSGVpbzdqY3dzRzdLMTl3YWxuRU50eXQyR0ZtM2tqZHY4TGZmMnhq?=
 =?utf-8?B?MFh0WTc0QVFOV0QrdXZlMFN4cGlURG5ySE1pc2FlaU9CQm9ZcGVSUERjb0Rv?=
 =?utf-8?B?QUR1akliV09icUJTVWU5V3E5QVVCTkNwaVQ5UnFLY0t3Y0dZTHN4WE9OOVhm?=
 =?utf-8?B?UjNqVm5ackZySlQ5bkFSaDRYYmwzai9pY0JpL2Y2dFV4Y2o1a1QralJhNjhW?=
 =?utf-8?B?L1ZQYU94b1I5M0FjcFlTYklTeUJOVGluUVdCNmNLUGpjT3FtUk5iSXRsaXpp?=
 =?utf-8?B?VkZwNDVWd1EzUXNvSXlsdkJBeWNYcHlPK291REJ3Vzg1S2JyRm9URTc3VzVG?=
 =?utf-8?B?cFJ2S3BwSHlVOU9IOVFBSWF1OFVpY1dYL3o4Vjc5Uk1CZy9pOHdhcGFqQkFn?=
 =?utf-8?B?TDJBUnNpWkFaa3g5dUdxRHdIT3QvYm5abCtxVmo1TEFyMkJoK2xuRzE3ZWdy?=
 =?utf-8?B?UXJLaHgvaDcycklVYjJlS1JMbUVGdG12S2FONjFHQkhrM1gzTHVqU2NNcUxO?=
 =?utf-8?B?RlNkK3ZINUs0Wm8vS0FUZWN6MlF2Sm8zc3ZrWFRpczh5YzZRNUNIQXV2d2RZ?=
 =?utf-8?B?YkRaTDFxK041cHdJL3MxOEJsaFlIS2wyQ094cWRpSnNTbmU2RkM4NFFuTGVj?=
 =?utf-8?B?Mll6U3dqZ3MyUUUyRW5QZ1hTS3Q1c1dFUk5xQ0ovb3JEbEJwS2ZyZm5kMklK?=
 =?utf-8?B?cVNHQjNYSTBLUVFJejVpQ0loWjJuSS9KYTJuenFzbGtpaTFBUGxhb0M4RDlm?=
 =?utf-8?B?QjFhVDl5Y0tCL0N3M1lIR3VDdmd3MlZRVWRGNjZ2eEtYa0pBODZEVHhMNXdK?=
 =?utf-8?B?SkZOTStISS9xaVdGMFp5MnNqaHUyWTl3Rm5PTFNVRXB6M3NNd1d1MlAvZVc5?=
 =?utf-8?B?S3JBQzdlV1BhVUJXMFFGVkhXVXlDOVRTcUpvYU9zUWx2bjg4Y3FLaFJ2VTVq?=
 =?utf-8?B?NXFYODJYaFYzUHJ6MUN4T2J3UCs5TkJCeVY0aDNFU0RmZEw3MjB3TWVudzk2?=
 =?utf-8?B?RlFLb3dPY1l0SWVvaWo5V0dqTmp2aDlZUmRBMVlCbzkzb2hXR2hHeWJMOVhz?=
 =?utf-8?B?UlNnb3QySkV2M3dJZnR6NnQzUnNkQzdSTURRZnRjWjlaNVdZcUdmK2RJaVQy?=
 =?utf-8?B?ajdYZGEzSHAvcVZiNENDWXdJS1JZMGlJa1hhSUVCbzlMU3VzTTNUNERsSGNZ?=
 =?utf-8?B?d0Vzcm12bnpkTXRtdTNIK3NQTmhrWUtZeTIzaDd5eGoyOFdUVDNyeVU4Wkdq?=
 =?utf-8?B?eU1jYXIyS0ZucVd0WVZMVlR2VHpDdVRlWEZjMDlLWlZwMUY4dU8yVXVwWXFt?=
 =?utf-8?B?SHZaenhzSzR1V1I3NFJEdm1xbWNqS1BIdGNJb3AybmQ3Sk9LS2thZGl1dTNY?=
 =?utf-8?B?WlBiQ1Ixc1BwcTlDZWRvY0lCTU9ZWGVtUU11MFppMzFMUG5nK2lyNmM2TkFG?=
 =?utf-8?B?OUJMYXlOb2ZzVXcwZllHMTd5bzVWMG5CMk1DdDFxN2VSd0FVaHdHSHhMS1VQ?=
 =?utf-8?Q?GWR28KCV61A=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QlJPNjI3QUVvWUZVMDN1cGo2K0xlL2xiVUxPSU8vbmV0QnlPN0ROVnBTZnRO?=
 =?utf-8?B?bG9NbW8zZEpPeXpHcm5VZ2xrV2UzSEhCdDZ4RjA3Y1pNQjdxbTVEVzNOMFZ2?=
 =?utf-8?B?UGhQekZ6eEkyV1duVDVEakF2aEJoUGtSVlBEaVFTQ3gweVZpYWJ4WDlRWU9q?=
 =?utf-8?B?NGl5bjQvTERXRGY3N0EvWFh3eHFIQmkzZnR3a1RlK2ZiSmZPSUY0Nm5QeXQx?=
 =?utf-8?B?ZEtlRnlqVTBabGNZNVBhTWxqb0lQeDdVNXU5QXpsa3YxR0tlTGlDajJUdkpR?=
 =?utf-8?B?T3FDSnlicVljZmNrZDAvUjYrU2VIcThGTHVLamVxZFQrZXE3WSsrT3kyb3VI?=
 =?utf-8?B?M0pqQVBPNjA5VnF3NUhab2pKdFBWZ0puSHpWYldPMWo4UmdrbUxKckljdnhM?=
 =?utf-8?B?ZnpiaU5PZGx3ajZoQW5PRVdmZEdORUZPMFExZS82c3ZYNXBycXRvYzZiaFpG?=
 =?utf-8?B?UW9WTEVhM1hNUHZBNHBsRGl3ejVsUS9seSs0dkxwRzZlcjJGckNmZ1cwM2tB?=
 =?utf-8?B?YnpBVEYvZHhBbVdSK3QxeHJmWGxiSDhBQzM1T2lZOE13NXZhakp3RFV0alVE?=
 =?utf-8?B?cEZsMFBqWFAwZGEyaVNnblFlWldqanBCRE03RUhlY3Bybjh0WkRoYUwyTC9H?=
 =?utf-8?B?VjJxMDhuRkE3dmp6NHRETEV5ckpyTGFSSWxMNE1pQ2ZVR1VFaFppNzU2cWJL?=
 =?utf-8?B?SU1leG1UZVdJd3E5Vkg0d0xVeUtxWmkrdTJmSTgvMGhuelBlbHB6cmxhc0Fj?=
 =?utf-8?B?NEV5aG9XMnk0aDFadlprcnJNamJKbVRIRURDb0VwaGhLNFpoaUpMNTFOZkpp?=
 =?utf-8?B?UHhIODZzRHJRTm1SSHBabmRoRENnK0pnelRhUDcvbkxwWWt2MXBnUmUxNGRs?=
 =?utf-8?B?NElPRHQwQ2lBYm15K2NoR2grZEdMVXA2SVNWUFRYcStPaWJYdkdVa3hxM3la?=
 =?utf-8?B?OFNnelp6SmpGRmNDSFhSZDBqanVLNnI4WTVrdXNvQTdrenF5R2EyL0l6NWFs?=
 =?utf-8?B?eTcyRVNYV1oybWdpWDF3aW1LcGdrNkNiNWs3ZEZtZWpRd3B4amRsVTZwMXh3?=
 =?utf-8?B?ZGlBU3FuLy9PNFlZWklMc2tzVkF0R0JqTkNwMitmbzJJU0dEM2JMdE1hVDY4?=
 =?utf-8?B?Y2VnajJxVkNWMGxGU2RCbkpMYktBdkNDbUwvaW51cXR5MkRPU3dZcDBMNFo2?=
 =?utf-8?B?clY0T045aTVVR2IxbVA0RzRac2M3Y09TZnpXdnhYMFhtdVZlK2Q4dEtTQnp4?=
 =?utf-8?B?dXYrak9uZ1gyLzRlaXBlSVVzcjVJWXk5T0JEOVdKNm4rMCtZWnMrb3V2eVRU?=
 =?utf-8?B?SlFMa1NsN1NNMGJscVBzbE54bHd1OW1UWDFDM2xTTXZWNE9YRnV0bVptdXNY?=
 =?utf-8?B?cHdlN3VxbTR4dnhPY25MVmVmU3ZZSG4zL0NMdk9QUU8yVWV4bkN4Y0FieVp6?=
 =?utf-8?B?VkgzWklQSGJsaTFkSVpHa0c0RjRQRnFpQitzd29XTzF5cm5sL0NHczh4UDZh?=
 =?utf-8?B?MDcwSG4vR3NzeWsxU3NBa3B0OGtoWUx6aHp2NTNRcURsMlJpNERBT1RxTjhh?=
 =?utf-8?B?dndGMWJjM0ltZmk0ZkppT2FaNTU3WTVIdVloWDlXR3I2TXZ4SDg1YmtYYkl6?=
 =?utf-8?B?bnk5WHB0OXlWakN3T2JScXBmb3duTU5xQk1Pcmp1bUhycTVTTE42dlk5SStP?=
 =?utf-8?B?enljbm16WnRNYlhnYjlQQW5CdFlaSU41YzlPMEpPNmEvQTRud3FtMVpmd2FC?=
 =?utf-8?B?TUlFRzFpZmVwYTB5b0YyeGVsZUxqZ1hRbWpVM2JLMDRpd3drc0dxb0xlcGRY?=
 =?utf-8?B?ODhDMTdBdnNpNWhEM2p6OEFSR0VtdDdJbEhCcGs4eW5xVHVFVzUvNVJUVzgr?=
 =?utf-8?B?Tnl2MVVSK1pIanBBYStKMmNBSkt6YkNUdGIwelpHcG82WXhCNENNMUFKM1Ny?=
 =?utf-8?B?ZHdVZmgxSERLdnFhR3ZvZm9YeGxiOS9kM2RWY1pYdmRoUFhSaFhqVzZJWURz?=
 =?utf-8?B?M3RWQlI4dzFudFg5c1NJYkRpbnRkZHplNkM5OUJZS2FUN1JLbkZaUzhzMFdQ?=
 =?utf-8?B?N3BYZ0lqTDZlNnJ4VzA1SjNhSFNmdlB1bUUwSHNtRWIzWDRLSTg1ZFNEMHVh?=
 =?utf-8?B?WXpCTE9IbXZOcS9MTFZNNURBTkxnMmk4RHYwVm45SzdQQ0cvUER4VnlrWEtC?=
 =?utf-8?B?Z1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d890b08a-3790-436c-b21a-08ddd9bd889d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 16:30:22.2510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: as1GhABTrB8kEkWL9AKR+K+T4CEcyQo68wTk6YrPnAr5jC1Th0qY4lyMB4EAowp3YwIEk3c/USz2dNkI5DB+s6oQHK4qQioMLBbtl3z+gqw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5822
X-OriginatorOrg: intel.com

From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 11 Aug 2025 14:09:06 -0700

> On Mon, Aug 11, 2025 at 04:21:32PM +0200, Alexander Lobakin wrote:
>> From: Nathan Chancellor <nathan@kernel.org>
>> Date: Thu, 07 Aug 2025 14:36:28 -0700
>>
>>> After an innocuous change in -next that modified a structure that
>>> contains __counted_by, clang-19 start crashing when building certain
>>> files in drivers/gpu/drm/xe. When assertions are enabled, the more
>>> descriptive failure is:
>>>
>>>   clang: clang/lib/AST/RecordLayoutBuilder.cpp:3335: const ASTRecordLayout &clang::ASTContext::getASTRecordLayout(const RecordDecl *) const: Assertion `D && "Cannot get layout of forward declarations!"' failed.
>>>
>>> According to a reverse bisect, a tangential change to the LLVM IR
>>> generation phase of clang during the LLVM 20 development cycle [1]
>>> resolves this problem. Bump the version of clang that enables
>>> CONFIG_CC_HAS_COUNTED_BY to 20.1.0 to ensure that this issue cannot be
>>> hit.
>>
>> Any chance for this to go to the next 19.x (if it's planned at all)?
>> I always use the latest HEAD from llvm-project, but 19 is still widely
>> used across distros etc =\
> 
> Unfortunately not, LLVM does not maintain more than one branch at a
> time, so LLVM 19 has been unsupported since LLVM 20.1.0-rc1 was
> released back in February :/

Aaah okay, I didn't know that, thanks!

BTW 21-rc1 was released roughly a month ago, does this mean that 20.x is
already unsupported?

> Cheers,
> Nathan

Olek
