Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012023.outbound.protection.outlook.com [52.101.43.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F88246C855;
	Fri, 14 Aug 2026 12:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786710865; cv=fail; b=idmzD6xzeKuqAFBQg/7R5zOa37st/V2YTCWJTEFXhL13lpeL/hC5W60QlTyTA9yv1Be0QI+H2sz0/Qkcj5Kk2BEZLRheqPX9Pywf/tIPRgay9QfWMORtT9HAHU3GqHfFscxIs8S2A1yztjL2XYK8FuqPEvoQaPgbu67PaIJRTAg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786710865; c=relaxed/simple;
	bh=eOzQLRDABbRPGWO2eocrF9OWTRr6R60qndEcllnvbJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kZezan+AiqC7Gr4BwYo32KOnyF5Alk6WNBBBctSUMZ4tH7/6UKpFYrfPCMYUc6n+NTnxN5NHiAFtj7WQarrtPD724asiZuz27kzpwSgSJsBM4BdFnf2aJB3yJzQ/ugVQKeuywtgkqXZIL1JrTruNgh3cMMz0hsiKnnF0NHYYH5s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=j8DxAdhF; arc=fail smtp.client-ip=52.101.43.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="j8DxAdhF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IzKxpD1A2om4l8IqsFFD3X5xBae/BMBi/rdbP1HJA7Bb99BxisNSQhZQDFwGkWC8Sy9VPspmprL6+yJxND9SsX+UmyIC6kvumkYEL1V+BKpHoBe+9ITClAyTqMw/3yGBQ1U6VxOkR9A4kydtiRZiOKJ8omZ4rpJAF4qeMzI0ar2As7irJhDre53NIexrlpJnfMbjl9e0FuAZsUOjV4dSvF84Rohue0bt97QL/dguLq04YUukzywy9RR5oE8XDOKvzMgdH0BoR1vOsVigFnijC0OtQcl2PoPZj7ibpcJzRn5c5vskWUh8uFHD7NoQd1ZsFwDBaXcCAeoB6B/CJ25Wsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xSjKu0tZim2N+2GIaQI772fd6wGj2gCouyn9Jr5PcCU=;
 b=FwbFdNRlAYJ7h9Fg002pyFpKKTFeHY6keARzt0iW0Xf2TFHmYftff2H+EFcZX3tsk3gOzHE/yOMzhrfU3T6nfbYr3sBaQNVTPG9GzAEYJxCMxISpHrqNnCdN9AVdV6EDaIr7xnJMJ0fsbW7sBLgavDYBlX2KnW3SNTJKL/imTFxZwvnJcENbmknotYvLp/f2a76pC3J7dMAH7DUGzSXR7pIfsUvwN4Fa9INOtCCMl8h4KoVQqaC5logzU9bLfMI9rq+NRjFTH283tlXK84ecjFjiyJut7TS4RopUCXQpE/Kr9qJudDWlsCLAUHnj4fSln9NmI7na9EObpK39Sg+AEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xSjKu0tZim2N+2GIaQI772fd6wGj2gCouyn9Jr5PcCU=;
 b=j8DxAdhFr2pgciIkZHmj25T7ZJ3Oh/7yH+n/WwkaMOg8WTzoFPg5lN51f5006rlrFyECHSiKf3E6bNoEjyYl+XPl6Yacx1dyhGgPz8KpFuetaGNQxuqL9XN0pB052rxNh4zLtgQHg7ENjAsZKVZlMFkiePsb0wx1kdDh7J56JRCVN1IfrEMQDHMTcO7RjD9c7NaCIrKxjJ1YhiChoYcp6x/E6eS07bOljkCKtICvY5mp/6KUu44ynMs3iO72iD4JXwmt4EroL1QQHLeqlz2FHxOeUisIK7TQgPU/zu4DGMPwEhDilD83MN8ztvOzxmqD9AVhHEDp11P0mZ0+N64IhQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB7115.namprd12.prod.outlook.com (2603:10b6:510:1ee::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.13; Fri, 14 Aug
 2026 12:34:19 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.014; Fri, 14 Aug 2026
 12:34:18 +0000
Date: Fri, 14 Aug 2026 09:34:17 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>,
	Mostafa Saleh <smostafa@google.com>, iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH v2 3/8] iommu/arm-smmu-v3: Optimize range invalidation
 for latency
Message-ID: <20260814123417.GB510472@nvidia.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <3-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <akzm5BoV0rToJ7ij@google.com>
 <20260708001058.GA422027@nvidia.com>
 <an3MSKEj7VhT4WkP@google.com>
 <20260813141320.GF730363@nvidia.com>
 <an3ew9xbnLe1dr5g@google.com>
 <1791d7da-ecd9-4475-8f27-c8857477b442@arm.com>
 <20260813180102.GH730363@nvidia.com>
 <an7UNAA1WlEXG23-@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an7UNAA1WlEXG23-@willie-the-truck>
X-ClientProxiedBy: MN0PR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:208:52f::32) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH7PR12MB7115:EE_
X-MS-Office365-Filtering-Correlation-Id: 113d4640-44f9-49ed-4253-08defa005c11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|56012099006|22082099003|18002099003|4143699003|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	fuSzhryuyh45v/Ti+6xx+7SP3c5fLxwWySHLIHY7ykp413hm4Gv5hJ5yq/zMPtO5Ol0lVMrhf+Fc8O37avlea33LeOxLO4UAAMfyfPFTKXRojYJEhS2wLQxMAg2dR5/SMaKjB6U28hZO6N6iao4qh+GRss+jFYgDlVCiJr1kTKoI04V73YFhfIHAN3Ccej4MJhTdaFTU1Yte/nSQ6PkN/IgiocMmXXsQSbGdhEfpI6Jz2J2NaQYMfruMqb3kPIMEmGazla8xEygrRjy2ICboV8xt/f8nkr6tUMdqnE0ewGRQBgF5T8xdWQCAre5dJU2qF38ysqz2/lAW9SZdzPFEg3ypk1Nqu4XTsNYaBh2sGCPVieXzI1ZGCgCMMODQeiIF7eVt6NVXrGK14qxEbWA9zzPrRIC6z87P+SkNHb5UvQE/alaKmBy+Pz2ZgqNGqUngiQTiE168aVKwuB4h1KLPc2qhgK3qt68Q3JTpLK98vACUM6qafbvxR1Vmc7eV6YCiQW4GnhvMh0hjZm0JrKPLHF/C90u4vFe7pqo8fLftnYwWngEh0b3/EuvvfroxfaHoJ2Taa97nJfOaz7CSo7A4XUwtYeVI6/B5KktenOHNgXsAXp5+ZXNyUOW8JpUsR41ApoCopFd+dSbaLa8p+KuHlXLIUrPyHzICtNB8esjI1tk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(56012099006)(22082099003)(18002099003)(4143699003)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tysjeNRnEh+37l/CGO7Zff28GaF79zwEj/ddjahWVLFRx0DSMYBfvWwzHGWq?=
 =?us-ascii?Q?4+o8QrXT0nsjuiTEowxQY0J2PvVWOleAHzVH1Dz+/6QNoIOFKbfgHKChoL8K?=
 =?us-ascii?Q?g4HkNefSenX/60vFNt50lbth0OhU3h8H6qS75x7fc1yaQR7T+Hmx1AyS9H1L?=
 =?us-ascii?Q?Pm5k56bToB24+PeyXiJxmSmXOxQIBWrJN/MfFe6WZ2lWPbfdfiYuSpU/JWTS?=
 =?us-ascii?Q?h6Eh2w225Jx+odKWZSi6GDgqH2a2qJMMwZpwbelPtJeTu0qccdVyi01e/eV6?=
 =?us-ascii?Q?qTyHWFfXaOK+/AuhntzJ6NRIDM2zUBHxLeshOUlFtNl+nCrx6jFUe1tZg2BG?=
 =?us-ascii?Q?vGpFnWJ84jOIJboapf0QOvVq2BOfirCxTFaFgn6Cr2X9UJQYJ3cmekVUpyqH?=
 =?us-ascii?Q?6/dZXV/iy2B6NgmUPv9YeptDH0c8HFHa7VcMRJ3qBBfbhYjiS81NeLluR9xU?=
 =?us-ascii?Q?0U6YZ8L5Ao9ZC0K7LSmarivMg7hl/MhU/ssP6HId6nmqlm0mcP028osa8jm3?=
 =?us-ascii?Q?44i+eX+FEjNV1xgVQ5SbMf20T06n1t4KYzw+6xdbtS+ZJTppgSZ6/fjK1PVh?=
 =?us-ascii?Q?rau8lX8L1RjGt3Jpew8wAPQWE9WzDuFSo1+3H6+KlZUrhG7Fazn7fhPyiCIj?=
 =?us-ascii?Q?KfBjNUFTjEGMeFb4WVHjtMyyCuO5F3nYZvDGRVRx4MLlHui+FrNpjzvDkvbA?=
 =?us-ascii?Q?Jg5AiHkRqxCojT2xsl2sDkWr0LTxgh6/kHUgVwPLosqrtGJ4Io3qAwpZobl+?=
 =?us-ascii?Q?KvRRpPRxP7TWkX1iJn644PruZIyIVqlDoyRJ0iVkiMD1rc8FvcS1MtzCzhjs?=
 =?us-ascii?Q?YLiNQrNXTh/YqtK+qbZxnT5OWydTa3EpIAF7ySQaaQfOnmxKZzvfZr19rkeV?=
 =?us-ascii?Q?yw853fpJV23Zqp9VUmYWvshbCk7PnMbv+gkP9J8Stp3lZV/q3cIdJTLiyIuf?=
 =?us-ascii?Q?Z44T8Wk05EFBCrB88/9dig9yFAz4QI3AVT8+gXmrfXcxCLnOtlXa0RIf5js5?=
 =?us-ascii?Q?tMimxpFoVKN0JPlZbdhUAcv2jhp0DL88wlo87esZFjoTei8C9ZwqhoLNIb4E?=
 =?us-ascii?Q?DRGAHbDw4Xmez1fqMovzdFUmr3Dg5XYgb4idl2UW6HrBW+oLK7lTNSPLs1wO?=
 =?us-ascii?Q?qE5i07gtYffPOHBJVWw3pPBx+J4ZyYmvT1E3zA59P4lCQJzUsV4Gl7WzkWcY?=
 =?us-ascii?Q?bVT3r5YVOBQZl8uougzPPr+17JzPDKpo6q543x4RDWGUYF4cJc56yp/Os4ta?=
 =?us-ascii?Q?Dk8l8J2eyPEgEvOxbFlL1Ds0NAp8Il5TffIs4yV6mqefpYFFnxFxUfT3w3S/?=
 =?us-ascii?Q?dzubi8u6+/5zOCRqxIRPt9THDPWec8nIa7UgoGIXBNRqJsMi4F+mas/acafO?=
 =?us-ascii?Q?ibvMht0aO9MefG8jmH+osPnLKJiJJsDwNcBrJOGk5ttrT5IckX/w8kxxe+Lq?=
 =?us-ascii?Q?18e9+/CyROq3QYV5DQMkJjLIvhrvHHXYdMRRYfY1yXEIRS6j0hcSJQpaxbmP?=
 =?us-ascii?Q?LtJ0OaSmSmIkxxaCFVk35/GimQBXdZ2mNyFR6+P6d2yIoG/QqiJLBvw3wv0M?=
 =?us-ascii?Q?B3YT0K1F0V3ihxPP5YJTydtMRp2Ed3hMFqgmTz+5nbuFPGC4yP3GbThFibRf?=
 =?us-ascii?Q?+ShBlNjdjqA2ZhOipfmbjG5VXgN5rjx9vYMmK4gDBdrXpnwcUDC5hJqo+sQd?=
 =?us-ascii?Q?bKBYvQr+dTDErdBsN7hQMkyi1k7k1IUf44CuVSut2KtH7if6oJd7vT9QaiV2?=
 =?us-ascii?Q?8u47BrtOJg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 113d4640-44f9-49ed-4253-08defa005c11
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2026 12:34:18.7833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b3HZWRfhhbEDytInwYSZ5lYWDh1VLsKAcIJ22g+4WAZrJ4f/00aVddjpMK+Gu6C7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7115

On Fri, Aug 14, 2026 at 09:39:16AM +0100, Will Deacon wrote:

> > Let me try it, it seems like it would make everyone happy.
> 
> I was planning to reply yesterday saying something like "Robin previously
> mentioned this one neat trick...", but I didn't get round to it. So yeah,
> if we can implement that, I think we can have one range invalidation
> algorithm to rule them all.

I'm working through it and unfortunately it brings back the CONT
errata issue. This version nicely solves that errata because there is
one RIL that always spans any CONT group.

When we have two RIL it becomes problematic as we can no longer
guarentee that a single RIL fully spans an entire CONT.

I'm also wondering if we are even OK with this errata today? The
current RIL algorithm also does not guarentee the split up RILs will
cover every CONT. This will happen to be true if the input range has
certain properties but I have no idea if the SVA path or even the
proposed CONT iopgtable change guarentees that.

Certainly iommupt will not.

So, if we disable CONT and SVA if this errata is present would anyone
object?

Jason

