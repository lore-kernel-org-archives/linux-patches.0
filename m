Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBBE2253FC
	for <patches@lists.linux.dev>; Fri, 19 Dec 2025 05:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766122158; cv=fail; b=qL305ecUyt99R+Fy5FgHuDOu1iLsV/K8lBwwPVbAV5ir7SLNRMmzX7W/JkpLrRjw4BJRoVcDDf5TY1DeXwpg4oBfALZnvwZ6spjXQq5uoOmhJk4TAl/i1gCTAoaMarTqzABMQpOAm8cFBrxBVXfMWOnJ5JLvU75KcVNJO/1Ew7M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766122158; c=relaxed/simple;
	bh=8waO87IlCmfwK1auukTfrCSvl4bL7/9DjoaMhxdZGQE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tlCFutCfuneA4Pvw32imnnDrNmXHD2U5NVqfLrwcMiIgqef183/g2GvVjJKgrc0hjAlyYEQSRtZi8rKJh5UjwgFUqVmz8eVDz+Pnx+SClTwFL9M4IU7SnCaoVhw9o0T/6N2tNn9eLRQ9SmppZhqYWKn6vw6clUrqooVuQ/hkMaI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=lIRwlCuN; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=gDx0i31A; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="lIRwlCuN";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="gDx0i31A"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1766122156; x=1797658156;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8waO87IlCmfwK1auukTfrCSvl4bL7/9DjoaMhxdZGQE=;
  b=lIRwlCuNy9euVMRwQgf+SRz0oCeothdBnlY8UwLIY+pddOwe4kdM2uVa
   RCXhW9WzXPA77q4a5kHpHZcAJC3OsobH17Kpelbu8unPQIrT2oKMWw1Pu
   2e1/TTDonShgpjtVbpFIDkw8WBKg3kQr4a8GiqCY4XN63TQ5uhnw8r8k1
   2ac6FbRxTzL9U78+gCp+xFJICYi3JFBo3z/c+PzvQpHzH9CMTD05FP5qH
   +oerhSh5pmtHobcAIhATCAfQmcAMUQeQoB/PfCWnTGUNv9J364cCclNiX
   WyxeNZAoo3OR/gabVmypTQbMnw9be5Hcr3OzWfmVKYUus2/j7hvcy4lVr
   A==;
X-CSE-ConnectionGUID: KMeN+Pk4QK+TrgpNQSKgEQ==
X-CSE-MsgGUID: GIUIEr+gRyWCd1gZRVvkTQ==
X-IronPort-AV: E=Sophos;i="6.21,159,1763395200"; 
   d="scan'208";a="138635831"
Received: from mail-centralusazon11010051.outbound.protection.outlook.com (HELO DM1PR04CU001.outbound.protection.outlook.com) ([52.101.61.51])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Dec 2025 13:29:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jUAyYXsWBbQ5ALEAQYpZR1qvG/IroHbbdr/JuofaCxNdbh9NJCS5pHxvCqrJtJTBLxXrDWZgGIyGfQ8TzUu9QneoaDLXE2udgFsEvboKONZDAN9A0C8Am6Vqx0e2QzNEYBQ1vAuN0J11UjaaaxEuzsYkDg/eze+402lrenPX8wt3ft1gRhk9KxN85rVEyMdNZVdurHu5LXJTAAAENlfKwmqmD32zH8cZSp3eazQJ3EBYlBoTAjv3YJRhwXtxiBBtoYLvHrbhEN1aVuulpYNKGAf58Ye46EVWcfbjto/23gEiqZebWcH7baWlx4bmCfovYHBAZ2jD1epAMAfoAYGM0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8waO87IlCmfwK1auukTfrCSvl4bL7/9DjoaMhxdZGQE=;
 b=lQMtu0yh3jOUFNiNd3az2oHlHp/s9s426JYhISyXU0D4IOiZ6HYzFRaLawPpIDVs2gqeoBsUAqz6mNDzW7bvbRX3jhUDX6FPg5NoRRjBhx1tjD5YVvbSTEoa8c4kievb0IoI8JlA8EqIyY1waXVa0PVGw86QgP2LTKWSnu9S78PSioG4Pi0ow0FW5BnIWQSdCcAun+oOKg7Mu2EEErmW/kQREj+H/+aQ4dBeXSEKs7/CAddRMT3plv2hDBHFN+G3ArdqeuduB9xFxIgO3N1NoOwAQPqU8OAAj37fMbJVJHXVimx/LSaMXU7q38RUXSLTif12qBkKuUcQIX2mfEkZVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8waO87IlCmfwK1auukTfrCSvl4bL7/9DjoaMhxdZGQE=;
 b=gDx0i31AQTKOgSh3rfe/AHfzB0j+6xja+aeaao3zsOMpemLrJYsRD0sNOufd+ICUQWmmYHBp0XKfntKyx3fqDayI2lugan0AVCi5pfothigY664ixPZptcojZCeo6Kgaiy/K5ID6VlBBvk+q7AftDKD3shgP40EUQg1a3oTmHWQ=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by LV0PR04MB9789.namprd04.prod.outlook.com (2603:10b6:408:334::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 05:29:06 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%7]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 05:29:06 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, Luis Chamberlain <mcgrof@kernel.org>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "gost.dev@samsung.com"
	<gost.dev@samsung.com>, "sw.prabhu6@gmail.com" <sw.prabhu6@gmail.com>,
	"kernel@pankajraghav.com" <kernel@pankajraghav.com>, Chaitanya Kulkarni
	<kch@nvidia.com>
