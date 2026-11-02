Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793641047;
	b=ZP2Nl0s4waaGrd6zPguQhhCUlVoFIckPKW22os4Z2ly5Q5z4OvxDjvM9AaeOvns2QqZQ
	 L76RbY/q8gPOIsQdUooc7W+CTepKu62P01KwERnx9C7xYCTi0pK3d+b9lkp/VB+ElMfDU
	 tACBcEeP4Ixg9JlXgOzG6Gyiu34lOVTT4t6pEVdm/v6r6IJmuqsYixw1HWfc24tr3r0sj
	 SuTIDbWoNIkKpbnfYSbTYHaM3W2ddpX0RDhVb4ViiPXjTIUgasKR8kj1fi0jWP+vvx2y+
	 fi7Z3JtcupRpAQJP/tswu+ac41c0bDg7ExsYn8ZGr5z6bXErtcJEw4eSt9TmXT2W8tg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793641047;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=8Z4WwNSciZiMuAQuf682HWz1BX8xEt3jFp/bgJtueAE=;
	b=QuJR6XxLpKJgS78+M3CE7Fb3gvMRgBYU2u3OwgBZTbWx+QC+YFYGRujmeU7RVSzB77NR
	 hvdc6tstgma7p/rWh5xvnwXheqSbEHB5QweF3kXvhrn3MqCxXmrD6auL6zxJSlIo/ZBSW
	 eeEXItHpTBOH+VNGmnMH6wGRQVLU+qQv1Az7y1gFMQ31MCIaPSmfk9rIlLABrSmy6cqH5
	 9FXomJ/8vshyFKxekfgGFTHIu4b49YSgJJecouup/SV+4BFxm1csvgRtRNeR55xwWZm5h
	 J0LgBLLW7GDrw+3BJs2uZl/dWlcc8I+xCdmI4FCywoJMzpOLRkIsACc/qV4JskghtZQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aCHwjdeo;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.43
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012043.outbound.protection.outlook.com [40.93.195.43])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706D6606AB85;
	Mon,  2 Nov 2026 17:37:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 706D6606AB85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aCHwjdeo
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W/5mJT18tac5/dp6M16woPpWxhS0WLdmgk3G3NMWkKQCEXWHh/J4ems1Ruo9glO0ohMK42lLObaTJwO1pXtF4aq4VvH419cwqlPTJuNXU0ThEJy9BqKE/uggmvp3bGyRSZnyXchfbPUK7QB8WKky9krjHWGknB2w0gyyjZ1QbJ2iMIlUPlnxHIEE0omgCm18LxZHd3M9u1hcMQsxN3uXPTMFXfG5WYyFMYpDEIu9vcgX+QaN/apzwM5BQonK9MkhnWmUJ0tdOhYeeVUEIiNrste6uYCMW5CqUTNDgcDjv/uMhwr7yNtu0WhYThtDrZk8qazyLoB5TjaStk9fx1X9Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Z4WwNSciZiMuAQuf682HWz1BX8xEt3jFp/bgJtueAE=;
 b=I3pGRxTTlD+POU/SfiadIc0A5oKCDclmeYyfloee8s0ULNU4b7dXw+PwPzSLQGOMDxHTrls9tJguI0qRJStWJ4dM3DQhFxuy/Ts1YSI9F3hPKJMLsgqN2A+ahKRoVBlljWP0YEPl94E1zN4IDUMF+SRzDBp8enptNckLsO1FSsdWFh8Ns8OiL8s/nF7/5yGo76630Rr9eIMQJWwKXC/t6Is+ZLQov62nTmvGp1COqoTDyEDVwBHZcs5MF68lBQPQ7qFsNnIVOcGEErl5EbshvldvZn54JVtsWGyhx9gP879kQMWX/E9VF3JHEceDjEwvp/aBjgHmlkoVMGKdvQAJFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Z4WwNSciZiMuAQuf682HWz1BX8xEt3jFp/bgJtueAE=;
 b=aCHwjdeoTKKTmTNNn3oe3uzciC2mzjUAkszrbPHngUtvtxj1UZm/SyWNd5Zbz7fizt5LWY5VxODgCw0jyw8l6ieg/M3aJbwajlOBYIFAoWt3wKVsK68/smdNwxRJwWC3VjyHk7pJNsDEO10sInA52tRGbZ6zYM2Aq0f68coCxCgu9EQvNNH8vt0pw1QvT8eakPvKxPUtnmVHhLmTngkJ+4/ByJdNueS1eaLrKqAYNyhx9mYkE0YEvZ+G/zJIjS8Lwff9JhpbWDdsO9VUvCsuj7SXNdyg2PewclgsTm4Q774GdsEexdWngsu/7k7+QspQahUyCA4gsA5OoUpV1bynvg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LV8PR12MB9271.namprd12.prod.outlook.com
 (2603:10b6:408:1ff::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 17:37:21 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 17:37:21 +0000
Date: Mon, 2 Nov 2026 13:37:20 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "Jiang, Dave" <dave.jiang@intel.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	Jiri Pirko <jiri@resnulli.us>, "Tian, Kevin" <kevin.tian@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Message-ID: <20261102173720.GC274202@nvidia.com>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-11-aneesh.kumar@kernel.org>
 <26c24a66-be3d-40ac-8cb4-294deb0108db@intel.com>
 <20261029171053.GD3734323@nvidia.com>
 <DS4PPFA84FA90FC768B30DCFEBDE71F31CFE76D2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261030131543.GH3734323@nvidia.com>
 <DS4PPFA84FA90FCBFA0773CA4564A0DB095E76A2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS4PPFA84FA90FCBFA0773CA4564A0DB095E76A2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
X-ClientProxiedBy: CH2PR19CA0022.namprd19.prod.outlook.com
 (2603:10b6:610:4d::32) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|LV8PR12MB9271:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f5e2098-9fb6-4124-9f48-08df3907f2f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|10067099003|22082099003|18002099003|56012099006|4143699003|261026121527099003|11063799006|261022105027099003|261022075727099003|261028144727099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	tA6dccZMjddatFIsmGCPFKEGtjtr1ks5/WkUiFRtbUe0wf/eHhryYdb7NE3h2maweZxT8IecVEyaQZ6wZkYv/LFln7Mpt35VRLtq/A79wa+n6jlgvZzrganA3vbYsbucoociI0NhvxfVMllVW3g1/ckhUfg2uwHjXNyg/7+L2BI4QkLLeikXGv3QHg9Rf/oeyit9DMbOB7VOf0sD1Cj5cW4u8zTHruZaXNyIu4e5qCWJD2keb577AGsCuMP3tT36xo2tN67UimoDyby+UuUxAagqU40E9iMelH5Oj8jhfE8od/ag5yCIxLNdmFsonoLNMSY3WkkYji2N0mAl4icH5RuhzF6KBT12ga/hjlI+mr25PjVjDDTlb50P4KIxyMmmYHWt7BJKZvoFJyqnC9+d/ki7hhU9QhqZ/tvycmpGvbjYl1GUQgJqY6yuMOY7K2bzthcjKbgddl5fSUt7dlu0VyfNV7bsgOdYLAIdlm2UJISd3Seuofd3AvUaNbvqw7IxyH6lH6XvVCQMG3NZbuafL8wMKOLk3/arUDJmAoGLgMTEsW60U9UCOOSfJi+CkJIC1bBu90p6iMYJEawTG0ZONNjngfkQZoof0tQ5Dds85Lqd4V3OfXwKGB+yKGzg/dACIRcx5DDfNBo5pzSgoyuHlfgwXjU8Uw1stmzDZbgTwug=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(10067099003)(22082099003)(18002099003)(56012099006)(4143699003)(261026121527099003)(11063799006)(261022105027099003)(261022075727099003)(261028144727099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pq1X5wBnqFw93BUt1C0Wq0FGxLiCpwa5sE/vxjZJZESKsZxNN6JNT3d1a7SO?=
 =?us-ascii?Q?7Om0+aSE3QclPLL30a7iqJnvvozP9XmTRYtDbQeU81Y7pCKaPmmdDlWcrUGx?=
 =?us-ascii?Q?iylfM70kZwZxPD4yX8dCdhdkcd+JkBqtKzKOET9yblRGAl2XuvT+z/Sd48MA?=
 =?us-ascii?Q?+7Lx00TVJ0jqwTaZsUwrWuXqkDX02V/KQj8Y3HUqK3LvseaQ6W5Ax/X8GtAa?=
 =?us-ascii?Q?tMOz+R1gYBQ6N5oK1lv9dszOvO11+NVhTkDvt7w7+vMsOuLNdOZttqFWq9MO?=
 =?us-ascii?Q?Zaj3IgNxlKk1GT+u0U2AIgmdALUCXkrDCkvbst3Wm6v2xhShyXLvkybizquY?=
 =?us-ascii?Q?Nmrkdp4rSSUoXsTmjQUnClzoLdlWQHjBlQatTt7bXV7c+bmXuBCs3L4RNB93?=
 =?us-ascii?Q?lNUvUDNefhIn+98QZtRRQRWRkMZ1LQHdRRE5Kj6//Z4NhFpJbHaxfr8MCo5O?=
 =?us-ascii?Q?CdbZW2fVsx2QBMCCPoGCnVknB/QMlW30xKzzGbt8TI/XIziInVd5zKtAtKp1?=
 =?us-ascii?Q?rs8mAOSMMe6qLAT2px9gMrSOZ7fsmfAwuSg8hWeFdZMFGM+/YhV0u6UVeqs0?=
 =?us-ascii?Q?yAQ9x8Iw6KcAewoFWMGJi0T0kywLIbvAlldHcSGRq2pvPmqDD81xQDzPgEIQ?=
 =?us-ascii?Q?uGkQ0i06x3egWNglGkms5MVgQzwQLFKDkJss6OtDr15Ge5MJzSmvurXdteiB?=
 =?us-ascii?Q?1RdvkKz3j9KvwVa+06V1xvfHNeeYhm8KeJun5aDKag+GsimwwsMUmItJFnQ3?=
 =?us-ascii?Q?XIhJqTlwKAJQGfF2S0dpUEOAw+YdCK3nBEN9dEjhmc8sFJ4hrdkrQ+jyeYWK?=
 =?us-ascii?Q?uMXN4FE+MTnQomECG5aWqg0M9+d50hDY4AtpyvHG8Okcs/+5gt5wXPLAdcvD?=
 =?us-ascii?Q?2Je1/6IZqOwZC/qz61EcuLrI4dTxpcBydu9gFpUW9hupnQ6c3nKUkyzpS0cq?=
 =?us-ascii?Q?KXe/4ZIAzYsmLKQ0uyoimLfbt0WBE/8/e5ab2kLeneFii/QlYf2TtQ+rWSvN?=
 =?us-ascii?Q?flSLiggHEyOsaa10Kh3TZlKfyfJBicdYCVRpcE1gM95PTduu+eAY4jG7F1hW?=
 =?us-ascii?Q?XFPhyzxZgC+N5/Q+Ny5JJhBd4NnQCa4qy/WJqodxh3Z7EYj1nJRSjS9ZnkFS?=
 =?us-ascii?Q?ca4ryQTdDIHPnKvPP3Lkh2Mjd4k5fKJtdjY25iYZXyYeyCWNl5Nn92jbAbo9?=
 =?us-ascii?Q?2c6G72fJmMnwJQteDbskXNmwJHt2dQCg4Z+XtFljE8Bw6qxKG64b+9oKgJcx?=
 =?us-ascii?Q?QbLWWa+i/P+lkqu62QJvSYJeAGTRJnlWDGmlBSXk0emEUIyXPoN19/Z7Gcxc?=
 =?us-ascii?Q?J27lQgF7wm+3a9gz7AmdQozKza/wiP28j3PK0PwpeZcZ7EOdx1lH+SbMFK5P?=
 =?us-ascii?Q?Fgo37bljFbUQBH1S6OOp4SjGDic098n/y97mBi4FLE3ZrWHcXhGwtSNkT+83?=
 =?us-ascii?Q?3DyiNKV0SWQKBkE0c9tHxqX6e56UBUeopzMgDeZFeIY1+6bZjWH967VY6Zza?=
 =?us-ascii?Q?FbNiT7IvIr8imE+7ELieQAXa5BEGak3lE1nrJWBaEG/24JLLgqya3I9CmcUD?=
 =?us-ascii?Q?Pa/vZj5J/Ubtdr556x9KRt7uAnug8XX8xbBGVObdmS0JGHw1/0iL4vrBy9S0?=
 =?us-ascii?Q?A5iABrmYcNohBiRC4GaYvfpRpekbFHqoiuQTWm6WZsyeVZEbZxCZJwxEhxe2?=
 =?us-ascii?Q?PeGGtD33asWjaZ+sN4i7wEgJ4Wl1AlbH0OhzB2mVA1gyYlBH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f5e2098-9fb6-4124-9f48-08df3907f2f9
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 17:37:21.4852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8xiYvjERaCc8ZRQDdbZeTGH9BgFbeHqvUeANZwkZWhAoveKCi8JGHr5vDEwvyxfn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9271

On Mon, Nov 02, 2026 at 10:22:16AM +0000, Reshetova, Elena wrote:

> We can also simplify this further by not using GET_DIEGESTS but
> assuming TSM can return the cert chain for selected slot back to
> kernel/userspace in a trusted way. TDX does it by returning
> the cert chain (actually for all slots if asked, but it is redundant here)
> on successful SPDM.CONNECT and there is a trusted TDX Module
> provided digest covering this info.  
> 
> So, option 1 becomes like:
> 
> 1) With 1.4 match GET_DIGESTS and MULTI_KEY_CONN_RSP=true
>     1) Do via RustSPDM:
>          GET_CERTIFICATE / CERTIFICATE
>    2) Userspace selects slots
>    2a) Calculate a digest for the selected slot
>     3) TSM module does startup 
>   4) Extract cert chain (or only its digest) from info provided by TSM.
> Verify  that the digest from #2a match the digest calculated based on trusted info provided by TSM. 

See my larger email, I don't think this is how SPDM is intended to be
used, you should have a GET_DIGESTS that is covered by a signature and
included in a transcript..

I see only three options:
1) Use a single slot, so KEY_EXCHANGE includes a hash of the single
   slot cert chain
2) Use GET_DIGESTS/CHALLENGE on 1.2 followed by KEY_EXCHANGE.
   Maybe use the same nonce for both signatures so it can't be stale.
3) Use the new multi-key flow on 1.3 which already includes
   GET_DIGESTS in the transcript hashed by KEY_EXCHANGE

These all achieve the same end goal as what the 1.3 spec did, you end
up with a transcript signed by KEY_EXCHANGE that identifies all the
legal certificates.

IMHO there is no reason to deviate from this, so the uAPI should be
designed around it.

Thus I don't think TDX should fake this with a second GET_CERTIFICATES
pass inside the established session and try to skip the signed
digests..

Jason
