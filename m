Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazolkn19012058.outbound.protection.outlook.com [52.103.43.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C143A35F5E3;
	Tue, 31 Mar 2026 02:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774922525; cv=fail; b=HMG/sWb3vw7Z3z4svaURiI6hgfo8EI8Yyf7qvCtAwm+4wYCKxOzkpCW3ngJbUjv1gz9E1YGtp0rld57PTcs4NOK4drV+EEXsDMocAFuSm3GJN0c/N6YlI+g6PccX7be0nE1nxu0143R/VxckqC6GEe5GQ82GviIicP/xGECpIkc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774922525; c=relaxed/simple;
	bh=fmA4yXimKRVuSjzoPJVqIZyWBLjWSRe/NN2IT4poZbo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ce5I45y6mNp5LuK3fE+j31VlSRDYc4qP3+7NyRN6Kp/MKk63n8hA8XuXaHEfqnkBgw0AobiEFn9prq87CS2eWJf7s6dASKd/vmvHkrYtWEkplpu1TejBdgSUwtUQ4V/n9JLd5uETwkn7tRuGx7TK5qDO3gQJUO6kW2n7BIK1lCM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=Q2A0gVM/; arc=fail smtp.client-ip=52.103.43.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="Q2A0gVM/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qnvt7ywjeefaHN7CtLHtG/sstHjWN4ZIHkMF7cyMa2UBy7TWk6tHXbK2pvGm95CzCHbrl50c96wHeTk/7pu6UCZt1nzABSBEL8UslJM9pIRYmW/56Pr4AbV7mbiV4/2G9dK7g35T8YGzo0W5J6sW/5k0Eu/w0gbqqxVLTp2t7iQvbU9pAxoF284/RKL7SYlT3I/9q4vzJIi6n8ecq37wh1srcx+NDsGidQMs/Gph6rKahno0k35MqiVCoATNpYjIIIQBQcsvhok7z2tw3ARVbbvceTFffe3V1sldzoRi7SDkIAkl3vgEOTJLhYhwuZQMFnOu9b5OEEh69N/AMjwHCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZTINoPtjMKphdlTgzsuSPqnTrByFviBCcv+cGqSIyV8=;
 b=KyHv4NH5JeCcsDwBeCPcosr0Rmm66lVZxw6PBU2bYDXVE3MNHRg5q8JS/AVkSgpXpgMo1HXYPQgCAfbQ81YPQYtPDs0GpWqlcK82SLH9gcG4738iUL+TL0xKVuAk5dM1lfUxeS6xzgqIJJF57eaF3+8k3bP6k/HX3OYeIvBSmwVfIaKfr5So2BslMDGMMdhGv20UIZ7kMo2MK03lTgFQdA8SD7fhzNWksh9q7X0MeWzaFEOGEYxSbF9UiI/9OqUygAzQXFTQUmUZuT574tE/KIcAhrE3VE+gtcLsU2gohi+PBdlMP9GmH79JFMYsnWKvSOA/WrTJcoj1V38JdUX9iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZTINoPtjMKphdlTgzsuSPqnTrByFviBCcv+cGqSIyV8=;
 b=Q2A0gVM/L5HPbOkXMoxuGjc+4uczeFfIQjYHkf8GTaDeEDwf9a28w4QYqc0xLK87cgz5meTCAAcshFhn8/v+3o3u5GKjS4iPV742nJftYuPYjF0Y1m571aD2njfvzA4AoL9n6e0yAkVE8IfxMZeF1lJ3L0ptV390TVnTL93Pvc2KLqBr5TMn8QrWVEFJMFeAtK86u50Xm+5stCvZwep50xOpBlQ7cSvAmZnbqtXpkAP63I9uvLgmfZigPm2R00e+Ej9XQ1FgVsBm/P3uoiNAcWeCA2owhybOxwtshQbCFMBMw52jp6nhnaGaX3fwwhJV/0OaNcI2oeSTRyLzhwz0aw==
Received: from SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 (2603:1096:4:1b0::7) by TY2PPF92DBCF23F.apcprd01.prod.exchangelabs.com
 (2603:1096:408::3b8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Tue, 31 Mar
 2026 02:02:00 +0000
Received: from SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 ([fe80::c735:fab8:6e3d:6d1c]) by SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 ([fe80::c735:fab8:6e3d:6d1c%4]) with mapi id 15.20.9745.027; Tue, 31 Mar 2026
 02:02:00 +0000
Message-ID:
 <SI2PR01MB43934BDB6A711DEC831ECC3BDC53A@SI2PR01MB4393.apcprd01.prod.exchangelabs.com>
Date: Tue, 31 Mar 2026 10:01:55 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] iommu/amd: Simplify build_inv_address()
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>, patches@lists.linux.dev
References: <1-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
 <SI2PR01MB439395C17C83A66A3E614470DC52A@SI2PR01MB4393.apcprd01.prod.exchangelabs.com>
 <20260330120500.GC310919@nvidia.com>
Content-Language: en-US
From: Wei Wang <wei.w.wang@hotmail.com>
In-Reply-To: <20260330120500.GC310919@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TPYP295CA0044.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:7::18) To SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 (2603:1096:4:1b0::7)
X-Microsoft-Original-Message-ID:
 <0cc0e249-7d98-4248-9fe7-5be568d68ab6@hotmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR01MB4393:EE_|TY2PPF92DBCF23F:EE_
