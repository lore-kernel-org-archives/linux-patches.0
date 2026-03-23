Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011009.outbound.protection.outlook.com [40.107.208.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C8E386450
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 12:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774268916; cv=fail; b=ZgT8UNCwsJ/1jvYkVNeDQCXaiDJ10X6KIYg+lCgAkZhJ5Fkf8c7rB5WRDjG+40H0kQOJ4sEUYYYKmQABT0vtx3yyPspiIpJGBL59OZs4gqJNz/lwDz/aRcdXdwjdtRjqGaNTLP0ZbaBZ1HusADYII0TQ6euS1CrOAbwpWqMdLyU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774268916; c=relaxed/simple;
	bh=C5+50mJ9aLWX93tUFGqE53gsk0DoxgpDI9kmIEt+XY0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=i1li8sEdj76sBDnRXGHH0Wvx7dluhmEBbqyswvrG6J8LtpQM1Q/mEcwR9QFbpq1ZHD10CfHVJpsSHHl0Wt6OGOV2w7GH2PkjwAJCNjCh+FfyZU8AbKG4K7rG2vPjkOW1zsgHmKPPg1NMCsWy2gIw2vb/Iu4NXVsC4IA8MKLMnPo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JmMZnbH9; arc=fail smtp.client-ip=40.107.208.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JmMZnbH9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b79Yj4AaF+sIzJshdy6Y4Okps8GBrpzzD0nEGCBEX4D4BxqGfgs9H2TjXKt/e9TeuiJSzyUzt4vLZWqGLJNgkXHqz/V1AUlqh+45kWbBR59tRFET8SvrnYj3zQygaGcOeo6i8r+6Tz9CNfmgOYmpB3XSqaY1YVbPLzQWjh82PGvpBh5jbLuMTD4Mg/6ywxoj+P6K1SsRv6Ep/VtV4+zbG0g0j3jstAMz3ydWdQjcf5ljRVCZ9XVr1l/sArCjXCsNOr8Iq8IgqsVHDI0vySQ16jyFKhxE6yz9Vhisk7bPkSaujV6hEDwo9/F61ba+HyJr9DJPpZPJcCis+OMEQvP1rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dvRa3eFhTfoiYHC76wLDuY4zQD6lT6kg9xlN6UxPIoM=;
 b=ukUKOlY5UN9Yiic3btrUtkNFLhvmeiLzkT2EsaCaNPskWNj4prLvzKaHOMBMA7kIimnkOckcWdHMi55rylomFdoVVPIJdy78NpR+LuTVAc6vMfvElpeAB6Xq+M/ujs5WUQq1ad9LganLgpbrERPhWI5B8NB7L8MIoIptV+ZJrhIVAKtbD6ioeVtKvfCMvKFJDHuNMfLPprpWlkbjDGdUqHsu3CS8JuGXvooAGqo6V1iSV0qAGEHaCKv3J4Idt/hrleTGdJ4tYcSmqz65mae6nIrNj0ErLNy+u3Qpu6+QHLL8uHEXWxk9W6XV0vAvihwJ/+rVaeD15KdFXyclPIar6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dvRa3eFhTfoiYHC76wLDuY4zQD6lT6kg9xlN6UxPIoM=;
 b=JmMZnbH9UYIklU8o1A6ByoFIyUXa2EEaOOsy46hhBm9jkZOiftMJzk8/zwYEThqD5vzivgD2D2f0T8HLpFVCU3izvi+bUTGuWXJ9T7AmAbjti+nV1qjbQcAtz8L9wKALOFEUs/VHMAs5UROXFhXVfJUGwq+LSCTgdBMd8lmuS5Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by CY8PR12MB8265.namprd12.prod.outlook.com (2603:10b6:930:72::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Mon, 23 Mar
 2026 12:28:32 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.20.9745.019; Mon, 23 Mar 2026
 12:28:31 +0000
Message-ID: <bd383c94-8350-420c-adbf-cc02a9918a37@amd.com>
Date: Mon, 23 Mar 2026 13:28:24 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1.y] drm/amdgpu: Fix potential out-of-bounds access in
 'amdgpu_discovery_reg_base_init()'
To: Greg KH <gregkh@linuxfoundation.org>, cve@kernel.org
Cc: Li hongliang <1468888505@139.com>, srinivasan.shanmugam@amd.com,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 alexander.deucher@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
 daniel@ffwll.ch, sashal@kernel.org, guchun.chen@amd.com,
 amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
References: <20260323071052.4068410-1-1468888505@139.com>
 <f2d125ce-8cb9-4ae8-8f55-0b5a78e66f83@amd.com>
 <2026032346-ruse-dork-baf3@gregkh>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <2026032346-ruse-dork-baf3@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN0P223CA0028.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:52b::17) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|CY8PR12MB8265:EE_
