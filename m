Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC98E2DEA8F
	for <patches@lists.linux.dev>; Wed, 30 Jul 2025 18:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753900982; cv=fail; b=C/SuxDVh8m2/tlysy6wb/fr/9XXiFBjrICC0BTuDan3Iv3gPiLP9aCSiqelq3NNGdYzf1sbNJlfE7GvOnscd0/tLkh6GjmSk64Ct3mc22eMMOHJogRhfRA2tXFclHq8+OtfCbFG6PNxKNDhlHkCBowZKRe6qqEo/gOqDSpqDsy8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753900982; c=relaxed/simple;
	bh=XpVT6AmTIShKbHggE8PpcXnqWuhT4BsL2SGr5peAtp8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XOGldjlhPxiQ/TRC5R8ji9D9Jf72YU+PGFCeUjhCP7OQVuehDKHxpP9EZw8MG5b1oodZxPje7zW3MDSLxjaDydermejX3ctc+2PbbHHz6LUpPMTUyeAd9tBnSyVgAF9SYCqjhYPoWYPw81NJl9iI9tVHPQIYfn3Y3x2SyHATfVo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dKEW2UZ8; arc=fail smtp.client-ip=40.107.237.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dKEW2UZ8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p6A5UTTDzZhX1dTrw+1NDGaYYc6lGoIsrdnOiOXk/qeHZD1B+4C84DPVP254p7ewMf8UEEkc738T6TFP259w7+xU9y2yaXcDaCwOQIBlh3tLsh/0gGV7yZEm6VisRjPK5OvFtR5Q610ElXYLUjCZzQmaZkaj7NBW732CIGQJc0slcDejuGKsuK/ZzGIhhiNlbMT00rACUTOeqmfL5fLNdJF9aPmiIcKn1a6wLFH5q3ToCOrUznp1hjOhmRONGFENaEUfj8dDGWcKX7QZejtORhXo5Up1KOAwtLT2ZCpzfV7CngSBYMLzhlrzdxxFcrlvEpxkGJPkwoz52NpRM3/KkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u3/ncdndFzzMKknZkd1sB9h31OymnJHsMAB7D1MkPR0=;
 b=ZKsTqgxsN+4/lHnp8hdjrOwC4FROXw9D0fO5lEQUwXy5jhh4h+ngIWAkuezlFkTENQfu+nwFevlicap7ttXFfPYNMdGiB7yArbQzmXIQKq60DQIY+4rwxc62CgMkLa6VMCWYmUhAWcwqXCqo0bpzBmdv4gRuw6Ywl0qlWn3R0sDS6tfZOOY50MKuruWAgKhjsEj04NyQWYzKBCQWsgBIzDj5InQ6L2bkfVKR8o+Vj3v4wxY8XpjPSV1NIUdKzbLO0Kr1PYjHLugOPiv8vJqZrZRQczaQLog1FFhcQJ93Hrf+R5GMsWmTKsSgz72XPIvBSca7v3HF8aau0CchDi6soQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u3/ncdndFzzMKknZkd1sB9h31OymnJHsMAB7D1MkPR0=;
 b=dKEW2UZ8Gbffi9niUfEIyT3QYt1pmctC/L1iI99E8yyh+J32F8JxGeY2ruCyqV6lrUoy9q/oaH6GdmDdUlZxL+FJMV877/TJWHqiOLxn/3Ost40PzD2a2O2QUA0bWFeZ9jEkiC+altPg6uA2tIkGtXO77RvDtayn4ZIf5ds0NBo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by SJ0PR12MB6805.namprd12.prod.outlook.com
 (2603:10b6:a03:44f::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Wed, 30 Jul
 2025 18:42:52 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::bed0:97a3:545d:af16]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::bed0:97a3:545d:af16%7]) with mapi id 15.20.8989.011; Wed, 30 Jul 2025
 18:42:51 +0000
Message-ID: <91258652-7573-4065-9590-3d03e13c9e0b@amd.com>
Date: Wed, 30 Jul 2025 13:42:47 -0500
User-Agent: Mozilla Thunderbird
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v7 00/31] x86,fs/resctrl telemetry monitoring
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Drew Fustini <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
 Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
 Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20250711235341.113933-1-tony.luck@intel.com>
