Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2048.outbound.protection.outlook.com [40.107.223.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509C11292EC
	for <patches@lists.linux.dev>; Fri, 24 May 2024 23:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716592420; cv=fail; b=ETmWx8JuFt2l8uLYVtI4GdLxCo26ZZs6LefmynNX7CCXvEzMqDWUQBNjq23veyTrTUX6W3TNqaK/OPN9yPmb4wu1lw6r5KKnmt5mRr1HQn+B1ejv4W47lQTQ+lOu2+Bue8+7SyjRTU45+vV3iwSQNgI/VUpayOfxJNqG7N/YuKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716592420; c=relaxed/simple;
	bh=zJvQYBhMcFrYtzmoi+L4zZZUq8Dy4NapMATkhAsR6DA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GeGq842Wnp0HjzL13XnRYB0iDp3R+WYeo3egjxdQXNr5VbCkGRUrsbQpv7WS0wMjFxhCvw1nN8u6333izFkGghQlpLrV/ctWE3/SDKnUvQ0081PJnSnhNi9N06K/ob+opg5mImPGm65Dhkp/gM5EgBXnNK0XadOXbM2JehgRKZw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VhFfytIg; arc=fail smtp.client-ip=40.107.223.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VhFfytIg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fC+JC/BsZRaBEnilDqqQ40uN2s14E9YMgURUTdUbY30m0hsLXtF0E0bM5N89drJxMzwH33cmNAgycDBu/lAURCPiAh5znSdSzLNGpAlWu5CFJvXP9eswI5e5M6i96dKNnXvRmFvc2z29oIJGNOmaB+al5M1x5lPsYw1bWQMUpJmGVsU/AorS8KjVcC55bRxFMRo9+2UfDOlQ/M71FNeG+S8Eb+BJ3BqGPJ92qjKrcv4cLbG7MFL+MGZdiliEt3ebqoMVRhbyNYuh4qMuoWUnyjKttskxXoH8c1Pv/9Uicel8XBneFuUoPEETxhK9N2gPOtuqI9nkc69+cXxXkDskjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QmqGrYkmB1Q9r0JxO0s2+xh20UtjgIcwuN93OEkRWdQ=;
 b=TXGioaS8O6XHL9MG+xebdd8PVMXwm2iTLvdzoItsj4ERfHagOMpdfhFvCrY7SCFCyuoy7xuj2cdvH6row3udNXI6vdHwjYlKPu7B3j/jXIZxCw85CZFoWXCyktKGf+2E1zrRsRk9CmcMdGEh5kttCNZU6GudzV0niaeCGplhh9OIiiaOX7zoYCFatCz2/NQNAx9YyPfHZOYZvTi++7fdwZxLzfVvjdNtbYzRPOJuhGpCjNS1jJweRcORLwuUtpyZ8TxaAVVHNwvtw+fU53ErhNpEcxB9vp/zQ4vef8qheQszZutxL6IvztsLZHTRW37ObFHqpSb79AePyq6vI8Gs7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QmqGrYkmB1Q9r0JxO0s2+xh20UtjgIcwuN93OEkRWdQ=;
 b=VhFfytIgTaY1E0HoO0Yr1msUWFINJ9o5DfpxnBzWNEXlRpgPZFoMI9sc+tAk4r6MNc1luqXGQRB5ZdUUOvJ1jg880TVJscfGdo+i129ZKWJiI4pjM7aHl/9Vwk74Q7d/al2F9rZSBuRHcXYTE2jNrR87RiCfdLW76QxYljdkAuITEpiyiECU/Nn8KJfgrJQtHMyrZ5w4YRmXWb66OEK5eJL1t+U52ZNX6ZbrhBcqICZ0tltl6RO1PadTMXptEC4EiESDaTKkLWhlgsCZgi5vyn4teBDEQyrfr1W/SkfxkzWGIQZBgc8Ohzvqai2hSuFW7jdQI8Pr096FwrRB2nCvMg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 CYXPR12MB9387.namprd12.prod.outlook.com (2603:10b6:930:e6::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7611.19; Fri, 24 May 2024 23:13:35 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ae68:3461:c09b:e6e3]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ae68:3461:c09b:e6e3%5]) with mapi id 15.20.7587.035; Fri, 24 May 2024
 23:13:35 +0000
