Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2080.outbound.protection.outlook.com [40.107.93.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888441C06;
	Wed, 27 Mar 2024 16:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711557777; cv=fail; b=ORa18Vead7AyYKY0hfvqvEBwTlYAPKfsfESSVS+MkPHl7QNDF569wBXtd9OoVIbHhwsW54vN1vEIzKUBrmy/rOqQnvx8akiTEsH9dq3SwL5ogt6RovUceEHiThEXUFsnGDarbntLPQTMXe+/6nHNLmPf6LzB4jSYwXtoQ9i/FxU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711557777; c=relaxed/simple;
	bh=N/aTnbAj7beEWJzkqSteIMO2704PeAmwc3FoYOD3MbU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=A1vDaI0Xgq3ZWYc9TF5iBY7QL82PUDBiw3utWnxjSZzNI1zFNRMJDNj3m/TkZzc2MgtPMEGlPc+39jcj+xFFBXdjOatQJqYBrA5UCHbKcqke230yUEWT9gkZp/firKJq6NffLowMPXlHRROwRKdFPXUBXO5pVcxvXXPQzDd9mgI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Vu/ACAvn; arc=fail smtp.client-ip=40.107.93.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Vu/ACAvn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U2Cg1MDQqGhrH/daPr+jcPW0LUUwH9Zg2pgy88pWW7e/1K/PwALUzyRrww3cJkIABUVVETnZLIgGb79QN/lyNYvwg9JNaaz60iClS+mczieD9FjjyBOiX4K9Elyom4RCPN6cyiQ3KxPiA9jHy0wYudQssp3W8WtEH0yaW0IHyJ5Y8p4cxuoX1MoJXBGc1EIawBD5/VzBzCxcm8R6HpmK49IXG2tl5UFIDbdV6ml5jdHbpVraaUrqPg4quWmNHc6aEgdappciCLUXf4hFykpNE8Nd2ra7TfjjbjjjSSDki/dwvKS54pKFpbvG12iE6HU4E3MEjqTsXU4OJcSurZy+Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dBYMtVj8WzKk2WV55QTynzdA6eh8syT1stetzHsyj0c=;
 b=QMxJotOKnzAXmU5ehKGUfOC8d6k9zhoC72syqgtpH/mH1g3v3H1SHPOmG0P6ggKmgqiHJdf7deDMhYHMZM8m7KUJsPCHBCwykI83v8X+0LPEGLkG+1/pdrAWCf/pgg7TXnbQananXV0Tovhq8TD+JHDZVqqmauNRxhBWbj1rodJwEOR4DW/mnoy8ur5HVm27M2Yl/w34/esrWQt+uLfQrMswdIZygpNOG30nMlJjaTIXdn7BLb+PUOREQY53Of8mGuzXos0u7vEfejPFxz+TbArVz5QVBdfW2JIHQj7xMTh6+DZ3yIJM91xIgRzwJh917BHqUYw3RC0YYcPuCtvyHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dBYMtVj8WzKk2WV55QTynzdA6eh8syT1stetzHsyj0c=;
 b=Vu/ACAvnm6xNzcMZiEWCGu1g9ZCLHg5EW8l791b2/hydYH3a+3w6WxHXBWntWnKXid6stcKDt9tloL4yYYcVTzpiGlVd0zF0OJ46bJKIMFlFDGgIGkNiM77Aceec/GA/0Pm8apOqxYxQ2smXh35advvXEBPipv/Y8vWaDEY9aX0jnLZIFCoXeYXklykSd8HN9HY235OF2Q9pAJRC5Sx197LTqSQsEwE/CAua5S+XaLpoBamXvXcI5JGFuugYvyg5gbqKshfO2sQaSJtXG4nqbU4s+PeQaK6Nwhqn+lR8Bs2hzUsnm6MRuhl1MMvR2dxmhlyg51vJcPvT7B1YZyKaRA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by IA1PR12MB7686.namprd12.prod.outlook.com (2603:10b6:208:422::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Wed, 27 Mar
 2024 16:42:52 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 16:42:52 +0000
Date: Wed, 27 Mar 2024 13:42:51 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 05/27] iommu/arm-smmu-v3: Make CD programming use
 arm_smmu_write_entry()
Message-ID: <20240327164251.GL946323@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <5-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <Zf7S109OKJlRVXiR@google.com>
 <20240326183055.GL6245@nvidia.com>
 <ZgMeNZP08aZu-nVe@google.com>
 <20240326222758.GB946323@nvidia.com>
 <ZgPqnzA_a4ZdYGXM@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgPqnzA_a4ZdYGXM@google.com>
X-ClientProxiedBy: MN2PR04CA0016.namprd04.prod.outlook.com
 (2603:10b6:208:d4::29) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|IA1PR12MB7686:EE_
X-MS-Office365-Filtering-Correlation-Id: 3569f967-c005-4b04-719d-08dc4e7cf1d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	WcjGtnKCrbFe44hIu1jL0oMrCyzBqJUJasOTFi4hc0pBNgObTPgDDTLTOEUscV27/3cZwNBT4koaoWUENyXRAEwRJbfeuZOjvcOBnArnx45146si96PqnIzM0jJ00yl6TUadK1j3U2YGTPxr53BhYXd6nD8aykjRlCR15LRMjm3OqnKwIVje81NYxDTGerRSg7OSGrX8RWJA6m9KxoNms/EkvHqlyRrm1dPrely1MiXFqSTotkoHMpBsqk5vBZ4jZoWTBc27j3cg2KsmlXE945FxH70K9C2/RDJvlK7LzLS5w1ecpm5UtsiykCyNBgzNUUG/qLzRlbyJ9H0Jj76RRYt3Xq/oazbhwVsmHdm4LkPVkP58CLIA7Cy2UCydPYahXdMcYlOV2iYqjWMm5H/2fEAWmAbvd9r7Xxt5dIXjiodrIFq1sMkIcqGktpRtZWwzpoXoMyLJGLZPAq+YKDbCR0adUxPv4cjp3ViLvtV5Loa6NI4WqgEkxGm+weZN4bOEy1VGV+zpu/N3QMBRZSrdX8L3xRcCzAdufbApDHvmN8Y3xxGaFhWp9/FEow+V/RpG4cbN3oVJs4D5pBPSvpkjA7tWpwnu6Z/CejM4RwQlDbGAWdISCOJ5dAkcz9MkeL/SaVx8lRmOr1rNLbH40StZHA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BeLeRcLGjrcTCrAim0StBFJ+FosxLCGq8p6Yp4bOKKlmOxIDSkjuVB/OWlgH?=
 =?us-ascii?Q?m38c5vf0A5Biao8TpV5JpWQTgMXp9ZdISyhRO6MZVcpA9XBpSIgwjzMpzFsy?=
 =?us-ascii?Q?aNJv4evZXVgsM4K+KyTikADsRDhuBe0bYet2BELPYXXezy7gGsIvMEFyBF50?=
 =?us-ascii?Q?O7wUiQSSW4Q+rdGLwhixKcWJa62M1WqcSO6sz4NsMtvU5xTBdlhKGpg2jpwR?=
 =?us-ascii?Q?odCuZtFyeUOsC4AyQDu/bJ2PzGQL8VmbQKevDcjPiDQrw/AgfdqB3tfyYA1n?=
 =?us-ascii?Q?ws9lBxN2cYKXo5FvclxlbAMr7yap2DWUeDXLjESK7W18DPCA8d3KUZYMc5oc?=
 =?us-ascii?Q?4sqSmkJ5xSqQRiR/OWx6FqVWTYvVJ4JXSkmhBQzz9dD841uBpM9RENL3+o7c?=
 =?us-ascii?Q?n+jJ08Pl+RmXhOjjqSF3AEgyhsKp+9mUyO8G8nNToaJOXCjE85+wClge7zzG?=
 =?us-ascii?Q?8ewauG6ZlVSnOtlJTlal67Hmr27uviMHZCCLju6ZkTSj/M5z8RoeQKd7tbBA?=
 =?us-ascii?Q?zRHECMfNcDWtN3fOKyXr+vxpE76umKp7Gibq4tvvFb1bDo1th1ZzMHII14mI?=
 =?us-ascii?Q?DUVfWk1mjK7mOJJfE8Hx7lDPe3i8foSlNOc4B5ylKwQCkURKR4Vhy7IEBi2k?=
 =?us-ascii?Q?l5p/B1tFRnIQbR24xlpkM5FgQH1RtMXW2o4yeBs+Bp06BE9B1A88Sna0W4EG?=
 =?us-ascii?Q?WFni29px+oYoqwdqcaccGnXPo9hguKWdvRAlKMlrUX/5hE2hrkkyP85wKUHM?=
 =?us-ascii?Q?1RAMpXSriMWpsIEiAjBUAsmsKFRJWkLLSKeAWS70Ke4WCB9xqgqW1yrHpVUh?=
 =?us-ascii?Q?fJOsi/3R0tdjc3O63egdZ3Xqztvbk8QBPVA6fUhUinhZ/vZDUxy8tADoNSfs?=
 =?us-ascii?Q?O62Are6tUDjc7Y/f5bqEaVCM2TclJSHPvA4t4lVqS76Eek7qHP1MoFX3NNKD?=
 =?us-ascii?Q?j27nCmof/4fO1nvZh/tAny81bVs/IgFJKyquGqdrUUQ3zmheUde4JW6ByXEw?=
 =?us-ascii?Q?xm+cOkBIAl0ctoswNWWJciu1HLpCiWdCkEA0A2OqrdDAB5fzNLWfBwgiUV2x?=
 =?us-ascii?Q?YtPKgZYU6cqw7LtbCvuyfzy6dgPv/tLl3OW6EKbM7VQo+FAliAuFg+ee5gb9?=
 =?us-ascii?Q?4qeGOkxFFXJ5PgHY5do9UILiXzqMhfxWOwgO+kXyMYKkvZQv9+6fEPEaOyAM?=
 =?us-ascii?Q?p/lxonBeFkPrjCIK0c3COzFS8HhZEO1nlZ4YHWfOoVSSz009KuyVa0IkWLrG?=
 =?us-ascii?Q?lmsScbyEqzfaThz0A+b5Cyw3V+w4QpNIewdQaO+IrZT2oq7Sa1XT4F/k/8Iv?=
 =?us-ascii?Q?ZK3tpv7irMWt0WxDLUFmOto2V089RnDZQYOibestA6XL7I9MNrwDHrg9soxR?=
 =?us-ascii?Q?mj1OiNM8qoz+Wi22aHGWvtZnSnMioZNpfE/eDO/Hov805BvOThRK4B+yeQFj?=
 =?us-ascii?Q?GlK1Wq29EO2nMB+eKXtVwoRoIRLh+XsNGpxHj63efDb03oussqDe/ExAssBb?=
 =?us-ascii?Q?akZ+dYNrOae9dWWarcy63R+F0lC4LJXM8yk8nV5dU8TyONpqo6JTQNimOs7j?=
 =?us-ascii?Q?VXpr3sNG79yzJ1dqt2uisQzIeLV+T2ZRMhBNiFLN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3569f967-c005-4b04-719d-08dc4e7cf1d5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 16:42:52.1281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GgD1m18OiEa8JQQuF4iNpFpZLOe+iUzpSifp4TTn+IqTDYZGM6nSbJuXDOuQpmpk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7686

On Wed, Mar 27, 2024 at 09:45:03AM +0000, Mostafa Saleh wrote:
> On Tue, Mar 26, 2024 at 07:27:58PM -0300, Jason Gunthorpe wrote:
> > On Tue, Mar 26, 2024 at 07:12:53PM +0000, Mostafa Saleh wrote:
> > > On Tue, Mar 26, 2024 at 03:30:55PM -0300, Jason Gunthorpe wrote:
> > > > On Sat, Mar 23, 2024 at 01:02:15PM +0000, Mostafa Saleh wrote:
> > > > > > +static void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits)
> > > > > > +{
> > > > > > +	used_bits[0] = cpu_to_le64(CTXDESC_CD_0_V);
> > > > > > +	if (!(ent[0] & cpu_to_le64(CTXDESC_CD_0_V)))
> > > > > > +		return;
> > > > > > +	memset(used_bits, 0xFF, sizeof(struct arm_smmu_cd));
> > > > > 
> > > > > This is a slightly different approach than what the driver does for STEs,
> > > > > where it explicitly sets the used bits. Is there a reason for that?
> > > > 
> > > > It is just more compact this way
> > > 
> > > IMHO, it seems too much to have this mechanism for CDs for just one
> > > SVA case, but I'll need to go through the whole seires first to make
> > > sure I am not missing anything.
> > 
> > It is pretty ugly if you try to do it that way. You still need to
> > create some ops because the entry_set should be re-used (I mean I
> > guess you could copy it as well). Then you have to open code the
> > logic. And then the EPD0 path is somewhat fragile. Something sort of
> > like this:
> > 
> > void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
> > 			     struct arm_smmu_cd *cdptr,
> > 			     const struct arm_smmu_cd *target)
> > {
> > 	bool target_valid = target->data[0] & cpu_to_le64(CTXDESC_CD_0_V);
> > 	bool cur_valid = cdptr->data[0] & cpu_to_le64(CTXDESC_CD_0_V);
> > 	struct arm_smmu_cd_writer cd_writer = {
> > 		.writer = {
> > 			.ops = &arm_smmu_cd_writer_ops,
> > 			.master = master,
> > 		},
> > 		.ssid = ssid,
> > 	};
> > 
> > 	if (ssid != IOMMU_NO_PASID && cur_valid != target_valid) {
> > 		if (cur_valid)
> > 			master->cd_table.used_ssids--;
> > 		else
> > 			master->cd_table.used_ssids++;
> > 	}
> > 
> > 	/* Force a V=0/V=1 update*/
> > 	__le64 update = target[0] & ~cpu_to_le64(CTXDESC_CD_0_V);
> > 	entry_set(&cd_writer.writer, cdptr->data, &update, 0, 1);
> > 	entry_set(&cd_writer.writer, cdptr->data, target->data, 1, NUM_ENTRY_QWORDS - 1);
> > 	entry_set(&cd_writer.writer, cdptr->data, target->data, 0, 1);
> > }
> > 
> > void arm_smmu_write_cd_entry_epd0(struct arm_smmu_master *master, int ssid,
> > 				  struct arm_smmu_cd *cdptr,
> > 				  const struct arm_smmu_cd *target)
> > {
> > 	struct arm_smmu_cd_writer cd_writer = {
> > 		.writer = {
> > 			.ops = &arm_smmu_cd_writer_ops,
> > 			.master = master,
> > 		},
> > 		.ssid = ssid,
> > 	};
> > 
> > 	/*
> > 	 * Target must the EPD0 = 1 version of the existing CD entry, caller
> > 	 * must enforce it. Assume used_ssids doesn't need updating
> > 	 * for this reason.
> > 	 */
> > 	/* Update EPD0 */
> > 	entry_set(&cd_writer.writer, cdptr->data, target->data, 0, 1);
> > 	/* Update everthing else */
> > 	entry_set(&cd_writer.writer, cdptr->data, target->data, 0, NUM_ENTRY_QWORDS - 1);
> > }
> > 
> > IMOH, at this point it is saner to have just implemented the used
> > function and use the mechanism robustly. Less special cases, less
> > fragility, less duplication.
> > 
> 
> But that adds extra cost of adding ops, indirection, modifying STE
> code..., for a case that is not common, so I think special casing it
> is actually better for readability and maintainability.

The above is what the special case would have to look like. This
programming work is not trivial. The programmer code was always
intended to be re-used for the CD and STE together so there is only
one logic, not two or three copies.

Reducing duplicated logic in such a tricky area is worth it, IMHO.

Jason
