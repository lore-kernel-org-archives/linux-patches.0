Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514111E376C
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 10:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736244104; cv=fail; b=m2un1O8Aey89T6+LCghx9os6NErzXmW6FJ2Lm/QfvDPcvuSb/I8lGqULqOctdhVNQmOspXyP4D7m3yZyPkZieLkD35U5YE0kC7v5bVSR2Xmz0cPuse4O8HDy0DFa+u6WqplWlwn1wq5sFsBsFoSa/TQpTDouJ/I0qPkepp4iNJc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736244104; c=relaxed/simple;
	bh=wzCkdrUUN9HUZPSR3nbeIqlLMtspdrLvegOo3g2spd8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pHBMpYDbwdNkbVms7o6nfFHJZAj2b03atfyKVm6a/Z5oUqaE6VCXLnqn7zG5/0JuJeiWdT1FPzfj1Y8WLy+bZIP2GiAj3VsAHhJQQyo70nxzEPgBmV/Umi/OvhX2Wjmxcf1ZfPpkCLoby4bw0wAta0lbYtFQRl2zpPEKHRji2Xc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YXhMy9lv; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YXhMy9lv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736244102; x=1767780102;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wzCkdrUUN9HUZPSR3nbeIqlLMtspdrLvegOo3g2spd8=;
  b=YXhMy9lv8TyJbcO4ZO6khuHgZ0qhkhmhtXJVVXTpAuDQR8XO5b42tc2P
   9ya1TxyIqZC2B0JBc3njS3V+lp+q6L6tsTwoS9nB5CPnGRCLD09z3e5SM
   8A/P5R1qk0Oz5gbjmzSENEf+0lu4UY38vr/7VnA4ZYqmDUJ68iL2Taq/K
   m4hbqLTM9dbLh1LJp45+Ef3bH2iLmPJU4QSO6BCJSEUGMAbY2xnL5EgB6
   PfDReftkwbYTqISCpxfMbg0CxzT7l4w6yFlB5/1vTL7gw/o4qKFFwMzPb
   XHC8d870Fomyw7mHtZdXg6NW6rXVFHtbLTCPzn3NwgU5IfBwWVuGGONFh
   g==;
X-CSE-ConnectionGUID: btCjEBGzTxq7m/u5Mn+hEA==
X-CSE-MsgGUID: 7cs86mQQQt2vDnEhLgNjeA==
X-IronPort-AV: E=McAfee;i="6700,10204,11307"; a="36296774"
X-IronPort-AV: E=Sophos;i="6.12,295,1728975600"; 
   d="scan'208";a="36296774"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2025 02:01:41 -0800
