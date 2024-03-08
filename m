Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468985A7B8;
	Fri,  8 Mar 2024 20:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709929329; cv=fail; b=NtWkxNpSzTZUyRkivhmP9SLGmM4Qv7Js54+0Viicx51tokDGXqr/0MAfLhHenfExkW0ycG92DJwX8pS/653vCWE7SY2IWJZCSfM3CVB08b3/v4eJX38hUFBYSVU/ihl6hsnlq2EiAL3YVzfeyD8hNrfAoXos8pi2zo31c3S2ga4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709929329; c=relaxed/simple;
	bh=73GC5wdS0DDuKsd4NFiSRnovx5XEDMScCUmot0PANe4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=U8X6xIYto9tMZM+sF9lE59hb3v6wp57QB3YWXBpPGUwK++Sb5jRjMFbrHFwAsRymX4tAwA5gMXc5xbDpMJy4V474NXQRT2txe71jj//kq5+zfK2LjjVpesR4GOCQZN+PAy5dzGWB1MdUEqiHf/1i3WjE47woa7z+CD6A6NnN6s0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Pzf5B0YC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Dres8D7O; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Pzf5B0YC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Dres8D7O"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 428JxPM2006404;
	Fri, 8 Mar 2024 20:22:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=b3EDM1ICmPd4gBtkkBQ9C/0gxQyMOsxyJ/CAqQ7ZZ34=;
 b=Pzf5B0YCahh4MHCYZWjedLNXrT5vBNZ8IovXQE+7D02+UyWP5YW37QsPK7BeWUJih9KZ
 nwcyI4/sj5U63XX4QZOO2lyH/PUGPVlStYjDIo5dY6oMIijxeAEkjpWmwLL69AiPFAC7
 JuY8acr4fpb6+TCMzFQyd9PaO9YUxc/Kj9KUVtjiyqnZnZeLcL91AtE11clfIH/rDo1Y
 E1SSN2QrlJMA4GEo+1DkIdJQN6pp6SWeMphr2K1jjJbVCkqm3/poiG2qjSQs1L5oXGM8
 hUt0Sdajy2iRgPYt3HPxG7mln/Nqhp9WgrXPD4Yl4+Atkgz15HK6F2MEp5Oee6WoC/CF Ow== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wkv0bpnn2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Mar 2024 20:22:02 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 428Jklo8016020;
	Fri, 8 Mar 2024 20:22:02 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wktjdbfy0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Mar 2024 20:22:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DiiDfbEjqkFgHFhQ9/eAn7jpgWbYfyATBw53I0GoCEYyoRMZ1oCZMLGC+IyoXW0rG14Vk6+Igrj4QPwa+Ecr+U3GDocLYDnOUnghWHZ1Mfb2T+gS5cQ8uufLa2pXVSrfQfVJpaFa/E9Yxu2+c59jD4s3MjVeGwjSL3Geu0yV0lRajqzC8H7UG8/pgzrOK3vPdHyJor9aJ/yG/WDzdq3cOCfY99KxLyNQca/rzwQT27K2HKbHo0akrK767vIOoGgziYcNTau7CbFai3qsjKGmxVmXx7Zp6c54SwFs3FqoAApEeVNY6q5Q/MxTAyUIc3dOwjckiAkcM/qjtwh+2GMT/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b3EDM1ICmPd4gBtkkBQ9C/0gxQyMOsxyJ/CAqQ7ZZ34=;
 b=kiqolWFnK95ShLaMqMqxZrZqkG8phIyTHm7MiY8Mh10XYqUtk7NfJKAkg0s0P5EJrBuwOfo9uqtCx9ckRlvDZTJtQ6yZFQrOnlP+5Z3t0U9wAlqy8yOh7BymH1SZojDlarX6sC8/B3TwEz1wryPXXXbA4DAjzyNAcNAZXsl7m5A2EJgCxSOTKfq85JI1jCqtNvcDguJFZ06CinetXrn1lXIzyuorDUNT3VbZ/E0A9lfByxpRLNJQip2T7NCLcllj4B7CwhN+MgurDX9hmiBhna4RoWmSKngtVZD5cq3QxizOSEpa+7rG+RC+CC4pnIF1aMB3weu9+y1+aNfQtkoSug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b3EDM1ICmPd4gBtkkBQ9C/0gxQyMOsxyJ/CAqQ7ZZ34=;
 b=Dres8D7O0i33URI895i4D4bjEAQlCIucP7fFdpkARgGYjX6hnOnT2QSK/wEPoBwVmPZbk//bNWJdT5nTN16LjQW2wOnHqKoXFjl9VcyW3NeYYLW3frHCO5IvVSAELPljKO3PeBIrIGpP8jfoD6G+Y/JrWbv94j35jFzXGa3TF4M=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by CH0PR10MB4827.namprd10.prod.outlook.com (2603:10b6:610:df::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.29; Fri, 8 Mar
 2024 20:22:00 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::7fc:f926:8937:183]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::7fc:f926:8937:183%6]) with mapi id 15.20.7362.024; Fri, 8 Mar 2024
 20:21:59 +0000
