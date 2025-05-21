Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FEB16F288
	for <patches@lists.linux.dev>; Wed, 21 May 2025 19:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747854704; cv=fail; b=oBF8rvO/E7w/JouSu4OtDCndVL3RwoJixkTQsCqdNd36GuGJft1/9dP7qvr9V28BN2B11XBvZGn0UZ3/njLOadDoVSOVAzas3F4PqPsE0kOcAdRbqhR/7W2l3M2wwo3Yb80e7FbI34pzRVrGrAH8hbOPihSv6zwDecNTZiiPp5E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747854704; c=relaxed/simple;
	bh=gYmVZu5O25gjpF30TpSubbxELxbcpw1yInCI3LehhXE=;
	h=Message-ID:Date:Cc:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jbTc7Xst9vAnwr+Pkz70VOhqGnPVgwbctB19dV07LexdmNH/Wqo8CjhDHBHMEKfM8mn0sp4OteOiO2Aw4dYWE4xgx7X49y8AW2FKnT8ys3VGF/cZ4rU+IqSHdTN+t9qcfMAflGbBcYFc5iQ2lekQXM5SJ3/QoKHgbMvwIeA6PCo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SMsFtuwm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xeKUnPQl; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SMsFtuwm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xeKUnPQl"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54LJAtMa030777;
	Wed, 21 May 2025 19:11:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hceZnhUvwrq6kzNIrw9s8xsh2M8H8/e3zc8MlYTyL54=; b=
	SMsFtuwm8l/VbGkQpk+QU6cXr1Awi8bBTcthTVArVI6oQOQIFgzd93mUTJITLfi9
	lm0giNepZOlQq56BbdqBo9v8MB0nU8erZPxuBNbcAG1QEYyufdlPX+JBKUHNmc1Z
	q3Xnd4mPwKxNnH7tXa0vnUmo0KD/ZhesWC3mTl8BZKPPongFzV/RAHzH5PvOpeV1
	SeMRRaexkkWSrYNMKY4j8l87f0LNCLwCx0ag02/4XdXe3hUD5srVyyTKD+pWapa1
	Fti5FfC+hz/L+HDaJVBOSAu3tJ2LMNgeNoq122Y3yn3CqVIr6fwq7aMcGRSMJq+Z
	+Bljz7EseDN5LB7zPmTlSQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46smre8020-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 19:11:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54LIT3SJ034582;
	Wed, 21 May 2025 19:11:19 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010028.outbound.protection.outlook.com [52.101.61.28])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46rweq8s89-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 19:11:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H+/b3CmsXf67zqwgL4Jz8gd7fVzZ4lhrD4X3kxHJtpGXhjRvJhgm/9mhlkLUKIoVukHaHr9ee9kYcAd0fJtgW7L3GZvZh6Mue+rIlrRelimXp1SFkXiYpX9a0V1zAYSiRkEHbjyyE7NpzypynJl+UKhk8t2HlHoMEnSPpDm2y40tmm7/rqSo/A6d5+GibJgKsroWO0Qu5SrtTP6/tyaPeoTMuV56onfwo7oHDJqmwS0rSVXVxiMahpinIzrI0SVUycFTAe6ser2KzvSS0k0a9x1A6C79t7ZCKvElZtG5U0VhjxPdPTLZXKY9rbaHHhkh4Fm6KvsgxtWoWqTS5ZPuoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hceZnhUvwrq6kzNIrw9s8xsh2M8H8/e3zc8MlYTyL54=;
 b=CvWFbIA0sJWZsqIidzZw0bXtOuStk+d2MEeNJ8NjWIT3tuDsc26QoB8nnzkxA3169H8aSTj9EvJDeZXCKpFRlE7jm9KsokK86rCFM4pLNyCdrPEockHdGT1LFsvZ4DkXtC674tinFx8lhxiVBlRTvynnY8vfUgtztpUHHUm7k6P2xEe0DkrAVw3zhgnfe3xFTAh5eJDijKS9c2/Fbyh2EdxpAG3WHuhao3dBh8Iur02ATWdMDz01qsk1Z5kddmXuQfM1r4I4xb4i6tbA0+ZLtuerCC+2U0VekI6m0lHHZi5mk6EZuH3daRe+HDvGhr0O3rp8b3ecPtV9o8gG95XdhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hceZnhUvwrq6kzNIrw9s8xsh2M8H8/e3zc8MlYTyL54=;
 b=xeKUnPQlhfbBFTVel5JDx4l7uCD2XP0dkJ085fIK68Btyi8BH1q47Mcbdwwp89R0BdkDW92yn0XH7fo60DoXTCfaCruhRBTlEGTT86xcP2lhGm7IbUV3GK7sqV3liyFn1AxexcxgS38L7cdL1tTcbEHCDLufC/HYZumctUjVL5Q=
