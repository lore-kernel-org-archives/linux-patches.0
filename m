Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD72372601
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 03:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749008577; cv=fail; b=fytzvDidA45ubtI2DAp6yDM8JuPSWn4/OpeJouJ8Uji+uOKhGevrb02bfP2ShHUwO9eCwBAXucSg2FGw2J8RDAHxVa4ri5IkiWrIOo2stsBq2PZfJlt5mq4hUcCKHXCxYPdAvCBRRiV46vMgC8R4XASE/cwOrFPijGNPedsyZcE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749008577; c=relaxed/simple;
	bh=egTV/Px4IQ1nnv+vHsNCQd3Qmrm6v7MKLdSuuCcsNdk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=C0RIo7mpGIEkrKJ9iP6SOTnOxYjqKx52LBeYfkvLmjttGStZAl0h6XaQluzV76hzINol3UXav97tU9n9qen9hjzs11faGWOcP6jKS1L6q0n6cUZB7xS3jOb5qgl4S3wa6dm5RH1rTVGeP/OT9zs2w3621bNaaGaJZInqGjhWNk4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fFYbId0d; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fFYbId0d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749008576; x=1780544576;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=egTV/Px4IQ1nnv+vHsNCQd3Qmrm6v7MKLdSuuCcsNdk=;
  b=fFYbId0d0KcWSHiE88rvt6u+/Ag7PH841AVKaXaQx/0Lc63U/nmEjAlp
   VKuHkEQcIEVm0n7yiKEgThNU0X3Ej2fbC/kAEmu8T5fqiX4VYG/f6zqf8
   0WGDWgbHVjta/k2LADKVZhFqVnKRnDi1T73rS13SCtjKK3aGnsjr/qPdV
   kbAjz7eznsWtBCFnptC466IO7nHtOnwXgNAaOmZe9lHOpsjIHjDqHxp9Y
   KH/lEHBcvmcCRqkpvLABorXA77zM6z1md7+CMuX42KkbloiGU2e3h4sEg
   qFXoEMPMQo7h7+44QsrwbVI2AAsAMP8JGyMPKInXZHuFK7kBupA5qWOYm
   Q==;
X-CSE-ConnectionGUID: 2BDaq97jR46dfeyuq+5gAw==
X-CSE-MsgGUID: YqvT+y+/T6SXY97T0NxXfw==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="61693771"
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="61693771"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 20:42:55 -0700
X-CSE-ConnectionGUID: aTvpGrKLSry962BrjnVeZA==
X-CSE-MsgGUID: /VtiYP+5TEyqpYC6DoETAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="144925385"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 20:42:55 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 20:42:54 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 20:42:54 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.52)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 20:42:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EzjP/SAhK6fMEnTR76ADZ+lFNh3/KFg8RC/8saM7Jq9rVfAIvNx8Rhb//QVA4Z+0O9B03ekgWV+REkGIM4urXPgN+kbm0OfBMCeeAvwu0UbuH+p/70qizNbQCwyLmlTfo2UhpxH+0INYUfb5eFVY6C22HLdOi+vrVewGyrSn+8co41mGqR+GAvRyHfaQ1nr1yGfoHDuSLO3Ulr3C0ijCw1SuslTxOudvk+nX1+juAVmzasa2fAOpeVNWYF4NoRQUEXnFeDYxHghIfRDwYBcSRfaSZKD9eiiZD72MBzmh/wUJhq0/x2AZ34uLOzKcRtWOUpp9B8tNwadgfELak6QYFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DPswnT9J69OSr0BB//2FN/BYp+95K9vASmHBgNNA1Ls=;
 b=asAMhyh9LksHAYULA6wwO1kw9ymACPg5f2Gyp6a+kL7EidcgnfHN7Tf0zf3f53SCeHIzNroyNgGL3HcMen7XXf1PemFUkfRxg7ujVOwqXUawnoKFeyu8yMsfsBP6n0hiIU/0X9CmCvVSLtNiqXYwSXOhyzX4FMXXVLBM1nz9BR6tAR7eSz6kVs3HU8x/St8XSDroXncjTyM8rEzNJbcWEUWvY6RC/GW7EMON8P+D1DLXKnpWatWUTmQod4AMV+7kY7M6B+KfG16buk7mvUHF7RlqS9i6ldLb4lkxzsDbn5aXJY5er/MUpGdnhH1GJRVe0RbYLs+/xxQektJrRioOjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ2PR11MB7599.namprd11.prod.outlook.com (2603:10b6:a03:4c6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.36; Wed, 4 Jun
 2025 03:42:39 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 03:42:39 +0000
Message-ID: <e0320c8d-8bdc-4d8f-a165-b3637730163d@intel.com>
Date: Tue, 3 Jun 2025 20:42:36 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 13/29] x86,fs/resctrl: Handle events that can be read
 from any CPU
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-14-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250521225049.132551-14-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CYZPR05CA0037.namprd05.prod.outlook.com
 (2603:10b6:930:a3::21) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ2PR11MB7599:EE_
