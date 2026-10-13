Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7E451EDEE
	for <patches@lists.linux.dev>; Tue, 13 Oct 2026 16:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791910735; cv=fail; b=Kre5H4KbdGArM01XrEmOWRJqidMIFKQCjIUNDUxh4Auxgi+yx2ZHYOwsBNQeO4N10kLCutsKgVI0Q3NpZbJtSAZ5WJMA8g5/5NwELXFz82et3JggtWOxv+KAVD3gqK79ZjKsmRljPSmYivibGT2NE92xhEE9GPppMnGhdSclp34=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791910735; c=relaxed/simple;
	bh=MPFNsC1Ai+WRsTk8J+ykiDiMqwcgqWtsJB0h5qehKhU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qwDAGEuEicA32vFfBuBw/fclLn6qamCluOnvX5i/5y+0W52weuxce5B9TUhsVL8DiB6aOoMh4Jme9kdr6rFAcUm7Nri4+j5E9M5TbG2tUm+IQKsGWG6mjTo2NsPonYzFvC7WiNQnvSbWUJ1qsxge4g2OaoQAM/g1uH+ZbyU/i+k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HPqPix7G; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HPqPix7G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791910735; x=1823446735;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MPFNsC1Ai+WRsTk8J+ykiDiMqwcgqWtsJB0h5qehKhU=;
  b=HPqPix7GWFgnWFz6hKXMEFQPHPZK0w7iNVo3dO9LcsRgpPji58zzz50R
   mYuUYD9nw9RHUwfno2J/cea2M1TeDxOYiSEOOVQimhPDqSqPLl4F3HmdR
   m3CMkjWqYcBz/o31PpgvCd3ScbB7+ibFc8err2/J+TqUXbEroy4xXaZPR
   Lu0U9eX+MnySgNa90BHxlz37TsYnFH1jDbZoDbonmV8R09/YiWm6j9jus
   q3Haik6V9Wir8ixHeU8rnx37v0r8JqkgtKiRSVt26tqJP8skzJHvfsSnT
   D9bOkO6iM46BEREUZMlLe+Cc7wA6cuWQWSVZpGZ9o8HwcWi1zMve8wSj9
   A==;
X-CSE-ConnectionGUID: GdN0GEmRTcywhFAvUdAsQA==
X-CSE-MsgGUID: XWrYk3ZITUqLCIbSQzvBSw==
X-IronPort-AV: E=McAfee;i="6800,10657,11934"; a="546271"
X-IronPort-AV: E=Sophos;i="6.27,156,1787036400"; 
   d="scan'208";a="546271"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2026 09:58:54 -0700
