Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D705222127C
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 09:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752657745; cv=fail; b=hFbpjUJ9E44RR4bHVgxmIl5zZGbBBhxW0agjOn5bDWqiwCzkbVumBpZfeffTWlFuJygM2mjzCVTcq3yWgAs1iq8Th8AppOFEsRfvDStyeBGUjw9uVPDXvSOdV52MsG5Qe+7p7L4OaU42wDTJAwQy6SWlEaRLJEzdnJt5yhxVXCA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752657745; c=relaxed/simple;
	bh=PX8jMWrnJpsvULUMR76wa1t5xv/6UykMCzdl+3Nz1iA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DLikBNlph8AUod6APjGMfmELezppGACfbXDD+pmAyxMoR/XV2y8CIrjBl5XbUQUGGjhP7OSGmPdoDM4jYi9SiCgV+vDgssrwgVIPoDGye+2G52cBR984lrlH93PiigHw+EDQFr8AM0bVPxb6VxqngQ4Zb5/uLMl6nzUXfBEEN9o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kiH5Ardo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=atT8d7mW; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kiH5Ardo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="atT8d7mW"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56G7fxJ4004742;
	Wed, 16 Jul 2025 09:22:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HoECAYEuV9FxtVkjeBVWsG0slVi3TyPoTwozyYNswyk=; b=
	kiH5ArdosO+ufQjX2b3Cq0L/+UDcLxk9erUGwqh3vFtAx8dmeUnMnEnbOxgTbGyC
	zjAXaOxdlbXXiMSbOm+j7xnAcub/T6wg/8ODN3RYta2jMX5AJBfH1OFg75a24hYR
	6DOKtoGzDBEO/DNdlGqtnApIezm/D/NsaXB5VcrosBu2hkwiw+e3vo44+0Ocq/0+
	oV+J3Ur8618xSmzKba92ZSxdtkyKdh6NxfmF4bJEwNCk8xEemmmayO/yQ789LGRF
	bruifRKuiK3EDhqlr4/+QGtUzW+M63MBPso/NL2bZeZMZsjIETUK/DYIMF9MmXj/
	TX2de+PeO/hR1X0/OzPCyg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47uhx80rj1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Jul 2025 09:22:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56G9GJ4d030404;
	Wed, 16 Jul 2025 09:22:11 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ue5b38qv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Jul 2025 09:22:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FsJcj7dG8KttvNcC7rN+/M1Wl100u5N+RNHGNzvB2krT8xP11OFc0r7YeGZyZCptdOCj+6RxTFrLfzievRBzkBj/4uFdlVwFaEeXMa0SKSCcjiMvH5ToGvY0VyTBE3OvbDmHuaFLHPKXsy0GAUAh5WG7Rbo5XXTh96r4TUmVkLeQcfB+WqqaazV1H9u9vIXjFu55NcrLJy1FqA61bOZiLi6/ipLxxD+AQfUjhPOanCBKfDZ5JrgIbwLJC91Svc0QxCt/1ZLqSiiF7Cp3gIBm9lWwnJbVDQ7Po9axYvN7tmwm/bzX/PJoC2COIMc+SlJ+ECXP8gbUCrBcv3AaMi+0MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HoECAYEuV9FxtVkjeBVWsG0slVi3TyPoTwozyYNswyk=;
 b=aMbeXHowzlx+PND5ppPmG32Fi5PmaBo9M1E7a82yuQHaYLgNGKCgKeV7zzE0uVDQmy6vtagUSd56KQs9LzFXjOC6Y59j/phCAwUQEgBrE9XUqpbR5h1POc+7hWy8A9h5iWPFN6jkWp4moZSTugn4N5J9pMkDsMk3jztIIp3OiXlIpe2z/qzGTSnvAjVs1xQGZjOcPnhkObB8Qc/wdBtkXvBpa55CvAGZz54od3zH/OGENsUnkIs7aB1EVvDxRtWOMii1K/rwlMDveWVwz/QlrBLlajdevjqgWYTMBLxHGlusHNVnQLCKfz6vv3Ftbb6am+D0G0/qamcr0mV6t1dIcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HoECAYEuV9FxtVkjeBVWsG0slVi3TyPoTwozyYNswyk=;
 b=atT8d7mWOZOZWqK0YF7U951cN7KWI/YOL9hGwG3AKoRqRt1YzI5mXCfO4UwHGLZX8+tLajiRZ7a6WaW78HFBw25nffVfMxM1okT+XZ+Pc7HKTG82LFFILFbBB90Z9d/xTR4mS5J20QVb3kO0JBQMi4JwPJXGIQXtDYmAZOzBH7E=
