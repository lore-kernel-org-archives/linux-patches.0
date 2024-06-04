Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A250714AD2D;
	Tue,  4 Jun 2024 19:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717528054; cv=fail; b=C9x4t860I173G92Z+FYaAAteDgFr4nCSnT5oaD/bJ0uuHQHioHaxJv9PPyMIqN9tCfN9DcNQLf81UHFKoLzgfh7J6yk6uaqAddVX6cPP/b82Acujz/JwsL64NqeelG2h/cSktPrylaNgF7JKzcNSB99sF+fqOuGRQKB46gJhobM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717528054; c=relaxed/simple;
	bh=9cHKgRncFdCmn/DEAxl3ZEAUc4zsW+gUtEm9aeoDrwQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZkcG6RVVQrTqidVnIBeRUqPSbLCHfFvwXJyiPtDeC2YDdbBAEV6VeLTYjePGBjcYO+ZEcJeNIpCa/Q3MwdHoxQFIIqui5/ip3XscK37bEqqyhNZ9I0AbfOptgO3KuAstca4xs9m3r7Wxa7PuurKAgyFmAT5xaJMHU6qcLYP9xIU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AZ+t1b/0; arc=fail smtp.client-ip=40.107.220.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AZ+t1b/0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sgt+bv3ng5UAkQQL7qDoCsi9yxGO+JXqAtwK+AUKz5KKVaIFeEg2HCvJLzj5TBIjOWDqsn0kU39Zzt7HpKRCZsczKlM90LwA6AlzdptsL2i7AqZApo08korHwQ2KMAHkoSa3kZ+7PNj2eS0ozG+GImRL+RgzexV5rkYhy8c8u/Qm+3NhLRXzkFa3qfd/l6Ag2n0XMDYx+FoDMILpGDtAWKmMBSIlAu87ijtOWpQN/Agoylkuykv/A7W8TpWv75ZQd14x722xxEArVgwXcirFf22lt5EUPiGGOhlG611xcgr761g6ca4XCwJTZWSoMZxr/lkw5cZg111VhH26p8m/bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JaadWie36FcrMbW/t0MBRq2Q61aNJfnaZXzoi8dSwMg=;
 b=mtoAXW4OpoR6ci1rPvbnJFMnEJEV2lzRGAopr6gFa2PP13wQhL+8HuGcUxQwlh1L/Csf5zxzBtwMNe7W+uw7TUFuuQ3ZnpR+eaKkTsCGSAlF7CiFieqymcJbMrF0VyER1CsV5I4ElvghMCyUrx6zvj8nr30ZjF/8YWSPTl4PkOELrKANf5gThlDeauO2zKmATJ/tYlqm4I0hTNvN2QHXhFc/DNnoO8LrNIMcTNqs09klaw2UWuxJVBuMqKvkbuUgJexLEjgbBUioFOYExSGLZsGAL5ryii6q/MUF4DyuM7XRbJC8H8aGFpPbS+8947inBQPLyhXLo8hjuBo1QleiDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JaadWie36FcrMbW/t0MBRq2Q61aNJfnaZXzoi8dSwMg=;
 b=AZ+t1b/0ZKT3kJXaGDdn+s6gAmpcwvFZ2mauyyFeK7cbW8HywkPIbSSfgVm8pOGPaGcc9JOwPhZzEfC9i9vpwvGfWYbqp7WY9EJFQm/3M6J1sIvCFs0f5ZadvLV8FAd7Jx6hKy9yXFX5yZgGsBrfgIEnO0qGNNA6kYhCIW4VtOWI1R0weU1lM6f4OwOm+4Mw/EU0XEuFU/zwxbY0PC/Yu6oYeGGYbSf83Y/hVpokH9TPQgHVpRW7bYRdHeUNXVsZZCygq0w5xHUheI5SVK302txbBT2S9iHlPbQOntZ0KxAPz8Lh+WfkNG2bgiUgdLRuPckwuZw2FQb15hbnQXpeFA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by LV8PR12MB9450.namprd12.prod.outlook.com (2603:10b6:408:202::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Tue, 4 Jun
 2024 19:07:29 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Tue, 4 Jun 2024
 19:07:29 +0000
Date: Tue, 4 Jun 2024 16:07:27 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v8 00/14] Update SMMUv3 to the modern iommu API (part
 2b/3)
Message-ID: <20240604190727.GQ19897@nvidia.com>
References: <0-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
 <Zl7UDSdN5VXo/hRH@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zl7UDSdN5VXo/hRH@Asurada-Nvidia>
