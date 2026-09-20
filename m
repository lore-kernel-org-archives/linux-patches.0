Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDF5282F26;
	Sun, 20 Sep 2026 06:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789885712; cv=fail; b=hckUJW2pgxD34gIUPmQHKtDdb8y1cz3Rlwkm2hM9+R4TnLtM5Bx/Xh45IKBfT87XY0ddVGOObrXLAtNJc0uar9NTFuKrPAof4pvc/OnC/kvz9bJYQYHDULBrl2caiQiojw82ASq47KWRbcKBa3qiQ8GpIQCr/GB+afPGE33af84=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789885712; c=relaxed/simple;
	bh=Btg4+Zm8d8vekw25ooOF6OvssxblUigNliiulxX7Vnk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WwUnhgDYsjNbQoK7wQKsgKtQsB/DKGLJpSJ6Yt47xO2Nroxsz0kURtTSsbdihgtJ3+XWyFcidpNM+8RkhIYs6b5seciaoPRAatYfxmF27FGAN95ehs4R2jdOGQVHDXWl0lIz7Sl7h2SIq8odFcctC9eN00VN7w49blPE9Pn0Bx0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Tj0MHBlN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=p4gPXEun; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Tj0MHBlN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="p4gPXEun"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68K4uTtO2648941;
	Sun, 20 Sep 2026 06:28:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=d8Rm5M+1kA2qI6ReNuq1kittNZFh0yQNRwIkx1i++Zk=; b=
	Tj0MHBlNy1NZfcuunv4l51j02hjd9Lyg0pzbTIBzr6fuQa6u5pWhLKIjvdRznh3+
	ZOrV7Hqj77tdDePZNXSt2r+cLJ5XJzIRUuzqXnZBSE4bmZQVTh2r7+Q/hV0qesdx
	yqMrwQz+Z+tHg6o7ZpRGv2Oph780jRzy2IJTczh0maU/oIaj1dmQDwBrQ7OUFYgm
	uMpLw8BT7lbUZiPg7xYIF3a9DwU21moSQurX4U1rkbxnxP8ii7IkdgZCdnWOomeH
	J2PeTFTDF6n0lopuwTHQxn1PgZCBFAC/4CeLUIj25tjU8oHSsuws/8sz9SvI3YZ+
	PtiNurMqLePWGh5KVGb/6w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gsk0xgy63-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 20 Sep 2026 06:28:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68K6P25I009454;
	Sun, 20 Sep 2026 06:28:26 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012070.outbound.protection.outlook.com [52.101.43.70])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gsgu9kfh3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 20 Sep 2026 06:28:26 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IQRt65Ddw7vfWZwYz4pEbXRnnDAcWik7CL7s9Zs87KzVG50uxMroSfFixIrN8BNncxcbNB1fLEuFjKjE05iQvE+gZxdDLKLJ5E6qzUoMgDZiK4XTb+w+x+R4KZN4PdJgfR3yfK92+lqh8I48zwC1YLEYuiWyfLVZbdxbuBASOeLNNqqr/z6eYgmQ71sN4mGykSbjcihFBeViWnJnTOQzVrsr0xn1TNUk3DGQH7y2DD+RGgH6NBIVdHjPCBF99Cio2RvH34STh/dqO+8bOSCzAxq/WtJHSmLcopEHQ8tOOGJ/lXbx4nSHAdYfQX9w1Zsn55YG5UTrgBYhnZc26lR4jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d8Rm5M+1kA2qI6ReNuq1kittNZFh0yQNRwIkx1i++Zk=;
 b=oIKBprIRcXdMP+iLdwL9SL5EDgBxIINgM8fuKffBOKoXR50VGRdeFcgu0MtcaulgLgKOkyjy++zX2rCOhnuy5sPPUnja+537REG7XzGXin7zrtkeKDKIVpj+i+GkXm5FMKrlQ+lo5Gr5690+j2OBzc+rwiqi2BvG2esK2zUpKncBZmAZN68j/faWJzAPdZuQOQCHAJcGw/+wIBO2Oq0tiB6gWUgOxmALKJEXMDk25kjV832mO+1Wxa0BhQ7NbpoHYRo0skm4GbZP5l4cxbQJdtnvUK2G97g0zEAqjIn/35ggNCk3oKHHDDBK3O5SWUSTcqK7TsXzZNtSW4pCOZY8wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d8Rm5M+1kA2qI6ReNuq1kittNZFh0yQNRwIkx1i++Zk=;
 b=p4gPXEunDUHaAlRfp+FMdU9zdHYcOYEWMbZo6g0EaFMvIMGGjzHNDqBgObnlspDNjV6IMTVuVF8dO0tQFH6PWhI7OycENq5Rrwk97XdOkyOPNeo4ovFfmJExAXxImx0USwYVvRegZaIFMFMKkrpZT/lBuPmI2B6euMupys7yRRo=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by DS4PPF085C55EC8.namprd10.prod.outlook.com (2603:10b6:f:fc00::d06) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.5; Sun, 20 Sep
 2026 06:28:24 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0428.011; Sun, 20 Sep 2026
 06:28:24 +0000
