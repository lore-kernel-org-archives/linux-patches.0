Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCC019995E;
	Sun, 19 Jul 2026 19:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784488701; cv=fail; b=YOIhDA7pBwJ9M3hql7K5Z3S7/gPlx4jXlkYugCuL3TpvrviXK34/U3hKov6eAlbTzpgOWPe0CqBvaPMKNNbiXP4i6yCIsJ6Ph4dW8gvQXrT5ScFkgBvSrZqFqmxEaPzGIbbeJ0V1UERyIaqgJtZgyqGDXIXUNIICJkHT8v52gzg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784488701; c=relaxed/simple;
	bh=Xhv4q7X+Bq8PhMG8V1u3zSfO8dUSjru1aM6etaoIQEI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ON2h1YyodwTpxX1Ob44FHvcJHCzGGN/1HUVAEJT6PS69ZkMvWUp/IS3yX1yCaT/czr6hImHUfEQv2D+hkFeFCBMrmTloWJevLC0jv1F2PN54SBnkqbiLN+0dBcFvR7pui3WLeCcAVZKtv825/N7vKtlIoPvoDrf8D7ZFutxIujI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XkxSJVir; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GP9uz1Az; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XkxSJVir";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GP9uz1Az"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66JIKuJQ4181424;
	Sun, 19 Jul 2026 19:18:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=PkRm2sWAupV0t1nAtY+t6WwH2UwDhDOLHF5ZQWULFRs=; b=
	XkxSJViryn/u4by1mVnTjncE41SpEg6Ls+ZdXvtwS+R02HbO8Ndia4knxUjiyzwN
	AOTC9lLSiGqdKcVVZnD+RSKvN6p0rS5eENZTzAxJQFn6Ba4FjW7I/ITVTNrW5ZMX
	0FxU2OCxUeWlWFOT+aKg+QG45pkZXtGfq7x2s5yiQgxy44thoo7T2Xc3EemXYJRs
	qLsnWRjVuJXr1nWo7Hno2glaDZ0F45Dk+nZD5DXN2KO09UfzegvirYot8FabrXRq
	x4ShmkDl13qhqMzzNXrQ6kfDvbAsglvNZz5nWTmVUfh7EqyryQjJu3zj7m1uNwtE
	czenxquD3U6z87oxAaQrOw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1mv10bt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 19 Jul 2026 19:18:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66JJI8Sg015502;
	Sun, 19 Jul 2026 19:18:10 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011036.outbound.protection.outlook.com [40.93.194.36])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fgtrvyeba-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 19 Jul 2026 19:18:10 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TBd0UxYnearynOk4ugQZk+dpEf1ZIyPnzwR2aZro8AG3ud778lbvdXDdSPl09gXWK4TgfDuEAjPCodXbXil5Y96BFh33HtlEkNJqg7ixqxwZRph8xRJA4vR9XZ9p3ILmUbLpAkv8EPza3hIEElH6pBz7kCBkbtFtJW/Jjqm9siV3IIWl49ZD8a7sIKG4wrUjlX64aModTFMdK3TBerZCBiGus9yYFbJakoS+jNuNV3AkcslXavgLEC1vwtrouNVnkI/0lHBAfNJrCi+slRTI1HS7cJPmFlvBdJzCYUyU+0vMJptqEykljsJqLW3LnsnlbT8ZLHtHj2PQ07beRJ+qAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PkRm2sWAupV0t1nAtY+t6WwH2UwDhDOLHF5ZQWULFRs=;
 b=es9Fpw7+gCgaRq0ETf02xtpMFolv0W7gKlOUpkSpCLAOF1ZXlq9nPb68xPhI+CcLXWz7yS5/u4GfSPdcE5VD+CnEwhmD81njm7APpkCzqXp4DxZO7GLblQs06QgyMd+f6xGdMEOWLYntA7wVLtaUvjzoZ+hZNDS3l3/2+oOl2O1g09gyKsGUd7ZuWAPa/QOdA7K4LqHVPa2hkDqI7Qekp5UTsVo0r4hebHpkuxMHs2PtPRL1HuqygcCK/fFGIuzxkaPFe4NqFsdJ4OvVy7TU0Fyi+BrPAXUXlW4AsglNr1qVnGGW/ycR8EfTeYUVhfkoLm9z6RoOo2bVjzRwbckGKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PkRm2sWAupV0t1nAtY+t6WwH2UwDhDOLHF5ZQWULFRs=;
 b=GP9uz1AzWRaHktO5qB+8rWYuU/kMxILmVrShJBgTkBDlWqXrIyS2QYv+cOum3QgRtgrQDYDI+koF1eugeiWtJ8CO49+BpHXwBywUCoVIXnnFsNP5mQxzeiL59rvnBKUmEUSbz9R++3Hwm9yNBo7Z2x1jGsOYZVGrFfmYjXoFqi8=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by DS0PR10MB7317.namprd10.prod.outlook.com (2603:10b6:8:f8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.16; Sun, 19 Jul
 2026 19:18:01 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0223.012; Sun, 19 Jul 2026
 19:18:01 +0000
Message-ID: <6a535be1-fb06-4a37-8a14-2c8591d87714@oracle.com>
Date: Mon, 20 Jul 2026 00:47:55 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 73/96] irqchip/imgpdc: Fix resource leak, add missing
 chained handler cleanup on remove
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Qingshuang Fu <fuqingshuang@kylinos.cn>,
        Thomas Gleixner <tglx@kernel.org>
