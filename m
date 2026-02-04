Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012043.outbound.protection.outlook.com [40.107.200.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCB238BF7C
	for <patches@lists.linux.dev>; Wed,  4 Feb 2026 19:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770234898; cv=fail; b=nDVVKlRDey9yu1UFvvmcFA2v6idLevI2WTZdyVS3HIvBXAnW1ullVaUGgKEPxrXa54yXsHpOZzx4DEkwdbMqod1YC2t15Pl69Qwmbklf/vkYI1qEWvQhLJvo4W2LfrXJrIV8oLzglfIntJtVAiLEFCLaScDgLo1FgYfnH1Mksjg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770234898; c=relaxed/simple;
	bh=mnaj9ZJ9O+upvLuwgRwwTOOjjhDM+4oKzDO9tj6Dkhw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eXonVvBDkADa2FwANmsfYTRWtNHMG096xDkBkFxHpZXQANmXrlBsU1OVSRWmdPMBadUBo8oCM9uNgV7T7SYYCtZyMONv845XYYuF5hzHtpeGLSfWoqyGjoWdIcvpWphd6YV/4m2QWl7rBUTO9gfU1tWt7ztqrUGPMtA2eNaIxFw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UhwVCSTz; arc=fail smtp.client-ip=40.107.200.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UhwVCSTz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xHbTwgvtl705l3pN+0it2/d9QzmpPjeY6AQbewBYpbyK8tZdWLzmskhTDKCK7m7vNsXeg3M/dkQ04lsC7LTpTp1kLZPF5XUkx96uvZuedu7cfuF0kcB/N2JRUnPrirX3Mh9BI9NetS+fgK/rZXSrbwnCq9HE51+tYYSFnwpIKLEKie7GbifCZ+i1wWFXs7Q551OPM4/dclRhzbpu7Rlujy/VNjr0o1CgEXUV097Ui+PSzsPK4j0OadFP8d9foQs//nFj4LPO0qXA3fql2Wtx3w2nJEp1sWspr+8b5v10RNDCl7zxe0yTfs85el1FcLu8Lr8Os7CHsPdcHNrerHtU9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xz7sQ4aXwFjd9ymUyP1cd74By17h0EuBWswsDInBx8c=;
 b=djsFunWEsULe8CSc+J7Zc4u2/jafca18TKtE0Ssh/du1ibdeK/y73BOuFPQCHhDDTMeAJZL1KDYJ81VSwyiBpzJ0DNZ3tndM4FvCNy/2YHNaEy0+zSJ0jbV5GcxiOoHuoV7Udb/A4rR2AMXcPmxqIQ2SNkgmZSdV27BcOOO2FwEd3lkOGYGEspBox6ZBYnNE1V5yT26aHXtc2Y8UYwE473uYhVRfi4D5cMTwOMCPgdZ2U9Xzmtq8/msZ/VHH9dgkMwGfz23Iedb+keywlTJDdg0BFs7XVX6iBs0kiZjG4/vwTT7Ty/n5mrvY1/3pmA4brivdRvnvd5rRUagRC8ITCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xz7sQ4aXwFjd9ymUyP1cd74By17h0EuBWswsDInBx8c=;
 b=UhwVCSTz8wvRUCaMzjYSH+c5jWmvaSc+/QYJTQdHAyazJqVgl67jwrggXWir4mgscH48V5flAdLW/CCzrGPz6E/MW7vf7qgKVW2lIZUoG9/TkEFYAiQgUex7RbIs5bdEg4PlpmAR0Q+LMfGAzBEeXDX7G3iNAExAPwb9bTt/KUi3H0c+2HSxqhQtmiwYXvdiTOTvJj5Qc69l4jrn1dThOjlEEYj7xjgniRv08oV6qXFlv8uqeXHzpPp2/eDKzEnhaBEvfzwHX6ECE9a7jOqbWFqnOyspudal6n5mjxcDILflnUugpbjnYTJfSxoHJnqDgEBDr7zhye8y2aONNBvBng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS2PR12MB9750.namprd12.prod.outlook.com (2603:10b6:8:2b0::12)
 by BL1PR12MB5969.namprd12.prod.outlook.com (2603:10b6:208:398::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 4 Feb
 2026 19:54:52 +0000
Received: from DS2PR12MB9750.namprd12.prod.outlook.com
 ([fe80::56a8:d6bf:e24c:b391]) by DS2PR12MB9750.namprd12.prod.outlook.com
 ([fe80::56a8:d6bf:e24c:b391%5]) with mapi id 15.20.9587.010; Wed, 4 Feb 2026
 19:54:52 +0000
Message-ID: <f6280336-4e59-47ed-876a-bfb62252ae52@nvidia.com>
Date: Wed, 4 Feb 2026 19:54:47 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/161] 5.10.249-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20260204143851.755002596@linuxfoundation.org>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0548.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::11) To DS2PR12MB9750.namprd12.prod.outlook.com
 (2603:10b6:8:2b0::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PR12MB9750:EE_|BL1PR12MB5969:EE_
X-MS-Office365-Filtering-Correlation-Id: 354c7b3f-4482-4c47-61d9-08de642742f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NXYxTkJpWE5Ld1RDN1M1OG41T3ZOYTN6OTlYbXJMZkgzdDJjK0N5YkZyblVN?=
 =?utf-8?B?QzZ1L0pkRlhqU0JPejVZN1ZrVm1uNVZod3dLUjhjOER2UTZveElIcGQ1ekIx?=
 =?utf-8?B?eWdZc0hwVkViTjgvdG5NUEtzRlMrdWFBRjdIWWNUb1NIUUZaMWx6TXhKeENi?=
 =?utf-8?B?TjcycGRSQnprM2k1SHJBelVyVC9TVERYa0lTblc2QWs1emZQSVVjZXQ5dDV6?=
 =?utf-8?B?VzQ1U3NZMDJjOWIyNk42aGh2OXQ4UWh3Zjk3Z2dlSlgwL3YyTzZvK3Bkays2?=
 =?utf-8?B?Tk44Y2JVNDJxMFM0U09JU1ZDU0F4OE5WMm92cmhWRk05T2taZlNnZUplM1Ur?=
 =?utf-8?B?UG9mSjNKUCtuaVBzWnI2dDNjKzVqb1FLQnFoSDhiS2MwVlVNbmFWL1dBZmJu?=
 =?utf-8?B?RDZiOWlzQVZCUTNxMm9CQWZNTWQ0WjNtZkRIYitISm5JL2lIZ3J0UnVsVVZk?=
 =?utf-8?B?elNFWWN0MlZOSk5rZGw4ZUtQUFYrQVQ2d0JyNTB0NkxZMnkybzlQekIzeGR6?=
 =?utf-8?B?ZjcxQ29pUXVRTHpOZ3d4M3ZqUkUxK3B6bkxJRURYY3FPRTJ3RDFaSDZxd0hu?=
 =?utf-8?B?TjdhNktpdmRnd1RQcVk3MEpJbm84dTdhem04dlFSUndYZVgxaklNWWRUbzZz?=
 =?utf-8?B?R05YLytZUm9mdUNBRHAydFZ5UHk1RzdiZExtMHZKdnB1emkybnIvamVXODNo?=
 =?utf-8?B?dU9tT0IvWVFZK0JnNTN6NzVQZEZoTUFHK2tLZHBxQmNRRXIwSG9qYU9Cd21Z?=
 =?utf-8?B?VlRHWHRHV3JDMzgrZEFiMitvTUk0UEF5NXhodHdocG1sRGFES05XNGgvV1ZZ?=
 =?utf-8?B?ak84bVlWY2JVeGlNMGZzWS9paW1yUVNlSVduYmNuSWhRMS9PUTY5LzVobXNS?=
 =?utf-8?B?TnFRYVRHZUFCcDhVOEZPWUNPNUxEM3pkc2ZQclRTTVlhakFoV0FEZTlZWWhn?=
 =?utf-8?B?SzRpaGtzQi8xOVZ0TzJ5TVZESTZlNjdueCsydlh1MndIRWxUMVRVaFE0aGpB?=
 =?utf-8?B?VUMxN1Z2M3lIOTlQZWp0UEtGYndEYU5mMnNuOEI1WjB2N0tkN05JK2ZSTUlD?=
 =?utf-8?B?OFY3cnFnMGZFaW9rNkFKQXgwTFpJR3c3S05HWkowQWhzTDZVU3RROEZOeFB0?=
 =?utf-8?B?ZHBHalpaTThqbS9kaFByQkRnZUMybVlUVC93SFFMNXVUbFBRcElNOXpnZTZR?=
 =?utf-8?B?TTBTL1VFbGVmVWpadFBaUGpCTGYzN01PWFFaU1FTWlJnT1pBYjlHZGxvZnRV?=
 =?utf-8?B?MSt4RHlzMjRrbEJFZEtsV1FGWjNWQVpCWklTMTlpb3ZwS2FMSjAvYmxtT0dD?=
 =?utf-8?B?alY1cnpMbUpCOEEyaTBlV2w2TUJFUXk4Rkl1R1BpdDBqZzVkcldoWC9JUm9z?=
 =?utf-8?B?R2c0ajI3QVdDdlhzRXozZ2JLeVBoNFZGczJPQmpqZnNJZEY5aWU4eHZaZFFz?=
 =?utf-8?B?NTJMTVhmSkFMdUdOZXo4akdwalhBNzNnMzBBU1FBRW1xZk9ydU5aMnJER2Fs?=
 =?utf-8?B?UVJ4c29VY1I5SmprY1RsS2dNZTdaVVorT2RqVHFnUzlxQ0VxM2VJSmppZ2xo?=
 =?utf-8?B?eXU1MkxrcG1iTG5wUHhUZHRxZ3N6K1hmUmJnTEtzaW54SzZ6VkdlQ3BzdjRV?=
 =?utf-8?B?SnZmcnM5OFBkbTFjaHhFcWJqZHRnVzlISlZNTW1IS2YyMFFFM1AzbDYvanJB?=
 =?utf-8?B?emQ0SENpaStJa0VyOGRCVnpNRWVvcENZazRqanNIQ1FuTGVlWDJ2OU1tcmda?=
 =?utf-8?B?eGhLTzdvSFBSa0kwcHVJbzhFZHQxbHY4LzFvTUd6c21XYTVKNEcxSit6NXBS?=
 =?utf-8?B?R3JGWXN1ZGxrWGZYU1NPT2VVV2p1bVkwVU1sS2llT0dQUXRIVDZUaE1ZTTJZ?=
 =?utf-8?B?UHBOV0tLMFNsL1V6QlZCdmhJanZnMmJnK3locWVURVQ1L1QvcG80YkxRclc3?=
 =?utf-8?B?Qjd3ck5NeXpvYjNwY3kyY2J6QnBpVGN0eVVnM2ZxRmpDZURoeWZlRHYvRHI3?=
 =?utf-8?B?ODBHRkZPSE1FWXZEeEhrZElhZG9VNTVrSGZ5UVM1WnR2YUJBSG81dTVkWmFX?=
 =?utf-8?B?R1JEVmc5WDRDckVxSHVsUWZWQ1pWeHFYam45NnhOempRWFdsWFdQYnc1cGVS?=
 =?utf-8?Q?oAW2ERDABZryG/a2m8nkkxibn?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS2PR12MB9750.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SE9iNVB1c3dGK3hDS09TNzV4L0NkdnZkSDFSU1BhZDMvUjV2QkE5MjVja24r?=
 =?utf-8?B?RFIybDRZKzltNTRhbnpwemN4TlYvK2dCNjlNTXBUSVlQVUxwWGhQQythVXhP?=
 =?utf-8?B?UFZBbUZ0SnpzZjF1UXAxNUJWU2dVYVFBdlFsWnRXZEVvdSt0VnRTZVNQK0JQ?=
 =?utf-8?B?WEo4YXNBdkljaUZaMy85WGVlNmFVWUQzU3hQRmhDaVI0NkZuMEc2N25naWJ3?=
 =?utf-8?B?RnJYU21sL0VlaGkxNGZoNXQxN241V3R3N1FQMVlScm1iU0FVVms4Y2pncEkz?=
 =?utf-8?B?OW1Kek1WUDJlbHNEbnlhenVTV1pJZVpqVjVFajE1Rmc2OFpIWVMyZ0lkREFV?=
 =?utf-8?B?S0g3VktPOXBMRVM3cWhMWGcrb2hmWVkxRXQzVWNWSW1Yd1hxYlVrY28zdStC?=
 =?utf-8?B?OUl2UXlHanZVRjFodWs0UWN0UHZ5TkVFZVk0WURweVpLNUNQZXYvZHpkd1Ra?=
 =?utf-8?B?ckJnUVZiODNJMUlldWIvUHQxN0hGR2lpSTVvMzZ3cjVYTy9iSWp3TGV6am12?=
 =?utf-8?B?NW1uTllWQmNySWxyMlIyV3pQTlVtYnhFUnkrb1dqWmRWK0hFczhYZFZIVjFX?=
 =?utf-8?B?WElCKy9rZjlRNmVLdUtUdUNOTmpjWC95SHcwZkhmNUlTTjBHSDRwaU1VQ2g2?=
 =?utf-8?B?MjFkOFlqSjJqb1M1WFV2VVhQd1cvZWJDVDB6bE1VbUl4N1p5VkttRmhpdDZM?=
 =?utf-8?B?cVN4WXZwMlJvSHlkbEhmNGxwWVJwUVdsa0pTN1FrMjVYUnorMC80anR2cFh5?=
 =?utf-8?B?STMxczhrb2pHYis0UHJ0RVZGc3lyMm02M1dZSnVoZU1JM09QSzVaS3hjUmRp?=
 =?utf-8?B?cGh6emVzdWZOTzIzMDNNTGt5RCtxNUVkc3N0YUkxcFNIWG9ZaWFIMUNkbzYx?=
 =?utf-8?B?cW9kU0U3TE1kUTN6U3YwTmVIK2hNQ2NuVitGb0lUTHFCV2FNMFlBWm5XTXBT?=
 =?utf-8?B?TUxsUjNhK3I2RkxrK1dNZURDSFpwSHB5djF4b1FaY0RuQmtHTTFmek1aMWtz?=
 =?utf-8?B?WC80b2ZoVlBQeDdVNnUyYU1IajJKVTUxUXZuUE4xYVpEZEJZRkxHcGlaTDcw?=
 =?utf-8?B?b3pOclJ3VEU3L3ZwSExjWlNvWGZpS0l1VTU2bjhKM2F2SjRCZXZIV2FyZ0hp?=
 =?utf-8?B?RGY1ZDhTWnVGaTdWMm1OeGwyL1A2ZzEvNUVWc0MzaWUrcDVuTWJCSmFFS3NB?=
 =?utf-8?B?Z0dFaTBic1J2akg3ZDZkcEh5bUtiQ280b1hzc2R1VzRiK0ZZSUxxSHJNWjda?=
 =?utf-8?B?bUMzeThwOGlPUnVkMzN4N2FWNSt4QklOcExOODhnR1dsQWUzbVlIUmFKaCtB?=
 =?utf-8?B?Mk8vd2NPT004LzM3b1VxYlZiSjlnSXdMOHMybzcrTmM5WlpOdlZkUkZuNUxQ?=
 =?utf-8?B?dmswUmU5QWY0aEFLaGwyckRJL2RWT0paT1NvUllpd3luNGszbEhXdkl3WU1X?=
 =?utf-8?B?MnVOQXI0dklva0ViYTBFTmJ0MDRqM2NCWXk3R1RkUkx1R1pEZE9TU2dQRm5a?=
 =?utf-8?B?THY4TlQ1Z2VUa2VaZGwxOGk5UXhDVVdEOEtzWXFnWW9jOFh4WWZOemMvaDBT?=
 =?utf-8?B?TmdRQVMydEliOFhGbWcwTnN1b3BlQ2l6QktpNEY0UG91R1hFYUdHYXA5RnhF?=
 =?utf-8?B?S0EwZk9RTVFJSEJ4R2tzdmNwb0J1WVFiRUk5RlFxaGhiZUVvVzJpdTBTRWQr?=
 =?utf-8?B?OStTNE5yWnNyZVhHVlVCOTVKNjJzNTVDVVVqMDNaNVZlZ2oxZFF0NVNwKy9L?=
 =?utf-8?B?cUVNUGdpSWx2K2x3RlMrYzFwZHBGV1VYUnVkSnFFRCtldFdvbmtSck9ZK0Fv?=
 =?utf-8?B?U2dpNlNNZHpQZXpINDU3Y29QTkFMOVpXcXJiZDhmUE9IMVRNV0RhRnFXd2lJ?=
 =?utf-8?B?c0NidENNbXN4S0o4Y2RHWjhvdjc4QThwWDdXWFErRWtzNG1oQWZWSG1iMUsx?=
 =?utf-8?B?azZiRmQ1UFB2anBCY0NPWG5tYnRKb3B6d0tLY2U4aGFNSGVNdHhRcW9hM1VX?=
 =?utf-8?B?c2ZrSDA4YUxVdks0aDdwZ0hCZHRQY3BueTNrZ0QwQ1pTYlM3ektlMEttNVZ1?=
 =?utf-8?B?MGNNYmpJQ0gyVitQblY1SUFlT2FvdXpHcmNYa0YxMkthRkp6MjZwR0dLS0Uy?=
 =?utf-8?B?SFA1K3ZwaFhhb0JaWUVUNDBudytrK25Cb0VTV1d1OW8rNDBteER6V25wOExp?=
 =?utf-8?B?TGYrMHVUWXppUFhRQmU0VkdTRFdHRTRGNGdiamhiTnpHMW9IM2RNaWhudERq?=
 =?utf-8?B?ZmJnc2l5TStuclduWU1CTFJwOEpKTFNTOFY4RjhsNHg4Z0sySUpnd1UvM0I0?=
 =?utf-8?B?SzI3bVk2YVB3WmlqVDZRSW16WlhuUUFWM1BqVll1MjJWTWtQdzNYUDRWWWI2?=
 =?utf-8?Q?ZShXF2UF3P77IhzLQOQzPrJ8+2obmUUeWt4FL9+R6JKzo?=
X-MS-Exchange-AntiSpam-MessageData-1: kgsEVbB5GYdTAQ==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 354c7b3f-4482-4c47-61d9-08de642742f3
X-MS-Exchange-CrossTenant-AuthSource: DS2PR12MB9750.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 19:54:52.3754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eyGBKSkmqVcMfbE0pahj/s7wlwWqv18kNfoq5yF3rub65sIdCejljyyiTx1Np0RctJcc3V4SH3eS4WFfhW9Mxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5969

Hi Greg,

On 04/02/2026 14:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.249 release.
> There are 161 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.249-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:

...

> 
> Johan Hovold <johan@kernel.org>
>      dmaengine: at_hdmac: fix device leak on of_dma_xlate()

The above commit is causing the following build error for 32-bit ARM 
with multi_v7_defconfig ...

drivers/dma/at_hdmac.c: In function ‘atc_config’:
drivers/dma/at_hdmac.c:1323:34: warning: unused variable ‘atslave’ 
[-Wunused-variable]
  1323 |         struct at_dma_slave     *atslave;
       |                                  ^~~~~~~
drivers/dma/at_hdmac.c: In function ‘atc_free_chan_resources’:
drivers/dma/at_hdmac.c:1583:9: error: ‘atslave’ undeclared (first use in 
this function)
  1583 |         atslave = chan->private;
       |         ^~~~~~~


This is also seen with linux-5.15.y and linux-6.1.y branches. 
Linux-6.6.y and newer are building fine.

Thanks
Jon

-- 
nvpublic