Received: from SN4PR10MB5622.namprd10.prod.outlook.com (2603:10b6:806:209::18)
 by IA3PR10MB8589.namprd10.prod.outlook.com (2603:10b6:208:577::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.31; Wed, 21 May
 2025 19:11:11 +0000
Received: from SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::6bce:37ef:d1de:d084]) by SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::6bce:37ef:d1de:d084%6]) with mapi id 15.20.8722.031; Wed, 21 May 2025
 19:11:11 +0000
Message-ID: <81cd1d38-8856-4b27-921d-839d9e385942@oracle.com>
Date: Wed, 21 May 2025 21:10:58 +0200
User-Agent: Mozilla Thunderbird
Cc: alexandre.chartre@oracle.com, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
        hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.15 00/59] 5.15.184-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
References: <20250520125753.836407405@linuxfoundation.org>
Content-Language: en-US
From: Alexandre Chartre <alexandre.chartre@oracle.com>
Autocrypt: addr=alexandre.chartre@oracle.com; keydata=
 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
 swLliy6PdpST
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0206.apcprd04.prod.outlook.com
 (2603:1096:4:187::21) To SN4PR10MB5622.namprd10.prod.outlook.com
 (2603:10b6:806:209::18)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN4PR10MB5622:EE_|IA3PR10MB8589:EE_
