Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C663BF68F
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 11:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781782062; cv=fail; b=J2VGWEOlwxkX5/AmvpCqLTCoZE13hElg8niYlhvwZFl4lV2wgUoqWjO3wmnr09o42QQ7sUqDfX5Y4LEPXVUk9fiA/MBhcfkc0Q4YJt3SZjTrD6ERXhV4eHuBkANA1fGMs58XBM90Aeo8zQaBYIB1fpLzzDNtWnbI2Nh/gxV2i94=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781782062; c=relaxed/simple;
	bh=K8LHnt9A2Jqp6Xk1fGgOdV5CgUmP0jxh/aUUdH46H9I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Njp6JyINhbfBmkrXDKPZVLJjTKit7mHFiyn7itiiVlg+e17gQKg6+9+8UBiqGPrd5TTqRzmOZBX04jWkNebH5Oz0op5zCVjHNS1nh2UxhX/Y52uQD1vQWKAHn7SrHcj8VXoKZl7xRrFOVY7K+StBXEcMBqS/ZI/D5Jn8g6AAgXk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FZHmRrMb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=v7hGJJwF; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FZHmRrMb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="v7hGJJwF"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65I5W4EC2367939;
	Thu, 18 Jun 2026 11:27:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1LIhQPSpn/HYpGWgbEq6jJVX+qgccfvrbwG/cViCQm8=; b=
	FZHmRrMbLSPn+G0ULYzHMxI3oK0h2gMBJ35ATCb+tqP6/5+fM2dnJkl0QcwU3YC9
	ZYide/2x3eoJz3QCTmQkZM486BuQ0WFPl2v5lFs/x4A1DeVZsyYM63/jMfe9Y2eu
	J7LUMwwaTHVRhoPryiiaSXlyYLJg6Odv4Iaki7ubx5V34dTz42eMNlfkXgZuqtfE
	kiTSjIabFivSQeqsv2O37sgVVWBAek/3aE/RLbqGeAk9oW2FAKJc+a7gjsOts4ap
	QW4mCPEgaQBvgpsGXpu8zGZMa9PdmimHx49FO+WLi7hl67tyAz+VXNTwltjc2d4d
	pJll8JPnUatojjeAOR2/pg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4eueg32dbv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jun 2026 11:27:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65IBNj1K013341;
	Thu, 18 Jun 2026 11:27:24 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011027.outbound.protection.outlook.com [40.107.208.27])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ev14f1tsb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jun 2026 11:27:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wV5O4j7L/eEuMD8edMnY/GHbfckB/q9YKA3agiT8abLnrwVWq4sBojoCRo+NdPaPZ0eYrniEdQKgEGYKxj9lqsqM1HijPmr2eN/eQKOZkibcy/nOXipFTAtVNWm+zBCOu75Bw7o1rBYojQtb5kqzXXYIu68MyuHcPcM7fxXZT0JoPrFQtbYSzHJY45I7L2X1vU55+73aZh/g7kSCjoNYDw/LS7sduU0YKXjcOt361gekRyOiRQo4Y/04wCCdNkfjuuUqTjzceoZK+IpFZemOLzVdxjYtaIqQVNeRJKryQJE0pm4XjYNUwzdrqOhCTwnTmm1LaAdKVD6bt97/YRLupA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1LIhQPSpn/HYpGWgbEq6jJVX+qgccfvrbwG/cViCQm8=;
 b=tqI0+k2uOm97nxAQ/ldfGkZrI047b9jW+PupJdOT5d94hiCOvYCG/Q1R2jrMClYpn1ZERyMSbLF0ac590aOplW+AxtuixraOinOINdYbSeymiupGP5HceJOkTd4rep0/k23qM4orUQYcywE7GB3M4q9UMA/MHaY1qGlcA/S+Y8iMmJMmCGSNq4KJmEgRJOV3gEBDO1CSz9DMvSlpv+TSRDVXC9eTcK6pszweFD78AZ54uo+I+Fxcb7Hnz7dzixmnPrTTK1r3iu8XKCgFF209GNFSk/qTdhsPu7wrj7gzqnDFseZj3VPTa2pYGtfN34VNMpZv9nYX7ung2JlKWkg43Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1LIhQPSpn/HYpGWgbEq6jJVX+qgccfvrbwG/cViCQm8=;
 b=v7hGJJwFoqxk6p0Vs/xnbas5bj7CYHmUDqHDY5QFR7NkFk1Tc54eEiZk3DYijGTFoawh/wPwVP551NHrEnTlq8kQ+vCpmSdNTGe2DE7yMf4F/zp0rk67TRCZjxvcRYpkxA7joeYyW/4LPArE47wCUsh8DTwZ2vzj/65NeNq8wdI=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SJ0PR10MB5786.namprd10.prod.outlook.com (2603:10b6:a03:3d7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Thu, 18 Jun
 2026 11:27:20 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0139.009; Thu, 18 Jun 2026
 11:27:20 +0000
Message-ID: <ae1e9012-1f2c-45c4-9115-d53990bcc5ed@oracle.com>
Date: Thu, 18 Jun 2026 16:57:12 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 411/411] x86/CPU/AMD: Move the Zen3 BTC_NO detection
 to the Zen3 init function
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
        "Borislav Petkov (AMD)" <bp@alien8.de>,
        Nikolay Borisov <nik.borisov@suse.com>,
        Ben Hutchings <benh@debian.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260616145100.376842714@linuxfoundation.org>
 <20260616145122.972422457@linuxfoundation.org>
 <a323b095-78fe-4c6a-9804-221dc37be3fc@oracle.com>
 <2026061822-alike-goal-6765@gregkh>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <2026061822-alike-goal-6765@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0289.namprd03.prod.outlook.com
 (2603:10b6:5:3ad::24) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SJ0PR10MB5786:EE_
