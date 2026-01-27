Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012038.outbound.protection.outlook.com [52.101.53.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15E9304BA3;
	Tue, 27 Jan 2026 15:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769528477; cv=fail; b=XGL6v6gVUiRmI9sKdzNgVLQZlt1YwyYtRTDzfGF+hzr3lhCTvHnULBtIciOujHOjJHhda+FttooUaIvAyAsXApT+AxCqDoDsEMobsob75jl3j99Y/sl44EITG3184nNViX7xQeL8p3GMLNWB4VIE+EYj9wLZMUWDUXHeDAt1u8E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769528477; c=relaxed/simple;
	bh=zNhAo/M+XnFtEdBVhxVUBIDXB220gLq9byn7yIcy+JM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ngltLIdSvxzamhxH/9yIc4P50ylPSu8PMFXqrlHfwKVoDskBphNVuaU3gttaAriaG/rUMXNKXGa4fVqRoQz09iHN84sDrvRcmQ21m8WywnNp2dqthllSwsB8j0ZDmKg4cI8+s0+wthxIm6kXVK1KL4BGdMjZsw+y521MPR3GVaI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ICyWevLp; arc=fail smtp.client-ip=52.101.53.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ICyWevLp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kf56BlADneVb58JEefUqEwJcd6zpYRtXKNUOKrYz7lsAvWUhMMsriEETRzrrgV44sb6QFUo4UToj5SVTROLDOtMiGwVvP84TENqktH+49zn/QkwM7pe0s3ZY1zTp8nLQaFv3sdkF8V3PdBf09RArqxFzrkwBVVZ/92+h23FV4Bmwl1FnKndF18fhFQ17g5p4MKnpBMuX+5a5IM3/1aDbjqX7MTD8kEOdbvk8mwfZ4ZKKh0EObXDQ0i1twgTET9SNn0r89B+MC57zFcdCJCDLYw+BHVfgUOkFY9Q+wSvb2qYvak3UViZtuDq0743MjHV2Jo/+gptN5BYJSswsP9vbYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=30a4q3OIKbGgA4KfQzQRlyFY45bDAnd7N/11c82QRNg=;
 b=sJwi1p387biT2ON2KGbyqA4owJd+5KIeXYo1vFifpBddPsI4dnYzz9BOgoc2hR+nsa2eA5iWeZrryuSOvg7D+sQrdhgAj2iWFepGgC4ew7APkVlZ8uypzw3wfe9UOnfxwwMQaSAqruOPoq+YyJDFuAsmGpt90VlqqeXTZdXgRDY36IV1wCDvOHsXNAFHBPnpoLkA2IeliCm6K4Uk1MJoxquREMwLJaqErSZMHqSR4EJ/DqcuRukVFqr4jJ+aUvE/u3GyUm571FVpmzKRwC3h17i3iIKubbkUPl71H5s8XaH1+1nGBqxQC25ST5QIbyqRqjV0sEvDd/RLZWbTykg8Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=30a4q3OIKbGgA4KfQzQRlyFY45bDAnd7N/11c82QRNg=;
 b=ICyWevLpf5TIsCZXatogjcgeNYJmB/tLFFbUkH0s5GTO3zOp0Zq4HiQVCRo6J/xEW4kchGTpUBgJZ5C5NRbzqSDKIqo1JXzadTojVbLZdpwP6EaeG/lnpkwPidOwGwyF2v81CIgKl/s1TSMohakrzSKmFbfUYvaJIZfu9mphxDhNTQFn2wJrPKqN8hpj8I+bXxnjCv2EIGbKUlZkcmXvxIzxdXeu1cLTuAvU6xhFaU+aT/23WLsPtrECwmBq880F3g9BMOr/1Egy4GU2Fdo7fC5yTEtaZxyxEe/BSa9ZjyYEfylncZDO7yOdZ75PryH4jdMbwGiZy3UOkoFtlIkWQg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by BN7PPFFF39339DD.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6eb) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Tue, 27 Jan
 2026 15:41:12 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9542.015; Tue, 27 Jan 2026
 15:41:11 +0000
