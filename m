Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50DA3DC4CF
	for <patches@lists.linux.dev>; Mon, 30 Mar 2026 22:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774909133; cv=fail; b=h2ygDUCryCzC/FlAlVWbSjHgta/nB72b0DB3TuAUo/UCEXTS/UJbTS9/dePd/Rc8wccbe5XIY2zdds41sap/660RwX9pTVm01mvurM0/59hKQmHmuuHLW9fCiUlTe/HyQykbmsFlBkUp5jDnjVagtUByHxtjf8sqX4tsEXwZ/+o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774909133; c=relaxed/simple;
	bh=SpMKXr0aZBv5cFFqrrM+XL9tYaScLK9Y5WR+BfwKTCw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RdK/TXpuVtHnkC21v4erSDsW4QgyQ4K5zSN+Rfvkq8EKQm2Uc8heasTuatYW7qTntctdXV27fzRDuJD/s0mpaj1EZaVh13JaehgZQXzaekjlzw5+0A2nj5jTbiPN+NE5oinOOf0vL8Sa8kvhwHa6FBAlq/9kDxvx/uv+w05Y5lM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Sb5grRsm; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sb5grRsm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774909126; x=1806445126;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=SpMKXr0aZBv5cFFqrrM+XL9tYaScLK9Y5WR+BfwKTCw=;
  b=Sb5grRsmpQ99inl1JUMEsmE6/oW3qJqZHK3vXP5X/f9CYWaujTyADFpO
   DaUEf5NoxVIurwP8DRNZnBH5esgi/YjEo8DIyXV3qgvap+c6LlWMpryK7
   ikn2cpQ99gaNQ9khZp67CwKUeBUsjzPEOcOZ+IH6HKq0/e050SppXiQ+Q
   IFbCrKV4a7eZnkjjCZf6znr4kODa7ADlf1WgziUcGt7GreZmMgVyWsBP6
   kbR/tXUXwNgT0vYLkNGdre4lKNNLwierjjKH3QeoYKN99KhdPwJgYOaHg
   3K9EZO6GDS8XoJeR8wjT7BXrIr+o6CbsSj0wIZXY+0Z/vM2YlzdtgJrPz
   Q==;
X-CSE-ConnectionGUID: On03ZI0lR2KSqD3ZGkhZ1A==
X-CSE-MsgGUID: /cA25NquR9ieQ4xrbhie3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11744"; a="76024258"
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="76024258"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 15:18:45 -0700
X-CSE-ConnectionGUID: KbJccT9oQzWOfhmArS44iA==
X-CSE-MsgGUID: pq514jDCQ3WxqlZYVMxxLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="256680854"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 15:18:45 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 30 Mar 2026 15:18:44 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 30 Mar 2026 15:18:44 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.65) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 30 Mar 2026 15:18:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FTPvw1IspPH4vXmD6dR9tUE3nVXDawYG+4tdN49nPELgzpd9+zha88fJ9SgdI4TruzRv57ecTr4QYoRFqdeeHpZm40Kf9CiRQnSgXDwsQfXkQ4sr4W0n/ps1ISh3XgDXgkRW6AK9L7O66Spb+F+sKQP+M3lfVCfUijv4qoE0t1utUTtshn/CZy3gbxXZ2js3O2iqgIvkowYzOdF0Zke/8QJ/Lpv+NZUpF43E3V1GUSuyVwjPXjQTeMJ1pPznxoBgHIPIgKUbe4WG8sfymepOlxoKIbuy9OykDx4VxU89NuLrZhm/UrVptOKXWQl3Zjlnin9R87JlYAvBrkvyyDENmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YFZdMvu+xHBtJeUUvn9dAVRKS7IhXmAcSeoycQn1pJg=;
 b=IiAbYeabJ7YoQVWLnNzgNIlIvjA9hTa6aAuEZcg7D94DWuPgxkTFHJqYMK/DAlLxDbJCqdcDXvZbekkWJow5G5XQ/qEVxzjIBQrFmv6gc0nSHWSw1UYTicy/o//spka7IvFkFJBBhSWz/7V/TXNpSiMk2R2fSD0imb58h5ghJzEjtumYYeOpbKNsKmJsTr9gC0nvrCnrL1Pbhx1Ln3NZWHE6G+YX9T5haLDmEut1LFhogoENy210Hj/Bwd1tQ6YVco3mkJjovcQey4aGf4nxiaWeu9ikGXsZg6W41iI2fGf65Qf364hAZZ7HZ0g2df0ui2jVWgA1rZRJRTRWLiWKfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by PH3PPF8B755DBFD.namprd11.prod.outlook.com
 (2603:10b6:518:1::d36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.14; Mon, 30 Mar
 2026 22:18:38 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::7d4b:a049:aed5:d2b0]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::7d4b:a049:aed5:d2b0%8]) with mapi id 15.20.9723.018; Mon, 30 Mar 2026
 22:18:38 +0000
