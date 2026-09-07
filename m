Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013045.outbound.protection.outlook.com [40.93.196.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FBA4F797B;
	Mon,  7 Sep 2026 15:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788793915; cv=fail; b=Jyd98pSQ7BqtG8b+7kt0vMhsqTbAwo51gqYj6a8CsHUQRk8OzjUF/c0ga+G7Y3QphAwVQ9niu7u205cPOqgj2YifbAQOT83AwNvKCDt7kl7sgPvH8lmI/yPqv03eLOD6i6NQKsmnFz8jEQ1gVTbFEjp9Rx3BwfGejyyoPhQA16s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788793915; c=relaxed/simple;
	bh=4v8FErJDxJuWWsggZgUQRQ/7FXgBaG5gpA57aCOjpLk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IZaGz0kmSJpEIOtDX/uasJs2t7DBz7kIV2PzWyBwkdJuG2MO+VfO0EOwu2SFqKYmxia/zij+TW3lhXUHUrXP99ediFNnsVFOlPp7zArbdVX89PCR7eQdPZDnGh0VYHym245fiJpZ7jsuwLJ5C3FBLkQJLAs9F3guL3hb9Z5L5NQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SmmoHXOt; arc=fail smtp.client-ip=40.93.196.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SmmoHXOt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IUDWsa5kRZ2gx2EYwQYYOS+Fv4z75MTZVkls31WFqxKukW9g8kjlN6fwMNBC3w032deM8Vn2ija6dtlSyeiA1FVW0e2NzbuIr1f35N4CiqoCE+9++NxIp8Q3mvfHaY5x4RCoYxmFt3JuPultXLecS25vF26uLTfxrypE8zvm+oWDXZ5vEWsKju04QU1JfEdc5W0fkVKFKsOfVsU9qkk8uj2pJXVndHYriYWOOY/wap1QfNp3eDnorSBPGQ+bzudbxpveBlzC46fEiJkrES0e8klGJvcZbLYLjDMjql/60BJFkCqfW0N/KGAJaP06NjHD7SE2jO/q6QjCw1ATZr32qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NovTYCRe5kJkTHgaQPZ/h4bNVe0PyLgbbblmELuQM8w=;
 b=WX1CZes7fmimCFpBru8EcxuGOgXH/W3i79IQ8HOc587JM5p4zdB0k8/9xTdu2/gVp3zInWaTrCHIzQG+z6qF54ELSXxO1wQ9nVsbOEiXQNa51Wdw8kbJQGCu/rU0edsRnfLpc6KNy8Un65qaWciUvCNdkZbcQgp/B0BZjX5bS3VeC/Zee6PRnjHAQ/e7rchzFTJXWv8FS7MXQBGzEhWIV51pVnlxf7ujLZgDJ+tYnvJ2FExC+wVadmSTjnY8qDmz/12j7cdzZqslyyPMtuFzLrKlzsseBn7Wlqsj6hiaSOIHrof5KBvBB18NzOWq5+9oRhkF8HaKb7eZoPozQW9wVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NovTYCRe5kJkTHgaQPZ/h4bNVe0PyLgbbblmELuQM8w=;
 b=SmmoHXOtrojhAtPWK1WSFRTOUfnRdZp2e4ZQSWAVsA+LxqhlBwQRStQuxemTrR8Vt47YRnWrwfMXex6GpJu0lguoUeibaqwu/NQEki7hd6ayJ3+Ch7nfYsHyNdSfnXXwtQLT+j3xoYAP41mkfI1b4ah/UwuycWINKZ49hQYQIb8QOt5OHJJId0yjLyDTURg8fMMjc/LlCEeL5glUlShhmN0qeAQ9f0b9rv2Td5mdKfnPjvOjVZfPUj8wImDop5RVL55hvNDwiuVjfVzECdgljuZEQvy4Xs1jUaXrxcVf0vtRIC4BMWcZJbxql3XIZD9LgeexuERNhxtOaW+hLpXRlg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH0PR12MB7789.namprd12.prod.outlook.com (2603:10b6:510:283::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 15:11:47 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 15:11:46 +0000
Date: Mon, 7 Sep 2026 12:11:45 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>, stable@vger.kernel.org,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: Re: [PATCH v5 1/9] iommu/arm-smmu-v3: Handle ARM erratum for CONT
 under invalidation with SVA
Message-ID: <20260907151145.GY4157646@nvidia.com>
References: <0-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
 <1-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
 <ap7IeAfVPZL3Hqt_@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ap7IeAfVPZL3Hqt_@google.com>
X-ClientProxiedBy: BL1PR13CA0071.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::16) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH0PR12MB7789:EE_
X-MS-Office365-Filtering-Correlation-Id: fa3fc598-cd11-4b1e-1e6e-08df0cf2551f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|7416014|10067099003|4143699003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	6gK6OKxYLnYp3cHuj6Sy2MB1P3TeH+3camS42sasrawaK0r1mIDRC0SHfwWZUEsIdH6nT6ibApVfyRirZhGZA/ewT3ACTFCB8TGHfURVL/VqW+tbbd4Rs+BbpbSWnC5/nLpDuJ8Ymi8CD4hWxzGMIBrFA7Ck0DRGpELaPohAJGHU5jKzrSjhQGSHXtTqgr8HBPLfajsuLMvwCrakIIovE/Jbfya3qyX9ECdOjnQlCwPXWOXziPZF6aoxtKPNnUGL7kusaxdzT7/PihMfs7IXMEgfc8/RF5zUInqWG3LGVdpVI6NuhOy/Mu7a3YiSbj0c5Pkse4HYJ01PljUS5Dv26S/V74Mu5dH0CS7LvHsrgfp/scNDEZTxz7KMo4QAyQSpyTtMEjiidcsi7ku4R+c+sHBuYDREqPqATcgjCmKMnyKEb5dsxqZnlSYZjrDClNmJ7oueEz7HRE91jZa/7PFaOx3kFkOuzBSwdp0gOfBGaEc/mx7gGlMd/2k9gUM06Xct4EBgUmAIG2OqYwFY2/MS7EKmbmQQ4hfC5hmzx84pIpYqRWPS57HIeTnwuGAmHh+Y/WXnUBJx700PZVFfB70YS1M+bulU6dcC/D1FOMZVDs+1h0yz3Qrz4vmWxqNCQLcQeG6Ip61kBrymje/GhhkvB0f6Ied15QMVQwPFM93uOm4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(7416014)(10067099003)(4143699003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gZ6IrDAtMY3FnbkmIFCdPr7KMWvP0cYpBXO0rX28fPn89V0Sj9xS8vzEfBs+?=
 =?us-ascii?Q?JdKZTzuLictWx18WvNXZoUoT4KqnjAGDW1DIFoz/w39zQWyk3lRqR45S6AWX?=
 =?us-ascii?Q?Cr5dMKX5meyxVlAzvt2RRaVY71zYFnRDLK1eYeYEVmUZwp94hDKUbdgU5Yir?=
 =?us-ascii?Q?NR+oP+UINsb3Bhtog89b22K+PdNBbVCZWbmvTVpf/pBgnQniTW0cnksBgD/H?=
 =?us-ascii?Q?V6qvQ9OYekE/P54rCgWw5pjEUYi3UO0/KEDaCt23PGP201qcEu4nsDjsn82D?=
 =?us-ascii?Q?crEy53AEguv+cl9m5KuAYautEWly33clPAcplccuQFS8wDCtFryH7ZkixOBz?=
 =?us-ascii?Q?Xw6hqwHkVO4yGQW0l5WlzFLmC4OoOgTU+4VcVHujfbXnz0C/Q1QgKR3PIoka?=
 =?us-ascii?Q?o1HYtqG1tzsdf+xocdihz0ETjm5Jim4NGDJBaFfKhPINS178zmkGn8rctpid?=
 =?us-ascii?Q?Mz8Fig0AuYXiRdCbr0PUZQlA9yFMJ5nJCnvrAlij7bfpFNXHSB1TbaxGaY/g?=
 =?us-ascii?Q?piJW9I3MQGh+ZCuV7nNfKUKl0XFxCtSm4RSRXofsM/d6JU5epw93LplUElzO?=
 =?us-ascii?Q?z0KglWw2t/su7+6Tqd066Nfs+UMBC6/40+r7en3YcDVXdGUCAkklTEPr9BTV?=
 =?us-ascii?Q?3XTp7PCUeEvM4c3w5EcTE9p6gpagQJfSIrcL8qPyELzz4sotwgm5vtjCvM3U?=
 =?us-ascii?Q?gHS7wasz3Vh2m29mjKHBuE3J05EC8A+z1h4B+fkyjkBOH+S3FWOtIQ5yLogQ?=
 =?us-ascii?Q?uJqq3wA6t2OWGdNSx6PUVXTagueWd+6s7BT8g9zxNESrl2xak/eGHlS8Ys+U?=
 =?us-ascii?Q?ffrETN9O5RwVhi+T2BoYEQGS4z87Anf3JYhnt2nhAJsRd0hgkIxdGI1z/8n2?=
 =?us-ascii?Q?wQ8PHegyVxRl5bitaltIElD1kAI8oCfUBsfoMn4zhv+2yRDAJdNm0lzXoMd7?=
 =?us-ascii?Q?jbqdepO2Q0WkNVyxRytvzp0B1zSc3svpvqV4BuLrn3LeTUdQHeDI62Eh4Mbu?=
 =?us-ascii?Q?SCvG7ZUKA+pQr5cxjV8UsyNgraf6fxuVnfB++KR+K+094dHDD8ujIg1yQ+eT?=
 =?us-ascii?Q?bcEUfcsN6g4efu51nIuvfbvjIlQ10OmeMsoK4ibltkonLTcUzawnDD1EnJIS?=
 =?us-ascii?Q?dbUjvPELH3+X/rr9OzbW36W6d8OPvhEmlABK5c1h2zGf0gtislbhyR0ix/UP?=
 =?us-ascii?Q?VAgCf3u06QJqwq4LfsYSbWuHB0Yj/n1NzcxHnEShPSo7rjLQXfuzn9N2Kak7?=
 =?us-ascii?Q?ZXPSK+6re65yWDZLqnH6VP9a0IaEn6C07PzR62DXK2abKFbZisPgE3Y0KRtf?=
 =?us-ascii?Q?NsXb+QQTKQN5aqufhidmNli0HVaOevJ8pJFJOmI+xDKJFxZldsB3zOX6SbvP?=
 =?us-ascii?Q?BPCcyM2FlDMFe10YC+/Ys3C6DJH7q4KiT4igi6Gu459THue0eNqCSS43oIUe?=
 =?us-ascii?Q?YJ7vnDcYzb4dD5J34OqaPDCM2nMlWn/vxqPs+tSFqGg0CwDJcaWonaxkN1VP?=
 =?us-ascii?Q?bBT1xqaK93znxLTXm64bRqXvPvXvuP3qurMTwTRmj7PUDYCRya2RyFCsX2CM?=
 =?us-ascii?Q?zGimh3mPcCeosqUnDjwCNjBUSXiBTbAkr3QqE/msFIboMLePUkPZY1eVF6+k?=
 =?us-ascii?Q?mLPRc3BpWBSQqpvIQeE+fGTDt2HJ4CxwkezztceH0JxeUurXdCPDFpOyG1yA?=
 =?us-ascii?Q?Dlk+Tik7lE7+IV/3WOMYLqTvJm5LGGmxVHeJlVradSy/Twov?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa3fc598-cd11-4b1e-1e6e-08df0cf2551f
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 15:11:46.1014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mJf+GAIurXYFYLOKGZYDhEs28ITyAbqI6E0QcONTzKS4O9UMPG14tdtksMzL1pCw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7789

On Mon, Sep 07, 2026 at 02:21:44PM +0000, Mostafa Saleh wrote:
> > +static bool arm_smmu_cmdq_batch_add_ril(struct arm_smmu_device *smmu,
> > +					struct arm_smmu_cmdq_batch *cmds,
> > +					struct arm_smmu_cmd *cmd,
> > +					unsigned long iova, size_t size,
> > +					u8 tgsz_lg2)
> > +{
> > +	u64 cur_tg = iova >> tgsz_lg2;
> 
> Nit: tg suffix is a bit confusing, I guess pfn is more accurate, but
> no strong opinion.

I don't want to use pfn in any of this code because convention has PFN
as PAGE_SIZE, while this is a "translation granule", ie the base
granule size of the iommu domain. Which are not always the same thing..

Jason