Message-ID: <9f5619f7-f726-4214-b87c-c052144134ea@oracle.com>
Date: Sun, 20 Sep 2026 11:58:18 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 424/935] bpftool: Update btf_dump__new() and
 perf_buffer__new_raw() calls
To: Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
References: <20260912065526.833703348@linuxfoundation.org>
 <20260912065536.549009682@linuxfoundation.org>
 <51f57a9f-3960-4d8f-b6a4-26ca6985f35a@oracle.com>
 <20260920000825.9-1-sashal@kernel.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260920000825.9-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0095.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:27::10) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|DS4PPF085C55EC8:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f348633-ba1b-4f9a-1e37-08df16e05f8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|56012099006|6133799003|4143699003|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	C0sOjx4vlbT1poElOwcFdKGnCc89YE2My/fMPBz7DgsdKNqdmdU3uE0YHMyGoANRpkSdyLmObjPnRPbiYVARtZ7vA0+i/HJpJAuSfnJQ6AtyjAuCs/Alpn9UAH3aFFXI/5nqCZYW4Pnlawcy7XYQm3tYqS3Y3VhT/xwXXNXfXA56ukdB0oCoh5PDHhSjx5mUzmQrXg39UEWyinKOHcnfo8oLwGIWhbzEGCHmNHgnUX5lShRrRZ4/I2lle1zNadZfevZhKcgMaCfkIRW/zepQSjEqe831YrLtqIK8qsxSY3rQ2GWzzE4BGWV3cf+1q8Q5Zg2ZfiZdgf02Eg6nFkLbg1a3SkNNOXnXYRjK7DHaqLuSwAIZ5VioEOMtaG6QKnh813Trlx0kaQqNFjB+MPjwBWE+sRZbGNPbwFzRPjPkALz6wT5nAE0qCOHwbja7yHBsS2xQ7c2gwgC42rAF6ds2FX0h0wS/AkxswEoe7adk6nZkhFca1OtzkcKitBRGIjcduoC/1yhrLnwqRHcJuxroDULZ8IJ4eUjV3YaLHuzzVCWgokvERLzSc7D/2kreNkuBX1RydulW52Q+fGBrfF9/2fnn0NBabGCyym7CmPSLeJ9aaU69Fv1ho0jpkuwuD7NbXQf4EOc6RfCxiCYfwdRhg95lkOAZ1GCJ0G5NmWTmI5c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(56012099006)(6133799003)(4143699003)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WUN5bVA0Qm9QMksvaTdLRzZwNkp6WEltSlB6Q2hzWVdYcGNPTEt0L3drNUpa?=
 =?utf-8?B?TUJPdlhVN1FObTVCOFkrU0REeURiTVQ3UVIrRTRTSlRLczFmT1dLUmNRQ2RO?=
 =?utf-8?B?S00yZHljOVRSSmFodmJkdUdVcjJpZndZTHNJeExoRVJ3dk0yaVhnNlVoYUJC?=
 =?utf-8?B?eDNNaDRBMUdwRndiNG4vV2ZOOEh1RGg1WVg5ZHhDUmpjcUpHWjUwUko1SFlt?=
 =?utf-8?B?eEdtNTMvdURiUDFrZXZTYnV4ZXJuL2xDZDBRL0lQbUlsMGV2NWpvQmZCVkpk?=
 =?utf-8?B?SXFwMFBNekpzSjVrL2p1NDFteTFGMENyMnVyUzVlQ2hhbDBqenRjbWtXRnlV?=
 =?utf-8?B?cWM4M0Q0ZWQ3ZCtNSXNZY2lwaHpxdDVyd3dNSHpMNUNOT3NCOXFsWEZRRDhW?=
 =?utf-8?B?OTlHcXBHVzBrL1NtS1AxbzZ5ZklOcXhPellzem1RNnltNmEzNWVlcGs3a2dE?=
 =?utf-8?B?RlMyUTllVXN1UGJpTk1sV25EanlsTVk1T0xSUU0zdlNwVk52Wmd0R2NVWjJJ?=
 =?utf-8?B?UmVKK1Vkcmh1dGtvcUM5ODRIUlJ2ampNS0UzblZ1T0pmUmE1YVVaS3d0bzhq?=
 =?utf-8?B?ZDkwVVJlUzZPQUtpSTlTY1p0dXVvTW1MUkYzL3l6RGE4ZDQxTHJZenJCbEVi?=
 =?utf-8?B?Z1dac3ZHRVdFQ2FTWHUzUklRZldrSEpXV2J6TzA1ZDc5YlArVVlpSXV5QjEr?=
 =?utf-8?B?cE9jSXZJWjRLanc0VjN5SFNGSmRnbnlkN0wzZHArL1BTR2ZQSmNabUtUZ1JE?=
 =?utf-8?B?SGI3Q2c5eVAvUXdDVThaSHVUMGhMbU14TmNZZm4xWXNleFhQcC84OWw0QXF5?=
 =?utf-8?B?TlAyQmZyZnpFVmpSTFlnWWduK0tYS1lyZlJCWWQ4cGkwQ1IrZWM4QWhCNG96?=
 =?utf-8?B?VVdoWkdmY21USVlHN0NyYkZaVU1ENWVjQjh1TDBYTkpFQzcxc0lTMmhtWnNj?=
 =?utf-8?B?U3JHaFo5aDBGQmRKWWRFTlA4YTd2WWFSWDRWWDI4VjEyL2NCZERLaFI0SXVT?=
 =?utf-8?B?RXBsYlZQYzVHWUhhdXVQRzViblhBVVA4eVZWK1dBSjQ1amVjUzZZUllwamNZ?=
 =?utf-8?B?bXFPL1VJd2xmckROSGRtM2dWbTVkMGtyMkNjN2k5TDlrd2duWVJsdEMycnBE?=
 =?utf-8?B?Y1k1b2tPVklBdTVuRnFRN01hMzVyYkZ3SjZSNmN2OFhDOUNUWFlqMFdGNUdl?=
 =?utf-8?B?OVJ5YlJiTHlub2JtTnQ4WEZHV0RoWEd6dnJOc2FLWlVFNGhYK0h0RTJvOGRl?=
 =?utf-8?B?bzJGbjJ2bTd1NXRtdGtmdldBUzBGT0xQZFBpQjNDOWViSXgxYThVTXNXRUY3?=
 =?utf-8?B?aTRqNXR2V3Vjb0xMdFdOMklGenBQSWtPUFVBUEtZTGNLbTlJU09mR3o4NXVC?=
 =?utf-8?B?MXNrM2tsOHhtOXZPZnBXRGN0MklFaTBTOEZDeCtxNWFFc3FrSFJrVmdvaExh?=
 =?utf-8?B?ai9CaEhIZG1nRzRWZFFyVTV1cEcxYjhEVWhoNytPREJNNWR6Zk5kK283cU43?=
 =?utf-8?B?emNoTE0rcDRLOVFrQU8zQkQ3OVVWK3c3YmU2N1Zsb0RKSEhMVlhxcE5xb2tE?=
 =?utf-8?B?VnQ1aVhzVnF1ODViMzNDWUg1MXBTTU5DWURzNEJIL3BQSDFVMi9nKzFvcmpL?=
 =?utf-8?B?YUQ0SnIrUTRPUnJsRTlvVnNYVXppS09uazErQVM4MHRzMXdlZVY2VkVkQkZM?=
 =?utf-8?B?YkJ4UEpFVXEwSE9sTzVwbzJDVDNQVTRNa1VhN1cwWGRwRzYvZVJSNWFlSVlk?=
 =?utf-8?B?czVqZ1RySEE1SzB5a2h5MDFOMGJvRjhOYUlBYlBBNnJocTFPRU9yRm9nQXJR?=
 =?utf-8?B?QXZYaDVhMURHaG1PVzVLQnNJQnExekc1VHc1eDEwTlRQNHlWdS9Ic1U3eXhh?=
 =?utf-8?B?YyttbXJ1NXNyODVvYngyU1hkdUdUb1lJWW9QWGtmTzl4Tklkdy8yc29oVmxq?=
 =?utf-8?B?bmVuTHM4d2l5R24yd0VQRHdudHBJa1RGR1FZWjlpbDdqQU5SWkE1NTRYVVpo?=
 =?utf-8?B?YUpVRy80cmtGcUdNUnAybGE1ZENwUnJxQkZydTF5bkRDL1QwOU1kWnJzZitz?=
 =?utf-8?B?SzN3UnZUWHV2bndIbThtejIraW5mNEptdDNKZ25zbUdmTW5iKzFkeEVSQXp6?=
 =?utf-8?B?UTM1Y1hpK2s3L2JNaGpzbG9VY2xYZm1pcjBrVUVKMFk3MFlkL04vcHVtMVlq?=
 =?utf-8?B?ZnFSRmpiYU5ocG9MbG9FbExibzBZY0Z5VnFqRDNTOHZ5WGdpdThqRmp6aEl4?=
 =?utf-8?B?UkJWeVJEMXp1b1JJMlk4aVExcjVHOVdWSVJyczluUFRmNjJZNWRmQnZKR1FP?=
 =?utf-8?B?Nld3NEE2TDcyN0tKMTBJbktmSE1GU1ZLZVQ5TE91dXkvV1lYMTk5NGhiVmYr?=
 =?utf-8?Q?QwlqLrEYr0EQt/CS5Dwxyp44o29+wKo/pBfyj?=
