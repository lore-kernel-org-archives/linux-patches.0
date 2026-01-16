Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010063.outbound.protection.outlook.com [52.101.56.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BF13112B7
	for <patches@lists.linux.dev>; Fri, 16 Jan 2026 09:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768556731; cv=fail; b=pzz1hp032rg2FX1XhIB8+vZsp3TccUYsVU4LhiNG8WWByYdpVuDBBbCumZuWpoFGL37ZwO+NSIHrc8DoyRL5mthOu/0LWGtEQ8zO+n6SSwVILmyFnQCmCN1auHe0HNGOk5NvihObzsmRvXAS0Zg7dnuK4+AIdxNrvXYj95nF7o0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768556731; c=relaxed/simple;
	bh=FxnEX72ZRc4lRNNAisJ4P4KNpzlxJCA4HRhQIHnHiCE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Fyd2TjmSG/UP/jOEBQsAmYGjaMRHOJwqlVD0QgoSbjlaZjKJcwvAU0cb/dseZKmwY5Bfp7F0p+pTVmj6zqnoBIeHUExTwy4+MNDD6nEAGrcr0JrsdZig5zZmwa1H0XiRps2DpKC2vPsjk1Jy/FfIeuLh7pDn8y3uf6MauCX05kk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WtP+fWp5; arc=fail smtp.client-ip=52.101.56.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WtP+fWp5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gubXYQ4nBUnBdFfRygJYV5Oxo7uu0vMAK2izH1bt//Yk0hjND3wb15RRr3ZWX6j+oQmo6rL/EqNMxV6n4SUCI5T2LG2v0DLNWOB7CRRtw5sBWfz5ogQu2LM5Vqk8K5UVE1fSTrt4Ty2uCWddpAmJ+834xCjB3AVbRhwgSM9jcAzv8TrRNfSeq0zMDUHNfiyYv5NWbR/Uk6JqSZUNWx2KGh9DzD9/ffTXkjNCulAuNQo/0M/S3ke4a9cfUQNkTI9u/NuvKAYcs/BvM5+qHudBCoyS6iuIvfF9IJpKAuW4BUnhOsb0twDQnt6ZwURJ99BPMjr1gYkPA1N0Sv/IwUuN3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OW4LRJnGGHePU5O7Cps2qTXvFVAc/J6P77Hrc5Aq81A=;
 b=ChcXXekuS+hdUk5W5EL1ojorqRnPt8ZDB28WLe8rJhx1RP5K4hNqk+0fDaXEU7HBkNKtcnUXN/lxF4x5druIZeSjEd7J3g0gI2K/fzai2SD1s4sMoBewb0DekHm+JiRegFH0PRmC6jEoqDBpQfwf8or+MnpYDLoDhQUrlUuV7VhjGVIbje45epRh9P/KM+CucDMofe5MWEGWBhJWg5GHfdncaw+3lOn9zOVQWE++PPsz08Nh6kcDhFRk46dL35RUdGkZa5UPrgleIheAUIDYoiN/VajBOW8q1LAWiWOemOvsc+nrMUINmpylztVFwjvbPOR9RGD35WwBl4M40LVAHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OW4LRJnGGHePU5O7Cps2qTXvFVAc/J6P77Hrc5Aq81A=;
 b=WtP+fWp52tbPP/55kRe/PQkUJQEb5kivPslJWAEEBfpk5sX5/hgwNurQYSY2nE1iFswWvIL/8/dfnYh0RA88NevH50CDkmbFEQRCZFL8HnVxpCNz8y2GvWkh/iQkm8P0HgVnvDAFQau1nd2mZ4fl+hvuRxsSFUOas43Qv86V7tFqVIG83r7Gckpq78RizbYsp1T12l1mI1PWaVGjLrQg8/Kyr8D16eU++n1OYex99sQQIa9s0KAJ58m87LZCn9SR7NlNbB3XkAWiCAZYLVG8YxJ2aOlbmJELlTd+sif3Nu78nIAzSV7FvmNeBfoW3/SAuk+YByBi20wwmlUaOaOZ7Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS2PR12MB9750.namprd12.prod.outlook.com (2603:10b6:8:2b0::12)
 by DS4PR12MB9818.namprd12.prod.outlook.com (2603:10b6:8:2a9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 09:45:23 +0000
Received: from DS2PR12MB9750.namprd12.prod.outlook.com
 ([fe80::56a8:d6bf:e24c:b391]) by DS2PR12MB9750.namprd12.prod.outlook.com
 ([fe80::56a8:d6bf:e24c:b391%5]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 09:45:23 +0000
Message-ID: <18a459de-dd95-47cf-bf53-d7e743810e54@nvidia.com>
Date: Fri, 16 Jan 2026 09:45:18 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/554] 5.15.198-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20260115164246.225995385@linuxfoundation.org>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO6P123CA0020.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::8) To DS2PR12MB9750.namprd12.prod.outlook.com
 (2603:10b6:8:2b0::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PR12MB9750:EE_|DS4PR12MB9818:EE_
X-MS-Office365-Filtering-Correlation-Id: 16ea577b-555a-492e-5126-08de54e3f831
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eE9zbzlZRTRvai85ZEY0ci9VYWo2TmpBR3JCM1dRd2ZNcTA5Rk9INjAva1Z0?=
 =?utf-8?B?WUYxTHh2T1FKWFZGQzZaV1NZR3U2THg4YjVrNnFjb3JUVDIvVVJSVFBnMEhR?=
 =?utf-8?B?RVA1Y3U3Rm8xZEZXQkYvVGU4MUlJM2ZYWEVQZWZINEF6Z1c4b2FrL1RoL1lk?=
 =?utf-8?B?VldkU1JuRW80anUvVVg2RjVqa3ZWOGtUVXlFell3Lys1RmlIUXJEdmpjMG1w?=
 =?utf-8?B?VUh0OTNFV3pRY1VrbCtJbHdUOGRLWFBGQzc5eFgzS2ZqdzRTZXExU21QTUxJ?=
 =?utf-8?B?UHlNdWNRbitQSERpa3d6TDVBNmV4a1JjYmRnNGg5NXptWTAwaEpXbERtM1dG?=
 =?utf-8?B?UUtDU1lVN0dEVE14ZnczZURwc2luWUY1RVl5YmhpMitOT1g0b083WnNFdkk3?=
 =?utf-8?B?S04vS3pEbHZCTTExR2dOdVp2UXNFR2VSUGIwWHpma3gwSWdkM0VyU29ESlNn?=
 =?utf-8?B?aHBTSENma3czQTJoUUFsUWJRU0hGdythdnh4U1dtMWsvMHZzSGJldWwwRFJa?=
 =?utf-8?B?SjJPdnE4Q1VPMHcvWkFvc3FGWVpja0diVmhPa2IzOXU2dFN0MGRtbGRBdjVq?=
 =?utf-8?B?NWZIZUVpdWtxL2x5cWxNZENtc1ZJaU5oWUt0ejFHT1lId2MwcFpRc0xjU2Z4?=
 =?utf-8?B?UnJISmRYakdYZHpEa3ExTENxbFgrREhFRTRkd21GNjM0NmczQU1ZSnFRcXdh?=
 =?utf-8?B?aGlsSGszRXJOWUJQeFF4WUwyOVM3cFhvK2M3Z0J2L2dyZGdjbE8xcWFpTVJr?=
 =?utf-8?B?bDRVVEYyZ3BDOWlHUkQ5ZGhxbkswcmNndUYxNUhzNWttSUJ5dFVZcFBoaGFW?=
 =?utf-8?B?WlQzK21yS2ZkT3RsckdmN2dFR2M2UmR0b1VSaEtWdnAyOW1MUkJUWU5oZlB0?=
 =?utf-8?B?eXFDcjJML0VYclBYT0ltQThVS3UyUUFJejlZVk1CS3ZkWjVLOGxFQzdBd21S?=
 =?utf-8?B?NGtvMytWN0dIbWd3MXJXUTlZNWJiK21RM1JjSTdBb3BoSXd2K3Jqc0c0TDZW?=
 =?utf-8?B?NjY1NkpDQjkrWkNBZGpzdm5KV2ZPS1htL3hDTjBIOGdqVUZhS29ENGFkd2Ux?=
 =?utf-8?B?emQ2TzJDQ1c5VGViL2dLVXlId1ZnSzdBTE4ydEM4YUVyUnFLYlBJUXZYRE1B?=
 =?utf-8?B?UjVRNlp1eEZZNUlFQVFvWkV1NnlYS2VHMFhzNW5LQmNBR1RWNjB6TWl5c0tq?=
 =?utf-8?B?MkNiR3Y3WmVpdFdINDg5aDhQS1N3UWlXOEdheW9xN2d0Szk4SWNia3M3WHNQ?=
 =?utf-8?B?NGNUSWl6ZzVhTlhKL2ZrQnFna3JHSHdKNjUyMk81SFdrbmZLS0NObWk2Um9F?=
 =?utf-8?B?Ry9Wa1pjTnBTelZBQmduYzVwZTVpRlcvc0M4YlR6eU9LeWY2UjAxenM3ODFV?=
 =?utf-8?B?eVFoTGtCNTZYNHhaVG1ZOXRzYWx1bXdhUGE3R3laazR0dVFRYnFZWVJhRzc5?=
 =?utf-8?B?OW5CMSs2R1ZtNmJqNnFnK0NUWXFFZjdHSENiTjI2MGt2Ti90dzhCTStGMzc4?=
 =?utf-8?B?YXFBb2pobUhVNnk5aC82ZXQzaFlLZWJlUmFNU2xDTmlZYkx6Q3ZMcjN5YlA3?=
 =?utf-8?B?OUg5bmFqODZ6L1pQK0lHYkN6L0hWeFE3U1ZZWmZNTUN0YlJqVkczWnFkVUNy?=
 =?utf-8?B?eUk3aTRLZjFaaC9JdVY5WU03SDVMVDZRZk9mZW1IOEU0NDNwVjIraHUxS3Jr?=
 =?utf-8?B?bkRQWmNmNWJHSkFaYWVhVVlEUDZJbUZIZXVhZlVhY0ZGRlAyNUVScUo1ejV6?=
 =?utf-8?B?L1VsczhQWEx0WjgxM1RGNGxKSTViVnJJOHdYUTRLZXVKMEI3ZXhZVTZmOHNQ?=
 =?utf-8?B?RlEvRVJOTDREeVVrekFGRXl3cEN3aXJxNm1CcU9yQWxScFZ5MUMyaXRMR09Z?=
 =?utf-8?B?U3AwZnNySjRLQWZYTDk5T3MyWnNUQ3NzWWhteWJaV3hYN2tHc1hubWVYYVU0?=
 =?utf-8?B?UDVKMWpxd1V1ckNCWFY0bTRVUEVqQ2ZGdnNrOTVIelhPVVFWdXE3VDR2ME5j?=
 =?utf-8?B?ZFJEblp5cEJoandjUDVBSjFLUzl1UElIaVpHTGF6eldEdmNJWFE4ZmpIV0JH?=
 =?utf-8?B?WVlCZXNmcmY1Nk5LWmhQeERkcHV5bkZEcFoydFViM0NjSUhRWHhoM20vQ2dF?=
 =?utf-8?Q?8eN8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS2PR12MB9750.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(10070799003)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aWpwcnFuMFp4aWQ4eDdmczlOamZkL2hIanIxOXhnVTZoWW83UU1WTVN2V3F1?=
 =?utf-8?B?b1hxWktrdXBrQ3dXR2pRMUZCYTlHRkt0MCs4QlVOSnlQREtHU0d3UWNTbFEz?=
 =?utf-8?B?TjNPMDhiNVJ2eUd3akxyNTN5OUZ4SVd1NVdoTmtscUtTNXlsYUJEMVc2cFNq?=
 =?utf-8?B?N01NOS9SeW9SNlJGZG5DSEhQN0hiS2oxZWdqcU9jMysxT1ZHYWVFZ09XV3pO?=
 =?utf-8?B?RG9sTExJemlaOGlFUzhFTFh2dThKTzhFTTJqbjhNVTdvd2RSQ3BoUCtpZDhH?=
 =?utf-8?B?eXNPb2trTHBGejNPcFhTYUp6R2N1Q0RTbmxsWENBandMeTlURzRkNHM1RjZy?=
 =?utf-8?B?akI1TW9WcWNud2oxdm1IMG80S1dqRnNTd3pVenhNaGlSUC8vYkIwRWdqcWZI?=
 =?utf-8?B?cHkvd0RNbVg0aW5nSnR0ZEJtYU5CKzRERFlBbWxvZVV1aEV5bHgwbVBaU0Z2?=
 =?utf-8?B?TEk1RHpUWmRCbXBmUDY3a0NhenVHOXlnUm41K3BlUXBDSlRVbjh5cHdwcnk0?=
 =?utf-8?B?eHJzei9XbEhQODRUL1dYTzg4N0JYVjNUSzdzYnRsSXQ1bVZ2OEVVM0U2NjMw?=
 =?utf-8?B?Z0dpL1dkaFdDK1pSMXdTSzgwT0xTdTBodEg5L0VBUTgrQUY5dG1wRDUwN1Ew?=
 =?utf-8?B?Um55S2RTMlVWNXVSVU1KREgyZkdFNHFDNHFWb1J0Mmh1LzhZUG1qQkRlOVll?=
 =?utf-8?B?ZzRGd1Iwd0JZYXI1VGs1cis3UVVhVjJlb0F3aFNPYnJ5Nkc0WFdxNDZDK0lT?=
 =?utf-8?B?L2ZVeHJUV1pJdVlWSVVQQzh2dGxuRnRZUjkyUTdXczhkY3NXNWFCV1dQSEZC?=
 =?utf-8?B?dThHRTVmTkllZm9qRUdqelJoVmtuVGtEMkt3clRlZTU0YTBPbFlKSEJLTlBK?=
 =?utf-8?B?NDlqVjJrdkxWL2x6MkloM2FESFMwaTZWazcxN3ZhRzUvc25ycVRJdy9wR2gr?=
 =?utf-8?B?K3dBNUEvOVVLLzVVUmlKSmpCZWJ4N2VuMEpGejdQSHhrSld4c2ZmblVzSXZx?=
 =?utf-8?B?ME52YmE1Nk9raS9RbGxoU1dPRHh3NXVQME5iZXJDRjFoVmUyT09FOXB5MlFG?=
 =?utf-8?B?cmNDMFl6ZWhydG5VVEZGcXdCM0ppUDlIMktYM3M3VVRxbFhCd2tOL2c4RGZx?=
 =?utf-8?B?NGU4ZURUaTlqWDd5L01qQkNhWW9Va0NGbEx2ODRnMUpQbUgzb2dMTzVxQUZ3?=
 =?utf-8?B?bFRVbHYzUzZkTDFBR2VUOEJwOFBvMlh5WllKVlYyanlOcWlKWkh5V09HL2lG?=
 =?utf-8?B?ZlByUW85NDFwNENGNkFVcWtXK3J0Nk1PU0FyZDBNVDJQZEZDbE5EZ3ZqakQv?=
 =?utf-8?B?c2xwbXRCeFlFRGIzeVVUNlc1aTZPZlVPZ1ZtbmRXSUxBUUIwTTg4UUdxOVo5?=
 =?utf-8?B?MHp5Rm42ZWpnMmRtK25BbTNlM1U3a21wdFp0a0hMYllZZ1RHZnFtSFVYVTNZ?=
 =?utf-8?B?NHM2b09QUWtSTVVEVG9JVElIdUZEVjVnRlZvdlJ3UEIvUURTM0FaZllPK0Qy?=
 =?utf-8?B?UFczMGt0L3dkMGJQbEtwbDdDdVJNQ1hvMGRZTXJQbVd0emlQTVRHZHBEMW5u?=
 =?utf-8?B?RWNnWm82Q2o1MVg2TVN3OFl2RjFpYVkvd2FSTUhyWTBiVEVYU0tkTUtkeHVO?=
 =?utf-8?B?ZlZaSUZCbElWL0hwR09MN2lwQ1N4MFl5KzlqN05jZVFiMzlSMlg5TDBmVE5K?=
 =?utf-8?B?T0FndEpDV09jODk3TUQ4SXI1UnNTSDluc1dOYWpDaUN3UmJ2ck5PbVR2V1A5?=
 =?utf-8?B?dWs3UW9WR0dXNVBzYjhKelpmem00ODcxVjdwQmR4SG5wN2Yxb2N6ZHRIb216?=
 =?utf-8?B?MlVrQ1ZIZ1pnU0pHSTNLaCtFRWVUOE9mVW1lbUkxWXl1SXV5L0puMGVXeDFW?=
 =?utf-8?B?SGFRVklUMGgzcFZMYytlTUM3WmpyajNEQVQ5TWxXM25hVGdaWjdSUXNLTzNt?=
 =?utf-8?B?UW0wekFnWndmc1h2SWZqcGNDclVjNmRzT2x0NkFVTmd4ZS9CbDdlVWlxVnNv?=
 =?utf-8?B?TlV3RUVJM2FjUUQvQzY5b3BvVWpsdlI5bHlMMnRzWCtXTER6TjBSTm1MWWd5?=
 =?utf-8?B?ejNLL2pXVU5FZXhFRVVxK1VreFlLbklRcEE3MXdJVTQ0dlJwZmNTN3FINFVT?=
 =?utf-8?B?Y3hsVktyK0lsYkZEMS9YSDV6aXQwZHVlazlnMmwvTyt2YmRlUHRlMlRrQ1lp?=
 =?utf-8?B?U0NOMVZJYjQ0b3pPNmVENHpxL2FCMzc1VjRaVFJCQWRqM1ErV2h5OERiL1Qy?=
 =?utf-8?B?OE15cVJCVDBOYkRZT3hPQitDYTczRHp4UWRtMkl6Y21IemxpY0hxVWlFcTh5?=
 =?utf-8?B?N2tibDBDV1ZmQ0ZVRTB3RkJoTUdPTEFjb0dmMG1EN0VkTmM5Z0JjcVBkRWZN?=
 =?utf-8?Q?TAE4IHKZhq1qUeh8xLd8SbLfiXRmTpBxNGvurs1NePlle?=
X-MS-Exchange-AntiSpam-MessageData-1: BuaLX3SBYWz/3g==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16ea577b-555a-492e-5126-08de54e3f831
X-MS-Exchange-CrossTenant-AuthSource: DS2PR12MB9750.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 09:45:23.3805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VioOc9hNh8VdTdYqiGB/M8OsdUqAudjk7a7rKaF/Bd3t8UTpQaph8QRKtdtaUd7nDQEEBCXC2ai5CGA9ZVwHzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9818

Hi Greg,

On 15/01/2026 16:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.198 release.
> There are 554 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.198-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
> Wentao Liang <vulab@iscas.ac.cn>
>      pmdomain: imx: Fix reference count leak in imx_gpc_probe()


I am seeing a build failure for ARM with multi_v7_defconfig ...


  drivers/soc/imx/gpc.c: In function ‘imx_gpc_probe’:
  drivers/soc/imx/gpc.c:409:17: error: cleanup argument not a function
    409 |                 = of_get_child_by_name(pdev->dev.of_node, "pgc");
        |                 ^

Reverting the above commit resolves the issue.

Cheers
Jon

-- 
nvpublic