Message-ID: <2ae612f8-43c3-4508-b1c3-cc4537292648@oracle.com>
Date: Sat, 9 Mar 2024 01:51:51 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 226/476] IB/ipoib: Fix mcast list locking
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20240221130007.738356493@linuxfoundation.org>
 <20240221130016.237621139@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20240221130016.237621139@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0043.apcprd02.prod.outlook.com
 (2603:1096:3:18::31) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|CH0PR10MB4827:EE_
X-MS-Office365-Filtering-Correlation-Id: 08b143e5-e6d6-4afa-937e-08dc3fad688f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	iyRRjQPJ7b+rJxLFdiAY0fStUMQBv+U5fU8QR5qN2hGioYvqpEV1qtD6NeQaANa5pC1SuFP7Ckq0hODFxGIaOJLZB39Mn0DEfVSe6MeQqYYbTqHrkplAiE3otjL6DhvSWCEcYjoxvKVQtKkRU/pcvdg0KU2rppnoXNC4Ww1DiqzOG3sw6hwBdhc7TruLyrOpUBpmtH2Ze7DvCpjp7WeKVYzFqyi4ob0929CrLBuXBb/q4qn5NjSymYnwVCxO/TPQXvd0NI2gdOudic0MZxPVAix1S64+a6Co/brKMsmqjyP/DbX57hcLEXYiI4tEnrjpPn/bcp8DuheyF2HVrS9ZaWXXLKPa7y/6rZ9s1N3h6b1PQx3L5zK1r3fYyIV0hUG6hJ431TF1JZSt/pMbbyCwkfIkFDlc82JbPQ9TllHXNQqUTX5n1Vmrlcg1Bhtng8E5t1lfrTIVg+yhtCvROHliKWG3FcY4xJbpAxVnsEQYAwjsnfGI6WcFwdaso5kWj9NzJsgDYFlvIJA3njApt8E5+fE1TmCCPXg3m5PbM0dcYd/t3PE43E3d0ZrFUXrDep6C8NRdXKYMfW9zj+3gCkOxzxRlo/dBvjYz+nElwAnqONvl61d7Ct6gakJedq6pY1HO
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MWhhWXFSM1VYaURPbUFPMUl0cDVkUno3a3J3UnlZZzliL25sUHRIeEh1RTI0?=
 =?utf-8?B?aStlWnRkU0dpenVJbzJnWG5jcVY4bk9RU0o5SXgxamxwNnE1RTZtTEZUcWVz?=
 =?utf-8?B?c2twdzEyS2NNUG1sYlpPTGY4SGpEZnE4N050K2YvanJnZWVJN3Fub0hKRXFU?=
 =?utf-8?B?Zzk5eVpqR20xY3JZdEpURjVTV0FMaFZIVkdNYUZVWWluSXIyMjZlMUYrcUFX?=
 =?utf-8?B?QUNqYlpKMVBEQk53STl0aFRKcWUza3Jva1BaOTgreHMzVG0vM3R5TGdqK09E?=
 =?utf-8?B?RHQvcUo2c29GSTFBTFhZVnp4b2p2dGd3Sy8xbGtuQTdDaHlGRWdIakFvZkIw?=
 =?utf-8?B?R1dlNnN6by80ZDhDajdxM1FRZ2o5R3VVYklYUjZkaFBDc3NkSytudjlTS2o4?=
 =?utf-8?B?TDc5MEhweWhLRCtMNDI2Q0VubWZVRERzMmdnbmtlSmUyNkVKenMzM0pOUlBl?=
 =?utf-8?B?UVdFTllpK3o2YXVsajN4cFk0N2I4QUJJNkpKeWNNREV6VjE3dXdIMExxZGYv?=
 =?utf-8?B?c01JQUh0U3FycUFuZG5LNUt5UThVZmZPVVNnc0Era09QajczMERvc0dNRHph?=
 =?utf-8?B?MTVMRGk5L3BnNkdNVHRWRWJxQ3FpNlhQT09uMTdxenY3dTRiSnU0eWpLMzFL?=
 =?utf-8?B?b0tHZGNUMTNsMEZEZzI0ZXhnL3dMVmU5R3FrbkRBWXpyZnFWMEtxd09rRHdR?=
 =?utf-8?B?OGNBSzl2bG8wdldraUtNYm9ONmpBT2ZHMDNiM1BYTHR2a2gvcnpVQmJib0RG?=
 =?utf-8?B?Rzc1dnVoY2ZkcnEzS3NWYVBGZisvZFJrZ0k1dDd0bzhlYkVWWXVWbFhoSHlo?=
 =?utf-8?B?Qm1LSjU2M01CaEdnbGdPRTZobVl2MVpveG1XcHhkK1Rna0MyYXcwVmpNSk9F?=
 =?utf-8?B?N0U2M21JU3YrSEhacXR4V2FYUzNHaHdEWWgwVURoR0FuWW1vM3Zua1VZUFJT?=
 =?utf-8?B?S2U1UDZ2OXdvSE13d25yME1VNExlc2g1cU9QUHU3Rzk0c2dQSGdlbEl6ajBh?=
 =?utf-8?B?S0hBL29tcU5ST2VKbnN0RXpBejg0OEp2YnRZZDYvbjd2M3JIdUluVGZIeVNJ?=
 =?utf-8?B?ck9mdzM3NlFiMDJoTFpNUXRYN1dIT2xMalFoUGk5bTBVemNoTlpvdTMyV29W?=
 =?utf-8?B?T2VsMitaWjZJU2t2V0VldlQrbzJPb0oyb08vZnBWSmJwY0pJcjdaOTB0Tm1J?=
 =?utf-8?B?U01RbjVmMi9wZ1oxL1JnWnJUSE1EMTd6RDJXWmNoRGJFVDJ2Q2wwMDRPeFRE?=
 =?utf-8?B?NFEwaUZ5RTYvVnRBc2VWczR5cTJYdVhQbjU1RXhibXRjenIyVm90a3hlVjRk?=
 =?utf-8?B?Vi84c3E3WENFNExlOGIwUCtIZjZScmk2VjRDWUFMMTlMUTIveW5HMmdtSmR5?=
 =?utf-8?B?MEF3c3BrcTBGWFBXVnpXbUNCbWNsM0oxT2xYeGF0eXNMRWVFM0JxeXVsV3BF?=
 =?utf-8?B?OS9uWlJmSEVoZG5WOTNDSlh0VUoySHJ5bWxURnVwNHlWSlkyOFByMWVkS3ds?=
 =?utf-8?B?Q3RmMTBUNU9UTWpLSjdDclo1ek1YWHNqZEdUejVad0xydHJuNzZVRXhSaUIr?=
 =?utf-8?B?ME16aWJWblNnYTZORnI1cXoxTVRkV3phR2NQNFd0QnJXMmcyWHVCb05DVVE0?=
 =?utf-8?B?SUtWaWwrWmVtNE1UZi9CeWE0OVY1SHRrYzZRQnExSnJ1MWZpaHptVXhwSjR3?=
 =?utf-8?B?NHhqR2Y4TGJuQUpDSjFkc0drNEM5cFFWRzQrSFFBSnF0cjdNM3B1RW5sTWIw?=
 =?utf-8?B?M0JGRXNKdEl1alo1ZEFSTkJBRFZocldHVXJzWGFyY3B3VWFrdzJCRXBwQzI4?=
 =?utf-8?B?Q0xYWUlDeVMybHk2MFJkQmdKeXhnSUtCTTBXd3p0QzYzZU9XdUtMUU91eW9L?=
 =?utf-8?B?MnRvekJTMFNpODJQRnZZU2tLWkd3RnlIUW04R3ZXV2dQLzl0Uyt0OWwrdFJ2?=
 =?utf-8?B?NUxTQm5TOWhuclZUT1hiKzE1REpTRlFMWkM3ZEp2L0swRUdVcENxTmtqbGdi?=
 =?utf-8?B?bGNvMHoyenpNbkpXaEx6SEN3VXZqb2VOd1BOdUhlSnRDR2oweVBGR2VweWhp?=
 =?utf-8?B?cG12aWZMUXlSdlNlaTlONGUxWnRqRzdrOXdzSjZnTk1vUEdOTEZGSGFJbXdy?=
 =?utf-8?B?ZkVDc24rTTROV1lNR3dHSmN2cGhCNmR3WmJURVhVeXo0V2p1U29BT256dCtM?=
 =?utf-8?Q?6K8fPkiHVR6SIrqs1QU/YTw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	vdt5qmLD0MGTbt/A4Ms7DF8aZgP6zMkf38l6ajMHFlCggFrGsO60CVO+Gjli/xZGHQcjZv24bYR5yVXdncKaGjOo5R9No/TdZZGxSznmjXcEyACVlXzTwx1kO/JyJEAlx8OA2IXlDG9f6Q8gBtzSgv/F6wGC0B8QAQO5mWkuiWBLqbQKnodtZ63MGPWo/Hmytxk4UcBXgqOE0o0W4BqamKTqRDIwC80uMgNYE7p1BABJ3pthX5Og0MBTUTHnHzARiKBfvA0U/djCzMNJ7qGpvm8HYGIRpmnaMRnrxWHSWtgsUsBmB7O0I1QNatTTjb3ymgHh2G7d0IFGYdZxw3BBOZpP4QqAfoFIB2XLKixmXZy1pyvTPSTz6xtAD1/e6cy1DzK6az2t4+CFlc56UO9CrFZnA5rj5GmnpWJxIgTN0KOy4071XlC7LwCclITZOojybETje940nX+2FgUPW4ug7otRg1NMhyM9X4peNzNdH6Ppn7ksTn3SiPKWGgg0b/bDb5rX1xhjUh/9++uD8PLkpOYgWgr2Mv+4xAkRa3YfxBBEZ/J/VIImLlrc/aqaB+Ky1VgkMbHv984OCiUyX8BArBYYXw3PdjEMgSanozrkzZg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08b143e5-e6d6-4afa-937e-08dc3fad688f
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2024 20:21:59.8848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LYr16G0eYJQiip+qwfVZqgX467EQIgGLydocv1AFZGNvMf2RGlPFPpNPBoDky338Gxdxkj8wrxeoqjue5IGQv6V4JGi9JhVwAnNuBVxBsQ2Y7mGH/SWJrENi2O9NGjN7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4827
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-08_08,2024-03-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403080160
X-Proofpoint-ORIG-GUID: l7P5jxSXzNDgu7Ncsu-jL-Y32aQEdNpS
X-Proofpoint-GUID: l7P5jxSXzNDgu7Ncsu-jL-Y32aQEdNpS

