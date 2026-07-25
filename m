Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE326233938
	for <patches@lists.linux.dev>; Sat, 25 Jul 2026 02:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784947420; cv=fail; b=cFbpnv/EDdgqduCfGQXVyXrg1R+sIBdgylmJ++cKh6ZZQvK9Mo/oIBwzRoTvUZhMH1/MDzHTB8VF0gGBeUh1ylyxStVgLcxDrAR3T6RH7c+PH0AmUHIBmrX3bDulUdOwf/HlxOjK5pvEWE6MOASyFEUQp9MrAb/Y4ElQSjLl0Y8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784947420; c=relaxed/simple;
	bh=9R+P+rykiSTA5P5hIm9XnU3siZdfSFns0gVaqYmPTmM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SE0M0HKU5BZTDxZVoAWrwQSH/5p38NP7IAeTLsaKV1FrPOnK8ebb6pxmeCfqiViP9kkD2Cf71F48Unt9qSliNOcUF8bf8ypY9fdnhu1pPF42PZO0W/QfVfPgLqomqgruHCvXbQ61p+NHK1jJu3434oKHXnta4p4WunbUIbPVFFw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=EsC2f38G; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="EsC2f38G"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66P2bSiS3376257;
	Sat, 25 Jul 2026 02:43:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=SyOuIchCK398p7e5QWgha2Ln46gB0baBYq8ErxKXMac=; b=
	EsC2f38GgSOkQ8mISw8lHpTfYwIqODryON6QIZwzwDXZ10G/8TTSu0bi7RfpTaWT
	Tm7t857MFOH2LLGSGHoIDBcL1/ijrMFg+CSORg2p09rP57yk9/r2Aoi7QOwdkgTG
	EHUK7kK3IL2KX8j2Hk3AYc29ZT8bCJVdY+ZZIkDhVkf+wmf5QpeYoWK2YldlDd8+
	s2rErmAdD7wBIsx25tZUK/acynS1T62DguDGLkVhKlYNcaNAdZuiVzeXswa2DLsZ
	HaZCJSVLKfUo0NimEjXvNuEX8i+QiVf8vZaYI7TqHlccJMNbLSQD6PCpk8NsW7a4
	nF6n8gxB/y9jR4YLCU5Vhg==
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010028.outbound.protection.outlook.com [52.101.56.28])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fmjnfr2fp-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 25 Jul 2026 02:43:28 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=loP+apgJNvIBbaO4SwCIvvbiZkhThz/4f9a7vUY7DvjRakBSnKOTI4BkEgVX/R+rxDTsS41iwD5KyHrbztOdVwEKswFSE1YK4QN1PbpiajfFWjd0OKndGTujRjoClMNOSZruFdL/Hl1lk16szzUrXeaZmj1Ot6fcV30k8+zNXfU/VcW+vszLogdmRmx0WPUiK62IE6ubMt8sTJAxTgy8tGuzSPt2/dlMIPaVXpqBtkh94coXBRBEZ60F+ckXDR130U/Vdd4syjnGskaWK2d1sGMQSe7ygWNMNQV2vEsuNU+e5TAhx6O1cFtXNnXMFmSAhdNHJHWWo0bM8xp70kJZMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SyOuIchCK398p7e5QWgha2Ln46gB0baBYq8ErxKXMac=;
 b=dFVtwVBeVtP/eiEhhzJ3OT5WxhVn4lqqn9E3mggwZayC7DR3ThKrzCqRR5gsNUrPGsb7IjLTL4801S5RHu+a9jhNN/4EavvjgbPcfkQKGYYV2RdAMX6iMriBv0we8g6fcBJKYwfBQh5fhmT5WrLWGyjOXhXxCMvZwHLdDeiODTEctN8Kpetos7zV5NhnR2MHLpPReSbXGls0EtzdTjYS5JKh0Fve6ZZ8oJpFlJWivomWGSJsQwXFZUe7FFSe367usxTSfsFaW6WNJg9AgZtPaNqDYZptXal9Kr6CRo+5vIAKiGUBz0YTnuitXoCvnxuDbALF9NeGh0eEwB3GF0uO9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by DSVPR11MB9578.namprd11.prod.outlook.com (2603:10b6:8:38a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Sat, 25 Jul
 2026 02:43:25 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0245.010; Sat, 25 Jul 2026
 02:43:25 +0000
Message-ID: <26bb37e4-e696-471b-b313-8c4e24c4884d@windriver.com>
Date: Sat, 25 Jul 2026 10:43:18 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12.y] ext4: validate donor file superblock early in
 EXT4_IOC_MOVE_EXT
