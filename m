Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013058.outbound.protection.outlook.com [40.93.201.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E244923770A
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 19:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764791374; cv=fail; b=NdIjt4ItFJMrz9/OqDe53l+kYTsv57Wu1T2oXXmgtZZlsO+oIJuDwrybV7b88lYMm0E0aFcdwga1cpeU2gtbXcv4Sbxrf2970meUCH99XiA3CfFvzBLpZwa4gvvQlO9eI9V0OcEpvUGXQKsXAw6XME2ZnlcC3sDUbeMSR6fUpfQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764791374; c=relaxed/simple;
	bh=TixK2B5zoC8A3XyhYRHbbCU4HdQ+GynxLcO1izBTUXQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IAsxpXa6xod8Ykp9Bf0/ylGtMG+ZEoO8RApJLfxoqw2XXgcrbfVokmnAsXmKXQlYc1jQIYRKHKTwf9cW/BM8Q6mm/4x8gqHfZ1iJq+R3vSuAldeH4894RSkhf+a3QdJdH6QrALrgqEgpupAZDsX1ueF3IXJXQUtV8qBSUgL5K34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RxNSUeBI; arc=fail smtp.client-ip=40.93.201.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RxNSUeBI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VbYxKiNoG9x06cfTlXSoqNWFp5ejp2dLrIJbpllPfmkVELQNBjiTQu7gnJhnv2KGfUjyVwPBb69wIsU8VGf2MdyFGqnSRnA7ldZgikG5Urp12edr4o3VbJqC6JX6MbiiEeFcYchw3kVQhYzMl0/TApaLVhNHGWbVlhToRTE8Ai2gJv/DGzaY6t10MVRBBxnZpsNHK9UYj3h3bgOKtuOy3GO/D5yDfH1hWuheu/IjQPf8//tL047HpEc6X2EcZae9Vmakl8upjPqUce23tcwqExJ0zQ8I4d82UbE4jlBMeRZ0hCXJJ+cz72pryuFvM2eHQPCdoTtHTlZr8bBDueNjYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+wYSGGTYwLLeJdgFOQl4Itk3W1VfxMHtXxNdqquzJyM=;
 b=wfntM+c9kygvTPEV8tmkNt8/Jp1AgbX3tLRmt5/eOtb2mPnFucaXBVVb8H2mRbIfRouhW2EvVOnAf7Jc4ykpadFBJx+Ss97eZeBJ1QAt6ftCtPFgN5D3yjX0OTvEnIg+5giOXVgRRtfJM+z0pGLwpOsauXtEnurYiZ1VCqLLSMbRa3jGmj/o3yfPStHDlBonqhSQ44CmZHKNi7wEI4eGHnEneMQbtnJbDeTZFKKq6SxZVDVgLE5trg2zOB3uZ7SZr2IKsTQZMDyxBDPgjCufC3n8/WaECawJwXC9NMhV+WYTG8DLPC/pxuEp+Qm1TYGQE/bbNCs/jYbd7iN1g1ULUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+wYSGGTYwLLeJdgFOQl4Itk3W1VfxMHtXxNdqquzJyM=;
 b=RxNSUeBIdFLdrErQ3ZN9ZkuTUmCSE9R146gifAy2Y+cEHSbnOaGF9TlvO695yYlcDgKkXTlmMplngz1HfR1C/3iBXxaVPhtHtyN35awu5Xud7nFKFWXjPSTiWvG2VmUQuJHQmIeL+Ln3Syz5H1zguMTCIf9imRaR6yq7cB09OmcW+6WnLo7ZJ0qJDauNxTdFv3vVSwjiG153RHZV3FNE8SwwNUi+MacufM8ft3XNgwmebYIVA4CQp4mxF5PxBBTbKOaACQYWnONIaqnxsQsaRrxwozttg1Tvx6dXY+CUy0OFR9e2pwcL3kT0rYR+Mu5jo5ow4HIi6YUjH1nAhsJMbQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by DS4PR12MB9588.namprd12.prod.outlook.com (2603:10b6:8:282::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Wed, 3 Dec
 2025 19:49:29 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%7]) with mapi id 15.20.9388.003; Wed, 3 Dec 2025
 19:49:27 +0000
