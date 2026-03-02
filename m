Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73F831ED7C
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 17:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772473012; cv=fail; b=k3J1+hKrAOunbs54jh9hJm1JdG3d3BEw3+HzgZ4ui9ZK/IcLOx65YywMnP87K2V2t2yZlM3VhW1FVnDB4hs+BNpxzRbivg3akRWcf03SKWsCyU6XW6kBRjIlxHUtwEwsVR4IB2CpngrDJV1gXDdf2lstkxFtyChUqhZm6rkxvN0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772473012; c=relaxed/simple;
	bh=xFQMF1PqUcfitJ2ebCs8LQflAt1l65HV98K9PrBuzWI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cTXG23i16V7klN3oSUN2Bu7GeD0fXgs1x679yelN+lX+3AmCfJReQYPMuSgfhySwj2dA8R37BYmceMfQA2mp4+cnYQPpSwoYhxkWyS+wLblepamlb83syVefWpZlZ3qCJdRAbDJWfqCH05p9yhsoQeuZ8v8g4dyDKywJcRebnls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Aoz3QL17; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=E9kAdp/k; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Aoz3QL17";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="E9kAdp/k"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622HZxo32157170;
	Mon, 2 Mar 2026 17:36:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Qdf5aBrL5Uh+QmHxDnyhSkJNX/q82Kb1PcgGnUXzxVw=; b=
	Aoz3QL17UGEereusARHSMGsjGMKVXwOFyFxPO9BK0QnjXEkMIaPP8ErWCYufM3YY
	5Y1nx7CmO38InxH7GOXdzi9R2x2/EruaLzPacqh0WiHf7Vgekfp3A4BvwJ2Na9yI
	xrDpj/ZJfGFvf+YLwd1hrcxtE91Tz/eXIC9FGgQjSXEUGTiu7EAy2iwHo1xHhwJN
	3rmWptRf/5/PCQKRpHCqrazsIIYWL97mWohKQQka3vXVi912pjz9QG0rsrSF0/IX
	O4DL/QoEBQ/yuxgleht462G0lGnCEI2a7/qjA/wXGLi2pBEslAwrzs9vSBpdHOCL
	Z7JPZQOe4Ul9Kei0K6WwAw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnf3d8022-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 17:36:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622H55Tg027357;
	Mon, 2 Mar 2026 17:36:34 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010066.outbound.protection.outlook.com [52.101.56.66])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt8yp1m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 17:36:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hcOSCJu/Ii1hLkh/GV+eKZ6PA37qR6b14f4bt8nuDdgQ8XPucUFTw1e7GjRW/Ww2ZHxVd29wST/KRcyPdgmjF4mXbNv4O1rKzjE2wdyRoqO+8eCtvhcmIOxF9udep7SBYLNQ4Uf3mIU89T/QOwz3tfnqoPN9QZBoRzfsk928l64ra3s2M3/htRaoPk+SoBZacVReWbbPKGofUV5WJ0r7BnJEQnYjdkUVlxpT2Xw+WYT9AOHN3hW/vekWMDViLLBISTt0v0Ft7BceebZe0QnnZBqyGRA9CrV0ejQKQgxnstb6nx2dVaT1FkrYeKmwhLvR7Cm+nDOnZa24YNc5kf8taw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qdf5aBrL5Uh+QmHxDnyhSkJNX/q82Kb1PcgGnUXzxVw=;
 b=Ak5NtThpP3Oy9blspns6RoRbuMqtV4Y1AfTFIZa6m2u8jlikCXPhN25Ijtw6O/y5VAH4F0k2cKBLiwQ73GQlWxFYGA/FbaUCcZkVo4TyeIIWeaEd92YnG9TsVJ9Kp6jCJ3A+1Us4eA955g5Z7bx8rmjL25tXTNrED/xY0q0JJj7SM7pzvY/EPNBRPQhIKgVxgDk3hkYlyaE0v/cKMk2X3DPohUpaObnAv/NwWN3NM7j9yWSnTyqun3LfPxx9K0LCla+WUyqfqx81ygEYing1J2EOrGi4i9Yju2pJWd2qccSkkJZIEA1SkuFw64hZIBv8ybdZfUxcTT9XTMUDuXjF2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qdf5aBrL5Uh+QmHxDnyhSkJNX/q82Kb1PcgGnUXzxVw=;
 b=E9kAdp/kheFGNm2c7ZmnWseOt9t7owfa3TR84y7w1aEXJzmwDQBtRGywZQWdNdFmytpW+PzXdv3UNmx/bZNPQL61YxPriTpva/vH/za+rrjxllIfhkgB77mbPodaT6iH/SL2v+X9MfjphqeSD2RnacuGxUZWfVlXvVEgoiWwAOk=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SJ0PR10MB5582.namprd10.prod.outlook.com (2603:10b6:a03:3db::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.20; Mon, 2 Mar
 2026 17:36:30 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.20.9654.014; Mon, 2 Mar 2026
 17:36:30 +0000
Message-ID: <7cfc1cde-a8e1-4802-831c-3e082b22fa73@oracle.com>
Date: Mon, 2 Mar 2026 23:06:17 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/533] 6.1.165-rc2 review
To: Peter Schneider <pschneider1968@googlemail.com>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20260302160943.2522184-1-sashal@kernel.org>
 <66461c13-1bb3-473c-b57f-adba9db4f756@googlemail.com>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <66461c13-1bb3-473c-b57f-adba9db4f756@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0193.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::6) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SJ0PR10MB5582:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d4bc71e-779d-43ad-ac62-08de78823d78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	SOUj51Z7ZrIHVmCZf9uE3fqozqb/0SQq5Ol1QkHlnxNYpj36aOoFD3G+7A0yDXNXevcLEtKNUHkiBWyRYsRudOSOkzxhjQ+J1JSF0Fsck9fjTo7AauILhSrn+qd/MiVh88vnEiKxXI4PbxUj1DFjTKXBO1nkhirHYUa17eKkieeJ/Tk4bwUKBlstSH9w9A/FuH/8qcheh+Wxh9FBlE+2JPaMpcm3bSfmSl2yKiWOeGDl9AIpRDw6WzKanIO1ReO8SuXzrQBFcyZQbAQRBgOh3fV0QX1UOn8KUvmFQ8HRwAGd/y/g6NcO7PC5JG6v6luyZ1AzGPMxTRMITGeGaxdJgG0kzGxH0XlmYlBM7Bwgp7zPgy1iiqPpVPjbLVaPrWKocxmarC1tiKmiHuuwpYf9WLZMYWRCrGAmz+R+0praxDYPbfdMQPvB8WhE7dQKx5XqKRRxk1b/EhhA8Ity8c7E1dCKm4LThuBe3MQCnCYAnXRMnpdJdLwxe+7iOMHQvPbrZ0ZarPGILI8rR+uNPH38ggyJLZ/Yjhr2MIh8NLHWJG1glyzO0we4swcS/e0EPY2WVvF5nIQS5NFG47JSiXVYmgWRocMsO5bM+41AW7yXwxRXTosmSk5KMEOdipLYeifucnARvwoz8eBTkLFwBfoiRbDJ62zTTDjMzkJ4l6kby2RXqOu73ziyyRWOgwl7iuPBPzsbsvVE6O8s65RULnpFbP14KWMl82xOkDVqy0JvgtI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eWhodDV3MWlLamlEem5ZVllHemdKN2dKbnN4bUR0eUFXMU1WSU5PaEpEYXg2?=
 =?utf-8?B?b0xlSWorRUtIVjk5TWRtS3d3T3lNKzNaMGpYMWxla1Z1TitFYkc2a0tkeFBS?=
 =?utf-8?B?UXgxWTNsa05jOGZKdG9CVGNZMmdkdlJaNGN5dUk1SWE1bmFBS2dGTXNPZHMx?=
 =?utf-8?B?V0Jzc05iMFhjN1lGMUY0eWV6VHRSTmtORllGb1U2SjdsbTNqZkRMNndHK2FL?=
 =?utf-8?B?YXRjSlBxenNjbVkvcjVGcU5tY0tTQklVT2Q2eEF2QkhKbFMrVkFNMm5WSFYz?=
 =?utf-8?B?R2JKL3VGTDZrY2ZSTGVsSisybDFocUNiZm9qell2UU9IQ2JQTS9jOHkwVXhR?=
 =?utf-8?B?RFQyUXdkWVhMS3BPMWFUMXRCREtqaHhJNE5tdWVLczVad1A5YUZRck5hYXJM?=
 =?utf-8?B?eTkwSXR4cE1idHQ0a0FCWDNqSWNuNC9MeWVjS1NXV25LL3lVNFA2cmt3c2Nk?=
 =?utf-8?B?V3JQSTJkdmJLdEdudzBwRm83YW9xYmo1UHVrNnlBUmI0NnBhM0FNQWMydnRK?=
 =?utf-8?B?TXFrU2FabGtJSlpiVDdvOTJKRmUzeHBRVm1obkdxZUMyY2NKWWduQ3lyZmEw?=
 =?utf-8?B?RGwyN05pWkdpbDNyVWlZVmhoeGRMTmNGbEg5MFhvU1FIdG02bGI1bDJxaEkv?=
 =?utf-8?B?bDN2bVEvZHRycTlGUm1iL21CUGtpQVZNMnVxMmZIbEJVYUFoSTZ2ZW5iRnBY?=
 =?utf-8?B?YmcvQkFOVzNyY291RDllbk5YY3VyWmYvckRGZ0p1a1JZblpjZHZ2T0VDMlI0?=
 =?utf-8?B?a3Q3WXlPSk1uU2wwMFh2TTdBMGoxckN4Yk9hMmhVMEZQbjh6ZUUyN0xLMmN6?=
 =?utf-8?B?bjRSRk42dnZhalNvbzM1TDFqeGx6WmJGTkU5Qmk1TXYxWlV4cFFpempjZWxN?=
 =?utf-8?B?MHU2VlFHTGkyVGR1WnRCU2pZVmRTdy9PQXp4WTI5RitnVE1ETTNkWWs5N0My?=
 =?utf-8?B?YzBoWWI3Rk9aVDFLWVNNN1RtWmxrbG0zZm4vNFp5TC82OUwwMjM0N2E4UC9j?=
 =?utf-8?B?eFdvK3VZK0N5eUUwZUJ0SUpHNXhSNEExNDhVejU1dVZndDE4ZkZUemNCQXZV?=
 =?utf-8?B?NUFUZWhMZWhBMjFGazlyd0tTQm1QaTYxbXRNUUdodGtDdmRmaHhkWEZCNC83?=
 =?utf-8?B?aXU5SFZ0Q0N6VjBSVG9nem5oL24xR2l3QW5vdFVreW4rM3F4RHlqeGhMdFlM?=
 =?utf-8?B?WlJwVVRCVTBVaXR2NUhDb1RKUzFaeE5iVEUyMEt0eGs0Z2RZOWc2a3MrNEtK?=
 =?utf-8?B?UEk3aU1jRituM1hheHN5aTFZK2tIZXRZT2VXUXJGOVpwN2M1dHI1S29VT0J6?=
 =?utf-8?B?aU8yMlhkSFlOaUFKekRJNklGUmUvbVhKN1ova3FpeXl2K2UvWFVybUlYMEdh?=
 =?utf-8?B?TVc0UUlqQW9PT3dLVTRzdFBoV3FRUlBZOExPa3NNaWY0amEyT2ltM2FXeTVO?=
 =?utf-8?B?Zk9HTVM5bjNyWEVtdk1GUEdwc2RRK1c3TTNGaFpBTXRBSWRYRDFvakxpaEhM?=
 =?utf-8?B?T0JNUldybjYrbWx0bzJjdjFQMjZsMkxVcjFPMWRIc2RlMHJNUmNiZ2hmWXda?=
 =?utf-8?B?dnFheXVkdHpWVnZKUjZ2c3J3YlByMVV6aEpqQWpDN3dqMGRVaE9vOVpNR1Zs?=
 =?utf-8?B?b0VNajR3S05UMmsxZ2dkK2daSFJZYWZhYkIwRnhqaE5tbFdMb1FZUUJTMm9Z?=
 =?utf-8?B?eWM2bUdLU2YvWG9mTHBNcUFXaTZKT2RtZjVkaU11bU5JTXdjbzM2ZUJqYmFV?=
 =?utf-8?B?RFVFTGIvTzFVaERDMVNhUDlLcnphRzhpOVVkbHlXMEdYMS9tblVCelRPU21q?=
 =?utf-8?B?K3BtUXB1RW9SdTQvcFV1a1JIZldnK0JTaFJHT1l3cVhrV2dGcW5HNDhSUGN4?=
 =?utf-8?B?TkxqTHcyamRQV0tpS1hoR1BTR09kTmlBM05qR1ExS0xZdXRJdHRHQVh1VzZ5?=
 =?utf-8?B?RkhlRXJ2anE5ZGZmcnJwVUFwUktwWXRaUVVHZ21QcytGZ0I4K1dqNkh5dzVN?=
 =?utf-8?B?OFErTU5NWWZvODhPdWl2VzlqdkFTbjB3YU1ZOFUwdnlzUWhhOGV1SjZndUp3?=
 =?utf-8?B?eDZuTWhKUWMrMHc3aEwvZWtab2JFYk1ENjZkZTMxU0FrSHNpb0wyVFJXa3BX?=
 =?utf-8?B?aG1MY2RCTEgvaU1PbVZSbHV5Y2twRTROK08xUy9DREppNGpteUp0cHpETVBK?=
 =?utf-8?B?YW9hd1pzUHZNRXNKVHNQR1M4eXdOT0wxOExUdVl1ODl1K1pCTG9lek8zOTU2?=
 =?utf-8?B?UnY0ZzdmbGljdUIwazZ6NE5EY29HM2dKckRPdGVSS3A4K1ZuVXc1Mk8wSER1?=
 =?utf-8?B?N3UwL05YTmZZK3VEczNpSFNNWDJFZ0NkbnorVzAyR1BQWEdiNUJ4VmxwY2I0?=
 =?utf-8?Q?VBzfdyop+TFXdn8XbeVzdAxjE1KCp3jAn47TN?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NxKdKtJkeDmcKNc1H/JGmpFPZ9FTWaRQ9MNJ1snTHPqvR6DYMxPw82XafC0xL7ZJaOuOi7tuASSLQzZN1WOXsqchX62crHtROOkg11WxqURIbClRjjQfqDVq9VhyD690xqYuKztpBn4XEMMGhbNvsNPOl6sEMXCXEurkBD6esuvXM9IUxwB71VctuP2uEV6OfDJa8l/JGrhz9OThv3hA8PRJwB2XkKdV3eHrEAiQbEzTGTK0H73wU2eRFCWwrEFLjKdILqneTrhXVWmidDyKsAHC3rQyNliC4wNiYSmNxULcA9JPxmmUpJsYr3c0rWBzpcyNKUu9ViF1JudtvRs0VYxDnHJgnnNc5Lpz2VR2adEh/IsYch/Cp9LulKYZJYOMfZdigmv2kc7gLSXrC46aa44npGC5vOqoBMi1ambU6n4xY06fnv1Pn6SOYu1dN/+0cdkNdCJcFPWWkLEiZB3OfEXhGTX4vfkZI3xzgGBdru7LMhj2mT3AICturCpYjzWWbVXxseoYnYpogACUFhq2y8qPNTdaT/dnquf/+yFLhv12Z9ExNnSFrSjKrKb7CV4kTrA6JiDn48DIoq7C5vCpZjVkz5aqwDH1f33DnVkbIbI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d4bc71e-779d-43ad-ac62-08de78823d78
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 17:36:30.6947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z3ruXI+MFkLzx1MlSDSnOSf9AGnn/5OGqA13BB+tqYU8krfVqA548A8AgC4A2wdWSAqnLHtMHalXET5iKA0TSvvbEwz72lV8BkfXXLpWy/oma5uy2NUrVjfi9B3fz2ZC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5582
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_04,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603020142
X-Proofpoint-ORIG-GUID: BOr5STeUMxlYaPqISuw9WUg8lM-MIA6Z
X-Authority-Analysis: v=2.4 cv=Jor8bc4C c=1 sm=1 tr=0 ts=69a5caa3 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=5xqhaY7dqGk1F4N_NjgA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: BOr5STeUMxlYaPqISuw9WUg8lM-MIA6Z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDE0MiBTYWx0ZWRfX6NI/DCwMMZRW
 4+acFjPL3zy3WjQW+c+q1HQ1a0uBKwY8mdeXvToIDVG28tjQLQ7YNWHHb0YZppwuZdKAi6lxAu/
 te0IfbrrHY9nrvwY0nGViEfORS7M/RAPR/N1kgmO6mnPAxTBA43uCqO0be+iUFy61pAVlFxfZDv
 /geR8IcVFpcCaZyJLZyI9Mdbo+V/5WQUG0ZYiTNxugdwOrwAa3Jl6jSpOz8p0g2FIsK05oJ6NFo
 N6UThrotDX/UImi5JH9pCjXj0udmq60IWQdVNVyjjMtrm9jdvOtOm/jfi3/TgocmvplM2gEPigC
 5rOuCNMtJKWWQKtAnNixh2MjImG0VFboXORZ3si2aVAfOCtrKgUBg1VDnTkP1FBIq7FMwA8e1qj
 zkcDrwztH0AJGJulJNT8gxjmx74J0IxZcAtBjJmtyI7Z4tDyEiaNCUywdrDE87XWe/1EATtIpJR
 cG+4tICnktD6M6qmE4w==