X-MS-Office365-Filtering-Correlation-Id: 42d02a6e-208f-4099-b8c6-08dda319da54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?V29ZS0ZNTmRJTGl2ckdFd090RkJPZi9pM0piWUZhTEJBVUlDRDZYRWt1TEIw?=
 =?utf-8?B?T2tBVnlDRzBFNlFyaC9XUVJzWWhPNW5VYm9lMTdIeVJmSVJkQVZqYXlrYkJ6?=
 =?utf-8?B?ZjB3OFNWeEdYUklNU2p6VUVpQTJIclhObThWaGI4bHljdDlQcXFzV1czZWdi?=
 =?utf-8?B?enJUdTN0c2RSRHBsVmNUTlRZQnFtQzEyQVVDaUhXYzlJa25TSmlJQW96bHlZ?=
 =?utf-8?B?amhyL0Zvc05MeGR4cVNId295S3VmVUFxYTdHanAycy85RUwzdzlsM1A1K1A5?=
 =?utf-8?B?KzlXTmRnMk9nSkFZdUNGRHdicTlvZGliUWswNldBL3dmWEZxVzJOWnRvL3F6?=
 =?utf-8?B?TjZZQmVFMUp5bWJPbE1nU0cvenJHZGRLQVdNVHYxWmZiSWZlYnY5VE5pSXZi?=
 =?utf-8?B?eUUzRGg4My93cm83OEZGRWlpb1ZJT3hqb3BxdWZoMVQwU2Z6QnhaeVhjdnEx?=
 =?utf-8?B?M0VIc0paRkRuc254bFBSeGVkMGVXVEJOSEpNRnZzejgrWCtCSUh0MGFtM2dG?=
 =?utf-8?B?K1BPMHFZTUdwYkgzUXk3WnV6R2ZibGNrdG4wTkFRS2tyQjh5S3QyMVdjSC9i?=
 =?utf-8?B?MEtSYStKbjBrdlA1VzlOK3ZMM3BHckhNV1Mwc25td3gzNkVGQVhxUTZrT2VY?=
 =?utf-8?B?WCtRWjNxQjZFamM1VVZWTHJ1bDJDNW1QaFE3RXJOZGhHc0lYUlNDWjh1MHZJ?=
 =?utf-8?B?NXQ0MXpMQUdxaDVVYStOb2UxWVV3RE5lMzVMOVYvVnBEZmJqWVIrQXd1NWwx?=
 =?utf-8?B?KzUzREg4bHlkUkpXeEJxbXZ5bzE4TjlveE5CbVhZVFd3QUdHTDhvTHFYSlhY?=
 =?utf-8?B?NWtaUENnOTQ5K1RsblZYNFZtUE85QnYrZ2pHaGcxRDM4Q05VeXZ0akltOVhW?=
 =?utf-8?B?UEZvZHdNODUvaEJUYlJ2N0VucUVIcG5Xdkw2ajN1d2Y0NzQzMjlaOWNUb252?=
 =?utf-8?B?UFMxbm55WjVETUFXcFBVUnZpdW1ZRnNVa0dCOUlXRmZYZFRncGllWjR0L3Zq?=
 =?utf-8?B?QkdqK0t3R2JjQ1lSQlpteUN1bWJDNGJzdFA1OHMyTWFKeHNucUZxeEEySytP?=
 =?utf-8?B?WEdMbmxZaXdLUXh3SFNRSzV6VGQrTUJJTHZ3K2x5QTBCdjlZeHdTOXdOLzk0?=
 =?utf-8?B?dG5pSURBdUt4cjJiM2QwQm5HS0VnWDR3YWtHM21yYVQ4YVVpRWpyN1JQVWZk?=
 =?utf-8?B?ejA0bHVxQnRIZzdiaU5tTTNSOUM3NXk5bFdTeWV6aG9xMTNiNEtBSnZWTUNL?=
 =?utf-8?B?U1d0dVZuUngzZ0hkdmo3UXYyU1B1Ny9nVFZFN3RjZmx2YzlTL29yc3lyajl6?=
 =?utf-8?B?RWVrNlNBblR2dFdXRkNkVS9EaSt2U2tnQ1RTRlo5V3hiN21LMFlnY2xpcmtK?=
 =?utf-8?B?S1Y2b2t0ZUtVUUMrNGo0QnpsWDhJeHozWVdxcWJZeWlldnFJODZJcG10SDVO?=
 =?utf-8?B?TFBBM0wvaGZKZmp3RW1mWlpUV0J6VmtHTkhORTdIYnF4NWdlK0xFSXNBWTg0?=
 =?utf-8?B?Z1kxT09uUnM5WXZ4NHdiQVYwWENmUDhXaTFOUzd5SWFURXFCWW9naUc0cWVi?=
 =?utf-8?B?NytGYUUyL3hTUm5YR1Rxcklxcy9wZ1J4OW02MDQvaVl5dzNSWG1Xbm0wY1Vk?=
 =?utf-8?B?MGptY2xxOXByaTN3QVc0QWZCTlJPSTFuZll6RW9VcEc3WG8xSVk4NXU0TXBG?=
 =?utf-8?B?TjF6TThhK0JoOEVPVEMxVENJOHBneU0xVUg1YzlKNlNtNm1nUnV4RDRMQ1BB?=
 =?utf-8?B?ekJyZ254RGhkVHJSa0RaT0dnaGJ4Tm5lcGxBQ2xvUzRIYitGL3dtd2g4alht?=
 =?utf-8?B?MFY3ckNZdWZHTlhzVWJRNkhZOGYyTDBTd2RZVHpSMHZ2OXEvZHF0NzZhY083?=
 =?utf-8?B?ZnFrcnZqNXlYaXE1TUhPZE5MYlp4SWpWRUgzeElDQVpZaDl4VkpiVFdiWnVV?=
 =?utf-8?B?b3RoNHZNbk1QU3hsRjExbTNKbHZUc1Jad2VUQmdMTkRDWnJTTUxkbDJnZ05L?=
 =?utf-8?B?Yk5HdzJIZ0J3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?am1aVTkwMmtQcEpJSk5PVTJYRWVPU2dIS2I4ZEo3QjdQNVM0Ukt6MDYybEg3?=
 =?utf-8?B?bHg4ZnQ5dFhFaFJ2cXBMZGZFRlhNWThSUGxRMzNwUVJKb2UvYmUrZlovY3dm?=
 =?utf-8?B?Z0RVTmR1amsvMWtSenQzTlhVc0RFNWdacFpxYXNnTlo2YXgrMk5xaThQeWth?=
 =?utf-8?B?Zm5SN0VnTjdlOVJKKzg2T3R1ZkNWM3hoeTFXdEpMK1c3ZXhLdy8zaEM3dGlF?=
 =?utf-8?B?ZkpBQ1M1UTU3bVBJc21uZkJiTDBMRW1hS2ozREtTckQ3cWVzMU9GQlNaN2Nr?=
 =?utf-8?B?eEpNVjNjU01oYUdqc1VKWnB5VTlWKzhlaDdXUDJaRGduYUpEZC9JRjhyNndH?=
 =?utf-8?B?M0JQckYxRWFnNjRQb1dEMHYwVVR1cllFbnlCTnRpbzJ1VGRGVnFGV3dtelRy?=
 =?utf-8?B?Mm9LdWZDNmdZN284S1lzTWE2RDhQVnBZMldvdUJ0aU5UdzNHTlBBUHlOdDMr?=
 =?utf-8?B?TG5zMG1EVXRnVFZ0SENYRjkyRlBzQWVsN05uRnhVaURMaDZRWGZpSXJQWmpz?=
 =?utf-8?B?Tjl6TFBjYXluRkQ2V3pYYjc4R3ZsU1FoeTMyRXZIRDIvT2E5b0FCcTQ5MVJo?=
 =?utf-8?B?RXI2TGJKUTJwQTNCa1RsZU55TGFRSVExaktIbEFGSHU1MGVyS3poSUVhZ1VQ?=
 =?utf-8?B?ekkwMUVBTmV4YXRIQkJyVWJHQlR1VW9NejAvUThMK290N0x5MEtHcVZ5RGxo?=
 =?utf-8?B?OCtzeDUvY3NYcFh2S0RpUEU2blhXSWRJQmI2MVRleTJ1OFhjVjZ6YWdSMlVu?=
 =?utf-8?B?RUxGNTJtQ1hNUXZnVk91ZXAxemY2ZUNiZGkvejJJcVdIMGJTeFIrL3NoRmNP?=
 =?utf-8?B?dUczKzVKZVBMWGRGQ2RCS2lBUTdJdUpKUTg3dVZyc21id3p1R2k1aXM2dCtB?=
 =?utf-8?B?WDVCRGtlMFp4UENwL1d0WU9iSW9WSFk0ZExJeW5PZDV0UFErQVZqN0pyRSs0?=
 =?utf-8?B?WjBzaXNDa3k5cWFFeUFJbzJDeTFtcjBNUnZhSFBMZDRla1o1c0liSU4yV240?=
 =?utf-8?B?aUZYRGpvQlVWUFpGV2xpamY3ZTU0eWlYMUpra0k2YXd3a3ZIQUZScjUzMmtC?=
 =?utf-8?B?czZyM1k1SEd6ZmVTdmFlZ3V2bDdoYjNiTW9wM1FpMFVYWDd0SEticmlXbzV5?=
 =?utf-8?B?dTJiZTRiRW8yL0s5N0I5d0FvUnkwUnFValI2bHo1d0tsKzVQNmFVeFV0WVF5?=
 =?utf-8?B?M3NHdWk0bDI3UzhxSU9MbHU5Z2xrbkVlU0xyU01sVHcrdFJ2aUN3ZjM2bTlD?=
 =?utf-8?B?cnljUmpXV3NBanIraEhsQ0ptTVNIZUQ5Vzc5bFcweXRPRFpWMnJvQzc3MW0y?=
 =?utf-8?B?U0hJUXpsWkE4dFVTN3Nadk4xTURQVnhMN3I1OTU2VHREam9EOFlxVFlqL1cy?=
 =?utf-8?B?Qk1hYjVjTC9aVjZuZ0RSV2JPTmMxTHV4dHFZaFdTQW9mZlZtNTF1ZnQ2UHlN?=
 =?utf-8?B?aXF0VSt0SEpldUVDOVNyYzRHSXNSL0lBMHJNTG0wNlB5U0sxTWJ0ejlkUUlS?=
 =?utf-8?B?QlpJMzRUL0tpb0RvVURvNDJid2kxdmIzSWpmd2k0eW9uZ0Z3SEoyWGFmRy9X?=
 =?utf-8?B?UXZ3VThUaitlMkJUUU8vR1VxSkVXMFdnTEx2blZ6a0VtbUpsOWVrc3JJcDlS?=
 =?utf-8?B?OWRiZ29RYmNSVm4vZWtJcFdwbVpTdnQ0YlBuRzFhZnBDVHhNYktNMGZTTjYr?=
 =?utf-8?B?RzVFWDVoQmtiT0xBNmhiRkIwWC8vY0c2ckFrL2lrcHNRSlhJa1M1NEU3b3pC?=
 =?utf-8?B?QXA4dTFzb2J3WFVoQ3FlcHd5ZEd5ZEp0TTh2dEdQNWtvVGRsUjdaV1VkdXJv?=
 =?utf-8?B?QkRGVTlDVDkrc1VmOTdJZWxHQ3hmQ2tLWjF1QkIrTHVlbU5OZ0xmLzFhYUJk?=
 =?utf-8?B?OEo0bmE3d3BBamorN2R5TXN5R1lPNk4ybjRvU0RIc0pRUm41aEc4NnpielVN?=
 =?utf-8?B?ZzlVd0NPVXlEbndYOFdxRHhlOUFJYmZnTzBZWXp0YUtpMUZLZjBQSTBqQmhY?=
 =?utf-8?B?cjZ6WkZqMDZpanp3b2FhM0hONEJLWERkdlZqMDFJcE5Cck13UTlnbGp5L21S?=
 =?utf-8?B?TTFPL3ZxekZCaGV1OGRVclFjb2x0ZFZlUUwwUjVNaHRWVld5QVZlMDlPS093?=
 =?utf-8?B?OXRxTGhaWjY3ZWIxbkdmbGRDSGFTb2d3ODVkZm5SOGNxOENjcE05RXQ2Y2Ji?=
 =?utf-8?B?OHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 42d02a6e-208f-4099-b8c6-08dda319da54
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 03:42:38.9821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L7OTi8sdzkv4ok9RdB2G9Kl1MPN+xgr+JkeFE6MyVZs0u15oqkCD28c6D6lxdI65ltkrlOvl+GeKfcB+nq04ckFTZGLdwE+rsqfk9meiUaQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7599
X-OriginatorOrg: intel.com