Received: from CY4PR1001MB2310.namprd10.prod.outlook.com
 (2603:10b6:910:4a::17) by DS0PR10MB7361.namprd10.prod.outlook.com
 (2603:10b6:8:f8::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.32; Wed, 16 Jul
 2025 09:22:09 +0000
Received: from CY4PR1001MB2310.namprd10.prod.outlook.com
 ([fe80::5661:9254:4b5c:3428]) by CY4PR1001MB2310.namprd10.prod.outlook.com
 ([fe80::5661:9254:4b5c:3428%5]) with mapi id 15.20.8922.028; Wed, 16 Jul 2025
 09:22:09 +0000
Message-ID: <22066120-f2ba-4806-bf14-ca12a74323d6@oracle.com>
Date: Wed, 16 Jul 2025 14:51:52 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/165] 6.12.39-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org
References: <20250715163544.327647627@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250715163544.327647627@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0241.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:21a::12) To CY4PR1001MB2310.namprd10.prod.outlook.com
 (2603:10b6:910:4a::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2310:EE_|DS0PR10MB7361:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f1ab8d0-ae0b-4511-58c8-08ddc44a3cbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bjVGTUxia2U2UHBFUjZMbURLU1BmNEtVd1hBb1dNR1JDZ0h0bkVTWXkraUVE?=
 =?utf-8?B?UkpVUHRaZU5TLzg1d2hyYXpjUTFETVhET0FVUG9RNFQyZmZNU2tjRGVmUFEx?=
 =?utf-8?B?S1RZN1gwb3dMZkkycE9QWDlNUjFBd0swbjgrNVE3MmVVSXNHTGlyd0JHQS93?=
 =?utf-8?B?UVV6eXl4SlRkeGtRWEYzUXV5c0JvQ0J4bVUxNFp3UFMzTDNiM1ZuYkg1a1di?=
 =?utf-8?B?UnMwcmVRQkxTUnFDQU5ES2hkVU5JaFdFSmV1di9KSEZ0ell5ck01TUcwbXNp?=
 =?utf-8?B?Yi9TQzNydGthei9nWEd5UkFnT241NmwrZWR2a2xCUUZTcE9rMG94a3dwZktT?=
 =?utf-8?B?enRKVFJ3N0hmaWxMUkhqaElweGJkK09aYWdqSXdySW9ORlpwNGJOblZITUt2?=
 =?utf-8?B?RFQvMGg3QnFWN05yelFXV25DSklrUE9TcVF2WUYvTm9Zb1NoL1VDTFhVazB6?=
 =?utf-8?B?aVJNaVZybVlnL2dUQ3RaRmxVZCt5UHhWWUsyWS91WGJ6L3NVREtjSDFlMm1q?=
 =?utf-8?B?TGo1WEMrYllxVEY3MXBJSzRSejFqUm9IQW4xZXdrdXIzVDNZMW9UNTM0SEJB?=
 =?utf-8?B?aXAwcXY3NmdWb0FWSmVMMk5nUUhrMytxOFNqcHYyVlVlUWRvZGR3ZkFNSEdv?=
 =?utf-8?B?VU5kVlFFOGRabXE0T3loMVpOR2pBK3ExZWtqNzN0YUpsRzVnUGpZOGNJZW1Q?=
 =?utf-8?B?UEtjNCtyNnRWVFVMV1VhaDBBSERjRHY1MEh2eWJYcXI5OHBici9FSE9NaWZu?=
 =?utf-8?B?bDlNT01lS2RTQlhTNWhUbDg0ZmpDNUVVOFc0allrM0I1dHZtcVBkZUNWRzRK?=
 =?utf-8?B?Nk4xd1V3bVRGSE5zOXhwbHFsQWc2TytDOSt3Tm40Ry9VaC9ibjVSVjdlUVlw?=
 =?utf-8?B?Z3lpSFNBUWNjaVArTkU2dFBITGNmUGhSUldmQ1g1WXE5dk1JMHBmRDF3V0tB?=
 =?utf-8?B?RkRUclN3SXJWZHNKVmRSMlZlZVA0NDBtNDcrQlNoUHB3WTVvaml0N1h3dS93?=
 =?utf-8?B?TEpJWS9aKys0dVRldFdLR2R3SHMxUkM4WVdqcWw1aDl3T2R6YWVIaitYMVJR?=
 =?utf-8?B?TWY5c3FSZERhY2xZWVAxT05VSk83N09kS05sRjR0ZHIyL2VWVm8xZG11RXhE?=
 =?utf-8?B?V3drNVNYWHlkRFJzcEpRMjFTRG5IRGZRZEx1SFBlaitYT1hpL3ZLS1QzTGQr?=
 =?utf-8?B?ZmxiMFJWVkVyQkZYbEV4NDg3Y2xHempMY01DL3hjOTlVMHRzSmpZMVcveXVL?=
 =?utf-8?B?SmF3cmhleUZRTkJiNWpJMVh0cHlnTFFJWFNSU2hvQ1ZTaEFBQWprNXljNVdM?=
 =?utf-8?B?TjlOZk8xYmhvY1BLMjA4WU9kVllpcFFzMVR0RW5OTEk3OWtnaXV3UXpod0RG?=
 =?utf-8?B?MVJVSFdWZXVVdWJEbVVSeXRZc051SVJ3MU9uK0JyUmJqRzJWMmlBcURBck1i?=
 =?utf-8?B?OGt4MDI1SzRHVjYzZTRlbWFyQlJibFNmcUxCUjdZTFR6WFJSUnhmQWVtVjJw?=
 =?utf-8?B?SGx3ZUpRNGZiQ0xLQlZCemc4U2JaUjYwaytvcXhRRDBCaG1STWVQS2FVZ3F0?=
 =?utf-8?B?MzFKUDlaTllrWmdMV0lXa2ZPNVMwVDFOT3hUbnZUMlVpN28rM29TcmlpdnZ4?=
 =?utf-8?B?ZXJwNG9LQjJZRndEeUlYUk8xMXA0dUt6SWErc3I0aWQ0YkdFOXFXdC9RY3p4?=
 =?utf-8?B?dnNaSFpybFJLblFSVzMxZDB5eUFPVEFhazRaRHlMeTM2TDNzRmlKeml6UXl0?=
 =?utf-8?B?dkd0aW43TkRaajVXUkorNWdzVjVZbCtQeGZtOFNpOERiTUhZc1JwY1JLYkhs?=
 =?utf-8?B?OU9OU2J0MlNqbUN3SE1lcFJUSzFRdkpZSDdvOW5kRE1kWnBxNTZRclpuT0tD?=
 =?utf-8?B?YjVRWW9BOGN0WGlWZ1NzeStWaWhrTlVyNUc1Qjc0OUZuMHhuOUxvOWVXaUxQ?=
 =?utf-8?Q?PI07jrIVErE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2310.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SXo1RGlwMmhTdkZzdDdqdVd4UTdodzJNaDVib2ZFbzVpOUQwSHdyL01ZNVZm?=
 =?utf-8?B?ZDd3dXRIOVdNaDlucXZpa2dTYkF5RzJaZ1ZYL0hIUTZSeXA3cXQyQlpoMTZH?=
 =?utf-8?B?Tk9vNmp3T1FZdW1ScDlRMEdPWGlJNE4vRUhwTFZESWUwNS9GNzNibTI2bU14?=
 =?utf-8?B?cHRteVRTNXhUcGZRUU5QNmVDclpNcUVRTDZEcENzNSs2WWUvVmVWZ0Fya1VK?=
 =?utf-8?B?bEdmeVVRU1BXS3VmQ2orb2lvQmZEN0NhSDFOSXN0NmNMcWdNRVJWY1lneTZR?=
 =?utf-8?B?UFFLZXV1ZVhKb0VDZDkwQTRYSmtCdkErUjMxclRZc291d0w0K1RuRUVpdmFP?=
 =?utf-8?B?VDcyN0ExNWJ5WVI2VXgvOVlNOHpzUSt4UWl5cVU4WlMwTnBtN0FzdzFkVkRF?=
 =?utf-8?B?RUY5bUwvb0VoNHd3STJNbThUekIxd2FZVmdNUXhyWi9QUjgyak93cWlrTGJL?=
 =?utf-8?B?RzIyNmNkSjFzVDRZQ04vNm9kdjl0VmJFTTRCWGkyWXp0a0VWMG01WE5Nbi9G?=
 =?utf-8?B?UDJCWkl3S0Nidkx5VnpwS1BGVjNOY2hsMnZxcnlsOEV3MXNvNHpWNndYZkxl?=
 =?utf-8?B?U1g4ajZXcWx2RDBudG9jU3ZPcGgreUhndUI2VXZwZ2hMd0loOEsxV3V0Zldj?=
 =?utf-8?B?Y3gyUGdCbnEyS3FnUG80UTdVekQwOWo0cGJ3dXFIbWtVYTRFayt5RndQMjcw?=
 =?utf-8?B?ZVBWMVU5ZGV0dElIRXJLdDd6T013dDlZL0JJVGwwUkMvVWFMVVU2TkVyaTd4?=
 =?utf-8?B?bmpwd1VpVkI5cmsrZWVKSEVaQmMxWTJsby9BbWZ1TjBQU1FuZXRCU2tESEJU?=
 =?utf-8?B?WEZ0WCtpQmtPcUk1VU8yeEZnMHVlcXZiL05lRVhpNFY0L0RDWHROdnpDaGlX?=
 =?utf-8?B?VXI3djk4WkE0bXR0QTUzd1JiaG9ucXBzK1Y5ZU5QZk9yVVAvREtYcXNmR2xY?=
 =?utf-8?B?TXJwR0F2QmtpbFVHeGVqMVJGbVJNZjNwNTRRNU1hZmFUTGsvOWJsTHo1ZmQ0?=
 =?utf-8?B?Y2JlT2F3aUZQelM2dTBkS25FL1R3b0hPd1VMcUh0RHRCVkxBbnVWNFovR2RI?=
 =?utf-8?B?dS9TQzRyMlV1NldwZVQ2QmpNdnFVYlFrbjNqL2ZPSmhDZFQwSXdXaUU2Ly9z?=
 =?utf-8?B?Tk5rZVB0dStlSC9MMWhTM3BhNjRvSzFTTmpCbnJBUHBFYlJ4aFg4ZGp4TjdO?=
 =?utf-8?B?Slp3WUoweTRMcSs0ME45RkZuSkFvdHpTcmIyanEzMXNlelJQMU81Z1IxQUtx?=
 =?utf-8?B?TmtwT3kyTWwvbkx5T3gxL0tsYS9uT2h1QjdyeTF3ekpWS2FwdzY0QjVjYm5j?=
 =?utf-8?B?elJRNzl4eDZaSlJ3cko4bUZCUHZBcHA1VkpyQWZKUWRxeGtYR21nUm1lbVFl?=
 =?utf-8?B?T0RQdHRkNDk3c04wVHk2YWlOSzlQaTBwc0RDSXB3bHZXZFFUN2poamY4cFJo?=
 =?utf-8?B?M2diSTFYTTBBWEJNdEpyYU1Cd1hOTmo3UTE1ZEdEREpZQm9KVjBVb2dRL2Vw?=
 =?utf-8?B?SVk0WjFrYW1ZZHErblJwL3JTYVhlbm5ZT2VlazAvODdEd0FUK2w5Mml6Umdt?=
 =?utf-8?B?TjRhUThkMlRzeUF4OFJXYjN0U1lWdnUyb0RlSG9YRUJQbzYveWFwOTNIYjQr?=
 =?utf-8?B?TFhGMVJFbllWeHB6RmVEMjBHamhGUEpKY1J5WU80ME5PVkJSMWttNVBIL2Ew?=
 =?utf-8?B?a1J1QXR4VkhSV2lUeFU1Wlo0c29iVW5MNHlveE1JSCtwTE9wbjNNUDkrcUdN?=
 =?utf-8?B?QUpnbWNMbXpCNXc1L09Kck5ma0htelVHdmdNWTRuL3p2TDdNV1ZRZWIybm9p?=
 =?utf-8?B?WXNjclB2S1lUTTFwbGlMeTF3NC9CZDZ0d0plUkVZU0lXRFQvb1FkRjZnZVlo?=
 =?utf-8?B?dHR3aThuSFNocjRSZmhSbjBzZFJSV2xHb01BamQ1Y0JPMzlVcHJDTThwNUJx?=
 =?utf-8?B?cENkMWJOdzBXWGFDbUxUaDJlM1hkUnllOE42eE0zR3lyTVF4a3lXUi9aT1l3?=
 =?utf-8?B?MHYvZ1pUdTNwMnl2a3p5M2M4OEVNUlhneVdiZjZNTitiN2x4Nm9OTnZvUjB6?=
 =?utf-8?B?cWZBK2hiNGFscVlyVEJYVE56YVVMWVRzdUZIQnczMldRZG1pd3FQbm8zUHVE?=
 =?utf-8?B?YWtBeWFyUlRhMFo1YWJKY3NXbXJOSTJyVzFTWHlFOE96VGltd285dUgzL2lw?=
 =?utf-8?Q?8d1hgGpQ5iDSEpEJSRWI5UY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	I8tqK5A14DxDfd94b13Cm391IYNL6djj74wmkwhxhqaY3Xm9b868TMPBOUxN4uhIw5Aok81n751QI5jvHbcIRth37L96mxLunD43TxejO9F/ZdScPHXyqeZfHrGkAUc6m6cl3Lzq1CJ5W35Ux+UlhbpLwJGX0TA3W1uPYEO3+LywyOoHddfH02WszjaE3EXr32bY+JEmnElGRQIPIj/UbrrflWbRyddY/1cPE2C7/60XtLRnVBHi55nVI8vUTXjBv08OHIbLX6hncOX0rWDT1wLhD+TXyYKuqQIbKHihSakNzRH1SZeAEkm/WayYIV35SdrssAm2RIJsX38BDol8Oww59Pf3yyTe27MOXseiL7+FK/UVh+jsXcm+FyJXSKi01tGMMyQirmp2k1tYuMiR+d8ZtG5mhvsDNC8SKjH/yfW5fq6I1/cu1kDWKcuH1EN90fXqlQaw941kO/NfDBrr70wfPB/xUU6m/95VrGXY1jCqvVd5Qfknk6bGaN/Z6SGF+Mx4CeKHR8mnsID0Y3XxsLZLpDhMVFmvTKbdaOafNbqeg8l1kGFvKp6pvgWIxdfDcdqEdlxaNRBwlwnJe3FTJ/DENc+mCFX4dv9ELdN5Xb8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f1ab8d0-ae0b-4511-58c8-08ddc44a3cbb
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2310.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 09:22:09.0565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EaCffGLxSX/YVUw60N5fFv9rO2I1+uLmvLpvjTG3hMlfU2mkSUlnfFz6sCix7wmzp8mtwvTRyCYWBbqyEibSGIF3pPPHbvBGXnxym6mjinFyaC3ZzMdvUK7mogWSFbY3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7361
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-16_01,2025-07-15_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507160083
X-Authority-Analysis: v=2.4 cv=auKyCTZV c=1 sm=1 tr=0 ts=68776f44 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=XfPcjoVuuVMqcHTMwS0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Jj6QBosh52tFtmmLt8O__DT5LWCDNZjD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE2MDA4MyBTYWx0ZWRfX5rd45VANZDwi cPS1/3XO1xghz4D8tNtYBHGRaruvzPL9cgOb+2HN2BEb4PV/ZtyOytxi3Xn3JPl7YEKvTJOXzxT ynUa3ieOqYfkSWOkvOoVvQSG/eT/HubeuBJg4Rek/X2F7wQ3t+FDzsFY8fH+dZn48VjxvqKnNZD
 BsPKtpaQm5MXdzn2wuU9jlGti7mNcFBsV128c5RmVcofleNUkLXMpIaXMN8zWqs2264Cq/a48cq XG6PPvlKKkfXMQy5UxHEViXakE8b2bLuzC2+pB3Uk3O72OrWOnUq0UkPcX6A1s5uf4BKHO8o+Lv +jVkV5nLXdisXuL0BLLNIWVOdkJF9OtnFjt+3pllePoehv27mA76xo4mjexoi4/2i13pLFeW6eT
 W8gRcsI2mM6vvHdzgYnFat1De0OZ1NpGe4wJ3JmcGtyiwmqFq2aBQIwftu3rE5EDbYioxRNm
X-Proofpoint-GUID: Jj6QBosh52tFtmmLt8O__DT5LWCDNZjD

Hi Greg,

On 15/07/25 22:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.39 release.
> There are 165 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Jul 2025 16:35:06 +0000.
> Anything received after that time might be too late.
> 
No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
