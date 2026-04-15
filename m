Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFFC538655F
	for <patches@lists.linux.dev>; Wed, 15 Apr 2026 20:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776283554; cv=fail; b=Ny82AFwh9/LMfIN/7bMr8YRguUMq41fyA0/1qpHkCUNET1loACEV45O7rcfwWA/3M+9VLdWkfUeekuwCMM2dP+9OmJP+jnZieMM51hWiQhfD0Kt3d1meoMc4jTwdvQA7aLcSC5+U9Wv86ZV3W5rmgKp9Ljh9Idf9V77HBUBTGKU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776283554; c=relaxed/simple;
	bh=Ot+hObZqni8qe0cjzxSc8Y1VvXtMj9IbIjrb/dT10h4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=P44oMIm3nM+CvvRLYuk/zVZQIK6hkkUftMi4vCo6priZqCZ27idQ7f8vPcuBr6hyIPtH3Cz3S0/KU1vR8MsHp21+VVxpZe9TkLA9kjIes7FYgWGw1HWr0HW84TW+nVah1u/SsPj79ma54+TNXyzMWiyGUONTfcyMVTyyP7vazy8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YOPppI9f; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YOPppI9f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776283553; x=1807819553;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ot+hObZqni8qe0cjzxSc8Y1VvXtMj9IbIjrb/dT10h4=;
  b=YOPppI9f01TLSbaOQ9SdWTHoFCfXl4oKJES5Jma1aE32H/6SehxEMzGx
   wXHxsEqRpX/GI0+0Qh8l52ew8aHc1179W2vw/zVrju9x5e4qaXxa/rikD
   U3OrKpCB+cCOyawTPfB0lpw87+p6oibydevw6bl9D+rKCL0J8xH1u6WY5
   zzeWISLYJJ/a00hHn2FXwcm2lO97bHgCTr7yJxEdgTBpcrHnTonTHBCWX
   0ou+4NMSvH5JB8Wnm2oNEfDjblOg/PbWY+wiy1fa0alWqiJmqKXZUMpoA
   HsIopqRjqZbR/aTFfrbFEKH0fYZkqubqbLSn8GuDrZ0MBv7rS+9nQz73t
   Q==;
X-CSE-ConnectionGUID: DYhA2m4RQ7OkeAV72NqTwQ==
X-CSE-MsgGUID: rasHYpD8SP6MQtgGT2g00g==
X-IronPort-AV: E=McAfee;i="6800,10657,11760"; a="77150061"
X-IronPort-AV: E=Sophos;i="6.23,179,1770624000"; 
   d="scan'208";a="77150061"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2026 13:05:52 -0700
X-CSE-ConnectionGUID: lk1Wm9FnQvqd5TsUPGxaSg==
X-CSE-MsgGUID: 5TCenNELSRatqZChQvfZNw==
X-ExtLoop1: 1
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2026 13:05:52 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 15 Apr 2026 13:05:51 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 15 Apr 2026 13:05:51 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.60) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 15 Apr 2026 13:05:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aLCsd8N65qh9YClIJIYO79txuNWqdvhLuHuZ5r54QikgKQC4N2bBdGPUPqfzzkeknqqIQg4O10u4xqTbXC5YXnkTlLxsMMWrkvkcEj4E8mQZr5KGOFcmYUcQrt03ci+Z+Jx1SGYTQNTwZ1FJNeILSDb0wr4J/xiElMCQxJ4LI8ejv/YzUmNavmJnCztfhZaviQTVozh9TEua4iOA5k9y5d/kubYApSWT67oVLeQ+c2E94CrCi8goI3wXWmad1E26fdOFztFMNG/XoqJ6eeTLGRrGqG/1o2ciEjmyNB7mHPdk8JS448jRj/UGkf5Ih+G+zFaPga8BGprhYoyFMfMVxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ot+hObZqni8qe0cjzxSc8Y1VvXtMj9IbIjrb/dT10h4=;
 b=aYN5sUBDfhTRlxqz8cb2M85q1aCwmRcfAKq/gu28xuMglSMsLVyW9jRA9W1hAxJvWdQalUuvgOwfipkJteelu0FDgO+oOKE3N33y7Mr8bbWDb/Vf06fDKMp0w/+ugUiduwy7sVKqkKIX/krcYRFIx4p10h7LNQjv16mG9zrXJXSKPxkiDG+rOU5SxGoButmQZ2Sweow+lbqPCMOpoVVRkjLT5KQpr1Qi0bNSn/8nrN8tHMsn5ptm/POdTxAMwwS/apfpphXKzjMZkheiTw2Oq3hVK5QxNdCfPYImfbLInsstAQnjNe9OVFIjixQm9keyQVoHi5yJjGzXz9RJWsVnwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SA0PR11MB4768.namprd11.prod.outlook.com (2603:10b6:806:71::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Wed, 15 Apr
 2026 20:05:49 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9769.046; Wed, 15 Apr 2026
 20:05:48 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Jiaqi Yan <jiaqiyan@google.com>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, "Li, Herman"
	<herman.li@intel.com>, Zaid Alali <zaidal@os.amperecomputing.com>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v2] ACPI: APEI: EINJ: Fix EINJv2 memory injection