Hi Tony,

On 5/21/25 3:50 PM, Tony Luck wrote:
> Resctrl file system code was built with the assumption that monitor
> events can only be read from a CPU in the cpumask_t set for each
> domain.
> 
> This was true for x86 events accessed with an MSR interface, but may
> not be true for other access methods such as MMIO.
> 
> Add a flag to struct mon_evt to indicate which events can be read on
> any CPU.

Since struct mon_evt is per-event, how about:
"Add a flag to struct mon_evt to indicate if the event can be read on
any CPU."

> 
> Architecture uses resctrl_enable_mon_event() to enable an event and
> set the flag appropriately.
> 
> Bypass all the smp_call*() code for events that can be read on any CPU
> and call mon_event_count() directly from mon_event_read().
> 
> Skip checks in __mon_event_count() that the read is being done from
> a CPU in the correct domain or cache scope.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h            |  2 +-
>  fs/resctrl/internal.h              |  2 ++
>  arch/x86/kernel/cpu/resctrl/core.c |  6 +++---
>  fs/resctrl/ctrlmondata.c           |  7 ++++++-
>  fs/resctrl/monitor.c               | 26 ++++++++++++++++++++------
>  5 files changed, 32 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index b7a4c7bf4feb..9aab3d78005a 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -377,7 +377,7 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
>  u32 resctrl_arch_system_num_rmid_idx(void);
>  int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
>  
> -void resctrl_enable_mon_event(enum resctrl_event_id evtid);
> +void resctrl_enable_mon_event(enum resctrl_event_id evtid, bool any_cpu);
>  
>  bool resctrl_is_mon_event_enabled(enum resctrl_event_id evt);
>  
> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
> index 085a2ee1922f..eb6e92d1ab15 100644
> --- a/fs/resctrl/internal.h
> +++ b/fs/resctrl/internal.h
> @@ -57,6 +57,7 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
>   * @rid:		index of the resource for this event
>   * @name:		name of the event
>   * @configurable:	true if the event is configurable
> + * @any_cpu:		true if the event can be read from any CPU
>   * @enabled:		true if the event is enabled
>   */
>  struct mon_evt {
> @@ -64,6 +65,7 @@ struct mon_evt {
>  	enum resctrl_res_level	rid;
>  	char			*name;
>  	bool			configurable;
> +	bool			any_cpu;
>  	bool			enabled;
>  };
>  
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index b39537658618..5d9a024ce4b0 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -880,15 +880,15 @@ static __init bool get_rdt_mon_resources(void)
>  	bool ret = false;
>  
>  	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
> -		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID);
> +		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false);
>  		ret = true;
>  	}
>  	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)) {
> -		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID);
> +		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false);
>  		ret = true;
>  	}
>  	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL)) {
> -		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID);
> +		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false);
>  		ret = true;
>  	}
>  
> diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
> index dcde27f6f2ec..1337716f59c8 100644
> --- a/fs/resctrl/ctrlmondata.c
> +++ b/fs/resctrl/ctrlmondata.c
> @@ -569,6 +569,11 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
>  		return;
>  	}
>  
> +	if (evt->any_cpu) {
> +		mon_event_count(rr);
> +		goto done;

Please see earlier details about goto in resctrl. This can be "out_ctx_free".

> +	}
> +
>  	cpu = cpumask_any_housekeeping(cpumask, RESCTRL_PICK_ANY_CPU);
>  
>  	/*
> @@ -581,7 +586,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
>  		smp_call_function_any(cpumask, mon_event_count, rr, 1);
>  	else
>  		smp_call_on_cpu(cpu, smp_mon_event_count, rr, false);
> -
> +done:
>  	resctrl_arch_mon_ctx_free(r, evt->evtid, rr->arch_mon_ctx);
>  }
>  
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 3cfd1bf1845e..e6e3be990638 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -356,9 +356,24 @@ static struct mbm_state *get_mbm_state(struct rdt_l3_mon_domain *d, u32 closid,
>  	return states ? &states[idx] : NULL;
>  }
>  
> +static bool cpu_on_wrong_domain(struct rmid_read *rr)
> +{
> +	cpumask_t *mask;
> +
> +	if (rr->evt->any_cpu)
> +		return false;
> +
> +	/*
> +	 * When reading from a specific domain the CPU must be in that
> +	 * domain. Otherwise the CPU must be one that shares the cache.
> +	 */
> +	mask = rr->d ? &rr->d->hdr.cpu_mask : &rr->ci->shared_cpu_map;
> +
> +	return !cpumask_test_cpu(smp_processor_id(), mask);
> +}

