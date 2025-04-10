Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FF61E1A16
	for <patches@lists.linux.dev>; Thu, 10 Apr 2025 15:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744299326; cv=fail; b=f4+ETeAfKGtO0BxhMDAX0iafOAXGEyvMJH5KPT7Vt0K7F/1cdU2H0xZeCxVszOf0Ap5hfe+8urpH4HYP/QEUj1eHFvuM7WNOVBbbU0KgNHnm/JZbz8W2Yaf5ORnXypoDNXh45834vJgpsiapKy/fwHzPYj5hNVO1WrrSQUnp7iY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744299326; c=relaxed/simple;
	bh=4obEOeyr+l70pv46on+4b9CavXV9+s8kCAPUNpW7Vuw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SmLzvG6iDJoMBZIbDB14W2QROvLJsetpXbCk07q4wvFcyjHm6cY2WS/WsZdzQOVbHIDtvpCersXSISNwwNHf5EqBfe5tQhzi6+8OqJeG5QBk+t3Ol+9GW+8pY5N5RHApLW4ZdYGW8HxQrVp1EyfemguPZt6O5TDsJ7ujfjm4Moo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MUzScDjG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ACNvsIPF; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MUzScDjG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ACNvsIPF"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53AFQs6f012764;
	Thu, 10 Apr 2025 15:35:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=/m52cKjFsIb3RVtXB96d0fh2s1rV+mLzie8yan4U31w=; b=
	MUzScDjGCIrHLxVfDDHSENg3wIMH6zYKf3GmL59+3KBcEihXb/d37BI4hT3WcRxS
	rgE7K10tk0qF8dvLCH68uzvBTtH8pJp4wDQDhZS9z8vUl4v2Qhwe2N4rehdnzIBw
	DFTQEdmkh2ZRE09hVDPW+9+QFlb8Vm9+DMK0XtrtIBH7TrkArK+i/XCOncpMxqy/
	F0mFDkAkiUJinGAdjMPzRohMLLgPE2H4y4j1o+Dou5zdYt6uqE0Q64e/FETDiS9K
	w+4Ju/UUCTNPnNcBN9MCpxrLpwxmTohvarJk7pYlpsVsYVhyyREhRoTRHM2+mD3x
	1zZwGN2oLjDgTQ+/UJGdcQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45xgmwg0hq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Apr 2025 15:35:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53AFNo5f013924;
	Thu, 10 Apr 2025 15:35:04 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazlp17010005.outbound.protection.outlook.com [40.93.1.5])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45ttyjratj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Apr 2025 15:35:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y9S4WShAojh1JZVlhvE12bB2KoA2Ly5BFJV2/QcC41shW8/yUUAiagG4NJcfB9KJXoJKnKjoiDa8wTXlO7QqH+VF1KyXXub7D3pmI0WWLxRE6MLaPnciOd051OseetaHKAD6xdYfwop5EYqZ6c28QGsmVfEOnIN2G0aR2hwSfIKdLugYFAzqp8dJvJ6cWpSgDU9+mEeqDLNiaI62zT8RlzpPrLibpCWj2zcY1qbkjno8lPRSV5k0NwzfUlTDWi7DsvkLIzNOjNDvSbRxXCpn/xbs8Gs+LG0WuaCJUBp287NmCcLwZJVIKEuNlowcnURHysgEXDbyzpWVueLIx4duYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/m52cKjFsIb3RVtXB96d0fh2s1rV+mLzie8yan4U31w=;
 b=M74HYEnXCAZEFkcrwehLZ4vkUHeK4BQ+o38iq/j3rL6IZBKXYnJivDhLcR8QGtGhJdsu8y2zSxIMDaCcdClh/ZqkQ/OylwGOGMguaRfkZUWtldHu7y6xnch8WUoOjQBsHb1rmWkoTR/hA83eJzWs0Wl+hReFno6vKmxAlk4CmO8QV+GXsrgx+Cw0nzytYEcj/se640tSGg0rL8sB/JHdpDWBfgSuuFFH5TQRcc5gLldvom4i1CiFuKs8Jhw8c+z6AIDrdkHZqV2o4r22Q9JSdpQSn2wWD8BuR76lXK7R2vlj9zEwiU0HCLdVrq8L1o0g8h5zsqBlQ8/twWM5yo5G5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/m52cKjFsIb3RVtXB96d0fh2s1rV+mLzie8yan4U31w=;
 b=ACNvsIPFmc5AVqpjQ3fEQOjln0zxT+pwj7sBkkj62u52d3ZUZIjGMdc9sJgV8EBzCgG5v9qKDALUNB0BvpXpB10y4VyZeLhfJAd+FwzUurvqByXbGyqRr6LfNVlE4/gTdlSdH1xrYiOAcNoxWH5yyqrSxGWMT2Eq8vKho0xQJEE=
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com (2603:10b6:a03:3aa::8)
 by SA1PR10MB6519.namprd10.prod.outlook.com (2603:10b6:806:2b1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.46; Thu, 10 Apr
 2025 15:34:59 +0000
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af]) by SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af%4]) with mapi id 15.20.8606.035; Thu, 10 Apr 2025
 15:34:59 +0000
