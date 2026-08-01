Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42004340411;
	Sat,  1 Aug 2026 04:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785558485; cv=fail; b=F5jhyaHwGPGdiGIl+fhQonVT9P2HWqnSDD6bCo0HXZ/O03Jj2GcDkYSbzAVasAjNrnDSEJrte6TGrL51b1DyoR7HakeSSE9xzvxIWITnwHWWOO2M38K+LR4x2O5yWQgo/xAkXsM78LCwPlepD/g89UQTTkfXD9GnBv07xxF5xmI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785558485; c=relaxed/simple;
	bh=9btfgRhR8AGpifKBZojeieMuq3+qgvRGuLFWqtOCyPE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KXN8MBhZ8GtMws+uns4CJ4r1WMJ73u2Hzuzx0e6QfFuaccK9P4dlsSgHqtcqrTQsGhfSMVkxq1X6mvg8zZXczGYTKzkzHJqSPwJIOFaDEkuiVVu1YF+FzyIg8U8MAUO3LMphsg4t0joIdVoLbbol5jXlbBnt63Lz5F2yy0eMVS0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dghbakEa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CYDiD+xO; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dghbakEa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CYDiD+xO"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6713vVV91215718;
	Sat, 1 Aug 2026 04:27:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=jNMlEXxJ5F2gRBQamdq2I28PWy0nYT03E1VTaRrrlZQ=; b=
	dghbakEal/wkxvImjLTelTJiVdXN6U+EZIrEmsmexx+KvjVEVMXjK7Mssuwt8phk
	XVzM6Jsvt6zMusNzRA1j5ejEHNFpjrEQI2JzEwnbGpKYqy3UYZNJijLOYvgVOt9+
	FHtdbuTAV9Yx2P/jKcPveojKvKZBBh3qG/oPGU/2rsuTu4BniZZqiG39oFzwUwAk
	f3I8RynU2TFqsqR+AeU06cZxLbgoREDbdVQwl7xNg+vCGc7ThoA6FRE5hZD13pxi
	X/MLWh18qbtdgitcW4MmpnpJXDCPV4jHlCNoFtZGn542kfDWj6Bptd2WsQqChIZb
	o/GyNc+be/jBkRu1tNi3eg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs9bt02hp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 01 Aug 2026 04:27:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6714P1u5024980;
	Sat, 1 Aug 2026 04:27:58 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010045.outbound.protection.outlook.com [52.101.193.45])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fs7892x0a-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 01 Aug 2026 04:27:58 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FytL/ZA6zJUC7Lm85aufUfcCmgFg3XIJSMJjfrZPThf7qXZ4wUz8tgVJxbmNGvNUkVu3psHVAe3+B2ZC+fZuHZfBbkebmdTu8Ws80UIVUfq1ThAM6BFLgVJAvVlrg0DaxAlFp4PpduJi5b+5zYGXUvx5zVGPoVTQ8jez8tzf5GY239kGssOogeu3nyI6/lnN+HoL7K7HuhxcXTB3KK7+x7NX8U20unKM8mqj21kBwxd8oGjG+AEJZyhb52AqwTJ3oTDJbbDxWmA7OxbZjCoW1V254hHh+lmd35k85StHSqZlSiYy5t3bWZkzdk5h+vJxS35Z31hR8HoFj+lFTrYx5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jNMlEXxJ5F2gRBQamdq2I28PWy0nYT03E1VTaRrrlZQ=;
 b=LOjAtFAe0a9wASaCNaZUdEEwek9ZUFaWyUJNo41PJdU/OnjyzVkb3KRNCiZx0OoJjqdfoF3QVPK7/VLdqkHLGDnmNA3mgAOsfc0kFrKGdwsEQRCpCWIP3JSwfbOpdzoP9Mdphrc6IG1huzonAPIY2KmaLIA7gBPjOReF2PE7dI91EK/X4yG0qzDBsi70TkBBHM1lPpksTsyMzY7YyVM/RbnIoKYUprAGYOiJlLDE+MVQFxrAIOvS35/K6PtkIrA/uoisLgtchv+1XVMzG1KzAJ+9MSxfpaAOkO9/Y7xUlTwgl9XxVZkFCqGEsWFqqcMCmE+g5dFJEqg3avvOSexmjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jNMlEXxJ5F2gRBQamdq2I28PWy0nYT03E1VTaRrrlZQ=;
 b=CYDiD+xOmHaE8jfj/VN25yeArhcLvkaAWJVI5ad+waeNkClEKS0Pl3VrxdCjAAVd0dX1tvARTda1YTX/d2NMIma/7yTpV76038Z+59sa4adEY7MmKkpz+WEpnfas9w0Hn+2qimo/CYu4Bwd17d38LVqLQtblBEj7aJ5Vjzd3+qQ=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by DS0PR10MB6080.namprd10.prod.outlook.com (2603:10b6:8:c8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Sat, 1 Aug
 2026 04:27:54 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0270.012; Sat, 1 Aug 2026
 04:27:54 +0000
Message-ID: <6006a83d-d1a5-46c3-a501-9d31b27204bb@oracle.com>
Date: Sat, 1 Aug 2026 09:57:48 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 513/602] sunrpc: allocate a separate bvec array for
 socket sends
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Jeff Layton <jlayton@kernel.org>,
        NeilBrown <neil@brown.name>, Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, vegard.nossum@oracle.com
