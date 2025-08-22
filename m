Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCCC27E070;
	Fri, 22 Aug 2025 09:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755854061; cv=fail; b=Ts0MxXiOA7kOwdhnumzeVGYfQekFmXy+LdtbY9wnvQ5GTthkNHtNtkbUPtn8SLyAeqVxtXYL2BTmJ/f3O6ebdcP5EpVxjT5/RaMrRxYysuf8lKjXyXNxyPfREBSWWg/EMNsGOkKAnNSP0hYvnnqjZqhnGJWJcFVh/2LzTgcVH5o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755854061; c=relaxed/simple;
	bh=WtrFBH9bUkFvPjtlfTAFgY2Two4J7YMjMtFFTTHJJRI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=l2VCyK4nnn/Qkl5VlScvyb2W8HMsxApn96PmWZt8g2sjJ5fRmG79nG0JuA9MS9YVyTyjh1npmoXXJVjJ/MUaMxwCkexLUBnc5+QbZosFkDsYksQ+DpC8Z7jwj/cnZlk+c7W2Y1TDawYHnMY8Cr/dBAGkX2fcq43mdMMsZygXffI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lGMsp6IS; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lGMsp6IS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755854059; x=1787390059;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WtrFBH9bUkFvPjtlfTAFgY2Two4J7YMjMtFFTTHJJRI=;
  b=lGMsp6IS1N43AlNEgdsuni2jGcUy7pCSWAHD4HNHQfDAjHlcRHBjN4To
   HgEebfZRCpzo42vKfINEWZ5WE0OVR/+208KWVIVBTdEQP8BuLCXzABIqs
   AYWUTjWxKb+58NXID4ZXHqY/7V0Wj1LFQ1AIfBeZgaAcwDF1HB3fanlj9
   FMt8sZZ/Jbs9eDhIQPN/uQHrpSw3tLPVDn1F6q7tJTTophWTDKKKdLuqP
   vFeAu9ZvMdGbl2uED9AOY3qtvZB/mrIR+dFYUHIweQDDYAoDxL3cK4Xgw
   di7EmarFgZ15zmfjzm7KR32l+7n55/G/NUJyaA7e4GMs0mn9NTsBvbCs3
   g==;
