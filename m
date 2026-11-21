Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795270084;
	b=C7iSOXr5ecXUB5LUmXfCDg857Zm6UOCIQ0lZKcCiS8bgag0k0YWjf0z0XXpC3VN51kXP
	 rDmAWRFkW5xn6FEYbD+oW+Usf94L2tBF3uUHZd/ietjGQaQU6XeAZNzV3FwnVzp04iMWR
	 +/tCQR5UomASe5AcfSW2C8MMZGAvNAncF/rGPMtDPplsr4TWhDZ7a6Dqt7VfcweQIpFsg
	 DZ82XyD42NwAQfhacPD6nvdZrfaU8TbLIWiqlp6Klk4ls2JWRIMhHo8WaLmLrbvlekqBt
	 aKkrWacM9HOw3uGAnQqA7EcX0MHBOA2tSSReDKfPNrJHpHoE/9b3TMHP84fvtiP/wIw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795270084;
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
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID;
	bh=fELYv/1Gpcxv3KYF7p/uWrxteKXr45//Cub9JidYzF4=;
	b=t9YKfGdzOA0BtePuSXYPoVaphhv2AtfTFhMRRsDj/eBo3UyfclTyPEECccPEJV9vgNBy
	 oschZ15+ihpyz02OLvrF289PEG+WcMXla8tcdvji5aVn/sLb2DLTKk6n43F6ORcQPcy2S
	 ODYqsoervuCVbzQqcXqqMKWtsan8yUvXrkKlgo3m7PMm0kUGbLLzlNOCaDcvhiobdMbkZ
	 tg5wXsKnBpD8DE6yEamwkGDmdaemEDHRt99vybniLDv0TU6eK2wIv2uIy4hdy74+xo47w
	 UNOmWz58OAZwozS6oXA/tycTQTkCLsfuMMVKO9u/oPlkrP80TfdRLbot/S5fotyD/KQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=LfWolqPa;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=NMVX0TcY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED68606A320;
	Sat, 21 Nov 2026 14:08:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DED68606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=LfWolqPa;
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=NMVX0TcY
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALDA99q3424808;
	Sat, 21 Nov 2026 14:07:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=fELYv/1Gpcxv3KYF7p/uWrxteKXr45//Cub9JidYzF4=; b=
	LfWolqPaiWtJrauP5YjF94XU982CZ7LzO2y2Ndi3p51t3PneYsw1zRzNXb2gw9Gl
	GuVf54bW5501VmNwotX6S9yC8ICGAUNNnmCNoxbZjrNMNWQu3jVAzJkVdapEY/ar
	gqP9YmQUxzlYOOEbEfdq6wh3RMVH2xGpVJXhbT3znU6lskeq3DhjmWPmxJDV1YyJ
	lceJ7IMpi7JxY9AeqUGRfCgv8C7nTx2vUiB+iQ6Me3Ss5ixb2uj0wbnAueA2ou3X
	mvQUwRZB7Gsofr9X+JJhHMxP+yPlMJqjhI1mQa8YcIOySpgko5iukFuS6rNkgz8J
	o/+sVsgImCiiwM1jIlpw8A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j34t1g777-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Sat, 21 Nov 2026 14:07:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6ALCHsRT252362;
	Sat, 21 Nov 2026 14:07:38 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010003.outbound.protection.outlook.com [52.101.46.3])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4j38rfky2f-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Sat, 21 Nov 2026 14:07:38 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xojdazjh1lJm1H3uoNYrvgphcaYByKuTxLha2nTB7yXt2usa4hywokn+jmO635WKSoivQppvEFqyNYXw0qwlg21VQVqogu+EJSsF7O8QQbgMDugSKVrFnUGQaWolu9MEhuNFBx3KxC0t98+2cu34mOAsslu/sD16tdxdu4nd897GxZPOo2BCOmCqlwl80WGkjfQvaKAdhh1MXxHpbhtf102AqlqUReqG4lkYlXpVKnOIl8y425Hf1Rm40mWVunubLurrHHE/g5+sgaZ7hVTNwAkIvUsgRLpIl7lhBAGGFcJFHXejE46gdn5GJIVafIuX6tMILmdHcj0DNXvi4G2owQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fELYv/1Gpcxv3KYF7p/uWrxteKXr45//Cub9JidYzF4=;
 b=i9QdoQDsksvw9HupWodRNM4NqUxt3k/LofpletT1akQu60/tF6JFZlWeLyi09EwyySgItVbtli37LD0qAS0eVxBnGb0HrHOnmMn4oaF5Uc60N0fNmuvV8TJwBK7f/TqPBdB6fj+xHO4CNygdzj+G101qiibEkZ/WEX2MIcUWjANmsQUVsF217XLFU3W8GyBLwf5WP/YO32q6nhjX1j+u3QjJthlTielKldBoq4Y/uiKQnqcorRLZQpnDC9q/Q740UtgAxM2kXAZxYS6DCpHXVqOJzFiegOspQKzUw63Yf40eUTMAWDFBa55Oq7zsTFY2e9r6yu55SoqPMXYZT2f6Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fELYv/1Gpcxv3KYF7p/uWrxteKXr45//Cub9JidYzF4=;
 b=NMVX0TcY0RzNhqKQ+0EipKhdCj6dcXIkZHOV+XH1aeMYd6IACmR8kiI68hCnO4iyjiMTETlNnRHNHqSnq9QRxSpUTo/LP4rguD41Z4mw8YSRR1hWo2Ss6PIhac4t8YhdGlcn3U1EB+WapTmr+UHoEgEvEkrX+vUC9mOxP3nVnEE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by PH7PR10MB6251.namprd10.prod.outlook.com (2603:10b6:510:211::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Sat, 21 Nov
 2026 14:07:36 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%6]) with mapi id 15.21.0615.009; Sat, 21 Nov 2026
 14:07:36 +0000
