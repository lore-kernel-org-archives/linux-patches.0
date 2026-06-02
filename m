Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DAC219303;
	Tue,  2 Jun 2026 13:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780405982; cv=fail; b=T+mWSpBeUNWPlvVCvVjvX0r70fsIQjwPGhIKf+RHJ35x/UWoUbVu7V3oaKEFVG0TQen6hLpXU/5o8+yCckrX0uJPup7FTlZf1maSp1GHDg+K/a5ymJaSyLersmD5A/JksnJSNzZ0snQCSsi0TW/buWXyNwxtFU6i4ciHsCwOZH0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780405982; c=relaxed/simple;
	bh=x/2FZh+nFkm+BzY9+eSKFSGo/OMEseS6PapMV4xxhJU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Z6lrlssuYlQCwU1UnnjWSMqi6NCFTLeDL7xVVcEst296upZRdZNSelHULfKAx1KrWxDU4QxaQu8HcBq2dGRtlcrXlJxjcQ73nA4KDvQjrnYHQsl9TJe/WTI5wtCjlmFL7atNzqMvdvnCAholnhZ1D5pcwPQljo0QFtIOpeId9e8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=i0AM5g5I; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tyLN2W1h; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i0AM5g5I";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tyLN2W1h"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6525tv7U4022205;
	Tue, 2 Jun 2026 13:12:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=j1RSIgP79AQbsm/Dy4g1nhkUGhn/lEJUGHO+696orRI=; b=
	i0AM5g5I4AYgGg5jvxMRfGl1UnikMToEY9bBbm5Tgz/yCmslW2FZG1B43sotTS71
	H3v5YQh5LMxeltciTkzc2PBqsU+Ep0EwHHWAdvnFD0kemnR9UwxSDAM7VIJBrBQz
	+3iCM/zc3OiWoqcKxSkeHLkxvwuu9wzKYCJwMXHYVF5UyiuNI5xKucQ77au39mNf
	8NWGo9dZrQqm8r0TP9bWVKxDEOidy0nR8EZGGWLKCF0y1KGzI822cAhlRtZ1ugv4
	74w/D6Sx5f3GdAiKhXJ1F6r2xOPEXOK+TyCaBjJrgSlciJD/WDUKZf+G/wr/YPnJ
	4gSJPUvNOlFiNmwSR51A5g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efres40gv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 13:12:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 652D0RAD025698;
	Tue, 2 Jun 2026 13:12:45 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013048.outbound.protection.outlook.com [40.93.196.48])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4efpbcmry4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 13:12:45 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k+zEhuKodS0z6BxFbVb7DEVvx0Z+BunNMDwIPv+yezXqws6/zgJCyCHbSIEodD/4wGc21imz7JDWCvXzJgLy2BkXZNnH1ZKCN5aHnDvtNBU1KoInYTSchZv/nQS9BhSQl0h5olzu/TMEN2nQWqa2K6eA7qhIi1Kc1d69Aocc/6yQpmxBNk3kh6iW3jwwm4PThXSvJEPhIordm4FUYamlRBHPDw+M6CH57HqgRYOyvjud8a+BGKLuJ4qWiyY5QImYf8gkfeVir1c+2H8azAD8Wxm1xYuQ+4wdlLh0nz2FsiovUD6jfB39KUgdSJRIxo+OgMatTA5Ibqoj2YtmB94HsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j1RSIgP79AQbsm/Dy4g1nhkUGhn/lEJUGHO+696orRI=;
 b=MkKoJtBNE0qi8iNDnW0ZW+yTjRQ5ru5Y3wNrDWfl1SWJqGRMoiaIKqKFAWc249mLLJCyw4y14HEu2UsKJWfYFhtvBqu/ZyGPk8A2hG9SzUALvlUTkmEBCZyxDKwdc0QyfZPFMNkFMCaWYyC6Vqk/d/E97DxI3DBpJpzhuRkOG6UKnsSCHCmJ7W4tFGvvKq1bY0FCJAHDsC9lqmJZVm/lb5e5n/9xwcLXjF8onM6FSQnpApFykruia9Rigo5p4Jz001JhyjxRAUoaMI3fhO3goPYUjx/Y3rfvgAxMJo6n6K8szpTJW9xa1q+o4UGSI/MtfR2gjoWaYkuBhT5T2XTz6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1RSIgP79AQbsm/Dy4g1nhkUGhn/lEJUGHO+696orRI=;
 b=tyLN2W1hu7uYcZaclgAqYy8qtigtS83Bt7/k43olR40Q+GgtD+dBSjCt4qBM6Z5Irut1q9UQbM0Ze7vAakUdr2zjFYFGaUGPsR7N1YSL9/buLxkWrwe7wo+VFdoftLDgXK4WZwqLOqKqykwjYSGeD6uWQBnfHRuGIm4nLxiJmpc=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by DS7PR10MB5133.namprd10.prod.outlook.com (2603:10b6:5:3a7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Tue, 2 Jun 2026
 13:12:42 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0092.006; Tue, 2 Jun 2026
 13:12:42 +0000
Message-ID: <f2de9bdd-03c3-4a1a-b3e7-b5318dff847c@oracle.com>
Date: Tue, 2 Jun 2026 18:42:36 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 002/570] ip6_tunnel: Fix usage of
 skb_vlan_inet_prepare()