Message-ID: <eff6e790-08b2-49dd-b0fa-61d6e959cafb@nvidia.com>
Date: Wed, 3 Dec 2025 19:49:20 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/300] 5.10.247-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20251203152400.447697997@linuxfoundation.org>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO3P265CA0024.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:387::19) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|DS4PR12MB9588:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e3c7a78-b6cd-4690-69d6-08de32a51105
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|10070799003|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VVFFaW50U3ZBdHJPR25oU2lYNENKNDhaa3lkWkpCQTM1WWFOMXJCV3Y3OWor?=
 =?utf-8?B?ZDBvYmphS2dEaXhJWXdCbC9BRDBlWWE5cEN5clpNUG40NnFJVjhYTHJlK2Rw?=
 =?utf-8?B?YzFvMm05YkNSbmxzL3VuK3k4UGwzcEdjUHhpZGhmUXhBTzlZa1pJMjVOTGVE?=
 =?utf-8?B?MjU5K3ZaTU1WVlE3Rks2T01IMnFRdlhad2tQWGJrQ3VEU09uTmdEZXFrNTRM?=
 =?utf-8?B?U3Q2VUNDcHlnSUN5OEJkK3dBSDI2TUFuZktMRHJTeE9vT2FkVUxTdmRZKzZO?=
 =?utf-8?B?Zm93Z0NBOFdzbzhNRFR5SEFLU2ZzRWRRT1lUL0JZd0hlMXR0SkxrRlVRb0I1?=
 =?utf-8?B?WGZ1Ty9mUDFxa0hlYy9SdXlhK2VpNUlsZ1VHd0s2NjVOOEJLTnFSYUhTQzNW?=
 =?utf-8?B?MEhTMHR3VzBhMG1tQ2p4OG1RUFdSWWovNjFGWTVTWHBkK0lpTFA5ekh3d1pL?=
 =?utf-8?B?REFBcmJMbHNGVEdSVkUrbEliOEFHMlJzaU1WdFB5aTZsakQrL1BmcldWYnRE?=
 =?utf-8?B?R2d3QnlOOVU3ZnFXM2taSndDdDA3SHJVWHBkeE15aE12STRIQ2RoN3JKU1dC?=
 =?utf-8?B?dWgrK3p3TVc5cFJhYWNhNm02WUVNdFRIK1AzQ1F3YkVqSDVpaGg4SkFBU2Ra?=
 =?utf-8?B?Z1RxM1c3cDNHL2RrZ2lDT3RjYVFPbGVmbzl1ZjJ2VHB1VzVlM2dzb1czNHZz?=
 =?utf-8?B?Nmt1Q0JocFBkbDNYVDlYSCtUUDMycDdWNkR6RnBFMCtxNnZwYTBieWJkNFg5?=
 =?utf-8?B?NnlTQjRTc2ZnK1Ntd0V3M2ZwK2F2Ti9vZkY1ZjllT3ZLRVhGOUw2NkNIdFhF?=
 =?utf-8?B?Y2FNVWcxa0NTTjRlZHE4RVVTUkc2TW5QQjV6TTZRM2tpVHcvRVV0V2xIODBy?=
 =?utf-8?B?bmZTemczbTNXb0I3YnBpb2NYbWx4d0dDTmdxeEdJUktxSGlWcnVLT2hQdHF1?=
 =?utf-8?B?QW5wWFRRVDNPQUZDUHIyZGN1T0tXOUMwemU0M1FVb3BubHhQNG1XMmNYL1lo?=
 =?utf-8?B?a1FqWEV3eHpVNzZ2MUIxWHZyZTNaUVBQRDlJU0cwU0E4aWlrNEpxV25rY0Zr?=
 =?utf-8?B?M2ozaGdNUUhyWXp2aG9DRHpmRGRPSVA3WmtuM0VjaXVPeUhkQTR0aE51OUJp?=
 =?utf-8?B?ejJTSnlETVlDeW93Vlc4WUlzYXRxZlNDTUN0YTVJOEt6YnZoUmYxb1JiMXg4?=
 =?utf-8?B?bFhwWVVmT1BsUmRvT3NjbHVmRmFDcjBjQk9HeVdITDNIbG0waTRLNHBtY3Na?=
 =?utf-8?B?R2lBaTZqYjFTVFFsZXlJUXBpUkFhQ3JadzZxalZmUG1rSHArUzJncm9kVWYv?=
 =?utf-8?B?LzVnMXZTZnZ6aW5CdTkzWi90OEV1TDJtQjk1V0t3OFI2WWp6bmNoNmNGdm5s?=
 =?utf-8?B?TmZ4L0tBblRsVGRZZFMzRVFNTXVzR2J4dytYTUhXaU9oVlA4SGplOXd5dGxV?=
 =?utf-8?B?eTlBTG02TWIwY1FWRjlnZmoxNDkzNFRyR1dzcFJBbmhra0lQcFAvaUZTeGlJ?=
 =?utf-8?B?bUF3QVpZSVdMVEVmL2psbG5CQ2dnOCtDOUhsdlRvVG5IMGFpWE1OS3lOZ2Jt?=
 =?utf-8?B?TkZISlBKV1phOHBCd1RFTGNZSWhpZmI4czBtKytMUUZsVy9MWi90QTJzWXpH?=
 =?utf-8?B?WVlQTG5TRVQ1UDdBVVNhOWlkR3BtSTNJZDJNQThsZmdQZFVmbWsvRkRyb3V3?=
 =?utf-8?B?Z2lGUjdDajhvb3Z5WUJPNkRVZlRGTHNlUjdjeHlsUExscnZTTXN2NHRCZCtP?=
 =?utf-8?B?a1lnbWJGZ1RWTFVMeUVqZjNDbEpuem5EMTFJNDU3a1h3L3IvYXM3RURMd0JG?=
 =?utf-8?B?aEROQ1FQVlZVbDF1d3krNWZxajV6VGNpSDBtclphS1RwYlVOWDcvZlBpM1g1?=
 =?utf-8?B?K2pCOE1qeG5WOW9hZDZwMkVuSFdhdVd4eE9pRmYwelRrUUtLbVNZck9hTUJE?=
 =?utf-8?B?eXgrUnM1S2ZxSklKOXVvVkRyTEtkd2FDM3ZoY2FHMjNSYzNoM1ZHaysrdC9T?=
 =?utf-8?B?UXhPdS8ySTBnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WnEvbHFGcmdOKzIxYTFTNVFHcFZvTjZhVDc1dVJ6cDQrWHVJVmVrR21oZ0lV?=
 =?utf-8?B?M2hndUxydk1wMlZleU1XemtoRWhvT3JTTDB6TERzZUFCMy9DQnFNU3lhSU1l?=
 =?utf-8?B?YkttbSs4ZHhJR01DNnJmVE9XQTJYdUpBaC9aV0pWVWVxNFpCNGl5WkVrTzNN?=
 =?utf-8?B?cE9DVTJ0elB5Wmc5eGsxNG5HbXZFRDJxak1haHZPaGZVNlEzOU1uQ1VOdDJK?=
 =?utf-8?B?eERycUd6TGVpb0JBeUorZHk5L3R5RDl1ZTY1Q256YUFIZnFhcWxWRGwrVElY?=
 =?utf-8?B?RmZIak1KYW9qbDljN0hoNVBqcFp1VEJzeHVZRWl5OWE4cE41MXNaMTlsbFhC?=
 =?utf-8?B?UU9TQlJjY01hZks2dW1INGc5RDJBemxwRlNOM1VOVEhoTUo1K05TdDc3czZl?=
 =?utf-8?B?VDJCVFMzY3orRWdzaVRYWjZNcHZFY2dOU1JRcXhTZ3Y0UXFaN0pkd04rSlds?=
 =?utf-8?B?Y1pBckdKZ2I1alVvTGp5Vnl1Z3JNSkRxdmN0MytzL1lvaXV0WnBZQzhKN3Vo?=
 =?utf-8?B?d3BucHp6Q3QvTEtBM21mdkpna2FWVVEyQ0F5eEZpaW1QMGNnMmpxcGpiS0lU?=
 =?utf-8?B?Y3dYS0t4WmpaclJSWmNib1hjdTNlN01PNnVjT1BybDliMnA4aEVYM0twUFNY?=
 =?utf-8?B?L2dCMlFoQis5WnNjdmF4amw0QXpmbDVxRURUT0ZZZ2M3UEVWcmpvbFNnOWRm?=
 =?utf-8?B?TnUvNmFLVzJXTUhadXkySkxPeDFBVWdENFBiZ1V6cTh4aU9WazdQNTJET2lH?=
 =?utf-8?B?NnJQOEptUmVpRUFJWkRnNi9kRUtYZWtpZkRUYTF2U2JVVDc4ZnUweE5IVnpz?=
 =?utf-8?B?VnZDazVWVVJOMkNtN3I2eVpPajJ2UXpwMUJRWUdmQSsvdHYzSkZmVDZmcmdO?=
 =?utf-8?B?QnpYR3dWclB4UlFMN1FnK3c5dXNmUlQyajIyOHZVZzhzUGhBa1BLU2F1MHNs?=
 =?utf-8?B?Z09NY3FGaHc1OU1uWFliemRVc2tjT0dFM0oranBHSjA5TGVBS3dBWkdYdUJN?=
 =?utf-8?B?NWpsVkwra0RXMk1VbU9UUHlINWo1dFVsK2FrcDlsZFpXZEFGczl1NjBVZlRZ?=
 =?utf-8?B?ay9EZUVFYUo2eW04dFBkTzdlNDRFOHpUb2dYOHNrdWl2RWZsOEtaKzhMa3Vr?=
 =?utf-8?B?WWdBamFITVQvcUs3RTNhOXJxbjdIZURLUVhyLzh6NFBESWJQVC94eDQ0ZmJq?=
 =?utf-8?B?cGJDbVZxbmRCMjNDcHZPVkRLeVg2cjBlZEtSeGN5dDYwTlJkS3ltVU9Tc3ZQ?=
 =?utf-8?B?TkRMYWE1U01QM0lSeEJpZlpEdzhWZ2lYNDI0TVJJU3FyakZjRmtUN2tsbW13?=
 =?utf-8?B?R0tlV0dFWDQ5K3gyMXhHbDFuK0pNWGhzT0FVUmM4VHp2RTI0aHFPRUszZ3Bw?=
 =?utf-8?B?TUVYN2dBc29TNlpoUUIwOUczTC9BOURUTFhJcVl1WFhKQjlzOEhUTzM0OWxX?=
 =?utf-8?B?U1B5OFZNejFZVUlRbVVCME0xQnFwNUE3b096UTNrZ3BXbUNSNzduaGV3OG5z?=
 =?utf-8?B?ekJiQlAwc2s2aWIrb2dqVkdubUMyWE5YRjRoSHBYODB3aVVvT21zTC91UGdJ?=
 =?utf-8?B?SEVNYW9YS3p0eUNISzVNOUVyaGIxYzFzM0JwVGdpT1VpZnkwektlRG1yTlhj?=
 =?utf-8?B?WXpHY0dpb0g2SUNJcVJFamlhOXNSTVMrR0ExYmR4TUxuYS9qblBRZGYwVWwv?=
 =?utf-8?B?Q3M3TEU2YlhVMitHd2JkZHd3Q2ozL29hQklJQnRTektzQkgrU2VTdkJWUjAz?=
 =?utf-8?B?allld2RxYTNmLzRNWmdHcWxJYWxVb2QwSFV2Q3dSbW5zRnkvYkJaSldzVnQ0?=
 =?utf-8?B?OVY5RmNoWjF6dGF1QUhJTlhoUUFGZmhTTWM0R2Y0b0F3aWlHYmlnRDhZbVRV?=
 =?utf-8?B?RHpqV1J4clVRblk1OE1KTlA0RXRZeGFpY0x4VE5HS3hub0IrUTY1b055RWNC?=
 =?utf-8?B?TVFPa3BvQkVkemhLVEw0cVVTYkRBY3BQYTJqZWJ0WVU4VjNsVWJyZ1RQUzVT?=
 =?utf-8?B?WGNZOWNKaE5wMk15MWlFWGQxZG9ub3NIT0JrZnJVY1FkUE9yb1JKRlJDNnRW?=
 =?utf-8?B?Y2pjSm1pNXp1V1dhUGFqdW9wU2pnQy9xd3dGajVCd0h3K2dWMTBDU3lRU0wv?=
 =?utf-8?B?TjU1NGt2Z1ZkSDdnVlpaa0FXbGdEV081MnY0Z1pXT3oyT09ZcmJTNE4vYmFj?=
 =?utf-8?B?NDhtdW5mZ2lrWEFjSXFPZG8zNmN6R1VyTHh1dFM1ZElIbFFlMFlYZ2VkN0N1?=
 =?utf-8?B?L1Z6cHFwY2lwRlp1MzlDcGt1SktRPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e3c7a78-b6cd-4690-69d6-08de32a51105
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2025 19:49:27.2333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AN0j+QSAT3LN8RSklL9PBcwWOQPwEK1pc+hamdMAjRQfycZLM5rxWdM/vmgIyu2avtjxjegV3fM2Bz+TyKQH7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9588


