Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012019.outbound.protection.outlook.com [40.107.209.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855D9225416
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 16:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761667234; cv=fail; b=gxRyugxrdHXE8yVZwN1FPoZ5Wz5hQ1n6V3zkeaZkIWvvNGz8F8wBOnR3ko4MaRuGS9iTkAXXsVUG/bcsuqE9xdtBrApXHD51PnwQfWJwdcM1Di9H/jKi06bjNmfYoBVJ01OV1k1qLV8x0UyMH5+bkVdcifN5ccyFfn1yNVrGX6Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761667234; c=relaxed/simple;
	bh=7+BT+DiiWq9WSv30N0Ixu6GR8SCFeYS11n/7i3p1Y9g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EqQcI10r60+N1o67TUsRzgeW5l/EagheLFndmfVOtqPlYCK1QcHORWDingawexkauE+TpHghfTHEUHuvfw9FXdUTMFNNUICWnGTUS/KUtS82kOxEOM5iyBgm3RZkyEkqm+zrZLn8QaW5lUbxPMOcem3O1i9xsusy6+QB/WA3MCE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=me8xNz15; arc=fail smtp.client-ip=40.107.209.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="me8xNz15"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ld9tXcw64Ch+BevAOM4I8wMhEMhi3mPzzWKlRDq+O6J9otv81OMpdqNx5vZmIkwGPs3RGnqlN0flX3mCr4ViE0IuEsDK89mM2V/blvDoUoXrlRGJkCn3ljBbNyuy4089QUCkg6GvioQqUVzak4zws0ZGi55PvB2HDqWYor7l41IA+tpnBFClRwJi6Z82CBJ3emlByYEJnj086oHKYZuG0PoLqftw8sY07jdDbF8PpRHdJPEWBRMOWldmTzTDXGOyM4hjSF5CPxq70lHA9eIhQKGtsPoFxXJA0OBkdKXg8tGAbYe4ERV2gRovMkHXRV+ItmKLk/L/ryypI95QQItB3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ip/H96bm+GaSr4Gpc8Y851auMjbbXiCzAtlL15MAVVg=;
 b=B6mDN+VlxKeKwhd+Fc60bmJA3nTbUHJ3Caej7UeyEBSvZ4cdJdDci29pRKzmY6sEO/HshMR5fe4cWu9CbvZugTT7BnXUbXiJP+JhJsdK2UWtKyK2JRo63B4Q3gSc9TE1iRVExBDscu98C9LUdvMhrXYilyaZ/3klTVXFWKzu9L4rYXzPg3AWXJtDDiWyT6865g1XM2KsOmM3D+/DUswU2VnCjEMz6MscpIiWP8jMAgXJIM6x1hBsPA3MO2GJAWIVwXzyYFFImDi9AkWEWFVWy6WAKk/E8m2S8t7xpuGqUOzT9QvyLBbIOEYngayRtZXN1rS/KghRJ2aeKrfWGfykhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ip/H96bm+GaSr4Gpc8Y851auMjbbXiCzAtlL15MAVVg=;
 b=me8xNz15GVp7sKW+Mcyq5y7oYherpqxSSCMClHEC0UL0Kpn3gcLXHIY8Fse5eEHdyV9H8TIRQFZQO6Ukad4nnCxBqVgGZZS6+nfUj2nALontJlejT1N1geHh+fRxaYMCEJTdhcxdqeLjBVOpmxLRDqwtofJBgeLf2qyV6SqxhFk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by DM4PR12MB6469.namprd12.prod.outlook.com
 (2603:10b6:8:b6::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.12; Tue, 28 Oct
 2025 16:00:23 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb%8]) with mapi id 15.20.9275.011; Tue, 28 Oct 2025
 16:00:23 +0000
Message-ID: <6da4a9cb-38df-41de-b714-44b64c9b3b60@amd.com>
Date: Tue, 28 Oct 2025 11:00:21 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 80/84] x86/resctrl: Fix miscount of bandwidth event
 when reactivating previously unavailable RMID
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Babu Moger <babu.moger@amd.com>,
 "Borislav Petkov (AMD)" <bp@alien8.de>,
 Reinette Chatre <reinette.chatre@intel.com>
References: <20251027183438.817309828@linuxfoundation.org>
 <20251027183440.942556856@linuxfoundation.org>