X-CSE-ConnectionGUID: g65cLtmvRgGZy36d1p1z3w==
X-CSE-MsgGUID: 9mROKdi/QQGKKPW9ypXXKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,156,1787036400"; 
   d="scan'208";a="1179279"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2026 09:58:54 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 13 Oct 2026 09:58:52 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Tue, 13 Oct 2026 09:58:52 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.50) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 13 Oct 2026 09:58:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cphVSKM5RpRhA9OcwgRytgDlBfB1ZPjxfLIcGbgq4lgB4OlG3EQ68rEKb4gt0gn0UXY83yjK4g/DZbK4cZt3mtwmQ9PqNhHjpxUuRuiwXiCPNvcOmR+5UZIUmSolafnBvSquvF6pz0wOxKPB9tk1epN7ECqNVdhZKpQa5LDmYmFM9BOagM1dYFqta+m2ksXslPLVmdPq4+1niyw072EubykBqNA4ZOMNmxVkjeNZRD1u1TyLIU/3AOt0Y+FN3RGP/ziypx6D2gTSwiHG+8ylOuE/AZ2DBZT2l9ybyunnfdfErWO4iKEUeXyMlKVjVCQNchawtxwVU7uD4qRyDdhf/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uRQ+1slNCjGYCXVtBlp5DuHI5NpdVPunJP3DUSAWqJ4=;
 b=BxrSLxZKczshma4N6E8g1XodNfk4GiSsX5OhBBWrGsrsusyFXlgKCkQh7lLrnnuHCwUGd2aa5GltHvTpF8FoG5jsGkrwGNaYRv9R5sfQcFC9JgP62Io1mI8JCptBOceHrQykI0kmSO3hKxOTZKfBfmS8A6zLg8bOKMUxrfRSSNRxUvYOjL918C0lCFaZGjgOWG1HLxeLpwRPRZStrSD13QyqNXnW40RnLwvDQAxX3D5tZl7dtd1vYQQ9bH8Ab18UToz6qicRSC77Uo7kOO0xHJ3vl1Aj58n2W03ewKC98q2if67mQzxCINehsLNo1dQr20n51EJe3TzRUgzMdIb3Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB8718.namprd11.prod.outlook.com (2603:10b6:8:1b9::20)
 by LVXPR11MB9780.namprd11.prod.outlook.com (2603:10b6:408:387::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 16:58:50 +0000
Received: from DS0PR11MB8718.namprd11.prod.outlook.com
 ([fe80::6aa:411d:4bfa:619c]) by DS0PR11MB8718.namprd11.prod.outlook.com
 ([fe80::6aa:411d:4bfa:619c%4]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 16:58:50 +0000
Message-ID: <fce25d6d-8fd7-4f83-8d8d-929871aff885@intel.com>
Date: Tue, 13 Oct 2026 18:58:43 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 158/621] ice: drop page splitting and recycling
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, Jacob Keller <jacob.e.keller@intel.com>,
	"Michal Kubiak" <michal.kubiak@intel.com>, Alexander Nowlin
	<alexander.nowlin@intel.com>, Tony Nguyen <anthony.l.nguyen@intel.com>,
	"Sasha Levin" <sashal@kernel.org>
References: <20261013112920.855194808@linuxfoundation.org>
 <20261013112924.605588927@linuxfoundation.org>
Content-Language: en-US
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20261013112924.605588927@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0013.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:2::7)
 To DS0PR11MB8718.namprd11.prod.outlook.com (2603:10b6:8:1b9::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB8718:EE_|LVXPR11MB9780:EE_
X-MS-Office365-Filtering-Correlation-Id: 8546358b-05f9-4c3e-38af-08df294b40d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|4143699003|11063799006|56012099006|18002099003|22082099003|10067099003|261009223027099003;
X-Microsoft-Antispam-Message-Info: pCNdve/Q5e2NlXQNZyBnpFbkXczEqWjpGHB6oiwaAWsHmVJkMeHhD4TR4dKM9JxicVX4u6jDcePUUMf/l3BI25fmzAtJJrTV2VlZOEeDY50Ull/z7hhhPENgfjkYf1Ki+uuyLjaJHqIVEF0h8Q5pC++2MeCClfwxcAecn2XapimLl+JLww0nKyVt7S7X9xL49ST//nWP8Uv772aG8NwL2AfC48d0nkBheZ+k0SQMrzkfUebqWmhhgJbHbM3MXVPtgx8EcF6M7FYSdhhGfatyBjvsluvMtP1PeOSCtV8zck3nZY3j25g385ZJhJTnuFXbaNwDLaEjs6j9/CrJUjLbu2fajDQP92d0pFYwBEbZZ+/g8ZeXHq8E971kfJNv6Y+lV1EXi4bvxSc+h2Ad3Siv6YEsoYYfdwNbG7JEsB4LHo4APdlO2fPLmLb0hh63qXeFQXLfqt7qxx6e6D+dJktYQwXZ7VSKzYcW+SXL4WJmVtD8pqsHhlC8R3zTr0Tjt6CjigKKgdZ/iYJ5cLg3Lu7+4XKDC6Fi0lXJVt1sj0D4gRGD54mo0PZA0yG+bVaUh0mBim1p3OERs8P8PLy92blGF46n++0+SS1SOeEyCrbzAztum//v15acnoeHw+2WXv7YmFtvmtggXU7SUxtpx3emeT4F+IgUW45m2ZBjW1By/xA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003)(10067099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VlhzazVNcXMxRzZtL3dSUTB6WGVUZnk3Z1NtN09yNDMxTWtVNXd3ZXhSK1d4?=
 =?utf-8?B?Nk5KRWNMSVRUeUpSc0RVaXkxY3poQ0JLVTBwMnhTL2M0UTRwV0RXTTc1a29T?=
 =?utf-8?B?TDVFZGxhcnBTWEhHM05iMjBYK2F0enM3R3BoZ1F2L2xUOU5VQjhZOGJnaW9U?=
 =?utf-8?B?VEtFUXNBRHphckJQQWRvMmRuVmd6U1J4RnYvcGl2ak45c0t1NFdoK3FOdXFM?=
 =?utf-8?B?VFJ2Nkh1b280eENERUk2cm5tcys4QVlkK202RHNMb3NGcllGU2FXRlpHcHNE?=
 =?utf-8?B?QXdCeGoycGM2L1cyU3ZKRFJ3elNPUmIwUmVnSXJ6M3F3Z0VIdzg3Q1RIZXBE?=
 =?utf-8?B?b1JGazdWR2ZmbXQxOEVXZ3NONGg5SWZJMWUrclhUaXNSc09JanV0VGhUWkND?=
 =?utf-8?B?MzVpekp2Q3h2bFFOMWFzN3FKeHFqVHcyNDVOSXl0M1MrVW5YU3FRWXhrSXZj?=
 =?utf-8?B?Sk9xSEZFcW0xc1ZOUmg0TlV5T25vd0ZGRndCeEFtbENmL1Qxem44NlpmMHZ4?=
 =?utf-8?B?ZjE4YXRsWVBmMkhjMDZmeWZqMzI1QmVkTjNSOHFlRlBIbksvREE1Q1pxVWhL?=
 =?utf-8?B?dEs5L3N6ZUdnS1AwVkQ2UWJKTDAwZUM1RStzTmFmWHpiSWRHN09teHB6Z0tM?=
 =?utf-8?B?ZFJTalJkaTF2V0RRSzRIaTczR3JJN0RwbHNOYllhWEJ5SkQwTjUwTU00WHRk?=
 =?utf-8?B?NGJkRHNkeXFQUUVBQnJramtSajhuOTNtMmZhSm0xYTNRQ3pPbGRhRFM1eDVY?=
 =?utf-8?B?Y0NJVGpVTC9ZRU4zMkFoYnZ0eFpscThvRmZLNTZKell0ZXZud1ZieHBManBG?=
 =?utf-8?B?U3cvWXAyY0p6YkZIQisvS1czaWVkK3NiWDlFa0lWcllJNXRsTVdkVkw1M3A0?=
 =?utf-8?B?Q1pRZGh4dTBQZG1SNXg1MUhidW4xTXI3NWpGeTczbGR0c21wYjFyL3dsNHZU?=
 =?utf-8?B?WGp0Z1FiZjlpRGRPVldRRmIySE9teUp1U2UyVitiNCtRWU8wU0JyNEovTzRw?=
 =?utf-8?B?dnFVMU9Ub2RpTitEdzJrYm45d2QvRzBPZmx1REYwNmR4bkNuNmQ5M1BuWmdY?=
 =?utf-8?B?NThuWHBSZW93RmtudjFwTTRvVWFLcWtRek9BQVRQM2RsQldTU1NCVmRRYlF4?=
 =?utf-8?B?dkhTdHVrWnRuVzQzcUdVMTNiUmc0emdrb25Ra28yQitFeS94bDhHMnpVbFcx?=
 =?utf-8?B?MzVNZTVBdnptS1h3VHZoYnJqaWRYQXdEUlFxMm55bnJDV0FEdWt5TUJIUXRx?=
 =?utf-8?B?MWlJQ3JCWTBEOXRweXB1aFlZZlZ2V20vaUc5YVhsRTFlT003c1UvMlJtcmFh?=
 =?utf-8?B?dzJTd1NaakdocEpaK2M1cnFnMVNLaTZUbEI1cE9LZXB5R1FiTWl4a2tjbkVP?=
 =?utf-8?B?REhUbVBSK0pjQnFCZEp5ZHdtRmQxdHh1ZG1YU1cwb0FrK0FyRUJPZFhhWUxV?=
 =?utf-8?B?Q1pyWHJrZnZWd3hCVHlDMld1Ti9vaXFNaVdKWitiOUh0MXVPQ0lOSjNMUktp?=
 =?utf-8?B?MFZUai9FNzF1U3V4Ni9pdjlFcU9OVnZmVHd1T0VKemhWS0p1WWxLbkRNMzZW?=
 =?utf-8?B?WXdrM21aNXkvMFBZdXNBRW15REhxRWZtbXdDeXhmb0VRcTBsWC9Yc3BLYXlQ?=
 =?utf-8?B?V2xZVWp6czJHWVpMMnZlUEhrVFVIeFVXamNadnZ0N0xFTWNqU3gzYnJObVdn?=
 =?utf-8?B?amY5aDZrY2JYRUhtWUdyTkE0TUVxd3NRRDNhaFVSY0plKzk4MForVkZqWkd3?=
 =?utf-8?B?amFjTG9wWVVSWkd3TzZrb2NzckRaK1k1dnEvc1BhSW9PNXdCb1ozeTdDdzM0?=
 =?utf-8?B?RTZwaUFBQ244ZzhsSEYxQzBRUVJnV1F3b2k0ZTd6Y1krb200MFl4TzZmTU0r?=
 =?utf-8?B?NXJOK1V6cVh4WVJicGV2YUlXYlV2QlJZOU91UzR1cWM4ZENvL1NpeG56aXk2?=
 =?utf-8?B?cTBYSGR6WlVJbkcrY013OEJ3QTdGSVJFRkxmTFhvRW1LWTFnWmxHUFYxMmUx?=
 =?utf-8?B?QnN5M21VOGsza2tkcUV1dDI3dEpzYU1LZDkxQ2NzN1I3bzBuZ2xlRENxY3N0?=
 =?utf-8?B?eDlWeU1JUFZDK1N0WlJLV1VXbTRIemhnQWZ2NEZ0aitiM1Z3RkMzVk9BTkJi?=
 =?utf-8?B?Y2UwcGNPRDZVL0RKSjFrMzR0S3RwTjdhUGduNkhwbkJmMUhDVk1BTTN0YzlH?=
 =?utf-8?B?SWl6Rjg2ZGowVy95eGVoSXJnaHVpVWVSYyswWE51aU9iZ0NCQ3pSZkh0Yk5D?=
 =?utf-8?B?dDFoMVhISE5KQVdFM0hQVzF5WGt3WFVicHBEdlVPR3NvMGhVRHRaNHBHTXBo?=
 =?utf-8?B?WHI2N1B6dGJETEthTk9QZnVLZzc5dDRmM2dRUFFVUEd3L2MvU3RPc24rSEFZ?=
 =?utf-8?Q?lIkyK+pYX8ZzFpco=3D?=
X-Exchange-RoutingPolicyChecked: N7Q9Jf6C9mp/Sk6U1MNuYhgApUa79y8eK8+kRu0TSqsMzzrxJ0+QPfx5H7ihA9hgLIpy0aR4KPM8EUIZpgXRrxBZj1MGkEd/offK3aziJTBZXLJYk6ZlO8MyBPg+dLCu3mV9qYWfBSQbr/rfsY9wRPAVZrTWvKLRYTWy7ff32XsII2zHNsfdeJ8f3v0C6bZeA8RZwW/J/aHeDMQCZiHIPLqrg1o9eisUK26UMOv50NhRpTMO5yrJu/dUYv5s044C6ir2bW3Dgr2hkzmK4VHzP2ir61iIcYH1CGjfcVqJP4Q6GGsYFJGoGX0SorhM7TrtavHGbaAphRJJdbRnfZOs7A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8546358b-05f9-4c3e-38af-08df294b40d1
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 16:58:49.9583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jDkuub9DLgyoDf4SNHxoia6X6ut0DQVeWk5VQY5qX5fmyVboplk2RFI1rt9CNhXkmpuSjFwvzi6wqnbkYujXvwldTs1ZPtnAX4mqEcfWEO4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVXPR11MB9780
X-OriginatorOrg: intel.com

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Tue, 13 Oct 2026 13:32:33 +0200

> 6.18-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Michal Kubiak <michal.kubiak@intel.com>
> 
> [ Upstream commit 3a4f419f750946181e3d6a339a1ef1942c5b5685 ]
> 
> As part of the transition toward Page Pool integration, remove the
> legacy page splitting and recycling logic from the ice driver. This
> mirrors the approach taken in commit 920d86f3c552 ("iavf: drop page
> splitting and recycling").

This is intermediate commit, if taken without
93f53db9f9dc ("ice: switch to Page Pool")
there'll be huge performance regression on all ice cards.

> 
> The previous model attempted to reuse partially consumed pages by
> splitting them and tracking their usage across descriptors. While
> this was once a memory optimization, it introduced significant
> complexity and overhead in the Rx path, including:
> - Manual refcount management and page reuse heuristics;
> - Per-descriptor buffer shuffling, which could involve moving dozens
>   of `ice_rx_buf` structures per NAPI cycle;
> - Increased branching and cache pressure in the hotpath.
> 
> This change simplifies the Rx logic by always allocating fresh pages
> and letting the networking stack handle their lifecycle. Although this
> may temporarily reduce performance (up to ~98% in some XDP cases), it
> greatly improves maintainability and paves the way for Page Pool,
> which will restore and exceed previous performance levels.
> 
> The `ice_rx_buf` array is retained for now to minimize diffstat and
> ease future replacement with a shared buffer abstraction.
> 
> Co-developed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> Signed-off-by: Michal Kubiak <michal.kubiak@intel.com>
> Tested-by: Alexander Nowlin <alexander.nowlin@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> Stable-dep-of: e142dc4ef0f4 ("ice: change XDP RxQ frag_size from DMA write length to xdp.frame_sz")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
Thanks,
Olek