X-MS-Office365-Filtering-Correlation-Id: 991f1807-8a49-4270-56a6-08decd2c8f8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	eHeK85D0h802cOVbeedOR1/SXHIKs9BZ/TD2KoK8oDjApJSEDD78nKTg8N67T2LKb/T0HOJ8DbUV40+QptaYn1oVIx1kJwyc3/V20DbtO7XSdVIhErWWnOTQmsewJZJUt8/I2Gi/hbWRm9Q4fhHXwLmiVyhAHaUqPaicMVPa9lp5jKwtgxJMnhfErFEg+fRvFmIjvmHCCKyVJAT7gEVudeXsLG8ND/GiXFdvZ3oWyl3zgfrZrOOOMcjUQY1QjK0K8oJb1lkWpYt9vgtP2UMIAGgW6a04KJjy2rokQAvJ1EaRHuuUzFImAM9oYnocGG+gskZaQJK9wuFF34z0Kuyv5gp4jCr2yDVRjx1l7Wzm+4G2VHgimtK2i4q1KnZjxV3Wm4Emdhin8oCXsgqSdLU7op8rIqMhiuFPzF3ZabfmyBjN6Yqd3EHzO13GxBwRMaOPlRnctcp1sos+VC3diLblFUCLZCu54idbmyvODIM32D/OKwYUBAOFbenUUfpsEz3cs5jrMDyc1QoCjaa/OYwa/QlbKUC37lj92o2ExqXWGWZl5R+6mKuZFm+8/1aXttbJH3FPivG0vwkX3h9i0ca8o2w68JwNdkO6LR5+AJxjKVEWhVnYstUMl1J9QMBVPvim3/CmI9g7vd7f6wnTAW8Z7AZ+dczUiKESgpwuIdhAnaj6ixPsgi2nX1fFUPuYylXL7IcbN2/4jHoBEV9GkR8zZQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YXdra3N5UHdGWWNzVzhOL1c5NzZndHpjSEFCbEV3ZmxwaXlDSHV4dXdGWXo3?=
 =?utf-8?B?WFJwVVJrMk9HOUY4emE0ZExJbnZQTlJNcnZ0T0tIbVV0MEVLaktiTlVZTDJG?=
 =?utf-8?B?K083VnZtcHFKeXY3Vi9TZDRrb0trMHNEUWdLeE1BSjM1SS84T0hJTldpRXdL?=
 =?utf-8?B?WkI2Wkl3TnBPb1Q5Tzc2WHl0RWpyOVBNODlEakp5T0o1RWZBYlBoVXlPanUr?=
 =?utf-8?B?S21PL3BNcGdzVFozaHN1ZFk0c1BodVhtRnpVK2pmeDVOQkhVdDAwelZCNUZ1?=
 =?utf-8?B?TkhSZU84anBTSFVnakt1OWZ4N1I4RFVQditYaHhjdVhsQldZaXpuVmZzMlNp?=
 =?utf-8?B?cUxOK3VCaHFMRmdrM0FUTUZTb01HMGNBY21GWDNNWXdhMHNPWno3cFNKQXF1?=
 =?utf-8?B?UzByQWZUdkcvRjEzQzlmNk5pTVBaOWh2dURudUh5U3dka0lEanRPNzJ1WVY0?=
 =?utf-8?B?d1VXTGNRemdYZDNGNmtRZGRKZlFPQjZBdUFxcVhjTzJJM3ZjNTV5Q08yTUEx?=
 =?utf-8?B?WXlsR0JOUWVQcGx0T25Fc1F2SzQySFBrNVU1QitPSC9uSURmWEJZZmRKcTRv?=
 =?utf-8?B?SWpYWm5qZlVsdXNCa0ZJb1FCWDFySWRDZGovTERSUWMzZUVUMytaK0JhNkFH?=
 =?utf-8?B?Ty9DTkNwUjREbWtaaTRYWWlrSFpNQzkxaEs1eWhzeWdZRjdmYTdBc0tvdk1n?=
 =?utf-8?B?K3c3RGxpNmp6dUJXemVHYjlZaDVaNFAyTnFtRytueXN6cnQ4Y2xRdFlVcFRm?=
 =?utf-8?B?aVRYT01PM0ZkZFFmdUxvL2NyVHdhNUN5VEtSdzlGK1Z1QVpQRmhuSTFtSTdt?=
 =?utf-8?B?VnRrNEUyb0FOTWZxYnA3NG1VM1daNzJ6MXVmamhQYTNoVDFLNlJ6MjVXQjFP?=
 =?utf-8?B?dXp1QUx4Vkw5UVQrN0ZrWEhVUVR0T1Q1UjJiV3dSVHc3Z0JidVh2R3NuU2R3?=
 =?utf-8?B?WjRIRUhLU3VCblYvbEVXTzdrYjQzVGZzTnFUQTJIZ3o5WllySWF5ODFFclVv?=
 =?utf-8?B?WWU1OG9VZUZ0b2xkR21lZWdCWWZ1WUJmcFZJR29welRxTVJvZFRiZHZ3a2RI?=
 =?utf-8?B?RVkvNFp2RTYyWTFHS2kxeVdkT2hwNDgxallkbW9YNzd5M2ZPd094eEZEWTUv?=
 =?utf-8?B?MDVSaTluQVYvWFcwMmkvYytQdmxjVWY5UGdHcTFCcXhNaGZ1Z1RoZUVudXhx?=
 =?utf-8?B?S0VyTDJOTTRFNXV4MVdlZHNlVHpMbFI2aGduMFJ6MmpYZGNpZ1JxZkdDbFlp?=
 =?utf-8?B?ZCtJN3hGNWV6blBGMm9IOGxjMFNWa3FNNnVHNlZtNkhSbFNjaWtwbmtNT252?=
 =?utf-8?B?QUVJK0NLUFZVU2ZKVEVtQzBZb05nNVV4cll1dWlSREtHRFZUOFZpRjFVelZr?=
 =?utf-8?B?dGNWOEFxbkRIOWVIbEVhblg0R0lPbWV3bFZyNFNiMEtlZ0tOb3kvNVFtdGZV?=
 =?utf-8?B?bXI0L2dRaXJKZUl2a3M2Y1RScUZIQWNHQkp3SUdjZytMbmxCZS85UU14Ykxn?=
 =?utf-8?B?L09oRkdReUFuSnZQYVhqT0FQR3FUai9UQjQzUS9WcmlSTnpWWGs5Z29zMm1O?=
 =?utf-8?B?ZVlzYWR5WTJnaHF0bGhPRHkrbnpSbWYwR3k5bnU4TlhLd1VmMVdJaksvNEw5?=
 =?utf-8?B?L0krOVRsZkZvaHFUd1ZJaTNYYUJjMUt2MFBWQVRsSFk3M1ZjNElWb2pvZVRI?=
 =?utf-8?B?QjJmY1B4Wi8vT2JNRDN0YkRidHRxT1JKQ0RvYWVGVVJ0SWFUM3BYb2dhamkr?=
 =?utf-8?B?ZmJVcXBKVU56bVoraXhzVWVBQ1ZWdVhKNVg4SjdYY0NESVp1YVdodi8zQkt4?=
 =?utf-8?B?NmgvK2NhQ285TmsrQkk5NmVGUXJTK2UrV3hKQ3NFSHVJcmswcFVLTy96Rjhj?=
 =?utf-8?B?akhwbnA0ODlFSkNyZ01tQlAzMTdldDNHRElFOFRIVjg2azlRMWxqNFhzaHN3?=
 =?utf-8?B?QkhlTElRY3JUSWxQS2RGb3pvaUVLRTFsYmxFeEtmaEdVWlQ5OG55OWMyY05W?=
 =?utf-8?B?RmZwMG1TL2pFTjFobkRKQWRnalhEMk1VdlNJYkhYZWNVbzVTdHQwRlN5QlFJ?=
 =?utf-8?B?KzFESVptT1JMbGhqRnJRWEgwYUI0NHdpbEFYUFphcnU4d2NmekRKUjVXZDBB?=
 =?utf-8?B?VGNpemcxdXRaOW0yZm5Ka3ZWUi92aFhtV04xVmQ4ZUcrNUx3aFpHaStEU1ZU?=
 =?utf-8?B?TVVMVVN2QWhaS2xuUTNOTy90MnE0Uk9yZ0VlY3d4MGVzYjJhNHZrMXdyM1pD?=
 =?utf-8?B?dTB4NlhLV1loTHJrYzJzdmtkOUJadElYNExUcTJ4dmtKY1Q4S2I3K216NG1r?=
 =?utf-8?B?V3R6NXRvV3B4ZjZsYzlScjJoemFncUxzanN2MFhHYkVDdURGc1ptNHByUkNM?=
 =?utf-8?Q?5YnfRGvtpT80/eIvldSyFXFqwAXMKI9mE9Qtt?=