To: Ben Hutchings <benh@debian.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>,
        Alexandr Alexandrov <alexandr.alexandrov@oracle.com>
References: <20260413155830.386096114@linuxfoundation.org>
 <20260413155830.485087556@linuxfoundation.org>
 <68ad88bb-958d-4009-8631-284853ffe1b0@oracle.com>
 <d9c2e8ea23b1919fe663e480cc7def260ed0ee24.camel@debian.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <d9c2e8ea23b1919fe663e480cc7def260ed0ee24.camel@debian.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0093.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cb::12) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|DS7PR10MB5133:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c904b2c-e141-4e69-2401-08dec0a8a0e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	wmQHTjQ32s+SkFKwkzYavWZ+sV0XDxjWACpt3qs+DXxPQFG0isL43ed+LshDE3uF7AsbvJPvw1JtJcxPeCxW5g8KRmFjoWSibDl6EhQe7y81CdWkTM3S//y81+JNF7eG4Q8po1DZxZ/StfNI6p1nOdloTJAnxv5CaUpJ4bIUbgZ7LAdFiMfm1sdoQ+hcCYcxNLBN2bMYNsc+dtWq9kl4qZo7xhdM04FnPIyMU2z7dMtKpFXAnVRp/3aIF8gwd+9+IEfXR3L7ppssXVzpLDdUAhqA2rKxOUMrjQJ3v7P0JVrrbP/ptgb/xUX0LMafvVN0aKKLvb57PmYCK5I9KZ6t9cbpWrCklE5N+lLqzhvLW22AWd8ynCRl6I8QjYU7l2IyfhRSRnqGqHOJ379m+Z2dnTzZvDsicTeUF4r7v+vSRt/gW+zkrxmpiF2SyqhJ7iMMboMEtv8UJ1BIKTWWNcSy7Hafl3ujH39gS996vR7B4TNJsSNswKsO+iYumI4mmRGl4K/1pO+Fm1ujipuE5ZUtqx+nJuspaWkPET65KuAyOY/QYs/ExMjWYYgQHs1e2FK5JwibjUqENBQ/XdqXzkpG0MzRZBxGUTMQdWUBp5WmDDHphixmNeRklFVlFQqVAWAzRL4kl4df3WTbmwE+QaNH8RtCVghhmu/6Zs3gGVlX7VlbGS5PH5kBCWvBNb8iVjuY
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZjFjV1FqSU5xamFBZWlyQmViMmw0Qkt4bUJPUzN5RjAyZ2YxL2tKaXpXUC8y?=
 =?utf-8?B?ZThGemZKMStwdWtQdWpHNDhFMXlzNCtNK3FUYUVuY0Z4NFRsQk9PYzlHcmhx?=
 =?utf-8?B?K3NORzFpZlNLM3lzQnp6M2phRTRsMkxPVG5SZUlFbFpjTVEvWGFWY2I0eXlJ?=
 =?utf-8?B?b1lFdWZIRGo3ODNFY0xFYWhncXIzT2QzSTVBdXFJM2F0dkxCR2lGRmwyY3BU?=
 =?utf-8?B?OCtnVnEzdThBZHFKUlorbWhFdjJ1clU2YjVJamM1d0l4SUZIRWNqZE9nbk5v?=
 =?utf-8?B?UWlDWWt2d3FrNHpsQnd5RWJGTnBVK3V0NmM2clk5YTY5OXNoS1hHbXNSalhw?=
 =?utf-8?B?L0FkMFB6a3ZNWU95dUdWbzAvMzNuaGJQdEFjL3dDbFlrNzk2eHhFSVJBeGRz?=
 =?utf-8?B?bytyVTFML3FtLytBQkFiMWVUd1F0VzJDUVVMOVlEczdOMkt4Wkw3U0tQK21F?=
 =?utf-8?B?VEZmdVJCRzlSa2JkS24vaU1lTDYrSTZYMExNQTJZak5pbkRLWGFrVjBCRjhR?=
 =?utf-8?B?Snk3QnpkanVPV21qcXpweTZuVmp0bGs3ZCs0ZkRzSE1maTRGL1FRbWRCRHNM?=
 =?utf-8?B?T3BQQmo2VDByd1NaUHhUbHlublcvRU1wU3BWRkJuZENaZHg0K2hhNFVIWjZm?=
 =?utf-8?B?d2c4UVBma05ycXppU3pMamp3bERYU1lmZUVURmd5R0FFdjVPMklNNzJQVWxp?=
 =?utf-8?B?a0RWUlBYOTd6MFN5dVB6OWErQjZMTWdzanBidVlJODdMbW9xTktJR2hjNCsv?=
 =?utf-8?B?blpBSlVKZjRHQVJqUWwxb1hhd0VCSGFObCtjSllsNU1vRnZEMzZmMjRCbU55?=
 =?utf-8?B?QnpCNisrNTZuUEh1azFMU3E0bW1Xa2NaQ0RRbkhpNlhhbkMrV2t6ZERrZ2lz?=
 =?utf-8?B?b2JxYmUzSW85N1p1d3BWTGI2K2c0Yk5MQkhjYUdHMVNNUEhTTGlnUm40ajZl?=
 =?utf-8?B?QmNOcnRreVFMUU9FZ3ZmZjl5RllhVGdFMGY4MXdrS3lGbHFpN2tSUHFCb2tl?=
 =?utf-8?B?TnVZY09GeTBaNldyZjBqVG1uWWREdHN1OVEwUmhyc2twZDlEakxQYWxkOHp3?=
 =?utf-8?B?RVREa1czQk5XSDdCSjRtRC9naXg2Z0tycTBrdURMTjNFQzIwOEVkWE0zYmU1?=
 =?utf-8?B?WmlSUmFYTkZQek5FSGczeEZ3RnFrQ3RLVUtLRFdubkk0V0JTeU9WR1RaSUl1?=
 =?utf-8?B?YjRzcDlqbFZ4UTZTdTFQNVV6T1lHNENLQVF3d2p1ZUtnNWo3dE1BVXNYQkxK?=
 =?utf-8?B?NlRTL0VuTU0xOFhuZC9EZVY5RUJkWWZmV2RtdXBXdXBobzN3YnRRYkNTb0R1?=
 =?utf-8?B?bG9yL1RlbmhrUDFqM2U2UVBkKzdqR1Q2ZkJjN3Vnd0dkZ2dleGltVWFaTDJQ?=
 =?utf-8?B?VSt6ZlppSFNhQlhTSDZVZUVxSHlvNE5uL0p3T09VSjFaMzQzWnhrcXVDb3I4?=
 =?utf-8?B?U0U1VjQ3Z05iTy9FOGdjUEVLSEtiekU4dGc0U3RESDZOMm4rYXJpY0tLT1NP?=
 =?utf-8?B?Zi9YVVNnTVQ5Y25lMVNHKytPbTRGb0lhd2EreTJaL1cyb0RwYnBXeGdxR0dP?=
 =?utf-8?B?OFh5U3VZSE5zWlN3eHBwem9UQTQ2dmx5QzZXM01ZZ2xwYTNIb3dtMUQrcHNm?=
 =?utf-8?B?TXM2V2IvSVRSYkJVOEFXVVdmR3RRVjRpN2gxTTJpWjhOZkNIb0Mxc2pMeWVG?=
 =?utf-8?B?MG1iVlhCM0xYbEduRFYyQWI2MzhEUmsrZnBEeHJGV3N6a3JtYjhRWE1pUGNJ?=
 =?utf-8?B?bnEzME1qRXhqZ2ZKU25GekVsWUR1RGMrVSsyV0dLVDBhaDMydFFoMk1XM2Fw?=
 =?utf-8?B?UFJSK096aG84Y2RKRThsUmRzc0dVLzRPaGdpeXpGSFNIM0h6eVd5TnZ2YmJX?=
 =?utf-8?B?V1h3UUs1V3Z1eFVzWitzdmxQbndyWkloemhLRUFRYkk2UEhSd0laOFBUM3ZZ?=
 =?utf-8?B?WS9XVk92Ti94YzcvSkcxUnR4U1RaSXJaM01xVDB0VlZKbFhmS1RxL1F1TU1k?=
 =?utf-8?B?QmtjcmpWTzF0L29SNWhtYTRzQlJSL3h5SzdVR21HS2dzT1hVRndKaEJWRk9k?=
 =?utf-8?B?bUdoR3VHYkZucU1hdUpZK1VPekJlQ1dYYlhFTHJzNWo5VnpPM3lsWGRxQnQ5?=
 =?utf-8?B?VFM5VGpHc3ZsSlA5NTFmZngrNGlXT29TcUNDck5GbFc0dW80dXpralFCeXZR?=
 =?utf-8?B?VmZKQjMwSkZYYitWTDBid3FVZVFPWjFtZG8xYkxERCtDWDBmMDB6eVpaOTNV?=
 =?utf-8?B?LzQya2R1K0lVeFlSNjRBRTcrNlpoaVZLVWRwcFgycEljclNpcWV3RGZDYnBn?=
 =?utf-8?B?eUVjSVp1c25Fb1hnc0tkMUhUaUtQL0Znc0pabG9DbFc3aFJzM2JDT3JrMDk0?=
 =?utf-8?Q?sBy4Rl9mmTzwUqjDao/xZIBYI+H1wz9spBeRk?=
