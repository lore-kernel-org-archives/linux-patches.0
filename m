Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499D64E1408;
	Sat,  5 Sep 2026 18:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788632727; cv=fail; b=jw/E0Kl+822FjpfHVbO9M0TIDe5HDzk+d2PMf9jLet1EUmZXbxv7DquANkEm928R/229UJ0t05u8lDGGAZ0S1O+XoMYGxrcBHE79a8k+bb2jjbqVLCLyYwcJ6fDOh5xFaib+WHh3vQxB3eGKJp98+hZPjzbfzJrkA1e/Yap/N/8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788632727; c=relaxed/simple;
	bh=tVioHDOq+cGMwPcfdVY+HeJevT2OscdRSBkxvwTsWdI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AhxMnWAwP650lTSWUl+M2G6LEMNn7jonuLZ225I3oMlHa9WSZTa3qk7SvXEr21dIv8ZTY61YzmU5+1nDQlmoHUYupq/XEKzw2DnsfwhewJ/aK7+1s5oMM+OhG4FI0F+Oz0PcewLB0brtlSaDEpO62ZJXaG2mNdyzaH4jfp5R6V8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AzZR5S1i; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KukdxNqL; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AzZR5S1i";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KukdxNqL"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 685HfZdX1461867;
	Sat, 5 Sep 2026 18:25:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qCUC/v+/sBbzGzsWwyyZ+tjuB+rO5bdAVdCJuBz9eRs=; b=
	AzZR5S1ifD0eeM7hc7wyRg3uZJsdPwMX5LOK6PG4t6O1ZboW7zhF60B/Q1IF/kj7
	ZVpDTB8mmLFP6gh66rlpEMAzdE8Gq0pkn3w1lLQU6JegZF2sL1Qr+pHemfJtPrxN
	RuggsytC/CWERFNtqpo9KdtquEKgo8cGzsTRs6xrDn2xXOJgIll4P3fFIMGghU9h
	f9o6kugS3/UXhBLXki/zmCFgFEg/EnGMnPA8L9nwXV3XvslP2trbrQSDw8eKLFOr
	sFNN6aZPV3pHRMtnVD4OKJaH6h3ZRdqEfbqtBAYxPXD0tyFlvDHi7tSKtoBv/kBo
	tLwhxSfNLZ2OL2Cl4c9aTg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbg1rcmt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 05 Sep 2026 18:25:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 685IK5Lk027579;
	Sat, 5 Sep 2026 18:25:20 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010003.outbound.protection.outlook.com [40.93.198.3])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gg9hbcn39-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 05 Sep 2026 18:25:20 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zt+SgmI+9rYJnswjceR3JN4TB3uzuu/M5ujhETryTjNSLm3YlS4UR3RPMUEMMDsgssNhhlM+1S5BM36B0hYhYGSUMfEvUhLVOSVMwjLkbsn7FTv5WySoRTdRAU6AVBcoD6ik/RouVnWgR26PBZ6sHioJDE9TmUFWsX2qnR5lX4AZ1dBlYkl8O1FsYo9WIj8PFSY0CaMki4vCVnS+0Qx1OjhqaPziMWzdzbuFOUaQ4W/t9KbnbVAYNv0+78L2mYvLRJ2g8QCOKPQ6AxWkwbQcVlBkkleqnsp4wJhHBR4UyqY5fQi50WhSCgY/GAxD49/xF2cUYRG+azY86R4zT6ZWCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qCUC/v+/sBbzGzsWwyyZ+tjuB+rO5bdAVdCJuBz9eRs=;
 b=HXH/vqq0LyXeIkRz7GBIh8ECX6R5GRSb8Ru6CnH0K8j53npBQaMA58WSWxwdBYl+WHm1SqWBl2xOQvUfmIqMp6xv1fIcOwoLCAVqK+pc53f9ZKrOA12X4i6zv4qetEHiNvz/dcKcWutgj131Bn8b/yDyNCJqOxnTq40EI7bN/AeBp8eTqXgvozDug5jnIxZLT4zh7taex4B1MnkT1+z+pprBxFVrzc5PLjsMGcmHYD4OKgwdEveJJp0KPKzTnH48Elo0b3Oqgb/lnXo0U+cJ9R0NJQp3iv8v1qRFV3gcfC6Jp/m3bLFE9MzyTpsbsVHQNDWoBgUsXPKIbgrfkXRCIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qCUC/v+/sBbzGzsWwyyZ+tjuB+rO5bdAVdCJuBz9eRs=;
 b=KukdxNqL9d9DT1SnDRlmCP1/T9yY4YmQzmx6pwWUJw+QvhEEQpKCGRipKWCs3zEcEgtCP6XTD96y7li3Fek9mA2b7Q3p8z+m/kb1xLNM7Gkbn8E5y6vFX0etqU9bgVL9E9zLqv9vn5QZ/T5SCPrOipNiuL9P8rmetC891YISkBM=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SA1PR10MB6568.namprd10.prod.outlook.com (2603:10b6:806:2bb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.4; Sat, 5 Sep 2026
 18:24:42 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0406.002; Sat, 5 Sep 2026
 18:24:41 +0000
Message-ID: <a49a7c72-62b3-4fec-96f3-8c2067f93dc0@oracle.com>
Date: Sat, 5 Sep 2026 23:54:35 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 219/403] svcrdma: Use svc_xprt_put to free listener
 on create failure
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260904045734.806166532@linuxfoundation.org>
 <20260904045739.846116733@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260904045739.846116733@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0213.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ac::7) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SA1PR10MB6568:EE_
