Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2086.outbound.protection.outlook.com [40.107.237.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD0328A405
	for <patches@lists.linux.dev>; Fri, 27 Jun 2025 21:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751061365; cv=fail; b=jHzV9eXAFELXeafe43FvXp3j2lMPFZUQgmwzm6x30lfqHDE7Baueg28/lb58utB8idetFmrAucA3uoTkVpWV3wdVFf+1mTaqlXS4d9/x/gN7UXfpRF1BOMb/wOmBUACTfCbNVB5bMUGmVrxboZdgy5ocgbu9d7b89UT1roRppEc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751061365; c=relaxed/simple;
	bh=0uvNB6LVMh0ghZpG2k4FG7QihkPPB7xi/NvQzHcj7JU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FL4PQ2x3+B2ortVz79Gce4CaYeLD03nUq4dVYna34dDCv3x8kze1ChASVITJxGS0MKtNE5eYExYWXleu+Vw7etz6OyvJoYskx6cNWn41GJs5EoQSQOELSloO36EvW1zVHSc/m9kzio5uObUybCKuNNkFW1IaBfD/1g7Hp/RMNfo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rLfQRozV; arc=fail smtp.client-ip=40.107.237.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rLfQRozV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NzNkg6V5q28enJgkdXuLqTn/QFi0mWdNHLm3qQwTxRJ4XR5SwbQWWGRcwvGmA5VmAMJKvzVGNGoZEQqKsbXf7cPaSD0ue7UDczgU8hqRRqazQf7b6NRyFWMkQtqziafkZF41Z+IU2eLY/8uNt6P1y11QAIy7bjXQcq8ys5Z8bHK52pySfUVeqoR5MrHVh5cEv/wXMoUSYsp1qVbDeZiyenwJaRDgZjl6kqQ4EczAEhRR6SidPTa1+YX2aOdqC7/JHmiymgBw0zrb2AS+LhgKslSwHjI/GXe7kCNb4Uq/f3BZIa1yhx8nv4NtlZS1OdrIEPornTusvDSh0VvPk3ytaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0uvNB6LVMh0ghZpG2k4FG7QihkPPB7xi/NvQzHcj7JU=;
 b=xZg79fMA0ErIG3PyrKV0XkcmMsaU/6M9QpOhegrodgyqjnUPFQsF24Oev9fZdqNMz9WX6JHoBX1ck6BGuMJskejXSLjGpvUlZAqJvDurausHJ1Rc3hGYgwtkmoaeFDE3guyP0gzmrCpJd0OH5APLSrEqd79r3M2rEOgaBgezuJ+2S5mhH1eQcXXaHAs061mMJ6ZTsEp7TCGJOtwpiL8xhM3GkQiHRAhVBnGXG6oRimmbDuR7u2iGypZu3ik6I5DypWZayYeEy58ZgHNflB9JUvTq36wX4U6sIerlm3O6VoqJVqTgeCyNOW5VLPMviuOmvv0JdE8RZxwxD67dVqTh3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0uvNB6LVMh0ghZpG2k4FG7QihkPPB7xi/NvQzHcj7JU=;
 b=rLfQRozVxK5BS5QyOyKWuCwpFBJB/kSOTVLW86elK9MqfwPkyen8AWPHBaG1ZGICvazefPQ6FmaHzkHBm3MuYf8PA5A6adH5vFf5p7Vw42q3oc4ZyIUYKqmILMc34GbTWkTvmSUWPN/yclA9yliVDZ911cbgKJlZv7WmnjC069ZR2LREU92p3fY31D0Ibau8fFRq7nDwzs5Rt8/n+s1QhpW85qqwPPUViZG+5cw1mTc7ltwd3CuTR9tf9ZIxkQ8H3Zf9MjEggV8GAwkgnkUrpDDYkBSHYPpme1MRAwGEZbzPuJVUXm0vJt8rGDadj9Z62cM4EzIAOkkMuuXhrNDiTA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB2667.namprd12.prod.outlook.com (2603:10b6:5:42::28) by
 IA0PR12MB8693.namprd12.prod.outlook.com (2603:10b6:208:48e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.23; Fri, 27 Jun
 2025 21:56:00 +0000
Received: from DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::bd88:b883:813d:54a2]) by DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::bd88:b883:813d:54a2%6]) with mapi id 15.20.8835.027; Fri, 27 Jun 2025
 21:56:00 +0000
Message-ID: <65c185de-b7a1-4959-84b6-399158865ab5@nvidia.com>
Date: Fri, 27 Jun 2025 14:55:58 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 01/30] x86,fs/resctrl: Consolidate monitor event
 descriptions
To: Tony Luck <tony.luck@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Babu Moger <babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>,
 Dave Martin <Dave.Martin@arm.com>,
 Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
 Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-2-tony.luck@intel.com>
