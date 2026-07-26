Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74F21B4F0A
	for <patches@lists.linux.dev>; Sun, 26 Jul 2026 15:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785079543; cv=fail; b=oae26jWqRkaYnT4vzmY77WBnjnVvz8rdhWZ1etQaE9U/VCkKYVwo/cyuVWjUs00jQpKOGSM5+gTI5zMwWWM/6YgrOwWS9XoICetdcfwXxatL2/ZFjiqjL2jED3L+Rxb2d5DIxynMhQbLDy+HDCkFaNaufPU9ymFbJpu9490qA+A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785079543; c=relaxed/simple;
	bh=YNPErVKLl1IBOfjbFgZkBa1z00pNFXXIF5+FCAAJWf4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JmOlZkNvgcvBIEACkSSFArg1qrXXPOKSt07CSo6AWYNlVSof0Yoa6mb2l+CoSO8/pjWUwq4lCi8xQORa8a7LzLXMjgF3bY3TjI+Vr0ncIIpozy2pxHfHGK/Hzhn9lCKX/Q8RiFfrOU4fRULLbTTA+9SQ/eOqPGtu7K9mtWdmHhQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lgwbIqXN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wg/k15dk; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lgwbIqXN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wg/k15dk"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66QEJWoO4084528;
	Sun, 26 Jul 2026 15:25:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=OrtPNbsDigXbJDFg2xgLKlMGGcyE71QJkSE9705tYYQ=; b=
	lgwbIqXN2WGipdj1e25AnmAvtP7oSxaZ3Xfikos6xKGACu/gesGh+qVrnhyximBs
	M4Knq39C6aQDeRtDD7LoyiH/VAWYjNLZwo0j+aMhzVVh/YbnO2lQU93PJiBExEgO
	Ig/VT5qwmoz0G10UnwOJqziY6Im1YK6uVUQTjGD9wL18YwAJhdCBpnn1womKhwoQ
	vqdFKiz8UYXnOxz+r6pehdpStwasx4bdrz5S07zM+DosMrkGUCav2KK2mVc0L2M0
	HYbnTzgD0cEcUOEgdSyb931RTUnCaA6d1/OLFQhQ6WUUw2HPMxbpv81DtYryfRI3
	WcLDKIkU7rjo5HTVvvN2Vg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5ngthq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 26 Jul 2026 15:25:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66QFKOSp027064;
	Sun, 26 Jul 2026 15:25:14 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010047.outbound.protection.outlook.com [52.101.56.47])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6ak1y5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 26 Jul 2026 15:25:13 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XPkoBJdjvPTVim6md3wqaXJUseSjp/NIRXrlfffV4ZZ3p4F6gcQRvaSdkmJFELL2IaXO9ammJ8v97XywtQ0Ux1k29sZX+DvUOEKkqk+VG/+tW005KxNIYTlGhFqR8PdhJi0B6coy/q4Cp1wHoQ46Bvyz3pIJPaT+c+tOHZ3TWUh2PLZCtYQb41Vm/lEQaIiPjThgZXfZzaw/ZDKbW6dfTDvjRk4NRrsIKPz6+SzcIyiZNKXoceRyLCxbbBHnIz6Mrulm/CiWfOCIBojy4TcxKfLn0nSN/I3AiahMgNpBGUP8kWKjIF8DDF1FuLs3HbKYGJ8H0ywhOP+hPXhELk4yNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OrtPNbsDigXbJDFg2xgLKlMGGcyE71QJkSE9705tYYQ=;
 b=WD4rbwo9CEGDY6FAOhtfVD4AApUp2TPrmz7EfqmZ6f5ZYN/CBzuSz0ZO4HFrUxusJhhKMMueblewS1MbaxOOua62DfrN+bZIePRKNg99xmhoRb+liqVlIQwzEilvwTcq85ryGuMfpmOdNQSzFj78EL6lDDrtPzY7ZVqnOrKV0PSyn1cM5yhQEJszZsX3Nt56hXvOqsm0JE8TAdKYDMMZ/SfRwp/gRPBAVSjBBwLxTBbbkp5X+TF24fh8aa3cYJNlwC/+crXSehWWEKr23PQ2CdGpjID4rJuKwq3U7cimw3PQzIb6kH/7DFqfLukyyB3hA8IH1N8uaWK64i9CSg5vqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OrtPNbsDigXbJDFg2xgLKlMGGcyE71QJkSE9705tYYQ=;
 b=wg/k15dk6nkZFGT5n3U0/Uju373GwonX6VE/Z6OIxl+n+lF2FOC3j/FL5RpqHWevgXfVyWlTgDyjBfO103G9noY5DX65WyDp56BOqGP3Qng4vUubzrj0vKAHZ3p4OPhgb1dGq7TmZLK0tXobGYC/ALHBvLPNDFVzNxl+GHXg7zg=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by CH2PR10MB4360.namprd10.prod.outlook.com (2603:10b6:610:ac::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Sun, 26 Jul
 2026 15:25:11 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0245.009; Sun, 26 Jul 2026
 15:25:11 +0000
Message-ID: <302daaf1-f83a-41fa-8306-f90769c687cd@oracle.com>
Date: Sun, 26 Jul 2026 20:55:05 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0588/1276] ieee802154: Remove WARN_ON() in
 cfg802154_pernet_exit()
