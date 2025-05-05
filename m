Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2084.outbound.protection.outlook.com [40.107.236.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1961F37DB
	for <patches@lists.linux.dev>; Mon,  5 May 2025 08:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746433535; cv=fail; b=pV09fR+85YLWybYItc0q4i60ag5JXmJ6rAlCF/VXaLsIAxEHAiTU/1QQk73po5g9avkdE8AMxk/iUKlBQLn6Lxhh/KM1CWnMSx8YSK0aLsjytl6sKpH4aR1LuuwZ0Q7yPO9lW6S4wz+jj2Zd5+shQ0Yk/3XS67hk1Hh02WGJZ9g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746433535; c=relaxed/simple;
	bh=sWVfeMuqernnqXwaxUGrQytQWC0Y8OO8txlscgJJDf0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kVkKZS+P9KI5EJr6QUmLa7sYZdntmW1Z6mOsU8/MEsGplM//9SP8nll4xoLJ1e7CRAV8UpqHjnbrv7Z72nUzXDI1DIDrGmDssK8v+68+fVc/o0kmo2RRMnaZGYjltlLJgqLXtX+0W146Mbb5G3AfKNV6Ugaq+lSoxbTPWCyraPk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=A5aK7tou; arc=fail smtp.client-ip=40.107.236.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="A5aK7tou"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YwgtmIoFXB/NKB1ql5NWOSMckqR+v0m1WkfsI/cqGPa7Aj48Ma5jF1BbhVuPs5cSSbHSXVHcVyjo/xhJedmKac++oNqfyYdP8mQmqXAUMafh2gMJrl+/TfZlhVpXc23FVGp9TZ11RuxTGYowlvw4qsRdgeTYUGhn+93b9jij0gDo+pt+SgF/aEPfNf7tcoFR+h2DnORJhzeTreYeI+bTrnxdlO70JCmUW7vBPYEP2no6WTaJvAKZT+TvOFhktmn3GWNM9I0E5VT2Nlmanh5fNf1hA+Zxnz1Wm2b06g7m1rt8hrQMSU5BDgq9Z0hMs8esjbhcSToX2Wcbc31dRR/f6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jNO3MN6t/pkw3PubYJQjYeSR7XXIxcP8c1aai/9IMec=;
 b=TN8wZQ9om2bZmCBe5qDUrD80VGj1yP4zXUgbhNoQTpnwd1Bhsg0FCIzmOl8Z3gINynZSMbEGc8XZHb4UPPSkiVHOtmVQHO4JyhNlG4mlcGHAE6RKcFzCpDbKijGV1FhinpCqNHoX147G8jbgXpQVDrtLhxfsDY6OOcjPUdVtHPZrD7cSaF0PSATclkj+4DxhtaO1P6cYxQtFjw86vJwcpsC1oW9qZh5XTeZDxxSj3fahkxkE/CVNJN3S2y0FgrK2aKGQz2d54vz8G/bCTTzFtWlRJcLOuyfet8LITLf7IzPQMwm3qLIGNQtWdfAUlDWga4sGLehlJvj+aG4PPM6CFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jNO3MN6t/pkw3PubYJQjYeSR7XXIxcP8c1aai/9IMec=;
 b=A5aK7touRDJYuSt/BoCBCpbe9nQ7QOP2N11vaIxGXF4Gh1+DQAm+3trvbxwjIpZ9K/Vaenu0Oag6AErL+5cHul87BaScqYa5hyAAGFEgrDPVCqrmFjyXBLaVyOP6WPBRlJ0v0uYD2zzsk85c18OhaViBUn0iCV+lz7cm0ly6tu4wWYH+YDXW73GMFl8XzSuuNVzUJOJmveYkaQ8/TpvtZoNwo74ZK3nBFmjNtTV3yJCt8OdLVUB9wz2WPu6d/Aq5ySBcMTzvpdPmFeNSKjhzVMozoREZ18qrbjX5bSOl/TfqPIbN9lj6jITfEG2pXdYs+BEQr5K73lAyvf4HL/zUKw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6363.namprd12.prod.outlook.com (2603:10b6:a03:453::9)
 by SJ1PR12MB6315.namprd12.prod.outlook.com (2603:10b6:a03:456::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Mon, 5 May
 2025 08:25:29 +0000
Received: from SJ1PR12MB6363.namprd12.prod.outlook.com
 ([fe80::bec3:4521:c231:d03b]) by SJ1PR12MB6363.namprd12.prod.outlook.com
 ([fe80::bec3:4521:c231:d03b%5]) with mapi id 15.20.8699.026; Mon, 5 May 2025
 08:25:29 +0000
Message-ID: <843866f8-059a-4e5d-8316-19c92ae25a82@nvidia.com>
Date: Mon, 5 May 2025 11:25:24 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 092/311] ublk: call ublk_dispatch_req() for handling
 UBLK_U_IO_NEED_GET_DATA
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 Sasha Levin <sashal@kernel.org>
References: <20250429161121.011111832@linuxfoundation.org>
 <20250429161124.815951989@linuxfoundation.org>
 <830759ad-243a-4fd5-9fa1-a106e6e6bb0d@nvidia.com>
 <2025050455-reconvene-denial-e291@gregkh>
 <744b4d9b-24f3-487c-805f-5aa02eaa093b@nvidia.com>
 <2025050509-impending-uranium-ccba@gregkh>
 <c5022682-52e7-4340-995c-7d3d84bb77aa@nvidia.com>
 <2025050537-flaring-wolverine-c3fd@gregkh>
Content-Language: en-US
From: Jared Holzman <jholzman@nvidia.com>
Organization: NVIDIA
In-Reply-To: <2025050537-flaring-wolverine-c3fd@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TLZP290CA0008.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:9::20) To SJ1PR12MB6363.namprd12.prod.outlook.com
 (2603:10b6:a03:453::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6363:EE_|SJ1PR12MB6315:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c0ec0f1-6d49-4cdf-ef9a-08dd8bae6537
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TFJsK20rMjFYWXRKR3ZTT0thN25BREpqMmZxZ0QySnpBNW90NHpQVmMrNUNB?=
 =?utf-8?B?UW5UY3RNWDhSd2gwOVI5SGdNaTFvMURHV2V5cWpkYjdWUk4wU1FjWGl0Uy96?=
 =?utf-8?B?a1U1QldWYUhSMmNuaHZoUzJ4a3R4aW5yeTF5bVhNYjBMMW5LMDlKYTltZ1Bv?=
 =?utf-8?B?L2E5MERRenR1eWRCb1B6QURTUXZJSVdKUkgxVml3RkVmclNJRFgzOWE3YWN6?=
 =?utf-8?B?ZXI5Zy9XMmRHRzUzZ3pHRUVEbVVmcGpsSml2NWRveTFLMDhxTFBnYnhlZmlV?=
 =?utf-8?B?cFpDK3JhbFE0MlFVTW5rNWV6UnRDemxma3RvbUMvdys2L3Y4bnhnUEFGMG9H?=
 =?utf-8?B?bzdTY0hPNjRENzJSb1lHTFRnZVV4aXNFWXBvYjNYUGVUeFpGdmhRTXJuUTlT?=
 =?utf-8?B?NjhWQ0V5Y3lJYXNCVjRyRTdIUFBlM2F5UjAxYjhTQlAvdWFpTS9nMVI1V3di?=
 =?utf-8?B?eWJUaWYzdjYwRG0rT3F2OGprTTJHQ3c0Q0lySHhJUG1YT1pENHRDK08yU2V2?=
 =?utf-8?B?NzIrVUNxTlFJSUJCWjdYd1JLTlFHYlFucFRtaUdPc2VyYk5WMnU1KzdpUW4z?=
 =?utf-8?B?ZUFNZVNseGI5bFZiOGphYmFnSng3MFZIY3hjMWdXSW1jZHlERHRpcmxSRHA5?=
 =?utf-8?B?OUxnTmFIZkhCNVV3SnJCY0lXTTJCSVk4RVFZb1lOSWY4SUpwLzM4eUc1eWVp?=
 =?utf-8?B?bDNsdkRQdktnT3BKQ0Q5YmM4bWNPTlFQL2hSZ2xOTEI4TWJwVUJLTm5rbmVo?=
 =?utf-8?B?c1dnODdkaS9WMkMvR29GZDlxMG1vNG5KWnVvK0VVcS8zSHErbnBYT1IxZnor?=
 =?utf-8?B?bmN3UythVjVEWCtwVkY0SDN0a1AwY3NLcWFONVJQSlArN1hYQnNRYjIyTkhZ?=
 =?utf-8?B?WnZlUklWSFNidWJTek9PN1ZnVkhIaU1DcjJBZklvZ3JxVmNxK0kzQXpOM290?=
 =?utf-8?B?cmVVL0llS3FSUUg2MkJFNktZeHlNQXZQdENOOTZnckFiSXJ6YlZDdTRZT0pD?=
 =?utf-8?B?akp4ZkdXWFZpUEcxTDE2MXNLaGtBejFSUGJ4L096cFlJU1h3VlpCWTVaVmc0?=
 =?utf-8?B?bDhLVGhiUm1PV3kyQWFNd2JXcVN4eThlcTJnRW15aDhxeGZhTllTNFhWOTdp?=
 =?utf-8?B?V2VXREdVOFNHQ0N5SEhIOHhJbjNybC9jV3ZxS0w3MkVJZTFBejFWUzNSTGRQ?=
 =?utf-8?B?bm53ejhCbDgyU2s1QnRod3FOTTZWcFBnQlgxdExkUGZWOFhnL3VPV2lmNHlp?=
 =?utf-8?B?Vm12NC9HUVczY05adVB1dnpHVXk2Y0ZjMVZ3T2dsa1N3SWZtVGgrSkdXZGgx?=
 =?utf-8?B?NzRjNlVlMkQ5MHNqUHdCcDlDaisyeDRJUEQzQVM5K1ViK1hCQXd0Y2ZuRzkx?=
 =?utf-8?B?N1VCelMyRFFUNEFNa1p2U1FWZXdIbkpxQnpURGN6YmwybUg2THFPYzNNVTln?=
 =?utf-8?B?WTVnMnN2UFNCam9jUnYyTmxKR3BjNXIwR3VURnAvUnFWdXM2UEdaTDR2ZnVj?=
 =?utf-8?B?KzFjU0tybjhoYm9URWphWTd3dzhON2J0aVdMNDdseUpOWllUVWsxU0wwbmF6?=
 =?utf-8?B?cGZZMlkwSkh6WmcyTjVtaGhtcHg0R2pGaHhxRVhCUk0ySjZmM254L0tVdVVo?=
 =?utf-8?B?VE8rS2djaUM1YW9FRmZDOW8zR0pDOVlhRVFjbWQwengwZ1dYZW55akxZYXJP?=
 =?utf-8?B?cDVNOVdEOVdHbWoraGFyVGJSdnNPY2pKcm1EMGhuVzZPSWgrd0lwQUpuZ0Nu?=
 =?utf-8?B?Mk1Ub0ZOekgrMjZxYXdpbG5yVEh6V2d3U2J4MU1FQ001Y0I5dVVVZVBEdHdD?=
 =?utf-8?B?NzNmVXk0aW1kcWFWcklyN2NTZXA4WlBpMFErQ0RlOEZtQnkxMWV2d2JncFJy?=
 =?utf-8?B?N1ZxSW5iY3UrNVNDZ0lHbVlSYldXM1RLOEI2SVRNY3RPTVlva3dKNXBnSk9p?=
 =?utf-8?Q?mKpW8zR9xME=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6363.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eVh4ZlZPREs3Z1BoWFhVZHg1S09ESE11dURDWW9SVTNGLy9kK2xhWVhwa3RT?=
 =?utf-8?B?NTJwdEFzR3VWWlR6cm5abm1qMjQyT2RTMUkvUmlHRUMwWjM2M0ZhWnFxeTJr?=
 =?utf-8?B?MUdjQnlDSVdSOFpEOGYveTJuZGZLcTZDSTBUWWNPcmVNekx0WFdpUFROeHV0?=
 =?utf-8?B?SXFoOEVMVytzN2MzMHg2cWdnQU5IZXZIb1VXOEF6clFVaU9rMG45eTFVNnBs?=
 =?utf-8?B?alJFOVhXbldMeTN2UVB5L3pKYnlrSUtzSDJWOVdvSk5lOUhmZmdsSDdjbXdF?=
 =?utf-8?B?L1ZLSEVnRk1xZmJMWGdxbVRqa2VERUZ3RU5kQkd3NUxmRGkxM0FXWFloQTY3?=
 =?utf-8?B?NkVXcllTM3JsTDZxd1k4TFovbEJvdmxEUmFDQUlFL0d3c3NzOE9TVEFpU3hY?=
 =?utf-8?B?UVBXU0dpNFpJNnNyNlRFK1B6STM3blRwbWhQOWVZS0hrYXVPQXgrVHZGcXIy?=
 =?utf-8?B?YkxNSXdPM0srcncrcm9pbGNYdnpsLzhEUVV3NklnV1gyRDdsM1ZBYU9kaDJt?=
 =?utf-8?B?TFN6YjRTVHlyM244bTR2aWpuQ21XWm5lM25SYnFId001QUlnR3lNRXNiOG43?=
 =?utf-8?B?SGhyRHVuODdUNEhaeU1CeDlpMzEwZXNGaW9qclJZVFI1YVBMd29lYm1Yenpz?=
 =?utf-8?B?bHJTUklCbkRtYm5zdXI1bXp1eGlZYXp3TXkwTHdPbjNrTVBnQkJZVjZZc3Vz?=
 =?utf-8?B?N0dvZE1xOHBVRlplSVM1VWF6SDZiSVhkb3VxQnRxR3JvcXp5eEo1OGpUVmtj?=
 =?utf-8?B?RGc0QTdiYy95cTI2QlBpNk8wMVhQK0JaYi9PRDdaVjZXdnQ4aEIrbVNualdz?=
 =?utf-8?B?OGovVmpUZG1uYjBHTklTT1l3WHViV1lYNGk0MVJrb3hUQ203NlRIbWU3OCtt?=
 =?utf-8?B?a29Xajh0Ny9vQTI4NGlkWUh4aWQ3eTN4Y1lFSW5xS0hHM1lrYldjRmlSU2hH?=
 =?utf-8?B?TzdUd0dYSlZBcjUvZ2k4d290MW8xZWtWUGM3RityWnlvVlFRSFA1d2tSU05J?=
 =?utf-8?B?ZU1BS0x0T3RRanRYUDBiNERxR3pOVzQ4dnlJNHY2aGNpa1lOSm9pc3NhWWxv?=
 =?utf-8?B?M0tuUk1FckdWcmNTUDYrbGZqUnM0NXNnaHlKb3ZpOEpiMFlTWUdmeisvSkQr?=
 =?utf-8?B?eGtpQ0FOaSt0ZXd3Zjl5bE11YkR1K0d2Uy9kbmxyVUt6cm1kMTdFaWJZM1pZ?=
 =?utf-8?B?cnhzRlpxL2YyU3JtaUZiVGoyczlvc3JjTXhmZUxidDJuN0w1ZDQ3Y1JONms2?=
 =?utf-8?B?VHlFVkxPblE3TVJTdlBCVE1WcEgyZ2JnZlUrNmVPQWthb3VlWVpQUWJicWtR?=
 =?utf-8?B?NDRFMG1rbXFVQWh1YXJrUmdvb200ZTRoYjNWSngydFhtL3owY0xJaXdoZXlO?=
 =?utf-8?B?bmJuYVhYMDB5WjlhUitGZ2MzOFpBSXU0S2dkcHc4eXhJdTFGc1EwSXJyS2FB?=
 =?utf-8?B?NFYwSEJwMjArNDR3ZUk0VGwwUXNPTVRDbWNmbUQvc0Nscm5tdjV2VWlMUXdj?=
 =?utf-8?B?alpzampsbmpwM2VGK0NvRFpUV1MzOTVkVlFGZG5GVnphSUYzdHlRVHhKbXJ0?=
 =?utf-8?B?MHU4UWt5OG8xaWtFc2hnclc4MC9QY0twQW81bXlZbFdreEt6ODdObEdrTDVx?=
 =?utf-8?B?ZG9rUE1adlRVL25IRi9KTXJqOE5CaW5uaDVWekNWQkJsM1dTUTdENU1mZmdR?=
 =?utf-8?B?ZHRZNmlzQ0xRNHhyejZoRVNFM2RTM0tIQVN5ODVQVEY3akJPREF0bUZtN0ZM?=
 =?utf-8?B?RGVVaVdoOHA1bmV3S2FVdXFXaEE4NGRzZUZZaDJUdE9XOERhMVpNbDg5ZmR5?=
 =?utf-8?B?WFZKTUZaVGVEcEhCYUR5SlFROWtWeXBpLzlwYlFiOWp2ZDNaTUVtRG5NOHRV?=
 =?utf-8?B?eTJFVjgvenJ0aFlwSnRrTnNscWJkNngwT1d2ZHlTcnIramt3SVFtT2hlYUx0?=
 =?utf-8?B?RDEyWDcvTThYcDFPK0tpcnNlNCtUNU5rNlNac2lOWHdLRENNRzUwR0RSc1ly?=
 =?utf-8?B?N3M2L0gzbjQ1WCsvaGNiaTZGYzBLT01PNnNaT05wam56Wkk3a0pQb1Uya2dW?=
 =?utf-8?B?T29LUVYvanNoL2s0WjFZVUxpeExVRCtVZjdaWHFaWGZmcC9SbHZqNHlaRVEx?=
 =?utf-8?B?b0JCV1ZTYi84bk9qSTdZdkZhdVRlcjNxQ0NCRW9lellwRGRoS2ZqRUFQWm9P?=
 =?utf-8?Q?pSng0eMonrGkU7tWOch/BtCctERSK5vkX4qH5R+ulpos?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c0ec0f1-6d49-4cdf-ef9a-08dd8bae6537
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6363.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2025 08:25:29.8571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TQ8PNfaDwB1znTBOpZydJKvohiHRoO4fwnJXGUM0C63358/Lz2LkvWGF7ikkKGbzr/dj4T+44MhzJzRwlb5sOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6315

On 05/05/2025 10:54, Greg Kroah-Hartman wrote:
> On Mon, May 05, 2025 at 10:47:03AM +0300, Jared Holzman wrote:
>> On 05/05/2025 8:51, Greg Kroah-Hartman wrote:
>>> On Sun, May 04, 2025 at 04:47:20PM +0300, Jared Holzman wrote:
>>>> On 04/05/2025 15:39, Greg Kroah-Hartman wrote:
>>>>> On Sun, May 04, 2025 at 02:55:00PM +0300, Jared Holzman wrote:
>>>>>> On 29/04/2025 19:38, Greg Kroah-Hartman wrote:
>>>>>>> 6.14-stable review patch.  If anyone has any objections, please let me know.
>>>>>>>
>>>>>>> ------------------
>>>>>>>
>>>>>>> From: Ming Lei <ming.lei@redhat.com>
>>>>>>>
>>>>>>> [ Upstream commit d6aa0c178bf81f30ae4a780b2bca653daa2eb633 ]
>>>>>>>
>>>>>>> We call io_uring_cmd_complete_in_task() to schedule task_work for handling
>>>>>>> UBLK_U_IO_NEED_GET_DATA.
>>>>>>>
>>>>>>> This way is really not necessary because the current context is exactly
>>>>>>> the ublk queue context, so call ublk_dispatch_req() directly for handling
>>>>>>> UBLK_U_IO_NEED_GET_DATA.
>>>>>>>
>>>>>>> Fixes: 216c8f5ef0f2 ("ublk: replace monitor with cancelable uring_cmd")
>>>>>>> Tested-by: Jared Holzman <jholzman@nvidia.com>
>>>>>>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>>>>>>> Link: https://lore.kernel.org/r/20250425013742.1079549-2-ming.lei@redhat.com
>>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>>>>>> ---
>>>>>>>  drivers/block/ublk_drv.c | 14 +++-----------
>>>>>>>  1 file changed, 3 insertions(+), 11 deletions(-)
>>>>>>>
>>>>>>> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
>>>>>>> index 437297022dcfa..c7761a5cfeec0 100644
>>>>>>> --- a/drivers/block/ublk_drv.c
>>>>>>> +++ b/drivers/block/ublk_drv.c
>>>>>>> @@ -1812,15 +1812,6 @@ static void ublk_mark_io_ready(struct ublk_device *ub, struct ublk_queue *ubq)
>>>>>>>  	mutex_unlock(&ub->mutex);
>>>>>>>  }
>>>>>>>  
>>>>>>> -static void ublk_handle_need_get_data(struct ublk_device *ub, int q_id,
>>>>>>> -		int tag)
>>>>>>> -{
>>>>>>> -	struct ublk_queue *ubq = ublk_get_queue(ub, q_id);
>>>>>>> -	struct request *req = blk_mq_tag_to_rq(ub->tag_set.tags[q_id], tag);
>>>>>>> -
>>>>>>> -	ublk_queue_cmd(ubq, req);
>>>>>>> -}
>>>>>>> -
>>>>>>>  static inline int ublk_check_cmd_op(u32 cmd_op)
>>>>>>>  {
>>>>>>>  	u32 ioc_type = _IOC_TYPE(cmd_op);
>>>>>>> @@ -1967,8 +1958,9 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
>>>>>>>  		if (!(io->flags & UBLK_IO_FLAG_OWNED_BY_SRV))
>>>>>>>  			goto out;
>>>>>>>  		ublk_fill_io_cmd(io, cmd, ub_cmd->addr);
>>>>>>> -		ublk_handle_need_get_data(ub, ub_cmd->q_id, ub_cmd->tag);
>>>>>>> -		break;
>>>>>>> +		req = blk_mq_tag_to_rq(ub->tag_set.tags[ub_cmd->q_id], tag);
>>>>>>> +		ublk_dispatch_req(ubq, req, issue_flags);
>>>>>>> +		return -EIOCBQUEUED;
>>>>>>>  	default:
>>>>>>>  		goto out;
>>>>>>>  	}
>>>>>>
>>>>>> Hi Greg,
>>>>>>
>>>>>> Will you also be backporting "ublk: fix race between io_uring_cmd_complete_in_task and ublk_cancel_cmd" to 6.14-stable?
>>>>>
>>>>> What is the git commit id you are referring to?  And was it asked to be
>>>>> included in a stable release?
>>>>>
>>>>> thanks,
>>>>>
>>>>> greg k-h
>>>>
>>>> Hi Greg,
>>>>
>>>> The commit is: f40139fde527
>>>>
>>>> It is Part 2 of the same patch series.
>>>
>>> It does not apply to the stable tree at all, so no, we will not be
>>> adding it unless someone provides a working version of it.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> Hi Greg,
>>
>> Happy to provide a version that will apply. I just need to know where to get your working branch to base it on.
> 
> The latest stable release tree.
> 
> thanks,
> 
> greg k-h

Hi Greg,

I tried branch linux-6.14.y of repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/

But I can't apply any of the previous patches in the series [PATCH 6.14 000/311] to get to the point
where I can create my version of the patch.

Can you help on this?

Thanks,

Jared
