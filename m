Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F642E62C
	for <patches@lists.linux.dev>; Mon,  5 May 2025 07:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746431234; cv=fail; b=Z492BBikoHDivlU+10iZ+dQ3Fw0AVbfZ747Ro8d8iR6NB7YB0dtMfm6thLJeOK5oN/6TF97e0DIaD+PuJZleSooe7Xcz0sj5LlsCag73uF+qyurNlEmsDYy+WVZNc3e3hjozSOStJ9ICCA95jfLinak2RynjY7ZHFZGm8OJmfHM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746431234; c=relaxed/simple;
	bh=jbQPivUA8U0wKmcGl5G4nqJncJCQX6QP8n9nDQ6QL1E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gSW8/iHLnQnJivTcllMZ3MZ2gHHZomb6l1ecXXFsraxeyr5chQBvgR20Quo0ylo8Zo/87bS3EAJF6st14RPTH8DuzeCj603bO+DwrUJZj3IxOnwv4+iqIsvJ810zpyvhYBl/tzr78XveeWiHTvy8VJfo6elhgMHA6czSYtk0kY0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BYIcb60n; arc=fail smtp.client-ip=40.107.94.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BYIcb60n"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MIjxGd5WW37ltiKfQA4djhZFR8hnAVoaD/WiTvP98oDtyVfR1nqVPsWu/E38i0K2d6Xp1lmmGnkt4NV+I5slObxBGNTvB0ErqIvlXWYnLc2Y+SblyfjjYlkUDEEzzTcGPBrmVHU41mG5pXqq67GGX8HZ1HMjYXl+BMgrTzTbOocm4CnxtPlCUkjFdRXfMmg2BqwPRn9kM/nMKtN5vNNn0Ltlwm/vyEDewfH6nMw8hZRyU4BZz7dmXOV9JcrrQL17JA9eyzI+HvYjLd/BBke/whUTi4tyroPe9ElNDVnz63Y7VlR2RJ/6a0Y5IAtLXrX2XyAl+dpz9YHfdqFNAOsQ7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0msilUDmkJ3zspQCQaCovi2SrATPu7S3hEI0bIzIJjY=;
 b=oFqzeTu4tKEmYjOfRW8VUW6wX8aUFSKsIZm06WwIFkaBd1thg2Z7Kl+NkXRW8nKVGNWne9mEULg/Bw4BJ86ag4tV/xADsWw//hfx9IqHykkGCSIcwLQpA7q6tz31igntVrmwd7Z/t3ce/AqFyJzuxUiRqp+iAVwdHuFlYY6cPawFyTv0XYiqmPGUROYohVi0hRaWO4wYyM75L+Uz6jgkaSyXOUmQwoTSm2eEF/PiJRUbOVivgZlIyjyDYkxWNJ/fNRZdl9sEpy6wxiyWmY+yneSyKThc85Hm0qobov5AOy9x0Y0DJUsS8GDKdrjm0cPYEy17kqrKlA9lkUY1QF03LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0msilUDmkJ3zspQCQaCovi2SrATPu7S3hEI0bIzIJjY=;
 b=BYIcb60nwgjsSQircTIzXRdWDR9Ebj9zBAkSWQoqyF+AvwE9mYWgjUKxZjd1tnNYJk3Cd6elyQhcQ3gtS5z3nt/A7X6zt1JHH9QFj3tq3bSUv4erH31yxn5vfZWhgA2JZkHVBfGjjKyZJcB7qtTJcu/sfI9JY+dqP9DDMA2wXJef7PtkVPQI4wYHJJUneTwJ4Pxoa3fi8Nj1lN1BD9HMqzbar/oIDyMMzJjr4z1CtHug8CoLHSqE763Ju8rYQ32GjmDbsIkWUFga+EhYPfHojuYOn6vnIIhwTexrF/ABGTRXW01yZircHfRT5Q3hzI39xhOiYDbkkvy4buy3axSrCg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6363.namprd12.prod.outlook.com (2603:10b6:a03:453::9)
 by MN0PR12MB6029.namprd12.prod.outlook.com (2603:10b6:208:3cf::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.23; Mon, 5 May
 2025 07:47:10 +0000
Received: from SJ1PR12MB6363.namprd12.prod.outlook.com
 ([fe80::bec3:4521:c231:d03b]) by SJ1PR12MB6363.namprd12.prod.outlook.com
 ([fe80::bec3:4521:c231:d03b%5]) with mapi id 15.20.8699.026; Mon, 5 May 2025
 07:47:09 +0000
Message-ID: <c5022682-52e7-4340-995c-7d3d84bb77aa@nvidia.com>
Date: Mon, 5 May 2025 10:47:03 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 092/311] ublk: call ublk_dispatch_req() for handling
 UBLK_U_IO_NEED_GET_DATA
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 Sasha Levin <sashal@kernel.org>
References: <20250429161121.011111832@linuxfoundation.org>
 <20250429161124.815951989@linuxfoundation.org>
 <830759ad-243a-4fd5-9fa1-a106e6e6bb0d@nvidia.com>
 <2025050455-reconvene-denial-e291@gregkh>
 <744b4d9b-24f3-487c-805f-5aa02eaa093b@nvidia.com>
 <2025050509-impending-uranium-ccba@gregkh>