References: <20260702155108.949633242@linuxfoundation.org>
 <20260702155110.517513316@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260702155110.517513316@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX0P273CA0012.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:26::11) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|DS0PR10MB7317:EE_
X-MS-Office365-Filtering-Correlation-Id: 00c87796-a584-4669-48bf-08dee5ca7357
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|22082099003|18002099003|4143699003|56012099006|10067099003|5023799004;
X-Microsoft-Antispam-Message-Info:
	Vpn2Fpdj545zMCkuco/8srPaDLoKIkOxWZLZzfHUpzDATFMu9VZNv18/BS2JI3eS/31IN8TefbYgSaLX5ed4xGHDykor9T5MouhiJpVZBDnVrQUfpi7ebfQiIH8T2qDY/vCJFu5ePYq0hyDO4BqNqXgfHWx/0ghrUJmZNHwv4pF1idtFpwDbLkMa6ABfjtBt6zzTMTHZzGhoQfJUJwLyR0I5w9i1Emw1T4NvS6oJAQoU0WupPHGv1KlcK0Rw/dVefwbhdkEBZYWoIdz0IDajXH7iWj6ijuPZ3l/653enikhxrw5ajbeGBAUHZvB49IO12e03R3elL/SfcpNeDtprhhsRfTJ4ugHud/FRPYfJ41kBuFLQWTFUsKGinPYO43g7GP52fipg/k0+7+4eCPpfvSbw17rQHQnFe/LpT+uDJ4pdLqo4NUKgoq8HYgNezHmfUzMf+yr//pLQbFlPLxLcdgHhbltvxswr2t59kuqyquxWixq5F2C+sDQpSjKvpdzFCSQUQLbtXYEdvEYaugRNX2okeE0DYMV40pvxq2AilqGrQ53PKC9T8xEP239XwkOnmTyQdR/6waDlG/ikgVLFEWWOofE1iBIkTSGr/fJbf6z0YakizDmYSE4GxxtGu19T
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(22082099003)(18002099003)(4143699003)(56012099006)(10067099003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c2ZMM0MyZXlxdGozcmNHWFV4MFhaL2FEWTZJeG5PWVg0MklLOVRpU3lCemhX?=
 =?utf-8?B?KzFaQnppOG04QnVjM0RSZzVnVUtjNzlRWi9JbjZuM1l2TVRiVVRVUzZZRkVw?=
 =?utf-8?B?aE9SSFlhZWpVeXZPamo1NXNLdElSOG5JN3AyQkpMRUsxRkxrcVVJelZoKytz?=
 =?utf-8?B?aGJRUFpFNHFRdUZHVUpiTWYwZksvUCtkQkwrbHVpYjJkMVFXU3E3UE1sR3lN?=
 =?utf-8?B?ZVZKaTBBUWpVNzVPdzZkQXNXT3pqazZkNHBKOXY0Tk44UlBZek90dzRRYkZi?=
 =?utf-8?B?eTkvQ293aXdVbCtMMllKU0ZBcXl3bVlLSGZnSmsvTXFReHJMb2pFcS9HekFr?=
 =?utf-8?B?MGZLN3ZoY0FsNk9hTW16Qm5GaVZnRWxJY254VGRteFRQanhYNWVMekJHa21C?=
 =?utf-8?B?YVhhWTNuWDI3d3JwdEkrMFkxOUJaRk42VkgyUEtJTm9hRTlWMjFobWk1Qlh5?=
 =?utf-8?B?M3ZhWmpYOXZHYVhrUXZiRjAydkxlSHF3YWF4VHJNT1R2c2VPd1hPVG1PWWpV?=
 =?utf-8?B?TFovRHg5S0Q0dDlzT2RkdkdJSWs3NHk2YzM2V1VlUzZISnlrOFpic2lwUDc4?=
 =?utf-8?B?ZmhTenFpeGlocndlZ2p6cmM5NlJIMTZQNC8zSkhUNGtEdEh2QWNNWkFVM0R5?=
 =?utf-8?B?TlZlUm1NcCs1V1V6WWZud0JKaTd6REo2UmZHRWtpdWlCYUpFa2haOTNVUFJW?=
 =?utf-8?B?R1F4aEQyWnJ3VHExZmNqMThnV1paNTBuREJrbkw2VFJMdlhvdmkxc3VRL1RG?=
 =?utf-8?B?T1ArY1pDZGMxM1BwekFtSG5mQzZHTi9XWHcrb3ExUTh2VFI4SXRnTmtJcGFm?=
 =?utf-8?B?RUZ1NjRwK3piRkZlVURXREF6MFo0cS93aStYZnROS1FMSEUrbWNweXpGTDlR?=
 =?utf-8?B?ajNpUGdHQWtYZ094Y2NJYU1VbHhQYmpWU2duMjN5ZllOVWJ1Q09FaUoxK3BH?=
 =?utf-8?B?Rks4MHc1dDBUQS9FTVVmZmRteGluY015eVo1MDNkTW9tQ2FMeXVxRE1ZaWd5?=
 =?utf-8?B?SVhXL241SytoS1dUNTdBQVhEbDBrUHlCM29WS1RvdnE3L0czNGI3OWZuWksz?=
 =?utf-8?B?L0VNNEc0VmJMalA1aTNKRlVBR0Y4aHcrQ1ptZU1HWTBJbHZTSEhVVHV4SUs2?=
 =?utf-8?B?YnhIeXA2RnNjZkljRThBdUlNRSt2bmFRaFJTM05uQnd3dWNwdFVJRUF6U1dI?=
 =?utf-8?B?b2JwWm1zZ3BpMHdCdkJZYUJXY09rakVRTU41aThuODBtRW0rNlB6dGN6eUFZ?=
 =?utf-8?B?VHZ6RUlNQlIzMExvMzAzZDIwS0pHVnhvWElNT3IrelZYb1NFUHduNjAwaXRl?=
 =?utf-8?B?RkxsSTIwU2JyME02UHZRTFR1WnBpSmdCc0hnaVlzMWdtSjBhYXgzRTZTbE1r?=
 =?utf-8?B?TW1NdFRGcXNBYVV4eXd0WG1SS1VsQ1JoL21XU0N5aGgzNDdnM1B2UXJ5dTdt?=
 =?utf-8?B?R2JnQ3U5R3RGb1ZDOWhjRjBQUUp0T1ppNkl0cEJUOCt6V0w5Nlo3UEhpYWtI?=
 =?utf-8?B?RFZWWit6QmZxNTEyOVA0TFpnaE04UzJBdU81blFpSnBsSVNEdVR1enpRUUJ5?=
 =?utf-8?B?by9KYysrSW5wS2pqb204Q2M5MFg1dm5Rb3pVeGZ5NmpmNk9nS3p4NzlNeXdM?=
 =?utf-8?B?blp6N3lVRWpDSGcwMnpLNlZkaTZPY0JMZHJDTGJ3NmZjbzF4WnU3RE5mV3g0?=
 =?utf-8?B?Z2ZteUxXUlZYcWllWk82QkVuMUkvbUxyeUg2MTNvTTdDbHRlQjhqc1NnWk5l?=
 =?utf-8?B?VHViME9TOXl5bG9kaVJkY3J4R1RTOWtuMGpmSGdQeGdrcmtpTHEyY1lNUTM4?=
 =?utf-8?B?RG8yL0hiL0RHcnhPc1ZuWUl6RTVnTSsvSmV5aEx4aFpkUk04WW4xRmVoK0lK?=
 =?utf-8?B?bUl6T3FZZVV5OGNFbkpJOUhHbGVCNzFHWWpZbXMzd3JiZWYyODBKdEVYRHRz?=
 =?utf-8?B?V2NDUWtoSTBIYXdzRithcCtSaUwxT2ZISGUwdVlZNkZSanRkUWRJWEYxZzJj?=
 =?utf-8?B?aGlqZW5qMW5URHQyVk9HTk9uakw1M0ZtZzcxNmh4RjVYRmt6SDcyUk9lQWhm?=
 =?utf-8?B?ZmpaN0w1YTVyeEh5VTg3YUFhVXFyYXlVRTlCc0hoS25hNTlWMTVhZGw2MzVW?=
 =?utf-8?B?L0dtb0FnSE5GNXM1VXJiYXVhb0xmMGxiZllHN1JWeGFaUlk3Z3MrWUs5OXdI?=
 =?utf-8?B?bWdoNC9Ya3kya1pGTFN5b253VU5DMnJyQlgyMjF2OWJrSHQ2MVRMV2d1cXZW?=
 =?utf-8?B?Qnd1RDdDOE85Y20vVDdXdlZ5eG1NRkpnWGpxZHJGR1VQUHRybHEzV0VOVTZw?=
 =?utf-8?B?MTRlY29VK0lpbnNvYWJPZ3BvNGVLcGFpR2lkVTZqVE9WeHdXdXpnY0FXWDFK?=
 =?utf-8?Q?qlrqYoBGShQ7mbch0SKGqSSGVUjYBC+lVfX2J?=
X-Exchange-RoutingPolicyChecked:
	HPXdI9nUy831wyaKznWqdL4VuUFogg2DqYlfc8blRakc4laV3JrxSBJyr4WOVj3HSozPHk7kg2i9Sshh9MncSdnW495pE9rrlLKnixIBQr6RvsVhk+azn987Mnxa2vxyUjLU5z18VJBdY0tK6TYffIV8pPXEbtkSkTenw5ekyQ2JcVaXmtZP/fyemYYAbbwyl5+VHxccRXJPYZMn7oQfSNSQpO6jdfkXWdvnw4S5FkPpyz3kgH/wtH6XqUnu7lS4VYKx2gqQl6d/62Lxqnm5u898YuOO4Aq+YSlNO+byda9Ub41uRv52iUhueNBrXNRmjKDrdKf5qqCzSylqfQqvbQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	haTB3iKpj8zNgw6K4oX6NkVuGIleOnzjMlqMQXiTepAmwEOr6DXtP1s5PLns3ACHHr6JOJLrzDu99OqgRR0AKa2HYsmddt4XbDbSogRO6+dW/XYFRyKifbUwGd8V7uDoGX0AmV66Cp78X/MppH+mktYol239kmcrc5EyeJ5VxVMOkY3lw+eC8RzM6nfeb2slBEURpucHLOHOXrpcmVgLkKmIrK3CyGdRIDNY4SuIDyu2ChR7qtTUVdSKEblcaxpHP9OjyAlhsvWYfUWEjLUD3fCh6DAw833ZTg9JR7caz9jrfa0grfav+cdymeMQsRqJyvqp/vyNcrrfeEe16L1sh00Msn4VloW69HuNsDjRm9WaLu6LR+q/a6I6oLbAVmoS4rQTPDJlEPwytCZNoc+fX8x62u+vfT0wQ6SbqZ/p5e7kQ4uQ+ByZEHS/wCS5tIwkoLmVKGGB2Vi6xOJwcrZ5pCbLSK6fs2IUfJc8wVTK8TyXch7yNh7HJ40ZdU3OvrI5hQ4H2KQt1Dy+xbnmwQpj21jeaNxvJ6Jbkw6eUVFPhZW+3asZ9oIfoiLcBY1WZ/eaOsB1Xj/uSnBi+V0zVo3vmx1sqCA824qM7KaqgdC9Wu4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00c87796-a584-4669-48bf-08dee5ca7357
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2026 19:18:01.5177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YdoEyZRJyITARHB+17Y7JHmzMxCgwhAcOnKLP2UHVWXhZvl82ltQI/LUo0INuY6qQPh+QbRPDtBxqhrpJqTU0YNG9Uln1ZdEkKxOPUHLdWNAHED4FgJsq42iCJ3y6+mw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7317
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-19_06,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607190215
X-Proofpoint-GUID: hiLLrUNQYx4JfvpT-873f-606BBCnPfI
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE5MDIxNSBTYWx0ZWRfX+spafHGALjIe
 otw/bzl4bOIFRbuxglJ8C/8TIpoaRQC6On7TchnphiCE1IpIuvQAv6HUrGzdionOHFh4mE0Wjp4
 WMBKztdDaSbWBvzK6z+r+fN8mZ0Pyf3gC900+EHA7vy8/Hej9Y0B
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE5MDIxNSBTYWx0ZWRfX1sDmb5Sy7meH
 6rI8L5MHOBFDaZ45VpvqJVkd7zj+GkxjOMDvmbP9q5duyUQnNcLZJCG1is86Rrf/01z30X6D88X
 C49BRKR6aYPELP0ksxOBT2REgu89rEClXo81NMWgmyW1tufKyWd/sxhuU1wnXZ+en2kz1+sy2XW
 GnY95jsdjWVviXrTYOWQs8mOjT4jDZO3ZbaOjGVEX6eNNOYK25YBmITNdBMpJ8Li8FErUmuE8cB
 OUkY9Y3dQtM4dUu7srESdQnWcKZ931Kh1zugpLgc/eqXl3v6BiM9EwIReN3fsqKzI6ouQ5Rq1DT
 RMy6KJFu9+QYLuxDjRjFsyiH3tIsq58c/Op2E9wsPLo1vHDDRYgveo4pyd84IpL2WV+6wAMDfZB
 +iqKeJB8BdKVb0LWb1piNYWnuO8Pfon0dcXkTo7tiGm98yQgWDtcOOXdG4wBzETDfNMyEEDon/J
 p8xrWV9ZSpdfAxy1SxA==
X-Authority-Analysis: v=2.4 cv=ZpPd7d7G c=1 sm=1 tr=0 ts=6a5d22f3 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=bC-a23v3AAAA:8
 a=Byx-y9mGAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=BVfjzp0RYeI6S14QljEA:9
 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-ORIG-GUID: hiLLrUNQYx4JfvpT-873f-606BBCnPfI

Hi Greg/Sasha,

On 02/07/26 9:50 pm, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Qingshuang Fu <fuqingshuang@kylinos.cn>
> 
> commit 37738fdf2ab1e504d1c63ce5bc0aeb6452d8f057 upstream.
> 
> The driver allocates domain generic chips using
> irq_alloc_domain_generic_chips() during probe and sets up chained
> handlers using irq_set_chained_handler_and_data(). However, on driver
> removal, the generic chips are not freed and the chained handlers are
> not removed.
> 
> The generic chips remain on the global gc_list and may later be accessed by
> generic interrupt chip suspend, resume, or shutdown callbacks after the
> driver has been removed, potentially resulting in a use-after-free and
> kernel crash.
> 
> The chained handlers that were installed in probe for peripheral and
> syswake interrupts are also left dangling, which can lead to spurious
> interrupts accessing freed memory.
> 
> Fix these issues by:
> 
>    - Setting IRQ_DOMAIN_FLAG_DESTROY_GC flag in domain->flags, so the
>      core code automatically removes generic chips when irq_domain_remove()
>      is called
> 
>    - Clearing all chained handlers with NULL in pdc_intc_remove()
> 
> Fixes: b6ef9161e43a ("irq-imgpdc: add ImgTec PDC irqchip driver")
> Signed-off-by: Qingshuang Fu <fuqingshuang@kylinos.cn>
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: stable@vger.kernel.org
> Link: https://patch.msgid.link/20260618021352.661773-1-fffsqian@163.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/irqchip/irq-imgpdc.c |    6 ++++++
>   1 file changed, 6 insertions(+)
> 
> --- a/drivers/irqchip/irq-imgpdc.c
> +++ b/drivers/irqchip/irq-imgpdc.c
> @@ -385,6 +385,7 @@ static int pdc_intc_probe(struct platfor
>   		dev_err(&pdev->dev, "cannot add IRQ domain\n");
>   		return -ENOMEM;
>   	}
> +	priv->domain->flags |= IRQ_DOMAIN_FLAG_DESTROY_GC;
>   
I ran an AI-assisted backport review and the report looks correct:

git grep shows IRQ_DOMAIN_FLAG_DESTROY_GC is not defined in 5.15.y, 
maybe we don't care about this module in 5.15.y at all ?

Also evidence is that commit: e6f67ce32e8e ("irqdomain: Add support for 
generic irq chips creation before publishing a domain") is not present 
in 5.15.y.

Shoudl we revert this ? Do we care, as nobody reported a problem, thoughts ?

thanks,
Harshit
>   	/*
>   	 * Set up 2 generic irq chips with 2 chip types.
> @@ -472,6 +473,11 @@ static int pdc_intc_remove(struct platfo
>   {
>   	struct pdc_intc_priv *priv = platform_get_drvdata(pdev);
>   
> +	for (unsigned int i = 0; i < priv->nr_perips; ++i)
> +		irq_set_chained_handler_and_data(priv->perip_irqs[i], NULL, NULL);
> +
> +	irq_set_chained_handler_and_data(priv->syswake_irq, NULL, NULL);
> +
>   	irq_domain_remove(priv->domain);
>   	return 0;
>   }
> 
> 
> 