Message-ID: <82e8adcb-aa9a-4c94-b355-a43756a012c6@oracle.com>
Date: Thu, 10 Apr 2025 21:04:47 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/281] 5.15.180-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org
References: <20250409115832.538646489@linuxfoundation.org>
Content-Language: en-US
From: Vijayendra Suman <vijayendra.suman@oracle.com>
In-Reply-To: <20250409115832.538646489@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0007.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::11) To SJ0PR10MB5437.namprd10.prod.outlook.com
 (2603:10b6:a03:3aa::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5437:EE_|SA1PR10MB6519:EE_
X-MS-Office365-Filtering-Correlation-Id: 85ed0b71-b88a-4a45-3eb8-08dd78454078
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y1NCM0tlc1pFeGt0RlEvY3ZCeTBaaTRGZFZBVkRSYXZHYnhFbGpQNUxFOEVT?=
 =?utf-8?B?OXZ2S1dNT1RtWUxOMy81aytweld5QWE2ZGVHZ1RQRHR3MGR2T2VpNHIxSm1z?=
 =?utf-8?B?UEVMejFuWEd1MURjcVNGUnArMm1YM0F2Q2VHeWZyalNsVXl2Rys3MkMyVURs?=
 =?utf-8?B?YUxCaUs0LytRaTIxcEJ0ZGpOcEM4YzJyVjFtQ25oTVFkSXRvVEJuOUE5TWto?=
 =?utf-8?B?QWpBUGlIYWpxT3hhY2hBWXFnaGdpWmUrenZacEo4Tk8zNk56eG00bnBDcUU2?=
 =?utf-8?B?UmZOWGRUMTExd1hEdlprSEFVeXVWNU4vYW9YRjlMUjRGb202NEJ6MzlDc21O?=
 =?utf-8?B?ZUNJTWw5M3hSbW5lNnlRLzNOSDBwU1FQcjJrS1N4dHlSZlRNYVY1dnZLdnRK?=
 =?utf-8?B?SmR0bU5EOEhNTFQ2SjU5RDlTSUduNjNDbmxVenVVcVdNQzNiV0FHOVJVcnVL?=
 =?utf-8?B?OXUwMU8xRml5bFFHOHliUTMxVHZnSUw5NzJuTEE4c0gzeFNuVkJPQnZrTkhB?=
 =?utf-8?B?bmszYmRHRnV6UXY3VnphWEgwYmI0c29Wd29iZmEzSTJ6QjU2RzEvRnJoaVQv?=
 =?utf-8?B?SCs4OU5ZU0NhTjVyTVQyTlZyakdadnJBTUk0dzJKWUVpdXFYdHFGaGhTRWNG?=
 =?utf-8?B?aVE2R1NoZXV2S3BHdmgxaEMrSk1BamRXT3ZnSHVudDNVU3Z6ZGVEaHhSWU5S?=
 =?utf-8?B?TVNGZTFka3JrNnQwTVpHM2hScjI4VTlZeHEwUngvK1FQMkhaK1FTMk1rbXFZ?=
 =?utf-8?B?M3hCeldHRVo0N3Ztdkp0TjBkT1hWa0t0TzZ2eXVxU3RtRjVUVHp6ZlFhQVgv?=
 =?utf-8?B?Wlg0OFlsbEtmaDJpNVJzN1FQS0ZVR3RZaVppTFVwNExNUkdCVXRwZDRSd01m?=
 =?utf-8?B?UVlQQzNNblFXTFd3a1hac0oyK00xV2lBSnRjVXpnblRRZXBzand0QzJKZXNJ?=
 =?utf-8?B?dFp3UHo1SnNLY2dOTG13Z05oTGF0UVdLS0N5MXEydEhQbEo0TE5BY0FnM3pS?=
 =?utf-8?B?NFBvK0lMbE1zaGs2TjIwUWc0VnRjOGloNE1qV3M1VkczYzdXRUtOWUwyemlH?=
 =?utf-8?B?SzB0Q1ZqUXc1d1RSZGRYekY1Nit1OGcvZWhnMXpkZHI3WkY1b3lqUVBPVlo1?=
 =?utf-8?B?STE2dkhmVjdHM1lFVUtDcEJhUG9ORmdveFFCOU1nTzFteTZOb1gvaENOdll5?=
 =?utf-8?B?RzBzQlF4NlRQTE9GZUR4YlN6WFhhZ054NHI3dVlzei9pdXN4Z09wOXJ4SEp2?=
 =?utf-8?B?WUtibVcvREdSR21sMFJsSlFuS3RnOTdSRVJBcXBwTkl0OVNBalhvZURveStG?=
 =?utf-8?B?RTBtZHM1c2xaT3U5Q1FubDdHQys5cXpvOUx5b0UvNmxqUmxNS0pBa1R3emFk?=
 =?utf-8?B?Ly9RaG9oS2UzU1lSbVJxNVlIbm81L0lmRWtvYlVPQzJNcTVXQVBGSC93c2J6?=
 =?utf-8?B?SXdGSjZ3WXpuSnYwbks4TzdsbXFvZmpBRUhYbVY5ZHhmbHJGTlRZbUhsajh1?=
 =?utf-8?B?KzlBWUdOd1hyRGptTGZxZ0V4UEI0SDhpa2lyWHhFMTQxR3VxVGZFc1NpelNz?=
 =?utf-8?B?cjJESGVuaXJNZGtDSWRPN0E1UkpRbS93b2txa0tpQlV3eUFJTkNSL2ZKTUZ6?=
 =?utf-8?B?eURUN2lSVFBrSTFPZnhCLzBjNGlib1NaRk5HbXVDZ2tLaDZXWSs4dHFDaUs3?=
 =?utf-8?B?K1dSN09NdFJLTkp4ZTBnSXVTOHlYMCt5VXMxQ1hjWXpxZVhkY2w0cGdiMVZo?=
 =?utf-8?B?L1pJd0lOUVNXRGtUdXlJalNkcWJXNSs5OWZrR0tHOE8xblVUenVLZEc5aVFj?=
 =?utf-8?B?V01rUjY4TUFSU0d2OGJpWXd6Zk92MGxoZ0Z5eGlLd1hONTA4YS9UZXhrUVFU?=
 =?utf-8?B?RHdnZUx5VjNKWXBqVC9PNjhsNXh4Z1R1ZnloZnpaMXMwRFpsZDNnY1FsRHJE?=
 =?utf-8?Q?ylH7iUfOWeo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5437.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T0g3OFh5bjVRTGJOcWExRUJQL0dsc3J3SVBaMXpmTmJWUTlOdHdXaHA0eWky?=
 =?utf-8?B?WWhpQVR2NGFGeGNhYjl6RUo1RWhpcWJtMXRucnFKZ0VXdHZTaFUwL1ZTS0JG?=
 =?utf-8?B?MUt5NUJoUjdkc0diMndaSE1iczlSdVliT0t0MERzZ2hZU3VQMzZqUzRIMEw4?=
 =?utf-8?B?YTZPQkxhNkNjZ1VtdlhXaXBmY3h4emEyZE9WTTRRNnBPWVdnWDNFM201R1g2?=
 =?utf-8?B?dnpLd2JqNnNhTHlVTmlvZ09LdVRtWUJEck1iaXVDeFp2enVHS0hUYWFFeS9p?=
 =?utf-8?B?YXRNbmFJdE40TTN4TlVBZlUzb0ZXb1FvaVVkMWt2cVZFSGRNL2FQVkh2Ri9u?=
 =?utf-8?B?dXBEMEtIY2FRQmYwUy9iWitWSkFnUGd1OEdWUmFSRFRaZDVYYXdtby9sSlg5?=
 =?utf-8?B?L2E3RE53RnFJL2VqVVJ1WitubTRtSC9kc0xlTUpicUNmNzNFM0V6M1BJeE1R?=
 =?utf-8?B?YlhLeTRPeDQ4ZGl5bENySG9uSkF0aXVXUTFsVmkxOGxKZU1abE5wb1BHaWNh?=
 =?utf-8?B?ZU8xYnV2VHJFNkdlOEFjcUZVUHd4MUNqQTFzY1BSK2RDS3MvQ2tVcXVsN3l3?=
 =?utf-8?B?TmdHRlB1ZUFEcVhtems5R2xXbEFCbmc3enpPNk8ycW1mTWMzZFFZaHF5SEQv?=
 =?utf-8?B?LytlVVBMdGZqWkxHMk84QUZiNXZoT3dEMW5yRmxoOWp1UHBmbWpYL2lLU1lS?=
 =?utf-8?B?c282eHhkcG52Y2pBZmRtbTE0NmZvUStyU3M1R1NqNFk3dFNXRkNzeThtK0VY?=
 =?utf-8?B?V0kydjdHeFgvbkJyaVJjUXNYUWRGK3FST1VsS2xmSXFmWk5OOC94UGQ1enlm?=
 =?utf-8?B?Rm9LemVFd3BrNmJqUktRUmpuSTR0ZlFqbnE0a2pDcFpPbUVJcU5HUm1xbXRi?=
 =?utf-8?B?Q3RlQmNtN0lwQjRtcEE3dXp2bGpPR0xyL0NjQjNQS3hiNmxnRTM2NnplOWF5?=
 =?utf-8?B?TkdwRG1lZW9aQjlCVGRMbVVqWmJnTVUvclRNRHVaYlE2bzhZa2tyMnJ6OHQ2?=
 =?utf-8?B?d1Q1d25VTnVPdzVMQTkrcnAzOGkwZEdsYXB0OFVZZVVPQ3NPWXhvMnJIWDRS?=
 =?utf-8?B?M0NvMVNXOTZoUy81NVVMOXlrYUE5bHEvTFExTUN2SElBMWdKT0pjTzUxOTRO?=
 =?utf-8?B?TXIyeERzNmdYM0YvNlVZUXFKcjh0SDJTZ0g5cHdUMHppTHJ5bEtFS0d6TSt4?=
 =?utf-8?B?Q0pyeTFiRzZYQ2xDUmIxRHR6b3E2WHhGWnJxaDNIaHA1N2ZYeFpndjlPdVpO?=
 =?utf-8?B?SEp0dlhBVlVlcmZBQ1VNY2lQT0QyV0pxeGhPY3ZUWVl1Y1EyaWNYamdQcllH?=
 =?utf-8?B?SFc2NjUwQlB5SUo5WUpRVWVuMVR4QkxXYkRsSjR1WWFSK1VmbUR3Zi9OL1Ew?=
 =?utf-8?B?K2hIcklxVTFZdW12OEc5cmJKdEJZeHNoS2R2L2d4QVc5OFdPb3F4Z0wyYWxS?=
 =?utf-8?B?YUcvcVpxeFREQW5uL1FDcmdpcHZBWEt1Q3pYVldoeFJELzVKejdvWEdmV3lD?=
 =?utf-8?B?aWQ3S3VRSkV2djIyWG1NZTh6L1gzU2ZaT0R6R0JsU2k5TERWQjN6SGJwV3lO?=
 =?utf-8?B?ZVEyKzQraHZtNTlyOVFLSUxKSWx6UlFHSkNGVmhBVk9va3Zuc293bm1hSzd3?=
 =?utf-8?B?dTFPMUNOdVVwcENiWEoyRDF3aExrSzVsa094ZTF3d3p5c1A3cGFXZ2RmRUts?=
 =?utf-8?B?SmFqZTNYYXU0dFNoWi9veEkyUzRNRWRkSDJlYWxwQzVXcm1IQTdGTWVWaEpF?=
 =?utf-8?B?QTc1RjZ3NmNnck9UN1hBUUlkKzN2YmJ3V0psOXlGYkJINytSR3ppSk4ybHY0?=
 =?utf-8?B?VndqMCtEeWhBUHhkWHRpeUFmNUJqT28xRjJyNkMraWY1SDlKN0x2TkRjRGNq?=
 =?utf-8?B?bUpaZVlZd1k5aVcrcHlESjc3V0VTcGd5UU5jdnJsSW54WmtxczIwYkZiNDJq?=
 =?utf-8?B?RHc3RjVJM21uTFZSR3krcXlWek5PZ0JybTFNUmhFeDVEVEdLV1o5Qk1XN2tD?=
 =?utf-8?B?d2MwVTZuQUthb0lQajcwWGdxM0VSaHpkUXhyRTZDUndYZFZXVmEvUnRtaG5O?=
 =?utf-8?B?SGp0eXFkMFVpbzN0MTROdUk5VWN2KzR4Mmw3aDR0ZlIxQ0xuMlpTY1F2Q29C?=
 =?utf-8?B?N0dqbzdPaE1XaVZVcTZNZzZINERzUjFYcEt3K2x3cFozMWlLWERNbGtoTUVN?=
 =?utf-8?B?NXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9kQ6035rbpLyGzXqgNokyyBUjQle3FxvZ/wJvrK0OpskqXO0k8mneVsirkf1AZxwwG+x8cQgh8abZLOcQk17oabwBMYIIWU2Sk+t7xHEesXT90WkW3lFYU7iSq7de7MVqHqODmxfnJBy46NDZ4rsYhFpY6vVhD/BJNNb4IZkVmO9zkwT8hznavQMz59DQTvzhERebX6/EWWVhYrgqmYe+7U4G4sHqlXMgH8d2yUBgeP877CjxNRtnwUOs3BTPYGgpSbsdIk3VmEmsOAYoHrpNdvyOTm2GekSbGdeNX+TYiA8XavyxZpKMTYcxavdLF/FpBpYOPh5iFBrSPyDdoKWH/W0auyjvdyTElj6IIQFxKBS6/3/3+mQDPB7XhHEm3yt97cxHsJvOQhE/gQUlsQ2Yvgp3G2ZWIykMvYhv7owMz6vxz9hFj9S5Jk/U0YJTMTm3gCupOsic2xKCFHqifwg0dCMjbT0frVCHxWx1PtsY7lTpACxxvJWpfgn1+ydWYpYwncSk++9FeEItTcFnAOqVDCenRQ3FIFl+6wq4JtQXEccHaZ/BeZH/EzuVgpDUGq4YOjSolkWyABgOoQfbrmCOePLSRyV8EeMKQDhDHG/d/g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85ed0b71-b88a-4a45-3eb8-08dd78454078
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5437.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2025 15:34:59.2243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mx/okjFZiJ+D4PE2YM1/+kVDxlUsmNWXch9uSZll7s5XCcHI4CiR+WKV1QBssbWGAlrJxzryBY9eaiGp2eObK9/z+L4+h4eWneRTnRF0B0Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6519
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-10_04,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504100113
X-Proofpoint-GUID: fqAdiQbTTPhFw2EMN-jY1T9rppaHE59K
X-Proofpoint-ORIG-GUID: fqAdiQbTTPhFw2EMN-jY1T9rppaHE59K



On 09/04/25 5:32 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.180 release.
> There are 281 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Apr 2025 11:58:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/ 
> patch-5.15.180-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.

No issues were seen on x86_64 and aarch64 platforms with our testing.

Tested-by: Vijayendra Suman <vijayendra.suman@oracle.com>

> 
> thanks,
> 
> greg k-h

Thanks
Vijay
