Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42772765C3
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 16:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765990426; cv=fail; b=gKmxyyxydCLuDmMXbS7DkqKSPMfmTNclFs8n5APmg7gC0hs5VSI/IUNM75cEHY9aeds2bpbBt++qkISPUQFpEuSEjbSb1rJGQai8Yd608oejaLTYDv95+gGhW724LaKnBWAsM03i+3NRojhVizfzgLiDkMBrN/pcKgapBI5bSGE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765990426; c=relaxed/simple;
	bh=Etov6h0jxCHbuNgHRpJnAblHvKiPs13LzmFiilD2ZbY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lLlqP7QyAnror38CGxt+xsMWZNIIce/dTvPwZDkTbIlj9zrNp1/DJbdtFaWByQRmxplHgg52mjXWuDJOxPkrDM8TjgqV2otKc/TtKwnL/5rbTHHUhoYmyclfT8AFj8st7PCbxMbvceDMYXxg3zrV1oXy1FbMhWERxRDC0vV60p0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IaURMEf9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TVAJp2qG; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IaURMEf9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TVAJp2qG"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BHFEMKP3025230;
	Wed, 17 Dec 2025 16:53:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6Cg49WyGeN+jlxUnfFOnvtp8LxJKW1h98VYa/n5z7mw=; b=
	IaURMEf9tcwyRrkRELeQHpDi6aH3RH8L2ko/G9YDAkbKoeJ7wnRMeBjPkNoQXhE9
	VzRdCEm3Iqo6sFD78q3DzqYK+z381TKHbqJg72yMR47d3FdlLdPtsu18M3J931Pv
	voMi4iGbnlfLSf/7tGxUzWVV7++a63v4dqS3yuNAH9kciAsvpNNnPOu1rSv08muQ
	27Vcg7ZGOWoPsk1p8XJEbeB9qbUh2X/dOxEAd7/2dew3Zy7+Xrw712YpVD/1RhfT
	uDaMx7XyZr7enjq8POXDxWm1b+V3rTeGfCBfLcshXVs4ongYAa+/jjVcGVXAeSDz
	/MltOW1O7SwAev3oyJVxYA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0yrup5wu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 16:53:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BHFRwi8024838;
	Wed, 17 Dec 2025 16:53:18 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012058.outbound.protection.outlook.com [40.93.195.58])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkbryy4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 16:53:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PI1ZwXMOg/Tqol36FjTdw8gG502L9w6DMvlEcrlUQQKhZLtpgzEPZvf1LNUAzs2dOrc8Y9OmfFdeSWf0R5pKlzW6m3FQTseFsq9NednXYNNIrEf3N4eyGI4KlLTdFO6LKyiSVp7OpsVME3HxeNtA4XzrceK0ZcwravPJueQ2hXYRKGsSsYIG5cPLLyGv56FLMsqMcftWN0GkqSGSI9koOzVbH7MNRnhjyb47q6au5M1PvxouwHCCaQFcrDY6JaKl6bMDcdMxibpJmW6tM7CM+bfDRSQV1EHfQB1sX35IDybIj9wUI5R7YjOVFsUZgZfLNgtYGcPvZ2/6ZCIdA5HlUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Cg49WyGeN+jlxUnfFOnvtp8LxJKW1h98VYa/n5z7mw=;
 b=tnJP3vH2nA/HEXNYi0C2KQhi8E3+csBRcgsosxX+5UND123DBI6LfuKyQ3/imcI426AE2zWzjohXVuzRzkWlrrC9h5zjP2O1r7GHrX73G0WctPHj7ThAei77IFvRQyUTvZjwqracpSVB0iMngyR54OTrgYBTt1jMDhOj7pwoktK7GUD6XzSS+zB2jiRozWkM7tj5cFMO7zTarzcDQH/hiYWnJRYQrggOGTKb68Pe4piil8CmIoTxExRrNws/nVhW0onNnAcFngw6i4pRYNW5RIxl78j/8VWuA04BF55x13HZq7GqVKg1XgNDEEGEGu09kl4sKlRgFKu+o7LMdLiQXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Cg49WyGeN+jlxUnfFOnvtp8LxJKW1h98VYa/n5z7mw=;
 b=TVAJp2qGkOzCDtl5eNlWctSoGY2HjVg/vfH5GknTQ0xylbKuR3gL68ZFb6TAByJbDCbmWSj2owUXogt0TsCnRandV32ehhy8zVS7reKH1eu+JFcItl/NJg2s1GkYDzk0TKNpSw+rhYpOz5715XX2wOxOBuhlnTnG2hk+Ewdif40=