X-MS-Office365-Filtering-Correlation-Id: 006494c6-668d-44fd-08c2-08df0b7af3fc
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10067099003|22082099003|18002099003|56012099006|5023799004|4143699003;
X-Microsoft-Antispam-Message-Info:
 7MrpdIC9c3b8p+lxne3t+wO3JTAJipITke/MY9ZHWV2JTiV7R3nz2D37VVtydUcj1PhNbexapHtY2RDTKUp0WFzlUcLHVcwFLStKYO3LHAU2rVVBt+KNiM2N2iHlMcmGDWTQ1bSAtRqxyN038sCSznOd+g+rSlzOd8wPRY98WIKMa2kRjQbwZwQ4TlDCYY+nr42HQjb6a9YMhFVd9GKXhE74PO255ZBDw/+ZEgRigVSgdm5XgPuBkl9bZdUpkhx4dTbD1nPyAU0IYeGWd76UbsdF5kmtlvtDQ1eSL7/yhIp1L8H3OQG5BszWFb8KOKvoOyehtm3G1+mChovSoVbxENaktcjdBf+6BJ6gA7XwSWa8lawpm7un3uR0QkUC+5+BA8tKy7EtoqpWEqJrifxDZ//3WA7u+ilviATyfQoj13NDALr7okluapTJxV/5zWkng8JKMxgNArivbeeuvZdTuNP+KfibhsKvK/65N+GuWBifWE0BQQ2FEQiXuhzHMO3+PZV0E3YDAHb4L/OgWsKosyTqpPABsc8+/VFMKAZevwOLrtW2pl3KOH8ztk+ViMxfTg9pUVU3ZYs0pVpdUbNTg2Dixiu7O7S7vWTtJpuNk0HT0/+qc8rn/UZZfzRmHgcx
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10067099003)(22082099003)(18002099003)(56012099006)(5023799004)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?UksxS25rR2lWNVRRanRSSzhTRS8wRmNhTmpZWWxXZ0pCSzZsS21VV0RGckhu?=
 =?utf-8?B?V2o4anBuZVdKYmZ4VlVuWXZvWkw2d241bFhNQmloMjNFcmM2WDVCL0I3TklN?=
 =?utf-8?B?V1VwU1FOcmh1Z2gxdUd4NjhDdm42SkpZNU0zT1dLakc2TTVzczhxQzlDeGQ2?=
 =?utf-8?B?YkJTcHY4NXN3b0JUZTcra1pBQlhzcm9tbTNLekRsanJsSGFuSmhXUG1CTDMv?=
 =?utf-8?B?dzlsWlc2d2JRem9wMzZGTFZYazJ5Ty84Zlhmb1BPczZpM0hjL2J4WGZjMys3?=
 =?utf-8?B?WnhsckRERys0cFhGRCt4dit3NU5lTHdKei9NREtUaE1Mbm50NlN5dXpwOUtr?=
 =?utf-8?B?UHkzVHRIdk5LTTlINE4wMVFTRlNnQU4vc0JZMm11ZEZMZ0RlWk5NZUpyYVdo?=
 =?utf-8?B?NkNCaU9HREx1ODlscGs0di9iM0tyMDhpeGpwcEtpclNrVWszYkhLNGRGWk9n?=
 =?utf-8?B?Y0tyTHlMeTJLaHFmZTV0KzBQZ3JWYTdiUVhremRib2dBZDAvdndxQTJCOTZy?=
 =?utf-8?B?SHlIOTJ6NUdwTlorSlFVenBOVGxmcmJMcGJBbWpIbVgxK01qenI3KytZcW5J?=
 =?utf-8?B?ckxiUEM1MitkVFp2RkQ2LysxQjBTUzVOS0RHYWREUlp0TDluSlJIWG9GaUFS?=
 =?utf-8?B?SVNTMyt4dDZ4TTJBZlVUOXU4U2dnUkhYZmNYT2N1SFpBVFYrZ3VZZk1iRHpR?=
 =?utf-8?B?Q0xGa1VCa25QY1JDTm9HTVExMXc0SC95aXdvQjY5cy9GRERLcFBPb3ZOVVNC?=
 =?utf-8?B?bkgxOWpWTktvSkt4dlp2SWlKSjhsYTZ6Ymt6VUIwT1N6bEVTZTVPdlBCQjJp?=
 =?utf-8?B?S0llaEJQOUdGcDZOWlBvS2o2QW8vSUFVd0VtRlZvUXl4OU01cE5MaU5qZUpm?=
 =?utf-8?B?aUFKTVhjT1hJUGxhS0J6NExlUHMwaGxxc3FXaWJjeEsrQ1VJZ0RQdUNvSnF6?=
 =?utf-8?B?cVZILzFINDJzTEVqdU10RDgraEtDbFFsZEg4RlE2RFBveFlkTXRmdCtBazIz?=
 =?utf-8?B?MEpEcWQvVytqWGN5MVV0ZnFrNjNQVWlkSmVrWWJDQktvdEhaY0xqbkoxbjBu?=
 =?utf-8?B?RzlVVUxMQ3VUVHFqUEg4T2JMWHRrdUxyWnFsOVBrbGdXZDhadU9PN2RwUitw?=
 =?utf-8?B?Yi92ZXpEUlN1ZE1RR1Z4Q0VZc1d0bmhhN2NDNGQ1bjRHOU9FVkQvbHh6OTFU?=
 =?utf-8?B?WGllaERjQ1BWYnVLU0IrMlVYQy9oWWpUUWkwdm5SYUluMmVRaTUxaEU0ODZY?=
 =?utf-8?B?UGVWTk9WUGtDWUR6RElDbDg3NU9ScEpGMzZqdzY0cFhXUE5lRk1FS2xEVUpU?=
 =?utf-8?B?Q3lxTjVqbDZBRCtHTGd5eW4xaFp1WmVZMW9LZ0d2MjhVdXB3VG9HTUY5NUdu?=
 =?utf-8?B?OWgrclgzdkVDOUs2d08xZTZwYXV6d0dpT2d6OFpXRDNBSkVzM1BKZjB3a2FQ?=
 =?utf-8?B?WjNpZDFSV3R6UzlJdk9Camg1UFo0UkZmRVVCNkgwNkZYazJwcXVybE95Z2th?=
 =?utf-8?B?OTBQWDNkcXp0OGxJK24wNXhmdm5JM2thVGxPaVluSXpWV1lvSmJCVE1YU1ov?=
 =?utf-8?B?eGFiM1d3MzlMeGQ4bk55WUduVG9CS1Bqc0V3aGwxM2hDMkEwd2I1dkdYc0hX?=
 =?utf-8?B?MDV6QUZ5TlA5ZXJ3VERNL1dTeDdBbzNSUmRLa1pOQ0k0cVp2RjJMNlJMUTh2?=
 =?utf-8?B?NDJrNm12NnlJMkJ0RUs1cTRRTTRRVjNnZ05HdFhyOHlFeVo1RXc4a0JRTHE3?=
 =?utf-8?B?WmFkMU0wNlJMR2QvaXRPMUozSXkvaFpTSWE4ZlJDcGkrUDcwMEdoNVA1cnRr?=
 =?utf-8?B?WUszZkxweG1iS0hCTFkyMUlCNjhua2lqeVFiYWdMSnVjTEtiR3pHRlVqeGNz?=
 =?utf-8?B?RUFic0hOQk5QelRMQm84aG1WNDRvS0dtdDdxblIvZkMwRlU4d3ZyZVdsSnpG?=
 =?utf-8?B?KzNkWG1CaWR1VW1wdURobnZXTGt6b2RpNmk0ZWlFdlJCSmVMUkFOZ2Vzd09l?=
 =?utf-8?B?V3BFd2lSSnEreW9CRk9TL3R1d2RGbjF5TnFJQlJmOGd2bGNYQzdoV09rSHZB?=
 =?utf-8?B?SGdGWjdwYVRJeDV6U2JQOXJ3a2RrWmk2eE9XM2RrR0ZaV0E3Z2xERWNmbWRQ?=
 =?utf-8?B?NjNwN3BqUkRUclRXeWlzcEh1MXEyamFDR2UwOE9CZmMvUGkybEl2WC9sK3R2?=
 =?utf-8?B?NExsOS83VGU0eGE2UmZLcXdjTWhqQTRwRXlGRnhTbTkvUUFyTWJ0VDJ4Nnc0?=
 =?utf-8?B?M1lEdm1pQ0w1Y2tUcFVCRnZGeXZEOElZK1dBelJYQXVXOWgwQ0MzK3dlWDUz?=
 =?utf-8?B?RnMvekl3Q0ZxaDlPdXFIbnFOcDRtVlZyeldIYU9VemJKRm9VRzhNaHJCQ2lr?=
 =?utf-8?Q?dxIy+1GWJq9emzg+x5OvgmwGMLRC+OvMV/Uvk?=
