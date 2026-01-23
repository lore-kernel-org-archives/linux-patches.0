Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE943EBF06;
	Fri, 23 Jan 2026 19:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769194849; cv=fail; b=k3qYEZ/eARu6kOxwwn0VlDsIm7dmLjepMhbfnLY2q7e2z+HhSmX3hUAm1CmsQaye26y5wJHWYa8uBTYRlK/cvW0x3aY/l7XuSxT70RUNYbAZptxI20tGW/VDaD7kduo+R/MPzxZhcyvgsanIPTc4R5HiTTTwAG8XWixWN672z6I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769194849; c=relaxed/simple;
	bh=RHEoFNk4Q2Yp8ISOynT8kUqfYrpPd9v7nLGuHZ4B/Xs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HnHkx6ck5XlnvVoE++l+7MaCzONHxP2kY0rx0VxPN8tbiQq0R2GCDW1hkpkyskgsor9U7ERtDDamlNdfXqrocazjwf3zSf5OTMOvS7V4SXpOn8lH1ppZYtzhESNbjwpuoxNxUKnWjMmc+a10wxuzP6KvrwuhBgIFcdS/m6sxaNQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cqDvP8TX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lP+5kd19; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cqDvP8TX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lP+5kd19"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60NFPKJ21631817;
	Fri, 23 Jan 2026 19:00:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4GMZSL/U3KydswSc/aoMvZAZSXeKCI4MsC0Afe8UR5A=; b=
	cqDvP8TXXA2enmfLAH5hq8Mi6O/+SVCzInOSXRnxq4q6qKR8HjGN+uxWKy1EfVCL
	amacWJPr21lfcYf+Uo95DjZjA1DtyVo7JMRveCMsM1TASwFTjHyz54cyoxmBtWTU
	qcpWpgzm33eny6xO6oHkzrue57fS18FhaRzYj1G52h+hzJcJuREfbZFfMAMU6l9M
	P06OvIh9VaPYkzDAn/5yTQz1pjMXyG2FbDThMquzjPKSVLyyyI1FpmwPYY2NAfgw
	4AbKNKpJICVesAATT078y0oozF+36SoH+tf3Sc3eoE1vSzdrI0EEQLoG66Tgmwtg
	PTaIsjY0L7l76Dqho6Hjmw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2yq2usr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 19:00:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NHi6VE013534;
	Fri, 23 Jan 2026 19:00:40 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010067.outbound.protection.outlook.com [52.101.56.67])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4butv0t5a7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 19:00:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cKSaFm8oJiVZrm1p7M8oFLUiPplRniTFPvfkhL1MFNxM2ZN4mi2Yk1/bpHKFZeFUBJZ/kSH/BI2AlDN/bh56j0apIl9Lx7mVFKUR5h61Z655DGKMhij2tcs67fby2ilE6ropKPuBQ36s+i+yLiPSJfK1J7gmJBP4i24gKOUkfpgaWYLDF3mELjhMgIHLMqay573OcaVFTmzg+vLKDb7lXw7Q6Dz+1Y9lb8Mac4P47di16eTO/eQu0lzBR1fgkBakgy8hYT1iQKM2/U8fwf7XRyuDm+7qFf+HjOeuGmFrSYim3tmhV54xWLgeZIjKMfDrdkR9yiiybFd26J089gj5/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4GMZSL/U3KydswSc/aoMvZAZSXeKCI4MsC0Afe8UR5A=;
 b=JTjAyjb+bfr5vliJ9fBsgB6JrwE9JMmkblaQT391gXTojgYiU9rzkeSOV4dEVN2Faz608L3t4u+crXuwcnprbJcpBMsFrSAXUGY77z2nvELbIYi2tuhKoOSyQHVwzervzTe1y4fm6vbzCKnsqk2Q7b61KUEMb7WNcVNkP6Px2XKuVx2OH41fUeXqCtKJEaJNTUm05h0D3jJNJ9OAyWoFO3NWX2pu4m0E/zaS4pdb9WXtmKpa6aTHeiw/KU0sYTS8Rr6nbGo+KDy210Bs6dPDTvFk5zLRRy3QyFI9T7oGT0+ylYMznPEQUFhh3FL0VSo2PcnKFONpxHmRrj6xs0Arkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4GMZSL/U3KydswSc/aoMvZAZSXeKCI4MsC0Afe8UR5A=;
 b=lP+5kd19/bIR1xR8SW2uAXxU2BnXfAFOeBvpF6v6nSSsGcod/NJOOcOrVY0V+V8w1QSIsVu2g5otg5K7exQ3AIOh+HAgWTaAsZjHjREU02ZG9UGtApS3heytESd6NCzrhKPMzciao2p2yCA3rY1Cae2MP33JrrLFZnPEbUXJRAU=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CO1PR10MB4739.namprd10.prod.outlook.com (2603:10b6:303:96::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 19:00:36 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::4083:91ab:47a4:f244]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::4083:91ab:47a4:f244%4]) with mapi id 15.20.9520.010; Fri, 23 Jan 2026
 19:00:35 +0000
