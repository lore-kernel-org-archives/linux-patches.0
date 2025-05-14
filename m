Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D591F416B
	for <patches@lists.linux.dev>; Wed, 14 May 2025 05:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747200253; cv=fail; b=lobyYmf9sWNkijVPI7QGVwm+24zikrRgyJvmbgk7BDKs9wtvQrmRhenCSdgl0oSIgHuSu1PUAvXPCo27W+4VUs25wXP6fCTRT9ZhVgPxXO3um14Evlg+g7atcZyVVU+0mU1mUn1q0kDS6IcwuVvW3/hxuuYlBDZiB8A03WoTnKk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747200253; c=relaxed/simple;
	bh=NbRrUPWT09eJmfi+tZyxyZg13rIBhZxFiCYwIAUkp4Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=u7sGnJZ8EIiCPIMrPzcm+NqghKTZun+fy/zg0d6njqmOZ4LCtPcAEdKhY/8ytuTfJdHuSwUPAM5fwsH5aNIHAYZrLBmC/S7CvaqCBDQHO5XfuqlJt3hRx48DSfiQSiAS1SsaGG9XPZ61xQ8BQMqzihoAAkohp8gi41fuLVAhX14=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lJr7UkzC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=I0Kyi5ST; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lJr7UkzC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="I0Kyi5ST"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54E0fr1K020269;
	Wed, 14 May 2025 05:23:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ihPrm7zvyHpIUO/hboI/QyB9/Yk+eMrS4Jy36JQRqGY=; b=
	lJr7UkzCn0LVoey2ra8zOJgoA5pV6ITXrf0rkJjQ1RelCCPVgLFXUBlk1CUUxIrg
	17Q5ikBprHOXl1VMQK0dMbm5BJ1znMpVhvC6ALGpbzb/QRNJJOl+wSTg+GDWooxO
	ZFga/PUTDxlsl/EgNlUHsu1+Ghl//23dfRCuWCYUuCcymROeTOYIuhSIbp1tEH1F
	5FD4SnH1DvQBS2GyiD8bez21ndD/wYXNUvck92cA/yKf0O8SU+avJkQT2zvNopWc
	FMB0b3u2lploKJrpqMzaYGUTp3sBaEVPlDWdAF5e54FCFMngGE0bXGhR/lqp4hLp
	SEy6cCQKKj/0enuMUi4UtA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46mbcdrscp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 05:23:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54E2cpet008968;
	Wed, 14 May 2025 05:23:52 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2044.outbound.protection.outlook.com [104.47.70.44])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46mc6w73a7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 05:23:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TfaAp1yXNfbW9Mn1ALCvNekx6Kk/OLp6altu6m7lLvBV7bzZXATo8qdlxIcv/yrmAPwsEGKE7MJ8vb2wtLm7rh49e4FsoFkWodpQEeGxRDH6GfT3I5kBY7ppbk3ZtQZ+jr7ZotdKHX2hPvWimVLvoSMP3bybf2JqyNDvIspZ+Qi9XKzyU8qCs3JF0hfGCc6YdWonbUcRCv3jMrVFAHXYkdqISpmi1BbAk42XvCTAzQQhz9/iwoz21lQt11R1I3e0Gc8eKmk1QVLAY7XiQSuXWIYJ1JmO3B7lc/GNT4KxUCpwrBUW0EIcy6bib4oZscMXmBei8IT2ivb0XZiZGAxdig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ihPrm7zvyHpIUO/hboI/QyB9/Yk+eMrS4Jy36JQRqGY=;
 b=IAyK5STcQoRWE5Fiz5t1KjqwxFcbkrty9v1d4EAc6xDgC8FWqKFLQ109Ei57DX5MufEJwwwD0yCRF2xBVBSwZxjdQ3PtClFehBCth8teQafSnGqMimvJ7LQJAh2RtFerrDcPqj+OrvsjrbtN+O16biWALFcyVGxybFHKN1Hr3NnWuWYwUHjjLPEUCIAbQM4giVtQ27kGEUspTh81ks/4BLkApifS2ZxuC6q0ayVPz/IIscwSlUJ01gnVGbTIYYcXU4BHQMaCm88T9qkrb9SKaosNdOb+mzwBBGBlvAnj4caTlCaGD9ZxvI8xYHqbcuTwXvoEH5W5tAgtdxtCU4Pu7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ihPrm7zvyHpIUO/hboI/QyB9/Yk+eMrS4Jy36JQRqGY=;
 b=I0Kyi5STZFchSaHhPuDC7CuKJ6aD7kQci9yvMTue3s2gqPkKlQ1VPtRSR6y1R94+URA2JwNJt1Ti8tGMxMUHfgflVhsKW7NTKZ7IBqjctUzVUKm3aUBMeceST2GXUSYaBUsNWPNBS/gRoQN3AI5g+o67K/WHTBtQplXnDtLhmtA=
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com (2603:10b6:a03:3aa::8)
 by SA1PR10MB6616.namprd10.prod.outlook.com (2603:10b6:806:2b6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Wed, 14 May
 2025 05:23:49 +0000
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af]) by SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af%2]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 05:23:49 +0000
Message-ID: <e051b221-235e-401f-acc9-d032ac1247b2@oracle.com>
Date: Wed, 14 May 2025 10:53:39 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/54] 5.15.183-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org
References: <20250512172015.643809034@linuxfoundation.org>
Content-Language: en-US
From: Vijayendra Suman <vijayendra.suman@oracle.com>
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR03CA0116.apcprd03.prod.outlook.com
 (2603:1096:4:91::20) To SJ0PR10MB5437.namprd10.prod.outlook.com
 (2603:10b6:a03:3aa::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5437:EE_|SA1PR10MB6616:EE_
X-MS-Office365-Filtering-Correlation-Id: 575feb50-ddae-49db-2b9c-08dd92a781cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YzFOYUdsVUNGQkl5UHBQYzRQUnBaUFEvMy9pNnZwYTFnakxrRTdFbDN1QXNF?=
 =?utf-8?B?SFNaeFU4UjRvVHdOeGF2a3UyeFpWb3p1Qkt0SEZTaURtbTJ4ek8rczR4L3Y1?=
 =?utf-8?B?ZVYxNlRwSmxmeTNkeWJTZndyMGtyUmVicHYyelRKQ1FKeGk3N3AwaGVtQThM?=
 =?utf-8?B?SXY3aWQwUjlBcVFWYmpyRm0ycVRvZDhtZHFnVytyNlpxd1h1Q09GVkhpeGxh?=
 =?utf-8?B?ZW4vZStkY2tKa09jWDg4WUJCaFhVd2tudVFOOTBlaTY4R1Z3TXorSW1sU2dC?=
 =?utf-8?B?VHR6ZEE0TWgvSkhtWUxQYmhCL1N2Y2xQOHoxQkwyZ3o5ZSszbXhuNHFnZXlz?=
 =?utf-8?B?R2tkOWFxTmo3ZER3b1cwcjczeFc3N0sxNHdCa3R1Q20zSGdVbStIeXRDYlQ3?=
 =?utf-8?B?TDk5d0RxdndDZ3JmbWwzRHVVZTRzdDh0WlNQYWhXNTdHQzdVMUZRTUhmMXhi?=
 =?utf-8?B?Ri8wWEVyRjkzVGFPaWxaWXNQZ3V3Uy9VUDB5NzMxUlc4dWduem5RZlg3Zk1t?=
 =?utf-8?B?VktyK3dEWUZITXI0cURhRlRSMXdVRldFNVA4L3ZzaVdXSlFlWDVVZWVwSGVC?=
 =?utf-8?B?aXFVcGpoeGVjVW9qYTg2Z05FYjhoMjRCYVdhNG1YZm40c0tFWW94SmZYb1Vk?=
 =?utf-8?B?d0dRYldyK29xMUFtMUdKVzNCRmF1ckpKdE9ka3pXNFMxejlKMjdoZS9nbHpl?=
 =?utf-8?B?UXE3V1FRWnR5TWNIdmJjYjBxZDZoQVVoWHZwSjdWSXpwbHh2bmhsZ0NVU3VB?=
 =?utf-8?B?dGtrNW8wY3I5TzlpWVRhZ05Ib2tBRmtzbzlVK2tDWlppL2s0QWZhRFhGVitR?=
 =?utf-8?B?ZTFLQ2FtY3M1WHlRM1lnaDBrR2g4Z09ibWMwaHZiNmtIdGVJRVl5V0tJalJl?=
 =?utf-8?B?SFN0MVpXSndmMGJuY0hPYXBWTFB3a1NDMHBrV3cyNVpOR09JOUVQZkhidENw?=
 =?utf-8?B?UWp0aFRnaUxpcE9vVTA3eTYyakprV3UxTHJZNWxWRWx5SGsxMy9tbzV4Z3RU?=
 =?utf-8?B?a0xaYmhGemJucXhGOFBZSCtKbFdjR3ZIdC9pSDFpb2djdE0vb3J5T2FmYk1s?=
 =?utf-8?B?cGNobU5MRTVYNWJVQzlZSkwwV1Fob2NiVmNEbjJZa0ZZaHp5a3lYZnNxZGFr?=
 =?utf-8?B?N3lPWEpyVnhNNnRXN29lZHIzNDFQUEZINzBhQ2dhUkNZSnVYZnRhMDdSRmNW?=
 =?utf-8?B?M2VGQ2VkMVQySHZXbnFJbyswbi94ZzhRZ2VaMXpyb3VXdkVRQlRyRGlaT3N3?=
 =?utf-8?B?b0h2ZzFQM0ZHSDJRWUxEelQ4QWRCWG1FTC85S25vei9wMitCZnhvT2d6Wm5t?=
 =?utf-8?B?ektrTmF5WU1DNUdpV3lnT3NEME1pU3FBQ04vaW5iTGdLQmJwNmJDNGtXc1JM?=
 =?utf-8?B?WDNJYWpINHZWNkQ1T2RKZUpiRFFtTHJjTjh0Y3RpZEVjakdkaUJ3b3hPTHF3?=
 =?utf-8?B?T055dEZUL1pXRllObVJFZytLcTErU29PbGhFcEo4T21QWXFva1ZsRFpOdFRV?=
 =?utf-8?B?aEFUbDg1eFI5SkxlS2Z5MW03cElIMEV1cWd2QlJ1bHcreUFGNVdLaG1Mdyt4?=
 =?utf-8?B?L3pUT2JDRnBXR3k3VlBvZGxXY0J2YmFYZzFMQ0RpQkdWQ1RFQnRYckpmYWRQ?=
 =?utf-8?B?cGU0emJBRUhpaVF3aWdIMzZNZVl3K0hLV0pUbU82RVdrbkkwMVNiNWRtaW9w?=
 =?utf-8?B?MlNxd2JCU0xsTGdpaXV5eFY0L3BOVG9EdVB2UGQvVG9NVDhqM25kRTNzeGFD?=
 =?utf-8?B?UUVlSjlqeUpuaURrYVlNL1I5VGlzUkRxQ2lkVTduVC9vRmdISkRJRFRyTFlK?=
 =?utf-8?B?UlhZKzVkQ2RqaURuVzBpN2hYQ1NwVWVObndENlJPVHNuaWdVdnYzMmJ2Sm5Q?=
 =?utf-8?B?eWt2WWhWN0xBZ2JuRDdIL1grU0h6emZxZkRraG45NkdESWI1eE5wQXhnaFk5?=
 =?utf-8?Q?GZWz4H6qSWk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5437.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YWprOGhvUXNGbkhzWWt5Z1NHeWFFZHhBQ0h6T25rOSt2YUhxWFFuZWkvV1lS?=
 =?utf-8?B?eVpGQ0JMdWJJdW5MVmFIZVBkbjdlS2pUNk5XYVY3dFRmWjNHRlhyYWNpaS9x?=
 =?utf-8?B?VnRZRG5OTUE3WTVXeHlFTlVKaXJhNWd0UmN5UXpDR2RYNkczVGQ1c2pvaGV0?=
 =?utf-8?B?VEJGZ1ROZFlYc1hDYUdLWm9RKzBXOEpmQTZDRmg1TFB2V2VLd0pqbnBOQjVs?=
 =?utf-8?B?YnhjSTJqekVVUWRxOUJqdGhWYnExVTE3eGttTnQxT29IYVlHd3R1aGtITXFw?=
 =?utf-8?B?ckd5ZjRHWk1ERnRTYUg0bng2NjlRTGNEODkyTk5vdDlyK0tWd3NUcXp3b251?=
 =?utf-8?B?M1p3K3puMjVJUHBYenNHdmN3U20vbVdFNFd3bElpclJXNEtDU0kxNlFWeWhE?=
 =?utf-8?B?eGZjY0tYU1EvclZuRDZoTlRrT0FqTlJYK0NaUmJsU1ErT25GUFVBNUdFMVN2?=
 =?utf-8?B?QkRUNndaTHRWcm5QVXVObHVxQmNTNmFqMGYydU9vN3M1TGUwVzlzaXpXQ1cx?=
 =?utf-8?B?emhmV215QUdUR2g0eHF6Wm5DSmdKeEQ5aGVBOGJVUXozc2NIMGJmYVY3aUgy?=
 =?utf-8?B?akNqdlNoVW9iR3ZoZWJPaUFVa1YyTzYveXFYNmdvM3RQalIzZWlUMlpMSS9s?=
 =?utf-8?B?NnBFNW05Zm1EUlVUREFHRXg1emNydy81Tm1vQmVxTFZ4S1ZxOWVCZ0JwbzA3?=
 =?utf-8?B?em0xMWdSQlVUL0ppWStwUTByTWp6ajRucjRGekdQa05FWDFXQ2lHU3VaVDlx?=
 =?utf-8?B?SDN3bFc1QzV2c2ZMSkpRMDJZckhMa1hjTU43alJVQzJwNHZiZmpGM01WK3VH?=
 =?utf-8?B?Y2NSb2o3SHI4TEJsRWlhd1dxcFZoNExLa2Nvd1RUdkhaMlVkd2JRSkJpSzVD?=
 =?utf-8?B?K09iNGtpZmRCQ2JKd3NXWTJrUE5pRGdMQ3k1alFCRk9BTnV2U0JWZDAxeXc0?=
 =?utf-8?B?VnpZazQ1TmZFMHhqNjNXSDVCK1JIeVAwbnBWVlVkRENwUlErNmduMWM1SkEv?=
 =?utf-8?B?Y3Nwalp2VXYwdDZxZlN5bkliWlcvckROdXpKcklmQUN5NVUxcGYzblp3dTZW?=
 =?utf-8?B?b0VBcGptdlBHTmpxd3lYMk1nVTBQQkdqbHZKWE5QOU13TFFWcitmU2dXdEJC?=
 =?utf-8?B?UkdNaVIrdDJQVGR0R3hEb2ZJVmhkM09mbnhhT0tJWVFGblNKT0ppMGhuYU1q?=
 =?utf-8?B?d0tVWWg0NmN1eUxnV1FjaGh6MjRTckJ3N2tjYUtTTGZIMGU3SUNhbFEySGFs?=
 =?utf-8?B?ejkwcjdRcityQW9QZFpqZktMTm5mTHBrdC8vRnU3MjJSSHlYVjNhNk9GZ2c5?=
 =?utf-8?B?VVBkWWhQYzB5L0k1SlRwUFRtcVF3R0dMZk8zcHJhZXp3NXRtS1RFV0NsMHB3?=
 =?utf-8?B?Q2NWR2hqK0lmK2JXOVphMTFDRXoyNWtDQ2Q5V0VOU2RtVE42R09INUh1Rmky?=
 =?utf-8?B?c0xjSElDTHZWb04ydUVvcGkvamtqRU5ucG5aeEJ6cUtOV2lRU2NBdHRPVVh4?=
 =?utf-8?B?T1NsQmQ0a0xyc1h1U3pGdEt1aU9BRHU4VDJnZzV3bVlkbUcwTnhPTmQxMVQ1?=
 =?utf-8?B?Vnk0YmVIUHRTUkp3OERZaTdBVk9IVmM5ZWhuUFV2Rk9XVDJET2tIeGp4dEYz?=
 =?utf-8?B?VUVKQzBzNGV5NnFyM21Kbko1Q043amo3cGw1N2hZMVVZV05Eb0U1MFRUQ2dX?=
 =?utf-8?B?a2UyQTE3R1ZhK0JwdDhRZTZYVGlHUzB1cTlsY0tEMEZrQlJZQ1lwbWRBaEZu?=
 =?utf-8?B?L1ZMeVBSSGJGdXFHR1RaMmJhTGxpejFTYUJTRUxTSjhFWUtnTVc1M1Z3NVFE?=
 =?utf-8?B?YVBFSmdpMndibm5FekwvaEFaQ0RkdlpFSFRjMXVZK1FvbkRCcUphNnMrQ3hY?=
 =?utf-8?B?WSs4a1d5OElYZmh6c2JiMXUvQkRLWjQ3MXJrcUR3bklBSytjRXhWZG04dVNo?=
 =?utf-8?B?VkllbmxHNmZCQjg3Tk1wUTRGSTNXM1ErVWYvTTFkeXZpMlJRUEZsVDFLVG1U?=
 =?utf-8?B?TmpKbjNXZHlmMFZ5Z2NiT0ExLzhXc2prTm9uUFZkclIyS0pXcldpTElMOTIv?=
 =?utf-8?B?Ym1Yd0l4R3pveFdLUEFtckQ2VWhWa0pRRklTUWluMGlueHBVaEUyWjRwT2hO?=
 =?utf-8?B?N2kxWFhYMHpObkFhaEFKRTV5SFhNNm5hMWxid21maHdGdVNHZjM2eTJ2QmRQ?=
 =?utf-8?B?MEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QQqSKZ1MxRmVmB8GwS6wB1JiwwWxVRy4bM3pyMmWNllSix0XaAHFEHbnRVy8LdJ+SCzNQhvgUq4cdfNXI/1yVo+WEgw600+NpfcQ0a3VXmLuAhdDiLAjPgpm9HERFgXrXzBEnr6m6p+0gOslrElvc6/hJTtvbPQr+5pJrhrIoV59N5PLLEE2rP+9HKsDUOnFXDHVQOb+N8rbnSjecbKAOM9C0Q36mCqdSkwDv2n/fY2IVw62zzeQDOzHmw6zhI90FnrrC1JDiN1H3mRpAwv8BHOuJOqDcZ5bcsWSOYV1wE/ka1o9pCPYmYCBoy3f4xrO+x+UTTqgjSNEfXskhiSwLn900t+UWBpvyzanSevDDfw2Ds7HcVq8qFa/LsNT2EsQkZW8LNVfJ/hLUlk2o4WuWEDd2EdxB9uhalHIy13Tos4JESwOCh+rBHbpj14uJcRgBFhW13Nb46vP5nbFGbrIb8u/Gc8csxBvWkpw5TUs9w+PHmJJ9fiIc5GTrYye+wQ9pRBYTdH0DkL6glhZ42JKpo2GDN3PiBFJVe4iOklELeC/LX1INfQilrl97pGvnuu+T5Vu5mOJ5dHBXJPovJmq/NIg/FXHdBxyFSup8H+W1EI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 575feb50-ddae-49db-2b9c-08dd92a781cb
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5437.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 05:23:49.4407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TTX8sV3ji/6Jsb98opmpqwZQ67HuYE2QhNXMXqJr6Y56YIRPZvLAKpkPnuA7Tb1918YvD8JjWHt3C/uGDgm006L3IzeqcMX8UmHhw6YoAMs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6616
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_01,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505070000
 definitions=main-2505140045
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDA0NSBTYWx0ZWRfXyso9wLHZu/rE wpb5DLk28yeAovBQ8XDysu+uOoDeN7iXzq75HGS3TdS/eDwXXJenVfE5RRRJSjwuOVJkWbJ4kwY 23Uq/GtRAKov1+86bTi5Oio/ZqDZ2jyDOByLS3rTUPufmEpAhf9sm2Sb1waAiZj9oh3CcAc5lcI
 AjmJ+6SfgFq234sUT6Wdw0kBQRvZjknbK1jVhaZlBTAgVc6CM34jNVT/VvqbbtQ1ikCcI4tw68P 2UUoaB0vZvrPINEuOdn4jmKNP6DlbHIM7LY/3HHRo/3da+jh55oX/ZEJJ6H6j2TQW0etV9PpbTR IxzvbX6wXJGH4U8Zh5CzXDqVcscIWlLjOQIza4LwSk3KNZ17aUIYpZ7dbCnunHVDqDsivdSynzL
 XUsesPEFR1M0HQh0XtgwK6XIV4EoE/nHzTB1KaCLUL+tTyuCupqWYRueZBdXUxgd4XKHN98u
X-Authority-Analysis: v=2.4 cv=Y8T4sgeN c=1 sm=1 tr=0 ts=682428e9 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=8-vRK6DNSD7UNujOA5sA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: GnN1DifZef3Uv_QaulhZieayeDkJtH63
X-Proofpoint-ORIG-GUID: GnN1DifZef3Uv_QaulhZieayeDkJtH63



On 12/05/25 10:59 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.183 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/ 
> patch-5.15.183-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
No issues were seen on x86_64 and aarch64 platforms with our testing.

Tested-by: Vijayendra Suman <vijayendra.suman@oracle.com>
> 
> thanks,
> 
> greg k-h
Thanks
Vijay

