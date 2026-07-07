Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012014.outbound.protection.outlook.com [52.101.48.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FC13DCD9D;
	Tue,  7 Jul 2026 14:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783436300; cv=fail; b=kGo++aGmsvjq9eYkvlcPdQedMPyv3Pvpnu4SBMwGSfGI7DShsw3THyswZ5yNr5WSvELVIVvjmnhQu+rxJ/8uhZrGEhhMI9BdtrOxqEfk+JBBNMff2pzlXDzUrrEl9EqyR2wxX/WWjsqqLUzQO7CjL+pa3vLZPGPcuxOEyIp2pz8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783436300; c=relaxed/simple;
	bh=XJpN2CPcBwPJRItG9MVfEF1lntoz7MzaIJ2XY66tySo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=M7ac7IwlmfC0eRLr29Ykd42kwpmbT7tbj+VTMXHAtudC0dyiZGiN3mHJG1UCUGihuVkLAXrUZeJYtbKVMkHlwUNiwDvvHlPZTtfN0dTJuhIOelJQbfIKY7ziMyWL/Zfdv3fu6VtK2IjAWT3zLjstn7w43LisNs9Iwbgq3Id9YOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=A+WJ8c8g; arc=fail smtp.client-ip=52.101.48.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="A+WJ8c8g"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e2dNolgTHJ3Xl2+fhfNTDBkNFoV2qzAt7Ds39KC5ELYgoru8PxC0KQ7qApEb7lVXhVdtApPdZhijst6r6Y2sMwiYcCZdql2DJFMRybjti7sSwWqYQXVNeADl0HXjEg3Geb07OgLVLs/3xE2CLkEKvpj1/vNiXnZ+JRucROEJgftL9eJH36OIuYXoxedkHhlX6yMelz5qqNpz56fyKoAJy5mKucE4SuU5145k5Bf1M5VuoWBGdupG+zL39O5bogRea4T+CFoF0UDs6gyGjKLn7E/Swnow5kJ9rPtp30td6U5VfM6CBnIxAt8GiUElg6dSAoO3V8UGHrMpcdIKpNjt+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f8ZHqSloZbKxEXszHfx15tdXO1EbHwE3uKdULZqA1Ag=;
 b=VQmya3StJcEyXe5R0nsAUHKAqFRODrMPldWOBq/R0CRrZRzJ55O5un2teRAuXoyhOfKKDc8JcBsnss19EKe3RTMQougXG6lVRRq71Q7MVyPquo7ixHjNXkxGlyyziOxBCde/8sklLJltA8yl066lAuFKwypqxTAX96gtWXeSfKEABkzeGMEbx8r1heXg5mAgyTan8ioOm8y47FlRaP6KnwV/mG3w/UN9cirwkqRjSj2/uqr5cLt0bVXejZeR7OH/T6ERw7P5rXHfKPy/LI24cWm3eYovRBNbD11NeGTI/LKqFU6z8o99funKzRY3cYp5FKE2Ycvizs+TGP5K15hzFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f8ZHqSloZbKxEXszHfx15tdXO1EbHwE3uKdULZqA1Ag=;
 b=A+WJ8c8gCMJEIi/SuMsNE67vOXWeXVYLopGXMhJM+Z2CkP1Oo2nj9z6oDeXciHR3yNlRazl+Yfklco1Cs9iHjA96Tdy4BKzGyGNbR624L2Tj3D9Qu6RJknXSDJ/FihNqQZRtJcowGxHwluH3NlNy5e7Dz77eoHgHUEI554YceI1BfCfU3Y15HgAADmFNJIi3ReDKehvjtYptcs8ogOQPfNpU9xJicQOQvgtC+GCzXkIHeTk32d/9waezIyh7RiX7RI4EMkMGzG1zcZ0EYYq32AaX2ElY2qfQ/dBgM6GxyyqOmNR5DuZz3lC4vL4NoIXz6xHv90LCUhX8wCsDaof9VA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA0PR12MB4366.namprd12.prod.outlook.com (2603:10b6:806:72::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.14; Tue, 7 Jul
 2026 14:58:14 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0181.008; Tue, 7 Jul 2026
 14:58:14 +0000
Date: Tue, 7 Jul 2026 11:58:12 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH v2 5/8] iommu/arm-smmu-v3: Precompute the invalidation
 commands
Message-ID: <20260707145812.GK220801@nvidia.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <5-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <akzoeexW-4W70QdU@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akzoeexW-4W70QdU@google.com>
X-ClientProxiedBy: YT4PR01CA0448.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10d::22) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA0PR12MB4366:EE_
X-MS-Office365-Filtering-Correlation-Id: de926871-38e6-4c9b-aed3-08dedc382ba6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	43omubcVcPXnNNeuf1kSox0LKdfNozYYnx9Vdozb4rhl2co3dOkAWHzU+UbZeBr2vh9u0yTnQp39itLrbDKYq0Vepz1+irh7NzkbItRdDp/R01SfAWNgSybjKKBtVXMvey/KJEcnB1npWgNdAyCBysENAHnXuOpdTmGtq/fUjfswOOU1PhcuiJI4yJmGe0YtTEAIX6CGJ5phLjOOF5alvpj6FZ7xES+aa8/DnOZzBH55jwfhtp5VcnBRk+Hs9etRIwbFGO0+YBtJdE3CPCzthAKr0Xx9i1TpB33/OsEww3JdLRtTxIQREjDd6Qb+5XnEcVBh/7n3kPbCkhX4mCUOtJvXZoSlkQWHtk9508Mff/xcf1WKgajE5SoTIMOAk2iiwSQ+E44HHRmNVW6a/DGdRnQ9CSaL64fOAn0Qr4aLDkryCXeCd/fL664atvDcCUNsu12EhUQPTi3oCUm1QP22sLotuh+cxE4CVoig2bY0FEM8cilrEsvWOs476UNd6OlXhLLGxK6KLTDXU7UXo4iwEF/gM8HS9w1wFTM85MjALnKuFXDtVB1gMsZOxdaOJI/RDgnAHq/Y+O876bPOXtndLh/MTwl9f7PztcqY4QQ+iPQP04KNXzXvt+7e5WDue4swVWOIH8nEWaP79QTh3xMfwDklLo133cjWXnlvEMMCSSk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vkjLTcf90bu1UdCSXrwMkrhVaesXHmVgKoibfjDZmnZFy2xs5XPn6jfkyWVj?=
 =?us-ascii?Q?GuGmckL7dbCqtUkq7qNULxIbJiAqmF0wnCtvAhO4JUrgakQ205gbZzi08/fI?=
 =?us-ascii?Q?Se8X6oL/4rE6jAO8wSrf9ulq345yNpP9zwGlzT1MldIoRQbxVHo3GtQDXNJ8?=
 =?us-ascii?Q?ruxX5EAb3GtduHOCy6ysJhJSFurFV3M6nie2Cv9XIdTJJEIaoQS+D+uKG9Iu?=
 =?us-ascii?Q?t8XItZbJvVpHQjtqwKHpae8Gj9DO66bLkGX6eeVEm8ofQZP2GntuMjm8Aq9D?=
 =?us-ascii?Q?ahoWw+dQQ4O3+EmOI+gd8SINd7xk4nR1FMv0ZzUeXYAJ+aCwqT19n4W0FqCO?=
 =?us-ascii?Q?yyjxyXBP2Dunzml+pKTfNW+gkK8gll4BHV+Xn6B5aTzc/GDsRBqudVewQVxt?=
 =?us-ascii?Q?9VSKKuSlVgkw2phlETjUglywqZdcuq8JmgLO/IIHbVZNSqXmiyyWSe1hC1Dv?=
 =?us-ascii?Q?pj4Ue5JgYPz2R+w76leMk+rzMYedFu3RhfjhRHoRpO1wgS5MpAFn2AQ2WnuU?=
 =?us-ascii?Q?EZBdEvBaCkyaSimqBTU1QQ77ZBcrrz+qG0go9JSicnMyYdyBezvkZwMIHmZS?=
 =?us-ascii?Q?E1W5NbFOj3Hhw5wfx+HmkGcvbwiLbuozuPbEe+1PJtZDIMrv2S+zA3Q6VjvB?=
 =?us-ascii?Q?1Kb2FADT1XZPVjBqTqHIcf84zVuaujyIY3aq9c1zPc5f5lSJk2ALYK15xszE?=
 =?us-ascii?Q?SZ58SOKcVhK2rspWoG6EgwBDMETaphvCiFAG5J0vptzkJ5wRIsz1sac4LfxB?=
 =?us-ascii?Q?JXtT8jP/1RmagBD1FtW827USlxdJPDqK0VPeBockhEtKdXobXmuqNK7zLfAC?=
 =?us-ascii?Q?PnZKaa6Eyweyyyj4XWBmEVBARFXXITx8cS+IijRssuxZkAPyVuBSl5XagIX8?=
 =?us-ascii?Q?cAsRnxqgI9efyEDAOXz6vXZBA+MiDgR1842+FE1zjiX1PxoGGfLGKAzLbnHr?=
 =?us-ascii?Q?ybkVGGV6NGHeMwrWzr4pPsTvpsw8qjhqUKv+2XglSyUKngXtopK9Wtf9fcGS?=
 =?us-ascii?Q?uV0xelvaN5OSVAfphYOLkAkSi9YEsfQbTZz2A4PX/thwQBsGxf1KgtpbcMl5?=
 =?us-ascii?Q?BzUi1lKaKg2121f4JTLzOI/mtwQJbQXkz+UamkpA7GFxLZ+1VLpDSnXtFuA6?=
 =?us-ascii?Q?pWssLnX9b9TxXlw3ez+VZXIciT2c7jc/SjDIXH5cjorWVcFv+39h2ZaWAMHc?=
 =?us-ascii?Q?zwqw57ifQ5px58s672+QaAXU/9HI6gl6CL0MEM3Ecdxr3UzF16faH98+kNH8?=
 =?us-ascii?Q?l6J7QiXvCzKlN2WTnKWGhQkpghWYYjyy3H2b3TEYiYZ1o9SGxJLRBXj4qMHT?=
 =?us-ascii?Q?nabkFkVj0eY6GqyM79kUHOePw+wks+aLZbmP2TvevHwWQMluGGa/vkf3oJgh?=
 =?us-ascii?Q?xjTmv+Bf97/oGt+aGnWQjFqf4QZ+cKTwEHaqM/9lOlQDUV+DToec39umtpOy?=
 =?us-ascii?Q?OogXpFvhuRw9qMQZUyle0QnaFqNfaQTdDEhMsSvW2VGF9Aq9yniATxd/WoQ2?=
 =?us-ascii?Q?s01qhJyDxCzsp5oOFbYxEWgsGyN+R7mm1oURdv/HMal6bKeYrL4tg5kJpTI9?=
 =?us-ascii?Q?ZKHA5RHLU6WfifrjuQymVyLC0XZd6pRRhvXo2mZX6z5qp1C0dmhyBoBx7Ugs?=
 =?us-ascii?Q?e2n2eiqaVZXpyHzhz+52xALcjqWWHyORZ4ehBcrFHFAZU62Yc5M2OCkTBGd1?=
 =?us-ascii?Q?tICX67SfwrYS/r4B+0LOHm8yLtXHgf4evrGobwMgANODML1P?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de926871-38e6-4c9b-aed3-08dedc382ba6
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 14:58:14.3838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AnNxgaqp71WVp31/xh+WtKGjpwcAczsfyWYRH0M5XxpMBWHVvBxP+G25uDWM54Y6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4366

On Tue, Jul 07, 2026 at 11:52:25AM +0000, Mostafa Saleh wrote:
> On Mon, Jul 06, 2026 at 01:26:42PM -0300, Jason Gunthorpe wrote:
> > Store the required cmd data in the tlbi and just copy it out when
> > processing each item in the invs list. The cmd form only depends on
> > if the instance supports RIL or not, otherwise it is always the same.
> > 
> > This avoids redundant calculations for each invs entry.
> 
> I do not understand how does this avoids redundant calculation?
> This would be the case if the domain shares multiple SMMUs,
> otherwise, a range TLB invalidation should be unique and can not be
> reused.

Right, if there are multiple SMMUs for the domain then currently it
recomputes the range for every one.

At the moment I think we can't have multiple SMMUs per domain but
Nioclin has a patch series changing that

Jason
