Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAB31BC58
	for <patches@lists.linux.dev>; Thu, 30 May 2024 20:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717100954; cv=fail; b=IJ29qenLiqt/I1iYF5qDfulIzL5grF0Z1cvZyzN+mJvsrMADwYmQHCZ0maSJGp1LNYqWnko9wMdCuK1dcWgN7O+9qe3Pg99QB/kf60iy9HoPG2OnSk5LnvBB6ONLfCGyhZfKaz5qAjevVSqNcQw4iUB63kYzW8rQVoa3D/2mby0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717100954; c=relaxed/simple;
	bh=J0yC0iUcB7G2GOpBjXZGiZn9iR9y/KkcJZ7eqd0HyDM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CZ+ZkZMVA+FJJdiDeM4WNtoJ8RVCcjr3B065KFH9CTO3xKDYPB/w40Erew081ZBcwV50UdpVtQv7PsawjolPbSLZedGLk+m4h0LzTl8Rn3a6176f/RP9dQMaK8helg7KIXD73c1bmFKpsT68pXxPIq2Boyu/xbN8EifudRQKL7E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZUiC0LWi; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZUiC0LWi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717100952; x=1748636952;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J0yC0iUcB7G2GOpBjXZGiZn9iR9y/KkcJZ7eqd0HyDM=;
  b=ZUiC0LWisNwnXysX+zLd/3lF+PQ27ouIf8uJmtgA1ilayPgB2h47q0v3
   JcjzbFV5Rednsm0HNi+kL1hJ7TGcVjREkC7Cy8jsTK5PWicJPILu2py46
   ayQsVDehGIMW1kuNp25KZDlVCHtxn5cHfbouHy7rI2SEE2N/a8XY8gjty
   O8zoEQOus1f4qrXtSlldIdIX525s+/xhV+Y5l6gdnQ4FDCtR/ifejXEzq
   rNk5ZvWu2JNTy9ZdCT5NTZ9YcOTz1V0I2EjahFSV8LRHamMFLk7yNElpt
   2tfnOdS7l9VhtSsR4T1MECEBIoKJVtONZjKcHqT5tVuIiMynUWdjFJQ37
   A==;
X-CSE-ConnectionGUID: vTVDsaJ5RKq/vZir1vMdig==
X-CSE-MsgGUID: JiBizFH4TtWWxSq470+0pw==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="16567436"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="16567436"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 13:28:53 -0700
X-CSE-ConnectionGUID: JXlqIeY1ROK3z7qoeho6xw==
X-CSE-MsgGUID: ucnu4+oCToeF6W6y3kPNzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="36040644"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 May 2024 13:28:53 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 13:28:52 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 30 May 2024 13:28:52 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 30 May 2024 13:28:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ItqShadPjf+kgKt1TN6SeQ3041BHzCBw/TR32nDn4ClxgR4sI2ejFNelDsE767itIbH9wBHRy7qrVkp09LTh6rVuaInzSodlvfgDdMq6ifh9XmkaPQrnXElZwESlE2zW5sxRvUsKaKcxSIArhRdXkBXgtoNmmv1m8C/lUwGS6mke+vjvceMxK1xnnJg9A0wKDKtgo3/4X9FvDacravKt6N37+cXscHebVHGYKjjX6EkHb5koxHIAF3wuj0PpzbLJd7QkG6bDTuEo54IDNkM45VprelD7NbOYLoh9exibqgPBL6L9vfAIwTHEnn8J48irUBJt3flqoJefx4Dx9KcpnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7SMWu+dP7vEWAWqPDQ/x2Vy73fA1J3jVopB9M7NHiac=;
 b=LPh7wiVFUuDUQUYds04e0TAqIi01peP2Gi83aXeQz9zF9mUAzt4wns29EBxjUUx9bRs7Q44WpN1Rn8hqQ1lbgswRZRDJxCay2CK9hbzt4JqeZS4lFSQEdS8sIL3z4/Bj5L1NKD8nazle4obdMNTL/I8lvp8TJuhbsC1SS7oTo5TNLwfdpudmx7oA6uHvpddSruNlmyhM2vft2YUnPHNOJ/wzoCfhZ9GnlmbhzBWNCxcFJRfA9T3T6+qUiLCuYSYnG2tMfoIUvNkHB8cSlbDdasH1f3ceNMk9odfxi0powxavbykbZqpJ67xU7RGUWiKw/kLaN3Wgz2D4b6WYAN5Ciw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MN2PR11MB4581.namprd11.prod.outlook.com (2603:10b6:208:26c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Thu, 30 May
 2024 20:28:49 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7633.017; Thu, 30 May 2024
 20:28:49 +0000
Message-ID: <c6651270-25a3-4d9e-91f8-4aa9c8652b98@intel.com>
Date: Thu, 30 May 2024 13:28:47 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 19/20] x86/resctrl: Sub-NUMA Cluster (SNC) detection
 and enabling
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	"Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240528222006.58283-1-tony.luck@intel.com>
 <20240528222006.58283-20-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240528222006.58283-20-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0229.namprd04.prod.outlook.com
 (2603:10b6:303:87::24) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MN2PR11MB4581:EE_
