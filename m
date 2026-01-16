Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1541A316E
	for <patches@lists.linux.dev>; Fri, 16 Jan 2026 15:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768577938; cv=fail; b=TdRokgzHyOeFMbDwR7cF9bvvGM2oItlS9j8Ht9WSXzcdzsCeTb2WF4FDl5Ske7ezfZ4+oxX+CEbjFWx8j65KDmc5fuxaGqamUxY/XbCRkFUADadjSeBacUx+SlpWPycvbPikT/L7IJF17XI10pGdB/5+lhjyEbzW+Xm2RpYIt1Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768577938; c=relaxed/simple;
	bh=XaUOaoXCKgM1KATXNgXDMyTWIk0JFF6NnJlS1NbQh48=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jwx1GjqK65Qfeq2B5AND9j5xcJ0u70Q9xpjFBeBnyaRMFaWAm6KjP4C2Rgi1NMRv3akyfah70s9daowMOg8zjHFgOwV4cl08Xmf0X4zdtmGecMh6Zhian810ceKzmcQkS6T/92ShQBzQlk+3uQ4k2Q9T7uzb3jeMUbMSN9KYAJk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Dr5gS92q; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qntEzTim; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dr5gS92q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qntEzTim"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60GDV3Fb1433051;
	Fri, 16 Jan 2026 15:38:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=PEMHHTQZYGdl5hN+jVYGAc05vTtBS1wm8yRRZTViauE=; b=
	Dr5gS92qP1w+YsAjZwB84es1+kHjoT6cSFQWVR26Oc/v/V1HNhxGsWt5K0rWaerq
	qcp5md/73EZC/Y5QfNOKS7TwgylvsTqjiyP4oK3Ik1bPby36KNzWdji72XK35Ij0
	v6rkQlgNhfdwhUs5rdK6xlRnIdmInOC1WYsv1pFCaLhV/06jI0EqLCxNwsXSXA4t
	qLCZ60kDl2CZpPaLvdWfDyN/ew7FQAslsa5+2E8BkxJJnINOaEn01x6rFqGBhHht
	NBFAiGwyVOT0ZjsWT1O9hqCnwPDjH9Fs6Ysvyqcvl90TlPxEd0F57223gD3FUEG5
	fdGaRviw0DthWB2jnK6FZw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkqq5a4fg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 15:38:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60GEkM3q008158;
	Fri, 16 Jan 2026 15:38:34 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013026.outbound.protection.outlook.com [40.93.201.26])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7csh7e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 15:38:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GnMafztY2j0qngy8CPwnQfEx8iTGYVK9ij7R49RQVNpBTtAbWjXoAZM/3Xg5etuqgyHgVCbdLwgU0+irsVWJOmkYlwpNNR7V5rjZTXxulKXPkm4cbV+DZ22h6YtqgNX55bgMAvqtEQZ6qIhrweaH9DdZYAZVubf/GxDvjs8uUBq8UT3YWPrQZiH4Rh/3Vruz5icWFIzPfPMmPfdBNwcC9RJjiqA2QwBmeiGvdG/7H/hcLxI6yIeYWComE7cn2bOhC8XcPc+MWMiJ/rGFF9yRo3jo4Gqx6iDkZyMN5tfqumTRrG6WwDEMvShBjYIjh4Do0za4qjwkmXUhjUh9w+x4wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PEMHHTQZYGdl5hN+jVYGAc05vTtBS1wm8yRRZTViauE=;
 b=czbdeh3Z3vXBcMlBxi8W2yEuPZiYH0XvmEm9s0mmd6XNXNDg+ST2OHyhywu9I9q/4pcShAp2aLtlaLYqyzDdlih02HwSx7ucPbMTF6NeATKClDEzxgcHOH33O1BkVcTrbNt9FfTURzhJm7lwxNs/vOJWT5cbYx2EfSoryH6AMqrmV1SImRvFcAHaKGC55+cHzjbuzEV3sLAFHa1Qdk3kvNQFksjTDR6v/P/vaQCDsj4BuLoi3xLVsQq5vFAjO7QJ8GpILmK5E6OOeqMyr4uEPYzub+mQkAFR7MYzQvhEZ/r4AU8ZnMpl1IQr+od8kBQNg+1T7uNsM8aQDAA5oX6d5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PEMHHTQZYGdl5hN+jVYGAc05vTtBS1wm8yRRZTViauE=;
 b=qntEzTim/x9+lrs6xt9RG20Ot+hwrYxTmEdKL9+bdCoxbQc5CHIS3Ys3Fj29IbOKZ4ZqV6szS/DQw+NvAzaNUMWMtAbqClgJIiIt9GBAYExisI1+pMJJk4Mjs6zUbeEmZKEsfnSBtzyqiNC4Z8wo44ortTIDUYLEgo3JNSkkOIY=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by MN6PR10MB7489.namprd10.prod.outlook.com (2603:10b6:208:478::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.8; Fri, 16 Jan
 2026 15:37:56 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 15:37:56 +0000
Message-ID: <2065f885-bc4a-4aa5-97f4-5ddc4fb10cf4@oracle.com>
Date: Fri, 16 Jan 2026 21:07:46 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/119] 6.12.66-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20260115164151.948839306@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0107.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::22) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|MN6PR10MB7489:EE_
X-MS-Office365-Filtering-Correlation-Id: aeea3347-7a86-440a-ed39-08de55153824
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TjJLQzR5SFNKUW94V0orWGNHVVZSODg1dk5DMWxVUzlyTTJ0TlN0eDFqVkxE?=
 =?utf-8?B?VjhJbHQzcWxCc3BWRG5hMGQ5bWNNK0hqaUx2cVZSM0R2ZUFBVGl5Q0Q5OXlS?=
 =?utf-8?B?S0hPZjVnT0VSQjc0d2ROYmpiUmovZW5keGFEZ1pva2dJRy83Z2R4S3B0dzc1?=
 =?utf-8?B?ME1GeTZSNllJUDNNckU5YnVvSGJDeStSL0VKRzMwZHpKejZyQmN5S3hSM2d3?=
 =?utf-8?B?clMrK3llbXdNdUhMSEhHQ0RhbjNtOFRBbmI2VVVjK2ZhL1dtNTY0bVpxdzY3?=
 =?utf-8?B?elRHb2E3aDhUNVFSbFhsazYwQWV4eHo4ZzhZbkYvUEFlbTNmZk9TcGZGMERB?=
 =?utf-8?B?TjBlL0ZaRDBzUUpJQkl5N1ZBSVVGb2pDb0RkaE1yaEduK3hhcTF1ZUdhWFc1?=
 =?utf-8?B?WGFITEJiTE5vZ09UZUVWd0YxNEZQRkoxYWlOdSt5Q0lUMUlobU0vSzZnaWVp?=
 =?utf-8?B?NFlhTFVRNXRKTGtXWWxTMTRwVHZwMEhldGFrSzR3dzlaVmpjWlFCb2txVWlw?=
 =?utf-8?B?TUlxQmhUdVZJZ0dLTmkvbkYyUW9YYUtwVENpeXMycmZLMGpzekRvMjljNEhX?=
 =?utf-8?B?SzdxVTBsbWFEdEpqeTBuV3FpU1d3ZEEwQjdLSkZVdlJOOGZZclpQNlpPbHc3?=
 =?utf-8?B?Q1puSFdhbHg5L2Z6bzlFdWNYQWQxSVdwSkNtVnozMEFmT0lkbkEwbGM2TEtI?=
 =?utf-8?B?bFA5aTdyV2pCYWJ4WlJyMUF3VWVKWHQ1dUFZcWZxakU1alNyU3UwamtIVENU?=
 =?utf-8?B?MVlGL3VSeFp3U3VCekRlSFYxQlJwUTIraG5kZHZpc1hTdGtqQWVIZHpQd3VI?=
 =?utf-8?B?dGZpcTRiR0UzdC9qcEdzNVM3MU9RTE50dXBUYVdBWS8wclR3bmRyak1LZHlB?=
 =?utf-8?B?S3JjUFg3RzJ6T2h4bGlGRHlsMWhHN1dGQXFHNFNWd01VTVluM0hVVHI1dnUy?=
 =?utf-8?B?SUtDYWsvK0E0Q2liZmFna05Kanh0OWw0Tlo5Ynlya1RNWGk1Q05UQlQwRDBa?=
 =?utf-8?B?ZzJZUzU3WW5qeWsxYjNqZXFPeTdhZ3RRZEI5SVI3NHlIWk5OTGZQRWtLVGkz?=
 =?utf-8?B?UVM3TWNISmxWUU45SERialh1MUhSQUJMZzJQcmg3T0l5WWNJa0hRMGZPNUhz?=
 =?utf-8?B?QmJwNXkxSEtXZnBTN2JwRjV1ZmZ5R3BycTRRYlBpdFhhVXp2NGEzN21WNUF2?=
 =?utf-8?B?dnRuWklZRElTRnRGektmRmlXcVR5STMxd3RDNTZMLzJ1cHJMVXAzV3JIQ29t?=
 =?utf-8?B?eUxzRm1OZm54YW9SUUxoMzVUcS9qRllscngraitoRnd2M0RaUkJaeUtsalhT?=
 =?utf-8?B?U2F0U2ZwL2pONUFSUk9CcU1laStpeVMwRmpuODA3UVJoVDUwa2V2Q1c1Tlpo?=
 =?utf-8?B?Mmk2WTZ5T3BWUEhORU5adWprblM3WHpGeng1aG1iVmFrZWFabEtZQWVablpv?=
 =?utf-8?B?eTZDZ2dUREgweStKc3pFOHFROXNpaWJJMEdCZGcyT3RRUUh4dm9HdDcxRFpn?=
 =?utf-8?B?OVhCbDM3enkrUTY1YnQwUjlZNmUrOW13TDJXVG9reWtmVjVsL0FQdUl4YlVY?=
 =?utf-8?B?YzhycVQ4QjB3NlR1MVZPMzQ3cXpzQ1BxTU9TcXVpTkk3bGdlendBV2NCd2ZI?=
 =?utf-8?B?MkFPN2xGRzkzSWJGcGkxTFVLSnpYY1lvNFBzQWxCR3BSemNRUGV4eUQyR1lW?=
 =?utf-8?B?NGVkRHpxcnI5TkVUaTVLbHI2bWNZM3g3TDlEVTVTSlBmM0R4cUY0SktRLytR?=
 =?utf-8?B?dUI0UGNQTzZrY29RMVBXSEFDNHpaRVNsR1B5NEI5SXNqVkR0TGlEL3JFMlB2?=
 =?utf-8?B?WGswOGZGSjVaUzg3aWp1TGUzZmw4WjVBakpZMys3QzRaNWFTNGFnQ0FYK0tC?=
 =?utf-8?B?YUdOeXpBczkwRTlKZ2pvMGczbDNXNVlSVmZUQ0lGSTFlMTJydVZWeHUrSEhj?=
 =?utf-8?B?Rnk5TzFjR1M1U2tEQmpCaHorLzR0V2FvcHg2YmJsOFFweHRIL3N1LzN2T3hs?=
 =?utf-8?B?a0FvRFUxU0FhNjRsQVhmNHZNMVNuSlNFNHEzc2ZveGVCRVlnMUZxdHQ1Vyt4?=
 =?utf-8?B?NGkwZGdwZFdpVUhVdFkwQzM1REo2VDRKOWFkY3dCVThPSTZmSDBmTXhKRDdK?=
 =?utf-8?Q?K2Zw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S3A5UW1aQUVCclVVeDl0WFBGOHNMU3RjMThrVGpTdFZCMEN2dVNKZGk1YUli?=
 =?utf-8?B?WVMrY1R2TWRvTk9MTndXZm9jdGtpWXN4eXorMTMwSG5qT3o1cnd0ekxsdnBq?=
 =?utf-8?B?TE1za0JvRmZOdW5jVnRtK1BieDRoZkdYRW9jVXloWFZFUit0bXdxSjMwMHg1?=
 =?utf-8?B?d2tjZU9jdjZZSGtYcENrelg2UUtpbm52cFE2bEhvdlVsYlcxVjNRV0VzUVdw?=
 =?utf-8?B?VTJVMXoyYUNnTjUwbnZvekZOQmNSL3ZCbVBqY1VUTmtxWTNveVZUQ2gvQ2Yz?=
 =?utf-8?B?dkV1Z1F1SWplY3VmcGhGV1VPWTdZaG0vUHNSSFU1KzJ2alRJWmxXSzdaUHdR?=
 =?utf-8?B?cDN0cVpOazRKclZheUFISzBOOUprOXpkUGtoZXV5UTliVkM1SEd4VkJmRUl6?=
 =?utf-8?B?OTJpRjRxTVdnUTl4eUhlaEV4M1hLc2hrekUxRjJqSUJkK1c1VGJaRFY4Uk5V?=
 =?utf-8?B?VGdaUldIL0J5ZUdlWDl3YS9PZ0o1U01hTFV4ZmszdlcyYytYblJzT0luYWZz?=
 =?utf-8?B?azM5ODhwZVVPUnVicG5ieXJOb0NleWUzdjJha2tDZWZpRk9samFuemN2OUtD?=
 =?utf-8?B?eldLWUNhcm9vbzJVRFNrdGoxTHBWaHJHbHhmZkozWDZ4c0hJaFhFOVBNQ1NB?=
 =?utf-8?B?bkM2cWxEc0Rld1oyWnVzSXFhWEhmWUdndlNteWtoek1SU2JMM2dmb1Z2azlK?=
 =?utf-8?B?Qm1rYTVFSVFzTmM1Y28vSHh3cnNQSmdGNkFqWWFwTEVIU2dJek9WYjQxZ2V1?=
 =?utf-8?B?V3pzS2Qyb0RDNlBoM2FVYzJxaGwra1BUUE91YkhoMjdnMkl4eTRZaUk1bnJs?=
 =?utf-8?B?bWNEQ3piZkFYTDVLSHY2ZDFNSEQ4VFQ2LzY4eWpkNUE0NmZ5OExNWXlBOU10?=
 =?utf-8?B?T2hUQ1JOa2p1MGRORU1hZERNZkVoTnRBSW8vR2swakV6ZjJSTmd6ZXZSZHE4?=
 =?utf-8?B?ZTVVNi9yZFgvdTBGNUVnaXo1amtoR1lHeUlHLzVoVDFOSmZXeFBXd0lUQVNr?=
 =?utf-8?B?TFFWeFNSbHkvT0V1Q3d4Y01VOS9pamM5eGI0akZQV2FSdHRmVGM4M3UwWWVQ?=
 =?utf-8?B?S0p0QmM5c0RQNi9xRHh6Z3ZlM09DQWx0c08vY0Z5ZTZaVm9jcmMzeW9sdVlM?=
 =?utf-8?B?TkVlQ0JhR0JyWk9qL3FhV3gyeEZQRTBNQXNTSHJZNS91NWhuNER2MUVROU9J?=
 =?utf-8?B?aEJrWlF1R25haWJ1WWRITmpQNzFGcHc4UGh1RVdrQVpYWWdnNHRHdWF3NHZO?=
 =?utf-8?B?dzN5QXoyMkp3ZEx4WkJRVW1MdUdTeW5QWTQwZjVEZjVISlRuK1YxTDB0WkRi?=
 =?utf-8?B?RkNCbnJNczYwWUxmS1ZVUVdMc29VVmc0bU8veUFKM1UzeWwyNXFVT29WR08z?=
 =?utf-8?B?Q0lXSTN5bEZjY1FjV2lwODU0OElxbTdLMHFNeXg0eUtxazFpRC9hQ0JwVHBQ?=
 =?utf-8?B?MVZhWk1kRkEyVUtWVllaMVNWbjkvQTZoaHphTTN2eGRvTmFxT1BlK0JVWkZL?=
 =?utf-8?B?eWNZdk9MY2JCQ3B3ck9rTkQ4ZnNXYnlBSm1Ic1MrNDlreTFPaXFqNjJNNUNM?=
 =?utf-8?B?WlpGeVpPRzBYTTJQU1Vubk9ja01xNkg5UGdoRHFTWVRQZWJTSXd5ZUFIdXgz?=
 =?utf-8?B?WmxzQVRoTnVZQmhqZkw4R1JaTmlEQlZxWVFJaXMyVldwZE5wYk51dVlrMm5V?=
 =?utf-8?B?d1lpaEZ0OVBKTndQRFd5eVZNVTFIN201VGx6Ulo3KytvV2dOOUc1dVhsZE5E?=
 =?utf-8?B?UHpEaUhmSlpRbFlNZXJrc1phN2VOS1k3Ny9uTUJtWXZXN0YxWEFRVm9OdGRI?=
 =?utf-8?B?ZnNjK000VVdwMDNERU9ybW5lVTVOWVl2N1pkbk54a1Avb01tMUpZL29JR3Z1?=
 =?utf-8?B?VE1meDU3K25LL2VIQXNQRzhmdngyajh2UDRaQ1VjcXZXdXhZTmpCRXE1dExo?=
 =?utf-8?B?dlJwM0dzMkUxUURyRExnRFVnRVNSMThzNDhvc3E1anZCc1NLR3h5b2pZdThS?=
 =?utf-8?B?WTVQb01RV1g3UXRRVWFnUjZaeFZRY3Ryc1Fvc1dmN1Y0Y2h2dFErSy9WeGg1?=
 =?utf-8?B?REp6UHN3S1VlL09GVnpNV3RTQWd0c296V3gyZGhNNUhidFFmVkhXWEJsak1E?=
 =?utf-8?B?ZERzZ01QcUNLT3liak5rcnFMNEZ4MndSY1V0VkJCVVZYNFVjQ3E0QXFNTUJ0?=
 =?utf-8?B?R3NRSXU4ZnkvWXpINm52WS9lV3pQTy9Hd0UyQnFzMVpzUm5iWHlaaXJ1dkNW?=
 =?utf-8?B?cGU2YkxLUTlBcDJDanhYMG9iNXB0aElyZEppVys1VEgveXF4RzA3eFpMYzc5?=
 =?utf-8?B?QWNUSFVoVnREazFiaW9RYmRiTUl5YjRGaHZuT1BxZDNuUVVia2VJblkraTBC?=
 =?utf-8?Q?E4OiR629eV9yT42lUvUMMArFKrfUNNs4nruCL?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OqKoNfte/egdoV/unaPNjKIQB4YWZ6lQ9TVbdTuMMr7bS7vwdCNjpKI8jB5CdR1JJFHPsEcucSeUJ/DhtJCHfTVP0LUvoZ9cT5UiDDCSrLNt12Lzf9LvA54EHmK0/gqcZVUVxBlOdLCzGLxZ1kD0a3PFwqSVEIiAjdZd/fkDtNAr5oNp8/PSNs7SDau08dTqb1PC7liePJRLQwpjk7dlSsfG+dLrtuS2FmNdE5aHOaX/NpPPcaAyKPkKKabTnZTDNxcilKSD7ac2tFiR3LUUdSYhOb04V7yc0EwWrrS89xcBAImirO5DiX6pBzx1skuaHtY3EPzgIyPddvOlQs1EFxJMXynddzlan7/OFacLyKVVXJP5o820g1yJ5FwJl2qTwtANso7LEkSkUlgXg99V65vV9COStejSgU5LWEODQlJ2OL4HPOApqlD3Wu7uCvG2mzQrl0f+J0FSAw12ScIFWPiGNGooQuiFQzK/YYRTn9ZCrkYAStn5GVaTGOcXe2/6t/JXdP4vZ8cYoPZXdysGg7trE7mEIVx8vgwZRrDAIRvk2dKUs3y282AMSSpAwdGkVCK++Ixjt1+R4rB3dM8QaFGMWQXyFXYMWfaC9O4glLk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aeea3347-7a86-440a-ed39-08de55153824
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 15:37:56.0160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BdM+HFilN6Sc6teWTKvNVDN8HNwyql09zTIMWBDPQoonaoWwekOw83hbylVcFQH2U+wpeyDAWkjGVR3AZNd5S3fOkcgP+AKIiA6qgG0X32GJo1+c+4umcyT2Yvk9N3cu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7489
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_06,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601160112
X-Proofpoint-ORIG-GUID: GPMbBJiSTLoxaBZvq_HWchGzamijFk9a
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDExMiBTYWx0ZWRfX+RwZqWaKoTB5
 luuK53PN8kTd9P8S4nUW0FzjU0XmesTLdtKrT7ADrvkGtfDIfcROwgnoTScAMU8maD7Qfk3FTkA
 LmHR/NPcB3KPQiYf+p63NFaqwQ5ajYmZqIuafRhzaFDl1hJGVHwqsdR+paBSboGTgtK4dJzMUiQ
 XlSGwcALKZ08mosM5PRJMAVBWfaIQa3ph+/kuOUiLzi5/M26VlBh5OHImlEP0fBqX8BJU0w5YH6
 WbxeopPtOHmN3kV52H+/YB9s5m2yJbkKQrpbAncAm3egAr7IIqjDOb3wJ/tQL5nOAo0SvYKZIgi
 KzC6MaIdSUVHnQzKycdG5HyFoMAnAtKIHAi3iWteVnQDqLbLxx+LPokQywgj4JlevytUvxZFws+
 Pho9H1KQRr6BR/VLpgxqn0NLC+tLHj82Z+lm7colysN8CKhcFN0yGDCFVj4Mn8TkfbQpkz1z/nR
 zhWRBBWWQGdctpNn9zw==
X-Authority-Analysis: v=2.4 cv=J9KnLQnS c=1 sm=1 tr=0 ts=696a5b7a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=yLgqrl2s3EH9fNXCsX4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: GPMbBJiSTLoxaBZvq_HWchGzamijFk9a

Hi Greg,

On 15/01/26 22:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.66 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
