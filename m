Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF59C19343F
	for <patches@lists.linux.dev>; Mon, 21 Oct 2024 20:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729540863; cv=fail; b=eMVLIilSSo8nBOa50/RDDUThx1nTfQE9fOS5m8MqNks4nBLfB81SZC8JM0GoYsQGlelzkQWjYbDYLFHSw0YNOHv9hTc2cBoxKKVSBnyu52UrskkGOBBVWcNBq2uLR4s4FG7NAe1u18oqtbGenx30GhQc4tzRP4MEs+H+ZNLdnw0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729540863; c=relaxed/simple;
	bh=FJTO9vDUkb76O++HWzSvqekbhrkwwZb51oy9xUrG3H8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=brZnlXnivmBfdQaKqh08t23zhrMsI4gINV2KqqtXvqp2jW7/pw2O0Ir7Fm7mUCnRN5V6YbdBvB5JZQSdoZ9zRgxod/kI3MIXBE3no7/hSjqouRTiBeyRjNuwrATVNf6SHiXFkLT6mL+EddOh9TVjvlU3Sr67q1za+EtRwclv4CE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IQyj/Si3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mlFfoe04; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IQyj/Si3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mlFfoe04"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49LJBd5g023182;
	Mon, 21 Oct 2024 20:00:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=+6wEwugTgH8DjgsmZEOKtHVID3W4k4uMmxuCfhL03ck=; b=
	IQyj/Si3Pahv8gZ4tYw70m9N9Wo+/PneGvSZlXJL1t1QuvzBjZfUGZUU9n+BhIIC
	yJd2kwZ/U7C3vlwuQJRSPKow7B6YhpqxdBIfQGLy/dFe9mkOlCHEPL83mqB0dVfz
	N/t/1RicV3OaK6LYuiXs/Mk+S60h1Mi62uIhxFIK5lY0YP/I5iSHmW8FXO+izfXG
	yzgRriMn0TdJ1hfJK3VAErIAhIrQ1fKL56lZHvDeCaTYQ/GdtFXhv1mjvjeZnJvq
	X/tJtieXbOyI1VLAx70fJWGwCqUayay1haFXj2TMwArogtbNCntN6AQ8MCjNpFAx
	d4GVQZP18lwWMlFHuEkURA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42c55ec0dj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Oct 2024 20:00:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49LIiQse026897;
	Mon, 21 Oct 2024 20:00:41 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2049.outbound.protection.outlook.com [104.47.57.49])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42c376sss8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Oct 2024 20:00:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KU+4pUvhurv7jotFWQLjbWk02AcfKyeavL1ythfd0JeuHOXRdJHlEuUHvpZwqEybWAGConh42yT9vu0XmCxpU5NnNvPlczLElc7SkB6Z894s2inRHI0aiOYrglS2FXtPcRNJVJ6pXkMGXDi3WJpj1ieJ6/xd+70f1e5ALHeNi+LicSE0KYSW0NRurJMz6GVi6KNZhUdMT9n15mCaB8dhG4XzXkLgFhWns7MQrXPyN0cdkuP9ynegqMOurez1mAQql7b4lyUwIC160KsyZGpR6f/5m4Tp67KaJcSQiP+YZwmtXhaTTKJveHO4nRhFm7Hz22gl8OWmswsfEcfcjyYhrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+6wEwugTgH8DjgsmZEOKtHVID3W4k4uMmxuCfhL03ck=;
 b=DkisWKzn8eL9gq24RQSUUvHhWaG69GQCsBZoo0Z/GdSYPDkPqVUXe2a6P8fmk5oA7gPJnUnxTAgcP8FKa7p9YzfemR1vaHl/XiBh6mwCR95hf26QAnIzeaCUeWQ7nd4ZLc4BziX4wT6KL/6lw1nfgJk9ceT4XSn+vOUaQmbnqqNxPjoSmJGw7ApxwtX/9ec1JdXDt5zM67iCO+u+TifCAOcRuZrDvlHbuDl7/rtXdWQSQfhtQZBU5GQAm6eQfdfsV1rS/wmArXyVhIZNg/HLaA0BFr2qsW3ADxjzm1yVhPT4iq18VTkItF+kOoSadAKB7ec+okFAEVWtbAw8+h0n5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+6wEwugTgH8DjgsmZEOKtHVID3W4k4uMmxuCfhL03ck=;
 b=mlFfoe04KpR+ZAcO1rcp7gE69/+3jlU/tBeXp1bCtlhuz5XS+vLr09pUPe5hw/iQ6zq8e7vc9gu14knPPCOBNekxx5XcJ/qUazv8NGkkbMVZyQ0UEE/wU1xBvRbMourYf1OiYoh1yqrC3HCT6hDEUuWYDdubOtu9/qGoO8BIKV8=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by SA1PR10MB7553.namprd10.prod.outlook.com (2603:10b6:806:376::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.17; Mon, 21 Oct
 2024 20:00:38 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::309b:26bb:11d5:cc76%3]) with mapi id 15.20.8069.016; Mon, 21 Oct 2024
 20:00:38 +0000