X-MS-Office365-Filtering-Correlation-Id: 52f2230f-16e9-433c-6ac0-08dd989b3f8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TnVvVktlSVo3blA4cUpxcUxsNFNocGErYjlJdHlXTUVwYnR3TTg1bXh5NXRZ?=
 =?utf-8?B?QXRPQVVNdVVIcTFvVDlTY2g5VVhQWHFkNWtrLzZFMlZFQmlVVEk0M0JSQTBX?=
 =?utf-8?B?cHZsRG90L2VyT2NobEdQcnpHUFlGTEFsTUJEOW9zN2ZKNkNPSFRnVWx6ZVRw?=
 =?utf-8?B?aDNPZ3dOMC8yU1YwMWdBdUozcnRjd25kbnEreC9QQWdENHRQMkZZMEVLTnZ6?=
 =?utf-8?B?KzNpQjR3cHBxb243bDRUTlJoaFVJWTRwam8yVktyMmkzSy9kSGIzWDBHWERH?=
 =?utf-8?B?TUJ6RnNicEo0RmVEc3M4U2tRUHBzRWZpTU9QNlFmczlEdktXZUtyaDM5UUtK?=
 =?utf-8?B?Tlk5ZkR4MFhka3M5VlNhRXJyYWcrekYrZnRGeWN6WVo4L0ZrMHFCOHNEWkdG?=
 =?utf-8?B?Q0tlYWFiU2x0UGhEbWkrSGZzWWJYb2c4dExvUDFoQ0NZVC9ZMzk2MmtFREtk?=
 =?utf-8?B?ajIvb1NHWHRpallwME1KV0FwMWhjekk0WTV1a1dYa3hkRmJKQnBlc3A1ZXF5?=
 =?utf-8?B?ODhvTURxSk1wMTFjc2pvVDZidkFTdGhrU2U2ckQzL1VYeVl5NVlyTnFBRTNJ?=
 =?utf-8?B?M0swU3VqaG1jQTZSSUxkTytxS2pZSk5ZZ2Q4ejV3ZGxvcXFnZktyOTNmRWJY?=
 =?utf-8?B?WG9SNHp5SFhiTE5idkRXbmZOakMyU1BFeUhYUGxUOStnL1k4QVZtcWtIVjVF?=
 =?utf-8?B?emcvYk9nRW4wcjZuQ1NES2tWNkVobWtUaGJPVmpHSThCL2sxZmlpQUtsZ3d2?=
 =?utf-8?B?ZjNKZWlzMWlrdHB4R3RpV3RPak9DVW5TQXlCWjFPNkpkS3RNdzhyNm8xcUNk?=
 =?utf-8?B?SVl1bTFVbUFhSTcvdlBPeC9XMVZTTENHVmp2WjFCek9mUDllM05kb0pEM0l4?=
 =?utf-8?B?bnBBOGk0bnpOUXR4ZUl4VCtVTCtSb0E2Z3V2Qk5zbzVCdEt6Z0lFbGZYaERX?=
 =?utf-8?B?Q0YwbC9Kc0gyVk9zeE5abGpkMENCU1UwRXVjNldseWlCeTdjeUtQR3VxTUg1?=
 =?utf-8?B?NjU1dE5zckc5UzJRYXFka2ZXcGxTZVZhQzlFT0Z6OFYrYXRuRGVlSjVXLzRK?=
 =?utf-8?B?S01BeEs3dkRsR0toOTU1U1JRUVZSaS9SZ1c0UDF1S1JiQVQyY1M2UGNtbG9k?=
 =?utf-8?B?L1QxOC9MN0tlRTQxQ1UrS1E3cjVHWGVlYVc5bXZMSWt6T0c0R0RtNmQxVG5J?=
 =?utf-8?B?TWtSbVJnOVIza1VQRVZ2UVRCOS9Jb1kybUdRYXE0OWlHTG96VHlhR3diNTlo?=
 =?utf-8?B?OUQraDhJMWlrNHB5Rzh4N3RRNWF6Ni9zMXFlTHVmcVFBWkt6N2lNTnJpSit6?=
 =?utf-8?B?aTgrenFtSFpObjF0S1huamg2eVJhNlpWQmxGbHdJc0Nzb2lNWTVIN3JwTW9m?=
 =?utf-8?B?TnozTWtIUEtEdEZDQnV5dkJ5SWI2TTBXdzJvakhqU1lpbThaVVZxUVpPUzJ4?=
 =?utf-8?B?UlQ4NUFKTWdPMWlRUy9pQyt2MG92VENQakcvL2RGcTlUZ0cxRFhmV2FuOTF1?=
 =?utf-8?B?M3FTbTNjcjFaNXBMT01Zb09ITkpXTisraWxtcUtpNk9vdmFXY2lnQU1iN29W?=
 =?utf-8?B?NnZkbDdXdSsxNDhIQmJtMWF3dWJNUHFnbnp3S0JPS2xSeGFzWmlvMExDcWJq?=
 =?utf-8?B?YThMUnFudjRnT0p6MHpHbUNhZzhiRlpzYU5zVy8xTHZDaHVUMzB1SnAveW9n?=
 =?utf-8?B?Tm5YdlF1Q2Q0UVV5SlRtOHdZWjFYZFdkVVNOMnhTNFNRSENTY3c4d2FIMUls?=
 =?utf-8?B?RTVKNmxWT1A4YUdnL1NtbTVJVE9FYXd2RURESmFDLzVVTEthTWl0YlJBRWFX?=
 =?utf-8?Q?YRHw7PYceglFo9A5k+2WxaouLqgSLpU+KiPz8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR10MB5622.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MjAzV2oveWk2Q294R0lva05PRXNySGw0b3dudktJQlJRWGgrYUlrd2hCUjk0?=
 =?utf-8?B?cnZmTXgzYTF0dzFZMDhTRElrdG9TVnlITU0yUXFYWVIxMEl6OWN2Y0NCdFlV?=
 =?utf-8?B?NnBKWWNRanZMM0ZoODFkbTFJZ3oydklKL2ZCclpRSGZ4bjFRQTJqNlV3Nlc2?=
 =?utf-8?B?Q2ZYOFUzd1EzTDhMT1RVQWloZzhZUldTTG1KeitNZ09Wd2dGcjYyNXJ1Y0dk?=
 =?utf-8?B?dXRqSXQrU2NLNmVoNE15OGpxTDNKZ3N6SHZRajVDTTVDdk5teUNZNUFCVUI1?=
 =?utf-8?B?YndEMGErNFVnZG5UVFhiQVU1bnBtbTVOcXphY2crZlRhbmRYcjBxZERjN25a?=
 =?utf-8?B?dEZjRVg1amNtVDR6RGdteWRwNVBsWUQzY0EySUlJcjIxOGpzdkRYUXNEYlVH?=
 =?utf-8?B?aXdHQzUwOS8xNHJWamlCTFVsZ2VhdThnWitVNE8rWFVQTjZPV0wycnlaZmJ6?=
 =?utf-8?B?L1RHd3BPWUdVcnFHWWVmQytWMjM1U0E1Y1ZWakNneDdQNUl4NFcrZVpaYVJX?=
 =?utf-8?B?MlppK0liNmU2WEh6NDE0MW1zeWlRditMSGJMOEhqWUo3TUxMMFZ5cXk4Z2lm?=
 =?utf-8?B?aXM1R28rNElpSmNncmVhc1U5QmVQL2o2U3Z5VlJna2dHK2IraXU0b0hDamNq?=
 =?utf-8?B?ekFtbEFZekI1SlJtaDdXTGNMWnNPNWlkOWM0bDJPNGY5WmhwUzhvbzJsUlk4?=
 =?utf-8?B?aUdQN3ZIb3I4VjRzc3VDRzN4UEg4SWdqVGc4dmpKTU5DMVhRczZUTThnYldZ?=
 =?utf-8?B?dks5Wmk0eVZra04rSEp4L01vazZrNVhQaHNnMXIyMHkvRkhPN3RwZ2ZFaUY0?=
 =?utf-8?B?VGV5Z2k1R2hBUDZVaDNqV3RoYkp2U3E4VnRWaXcrTG9IRC8xS3J0ZlJUSFlr?=
 =?utf-8?B?ci9JZlhwMmlpWlFDV1VINkpnRkpEZk5ZY2xyT1VmWUtobnkzWGZTczNCT3B2?=
 =?utf-8?B?d0xtSjhvaWZWVXZmdW1hUlV6WHJJa0NrT0p2eVhLZFJhY1ZMSU9WT0pxWlJE?=
 =?utf-8?B?RTFGb1Rad0hBMzdKc3BMRkdyVGprNE1ESkhrczlCdXJZajgzMUF4ak90R3d6?=
 =?utf-8?B?KzVPd2Vqdi90RE9aV3IzRlBoeTYrYXVxMFpuSHFYZ2I2UzNaRTBrSGwzUTcy?=
 =?utf-8?B?RDVJbzhFdTVwMDlwNlRBVVNaQ2JGZ0xFUFdCdkdkM3VDT085VFlINkRtVVJF?=
 =?utf-8?B?V2wzTmJ1blA3dTRhbFc2YU5aKzVtT0M1NzlDVkQvUmRHaFUxT1NubFdvQlRM?=
 =?utf-8?B?aSt2SW9rVWVDNXFqd0dCWWdHdmRadkt5LzQ0a1FXRkdsQ3ZzcnA3UzZxdDFw?=
 =?utf-8?B?cHl2RnZTUGQ3blhjN2U2ZGNCM3hsMjkraEZvRC8zNTJKd3VTL1FHN3JtZUJH?=
 =?utf-8?B?RVZIYWNMMXIrbTNqUHR1dnhaZFF6TmZpemMreExVQkZQVkpiYjVTS2FMWDFO?=
 =?utf-8?B?Y09mZ1JwM2tJMnRrUGEwbzBTeDc5UjlHN3ZiMjNuZTBvQkRhc25YZmQ2MWNR?=
 =?utf-8?B?RG12RGpKSjQ3ZDNSUXNSTFhJN3JOOFlScmpiSnlVektyeGNrWGNHZWkyWEtE?=
 =?utf-8?B?WUkrR2t1dkJaN0FPTERVWTFzc3pzcEQwaFBPSUF1OUw5Z1hzOVJ2ck5Zb0Rv?=
 =?utf-8?B?V2xaaTZjZGtLQTRtSWt6Y2o5NFFSdEtIeStWdkt6Y25uSDlWcEN2eGNaaXN1?=
 =?utf-8?B?RmpwSVdwY3VZUlgyOVdFbTZHcmM5WGVxVTNHVlREcU9XME5YUW1yYWpPeW45?=
 =?utf-8?B?QUZ1Sm5ndDUycDV3MFZIUnB4dEpvMVQ4djRjMDAvaTVqdmtRZkdnQkx1M3ZK?=
 =?utf-8?B?V2VsV2RoN2o3dzdyYnp3U0dFYVpJZ3UzL3FEajBzOS9mcjRzRmMrakpQMmV0?=
 =?utf-8?B?cVJQM2dURzNqV0dIZHRGam8ySGlPS01aMnI5TU9UVzFhQm8wL09Nc1JkSjF0?=
 =?utf-8?B?eU9LeHNZRDlDbmZzVHorR2tUbS9ZTnhMN2N6VFZoVHdhUngrMWpXU2ZHeVFa?=
 =?utf-8?B?eEJLM21PU1VieUplWVQ2SGhZa3p1UWxDOEVMZUhOcUEzZWloWVJ0ZUo2UVgy?=
 =?utf-8?B?ZnZRRVlQVm0zUEVwNDVjNWZaVGZWSXJuT2tVRFhJTkRRZVR4b3o4dk9xZlVN?=
 =?utf-8?B?S3Bacy9RT1BQZDVJSjArTXRySG5xbytLZmtTUEtwTkRBRXRqRnJCbmg2Z04r?=
 =?utf-8?B?TUg5aElnV1RibjZRMURyYUtlTU5jcVN5OGl3ZWZieTZUZDE4T3VlTG1PS29X?=
 =?utf-8?B?empWa1h6WFFISm5KUy9OQ2xBQkR3PT0=?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4a1nphlTfR/6NA3PJA8zblISJjBZT6ewCjLqiqbgNtyH1jie+iNfWLWeMWIl+P4LXOb11HG+tHX8L8xjUrPNF8eb6LvVbLOmHEwaQa1aajAaoslD1FuuRecHMhKvkpia5Z1fAk5DidbiCuMRsY5OBEuabZhzOhnYOhzVbZyWHZfVPbP2x4xx5eRAg2orWEc2T5tikgxf5yLofYOzBg7mT2jSUqBIdOF4D6Mm31tUsfeXUaJNDBiGSX7Ovi+IwQFhYXUBhk2Im04EOl5kORLGQSreQDpJLJq/dRyEYUEBm222xovuEmO4Ih2wS5eDRTJxNXK2HsbmXZCgxUzgssQ6OYlXpa5/kB5bUTWNt5EL0HkpHw0tfvnORXOvRpGyiRVMmuAcpqumPVtuXncx+/tbTEpcEX+1JXat9UxZ1I7uU+WitY+nwt7Dj9XVUbSsG6uYudmqsCmq+lF3E/cv688xCJJuo+zxJLf2tws49Xm9MJULgUBHRRgoSUkRy0gic87u1EoD9L9goqy3O9nZszlLM00aySRHja8ruSucQyYt+yzf9/MX4vzWPnh5oGOX14bRRbDFvRA6fRjD8YKCsECNV482r/jyDwUZJd1DBhNKUxc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52f2230f-16e9-433c-6ac0-08dd989b3f8c
