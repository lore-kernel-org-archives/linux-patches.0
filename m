Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010005.outbound.protection.outlook.com [40.93.198.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA324E5338
	for <patches@lists.linux.dev>; Fri, 18 Sep 2026 11:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730860; cv=fail; b=loX+9BSxkmGht2s1PR+qArKIEduo0YtEQyhyRu2OLOqEtWLwd9XbY6FQuHHM4vobC/aXSTiSsGW2mlOWzFzPmd65dW/EvYWCGxiV+BMXM7LJaGFjXnCqnQZxzcA02pN51mrUr/Dc8Ez2lnx5iW30e839qWm+gIN4Y39ZBX2STqU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730860; c=relaxed/simple;
	bh=ktqQOpODOcaHcmq7MS7l4e38phqt90FaQv+8OEtJymc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QPFXwtktlBrfXkFkAZ9Usu7Xz0O/FjXfYD3gslZz5ZHwok94rHcIgJkbaRvyDifVdTtsXjsWDg4gwWbVqtc9FvK/y6gJCjCDXLgBginMji+NYtSC0RTpDIZEI0GiXiGqtQ7RWfuXEx1C3NF3+TVCHc/AYlQA1LuaVQYQkge6hEE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=p6uIHAYf; arc=fail smtp.client-ip=40.93.198.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="p6uIHAYf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kT3NhW1/HcURtEL4UyGQrrtg8FO6Flt049q3O6twzchXJTIDM8ZhHPwa8K50BCI1LlEVULT6aW16O5xOKW0EXsYZWoCnj0yBkiwI0kEadRij7h7lX2mh8npTg/27hIjN1elZiyTFCDxWgq+tAti1kyxCNNuu5rJqdHgmXCEBrcS+1q38sh54FGqNNGYwgfjA1YQdBt+1eVcf/Fct/gQPm3tet7tSSdqX4dSvdaoQ2kOV4klTGFDjPNOOao7SXrqhkwxSAitICf71qVw+LHRDd28wejV1XhuLXltdF1fyWi3/r7wMLfGfGCGHpUC7T2z64NmFPLcLwa8uLN78hpCvaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t97Jc1vyYFPQeSsYSs/L79CWUrDGA4qg8Yxe9HbaQpQ=;
 b=HTBfyVenw/Tjn4PQp1T+pr8s9E8Wlf/5Sgm5lLQ/fmTBQ3V9ujxRl8aCtiZ0SzKCMBWKYhsYxnk0F4ZkLe5MJqW/pgB6dqz1DG4lq/it9xHWJdjmF7TCKDqIzdfxpVZK3t591wYiyzW/c1SiMhlXONBn7ke5V5+LHcp9ha3zfbPccbkDRVTBRn88XebRjupZt7K3bs5ljDyeF7RyDjMeEbS1uAzz4ydbfrzv6NFH2tiVsVXox4InJeqKcN1DnsC2MEWzzxLEkOowRNa6r9vPzHTPKqvbfvDmZUOcKH6b3hHAGiqPqbMY15lIY7Vw3XIVeiwAGak2O6ocGdHQ2CQmag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t97Jc1vyYFPQeSsYSs/L79CWUrDGA4qg8Yxe9HbaQpQ=;
 b=p6uIHAYfy/sFt4Jx/wKpqdSPRfRoUKiYEdMXqxP7Ph7vM78p/VwzPm8nyQnYTP2YntzRDjHij8oo81hNTUOKUMqxLpJ+btIrqaWSh3LaJyQwIgTv53s7wydJy4vpeRA+lJYOXQqDGpBnSnc0sIlDoU0XW0gyOFDSzYNwatSML7UA5dhjqWk2O41ARnLI3VhniX3SYiQa0vt9xCppPafqmA2CkL8qlIXIxuwa2gQ605taXDN4+cFP5dBHNU82QsuKKGz4CGsydMO86wnN3q+nMRA18GdyYlArihEfXwqp361hRy5+EgxWmXD+a3d69eU6fj87cE+f0kQA5dcgsNBymw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH8PR12MB7110.namprd12.prod.outlook.com (2603:10b6:510:22e::11)
 by PH7PR12MB5782.namprd12.prod.outlook.com (2603:10b6:510:1d1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Fri, 18 Sep
 2026 11:27:26 +0000
Received: from PH8PR12MB7110.namprd12.prod.outlook.com
 ([fe80::736a:e1be:ec64:5740]) by PH8PR12MB7110.namprd12.prod.outlook.com
 ([fe80::736a:e1be:ec64:5740%6]) with mapi id 15.21.0428.009; Fri, 18 Sep 2026
 11:27:25 +0000
Message-ID: <8cc48d19-ccb9-46f0-92c9-b26916a349da@nvidia.com>
Date: Fri, 18 Sep 2026 12:27:18 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0000/1102] 6.12.111-rc1 review
To: Pavel Machek <pavel@nabladev.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260917151539.408551884@linuxfoundation.org>
 <aqxLGIyiWCdsQoyR@duo.ucw.cz>
Content-Language: en-US
From: Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <aqxLGIyiWCdsQoyR@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0277.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e6::9) To PH8PR12MB7110.namprd12.prod.outlook.com
 (2603:10b6:510:22e::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7110:EE_|PH7PR12MB5782:EE_
X-MS-Office365-Filtering-Correlation-Id: 14d53219-3e2b-4d80-3a04-08df1577d073
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|376014|10070799003|1800799024|56012099006|4143699003|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	NnAWpDP5BvYP8WwiP5HwNPQAexdKfKQ/NoAcBk12PDUSI1+nCTozI/YXTvM6D8+C4CQYzyi35vlbQYzP78p0cjf1k3L6bZLIk/prckWwO/kI+I1SbkuXP7oUOUwZmMpqZfNTE6A8+n84mgipycv11wDRpnlMaNNayur8z2sBNg4rSpAUmcf7n3kJr+kBdiTN3G5sPslXEh80z9kFswFW6dt2ec/fMvL450TNzF6dKqniOScjzVmLzWMLLd3LDVal4KU1uz/w1/lGeVAr8U7yKyGUSpp0PUIadcGWCwwSzsBr4VA4ALl2vj04c3RqvlxQ47njiudnOHf8T8jbyhQJrcb+KsgTHyYi5dAjPJiqEIta/0eL7vXyId3+HSWlYKuvm8c0oXAjQory0RcepQd1UPD1WZjdf9+1RqssGtxvCZOANBIapu2GjpFmYJ91wr/OcuA/y9OkMMJbbxofsGD5ES/6UNZC+NRpctMftOvsvFrfeZe8DVA0lvqWFaoPA7spIRBmCeXPn0VqE1+02uyeKLI3UBbO5UHyrNTui0D2tYh6zcrd6EjYBCSVWG45tOK54kdl6EbCHdnZJC/3IPAvVX+FNpUtNDK++P/L1mph4T/Y6dBw/N9wOtGkTI6SUPBmzNsvu7R0hgCA7/YbUOppLZQG9KBgoRspeUcCtSRWIqg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7110.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(10070799003)(1800799024)(56012099006)(4143699003)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZkVtamE5WUtlYk1wY0RNRkxBVFJKWGZCZzJYZmYzTG5zbWxsTGF1VC9NRUlC?=
 =?utf-8?B?Z0tvOTU1MDFORHo2Y0ZCbTBEMzcyWUJXeXNsZzFJbXBpWngrNWpBUDNUYkxv?=
 =?utf-8?B?RHF5YlpUb3psZnVKNXdYRUdpVXJMSWcxOHFFdXBXdTVWVWFtWWJLVnZCRm1l?=
 =?utf-8?B?dzhLS0oySC9NcUpuOXVBVmFNSVZWa2JQSlpEcXZMV1V1QTVoa0xFYlhocUVm?=
 =?utf-8?B?ek5rOGdUMmc5QU1DaEFodElnemNMbmV0Nm9CUHExWEpTYXk0UkpmRko4QUw2?=
 =?utf-8?B?SUtFUk81WjF1ZlRqanlNUEFrc01IMDRGYUN1WjBHSlMxK2MrbE81MFVRQnRG?=
 =?utf-8?B?MmdFNW5oUXhESWM5VGxSbDgvYnVjSDdJMDBhZERraU4vZitOTDVVWFBVc1l6?=
 =?utf-8?B?VU9SQy9UdHBFMUk0eFNNKzRHV1FuVzFCRWozaHRzWXpHZmJQR281ZGFDMFNq?=
 =?utf-8?B?Unc1OGl6VGJidHg0ZUp2SDlSYzhTd05aS0thSzVWVWxiRUQ4VlRXK0ZzeS9s?=
 =?utf-8?B?RTV3czN0SFBmU2pzcmRVMkJYdS95dFY0TkVpa2JQWE5tbUM0aUVldUdGeUly?=
 =?utf-8?B?Q09hSm5acC9ib0oxL2UzTnYyQWtRdnF5Yk4vNGNWNDRsZXBxRjdsWGordStS?=
 =?utf-8?B?VlZkVm40KzNYOGVHMlVjS0ZUUFV0T3U1RnY2SHFUSm1HNDE4RUxtUG1rMjlq?=
 =?utf-8?B?TEVXMStzOHVwbUdONmNuNnpqVzErV0U5Sm1HZjhxb1M2eXZKTmJtVkd5UlVZ?=
 =?utf-8?B?ZFYwUm9BcWxjUGRJR2RCM1MvMTJITnNodTAwTEtwVmdEMU0zamdyVVF1QkhS?=
 =?utf-8?B?Q255RnAzNVYzQWVqWGdYVnZOQkx5VFZLb1FLeDRLQ0w3bjdtMjU1bmk3WGlK?=
 =?utf-8?B?SFVJQnB0REMxMWx3NFhDYmxJU2Y4bC9OQzl5ZFBMb2tIbnFRRHRhUElHbjZp?=
 =?utf-8?B?WmFmeDB5VWlGNFZ3bi9jWk9GRUxlTXcydEdCMUlIV3dyTm1HVUd4TTd5bFVk?=
 =?utf-8?B?U3NaV0RNU3dHUjNYdnFVcjN2eThVaTBZdzM4cEZBUUNNcTBJU2MySFFGQ0R0?=
 =?utf-8?B?bUVDU05xU2hOYlF0cnEvWWh5Qy9ncThxMG9KU0FOYm1xWXpOQkoyVmVYN3RQ?=
 =?utf-8?B?ZGtaRzJRa2I3UGhGL25xbzhLK0pnOTBlUjFUVERRaFJLQm5USWlMTzNVckNj?=
 =?utf-8?B?Q2RqOGcwMWo2WmgrWmNBL2EyQXlmc09VazNsVDB0SC9xcXM0S2owaVFRUU9C?=
 =?utf-8?B?aFhtOGZYRWRXMWI1aDU1LzdlTjhxdVBvNXNJam5BL0RybGFtSTFhWm9CNHJq?=
 =?utf-8?B?ckw1a21WT3lDa1F5UEhOSitzKytTSS9IVzdocTFVV2ZONWw4MXJuYlpZa1ZE?=
 =?utf-8?B?cStkWXIrVlRZbEk0Y2FXUlplOWM1ZzlJbEdTOENoa0VFUEphTVFlOGNwRytZ?=
 =?utf-8?B?V1NuZzRPNm1BNU5FYkdKcFFuaFFIL0Z0MjFwMmQ5OUM1WWE1U3lxeGR1ZjNp?=
 =?utf-8?B?RCtCTFkxbm5zM2tUT0JoZC9OdVVzS05vR2djQUxTTk9UYkVJMUFaL1JQb1NE?=
 =?utf-8?B?MnhXNFh4Y0pwcUJTYnZlcWMxa1NkVGxTRk41dTdBNEFFeGFiYmN2RmlPaGY0?=
 =?utf-8?B?eUY2U09UMTk1c3MrNDVueEFPc2c4ZW1NYXloQ2hEOHBoU3JKR2ZyZ0d4U0Iv?=
 =?utf-8?B?MGlrRDBBdVpYQzhPaVRrZHl5RmI3aTREWFZzVzBiN3Zid21paVJabXpqUmxN?=
 =?utf-8?B?U0RFS2dscitBU1BxbUpCWjdtRmdXbGF1Z3JRTTJEZk9uRmJ0VjNDZHZiK2tR?=
 =?utf-8?B?cmFUL2g0TENBNDFIYlpZbUdpd2lJcCsrUUQzcENJek1xU0xBUWhWMTBGSUVE?=
 =?utf-8?B?TzhsaEdXTEpoKzdBUmVMWUplZm1tTUpHYlZDU3hpanltQ3UwVS8zYmJSZ0Y5?=
 =?utf-8?B?RW94T0J1aXNtS2VsSEg5bUhqcXFCWW9FaEgvZEp0bVE3UkRlMG9BRzVlTWV2?=
 =?utf-8?B?K0psc29OeEtQekR3a29teHhId1hySXlseHNZaHFGZHBDd0RqNmx3OHhvMWxY?=
 =?utf-8?B?Z0ZUemk2ZGZ5Tm9TVmZpSm1jWWVacStJbTI1RDh3N0diZUdNZkd2eERCcGpJ?=
 =?utf-8?B?QnA2QmZJWk0wRjR2RUludC9hOW1zL1IyOWtYb1B1WG5tYnBaTm5IQzNsRTJ0?=
 =?utf-8?B?VVo0cW0vQWhmWVAxL1E4MWVzdFV3MCt2QUFORGVZbThKTy85VmdMUmp4bVAw?=
 =?utf-8?B?ZTBNNkE0WGZTeGNnaTJVNklMWS9mNXlIY0JYbVMwT3JsTFNFb2ZGWWQwdUp6?=
 =?utf-8?B?NjZhZGlsN0VWdVU4T3JEcGNPL3NxNlduSld6RUh5WHJrRERQRksxQzRycEMv?=
 =?utf-8?Q?yTzGmekf7WIy43kpW1hjY2oEg7j2GhlG/nGykOQGfPs4t?=
X-MS-Exchange-AntiSpam-MessageData-1: 0nnw5v2ezx/aQA==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14d53219-3e2b-4d80-3a04-08df1577d073
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7110.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 11:27:25.4933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XtnBGui+k6hawqmNfloJcUf+JCrHB1TCuyOoTblwWejQeWi1QGPGFiJyI3geK2oWmwNb3HE4q+iby3tenkJ9Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5782


On 17/09/2026 21:18, Pavel Machek wrote:
> Hi!
> 
>> This is the start of the stable review cycle for the 6.12.111 release.
>> There are 1102 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
> 
> We get build errors here and some runtime failures here:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.12.y
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/16571866335
> drivers/net/ethernet/ti/cpsw.c seems to have compile problem:
> 
> In file included from ./include/linux/container_of.h:5,
>                   from ./include/linux/kernel.h:22,
>                   from drivers/net/ethernet/ti/cpsw.c:9:
> drivers/net/ethernet/ti/cpsw.c: In function 'cpsw_ndo_set_rx_mode_work':
> ./include/linux/container_of.h:20:54: error: 'struct cpsw_priv' has no member named 'rx_mode_work'


FWIW, I am seeing the same build error for ARM.

Jon

-- 
nvpublic