X-MS-Office365-Filtering-Correlation-Id: 556e40ae-69b0-4a59-4d99-08de88d7b1c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	Wnbk7LBPfAneWHy94I9Wf8rK3TXzPg0cTs8Wf39o5eQfsTEJ9DVlsMGlD3irAj/jT7naL9Xy8OZa0twG9bzl4YrTJ/Hqn2qb1/NVhPypDzCouV+y5imMBLje2Vlx7LuZxIZUDLPYmWoie2Om2jpxVRomZV3mPG3HzRNdTaopvi4TSll7n6idERlZgcAMq56/77UZ0XpNWbbHWOhrzoJyUSgLMJ5Ctew4/4JPRvohMl2QC247Fv2gf419RiyucBlQ89CWiS3VSyDwMDPaqtc9AHYz7c5WibAz1m/ZQl9+qTlOrh2XMuajA2vURGmoJvstJhmI7nUAWWVXLWfoz8VlbnK7O89RIvCw6v4WnaqDbUDtdhqZziTQNzx7BYmqLxXuPoYtlKsAHc6O9RsWOlVP1UcfygvdE29DlF0heHxAOjEZL1Ru2E/o+ZbsjrjqqIwqKLcDRBMsdZh5vIuM2A4sZWQ2yjE62NIThENSYEytqrMcyUC0snmVrJr577+hebt0FynIGEYBELncTZqJathT71wwegHZ8hyzFJCH9FiqxFKIee3Eircn6MotCf8kJFiymUnyJWaUbx+eCE6oN7GMbL+6Qp+IdKlRALzUl1KJUjCd5SfiXX5pXFScgwC37iAvYjd6tKv0iqHt1qbSCszYE0kOphisosG4MgEClUq0h+/GhlpQMtaT8q7cP9vtHeOXZeFJm9A5sE8lSskhrwjWF4oqrBdrgovwwc3BPj/8hp0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ckVybjE5Wng3eG5heFlsSTFYQVplMU5PWW5GWG8rRnEwVGVtTVVUNmorTWkx?=
 =?utf-8?B?Q3ZiOTEyR1hhejhFaXVWaDNiL3R3c21KRkJoSk1qTXNzbnR5N3pzQVZTbmt5?=
 =?utf-8?B?MHJ3KzF0S3JlUU9MYWl4cGorY2ROV01hSS8vbFdlbmVWTC83L1R2NFBRcllH?=
 =?utf-8?B?TnIzNllPR0cxYmw2WUFLTTAxWGpBNHJYaG4zYkF6WjErZmFPVmZDblYxemdp?=
 =?utf-8?B?ZTJBN1QvYnUwamxWM3Q3dXArMXowaWFDMG0vNVN2aFR2ZCtsQ0dwblNOMzRi?=
 =?utf-8?B?NjcvM09weEw1MWNCckcyMVdHdTMweE5YS1JmREhDRWt0Vk4xZ2tHdVZvN1pO?=
 =?utf-8?B?ZEZ4TEZBMzFwRmNQSGM1U0lXOG5mNUZvVy9vd2xhdTZ2eWZPTGdjRlpxbnR6?=
 =?utf-8?B?N2NtQkthemJKVzdwb2h0bzQydFZxZU9iV0tWekNBOTJaZDBna2JtSitvaDFN?=
 =?utf-8?B?QmdnQWRySjIvS3BGU2FIQU9DSDlhMHJuYlV5QnNxQkFaRnQwQjh0WWNrN1Vt?=
 =?utf-8?B?R1NiK0IvVW5TbDJGSFArQ292bGFtZ0xBdCtudjJGeUsxNUhjWUdEVWJwYXg0?=
 =?utf-8?B?eVFTVmUxcEZjZ2pQZXNkTThTSlNGcC82RjAzWTRoRVVzZzJuSExhZmFiRTZv?=
 =?utf-8?B?WVdra3Rwa3B2SkJxa3BSaFV0T2UwNlJuSDVLZm9BcmRScSs5aHk5T2FWU0Zp?=
 =?utf-8?B?bm02bU12WUhmZ1hndDRHSm5vSEJpRTNyS2JzdDdyTm5pS1pCTU9WVUdlWXY0?=
 =?utf-8?B?Qmx1NjZTQ1luaEhjMEpSd3FrM2pNL1FKZkdrelk2MlpxMWFvQ1psQ1NqOFFx?=
 =?utf-8?B?UUhpNnIybmNWQkZCM3VObk40dnVBNGFvdzNNdEJKekJGVUE0NHFlb1pjN2dx?=
 =?utf-8?B?TzB3YXpISUVRVWtHQTRIK1pZeE9ndms0dmJkR0xWTUI0eDZFdjl0b3dCSzJV?=
 =?utf-8?B?b3ljb1QySkRmU0RxazFlRXNGNjhBcWk2ejBJS0xkUFIydkxxcEltNE93OWVw?=
 =?utf-8?B?bGtNQTNZSkY5V3VnSDJTcUFWSkdoWjlGM2lJTVNjaEFPRDV4OEsvOC94UTU1?=
 =?utf-8?B?WSt4WEtzc3lWNVpNaWtQMWQrNDhiVmNzTS9QSUZ5TGpUREFSajhPWlBUUzB5?=
 =?utf-8?B?K3gvUklXZ3Fta0h2SWdyNzNiSUdJT3hMZTVxaE5qdm9wTjVrTFBaUDk0dUpC?=
 =?utf-8?B?ODVURnJFMXFPcHVPM1ZBLy9Ocy8rQmhoOWh0RDdKSHJLZW51elJJbXY2ajBa?=
 =?utf-8?B?TVBhcmtaZ05GeHlsbm9CenRzZ3RmRllyYXJvYUpIaUU2bFhjaTV4Q3ZFVEFY?=
 =?utf-8?B?Q0gyUElxR0t6TXdMZ0hxbHVxNWZPMnkyREhCQmduR1hBNkk2VmYvV3Q0RnMw?=
 =?utf-8?B?VjVjdnZPSjNNUklnNzlMQWQvQWNZMlVqK1p5L2x6T1MzMEoyWjdaK0dMYXNF?=
 =?utf-8?B?VE1QS2tIRVhockxBekRwNy8vSjVjZS81MFRCdmIrZCszMU9ZaWZXbmZ1ZjZN?=
 =?utf-8?B?UUhJSzUyN09LVWVNb1kxTXRVb2JRQ1NEdjcxNGoxSnYxZzdDekFrOU0zVUtF?=
 =?utf-8?B?UURrdUNGczZLUDdpUnhweUE4YXdGQXNGMHUwNVUwL21mRkJJdk1peU9NeGR4?=
 =?utf-8?B?SkVOSjRRUzI1S1huRHlTS2xvbGZFb1J3T3c5dFBHY2FJMHREQmNBM2tzN3RU?=
 =?utf-8?B?U1hrNFBJQVY5MkNzNXVpN0dKME9JNmlSbDhpWGROdGQxbWw5NVN1RTBoWDJX?=
 =?utf-8?B?R0Y4N3BQNUl3eGxaeEkxbmNxOGZjTVl1ang3L0I4OCs2R1BpQWJQYXpXc3o0?=
 =?utf-8?B?T1g5bnZuZHdEbUVGbysrQWVRc1k0SGhLSll4UUVwQ3JVcUZFMUlITVpZU2o3?=
 =?utf-8?B?WXIzYnFybmJMNkhCU3FXUjNtL0pWZGRGbUtjMVZPYS94RC9sTDRFV0UzRzh5?=
 =?utf-8?B?QWxIcWh2ZEl6VG9CM3JET3ovMTNGenYvOXhkU0dUeERsMi9VWnBGTzI2YlE5?=
 =?utf-8?B?OGlSRGdQcHk5TVFZSEtid2VyUnlVaE9FY3RvTVh5dEhYR3JxQ3dmOE9HMDB4?=
 =?utf-8?B?bTYxa0lUdlJDQ041QWVCeExwMVVQTWl5dVhQeGJDQmRPNnFYZmJ6RDM1bkdG?=
 =?utf-8?B?MWZEcll5RFdjaGZCcUtmeFZzMmtSQnR1c2lsMjFOM0JEcHpSNDBIZ1pxS0tr?=
 =?utf-8?B?ZlBKMDVOM20wc3V4K1praTJDMTlWb09HbXBkM3NSMVZRSUt3bmh5c2JURVB2?=
 =?utf-8?B?TXNCbitocW84VERwYXZTNXVhamlLcldMazJmSzFxeTZGRUdtNWpMN3NUODNG?=
 =?utf-8?Q?06HeKQBzYB1PKesBqI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 556e40ae-69b0-4a59-4d99-08de88d7b1c6
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 12:28:31.7094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qvFTdF9v9A6MfzKruFnzw0yeuTK2NbK523vJxlCWAEHKgBkHAYuaTdBLMUxO/KQA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8265

