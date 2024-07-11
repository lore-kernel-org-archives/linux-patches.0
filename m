Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2084.outbound.protection.outlook.com [40.107.93.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B644644C
	for <patches@lists.linux.dev>; Thu, 11 Jul 2024 19:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720725400; cv=fail; b=SrFxZ6HGN4hknMBIiKH28frkcl9F4TuD3gCuVbZvk9BJjIWUdD5e/5UONDsV0y0qQnNC40hsMNBZKACJArljIT2RYFASnFo7oeg9SFUQO+k518zK+94jUuMMhNEBnD58YgeDg6RfPLtZ9S72d/+3nJir1CRB8o7apx7G4pcL6i0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720725400; c=relaxed/simple;
	bh=ASCAdsOaUxrnNlvROhxOO7zoEpWx/GPzjiAj1cW9ICU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Mf87vusfzMrVAHHiDi7ZtbvzQ7yYHvEOLm1TQKebdhAeCgUc3UjYRr4Vm4cL/vdy+sCXd962LCk5ohllOGGw9b+P7Q04K2r2EEUPpE50QlW7D03dFCezFMYwh0MBGPr9ymGxhTljksU+5qHqjBf0QwKV4lGR/pOmQlnw5SOOFcI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jnyk+hd+; arc=fail smtp.client-ip=40.107.93.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jnyk+hd+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A1LVOPBqlmshCUgZvcnJGwZjvNmY0BreNrHWsgamc/zF1St5GfGGvpJMgStWOC/rWozGc8mAtjOxF3Kt5jOsoa0zDH6+mXlwTHC4WAQIo2Ej90eS90Cl4B48ZgFsU4NUiJuA4KGhR8jT7CeZPJNoYu6Ai9waD6WHgJ43NIUGhVoIV+Ruj4t3jvbvTRTMmZ27iB5Mcyc0wbluAwbmpi1tyMXN+/0SUl7eHihoZNNmkXMG+v3RYQw82qAa4ewdW4h1ahbq6a1prrGzZ0QaRwxsGHG82wc3GuNR0BnrrKl6dfboxYzo2IzkBdu37IZn9RNiJpeO38r7NHg/YoeAJYq9IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P9miaHnPE/4PjlC8PnXrFuvygIzhgMtr9KEHnuk3vsI=;
 b=GmDl/KmxyTv5sFOW7LJ6pXoBcHt1poOdbbthDmptWTzH4RpRjZrmvRI0K+n8J8fYIvI5PIyRAZxbpGLzpe/eaVCL7vyw68zUudhiftcg0xnxjornXvMtOwGg4L9CyhRjkcGjWn+dBh+TtrnZhnt+b1rN4W5jKGqehmyz0dQs6gy0Pne71P5DSVtqHZJk/YLf2yv6xchSmCvM8oVMondlx3dWPtloTDPuB+6+jhoWacaleCHvLuHXsjsRLrJNgZQED/0FeQ3i4iIyWZVwU6+o+hjI2k9kAJsRs+BEvxOlhV1Glq7wYzG0n0sq4mcELPBBbQgGtHpkkkyND4IKjBJwpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P9miaHnPE/4PjlC8PnXrFuvygIzhgMtr9KEHnuk3vsI=;
 b=jnyk+hd+yifpFlu4cTG1joNK0pjTCYoGGEyNJ7Im5+oMDAM/5qIOk/qrKOdGpNBUVtGMY02IDff5dRBmedvWMTKrwCXO/3hWjLz0U5xgwAvn7UsVN5ky0OBMPjxHaKHIlptzVaG+T3O8EazWH8Kess5s07/2m7ZJshQkhqi9gy2IKVD1MePVmJDhozs0U0GKtHwKiLC7IKbjrLz3ryTFs7EojWU2rGqXKktDNK0M0diuH8oLmaSnFngTCh7ne/Adq5/5gYrpfB20R8u8giGFDrOfxZSxYvsznjmUPTraRejhWrC8X5Pl0adoKOh0QjswbzCrh6eMGsgCPYwPTnqckA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16)
 by MN0PR12MB5884.namprd12.prod.outlook.com (2603:10b6:208:37c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.36; Thu, 11 Jul
 2024 19:16:27 +0000
Received: from BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::2cf4:5198:354a:cd07]) by BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::2cf4:5198:354a:cd07%2]) with mapi id 15.20.7762.016; Thu, 11 Jul 2024
 19:16:27 +0000
