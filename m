Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADE913BAC2;
	Fri, 23 Feb 2024 19:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708714998; cv=fail; b=eJvWDQ0HjlE0Zpe4surLOXSRuKoSAJvOG+97ac4Kzk6NBHynky2jU36TxaPyHPMJRBMTBve1w2cLZu3Mxp8kZDR8lti3sQQhSmyyNDKcD+ylGj0soniLJtHvnBNNZ3AV+cBtM4oifgp4vL8UsYLRL7N3CNGKJLM76S3CJ1m+yDQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708714998; c=relaxed/simple;
	bh=cQXO3oIKcjGMwxiH90JXN+ZvvovClvOyt3bS+b+4izQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Y9oQMPEIxoIipy6Yg7Q3a6H7jAqAH/rFShki7v0exJ66gAYqX5KAQNohFa+6VIezXLRQJ505qnZGixzmvZn+46kJRF1rnOJbMSO0R0xaBnFeiHqfNtl6qJTQncKWbD7IuD5eZardUq9smPny3tqmTUATFSB4p0SqC6Kuamv3EdA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kSu0KTxN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=L3JIeNm0; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kSu0KTxN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="L3JIeNm0"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41NG3x8a002919;
	Fri, 23 Feb 2024 19:03:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=0TmIZmxoAZ6fPaGRnOgOGEg+uEnyj9ilIU5vxbNFmWs=;
 b=kSu0KTxNvWdvxpWeU82RDs9i+t2mDJJurSaWGIWs1lwP72clmVX2m0UiO/YRzBZNBBAk
 xcZU7ZhGEFFwV+a5SbsEJq0PyJbaLKXWDN/z7cZkd76FX4T4sV4GBMXiP6scv6b53kvF
 4HPvyRlT600LEL0GMUIqrPD5lA2Ll04TerWhJTBJU05LFmiCNu3k+09VyKqWJQxub6r9
 pJHCnc4JZb7bKb5QlZmKYVMrAEimabXfU1Kgv8USjzIAb57wiif4tSLsKozEB54ckwwJ
 97KWJBzZUQpSsVN8yf5WvConbhQobBI4J0kqaATVC72vNqQY+KH/cI9Wzn+lgU3UNb41 Sw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wakk48gdf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Feb 2024 19:03:10 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41NIuf0r019229;
	Fri, 23 Feb 2024 19:03:09 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wak8cgrju-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Feb 2024 19:03:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K6hONbbbfLBVQpzghrZdsGNm1hSSXyOXsCOLZodbqmU2KPjpjBqpoObuZJtrPOb3gBNmtwRQMPV600fGZNp++5hlJWNO/PaxcsjCMDJJhjes/SLmNBQ4QHNor7NVudteBZD36zPAExj9InZczJI7bzXBVybvvefRlECcjufRmk582gGCdXL00iR1ejdOlcuijFbkkiooNRYAubRGzjn/UhUSjItavLpChRpiFFv0sSpN9g8G+wbz2lKdM7RXKlF1O7fLjjan/ncxea7YKwTQn9ilv8/JwPzN4t6vHkV8wXw69KKNLa5nJvCowwfJhv+kveQqigbMdMO5UAJuPdTVbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0TmIZmxoAZ6fPaGRnOgOGEg+uEnyj9ilIU5vxbNFmWs=;
 b=EYxYQxABXvv/P5z+thxyTbwzPK4MuWXsd1NpE9iEd23XHw4Nu7rklc0gf1yGtSVojVhM5aaRE3b3w+q6b1smqvWgjHNoO3JD4ZZBK+92aUn3QQ/Ch5EmViFTLxrF2fB1lwAmIePBtXsCCeSjUUJr7bUbXOFoV+VOU0x0K1Eg4VS/2l9k09UCU8f9uFasZfhNEyTicfLW7N6YA6zZeLUqJqwFAk3iQWYjiWnDWlB4DHvlhvn3Peas49QWJsuwpR4tX2j0VMkLt7sjuSKQlVoF/hXLD69T4aodAldyfP2guf5J83WsFsa9SPF1xb4ZlTg8Q1pXENjzjajyinwGi4VdGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0TmIZmxoAZ6fPaGRnOgOGEg+uEnyj9ilIU5vxbNFmWs=;
 b=L3JIeNm0ehRprYf0eY/wVA98b/22kKPtfN+L4BO3CKsbGy10NVXwVgg4sEcmLhZ2ZRC5dt0iwzxULqaz+CV+zx4y2dxbmY/u/XW7OIGM02i2wVuHDTX8cyf9JCG4vnIGDThkV0aMjoiq0hoaCHG5RLDe+jMmzmWDC3gb26CJoCM=
