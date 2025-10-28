Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C509F33DEE6
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 15:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761666159; cv=fail; b=NEb/OPGzdinlLqkHCS4zZzyo2hmoJhvO6v55u+xBdeSvEzCpOc6G9ocoev78UqKFCfV3xY3M8QM5rd90nTf2oplCWKShlmz+y4CCiF7gaeegm438yys23+RoG94cqKkmAc0uKj2pBTQo0I9N4kPY1TlLzYtI0rK0FItj1b9CC2M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761666159; c=relaxed/simple;
	bh=Oi9bEqCA5qTPDcIzaR0Fn3QOnTcIr5DklQzU/xBRJmg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jYMT/Rhl3USNiRqOD3ihtNhskrMbgtMOI8syB8lHr9JKEAWhD2LzG4kLAPi+W75EmSYmbB2KPW3vhi9f6kJLdThKCSGYv6KgNwanQC2QH3Dn/wpiZBFKipRVC2QlT3nIURCnjCMq7lGVYjfzWmmmnpdZjH15Ehv2Su1nnZjifmA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HHqmUaKK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SB1GCj3S; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HHqmUaKK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SB1GCj3S"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59SBDd3a022414;
	Tue, 28 Oct 2025 15:42:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=d9yiDET+VXNlM1N4OaNYxlEilj2v1dZCWaOZ4cKZ88I=; b=
	HHqmUaKKMY9O7Cxzw2jVncddz4jja3PYn5Vaakz0cGSLE2VO36KMnzFYydNMrDc9
	mp9wCEJKee6xD9yxPxd+UIutSZkTKCLjZzY7siwsK/hymU3e5tiSn2CIyHRH5MV8
	Dyi6Y9H7FD1bHHEk43mLlJMt7H4rHd0zApQaWSKuuJOVX9j2gt+7KIp5At6W0C7h
	q4fTzhmTMEe7QBl+GjGebJTOooa9FSsw1I6ZCoqbSXudTRdj19XrBgtEoWzwVYrS
	20iL1ONAMxy/VOtCQfeXKGDR2G0IzAN1K0IXbcXX9i2acA3ChiA561tJ5RFzIecp
	A0xz8/TMY7DRgRJS4suZyA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a232uuygx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 15:42:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59SEgBlB009139;
	Tue, 28 Oct 2025 15:42:17 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011029.outbound.protection.outlook.com [40.93.194.29])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a0n0fm7ha-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 15:42:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y+mBLwCfadr44aIuNSFT9rraH8kZbvqV9WFxxHB2Noldd2hqZGMoPE3R9Ko6OQIVVnnIt7VIEwzPC7YDwgqlZJzZq0q6cnQVTUYvg7d+YonxGZXJ0hhXLTV2+lHQMyfkn/OxdkqYXq2++TtAA+UNklyVWLOegsS/0QMxIJE+LrxdoaV6z99A71SySvzAHCKRYqDM8W6+YTtgalfyfMINjgn0fjLCI3OeEB2ExFb1+mFhNTXGcDzEZs7o5fmze6EC7nZDSbf8+vH/ksQDtKM/i5EtWq9YT/h69JXYzAPRlhMZZXje5+ebmwWp/MBhgGrzTjDk1HwatbA7W/bmxBgHyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d9yiDET+VXNlM1N4OaNYxlEilj2v1dZCWaOZ4cKZ88I=;
 b=J1vS8uR+YuLYkymbQggK9YpuAFStidjXDpUdIqbrSK1s53tg7y3S7skRVE0evIxPxuW1kHYQRK2Klukq/l6kcThM46kfqxFtIxTxbJZ1Pr+8bIdiohH9ulxf6N3uqUPNXOQRevlMNoBAPwXefRlO3Mbw515e66yje16mWTHum6oK4jU6Ayz+BUorRtxyLjbCASPNbQBDHtKCHhIjF5TQPfvZocGnm/K8eQC8tbbdeHBw/d8OgbjAJh9z/cVgAJCDJlBrW66f20gbSr6XxnrqTXJUprt7Wfn9NoDs9umjHrc0K9ccFgEeIV2qwjWkhnAz3saoebJ4hcDvbKQ8o4DQsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d9yiDET+VXNlM1N4OaNYxlEilj2v1dZCWaOZ4cKZ88I=;
 b=SB1GCj3STlopBkUgIEW0ULQPtYL7xdjj5A2jmzXzDtp9kFnq7TvOjAgFl+JlVoDzCLYdNLns1Qco2/O0xEYHzNT+7OIyE8pkHJ+yrXXlZY3krDqTFXwXTZn0zQLJN+8C2fqdg5QUV/Ye73cAbTeUOxPPHxCrej/iqxDWzQOoRMA=
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com (2603:10b6:a03:3aa::8)
 by PH0PR10MB4631.namprd10.prod.outlook.com (2603:10b6:510:41::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Tue, 28 Oct
 2025 15:42:14 +0000
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af]) by SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af%5]) with mapi id 15.20.9275.011; Tue, 28 Oct 2025
 15:42:14 +0000
