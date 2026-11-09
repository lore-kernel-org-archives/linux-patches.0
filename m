Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.69
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794250526;
	b=FBtG+xzD9jKU//W0FWhsztzvoDxhzS3tS8P6FiaI+ObEJULzUvLZ9ptXZwF81jEeTCTY
	 MUOEGGPYgwfGmUaXX5c6lqxFxldHu71X9vb1V0gnb8rOjYJfboKNijWbRGHXO8ID2A+B+
	 jyOLhEZYgRP7aRipf/QXTf+baCkaH2kMrahTsb44fooEtKkuwDB2Yyu7ztYxWFaoADb1B
	 cZnJW7j9gD4xLBwTBGV1+BENHrY1Sy2bY0vS54I30agpBGBYkroKPO90Y7Jg1Nsmw68Uk
	 zMVfWP9GjvqX9MG48sFciqv0EtSxeK07IabRdrYycyR3Dn9vwelm6yZXUNVW9Ztq3sw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794250526;
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
	bh=1GRROsm66H9MFvfIUacigp1tqvhc2QapvtkGXBK0Btw=;
	b=UsqMnXcL195Zl7CcLcmsD2CDceYfYaSqWdQ/ezzKQ8VjamlXb/vREtcI3mAIKqwWk84G
	 +eg1wcyD7387lgSGyEmtMbPyMOahomkJRBW8sQ0sA2vOD5ZbRaDOlG2j0UsNaL/C9eEYD
	 gTeoWx3c3lU8GmSwqLp64KuhsrzgA7MdWYo87oC4GVG+e5t/BHWEuE73oyhZ1sSm2haJX
	 POBjZZkXtINEaF8D7rR+c5DNRMaclDu6x9sBBf6cUkby3FrTgsuZpTdWdQqkfwnOks1ld
	 iOwR1KdQsh/DfkzIAJCO0XbQDwUTz04+O36thoEpUAKxN6K8Z3OPadBKtYe6ZVxHP5Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qcmJjGNv;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.69
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013069.outbound.protection.outlook.com [40.93.196.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6861D606A321;
	Mon,  9 Nov 2026 18:55:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6861D606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qcmJjGNv
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KMOWHobKzZJfDI0JpjkdWun0lPloFMpFly+drHrBZ1OdeQZVBBdq+MeJxrVRaBSLnZj/6qXueBPR11Uo8seCXx4bxKmvTM6IPekWELjqJR7CzTDTwJJzA78G9YgJXtQMGjB75DgNccM24fkbfsKKbaF5jDT9PSCO9U97mnFwUvSOaQuR0PST/m39BYXqHaxWwXmwRZS4cMhOQsCEp2Nbcoit1Ckbz/rlmXvn5cRFU+N0T/1b2kN564g9SthQ1lpPe5iANFDBQpYJfKKNEt73jK6FEttn58HgCAB9V7p7ApRQ8dNm6jTNuCVYYW1TMehN0gOW7fWZpcz0cOPLgXru4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1GRROsm66H9MFvfIUacigp1tqvhc2QapvtkGXBK0Btw=;
 b=dmBhj3FgKDMHUSB7hdIGSKLWs+X9sTeW4DeAp0wbGm/AamZXVrLUgjgEwOvsjBr9MtlJIZwE7d7RSsqb7cmZD/97uHSv6El3h13siTNI/ddNuP6BgWy5xkDmw8DRg4nKIExczTyJakT2qmVuyLiz0sFJxJ5Z2eVON0yGd1pZw1EI/Gssv2CK5GBhJpf+r21zu71+JL8uXRN/cde9VFLZiyATqbl3LMdNbyU4OxAv8s76cjKJo9GxIrTfyhGawxF34SX6aRcymmMdX7wlFc6CtG6Tn1RcFx2SD8D8J2g56woPZCfu4i7Mo2aa0ELo3Da/Phizm53KUfXB8WulLZ2t8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1GRROsm66H9MFvfIUacigp1tqvhc2QapvtkGXBK0Btw=;
 b=qcmJjGNvEZm1XBjziub8Y2UL4KB+XY/JudToeyF9s4UQas6K3XwFzEOadZaLUB94V3rxOtRHWFTYF3VxSjKvjZQ9TNKen2CB0lwcF7spNNLXfC+h113xLKiYfa3ezLhDAWTYGFikaBVNjpUSApHFiOIFGOdLsPdv6sNjY1Jo4vEoP5TacQb7XY3ncij2kkYm6aiNsCmX93ZMqwhpmfepKee4gOu7zTartVK0d/nzVdshoSPpZI5m0LTevkZOX0tZAksuuLh76y4jjS1HQY24yM6K4AubXAeqTeh49jNZCOGMI+DioypRoXFlwsBs05kwTc4Nto0xo+s/Gmsfpiw3Ug==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CY5PR12MB6298.namprd12.prod.outlook.com
 (2603:10b6:930:21::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 18:53:17 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0592.012; Mon, 9 Nov 2026
 18:53:17 +0000
Date: Mon, 9 Nov 2026 14:53:15 -0400
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
Message-ID: <20261109185315.GS770409@nvidia.com>
References: <20261103151643.GI274202@nvidia.com>
 <aurmtTe4ObBQhC4S@yilunxu-OptiPlex-7050>
 <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com>
 <53bc57bf-1ee1-407a-b48b-bc6b2deee12a@intel.com>
 <20261108183337.GL770409@nvidia.com>
 <2b89b830-f1e4-4304-93ee-40287a4b5b2d@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b89b830-f1e4-4304-93ee-40287a4b5b2d@intel.com>
X-ClientProxiedBy: SA9PR13CA0049.namprd13.prod.outlook.com
 (2603:10b6:806:22::24) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CY5PR12MB6298:EE_
X-MS-Office365-Filtering-Correlation-Id: 99f7ba46-206e-4c4e-7118-08df3e92b76b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|18002099003|22082099003|6133799003|10067099003|11063799006|261009223027099003|261028144727099003|261026121527099003|261102123227099003|261022105027099003|56012099006|261022075727099003|261022115727099003|261021135927099003|261021121427099003|261026140227099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	EEGPQwODhJGYSlex192x1SLSo3QCxhw8/1VnvTQ9OL9CBcnBccEbV/Bhp7rsqn/sR4Y0owt0RzbkO+0Q8hVl2x6awfogVyG1Fy0H40WrVrJc5oagkxeuUBVzX0QD4q94EoSYboqgiI7OzQyWHXbVrD9adV3XYmwEp6FOWEX7N542RfJxaeggPS8wD9wmXiUdHb3LBNyTKH++UZ6lllipndDAcrQtDsMto/1pyXWJTnkg42gYbJVw1tqsbwHPZjDLzqewy5D2sd4R3444RohNS9OWvs4Btu1qsIMNeMDnB0YGxiGNelbeiBrw0ylGyQfF57zxQoMj5y3d68eJKKlk668LVj/PdcvtI+90rTnTBKTjSSvALIGkFDp9ys4fW/+pO5gO/8a9hgRQsNLEzyZnk5HvJ2ZMaRQFiheQWutk5uSttE5ItJH77LjHpIDZBtS8kWfwreZUXFXXHa3iojs7ENDO4x0FxkC3UgRWU+WBRbnG+f7XAjfud9SixSQqVWWe1CZNWku66/a6rcbQ5D+D1TLnE+leiJdOJ9lOAK7yQP5HZNZcdVo20ioIM2Hl6k+R+PICvfXdLocPW3zSg+A/O+qMylCZH1rRc9I2ELtRUhPKoLs+NJplJ1yxOS4QnjSbwYE4I9rYWChyUW/7Ef2opeuodrw6mL5tNn3IIT7uhWc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(18002099003)(22082099003)(6133799003)(10067099003)(11063799006)(261009223027099003)(261028144727099003)(261026121527099003)(261102123227099003)(261022105027099003)(56012099006)(261022075727099003)(261022115727099003)(261021135927099003)(261021121427099003)(261026140227099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CRAGfycTQLAqaETz9fA0l7duAJV2tGgM6aAoJOQhqhY248NcMwL7eZTtDcE5?=
 =?us-ascii?Q?ZoRGdPGs6eZszcbqwLxl0RQd3saplMwEkpXkRZCrgAgKjpTj8RuHcxDDhla8?=
 =?us-ascii?Q?9u82IKN/P0qbgleAVC7Okszy0tDU1TOWYymd2xZNJlz2e1qGz2QQceIMUCVc?=
 =?us-ascii?Q?2BYu0zXWnyqoHf3bLUg2rAkjklvXylFHNK5J9kn7O2Sm+CCSq2uypnJ0x6DZ?=
 =?us-ascii?Q?b+AxAkImlf8BW2K3zArYuaIBvnw2jrOYgvfdazM3CR1L9BxKhJDDm0vdoDZp?=
 =?us-ascii?Q?ga1mzViS9gL9NR7Ch2mtxwT1iObUrhCYWfNQHyU2mVJ9KDznDhiIaRqkZuFS?=
 =?us-ascii?Q?UGU5IcJQfSvcLn+WSww4MUGbKzZFIjdiRlT6hFIg5mcXg9Qg08hCMXT7IVQh?=
 =?us-ascii?Q?FnvdMSFXj5Nd/MJ/onRbZvoLM4hYFQMK8WNzHuEiWYgNUVEsFTXng8SrmI/Q?=
 =?us-ascii?Q?Ik0iRC7GvF5FNFALFnKupp8CgCKHhJQNgtQgTBjcXkAOv5Jkhfc7MfQPFnE4?=
 =?us-ascii?Q?zFF0TZV2BfuFrEf/ZErYS9jhQFR8fIa4nMca7TzPFgy0QqFVziJSIMpFxAYr?=
 =?us-ascii?Q?GmuXXOc+ozwC36vIZ+yjznRf0/2EYYjmQwkPrZPkboMWELnew1Ff/PIwOGfr?=
 =?us-ascii?Q?P5DSB/8yZhPO9Zw10jA1PURX1eQjal92OAu3ZgU5znOh98l6E7vm/0C4Rqog?=
 =?us-ascii?Q?yDPpMBDKL28KM8ezSNlOcKse5+d0OtDqj57oW4SEfPiGawTnNO35NlFpOKZr?=
 =?us-ascii?Q?zWoCX7pQS8cWYzLdxSjijMY8sbQ9qjJn55dKyq8D0MpoQ2dAXb9TYjRfvRaR?=
 =?us-ascii?Q?oi3m6Y7c+sgxplEfJ7iLYBg0Otg96waZUuj+Jl8KqQOX7zcXOS6Du4G1PufQ?=
 =?us-ascii?Q?keeVL0ERbEtUWdJyrHImvc8LpivrEoGr1SiA4NqouHHMkzASdYmDVD2J1Fp1?=
 =?us-ascii?Q?vWLC1NZ/OK/QvhN2GNOFGc15HkOnvgNul0O5kY7rT4zKNgisx/i3icSUZThz?=
 =?us-ascii?Q?TvFJo/j1H5Gnbx4BMcZgRY4ZzrRt2WMmKXElSQ6ZaJLFRke1NnN5/5G3Wz2h?=
 =?us-ascii?Q?T1qsylFae56jmYSnjVipf7w4ujkNYILRk9kTR3v8oEsw/TMiNUXVF2UStert?=
 =?us-ascii?Q?hY3c58iqxnQp6eyD6kFsDYuzouBCwQaruor7UqFUlyBvBBBCsf83fiPW/aSH?=
 =?us-ascii?Q?NfRqTOQrvR6hIc8PYnpcmkG0VWBgIJn+SRhu1AsUxfjxh1a7edlG9bjyu1kS?=
 =?us-ascii?Q?q6+xwCI0MuDN+MDmTVFi9eDVbPDbzgIZ8JDzg6NjOKVRIZD5nc0qpVzP0w+v?=
 =?us-ascii?Q?FgvBvGMCHpT8e2kDUAEUgo7rZKxxveDNVtU8jRfrQVUOMlIB5rhQbJ1urGxN?=
 =?us-ascii?Q?XuRIv/Cf0uSzaP2+sZnPMq0sq7TiakHfXZpPqhCdFMLtWbK0LZLPRq7UiYlI?=
 =?us-ascii?Q?lRoCkXnAH8iFhSRCUZQWxPG+ZRSdtbOEVs1VmhFYu7pjY8pexKPAt/4hF5rh?=
 =?us-ascii?Q?Aghoz63zurORQzFSBloMtYwT0ElzWzR9OPFdxZm7TDaQPYiygfTVRhNnYDI7?=
 =?us-ascii?Q?srYkP7THzS3vrQvvIzWbdAMU3Y5S4mNrwkqLMB54wXzi5y0bfOI9i08zdm9k?=
 =?us-ascii?Q?rbyWdoYw+0JvTp0ehOrH9J6QQLCAWUE2gVXmHlFSpgXUOXnQ65cGJu6lms73?=
 =?us-ascii?Q?zH07o27Q6wuCjo5smSYH6ZZ0cie51BjiSvvaJKkDhNW0mIXM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99f7ba46-206e-4c4e-7118-08df3e92b76b
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 18:53:17.4362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 834PK+AST8ovMOuM1D7QxVb61Qfigl4zwnZFjxqIbJOGRc+XS0lSRd6oi4wBcjXk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6298

On Mon, Nov 09, 2026 at 10:37:14AM -0700, Dave Jiang wrote:

> One thing on TDX is that TDH.SPDM.CONNECT also runs a
> GET_MEASUREMENTS of its own during the connect, and the kernel
> doesn't choose its nonce. The kernel wouldn't hand that one to
> userspace. Measurements only come out through the two flows, with a
> user nonce.

Why? Seems like another wasted operation..

> That works for TDX. tdx-host's relay is one function today. It takes
> the module's request from a page shared with the module and calls
> pci_tsm_doe_transfer(), so att_spdm_doe_exchange() drops in there.

Yeah, it looks like it works for everyone.

I sketched out this library, and it is basically half or more of the
in-kernel SPDM in just a different form. Basically all the reply
message processing and de-framing abstracted into something a little
different.

So in terms of *net* code needed it seems like very little

But it brings forward "rust spdm" or something in a new form as a
pre-condition to do the TSMs. Which is annoying for sure.

> I tried a quick version of the capture in a test hack with the TDX
> Module It rebuilt the VCA, slot 0's chain and
> KEY_EXCHANGE/KEY_EXCHANGE_RSP from the relayed messages, and the
> kernel's own check of the KEY_EXCHANGE_RSP signature passed. Agreed
> it's more of a debugging aid. Two things I encountered:

So you (AI'd?) something basic up to do the captures and showed that
indeed the right data comes through and the general notion is OK?

That's great, it matches what all the analysis points to. I could find
no blocking issue on this idea.

> - The DOE payloads carry dword padding, so the capture has to trim
>   each message to its SPDM length before hashing. KEY_EXCHANGE was
>   160 bytes as a DOE payload and 158 as an SPDM message.

Yeah, I couldn't belive it when my AI pointed to this. Nobody thought
to preserve an actual length so any SPDM over DOE implementation needs
to be very, very painfully calculate a length from the message content
and algorith negotiation.

My AI predicts 1000-2000 lines of code very careful spec derived code
just to remove this padding. Such a big spec mistake.

> - The chain hash in the KEY_EXCHANGE_RSP transcript is over the
>   whole SPDM chain structure (length, reserved, root hash,
>   certificates), not just the DER certificates. That's how the
>   device and the TDX Module compute it.

Definitely, it would need to capture the certificate stuff in just the
right way.

The optional chunking features are a bit tricky, but I don't think a
1.2 only implementation needs them. They seem necesary for future
post-quantum.

This also formalizes the version locking: the TSM FW cannot use a SPDM
version that the kernel does not understand. I think this was already
basically true, trying to do the 1.3 multi-slot flow is not going to
work out with out kernel support to move the additional data. Maybe
nobody noticed, but with this scheme it would be really formal.

In practice this means all the TSMs will need the kernel to tell it
what SPDM versions it can go up to.

So I'm a little bit stuck here. Some thoughts:

1) I think this removes alot of code from the TSM drivers. All this
   stuff they have to go back and get the data after the fact, or the
   thing that is almost like this in RMM, goes away. The TSM drivers
   are very slim, just run their communicate loops.
2) Clear uniform path to 1.3, stop after GET_DIGESTS, let userspace
   inspect the certificates, continue with the slot. Again drivers can
   be super simple, just need to pause at the right point in the
   sequence.
3) The data collected and presented to userspace is perfectly uniform
   governed only by the SPDM specification. There is a clear path to
   adopt newer versions in the kernel with in-kernel SPDM that
   instantly with nearly no-code works with all the TSM drivers.
4) This is about half of in-kernel SPDM, the receive buffer
   reassembly, certificate chain reassembly, x509, padding stripping.
   Each a complicated topic on its own. We always imagined having
   in-kernel SPDM, so I view this as effectively free code - contigent
   on organizing the in-kernel SPDM implementation in a properly
   modular way.
5) Without AI this looks actually fairly scary. I can see why people
   wanted to avoid it with different schemes to have the TSM do some
   of the work. Yet we planned to do it anyhow for in-kernel SPDM so..
6) With AI this is probably a weeks work I suppose to really expertly
   polish and make excellent tests.
7) There is clear overlap with Alistair's work, I don't have a sense
   right now how close some of the parts in that series are to fitting
   this shape.

I will look more closely at Alistair's series to see how close it is
already.

But, I am strongly tempted to make a draft placeholder in C with AI as
a way to get alignment and try it out. Something we can throw out if a
Rust version comes along.

Jason
