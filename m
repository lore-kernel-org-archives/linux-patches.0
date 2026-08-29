Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CCF3346A8
	for <patches@lists.linux.dev>; Sat, 29 Aug 2026 20:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788034615; cv=fail; b=u/bP6XdYjhDoeBOo0YVjoOB+reNtxHdyHSdbAUChMCV8DIGzbkqrmWaRmrPyfwsHKM96XJUx7q0gkkSSpY/xL9XLgxrp/olCYI7/yn2ED4opCix/A3FPlc2H/ANmONHFcci2GOH0qMxGde8sEjOJgtgJ7LgrhClG1+jbi+x+ufw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788034615; c=relaxed/simple;
	bh=KKuXzTZZ9hgWKxo5xFtYKSe6el4yVKSs6v7fLy8l3/8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oXeBuI+/XRHz2mXBo8/P8zaVAI5efmgWgHWnbWFGCWn3YNaQVpAytPhumBgqVbQjY0sSnOSK9KM2iOVp6HHI0oM0wyOEhO5CG6FjCiZr2eA4KIlGticUrYGQyduBPDW3ZJUVxVK4w0R+xdAdS/EjqAh0mWUD8JxDMNMFLf/JWZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bmrMjtic; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xmRRlMux; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bmrMjtic";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xmRRlMux"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67TJP1cg1467164;
	Sat, 29 Aug 2026 20:16:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=PAFmwF4zTFK1Ogmpw+2zivUzyHjuMuE/qshJYJ57CI4=; b=
	bmrMjticm8Vc1iMe1kWkriDCV3Hb3Xggj2vezQEhx6XVeLaZbu46fT+Ed35KBRhK
	bGaJgi2Ta5pNfxVwLmChg+lE4JzkeX3plzJfLvB4Il8e4ng9iHpRDn0NKCs33OuW
	nxsg/vnpY8To1SQiC05KtTuSWYVTsa8uPT1wSuLmTGfoVn8LuKF1fExEnPS9v5O5
	iF98AoErxFmNp8NAhGZPEESUkLDnM2izvOcoa2Wqk4wNj6DrGHw4H6295AD05n1M
	bbaEjFwBpsst0DXFPJM92qTZfm6qxy/YIXa7f89SerRbpgQgfE9BW5FI5rH9lbc7
	ex9+2KCIEfkPzaIunmBDMQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbnub8m9r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Aug 2026 20:16:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67TKATwO036373;
	Sat, 29 Aug 2026 20:16:49 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011005.outbound.protection.outlook.com [52.101.52.5])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvn7jna-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 29 Aug 2026 20:16:49 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rZ0cjOVQsLJSp5T8ERfWH8PCpWIG16RcGhuOHvI1t06wcK//YnROKiJuY7sUHp6Rolf0jIZcXvC7bYht769CDfGJUs89vStSAN6cp9SCRZZcDOeWOhoTs5nhpwPhZY5yb0z9XR158JY7oaeACdQES6g2PpX+zBuzTN3biS/SbmLLUXBywc0BotIgdeRwkTSSYWCUanxhfM9oYw0hXainutA2iqlRAxuRPCx+sfuttir9H6ImLWYoJV+XYFBRki15ysE+LclfkVmRQVNZ1Dv5gCvxDK34Bdnidd6Ue7KfZYSCwb568mdSwltjKzhwpRH7k03oPbreY82jJNx8hewFqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PAFmwF4zTFK1Ogmpw+2zivUzyHjuMuE/qshJYJ57CI4=;
 b=CwMZ9ZoXxKPYiSsF85585hNHaCPRjbTkaperfoNuYSgK/MWbaRZlfsE0yLejKOfL9vBoLDHfOUxIRmL1XUPRLUwDb19Kbze1RocI3UaxE3+nM1AZiUsZW6CV7348pdjbNpTbbqmtuDxZ+UgEC2Anj9F8QvtH5YAMTpsEvD8jlrD+fsqeMEZXjw6VRyZRVzMzaDsu3mt+VUVlmbvG0boKfGLumb6rQwFlPxRxSLkcFfLkyFAWxk1BmXtWd2ZvA/Sw9wK631PFaKYz0RvmKniWYWxmB9hOv+ChwgQ62tlbzhQAbKYQdguwcasCzTnRMnC3Dxr/0jcCeHSuKOM+scVpzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PAFmwF4zTFK1Ogmpw+2zivUzyHjuMuE/qshJYJ57CI4=;
 b=xmRRlMuxsU2mfamub3Rjjps6xorTUA6S/2BsBb5ZqX+JAs3UGi70MobDNXcz1HZBHHORBHjZwpU2Q3yxLmzTW6HM4mTC6TCXQTVhtdtP8RU+dI1/cp78/87wP7GExqjSa2SS1z8ZZtgCfCxaswlVia658OMnry/u/9oHcazo86s=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SN4PR10MB5606.namprd10.prod.outlook.com (2603:10b6:806:209::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.9; Sat, 29 Aug
 2026 20:16:47 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0382.007; Sat, 29 Aug 2026
 20:16:47 +0000
Message-ID: <7ec787c5-7679-436a-ad3e-51252f405d82@oracle.com>
Date: Sun, 30 Aug 2026 01:46:39 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 192/220] arm64: tegra: Add EL2 virtual timer
 interrupt for Tegra194
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>, Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260820145223.480031205@linuxfoundation.org>
 <20260820145229.287410651@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260820145229.287410651@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0271.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e6::20) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SN4PR10MB5606:EE_
