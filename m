Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7931FA151
	for <patches@lists.linux.dev>; Wed,  8 Jan 2025 14:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736345620; cv=fail; b=R9Xe130DijT8A1ztdkm2oX53mGSIx3jvHrzmLI+6gdD0TxypRXHS00fOGndANIVa24XR06ozL2ZRU/Ns97HZh8qkWbVw8yk7huu3NRtbIQG3ekZEgT7IFx19aqarV+J8ZCfMEiLCSsrZbikKUgAcWTZeT3GWaS8fyRax03vPG38=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736345620; c=relaxed/simple;
	bh=2yVlDrv5CJ2vA5BIZHaEMmV2ZM0tYNjC4ZaoHWFOgag=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LBb+El96P4AtGNtWvv5lTOoym3FtMy+RneJocKrQIUPlLMow4s0wNbEF5tOa17Om371SypeJhJofO7EeIKh5WcRKKr/RYyuPFS8T5e3kJC/KQWy0HS6K0wZEVpdVOHUvZ7/3VuRKYqINdXsaY9RZWeDuEJT0cZeGzNtBIjPvT1g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WMADgyiJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nB/ye2Qk; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WMADgyiJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nB/ye2Qk"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 508EBojR010357;
	Wed, 8 Jan 2025 14:13:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=+5k3kwxD1mfCldXA2KPV43UvyjTWf1FoJjuuluty+Lw=; b=
	WMADgyiJxWWxzQiSmJNa5Wajml8cpQ7HuAad9zPb+kadu66zpAKYWciu+LvDtioY
	4cikdk6jZn8yDz0O5u+47hfGLFI5Fak2aR2JKZL1OAwybzEYvItUAJf89k5O9Hyt
	cvHTJsG+DGvP4c/a3yYUwdA9WwjWwocBXZboxl/O/cWqsHf7BRP9UYFYWrw5TfHD
	+wMthBjlTuwkOiQh9Yp0TCl86hy2tTPMJz/5qNzDXJIrnF5v8td8eaK5xfl5GHwV
	BzI3SU5GuzcolLSBLgijJnICh36JZXlE8bxjEAdMI5HKk56k/uHtqwrlgl61I+8i
	dZJUblkgln7Yl+dxilmF2A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xvksxmbg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Jan 2025 14:13:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 508Dsa2m022806;
	Wed, 8 Jan 2025 14:13:23 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xue9t4b4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Jan 2025 14:13:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vRq4vAu7BZYCXewL951pEJLMu+tQtGxJqCDmlSWKo7svcYa2ojXHFWNh7xCDc8JWVArVROHWuL/xHCs++yIV2r+zpEu/WXfq9x0N0SCKpR65HTdY9a8cv2jPdufYvwVJmQ47P5Jxq871QgAE6IJJ18e4aiZawvtUy3zN+79t1Tl5sBRsdAWA2/dlSA5ZVQJvkaqyjwnfJAzOKKGmQcOFDycWVMhJeOs+BXLpx4hPLh3+BR9bl3xGS/K4tQ6iq4XkOPlxAXyCYgTuAUuxGlE2WTTYzyIxi1GglP9RVfIxnKkN58aP/vyLJC65ypGVFd9hPTe8vjnDIxRB0xi5wIqMvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+5k3kwxD1mfCldXA2KPV43UvyjTWf1FoJjuuluty+Lw=;
 b=WCrLcqhAFBPt3pDXqqPKD7vNBCNyvPca5KkXynQbjunrxmJMGU47p+kxSqKXZndssphf2LLi/nrj0ANJTsekRccjrf0GKcZr96Q57+rSKhJ0sqSkxiUS6BonyZkihdTtEJe3OR76MXd3UAraT/plizR7fBJ3F7eXIkQ+yIFByoxxT3Er8kxPVzSHhNkx4xX3QePWTbhPeCRc/Jg/2ZFno6hMDINXvOCZdi/v3sLj57o87zPdl/CVpVl1oBN6hTo3MM9PDpbJXpqBhQMCJITaPfSKD7zYCAb3MmoTVWgymglGisy88+zulQPZ3cguIU3Bp5VytiIhGdh21cganEG51g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+5k3kwxD1mfCldXA2KPV43UvyjTWf1FoJjuuluty+Lw=;
 b=nB/ye2QkzkQSXwh6GSzNaDHN8KnxPIQA+8Yw6c7XAOxHLF+ok9A/F+OQ5k0aLTx9tPUpAbmFTyyUumW5x+PAGVl6ASJgeTwqH41pf46xmvUIQk+iKySS1owKjFKXiu9mO7lJCktHoP19lcVXRrs1oOXfv1gulWjimoZnJv0VMSc=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.11; Wed, 8 Jan
 2025 14:13:19 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%4]) with mapi id 15.20.8335.010; Wed, 8 Jan 2025
 14:13:19 +0000