Received: from IA4PR10MB8421.namprd10.prod.outlook.com (2603:10b6:208:563::15)
 by CY8PR10MB6492.namprd10.prod.outlook.com (2603:10b6:930:5c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Wed, 17 Dec
 2025 16:53:11 +0000
Received: from IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77]) by IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77%6]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 16:53:11 +0000
Message-ID: <04d174dc-bc24-42c3-afc2-818f6cab25fc@oracle.com>
Date: Wed, 17 Dec 2025 22:22:58 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/354] 6.12.63-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20251216111320.896758933@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0049.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::15) To IA4PR10MB8421.namprd10.prod.outlook.com
 (2603:10b6:208:563::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR10MB8421:EE_|CY8PR10MB6492:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e9d9df5-2d6d-4575-bd16-08de3d8cc301
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MDZwSi91VWF6OVdEUGxpRUMvZXpSVVZKZ3hsY3Nuc1YvK1RuR0c1MUdtelVB?=
 =?utf-8?B?bkh4THlPWFJQK0pRU1hTUURUUVEwVUVmWVdSeklEWERZSVoyWXVOaG43Ym1r?=
 =?utf-8?B?NVpGWDN2UGRQejZ0Y1E1Mnc2WXcwZFZhMkN3WXVxSGJIdE1KYXpud3VLdnQ4?=
 =?utf-8?B?allKQ3ZwNEwwTkM1ZlNMaE5zRFNWSkp2bGxRL1JoUUM4N2VpNEYxNXlsWGVx?=
 =?utf-8?B?Qk44ZzZmb0hwWWFUd3hOSHJ0UGtxSWhkbndvcmNXdWpFcWhNV28ydGNJSFhz?=
 =?utf-8?B?Um9VNDFGV0QyV1hoTDNNWmdXcUNOeUdoeHZtOTJ3TzExOHFLb0tHekNOTFNU?=
 =?utf-8?B?enVLUnV4RVlocUlYek9jRUtTVTIxWHRvT3VxTG40SWtMRG1DMTc4VHR4UzdN?=
 =?utf-8?B?MndVa1FEa1FTUmxqNGdCYmFLR1p4b3l6NGhvaEVUMUpIWEdmV0pOK1FFaHNB?=
 =?utf-8?B?cnpOYU1DWm84VVpiQ2I3UWZNeTFCUVdNYW1JQSs2TVVKMXVQNGI3TWE0dUI2?=
 =?utf-8?B?RkhQUDdHbHVaL003dEZOTzhnaHV4KzgrQWhZWkM1NXJBRFdacFVDcHRkNytT?=
 =?utf-8?B?MlNWQW9qUFBQTnZiay9Uc0dSc09iaUZ0QXplM1FlVW1raWJwM09QOG00VllS?=
 =?utf-8?B?dTBPZmo1dGV3YWJhNFhJNU91ZE96dFNYWTI5M1NJeHFnTjVLekkxR01ZdkxJ?=
 =?utf-8?B?Q0djbnlpNlhhUzdLNitlazRHWW96TkRqSmtKdndBdmxGSHNXcXpkNFVZUnQr?=
 =?utf-8?B?bTE0ZGs2VlRSV081OTczSmxHODNaN1NVYUUvUE9YS3dBcGZkaEgrWDVoOTFU?=
 =?utf-8?B?N2FmTEhEeEdNYUk4dTdvMGYwMk41Qll5WGhEQUFQbElOZlBOMjM3UlM2bVky?=
 =?utf-8?B?NGd2cnZxdHdXTmpwNHcyUGJUOWhpUVd5anFSUGdBS1J6SCtLSEJzU1NBWExq?=
 =?utf-8?B?OXJaK3Y2UGdYaExEQ1YxdWN0eG9uclZGLzNiNTlSMyt2Y01qQ2QzR3FRbXdp?=
 =?utf-8?B?THVMa2xidS9iazlzejhTUGYvT2xoOE1TZEhnRy9EU1ZhMVRWNUFSUnBnL2tk?=
 =?utf-8?B?dUF0OXMwUmxGMHZaMUFjMmNRYzNXditwU2NDV2lpVWdvbW1xNDRBem8yVDY2?=
 =?utf-8?B?VXYxWlMvLytxc1BCM2F5ZERURm1lQmZ5RmFvYlp2aUZxd1dIT09PKzBjZGdQ?=
 =?utf-8?B?NmpuRlI3ek5EVnZOc3RMcjFNTGZjNDBEK1VOTUdxWktGRllWcFh6Z1JxdnJl?=
 =?utf-8?B?Q0JraWtvOWx6M3Q2YjVxbzc0T08yVW1HRnNSeXFOelo4UE8zMXBHTFozTjJm?=
 =?utf-8?B?dEVscDI3dk95WkxLN2NEOUFZcHgwa1RDUkZvV0VETGtsaU5IZlErOUg0d0dG?=
 =?utf-8?B?bzdra2UxTlBOUjNJV1JtN3hZSEkvS2psT1pPK29ibGZkSGM4YVIyekVkak1w?=
 =?utf-8?B?YURycnBnbVFCMTFqYVNOUEdSZVRJZE5lNmFFdnlRQUh0UFY5dWc3eEJOT0FF?=
 =?utf-8?B?cnVRUzJtUUJXSGs5M2RNdGt3bGkxT0J1aVMzZzNEbDRDUUd0M0RtN1RnNkdZ?=
 =?utf-8?B?YnVhMy9ORm9RTkFrYkd6STdkaFZmeWxjL3VkVm55Yk1ZQ1JlYlFFQnlLMktq?=
 =?utf-8?B?M1AzWFJEaitKYlpyampmOGxoSHlqUTEvako4d2dtQVV3aTVMb2UwVm5pVkVW?=
 =?utf-8?B?RGY5Qm1nTXF5RUY1T0E3dExjOEY0MmdDc3JucE9sdTVabDYyVVB3RmlDYXdF?=
 =?utf-8?B?ZWFoTmUyQXNPaG8zWmFwOTBUTTZYWVZ0YjI1aEYrQjczOVdKblJGZUVJT1E2?=
 =?utf-8?B?WERpSUJBQ3E2U1FKbmlLaDBuRDdLQ0RMMnlBMXZDSWZ1akIwOEo5SnhBYU5k?=
 =?utf-8?B?R2xpK29zeHNpV1YwbmUrYzdDMFpKOTROdWN2MklMcEFEQTQ3dWxKS1A4NWRL?=
 =?utf-8?Q?lVvMxeTeh5Eg/WLknE4HKZOXUCyFdGNz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR10MB8421.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZmRsVU5oNEF4MDlEVGE2QzM0OUhPRW9MQ3hmYzBIWGZwdTRRdk9TOW1rK0Rw?=
 =?utf-8?B?WUg1MVpucjNLdjBqUlJjekNZMUJjc2tULzMzcEk0VllnTkpUbHFHU3FkWkVJ?=
 =?utf-8?B?U1V3empjTDhPZ0w4c0FQbW4xUXFVZ1FXZHJxczhEbHkyWnByRWtoTFRVRm1C?=
 =?utf-8?B?bVd0aGJYdS9BRXNwYmR0NHRNNGFZQUdCbkQvbUcyWXhLYmxFRGpIRk9qU2Jy?=
 =?utf-8?B?ZFZNa3dIVHlBa1BZeldhMHV2ZVBZdUZzemVaNlB2YkdnQkp5cmdUWWM0ZnpD?=
 =?utf-8?B?eU9OMlBycEkxOVFxVVYvU1JFdzRZT2swWWZXQTNsZlFJLzFKWVJnMVdjdnd4?=
 =?utf-8?B?WXA1UE5tbHZONGY0SElFZlAvYkxzVS8zM2t2eUJTYjRGdnRPZ0NHNUs3bUk5?=
 =?utf-8?B?WjBEN2QzVDcxUWl0Zjd1cDhkdmNCNjdpMGg5bUN0bG9iVmJtWnV4d1NtUXFZ?=
 =?utf-8?B?MTh3SXlmeFl3S3dWcEh2QjF2UDY4N09laTBReFBrNUN5a3pNYnhiS09wKzRZ?=
 =?utf-8?B?eUIvWkVVVzBMT3J0T0M5V3M1QjM3SlJBdm1pTWU4eThmQ3hMUE9sMEFTOWFW?=
 =?utf-8?B?SUhwOWZvVTErSWJ4M1UyRkxwOEFNWk56SGdYOGR4Znp2NXJVaXVZdTVCb1A0?=
 =?utf-8?B?TCt4YzZlR2pJeUhQSkpSWThDZ2dFSGc2ZnRIUGJLUmh1Q2F1NFhGVURST1Ew?=
 =?utf-8?B?Uk1DTXJPZ3plUmlhTERIc0EwUG5XRGluSmFrdjUvTERUcHNUNDlaMTUxRFJB?=
 =?utf-8?B?OERTejJ1eDdqTUd4czB0RWFLek90bGw1V3BEaVYwbHpoTkYxOUFPZVRYdXph?=
 =?utf-8?B?SitpSjRiTmV3YUtoSVVZTUZoa0d2RldpTEllVUhyQTNtRy9BT3h3ajNaNUsx?=
 =?utf-8?B?TEtXaVhmMGorUzRObHVhUzIwMW93ZUpiVzdEeFhNMXdTelRtd1pFQWFkY3Zu?=
 =?utf-8?B?d1o0TEJEZWJ2azJIcWlMRkRGSlRvMml6ckxIQWJ5SjdOWG8xSUtLSTh0UkZV?=
 =?utf-8?B?RnM2QU1XNW5zQlNjODBCM3BLZHVlMVVXbWdWV0VQcTJwaXhXNTBBYjJXcmJu?=
 =?utf-8?B?WjZrb3dLMUJnZlJ1Nlk5YW9NdEp1Uk5yZklpbTJiMDVsbXNqOWNjdGpLenF1?=
 =?utf-8?B?NnBNd0drZmVrR0RBUkh2cXBISXlKT3F2a2E5dDRsaCtwNG5XeTRYd0dOVmN6?=
 =?utf-8?B?dGR0cS84QzdaR3d5d1FsZFZ0TjBWWG9yMzhwdU8yUEJTd2Z0MFlLZDE0WU1o?=
 =?utf-8?B?V2VOTjAvc1kvaTRIbFkrSjU3MXE0Q1BhSTFUUUxaTWJuemdkQ0pIeXBjaGFC?=
 =?utf-8?B?VDhDN1I4MFJEdG8wUm5ITXVzRVkxbmF5ZlFDTDlTd1BOVEJoYi9kRSt0VDVJ?=
 =?utf-8?B?K3ZHRTlIZllOcEJpQUZkLyt2THVqaXA0blp6Ti90SnNwWDhRbHNYVHM1R0ZT?=
 =?utf-8?B?VGl2OEZSaFFaVXBYZmRXL2pmSnBHQ1ZiVE50cXpzZWtDL0l5aTZEbzh5Y1Ju?=
 =?utf-8?B?ekRzOHhNMTBWWlpNUlZlaXhvbkRTK21lOE9zbzF2Y0ZocFJjZnZlS21UYXBj?=
 =?utf-8?B?RFBTc2YxUituczRiaEJreUFlZUpnOGpTeW9Na3pyRG9BVlUvYjVlajd3Y0RT?=
 =?utf-8?B?dDQvbTNHZzAwb3htYXR0OXhxVFdYZ0tJSWFYQmhLdWovbXVhUHVkdFhvNXhp?=
 =?utf-8?B?U2tUdXprejBOaEczN3I2bGtqUXhyQW15TzlzcTFWVDZWVTlsNzRxZTVqRHhm?=
 =?utf-8?B?Wkc2Y3VIaEN6RW5ra3hVa1FqUFNYTXFrTi9WOVhPYnhocmxiYjdOaVA0blpI?=
 =?utf-8?B?Z1pBQzY2aDgrTFVoRjR3Qm1EbC8yTFNpZy94clpycnlyNGptaURZWCtyN2tH?=
 =?utf-8?B?Q1FrcTJOL2hHdjRlYkFjMWlrdXBOL1Y0RlZSTmhJdHBHUitWNlJaSGJDUjNn?=
 =?utf-8?B?ekNuZlBobDhuaXZKelFiaWdFcmlBY1dTRHIrUEYxbzF4RkJBVTdEb0JsR1Jv?=
 =?utf-8?B?dWlWQSs0QkVVYitqK1ZGU3Q3OEdxd292UDdnbElvVW5VNDhscHJDdEkveVBk?=
 =?utf-8?B?alo5ejZFYTJHSUl3dEVrd0F2aXo3UGcrMU1TTGVVMmswbTVmMjhFQU9LaTJE?=
 =?utf-8?B?ck9SSHcyQ1UvNEQ0VzNDVHg2dHgxUXA4SFcrbldGOUM1STI2cnNtN0ZKNE9C?=
 =?utf-8?Q?D4LdqzOOB8SWyRqCDn56zME=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bLDjPsgh4YN73HJoUQ/vY4KhgUgnwKT+1V1Tx+DHtPBoQXuxsjbjY1xRJtoyNHLNDLESWZWlmeKcFMlxmaE/gc9PUwja41ab7ziS5Je6e6iUf89WuuYJ/z31xVEC8+ECCOdILSR1y3qMZk2bhOKVcn8N6tUPSjj92dG5PbBsrwh/KzOOR/JBMjUnaRRX0rxMLUpQVMmmc3EtHam/6rr+3Niqj8mkkTF3lbIC4jpWE80fuvsZRx5QvMPjrBY6q+ZxbWYSR+QAz7IKPrj14tu6eqcsxMUpj1UDG8t/pyGi2KSxEI+M4AbudBhr9kCDPuC9lS/xWsEoLtMjS9FzWWRMUZjSfKBpZqZHxbq/c9ikmYT51CIWqpC+y0iUYpmyF+T2wW/vsW5JOx1EWOXyTK65QRZt5vLeVGCdwOf3Xg6xxXCRVvlkvNGIFLDYsvMVpWl+JaBWyAKVcZZ+sGvPgn76fXZqu4QR87y17aNddUYjj9Ry2+Rcrfi+IEDJVJ0uDl2CillcykziRiiNX4L6hEhe3Eb5c917qqDyw44Hj4Vnd6o/9DyBYWcUBWSiTHyfn+I5CUjiZf4PehBlKUZg80TG8urEApnzpaCxBRKh3e2co54=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e9d9df5-2d6d-4575-bd16-08de3d8cc301
X-MS-Exchange-CrossTenant-AuthSource: IA4PR10MB8421.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 16:53:11.1059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tILGiVlTHK546Kb6NNoCynDtWc6SLW0lXxNK+ErbE56MwjsqK/l1R4fN3CcEu0Wk12X09dAv5b+LEHHpma1RIf316POhmKydSC9IkxNK6VtbRFflENxqDa8lhe8QWoBg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6492
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-17_03,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512170134
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDEzMyBTYWx0ZWRfX7QTpUCx7vmJ5
 ma6JK+/ntt1F07qJaAKyc/7AZvLkh040mamQXbkKDCHVS6B5cOl0owT/+fbfzp8C2ceIDLBzyxC
 qy7UVPNDWsvdXdMEcOvjmZoKnwIPE2n2SpNhq1tGw9lA3AoZmNG5OJFKDZK13kNtOY4cwQPbmlv
 fWsT9VlhU/TTVA6yFegqTeXQxzLOqIHDvAzCGzwQ6cRV7t3ajtSCglyBf6HjMQP7XDwXEZUrtgG
 Zk1E6bFFEJNf14d9PISzL1+7FiL2KsF2jYKqHRLyaZV4ysu4RWLxxyAgd68Z1SCkjbWEYreh6ch
 bGTdu4AWCN2BypyEi8lDU1BUL5VwMBCCZbvHYZ25Gs2zg6Jt1A2WNVHaatKvrmT8OZerAYBmOFB
 xckFlcUZd9vdrYPSFbJx4Y3qiXW2GA==
X-Authority-Analysis: v=2.4 cv=TL9Iilla c=1 sm=1 tr=0 ts=6942dfff b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=shKLvg-12WSsmoj5OQgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 8a_B42yHWaikcnfyZMfX_Kz-qkoS45ge
X-Proofpoint-ORIG-GUID: 8a_B42yHWaikcnfyZMfX_Kz-qkoS45ge

Hi Greg,

On 16/12/25 16:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.63 release.
> There are 354 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Dec 2025 11:12:22 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
