Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA9A214204
	for <patches@lists.linux.dev>; Wed, 12 Feb 2025 16:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739376558; cv=fail; b=KXDTx0i+flfz7qDr/i7NUpX01nytAP72KjopaUTivcKAxVOXi9vYB4kW6EhTGW5VxpFjMZjcu0gVq1Itvavz1Tl6Q9m0h21GQV1ji8VI0MO4qbzf5Oym4O2FyIezz2YnjVkk9GCmLK4L4qAMmqAjVC2npv4F1rT8DTGCHCQEszI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739376558; c=relaxed/simple;
	bh=MjWhk6yNspCV5eLUtV7Ch8WViEMCGJF7g3zgQOF6iHk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uYLSpD9jpwL8uyHDMJwi8gIby7belwD+6W6oDkM7ETVYpMut9Bv2/c93V7ZXdkUiUOzgMr/vAF/VITmFg8tzqPY0Qi1PNzO9awKiMWN8Wo2d4cAlbbPb6xbJUMIOJzvKF13teSdmGGgXxMxjeWZ1OhPGxEiguQMCUkwZMJzB3Xc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QbqL6ZR9; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QbqL6ZR9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739376557; x=1770912557;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MjWhk6yNspCV5eLUtV7Ch8WViEMCGJF7g3zgQOF6iHk=;
  b=QbqL6ZR9NKJdIW6o9sjHl2CbMj+jWD5WSnoNpDE3LCkpGsir3z4+KDZZ
   WzmtJlh6C9TIwkfL+kMsphBHjnksiRgVg5R4Dt6/mNGv6Txmcaoro/sJR
   G+lXpqnipsTu2m0Tk8G0MES6GniDUJAqWNlRnE8pwsKXVMfwQKpoo+qjr
   rohnbI/aDFyuIb/DLE++xCkvKII/reytjfgjryVZc/L2xLG6DMBrzP12G
   gmcMMStobZy8JeKoIojqM8adJec7N0xpu7Zf68c0K3tMZvlBUwGQKR38S
   +46P6/2sKjqmmWnKMdQbqqQLAMsrlAtbZ6L673SInCRagAcOpvIwbC6El
   g==;
X-CSE-ConnectionGUID: buLJ3SzjSrOtYGb/LqGTVA==
X-CSE-MsgGUID: FEJ5CioxSu6k1mDrS2WqYQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11343"; a="57574662"
X-IronPort-AV: E=Sophos;i="6.13,280,1732608000"; 
   d="scan'208";a="57574662"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 08:09:16 -0800
