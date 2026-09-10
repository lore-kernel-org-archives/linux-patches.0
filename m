Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010070.outbound.protection.outlook.com [52.101.46.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105B724676D
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 05:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789017495; cv=fail; b=fDZ38kDb0/2A3dL0OGNX7NBw2tMHaAJM/09zcI10nUV0Cv6eyG6NPO779LdaugFqCKVh6xLywRUqVQiCR9w5OWYFhnvhMF1/7b7qJ5Z9osrWG8twXxXQ6HTGR+IP3vLrp5YwqoudTAd/tCSpA/RtnURbakyOuUJDs3lnnd8OORo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789017495; c=relaxed/simple;
	bh=iffgQzbp3IXR54Z9Y3YTReMM+sxS+uD2E2KBI1RK+jI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aus3iIlrvLk5QA7M0Qs0y3tLeJYRyOatuJj0lZg6Lfudw7Z27ID+vD7JDD+qoZy+QWefkXjOtadLVOewzwISNI2ddMAI2zbcCbxzgo9CukFTvSiNcHoEH3pd9sZP08eo+E2+tKuk984oGXzsCnCgFvteCVyT/wkde9Jme+WVFnA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ntFyGQo9; arc=fail smtp.client-ip=52.101.46.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ntFyGQo9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WcXZlGQbV60moEsMXSsAkUvaKgjL22zAK2mlHdV34vXSWoUwXWfHUrdAe5IQ9NQsZqhtniWtG7zC2s5d3uIcapwSTSQfWpb83j32vQIkCWGXNpZjDz3AjTE7KdjBkaFwnw7lbWOTwJFF7hUWjVXbT/593AlaJj5PHR54qNKKFR3eq9VLOPfuK/zrgSvcZ9d34FdAwLOcASlA5cCWQZBEFi8z0maCm34xbAnW5xB8zoky5D9GFKEetAzwTIWhrfkhpX80C/yEng5ay9+OsHxHLrYlCXRWWpzBZ+dUEKZxxRu+EnH5Stx/eaPAQCRK9/XhR0NGqBKW+JX53LzoaZNyPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cJxFsWcYXbDlsBBry2EFqqOMA28+N7eLbJ8KtrkFez0=;
 b=K5q0nJ2+Uckn2YSyG9uLkhyEzWNECOigxcGyPhBoFSNyJ+Gg1d3Gaah8pmI8oqbwQCKWSjVwkUt2Ciyd6XD0wHm7CRf60Y0gqBRkO2QPk5WJlrdrBJUd7k2wMlzsvMYw7eMNLs56CLXeSgD7fHdg4SkJ/9c47LztWECjKvIZEvzh1Xqq0XLSF/jwjxror+bT7S3fq79FLaskv1dCHE4OdapNKoXdJ/9lhfwNgX3EHflpnpOZlFte2fB7CR0OpKgGSb6T2r8WYphzQXGeskXsqyZYKs59L6GmaoEr/HhOcWV51CIsWF95TR9qtb8oNIbk3WPJR5jKPGKnhAQdXnY4dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cJxFsWcYXbDlsBBry2EFqqOMA28+N7eLbJ8KtrkFez0=;
 b=ntFyGQo9HgVAkm28C1V6gVOINAi0NCH+5DZ5dDif87V5his2EvgNCilpLn3guzRLfk5fQJrZfAeWqtyffqnDNjupIPWRRj3HyFfQ7t9K68x+ROj8+AmWw/VZ97n7x0L3lCSIws0ydPQ/pNziSOrVJsmziZXd14izXuleFaDp+HUGMKMDnLdzwb8vipUB+lk83CaK5f+r/68X/ALtOLb/tdXqgiKRSoXEJBJxLgGDnZOoQSesWUg0RAVdp0QQH1pbMKIzqfVYL8i3ZzcgMiwhwbSG1eEUQSXmpmSIGGaxZfW22xghTP/ghAt9/S2icf/Z3AGirCAosrLVZ6gh2zqxTg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6051.namprd12.prod.outlook.com (2603:10b6:a03:48a::18)
 by SN7PR12MB6861.namprd12.prod.outlook.com (2603:10b6:806:266::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Thu, 10 Sep
 2026 05:18:09 +0000
Received: from SJ1PR12MB6051.namprd12.prod.outlook.com
 ([fe80::96e1:b300:7b78:d3a9]) by SJ1PR12MB6051.namprd12.prod.outlook.com
 ([fe80::96e1:b300:7b78:d3a9%6]) with mapi id 15.21.0382.014; Thu, 10 Sep 2026
 05:18:09 +0000
Message-ID: <e976263f-5382-4e32-a3a6-5639c4d56abf@nvidia.com>
Date: Thu, 10 Sep 2026 06:18:02 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/583] 6.18.51-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260909134237.773280130@linuxfoundation.org>
Content-Language: en-US
From: Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4PR09CA0011.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::13) To SJ1PR12MB6051.namprd12.prod.outlook.com
 (2603:10b6:a03:48a::18)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6051:EE_|SN7PR12MB6861:EE_
