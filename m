Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8624315A
	for <patches@lists.linux.dev>; Fri, 24 Jul 2026 14:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784904772; cv=fail; b=qUgi3bPsZDiWnmE+WrnGe3uh0r/bHPVKXI9q1iM5WjSShs9+ZlThpmYpWTSqxeRgVF9jwq4+7GLoifVg5O7ut9Yl547jPMwqgOhRL1W8mVRohOPPzw8TXfDR8eomQVrZLRFZxvpHoGwchSUQjtA2DoHxjU+WYe1UZ/gHziLk9f0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784904772; c=relaxed/simple;
	bh=jAv+TU63tU13ZB5vJAt9A8lIEefy98iNVKH2avKsxbs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qNqNZWokiyfAFUzLFvB1gmibWTNdw3VjHsHE/rmQ8jqUpbMMopWzdSvnBuhICDNJv+s1sGFmUpdEVzXEsOwaurW3TwlAeBL0I3VFBNY7AD1lyLnD2JtEMX5lpO0wCr0BQ3F2SahgS1700Sy1qq2gXzR9Bi4OonM2E9M8UR+jxwg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=m6f3uGLY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nGAN6iRM; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m6f3uGLY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nGAN6iRM"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66OCtogD3340143;
	Fri, 24 Jul 2026 14:52:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=MWkyXFLbROZlobBYUszcIhBoYCv3zsKQoCCLhRCJwyo=; b=
	m6f3uGLY/6Hl8o0u3Pj2kI7CFfU9hOfMzIi3kMl9VY8vCxaAj0RmM7qhhQ9oP4nQ
	d/N0Qbtz35AF7dkkhNm8jOutjp/qTsd4Ba857jmYr7iXyfb2C+XVNsEK3Zm6shCH
	c2Hm6alzcZLWThnrCO4Fw1uMYCj35BneLVoEQ1qFsCRldAzWzO0VCCdzPgOSNZFv
	NbPbmWioVEbQLUeAxgsf9R8R/Vyr6PYDXftNevU6iuRNJIGz33o6W4HdcgWpMo5+
	1Em0pOjXMf/xUjJ4WcCy+DjGQmeCqXGJ8JnWNmiUkpQFz5rhBOiKdSA/R+Vo0WiS
	gavYGjRGduxZXneHACYI3A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg21q8puw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Jul 2026 14:52:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66OEmcwU009898;
	Fri, 24 Jul 2026 14:52:46 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012050.outbound.protection.outlook.com [52.101.48.50])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxtsxje-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 24 Jul 2026 14:52:46 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=delg68tL0pznYEk3mQyIMHmjD2Ge0r6pLVLT4fKpTaB2s5Yx7uA72tKQJFN5vB09/loDpVLJ1Rj7BE2WN2UfmqJ9jBiTJn9uDI/VLhNzdki8lFHBxeQi44i0UV6hNPsK/i0umYsLwxHaVr2FbKcksW9lP/yOs67VG7NOzo4erg58m1YXqUGFy0kJetBZ7pPBfg0/Sz3JOPF523mpd9b/hnQblO2nImgSlCJkaxMUCmS0j+kBKkgYn0XNYzIKZ5nm6X0heH4vQsDFoASHvkp1qT9NggXJGmnoaB6uXUtFQUpu99e4dS06kh0sMtWlIFyXG9WnRDqgdSohERlLZe2/7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MWkyXFLbROZlobBYUszcIhBoYCv3zsKQoCCLhRCJwyo=;
 b=rOaO64B9imenUwgZ0RUQW5XH6b9qRFbL/gIHLkH7NYqob3SC3riPZINWeZmC+6WuU9Mh4/C9fTZ+mWUy1r3ccYfTPMuy7GQ+PhBNPt0/sHll7YO0P5vPPb5u9McGJ6lesanAG8gEKqlRn5PmIjoXxK0eXl9K+IkV8ry9GpXHskNePAOksmNLrSfpme8Pw9gGuLX1Hce3GcTJevbKO/ZFFkKO0aWmQb1o0JNBtBy/Rw820ouWJ2BP0TqTHcgAkNeNOj2Tar0Tf5yuNg1AfDCpHwp4mTSWVwltiZNqB5O3DCQVBkY6uTrs2+5kUJBngrzcGJuF6nrPYnoPgHedKT2wuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MWkyXFLbROZlobBYUszcIhBoYCv3zsKQoCCLhRCJwyo=;
 b=nGAN6iRMeGOGuH/CF+iZou8bEyJg/FL6Y4vYH6uKSczTrJ3l7lZPY2m4FtLheUmKMV5b2CiCG7uil3bG2/mbSmXVkSxyIvnKuQf/mysM1GlNjcQHj9adQXaAWiXPUWDpQy3ERcafEkzwYCuBzgXgqFshUQWKw5SdOXPSrQ3PhaY=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by CO1PR10MB4561.namprd10.prod.outlook.com (2603:10b6:303:9d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.12; Fri, 24 Jul
 2026 14:52:40 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 14:52:40 +0000
Message-ID: <59f6db07-e73e-4f78-9016-1dacea0efe10@oracle.com>
Date: Fri, 24 Jul 2026 20:22:35 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0820/1276] arm64: dts: ti: k3-am62a7-sk: Add
 bootph-all tag to vqmmc
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Judith Mendez <jm@ti.com>,
        Nishanth Menon <nm@ti.com>, vegard.nossum@oracle.com