X-Exchange-RoutingPolicyChecked:
	btoTwn1d+4UZn488cWh/a7WwBlxEl2KwwGY4Cur7zFF/MLMbOikYHrIsWn4GQqtTfPy3kLfkLfM+MpZjjdhFvj/uiB+Kb9fbRrfer+3GhQwa2DjwSoD/i7YpiI474RsXmnS3tFWUcMVT0ZJKG5kFuA97H/Zkf5NcsBZeJKEltjaKdWP0Op5I85O0jsDqO0Q5oUMsJdyDOzTZtBg9OQ/GFNwmwtiHPDtOKjsEzrr00rSb8bbuLCc1hD4UGESOVmONr/i9RXuJ8uK7hRyYDoXkqUoP8mUyVv2adztfnanDnDz5j6RfWzbd8TIaJiAXBMjEW9Q8lDECzj1N6D59J9G5UQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WoAgXaK5y1fG3uGmKLyk4B3u8btx5slmedRCz0F5g2B2lEnR+qLq+j1Owtgsia43ehFAYfGM+CCvFtfHQSgdl4v56hzM0ln089aw1hWG6i57cTbWm/fC4vNp+Of5e73iUnm5p5AzmKQGQ/yHG211LkPy3d7X7g2G6BGn8VKFr2+bcqBBcz5+rh3Ux3Jlko/n19JxsLo2AdvJzzBc6Ru2H/I+bJVkRfrkKRNbF7jam9OFfQLcfrBX6j9oQ/6tSK7zYq2gjRYMgqk76IJNTmUstmSrSHJ1z8kYCYq1XyPJ5GNDYKw9XSreszd9MkJBrFmsV70HLBxNSBhPhKkQhBo2N3oQpVVlLEHEHZh5YuNKMpeO6secDRKrI6g7Bbc5koqRWR4BL3xFNQcCZxIqVpEfHNHNqcQazn34/4xClbEsd41oLlZCPoOxxGXFoD1BSfTUK44pfHWtj6vkdmzPFyCBypb2T3gji7FipdwodHRdnBV1DgZ9KsfAi9LlRCBTwrsZnWXN4oID6QWtooNZBefVbQl1s/mS6ixeja8HJXYELsI7HeL5svcMj3JuC1Rzt1FVEf6G6hZUPD33KePOVZLHgQdK6+PWCyHvVe7Xp6zVYCo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 006494c6-668d-44fd-08c2-08df0b7af3fc
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2026 18:24:41.9200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G5ehkXzWFIp/v+34Yo9xdgO7RS8soaANL2635L+E5agoqzSE/PVyNPVc5T1OSTFWTP7CZGeAxrh1+8iGS+veJCoPtSCLA3BD87739DlMDofdmwpzM3IibKTVP9d2UzkP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6568
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-05_06,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 suspectscore=0 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2609050204
X-Authority-Analysis: v=2.4 cv=VpYTxe2n c=1 sm=1 tr=0 ts=6a9c5e91 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=bC-a23v3AAAA:8
 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=hrAP0w7Gs2yVPTcbcz0A:9
 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22 a=FO4_E8m0qiDe52t0p3_H:22
 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-ORIG-GUID: 3TKZjGbWYswssIi4nocuzMsQsG2dwMRp
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA1MDIwNSBTYWx0ZWRfX/NexiRlHp1BM
 6tBN8N6c5ZsJoFi/E+JPBKkaAGwRvqR6i0RW4dalFHzns/tD4FIKTmP33HrO30X0PKKfGnEIlAT
 oa7zqh9co+A0pzzlH3n+djuq+pc5YRltEEevHxAioOBcXnadTjoy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA1MDIwNSBTYWx0ZWRfX1zjgwA0KaOhK
 DtBDTCeSJVGXEq2xGWcdPexOA4BOLZcC9H/4HDfCoN/G2QB1k3+d8Px7AVxlCknzf9qO/sZtmeB
 mEKHkN8iLNxakFV3KK/g1IVUB4BWpi2ujYSRLum6Q3AjjXJhuuKfmAWvaJiG8BccKHc3wVO3vC5
 Tx9S7riGlXyTJwLEDLewYrj2o2MG/GmIr+bjtN6ejrMRZaUH3HDF1ZhPun5zp0MvOhcFrwZ+826
 Aisj9yLRWpKACf/sfCpPxzpFJq20eABlbx1HNWtdv34IcGNkhf3XjkbpbqnRxcKMBFyG+PWYTIc
 R04O9nTIXpgWCtfl/xP8b0fbkfuV9uA2s26MhaIRPT3oSweiRjNCzAHmPRiwiRI5PiFRJa2u0CK
 x1V9fYMnTjB5ktgvrSAKO+DwJYY1AfejHZDjZn3Y7bENiKJ3KWjP1fkFfK2+sD5YBanwQ3xCzZR
 UadkIQsDmIKNltW2LEA==
