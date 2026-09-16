Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B5D3B6BE4
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 09:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789549293; cv=fail; b=eMllcGbmClc4UdYz94gsSOOsJ1EBptTdX1phyoDiT9xq6+sUwUVVZmYvusqXZ4W6tZa3F31SCR+l5k8yod7yEU/uR+6Lg6MuM+I6i8lr/qZwLUCEagQaGjTkqRZY8tHTDOpSOjnx16M/w4Cm3nrsyf9LX1Sc7jD6eg1aE6XWK1g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789549293; c=relaxed/simple;
	bh=8Dh6v/IV8r9rxSYDkoGKF4BGUkJyZN1iXTZWW1nIZUg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aTmL5HG99wBxgr0Jq7vkryV+2hva3B2vPvqmaWCGgcjnlp+ykLuhJ2ikvFXbLPI3B3LSQKdQKy4HprC3B/W5MTYTgOm+zf84PB2hid/3+f0Esa5IFDonKNoTF5bVAyShC5JwOUtGJJSd/UzKYAUbXibmp5Yt6i9H6+fpSPjXOxc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TlAERePa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fuVAMBW5; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TlAERePa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fuVAMBW5"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLWd45622953;
	Wed, 16 Sep 2026 09:00:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=XsM5Uxrs2Pzj3vE7A+kgGorgW6FpmoQO6Q08F1bVlNg=; b=
	TlAERePaZAdIC/wwTM2RlvSrkfemtPjZJhVOepTOKvKs0eNaOFnhRDSAvL+WUzs4
	oSETTGQSkwcAQujmlrBDdVkv5zLgIISn8gx+aH9bmoIrAwt0Xu6c3DIv9X+jG0G7
	XAcEk+bUtw9A0vWxet0SuwtShEboELHLBJAzeHuva9dY43JXnehrMlgJDmNjbBCA
	NUMZvgB/8rND3/YkqxPMBlOzk6JeNEbQPG4OZubAQGnYe0pY0YRVNrZnJtd7l0R+
	9I0hCec19jUiZiIXG+IgeO+Q2lJi0nUm2TiFObcEPI0wzPy/onOvCAXe68ng43ja
	pcIJLU1I6V1r8U5py0xwzg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmwh1n7wf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 09:00:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68G908fB013869;
	Wed, 16 Sep 2026 09:00:57 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012035.outbound.protection.outlook.com [40.107.200.35])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6b498n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 09:00:56 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SpT8Kth5dHgPC60uoufNMsGn2xpC1W6Vr7+dR5szh9NjFtmD3rX2AVJEv2BB388doOpD5Bom4XI9vEFMi6ZLCyDva+l+iqxiQOltR0le+69E/d/8j0rW9vtjn40X3YQsDugeVCnQab1e2Oswekn2irG+kubclIUvVlzanLCVEVTtr/4kXIxZKPinek0U0ce8ebWVJIDC5LAXYqbImBQiH8OeyxNzfESV3WxQRg3TlDlUa2fczgjiISfjDnsSw6OGJ2EODA+y8Qf8c/Nqpl/pcaBaTk/Ckm+wLbSTzhLh9c1gyFFJqtdssLUpxOTCCRcIGvJDjkq+yId3lQVzuStTpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XsM5Uxrs2Pzj3vE7A+kgGorgW6FpmoQO6Q08F1bVlNg=;
 b=LSpXf/Xr59CUHeLErXHdhyfuHe6mqLbAlRY0u8H/7uY6fmUdCrn5+x1qkMAt7fzzWThX9xyHbMb/Yzdc3tADrx4hhDO87+G+UFfD2HFb99dBhhshy58m6OcSA+h/FO6AiLacWVZGyMSlfhA4aJQKu1lVuIdl8K/+VufBS947rpKlYM733AbjuCymxbBP5CXZbDWZpZGBer3P8jy6dxUiyjj29l8CIrU9wQBh9GTB8DlxaadB44hKwk2xUSc0XgOQA6kdJmD2CPzy8rt9T2ddLHwqwvZF7clAnCDQUNYdXzfpVu03agbXPurbQmRevdCS7ZRyNXBOYpfNLG2UTZjAdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XsM5Uxrs2Pzj3vE7A+kgGorgW6FpmoQO6Q08F1bVlNg=;
 b=fuVAMBW5D/YwMX2oCeLmfMMbUSgqW8g2FCM7YpcCvImFpOTojpscaC9V+pFlKdUW4db/bnjuCLify+CzMHfV+00s1l35qnWgUciDXgOkM0HuFPXVXcA0DqiKu+q+fGEe4PRN7xshWLJBaaaZ/UzCWElfHZAndN96ut0dTnsGqqg=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by SA3PR10MB6998.namprd10.prod.outlook.com (2603:10b6:806:31c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.7; Wed, 16 Sep
 2026 09:00:45 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 09:00:45 +0000
Message-ID: <34a69126-8408-4761-9b38-6ac9041b5b46@oracle.com>
Date: Wed, 16 Sep 2026 14:30:37 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 1374/1376] slab: reset slab->obj_ext when freeing and
 it is OBJEXTS_ALLOC_FAIL
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Hao Ge <gehao@kylinos.cn>,
        Suren Baghdasaryan <surenb@google.com>,
        Harry Yoo <harry.yoo@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065638.156668605@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065638.156668605@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0195.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ab::6) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|SA3PR10MB6998:EE_