To: Greg KH <gregkh@linuxfoundation.org>
Cc: harshit.m.mogalapalli@oracle.com, stable@vger.kernel.org,
        patches@lists.linux.dev
References: <20260724143828.1668805-1-yun.zhou@windriver.com>
 <2026072404-cultivate-cohesive-9fc6@gregkh>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <2026072404-cultivate-cohesive-9fc6@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SEWP216CA0124.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b9::11) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|DSVPR11MB9578:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c25cb0a-c7f0-45c9-e5ba-08dee9f67fef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|10067099003|4143699003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	uECkz90iK9JeSHBRYbhkGzNwNLmHkM7SThVzbnVMff+tyCNdqw1gte7slTqOMYc0ctxGHbCR0wDov4QY8lfUxGskNuhdFB70Wj/jiBuYwc/nNvxC/BX6HZq76QPlqW1yKMk7c9nX3C52u4Wn+0iujeUW9IVHBt1p8y62abChStHIsRf4XZidMDrLkK97KDLKNDg01OFDOyTGNQNkCz37vW42Iv1qkmOQNv4AdonERVf4UDElAp+onwlAiYqZRRgSuqE0Tg3TKC4BPc9LCN/cfn7dII8Nwz6sHTDsw2EEWnbIuIJUpVPgfpeaL7wCs4RfwINKN1CKOppnBiZ8SGLjXlQwDpmTDA0ZjtsdI0dP1D2xGpG9IOXp3T2Q0k6u0QSPYCwQSU/GS0BM6HQxTOG98tJbaapoExTX3NPVuTM90WQ95s93iP8xxEZQdOUcNAssprpQbvsDkeOQIbjwTFo9SNH+nNvFsAfIoYfPlfBUve2yBbESu4AsSZTExT8K6qNMzAdiI46bVw5U2gvmlTNw5HwytdHqaRUxfIpLddEABHi5JM8kXwt6ZgS7y7qHNEfRUlt85d/4CTBwMAqdunHThdSkBzEX/0ihOJ5qs64NN78gwT4hyGfX6qyOQmBYqjKlDwLqCYq/Dtkk/hSroFoLV0yxvS2P4YNgvOru7CI4SP4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(10067099003)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UXRtTVRETHNodmtlSTMvdWd4MWNpQlVkUUVLaU5wa3BkNkFqZDVTemRUU28z?=
 =?utf-8?B?ajhGR0g2U2lmOElQNC9HbHRPVlNTWjVVa2MrWGlKWkJ5cEFkSk9WczZ1anhs?=
 =?utf-8?B?M0pQeWJDOTJ0NmFpR3JLbENQVHdSSDN4N3FVNDVOKzZFOC9QcnBGZHp0MEE4?=
 =?utf-8?B?a2hjY3VKTTJzWkxZQW9FcHJiRThoR1RFczB5S1lhSjBxSkdSVzhUQWVPb3l3?=
 =?utf-8?B?SkVDK1grb1RtZEZqN0pabGJNSFcrd3VOQ3d3MW1xVjNQSTh5NkUrZ0t0TDJP?=
 =?utf-8?B?aWNwWU9wNE9LdnRMNEhFRXU1RXBoWGs4cE5UcndDYTcvc1ZMcGh2cTlheVBI?=
 =?utf-8?B?eE1rNlFzajNCY3ZZdE5NWWNxZDNIakp3cjNtaXluWXNMVE04ZkxGWUlmVWJa?=
 =?utf-8?B?b1BsRmw2N2VIaldPOEFMVnNRRXJiQ0psczhKZlBnNm9POHQrd25hT2dTVGp6?=
 =?utf-8?B?eCtyQWlXQVFnN01UU3lVb1dCeXFlb2ZKZEVQdUUvcXc2R0NRdDl5NzRORzlq?=
 =?utf-8?B?M1BORS9EZjFXTXNQcUVPb3FNTEdjZVdMUkZUM1c1MmxWS2dqK0h0Ni93VkZC?=
 =?utf-8?B?V2xNNzVYdCtjY3JqNTV4WC9tRnlhRGlNQlYyRERzVzE3Y0NsSDFmbkdDektn?=
 =?utf-8?B?aFQvVHBpRk1pMS9kaVhVaDVVZ1J5SGtlMHVCQ0hNMVlORENLczJNNTRaVWx5?=
 =?utf-8?B?UXN2ejlQMWpzMWlSQ3BNWWpUbUtwa1VjcXZkZUxOaVI1MG44TEhsM2xJd2dE?=
 =?utf-8?B?bGppcmY3T05CS0R6aDRuYnRkYzc4MFZFNnR5VlBqM24welRobkxNYzdLcjY0?=
 =?utf-8?B?TmUyQ0oxMTZZRk5NSmNCQW1kUExWejFXRVM1SUMzSEhJWTIyZis1M3o3WmNl?=
 =?utf-8?B?M29OdTdYODBXTUZ4MWRPVTlBVUhOeVE1SDR4MHlmTzdUNGtSUkZ1eFA0dFdo?=
 =?utf-8?B?TzBCbU9XaTMzVWgvU0p5eGcvOUFZNlVLV29QQ1RJeFM0bEQzdXBWVXNTMGJa?=
 =?utf-8?B?cnI2cUx1QU5td09tZk5KQXNBVmVLdDRjdjRraTBoTE5wRGtZNDhXbDRlSzh5?=
 =?utf-8?B?bHZFQm5aVVY5aDBIbUxPcXdiYlFiczRwdkNlRFMrQVBOSUExRWxyV1NJVUVs?=
 =?utf-8?B?K1BVU3Axc1g5K0tiSENtaVNNdUFPMGx0SWhENkhKNVBJdWRSWWdJU3NPY3p3?=
 =?utf-8?B?MGpKdlVWNlUva29BdzZJQU9CMzQzNnRnWEZCRmM3MGVVeHNBMnVIOTdqR2Rm?=
 =?utf-8?B?ZlhyT1ZuaGtvZFNLYU1OdXFWdVVHc3M3NTlIa09QWlV5bXcwN2FxalBpK0ph?=
 =?utf-8?B?c2J4aktwTHlNU1dqWE9paERhVGVWa0MzY0dhMEM5NWdPU2dUdDlrVDBrd1No?=
 =?utf-8?B?RWNRZmpaQloyWkZkRWd0b3U4KytyMGxGSmE2RzFnVHh6RVdFNWNrK3M4ZW1y?=
 =?utf-8?B?NmR1c1pHVjFjbG1FMW5TL3hOR05tOUd4Z2g4ZFMyWXpleGdZeGpiUXRURDNV?=
 =?utf-8?B?SkttZVdwRHYrWlUwUlNVOU1PdE03Mk1Pa3dzWVVLcFVVaENnd2dyd1VpMmph?=
 =?utf-8?B?SUN6TktIbHJBTGRndWVUaVJLak1jL0hUYlQ1M3R4YXFsc0lhVnV2NlY4WlFB?=
 =?utf-8?B?SzNzdWJ3dHFqVXBMenlhTUt6ZkJTa1BQa0VDQklJdVhUMXY5NW5GV1ppZmlP?=
 =?utf-8?B?dVdWMEZxaWlaSHFYaGY2VHA3YjNadXZGOGlZb3pYeWFDdEFJaFVSYzhsbUJn?=
 =?utf-8?B?dEtmTnFscFRoN1lzRkpVUk9sRjdwaUVKd20rYmtxSXd4d29IdklCQmQ4VFlE?=
 =?utf-8?B?QzZsOWZSM3d0NjUzVFQ3YjBxYkR0cndQa3JsS3VqSVhKbkZYaTFqcitaNFFm?=
 =?utf-8?B?WnVmZ010ek1RdjQ2MVBQcElTTGdlbzd2NE1VQWNZckVEc2pIU0l0eGhyeUxG?=
 =?utf-8?B?dzBkLzVFTzVld1RTN253Q05CR25kMTN6M3AwRERHWTYzbWU0ZGhNd3BrWkJn?=
 =?utf-8?B?T2NYM0F1NXgyV0FxSHdFRGFvN2tOaVFGcGNtOUdKb09rK3orL05YSmdaWUFI?=
 =?utf-8?B?a3BuYUZPVm1OcUlNZjNCb2t0RUlMNk9LaEJuTDE1Snp2dElaSGRiNjVHU0pZ?=
 =?utf-8?B?WU1hNWZsV21LQ2hTZ1FjM3ppMnlOSFpRaHNsbnB0dU5jbjdMRVdKVUViS1NZ?=
 =?utf-8?B?Rm0yVDZhSSthNmk2UUdkcEJqM0pQV0hFblYrdm8xWTlwZDdqWmMvOENmZGh4?=
 =?utf-8?B?V2ZBQ3BQU0FaZDBKaks5T2hRdUUzd3BtTngwUm1PM1F4KzhtRUh1TU1yQVMr?=
 =?utf-8?B?a3BuWDJNWWdyUnhRQ1dyZDJoRCsxd2ZMa2Fua24wWGZVTmtoSE8zQT09?=