References: <20260730141435.976815864@linuxfoundation.org>
 <20260730141446.781523139@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260730141446.781523139@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0137.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::13) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|DS0PR10MB6080:EE_
X-MS-Office365-Filtering-Correlation-Id: df61d319-0176-4d14-4bff-08deef854192
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|3023799007|4143699003|22082099003|18002099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
 lnemO4HC0lqqxhm1yRwk4Ai+hEqvRO2IaBL2OAgoa0SNFunUO6aInG2AnfRLqZavc6puZ5ag1jpf7dfQbsSMqDdC2vRG0KRb9WX10A0GZ/KNEf0w0h/m1KWQqsHXq+xHFu+usUZwCOzbukTHC8TeQ7hVn7E8DdB3Dx/fctxWr0QJYJXEtzKtxO4Qn2k29lcOSmGVWem+mcB0br9EwsitOpWLqn177REHKTC4tQIvtYYXVq03X+HIiL9uFUIilGZ0heTW3jYUP4eb04nVHA0pKsKil10nX/iWWkJJsStDFmt6Afla0QgPPxaBBIUvA9bHl0JpVhs6/7PTqb2dSBOUwyDjlI9JdFi/lVMWDm6h9eVLR9V2wY00VTmCWhjjT6O9/Zb9VlvN7fow6108FgRE3Oe+Kz3B0l2BJDxj2CFBi/hJXqYy//Bt2ErEGw9OsJxOazC9bFDrF9k3vwTx08wffMqun6WV8qFJE7duRbdZNdHVL10aqNZt4yJvKdtYW/rAZiKZHI26Y3xoDKI+k0OBqXEwDmYGSfhY62IqrdVffvwuGg2fOMFU7/LXtALRLqVBUTOPHo2rCKLOKnxOA5QNK4mNng0AwVFqKE8wj12lxVep4ZXKXtr0273DbkGQV3f33QRQ+PnPtMAJoW82+WWZHcHq5l2JubSc90PkjpRliHU=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(3023799007)(4143699003)(22082099003)(18002099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?c3ZUV2ZMMDdjZ2dOMW1xeFJsZHZFRDlhQStUM0RFakNIN2J3SElVZWI2NFNX?=
 =?utf-8?B?bWk0M2h1dG5pUldFY2FGWitOUTYxNkVMSGNZSStQbWtGWGRkUnFoeGhVZGRo?=
 =?utf-8?B?bkNNWjY5NFJBUlFnbTdkWlpJcnM3Y29FRzF6akF5cGFGbDN6blJyRGY2bndO?=
 =?utf-8?B?YVZnc3orUEw0SkQybVpjMEJrV1d2RHp2WEQxQ3RXSGpPRVZOTVlKZWM2UnZ0?=
 =?utf-8?B?M05jcEYzOWJ6MC9wOEZCT2FRTHZ5Ykx0alhnZitjeCswWGRLVTVIL1g5aHMw?=
 =?utf-8?B?a3VxeXNmcGZ1TVpyS3kydlNYbjY0c2taYUtYZlUrNG9oSkxWeFJKMWM3Zm1G?=
 =?utf-8?B?T0p6L2dOQ3JUazg0a2JEK0xUMnhLZ2NCeFV6SDdTeFhDa1pTbEhtVlovelVi?=
 =?utf-8?B?dTNuMmpFSFNsajBFK0RqRU9YVXFuczZMZzYrdWpuNUhVVTk3RE9SU2lGMDBO?=
 =?utf-8?B?K0xlenh4TXVjOHd5a1Q1dVdROEFDc3VnTzZxRFNVWXZMOUZYaE8vb1JmUXJJ?=
 =?utf-8?B?MUNTQ2xPQlpteUFESWVPM1hSSzY3enBZcGRaQ2JWc1BZV09UZS9zaHZjSVhj?=
 =?utf-8?B?bWNHZUo2S1hFcnROK1pZdmtaYlNDWEx6WFIxODV1NmFvallxeFNwVjNGSmNO?=
 =?utf-8?B?UmY2dmY1VDlKNjN3bmNyL0V6RGxvcHhuUEx0Wk03Q2JWTGdPU0xHZEQxR21V?=
 =?utf-8?B?ZlFUYkRzTmxyRFpjU2UrNkhTTmlVZE45aEtyUXgwZ0diVUVtOWlXMHpuZVF5?=
 =?utf-8?B?V0UxMlJMYURMTk96bUY4YnV5b1FNRHVNcjVISlpXUlIyM1hCbkZCUlh6bTA5?=
 =?utf-8?B?RUUxdy9ZQW9FSnFHQytUSVF6MHhuUHE5QjRnTW5wODZOMjIyT3JDRjJyamxV?=
 =?utf-8?B?em9IN0REKzgvdDllOG9YTFQzZkVCWklzazAzM1YyN2dDYVFZY09SS1dRUHRB?=
 =?utf-8?B?NVBCekhvR1RONkhJaFk1M3cwZHdsWW15SmUwMWxJanRHSXg2eDhDbVFsSHF2?=
 =?utf-8?B?UEF4U2hhUlltb0FWWVR0eDhmUU9jNVl0TmlJNGM1S1BFTmVoeExWcmJjdHpv?=
 =?utf-8?B?aHV6eE9QckdiUWRETWhzZnBOSjNlcWdYMjhlSklCS3ArbnlXRnltTHpoRDRz?=
 =?utf-8?B?c1hZZ1lsRythQXJjdk1nNkJlVTlHSTFnQnpkeUhPTzlyaHpNWktNRnNhYXRX?=
 =?utf-8?B?aFg5YXV1THB4M3p4cXJqVUxxMEltNkJHZ1VSYWlyZzNZd0dOYS9OM0tLTEJk?=
 =?utf-8?B?TVZRYUFMZTIvYk02ZWdZVE1XUHFHRGZvVi9KSFF1N1JCVXM3MTlkVEZPTDdD?=
 =?utf-8?B?bmVueFVGSmEyNnp3RVJ1MW9NTUtqNnJscVcxVnRZSWhNVE40eTdsRzZVdDF3?=
 =?utf-8?B?QUdwTU51dWpaNGd2M3FSWEZKTmRzUnVuVW8rbTdUaXZmbkRMSHYyYi9uQjRi?=
 =?utf-8?B?WTkzaER2TGZkbmhSSnhYNzE4WG5idDRrVnUrMDA1Y3JqM0pwdFBwUzhKRGxa?=
 =?utf-8?B?bHVucHk2NnJKdlpocDZBQ2RrUmZ0cXhleXAzdXlaNVZBczl1NzREdmliNVlN?=
 =?utf-8?B?MEJLdkFaTk53MEs4MTBZanhFbXgwVjZVZ3k3MlRQd3oyeWordXBaS2x2RFF2?=
 =?utf-8?B?MDlmblIzV2czaTZUUy9DQXJIaG1mNWt0NTkvZ1Q2eW03dkl1czJlVk5heTkr?=
 =?utf-8?B?dWdRejBTci8yRDVpYzJyUzhSNU9Yd3BheVFMTDNHN3ZPajFqL0JOMm9QTFNT?=
 =?utf-8?B?MHRhYW5TT3dJRVZpb1kxRkVIS1pnOURsejBKdVdKSUl1eU1Dd0NEcndiczl6?=
 =?utf-8?B?dzVJWVNqLzdPK3hEUWhhblNnWmFMbWVBQUExZHVlMjQ5eVFJK1ZubzVlbklo?=
 =?utf-8?B?TVV4S2VWdzFJdmxmRUZiRWh5RWx0T05zWHgxWlJ6VnoybitpL01uTGxNcnBu?=
 =?utf-8?B?MW5MUEMwUVZhNU02TEdJc1BDenh6MDVWQ1Fmd3ZDa1IwR3grZWk1MVd2UVN5?=
 =?utf-8?B?YlpuZjVlc0MwZWVhYWFFR083M29PMDVvaDZqRGFuVHlvbCtvVnNKaW1uYXRB?=
 =?utf-8?B?S1pLMTdhMEZVL2N3MlgyTGQrNm1lamdYeE1VOEhWMmxDekt4OFFVNDg0SGxy?=
 =?utf-8?B?bEZlU3FlaFNrczNWbnlGakR3c1lxV3RoRmVYdForNVM3amlvNDNTQU9sTnNj?=
 =?utf-8?B?Y0lVeEpzOE85cGpCUDZyamRHekxGMFlFcldJSElrRmJ6amhtZFFYenRCS00w?=
 =?utf-8?B?M2htMXYvZWtjSzNwZmNUU2VFUDBhT05POGprZWJnYzg2V1hOaDhPYjMyTnVH?=
 =?utf-8?B?NUtZRVhuTjNSNmVRU3dDNTZVWFJxVDRJUEJOdGNvL0toMlBnN2p5MHlWNnRs?=
 =?utf-8?Q?i4b7Xgfdnfoi5Us/S7j7PQAbabjoLQgvHs0al?=