X-Exchange-RoutingPolicyChecked:
	PyatBm4QHBcYwg9f6I6JPttH+OdUSiWOzyrZbZlla8p2FKheYxuuz6O1Bqjr4zwOmcInVjfA8x2nVByyV/IEFTuaN52oMBhK4/c2rLusIGZZaq+W8phStDI0jpUQKp4ukcLhE95iNALVQ0KijePxTwbGDXj0BmnrXxf7nBwcpR8CNw/YkszxUK2+xpS6kzXsfwSjaYqL4xKKBhUJs2gE7TxYlOr2gnCvvwlHe72RUk0BpWbFMBDy7qEelcfV7AcPrJbtp9EVdsFRvwv6MxvZJUGUkTWvMEk7EOijRU3Rj0dlBChVZutH8VTYMx1ST4ijIY6WaIcscLuE+qbrQcpB/A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	B0ldniZBwvzA90mnhRXSDacv2W1D6F6oyMqQS2ynCRCKhvpYn7+Sa/P33oEFNcngNS5OvYhlQSVFpdLLVLnPtOEhUgHbnx3A5mbWURLGlSDspC/gKc30gx5zKlN33OHkTGR/HMywkV9E530OWZ9KrRebH5wvEPCRPP5a17JWEGdgQDj2cU6K/OszwK4150VvJsW6Ap2CdljsdkfExXgCmX4i+R7GtbGupCqrpg5g+4i5oXdK2Em3VJRC5IxKPLO+jx8ucQbzg+rfnSBQH2LUuKsEako3nl1avDTQ+JeE4AbiEhLGUESBMo1WIbzK5RtAPJPS9SfhEGdyk/uEEj8ZgNbSpr6ydK0/8ETp7yvlxe2CShkZHF8wzmRGfBjPXkkwX3DI+0UMnqMEbkix6/9I1+A+A6AKaq1h1Y+gdMA0GvdjUXAvlekqOi1mX8deLK+hqBKSQxbHsj41icP8yajdvnehfkpnBmlp3P1OY6ail5m943zLX8ovld+xi9LlzhbCN4o5iRK/fQ13zIpBaSZ8bPTWlz+73fS+CQLU0mX3a2owMlZBjGG43+ItYZw1HrUnl5Olv2LbU8hzn2v5K+CAQSIh1rnqdkbkHywsnpQ/y+c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c904b2c-e141-4e69-2401-08dec0a8a0e6
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 13:12:42.2259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x3FJoP+TDAHd62Y83wDZzyjO/eefxO586QXasftB7Np65WYiX1kyVnESq6+FlXBHPKxyoHFEPRqeiqJoLog5ROq0FgQq5asPiQuhq69reBJO74hoy72Bvl8N5Cl3+8cY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5133
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-02_02,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=927 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606020125
X-Authority-Analysis: v=2.4 cv=U4Wiy+ru c=1 sm=1 tr=0 ts=6a1ed6ce cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=8T59DR07AAAA:8
 a=faI_pwx1KRfzP4a_yu4A:9 a=QEXdDO2ut3YA:10 a=nH4QB3FtVBqZfhiODIJV:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDEyNiBTYWx0ZWRfXw4UKVDITYCUl
 cPC9TZsEApmqLho/AEQVv0vApzBZnM9UraUcvUBoA1bkKu23/EpGofy8T0Lz9aDV+CdCI2mBR+I
 rA2L2T7JqeqK1/nBM4l2ZirhwLmpVHuNbtuKRqe3Arkg4/+qeeuS8wVRNz1NRpwemj9/4urrkKh
 BFuUCY4f3wgZS/VtPaqaU3pAhOAKwLDQHdLv0/c/dmbKY6ST0KRKiqU5TEjHCbrduPLz6VHdqdO
 Ea6pOyau6eoiDw3v5WUOyJ8zxhA4hzR0tlGdTHpNmKzmQdZOLLqU0m4Knj703Ndy3vZ5XdZ+P3q
 wWRo4V3xCsGrCOSEkNIcK5J5jP3YtqKP2BRfr21aMtF/vLj+z4AKyLzqePqF5ltg4WOpL5E+yhp
 R4g/MFaymsiwDzMoVz620j1/p6bpvfrNdi5uf0Se2z8UeniVWYXDdWDAJEuGAIIXAQwcRYZxHFt
 1acAMIERjdz7m7AY7hw==
