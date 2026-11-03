Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.5
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793720755;
	b=kQ6J4iSwlTD64zDOa7qbFnOCQU77wlydobm4C8CjpHMSLY1ApqWfXEBqEK1cJodCkbON
	 Y7lMk+ejKrY0cF2JNiWcIGGFZpQkPnmqIH5Y2Zf3X1x/asf65f1bUx51n836kRCftFCBQ
	 ysCVqhBaK2SUDogKFSe7oQPvWbaIG+ZvnZ7g/L+1hlurEPVwEP0jm7qTpjZfLScLQ9BNw
	 LbWdkQPaXTxxk7mcSV/BCliZTUJc9GU0ydt5zzl7QI7l6VdMn09GROvEylUiXT3HdMHP7
	 y7w9YkhgVq3+ga9RExxnavSDGE/PltLsONbpwbXbpJPn3om11vTIO8O2nAjA7mAJqaA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793720755;
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
	bh=tANjrDUNEIqHRLnV7BbHDs3YEIZYKdpWIoqGdk8xfRA=;
	b=wEAaRgsRhvxXbRZ68+KaXfFshsJDyfHub7A7yrtjG+pnhBlZUifMB1/KZzYHjBc9Q11I
	 piZEVLk2maqiQTxisGqV5I35n5Dc3alDOIkIJmB2X7B3QuQlSxP4HOvwX5UJ6lxsUhhse
	 0unyKSk6w+SCMt8SfwGLxrI1IewcfhjvIR0hCKHU2UelUXzUzOu2tr1YusktULWVhBegO
	 ALpgRTwT/K1KjO7lJ6DzmbyngmuaGfP2niQAho2sI8XdIHkNtTY5OywzFSP1PozhvGSIk
	 v7+5iX7HwuW1OICDEPcjs/2zEclNocBwvX/8dWCc4204nKMoPNBY/Rz9ZZjSC0gTVtA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=DeyqJdOy;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.5
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011005.outbound.protection.outlook.com [52.101.52.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D8A606A326;
	Tue,  3 Nov 2026 15:45:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6D8A606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=DeyqJdOy
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KLZ5GaeVrmnKEve+OWP4YJdGyUuFjfDViHYTGjx4zXZu7Ag0CFATcSAhwOcHgTClC09luDDecRMD5/PaBlhAYgmgrVMNU33v6uT4oho309o9HKUw3v1YhKnoBthzRlkBBLWzeqWSpu4afQJw9ttloVvwg+Q64I9Ecr0jY+S8pnXFyzc7Xy9Ga5z7pikkyhO1i76HLsjdN/6AleoFgcuY63vj6gIBWbUF/wxWvKtCJY0AetUlKpqGrwV9zxgRdRNL9klZExtAKNtjkb6YDWW325julJrUgacDzqz62+09P3Bt9LXFArYj4Fme8HmxMFZ9YQJRd4WI13WDtY5oFFW7rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tANjrDUNEIqHRLnV7BbHDs3YEIZYKdpWIoqGdk8xfRA=;
 b=SmK3d6XKa83VldxXFIzE4f0fcAZdK/FLKcNCqgKdaofQ92M31wepgBp28DYAP9Dvj3dO67Hl/GLCC08RFVosooJT9LXxaNeMbB+Qlm6ZAmpznvrR1J0a59olODp99eWsfZi98zUH9UNtH5GUw318mUOBKiWpIcJZeu9JEaGEacJ8IpF88132HwHGCXeRYyoyoxMnHGNKxWUsf5R+j7JQcJkEOyODXZaN8k57Fju6UGP+dK5rXSHgFy5SieXgc6Rz9fW6jaHZy8Aq1ZKQUEjSHsIYml/pCgidYfo2Hs9sbjI4LlCLSkKPHvDpSCvEfAZAESI7GbuGwf+dRJh6Qtxvtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tANjrDUNEIqHRLnV7BbHDs3YEIZYKdpWIoqGdk8xfRA=;
 b=DeyqJdOyA41jrFXP5Va9DPHWxG/JUdpdoCj4mnhR4EXyQn2w1iktPzHQZvJPmMn8FyEJn8X/pSA4hFk2PUhITM0Y+JFYOr/IbGZhoIqCQDg3QGYJztJs7iRfhhaYyEzf0fsTGdHUmM037Ut3aRk9x10fnLlGfZDGaBCyDlGhNPC46GrVtZEn4dIi6vXWsjGagmOwji0vPHPjxO4D6Qh6Vcx0w7YQYiUTpYW4J/h65izFQY0pmki9LJsolhAOnagrWSqsIvGHn1GT2/n0Ol6KzkufFFDGD51XdomgxAsFKEe7NDjrLJIQ8vQAsxFAYjZz95t5xuR/7ohlBdaa9t7ogA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CH3PR12MB8353.namprd12.prod.outlook.com
 (2603:10b6:610:12c::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 15:45:40 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 15:45:40 +0000
Date: Tue, 3 Nov 2026 11:45:39 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, patches@lists.linux.dev,
	Dan Williams <djbw@kernel.org>
Subject: Re: [RFC PATCH v1 06/11] PCI/TSM: Describe the PCI attestation
 control family
Message-ID: <20261103154539.GM274202@nvidia.com>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-7-aneesh.kumar@kernel.org>
 <auShvL2m00S70H3d@FV6GYCPJ69>
 <20261030154353.GN3734323@nvidia.com>
 <auh_GGpJ0ngQTETS@FV6GYCPJ69>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auh_GGpJ0ngQTETS@FV6GYCPJ69>
X-ClientProxiedBy: YT4PR01CA0303.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10e::26) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CH3PR12MB8353:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a1cb667-ab67-4ab0-d992-08df39c18304
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|7416014|1800799024|6133799003|10067099003|18002099003|22082099003|56012099006|4143699003|5023799004|11063799006|261021121427099003|261022075727099003|261102123227099003|261022105027099003|261026140227099003|261026121527099003|261028144727099003|261021135927099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	exvktsduIXbFlVI29m4i3TYjj6MNkXO2J0HlecukfZj0WiG/gXo9SyEdr1DZj9kuKpGIrkqsRtVMmiZolF3VTGvHog9pc9ScFAgxvg0nY3KzfDeUL2fKF2Nmno8VO/tLOO9ELZ96d4c5UcMgGqjX4lVCRQSonFZsdHYktBnEFoq+uOREkspPjE2IGolr9ifPFsvT9BtelALHnhkiwua0DJMzhqpQhLP3vDHxLSCgINDIz4giMXf7dfR6xHg1gHHXnieM0Q8AO405hyIgRQ3B5fGWWyFc7GVX5SnLefJ4evgqiIeTMdtLdwg2m7IGPn5blQuof131lQAiqpjVYBVBFaTp8MXfBniKSRwGtX1Bx/xALxuQ52N3YU1JZaEmRmg36LfSW1s5Pw3au03uxYjHODEvtnyPchBofqe0nJZANLxii727q3o6UjhSZav0OqT4KHxmXbYlLPr1OqVQKbRHohP91UIl+RJEnVGJ1auVb/EcSuxx+OmFOEzMhd0ZDrg6fFnrX8dozYwonnBPvtrQUVjiJpNIP4JqQin0Gzaw6HoOr5HfmqkPINrsUEL+62zbJ0llB/DxUg2UMkkDs55a+uhKpgmSmS4hsFQNtdNMiKs996idu6u6pFoq+eumel4fgj5sWO437XE55pQ0IQRGFoYPCSYmQMqruf4UzZF3fmQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(7416014)(1800799024)(6133799003)(10067099003)(18002099003)(22082099003)(56012099006)(4143699003)(5023799004)(11063799006)(261021121427099003)(261022075727099003)(261102123227099003)(261022105027099003)(261026140227099003)(261026121527099003)(261028144727099003)(261021135927099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hK+m/nP0Op7qNLwM5I9HXLbEcBORIwgdmz/oueELtWbSmZ84XkH3pBONOzwT?=
 =?us-ascii?Q?EBU+irQvhELV2EsKrgx6ThRPVnf7llgT6qpVF3ocMdXhYZ3IK73b9x0iRF0d?=
 =?us-ascii?Q?0dvkyB+qH9FGWd/7Uwh6BXgvrwfA8F9xzL/m/J77T2qsnGPaRXZEFwyd4wHZ?=
 =?us-ascii?Q?ihNiKFpk7+S3j6LISrL6wK49DZofL+9oXimlf08ycXbeqyp++3lxqPAmozGD?=
 =?us-ascii?Q?xwA89VXSll2KBy88gSmrUKewzkHWJLw/EhrF2glVQSjCTbAkkLexEYrWovk8?=
 =?us-ascii?Q?I4Aukk7gm+aiM+lrSYgFznHutA+jmBnQXPyKdru+HzgTBz5dw5XMatxkLHHw?=
 =?us-ascii?Q?wUyhcSnPHBS5Fl6kfURt/s5uWFUYydb7FhEu+gRwebOLJ7MsI7HLRpb7IUAm?=
 =?us-ascii?Q?E6rbCnYsZSKEIo6BlZC685uAejBf1J6ozEGz+YHF7GNFSbMF2LlXh9oQqZ6L?=
 =?us-ascii?Q?EqtoTXTbtRVwTC0gpMVcqvvuLUipSwZ7mfNeLbq7sJouCZLoJrDP93rPIO/I?=
 =?us-ascii?Q?U0aqVsxv6AEmzjBctfE10NqpsT8sy64cyUkp6qBAUpZqzWHXF/5tb2plsbX1?=
 =?us-ascii?Q?h6/Ap5YkphpJ3ssFqH6m/mP9k3I46Pkxx8ptNLEnQx+j+D6kSLfljiTkfPy7?=
 =?us-ascii?Q?2huqSfpyGEyqq6FuMbtuFenCGr65Rd5oEJW5JQYvg7FNbegp6WPvN2dkSNaL?=
 =?us-ascii?Q?DAPpWxLINBbMs0CiinV6XTkHl/UvY4je90Icko7zxwgK6IZmvLJSLC9UOauY?=
 =?us-ascii?Q?GMU1vW1OGPnzgFD10ms//hLAsWQJh9YyhPMlC/vMMiJ7wtcHhq7ggSd5AO4f?=
 =?us-ascii?Q?soznedXpqZg8WSJdOmslCMr6oZ/0Mx7yJKDvd2RVrCT6Rj6COFZZP7SoXt21?=
 =?us-ascii?Q?2deGWN+J44+dglwRgWCfQUj1sviUt6VHILwWhJOUcqR81wa2B1yB3hMAfC2m?=
 =?us-ascii?Q?Yf7Ac544aG5wZADVOjWcrUZN2pBLzJ+2pbuzpl3SpzNgyhq7UL2iXiOE1v+r?=
 =?us-ascii?Q?NsrK3DLIpuFRRxQaqItJHGh2odtlVd6KJlcc3oj8UulRVnYNHhZ8+f8zHnkz?=
 =?us-ascii?Q?UrZrEtlTiOwGyPQp/dI5rkAL3621nBq0qXWJNE0UvO1mFDQJvLCBjLXRXcg0?=
 =?us-ascii?Q?BRl6wVuBRvTm5HEL+KKCMaFdjRbX3U9YFRalc3dlPwKXy1KAMj7BVTFHAPra?=
 =?us-ascii?Q?uhvUGvZvXAU1SCsbO9sA15rAzcL3bsOTCtwLccV7oMirnuFXyWdWTJ6oIl5e?=
 =?us-ascii?Q?3ogeqo+i+PTWjdlbi0CxcYLclHZ6Fs006GlZ2Gz8njtSjd2Vv3Pum1q9SvzN?=
 =?us-ascii?Q?NSJ6tLVIvaq8Zt2P9j2r8RqK5h6ytBTTsZrq2IWi36BJnH5NATqmwEldEWB6?=
 =?us-ascii?Q?Kg53YUg8EIpzoo+Fs5CSc8etPTiOCwtZUIa0/udyk1j6KbeiKKx0iOpeTd70?=
 =?us-ascii?Q?T+4W7lwyU4kWVDT3jHGQiFAyMcua03cjgyJomdXJG/PAzmvIYZbUBMG2wMh8?=
 =?us-ascii?Q?x0P+0RBC/RLa/0o2Ji4N3wHg10u/bR1DnwZnXuEnKRkIbncFyV/pTk/T3i8D?=
 =?us-ascii?Q?6MX5dUYYKJkw2cjhqOPKSQ5tsQZVKhUHRoe/JoRWRzlYOTNmh8ria8S7PmfC?=
 =?us-ascii?Q?abmMq8z5PSfp38KKKbynYOhy5hhC+ZNWCSoN5er8SUOG92K2M9j2M06GznBC?=
 =?us-ascii?Q?zxPu39LzqQw+zwczqX1jT+SBCaxbomdc5naR0xhBQXicC9tW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a1cb667-ab67-4ab0-d992-08df39c18304
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 15:45:40.0528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ws7TKanQ5dwq6q/TFOR7Q0FzIxqD3ehrtUBX2KheFmKq18J1iryCejj0eqGC7VuJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8353

On Mon, Nov 02, 2026 at 01:45:19PM +0100, Jiri Pirko wrote:
> Fri, Oct 30, 2026 at 04:43:53PM +0100, jgg@nvidia.com wrote:
> >On Fri, Oct 30, 2026 at 03:01:29PM +0100, Jiri Pirko wrote:
> >> Wed, Oct 28, 2026 at 04:26:13PM +0100, aneesh.kumar@kernel.org wrote:
> >> >+    type: action
> >> >+    fd-access: read-write
> >> >+    availability: dynamic
> >> >+    optional: true
> >> >+    request:
> >> >+      attrs: refresh-request
> >> >+    reply:
> >> >+      attrs: change-reply
> >> 
> >> This differs from what I had in mind: a transport-neutral
> >> ctlv-attestation-spdm family with SPDM_GET and SPDM_AUTHENTICATE.
> >
> >Yes, we should try very hard to keep all the SPDM stuff as transport
> >neutral as possible.
> >
> >> SPDM_GET would report discovery BaseHash, discovered slots and their
> >> certificate digests, authentication state, and the effective
> >> authentication slot. SPDM_AUTHENTICATE would take device-generation and
> >> the selected slot. EVIDENCE_GET would retrieve CERT_CHAIN with
> >> blob-instance=slot without selecting the authentication slot.
> >
> >Do you have a mapping to ARM RMM operations already you can share with
> >Aneesh?
> 
> Yes. For SPDM-capable PCIe endpoints, this is the mapping I figured out
> with LLM, using the existing RMM 2.0-bet3 interface:

Lets talk about this in this thread:

https://lore.kernel.org/all/20261103151643.GI274202@nvidia.com/

> sysfs connect (PCI/TSM and kernel SPDM requester):
>   Perform preliminary negotiation and GET_DIGESTS/GET_CERTIFICATE.
>   Retain the discovery snapshot and destroy the temporary requester.
>   Do not create the endpoint PDEV yet.

If we want to do what I called option a, with user space repeat, then
we need a CTLV command to start the flow, not sysfs.

I have been thinking sysfs should only create the attestation end
point and not do any RMM operations
 
> SPDM_GET (attestation provider):
>   Return the retained discovery information and connection state.
>   There is no corresponding RMI discovery command.

> EVIDENCE_GET(CERT_CHAIN, blob-instance=N):
>   Return the retained DER certificate chain for slot N.

I think these two are my #2
 
> SPDM_AUTHENTICATE(device-generation, slot):
>   Validate the generation and selected slot.
>   RMI_PDEV_CREATE(id_index=slot)

Maybe PDEV_CREATE is in my #1?

>   RMI_PDEV_COMMUNICATE until PDEV_NEEDS_KEY
>     -> RMM performs fresh negotiation and retrieves the selected chain
>     -> CCA host driver relays requests over DOE and caches the chain
>   Compare its DER certificates with the selected discovery identity.
>     -> reject a mismatch before supplying the key
>   Extract the leaf key; RMI_PDEV_SET_PUBKEY -> PDEV_HAS_KEY
>   RMI_PDEV_COMMUNICATE until PDEV_READY

This is my #3

>   Prepare the root-port PDEV to READY and configure PCI IDE resources.
>   RMI_PDEV_STREAM_CONNECT
>   RMI_PDEV_COMMUNICATE on both PDEVs, honoring STREAM_WAIT
>   RMI_PDEV_STREAM_COMPLETE
>   Enable the endpoint IDE stream.
>   Only then publish authenticated state and the new device-generation.

Oh is IDE under the control of the OS for RMM? I hadn't read that far
ahead. Then it should be done as part of the "ACCEPT" step #5

ie the same place we would do RUN

Jason
