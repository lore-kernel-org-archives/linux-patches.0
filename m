Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220F33B9D9B;
	Fri, 10 Jul 2026 12:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783685815; cv=fail; b=kiFiyod/3Xin7YqPE9GRl4ytndjd6CzbpYr3BI5O74LNxObwuUEHq3c1360WxLuBfZohjL7CNhC0lKBu149aZQlBIZ7Nox6iHZbZklJXJYVpxqfpgVCOJkDAvBvqt9u3IU4N13DtPvB9mUFdq+Ftu76TLJea1AfC+YT5XJU3dlw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783685815; c=relaxed/simple;
	bh=AisTpvjttYixfI5G5fUnvr3tr13YDGKhv6OE9CVDEyU=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sbgshVicYs7yNZgEnrZkJHJB+2Qop2dpwqCob5DKh2VUuiF9JnnE6aFQyc4E6xpahsvbA6A82xTgKHo5wC4O9gyrEb6O5il/FlNgt21kNjcIczONjuYbltLKrc8YxLZ34Igb2NDJvarCzeV41hg0vwy8Ynrd8F+kWJl8qEUr1PQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cQ0MSaKz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Lq7zgVZM; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cQ0MSaKz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Lq7zgVZM"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 669NrrDx2894990;
	Fri, 10 Jul 2026 12:16:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=29W5c1ySp58fIo+KsZkVkpHETAteuUg2pRyayJZeNvQ=; b=
	cQ0MSaKz+Gr6oh/keXJq5jO2KJc45EhA+wPgOIeSsodBiDnBij1fJ1No4kGYOK9B
	VChlDcvy7lOWaOpWfrjlvc8xY8BWSl9Yoj7ak4OdIsp0rFG9D7v1JuA6J3ZZZASn
	RzBP8Gc8YcZofnaG/wwZTa569ldNjM4jhFaCXhGnpqxheoy3cLEXtZJWcpbLttLt
	omPHyDu+o4qwUMZW1jIexS6+UCjRex3vaejAyCnBg75kd8FE7c7SUmNSaBQElSVx
	TaTs158KAs0OGnbYmt0hqDaRWzWT6S58Ojaw+kooTDwI7kG45vJfK7swdRpeVWxj
	qU+eVsOx8ZDjaO0kbUWtMQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f6t7cubqt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jul 2026 12:16:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66ACD96N010964;
	Fri, 10 Jul 2026 12:16:36 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011053.outbound.protection.outlook.com [52.101.52.53])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f6twnpb5b-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jul 2026 12:16:36 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r44UYB4KCIC2RJJaaY1hyrc8MRM7xU951nBgsv3O5UmJA2fmcFNSeif6sd1583PrqW1SBlLWcQ+VtF7P82Nr5tBNUNui0lk43t+QbATaVvJpyxdzD7sFLPD+3XoLsoDGeszs058jm0oyxY8X1W9PKZHJhFxiK0oMzgGO8UShWDY6XvJ6SUpQ9mpjdxwrf2WTlzFi3eY7SzY7VJzo0jenDAWBhkj3d1rvHCJwTcY1HpvNM5rNOy1lZaELvZxlg3Rcmuk8fesB3H4UdZYaurcwktO4sUp9K/Ud/Wv1aGhtpcdS9Y/su8mz06FPhPZHHII0jINrGjqhg2hN4ZGge5IoYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=29W5c1ySp58fIo+KsZkVkpHETAteuUg2pRyayJZeNvQ=;
 b=UXGfW9aSl6k16VvTtVpyGPS1sF0C3DBsv1lpkqfDX4o3HFtL3YD/Jt8dVdARSJdKHEl50nonLHoxcbf84s+qZhdx2FZn6fCMIJ2Hy1rkWFi7vjfXD27PfF8CYMr0Sf583jO72GQ2vBKQlXBBJRvlM6z5hLYmqF8KjeJwtqxhgoJ/XoIpCUXWsM2Q4dkzpXe5Q6pyEf1SPM8DHilKoQCnIlwRfNnRJXc5VUFXqvWEg4gMHv+M5700Lbo4RCuI6QBJe1TcgBpcF1KL5xZO2D5DdQ89SIzz3ijoRGnnJgxQHS67hqA3YRbszKQUGoa4rOSq0VUbfQJza0RGVJYfMvF7FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=29W5c1ySp58fIo+KsZkVkpHETAteuUg2pRyayJZeNvQ=;
 b=Lq7zgVZM2dSS+vGYen/Hh1LDdtdEr3fmIfQZW+I/x5DlcXldgws6+/8HE/Ay+KVkGBx/XdwAvjuowuEeALPsFTlt41f//iWs7EJDVpr4e2ULBaW6kWZR8EuepWI4hCs3tVuZuueo8zCvjNgBaOk/A664My5lEtRYzqZCacKV8Gs=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by DS0PR10MB7091.namprd10.prod.outlook.com (2603:10b6:8:14d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.17; Fri, 10 Jul
 2026 12:16:28 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0159.018; Fri, 10 Jul 2026
 12:16:28 +0000
