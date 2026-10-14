Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55133475351;
	Wed, 14 Oct 2026 21:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792014031; cv=fail; b=riIkZzd9WcZrj6in0cD+7OM65mzbNxUJoUE28Ffzm5U49wT3p3mSg/9PVUO0NvYSARuWjhAmvEBf6e4w/xuK6ku9AG5xKgle1gHhz69HUX7S6DohtAkZrpWFc1FEBzMUYn8wQlwduKBeGtnyT7xwvO1qX9FKVtXkCY8QIusI9xk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792014031; c=relaxed/simple;
	bh=5yLlF9MsrsRkzVRrEfJmXeoKrpFFLoE/C0HSwnLouNM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZwDhvPKUae9vnKKCgeZoWSpSSnZJrlIP2i5FwcgBvMGs2Ljmjqk6h3ARh0mjGTQaOLAx5R3vdCS+30r1gbjQvERmNcFGGfSFDiGKAqzeSLLJVd8iMs//qs6/udMutM9LugTzo8VwEKbBCjzgfky4U+pwAx0GZ/whFJvdZQSzgDI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hmi8aDyG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=y5i1Udsh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hmi8aDyG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="y5i1Udsh"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69EL0pQu3614948;
	Wed, 14 Oct 2026 21:40:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=D2aRG3KeEMwlabt8VJli1JRdDwxCGQe8BuKyPf4j1PA=; b=
	hmi8aDyGTy60n5w6DIXjOZphev1dpVkg+NgeDgl4aXfNptMHhZV7KtqPKmbkR3Va
	E7ZrfwUZwjkSXlWnyPQYv7TzhnVKP/Na7Grcve1T5WLx3mdDwAUSMsoxvNzXNHLd
	FzoHl+hoRngzI5D996S5Zxp8g8MtLKnKvhyqhSRc1LBqRkCXJq08XiarSAAxmCAE
	lJwR6tkEayL8RR4Hhvq517/MetyGsflTV4jQU/drVOJ5fQM+gVl2v+CR9zuOJMMV
	B7NeuLRFx96G6uRtj++/6d44r+svx9SIJMss4tYzB/XzoemHyKMXfKQYUUK4dNlV
	1jScSl10e4YPMKfhSBF2zQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7de1q1es-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Oct 2026 21:40:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69ELaKR0006603;
	Wed, 14 Oct 2026 21:40:25 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011014.outbound.protection.outlook.com [40.93.194.14])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btbffx0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 14 Oct 2026 21:40:25 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=We119meb2FerGpX+qlKCAWqx4pQnCy5WhkRVIAsSvZTsllImgmhRdg8g5D0Zw1/tEXDjH5I1wwQP3QFkphhWZKmA4xnJha/k1yvA3syJPBkEDeM1V48EjhDeYVqDrDCAjq7E2S/Y7DSmZcBx9kDlOfh0Z35abkVYo6Eze/EIjRvNN2shh6UNJK/6/+Q1ChAT62heo4yrzfid8VZeCMrP7LpZPxGiSn0RvTz3MD2qNIryRp8Mj9KAWNQw/UpPS8NapJBybHksnRCKbFZKKmfhBqe5h64uYozhvoD8h7M1/47Uq1rGplUWrEhBKgmvL2jtNXQiC7gteg57hGJitClEOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D2aRG3KeEMwlabt8VJli1JRdDwxCGQe8BuKyPf4j1PA=;
 b=CRX14bwGxdhUI3nZy3l49T/a16OV/efNvRJBjjglGaYd4FbWiUpAx0jhWM1HzV8fDULdWm9lgGgxrXyoGDhyXRGDV/ERUftDjqp/Re3YHvpo9UxeLIDaatENdaum7RF01ZW6ICN0cRTuo2vBXYBKaQUlsFwTrquNovIGzoNu9WZu8klj2i4PLPDM5D0Twoy1Mm0gVkxn43e+UFkGYgz17aiZmxNeLZGmVjvVrsgFp5dE8n3TkGAZREUDvSs53ihNqp36RCv3bY8SJssfdzlslhg7cQEHGey4NjsEAMZenE3Ei9974iwIcU0n+w7tDOr7p2oMgf8s2bGuonOg/TVUew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D2aRG3KeEMwlabt8VJli1JRdDwxCGQe8BuKyPf4j1PA=;
 b=y5i1UdshPs5VBL2XRphPrp0NTFCGThoTN4gINhHaQErH49Fc98w7fcubnbXl66a/oCnNy7KSlbPQWKlU2S8EM85XoDf4caLfRkZxFONm8JZqnUwviAo8L4ZcLQtn0uapu8B0pv/mZlTp42kHuTaqY/HoGE97V52ZXI9sgSeE5/w=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by BY5PR10MB4290.namprd10.prod.outlook.com (2603:10b6:a03:203::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Wed, 14 Oct
 2026 21:40:23 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0522.011; Wed, 14 Oct 2026
 21:40:22 +0000
Message-ID: <0d7c5b89-87e5-4bcc-bb6f-ed44065956fe@oracle.com>
Date: Thu, 15 Oct 2026 03:10:16 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 406/497] net: team: free skb when broadcast has no
 txable port
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Weiming Shi <bestswngs@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20261013112907.864180619@linuxfoundation.org>
 <20261013112917.527762800@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261013112917.527762800@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0322.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:390::16) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|BY5PR10MB4290:EE_
