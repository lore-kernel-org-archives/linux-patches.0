Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E068379C2A
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 04:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788238601; cv=fail; b=M2KX4EDfD23WbRJLu/cIOojqvZEIO5BIm7m/Z938dVhFWm5zUTF7fAZFmGfgfaWXIOhku9bC1zu1LUTy/77ORxDlHuxrOUpH4xPCcOsI9jslvjJqJOSR6zG2arX4pKD0yON5kycNy+e3JtEvCw2Em61bsWxK3faOkkkMkDA6gtE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788238601; c=relaxed/simple;
	bh=AKolhqRNMyFpzd51sSdaXJtUbk5N9OMgROrJGCDSyhQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ct+lmijOToRROeqn8PlytCKsg0GQDzsotHkDEBo/M4XdmPmJa4NdqvpNIpbbgkUPkq1uz6h+eojHhmPE2fcwIbamRbqCxMfYkUVWCzR/eY0/PEympqC7OlKmyqGNw8zhRBErYhYoqhjnMo4XBLLplKgmDWWo+9WHOJ367t8dQGY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UA1plc9H; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jWnArIJp; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UA1plc9H";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jWnArIJp"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VLBsZu2311152;
	Tue, 1 Sep 2026 04:56:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IlhMbdAw86HStMqfUb711x7ufdcZ4v3xhFgHmMJ8rlI=; b=
	UA1plc9HTiyqc2fbYjRE6FSRP/GShkl50kTn/NIkCKo7zNlQwSDOQlnr+PCvBWoV
	N8Z/2Ccq0DELZwJRZ18YoTbGZgjrEwPAu2aemyCUDY1udLWSbHr1Y2J7qNdLTMLw
	C7DesYSQ7zjIyb9b6dgkMaI5JaTg/wypRsSh1flAVg9VE/gtrkZHvSL1mDK6dKi5
	1hIRW8F6/A5DQNZjvvubTXyAQc/NwgUc2lgFdyBcBj2KxWlcFvJXdctroPO0xUGz
	g2HfRyurqEZnx8s8nua8NVOhAWeaOxtBieCQYkj2MMabDwaSjyESesJxrKFmEQRM
	3GDfwzasUIQ4FjfwqThuFA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbq1skurv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 04:56:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6814tb7e024809;
	Tue, 1 Sep 2026 04:56:24 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010005.outbound.protection.outlook.com [52.101.56.5])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvq4qbr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 04:56:23 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rlL4zgDxbcuFs2y0XfkB1Qg/SpJjhrMcFJO/Na2om35weswAZQTMWh+7iOWotW8nvHLAeOx44BGlO0h7Ho1fUQ8gY7nRaO5X0yVp7peYpGIzdo/+A+CtMjABo4p8xZawzddVZdjkH6vO3ZrmtTaAsx/DiPn92Qb0K7sFn0PaYbv4iLAUy4yoPQpUdUWcf5Kb0g+T/usRCmo58ge9xSvlJEDe0wO5KLFwwknePilkNlXBNS86oS8AdIXNP7IAa6d20j3YnBmN1EyS1M61YpTL+j6/ZhaDo2otZlG9axMLHSbl/xGdrGBygLDvghxNPYI4IFtpa01aBGP1h22ZjLYg4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IlhMbdAw86HStMqfUb711x7ufdcZ4v3xhFgHmMJ8rlI=;
 b=vYSRocaNn4G7RWzJ6g4xDr945FPp68yqJnSQqCQg5R3NSDdezHotFx6rZg2BjLXwx7SaRBFTMXje2DwjqsqkN6bTocy4WLtQzLbD9j5U+cRIM4E2ISjrXG6EL6zoQZNZuH6IQU7jRlfXrjFwzBh/B1Q5Ice+hyItFU5+tRmdpmg7ECu9yvhZTu9dPPBO+ADMX1XQnDUq2j4+aJqR84qUhXeEgQfH/p4aiKtEu2ZGfmxvk0zM60JJ5kektexJ1489yDCHAYRlKJc6GRa1Ad/2ARzXP+dqLMPxWV8zF7FlUA+3SD9O0NvsAYPGyfHJnSoa0GH8KKTg+E2tTyprVYCn7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IlhMbdAw86HStMqfUb711x7ufdcZ4v3xhFgHmMJ8rlI=;
 b=jWnArIJpPwhYyIk/5quzbm6Y4V/x7suixnrUzzt4+wupIErDQR8LNDKT3+yjgR4xCXjyKI7wVpQpztMzxKzVe5kggagUCyxUnv65WR1azXetlMurxIQNfr5ZHz8xYcVCshoKcwa4WjAjdD2V7vl0UT1rrExyY84LpleKcQNlWEM=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SJ0PR10MB4511.namprd10.prod.outlook.com (2603:10b6:a03:2de::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Tue, 1 Sep
 2026 04:56:21 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 04:56:20 +0000
Message-ID: <92d4efaf-664c-4d68-a145-c45c4864965a@oracle.com>
Date: Tue, 1 Sep 2026 10:26:09 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/99] 6.12.108-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20260831133359.740409777@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0213.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::7) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SJ0PR10MB4511:EE_
X-MS-Office365-Filtering-Correlation-Id: ba50480e-e90a-4cad-d84d-08df07e55d69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	912ThAoIBc4eit74ZApbAQycJ6aUsjR+/HFKDENsqZRsjDs6fxN0OUFIHiohudl8L/H17vDHxg+Vlcy6beJtWJvWQ+lu9aA+G7ovzai/N41Xm2Bcehelb60thN12Yivv+K/tbjq4g5aino8WEjtVA7bpVGgwv5X1Wq9EGgW3kpL02LOtzYM3p2+pw450+G8Po2mRg3V/3I4csqwxxrA30cWxtpNcSM1ew636wCGJyN7FCP6Bk2o3Bzn047mw+eMlX7GeN4BuBt3ZiEpnBYv6b24+xUo80175j/Aa2ajLY2XJnoLUjYlSHXvxim6+OKM2hfwmpBKGJEnbxsA5Cvj78NBh4ayyWrcgDlhafxxhy5X6YelOlNvHb3rWzYukn/PpsGCdHL1ETM6d0Rk1m2rG2rOdRwIAygHtDOsIrGsbHB9gQ3Arioy0jIEBO6u//+n5QCpsIVEkFO+EjfQJv0SEt76yYL9dtAOKCPyhd5rhflSPHyB4xaSh+ntfE0F9xvtT/o+b+Yi6MrPMT9Vkms5s7aPv4skyFzc+N5ESVdJGo6gIXcEb25sBeZHGkBrkWbbkn3nAgqCP/TGAIPrVyKZVbu9QvXY78EXS+MiDMiugRFa/2mcGM7atv9MZ+er44rDgVMcQck64YtLoF7HIpJlPCcaWJV3mFggR61xsW9UVr5A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SVo2djVSMWlDUHo5emY5Y21HM3F4UW16a0xtU2F2OFlUdHh5MFNlelNIeEpV?=
 =?utf-8?B?S0tFcjNVSllmL0NGVWNYVGdrZWNvZnFBYllKOUZJTWtSMksrcVcwNFJJM3Vw?=
 =?utf-8?B?SndvR1J0UDRMMDUxL1lDV0pFdG54WUdyVnJrQ1FiVTluTXNLTW1IZUFsdDlP?=
 =?utf-8?B?Q0NnN3NvSDU0V21QblJvR2g1RHZ4Mk1pK2ZBdjByaFlmVnplNTZXZGsxOUNp?=
 =?utf-8?B?ZjFiaFlnWWJUT0gxVEhEMVdVR2RYNzJJUHF5UElJTDU2R2s0bzBrKzRuR09W?=
 =?utf-8?B?b24vMlZkcTJKOVBRSzY5MU1QVHBMOElwaW5GNDBlNWgzaGRHSlNQUm9mNDd5?=
 =?utf-8?B?aDFEWFRINThlUHVWUVVNOEZtSHFKQ0IrNjE4UzJjekIrTlpyM3A5dm5DNXBq?=
 =?utf-8?B?UzBwR0xJU3hDeFVkdW8wYzJYQnplN2U0NzFzQkprSFp5ZVB4bTJwcG5SNW1V?=
 =?utf-8?B?RjhCNUo2VkxiWWdaNDNXTlk1bnN2QWw0Uzk5ZkE4ZVdZVDlLT0xHRk14R1lh?=
 =?utf-8?B?MzY1VGJ6OXJmT1F2QkVYMkRkc1h5VnFXZXJ1bXJ5a204Vm5xU0JLUUNHU2Iv?=
 =?utf-8?B?eDVUTCs4bU8vdUdvS3d2SWh6cTNCNWl4Z0Ywb2c0V09ORzJrQllUdUp4THBq?=
 =?utf-8?B?UEVCZXZrc0tLWlo3ek1WVHV4dnVGamRISnZXK0pjS3FSdzhuVWNXdnFIY2ZH?=
 =?utf-8?B?aUh1dFlCNzFuZkVvN1ZvSGkyZ0o2TTB4UlliZE9USzRYY3c2a3ZrWFdleVdl?=
 =?utf-8?B?RXBreUVOTlJrL3ZubU5IcldhSFJTTEFHL2J2dk83K0lpNW1lVUNMQytvbjVv?=
 =?utf-8?B?WFNqOVRvVGM5MWhGaWFYY0h4b04zNDJVTUF5YUxYZ21OMzFOUEMvbzRuWkVO?=
 =?utf-8?B?T2VBck9mZmhwSEdxOFpLSVhodTQvQm1CdnErTUpJWm1HY3JLTFdOMHVGdVdF?=
 =?utf-8?B?Tm8ybENwQkpHd1ExcWZpVE9tNWNuM1Yva3ZHbXg1ODczZ1UwUWYyazY1Z1Zu?=
 =?utf-8?B?N20raDBXTDhSQkg1eEh2TVd3eHpocFF0NGNZcFFldVlGVVhvYW9QVzNQZDJI?=
 =?utf-8?B?amtDOUFsVUVULzRlcVNlWVlSNFpFZEJaeUxNVktPbzcwQXk5N2pRZEwzUEdO?=
 =?utf-8?B?ZTFJdUFYbHBESGQrYitZZFF6UDJSRHd4MlcvZzNmMmVoY01xVmZpSTlvRFBy?=
 =?utf-8?B?SDZhMCs5TlM1ajc4N2x6ZDUvUnRPcVpMMDZMcm1rK0cxbmY3RWZDd0hLSW9m?=
 =?utf-8?B?bmNuTGt4VFVqdHpRQ0FZZURHblB1am9tTVNTVEdqVDUwYW5NY0Y5b0dmOGls?=
 =?utf-8?B?bTI1M1Z2dVVQR3Foa3B0dmRhYlJsUFI1NFVxNlNnMGc2MURBaFV2czNwQk9R?=
 =?utf-8?B?ZGhtdzd0bVhka0F6QWFUamQyTnZmdy84NngrYVFpNUlTSTAwK2g3dHg3Wis5?=
 =?utf-8?B?NW9yMnFVL2lzdVNrSEphS21xZ3VYaWcveFN5SXMxTEJCTHc4QVBnTEtQRkkw?=
 =?utf-8?B?S1V3dFVuSmZ5cEo1MDJVWW9aQUFrNDZseVBYQUJFdWFOZHl4VVFHL1BYMCsv?=
 =?utf-8?B?OUdzSlpXbzgxdFhCd0g0UjByd1NMRmZCc1FzdkY0WGw4RVd5ZU5kclc4V2FS?=
 =?utf-8?B?Wk52RVYxL2dYVUk1WEFHWFN5ZnBuNGNMcWhJY29IaHZHaUJVbWxpQnViU3Vp?=
 =?utf-8?B?dzVuU1BaRitmMENMQ1kyejRVcEg5bVB6eDRidVptUWJNTE9SZ0Mxa2xZbjV0?=
 =?utf-8?B?dlFaWHNhbkx6Z1EyY3Vack9CYXBNSUxXeWdZT2NFWGZIUW5pNWM2cmlvQXlr?=
 =?utf-8?B?NFJ0SFFUVzhKbHNnN08vUGZncnNLdnlVNHh0S3VBaHVJZEZBd0k5UFVCV3Zt?=
 =?utf-8?B?L1NpNFNyQjR6ZHZNZ2FZOTYxRkNUU1plMGVvUVRYNmNLL09kN3E1aGQ5eW1G?=
 =?utf-8?B?UlRxSG42OERscDJWUmlCYVJnQzJPZHVOSTMzdnl6Mm9LT0JZdml0aE81WW1q?=
 =?utf-8?B?TEpobUdYL0RucXNoQ2o3QVpUbUh0MmZ2VDBVNkd3WDI3ek5ybDh5WXYvVVJS?=
 =?utf-8?B?T1V2ZE9mb1lXQUEzTk1Ha1hQSXJzV2RZaGJKblJDTWVQWG1PdU8rUExCR281?=
 =?utf-8?B?OUt6NDF1VnljMms2UVFPWnVRc0lmSlVDZjZGRXRiTkF3ZXIwK1BPTHd5cUwr?=
 =?utf-8?B?bmRETVRQQS84VVM4WUlXd1hTVTZYLzMzaEJTRGdGdW0yOStQZjE4RThOQlNs?=
 =?utf-8?B?dWlzQ0RnRzZGQjdvYksrUmdTeVBaZWR1OEFyMmhjK25xczdtVHNoSmwrbFp5?=
 =?utf-8?B?eVgyNDhOd0VqL2xKTSsvM3VuNEFrb1Jlcm83Mk5SZnMyTUxCdnQ3dmF3TmV4?=
 =?utf-8?Q?WGhbxNKj/XZyLuwklG2I4GRzUl5WUhf32ea5U?=