Message-ID: <ae0eda58-8e84-45a4-9a10-5fdca3612c16@oracle.com>
Date: Fri, 10 Jul 2026 17:46:20 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 187/204] nfsd: check get_user() return when reading
 princhashlen
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, sashal@kernel.org
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
        =?UTF-8?Q?Dominik_Wo=C5=BAniak?= <stalion@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, Chuck Lever <chuck.lever@oracle.com>
References: <20260702155118.667618796@linuxfoundation.org>
 <20260702155122.580017616@linuxfoundation.org>
 <17cce379-76ca-49fd-91e7-1a486de62d2a@oracle.com>
 <2026071043-dicing-arousal-ae51@gregkh>
 <3bbb428b-b137-4d21-885e-786ed5d76bc5@oracle.com>
Content-Language: en-US
In-Reply-To: <3bbb428b-b137-4d21-885e-786ed5d76bc5@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0028.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:151::15) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|DS0PR10MB7091:EE_
X-MS-Office365-Filtering-Correlation-Id: e4182400-13e9-42cd-8f68-08dede7d1169
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 zk9LtBiwhTzI+v3QMRemcAP9/peyIdNoSZC8X1/NraomMQjoBqHi68K8iAaYbmflj9fpB9RfepPUE5lKsEFetGihUMiY6BPELZva0+xTOiowh1x6P+LimsdvFO9brALIcy5s/4hDa9s4xUDQQDdFZseX4j+091/GKqm2/2GV2PnKaCfXV1C+6LpTLKqHV0RVR7m5ycTD/la4wzyQsdh7VdwGFAL4VI1MbfxvE2kb5bFX+3XqV1sUZ8w2Pz/CtzbGT5FJ1wkqE9DUFxdyo3SfoHVmAcQ2+4xHXHUVAuw/2wLDNOHv2TJ003x2+Jy9wVfGyujU+LpNDoc9k+k/MNcmJZ1LYaFvmJNEF4jbfCmUu1rkC6Jm4ZsjgadLZMsiM3Eq8bZVWCWHem4MOStd1qXbKnT1LCmWGlyVLcaARx5FCheWWxkT0OLU6vBIaj2qqthFPN8y+R5ndl+lG0xanbHR32QkzjUNIoE7soNaVNU9jHG/VqoWPuKVckhkmM4fxxHIOIBfFk0g53fHVnxVbKtTYnI6ntjzhQq7lxWyp5z4mJB9Oig+xYUm/d1UxGQisH5D2qz946Y2S1+ORNkGBAoZCmONDPzLMnqYogC7hFvSN1E35e2E9u3krqN5l6Mr7S560JJHsywJtt3LRLbZ1G/MwRaEIW9u2kcGviH6T3At8Zk=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?cjVZR015Yy9ETGUzWjQ3S1pBUjB4NWhxTUdBY1IyZUFiZUw0Y3F0QVIvdHNN?=
 =?utf-8?B?S3JDeWxMUkFOVHUvZzJQZVUvTzEzTmpMN1pYMzBhOG9iaWZvQ0EwNUlkdnNp?=
 =?utf-8?B?TEh6cVk3ZVp0dEtoUHhpbGMzOVkxL2t1K2ZNZWQwU3BWNE1GdXZtYjQ0bGlh?=
 =?utf-8?B?NHZDL1VMRWhOSU10MXlnazYvVHEzYTcxd25XMC9qamN1WEJuWnZjemZud2Iy?=
 =?utf-8?B?a01MUUtCNDVzVm5PalpKQ1pXLzBCc0cwODFaYnVjTXBhQzZwcVNsNEp6V2pS?=
 =?utf-8?B?QXQvR1BmMGg2K0krVDhqNUkxaDBNTDdlVURQcUp3ajhIT1FYeEk5ZGFsMDV3?=
 =?utf-8?B?SFBqdFdRSUlDKzNwZ2dTMWJrT3R1Z2UrcURvQnVhckF1NlVDMkNsdFJZVzVE?=
 =?utf-8?B?YlIrTGlxWXgyNk9KTVhJZW5tZTdSN0xZT3JTU295ME5RWGZpRkZoekpnYUxh?=
 =?utf-8?B?QzJTSWpuSmJ0Qmt2bFdFMkNXQWJPUUl3K2dKTTNsY05GVkJiell3SlM4V1dW?=
 =?utf-8?B?NmFldzJFbWE1THNMNjdKWXlsNGJwVUxwTlg1MWhIbGF1RU0rKzhIV2RGL3N4?=
 =?utf-8?B?VEphM2pOaUY3RWdQVG15SUtFWG5naEJUMVJhM1kxVG1JTnpuM3dORWN4V2RD?=
 =?utf-8?B?SXRXdmtzeVFxZzlRSGNqN2hQYWhIdFNvdlcwamNsSURQTjlMYklOemlpWkcw?=
 =?utf-8?B?TkdiQldDUEdlSnN0WUZBYUx0clk1SmFsOHN3bk40MVVVN3l1TVUwNGxJWlBu?=
 =?utf-8?B?Y3dUN3I4Q3MrZE90UXZCVnV1SjJwMWtqN2ZaYkdodzVJMXdkc3JlWGlWUnlJ?=
 =?utf-8?B?VVZ3cU5qQU1kWDgyVFYza0M5YWtNLzBpMWNPcTZPYVZRMnFZY2ljSHdhTm8w?=
 =?utf-8?B?ZnU5cnNJRGhibGprMUpYY29ZZjllSGJneDk1am5zVkdmajN3cW82aWdRcHBt?=
 =?utf-8?B?M1RxazZGYWkxQTc2T1FOOTkxaGhzcVVuOFkwMTYrUFViWUVQZitEc25PeFBU?=
 =?utf-8?B?Ylc2aEc2N2Fzc1dubEh3NHN2MVorSFdZbWZzVkRESk9zdlVyZkJ2eXcrZHVX?=
 =?utf-8?B?RjRqQ1B6WHRVdFZyMTZzRkk3eGM0WU01V1B2cldaTXlkWGgzaCtnYjc5NlZs?=
 =?utf-8?B?RFFIY1lqMFlyeWZsRy9wc093bUhBN2dUdWIwYTh1WkM2Si9maDE0VVZuM1NF?=
 =?utf-8?B?aDhpYTVvOXBWSEdaNjc1a1NDSnA1VmdqT0d4TzJ6Z1YzNDdmWDNXK2VVLzNl?=
 =?utf-8?B?ZTB6YWJaaGYzSEVFVllIZWRmT0ZGZldBNEFpRHFTemdDcnRFY0FOSGprcmZZ?=
 =?utf-8?B?azc5elFGWXNnV2RvRzhpT0ZzcHh0bC9WRnJrTTdMWTZrd29vQTRmdHhlUGZW?=
 =?utf-8?B?Yk1wYWc2Zms2WDJVK3pXWVdVTHR5SGI0QkErRHJpS2JCLzJXU0RxbStMWEZC?=
 =?utf-8?B?L0hYeUl4ODhoTDhYaWJzK3dibVJuZDZlaTQ0NUwxbUtGMEdjaUJ3OFJBYUQr?=
 =?utf-8?B?QXdIdjRMYThaNEdDdXlibSsvNzc2b05xNVMwdThqUG9XOWNRcU5ZUWhjREZI?=
 =?utf-8?B?M3YrUU5JZDdyb1NjMVU3dlgrOHFhQ25ONzJUYUlBMHJtWnlqdFZJZjNYY1FD?=
 =?utf-8?B?QitadjJEWk44SEV2ZkNPRW9DT1FiWnZ3RWRRRFdhNmN1ZnJFdlM1RS9RNUFD?=
 =?utf-8?B?cURQYmxqcDFIT0hNWG1GVXBNaDFSZW1uRkNwWUM1SERvRnZ1VXE2Wk4rMEwz?=
 =?utf-8?B?WVVhdms0c1RxRHFtUWMrenk1bHArNFBzaUd2WDJhMGVOMHU2V0VrVk5UTGpM?=
 =?utf-8?B?WUNIaGIzRzRqUFRkem5jMEdUTVNBTmpUa2l3MTUwRzF5Rm5wbkJFaWRzbm05?=
 =?utf-8?B?K24zcWk1TUdMTnZoUWlSci90ZHZvY3ZWZUt5MWp5ZEVGTVpjdzNKanpxV1dz?=
 =?utf-8?B?WVlPMllDSzhMK3l0aUM5V1JNQVdtODJBRWNncTV6dHZHOTcvb29ZREttRW5R?=
 =?utf-8?B?enhHeHg2TzZoczdZYis4VHdDUWpzczJaTGFScjJabko4ODdpSE94dnhkZ3RB?=
 =?utf-8?B?QXZkSytja0UyYkJEUmJFY2JtZ3Ewb0hucE53c2w0WjRZREdKdzR3UEoyNmhH?=
 =?utf-8?B?UWlzVS9sTXprenQyaWRtMEdpL0FxVWlsUmRHdFlmK0JKZHFwSGlMTUxYdXhl?=
 =?utf-8?B?YnI0d3dVZkpueloxa1MxaUdyaDN2clJKaWh3aUJmZ29XSXJkeStSVHJYZU9S?=
 =?utf-8?B?WHNoanZGWmJDTnRNQlJHTFhjbTVtbHRYRldQeThmM3AyQlBwMUdCREgrRXBX?=
 =?utf-8?B?SmR4WUNFR1lvNVVuYkI4ODdtMHh4RHAyRithODVGcUlza2l5TU5tZHF1RnZx?=
 =?utf-8?Q?FdykR+xYa3A58pAQ889Qod6aMCgVw0UJFpO9s?=
