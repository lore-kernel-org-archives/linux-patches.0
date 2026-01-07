Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12CF32938E
	for <patches@lists.linux.dev>; Wed,  7 Jan 2026 13:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767793492; cv=fail; b=utp/gPSqYinZ2yQpOICiX/5M3oXX3FcADiJcD6bTK2RRpKN4mI19rp48D9ioXMuT18z21kenRfgI3eCMqJuczq3UVx0k5i9m8fmjpTDVhbgb83yo83xAviVnKYsTJM20qLPKrz2FrjDdp7mOEgAlvsC5KQTZKaYDDetYKT2ncLM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767793492; c=relaxed/simple;
	bh=n+U1Tb/V2qLEh2T7RTR8mqhj8DeA1PR0qF1UjM73fEg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gjFpBp7wl+tFGlh47cTOknapZBq/ZqIo+v2PbZvmQmOIBrTaYfa3qleDiMG0Fo6EPzahuXJQ/tdIiFssjMbE1X6oGzxmpsyfM1auA7/PuK3L7mZ6SXtomtlW5Umn81CmRCO9aE4O8RA/ROkfEMZxfuGn8MXZNrOa8uq/8vma97I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E5CaaoUg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YCFFVGWx; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E5CaaoUg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YCFFVGWx"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 607CSYXY2010691;
	Wed, 7 Jan 2026 13:44:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=k1pv0oPRaPHQFkDBtZCJZGajLNGz9SDzV1eAqPFbNDU=; b=
	E5CaaoUgbucw7kRMglU91uk6BvG/JCiBQd8HSy+rP9bsI0GuCPBeE0ZtTx76/p0z
	myqZ55KUZfX1SMesoN26PSyN7NZGVlcMS1PjxBcxhgZCLYj7NEg4t9JldcJo15Wh
	t1QRFLJFTawuhexsUO8QKrrNSsKSGbHlcIm1cNreRVnKTLSynefnlOTQW+wCiDrx
	RStOtmprgRjPhaqP2GDFIEqaGX3FEmH5JujTuJ6HI5jAOkrpVbGkdzKx4yZ0KX3T
	R27MmwEZPo2quqO/VeJ7i/e7MQYhzs2MsvXK0DSreXYpJ9P4PvG5hdLyopGHHmyr
	hkN+iEFFnqSRslyUYc6V7w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bhqh582vr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 13:44:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 607CkJ6V017556;
	Wed, 7 Jan 2026 13:44:27 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012039.outbound.protection.outlook.com [40.93.195.39])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj9kxee-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 13:44:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ol+gWZeAp07LMpGAbm2D0AALMcEhqwjemjdnXYcLBpb2CtCphUJQAO5WVnYB2PY/w9scMWX6aqlmvoRfq5FXM3H7isAzcwzB3b+CuWKhX6eM+tfe/rkApVFV++quBfSL27l6VpN2equ71G6O/IXlFXnthQCqddnSwDOJnjgbCnLrhUO8wTWJHWjEuRkjW3EHA+VRvRIavKoxuqJYlGmmGFLm3bO09t1uQySPRb4IT1eoW212Bea7bFmslkzIGrFERNkffnUmx442Yj8Wp37eQ7LEIffPG6o+ethPkRX7uDOD732QeQGAHc7TFWPJ1hfAhMi7eGU78TpuZh+ac/TAog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k1pv0oPRaPHQFkDBtZCJZGajLNGz9SDzV1eAqPFbNDU=;
 b=rrTx+JhDTrVC6bj2ZTYmA4CsAYIeLceZW3FaPy3oDJT4jifePmx+sYU/ig2Vo/LTBq+0TJ1Jt+/y4zU3xNcoVAGact5mqjwAGLNhub+oAHGQsh3bkOdSsEY5PPKN7FAEemyRH6Yq1IFGqWs4ysC4T/qaqvJ2ohm9SSzgHhlabbJsqT63V5EfgELKev3lF0b7OdeKnh9fjIT0dJR3xcUFv+HvXsIFYmue+yR8Nr0CDx4nW4q/5xJ8p6IV3FmcgU7Ay8IdN3u6S8/wtd5vDVeoRg6h7ahsQEWMpgWe1mRbSqW6rgwLFfhl9fX66MSduC2QES38fYXrwaG0ZZFU03gGbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1pv0oPRaPHQFkDBtZCJZGajLNGz9SDzV1eAqPFbNDU=;
 b=YCFFVGWxOLX3ix0Z5gLLZqH98pvLFzxEZBqg68X2+oW8iqZa9NWn4DhxYNVQwKcgJ5HEuX+X9St+gzf3DfGss7c9ryc1cGTbCRn9Ffde38Bj6OBHvxZEIbMvKky77TbO2TN5jrgb4ySXJ9rLuHtZcpUEbQ8AwWErRV/iZjc/hAo=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SJ0PR10MB4528.namprd10.prod.outlook.com (2603:10b6:a03:2d4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Wed, 7 Jan
 2026 13:44:24 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 13:44:24 +0000
Message-ID: <938aa760-0e53-4ca5-8811-23a933093aad@oracle.com>
Date: Wed, 7 Jan 2026 19:14:13 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/567] 6.12.64-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20260106170451.332875001@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0068.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::32) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SJ0PR10MB4528:EE_
X-MS-Office365-Filtering-Correlation-Id: a861c036-d835-4911-29fb-08de4df2de48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V0JBZlNQaldFeEVJcTQzOFFFVU9rV0oyQVk3dGdiaGg3cjZqMVF2U0tmajJ4?=
 =?utf-8?B?dEVPMlVuOFdLTXlXR2tLYWQyRlVGSFd6SG9tbGpZWEsyRG9wVlBJZDR3VHBY?=
 =?utf-8?B?Y0V2MU9GcUZUUUdldXR5enZGaVVWS2I0SXRiMEJvWGFGTXl5THJzRTlGZ1p4?=
 =?utf-8?B?cFI4OC9LZ2ZpZUFXemdiT1J0Rk5mS1pTQ1RCeklpdVhSbERJMjlGTlJNaDhH?=
 =?utf-8?B?bEF0cGM4U0hteGloRzFUbk5KbWRMR1NGejNka2p5UHdUTzhVZ3c5a2pkSkhG?=
 =?utf-8?B?UEpUR3VNZHdwMGs0b2NmRmM3cXFNNlNGMStDRThFaGNubWJ6bGFGM1YrWVIz?=
 =?utf-8?B?L3VmeWdudXA5c0RXOWxQbG0rTDVYZ3ZYSTRxYTJoV0pMdTdqaHY5UW9GenJJ?=
 =?utf-8?B?Zm5NRUdBdlZvZFNCam9VYnluNDR5bWpGMjYySzVJeEU5WW93WDBCR1JydDlE?=
 =?utf-8?B?VWZJVURPTndXZHB0c0VNenAxa1JLa2NGQXlRYU9IT3llbTVLZER2OUZBV0Jh?=
 =?utf-8?B?NDIvMnNoVmlhVVQ4V2htQ1pmd3J6aGgyQlBHT1RuNHc4dW5GcGVSd2hHUjh0?=
 =?utf-8?B?a09aRHFETVNQU1UxdkRZWXZoZXZkU3dZcnRsNmI4c2NCYXZqM3FpVFhtUWtG?=
 =?utf-8?B?QzZmM2R4dUVreDE1dXArTzhmbEFGSjg0ZUJOQkZQMFJveU4zMGpCZ2ZjbFRV?=
 =?utf-8?B?alVoMU91dGhScndGdzlGSTNieFpHY2RET01vcFhieVFObWZNNk9kaHJzSldB?=
 =?utf-8?B?QVowNG1IRE8rME5ud0cweW9peGZ1ZzIvNHdKTUpwWk1IMk84NUtZalNXcnFu?=
 =?utf-8?B?VWtOWFJHdGhqR0FDMmI5eDNqWTVsdE5sRkpqTitxM3F1Zjd3Q1RDY0dURGcv?=
 =?utf-8?B?MVRROTAyMUVoSkZKUXpBQ0dpQXVCS0p0WGpvRDRoQ0VTYnUyUEZjOGQzVjlJ?=
 =?utf-8?B?TkM2MVFXbVU3ajgxSFJQRnA2ZFlhQTBIdE1JYkkzSWR6dWkrUUJaRkJHUGs1?=
 =?utf-8?B?STdjR1k2YTVzMlBJWkl2emZzSTdnbWMwVWRndUVlTkxVN2x0eTBReXIwSTZn?=
 =?utf-8?B?UGVyRU5BOHVEQ0FEMlNhQk9hZnVwY0oxM3Y4R1Z5cnhVdWlPczRySGdXR0xT?=
 =?utf-8?B?YU4rczZGMGVvbmxBOFZtNGlYN3BRUThxVnJMY3AwUjkvbjg1bkFTRkNHaVZy?=
 =?utf-8?B?QWpYczhCNFpLNjZlU0xuWkZhMnk2TUxyOEJYbkZ6RmJuazBoZ3kzc0Y5b1I0?=
 =?utf-8?B?QkxQQWhGeWRuaEpVbHlCUVgyano0VldkM1JXM0NZVXFVdnhXdUFTaHVoK0E1?=
 =?utf-8?B?OWdraFZLRlltcThnMDN1dzBEa0ErVUNkd3VINzdOcUNsbXJPSHRIUkVVelJn?=
 =?utf-8?B?aGx0R012SlZmYzdUaWVyMGdySUErbFN3cTVoZVkzcTJ4aDlQMzB1MmczK1VM?=
 =?utf-8?B?WGs4YXBvTzlUYUNhTFRiK0UxZzhnSC9VSHhyQjJZWk1jSjRBUU1Zc2svakNY?=
 =?utf-8?B?bE9DTWsrK09KSEdEdDNucUZXMEN4VW9TUzArQmtiRXB5NW8yZVZTNHhPbHNN?=
 =?utf-8?B?VnV1aUNFZzU2QWp0QmRvc1AzNDU3YmJDQS8zYlhXa2VOV3ZSaHhwRlpSRlpq?=
 =?utf-8?B?T1dxdGdSVEE4MTdiWkxZcTJPbmd4WGRJeFZaUDhsakRaRVRoWE5CMVppT3hn?=
 =?utf-8?B?b3lKZFJZck5RTWFXZno5a2RqOWxPWmFTUk80QXFmekJRV2RveGszbmVnZDg1?=
 =?utf-8?B?RmdjeDM0WURheEJlQlM1V0UxT3pYSHhyZXhIYTJZazI4RnVIbmhVOG8rN3pL?=
 =?utf-8?B?Sy9IbGJhc0p2STBOa0FuaXdEaHM5ZmJFUWYvL3VnU3V6N01WZ0pSR25iRTVl?=
 =?utf-8?B?c2VsdEpoMW1DVkVDenU0Y2VWNWVTVVAzVEd5SGVUZ1pXeGhVbncxWHVQSmFC?=
 =?utf-8?Q?0RDXQB/Ea1TWVY9kFhNhgq8KSzNbCTyG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RWVqRlBBbFhrR0l2Ui9BUnA1UGVXZDR4eHo0dTN5b0V4TTBaYkoxZnF6Y3o5?=
 =?utf-8?B?MkdGcDNTMlBPam4xc0ltWnVFeHNBVzJuKzBXWWZOZ3Evb3lBMGZkbk1ZWXIx?=
 =?utf-8?B?T3BTN0dUY1l1eCt1RjhWRTVkQU5IQXNWVFFNNS94YnU0VnUzZkE0QUI4MW4y?=
 =?utf-8?B?QW5CRTVrenhvaU8zSGZoajFRMG1tbGdpa0NUUkUyWmpOWjBLTnFvR1Vlc0N6?=
 =?utf-8?B?TFR6aGl4NGxVNHh6MjB3Y1hzWWJJcGVxS2d0NHVLNm01T3lqck1nWUswZjRD?=
 =?utf-8?B?aHlPcVJIZ2g5ZGJZREZIUlV2SElzcFZYWW02bURnUGJsQU5JTjFFVTNqeHBV?=
 =?utf-8?B?STNCSlZMVGV1ME5QUUc1M1NJNC9GZE9oNkpmRlpjNktlb1FUOWRheVREN0xR?=
 =?utf-8?B?c2VGZElMbUNYMVFqRExKZkgwY25obnhpQXcyQk8yNktDMytFTDYxZjRSNHRL?=
 =?utf-8?B?MTlCWnJCenAyRlltUFZLeGNnc2pmRTAybWtTV216ekFRaUlrVU4vTEFETzJY?=
 =?utf-8?B?VGZNdzg3Q2ZpYkRhVjc5MVpRUlp6Q3MxNlV0WFhua3p6OUYzTHA5d1dCUVBS?=
 =?utf-8?B?ZGRwWlZLU1V5c2tSUmlMWXZMQXcvdktHcysrc3NEYVpjWXkxOFNFNHpHN0c5?=
 =?utf-8?B?YXR2blRiOTZTd3JQMjI4T2RIWnoyK0tYNWp6OE5OR09SWUdGcUFBWDRjVnZZ?=
 =?utf-8?B?RlpjZU5kWElYUEUvWEhLNm15MkxBMWFLd3ZJNUVYa1h6aXBTeExQWi9PQ0FP?=
 =?utf-8?B?SVdrMlc4WXNFMFVIVW16SC9iblVhOWxPbDJUdjN1bERiUW1YUGdtVW1TQWN2?=
 =?utf-8?B?QkRRNGZZZytTL2txNFNVSWdURUNWNmdPWjJCT0ozQnUzTGNJZitOcDdyUmkz?=
 =?utf-8?B?OHlncDIxWDRjNzI0UDFBVEJKZml4WXpqYUtRam5IZHR0Z2s2TURiY3Q0c3VG?=
 =?utf-8?B?OStjQlJHY0E2djhXSTE3VHBtZ0xpQktyMXAzMENhTmJkU2pmdmVnVjFNOU14?=
 =?utf-8?B?U3k3czVzdTlwRG5xSGxKWldWemlqYmZON2RrQ0dJM1dHUVJUcExUS1RxZDBu?=
 =?utf-8?B?bTlPMWk3YnhxMTVXbDZ6Q1NEWEN0UkZiajhqY1UwMlViYlhhZGFvOTdyR3BF?=
 =?utf-8?B?bFhybHpNRi92Z0FkdU5uMWV1aVp2R1RjM3VpQmpabHYzemdXYkNJTGI0OG1N?=
 =?utf-8?B?d1BLeHNHQnZsQ3lwbXFwakx4cFNlNngxRk9Zcno3dzVjQ0s0UXhsUmpGY0hx?=
 =?utf-8?B?K2xHT2kzUklmMUsrVXV4b2IxQkVLRGM3UW8zZjR3bGIvUWR4d2IxMHMzclc3?=
 =?utf-8?B?Mng2SnNUTjgxRTl1V2ovK0FacW81bXF1ejVLYjNPa1RwUHVYY0hWOWFRWmx6?=
 =?utf-8?B?VC9HQ1VxaXdRQmsyTzM1WVBNTkc0K2E3bGI0aUV3bGx2NFhBWHFxTzFTcUR2?=
 =?utf-8?B?cmdyLzFuanJ3YXl1ZUJodXF4Rndyd3pzcXNiYm52QXZodXVlVGI3U0QxUVBX?=
 =?utf-8?B?a3lqN21pcjk2bUNUckx6T0NkQmZIdGpmNjVBSWJaelFjNkdrWmJrbENOS3J0?=
 =?utf-8?B?Sjhib1JmUWxweTczSlRDaEFFNFphNDRPUStNajFiVWpjQzlSY2JDOXZJMnhu?=
 =?utf-8?B?NU1MVFRuay9OR1hFbytYTXNQQUJ0R3hTeXRwK25SV2lRcjNPZGs2bk5TQnA2?=
 =?utf-8?B?T1VaQk5oOERBRW5FemxTMVpFUnBhRUpDbGhiaVFySEF0Z04vZThvejdHK2k3?=
 =?utf-8?B?WWtiTEhZaW13VVRYb3poNHZHVzFpWWhjcXRuanVSMUNMWXVGWm9aRisxdGk5?=
 =?utf-8?B?Z052cjFXSXg1M0cvMGRPaGE1dW91VlpTNG8vTElhdEdpYkc4blJGcDBXQVdu?=
 =?utf-8?B?c21hbDlIRWlqVUcxVlF2STZSM2VSay9TaEdaOHVYamxsOWRIamVjcDJCSmds?=
 =?utf-8?B?TWlwZHM5U0R2RW9qeGZTNVllT0dyYnJZTEVEOE5BQzEydDE4NjczVzNrc2Ex?=
 =?utf-8?B?UGZrQUo4OHpJT0tqRlVwU0VoaUtWVGwxNUYydFFTUnBFdkYrbzZ6MDB5RDlr?=
 =?utf-8?B?R2NZYWRhbkZCaUlNeCtFMXNMTTdLcDAyT21qR1k3eWljRkZqajEvVlNNc3Rp?=
 =?utf-8?B?d3Y1YXplUnIxVXhBZm5iTXRhc1d0OEtIOGtZVHVKQ01LMlZpbkw5Z080YWR3?=
 =?utf-8?B?aDVNY01JNlVjbmlaMWJVNXhsaU1XQkE4TEUrWE9NdlNsU3k2Qmh5SVhjUURm?=
 =?utf-8?B?RGpRUldEVVVDZ3pndFFoZGZkSVJQazZKRnJndjIyZS9TczkvSGZTUlNCa1pO?=
 =?utf-8?B?bzRhTUsrZzR4NlFadHNpejJFZEg4Q0tDOFBaeGlQSmJGVDRaTkJ4d05UTXFG?=
 =?utf-8?Q?J8ju5Na0Y4mu5uCwE2/1bsN0XVurKF429L5zs?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OgmYN3+ES1HUnevtW/YtrtgMotqd6HoU5+X0jxyj6BImp0hS08jvIOhFi8q/bsXYxROdZolQBRyH0LJy3UEfTjYNZVioPnKBajLGO/IKOlwss1zOIpa0f9wym3AiAVQ/Ick3uJ71v6jyNgcV91oyTuj0UASKJ8o9qAYIiXwEGpLwPoHqWZs9ObFeqgw3MADUr/1uUJ07sYtCskZf1N79afSgnpmAhnO2ptHL6Zb9xOfFRTXnnv7dJGVZGk9jaoeXGqzwervLXmPwD/QxYwSxz8DPUjAB/UfVCnrxo9zriuEWQWiOVC258GPehTYRGglHNS8GULugJVhFkaPxGUWFH75R8fV4RmExX1XD6VR8JX/AtW+YIq0t+q9h1jWl0kLWJTRN2mqriHeJZweHh3+/vqdatZGoipJ9ST/uWzWf+QufUPYXhINd91/orbkiqzbFQ2+wbvLN7lInBlj0AZs2Uln4g5SmZY51vZfeeE1lDDiTAtFTxr1WRfZVOLPWVAm9hZclvxwZiixOXseuKBP3HF1kMu2thfIKqsIOrpbr9qEBROacKsBawEbRw2yNgBdJhF0s26ozr1pgGBYYLzjtfP6iY2SUoPibGxGhKLDcGig=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a861c036-d835-4911-29fb-08de4df2de48
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 13:44:24.1728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DEeUtrlRJRJphh3/hh+k3CB4L/74rm7vlbY6RcVpYC+axgpHX07RBen2TF6oljb2RPx8HvxIw1EPYpnMX5A7iW8VVhqfVzwHuG9fIgPGL1w33nOX3mzrCuCLNSR+10SI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4528
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-07_02,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601070105
X-Proofpoint-ORIG-GUID: fohNIgs5UeBjDMcv-wrUXnJ2vRWWRvyY
X-Proofpoint-GUID: fohNIgs5UeBjDMcv-wrUXnJ2vRWWRvyY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDEwNSBTYWx0ZWRfXxw/k2AOi2PJp
 LRPvWGuOayV+8Y8Dotns6GYemOJNiqhPi0tsv38yobpetOE8qYjPw/1gMiR8RjqLl6uKQYfZB1j
 GxUoewKt8N4qbXio+emdxC8ilL268GLYyCE7uutTeDdiBtSVahz6h+VEfP1EWbwU/gVbSoTmqtc
 wdSpbFKMo8Yx8f8T4K8+Uto9WXofLIMO5Rubf1sf/YufprdYWW4AHp6Xb0KVe5Tex5Ig+8OWCzY
 P/vmaeMr9NP1mb/9p5J7Mz8N4AEFjZ9ITwOuzjQyqVg298FC8R3tBiSTo52UWB2typAKI16xwMt
 SDZ57vNRb3rdzeUYktmvug6H7J0niUwa0uj/VXTb5TKs1E1fc5sJtrwjt3iZS//W6lQ/gXMR+1R
 /+quWc72m5gVE3gM/JLFqDGA//liyu7taaNYuR4lPvj4H39Ko60mSPTP7ifqxRYQExYHmMzmWm+
 cJBF+jye306vN9v1S9g==
X-Authority-Analysis: v=2.4 cv=A+9h/qWG c=1 sm=1 tr=0 ts=695e633c cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=-FLzAiOpiDMxdiaLSvsA:9 a=QEXdDO2ut3YA:10

Hi Greg,


On 06/01/26 22:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.64 release.
> There are 567 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Jan 2026 17:03:16 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
