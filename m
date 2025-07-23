Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD27E2DA746
	for <patches@lists.linux.dev>; Wed, 23 Jul 2025 11:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753270549; cv=fail; b=bK0aCrUwi43fmlNew/KyfPNSgjhKvypEZLbbbrkZrH37Egm/pDnvmoDPnlszuN0taOXwcKh3LGNThQCRIDkGsEy6iEBoHqPpPwsgET70B+EbR4U7zl6xD/QyxEPJ9oKktt3kgaMn49MNeYVRH0qOXESOAzEUXF/OncCmAMxqUfY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753270549; c=relaxed/simple;
	bh=0ryDxZgC87s4mKV26pFtVb7AMz/5U33CmmpIq8G4H0w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=O5HO53obTVCPOMyHDuIalkfpAhug8VcV+AJ1ITduVEkephvZPlrRxFJb4Irz8ReNCY0AFRF1vMc0dddikN7TvZOsJyyaGjTmunLVuE04nMwqN/yHGm5WxQ9UOrQx2GyJhAtHk05gfr7REz3/L4NPr+bcf9GHF+rvJmN6/2BEbus=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PDPV5Wli; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=v2Uuwy17; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PDPV5Wli";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="v2Uuwy17"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56N8NPsj000481;
	Wed, 23 Jul 2025 11:35:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1+TEVoFUSLuvwsq5ZOJ4lvnF0yJMuVbNdvyQ74aAhBg=; b=
	PDPV5WlikL2keFcN+bLKt/1uFSWTTnyB81hoQ4WBl9XVEq9XzW9vKYvOA8dgSG5s
	u+A5osTDsELrsN28R9BZ35ZGy7NnHAGJTDpMO4jIdcedYJkaRek1ylke4bFN+BVI
	bGw2iVaaRSTr/qdT76o0w22XyUt4UJK4+HawBeiby0v1/6Y9wZzpP1Ps/SDATij4
	wZdu0zWGs2rBSS74pf4l0PDtthrez9jvQ7rcyOXe2NfKzmkrTTv04nCBEeHRAVef
	WcIAaI3S2CRX9WUAEYO7WSPz99gvTzIjrAf6GAhQOcDaTFmFwWpthf65s60QtKSx
	bjnlVGu+sOoz8ZN3CqH2wQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48056efafg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 11:35:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56NBM9f6011037;
	Wed, 23 Jul 2025 11:35:34 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801tag0u1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 11:35:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E3amNRTV5cACTobH4FgZWk9cD+NQrUV1OYFoq43lU0NpZSpdlR68aQpvjO0i7SvOS+xgpAK04C0Z9TMRqjOx2HJF1wgz0UnuZQA0kRJs96cUjMVnQh/CnAGVnP1v3UEVzi+OP2+UARegSuMioJJiE5a4BkLDJxEWtA4reHzKdMLsw3D77Lbpj5pczyczVMmjXmw7I5aAaMtz+ZCheE9is/bpeyQVOH8V9iR7eOzeEiV77J26zOBa/xpUFE2VNTfOSxSxKvcRfwGzr2FIGmu3N/Eqfmt+7+ZFK1pt+ry8fg/wT26GFw4kW97UFUcH2Y+zVH9OAJxnpSxSQ6qO/G7X9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1+TEVoFUSLuvwsq5ZOJ4lvnF0yJMuVbNdvyQ74aAhBg=;
 b=I3O2mdQbLuzTAMFGEeDJRkUwr0yiYudbvDUpucM1nhA+a7DRiaBWII0KGU05frm8zpWmeMW5dsujhUXWy8IoTyVrNIANS2zy1k+v6KEP7Aq6oBQDOZ0pMdt8lxLmFDdio7akfZ/dZPMAiGrIfgcaYOaltXWqRxu3IR85wCCkPO83ApUC22SlBO278un/LdRVnuoXbgRZ2eJLCVdVYv4I7qd9TWFIp7PAbKXnOo18+hzGCdfGUK/9NRVGfwjZCqbHWeJsmIEkF2C8bCJHobBUM/gakTVqgs9eXGpRtlmgV7cW1Zy75YQYzdqIocydvbtd0HXci6CKiUi5lI2LSbvRzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1+TEVoFUSLuvwsq5ZOJ4lvnF0yJMuVbNdvyQ74aAhBg=;
 b=v2Uuwy17QXOwh2FBfEtH7P+QKN5grvK08znv6Zwe6v4wFgE5vQbb5cQZFRSO8CX5B+fN9e0zQO44BWnPy0+X6T1HPQob31tnpCp++36TkoQivHfdQZh/YfdNyaFizOYwCmyMPSdQZqGkQ8XJgjfWF2mC2XBTVPN6Z3MhCvTSZgA=