X-Exchange-RoutingPolicyChecked:
	KH6N70xBl9caNSXmzmbXd1pfj3CtVySXImuXknDg2Aa5UdKC9ZM1bwK5JYH8bth0/4PvesI+BQrAlz+Wsgq6Eh6KePrNOk3dwxQaNisbAxqJAtgmd3DSNKgc3F6uD+rPQQznBVELOVRmEU2Jn76stiWxRyC72PwXqmd5Efnr2XE1vQUYD7v0+YSr71ZdJngvTOWgIINp/R+4YeavuqpxMI3FT4SifViIr4XL0xnRzMK4M1A6tRTlozHbREwmTo51Ybj8rnbioWGuW3wmpyqi9PtvJ1RZ928HdOJlz+9IPNLDjE0Jew/qzvvGl2VPuOGMfqAZdcIModTBze8u29wbUQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	f3QHM3+g/kXSGjUb37DAftEjwrkZkLf4dbVrnAyeHxWeyFrhLA1WrTd/fGUskiaUy4LjxnDueliLzELbe0WY3OtKOR36Y8L7yacR6QS14oB8WPxd44ZilUktdiPYsMwALTMf8LTZlBALP5Il4ZaFYPF/OSrOlzvIEk67k4WxW9u6+TzI+Z3yIOgQTcYrJQp/pJdf5LKX3qVcFuscBh0JCaLOU5NGm4MXUpfrWQuscPqlJSN213Ngiu+7kFhpufqC6idUR2cr7PRIAWb1+9MFz3/UkKvWY5chMFEuheUon+iou7FLsCrzyJZDIxM3nyz0a7LLnGYgt3QJ3L9tqqluqcIVOkkA2cjPLn3uwSkBI31eooc/m8d27ZjQcIM4h21SHVnL6fJl2BdOO+M2YuCV2E5NdKARWcBS72aFc7ah3e174vT+2RmU4SJ+r9UR6d5GxewXCgOPyuEqO5nzJI4g4t3c+zcHTMA2Xnna6ZQcNObH2OeK+J7wbYAxpcEMTAFbkN4JcIF4Dm6C1ye7jgCpj8SrIMt7633uvDyesBswxGZRKXx9WAOK3crc9ELv1OgFiQ6x0wSa6F6N+qh8T71Z1gBZPO+l6YqiiZj3TPFXRQs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 991f1807-8a49-4270-56a6-08decd2c8f8b
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2026 11:27:20.4818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3KlwKoN8HAFdH2woSvkvN7UBHIR/fXEN2kYCnCr+eelwLBborJ4zvLy7lvAKE7xpGbTwCCv85YvuNDONTzHA2NJry5GoipWq+xRx5/BxkIu7AYQzhYencAH5huwD1aA1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5786
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-18_01,2026-06-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 mlxscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=988 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2606180106
X-Authority-Analysis: v=2.4 cv=I8VVgtgg c=1 sm=1 tr=0 ts=6a33d61d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=iox4zFpeAAAA:8 a=xNf9USuDAAAA:8 a=ag1SF4gXAAAA:8 a=LG8CcmRxJ3GCZwW7LKUA:9
 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22 a=WzC6qhA0u3u7Ye7llzcV:22
 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-GUID: i90A3tmtmTrdjM1TluFKU-2ixK1-BEC8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE4MDEwNiBTYWx0ZWRfXxFCE4E/9shlG
 RQ758RQDDxds/y9tyXBqbi7/HcA634uMGHTJrLvq41BgZIXp/G9epC3jz43LvklsiSB89lCWK4Q
 4hk8hGNBmhlMICPe5YeuSULR2qdQePuZKuNhYcBYWWj3JlItfH2Qh4yCo/DyW0ubQbZTRmzfXs6
 Kt+POEItrcB39PUAUiAcZ+eQspC28fSynnIqmx27q3n9EhfHNQx6xAO+C0OWFvXBNPTT5Gqiado
 7+iU+OklQRDhiEpn1oCL8G0vbI180rBR6pl3UvP2vaNwMl3JyE6tnoynCQoV/DS07h60Ve6tG1T
 h1D5t/5q5hEfJgd+csEzg93YGrWwZvHKtB4BTsdGL/Jmiia/Z5xhYlCoI+yxU3AiRjdEuR1zQeP
 7NzLiP6cMydWgEderHdldO0S6hNsaYM7LiuouUfrXmR5GGL8y/G29kjq0xrHf3BwEicN3QWrVHQ
 K2xpa8R6gctK52gvv0A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE4MDEwNiBTYWx0ZWRfX5eDjLq5AXZ9M
 o6n2blG50uRVLw0kgcP2JhWl6j2y/k6xwEK5gNpASNbaMeipQ+HeXG9rqj+ZSPlOIyvIGEoSBjw
 RBgIugNoBdMcpoxmembBPD0Ij7u204MhJsIsSU1EwcmR13Jps6GW