X-MS-Office365-Filtering-Correlation-Id: e530c852-9b62-45c1-2405-08df0efae746
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|7416014|376014|23010399003|366016|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	evReHaQNXhcYcJeIQGUnOzySaSdGcSYykP9HGJkHPQ+BXPyBjndKImn7il7luSh4ngYjrRw93h3aOI5MhiJYeRIMd6Gv9Tu4yrIBHXfmxEVvMuUSyHS0UdwkZBCwYfUNlf3xEDR8LmS7/44Tg1hJaJkCZ8dOCf8HrcnQ2hUQUm52/BwduvkOnyWPDGXx2nJe9H/NzmQskPZrZFx5BRG1MeE5tA6klv8dHp3LTf4suqhrsJp4rdUXqlFEDs6xuSdI706sKwlkmUwABMkHX6M/lfQbMI2NKJq/dYbPCyKDADpH/LX6RGqa8cHxEakQck1/ebiubuUpgWRPjF0xc25lvOkNZi3E2Qh/ljME3fsEF4Ia1K/CpPHVEKZ1OpbTDqQCpMFdI4bYvC3HeyvsLFKFEiIo7CC/DwfQbAx2AdZEndIp2XQ1edRSgesgaVdmn5jeJ6UdPc+yRQDgBNfV7q0Kk+3PBlbdM4djvrma+hd4jgvz1TsRW4L45zku0sokFUBjQTRM+fX2hWvkft8haRbM8tcylAnkdphvuLfJDO2OwNptawT2yATrxkis5pCJWR29TXEvzjxEOn48b+LqeIxcBffCy88nQUPcMIl3JdXsQRzmWPcjbqvprh7XtuCGUJgUnI/uzP78WmNuG5l3ilIZ4s0SoDSyD3a5DBrqhVpGLNw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6051.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(7416014)(376014)(23010399003)(366016)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eEtFaFVSWEE3ZllJTVRNUWpqaXZzVHlBREg2OHkwYVprTHNyUVkzWFVlLzJI?=
 =?utf-8?B?K2RpazVEbWw1eDBnTzdUQmRPUzM3Z3ZHOVhpNzM1Y2ZLUjNaVTdadUxjck5m?=
 =?utf-8?B?YnRMallIWVJzT01rbVBEOENOYjduT00xVGNZVThCblVQM29VNnVXakVJMEpj?=
 =?utf-8?B?OGVnVnFJSVcwYVl3d2k0REQvSzJIc1kwS3JOandITVhXTzd1WEZBN0l0eEFn?=
 =?utf-8?B?L0tuS3RRQ2RHWkZrc2JRNng4cTlvVmgvNjdZYmN1NnF6Z1VidjNHeXc3Q0RV?=
 =?utf-8?B?ckFURkxsRG9VTjcydDFKRXBBRWRaSFZ6a2FVODBnNGtaR2VYSTVjRnBzTFJJ?=
 =?utf-8?B?MmF6UlJ3Y1g4ekJkV2RQQ0ZoNlZqV25LbC9uZnUvbWpJbk9iUTh1Q1AxS0lB?=
 =?utf-8?B?cTdKNmxjUytaeTE4cEFsSFpCU01ZVmZWMGMzNzg3ZFNnUVBXeVFsZ3U5K3pz?=
 =?utf-8?B?V2tKa0xNaXUwYjJpUHZZbDNJRmhsMGpSbkhQRzNHelQ0blIrRWZyLytvTmlX?=
 =?utf-8?B?a2Z2Tm1meDVGTVR0RHBXZ0RQUEJZY0toWjJqSmRxSk4vL1FDVVVQdmE5L3JU?=
 =?utf-8?B?NEY2T3JRQmJtMUlTcTB5TlRYbjRoazQ3OW9ndExjdjZlK2VIS3JOcWNUcmo5?=
 =?utf-8?B?SmpXZ24vVlBxYTRXeWpYWGpvNEhLQ0ZId0Q4Vm1ZaXd3Rkx6anhYZFhwUUdi?=
 =?utf-8?B?T0p0NGs2emJ3aHNQYnkxOThtZVd5eVJvSDhGc2hEQlJiWmtMMkdGdGZFUC8y?=
 =?utf-8?B?QTN5NzRXZU50cGFwRExCUkVnTHpZK1VxSUZUTzdvWVRxTlNzcS94QVFmMmVj?=
 =?utf-8?B?ejRidG9UdXJxcWllUlVQMHRyVEVKeG1yK2dod3BLQndHbGlBQ1JmMC9HRmlx?=
 =?utf-8?B?YUlNcDQrdEhJVHhDOFNUMmhtTnlJbDk1WkVNQ0F3dll3bzk2NXQxZFlXWmtK?=
 =?utf-8?B?VVVvZXJZcGVyREZkR2RIaXgxZWFkUGYwWGtGQlZsaFZnUmxscVF1SEgwVSsr?=
 =?utf-8?B?b1pFNjgzNSsyaUJvdXpJWlMxS3ZCN1hCdjhoRWxXTW9MZzdZeXZmeUFkZGFL?=
 =?utf-8?B?Tjlsc3JwWnhid2dkQ1h6MklLRTliVXZPRGdzOU1pb1h5T1BQa1F4UUZFNVlM?=
 =?utf-8?B?VS9hUFZOY2RXWm90WXNCV3hXMXhqZEdjUnUzMitQSVZDOTF4d0p2UTBnK2tk?=
 =?utf-8?B?OGIraHJ3a2hTRjJ3bUQxajlxeGdMNGVHYndvMXFMamlsMDBrNjR5ZEdXWWor?=
 =?utf-8?B?WjBPSm5EYWhSUGxwTGk0TFV3d1J3SzdTRk5EWFNwb2puaHMvZ2hxYUhQL1pn?=
 =?utf-8?B?Z1JZNHVzZmVUcFhldFJUNnR3cjA2OEp0SG9OS2lqTHBKTVI0Q1lETDQ1bHJm?=
 =?utf-8?B?WHRsdzdTM2drd3ZHei9FVDlEbzIwM0lDL3J3RElwNzhqVjRnSHZHa1U1L1I1?=
 =?utf-8?B?VGVGcmtzZUR4TUNzRVVOZGMrS2MzS2FXNlo3VHFDWmxVVUNpenllVGd3NWpL?=
 =?utf-8?B?RDJ2SkZNcm44Und1d0VnMk1GNkxESDc3dWwyWjg2UnRtbTR3ckhGcll2WWxG?=
 =?utf-8?B?azUxdUIzVHhoVzZ6MjhIK0ZWYVNPKzgrVzRXejIyTjZkV2ZDRjRpRjNENFlr?=
 =?utf-8?B?L3BNRzR0K0xoQkN4YUJVUHRvazRIaUNjcjZydnkyTGxwOXU1OU83TEY4YXJL?=
 =?utf-8?B?TytEVjBvMFE1VHVWOUtyN1pDYU1hempLN2dzOXcxNWRLYUorTlh1UGU3Znkz?=
 =?utf-8?B?QzZrcjBoNmJySGREN2daU1ZjczVZazVoUVlGRTVLYktBRjhlSHNsbS9lNGh0?=
 =?utf-8?B?QzJsTlFCS1NSN2kvdjVBblZKYUxZbE5MSllDMGdnMTJNS1RySWptdURIcGRW?=
 =?utf-8?B?dEVVVlBTKzBtdWFndVZjSVcxeXNmck9XRmhLTStLR2ZpUkRGUW5xMTFUaGFk?=
 =?utf-8?B?WXE2dnhGZEE2TUhlMjhpSVlGYmNzMlZ5VEVQS2N6d3FGNTgvNXcrbnUzVU1v?=
 =?utf-8?B?Y3RJRzBaeU15cFdRaU5IUFMzaGNLb3NQUVZOZUhIZHpRb0xXSGdkZ1ZWa01F?=
 =?utf-8?B?VUtyQkN1TGtvVDlVaHlORGlsbWZkeVFyc1h1MDREYU1BMTFxWHdjcGt2V0RP?=
 =?utf-8?B?bFIyNXNJSGVpaXIzdHdjT2I4MGIwd2x6RFhvUzcvNEkweENKdzhISmplQ0ow?=
 =?utf-8?B?Mjg4ZVpSZUJuWU5tU3ZZV3pabHNTMm5HZHVvVXZvVERnZzJPcUhWdHE3OTRX?=
 =?utf-8?B?Y0IySEh5MUFNaU1KS21ZU3grMk9zM20ydm5lbkdaTG1hUDZtT1B1cm5RTmxG?=
 =?utf-8?B?UCtBN084QUd6UEdaVTUxc3hBMHJudXRmei8raGxsVVJiL3lmdG9idEkxajFm?=
 =?utf-8?Q?/jxb8LPf+SEwv6Dfmug1JoZSCUIepijXXZs5J2C9guB32?=