X-MS-Exchange-CrossTenant-AuthSource: SN4PR10MB5622.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2025 19:11:11.1210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I0/6o9S/rgpJwGCG3MZHgoLan65qhZhcOftqXxZD7igZvCQ+xnEyQOdxGNtfPBiDRIjAQ7Wr2hJPK5RApCDy4vvzThZKween43yth/JXAMs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8589
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-21_06,2025-05-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 suspectscore=0 adultscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2505210190
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIxMDE5MCBTYWx0ZWRfX9sFJ3oSiEJNC 24QYbuYN3XVewmsC9F/533ZSkrVxWggkqwohAZ+ClumhcrfPASYJN7U5wdQwQNgPiWqPW74EPtR 8nftVLNX3AnURHV8TRjjJgDSJTOO07WXiuxTo2vFL58LCYmis4K7QKRkvMBWdh6UxPPT1NC6ieN
 256sxEviZDEvTHzDV7MY5gwXDcVlSlIq0DSof4HIYTZwyqY/MRip4m/tp3+d9gtlek9sJZ2Wirx STxschYr3KtM7AVK3jecsByfsca6eEnFxdpu3zTXylucBlxknUQ4mv1zj50vdF8Ovx6Cp/ijhJo 2wTeVVOStLQiDClEozfPwHpq2kITN09j6qk5Lxmdw92ZYx7Ctu3eaXHk1sxPXB4zOLKc4QRyXbM
 KpEigdtbTyLFqHUcmEdZpPwAmUZX4rppsDrFvcWkJds3BKotNXNdSiJQijYJwfNJjbu4bHO/