X-Proofpoint-ORIG-GUID: A0ZLahQbHrPijRIdS-Xo6iAP6ZnwoRG1
X-Proofpoint-GUID: A0ZLahQbHrPijRIdS-Xo6iAP6ZnwoRG1

Hi Ben,

>>> From: Ben Hutchings <ben@decadent.org.uk>
>>>
>>> Backports of commit 81c734dae203 "ip6_tunnel: use
>>> skb_vlan_inet_prepare() in __ip6_tnl_rcv()" broke IPv6 tunnelling in
>>> stable branches 5.10-6.12 inclusive.  This is because the return value
>>> of skb_vlan_inet_prepare() had the opposite sense (0 for error rather
>>> than for success) before commit 9990ddf47d416 "net: tunnel: make
>>> skb_vlan_inet_prepare() return drop reasons".
>>>
>>> For branches including commit c504e5c2f964 "net: skb: introduce
>>> kfree_skb_reason()" etc. (i.e. 6.1 and newer) it was simple to
>>> backport commit 9990ddf47d416, but for 5.10 and 5.15 that doesn't seem
>>> to be practical.
>>
>> We have seen ltp-net failing after this LTS update on downstream kernel(UEK)
>>
>>     mainline            : v5.17-rc1        - c504e5c2f964 net: skb:
>> introduce kfree_skb_reason()
>>     stable-5.15         : v5.15.58         - 5158e18225c0 net: skb:
>> introduce kfree_skb_reason()
>>
>> So this is not needed for 5.15.y.
> 
> I don't know about that test failure, but your analysis is wrong.  The
> dependency of the original fix was commit 9990ddf47d416 "net: tunnel:
> make skb_vlan_inet_prepare() return drop reasons" which changed the
> sense of skb_vlan_inet_prepare()'s return value and has not been
> backported to 5.15.  That in turn depended on the commit you are looking
> at.

Thanks a lot for explaining, We had 9990ddf47d416  for our kernels hence 
it reasons out why we saw failure after pulling this patch.

Thanks for the help.

> 
>> This needs to be reverted for 5.15.y, looks good for 5.10.y
> [...]
> 
> I started looking at how to fix the regression in 5.10, which does not
> have a backport of commit c504e5c2f964, and did not notice that it had
> been backported to 5.15.  So this patch probably could be reverted and
> replaced with a backport of commit 9990ddf47d416.  But simply reverting
> it would not be correct.
> 

Sure maybe 5.15.y doesn't really have the LTP-net stress problem. I got 
confused with this part of commit message:

"""
 > > For branches including commit c504e5c2f964 "net: skb: introduce
 > > kfree_skb_reason()" etc. (i.e. 6.1 and newer) it was simple to
 > > backport commit 9990ddf47d416, but for 5.10 and 5.15 that doesn't seem
 > > to be practical.

"""

thanks for explaining and sorry for the noise.

Regards,
Harshit
> Ben.
> 

