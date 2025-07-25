Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0218A25F997
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 23:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753486006; cv=fail; b=dA1Y9K97j+dOnHycLfZNLoBp0i+atOdys4HI4XC1qaHtmhXTBWqzoyi3XGG8wuAxh2zgrTtHk/YsytXjewbfy/9J5uPl79lotQmzIdFCsZrNiKoGPAxTPfiYzSsmQPeeFJjewUyVRcliT81OGLBLhF0mvNCHvQD/GTscb87EMxg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753486006; c=relaxed/simple;
	bh=VA0z97IB5EKwoAmk8Za4x/APwNFpolAZKJ60nfLmlwA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EGqWDOZn6zIACAZuLMlLSd7jejtAveJtKr/UqqPl/o1Zdt9S4mrpU4In8nYtpT9qnWK72KF4GmEc3PxQtZhuWM8qFkW9dnfOA1Z1RSyUKNU9fWl1LsOzKGqHqr3tmnVdwQWtdpMccqLa1aQ3L8W46mlhCQQseeFeYUZC8eWJW4c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nZgztzVb; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nZgztzVb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753486005; x=1785022005;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VA0z97IB5EKwoAmk8Za4x/APwNFpolAZKJ60nfLmlwA=;
  b=nZgztzVbZZd7+dqEBqSp/diNMBao3h2o7FXDa8IpGTZnKp4t2zliBbgm
   jgX4+hk9jh7jhc0jPZTjkz7wIlN3YWJSrvslizRSREW0ZpSpW44gWkV1a
   7IOjWMnqA6EGjr64+OC0tik7zZOD/nC8ta1vPx9dInqqxpoAQBMHDMTGa
   7OR5DYTtPvD3pcr8Vwnf+gspzcoxs4dkwYu+dme5LuWcuTBO0tpEDANJ4
   Yw65SGy8A+/YvHAy/uQgtCFbcc+y31Q4UJWMsp1dPdYAkwmhe6N54SN1z
   PGOo+DRM4I8vSdaWJtaV+NkZlQiLjZr8/j98ZzqelVdv/0WLE3vZG9ZsQ
   Q==;
X-CSE-ConnectionGUID: 1gpqcs6KRkajLYFI8xc48Q==
X-CSE-MsgGUID: zwFIJMtmQGKeX4OseMuVuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11503"; a="55922174"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="55922174"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:26:44 -0700
X-CSE-ConnectionGUID: IrSz5H70R4OqruXz+ALCVA==
X-CSE-MsgGUID: 1Qec9UsYRtS7z6ToQ70Lmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="162050959"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:26:43 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:26:42 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 25 Jul 2025 16:26:42 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.71) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:26:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i2ugt4G6whfWGv1cTnhUetBK3bGzkQbvUuVn7mUDCXEjniT3qx5MWKv750K7wssHlrZrGbDBwqIXRz0oWd2NjOmSRqfO2TK5/TAo/emJKSwfqFImYSbUMgVubxgjM7MZapVRS90CAnITtaN2K2b11jdA4nnXohXbAcSPX+UEj1EgrGkygMd0rTt3PlcHHr4V1Dn+GSJoLblM8OZUj3BOUlRJ7AZvgGfm+mOYSkwj3hVawyZhJPyBmLPv8BpH3FTIj3HSts98J9Blt9HhL+Ll1qvXynk76DXQ2BBkRdB5XUXyugrvk8k0WOiohLlYzFGx/5dx0XA8AVnz82KGj3ToIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pG1vnK1i+edjiYlf1Oiiy1K3edcJDDxErSj8saQR0ZA=;
 b=u+woMfbyt6hZSNpzO+R2F8JlLt+lI1mXyfLREpQkKw7z+hMQst6ianyja3psd7fnxNehSxMsfp14VXQQE6q1xUhiaUUJv83sZs6bTRuVTiXq/Y3iEVmVEzaxnby41qB6CTrGryJpJ+398lWMjoLXYosPM++aCSInak7QmPRhuXyFxB0OdiKEzlPjoXCadRLzBcM1xZhcYWAnq+VDoByxXtWaJ9DLhxCAlw8ot1vsU0sEr3ONEiffupLFhkCvyc+TX3fT6GKcnCsomfvJb7nBZd8n0o/43t5a7HmggNqwwdW5UzeDACJWB5Df65txnURBReFTJSeM1D5oFp+KQTCp9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA4PR11MB9419.namprd11.prod.outlook.com (2603:10b6:208:564::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.23; Fri, 25 Jul
 2025 23:26:24 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8943.028; Fri, 25 Jul 2025
 23:26:23 +0000
Message-ID: <fb14e6ff-02b5-436c-9825-1973bb8f2124@intel.com>
Date: Fri, 25 Jul 2025 16:26:21 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 10/31] x86,fs/resctrl: Rename struct rdt_mon_domain and
 rdt_hw_mon_domain
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250711235341.113933-1-tony.luck@intel.com>
 <20250711235341.113933-11-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250711235341.113933-11-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0072.namprd03.prod.outlook.com
 (2603:10b6:303:b6::17) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA4PR11MB9419:EE_