References: <20260721152446.065700225@linuxfoundation.org>
 <20260721152504.415619146@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260721152504.415619146@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0090.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::23) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|CO1PR10MB4561:EE_
X-MS-Office365-Filtering-Correlation-Id: 491ed854-dbac-4f78-9b89-08dee99335cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|56012099006|5023799004|4143699003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	mV3EvGwvhSWi1Z+LznK3hNDXj9pYPYauWqbIu+cnK/82lIMUr+jgN1s5QaTXjPbaUwgt/gj+yn9Sf0wBm1m9y6Se11fvd//9ngSmG5Ljqt+apmZHw+8nVQ5M9hwROkoJnQFRF1J7I2F/IppsYsHoYemWF7t7XQiXBRqMPHbVjcedw+oZm4pKAZWl/R+zrhX4zKGy1EQBUm40Ud62ycgssz0uB4qA4zcD5hMtEMBuav3/Jejq4Hh2nxo9aWvXdKsMWZhRlvOObfENV9AGZf0HUI6AALluLINsmx3S+rNHIchv4SEV5zwIuIU2cWoeBj0IRaDxHBaBnY11UCG4VhpHqP9fnpQFQ1r6nuw2HTsBQE6ayfEM+yNaxWi+ycskDj1dpoEsaTe4Sazf42+K84n15vK7bA2U8TkKrzwtKHZzTHJc8OBtQnuGL/szHM2dfNVvv3IeVtenFjQIUZ1rVWouObnqR37lFU8QM811a6W32cJH1PYqdXcfX0BJtlAcfmaRu0a4YqwgD9Tx0LaB1BqlcSo0r5P4b5iwGhjmu1wd/snwWjuplHEAGflE6O/ZUUuw41yV51kjx92qrwd2cCEZKFpe68aYsDsqS1Cqk+HSjPckfPd8Hbo//Dhkcc7YWxY1
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(56012099006)(5023799004)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RmN1VWg5Zk5sOTJWdGw4cGxFNW5uK2tOYno5NFpSSnRCSDJlWHJTUWZtc3hP?=
 =?utf-8?B?d3FZcEJTSGVZVTRMVmxpZk9QRDNJNTBEUW8xTTBNTE5kZElYOUlGbFNjTmdQ?=
 =?utf-8?B?Y2IwbUlmRVppdU5vdy9zK0VnVXppeGJWYkFSUE1mYnZRazZONEhXTGdkaDBo?=
 =?utf-8?B?clV1YmIrZGFRT1Z3cjZDbkNuSm1CcFVTdFlKenJLMXdlRXpQZXJrRHhoZCt2?=
 =?utf-8?B?TFZ5bjdYbXpVMEF5QmI1UGUybmRwWDFSWGZYRk5wNko0SWhaWjFGWWRNYU9w?=
 =?utf-8?B?aXBpNnhKN2kyblVaaVlSdzBjYWNPSXlTcU9qL0g5eHFYUkd1UVVVN1RpaU4z?=
 =?utf-8?B?Sk9WZEJQdzJacUVWak5kZXRDMU1yN21RWVlQTzc5RldpRzlkbjYxY3JtVVZi?=
 =?utf-8?B?Wk5rV0ExZlZCV2kvdmxsSSs5RUFJOXpEdmFXZjZZTHlkOVBza2pERGxGZVcz?=
 =?utf-8?B?MHVWaTdHM2x3MExsOEhxRzVjdnVpYXd2dW9JbFlCSjg0K2lKMzlpenBWWHV4?=
 =?utf-8?B?K29YLzdvejFDWkhiZTROV1Z3c3o0YzdpR3lKQWQyRUVnRFhoVXBYQUpOZ0pl?=
 =?utf-8?B?NnpXZVozYWcxUXEzZ1VMUFhNZVI5VXRyMUdTTWtaTER3b3JSRnZyQ0wyRlZq?=
 =?utf-8?B?UEVIK0FnTGUwTy9nb2hCQkFORFFHcmJpY2NRcnVnaTQ0TlBDTHBFcVZSNXEv?=
 =?utf-8?B?NTdPalZrcVcvRVhwa1FiODY1eTN1dGVraWJFREdsNUFDMVR6TStlSHB3Rkpy?=
 =?utf-8?B?Zy9ickZaZnJSK0NBYTVVazg1aW5NZDZzZEZEWU05YU10ZHdEeW9MOGhhYnMr?=
 =?utf-8?B?VURHNGdxdFhyR05XdUVrb1FNT2p2OGhkVmFpeU5FajdRL05QdyswRmRBclhB?=
 =?utf-8?B?dWd0bmJnem5Nb05RbzMrcnV1RW02dStKenZ4aWpEM1BTanhwZ2I1UG1RbGRw?=
 =?utf-8?B?M1RJdEUyTGRXaXlZa21jK043N3M5SitqMmFMZ1E1UktLVGJSSCs3RnFhZ2sr?=
 =?utf-8?B?b2J3Um5rWUhXNHhkL0YwMWtGUjlyQlZLNElTOFIyZUE1dWFiMEIzbFhXcHBI?=
 =?utf-8?B?aVJGSTVzTEVEdWFnT0tpUFVwNVM1NXJlZ1ROaG94bmhkWThnQTBhY04wbnN5?=
 =?utf-8?B?QllXNHc0MU5WL2JMZldFT3ZyZ0YvN0hhMTNrWE51SjZlYkllNGsvN0N3eFVY?=
 =?utf-8?B?SUlOMFNJQXZ5SG9hQ3owVTBwdVdUUS9tNE9oMkl6VEJjRm5NUHJvM1F1aFh2?=
 =?utf-8?B?MVF0OEEwZE1yYWxVaTNjUkJVTm96VUFHSmtoMWRLVE9jQW1jOEM4YmR4ZkNJ?=
 =?utf-8?B?aUY5VWpZRkJKeXZCcHhiUmNRUEZsUDkyTUhnWXVtZis0aWltaDhNYnB3VjB6?=
 =?utf-8?B?VHJmbEQ1eXdlcW85aDJEZUZmcWpJSzViK0drTXMzeUtQSDNaK3VRY1padzNa?=
 =?utf-8?B?aC9UQ1haT1hlK2hrci9lU1JMR2xOL3lNajNNbUU4SFMxVFlxaTNCVmMwRy9N?=
 =?utf-8?B?ZEFZb0xVUk5qa2hzaDRqQlNvQW40UFNZSHVTTDl4VTNSRy9oaHo0SG96ak16?=
 =?utf-8?B?UTdEQ05OM1JoZFUrMGtkeTAxTVg2MjFYRW9GME5Ucnc4UVVieW1qdmk1VlVq?=
 =?utf-8?B?elBZNTdWRTNZcmU0bDZIbTlPUDhFZFdHKys1Q1JENDEwem1XYUgyMDZhdHc0?=
 =?utf-8?B?S05FS0JEUnlUcnJZZzJVOXc5YVMwdU05elBYMGVFNUVQSC9VYlQzQm4vaVc2?=
 =?utf-8?B?VFRCTzR5eDhJeWllZjhXLzBYYmJha29GZ0pXaE1WYUZuT3VBVERXdUdNWGpB?=
 =?utf-8?B?ZGIwd05BbTBSeGl6TlBZM2VUNE5JZ3Z5SjR6RVBrRWVFY1JCRmZNMzNVL0dq?=
 =?utf-8?B?djVoNHNJK0FmZTI0TCt2WEhUV2svY1R4aWlWcXhnemR3czFCaEpqVWxTV214?=
 =?utf-8?B?U2pHaVhzS1RFbGQ5aGdJOEtFSDY3TWNhQTl0ZzZHaWNHM3R3MXZHYVlKdm5P?=
 =?utf-8?B?VGJvakFpeTJ3ajJORHFuZG5lR1ZVdmZMcVVra2plWVRCNHk2c3pleUhLUjlk?=
 =?utf-8?B?YWtBaHFxbks2Zi8xdUtQMFF6K0dCUk5BM29pQ2g4eEVnM1NFYzBHNUpCc21x?=
 =?utf-8?B?R1VrNFpSNkNTd0dyZ2MvekwzSGx1bGlzUlJZNzdURXk5c1Znd2xwK21qRGx5?=
 =?utf-8?B?eUlyK2tjYkRQTFg4cUtucDBnMzZ4WkJTU0tJaUxZVHZqd01OVVk1Zm1McFZh?=
 =?utf-8?B?NUVPVDY1c1l3R1lNajc1c1NBSzRVaklTWUxBeFQzTThncFdtT2JadUlzY2NI?=
 =?utf-8?B?Y1pCUTF6T1ZGeSsvYm1HdXg2NXo3SW9iRDVjZ3dZR2IzaUJjMk5Ed0pwWTlX?=
 =?utf-8?Q?WU8fzj5ojdRPNCh/Vlpk1+pIhL8x78WZokJol?=