X-Exchange-RoutingPolicyChecked:
	MZ6SPnUlzrjxmFUFsjhp43W7jJP1JllYsoKd1G5/gz3wYSDQ2YD2ATOXRKoqhWDSJ5dvqaMrFdJwK3/hE5b5nQ1qNsIIxH/iXmyDsBwxuM2IwzxtaIokOxmZDxqg4d2y0CJdy4Xh0vFEHB8mlppJrELm9kVtyqYCquHjz/bZhBUJ2bhi7kduK9s6pSpMtEHzW62V15yWyiKK6v74bIz90AT+n9XRclGTejAvRsDHT06royFI3IuUn8WTcgMKTZO7cve/22LnvUnBURaxQn0vMrtxw9kBZZdR2HiPlzCorI0TuLQjp2zdTaC4fYFQj8I105FPR3ABI29pQ7MYvW34Tw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0WEMmT7ECwLi3VOIVJPfIc78/khPWyxtPruxWt9RhKwj27pQBn0Ny6S4kOYFExUFwXwfm+RswyhhnIt+GQD5QZHJdMrX/bj4DZHZt8TssqRxqPftubKTT/WVOmlxNPkIr5FRQJJraDjP+xWgdS87oRqkf3O4jz1cEzBfiSzC+nbMXAWQVtbS18gmvazJj41dF2q911T/FW0BF/2V/qobdXVFzTJn4/CELrg1XsQItXeJKWg2fJ8OZ3h2ECf9c1YuIx241EfZyiN8iWyquCeik1Zkeqhkigih2lFUlTevc4nkAlJTpLVzZ9VpdmnI+Gvl1RiTb+l/2WcpmJFh+2+jJaTVILe5kDIgFLQJsBYh7u5GV6y+JZ4JgxxH4f68IYgpil/Bb3WA1+aauta/OF/nV5dPIEunBRvNNnBGHoyAND+hFq0ymW16nvBtxDVoxZjfmDffh3DX2bBfHesm8ITPSPnSeao566P0hSogefzc6Hg3dLwY/0Sb6gdzt/WvEdhbNJsMPoz66QSAjD3uv0F9jSOtYsWh+/9Sdc1UpZHtlewNn63l1YAdT7ijjvxkKExWe96kGbanu1Az6L5ajQ2lcnfFcJTwNEQA8fIXVKtpfcI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4182400-13e9-42cd-8f68-08dede7d1169
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2026 12:16:27.9572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mpwHDa98lySeCva15o/hpAII+g8Y13Wc9QKKpc2DQkQwjTA5m/HS18E3Y9uPJ//mn+e07vHCkUmInb/7kZQTcK/pHuG9hOA8/p6Nj6uZXu4qKPA6XN5r75ZOmGLfcrLT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7091
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-10_03,2026-07-09_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 adultscore=0 suspectscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=908
 bulkscore=0 malwarescore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607100121
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEwMDEyMiBTYWx0ZWRfX0whrvxKnW0Ho
 3dOS/oUL2ZU0DtbYwz6JKxEvi7Y9v3ec+Zbsvi4E7ZbVeoRH6XZkfPIpUDP7RZ2P/pRxpZ5N7yV
 L1L5CUDz6SsWAatuYJq1siGwYKEgZ6zK9TlhjuvpFNmp6ngOLD5kyHbOpTUGlMkGyGKlehIKpEU
 UrCr81R4JHPCefI2L4PTDqy6hIvBdDJThVBLaIWXbQe0o1QB1Nbokvo/wXMxyrjZ8ecEM6GodZn
 t4frksVLc5zWUDTUSdYAJ947rhZClfSisMtnnEu+tDaGyoUgtM5D+3+77JcOcs9rQQpES7rp0GZ
 X10NH+frqx+XzpdyIWucEH0Luf80X8o0E8xHV6D+kLDaroYTV0UUkTr3X+tUuv1Nu7QrP3F+2zc
 hycaLRAB9wb98c+url8/Q3vKlOXquPrbd07qY2e7uJ1lOHGMHmryIIQiqdeuk70F9v1OQLfcXhy
 KbzE+fWzYP1QjIO2wEA==