Message-ID: <dfe78e1b-eaf9-41e6-8513-59efc02633fd@nvidia.com>
Date: Thu, 11 Jul 2024 12:15:34 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 046/139] selftests/net: fix uninitialized variables
To: Ignat Korchagin <ignat@cloudflare.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Willem de Bruijn <willemb@google.com>, Mat Martineau <martineau@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>,
 kernel-team@cloudflare.com
References: <20240709110658.146853929@linuxfoundation.org>
 <20240709110659.948165869@linuxfoundation.org>
 <8B1717DB-8C4A-47EE-B28C-170B630C4639@cloudflare.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <8B1717DB-8C4A-47EE-B28C-170B630C4639@cloudflare.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::35) To BY5PR12MB4130.namprd12.prod.outlook.com
 (2603:10b6:a03:20b::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB4130:EE_|MN0PR12MB5884:EE_
X-MS-Office365-Filtering-Correlation-Id: 54fcee99-5068-4139-6ad4-08dca1ddf694
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K1BrS1c2bmxtaFlybnVCWUp4TGpZR2tZZFU3NjVBN1FlWWhIWk4wUmNidk51?=
 =?utf-8?B?c0Q4dWcvRFVUMDZCWUFYTVdvZWRJV2kveXN0ai9VeUE3d1ZsM24zTVZJRngw?=
 =?utf-8?B?TjZScnRZa2MxTzR5dVN6VGdySWpOUjFHNnlCdTdoVG9aSEJhZjQ5T1R3bmM5?=
 =?utf-8?B?ZjRoeGJCWkljVWpUb0d3MVh4TEhSNjVWSFhPY1JQNmJXUzh5YmRYSk94OWRu?=
 =?utf-8?B?WnNxQXVCWkF1dUI3aGYvdUZrdFdwdWx5RGpnZzZzVEZ6UzZvcTN0MVVwWGFl?=
 =?utf-8?B?eld6Z3paRVlYQVVSUG1DaVBzNnQrclhsUnhnTSt2VUFuUC9pdTJFclFlY1Vy?=
 =?utf-8?B?dkQ4cWIrMXh0S0QvWUhZSzdMQWhEb0RMcG00cDVOTXhFb240aTlrbHhLTWQw?=
 =?utf-8?B?cUxwVlp1blhRS014ZTdockJ0TjhxS0lDMnQ4YW5sWjJkN2w5OGJpMmNNdmx4?=
 =?utf-8?B?Z01zU0hibnhtM0hITUc0K1ZMdEhMR0NNM1djZml2SkppS1Z5aSs4QWlNY21H?=
 =?utf-8?B?Vm9nM3pNNXM1cy9FNXlKS3JyazEvdjN1YnhPK0luL2VVSU1zUmFYUlRPY0Ni?=
 =?utf-8?B?QzBkOTRZenVUanRBODBlK09tZDVXSHNMUFg3eC9Nb3QrZ0xRSGlHWUJOSmY1?=
 =?utf-8?B?dDFCTklnc05OMC84dS95OGtta0FiS1lLTTZHc2MvSkNNWmRvUlhyRlZ4SDRN?=
 =?utf-8?B?OERqVy85VFhockZYVUNwd3had1MxRnJmQkZyaFhlTlZTaTl4OE01QlViUWFB?=
 =?utf-8?B?TEh6cGo0d2ZFZXc0Z3NLNmxjNUNuTytid2cxakQzcGRpOHQxdzZ5bjlHNnow?=
 =?utf-8?B?NnNXcENLM3M3VXNQZ0VwSmZqdWQxUlJkd3hEWk16YlNnZnNvRW42T3MzQ1k4?=
 =?utf-8?B?d29RUHl0aTN3V1R1V1BUa3J0c1dPT1VWUlk4VWlyWUp6bVlmRW95blpVVm5h?=
 =?utf-8?B?ZTIyVFhrSm5PcU9lK2lSK1Y4dCtEMEVGT3V1K01nSnJ2Z2NqTEVVdW1YWVFO?=
 =?utf-8?B?UGVDdEtSVnBqRllNSzRHZWdwVTZUalQwODN6bXptZm8vWTlaRXBkamttYVIz?=
 =?utf-8?B?SnMrS2xXTEN3MDZCZk9IMEFwNUNPS3VsSjJCdlVjdTkzdzV1akE2bzRZQ0ti?=
 =?utf-8?B?SnZWdDNjSms0RUhiNjZkdFJJUnc5enVxRnY2cnJCa1hoRVIwNjhydHUzbG04?=
 =?utf-8?B?aGwzaFd3emVSN1pZeS9ORXhTL3poVlI0dzlpNjFiR3J0RjdXMWR6Nng2N1Rq?=
 =?utf-8?B?Qlk0dllabWF0OFJyTTRtTCt1ZGY4MmZRbDNtZENrYWhHZG43blhtazBwYnFm?=
 =?utf-8?B?YmhKQ2EraGUxcnk1VmZiYjF0bjIxdHFpM29SbjdpakJUaC8vZlkyMm9qaU5H?=
 =?utf-8?B?cGNsSmQ4d0xYcTloRlh6akZLZkpSVU15amk3dk5CWWY2NzhaclNtVWtMZ2Rl?=
 =?utf-8?B?eU8wWVR2WEhrWlhJbFV4UGdPSlMxL1pnWWZjRmFPcWlKZUJvbE5LSVRtbWtI?=
 =?utf-8?B?ZkdkTnlzR3kyaDVHaFBHRCt4V0h2cmhsNzkrY2pPa1hMYlNkSnNRRnlpSzUx?=
 =?utf-8?B?OGRuOFZHWjlhWHFQNy9UNVo1R2tobmNCRDUrdDljcnJKRDArQzk2SjZqcFlE?=
 =?utf-8?B?a1VyaDVQRSs3M2ZyS3lSMndoeW1aZ25VK3FHeThqTHozRnBwdWY1MlMxbURN?=
 =?utf-8?B?cW5OWS9NaE1XTUNDRUhBTEYxNW4xcjExaTFJd1VrbEVybnVtTHJ1MFFJMGJG?=
 =?utf-8?B?WEFxRWgxcUIvWW9reSs1NkF5UXpZNU5MUUppWm5HVzNkL3ZHSHNaRFFvd3hR?=
 =?utf-8?Q?hp4MEtkq/oNX1pZ0Ij8wbGpyB16o0bNoWRKIk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4130.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cnluNUE3Tk8weVhqeGdyWXBiMWlHT2ZHU2Mrbjl5SXp3UkRkQ1M4QmtaSGZO?=
 =?utf-8?B?T0FJUnpYa1o0UHdZRm1xbTE5ek91ZnVBVGpOSm5ScE8xK2lmV2xnQ3BKZG1a?=
 =?utf-8?B?QXhPcVRpUUE3emtDUWYrQ3p5bXJNT2hwR09zNnZtYysxazRqZGZnL084NXhM?=
 =?utf-8?B?UEwycElYQ2xUY2VHMTEzUjFrZjFUVENEdTBYMVlUYmVoSWcwWTJ6SWxhOHBW?=
 =?utf-8?B?Mk9DajRRcERFbncrK21NTWNUUktHcnFucTdDUHNlUEhCTXYzdjlBSTR5N3ll?=
 =?utf-8?B?dlZpZDZ0cDhQK0ZINTNYenJ6KzlYdFRjSWpoZVUvSDcvRFp6ZUNFWkNaUmsw?=
 =?utf-8?B?aUZKUFlKMEgwWGRJaHBRVnp5Umt2aWtsckJMSk4zTU5JQjZzRFcwSUdURHgy?=
 =?utf-8?B?T2xqYkdzaWtIbGVFZnlwbFFiV2RWdm01ZEdaQjNaeDlRZlVsZktjd0VCaWlB?=
 =?utf-8?B?NThOUEp5OExNUnlQUXRPRFlNaGN5RG5Hc1dibE55d0VNYklibXdod0FoRWVX?=
 =?utf-8?B?K2ZkSGZ5dUIzMEpEY2ZSYjNiWjlXcUlxZnpyM1h0NDhsVXVDQVQ1TVh1b2E1?=
 =?utf-8?B?OEMrU2JiRVBQd29qcXlBbG93V2dQZXp1MmlLcUlYTTlLWnRCK3dES2RjT2tC?=
 =?utf-8?B?bkNQYWpZbUFGUTNKTDdqNjEvZDNONG42ZVdKWVowS2pZWENweEZYRkJzaVly?=
 =?utf-8?B?QTdaOFNIdzl0eWZaNFR0aDVhVmNPNWlxUStuY2FPdkpIVlhWcjhHMDFEbUdD?=
 =?utf-8?B?N1J5bXdpQ1pVK2FsT3VCK3p2QUxjNXRzSTRuTG9Pb2tPcm5KN200ZmU3dWZm?=
 =?utf-8?B?M3ljTmdtOTRYb01OUHdXaTU2NnkrYkRVNDZON0JPRGs4MmJtTzY2aVp4TklV?=
 =?utf-8?B?cXdkQTVhQ1ljSlZtQkpyd1NjUml2bFg1eUttODJSZmNoNFpycW91Z3pzV25M?=
 =?utf-8?B?amFvV3lFQVlPcDZ0YUNwRnoxby9nS0dYZjQyaC9YWjVROG1ncERyeFZSV0x3?=
 =?utf-8?B?VWxtaHRNT2o3eDhzVkt6SGo4NHV1UzZxajE5aVFmS3VHZDZ4aEt6cFgrOENI?=
 =?utf-8?B?YUR4dDdVeVMzWUI0Q2Z2R0pjTEJKTnlJVHBiU01yOTU0dmR5MHhYeUw5Qnhu?=
 =?utf-8?B?M0FNV1dSaElIT2wzOS9MLzIzdjhNaGIzUzBIc2ROcUhISCswTUhrMExrWFY5?=
 =?utf-8?B?MnJXZWQ5VzBYbklwZXRFTlQyZmdPcU5Na25MejRGY09LZzk4bTR2WmRqTmM2?=
 =?utf-8?B?QzFDVFRXZWJRMEZvYkdtU0poTzJUWDlHa0VJZ1RHZlVzNkM5SFBHcXZseW1F?=
 =?utf-8?B?cGIveXJ4YzRkQjJjNkNIRXMrbVBiMnRnS1FiZ1Y3bGx0b0N1bStVUWx1MkR1?=
 =?utf-8?B?TnhENGJJSy9sbkprUFNKZEVxMHh4WGdqbGhBcWdRRjRXK2FrZ05yQjdTV1gv?=
 =?utf-8?B?ZDRPdE1BZldWbjNVYU01bFAwTnBUSGp2a2JaZHNvM1lhemxDWFZKTEF0WDJE?=
 =?utf-8?B?WUwyVDlCUGZZRnBCbWFWaXVjdlkxaHRneXF3Mlc2MXFmZVIyTzRIMUVMNndO?=
 =?utf-8?B?UlZ2cU9uNXZsM1BzTlhzZWpkSEx3MHVtTlQ3dHhIcG1jQXhVcENUVXVTYnNo?=
 =?utf-8?B?REErQTgzU0tjVS9IU1FHalZsNkE3YjUwKzIrZ2toZ2RrZFk0SkhrZWhmT1hC?=
 =?utf-8?B?TWlXSDdIaUhDNlBZbld0QXhyM0FEZWI2bWdEY2cwSzRmeS8za205MVZ4K0JB?=
 =?utf-8?B?OTEzZ1VoQWxJK0ZSczhxbnh5cGhTTGphOTdOVFV2ZnAvT0p6YVNacnY5UGFO?=
 =?utf-8?B?d1prREdudG9iL1Vidjd5ZE4wRW9Rb01ZMmVwZjh5TEtIVXJQbG9UdW05Tll0?=
 =?utf-8?B?QlNqMlljM0dXV1pzRi9reGw2bmd5VXFtdlJBUmh1em9RRjlmem5wK0ZMVFp4?=
 =?utf-8?B?K0M3cnZtL0RHT2p5MFExa0wzMnpGRi9nTTBRK2ZDZ0MrQU1tVitYclBrUjJN?=
 =?utf-8?B?SC81V1RBd0FJU2xjOGZmdkY2QmxGVGxTbVpLVkFKTkFBRHpEWCtlOWZOVnFX?=
 =?utf-8?B?SkYxSnpxOXFUS2NlVFpxb01FN20yUmJ6NzJEWDAwWVVydlh6bDBEQ1AxSFRh?=
 =?utf-8?B?WkkwekY5OExPT1J5RFRhektSc1NNYzc2VERVeSsvcjhiUUhhaFNKa1ROUFBh?=
 =?utf-8?B?UWc9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54fcee99-5068-4139-6ad4-08dca1ddf694
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4130.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2024 19:16:27.7295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ERnIEQ+Pdr2nf1inYikw/jvBN2gK/847XY4weD9dxyp5sgDrNd+bkqkIqehtqdcUWn7Ap00UHpaMW42XLeebrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5884


On 7/11/24 8:31 AM, Ignat Korchagin wrote:
> Hi,
>> On 9 Jul 2024, at 12:09, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>>
>> 6.6-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: John Hubbard <jhubbard@nvidia.com>
>>
>> [ Upstream commit eb709b5f6536636dfb87b85ded0b2af9bb6cd9e6 ]
>>
>> When building with clang, via:
>>
>>     make LLVM=1 -C tools/testing/selftest
>>
>> ...clang warns about three variables that are not initialized in all
>> cases:
>>
>> 1) The opt_ipproto_off variable is used uninitialized if "testname" is
>> not "ip". Willem de Bruijn pointed out that this is an actual bug, and
>> suggested the fix that I'm using here (thanks!).
>>
>> 2) The addr_len is used uninitialized, but only in the assert case,
>>    which bails out, so this is harmless.
>>
>> 3) The family variable in add_listener() is only used uninitialized in
>>    the error case (neither IPv4 nor IPv6 is specified), so it's also
>>    harmless.
>>
>> Fix by initializing each variable.
>>
>> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
>> Reviewed-by: Willem de Bruijn <willemb@google.com>
>> Acked-by: Mat Martineau <martineau@kernel.org>
>> Link: https://lore.kernel.org/r/20240506190204.28497-1-jhubbard@nvidia.com
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>> tools/testing/selftests/net/gro.c                 | 3 +++
>> tools/testing/selftests/net/ip_local_port_range.c | 2 +-
>> tools/testing/selftests/net/mptcp/pm_nl_ctl.c     | 2 +-
>> 3 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/testing/selftests/net/gro.c b/tools/testing/selftests/net/gro.c
>> index 30024d0ed3739..b204df4f33322 100644
>> --- a/tools/testing/selftests/net/gro.c
>> +++ b/tools/testing/selftests/net/gro.c
>> @@ -113,6 +113,9 @@ static void setup_sock_filter(int fd)
>> next_off = offsetof(struct ipv6hdr, nexthdr);
>> ipproto_off = ETH_HLEN + next_off;
>>
>> + /* Overridden later if exthdrs are used: */
>> + opt_ipproto_off = ipproto_off;
>> +
> 
> This breaks selftest compilation on 6.6, because opt_ipproto_off is not
> defined in the first place in 6.6