Subject: Re: [PATCH v4 1/2] blktests: replace module removal with patient
 module removal
Thread-Topic: [PATCH v4 1/2] blktests: replace module removal with patient
 module removal
Thread-Index: AQHcXverMdISXcicTESRwucSMTRsk7UFOs0AgCNYDAA=
Date: Fri, 19 Dec 2025 05:29:06 +0000
Message-ID: <7e056be2-d9c6-41f6-848d-f87e91983968@wdc.com>
References: <20251126171102.3663957-1-mcgrof@kernel.org>
 <20251126171102.3663957-2-mcgrof@kernel.org>
 <a38bbe68-97e8-4476-a406-5c5228167e96@acm.org>
In-Reply-To: <a38bbe68-97e8-4476-a406-5c5228167e96@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|LV0PR04MB9789:EE_
x-ms-office365-filtering-correlation-id: c5a0754f-c788-497e-d8b0-08de3ebf87a3
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|19092799006|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?a1FJVHNpVmowLzcreUlzby9lV1RyZFhhUWIyYlV5b21sZTBoMnlINlh4a2dG?=
 =?utf-8?B?c3VLbUJCY0hoTnhCblRWdnRuTjVMeW1zamNqZnVBUWJDQXpESEdUWXFWeTRU?=
 =?utf-8?B?ZkwyQ3V0Yy9HQitKMW5tcDBNVFNQYktKa1hSVUU2TmN4aXdSbjIraUErcWFV?=
 =?utf-8?B?VUtiTTlnY3VHeXlCMVpoY1dNUWt1QUJHZ1pFVUxZU2xzY040R2FHNFErZHc3?=
 =?utf-8?B?bzhDWG83U2RlK3JHaVJmQWRmQ1R4V3A1U00xWFF1dVY4U05tT3pFUkdsMXJn?=
 =?utf-8?B?cGNaOTBBTFk3SGpmc0ZiTk9vZE9Jdm9lYTk5SmpjQ2JSSGNHVDFIRzNHUWhq?=
 =?utf-8?B?MmtpQjR0ZGpFMWZkQlp5ejFTS3IrMkVxbnpPOGZBK3hFWUpjOEpIQmpURTFE?=
 =?utf-8?B?Qk0vVThvYkVpRGYxdWRtQjQwZXN6K3p0TTFHbHZ3d2lFVDBBYzc5NUVidi9M?=
 =?utf-8?B?eXJoNnVUUHVqdGVGQmFtc3hhUmZFREVjNXNzLzVBQklQa1cwZ0w2Qk9qY3lx?=
 =?utf-8?B?bHdmUEt1MEdXanluNjZqbDBsTlZBWTdqblduaEdyVnM1QXBRUW9waGRVZ2JT?=
 =?utf-8?B?bmtLUzRsUDdKQ1Z5cllUcTd6ajZaVlRYVHl3bXZwWDdmNGZGOGc3Uk9mMWtQ?=
 =?utf-8?B?K2N4SEQ2dG1PWDlZYTF3RjZ5cWRhbUdBc2dNdUtwcGxIMXBKMng3d1lIMDkv?=
 =?utf-8?B?MVJ4K0hYY3Rad1JVZTFnaTFzb3hQbDNHQjVqUmJIVlY2UnNMUytrTTdZUUVG?=
 =?utf-8?B?bFBNLzRqbU1yVEFSSXQyWEN4aDFhcFl0NW53MDFvTGI1QU5XSWtCWUtZSUpG?=
 =?utf-8?B?VjgvZTFTRGVRMmF5aVcxdTY4bjg2YWRZT25LSFF0RVh4R1FXRjJGMEhVWDgv?=
 =?utf-8?B?L2dkWi9SdE5ON3FuVUhJRU1jNjUyTDE3SGVEN2Yzajd5TDdGWi90bDhPU0g1?=
 =?utf-8?B?TnlmemVxcWNyRWt1eWhnclVBeER0M2c2WExra0lhd1FPRWU2c2tCbTBiSHdX?=
 =?utf-8?B?QjJ2VzR0UGRlSmRYU2N4bldjWHgraEdmS2VTcGR4c0Z4MEM5WGVEY1A2bFJT?=
 =?utf-8?B?Y1BaV0hnNS85Ny9acmIyWlJZWktwbzA4WmloWXdOUzhjM09maW9tK3R5bU12?=
 =?utf-8?B?MWIyVHZtNXpjZmxhVHdDdFNYMFR2S200U0o5bHlSZnBkdno0ZDFzZU5ibFgx?=
 =?utf-8?B?eXBENm1hUzV0NHU5dUcvRkxDRStyS0dnWGdQWFdPU1RXenM4am5ES2NGL21v?=
 =?utf-8?B?OTRYRXN3UE9hN3RzZWRuSTNieUdOR2pvQ3VqNGo2cmxvZ2lDTjlNSVNFbk5D?=
 =?utf-8?B?TGMyVVdtZ253S3dTdnJTdVhsbU5jMG9OWlRoRHA2M1EwNWdxVC9sdWZxSFFw?=
 =?utf-8?B?MjBNNHYwU1g5aTBJNHZnNXg1NFpxakZ2b0Nia1FGTjdsK3dzMjQvc2I2SHVj?=
 =?utf-8?B?TVdtb2hhZlQycmE1dVoweEt0UW5xU2pPakkvc3ArcnlWbFczdlM3czQ1N0o0?=
 =?utf-8?B?QVBzVCtZWTY5LzRBUExHMFBmVEFuR2IzaXJyOCtZem53ajRMSSt4YXM1eGtI?=
 =?utf-8?B?U0xKUjMzM2NDNUJUNGUxWjkrUkNEdml6SFRuOFY5VGwzZ2FnTWZxOXNLbG0r?=
 =?utf-8?B?RWZKZDJVVkhPOStYZG1PbGRPRy9wNGFBb0RmOFd4VWlwMUtJeHdadWRCeDNp?=
 =?utf-8?B?Zm5mekFtbVUvNHVnUE13WXNRNCtlWmhkZmFCSlczNU5ta0lwdFg1em01N3Zo?=
 =?utf-8?B?NWZIS0tqS0M3NVlYOFc2L3Z5aTBwTlZkRTVxdllXbUhrZUhydWdTR0FhU2lp?=
 =?utf-8?B?QXVTRFF0S2s0cERLWXJ0RW5OU040dFo4RkFFblFtL3lKSGNnTThMbzJ0ZHFK?=
 =?utf-8?B?OEU4aWQxSGV3aG5YVlZvdkpKMTYwS255emV6NHJRN28wM2dwbWFWMlNITFQ0?=
 =?utf-8?B?OFltNmpIZnVHNzEvNWVZSnpobUZibzljNVA3Rnd1NUVPS1BxeWdBdHJwRXR2?=
 =?utf-8?B?UDc5eXdPK3JDMWJub1BodE5obEhvZkp1WXo0eWpKNXFHcEF4VURvS2dSVVZl?=
 =?utf-8?Q?EPgFv5?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WmtkeENMblBhNlNPc0NVRCt0K3N1bnZmTHV6SElJVlM0ekRkWWxHVHNaMDlt?=
 =?utf-8?B?aDdwRm5UQVpCMU5Wdk0vYU1BVkxWM0hUN1Q0YXFmYWZ2MWFvTnBJQTQvbTVO?=
 =?utf-8?B?YzdaQTlybDhRU3lKRDQ0ZytIdEF1ampoek9lQ0F1NUk3TEFqNGFkRER0b0o4?=
 =?utf-8?B?RlhuZ3VudXhLNHFiUmhXUm9UaUo2SDVWYzd4dktGbEllcS84a0tyTkdCVkoy?=
 =?utf-8?B?N3l5bVQrV3NsTFM2S0o4TGQ4ZUpkVjhtdSs4K2lmSUlzRjhNdUJ4RHdaTXF4?=
 =?utf-8?B?U2YyT2ZNSXhzMzhNVDg1dHV2MW9sd2hJS05md1ZPVm5FWVNleWxsbGhxaWdP?=
 =?utf-8?B?dDJzNVAyTmZuYUl4NUY0MUZTaFljeEJSeXIvTjlMY3lPS0ZDQnNnQmduL2NH?=
 =?utf-8?B?UnpVUW45TkJ4dzlqSDNHUnJKWGpRNzhtN1RVaExpSm0yQ0MyaGxRWFY4R2wr?=
 =?utf-8?B?bVlRcWlSSzhvTkNEQmo1U3R1dFZWZWNOS1lOVWhqeFZ5TXEwbGlmcjlFSjNZ?=
 =?utf-8?B?cEJtbmtCRmFGUlZKOVYvRmg0czNqSnMzbUIwTk9qMDV5SWRIQ25uMGl3RDNn?=
 =?utf-8?B?WDlRekJ2S0pLTkxPM3ZlcGJSd1pWVzVDZDRQeFZ4V0F6dlVYczhlbyswZ1Ev?=
 =?utf-8?B?MktYVXZOaFpEemdNcXg1d1BEbi9xUHJ2K2NXeDVrcGNwbVdIaWY2SE9NQk55?=
 =?utf-8?B?M2szZXFyc09qM2d2Q2syT1ZZd01yNVBtNElaVm9zRkwvby82VEtDMnZaVy9Y?=
 =?utf-8?B?ZjJnU21rSEVDSFJybkw5eDhtNEZHUHp2T3pCTWp4TlREcGczR2VYS0RqREdh?=
 =?utf-8?B?b1hIM2hkdGtPMUtmTEw1NFRoV2ZQNFFlQkk3dFR1MitlTkpSWVNYNVpPYlNM?=
 =?utf-8?B?RlZqUmY0eUQrUVR3OXNHRlZSdWRtbHFvblZ2Umdub3RGZW90bFFMMXc3MFpW?=
 =?utf-8?B?UEdOWnY4Y0RRSndpQnlCRm5QYVdyOHpIMmlwZTdDbytGSFRWMW1MTUk2Yzg1?=
 =?utf-8?B?TTYxRHB3MFZ5cmFDQ3dVdkpTeXphNStPMENsZklyNFNmeExYVnM1S21nckdw?=
 =?utf-8?B?ME5YUTdpNzV6bjJqcXZnOFQwTDJEZGJrWGc0eXFoZ2krL1REcnZJSi9ENHJp?=
 =?utf-8?B?VUNWN1d3N1dEZU0wOUhvdmdhTmJqK1BtK3IrVlBJR2pkWmtOYWhuSW1GdEd6?=
 =?utf-8?B?bll2bE5QQ3JmTFI0Zm10dXRCNUtoRGpYWEFINUkvSTlSWlVzaTc2a2w5eFBM?=
 =?utf-8?B?TmIwWDI4aXNvbmV5MmhmdlNQMFhvVGRMKzEwcU45eU5NaXYweHdHcmQ1VmpR?=
 =?utf-8?B?bnNWZmVmWGg4ZWQrdGFxcHRFUDBmNjFPWFpuMXRTR1c2Vm1oOWVaamx1ckwv?=
 =?utf-8?B?S2pkTnNtYXh0SXV5ZmlNMnZkd2NUc0h2YnJVWm5zOFhwZWdWcUNvOU1CMGFM?=
 =?utf-8?B?VUthOWVYbXBweHpuaW83MFg2VGkwOG8wQ243OTljM3JxNGx1eHdrTDVEdWZu?=
 =?utf-8?B?bVVwbkxJWXdoTlJCSFJvNmw3UTc5RzJTNDVqcXlsL3RzQWltbExvclpISWRZ?=
 =?utf-8?B?VDJNdjVubUliMmVER1hreTVrR0xsekRJOTB6Myt4ZWVJTGhqM2JFZjJsNk9j?=
 =?utf-8?B?VHErMURzRkhlUFpyZHlJS3lKdEhWblJ0c3M2azhmcitIY2VQV2FBc3BRZFM4?=
 =?utf-8?B?aDZSaEx1cE51SWVkMEhoZ0J4Qlc2QmFqVDZBRkwzbklVMXJTSWVxVVNsQ0tQ?=
 =?utf-8?B?c2FzOUNLOEJPZ3Q3NkRTZjBFeU00OVRQMFZ5Q0YvQy9aSXRUdk4veVdReUw2?=
 =?utf-8?B?ZEkzNk1PQnBzUmxZSFBZa3pEbnIxVzNPQVhyVDdMTXp6ZDh4NTROQnVCcnVR?=
 =?utf-8?B?T1hxME55MTFHY1NYQzd5ZzAvalplWjJlRDl5bWJ2T0pCeTVFdExXUmZVVnEw?=
 =?utf-8?B?WFcxOWlQNEhLYzU1S2ZUNHBEQ04wWmRCUWFYN0xNTGFIRktxS0pOdkZKZVpa?=
 =?utf-8?B?aHV4QlRJdGJwMXRZaHpHWkIyZDJDU2pFeXRtNVFtRXpxN1FMK1NTbGVEVTBZ?=
 =?utf-8?B?djMyb1FnZDE3cG5ab20wM3hlSC9iaUZETXAwaitDQTMwZy9WV3lYR3BsUUtG?=
 =?utf-8?B?cFVZMXZVSGN2dmJQbUM2a2lPVzd0UjB2ZUdyRk1MekhWYzhWZ0VXMVRrZTln?=
 =?utf-8?Q?/hB4vfsimMQ9pXw945qc3eQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DFB0102E770FB04EAE8C67BBB946B649@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6C5XONYUDGb1DocBEIFXfNHVcjxpR3rLVL24Ra9YgvqPwMAnJ4wh0UGKh2P254/U36YCXa33qtJaKCMyggdzHU1ytYMx75v8r9WeLrkiZb3jetFl96It4ddELM++VMlKqMZ4aY5v+VrODP+VclkzhrfkohTv9A0267WnZPb3NdQ+aL1r3SP/Glm76kFrAU9FgvBVlzAE+X3nuE6B1mpEKIz4JF9RvHxWnhmgJE8q0e+E9Fa4d8yfsaah9h/vOjpBPTKR1X+kRahAhx2Xu5Qf+95/8lLS8noRR7cs/R9oYmpKJQr/6JNsBqOJtE6njuT+ePr2NWXIRnyPHULJSALJDS5outHzI8Tbvo2MuWyK7ICteIIo1FF/fGMLOmuvUgBAtdYA+nxREJrbZvMmNpKD3ewzzmkr23zicBoC+RX0rF+hSAIvvlQBUk3mNZI4FA640og5k/OTY40rE00YxrJF5qZ/LT8NmAB7Wy/YfFxa/veYF01Z1kmZ2bDOxxxs84foVfOMU27gKYBhZaZ8mK+G36CDejHyG45oemvjOC1QucR4WHsyq+YbgChl9r25VXsH8b9ypQPI7nz8LqMmqKtaef5/1Sl8s3ySG39mZ2s2QylmDX8aocmmVWWY7A23JtwI
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5a0754f-c788-497e-d8b0-08de3ebf87a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2025 05:29:06.8455
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cFpDLPti9D+LS8a1RKVjfPknAIPdxa7ItB5T8YKhALLd+W8XTIyO2GXpZa9KR0ZG2JMIUe207j3EN1gMXes4Jjf8KTxxudSErdjct2XrPJs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR04MB9789