To: Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev, Miquel Raynal <miquel.raynal@bootlin.com>,
        Ivan Abramov <i.abramov@mt-integration.ru>,
        Stefan Schmidt <stefan@datenfreihafen.org>, vegard.nossum@oracle.com
References: <fe4c6d82-b1d8-4421-b581-3ce231798165@oracle.com>
 <20260725192000.stable-0007@kernel.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260725192000.stable-0007@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0415.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d0::12) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|CH2PR10MB4360:EE_
X-MS-Office365-Filtering-Correlation-Id: 85aeaaf7-bc08-427a-19a9-08deeb2a1582
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|10067099003|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ObhUAtMuJ9d/CMC/OzNmpYAXjwgOflO4l9JPewFInHBPhCm/VTn/PgV5xkxDGT7Cd8O6592WmvmVd0DpPGE7zazadATIVT9mkB+A0KTZvGdgFCHaFPeFayQeRKrrucEQp/ivDZmXGjL8jyr7QLAlWQ5QdFG6KjkqbC4FZlWkU/ZUVazWaNRfQrx3/Ngt8DnGOaO8FClNXXigkLFMvvEeubVa3vobM4MVRoAH9oUAGrQy98ba+gREhTOA6nqT5EVl7nkbYoqbEB6d0MjMlW6TipiFZS5Y4V3WsLfXeJDC1COJXpDbOmTMsfVjmu/UYv5C497PeCgVrbWQXkjPcKThnz2/ZGpOYFTndPUqSWk84DfZSRnIyUYJJaPr2w/T4Eu7MtM1w7ZAmfDx9fq2TlXW7QAkr6oHbeCzrvHsI2pfqE1i7EuiP2oYyU2GfJZ4ZElQgYMHKGnkqlRPDP/zNPnomKd6EfnuLQHihutxZY7954heFCpo6H3arEaer9bF7xNWxN+dsldyFdlMLOz+tC9ePUv23aufNA/ebpI/H3rmyB7zrrS4BxA82hGNt6twYZjSlQEydOrq5cOxGPsEb+oIXQGRJYvi7NHgOfrfqd4v4GwrkGZCGYWJmvuR6Sv8sKLtORemVSoiJfmKPCQREIDzJbVHz4JnSPOivqXr6XBorYU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(10067099003)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RlhTN3FtWXVma0tSSUJiS2hhbVNuKzVSTWFhYUJPLzh1R0dHY1E2cS9yVjEy?=
 =?utf-8?B?WUlDNGVYVjFKeGMrTXVOS2NFKzdkSDltWWVxZlpGRklyQ0xSYjhqalIzbjNq?=
 =?utf-8?B?Tnh0LzF1Z0pkZkVuaHFubjhCblQrODVVN1YxVzhmSVRKWkt2Z2lwd29vRXRj?=
 =?utf-8?B?TjRPYmlmMXFDQ041bEtqcmZkMHpXYVViMllZK3VIOTZUdnpNM0w5eE9kdm9v?=
 =?utf-8?B?UU5yTG5yVDdqL2diN0lONm1mQXhGOHRWQThvUGRJNEhHTU1EZElWSDRxRGg4?=
 =?utf-8?B?a1JLOU9VVlV6aTAyRGRHOTNIRVZjY2FveTByQXh4S3M5ZUJxUWFhczBsMXZH?=
 =?utf-8?B?QXV3Y29lN2pWaXk1bis5MG1NejJKc1ZoL0NLM1c1QVgyMmxBcjhzMkpJZUps?=
 =?utf-8?B?RG5zTVhPZHlWZThRM3FmdndGZkNlSHVMdzhSZ0hhTkFSbnpiKzR6Y1BPa1hi?=
 =?utf-8?B?Nkx0YXZoU05iU0RFdlZPVW5YSmNWZC8vMHV2dVl4K2p3QTRwNUZLSURqbktM?=
 =?utf-8?B?ZmdwME44MHZpYVlPSDBubjMrYkkySTlzakZlRXpySmF0Z1RMSnNVNmx0QkYr?=
 =?utf-8?B?WkUvRjJrbEdnU3V2bW5ZVVhKRE41L0k0Y3pzRk5mRW40OWMyL3FkM0p3elVY?=
 =?utf-8?B?RVllemJlYXRtWXpBQWY4aGs2bmw3UGM4UVhxWEpOWjIveHJOanZzdnlNY2ZU?=
 =?utf-8?B?YVVoMkdrNzNybEovLzFMSG1wQVRWQ2pSVlFRNmtwNFFrWjdUdmVDa3BibFFO?=
 =?utf-8?B?OE1FTllWbHhWcytXekVBL3VvcnQ2Mnk1WDRwc0l6WDZhVXVQczBITG5PdlJU?=
 =?utf-8?B?VUt0TkE1REVIQTliZjRGV1JrRjRnUzJmNVVTbXQ0eGJFREhCTnQ1blJmR3lF?=
 =?utf-8?B?d2ttNjNGR3dJU0UwYzZGejNDb0xnL1ZsSzJub0ZLOEo1Tm83ZlV4dVpyWDhv?=
 =?utf-8?B?WVZkMk1rN2lKdkhwMUJwR3RIbzRSdzRrRFZuWHFrcGRLZFpyRDA1Y052SUVR?=
 =?utf-8?B?dGFDRVRHRlc3Ulh1NzdQaERZdGtPNlR4KzUyRzlOaEx0U29FZ0pWbTdlT3Ez?=
 =?utf-8?B?cmxDd0pUUXh3bDBkR2VoQkJQVjhIMjlpbGZJU0R6WE5ndDMrZjZlRlg0bWt5?=
 =?utf-8?B?VTUyZ1dIcEt0cEcreGJFMGQ1ZVk2ams1ZEc5S2ZKRWJuenVDdUpFVlUwS0lW?=
 =?utf-8?B?NHppNUVLRTJ1VkIrM0d3eTQrVHQybW5ZN0tMMVRsSnQ4N2tDYjVmT1RsSDZr?=
 =?utf-8?B?T1MwaEcxcWpScHhGcldkc2V2ckVNVkxRR2EzQWI4bnZSWVZRd2lUVi9leFIv?=
 =?utf-8?B?eVZ2bElDbzl5QVpMcHpJSFo4M21Od2cyQmlIcUJ5N2U2dkdpbnYwb2Z1MHBZ?=
 =?utf-8?B?WUFOc0p1S1lmRGRhTEptd3RFaEE4RnlPbGZ5WHpwQUU4eFNWNGJqR2Z5Vy8x?=
 =?utf-8?B?UFVYNE1hRElkU3JwdExjTUtzY0t4bkM0dEp1OHhDQm5uUDJiM0tZVDNSN1BK?=
 =?utf-8?B?N3ZKTzFVWjJ1c3BKeTFkQ3YzcDN3ZDEzUlJVWWRCRnlJdEVMek9sMlpsV0c3?=
 =?utf-8?B?RTd6Q29TVExqZXVIVEpMME1XL0Z5WTN5NzJoTjFtWVN1U1Vaay9kSFMyR04z?=
 =?utf-8?B?UGhnWklNd2k0V2ZzYkVwclY3ZGFYcHBDV0hnOXNQdHZMd2RicjlYMVRKVWM0?=
 =?utf-8?B?V1BJVW5jOGUzWms2YkozdUVHU1JOcGowbSszeUJ5UHVJTThnVENrRHBIeDd0?=
 =?utf-8?B?VGlzRFlScklwb3ZVSEdCLzE1c01IblkyYUJqdnpjOTlHWlhrL0ZhOGlwYlZQ?=
 =?utf-8?B?blE5aGJveU45emgwNm9CWVZsdU9YY0ljSzk5U21kb2E3RjcwTWM1TFZCMnFB?=
 =?utf-8?B?Y21QRGVzVjdJME5jeVd3bTVUUjRRam5vMDZ0VHZzV1RTdGlwSHBheUo0b2hn?=
 =?utf-8?B?bXBQMDhleEs3Zms3YU8rWU9OVnJQbHdTa1EybEhUVFN2a0FQSVNWMWpPb0tq?=
 =?utf-8?B?Y3NFVVowTk9JaXVMNkloN1NJMmF5UzU0ek9WSnZHWWlKQjhCaWhaQmc3Wk5o?=
 =?utf-8?B?L09rSDRpMG5ybUU2VitWVXhMRERRRUx6dGNjdnd1YWYxSDJ5d0R6cFdldElV?=
 =?utf-8?B?cTNuVVZ1b1VXeG9qZ1l2Qmc2dWNScEQ5Y1prdWFMZXNUdUgrZC9pbllkN29G?=
 =?utf-8?B?YVNxNnVFVWR1MzF6ZkNpV3lRZXNqOC84NkVaLzM4RFA2QlJHTW9weXp3azRx?=
 =?utf-8?B?dkF6N2Z6cHd2WFdCMWZzeERqRTJhTE5wcVFDdytPMmk3U2FzQy9YbWlGaTB1?=
 =?utf-8?B?cm9jY2RjQ1VHc29YTXY2MzdzKzJrVXAwbmdmOSs4cFdrUGg0VWh5bDN4akEv?=
 =?utf-8?Q?BLntulNpcqVeLSi74nIYZk1G/U57/8LTu1LxC?=