X-Proofpoint-GUID: 3TKZjGbWYswssIi4nocuzMsQsG2dwMRp

Hi Greg/Sasha,

On 04/09/26 10:30 am, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Chuck Lever <chuck.lever@oracle.com>
> 
> commit e346ef7bcb137f50c49f969330ab7dcf64ea1654 upstream.
> 
> svc_rdma_create() calls kfree(cma_xprt) when
> svc_rdma_create_listen_id() fails. svc_xprt_init() has already
> acquired a net namespace reference via get_net_track(); kfree
> bypasses svc_xprt_free() which releases it.
> 
> Replace the kfree() with svc_xprt_put() so the kref_init birth
> reference drops to zero and svc_xprt_free() dispatches
> svc_rdma_free() to clean up properly. sc_cm_id is still NULL
> at that point; the preceding patch added the necessary NULL
> guard in svc_rdma_free().
> 
> svc_xprt_free() also drops the module reference via
> module_put(), but the caller _svc_xprt_create() does the same
> on xpo_create failure, double-putting the single
> try_module_get() it acquired. Take a compensating
> __module_get() before the svc_xprt_put() to keep the count
> balanced, matching the convention in svc_rdma_accept()'s error
> path.
> 
 > Fixes: 4fb8518bdac8 ("sunrpc: Tag svc_xprt with net")> Cc: 
