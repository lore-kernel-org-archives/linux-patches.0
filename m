Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.68
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793720392;
	b=DRRQJXngBTYIW2435df+pd9RRVsocxs9lmjP0gc55x5xo6JHBLgVc2x8eqz8c/vZmjnK
	 T8xMtiXrbp7RO7E/6rQUfrCzBJSYmqY+gdz6Pnzz+ZJU2MmwoIg8Dx8keNX48G3rTyUIc
	 c7Ru0X+8NfrSGAZsM4ys6TY/zkWNZH0TagOuCjRxqhm28c5fc/GLBnozV6SPbNmfsf1sK
	 JT/LkhZU6Ec5HrX6pxGvZVMKlqSNIqk4+EgTHwV9ZVkln89Tw/oLFNDBMFXMdN0kSM1HQ
	 4S3iPxaDlL6Siq8+d/AYhQ/9ky0/LQeUP+1RET8LITd/63J8Tx0Lbb3VWj65LBLg4jQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793720392;
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
	bh=12qUVNixKCluRlJXpbkfyt021PP1vseQwrWfEsaYAII=;
	b=Wqazc82Z0F80KUHfV2aPIvyC8bWqLRjg/3wYRtUe6yK7H7EgrODgVdys1w6JZTiA+DhG
	 pghbaDubPwwYtheNvnpURMAs8qApj/vS3yALUJl3rl14HqML+O1JFERmz6YTEGi5z+2xu
	 FpeWbcGc5tIJ4uvQqH9pxTmMLOstw3IuBEPN6o2ttdgTYhQoxZ7XO2hG0Pv4X+wASJums
	 R6Dx2XENTlqQWWPE9ho31PKpi/eGKpt0mZMDxP5/OcV2z+8zuCL1Awm7yx8V8Vl7Pd4Ok
	 jIqIUccUvYsj0pDM6XX+WkdgmJZymhRIWdKaBw9eRMZ0ACfnoa6YVMFo4h/36CBvcig==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=TmFFGsVu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.68
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010068.outbound.protection.outlook.com [52.101.201.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786E1606A337;
	Tue,  3 Nov 2026 15:39:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 786E1606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=TmFFGsVu
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OI4AGwOC8UstBbEGKiWs87edRLJ2Jy1fpYQ3yy3Ul+PvGU/4ZM8ONc6yiSzworzPtqx3yTIcDfja+lDEoYpogdGZEDF9dtLoxeOlIVDAx9NJJRd7i9d/m6yx3oGIXwL6AGd1BAqlwZvbH4MQfsK0eHItZEraxZGQCRlLTD+6Ml2zRB2K24G2MrTExYIVAcfh+m6yJkjcAtXkpRgEYw7E3jQ6Gwe6y1lgvRPomhEgd7YS5jRIVvvGl9x2nSiz9NfXkeMSHXOzDhZOp6EXbg5qSB/eYT7kbYFp5TjGkQBtIiJ/zPT+DZGA2FgxFLL+V8nTLrZ4RyMgJNZE7bw0plpL4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=12qUVNixKCluRlJXpbkfyt021PP1vseQwrWfEsaYAII=;
 b=XqSz1Uau71aaZcecvUTJuRGrjCplkq3MvStxfkeMNLNWnrFlnuUJvesL9AI2S+WukTnxZOOlVOgM/ZDMeBxojHLHjP73ALCUiY2KQl1V6lmJr04bf9bFGMsBdOX1gXVwpNBEx5BVhSsRnTjsRWD3y4qewOu/SxHelJ+U7gwDArzbTkQ5Wp11Ox7f7TsTqOaWcA727c4xkxPkAdPakOFclpCnY5sggUg80srKiJ7exTFszBQL4MPT0GhGlH3JNjSjHaxoIpurg4yZrzEVfViT1907bbCv8hf6VkGFnK9jqxFv5rLNI3/04cj2VXqat1XdNzWLfTELmhIc9HtQBjfdLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=12qUVNixKCluRlJXpbkfyt021PP1vseQwrWfEsaYAII=;
 b=TmFFGsVujX6t27FhxCmzQLs6F4OueWKfYAiiaTZXTttD+VVcmEWZr79jyTUE9rFPy+tXQjX89jRWUHh1tVXBh9xsb00Sdp8GNh5vH8K/xpbJDYADi/cS7HI2/CKvH9xe/sddHfLHSgzMqia7Y8o8A+4qPDkVEuI9mvEjiepkPEZgSS8K8wGWFF4oFVIFNYm+sCBORNlQoD/BpzjzMliXRTgL/vsFaUH3lF4M7zgkR/5Ar/likRSwaMcY9eNB7uU5s5aKp3IJuidmjXOKZH+nlJ4ObW0M8tj6Ml16VPrTt/cAmAggaKn5YiwU3cy6YG4/pFFqrqU+DitwXkJ/3WJ5nQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH8PR12MB8608.namprd12.prod.outlook.com
 (2603:10b6:510:1bc::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 15:39:48 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 15:39:48 +0000
Date: Tue, 3 Nov 2026 11:39:46 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Jiri Pirko <jiri@resnulli.us>, linux-coco@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
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
Message-ID: <20261103153946.GK274202@nvidia.com>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-7-aneesh.kumar@kernel.org>
 <auShvL2m00S70H3d@FV6GYCPJ69>
 <yq5ah5i2a487.fsf@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5ah5i2a487.fsf@kernel.org>
X-ClientProxiedBy: YT4P288CA0052.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d2::7) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH8PR12MB8608:EE_
X-MS-Office365-Filtering-Correlation-Id: 11fb8e25-a15d-4ab7-1947-08df39c0b110
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|10067099003|22082099003|18002099003|56012099006|11063799006|4143699003|261022075727099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	u+8ZlRjFRacE3+VpkVOAT3UZmaul+NwkDdrdVwqoob4hHRbq+aMDUyXF7tLYjil0nkLRnUfQ8rfHCYGGfCYGwfegOQINL3Z//v+/ihq5Qp6zD/iUqaQ0rvr+sWyNrS83a4e17qavUzAtLRRQzt8n7m41t+Z8alOlPW8NWM7eMHA6U3cdlJITpCKMUPJBOyp7YsKMvT7X7xLpecRB/MJt7V4nM2/EMIb33BmtEuWyua83l/qpetgkNe7QXFHwERk4313ihYzUzbwcLPGhUqtdsZ0gE2M9q4uuaXVTAG9ZZFIP6a7wjUoT+n1jEq/IBLwCIK9N8Tl8lvkXI2Ti/AzxKWC3gzLtkbbG07lo8kkKRXK4CgP6hDa6wE1uUsUAdwfEqU++bXNyc0v/OD+MR6vFDdvfipMP0bjaDnCOAVR4W3YwcJfaxoCk1t2ELJAxLgIdRiPRl1fIfCh7L97z1Kfy5bZTr0AjpCt6hTUJ2MUP6nPiezjLVtyXA5iShrJvVAbPvogKYHhMqOceIbBy1yvaFsMdiGYSSr+IfA94fV93eli1spHHgmhl2lue2HtEhnaqu6a1N4T83YhiwrcMzhNmSf0qu3NgGaYOiYifxhjSdE25uSXcQlJbRZ4crswv/zeHMw8V893KJ8R9cL0YpMUaDOeNT+TVvEmHtQvlPaS/J3s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(10067099003)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003)(261022075727099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qzl3y5nO48yiEjUjdXLHDdlVuGzfedTzXjGQxTZg3CpRr1pYNFabvd9d16mc?=
 =?us-ascii?Q?XN1r7RMBP/hmIuMejacWRI+HqXKKT5aSA81rjpFz3encSzwaYmbVaOw7ylN8?=
 =?us-ascii?Q?DjA425lw3y176Wpbqgaa7fKdmz6O37yGNzV2k4jpdOzyjxnSXe0ttO3hCcVt?=
 =?us-ascii?Q?t5hGA/jM30YoVTsfrA0rop/LlCPj7dkWYrcl+mBoah91koa1qn0cVN2HRU5f?=
 =?us-ascii?Q?ZVatMKhEYICz6wrF227Y45eU+vavA2l+WlDsj2fUcMB9x0neBwHe1HKTzvHx?=
 =?us-ascii?Q?UHBe00FzVFRy6cbAkw0920C1d70sJrhSeRx4dGkajAF6Jh9hxbZOx7Ngu3Hp?=
 =?us-ascii?Q?N9sF5bMsyyCbqPP+7i1KZqI5yq+pjxKZ4jhomjSgBCiF0duywXwBAbhYmmPe?=
 =?us-ascii?Q?CZjQySZeuejA9jOpa2rKnlm56bTKlXHmUrlqQ1jWem/pB0uDvA22OtX5qrl+?=
 =?us-ascii?Q?RQ6XidlCuOrcw3UnQvIFlBNsRgrj2x6GAIa7LSHFgzL8+UM1Jr/CWlGEs0eR?=
 =?us-ascii?Q?iTtsoelPodb8F32OnFXIkSKqmWEzCQxuxzfM3Thg/YOOJByLK/WpBn1BGm/p?=
 =?us-ascii?Q?+tJwUzCw19s+ZdMO4a04vGMZ68McWXW6/z57y3tilHmVEeugUXn+sBrauOFA?=
 =?us-ascii?Q?t401WPoZYneiW+1GcYwetKeTTR/nkopPcHKlXJ+7mHCwtnUdVVP9ko5pw+44?=
 =?us-ascii?Q?M6ntMqJXgzGXCjkPOJa9uqNeF6Nkb+XYotIVV1EaxCCP3IoKEO9ON7K/o9lA?=
 =?us-ascii?Q?FxURdXjRPe+ecb6n++b3LfiUrMP5eh9JvuwFQIzmPFj7hbT/PVVcHkaXiah2?=
 =?us-ascii?Q?MgSMfQZczcxmYk3Vg8FEe5HcXUnDTVgNwgdRLk4OUBhN/JRE/qJysvN0ZL9b?=
 =?us-ascii?Q?tkFZ0aM5cA6D4zzBYYeeM51vaKO2UEdiPrrkmVOPs/emK705jRqXxxRv6wM6?=
 =?us-ascii?Q?vE1Y8EjY4iNSXQ8Npr+VhBsRx+1j0vSf1e9CaOdGMGHtKFEhkVIZpoDV2xbY?=
 =?us-ascii?Q?vqKbZftd73c0/gz/TW3qZYRX1UFRNCLGH1YqPsXqaPplKQz6YdXkqehdxWhd?=
 =?us-ascii?Q?u48Atw8PgNZcY5YF0Vwh32jreEvGOQsI666kg5htS30KA7DHiDtzoeVBUrL7?=
 =?us-ascii?Q?LGE3PjKA5wX8S3SQVj75iRufyPmk4L3yVOw9c9A1Lf0O7cNyTq1Cj9LapMpj?=
 =?us-ascii?Q?yVHssZui/0zPTv9/Yg6ZJbY2JcJp+5sbd5nlyqthOLuhYFAdZNNs89z9qClj?=
 =?us-ascii?Q?5fGGEPqQtxRTIiJQxSktDcAQXr8ws9lzlMShRraDlEW8QIe1T3cHNWBItf4V?=
 =?us-ascii?Q?Gj8Jqlp4mjFciGD7zJ02oYK85Z+OmgiSHLBPHspZmyK7d/l+LEMn4+Qf79US?=
 =?us-ascii?Q?eqj8tU8PeGASV6WK1FiKlgVYa4hjdzbPoBY9cswllBJy/407h8frhDBhMWjQ?=
 =?us-ascii?Q?9XnOwSmyWIZsKD02rZWdNGgCGSINHe2IH+SZWPqtY+Rg3eUO/JekjwVrjzZL?=
 =?us-ascii?Q?lbnb0j+frrLrNo7a71oZl8CtVV5N5o5uYv9z+3oSFD4PJV/80rmHfrfvU1Le?=
 =?us-ascii?Q?bCeHYHsxKXqIPMbTIctWmI0ICVPDtv12XESMhg0tKScvWbiYc/UI3CESUEeS?=
 =?us-ascii?Q?hAqQo4QL+Mr3wmxAoYPMrIqvv4lLVMVAY3PVqwtPDNBJu48i6o321NXXZ+KX?=
 =?us-ascii?Q?RJid2ta1XpOvTZtBQidppgGFs/HCDfgN82Fn5zT2uW/ZZ7x0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11fb8e25-a15d-4ab7-1947-08df39c0b110
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 15:39:48.0752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kyksw0atOmNqECPDBmDEQ7vooy9YH/w7wDsQ6Gm71tWuSnM3wNnvz4TeUHxuS+8k
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8608

On Sat, Oct 31, 2026 at 09:52:48AM +0530, Aneesh Kumar K.V wrote:

> I was considering evidence-get to return the evidence generated by
> evidence-refresh. Without an explicit refresh, evidence-get would return
> the previously fetched evidence. There is no particular reason for this
> two-step approach; evidence-get could always fetch fresh evidence,
> making evidence-refresh redundant.

I would strongly prefer we have two things:

1) Immutable 'transcript' data that reflects the SPDM startup
   sequence. This is not "cache" because there is no refresh and no
   eviction.

2) Fresh collection that that kernel does not store. This requires a
   single shot IOCTL to transfer unsized data to userspace. We cannot
   double a collection without breaking the sequence numbers RMM
   keeps.

I think the TSM cached/refresh/get scheme is a work around for #2, I'm
hoping CTLV can solve it directly somehow :)

Jiri had a sketch to return data into a memfd, that's an appealing
thought, if we can provide a memfd for all the unsized fresh evidence
then kernel can just fill with with whatever size it has, never an
issue.

Jason
