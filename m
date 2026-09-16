Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA7747D443
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 08:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789545789; cv=fail; b=nv/6LbAVN5LOaHiZNjS/gVpy/jE2qpp3R3ZH0868OXZwGzpaHltKyMHtJ9gDAPQ01mG5aAS6VquwoaO2+Q8816sQOq5uDo1P7PQvhRvL1AIR0UR01ywRpH0Hi3Mq/2QxKRWr2xx3lihldrRIJ0Tim7pbDgEzY3HPGylHURSRgQA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789545789; c=relaxed/simple;
	bh=d2pFqtVbmZ2a6VHagUsLvbuR0jNVW47+jDKe3Y8B2fw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Wtt32ueYPUERYogYu4PHJvoKkHA9pI2LV4n7x6kso4mtHEt7HWMnMTAJyS0tXccrIZlKjxXw9gT1CoTnYuzOxqJhNuv4c6VX9RA8X3C40UROtLvBS4syRo7pi1Yxrn+xpICRniqYTfQ8jGs8hHEwdamrR/qCWYJXA5P/2DHubS0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jktGIXw7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Q9eRnTOv; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jktGIXw7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Q9eRnTOv"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLWOx8641100;
	Wed, 16 Sep 2026 08:02:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=85ztMam2LRkR7bOXUUhj0WjOlFjgjn5PV/hUU+KNqXI=; b=
	jktGIXw7AAKMDcJVfxZuoPHCEDorYX4yXnLQqQUIqZLVUe+7aDbb7hBILwVstcMy
	f8Ki65bEZRbV7gTArcLnojEWQ9KHUrvLTdWqiv5mOca1E24Pp+anlttL1N4yggeL
	BVc5oJtlhNJnew6JVlODeWkzjPB6cPwgqUwkW69EF600QufEaI37rtjhlzLUvaVf
	jvf2Tj0wG2AnPL/y8CrO20bnwwtzxeYc0+/LzChXTc/UMKOrrSu3IycosCSxjg0P
	IAHsV4tZJaGrqjnxM+I2mYkSn19iMVScz9gBlNcDqcsSr/y219+kcrRca2BgPQyW
	xmoDfdbmmZsWA/s6cW2Tcw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmxbs557g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 08:02:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68G802xM024320;
	Wed, 16 Sep 2026 08:02:34 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012020.outbound.protection.outlook.com [40.107.209.20])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6b2c5w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 08:02:34 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=onVeHiaWLBq5mpbc1YYswayj8vyYjQyo1DwojDmKvRWSj5ztKzFqlBae9gdgGbChN7xcku3Ss0ZTyzIeNRAgk/Cso8Ra7A0AjamsSXOIvPAysl0lSo3t8R5GjCqfiq2bw9w0FHtKS76NVwBOy2AA0EAXW1L83frhIzNA5TXNVtTr/0hCU1HFRWINqMYSqq4v8LnDxMwu7vN/f+wiDKEovz5hg4UrYkj9u0Jp0hmS3V+WaB8xJEevU/QXvbHZm10M3s1OsbLSD1jbkOvcl2+OVudYI5sTbsYtGNMDwSjUVCdSq+bKzmJTiO0FOzmSfGlaeDBKlps1roagcuNDJ0/88A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=85ztMam2LRkR7bOXUUhj0WjOlFjgjn5PV/hUU+KNqXI=;
 b=sAsYLk4Ctls4R/cuUOo9XUyLpgCV5fXKPwCntfI54l44syFgquo06si4UeSHWXu6Le/GqqPMaW8C9kuD4Ye3jRf3y7uLpYFQxNsFICzhrCJFuTfQcOrqnTpnlmMSxlZec6plmx0Ekmos6C5An4rXEmvq3xe5wDJuSNlI54px7NT02EGL5541fGNOvGC9ZVvO4Baml835mqXqas2geKvR5K+lHNwhao1dvuCcEHtR9KC7GM+eSKekpg2ag8rQzRokwnj+iS5H8f+VLrgkc7hlTQ78LChsmzMv2SWm44g9SEBMYh0Z4Qgx2xoXyDH3urHAWC6nacm6P9gt5qmMutgo5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=85ztMam2LRkR7bOXUUhj0WjOlFjgjn5PV/hUU+KNqXI=;
 b=Q9eRnTOvCj8lx1XH1RdRg42PcCSiI4axYcSp7bE7l7akRp3r3nv/9WO0S+8wla24Wm4RphaYSg3BOYaxXzxtmwxlsPGxG37iYpFuv1OOq+at0BCEXBWkF6bXfDCzLIopOjM+Y2SIVfnrA5l5Lt8lVbIM3UjND1KCtkDTZN4d2fk=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by LV8PR10MB7920.namprd10.prod.outlook.com (2603:10b6:408:1fd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 08:02:28 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 08:02:26 +0000
Message-ID: <6bba445a-be89-42d0-9558-8009656ccfd8@oracle.com>
Date: Wed, 16 Sep 2026 13:32:18 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0908/1376] ARM: 9481/2: breakpoint: CFI breakpoints
 only on demand
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, slipher <slipher@protonmail.com>,
        Mark Rutland <mark.rutland@arm.com>, Linus Walleij <linusw@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065627.803846640@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065627.803846640@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DO3P289CA0028.QATP289.PROD.OUTLOOK.COM
 (2603:1096:790:1e::12) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|LV8PR10MB7920:EE_
