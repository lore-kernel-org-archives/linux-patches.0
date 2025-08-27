Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC78258A
	for <patches@lists.linux.dev>; Wed, 27 Aug 2025 15:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756309644; cv=fail; b=MK7Cne9R718oBZZ/eOBoYkzOCnrJ7ptABc4zVGDXtQJ0ZLKeH76X00SkP0OlVdI7e5n6l7X+Kd3CT81oYxTdTwu9C2HQZvC9eZ7kLhBjl9tvlDWchiY8hWvxf4x+LiLhnAJcZKah1nBZAB+zmNRuS0r5/f+taoJ89K+Hj82PKmU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756309644; c=relaxed/simple;
	bh=P3uyIEMMKSRwJlK5jojLEioUdDOzgKQzaS5JXnnjk4Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ro6xBYymvh/CVZ5iGKX2uABBebBJta+s86SgvSdb/BIXKHUczJmqsDNaKUHy7/6l7qztmSloNtqLY3nYDXY3NpqMXDzRZ4aZE6SkaHre0soYWlWh6pMU5uLzkxzHY75S5HimGm1d8wZJDrYyB0h63Bi2oDfs5FK0zknz+Fl/8QU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oUjiVc1c; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xTZUzEas; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oUjiVc1c";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xTZUzEas"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57R7tw0i015126;
	Wed, 27 Aug 2025 15:46:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3H+3gWOjKsJexEdZTiPiBLbHGPxfkmqIizv1nTu9VNg=; b=
	oUjiVc1cgq8pRdes9skg1U0XnVpBVfxXggt94Cbkefx6WJtMbAd7PnzEVoUMEG2U
	Dv8+AnkgkQdx7p64KW1YcO/3Jnv24Xy/w13YWxybTgm54tssum5glikqk8tisuqm
	HxaIJp7bOytkNZdwb7zRvuBDGL+ekHuMldOQ6zkEh6BOUK1p3utfc5kwX01yjw7j
	DO0xHhlXoKhhtiziW8Bwco+aV/k82H43E9Jgw37ZqCOU17Mu1hcQzORMbcITKPeX
	c5jteWD0J5nak/xFeBm6p8Aq/VlV5LfaUwyEbR4iWUD4y98J1lF8+zV83K1uUmsM
	gL7hKcGjfH/XoQn9ZcnW+Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4japrbj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 15:46:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57RFVpTK005021;
	Wed, 27 Aug 2025 15:46:55 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2081.outbound.protection.outlook.com [40.107.92.81])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43ayc1q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 15:46:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qCG/w0IHex96t/ZMZPV9+mUTQ4P1xk2PgyvvEK5iLRXKDZQAJjky1uUCxUaR3jiDmpy324JM7Pgw7B+Qm9hNRx/bfhPyKUwzkgsaaXNH8DAGf2W1W2/Y7xo5OrgVT1yocQFQ3jFqXnU7vSRlIrA4J9GaFp8AKB2ecqpcbv8+a8Kc4q2U+G7xbmWpI2DWqAdemNojCGUZiW+bR+Eal4TRfX5F1I0BgbVaJgHXsvultaJ14oH0uMzlQ2gHW3C9fVkqvJ4UCvLwq8GS0j5ncYcZyuIKwd+AGdPsBDQZorSMmpJHd5oc9+/25oHU/VxDDI9GfuND1Evcrh/U0wvBN8o9lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3H+3gWOjKsJexEdZTiPiBLbHGPxfkmqIizv1nTu9VNg=;
 b=HDw1zTBCiyIDzO8CE6bESnEDaeW5Ree0oRgiXQbiJVF9RiolTmk5Lx3imXw3Lf11mQD4UPZX98hxlj/CBkHtwlTqaCeQOQ5Nd9QAnQ5Q754R9UBTIx+TLRWg8s/tFKjf5hnrnIJyMNP/Pp5ktDB6xipCBdBFTcf1AnR7nmFeqDE5XY0q1t4WSBXHaA9EZyRfbETns2yscwNkH4GSXnsmXokh7Oo+Chsi/ithiX9Pn7ryqoYmH4skey786u7KdyA1m6Qw3kT5+blyEdNTTjaU7X4XX+EL/jPXyrnWQRHsL02zRKGY3CZS3elWpIrgsaZMN/vuxY6v9LCKT+nAxtU4pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3H+3gWOjKsJexEdZTiPiBLbHGPxfkmqIizv1nTu9VNg=;
 b=xTZUzEassQfKlV+CZ7ZI6hlDgzeFpFwRpnx+mh3tmG2p+2UTGdOkttpwf1ePXYJYq2LXMD4cwMEDogXedkkLgaa9Mf1slpEbBBY01OXDJBNZqmmZOLrznLcirHzkPzYj0lQM3IUjj4QGvZYlW06fiq3uUNSN11EC0dM+q45orT8=
