Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC5F187579
	for <patches@lists.linux.dev>; Mon, 17 Jun 2024 06:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718604805; cv=fail; b=WAvErNG6CXZTH82gtWz82rjWuIhhG0czTubHDpel23BMBVdk6Z/nWQiSjfnxgm0VdufO8dbXrDKaU5LMFSNMFxRk+/nupCjwgehB2SFscz6WH9TjrkQygIun7FxXyX2RB4XF4lP/cN0WaeFWDI7YtVo9ZOLKdT3gtAo9KSTBQHE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718604805; c=relaxed/simple;
	bh=kRrzg9cbizgLQpmB3RGf1OOMpNyFqJF39xfIPawQI3I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Pktauwh2v+/EONUTelmiiIaa/RUI8jsmIHn4QZ90w/rYBiEoBdtGzVq9VYpEkYqTla9o6KPFTtNIBb25RazkmYNuzsg1sCOAGsKtxG1lAmVmNVjwmke/EJ+VuGs8WS4MvqigrHCsQ/GalsIDOM4AbxvZYLq+mzlZyXrzXRhHz2I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UKJgCzp0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=j/oWOemz; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UKJgCzp0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="j/oWOemz"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45GMK2Iu006201;
	Mon, 17 Jun 2024 06:13:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=mEEo5pBQJeoN80Y0sOyRKVblr1zr4DUP6qG4/wHox6w=; b=
	UKJgCzp0TJMW8QBl4KDwq8xCW6h8uHb6iws/SZg8ZG5++zi6rg91Qe201PlAfRX5
	yGGaG7Vg6T0XNJbH/2Zkq7SSG4ckidmSLhy+bhxLbbUTJQVQkl6+Od/dTbaNus7i
	gbHsaw9HoseBWo1EW0p2b9kzWuV4UVZXkUmLc6eT7IYSS8VUps0Fum0G9K8vws/Y
	yNyhnKCyTM3M0lLjSPgBd+V7st+SnqEKj9FY/ZMOX8PEl3cJ9UkcY2DuW38nG9OG
	PEhZpYHcvIByKyobXybZ+rC2r2JLI9igaYGTdVZFAQPruk4VtkI4g6WYRtMFhSjv
	J9exBqD6dR6MAvUBKqgPPg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ys30bhwax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Jun 2024 06:12:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45H5hENu032918;
	Mon, 17 Jun 2024 06:12:59 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1d61m4n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Jun 2024 06:12:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gRVVsWFYM6me3ybREX0vQck+1xGqJ8mHrkd32z1CSXvEMqFBcFonV2Le9udoR5VXZgHGxgBnXx33IZqR7cff9ogi5hrTZKMhFP+u/nehaWWVOrOjJPRdNYL8I971POngqwLV5bjT8BPaXZHC7HFlDF7Mo6RqKE91jGPfNLbizZD7iM5lAPosDrgV8IWx9iE8jVwvi6JbL8IMffg02rY43eKbyniCORSETpDiUhLg+hNuAO0SUPMnOC690KZfoHTw6X9N23jYNbmHpoWxF2LrdSVcm9YPi7mk+aEqgr4cZJpmO+6fS9YDdX7RRu6fx4wG949/5JtGgPmsk/GMTDMSmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mEEo5pBQJeoN80Y0sOyRKVblr1zr4DUP6qG4/wHox6w=;
 b=ca7qNctxy9mTquR8y6tavnnuDohPNCLNeVx0ETy6hgdo1OMUWZrHm3dJWTU/pMK/6cBfwwWvaRJL7y3GAknAI/lWZ/Er6UV9nClisaqE33Exvk++k3a0EpKyWyJU2BcZ4MK5NVKu3Nngn2O7BtT1C2pVRw+x9OkCrhGw/elD45UTtnzpGiRGxaNOOsnp6L5YRFyJ0dD5IV6K+yvQPnR3gkpDIXk15aus9OumUhEUn+sEu7Gwm7de80ARffstpvTp7KwwI8kxjVfe8GuJ8v6xoTlL9VEDr9UZg+EDmDIoQlKrNALUtCs31a1NjhcHhSOgl2bjcm/S48jSQO0xDipV7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mEEo5pBQJeoN80Y0sOyRKVblr1zr4DUP6qG4/wHox6w=;
 b=j/oWOemz+i+P/oa1vf32panjQRs4bb2XS+f0CdzBMECEg5mlto+F2rGnNgj+QDqvGYTnoubmApPVv+MEQOWw1wlPwcv8Wz3R0ge8UviFPaA9suelMsX4A/6qqo9c6FLYKvrqqHUw+vG0IY6mPOCqfonU3SH5cTKuaa4ZQWMJv2M=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Mon, 17 Jun
 2024 06:12:56 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%6]) with mapi id 15.20.7677.029; Mon, 17 Jun 2024
 06:12:56 +0000