X-Exchange-RoutingPolicyChecked:
	d8fDRaBH3tWJhBg+fLl1OEq9JBlZONATNWtCkZ7xmwNPfsF0BzPUPcKWojNH6LysW0hkjEdKXpYWtmmWeQBhRRw4PMT/PkKR/inxN2LBBKte+GOe6pYgGn9+DwUSlWb7auCMm4aTpw8NDwrM+76u8TvEZzsD7gfV9cVghdiBa5JetvNW9WeZBXOdwF9eqLSkjeK9qDSbe8eJkSWbMiV7STQPeBuswQyAaNbmZTeXxM4irIdJv58ZTN29ZrFw1nR6nTWVRueWGkK1M+0eWw04RMzlMLv/85KXV0lds1u38dHuJsiEBPa+rG2xdwF8GbEgCdA9Y3M/YHwS67l7C9ZHwQ==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c25cb0a-c7f0-45c9-e5ba-08dee9f67fef
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2026 02:43:25.1912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9TesyRVzNUM3Jkru6y9icr+ZMwG+liafvZM8ajC3WhUUjbEv5kLYQVQRX2cEdDNyV9ap3OxzJn3LClIYipcpLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR11MB9578
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI1MDAyMyBTYWx0ZWRfX5mWUcyW/epUT
 ubNmOaXoe4RPInmL/qXSvjpGCPOC0PTthh72Nnqp1ZiU12Uzqk0ctcKdBh/7ty8iox8oZiG5ncl
 e0PneX2TAXXAQstua7F6HXYKuowzRrHGlIPDbr8qKuwD2c1ZfsL0