Content-Language: en-US
From: Babu Moger <bmoger@amd.com>
In-Reply-To: <20251027183440.942556856@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:806:2ce::17) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|DM4PR12MB6469:EE_
X-MS-Office365-Filtering-Correlation-Id: cfa2489b-545d-46e1-ffb3-08de163b1a13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NUZPNUd1aE12S2Z1OTJhU0NrY3hLd1FWMzJMOU5lMDdqQnJpWnBqWWRDcWZS?=
 =?utf-8?B?ZTAvcVN0VjNCYnlIUUZiZXlWUXZKdndUeE5xQVRKckUwNURWUVprNmNoOWlm?=
 =?utf-8?B?QmVHY3dJSHZ0aURER2VrajZkbWlMTmhaeW01TFhkVkNldUJKMnlOY1JvMnpT?=
 =?utf-8?B?eFd2eHR2bnRzUzRIUkV0QVVhUCtjQlpQOW5ORmw3RWVNQVdhOTBqV2VadHZh?=
 =?utf-8?B?SVRJamdKVG91SVVYNHdsWWJISUZ5b0RWOTBtMkhJZGxhb2RORXdOVGpRMHVB?=
 =?utf-8?B?RHNBT2lqM0E3VUduRWtBem94UFlUYUlGZFAvZk5rTUlqdFladnpWa2xubHps?=
 =?utf-8?B?TTF2M0l0dFdNUzdwV2JCUmNtQnBvSVI5bnYwejNYVlpJS0Q0TVlFZDZSenlP?=
 =?utf-8?B?RjFBYU0vT3J6MVZUeEcrTGxmTDhjV1BrWXdCNExEa001cFNiS2ZCbTRRdzdR?=
 =?utf-8?B?OEdOUENVblRxQVh4SFhGUkxJWFBGNUxZbFY2Sm5tUTJReEpxUTMyS2NCVm1V?=
 =?utf-8?B?NjQzSVJSWDVDV3EzN2JRRElBWGpZeUZxYk43L2JuZ2tMZUVNUENtM3B4dksw?=
 =?utf-8?B?U3diK1F5RmhlMEd6ZjV4RFFIZzdtd3YvMXovckxUM2drRFFtS1BvVE9zRkJV?=
 =?utf-8?B?cVMxeHFudmJNc1dBWDBBeEZtRHZkT2YxdS9KYkhlZTdWN0cyRm9nT0FrYTBw?=
 =?utf-8?B?Z1E3YnUzcXlvSFplSjQ5bEFZa3ZGZ2kyWHpta3MxQmZHRUgwMXZ2Wlc0cjZa?=
 =?utf-8?B?M2V5MEI0QnVFUFQxRksxMWMwb3pNdERla25sWkx2bGF1QllQbFloSStUcGk3?=
 =?utf-8?B?MEVPaWlIVnBaSjc2SVJHTzVwejAyQjU0M09USFk4c29NMjJOY2k1ZW5YdVlM?=
 =?utf-8?B?cXhPNU12UUFmYUMrRkJ5MnZZL3BVbWorSGw3SG9kZ2R3WDIrUWRvNXg0MjRx?=
 =?utf-8?B?czJ0eklsd0xzR0p5QnNEUDRSM1lxN1dUc01wbG9LV2h1c1I2OEIxUGkvVnBB?=
 =?utf-8?B?dWFBdHNpS0pwT1piNElsNHBuS0JMMmZMdFhYOW0rOXVJVWcrbzRIeDBOVXA5?=
 =?utf-8?B?NGFnM3VqeG9wK281MzdhNnkzZEM5NmxiY0I4aG84SVh2KzNVaCthdDZHUFp0?=
 =?utf-8?B?KytQM29EbFJUNmhFWk1TRjRyb0dTZTFCZmkveGlVaUo5a1g2QTVMUjJkc2R3?=
 =?utf-8?B?anpPVHdTZkp3N0hvQXpTOS9WNDBBSTBkcWxVMDFUWktoRkd0cWNUWEI4dG5Z?=
 =?utf-8?B?WldVUDJSc1FLWFloanA2QWFxZk96NUJVNEFVb1NYdWhsekVpYndUVHArOWdC?=
 =?utf-8?B?Vi84Rmc3S1hRa05QMTQ5YlFWaXk3c3BGY3VwMFJ4dCs5VmV0SHJhZTZWSUxT?=
 =?utf-8?B?QUp0eW14WEs5aDFuNWpjYXdDQnBMS1B0aE44VllxZGFoZzZqbk1PZFdUT2Ex?=
 =?utf-8?B?TWtZTDMyakI4Wkh0eW1RYUpLL1Y0WFNFMVBodUM4cUxPNWR4eFJkK3BOalMy?=
 =?utf-8?B?M3R4bGljblZUOXd0V2tDaWdHcHRCS0VKTTZPVnkxSU1lclhyMWd2bGx4dWxh?=
 =?utf-8?B?N2RiWnhtWm9ET3R1ZlVtNk13dkREYmk0bEJ1M3J0NmpQeDNTR1dBQ1IyWnRk?=
 =?utf-8?B?MFFscWY5YnI2V1lYZlVLSlNsaENFMHA0UzlLblpJYWRxdElCWkNrZWtGNHhL?=
 =?utf-8?B?QlNsMjlCeTJabW5vQnZDR0VGTVZhOEYxVzk5SmozVUxFVk1DRVdsTGZFOUg2?=
 =?utf-8?B?NVczRnNRdEk2OUFVNmI0dTAvWFN6S0JDeVEvbVVVV1BLOHg3Ykc4RGtwaWVa?=
 =?utf-8?B?UGVQL0U5UFEwcWNOZW5SNVB3QURYQ0xtT1kzWTNwcXkxaXNvQzYwZU5JSkhS?=
 =?utf-8?B?cE04US83SFJ4TUZ2eHNYajFLYVZMK2hTOTJ6MTFpbHBkbFMxZG1JSzd4R1Jy?=
 =?utf-8?B?ZCtpaExZa0Y0QmcyOWJPWTBxZ1l3bW82S0RUcWpqc0NpNHJYT2FLMTJtNnRB?=
 =?utf-8?B?cGlTdHpaTG13PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SDIyNjZjd1UxZjFmWVRGdVdCUHZjQ2tLckxXZ1k4UHFpMXRpancwOVdwaU94?=
 =?utf-8?B?SDBDclNub0JQemlaajFQYkhlUG1YcjZIczFIcWVHekZBcEdsYmlPaTU5OHhw?=
 =?utf-8?B?MUFYL2hDbHdYbXA4RFRqTVlBY21qVFNhNms2ZWo5blVqeEhONkpNSEZCNURN?=
 =?utf-8?B?b2Nqa3hxVFZHbStBK0tibEdyQjBWUVhnaSt3SVhmSGRWcFFHeitlUEt1UFBK?=
 =?utf-8?B?cmZ3VFA1RkZzK2g5dHU2ejRJSUpCUlBrZTdOWWhwS3d5bDdmcVJXbitOTXdF?=
 =?utf-8?B?RUZJZmo2dGlLYmpmYnhsZVRWUms4R0VWcEREK2tuYmlVMHJuWnkzTSsvVHhH?=
 =?utf-8?B?K3NqWDBnTWRRL3ZIWDdVcGFvcHVPSkU0SjJlZFJUdThKM1BhS28rZmJtMHM5?=
 =?utf-8?B?K0cxaXh2a3pwVnlxU1hDSFdFUkI4cURBSXY3ckpiNHdlM2hDamxqbFRyQWIx?=
 =?utf-8?B?aEw2RG9UYk9WV0lIcFBWaWw2NzRqVlVuLy9HNFVjVjRIQnhjWjBEYzdDWU5Q?=
 =?utf-8?B?VWFtQ3VXUldKYmcvV2l2cHF5cmRjK0cycG5icUZ0dzhHZE9MTWJnTTl6emZV?=
 =?utf-8?B?Z1R0NUFSb2xGSlZrdzNZWnhiTnhOVnd5VktyYmFSZ0xkL0hxdXBac2pRbkNp?=
 =?utf-8?B?RGlPOVYyUVJWdUZ0RG1kOXg5ZjR5bEVjenU4SHk2WmcrZ2xONFErVDZyeE9H?=
 =?utf-8?B?RWVodFI1b1huTHMyNVJsL09BcE1NVCtlWjRuZEJjeno2VG1zbk1MSUZhYjYx?=
 =?utf-8?B?RjFSN2NmWERyVkluVEhWUXgycmtpY0phMUJBN0xONXMzRit5UUUxNGpuM3JD?=
 =?utf-8?B?Z3ZhQWlZM05LN254bytnejRRM0ZJbG1zVTFNWmNtRFBjRkNheWVZaGIxRVA2?=
 =?utf-8?B?L2xnNlVYZ3Q3NjZ5K3dPbjFoNGRGWnZITExjcC9JL1hZNi82Q3lJM1Z2eUdp?=
 =?utf-8?B?S3BWa2I4L25ydE8yZk15Qjc1SnQ4Vjhvek5jTXhoYzJpVXJuTS9MdlJLeTF1?=
 =?utf-8?B?Z2ZWRW5qMHI3VWFOc2F1Wm5jditIVC9ZcUpRa1dUQmQrVW1JeTh0WEpxZ2U2?=
 =?utf-8?B?YU1OK0RIUHJreFhkLy84UzlKOVVnZUhQdjE4RFMzZndCSUxKR2hpK2RNUlM2?=
 =?utf-8?B?N1NBaWtZckJhT0tBS1BQeTV3QW1Mejhla1BKZUVtL2dJSUw2MFB5UGtHVHJh?=
 =?utf-8?B?UUpNMys1VzVCbnF2THNlblNlb3F0bFp6NU1lT214amo4dGF1NW15bTdKWlJH?=
 =?utf-8?B?SVN6bkxjUVZ4M011RzhSVm5CL0JDd2o4ZzlMUDZmWG9LcmIybUpoNTB0L2xY?=
 =?utf-8?B?OVRPdUY1MlJDNG1qbjJsR1FmalplQ01IODM1WDMzanBNWWEvaFF1eWowR2ZK?=
 =?utf-8?B?U2tZWjBRNE1WZGYyTG9BSmVHWVNXZm5LZlB6eVBRNGQ1YUNiUTZpM1FWYlho?=
 =?utf-8?B?Z0ZGTysxWW9OMlRicnNKZ3FaUnorbFZOVW5aN0ozcTR4K3pNeHRCVGFReFZ6?=
 =?utf-8?B?eXhVTFkwa2o4M1hGa0R2RVlCbnlXQXB2Nmd1OFdBaXBoZSswK0VqVlpROWQ2?=
 =?utf-8?B?M3l4NnBLdVkwY0gxbkNtQ0w1NzRUSFRBN2lITVF0UHdxODBlWXFNN2tHNjli?=
 =?utf-8?B?Y2RGaWVveGRPbUltS3FIVURNUDNuS0x1L2Y0d1h4aG94Q3FhUS9sZDg1K0Fn?=
 =?utf-8?B?bG1FQml5V0tjWFpBZWZXM0NMVVY2QnNNNHM2L2Y2KzljMkV6dFZpZU9Md3dP?=
 =?utf-8?B?UkxyZXFwd21ZWnZCQ3ZmaFV3YXV4UjJiZnlnalgweFZCajNmRG8xODArdnNL?=
 =?utf-8?B?WVg2THp5cVFhWXdYdEhSN2V1WmxabzNHWGo1WTFYMmdzTTlibXFsbE01c24y?=
 =?utf-8?B?U2VSZkMwSFV0NS82di96T3R4TUpQZ0dubklhb1YzeUhhSzFJaW93NjdYQ085?=
 =?utf-8?B?TWlOa01USHFya1NsYTVRM1MydldzR1ljbGdmSTlhVlBvMTllb05rdlZwWVFQ?=
 =?utf-8?B?ZUc0a0g1NDVTeGtzM3JTN3BxaHBTOWtyeHNIeDRSNW54MGlNS1Q5UVZTT1FY?=
 =?utf-8?B?MDJHb2F0MDA2dnZNak12SzRGTDUrQWpCL0dhR3NrV2h3Y1EwOXZtd2VwbExU?=
 =?utf-8?Q?q10w=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfa2489b-545d-46e1-ffb3-08de163b1a13
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 16:00:23.1675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZOYDUUP+lVLD7lJ7u2MEj5xwg8eGXFiaF/J2IiAESPO4Gg1s05Q6af0avLABRUfx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6469


