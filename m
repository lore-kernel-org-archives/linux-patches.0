Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79C2199FAB
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 05:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749015957; cv=fail; b=sOR6IGEnwpHbNotr33862gKV+qOxqEvWeacWILcpBIgthMfQ6PG8OqXvi9uZx+xrawEZiTO1//FKPTuSip99e1e5ZoZFQ5k/F08YNV5qaH8zdMlr8M8MwceaFCKS1T+DT4BLjmrlroQDIrAk9qD1Q5aNKnL9eYNLautIB7lGXUc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749015957; c=relaxed/simple;
	bh=/RucLgSsVVYfI0hQCYj4oVxLkNVzvNGMQnyhmNC9QhI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EJ5tEql5kSuZ576LQgMv1AR5SsyKA4ZE3ltkNATTPOqSs77K/l21ldEGfWjLguXvIlOPSSlehXALv6aNRBn4SNogu4wAKKSXDCcIgP/BXehgweVlfYktdYpsRMYk+7y7v/1aBSs93cGRnzd+KvQcsq+0t6XngC7rXICojwgIeCo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Be4tCB/D; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pTvDxC9T; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Be4tCB/D";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pTvDxC9T"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 553MNN6W026781;
	Wed, 4 Jun 2025 05:45:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=F5OVP9PKw988+SpzNBEClaOSGjDUUbd/miyv1Fr4Xu0=; b=
	Be4tCB/D+CzxiIDIwWedtD1+g+bgSOCKQvMPTupr+h3TztGRmCo1MnbS+/HCl0jN
	vlmu/BQd1Nyfs8Y+ma4CxVjNmK5brJeEPb4oVUsp6d+V+Jbvb+kxmVaTBS2xepmG
	MySMQjx69OSBoA9BpDc4gq07nqN28m0CYZ60Q7Iw5n0yPSxqRWaQZ6AJJCa9RiaW
	cOsBdNhklvYTO1GvMKms1yHMk8XNCwztqBnb9VzbsnkDmh+pGBuZlKT7xAkETgUI
	lfcwiUCc732QPxsuS+UIF2H8chXXoTLZ4a1Q+tDzf7uGPnFe7io/IYSSsR8rl6ma
	OkYEYae4xCna/C1GFKfKww==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471g8kb86u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Jun 2025 05:45:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55458QV6035349;
	Wed, 4 Jun 2025 05:45:42 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010034.outbound.protection.outlook.com [52.101.85.34])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46yr7ajghf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Jun 2025 05:45:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pnU8Vhtvk6tZ79hKcXFjw+MnLi3IGVYazqierxeKcE7BOKdPBwUMCr4TWXR1iXD6U7q9Ha1hsaHWs/vwR1d5ykuqIZQ2liky/isEzaBhJOX+EBPolO278aw8FRWob1XOXs+VBQTowTJ0zMGSgwh3jzGw26YQuvUTObMUulCTvMuzh84/i4mKEdW2BBVkAVCfk7y45WuGvMkamVKxEws2HmuZYDvme1ZULbSJbIaeIpm+uYPwsqUiz9hUSnL1nlEuPBMH7obWv9hGDw91ENhYRlnlUdC9m/EBKKSeuQ+tI8HQTtYXU352gCgZKmyEvIlmz77RZAWzLsoWO8thRpvXjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F5OVP9PKw988+SpzNBEClaOSGjDUUbd/miyv1Fr4Xu0=;
 b=pcL1VodlVjLBeCFg9zIFD6AFdfWahbKlmnB8ZU78CFfMOuyfJdqcP4Ox3+BXlHUAybv6CoaT4/q61cSgNY8un5M1L40eGqyuZ+sDXgRR3/O3voyWHUDPEZ2abP30X0QIkYySJEw8rFBxnZ62m2Pijgd5a8oiC0/tlz9gHUpJzEFaVZ8XuRymP5M0zyHmPBHanpkydHcNSvKNbZPlWJ201KeN5i+97aCVvQ3gbV3nntIaU9P3sCs5M9WSOy0SzvIqLUSEnXsfk9iIF45AsZT5VHX3D+oYZh3mynUz9CRFpgryktnLXEQFOlXUtieNiPh/yv1I9+DmA2hyB0j3ojZW/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F5OVP9PKw988+SpzNBEClaOSGjDUUbd/miyv1Fr4Xu0=;
 b=pTvDxC9TMmn6qdJN1qUYOXpEcvh9gwoH2ykdwHupcMs95TEK4WmrIL33deDfXYB3VONMrLqUR99Qen2GZT1eD6TcIEXPzWt3U/Y06GWND1VFk0MNzMWYEb18C841dGAnjj9SVqySrV0Qnq6wL2biREeX5f8Nfr7Jsn0WChND+DQ=
