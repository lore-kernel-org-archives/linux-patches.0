Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8B21F4706
	for <patches@lists.linux.dev>; Thu, 20 Feb 2025 12:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740053691; cv=fail; b=EObexQL0AYAe/uxtufBQifdryPMU0qERimgGT0pdnbtpISoAiVHzIqYf/OfB0CFRXFsqqteAdqK+S8avpnjN2XbjEjW1YNBi1co/uCfhvZiofkY75P7zNc4k9LJubsIAeFIy8qjtAbPrB43ee7Rp2XPQuFSZVlgjb3tuRFCe8jc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740053691; c=relaxed/simple;
	bh=pB5oQrZhRa0jiBZ0dJ1uV9zwt/ozcCwn8/D8aHRwIjA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nXAmyqAwuNB5TBt6IsiE9mSTd3gNLlBP2IUUARMGjKyUFZpkxrIRbb72AQSO5XCtfZhNUM3sU2D5TNWH0WT9zoQxTCikhMMBCFW8FW+BW7iK4zhD96NhINtBMcKExqIvRgZfkNwOa6njKWvezPmTHo5LNr2/DCKw4cfU2UwiO68=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kthJ4v2i; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nT+rTOfa; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kthJ4v2i";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nT+rTOfa"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51K9fgs2003564;
	Thu, 20 Feb 2025 12:14:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=grjQu3RGXK3DNULAq1RVc2II1fGcRI2EBudWfY9I2+0=; b=
	kthJ4v2i7uXILyFhP1L2bgh3uxQUbE1dUfksy40n4Cux38z04I7zVWa6U/Y4svrs
	QblAf96stwyfI+MSzyU4Gx33VEByxdHPN1muiWzRExbMFtTX5eJA1LGF8DeOgkA+
	qzaPX4OZtqDXgD8vVw2zrpIFZBjqv1U0KcSGt4xx/tT2OfU5lYOu6G+lmfy/WLIO
	BH7ByIrP9I2w2HoKn0B3WPxQO/QGIOYDLLUMbUVg0AoeMu6n1xpl+LlKKuAuDOxv
	1qKS81bMZY+Tu4Umi5vTsfr5luMeIPse5bt9IuyFEbUE4X7td0QizMZpgvCg4IJT
	fxBAfQX9rQQTC9e/0Rou+w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00puxgw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Feb 2025 12:14:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51KBJ53W010510;
	Thu, 20 Feb 2025 12:14:33 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2174.outbound.protection.outlook.com [104.47.73.174])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44w07euqbb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Feb 2025 12:14:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=asSCDwZVWWMuZLJAcYm3yV1XwQJbtF1TRBm69eHDcYKsxbgiF0eeS+PFDRCL85iEt7joPLpmul+UHanL7/YyZQ2vdqw5S03Reptm3ztjAabPyLjVeEdpPgtJjz/LO5M1ZmPVvfsavfiY8XMf9egeIiJF/C7HinikR5qWfDPR2k1w8xiNdoBC5l22fzhj995zpbU6pfJylWCERbPKKmfVw73giUpA3gvV3zbnzGIY11GZGgH7Jm7pVJoNSrknxc+NKqJlGL/8IBTUkGTg1AJ8nOm9lxn9WmM8RQYLJFX1peb6CxmVIO2pvhcn2k7QWMB5Nw64sWAOiG/PAIoMNXYlfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=grjQu3RGXK3DNULAq1RVc2II1fGcRI2EBudWfY9I2+0=;
 b=d4U3zFmSRD6soWL2YmFDNwXCmWjoYrQiylCPrvndhuoMxduEwUE0a5NwDC9gEjpx0rFWfO8dhq8LhsEVvgLXZP4Knweia1NzU3DKUN8L/v7EKIJlF7pJSoM46QUr9RY/P0FAoKs26s/82R3jm2MrORi4Dn/dbzdXfk9KkgO2F74As54m7pmxcKfwCkzrqBhsBWyDsPGMmHnGcbtoBkN4RGWqgCwrucjvs8djycFXAyanyepheafOhQNib77/kzjNBGoJBH5bA04Cj/1VMRZ2cvzm09D8no/ZCmTDH61hQ/jg0ITRbY2Bmz/pJp/vYUfKcb9kDltH2jpws2AXSi62zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=grjQu3RGXK3DNULAq1RVc2II1fGcRI2EBudWfY9I2+0=;
 b=nT+rTOfaF6GGG1wYwQNw1VQMIff1RS4BY6k1UkZ/2EtnSQTLH38RXEssvwIe+ZgIAZxTRtgqDa/KEdYYErOIjpS5sj3lWFw4oMmYYm41zmvyuxpE+hDwrWet1RHXW7kAgY1j8Twh0ZcNJh0pkY13QS2mlWlHN6od/kb+wwf4YY4=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by IA0PR10MB7372.namprd10.prod.outlook.com (2603:10b6:208:40f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.15; Thu, 20 Feb
 2025 12:14:29 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%5]) with mapi id 15.20.8466.013; Thu, 20 Feb 2025
 12:14:29 +0000
