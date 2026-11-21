Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795277337;
	b=21y2feHuOwtImGiY2Bu0fl7ekJrO3O9q6ogoYaOxa5pjuYNzTXGvcvM+DoU4WukO9vG/
	 w4WH9X5ufEGcowC811s8rigJivTmNNP1eKkRaO2uNfLZpsPJAXoD4nhhEwQQEly2COUU0
	 opX/H1RArSQ+yrVcTzX9JraPFpM3Glu7mPO9J2tyrnqib6i1YHkZ6ywjrTC32gFv53JDQ
	 VP236ny+gyOaWC3oVs2VK9OOOxkYo5SyFHtDtmHfICsBI0HlMbdgcyg3kcnvnPfeQEOMK
	 MDn7ddCNPN6nrG9yevII9W2Ipz8dbffcl61pHETbcECXdiInJv4yA86e8oqL3WlgHZg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795277337;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 DKIM-Signature:Received:Received:Message-ID:Date:User-Agent:Subject:
	 To:Cc:References:From:Content-Language:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info;
	bh=5ExQVh861DHRzsJWqNZXFJ0nXEwaV3UO1SanzmrEz8Y=;
	b=kn4tYkw50xNx9yXk/lz8sukHq77WFEtd6nIN4DEEof5ig/yLxL0Z7VZ1LWUSzIAPdT6V
	 VywZFam4lD4D+5RV98O8VlMWyh+xQ+/WNnO+XbZuGjXlLivMkPO6o8C9anm89iVIsKJJ1
	 uPr+8+WYSkhMASYc2iBVrBSMTMec5hC2OQsR1CEGNvySEZ4FoBR4je8Z8tY/PleK+piuk
	 Bdo6D4jyQKuLJ5e+Bmk3FwCbiVWEmPcZMSZIWE93kW7NQuVVNbodkW7j1LjxCwKlGbek3
	 OonHQakabTirYD6C/YEUQxTrDh5uQ4RZd9AW8dSABFYQoME1OJM87nAu3b5vtMZb7YQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=O+tXZgU3;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=fScC8Z+9;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.177.32
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91272606A32A;
	Sat, 21 Nov 2026 16:08:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91272606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=O+tXZgU3;
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=fScC8Z+9
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALFAwGn2296211;
	Sat, 21 Nov 2026 16:08:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5ExQVh861DHRzsJWqNZXFJ0nXEwaV3UO1SanzmrEz8Y=; b=
	O+tXZgU396EHzhSr1WzOFG5kkQs2uTp6wh90HDMRf37q5dTKdsGUu1PniNiuQn/3
	S2jzO6Rbuni+SZd6bpTXHttqEQdqHItqsGObYdz7+UTL0BD3m2CqolwQTsC6ZFBc
	ZUE0fEURW3f2EG2B+DdomDJD3WEagU/1qWrA3Z2q1uOnJ4Km83O1d/SUz5IdSiV0
	I3R9In/dQ9AaFIFuLLlCANayp1qwKojc8tDJV5+DAQ9iH++GMySNwgU4LZ/5e+L/
	dqeEusyDLSFWYgNstOkeC6kSu3qoHxAm3rqkCDjUDydhGEo9J0airdnPenwdc9KP
	MgU6oA1k935OSpWPXzsBew==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j34t508w7-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Sat, 21 Nov 2026 16:08:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALFXVaM2902467;
	Sat, 21 Nov 2026 16:08:44 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011039.outbound.protection.outlook.com [52.101.62.39])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4j38wf5b8m-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Sat, 21 Nov 2026 16:08:43 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JzUqAKEpVqIR0unGNr7WFF1t2Fx+DOYqm2XC90ZciE6RZ7r5dwdmY3lcVbQDlR43636m+Rj+52Zic7wqd38nlUfRcPxqfohYP1fs5bAGwLzAvFFe31Oos28iOXcT0nmnIl30FZA28ecCW/RnZakwLutsz+/CnYnPFj3swJ+1W/HavFiUoFXO+HfNzH6Ej0xs0XXhgcntZxUiuRC4I5g58aN/IMFTqCCzIsAKNAkbeyQD72A+3xWrAFjP/k1amapNeUfeuiyNzVNUvCsgmtbVOuOry3lF/YBvHSep4JJUuUiInlfESIXiYeTb+v89NIuPrUGxWKwT1HoYVy4UWtgaOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ExQVh861DHRzsJWqNZXFJ0nXEwaV3UO1SanzmrEz8Y=;
 b=iWdZGMd+jwm7U5udb9evCb89Y34PaXqIDM5G/BRhIqzZDx48NJl3svM6XZSPaZVhPytFVRIwsqdPwFhZcpa+WVmDKJG2c4TGIb+PJQ9k6WVOk3ks6LFTyFOZKp+oYh+sH2DbNkrqUfH0OaA57IQjegT/iw4CSSNig0XyTD43LJQ1gV3wlc+YZ39yDbpHZ2RNjLdPxw1vmtc/aKwputx+sJPhMP6FOPynsoVSCpz+WCW0l+e2V2vA3LTP8ncXAYW/9lXxMOAd+b5kHJMx0OewHNJAA0DYUBn0TU+KmuQnej6wB5MobhOPNMl6RgtvR0dLEr5Llpv/jt1rS9QeOPaiDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ExQVh861DHRzsJWqNZXFJ0nXEwaV3UO1SanzmrEz8Y=;
 b=fScC8Z+9bEyvvgH9Tx8KhS9sejaUjrHuYPMoUbS1nVDHErSK39pmWCjFbHT5yxd3HXn2v6ePQ6oXB3UaNHZnzCdd5hB+xSzICtI88/psBtOS91WfiqmgQ+PnN7XJgSzyXHeedtW2HBt4+FLB3KF7OXpxa+9BNULtgFkgJ/qq3Oc=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by PH7PR10MB6580.namprd10.prod.outlook.com (2603:10b6:510:207::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Sat, 21 Nov
 2026 16:08:40 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Sat, 21 Nov 2026
 16:08:38 +0000
Message-ID: <0da409e5-d7dd-4f46-a88d-d33ef17ed32a@oracle.com>
Date: Sat, 21 Nov 2026 21:38:32 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 1832/2214] rtc: abx80x: properly handle shared IRQs
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Antoni Pokusinski <apokusinski01@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
References: <20261118150009.797899913@linuxfoundation.org>
 <20261118150124.719256585@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150124.719256585@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0142.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1b9::17) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|PH7PR10MB6580:EE_