X-Proofpoint-ORIG-GUID: xlkAlYvjXltpvCPeTWmi8PXnMmdZ1NzP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI1MDAyMyBTYWx0ZWRfX2NuFG4Imt7WA
 pzR5qdlt8gz1IW1dIbUfLNmj6narlbYtGTNpdJbvLnqj/QP0S9QqxLhtBULfq8uXvc7qKg5tClH
 QDiyqxJbIYzqUMsE1OU4pBI1uH/2sX8+g6DnaoENaQxYWN/RhDKDEG2V+mSGlVRb7NYHJAada6u
 mtgPL5UIgYWDIO7yyo8hJ8wMpkbFJtDZ6eq7rTtXmsRkbbaCdNOSgQQW39QdS0d7Yl1ZndaTz6J
 9UJonJM4GWAey5CCloBchm884yypei+StdUQT90zd/Ry/RLr959re1gSJmogYhpKaKTViKIhI20
 KAj5sdarLszUVGcxGdnB1vG951QFX22U5UI8MW/80GZ+rMnFdSYQ4Ntw77TBmqv5DN1k7RttY/A
 cmVi8gu/L/VhAj0WQmZx6CROoZh/i9pe776dY1D2m3D+ZS1L951322KUa+aF+64ReQ2cz4dRMVn
 Ib0jdRyuR//dsKLZQ3Q==
X-Authority-Analysis: v=2.4 cv=MuRiLWae c=1 sm=1 tr=0 ts=6a6422d0 cx=c_pps
 a=M48x8qJemVpu2SzQJjJwbA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=klDOsUkWDRETUCZYPvoE:22
 a=vei-FXw39r797DEseDgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: xlkAlYvjXltpvCPeTWmi8PXnMmdZ1NzP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-25_01,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 malwarescore=0 phishscore=0 suspectscore=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607250023

On 7/24/2026 11:26 PM, Greg KH wrote:
> 
> I already merged the original, can you send a fix-up patch that I can
> just apply instead?
> 

Sure, I've already sent it out. My previous understanding was incorrect.

BR,
Yun