Content-Language: en-US
From: Jared Holzman <jholzman@nvidia.com>
Organization: NVIDIA
In-Reply-To: <2025050509-impending-uranium-ccba@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TLZP290CA0009.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:9::18) To SJ1PR12MB6363.namprd12.prod.outlook.com
 (2603:10b6:a03:453::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6363:EE_|MN0PR12MB6029:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c09f3fb-f2ad-4a0f-e77f-08dd8ba90a3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WkduUnJwL2Jkbmc0YzhjbnJ0YXVqT0xTaUwwQUFVbzhKangvT1VaSE9HdTE0?=
 =?utf-8?B?K2pxeWNzT2tkTE0vc3Rjb2JPRzlNVi9LV29CRXI3UURxendiYklnTkVHVGpo?=
 =?utf-8?B?OFJRTlkyMzBKdWtyNEN2T3hOeUhDUHVrMy9iOStOVXpybnJiclBqcUwxWnZx?=
 =?utf-8?B?M05meXNxRDREdUxyMkp2ZDBwTG13MSttNmh4eFdJZldpdW1kYWdCWm05RDls?=
 =?utf-8?B?aDN3TFpHRUpLY1MxdHZaUk1xQVlFbkVaQlBuT1dYbkhhS28vM0cxZmJBdkl3?=
 =?utf-8?B?QVlEblUzZDUyUlIrcklxbEY3V3pqb3VHZ2JIS0tSQ2hQU3lQdUdvdVBWVVpJ?=
 =?utf-8?B?bE1xT1N6Q3pqM0NRSzVxdXVkSzJhUWY4WXc4OElWK0wyVnQ3NjdpL0JDaEc5?=
 =?utf-8?B?ZHdUZm9HYUZzczRwdU95VEY3aUtNOGRJMTkzbHlsM05rU1Vhdm5LNW91RUxu?=
 =?utf-8?B?QUF1UnpkTDhyb0s5OUNEQXpmQW5lV0hHK1RLNXhJbXd2Qkh1ekV1dllrWnRV?=
 =?utf-8?B?S1VCSlZLeTV3VUNjTktheWIySjR2aVVUOXllcGJoeUd5OWdaU2hkamJZQlV5?=
 =?utf-8?B?RzFBN1JqMkxoOGJtUFVBVnZzK1dESWppamFZTnEyeWYvTHJLUklaQXlud1ov?=
 =?utf-8?B?MVFSOVdIbTVWS0ZKcllldTZHQjByMHRqV3hTeXdHRHZJVkFZeWQ5dS9telIv?=
 =?utf-8?B?UDRHMlZucWVXL1diMEt2Y0RmMmNFWkpkaU5oa1p3TC9PeTU0a0Q0dTJoV0FF?=
 =?utf-8?B?dHo5MnZWUStIQnRzbXlYMGwyNHZ4MlJGT1Z6QWVrZWdQUk5udjJkR0syTW5x?=
 =?utf-8?B?Q25ucjRJS1M1VUNpVjFRSUNsQ1dnSlBxd3htb2RjTXdqdnJPQVZFblcvSGU0?=
 =?utf-8?B?QWh6UHF4a2tYUW9jc3ZOR0t6bzhnaDhVaWJhUml1TGlxdnhrejNRUjhsWlQv?=
 =?utf-8?B?cTN5cDdCSzVPa3RyMEQ4KzhSaVVNUmxmc0dzL050cWFQNXBSbmF4blZTL0c4?=
 =?utf-8?B?T0tnMkdnYXQ2dXJ4SmxHMDJKSk9SdzlhS1E5b0dNVzcrSzVDTFpROTJnNWhI?=
 =?utf-8?B?ZEhEQ3RNckRaaFdJNTBBVStRVUtlc1pJOVJuSzRya1krMER6bWU2eHJTcStL?=
 =?utf-8?B?MzRoeGZJcVc4cE51cG8xWkw5bVcvUFN6UWplOHZaSWxxQWV0WGpCOFRyeDFR?=
 =?utf-8?B?K3JRWGJzSy9PVUUrUU83ejlDRGtsMFNNMmlkN3NpKzI1SldpSW1FRnFBK2FR?=
 =?utf-8?B?cDFuOG0vYWFXYXhKa2pRN1FGbzNVZDdwRzNnMEQ1ZGdES3paTm9OY3BOWkkr?=
 =?utf-8?B?QS83dVprcjhUYkhYZzlVa2xtZndoT2ZsU2RNVy9zYTVyZ2RkQzluVzdIOXY1?=
 =?utf-8?B?cFpWTVV6VjJOd1A3M0I5elZDVmNWbWVjbHNFdzZMaWZzbkxxM3VvVDZhTUJx?=
 =?utf-8?B?RmlPYnlTQ0xJbzZWc1AyN0tCdmJXSlNiQlBQU0p3VGNWUmJBWGQrd0QxUm1H?=
 =?utf-8?B?L095UWgxZUtCMnNRWUh5YlRuaU5vaFhNazgxNHdCL0Q4VEpOSUYrNS9aQWhD?=
 =?utf-8?B?ek5aM1BsNDdLMnEzUmRSbWs5ZW1pdGpZSkNlWG1zRGRaWktYcTY0aUFuOHYx?=
 =?utf-8?B?WjRsZEpza3dXbHNnK2JUNFNJQk45bGtibTBxbmZleDVmRDNHM0lzanI1QURM?=
 =?utf-8?B?aWUwSTBVNWh5SGtnbnhPN2M2aVBycDUycVBvWHpOWFp0UW1oWW4vNXJnelVK?=
 =?utf-8?B?RGdqbmtLQzFSc0hYOVhXbzlCcTl4QVZmTEJSNkQzUmQvYWVpMVhLRzE0UnQ4?=
 =?utf-8?B?SXNNUGhxbnJHTnBpRXI1TzltUlpWLzcyVWhsdGtEZHBUNU1TZWVXUGIrQm5s?=
 =?utf-8?B?MHVnR1I5NnorKzZzRWVHUmJLQmNGZnJTUlFCS2R5d05YVU51UVZudGNxSnQ3?=
 =?utf-8?Q?3AB9LyUp2OU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6363.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dUQvYmFZVmQvRXFvd3p6NEV6S21PZzVKc3YrcUNCeU55OFJ4SzVaRG9MWVpI?=
 =?utf-8?B?NjQraVEybnVPTDRPUkhObk1NZE5CaTZ6blVzVkx3d3BzSGw2WGovSVlOdmdB?=
 =?utf-8?B?TDdFTnJmaGVYdlh4NEJnZWIyQWNZUHdUc0Z1OE9hNC9kVFZ3OG9qa3FvY3ky?=
 =?utf-8?B?THRZeUFWVmJCaXdkWDcxNGQ2N0xLVFNFUUdPZUp4R3EzOUVydnJIYmEwVkhz?=
 =?utf-8?B?WFRjaXlMUjU5NHNCZkhmbHEzQk1SK3pHQTF0KzlpUmZZQXl3SGROd2dVUHhJ?=
 =?utf-8?B?cTNLV0RRdkxXek9TN2FiVnU4OHJrVld5eDRBMkJpZnJTcFBwamlFbWN2bG5l?=
 =?utf-8?B?d1V6TFZ3QkRBTlZMaHVSenlIekVIS1NPVldQcEgrWEdKQW4vR3pmajVEY3o2?=
 =?utf-8?B?TEFwTjUyZnRFVGpHdkxKT3ZESHo5N0hVamNYTGtSbWdiVjl4MU9KNXp1RUJN?=
 =?utf-8?B?bGg4NXFGeWNuQXFLc05pNFZLTzg0dkU5Yk9xelI3bDBGaUgzNW4yODZRcndY?=
 =?utf-8?B?OStBZno1V0Mvc0tTcDV6VlV1QVpSOE83S1N0Z0xGUWthTlg0b0dYNmlWNzZ1?=
 =?utf-8?B?QW1aZTU4UFcyUUY0TW1qZjlJTFhPQW9JRjkyVDVXbHlYVTM2MUhKdVlKTEZB?=
 =?utf-8?B?WEVONkpmUDJLN0pWS2xQbm9rRzNLYkVwMXcvdCtMSHplVHNya3c5YTdQNGtE?=
 =?utf-8?B?Mkk1cktsVklZbTc2dzJUUDByZnByMDR5QStkQk1HU09xcjNHWUwwNXhGS0gz?=
 =?utf-8?B?SEFsdVFkdFQzS3kyZ2FrQXVHWHlFbmJ6cDFoNWZ6MmNicE8yK1kvOGtoTm0z?=
 =?utf-8?B?NnZOSllKODl2Sm1qTEs4akwrcHBnWk9yRE92Rkp2Zk10TUU0dC96R0c4NWFr?=
 =?utf-8?B?a3o4VkpZei9zNzhndHFtVWtJRHROL3pCU0FLdU1nZWJkUG1Rd2ZyTUE3ZG5I?=
 =?utf-8?B?UGVKalU3dEd5K3FzN3htNXJsVmczNExMTW1sb0RWMSs4ZHhPQXRvRDhlTXhH?=
 =?utf-8?B?MXZ1NUhheEhBQmVxZVZza0FXTXl0aFVoOGpTcWlQQnc4OVBBRG9vVWY2YVBI?=
 =?utf-8?B?YkxyRENDc1hrNHh3cHAxNE1DRlgwUTEzeHFIWWNVTXA5TUVYa3o1Q0gxNmVL?=
 =?utf-8?B?c0FmRFRaa3FPZXRrei92VnZ1R2xuWlhNNy9XWENURW5sRkxWN010cVJRUjNX?=
 =?utf-8?B?RjZjT05CTjN3WEdlczcrMnkxT1Jobld6LzdGL0ZuQ2dFNW9NdkNUT2Jidm9y?=
 =?utf-8?B?QlV4STVHTW5KSnVDYXNicnh2TGp3bkg5TTRJQW9PcjVOMkxSaG1GdnFBL0Y1?=
 =?utf-8?B?NlpLWXBSYU45cGNPWFFkUnc3d2l3WUxTWC82UllSYnM4NHJHZ0xNMVZVRWUz?=
 =?utf-8?B?dm5pUDJVQlRhZStEWHVSSjQwTTYxMjRPQUVWRVR1aHlvTDRGcXJuWGpxalZ3?=
 =?utf-8?B?dnEzYnBoSkw0aHRnMTBDKzlxVEtCSkFyTDZuSFdIVWdvOG5ad2g0WVFxRzZS?=
 =?utf-8?B?RUg4TTFVdG9vMVFQUzlXQ3p2RkduN2xTYVNoYkNkRU5NRHlRU2xQZlFnTGpF?=
 =?utf-8?B?NmpxejJUU2VNNjlzRHgwRGNYSjhzMUZpVVFnQnRoVzZhWmJmNnRJdUdqVFpQ?=
 =?utf-8?B?VWJVNDFjVDJOREQrTnl2dk9hY1hYa0dxdmdDV012ZWlndy9RU3NyNUszbWFr?=
 =?utf-8?B?Y2xSV1pzU3JIVnJodFd0aDFLUUhhSmRjR1NqNXlBWTdPR1p0NVA4cW50M2Jp?=
 =?utf-8?B?ZGxqMVRKWkZCVmp4TjFSdUsrVThnTHQyTXBFWTNNdGJLalVyUW90cEFpUksr?=
 =?utf-8?B?Q3krL0FFbHF1RElDSWpZOVhnbGVKcEtHbG5DRWNPdldOTFpzanRnMVFBdGZn?=
 =?utf-8?B?OXBlbFdpTzQ1bFJSUE5uWlVZVzBtQ3I3UXJPcmdYRlVKV0RkU09EZkhGbEtB?=
 =?utf-8?B?QWFUVWVxNU9SQlJ3U3VQUVFYSzJ2cVNoL09xUEcvWUtidi9BOXJVVlVGbzRL?=
 =?utf-8?B?RzZvNlJKeTVIOU9ueXkzSzV5dUdjdzlDdU1SV210eHlHdmlKWXdaZE55VFNy?=
 =?utf-8?B?OHU2NUI1aWVwcFFveG1LdjNWU04yTXBWL1orTFVkRW03b3dsaU9FZ1d5NS9a?=
 =?utf-8?B?dkFBbGJRTlFvbzVhQ05pcHJzMGwwNXpoRTE0ZFJOVnl0U1NsakZZMjBxMDh3?=
 =?utf-8?Q?hpJT5TRj8fmNCnzrzNRqcQtoYPrfcnftxVvHaRnIQeMG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c09f3fb-f2ad-4a0f-e77f-08dd8ba90a3e
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6363.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2025 07:47:09.8360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wTJQ+p0XGqrf1ohiXkKzbw0b/S6nRfMUKax3VlFZyXs7mlEEUnvqy72tImanvQPb7OTMWs8gaLlsijPxXLCHug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6029

On 05/05/2025 8:51, Greg Kroah-Hartman wrote:
> On Sun, May 04, 2025 at 04:47:20PM +0300, Jared Holzman wrote:
>> On 04/05/2025 15:39, Greg Kroah-Hartman wrote:
>>> On Sun, May 04, 2025 at 02:55:00PM +0300, Jared Holzman wrote:
>>>> On 29/04/2025 19:38, Greg Kroah-Hartman wrote:
>>>>> 6.14-stable review patch.  If anyone has any objections, please let me know.
>>>>>
>>>>> ------------------
>>>>>
>>>>> From: Ming Lei <ming.lei@redhat.com>
>>>>>
>>>>> [ Upstream commit d6aa0c178bf81f30ae4a780b2bca653daa2eb633 ]
>>>>>
>>>>> We call io_uring_cmd_complete_in_task() to schedule task_work for handling
>>>>> UBLK_U_IO_NEED_GET_DATA.
>>>>>
>>>>> This way is really not necessary because the current context is exactly
>>>>> the ublk queue context, so call ublk_dispatch_req() directly for handling
>>>>> UBLK_U_IO_NEED_GET_DATA.
>>>>>
>>>>> Fixes: 216c8f5ef0f2 ("ublk: replace monitor with cancelable uring_cmd")
>>>>> Tested-by: Jared Holzman <jholzman@nvidia.com>
>>>>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>>>>> Link: https://lore.kernel.org/r/20250425013742.1079549-2-ming.lei@redhat.com
>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>>>> ---
>>>>>  drivers/block/ublk_drv.c | 14 +++-----------
>>>>>  1 file changed, 3 insertions(+), 11 deletions(-)
>>>>>
>>>>> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
>>>>> index 437297022dcfa..c7761a5cfeec0 100644
>>>>> --- a/drivers/block/ublk_drv.c
>>>>> +++ b/drivers/block/ublk_drv.c
>>>>> @@ -1812,15 +1812,6 @@ static void ublk_mark_io_ready(struct ublk_device *ub, struct ublk_queue *ubq)
>>>>>  	mutex_unlock(&ub->mutex);
>>>>>  }
>>>>>  
>>>>> -static void ublk_handle_need_get_data(struct ublk_device *ub, int q_id,
>>>>> -		int tag)
>>>>> -{
>>>>> -	struct ublk_queue *ubq = ublk_get_queue(ub, q_id);
>>>>> -	struct request *req = blk_mq_tag_to_rq(ub->tag_set.tags[q_id], tag);
>>>>> -
>>>>> -	ublk_queue_cmd(ubq, req);
>>>>> -}
>>>>> -
>>>>>  static inline int ublk_check_cmd_op(u32 cmd_op)
>>>>>  {
>>>>>  	u32 ioc_type = _IOC_TYPE(cmd_op);
>>>>> @@ -1967,8 +1958,9 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
>>>>>  		if (!(io->flags & UBLK_IO_FLAG_OWNED_BY_SRV))
>>>>>  			goto out;
>>>>>  		ublk_fill_io_cmd(io, cmd, ub_cmd->addr);
>>>>> -		ublk_handle_need_get_data(ub, ub_cmd->q_id, ub_cmd->tag);
>>>>> -		break;
>>>>> +		req = blk_mq_tag_to_rq(ub->tag_set.tags[ub_cmd->q_id], tag);
>>>>> +		ublk_dispatch_req(ubq, req, issue_flags);
>>>>> +		return -EIOCBQUEUED;
>>>>>  	default:
>>>>>  		goto out;
>>>>>  	}
>>>>
>>>> Hi Greg,
>>>>
>>>> Will you also be backporting "ublk: fix race between io_uring_cmd_complete_in_task and ublk_cancel_cmd" to 6.14-stable?
>>>
>>> What is the git commit id you are referring to?  And was it asked to be
>>> included in a stable release?
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> Hi Greg,
>>
>> The commit is: f40139fde527
>>
>> It is Part 2 of the same patch series.
> 
> It does not apply to the stable tree at all, so no, we will not be
> adding it unless someone provides a working version of it.
> 
> thanks,
> 
> greg k-h

Hi Greg,

Happy to provide a version that will apply. I just need to know where to get your working branch to base it on.

Please note that without this patch, our application causes kernel panic 1/20 times it is stopped so we
are quite keen to get it into 6.14 stable


Regards,

Jared