X-Exchange-RoutingPolicyChecked:
	W6Q2v0+N9EYAxbl57QIWTVcEe5287rNC5ricNHLTCWhynP/3TYtWF5EjIA0x1cfi/6eWuW3QND8FS9tknOlihV+FmJMEg28fmNiIHPnDuAM98tPSUabmkHZi2TUu6DErdWvPXLQUCBryxjAHyG6/NnM93XtT8+eIdgM/NRZVW0o/GyPH3EzK+TGT9iOkWOgltkALAJaqqFQkLGWP4TxknB8mQqf58BN+3Agdal+D1mMcinpz/BXpTQ5FmQ0CA9Yh0QO8QMzgGNQPnuI3aFoSE5uWik+FUYmfCDWZCNhIE/JK71CQo2j2s5ECOCtYTNMaqz2lqdgsZrnFXXOn/M73jQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tdeWuVDSavML4+bnRLCB8JIWpvVZXVur2RXXgqFOOIaPvngswWsqTpgnvsqw8oFDXHS4Bo8bsgoObk2hDEODPoV5xVGTwO3yAl622alQYmEpm8zih2RBJzTPvGhEmsie/iLchkm4g+B5uRj2pHl+1BxiIuYuXSHmSLHDlIi1eBDa0maFH8PVWoiG3EQWJTPBosFUbN6ElQhYgW0eY4czwdD/fzuojK2hrm2ztaa1sKSaqEXRNL4m5hrXxJsnF5wQAxM9oLvOX3SBvQXOnoyi9iKOaHQ00MrpTdT4LGelC/uyG+xM7K1x//ECNxknFUoqsimBkZkGZ/mMPxB6Y9II0lZrLnvHN97YXw/EZipEMz9spUOX5iujy32qY5pFMXV1PmJ99ilcRXGjihOxI7CH/of6Rj5OFsIliCtFG/Fl9MUr54RDaW2gQFwoYEL9cmrgWuD731p0MoASSqdqXfQU2LQjLXqSidQ6RAt4HVVosE5FvYNhJ6INI21D5EbIvhqxZnvzISQ7XH7MXDMFlGqtwHDW+TOBWFlKWT6H0vw2vJIa/Lz0bpiuKetwGex/yP5ocqibAr37WltoqPd4D8gwg5tuP0XYMO5WvfhoLBss15w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f348633-ba1b-4f9a-1e37-08df16e05f8a
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2026 06:28:24.2175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W0r5ql6vhz6raIqzM8aS8DCqD0ZGxKIJQgAT47JQpRFmkn0jACKZRdbnBPI6YVLJNKAmsypS807h0TP0r74R45XUVvZP0ijtUR4DaH3mnMaVwbGGJ8ccEvk2I+1DOxYk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF085C55EC8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-20_02,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2609200090
X-Authority-Analysis: v=2.4 cv=F/bC5ahN c=1 sm=1 tr=0 ts=6aaf7d0b b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=dgPlFU0zy-65d1XZ-AgA:9 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10
 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIwMDA5MCBTYWx0ZWRfXwtH4i+o/6+OY
 +GmD30VOfSdJ5gHZP7GWx2jiAWe0IHsOSrbTvoBLfRqZkQa6w5aJtdX7X3HccRhj1JZkNpe4R62
 e315kd0XnnXoXSotl7+O3CtlX01DMfMH3tQNBBvmYQHxVBB649wO