Message-ID: <ee4ed62a-da6b-4bc8-9219-1757a17efb6c@oracle.com>
Date: Fri, 23 Jan 2026 14:00:29 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 393/451] NFSD: NFSv4 file creation neglects setting
 ACL
To: Ben Hutchings <ben@decadent.org.uk>
Cc: patches@lists.linux.dev,
        Aurelien Couderc
 <aurelien.couderc2002@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
References: <20260115164230.864985076@linuxfoundation.org>
 <20260115164245.151340252@linuxfoundation.org>
 <ac4bdf4fd2952f95a300b027f705dddffbe54a1e.camel@decadent.org.uk>
Content-Language: en-US
From: Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <ac4bdf4fd2952f95a300b027f705dddffbe54a1e.camel@decadent.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR07CA0057.namprd07.prod.outlook.com
 (2603:10b6:610:5b::31) To BN0PR10MB5128.namprd10.prod.outlook.com
 (2603:10b6:408:117::24)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5128:EE_|CO1PR10MB4739:EE_
X-MS-Office365-Filtering-Correlation-Id: b456c7c9-5a57-4df6-2f5f-08de5ab1b074
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VHB0QjYvQW1jbEM4UDZoVzNEeVFUd3FTdWZKYVBKMDJrdDFMU1JjdnNCQjQz?=
 =?utf-8?B?OCtFSmF2ZE1JTWpjc05wQVpOb21ieWM5VlZpcWVuZTIrRkdpVU1pR1l4U0Q1?=
 =?utf-8?B?ekl3SFpJYm95U040YkJpTjFybUZVSXBlTWVPLzZKK1psNElYTXFGdXZLZW9M?=
 =?utf-8?B?ZVpydWEwN2NYUm9RNEMyWWNKWHpwWWxGeGJvZHd5aWdualN4WTZENjh5ZWFp?=
 =?utf-8?B?cTVlZ2pYdDBWYWszVFpXd2diNHRmRjRjdHJsaWltM1RHeFJ0Q0h4OEh2UXBw?=
 =?utf-8?B?TWlYc2RhYmc3UlRURUNjS2VWK0VrZjFmR0REOVBZdEZ5MnhjK0JkdE0vcWUr?=
 =?utf-8?B?QzJKb09jNm1SSENpVHVSM0JYOW1FRjViTU81TlE4UUhKdFYwZ3Y0Ty9QaVBq?=
 =?utf-8?B?N0NNSDlzdEZGUFNNMWNjYXFCSDZ5NXpoNGpocTh0eTMreVF5RlA0dUs0MlNB?=
 =?utf-8?B?MnlqVC9YTFRDa0ZET2FWMkJOcDJDc3NKY2NUWWVmd1JwaGpSZXJoYjlSY2wx?=
 =?utf-8?B?a2toaWs4alFmdFFUM1RDb1ByWVdEVjQyWXhHZHZiRzFubCs2SElzcTlxSmVh?=
 =?utf-8?B?QUpKS2VMMFl6Mi96Umx5ZWs0VEZNc3JCOVpuNzZhRGlTcHBhOG1MWFovbUNr?=
 =?utf-8?B?eHY1OTQ0SG8wSE9KTEhNY2pvS3lORWZSRUF0OGV4c1N1cnZTWkdqRk5laXc2?=
 =?utf-8?B?Z0pWdXpLRXNLVWVRT3BsWnJTQzV6SU4xb2x1MTFnYXJZd0tVNnBJNEVaWTRN?=
 =?utf-8?B?elZqVWZyT3YwaUVEMnY5ejZWOWlObHBhZVZUS1VSeXFsQXVQeENzNFpIaWdJ?=
 =?utf-8?B?NkkxK0kvckw0ekVhNjc1TmhsbWlDMTl5U1RzQnZ4cldFSTRRd0o2bUl6aDFD?=
 =?utf-8?B?TzlOWWZsMS9qQ2lieUI5YjFFWXU0MnFGQlYrZklnRW9IUFF0MVRybEVBN21E?=
 =?utf-8?B?S25xcUhqWWg3UHZTWjdWc2VnaUFnWDY5bGx1a05vWWkzdVI0NU42cmVINVRu?=
 =?utf-8?B?WkpDYWsxTnowUlcrV3EvdGhqVWVxd050MGZzQlBwK2xkRVBaanE4K3N2bTll?=
 =?utf-8?B?amRLS3FGa0c0Um12YnFlQStYVFpreE9jZG12UzhVbEtheGRxeHFFZFRNSEJ3?=
 =?utf-8?B?UVNaaXU3RTZnWEo1L0RJK3Q3RjhEYjl6MHJPNG5KN095dXRGQ1NJQXFGM1pY?=
 =?utf-8?B?UjUwZnBsQmcwOFJCeXNEU2ZScjdNSlZ2TU1UVThJZGNnajBlWTkrTFZybGYw?=
 =?utf-8?B?eUtmUHZvSkRqTlhiSUQvOGdsZ244QytHM29rQjdEMGEzdEVSU3YwRWNuZHUx?=
 =?utf-8?B?WHJxODZCL0lTMjcvZmdwVEVWYzZ0cWhNRDBPeFFya2ZNdDJLTklNNmJHNkFz?=
 =?utf-8?B?VHVHaUUwNHpqS3FuVVZLenp6OWhISzNXbkZEaTE2NHB2QUlGTVgyWHNkSXFm?=
 =?utf-8?B?NXQrZ0NZbnFjSG9kekxuNTY2Y2R0N3N2WGdaT1dVTGJJTjRrY0tzY1VmcWFq?=
 =?utf-8?B?VGJ6bHlGb2UrRE5qMzA4aWxmQTk5dnVFNTZNZWgrcVRTKy9GWVI4QjFJMVlF?=
 =?utf-8?B?UnRkOXRhQ2JJMDNLU3doeVRUWm41d0ptMXRTUTFVN0wyU3lLZ0dYZlh3TkVY?=
 =?utf-8?B?QWt2dXJRcnF5N0lZWG9rN016Q1NYUmlGSzNFbDMyd0pqRHpvVXBRb0ZSMWxs?=
 =?utf-8?B?QkMrTHY0RUN1d0M3ZE1NQTRJcjJuOVYrYmtlems3eUswbkRyR250MXVQRmtt?=
 =?utf-8?B?WUxBZTAzUkZ1S3VUOGhJTDkxZExvSUNBY085b1F3VW1vazRvVTVXamJnMTdu?=
 =?utf-8?B?cFd3MDl5OUs4UDVDaGE4ZnhTZ2d2bW9Ca1JLcTdIcERJd2tKL1Z1c0dSSUp2?=
 =?utf-8?B?Mmw5YVFvbmxIMGp0Unc2ZHNWUE9hVE9LQTBBTHgvOHh0ZlBPd1dIWGIvN2Fq?=
 =?utf-8?B?empzNzNCTzlBbkxYdjIwR0hwNjFGR0tjaUFoNTJJdFJuRWRWVFJUT0RUQTZj?=
 =?utf-8?B?d1ltVU5rRWtxWDZkN1hlM2puTDRnbFNvUWVQaDVoL3FCTVlBZzZpclFLZUt2?=
 =?utf-8?B?ODFxdkJib1B2bEN2dFI5ZVR2WmFRWWxUazFnTUlWSVRiS0hDSmMwamtOTW9N?=
 =?utf-8?Q?Fux8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V2c3R1Y1K1dyWlB1ejVhcHI5RUxyZk1yL2NEdFFTWjdjcnA5NUE2QkxiZjZv?=
 =?utf-8?B?TEFwb2RlaEVQcFhxaUZyVXYwN0RYbGFtcnlJbEs1Nzk5QnVBUjI3dmtWelM0?=
 =?utf-8?B?UkVMYjRIcm9PVm9UcWJ4UWQrTzh1c1JtZlZrRkV1WFV2aWZ0OEdHa2lsYTIy?=
 =?utf-8?B?cUpqV0ZvdzdwOEwrYmg2L0ZCZFFTVEVMOVZ5Z2l0cmNQRzZwVHFIWEh2YmYv?=
 =?utf-8?B?ZU9KTmQxQXlzbEg1ZThCYUsxclAwY0dhZWRqSTg0dDdtSU5ObytaWTIxMVhh?=
 =?utf-8?B?ZC82YUF4V3BwcG5BdnByUnVzYU5xcW42SG9Ib2lyeDk1bGZ2RTd0YVU0VzBw?=
 =?utf-8?B?a3puQ2UxTWJKcTB2QVZzQ0drRVhZZ3Q4Vy92ektFSVlVL0VXQVdrQUpYMXVG?=
 =?utf-8?B?WWY1MjNxeFZzaDR3ekR5N2VYd21DbUx6UXdYYWJtaDFydWRPNmVPZmRicm8r?=
 =?utf-8?B?R2JOU3ZrR2VqSEt4NjNjbExFaWxwbFRNVFBleXBXRGJyb1M1cGwwd0gxSEdi?=
 =?utf-8?B?RTdTcUJRT1BqUXNaRjlteVpEeUFEell3NDNQWTJMR3ljQ1J0Wnc5T3YvWlY4?=
 =?utf-8?B?c1VVLzFneVZndy9WTEU3a0FtSzd5OFNjbTN4VElvUWJxVFZlM2ZSRFdwMnZG?=
 =?utf-8?B?akdjRENSUmRvelZWQjZmNjI0RTFISW1WaVYzamRUOFQyOFFLSzV3MUg0eGtF?=
 =?utf-8?B?RlNqS0tBY0lodzlQZnpEREY2MGZUcUxSekdQODczQ0JuTkxFaWpqUGNaVlNj?=
 =?utf-8?B?Mk1nVmM5QjBpaFRwQmhrT2kxQklna0VkWVg3WDZkeHNqZ1pmZ3RLOFdybk5H?=
 =?utf-8?B?dElySU5BV3dZbkloVFl2eVRlbEhTdFEwMWQwRmFrMStCOTVHcVEvZE1MckYz?=
 =?utf-8?B?TUxCeml6c2VnSjJCNHhsMmZKS0h1anlMRndhU0R5NkFYN2RtZ3hPaHFtVEps?=
 =?utf-8?B?Vm9hUFFld21ML3V1QmsvM0h3NVd4cTNHZW4rUFNpQzkrVm83V2JSVmRDM0xn?=
 =?utf-8?B?STFlZk1uZGEzRlBkejBvcDB6NDEyQUpERXoxUENWZWkzd2k5QkEvOW9FeEo3?=
 =?utf-8?B?ZHgxWTBFQVdvdmxlMFc3QU9DQXJYWXhEQlRhYTJKNkd3VHEyWldCekJGRzFE?=
 =?utf-8?B?cUhGbHRIdmplNEg5ald6SG5ubnhSY1JsdllKWURvNVVLR3NObGcvblNRTGNK?=
 =?utf-8?B?UGRhajIvS0ZqQkVuN1c0eHFoNzlaRGJPWkk2VXhuOEs1bDV4RHdObWtHK0NG?=
 =?utf-8?B?cnYydllMNkUvWXpWbEVSVzdIU09mdGhTME9kV25uaUJYc1ZtRklTZzZkZnJ1?=
 =?utf-8?B?S3NIT1Y2L2Q3dCtpdVluaysvdFNTRjJkQWhVOC9ZWUdaU1o0SGJqUk11N2Q2?=
 =?utf-8?B?OGRCbHFMMmVIbmRnTnJyem13RXQ1RXFpeFNwTVBWaElPcWdTSm15Yks4OWVN?=
 =?utf-8?B?cC9aTWU5cVNnYlVmZmRacEpGQjBrc3loUW1DaUk4cmRtd2dicWg5eDN4dEJn?=
 =?utf-8?B?K1JUZUhieGVKTnE4UlNhcHJQS0dVRzd6elZrRGMrYTE0akJlVU0rZE1vZk1v?=
 =?utf-8?B?d24vNi9wNURxMkxicFl1aThJTUlXTWlzMXJDdVUrWjJPUWZCMWF0YVZTOGly?=
 =?utf-8?B?cWlBdzlIZGFHTHVqSXJIYThSWXhOV1FNT1lHUXAzTFNLMy9yaVZOMzFKSVBn?=
 =?utf-8?B?SG9WSHhrYmJlMmNkRkdvL3NOWGFldEUvbC9WRE5sOXVrYnhzbkhBTFl3Zmhs?=
 =?utf-8?B?MkpsTWRld0YzMUJxbk1HQlZVamNRZmZmUWVJMXRmdXQvT2V3bGNWMGp0UXdO?=
 =?utf-8?B?cmdhUGlWaGRNcXRKQmJMUFVHRFJjSFJKVjdUbWkvbkFLNndjR2NWK3VLNlA2?=
 =?utf-8?B?ZEUwK3B2YjVidnp0a2JWSG9BQ3JOQnhuMjQrNHVmaG90SE44VmpNMjFGVi9Q?=
 =?utf-8?B?Tko5TjZpNk13UVRVMUs2MUthR1RlaFlKK3V0ZzZCN2RUQ2Y2c0E1dmR5Nnda?=
 =?utf-8?B?UXBCbmJSeXFpajhreFQ4RFFBTDV4Y0pHSW83YmdjZklWT1VpU2c3NWhmRjRj?=
 =?utf-8?B?WHhKTWNHMjFFaWdrTkhqOWRxRE5VM0lSNEdjOGllRW13QUJ3QVlYbW0xUHU0?=
 =?utf-8?B?REtjUEtWR0RpcWt0SnFqaXZ3OGpWMElhWGtsbDVNN3VmUmlLaGhDUzdHSzc1?=
 =?utf-8?B?cVh5REdwNUNKRllCWnladzd6NDBCRTFnUnhnNkNmdkNRU2NxZjkzNGJnYXpu?=
 =?utf-8?B?ZG5qa1RrV1BRTHdqQkZISzlMaHZEYUZjMTh6V0IwTHQvZEpRQitoL0F1Tzln?=
 =?utf-8?B?Ryt3SmQwc2htR0RjMlJsMzdVeFFyRm1WUlpET1RVY0FpMWJTTVRJdz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+JWgel8fjZvefX87Ii3h5p5Y/LwxHHWcSK9gbcXdBPJxpA/xjem4NwTCar++k+Y10QU7qyWhQJjOHm8hso8uUGq4dKay7vOz71v+yO0iMe8JVo2gMZLg2Rr7pptTNEKmLZEWqN7C+xQ2ACB/FsqLv0sBUGwosq4Ewahx3tkrw9AHxJgmwdH7Lktw3J7sAdyeS+PbEncT8ZBjXvbg/ZetED/bDnbdxfQU/A07E7NDXMXsQHWR1Pmuy3pMKthycI+R8OrWuim019Xw96ZiEudEqmBDMKlfx88gWWsxF1eaLMJS0HRoEGgynwQZo9vic8LRDScXrCvODL414LuivRsUOXEBuN9D6tN3qIXl7knKhMxWZkFYPwKr6wIxRQJ1/GjUZ7WD64Uvy3xZwBJBr0DWkJYygeXSkMF3/PpPWo1FIbvjFr6oQyLYuJaPQdnUrzDnwQgcNxYNhvNvaNl4TVoj8t+xXFr22211w8WB+JNBSfhHyCXr8M/tW07JJq8ncozuzigQvObZzWnbY3iSWr2ou2Sy3s91OowJFulJAUeHJ6xxhp7/K50QkQS63dwroym7aoiZMTAparjtsqs4+3E7VfflbsuLIA0xE618ZHZ6xAI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b456c7c9-5a57-4df6-2f5f-08de5ab1b074
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 19:00:35.0446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WDYyGOPqG6cDGSKskLFZvcCUUTkGfBAGP98dqiiDCxtilOf+URs4p1aDM4RGKkoANXAjHQeLUyRzZzMtWu0ruA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4739
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_03,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601230145
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDE0NSBTYWx0ZWRfX71yyE00Qzwdm
 owCxq2gevygGVM0bCoQGvCImxSb/FEerUKOr1ZGNW736hUtQnmdFPSJ2sJzlJK78qDULGciO/ru
 qqAmMdd1QAHk3cfvFhhn3WIRmj14eN5CzapG93Ia+fcxQc0CMXOlWiP5RuccRnIbziPvfQMNVE0
 AJNQljPlA9WZ1yuePx//XKle1zx5gUnFwLhZqUVnL0rvN/VxQA2YbR28EApGy6lbDbQQnGMFMcf
 xOmce3NmeoKcOjD2RrQfiyku8PNl5vkirpfjQGTth4ms87w6xyQF+18uio30IL71dMIfn8nGxL+
 EEJOfHCfMI+FwENnpsNd90ofjG8T8aNJP0WNpkjA5M1LPQpDkJEfFZFD5fKIRymgJDs8gfg+QPs
 CE92bgrKuruzkAAM2tlCk/ZhyVA3EZNG6BtF4n1Q4R+/awgKseR0TGGjN9ebwfTQ0fGJwmvsLZv
 VX5qqV2inkv9imcSmMQ==