X-ClientProxiedBy: BL1PR13CA0318.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::23) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|LV8PR12MB9450:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f0b6823-a90d-4cc4-1e61-08dc84c9944f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hHE4HTXF0TT9gnVS+ioo3Bri+JEUlWbd4Ntosaf5Py1KIzp4TLKGnjZHtzjX?=
 =?us-ascii?Q?AOFMNEaw8lPywwrVL8RdYHMnl9hvldLM07CZszCF/LV8ce50CZDHUmwFuW8m?=
 =?us-ascii?Q?r04msEwZyhuXzutf2HTU2AS7JHOQoMqqHLaAwHedYNh53jZR8bAPOz8qx5wv?=
 =?us-ascii?Q?b9lznpbAQq7yK1LsvEXcujxsBt5p4YYyd08PTLkKrAS2+TkFzmWI7NoYEzk1?=
 =?us-ascii?Q?5A7oeScqhVoZGJz1m1ZLdecYCPKYZtDWNMn/DuXsZ3S6g+m9yGRSHiUbNFvC?=
 =?us-ascii?Q?ra45gmQwb5TLKyuBgT3r+JD2bPiAiEJ/Fyt7PvvvOUzSjyBOmCi3HfIFe6T7?=
 =?us-ascii?Q?JuUtPDRlb4/yv9Rde53flYTnrVvP9GurnY58SZfQdHsg0tMJQWccglAM7Yb3?=
 =?us-ascii?Q?TThsWL0bxAGmFzZzOPbfK48vGZGEzdAGus1cULUxgOxZQsL4p39D21trb/3i?=
 =?us-ascii?Q?FhylLGBabw2lpE7XOEfKmzQEPL8vlFEhczdVvk3xChsmzQ+zHhpWQTNyPB0u?=
 =?us-ascii?Q?tw668x0/tzsGotYF79Nu6rvONIaXWRbmQFz/jFvykY93sPd6dX0y23TAdwAY?=
 =?us-ascii?Q?bTmxsVKZx6VRyXFGi9zj7m0F9oJCLRBB9U2tTxZSGYCTbbh238eh/CXEfOXS?=
 =?us-ascii?Q?SsE/eGmVajy4iFAcFZK7t6OwDII0gJB6cKYDowhrMTlEWpt8HajX7XNv17wK?=
 =?us-ascii?Q?FhbSHmDQ+RG79dEMq89RYjrW4DS2fuyoHBVW3SRE23nyWzGaTQrVO9PaXphS?=
 =?us-ascii?Q?k81TRjLanxCxauDdrIKCaSYLELP5WNVv4HdHOT9xlS50b0c7TcbUGYhj7N27?=
 =?us-ascii?Q?hKoOyvy07AhuqK9Vd1VzL3XezVxXSS46oytueQDjLsYadXjnrMKbXghQ5Lui?=
 =?us-ascii?Q?m7LnDOH19yEkvYU9qw9CUmn/jIE3aQy5Q4vyMnhpkw60Pn9l0iJHNGuJPPxa?=
 =?us-ascii?Q?es3lje46pNhnzW8HcuDVFWA5/4lICkdDL8RbqFTjqAc7CpZlgkPqIZX2yO6+?=
 =?us-ascii?Q?WuVaXsrLsjOC7Zwu1TH23z/VOpppjMrG9StEhVOPoJiSD0KOW+np+kDeUieX?=
 =?us-ascii?Q?kUZlQsie7XkPDmdYRchAbQ/TjmaZO/esVwIymF96jWfYwxlUDbvWEj9WTK2D?=
 =?us-ascii?Q?W3KZQ0rLBcY0/4eAu4W2lEiwlXd7wPA6vmvAzUm9YRoca2eZ5iS+nXGnvL+p?=
 =?us-ascii?Q?VF7bYGKz2zEEbaYetmp5PnGlxKJPNmiPiVAr1MCCgr3ySjIua8GMicKWVnZC?=
 =?us-ascii?Q?6jAyDaPfZCFD6H9RQELEvQsC2tN8KX7xLgWlWdOIsg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?y+7OcqkECcEV6utc3IQ9xLQDe7/L5u2as9mdAToyK5iebZg1O/8P4C6l/zln?=
 =?us-ascii?Q?PNcLk9JDZtBdUm4OIyh9p6oVnhBQtfnXEVyx8U66fGfiijzQITLZE5Tv33Kq?=
 =?us-ascii?Q?aXhYhVOS1I3ez9IVZB9KK+iP4a/7zaxAmiUcC7CAyR+21uvsLMY5oj14KaAi?=
 =?us-ascii?Q?AL7cDyp1YhPw0agqWw6L+87shVjccrcrm/IEOBshEWAsh/EJvtTSeicdeF+j?=
 =?us-ascii?Q?vWiftbhEQ5RWZG4S+5eSdq8ITOrLXPEdUxnCMCBOUscCjNCp4ZgJX1+det6b?=
 =?us-ascii?Q?F9viiPzWgOcV9mTEjJVPzNj4z7Zy5Be66CR+bKbCZJmEAfxikhDz/r//9ejC?=
 =?us-ascii?Q?hKTqgh7Jo9GcFOelYu27W/h8xmLF2X+ebQDfGskf7gOavibPYot2vdq5R9sC?=
 =?us-ascii?Q?yH032iw01V7kOBuZXAmJBKV6ZXzIbtW9vYBneBxqcdtj0/w5FY2eQVpnA8xx?=
 =?us-ascii?Q?FREQRhFoXutgaPT8yQx8NfGBGoWbV3fKcKDqRWpq0vB/o/MD8c2HuQtSZZVk?=
 =?us-ascii?Q?OckMMO4kEpy0at1LdH6x8wtM7AAu0I2hHy5iugBd0IgEDurbm/ZbUefvWYKA?=
 =?us-ascii?Q?gSHSYgSFxZYngNfLaxm2GWyBl4opjLTOFJy3tfHqfHuZlg0rCWAiC2Sqon49?=
 =?us-ascii?Q?6LcK31vv03PEcNOG9hRyGdmfSQpCEcpLvA1PGIQkrukpU5ajBqNeJBVEF6TI?=
 =?us-ascii?Q?aQ1OWfAyByHybHgqZY07ruPJ7dOH+MwVOl6gTVl/x6Y69JhnokqKW1Ndr8/d?=
 =?us-ascii?Q?Pz5udEkH38csEY34oRvBWY8jtUgME6FdsQGMIVZd6h5740W0GfpI5+B/GMLD?=
 =?us-ascii?Q?HEQ/c84RIkyvBHWLyeSdPTKkxI/waXBAtkwJLu9dVU36uRZ29zsoTpFKMQ6o?=
 =?us-ascii?Q?pi9JcFRY2HycMfSmV+M4/lTsWJLilonFZu0Oxg2gzWjBkzeAnQejBjp890hd?=
 =?us-ascii?Q?xIcKrRI0VSfkTaJ7FFxuSxU9sV4FpD0ezUM6mYRA34HRH8SSQrwrfRxjf0UT?=
 =?us-ascii?Q?SLoj9uzrCJ9XLOr6aY8bQIqPQBVX0QhUFLnS2xwb81/2m0ja3p0IQV+mRvJQ?=
 =?us-ascii?Q?bu9bvqoEz3DCDtXdYi89TdBAeXDlYr7DlSoeE97Ug7Qf2q1t8LT0tSzIRMVZ?=
 =?us-ascii?Q?sduO9JrBfttPf2CputIAWTQjGoYxARzmKYrzU4d7DV6FOSNCdJ3cQF5SmNZC?=
 =?us-ascii?Q?t7ItEopxrBWnTCSypahsCQv3TTPi5BQhlJBWRqVmoGQj7JWBpR5yFoJoWTUd?=
 =?us-ascii?Q?SO7+WSErW2nYjXoO3INpZloCL3x5VYcydJYQL/Ddlxeo7A8cWGpto7M2acMv?=
 =?us-ascii?Q?W46+AQYEWtXdB1Umf7NE96+xJmLx23Uhm7FPH5kfEPXFy9ZHND7lbM/fPEtQ?=
 =?us-ascii?Q?1j4U9ctp1hnVHjzwRpElloFHtzTjvRjt7GqRuOZHmKi4N8YopT1UuNSLSWxM?=
 =?us-ascii?Q?Wa8EfBCCN1S6EyKeRpnyz0ZwTeNRF2h7oF8LAgTZUdBpAP0DMsH4QBL2pvZn?=
 =?us-ascii?Q?ECN+jBVBaBAnOrjC03ghP6UeFnCV/bhCu2lJ5Lf0ScQWMo8ug0fQyqjCA0nZ?=
 =?us-ascii?Q?GcHDgo3bOpzfvat/Wpjfb9Q7GxhI3d/JSQ7yuEwa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f0b6823-a90d-4cc4-1e61-08dc84c9944f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 19:07:29.2361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fl97e2fzGNnngj3ygZ3tlnLHq0zpT9QjDagJbMGx/swghqkNsi3qG8tXo7Wz3EYe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9450

On Tue, Jun 04, 2024 at 01:45:01AM -0700, Nicolin Chen wrote:
> On Mon, Jun 03, 2024 at 09:15:45PM -0300, Jason Gunthorpe wrote:
> 
> > This is on github:
> > https://github.com/jgunthorpe/linux/commits/smmuv3_newapi
> > 
> > v8:
> >  - Rebase on v6.10-rc2
> 
> It seems that the branch above isn't updated yet from 6.9-rc7 :)

I missed a push, it is sorted out now

Thanks,
Jason
