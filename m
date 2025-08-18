Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DCA11B3925;
	Mon, 18 Aug 2025 23:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755560141; cv=fail; b=S1bwMmDf/w0yxRyqXTW49+3m5LAGDIaMO51ReAdvS3tO/9aa1fy0Lgxole2WOvQH9Rz3bknvwomK9l7OBDBJjKVt5axJH9Gl/K7s1l+vs8elMn2jGY5rbB87nqB26CAu2MKfCDe/ileT01H/EpaiRJMW5gzcH8R0VSjuAx/8JMs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755560141; c=relaxed/simple;
	bh=5XHry1hJxiP4+QrLHG6p2FnAthbh+RZjgh9ni3Lt+PU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KbdQpjkSj3DjmVoDprme8i1L6zhpbu+1WU3zoO/bxhPXRTcDgZx4Fjb9R+cdN0PYvT+8gNsLOFXwDiM01xIcnCqXttD9JzPp7MA7uke/2TEI5UdFtYXPm1mHcu/hmTmUo6Dd2gemIKPqDluYpUeAT6L/2XywmmHMEd5BkObtbrA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CO2WJoTz; arc=fail smtp.client-ip=40.107.243.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CO2WJoTz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xS0/PZ7uNHkmL30biO/0shbrOGLbne3vPLuZHejIEM/pPxsKdkxoI2fiJX0W3hubn4/CB1AFm6+C8HzRDyyawOLILLsFz3q3TV0md9AVd6g1twq1eIJMzH/ZD4GPFyEGoAiVogW+BL9UZW3dT0VoqCEaLrRLmCfw+PxzEzwWY9pE6htHeBmx8UISIbkcut79RnZWeLThw8LWAEeftYj4VVrK8YL3dA62O+h4cKKT06oYbSM+e6idD7kCelEFOQm2HBUF+0gcMgR5PxwsYkF9BPhDk8RwkILGBFVhRavEVxsYtWdjdfoyP+BJ3NTQFZdldXRf2XcKpT4jA7D/dO73wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eK5nVfoW+/DMNUILqmBOYWGClbeHdmJydPlqWtjoJ50=;
 b=v/ULVJpUKuKui/DlhFNI0Iq9TEjkWCJc4lMvX+VQjJkYpK0xZJugiy7u7/2Dn/ngaBky1N42LiarfsRfziw42jF3eb9Tz5Oz8/JfzjGRjEdw+gS+/XLk9W4ZKTZRYJ/tBO8NBrOACknLnx7qT9YSJOM4GhtIDuCmqh9IfV16Y1D448BJmk317eHrmGFHklc1U65t1TeJJNCrxjH9xq17HRNIVklpndrOCNBPyzn/zq2/9DtbSz1iMF8zf52CkBX7EhWk0vkzekaoIJiydf9Wj0+FqS0eQijOnOx9baKpd67VYD8HKEneNgSSw4sn0MKfnOsOULtqv1kpPeZEwIheoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eK5nVfoW+/DMNUILqmBOYWGClbeHdmJydPlqWtjoJ50=;
 b=CO2WJoTzjujeDy9cUtHybI+g/POYlWNagHHqNiMF5umcsRpehfeb61Tm3qvVLx2cHymrEmTvdjDPCJcYJyJifM/pKkOHLF1u5+HIMUEi4gEedY1uzISTl2hHXowiS2tUCHA1aSMBGKY+L8ATY9IqxgYkomIxlb9g8IFcSWzQ4ePjNnfHSo7dpGQLCaq7UvjrLelKzK6LDFktyV7ebiSAJjdW6gAmSEtYh3uvXsvwfXI0A1dDWyShR39hgY26so30bhMdXxSmmw96mkq9zl1dTYQ7rIN3o0WfkzE9T7LbvZFFDOAp+Q/luqjCrpQIc+IMCpUQLzVFoPlTBatgviA97A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SN7PR12MB7883.namprd12.prod.outlook.com (2603:10b6:806:32b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.20; Mon, 18 Aug
 2025 23:35:37 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9031.023; Mon, 18 Aug 2025
 23:35:37 +0000
Date: Mon, 18 Aug 2025 20:35:35 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Tina Zhang <tina.zhang@intel.com>,
	"Wang, Wei W" <wei.w.wang@intel.com>
Subject: Re: [PATCH 2/9] iommupt: Add basic support for SW bits in the page
 table
Message-ID: <20250818233535.GE802098@nvidia.com>
References: <0-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
 <2-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
 <BN9PR11MB5276372E3F386A590B00DEFC8C34A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276372E3F386A590B00DEFC8C34A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: SA9PR13CA0005.namprd13.prod.outlook.com
 (2603:10b6:806:21::10) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SN7PR12MB7883:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a55e158-0f03-4f2d-febe-08dddeafef2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xPkZQcTyKaemu2eq0Lcpp2qW/L0KFXEX/WwlshOh3PHOTAlquzEOhNJyqrfi?=
 =?us-ascii?Q?lTE2wjkTFhiqxYjOG8fs3QyUd0H7sWno/RAI5DRB5HerSV0NEPK6CFpC3HpV?=
 =?us-ascii?Q?LOC+pEeVSv/k+0vuXZobtL1rolSXo/gu2c4EKxb9Hz5Fhf+fg7dV9ucgMYZq?=
 =?us-ascii?Q?r2qDyV8Fs3CdkIVN42AoJ+KGji4NuP9/eGdufC/O39MkMAS98nHTPnBm4/kn?=
 =?us-ascii?Q?iatLDeWNhvgnRJB+r0pIEwtDyuXIHv1ZU1T6xXEM9CbRez8Nzbm+tKLemWgJ?=
 =?us-ascii?Q?7TIdeWCOIyN+ORxjaF+4r5RSINs+aj18GsMJu4lI61OIMznnfNnLqpr7heoq?=
 =?us-ascii?Q?6/heGh39hl9qudy3nyqKV54ym+eKL/68UsWFSg8yR6PoruJnQsZROGuuf5ds?=
 =?us-ascii?Q?DQ7QmS+0WgduGrMeoxpKbZK5KaZb9AOTgr39wlLCgzIDfQMtX3VWy66E2vM3?=
 =?us-ascii?Q?Pm5Dm/8WLt5rMmZoFTr1cvhMYF51j1c5826AwWYxUCICZwgJkZCU2CVZg932?=
 =?us-ascii?Q?A6TsZHQIzFDVRkOUtwxeX6sNmT10NsQuUW+hn126oDptK9fAyMREU9wbUWMb?=
 =?us-ascii?Q?ia8CsAneXILYkzxuiJJoUGNjGX8sxWZk0f8HP8y7k82FSpuH6Qw3MjejGFVS?=
 =?us-ascii?Q?Afdv1aH2X9IMtnD/OXcYH9Y5q4nzBNASvHhcQqOSq9BtuBgZc0y0FHuy5OAE?=
 =?us-ascii?Q?rOTy0JmQ6dQA/inmJ5zt/EK8sSYRpckH4Vl0UIU9fTcf8ruwk/nI4cN6vsef?=
 =?us-ascii?Q?o+DrYu7Au+kWwC+OBoIzL9B20ZYdhBc6UFShS/TI74cWAoCQDd5YIxDr+TkM?=
 =?us-ascii?Q?vGmohY+dcqqWlIvGZ67AhlL3ijE+QqGv2feFQXCj5mCENtldM7yGK09HTOLt?=
 =?us-ascii?Q?Cert5PWxURfnO9j7iBifdwfVjCe0GBYD6qxNNTlkgMcAb0CqcuSPxTsAfGAw?=
 =?us-ascii?Q?rXBhtSuWzOyzq2MYOV/pq07pkBkvN3SkR5z7o2A7Espx+skMb9YgwzBS26JN?=
 =?us-ascii?Q?/zpNm0GgVq6rg31b+CQjolFWHyXxErQ6iFh9vA4WE4whzHxNN0OL0Jj5S/K/?=
 =?us-ascii?Q?b4SmAlj0/P6S1YfmjsBlaFA+tivL4Mji4thOEk6s5l7tX4UPKGmgHoFOYMW1?=
 =?us-ascii?Q?2JUBjcn1a5ora/CAiBRG0TrNbOAQTbR9Kdj7ZH15hwKoBqJG8qhixPq4MTZO?=
 =?us-ascii?Q?7znrk4TiyJlUgUMef51HMmfBI57KnNjiL/FBwrFNYfWsqRLZS2VF4SMpeFHs?=
 =?us-ascii?Q?ULjFyCTSVsDfWINpdTKeoCEcDH33fsi7jgcMou/Zxfwt8LhJTHMnA0dz2ha+?=
 =?us-ascii?Q?iKFphtDAXzQw/axiq3Jyu6UXh8eUQqdMfQ0cY10l39N/Bo/Cofs9L1gVKB3f?=
 =?us-ascii?Q?ib3MycrDSuyatIZHzRwWBKVrpr2zeZloHBGBfeeU6tHYqawhbeyAgZLn2t2y?=
 =?us-ascii?Q?ZSLoUThfFow=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JohQJEMfIq0CBaf8Xl2BGs4fkGv5N4usavVmEhWQOrIsY6bwjRaGZBfqyHJf?=
 =?us-ascii?Q?z3p8I9hKS0iMBXJiqAyITD06vyy/MgxkrpZi8wx2n4ln+QgKTfoyTbhsYYoQ?=
 =?us-ascii?Q?SZ4f9r98tT/BjLaAo5YIAgimNJ2SAkUytKluftfu4O3TVkfUx5yu+qaxcS1u?=
 =?us-ascii?Q?UmQG7FwTLCb3V/JrDn86duGNt28w/mmhX5oeTaYdzipjg+UQGQUs5Zqocg5S?=
 =?us-ascii?Q?1yPzuEnKKzqOsfp6s8ZC/NhqLAv9P1Zy32fDy1/NKez+SLdbNV2SLTw4/K1d?=
 =?us-ascii?Q?hQp0YJEJmULutJJXUHXz+UQgkUP4ZTFjxBNhsMwKyZ6fngC9T1+ziMS2Nyco?=
 =?us-ascii?Q?oVSIM2KxoL9O9sMxrEha/j1l7WgsA9HFbQM9enZgWKGVBIQi0zZa2kmVMK7e?=
 =?us-ascii?Q?XfrZ4t/WdGbfwQ4pyuv7lxWrnmV2dNGEg+ocmDB3eHCo6mT1LJvzJCfLvTnJ?=
 =?us-ascii?Q?dzA9fjLqxYhD92WRzwtYF3cwkK7hx7VTPpFws5CZz9af3uPzrlvI8ptozDhy?=
 =?us-ascii?Q?sQadiTaEpO/ReMxLevNMDh352CmEWthVXQ9NFFc4QsmN0LZlPbOJ4oTliAcy?=
 =?us-ascii?Q?fxxkVD9Ub5az+h/zu2tmZe20oh9pdkBQUUl6EVRlXH9/DSWouCJ+sXIwJbsB?=
 =?us-ascii?Q?llIV0J0d0Yxy7NXVxKkvnsIcH9NVBCtUx/N7hq4QEb2Zms4STPiw0B04zjgb?=
 =?us-ascii?Q?RkynNPai+6GVG3AltEJofpBFLpEO8/bTSfaT0QwsPDIqtGTpY0JyzHKf91fd?=
 =?us-ascii?Q?aAWxXgdW3ymKXz2yeTK7XQHCrYOdk4kI661imQev8m7nKRuZYXWk74hQmeAf?=
 =?us-ascii?Q?qzl0Ex5WkJ2MHnly10jAaDRw2oxILK7FSwragn3rz0Y6B7S4S1LJg2aVZeDP?=
 =?us-ascii?Q?ccmuuKfDaMamaL9/uNxvcqek6oZWasHSgundKO77w606FF7Xyak8Dte3VNih?=
 =?us-ascii?Q?WOntUFYS1toP2rWiffxXxGirw1nUZUFvBhcQ87AP2FwW1HxsCBBOr1BxOneh?=
 =?us-ascii?Q?CZygHpXICHmY7gKUDyAFixuvExdUZiVG+FxXT4OJfyQ86EKx3xpwSqJA8mRG?=
 =?us-ascii?Q?vWrOjC56RxPlXvgPCbSadnDuWC6zMIpDLG3zI5zMZSaYkNCOdrP8348hIhlr?=
 =?us-ascii?Q?8v5jpMjStlMnj2YjvqQMp7FyVbVVuuKvRFAM5DitG6X12gWJ0C3Om0cN4ouO?=
 =?us-ascii?Q?nc0Yrnga/7Ty+iK7ok9g/q0e14kyIeYOQECa+w170Nsj/1tWhx0dtZK2bh/4?=
 =?us-ascii?Q?ROlDcQ3HLErIEIHzpbHsk/3fe+kXjUEaa1Frl0jv5s7iqgLH0FQ+Jd8PB4nj?=
 =?us-ascii?Q?s/edWMImhW05fUDf18euoMZ9MA9WeBcXDI/Wtp48NYIzyJKrDqvsv4bIDD2z?=
 =?us-ascii?Q?eMs4p9q6dTZNzNFU586Hio7G3TSY3atE3/wudQuS6lwlJUCatJ3cJDSzlHNi?=
 =?us-ascii?Q?OVqFKgduymabs3mGVQZeOjfecoFXSHdHvzBJyDfw0RJKB0MbBztOJFGeLufc?=
 =?us-ascii?Q?5oPnV9DpvFbCYx1mBVHArFmgbkSfmjrMtN2aQg/TMTLQifnIPjg/PQHbTKca?=
 =?us-ascii?Q?WVMtwi0CveOgVPlEGMIi5rqBsgU3w7nio/2t4UWr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a55e158-0f03-4f2d-febe-08dddeafef2d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 23:35:37.1748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ubAw1M1P8y18Ljk/EM2s1kGWt+jUyB1J8zetAXhfGGND9Fxf9vghC1uepkgZ0mWs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7883

On Fri, Aug 15, 2025 at 11:29:09AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, July 17, 2025 3:58 AM
> > 
> > SW bits can be placed on items, including table entries, single OA's and
> > individual items within a contiguous OA. They are guaranteed to be ignored
> > by the HW. The API is very basic since the only use case so far is a
> > single bit.
> > 
> 
> what is 'OA'?

"Output Address" a page table translates from a Virtual Address to an
Output Address

Which might be physical adress or an IPA/GPA or whatever

Jason
