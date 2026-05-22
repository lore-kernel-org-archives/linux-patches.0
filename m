Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164E63BC68E;
	Fri, 22 May 2026 10:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779445610; cv=fail; b=YF6M3ZMlVzl/MBruavrvm8Wmz6sgxa0yKihj41Tpqvt8oZZdxwU/KUCO3z/hrBC4u7PhPm71xktfdxXphF5mC+Da7lkbTFpp4o4rDHTBqBagdTSeYLepVIAQUD05Sx+SGlOWJgPWVTm8qtOKcujg7jA7nvZpy9EENa50z+Hys8Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779445610; c=relaxed/simple;
	bh=N1a/96T31rFr/5ttGti19lXjhoAHlntRaoq2ipaEOhk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pigoI4+STWmFM7aNevFv4BRzoCxVRQLoncFzymv3nitWi61hdzKnY8Pm65j/Q8oa/PejUOJE1IMxEP9GVN8T8aUK0AcARKNSnz3178/ZwlJ9N0zBNoUZbKoUaRnCvTqrk+/WcTzIpEbdyPfG0Ay6z+f0H/Hi1eWtsmAfAObPhlw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GFvHP3rO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RM9z9q5u; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GFvHP3rO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RM9z9q5u"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64LJkRHC1808544;
	Fri, 22 May 2026 10:26:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=OlkBo73RfuivLK94CsmaZiYaR6N/LhR55LxY1kS4AhM=; b=
	GFvHP3rOrVTHkuvE8WyKxPs0ber6MnZm1PPeMC2Kgegxnc3RFEyvRX2rqoM3YaHQ
	zs131vIaI1+CRx9PZTVzCCfT/GcBLsxMaXEPmCE0POTPBqlhfXMwuwYg+qcJEAUv
	0fr6LlKzjfOM0Kk5ZlTuckZEXeyxQNIdiNo83qI4TKWYM5Qde7muRRY3rbIi40ij
	BGxnFiGsnr6bTysNfHL13kfiJjtjXEWlb7ziYAZoi0q52eH+GZ5V5rXMkykFyEEx
	rXc/oEr5Hvm7CPmIHhPOZNQ/PmU9icXfsGgScPnJg26dBayRL0ch13HfCyae4Xk9
	ivXqzmCTUmJTHbk21vLcBg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e6h1t2ww6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 May 2026 10:26:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64MAOq0O016180;
	Fri, 22 May 2026 10:26:33 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012048.outbound.protection.outlook.com [52.101.53.48])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4e6f1es68k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 May 2026 10:26:33 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AEHyUr3OfsNtyr0s0EIii2xrpG+kfRPoFfuAnk5QZmzNlUHUcOtcRj8ey4XpU/23N84WaV90KO+q8vqsvCAVR/Hvw+sjMQWwTJN5z5355aKIedSQjSkkf5coByWae/HiNmfpjTJOgrcZS98Tf12EgQC6pkQ0cBLVx8pAD3BNdleP0Ky379DQGBpovg03GNya81tLjj3y7RGfVwg18TafklpUHr7E9WxaDeTler+yFfc7ykNX+bzzm3MT9magpeBqv39njz8Vn0Mwnosgw+8YcFHvLV0FDiiNKT1V0cL/Z9NZzqAAPOtKTP9blbjyfWvvSV0k/Uv5Kdo1D0bnsTw7MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OlkBo73RfuivLK94CsmaZiYaR6N/LhR55LxY1kS4AhM=;
 b=i5kKzH/6XWcp8CWvvlDoNgmhxDztx+9FeLyCIgfEs1zYbuRuabwF6+/AIwNSsOTE9XLEighSoH5i7oDOCvzUVqSqBxlIRrPvWCjMzxEG4GIAHHv/oMPwmqAOg+34hqgCzUgB1v2rzaVd/wgiR1dtJfhLBv5tWqUGQEjMyXCZuMJo+lW9unajpekhOn97lU+ciBTNpxSNLe9jUHCsHcsK0CnbOJDnJDPIcj5dvA/06RSvUvumhDf+6GwtYsfC3yEp6Eoq53ZQnBE777zsR5EDHE8N1qcG0HsbP7pQ3X5Kbp12vUE6bHdTcShLvWd4N5eiMsdCz5mB9NgaREUdh3ZlRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OlkBo73RfuivLK94CsmaZiYaR6N/LhR55LxY1kS4AhM=;
 b=RM9z9q5uzF88HgQleFKukzV/mMxlWCXP5cIfyrxpqqlq3EkZgsoTmc5R903inls1Vd8I9jWAKpf+ws/E94zwUAG4h/fTe8GjhEVZ1Ek6++wzN+beHOIBaWRRC2K2AnP6ztTaq+oPJD9u3mjywaZSzMzGp4k6+eUizUt0ae8D8Rk=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by BLAPR10MB4851.namprd10.prod.outlook.com (2603:10b6:208:332::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Fri, 22 May
 2026 10:26:30 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0048.016; Fri, 22 May 2026
 10:26:29 +0000
Message-ID: <a6d725bd-9ed4-4328-b2ba-078f658fd8b2@oracle.com>
Date: Fri, 22 May 2026 15:56:21 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 384/666] i3c: master: Fix error codes at send_ccc_cmd
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Dan Carpenter <dan.carpenter@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jorge Marques <jorge.marques@analog.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
References: <20260520162111.222830634@linuxfoundation.org>
 <20260520162119.576627180@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260520162119.576627180@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXPR01CA0084.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::24) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|BLAPR10MB4851:EE_
