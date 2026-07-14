Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012046.outbound.protection.outlook.com [52.101.48.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCB4377A9F;
	Tue, 14 Jul 2026 18:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784054509; cv=fail; b=fSC41e5t+2mqCSdHFDmIhX91w/IHFRvGzx3aqsLK0uRXM9N4+BzLT+mpfTedRGpDU9QEKJ4585+HdEqzMgxHyJuSA9UYOtU3U1epdON3H446pjdka0rafyqo0zVnRSIj4WzYAaJozlZA7/is2ZD/iXQ0EOwE6yBwb/mhA7y3ZPU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784054509; c=relaxed/simple;
	bh=qR7FLjKd7kwmOA2iTzIqA7ir/ptalznNKRbEz24l4tg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KnK7JJhBtxex6f6f1ZQG0prOuNEOGpmyE766rJT6vUS5WDcy2uYdNE4e8hK0F6uK6z7j8l3hz4Dca3gxkmkQp2RlSIFNrNyJVfg8gLAW+qkbaA164/BVqu6dpHreMMygja9Jr90mLXvZMtxU8tw/ntV88oRxYNpmJYd9C7b4ZeQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NeA7DqFb; arc=fail smtp.client-ip=52.101.48.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NeA7DqFb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wEuIYqc0bWpvl6syfRElPG6Aj99H6oAOf6GpsjH7CfU4qh19tsohCCFhmUTPrZxcJiFGqYPH3jzU1gOeEPIuEjAHKyUTbeweUD7ISuDEVTRu7xKDUiWeZ6+E6K1u9mLXlqla9ZRiNVD5WSSCwgRHTaBIQgaQowqbuejji17aiab4dyJuQK5VTyWUsNlJBMCKYDa8yBMMqCRU8LehGftc4HfG5VI5ztrCd/UDcUtVpcIgcrN4bmWYZBVyXRKWxHxmofEIwcINm8HvV4zP4TFfTkjRCBBd6tvNjHwwpcUQ+TDMP9T9g7tV63cF8xb02x1thSr0B365YwL2LeiHhDliJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kyKpYWck3zmqwg+nyC5UHfrN45kAGNxzHQXPYTkyVG8=;
 b=szw097Mdj1VJTsaK5wj8/Jj87BG2xl0IiQrrc5FKLnNMYlwOUMktn5J8xvRp405xPeHYT3quYiKxpZzoXlQ7oNcQYySLiNhv145O1djTpcyAF8c0Cj/9noheRhfgQCR+RXmdFRlU4uwrD9uulNMiNBx8RyAnYNDBZVbEyn4Cssy/FymrKhagEwLBgfu53RrIT5goIdZcVn7pn/3pzmuEH2FcIQ+LetXMyHJUBs0blypwlwd98inqZAgRKmwbgWYbrHdb1F/4hEJEZx2Bn4YJvCAk8iB6fXBTtXDTbTzg434aFSliQbP2tEw67uBw+qVl1q4+qN0QJCOKK5x3CuDvLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kyKpYWck3zmqwg+nyC5UHfrN45kAGNxzHQXPYTkyVG8=;
 b=NeA7DqFbrDWrJEFPcmwkvM0c3MosLt6YNxrhG6AAKgAPTva1+gGtzMYJmRLCPa9xBT60GS/lFWNLb7Pe4iNVVOjQ10SwUnWdCc8CtXEe1WXh3c1oDkotIWNVKwNf27f+Ai9U/ATNpcyx5MMgONozV1QKAoIRiCFAuehscrIyc1OrUZTGNIeiVjc0fGlBxcRxSnMKM1nGD1a8Lj+HdOuQA7JUUntaDj4W3caMl0RSo1XHKMVrKsw0gvf0gh3FyQKXHLI63rqBQmqtmVJCEAnU54FGueMxzQs67AywcLtgLjKfgLY7SV0cTpTFDiBY/ufZ05K/YAI9uhstLdLyfPtpAQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SJ5PPFC41ACEE7B.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::9a0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Tue, 14 Jul
 2026 18:41:37 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0202.014; Tue, 14 Jul 2026
 18:41:37 +0000
Date: Tue, 14 Jul 2026 15:41:36 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Daniel Mentz <danielmentz@google.com>
Cc: Mostafa Saleh <smostafa@google.com>, iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH v2 2/8] iommu/arm-smmu-v3: Move pgsize out of arm_smmu_inv
Message-ID: <20260714184136.GB1636147@nvidia.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <2-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <akzh9qFEfi2umwDW@google.com>
 <20260707180811.GB226829@nvidia.com>
 <CAE2F3rDoBK8MeGJb=ZDRyjSYdjZac7R8-KiZf5WJnvUPfxbgbQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE2F3rDoBK8MeGJb=ZDRyjSYdjZac7R8-KiZf5WJnvUPfxbgbQ@mail.gmail.com>