X-Proofpoint-ORIG-GUID: JQIvw_sTi_pSFBZ_oD-zmgFF6CRevB0i
X-Authority-Analysis: v=2.4 cv=Io0ecK/g c=1 sm=1 tr=0 ts=682e2558 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=BLgt9l-caxTrh8VoR5AA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13206
X-Proofpoint-GUID: JQIvw_sTi_pSFBZ_oD-zmgFF6CRevB0i


On 5/20/25 15:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.184 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.184-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

It's crashing at boot for me when the ITS mitigation is used (tested on Icelake):

[  OK  ] Started udev Coldplug all Devices.
          Starting udev Wait for Complete Device Initialization...
[    3.567527] BUG: unable to handle page fault for address: ff4fa48f82b9a000
[    3.575207] #PF: supervisor write access in kernel mode
[    3.581040] #PF: error_code(0x0003) - permissions violation
[    3.587262] PGD 1007f401067 P4D 1007f402067 PUD 3024b3063 PMD 302b99063 PTE 8000000302b9a161
[    3.596685] Oops: 0003 [#1] SMP NOPTI
[    3.600775] CPU: 73 PID: 1672 Comm: systemd-udevd Not tainted 5.15.184-rc1.its.1.el8.dev.x86_64 #1
[    3.610779] Hardware name: Oracle Corporation ORACLE SERVER X9-2c/TLA,MB TRAY,X9-2c, BIOS 66110100 07/17/2024
[    3.621848] RIP: 0010:clear_page_erms+0x7/0x10
[    3.626813] Code: 48 89 47 18 48 89 47 20 48 89 47 28 48 89 47 30 48 89 47 38 48 8d 7f 40 75 d9 90 e9 13 7f a5 00 0f 1f 00 b9 00 10 00 00 31 c0 <f3> aa e9 02 7f a5 00 cc cc 48 85 ff 0f 84 e5 00 00 00 0f b6 0f 4c
[    3.647774] RSP: 0000:ff63a55d1b8f3cb8 EFLAGS: 00010246
[    3.653608] RAX: 0000000000000000 RBX: ff63a55d1b8f3d38 RCX: 0000000000001000
[    3.661565] RDX: ffc82ea4cc0ae680 RSI: ff4fa48d971b1fc0 RDI: ff4fa48f82b9a000
[    3.669529] RBP: ff4fa50cfffd5d80 R08: ffc82ea4cc0ae6c0 R09: 0000000000000000
[    3.677496] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[    3.685460] R13: 0000000000000901 R14: 0000000000000000 R15: 000000000002414b
[    3.693425] FS:  00007f525eb73280(0000) GS:ff4fa50affc40000(0000) knlGS:0000000000000000
[    3.702451] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.708864] CR2: ff4fa48f82b9a000 CR3: 0000000401476006 CR4: 0000000000771ee0
[    3.716830] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    3.724796] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    3.732753] PKRU: 55555554
[    3.735773] Call Trace:
[    3.738504]  <TASK>
[    3.740847]  kernel_init_free_pages.part.0+0x46/0x70
[    3.746394]  get_page_from_freelist+0x3df/0x510
[    3.751453]  ? do_set_pte+0xa5/0x100
[    3.755446]  __alloc_pages+0x19a/0x350
[    3.759631]  pte_alloc_one+0x14/0x50
[    3.763623]  do_read_fault+0x12d/0x160
[    3.767802]  do_fault+0x9a/0x2e0
[    3.771403]  __handle_mm_fault+0x3e8/0x6c0
[    3.775978]  handle_mm_fault+0xcf/0x2c0
[    3.780261]  do_user_addr_fault+0x1d2/0x680
[    3.784932]  exc_page_fault+0x68/0x140
[    3.789119]  asm_exc_page_fault+0x22/0x30
[    3.793598] RIP: 0033:0x557a550175bd
[    3.797591] Code: Unable to access opcode bytes at RIP 0x557a55017593.
[    3.804878] RSP: 002b:00007ffd57006600 EFLAGS: 00010206
[    3.810710] RAX: 0000000000000000 RBX: 0000557a6a620e40 RCX: 00007f525da098b8
[    3.818676] RDX: 0000000000000003 RSI: 00007f525da09908 RDI: 0000000000000003
[    3.826642] RBP: 00007ffd570067d0 R08: 0000000000000000 R09: 000000000000000a
[    3.834607] R10: 00007f525eb73280 R11: 0000000000000206 R12: 0000557a6a620f00
[    3.842573] R13: 0000557a6a6b76d0 R14: 0000000000000000 R15: 0000557a6a6b87d0
[    3.850533]  </TASK>
[    3.852972] Modules linked in: psample pci_hyperv_intf wmi dm_multipath sunrpc dm_mirror dm_region_hash dm_log dm_mod be2iscsi bnx2i cnic uio cxgb4i cxgb4 tls cxgb3i cxgb3 mdio libcxgbi libcxgb qla4xxx iscsi_boot_sysfs iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi
[    3.879765] CR2: ff4fa48f82b9a000
[    3.883463] ---[ end trace 5c8bb91d889112a9 ]---
[    4.498240] RIP: 0010:clear_page_erms+0x7/0x10
[    4.503205] Code: 48 89 47 18 48 89 47 20 48 89 47 28 48 89 47 30 48 89 47 38 48 8d 7f 40 75 d9 90 e9 13 7f a5 00 0f 1f 00 b9 00 10 00 00 31 c0 <f3> aa e9 02 7f a5 00 cc cc 48 85 ff 0f 84 e5 00 00 00 0f b6 0f 4c
[    4.524155] RSP: 0000:ff63a55d1b8f3cb8 EFLAGS: 00010246
[    4.529978] RAX: 0000000000000000 RBX: ff63a55d1b8f3d38 RCX: 0000000000001000
[    4.537945] RDX: ffc82ea4cc0ae680 RSI: ff4fa48d971b1fc0 RDI: ff4fa48f82b9a000
[    4.545910] RBP: ff4fa50cfffd5d80 R08: ffc82ea4cc0ae6c0 R09: 0000000000000000
[    4.553874] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[    4.561840] R13: 0000000000000901 R14: 0000000000000000 R15: 000000000002414b
[    4.569798] FS:  00007f525eb73280(0000) GS:ff4fa50affc40000(0000) knlGS:0000000000000000
[    4.578831] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    4.585235] CR2: 0000557a55017593 CR3: 0000000401476006 CR4: 0000000000771ee0
[    4.593202] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    4.601158] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    4.609122] PKRU: 55555554
[    4.612143] Kernel panic - not syncing: Fatal exception
[    4.618980] Kernel Offset: 0x39e00000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[    4.686287] ---[ end Kernel panic - not syncing: Fatal exception ]---

There's no problem when disabling the ITS mitigation.

It looks the problem comes from pages allocated for dynamic thunks for modules, and
this patch appears to fix the problem:

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 43ec73da66d8b..9ca6973e56547 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -460,6 +460,8 @@ void its_free_mod(struct module *mod)
  
         for (i = 0; i < mod->its_num_pages; i++) {
                 void *page = mod->its_page_array[i];
+               set_memory_nx((unsigned long)page, 1);
+               set_memory_rw((unsigned long)page, 1);
                 module_memfree(page);
         }
         kfree(mod->its_page_array);

I don't know the exact underlying issue but I suspect that the kernel doesn't
correctly handle pages freed without the write permission, and restoring page
permissions to rw (instead of rox) before freeing prevent the problem.

alex.

