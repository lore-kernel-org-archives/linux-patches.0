Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020119.outbound.protection.outlook.com [52.101.196.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F345118C336
	for <patches@lists.linux.dev>; Tue, 30 Jul 2024 11:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.196.119
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722338297; cv=fail; b=Mfdv3kT9uYoVmYyEfUwyf66XXtGrvWk0cy4JHQNw9Q/ua44+mpNn7cJa0dyATc3hAbMj/leFFpCijWbeZO4akPSaOoWYe3rarmpnX0hJtV8+bPuu6fRCDnLGhrH11kb1P2hzhPg32HSfXe2G1cBvM9+Kd9wM9KbmrdkH49YzLNA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722338297; c=relaxed/simple;
	bh=v/KpH5qeXycGoss9LRyFD8Lqtu2p+wDP6hG0Hs1Ad/0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nKwHEzdOG3olG3cDzvcA106gyTht06RXYZY508Scvh03SQ6icnAQc65wArI9p5CXMuDHQAFuCWWbudd7m3dpOlWAyiM1fvjxyh32QLjFUqXfuIOIWwEMzTAQveIrFD4qsKTuTQojoGpLjF7IIlSIa9SWjOEylTsYo8s5waopDC4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=JGEaAner; arc=fail smtp.client-ip=52.101.196.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="JGEaAner"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZkgEgwniJ6IrGAKsmbzN9++1cE0rr7FYINC8RONE/XRQjTKx73TuUW6I8Xmp0j2r4GDdzGSmNgKpL+QQd45OJc/YOIQOkRoNfa79Ht/y3Ym4y+lPSR1cpEFx8e3ARoxPKCaLxwuadN/6ay5SdZXZMdffgqPRSRdxNpAN9NMJhwaIjEL8sGQlyItyRTVVEjBgfweZXLOa1PQ2jkN14jGb4RQlZDhWBZ6lUsTW09ZOM97q2KyLXBkPGEY9ZYmXHw5GC8lfxvwQSZ/zrMU3UreBJL0y1KxPPQhmR5P9XQxPU6bT11ztWdxHsD2Do5nGWieJab7INKpuHd2Ya+OSv0oV3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rl1CfFlQIH/XLY99Q5c1iUVlO+2w+QMDOL7rM+qFZEc=;
 b=fCh28dnbAu+5V2P57YVMd9v1rj+Jkln3x1Y5Hy9M623s9ZbWIti+GrUl1Yk/IjVPlIF/ZSuE6MQTH6wcYpboxDJx63yPRa9SkesPYHYhkEPYVRuIcjJOjDJX6eF57l6V4qEDqYoLEzGMCkNxgGr6XVZTYVl8dZ/BExhYYRGqGaAyDkOkoVqU3tFjOz9byknQvpf/jZv0RvXocRTgYHQYeeYPcje07V7VVjBUJ1cKEIKpncyenf2umzqByi0r2K/JTnPv76+9R75EOC64fl0Bw44AL3YQmyl4OvjRpJ52IYjdtjMWzgWjat5O5XpW6/9hp4X7WMYPyp6sN/oiMDOAbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rl1CfFlQIH/XLY99Q5c1iUVlO+2w+QMDOL7rM+qFZEc=;
 b=JGEaAnerWOVbdqdhobGcgCKlLLMEgi9NY7n3jtJfWpAtDITTYfwHdM1h04x3uXO63aP4owwtPsFUZbHPaZ3gUpWXsOWka0ZWjAKaB42Rtc4QlEVDklpsqIRM0vRob/TFrSCadorbfpTsGkHdDjDDq7yPZH0fEppd2N1cp9HxN8M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:253::10)
 by CWXP265MB1815.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:30::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.19; Tue, 30 Jul
 2024 11:18:08 +0000
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7]) by LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1818:a2bf:38a7:a1e7%7]) with mapi id 15.20.7807.026; Tue, 30 Jul 2024
 11:18:08 +0000
Date: Tue, 30 Jul 2024 12:18:06 +0100
From: Gary Guo <gary@garyguo.net>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: a.hindborg@samsung.com, alex.gaynor@gmail.com, aliceryhl@google.com,
 benno.lossin@proton.me, bjorn3_gh@protonmail.com, boqun.feng@gmail.com,
 bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 jpoimboe@kernel.org, linux-kernel@vger.kernel.org, masahiroy@kernel.org,
 mingo@redhat.com, nathan@kernel.org, nicolas@fjasle.eu,
 patches@lists.linux.dev, peterz@infradead.org,
 rust-for-linux@vger.kernel.org, tglx@linutronix.de, wedsonaf@gmail.com,
 x86@kernel.org
Subject: Re: [PATCH v2 1/6] rust: module: add static pointer to
 `{init,cleanup}_module()`
Message-ID: <20240730121806.7191f3fd@eugeo>
In-Reply-To: <20240725174713.103150-1-ojeda@kernel.org>
References: <20240724204649.7de3ffed.gary@garyguo.net>
	<20240725174713.103150-1-ojeda@kernel.org>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.42; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR1P264CA0148.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:346::17) To LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:253::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO2P265MB5183:EE_|CWXP265MB1815:EE_