Hi Greg,

On 3/23/26 11:32, Greg KH wrote:
> On Mon, Mar 23, 2026 at 10:51:18AM +0100, Christian König wrote:
>> Hi Li,
>>
>> On 3/23/26 08:10, Li hongliang wrote:
>>> From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
>>>
>>> [ Upstream commit cdb637d339572398821204a1142d8d615668f1e9 ]
>>>
>>> The issue arises when the array 'adev->vcn.vcn_config' is accessed
>>> before checking if the index 'adev->vcn.num_vcn_inst' is within the
>>> bounds of the array.
>>>
>>> The fix involves moving the bounds check before the array access. This
>>> ensures that 'adev->vcn.num_vcn_inst' is within the bounds of the array
>>> before it is used as an index.
>>>
>>> Fixes the below:
>>> drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:1289 amdgpu_discovery_reg_base_init() error: testing array offset 'adev->vcn.num_vcn_inst' after use.
>>
>> well this patch only fixed a compiler warning and has not much practical value otherwise.
>>
>> Why are you sending this for inclusion into the 6.1 kernel?
> 
> Perhaps because it was assigned to CVE-2024-27042?  If this is ONLY a
> compiler warning fix, and NOT an actual vulnerability fix, please let
> cve@kernel.org know about that and they will revoke this CVE.

Thanks a lot for pointing that out, adding cve@kernel.org.

As far as I can see the CVE-2024-27042 is not valid or at least not correctly categorized.

It is correct that there is a potential array overrun in amdgpu_discovery_reg_base_init(), but that function is used to parse a VBIOS table from a flash EEPROM located on the HW and not user input.

If an attacker already had the ability to modify that EEPROM he could just overwrite the VBIOS code were parts are directly executed at bootup and/or driver load. So this problem here wouldn't be needed at all.

It is good that this warning is fixed, but as far as I can see there is no reason whatsoever to backport it nor to assign a CVE entry for it.

Regards,
Christian.

> 
> thanks,
> 
> greg k-h