X-MS-Office365-Filtering-Correlation-Id: 64292cfc-0d9d-498f-7ce9-08df13d0fe2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|56012099006|5023799004|4143699003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	EAYLjERqCeCOBohlJ2RPD8gZXTS3rfummtWiYC3UIGcnW+8pIv7Isu+L/NnBaKaYzmVz+5VWe68KgasgKhMDsPF0IqZ6a8/4PwhRIaWXA+xAqesnXWtF824ZGPTCdKKwZ1w/cX/gYX3trMlvl790WUUTlB0jCzRsytBYCLZRcbMtecWYMK+RzRzxpcX6WVyPux6W6VSogvX62ICxDY2A5O2LQidev0SXfCL5YDawAiAcDMy/6qtI7bwxaIrculYcMUb3yylXx5NROam/GJ7yg/WcwvsLUD8L+F5LTydkN2Vb64w2nsj3OUt4FZrneUqkZinbXQhUV12KmK3VI9R2zaEKrYTW9uYco/HlmnXDaVE3BJ40WE1mT1ggSDhg35MwS86LEbXxU0pd5QIqo1y9EHWLO8BuUbzO3oQ048P2COLNkHDpsBgjYJnwCLHQl0JqaMb0qoOagD1fdsZxJ/JMXKgIhSSem2AxSepBeMXeqVrSnwwb+w9GwykWZGM4QpBcEOqxysQCtLB+Kp+DLDmH9PovALr++Grx/IxvorwuzMMfa06TascsLn91Ug4VxuZYS7zHxq1BM0uLED7wIUFrpstR8ll7EyucxH2puePjZPKd5pduA5/AYj6lXoy7R3TwHIgfL+19DKzsyjv5OT+ldEhx2auImfiavpUni5NEQ6k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(56012099006)(5023799004)(4143699003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?REptMy8vQTA2NUVMZ1NXWDY0bmRTV3JXdE9aeUx4Y2JnNjVBV1VjdEZud255?=
 =?utf-8?B?RGlWZW5RdzdrNERJN21Ub2lEUWpiZzBIZVlTRXVzT0RCYnhCNHFRREJha1I1?=
 =?utf-8?B?UmpZNXY1ZDR0TE85WlJFWHhSKzZnQ2EySG56UHBnTS9RWC9UREFadUNlbnBP?=
 =?utf-8?B?Q2FGdS96ZlpNS1pJcHYwZTFHVldzZ3UydUIrcGd4eVA5Y29nV0w1dnoycHgr?=
 =?utf-8?B?MmVmUklmQXdDLzFxTGJ0dk43SXVDR0dYdmFLYkxLVGhGS0JMcW9oRGY2dEp5?=
 =?utf-8?B?cHYwOU9HbFVkK1FsRFdPZzdGTEM1OFA5Tm0xQmxrWG9MUEZ6Sks4ZEZGL2Zs?=
 =?utf-8?B?dCtmWW1yK2pzNWFSRU5PTnREQ3VJTjFPcWFwMkx6L20ycnJPOWFyREF6YWtR?=
 =?utf-8?B?OXRnNGYzbStCamxyYjVmd1Y5Y1hkd01VVVlXUytmQW1zZ1hnbldJd1pVVkFX?=
 =?utf-8?B?OFhvalEySjdSRitWN3lpK1oxSXlydnRlR0hDRkdQYW1WUlRqNlQrYnJOMjVX?=
 =?utf-8?B?c3RLek1sYW1lZE9qYUVTSVBmL2MrdE1sY0UvOVRQRUtQVGtaRklLUzFoUFRN?=
 =?utf-8?B?VllGb28vblpWMmxlcEFkQUVtYWpkcFJ4eXFGd1I4UjVKNWJtbzVFTW91Q0ZD?=
 =?utf-8?B?eUUzUWhGZ2VLQXRmMnVpQW9GL2FLS1FwRW1NQ3EwcE5jRzIxU3Zqd2RBQS8v?=
 =?utf-8?B?dU1BYzdldGhTVEhheVhKYTNsR0hleGdzU0oxcENKSVpoMHJZOEtzRnBIMmxz?=
 =?utf-8?B?aWxNNUFyOFQwYlJ4dWlDVU12UWRBOUFBOVcvcTBkbXUxamJTa3JYUzMrcE1S?=
 =?utf-8?B?bmdDUGY4R2lGbDVEcFQ3NUswblI2Z2JvWlV6dkVSQnlMRnBMUmpMbjkrL28r?=
 =?utf-8?B?UHFsZHc5bkFxWUtEN1MrcGR3MlpuelVORkloYmxHckY3S04rS1JCVU9QUFBl?=
 =?utf-8?B?azJlR1dWR0YyK2ZBYWF3ZnJIcGFBWi9KbS9QMHFROUVKMU9wanhsaFp0U2VC?=
 =?utf-8?B?RGhQSTNwT2M5MFhRVlBya1Bjd2dzc0tVWVUrSWxlbkkrNGMwTURzdjk3MHZm?=
 =?utf-8?B?SmlaSGxkV3VhSExmTHMyWG9KT0V6RmhDUGc1d1RnWkROZTl3RTlwZkpjSVNO?=
 =?utf-8?B?Wm9zeHJrVmpqM2NHb2swMDVWRkZINHdIQThhNVZiUlRzNHZGTm1uOG9GZXEy?=
 =?utf-8?B?bzRvdHovMXdLQVZIWDZsTjFRaG9pSDFmMndtaUdBc2VYeE9Ram1ORDJYalow?=
 =?utf-8?B?QUcydksyV2lkK2M2MERaS2U4YnZkTUhVMC95WU1FVURuWlVjSDYzRFBtdGsw?=
 =?utf-8?B?MU5kRmVRQ1dsMkhEdnB3TDhUZk9uRHdtdlBkSDZ4T0FDVmFCcjU1S280TGNS?=
 =?utf-8?B?VzBXY3dLeTJRZU53c0pCM2hsRXB4ZDNIeFRNTFhIbm83bFpPVnRvbDhHUnJ6?=
 =?utf-8?B?RnBpYkVSaXl0bWpSUWozYm1Ic09SSkNmWXV1UFNsV0E2cUJMWGpoSm9wcTdv?=
 =?utf-8?B?cHhHY0FRakdUWVppZVJIV0gwOTFhTHlqc1F1WTk5Vm4yMThOM3FlZmo3cERo?=
 =?utf-8?B?RldEM0dNN3A4SXNoNG5LUXp0OEEzZitxdXpjN09ldGtSYWNQcUI0WmxpOElw?=
 =?utf-8?B?Rjhhbld5M1Bxelk1N0EwUjhySzJpMEhTQno3MXJDR2ljQ2hWVzMwTlZKbk90?=
 =?utf-8?B?MUVITGJPbDU4eGxjaEZ2VDhkaUpCK0o0TTB6WUMxeWp2Sk9aeXBCb21wMEp0?=
 =?utf-8?B?S1FuQ0M0MmI2RXFjdCtXclN6VkxLeTdqWEF3WEZMYS90d1BRQ0w5aThCVERB?=
 =?utf-8?B?ZitwOHdRVEpLMWFDWGE4NVZlSWtFYTNCTEZqQ3ExRFZUa0NodGRmcjlIZkEy?=
 =?utf-8?B?bmtUbmRBSDhPZTBBOURpNk43ckhmTWlqR2hhQ3o5ZU5KNkNScTVPL1RWa0Z5?=
 =?utf-8?B?b1lFSDl1UmN4T2VXZ2E3SHpXWmN0NThRYTVkQllET1JhWjQzMWMySE5Md1Y5?=
 =?utf-8?B?M2ozb1hPRnhmbGtkcks1RWQwbWpzb2VVWER5eHl5YXA1VGtQSktkRkJmV1Iv?=
 =?utf-8?B?R0ZqanVpSS93RGZ1WUFKS24wcFN6RHBLK05Hc3hmTlFLblFJNTBCNDNFU1g4?=
 =?utf-8?B?blJOWS93NnBxTi9lK3luOTd4aWpXbGpxWUFXSlNHS0lCNVpOL1RzUEdoUk9l?=
 =?utf-8?B?b1B5Y0Z4YXA5VzNSMkI5WkM5U2lqY1l3K2xtYjBMMlkrZG5jS2lOWW0vekFz?=
 =?utf-8?B?Z1NZL0p0Z1lETEJUTmRHaWo3aHgzOHZraTcwREpPY2I3Q0dJVkN5Q28vYkFa?=
 =?utf-8?B?eHlNT3VNNlZSMVk1M2hXNEhEYUp4NlA3MjdldW11R2RxWmhvNnc3TEZKSVor?=
 =?utf-8?Q?Y74rwJa4a3DTl9Sp1Z/CxXN0T7wXoj77hwMjS?=
X-Exchange-RoutingPolicyChecked:
	OUTqWVLBFXM13KLjWhhw5hAAEAUhxXkyDlE68OZ9nmYVsygHtlNxLhLOyghEVPSimDRy81wLeow/yAqQ0mM7yGpGCPWNBAdSEImPyVOUEooX6MOLfBl1W0yCbuHu7CfLwPZmEqppek/WKun3dgvm2BTCW4BQKILjCzZCa3FkyU0FVVWmtgQhlvcOW5WJfuA+88Iiu4+mlBlfIy6NbWZw64xNLEKUNQdifVrcaJUzSAgfjNX92cTkLLL4mMWCzngVZfDQjSVJewFux11NSDDVjNXzvSMNZf6TAZt+v4aPcVrrceBPVf60R2BRGDTwFNgv9NVLWAMg0bIm0gIYeh2GZw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Sfg9ZUl//z+oMUHtrKS+ascTDSST/6iTKGoWoOi2qJFYrfRWexOkJ0LGhtFEeVHPs+QDMEZrWDMgSnQ4tVhbyhzq2SaPdhRPmF1Ir0WhwL+15cWq1ksfqD68VckmN0Cudiiwsqpemj/43Uqqs7psOn101J9pSdZpdIwCeD7dAv3jvlWNoJvcjActAILOKfFYcoQWy9ywxpq5XHrL+88NWGNq+GjVS1pkqPNn5VM9DTvjGwQqOk1CXKgZBkX60UOafX7IsmVo3whzc2bkhFuXgG+NcD+MA4LTh1LZQcel5QkA429fSdt3fnb+WDu5Q8Q6ACHV9NrgLDRvdZMF5v7+BIpTVNxFwK62jLfuzfnSdq/1rOVK9SCy6fIkV5hiw8eTw5AZUwm34S+BSOKkQWHqQmuuDnSVQZ8mszzN6QWOTJkzlr6Tpjmwou7wD8lk78u7dDGUf+UPrD2dsWXvgJkTjzLUGMStM/FsELwzSUEzgs1vzrUHEC8N4U9WOmSCF6AXnYTUzeqeDT0PnASX5LNEbVEVOetwoj2VDuKyNnWk1Ch0BBdZ56iiZgEuhDNkd7PdjMWk7PDeK0JnV51yuFJjnE4WJPXxdQEoNHqDdwtGBfM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64292cfc-0d9d-498f-7ce9-08df13d0fe2d
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 09:00:45.2961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uch9p1UMR2dr3p76y0eSHbGOgeRdrTq/OSG8oO2S+18syskW/1DvKMR5eKcSBQrEY71KHMx9MiPCLZCh03IryjcksRzOiTY3XArk3vEDzB7/YT5NQJmh4H5E9YYv/jz1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB6998
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2609160116
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDExNSBTYWx0ZWRfX01cVCevbFxSR
 daJpTTkwQ/0YZPzOI2HugkWepC+SkE+3gNzbAaUb/GTtnqymkYeeNtcm5rIkOnlNcGVlsgh4Ai+
 GRc3u1fyP5WrZoPBdgQTWJ350y0owUgkYjtR3tBNjLzEXHAGAsx6lpCjPegGb8dBFxqkSiKtCPc
 o7/i+q3ert8dcZv2WBzBsNNV0NsuaA0ZCYk7d/xfZhFFC4fbv9v8zQBHrNe3Qwo1LfI2HL8PEtP
 7OVjVcMT7NzHUuLMjy7ss7W9igkdDZo7KUsk370c6NCQOWfSvddQQASVKM+xD7qODCbz7ocjoB+
 54tdCKAoUYb000MFQNjj7hNOheFhpJ1969EqVba8I0fg+XbrMLsO7H3AL1GVxygfjMIdHzOJp0J
 jJVAMSGvCH7UMd2YnUr4xQh1THx3Z/MSo/FvTgsxTicK4HYj3L+RbA9CnLnROqRGV7WA9OEOWdX
 LQsQ3rVt50gNc3EGuXA==
X-Proofpoint-ORIG-GUID: unErC33v_NCAlEexPsYoca8vDCwFFUGf
X-Proofpoint-GUID: unErC33v_NCAlEexPsYoca8vDCwFFUGf
X-Authority-Analysis: v=2.4 cv=HPhWhYtv c=1 sm=1 tr=0 ts=6aaa5aca cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=ag1SF4gXAAAA:8 a=d7NRWt85ZsWhMf6-aKsA:9
 a=QEXdDO2ut3YA:10 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDExNSBTYWx0ZWRfX9ksz+IW53zEW
 MPBo84l/Vt6QZJ+5c1Vy5fxK37bBsQ01OJ7m7O+A0T/pESRxVbSG7EA75ZPKpKe7odRiMAgImQV
 xKi6C/2AK+DRrNfG/IGso1YKMVRQUrgRbMR64vdqQS3SqLtVUa5/

Hi Greg/Sasha,

On 12/09/26 12:33 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Hao Ge <gehao@kylinos.cn>
> 
> commit 86f54f9b6c17d6567c69e3a6fed52fdf5d7dbe93 upstream.
> 
> If obj_exts allocation failed, slab->obj_exts is set to OBJEXTS_ALLOC_FAIL,
> But we do not clear it when freeing the slab. Since OBJEXTS_ALLOC_FAIL and
> MEMCG_DATA_OBJEXTS currently share the same bit position, during the
> release of the associated folio, a VM_BUG_ON_FOLIO() check in
> folio_memcg_kmem() is triggered because the OBJEXTS_ALLOC_FAIL flag was
> not cleared, causing it to be interpreted as a kmem folio (non-slab)
> with MEMCG_OBJEXTS_DATA flag set, which is invalid because
> MEMCG_OBJEXTS_DATA is supposed to be set only on slabs.
> 
> Another problem that predates sharing the OBJEXTS_ALLOC_FAIL and
> MEMCG_DATA_OBJEXTS bits is that on configurations with
> is_check_pages_enabled(), the non-cleared bit in page->memcg_data will
> trigger a free_page_is_bad() failure "page still charged to cgroup"
> 
> When freeing a slab, we clear slab->obj_exts if the obj_ext array has
> been successfully allocated. So let's clear it also when the allocation
> has failed.
> 
> Fixes: 09c46563ff6d ("codetag: debug: introduce OBJEXTS_ALLOC_FAIL to mark failed slab_ext allocations")
> Fixes: 7612833192d5 ("slab: Reuse first bit for OBJEXTS_ALLOC_FAIL")
> Link: https://lore.kernel.org/all/20251015141642.700170-1-hao.ge@linux.dev/
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Hao Ge <gehao@kylinos.cn>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   mm/slub.c |    9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2161,8 +2161,15 @@ alloc_tagging_slab_free_hook(struct kmem
>   		return;
>   
>   	obj_exts = slab_obj_exts(slab);
> -	if (!obj_exts)
> +	if (!obj_exts) {
> +		/*
> +		 * If obj_exts allocation failed, slab->obj_exts is set to
> +		 * OBJEXTS_ALLOC_FAIL. In this case, we end up here and should
> +		 * clear the flag.
> +		 */
> +		slab->obj_exts = 0;
>   		return;


Hi Greg/Sasha,

I ran an AI-assisted backport review, and I have verified the report. It
looks valid to me.

Upstream canonical teardown code:

     obj_exts = slab_obj_exts(slab);
     if (!obj_exts) {
             slab->obj_exts = 0;
             return;
     }

Downstream reviewed ordinary-free hook:

     obj_exts = slab_obj_exts(slab);
     if (!obj_exts) {
             slab->obj_exts = 0;
             return;
     }

The text is similar, but downstream placed it in the wrong lifecycle
function: alloc_tagging_slab_free_hook(), not free_slab_obj_exts().

The canonical change clears OBJEXTS_ALLOC_FAIL in free_slab_obj_exts()
when the slab is retired. That exact fix is already present in 6.12 as
4772e7f18ac2. The reviewed patch instead clears the marker from the
ordinary object-free hook while other objects in the slab can remain
live.

That premature transition prevents a later successful extension
allocation from marking old slots CODETAG_EMPTY and can produce false
allocation-tag warnings. I suggest reverting this.

The backport is already present in 5.15.y as:

   mainline        : v6.18-rc2         - 86f54f9b6c17 slab: reset 
slab->obj_ext when freeing and it is OBJEXTS_ALLOC_FAIL
   stable-6.12     : v6.12.55          - 4772e7f18ac2 slab: reset 
slab->obj_ext when freeing and it is OBJEXTS_ALLOC_FAIL
   stable-6.17     : v6.17.5           - 8f4c0c2fa3e3 slab: reset 
slab->obj_ext when freeing and it is OBJEXTS_ALLOC_FAIL

thanks,
Harshit




> +	}
>   
>   	for (i = 0; i < objects; i++) {
>   		unsigned int off = obj_to_index(s, slab, p[i]);
> 
> 
> 