X-MS-Office365-Filtering-Correlation-Id: ff40c397-7b20-4a5a-915c-08dc80e71d03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?K0RVS25OZUlJQlBGbHBmWDJhRXB0amU5SnJPV0tCTXlyRGdFai9vd2J3bW5B?=
 =?utf-8?B?Qzh4K2trQ2dnUnYvakhHTEpxdWNLSTlTYkxIOEhvT3pHbEFWUW1qSE9FZzZT?=
 =?utf-8?B?SFcyZkZEQXkyK2o5S3VaSE5OdW9rVnVIQ0wrdHhLVVRkd24xSEkvczd3b3Jn?=
 =?utf-8?B?aS9KV0d5S1Jxc2w3SjdJdEpBNzdLdm5IT2ROT0VMcXlNelM4ZXlFOTI4NWRh?=
 =?utf-8?B?bkFpdGV3NDBaL1VyUzBjK3ZMZTQ1TjlBdGZNUlZCdEZrN0NmdUJ2bHNkWHRx?=
 =?utf-8?B?elBNek5RekF6ZUd3NlU5RTdtM3Y0QUpWZVhtSlQ4Ym9RRDZjWGs2MXROTHJL?=
 =?utf-8?B?dlN1am1uWmh0UHVNQm1XdzBHaXY1ZmgvNlJXQytadTJSYkxqdEtmaU0wQVVy?=
 =?utf-8?B?Zjl2VlpqbThnWm9ZdDRUT2JrWUhwNEQrUG1KRDdHd2ZlVHZ5OUFsRlJ6L1l3?=
 =?utf-8?B?aGtXbGFXRWord2tLVldBVytTR0gxSjA2QTlud1JHMmhSMkpsQmJkbUZhN2pI?=
 =?utf-8?B?NEFsV0hDZDYvS1BaVkdrbG1yaHdJV09tUWJyZGEzTlhaTVRjYXUva3RJdlJn?=
 =?utf-8?B?NjJzMnBab0JHOHFIbVhIZHlBRnNEOE4zaExWU0JtZHVMMFB4M0ZXeExUOURF?=
 =?utf-8?B?N3VYYWxpVlBTQlQ1QWJ4Sk83Q2VwakdKeitYUHJZRGU0ZmN1SU9HK2dFa1Zz?=
 =?utf-8?B?Zkc5WUp2dnl5YThLd3hsdlB5bk10U0pzYkNUMXpoR205QVBCUEo2eEJoZlZM?=
 =?utf-8?B?VWxleFVONWxuRXN0NWkyWEx1KzIzK3pMajFUNDc3TWFpbE9zcWl3MzhNY0s2?=
 =?utf-8?B?ZHdObHp3VGphMVhVemFZb2V3QjZKZ3lVOWw0QWw0Z3Nnd2hLekFIbGhPZVNF?=
 =?utf-8?B?QmhsRUM5TCtYZmhiOWxpNVA2SHpwaGpzbHFsRDBCTTdLTFc5WStxS3pPZXlU?=
 =?utf-8?B?RjlpUXFrZFZMS2FFL3k2Ynk0QlUweVArb0hlb21GOGZkS2NTaHIzd1h0S1R1?=
 =?utf-8?B?T1FEak45YjhnSUh2MU1wNkFBRmdGYzBvUll5OVFNejRMUWlsdHliSGtueEF6?=
 =?utf-8?B?dHNiUnpFZS9NOUdRVHFwdUdnNmhnUXBiL3k2Y0YvNzhEbjFSZXJIV3VML1Bx?=
 =?utf-8?B?cHNyRWFLT2psdElYclY1cHB3dVBvQUNMQTc4eDNOZERHVnVHcUpVY2FQQVFD?=
 =?utf-8?B?eVBBN3o1M0pnM0dzbFlFOUd1S1lISkl3Q1FhSlBNMjNWWkdQM0FiejkvZ0lM?=
 =?utf-8?B?d09LSWE2dVMzeHU0UmJOYnpVL0ovRGNNWkluYU1WeWsybit6Y1U3VG1pZWEz?=
 =?utf-8?B?eXU2aXhrKzdKUEVUdmhyZFEyVnJaaGRMbStQSXZLaCtCbkl6dDA4M2c3TTlR?=
 =?utf-8?B?Y0xxU0JxSjRvZ3krd2pmTVRBS2RqdkdDellER0VVekU3WTZIT3JaNURNcWFG?=
 =?utf-8?B?U2Y4UTNobXd5ZE13MmhRQkpLZmlNZ2duK1c3bkQwdjR4RG9LMDVaYmJiaXYr?=
 =?utf-8?B?ZWdYRHcwdTU5SS9QZXB1SFhlSURFbC9sa29aaFU3TG5JRTVVS1Z6TEswOThj?=
 =?utf-8?B?YnNub0NoVENaSlRqRmxDUHlFMmdrVzByanoxWERzRWoxMTRBOCtZNEFrMXpo?=
 =?utf-8?B?dERjWmlFTmRsVHp1KzRiWmVUa0cvQTRZNU5DRi9JcnhKYkFRUVpUS0llQTN4?=
 =?utf-8?B?dllUVWF0Ry9RTGhtZWNQS240ZExYaDZoWHZHS3Rjd1ora1h2Nm1sZlZnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S2gvTVEwV1BLZEJ2OENTc1FUdWFjS2FuUEdZRzJxSDNUSDdLaFV0alRreFJl?=
 =?utf-8?B?Y1RyNHJvUVVqbG9hVUQ5b1dPUzkwSXBJZGlCYyt3dnZsTE1FbTJoUE0zVUxw?=
 =?utf-8?B?UmMyUmpaRWVRVG1oTy9vZytMN2ZjRnNmaFdUNU5LZDN4MDEwOTA3K0NtbHln?=
 =?utf-8?B?VXROcDNIQmsxUE5VRmZLbVd2NURtVC9qWDBZSG9tSnM5aTNJczRKRzlBMUg0?=
 =?utf-8?B?bXV6SkhDU2NWaXFPN0FKdFdiK3F1allaUmhvTWVyNGRTTElTbGV6MUtKOXc3?=
 =?utf-8?B?VHdsSkxTaXVzR0Q3M25nQVliZG9QTWswVHB6M0F4Q2Rvb251cmZ3SlRRUkpP?=
 =?utf-8?B?YXhhK1pVVWtyVytrM1Zna1k3Snh5bEFLVTE5YXF0QVhEWlAxM2lIQUdwZS9K?=
 =?utf-8?B?UXVuWFZPZUI2ejNkNnMyTjFUdHdINVdpeDJVeURxRDk1UjNHMzZMVE5PQlB3?=
 =?utf-8?B?ZlVkalpyalhsN2RMT0N1bVFIMWtzdUl6Q21xRkQ1M1lLcDZLNmREMzl6bzFr?=
 =?utf-8?B?TmZtQ2d1U25PeFNXNDg0VDZGNHJkazA2UnUyVTFDTTIvZ1lmaU5kcURydkdn?=
 =?utf-8?B?R0VkNVE4SUY4cmFrbVQ5THNFMWRCazY0QXNJSEFBc3pwQ3hZb0RrNUlYM1li?=
 =?utf-8?B?U09RY3lIM2taUFQ5dXpPK1VxVk1hc2JGd0ttT1ZSL1FkNUxheG0rREF5NFY0?=
 =?utf-8?B?TXNkcGNWN3pFaXJORTUvRkJqNGdsVDBEZzZvcVFzZ2FpRUJ5c0tEcGtGSDBI?=
 =?utf-8?B?NWZOMGhwMzRhNlRTcmtabWxnYzhFUDRNTTIveTFEdVo4RjZ4TVI1Wi9aMThm?=
 =?utf-8?B?Z05VYTdTVldSYVozMStZYTE4R3ZPTWVqOENSblpvNERZczZGR2w0SWFrdTBG?=
 =?utf-8?B?K0I3bFZRUzFXekFOdHB0TDFNa25icEJGbE1ZWWo0Nm9LNHZGRktlTno2d1Q0?=
 =?utf-8?B?OW5jSys3REEyemFEaTlGbE13UzdrZ1U1a2ZzL3hwTnAwbm5GeHhKVEZPaERJ?=
 =?utf-8?B?R1JXY1RTMG9jNjYzb0ZpcDBlR1FRUTRXdkJnUWIvQklReGtzQzQwSGQ5UG8x?=
 =?utf-8?B?SUVwN1ZVbC85SUpGVWJHRkZJQXc3L0FZN0RoN0ZhTmRObmJLZjRXcFdSb2w2?=
 =?utf-8?B?L0kyL3R2NzQyc0ZtUmJtMSt3by9DRnRCc3d3L0hXVU1xc2JHaXN6Y0lxME1i?=
 =?utf-8?B?ZTdLZlhtRWc0SWpxakZ1WnBtb2lSZThvM1dYYUNhYytYYXZQdkdjd0xKdlYx?=
 =?utf-8?B?bUkrYkROQ05rVzg2dWNiT0dOT0xwOVN0dDFiUEtQQjluRU1XbVlNaExyVkli?=
 =?utf-8?B?K3E5VkFtajZhb1dIOUdQRUtDd3JBVUFIK0tSQmdadWZ4TG5vT2l3MzdiSmJh?=
 =?utf-8?B?UWhQRGFOb1d5OXQvcU1nK09KTzhiZklOanh0TUF5d3hyWlBiMnFTMGI4d1hR?=
 =?utf-8?B?Vzd3YlR3bGRuSnlrSkVJVzFEcmJUME9pRDVsM0dvaVc2MFFuTEF5V0pDeHcx?=
 =?utf-8?B?TE84V0hWM3h5dzhYT0NZWFZzRVVDSERqUWNoc3Q3UWRRZHpOb29hZnFRR3NI?=
 =?utf-8?B?Y2x1ZXdVTnZiQnQ3ZjlYOXVhUENyajcwaFBwYVJMZ1NsRm15dFFSMXRsYjcx?=
 =?utf-8?B?NUZGaWZJK1NzKzcxVkM1Y1F2cGVZZGlSaGZOa29OSUJNZk5kekdFcVpGZ21w?=
 =?utf-8?B?M2tFSEN4SVdDMG9COTQ3YjBkbHZyZjZVOFJuQVZqRFBmWlpLeG5nVGFNbWlV?=
 =?utf-8?B?Uy9NazhEZEhDbWVxQWw5aUNnMkliYnRNZDlvOWxkQVNXYW5HZFpkYkhjU09N?=
 =?utf-8?B?djlIcUZEL3ZLOER4VDdDSUFwaU5ieUpSMVZUenNvSk56b1NtUnZUb0JPbnp2?=
 =?utf-8?B?SWNKMDVRZDg3ZGEvcG9CbFQrM0xnbmlXSWpkNitXRXY2aFYzbXlYbUxUait0?=
 =?utf-8?B?ZU5SakFnbkRoS3UvZENiWWx5a3RRL05XSThoVS9qL3doeWRMLzBYQTlaY2px?=
 =?utf-8?B?THE0RkFYZFNIQWZVblNBVmNSZkFXQnYzVzB5WHJMY0czV2NMTUNBbmpjRFlE?=
 =?utf-8?B?bG9UMjh3QjQrQWV2c3FQT0tGcTJLYXE0dTM4eVVENlNXclBQV0p2RGRMcHlo?=
 =?utf-8?B?VEVyZitJSmh0cHl6dmtCYWxlZjNsK0l1dTRxblhxWEhFUTNYUVZHeDJmL0V3?=
 =?utf-8?B?MFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ff40c397-7b20-4a5a-915c-08dc80e71d03
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 20:28:49.3517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IgjRpUa2JRecfSMwUMG36hQXBbqbTh4ZbEiviU2qlxuTEwuOxQAQ9Lm7fF2qCCNS0Isd5ySoGy4PxNJr1MF2xJvfpqB01eyrSQiDAdzQzng=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4581
X-OriginatorOrg: intel.com