X-MS-Office365-Filtering-Correlation-Id: 7edb714f-8911-414d-d107-08de8ec97e5b
X-MS-Exchange-SLBlob-MailProps:
	ScCmN3RHayGKAlIIivN7fIKgPET+ZtPok1ePxvRx6621k1U4s5O08K/IWDbD1xAsa0HR7ZzpzgAv6rsUzzyU+WOmu2eKU96UhQptSzcSayjpIJybB9HAcecFWeg5mYFi0J/HrGi8aGM5b13dEJdd0yTtZ1r5Sf31Zzm0qH4jvk194Uk5uHFopWkN++i6lv4UrSUreNjsf3iaQO7a8YrbVgT4lzxLuVoww7U0577sBdN0KpqlPV9AgXvPD38aRqQK1HR2O3k1+fxO+6AiN4RbOBu5s92nS+WYH2HaRKyOycKlyz5fr1IBoHmukkOympNlRhuGVG5pwOnwlTWnD9Xf+yASLvJeibLPldqxv/a25uOsHTevF1GkcCPOMMYigPECOWVkAf7nLJrTf/9KoEC9CrRdzjDdeH/tT4XR4XiGVifyAMc960mpfFvRwrt80rtc7AXW620gSlz0Gg2tVeujMs3ReeojvW7jud++jwCdHie+XG+AVwJCtgIL2/TMNeDKU0mvazonl+HL4UCwtDJ4D+5QiSN4PmPVRB+wfthpoFYWIzmM8Y7lQKG/2BIJP/Ly+PHcxMtg9cbHlIJf5JgpgTqlqqKIgnNXoNtuU8jCt8/b6MK7AriaEJA38ES44jbIRmQ7f1Mp9W7FitkCaAbhuO6G4wBsKSzansaJGB+P2kkWGfBJuJufrGcsrx8rbE1jGcYHtlJdrxNui2lM+kNo+nnq1VbQeJbsO8sj/I9bM3g=
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|41001999006|37011999003|15080799012|23021999003|5072599009|6090799003|7042599007|461199028|8060799015|19110799012|51005399006|440099028|3412199025|13041999003|26121999003|40105399003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WnM0a0h2K1BNOTlmSGZ3N1BEMzhiNURUMkM4VGRPSk9PM2N5bUxoQmw1OXdo?=
 =?utf-8?B?SHpvbmdrUGdHTkUxaC9FdXNXN2xDN0RBMGdwc2YzUkdPb2JIRG0yTXFMdzFR?=
 =?utf-8?B?QmQraWdzRmFzVnF3V2plVzhUdWhSSVlzZE9wU3FzMGZIRlRwQjVHM2FKRmhW?=
 =?utf-8?B?TkhuTTZKQU9ZS0xyVFlXdzd6ZXpndFJ6YjJOYmdtMUVsK2ZTRHVUSDR1a2RY?=
 =?utf-8?B?MEhNNDArTU41bjBEaWdpSVNuMkdTc3d4Q2ttL0NncUZweVM3blplRlVGd1dj?=
 =?utf-8?B?YUlOazhXY3FLQjhCS01nVzRpYXNHdXVWQ3BMRnZvRUxTQWZJMDB5cTc5VFpy?=
 =?utf-8?B?ZVMyb3orNG5xaFVsU1FjZ2ZxSUhWbkRlQW52UjRzVHVrYWo0YmtTZnRhQ09Y?=
 =?utf-8?B?SDhpQlhGZnB5VTNQZW54SWZ4dmZ4WCtPKzFYQ1ZVM1hPdUVNeEJJMW1JYVU5?=
 =?utf-8?B?RXYvUWdjVHZTVGNvaFZ5cWVUM0UxbmtNWFcrdW5QaTN2N28yQjRUeGRwOUJa?=
 =?utf-8?B?MVlEcnhPeis2RktPUjFZdEtKOHVWbHR5aG5jdENkYm9GK0hMQzNZa21TdUJS?=
 =?utf-8?B?YWRNbllZNlByL3E4eEJ6MWhxUytPSzEvVWQyeHIrOTE3NE5BTis2R1o5WVhk?=
 =?utf-8?B?eGlDZlFLNVVtei9iYzNSUFdOekZaeUdlSitKSzYrMDhJYnVtM21IQ2dWdGJ1?=
 =?utf-8?B?U2s3T1RtUzdzRnNXY0cxK0hZVExaLzdVVXhkU3pvSU5aSDAvY0VtV2JWNjhR?=
 =?utf-8?B?RjFkWGkzek5lQ3VxNkZGTUhpSUVqUm9iSEZMbDVwSmZjUElDb1UzcFQ1d1JB?=
 =?utf-8?B?eEVPYlNTOGZXYjRPNzY5eHl1cFplQnBYbzhaa2FacEQzTXNHYTZjK1JhN0Uv?=
 =?utf-8?B?RkVnQ3VpUHZrcnhkODVKaktVbGxTWXYyWE9hY0dWSnhNZklrTXF4L25LeVp6?=
 =?utf-8?B?WmtxNnNoYUloVytZMkZac0lWZzRRd1lIZjcxUFQzUlhrSWs1ckJhWmEyUklw?=
 =?utf-8?B?enI2TEs4ZlkvdW9LMnd2QnhtMmM3bmJKWWtJazdoWjBseGpDWUt5TlV2TjRV?=
 =?utf-8?B?ZVNicmtkMWlQSDhiVTh4UGRZVlhEWEJvejcyTGJIN0hDUm9tMkFIQTU5cWRW?=
 =?utf-8?B?TE4yVm03WG1Sbnd3emxYSjBKSXhlWXhiWU9weFY2ZGovYVkvQTBieWlhZ3ZC?=
 =?utf-8?B?eHRLaUFWYXdSRHVsNU5TaFdmOTc5dWNDc09iLzdLUnZHbHMvWGNaOGMxQXZP?=
 =?utf-8?B?cFlBZHVVV2JsS2VZSXhhLzRCdVM3dlBKVkNjU2diRVVGT2owSEJnNkZFR1Fj?=
 =?utf-8?B?bU5FWjNkWk5jVU0vTlE4YmNFSmVmekdFTlEwVmpsYmlPLzRTaU9pZUJ4b3JD?=
 =?utf-8?B?RHg3RDhxMmJzQjVvY1RJN2dRZnNJaUNIaWZhYnM0U2RYeVk5SWRpY3MwTVV5?=
 =?utf-8?B?WHc3MnJEZEJ0eGJlY2lZNE5vM3J1OVQxRnpNZ1d3PT0=?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RkxTc2VlUlZaT2lhajVraGp2WlRnSGp4UFlwZkNVSFhqaUN1QTFKcVkrVDRT?=
 =?utf-8?B?ZkFBRXVzcWc0eUYvR1E3dUNXbFU3NUkrUkN0emNRMEVCNDBLajlXczFXNy8v?=
 =?utf-8?B?eTBObGQyWnoyVlRRMUwySzBNZ3d4UFR1L0s1SXBoQTEzTU1zNFFmdUpWQnlE?=
 =?utf-8?B?RXBzMHhXYno2dDEyelRJTVV6RUJ1RWtkQUt6RXlMMmF5eC9Nam1RRmFhdEpT?=
 =?utf-8?B?dHZ1T0NKOUxkT3VGYTVOTHo2QnlqOWMvaWxHTjI4Q2wyQlo2dC9JTEJjeWdJ?=
 =?utf-8?B?OENGZEs1ekJGaGIyUDRRWEg0TkdYcElXaUxEYUt2U1VOVzBwZFhvUWdkMlJJ?=
 =?utf-8?B?MnR3UkptUXJTaHl2MVRaQVY2TEJlWGhOaysyZmNyRnhjdnpqRllyRzNVd2ZO?=
 =?utf-8?B?REVVd3pFZVRaaTBXU05lc2wralNGaUx2OExkcWlqRjI3V0NLY2FJWnMwZTlX?=
 =?utf-8?B?dXMxOWxQZi82SVdOeHN2cFRwRDQ3R0JGVlU3eVRDN3hZUUgwOUVUcXJJSXJH?=
 =?utf-8?B?TjBJWm9aSlFUem9EQVhTV2RjdWYzK2dSenJIaGQ5aXF3bFNSdWxTVEdhS0Ir?=
 =?utf-8?B?Zy8wMGtEVVRoQXhXTXc0SEVxaWxlM3ZmVjIzemVFRjl6dFJNOFFBSThrZ1NG?=
 =?utf-8?B?cFlzWG1rQW02K1JTNG96RlpRTHVsZXR2SDNnWDJieDNXWW8zVk5nL296UWR4?=
 =?utf-8?B?OXZZQ29qS3haRndsZC9lWjR0NDNQazhMdCthbHNZandRV0s0SWUzWjUxOThG?=
 =?utf-8?B?ZXNuZlpzaklMKzQ0Z2UrNU5JRUc0U09wdjkxcmd3N0E0alRUUlFrNmNKVUdw?=
 =?utf-8?B?dTZKYUN4NVpDOTN5LzhwbWk5K09xblpTUkRYQUg3ZWV1SGMvQ0tBMkNoWDFD?=
 =?utf-8?B?am1nYTBENldWWXRsdm5qSWJIbVJKaXIvTEwzdjdwejZvTGpDMVhkdmtkSnYw?=
 =?utf-8?B?eWMxalAwMm92S3BaTVFQamFXTjJ5NnQyYjJlNUtRRThWNjNhOWpSYUR1Wmcv?=
 =?utf-8?B?Nmc3YzZQK3NaYngrUHBMSjd6OUpCZWVwZjIrZStHUHVSV2tIZTk3K09wZlBR?=
 =?utf-8?B?L3RReU4yTFRhajFPM3k2Mzd5a1Nsd1FWenVDTUN1MC9JdkJQbTRiQXhpOTBV?=
 =?utf-8?B?VFB5YVljdHRPNFpqeFVuNDdabjVqTWZaZmZTNXNCQ2ZRd1hjRE9mQzZVeHZO?=
 =?utf-8?B?TkgydXlTQlFybmw4TUc0OGtrcDBCTzNMdGhUMnZaZlhLUDVpSERIOFRmQWh0?=
 =?utf-8?B?Ym0xU0ZBcnR3cDA4VGpjOUZhTFJPR2gwUkM0aDJQaHNEWlFwM3pZbWtOSEdx?=
 =?utf-8?B?OFE3RkI5Q2VRcUJoclRmMzdnSEhUbjZoSVVlZm5LUGdWejFRb3NZTDBhSHp3?=
 =?utf-8?B?Q2VwaXNtWGpmQmd4QWNOTGtjMVZveHcxU1IrT05OOGVsREI5VUFjWHBENXc2?=
 =?utf-8?B?QXcvekxHWjJ1c29aT2NFODZQcmtWWUNVQ1czODIzNXdrOVU4d1FLMVF1WVd5?=
 =?utf-8?B?eWMvV3NWdFNQMEJtektKSVZrb1V3YzdpRVl6bHR6OW9oRW9LRkhBQVlIdkZZ?=
 =?utf-8?B?dHdkLys1SEh2NS8vRGc1alhsWVlwUklhUmNnUXlZOXYrWFYxaHl2d2EvbkNR?=
 =?utf-8?B?cElvWlRXOWhnUzdyYk9PbExXbTFCRTkvdWlaWm4vKytHMzllWisrRzNMeVpr?=
 =?utf-8?B?cFJBeTRIaDJ5ZEdpWUcwUGFSMTE2QnBkeFYveGE1N3JBVXBYY3JEbzV3d1lX?=
 =?utf-8?B?NzVPVnloaWFSMGkzMlAzNTJuOFI4cDZCNUp3c0QxWUJxNTZ1U3Q5Z21ZY0Ju?=
 =?utf-8?B?TWJmRmRqaEJXMnd2YkRYRmM2RkF3VUM2L3hGTFkrRFIrVmdFcGdMbnJFUGhF?=
 =?utf-8?Q?Io0DoSNOR8D8B?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-3e488.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 7edb714f-8911-414d-d107-08de8ec97e5b