Message-ID: <072dfba2-b3d2-47ee-ab1b-888f760dfc53@oracle.com>
Date: Tue, 22 Oct 2024 01:30:24 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/124] 6.6.58-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20241021102256.706334758@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0026.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::18) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|SA1PR10MB7553:EE_
X-MS-Office365-Filtering-Correlation-Id: bb6a541c-63fe-4139-7c10-08dcf20b0852
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ekpOby9MaE0vMFZqV1BUVlg5TFdwT1hhcXVmaVFKQjQ1anlRd2gxNFkyQXNH?=
 =?utf-8?B?bXFPckR0OGtEOTRmYVNKeVVUQUx4MER4c1hsd2prcGlPVmpBZUZZUVZDNmo1?=
 =?utf-8?B?ck02bXl4RTFURXFXS0NsQnN3VmhBREI5SW9hMWdYOHl3WTRDYjJsYklHTEk5?=
 =?utf-8?B?RXBnZkJiRGRyUUg4SGlhL1lFbis0SGZkZFpiS0ljcGVmdnlxZS84SHYyZ08w?=
 =?utf-8?B?K0s0VnRxQ2tlNVBFdStYcHpDM1MrbE9MZmhtRDdnVzV1VjhNZWVwd2JDeVEy?=
 =?utf-8?B?ckNZeXpKVVB1YmdYamZOMDZSMnlVUnVSQnhTTG5OaWNjV1pJWVBKQ211UUN4?=
 =?utf-8?B?bXYrUmRhaHVnR2xUR0R4NEk2ZWQ3WmVYazZuVkpMLytoM092OHpUd3FYUjFu?=
 =?utf-8?B?YmxlOGJ3bHIwQlZtZXIrZjcvS0pEbkVHSnlsNEs0RVZnZHNYSXVxMkh1c0xn?=
 =?utf-8?B?aUE5bjFuVnFaQ1N6b1dKVHNMYlh2MHZoOHh6NlhkamFBT1JKYlFTVGdJK1dB?=
 =?utf-8?B?Q25iWFkveVVIbDFtVXpUM0xIKzVwb2V2cHplaDZ3S1c5MTExSWY1V3VaeXNZ?=
 =?utf-8?B?RUlNcU9QZCswSGdWRnp6RDNWbjVLNWxVRHd2eEhWWVB2bkt4OHlCcWE1azZu?=
 =?utf-8?B?Njh3RDhva1FCWHdrTnkxVXl4Um9LazdjaExYUWN4bEJKa3ltSVY2TU9JNCs2?=
 =?utf-8?B?bllYc3FReUkzWGc5SDhDWWdvQUNpSWxGR1h4a0tLTXFkazlGMkdqUVE1S1Fu?=
 =?utf-8?B?SXN6ZHFyK0N3KzNnRDd6WTNiLzJ2OHpZRVRqTXFkdkUxUHVqVnJNVC96TURE?=
 =?utf-8?B?Z0hrTTdYQ3RSTHNGRnZQREVvVlhWMVM1V2FHRTIvaCs5emJvVFNqQXZiTTBo?=
 =?utf-8?B?YzMzeE5SVDMxM2c0NzB4SDQrK1hTUHFuRlhFQjRKTDhqdEJwVUVPcXlabDdx?=
 =?utf-8?B?M2FucnNjQkkxVk5DOEladGRDUDg3VTFBcGlLMGkzdXpFNUlORTZTdEFsWWd1?=
 =?utf-8?B?OWFqdVRmd2tGSzQ3bnNQUE5RRGFQcE81Tmw1dS9LQWtSTER3RnVGMkwrT0x6?=
 =?utf-8?B?V2N6MXJWWGF5ZXNHSGhZcjdiV055b0hMWUh5Ui8zRHBnVzJwV0huc1VDcDFn?=
 =?utf-8?B?bVJBMXlYbnZ2cnNtbFBWUUVOc2VOUE1udHRxSjNzcy9oNWFFT3lsY0RRTmFX?=
 =?utf-8?B?TXJXTlJUcHBhY3hqUGFXcVdiSHpoVnJhNVJkYmFyZUFZdzFTb1VBOXVyRlFK?=
 =?utf-8?B?aDJXN0EzNEQ0SDhMZnRadTJDQ2tKa09OM0hCbUUzSlZRckEzOG5IWTUvWlJm?=
 =?utf-8?B?aWZzOUtLYytudjFBK2cvdmN5aTdXT1p1dkdNUGhLRWgxWFNZMlhsZTlnVHgv?=
 =?utf-8?B?LzZzL0NmeXB6QWtIU016S0krK2NMMG5xZlp0L0V2Z04waURZNWRDYmVUUksx?=
 =?utf-8?B?SVNaclFSbUNnbERjdDFNOWJIRG1XUHpoQ2lhOTE2S0dYYzJua3E5OEhDTjI5?=
 =?utf-8?B?Tk54SnJNaWVwYXVuMDRUTWtxTndDVTBFeWk2VmFPcHVjYXRUQ2dHMjk4VVF2?=
 =?utf-8?B?ald2TGRmL2NPSVBlOTkzdEV0eWFNTk84ODlsS3d3OU9QLzVDTmhlRGdqeE8y?=
 =?utf-8?B?TG11NzI0WVFHNWlUQ09NOGZZNFlDZFgwN3NEUFdxYWR3VlcwazZobThjQXh1?=
 =?utf-8?B?YzdpRHdYSlpWQU42RnRCR1ovUzBvR2VjK2tiN3UybFZzTFBCUXdBdTdKV3h6?=
 =?utf-8?Q?vzcEEEYzD/CV+88Y4GTeNW3gqOtSPX+soxhpAKe?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cFVnek9EalRHb1lPQmJLQ2QwVGkybUpKOTY0VmhFTGJWK1ZaMnc5RXVWV2Y2?=
 =?utf-8?B?TTN6anNnSXQvZFIrSDBLTmhIRUlLTng1Ni9MdjIyajhEd0FPdjk0eEtNeGZa?=
 =?utf-8?B?UmVJR01zb2ZNNTRFemQzTDVFRWQ5SS9yZkE2T2dFUzBOMGI1L3RmdFptaEhR?=
 =?utf-8?B?WER6Z0lBU0xvT2xBVS9pUGdGaUVzazUzd2VYV1NBS3ViZXJwOVYwa1dwc3RH?=
 =?utf-8?B?OWFHYWdtajgwQTd2bUE2bmEvUndFak5HZXk2bjk0M1U0bmQxMDFGYVN3SkRN?=
 =?utf-8?B?NVJqdWZKOGQ3c3k1b00rUmwzTnhPOEZaRGFWbXJjVU5PaWl0cUlEcVdjQUE2?=
 =?utf-8?B?UWNpQm1aeDJUcFRyTEZQNmdhempEWDhjYi9Za0RkZ0RIMjlXQUhJSWNwNTk2?=
 =?utf-8?B?ejFwejR0WUZDZHFUWHdabVM1NVNDaE9jS3laQzd3UHlZTnJMbjduRUt2Wmdw?=
 =?utf-8?B?MXlOOUJpOHZsYUhTYUx3WHBWTG56RGJxck4wSjNVZXNjQVlTK2pjWHAwR2c3?=
 =?utf-8?B?NEp3WDNCSWlGcnJxTlVscW95aGVMaGZsSW9nc2Rab1RWalB6dFNxQUJPejN1?=
 =?utf-8?B?Z0dqWU4vNStMWkF1cEZMNUZjNVc0S3dWSHlkL0h4OFRjZU9MU0JWUTViZDFs?=
 =?utf-8?B?eVAwU2NZODBJS0ZxZnZOL28yWjhHWk1qSmVLMThDdzlJL2hkV2dOZXYzdDM0?=
 =?utf-8?B?c280YWNRTTFzQ3JwWXlYTmFXeUN3K04wMFpnbzQyT1J5QUhRVUFLU3ZvU21L?=
 =?utf-8?B?YXJIeVZQYkRCOGttU1NJTWpranovd3hKbVlHbndyemZua1g0VTZVcFV2ays2?=
 =?utf-8?B?cjNpT20xOXhUblpuZXdZcS9BZFN5azRuT0pqemlMZk15MGFiZ2pTZXlMMitL?=
 =?utf-8?B?ZDlMUFRESVNXM2txTjdyOGRjRTZmTXRhV0k1aW9jYzNoMmVJM3Z4NFZxZEVj?=
 =?utf-8?B?SldKNnM3NXAzSSs1YS9mMzI1S1JVUXRodjNqU2JBK1FrVk9iWU11cThpT1hU?=
 =?utf-8?B?d1JHdW96Y3dNSks1YVpHQTNCZy94eDkwRzBPUWo2RHRJS21VV2hRTTEwYzVw?=
 =?utf-8?B?eUpGbTkyYWR1cmhKWDFhckdwQyt5QXE5elVWRFp4WEVRRGpsNDlEcWpuTEw4?=
 =?utf-8?B?eDdERnM0cjFzM0loOGRjTFVjeHFxVDQxbjdaWUsrdEpTQ2pWWDBUWUFJT1RG?=
 =?utf-8?B?R2k2YS9nQ3M3OCtBN1NMTDZ4L3FXTUZOcE5jaUxiTFNqK3hMeXBKV0luZW1X?=
 =?utf-8?B?WlVxSDN3andBOCtnTGJOdzR5bjBENVhPMWNObnZiWW8zQTBpWUg2dGxLSFNv?=
 =?utf-8?B?STl1ZzF6S0ZITUdtRHk1Qk9XbTQwMTZrWnpPaUkyMGtQZ1hrTmlXdVNzaHZt?=
 =?utf-8?B?ampBMjFqWHdUeWFabSttNzc0NUJWUy9QNDV0U3ArYjdYV2ExS1FpMWR5MnFM?=
 =?utf-8?B?RForYUc4YVNMNG00S04xVU9sZEtDeTc4eExFbndQbHMvVzlMUENTRHBteTFC?=
 =?utf-8?B?Q3ZEeWgva0lRb1AxbkJXSzlWTnNVZlI4d2ovdVUzNlNSbm94QXZob1ZqSkgy?=
 =?utf-8?B?c3JnZlZEdWJ0VzdzNDRldlJjK1ZOcHUwcHFFNEZSbkpoanE1dW84WmJuUlBI?=
 =?utf-8?B?VXhUaFJhYmd1WFRSWnhPQjNpWk5iQ1djWE1BY3JKLzAyNHBIalloS2dwN0hP?=
 =?utf-8?B?eGp1NS83V2tWVHUrZXJJdWtQUkdMbVlkR3B2bzdnSkRvUXNNbExKdGN6NCtQ?=
 =?utf-8?B?WDErcE5vNGE3ZDlNR3d4V0UyV2hJUmQ3TUgzcGlKZ21ENHMwVWVGYm83S2RV?=
 =?utf-8?B?UkZ2bitGS21tdVhiWlpYNjd2MjVVWnp2K0tJUGVwVDR6azZLOCszUTFSeDFS?=
 =?utf-8?B?SFdSZ3AvVStUSEJpczFQdmNLN1lnemhRMk1rSUU4U1BsWmp5T3ZYK2VqMDEr?=
 =?utf-8?B?eFEzS09SWFB0UnVuaXIvSGRZcXBKQ3ZaQWE1ODFwOHR2clZXZnRnTXkrc3Fs?=
 =?utf-8?B?SzJGSzMxYTQ3dlE2UzhUdElqSytRM0lOWkRCSVFjTTRTNWc4MFBEdlhQNHNG?=
 =?utf-8?B?OEhCZndzRzBUMFI3S25GazJGaUdjVUpuQXRvbE52dHVTd3AxMUdkNTVEaU41?=
 =?utf-8?B?OHBBRXlteTk5MDN4SHpjRHV1eGptMm5uMnVnNWd5WjFFRmxRaS83aGFyNWJm?=
 =?utf-8?Q?OXB8mN7vp9c/AyK8plwGtXQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	T44lOIVbBYyugg26vZr02YP4LLLT6BnottU9VGw2ODGf2S4dhcIu8BnlWNpVplZblafN0WQ2I1lJ7siEZj3I0CmcotLE5D0znOWqn3mmW5ugjURYUTIzOPzOZtKe7NnNpB43n8sMoVeUZO0soOI+f3NanFYQ9z9dtBLxy11XTnnKrHwM4UQ5Fy0s24HhDwyboXdIXUMagAIt+Sp56N9bZJ2qA2v8NjfKyNKm6lrl7m517sxIvJGQv8rUw/1Oeiuos+aVGmQLHE4tHqSWwU8KGz+126fczmvSKJwzc+P7946RfaPtraG6gFq0UqLrWvxgLR0aLW1CgKilWH/Nnck3OBtseM75299qhADP/j1e0b8enicM/KgMtntLKvwLONa+7ut2p6h++pVvy1a5iduucu/eFAmqZhCiDCw57RI9Jxcb24MR02hVhrN8gEHtmzKkNQR/zA8nq+BjNbDqr40zB7OCCQlS92dcNTvP3YNLTXvCOeLNub3pzsY1mAKIbHCTyP4ddXu2QpaHjUq6x68jRhKWrbXN58MAEuJg3j9xawW1tPiIVUr4Wsc2tE73Y8sPuyuMgc6RzFMJwFg0CW9kAArijx7qkC+ZFBfWFLaqhRk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb6a541c-63fe-4139-7c10-08dcf20b0852
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 20:00:38.6265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kYJCiT0fEbm7baRYbZ6+Bsv7ish9ChxpBr01tNmMMNA1qKExj1r8vVaJHAt8JTb3XZSKkXBrfI1O+SppkjoBLh8GzA8gC0+rGYPNMSeuABxaKB1D1Qs2RihkDDJ0MdaI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7553
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-21_19,2024-10-21_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410210144
X-Proofpoint-ORIG-GUID: U8e2t-xG59ywx0uRBhF8qIzsTSFnx_vz
X-Proofpoint-GUID: U8e2t-xG59ywx0uRBhF8qIzsTSFnx_vz

Hi Greg,

On 21/10/24 15:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.58 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
> Anything received after that time might be too late.


No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