Received: from IA4PR10MB8421.namprd10.prod.outlook.com (2603:10b6:208:563::15)
 by DS7PR10MB5926.namprd10.prod.outlook.com (2603:10b6:8:86::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Wed, 27 Aug
 2025 15:46:52 +0000
Received: from IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77]) by IA4PR10MB8421.namprd10.prod.outlook.com
 ([fe80::d702:c1e0:6247:ef77%6]) with mapi id 15.20.9052.019; Wed, 27 Aug 2025
 15:46:52 +0000
Message-ID: <e2e6ec91-31d5-41fc-a6b3-2993c0ac069b@oracle.com>
Date: Wed, 27 Aug 2025 21:16:31 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/322] 6.12.44-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, achill@achill.org,
        Darren Kenny <darren.kenny@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20250826110915.169062587@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0043.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::12) To IA4PR10MB8421.namprd10.prod.outlook.com
 (2603:10b6:208:563::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR10MB8421:EE_|DS7PR10MB5926:EE_
X-MS-Office365-Filtering-Correlation-Id: efd549b2-7390-4853-af16-08dde580f12e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V1pMT3ZsQ0JndjJER0ptcUhCVHRpalpKUHhCaE53Qlp2NzhrRXhnc0pMZ1RW?=
 =?utf-8?B?MmMyMGpJVmNmYnZvOVhZaDVnajFWMGRFU0l6RjVJMFdaRHIzWHpKZzE1Q21t?=
 =?utf-8?B?M0JZYlZ6YWUwQTcrN0VFczNYb0oyNHlid24ycW82VVRsVUdtK1h4MlRLV0p2?=
 =?utf-8?B?UUlBYzgyWDFMUWIyK212Mmt6N3ZvRUUzemJSSGJubWkrRklLM3kxeEg4TTNB?=
 =?utf-8?B?ZXg4RWU2TmlQTTUyZTg0K0NjVkdkMWtzVWF1U0NKcFZzQzFSTnlFNWdwRlc0?=
 =?utf-8?B?RUVjd0VGZXN2bENnNU1xWHMxQVF5K3pndDZkang4N3ZDWEpMZTVzd01xUExZ?=
 =?utf-8?B?UDZPazl2RzBIbytlTlBhaXROc3RWOHpkNENOOW5TWkdhSll2S0dWTC92V2xR?=
 =?utf-8?B?RzYrazBTT2lGaXBqc2VlQ01vWGE3MkI5N282dkJwK1dXbkNNUXV3WlpvRGl3?=
 =?utf-8?B?bDdlOGp3dFFPN213RWVyWVh0VzM0OXBxOUFlMjg2cEJST0F2TmdGZ2UrakhK?=
 =?utf-8?B?bWRPY2NCcVNrTkVSS3E2L3R5am1iZ2s3d3BUTUw4aitZTWVPREN1NXVKaVp5?=
 =?utf-8?B?WUoxN21neXZsc0NKRlUzOVovTVRveUhvNEZxTk8rMVNpbGVUbWhnNFNlQUZp?=
 =?utf-8?B?RWgzUGU3RWJJWnE4MTdBaDM0Vm5mRTloOWVWUXdsdWltSktoazBlUGNUYkp2?=
 =?utf-8?B?WU5PSnR2Y0xHRVFDRDI2ZEdpdmFyQndGcHRjZ3FKR2ZxQjRnUlc3WHptMlAz?=
 =?utf-8?B?UDVBY3BjcTZyaFA0SVg2SERoZkNnTUVMYkZyWHF6bUxFdXVGOGNubTVCMnI4?=
 =?utf-8?B?Q1VSeXJ4UGYrakN1V0lQVVN4WmF3cTNHOEFOM1dmWFc4alZiT3poT3NVcFZw?=
 =?utf-8?B?QjI4VE5LQjRRMGloa2FJZW1WTWpMaHFwTnU1YlVqV0FBYWFHSUpPQXlTRmp2?=
 =?utf-8?B?YmJSWDk4ZDFhblY2WFBQVzdEZDR3U3lVRENVWTB6M1dpbzdiNXczQ1hOcUl3?=
 =?utf-8?B?Zklpa3pCbTVGTG1aOEtzaUZPQUxoQUJuK2VOYUNsS1l3eEhrMkU5TFBQUzJ3?=
 =?utf-8?B?WCtGWVQxU1lzSTJQVjBEc3RTS0V2eTlkTktaWWhxVHBjVGtOTlZkdFNoeHJI?=
 =?utf-8?B?K01nWmlYNVlnU1M3K3hkVSsvUVo5NDhHM2hhbnhWOVFzbmhwaXN3SzZNN0Za?=
 =?utf-8?B?aFdxOXVYek5yeWprV0lON3REdmNBc3ZyUW5rZ05EUTdYTWxrWjN3dTB2VTJZ?=
 =?utf-8?B?dUxjR3Btak5iTFkra0tMdGNsS3ptUE9YMUZOZFAyV2FMR1hnSGRpZWdwODNM?=
 =?utf-8?B?TUJBWUlNMFNOTEplOEUrczVvN1JnYUlQSlZ1OUQrQkxoVW91NzYraGhNbk1J?=
 =?utf-8?B?dmd0L1hhTW05YnUrbzFYNEUxRm5CTUEyUCttY0d5Q0xNQUcyTHlTanlMb3BV?=
 =?utf-8?B?bWNNY3N6SUM0cGRhWFNYOFlXTjBDaEgrbSs2V0N2L2FyTHlQbXoraTRQVnJ3?=
 =?utf-8?B?MzgrVFVUY1pXSEVGSU9MeXRGS01aTkxWQ3RnTWVWaS9GUlVsSzJ5azFBOSt3?=
 =?utf-8?B?R2ZWL2I4QXVaZDZoVHZEb0U5T0tLTzViYVA2Zk9JejRmaUR2YzZBOTd3S0JD?=
 =?utf-8?B?c09xZzYvRGF2akUzQ2E5WFZYcldZTEhLMmNBcnNKU01PTllocFBrL1B2WEow?=
 =?utf-8?B?QnFXR1JZN1pobWp2OHJOUjNjUkNPMkxBYTZBV2l2TUVmSU1udmJoZmQ2WTFJ?=
 =?utf-8?B?STFaNGZQRE5SWVc4ZEZsa25CczFoZlp0cWc2QlY0VndQYkxOTFVTZ2RrSDBC?=
 =?utf-8?B?K3c5N21WUG55a0hMNGVVbkFLMGhzMWRQSGx5aTNadEVhSFZXcExCRXZVY1la?=
 =?utf-8?B?YVRzejdXMFBhU2tieE4xZHZmTjY4WWFhRG04cEx4NGhjditPeVdMZGg5QTVt?=
 =?utf-8?Q?0DF3CMdqql8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR10MB8421.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NTVKMWJzMnJrdG1GbDBVaUQwWndEaWdJc1lIQ0hJYlJNQ0gwV0xsYkZIUjdO?=
 =?utf-8?B?Yk52ZHgvQ3dqY1hpQmdDYnQzd3UrT09jeUFPQVc5WFJCVTF0a2dVQTFVN1M3?=
 =?utf-8?B?WFYvMnYrQnp3M0kzbzBwSnZrZExWNERZYWRsWUFWaUI4Ym0xaFplaUJkMGIz?=
 =?utf-8?B?V2cxdzNDVmNCeXpQWXE3MTVJd2JCaXF6dXg4N2YzYzYyNHVuRWxJb24vU0xj?=
 =?utf-8?B?VEI3aWgvMzhDR0VBc3JkcDRTRzBxeW9HWHVGSll5Ty9yUkhTQkFnS2ZMcG1E?=
 =?utf-8?B?dytLTEswcEdXaVZCQ21XMmRpT1BxZlI1ZnVGMGYwVnNEcWEvZTZlemNTeE9W?=
 =?utf-8?B?eGN3bG1NSTY3WVBjY0xEUzhrSnU3YWZldmo1Z0czclo3aHhVNGxuZUY1bzhR?=
 =?utf-8?B?RkxBUFpZTEVvanJaTmlvcXJJUjJpTlpBOWVqZk9udFZPTm02WnJTT2h6YzJO?=
 =?utf-8?B?cXppV0JoSyticHpMRHhiVmk3UFFyaDVzOFU3b0pvaVE5NTNoSmE1UG1tcXQ3?=
 =?utf-8?B?ZXZZeWFBelBDYnBmMy94NHJpWmRUV2RUQkZWM1IyTTJwWWNONHRQOGs4MUFv?=
 =?utf-8?B?RTNMSGh1WDFtdE4wN1pSY0RWcGhGQXZYRjlQbGFHSkhGbkg5YjBYd29VL3Qr?=
 =?utf-8?B?cmVTOWZTNVh5OFJtdkl3a2owQ0NuNHNiRWlsR0owVUw3UkdIcmpmc09sMDRn?=
 =?utf-8?B?aGhLRFAwVmg5WG8xdC9jRDJSU2VCWElFTGE2RkxXZWVrNkw4TlZZY240OWl1?=
 =?utf-8?B?S05lU200NFJ3WlMrS1JXRUtabk94TUsvRldzRWR2L0hsNGYxNXNTZUlQazF4?=
 =?utf-8?B?WXhVdFQzU2FHaDU5VWs1VUFJOEE4QmkzQmJmcTl6TmpWSHRsT05EZXUvdkZ2?=
 =?utf-8?B?UXd5NkZ5aGMwbDI0Z3RaelNzbUdxZ05RckpKczZURmpHbmtJV3paekt0Z1Zl?=
 =?utf-8?B?MHhNZWl6eVQrVEJTWEJpbkZUQ0w1VDBIdCtmeDJPQm5ac3VtSTFCV2VrTmd5?=
 =?utf-8?B?VVVzQXdibFBBT3Z1d0pOc0VLZ2NRT2t6SlJIUy9PUjh6WjA4MS9tMVNzMUs1?=
 =?utf-8?B?ZEFPdkpGUWJmSXZFK2pPTC9zTzAwVjd4aXdVdkFPWWRPQjM4ZG5FYVZFcUMx?=
 =?utf-8?B?Tnd5Q0w5WTBXRkVtY252MUd2aVVNS01EcEp3aytHdnk3ZzhtZ0hQeUJqQkpo?=
 =?utf-8?B?eUVnTVc5Y3B4TFV3ek9aOXVBSE1obDlobGRxZGhwSFBSWGx6VEdBZDVhNGpq?=
 =?utf-8?B?Y1A5d0pEV0dGYnYrYmZqQmM2aXF0TG5VeVlFWXZLcXNYSHVkUFB3dG1NMVd1?=
 =?utf-8?B?bTdlVUU5ZVozYXpITUMvSW5ONnBYR1MzTURjVVhEWlBzZWhNU1VRMXYrVU9O?=
 =?utf-8?B?aGhlTUN6RUlTUFhrN3hkbDFCditVZjAwbTdnVHpWV3FiNXp4RFZSdWJqTllZ?=
 =?utf-8?B?dHdoVVd2SS83Zm9mbWMrcmVLSk04YXRFSmhwT3BGQkxueDZsS2NFVmViR29s?=
 =?utf-8?B?N243NEpiUzI2ZEZuOUZ0cHNJNmFjck54aHhyb2M5OE1OaEtWMmdkZUlZU3Fo?=
 =?utf-8?B?b09wYkZ6akNvZ0hpYTdxU01QMWhiTUNmRnJjOGo4QVBwVHNSY0UvcUNWa2RT?=
 =?utf-8?B?ZDZLbjhIbVc2ZXNMMWtsb0xUbzNqOUJQdk5zQ0MrVkNuMExIcmZ6SjE5VHB6?=
 =?utf-8?B?dGZGeW45SVRWTlRJeGVKc21NSFdJOHJXNGpXUm1UdWF5L2sxUlQ2NVI4ZlZ0?=
 =?utf-8?B?UitkTzhqUXFnZVV2Tjd5WTBEaXNqcEJPNVB3cFA3WW9ISEg0Z2xWOUxCRHln?=
 =?utf-8?B?V0laZWhWZW9HNGJBcmhKZXdKemIxUWlBTmNobkZscGE2Q09YRHBEcXdpZCtp?=
 =?utf-8?B?cjhuNmJVN0lmWlFCYWFYQ25jM2xkUUk2dTV1RlF1YzFNeXF5WEJhdmdRZWE3?=
 =?utf-8?B?WEdFOEc1UlpvWVdiNlJxZVdrajFhUnU0ZUkyazZMaTc2M0hhNVFGVzZRdUtR?=
 =?utf-8?B?NFBKdEtJZDFqUExmc3JHcGZIL0lYTk9XMFkrUldvNXpRZmc1RkEwQUdqTnJ0?=
 =?utf-8?B?aElqREFxWmlrbjJIYnNHYW5MMlcyQTZ6VFRKeC9xQmhlRStoZFRBRnNjUE56?=
 =?utf-8?B?d1dyNkZWL3JwNHRNR0tPeU9sWnhiUHBCSGowb3d0cWVMM0EzeU9iOGRRQzd5?=
 =?utf-8?Q?Uu5ZKEO00mwLfchsNevpLCc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3cUaE2E9gYr4GZxrnqRbdWLj4ch4bTzl0FGzKqh/Ew7Mqg+G0iwUwe/EV7Kv+N8CUQqpaX0V76kX8kGFv5HfK7/XPU7OhoZi/9rF7Kz7jL9WsPWGh307cbl9IrM9d8QwXg2DtECVN+lnJh8VCGlbBIanngW2gdhLpxeRlhxYE2d8R+uFjELK7f8oCIZUqMaOOLwjUamFNRYqTFUc8gaLHXjf35+cTYqe9vGRPE4vQjskhJhcRsZtSGmhmM8BC3ubH2rfjkUFdYeqcu0uPA3FfjuLjl9eNDwSqTm9Ge+TzG2fN/pSQfF6/9QnnuQYpeGMgyCUjc81nFhIjYA+Lxqh4un7vi/NddYWvAAwpnrbCW2nXT5wvNpa+nIR9eoxs1qY88924sIVe50+HZoIaq4Yj4oKbgci3Wx0Z8TRMwSYiSSznYNCo8A3pDwSFmvh7Vuac/F+uVLTyyLY9WvgJU35rGX4RIC5hQ2BAvR46gxSH5pVG/bLYpzzpqDtc/XcUprFZ+GPVro/VlSSvdn7p1Asxgza1HRFHgQCLMOdOMySh48oOWb4c2Pp545V11MR85lnepOSaaWRbNbwX1Ob+8csQI+uB/vsGhokpXxIZFBtyKc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efd549b2-7390-4853-af16-08dde580f12e
X-MS-Exchange-CrossTenant-AuthSource: IA4PR10MB8421.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 15:46:52.3740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7hYEXiXrWWVlLi7NSu2VupqdVWAW1VZEqnLNjahyPJNGwbaRohw7NpxVHlOhSfHjistjbako7Ya7freFLuTambj5nxocTBt8HyZDMyeYZbAY+XofTwomcPQD8INH5vXh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5926
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-27_04,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508270135
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxOCBTYWx0ZWRfXxW/ztfThiNHB
 vGqjmQfq9qZLZ9MHWGiTh8VgyjWqNfOuSQYbCASfwc8agjKJ19qL6DbAYgT0cFyKyZaEmp/VLxP
 o2HSvDYnt0AqQUmKlAGr7RkljQnxZ8tEhs6iB99kv38FzaKILbSRZxQwUTWgR/1TC68KWG1sgKy
 BQMcrAkN8e72ITH1E5yPPPN198VOF0O/oG5+jB3u5khRhXKGoLMN0QEgiDsTC0+jlHHRSMlZAIj
 AQBqc5ZzKB8sK7vFzhnXfrEyLD4Agw4UgUwKxpeFokBjX28v4NBQ7bOgx/Kwn3XreTpvxBDAPaW
 TFXully9EjNPzdZvnASBRwvPh/qDCs4Vp0ze8aZ9fbyVm6GaR3GlA/aVdp4211l+LqEEwdoOQa+
 i0FFpadb
X-Proofpoint-GUID: VlzvPQts7T4X-nvRFTOCldJ2XDQx7uC4
X-Authority-Analysis: v=2.4 cv=IZWHWXqa c=1 sm=1 tr=0 ts=68af2870 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=wPjY6ArtI7gPP6EBfAgA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: VlzvPQts7T4X-nvRFTOCldJ2XDQx7uC4

Hi Greg,

On 26/08/25 16:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.44 release.
> There are 322 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