X-Authority-Analysis: v=2.4 cv=P+QKQCAu c=1 sm=1 tr=0 ts=6a50e2a7 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=Vf7Ve-Ty6jfVkJ-gnYgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: RGufm1UMGj7le8T3XbnrQq4VjdAQqYsf
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEwMDEyMiBTYWx0ZWRfX0oibdnaNhAJN
 FITRYDFMhR7yAwhUg4VaPWRK6WHdaY0zqdlq0ksgNUHQgLXraiEpYkvjUSPX8nANQ8UHggfSLTV
 dfNrOJSqLkQFZICoWy6LHmOX/pWxror1Ap06dFzusBSHq2JflykA
X-Proofpoint-ORIG-GUID: RGufm1UMGj7le8T3XbnrQq4VjdAQqYsf

Hi Greg,


On 10/07/26 5:36 pm, Harshit Mogalapalli wrote:
> Hi Greg,
> 
> On 10/07/26 5:19 pm, Greg Kroah-Hartman wrote:
>>> Maybe we should fix this up with a downstream backport ? That looks 
>>> like a
>>> simple approach to me.
>> Yes, that would be good, can you send a fix for it?
>>
> 
> thanks for checking. Will do.
> 

I just started the backport and looked into the stable-queue, turns out 
we my report is a duplicate of what Ben reported and Sasha already 
picked few patches to branches which have this issue:

Thanks Sasha!

"""
 >>>> You're right - the new early return leaks name.data on every branch
 >>>> lacking 4552f4e3f2c9, and the patch shipped in this round of releases
 >>>> on all six branches.
 >>>>
 >>>> Could someone please send a tested backport of 4552f4e3f2c9 to all
 >>>> relevant
 >>>> trees?
 >>>
 >>> Not wanting to duplicate effort, is that "someone" me ?
 >>
 >> Looks like most of the conflict is due to a missing 89bd77cf436b ("nfsd:
 >> move
 >> name lookup out of nfsd4_list_rec_dir()"). Ok to queue up both
 >> 89bd77cf436b and
 >> 4552f4e3f2c9?
 >>
 >
 >Those don't look like Rocket Science (tm), so go ahead.

Now queued up, thanks!

"""
https://lore.kernel.org/all/ak49GYepsuRSyu1b@laps/

so we could call it DONE!

Sorry for the duplicate report.

thanks,
Harshit

> 
> Regards,
> Harshit
> 
>> thanks,
>>
>> greg k-h
> 