Message-ID: <a57865f9-15ff-4fa3-ace4-0b384f53cee3@oracle.com>
Date: Sat, 21 Nov 2026 19:37:28 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 1081/2214] wifi: brcmfmac: cfg80211: Report
 port_authorized for 4-way HS offload
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Janne Grunau <j@jannau.net>,
        Neal Gompa <neal@gompa.dev>,
        Arend van Spriel
 <arend.vanspriel@broadcom.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
References: <20261118150009.797899913@linuxfoundation.org>
 <20261118150055.486581750@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20261118150055.486581750@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0305.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f6::14) To SJ0PR10MB5834.namprd10.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|PH7PR10MB6251:EE_
X-MS-Office365-Filtering-Correlation-Id: 812cf65f-f0c8-4946-5ccc-08df47d8cb3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|18002099003|22082099003|5023799004|56012099006|4143699003|261026140227099003|261026121527099003|261022105027099003|261022075727099003|261009223027099003|261028144727099003|261102123227099003|261021121427099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	AAPJN5/gRD9bj6PAOZR7WPluFEi5YLxxZGJ+C429+jHpYXSdzMewIbOTq5UHr/imFsTSgK45Ytp8LW8nQiYxUHIkTTw6HfM338b4MDQ8PuTmAdszJBvUXKlupm7Ixw5UXDxrIOAPFch0tzvHj9xVN9mGmDROly3boIc9RzvxH9yjaRVlzQN2IS1Zrxi6isgKiiD4ZFfqW9hopP22xgB2w21/85zcFn/3XgRBnmomRaFv9pSlv5Hd/pvrYtcGtT4M1O5t7cW5g9J4PS8riEG9PjPpWYpxopcl8S5V63SvgKzSijtZRVcAtCPZzYCTcGIgVhVGkEipS5IYjZg4deRFsMBYgjNLBhU12r8RXG+YTJv+XEKcLpq7mCcgr+faCLLQlgyRJcJs1pv6t4tAxHk5HbZTFV2BFxLGTaSiG8Q5WY8eF5IeVlUOCEJoFoh1h3M5PVWQGT6nscfEwRIXmJXW8FOsgJSsJckjkzY1i2aNdmiP6If55zchSobfm4+Y01oD/zBNsGK8G+vNc/Bb7U2XeHcZrSwCNxOQWM785wgstsoswiHapuWL/VdVImWjqCUND7x+6nEU205nmxSS4qAUkGjyx82e3EZizacfW29qNr6rMKi1dioBeWmOEeVyzHSS
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(18002099003)(22082099003)(5023799004)(56012099006)(4143699003)(261026140227099003)(261026121527099003)(261022105027099003)(261022075727099003)(261009223027099003)(261028144727099003)(261102123227099003)(261021121427099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NlJpWXBlbDRYUDVDTExQSjExdUVqZ1EvUWRPSjVlUXJjZE9sT3duYXdhMTVP?=
 =?utf-8?B?RGs3MFViMlBLdHVGdEY0ZEtLSDBpUDMraUN1NUU5a2t2a2dOV05KMDE5U0V3?=
 =?utf-8?B?VkMwd0VmSk5Ub2dCbFpWVjNPVDNkU3NmUDZ0R2ZJVXlrdWdqenBaOTdaZlJV?=
 =?utf-8?B?NTFvNGhSWmlPYmVYeUhhb2ZZbXhrWTlFRG82WE9QK2VqTVZJNXhudG5ORGdK?=
 =?utf-8?B?YStMa2QweXhjY1JpbzFZbjljMjBWc2dsWmRVQjFBOGsvN0hWK0NDcHljK3V2?=
 =?utf-8?B?aFhTME5HVmt1ZjNpNERSa0VqTEMwVWE5VXRlRGFLbTV6TEc4K0QreWJ6U0JJ?=
 =?utf-8?B?WTZCeEtSQTZsRm5Ta1B3M3l3aVRUWDBJcG9LbFNMNnBrczAva2VJNXUyTW5q?=
 =?utf-8?B?VS9aajdSQjdmMFFhTWJxRzhsVGNVTWpPZFlFbXhENXJPanMydmROdFhTSUlB?=
 =?utf-8?B?NlhMM09NY0dZZkhRZUpwNW5hdnltanZrWmNGa2g1MUx3cXhLWWtCRVJxaGxO?=
 =?utf-8?B?NjJPMXp0bWNkSW9JMVZoREVkVzdRYU02aUxXSEozS3oyWXhIWWVHUlJuVVpr?=
 =?utf-8?B?NDhsdGdFWkVLSHc2TUEycndQWUVQSXcyNHN4UkZUbldBbk9OQjdWeXNMMmh3?=
 =?utf-8?B?dDhBNlJJKzNxcDZLODhERUtIcm5najRjL3FPQjVRRTMwNWw2Q21wSDZCQkNO?=
 =?utf-8?B?OEZacDNYSDBhekFJM3QvZzZRYnYrSUF2N25mQlJxYSt2YUFtYU9FU1lOS1hY?=
 =?utf-8?B?Vnp6MlFJQWZZbElqT280VFowV01YNnZpcExkSW9Kakdyd0NyekRtRXFBRGlk?=
 =?utf-8?B?U2trQmkzanYzSC9yaGlnOUVjb1kvT0ZpY0J3RDFPcTdRZFBFYkJzOW1rZFNv?=
 =?utf-8?B?dEszSmk0WDdLNkFGbFl6VDdJeUljTFhZZFlZZXIwWVREWHovN2lRdmJmdllN?=
 =?utf-8?B?cnY4TnJ5d1YzbUhRMFdxVk5tcC9PanpFTVFuaXJxcXdOS2RxMDFDYTlsNkRC?=
 =?utf-8?B?L2VyaFhrVHlmeGFvV0tNM2ZmWHdRM1JlVVlVTm1yLysyUlV3TjZOZXRpdUJk?=
 =?utf-8?B?ellHQkpjc0t1b0o3ejB3T2tKLy9jd05oZElFRldRYXlFeXdwWjhMMWhkWUZM?=
 =?utf-8?B?K1BJNjd5Qy96RkJyT2FKSzFrNFREMHlOTm9aUCs3cTRvSjU2MVRUSFg4NUxZ?=
 =?utf-8?B?VUZoSENLRjlud3Y2blh1UzZBbkx4bDlkazJTUVUzcldBY2VhYnowZWhDa0dW?=
 =?utf-8?B?VVZYeWU5V1lJWUJMRmFKQzFxVWJsaXprV0hjY3lPQjVSbG03OGNuY3RMTFZu?=
 =?utf-8?B?ZUlJcVlOVWtpaEJ1MUVHU0pZWU5qWUJCUjFYdHRlYlVDb1ZubzlyeFNJZzcx?=
 =?utf-8?B?eHVudHk0RllURm5JcDJrTWx3UGoxMC8ydjQ4ODBDZjRtUFd2TUJPb2t6Mjk4?=
 =?utf-8?B?aCtnVHBLbFBUbU1mYlRZeDNZZEdwdFI5RW1iNEN5R2tNU3FLYzlzYnRpNmpZ?=
 =?utf-8?B?ZzdLY1M4Z0pDNllmTmJTa1UvZHZEbEgvMW9ENEtjVGNDYld2dXdwWnUrNTNX?=
 =?utf-8?B?SERiOEQ4NzJkWnpUVzdaSlV1TzVNajNZL1JkRG80NjhHN0hKbkZEZ0FkT1JB?=
 =?utf-8?B?QUtFNTBlM1daMmh5NlVYalJwdm9zcjFSRGJKZXNzSGFadHNGMmtmZERRRk9K?=
 =?utf-8?B?Y1c5MHJhRHVvRUJLZUQ5OGRENzdpZGFDcW5JZlRSNHFoMlZydlFpV0RZM1k4?=
 =?utf-8?B?TnRWM29CV0RneVpaT2gyRmRNRUd1SUlZM09hdkJVS2tuS2plZGh1ZFVjQ0Fm?=
 =?utf-8?B?cys0bFp4eFg4b3R2Ums4ZHlzZWdHTFJUaEQxTnBoaElEbnNQYmRWM3hxdkxt?=
 =?utf-8?B?dUFSbWhZNHRYRW8rNCs1ZkFReW9jSTVnZ2oxYjFuZEFLcjdkK2d6MWJpQ0VD?=
 =?utf-8?B?VzdDdit0cU5xUWdGVDhCcmlCdUtlT1JyOEF1ZDN6VW9ad3NXd1lkVnNZaFli?=
 =?utf-8?B?UFF5NDdTQVR5UWltQjFVS05vZVJjdDc1SXZNQWxiNmVrSzgyN1JTNytlcUNX?=
 =?utf-8?B?eG84U2dVRmRwRXM4c3pPd2Z6RENtV0M1UW91SFpFS2J1Rkp2N3NpVGtsL3BM?=
 =?utf-8?B?TVFDZ0VSU0lBS29nWDJWMHBDemhNenVFSXNDczVscS9vQmtCYUdNYkpyS3Yw?=
 =?utf-8?B?TnBKTXdvdTdCcmdvMXlFR3FNeG4weWJVTm1sam5McWhVNnhBZW9qaGYzbSt4?=
 =?utf-8?B?bURrOHlSdEo4bllsWkFCQlQreWxieEtaMG9lM3FLN3hkQU1DT2t3dTlUWU9C?=
 =?utf-8?B?SmlubFBxdU1XT04yK3k4NFlEMTdEVlNVQ2NwSHlYMWw5MktPS3BzYVYweGl5?=
 =?utf-8?Q?emsDHroOzfj+a2kf3ETBdqXa7rFgm8eGNbMsD?=
X-Exchange-RoutingPolicyChecked:
	iPQaHR2QdFqMzcZ7wAstAJ+I8iiTi4npWmAUO9b90sHMssayJHWxRxHuh2YFw3Dv6VhdnXcaqpgkWJtEppoQuGrPen4DRdlU8T9Y0MdfgFUHrMd1dvNO1U1knhrr7jc7+3+e3I760P54NSFGm7uYHlqCez7aTwi3p5qNhT6mdY4WrCczBxacmNcTRokaqt+I44qLqsBTRAV50NACVltX64wwKOtMuiCajXU2o+4N1JWsCA11FQiDjZ3YIXoI7B9IVUx+IQIQHw/CNgWucThEf6Dex9EtlkBNUfzinNtxstRQwd37SlNiZb0G33GhZwTxyncQS86DU3yhXJUYp/k+0g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tg2T5cqilrRN16w9d+KdNOTl9UK+nIt8e5XZV6z4QuuG6gKH0D9/jNkFzcEwOPZaAGyFEp7HgxZ50ZE+I6wWawyVE7caL6xcOnSv8EQyMNdLCS07xfJxcuofE1CW5IisbqY/YCjO2gRA2npNUBqmoAb9R5rhdKW7A5YpmLyHJuUvTsIiKzD1a6HHjBWa9L4GOt0SKsZWTCDHmK4KRo3DSoJVls1xQTKLt1YzpaGZbngNkow1AHzbSnR8MYYbgtzvFcEpJgTuiOcWDXIKcMRazlMT9cYetdUX393SXxu22FHibHneR9Zsbaso98Q1bAPCREBmuUp/m5xtKCFu7frvsoAy014v6Sim9UB1ePBj7cqgEfy/5oHIGnBDWnrnZ3VH41wqS0tvC1r1IocNYTHwF8tYvfrXUlGCPfCQ8v1cMMuBnKXZLfBVsjoF6+qehcHD4MkOW0OZKtsL4s/BoeBaPOgvD2MiaDQqGvqFN9a4Z/wqF/gcUr5tbBDKkTI3lM87yazisG2oVRM5WrFZmIkeNoSdJg9aYf9b4EsZ3pRuUMb8WPN7GYWi/ac5J0zO7NkQIPU1oAcWRXlzCLF1z7CVJ2YeYSPtDSsXeMRDmdm6wWc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 812cf65f-f0c8-4946-5ccc-08df47d8cb3e
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2026 14:07:36.0490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nNnpqfxpp+en+N2/pWxnI2lHiz2ckOCD81emHA4Rlne1xzABUgi1YezfjtXTipCyoAn4xU5RkbbgBik51cBTZKLTThPSaGS7uT2nNzIOvPgaDjwd6kJ2P45/ThD9c+2w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6251
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-21_03,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 adultscore=0
 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611210055
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIxMDA1NiBTYWx0ZWRfXxIsCjM1HHZvB
 /H845/W54FMTwhgVnqz/f61YIc/5/qx5kQK/W+xzI84pWu4Et4zrzOMNhnE6UWRwcOtNbeP57pZ
 /82Pil9O4Lv6teI+RRlUXYRGXZLHSXy6/lWcAw1I6xTk3uAxx9x+
X-Proofpoint-ORIG-GUID: lc-jrw2uK_FSS2o0H1cSKYE80sw9C_lO
X-Authority-Analysis: v=2.4 cv=ePaGH3p1 c=1 sm=1 tr=0 ts=6b01a5ab cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=NEAV23lmAAAA:8
 a=JfrnYn6hAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=bUQKSiCPAAAA:8
 a=bC-a23v3AAAA:8 a=dOLNmq4gAAAA:8 a=Q-fNiiVtAAAA:8 a=QyXUC8HyAAAA:8
 a=B2pxrF5tvMyMegfq4b0A:9 a=QEXdDO2ut3YA:10 a=1CNFftbPRP8L7MoqJWF3:22
 a=-fHZXUhsFbuwFN3fwQAr:22 a=FO4_E8m0qiDe52t0p3_H:22 a=_m6CO-mWuQdSFutSHjXj:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIxMDA1NiBTYWx0ZWRfX/SKm6YUKvCGp
 Sipz7w3YU3wUY1f4Zxpv+C+tESNnDz+9O5K7XysocPssY9heAootV3r0dLqS68SQ26pPTlfx+TJ
 0lqH1Cjlg9sIxgybf97DnPPqJ8EYfoKrKx8Qal64ZWC1U3w4hde2Sui+e0dcwgnhG4pjZEvNw9p
 tZ5f8cK3O+Y6yaWhhuZMtj/nE90ffGihZ309MYiPKvvwLo2W15bL/9bssl9SGeZhAUVSTmdzIog
 i3R++9PjUsXxBpPKBGPFtVGwUOBKAj6ezxrQTPSWgyh0QtgeHBfb+Q6jIbg4uMwTC48fddT46kB
 MGxayX3Nqld/556inZltUHHn03x6DVEswfz2iT8QTyggI2lKxWBlS3ScfNwmCAHa8SCctbyZD0Y
 eigPFdCY1ssI9mXIIKRphPz6preW6V+Ty3MOxuAbg0AijIqcuSI6ssI4OgJK03l1Cqgzc3JpE+0
 sj1Myia3PpRGX1/8Pfg==
X-Proofpoint-GUID: lc-jrw2uK_FSS2o0H1cSKYE80sw9C_lO

Hi Greg/Sasha,

On 18/11/26 8:15 pm, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Janne Grunau <j@jannau.net>
> 
> [ Upstream commit 6fff9de5c5b425817588eeed42bd56d665751c13 ]
> 
> Since commit 416386060 ("Mark authorization completed on driver
> indication during 4-way HS offload") [0] wpa_supplicant expects
> NL80211_CMD_PORT_AUTHORIZED to complete the authentication when the
> driver supports 4-way handshake offload.
> This was apparently never tested with the upstream brcmfmac driver as it
> does not report this. This broke authentication on Apple silicon devices
> (BRCM4378, BRMC4387, BRMC4388) and other devices when wpa_supplicant
> 2.11 was released [1]. This was initially dealt with by reverting the
> commit in Fedora [2] and other Linux distributions.
> Instead of carrying the revert over to wpa_supplicant 2.12 add the
> expected NL80211_CMD_PORT_AUTHORIZED when the connection is established.
> 
> The "Fixes:" tag is not fully accurate as this has only became an issue
> after userspace changes years after the change. Since the change is
> expected to be required in all active stable branches for wpa_supplicant
> 2.11 / 2.12 compatibility it is helpful even though
> BRCMF_PROFILE_FWSUP_SAE did not exists then.
> 
> Link: https://github.com/zephyrproject-rtos/hostap/commit/41638606054a09867fe3f9a2b5523aa4678cbfa5 [0]
> Link: https://lists.infradead.org/pipermail/hostap/2024-August/042893.html [1]
> Link: https://bugzilla.redhat.com/show_bug.cgi?id=2302577 [2]
> Link: https://lore.kernel.org/linux-wireless/20260911065656.1269623-5-Jason.Huang2@infineon.com/ [3]
> Cc: stable@vger.kernel.org
> Fixes: b8a64f0e96c2 ("brcmfmac: support 4-way handshake offloading for WPA/WPA2-PSK")
> Signed-off-by: Janne Grunau <j@jannau.net>
> Reviewed-by: Neal Gompa <neal@gompa.dev>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Link: https://patch.msgid.link/20260915-brcmfmac-4way-handshake-offload-authenticated-event-v2-1-fbb9cc7ac177@jannau.net
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> [ sashal: replaced the authorization helper with an inline PSK/SAE check using the three-argument cfg80211_port_authorized() API ]
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index 13ea5f0c8e1e1..aec1c0b9ef08c 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -6029,6 +6029,7 @@ brcmf_bss_connect_done(struct brcmf_cfg80211_info *cfg,
>   	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
>   	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg);
>   	struct cfg80211_connect_resp_params conn_params;
> +	bool authorized;
>   
>   	brcmf_dbg(TRACE, "Enter\n");
>   
> @@ -6049,7 +6050,12 @@ brcmf_bss_connect_done(struct brcmf_cfg80211_info *cfg,
>   		conn_params.req_ie_len = conn_info->req_ie_len;
>   		conn_params.resp_ie = conn_info->resp_ie;
>   		conn_params.resp_ie_len = conn_info->resp_ie_len;
> +		authorized = completed &&
> +			     (profile->use_fwsup == BRCMF_PROFILE_FWSUP_SAE ||
> +			      profile->use_fwsup == BRCMF_PROFILE_FWSUP_PSK);
>   		cfg80211_connect_done(ndev, &conn_params, GFP_KERNEL);
> +		if (authorized)
> +			cfg80211_port_authorized(ndev, profile->bssid, GFP_KERNEL);



I ran an AI-assisted backport review, and the finding looks correct to me.

In 5.15.226-rc1, this backport adds a port-authorization callback for
PSK/SAE offload, but the helper rejects P2P_CLIENT interfaces. A
successful P2P connection can therefore warn and lose its notification.

net/wireless/sme.c

5.15, cfg80211_port_authorized():

     if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
         return;

Upstream (6fff9de5c5b4), __cfg80211_port_authorized():

     if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION &&
         wdev->iftype != NL80211_IFTYPE_P2P_CLIENT &&
         wdev->iftype != NL80211_IFTYPE_AP &&
         wdev->iftype != NL80211_IFTYPE_P2P_GO))
         return;

For P2P_CLIENT, the destination warns and returns before sending the
authorization notification. This call is new in the backport, so it
needs the matching interface support from upstream.

I suggest: Include 8d70f33ed720 ("wifi: cfg80211: Allow P2P client
interface to indicate port authorization") before adding this callback.

Thanks,
Harshit

>   		brcmf_dbg(CONN, "Report connect result - connection %s\n",
>   			  completed ? "succeeded" : "failed");
>   	}

