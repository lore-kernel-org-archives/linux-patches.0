Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2058.outbound.protection.outlook.com [40.107.243.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDA329B772;
	Thu, 17 Jul 2025 11:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752753531; cv=fail; b=n2hZ+ksr6Jhe2fZpgZKUyV2P5dkAEIktTc6qT0LixEcnXu/Tla7F/uarezt/Kuvd1+RFd4nW25q0fAxDHhnCbBcsG9hKvNiyS6Rm4hW2ZhUromR4DOfkbwmMzjA7McvGmNC4u3yyQZKJXjR4GxWMcIG9xTvSYG1K9sX5yPVeoR8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752753531; c=relaxed/simple;
	bh=NSohC6JGb7HbcnFSOX9ndpyPS1zawvY3LeA+0+QeejM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PVz5rQ0t9hvtPHzyL7pb7tLTXebcwNQhMMFe0m24ZkE/2ShTnQhaxA9sNC24hTDb/Xr4hMchM96whfmR5r+kYzGFoTn00I9dTqpBLQpzvnLgWQEwBd3B2svQA/OcYKJe5QzCcUUq+VqU8YKIrYg2qJe8fftlNhvq2/Q4BOdwoFY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BtQyinGm; arc=fail smtp.client-ip=40.107.243.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BtQyinGm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hXAkjaZuaQVXwozAYa+EhrbJ7Lg86NnK9TEhovfaW4E3E3LmitshlC1ZmtK+ilBbmYXyuKcdOAa7K39VxejTwoTfseDDdi5bHcfcJwioF9152UmsAJwKqz+OFwn654h3OhSA3urChnLCpiP/Hkq7zM2j7jNyxrB1WsdSjUQRTZpEhEKqGS0pPdl59WqYqPIniD1DDI+KFgX2fXJRuL/1IIDTmv0Du+sYK+ifx/N1ULxv6hwBXYE+E9gwhTQBHlMs7Tt/5A8AjTrqd8Z/y+OjWSPd1kMAB0KFNvdJAx8oUHdfYv7bD70J8KupkrHcF/liJRW5Au/ScQxEb7hoGC1nzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NSohC6JGb7HbcnFSOX9ndpyPS1zawvY3LeA+0+QeejM=;
 b=LTLg5UFnooXqf+ty6gV/K8VLd8XaDCUevr5iYRtFur508nbPDdO0NSR/3Wb55JLQb3q5HjaCE5JrNEPzKlY2dFhvE5PA0XCO4aOhUOqUa3cLEPA59WADOm8paV+9rX/ZFGN20gjPdK5DoG1iZJJBZH1Uz1zoBvHTdAncFc1rI3fj1CLb8HkjsZT8pgDcjSYnyIvW8TAM6obKbfs6kYR2mI0DGb816gnnbQRcfWzYqKidOoaMPxXxdav49HxrfAxV9cVctyu9yQv+AEqh8OPJ4gy1V9AMJqtJyw7L2tSPGF4JMScK3kMCXoXcuWUd6DSCdL6f+VrhqVSBqpJqGgNCFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NSohC6JGb7HbcnFSOX9ndpyPS1zawvY3LeA+0+QeejM=;
 b=BtQyinGmBEO6IJuliHyu10qxeVVJjapnwL+30B9kpfTA1Rfttmj6+VPR494kwzNORluMhr0wP/bUriV40vDuHO4qWId1UHQTL93no7PSXaQR7qvyW4Z6CwZaXKM1eIdAxwTonannVAVg34LfuvD4E/BmtIBcRiqsRwVYS9njElvIWh9l+zU7cDiLhXbNDn7GKbLz6S3Pv7XF87124bm5C7TBFIh4bpm6rGMAhvFjowKY7AIZ4lvZ2cPZa+QO5FD9p18IbnnSwU54dfPGc3AR0H/9TfPTdi3G4MiWe6QYzVQYyVqY3grPzGho1i2ZGsd6K+y589pv50AkgVFBv7+lcQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM6PR12MB4433.namprd12.prod.outlook.com (2603:10b6:5:2a1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Thu, 17 Jul
 2025 11:58:47 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.033; Thu, 17 Jul 2025
 11:58:46 +0000
Date: Thu, 17 Jul 2025 08:58:45 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: Vasant Hegde <vasant.hegde@amd.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <jroedel@suse.de>,
	Jerry Snitselaar <jsnitsel@redhat.com>, patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Ankit.Soni@amd.com
Subject: Re: [PATCH v2] iommu/amd: Fix geometry.aperture_end for V2 tables
Message-ID: <20250717115845.GE2177622@nvidia.com>
References: <0-v2-0615cc99b88a+1ce-amdv2_geo_jgg@nvidia.com>
 <16da73bf-647d-4373-bc07-343bfc44da57@amd.com>
 <20250716124929.GA2138968@nvidia.com>
 <aHjKjDunWlpF_aSx@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHjKjDunWlpF_aSx@willie-the-truck>
X-ClientProxiedBy: MN2PR12CA0005.namprd12.prod.outlook.com
 (2603:10b6:208:a8::18) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM6PR12MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c576fbf-cf5b-4ace-6c82-08ddc5294918
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?E69/JvqjEQxct1PopsaKFKB7vytvJdIAuKL3rKCn1xuYDfCFm0i1LPErbGN3?=
 =?us-ascii?Q?Tgo+j5IZ1v9WxoTAedWRu2B+YYkUY1Oal22T1+5ifE4mlMFa4n1/pCep3TWX?=
 =?us-ascii?Q?FDJWBMWSL5XN1by7cOjI0kRT6NXHH01Zcj30BRaUA4ptm0Gi59wf7phOAkZW?=
 =?us-ascii?Q?uPsPO1h6Yf5YCfftEM774BIRadZfa2jea75Gy0m5/Ih9dpE92ZgDC1tkBd3w?=
 =?us-ascii?Q?cZJhbxi2czUXw8uLYpdhc78SE0ClPPpqd88cKWMpOJGPXAeW7RmDN5GKQPcG?=
 =?us-ascii?Q?NHRJzvj1A0VT6UEyl1XETBt0ghuU0Iy6RkQzMhoA7ZG9dYfhUe7mB1pNK4bW?=
 =?us-ascii?Q?N9xIXdUoVYh+tNgBv+ic65qHEOyFbUo0qg5ExmolgWA0ZPRltiKEf8clg5CD?=
 =?us-ascii?Q?nk7YE49fPIBPvi265OlaYlU/eDdV72opa0ImsxUWfcffgt0IdyhKLf9ik0DM?=
 =?us-ascii?Q?hil1CY0Z5LdnbMuSrVPlU4S+Y44qN6LieTWk/pukLlnZ3gttR21qVSLId8K3?=
 =?us-ascii?Q?bKlltODaq9/v1q7srTh6D0e62CUeB6v8GgBxbjtW3POTdmS058yNjUFqwrTF?=
 =?us-ascii?Q?jUymA91IkpSK7CXoC9Q0FudrBAahnExXMCXZ5xU18sv6/r7XhuLWnT/3mNcG?=
 =?us-ascii?Q?Zqorz8KmlDeJh8W5T6GqVXvFyCx4iJAltRI0Ws9apynUFjmvBto+URLVYSsA?=
 =?us-ascii?Q?HCgOso30wmRzQPy/XEs5lm/1sFyxgJ4hEMT2POK3AWGJ3Fj6rSiALIfHzkhD?=
 =?us-ascii?Q?QILu1n9lrGONfKdJ7C33E93vLE8PkwafxIEzkZ1FvT5wt2cyojd4ldpwKFfv?=
 =?us-ascii?Q?P/LUwJ1BwPjeyyxIMTWDCAYyHhZDHU81Lf6j3XaF7lI0171giMFrDTMMQKcI?=
 =?us-ascii?Q?MKOcAxHhfYrzDCP2UzNTwCwIG2L4D9WN8TBb7NZESz84NEsN+iTYz4lMPpvP?=
 =?us-ascii?Q?FYQ1F55DCLyR3uHUWn0ZuKaUrGfpIofXnsKfxc+4zP5IlYCeQeA74JBmJJe4?=
 =?us-ascii?Q?9wjI7J8BBd9szGv4lqZiVBX3KY3sbul3D+4hgKeAz9iYJ5Rg2G2P4PwkDhHy?=
 =?us-ascii?Q?HgdraB/xeSJjQsjwCK9KAHZps0xtsaG2nxr/gmJ+sG4T+gBdPff7s+9tP1TQ?=
 =?us-ascii?Q?4Gr0vyIZMOSHf0FlXxIcBdeuOhebo5fWCpg7BFsq35W/0+E4w0d1zmJuzN8t?=
 =?us-ascii?Q?bcUYKcHLiRHY8WvkSk8EZNVOngKeuk1b9ktqprR0M7toD3+ut0tnan75gSiH?=
 =?us-ascii?Q?eFeiwmEljyat22cdp7IKegvcpbhErzIZ4Opmx8jPfMMLuuaCStDw2K4+PYcS?=
 =?us-ascii?Q?eMNjpD6zF2mOBE54Uo8vxPPWz5fiXIgzjVLhPiNCbWQrCicR5x0r8n6BdmDl?=
 =?us-ascii?Q?loNBgZ7tFmRfzFzjwCQVCOrpvAWYAWVJG84y+/RC1dg7XWKgZVvdmcOOnsoU?=
 =?us-ascii?Q?boihpvh5AZo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NnCkoqYhyeooOamv5YMFzZDChSgx/VabNBJeT4sqpezejSU7WbfMB2eXvz01?=
 =?us-ascii?Q?TBZ32UtyVMkamLA/rljrJVcqJE5SGWjekkZumLIR+v/hRmFnxvExgoRHihw2?=
 =?us-ascii?Q?GHKqr2v9X/syhVfRkvTEkMkynZFtoR2bf2+iSGoZX6Apnx73CWuxxUHmm3z6?=
 =?us-ascii?Q?SKjb1sWjiibj2Nq408JNy3N/AXBxowlYSsWm5F6NCWR6Cop+Q1A6WDAszQ6h?=
 =?us-ascii?Q?D35PD6hDqvImeD5disGecCfB95OFOcoSyJQxaORaC0OjgMdZObRIOitYkV3e?=
 =?us-ascii?Q?GiJ3sJc2ihA91sVpqE4OSPlGVyBF24mXRU3gP1o1c3+SZxWNMzYJeT3t+aXS?=
 =?us-ascii?Q?WvY8zpYue0HfZ50i9lQESnnIqAuSGC1/feHBsO6XZ65Qav2H0svjCNJt6hOU?=
 =?us-ascii?Q?+NGhqMyf75a4Rv99kXn4HIcH+PhBPd4u9NNzb29nCfgiHJijT4zCltRhLcLs?=
 =?us-ascii?Q?uPwoxwGhZIL6fCcwPRTcGf/cizZvzsrXUD1TlHBHg8aTYSkU+Mqi1kZNZymY?=
 =?us-ascii?Q?hq2jCC5QX+nFto3MLMK+wyRsokUPg9rbuggZku8EeIR707VDPpzbH68qf/vl?=
 =?us-ascii?Q?AtUkjyAF8zSZl/Xhb3kXaUqy6jUDwp0XMyBlptU8sVkSYm1at0X0bfyApax/?=
 =?us-ascii?Q?UeqIE69MCcXYiNZIM9RojMF+FGoEiS/2Vi3Qz35pQhqSAHjaTpDcmTVZuVKV?=
 =?us-ascii?Q?q04GDl3FV/P27wgQN1snYo78qed4GA9jRjzyjE7md1xt+VLpbA2esx0ZEYMG?=
 =?us-ascii?Q?XPTZOQPEhYWBbgekfPx7ZtQ33RzYT0s+c966B7U3Y9M/P3K842jmPpTwfb2I?=
 =?us-ascii?Q?6YVRuruMQR/7HMpV8JMsvklAxh/iYyrP8Lc6jhovhAgxpfrbV1nOLPk0XGf6?=
 =?us-ascii?Q?bo46q9/RxSvqP6G7nE87uV/oUSzYzvU/kZAid6WJlXd3NExMtMJYCCz4xAva?=
 =?us-ascii?Q?rS27rsFngJRtc2CyERJwMKkbtu/ZSfW+iqrQHjFjTOfrX7+/J1B8MZ2kFEZ8?=
 =?us-ascii?Q?3TeBSdeXwN/9wKh8MjMacUjCFSk9NlkXU7Z7ov3Q7r6e/NEJLFdZnSpAyEfp?=
 =?us-ascii?Q?VT7q5T4Sxe/LH1iDAR9nCqraXjQhiE2GI7lozprqY7CzRBW9nNDjW5dBtoOF?=
 =?us-ascii?Q?BzeXwzLEF3PZg2+jw65twoN3O+5nHFk6OjgwqeifbOEgQWJukZneaeIM8CN1?=
 =?us-ascii?Q?e/g1ZcPHjc5GtJYEJA/3XzBA4hM6U3RvDpHUn2qHWzWic90uT+vMBaTla9tL?=
 =?us-ascii?Q?yXbmIOPtGT+8pxtqDu65b19pQDWFWlKQwwQki9VfkRD7PYlLOMm4UdCwoiJ7?=
 =?us-ascii?Q?hbTFS3nNbba7Qcwmnih+q1B+43qDFfV0rZY4voF++ejcad+rIhVMDfiWcegE?=
 =?us-ascii?Q?LJU8K7cTBsR/nrakLrUbuX9j8LHhnOqJTKvbTbinfSDFHTA4MUgbFr6gOO3G?=
 =?us-ascii?Q?SekJUyg1FjwI1CCYpWrfUjq3vUT3Ja1ntXB2JAJIT9bSfGV4TLO2e65m5Ti7?=
 =?us-ascii?Q?6XyGQQXvxH6IBCA6diI472keVsN16LCTsFPTQV+CKJdrxBC7mKmaMUriyo3P?=
 =?us-ascii?Q?4gzuJDH17jtE55fj5VPVZ5CtGsFnwivMapZeLtnF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c576fbf-cf5b-4ace-6c82-08ddc5294918
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2025 11:58:46.8872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /3LcuQJVHYdNvIHR3akGYmxgQwE06IlnY+TfIOCIw6XqmdLDj5p4HVbDYD10AFGg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4433

On Thu, Jul 17, 2025 at 11:03:56AM +0100, Will Deacon wrote:

> thanks to 025d1371cc8c ("iommu/amd: Add efr[HATS] max v1 page table
> level"). I'm assuming that's fine because this change is about v2, but I
> just wanted to highlight it in case there's a potential issue.

Yes, this is only about V2, V1 is OK with the HATS changes

Thanks
Jason