Message-ID: <8e60522f-22db-4308-bb7d-3c71a0c7d447@nvidia.com>
Date: Sat, 25 May 2024 00:13:28 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/23] 5.15.160-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20240523130327.956341021@linuxfoundation.org>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <20240523130327.956341021@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0016.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::6) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|CYXPR12MB9387:EE_
X-MS-Office365-Filtering-Correlation-Id: 312ad54a-fa9e-4789-9f1f-08dc7c4722fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YXBaRjNGYWxRUlVQS2lIdlBNdE5JZGo2RVlUcFN5bkp5ODhzOGMzVjdCWmgx?=
 =?utf-8?B?YzE4emNBYTF3S3RZQUpzLzBsaStPOGFzdTFjL1Nqd293QVczRFVncUZkR2ky?=
 =?utf-8?B?MXdCeVJzVEc2WC96dEYySDlZZU84VXhnUTQvV3Q2WHFmdXlHK0Q4RTZ6SDJC?=
 =?utf-8?B?MzJrODA4TTlraFRHYnNqUFdGV2JXcW1aeU5xT1RYVzFxMXhxTFFKVCt5akhR?=
 =?utf-8?B?akNUMHhUOEhRdXhLc2VRakhwWTZIblFkTit4K0E1QkNtTDVtZjlkUWl4TnhG?=
 =?utf-8?B?VTJLc3Z0OUJMZEZZUnAwZ0ovOGNQamJ3Zm11SzdMZ01VbGFEYjV5WlY5RDRW?=
 =?utf-8?B?dTdvalZyNG85RUwzcFNuY2VQd1dVVGtNL1ozc0JhYXV0UW1GWWVhSncya1hG?=
 =?utf-8?B?YjZmVm9ML2hJYThKQUozN0RiT09KTjFRRE9nL1NWOUY5RnR5V3A1MU55RVNO?=
 =?utf-8?B?djRKNVVFbzNxT2VxSWd5UE0zTCt3ZnFCMkJxeVdCNW55dm5nQXB3V1hjdGZQ?=
 =?utf-8?B?MFVoVDZ5My9ZTUFHUFNYN2hoRnVKSFFJdDdqNXl0bitaRUxEZlNadnJUMnNs?=
 =?utf-8?B?ckVBL3hubXZhZ0VFdldHRG1XOHMrR29rM0FyYVpkbDM2RVp3bjVmbmRQZ2pY?=
 =?utf-8?B?MTlmQ3pwL1dnYXZ6RmFZeGZ5U1NSME9Fb0pTL0Jwd0VjSXU3ZVIvYlBjMXRD?=
 =?utf-8?B?cXE2RnlvYmFxYlRTelpCMXAySmkxUjY3U0F6M1NsZXVJUm50NWFjejVQTVpq?=
 =?utf-8?B?K3VsVXZwT3E0aHA1OXZENm9mMytMek16aU85b0MwM1hKVk5kNDdyZ0U0cUoy?=
 =?utf-8?B?VFJKemN5MzkyZUhiRzhucWpUd2xUQlNFQWZJUkpNbGE4VjZaaXNBNlVKbERT?=
 =?utf-8?B?RWhDWXZKZFVkTktNaTJTWVlwcC9ab3FndnFEMElmL0UxYTlhODArWVo2bEtN?=
 =?utf-8?B?eSs2djVjR1VVQStNZW16bUJxWHA5SzZoUjVXd3ZQV2xIeEZ4MjFLTHREdWFF?=
 =?utf-8?B?SDFZR3JUTTZTNFhVQ3d2MmgvUkxyUlRpaFJEUXR5cFdLMjI0VjRBZE5PVXBi?=
 =?utf-8?B?NE52ZXBUWmZKWkN0bXBacDBMaFQ0U29sMVdaamxMUWNCQ2JYUHVuZWNpNm5U?=
 =?utf-8?B?bldTSWdxbTM3aEx4NjNNTDZVSUc1OERWSFRGYitwYkgzTWkycG9POTBCcito?=
 =?utf-8?B?a2dTVlRCUENTcnVWVm5xdVNlSGJZY1hZMDVEemM4d05waWIyZ1dZdEVyS29i?=
 =?utf-8?B?UnJCOWJ4b1hXVVEvLzlsZXZZYTNRaFpoNlNIeUNZRkNPaHZ4aDZRaDI4MnAr?=
 =?utf-8?B?U1hwTVJDdytTTFhmR01RQjRaY2V0U1RraStiRE5iOGhqL3hmMjNpNUg2L29H?=
 =?utf-8?B?cFFqaExQM1YvZExMRkJxb0RSV3h6VzZFN3FvcEVXK2FaaHNmYWs5czU1d0FJ?=
 =?utf-8?B?S0FKMnBjbmxhOXNmcXFDRjVzQkJPZEgrKzVQQkJjS1NwUTc0NnZQbG8va3Jo?=
 =?utf-8?B?REU1RlpDYUxBMmFvb09MVnRhUHdQQ29YUko4ODdlUE5vWU9ram9yZGJLWVJv?=
 =?utf-8?B?N0JiL2RydlJRMlJBSFRzY016S3lrYzNFUWNtbERFajI3eXlzMFYwUm9sTnkx?=
 =?utf-8?B?MStFUmJlQUJLd05FUE1HVS8zaElCYWwvUzY2SHJaRml5cXZMR0FvcU12RzBH?=
 =?utf-8?B?bDFmbnJ3RjNyODJVVThhOVhoSzhZL1UyRTVmY2gyUkRoRUN1YnJSWDFRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NEEzblJKRFd1NXAzdTF1aHErMkZKL0k3UGdWbXRkSzhlcFJYYWtld3JQOVJI?=
 =?utf-8?B?VG8xYlU0djF1MFd6SURsRVZWOU91ZlVobUdXbmpCUm01VXRuc0hpQWY4VTRD?=
 =?utf-8?B?R2NxNHQrK1lVQ1k5K3lMZHVlcFpuMDd2RmVveGZycTdBQmZvQ0l2V05LMnJa?=
 =?utf-8?B?cm9OQkJmZzVaZEdaY0lZaFFTZU5CNEZQTEFHN3dYdW1VTHc3Q1U4NkFFUFZ4?=
 =?utf-8?B?cmRBbkpWSmFrL0dmTVZoNGpJR0V2OGdXc2Y5WXBHaEZyQlNwVVZBcm9pelly?=
 =?utf-8?B?Q3JPZndsNEEzWXhZUDBTSVliTEtTZmNOSjdoSnlGNTZjSGhhNnlWR2RaMWpt?=
 =?utf-8?B?QVNtVUdqaTdUT0ZnMlN0QktaTE8vRTVLMGlYa2RiMkNwckVhK0E5NTdveVVy?=
 =?utf-8?B?NmxkSytXdnZVVkxXZVZ4Qzlnc0o2SDlYYVdBNkJodXVNRzhmRGwrbk84Vm8x?=
 =?utf-8?B?RHNiUTZIVU5wdSszM1dRYjBxMjZ0V3J4N1YrN0lWb2VoeGF0MFN6VkZ0YUFI?=
 =?utf-8?B?TVNma3pFN3lnQ3dxdVY1R0NxMjRyZzloaW5nckg5T3RWMExlV2F6VGRuNDBh?=
 =?utf-8?B?TDB1SEVUQWdUTTRGK3JWUElBRFcydTJlaUUyOHhsb0hCRENzOVFJRXdKMldp?=
 =?utf-8?B?V3dhNXNoYXpnMVFvSWx5VXZtSkYxVEN1RFpXYkVYRHBaVkgvblNqWm9zSENS?=
 =?utf-8?B?aThrdFVOa3pESFhHNmdpS05yc3NlQlJyVHp0YVBjUE8zRmRpekpWcVFpNW5D?=
 =?utf-8?B?YVhVcWEzalhRMDZtaDY5R3o1cFpyazRhRU1IUi91SjJwcDhoM0haQkZJMkd6?=
 =?utf-8?B?dzFrV2VlSzVxdnMxS1REZEtzalNMOGRWeHZCV0xlSTA1L1dNT1VzSGhOalBy?=
 =?utf-8?B?aUF1OEV2eTVyUTdyUE1sWjFFb2treS96NjkxZnAyQ0NRRWlCU1loV1U0NHFY?=
 =?utf-8?B?bTFmYUJ0bGs5bS9TbFc0YW9zQjhPMWtKUHdlT1RKQm1Ld3JxWGkwNUNiR1FU?=
 =?utf-8?B?UmZ3ZUg3bFBkWmVpODM5Sm5hbUMxTjVXdGxGazZaOU1McGNKMHoxdkRldUpq?=
 =?utf-8?B?Nkx5SEtZdWxwN2Z5Y25XTGFjQXRqMGZsd2YxS0FYRENyMEZoZ2lPa2FmSUVI?=
 =?utf-8?B?WTdZMDl5Tko0ZW5lM1A4aHdmTU1YNDNhVGQ5LzlhNnpiOHIxOVdJS3BENVpa?=
 =?utf-8?B?THIwOGg0aEVmUFh4N01XcFR6Y1lPb3YxYUZLa1hHdWZ5ZEFJTHlBcnFBZUlz?=
 =?utf-8?B?OFZndnV2VndvcWxQcmUzdURORHdoV2JxNGdpazhBenRxcldTR1dRcFJvZmI2?=
 =?utf-8?B?N0tmZEh4dm0rRzlZQVFteDB1MFZOdXJSS2lVL1NrY3BjWmNTL1dmMHhab2g5?=
 =?utf-8?B?QTk0SitIQmp5azM2M1E1LzJTZGtLbjk1RTNyLzJOWWhjNzg3YVJzZWF5SGZ4?=
 =?utf-8?B?YXh1bGRqWmdBcnpkblJSU25yQ3NkclZPeW1LQy9RZ2Z3bFZrSjYyZlpiSlBk?=
 =?utf-8?B?MC9ucmljVUFyMGR6RkRWa09TT1k2L2NGdHh0WVd2TGNUOVlSY1ByNFFOMFpL?=
 =?utf-8?B?cEVhM0psSXJtZFY1bzlWcmFXZjdvTit3WjhDUjIxd2g4clJ5c3NQblU5U0hl?=
 =?utf-8?B?WjYxZ0NhaS9UV1pMUHhrUS9mN0p6M2VFdlFWeUdrbWc4NlR1bzIwZUxlcE5h?=
 =?utf-8?B?T0FQdGFjdmhQYWtISGM1NkxCaG1wZWJkM1RybkU3SU5zVm1TRnhXVDI0YjNL?=
 =?utf-8?B?UmRPUUU1ekdiVFdHQmlNM25KcDZKWS9BY2NORXkwQytxU2c4TkNqVDJOYVFt?=
 =?utf-8?B?Z0tjUmY2ZnZmenMzQm1YRmxRYllRcEZNcjVzMUJlUXQ1VnM5Z3pPWTBMN1lT?=
 =?utf-8?B?VDUzUm8rTmtGbjUvMUdYQk1hVTJlb0FoU1kybGsrRUpDOERGSWNEWkpUdElW?=
 =?utf-8?B?SFhFNHoxdzBpanBKaExLcjM3SUFSUWc4eXd5dCtrK2gzZmJvWDlvZUNVWjFy?=
 =?utf-8?B?Nk1jT0ZZcTJxOE4xUDZxSm4rOGpMVEpRL3EzdG51SkNsbU84SkRUa0NiTjJQ?=
 =?utf-8?B?SEU4cE5mNG1xQVdVVGl1QmVvTlVvK2VhenBhWllkZjZKT21LWW1CMUJ1RTN3?=
 =?utf-8?B?TmdwbFZNakRyclNyRDRIRTRrVEUxbStSb2h4U0xRcDdnV053TE9qVEZyZTVk?=
 =?utf-8?Q?U4D4utrcWdxycPrriSP7O8K9a4/tZSDtS5txDb0PYiiP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 312ad54a-fa9e-4789-9f1f-08dc7c4722fc
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2024 23:13:35.3905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Iv+NQ6yGHm9BV6DGtYfdPyIT7TMyU9aPI6V+knYET81cmIxPQi/mQw31nXezhnL0PUct7GlZJNyj3Y9LJkvlww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9387

Hi Greg,

On 23/05/2024 14:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.160 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.160-rc1.gz
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

> NeilBrown <neilb@suse.de>
>      nfsd: don't allow nfsd threads to be signalled.


I am seeing a suspend regression on a couple boards and bisect is 
pointing to the above commit. Reverting this commit does fix the issue.

Test results for stable-v5.15:
     10 builds:	10 pass, 0 fail
     26 boots:	26 pass, 0 fail
     102 tests:	100 pass, 2 fail

Linux version:	5.15.160-rc1-g7c7f29d3b2af
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                 tegra20-ventana, tegra210-p2371-2180,
                 tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra186-p2771-0000: pm-system-suspend.sh
                 tegra194-p2972-0000: pm-system-suspend.sh

Jon

-- 
nvpublic
