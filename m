Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2085.outbound.protection.outlook.com [40.107.244.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5FD227B8B
	for <patches@lists.linux.dev>; Thu,  6 Feb 2025 11:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738842084; cv=fail; b=A/HcNJ3WA9xYZOMB589V/KjJzlBbq1vRL9wGxyJlC01DEt1OnvA1kp7oe25Sg0Z9Nzwd2fqAQhHAajVEcKrlFSH8jtG0eRXgj2y9WQSlB6aGAVjgMODIJgrK5rXhsDSV6GE6bQHYqkRhaT6u4iC0fjH4ccRkaemn+tb9/98tgBA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738842084; c=relaxed/simple;
	bh=Zd6iY0TJEfPR6Mv5NCT7byd7a7OowNEswBRUBI70I+8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WTw7JudKBbJn/ciHvNN+qqGHPbPxo5ouX9aWrQW5YB0jggoXYXgRzngTA3AfvoG8N81b8Ummj8rMRoLpFuWWLMIJFYd4snCOXV4yF7XBwE3FO1trOGXoMCVdTTycUYm43uroGwwjtYEOksCVKh+ln9TxtzU+hR9tlmcyRVu6aek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fIpPwD2A; arc=fail smtp.client-ip=40.107.244.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fIpPwD2A"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C8NEGbgPtJ+9uBv7zL4fB/5tv9EN11BYm8qyfBbNRe3Gvp8/Dg1/uqj36WNZStWBGOoO0dvZzFekY3bD/+kzmLcLsCulDzMzxzrR3kgqrLnO7T0cFcZk5E+iJ1U8VMA9OK5b/bvgtfY3YNO5Odfspz7mesLAN3cFuhBn5vl5VgGbJFdS5HR/Kod90HTCAUgF2Ow+F+17A5j8v4oV2if63/75qx1uhxWAq7xKUi4ekYx5+4vPsPf4X9/R8fGfWVDm+FZ3EoZpgmonBfEfzE5CA8xuH6ozi+zpIrT/7hvvqiXYsS1AKYDfrPK6U8c4+D3EWTCuyJrKoK+XZROHQQn17A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IOxtLE6ehT6KCpt0ERXaG9AgPGdacjl9WzbzGIfb4uI=;
 b=q1NmtCbwsf+gXGbi17hBc9DRODmeM/IKMyUoBWlkrOj2HXPukfGdTggXwPYedf0zYdWHTpA6QDL71Vu67Fr587zjjCEeKPxzFtHsRFsNAU5zbPgwtDiPMwySpXwEQ2fIlBBgNqDYFTLNodujloBi3y0ijo9ZjRXvAvSvfUyHlFskgrTYHpIDKCgFS0sQF/sYyrElJJBH1GIgSsE2mj+ZGyeMweL7Fq0xWnXULsf3o/FcUVhlPmSMVqs5d/Y38G4XnWgZHX0AgbsAoxE3JV7x8k0F81u9f0Wvt85nUG8o2U8vRgd00rasaqONzuWbONaPWlpsd4nAwUclcYfs4Fw1/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IOxtLE6ehT6KCpt0ERXaG9AgPGdacjl9WzbzGIfb4uI=;
 b=fIpPwD2AIaKb9bcIzcTRkKhmW0AQgx4TLu6NXSwM1BLkYIOMooftYz4uNq33QNyWbzEToMeOP+gFfE7TtM8ei63YhSz+6nmGvRM4W//9Y+e7JqMiKXwHCIDfGfzGxcawFLQVtVvqBMwv6cm07kMlmNCg18yYMnw3Nvx+qmScCuaC/4fjUqvabAM9vAgLymLKf/6vOFN6ufilbloP3gLFepNQJsxCP1c/PzieJyHZkz61o1OXDAgjPgXRAROMsj14/pGc1JfpHyZ3WdUTjdQvp6UOcqmz7kxWwHhhX/F+q9GzPjAOKqLfuou1MwUglUKyv70pdyzda4RVz63Qm6/d8g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB8761.namprd12.prod.outlook.com (2603:10b6:806:312::15)
 by PH0PR12MB8152.namprd12.prod.outlook.com (2603:10b6:510:292::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.12; Thu, 6 Feb
 2025 11:41:19 +0000
Received: from SA3PR12MB8761.namprd12.prod.outlook.com
 ([fe80::f72e:615c:e83f:b78d]) by SA3PR12MB8761.namprd12.prod.outlook.com
 ([fe80::f72e:615c:e83f:b78d%6]) with mapi id 15.20.8422.009; Thu, 6 Feb 2025
 11:41:18 +0000
Message-ID: <b7363e74-2207-4cab-a573-bc552b901f4e@nvidia.com>
Date: Thu, 6 Feb 2025 11:41:13 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/590] 6.12.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20250205134455.220373560@linuxfoundation.org>
 <ea698e1c-02a8-47f8-a66c-b7e649dd417f@rnnvmail205.nvidia.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <ea698e1c-02a8-47f8-a66c-b7e649dd417f@rnnvmail205.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0333.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::33) To SA3PR12MB8761.namprd12.prod.outlook.com
 (2603:10b6:806:312::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR12MB8761:EE_|PH0PR12MB8152:EE_
X-MS-Office365-Filtering-Correlation-Id: 4dc30580-6bf0-4bd4-3618-08dd46a32bc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NmhZT1FEVDVQNFpMOGNNSCtVVGJraGhFMCsxL01HMEw4UG10SjI1WjlJWkx4?=
 =?utf-8?B?SElEUGdpaFpuakFXZE5pOUlJUmdCOGtDeEhVQkVUdUlVVys2OVBqK0dPbXM1?=
 =?utf-8?B?UDRhc00yYzhQU2ZaZHBjcGNBZ0hscHlxZWgvSFJZTjhhRkdmeGZKMTBXbWZN?=
 =?utf-8?B?M2hKd1pKcDduRTlnSkhWN3ZSOWZlZlJHMzh2SCtheVlpUXpzZWVwalFrc2wv?=
 =?utf-8?B?RnVkM29YTnRVVlV3bEZqZ0M3Nm45VkRyRVpWSCtaOHJ2VDJDUUxucTYrVGt0?=
 =?utf-8?B?RUFXMU40eFhWVytQU2VwcUN6K1dHOGw4UnZ2V00rMS9SdzIwaEt5U0tpSFU5?=
 =?utf-8?B?dGlRbCtucXZNTEpHWjMyaW5mN2oxYXRiUUgwN0FQQTlIVm1SRncvbCtvVmJx?=
 =?utf-8?B?ZGx5OXpiTy9MU2s4cDRISkFPcDJSYlZTanlXMm1obVcxM1FnckQ4K2t6ay9H?=
 =?utf-8?B?MHA2Znk5M3hpOWtvQ2RpcWVzdTJFZEsveC9nSWlQM3llbkpYL1dDbTNiYVlE?=
 =?utf-8?B?djcxbG82Ym9UUkhjZDhTUmRTZnJ0cnhiT0phbHNHR1h0NWo5dzgyNE9uNExX?=
 =?utf-8?B?R2lnNSszalQ0OENKNnp2OFgvcThqOU9LREZqUm1Td3d6SHFtc2xCRjgxbnlL?=
 =?utf-8?B?aHdMMTFNSVhZajdML3ZPRGVnckdETm42WWlqN0h0Q3JZNXhCTEQ4NjNpNit4?=
 =?utf-8?B?aFZ2NjRoeThrOU1VMk5YRUNIMUgrK05BZklhekJFdUxBZVJtUHplUTdHRW1l?=
 =?utf-8?B?L1ZEazlWQjR3elBJSWptL3MrQXl2ZlR5RHBtZEtHL0dZditpaGZITmV5WWpU?=
 =?utf-8?B?Z210UTBtZmtjQ2VuSVoxS1o2UGtDYW5iak1GQURUblVuVFJ2bWlOWTYzL21T?=
 =?utf-8?B?WGdtYVNkQU5pWWFFbmJpaTkraFJicE05Q1FXaTFzZTBESlZGUCt5bTl6Vjcw?=
 =?utf-8?B?cDF0WnczY01GWWpyYXowYVd2Y09lY3lLMit2alJEVU5xRWNOZlRsa3NoQ2lJ?=
 =?utf-8?B?UktiN3ZRb1VFUFdNYkNPK2phc0lPZEEwRzRjTjZsNHRtbkQzNW5vejNjWXJY?=
 =?utf-8?B?MXhTWkIwcFhtNFI4R3hDV1psVHVYL0s1VXBvZXZUc3UyRXBZclZQVWlnQmpt?=
 =?utf-8?B?Zmh1ZkFZckdzTGZ0dU9QN29LTDlCWkdrMktveExGallxWXlNME5VVzdmN2Ri?=
 =?utf-8?B?amduY2xTU3prVm5Ic3NkdC9UM202S29ub1dGWGdXQUcxS2NYWE92SndTbGI0?=
 =?utf-8?B?cmRDSlRUMEIycGdRYkg2VzAxVVFIbFRKMXNRM0FRbklPN2NWR05mYzU0bHNo?=
 =?utf-8?B?RnRIQnlkc2paS2pKd2x2MjdBWjVLMkNja0VFNEJ3Q1JJTmZDcHZ5TTNHdVFJ?=
 =?utf-8?B?T1ZIQnFwL0FUY3VqZWVzV2J3V0V5dWZZUk02UkM1L05rS0lFa3hxbGRBM0lZ?=
 =?utf-8?B?VGNZdlZ1WVZrWVJyTWszYzhuZnd1V2JRRlN0ck9ENmpKNiswRWdEZFdOSGh5?=
 =?utf-8?B?R0JtY09oOXNLQkNrNXlPbXkzMlRlQm5qaGsrUWhtU0pIejBueVdjWnUxUXgy?=
 =?utf-8?B?UWw0ODgwOHBxQ3VOQjIwWkhyaXFVazROTzRtYllFTVF1VW5yM05WV2ZPWHNG?=
 =?utf-8?B?cTdiM0VESTJqZUVwekp2REhOeUw1YjJucWxqbFBPbWJtYjU0TXdaMzA5QWo4?=
 =?utf-8?B?L2hXM3lDMFlaelRSNVNEbk0xOFhYaVNsM0RlUEFuTGNmd3ZURDQrL2xFNFVS?=
 =?utf-8?B?TndOMStkOXV2VEtaajk1eSsweFFZeUlTZUpib0l5eCs2QlUxQ3FvdUx0c0Vv?=
 =?utf-8?B?YVZDUWRxb1BNSTlwWE1va044b3FEVm1ITzVIMjA1ZFF6U2YyR2dDVHFnUUdx?=
 =?utf-8?Q?0AHHhUXqtNuzB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB8761.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aVJQeU4vUTcxczAyajliR3VoOWtZMVgwTVdpOTE4OW1yZGJLa1JtWm5YKzhN?=
 =?utf-8?B?V0dyZWhsQ0NNYUtJVlFqc3BzR1VJWFB0SSs3bnE4UWJOdkFKeGpsb1NmV1BU?=
 =?utf-8?B?WWQ4QXpKR21ibXlJd3RuajBSakNxZ3hmM3ZuYVRaZHpLdVJzSGdBOFhSL1lC?=
 =?utf-8?B?QnFRdUIzQjZTT0JzbSsvMzEvSTBSYjlMcmZMdGwwWEtWUHhaTVNhM2Q1MVdz?=
 =?utf-8?B?Sy9RNDBzQ1kwb3loVTc5QThLTnE0bmlRSzhVVXlzeTArWStVUFVHdTFvU09o?=
 =?utf-8?B?YkVZUmNpVlZJR0FKQ1FXY2F4V2ZDNTd2azRBNFJzVCtDZm9acTFCZytlSHp1?=
 =?utf-8?B?Um9TaEN3ZTJXVEZyZ1U3eWV3UjZRaGVoQjZoL2EwY2dXcHFGa3ZDRDcwRHFv?=
 =?utf-8?B?aHVwQjE1Rmx1ZU40R08xRlppa0tuMWNSaUVZNGV2WGdNcjZTdmdPZ25rN0JR?=
 =?utf-8?B?QVdIWGtVdUJ3eW5nVXBoQ0RHMnI0M2MzOTdYVHNBL1VPRm9CbGoydmdlOG15?=
 =?utf-8?B?S0lnaWhFbHo2UTg3MVV4WXAvSForS21rZUNuTkc2QkdNUzVSdG5PV2xVRTd5?=
 =?utf-8?B?cmZ4Q0d5QUkzb2tGK0VyTDR2aDN6cDlWVEg5azRtQ1ZwZ1FuSFA5ajcvKzFT?=
 =?utf-8?B?TUFHcnBjeUphY21HN20zVEozcFQzTndxM2hiUjhEd3dqKyswMVdPYlV3UVRR?=
 =?utf-8?B?ZUlKbjVLcitXUjVwSHAyQlc4cTdhN2U5akVGTnU4OWxVV0hqK01tUHpaempX?=
 =?utf-8?B?M1pycUZ0cllnN1J5OXJENWRnVWVHYnFhMzB1MkpBLzNoY1krMDV4UkMwZWND?=
 =?utf-8?B?aS9GQUZmaXQxVlozQVlldnc3ZWlKa29IRm9pQTFmWThXam1RM3pveHkwZm16?=
 =?utf-8?B?Lzk3QTIybFYzSlhCSElURHVTbStnZTdGVHhDR21kdnVvcWttcjdpTHRPQ1BB?=
 =?utf-8?B?L2g3cllBdzhMdUEzL2JUNVNQRSs0SVFCekk5cC90Wks1U3NRdHg0ektJQU90?=
 =?utf-8?B?WHhKcm1kMlZORU4yVDcvRzJGNEJwZVg5VWFnVVZ0SkJwTlBTN0dUMjlocTNk?=
 =?utf-8?B?citvSjdPZnBIZkF0WFZpaGVhY1lBYUFjT2FmNDhlZ1NEdXB0R3dPY2EzazAx?=
 =?utf-8?B?OUlvMjluQWkyamRmVUtFelF6WVhzRVBUcFRNalltZjc3aWlkTk85UTJlL1pt?=
 =?utf-8?B?ejQrMUtod3JqTEI0eGROR1RxOFpuVlFWUzZKTk9odGswQ2tjUG81Qk53TmhK?=
 =?utf-8?B?WVpqVzZhTXFQZ2REYkpxNk9QK2VGenA0Z0NMazI4dTZHT1lORFo4WnFnVzM2?=
 =?utf-8?B?clNoUnVGUVFDak5nSk1tbFFLWVZXbW1sc05XVTI1QjcxZFVSZFlJM3hoQWFp?=
 =?utf-8?B?czQ1WmtkVzNEYkViUW83aFB6Vjh3cGo5RDFEWXdBeU02dVd1aXhSU2VZdlBX?=
 =?utf-8?B?eUcvSm92VitlN3VkMGJKZGlwdEZkRTFhOWZscXpPSW81K1RSeHN3SUpKVk5w?=
 =?utf-8?B?R1I4d21NR2swaStTOFpwUzFlbDZ0TXVPZzZTNU1aQ1FsT1RnVFFvT0RwV0Jr?=
 =?utf-8?B?V2RScEk0cGVORTVYWHBJM0lVSnBJdTNCK0ZLVkdvWXM4QTA3WHM1eXU1Vmpp?=
 =?utf-8?B?dmFHQzNmVERqaC9vWW9VU2RQbzdFYmZvaFp1VjA2cGhmM0dKbXJHbXlXSVBn?=
 =?utf-8?B?cGZlWTdHcFRQblBaRUdlM0cyYm9lYUpXcmMwQS9lMllHU3hKNWMxa0pqNTZW?=
 =?utf-8?B?Z1BZUDBzMWdmMStkbHE2TEozS0RrbUJ5NDFDR0VtMS93Rm5wd0N3dnhEc0ZD?=
 =?utf-8?B?emZJZUpkSUdKNzhOSkZja2E2cStRVUFNWnBoTWFGdzl3VnZmSGtya1p1NGc5?=
 =?utf-8?B?NU9oMGxvNFVNUjI5ZkVFMXdkN3RDN3hKVFhsWDFCMnNFR2I1bWtseTFlL1Zz?=
 =?utf-8?B?YU9BQWtUQ2tMNFV5b2o5ZFgrVGt4TzlCSWdtMFl5T0E1cnhycVBUY283QUxT?=
 =?utf-8?B?dVJ1R1BZTGhUdU4wU3BDc3BHaE5YUHZxTXBwU0Vsdk5qY2FSMk90cWRIbStF?=
 =?utf-8?B?bG5pWlhlQUNISG0xbkZzTUdyM3JFcWhHWU1YUXZOcVBoNWc4S0taekJob2tN?=
 =?utf-8?Q?GpYZLe6mwM3RTBIlmLTe7rOXZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dc30580-6bf0-4bd4-3618-08dd46a32bc6
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB8761.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2025 11:41:18.7248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DBH2dmrVgBDyMkUPMoer7K9u3sC50jcfdNp7/lxP+DdBga8MkbMFAWxceQngOnby9k1gaXMAJGRAvkB0VDLwuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8152

Hi Greg,

On 06/02/2025 11:37, Jon Hunter wrote:
> On Wed, 05 Feb 2025 14:35:55 +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.12.13 release.
>> There are 590 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 07 Feb 2025 13:43:01 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.13-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Failures detected for Tegra ...
> 
> Test results for stable-v6.12:
>      10 builds:	10 pass, 0 fail
>      26 boots:	26 pass, 0 fail
>      116 tests:	115 pass, 1 fail
> 
> Linux version:	6.12.13-rc1-g9ca4cdc5e984
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                  tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>                  tegra20-ventana, tegra210-p2371-2180,
>                  tegra210-p3450-0000, tegra30-cardhu-a04
> 
> Test failures:	tegra194-p2972-0000: pm-system-suspend.sh


I am seeing a suspend regression on both 6.12.y and 6.13.y and bisect is
pointing to the following commit ...

# first bad commit: [ca20473b60926b94fdf58f971ccda43e866c32d1] PM: sleep: core: Synchronize runtime PM status of parents and children

This is the crash log I am seeing ...

[  216.035765] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
[  216.035982] Mem abort info:
[  216.036055]   ESR = 0x0000000096000004
[  216.036147]   EC = 0x25: DABT (current EL), IL = 32 bits
[  216.036276]   SET = 0, FnV = 0
[  216.036349]   EA = 0, S1PTW = 0
[  216.036424]   FSC = 0x04: level 0 translation fault
[  216.036544] Data abort info:
[  216.036612]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
[  216.036736]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[  216.036848]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[  216.036982] user pgtable: 4k pages, 48-bit VAs, pgdp=00000001161af000
[  216.037126] [0000000000000000] pgd=0000000000000000, p4d=0000000000000000
[  216.037340] Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
[  216.037474] Modules linked in: snd_soc_tegra210_admaif snd_soc_tegra_pcm snd_soc_tegra186_asrc snd_soc_tegra210_mixer snd_soc_tegra210_ope snd_soc_tegra210_dmic snd_soc_tegra210_mvc snd_soc_tegra210_amx snd_soc_tegra210_adx snd_soc_tegra210_sfc snd_soc_tegra210_i2s tegra_drm drm_dp_aux_bus cec drm_display_helper drm_kms_helper tegra210_adma snd_soc_tegra210_ahub ucsi_ccg snd_soc_rt5659 typec_ucsi drm backlight crct10dif_ce snd_soc_rl6231 typec ina3221 snd_soc_tegra_audio_graph_card snd_soc_audio_graph_card snd_soc_simple_card_utils pwm_fan pwm_tegra snd_hda_codec_hdmi tegra_aconnect snd_hda_tegra phy_tegra194_p2u snd_hda_codec snd_hda_core tegra_xudc at24 lm90 pcie_tegra194 host1x tegra_bpmp_thermal ip_tables x_tables ipv6
[  216.078599] CPU: 3 UID: 0 PID: 14542 Comm: rtcwake Tainted: G        W          6.12.13-rc1-g9ca4cdc5e984 #1
[  216.088830] Tainted: [W]=WARN
[  216.091978] Hardware name: NVIDIA Jetson AGX Xavier Developer Kit (DT)
[  216.098287] pstate: 80400009 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  216.105628] pc : simple_pm_bus_runtime_suspend+0x14/0x48
[  216.110883] lr : pm_generic_runtime_suspend+0x2c/0x44
[  216.116132] sp : ffff80009180baf0
[  216.119545] x29: ffff80009180baf0 x28: ffff0000873f9140 x27: 0000000000000000
[  216.127152] x26: ffff800082b339b8 x25: ffff800082d09000 x24: ffff800080931f4c
[  216.134245] x23: 0000000000000000 x22: 0000000000000002 x21: ffff800082d09000
[  216.141596] x20: ffff80008092d498 x19: ffff0000808ec410 x18: ffffffffffff4a00
[  216.149116] x17: 2033303a35353a36 x16: 312031312d39302d x15: 000048df7f6eda30
[  216.156378] x14: ffff0000873f91c0 x13: 0000000000000001 x12: 0000000000000001
[  216.163552] x11: 000000320f13ac60 x10: 0000000000000a90 x9 : ffff80009180b8f0
[  216.170645] x8 : ffff0000873f9c30 x7 : ffff0003fde5ca80 x6 : 0000000000000000
[  216.177991] x5 : 0000000000000000 x4 : ffff800081f78680 x3 : ffff0000808ec410
[  216.184908] x2 : ffff8000805bd4ec x1 : 0000000000000000 x0 : 0000000000000000
[  216.192169] Call trace:
[  216.194619]  simple_pm_bus_runtime_suspend+0x14/0x48
[  216.199613]  pm_generic_runtime_suspend+0x2c/0x44
[  216.204159]  pm_runtime_force_suspend+0x54/0x14c
[  216.208966]  device_suspend_noirq+0x6c/0x278
[  216.213169]  dpm_suspend_noirq+0xc0/0x198
[  216.217452]  suspend_devices_and_enter+0x210/0x4c0
[  216.222265]  pm_suspend+0x164/0x1c8
[  216.225682]  state_store+0x8c/0xfc
[  216.229181]  kobj_attr_store+0x18/0x2c
[  216.233116]  sysfs_kf_write+0x44/0x54
[  216.236616]  kernfs_fop_write_iter+0x118/0x1a8
[  216.240824]  vfs_write+0x2b0/0x35c
[  216.244062]  ksys_write+0x68/0xf4
[  216.247727]  __arm64_sys_write+0x1c/0x28
[  216.251236]  invoke_syscall+0x48/0x110
[  216.255428]  el0_svc_common.constprop.0+0x40/0xe8
[  216.259981]  do_el0_svc+0x20/0x2c
[  216.263215]  el0_svc+0x30/0xd0
[  216.266109]  el0t_64_sync_handler+0x13c/0x158
[  216.270572]  el0t_64_sync+0x190/0x194
[  216.274252] Code: a9be7bfd 910003fd a90153f3 f9403c00 (f9400014)
[  216.280303] ---[ end trace 0000000000000000 ]---

Thanks
Jon

-- 
nvpublic

