Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E084A06;
	Wed,  8 Oct 2025 21:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759959333; cv=fail; b=tobpas79gZQVn/+Ez1V3lis78YNPamKdnpchFR/QMXMKkOt8mafO5nQwdcv8cgD9OMVPOOpH+XWu6ba0et8+083bqw27KSUmDPKlg5BYOFWQTtJlJU6NaKPGXK9ntN8DZQ9tG2v66j5wXDEZkcwKGePqcYj0dwGkC7XIq3VgegY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759959333; c=relaxed/simple;
	bh=stg1wKSa1jBuTJZng5EkTvq2ayXCgv6U1ZkQDFMhKDU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LL02Iz6+lwjHR/1ckd/55nboiTXmcEazHnh9r+j1OdyAbYwp7LsKCna+1BebLi/NAwjHXU+IsFPT8aCE0WM4xzsZ6KA7C8b5UogzlKc25Z8zIk1h70X0HvdIgojvyKHaG04w51BjdRrWavicQg+1ppcGEZZngdkV/CF3+P/bXKg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SNZNioU8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dehwHmEj; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SNZNioU8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dehwHmEj"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 598Ktta7032203;
	Wed, 8 Oct 2025 21:35:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3QilfOGBYDEnARdseHQWdq4CigqXzYqFzm2GoumeKR4=; b=
	SNZNioU8hCdPruEsj4WETSf5dM3MeR+Xp40gS7oJbK23sR0T9DHVryyH3xJfcynL
	Azo3FvgCFtrarsz4WhLVfljMy+2Nt4/n07CT8ypjgUIwl9GkWHEZJuIDxEjkvOfl
	HG5hxsSdZ9wLhvIbLesOLKR/mGPo3vnsHGMaaSKrGyFN69/gaJs4hff80T4glhVD
	QKm5gQrgfSGRcGkwVutD3Wep0ghogk2uF9kpIe3v7p/BSYbWrWViTlkkP2KMjIC/
	PqaSGnDhy3Ys2IlvYOMK7fZm7AFh80BGYY8tl9a/g1N72n+15udETl3aYaKHGzf3
	Cw78mnVg3Rx4yY41/5+RYw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49nv6d0e2t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Oct 2025 21:35:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 598JKRDO036923;
	Wed, 8 Oct 2025 21:35:15 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011040.outbound.protection.outlook.com [52.101.52.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49nv630j05-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Oct 2025 21:35:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PnAtIaQvRCTJ5Bg90QmS7XGv+ZChNbQENrEYwTeK9Lzs9DbyMnRLQruVCrsBQpa2efCmQl6Zt16fmcYlw92S6DQ4iOqEN2syV9tG8wRUqCwvcfdv8d8FfR7obGsb8s2mmqrOtkT6iO6NJ38E7y70k2NmcSjChM5095hwn9lLrS73qf8eYtFCxrtVSq4UqLuCBF35snJVCssTi0xFZhRpDU8CPmMAxoIEEaWZ6K4E+ExtZBQzfpjq/TfvOLaGFUe23xVXXBFZUbS+ZL3vzex4LFwAgdx8CZ1jmKowQ5JPhxeCZokanXwgMvaMfOhGWAFQCthHQT7+S/6WcXVFk+dd8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3QilfOGBYDEnARdseHQWdq4CigqXzYqFzm2GoumeKR4=;
 b=puNEQP0ch9eMHVxlsFddjchhq0dXjrZh7o/vB1xBSTke34DA6e4Q5r026++RLSLV/x3ZUte8c5iIDjviHphNpEdxMwnLwqVTquR1lZaaE2dJp2749sLKaSMTRQh3oxPeliqlXBsyOWkKTgJah522Yc2hqJyr6C3ct1kyra0Dtdv1aWc5tcSDPoL2YT+M+pTWYlG8J0NXy6VNWwjG/DzaGbT12qIBzhPqNt3Mf9RlMW0v/8gcfum5aMsfkR162BW1kOl9afPVUh01mNR9gdTpBBkY4FRy+DTRh5g/NjZXuR1BDctyD5XFRV9ZIKtDPLksoYqYrkuOrVWdu5Rgh8mSFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3QilfOGBYDEnARdseHQWdq4CigqXzYqFzm2GoumeKR4=;
 b=dehwHmEjVEtxloiWKheC5h8lzpZqu+qmXH0J1zjwjCKfMVX8sqchFmVqkDNVTGIAHZKAQWlY2GLmidsSwSqG4EKw8Q+HutFLyHbLR5Up3a8eIbClhLFAHJ7Z90nAKQ9SlHNLvpK6m8PeJmjmppqqx2xb2ncRzefttvjgBL/mtjo=
Received: from IA3PR10MB8735.namprd10.prod.outlook.com (2603:10b6:208:576::20)
 by DM4PR10MB6277.namprd10.prod.outlook.com (2603:10b6:8:b6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Wed, 8 Oct
 2025 21:35:08 +0000
Received: from IA3PR10MB8735.namprd10.prod.outlook.com
 ([fe80::396b:a1bb:fdfc:d599]) by IA3PR10MB8735.namprd10.prod.outlook.com
 ([fe80::396b:a1bb:fdfc:d599%7]) with mapi id 15.20.9182.017; Wed, 8 Oct 2025
 21:35:07 +0000
Message-ID: <10599aac-3370-4f8a-a18b-4ca2d645d6b6@oracle.com>
Date: Wed, 8 Oct 2025 22:35:04 +0100
Subject: Re: [PATCH rc] iommufd: Don't overflow during division for dirty
 tracking
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, patches@lists.linux.dev,
        stable@vger.kernel.org,
        syzbot+093a8a8b859472e6c257@syzkaller.appspotmail.com,
        Yishai Hadas <yishaih@nvidia.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
        Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>
References: <0-v1-663679b57226+172-iommufd_dirty_div0_jgg@nvidia.com>
Content-Language: en-US
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <0-v1-663679b57226+172-iommufd_dirty_div0_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR0P264CA0247.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100::19)
 To IA3PR10MB8735.namprd10.prod.outlook.com (2603:10b6:208:576::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA3PR10MB8735:EE_|DM4PR10MB6277:EE_
X-MS-Office365-Filtering-Correlation-Id: 77c4b332-15ce-4030-389b-08de06b28ce9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TzNxM2lHRWgrZ0tVdjB0UmY2dWJMV3VaRHkvTlFFNVBteHd0bVl0aTA0cDRj?=
 =?utf-8?B?STJsY2VXeFpGbnpWWTBJOWthM0hPVFhoZUJWOWx0SFVWOFpaUUYyQ0xjQWJx?=
 =?utf-8?B?VXJXWjlyYTNvZThISUxqaGpaTkxQcFFTUEQ0RjduZm1UYkNZaTYyVmNzaHYz?=
 =?utf-8?B?a283Q1VGa2h1Q1p1VWNORHVxOU11dUt0K3diRk1RUmRSdGxmUmh6Ky9XVWFh?=
 =?utf-8?B?WkRrRHJJZnM0SEJiSXRIM3ZFKytvNm81K3F3b0QrU3JQMUVObmhHU01GZFpP?=
 =?utf-8?B?QXlLSXlTREVyZWdmSUxFMnlHeVE3YUZpVVYwNEdQWWxHRUFqbWdxL3R1TjBM?=
 =?utf-8?B?Y0p2eU1JNnZiRTN1UWhnMU9sMnBkdmNxT29TMm00MlRxSGJnTEd5U1VGa1VK?=
 =?utf-8?B?czRZemR1eVJ4OW0zWFBoYTY1TjIrSjlVckM3L2dCZmtVV01RdGYwSjdUNXV4?=
 =?utf-8?B?QzhTbFB6U044VmdpRnVyQWNJQ3RGVGhlMCsxL2Y0OVlic00vUzhhQ2JVT0FR?=
 =?utf-8?B?d3hHS0VINXV2anBHb2tCNkQxSE5SajI5ZVBGbWg0NnlGUmRtanRpV1dVQ3RV?=
 =?utf-8?B?bVY5T294QnhiNFVtMWxsTnVuNXVOazZkWnc1U1JrLzRZVVV5aTJUdnlOeXVq?=
 =?utf-8?B?YTQwUEFrZlZoaUlmVEFtZXFpRHZjcVFkZUYxejNtMSs1ZkVIUVJVZDJUcXRB?=
 =?utf-8?B?UnlYa09Pejdodkt0dTFEeWM5c3FKdHpwaUJiM1BYSFY0aXBXS3hSOTVIZUJl?=
 =?utf-8?B?dkZRcDR4Z3JVbFpYdEVHUCtVNE5aYVBmaHF3QmRzcGYxSEdWa2dSSlU0U3U0?=
 =?utf-8?B?QmV0SzhDTkF6TWJNWjB2YVNFVzRPNERKczcwMkp4ZlRpRUxKOHNQSUJVME5m?=
 =?utf-8?B?VUZON1V2Wk1nRDdQY3ZLcmtTRGJZVzRoUTEwSkRUR0E5bDdPWVlpQkM4bE1j?=
 =?utf-8?B?YlJsMk9INEp3aFRXTVZmRUJzZUlSSUFzdFU1K243QmgzSytQaG1vWGc5ZExW?=
 =?utf-8?B?UVVhUGpIaUVITnh1b3hHYUVFOGR5cXA0a2NBdzlreVVQdGc1Tzh6b2hncEIy?=
 =?utf-8?B?eEU2U051ZjZDTitOU1VReUxjUjVHZEwrR2VGZktnR1ZjVmdWQjJoZG16TlRW?=
 =?utf-8?B?SXhvSnJjK3d5VEpsd2wrSEp3eGkvQ3dwK3hQT3hubXIxRStlWEhJcFNJRTFi?=
 =?utf-8?B?NEQ2S280a0VhTFNtR3lVZ2hKNDVUNVdyamxZYlZqbHZYUzdIcjRtZDlEOGtp?=
 =?utf-8?B?dllwb0VZMlI5N1F6d2FjYVpueFNIaGxvNkIrRXIrVWJoNWh3aUwzNTNrUmx4?=
 =?utf-8?B?enJ3cUNyenMvRVUxejdwTjJiUzQyeW1PQ3Nmd1dldytYTUYzejNwQzRQVDVI?=
 =?utf-8?B?Sy9TOHpkaTZwQlN4VDdVRW43Z283N2M0c012NVFoMXVGNkpSOXZqdzQva2NZ?=
 =?utf-8?B?cTF1VUR2U1ZnUVZzL2FMUmxJeWhFc3pmMlBvY3B5MU5hc3l4MENhcUVHTE50?=
 =?utf-8?B?TTlUR05lT2gxbUpyVUhKblkwcGRaVXNocXZKd2hxcHYrSFY3Q3ppdGhkRVBU?=
 =?utf-8?B?ZFltc0ordVBUZWJPN2R3RHZieGl4K3lCWDV6VjNWd0crbERzZy9tNGMydTVF?=
 =?utf-8?B?RG5QeFlCMjlWNUFIV1BCbkp0YUxPOFoycW5uQkhiOGdNd0U3VHlqRW5nTDBh?=
 =?utf-8?B?STZjL29SZVJlTmdrakxIVEJHcnY5VFB0Mk9HUllmRjBKSW52S0ZHMExsMUtJ?=
 =?utf-8?B?V25POUI4S082anpLMUtyQzlWYjd5UFh1R1c1YjBtaStKZkxDenI3VytXRENh?=
 =?utf-8?B?WE5YdUNwM05hT1NMc1pyZkM1VHBiTGlpcEdDUWU0enlqMXlvRXJNTElyaU5p?=
 =?utf-8?B?NDNBRS9lbDhFTDNkYXFaL0pIalFxK2xXZ2Fyb2NVZXFGV1E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR10MB8735.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cythWmY1d2lBKzNTUkZ0cUFiekVYWEJlbzlsNDNldVBZNmlvZmVTM2UzRzRw?=
 =?utf-8?B?RUpRN3RsWExDYVBiSEtra3pvRmpRbVE5OXNXVHp6OE5iU1ZuKy83MzljLzU1?=
 =?utf-8?B?VlRKalI5WWFLOVZackJOby9UTWxXeHF1cHpJMlErTHovcVh5dFQvK1ZvZ2ZF?=
 =?utf-8?B?eFZreXA3cmU3U0p1YzVrUUZaSW9GUzJSMjNudGlEZmhKeG93YjNKNmdFZHBm?=
 =?utf-8?B?WXQrSFZmemtrTEUxcFIyaEs0MUFPOWVJWU0vRllrTTB1Y2hUWTJ1cmNpMGV6?=
 =?utf-8?B?emhob1MrOGQ2cDltazhWYm84THpzbzBLeURKTnVRRDNLbjBJc1Y2ZWZpeVVm?=
 =?utf-8?B?QXZUcGxvZVpURVVlNm5uZXJwaEIrS1dLbWVPMWkwU3c4eTcwUCsvS2ZQQ2VL?=
 =?utf-8?B?aTlVMERQWW1TL0UvdExkOVRpMFJaRU1ZeTc4cWZXdW1MM01NSVMxd0pJTkFB?=
 =?utf-8?B?Z01BdGJzOXdQS3NkL2VwWEhMZFU2T1RTcU40blpmWkZVdHlLTkg4Q2FUeEdW?=
 =?utf-8?B?T21qbDJiZDNtQW9IREVRREFMUE90LzR6QUZ3c3JYbXBUZmphTWZnMjhBRDAz?=
 =?utf-8?B?Z1hxWlpWWUFLdC81eG0vbDU3VU5vbzBhTEJiajdsZ2k2aytnY0RnSXlnOHlL?=
 =?utf-8?B?RmJiL2twWUVtbklRNmtvamxZZXFEVTd2R0syOGJ3c3VpSW0xWHNMUWZYSjAx?=
 =?utf-8?B?a2Jlb2JidmE2M0c4bWV6U01IWmQ1ZVlvbFEzd3hkU1lNeDZkWVBNL2F5QVlS?=
 =?utf-8?B?L1JKUUVMUVFwMVh0cVdsWk1GYkVsN0x1d3JLdXV2dkZuelYvNGRySGVqMU4y?=
 =?utf-8?B?cHE4RjE0NnpYaVlUU1FWcS8zMFk4MEt6aURzTklSbmhScjhtNkNhMngxaDVI?=
 =?utf-8?B?LytMcjNLMjRIVlZ2V2tkRyt5UGFiMXpWbmNuaEtKK1Z0MXlPNm1NYjRRYXU5?=
 =?utf-8?B?NWl0aDZiaUlYUnoxelFRd3RLblc4Y21vWU9uWklyaDA1SUE0a3pVM3hHRnVD?=
 =?utf-8?B?N0tmUHFRWVExSEdxY3E0MWozeTJvRCtQVEEwNzhoOHdSWFpjTm1hbiszYjhj?=
 =?utf-8?B?Ymh5ZUF0MnMwZ1crTjZCK20rSk9Sa0ltYktHSVFydDNrWWpnZGwzWnQyNXRG?=
 =?utf-8?B?ZnNweStuWFB3Q3ozWFBXM0sxbWRUd25vT3BYOWlsdTFBcFZ6YzVtblRLNU9C?=
 =?utf-8?B?b3ZVQUdVOGsyMmI3eXV6SjFTV0FaZTNPR2FyZk1mTW5qV0d0cmNUdjNaTngx?=
 =?utf-8?B?YWx1cTdjbDZDZ3ErN1BOT2lwL0ZHYk1XbU9YQ3d1UWN6NmtLTUNVV1NzYTdZ?=
 =?utf-8?B?Z3Zaa1FxWDU1aDkweWlGWHZmWmIwYW9JM0RBSmw2bTFvSDl4cW1nRG5sZ2tx?=
 =?utf-8?B?TEhuRTg1TFpXOFJEaWRGSHkrNS9XSW9yaW9vNUJhRWFramdJOTNxWmlvTmtj?=
 =?utf-8?B?QjYwVzdqYkxVNzBJMW1EeG04dDVDNnZJZWtSOUxnVnJGKzB0ZHhkZ1hBQ3Jj?=
 =?utf-8?B?bmZkM1FIUjd5UVdqNEdFQzRNTy9tOTFkeElyOFlGR0NYd3hLRkM0VVE1anhT?=
 =?utf-8?B?MlA1eVVWakI4UzdvRFgvR09paFg5WlN6MmM0d2gvdExVY3RGaG1Lampjb0sz?=
 =?utf-8?B?RWxzK1FNT25Hd1AwU0c0a1dYZU9MTG9uZk1oVkJLcG5rc1cwVExud0MrNkMz?=
 =?utf-8?B?TXgvNHpxdWppUm1rRnVWZGE0QkkzaTlId3BkK2w4Vzd5MHBMcUdOSW5kcHQ3?=
 =?utf-8?B?MzBZMDFZcTV1V3VxK2NtYy92Vmd0NWw5cnFOc3JOZEUvdGpXQ21xTXU5ZDhM?=
 =?utf-8?B?bTJmRTdqZlNsanQ1VmF1b3N6aE9hSS83QUduSFI3RHNuUHhpQVpPTDNkT3B0?=
 =?utf-8?B?ajRPcmlwNDllNEJpb1BKZU5TN3hhMzcvaXhPa2ZJaUhRVTR1aWJUMzFac21C?=
 =?utf-8?B?RUU1SllRL25Zc3IvL0hVSy9nR1VHclA4WUVkNVdMajJrMXNvazFRR2MyaWli?=
 =?utf-8?B?TUlLdGZ0akExSWIzR3M5ejgrelZ2amlMKzJ5OUc1VTFtUWxKTThxTzZhOGNW?=
 =?utf-8?B?OURzcDM0cFFHSWt1YWpHd3UyUHhvMlV4elZrNDVwNkE3MjZaV3pQNERmcXRj?=
 =?utf-8?B?VW1QQUNWeGl4U1I5Q1A5ajdtVkV5ZytIR1hUNVp4MjBGYmMxT3k4MWJhMlRo?=
 =?utf-8?B?aGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qo39dnVHeFCJ9kKV3UMmQt6aFcNuJ20BUyPdbNhAti5w9tSpmlZk7Wg/uvzXv4yqmBrbS5vtTYk78LR438fFSARXj4YK35ADt7y+N1uXvxS2iATkUWYfR4dawhm4oWTwx+FW+6memj0r0tmTT/1EHSDxFCmfv1MOHsNs5NXnvruCrormHG8aABfC/7FTnPRQ28QlAMyg2vnYvYzmMMks5WvvF5aW4Ee3OZsSroh7urw3mVjp/nI22C8IsG8Zw189ygX9o3z+0qxvh33uulqnmo8BUrDhFwQrewjDyl6NoPaWG6yoW4jo1rdHL/wqxKbW8oHnSf0A8K3VKEOrKO96ReR9BDwOOXdNzvVWvEvEOQZ40xtkxKszxhOOY2yayzPr2gCnC4LD6t3yeFwRp/MTHS48x3x/duj/UNBU56LonyEA1987e2TR84LHpWkHiNgQAbLr1j3NE8QOU4w5Wlksd5ZfBA8SGLI9Wj8O7qw3XT/WS6u4DYaQ/77hrkpcLW31uHO7NKKtQM4GLKIUqRiUn2RoVITGzL6Q+0P86Y+hO3rVL1LJhDcpJc61euxRx+dJrY0iWzfvDdtnBABm3AP30puE8SoZgu7h5KW/jvITA1Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77c4b332-15ce-4030-389b-08de06b28ce9
X-MS-Exchange-CrossTenant-AuthSource: IA3PR10MB8735.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2025 21:35:07.4373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KVQ2ckbjoP8SQlxS3Vx0p8gU7sxWMGac4vbz20zvWmIMdgMxKXlkoDQ1egW0J67bzty112YqzdTgQtEGRbT1skazx8CwCT0PNibnpmSgXMw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6277
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-08_07,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 spamscore=0 adultscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510080151
X-Proofpoint-ORIG-GUID: 7ztu87sNOCOLgRHhrYTGvfkxFIN4I1kM
X-Authority-Analysis: v=2.4 cv=bK4b4f+Z c=1 sm=1 tr=0 ts=68e6d914 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=edf1wS77AAAA:8 a=VwQbUJbxAAAA:8
 a=hSkVLCK3AAAA:8 a=Ikd4Dj_1AAAA:8 a=yPCof4ZbAAAA:8 a=Pyf4ynxWdgcanfih80kA:9
 a=QEXdDO2ut3YA:10 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22 cc=ntf
 awl=host:13624
X-Proofpoint-GUID: 7ztu87sNOCOLgRHhrYTGvfkxFIN4I1kM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfXyQLQgWHszE3T
 CHXXobRT1Y4rkZTtC/iQTZWhaQlVodcmpdc5SX9PYdS4ke5a1Y2E1uvoBjiMKnZ3upkAukYapip
 117hHuVhHe4xBYsVjLMIgkWOa0wwa+2SA3GwpDzU7kYtgXnHyjloQ/P0klyZzLEJzYc4ScZKapa
 x6KcKJljTcIMotf1pjvD5d+xYzzBvzvoDtR0aHMevVUOiBt9U6PnnKoXCRxN8/WfnQOWJsm+H89
 Jnjkuu/XflsYMf283ttvG9KuqV8smRlC3FIS6cMW/aXr/gMIiVY7/rfZ+j7jIpyW0YWFGWxyEzu
 sXYAhL7DCtd97r1fg7PeMQ+is+LEVHdRGzfR5FZMqFhUiXk5eDeBhZ9sB7KkVG8MELH/j+sfTAs
 kgmO6xciGciJ+S7ir7nB9wznJONib1WduQYIyJ1n3qhznaAJw5s=

On 08/10/2025 19:17, Jason Gunthorpe wrote:
> If pgshift is 63 then BITS_PER_TYPE(*bitmap->bitmap) * pgsize will overflow
> to 0 and this triggers divide by 0.
> 
> In this case the index should just be 0, so reorganize things to divide
> by shift and avoid hitting any overflows.
> 
> Cc: stable@vger.kernel.org
> Fixes: 58ccf0190d19 ("vfio: Add an IOVA bitmap support")
> Reported-by: syzbot+093a8a8b859472e6c257@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=093a8a8b859472e6c257
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Joao Martins <joao.m.martins@oracle.com>

> ---
>  drivers/iommu/iommufd/iova_bitmap.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iommu/iommufd/iova_bitmap.c b/drivers/iommu/iommufd/iova_bitmap.c
> index 4514575818fc07..b5b67a9d3fb35e 100644
> --- a/drivers/iommu/iommufd/iova_bitmap.c
> +++ b/drivers/iommu/iommufd/iova_bitmap.c
> @@ -130,9 +130,8 @@ struct iova_bitmap {
>  static unsigned long iova_bitmap_offset_to_index(struct iova_bitmap *bitmap,
>  						 unsigned long iova)
>  {
> -	unsigned long pgsize = 1UL << bitmap->mapped.pgshift;
> -
> -	return iova / (BITS_PER_TYPE(*bitmap->bitmap) * pgsize);
> +	return (iova >> bitmap->mapped.pgshift) /
> +	       BITS_PER_TYPE(*bitmap->bitmap);
>  }
>  
>  /*
> 
> base-commit: 2a918911ed3d0841923525ed0fe707762ee78844