X-MS-Exchange-AntiSpam-MessageData-1: 6j/8R5su7klYqw==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e530c852-9b62-45c1-2405-08df0efae746
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6051.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 05:18:09.5867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PSwPdVUUfLAfmh5OOuwh55Nq19mxtq7Bkkw0/CMnEXp9oaACk6lzE/prge9Qr4Ko9al3caFUKLANEMH7Jm3yaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6861

Hi Greg,

On 09/09/2026 14:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.51 release.
> There are 583 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Sep 2026 13:40:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.51-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:

...
  
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: tegra210_i2s: sort the register default table
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: tegra210_i2s: sort the Tegra264 register default table
> 
> Jon Hunter <jonathanh@nvidia.com>
>      ASoC: tegra: Fix the MIXER enable default value
> 
> Jon Hunter <jonathanh@nvidia.com>
>      ASoC: tegra: Sort ADMAIF register defaults
> 
> Jon Hunter <jonathanh@nvidia.com>
>      ASoC: tegra: Sort MBDRC register defaults
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: tegra210_mixer: sort the register default table


These are causing some audio regressions for Tegra ...

Test results for next:
     builds:	11 pass, 0 fail
     boots:	26 pass, 0 fail, aborted 1
     tests:	139 pass, 15 fail, aborted 1