X-MS-Office365-Filtering-Correlation-Id: 0dc08b33-add1-4367-3c0d-08dcb0894a73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WzFmS8Ps5ZQ5Mnfvlqq/njC6el6cGl0/bwRDVH7ZX1Js6y6FPQrq2krfJLI0?=
 =?us-ascii?Q?ChhSgvHGLSoixpXJ8zOjNf8hZLjPOfr6pWetMSSE4cMwtEjlNCs1lqRbc0Ls?=
 =?us-ascii?Q?nj+9KLLSpBc52k8wk3VsEto9VZc11LpcGdyjTR4Sm/UEsu4TJFf/qwzcdeLQ?=
 =?us-ascii?Q?VLrzs2EzFLv0Rxn7ukxN1pv8GhwG3HYxExR1Y1es/UAw+xlKgTlmguLJiq8S?=
 =?us-ascii?Q?ykXEDRA7fvfscV+nv40ehX9YC+TXyuDe0/ORtYbUHQj2WCpJLq7DTpLJZPeb?=
 =?us-ascii?Q?0YFxWIXVzxnqEiPiLzFTOc6RxjieF0u44///v0dopwPqB7tZWXN7dZMr/JRO?=
 =?us-ascii?Q?elfygErwMWbWzondB9Mc7i3o5Gm3ja4XSEChd3aSEd+RtJkKz/15RVCSQZjv?=
 =?us-ascii?Q?BdmoGofo2zHBQ0OMXpa+fGOPBrXW3Bdcupm6t728CEkU2wTzusSjbcuPGdWJ?=
 =?us-ascii?Q?AJbYL38hUkaL9uXbYt8GnUNh7Lgf935adtTC3VFTtbZ72lytqcD4QbZV60wf?=
 =?us-ascii?Q?P0Gu3wIalDIKw+kOnsF7L94eagP57uCZDi2+f49Cgv/Y8Ftb4xXomcNsCwdC?=
 =?us-ascii?Q?Rfr12/CZLhQwC58aPztLTZau60RHKjL0Cs1IgRRYO4pRIecNyOcDnr6qoUpL?=
 =?us-ascii?Q?mAUAkMaQFZmX++R4yim17jhmkoifo0Jlbmmy8/NHWjUn0PTFTWOakLsRt1oF?=
 =?us-ascii?Q?h/b9KcW1LTrECi8IeQ5CSYlrRE7SrH27aw9bOTIEzKXG13mvkAvijmzxNhnD?=
 =?us-ascii?Q?MeziAuXZTfMCo9oMSsobVDWIhDw0EpNCjhcH1I6ZumrqmA52LV4OTRZlAT0B?=
 =?us-ascii?Q?2mCELiL9o4Leg2c6zcMk65KiYOckLv5dBKvwmOrJzQ01o9WRd2uvzKqS3ZkX?=
 =?us-ascii?Q?QtWxHkUxdZrDGK3kIKrZ+S9xdzmjWxRKmJc8gYG86bMIg6kdhFUij/oljtkW?=
 =?us-ascii?Q?WbCb+ShRrUCOM+Tn7LDyBhQW0Gizjrn2s62siizz/2S9leT7jIiIL0K8eUd1?=
 =?us-ascii?Q?Cz1ZQP00C+4u6kOHP973niHJpNr9XgUnHWYv0EQJbyUKvP/wnWeFA/DKK0qF?=
 =?us-ascii?Q?+J2VycXMXFsT5fobYl3xVt/+0nrAziPqiQkr4Pmgoo0J5DKPJbrbM9fyzX8K?=
 =?us-ascii?Q?buKySVw6NRUD4gi7C9aFrMJ02K53LGDJ3oFf/REtR6g8iYR0xIj5hWYhjp//?=
 =?us-ascii?Q?mS9LrtbrxBqeybH7LhsniitGnWWauVvMWmnTyJGIvRBc44Ar/401MXG044iE?=
 =?us-ascii?Q?/GF4KuFj063l1uVF1pI7CSFZLUv7Oz1C2E5JXle2rE7KsaCqfPbpDJe4Zkc8?=
 =?us-ascii?Q?38sjvk7Nu4G3m/C3FT7mSpzSexL36CkxvQqI3MSVEcnH7A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?p6Zy0IBtNnrzo/ccEUdgKG08MTzkVAWllLQ3CCBj1ozUc8vS+nwDZurEhMxy?=
 =?us-ascii?Q?ZuwHXK1r7sh8TPb7dineeAmO4AwL1Hb0bpL1bnFPRRj/BBw7IsnJVctypa/t?=
 =?us-ascii?Q?p08M/NxBfsZYVOPgkKtlFm2L7y08I5wFdR4pSeURjTJK2jeRxsbDlDUvDBDx?=
 =?us-ascii?Q?lpcOrY5STTqtZS2zsc7xOSI0BsGdSp7Kr3BNDGSIFrlnSIkraE9ZlAex5yiH?=
 =?us-ascii?Q?OvM0Mhi8mDw81jBjVQg1YXvHK8DOXuxDN0zj62WLh6irh1ae+zxC6hVI4enp?=
 =?us-ascii?Q?40tTTzT9xbTb5OtuuaByPH2m+36NU/V78aeN3hejAaHFccX9xtQ6ERlfkpVP?=
 =?us-ascii?Q?dvTBrkLxiUHKqk6fmi5d/Vmxxc+JLYpBdxfk9alzqqaFNhy51MlCtBBgfAxt?=
 =?us-ascii?Q?WTt9qWhID9GOfBHGzY1A3NnDIV6nomnLmzMhklB/S8YNr6TPclmvC5K1raGX?=
 =?us-ascii?Q?TMrVs9vgrs7zarTJz1BjvlhXrYesfmEFMzt6rNYZhduaDGxMQBGo88yv7BN+?=
 =?us-ascii?Q?0zuUKb4LZ+frf4qGSDBVkNcGi0Hl3I6vTfVxAmZ9v5PjebNhOl2qylBx3gzn?=
 =?us-ascii?Q?Cw39C2rEPw/gK2Z6rD2A7AZW5PLupFMTE8kwATGqcDzZAB5pvSIYnj+0ZMb+?=
 =?us-ascii?Q?LPekdFyTZdT7HC6dCSsxhnMYDNhZcTMQgTlzCnyuAz3HWVYT0oKuPijqdvvh?=
 =?us-ascii?Q?2UVHjz2m3zWn0FUloY6w7d7EPyIPh1g6L9wvBlI8V5zbyaH5K89gqOevLa67?=
 =?us-ascii?Q?6BJp+QejKCEZqHprcAx0z/BKbLSz87eHrAlrClGGWtk8VJZB0JPS2OGrHIgP?=
 =?us-ascii?Q?DSMwJahqF41qnQc3nCP91UnUzjHW7MXAqe+Uhj68GbqksmPVKM4KXRzlnlmr?=
 =?us-ascii?Q?MPVYj/HKFK/zFm252nxeCU/HJUpzwYl4VLJFrTHCgCUXe1acjOWs5UY/9twC?=
 =?us-ascii?Q?Reeokdiskz16MNPIIyA8YcVaeTZx0KNt1IKLmKZ1Fp6AfaNZVArUKZ7jHG3v?=
 =?us-ascii?Q?FMbUvaClRoJMeMvLW04aKVft3O5BjZ7IfeFmI0G4LBTDCkzjkMv5xK8kgScS?=
 =?us-ascii?Q?yPLWGbttRg8Cd2QLmy5a+u/SgwT5kKA0UVMGBX8J5/dOmYIXjXPLFtbf0Shs?=
 =?us-ascii?Q?0bUZsTefnV78vxTA6pnv64vGySqySf4HmDKnD1zq+r2eaF1vre6bDGFURgVb?=
 =?us-ascii?Q?hM0/kLAWyfZQM+iB/OLlwgB9PU6bFGtsSWP4g9IjDw19TbC5xHqyvxoeBMrw?=
 =?us-ascii?Q?CrrsQrfYnC6J1R8jDdBsawqENgHevaXCJ/1Cn2XuStkyg3c6/rACFl+aBCTP?=
 =?us-ascii?Q?m5E0/Ndaiv0Vuj32uK3FPRGs8XlGPzhbswyTHwnMgdPy/fzMuRdklkogUqYY?=
 =?us-ascii?Q?BZ2rs+1f3Hj4pr1Mns0pX188zQolpOMMisWCQBn9TDnVUr/M5JQ0c4XBNDTZ?=
 =?us-ascii?Q?IgQPEzvu82hZ88KEQWAPatxUmiUrkWZWP96hVS053vMKaZ9JhVbQVI70Hmvf?=
 =?us-ascii?Q?Pyt5Qpd6MjWNTYa8BItgIUrs/xOTK0Qo5pv4tYqkSJkQEKNTeNK7y4SEMfZv?=
 =?us-ascii?Q?zUHaZhnqHHPY36lex3mb84JmAlWPiDBVaVogelGn?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dc08b33-add1-4367-3c0d-08dcb0894a73
X-MS-Exchange-CrossTenant-AuthSource: LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2024 11:18:08.7947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c6fNBD2ehwZ2fiVQR1EDIzKnEDu737RnfrDN5SFdEILStLrKQY/M2XZ22AtFRjPwpjRoyNZba5wKVocMHip9Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP265MB1815

On Thu, 25 Jul 2024 19:47:13 +0200
Miguel Ojeda <ojeda@kernel.org> wrote:

> On Wed, 24 Jul 2024 20:46:49 +0100 Gary Guo <gary@garyguo.net> wrote:
> >
> > Should this be in section `.discard.addressable` instead?  
> 
> No, we need to mimic the call to `___ADDRESSABLE()` (i.e. the one with
> 3 underscores, not 2), which passes `__{init,exit}data`.
> 
> By the way, thanks for the reviews Gary!
> 
> Cheers,
> Miguel

You're right. It's a bit difficult to navigate macros :)

In this case I think this indeed matches the C implementation.

Reviewed-by: Gary Guo <gary@garyguo.net>

Thanks,
Gary