Date: Mon, 30 Mar 2026 17:22:32 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, <dave.jiang@intel.com>
CC: <patches@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<alison.schofield@intel.com>, <Smita.KoralahalliChannabasappa@amd.com>
Subject: Re: [PATCH 4/9] cxl/region: Constify cxl_region_resource_contains()
Message-ID: <69caf7a84bc20_17924f100a6@iweiny-mobl.notmuch>
References: <20260327052821.440749-1-dan.j.williams@intel.com>
 <20260327052821.440749-5-dan.j.williams@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260327052821.440749-5-dan.j.williams@intel.com>
X-ClientProxiedBy: MW4PR04CA0281.namprd04.prod.outlook.com
 (2603:10b6:303:89::16) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|PH3PPF8B755DBFD:EE_
X-MS-Office365-Filtering-Correlation-Id: 319d88d9-2a72-462c-5c89-08de8eaa4ad0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: VG/jL6aUABnwXU+p+F6C6yKN88dCpEeOIX/YX7fUoDrQgZr9U4Nbj4z8kQ4HFx8dXYRl9K7gzJYt3LJsxQpaBBDHb82Dgoaus4QPkhXl4v/4bC1+yebhhkWHUcAWVRY3Qob/nhRGwvUq9EnAtRU98iMR0Jriu184dvnAlxt6gqScqlhfn0Tutk0XhklhBbtBufHnIk3p5HVJpsaLpx7auJZwpYxqozJs4dNYPgtpgm2C6TS5ur5jm3BWk62Mt6YG/rfVYrALpebbsOvjzaOlL7nHBygnCln9cdimc3Q0LJC9SNlcdq/so1QVP/9Y4OoTTrbs2x2TUsYdN64Vx0/az2ABPMij3T5cxdIrCCOuz3tkfz6p1DwGmjqc/fDooM1OauMGRrDKQywHLo5qnIcZ/Q55+WiR2ucFICA5XZE4TjM6Ss0piQIfD9qy9mccsZAKvqsZW5pdZGkQ4xNqvlAvrik4Ey9OM7TWstt/FN7up2jxrlepLA9sbxUXJLsYuI7C7ssHllU3PF5qjkir5RHlwXBryv7l0J9rQcQQqTSefWARFluxjJx4qlhw7Mk+9wyXjCekz6dat/g9AsHFYZC/vI4KFKmgKTHc0V9CKWnLkqA3xGbGG0TqdV8qMNMZaW9m2VIT/psdDqS15EqwUi7Ef0lBVtPZNdguLCc0I8c094obgWiuRRdhT4Z2olpU7jps8tsUZiKMQ7RUC5H48uJP/xgJwDRk4TWh3H8D/J51YM0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T5S5UJsul7q9+ZibsByEzFNBQO2kYyrWMuOWrcz+KoefRPZqG0qRsgZdCDAB?=
 =?us-ascii?Q?dmTpcOAZbAoe4/nJ/MqVobcFcxgDJ42GjgGLH/S4QPS1Xx2F9fKz2USd/KpI?=
 =?us-ascii?Q?aE5Ql2POqeFuhhI1wFtQmuI0ZtMO2VbE4t+fveOw4cKqAw7YNOarkbekDrm5?=
 =?us-ascii?Q?HS38+o8bs+BR6l96uyy8V3T+EsLZ0lo45LFKzQc4kzqpVeWpUOc3JLEB0CxP?=
 =?us-ascii?Q?JuLS/jrdHKgStWHW/lbH/GPvWCba6GhmUp9ko/zeUoAW/DYFKcgmiIvZTbn+?=
 =?us-ascii?Q?WXirsoblZTYXY/xSV3l/yZjJeyCsdIygOM4GFWSn5ZhYL0k0tm24X12jwUuJ?=
 =?us-ascii?Q?NuaFlXxLW4lFJO0g/cS/wFfo6V1TgiU9SdvHFoKvFV6TppU/bFd58zr7Q0+4?=
 =?us-ascii?Q?FD/lF5tgK9ZnijBn9iPw+RHUaAx81Fo7ae2qWKkNZaNrGJdUCBQnKrJtgiNV?=
 =?us-ascii?Q?PCdZdNx8i0RPvmtcIbA9l1n/hnzdSZukHQPh4bbrnODuWnMO7zO/72K6a/EF?=
 =?us-ascii?Q?XFIid0blCmpk8t23QCJhM/N4orqM4sW/JGljBaB7O6qGXMSwknbxM7PU6BdA?=
 =?us-ascii?Q?YzgsMV9L7TEZPbTaAAe1wHUpTqxstczhQV5uDQ1ql6mTLzKSEKihNZ+uwTWu?=
 =?us-ascii?Q?bmkDKqdo3bDiwQ6ioVviJ10wi66JD8E+T3g7qlkbUex1WOjnt6r3wuHB9c0Q?=
 =?us-ascii?Q?uCRaaaYGkk8FpUtZ3tLC+WoNo3pF6EmIDYvuoDisArbuoviUHOJYaspZR0DK?=
 =?us-ascii?Q?GEfbk6hYRU/UpL5nVJINDdg0+Zng414Jnb2we3/+tlMkuNNrxhso3J6iwwIj?=
 =?us-ascii?Q?FUox8MkZpLfIQS5FZtGXIJaa1mqIf7SeZDuJIvGoBDt6fGr+ZIVVxk3WY0mb?=
 =?us-ascii?Q?PLUVGR5LiiMWKyNdMBwK1ZILA4t4+iNlVnzjVxnRriBq8wx7A0S7KHWNuhl7?=
 =?us-ascii?Q?mu/S2b0WTxHuTOkpL9g+b+LBtINDzDDVjUi4NRmbWrpp+pm8Bzo24DuRhFNJ?=
 =?us-ascii?Q?gLI/u/Cglu43EK1AWnBH1g0Xe5Idbhxx8cc7tawo2i5Npn62bIkYEb4G7tAr?=
 =?us-ascii?Q?DIpdVYZlU9Kosgn9mNiftqXrehk7W+VWXVsWWJQQCSHWsAA0mokdrs4zhKGb?=
 =?us-ascii?Q?5Rfjkxjpwy6pB/lC8IC2JSSodfOWtw3md1BwIxCqkOLXmC3EZv8iEZcyrhqp?=
 =?us-ascii?Q?431Pd2TdlsiQ3c3uWffozz+kmvShyjmW8XJOVjjUNUuxR46GNEPFaTDIllOV?=
 =?us-ascii?Q?qoGsTs+pl0FAb/O6xwRxmVcTNvG7rgMY/LJjcypDcJcaAg6pGdS+FMVF2Gy8?=
 =?us-ascii?Q?4aoHhRCHFZ7deaZlwtRnznorJNVAllH1F9TEdewf3avD1pKT2h7cUAx6zsiJ?=
 =?us-ascii?Q?+5vcSiVIu9gujorEPYbPlan8x2armzSJnuNJlx8o++xAda048k6oM024axUy?=
 =?us-ascii?Q?Gcm0PrvNP2hiQ4POaJ1dyO2aHeCLZXjD8A/89WED5dLoyj9QdxUuFkc7M3Rl?=
 =?us-ascii?Q?qJ8GWLA8XqJdnNCT8Mp/KovqRISz3F5ENnitD2lk3G0xlSa0kW/A0tcyC9DG?=
 =?us-ascii?Q?gPN6OzrZJijDT75fGpNoBoKB5ETtiqeA8DBDclngzNSriHvdUxUBLDB7iJmH?=
 =?us-ascii?Q?e7Vg9y/BSaoJxvXbgwiVPNAaGMxQ1q+ukgewYmcDfpehUZknEYubO6kJ6DiP?=
 =?us-ascii?Q?1tiZW1VJlnOLaLTaumDpNqoiJyxvkBkhckkOlGzvTWEn6Bw7W1XeovLrJ0Bo?=
 =?us-ascii?Q?rBguCkeraQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: Etyi3vRksep4H0rnX4oDp5nu9IBZ24fucJ1G/QD8XzTEqaSvMnQDIr6Z3XHbdeZWfh6d5OCwfG07MDl03GCt78zMqZGYoybU+xXULns0YUHj7S+6nrEcuF2B5ekwcV7dC4t0ZzbrZj4QBFl7NlBnDgupvpQOtkQqr7iFqz9oWLc4ezuNV8OUoyzHtnWevSZ+XjqceiWqy7S6LIs9nbXv3GhmMyODU7YOBj+qEEPGfuCfC6t2Yj+UaEGUq3Wv3z9sPnznHkkpU8xtUS6Kq7TcSH8/r3K/uJBgdjmub/BAmOdgwZs54waaHX9tdOTWPulTAzoekYVQ8xF3Cx+UFZPPLw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 319d88d9-2a72-462c-5c89-08de8eaa4ad0
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 22:18:38.5671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +iuH2pdZdw74JXj2Vp8jbtiNnIPxsNk/VFzw/QQZOIRlS5EZeY9P51XjumrodviIgkLGsEDl1JWjz5A9F1OezA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF8B755DBFD
X-OriginatorOrg: intel.com

Dan Williams wrote:
> The call to cxl_region_resource_contains() in hmem_register_cxl_device()
> need not cast away 'const'. The problem is the usage of the
> bus_for_each_dev() API which does not mark its @data parameter as 'const'.
> Switch to bus_find_device() which does take 'const' @data, fixup
> cxl_region_resource_contains() and its caller.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]