X-MS-Office365-Filtering-Correlation-Id: e742ba54-b5f8-4538-7dfe-08deb7ec95f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|56012099003|18002099003|22082099003|4143699003|5023799004;
X-Microsoft-Antispam-Message-Info:
	W5FQ7/1nwvu1K27h1Jg1/bqEhNL2k+5gLk/sxf448oARJZmSvMffg86Q0pnq9Vd+kutrxE85jqBQ1fnhnDfztHVDYOdxSNmdCdZkveq8Q9virG94HSdR1lDQOjZvQGBSEUM0Fbq4xoliql2QWME5fSJUPuM4OKxFs/jDUlUbc1zna1nvBo2iEKDQ8fFPnrjutaKVxrsJn8qJSbMW2ekvfJs9Bm22DvpPWOqTTHoARPcF1Rov+iQxONRL5USaEUVBlEJXQoV8Dh62Pzu1ShZqmsWqZnoMFXb5tTCr3W8r/eowjAlwa/KE8ZUAFZXHLJMBA5BIlHwiJfiTt0f+LeAnMQIa3OHOOEwIOZo7HudM1N8Y0QEk/lDkZ9bklO1iEvbM4EJP4WN/aSDqmQOzzbV7xttlK2Gh9fPhRC3WMitOgMSH1i5oWLhOPrQ19MDEbSh/EeoKFp4gaFbr0B/l1rVYXpYMGEbUVjGbcct3G1qt60VstnSrwj+UDaB3HdhVRtNIu1xaDPd7XJ1DogNelIuD5i2Pand+Br8NLu/wAyTgIn5Sj0xMWjVIgFf/BhFsNCXRifCrTBl5lizG2Bt4dMwOlbosmrQtjB2noTLH5M5dHc4kqh6eLUPWyMyhFIkA3FvOF6WTC6gWqLWgKJvvo1/08A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(56012099003)(18002099003)(22082099003)(4143699003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NksxYWYzUmdpNC9EYldWQ1hnTXAwY2ZyWllzTTVLaFdiSlUxNXk4N2hBbzdI?=
 =?utf-8?B?aktMam53ak1HODViYmk2OWJaZ0RUZHg4MUhvUzlYbWRFOG1CaFpOMkZHZDlU?=
 =?utf-8?B?SlhQMXk0bUV5ZnptbGsvZlZiWVo3RnRMTmdSN203amFXNUVlZnlmUW1yRzdU?=
 =?utf-8?B?N0d2TTR1eHZ2K29EczRuTTFlcjlJNGpxTlFqYk9hN2VCTTlBTmJkSVN6L2E0?=
 =?utf-8?B?Y2VuQzBRdmttSzBHRWIvZFg3SVNDWjRJUFVMTUxlckdwQ3BZL1BxSXdkb3p6?=
 =?utf-8?B?dTFodFJaZFBQUk5ycklpdW5wZzl1V1FzVTZFZUhsbVlSdTdkWmlMSTAvQk5C?=
 =?utf-8?B?eTB2SEFjN3dXV0ViR0pvT3dMdVAyZkxrbFdSZUpZU2hoK0t4WmVqN28yK0NF?=
 =?utf-8?B?UXJ4ODNWTlB5bkR0dHFTbzVaTU1LRU1jQkdxakRrYjFFcWwxVkhWN3VTR1Bs?=
 =?utf-8?B?SURMaGxCSkNmLzNuMmFVeEQ0OEhWYUdOUDE1S01wRnc0NTdQVWR1RTNBRHBK?=
 =?utf-8?B?Ty91cUFsNWo2NXlmSzJlNGM4RnRDelk3RkZxRkNlckp6T0MycEpnd1JvcnJp?=
 =?utf-8?B?M3UwZTFkY21VVHVKb2ZZWmkwVFdKVTdtQmY0RDhtYzJmeFhKb3pxUUdSc1BH?=
 =?utf-8?B?RG9OUS80N2xkWThMV20rZkNPRkp4WUszM2xYcWg2Q0xBV1Fjb1V5Z1ZsdFpr?=
 =?utf-8?B?YzVEcmZST3JWSS9lR0IramQ0OENmRGZDWkllM2dwTG9zWE1YcVFwWnRmRVRS?=
 =?utf-8?B?Q1pzR2xnS1BoRHJaaGNDcjF3TnFheG9KbEszOEQzWDQrVVBYMll2YnZYRHdu?=
 =?utf-8?B?dkVkMXZLSm8yV3J6azQ5bXFlTklxaXRQRzU4eWZRYk02cnhaTHBUQ042b3FO?=
 =?utf-8?B?aGFQTXNvQ1Vmd1MzVkV6Tkk4bTUwcC8xb2cxcGhqaFpaK1EwTFcyd2plTEsv?=
 =?utf-8?B?U1lUT0hlQW9FWDAwR2trckJ0V0pWSXE5M1MrdDF1OW1Ja2wyenQxc3AxOS9O?=
 =?utf-8?B?T1FDdHdLNkFGOGdFQmxmUjMxOUpRdnF1WFZOYVc4SUJQY3gvQ1lJQU1SS2Mz?=
 =?utf-8?B?eDlaVXFlR1lwQ0R6eHFXMWROWFBTaDc5S21yZ1VDQ1FqZW1uN05KN3ZtY1ZE?=
 =?utf-8?B?d0FPelc4R1lNc0VpUmJjRmluckJuK1hDZkxCWlJ6UE13ZVBtQWMyTGNXbmZI?=
 =?utf-8?B?MkMxQWZ5RzlWSGRtSE1rTjE1anVqR2pCMEhUTjRHbVBJeW0raFpNc0I3aitY?=
 =?utf-8?B?MjNyblVtWldUTmcwRmRwK1pyOUthVzUrekppYWY2aVl2dzBSc0tJcnBLVWkw?=
 =?utf-8?B?R2dFemh0T2JqRWxlV2V4bGkzUEs1NXliRmpWNEJwSnJmR1VIeWdVMGF2RHhj?=
 =?utf-8?B?UXdiVzI2NzVLdEpiZi9TbkdVajVvWVNyR2NoTGpsYnI2eXhKUFlhSENZWXlL?=
 =?utf-8?B?VUFnUDFhTDU5N05zWmJqM2F6aitlQ05GWjVnZXBJVnhObStMWTJHWkhWL01j?=
 =?utf-8?B?MitTUDlOYTFrbUZpQmZwSyszNTgyek1rVklKNVZlSTY0b1hvM1hVNTJMcVBi?=
 =?utf-8?B?NlhwcGpsZGhWakszdnFRTW9za1NrVnplTHdlRFk3QzNnT0tMWktmK1lCTEM3?=
 =?utf-8?B?czBIYTdHT1o4UVFFMDc5Y1VGalQwN3ViWktURjZTUzZVSU45WHNPQWxFbDJV?=
 =?utf-8?B?azFXTHliOGRGK08yaXpNcHlvUUhQVU91UGZiTnNnd2lrTFdkeVBGTXhmLzhj?=
 =?utf-8?B?ZmVERG5nN0FIdzd0L1VpZVFPYjdsVWdIM2xrelJGYlFjM1grRHdWdWxQWUVt?=
 =?utf-8?B?VWtmRWhkSlhPcmJ4L3ZkWW9IWm9XMzN0UGJQTXZuZDZmNzduV0hXMlB4ZllN?=
 =?utf-8?B?VGc0MkhqWTdNT3I5L0xCM1hHZllyNU1Ld01xR1p2cDlqMGw5T1c4WnVqeTdJ?=
 =?utf-8?B?NVlrZGF5Z3FhcmxDNCtWbnRBVHBPZytjVEV4U09jU0N3SGgzY3VwbVpHOG1Z?=
 =?utf-8?B?MVJEV29ZcGhMbFRFZkdoZU1PVFMyc2tMWlJ1a2loZkxCbUhKSnJHQmpqQlhy?=
 =?utf-8?B?MjRoWnN3TjQyZUZlcytzVTVhU08yR0xLUEJLRHlhN3dKRDIwYy9oVC80U0d3?=
 =?utf-8?B?ZkVSWHZtQmVjdGhaUFBvRGVOc2VCQ3grcE9Uc3lPSnFXOHFvL2NyTDNkeUNi?=
 =?utf-8?B?Lzl5RVpER2tlMFZzWHh4citUQWFzSXIzY2VzTEJqU0ZwcHMvbEJzT3pxa1dB?=
 =?utf-8?B?Rzd2dGhjZ0RvL25wc0FudG4wNmZ5SjJLZkNBZ2QyNDZKSWdzZTBzTXZPejhE?=
 =?utf-8?B?SUcva1BiNEdSSHpFdnhONHE4Qi9oeHJQVkFodVVzd1BZc1lMdm9UZkdSRlBK?=
 =?utf-8?Q?Z3L/270xJ7+XCcmwtXOCRRtjddJWecRngbLS6?=
X-Exchange-RoutingPolicyChecked:
	YW5LWMuDX2vr+OvPk2JuDrQn3j+88oWKDc+w2jzMfj/Qpmna1kz1Q8T1YMABHqN2rb/O4Pk/HzK+erSCMn7dCiurLdacG/Qwl30BnQF1NSgd1m5YP6jZRBGDIG0KSYUB1XGkQFragy5js9vbd8lrLn3VxYACJ4iE8lYxtefW+q49GClxLdkTfTgptewqpfi7m9X0uoyre2CuQ2KhR9AS8YpSBR8jozXgKQouPpEpOxX3/sDEHh49FhwzV11N5M5W/hxTcmQuKOqzivg5+fgcwRktR6DfD4NKkrskT4yS031Xzat/fcP9phcZel14J9tGL/nNInu2kzqutkO4ozKBEQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zkDEFObIxmbxmBNyn/0HboA1Et5GnW/k1+7KLpNLC/yjCAQhWab6cwRExYe7L70h2mWmYZdNyK0lhQgjBO5f6EdxHrRe2hcHP+2uDyjQGN9KERNbfU1vFmBR/qUdYu4fATuhAwtKRbtziNaJz2hbSlUHM3lDYkuHPe6BiZSFs6cRZc+Z9EDH0XCpIpwz1T7buL1g5UDvVlEYFJPYeacHMDkdSp0Sv25Gq1FLUHvLvdka8xXr3nYDuc31N/IPFnoirGLX6FEWIPlhE1NMFHeOuViE02ZjdUKzlqd/HkrDqznKjKp3ZVqV56cbXsD7DjBMTbqcSZIhO83RTdDDRQmrwJp+nnrb9Kz+CCZEGfVrP3VuglLf9nkkcrr/xwGskpui8or2VeRS2yViAJAQR7qx6MveUHl6aCvnbvE24J+gS9/QFCYYbnAytmyIoKsk0d7rGGx+9et4Cc+B6R6DWPNSOQbBagMc1LNgjtaj9rKoPK4ZsFEAwBBN46oHim4Y39sBDeIoGeG1ggM6803Gpa+x+b+mcF4mwFQUUDFjFLe8z7HZuDE6cCzFCRpJIotCT1pMza3PIlhecDGvp4U+3/9oLEh4INM8ZcLy3qpISq8eyio=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e742ba54-b5f8-4538-7dfe-08deb7ec95f8
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2026 10:26:29.0461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U9rFa0S9r170tEH5F+7AXM1SiqeMG5Lfacf3whwQMR8O93lOFUIzo56NtUcdCQ5rvfJdUY6m/yApW7jN0HL50LhfO54qBAX1pIuAmIFlQKiAPPIFzsci++TM3VVtoquS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4851
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-22_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2605220104
X-Proofpoint-GUID: -QRTkkJiadxXr3uX6TaEPlLZNa9C5D1p
X-Authority-Analysis: v=2.4 cv=d9jFDxjE c=1 sm=1 tr=0 ts=6a102f5a cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=bC-a23v3AAAA:8 a=gAnH3GRIAAAA:8 a=KKAkSRfTAAAA:8 a=QyXUC8HyAAAA:8
 a=P-IC7800AAAA:8 a=9vk2M0PSzc6pA2ZksqgA:9 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22 a=cvBusfyB2V15izCimMoJ:22 a=d3PnA9EDa4IxuAV0gXij:22
X-Proofpoint-ORIG-GUID: -QRTkkJiadxXr3uX6TaEPlLZNa9C5D1p
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDEwMiBTYWx0ZWRfX0CxcVrhuhNX6
 PNzRSS34LDWh6r1HDQSG/+V1qLGUAFRAyV1DsHefRudqCJl+Rwr6IInzXlUxBL9FHZJZfTNvNgj
 XckQ10jLS0edScqrQpco/ckJ2DfD+FDmuLji6L0YavUKsxytYXSzhKUGxTqJK4UEkik9fB5CeBY
 DLv7rlB1GW0Jluuj1MOYJ1uepO7rOj5HvudiUMXTVlAU/vXtbwSnYl2eRnhxvPknMRl61mJGYEg
 EbLx5eSajzqzh3/Mmpl4JhLkt0PHuRinw64qRleprp4Z2Oej5q6GSsTPStWs7b3GxcfT3IDEAcT
 Rp/j3Sso3zqUkPGNJV/gzvlTyXFh8ZKbxbH8hjZ8DeZQnrxOc7ih1rbDtkWBgauVDdzBmhVgclG
 fGlAnuf+2GCw3Dd45ktlY2iaMKr77pS/OGP988j4lNLDxOrkzzW5TktyrHZbOlJtoq1QJMI79+a
 yFm2pEDeS+RU8FjqnJA==

Hi Greg/Sasha,

On 20/05/26 21:49, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Jorge Marques <jorge.marques@analog.com>
> 
> [ Upstream commit ef8b5229348f0719aca557c4ca5530630ae4d134 ]
> 
> i3c_master_send_ccc_cmd_locked() would propagate cmd->err (positive,
> Mx codes) to the ret variable, cascading down multiple methods until
> reaching methods that explicitly stated they would return 0 on success
> or negative error code. For example, the call chain:
> 
>    i3c_device_enable_ibi <- i3c_dev_enable_ibi_locked <-
>    master->ops.enable_ibi <- i3c_master_enec_locked <-
>    i3c_master_enec_disec_locked <- i3c_master_send_ccc_cmd_locked
> 
> Fix this by returning the ret value, callers can still read the cmd->err
> value if ret is negative.
> 
> All corner cases where the Mx codes do need to be handled individually,
> are resolved in previous commits. Those corner cases are all scenarios
> when I3C_ERROR_M2 is expected and acceptable.
> The prerequisite patches for the fix are:
> 
>    i3c: master: Move rstdaa error suppression
>    i3c: master: Move entdaa error suppression
>    i3c: master: Move bus_init error suppression
> 

I have run an AI assisted backport review and it spotted an issue: I
have taken a look and the issues goes like:

The above mentioned prerequisites are not present in 6.12.91, so I think 
it is incorrect to backport this to 6.12.91.

Thanks,
Harshit


> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/linux-iio/aYXvT5FW0hXQwhm_@stanley.mountain/
> Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
> Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Jorge Marques <jorge.marques@analog.com>
> Link: https://patch.msgid.link/20260323-ad4062-positive-error-fix-v3-4-30bdc68004be@analog.com
> Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/i3c/master.c | 32 +++++++++++++-------------------
>   1 file changed, 13 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
> index fe6f956cc3111..8e2bff031aac9 100644
> --- a/drivers/i3c/master.c
> +++ b/drivers/i3c/master.c
> @@ -825,11 +825,17 @@ static void i3c_ccc_cmd_init(struct i3c_ccc_cmd *cmd, bool rnw, u8 id,
>   	cmd->err = I3C_ERROR_UNKNOWN;
>   }
>   
> +/**
> + * i3c_master_send_ccc_cmd_locked() - send a CCC (Common Command Codes)
> + * @master: master used to send frames on the bus
> + * @cmd: command to send
> + *
> + * Return: 0 in case of success, or a negative error code otherwise.
> + *         I3C Mx error codes are stored in cmd->err.
> + */
>   static int i3c_master_send_ccc_cmd_locked(struct i3c_master_controller *master,
>   					  struct i3c_ccc_cmd *cmd)
>   {
> -	int ret;
> -
>   	if (!cmd || !master)
>   		return -EINVAL;
>   
> @@ -847,15 +853,7 @@ static int i3c_master_send_ccc_cmd_locked(struct i3c_master_controller *master,
>   	    !master->ops->supports_ccc_cmd(master, cmd))
>   		return -ENOTSUPP;
>   
> -	ret = master->ops->send_ccc_cmd(master, cmd);
> -	if (ret) {
> -		if (cmd->err != I3C_ERROR_UNKNOWN)
> -			return cmd->err;
> -
> -		return ret;
> -	}
> -
> -	return 0;
> +	return master->ops->send_ccc_cmd(master, cmd);
>   }
>   
>   static struct i2c_dev_desc *
> @@ -959,8 +957,7 @@ static int i3c_master_rstdaa_locked(struct i3c_master_controller *master,
>    *
>    * This function must be called with the bus lock held in write mode.
>    *
> - * Return: 0 in case of success, a positive I3C error code if the error is
> - * one of the official Mx error codes, and a negative error code otherwise.
> + * Return: 0 in case of success, or a negative error code otherwise.
>    */
>   int i3c_master_entdaa_locked(struct i3c_master_controller *master)
>   {
> @@ -1012,8 +1009,7 @@ static int i3c_master_enec_disec_locked(struct i3c_master_controller *master,
>    *
>    * This function must be called with the bus lock held in write mode.
>    *
> - * Return: 0 in case of success, a positive I3C error code if the error is
> - * one of the official Mx error codes, and a negative error code otherwise.
> + * Return: 0 in case of success, or a negative error code otherwise.
>    */
>   int i3c_master_disec_locked(struct i3c_master_controller *master, u8 addr,
>   			    u8 evts)
> @@ -1033,8 +1029,7 @@ EXPORT_SYMBOL_GPL(i3c_master_disec_locked);
>    *
>    * This function must be called with the bus lock held in write mode.
>    *
> - * Return: 0 in case of success, a positive I3C error code if the error is
> - * one of the official Mx error codes, and a negative error code otherwise.
> + * Return: 0 in case of success, or a negative error code otherwise.
>    */
>   int i3c_master_enec_locked(struct i3c_master_controller *master, u8 addr,
>   			   u8 evts)
> @@ -1059,8 +1054,7 @@ EXPORT_SYMBOL_GPL(i3c_master_enec_locked);
>    *
>    * This function must be called with the bus lock held in write mode.
>    *
> - * Return: 0 in case of success, a positive I3C error code if the error is
> - * one of the official Mx error codes, and a negative error code otherwise.
> + * Return: 0 in case of success, or a negative error code otherwise.
>    */
>   int i3c_master_defslvs_locked(struct i3c_master_controller *master)
>   {