On 10/27/25 13:37, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Babu Moger <babu.moger@amd.com>
>
> commit 15292f1b4c55a3a7c940dbcb6cb8793871ed3d92 upstream.
>
> Users can create as many monitoring groups as the number of RMIDs supported
> by the hardware. However, on AMD systems, only a limited number of RMIDs
> are guaranteed to be actively tracked by the hardware. RMIDs that exceed
> this limit are placed in an "Unavailable" state.
>
> When a bandwidth counter is read for such an RMID, the hardware sets
> MSR_IA32_QM_CTR.Unavailable (bit 62). When such an RMID starts being tracked
> again the hardware counter is reset to zero. MSR_IA32_QM_CTR.Unavailable
> remains set on first read after tracking re-starts and is clear on all
> subsequent reads as long as the RMID is tracked.
>
> resctrl miscounts the bandwidth events after an RMID transitions from the
> "Unavailable" state back to being tracked. This happens because when the
> hardware starts counting again after resetting the counter to zero, resctrl
> in turn compares the new count against the counter value stored from the
> previous time the RMID was tracked.
>
> This results in resctrl computing an event value that is either undercounting
> (when new counter is more than stored counter) or a mistaken overflow (when
> new counter is less than stored counter).
>
> Reset the stored value (arch_mbm_state::prev_msr) of MSR_IA32_QM_CTR to
> zero whenever the RMID is in the "Unavailable" state to ensure accurate
> counting after the RMID resets to zero when it starts to be tracked again.
>
> Example scenario that results in mistaken overflow
> ==================================================
> 1. The resctrl filesystem is mounted, and a task is assigned to a
>     monitoring group.
>
>     $mount -t resctrl resctrl /sys/fs/resctrl
>     $mkdir /sys/fs/resctrl/mon_groups/test1/
>     $echo 1234 > /sys/fs/resctrl/mon_groups/test1/tasks
>
>     $cat /sys/fs/resctrl/mon_groups/test1/mon_data/mon_L3_*/mbm_total_bytes
>     21323            <- Total bytes on domain 0
>     "Unavailable"    <- Total bytes on domain 1
>
>     Task is running on domain 0. Counter on domain 1 is "Unavailable".
>
> 2. The task runs on domain 0 for a while and then moves to domain 1. The
>     counter starts incrementing on domain 1.
>
>     $cat /sys/fs/resctrl/mon_groups/test1/mon_data/mon_L3_*/mbm_total_bytes
>     7345357          <- Total bytes on domain 0
>     4545             <- Total bytes on domain 1
>
> 3. At some point, the RMID in domain 0 transitions to the "Unavailable"
>     state because the task is no longer executing in that domain.
>
>     $cat /sys/fs/resctrl/mon_groups/test1/mon_data/mon_L3_*/mbm_total_bytes
>     "Unavailable"    <- Total bytes on domain 0
>     434341           <- Total bytes on domain 1
>
> 4.  Since the task continues to migrate between domains, it may eventually
>      return to domain 0.
>
>      $cat /sys/fs/resctrl/mon_groups/test1/mon_data/mon_L3_*/mbm_total_bytes
>      17592178699059  <- Overflow on domain 0
>      3232332         <- Total bytes on domain 1
>
> In this case, the RMID on domain 0 transitions from "Unavailable" state to
> active state. The hardware sets MSR_IA32_QM_CTR.Unavailable (bit 62) when
> the counter is read and begins tracking the RMID counting from 0.
>
> Subsequent reads succeed but return a value smaller than the previously
> saved MSR value (7345357). Consequently, the resctrl's overflow logic is
> triggered, it compares the previous value (7345357) with the new, smaller
> value and incorrectly interprets this as a counter overflow, adding a large
> delta.
>
> In reality, this is a false positive: the counter did not overflow but was
> simply reset when the RMID transitioned from "Unavailable" back to active
> state.
>
> Here is the text from APM [1] available from [2].
>
> "In PQOS Version 2.0 or higher, the MBM hardware will set the U bit on the
> first QM_CTR read when it begins tracking an RMID that it was not
> previously tracking. The U bit will be zero for all subsequent reads from
> that RMID while it is still tracked by the hardware. Therefore, a QM_CTR
> read with the U bit set when that RMID is in use by a processor can be
> considered 0 when calculating the difference with a subsequent read."
>
> [1] AMD64 Architecture Programmer's Manual Volume 2: System Programming
>      Publication # 24593 Revision 3.41 section 19.3.3 Monitoring L3 Memory
>      Bandwidth (MBM).
>
>    [ bp: Split commit message into smaller paragraph chunks for better
>      consumption. ]
>
> Fixes: 4d05bf71f157d ("x86/resctrl: Introduce AMD QOS feature")
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
> Tested-by: Reinette Chatre <reinette.chatre@intel.com>
> Cc: stable@vger.kernel.org # needs adjustments for <= v6.17
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537 # [2]
> [babu.moger@amd.com: Fix conflict for v6.6 stable]
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Tested-by: Babu Moger <babu.moger@amd.com>

Thanks

Babu Moger