Received: from DS7PR10MB5328.namprd10.prod.outlook.com (2603:10b6:5:3a6::12)
 by CY8PR10MB6657.namprd10.prod.outlook.com (2603:10b6:930:55::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.41; Wed, 4 Jun
 2025 05:45:40 +0000
Received: from DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c]) by DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c%2]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 05:45:39 +0000
Message-ID: <b2b7c40a-d792-401b-b172-cc4891c47cdd@oracle.com>
Date: Wed, 4 Jun 2025 11:15:28 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/204] 5.4.294-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org
References: <20250602134255.449974357@linuxfoundation.org>
Content-Language: en-US
From: ALOK TIWARI <alok.a.tiwari@oracle.com>
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0127.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::31) To DS7PR10MB5328.namprd10.prod.outlook.com
 (2603:10b6:5:3a6::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5328:EE_|CY8PR10MB6657:EE_
X-MS-Office365-Filtering-Correlation-Id: b863fbf4-2284-4f07-2d28-08dda32b096f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q3BwSFFuMC9aZHhOOVJNQlRXUnp1RTZJaTVWV0h2SWZtWCsyU3duQ2R1Tk5k?=
 =?utf-8?B?alhPcHVpdzZFSXFvbmtSbloxK1k2ZDlKd3RUbldIa202NXFFMGRzSDk4TVo5?=
 =?utf-8?B?MS9YVkh1RjA1RXVESCtOTit4NjdmRmNhWDV3K2tNL1phbUVBWUdFNHA2ak1t?=
 =?utf-8?B?T2NYU0kwSVNsd3REMUQreG01d2Q0NDVmbnlFSkd5TEY4U0U2bFNjb0ZoVkVE?=
 =?utf-8?B?OHorY3NMMWx1WjlJWStSR2ZDRlMyL2c4R1d1WmVYVVBZTkhwNjlxWGZybUxr?=
 =?utf-8?B?R2xveU8rYzJCOHBydmJHQmJKbGFneGV0aVZIVFk2cnV4aDZhTnhIZ0x2d2pi?=
 =?utf-8?B?N3YremcrdkNiNUlBS2U3WUl1bndzbnNKVENpNUhOcjVjM2xQT3JFQXBKbGJr?=
 =?utf-8?B?S0x3VCtrYlFUQ0pBNnVzYkZ4L0FTZWdLVVRieUNUcnZmZy83MUNIdXFMWit6?=
 =?utf-8?B?S2labWhtaFYrM2JkNS85RmVyZ2tFZkdmNGdRUjh0QXRBWlNmanhEL1ZaY3M4?=
 =?utf-8?B?ZFJmTlkwdVhHRkxKWXRlMFplMDdweTNUVC9PV3BSd3NjdnZ2N01saHNWTHRa?=
 =?utf-8?B?Q0wyb3pQYzQyemZqZ2hrT3B4TUV2VnNVeU84bklNZllja1hGc2FZcEF6VnlH?=
 =?utf-8?B?TzY3dnRPOGlIZ1pycll3SnpXK0Nhdll3ekg0ZmIwcExEeTAxN1Nyd21UT2s4?=
 =?utf-8?B?cjNsSlB2NExoNm9jcUoxTXA3YW93NTdBOEFWZnlxVVdQOWRlTWp2QnlKN0h3?=
 =?utf-8?B?NitPZW05OGtsNmhPUmx0RTQ3RnJqcC9GQWVnajgxOUpQV0p4dkxnWjloNG9m?=
 =?utf-8?B?TTRoZHN2R1haUmhGRTRVTTVjWjhkN29uVjBGRnZVckNiNkRoVVRVMVlMQS9V?=
 =?utf-8?B?K0lKNlNZc0pwV3lPRlZnUDJIRmVYSGZseW42UDBUMm8xQzZWbTlES0N5RUNJ?=
 =?utf-8?B?VVBUSEJoSGhnenV0dFdYZVlrQ2p6aGFycWlYcXNDV05Yc0pKUmVLM2hIWUhN?=
 =?utf-8?B?ZmJpMFBtNFI1bWY5dTA0anNSeUVNRkI2b1pSakZQRmdkZ1plamUvZ3d5MzVu?=
 =?utf-8?B?Z2tIR2dsaUkxY3lIcWhreXVlV3BCRWpkNktxSjdlUUlhdFplYm1UcHdCWGRK?=
 =?utf-8?B?d25XM3J5OUc5ZUxkSDBuQm1DZWNFcjJTeVRKSzlSU3pDVlJYd0l6NzFSNm13?=
 =?utf-8?B?eG1tOXpOQmdPRUhrSVBSKzZGT2JTOEhtZ3FIa2dwWVFhZThabHRaQVoyejdH?=
 =?utf-8?B?RU1SMnREbWViN1dMRDd4anBGTkhsYUh4TEIrbTREdU1KRDBSMTZ6cXg2WCtC?=
 =?utf-8?B?UHNSRE5SWklPSWxBSDY1SDVyb21mSDJYelE0cG9wb1Q3SHA1VXZSRDhtcysr?=
 =?utf-8?B?VkY4NjdXY1JSV241Mm0yQW5HdnZNT3BJVXhPdDlDQm95OHB1MHJud25RNE00?=
 =?utf-8?B?czUwdFQwN2grV0tlNkpVMk1sd0tzQ28waXIwUlQzVWtxNFVrRjZ2TXYxbUQx?=
 =?utf-8?B?NGJFT2xJZzBDcEswREpWRm1EUGNxNDBkOVIzeElkb1B5YjBlWHMvQ2VOTFdH?=
 =?utf-8?B?VUlYL1cyV3dMdm9JVElKM3VFZWg3VUpRN3czSElYbHg0elp1R09wMkJhUHV6?=
 =?utf-8?B?Z2F3RGpQUmlwelMzSUtFZGdZN2NOWEk1M1kvZExmclBMazkvdnpJb2gvbVp3?=
 =?utf-8?B?VWlBL0NNUXdKMUE4akw2NnR5OUdaVTk0ZEhTcGxZVjl1L3hqV2Z2emYyQjR2?=
 =?utf-8?B?WTNySUxEVitxMnN4OVFleWNUZzNQc0laN0czZ3VTU1BoNWlMdEk5ZWY4SUYv?=
 =?utf-8?Q?5ajyT7EbpcDES00PtiVMQHZChc8Jj0b2mBL4Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5328.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N0dsUjUzOHdYZ2QrcktwcmtYVnRoTU1peEdKSCtFMzFkdDlsWkMwTFd5cTdQ?=
 =?utf-8?B?OGc5aXF5TTRSd0pxb3FNVVlMZCs1SlJESU1Va0ZMRk9ManVVbU42WDM0ZUxC?=
 =?utf-8?B?NCtEemxNd3ZaakwrRDBPZnNhWWNUSUcxK0tHZWhPdHJ4MG93V1U5b3BzR3Vj?=
 =?utf-8?B?VzFGazFBdERtUGloYjM2RmdiRVdEOEpqUGxNNlFuVjVBTDBSclN3NDE2N2c5?=
 =?utf-8?B?anBqTHF2SlQ0TjJ0T0p4ckpJb001RlF4Qm82enFKcHFwcUZzNE9nczBzMWZi?=
 =?utf-8?B?bnZqZ1Zab0hILytDNHUvQmllanpRc3JOU21WSmpqUmR5cjh6YlU3T0gvUUla?=
 =?utf-8?B?aHRuM0dvRU9zSml6TzNpcjdqQmZvenZqTkhlNUJCT2JZMDhiZHNjUXFZT1lu?=
 =?utf-8?B?TmZsUGVObFFwWjVtd2szdU1qS09aVjA2N2tpeVE1YnhCV2JoSC9SLzhHRzZo?=
 =?utf-8?B?VWJOZDJSNGdCY3plWDZ4UzFCNGZBUE1NczVTYmNlOFlQL3oxUXQvRTlFRUdt?=
 =?utf-8?B?RGtDdmk5dzlYS3FPNjJIenFhcFFyQi9aUDVlV0NIS0c2TkNMZWxZQzhSa3Fs?=
 =?utf-8?B?YzhhZ2tQa0RNd2QwSkpOWjZ5SThGbzVzdHVYTS9SeEYzZUd1NVdRTThHcFo5?=
 =?utf-8?B?VTJkQ0paenNzcXdvZjlPdHliUmxjaEI3SmRVcWs5TDVMU2ZYYTdWMGo5dlhF?=
 =?utf-8?B?R05KWnFNZm9uU1MyU3pNOVhiRzd3YVhXUnN5WXJndXN3ZlJxMTA2Ymg3djVs?=
 =?utf-8?B?ZHlCYVJVNEpEYUJLYm5tOVRxSkg2K2lyVVJiOUtQbWs4UGZkRTdTLytIRVRM?=
 =?utf-8?B?QXRBS0NCNzhTcVovOG9IdE1xUW1XNjJZTGxpb04vRUh6QUxKZ2dEejlQUXBh?=
 =?utf-8?B?UzlxbDFaQmF6QUFmcmxHK05RZW1VZCtpMjhUdEZLQVk1ZFUyakRBTWlydVNY?=
 =?utf-8?B?VWtuSERLbEN1VnBoMkZPaGUxZnZJaEFKTGwzRWxjMjV5eG9OalltdnI3S2FI?=
 =?utf-8?B?elk4SDcxTERnaU5KVVZoU1FoY2EyWGpjNmUyaktlaW9yL1V5Mk5leDM0ZSs5?=
 =?utf-8?B?YlUrZmp5Z0JRWEtONTd3OEVEcm9iOENUdUNHaWVoVVdtc2JGdDRvQVlCT0FC?=
 =?utf-8?B?bEVDc1U5TTNqRU9SSHRBZlI0WlFtOFJEaTNKVG9TVzhsdzhWSG8ybmhaRkpD?=
 =?utf-8?B?QXExNTRLcy9Zd1M4enRmcmhyNjRTNXZCOFBpaTlPWTJFVmdzQndqaTU0YWxQ?=
 =?utf-8?B?M0oxTnlUaFRtU0lNYUpqL3k3QWt3TTBtdWd5eTA2TEhMbFp3NUozSE1BUHUr?=
 =?utf-8?B?Zy9UeUF5OWQ2aDgxMDFXT0JBbXd1bkFGWGNJVE9maVhQNENIaUJxQThwd3Q1?=
 =?utf-8?B?UGxZTk5rMGZkRWdlVGd6Y1MwSUlMYkRWU2lFbXlsMC9WLzJialRoZFBHR0lr?=
 =?utf-8?B?UktoUWJ2QzEyOGZ2ZjhLbGZROTVneEQ2cm1ERTJCM2dtelJGb2ljRXNHNlE2?=
 =?utf-8?B?YjJYRk9QbXROR0gxOWdZOVJMeUVnYVducElmbjk0ZThJK0hzclZ5czZaQXpO?=
 =?utf-8?B?cU0wQ0liQ1h6NEdaaFRGMVdYVWYyU0pxaDB5NDBabHVobTNGMy9wMkxhdDc5?=
 =?utf-8?B?TWFVaVpmYVkzaEgyMktiSEticWRDbjZhUFVpdjRROFlsdk1aUnI5bndBQ2lw?=
 =?utf-8?B?WXhYOVpzaTh3L2x4Ulk2OFUyUzJGOU5TdDZhZUF3MXV1N0JDRlR1R0JlWm9H?=
 =?utf-8?B?cEtvQUhJd2hSQkpWcTl5anZUeDB2VXRHUkJ6N2t3R0VhTXhldTU4Q1VRd0Jk?=
 =?utf-8?B?TktRSHRUVXl0L0R6azhwNWpNbml5WTdYclF3VWQ1c3YyalEyQjdvaStJbkk0?=
 =?utf-8?B?YVZDaDJPOFhsMWZrRk1vZXlORWRwdm52aDQyNU9mWkZRMHorYkpJL3dnL3E3?=
 =?utf-8?B?d0t4VVhBOUl3Sm5MZ2M5dHhTSUVjR3R1SHZsWXU1dFhLODFMSFFQUVdDVTBZ?=
 =?utf-8?B?TVFranlINGxGaXVaNEl5OTdmOE85ZXF5bWlKUE16L1Qxamxsck5YUGkzbE1O?=
 =?utf-8?B?SUxTcGJmU1pyL09majh5eE1zMTUrMElnS2RrQXlCZDR6eFkvZlNBQXZTbXFo?=
 =?utf-8?Q?majhkZnSqmaqoDM1qx7CLMXmZ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OOQrApBGlp29Xk34w+HZoeBbVAN65H8x0CJkfKC71H9k4jz1IgiwPUx2P9m85QKcfzpttBPZCgjdXZ2dbO9rFidB185HrhQM0DyCJxUqS/ROvLN8zedRYqeFG1lhpQUwiw7a8LkYg1kedKML0UM0b3VBsIAs+7m056fvxnzY+SR7qXhdYY+Ixjrh307CyXtD81axtCY4O1WnruUXJ7LJG89eE9BUETMoqE+kui63OS+zXHriIZXVR+31ZrtJPfW8xaIG3d043BRg5hF8isPMEU6MTP6x+zgV6iXlNTH6fCqSewwXtFEPD7RsS9H7Ju4Vh1TtcCY/mLi0L+txwEpfPGGVvwEuuPIvr9HDs+d4A/QkL3lpLVhmRLWwmG1FOGAm6e65xcWlhQ/GRXHskdNgtK3pa3InRPP+60OeLK91K/zVVnRDWrhqFGu1GNdA99rWnmF8HSlJcNC7tUARJ58lyklaDJ/8VxaaGhv17M+sZX3tSj0N/TSweHqVXV9sqlPNPeIe1vEeju1fdxCNVj2ADuxIfTmfn1IF3CuupOK7+qrOv9wigRynmrZvYwmLwdpU+gTAb8H+TaRl+tLUAdz0vkhDVzsHiluU3NjdrbNBRw0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b863fbf4-2284-4f07-2d28-08dda32b096f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5328.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 05:45:39.8587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j2pUNGMnkiAe6OUvjLdyADTu+2aj3QGuWoQQuCEpOtJEKMvRcUnlrXmAKAmi1GWR/52mcIfFh1EleldutYwGWGn4ppCa6oq/VmizET/uTR0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6657
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-04_01,2025-06-03_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506040047
X-Proofpoint-GUID: sgR2l2fFhufLnjR9GR0x_CbJRLrGf7qz
X-Proofpoint-ORIG-GUID: sgR2l2fFhufLnjR9GR0x_CbJRLrGf7qz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA0MDA0NyBTYWx0ZWRfX/eXD6FxyR9Zh DL6GdN+F4d8mz6kQ8HW9F6T38oLzsoKZyjIhy9dI95j7ir6U18C10RN0g1OQ24HCoVizChkYhfu /n3zJqooD7hwEWz4EN8Vvs1yRKV6g3VAtu2auOHhJQBa2+zdt0g1aEnV7B54g9ZKTDm6/PIxYE4
 qf0GvwaZRuXbV/MJ0W08xqwjW/8MC1c+fbAGLv4p3FLAFxXc3uNIdHXLl6+HNXuGqmZq5BTLz/k G648Z9ZIT3f6udPUJ0AZn1YJYO0ytO1RUmvSy4glyk8Vt3hkh9R3z/q38oPE2ZmB6XHQLbUszV4 eMUxAFL2kJkAcNutke9v0gBu3CNpqA3XoCm/PPLMngJrc8JKcYapr6g+xr638ER6M9VYptexWjL
 uFKFGJNU+QGP3dJj+AF4BCifneuljpmsSp2KCBwqHnLeFwUWnpN/0HdX7BE8nlQoTZnK6Xw+
X-Authority-Analysis: v=2.4 cv=FM4bx/os c=1 sm=1 tr=0 ts=683fdd86 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=uherdBYGAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=V_0_fhofz5EzV17i3HYA:9 a=QEXdDO2ut3YA:10



On 02-06-2025 19:15, Greg Kroah-Hartman wrote:
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://urldefense.com/v3/__https://www.kernel.org/pub/linux/kernel/ 
> v5.x/stable-review/patch-5.4.294-rc1.gz__;!!ACWV5N9M2RV99hQ! 
> J6pJroisoISUtldxNLLNVGnkvgEjGsbCZoajtOyvledDnWtv3FKmjfXeyFoe0fxRN5q4r2IeQ3Tq045ESnyZuZ_RPw$ 
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Alok Tiwari <alok.a.tiwari@oracle.com>

Thanks,
Alok

