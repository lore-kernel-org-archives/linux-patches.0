Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010062.outbound.protection.outlook.com [52.101.61.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14AB925B090;
	Wed, 13 May 2026 21:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778706199; cv=fail; b=NLyv60z3SuieJE3Tz6bp+iT2Gq4fKG/mk0KO+1udTwMfvyQOa8vzhWFUfBj0NTte/AYPAYZ/FJ5Ye7dQdShjPq7cnJyJhAC3wjFhH5EZZI7e3v6IZUNM/Fj/0kiiffit2g2Fj26aAgBSEbG1HQ8ls/NgynTW+oM+o7ayDC152sc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778706199; c=relaxed/simple;
	bh=g3R0Nz0CIGXGdp0F0H3TXJ+Ap7/b9j8WLLtz74nNVjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LH9qa7u1H5F27ahcK3XSXR9SZeM4pEbM0Sn+vLeQWKRTqJTszGXKpQt+5UQt+5ej17S/pm89xZD0Xnuhd37fBusVJdZf8pHpwKgx/vrmrNNNAujH9a+K51PGx3xtWTpkUgOCytsznOocK4IsHHbKEaFjLhihGYzLxUyJfIcWpLk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=h5hK33bm; arc=fail smtp.client-ip=52.101.61.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="h5hK33bm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cNlLE01pXWgOER2onvlOl2lk4rQrUNWEnyN0Xd1RbvRUZKrr8zzVVsJ83F0fhmcO0GSeLUqs6UqGxpd/Yl3L7JXFF4i1siBqmMCVECeqgFBK+BZf2vGJwEVn9Xi1lqaYus947PIlXrNlJsjevBLmxTCmQKHmSe1CEi2PA67w8SnoVThFWMUGNMdU8x2MX8OjzFLKy+0SaGnLnM+z8fDZyI9vPR23yDzfrELMehE6KmgQm10aU/w9QOm2Odt7wj5Bkl6+K5IaYQVNID56S9vTFPl/yHOSsATEmLYKEuq0oIjRSVjHryfqKqiTeqbiH1BBayQjd4h1EyKgEpGMl/YS3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lREto4AppUnw+tr8RUeBIppAL3Y9YWPfxdP+41jZsUg=;
 b=iDXqLbQZH0n2U4x+zQvN8HT5a+PjfcQVbLyBeHkmr4HeKBk4LOqec7yP5+8MlNn5KIlNob+wZ2UVfvXFZLMYyx/ZVtDAkkQevrPTH2z0XF67uxojVWAJYJZHFpUKtQgoFegpgq0gcFAFrPKmlGgCzrnxIOfvM13mFGWjuUSrJqrd+ZeGIcA9LHHT27y9JYK49W+lszAq2lGYx+h5TdhickjaQZS5DWmrZ2PAzL7WUqpDFfOmHJDO4Kp8iOJHBatF1RQqBER3Gs4YvAGijPoRkAeRsOQCCD8JxB6nvT5mYv8WszzWOGuPh4xjho1IC2Ml7A14BxP2shC5tmZhQI+RKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lREto4AppUnw+tr8RUeBIppAL3Y9YWPfxdP+41jZsUg=;
 b=h5hK33bmfr/JwAMm658oTXHfVdymwx1Le4GgVs1j/a/uup4DrG9HMZzJC47umddmuCGaDoKajQp8A1NQl9gYBOCdWioTbn0Aee3pP45ElLO5spOtonWkp4z71jNbeTgCq5LqbvdOKDny0prprq0zPOzvbgDq8zaNUDyvgCYKQBpuZAvf4UtesxAsOBN1f9T51sDwHxiZCkrWh1R4c8F1VxwWLpAiIhp7+OryEXdtdJn4Gyk2OecVEIoAoQy2bWP3lsXEVS2To38eNDTyTaiViS7vXxyJEgrHQ0Nky4uDJcg/sGKm81qpaypS9Bd3+AOt9ZyoCZzxZHCS3o69yA9KdA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS7PR12MB5933.namprd12.prod.outlook.com (2603:10b6:8:7c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.12; Wed, 13 May
 2026 21:03:11 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9913.009; Wed, 13 May 2026
 21:03:10 +0000
Date: Wed, 13 May 2026 18:03:09 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Samiullah Khawaja <skhawaja@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Josua Mayer <josua@solid-run.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Mostafa Saleh <smostafa@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH rc 4/5] iommupt: Check for missing PAGE_SIZE in the
 pgsize_bitmap
Message-ID: <20260513210309.GD787748@nvidia.com>
References: <0-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
 <4-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
 <agS04F8UmZwWZNao@google.com>
 <agS6jQII_2PsAuZh@google.com>
 <20260513180607.GC787748@nvidia.com>
 <agS-MDCnoofhsBEe@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agS-MDCnoofhsBEe@google.com>
X-ClientProxiedBy: BLAPR03CA0112.namprd03.prod.outlook.com
 (2603:10b6:208:32a::27) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS7PR12MB5933:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fa640ba-e1ee-46b9-ea60-08deb1330a3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|11063799003|56012099003|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	+h/nbZYlLyB/iuCPCZi6axIKUQX85cr6w3ex2/bUubqRX8B6OJ4nbRQEeGeqO/GQSfLH700q2I6hwwcPCWPjTfLjBUvUABADFz1oZvAk6ofMqvcJ+FOIc9LBusYRBwpa5zFMPXkEAmlH2z5EjhAwc73Fxabv7FrNfGfkbodHiBQOjEHAvAHzUfxh5foH8JVZYpw4WLthDX09hqfCICTMcIbSlTeZxD7rd1qeSHkTxfRg4GzcW2IjPvIKIwvQ0PyU6yL96S6eJ5qOGx6X/3YoLEdYciL//I0RiCEGB61FbPK2aZGL9QyGoyDMlUTT+Uij1oIhJ6LPBzPcb7uNny2jxnAYMXK0nnz6uTdZAfspRn4QqvBFNwonBMyE9TTCdgqQIsSc6c/k0rAYbrVcppQTBjCg74gLwK10MCQIBjP1N6LQqWv/yKlhevllUb141HsbDm6XtjOSl9FowXBIwog/X/2AB1WcvrYDpYhNNrARVB9Em6S9U1HPVFSwktDS41UOjWExRi82DM8eOFyiB/nJYotZOUFC7K5CoIDbXuvwxa6Nnt+b9+GyP9WsaURqPy/74QYhBGSp7A/tL/RUtnK6inDhMRb67VJBMtYgE1fC9INtxQYQ4QCTHMmVMB7tRfsfnsQYncxiAIMYwSmxNJIduYGkn8In+XtxgFOkZGMtsauE7E3zKM13D+Y3/8GD7L6M
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(11063799003)(56012099003)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?J7JSzTfQe2Xsb6XxsI50RxtBeLMtbZAI88HHiBAodv/4q6xap+KhPMKmCat/?=
 =?us-ascii?Q?TeElGjRlezQIPFrKKSmrOrxgAdpA14OcxbUMBasYy3XLeqrVkCfVbvC+WHT2?=
 =?us-ascii?Q?9l+NIEOBTfhdmJ4LYpiJ+eXdcJpwABVpwDwCJrXM4XvSdWk9U/7+UmOgBjaM?=
 =?us-ascii?Q?XmukIjfGb+Y2jUQf80qctogDwxG2EG+tDKGj5a4qgonMJKdfagDQ76OWpotC?=
 =?us-ascii?Q?xlFatLo43EWNUwtMgfVI003c1wt8VY0MkPXFXsqcVNTJp0KZybB89+8hxi18?=
 =?us-ascii?Q?T4Ia5jKHo5TuTGfmxnXleBA7+iJ/LED0pcJvTbWP1hvV28Ym3aVOg1n+v07Q?=
 =?us-ascii?Q?mi/7B/Pz0bDnc53iB2REybudv+DxzGQvciWcla24T6iPtUBl91DaP1F+VtnH?=
 =?us-ascii?Q?N6YSQJkp4bKvOqu62Ts1lraPiZNIMHqHbEQmn/8t2246eo96MRA98yk3d3IF?=
 =?us-ascii?Q?mViGpdj71jb5BFhFHuqYsfL1IP9BaDR+6a7Dr87BLJ0x0Xqxl0HXwrEyg43+?=
 =?us-ascii?Q?4A6/KYAaqzOxyg+WcoJLCVOvi8N7xCcByMyGLb2twAdb5+VuQ7do00Gwpx4t?=
 =?us-ascii?Q?DuGD1weXOpYWljVr6c2tGNQy0Otr5BTXEpJmParAqXTqkbAJ9VhrHzFqVevB?=
 =?us-ascii?Q?12R6a7bJPjO0g8Yr1u219K3twsEORrBz5exXGykGenK2q1ixl/WtmwSpVtEB?=
 =?us-ascii?Q?w/EtJ/fQCofkBc7kDIHG470kuc1gGuaPztrUc4tR3TGmnE2zX/89nvTOk0/e?=
 =?us-ascii?Q?8NFIqa2kaYg3e3hOBzohniS6c3DTmC9ev/xYzYvRCQFTzOn0rvztNRZoD1iO?=
 =?us-ascii?Q?xI7mGlE9C8i2VLIq/ONdhJPhpxUClqKOL6L6qjiFSGg5P4wrumTvhDZ6DpoD?=
 =?us-ascii?Q?WKCvaCHzgIQCbE9AwzORYfiF8FabnI3iaqKZjypvleXlJG9reUXpq4Woz1Ie?=
 =?us-ascii?Q?xJ1UMpEqz1BcOofhm0dTuevAy2XpCU86LGkTQf8dVfE9ALWm04cmDU4bXytJ?=
 =?us-ascii?Q?ChW1wsbsj7nRYVnjOxpb34F+YV7l3jA/t5EuQlvAU1ev8Ft6ETXdujKiZBYM?=
 =?us-ascii?Q?BtZftgJv1QYsPpj6qX3vahSeZDsxupapSD0tY4+ptSoxjxAO3YdiuL06/rbN?=
 =?us-ascii?Q?wnHdF3Uf2eZXDz4Mg/mx5rzYlTXitg71SHrPYiGCgENVdqnbs5bNj61Y0WOa?=
 =?us-ascii?Q?5nxYSEDWeFpMXBlrjNi8HlF8iPTAxrpLMljffpvhNtEyblGn1iggcxbcTbhO?=
 =?us-ascii?Q?v44cGREvh35qgZyV+4ShW6anVtVt1hUuyKpabSPy+8qyV2QsUqsUgeQRJ6ht?=
 =?us-ascii?Q?/VzNpfPlP96ivYbtkZMrVh26wUxMvac5V/Mzm3hn2f9o+dTD7bOiqNK4EgKQ?=
 =?us-ascii?Q?mTwyhRDCMmrBfzhL5+sgPHDyp3O1dl96Er6dAkYzWP6fEDSC4zqpiYBxV6a9?=
 =?us-ascii?Q?H7tnZ3j6gNG/fL+7fnVumVwLPG3rWTCd5oj6hEE46KC0KA8CATJCq8MNPg/k?=
 =?us-ascii?Q?TzzqNINWYYpcFYCF6/13SSsPi6/NI+nHDaXEP8tIIYT4f7FbIi5FcGFYGda0?=
 =?us-ascii?Q?pV8YJl/AzGWtbiul95QtXdVtgeJE1Wrx8wlKlAfo8zGppJexLcDl7X0GBjCh?=
 =?us-ascii?Q?oJv82jbOwUnUP2z7Zgwc3Wa/EDxSwLmrc8qDk6/bOB9EIEl9ywDYJTssLkwt?=
 =?us-ascii?Q?5cajzl6bOjTInAuS+ZT5hTXblLGcCfK1FYpdUjmQ5CHy3gSw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fa640ba-e1ee-46b9-ea60-08deb1330a3d
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 21:03:10.9104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ezaz8QEKlJUq+2jFtk4Ohx76FXmc46gLauhNOv5wdhI2tgcRXu18gM8LhdnuOdax
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5933

On Wed, May 13, 2026 at 06:48:26PM +0000, Samiullah Khawaja wrote:
> > > I wonder if the error handling of iova and paddr alignment should also
> > > be deferred to non-fast path? Basically lift the iova and paddr check
> > > in the parent if?
> > 
> > That would break support for < PAGE_SIZE tables which I've tried to
> 
> I was also thinking about support of < PAGE_SIZE tables and wondering
> whether the < PAGE_SIZE tables support is already broken. For examples
> consider following:
> 
> iova = 0x12341800
> paddr = 0x56781800
> len = PAGE_SIZE (4k)
> 
> But pt_has_system_page_size() will be false in such a system.

Yeah, it will be false so it skips that branch. The main code should
be fine and it is covered by the kunit on the 64k arm systems, and the
iommufd self tests on all systems

> > keep generic support for. Similar checks already exist in the generic
> > code in a more general way, probably the first is
> > pt_compute_best_pgsize().
> 
> I was suggesting to rely on the already existing checks in
> pt_compute_best_pgsize() to do error handling, by only entering fast
> path if iova and paddr are also aligned.

When I wrote it didn't think there was a way to trigger it falsely, I
wonder if that wrong.

Yes, it would be easier to think about if it falls through to the slow
path.

Jason