Message-ID: <86abc1a6-6bed-460c-80fd-a74570c98ac8@oracle.com>
Date: Tue, 28 Oct 2025 21:11:58 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/123] 5.15.196-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20251027183446.381986645@linuxfoundation.org>
Content-Language: en-US
From: Vijayendra Suman <vijayendra.suman@oracle.com>
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0257.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::10) To SJ0PR10MB5437.namprd10.prod.outlook.com
 (2603:10b6:a03:3aa::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5437:EE_|PH0PR10MB4631:EE_
X-MS-Office365-Filtering-Correlation-Id: 97586cc1-7fba-4158-470e-08de16389139
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R21kdTVVcDloWm5lRWJOelk4bmVHUkRVakJ4MHcvR0Y0MWtLQU1jdSthdldx?=
 =?utf-8?B?ZmFxY085NmhCYkxDRHdYN2t5Ni96MU9Yd1U2MDJ2ODRnWGp5YUhNSWtDUi8y?=
 =?utf-8?B?dGJkci9BZ1FHTFBBTW1qaVVCRG5sLzM1NW83clJEdm51ZUtLdUtZMjdWVXJk?=
 =?utf-8?B?bTlRVXN0aFFHNS9IaUxjZDNmVnRLTnEzSlBCRE5hUDRtaWk4VzJkL281NVox?=
 =?utf-8?B?WkRXbUZGcnlvMVFta1dHT3VyWFdpdkllN2s2SzI1QjJxR3NoS1BCd0c5RElX?=
 =?utf-8?B?VVBoeTNqTUVKY2pJenFYMis5SllSbVpqaEUvci9lMHQwbDhPUkxSOGFqTGU3?=
 =?utf-8?B?WFZPNkZaN3JwZi9Ya1V3SzdzbElHbXVEZUZsNXhRUCtXUjN5RGdEMG1KUTUz?=
 =?utf-8?B?eFkxclN0c1B0dDBqZElqcHcyaWhLcHJ3QXJ1b3FySjc0amp3SlZpSXZqT2NS?=
 =?utf-8?B?TjJuUVQ1Nm54UlRNaWZiaGJkVXZ2V0pCYmc1VDF1VkR5OXhzdWRjQ1k3S20w?=
 =?utf-8?B?UzZtOWFrN1dhSTJ3Z0xWT0Jjb1Axa01BUlhmSTdwMDAyZUdQMmhlU0M5YkNu?=
 =?utf-8?B?WWJtNUh0RDJNMXlJaVdHSnhxcU4vNmFMZ3NpelNocmNNcTBEa0RVR1V3cTJW?=
 =?utf-8?B?ZnVKUlZxTTJZcGRBN0pBaTlaazdiZmMzemVZczdtbU02bWhTcXAwa3U0eXE4?=
 =?utf-8?B?Tmp4UGFCQlVDSy9leGFxZzZNRDhodHpZMkEvYUVJZmt6b21kdENHMVo2ejhk?=
 =?utf-8?B?bXhBd0FUNFQ0djhzNVd2VEJpTm03Y1FITzRIQjRLNWFHNmpCZ1JKZUlpV0Nj?=
 =?utf-8?B?b3BjM3hpZ2J5dTdkQmQydGczNlR6UHpnN1ZMM0czUDhxcWdYNlVSUFlOTDRT?=
 =?utf-8?B?b0FhaVpwNWN2aFhibmJpcnlJaWtWbVpqYXQyOTFFTkxiZzBLNVJYYkFMSWVh?=
 =?utf-8?B?KzdEREtmM2JqUlJrYWQ0ckJFK0ppRS92eUhaUHJEVE5KWUplWmg1NWltdkRa?=
 =?utf-8?B?NnFmNmlFZ3B1OVIrTkhqNjY0TzBJekw3bE1zcGNLM1NtWVUrZkhDckZ5cVB2?=
 =?utf-8?B?WUdwMzVScFFaQmUwdEJZR3hjdHRJUlFKcmdqYWdkM252cUZLci9DcGVNQ1p1?=
 =?utf-8?B?UWxON0lPNGNMbFlaU242MUxONnJSaXl0UGkvZDlxY3dTNmxBZmc5MTUrLzdR?=
 =?utf-8?B?ZHE3MGp3SVV3VUl3U05BaWJNRXBRNGV1QVo0Q21lcklxL1dXNm1TaFkzSmQ2?=
 =?utf-8?B?SXFMaUJ6QVlBb0kwVW5XRVdldy9hTFdQMklhRnM3TEdWM01Ed2tsN1pxU3B3?=
 =?utf-8?B?REFsSDByeEdIdVIxMVpsQ2xURGt4THZMendwdEpEVFZOa3lkc0IzWXJFV1o2?=
 =?utf-8?B?akxuRjlXV3llOW1ueGJ3VmRvYTRSUCt0dVM0clNteWF5N2p4ZkZ1ZlhZT0h4?=
 =?utf-8?B?blU1cFphaHBhOHZ1ai95ZWNMRjd2b3pvSDIrSGh0d2FBcEp3eXhNdzJucnpU?=
 =?utf-8?B?SXVINzJWcUFYemFCS0lOYXBibGUyMjhxOFR4SEZKaTV3VDV6MTN4ZytDUGhO?=
 =?utf-8?B?NmdmTzBhd1c1U0hMUE9oSFVXak84R3BiYW56cHhiNWxmNmJkRlNGb29YdVVK?=
 =?utf-8?B?Um11VUdCem5TcjVxSS81L3NvbUZvTENFb25IYmFnOFJkKy96WkZGcHFKU2ZU?=
 =?utf-8?B?U2t2cFVxc01qYXlValFucG4ySTEvRjJiQW02a0JnRmdMRG5YNXZrL21ya2NM?=
 =?utf-8?B?UndGRlJDa0M4Z3EyUGhLa1dVRzkxaDVHQlJaa0lQQzNxamo1WVdxeTNvK1lJ?=
 =?utf-8?B?UTl1ZEdrM0hidGZ5ZVByOG1zUzFKR0t6MjgyeWI3eWVaWFJZaEVlVmdXc3Zu?=
 =?utf-8?B?Mm1rQWRnYlQ2aXI5eUU4UlNhSFMyVWRQdkd3S0tndStIQmMzWE1XUjU4d3ZB?=
 =?utf-8?B?bGdjeHZ4UFJwbmRKVWM1UXdsZUxuK0gvd2pTTmM3QlJTZnBFcHBzOEJ3M1Z0?=
 =?utf-8?B?WlZVWjg2ZTVnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5437.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OXdjMVpFQTkrS3R1UkhFRWl1M3FScW43c0t3K0JrUVUzU1FkT0JtL3dWa0Zi?=
 =?utf-8?B?M2JnRWo0SG5HSWZKSWJRaDhvcGovbmJ4aFZSeFVkaFI2SGdSQi8rM09HOFNN?=
 =?utf-8?B?dEE2Z0NBRnpIK2xoeG1veWlOemxpcFUvZ3dlTW9XZ2FDNVUrbTF6a1BnSXBC?=
 =?utf-8?B?Tk1QancwWGVBc0VrZTB3UVhmR3lVR0dWcWdvcG1rVXBrUXlVcjNqYUdmbnZI?=
 =?utf-8?B?M3l2c3B0eHJTSHJJeGFyMXRsK1JiOEFIK0l1VWN3dVYvaGIyQ29XSThjM09s?=
 =?utf-8?B?cGRqK2xZVHUwaEZiV1A2VE1sa2RoeFdJYnpWRUo3QmI3QWF5WUpGdWVsYkZi?=
 =?utf-8?B?NkRrVDJuYWFZZXBYOWVmbDlrS0hQOXBiTkVyTFJlMkJLbk1yZ3RhY3UzNUdv?=
 =?utf-8?B?ZE5yNVU0OWVKQlNGRUUwMm5WYXZzS3pydmxuMlpnaERmK3RMaDFHWFdwNjZ3?=
 =?utf-8?B?TkwrdlRNdktzOG55QllqZnUzYTZaM05FcDV3eVJjQkdxaTBsaHBZclhSQndu?=
 =?utf-8?B?U0gyMGcrc01kblJLU0hiREhKNHlqTDAySjVNY2NwZ0FXaGNEck5HWUF1Nmdk?=
 =?utf-8?B?NWE1ZmFrZWdZZzRWeW9rVmtuU1N5NnhiT0JBZ0NwVzBOeWFDSHB1eS9WUkMw?=
 =?utf-8?B?UlNDYXhOWUZFVkp3WDNvNThCWGg5Snp3NVhGVVhWRENBMFZ5eGQ0SnoxQmV4?=
 =?utf-8?B?VzNxbWN0RFh1OGo1Q0JaYXlFRTBGdU02c3VqaUlSaTVqMWg4WXA2L3VQVGxs?=
 =?utf-8?B?UDBjcnhhNi9naSt2QkZ6QldJMzVxT1lWT3NqY3YvRXRScm0yZ3lNWGQ2S0dO?=
 =?utf-8?B?ejN6bjlTR3FWTGZCWlJMdjZ4YkcrOSs1V3lseWhXWUN0NWNrRXFRZXdQRmM2?=
 =?utf-8?B?aWZhVWd5SjdKYlFXOVJDUlhNQVZGdS9ScnNZZGI5RzhQc3pvaWtYSXZsYkEz?=
 =?utf-8?B?Z0U2UkhEOXJrdEphQUNwZXlKMmV2d1gwWjNBcXBYS00wT0J1U0txR1lSanV0?=
 =?utf-8?B?SEdiTm1hOE80L3dwamN2SDFXaDcza3krc2JwbW9HcWxpaWdoWUx0Z1N2Mk9r?=
 =?utf-8?B?Q1FlNml4TmJBN04rNGVFaXFVcE00Mnl2QXJRc3hZcVlHZEtrd25zUlhSNC9L?=
 =?utf-8?B?UVRLeVhlUkd2OVNIWUJRdlNLbDVmYTkremd4SFNqRTBMVUM3TVhSSWhMY1N1?=
 =?utf-8?B?NE91UGtZYnF1QitWVkU1UkR0OWdOVVhGVUJxRG10TS9INis5ME9udy93cFpB?=
 =?utf-8?B?TWlKa0hjWThvd1RVRkx5bmxZK2VDSXoyS0RmY0lsZzliblZiS0ZTWjAxT0Zz?=
 =?utf-8?B?RTByZkV1dmh4NXY5czF6c0lGb1BIN2V6RFZrenQ5VitmcEErd1Q1cDRGM3dx?=
 =?utf-8?B?NTdqaHBURjBsSkt0MEtTSUk3ZjZWU0FReGJHQ0hOMDh0UDJYVnAyN0h0dTFE?=
 =?utf-8?B?T21BSWpyQzRyQ1hkTGtKQ0JUNXlNRytXSWFnUmRCK3AwNytpSTV2ODhtWSs0?=
 =?utf-8?B?eWdKWlVjTUZFbDFvcTZoV1JHQkdmZXZ6dkw0T00yUjdHT0tYV0J3M1NFditT?=
 =?utf-8?B?REs4MjZZZWNIbTFLbTZqMzdTZFVDNzBqNndEOHB0WWh4aFAvVC9FV0pYUnpo?=
 =?utf-8?B?UDRtMjhrZVpHTFhqS21NczI2c0pLUzNIeitudzZ2Sk9QNk9XbkViSGEzMmsz?=
 =?utf-8?B?TXNTK1BEWWl3RWYwUS9mZU50TnNaMjZMdDlJNFJWcDBGWkx5ZnFodVpQbisw?=
 =?utf-8?B?SW1lcG5xRmdUdmRXYUtXQ3U2c1cwODl2ZWswc0tCaEtwRWxmQjgyUHJVNjVS?=
 =?utf-8?B?T0M1K1RBMlNzYzFtSnh5MUgvUEFTZ0p6N2NHaC8wZEJWeTdTU25PUlgybzVB?=
 =?utf-8?B?czdYRWNUQXc4aEt6SXI2KytrbHJZTmM4bk0zaGtvZ2hOWUNWaFJFT1gycjYx?=
 =?utf-8?B?ZG9VL1ZJa3hxb2RCMDhKRTFzVWYzR0tyM3JzUm5CaHhCMnRndzlnbEY5R05K?=
 =?utf-8?B?K3IrWG51dHZ1bzVuWTVWeDN4NHFxMjlxckpwL0FrcVQ3ZDNkUlF3WFZHRjA5?=
 =?utf-8?B?MlBvelNUSnQ3cUpaUW13d045WlpaV0tES0MvUzJaeGRsZkhHTVNsZmhTakNj?=
 =?utf-8?B?VzBPZjVZbVZBM1VhRjVDaEJNRk9JVVRZSk53ckRBWVZmSERKckdQOWV1ajNB?=
 =?utf-8?B?Nnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WNEwzwMEyCoFU/5UW4iHpFBUnsvLnfKnL8kiZ0YsH7AjMe+xq1an2rjKGGUcwdhMugpSq4PqmN1AEelAaFCQiq5Byor7ADPsLFCVJm/xkN2tusFDvjgef8LFSQVZs0ou4k+mKpZb0kw3dxUJ1LcuTqitKF64ZO5MVECROCsTwtTfMfAJrfsDN6URu510ndQK9EpEJ9xRNaMAIbkacdFB/8AowgCxu99SBnbE1yhCPKfjiolq8gFL2T20ZQKfbEn85sw5C6c9292mGU6zegJxfmWiPkRJVXPdurOdWCMGQ7bH5KgSBxdYVDluoDaa2/tLzcCc/ycee8M8kBJNASxOUrEEw33clZlUD7OEThU1WUPhYrSppwRJLVr2LTW2DVriLtxKEKWoHDN+HRnf9FcNZpyUo8/3Lq3XVGoKwVXisliLzIhXS3KQQB6tzt7h9mkGjwFkbNSeVWIz8wYruGQOBYKaKbu1suRb+HuzGy9ua5bA6Ydy5dbPecI9SDv6f4brgXMJ5UG/rCR8gz3ZFtAJfdnHfVWz8F+dS1NAA8LoWYQSbrOss6vxjPMMizxCclcoXtvEBaT2KY8DgU5t6t4JYxkwa6HCK8zJU/8guSVCE00=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97586cc1-7fba-4158-470e-08de16389139
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5437.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 15:42:14.6863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mGkdmPMSs+NRwdXpru/EMLMpv/xlZiMfCfY36ntt9IsLtR4TSX+PPNvQCMG94vDw21C6TjnsDGBFn3+bEp+1zkqerLFFopDQhs+iONkrLtU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4631
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_05,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=959
 adultscore=0 phishscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510280131
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDA1MiBTYWx0ZWRfX21YpuRBo6Mpo
 K3M8k3hh6DzlEZ1eOfq58AqAj9mWTdK7BrfSpOATQuh9fO8jjNH/gb+qGU2G019G8m96piJWvES
 UQel1UUUS0805Ee75dziymxKKnWotDUqI//4hzcu/mEMZrmOO+o8b3Lh827LXkdtV6t/7ntN10z
 xQCH3Nsg/hboXgQmrwMSERS+EZs29Xs82pCV6Nj+7QZjDgQ5G0+sXgEDNTUW7GDD1cFLf2EDyR1
 x5cfyNQWXTJ9C12xBLs2tjwYn3EMEXkAtwHHuUK0MFbFaZNs5qjnh7V9kAIVkEF45dYMZkLdpZn
 fOa9+/pIJ9R4fEFeeT27KC6hEYp4/6O84bl2ktKY4QNnhyBHEEsytZDbJIsC2lZ2AjulFLlqOM9
 t6DgEd2jdNVkd1BAhGt0UrRUNPy7MGmgCOOvTaUu+iiPBtG/D1A=
X-Proofpoint-GUID: bKoVM5AKsI0_BM8b6u5pfODQXEsUsysi
X-Proofpoint-ORIG-GUID: bKoVM5AKsI0_BM8b6u5pfODQXEsUsysi
X-Authority-Analysis: v=2.4 cv=abVsXBot c=1 sm=1 tr=0 ts=6900e45b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=_-oXDqdGEXAFBEsyR_cA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12123



On 28/10/25 12:04 am, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.196 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/ 
> patch-5.15.196-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf failed to compile with following errors at compilation.

BUILDSTDERR: tests/perf-record.c: In function 'test__PERF_RECORD':
BUILDSTDERR: tests/perf-record.c:118:17: error: implicit declaration of 
function 'evlist__cancel_workload'; did you mean 
'evlist__start_workload'? [-Werror=implicit-function-declaration]
BUILDSTDERR:   118 |                 evlist__cancel_workload(evlist);
BUILDSTDERR:       |                 ^~~~~~~~~~~~~~~~~~~~~~~
BUILDSTDERR:       |                 evlist__start_workload


There is no definition for evlist__cancel_workload

Following are references of 'evlist__cancel_workload'
tools/perf/tests/perf-record.c:118:	evlist__cancel_workload(evlist);
tools/perf/tests/perf-record.c:130:	evlist__cancel_workload(evlist);
tools/perf/tests/perf-record.c:142:	evlist__cancel_workload(evlist);
tools/perf/tests/perf-record.c:155:	evlist__cancel_workload(evlist);


Commit which need to be reverted.
b7e5c59f3b09 perf test: Don't leak workload gopipe in PERF_RECORD_*

thanks
Vijay
