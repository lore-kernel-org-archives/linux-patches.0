Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013001.outbound.protection.outlook.com [40.107.201.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263E31FF1AE;
	Thu,  8 Jan 2026 14:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767883749; cv=fail; b=LlA42SidTlDksa7n8NYFqbliAj6O4V0ygg0ru9jgbRbih9+CpPtz5OFHNQiTt1hK/QzJsRphIKM/gF03SCbSKmp0hDzHMrghBKj9Gu/8vV8PI7/lnOQbHbh845+R9HLFqY/90Fj9A97qYWLrftokwcvqORC6jfRkjLr1Cfe5Q4M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767883749; c=relaxed/simple;
	bh=v4uy8JZALog5Q9GQbie2b+y37Eti2vAo+o0K6KLv7/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=p5WOMAEGNCRUKmJbpDcXNrKQGMqcHCAwnP7xLfhcmHwjiK6U8UpmKcC9gVSimX8MI6mARWEobGfo8/+4n+24zLi2sZxEEFMT7nGpo+1k+zGklb8qBVOaAULAP4ylmeQJBXdmO5Lo4Aj4fuGKc9a0a2Pz7N/a0LVFIdSKOSFbUcU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=X5qEjZaB; arc=fail smtp.client-ip=40.107.201.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="X5qEjZaB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YIehypkTkLMVyVAYEur/jJA6kRBhESAXxZX49D4Wkh99sOdVb6Ke5g1/gndVT0nTspMZkOZ6i9geH2dRjmFf5fAUcEMLtJ3cQFhMynM2LOWUbcq3rzDDTfNIMidAbQE/QF4JVA/uHUD70vOKgXA+ILOBp8gF9XiF/VG8il8x9jed9zGowZ0qyITxP0ss6Y7J72DhwBhDYW96//QBHAqBknl7rlIvBmIFdltXG9EYqQoka0wnTGUMxLVGzW2VRFYwFPaooWRZz81baS97wT5JtfLztHGm9tCs+4yPgWonoA7RG8ts5iCiPRyHJw+j8sgaScdJRZ4+b9KiHCwFl2rM+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+6QFU+/X90LF9RdPkL4tppufQQ+rlTd++vmQ6NF8AQc=;
 b=cycbTHIXOr1ml9S+iSkH1VTHmozm+NK2ahmRhcglH7yq+tWZOOh6MkPvWav6qdLqdtr/ThDbruBrvrP8l+RP9+Ejn4l5eEHSDiWoQSkuVLMI5ctkciU0PZ8da3hAtBQF3tUPtxyo5Ggf4A9PxCckWum5nnSsNm4r5Mf16QYVt9ofVAjOHEsvZv2u7qSjv9UDc4cz6RAcdNX3lWFGfnZ/Wjr4ANXn5WSuXCJIHqvZlw/t/JRdrbXXIPlhDqfRBcDtRIR2vVPUPgmp7tzK9k19lSRdvLWryAeFT/vlYHL5RVNXrxIwvK1ZVoI50xHHYtLFGcP/J0fb87Gx4u472cFVOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+6QFU+/X90LF9RdPkL4tppufQQ+rlTd++vmQ6NF8AQc=;
 b=X5qEjZaB9qBZDB1QI8vZ2xzYFu/wvQVw7AMkB5qms2liv506NnMfUCTV4Oe6O6vlmbvo1nqoFDHrNiHU/TUOxOp9t6lTCclJndHtE97ydl2lswbLD3hOWmPR6KOJkfN9qZz2GOjxVC2rW6Xr71UaoXUWpmDZb9jSC+q+KiBFMI98GjNrExiNL3LDLZJU1rrzuuRpXbgdEorCJwDR9MxAbwQo7rSxTeADtEYZqvY4defzmQpQd1LGPljrC4du4g8/wL3SF/kujAXEL3mChuWqOEXl1TfjorkECaMJX1p0tsEh60EAcfloub204rEzJ364Rdxg6063VilJenXJXh8cnw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DM4PR12MB6109.namprd12.prod.outlook.com (2603:10b6:8:ae::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 14:49:04 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 14:49:03 +0000
Date: Thu, 8 Jan 2026 10:49:02 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH rc 1/3] iommupt: Fix the kunit building
Message-ID: <20260108144902.GD23056@nvidia.com>
References: <1-v1-946859fdf97e+1bc-iommupt_kconfig_jgg@nvidia.com>
 <81de8774-535e-407e-8b01-5676c2cfd204@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81de8774-535e-407e-8b01-5676c2cfd204@oracle.com>
X-ClientProxiedBy: BL1PR13CA0202.namprd13.prod.outlook.com
 (2603:10b6:208:2be::27) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DM4PR12MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: f7c17d6d-3760-4895-0397-08de4ec5110f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+YIlmzzTnW9tnopQyj4MPMrzKKUI77/bbobEPoUUd/IBPPGV6BbaWUPIpitW?=
 =?us-ascii?Q?0rM3hLGE1ZRPPNYiYynQ+gZ2Dtg8XlTR5zDOBODFKQzbIZAGRiSTfZfzU20s?=
 =?us-ascii?Q?kW8YoVGWWF+TjCQJ1CwW4oP2aAchGTMr33vJl27kNYA+G9OqTAy2vblkdzYs?=
 =?us-ascii?Q?xBaJ0EIL81D22DJ86X1XAlaHiAfALz2/HcQ+CiMoVfXR8ZqYTrNUYPs4vI6w?=
 =?us-ascii?Q?DChoGh07ZUHnZOjNdqbihx2UohLlDC8dW7XnYiFfIwQsR/b+kOT1x0AHa/7e?=
 =?us-ascii?Q?rRsC9PdOG1abmy8f5twJXrqiEc0q4P1H2G4Z/thPEm/duphNAsAc10CpTFsG?=
 =?us-ascii?Q?TdowfSSE7j+tns9NPW+hcZG9NRryfrjpM2ufPj24dUNoEVwUuc+n+3xGfEiw?=
 =?us-ascii?Q?RfeS5i+jjM9nOKtScUANOFF0s0SK8JeCkPHbpEHmeRdTj1zaCbKzOHrM1RzL?=
 =?us-ascii?Q?+kUUSyMuLAsVKRDylypxo7Mwr3owN/S4p8Q9fHNCoNjaQoJfS0XY9PpVNTVX?=
 =?us-ascii?Q?IrNEVBiTA1zY8lCi4H/uhhtPPrt2SbOlkNGRhNz3OcF9lu20aKwy/vUABJI6?=
 =?us-ascii?Q?feLoVYrlwKwXjJamy0qTE3DGzbDIacII2iZeKUf6qO3yg7Yb1NH4qFcXE9bG?=
 =?us-ascii?Q?TvsQBaAUggIfuWyKrArR0aoVIPjvZfgYRKep02L8Tu1QYv7iTZ6QXW5U+cQa?=
 =?us-ascii?Q?a6kCMG/vvDELtCk3JDj8gX4yileXvJXXrnmA4+DzGCwqkZl+omICFT2M1mmI?=
 =?us-ascii?Q?+U5NhxM3tw8lv2dxj/6o9khFepOgQXfPMCB4F/bRcbBMKEZizp6zviLs5Eg5?=
 =?us-ascii?Q?zmRmAHE1RyireSH6FFTha/ND4yYAK8zxlxdk1Ht3Gm0+cIbc9mLj6o/1dSH7?=
 =?us-ascii?Q?SOqVZszMKrwlHsfRjSm9gKsTfVvhpCuqwe2wIFXWMsZ4MZNLngS34gML1DRx?=
 =?us-ascii?Q?jA3i4QX2efH7o8IcQb7cih0jCh4obHgFnZBWBguPK5XCFi88H5yo6k9oGeK4?=
 =?us-ascii?Q?bKpyzEhpotw7HJFdAYOKpoyyf74JyUHFaBcfE8UnwkAL0qoGRAlALFzrsNxS?=
 =?us-ascii?Q?gHKztUUTVag+unSzwB4E0euOJEsi5Ruwyjvh0sRmEEM4xkZxpEJcePwaguFQ?=
 =?us-ascii?Q?+JB3TZAjuPt4nhgbvA8fnQBp03aXmMBAMF6cEyOFErkBRsoTcZ8mMhhjOEmg?=
 =?us-ascii?Q?ll24AVTvew3f6NQifA/TydrQn62Hi2qhGI8FjMAngpMwDK7DYvXCJYzyF9PG?=
 =?us-ascii?Q?EnBCvRggBmTqRYnpUZlNgL8pfZ1nK0SJuxP+nVeZIZzbsLKJuyOl+yUJiWVK?=
 =?us-ascii?Q?qE+C23xeaw/yEMmUITQmIY+buB4SYnB0N6zgFIppeJo6Ydi4BjzunL88RwIx?=
 =?us-ascii?Q?muQCQnxJaMqlLppPRm6ni1ITennxaASUv43+mEzY5sR0FdDaz9SnDymbfBgz?=
 =?us-ascii?Q?ott6fDIsU0zKKvl/uv6qRc5nVy0/HKXo?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Z58rEjbe3Y9kKMybbiuPRuA04OztJWOdpkl9LJVShyWo3DtTn/61WAHeY3NF?=
 =?us-ascii?Q?eYJhPj9wI7GYuYMs3qCXdQZvScErv7jHWw3ol1MSiZ0q7D7NWUxa7xzm8GPb?=
 =?us-ascii?Q?4RpFsodG7GuVR8ZWWayoBIRaRfnI1ibmXu7/O2wcIAL6UpZuTK2mp3QgxTMw?=
 =?us-ascii?Q?MscF1cn2J1JkAj0C1Rx0f0+6OvMaJYg4fA8gUxxDigwin6+b5+lys6yyxKQQ?=
 =?us-ascii?Q?iZND2x9M9DXP9/PYJiqpJtTte4p+vQet8tRRKrm3r/IdpdP79nTIa8NfU5v1?=
 =?us-ascii?Q?pjqXis/LXUy4InVNV5CzXeS49wpls4S5DhoyrobzQfQeVc33qIgWQ5KK3iBe?=
 =?us-ascii?Q?O6gIlB5vzziESsrCJykPmi1zoAWar4925MFUmWAjskztjcHxqsglWWT1ofOd?=
 =?us-ascii?Q?Ythue8gBcZR9Sl/cMrDJptiGDay8NMwDIhq447C7a707EX+4o8RNllzeS111?=
 =?us-ascii?Q?SVbuHeXMfgWhQnT/iTQjoHfqsb3U7ir8VPD4C58TDtbtf+CfIi8KguuFVQHS?=
 =?us-ascii?Q?lYRKxI3talZiLCyJstANVbv6Lfo9lT22CnXkf8VsfkBD4iSiJLdsREat6R6p?=
 =?us-ascii?Q?kYBlvoPDh7o3XI0Lu5tnlREjklWnOOxnEi3t4pVzaxWg2dVtlYOfmhPBU9q8?=
 =?us-ascii?Q?WKOI9JyRJW/dyFkaOh73GzUqxvdfTwBzSc9KHoqx7ImO78epcQ57iANQHEcj?=
 =?us-ascii?Q?apwSN482hrMqNFJ5OPZfO313zwkm6HDljtfOnp8TazOEt+Hs4fK7X739TDy8?=
 =?us-ascii?Q?ye2azZ4fdU90wPefi8gAV9l0oKXJp5Vk0CjV6+s0znYuVAVXRCnpyL5im/M5?=
 =?us-ascii?Q?/2wSfyrRjw7G/pFbJJmIx7XWe5/RQkY1v8fxuh95AhUcpiRkEvgRUY2NzGBE?=
 =?us-ascii?Q?Hw86vTzNPLl+xBnscuaCAXKvBsXMksAdezxuLLur1qkxSwmUx9+a9qSa1SPo?=
 =?us-ascii?Q?e2yAUAmP2AZ0snIC6kVEdXOfosy2wt41NduOYOJ+detSS/2QCbxmBsQ0vJQP?=
 =?us-ascii?Q?U5vWrVvdhVFTaaMKiBJLAQZ7b/vAOLFBSkR6JdJqwPDZ8TaqSe+YvKghuU/g?=
 =?us-ascii?Q?2bKsKC6sfAIzzSPWZiCvQftFGYhbKcluR3fII8RP5WQcCyZbJ87TeS1ZoMwT?=
 =?us-ascii?Q?WxcQO1vraLnP+w4HevklqrrT6ux9nOpSERcZpmwVku4nKCEfoKitjGoBHfQn?=
 =?us-ascii?Q?QRJQVdKbEU1s5ijoiQnRuReYaDFY5sgGVzf8tuE1gWC6vtBXDQot7YSuV1AA?=
 =?us-ascii?Q?geJjcAyM1RHggNE/CDRZWmTkmFupI/BYmwsrU7ZYptLbZqTGQg6tM7RZu8oC?=
 =?us-ascii?Q?AKn6UKd6T9aeAhcl+DUTMAmVy+0rPfH5dQXSHBmdTYTPgJmNaBvPnvQkOoB8?=
 =?us-ascii?Q?iEF+LDMtxAvGxpU5VZH98GGcsmlLcd8oeQS1UR1XTEJKSKpSgPPFOR47zQM9?=
 =?us-ascii?Q?WdAbltrfTea2PKgxiQ3aDsCVwsTt9Rw/4E9DtuzqF3BT+jEvUwqPfnJa2Vo5?=
 =?us-ascii?Q?YYUNC5ahIIBiqO6FXZoepJKUV5OYwJKjB/Sz6uhC9JrERA0MeTcDslBTgZFm?=
 =?us-ascii?Q?XlRtn752gIn/tK1gUr52BUoflt4q1WBVhBY7XkIhp+nrk1GPWnw50mbxPmW0?=
 =?us-ascii?Q?Mk3iexRvcIehWQ+41Da7tujxV3eHAgFCfYrGxhHkN4VEMqYh4zNGn+vwhGoQ?=
 =?us-ascii?Q?qpjyOFbEwLst6k7leUPbSmKSbC4jpvJfbgbFgVIVXMlEtT/rqmXfu6Be0wYI?=
 =?us-ascii?Q?zskKZcKODQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7c17d6d-3760-4895-0397-08de4ec5110f
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 14:49:03.7027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AGCrJ5rnmQ169lfXbi+ykIuvJC0I99zrX7z0n8J8+xIBv6IcTGkuZwf/ewjWsCEH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6109

On Thu, Jan 08, 2026 at 09:37:17AM -0500, Alejandro Jimenez wrote:
> > diff --git a/drivers/iommu/generic_pt/.kunitconfig b/drivers/iommu/generic_pt/.kunitconfig
> > index 52ac9e661ffd2b..a78b295f264d23 100644
> > --- a/drivers/iommu/generic_pt/.kunitconfig
> > +++ b/drivers/iommu/generic_pt/.kunitconfig
> > @@ -1,4 +1,5 @@
> >   CONFIG_KUNIT=y
> > +CONFIG_COMPILE_TEST=y
> 
> I was wondering if there are any side effects from enabling COMPILE_TEST. I
> see that Geert had the same question on:

On it's own COMPILE_TEST isn't supposed to make any functional
changes, just enable more drivers.

IMHO the .kunitconfig fragments are really only for direct use by the
kunit.py, if some distro wanted to enable kunits on top of a
production kernel they should not just blindly import the
.kunitconfigs into the .config..

> and that you agreed with his proposed approach to do:
> 
>  menuconfig GENERIC_PT
> -       bool "Generic Radix Page Table" if COMPILE_TEST
> +       bool "Generic Radix Page Table" if COMPILE_TEST || KUNIT
> 
> (which also works as long as CONFIG_IOMMUFD_TEST=y is removed).
> Is there a problem with making GENERIC_PT visible on KUNIT=y?

Ah, I may have forgot about this, I don't have a strong opinion either
way.

Jason