X-MS-Office365-Filtering-Correlation-Id: e8042ad6-8213-45bd-ea2d-08ddcbd2ab7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?N0Z5VFVOVllWcEY4c2pmdVpncVFmRStMK09jL0k4NnJHWmJ2VFVGYk1iQzYz?=
 =?utf-8?B?d0phZGlVUTNKWjAreU9HRDZTTGpCaEhUWDZmd2YzWm1IMVZRRGpLTEEvdXBr?=
 =?utf-8?B?azJIREpTcEpITUxtQ3k4Zk5xMlNNaWN2RUd0TXR5TzhkNFhaQ0NiNy9BeE1u?=
 =?utf-8?B?RnBhRDN4OCtISWJxSTRxd1owSUtKa1Byei9YYStCZFlxUkZPOEFZN2VmM29T?=
 =?utf-8?B?QmZsb3hpVnVWSTVMUlQzUkEwam1UYzdhZ1ZqSzF2K2d1VjFKd0ZwY09jdmR2?=
 =?utf-8?B?L25jWHdaeEpMbmZRRGEydVQ5dkdXZEluM2tZZGNYa2JQUDY1bGpUOHM0ZEIy?=
 =?utf-8?B?MS9HMnVMdS9JeVl5Mm5wZW9RVWgvNTA3THpwcEkybVZQdWllUEY3dWlrWUYx?=
 =?utf-8?B?cFRnaTRoQktDdGJCKzl1WGs0NWJ4aHJHRTdORTBqUHBZaGJmSnNWZkpaQS9I?=
 =?utf-8?B?RWszUE5KZmJ1Z3dvSFNtODJ4OEZrSVNIQ2Z4NXZIS3g1REFJblE5V3J0TzB6?=
 =?utf-8?B?Z0YxZE9QTUpHWkR0ZzBjbFBINEF0T1pkWUxZUDRlTEVQRVR6QUZVNjNibWdw?=
 =?utf-8?B?eFZ2N3lMU1hBME5pQmNkckFkWllEempSM2hYSEZtaGtyaXBMQUZsRDA5dTRk?=
 =?utf-8?B?ZzYvek1ORFpydnA2c0c0L1pwS3pZRnMwZHllaFBpWTJRM3JnMzVHUlRBNWRW?=
 =?utf-8?B?L2hZKzZBSHVEN0oxV1V2NHdmRTMvV2FmRVd0NWh3emVaZDlmUFZBK2xGdXVo?=
 =?utf-8?B?aTZGWUROYURHQUgvVnZsZUxyemE2UG5HYk9WRTdzeGRHK0YrOEdWclFOK1ZN?=
 =?utf-8?B?M3o3V2NKUGRPWlk2S054OVhXR2hDaWlOYjQvUzZLSFl4WlJDY0tITFFRSG5F?=
 =?utf-8?B?TlJ0Z2hFSjI2bkpGOTNzdXVSUDc3NGxlTUt3QUo2SmJPUEhBTWV1Mi9Mc3Bh?=
 =?utf-8?B?RVFmUFhsanN1TjdVYmFVNWtNeXhOU0dMeWxkSkRSSUlRWStCOXcyY3FVZkpC?=
 =?utf-8?B?ekhZOWsxa1pBN0hMMVc4ZjVKMU5DVjJwaHdPbXRyQ1I2dWhiTVJQdGpYOXdq?=
 =?utf-8?B?NGlPMFNQbGRVSlVZMGNLWmxJL3hxTUVDYmMrWVUxV2FSdmlya0lHV2J6bWVt?=
 =?utf-8?B?Tm5TYnZTNXdqZ2hKMWc3RDMrM0h0QXNuOUZNR2hTWEdCUmF6NDNzWTZMcGx0?=
 =?utf-8?B?eWR0MkIwbDRBbHZSRTJ4S1Exdzh2dUpyYllWeFNacXVwVHY5bWpsNEt1Uk5m?=
 =?utf-8?B?cGI0U0cwZHdva0hIYlFsK2FuUG1vbStWNWpWenNaK2JDd3h5ZnA4RXA2L0I5?=
 =?utf-8?B?WkxDdHBrVGJMUmlqN1Z3ZHNmNE0xY0REMURlcG43Q1g3TzhZYmUrRGFyY21m?=
 =?utf-8?B?TXFmUUlUaUIxakhYNHRIZ054UW8ydGRza2RwbFE2QU5sZmxndm9vb0VxdktE?=
 =?utf-8?B?TkVId1A3UTRrU1NSWHBvYk0yZ3RVZFI2Z1F0K0l1NmFJQ1lOeVl2Z25QcXhi?=
 =?utf-8?B?ZWdvL1J4Q1c4cHJtVTZxSEE4NkxZMkQxSUw2SFVZaEhvVW1TeWRSVVBSYTQx?=
 =?utf-8?B?ZkJrQ1pzLzFSUTZROS9GekxEUm4wb0RCenYzaW83WkNmZGNyZU0yckpuYTVK?=
 =?utf-8?B?NGtjSXNSa1I2ZWdLNDhEQkFHeWxZOURWVmpvV1gzakQ1TEJCeDAwNVFsK0lw?=
 =?utf-8?B?b2poWjlKMS9LK0pjSDU0Ym5idXM3NXNaVDVBMGlZU2VuUmN3L2hVVng3dUpx?=
 =?utf-8?B?czZyTDNISDEwK0dUQmJBTmVGTWczWGN5dzkzNXhlYk8rMG9sWFIxV3lVdUdY?=
 =?utf-8?B?MG0wQ1E0ekpyMWE2TUs0L0JTR0hRWUpFRG9GaGhuV29OSkwxd3JKclpQMWQv?=
 =?utf-8?B?V21EbkE4dm5OWUNJU0F1MVpmNGxaUVFTQ0ErUWVsd0pYZ05oc1FBZHVKbzdm?=
 =?utf-8?B?aUcwZ1ZvRnphQlpTa3M2aytxdjh4TVNOV3NmRTNWQ2w1bk9uMUlKMHFFTUY5?=
 =?utf-8?B?cWN6NzExckNnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eS9ESzVKcnAxZ09paUN6N2FiN3lIbDFqcHhQMnkvRUFCVWE5MllteDFQR2pJ?=
 =?utf-8?B?Wkw2S1U0Y1U0N1NOeHBsenB3ZU9VUHkwMVdObXVEWmcxOEZYeFBiTDVjTXV6?=
 =?utf-8?B?bUZRdWZqRG9lQTFjTklQc2FtWHo0Z2U3ZkZ5TFFyVW1PTkVzdTdwTWJ6dzZs?=
 =?utf-8?B?SUgxamtTMWNCT25CY1JwaExwdmVSeEFCZTBSZGhUYzUrNzloaDg5MmZUclBC?=
 =?utf-8?B?K3BEU0tCNS9YakhQTTJGWG9CcTl6WFBUUndNbmJGcnlvNENlZFRyVmdLaVRY?=
 =?utf-8?B?U1Q4YmdobW9jWkRKL2pvOGJJRVM2eHlKZGxBemEwMnpoNHhkWFFKQmdQOG9D?=
 =?utf-8?B?VGNIalBXU1IrMXRxUjJxZ0pLL3luVGhrVXRWWjhWNjV5RkMrTm1xeFFiZmp1?=
 =?utf-8?B?cHR5ZlBsa0kvNjFBbXNOZmdYNCtUczI1YlFOcHJBcENxc1Jvc2lpV2kvQW8v?=
 =?utf-8?B?c0tZR0lqSWpjbGZ5a2xrMHVOSlRQbHBWT0lCeStZYk9VSkR0Z1R2VVp2a01i?=
 =?utf-8?B?dFgwRDlxUExwTW94WGhQRUdlakRKcDJ0ckNOZEs2MllnT2IvNy9nWnZ1cVdW?=
 =?utf-8?B?bWI3czFlUTVET0NyUVFkTUxMaThuYzVHWVRmeHoxUXFCVFdsTGJvUkljTU5r?=
 =?utf-8?B?ZVZjRGtSQSttWTZ0ZnBTWEdsUlpUNzgxS3k1U1oxbEZoZEpkYWFIQ0c0Qkh2?=
 =?utf-8?B?TU5OZVlEUUxsbVgvbExTRXlObUNsQnlaaFJWZkZqaVFmSng1d2l2bFZwVUVo?=
 =?utf-8?B?dFhvdi9zZnBsdGNxOEM4SzhCc3pTNW1vYmdRSmdiQk01VWxmNjZoMTZOVDND?=
 =?utf-8?B?NjZBYTdVU1V4M0NpeWMyQXhzRG5HVnY5R0lEekZOVmd3endZWkFGdUxTOE9k?=
 =?utf-8?B?cGVvbTRvMDBIanVXb3FOMXBVQ053YnQxTVR6QzBUQktVQ0dJZUZUMUxLblFR?=
 =?utf-8?B?T1ZvV3UydEVmZHBEallWd3hTdnh0b2J1aXYzdWVPSGYwc1EyMitHOWowSHhH?=
 =?utf-8?B?S0xPYWJKSDlTV1B0RVpHYm1VTFJnUE1vMitBbStndnoyVjc0WUxWdnNnaWhu?=
 =?utf-8?B?T3U3RDhXanE1eGlzZjFyeVgwbzVCNkMvdGl6a0hPNlRoYURYZ3pvZ1ZSZlZl?=
 =?utf-8?B?dWpjajVnSEN0Z2d1L0hSZXo2UmN4K0hIdXJWbXB5akIrZzR0MjZzdW1ScmZV?=
 =?utf-8?B?RUZ2VWxGTXNpWVF1MVBnQnMzMGUrczZTbDFkTUlDR3p5SlRYYlgzZys5RTBw?=
 =?utf-8?B?M1o5UjUxeE1rZW8wQis2RWdyTmU5TFplT050V1JBS3FGa2trNjlMOXlQNXlU?=
 =?utf-8?B?ZVlkYVc5ZDZLaDVhMWExdWRWN0VXRmVGbkpKTkhzeGNTY0hMVVBGeEx4VnRT?=
 =?utf-8?B?ZzVTdEptWFhpbVNNNXQwN1B6S0hqcE5LaU82cnYwQjVVUkpObHdvL2MxM0d5?=
 =?utf-8?B?Y3ZyMlRUYmJudzh5aTU0VFpIV1JGNjNING5DMU9NTDZGT0g0bXFldFJCcGJI?=
 =?utf-8?B?a1VqdWdmaFJNOHlaVGVnQUkrcmJoMFE5elBkby9NWU84VVZ2WTlISmZacUdV?=
 =?utf-8?B?RjEzSS9FbE9JZ1d6ZEZRSDV6QjgxVHJZamlEL3J1aWw0aFVaUUY2Tis5Yldh?=
 =?utf-8?B?NEo2dzFCdUpLU1pLQnBWazZXYkN5N0lRRzJSNXhmSTV6L2ZNOCsxaEZ6bUJP?=
 =?utf-8?B?ckhGYnhsRGJ3TlNQRVlLeloyUndLNmJNOXZhelFMRW5NaU1jOUJZa3FXWTVV?=
 =?utf-8?B?UFkyek1rcmhOZ0EvWVpmRHZxTG5LYzF3NG5oLzd1b3l5WTYxV2JRZCtaTW1H?=
 =?utf-8?B?dXphNkQ1Qzg4aFBNUDgzTGtVTGtRQ2s3MUpQaGhGY3RrNHhhRlpHS1ZIblpR?=
 =?utf-8?B?S3BjR20zZ21oNU01YWczcTZQS2JBbE50ZXp1eW9uRGxGUkc4N1Q2MDB6c1dh?=
 =?utf-8?B?M09rWE82UmE3VjBrcHlsWFlDZmI3RlFCcWRrN2lkSmdwUWRBczgremVBbE5L?=
 =?utf-8?B?RkZ3M3AyNllpS0hLQURlMmJNQ0p3M2VXU1dUWTRLU3R6QmY2bzNlOHlQdUpH?=
 =?utf-8?B?STJ3WnYxdXc4TnhtWnp1eURTT2hnS3BIVllLL1pLUzFrNVlRTVRkRkZCclB6?=
 =?utf-8?B?WTdOU1RGS09VVW9GdlJWcUxkRHZuZ0FtcmtXK2xSWUt4U2FFQnZhVjRXWm91?=
 =?utf-8?B?eVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e8042ad6-8213-45bd-ea2d-08ddcbd2ab7d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 23:26:23.8773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WScP9bPDFhpdbT7zOE49kxeqaRAXlmTmjYRfJNlQJWntSl3ZBOlYZB1g/tI3yIRU79qy4pfGiqZcnLE1NotYFKf8Lw3pU+1U30qQm0RAybw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9419
X-OriginatorOrg: intel.com

Hi Tony,

On 7/11/25 4:53 PM, Tony Luck wrote:
> Historically all monitoring events have been associated with the L3
> resource. This will change when support for telemetry events is added.

Same comment as previous patches. Please keep context separate from problem
statement and write in imperative tone. You can review "Changelog" section
of Documentation/process/maintainer-tip.rst for what tip maintainers will
be looking for.

> 
> The structures to track monitor domains of the L3 resource at both the
> file system and architecture level have generic names. This may cause
> confusion when support for monitoring events in other resources is added.
> 
> Rename by adding "l3_" into the names:
> rdt_mon_domain		-> rdt_l3_mon_domain
> rdt_hw_mon_domain	-> rdt_hw_l3_mon_domain
> 
> No functional change.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

patch looks good

Reinette