Received: from CY4PR1001MB2310.namprd10.prod.outlook.com
 (2603:10b6:910:4a::17) by DM3PPF00080FB4B.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c04) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Wed, 23 Jul
 2025 11:35:30 +0000
Received: from CY4PR1001MB2310.namprd10.prod.outlook.com
 ([fe80::5661:9254:4b5c:3428]) by CY4PR1001MB2310.namprd10.prod.outlook.com
 ([fe80::5661:9254:4b5c:3428%5]) with mapi id 15.20.8943.029; Wed, 23 Jul 2025
 11:35:30 +0000
Message-ID: <22a31718-7501-47ca-b65c-9ec2ce740263@oracle.com>
Date: Wed, 23 Jul 2025 17:05:19 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/158] 6.12.40-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org
References: <20250722134340.596340262@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0218.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::10) To CY4PR1001MB2310.namprd10.prod.outlook.com
 (2603:10b6:910:4a::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2310:EE_|DM3PPF00080FB4B:EE_
X-MS-Office365-Filtering-Correlation-Id: db6bc28c-7d80-4435-9f5d-08ddc9dd074c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R1AwMnRHME1tSVpUYVBZWGpjUFI2YlZxNDNlcUk4cXBKeWQvdmozb0lGM0RN?=
 =?utf-8?B?c1BhZUV6bnpHUmZkWlZWNTd6RFB5TWpKeVg3dEt3WGswQzBkTnArWHUxV1Fl?=
 =?utf-8?B?L1BpVDU2Qk1PVmcvRHJPMWRNamtmY0hiUkZ3dHMyUDBWODkrWWpVMkdRNUVO?=
 =?utf-8?B?alo3ZGtHanpubUVUVG1kOXlKcU44RjNkTCtIM3hMVXpmRE1NeDkrcU5IemdM?=
 =?utf-8?B?aXdWb0pUY25hSWkzd09mQTljMTV3Z2tiQXc5TlhCaEF0VDNZRmZkcUZpUmFv?=
 =?utf-8?B?V2FFSjVxdXY4ZEFPVk9FU1FuSGEzR2M5S0owd1o3d3Q4cmU2WkFFNklGak5x?=
 =?utf-8?B?elYwSUZWS2txU3grYy9qQ1h2RFpSREtyb3Q4QkJSTXJNY256Tko1WHp2aDVT?=
 =?utf-8?B?cnBWUUZrdzVXSlh3YWtDUEpnN1ZJVGxGTTd1Z2Z3dHpRVFVRc3k3VG1ESGhR?=
 =?utf-8?B?VHNUekVTNzViVkhpbUNRaTB4eFp6ZWZQRGRGazJMZUphSTdDb3BFMXZGV0Fi?=
 =?utf-8?B?WkJGL3NhNUdhcjBxYWovNTZ0dlphNjVPZVR0U3Q0bEU2QjJWRDN2WkIrdTJN?=
 =?utf-8?B?YTlFQUhaZ0tPdVNzRjZ4SHRKNDdJZS9qb1k3dGVvVjRqeEhDSExTV28yZ1Ev?=
 =?utf-8?B?VS9kVGpadEMrdFNBY0ZMSDRVUTBQTjA0S1d6dTdLMWcrZVUvSkwvenk0YVM0?=
 =?utf-8?B?RE5MYUpUZjdlTWdiUGhWQ2NmeTFCdCtKQVNZU0xxdUcwQlZlYmtoc0I4eEFy?=
 =?utf-8?B?ajVMWDJVSklxTU14Q1hoaDdUQWJkZXRXSER4M0tUWjJqaEtzN01xWWxRUWMw?=
 =?utf-8?B?UVJnS1UxNFJYSjllZ2Vya0RJak8zRFRSMUNNb2F5d1ExaUVoNzVGUElLWXBu?=
 =?utf-8?B?L0tEaWdEcVRSZjlIUzE5aDhKZDZCaDIzaDlVMkV4K3pCRDlMdVdLNWNaZWlZ?=
 =?utf-8?B?b1hsRnRnRmJMZ1g3amUxQWRvQUZORHM4dGVlQzF1RjF3VytPR0IwbVI1dVBZ?=
 =?utf-8?B?cDlvNTZzWDRJUHA2V2lKTCtiMGZadkNqS3UvcDZ5Q3dSbU85d0JxSGVYc2s3?=
 =?utf-8?B?K0FjQ2NvWExES3BDbXZ5b09rVWd1WnFuNk9sdDFVeHZHK2t3eUh3UWNpRDRl?=
 =?utf-8?B?RmwyZ2d2RUhoN0Y2dUVUc3dOUTlYNjhtYnlJdXhhNkFBVm55SG5zUUtzSlBH?=
 =?utf-8?B?cE53UGM4UkV0RE5JckFBdTZHY0ZieHl2YXpyVnNZd25kazZBMjAwS3c1cmNF?=
 =?utf-8?B?OWptVFcvWmZrUmN6dXNVZHJhSWM3UUVDSmp0UUJ2SE5ON1JuZzJ2ODFPa0ly?=
 =?utf-8?B?eStYTlRobFpsUk1RZXNadGc3eGU3MTZiQ0dwQllUMStCcThuY3ptSDdzLzk0?=
 =?utf-8?B?bE9MM3cyYzlYd05PdTdDekZad1R2cFpOZ3dpN2k2VmpYWWRacWtNeHRqNWJu?=
 =?utf-8?B?WTJrd0k0QzZGaTV3cXBBUU9ydkE4ODNWVzVZUWhueElXZElzY2FDa0NOcWkr?=
 =?utf-8?B?UHMzSDVXVEFBYVN5ODdHUkxMTnFFKy91bGFpL0hDcytWcHlPdm92MHNmbzZI?=
 =?utf-8?B?bEZBUVBOUHB3UkZMMGt0L1JrUlppbEM0dkRRZldUL0JhRDJsUDVoc00zRkRl?=
 =?utf-8?B?eU9FL1VWa2ZFLzFoYUVKNnNGTnlNMDhaekJGa29qOFpXUTNyWktlRUlkNjJY?=
 =?utf-8?B?RkkyVFJnV1p0QjNqN09QNTdPa1l3aCsvdlJUcWlhZXl4a08vTDcyV2hxdWNx?=
 =?utf-8?B?VmZuZmhjUkZaSllnZWc2eUxYL3RmUEFUUnBnWDNqbERYMnNGTzUrN0VGekVH?=
 =?utf-8?B?TWNkZFQyUTYzUUxSQ21Obmp1LzlYRDhIUWVVMnVQdjk2b0V5Q0Rrc0RVZHBp?=
 =?utf-8?B?SmVyaER5L3hYdHhkSFl0Qm4rS0ZRZGs1Mzc2dzJCM05WbjIzQ0FlUFFmT0lp?=
 =?utf-8?Q?aMbvedzQCxc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2310.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YUtrdDhTM1JONUxPWWZyVzVDMUtkZzh3azh2TXBPelFHTS9NWVdYdjV0REt1?=
 =?utf-8?B?MVVWSG8vTFp3Vm9vWTY5OWlic0N6YlI5NHU2dnk3NUN1WEsxdXlZYWRIa2RT?=
 =?utf-8?B?UHdmVTdYeHFQUWxid0M3TlQrS3dsYjN6QXFZYXZHRk1RVmJ0QkEwblZGdWFG?=
 =?utf-8?B?eUZ3djdPcUEyY1paU2lJS3JHQlBBdGVQRTJKbTB3QW5BYW9QQ3V1MEQyNi9P?=
 =?utf-8?B?dVk5YURaRkMzY0lYQjJ5amR6czJkeE5ubk02SUY2SUx0eVo5cGJLTDA4Q1lk?=
 =?utf-8?B?RU9RUktCbEdsSjk3ZDlpcVhhTC9TeDhmQXpzMjI2STlwOFZzMEZvd2k3Vm1W?=
 =?utf-8?B?Q0wvT3d1dnkzS24wbDREK2NyWldNczUvREp6anpNbGZld3RpMGZOMkM2d2lZ?=
 =?utf-8?B?dmxhaWdRdkFLRk5YUngvSDZabkFSY1hLNjdrY3Z6Z2pyVDlGUjk2OFVzQUpK?=
 =?utf-8?B?OHdQMXhDcnpDeG5XazkweUNrN3Vrb3M0Rlk5d1V1ZGpjbXgwenZDYnl1VGNv?=
 =?utf-8?B?aElwSXdaR2RaN05LZU1hSUNPS050TU5aQkgybmJ3ank1S2Z3VHoySFpvNFhH?=
 =?utf-8?B?MEVFRnI0WFB3THc5QjNaK09EcmJ6WXdDRnN2ZU50QlIydWJEL0dzSEJuZ1Vm?=
 =?utf-8?B?eVZtSXpwQWJaVlBYS2Z0VGVWNlFRbmNRVTBRd2E0UkkvUC9tT3pQMnp4R1k2?=
 =?utf-8?B?dFJJUDI1cXFlcm0yWlpvNXdFWHMwK0d6NGpKazd4akpkR1BWeVMwMVY1WFkz?=
 =?utf-8?B?ZGsyWTlGbHdWTHlWYk9wclk4YWgxSkhFVTlXZkFzRDNuNjBXYzlFd1FxVDlq?=
 =?utf-8?B?QzBXVWxPeWl0S1lsdFRrL0JQN1RZM09abFdoUkE3anNvZ3k3MUFMUFhnNHNs?=
 =?utf-8?B?YTJMTXd5a2NpdjBUeEJrbExzaW9YcGFRQllVVjRaLzVHd2ZhazhDSzJONG9E?=
 =?utf-8?B?QUlzWW9KMzJTbmo2OWFFVXZZOUpNREpaVXJULzRsVFFtRTRzbjhLcFBNVi9a?=
 =?utf-8?B?ZTdaamdOUWJFZHhoRzlFdjZaMVJ5ZlJrOUNKUFl2MHB0M3RhQVp0a0V1cjJO?=
 =?utf-8?B?eCt5TXNDTjdwcld0TXlqcDhPbllmNkVob1Q0eElTbVlaSUxoZVF2NU5mS0Jt?=
 =?utf-8?B?ZGtyNGdzUDRRT2MxUE1EbzYydGRBRVZOdHduSUcwcklGcThYOTdpbm9pYnh0?=
 =?utf-8?B?K1lnVm1Ta2JJWWVWaUlBeEVpQjZQMmdEczZsOGZSNmVRMy9HZERHcHkrdVhW?=
 =?utf-8?B?aVlBanhJaTRMS2J2UDQwQUU1SGZDVFFHMzFrZHhBcU80STJNUjRpdEthM2JN?=
 =?utf-8?B?ZnEyY01uS3VrTllVRTN5Q0VNU25XWVBwLzFxNG5HSVg5RGNUVkpoUXl1ZTZU?=
 =?utf-8?B?VHM4MkJsbnIvanE0TkFkOHJIdHZwc2dEQnVDK0pIVTQ0cmI0aUx0UGhpcDFy?=
 =?utf-8?B?SzlCdEtNWUNYcHc4QTgvNk9haFJDTGliRnJKcmZQT3pNT2lwMnVxMlF5MU4v?=
 =?utf-8?B?Ui90d0xWR2NDR2VFY0ZqMTQwYjRnbXJacUkvYlVtRWdraTVzeEkyb1lrZDk3?=
 =?utf-8?B?MVRwSHA1VzAzZnlUL1VlREtSOFJFZS94cHZqMHBnTlp1MUdwRmsyUzlrOHFS?=
 =?utf-8?B?eGFRUmh5aXRqdGJYZkhpUVcyM2h3L09HcU00SjNUVktpMzlKa3NOMi9TMm4x?=
 =?utf-8?B?a0d4MXhqaEppcHk1ajk3Mm4wSUUyeXdsSUhsYkNxWDRyeXVqeC9nQ2czWFhs?=
 =?utf-8?B?OUlCRUo4NXdyVEgwM1JrSHNZNGp1V0lEUWpoVnlOQkhwcHc1ZE13dUFhaDdk?=
 =?utf-8?B?dURadTNEOWlwYk5aYm1ycGFNM0VIWXAxb0wzenl4elhmcTh2ZnVjUDFJTGpL?=
 =?utf-8?B?YWpFUTdIdTdPVDFOV2xDb0oyanBydjZMQnRtS045VXhKYXBubmgxdmMrUGNT?=
 =?utf-8?B?cVc1aGt2VjlrQjBPUkUxcWFlVzBXSHNMYUU2Szl2Z0NoeDlaTWxXQTZjTEh5?=
 =?utf-8?B?c0crY3VaMkNITW5EVjhMamNHSjdLNXA0M25oUWpEcWxhanEyaXFXM0IyMENH?=
 =?utf-8?B?a1V3ZFZjazhxZE1hdWlRNExVdytXNzBvYkJnQkwvQzZHRzVBc29ZK2llZ3Zy?=
 =?utf-8?B?SXhBYVBGanFnVUFQcTNuQm9jVEtGa2xidkNTZGlIYUlNb3hPaUsveWhITmpu?=
 =?utf-8?Q?H8eatPPosPKYSpdzDNKptM8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Q9LR7CsC3bF6p67sAUj0jNkru01XU58WfDcpNaIcNs8mNk6mRMD1ZuNbmN0JTcelLSflLyeDBECnv4TDRmV4ZTvo7LS1oHkXWBv/+VZ57gaQcqEZm4OD8JAnVVa0UiBLQFdR7PT3JvuiSnT01skKs1usOWtBcByK4TWHk4gV92sGUyD5aeb62DYvD52GwHJQioaRP2u4hLvEboZUC2x/WvJRoOF9bnE8mMS//w+cBiLA6M0+8tZvkv2w7oK4sYw9rAT2fpGTAOa1jCQT3DGqhMcnfJwqf04Pp4AcDd+GG09yD8J8sAGd/X+aHM1ltweHNEETyP5+FQmz7pWAutx2Hx9Xu7m6isDDrWoecaxLUOGKkAq7lM2UQqyLVQJA6FPHb8v1Mz6dtDu2To4DYiTDrf/CYZlnnhQpY32h9PngX5djzhHj6nFi3cMbLT/7L0zj88LgwyvJLmOwoPgHqi8a2dlwEfctkTgEI5NCsZbA1cx2qz52LQ854Ln0AbqTpTYfg5rdTorJDCCLEcJRWD5DrfHlB7O2JCHOpL7eyRZOG5t8j4uyCWWZysFl0KDFaN50LTqOA4/WQ+CjegNgNcCTXUf7G+1fhg10P3/G4qAG5/E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db6bc28c-7d80-4435-9f5d-08ddc9dd074c
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2310.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 11:35:30.7081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VIsJ5CURuH3ZxUMOqjM2/k7cVuXojfpo9c+w/PgyCsHdVbDDNiLXLUoY5N9hlDvt+DAk8oDPtPvwBErHYu4e4FOwc49TRfkxfClgc5H7sw4ne/ETmjlgZOWbNPvfdIjN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF00080FB4B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_02,2025-07-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507230098
X-Proofpoint-ORIG-GUID: L7m9CU4xWj9xJocwUov18EZ3-4AaGmlf
X-Proofpoint-GUID: L7m9CU4xWj9xJocwUov18EZ3-4AaGmlf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIzMDA5OCBTYWx0ZWRfX/rNXOHlcfnfH
 IrnmQWC9+TXHf4v4pKgWQ4N2Gnia2k0inf+Me2I5S8u/PYk5RgMJ61f6QXJUkd3gOD5g34OCDYQ
 JUp4UUhqMwGl+gr6EzeMzdrDZ5AzzWZQrSLpuDQGUMOV3NGYWdNijSVGT3SiTH1x+PcBb+g5H+k
 unC+YBWSkvkIJfvg7/RsaasSsOl3ObfqloJgPI/T9tPaALoz/klLZqSjp10do3z1JLYmavT5fAF
 ytA8aGvAT00t8Gb0BXYdmzFPuXMcKer40ICVQDDym/mvX9bMjIku1jbOX2PgyXcgtOWJrnuFHld
 0FVLoOep0L2lruDR0fnvHcEGcdBCaRHGgzzcV4GpNhDBFIh6JjoSPJhGneqAKXzXAk+e0FQCs19
 Cex4SFfL2etdlfp+8z+e0ddlYw2Yi6eAfU9rVsr6+lh7KfAKqh8LmRVKLq9D57ENeQcmP2ak
X-Authority-Analysis: v=2.4 cv=Ef3IQOmC c=1 sm=1 tr=0 ts=6880c907 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=yPCof4ZbAAAA:8 a=Xq6WveWaWgIdxh7GAcgA:9 a=QEXdDO2ut3YA:10

Hi Greg,

On 22/07/25 19:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.40 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