X-CSE-ConnectionGUID: TTlDdBRjSSq1/2PtxqmsRQ==
X-CSE-MsgGUID: nPOu894EQqWz/aKow14iMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="58257236"
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="58257236"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 02:14:18 -0700
X-CSE-ConnectionGUID: sjJDizvEQ66K0z6Fl7zUEA==
X-CSE-MsgGUID: Z8StvMuMTAiiHZ0loW8UeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="168566527"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 02:14:18 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 22 Aug 2025 02:14:17 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 22 Aug 2025 02:14:17 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.66)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 22 Aug 2025 02:14:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t6KD2B3PlD1fFaPCapjLuVvEM7reom4Mvdk5Mp8A4ERns4YIHSqHftgRVZ1oEpmlyhs6qQnlza7teUakhbWSvhsxIal9NfxQtgGpbNIoUpze7fvMTwoEUdgTW3umUFQsuQfCuGItp7PshG5wpzPkA+d0hvnRZH+shLovjzMI4KgvamwaqBGbP9As862e4OEDyNjlotQ8LG2bCSzUO/n/udhPWoTcbQFQbB8RmQJb5PHo+a+pq6y7qOyAJ933h9wYT17m5/4/HKBEIEf5blOFm3ssH5zegESDxifXvAGc5YLdgjRiI39Iy5Ke2AYqH0bvIcXsu4EUNm+LOVdl1GDumQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WtrFBH9bUkFvPjtlfTAFgY2Two4J7YMjMtFFTTHJJRI=;
 b=bs4Jl7B1DK+NlAQo4Y+/y0HEO5B7gCosJObi5SVtrBZd59aYdNhuZqFDlViGPJ0U4KEwNfXa6KXlCBpyfxzRTf0xdYrzh3pDewWVB1OpmP0sE50URFxMRNrFfqFcOS7NOi3vHmVZUlOwyqQ8F2+YfSrJLda8bIqwYFkS3frhrZeiys+h53ei39baR0/yfiWAuM0sJSOH8BitrdaPeY8iTkqt10m9a66L3xUr6CBFM2UBEgxTByGajmKZ0rnfwoUjfyDe1adl1ePWI19RDWHSeY6mYUiyFi57EEYpdIHS4VNlyQgFHydH4fxHDUDRlBFQL29nM6HWUM/KilcMi0HEJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB5027.namprd11.prod.outlook.com (2603:10b6:303:9d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.19; Fri, 22 Aug
 2025 09:14:09 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.9031.023; Fri, 22 Aug 2025
 09:14:09 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Tina Zhang
	<tina.zhang@intel.com>, "Wang, Wei W" <wei.w.wang@intel.com>
Subject: RE: [PATCH 5/9] iommupt: Add the Intel VT-D second stage page table
 format
Thread-Topic: [PATCH 5/9] iommupt: Add the Intel VT-D second stage page table
 format
Thread-Index: AQHb9ovxM2FvdwYrfk+IEcB+3Z1CDrRui85A
Date: Fri, 22 Aug 2025 09:14:09 +0000
Message-ID: <BN9PR11MB52765178E74F075CA330F7E28C3DA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
 <5-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <5-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO1PR11MB5027:EE_
x-ms-office365-filtering-correlation-id: 81b02c9e-16a9-4651-0064-08dde15c40de
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?azlzQTdvSDc0SkFKWHYwMkhXUnJib3ovODZMRE0yMit3MFI4aDVMZktaVnBN?=
 =?utf-8?B?dUNrYnp6SGJXWEZJcE1Xejkvem8xa01xWVZPRE81RlFnaFNJaFpyOHhSYjRW?=
 =?utf-8?B?eFRhaUVGb2hNL2h2b2lJZ3JweWhpakFyVXB3aEJsc21uMmlGV2R6K3VjRXdK?=
 =?utf-8?B?Y2YxVGtpTVF4UEQ0dkFNb0NGNzdYVmNEZGZMMGFVYURVSi9vQm5rUFBQclBU?=
 =?utf-8?B?YU95cHdMNHBpTEhTQ05YQ1p1bGVKUjFzN1ROZ0FZNFJyUm9CM0pjVXJleUM4?=
 =?utf-8?B?WlRKZHFpVGFEcGxreG5Fc0dtTUx6WDBiL2RZa3ozUldiNlJmVXR3UWVOZVVN?=
 =?utf-8?B?WDJVN1lvOXB6ZDd3akt2Sis4UHVTbThHbzExLzdUZG83R3lCVHBKZHdwZGVw?=
 =?utf-8?B?OHdtREJDbmJjQ0F3UFZRY1lxSWxWT0lRelpHVUFxZTBuL0FjSFhvSWlhcHNU?=
 =?utf-8?B?OC9pZG0xS3Y2RjdCdWdYNFZBV1dQM1VEZ1VhYllCRURLVTVpbWYyZERGTktS?=
 =?utf-8?B?NWpXQXZ3bjMvQ3JFZE53MVY3T2VIMHJyclU1bnhxSElBOEM2dlpicThCQ1JQ?=
 =?utf-8?B?cFprUjNESnFCQ29YQWllT0dKZE5zNVRkZUl4TTBRekhJaEwwbVZvTXBjVUoy?=
 =?utf-8?B?RUI2UmxhSTJCSDY0QStnbUdzellCVU90N0NHTEJ4ZXRIT2tRVVlvTElLdnlj?=
 =?utf-8?B?Z3NleDM4dFE4VHFEMkM0WTZ4RE5hdFlBMHFuc3FZOWxZVGNmZWJvdDdMdnVI?=
 =?utf-8?B?Wnp2QzZwaWtFdDBtWUNpVE1CeDFPaXlRa0NVYnR1MUtKZjkrTXJSbldDQ2w2?=
 =?utf-8?B?Z1hnUFBRN0dNSzZYcitXTW1FNXRmY1hmRllZT01nWm12SGlra3BRRU4wNHFh?=
 =?utf-8?B?TTNYWHh0YjVmWHAybGJ2UXZrL2VvTE81TEZKSG14eFMySHQ3aGc2YVZSUTcv?=
 =?utf-8?B?QTJudjcrRHlSeWVocXRWQ2NXa1ozSEFZTDZBQlFQbmVkbHdGZ0Fra2tUR0h4?=
 =?utf-8?B?YW5rRHJxc0J4Tm9GTkVscTZKZmNuSFU4eWh0UVJCMnUrQmJGNU5mQTFrZXFU?=
 =?utf-8?B?d0xWWVRBUlFvV3NHb2JBNG9naXVGZDVKeEM1K1ZMQmRFWStuWkdhV01ZMmFU?=
 =?utf-8?B?U3lwQjJrMGk2WFk3N2JVZ0dUaVMzYk1tTC9RdjdveFBsaTdmMngxeU5JaThT?=
 =?utf-8?B?MzN6cVNhaEFpTWw5U2FLSS9BRk85cWxhb0hpazB3QW04d2R4dFNVZVI2bS9N?=
 =?utf-8?B?dkQ5VUtrYm9tVS9pRzlCVUpJN2hsd0pjdkI5bjJFZGxVR0pEbnZpWm94VmFR?=
 =?utf-8?B?eUJWdytwQ1hOS1RrZTZlM2oyeFpORGtNZFRJeVFXNUJuMGJxKzNBdUVxN1p5?=
 =?utf-8?B?RjVxU1B1WGpVTVZsdDVjbXRHN3Z3azFQR1dOUlZLelZ2SDFpNFN1d3NtUitl?=
 =?utf-8?B?dVFHNWZVV0tJV2dBQWhBVmZMclBhQ2REdFpRZVNqTUk4SW4rN1JEekNIY2Vs?=
 =?utf-8?B?T0NVSjZ0N2JxT0lhZVc5M2xZdWxNTkFZdnpuc0tNck9kajBZQUZTaXV0WjFj?=
 =?utf-8?B?Mkx1dmVpcGR2OFIrWTZBRXMwRGZIUElYQWlWWnN0U3NDWEVmd2Job3QxREpJ?=
 =?utf-8?B?YWxJRTE0Q0txelRHcStUa0lud3N3YVRwT0RzR2pvdGdvTGVPcWhMSklNTWdu?=
 =?utf-8?B?YkQ4VmFJUG5RMjZSL0Y2MkxMckRFMGp5U2oxTFRtOUl5MUUrUkpLeStlZ3lC?=
 =?utf-8?B?cVE1bVR5eTlRRDBUaGdxLytkMFVEK0E4dkQwYTdJd01qZlFBZlV2dlNBWUlE?=
 =?utf-8?B?YUNBNnZZNmdQbVQzRmhEc3lqbVJLdGFXS1dXclRJSDlEcmppaGZhc2huOUhy?=
 =?utf-8?B?d3kzTjRjOUdnUHBtRFVvVkRsNy9YUWkvR2l2SDVVamhiaVVQeE1Bc0d3UkpH?=
 =?utf-8?B?S3JQbFcwdnhITkhVTEN2OXdSWDlxM1AyQ0l5VDdyTE1yQ1U1MjI4cXkyNE9v?=
 =?utf-8?B?MWdCS0k4dGtnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZTI5UkRBSmcwaGNCZ2pleXUyTjI3R3hRWjFUUDZjVXA4TkcxczNTLzVGMWQr?=
 =?utf-8?B?VDhGOFlMWWlpcEdzcjk2dVhMU1pDL1hYWUQ1SU9lMUVsK2ZBYXFzc0dURDFG?=
 =?utf-8?B?TUhHNGtFTGVxbFBCZUpHSHBPc2JIandmRGJOWENORGhtVlhZZEFadnYzTE5H?=
 =?utf-8?B?dmpuUTQ0c1RGN3Q0czZETkVnRVdzZXpjZU5VNGx4WnBBL3N1Y2xJNHpGSmVK?=
 =?utf-8?B?VGgzM0dWdytIb1Z5cC96YVhuNXZ1d1ZrdEQ3bXVnNlRiWGZ5aDV5blAvdGl2?=
 =?utf-8?B?MFE2b2xDRjNJaTRqTDhQTmxXcE4xS3RUOWhwTnJiWlFsV01ZUHQ4QUUzT1ha?=
 =?utf-8?B?YXJSaE9BMFI4WExhQllneCtCTEdINGQrY2R5UCtnUWlSR1RnbE5KUHM1bXdB?=
 =?utf-8?B?Q2dqa3JqeURYd3Y3T1FMKzU3K3BpL0RlRkxnRHAxQnpSVXIyQWM2SVdmd0Mx?=
 =?utf-8?B?Z0ZMSVg3S28zZ1BRVHREZU1oRVNGOSt0VDQvYi9ybXdJSHBVYWdZSzBkKzJj?=
 =?utf-8?B?TEk2dHFMN2QxZU1lUjl6NjJIc3JrWVZjVkZBblo4U2xuSnZiYjR5RVFHdVR3?=
 =?utf-8?B?Ym1VN09meWU5U054SG1CREorN1pwTGxINVJUR1dCaGJHblByRWV6ZWwyQSti?=
 =?utf-8?B?eVJINlA2a0tMSEF5VUlRSTNkMVRpNmZ6SFQ1WGRrMit5VU9HcU96M1RrSVhO?=
 =?utf-8?B?Z3BxMXo4NzFXSnlTWmc4SFUvNjc2T3hIVGhaOUM0c2VpK0pmOTVESURWdGM4?=
 =?utf-8?B?N2o3MEhCb3VvdFc5Y2VEbWJkVUJJOVJVODREVU1BZXUrc1lkT2I2YWdFVml0?=
 =?utf-8?B?aG1HdG9iKzBkbFYybitLd2pxM25aMXZBeml5QWJzdFIxdHhXT1lIMGE0amNP?=
 =?utf-8?B?RXVSM2lHWi9LdVorbnJDODZuK2RNVTA1S05QYlhMeldZS0RGU0xKVUdGbDdD?=
 =?utf-8?B?ZkJ6QW1LampibDQ5dkl5dHF3azdBaktQN0JUYnhNbUU5cnQ1TFUvS21uNzg4?=
 =?utf-8?B?a3krL2hzbWNua0hsSkpwN1VoSmdVTTNOc1R0ZFp0Szlsdy9OWlFSSlRzenps?=
 =?utf-8?B?aVNGSE00emwzUk15cG9GSTRYRjY1THByUDQyL2FtYy9WODFaQU4xU3plOGRD?=
 =?utf-8?B?aXBCTmUxUWhDcmhveHJPMmhYRk5reWsyUnBEWXUvNkM1SDF0c2tVaXMrNFZI?=
 =?utf-8?B?M3V6Nk1xL2RCaDNxaHUrckpYbTBqdVg3bi95b3ZpdzJHbFU5NHQrWEhtYlYy?=
 =?utf-8?B?VjNMaWxNS05yWEwxSnpOLzQrd2oxZHZLalRIQjA0cHkzc2JVNEpjOXcxZ09W?=
 =?utf-8?B?QTFsY2RFVmVNemNuMGt3Tmd5Vmd5d3ZUQVVzdkxwbHRzZzN1Rkxhbm1zVTUx?=
 =?utf-8?B?T1M0aTg3VC9vTjhLRVJKcmEwQ0hiZnRabVkxM1UvSUY2SWxNTGIzbzU3VnZZ?=
 =?utf-8?B?c3Bla00zSjVMSXdSdFg2S3RRUVBNUG5xZmtEcFJxMlpiWnNIdEkwQ1ZWQUFr?=
 =?utf-8?B?Z3VhYURhZVZjcEw2Q0hWeUJQME53REk1SDBQMVNWVTVEdjY1UkdMdGRJTVEv?=
 =?utf-8?B?Q3A1ZmVCc2w1Z2Nja1FEcVR0bmVpdks1emdGb2NITjRoYnZkajNONlh6YnYw?=
 =?utf-8?B?Z1k2K3BzNUtGSmxJT1VMQ3NNU0VtUDluREtuMyt4ajk1UVpXc0FjVlRoWnE3?=
 =?utf-8?B?cTkvTEwzU2gzWXdGQzZSazh1ZzhKMndsT0FrUmFLaEc2WnJ0T2F2TXdtcXZa?=
 =?utf-8?B?SUVYU3Z5ajhuYzArNGJ6am5DQnhNMUJjZ3JrNjJFUUhSN1JmbVBJR0pDVnE1?=
 =?utf-8?B?R1Y4NW9GQmZmRWxKd1FQZmxmY0x3UXlIOVlrUHpxTU1QOVd4b3czdWFUaG9Y?=
 =?utf-8?B?OHd6aXpLYUdFanBzdTU0VkpmMVY3M04xZ0hVZ002ZXRhUlNpYUxoMDZIMCsr?=
 =?utf-8?B?Q0tVWnBBVUhJd2p2aE1ueGZKOGtmZjBoRnRyQVJzczI5MVl4ajB3WnpWdC9z?=
 =?utf-8?B?cGlWbkk4ZFgrcDcrV3BPM2VjMzgxMmpCOHcxcEVQQTFMNTIwQWp3RHZaV3JK?=
 =?utf-8?B?OHo0NmxlVmdDMEZCOFNiUWJPcGFBakhONXVPcnBnU3FyQm5qa2tzOTR6b2xE?=
 =?utf-8?Q?UZXvSREyIdE/pmMtpPlsm9xJl?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81b02c9e-16a9-4651-0064-08dde15c40de
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2025 09:14:09.7843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iIlSPvQiKQwpbOKzHA+Mq5iXCYAHLuFfpR0jX62/VeMs4XySQCac0pXqB8T2e6nuNIDwJet1BE5NvWi5KCbSiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5027
X-OriginatorOrg: intel.com

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBUaHVyc2Rh
eSwgSnVseSAxNywgMjAyNSAzOjU4IEFNDQo+IA0KPiBUaGUgVlQtRCBzZWNvbmQgc3RhZ2UgZm9y
bWF0IGlzIGFsbW9zdCB0aGUgc2FtZSBhcyB0aGUgeDg2IFBBRSBmb3JtYXQsDQo+IGV4Y2VwdCB0
aGUgYml0IGVuY29kaW5ncyBpbiB0aGUgUFRFIGFyZSBkaWZmZXJlbnQgYW5kIGEgZmV3IG5ldyBQ
VEUNCj4gZmVhdHVyZXMsIGxpa2UgZm9yY2UgY29oZXJlbmN5IGFyZSBwcmVzZW50Lg0KPiANCj4g
QW1vbmcgYWxsIHRoZSBmb3JtYXRzIGl0IGlzIHVuaXF1ZSBpbiBub3QgaGF2aW5nIGEgZGVzaWdu
YXRlZCBwcmVzZW50IGJpdC4NCj4gDQo+IENvbXBhcmluZyB0aGUgcGVyZm9ybWFuY2Ugb2Ygc2V2
ZXJhbCBvcGVyYXRpb25zIHRvIHRoZSBleGlzdGluZyB2ZXJzaW9uOg0KPiANCj4gaW9tbXVfbWFw
KCkNCj4gICAgcGdzeiAgLGF2ZyBuZXcsb2xkIG5zLCBtaW4gbmV3LG9sZCBucyAgLCBtaW4gJSAo
K3ZlIGlzIGJldHRlcikNCj4gICAgICAyXjEyLCAgICAgNTMsNjYgICAgLCAgICAgIDUwLDY0ICAg
ICAgLCAgMjEuMjENCj4gICAgICAyXjIxLCAgICAgNTksNzAgICAgLCAgICAgIDU2LDY3ICAgICAg
LCAgMTYuMTYNCj4gICAgICAyXjMwLCAgICAgNTQsNjYgICAgLCAgICAgIDUyLDYzICAgICAgLCAg
MTcuMTcNCj4gIDI1NioyXjEyLCAgICAzODQsNTI0ICAgLCAgICAgMzM3LDUxNiAgICAgLCAgMzQu
MzQNCj4gIDI1NioyXjIxLCAgICAzODcsNjMyICAgLCAgICAgMzM2LDYyNiAgICAgLCAgNDYuNDYN
Cj4gIDI1NioyXjMwLCAgICAzNzYsNjI5ICAgLCAgICAgMzIzLDYyMyAgICAgLCAgNDguNDgNCg0K
SXQncyBhIGJpZyB3aW4sIHRoYW5rcyEgT3V0IG9mIGN1cmlvc2l0eSwgaXMgdGhlcmUgYSBzaW5n
bGUgYXNwZWN0IGluIHRoZSANCm5ldyBkZXNpZ24gY29udHJpYnV0aW5nIG1vc3Qgb2YgdGhlIGlt
cHJvdmVtZW50IG9yIGlzIGl0IGp1c3QNCmFjY3VtdWxhdGVkIGZyb20gbWFueSBwaWVjZXM/DQoN
CmEgc2lkZSBub3RlIC0gdGhlIHZhcmlhdGlvbiBiZXR3ZWVuIGF2Zy9taW4gaXMgZ2V0dGluZyBi
aWdnZXIgaW4gdGhlDQpuZXcgY29kZSwgYnV0IGl0J3Mgbm90IHRoYXQgaW1wb3J0YW50IGZvciBu
b3cgY29tcGFyZWQgdG8gdGhlDQpvdmVyYWxsIGdhaW4uIPCfmIoNCg0KPiArc3RhdGljIGlubGlu
ZSB1bnNpZ25lZCBpbnQgdnRkc3NfcHRfbWF4X3N3X2JpdChzdHJ1Y3QgcHRfY29tbW9uDQo+ICpj
b21tb24pDQo+ICt7DQo+ICsJcmV0dXJuIDExOw0KPiArfQ0KPiArI2RlZmluZSBwdF9tYXhfc3df
Yml0IHZ0ZHNzX3B0X21heF9zd19iaXQNCj4gKw0KPiArc3RhdGljIGlubGluZSB1NjQgdnRkc3Nf
cHRfc3dfYml0KHVuc2lnbmVkIGludCBiaXRucikNCj4gK3sNCj4gKwkvKiBCaXRzIG1hcmtlZCBJ
Z25vcmVkIGluIHRoZSBzcGVjaWZpY2F0aW9uICovDQo+ICsJc3dpdGNoIChiaXRucikgew0KPiAr
CWNhc2UgMDoNCj4gKwkJcmV0dXJuIEJJVCgxMCk7DQo+ICsJY2FzZSAxIC4uLiAxMDoNCj4gKwkJ
cmV0dXJuIEJJVF9VTEwoKGJpdG5yIC0gMSkgKyA1Mik7DQoNCmJpdDYxIGhhcyBhIG1lYW5pbmcg
bm93IGluIHRoZSBsYXRlc3QgdjUuMCBzcGVjLCB0aG91Z2ggaXQncyBub3QgYQ0KZ29vZCBwcmFj
dGljZSB0byByZXB1cnBvc2UgYW4gaWdub3JlZCBiaXQuDQoNCj4gKwljYXNlIDExOg0KPiArCQly
ZXR1cm4gQklUX1VMTCg2Myk7DQo+ICsJLyogUmVtYWluZyBiaXRzIDktMyAgYXJlIG9ubHkgYXZh
aWxhYmxlIGluIHNvbWUgZW50cmllcyAqLw0KDQpzL1JlbWFpbmcvcmVtYWluaW5nLw0KDQpzdHJp
Y3RseSBzcGVha2luZyBiaXQ4IGlzIEEtYml0IGluIGFsbCBlbnRyaWVzLiBQcm9iYWJseSBubyBu
ZWVkIHRvDQpsaXN0IGVhY2ggYml0IGhlcmUgb3IganVzdCByZW1vdmUgdGhlIGNvbW1lbnQuIFBl
b3BsZSBpbnRlcmVzdGVkDQppbiB0aGUgZGV0YWlsIGFueXdheSB3aWxsIGdvIHRvIHRoZSBzcGVj
Lg0KDQpidHcgYml0MiBpcyBhY3R1YWxseSBhdmFpbGFibGUgZm9yIHNvZnR3YXJlIHVzYWdlLg0K
DQo+ICsNCj4gKwlpZiAoaW9tbXVfcHJvdCAmIElPTU1VX1JFQUQpDQo+ICsJCXB0ZSB8PSBWVERT
U19GTVRfUjsNCj4gKwlpZiAoaW9tbXVfcHJvdCAmIElPTU1VX1dSSVRFKQ0KPiArCQlwdGUgfD0g
VlREU1NfRk1UX1c7DQo+ICsJaWYgKHB0X2ZlYXR1cmUoY29tbW9uLCBQVF9GRUFUX1ZURFNTX0ZP
UkNFX0NPSEVSRU5DRSkpDQo+ICsJCXB0ZSB8PSBWVERTU19GTVRfU05QOw0KPiArDQo+ICsJaWYg
KHB0X2ZlYXR1cmUoY29tbW9uLCBQVF9GRUFUX1ZURFNTX0ZPUkNFX1dSSVRFQUJMRSkgJiYNCj4g
KwkgICAgIShpb21tdV9wcm90ICYgSU9NTVVfUkVBRCkpIHsNCg0Kcy9JT01NVV9SRUFEL0lPTU1V
X1dSSVRFLw0KDQo+ICsJCXByX2Vycl9yYXRlbGltaXRlZCgNCj4gKwkJCSJSZWFkLW9ubHkgbWFw
cGluZyBpcyBkaXNhbGxvd2VkIG9uIHRoZSBkb21haW4NCj4gd2hpY2ggc2VydmVzIGFzIHRoZSBw
YXJlbnQgaW4gYSBuZXN0ZWQgY29uZmlndXJhdGlvbiwgZHVlIHRvIEhXIGVycmF0YQ0KPiAoRVJS
QVRBXzc3MjQxNV9TUFIxNylcbiIpOw0KPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gKwl9DQo=
