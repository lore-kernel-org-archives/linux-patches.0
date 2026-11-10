Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.13
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794323274;
	b=Wt/ok1abSl+ef8Zk6BHMcPE6KRHz5yBJI2mqDChhewP2OBkZw/CrcykA2AfSXwYZgQxB
	 VsqWdNacn/yy7P042e6cp1ttehYehEASdRJ+I0rY9aPCSPXcPuab47NNI0juunQhM11K7
	 pFNGvDK2OvzK1V19V6KsPK+xQIQMl611gxEpPB0bDkT7L9suDZ7bMnS5wTMgGvwBtZk/2
	 67IoJAzO+pq0oc6fA4FKFcq1Qb97qGRENPmXxQa5/bm/8uI4dXPsiH2tGmAFs5kpTzxjB
	 2EbXaV8Z3oUgYZlGMgxKyFc+m1uEag+hAMdXaWsD/+yPU8V3sLqyncLDp6pE+yBIt2Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794323274;
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
	bh=OZCx2PTs2F7whkcBbIQVmgxnhV1jst8iVJRQ/xRgCXI=;
	b=JjeQGMNAeFR1WvzxV3mpjkrsbVI3fK1gsPB9PKVgbzTIzreQ49AAIYEZup1oKEb22HQX
	 6PO9QCtwch+P1PZc+bypi1SW+u56tiHrXRpgvWgV851qquSHdyz93iRL1+GV9L6x80Aih
	 4Ro8rn12CWbtj+tIHdLWUNCKxZs3gam9FPNRJXOkPZOAG4BTkqaVopwz2mDoP6EnOc+ev
	 xHiBn+8XdHTP1KhRjARDTBq7nCKKKgYKQ1k63UI0z1WOkqazLR0nq6x8uJ5FewUgIa+MM
	 WIK68A7tVkNAqRsgMmA4ihCyqUGTjMSjaA5AngX0ulnq26woh1qoJDG/oFE/XE6qBiA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Z+s4BlEC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.13
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012013.outbound.protection.outlook.com [40.93.195.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F41606A32E;
	Tue, 10 Nov 2026 15:07:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36F41606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Z+s4BlEC
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=copms/ww84NDCbQG+VmNBA5ZipBNzu5CuPU7lS+IAAViXHgPKqw8QyGTEtkEW0wFPUBPMe/MXMbaNB4h3pu/+NjDZMX1L0PVai37qWFxu+XB31NeVyq3bi9kE0a6Ot81zjSrd3C6/Iq1AqqL8fhEMVZvGVBUnC7KsNiy9uVBalxYhhyAb44Agq5odboZVpBN5hsBpyk3cdwkExw4F9aUIhZbLnigVFO4zbCFmKHunZdZuEWtnVtNigaMSPZ7wdSKJDzvzdZwrd4u2FJjOKtWVOJ77Q89Yk3Qx026sBWrOaefXbbhVBEzKxTV1cJ/ODe1OxTb0hDQgGtmoPsT1sBPwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OZCx2PTs2F7whkcBbIQVmgxnhV1jst8iVJRQ/xRgCXI=;
 b=rodaiqn8VyRstDAb+B5ooaQu5dormirSMHxnSa3c62Pty3EhZqRMVFvEeonnY5rAjziFqxpk6vC0nLwWWU1dRuIFOYPcgnGI0Tufsgh/1gHP1wZoRyfrVIYuAtOmPVREEgcF9PfYLNexTv3ncY8VvBeZJj88r0a8LVxgS65ghuSJwJoJrN/PLMlN0bk9sJ4k8YYw71AxBpUn7VJ28Tw1hJkdeRZ/JY1/2i65BN0EAeCF/+pxqf4HKnIJIMwr0O/btETYytdlPO0ebRfpH/QSAR9aCDClulnw2/O2edCq3KruSxIhJ2nktnzihzJD/akGh90JtKC79WunR1QneM5ERA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OZCx2PTs2F7whkcBbIQVmgxnhV1jst8iVJRQ/xRgCXI=;
 b=Z+s4BlECU5DEAWo5f8e0CNoMXGxDdTPdcXq57m6YpPGedYBqJcLO5e4hX9cBDkOBhU69YA8uq+e4cxT05uNHIsGDVLajHGA0zD6nl288m0u6/4QVNIABpXLeIt+eqm0tXDRRUuIUcCY7HUTG34qU5TsBJchQIxNRXN5pwYdXx349RckVVQrHFcidCtgUBIiduwDMg592WFmfqEZNOewUy22HG9ls2HajVQiBFCA5Y0IZBpGJXhmmGt2jTHOQebibDtsFIPqSW2v1F1rgX8M2Fd69m/SJkEPXniHueLHhFk6vCDVT0PGHgysP/4K7LS6aQRtHF3rzJaxj8f9si12iBw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LV0PR12MB135619.namprd12.prod.outlook.com
 (2603:10b6:408:3e0::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 15:07:49 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.007; Tue, 10 Nov 2026
 15:07:49 +0000
Date: Tue, 10 Nov 2026 11:07:47 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alistair <alistair23@gmail.com>
Cc: Dave Jiang <dave.jiang@intel.com>,
	"Reshetova, Elena" <elena.reshetova@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	Jiri Pirko <jiri@resnulli.us>, "Tian, Kevin" <kevin.tian@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
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
Message-ID: <20261110150747.GF738765@nvidia.com>
References: <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com>
 <53bc57bf-1ee1-407a-b48b-bc6b2deee12a@intel.com>
 <20261108183337.GL770409@nvidia.com>
 <2b89b830-f1e4-4304-93ee-40287a4b5b2d@intel.com>
 <20261109185315.GS770409@nvidia.com>
 <4765e562-8c58-4e0f-89f4-eec23b5ef102@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4765e562-8c58-4e0f-89f4-eec23b5ef102@gmail.com>
X-ClientProxiedBy: YT4PR01CA0339.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fc::22) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|LV0PR12MB135619:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a0a5e69-2a3a-4af6-a800-08df3f3c622d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|6133799003|10067099003|3023799007|261028144727099003|261102123227099003|261026121527099003|261026140227099003|261021135927099003|261021123027099003|261021121427099003|261022105027099003|261022113327099003|261022075727099003|56012099006|4143699003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	yXgWFrbNSMw40FyXNA6VPG5xb0QjqjNFKqup22BbK2ECYMlRTD9/opArq6onTFhGnwpOPZ8xvqlQFSFLEYpJy4R6JDg4aSYudSj9YLiOyF/7DsokBy0hBfEdtvrZzUamsiBWqgxPaX2uEYY89TU72+T6OoODnbvbEILYopVRT4ceC/dR7C73jNKXasSSRJg540ejPQ0/9P8dXUuvD7GP+jFs/dgvlnBV1mTF827796Oukmgb2AgpaKFEPs7t/wYuaaIHHqSNFquGq2ZPcvydMSeXYl/3pTmhY6QAhiJclM31SARmj5zDhwXQoHYU5juYO4Qg9CDwnjtL5b40GqefeeQbvY1qnzy6pz2tqaB1oG/HBaEjx2Rrduf0DvyiU+sR9QB/bNSbqbO38gp5Oot7vp7PlxwBfE9Ns62/+CE4N11CeWlk7XpudXy5t4carqStYC1JoBXoBncz7pX76e5dPRr+1QYbRmuysW6JVtt2het6krpkANuYb4ojsfPQRy2t9kuLT7oCCrINxFEoQkNzjz+pyRLUwJdrVDILPie4LHSCnTH1httMNAiTJIf2hhi3e8MpVNlBhSVsl6uPq2NEN4/XnGjt5StRTrsgM5ipZKgvYvsqpJONfnf+YYG8AIzY/xYNRgAYZmoDDrfB9sXXlQrw6OHZCyhBmhZnXdYaKHM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(6133799003)(10067099003)(3023799007)(261028144727099003)(261102123227099003)(261026121527099003)(261026140227099003)(261021135927099003)(261021123027099003)(261021121427099003)(261022105027099003)(261022113327099003)(261022075727099003)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KPPq96Nu0XOy1kUaRBg8I4IOm8swx6Y1IcldK7jODp6TPVRdNf123015zpm1?=
 =?us-ascii?Q?r0rA+pd2k0xbsTjkQuvY0ZirjRmXVsLf9NaUMRWtrZBTvgG7fOeui5ui9Zkb?=
 =?us-ascii?Q?aN5u79N2iQy+cQuY8GWjq5a9OsOo7xj1k6xXJ2KJeL52x5/OvWlLFMDwrDqa?=
 =?us-ascii?Q?9Fva6l8hRnm/f6eOOWGa/Q2dzSTKyS46hGsAWVdijRW490mDgoNQFbu9N2nw?=
 =?us-ascii?Q?FiOQrWucoCiCKhh4E82T7b93N3bwyWEBO9zU6DzqG6jrvzHAdFf6v2FalQ+j?=
 =?us-ascii?Q?jRkXN0+aFb3rSW211mzkGjbm4dk37Vl1g8BnLO7YNjbiDEwrixKz+8Gyc0aF?=
 =?us-ascii?Q?SHiX6WYxrSA+sc0fZcamuzkLB1y5i3locB/j46RkQBFZ6fUZBhTLzboYsc96?=
 =?us-ascii?Q?Yhg3Mt9aMDREwkxKB3yHbn7m+ZrAElJKoZvEEkdHxEyq4xjHHmm54wyEqRdw?=
 =?us-ascii?Q?2yk+lXjExJlnaUU32ijl4vfZED4Yg1wQf2KU+MqtTpzI4yGSa5yMlDYXb4zl?=
 =?us-ascii?Q?bKWBPTS6n7qxjELJWIWoAFA50Zac3y8mELRmvmL22WGk3ao5T2+J3Bwanyad?=
 =?us-ascii?Q?+GuMrZ7NL0NUe3WD7sUuMFS0i4LD+aWuDSU6KeGrVG063jfAqvvae4DoisEF?=
 =?us-ascii?Q?YAmW6LSZh6UZ7DwmJLWhCVpRL9FiOVwDmbPKh/46VwgcElGQOFL2PWiMkC9V?=
 =?us-ascii?Q?/KXwxmk8y0WMloVcqqss709Am28xW2VkZLQAxepd4eW0j2rwOrmA49MDpR8Y?=
 =?us-ascii?Q?7d/hdvXyMpDshdwK13iuh14yfiGY3rgSUaBD4mk9GBWRktALtHSO6wpe06p1?=
 =?us-ascii?Q?x0Qzfd/I4qHwuNkLMREiEjsNsBPLS7yelh7ZsuX6BGh3eDNuViRPb1L20PqK?=
 =?us-ascii?Q?NPqMNZHiancoGc+fqFTYTOZ487JEXOlsr96ZbpC8ij01kagWxJyN72gKizRI?=
 =?us-ascii?Q?GjNE1VHFAQrf3+3wcIRURkaTl7TMV5tjKQn0qGCmFOjPUQUTrR8ewXnrAl0O?=
 =?us-ascii?Q?uaJS7IrNxDn3kE1kiYsmsy0nAek08H5yB14/dg1+UiloVSBRvHrmmsFZoLV7?=
 =?us-ascii?Q?y9GKFAP6tM87VThKnb4IuS/IxYV/knFZ/q5lf+z8/9tjFmFBQPjoEMy8FEm2?=
 =?us-ascii?Q?JaB7z5BWZJ1utBurNrHz5O6ePcrfFShOH+B9ekjAtVKrydGdAlQARoKY7C9i?=
 =?us-ascii?Q?ScaQM2IM3mi+Y6yYd8wbpQxJKxp3mcVasKQKOQURzVdsVwfyyi4bMUJDnVqN?=
 =?us-ascii?Q?DXeDnTixete/2KRwaP67ELqjLv3snryAsbAAa2HIfDDcStHqvRd7tGYxZgiF?=
 =?us-ascii?Q?TDe/vsvsHtbVQn8WfrzRqHTV/emWSnZq0KsvaF/Za59yZudgmQ2EKi4ynG1p?=
 =?us-ascii?Q?BGXw482Uq0MFbVakF2wUOdzZb1kbvytvxBn1CKdHX0PgWx6ZGSUkl4XCaubo?=
 =?us-ascii?Q?7DgBjYET8fFhXU6x2UJ01p1FjqTDp+aHB9Q2ZWAMLJvIYyyvvBpQjJIpcA5v?=
 =?us-ascii?Q?djwHFLqb2AAiB31dH4z5JU5OYMx9XTH3qXZCCd6UZkkNWnoXP9nLTMirTjGV?=
 =?us-ascii?Q?yX0hoY6RQDezWGNnu8pRNH/H1rYfaNephqoGXz/ua9+VZE3aAz0aTfVRBzpn?=
 =?us-ascii?Q?ML79stLL6OpjTQNWPXPZbqJyM+opQxoyREhZwXfs79LulQQcLlORKiFwiS+x?=
 =?us-ascii?Q?iktSAt3ZVtwueUZhZtpm08jRQIfYiLTzk6KIQj7UlrjGvb7J?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a0a5e69-2a3a-4af6-a800-08df3f3c622d
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 15:07:48.9333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kuy/cy+kKgywfOybnrcZ1RRZ2IztU+Iozp9NBATIIGRcVe1rh6ThlIK8q47SYils
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR12MB135619

On Tue, Nov 10, 2026 at 11:40:46AM +1000, Alistair wrote:
> On 10/11/26 04:53, Jason Gunthorpe wrote:
> > On Mon, Nov 09, 2026 at 10:37:14AM -0700, Dave Jiang wrote:
> > 
> > > One thing on TDX is that TDH.SPDM.CONNECT also runs a
> > > GET_MEASUREMENTS of its own during the connect, and the kernel
> > > doesn't choose its nonce. The kernel wouldn't hand that one to
> > > userspace. Measurements only come out through the two flows, with a
> > > user nonce.
> > 
> > Why? Seems like another wasted operation..
> > 
> > > That works for TDX. tdx-host's relay is one function today. It takes
> > > the module's request from a page shared with the module and calls
> > > pci_tsm_doe_transfer(), so att_spdm_doe_exchange() drops in there.
> > 
> > Yeah, it looks like it works for everyone.
> 
> Jason just pointed out this thread, I've tried to pickup what the discussion
> is currently up to, hopefully I've understood it all.
> 
> It sounds like the current thinking is the TSM will issue all of the SPDM
> requests and be in control of the session. The kernel will forward those
> requests to the device and Rust SPDM in the kernel will be used to decode
> the responses.

'capture' is the word I want to use here. We actually don't want to
decode them. The goal is to get the message transcript and share it to
user-space in a 100% consistent format derived from the spec.

If DOE had a more sane protocol this would be trivial, just unwrapping
the DOE transport and recovering the exact SPDM messages then storing
them away.

We don't actually want to decode them in the kernel. The padding issue
means we need to decode them enough as part of sizing them :(

> The TSM will be in charge of slot selection, bank selection and algorithm
> support.

kernel will do slot selection, but TSM will drive the slot numbers in
the commands. Yes on algorithms/etc.

> The current Rust SPM implementation has split out the message processing, so
> that should be somewhat easy to reuse. Basically (in Rust) you pass in the
> bytes of an SPDM response, specify what the reply is (CHALLENGE_RSP) and you
> get a nice destructed struct back (or an error if it's invalid). It's all
> called the Validator as it validates Untrusted data and returns an SPDM
> response.

This isn't quite the right thing, we want a module that undoes the
transport chunking, padding, and GET_CERTIFICATE chunking to store
pristine raw messages. We don't want to validate or decode them,
beyond what is necessary to undo the padding.

The goal is to pass pristine message bytes to userspace as the
transcript report.

Your series should have most of this, but I am guessing in not quite
the right arrangement.

> > But it brings forward "rust spdm" or something in a new form as a
> > pre-condition to do the TSMs. Which is annoying for sure.
> 
> The Rust SPDM code is hopefully really close! I'm planning on sending v6
> today or tomorrow. 

No TSM drivers will go ahead until all of this and the uAPI is fully
agreed..

Plus now there is this issue if we need to reorganize things to
support this capture flow.

> > The optional chunking features are a bit tricky, but I don't think a
> > 1.2 only implementation needs them. They seem necesary for future
> > post-quantum.
> 
> Maybe for PQC, but generally this doesn't seem to come up much with DOE. So
> for now it should be fine.

I gathered the PQC issue is the signatures can get really big and the
biggest DOE chunk may not be sufficient anymore depending on
implementation.

> > This also formalizes the version locking: the TSM FW cannot use a SPDM
> > version that the kernel does not understand. I think this was already
> > basically true, trying to do the 1.3 multi-slot flow is not going to
> > work out with out kernel support to move the additional data. Maybe
> > nobody noticed, but with this scheme it would be really formal.
> 
> The kernel patches support 1.0 - 1.4, so that should be fine.

Not support as in "I can be an initiator and do a limited subset"

Support as in "I can be an observer and accept *everything* in the
spec the actual initiator might use"

For now all we need is a fairly complete 1.2 since that is the minimum
rev for PCIe (by spec) and the only thing any TSM FW has implemented.

> > But, I am strongly tempted to make a draft placeholder in C with AI as
> > a way to get alignment and try it out. Something we can throw out if a
> > Rust version comes along.
> 
> I would argue that you would be better spending that effort on making
> changes to the Rust code and re-use that. That at least would make sure it
> can be adjusted to do what you want and would be more useful :)

Heh, well I don't know Rust so I'm useless. I also have no Rust
knowers to recruit to such a project right now.

The best I can do is make a draft with AI reusing parts of your series
that shows exactly what I'm thinking and we can talk about how to go
from there.

I fear it will not be very good rust though. I fear this will be a
huge delay :)

This direction would end up with two series, a core bit doing the
message capture and a secondary one doing the in-kernel
initiator. Maybe we don't need any new rust bindings just for
capture..

But sure it is just AI $$ we can have a try.

Jason