I find double-negatives can trip people up. Having function name contain
"wrong" while also returning "!" can be confusing. I think this will be simpler
if it is a straight-forward utility, for example, "cpu_on_correct_domain()"?
Maybe even "current_cpu_on_correct_domain()" to be explicit about which CPU
is being checked.

> +
>  static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>  {
> -	int cpu = smp_processor_id();
>  	struct rdt_l3_mon_domain *d;
>  	struct mbm_state *m;
>  	int err, ret;
> @@ -373,8 +388,7 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>  	}
>  
>  	if (rr->d) {
> -		/* Reading a single domain, must be on a CPU in that domain. */
> -		if (!cpumask_test_cpu(cpu, &rr->d->hdr.cpu_mask))
> +		if (cpu_on_wrong_domain(rr))
>  			return -EINVAL;
>  		rr->err = resctrl_arch_rmid_read(rr->r, rr->d, closid, rmid,
>  						 rr->evt->evtid, &tval, rr->arch_mon_ctx);
> @@ -386,8 +400,7 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>  		return 0;
>  	}
>  
> -	/* Summing domains that share a cache, must be on a CPU for that cache. */
> -	if (!cpumask_test_cpu(cpu, &rr->ci->shared_cpu_map))
> +	if (cpu_on_wrong_domain(rr))
>  		return -EINVAL;
>  
>  	/*
> @@ -865,7 +878,7 @@ struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
>  	},
>  };
>  
> -void resctrl_enable_mon_event(enum resctrl_event_id evtid)
> +void resctrl_enable_mon_event(enum resctrl_event_id evtid, bool any_cpu)
>  {
>  	if (WARN_ON_ONCE(evtid >= QOS_NUM_EVENTS))
>  		return;
> @@ -874,6 +887,7 @@ void resctrl_enable_mon_event(enum resctrl_event_id evtid)
>  		return;
>  	}
>  
> +	mon_event_all[evtid].any_cpu = any_cpu;
>  	mon_event_all[evtid].enabled = true;
>  }
>  

Reinette