X-MS-Office365-Filtering-Correlation-Id: 75d55809-860d-4ad1-663d-08df2a3bc011
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|56012099006|4143699003|5023799004|261009223027099003|10067099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	wmcUm9tfe9J0LN0h4S2n0aSHn5ZApyvSrQelfL0+Xk1Y4UwNIiQ3elAt5HcbiQ5FctoFQfn3admHpARJCaNuBucuphZ7/HJs5/wuduEDDxp5F1ekY05Wbr0MJqV6kjdiBTdp7jwdu4lWiUifeUt5u1qo95ieWDNDdKgy7/DnzUKbbpdam35PgKXWRXkjDCuTzloSLZh0Sffq3lfEzyk7OFSsvZ9c6G4l0KR83AUly4ezgc6hNdWkb6KSKy6LBPVLchleYHKxFopX0RPUD5jU1GidVnMzBU/cImeUiFPnmKbZ9s/egHmmJDJHLV01Q21uJe7vKij+qqK+G6R9l7yKAZE/NksnrRPNxQPfGldVaNBMiNIr1UtxsyN7ma1eyWssamQU+pX3u+OUbyUtY3Ah7C70IyyKE7Jjz33NE7TU6JRc1qf/YpG73Czyvdzuk4pDGU+tCvbWXe2i1OqrowLQ2SCAXPJ7DtIxv94sZlYatTdMezzMI33oleTQAhpWUFP8VppJ8e3o18pq5gnQCRp6asSBFrjAalfPyEpjWuKTaRoKQyeR+miAtc0e3VyAasATG36KSrDKn0aHy3cI8LN0VWXJydSmpfIq/NRkKy66JhU1M91Wbj2JUGDC7eZSiMJw
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(56012099006)(4143699003)(5023799004)(261009223027099003)(10067099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Mkp1ZmRUNDJYc3RnWXdLQURLYmdVZ2lieDU3d1p3UjNNamgwQ3BFaDUxdmhn?=
 =?utf-8?B?U0JpYlNhdG1zWkJQOUJ2STV3Q2dMT1NPZUJLWjhFT2krOElxS05DcDRvZjR4?=
 =?utf-8?B?ZHpERTJYMTFkd3dQSEdOOC9DVlF4UnNvejhjQ1Q4QlQ3bEREbUpPWXduUDNy?=
 =?utf-8?B?OEt5cHYyZ3JmVVpyb0dkbFViWnEyUGFNdjFydjNyZnJxaW5xdlVBekZOMWxK?=
 =?utf-8?B?MllST0pMbkNzSGwzdW1tenJKUXBleStWOHRhSUtwTkNJUjJDbklRS2FUaUdt?=
 =?utf-8?B?SEhuNEtTNXo3NlNmdHR2VTNJTEhsZTBCYXRwTWdWbG43cllLcFBEQnVzUmhw?=
 =?utf-8?B?czB4TXdPK3hwYVFnalRFeWtoekFuZC9rdTd4STg0RGg3dHVRTXlJWmFrQXZB?=
 =?utf-8?B?NllYdFlkNGRuMzJsZ3FTUklNTFN2U2NEYUk4QVJrVUdyM3JnNGc2WWQxdU40?=
 =?utf-8?B?L0lGK0lwd2lQcjJCdmRscTBoamxQbTVaQmVBOG9KR2xtSWhQNml2c1dSOExk?=
 =?utf-8?B?RDdXblAvd2FPQ0hNamhsUFJndzBhN0JTRnkzNWlZcDJPQmxVcy9RMnBSeWts?=
 =?utf-8?B?MWNKSDIrVHFLcjE1NCszN3ErcHdaeUtJQ0RLdGt0N3BnalNQQmVNbThOTGR2?=
 =?utf-8?B?UTl5UFlYOWYyK245OGlKSjJ1WlV3ZkFPVXl3ZXVOWlh2Y3pUaXdaR1AvZmRn?=
 =?utf-8?B?d3pLdDEvaWcvTEJqTWpiMEV6eVZQM0huak14S1lDaXYrMnBJK1dGVXNPdHVE?=
 =?utf-8?B?eFlaU3ZzSnBCVXljVWdVU3lYblFKUVVHWEk1VU95YnRhb2wwTVBhY25aS1Q4?=
 =?utf-8?B?ZTlmMXNXbFFKOElvQnp0ajlPZzEvT2dYdHBCRG9mR0xRMXNLcm1QSHVrOWx6?=
 =?utf-8?B?YUhWR2l5UGJHR2crM0NueGx5TW9oQmJxczVjemdCV2pNNDBYS3h6enZheVhG?=
 =?utf-8?B?b0JmZWR0ajk5ZFFGWk52eTdxTmdpU2VZNE5HTVRoYUNvZXdXMmFGREJDK1JH?=
 =?utf-8?B?Q2gyM25zRDFqTDEwcUV1UEZTaUFSVmRWSi9FaHhPK3RFY2FROC9PclNlU1Iw?=
 =?utf-8?B?VmNrVGFURHU3aVlmT2hsOFRDcVV2TkVJZDVDZVVhdTZCNkVJbzVhUG1tQWoz?=
 =?utf-8?B?dzlWMVViZDZPaWxmM3VVWXFHSVoxbnphUjJEL0h3ZVVvcjYwa1Y1eXc0Z3d6?=
 =?utf-8?B?Y3ozdzdsTXZHb3hwNzV6Um1GWUpzaElOYWorRVZ3cHhKM2M2Y2ZNOUV5b2ww?=
 =?utf-8?B?M21nSGo1eDJERkFLYzEvQU1KRUxTZ3ZReHFlWW4yRTVxR0kxU3FIcFF4aXNH?=
 =?utf-8?B?eUZmYTFRK1Zoa1h2N1k4WUlyZzB6QkxWVm02UU5OaW9hakdlT1B6TXRMQWVr?=
 =?utf-8?B?Q25jcVVNcXJ6VFFGMnR3ck4zcUxSVU5rUS94K3VOaEFLNnBSUG9zS0dpa3Bk?=
 =?utf-8?B?cW1KVUlTRWlwZUYxWkNWT3crYXgzbExnZG00a3BaMHVtaWxjYWVFT01wSFM0?=
 =?utf-8?B?TXpyYThmYnZjVzhiazlnTkc5ZmhuK25KUGhEOFFzTDJwSmZkRm1KOXJ2enll?=
 =?utf-8?B?Z2dmVHlocG9HRms4cCtZakJHY254MzVNRHhrU05VVXJnalNzSGE1TEIwczFH?=
 =?utf-8?B?UU93NHYrU0tZYkdicG1vdEdacDJWM2dIRFl4NklwVXlYbXVZTjRQcml2dTVE?=
 =?utf-8?B?RjJFeTgrSTBubHQ2TGM5dElGbXJCN09SODl5VXIvRmdvSnFRVnJmSmppNHlV?=
 =?utf-8?B?YTlQUjVBK3d6YVp4a1dvd0RxOFJuOThpSlAxVjNIVkNZbmpmbGo2VGNNcTc4?=
 =?utf-8?B?SG5uOFBCY1MzQU4yd0RoekhBMHF2ZWxweEREclJWZVE5azBsTWJnaXZ1Tk1u?=
 =?utf-8?B?ZWJFTGlvWnRYVzJ2N3JibCtHZzdFb3J3K0NPcSttUFNSdnR4Z1RzL0s0RVRx?=
 =?utf-8?B?YktYbXpFcGErc2JEMXRseFYxaHV6RWt6WmVMOWNJL2M3V2FyU2dZY08wOWRo?=
 =?utf-8?B?aXV1TW9YS2MwSllTYnJ3V0pPMUJxYmUzVFFzR1d2SXVlSytJQUFaREovcFR6?=
 =?utf-8?B?WUd2djBjUk91d1NwUTN6Q2o0a094QXdjRk1pU3NISFovK3J0ZWZQaGN4QTJv?=
 =?utf-8?B?djZPa0l1djQxSlczaTVmQTRMSEhpaHRyRjRxNW5UY25kU0g5UmxGUDU1MGJB?=
 =?utf-8?B?NEZiKzFPcFlERU9yMVJtci81czREUFJpaW1QaUhTOWh3cmN6a3pMb1RmRFNZ?=
 =?utf-8?B?aFZ1ZTZTUXFlVCtCL0UyV0ZGZUh6NkJBbTJsOExlaEh1emdXN2NTS3A3WVJo?=
 =?utf-8?B?TDR5cnBrcnBBd1V6SDhJUHJHSlZsK0UzYVBMSVlEZ3haU3NWTWgyRnc5YzY3?=
 =?utf-8?Q?a/+LkDJdwmZX/fJpatzTpSLnfrlQ7Uday1dGw?=
X-Exchange-RoutingPolicyChecked:
	gXbgUAXC1HAjSo4gOo9S+kKs1QxBO/NqIYOHVznZq0DulrKqiieTW2bqt1lyBvndDCAR4xsNXSRJozQ3dzeIq5a4YiN1xRqn4/lFYn8VMjj/RS3oRPbHavdJ2FM+aP5qkjIMjTX/uacKLlmmeYVb2SZWzxinPncmdgTNMP3VAjrKI83UB5a3Jk3swqLcEftdFS32o27MTmrQATnsfGwQgLuTTWVeWjI3Sc+yHIyCnG++paOtyAA6nH5VUpiyCA+ljDt71X0l8L/B/IN8iq7UYSIT4InU516EYVSzC5Nxrj0MatMm5jxnB5fG3bHOAb55yU6pqxqUU9D9GOX3GwJG/A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Mb/Q+xUgNezANytfzTooKn6LdmpUOEQ3k3iHPdwbb4K9thZgZfsTP47yj7+a2WkNihiHBPRF+HiyaRwo8OvoG+XxiNo4jA3WVNtg+ixHy2bNWzJ7ItHnNYtO9x3j3kdqTkPpU2ljxlGYOMdAzfODIlyMAcc0PKrkm+gK/UJvg3UVI9rjImd7qyGl2/p1dBAIVbMGYUDkC3FATRv3LK6klrHYBv9on1lCKLL/U3xuQ/ZQR5JpC25mFtHhBin6naJ1EH2mY5JTJhe3Rr905CZ3zAhVtz6+su9dOv//xnyNi1xur4gcsQqNopTqj+ChSdl9bh6mll8A7ExPXIxmeU2tpyd2L6g+shC8dWyswV9uVhUZQpNf5eycwqH1JOsiMyLFOoyJVCYgVvEmOs1pKMcVeAr8SvEjRMM0BTnfL5KQ9UmGnPMTbOvDvmlvyEFmq+CuQoWSr/b5x3yL+uqCW9xm7VE8P7j3lsQRnOC6TirOCdNcSGmP8VBYzYRfB380c2A/KijtLjWXygpO+xQ3R8Wvc69FyVaIYLgAGh17KIn8+K6XZ7X7DTUX9yEsyXb7sL/d8b3HgHbZrEbQmsX36TanZmw3J3VVqqomGCWdTrBvcqA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75d55809-860d-4ad1-663d-08df2a3bc011
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 21:40:22.6202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y8vCw+siSLpr3llER0h/8cMWtAqoygL00wYlPYO8OWQLYy82KrCna0MJxNGvpt+EsOl8+YuqXYS35Txmfvf2we26tcQTn6do/sfZfs4ibCQ87DXc1IOMOyXMsky5RRct
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4290
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=936 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610140086
X-Authority-Analysis: v=2.4 cv=O9SsLx9W c=1 sm=1 tr=0 ts=6acff6ca b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=bC-a23v3AAAA:8
 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=56F0pANeB0IEYMCdWEAA:9
 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22 a=FO4_E8m0qiDe52t0p3_H:22
 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA4NiBTYWx0ZWRfX3gOOKJEUBm3i
 ZGFfJC96ZhDny79id4XuJSAe56nKOobxK+9lSzFzTqaNiDF8oZSHRNEGABEa10kWLfkEgAgx8J9
 uhhNu5onOwscM/r9BrfurioZM0/XtwZj8kqX5APFJcfsnUksHzo3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA4NiBTYWx0ZWRfX7TczKujJoR00
 pfiWvQYhZpFEse8TpL/HzHouwouI0DawVNKtjtQWW7BXoao/SSK4tfTMLk/Dwd7aqLoV9Cxj6fn
 ycGjJKUvisHhsbLKIaxcs5pqOhZ6IRKOub4sTer5N1RXlvwcBCDeYo3GoHRbNY/R9LrgzGK1Q6F
 HlHwbHS7PvdjnQZVD8EyUUaT0nO6cTniQZgGirejBaFnkQ9UjHgsL5EKI9JTBxIL+Nalvez4ENz
 n6EGbzEu3kP+pIRPm83EypVmQ+ZNy1oU+dcpP2v7KzoT4CqrBDE0Vd8gXDCN+ic8c4i2OMBXtTJ
 pOyc7WGmJF//MIe4A275vzVMjpIrZUWFROuFCNzd3giWUYHEu8jaCRrNKe/WcwVJKFv/hGjiloK
 jY9FldD50BiqbRKq4Hvs0ZATu9DPv1Rr8UvrwtBEdADgwaf05vxK7Btv6MUa8jOpf4M2qRaY99l
 GGddUl+yj5/OpZSoadw==
X-Proofpoint-GUID: _zgIpskKd8OKWhEel68jd79NAcrGQqZ_
X-Proofpoint-ORIG-GUID: _zgIpskKd8OKWhEel68jd79NAcrGQqZ_

Hi Greg/Sasha,

On 13/10/26 5:09 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Weiming Shi <bestswngs@gmail.com>
> 
> commit 489114c9ecae44e523361a4b3e610ee5ebd9189c upstream.
> 
> bc_transmit() sends the original skb through the last txable port.
> When no port is txable, it returns false without consuming the skb, but
> team_xmit() still returns NETDEV_TX_OK. AF_PACKET sends then retain the
> skb and its socket write-memory charge.
> 
> A TX-enabled, link-down port keeps the broadcast transmit op installed.
> Carrier can stay up through a second link-up, TX-disabled port or be
> forced on by userspace. Free the original skb on the no-port path while
> leaving the existing drop accounting intact.
> 
> Discovered by Sashiko during review of previous commit.
> 
> Cc: stable@vger.kernel.org
> Fixes: 5fc889911a99 ("team: add broadcast mode")
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> Link: https://patch.msgid.link/20261001182326.572045-3-bestswngs@gmail.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/net/team/team_mode_broadcast.c |    2 ++
>   1 file changed, 2 insertions(+)
> 
> --- a/drivers/net/team/team_mode_broadcast.c
> +++ b/drivers/net/team/team_mode_broadcast.c
> @@ -37,6 +37,8 @@ static bool bc_transmit(struct team *tea
>   		ret = !team_dev_queue_xmit(team, last, skb);
>   		if (!sum_ret)
>   			sum_ret = ret;
> +	} else {
> +		dev_kfree_skb_any(skb);
>   	}

An AI-assisted review identified an skb ownership problem in this patch.

In drivers/net/team/team_core.c, the downstream override helper
treats a nonzero lower transmit result as no handoff:

     list_for_each_entry_rcu(port, qom_list, qom_list) {
         if (!team_dev_queue_xmit(team, port, skb))
             return true;
     }
     return false;

Upstream 489114c9ecae separates handoff from success:

     *tx_success = !team_dev_queue_xmit(team, port, skb);
     return true;

A lower-device drop consumes the skb regardless of its return value.
Downstream then falls back to bc_transmit(); with no txable port,
the new dev_kfree_skb_any(skb) releases the consumed skb again.
The override bug predates this patch, but this adds an invalid
release site. b7454f1940c5 ("net: team: stop reusing skb after queue
override") provides the required ownership protection;

I think we need to drop this without this. They are fixed in a series 
too: 
https://lore.kernel.org/all/20261001182326.572045-1-bestswngs@gmail.com/

I see backports from Sasha, 
https://lore.kernel.org/all/20261013151545.72467-4-sashal@kernel.org/ so 
I think we are good!

thanks,
Harshit


>   	return sum_ret;
>   }
> 
> 
> 