T24gMTEvMjcvMjUgMjo0NSBBTSwgQmFydCBWYW4gQXNzY2hlIHdyb3RlOg0KPiBPbiAxMS8yNi8y
NSA5OjExIEFNLCBMdWlzIENoYW1iZXJsYWluIHdyb3RlOg0KPj4gTG9uZyBhZ28gYSBXQUlUIG9w
dGlvbiBmb3IgbW9kdWxlIHJlbW92YWwgd2FzIGFkZGVkLi4uIHRoYXQgd2FzIHRoZW4NCj4+IHJl
bW92ZWQgYXMgaXQgd2FzIGRlZW1lZCBub3QgbmVlZGVkIGFzIGZvbGtzIGNvdWxkbid0IGZpZ3Vy
ZSBvdXQgd2hlbg0KPj4gdGhlc2UgcmFjZXMgaGFwcGVuZWQuIFRoZSByYWNlcyBhcmUgYWN0dWFs
bHkgcHJldHR5IGVhc3kgdG8gdHJpZ2dlciwgaXQNCj4+IHdhcyBqdXN0IG5ldmVyIHByb3Blcmx5
IGRvY3VtZW50ZWQuIEEgc2ltcGUgYmxrZGV2X29wZW4oKSB3aWxsIGVhc2lseQ0KPj4gYnVtcCBh
IG1vZHVsZSByZWZjbnQsIGFuZCB0aGVzZSBkYXlzIG1hbnkgdGhpbmcgc2NhbiBkbyB0aGF0IHNv
cnQgb2YNCj4+IHRoaW5nLg0KPiANCj4gSXQgd291bGQgYmUgYXBwcmVjaWF0ZWQgaWYgInRoaW5n
IiBjb3VsZCBiZSByZXBsYWNlZCB3aXRoIGEgbW9yZQ0KPiBzcGVjaWZpYyBkZXNjcmlwdGlvbiBv
ZiB3aGF0IGFjdHVhbGx5IGhhcHBlbnMuDQo+PiBUaGUgcHJvcGVyIHNvbHV0aW9uIGlzIHRvIGlt
cGxlbWVudCB0aGVuIGEgcGF0aWVudCBtb2R1bGUgcmVtb3ZhbA0KPj4gb24ga21vZCBhbmQgdGhh
dCBoYXMgYmVlbiBtZXJnZWQgbm93IGFzIG1vZHByb2JlIC0td2FpdD1NU0VDIG9wdGlvbi4NCj4+
IFdlIG5lZWQgYSB3b3JrIGFyb3VuZCB0byBvcGVuIGNvZGUgYSBzaW1pbGFyIHNvbHV0aW9uIGZv
ciB1c2VycyBvZg0KPj4gb2xkIHZlcnNpb25zIG9mIGttb2QuIEFuIG9wZW4gY29kZWQgc29sdXRp
b24gZm9yIGZzdGVzdHMgZXhpc3RzDQo+PiB0aGVyZSBmb3Igb3ZlciBhIHllYXIgbm93LiBUaGlz
IG5vdyBwcm92aWRlcyB0aGUgcmVzcGVjdGl2ZSBibGt0ZXN0cw0KPj4gaW1wbGVtZW50YXRpb24u
DQo+IA0KPiBIb3cgY2FuIGl0IGJlIGNvbmNsdWRlZCB3aGF0IHRoZSBwcm9wZXIgc29sdXRpb24g
aXMgd2l0aG91dCBleHBsYWluaW5nDQo+IHRoZSByb290IGNhdXNlIGZpcnN0PyBQbGVhc2UgYWRk
IGFuIGV4cGxhbmF0aW9uIG9mIHRoZSByb290IGNhdXNlLiBJDQo+IGFzc3VtZSB0aGF0IHRoZSBy
b290IGNhdXNlIGlzIHRoYXQgc29tZSByZWZlcmVuY2VzIGFyZSBkcm9wcGVkDQo+IGFzeW5jaHJv
bm91c2x5IGFmdGVyIG1vZHVsZSByZW1vdmFsIGhhcyBiZWVuIHJlcXVlc3RlZCBmb3IgdGhlIGZp
cnN0DQo+IHRpbWU/DQoNCkkgYWdyZWUgdGhhdCB0aGUgY2xhcmlmaWNhdGlvbiBvbiB0aGUgYWJv
dmUgcG9pbnRzIHdpbGwgaW1wcm92ZSB0aGUgY29tbWl0DQptZXNzYWdlLiBTYWlkIHRoYXQsIEkg
ZG8gbm90IHRoaW5rIGxhY2sgb2YgdGhlIGNsYXJpZmljYXRpb25zIHNob3VsZCBkZWxheSB0aGUN
CmFwcGxpY2F0aW9uIG9mIHRoaXMgc2VyaWVzLg0KDQpTd2FybmEsIEx1aXMsIGlmIHRoZXJlIGlz
IGFueSBVUkwgdG8gdGhlICJmbGFreSBidWciIHRoYXQgU3dhcmFuIGZhY2VkLCBwbGVhc2UNCnNo
YXJlLiBJIGNhbiBhZGQgaXQgYXMgYSBMaW5rIHRhZyB0byBzaG93IGFub3RoZXIgcmVhc29uIGZv
ciB0aGlzIHNlcmllcy4NCg0KWy4uLl0NCg0KPj4gKwkjIENoZWNrIGlmIG1vZHVsZSBpcyBidWls
dC1pbiBvciBub3QgbG9hZGVkDQo+PiArCWlmIFtbICEgLWQgIi9zeXMvbW9kdWxlLyRtb2R1bGVf
c3lzIiBdXTsgdGhlbg0KPj4gKwkJcmV0dXJuIDANCj4+ICsJZmkNCj4gDQo+IElzIHRoZSBjb21t
ZW50IGFib3ZlIHRoZSBpZi1zdGF0ZW1lbnQgY29ycmVjdD8gL3N5cy9tb2R1bGUvJHttb2R1bGVf
c3lzfQ0KPiBpcyBhbHNvIGNyZWF0ZWQgZm9yIGJ1aWx0LWluIGtlcm5lbCBkcml2ZXJzIHRoYXQg
c2V0IHRoZSAub3duZXIgZmllbGQsDQo+IGlzbid0IGl0PyBTZWUgYWxzbyB0aGUgc3lzZnNfY3Jl
YXRlX2xpbmsoLi4uICJtb2R1bGUiKSBjYWxscyBpbg0KPiBkcml2ZXJzL2Jhc2UvLg0KDQpBcyBm
YXIgYXMgSSB1bmRlcnN0YW5kLCB0aGVyZSBpcyBhIGNvcm5lciBjYXNlIHRoYXQgdGhlIC9zeXMv
bW9kdWxlL1gNCmRpcmVjdG9yaWVzIGFyZSBub3QgY3JlYXRlZCBmb3IgYnVpbHQtaW4ga2VybmVs
IGRyaXZlcnMsIHN1Y2ggYXMgbnZtZS1mYyBvcg0KbnZtZXQtZmMuIFdoZW4gdGhlIGRyaXZlciBk
b2VzIG5vdCBoYXZlIGFueSBwYXJhbWV0ZXIsIHRoZSBkaXJlY3RvcnkgaXMgbm90DQpjcmVhdGVk
LCBwcm9iYWJseS4NCg0KT3RoZXIgdGhhbiB0aGVzZSwgSSBwbGFuIHRvIHJlZmxlY3QgdGhlIGNv
bW1lbnRzIGJ5IEJhcnQgdG8gdGhlIHY1IHNlcmllcyB0aGF0DQpJJ20gcHJlcGFyaW5nIG5vdy4g
VGhhbmtzLg0KDQoNCg==