X-Exchange-RoutingPolicyChecked:
	FXkVMcqZ4GnBn17XEX+pv+SB5SBlD9fzm34+trf3gccD2rIWP8lraHa2PD7cXhnujZ1yudMlHWnPIBACk5Q9I8YPJ4Awm4jsdD9UhmlwblntaG04l9HrU71r3am/yHq9cWTIdtepSaJiPVCpB0+6TMzLY7HN4Ngp+dge0V4oyzZg3J7m3N04U5IcGtG9zjqUDYKkCgp3fFGX/gR0bDqJtyYDaXLk1xhfdNI36fbXwmC4lTNPgIv8h3L+3e9Ry7/ZDVGH0clr5t6MW3NhY0G0vfXp51BM0uY+vu0cO4ZwZ5Yq+zz4QKiZ1/Y+PF/rCZHWLAqhR/R9WzGcrIDu7iF8Aw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kb8JsNCz3U1vH3LQV0yrOZxAP410vSELczCZaRmQOU84dICRdSlkfEiAdTCifUDM6p8BeOSmE0f/4L5+KMD/GdyrvSS9+LSAGoC97wDgUvN0d2CCg6U7udHjNI/qyNghj1pvbZEbNWgNc+pqQwmXeBPrAqy+D+c1hT3W7/FIu/t7eP8tDfiW4M9EV9eliILQ1Xr+LGbo42v9JKiyjjpCTAn3PPJwQS+RsKCSxFGfBVakSbhl3gIl+zebcAb5hGQtsXPUCZw/92LkCQkAzRHql3A6cCIf5egiYSFGMLRXV5IFlup1yBiVWnoonlYOAFQ1RNdqOXzeRmbd8I77oZHNgN9P7/Fu+OfE1nGPavMQ9sC1b7xl+LX/mWl1dKURIgbb+fXHA3U3DUjbcZoVRDMF4AiTEMHbE8wS8Iu+ugWTlhyXkfMtyhmA2+91hQ2wfD4RZvSywysxr2b18Jz7LWeab2oRoYegFHfPMot0lNh5fMINn3/KPi5R6l8ydIjLDoUaJTknOcI8GRlXJnTkSrI++7IHk8nI5QESUCWnXhng4y3Z4jFXSjol8GDW7XwMt/vM7tEu34XQjGVmN376v5pKoFCOQfvu+TfJO8yTrcsSqsI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba50480e-e90a-4cad-d84d-08df07e55d69
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 04:56:20.9019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RArfaFESgKMi+S5Wf4yU8a9Azx+48EfbUP5MIVshFzNgAPH2COta5f5r8PoHcIE1Q2d2bHCNCWmYVz92V6zTzz5MhRTzwyvdoxbp3RR1g+p65IgcMx/vo2wnUK7hMs4C
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4511
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_01,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609010041
X-Authority-Analysis: v=2.4 cv=Vp0Txe2n c=1 sm=1 tr=0 ts=6a965af8 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8
 a=PyDOeFXNue_vNzKc-FAA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13521
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA0MCBTYWx0ZWRfXwMzfbtKpec63
 ZcypznMnX430ZBQL62Ttbo7pn1HMqKRhJT1xyxirGozPXCf2f257yNwu2s105eF4+oo68g5FMLC
 NBVadjOcDRAmj01sZDu33juWOKA+/8EHMk58zmTM7zHsV2eqgjR+VgCFirkXlII9aT9swaQaoXp
 H3cAnF+KVBoGLIIJncF9BC861YvpOewEzzGSrtMhunPK/TWo2EehRQxlrhpCsNT2hMKIRg/abc+
 g8wi3sYu6N7GJB2CkectO8/1GRd/59+fn1isndbKeWGqUdchiJElzlKiAdRKXgQEvWvMP57EDOc
 4m18tsAn3JwbIalIow4DXgWOozHH1soBS1bV+x+R/FEYdyfUd7LTiDAfPN/FF08jC/JuDFPVbyH
 mb2wf3pJ2FjUV+xu5N08kI38/4Uj/SOI0CdIsOeCsMZuNfA86TCiQeQYHP3Bl9cG7DkwajZ8E77
 Qt32oUQd6ZRorIGDcHtDxIfQScH7FwJDD6UOPehU=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA0MCBTYWx0ZWRfX1kwkQ3C4oEv2
 z0S/5sv0x859AFGsLt18BzSaP3VizgKJ9ZkqDqA6J5Jv81anMjSdY2YULAQAZBIx6Ra4XGl+PDq
 040ZqMQpRvVNHtsrnLLymAbFDgnweKXOFqaBk0UNDJ/onFlz0p5i
X-Proofpoint-ORIG-GUID: NBR8TCSEZ0hARHlWoPf0tEVs_y_JMAIw
X-Proofpoint-GUID: NBR8TCSEZ0hARHlWoPf0tEVs_y_JMAIw

Hi Greg,

On 31/08/26 7:03 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.108 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

No problems seen on x86_64 and aarch64 with our testing.

AI assisted reviews haven't spotted any problems

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>


Thanks,
Harshit

