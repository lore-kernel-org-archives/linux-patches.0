Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013026.outbound.protection.outlook.com [40.107.201.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D00501F4F
	for <patches@lists.linux.dev>; Thu, 15 Oct 2026 10:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792060073; cv=fail; b=fAoPRoZ4NUM6N4GdpGzObmmVsNZriew/KG4XnhQiLGL5FlGQt426ptW/nuFUQQ9XgF+JU4p0O1ajlyVR6ID8xCjohrau9OX3xXN+4QAUBagwIaQaRq19dQqAgvOJRKeV8xH6rlPRsmvSo4bBYIXYqPqhtUm8ET53+ARqMySjrcA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792060073; c=relaxed/simple;
	bh=36scBGCIYNYzFbhWTLDpEqIlDw98c5vOw8KbMF/zpZY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fH3qc2r1j5kXp6X7UrbpJlWRgra1dmH7I2SjaFUB4m2/MlVosWpM5rLpjjmGasTFv5cOxdku7/8Fyppr5e3+rVFJHJlETOK3IyQPr5wJkXr8NOat+ThQ4zKHP3OeQtQAt+d8TE5QHkCn6yBfzrY1VY7p6Sob3D0nc8g0hc8lnaM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oRgXSX4I; arc=fail smtp.client-ip=40.107.201.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oRgXSX4I"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KIHUAu75k3SwMBopxbUGVXu/fvk9ypvFAkLynK5uCCAuzOhQ8xmfa+9FsjZC5LmYhD2uPGXnSGEvvl64IQ+SgzctkpD6f2ZzGfsw4QfU4y67lp6tea89H/qYenLtZD0X2tp/uRqNVwGnvgQdZ8CyVPrqULTH//60xwZne3W87hT2CBP2jllVrR5lOm1JEHp9YXkUzv7Q3F8nutPhuNoiALMc9oNpI/E6U0ij4WcHRyKVcpfuhV5El5Icby4Y9JR4Kwyztf/V2/QiRaZrz9SuSIEB7p38rtyf4LR8TWyLlNmDeNLyNS7GvYBIW6kLpi4it6BCef9htRVvX3XYMQQFQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xKWowcJ+KakNGLrGAdhr35aeAbpoAP5+suPjF/SF2M8=;
 b=CBwwewWJUbc6st33JDMs3Dkpj46OjA+TvyKaDDZp0BxBFOuaQfUIK7bpOVG8DtwfYXReKfm24Zo1LBfqcnx6VvoSQMxXaDQbfuk4iylnaU8tMULa3/ao/9WvLyV5A17YcZKAekXFoTg9Hwc/bh5W33bptzlcvkMtdlZLS1gp+nPm/tsciRJ/AshxbvhHEdUeGwGKedBZrKhd15tmd0FCnro6KKeYMRhRI4EDVA/jJG4hHL7oLQJ9myab47uNA+Jup1g3oiwTWHrplUgq8CuAFkLfdS+eNhdpjNIVhBu/oLl5tbYaQAxIZzeOd9ODQToPnbp0WCQf/pS/l7q6w6IC6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xKWowcJ+KakNGLrGAdhr35aeAbpoAP5+suPjF/SF2M8=;
 b=oRgXSX4IeY1opQi4L+zlNIk0ikN5WtXtyKvyTAP2p+uZfC6Wy2dA7YoE8yTDOgKopjYtLSSXUe0sKH+CShR4yaJTi+udcVVAWHJTmJXuPN5MWsWTDzoXm8GFu+FVEMTJr96pDaAZTBhKsf7ImNVzT0RiII/QvFzVvR70VKbSYVjLEjGFbMjO7YCPeZEjpCL7wePkQ+QGNs1y8DrBQeRjLwNV6UYn677d/cu4TH9rMrueYfIdO0yyAydmdHH1j2u8yN4PKRg04fdTwbR3Xiogt5SHDFss3x8NU2K/a37NW9ym+q5FVUTpFs1CrYPlMwspWYBhDBd3tvNXfOvaB4ismg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH8PR12MB7110.namprd12.prod.outlook.com (2603:10b6:510:22e::11)
 by LY0PR12MB955947.namprd12.prod.outlook.com (2603:10b6:404:221::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Thu, 15 Oct
 2026 10:27:48 +0000
Received: from PH8PR12MB7110.namprd12.prod.outlook.com
 ([fe80::736a:e1be:ec64:5740]) by PH8PR12MB7110.namprd12.prod.outlook.com
 ([fe80::736a:e1be:ec64:5740%6]) with mapi id 15.21.0496.021; Thu, 15 Oct 2026
 10:27:48 +0000
Message-ID: <10accc0e-f67e-4b89-9ce8-54ab09f6414a@nvidia.com>
Date: Thu, 15 Oct 2026 11:27:40 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/632] 6.18.57-rc2 review
To: Sasha Levin <sashal@kernel.org>,
 Peter Schneider <pschneider1968@googlemail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com, =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?=
 <u.kleine-koenig@baylibre.com>
References: <20261014123820.008483134@linuxfoundation.org>
 <628066be-fc84-492c-8b03-1aedaefad4ca@googlemail.com>
 <20261014213019.rc-reply-0001@kernel.org>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <20261014213019.rc-reply-0001@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0091.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cb::20) To PH8PR12MB7110.namprd12.prod.outlook.com
 (2603:10b6:510:22e::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7110:EE_|LY0PR12MB955947:EE_
X-MS-Office365-Filtering-Correlation-Id: 08009504-5b30-4ca8-4fb1-08df2aa6f55f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|56012099006|11063799006|4143699003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	AFGLZdQzTJ/rr/OkNgwYr+AeueTcdtzvVuRLyk2ucaUUtiMShVfKhiiW4R++eL+RjMkvty1RUbyRX/n6AR3VLPGQT8aewEQg2MP8+KaE3vaFX0fpTrjmddIwrQeXA+HXB45LaCQyYBgfmgN0748JzbxucA1f7VQqOj3xRgSxdxykmf79jPrRru+XRnLt3OITJxuzRXsW5fHk2EUIjKLp9jv/e/DTFh5TX8AoCe0b2peMA6is+xf85XUFn7BQuVJStRMGwlbNG/xpDBvvzys0o8hNmpOZBsPKhCaKBUHrIZMXxCcJqPdNyMKg7tTI/ZzOjrQU+Rr5OR73LeD9yTImVLwELAsUIgdpJXiNbgllOll1OmHaOVy85jJA3vkKC8BIagXtJlq6Y6zer+b/jAriEETzZOB7TOI+pwr0IgPVxJWPVoFSU5XToQVmPKdm+0VY1DHImyFAyC8eXu+3/QOJYvaurxNJedIi2GoRnkl07pjPeKusnENl+nWTyeisWwq2plTUSHwgS+TsCwv/zEzmJ5WlozBHTMoJViCzXxq52xNFkXvMh7NWukSrIOPFVGm4OZHcTC/5Uzg9Kvs1gXM4Pp9bnA7z0ZsDTNj4Xzk4tfGkjk7oZZGaliEobNpRcq65bfm6IyRWFM4qarotpx5o4cgPKVSgdz2HczFdt1JrFhI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7110.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(56012099006)(11063799006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bWRzVG1uZVhUOS9FN2xobFI5WHl1RE96WlIycVlVL3FuRE5ISnltdzQvL2Fq?=
 =?utf-8?B?SHdtQmVCSDlVc0I4YlNqR2dJV25qM2FpUW5Md0NOc0tLdno2UmlSZjcrQlds?=
 =?utf-8?B?NitLcDVPNEVCQlRBZmpmbEUxSmxtbnpWWjhaUXpXRWIzQjM3c1NvcFBVNjBL?=
 =?utf-8?B?SWdjVTlVQVhOQS9PZ3pUekwrcUJRaEg0NEoxOFpSNFRCRXhWdm9vOHJQTGdJ?=
 =?utf-8?B?MEJxRW5icUdMODQzeFozZWM4bXMwOUdET21UZDFsMGVLbWFOMGFDU1hKMEkv?=
 =?utf-8?B?bDUybDNLZ1lBVlVVWFNHbVVxQTBXSTBLSVNRaEwvWFkya3FCUk1PazhBS0pY?=
 =?utf-8?B?SWE2RGNrUW1ITE1tT01INUZ1MmZBOGlUQXRNWVVPYjNiRE13cTBzTm5oMlBh?=
 =?utf-8?B?WWFvNXEvbU5odUZCZGZwelVZcXFLbENDQm1CczNUMHBwTkVhTTZQZnlLMnJj?=
 =?utf-8?B?WWxnSUUveVN6TkJQbVgyckpXYWs1dDgzLzVadmJiaXYrRUxIK0xlbjRRd2lQ?=
 =?utf-8?B?eTdLbDBNZnpxK04yR2YvTndPQjhqakNJUkdyUXlPdkRPSFdvY3FIWlk5OGN3?=
 =?utf-8?B?TU8veWo0V3ZUenRGKzZFV3pXYWVJREJGUGdrb3pza0hjQTRMZG5FckVnN0Z6?=
 =?utf-8?B?c2ZKckM1T2t0ZkhmcTVxOWE5K0hyKzFCVGRUamtUMG1hcENidVhSYkdJUDBU?=
 =?utf-8?B?bGQ0Mklmc21EMFpaZWpIb0hIa1RObG1vZndFbFdsTG8wN2Fiam03ajFMTTlM?=
 =?utf-8?B?MXRrQ1ArUVFpSUVNTVZOL2Jic2xaWDdzMWl5cGhoTUk3ckt0VGYzZzNVRzZ3?=
 =?utf-8?B?UW4zcDhGd0NpRjdmUmdLNjBnc2NkbzFZUUZVeHAvKzVhQVdHbE5PcUx5SW84?=
 =?utf-8?B?aGtzTDRzYTBJZWFNVU9lNjNsWEVQYTBkT3RsZDVMc1VmV2tiamNvVE1nb21W?=
 =?utf-8?B?NDBwbVZpcnFqcWg3djlhd0ttZjhqTUtPaTFzQUhqUno3QUlWRER0RFFsLzNT?=
 =?utf-8?B?eHlFNWV3OEJnMDd6dmRoaUJyYk1VRVdpd2dERGlYQVZhWG5QaytGWmZsbm1z?=
 =?utf-8?B?V0x0d0NEcVU5eW1KY0crY1c3YTVSclpCbzJ6WTg4R1BXSnc4MXNsZ3QwbFJT?=
 =?utf-8?B?V2YvT1VCOEFPNlBPeit1b0NZRlBZajA0SHFaOXdaekN5RlZVR2pNY1BzbDFk?=
 =?utf-8?B?R2JxWURFL2EvYUZnZkgvRkZZQlptL201OWJUSkNoellOSjAzV0NyaEg3RU5P?=
 =?utf-8?B?VGFYNVpBNDVLbXVnTW1pYTFxL1VPa2pWZmJ2WXNCdFJ1V090T04rcFY3OUxO?=
 =?utf-8?B?azR0MDNYT2o2VFVLQzBtbVpZN0djajg0MHVzeFJhbWthTXJNaktYM1FJei8x?=
 =?utf-8?B?R1E1d2JTUWdGZ2pQK0MzQ1R3TjJxMThGL2RuaW9jWWl1b3dMNG5Yb3hXMFdo?=
 =?utf-8?B?cWorQzF6UzJnNXVnN0w1MEdTbUk1WUx0WHVXbUh0MDFLZlVkOE1idmtGWEcv?=
 =?utf-8?B?VVVXblNEWlRiS0ZPSTlpcS90Mitqc0NmL3NJczZqcUVpcHNML3JOUWVMcGJ2?=
 =?utf-8?B?RE1Gek9XMkIzTzJTOXIyRE85OWgvSmVYZjE1bXJNd3hORTcxdUJYRmtVL0FV?=
 =?utf-8?B?U3A4TzNWdk1IcHBoZjYycUpKbXFhck5DdjIxYkJQRURGa3ByeDRRUEZuclB0?=
 =?utf-8?B?WldOWXRNWDBUanI4WmlISGUrZjZZVlhESTRXbWJVVVNIclZ3WXpsV1p5OGFY?=
 =?utf-8?B?aDdqZmdpbUJ4MzdNL0Z1ZTkzTzBRanFMRHM0OGtramI0VTJqRmN3dUJqSHIy?=
 =?utf-8?B?YitYN1FJRGxRUHBSY1FjY2xWRVlSMVd3V1dtVExESGozQnN2bk9IWnVENGRv?=
 =?utf-8?B?ZFZUYmNqVzY0emY5d2ZTUitrd09QcTdEb1JWaEJ2RXVXeTVnQjM5dlRtdDMz?=
 =?utf-8?B?Q3ZLQjdua1NCYWoxQW5PTGlMOUtkc1ZGQzJWZ2xXYUNvNXRobEJtbS83aGZI?=
 =?utf-8?B?L3cvWjBNaGFsWS9xNk1IdHlYanp2UWJGU0d0ZnNIbWloUXNpL3FGTVNUa0cr?=
 =?utf-8?B?aVZVR1pkME54SDVWWGd0ajlmM2lMOWNmbUdzcTY3QU4vbXMvV2xkU2NFN3BU?=
 =?utf-8?B?SmVwUnJ6RzE1eHVZQzBNQjBOL0ZBZjNYR2FmcVJQQURxdVBPcS8xSmVlNSti?=
 =?utf-8?B?Y0NPVjlVeEdDbk1ON1gzMDk3Ni91M0p3YVBROVR2ZGhhVEFvaStRMzd1Y2My?=
 =?utf-8?B?VTNpVHBWSXZ2Y28wdXNBcEhvUjV3VDk4ZEcxenUyZ3NodWlsUUVpQ3Fxb28w?=
 =?utf-8?B?M0lxZzFNdjJ6MjVqeWl6NW1pTStBblo1TTRyZEkvVnF0UjZJTG40QT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08009504-5b30-4ca8-4fb1-08df2aa6f55f
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7110.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 10:27:48.0659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5WTnP7pXbzHn/AIl6OF9PYql/f3i/uZk2AQcQB5/fccPXTZA75amzLMr57h8BKd3GwWxK1fV43Hxb47rFiyM/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LY0PR12MB955947


On 14/10/2026 23:33, Sasha Levin wrote:
> On Wed, Oct 14, 2026 at 09:34:32PM +0200, Peter Schneider wrote:
>> [   83.881266] Driver 'ses' needs updating - please use bus_type methods
>>
>> That patch was "scsi: core: sysfs: Make use of bus callbacks", and it is now in here again?! Was this intended?
> 
> Thanks for catching this. I've dropped it from the 6.18 queue again, together with the rest of the bus-callbacks chain (4 patches in total):
> 
>   - scsi: core: Pass a struct scsi_driver to scsi_{,un}register_driver()
>   - scsi: core: sysfs: Make use of bus callbacks
>   - scsi: sd: Convert to SCSI bus methods
>   - scsi: sd: Move the sd_remove() function definition
> 
> "scsi: sd: Fix special_vec mempool leak when scsi_alloc_sgtables() fails" stays in the queue.
> 

FWIW I am seeing the same and this is causing a test failure for me.

Thanks
Jon

-- 
nvpublic