X-Exchange-RoutingPolicyChecked:
	MW/RebYuuaBGya2H4+ln/XvJqQkMm+wXu7L6YXtSz12ScC3uKFaUSAVOnGewE/lMZIbrmSKaZ8lqbCI9JS0F534+xhiVAlNafNw2Rh4Sk8rgrPx1f2Kt4QgQzsPR2tqAo2KdceXsfc50sW3amiKGF1WLKRikolDYtaPzwvaA+Ax01IeRtI4VYsGdFSQDe9PsOT7pYdCZl6RiA7p1n5YczgiQtVMpqN8vF5TaIZR7apqu+EwTEVuaPu8O4ERo2AWmuNoc9hHyk/jcyh4JHv0t/ttnaDvzETY4qpPmJMg4Q04rLNmAeGOtgkwrwk+iBhJBJ9Unqt5iz6Rz2nBkw+gdJw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BUjzJJ2sTu0WpwgVmePzkDHGaq5KFxxkzJyg+wJgzNmJaEeCewv1DTSwJZSWXX5v91DjDpfk0h237I5q47StQxp8EozCkJwQbb1bmlDS1phjqqOqRnsfjvKjB7zQKOafqIyQZgp0nSnM92hKz+iQ7LIA9jaCoURPynoSJydjP/kkIL/f9v61GxSE+Tvj6PP3G+clhwVicwuHpl8LglBjB/yrAClxGMUu4Hx7oCJoOzIt5pgmzbXcfHMicZkSRDiUITFze36/VGcQspRQaddyou4iSpMiTvWMmPzOXwFSv3jEcpGMHMpkw2wFZWQVbatVmifFvgsU/S/MM3Iz7mOd0UufjVUE7ETM8uWEssDQqqWqpiWLgBXBRXdd89wvWVY9UtNNU9BC4vp5ntUR34JrXuH/pQzCqUaGthfPYOt+sWKDL0vcIJnUS+gdQw8hU1Uw16y/ZaOqTLLjHH0uLjAD6mM1gKZDLo3klQnOA1RXx8TkjANgZ71T73j2uF4EUUqahwZs4w39l+Rhj9wwTyMP5BG5cyRgQA7WlqylEhJW+Uq8RqJJ0+L/LdIjo29orW0MknR+EkMt4nLp+7QyEs4nZ+r3c6f4kJAg0QFxkfl5X6Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df61d319-0176-4d14-4bff-08deef854192
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2026 04:27:54.4866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3ai43g7KVVEIQO5ZldCNOObI+gutQkOOmH5jF2kA6263zexrkiimLhIVKfk4TlgG/T2dUp/mNWMJYkY3iH4bU/4Y+grBy/RHaGJbRPQfTv3dMLrIxycbBQsNZl6aEwOL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6080
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_07,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608010026
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAxMDAyNiBTYWx0ZWRfXzBpbOen3McmB
 KF67/m2Og691xgJ7VQ+yrISK6I2TkA0Bw/gSKDdmfmYX39YbT/MP3WUVAqSwpUkwtDo1LCJXdOX
 ADk9dW3ioyHSnaqdsic68TlCm6N+OH3m2kOKjl+Zn4/fKUDXz6NBtIRvzK6NSQWQXzXg9GU6R8/
 oKyoXHA8Gp6FLkR1MoelemxzY2UO2Dufm+zFuBH6neWz7CnIsnaKfgL+o7zybFp7yIAy/GNISzZ
 yMmH9hShd8dTPq9YOk42Yvqnwi3CnHUdoyUw23UEvZUsblg777IKWtOw069osYyYVbcpwEhPlZC
 WjQKQq68g1hV77EPkRGLeL4HVy4YYjJEESfCBtomDpPIRN6qh4wq6veBF7DYuygcs44CUfsUTVO
 z1Y+p5wsMb5Mp7ZQAC2f1EJzFnwTpJG/TX3vYu1b7ukzFwa5dKy68RiaohoRpJI88E+9dbZOfKd
 ZxpAtsCvgiL1taMUDBA==