Message-ID: <a37ca42e-b005-456e-9237-f1a7bba3d323@oracle.com>
Date: Wed, 8 Jan 2025 19:43:05 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/93] 5.4.289-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20250106151128.686130933@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR0401CA0021.apcprd04.prod.outlook.com
 (2603:1096:820:e::8) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|PH0PR10MB4456:EE_
X-MS-Office365-Filtering-Correlation-Id: 68a65272-acc5-447b-f5c5-08dd2fee99db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aDg0RU1tUnQ4QUdhNkpjaUJuNDNOWEsrSU5uM0dNYU1MeitQRFlEY1dPSDJG?=
 =?utf-8?B?VE55TjFCWFAxMnJ0cW9DMGdIKzFoYlByMXI1R1Njb0U0enRsaW5EaitGZDEx?=
 =?utf-8?B?bUFqMmFEVGNKK3o0cVlJWnBzaEt4bVV4ajlnaFR4cUxuWlFodzZVaDNUTGpt?=
 =?utf-8?B?OVJjZElGTUlkWWdWNnU3YytBdFRDa3ZBMVRzdVg5d2lnZ0ZLNy9NNEdDNTh5?=
 =?utf-8?B?VUFEaXNpV2pCRzE3TVZIc1ZGelAwUWZsazRBckJwOFlacjdUTExhUUkyMXZC?=
 =?utf-8?B?aWtXSzA3Nll2cCtJM1B0NHoxOGlEMUFodEkrekNmeVdjUFloQkthT1ZTSzRE?=
 =?utf-8?B?TldoWGR1QThIZllUMklGV0JkSTJZcnZtVHUzUEdTaEFicW9mSnJVZi9tekFu?=
 =?utf-8?B?YWY4NnlteUQyMTM0b1NKcnRyVHdOd3BlNlI1cGpHanFmeENvRklkdUF2T1Jl?=
 =?utf-8?B?cjJ6eHVVM0R4KzgvcXNIcTQyUk9GU0VpM0xNNzJudzE5WjhhVmp5eFlBcXo4?=
 =?utf-8?B?RVZhYVVDY0lkQjh1MDJ1QVU0QWo5YlN2Z1VBeURUYXpIT2Y2UVlRMW9NKzZ6?=
 =?utf-8?B?RG9OQjk3aWJLNlRlcjM0Vm1lVXNhMzlReXdweXU3UUgvdi9OWVBPZGUyeFBz?=
 =?utf-8?B?N1VvdEdac3Z3RnBJR2xMc2w4dFJybzBjM0pMOHpPcGtxLyt3YWlON2dqd3RQ?=
 =?utf-8?B?SWJQSjNKcmx3QVVEV1BtYUJGVExnclBkWVErTnhkSlU1UkVoNFZycFFpeXVP?=
 =?utf-8?B?SmI1dzlFY1JqTnpCZ0JPMEtZR1FocUZqRXBvbXJoUnRycGROVTJzN3RmaC9Y?=
 =?utf-8?B?QTFDUVJucGczUGJ4dVA0cmhSK3JIaFVISFZHUmFIOXlVRjZZb3laV3J5bmkv?=
 =?utf-8?B?VlBwRDlOMVpxK2pMUHNVcnA2bVg0WjRMQlN5WnFuMWVUNVRwL281eUZHL1hR?=
 =?utf-8?B?c0NScFRLK0pwa1VMdzMyc0VrVWFtU1pEdDdXYktwQWRnSjVTTCtnTkF1YVln?=
 =?utf-8?B?b3I5LytUK09ML3ZlMnZibWFuTzduZVJlREV4Ly82NndWUTlMRG1aYzRZcUZ4?=
 =?utf-8?B?dXZyVlBoNVdmQ2psTDIxV3pVbWtTblJSMWY3WFpBdEZKSjdxYTMvRHg4MUJl?=
 =?utf-8?B?bDZFamR5cDlDdG1vMGZERm0zVW5HUFZscys3cTJ6UzhmZERIbytCV0xCaGVs?=
 =?utf-8?B?aTRVSUh2K09hYW9NbEhKSW1td1NhcXVPbEpKOVlwcEFzUkhnMWFFUXNnNHZ0?=
 =?utf-8?B?cVphS3VUT1lSOGozcUs0L0ZKc09oTDVkRmhTREpOam8zSkdpM0svNm9DbHBl?=
 =?utf-8?B?d200aVJITDV2Ry8vYkNqWGVFL0ZNMGE4Z0lTUlhtMXpmMGZrQlBPeXFFMmVJ?=
 =?utf-8?B?NFVyWTFhZkRpaC9IazFNdSs4QlhPYVlWODNUU2ZkMUlEQWJjTFFnaGJXMk1E?=
 =?utf-8?B?VXVlUlZLRzg1VE9WUmJwejZxZGZQZlVobmhiamhkcVNkZk1lVnB5UVpBcHBx?=
 =?utf-8?B?NzVkUHpVeUFUUC9BMkJackRnQUEwU1J4MzRreEVwaFIxWFFsOGREa1pyVm45?=
 =?utf-8?B?ZFUrNnRacmUxZVhiZER4ZCtBN2FiNHA1bnpUM2dwbEtIeXlzNHlicStUd1lW?=
 =?utf-8?B?YnZFZTRrTDNZWlJTVUlDdnhvbS95RnljTURSUk14dG9NMHhuanhHUi8vSThY?=
 =?utf-8?B?YTluUnBja1grNmI1bVpsNEkvbXpHTHk1R0VwMEZMOURBMlRMbjErNC9XcCtN?=
 =?utf-8?B?RCt1dG10UGlYYWdBMXUwL0FTckROZjRyRHJiWVAvand6ZnVCL0N5cktZeSsy?=
 =?utf-8?B?ZHFNNU8zR3ptdDdzVytDVjRSU3V4WFhQUy9SNnh5Smw5M3hlQ2tCc204UTBl?=
 =?utf-8?Q?Cd+4TsGjGjTvi?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QWF5QkFWbi9ZTW9GYXBTYXFySDgvcS9GSnkrQkR0RUxtTlhUUzN6OGVwRVdp?=
 =?utf-8?B?T3lqOWs0cjlsL1F6eUNPRkFuNFZpaHY1OGJDMkZ5VVBUOGk5aWJrd3hHSTQv?=
 =?utf-8?B?ZElrNHdQUjNYQ3RTWFNPWDdVNlQrM1pMcWJtNSsxTm1UOGFPSkErOVU5TEEw?=
 =?utf-8?B?bVUzU01vTVJCTkJJYngrMFVsbkE3dEllNFFLLy9sWEg5cVpzbytrc21ZWkxx?=
 =?utf-8?B?cDdKckxqYUZENyswUnlXQ29nZHl2aXVESEVGbXFPeVlDYXRoK2xKV2RMUnVs?=
 =?utf-8?B?YlBVV09WVU02SFg2ZXJvMjRkOVF2YmxkcE1zODNoK0I1dFJiRWNhRFd0ZUQ1?=
 =?utf-8?B?Yi85VUtsdUZ1TkVZQUdmV01tL2xxVm5hOTJ4RXY5Z0gxUW10UWxvazNjNE5P?=
 =?utf-8?B?YW5meEgvRlF6UUx4ZEp2U1FLczZMUzBic2puLzJaQlluZU9aT0JOVkVZdDlV?=
 =?utf-8?B?T0ROZ1hrLzRYWUYzK2lLWVh0MW9YK2J4bEQ5UDR2cVZXakdZblcwT0QzT28v?=
 =?utf-8?B?eUFFL1RSRTdtTDc0TWZZMXhEOFUzdmFHZy9GS2JYaFBGTE54dmZER2E3VnNw?=
 =?utf-8?B?SmpiaEt5cUt3ZHVydUx6cks1Tmg2YUVLQkdSOGpwc3ZPdjV2R0RWaEM4Nlha?=
 =?utf-8?B?Q3FFWEllcDJIOE5Lbng0OE41TlUwc1k2ZVAwVlByWmNrZEFGdzQ3T2dSckdT?=
 =?utf-8?B?akZmVTNnL1M2MDVjTVEyYUNTSndZZzhCSUhhVG9Wc09ERDloZmlLOUxPeUhu?=
 =?utf-8?B?bXdDWWxhbndETDY4NjBsM2ZJYU9lbmVvdEw2UnNJbzZZV0lLd1U5dTV4NFly?=
 =?utf-8?B?VVVZOFRlYVFxakdITkV3cEwzeDFPbHl1TVV0VVhYWWpXOG9OQjZ3dGZ1SlVE?=
 =?utf-8?B?QjlXanlHN0NXc1FtK1BCcVl2OGlnZWRQU3EvdWVPdzg3N1h5UDJ0VUVIRlVW?=
 =?utf-8?B?NFliNzFXTW1DYmRxcHFFN0xtMzByVWJPRDFhd0J1dm5yNU1YM3JaK3BjdnZF?=
 =?utf-8?B?YW5TdmlYbW85TEpPRHo4ZXFWZGdsc3VUdGFoSGVhVzhuSzJjVGN0cy9Hay82?=
 =?utf-8?B?QVZHSjBZdlFueUxMQTRVNmhUSWE5amdLMS91MVlWK2hKT2NpSkVBZldMNEZM?=
 =?utf-8?B?S1hiS2xtYldJbEEwcUJ5Z3hNdlluVDhtQmEvdmhVTlVtRlV2UUJ6RkIyQWZF?=
 =?utf-8?B?L01rVE1DYjZTN0RpaUV0aExGTXQ4T3FKd1hQUGxjRlJTR1c0N1M4UEVCbzFG?=
 =?utf-8?B?cS82SW1idlEybEpTaFlaSTUzYlhNZ2xhNXQ3alRGR2RZd2lYWFd0alNBb2FK?=
 =?utf-8?B?cmQxZXVndklJbVpFamRia2QzTUdiM0M4djUzTDdjZjVZN3NvVmV5dkczUnM5?=
 =?utf-8?B?Y0FFRklrVVlMQjljbnpkdHJuczdVMEkrZFJKM09vZUdPYUlybnBDUUcyRXha?=
 =?utf-8?B?RG1ubFpwME05NlEvenZvc0MwRWtsSGd4TitBbkN5SElpUis2blpqeFB4U0hp?=
 =?utf-8?B?aDBKNUJQWVM0SysvWER2OEhSbHp1YU9NZjR0OXdNWmQ0T0huL2FoU2Vta1JE?=
 =?utf-8?B?NmlkcTlUamZlMDB6SWFJNGVMUm5maVkyd2RlODJEZzhjUHcrSk9LWEF5Y1Qr?=
 =?utf-8?B?Zm5nZklsbzgzWGIxVU4xc0pqMFpjb1dCcnNJQks4M1loclpVWkFkdkp3bExs?=
 =?utf-8?B?Yk1YMHQwd0VTODBBTk5VcVdvZ2lJbFpUcTRZVzN5TUl4c0creHBSVFlHejNK?=
 =?utf-8?B?YkRqR1FpdTVvVWpocm9sT2dIa29rNEZmU21tbkozNmpKT0k1WkdGYXQyUUdq?=
 =?utf-8?B?TmFxcC9kUWFObTkrelpBaXl4TzJHdkxtZUdacnUyU2VKWGw2YzcyMVNaZkxR?=
 =?utf-8?B?SjZWT2w5bHBCVjVTNXdhZmk0ckxMY3FoNnE3U2YzMDBaWXRxd0VKNFNiS2hS?=
 =?utf-8?B?UGxSekQ0SE1HM05DZnNwblZWZm9FMEo2eHEvMW1pNUZsaHBwSFJ2Mm1HWjM3?=
 =?utf-8?B?U3FCeHRvU0haanFZK081ckJ0d05DQlh2ZzFsY3E3WDB1ckVxZFU5UGVjUnk4?=
 =?utf-8?B?NkxQSnY1VG5tT0FjUzgzaHZwSExsUlBiaHBacnA2L1BQRGJwVEl4c2lUZ1NS?=
 =?utf-8?B?Z3h4U1hYOVBuZGxPN1FFV0luZEZuOWR0NGpFUUFyL1dEL21QcW9UTTBlZWhL?=
 =?utf-8?Q?kpW/yzxS+mhHe7XSpeiETMQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aJWoqI1FPRG6EfQG9kiIK5e4CDAPesS8tR/Ls785sjTCmhrMuVTAtOEFwrh9mArj1sT2QhAGge936KpIvUgvfWNRU9/Kjiud0aT+9CwZJdXl6BSoWLYpvOuSSAYiqZhYIYDvI86qEsOoJ6U1wg3cuk4FslQ9WRqv3Wzl56a9N+GOfRxREJFhkNkQ/A7QsuRi1q8rWnzIDJ1LtKSCA9ld1JQaVIaWvdtaknh5cA2rorpVxY2ztctzUPLwhHvwNeP4RF9LFbWWzVVuXuCWX0DvbYlVl5KKZFUhMEaoSL6NJos3Li4iK5NKwHbB0xWmk7WmGWJIoqASKgBMf45Z8szKAhD5ulh1YtKVsc60i+l/IqlsgZOQRtDKf+xYitBSv8eQVXn7+/PykEOUSiWJM1g99BC+BMDC2L8AXeAnOX3Dyyafla7opoocsB2SvjebmRyZSB/xHX/DstD+btSAgHgR385Rt4QpRnGGgzJM8KOi0V23du9DK6Tm+E5R3NGV8i5vBIq2S2ZVjqIgvPlhwkQU+1PbyNpqtDE+MeAU0PuvSOfroUOsEALZRL/2xnq4k0tUIreIJEdzZM+ZzwF3lDJPa6LL8S0lJlKm3fMEloiH3js=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68a65272-acc5-447b-f5c5-08dd2fee99db
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2025 14:13:18.9665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XgTwmKxx4GvSS1c1MzESTxhJCvw/9FpPSGgvpx8pFlWmbgghxgFKst+rjl+wIbwcL9zgOep3x2UGIdwRmmB0wsIB9680VubpQrfNm/GpmqTWU74CPMgYTTyhIPHpa+cT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-08_03,2025-01-08_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501080118
X-Proofpoint-GUID: mxWpbF_-4jLSWxw88TsU7R5kfZm-ZUiw
X-Proofpoint-ORIG-GUID: mxWpbF_-4jLSWxw88TsU7R5kfZm-ZUiw

Hi Greg,

On 06/01/25 20:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.289 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