X-MS-Office365-Filtering-Correlation-Id: 1617ba80-be73-468d-f7b4-08df060a73ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|10067099003|5023799004|18002099003|22082099003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	r/LS3ry6y6VE4JtwYV1oTjp1hxrBIQoJXkaau415xOUilh5EsANtSIVf6HL6Y+UtFz1HEyMDehARfGX8TZgY6RPlEcV5+HJYG1rXLo8htQfKNvPy8JfmeZENzrWqXL3uD6Nep0XzN/H4RKoRiJ+gcls0MJdRFAgiXcedLiwUT/3KUZT33qloAOcYwNa+DhdHn77hkLr6h5Vv5IuNAawuM74+JVNmeIat9bPTroM/200ZhoM1kumwJjmyS/4RVHFhTIjoepQ4BWaQSOfs9SLbrd3R3kAngf9DUMT5dR+ImrnJCsDyDnE+kDfMZ/1GIXy/RrOyrOpACgKsdZ340aw7gAqst83GJehldUXiqJxqt0Za2TYV2Zs9v5hO+2u2lDJex7hKVNss4ZGdQ3nank3muKIvYIeCQ4zQCx79C7yNFknH+Yr1WJhv5JhEw+bq1z0Fi6fKexCUFNMTPRmG/tlWhdhfy7f9LBSfQOYBezlCVUaESRjk5+Nriemd6F76p0VGKcbw4vL3zZ5ljPkTN0h8FB+xIUoWLdpSxE69eG+agUdAkfXuaoS6MYwbsk41qzF3tvz3p6XvRewWYaqn/p6UwlP2sx9d5Lc2rFjEpknNPBC+kYIPPimxTkESKQayNeXu8ULvMfHgEodS4Gc+zWhZrVH5zFRBvl++dalf6WB4zE8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(10067099003)(5023799004)(18002099003)(22082099003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?czJZcE5YNEExM0hxblF3R2Yrb1NWOVlRZFRUTXRCV1BTdmZWS0hrc2RVTWFQ?=
 =?utf-8?B?Z0xROVBsU3NmTmljcDZ0QnFRaUVSUDZuRkFETDBzNUswWU1WTUpnSlI4OThE?=
 =?utf-8?B?VDRmYloyOCs4Z29pN3N4V0NwT2RGQU5jMURwcHBVQTJUK0lIMjBpR2J6SjlO?=
 =?utf-8?B?VkZLeHZQUnJQamgzTmk0aDBnUXpzNVp6L0o0TzRnZmtZb2NWR2xvRmtLbG16?=
 =?utf-8?B?Q3Nsc0tDSkEwV2dSbEwxbndYYndxa0VqMEdLNkx6K2JvQWU0QzhEdTdYeCtV?=
 =?utf-8?B?TGFrWVFYNGdGVS9ZSW9acnJ4KzRwWVU1M0Z1R0xXazFnbXhZZGlZdjN0VzFP?=
 =?utf-8?B?RnFEbXcwU1g4RGNTcXphV3FKL0EwVlNvZ1FKNXBpMEVuSXVGa0pIOFhXZUZy?=
 =?utf-8?B?WGc0MGoyVFNaSXdpb2Z3VUUxRmNkZUg3UEpjcVpjTmZ4ZnV3bjZGbkVQRjJl?=
 =?utf-8?B?cERPOXVlaFBSOVhuMzJjb2lmREN5MWxwUUZZOUsvNE16dll1clVLdFIybkdh?=
 =?utf-8?B?YTVaK20wWW9BOGw4ZllxNDlvWjUzMHYvV1EyclM1L0VwY0NPTjZQUzJ0VWg1?=
 =?utf-8?B?UGJpZGlJOGQyQW9qdE1mV05yai8yN1V6QkJ1SVpGaTBKQkR2N0JrL3lkNXNu?=
 =?utf-8?B?cStvWnNtR3RWQVJzeE9GeTRTaG42czRtaXIvdTdDRWdlVVp6WXFaM2ttNCth?=
 =?utf-8?B?WGNnRjcvVnN0YUVZOTdMeWxyUXdLM3ZOb2htbkxmRjh6eFVQMnFNL09rOXkz?=
 =?utf-8?B?WG1sNnVPYXNLR0Y5enBRbzB6aVY0bThVSUs3K0VHOThja1JqL29peTV6VU9v?=
 =?utf-8?B?SFBqOFdoUmdoUG9hUW96cU1ISFhndjdFUFg2c1BSRm9wTnFtU01JenlIRW1H?=
 =?utf-8?B?aEI3WTlmMlVzL3NVbTRFVE9Mdm1HREVQUm5wUzEzVWZwOUJKNjZFeU1vdXpo?=
 =?utf-8?B?QXp3ZDRzejduSmdkSjdZZkNPaDJ6ZWZLL3RsQU1mQ3NPVFVZdGJYclBqT25G?=
 =?utf-8?B?YW15dmpqa1FpMkZvSGxNQlZKQmlQalU0K3VUSUFHaml6eFBhcklIeWNvZ3la?=
 =?utf-8?B?UnBmd2FNcjB0TDl5VTQxZ0srbkxxUGZDVzlGMzg0K1Q5ZEF0d253eDVPUW5M?=
 =?utf-8?B?a2NMZ2M2MjZlU003UmZKNlBnT2xYVFNxVThDUGltdkk3UDV2blRNQVF2K0VK?=
 =?utf-8?B?N0R4ZitESk9KTU8wMm1QazBuenVNYXR5YWR0V0owaTh0SVdQV1NRcXpNVmtj?=
 =?utf-8?B?N3lxVUlDMU51dDRDZjAyaE1XS0kvZXlrdUVDREpKWjc5U1VwdGU3bXlLU1JP?=
 =?utf-8?B?SW9QaUJNbElBMTNoSTVURkRwdkJsQjdvRXRBME8rUGJxN2l2S2JpMndQeTZE?=
 =?utf-8?B?NExaZngxMzFVNk9mQzFUeGFaYklnVDlIV1A3OU9odHRTS0dkOVNNUHliQXVY?=
 =?utf-8?B?RDYrdnAyUlI5M3FHdnhCSllkSFYvV013NVlhd3J3SkZ5Wm5kdVFTbi9PbHpZ?=
 =?utf-8?B?NHNuMWFvM2ZQa0xQUXJlNSs2NlZXaTdTZEkvZlZRRlVOYXQ1SVFKeGszNHNZ?=
 =?utf-8?B?ZWZSYmM0d0hxb2VwM1VVOVdkNzdnQXNSa1lxbU1DYjVtOXVlZkUrZStuOWN0?=
 =?utf-8?B?SzhwWVU1Z29QUFBFUW10UFpGR1Rwam13ditRKys1NkZtUGx1S3JRZllob3pw?=
 =?utf-8?B?WFdCVHBUb20wM0x5OTB0V1hQb2wvSXZkMmp0bncxc3J4R2VVOThPblhXT3Rz?=
 =?utf-8?B?VGIrMGEyejVZalZBRlppVjY2WVNBclp4TWdWUWlLYkRYRlV6Ry91ano3T1lX?=
 =?utf-8?B?SFp4K1o1SVhmSlpHRFFJQU9uOHdNam85RDlzWUt6aXJ2ckFFYzhHcmtZRll1?=
 =?utf-8?B?WkcxTXhwekpENUFpMkJ4ekprNFFhSjVlRlpGcnlwMC9zMnZESndpQXY2blBU?=
 =?utf-8?B?ZUdKYUdtOXd6UE9pRnlBdkZjakJGNkVXaVFZemovZHRkMUJrcXpNRHhJWVBv?=
 =?utf-8?B?TFZUZ0ExWlhQU3hEbVhyM1ZEQ1FGaXBkbUdyWXZLbGRKSitGcmtSZEtqMXpa?=
 =?utf-8?B?eXJPSURkR2JiUUtKNHk3dzBiT2RNVk1wZVFPaVM4UzJsaTZIbndwNlQvSzZi?=
 =?utf-8?B?aWZ0Nzd2QW0yT00xODVTUE40dnNsb0hxWERUTUFUWTJUU1hlQW5tQ3d4SHNT?=
 =?utf-8?B?dGJLOUtBdGtOT1JhOUpVOUJOR0xWc0JkVHVLY0V1anJuY00zTHR2bmFJRDda?=
 =?utf-8?B?WG5aOXpuVEhQNnVKeUtRaXNzSjJueW54b0ZKY01HR2YrMzJ0dmZ5SDg0WVZY?=
 =?utf-8?B?NitKdE9WRmx1NGNSRll1WVdCeTFsNTBCME1wVUJGc29IRjNvYnhsV2pNOWpL?=
 =?utf-8?Q?ci1e36Q6KgpA/BAbN1qS05G2ztDrJO/eu2Tse?=
X-Exchange-RoutingPolicyChecked:
	rEOLuiH64oQgEkzX4qk0edFcfZmW5RLQ7IQ7wZ7OK1qc9KXiu83ixXabbaMFDDul6iCRDvyjwi0dzqHD9SR6Tmy823pKIvVR+XM/AR3OignZnMSTFSQ7E4oT9JPHa4oLGZW4UEoGRfY3Ghuk6rRXxa1iYrBO7gAt8YIW7mOg/MpwIFVFqvDU8UeRbt3RahS0cE62UC7xwCEsgqkGWPwApz0MdS5IslgpQYNP52AUvZofS2C/n0Zclq0q6qXPpiTDci9dZCM1jjA+pUMHS0dpTVpZc93Ezx5NPy4pQ/EQpqnRqODU9tdOJ89QEThcbVKUoZsh1zZu0kGRHXoqAr7CcA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	D/A5cxL73gvE76a/F/YkAP2jb0pIK5G9hVz0qyAXaTwFo9r5p0jIjrcMqdT47uiUMHOHzA7A41rqJGTdxyAsVD11Czyik/Pz3xoO6GuWLy23D/z6D1nEsqQeHcNZN0VWriGbvR6bgzusCq1rT7q19tSbIvIIPDWiUQHcJYHIjol8kRiUFJO1SDC0w3q8lfOj4x49st9c/QKhwu/A8S6qb0IoLYHa23n+HO5iOYQG5y6du3jv2JaIz1oh4GvgD735nE4LqpuLaYKXFioiPcWLGk0Xj3yeenOS6+oNawNXIm0/xQisuBCjLr7wA0SbPLKtPpGS9CiBsBRyZKYw6ITIwUIXyyEQwpCRPBLgRuSeC9GUadWRq7eopFo/9obc32SX+I/U4CzE6wZAo1SeELrOm1y0+9XjWxdkmFxXv0i7XQyPLnk+t6rzPxkYjPpTKll7DcLQ1D+6NrDznooB6EA0QJIKJg5BuQKt83vTO+282cJ6yxYN91CQ/4Bd6id99E9RNXBc34RE43o2yCTDwAy3dWoP2XojkowL120dGvz6XWDp2Vibkic5/EXfIfqK+CPt/+zVkvfaSe+mPvRbvnF/3bTK4yqabVnNsTti1TcMh10=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1617ba80-be73-468d-f7b4-08df060a73ae
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2026 20:16:47.1042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: op85E0D/A9ylUokeClTbhVGLAFeoC/HGLNi9tuk/J3V2JJ+jlx3CqbnX9Pn+o38opkDy12v5VuofvI7Gbn5soglIkyH84riQyGSdZyusWXU22LBILak6jdJorrCC4PE/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5606
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-29_06,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608290175
X-Authority-Analysis: v=2.4 cv=QoJuG1yd c=1 sm=1 tr=0 ts=6a933e32 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=Ikd4Dj_1AAAA:8
 a=VwQbUJbxAAAA:8 a=WWUUyJtd5RaCo-ZxTmcA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12101
X-Proofpoint-GUID: eU--bn2vXkzHVp00PtVaPdWAx_U_ju3U
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDE3NSBTYWx0ZWRfX9eUglPQAGR7h
 Ih3xeHV6cNhOHXaeZJqKlAMZ1KcTV9Sos2WVxXuCLMuq7jznKUOvw6/5J4iCFhIGnndRO96O76h
 5Zt/nTRZpB+qqW6TCXlewZvcpvScafatKY3eHShFA4GX0axrAmqXfY3dxX7z+PvkpCB5BT9o48q
 insZMBzHBSNum0e+Al9IJ77N/AMsAVKeiJ+IbNt3QJxxwwEzECMS18qSbXqx69ezin+KMI9BfCy
 eGJsu5QfqEm7yAxRkwmUqT0AeIsKpX9R4PjInb/XHfbt5vcO0e5H17HG5S34B8jSBCqAYXKLqF4
 YHedcLvvCHM2+TRjWUDWvjIF0DHHuGVqz+pfxps0L5evQhHuk04IHq0o9Lgb5rritWUkb7L5cXe
 asJxqDOA6e9gqvYESlLKcna0wBRbuDaKT5T3Zh3TIFZsEbF65uHwCct0l8OXY5y5GX7JkwC81/P
 6IhGMh3wru/H07guobxO96MRm+J+HeHyZy3o7W94=
X-Proofpoint-ORIG-GUID: eU--bn2vXkzHVp00PtVaPdWAx_U_ju3U
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDE3NSBTYWx0ZWRfXx244W+sV2C1f
 qTnIFKuazKsAl19YNcshqAyiKxSAJL9k0QP9dGn1TV897S9xxcZMbLWF/GVH1VuQjOKI8prDRnl
 z2b36wLmjoS42Mvqbv/mF7e5H1nVaYpHHriTH3x97RyIhLXEMRXs

Hi Greg/Sasha,

On 20/08/26 8:26 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Jon Hunter <jonathanh@nvidia.com>
> 
> [ Upstream commit a7c28483fd57dd0e1487024af70622315320774b ]
> 
> Commit d87773de9efe ("clocksource/drivers/arm_arch_timer: Default to EL2
> virtual timer when running VHE") updated the ARM arch timer driver to
> use the virtual timer by default if the CPU is running at EL2 with VHE
> enabled. If the CPU is running at EL2 with VHE enabled but there is no
> interrupt provided for the virtual timer, then the following warning is
> displayed:
> 
>   arch_timer: [Firmware Bug]: VHE-capable CPU without EL2 virtual timer
>    interrupt
> 
> This warning is observed on Tegra194 platforms. Tegra194 SoC includes
> NVIDIA Carmel ARM v8.2 CPUs and support an EL2 virtual timer. Fix the
> above warning by adding the PPI for the EL2 virtual timer interrupt for
> Tegra194.
> 
> Fixes: 5425fb15d8ee ("arm64: tegra: Add Tegra194 chip device tree")
> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/arm64/boot/dts/nvidia/tegra194.dtsi | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/nvidia/tegra194.dtsi b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
> index c369507747851..45d0606bd5444 100644
> --- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
> +++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
> @@ -3161,6 +3161,8 @@ timer {
>   			     <GIC_PPI 11
>   				(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
>   			     <GIC_PPI 10
> +				(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
> +			     <GIC_PPI 15
>   				(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>;

I ran an AI-assisted backport review and then checked a70b2fbe03d0 
against the 6.12.y timer driver. The patch adds Tegra194's fifth timer 
interrupt, PPI 15, but 6.12.y still selects the timer as follows:

         if (is_kernel_in_hyp_mode())
                 return ARCH_TIMER_HYP_PPI;

Upstream a7c28483fd57 follows d87773de9efe 
("clocksource/drivers/arm_arch_timer: Default to EL2 virtual timer when 
running VHE"). That earlier commit selects ARCH_TIMER_HYP_VIRT_PPI when 
PPI 15 is available and supplies the matching virtual event, counter, 
IRQ, and KVM PTP handling. In 6.12.y the DT parser records PPI 15, but 
no path selects it, so this DTS backport is inert and cannot provide its 
stated VHE timer behavior.

d87773de9efe is a broader generic arm64 VHE timer-policy change, not a 
small Tegra-only data prerequisite, pulling that
feature stack into 6.12.y solely for this DTS change does not look 
suitable for stable.

I don't think it is a functional regression that could be caused by 
this, so we probbaly need not do anything but maybe authors of this 
patch could confirm.

thanks,
Harshit


>   		interrupt-parent = <&gic>;
>   		always-on;