Hi Sasha,

On 02/03/26 22:56, Peter Schneider wrote:
> Am 02.03.2026 um 17:09 schrieb Sasha Levin:
>>
>> This is the start of the stable review cycle for the 6.1.165 release.
>> There are 533 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
> 
> 
> I get a build error in arch/x86/kernel/setup.c:
> 
>    CC      arch/x86/kernel/setup.o
> arch/x86/kernel/setup.c: In function ‘ima_get_kexec_buffer’:
> arch/x86/kernel/setup.c:385:15: error: implicit declaration of function 
> ‘ima_validate_range’ [-Wimplicit-function-declaration]
>    385 |         ret = ima_validate_range(ima_kexec_buffer_phys, 
> ima_kexec_buffer_size);
>        |               ^~~~~~~~~~~~~~~~~~
> make[3]: *** [scripts/Makefile.build:250: arch/x86/kernel/setup.o] Fehler 1
> make[2]: *** [scripts/Makefile.build:503: arch/x86/kernel] Fehler 2
> make[1]: *** [scripts/Makefile.build:503: arch/x86] Fehler 2
> make: *** [Makefile:2025: .] Fehler 2
> root@linus:/usr/src/linux-stable-rc#
> 
> 
> I always do my test builds with CONFIG_WEROR=Y, full .config attached.
> 
> The line causing the error seems to come from
> 
> 73b97ee06bd63 x86/kexec: add a sanity check on previous kernel's ima 
> kexec buffer [ Upstream commit c5489d04337b47e93c0623e8145fcba3f5739efd ]
> 

Interesting: I didn't get an email that this got queued to 6.1.165, 
note: this is not in 6.1.165-rc1, but in 6.1.165-rc2.

I only got: FAILED: Patch "x86/kexec: add a sanity check on previous 
kernel's ima kexec buffer" failed to apply to 6.1-stable tree

In any case: we need a prerequisite for this, so I will work on 
backports in a few days, I think for now, we should drop this commit 
from 6.1.y.

Also I see something unusual -->

6.1.165-rc1 --> 232 patches.

6.1.165-rc2 --> 533 patches.

Can you please check ?


Thanks,
Harshit



> via
> 
> 136114e0abf03005e182d75761ab694648e6d388 "Merge tag 'mm-nonmm- 
> stable-2026-02-12-10-48' of git://git.kernel.org/pub/scm/linux/kernel/ 
> git/akpm/mm"
> Pull non-MM updates from Andrew Morton
> 
> 
> If I revert 73b97ee06bd635433d1c429ecdbc9167da5de588, the build 
> succeeds, and the kernel boots and seems to work fine.
> 
> Beste Grüße,
> Peter Schneider
> 