X-Proofpoint-ORIG-GUID: i90A3tmtmTrdjM1TluFKU-2ixK1-BEC8

Hi Greg,

On 18/06/26 16:50, Greg Kroah-Hartman wrote:
> On Thu, Jun 18, 2026 at 04:42:11PM +0530, Harshit Mogalapalli wrote:
>> Hi Greg,
>>
>>
>> On 16/06/26 20:30, Greg Kroah-Hartman wrote:
>>> 5.15-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Borislav Petkov (AMD) <bp@alien8.de>
>>>
>>> commit affc66cb96f865b3763a8e18add52e133d864f04 upstream.
>>>
>>> No functional changes.
>>>
>>> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
>>> Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
>>> Link: http://lore.kernel.org/r/20231120104152.13740-4-bp@alien8.de
>>> Stable-dep-of: 7c81ad8e8bc2 ("x86/CPU/AMD: Rename init_amd_zn() to init_amd_zen_common()")
>>> [bwh: Adjusted to apply after backports of the above commit which actually
>>>    depended on this]
>>> Signed-off-by: Ben Hutchings <benh@debian.org>
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>
>>
>> I am a bit confused with this, this is a stable-dep-of something that is not
>> being pulled in ? Asin, 411 is the last patch of this series, hence the
>> confusion.
>>
>> Can you please help me understand this.
> 
> That commit is already in a previous release, so this is needed to make
> that commit work properly :)
> 

Ah, thanks for explaining. I checked the stable lore(copy the title and 
search in lore) instead of branch/tree directly.

stable-5.15         : v5.15.207         - b9524a099602 x86/CPU/AMD: 
Rename init_amd_zn() to init_amd_zen_common()

Thanks for sharing this!

Regards,
Harshit

> hope this helps,
> 
> greg k-h