X-MS-Exchange-CrossTenant-AuthSource: SI2PR01MB4393.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 02:02:00.0504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PPF92DBCF23F

On 3/30/26 8:05 PM, Jason Gunthorpe wrote:
> On Mon, Mar 30, 2026 at 03:39:16PM +0800, Wei Wang wrote:
> 
>>> @@ -1267,39 +1267,37 @@ static void build_inv_dte(struct iommu_cmd *cmd, u16 devid)
>>>     */
>>>    static inline u64 build_inv_address(u64 address, size_t size)
>>>    {
>>> -	u64 pages, end, msb_diff;
>>> +	u64 last = address + size - 1;
>>> +	unsigned int sz_lg2;
>>
>> Would naming it shift (or order) be more conventional?
> 
> I find that confusing, shift of what exactly? It is size of the
> invalidation encoded in log 2.

Just the number of bits to shift the value 1 to get the the invalidate 
size: 1 << shift = size.

I thought it's similar to PAGE_SHIFT - the number of bits to shift the 
value 1 to get PAGE_SIZE (though it's also used to shift an address to 
get a frame number).

It's not critical though, up to your preference.

>>
>> The spec mentions "Address bits 63:52 are zero-extended.", should we enforce
>> it:
>>
>> -#define CMD_INV_IOMMU_ALL_PAGES_ADDRESS        0x7ffffffffffff000ULL
>> +#define CMD_INV_IOMMU_ALL_PAGES_ADDRESS        GENMASK_ULL(51, 12)
>>
>> also for the returned "address"
> 
> 2.4.3 specifically calls out
> 
>   The IOMMU invalidates all translation
>   information associated with the DomainID for both nested and guest levels when S=1, PDE=1,
>   GN=0, and Address[63:12]=7_FFFF_FFFF_FFFFh.
> 

OK. The INVALIDATE_ALL case is specialized out. It seems the “Address 
bits 63:52 are zero‑extended” requirement in the spec applies only to 
the encoded addresses (i.e., the returned address), as stated in Table 14.