X-Proofpoint-ORIG-GUID: qbQoW4Yhydz-5_kVNFHtRhIAC9ZInY6F
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIwMDA5MCBTYWx0ZWRfXyI/+jKVqJF7A
 S4rclhtEUztUu/TqKMyfd1Ieg9r5rwTH3/v/GvYskWL6w3aYOfWCnBCLvRatlvakWjO/s9kp0dD
 43o4CjXxdQfNa4AuUJg6wayH00r6HUivFNvcl3m9b/wW41/ObNU1GMupn4XV8CEOFgEH7jz4QR5
 Adww/DgvPfO7oGsIRrpd3r1vbfAm8VQHWlWsMU0bybZ8VZ/wHL25N1KgEAKwdO+ziKIA9t1tDK4
 +GczQcM8JtLqG0AOpFCBdQNd2ECg6cXMfQFVyc7QMOQsCWEaM5wjiFcikGTKLexObQtR1QphpXi
 iOyQi4Bvuag75ujffZR6kS3gpwE7kUOA1trD05TqofMKApmlZ4GJSpFjB/iMJaF12BZIepIyaXr
 kNXkQBF9el6BNtzyGUYw8NEHVqzogqzloypjkxQmjLuUlb7qT2DuxCY521pza4FiN2snvT/zl8f
 J1Matc/nNGjjHsTK0QQ==
X-Proofpoint-GUID: qbQoW4Yhydz-5_kVNFHtRhIAC9ZInY6F

Hi Sasha,

On 20/09/26 6:17 am, Sasha Levin wrote:
> On Fri, Sep 19, 2026 at 02:09:33AM +0530, Harshit Mogalapalli wrote:
>> So bpftool does not build: LIBBPF_OPTS is undefined and the
>> perf_buffer__new_raw() call has too many arguments.
>>
>> Should we revert this and followup patches to this(this is pulled in as
>> a stable-dep-of) or comeup with a downstream fix ?
> 
> Both breaks confirmed on 5.15: there's no LIBBPF_OPTS anywhere under tools/ on
> that branch (only DECLARE_LIBBPF_OPTS in tools/lib/bpf/libbpf_common.h), and
> tools/lib/bpf/libbpf.h still declares the 3-argument perf_buffer__new_raw()
> while map_perf_ring.c calls it with six.
> 

yep, thanks for checking.

Would you be planning to revert the commits ?

Don't see it here: 
https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/log/queue-5.15 
, so reminded.


thanks,
Harshit

