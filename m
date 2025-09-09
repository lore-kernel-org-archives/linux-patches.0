Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D0B33EB0D
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 14:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757427092; cv=fail; b=hvvCjCbRWF0GvB9BASP+IJ+EtImu22Kk9cN+3bHPtusKA6S/kq4kztHlVUxjdzOacXYksSLySE3nWdQ/rgRmUdVSVlXdTwqKTO4EJM66owCDXXbW3Fvmsvz0XLDg6MQFwWgZKgJ6okkSguYOw6IKV35evP+1D5DXudyPTWzc8lc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757427092; c=relaxed/simple;
	bh=7T2Yilr7Z9FnD/JqScyxpljkIABKriDRthmpEOmMlSo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HFlNKegrgj33lGMKsrxW2E+TUvYK4/UsQXr6lXB61lwSd4DZslZv0KkDEPylEsorLebRBO1xiMP80zXYlPSjaEAcUPC4fVY2IJ9OSehXM5GsIN9bY2nmEwDzrHw+Pj8dFodwdWyoTcTKM2ZVz8sGeazB8th3wSDUpo3vVXT5VmA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=V+XsCEls; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nv3fK9aE; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V+XsCEls";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nv3fK9aE"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589CPloS012307;
	Tue, 9 Sep 2025 14:11:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=aoJ/AtzZA8ZeZjsAkyBfmdVhf7wnz2rF9JuhusWdXMw=; b=
	V+XsCElsnWQe27ZOi0XTFk7DFzmn5NXHGnh9YdgaTlBxjzFFP/1cI1am35an0j0f
	ADi4Bm0mlBn3FDKr6Gx5pUEr6Z6Y+QIUr3Oc9eFON4VVYF0FcnChvwjhqe47th1t
	mzuRRF9iAKWUVxJAtF+lww9x6Pe7N2ncjTPcaN6oCe/3fghBS28tdxpCUK31TKdj
	cCZ3KfPgtDG2fi+bpzPKfX/6HiGZEhIElf6VtYEzf/zh5KgPqmG0ZhOOvy6m3zCZ
	XftwjYEIA9xE73OMIoIJSxaPEv5toazuimseNQUb88tGQIvN7qB0o+H3gIsZeNwe
	k0JBqIrGK/Fpou8pN2XpBw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922shswd3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 14:11:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 589DDQMa002957;
	Tue, 9 Sep 2025 14:11:05 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2079.outbound.protection.outlook.com [40.107.96.79])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdg6e8m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 14:11:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QJKyU/bSnXVNwWsLM4H2CxvzQ94Q7TAoDHsz4gQwW/qrchSyOrFWTubQRo2qlvnR7eEk8fdNZyj3mA5HvOI6JAX9NQKeQN3PRGuxH81Y0rpLfq0BqcOlu4vlQ94XrCNUnZFORHtzSp0J7E+BW/t5PsJPNorHd4g9DCD3sUUqM8d3QhQa4dYwKoU5G5rXnQ9CzGgmSIHF1bO6LeksQ2+ps7PXOsWesG6+Rp4aQCp7ZNpzn+GLOiNwreup8oxe+nSW01hJ/bpUDbMlo4YXBDWS6UdeJPSgD9NlvIHKYDDSqt0EYO2bWsKHUWfCI32disNYCsrvEdwhdh3azq5xi4elWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aoJ/AtzZA8ZeZjsAkyBfmdVhf7wnz2rF9JuhusWdXMw=;
 b=GlMyMj27lt9GfJvlueDIiadhsoe1jTXsrOpiZJ5TfdXZN2a7CZzhzGi/p0nQgYnD4fhQyJea9tUDa6Iu6do15mEYMSNX1Uwr3nmd76jV5gdL1GJDkdxvuL4jnQFHXgZQGWkhijsy83l3zwsJO7WfqfORi7l9GsBeejssZP4P3cgJmxWXoNTz4gq8r0/xjOeDxqquHNYGS+5Jh5mT9WoGgqUdBPaGtjnObzbuXwCUxx6rS2LxIIBaBQpLIG0y5J0Jfm77Lm+JDYkfr6Guq5scS71WqmFFK72BzQoWT922CcRHv0pJRYt8Wc5gp+oOB7cxibprgr2M/Tirho27UXnyUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aoJ/AtzZA8ZeZjsAkyBfmdVhf7wnz2rF9JuhusWdXMw=;
 b=nv3fK9aECaM3DVFke2MkTU0vdiN9avu1tORkFdyk0EZzmGOu+h/WBAoE6mYtyvPf7ye4R394iQpEb3ALPvo7SnWWOoq04yU8OQx5N75rF/n20R6pkhhHoPM6xxryyojNra68U15loTfVEQMPpTLyxnBsIcIfk2GBrxHSF/kRSSQ=
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com (2603:10b6:a03:3aa::8)
 by PH7PR10MB6675.namprd10.prod.outlook.com (2603:10b6:510:20d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 14:11:01 +0000
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af]) by SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af%5]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 14:11:01 +0000
Message-ID: <66ec2897-ac66-4f6e-b884-1609391239d1@oracle.com>
Date: Tue, 9 Sep 2025 19:40:49 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/64] 5.15.192-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, achill@achill.org
References: <20250907195603.394640159@linuxfoundation.org>
Content-Language: en-US
From: Vijayendra Suman <vijayendra.suman@oracle.com>
In-Reply-To: <20250907195603.394640159@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0674.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:351::6) To SJ0PR10MB5437.namprd10.prod.outlook.com
 (2603:10b6:a03:3aa::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5437:EE_|PH7PR10MB6675:EE_
X-MS-Office365-Filtering-Correlation-Id: 08280344-376e-4b3e-3317-08ddefaab474
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OWZsR2h2MkxIZlZHYjViWTAzUGtncXB0RUc3SWxmTExQNVNEU3l6V29xVFNT?=
 =?utf-8?B?VkR3aElDc2J2T21RWFBSaGh4ZlFCS2F6ZmdvWTBwSDVqMjFDcXpGUXBsSUdx?=
 =?utf-8?B?VTVzSS9sN2gxWnV5ZUNQZ201TUtWYmpNajFtS2lkV3lLWFZ6K0M4U2I2dGhz?=
 =?utf-8?B?WmVwcENKYmptdWx2WXpCKzBUSm1JMnI0cVJJQ3BXdDliaVRSdlgvVkV6ZGdI?=
 =?utf-8?B?aHd1YUI2QXNJQVFJeGpUb1pnQjV0am5IaXVhd1lQV0tPUzdQcXdFbDV1V3BT?=
 =?utf-8?B?dzdRY0x5UldZaFlLdjZlTFFyR1hFV09BMWx1OHA4Wk80OWtpSnlyMk9ydXAy?=
 =?utf-8?B?K3krYU1ySXZSQW9VOStUMk5jeEJyak1ZWXZjZkRsckdmZ2JGNjNJcjNpeTd6?=
 =?utf-8?B?ZkpldksrdDVjQ0xqVjc3aEp6dkh1VFExajFIcHpzWDdQbksrL0Q3YWpZNGlJ?=
 =?utf-8?B?dEExT2pwMGFyTVY2MmFvcldWa3lkVXVQN1Roc0pRVWdIay9TWEwxUUNPai9V?=
 =?utf-8?B?ZHdSNjBBWHZURXIvb29wb0pYaUlSY1BuR1NkRi81RnMrS0ZNeXRlT1BkZ250?=
 =?utf-8?B?T0t0NmdNc2NoT0daZ1RPMzFKeG9TUitNdzE1VE1xeEMvZFZSVE1namNHbE1B?=
 =?utf-8?B?RnRSR2pBWmhJMEpsc1FqZkJJNkJzN1EwMUJwYnVuY3JnOENtZUFpN3lnTnlN?=
 =?utf-8?B?T3Yrb01weTV2VVpranBybFM5NzlpLytRazlhWlNOTG9JZXJjZUxybldGOUJX?=
 =?utf-8?B?dmZ6WTVKQTV4UFIwS3lETUxyNDQ3RTRhY0Zub1h5eEVkUklsb1RrN0lFNFJq?=
 =?utf-8?B?TnhwaUZOV2VTYzFIWGdkWVA4UVdRM2VuNVdOMTRwT256dUJ6RWR4Y21sUkU1?=
 =?utf-8?B?OG5XcnNxNnJtQUV0UjBzZVJNNkdMeWtrWnE2c085WHFQUUFrTUVqT1B0NVBp?=
 =?utf-8?B?ZFVLNEd3SDlMc2lZVkhXMGNWZGQ2V21kQTB3YjNQWlJYR0d4NkgwZGptSFhD?=
 =?utf-8?B?NVRQeDdIRUltenRlenNOTXRLRldlSk1sbVVKTExBNGVQZVNTR2FIc0lQeVlY?=
 =?utf-8?B?ZU12eTRtdmV5RFdVQys0Rkh2Qm9zQnprd0JPWk9mNmhDZ3U2NFludkdKZlY3?=
 =?utf-8?B?VW1BV0JjZkFML1VtWldwQ2tFMkJsakJtV1FYL0dZcHNwVDc4UXN3NnZ0WFdH?=
 =?utf-8?B?YWd3Yzd6K2Q1czVYanBZeVVWdldCcWJzY1pkWDlRaitiWU03R2R3MEQrU01a?=
 =?utf-8?B?eXpqVFpGVHVBbDY4SmlMS2RsenBrMVJHM1JQaGhRM0xYUXJwd0RxNE5WZ285?=
 =?utf-8?B?L2ovazVteXpVWEdxblMwb1JDTEhLY3NUZmFsbThVVDJhZ0RIUUpFa2VWR0Fa?=
 =?utf-8?B?V1BwYVlvK1JNZnFhZVY1dmovN1B3Q1IzbkpUVk5BVUZYVEEvZk9GTUdVTDJJ?=
 =?utf-8?B?djdENlJCa2RPSTIvczl1dnJFU3Frb29ZQitJbENJTXgzV3kzQW13R1lWcktk?=
 =?utf-8?B?TlBYKzRNZjVIRmRmdmdueG9jbzREVXdrSGFzYlhQTmcwclpzRFJvcmJTSWxP?=
 =?utf-8?B?clhiSE5wUEgrQWxnaXhWZS9ZRGxKNmg5KzdKeTY1ckdYVUdzVTllSmZTQkZj?=
 =?utf-8?B?d3NEQlhTemI4WnViNVAzekkrT2lncElHaytkMzNvcFJzSTAzeW02QmNabHgv?=
 =?utf-8?B?ZlA5SFgxRGFJZ3dkVnVkTlorR0FIRytFb2Y5NFNUWHJFSzV5NGhvY3NFOGJH?=
 =?utf-8?B?WFloN2JwM0lyZzhleXVGQ1pzSUdCcksyeHhLOTZkenRiZzdCYVVZTHAzNWdD?=
 =?utf-8?B?djhuTmhsY2lNc3dBM2tIKzhBTzFFYlpRMTZSSE1sVDQweG1sY3k4QXpGeGVD?=
 =?utf-8?Q?4NS2wHLNbfdzV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5437.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dlVRZmlZMVZjTFZwNlRTai8vVEd5bllzOEc3NmpYNDA4MTFXdVAveHVSTHY0?=
 =?utf-8?B?OGxNeEIwdUtZTGovSUNvUktMa0FkUGszM2JBZ2hUZDJnZTV0eUJUckE2SEVS?=
 =?utf-8?B?aVRFb1laUWMwVWUzQUUyZE5WRGMrNjRyMU5UZk96NWt1QlhwdHViN2VRTmpw?=
 =?utf-8?B?OERMM3ZIR0JXN2U3SXZMNUJCZVRNRkdlYThBNnJiMXNRSjFCR0FVNWFOZjFU?=
 =?utf-8?B?WmpCVHlhR0pqNU1kWVFCR2RNdGdGNUdRL1RXbWdXOVQrT0VDcHVIcEk3UGhJ?=
 =?utf-8?B?Uldsb0RJSmduVmZDd1lzakxGOTcyQm9VWmR3TU1xQjEwcGYvS0dtWXJ4SW43?=
 =?utf-8?B?NXVUTVVja1J3R0JKdDA2UDRpY2tXN0xQZGVydGM0TTR3ZjM1dEEzZEI5aXpa?=
 =?utf-8?B?blFNS0wyQUZrQ3FwKzRLYmJpbHZBVHJFemVRbVloKzRITkdGQ0g2RWVNVmdl?=
 =?utf-8?B?UEQ2S0N1dlE0L2ROa21nOGYzVFZZYUNhZXpBWnV5QzJOZnY2Sy91eTRGMXdk?=
 =?utf-8?B?ek1wdGViYUtucWJUbGJ5NEl4QzVCYW45bDdVL0FuU3J4em9UcmxuMEV5WEFY?=
 =?utf-8?B?b0dYRm5JcmNvMGVERWhSUTE2MXJmR1JTNGxsWmFXeG9tU0VKSGJFUHBvbjNJ?=
 =?utf-8?B?TUZESHZQdGdOZFp5dUNxU0hCVUthK1FOMDhEQTFGYm5HUmVOaGZCdXgvRkpP?=
 =?utf-8?B?bk1XcXdwSzA3M0JyeDNQejgwRGYyeUtFYU1aZmRDUHZwc3N5MFJEQUNhY2Vr?=
 =?utf-8?B?dkRzM2ZpR3ZnVXBmQUE5WmphOTFsRmJuaHFGNGN6eUlDWWQrYnJPcktMNFV2?=
 =?utf-8?B?dmNmdnFrZEJlSjA4bGZHRTFJcVhBL0NsSmVISW9JVjljZFlLZVZhNTdLeWx1?=
 =?utf-8?B?ZXFnYytqRXFPd0JVM1NwMGl4Nzd2NlRGbGlPbXpLeFFCSlB2dUlXQk1RYk41?=
 =?utf-8?B?MitEbW5TNFNLZTVDN1R0NDNObXlrSDZFaGhiQ0prdUNHNzJvTDBpWkxJMjFq?=
 =?utf-8?B?WFRjeUNQY0RsUThHUDlCNE5sNjEwM3JURnpGMVpqWVpFclJISG1RRytBNHQr?=
 =?utf-8?B?RUxWU1VRK3dicDN6SGRHelpCdnFlVGM2MXdtNHRKbW90NDJLekExUlkrWGRp?=
 =?utf-8?B?azg3QUpIdDc4MGdWbFdiOTR5dytiNDVZUSs3L0d0cWtodnhzVWRpRkg3MUcv?=
 =?utf-8?B?d3JWay8xUDRzK0NrdUV5eGZtRUZxbTJtdDhJNnZESllpM3QxWXFJQnNyT1Rl?=
 =?utf-8?B?d3pnRVVFemwwakx3Q1pLdjBsNFB2V3BSMU1SUDd2UDRqeHhGczhQNnNkMmFa?=
 =?utf-8?B?S0FncUovVzVhNlJXSVpZcWZkeXFQNkxXUUNTdVVGZ0lVQWo3czd3N0pmdUw0?=
 =?utf-8?B?NUJPK1hrZXg5TVhkbjJnMDJPOWZSUkI0NjZVSngxeU9wcGRIWWNoT3BqRW8x?=
 =?utf-8?B?QUFxTTd3NC9saE5aUjEyaXFoT25rTGtzTlNXc0wwa2NCaWRxa0RUcEJ1ZlZW?=
 =?utf-8?B?KzU4d293bEgxV3FTUm84Vi9vRlNJeTMwN2dyRlJldWh0dzZ5Slp0cXBmVHBD?=
 =?utf-8?B?ZWFJbW02c3BVS3ZNck45eU5LMDd6dzB1bStIVGU5TzV5TVNWMmIvUzM2TDZD?=
 =?utf-8?B?d1FMRzlHYW1nS2RONnYxalowK3p6c05FeVdoemMzOS82K1hUQ3hRYWFBdWZC?=
 =?utf-8?B?eG00QXc4VG5Ib3ZLdmRodXpqZFRDZW1mMjNJL2w3aW95M05sTzFxQzBoZGVB?=
 =?utf-8?B?L0F0RElpQlBWZWZCZGhreGpROVQ2dFJwbXl1K2FEbXZSTDRlZ25vSk5DSit5?=
 =?utf-8?B?RGNESFEveEdlTlJ1c0NZNE4wU3NCcWUrMU8rdUY0Q3JLcmJLN2RaK2J5Zks4?=
 =?utf-8?B?V2hVbC95c29PSy9GSXhxQktEbGFSbmFIRW9kV1pkSHBhbDNmRlRJZDFXbzZK?=
 =?utf-8?B?UkZSQkdSalZBRGJUVFJhb1BtTzRsaUltaThjNFVyQWtHem1aYm1DNEkyaTdN?=
 =?utf-8?B?OXYrcW9DclR4RStKV2FXWERMUWRQeGxWanBicTVPWnorR2ovSjlqR0E2MkZ6?=
 =?utf-8?B?dWgzVWhPT2NWL2tQMjNpeVBxZ29aUE9IMDlHOFpPanhMSnBpUGpnUURsYWRC?=
 =?utf-8?B?ZVBxQWh6b1E2OU9pOHc2VlBqaXdXY0FWUmpsZGp1dEowTldYQXI1c0pMa01R?=
 =?utf-8?B?TkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2XLuqwwoVIfpM8gC4Gf4yUv2FWIXvIWdxPvHqpemEgbco1iv6PpOa7Hpph54P4GVm1aFEgE01p7SdiQWa0Byo1YA24DFZBoOLy/VxN53boYhPuZesLtN488agq6DFstzQz3mzsgWtMKQCy+8e6qtzZ2GXEXKnGSctnnwEvZhB37HFtGviY9dqHkqK2KrcmSiS1lthZMDStYSzDzxrrTSDT/srndy8YgSqaJOtnPN2bylbh8N4N0OBLavS8wAxgrtrso+8jQZBBDrpKBrjhhyy1JwifG0deZL4J5yXLHGTebx0dN9UWIxSVDRYxXF+yGeVxgbIulpqdqs5miVwqx1dSfRyUpCNlkpNDu/HdxkjAFKTkdlLwQj8ULmDIHYj9tD6EcuBTBLVsdFC+MsFGkTxN/g+dRNXYZ5J2X1Akb/Erg9I2xnnbTdmnuCLj4OEQc8CQYm4iBjMODzrnOOw9QTiqWInrpyYhQ6DPKc8qU+etbK1I50SYYnMNQDlCTTPxMYODhp3xmwoDxpAgFpSsWPhwKU7Ign2v0u7uWcXwznxx6lLsIPKdUE/t/z2O+Egsaoe7/mEz7HwhsmNCdR5sGGX84sljGgqyge1ipnpMAjv+Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08280344-376e-4b3e-3317-08ddefaab474
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5437.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 14:11:01.4432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wJ5BCqZ0btmOhVdJZrjDbwvmyNeCJ6RBu2v6+rwPpg4bx+LOtU3DpZSs8nJFLmqZYs/lI+Ohnn95qbYUsDHCdJwdsxyLJS64wvWZBdEO4T8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6675
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_02,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509090139
X-Authority-Analysis: v=2.4 cv=esTfzppX c=1 sm=1 tr=0 ts=68c03579 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=8-vRK6DNSD7UNujOA5sA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12084
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2NSBTYWx0ZWRfX8NkjTSLPz3Im
 mIeLei6/8IKjgH7S+2nKU5sLiWFgA8ShUZKHwlODrTWn/WnbVrZQ2MT2i7vMsQx/Z1T8eCRKI/O
 Cad4Mc+/qaynu5iKjcFNi76eZSWCno9xzbkUoH2H+X66wGWMfnjpdU/eP7jI8QKbStS6QSxz7QR
 zhKnRsedYeyG7u0G7FKuP0ne9J0vM76fnCRBpPXTbhoq2P+n34iyztXocGu49dFTP2chL4cEsGa
 fDlrMVSYhHdhQVdhevY2t6M+n8RaC/adXF4yKqYw0Hu5JUbg9X21KFp5F5BUJAQ2rgx/kwszFr6
 rqZYvBP91bVN/Bq7XZZq0NqolSz17H8v2/9hhg8xRmxXelWzNV7wbpQuM9RYAvGCqVKjSm9BELZ
 O1LaHsjk2IF3QZLyPsFjhWuwmA9PqQ==
X-Proofpoint-GUID: k1T1pZDrS_r-nqre0PD7OJCw0kZB_y9C
X-Proofpoint-ORIG-GUID: k1T1pZDrS_r-nqre0PD7OJCw0kZB_y9C



On 08/09/25 1:27 am, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.192 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/ 
> patch-5.15.192-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.

No issues were seen on x86_64 and aarch64 platforms with our testing.

Tested-by: Vijayendra Suman <vijayendra.suman@oracle.com>> >
> thanks,
> 
> greg k-h