X-ClientProxiedBy: YT4PR01CA0227.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:eb::20) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SJ5PPFC41ACEE7B:EE_
X-MS-Office365-Filtering-Correlation-Id: b5724fef-73ea-4daf-9316-08dee1d7894a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|7416014|1800799024|11063799006|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	N1soSzhIWIFThPYKIbsBvlRfBvQaN0bxqG5AriqWi0XXJCIpbylY1bhlg7a2WQCroG19xBE8V0+L21n5WOQxvOjOa9Y2cbkoT4yTrtriiWDURAgczbbBniUqQh6ihnjsRM1TX+Ov3bq2kdYNyNIzHZ6AE7kFX+0UKUq5b+yzKuKuWhalrh8gGZWT7jBkO+j2gfVw0wWOtoPCLrKsWKximNad7S7/elgYxL5xQba1VcqCSqyElVimvHSkmUoSA8RTmF6luC3VA3D+/onBVzKZQtXd0qXuJGgQmRDq7rOM78N248uUZdye93f2OWQ6VR6yuPNnLaP0BVwpDJ/VLmmpT0yakl1R06RmnA8JiDzTRNQ6Dul4laXRLHD6c37xzhSIhLRcYSeJb65PEngs5ws+zUiAvlI2zry+7pMiAsYejI72fUveb97G2j6VIUcyM39xOgUtYJNPocV09GUrN/Pm+b8mOW0htKcZVox13HZgjjOedq7N4HLpFa8QGWLG6uliMS2NRg6HtzQd1ft9jtCNHu+JkZsEVK1y751ej2HyklHG1tzDpsCgqahlMI4BxoZxUfSrpSjOr8fXWF0c+AoPaE6UNHBvuo5G5IUj4I/airQDn/sABLFFCZNJSuy0Di1n59eGHh7hEsOZbuSgtiWD0HaZHKTp+Ypqo6l6QdVPwks=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(7416014)(1800799024)(11063799006)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RVVQUnVnZzBBb0N3SHpkZkY0Z1BpYUwxTnNJdXJpUGlFaWFiZ1dCZWE2dytL?=
 =?utf-8?B?aDdRRlJtYjk4NkI0QUZBK3BHeFRnWWJoWHp0S0FETkRtZHVkVkxmdVNFTmFN?=
 =?utf-8?B?dC9SUXEySXpvb0UyV1dXWkJ0SWFZVmhFMnpKYjQ5enFVSzJpOTlBVXhJbGNP?=
 =?utf-8?B?WndMcGNlOHV5ak5ja0hSNVBnTnNiZmpvUHlHUDk3akUzSktyRWdPVm9sOC9y?=
 =?utf-8?B?L042Mk1jYVVrS1dnSmZSaWRnWUZzQ0ZSWjJrNnBvUDYrdWV6MUtJU2JmRS84?=
 =?utf-8?B?RDVYT2FEd3VWMU5JSXJZZ29aT3V0bmJqM3BvUlByN0xhQkt4d0dYOHJ3SjFX?=
 =?utf-8?B?UWZHWnZQSDI4MHBoT3BxdkNrZ3Awa1FhNHVuOWRFMlJHRWhDUXRoTmE1SEFX?=
 =?utf-8?B?d25FNXFDcVdJZzlUdm1KUW1EVlZndkd6a2pnZk1ZQktjNk9ma2JuWnBVTjRr?=
 =?utf-8?B?S0RwY1hZWWhXL0R4UGhSbnlQYXpSbm9md0daRE1Xa2RQUGNnSS9RK1YrWVNh?=
 =?utf-8?B?Undpb3lFQTNibnBzaDZ6ZEEzWGxsdDFybGZ3dW5rRTNOTFphRUZPWkJiSlRO?=
 =?utf-8?B?c3RQUE5FN01zY2RUQlI4cFRFdTRncmY4c2pRMHBEQ1JPd29iVnVSd2pnU0Z3?=
 =?utf-8?B?UlpwSGpRVlVpLzhobytWUE94UEM0TzR5TWp6aFI4RTdpMkNqSWM0WDR3VlJE?=
 =?utf-8?B?SDZuOFFXYmlvMGJ0UFdub3g1TnVGaFA2d3YyQ2hIeW9rZVJFTHpIZWZVZDhF?=
 =?utf-8?B?QjVoSG4raldVQVJYVy84dWx2cjJPSTlBbEFhS0xoelpCa3g0N2N5MUxNVnFG?=
 =?utf-8?B?VFkxMmRuenJtNldHdEtSaVJnUG1jckhCSmY2dUpONktnZnNWcDBEZVZrRTFN?=
 =?utf-8?B?L2hJNVJKYU9OWlcrVzdCeTlYbmRQWFpoRVg3bkwwS2dCK3dKWWFLQ2Vadjk1?=
 =?utf-8?B?clBxUG53MGI3SmJHNUlMaXUzNGZDUnpyc0FHOGlWRnVjbXlGaVBScDcrWCtM?=
 =?utf-8?B?NUhQUDFUUXBKUzVEbDJ1MFBhT1Y3QmdSSW9VQUFMUmJMWjhJVE1MOUlEMUpZ?=
 =?utf-8?B?dUg3VktQUHc5ZXNuSHBpTW5SR0FZUlYyT1k3N204L1VFMjRpb1o2L0VQT29w?=
 =?utf-8?B?QWo1eVBINGVWRE83VFpuRyt3c3Jzd1NrVk96NVkyMXRyZGFrR3ZoMy9MVXBa?=
 =?utf-8?B?SmtWYktHZHNSdnB6L2RLUFhYUEk2SGdmR0VHVUl4anMxc1Z6UWpjTFl3QW91?=
 =?utf-8?B?SXY3R0l1Tm1wbU13UENMNjlxcml3T1YwV055Mno2Q1ozNjVlOXM0Uk10RFps?=
 =?utf-8?B?SW9zT1U0MWJrOU5rcWdHR29BVzJ1MnZDZ2Y4VUpwSTRtcDM4TjZaam1xTzRt?=
 =?utf-8?B?dEhZekhiTXNRSlpFT1ZubXNjNHdXeHpocVJTblM3UFBCcERNTE0vQWhtVE5l?=
 =?utf-8?B?eVZPMTlTcUVuQTVIQnhydjgwM3gvRXJmRS9OYkxDTUEvWUZWcWoybFp0bjZp?=
 =?utf-8?B?Q0JJZWdkckV3N2ZRSFBOOFJQMDFGRXl2RnhpNGdtcEhhOStQajFCUGY5SHhH?=
 =?utf-8?B?c3lsZWVWWXJnMTVuYjRqdXA4RUV4SUQ5KzVCb1dRUHJLZVZVQ3JDaDhhTXBG?=
 =?utf-8?B?eVpBVTE3Q2Q5UVR1ZXdVQmhwSUFqMG1xbUxZSFpTb2RhSHRHL3ZDTldlQXNF?=
 =?utf-8?B?TEJheGxzTVBORmJoM1d5OHpIUHRDaTAwRjA3VDZZL1ZpRUwwcGhpb3M5Mzdr?=
 =?utf-8?B?VE5UbUNXT3RBblNvRFdkR2hIT3FWL0RUR2MrQjlhMy9VdnRsU25pK2RqSkNR?=
 =?utf-8?B?YkpTVkc5SUR5bEM1aE5tdFIvRXJDQmEwbHMySlFJbUt1V2JNdjM5c05qc0ZK?=
 =?utf-8?B?S2djSDl3RzFVOGpYdDltZTdCazZ0NW5PYVNLcFA0M0pOdlFJVlAvRG9sT0d6?=
 =?utf-8?B?VUZMdmw0Y1pLQy9vWEdNQ2t1NXBZbC9tblU2YU1VdkRWWEZUT21MeGNtMllv?=
 =?utf-8?B?dm5vQXZGVTVLRkE2YVIxV2xEbXBNTjR6Y3laaE8vc0hsV09hbXFnMENIUXVL?=
 =?utf-8?B?M0tzSnFDcW5SUEhmckVFczlvZWFQMmpMTDErWnh4N2l3ZEhDajdwNGZiZGtM?=
 =?utf-8?B?SUYzaTlWOSs3bHhzYXhKcmJkbjVsTnMrVkFyR3pISkVBdm42SVBqdXVLRGZL?=
 =?utf-8?B?Mk14Q090TE1IRmFSMUdWaG9wc2NuQ29VS2JEckdOTmdWU0lpellDUS9sVFhD?=
 =?utf-8?B?MVNPdW1FU3hndGRpaXowc2t3TmgvL3R1VTEyU1A1OFFDYkJjdW1mWW9YOGFK?=
 =?utf-8?Q?dk/QFv51eiu9JbotEA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5724fef-73ea-4daf-9316-08dee1d7894a
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 18:41:37.3481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FM+NaJ+CL0Ig7Ibm3W8vGqiKXYS7n4jqlnvrqEQgBKQWQ1CpYRCHOTiLCmU8HfmX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFC41ACEE7B

On Sat, Jul 11, 2026 at 10:38:15AM -0700, Daniel Mentz wrote:
> On Tue, Jul 7, 2026 at 11:08 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > On Tue, Jul 07, 2026 at 11:24:38AM +0000, Mostafa Saleh wrote:
> >
> > > The smmu_domain is only used for the tgsz_lg2, can’t we add that
> > > directly instead? Decoupling the invalidation form the domain would
> > > make it easier for KVM to re-use the code.
> >
> > Sure, done
> 
> I downloaded a newer version from your jgunthorpe repository, and
> found that arm_smmu_tlbi and arm_smmu_domain are using the data types
> unsigned int and u8 for tgsz_lg2, respectively. Can we align on a
> single data type?

Yeah I updated it to use u8 in the structs, but at least iommupt has
the general style to use unsigned int for lg2 type locals that I will
still follow there.

Thanks,
Jason