Thread-Topic: [PATCH v2] ACPI: APEI: EINJ: Fix EINJv2 memory injection
Thread-Index: AQHczP6ZIr+DSloHlEG5vW6nMKqsorXgaWIAgAACdwCAAAywAIAAEZ8g
Date: Wed, 15 Apr 2026 20:05:48 +0000
Message-ID: <SJ1PR11MB60834D8CFE5F63FBF9C03104FC222@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20260415173735.24437-1-tony.luck@intel.com>
 <CACw3F522f6p-x6MEU8t7CEoU1P=PtU8dKy7opKjH8sOecdF1kg@mail.gmail.com>
 <SJ1PR11MB6083BF86FFA17D90FBF86686FC222@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <CACw3F51QuexjytfyCFZe6uRaWqMKbQwrG9qFCvArf--xEr-9jQ@mail.gmail.com>
In-Reply-To: <CACw3F51QuexjytfyCFZe6uRaWqMKbQwrG9qFCvArf--xEr-9jQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|SA0PR11MB4768:EE_
x-ms-office365-filtering-correlation-id: b78b26d8-794c-4f33-815d-08de9b2a633f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021|56012099003|22082099003|18002099003;
x-microsoft-antispam-message-info: 14enfRARjTabK/XLxWy7mR0dbzJ7wSLEvw5l5j4iNjQqm4BNF/nBvvkUA44upZSrBuYlEnG/149K5QebRpL4eaKpVlhswOArL7X6sHeaPz8DyFwdLSvI9fLWZo7mHsWahkABquPodlfmVXLN0AjC5yQCdHLUaLEQDHwbwVFFpdmYQQ+5ovyWhR7get8cNFzp75K5GMvPv+7+DySnFB2gf9yVTTLulxSN4WVK107Wes8mImbVUxFfynI/7ZiqCCjCtAa9h+zXaxZGXrWFNbkG0SkvvWPXR6HszN4gUXvXJSn+aA6hBM1KlAc9JDviliP6PD8CgQxFAzyeh37Usk9bSjHaTF7sHugBn3hJG658hebEjLeULqpUxJic17vxUqaPI6E3RJdYOBFKs9zBStq2FlG14+V5qSKtnefl6QHnOvaU7s0Y9BtJENE/K6oUc3uDhIeKFWjj6iMsJYlpHPUT6uS8RvdHMoVulg7AwNCJho1sFUdCyc/DSLNk/ojPKALMECVJ7L6QrSaQr35F6upiSkbli550zrNEXZC/kSf8PsfYRsZ3356E7H4lJVv3uwBdKy2AYZt2zU/Mco7apoAGkm65syOD0zGSq8C6GqHrGlJjmDEFNSCebs7uWK39uf6Bts/L1FAgzAPcu8z5uf4QmzQHo6cGllWHil7peH8slC4JsG2p5AgcKCgVHzy3R4Whe+DAtmgKL7Vl79QnGjUMI5lT0uDLKl4ctFCBg2e2nlg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TnM3aUs3aVlZTEhsaW9qNkdVRzZrY204OWE2Y1lGNC8zdnZsUHlxNDlXd3cw?=
 =?utf-8?B?WkxaTWxRaXVsNW9wTkdHS01zK01ZamtJQ29UR2pBV3JRVUJBN0kwci9oNDJF?=
 =?utf-8?B?eGF3Y3lwZXFkQ3ZabVhDd2JqQUpvenlyYkU5SVFBWlRab1lreFBUVGJzRlN3?=
 =?utf-8?B?R0tURWZ3QmtCS01zcWlMSksyNVVyRCtVMWg5SEhrcDJ4REFsdElDeFN3ekJJ?=
 =?utf-8?B?Z3FXTVg5U0lZVnBScVRRUjJtZmI1QjF5VytFY2ZCc1dSdCtSYWhmTkxWamlH?=
 =?utf-8?B?eE5MUEdUZWhRdVYxWTIzN1JEQ2VKY1hub2hndDhZVFlMbFA5d1JQQW1zTTFE?=
 =?utf-8?B?b2RsQlNkWmhUbHBVQ1lOMnFCaWYzZFdXdUpIanZld3JoY2s1UVV1UkJZdlYy?=
 =?utf-8?B?M09JaTM1eWpxai81SllFWmpPS1F0ekxKWFJlUXVVK1VabzkrS2tzRGM2L3pY?=
 =?utf-8?B?UnQyVUJjZnFYV2I5VGlNRHZRQTJ1WEZiY3VmYi9uSDVQc3F4QmgycEU1NWpw?=
 =?utf-8?B?SkM5TFhrOHRzNGQ4bWVzVEFPVHlIN2NjSWlrVVJ1RkMzMDQ3SXFWaC84MGZk?=
 =?utf-8?B?ZHVVNzlvWU0xYXZHS3NnV2ZxeDI1VHdBNFNRV1lZTkdrd3Rkdjk4VUUyUXB1?=
 =?utf-8?B?bHRueFh6c3hwYXRmdXRUZGdhcmN3eE15Z3laYTQ1eFA3ZFBHOVAycmJCcWI0?=
 =?utf-8?B?SzZnWGxmSDJ6dDBySWIwUjhpUjhxaEVMYm92NUJwL3dpY3RuVFZ2RnZjMzRt?=
 =?utf-8?B?SzJPUDlDN2JucER6S1VESDNWckR0N1B5enN1bWdxU3RJNDBiUmNNbGVHWVFk?=
 =?utf-8?B?WC92NmwrMFhBOW1SbWE0NVplanFOdTZ4cUMySTVZUDFJTThWWE5lNThnNTJL?=
 =?utf-8?B?Y05YNDl3QWNyR2ZJeGozaGk1TFdrRWp1L01nNytvbWl1cnhIVHZTVjhKOHhj?=
 =?utf-8?B?eHRJT0tPVDFKQnB3RzN0NlVVb0xYcVIwUVAyS3EvcEFOekk3MlBSQmNyWWx6?=
 =?utf-8?B?eFlQQmdQNElXekpSMUt3dkhNZUdvZ3JqSG5xcXp4ZnJyT0tWVngvSVJENUls?=
 =?utf-8?B?WmVZQ2J4Mjc0WmxyTVFPZTFjQWhiMkVCSDZaVG1OQ0lxUzk2YVU3c2UyZU5W?=
 =?utf-8?B?SWhuYUliUnhLbkNJYXFWdldQNEJkazJmTjU1T0lBc0tYbnpXU25NdTNJRFdi?=
 =?utf-8?B?TjJ1eWx3Qk5BcG1UUS82Q2dQVkU1RitMR2F4QWF3c3lKZlI2eE9kMi9scWVE?=
 =?utf-8?B?T3Y2Mzh1eFRna1BqZmN3MVVBNUxiK2VkdlZHOUkrb3NSOWRHb014UzF6alBp?=
 =?utf-8?B?QVJwMEg0YmNvTEpvckoxSUJPbStHU01VcU5QZlo3bjZnVnppaTFoQXlnVkFI?=
 =?utf-8?B?cWVYL1ZIN3J0UUhJdGlLWjNmb3o1cmJBSGJTVmd4eHd1a0hwcUhRdXFOYU5h?=
 =?utf-8?B?VTBrMVp1T2ROMHF3NHV0bHJFOVc0dzM2RG9vSnNjNUVWZnNrdnNqMjU3VUZk?=
 =?utf-8?B?d3dSb3ZHcGZBb2JhSzdEaksxa3ZvMkJlUjhyUkY3U0N5cFVpVmFHdkxkN1BS?=
 =?utf-8?B?MjEzdEJ0TkFFSVY1MEJWWTJtRm9ndUQ5eUFGY1dUU1FDWFRCNm5CdmVMVHV2?=
 =?utf-8?B?b090aXlWc1FNYkNYUWFLUzZldHhtL1AvR0NUMGtiZEU0V0s0MTRzYW1zNTdY?=
 =?utf-8?B?Zng2WDM5dFpJUng5RjcxQ1RMVWY5K2h2NThMNVU0SE40TldvZjQ3bklLMU9h?=
 =?utf-8?B?MHJ4MUZTVTRFTlZ3anFuYzlLQXJYWXdGajdDSFlLTW1MUS9hd0FveE1BOFli?=
 =?utf-8?B?MkhjYTdweVlWR3NaanMrcGpIOExSOUp3T2VPdXRBN1pnenpkTCtoMkRCbUQz?=
 =?utf-8?B?d1BKM1ljSkprYjhrdGJvcFFpTGIxU0xEOGRyRElkZ01iMVc5ODJnL3FMdnBT?=
 =?utf-8?B?N2pETjZyQnFuWWNvemk2OWNqbFZDV0twbHdGa3doenowOGRSa1RnYkQ2UGxG?=
 =?utf-8?B?V1JhUzNJQVp4Y3EzMG5OT0l4Q0FTOXBLKzFZQk5oYXBreVRnZXpZWnA2Z2M5?=
 =?utf-8?B?V00vZk9MaUtXamV6bFVnNTQrKzFwZHBadUZXTXMyb0FhM3F2QlBXWE1GMGNO?=
 =?utf-8?B?N3VVaGRtdjVTVlVwRTJEOTF2REhRZ3VDV2dBejhtcmxrNTdWcU5tM0gwNi9E?=
 =?utf-8?B?SW9zNktucE9Wa3N0K0Jja3RBaGxjdS9teHNNeWpSbzVrNThXQjJERkgxRXV1?=
 =?utf-8?B?NUdIamlIazYwRnUxZXd1N2Z0a2RIZC9JT2FQK2xwbGZnU0s4OFB6RlU1U1Z5?=
 =?utf-8?Q?+u4LaCIJC16J4+SuTX?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: YtBT86oK9YTKKGj9jgqj8IUvKInCQiVOXmQ9Vw71ipk7jKw9zUiqaqE9+v+C7NwysO4fcFNbFf6mMdBmsGg09twVa3e33LTIxTv1oWWVCPrQJsEm8d5cuOC4xfwiWhYr7IxMIdwosCM+DmkEqY6KWo2j8/rzcPI6vCgrvadFXjAkSlwji8qabkEEviWSJUPIYFLp8A6zuQnvG1YtWO9OmUMnvZLjssSok38pTrtKBFyhk5FLbO4KtUXc7tYO+81RSvi3Rkh43MU6UkBQ/o10UkCjuMEZBa+i+cGRNQVIGGZH8/thzMCh5nSJ9hwCMwIjBn9S7tKO8EIV1BTq/Srpug==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b78b26d8-794c-4f33-815d-08de9b2a633f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2026 20:05:48.8793
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rucWISyPm+a6sHXZfFaFJlkJiWRdEeY+BFoDlFvF/pq82uDDKN9Ey0wls5xxJy0eWbLgAC+LBwcLOWiKXrHjMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4768
X-OriginatorOrg: intel.com