Let's just drop this patch for 6.6, then. Thanks for noticing and analyzing,
Ignat!


thanks,
-- 
John Hubbard
NVIDIA


> 
>> if (strcmp(testname, "ip") == 0) {
>> if (proto == PF_INET)
>> optlen = sizeof(struct ip_timestamp);
>> diff --git a/tools/testing/selftests/net/ip_local_port_range.c b/tools/testing/selftests/net/ip_local_port_range.c
>> index 75e3fdacdf735..2465ff5bb3a8e 100644
>> --- a/tools/testing/selftests/net/ip_local_port_range.c
>> +++ b/tools/testing/selftests/net/ip_local_port_range.c
>> @@ -343,7 +343,7 @@ TEST_F(ip_local_port_range, late_bind)
>> struct sockaddr_in v4;
>> struct sockaddr_in6 v6;
>> } addr;
>> - socklen_t addr_len;
>> + socklen_t addr_len = 0;
>> const int one = 1;
>> int fd, err;
>> __u32 range;
>> diff --git a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
>> index 49369c4a5f261..763402dd17742 100644
>> --- a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
>> +++ b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
>> @@ -1239,7 +1239,7 @@ int add_listener(int argc, char *argv[])
>> struct sockaddr_storage addr;
>> struct sockaddr_in6 *a6;
>> struct sockaddr_in *a4;
>> - u_int16_t family;
>> + u_int16_t family = AF_UNSPEC;
>> int enable = 1;
>> int sock;
>> int err;
>> -- 
>> 2.43.0
>>
> 
> Ignat
> 