Message-ID: <1c0d24c4-eddf-4aaa-aab2-39109078e340@oracle.com>
Date: Thu, 20 Feb 2025 17:44:19 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/230] 6.12.16-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20250219082601.683263930@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0057.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::10) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|IA0PR10MB7372:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c9a898d-d12c-4e71-e73a-08dd51a8202e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MTRvUTRDMmVpRlZUbHh1dVVGTndHUkdzMnlsV21WdHpzK2N5eC9vZ1Q3MFJw?=
 =?utf-8?B?bzAwancwWk4rUHV1U2o5aERxdFF2eXhDbWdvcmthOVBCT3g4RkJ5a20vOEV5?=
 =?utf-8?B?ZW52ZjFubnBJVExvd1R4QVowMmVhUjZNRGIxWUNoYTV3Wmoxd2hzYUJDcFNy?=
 =?utf-8?B?TzRKNWZrUGFnMDkxWjJsL0RTbW8wNzFaMHRCb3FBMVN2QXpFREg2Y0F0REJi?=
 =?utf-8?B?RXF4WlhhaW1pbi9QUjkwZ2dMZEpqbEhlcjBnSlJvZWNNZytvTDlMQW5wT25a?=
 =?utf-8?B?WENma2VZcVg3WDFXcVJ5TndtMk5hT0dnS09HTXZvL0h1Q1VScEZUeFhIUW1l?=
 =?utf-8?B?OFRXYjNiSlN1VitkNTRwWnF0T0NzLzFuOVhCTDMxdGlSN2xnQ2JqRlBHeVBt?=
 =?utf-8?B?V2o1Y0MwUnorRHFwYXY1NVpHeEpnZkVtNm5qNXdRYkVaT1hxeEMzWUdrbUlB?=
 =?utf-8?B?MkU3S0JnWEYrMFd1VUJicmhlcVdyZmFSc1lMcSt3MGVpY0tDQU5kUVI3N1dm?=
 =?utf-8?B?S2I4QkJsR2NFRHNNdkZiZXZVSGdiclZUeWhWNjJITnBsMWszRWgrbDZ1U0FF?=
 =?utf-8?B?UW11MnE2MFBZdWxEM01GbVI0NHNlY2VQTjhiQk8rcU90RTRCNXZHOENHSCty?=
 =?utf-8?B?VDEwYVo0QzBnY291UUpzcFowL2g3U1ZESEpIeWZyUlpyczhrQllOamV4Z21H?=
 =?utf-8?B?SXJFQ3p2L1hVUmM2RDg4MjVzQllNYkMybkhuMmF0a2FXUWpNZy9RN1FQZ0VT?=
 =?utf-8?B?N3dsckdhMDdyRDZYYi8rZ0xGMmI2eThCaXR5Ymc1OUpERlNjRm5sclRVS1Mr?=
 =?utf-8?B?RDBkaGN2UW1iWTlZOWJBZlBQb1N5VEMwb2IyQkgrTkc2T0hVUThPYTN4M0R0?=
 =?utf-8?B?ODZxQk1iNnQzUnVwc3drVGlURnIzRWNZbVJSM0FBMjVxRGt1KzZ6N3hqbUxj?=
 =?utf-8?B?RVFuSUVkSVRGQkh3OXVvYlVCM0FwVWdqOFVkaXhac2YyQmNKblZZZWFmMSs5?=
 =?utf-8?B?N2QxRFRkYXJHM0VrVkVqME8zVUVtOG5oU0dETVovdDhmam0wSkRIc2RuVHlY?=
 =?utf-8?B?V2h5L1lCUjlWNDRFWHRLR3h4cEZuUlJjbnU3MnNPa2w2UE5rN1JkUXlkYjFF?=
 =?utf-8?B?RXhuT3Bad3VBeGVDWkdSNXpkRkJMOFRxMURWZ1UvYTAzbWg4SGVOYlBQZ08v?=
 =?utf-8?B?WVYxaWwzc1cwUFY5MFZCbzZERUNOcGFzbGVIeEl1eDBGU2UvMmxTMEdnMnZu?=
 =?utf-8?B?Y0VxMkpRWGh1TFZuaGVzTkRWQWZVUk1uVkxZajJsMG1Oa09kTmlsNzRQMTV1?=
 =?utf-8?B?VUxLbFRFOHVIcnBUMXhJeWV0dTNCQ0tSTFhwRks0ZmFuN3hVeDRNeW5uOFZ3?=
 =?utf-8?B?R005VTVPVnU1YS9KY1NvVGZKZjZhSk05clZFWE9tVXJTcnhZS05YNElQVkVH?=
 =?utf-8?B?K1VjMW1iZXF1OXV5ZXk5eENKSWNZU1VoajcwbkxNc2ZXUFFCNzZYT0lRUytp?=
 =?utf-8?B?K2ZPL1I1N0tzQ253YTRVS3Q3WTdaNG5nRUZpbmp0VDgxRU9rWmQ5bFRHbWlv?=
 =?utf-8?B?WGVoUDFnZjlBTWdTTWlDMEp1QnAxVHJjeTlRRGRhRDdvVVQrK042dCs1SjdY?=
 =?utf-8?B?Z2cvaWFWMUhyTmVnelJuYzRHOHFhbXdYakhadXB4VkV5Y08wdVIzU1hiMjFv?=
 =?utf-8?B?ekNTQ1JxZUlaWnJad0tERVFqVTEzaWtWeUMvMmhyc1RqWEFUSXdVSGsxOFN1?=
 =?utf-8?B?R1BmdTNjZTNzcmVaVjJFK2UrVFo0bVVadXJjeWYybGc4R20vV2puYzlDejds?=
 =?utf-8?B?Y0U3K0N1UFlFYTdJaGdBSG1SOFBxQ25yTGxlalJSTThUZ094akJ0K2xqVEMv?=
 =?utf-8?Q?UT3nX4TOY3G7E?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q2lscmZvSFVoOUtyZ0VHeC84QUFQR1c1REZhTWZTTWlITE9HTEJhL3RLbUNz?=
 =?utf-8?B?ZVdQblI4TVZGd243SXR4WUR2UkdET1dseWtkMlRJM2VOa0JwUk5wbURXOFo3?=
 =?utf-8?B?Ry9wcDBpU1p5VXk1dldBS0VpWTJTNTUwWFU4bUxYSTBndTkrQ29BSGRxc0tp?=
 =?utf-8?B?Rnk2MFVUc0dxQ2VnVDBXRWMvWkpaNEFVWCt5d0lEQm1WV0xMVW1jTkF1eWV5?=
 =?utf-8?B?bmttQW1UTUVGNVI1QjBxRWdMb252UDBFRlZkSEJKM3JhcUdJTDdWTitDcTZ5?=
 =?utf-8?B?YkcwNzlzYTN6dU5ISG0vZlBWWkRxd0NmM3lHdXpFQWtYSXBqeHhDMTlCU1l2?=
 =?utf-8?B?UnFZU2RxSlZkUUs1aXN5RHpJM2dpeVBZVGRQRzczSkZPZUM1ZmwwVElPdFpR?=
 =?utf-8?B?Vm1NNDdlZnY2TTVmam1KWHhoYTVpZnFqbndNOHlQWVNLcTBtOURFSG9YeE1w?=
 =?utf-8?B?UnAwUTUzSThoeHpOV1NOZUVabU0vK1dxNWFPL0M4b3dZRmlxbGZtdGpsWUth?=
 =?utf-8?B?MktqSno1UnlxYzl3bC9NOTYzem80S3RmRzIrR3oxbU9Ubk5Na2RTbVZkNm1K?=
 =?utf-8?B?SVJYQ2Z0Rm4zTDZVU2JtaGFjcnJJN2I5ZVFKVlcxQXdoZ0FSZFhiaUVRMmJN?=
 =?utf-8?B?cGp1Z21oanVUSzVzTkloMHlUbGtYN2NMbmtIaS9ZMDVsZDMxZUUxbFJoYTNt?=
 =?utf-8?B?YW5FdTUyV0pxcjVwVXFTWmZKOThkZjd5ZWNYVHBHdUE0SE8zMGJNcmZrNCt6?=
 =?utf-8?B?WXcwOXBsdDdrdEJ3RW94TDFCL0toeVBZVUFOQUVjUEo0RS9IeGlGVWkzMWJZ?=
 =?utf-8?B?dC9INjdPajA5Y2RqMUt2QTFzVzV2V1NIdW5SVVdMQTJhMy9Rd0F2VHpsZmRC?=
 =?utf-8?B?TGxCNENRenNQWTJ2WG5sOUREMWpVRDVHUlhOd1ZLaWcycUpFOElUWGI0QTgz?=
 =?utf-8?B?c1VSOHVxQ0FmOEFoMSt0TjhXeFZ5eGtxL0haZ09UdTNCMHovQ2VyK0RnYWNG?=
 =?utf-8?B?bytpMUtUUTdSOTM2b08wVVZZUEdscE9OZEM1UDV3a2hxdzdYVUxocUtLMG1I?=
 =?utf-8?B?T3VUYXJCdFoyOXdHcjk5ZTBUZC9oc29MT0RwL3NjQXFicE9FVldteGYyT3dY?=
 =?utf-8?B?MEJBOUtzZGdueHdTWGpQaVBBOERVS2xpQXh1UkdpSm9temMvaDBmYVE3YXFO?=
 =?utf-8?B?b00wVFRLbFpxRS9FNEFtUjFHcWljUDB0cTJnSEMzWkx0Ykc0aDJKdDJpOFpR?=
 =?utf-8?B?NnRqVW4wdEUzWXFTRHpqSHBZR1R2cVNlTVVRTGxMTDF3T0hMcUFNTkw0UURr?=
 =?utf-8?B?NE5HZ1VSRUhNaVg0WlpLR2JIeW4xVldIbTNZbURYcmh0bldqOC9LTHlRUXdT?=
 =?utf-8?B?YVYyd3RMNkhDUjRRSTBwWnhiZWNMMWZYUWJIN1kyS0duWnIyZmhkYWFlRzFT?=
 =?utf-8?B?TU83VzU4b3p4V2tSaXpEUzhPK3NRV1dtei9vcUt1amMrM0tsSmlyWnVzOUhj?=
 =?utf-8?B?YklGVzQyaHhicGpqNTQzU1BhV3BxYW5maEZFWnFleVV6V2NCL1NYcHQ4aW9W?=
 =?utf-8?B?WlRVMnRJbVZ0TXhtZ0xKcWxuMS9FYWJQTU1RWHgvY1psN29VUEFQTkF3a3o0?=
 =?utf-8?B?RXhoeWdndXducFJJVXBpTzFBemx0d25xSmZGbkNya0p5WXdMQ3dya3RsS0Zx?=
 =?utf-8?B?K0MyelpodW9TQU5YcjJ2Um9nd2hlS21LUDY2RU1xaGh2TnJkSGRDTmpSNDRM?=
 =?utf-8?B?SHQ4UDFIc1plR3hmeUpTQlhMenIzN1ZSYnltUG9rREg5MlB6M2lYd2htM282?=
 =?utf-8?B?dnc1RjFVTGFtZG1LTzVRN3F0NWk4Q3kvaGRocGxjQVlCcnpPaXNxNmprMzhT?=
 =?utf-8?B?ZEx1TGYzOWFCRnNKQTBpMEdYWEo0Z1p3bDRsMXE0eFVJQU9VZXlmbkplVlhp?=
 =?utf-8?B?d24wMlNMUStMSXZVL2FBNkhudWoyUWViQXhaZ21EWkF0V09hUzlmc0pHVzFS?=
 =?utf-8?B?SnNYZUU4aUY2M3FLQW92djVNZFFKQ1dzOC81VXplV2E2TGg3RW81a3FKcDg3?=
 =?utf-8?B?SzlDUGYwVitIa28yT0dSRUZJZU9Hd3R2U2JBcEpxMWlXSEtLbW9NZjJ5dVgx?=
 =?utf-8?B?N1VLSkdaUlRtODI0M0FHUnN1T2VjYU1CNWo0VUc1T2pzeG5wMWxtbzQranRH?=
 =?utf-8?Q?wID7lTnGILqVqpvVH9JVnZs=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NKPQFxFG9lM4aQ8pHyIXIGCM9Wynl7PG3kFOqLT1W0BLaAicq8b7C1dl5GVObOyx80DkCmhVCSAGcUYYAKO67pV35SM/NRCFRVpNI1XerD5jY2Q7FzOZlIi2tW/0HGLg/aeCWlgrrvnD+ARJfhw/s95RxPRY5bcCaR7pPma2My9MsBtQuSKr46bkCWUu6i+tuYZHT2pAdlRIgWqGyww25y2kXKUeyr+DDgwzYu5gg7qicb/xa2+qvf3PU82vBEsWo9WjIylW5hdgpuc4F0seIpC/GndTZ38ADmMwxt7gcgKI0aWAg6/YCuzeY287/VbEYHhPK9BxcOlkigptXDtq/pKU6Jt98nRr7QV3uL938F2+KPttX6U7B2enouc3538K4fYrAQwqPOySxpdlRJuR8geuDBbvTYPhab2/pMBRWvJQaGI99gu+veUsZpPG1snSie1C0taEjH9nUlvD56lhcbxjM5loWYkqYAflUD+4Jj4D6+a0O/C83Hbnd9zueffZpgxXOnMmVqX+zqGL9dVnec8H8psoeRCCLdZ/HSy1boxvq7+KcqCViybaiJI41Nq/fWvKxaXRBHNWSDgZdkpB4x/XvWw0u17y0Np+vFWdVQQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c9a898d-d12c-4e71-e73a-08dd51a8202e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2025 12:14:29.6382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: du5MP4uQfGnlEebiRTKsayL43DF8UsXHEp9z+KfDGVcnH3BeJJf5XhCFoqMhTLTjrVPA5MGr3upcZo60UwV5y2Sf6dAQTbAI275ttgYrTHAcr34MFyMtSn9iF0qtJb82
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7372
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-20_05,2025-02-20_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502200091
X-Proofpoint-ORIG-GUID: ThwJCKIpvocVIEK1FnStwv6ZwoKPIcnW
X-Proofpoint-GUID: ThwJCKIpvocVIEK1FnStwv6ZwoKPIcnW

Hi Greg,

On 19/02/25 13:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.16 release.
> There are 230 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