Message-ID: <2f84b5d0-39d6-40b3-a706-1bc55686fb37@oracle.com>
Date: Mon, 17 Jun 2024 11:42:45 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/402] 5.15.161-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20240613113302.116811394@linuxfoundation.org>
 <866c06f9-7981-4f76-88c9-930068cb6c21@gmail.com>
 <2024061620-snowfield-renovator-a9bd@gregkh>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <2024061620-snowfield-renovator-a9bd@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0010.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::12) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|CH3PR10MB7329:EE_
X-MS-Office365-Filtering-Correlation-Id: 63786057-284a-47d2-3780-08dc8e9487ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|376011|7416011|1800799021;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?dE8rS2NVUkVjZVBycG5lNWRWVWdRSWtoRDcwd0hxTHpNa2NTb010RVBraVF6?=
 =?utf-8?B?N2ZYMWtnQWJGSExBLzlySGVURm5DL3JTTkZvblk3SGV2QjZSb2FXSkU5K2Np?=
 =?utf-8?B?bkY1VFJNeTJGS1M4Tm1FK09VS01uZEdjZGtoSmUvek8yYkVFOGw4SGhmZTRE?=
 =?utf-8?B?Slp4Zlc3S2wybzJYTGZoRkU2Q3NzWmJjRjdUb3AvTjNoMXJIYmtwZEw1M1lE?=
 =?utf-8?B?MUtvQ3U1T0c0dlMyUUhoMzN5emwrcko4aGl0TjNlZ1VCdngzeHhWaFVBaFlU?=
 =?utf-8?B?Rlp2TXRxL1FvOTg4d3JYSXNESTg1NEZockx3MmE5UTFqaE5rVlJZZmMwMjVQ?=
 =?utf-8?B?TkhubVJnVFpyNVB0ZGJ6Y0ZTZjc3czFZSm1QaXJEWi8vbVNFTjZvUlp1bGFk?=
 =?utf-8?B?azVJa0hRbXg3eVVsV3NyY0RIYVd4QjJzSGZaQSt5c3E1VkJvV2FxL0V6ZnRq?=
 =?utf-8?B?TFpwV3ljV01FZGQvUzN6a0ZIQUNUaWpsZzBaS0pHcmNQZzVKbnVhZ0ZCZkhr?=
 =?utf-8?B?eFdhM2xTZkl3S1Bja2VQRytWd2hibHVZQnZjaUZabG1kK2ZqSDJTN3RxNlRS?=
 =?utf-8?B?aG9kN0Y0YlBqUHFhWHZ6Vjh5dXhXdWJlZ1hDMS83Qk1lbmw3aERvS3lNcFow?=
 =?utf-8?B?YmZPemNNOXMzNjNDbWhZZVFNUDZTYzhEMk5yTlBTajVXVi83eHFSbjNITHpw?=
 =?utf-8?B?V01kdTdZY3d5SzhhWXVYeFZxQjZrdkRhaE5samJpKyszaFBud3hBMHQ4eGJF?=
 =?utf-8?B?WXd3dk5LdXJaYXBwc1JzaXFmaEdMLzh1QnFsK1FHKzJpL2RSaldoODlucXp6?=
 =?utf-8?B?ckd6UEFjUVVKRHdzNTlSQWd4SXVveWZsRjV6Zlo2RHVnWldNVVpNeC9ONUhZ?=
 =?utf-8?B?YTJlYlNWU2N0Sm1aSmg1RHYza3lCYzY3dThUU2tvVGVqM0dUNEk3ZFpTU2d2?=
 =?utf-8?B?MjFsZFhhbkdQdmUrZkR0RzJxSU1haVJiVXp2YTZRbXFJaFZNa0Vsc0lObjg3?=
 =?utf-8?B?Wklrbnd3WExTMjkyZGJIWDB2NlB6aGNqRTUyM0dmdE5WRzY0bnljQnIxeHYx?=
 =?utf-8?B?V0lPVUxuQXBGQ1U2Q2lZZVJibHZBSE9RYzVWVnA5UTlWbTFxOGFFNnE5NzBj?=
 =?utf-8?B?Y3MvNXNkZVE4NkpIQmFsS0dRdkFFNGFFVno4U3lEWVFtb1JJUDY1bWNaTHZI?=
 =?utf-8?B?ODhuWjFHSitYMldsSEtvZitadks1T0IzRnZXQW1IUmlJWkJpWCtXU2dzZmZ2?=
 =?utf-8?B?QURFZFQvR1pLNlgvYTIzaXVpbFRaQkRTbUJBZTdKdUFpSmZhUS9Fc0tXT01v?=
 =?utf-8?B?ZHBBVnZXNTJRemM1RytXSzZid242VkRHeit4NXFMellRbjBuekdoakczL0th?=
 =?utf-8?B?QnN4eUNlWDdHOGI3bjA4UjNza3ltQmUydHRkOFhlVnptV0FMSk1ucEF5cFhj?=
 =?utf-8?B?eXM4YlpoZTk4ZjMzb1FqOGt0a1NpeExVSFpYL2MzR2JPZzhWV01ZY0VMdlJT?=
 =?utf-8?B?b09PdXZlakpGS2gyMGk1QnRHS3pvdWI2MDhtbGJQcGNVbUptZmNSNHBGajVK?=
 =?utf-8?B?ZzBQRTRaMmdLZmNscWJ6ekhxbk9MSHMyaStNYmpOUElENW5hUUhNa1pkcDRu?=
 =?utf-8?B?T1NaNGpMSjF0R1cxeTFQVnA3REN2cmZkcWN5NE12SmNvOUsxUk96b3pXQmda?=
 =?utf-8?Q?J7pF3mrqIIu7l3Cu7OPT?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(7416011)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?RzlCZk9jMzhTemM3a2d6Vko3cEtIZlR5YkI2WnlFSnBscE9YQktMS2VSWXBR?=
 =?utf-8?B?dTlQOUJRT2lMVTVFMEJRY3lEYjh4dGlQWGMwRnVIZWtuZHZab2lpdkkyZW43?=
 =?utf-8?B?NDFQMEpDRFVHd3FybXlhTWtxWG1YNjdsalNPMklaTExkeCt6bmZOVzFhOE5M?=
 =?utf-8?B?b25weTlqclhkbXMyYmVnWUU2bFk5RkxqTk9Sb0xhQi8rSG9tWnkxcDZEQ3lN?=
 =?utf-8?B?MWVjODdTamtyT3lIMDZnWWQwYUpNbXczUTZlcWQ0U2RNRFRFUFQyNC9TTC9D?=
 =?utf-8?B?TC80U0RVZVhhTkVlTy9xWVNUTG10Nm93MWhsUXZoYmdFaFdYUi9zQTNOTFM0?=
 =?utf-8?B?emhaaVRVdTM2aTNPRW9RR24wTFZUS0I2ZmZ1d0RBSjJHMGFEeDBCTGxsdXZj?=
 =?utf-8?B?amVvWi90YkJvQnBFM3A3MWxxNXpmMDcxZ0pIOXhOWmFyY3dDUFpGd1FRZFk1?=
 =?utf-8?B?UWt5cXE4VktQK3BlZXIydWExZVBKcTFlUHBqUk80cnhGbFBLMTExNld5Nzdq?=
 =?utf-8?B?RHpoUld3blRZeTBlSkVhbUYyZEpsdC9wb1JYOGhGc1Nvb1dnc1pzQkhIRTJo?=
 =?utf-8?B?RHB6MkVwYVYvVGlObllOdGlKKzh3dzJHM1JuUVk4UHVObEtHMGtQc2IvKzI4?=
 =?utf-8?B?eG1aVGx6ekFmNmo1SGdUM3FwYkRXbCtXZG0rNmZTeWdOMlJrbFVucW1QOGtj?=
 =?utf-8?B?N2VTeW9ZUk83OVJCTFVCWTZLWCtiLzRFeXB6dWdWWjhXVE80b0FkN3VhbVM4?=
 =?utf-8?B?Zk1PZjFTUE4zSDV6Q3VLdldqZmpETE1pZFQxZDdaZS9hSTM1TU14NURqMUNH?=
 =?utf-8?B?RVdINkRtaWdLNVZZR1NnejBPczhpTUFxc2N4Q1cyM1FmcHlNakxQMmsrbzNr?=
 =?utf-8?B?OEl3cE5aMmpoWEFYWHFaOGJFL3RWQ3RZdWJFK0Y3SlEvTmVSTzR5Nlc3K3Jh?=
 =?utf-8?B?ZER3TDFNVnBjQWxLT0NXZ294MVBvMU5lSU15STltVElVQTNvVGJmNzZPSXdw?=
 =?utf-8?B?cnpoakVNOVd5M083eldIMmNmT2xOZlRQMFBHL2FpcFBvb0N4aWtmMGNqT0JC?=
 =?utf-8?B?M1N2U2dwMjcvSDNuN1ZLQ2FoUnlaMFY0RzNtL1F1M1VzRmp4UFZqN1NIaEJU?=
 =?utf-8?B?VEdNUmUzM2JEODkyZ2dLNFBPYVQ3MmlxZ3RsOTdFcGJqYkR5NjUwZjdTM1kv?=
 =?utf-8?B?NWpKbXdoYXdBZVFNYy94QkNHZzZaclVCeW1QYzFlNk9OMXZOT2dKOHdTclEy?=
 =?utf-8?B?R3hjbVNQWW9zeWo2WUpMSElLaEE5MEdTM01kK3VlR045R1RlQk1idTdmUHBl?=
 =?utf-8?B?VG9yVnBOTFFZanZEZ0hVK0pGTVpHN0doRithVStrbG1ST05XTmVvRWgvdG1D?=
 =?utf-8?B?amVRNWpyOElGeFgzMXVTK2tIZnJXTzhRYXpWZVE3ZndHMHg0YURZdlIrZFE4?=
 =?utf-8?B?Z1JGOThVdGdLM3RsTlB5ZnN4U1VjWjNydU1zUTg2cmpTMUtkR0E4enVuUVkw?=
 =?utf-8?B?Z25DZUdjeU15U0xpTVNUNmJydFB3b2RvdzVUWTVZK2tLNFZPL1RvQm1hOFFn?=
 =?utf-8?B?akJyWG5yZWE5UFNPSy9QOXRyMmNWd29NYUJJWlBlcWVQVVBzSU4xdXRCTXpN?=
 =?utf-8?B?RWJGNGFFUXZMMEFWTzhKdGY5NWdsTncvWW9BWjRxNWJtdnpkNUppWUN5K2Vx?=
 =?utf-8?B?RFF5b0hkTUUrQWVzN3o0THh5R2NscTl4U0FEZmtmelkxRnVXTUxibC90WkhI?=
 =?utf-8?B?bXJuakU1RkYxOWJvV3U4c0F6NHFVMFgxOEJ4QWU4Y2dkUjQrNExYQjBFMHV4?=
 =?utf-8?B?S2lGYVVuWjAzeFNZNk5XWGtVT1NzZmFpYXRhcHZJNlBpbEh0ei9MNlU3RHNi?=
 =?utf-8?B?NjE5eGg3Z2NjbVlFTWwyNXJSWHdoeklGcjFMYnNGL1ZKR3hnSUhaVlJPMTVZ?=
 =?utf-8?B?ZWRaNGZwRC9qYndBTjJBSlR3dEhXUjRuMFk4dWJDenlDcjZVQTdXeGppR3pS?=
 =?utf-8?B?ckY1NmNGNE5xV1ZIMUhxbURhellNcHZZWFp5dDBMUHBLT3ZOVFJoTXFoT3R4?=
 =?utf-8?B?U2VkMVBWdFVKU09kUThQMG95TklHYnJlclRoMkpDL3YwSlZXV0g3dVdwZnF4?=
 =?utf-8?B?RjRPeWpweWp4d0lLcm5abHdQVjNHZG4vNS8rYnNuQzJaTjgrVUVDZ2pMSXE4?=
 =?utf-8?Q?+nzwBx7hkMKEfjDNgfsMWaQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ExpRP45Y8YImr+4pCh9QIW7ohvu0udEEgMzzhNSvIcYpIcobQhh+rOlI4zcsfVeDKp3P7m3lKWe6HncNyogIFMfuhsMPrbFr8D5B95fOW0zcZ1ra2OSgPab6e8Olsc74Bsi3Y38511Gvc+IFF4cO+h7Bxk3joI8ZgQVu3zLj59qUY8j8jjKHzwgNHjuRYgntXAE0GmplYQ09B6wj+Lzl8CHq1rwFPOKjbqLfOZbGX2ux1C1pRNU9IWnQKK11Ey41pZ/Z63O/gJvf5paYxwUlBI3H++5BbxowvKozglN+ITnx7x3ptADSDCCo81CIz9R5/YjvkkZj1m7dp4VZVk5I//wCVZMoAkTkvkibLp6R+k27fOSNJL23A85YZTh3qriWJkHYbjpZkWBvUNhZPtD6GfpW+DymP1F5OBhJC3nT/AWbO/BACppa1u+s0x/7+YB/7Y4qqEMW/pGJBu/aD14Jsh33Q496JoOZvK3NKyQKxHr4eayvoPq6Mp8GHc4ejNqsuPw/xxulEX8jLTeRW5IxdeD2My07QWuBh01tkbzUOsS37CCj1KcxlFRmSwXgZa3QAMfZq/l6bI8+9Kr++CeVQ6pEXu50SlP46jdr/mCG6b4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63786057-284a-47d2-3780-08dc8e9487ac
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2024 06:12:56.5030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fychBT2zQdHss+J2LjTPRdoieBWf5X1aKob1EkbPzR9WyKJN6KwlFi0kLXfSY4ofcmSIwj9tjtLpdJ9MYoWHVdB9NjNij6PplnZi9EYdOWwvXoHu3mcBHrGSSasQHm3p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7329
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-17_05,2024-06-14_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406170045
X-Proofpoint-GUID: lE56AHE4_oE3aMMpDppll308RqiOuDZi
X-Proofpoint-ORIG-GUID: lE56AHE4_oE3aMMpDppll308RqiOuDZi

Hi Greg,


On 16/06/24 19:58, Greg Kroah-Hartman wrote:
> On Sun, Jun 16, 2024 at 01:56:17PM +0100, Florian Fainelli wrote:
>>
>>
>> On 6/13/2024 12:29 PM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.15.161 release.
>>> There are 402 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.161-rc1.gz
>>> or in the git tree and branch at:
>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> Same perf build failure as already reported by Harshit.
> 
> I dropped all perf changes from this tree for the release so all should
> be good now.
> 

Yes, I have re-triggered the tests and all good now for 5.4.278 and 
5.15.161. Thanks for taking care of this.



Thanks,
Harshit
> thanks,
> 
> greg k-h
> 