stable@vger.kernel.org
> Acked-by: Jeff Layton <jlayton@kernel.org>
> Link: https://patch.msgid.link/20260527-rdma-follow-on-v1-3-1b09bd87b6cd@oracle.com
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   net/sunrpc/xprtrdma/svc_rdma_transport.c |    8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> --- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
> +++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
> @@ -373,7 +373,13 @@ static struct svc_xprt *svc_rdma_create(
>   
>   	listen_id = svc_rdma_create_listen_id(net, sa, cma_xprt);
>   	if (IS_ERR(listen_id)) {
> -		kfree(cma_xprt);
> +		/* _svc_xprt_create() acquired one module reference and
> +		 * puts it on xpo_create failure.  svc_xprt_free() puts
> +		 * a second one when the kref drops to zero.  Take a
> +		 * compensating reference so both puts are balanced.
> +		 */
> +		__module_get(cma_xprt->sc_xprt.xpt_class->xcl_owner);
> +		svc_xprt_put(&cma_xprt->sc_xprt);
>   		return ERR_CAST(listen_id);
>   	}
>   	cma_xprt->sc_cm_id = listen_id;

^^^

I have run an AI-assisted backport review and it spotted an issue.

The posted backport calls svc_xprt_put() when listener creation fails.
At that point sc_cm_id has not been assigned.  In 6.12.y the class
free callback queues __svc_rdma_free(), whose first resource access is:

     struct ib_device *device = rdma->sc_cm_id->device;

That is a NULL dereference on the newly selected error path.
The queued free also lets svc_xprt_free() drop the module reference
before the driver work is guaranteed to run.

Upstream commit: e346ef7bcb13 ("svcrdma: Use svc_xprt_put to free
listener on create failure") was applied after commit: 4488e9129737
("svcrdma: Reorder rpcrdma_rn_unregister before rdma_destroy_id")
added the NULL guard and after commit: bf94dea7fd4e ("svcrdma:
Release transport resources synchronously") made transport teardown
synchronous.  Neither behavior is present in 6.12.y.

This needs a coherent 6.12 teardown adaptation, not the visible hunk
alone.  Without those prerequisites, I would suggest dropping this 
commit.  Thoughts?


thanks,
Harshit

> 
> 
> 

