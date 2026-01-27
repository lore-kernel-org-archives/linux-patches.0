Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011020.outbound.protection.outlook.com [40.93.194.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2306242D84;
	Tue, 27 Jan 2026 15:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769526599; cv=fail; b=L0i0BmIINKMqVXWuCU4XbyTvQ8mU8iFfr+lcM+Ni+lPKldqEAFn1FtbvrwJBCuMBg+YXL2qjp9yrImRUrzeUp+PmbthMDZaungrvixFO3iBDMn25TX9sTb8Ieo5v56lSw1rkKFOt017bktYJGcXGXCGibtV8DpWxq8JMK2U8zeA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769526599; c=relaxed/simple;
	bh=2/5aHQ7LOsVpbYBZL8+5ra5hQkoTJ8DHt48Oic3SN0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dpk+RmzCSZv2uI5RNokw3xcX/n32UgJ7cZqhQdyHE8QB7XhaHSr462BMFZFVgN1imbsE8XHoGHZiCHvpG/6Sur/f1hf/mCSP9bs+dYt5aFFP1LuX3G6N40GnqqsfC26YFRfZhqc4tn6wY5jKk/4W/ybCf/Ozt8OIw1AdPNwL+k4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=H3wsFYpl; arc=fail smtp.client-ip=40.93.194.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="H3wsFYpl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TmIZ0o2yJllspIwITrzmbu3epFvHhN8FZ2+UBXGKP9nCuCwNFR63RXRuhA2odamYLT42QYIqf4ZQ8bgehmJAs/QS7KKLqnsJPSStbUhR7erc27KFX4PvqME0UvlJb/Yc24VZwtKBeDqeasI31FeMzbVuidh6R7WRT9y3+9JMMwxPLDE9KT7qWeKzBWCcwmAPlcByCvfLgsayO42/9SofXrEc1hHD6p/bj0wNs6+Tjl4ePETlhHORD7AnvhMYfLfA7ZdaZH9BD7OOn1DokRzk5U1Mi0wqJvHEZDAkUlV0b2R02zRuXrkOIMZfXlfmpCSkTd66TzVRJ1zN/ZUNjdoZpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZlwMjtNZBfdAG/DMynkLELRkWMXchmBi/K5kvNrKkYY=;
 b=dZp/HEBERYyz+MQ6I366vje0sWXiQXvC/P63wgahG7Mcl2OEwQxYrV2RHYyWGtTwgLK+i6GDTiPx7DEWpedaGfVttiumCQswFjzF9C+oMlidtcCW8C9R8EkeOWm1JLa1WWCeA5qruayRADGyx7m8E5w7fzLlV68pwM53Tv7CKZ0Mpn6EJNTpOFw/XydJID72Mhb6TVwENble8yE++LvX3YTCKF515QOkfIrsGRWkFB23LCxFJdLdVtngD2iW+4GppTdQW7zMGx1SaLS6jtyWrix3+dSQvnzZZU/6w9IwZmQMnGxtDqZ+qIuxAL5w4a2rn3ENeJG8piGzQohLmfBDEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZlwMjtNZBfdAG/DMynkLELRkWMXchmBi/K5kvNrKkYY=;
 b=H3wsFYpl7tbI/L1G9GacekWjmUOCSd+YC+ja1zS1V/5QtrYuxM3L17m/HUCNIe9XcGb3o9pfZsWNOgk5LZ0n/EubOQ+Q8DuZU1PtnUGA0LCvrEwHxfBZvnRIbLW2mzJ6ilFU00eZZghyPna8iom5q4r0SF/39VplAbc6wtS8zOTbO3fSqUm3L8BAExV6llV27GAX6nVr5FkTWNePDER4jCZ3mnN0x1xQ/EEg9Z+kgS6BPI2la2rehelkFUDdEi7Yg3aTwNd0jokEvikl0aBRDZ0DeIZOWNnmcA1n4PhwtQvvONVVZWOjqPNz/Nhl/MZG1WmwbPFsZ8WhsWuOcv8f1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS0PR12MB7704.namprd12.prod.outlook.com (2603:10b6:8:138::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Tue, 27 Jan
 2026 15:09:49 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9542.015; Tue, 27 Jan 2026
 15:09:49 +0000
Date: Tue, 27 Jan 2026 11:09:47 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org, jpb@kernel.org,
	praan@google.com, miko.lenczewski@arm.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2 05/10] iommu/arm-smmu-v3: Flush iotlb in
 arm_smmu_iotlb_tag_free()
Message-ID: <20260127150947.GH1134360@nvidia.com>
References: <cover.1769044718.git.nicolinc@nvidia.com>
 <4ee324e4f189fed601f4d947af10393b14dfb7d8.1769044718.git.nicolinc@nvidia.com>
 <20260126210833.GA1134360@nvidia.com>
 <aXgpZJTWGGVrvqv1@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXgpZJTWGGVrvqv1@Asurada-Nvidia>
X-ClientProxiedBy: MN2PR20CA0020.namprd20.prod.outlook.com
 (2603:10b6:208:e8::33) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS0PR12MB7704:EE_
X-MS-Office365-Filtering-Correlation-Id: d884597b-c94c-414b-0db2-08de5db61d34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jpirs9vipZzzs48zyEaqPLcGDcNrkmvCln65yql6xy127lHBA8em8nsI2OF2?=
 =?us-ascii?Q?1uC6ZgkvfQ8GF+qkcMQQP7jg3QyAfIY/mww0Qf+U8pLq2zTBJwDrC5rX6/sq?=
 =?us-ascii?Q?gaD8R2olpPJz3vAhV1B0elBhqQE1TieCH3bhgNt0+smpG+kl/AfUDc92BT9x?=
 =?us-ascii?Q?/K9h8OlYWke8vOfj9sOa/wTDb49y1eTPudx2YLC7ywZRZWcHEcNctboXKrsn?=
 =?us-ascii?Q?W3+3cwXJU2CazbhumcouCZYp7N3ftev1Z7VM4FHmNcxIadlrJO+KtyBFW9+3?=
 =?us-ascii?Q?rxBGOyL3ydAKTwLwK5WUfYaCGqxQVn8xKXDWXaM94ZeTdoM1LOkkxvWr1LUU?=
 =?us-ascii?Q?6B3k6NZNxW9xxjA6Avp9iz7DmwrOuibipq/tnPXCuf8ElqR6fglloJfssT6A?=
 =?us-ascii?Q?Hbt2UXoJx/RE3U0N945WCwMZVhoNCI6gu4h2J7DDgTQDpE8yrthsihUpu85/?=
 =?us-ascii?Q?KkxgRw/58mPosGW+QwT6IrC4y8d95MgJyWKCZN4g5+BUJo4EcKOLoL4YMapM?=
 =?us-ascii?Q?eUKaLiSvgHyk3LxvNT52Ar7XvlJoLg2AiqRr90Cl23jNIXi4aWdMqR21lLu5?=
 =?us-ascii?Q?BLCMKejNNqiyqHGMreMymZwMKKdpEDGpcJeSG+NQWUNCLMH7+4I2OCnbWgE2?=
 =?us-ascii?Q?SHdKzu8wWdYWemNO0VNbSLupG2S4YH9c0ab4SC2venk0qrzF73P9fINYUSAs?=
 =?us-ascii?Q?TrQudUpitlzIHbmFba7D55tNswCEdHpBDDt0aAIQz9i3NjbPc9ji68JzaFJ0?=
 =?us-ascii?Q?QMjzVNSky6iIMCPVJOCexb2cHWssMckiV2kIfBbbYBIPQIvTdY1a1JMfzpF/?=
 =?us-ascii?Q?nhn4EW/27pmjgfs0uIur4RU1Mb1flzyJMW3ugUdBU8FxTf8V2Q8KwlaOs+Vx?=
 =?us-ascii?Q?xhqOghPxldyrCPBc6jygWfx3gY9whrorZJIuE0uKzBoRWKnT6ZIrW0Gwn5u8?=
 =?us-ascii?Q?hSAZljM1JlRqA9OdxD+wrblASJ7M0nCZqlubaRUOJHLsNCl9+fbGOPAJz2p/?=
 =?us-ascii?Q?ttQ13Hc7AggqZH37/h/HFzW0+hC5ATaQNFYcg7/eIw2iOxJYlSAt48Zz/J9K?=
 =?us-ascii?Q?jjuFjgg+N6ixXaYKWZSHZP0r3cnMkt1Ct5jpd3VUbk6WWh2oO26zUJmhMOCM?=
 =?us-ascii?Q?CQZ+zBP4zLA5PhhFicINAATHgW30qqDPN1rAON2eOm+QZU5pULPIs2lTMWqN?=
 =?us-ascii?Q?XtAokFACFJLer6+SfFtG9/f1s68fMsLLBy6O2vIWNTVIzaQ2RT4cjJIXO6K7?=
 =?us-ascii?Q?6aQqJeQBIwSntmB4UMQMAiw7d+e7AyGrjcMBaCUPF6vSoMtlJqyfn5ycW8I4?=
 =?us-ascii?Q?2mYC0Ydzm1rsItZDIgR/OppJgD13YWZ+MzY75w1Vmlkf4eBvUWQpN58fpil5?=
 =?us-ascii?Q?q/bmmEoMFu4XsPZlhO0bi1e3BhUKDU4rw1jM5fuaHgyU5qEi+JdHvObBGPE8?=
 =?us-ascii?Q?bxCBo5ErCG5KFdzt9Fy6DytcTNIIZhaiRMv4IZpZs2EjA+SGMpXCMB/IQryJ?=
 =?us-ascii?Q?7Qpqesfw9xpPc3GfWTSNXXqWGmXZA1QN3kzdNciYxztxSvSFD+Iu2vdFqomq?=
 =?us-ascii?Q?Ai08KmigN1lJDl6kV64=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Cn8NGmqOb4XRMAfwxCrw4R3ZlCA+g+jh+kbbgBFk3s2lFzLJoV0pe1aMCvZJ?=
 =?us-ascii?Q?fcyKnoLYso8K+siGguijtuyCAEL0PcrWlxj/5VPlFDvRsVOyKAwmqh2JWpMs?=
 =?us-ascii?Q?yKfp2uYuVYpf9N4FbpWkvN/dbhucA2ICKu/ZVchaRF0rVpsPbnO3kI73TOqO?=
 =?us-ascii?Q?zM3V7hmblTRu7r8siPbpO5XKoDBJlYBLK4QJ1pNopoj3ZRw3DE4zBNMFTHhJ?=
 =?us-ascii?Q?BFSFxZLxb2V69LkXTi4wl6eeSqKXh0J0Yrr/rbfWZsUInxXmBzUn8pw13sG5?=
 =?us-ascii?Q?ZtO3A+p9n8H+G35XN1H9T7IQmA8o0IVP0xmOL4vP/dJPKZBO6GKIyHW3YTqz?=
 =?us-ascii?Q?5RtOpbjmwny0h/SCkK+TYS88vNVQL8Uvg/k42hhR4wCXxViEyybviRo3q29Y?=
 =?us-ascii?Q?DUPfoAYnncxAhFK6nhQtrzkiZELphFtuwC3Bc1J+dL7ydp0ZuvW9hdVfv9dj?=
 =?us-ascii?Q?iL6spOssbAgf4RoVNyDBlHLMoe7sC5BmAFeiouc5d3rQG/r5jOXdk+sVXy3Q?=
 =?us-ascii?Q?oxJI7pq/4ek1HOXZ3icpILpuJVNZZl6/dJ3jC7KZ799GbGwL1RqglEU8CCP8?=
 =?us-ascii?Q?9/WQS71zaC/sEIDK5+/E5GAxnuatKPerDR9oL/pdbmPlXpk0uh4adq/L6kzM?=
 =?us-ascii?Q?G1ZLBtme0QpWAwRFId6DCooW1tYfjroHsmsc+BokoQljnFOycBVikpHsXStr?=
 =?us-ascii?Q?0SrgoKqbhdGKKP7vAEbUmt2pF71ketzc+AQcGhfFytCwquiZBwPCo5GUfzhZ?=
 =?us-ascii?Q?uMB4r8AQQWuZ0KNZVafGSIL+bYZa8/bkFpOyqrkP2UhffaN4vtBJiF3yGuWm?=
 =?us-ascii?Q?yNPBB27RZ9yslnKY8CwTV4UGqVyYd85FMnM5LWTjBCUPVTjBOyI7kAodTDff?=
 =?us-ascii?Q?S/rO5ESeyBtXv19VUe47ZI2SO9JL4RVEahOPyszKkEFyKnGs97ZQVr1Paf7U?=
 =?us-ascii?Q?EbuBKBRoDo7JpxCLyj2T2qAhBy3MXon4cuzAgNWHhBFi6WsOhqTcAD6XqoAH?=
 =?us-ascii?Q?f4sH86h+/Ni7XmK+2Ooc05E41OckQPqPhhGpg64gr8v8zlPi1YUOKrdc0BbW?=
 =?us-ascii?Q?FOQGciNCDeDr/ki8GSimtQaxRk3Cg/9hP24fRdFsjWj3tl+vDrpuwIrerUPT?=
 =?us-ascii?Q?UawgFAH2h8KuEg3Z3uLXcb/9WC36l0/44kaB7VsVrGO2P4ovK0z0pGsDGl17?=
 =?us-ascii?Q?XTt5XFZI286yFFnNZKoG1kzQf7sosArHcd57dVp2rJ5Fxdz5G5eZKKk+pWVE?=
 =?us-ascii?Q?zarKN/FwKY0S7aGqOkbFpiKRQ+5YYEWafQcZEyxT/d4J2IhH4BK4uxKL7Dcy?=
 =?us-ascii?Q?W0NOSdmASHsFcP+EJM3AJ/ngA420CZcfkGynVzmandM07Xkz0HtkqHvj2/Sp?=
 =?us-ascii?Q?lfbK6eCgPVFuYpzbvSEUutYyHlz6dsf2I8vVKzxtB4ROTW99HrF4Y7/s/agw?=
 =?us-ascii?Q?LphAFAoIrQowB3aX4fEq/TSlQA0aamEvGU/AWxoRQ0ORj7tA4xrCKGUjPde4?=
 =?us-ascii?Q?6rACYBl6CWqBmyaSg1lefUkhAk7Avcl5ad+SZXvhRmg5vyeI98XFO7t83bHR?=
 =?us-ascii?Q?oVdPbqWYRezFjVTjB82PAzo/VoTVXTA/5myXxSF6P+Udxykd+SaZTShEMnPI?=
 =?us-ascii?Q?krUgrQ8N4iT3gEEF6R6lbySmrpwgCrHTT6tmTr+X4p75RkcUABavYzi/PftV?=
 =?us-ascii?Q?irR1/TjkN9wgTz6GqdgCDfEIcwA67cOM4OYVHshAbUs2tS1nPBUPYAJH/svn?=
 =?us-ascii?Q?DcVVjDgn5Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d884597b-c94c-414b-0db2-08de5db61d34
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 15:09:49.0523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jw37R8XBqi3ZD75bGwVxf1MWbtOD/OuTS/FR8grlJc2sCA59Fs41BYJ2eUjtb9FQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7704

On Mon, Jan 26, 2026 at 06:56:36PM -0800, Nicolin Chen wrote:
> On Mon, Jan 26, 2026 at 05:08:33PM -0400, Jason Gunthorpe wrote:
> > On Wed, Jan 21, 2026 at 05:24:23PM -0800, Nicolin Chen wrote:
> > >  static void arm_smmu_iotlb_tag_free(struct arm_smmu_inv *tag)
> > >  {
> > > +	struct arm_smmu_cmdq_ent cmd = {
> > > +		.opcode = tag->nsize_opcode,
> > > +	};
> > > +
> > > +	if (tag->type == INV_TYPE_S1_ASID)
> > > +		cmd.tlbi.asid = tag->id;
> > > +	else
> > > +		cmd.tlbi.vmid = tag->id;
> > > +	arm_smmu_cmdq_issue_cmd_with_sync(tag->smmu, &cmd);
> > 
> > I think in all these places checking the tag->type it is probably a
> > good idea to not use a catch all else for vmid? We have many tag types
> > and some should never come to this, or other, functions.
> 
> Or maybe we can add an assert function?
> 
> static inline void arm_smmu_inv_assert_iotlb_tag(struct arm_smmu_inv *inv)
> {
> 	WARN_ON(inv != INV_TYPE_S1_ASID && inv != INV_TYPE_S1_VMID &&
> 		inv != INV_TYPE_S1_VMID_VSMMU);
> }
 
That works too

Jason