X-Proofpoint-ORIG-GUID: 0Xin_rhpQmneFmMxN9xPQRL8dEC-heMy
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAxMDAyNiBTYWx0ZWRfX06BncChFgB/M
 8ahb1OU8/LdSvu/WxMMIMvnfqCJeL33YixjqPOlxlcK4zxrPMt8FvQgrffACgaS6t2pGdSVyY1I
 UgKvpkbFyx2hrh8mIKRmCunxkbqgzWQ4vOIGhO5KaEnX5lyU2pG2
X-Authority-Analysis: v=2.4 cv=ZOTnX37b c=1 sm=1 tr=0 ts=6a6d75ce b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=ag1SF4gXAAAA:8 a=9zp1er7nOwfi_7b1cuwA:9 a=QEXdDO2ut3YA:10
 a=WmVTiCyuxqgg3mnwYu6p:22 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-GUID: 0Xin_rhpQmneFmMxN9xPQRL8dEC-heMy

Hi Greg/Sasha/ and sunrpc maintainers,

On 30/07/26 7:45 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Jeff Layton <jlayton@kernel.org>
> 
> [ Upstream commit 6b3b697d65d46a0f640216a3f6c72856c159c567 ]
> 
> svc_tcp_sendmsg() calls xdr_buf_to_bvec() with the second slot of
> rq_bvec as the start, but doesn't reduce the array length by one, which
> could lead to an array overrun. Also, rq_bvec is always rq_maxpages in
> length, which can be too short in some cases, since the TCP record
> marker consumes a slot.
> 
> Fix both problems by adding a separate bvec array to the svc_sock that
> is specifically for sending. For TCP, make this array one slot longer
> than rq_maxpages, to account for the record marker. For UDP, only
> allocate as large an array as we need since it's limited to 64k of
> payload.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> Reviewed-by: NeilBrown <neil@brown.name>
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> Stable-dep-of: 18c1cc698861 ("SUNRPC: Return an error from xdr_buf_to_bvec() on overflow")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   include/linux/sunrpc/svcsock.h |    3 +++
>   net/sunrpc/svcsock.c           |   37 ++++++++++++++++++++++++++++---------
>   2 files changed, 31 insertions(+), 9 deletions(-)
> 
> --- a/include/linux/sunrpc/svcsock.h
> +++ b/include/linux/sunrpc/svcsock.h
> @@ -26,6 +26,9 @@ struct svc_sock {

> @@ -1423,6 +1433,13 @@ static struct svc_sock *svc_setup_socket
>   	if (!svsk)
>   		return ERR_PTR(-ENOMEM);
>   
> +	svsk->sk_bvec = kcalloc(RPCSVC_MAXPAGES + 1, sizeof(*svsk->sk_bvec),
> +				GFP_KERNEL);
> +	if (!svsk->sk_bvec) {
> +		kfree(svsk);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +


I reviewed the 6.12.y backport of 6b3b697d65d ("sunrpc: allocate a
separate bvec array for socket sends").

The main fix looks correct. In 6.12.y, the TCP send path has room for
RPCSVC_MAXPAGES payload slots plus the record-marker slot, and the UDP
send path still uses SUNRPC_MAX_UDP_SENDPAGES, so the bounds issue
addressed upstream appears fixed.

The only branch difference I noticed is in allocation policy.

Upstream uses svc_sock_sendpages() so that: (downstream 6.12.y doesn't 
have svc_sock_sendpages())

     SOCK_STREAM + SVC_SOCK_TEMPORARY -> maxpages + 1
     permanent SOCK_STREAM            -> no allocation
     SOCK_DGRAM                       -> UDP-specific allocation
     other socket types               -> -EINVAL

The 6.12.y backport instead allocates sk_bvec unconditionally in
svc_setup_socket() with kcalloc(RPCSVC_MAXPAGES + 1, ...), including
for permanent TCP listener sockets.

I do not see a correctness issue here. So I think this looks like an 
acceptable 6.12.y adaptation, even though it does not preserve the exact 
upstream allocation policy.

I don't think there is anything to fix, but would like to double check, 
thoughts ?

Thanks,
Harshit


>   	inet = sock->sk;
>   
>   	if (pmap_register) {
> @@ -1432,6 +1449,7 @@ static struct svc_sock *svc_setup_socket
>   				     inet->sk_protocol,
>   				     ntohs(inet_sk(inet)->inet_sport));
>   		if (err < 0) {
> +			kfree(svsk->sk_bvec);
>   			kfree(svsk);
>   			return ERR_PTR(err);
>   		}
> @@ -1651,5 +1669,6 @@ static void svc_sock_free(struct svc_xpr
>   	if (pfc->va)
>   		__page_frag_cache_drain(virt_to_head_page(pfc->va),
>   					pfc->pagecnt_bias);
> +	kfree(svsk->sk_bvec);
>   	kfree(svsk);
>   }
> 
> 
> 