X-Authority-Analysis: v=2.4 cv=de6NHHXe c=1 sm=1 tr=0 ts=6973c559 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8
 a=dxC9QWALQOsBklYfruMA:9 a=QEXdDO2ut3YA:10 a=EBa_rOYxF3VBboPlVeQ_:22
 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-ORIG-GUID: lxgvVnaMOAJzAhc4xQXmUVp64yvphOfs
X-Proofpoint-GUID: lxgvVnaMOAJzAhc4xQXmUVp64yvphOfs

On 1/18/26 1:50 PM, Ben Hutchings wrote:
> On Thu, 2026-01-15 at 17:49 +0100, Greg Kroah-Hartman wrote:
>> 5.10-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Chuck Lever <chuck.lever@oracle.com>
>>
>> [ Upstream commit 913f7cf77bf14c13cfea70e89bcb6d0b22239562 ]
>>
>> An NFSv4 client that sets an ACL with a named principal during file
>> creation retrieves the ACL afterwards, and finds that it is only a
>> default ACL (based on the mode bits) and not the ACL that was
>> requested during file creation. This violates RFC 8881 section
>> 6.4.1.3: "the ACL attribute is set as given".
>>
>> The issue occurs in nfsd_create_setattr(). On 6.1.y, the check to
>> determine whether nfsd_setattr() should be called is simply
>> "iap->ia_valid", which only accounts for iattr changes. When only
>> an ACL is present (and no iattr fields are set), nfsd_setattr() is
>> skipped and the POSIX ACL is never applied to the inode.
>>
>> Subsequently, when the client retrieves the ACL, the server finds
>> no POSIX ACL on the inode and returns one generated from the file's
>> mode bits rather than returning the originally-specified ACL.
>>
>> Reported-by: Aurelien Couderc <aurelien.couderc2002@gmail.com>
>> Fixes: c0cbe70742f4 ("NFSD: add posix ACLs to struct nfsd_attrs")
>> Cc: stable@vger.kernel.org
>> [ cel: Adjust nfsd_create_setattr() instead of nfsd_attrs_valid() ]
>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> 
> Would it make sense to also backport:
> 
> commit 442d27ff09a218b61020ab56387dbc508ad6bfa6
> Author: Stephen Smalley <stephen.smalley.work@gmail.com>
> Date:   Fri May 3 09:09:06 2024 -0400
> 
>     nfsd: set security label during create operations
> 
> ?  It seems like that's fixing a similar kind of bug, and would also
> make the upstream version of this apply cleanly.

"nfsd: set security label during create operations" does not itself
apply cleanly to v5.10.y, and neither do at least four of its pre-
requisites. There is enough missing context and functionality that I
decided it was better to simply apply "neglects setting ACL" with
adjustments.

The question of whether "set security label" also needs to be applied
to v5.10 seems independent to me (but is still a valid question).


> Ben.
> 
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>  fs/nfsd/vfs.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> --- a/fs/nfsd/vfs.c
>> +++ b/fs/nfsd/vfs.c
>> @@ -1335,7 +1335,7 @@ nfsd_create_setattr(struct svc_rqst *rqs
>>  	 * Callers expect new file metadata to be committed even
>>  	 * if the attributes have not changed.
>>  	 */
>> -	if (iap->ia_valid)
>> +	if (iap->ia_valid || attrs->na_pacl || attrs->na_dpacl)
>>  		status = nfsd_setattr(rqstp, resfhp, attrs, 0, (time64_t)0);
>>  	else
>>  		status = nfserrno(commit_metadata(resfhp));
>>
>>
> 


-- 
Chuck Lever