X-CSE-ConnectionGUID: aZvBVpV4S6O00XOfwGMhFA==
X-CSE-MsgGUID: 74Ma6nWCQxSaFkuOd0fZiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="117797644"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 08:09:16 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 12 Feb 2025 08:09:15 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 12 Feb 2025 08:09:15 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 12 Feb 2025 08:09:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TMp3BKe7LvaD4h7GUNJrglxkwe+sSI9R+nHbeTFeqg4K00i97bczcO/4gTieImQyZFQHTkEfbcFzgp2a89JVHaiI7eGT0+3mIFmS7Faar8FLBFBUKIA96z8sdLFWelXg+4g4npZHQY9Gui8rEYMv+S0YEzJausdLcEKeImhCEL4+TzdOLBBxLlgRu+3ZzmQarad4Oo7oMWaQYeeBcydsIhxlX/hKLVo838fReoMv5dD6Tk4lo5ZDqidM7yWFWcquNDdg9UMQp7NJe3YppzAW7HPQ8Wrbp46SR+hzD7AB46n8c9YGEeKV1IhQiTe68h6V9zvcaE8SO2uJLJU+0LyYFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MjWhk6yNspCV5eLUtV7Ch8WViEMCGJF7g3zgQOF6iHk=;
 b=L4Ik8YbbYyfQ/d1zXGHUJE1Qz7Z8gsdf4yL1Jr5gLYlKIvzU8jGIqPszA1YvjHK4HVDc8WF3/OVAOGUUuQmZfjpneq/VuB8M+PTv0mmulciQF0jeILirDNfTAw8vtb4sAsdvmAZPDi7z2ldn6ZVZm/VChmFNtPZVIHo9BV/JoOJBKSRc7J3s7l1nql1H36kamhm9k9F35h9Cd1s3cFQl7VPrFhdIVx5NKzlkNo+AkezxfkHkLAtI/2pxm5cXERCUva/oSsVmY0JWbgkoe5sg/VewApxtmb1KMblgzcmvvRcy816F/BLgBH/yNRpl+0fqCX7iJZcKQSAu2f/4VlC99g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by CO1PR11MB5011.namprd11.prod.outlook.com (2603:10b6:303:6d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.11; Wed, 12 Feb
 2025 16:09:12 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.8422.015; Wed, 12 Feb 2025
 16:09:11 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>, Peter Zijlstra
	<peterz@infradead.org>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "x86@kernel.org" <x86@kernel.org>
Subject: RE: [PATCH] x86/cpu: Add two Intel CPU model numbers
Thread-Topic: [PATCH] x86/cpu: Add two Intel CPU model numbers
Thread-Index: AQHbDd9dF+gR22kTGEOmrX/vELh3ubNDwhsAgADySWA=
Date: Wed, 12 Feb 2025 16:09:11 +0000
Message-ID: <SJ1PR11MB6083F36D7C68AE8DF5AAA39DFCFC2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240923173750.16874-1-tony.luck@intel.com>
 <c8545ed5-b822-43a0-a347-d077bccf9d6f@citrix.com>
In-Reply-To: <c8545ed5-b822-43a0-a347-d077bccf9d6f@citrix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|CO1PR11MB5011:EE_
x-ms-office365-filtering-correlation-id: c9994e7f-3453-4579-76ce-08dd4b7f96c0
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UEc0ZHVtZ0dhOVlyUWNkdnRaVzZ4dVF6SnMwVENaaEdSWmtMQ0pMNnNidyt0?=
 =?utf-8?B?eHYwd3U1MXdwOFRHSnV0RzMwZVR2aFVTNHdqejlNbFA2bmN3V0ZqbFdCcVg2?=
 =?utf-8?B?NlpINVBvYjU3MThQU2Rud2poL3llb2tVZWVYY3o1WmhVRzNEWGlpUHVZU08z?=
 =?utf-8?B?WUpmSWZ6TXBkckNGU09LUWdDcW16MjJOU1VPQW1GdUN1OUgrekRWSkpxbWFQ?=
 =?utf-8?B?YStIVGorMmprb3BWUE9xTWU4UmdFRGo0YW5WVUoxMytXQk8xSFVIQlI4ZWpV?=
 =?utf-8?B?d1dKbStRT1p2ZWx0Zi9QdGV3TE96cWUxYkRXb1BNNEZ4SjhMbWswZUh4MmFa?=
 =?utf-8?B?WmtndjlrNS8rM00waUhhYnNEVEhBaHVuVEF2L1NITUhETkV1aDdjSDgrYnds?=
 =?utf-8?B?dHlFVjY2WHVNUzJ2ZXE5anUzQkQ1ZWx3OVQycGxMOWU2VDlWOXgxVktUWmNC?=
 =?utf-8?B?bi9zN2Y4WmRyQUk0TDRHUllXaVBaODI3OHlBQ2h0eHlSbENpM09yOXZyYWdy?=
 =?utf-8?B?a3EyQndIZXg1cStreG9YcVhiTnZ2NGxpbStHN2VsK0xHcTMvNzA4cjVVMDFL?=
 =?utf-8?B?K2d2ZFhMWVRhVHdldUFaMy9RMTBMQUlTOEs3NDZhc2tHOTljWXZJRWNQVHRP?=
 =?utf-8?B?VTlLUFdiV1d4RXpkdXFGbFFITVdPWEZmaGM4SjdBRDZvUEhnbHB2cWlSUUJ3?=
 =?utf-8?B?NksyTEhhS3l2WWs4NzJuY1BvQWh3M3hVQ0k1VFNtRzBIOFZNSjhxc2k5YVJL?=
 =?utf-8?B?dFJ4aHk0RWZQU3Y1amQ3NTBRZGcyUERhQjNUS0JQSDR5OHhsaitJbG9PZGRi?=
 =?utf-8?B?ZHU2VGY2bHloWmJxVzFTSEFxRlhGeTVHRHI1MjNXUTV0cXpzMDhtNjhZb2F0?=
 =?utf-8?B?SUJmell3WDhJb2FiQmFXV3ZteUlYUXlWT0c5ZjhOdkdtSjVkZndWa2o2b3Bi?=
 =?utf-8?B?VTJFVC85RUpjb3FXb3NVRHN6ZkkwaE12RUMxa0xQRnFld2hDaVRySkJQOU00?=
 =?utf-8?B?Mm95cHROTU8zdnJzcFRKK1hvU1dKN2RuVC9KSHVEekxHNndjOGlXSVpoS1lB?=
 =?utf-8?B?ZUN2dU0yL0FuQ01sRmpSVnFsY1FwWlplREloN2NVaFFWL3ZicStDUy9GeVla?=
 =?utf-8?B?SHVGWWdBdjJnUDNGdS82YjFKV3lEeHBGM0tyZ3NyTlEyZWRvcFd0MzB1cEw2?=
 =?utf-8?B?ekZGS05raHIwNW1oR2lFUkRndTh1amF1K0JsTGhTNml3aTNHZ0VucHUyaGxX?=
 =?utf-8?B?K2pQWlRWcjVLWWFYYnFmem42Y3ExcExObVlDaU1MT2l3U0IrWEhmbEo2YS93?=
 =?utf-8?B?aGVtVUZRMFBwN2phaVdKMHFvY0loU3QyZWdxMnFIVTFnemFKV3dpaFdpS3NB?=
 =?utf-8?B?clhGeXd3TlJBcERRMHY2QnViNXh1Y3hUSUxuQ09xYmh4emFFM0hTRTRUaklT?=
 =?utf-8?B?SURjd0xDRDJ1RUdZeHN6YkJtOE1UY0UwdjZZTXRpcnoxUHJIS2M0a1BScTNP?=
 =?utf-8?B?SHRpc0kxUlBINFp4RFR3MWFtcDM3UzVpS1NkZzVWK2JRb2kyZjVWSXVJQ1cz?=
 =?utf-8?B?c05SZGRiN2lJbU52d2lBaitZTXBrYjJMQXQvQ1pDcXJFTHhwOWNiU2pZOGRh?=
 =?utf-8?B?VmdldERkSTFpc3h5dW9STnBaMjRQd0tINHFqdkhtRm1nNHBBU25FMFZkWUl4?=
 =?utf-8?B?K2pDM0Y5YzZxbDdpcHZIWm9WSmQvTzV0RFVpeGpzRVJ0SFArc0Rxb04yL3l4?=
 =?utf-8?B?dGdSYUNkRWhJbGl3bFU0TDU5MjRraVhYRDFjVkFteVEvTkcvMDdROW5nR2FR?=
 =?utf-8?B?clhIc0xlRUEzNjZRQXo5WGF1WHN1WEdEb01nRzVPUGRmdHRVU2gvb2o2dTUw?=
 =?utf-8?B?VWMvWmdudEVNQ3ppcksyeU1YWFVJSDVzTU5BWm9JUy9NczNSV2c2TjhORTJQ?=
 =?utf-8?Q?BBNwd4+AZ6kD4crN2pCK2ON73eUAZLnP?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YVVMbWgrc2NNVTN0ay9ucjFwMXd0Q1g4VU5kOHVsRHJrVFc1d1RpSWRuT01o?=
 =?utf-8?B?Z1ppQlVQMmZYK1orcDZIT2YvZ3gzNUVVeEhsY0YzaEZGVGRyeHUrL3pWSXpl?=
 =?utf-8?B?eUlOc21QTy9kYmtPczhHZjU5b0NPTkhqc0RsaUZNR1dYTTRMYlB6WWZpcnpP?=
 =?utf-8?B?MVQ1c3ROZUd5RGFvaTZ4MllieVVpcDB1Q1IyUzZnWHl5bmIrVXQyaUlEalNU?=
 =?utf-8?B?eGdoaFNhbVJCdWNleUxrQmlRYlF4RExoWmxLQk9QejVhdFRxWjY4dXBhSSsv?=
 =?utf-8?B?cU13akN6TXBEN25wSkUzTERrRjBoODcvR2hKQXlTejlJRmtPM0c1Z2hGMUJ4?=
 =?utf-8?B?VEVHZlJBT3Rtck9iTUkvaTZUa1RaWFRCWDM0RlpFRUdOSTM1TjZoV3JBWWs3?=
 =?utf-8?B?RENBd3FjMXZ3VC95M0RxcVlOQmdEaG5ITVVrYzByRFlDZE5nOE5tWjRCTGdy?=
 =?utf-8?B?eDRYZ2tkUnVFb2VXK2VKelA1YmpHeVlyME5XMGVSWGhGdGJ4S0ZnWUNpd1lW?=
 =?utf-8?B?dlA1QlZVcS9Kb1dUOElJcUoweVp1WURMb3ZSd1BQbGl1dWV4YWx5eUJGWmFq?=
 =?utf-8?B?azlOeDkvSnlmZHhkWWordllNaE5lazFYanJFZE8yUDJ0bVlZWVpKM2Nza3Ur?=
 =?utf-8?B?M1MvaXdkUk5zYjVMSHAwREtqTStlMUNNM21xTUdSOHg0QmhkWVAwT3lobjdN?=
 =?utf-8?B?Zkl4T080LzZoZmhxMG8rWUFmUGlpUktKRGc2dWdlc1lZU2M5UVJVMXNkVVY3?=
 =?utf-8?B?Mi9Ld2psL0tXYjB1Zi9wMzI2SjkwUzFjUGZ0Vlh3Q3czc3F6ZjMxcGczc2Jx?=
 =?utf-8?B?SmN2cWJmM3FQUUJ4c3Jody83TWZkazRoRmRvQjliajhaZm92YTJObzZFMXM2?=
 =?utf-8?B?Ukxvd2JRSTRuZ0U0MW9xZkI1NVI4aCttV3RuZTFaVlZLbE5DU1BQMzc4U2FE?=
 =?utf-8?B?KzRKQXRieHZZZGc3Y1FHdmpXRnE5N1AzZFp2Tms1b1lkTTdtNi9KOERtOXZr?=
 =?utf-8?B?eFh6cVJOWUlOWE9tYzFNUU1pMWZnUE9lcUF4OUpYZU1mdzYyci9pU3laN1Yw?=
 =?utf-8?B?K216SVZLS3VlMXpkUnUyRkh0YkVIWHJ2bmNXVUpYcy9tV0o2Nkg5cGY1NHhC?=
 =?utf-8?B?UWJSZ3lnQ1JVM1hKQlkzelptTGtGSVdXZUNwOHdmbUtCSjMzdiszank5bWRr?=
 =?utf-8?B?THpsU0Ntc0Y0aTh5N1FRVEdhSCs0OCtUcElTWG9TMXhpNkdtYno3Yi83aDRm?=
 =?utf-8?B?OUtiSVN1Nk1uTGNtdlp0VVgyTmlBamZBUCtUcjUveUh6T2c0YkV4YVVCWThw?=
 =?utf-8?B?eVR2L1c0VVYrOTgzRGlmaEJzNFlmQlE5VVVFcFBvV2o2elRVTzYwejdhVDJF?=
 =?utf-8?B?TnFDRWhqRjB6cUpyN28zUWNQVms2bnZYeEQ0YWtaMHNLR2FaV0VzYjAvT1U2?=
 =?utf-8?B?QnV5bklpOTFzUzY2QnlQaStISC9FdWsxS3J6RnN1V05hZnFUdDRrZS9lVE8r?=
 =?utf-8?B?M0NpK09DZ0xqRzNNdStzTE8xR3UyZzZBSkVCTUNndHU1Zm5sSCtiN1l4dmov?=
 =?utf-8?B?Q0RxMUhkOGdaWU9rTldHTUkvMFRQVUo5d1M1dVVvYlZkT1VVNUFCUGhZRGIv?=
 =?utf-8?B?ZWEvRG9lRmZxTGx1ZFJqL0FzRllORGZlQ0xkUy94bm1GSHZhd1JCMjZqczdn?=
 =?utf-8?B?aHZkYzBxMjJpUUhsbzVoRFRpZGd2Q0FsaE9EZTJObHNmWkU1OFdueUt2MVdU?=
 =?utf-8?B?QnBOL2xpU1dna09rdFRITUJUNlZ6U3JKb1J6ZUZHSXgzNmsyczRWV0EvK3Ns?=
 =?utf-8?B?VTN2Y09Wd0tzRTFSbk1KY216Wmc4RXlHQ0VFWWhUaXlqU1RTUXIxcTRFME1z?=
 =?utf-8?B?NUw0cG1uU1g1SjBnVjJCdVNEYk81YjFDWU5jRXYwTklVUExSWEVaMjBqcFZj?=
 =?utf-8?B?SHVsTjJ3ZkxTa0hNWlNoUG5lOFNFMkVIVmZsSUZ3NFB0R3lhczc5YmU2UW9n?=
 =?utf-8?B?OVMrdVAvQ3Fmc00rT2xXWEVEOHhlMzlna3M4d3hScG5Ld2JSc0E3WmowTnZu?=
 =?utf-8?B?MENmT2YvaUxmSVIvL3hBUm13M0ZWRFM3clNxbTN1UUYwdERwaUZiYTFKVGpk?=
 =?utf-8?Q?7x4vNiO9UWm5XdqK0D1lL1nlg?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9994e7f-3453-4579-76ce-08dd4b7f96c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2025 16:09:11.8450
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u2qR/sjlnvcLahxmOv8HUhsXDWn7z3zYq01r34nurO9KQV+YwP87F5uH3knsmVMvIPbF7lq0saE9G36d1AtgsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5011
X-OriginatorOrg: intel.com

Pj4gKy8qIEZhbWlseSAxOSAqLyArI2RlZmluZSBJTlRFTF9QQU5USEVSQ09WRV9YIElGTSgxOSwg
MHgwMSkgLyogRGlhbW9uZA0KPj4gUmFwaWRzICovDQo+DQo+IElzIGl0IGludGVudGlvbmFsIHRo
YXQgdGhpcyBpcyBub3QgSU5URUxfRElBTU9ORFJBUElEU19YIGxpa2UNCj4gU2FwcGhpcmUvRW1l
cmFsZC9HcmFuaXRlID8NCg0KQW5kcmV3LA0KDQpQZXRlclogd2FudHMgdG8gbmFtZSBiYXNlZCBv
biBjb3JlLCBub3QgU29DIChhdCBsZWFzdCBmb3IgbW9uby1jb3JlIENQVXMgLi4uIHRoaXMNCmRv
ZXNuJ3Qgd29yayBmb3IgaHlicmlkKS4gIEFyZ3VlIHdpdGggaGltLg0KDQotVG9ueQ0KDQo=