Content-Language: en-US
From: "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <20250711235341.113933-1-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:806:f2::33) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|SJ0PR12MB6805:EE_
X-MS-Office365-Filtering-Correlation-Id: dd05bd83-fecd-449c-a49c-08ddcf98e318
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZG93R1NLMzNaNFZIOWRMTnI3MTd2ZzQyODdZZlk2N0VWU1R1d0tqMFFoTmJD?=
 =?utf-8?B?bjhYZ2drZ2hKd3R3K3JRUWlDMms2TkozMzlzczFZU3IxNGxGM01UUnR0TXht?=
 =?utf-8?B?dE84d3VFU2tYZ2VUZXM1c2d4Slgrb3JoYnhJeXo2cHpjTDl5dDk2Q2hQYzgz?=
 =?utf-8?B?c0dBOC9RRFdNTUFnNXVFTCtuUlpUOWZFR2J4WDZXT0VOOUV3dGhsZkZiSWtX?=
 =?utf-8?B?NDVoV0hmdmRwWXIrMndmdWhaYk5VbjRpRWNVWWhucUtQRXZVWEo0TktRZnJK?=
 =?utf-8?B?OHBEU1puSFBUSHRjM1YzU0dndWdDbTlJM3kra3JkSXF0Yy9IZkVOUGNGdVRu?=
 =?utf-8?B?dTB6Z0I5SHRhWFNBMzFraE5SK3RxMWdzQnV3Rk41QjFhN2tPYjhZdDFFN1Zp?=
 =?utf-8?B?bGorVURRbFZRem1FTFBTZngzRCs3ZWFoZG9tOE1ocjFHYUJDenZ4MnVIYmhp?=
 =?utf-8?B?dTBrRGFqVmpOUXlReGVka0RCRGRGYTN3QnJlcXdEM2FubE1PbjErUmYyZWJx?=
 =?utf-8?B?NWJSeGNpeTc4NlRLSjNNS1VEN1FLTnZQem5rbEhpVkNnVTlFSkRUMXFaOHM1?=
 =?utf-8?B?NWp5TE1sNXJyUkxUTmRNOGFvc1NkV0ZqVnIyL1BIbHM5L3g2bzNmckRtVG41?=
 =?utf-8?B?M3E0REpVbWVhckdLUlg3ams3dHdEdE1rMnQ2eXlMWEZPUnF6dXdKR2xwS2ZC?=
 =?utf-8?B?azZaVTl5ZDU2cXo3NGRrU3Y0dkQxTk14YlpyUWZXWHd3cmhFU3FzZzB0YlVO?=
 =?utf-8?B?UW9kUFlzSEVLM2FkT0FiU2ZPdXZNdElzNVFiM3cxMnJhLzJINGJDcVljclVX?=
 =?utf-8?B?RmVhYUxXcGNiSWQzcWhzT0VSK2Z6M1IwOXdUWUh6U0FzaGVBbmZTb1JoTjRH?=
 =?utf-8?B?bGdhUWRqaTU0ZnppK2pQcDQveTdsT2dlYTNJeUxBRGhsNkNMMXVtSUlaVmtx?=
 =?utf-8?B?YVluZVFiMTFxTkhCRDFFd2dYU3c3aU05dlVkaFBSV25qZHJVbGlleTFvTzc2?=
 =?utf-8?B?czUyZWVOWTdybWhrQ2tDOXhEdW55S3lvdWVVMVozY0dpZnIzQzQ0SVo1Y2FP?=
 =?utf-8?B?bEZyeUdRbU5iNWtzVnJwMXhzRTdzVFhHakFPemxwLzlVdjlrYUxHWFBzeGVL?=
 =?utf-8?B?ZDM0Nm5iclAzeDFTRXR3ZUZqbVhNbnhqcHZXcm8ycmZmWlJ5SnhyN0ZRWDdW?=
 =?utf-8?B?TjdZZ0lQVHhSYm1sVGREV3VmMHhlcE9VbGc3S3ArWVpaTGp4NE5jMnA0OVo4?=
 =?utf-8?B?cHNYa1UxRXJybDg0YUdFY2RZSTNDbmt6RnQyUHhSakU2NGtOZWhZM0VxejVu?=
 =?utf-8?B?cmZneEF5Z1Nqd0FscTgrRXhpN2xJbkUrblUwRi8wR3RsbGV1WW5NcXZ3V2ty?=
 =?utf-8?B?S3RVTFk1Zi9SejZvMHVxQ2xRNUdUamM2TGlmc08ybUExdnFyZmtFTVR6WU5O?=
 =?utf-8?B?MU5ORXN3Ty9Ld1dSck9RSEx0TkNEcVZkd0xCRGxJc2g3dGQ5OG1hZFcvSGZY?=
 =?utf-8?B?SkhiTjNXOTBwVUl2K1BZNnNVcE13TkdTbS80bTU2aEtpTjNpY1JTeGNmQ0hm?=
 =?utf-8?B?ZzQwOXVLYzB2WnRaSmJ5OG1oaFJjenYwbHVBL1UreW8rSmMrQ29DbVRkbDZJ?=
 =?utf-8?B?MGJ3Zlc1RUhLbWlvM1NGWW1EM09GV3BCdHpicVFEQ3pSdytVc2o0dEJ0T3E3?=
 =?utf-8?B?YlNYYklpV3hsUXhTUEhQbXhHYjJZaG5sRm9wSTMxV0JlTTNCSm1pTE9Ka2Zl?=
 =?utf-8?B?WGxGa1RBOGlGRnBDNHN6T1Y1OWJzUGVlTXVhMHVrQWt0eVJpZjBMZGxmcFhO?=
 =?utf-8?B?Tjl4VW5BK1hlQmFVL1d4V0kxcnhvNlVTcGp5OWxtVzlHMHhQQ01Dbmx6ek5J?=
 =?utf-8?B?QW9aRnc4Qis1Q29HSGg3NiswRy94eHI5QWQzQkVINVkxRUlGYXZrZWtSQ2s0?=
 =?utf-8?B?a2Y2dm13RzFtTHBHZWR5NHl2aS9SSGtnWEZtTTZVYnRKTDB4cFJhL3hQV3Jx?=
 =?utf-8?Q?9xRfWJJ8X4cNy7miHUGKVB4R0Qt8Hs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(7053199007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UnN4Q2o3SkRvY0oxaHJud0pIWGJxVGtaaGxwRUd2dlBaemx5WWJlcVVEMFN5?=
 =?utf-8?B?Ly8vSjJ6TzR3aTlvOFpGb2Noa1pjTUplV0dZblZtMlFXSDZZZ0RpajlmeHVm?=
 =?utf-8?B?aFJNbk9BZkVzVjlOQVpmSktPVVZTOTYxcmt2ZmdMbTZBMVBvV3dPai85VllS?=
 =?utf-8?B?cS9HWkk0bVd4eVVaTzhReEN3SWxIS3JBc2I3V01td2FNMlZUcXZ6RnBvZGFZ?=
 =?utf-8?B?ZlV6eHY5ZE1OWkFES3dqZ0VVWG1BM01abVFGaVRDY3BRVjVaeVdCWVJmVmtz?=
 =?utf-8?B?dUl4M3NzVjBDSEs1cjE2R3lTNkN0NjRHaURSRm5hdUNxSU9PVGlBUE12d1hQ?=
 =?utf-8?B?cHBxbWFudVZXVEJaVGtwdGZhWFZOcllEMEtBTS9lU3hpNzlSUGdpdWpTaWdv?=
 =?utf-8?B?Qyt0dVlSTFhWZGRvR0YwOHQ3aVZXRlU3cHFOdWQwbGVLN3I0enJqK0hvMFNa?=
 =?utf-8?B?ZHExS3dRc0x3VW9yMC84L0JjWnVZMkduZzl6VXhGd2g0ck1VRGFKczZUcWxh?=
 =?utf-8?B?MkY0Y0dsNThRa3ViaFFwRmpiODF3KzdJbWFhMW5RKzRETW9XRjh5MFNuS3RY?=
 =?utf-8?B?b0FVNHdEN0IzKzFxOSszYXdjYlVDNk1zZ3ozL2tOaFI3MVdBWDRkTHN4bnVF?=
 =?utf-8?B?b0xzbS9NN2MyT3FoQno1MFhjSnhxU2xzU0ZpdmtPclE1Y0wrMnFtRFZsTmND?=
 =?utf-8?B?c1NFQmpRWmlBOE5MeTFCdWtxT3FtcHdLeTdUUHROUDJWSnR0dSt5V3BIY25K?=
 =?utf-8?B?RUJyYkhFblJiQ3hmOUpSZU9Kc0VUaGtwcnludVdBYUdJMmNLdlFGUjF0RlZF?=
 =?utf-8?B?ZHMvRDhyZURMUGJsWXRRQ1RKUUVRZ0dvZHg1NGRrU0t6bUN0SVM2U3BFYUo0?=
 =?utf-8?B?RUY5Ukh2Nk1iKy9oWXRyeGZmMGVZT3Z5SWJwMHpscTN4R1BnK2c5cFI2Q21q?=
 =?utf-8?B?UllqRUpUNnFxTnlIRFFMZThNd29JRkl2cGIwOUxwV3BlR2NPQmg4Z2VBMTJM?=
 =?utf-8?B?ZHk4SE9vZ1pTRjJsSGRpejV1akVCR3RQbDBTSlJ4MlFNcFFuc2JyekQ3WFY4?=
 =?utf-8?B?T1daZkM5WjJ3bkU5UGdoQy96YjF0ZkNIRDFPckgvWFZGOHJ4SjZ6SlB2UHdm?=
 =?utf-8?B?eWdWNStuSmRFekh2ZC9CT3F6K1Y5cjRiS0JHSzNDOWgzSTlQVzJuREsyVFJL?=
 =?utf-8?B?TFBOWnFOVDBuUkVDWkpsdG93TzJiZkpubUNad25wYWY2MG51V1ZocE5obHlP?=
 =?utf-8?B?T2o5QzZZenBQQlZXU1pKeG5SOHNIdzlpRDd0YkdncDg2eTRxclk1QW1BSHha?=
 =?utf-8?B?NjdpVjd0UjhOa1RrVWNxNUp3NWNSMjE2dHBMU2V3OGtCZVdVOWlTQkJyVllm?=
 =?utf-8?B?RXdoWi8xVEcrN0ZnU05sYzZDcjNiQ0U1UkJqYy9PSzlUclVESDdJRXkzM25G?=
 =?utf-8?B?UjJaZ1c5ajVDeitWTEl2UEp1Q2ttdWJlaGZNd2FqclMvT3FWWEVIS2JoKy9j?=
 =?utf-8?B?b1pEU0xwT0thczNCM1BDcm50R0ZGOU5kRDJzWlZoRGJLN3MzTlJlUXNwWlhP?=
 =?utf-8?B?eGZaSlJKcWYvNzRDckFaWmV6U01nSHQwaGFibGxkVmxvc0RJYnM2bEVYaWxW?=
 =?utf-8?B?TjdxeStRWXRGekNmOHd2VENVbmlobURsdnREbjNSamV2M0J1ZlBZb2RWKy9h?=
 =?utf-8?B?ZGRjT0dzYzRZbGpuK3ZUU2ZjcU1FSzhTZG5hclVwZzFrMHM1VGo3M0hPR0FC?=
 =?utf-8?B?Y1oxenNKVzhqQ3p5bHRpZE9hQk42OGNHbSthRUdNY0ovQ21wS1ptem9RZVN2?=
 =?utf-8?B?cHJLUGVLMXpFZjNZR3graGxJMzZjY0RiZ0tUMUhQTEFqN1oxUi9WaDVMOGxq?=
 =?utf-8?B?R3QvSW02dVZXZ0VLOUdSVnRiMDZRTVNKb1dEbXlxaVhhNnFzYUtMdzRLVWVR?=
 =?utf-8?B?RUowaGZYL3V0YndTZzJXVkxXSVdPaG1Pdy9UOUpUeEtMajZnbWYwUGFoWmtD?=
 =?utf-8?B?WEdYTlowdm8yTGRRVmlwL1lzaWQ1V3FEcnh6cDFvQW5xcWpFQmJ3MjJFOHRU?=
 =?utf-8?B?c0M3U09OaUswbjBQTHU5T0o5UzNsVVlma3pwdUlqRjNIQXA0dDBudFZqU29D?=
 =?utf-8?Q?fj8U=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd05bd83-fecd-449c-a49c-08ddcf98e318
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 18:42:51.0399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cTcWx68DNWNjdJHuGQ00ohDGk6HrhwxmMdyz65cQYtrkZcDcajDZXYKfuo3a+GAA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6805

Hi Reinette,

On 7/11/25 18:53, Tony Luck wrote:
> The prerequisite patch series to the Intel Telemetry code is
> now in the Linux x86 platform drivers tree:
> Link: https://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x86.git/
> queued for the v6.17 merge window.
> 
> That series is based on v6.16-rc1. One resctrl bugfix went into
> Linus' tree after -rcl: commit 594902c986e2 ("x86,fs/resctrl: Remove
> inappropriate references to cacheinfo in the resctrl subsystem")
> 
> These patches are based on the x86 platform drivers tree plus cherry
> pick of that patch. For convenience I've pushed that base, and this
> series to the rdt-aet-v7-base and rdt-aet-v7 branches of:
> git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git
> 
> Changes since v6 was posted here:
> Link: https://lore.kernel.org/all/20250626164941.106341-1-tony.luck@intel.com/
> 
> 
> --- cover-letter ---
> Rewritten - and then updated with comments from:
> Link: https://lore.kernel.org/all/f3ba783a-6387-4997-9e8c-897109ee3559@intel.com/
> 
> --- 1 ---
> Added review tag from Fenghua
> Change kerneldoc for mon_evt::rid to "resource id for this event"
> 
> 
> --- 2 ---
> Added review tags from Fenghua & Reinette
> 
> 
> --- 3 ---
> Added review tag from Reinette
> 
> 
> --- 4 ---
> Added review tag from Reinette


We both(Tony and me) are carrying these patches. As we are in a merge
window now, any plans to send first four patches for 6.17 queue?

Just a thought.

Thanks
Babu