Date: Tue, 27 Jan 2026 11:41:11 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org, jpb@kernel.org,
	praan@google.com, miko.lenczewski@arm.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2 10/10] iommu/arm-smmu-v3: Allow sharing domain across
 SMMUs
Message-ID: <20260127154111.GK1134360@nvidia.com>
References: <cover.1769044718.git.nicolinc@nvidia.com>
 <2882c7b6dcec7cf8bdc08bd4fd9f4c4373db5469.1769044718.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2882c7b6dcec7cf8bdc08bd4fd9f4c4373db5469.1769044718.git.nicolinc@nvidia.com>
X-ClientProxiedBy: MN0P222CA0023.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:531::27) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|BN7PPFFF39339DD:EE_
X-MS-Office365-Filtering-Correlation-Id: eb327689-34d8-4773-2659-08de5dba7f70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VVOGPTibCl813iaeQH1yRzK2nLQwAHfEFrLnMFrVcesE0q33+2cvzIR/6aME?=
 =?us-ascii?Q?qQca6Q3EuZCHWHcZ2kLO4tYoW8F9W6IbM02jv2ltJsew4W04TTH8jHz+K9pv?=
 =?us-ascii?Q?AKljzIF7Magf6RG04sulpweM7r9JrzOzdwIa8yKPzFx4G2jgrXeGbzDMO2z5?=
 =?us-ascii?Q?yIivdsskMjblcorHuFVt1A4tULgF6lAc+sVdb1oSWTDqWF6jgqee9pzvaZBp?=
 =?us-ascii?Q?NVJoLWFRvWp607xR93NeSKcEK5O6cyghIt6hgX+PSejvpDkdnIYbXNF4/w5V?=
 =?us-ascii?Q?glNfApHWRoi6DhCCdA2YTSjhyEuxCgtu/u7DmKEiRtVWL0ujfcxpdqSfvkCH?=
 =?us-ascii?Q?5/cN5KBNqxmzhmWp8OJK+1IBDdhJTnKIkuit4YrNbQDQPJoIFzN9Sc/mDWd+?=
 =?us-ascii?Q?a1chlo4PbfN5BiDDgYpGKH1H6tB16cOFREzd3kdWzHmj9tyuBQBp+Frsbk2W?=
 =?us-ascii?Q?HkUDYse47+fQaCrSTeL4BbvYYhZgUIvy0LUqgRaYKcC+Yr57Sjey0gKgRet2?=
 =?us-ascii?Q?MuwYNwo0LmFJw6VzKXMpWu2cYCFJ2IHA530W0RR47qLlo+Ru4FlEcE86Y0ky?=
 =?us-ascii?Q?UDW0zVKoXBqPk51YWjo5haD1yVoBvPS5KbbBQacP79CG++p3ouvLYBmMT+Id?=
 =?us-ascii?Q?cFxKON+AFH0stGoUv8iQhTH0fm6C7S5Pz1JtrW3MZjoTDqOW0IxGunQVhcRN?=
 =?us-ascii?Q?b5PRK0b8mcFKP76TbTKgZBePQue9x3/XWUXU/yRZFEE+lHnjQb/4WYExQh/R?=
 =?us-ascii?Q?EixhR+JQE/dLKExKaERmRILZfliY5VaOwkzNVGvMWX/zWcguK+HGDCeTSDIV?=
 =?us-ascii?Q?tz6DDtWnJ2ZlFeAFWZqK5f3A9dzrNmlAa2sfO4AlCQqkvgmK7gX5M1kg0Oix?=
 =?us-ascii?Q?CpEug6RrUeEgT3TnArx6lNXJ14Z3GwCS/3i/pgTC+7dsKIrGqn8igENBXUD5?=
 =?us-ascii?Q?4RQsIUXVrfBnZZxDkB9wQIcSQia3cFulqUJd05kQyH8X7/MPeIIiovVofdFL?=
 =?us-ascii?Q?0zGrG2YR2EnCkpk4KMZyh8gFWU0NybMbolvLVvfODaxOX5QC9cRdHoiPT5CG?=
 =?us-ascii?Q?K4rj1jzILe28Y89111oY8cMVw5P1/CXHSxHWPLW+1JXo5HZQPK3E9HLzlxG2?=
 =?us-ascii?Q?RqZXmxKQII42jJMGTvWm9Yhh9sb9G8gEMj+dPyjPqMr1pTqnPPt0lfE0+sg/?=
 =?us-ascii?Q?eVT+Ackh07JJaOpthUikJq4YsAPk7rhTLGHBxPqXAkygMu/oCp9kKnFUTD1F?=
 =?us-ascii?Q?qg0yqja1MDD8k+bgS3mXCqHGHD12JoN0fVVRJ3OrzVxLPVAWO1CKg7KPo4yw?=
 =?us-ascii?Q?1d6cxHSxtp9yR5j/6lig6SjJqohmm/a5sKNLiaXjRlPT/H14Ki/J4C5IY06H?=
 =?us-ascii?Q?HRLMVMqV7vwto5ouKRe5erBWmq10oTzOYfbedmZZl1SmcWMtubFPANUNLRnE?=
 =?us-ascii?Q?N0YNaZSi4TTTjXWdbG3MDzZBA9Jfr10sVYkbiQoYI4jiZEzOkyz2hFkJH8Yw?=
 =?us-ascii?Q?out5OBqsgtcFfmuAKKXz1I8urY8p5C1LuDrRSBaVlJwsnbL7K7X4uM8bC/fC?=
 =?us-ascii?Q?gelGhL04Gja/kvH+cYY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WffeAbpPyxtRjEn0FfAOlf/WLdy7BB4mTt+4x5P6MPVPNCu7tH+dSH4Tcdjs?=
 =?us-ascii?Q?BZQpsrvBza7YJwN+jtylO07doYypdgVAoZC7s+PvOter8/kcEQTPLC54OWMP?=
 =?us-ascii?Q?kTk5qBdbxbTgUuv0NNUKqglkPbO2iPJYWDiY+VTuZ4Mmjou7+Or4Pb0wF8eo?=
 =?us-ascii?Q?hnFCHbkYZhg3gg5U2ZghLn/56mrnIR/QqaMIYrlLxR9eu3F66JOzMyvj0ja+?=
 =?us-ascii?Q?7sJhOcxe8JzYvWmVg62COHeB57VvnQgW8zl5H+U3kqPc4eoiyzdnBAKT8C/A?=
 =?us-ascii?Q?looC4zfb9sCTHRMLRrRUrTIt/7UP1sCMAdjORw80yuPddKmpGJ1ktzmC1UyO?=
 =?us-ascii?Q?+jnQmvva/ZFvYCX883wLCz4iVpO1u1WGJvgy5lbuZ/o8Bl8eQo+kePmpgBQF?=
 =?us-ascii?Q?G2qlooPpphwwA/YKxXU7S/Bc3QT5kygC4NkaGMGCmWbvxvuGVe8wY6H+mob8?=
 =?us-ascii?Q?jawM6rKLKQY1jDYav/axe77EGgkvp+b1J9MHsJIwcNaU6+LjEw9Mrdk0Qn6u?=
 =?us-ascii?Q?XmWqDUpGu2Nvj6NU2qoCwKq2xUUSMUggifYhfpFDrCXXcQqeL085DIcNSXEg?=
 =?us-ascii?Q?4FI9kH+k2cdqDHbxRZ9oJlacL0aEa/f5AW97j1hllrzW/25Wv/rYwxbRy8oY?=
 =?us-ascii?Q?iKM0ak25ekgEeoWu9BcSxwmykDwA8Pl8UiZaebYu3fySqXD2O+uB4DZW8434?=
 =?us-ascii?Q?T4Azcer0VcsgRrrVNMgIgTILMpK9ZM/DUdk8BDaHEahJkjbD8yegyWv6+ooe?=
 =?us-ascii?Q?8MBZ7TcNlVF9R58yREv4RRyGuVVmKBug3Igc9nhMU7JDtVw+ZUnZYOhQyfap?=
 =?us-ascii?Q?YWcnI0WFIbXzPEqftUc+pbk8L2Wu8T5HOAspStxo9jX7hmLVmYA/VoB9m/LY?=
 =?us-ascii?Q?d/QsheznBk3hF7mVyjJVUQjmepNundR/qoE9Q5+CWFclaHYVrvIzInr8ahFV?=
 =?us-ascii?Q?3akCkRGgkXM6ri0lZMnuLKMaK7eAfTtASV21NW9DiwIWLrX3tqMhS+VCBr5q?=
 =?us-ascii?Q?JkkYVbDGQxiqquPpi6IMP1YBYJ+2HXN0+01c0vDidS/AKMox4GpW779lAiA/?=
 =?us-ascii?Q?iaBMedQn4303azEhz2+t6UZsAcPZbmiicgJ7gphzV5FZy7o+PyCsBEfGc8OA?=
 =?us-ascii?Q?Cd6pNN4ZDCw3pN6WYCERB+Jd5bSUE7+DX/25rNMB5IDV1W2VBSglPBLQDGvl?=
 =?us-ascii?Q?PvNc367o2dcXurP3gx+WQ6vEbpz5RzQ5jkOrCSHxjbOf6VDedhW5e45h2gHU?=
 =?us-ascii?Q?/niivkuOqH7mG+knhJdwNbcBgi1R0u5+GD+Ve2UmxoETyf+pn2f/tum+Rax9?=
 =?us-ascii?Q?Sqx0ESkLLYFcxZQmNgsespTdriHnmpZPe5FckDV/6i9FFTsiW8+k10OkpqYe?=
 =?us-ascii?Q?1l7YkUnJZicHNfM1TWEuJq9E6BoTpUQHAidQN6etGU6uAbs+jmfd8GiGN99B?=
 =?us-ascii?Q?yO0NiOgndUN0FYw4349IIO+MIeGDehcCg2MVzzJzpuaaCg89DO1iNu4Sd4D7?=
 =?us-ascii?Q?WLogzBqdG3dwrmN2c6RzvLaj7BWgXmyk0RIgiiv+J68vVKFUv/Pfo0jXSDfG?=
 =?us-ascii?Q?Hjs786+JXdrmr7H0EwFrQStUSbAnJw7S6NtXYGRdl0lc8gaaAQlo9S1K7ijV?=
 =?us-ascii?Q?LsYR6dpypLWk9aigO2VgwywlXyjedlp+rfA+F30R0gx2i04DtS3mK+dAwSQf?=
 =?us-ascii?Q?cyc9r9ZE+Kahj/qg1AMhqD3og56PE0QNTKj1NccrFG7Goer2PNJPfHfg41fT?=
 =?us-ascii?Q?Hhhf4ZO8UQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb327689-34d8-4773-2659-08de5dba7f70
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 15:41:11.8266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2jNBEEhUHHM+/N31ykDuPPW5EAvU9+5QlTvtLhN/obkScv/J0LX1/ok9l3MQKmXu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPFFF39339DD

On Wed, Jan 21, 2026 at 05:24:28PM -0800, Nicolin Chen wrote:
> VMM needs a domain holding the mappings between gPA to hPA. It can be an S1
> domain or an S2 nesting parent domain, depending on whether the VM is built
> with a vSMMU or not.
> 
> Given that the IOAS for this gPA mapping is the same across SMMU instances,
> this domain can be shared across devices even if they sit behind different
> SMMUs, so long as the underlying page table is compatible between the SMMU
> instances.
> 
> There is no direct information about the page table from the master device,
> but a comparison can be done between the physical SMMU that the domain was
> allocated for and the physical SMMU that the device is behind.

I would very much prefer this works by inspecting the cfg from the
iopgtable..

You can get it by doing 

	struct io_pgtable_cfg *pgtbl_cfg =
		&io_pgtable_ops_to_pgtable(domain->pgtbl_ops)->cfg;

I think it is important that the domain->smmu pointer be removed as
well

Jason