X-CSE-ConnectionGUID: 35dPDnlzQ4Gj6pi60sz6aA==
X-CSE-MsgGUID: Hnp9cnLkR22dv5e4xDeY1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,295,1728975600"; 
   d="scan'208";a="102536866"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Jan 2025 02:01:40 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 7 Jan 2025 02:01:40 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 7 Jan 2025 02:01:40 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 7 Jan 2025 02:01:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YBRYieXB3oo1m+EEUGeBk74/d22Pu+4CLTX7DuoXIFdqSvHz1NH0OztnHTw95vremONTNGFA4IfnrLOzpl0WZbH37cyPdC9E7SZoLYQ6BMYCl+u1mcxe9vCTwiwATUt2e8BQ1pRCtqPcQTTT910Yns7lgmHPhYy3WnUwjmrS2DACD7gLpmlapKSz8fGTipUnGxTp1CNJqfpeHUX7HorZuAXsc02BChSkXxrwmf3zTtlNiHAZQ/9MF9jpC7a0h55G5mxhM3b4hZ3EPcowk6LRo/ZwlO5E5qDGtF+4woc5qvCgQ1O5CrDLmw7Wlir04mNMSCP3XVYya04A00tNQ3swmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=93bOtr3zbgnC14GGUFEy5plizs3J9PqFOJE7rmOGRC0=;
 b=tjsSYDOyazSNNpnLrrrfgeXzpjLpEacN+ez5ngpUTBWabx4LtDSHKrTJQTtK5tNUWdJajJ7ztRCTBrC8Om6wJxbvzL55+6miiiRvTCStE3G2Qr12gWdkPT4hj3kLbDs96hUKyK6gBxHvNdUa50nV9ykcV3AJ/AY1vPd7ERggxqtB/x7k4aiRELDcM1mvfRfmW+J1m88BJSadPK42K2oPy9NScqI8vtzCC8pzA84j4MkDNTR7f84Q294fLBVNz2g+6IYqvzYAp4RPVxQU1ieXt4BnK2zoruAzbpjSo3CtM2uuC831hgR/gAvfr40bkQ4Vqbh+0SxClPX1U4RDjciGsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN6PR11MB8102.namprd11.prod.outlook.com (2603:10b6:208:46d::9)
 by MN2PR11MB4632.namprd11.prod.outlook.com (2603:10b6:208:24f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.18; Tue, 7 Jan
 2025 10:01:28 +0000
Received: from MN6PR11MB8102.namprd11.prod.outlook.com
 ([fe80::15b2:ee05:2ae7:cfd6]) by MN6PR11MB8102.namprd11.prod.outlook.com
 ([fe80::15b2:ee05:2ae7:cfd6%5]) with mapi id 15.20.8314.015; Tue, 7 Jan 2025
 10:01:28 +0000
Message-ID: <35ac0170-8979-4047-9b11-cd2c9ffea014@intel.com>
Date: Tue, 7 Jan 2025 11:01:23 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 027/222] cleanup: Adjust scoped_guard() macros to
 avoid potential warning
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <patches@lists.linux.dev>, "Peter Zijlstra (Intel)"
	<peterz@infradead.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "Sasha
 Levin" <sashal@kernel.org>, <stable@vger.kernel.org>
References: <20250106151150.585603565@linuxfoundation.org>
 <20250106151151.629422119@linuxfoundation.org>