Hi Tony,

should "and enabling" be dropped from shortlog?

On 5/28/24 3:20 PM, Tony Luck wrote:
> There isn't a simple hardware bit that indicates whether a CPU is
> running in Sub-NUMA Cluster (SNC) mode. Infer the state by comparing
> number CPUs sharing the L3 cache with CPU0 to the number of CPUs in
> the same NUMA node as CPU0.
> 
> If SNC mode is detected, print a single informational message to the
> console.
> 
> Add the missing definition of pr_fmt() to monitor.c. This wasn't
> noticed before as there are only "can't happen" console messages
> from this file.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   arch/x86/kernel/cpu/resctrl/monitor.c | 59 +++++++++++++++++++++++++++
>   1 file changed, 59 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index c7559735e33a..1c5162a68461 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -15,6 +15,8 @@
>    * Software Developer Manual June 2016, volume 3, section 17.17.
>    */
>   
> +#define pr_fmt(fmt)	"resctrl: " fmt
> +
>   #include <linux/cpu.h>
>   #include <linux/module.h>
>   #include <linux/sizes.h>
> @@ -1095,6 +1097,61 @@ void arch_mon_domain_online(struct rdt_resource *r, struct rdt_mon_domain *d)
>   	wrmsrl(MSR_RMID_SNC_CONFIG, val);
>   }
>   
> +/* CPU models that support MSR_RMID_SNC_CONFIG */
> +static const struct x86_cpu_id snc_cpu_ids[] __initconst = {
> +	X86_MATCH_VFM(INTEL_ICELAKE_X, 0),
> +	X86_MATCH_VFM(INTEL_SAPPHIRERAPIDS_X, 0),
> +	X86_MATCH_VFM(INTEL_EMERALDRAPIDS_X, 0),
> +	X86_MATCH_VFM(INTEL_GRANITERAPIDS_X, 0),
> +	X86_MATCH_VFM(INTEL_ATOM_CRESTMONT_X, 0),
> +	{}
> +};
> +
> +/*
> + * There isn't a simple hardware bit that indicates whether a CPU is running
> + * in Sub-NUMA Cluster (SNC) mode. Infer the state by comparing the
> + * number CPUs sharing the L3 cache with CPU0 to the number of CPUs in
> + * the same NUMA node as CPU0.
> + * It is not possible to accurately determine SNC state if the system is
> + * booted with a maxcpus=N parameter. That distorts the ratio of SNC nodes
> + * to L3 caches. It will be OK if system is booted with hyperthreading
> + * disabled (since this doesn't affect the ratio).
> + */
> +static __init int snc_get_config(void)
> +{
> +	struct cacheinfo *ci = get_cpu_cacheinfo_level(0, RESCTRL_L3_CACHE);
> +	const cpumask_t	*node0_cpumask;

Stray tab

> +	int ret;
> +
> +	if (!x86_match_cpu(snc_cpu_ids) || !ci)
> +		return 1;
> +
> +	cpus_read_lock();
> +	if (num_online_cpus() != num_present_cpus())
> +		pr_warn("Some CPUs offline, SNC detection may be incorrect\n");
> +	cpus_read_unlock();
> +
> +	node0_cpumask = cpumask_of_node(cpu_to_node(0));
> +
> +	ret = cpumask_weight(&ci->shared_cpu_map) / cpumask_weight(node0_cpumask);

It is not obvious to the static checker I tried that cpumask_weight(node0_cpumask)
cannot be zero. Can you please insert a check to make static checkers happy?

> +
> +	/* sanity check: Only valid results are 1, 2, 3, 4 */
> +	switch (ret) {
> +	case 1:
> +		break;
> +	case 2 ... 4:
> +		pr_info("Sub-NUMA Cluster mode detected with %d nodes per L3 cache\n", ret);
> +		rdt_resources_all[RDT_RESOURCE_L3].r_resctrl.mon_scope = RESCTRL_L3_NODE;
> +		break;
> +	default:
> +		pr_warn("Ignore improbable SNC node count %d\n", ret);
> +		ret = 1;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
>   int __init rdt_get_mon_l3_config(struct rdt_resource *r)
>   {
>   	unsigned int mbm_offset = boot_cpu_data.x86_cache_mbm_width_offset;
> @@ -1102,6 +1159,8 @@ int __init rdt_get_mon_l3_config(struct rdt_resource *r)
>   	unsigned int threshold;
>   	int ret;
>   
> +	snc_nodes_per_l3_cache = snc_get_config();
> +
>   	resctrl_rmid_realloc_limit = boot_cpu_data.x86_cache_size * 1024;
>   	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale / snc_nodes_per_l3_cache;
>   	r->num_rmid = (boot_cpu_data.x86_cache_max_rmid + 1) / snc_nodes_per_l3_cache;

Reinette