X-MS-Office365-Filtering-Correlation-Id: 3672ab89-03ad-42e0-aee7-08df13c8d8d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|22082099003|4133799003|10067099003|5023799004|56012099006|4143699003|18002099003;
X-Microsoft-Antispam-Message-Info:
	3Fp2fbqCqiDmog8tY+Jr/UCnmoW/DPzG4ujM6f1DB0rlL38PZHOixvHZySxK91p4gCP26cjNUNas6uhsOFmw8E9R1stAe/SqJwaF5wsc1hKBwv73CRfUjIMQ1hpUBKKg/Q/NHOBuFg9DaDy65C3v0JzoWq1mOQQjawBKY/PzX5X2zWlFrD30rZpclwns66KAELSbCpkA60575aWvgFQYNZCVTcTtQy1lm9J0a1vBpCwU+ji9c9XVXCAxxhiZNCmTIMIXRJprCKFCzC9zLChK2BEm7Q5rQhTSbjDXVdtMGzNP0J2dADEI9CdNA48ubhd4YJUdtVJisFg3Vi7BRXJv85m5grraMFr53ZH2Jv9BXd9b3fkCX9u1BeEUxp3s3c02E2bMDoakl+IV4naO57BS/a7jD31DLruNVW8WjUilbClsyB6uv8PRPjV3uFG8BP46CMhUUaZbHWEtuGzxoIBvOGO+4po5gFrEoMoiEpK195kL9H0IHTC+0iXODCCGdIL4aRPc+hsYpQoXcbWkXTJ1o4VgmLArCVPQGN6QQr7rjngW5BA7EcJFAWwEMbgFNKUYq8cuTCog5CIv/W4OoxuUp8rfJvUzaP2tx2NNH/ERGRXTvJtk1sXNiJd7Ybi7vOAbL19Y54v4Hu8FBDL+S/Ef547EEHqGrpxt0eumXQ9upag=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(22082099003)(4133799003)(10067099003)(5023799004)(56012099006)(4143699003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YzN5aS9RMTNTbGtGM2taSEZsc3lnZDdVaWxRSC9POVNEYW4rbEZuZkcxVzk2?=
 =?utf-8?B?TUMwbmZKbUlCL1AxRERieGJ4ZTdxdDBnbDg4K0ZvZEhTcFdLTmxUWENmWkVr?=
 =?utf-8?B?TVR4eWdtVmpxckhQUysvUm04cFhxOFNIaUhQNlNQUnFaank4bDFGVlJ1cWNN?=
 =?utf-8?B?L0NNaG9FM3hBSXRLUGd1bmwxbXNleGVTQ3g5ZWV0YnNHYWFQZHVQU1V5dEdI?=
 =?utf-8?B?enpQWnFCSFVjWUNlSVVkTWtCZFJ6YThoL1hIR3RHc1RicHMvem5OWTYrd2Ux?=
 =?utf-8?B?dTZIZVNmNkFCWE9KZXhsazFNVmlvODBGM29kRVZ4M2RObkpOZkI2NllUZ0Ux?=
 =?utf-8?B?R3kwelhucVA2TzgzOFI3WkltaFRsdWJPOEswSW4zNnpwdXp4WFVxQzM3N2Jx?=
 =?utf-8?B?VktoL3Q2TUZldzBEU0dvWGZILzhOcFZjOElBUVByYnlxU01XSStEd2FvWUJK?=
 =?utf-8?B?NHFlSVBJVE5wY1BEV2IyTHlXUDIzVktUNHl6RW1oSzV1czRmdmR5ZGlKTHNI?=
 =?utf-8?B?OEZOV2FiRExGV2N4NnA1cG9tM2dEYzV2L1M4bEdYZTk2Tno1R2xiZ1hYWG80?=
 =?utf-8?B?UkdQRUNFVkNBeXpKbjdVOGdOeXUwWVZsUkFxSXp4anFqcTVnTmNjT2lqa2c3?=
 =?utf-8?B?Y2lMVmV0WEpiVjhQYzBUVzA1bGVOdForNnRjZG8xa3RyYVBQZzYvMExObXhW?=
 =?utf-8?B?WEpJMHhUYkcwYlBPU3pkcURaLzhtQktKOU1mZXQvVlYxaEVUbkRkbk9tVU9L?=
 =?utf-8?B?SDYwc01SRlFjTG1yMTgxZ01jaXlzOHBWVXVScmhtamhBenB6MmVDUzdtSkRk?=
 =?utf-8?B?YWdBcjNUYjdBcGdKSm9PRFgzT1Q0SVRCQ1dTRnVNbnRrU0VuTEhKTTVBYjRM?=
 =?utf-8?B?WmYydmUxdkdVWjJ0RFNQTmxqMFAwWTdSaDBSeUpibzRqRzJwL3pVMkJ0akFX?=
 =?utf-8?B?Sll0REFDMVRBb21mcTc3elFUU0I0RVJnWFhRc2NGUVBTbVBjempuMUI4R0lI?=
 =?utf-8?B?dHdGY1RpTmV3azE1cEYvcVVLbXphY3VxSnpRdXZtUC9wUnVVTUFnaHdWb3Zh?=
 =?utf-8?B?UkVockp3cDJEeUpLU1ZMVDFyK0pzTVRWdVpGWHYyaFRFZDlxMVVjMkx2QWFL?=
 =?utf-8?B?WHk2WVhMWUlLTVhacjE5My9MRHA0QmZ5bDRaQ29LN2x5eU1KMUUwa01KTVlO?=
 =?utf-8?B?NzRvZ3VQa0YrekFIcitITWEzS0drU1NueHljZFJiRCt4Mng2cUxERmxYVEtQ?=
 =?utf-8?B?U2tLSGdPUWwzZFNPLzRBWDJLNXh6WnA3a3phQVAvYkNtelVYbFdrdGh3UEhn?=
 =?utf-8?B?NnFPOFoyZTVZNkRVaG1HRzNaZVFqTzJyT0M4UThwNmpzc0hlVWh1TzI2SEIz?=
 =?utf-8?B?U2YyNitkTGQrZzhEbnUyRjI5OWtQamxOTmV4TWx4QU5Ya1Bsb2pRNXp1aG1x?=
 =?utf-8?B?M0JZMGsrUkt6Y1A4bnBON3dTeS9YTWJxSWlueUJuZTkzcDZHNWx5Smx3eXRk?=
 =?utf-8?B?dHhtcXRVVi9VNGxnbjZhVDFxNG9GTmgyQ01FOWN4M1FmeWg0VnZRY2l0VS9M?=
 =?utf-8?B?ZGdBdlFNT2tGWE01ZVpZam85dW9RQkt0VGdSN3lQb29td1Z2WnNLY0tTUzBQ?=
 =?utf-8?B?YitrNkxVYzVjSU45TUpCNzhVSlFoSTBNaXBzcWd4WHVmS3RQTGxGZmFUb3c3?=
 =?utf-8?B?WGFrc2hDSzBMSE9GUnRMU3RITHVQaDZqNmp1bGRhOCsrZ3VVak9zeHVIc3M4?=
 =?utf-8?B?ZG1wR2xWcllrTVdnUmNKaDZpVlVDRXpveFgvVnk0bU8wSVpqNHJxalBCcVRO?=
 =?utf-8?B?K1YwV2FFeWExN21maEpvMnVkdzlaV09PRncxQ09yeUFzdjNSYm52Q0xNdjJk?=
 =?utf-8?B?clBhKzRYN3lleFhqVlNXNUZVRkxJUFBpMTk4aVllOFArS0d5bWlERW1IcFRv?=
 =?utf-8?B?TndxSkRMZUFQNWYrNW12WW91aU5sMFhDSWVjSFFINWxpTVFGK3hLK3hRc2J2?=
 =?utf-8?B?cklqQVZsZmpNWE5ZYThtdUh6YTA2V0tqZm5zYTZZZVBoc3BSRHNCWDRldWM5?=
 =?utf-8?B?bFpua0FVVjU1aHFJcmtrdU5DbjVxUGd1UVI5QXJxVnorMkZLUTR0dldnSDkr?=
 =?utf-8?B?ZHZxMHg0V1dUblpuV3dDaEFJT2JzV0p2UkRHUXFwcDNkdWo3aHpGWVRPeDgy?=
 =?utf-8?B?Y1JhR2NNVWVtdXE5V0xRTHgrVGp0dTVlRTVjdG9HNEZyWWcvU0tEYzUzYldO?=
 =?utf-8?B?Q3Vmdjgxd29iUVcvQnZrMmpkNEl2NEptSFJhTUtiSHV4WnlIU3VKQVFHOUVU?=
 =?utf-8?B?V2Rxck5mYXNuTmpEcHFobm1nZWhSTGg3Rk5yZm1lelY2UW9zL01HVnlITzA4?=
 =?utf-8?Q?sIFNXsscvHj79jdu0DdvSYrBOD7Oprms4t4dw?=
X-Exchange-RoutingPolicyChecked:
	QDYiryCrQsqWFrQJ1X3C5Ggerr2tR4HkHUtr0DjRj8Coguvl8dz3bYKMoXNgTUWCHXKSVkCajG7XxDGdzSpckBAPhuwkid/L9CSok6iDbEyH/eS7wiRkRlcU0Pygq2EuUaIBGK/W5NLqZel5xWDGhqC1kQH5r8id/HUSmV63iVC73yzA2xcScdcRUBLTCECqbmqXOtbbEaO+EMvsSVvEKkmnsyb6uWEUfTfRZeuhFxFTsYe/ggAf+O9MLQKiE4kJQcO4Sm2x0L5mLCVVwp36fZcjl07OykKYq6SE70GPJcdLBiHO/7w2Vso99PnefT7JzeNYbhGzaRF2rzw2Mgi0eA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	riVIbHnfrcPASjv+MGUNb03MXtNCVrTuAAlUFzzEoI5h22hkv553esXsmeKLnHZ8O4Wj4CKgYrz+OPnvE1bCzWmVCmBV8Phsk0ivneRqd+ofUanSirK+U1cyvLINA4ZTtpRktq4yG7egngPvk6+PRdzSPmb6URtfhDJYlE3782WwSEjtWnYHUbs81+Gs+rQcXXmItbO7TiwqYEPh/4Lt5OlovcCaWMqbMxy1S5HmmKD3Io1ui2oH3ZYwiswRsqVJQVkCLdCpe0/0XA5wMQy1yXyQGLD6n/RuXkA6jL9YxiZb+t0MsUBAFvrFf/lcf9YxQEUwm0FP0rbVO8w6GlGf5Yss58pKPmURT305pmjIU/95D1J9RjLDls/2Bu1lpUpp7SyH2C00Qo8utRO5a36voQ+3m1zJbTEZWclT06z5LRncKgbXSLjTz+KJ1U3KdNOVPZ/Zrl7v9VMn20oceDJp6Wmfd8B5SX0tHpDcBAcvGR2t7h+6GSQTj5jUeBDCQC9ECFyJkWNyg8ItKOZ4NH71kEGB1BrYjBzY/cHR8gMak21uSkYq0rKpPNSHxqyVzcnpOSCC92ZhQ9LgXghSC4FyT5x1nQP1xEDygdBjZlvpykM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3672ab89-03ad-42e0-aee7-08df13c8d8d8
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 08:02:26.6556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cSr9YwCdCXS6XFJSV+tvnUzMgiheyHE808vvEIHhy/YjXtCc7sD52eC7gWS0F46AjNX5YNtis8dkmMut5HSND0BwFbSS4ZZiXbLZ0biKqb2y6ZNbHhBbeF8IxeVnYZH3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7920
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2609160103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDEwNCBTYWx0ZWRfX7cOHetHH0HST
 cyCuayRleN3nm/5Z06KcYVIx0LAU4GzVuhfwiLKOPYawXkPY36NqhIbgii5QYUSaHxraJh+w/1Y
 zRbSz6vssIrxl3bbO06M1PGvZU5pa4gSb1Sof8HUnahRvboMkVasQeeY2llKC9wqxGM8MTGunPk
 M5kceQsDnb5DprXtKeCUhTukqpdWfOJFsnQU6zic4nqHTFWM5dbHlMlXGIBJbeAORsmMQb+nM6O
 i1Ka8NwdC6lYlkauJ+7FOga3qAV/t27ajAHYG1OsvEAMfacMgmYmUbo5zTufjjilEU0hlahru5Y
 umJZ8UGAvHwtir7KVgQYDicpRyzdKyGSqLgKR6UTXH6pLUa0AEuMCn9T084/t2U2p5Tu/0lRqbw
 rlUj2FDo5pBIyhP3ZzXvqVR3DkaOWzzqq6C/0gQZeorKgXnDbBeZzUmh8/jIww0uGdthlyEZ4vS
 P+SXjubHqQIcQFxA6bg==
X-Proofpoint-ORIG-GUID: YTfphq84Th09OGY51NMbk5-p1-gP5yu8
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDEwNCBTYWx0ZWRfX7Yf9EJcsg3xI
 uEnkWzw7V0e1pmZcc4DAESCHsXqaG/7TkAuzkw74McsYHHdelmrGqGJlbPcCQ7f1lmsrUIcKRd5
 w4JDz80uaCTsun2LToHfvx3gT/morYtAOuVhfFgo44OcUz1SKww/
X-Authority-Analysis: v=2.4 cv=DIYacCNb c=1 sm=1 tr=0 ts=6aaa4d1e cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=sfOm8-O8AAAA:8 a=7CQSdrXTAAAA:8 a=PHq6YzTAAAAA:8 a=LkdLgezWf1TWsHgHJ9IA:9
 a=QEXdDO2ut3YA:10 a=TvTJqdcANYtsRzA46cdi:22 a=a-qgeE7W1pNrGK8U0ZQC:22
 a=ZKzU8r6zoKMcqsNulkmm:22
X-Proofpoint-GUID: YTfphq84Th09OGY51NMbk5-p1-gP5yu8



On 12/09/26 12:25 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Linus Walleij <linusw@kernel.org>
> 
> [ Upstream commit 8ed9bff906cf8036531d1559f10e82733a52b41f ]
> 
> This removes the stub hw_breakpoint_cfi_handler() from ARM, making
> it not steal breakpoint type 0x03 (ARM_ENTRY_CFI_BREAKPOINT) unless
> CFI is actively used in the kernel.
> 
> When not instrumenting with CFI, or when a breakpoint is issued in
> userspace, we fall through to return 1 from hw_breakpoint_pending()
> "unhandled fault" so userspace can make use of this breakpoint.
> 
> Tested with LKDTM and this command line:
> echo CFI_FORWARD_PROTO > /sys/kernel/debug/provoke-crash/DIRECT
> still works as expected.
> 
> Closes: https://lore.kernel.org/lkml/kJqktbpLphg_Pk5I5SPptgTLjl3E3eq5mN5UzCslyFj7Q1Irp-wDid4mj5eQVd2iZtRGXgeZd8goq195EkXdjyt864YMc8mVb2B9NGH91NQ=@protonmail.com/
> 
> Fixes: c3f89986fde7 ("ARM: 9391/2: hw_breakpoint: Handle CFI breakpoints")
> Reported-by: slipher <slipher@protonmail.com>
> Suggested-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Linus Walleij <linusw@kernel.org>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/arm/kernel/hw_breakpoint.c | 11 ++++++-----
>   1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c
> index a12efd0f43e81..6819d4c1f3521 100644
> --- a/arch/arm/kernel/hw_breakpoint.c
> +++ b/arch/arm/kernel/hw_breakpoint.c
> @@ -929,10 +929,6 @@ static void hw_breakpoint_cfi_handler(struct pt_regs *regs)
>   		break;
>   	}
>   }
> -#else
> -static void hw_breakpoint_cfi_handler(struct pt_regs *regs)
> -{
> -}
>   #endif
>   
>   /*
> @@ -964,9 +960,14 @@ static int hw_breakpoint_pending(unsigned long addr, unsigned int fsr,
>   	case ARM_ENTRY_SYNC_WATCHPOINT:
>   		watchpoint_handler(addr, fsr, regs);
>   		break;
> +#ifdef CONFIG_CFI
>   	case ARM_ENTRY_CFI_BREAKPOINT:
> -		hw_breakpoint_cfi_handler(regs);
> +		if (user_mode(regs))
> +			ret = 1; /* Don't handle userspace BKPT */
> +		else
> +			hw_breakpoint_cfi_handler(regs);


Hi Greg/Sasha,

I ran an AI-assisted backport review, and I have verified the report. It
looks valid to me.

The new ARM_ENTRY_CFI_BREAKPOINT case is under CONFIG_CFI, but this 6.12
tree defines and uses CONFIG_CFI_CLANG. CONFIG_CFI was introduced by a
later upstream rename and is absent here. The handler itself still
builds under CONFIG_CFI_CLANG, so a CFI-enabled destination omits the
only dispatch case which can call it.

Upstream source code after the later Kconfig rename:

     #ifdef CONFIG_CFI
     case ARM_ENTRY_CFI_BREAKPOINT:

Downstream 6.12.y handler code:

     #ifdef CONFIG_CFI_CLANG
     static void hw_breakpoint_cfi_handler(struct pt_regs *regs)


Maybe we should change that guard from CONFIG_CFI to CONFIG_CFI_CLANG 
before retaining the backport. Thoughts?


thanks,
Harshit

>   		break;
> +#endif
>   	default:
>   		ret = 1; /* Unhandled fault. */
>   	}