X-Exchange-RoutingPolicyChecked:
	ZiZVovHbaXRO8PUft2Qvv3CcjIjo+TDgfehiSb8rN8JlI3GtGttn3W74+kKOd0LylFfvIO4n9btJbsBx5aNs9EDzkZWKogF6W4POJvtK7Wib0opFJW+kCNa1jdhvVyGZVizOFwda7ngepV23gHFnswoyfgPE4SEZk8WFrJrIqEfc8mXwQBZxGHyoxm98LHopy8f5R9VcP7P23EsrZCC1P9pEDILuaqSaihE8pLuPupxyKqOg2C1H/r33koCaBMF5TCmUkeTad3sjwuSkMWioZN5LRRbT41AesWxhYE0h5W3E3v2uH46YQBXwgANo7tIEsyIhBYuAex9LQjS/EZQDIA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Hzqdr6RXF+WY9gEYNaXowBT1iZIPvsnPiT2gMmfeaEya3ky6PWOSi0VFojMns1Dtdfbq9JDjvd0UdNagaEiPvmcXE8qBE1ql+XmG7C0vaUaBfNdZK1CPcqZc02wpjc2OArXlyCZ2+j4BT+uefvI+1SrV9MXF/iDecCMCVwBB82OY1Yg8RJ1EcjgS4HM3GoCTuYkdLEpS0ncpGIcvxf10tWMK0Mm0GpYjB9h60y+1SimLdO6ntPke7A6lW0T3kYN/NQbWU9/1CWWGP3/HH3JtAy0rPgjvNmzCZ+7E0z6BZk1e0gK7ff5WmuPQWDovzdpYs4G0/OU7fOy+fP7f6IklgQaU/U/qHuS7bBUKkmnxZyrMZSbiJlFkG+I4HUFYGNHncTNAeLbXltZPT0pxmXjxqPDh4SWOOXCuxwmbGhh5jO6Z0XSybGto6NEgK3eHLZZCsN1t8nqBqMTJ8acaGgnwH6jUOagQQYQXhQysgcYT/vCw1i1DZIGxsy3ehRRwMmpsH2tiMzs03D4KHGU6dtpXRzSChlrCTLKkHBiaDMRgwwiU0JML4OwmzhFm4PjEVIOprDLYg0lcjzgzSdWXlaH3wuTbg/Nf0guBI11JXQKKVp4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 491ed854-dbac-4f78-9b89-08dee99335cf
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 14:52:40.6691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2OE20V04aGpg5bo7ChFY7vpjf1m45HgXCy3oYUSqAY5jhiWc32pOdwzq4ZNsYNC+cYJPJRadmQ0jtTlBXaBgFGrbzsmlLaha8PeUqOwdQKEnJfzn1MR902DcT00BpVR/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4561
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_03,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 mlxlogscore=752 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607240134
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDEzNCBTYWx0ZWRfX35MLqRDcmYsz
 IYbi5jDtkXmYPPUSMoGNVHQNTsOPzKMD1MFfLyrecg7OU/9QPetSav72ErsCRLCQFZQnsZQtYW4
 z5dveXoxC6Yhj3bCrFtt3qRjnzYCYvZGaQHHFDftTU8HyzLfyi7Rbn2gI2IZBPXG3+neah+fYVl
 lD0reaT9SM2MILAhQTEqHWJti9ZZDqfTVARxaOqTc7lIBot+sQ4FEDHnXip2RdLDp9Vun9RWRH1
 1ESqSV3NW/Isif4cg5yS+nTqfkypdWGdbCA21eOZ+FXPZN7/XWQumVrMitEamtt1t6B3WnFYxSq
 qymJNBbkEy7nLfdLWgLdrxjc622cQJesE6mdJLXqlk1cPq2bbZzHziD3gnE+mNZcERKeBK4h3Qj
 oawMs+/IbGIeBk1Nv9w39sdoGJTcb+1yQgZ/1Zlq+qGbs/iqDIi1cl0ei93QKPj38HqY+MwMDbf
 L4Bc+x4GvRRViPHVqCsIFhFXfEzIa9I+H83RTGkU=