PiA+ID4gPiArc3RhdGljIGJvb2wgaXNfbWVtb3J5X2luamVjdGlvbih1MzIgdHlwZSwgdTY0IHBh
cmFtMikNCj4gPiA+ID4gK3sNCj4gPiA+ID4gKyAgICAgICBpZiAoaXNfdjIpDQo+ID4gPiA+ICsg
ICAgICAgICAgICAgICByZXR1cm4gdHlwZSAmIEJJVCgxKTsNCj4gPiA+DQo+ID4gPiBIaSBUb255
LCBqdXN0IGEgbml0OiBmb3IgcmVhZGFiaWxpdHkgd291bGQgaXQgYmV0dGVyIHRvIGludHJvZHVj
ZSBhDQo+ID4gPiBtYWNybyBmb3IgQklUKDEpPyBsaWtlIEFDUEk2NV9FSU5KVjJfRVJST1JfVFlQ
RV9NRU1PUlkNCj4gPg0KPiA+IEkgdGhvdWdodCBhYm91dCB0aGF0LiBUaGUgb2xkICh2MT8pIEVJ
TkogdHlwZSBiaXRzIGFyZSBpbiA8YWNwaS9hY3RibDEuaD4NCj4gPg0KPiA+IFNvICJ0aGUgcmln
aHQgdGhpbmciKFRNKSBtaWdodCBiZSB0byBhZGQgc29tZSBWMiBkZWZpbmVzIHRoZXJlOg0KPiA+
DQo+ID4gI2RlZmluZSBBQ1BJX0VJTkpWMl9QUk9DRVNTT1IgICBCSVQoMCkNCj4gPiAjZGVmaW5l
IEFDUElfRUlOSlYyX01FTU9SWSAgICAgICAgICAgICAgQklUKDEpDQo+ID4gI2RlZmluZSBBQ1BJ
X0VJTkpWMl9QQ0lYICAgICAgICAgICAgICAgICAgICAgICAgQklUKDIpDQo+DQo+IExvb2tzIGdv
b2QgdG8gbWUuIExldCdzIHNlZSB3aGF0IFJhZmFlbCB0aGlua3MgYWJvdXQgYWRkaW5nIHRoZW0u
DQo+DQo+ID4NCj4gPiBSYWZhZWw6IERvIHlvdSB3YW50IHRoYXQ/IEkgY2FuIHN0YXJ0IHRoZSBw
cm9jZXNzIGluIHRoZSBBQ1BJQ0EgdHJlZSBpZiB5b3UgZG8uDQoNClRoZSBzYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCBhbm90aGVyIHNwb3Qgd2hlcmUgY29kZSBpcyBjaGVja2luZyBmb3IgbWVtb3J5
IGluamVjdGlvbg0KYnV0IGlzIHVuYXdhcmUgb2YgRUlOSiBWMi4gSW4gZWlual9lcnJvcl9pbmpl
Y3QoKSB0aGVyZSdzIGEgY2hlY2sgdG8gc2VlIGlmIHRoaXMgaXMgbWVtb3J5DQppbmplY3Rpb24s
IGlmIHNvLCB2YWxpZGF0ZSB0aGUgYWRkcmVzcyB0byBhdm9pZCBwcm9ibGVtYXRpYyByYW5nZXM6
DQoNCkxpbms6IGh0dHBzOi8vc2FzaGlrby5kZXYvIy9wYXRjaHNldC8yMDI2MDQxNTE2MzYyMC4x
Mjk1Ny0xLXRvbnkubHVjayU0MGludGVsLmNvbQ0KDQpJIGZpcnN0IHRyaWVkIGFub3RoZXIgc2lt
cGxlIGJhbmQtYWlkIGNoZWNrIGZvciBpc192MiAuLi4gYnV0IHRoZSBwcm9ibGVtIHNlZW1zIG1v
cmUgc3RydWN0dXJhbC4NCkNvZGUgcGFzc2VzIGFyb3VuZCAidHlwZSIgYWxsIG92ZXIgdGhlIHBs
YWNlLiBTb21ldGltZXMgaXQgbWlnaHQgYmUgYSBWMSBiaXRtYXNrLA0KYW5kIHNvbWV0aW1lcyBh
IFYyIGJpdG1hc2suDQoNCkknbSBnb2luZyB0byB0aGluayBhIGJpdCBtb3JlIG9uIHRoaXMgdG8g
c2VlIGlmIHRoZXJlIGlzIGEgYmV0dGVyIHNvbHV0aW9uIHRoYXQgYWRkaW5nDQpjaGVja3MgZm9y
ICJpc192MiIgYWxsIG92ZXIgdGhlIHBsYWNlLg0KDQotVG9ueQ0KDQo=