X-Exchange-RoutingPolicyChecked:
	kjcP4ATLHf797if+TveuRj5k8HUgIXISJht8N+BW8VTuO05GRr0VxRrlENeRC1ko9yAcLdnB7yQinIKFl3ro4s4nS3/ACCAQ85eadZ1xxqgMMGb+U+A/M4lqtohBiXSxBA59eubGZLrcbMaYFES3/UoRVkiDqscSZASVEnpnE3/Tkw/oGjE80iwAU1EsRcmnQkJogz+M5s/85htjkVFl5c4TN2fiBRgNYLTSh0C4pJYMi8gBWfA8HEa4TfKdfzgPYAjnYEUW2eoAKf2zAdzAdd9X/dC0V5C1iJZqZFshcZxzRFZVtO8UiSTg0sNr649Ie01vo+cDI6wpOIveKiRapw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nTmmGzP2zzWUkyyJB0TZ16L89uxvcyYSngusFNJQWQt6Mb2wvj5yAzGx95xpRGfSNfayTAUPoc4WCmg50YIPHZLEetiK5t7r3y823Vyh3+mnkM/l7tMPYBLgWXs8qGHmmfGMRpuxRZtOy+b/vPv/GZk7/BsSZeGc28g0ahLlSwyjkLAeZDfP14oAoD6UTnjg4rTQupvw1wbewg/RzzowM2PPx5NpTvh3GoBkTxegPl0qvJ1q2JguK8bDDSsI7IuHlD4dsUqlbZhZQmrR31aDZozfm0sQMqHKmK6tt+uh4asPDNdr9SgrySRgyokCKE9bF5/19xtCyCo5IOvhdqxIy0kth82/rj0RAiNV32B/mXIJ/n7O2sINouPkkzFczTiOYPMEOqTGoxo+HVFgQNa2oJGVgodQiVpROA1/YU/TgLy5kNMfVL+Aa3lialFlB5f5PQkmdI/LELT0bZNyIRtOcSQIYBeXnVyqzx3BM6gGtGHEvYHXqnXiLQ6kra8WTg5CYBxSDcBpRBe98yrZduPu6LMHpFciQrpzra6Q5IOh4gcpS9uFWLtXHDG+N3QTrjn0wZFtfQc9XojTAnX4kArSdnmTBC6TBTj+yOMdeJqsgHw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85aeaaf7-bc08-427a-19a9-08deeb2a1582
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 15:25:11.6099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xRFjiqz2T3UmsLTsxUs+MFL8O7Dil0JVmNOaHnx2+cjXJzApWagELuMkDmgtHCBY6bM4jddm+MIBpZwGaUxBOTnZ5eLAULTCeIIjELgAJj1vLz/QhKz7HGTnDZxt7BSH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4360
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-26_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=659 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607260156
X-Authority-Analysis: v=2.4 cv=OPsXGyaB c=1 sm=1 tr=0 ts=6a6626da b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=TpsN-QUPK_trVusq7MkA:9
 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:13523