Linux version:	6.18.51-rc1-g4cfd5b1359b0
Boards tested:	tegra20-ventana
                 tegra30-cardhu-a04
                 tegra124-jetson-tk1
                 tegra210-p2371-2180
                 tegra210-p3450-0000
                 tegra186-p2771-0000
                 tegra186-p3509-0000+p3636-0001
                 tegra194-p2972-0000
                 tegra194-p3509-0000+p3668-0000
                 tegra234-p3737-0000+p3701-0000
                 tegra234-p3768-0000+p3767-0005

Test failures:	tegra186-p2771-0000: tegra-audio-loopback-testsuite.sh
                 tegra186-p2771-0000: tegra-audio-mixer-testsuite.sh
                 tegra194-p2972-0000: tegra-audio-loopback-testsuite.sh
                 tegra194-p2972-0000: tegra-audio-loopback-testsuite.sh (rt565x loopback)
                 tegra194-p2972-0000: tegra-audio-mixer-testsuite.sh
                 tegra194-p3509-0000+p3668-0000: tegra-audio-loopback-testsuite.sh
                 tegra194-p3509-0000+p3668-0000: tegra-audio-mixer-testsuite.sh
                 tegra210-p2371-2180: tegra-audio-loopback-testsuite.sh
                 tegra210-p2371-2180: tegra-audio-mixer-testsuite.sh
                 tegra210-p3450-0000: tegra-audio-loopback-testsuite.sh
                 tegra210-p3450-0000: tegra-audio-mixer-testsuite.sh

This tells me that there is some other dependency missing.
My intention was to only backport these for v7.2 because
audio is broken in that release for Tegra. Sorry if I screwed
up an fixes tags here.

I see this is pulling in a bunch of other related patches, but
I am not sure if these should be pulled in either. Adding Peter
if he has any comments.

> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: tas2783-sdw: sort the register default table
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: tas2783-sdw: drop duplicate reg_default entry
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: tas2780: sort the register default table
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: tas2764: sort the register default table
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: tas2552: sort the register default table
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: sti-sas: sort the register default table
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: sgtl5000: sort the register default table
> 
> WenTao Liang <vulab@iscas.ac.cn>
>      ASoC: samsung: aries_audio_probe: double of_node_put due to direct assignment without of_node_get
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: rt721-sdca-sdw: sort the register default table
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: rt715: sort the register default table
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: rt715-sdca: sort the register default tables
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: rt715-sdca: drop duplicate reg_default entries
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: rt712-sdca-sdw: sort the register default table
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: rt712-sdca-dmic: sort the register default table
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: rt711: sort the register default table
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: rt711-sdca: sort the register default tables
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: rt700: sort the register default table
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: rt700: drop duplicate reg_default entry
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: rt298: sort the register default table
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: rt286: sort the register default table
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: rt274: sort the register default table
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: rt1318: sort the register default table
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: rt1318-sdw: sort the register default table
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: rt1316-sdw: sort the register default table
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: rt1017-sdca-sdw: sort the register default table
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: pm4125-sdw: sort the register default table
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: pcm512x: sort the register default table
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: ml26124: sort the register default table
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>      ASoC: max9860: sort the register default table


Jon

-- 
nvpublic