Received: from SJ0PR10MB5891.namprd10.prod.outlook.com (2603:10b6:a03:425::16)
 by SJ0PR10MB5664.namprd10.prod.outlook.com (2603:10b6:a03:3e2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.21; Fri, 23 Feb
 2024 19:03:06 +0000
Received: from SJ0PR10MB5891.namprd10.prod.outlook.com
 ([fe80::2b6b:c527:ebc0:9673]) by SJ0PR10MB5891.namprd10.prod.outlook.com
 ([fe80::2b6b:c527:ebc0:9673%6]) with mapi id 15.20.7316.018; Fri, 23 Feb 2024
 19:03:06 +0000
Message-ID: <0b410915-d716-4671-86bc-055abce632c8@oracle.com>
Date: Fri, 23 Feb 2024 19:02:30 +0000
Subject: Re: [PATCH] iommufd/selftest: Don't check map/unmap pairing with
 HUGE_PAGES
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: patches@lists.linux.dev, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>
References: <0-v1-1e17e60a5c8a+103fb-iommufd_mock_hugepg_jgg@nvidia.com>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <0-v1-1e17e60a5c8a+103fb-iommufd_mock_hugepg_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0020.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:151::7) To SJ0PR10MB5891.namprd10.prod.outlook.com
 (2603:10b6:a03:425::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5891:EE_|SJ0PR10MB5664:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fb7f784-0d35-433a-cbcd-08dc34a211a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	4FGFnWbSOWWWSyyls/aPpIQcCINRREEryr6JFQGn7TBXEk3dhu3uYK7H5o68fm8IJJXNt+mjNQOYZuHRaScHT393s9r+mkI2HEt1XtlJIm8EJRmDcBzUkjmwZs0lRkL859F3qYSVq1n8QoA7YBe7DfcUzWR/ABjoTi44qC4vmHoSVIolBWrdxZduQ9qQexWtnuLDXBYjlFxsNE/Ibj0QBm19vJF4lWFPwKiIvQk71PRNp0+MqS+lRPWtLF8lLSf33H3i1haQARd5Q7IuboXYpCwm0KojeGPEOXKIEj8t+PvR/esORQ1QXA6OaSodM8KuGOek1aPTDcMM1+VWzAJwep/hqpRR4w+ldT9AfmLx2D1Pu32pdxbN0xkH8mBeHYh31aprdvd2yYt/1CIEantIKlGqMrftZFzzoLSrNUekIPtvGAE9VSHQFxAXHV7VyDXEF7Vdm0omZHRX583MskjorGGGJs7DmXvZ2fbFi2d70h/HpzUC4fe3nJnNG5WgHZEtLBjFVN/bXQXIXK5pvGRZcaUlbm4V37RrNLcFkuyWdJfHXtv+4AgSg+ZbBHnWNUkJ
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5891.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(230273577357003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?UE5mbDFoZVFkeFpzejNmSEs2TU9aWTFuL3c3TVgrQytBNVZTYTh3SVVpc1pw?=
 =?utf-8?B?S3BMeVNJVVM1SGRucloyY1FZclpnVEtRa3dOcGhhdDh0VzNGVVAvOERlbStZ?=
 =?utf-8?B?Zko2Njl3OXgwQmQ0OUZkYmh1WHlXQnFhVkN4cWNxMGs2dFlFK1RiYzZhQ09z?=
 =?utf-8?B?OGtQenMvamVuTkhUNUNoQ1pTUFRNOGlyU3JsTVZWTkdIN2hxMWZueHd2eXNO?=
 =?utf-8?B?Y3puVzlTaGRkMUZ6SEhjUDdsUEpKR3R2d205OHFkbzZJTUxWelNHMG9qKzlG?=
 =?utf-8?B?L1J6KzRUVlA2elZyUzVoTUlGTDdNcmJzOUtNVDlDUzM4SzlOVFNKVGxKQVdm?=
 =?utf-8?B?Qy91MzRjUkkveGQxWE44RHg3bXdiU2RGMldOYUcyUjJKNXpydHN1MFB3L0Zp?=
 =?utf-8?B?dms5cGNLOGtaVTU4ZFlMbFNGZkR3MStjKzdiMi85a25ibFVYYktvd2tCdDRE?=
 =?utf-8?B?Wk15cXZ0VmZnaEt5Q1M2TjZvTDRlTmtuZHNxNE1vb1ZlbVU0N1RsVnBuZFhT?=
 =?utf-8?B?c2dUMlJuM2FJeDFzaGRybkRqeVhqWDdrVGNWbmhFeUpiTFR0L2dUZ25Ca1ZE?=
 =?utf-8?B?WXdjRGM3V3djcEEwbStPUzd2M29qSnIrQnEwTnpZOStudlFySHJsRVR5aDJx?=
 =?utf-8?B?RUJPNVZvV1l6cGtQV2YrN2ZTTjd1bndZTjA4dTNyaStBaFpMRWREa2ZHOWIz?=
 =?utf-8?B?bXBmaFFBdWw0MTZ0ZHlmSFdZTFRiKzhIM1ZiNTIxNG9jd2o5TjEyTWQyS3Q0?=
 =?utf-8?B?dUlORW4vdEtiM2hmdlNBclJJT3JLeUxiRjkrVWtlcEcvVE1nS3NLcFlkNVVx?=
 =?utf-8?B?NDQ2VDhOQzVnT1I3TGdhYlVqUHl0VEdrUzdSTFp3N3pRSGVyUExFaXhsSWJq?=
 =?utf-8?B?aHBhM1JBWThDbDlOOXZ3NjRPWkdGNWlneU1Cc2Nwcm4vSUJVZzdKaGlCb1Zs?=
 =?utf-8?B?d1hrc2R6YnBvNTNCSm03THRJTDRqSTlyQXN2c3czejVoSWhkRWFKLzlrczgz?=
 =?utf-8?B?UHorWXdPaHJ5NysyQWpFYm1QeGdWWG51ZU1TcGxpTEJxWGZ6WkkvL1Z5M3FD?=
 =?utf-8?B?LzBIaW4walNRanE2Tm1iNkc0dDNacTFMVWErSkZ1Wm1ESCtqeVUyNW9ETjVk?=
 =?utf-8?B?U1hWN0R2anRvY0Y3UCs1ZkdNdlZmSm1lZk1tTjQ1UndGT3BjWVNvV2VxSUhz?=
 =?utf-8?B?MTdNalU0VTRvQUthZGppZ21BbE8yMnhIWE5BUkNHRGNuM2xQNGw1c3B5N2tz?=
 =?utf-8?B?V3RkYlRldnZSQXhsUXZRcHFFamgveUprNFhXcjhwbWVjdURsQzlNVjBvTDFu?=
 =?utf-8?B?Yk5HaHg1VzlsYTNOVUVkWmh6RzdWK3FqV1BjQnJ4cUZza01ZK09XMHhkMzY2?=
 =?utf-8?B?S0x3VC9lb0EvQXFEZmx1RmVxbVJFbzJZdEJTTnN1RmpyVlUzcG1FK05ialYv?=
 =?utf-8?B?dC9WMENPTUFZeWlaOUZRN1ZoeGdENXVuZzVmbHprSTZBcy9rUzJETHFmLzFq?=
 =?utf-8?B?T2I2cVZKT1pWbGtRczdob3lkZ205MVN3b1RoWVY4VjA3UklmZTI5NGk5bEl1?=
 =?utf-8?B?dHhNaVJTZkFPOVlRTkYxWE9hOXVpM292cHhnenJZQzZWRjNpaVpUbTR6V0RS?=
 =?utf-8?B?bXZUNDVqd0FTaVBhVFZHc1c5WFplNDh3L0xPSGJYNGFCN1JGZjBrOEcyeWcw?=
 =?utf-8?B?OGtsMWJRdDBjSnJNcHFxeDUxdlh4MG16cERlWVpMUitON3hBOFpzU0czMjRl?=
 =?utf-8?B?Y0FqbFFEcG5FamIxSlpmenJYMnlZajhTUUpWOS8zTTR3ZE12MkRKKzB6bVd3?=
 =?utf-8?B?Zkh6MEJPQVpEdGo5NWVyQ1R6K1pZVWp4eEwvSU9PNTdRQ08yckhxVFdPdnBJ?=
 =?utf-8?B?QWxrTWJmR0s3YVFOQlBNYm95VEwzTXJTdlVWeTRqdXk5Nkg1MzNaTitOKy9X?=
 =?utf-8?B?K0UyMXhvRmpiOU1UekdndUgzTkNMSkE1K2lkRFQ4NzIvallxZyswU1pob25P?=
 =?utf-8?B?R081b2dGVVB3SW4rNTdpNG8yVzdCZkpWRlRtM1V3U05UL3gxM0w5dmdBK2tD?=
 =?utf-8?B?OGZjRmc4QXBpMlh4NHgzUGVtMzBQenFRZE9tQlBhUVlvbml2TXF1MS9xS0k0?=
 =?utf-8?B?Z3RZOFl3VzlzU3hYOExBd1JqdEtKQkd6ai91WWh3dHFFajE3S0Q2OUcyQ21p?=
 =?utf-8?B?amc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	UreO8ycUn+z3jUO0yBhJKGOdDrf63cQuLQd5BYKeX4ckM2mHOF4Yk/qx23JKLjWZk8yAhUHa+20bu7vBT2DvKUJlMEV4Vf0JRf39K0puFMNEcY6Xp6Ia2IYb4AJpNbOAi3LxkTcskEp81al7R49mqZCqrM2hHziwd+at2X65LCdDAKPkht4DU/9HyXLjoaeGyvOxLTimvUP1wovgxoUOYkzyuAP8l4j8Sjlr8ninxIBcdD4tk/qblOJGqe/KKFPJP7TMxcz4QW6ywpuUPwgIANUbhbu963smb9T8D5PMyynk6JekzPVIXLo6MBuK1QlCCpIVhCGmp3x9NI+I+qobQSinboL9u1ernThds58qxUxbSV7yehy/Jia9OceOLdEdl4l6t9wz1PTFfqwuj7uzTamcteqma6MZvq02twB7Tg9CiPjGrKkpGWw5yjhI9tl9InodSkctcuESxKXjBxzJVrpZL9Eyda8R8RmtajJhdpYMjp9eBJETFcG23G6eNVljKfA75c3lof/jhWVS3pekyw7RmVSjnKzOLmmg4ZkhOw9iSmtCHH11himL0Y4pfuqveik15y9NGRa1ZVrr1MaaWJDnYEzBlYBLGZW9qHIJOSY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fb7f784-0d35-433a-cbcd-08dc34a211a4
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5891.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2024 19:03:06.7588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n4o2wuqtRZp4HYHMrROaJyents70nn+CJPHSxDWUYIHx8VsgA75Gs0thEpVN5Sg0k5Svft4937UmJ4/x5ol8S/CSyC/2XJcWRtpN3riwSgA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5664
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-23_04,2024-02-23_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402230140
X-Proofpoint-ORIG-GUID: ktuadqiVLeTYxZhpjEzLh_bxDHpbeQHD
X-Proofpoint-GUID: ktuadqiVLeTYxZhpjEzLh_bxDHpbeQHD

On 23/02/2024 18:44, Jason Gunthorpe wrote:
> Since MOCK_HUGE_PAGE_SIZE was introduced it allows the core code to invoke
> mock with large page sizes. This confuses the validation logic that checks
> that map/unmap are paired.
> 
> This is because the page size computed for map is based on the physical
> address and in many cases will always be the base page size, however the
> entire range generated by iommufd will be be passed to map.
> 
> Randomly iommufd can see small groups of physically contiguous pages,
> (say 8k aligned and grouped together), but that group crosses a huge page
> boundary. The map side will observe this as a contiguous run and mark it
> accordingly, but there is a chance the unmap side will end up terminating
> interior huge pages in the middle of that group and trigger a validation
> failure. Meaning the validation only works if the core code passes the
> iova/length directly from iommufd to mock.
> 
> syzkaller randomly hits this with failures like:
> 
>   WARNING: CPU: 0 PID: 11568 at drivers/iommu/iommufd/selftest.c:461 mock_domain_unmap_pages+0x1c0/0x250
>   Modules linked in:
>   CPU: 0 PID: 11568 Comm: syz-executor.0 Not tainted 6.8.0-rc3+ #4
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
>   RIP: 0010:mock_domain_unmap_pages+0x1c0/0x250
>   Code: 2b e8 94 37 0f ff 48 d1 eb 31 ff 48 b8 00 00 00 00 00 00 20 00 48 21 c3 48 89 de e8 aa 32 0f ff 48 85 db 75 07 e8 70 37 0f ff <0f> 0b e8 69 37 0f ff 31 f6 31 ff e8 90 32 0f ff e8 5b 37 0f ff 4c
>   RSP: 0018:ffff88800e707490 EFLAGS: 00010293
>   RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff822dfae6
>   RDX: ffff88800cf86400 RSI: ffffffff822dfaf0 RDI: 0000000000000007
>   RBP: ffff88800e7074d8 R08: 0000000000000000 R09: ffffed1001167c90
>   R10: 0000000000000000 R11: 0000000000000000 R12: 0000000001500000
>   R13: 0000000000083000 R14: 0000000000000001 R15: 0000000000000800
>   FS:  0000555556048480(0000) GS:ffff88806d400000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 0000001b2dc23000 CR3: 0000000008cbb000 CR4: 0000000000350eb0
>   Call Trace:
>    <TASK>
>    __iommu_unmap+0x281/0x520
>    iommu_unmap+0xc9/0x180
>    iopt_area_unmap_domain_range+0x1b1/0x290
>    iopt_area_unpin_domain+0x590/0x800
>    __iopt_area_unfill_domain+0x22e/0x650
>    iopt_area_unfill_domain+0x47/0x60
>    iopt_unfill_domain+0x187/0x590
>    iopt_table_remove_domain+0x267/0x2d0
>    iommufd_hwpt_paging_destroy+0x1f1/0x370
>    iommufd_object_remove+0x2a3/0x490
>    iommufd_device_detach+0x23a/0x2c0
>    iommufd_selftest_destroy+0x7a/0xf0
>    iommufd_fops_release+0x1d3/0x340
>    __fput+0x272/0xb50
>    __fput_sync+0x4b/0x60
>    __x64_sys_close+0x8b/0x110
>    do_syscall_64+0x71/0x140
>    entry_SYSCALL_64_after_hwframe+0x46/0x4e
> 
> Do the simple thing and just disable the validation when the huge page
> tests are being run.
> 
> Fixes: 7db521e23fe9 ("iommufd/selftest: Hugepage mock domain support")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Joao Martins <joao.m.martins@oracle.com>

> ---
>  drivers/iommu/iommufd/selftest.c | 29 ++++++++++++++++++-----------
>  1 file changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
> index d59e199a87055e..7a2199470f3121 100644
> --- a/drivers/iommu/iommufd/selftest.c
> +++ b/drivers/iommu/iommufd/selftest.c
> @@ -446,20 +446,27 @@ static size_t mock_domain_unmap_pages(struct iommu_domain *domain,
>  
>  			/*
>  			 * iommufd generates unmaps that must be a strict
> -			 * superset of the map's performend So every starting
> -			 * IOVA should have been an iova passed to map, and the
> +			 * superset of the map's performend So every
> +			 * starting/ending IOVA should have been an iova passed
> +			 * to map.
>  			 *
> -			 * First IOVA must be present and have been a first IOVA
> -			 * passed to map_pages
> +			 * This simple logic doesn't work when the HUGE_PAGE is
> +			 * turned on since the core code will automatically
> +			 * switch between the two page sizes creating a break in
> +			 * the unmap calls. The break can land in the middle of
> +			 * contiguous IOVA.
>  			 */
> -			if (first) {
> -				WARN_ON(ent && !(xa_to_value(ent) &
> -						 MOCK_PFN_START_IOVA));
> -				first = false;
> +			if (!(domain->pgsize_bitmap & MOCK_HUGE_PAGE_SIZE)) {
> +				if (first) {
> +					WARN_ON(ent && !(xa_to_value(ent) &
> +							 MOCK_PFN_START_IOVA));
> +					first = false;
> +				}
> +				if (pgcount == 1 &&
> +				    cur + MOCK_IO_PAGE_SIZE == pgsize)
> +					WARN_ON(ent && !(xa_to_value(ent) &
> +							 MOCK_PFN_LAST_IOVA));
>  			}
> -			if (pgcount == 1 && cur + MOCK_IO_PAGE_SIZE == pgsize)
> -				WARN_ON(ent && !(xa_to_value(ent) &
> -						 MOCK_PFN_LAST_IOVA));
>  
>  			iova += MOCK_IO_PAGE_SIZE;
>  			ret += MOCK_IO_PAGE_SIZE;
> 
> base-commit: ad0b912913c0e21f217d5580289fda0819cd45ae