X-Proofpoint-ORIG-GUID: PXAmCXiGhuTaSVm5Un7PlxLvkYKMByLn
X-Proofpoint-GUID: PXAmCXiGhuTaSVm5Un7PlxLvkYKMByLn
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI2MDE1NiBTYWx0ZWRfX+FwIYTM90Lq2
 93y9HsUY+9XNd+B1FWzlEAM0VFjoShvZS/D26rGmPRE449k1tx/nFQTfXB4ZHNs088NCb1+0pc7
 keNpHZ2aG/ZZEwcMz+Q35NYRo8mH44Cpf+1xudm5zXeBn2iz9V73
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI2MDE1NiBTYWx0ZWRfX/xfzIyfgDuq/
 53/2zCsN884gtAQtrqu0ZVbcy1nTLFBIA2ERgrzJ/M8aTzRI9jBN/Mpt0UQu/Dd21rBgXYPEU3/
 AIcGG40/fYqZYp6uCjvV0j3x3yMM9B5cZKfKhKw41uylBkgBWhm99wADatPhqy+3jx6fb/zNl+h
 DE0l8Q08pICEj+0Cx5rX6vM/LbuyjRsJybJelvaLV35mDhrqv3yDLWu9F9yXdnzNLD5lFWf18p3
 Z7ff/VCrXgEuoF4oHg3H+ZZiIzK+Ko6UJUlGx6Is25tt+XMk8x7PBcKaT90WI0eQeovT1yDvX43
 qo36OveExVu42bbgF7FTxbfkmdTIKa4ToHf7amU7c1+o0gtDjpOMFmF7ACkwhfnw+CDhDBkUqRc
 3SwEnSP067FVOHYBKBmiponCsFhQ5mWFMjcQLYqLQvnBQPSy6zT//HFZwa0UdzKc21L76BjAF76
 FtwQwMrPclDx+PJu6ixlIx5oAjnSSLeXWn2bTghw=

Hi Sasha,

On 26/07/26 5:34 pm, Sasha Levin wrote:
>> So I think we should drop this patch for now until 0569f67ed6a7
>> ("ieee802154: Avoid calling WARN_ON() on -ENOMEM in
>> cfg802154_switch_netns()") is backported. Thats not a clean cherry-pick
>> and needs adaption which I think we could do later ?
> 
> You're right about the missing coverage, but I'd rather keep the patch
> as-is. The prerequisite 0569f67ed6a7 doesn't backport cleanly here (it
> needs the netns_local -> netns_immutable rename chain and the
> goto-errout restructure, none of which are on 6.12 and older), 

Right, exactly that makes in not a clean backport.

> and the
> only downside of removing the caller WARN_ON() without it is that a
> non--ENOMEM failure on the initial dev_change_net_namespace() break path
> becomes silent. That's a lost warning on a rare error path, not a crash,
> so I'll leave the queued patch in rather than churn the chain. 

So are we considering backporting the prereq in future releases ?

Asking this because panic_on_warn() is set in few systems probably.

Thanks,
harshit

> Thanks
> for the careful review.
> 