From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Content-Language: en-US
In-Reply-To: <20250106151151.629422119@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR07CA0146.eurprd07.prod.outlook.com
 (2603:10a6:802:16::33) To MN6PR11MB8102.namprd11.prod.outlook.com
 (2603:10b6:208:46d::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN6PR11MB8102:EE_|MN2PR11MB4632:EE_
X-MS-Office365-Filtering-Correlation-Id: f7858cb3-48e2-454d-780c-08dd2f024101
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UFdNNjJHRmFUV3VYdEE3L29VRFZUU1dsYzZyVzYvSjE3eFVkNmdUazBuMnBE?=
 =?utf-8?B?ZW0ydnBLL2RpTVZKamxDMTdjVE5DUW44Q2JWblcwYm14cmxhWFgvN3pRb2ZS?=
 =?utf-8?B?cFFKa2ZFdlIveEdkdnFwNGp4elNRZ1pZRlp5SCtHTTc4ZmI4T2w4OU93dVkz?=
 =?utf-8?B?ems0aTJuQVV2UDR2ZWJwTVEwb2p2QmRFRkg1Z2dOZDdHcnA5OGZUekxPRWhx?=
 =?utf-8?B?V2tCZzlZVEVuMXEyT3BQNFl4bHB5UVFKTEREekYrdzU1L0c1cWN0YW9jNTFj?=
 =?utf-8?B?Z3FnemhyU1ZFMGNGZVkwTzVjVkVmQXZHeVNZcUdFSVFRQ3dXZzNnVlN4K3g1?=
 =?utf-8?B?NG5rR1c5RGpkTkx5algwUWlaemNoUDR2aElsM1lEbCs1MnhwZmNuaVFMYVhE?=
 =?utf-8?B?NVFWRFlab3paN1VCTGdXSmZFWWVzRGdOdDZzL3VOckdRamRLWFY4bWdUOFRC?=
 =?utf-8?B?UGFROXhkVkhURWlvN0xMaGJhUFRrNjYvRzFEQktHVGVFUW1JemNMYXRuSk0x?=
 =?utf-8?B?OEViYjBnUHJPZEg4dVVLZXlic3pnVWVUdjBJd29lZ01ybDIxWnJQNFhYTTRN?=
 =?utf-8?B?cGdGQXlFRkwrak0ycE5BNGM0WTBMM05HcG50VUFjcThOUm45c0xCQXhkZlNr?=
 =?utf-8?B?Qll1Z01XNVFkZTFTRGZqdDNFYjQxcW5LYTJzYXpZVkpwVHIzUlQ1cXBrZEho?=
 =?utf-8?B?SlgyUGZ6aEFsclgwZEhXN1hEMlA5ME1Ncnc3by92RjEvM1ZkZEZURTFIUWEv?=
 =?utf-8?B?Zk90QlB4NFhoV2FPbTZXcHB5Yk02OGw2Vm1KSlkzekd0UUh4SU9ZSllIcldW?=
 =?utf-8?B?aTQyeFRuRWNqVEZCdmtDQzFWbHFVcjkwS3E5aEltRTR1UjI2YkxuNTlTM3pU?=
 =?utf-8?B?cm9IbmZlcHNjdmxJb3VPTGJ0QW5kVjd3Y2J5aS9DYjUzUjVBNzZQRnFRV0lR?=
 =?utf-8?B?ckxjVFlxaXllOHZWemJvU1Q0K0J4VHRDaEYwVkxJbXdjQVlaMkp3WU5tcVZh?=
 =?utf-8?B?R25KYjZUNU5MdXVxbHM3bENEQXB2dGpHMXkvckhnNm9yUzNpV1p4eVZqbVVq?=
 =?utf-8?B?WVUrRjMxS05NVmdrRG9xUWRLR1pPTWRoQWRPTUZiSW1ySXZTVW9UazMrelB1?=
 =?utf-8?B?NE44OHhKU1JIYnRBVm53ckQ0bktMMVBuT2xZUTZ0VFVYbE8ybDdWeUQ4Rm1x?=
 =?utf-8?B?cllsazA5S0hBcnNjYWRhaEhZZHB5am9tNmtvQVBYSU1uQjljTEFEVmNabk96?=
 =?utf-8?B?NXhBdTJNNmhVa3huTmZJV0FEZUhBSDh3SlZaSFB0d1pPaGVvdEZRYy9aM1pU?=
 =?utf-8?B?bTUxZVg3OUNkNmlaVm82TGs2OWdDNzRoQVVhUHNkbHR1V0UvMGgwa0pkZnBI?=
 =?utf-8?B?WlVReEV2U0JYdXAxckdGeE80T01sOUwvR3g4TzV4bGxQQkxiOGs1S3dRQzBC?=
 =?utf-8?B?TVVKR0lncG1OQUF2ejBxMTFWTm4yOGM2WjdiMEdXUTVkYy82dG1QSXhVOTNB?=
 =?utf-8?B?NUl4UVFic3hkdW9xM2ZTcFBZcEFuajRuOVE3VDFJWWJ3RjZRMVloYTRHSm9E?=
 =?utf-8?B?bkJNYXFQMkxLekhwaXh2UzNBdkljWHdpVXpwcTFQMUFqeUs3VnlZSG5DV3RD?=
 =?utf-8?B?eWVPdzlldTRZY3pOMWY0Z2E4UmxXNXVkaWNmYlhMNTRmV2wySUhSQklHRW9Z?=
 =?utf-8?B?UlZvb3c5WEJOOThOVFgwR3NsRU5seHBUcEtBanF0QU9VcU9xVUVXY0psaFV6?=
 =?utf-8?B?cnlIazJRRmN2YnBMVGV0SFFWSHY5SjJScG1sQm1CWEw1UHdteDA5R0gzMTFq?=
 =?utf-8?B?ZmY1VlNWNXlsdzhNbDA2UVViQmNnUzVnTjRpR0tQcDBBUHIxMDNjV2cyQTFK?=
 =?utf-8?Q?z1jK2WLg1LQ9y?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN6PR11MB8102.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WERQVVFxOEtvQXg2VWdtSGNrZ3ltek9MNEc4SzJSVHlKM29ZdTg2aVV5eDFT?=
 =?utf-8?B?VEtLNlFlVE1DaGcrZ3JUUVZwQXdVdExOQnpnMlArYUp3NHFJcEswWEJQQ3Ur?=
 =?utf-8?B?VXhOUlVmem1UL0VFR1BrSVlubld4WDl1Yzh6QkV5NDBxMmxha1UxNDIyZE5Q?=
 =?utf-8?B?WWhWVVZYdWRkVFFsOHBEWE1mYTJtSHZ0RFU3WEpBWXBCWWRhUUdaNlI4UnBx?=
 =?utf-8?B?R0c1REVoQTJWVlpUM1BlT1VzZS9zWUpadGpFeU1tYkxBQVRnYW85VTViTHZQ?=
 =?utf-8?B?bkxKeERTY0hWN3NvQjFscmt5RmF4b0doanJya3cxbDZWRUNyOVVJYWVyMkE5?=
 =?utf-8?B?WS9NTUNuRUx2c21hODNpcU5oNHhuN25sc1ExdzcrUDIyaXM2R0x0UVh5QU5T?=
 =?utf-8?B?VjB5ZWs2a3ZpMHNxcEtPTGYzQ0QxSjJDR3ZIcHNBSDZNNVZnT3llNWUwMDQy?=
 =?utf-8?B?TG13bitWcTA0VGxhdFFEUUFvNHV6TXpxeWZ5dFRINEpobVVPcUJoS2svSits?=
 =?utf-8?B?dUtqbGxzeEYxL1V6OC9KTDE2UnNwU1NLNnBHU1VZRWl4dFR6MUUrZU9oTk40?=
 =?utf-8?B?STM4Q0VFU2J0MUx2YUJ2VGVORXU4bjBxazRqaDF6akY3YlVTbktmaEEyWVM5?=
 =?utf-8?B?b1BMWlI4cXRRZEREOCtoZGQwSjlZaUlSb1ZmeFlKUTh5NUtURGdUU0pQeDhQ?=
 =?utf-8?B?YnYwcCtPT21mUHVnb0w4S1dsLzM4d292T1Y4OGNUY2Jta01BbWx4NlkvdTRy?=
 =?utf-8?B?THpyd2M2TU9iSWpyb2FVVHFXdllaZXZOa0N6SnN5M0pxWVExeW9yTEVmSzJX?=
 =?utf-8?B?Mk9yTWtERS95dTdyM0pNSmNITkpONjY3amtEQktQYVc1cFNuNzJLdWdBcHN2?=
 =?utf-8?B?cEpmcmJzb1NCdFQ4TEphY0FqYlpIS0EzdVlOek5PTGhSOG85S0FEVjZnMHFn?=
 =?utf-8?B?SnRQcXlucytHdHpMb09lWTlEa01KcUV6bE0ybTZXalNONEFHK1VYdXhSZWJ2?=
 =?utf-8?B?TlJIczkxTTRROVgyRzBha1NjUHBockltWmtYZHQ2WnFpVkc5VGVDWkp4Q3I4?=
 =?utf-8?B?eXkxbzlNbnQ3SG9YZUVDZXZUanpiZXdpcG9zSkVmeU9iOG5LSWdkazdPdm1M?=
 =?utf-8?B?aU54MW9DMjZsaWRIcHBrZm9sOUJISlYyR2paeDFkNUdvNkdwQkE5aG1seGpF?=
 =?utf-8?B?R0Fsc3dPakxUMnlCc2U2TzJOU1FlaE93UW9PSjBwQXhxM2trK0R6MnRjOE1h?=
 =?utf-8?B?MGVLVUo0bEFlMUZORlZhbUp6RVVEZ0o3dXYvYStkaWhvd0hrdStEbDBLdC9s?=
 =?utf-8?B?MGFiWS9KQk5kbVYrS2xYQm05SzBmSjZzamtwdnZGdjMvZ3MwUzAzcndwWita?=
 =?utf-8?B?OEI2U2ZXaFdqVjdQcWdtdW5iWHA5ME5peDQzclRrMXVIaTFPZXN2QnZrckgr?=
 =?utf-8?B?dHVod0tPMmpRR3hpSG9HamdBNXJnZzdIY3NDNjg0S0xBU25Sck92YURrRHNt?=
 =?utf-8?B?WHZ1ODhVdDBuTmx1bzJBVHBRbWRmT25NbTVQQ2R0cFJHWmJXZ3Q0SmhLT3Iz?=
 =?utf-8?B?cTZSQTF5VUpLVytTdlFGL1VKT3BleFcvaEdONmpFZERqeFZoazR6MXlaL0JV?=
 =?utf-8?B?aUUrY1Fvb2h1bEx6MGFyejMrMU1YcWVFL3NkblJrUFBUdTN2YXBTblA0Ujdh?=
 =?utf-8?B?NmJ6OER6WC9NLzg1UFdjaG5BUDhXUC9nZ0xHZU1rVHptOEMranU4Smc4Z0d1?=
 =?utf-8?B?YWdZT1VyOGNDSkJYMCtSbm5zYXhnZ3dNLzlZZWFsek1HMXBBeHZCNXl4VGVy?=
 =?utf-8?B?RXF1SEFYZTRWbElCNnkrMEdOeW1YZzlNS3FycGtja3d1OVhYNkhrb0dkeDZG?=
 =?utf-8?B?eThsTzJNc2hneFdYNGlUVncwRDFZSmVRdXEzbGt3emRWZ0RicjRoUUdxK0ln?=
 =?utf-8?B?US9qbEY0ZjAzWDZ4NW5sNWxZVC9WaFBsYXkwUk8xYzluTWg1VWxITjU1TXVG?=
 =?utf-8?B?QnNJSGdrMXZXRTVOenlZY2xXOXBKYXcwbWt3dGZNTWp0eVhnb0h1cTBpQTgz?=
 =?utf-8?B?Z0dabkNOM3hQVno1OWFmeFUrN1JvaGRmYi9zbnRHSnNBMWpwVWdEb1QwK2Vi?=
 =?utf-8?B?VStIdEI5UWxPTFR5ajZ5SHh1cTM0Y1oyNGNVMmlMK0JtMGUwenB5V1pZczcx?=
 =?utf-8?B?bXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f7858cb3-48e2-454d-780c-08dd2f024101
X-MS-Exchange-CrossTenant-AuthSource: MN6PR11MB8102.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 10:01:28.5494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5t2LY7a/zd8yH4A92/wXAiJqkw3VN5AT/9/EYwtXRu1J1Ed3129MrSqfnKnq807o+wfxxyG+9fex1CEKtihX+uurNWLySrgFH/ViArrluPk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4632
X-OriginatorOrg: intel.com

On 1/6/25 16:13, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> 
> [ Upstream commit fcc22ac5baf06dd17193de44b60dbceea6461983 ]
> 
> Change scoped_guard() and scoped_cond_guard() macros to make reasoning
> about them easier for static analysis tools (smatch, compiler
> diagnostics), especially to enable them to tell if the given usage of
> scoped_guard() is with a conditional lock class (interruptible-locks,
> try-locks) or not (like simple mutex_lock()).
> 

please also consider cherry pick of the commit 9a884bdb6e95 ("iio: 
magnetometer: fix if () scoped_guard() formatting") when picking
the one in the subject
