Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794341240;
	b=nCuzxmXc5iPfMrTkartPbTgMyY+IewakP7kI+5JA6Z++i5pxj6i53j2y3CnaO2KqnsyF
	 HkuQ+qjs48PSGLXVIHQBMr17+Q/Ahdc5RXLGUytp+bhTlLBpe44guMH/oVYwUe14WBqwb
	 4sF7wzIyXRYnvdsikImeiKM+1oS/0Db4b5g6QMlzkfewMIbGV+uIfpSLnxvzFatDNua3u
	 5lOEoU9Oo18uM2imfmHv3UPhpWRxT6e5WxWfjf5dL04DN9MZjjNITAXHKcwrATkVx9S2l
	 XG9Vsi1wpQCVSVNDVp33zaXsJm/nGWRa56LOff05Xy2bCmKnK5lc0yx6PiGO0QnlQcA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794341240;
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
	bh=JnsQV8+3SGNFu6s//opa5/+fxy+3vNaO/Sr99GOrrA8=;
	b=mv0KhbUoIuiKQi+AI+lzA+94rLw85vrEBhcSg/v2qDfH+GB4plvGsmesl39Uc7dbGHWR
	 zw7iF2Jzsruyz0fG7mbqcs3sHrlTLVT7WXyfmL07IL9bR5gtH7sh47aPBLqdompzrLck3
	 XbQ2mqEYcKwFakru4+dphEQxDBt/m9im/XVlanxgbyJ9EEL4dE3YiS2y+Eb0UfZfsJaaC
	 znruR8aKYVYe7BUyO99ROnSuogjVu8/mD/4hl4ZR6eFqp72/h5lJ/FpDil/eSqIXZ782o
	 NhIT+ZSSkzFZnPmbSrnEvjJgsUVPIfVviNqx+FATYgO9Xv7ONyeFSc+b8Wkj9MX8lrQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Ky6KE8Y2;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.47
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012047.outbound.protection.outlook.com [40.107.209.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5025606A321;
	Tue, 10 Nov 2026 20:07:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5025606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Ky6KE8Y2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fUApT2g+8FCHB4wOJI5jZTvq9CE7qucn/5MBGXw4X7leNuGRPlnM8BpMKjvhChOMx8qw0/hDn/NMR0RNUTr0MyCQIzDWlU0b+DiOPc9AQLe9mXsjJm1OFk70FOZAdN7tGLhnEjxTieenHCrxEbR2Zwu3BhbZF608EQv2VcyMWrMeDc5HuWAzvb2WO6KkNox/NmxWdpKj7P2s82pM691tr8vOgO4USH3vCG9Z1jcn9oXQo7lXt4eh58sJ7r3U6jslZ2eQ4U9ewXaG4DkxWb8t5odkkLlgIAoMpEhP6sCHHzHWWohEM1R9a+5mMPytYcu+RwhN4SRyIAuTBIpDxPzN8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JnsQV8+3SGNFu6s//opa5/+fxy+3vNaO/Sr99GOrrA8=;
 b=Bmvktrt8cPGwzYZ/pAON5H26T40nchvZo/LSRwW2hnv+HiyIujdGXaN8594Zt5Ah/sCta6QnaSMBgpr0WACZ10uLR1xI7eWYMIEvVn2xvp1+IsqZKYeKQrizdsWT6vgLxg6xoE/fCRqAoGMuyKqsaG6bALRJjB3y4AdRSfAsAUPI6HGcsNaNK9dfPP0RBIiSYX2kXyIvtB3jPLTWqSQZf8lZACycQMwLVx2jB8TmQkY/6WRa6BvFMld4sMO1qOYN0F84NkEL0dJc0jdPhYPVWTza6iRZ0AqNo6qlPieX4GZ1aX5PCXOe4WV+zoME+8tHCEPOKe7uVNlLQXXuiBomYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JnsQV8+3SGNFu6s//opa5/+fxy+3vNaO/Sr99GOrrA8=;
 b=Ky6KE8Y2i1XlkIx+Q84fGGoL+WTr8gqhXEHhDzs6rUobOCK2CXtaAMFduwz+8qkZ7Nk8qBHUSH0xb9KKmUrbmRtDyFTYC5X52dIhsJ4J5pPJvIcIhKFX8F4ThmoqbHafB6DQCbOshNPbysG0YCAm5IfBrgXfEdRuWP8LJQe7mTarTuMqK1BmuJ39G5K+k6ed5LG3t+n95YHjVKh5i3HqZ1Q6uKPb7NYJuQAquhmoEB+rgT+ENiK4LDWayj0xeEwLDjLVpJ0gSEYlUoDAJ3g74OBAt6L4roWqh0GyvW9PLNg3WSFE5PzInYa8fXIX8RHOg2P7bNSVqP81usDaEpBIpw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CH2PR12MB4103.namprd12.prod.outlook.com
 (2603:10b6:610:7e::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Tue, 10 Nov
 2026 20:07:12 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.007; Tue, 10 Nov 2026
 20:07:12 +0000
Date: Tue, 10 Nov 2026 16:07:11 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>,
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
Message-ID: <20261110200711.GA1504491@nvidia.com>
References: <yq5apkwqa5ve.fsf@kernel.org>
 <DS4PPFA84FA90FCEFB18E5620217FDCA728E76A2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261102172640.GB274202@nvidia.com>
 <DS4PPFA84FA90FC31B41ECA1F6ACF6D0600E7692@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261103151643.GI274202@nvidia.com>
 <aurmtTe4ObBQhC4S@yilunxu-OptiPlex-7050>
 <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
X-ClientProxiedBy: CH0PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:610:b0::21) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CH2PR12MB4103:EE_
X-MS-Office365-Filtering-Correlation-Id: 2dbdaae2-c6bd-4c29-6cf3-08df3f66350f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|261026121527099003|261028144727099003|4143699003|56012099006|11063799006|261021121427099003|261022075727099003|261009223027099003|261026140227099003|261102123227099003|261022105027099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	dprpHFkBOVe3WaBVFZYFY99PDmRu6lfNte/pgQo0WUEBqA4Yuu8R+GF21qz5lCRqCoWWyNmrdQCNB/Ik+1Xuf2bhuEaBHhICsKWlKtK/syp35YfG+rhdMkfwDe4OmyEqNQVssIf9XsbVPn7AOtZTLCoRTDnZ9MxS0fQD/8gc0V5otMT1PLA+hq6Znuwnrv+3Nf+W7WzB2w6olLg1o/A5h3nOiNpbMIXY7ulvwx/1Og94fz6tUIl/sBRHngc1cy1h4QjmBEy0mfRDUpvmPqRo3F8siLADr6gnMsps+Mgzok1lWNeiQV6pUoe0dQLHKX2mS3WwpLdgINnpWZiIKY+ePVKY6qFuxuwjZPMEWjfhoAGCn9PL1UrRkDRLSMPkJcEDw+z19Tsey8ui0QQtpDgSnn5QUCQ9KYL3me/TPX0O2eFdEBg/fzUJrO9TRjas58RrvGWlX+5cGwjGSyDjfvJbY1EYRnbsC6SaM36ybhiIJUJUD82h3lnzQ2XjqPuZolxe4l2OmAezcKzidDz4IbuEj0L8bTRgaEvObvRxUvW5t3R5E+/ZgAymIR/x4+iLtyg8SUZYRcfX7x3Jtghuyid7rHXWcJOWVtISz80/vqNL8/Ygtak/cG54iaoJxPzzGtW70Jbqsx5QA0/zoo6bja5K3owPxJTUZLtmdkbba+Ya3ik=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(261026121527099003)(261028144727099003)(4143699003)(56012099006)(11063799006)(261021121427099003)(261022075727099003)(261009223027099003)(261026140227099003)(261102123227099003)(261022105027099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nQh7RgL64XnBkoPhGz5wgmXRS00dlA2xaeKU3p1sIFZAHBv698dthaUq4INW?=
 =?us-ascii?Q?5f6gAO0PEXdugKSIhmmJh7+eVdwU0UG2yXzfPfOAL0skASFO7H4ZSKS0k71d?=
 =?us-ascii?Q?fhJvPCmn6tRZujqwJywu81Or8r6tUoJ0ckztxWz/rT3CJcY2cLgbJzipV8no?=
 =?us-ascii?Q?vrxLjVPo6Su5LXGx9oKeCrBqHzDUd/gBCnfv7JI6PttUtc0Q+Ag4/16vUd6C?=
 =?us-ascii?Q?oX31zCIJXMR0BMHumVfQn5iRxsdmCuMvnzALBfpAAiGahOGGlvs08h46Q6iz?=
 =?us-ascii?Q?3gg/5lJg0WBKQ+N9Ugp78TM7zHTXJKJ+Lpj8PVDoYE4CxyvH9XGJvPkRPBtv?=
 =?us-ascii?Q?GbU8Fj6JUEsor4u2oISPWpsSx89S6fgTrHzv8YIP5bxOPCzPJ6Llp+DCYvEW?=
 =?us-ascii?Q?6pgaerj+YI5jbFPGGioGV4vk1WS4RccM/dhS45OjCuFQz9USQQd/AXbd5AhZ?=
 =?us-ascii?Q?YVkib8I2UEKL870vkUApWrv1EteMim8IyZByisJC0BbyL/IAjJKn+vJSlKnf?=
 =?us-ascii?Q?5CclHp3ffU3J+DbRz+XKAz8u4DTR+zSMWQdfOPLkMn2G+5fd1yF6sbo2zh7u?=
 =?us-ascii?Q?Xq2MKJ8E5XlR5UUGF4NqjBIpy8uM9yLec9pJfkVcpfkv46IMMalWoks5It6W?=
 =?us-ascii?Q?oVjhK0vxgWOblMykE84JAp2OLz+RLpan2K8ycZ1bKQBGXdBlNAABrarI4zB3?=
 =?us-ascii?Q?hPn2wHXp1nsjiZrsX0OaEyyO5N3p5nXpw/wIhmQ4a4+/RJWdxl4DhDeYsow3?=
 =?us-ascii?Q?WCkgJHPRIuJo1y84YRSlIZFxm7KHf4AN+7HEif75TYCMUYl8clwN9vwMoNLE?=
 =?us-ascii?Q?Ru7+0jGy6uNhx+VLVIUYRI0PLef2oq3+r5uL62ndOk7WwM6Qo5IdHS+CkLxb?=
 =?us-ascii?Q?LVjX2gOTBu7fJ7Z9T7/aWV0CcVzLfZIB40Choi8pYVvQmzyoNBWWlXxQtYI4?=
 =?us-ascii?Q?s6rUFu2FqujSr/X7ddwOqhsomv02/Q13FZNZhpJySTeufP7or5Kqu5j4kKyB?=
 =?us-ascii?Q?arux/9CdsgGec6dyyJJPGdFX5scpNghhzgiPLoa9SfMMqP/6ue14+quJc4dZ?=
 =?us-ascii?Q?o2/S8sNvqJL0Jsy15Vc/OorulqDkrnqEch7w6UALbaszXy4LKOo88odGcwQT?=
 =?us-ascii?Q?UIsG1PJlxWAIKmKc8bRNRJBJS0Nhw0A1apfkOUX+sMNiMGfBmyWNGG+kcnND?=
 =?us-ascii?Q?GvDpyecKljvIBal/gSmCSs+Q0bJOq4c+HrLaN3W2H08Yawc1nmb+A3BkaawS?=
 =?us-ascii?Q?qmrztuHpciXSIQ2guEir6zmzo2xG5AilQ1uQxQKxji60gIi1Z7rMzPyJ8C3p?=
 =?us-ascii?Q?vGBWQ9YKk4557/dOHVcmHyHzZXfjZFFk3+S2/kLYyrqTAZ2bSM8Hl+Rs2TLB?=
 =?us-ascii?Q?RnJwI7Di5rAHyXjchUWqf0vtVQYT8zYd2BfTIIvc2pDQce/7kDQdwk2pRnRP?=
 =?us-ascii?Q?nTV+VS20xbKM5lNNqF9AyWHN1a+gm9KpKOkqjnrusFtfAr2GHpBh6YbkSAu6?=
 =?us-ascii?Q?1tWm9zYc1vjQa5oZPg43O3ixI3M8Zh2K0ZLyKp0wRYDudNjnSJnAgMJ8VA7J?=
 =?us-ascii?Q?ejIjqqM3rMtty4sFlWeYPgaJBrYD/kgmsDn4SZc7LNGyK0FtExz9erVKvVZO?=
 =?us-ascii?Q?ondlPx2WrsIQNwC9L5b7uqt4Wpd3JxvO+Vp/G15E0JbCr3FCrVez910EYwFK?=
 =?us-ascii?Q?ha41MFR+KgtPQRDtRExIWJH/uyF8t8HXC/D06W5NsOos11KR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dbdaae2-c6bd-4c29-6cf3-08df3f66350f
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 20:07:12.0316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pNLOrcJbn1lji8kD0/n8ad26Xo2/h2JNlqI3Uqj2wTMv2RMAE/dFCU4nlBaPbb+f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4103

On Fri, Nov 06, 2026 at 08:53:39AM -0700, Dave Jiang wrote:
> (6) SPDM_DEVICE_ATTESTATION_INFO_T [ABI 3.3.2.4]: SPDM and TDISP
>     capabilities, TDISP version, the requested chains, and MEASUREMENT.
>     MEASUREMENT is the signed SPDM measurement log, Concatenate(VCA,
>     GET_MEASUREMENTS_REQUEST1, MEASUREMENTS_RESPONSE1, ...,
>     GET_MEASUREMENTS_REQUESTn, MEASUREMENTS_RESPONSEn) [SPDM 10.12.3].
>     The last MEASUREMENTS carries the signature. The TDX Module keeps
>     the info's digest. The kernel keeps the info as immutable startup
>     data.

I threw all this at AI and it could not answer a question..

If the guest obtains a SPDM_DEVICE_ATTESTATION_INFO_T where does it
get the VCA and other transcript information from to validate the
device signature? VCA transfer should be defined in the GHCI calls.

AI also complained about inconsistencies in the spec versions I
grabbed around if the recollection also updates the
GET_DEVICE_ATTESTATION_INFO_HASH. Your message says it does, and that
is what I would require, FWIW.

*Every* GET_MEASUREMENT in the guest kernel needs to trace back to
some crypto binding that TDX module was in fact the one that issued it
on the given device in the current session.

I also think it is a mistake for TDX to hold only one digest over a
large report that includes a measurement. That is going to be
difficult to use in the guest and requires transfering an unlocked
measurement to the guest which I really am really strongly against.

The other arches split the digests to cover SPDM defined objects
directly and you can transfer them out of the transcript from GHCI.

Jason