X-Proofpoint-GUID: aNx1-aD0yZh2fGhiDScEpTiesyWJ2QCg
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDEzNCBTYWx0ZWRfX3EgGhtFYyLdG
 ZfNzRvwYPm9WV0CmOpoJCyy8THHI0a/8QDsqegRuAHmxsPU2fzhzMFSBeK549YvqL1mjCYu9h9e
 +leWFjciynKQQ18KQD+AuDiXCXvoRy/SbIcYnNovcAex14o+TyS+
X-Authority-Analysis: v=2.4 cv=ALkdLnG8 c=1 sm=1 tr=0 ts=6a637c3f b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=bC-a23v3AAAA:8
 a=sozttTNsAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=L3XiUZ5n6R2OrhwilLoA:9
 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22 a=Yupwre4RP9_Eg_Bd0iYG:22
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12115
X-Proofpoint-ORIG-GUID: aNx1-aD0yZh2fGhiDScEpTiesyWJ2QCg

Hi Greg,

On 21/07/26 8:51 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Judith Mendez <jm@ti.com>
> 
> commit d8fe8442366ffd8306575028bda92389d0dfb674 upstream.
> 
> Add bootph-all property to vqmmc voltage regulator node and its
> corresponding pinmux node to make it available during all boot
> phases. This allows to run tuning early in SPL stages of boot.
> 
> Fixes: 8f023012eb4a ("arm64: dts: ti: k3-am62a: Enable UHS mode support for SD cards")
> Cc: stable@vger.kernel.org
> Signed-off-by: Judith Mendez <jm@ti.com>
> Link: https://patch.msgid.link/20260324140247.1200631-1-jm@ti.com
> Signed-off-by: Nishanth Menon <nm@ti.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I have run an AI assisted backport review and it spotted an issue. I
have taken a look and the issue goes like:

Upstream commit d8fe8442366f ("arm64: dts: ti: k3-am62a7-sk: Add
bootph-all tag to vqmmc") has:

         vddshv_sdio_pins_default: vddshv-sdio-default-pins {
                 ...
                 bootph-all;
         };

The 6.12.y backport leaves that node untagged and instead adds the 
property to the unrelated PMIC interrupt pinmux:

         pmic_irq_pins_default: pmic-irq-default-pins {
                 ...
                 bootph-all;
         };

The vddshv_sdio regulator's pinctrl-0 points to 
vddshv_sdio_pins_default, so tagging pmic_irq_pins_default does not do 
the intended fix I suppose.,

This is probably cherry-pick fault ?

I think 6.12.y should move bootph-all from pmic_irq_pins_default to
vddshv_sdio_pins_default, thoughts?

Lets drop this for now and redo this later , vddshv_sdio_pins_default is 
present in 6.12.y

thanks,
Harshit


> ---
>   arch/arm64/boot/dts/ti/k3-am62a7-sk.dts |    2 ++
>   1 file changed, 2 insertions(+)
> 
> --- a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
> +++ b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
> @@ -134,6 +134,7 @@
>   		gpios = <&main_gpio0 31 GPIO_ACTIVE_HIGH>;
>   		states = <1800000 0x0>,
>   			 <3300000 0x1>;
> +		bootph-all;
>   	};
>   
>   	leds {
> @@ -381,6 +382,7 @@
>   		pinctrl-single,pins = <
>   			AM62AX_MCU_IOPAD(0x000, PIN_INPUT, 7) /* (E11) MCU_GPIO0_0 */
>   		>;
> +		bootph-all;
>   	};
>   };
>   
> 
> 
> 