On 03/12/2025 15:23, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.247 release.
> There are 300 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.247-rc1.gz
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
  
> Vlastimil Babka <vbabka@suse.cz>
>      mm/mempool: fix poisoning order>0 pages with HIGHMEM
> 
> Fabio M. De Francesco <fabio.maria.de.francesco@linux.intel.com>
>      mm/mempool: replace kmap_atomic() with kmap_local_page()


The above two commits are causing the following build errors and
I needed to revert both ...

mm/mempool.c: In function ‘check_element’:
mm/mempool.c:68:17: error: ‘for’ loop initial declarations are only allowed in C99 or C11 mode
    68 |                 for (int i = 0; i < (1 << order); i++) {
       |                 ^~~
mm/mempool.c:68:17: note: use option ‘-std=c99’, ‘-std=gnu99’, ‘-std=c11’ or ‘-std=gnu11’ to compile your code
   CC      fs/open.o
mm/mempool.c:70:38: error: implicit declaration of function ‘kmap_local_page’; did you mean ‘kmap_to_page’? [-Werror=implicit-function-declaration]
    70 |                         void *addr = kmap_local_page(page + i);
       |                                      ^~~~~~~~~~~~~~~
       |                                      kmap_to_page
mm/mempool.c:70:38: warning: initialisation of ‘void *’ from ‘int’ makes pointer from integer without a cast [-Wint-conversion]
mm/mempool.c:73:25: error: implicit declaration of function ‘kunmap_local’ [-Werror=implicit-function-declaration]
    73 |                         kunmap_local(addr);
       |                         ^~~~~~~~~~~~
mm/mempool.c: In function ‘poison_element’:
mm/mempool.c:101:17: error: ‘for’ loop initial declarations are only allowed in C99 or C11 mode
   101 |                 for (int i = 0; i < (1 << order); i++) {
       |                 ^~~
mm/mempool.c:103:38: warning: initialisation of ‘void *’ from ‘int’ makes pointer from integer without a cast [-Wint-conversion]
   103 |                         void *addr = kmap_local_page(page + i);
       |                                      ^~~~~~~~~~~~~~~
   CC      arch/arm/mach-tegra/pm-tegra20.o

Cheers,
Jon

-- 
nvpublic