Hi Greg and Sasha,


On 21/02/24 18:34, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Daniel Vacek <neelx@redhat.com>
> 
> [ Upstream commit 4f973e211b3b1c6d36f7c6a19239d258856749f9 ]
> 
> Releasing the `priv->lock` while iterating the `priv->multicast_list` in
> `ipoib_mcast_join_task()` opens a window for `ipoib_mcast_dev_flush()` to
> remove the items while in the middle of iteration. If the mcast is removed
> while the lock was dropped, the for loop spins forever resulting in a hard
> lockup (as was reported on RHEL 4.18.0-372.75.1.el8_6 kernel):
> 
>      Task A (kworker/u72:2 below)       | Task B (kworker/u72:0 below)
>      -----------------------------------+-----------------------------------
>      ipoib_mcast_join_task(work)        | ipoib_ib_dev_flush_light(work)
>        spin_lock_irq(&priv->lock)       | __ipoib_ib_dev_flush(priv, ...)
>        list_for_each_entry(mcast,       | ipoib_mcast_dev_flush(dev = priv->dev)
>            &priv->multicast_list, list) |
>          ipoib_mcast_join(dev, mcast)   |
>            spin_unlock_irq(&priv->lock) |
>                                         |   spin_lock_irqsave(&priv->lock, flags)
>                                         |   list_for_each_entry_safe(mcast, tmcast,
>                                         |                  &priv->multicast_list, list)
>                                         |     list_del(&mcast->list);
>                                         |     list_add_tail(&mcast->list, &remove_list)
>                                         |   spin_unlock_irqrestore(&priv->lock, flags)
>            spin_lock_irq(&priv->lock)   |
>                                         |   ipoib_mcast_remove_list(&remove_list)
>     (Here, `mcast` is no longer on the  |     list_for_each_entry_safe(mcast, tmcast,
>      `priv->multicast_list` and we keep |                            remove_list, list)
>      spinning on the `remove_list` of   |  >>>  wait_for_completion(&mcast->done)
>      the other thread which is blocked  |
>      and the list is still valid on     |
>      it's stack.)
> 
> Fix this by keeping the lock held and changing to GFP_ATOMIC to prevent
> eventual sleeps.
> Unfortunately we could not reproduce the lockup and confirm this fix but
> based on the code review I think this fix should address such lockups.
> 
> crash> bc 31
> PID: 747      TASK: ff1c6a1a007e8000  CPU: 31   COMMAND: "kworker/u72:2"
> --
>      [exception RIP: ipoib_mcast_join_task+0x1b1]
>      RIP: ffffffffc0944ac1  RSP: ff646f199a8c7e00  RFLAGS: 00000002
>      RAX: 0000000000000000  RBX: ff1c6a1a04dc82f8  RCX: 0000000000000000
>                                    work (&priv->mcast_task{,.work})
>      RDX: ff1c6a192d60ac68  RSI: 0000000000000286  RDI: ff1c6a1a04dc8000
>             &mcast->list
>      RBP: ff646f199a8c7e90   R8: ff1c699980019420   R9: ff1c6a1920c9a000
>      R10: ff646f199a8c7e00  R11: ff1c6a191a7d9800  R12: ff1c6a192d60ac00
>                                                           mcast
>      R13: ff1c6a1d82200000  R14: ff1c6a1a04dc8000  R15: ff1c6a1a04dc82d8
>             dev                    priv (&priv->lock)     &priv->multicast_list (aka head)
>      ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
> 

Due to "---" in the upstream commit, part of the commit message(along 
with original SOB) got trimmed, just letting you know so that stable 
scripts could be improved in catching those.

5.15.y commit: 
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=ed790bd0903e

upstream commit: 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4f973e211b3b1c6d36f7c6a

Thanks,
Harshit

> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 6 +-----
>   1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> index 9e6967a40042..319d4288eddd 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> @@ -531,21 +531,17 @@ static int ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast *mcast)
>   		if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags))
>   			rec.join_state = SENDONLY_FULLMEMBER_JOIN;
>   	}
> -	spin_unlock_irq(&priv->lock);
>   
>   	multicast = ib_sa_join_multicast(&ipoib_sa_client, priv->ca, priv->port,
> -					 &rec, comp_mask, GFP_KERNEL,
> +					 &rec, comp_mask, GFP_ATOMIC,
>   					 ipoib_mcast_join_complete, mcast);
> -	spin_lock_irq(&priv->lock);
>   	if (IS_ERR(multicast)) {
>   		ret = PTR_ERR(multicast);
>   		ipoib_warn(priv, "ib_sa_join_multicast failed, status %d\n", ret);
>   		/* Requeue this join task with a backoff delay */
>   		__ipoib_mcast_schedule_join_thread(priv, mcast, 1);
>   		clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
> -		spin_unlock_irq(&priv->lock);
>   		complete(&mcast->done);
> -		spin_lock_irq(&priv->lock);
>   		return ret;
>   	}
>   	return 0;