Content-Language: en-US
From: Fenghua Yu <fenghuay@nvidia.com>
In-Reply-To: <20250626164941.106341-2-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR13CA0017.namprd13.prod.outlook.com
 (2603:10b6:a03:180::30) To DM6PR12MB2667.namprd12.prod.outlook.com
 (2603:10b6:5:42::28)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2667:EE_|IA0PR12MB8693:EE_
X-MS-Office365-Filtering-Correlation-Id: dc3e73ab-a988-42e1-6f68-08ddb5c56733
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dGhCZWR4Vmd0Q3FtN2h1UU5oUE1KUkU3bSt0UkcwWit2NDhZY1pMTml4dk1C?=
 =?utf-8?B?OW5ZWlg4OXc4VHI4NWszRGcxU2Y4YndhRnhPNG1mQ3Z5cnQxdmRnS3JQY015?=
 =?utf-8?B?WmdyTzFlc2FKUkJkTVpXYUdQWEFtaFRBNDFrVDJkTDFSR1VSaDhiOE1MZFg1?=
 =?utf-8?B?MjRWM2pRM3RjNGJ6VmFmdmovNStWNGN2ZU9DVWovc3FKdWxvb0pxNUJXVFI4?=
 =?utf-8?B?WkJWd1NPakEvM1A1bWFlN2xIY1JuOWx4aCt4QjZjTFFMTGUxdVA2UXpzaXFN?=
 =?utf-8?B?OFphMytIZ1RtUml0SlV5cDUxMFRUa3BSUTVpc2tBTkhUejlJUHBTOWFsbk12?=
 =?utf-8?B?eTRJK1l3QlJ2dVN3dEV6MlFpYWRCVWUyYlRaRWNpbGJnZGNPMXNhVzN5cFdj?=
 =?utf-8?B?V3c5YThLZjlCWXN1V1YreUVLMkswblJUeU43ak9rNlBudEVuandpSmtuWE52?=
 =?utf-8?B?V2UwZ1N6UWpJQnUwbXVVL2pvQm9RMTkyMCs5Z0hMMm5OclEvQW5rc2FWUnRx?=
 =?utf-8?B?cVhzUk9zVG5Cb1J5ZXU1cEFSYzZQNmZveWVzMTZWQmNiRFVpMStuYS9URkhr?=
 =?utf-8?B?NWJFalJTaXpxc0o0MzNSck9aTnkwU0JhN0M5bHdXa3planp1Mjk2eXRMWDJ5?=
 =?utf-8?B?Z3NwMm84R01jM253aFJMM2ttWDFSeFlhSDM3b0JPV1RqRlFJLy9PK0NSR3hi?=
 =?utf-8?B?OXdhZzU2SkNjQTY5YUQxdXd1RlEzUmx2bUVmNkpvV0MweWVPM3h1dktmQlpW?=
 =?utf-8?B?WWRtcHpvMHBPYTVjT0UvVThpVi82aElkV205VEhZL2Y1S2RhOFU3ZE5Qc1pX?=
 =?utf-8?B?VGxpQ0MzdXNUSUx2THhlVStlRWc3WjBOUzVvdHF3YXJFK3crQzN1U0lkU2pR?=
 =?utf-8?B?UlNwQ2hBU21adGVBdFZPblB6SUUvQjZFVFhtMk9reUlqNzVJTnp3RWk0SXhB?=
 =?utf-8?B?VXd1NWFYL0RHaU1XTW1mYlc2MkRsZ1ZmTGtBa0tDaUdJOGd2UXVBNk1UWUpO?=
 =?utf-8?B?Y1doeUFldWFvRHM2YW1GY0FtQWdrUkRWVkw1bXZrNU53L3VSbnB6VUVMaVZN?=
 =?utf-8?B?UmtrME14WTNkK0k5UVpLUEhSWm9yQU54eXhWc3FHRGI1bDA2U3ZIUHVZdWI2?=
 =?utf-8?B?MzZHSVdKYU82M2JjT08vU3VMc2hHU1F3Tzdpc0VZMk1pUTNTRnYwOXdqb211?=
 =?utf-8?B?R0NoRUxHWWpHeXE5NWVxWDl1c3V6NkFhVndHQW5WNkljNlJWelExdXhFOVZI?=
 =?utf-8?B?NXpJZ2lEbzYyckt0OFUzTkhmbjBiMkZQeGdmSU4raEZTRTN3SjJhUEFERGxw?=
 =?utf-8?B?UjNDRHMwaDY3MUpvMHM1bFdkbWZVRklaUmNQdmpES21OVTE4S01iY0Vid1Vh?=
 =?utf-8?B?amFPTyttUUw4Y2Nwc0ZCTE9VMWFsd1BwSDE4bEFQcnA2dE92WkFtc0pxSGxy?=
 =?utf-8?B?dkJWTC9jWEhwa3lOWXFJaGZoSmNjZGsra2l6Qk9oc0l6NDRXSTZsaW5kR2xS?=
 =?utf-8?B?ZjVMelliNFp2cERIZVdJWmdaajM3cFVuY2tuV1lGWm5RaGNrNjh6UWZyZmx6?=
 =?utf-8?B?MFNkMGliUjJzKzE3SU40K0FyeDdyQjMvbG5XRGpjbWFuR0hiWUN5a2NNaDNs?=
 =?utf-8?B?YlB6VWxpRkRuVGpaK3FBS1padTRIZjBHUVo2L0FMY1kxUVlObVY1WGFZYzNU?=
 =?utf-8?B?WVFCRVRPc3VSSXM3N2N3V2FqTURtQ0svUVJXa0VHbm5sdnY0RzlrSnpKSkQ2?=
 =?utf-8?B?L3J3SHZmZHlzWG9BUXREQWRrSEt1dHB0ZVl5U0pMZjBqWUdMeU4yY1dXcnpE?=
 =?utf-8?B?V0M5Z3R4L1hvZTZVdEg1V0VHTG5GdmxsQllxa0JtLzNaUTBiL0lPZk03SU5P?=
 =?utf-8?B?Ulo2eEpUL1p0RXZtOUVkNmVIa1I5RHZZbWR3ckFrMWEyU2pyR0tTR3VLeDV4?=
 =?utf-8?B?Z0lVc05hNEFJRE9Ib3VhamgxVTNFendGRCtmODhoeWtzOEV4YzBJSXpSWGkv?=
 =?utf-8?B?V0UxM2hYaFR3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VjdZejZ5Y2luVFI3UzR4OWE5RzJaN2tQdjE3akI1WFdWRTZzWHZXeEFSNU1O?=
 =?utf-8?B?bzZnTSt2L1duYkRMRnFCRFkwbGxVU3FWUjNCRGNhR3JUOS9GZWJNSi90Z0tI?=
 =?utf-8?B?RnREWE04ZHRPZ2J3cDA4cm1iV0FmQWZ4Vm5VeVZadkgvaG5XWHhiZ3k4eGxT?=
 =?utf-8?B?U0FsMWdYanVEL1dreHJYSlNMektncEJMcFJTbjRVTThsUWVOMFNBeGVEb0wr?=
 =?utf-8?B?MDFWcGN0UVNGdXlWdWkvL1pXYjBjd3VPeGpBdklEUzllTWZLTFIwMlYxdGdW?=
 =?utf-8?B?azBJK1RORE9wak9DOWFuU1h5aWRZckRaWGVHZGdrNXl4emV0ckRQa2k0eDBL?=
 =?utf-8?B?aFoyclo1c2dKN0k4ZU01dW5EbTRGSGRtbzFKQ29qUkRpQXVhRzVoUnJwaTFM?=
 =?utf-8?B?UXlUZ00rQy9wUVkxSGtyRS9ldy9FdmU5NzkrN0hZNWlzdTRBTzQyZld1Mi9p?=
 =?utf-8?B?ZVRGZGZNRXBpWkxkQytTN1hpZW96OHJCVEVFRW5xTEMrVkZFKzZWYnpJek95?=
 =?utf-8?B?OFkyN3Vhc2RqeWNJOFVMaU0wZStIbWc5YTRDNlJNZzBiOFRTdXVoeUhleWxm?=
 =?utf-8?B?azM2ZHBNeWQxNmNDNjVIYVlJbm1kTTB0SEJtdnZ6djkzc2xQVVIzOURsNFV6?=
 =?utf-8?B?S0hjT0F5aHprQ09oVXpaaFErQzA1UDJiYXBlSU5oUzI1QlBkMFBGZWQ0SDV4?=
 =?utf-8?B?R3JPWkFDZHh6a2cwaXM2S0xkVWp0TTNtSCtxODhkTmpjeFZ4Q1ZETldqMlNH?=
 =?utf-8?B?aWlnQlZ3V09iZzBaN3g2elE2RDhqbHNmR0NpeEYxRzI0aG91RkI5QnhCaGtL?=
 =?utf-8?B?cHhFTjh0T2tyQkNWL2l1M2JVano1QWxJaithZFRyUFo2Mll2UlViaDI4YU8z?=
 =?utf-8?B?aWwzN0xFakcrTWl1Vlh1TVdFQzNyajJHdWN3QUowN2NycFBReGFNRTYzVUt2?=
 =?utf-8?B?OTVVRktVSS94NFRMT3hoQzJBTEswZW5lSHFjd0dHODFhc0tsZWYvbXRXWjNY?=
 =?utf-8?B?TUNKZTVsSXFLRmJZSWpZaWNYQ1Z1OHBpSnhsNmh4dHNhZGdJQjRsbEdXR1Rw?=
 =?utf-8?B?a21YcmN3eFdFYnJRVVArcmRueGZtZ2ovTkRzQVFZYVVFN3J1QlJRZ3pKODlq?=
 =?utf-8?B?YTExUFpTYW9UYi9pS0VzTnpwTml4TWY4WUREL3hsQ25RMzNWUjkrc1FIbGxp?=
 =?utf-8?B?NjRWOG1QRmd4MjhhZS93R1dQWVZsbzlmazQ3dkExUFg2UFVXRHNMbXJvbW1o?=
 =?utf-8?B?MTB0RDlmRTR3S2JmemlFajBKemhBbnRWTVh4cnpGZDl0aW1pNFgvTGJkWmw4?=
 =?utf-8?B?SFpYTFZZeTFMRTl6MjRqbjB3UUE2OGhQOTgzQ2JJblNoSEo5SXZaUjlHU1B5?=
 =?utf-8?B?OU94VFcxVEJoUWJseTBLZ2lrYmtiVTBWcUFtKzg3bklWLzZpT1lrT2pLNFZm?=
 =?utf-8?B?NVVTelFuV3FPbXZTdm9lT0kzakJCNERORWpDZ3hUdm55L1cwS3JHTllOU1VF?=
 =?utf-8?B?Y052anc3UjVGL1JDLzRVajFsdjJqWk1SYTdjV0Eydy9hN3FkWURZcTFWZWcx?=
 =?utf-8?B?Nkc4WmVFcWVsWms5NTRLUW5uZmRyWUN3V0gvSW9iMEY3WXdPSlJlcDdhbzNx?=
 =?utf-8?B?d2JlNHpzUnVXbEN0ZFVHaVdSN3BFVzZXcWYyREhmeDh6eUFhNXY5dzZHN0s3?=
 =?utf-8?B?UVpialpnUEIrSFhhZFVCWkZFVzIvVDJtVTNnYUZ3MHE4bEgyb2x1YlgrbFBh?=
 =?utf-8?B?cUF2WHUycjgzWmhGQ2pZcHVYdUM1MkpsTkt6ZzJkRWhuK3JjaGE3OFhrV1d5?=
 =?utf-8?B?N0xuZGV4SCtld0JHUXg5cW42UVM0ZmFPYkhEa01pNnVadUNyV3EyWWNBeGNU?=
 =?utf-8?B?am8vUDFjb0g5aE1WTWhRNFJZaUttSXRzV0ZjbVpNRHRGOXNUUklHdEh5YW9I?=
 =?utf-8?B?ZDdoekNnb1hnWnVubXhUU1pMaThUOFVueUIzQnlvY2wvcGdNM212UjBTZzQ2?=
 =?utf-8?B?YXZubzFSZDFtZGdIV1VNbFZsdHZwT29jdGJ3cXdxaHgvOThLcGZTUWN2VUpV?=
 =?utf-8?B?NXNiMCtDTHhwNUZwSVBIa1JMM2s4M0xlUUh3MGh0YnFpdW5ZQ1AvK3Joa3RG?=
 =?utf-8?Q?5n4SH9v1iYH66+TXB7GlWvUXL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc3e73ab-a988-42e1-6f68-08ddb5c56733
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 21:56:00.3216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3j0t5zdSRRkyoDtxGTMzKwVBNhFpFY0so/hTq+iAj5GktlwsfLrvONbxzwO0/rcajXh3MD3t6xBUPSmBTkWVvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8693


On 6/26/25 09:49, Tony Luck wrote:
> There are currently only three monitor events, all associated with
> the RDT_RESOURCE_L3 resource. Growing support for additional events
> will be easier with some restructuring to have a single point in
> file system code where all attributes of all events are defined.
>
> Place all event descriptions into an array mon_event_all[]. Doing
> this has the beneficial side effect of removing the need for
> rdt_resource::evt_list.
>
> Add resctrl_event_id::QOS_FIRST_EVENT for a lower bound on range
> checks for event ids and as the starting index to scan mon_event_all[].
>
> Drop the code that builds evt_list and change the two places where
> the list is scanned to scan mon_event_all[] instead using a new
> helper macro for_each_mon_event().
>
> Architecture code now informs file system code which events are
> available with resctrl_enable_mon_event().
>
> Signed-off-by: Tony Luck <tony.luck@intel.com>

Reviewed-by: Fenghua Yu <fenghuay@nvidia.com>

Thanks.

-Fenghua

[SNIP]