X-MS-Office365-Filtering-Correlation-Id: 721025bb-9d33-4b6b-6780-08df47e9b3d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|5023799004|4143699003|261021123027099003|261102123227099003|10067099003|261022105027099003|261021121427099003|261026140227099003|56012099006|261026121527099003|261009223027099003|261028144727099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	Nwgzn6ekarqBN8BgXVqNuWxUmfTzXjXGb/Q2kSokQiQmlXM5JlrGqaA6E+/fbOGCcrTTXpjRFZZhjUHpWMYvermTUC0et4RGIv4NJV7x9GypHhfGqDvSjvy7hqyOfho6bW7VwtW1k+A0W4+byX9/QoZSb6jRf9w7UCD6xoYITtS1HvrFmXBCEl5/jz9jGERAhU/R1sOxp/gqj8GW8X0iMFPKFOJBdbZBPiTOMz9z4d0Kxwpp9bRhMR9vZ6kyR8hFfeAKyTGt4Rmsyuo4jg0Bh3Xjejs2MVh1ut5+TV/BT4vbXwX1/xOwzXcD3YsHEqUZfsGs3yW12j3bEklbXlYIMkhflOqQbxmtsVCKjGxqTOeUTl2Yg5jpIeo3rvhrlvRuFPzkgsIMg75VjCyUzOtG+xMBm1PPCLMjmte1jN9C0iopg1kHfZM+tzZvqzsvoNu6HR/AGiu9rvBHZNFCp57x4K+OoTRnbfQYij5x32cyiFhT/oHCaaCJDQ7t1VGDEGnzykQ/XfL6l5agVcDQKWxEpEI/x7yd+gX0C+P00h+5vGJVIAxU6fU585/1a0x3G6PbOk5COVYu8XtnzP4dGA9MFMmbIWGffDT31uHi08REXE6WlVlj5CUOTLjBax5AB5ys
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(5023799004)(4143699003)(261021123027099003)(261102123227099003)(10067099003)(261022105027099003)(261021121427099003)(261026140227099003)(56012099006)(261026121527099003)(261009223027099003)(261028144727099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Tld1S1JYZXdNUVB0OHN5T3Y2dlNzRXp1L21McHlqdUoyZE43UFJ3VW9sdUp0?=
 =?utf-8?B?MFlnS2x0TEd1MGVFbzIxRkpldHU0azVwYldCcFBRb0tUMDhJSlpjVFhyT1VF?=
 =?utf-8?B?WDJIa1ZPekRKK3VvV2dtMVByNGt3SzJmZ09kTDJqb245dVBhYXBwNWJ0NlZs?=
 =?utf-8?B?bGdneDZtMjViQVEyUUgyYzA4bjBWS0h6RytBN1dCQXJPazY5U2k4TTJmWkYz?=
 =?utf-8?B?dGtxYklXS2VYZ1c5YjFLaVZBNU5yOTZWanMxTFZSWkEwd0pNRW56YlZxQzd4?=
 =?utf-8?B?UDFxamtERmNBbytxT2xyTUVzSUN5aFlTY29uRFpnNWh6enZ4SmpTVzZreTVV?=
 =?utf-8?B?dnRoSWVNSkRNeUlOT3VpTGF2SXhSSGVnTkVrK3QzK3lvN3VEanczTVI1VGNl?=
 =?utf-8?B?UnQwRGZxOGlUYmoweGllL29nenRlaWpzakVFbzJpZzc5WFBVMGZUMUpqSk55?=
 =?utf-8?B?UytORFM1M2MvaE9LckxDSkNzVkxnOFMwMzM4ZFJTelpqRGtXb0RHanZvK1or?=
 =?utf-8?B?MHZSQndCZmFVdXh5SUNxeXM5VC9OZ0RyeUdRWHE5QzFFMWMzRFZ2WkhaTHVa?=
 =?utf-8?B?dzZQRXdKc3pCMm5LbURSYnlNTGVMbW80Q3V6VVp1RDRCb3M2L25CTUxmU1BQ?=
 =?utf-8?B?RUp6c1EydXdjQjFueWcybHBEemZnY2hXUCtRSU1GZlc0MEVYWmRvb1dLb0tT?=
 =?utf-8?B?QXBGaWZFck1ZeVRhTXFDTHoyN2NQMzgxNEdJYkh5dXVCaExKZlhGMGRVdGhh?=
 =?utf-8?B?Q3dCMWtFaGkvcm9FWm9TSmgvajlOMGlsS3hFb1BHZ3k3L2ROazlqNkZmWFFF?=
 =?utf-8?B?RmpuOGZsUVh6RHhRcEM3a1pGd1NWdVdoV29pdDVEM1ltaVhyRnIxdk0zb1Vs?=
 =?utf-8?B?eUJjQ09DUWtUUjlac3NuZ1ZKVEdsbDFUMFJNbU5jOS9EYURNbkxKcUlLaVlp?=
 =?utf-8?B?dzBCSnU2L2ZWWGdmeXIzN3dFNHFsNytsQ2ZDTUl0bVRBSDNiamMrb2xNZFVN?=
 =?utf-8?B?Y0d5cUtkdnRIVEtXUUpFY05HZDJLT2tzSTdqeFpqVEE0MDZrNmYvUDQvNytz?=
 =?utf-8?B?c1MxZk16T0FmVmJHQjZ3eGRQaHNQU1RpZWJKNFdDUW5QQ1lBWWZLUG9ZWnRp?=
 =?utf-8?B?cmFieE5lWEVsRDl0N053R2I3Z3cxYzFhL3RPNU1PUHJBUCtzRmZOYmJ0VHhw?=
 =?utf-8?B?L25zamVuR3lKUG9Hc2NQMW55Wm9nNytnTHdCOHV2a3VNOU0weDVqYkNrN0dm?=
 =?utf-8?B?Z0ZNM0NRVlZnNkxxZUJQQjRGTlZudi8rSDJ4dlArS1ZrcjVESTdUY2JLZlFX?=
 =?utf-8?B?alR1TEhVNXlrdktjTUlVMFpCWlNUL1JuZ1FuQUY5NVJncXZRUjkvQ0Z4YXB0?=
 =?utf-8?B?Y0tURzlYVVM3Qm9BRVY5bGNoR2Y2bzdad0FkTWtCRjdsRzNHUjJHT0JmUFo1?=
 =?utf-8?B?M0ZDamFsU3JjdzNadmVsYWFiOEFHajhVWktQd0Z4YWFScXJZWkwvL21PRjlx?=
 =?utf-8?B?aTBvR0FkVnRSVlFFWHBTcDcrVDVZWnhwdi9ZUWFiejdHdW9vaEhIejdGekRs?=
 =?utf-8?B?UG5IVGY5TGxoSlZBc2kwZXhOMWlleWRKMVUzWVZoa01XdE84Wmt0WEdHS3Ez?=
 =?utf-8?B?RnZKNHdreDluUXB0aVNnNVhiSHRMTndkWjJBQ1BRNkZ5aGNQdklYVVJFaHVq?=
 =?utf-8?B?bWYreWR4aUx4amtxdVZGQzE1WDYzMUVJZ3REaWNMdVprRmNkQkgxYjdGYnNJ?=
 =?utf-8?B?THFQekpyRnlrcmIvTzIrR01EMEMwbUtSazQxZ2IwN3BZdUZKTWtQS1FFWTlL?=
 =?utf-8?B?dFd1M2tON2tDY1B5bkhHeXIvUW5jK2hIUU9Zb0ZnVVkxcjhIQWNYRmxNTjJn?=
 =?utf-8?B?ZVdvbEk1YjZpd0daYjJHOStaMXJVSW5BR1ZJcWZLWUUvdUxZVVQ5V1hnRnN0?=
 =?utf-8?B?UjhtUDFRbm5CUXBjSTc5MTNWRDNtQWhyWVJnZXM5V0toUUIvU3RIbWp6dE96?=
 =?utf-8?B?VFBUaXlNUGpxQjlSQWwxdXpsT3cwSlV4aXRiRjh6Mm5kRGlldmI4QnQ3NjNV?=
 =?utf-8?B?SGNFNXdpT1E4OTBMdytPS0ZhZEN2bFZucFF6aTZyUmVHNkhOQStKY1ltTHpC?=
 =?utf-8?B?L0lsTWNTSTNGWG1XRCtQTkZPRlFYS0tzZTdySTJVOUdDU0FEMStDVnRmTm5F?=
 =?utf-8?B?L1FKTTlFdVczVUdPNEZLQ21aZWFyYzdwalBFNTF4YUZZVDdWMkVWVzl6djlQ?=
 =?utf-8?B?ckU4cU9CZ1RnOXFXU1AweG80RnBZOVZPQXpubStNQkpZM2U3c3JFSWRMNFdT?=
 =?utf-8?B?UUdEcDJhQTVrSDhtZ3NFeHFXZndYWkh6UG1LZk1iN291VkRiVis3WVJMdG1p?=
 =?utf-8?Q?jer6aT1KGl2SJyFTIuQKv9IN1Ya1PB3RiVfTi?=
X-Exchange-RoutingPolicyChecked:
	H0W0ubGGS+6i9LcC4cwR18WqPr0l3mmd2prmmy2TvDBknEUa/E7/YZwgfMiFT7stKe+Fh9HnTJ09Gqg/ZLzorJMqaDQXSFurzbEvvN7LqcnsF5ZGan52nzreTQfIO1VE815JXgnyvjT0/YXhH2clfim7FV6md9JPDd8S6Ymqr3ypWL1PUObP4/svSOpKi19NofQNZv9dBGDdFb85pvPC5/eyoyfsex3b0W5mYPNapjRvLA8XxHoAynldqfYn/HldHhi14YEC7vXhhHv7Y0AwlifMyVyMPrL3oO3An0f4z8YBr8skI+R47uPJxmUYmf5JdNZiSe3yFemAn7WzO8cUaw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	boV7Q5t4vKMNkLrcxFMdUH+Eh4Tq4dbtrmU4Y/ndIq962UNNXU63gjCdDg1C6QjS4e+LgfCnJttE8rV7b2TYNn7Vn0HfLT6HU0UHxtoB7clbLF4ryDfqRjghMxOSSS5Jmm1C0CZhrAV3VLDlhhDyHZOSEASaz/I2p5WsXepWfxoGcoI5FVybo4eYaxKTv6CLnI4ixv8dmbABfPh+194kZYWVWar0XBYK3wkKol41FvVQvSYyLwosrQmnmOygvok4WCyLlgtvur7Y3pH92oafcrRUVzLO5tQaIRteZUVCsavyLgJuZ4jA0tNKNMIuM7q4+sjM80EHnrJzFamDXQkKLkjLF8MssAUzfjKlbddx8laB32FZcvT/MNK59pIFLQ6hdezQps9q9uBEtJ8ul1Oiz+NNxojfSU6ZrRGtaT/XU6OinSgZzMQphIzglG6ohrPKhsL9ampm5sdBn+2k50hwJFziaCbADXmbYI4QQubumbCngnql5pkJVFn0y7cBzNVwXN3rDIQZFn3yvIpSYanm3BUwxQzWgNQzKFl3oDIaTy35ERgp4Bdoh9NTJ2zsa7iKcrdNAZcsEFeHaVsC+qIrsCqSJ621qjz2hTRnOsXvghw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 721025bb-9d33-4b6b-6780-08df47e9b3d9
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2026 16:08:38.2605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O5u4/ooBA+kMB/zQLlfreuZtDA8lvKwCEt6vbmC8jLZGYDmdER8uPb+rm0PLHNc8QGZLxwPw76nAiWzldkUlMuzC4F8cjwyBhpkJRGvTBpPXvI16E+UICTFXrvQ1hY7p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6580
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-21_04,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 suspectscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0
 adultscore=0 phishscore=0 mlxlogscore=957 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2611040001 definitions=main-2611210064
X-Authority-Analysis: v=2.4 cv=dJIzC+Zb c=1 sm=1 tr=0 ts=6b01c20c b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=bC-a23v3AAAA:8
 a=pGLkceISAAAA:8 a=P-IC7800AAAA:8 a=VwQbUJbxAAAA:8 a=tJYfMFUQkaZNqJ9XZScA:9
 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22 a=d3PnA9EDa4IxuAV0gXij:22
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12101
X-Proofpoint-GUID: cLcyngLJCbEnTTL_KfyxIKYrLSwpKaCo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIxMDA2NCBTYWx0ZWRfXybiofJlMYsib
 6MWyzbTPdw1ixQbtaPsoChboyA9UDOYyh/HzjGkI54a6sXMY4uEozFomnOr/JmPKJoSkJjbKoj5
 OJtjeiKJwOgx+vSUg/JEwVNr+RCOYKW7bdTdbyl5976lxsbKiT0aFlvgHkCNWo7IEurtFMEYmvM
 RyUovN9buQscBzuZzMHdb05k8vDelVxBBPGI0JO9vOQmdI79Yzv198kEp/k7Wqew7HXuAdN2PqW
 woeOrJc7No68/DelJu/uxUgfRUH8NtKrwMrS7JzhG3x1MgqK3vOp/VVsRwRybJ9MO9qPWGCGPr2
 f8NfK8RcS9BBriNV2CrNJmWZ5Oiw9uRIgZIzSrtaN1/WaG2fQt33cfsGuy2kBU/QDLNJrQ0K+zZ
 e05DJUN9p9WSggsnUUH7DJNRzHgI3bOGx6aLuz1/cD4ODd8JQ0ySW75CQ8Fe3jrdYiV6OdKMm5Z
 kRpWi9ZMA3Omm+q6t0k7uKAnj50pOmFwfeX7PwcI=
X-Proofpoint-ORIG-GUID: cLcyngLJCbEnTTL_KfyxIKYrLSwpKaCo
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIxMDA2NCBTYWx0ZWRfX9m8UiDVt+lF2
 jaZl7pIPMbezcI1tEYIrhU11MjA8rDW/mywoHQP9bfe0MQMu549I3MKOPhT1keBhTBLsdErZsuw
 fUCRLtBjud15X35988NDolLWea87iuVMt5SJju2X5uVcA9T+3nlr

Hi Greg/Sasha,

On 18/11/26 8:28 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Antoni Pokusinski <apokusinski01@gmail.com>
> 
> [ Upstream commit 632916c7bde35495f2f6776d8e335c3ec6e306ec ]
> 
> The abx80x RTC driver registers its interrupt handler with IRQF_SHARED,
> but the handler always returned IRQ_HANDLED and cleared the status
> register even when no interrupt source from the RTC was active.
> 
> This could cause the driver to claim interrupts belonging to other
> devices sharing the same IRQ line and could also clear unrelated status
> bits in the RTC status register.
> 
> Only handle the interrupt when the alarm or watchdog flags are set, and
> clear only those interrupt status bits that were handled. Return
> IRQ_NONE when the interrupt was not generated by the RTC.
> 
> Fixes: 718a820a303c ("rtc: abx80x: add alarm support")
> Signed-off-by: Antoni Pokusinski <apokusinski01@gmail.com>
> Link: https://patch.msgid.link/20260916205138.16771-5-apokusinski01@gmail.com
> Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/rtc/rtc-abx80x.c | 52 ++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 50 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-abx80x.c b/drivers/rtc/rtc-abx80x.c
> index 6b3a47c6d0108..08c5adcc8a5e2 100644
> --- a/drivers/rtc/rtc-abx80x.c
> +++ b/drivers/rtc/rtc-abx80x.c
> @@ -48,12 +48,18 @@
>   #define ABX8XX_CTRL2_RSVD	BIT(5)
>   
>   #define ABX8XX_REG_IRQ		0x12
> +#define ABX8XX_IRQ_EX1E		BIT(0)
> +#define ABX8XX_IRQ_EX2E		BIT(1)
>   #define ABX8XX_IRQ_AIE		BIT(2)
> +#define ABX8XX_IRQ_TIE		BIT(3)
> +#define ABX8XX_IRQ_BLIE		BIT(4)
>   #define ABX8XX_IRQ_IM_1_4	(0x3 << 5)
>   
>   #define ABX8XX_REG_CD_TIMER_CTL	0x18
>   
>   #define ABX8XX_REG_OSC		0x1c
> +#define ABX8XX_OSC_ACIE		BIT(0)
> +#define ABX8XX_OSC_OFIE		BIT(1)
>   #define ABX8XX_OSC_FOS		BIT(3)
>   #define ABX8XX_OSC_BOS		BIT(4)
>   #define ABX8XX_OSC_ACAL_512	BIT(5)
> @@ -249,6 +255,7 @@ static irqreturn_t abx80x_handle_irq(int irq, void *dev_id)
>   	struct i2c_client *client = dev_id;
>   	struct abx80x_priv *priv = i2c_get_clientdata(client);
>   	struct rtc_device *rtc = priv->rtc;
> +	unsigned int status_flags_clear;
>   	int status;
>   
>   	status = i2c_smbus_read_byte_data(client, ABX8XX_REG_STATUS);
> @@ -265,9 +272,15 @@ static irqreturn_t abx80x_handle_irq(int irq, void *dev_id)
>   	if (status & ABX8XX_STATUS_WDT)
>   		dev_alert(&client->dev, "watchdog timeout interrupt.\n");
>   
> -	i2c_smbus_write_byte_data(client, ABX8XX_REG_STATUS, 0);
> +	status_flags_clear = status & (ABX8XX_STATUS_AF | ABX8XX_STATUS_WDT);
>   
> -	return IRQ_HANDLED;
> +	if (status_flags_clear) {
> +		i2c_smbus_write_byte_data(client, ABX8XX_REG_STATUS,
> +					  status & ~status_flags_clear);
> +		return IRQ_HANDLED;
> +	}
> +
> +	return IRQ_NONE;


I ran an AI-assisted backport review, and the finding looks correct to me.

In 5.15.226-rc1, this makes the alarm IRQ write back status bits
from an earlier read without locking against RTC_VL_CLR. It can restore
a battery-low flag that the ioctl just cleared.

In rtc-abx80x.c, abx80x_handle_irq() now clears only AF and WDT,
preserving the other bits from its earlier status read: (Code spacing
adjusted.)

     status_flags_clear = status & (ABX8XX_STATUS_AF |
         ABX8XX_STATUS_WDT);

     if (status_flags_clear) {
         i2c_smbus_write_byte_data(client, ABX8XX_REG_STATUS,
                       status & ~status_flags_clear);

If RTC_VL_CLR clears BLF between that read and write, the IRQ writes the
old BLF value back. Software can set this flag according to the AB18XX
guide, section 5.3.1. The old IRQ wrote zero, so this lost clear is new.

Upstream (632916c7bde3) serializes the two operations. Its IRQ takes:

     guard(mutex)(&priv->lock);

And its ioctl handles RTC_VL_CLR under the same mutex:

     case RTC_VL_CLR:
         scoped_guard(mutex, &priv->lock) {
             status = i2c_smbus_read_byte_data(client,
                 ABX8XX_REG_STATUS);

The 5.15 paths have neither lock.

Maybe we should pull in commit: 74bff654a4ce ("rtc:
abx80x: add mutex protection for register writes").

Thanks,
Harshit
>   }
>   
>   static int abx80x_read_alarm(struct device *dev, struct rtc_wkalrm *t)
> @@ -821,6 +834,41 @@ static int abx80x_probe(struct i2c_client *client,
>   
>   	i2c_set_clientdata(client, priv);
>   
> +	/* Disable unused interrupts */
> +	data = i2c_smbus_read_byte_data(client, ABX8XX_REG_IRQ);
> +	if (data < 0) {
> +		dev_err(&client->dev, "Unable to read irq register\n");
> +		return -EIO;
> +	}
> +
> +	err = i2c_smbus_write_byte_data(client, ABX8XX_REG_IRQ,
> +					data & ~(ABX8XX_IRQ_EX1E |
> +						 ABX8XX_IRQ_EX2E |
> +						 ABX8XX_IRQ_TIE |
> +						 ABX8XX_IRQ_BLIE));
> +	if (err < 0) {
> +		dev_err(&client->dev, "Unable to write irq register\n");
> +		return -EIO;
> +	}
> +
> +	data = i2c_smbus_read_byte_data(client, ABX8XX_REG_OSC);
> +	if (data < 0) {
> +		dev_err(&client->dev, "Unable to read Oscillator Control register\n");
> +		return -EIO;
> +	}
> +
> +	/* Unlock write access to Oscillator Control Register */
> +	if (abx80x_write_config_key(client, ABX8XX_CFG_KEY_OSC) < 0)
> +		return -EIO;
> +
> +	err = i2c_smbus_write_byte_data(client, ABX8XX_REG_OSC,
> +					data & ~(ABX8XX_OSC_ACIE |
> +						 ABX8XX_OSC_OFIE));
> +	if (err < 0) {
> +		dev_err(&client->dev, "Unable to write Oscillator Control register\n");
> +		return -EIO;
> +	}
> +
>   	if (abx80x_caps[part].has_wdog) {
>   		err = abx80x_setup_watchdog(priv);
>   		if (err)

