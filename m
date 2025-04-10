Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2079.outbound.protection.outlook.com [40.107.243.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90197283C8E;
	Thu, 10 Apr 2025 12:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744286927; cv=fail; b=KisnLZ20MhHOMzywm7l0wEb3p1OxSv8RTY0K3EtEv26jvPpBx9M6MIZLx26VY/muX9vvVJKFZwzwpQDsU3R078+Yo2OKT1HwYcCy7+dF3TI+jHj+zOJhWvr/GCc21ucwMGRNzFQnQv/uqzYuBaOgjhioATC7vo91ehef6hrSt/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744286927; c=relaxed/simple;
	bh=g/7CQWMLhuqw5MCg7r8uYP0ud8Gk2JuDxYQD1FoVcXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KX0n+K9QVnF0lG4fzb/q0e1hPXzlE6ZrkfLpGy2GW3hk2cpEvGLQN6N8dWKx/UOJc0pTjvbybjC/QYBEZXdEA7ba6LUi3IVdy2pfohL42DC81BRkJP+eBedpcy36EZJ1XSKeLhiP7mQZb7/2MpQFdoDYX42xU9J96qOLZC2G1mU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=INK8GfGE; arc=fail smtp.client-ip=40.107.243.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="INK8GfGE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P4hnkv3MORleRkB1daZn0RIsehYX6D84oQBWGlob0gRPSmz+j19/LsgCLJRqvTfFdeMExlyNHr3agWqbZg24VadwHfjuP7hnfv6YoVRQ5pnbde511XIALYdtWct1dby2HXZRkkn2pRercpA07VnuemhUSIUQnvjhWvYMHHW6EdUucgjYaczGfyaZ2iozq5V3kjoLOKtfeC+A7RqlH4EG9DLwgZLAW5nrmq866wvBbVcp8/sYWQnJhn9oVFqjyCP5PpvqPqHToVOz65FbdFs201hENScSMOoU2sQFXo6hDgxfp+bSBI2ZMV44rRvCoLxeUWtqarxp+ymmqz5gRX2zHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wz2Y9vBpL1azpu9kikvWjDbD2I022p/MMQEzqNkkNd8=;
 b=CTwYh5xOHFDDw9buYnxT0EidWhapxfAkCleopWMJi5XNDleVIeBL/ubDZdGNCbYOU5AJdwOo00dmeuukl9unaj8nIVZavc9AEFlvwQweCu8pDq3ihebxvcL5+hALHUVQiD+62Irs/AJo14wpt1lpM/5CtZ8w35K1cM2RT2iwB7qwbpoj1/zI1ktv5NngJiR/fUF0YOSfxONuLBh3X8+Y7GFdWgAHE8LP2xY/zDt8lMAWWKGrKViRdq9ghrtENB+g7bHopwrMgr7kbh8WKNzpEzz4jq9N1scHbyteup011uNqfc+qTWqfTfaF1LQ02K+0mmQd7/FgKLuIV8yjzIn/kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wz2Y9vBpL1azpu9kikvWjDbD2I022p/MMQEzqNkkNd8=;
 b=INK8GfGEaCQmRs91vcoOc8d8amY7wjl2vTEH9HUDs6d9z1XIqTzHSfVSwgNG9W91w40INTtdsUuXhMgJWLMAltsEgmd2Bkct6tfItmVLJ52IoA6yvHCCTOsW+tGaQcMW9aDc26Ymxb2KZrwrUQVI7C0q6LYqhHnWSXlMHO8Q8ykitCaBorj401BsOWBDcEDnnl2RuWDkjkZm58YkcV7Vu7eroJPjerWpP7G8U4vYAaC/22pmCRA/cIHe4pXHAJLiSXgjPp8CfJioxT99+86fgbnJiPIxOnlVKSkECMGVnRUvptn0vrA8cl2vUpXyiqpCnL6FTKu0PsTkth76/WhLkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MN2PR12MB4095.namprd12.prod.outlook.com (2603:10b6:208:1d1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.22; Thu, 10 Apr
 2025 12:08:42 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8606.028; Thu, 10 Apr 2025
 12:08:41 +0000
Date: Thu, 10 Apr 2025 09:08:40 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	Will Deacon <will@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v4 5/5] iommu: Hide ops.domain_alloc behind
 CONFIG_FSL_PAMU
Message-ID: <20250410120840.GR1778492@nvidia.com>
References: <0-v4-ff5fb6b03bd1+288-iommu_virtio_domains_jgg@nvidia.com>
 <5-v4-ff5fb6b03bd1+288-iommu_virtio_domains_jgg@nvidia.com>
 <BN9PR11MB5276B54CE7C5BC8E4CDE986D8CB72@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276B54CE7C5BC8E4CDE986D8CB72@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR01CA0047.prod.exchangelabs.com (2603:10b6:208:23f::16)
 To CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MN2PR12MB4095:EE_
X-MS-Office365-Filtering-Correlation-Id: d5ba3b06-9b4d-4e0a-f403-08dd78286eda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zg5eLyDw2h0M0epQ+N9JarIbvB3Aza13BvFMie2dW+wxcyAPg8nS/fTzKRrg?=
 =?us-ascii?Q?WM49yWo4Z/rotVPCK7VtvfBdhPc+ZkPm94h3Vi42w+UUd8gTntj2x/spAP+U?=
 =?us-ascii?Q?pgP9w4C3OH5lA3+j6lvQQ2ZJ/xbxqE/ddIOKSsdMKu599U9JEuZy3O+8VoIF?=
 =?us-ascii?Q?W8JvRXOwUuzk4hbvHrKXAawPD1pycMEb3G0lq50zNNojWm2debtTSVJKwmrK?=
 =?us-ascii?Q?vnOdMIKwP8avRqvQ0wd4TajnYYaMLGHepCnpn+vI7doJrs8uFyf3upIfTaC/?=
 =?us-ascii?Q?heqImdBOJJbjFo8uq25yyD5mZd7ADTXIyUtobDjCxjBIlr1Q4niH21IovYWZ?=
 =?us-ascii?Q?IOUgk0cVGV/2G/jJqjBk7xOJjuYCPrWMtec0j0BUEq8W5z2gYhZnsNNY9Xs9?=
 =?us-ascii?Q?V1eiiFKhGBiGih+q9tKVCeSr7zJru0OiTCGxShl/cNowbr+1jkp/F4aPzdqi?=
 =?us-ascii?Q?nFl7wg6Q/IRBPsyowV/DT9oOEAR07HHgdI1Zx46aJm58vB2ppd577qJYIFHp?=
 =?us-ascii?Q?JRzCqKD/8YTF2Z8JBetbqNvmum8qs4O9zOTEL0Vjim1IZVfFGfz21NdYBask?=
 =?us-ascii?Q?SeQp75egc498ygjbmLCeG8WYzDBJSk4llM/Vt69yZeJ9+baOc9/HE2hboKF7?=
 =?us-ascii?Q?kMr+X0D4TuxxT68Z5LSzKKGmfLaAfpRekBAwEbyVRSmAF9Hcr8veB+MsveYZ?=
 =?us-ascii?Q?ER+55wJVo0siSgKP2ep2lu7eZeo9yPMSKTS7wIL1aKAjOz6pRogX1oQ/GBAa?=
 =?us-ascii?Q?KFAHd5e5Ef1pMSa7t7Q+41sHNGMCdSBNc8ZqpDP1xU6NS53EFzgdhOGWdaKO?=
 =?us-ascii?Q?0Rw/yP3VSFAjsciMYx6vy6O+UifiLJjlJnJUhSw0J6f3ptevgr3RtQgU/gDz?=
 =?us-ascii?Q?umQpncDY4a17LCS+J1binOMJrQLVi0eEXgBd5hcKeP1k3InG/lSEec23hwu9?=
 =?us-ascii?Q?q5qO4NUS3PZt7vyeuxAI4GreHeiyQGFMro/WPtAHtoP7A4qDut8Y5IAeKpt9?=
 =?us-ascii?Q?Od2Gkj8KNv6to+ZhHbeNyPFRxSgBnrMSqJhkRKLUzN5FVSgCNE1d72JEvXrN?=
 =?us-ascii?Q?6nUfMg151H7z1TP4PGvSf6UEQCgypNqFkNj+dnFpliGVbMFtd9NvQ1szPIPb?=
 =?us-ascii?Q?7Ilh337KgRuu8JevoERRarDZxtQ4NMwRC2tpxmVp09Vz4Id9BQBwn3te/F3+?=
 =?us-ascii?Q?JnHfExVweLo1q/zvskvJ6afEm60672NUByBRa4L/iWgrxjsjneam/rqYKsam?=
 =?us-ascii?Q?DOj0wU5bjxnQJDMqgudXPcjfurm4/YpuDSy+OIp2xzJLneabqjgSV0MkXkX4?=
 =?us-ascii?Q?56Zjcgp7Nv71LZPtiLUVz8x4QNGt8nRNhDsQ0TyDLd7zfK7/egUSJ34cu8n6?=
 =?us-ascii?Q?AynCmZesc4j6EY+LxoHHj6NuQreejKBg4/XWdumG/FRCcOZYGRPCwx67rsrd?=
 =?us-ascii?Q?KaP2gxWCmmk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jU/bbHL65C2E2pneW5gah1xX6rBjeJXBpabeQOUlvLGB0BN3vHsE+wUztRm7?=
 =?us-ascii?Q?UZcS2GVtxJ6GQ7iqWVe+2MqWF5DbqvwcGnwWxRFm+2Wvk+qSEJIkZJisiDlv?=
 =?us-ascii?Q?sEIkvUmIRoADLZQiIdcnT9rxwH4tXEv+87z7/Ouj0i+zlaKhl2be+R+S0JSz?=
 =?us-ascii?Q?kxf/1YQcfJjplc60agGsJFEo+uHaqBXET/w3glrh31LF8VMQb2kxpWDA/bA2?=
 =?us-ascii?Q?6LqzrwuV66LH1d4FbVFDFr+YlaviV+Qe6WqA9ZL0KKw5cpJv0QzqfKuh3xS6?=
 =?us-ascii?Q?OqWq0Tk8nLJOlPdqyW1yEkd7BmJtWksaWbFxsVTnigX04GWTulZpv4l+Sikt?=
 =?us-ascii?Q?2Uv2HaanlyFDftKjWbvQtJvjbuUqnGbu919n91Bj4CEPfxJ4GE9V73TSIJOX?=
 =?us-ascii?Q?65nltvO7Zl7TYziVWs2tvf2LIZCSp7hrV+Lss/TtU/RNU8JR/le8l+BIzbQT?=
 =?us-ascii?Q?WtClSPBxWClwuN83hLn6R3dWplqpNHECmO8U4uEb5MacM7H9Q3Fp/aWRDZuF?=
 =?us-ascii?Q?/d1TpTolPXw7/KO+4TM2VyCONOqViX3jijfqQWClgVHyWsDSPLHXV9quHN1b?=
 =?us-ascii?Q?OdT979ScXXYK/zvpL0JqDnm2V86k5iXI6YNr1kJWiTqauDe3gw+k3fYRQ7MQ?=
 =?us-ascii?Q?BTSkD0+EHT/4wP/FNzBbqVKaGYq/cn8n4o5Y68BTZEYpHmE5ockdaIFSl+My?=
 =?us-ascii?Q?YjRyenHg5eTi9Cj/0i3ckdMsCEYxP4vwcqXAlOVQkoGIXv4eawMepo9YZwtS?=
 =?us-ascii?Q?JjHgqcMwY166ZFzMrce7yPhzEk/6m9EVZA3H6ns/Fa65XOmWrl7dW6d7j4XP?=
 =?us-ascii?Q?Wimhlo9U4kyMuiTmLC2zxGZ2PifdNyO8AFZESAukC2CaaPD5UZ80cTYsmpsG?=
 =?us-ascii?Q?NbOJasaQi+1Huelz4JJ7n/L2KsIM24heuxPY0LTAnsONjY8dBgL7QCx0VCR4?=
 =?us-ascii?Q?wVYMMPQoig+4nN0OfaBUho8DyT8F1ss1PxUSi9Y164iQzjriQ5dyxcjD6jAQ?=
 =?us-ascii?Q?EnXxAlu/Ze8mqlyk7CB6CdDmYiDuuoJwZVCy8Hw9xFM33Rc8J882LHitLQZh?=
 =?us-ascii?Q?HQkm37UEn+TMyrb02fyfGzDBOu60keM+dJ24yzUuEh2wSvsu94VGc/nKhVCy?=
 =?us-ascii?Q?xCTPyctIcE2IvJxhr1kKgnpLCclHawug8/a/G1LaIIDtkQVn8DxVV5pJpi9b?=
 =?us-ascii?Q?fhRt4d6HOdlkB1w3L5imK96n2rzVGoOvsfXfEO6B7Y5EVsOBKCQKyzNEhB7r?=
 =?us-ascii?Q?KX0C48WRRZNwSTkiUnZtHC2y2bL93JvO1m4VuZWhZng2Vf0Edwbv0jimnZW7?=
 =?us-ascii?Q?lrn8S9ZmwYDUNnvvDV5fF08Z0bpt/J/TS8zoOUOz3u7HSL3baKxdhCXYUWzi?=
 =?us-ascii?Q?MEKMm6zgtFX9QeAbcWidjZoajlRylpiPay5uzFmioNUW6CQ7gAuAywJ7TCvK?=
 =?us-ascii?Q?ti181vkKrZa/LiWrZU2Wg+39p5SCVOmCDR7YMALwhxcP9SslWEreujkCSmJo?=
 =?us-ascii?Q?U2XXa4VZC4TTgaQd07Pjt6ZQicZRpnCLJ4F8T8axWzaxui1OrTKfZxMWHS4U?=
 =?us-ascii?Q?H5j3Pirai2EqEYF9FX/VyUfe9KvEtb+VaBio1e+m?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5ba3b06-9b4d-4e0a-f403-08dd78286eda
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2025 12:08:41.2576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cr1RPqObeK+CzfZgwD7PaRRGI4sPvZLzcr5PLRsI+RW4O4L76cgqVAxUACTyEaro
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4095

On Thu, Apr 10, 2025 at 05:57:44AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, April 9, 2025 12:36 AM
> > 
> > +#if IS_ENABLED(CONFIG_FSL_PAMU)
> >  	struct iommu_domain *(*domain_alloc)(unsigned
> > iommu_domain_type);
> > +#endif
> 
> what about directly calling it as domain_alloc_fsl(), given no
> more drivers can support it?

That would be good, but I'd want to change all the call sites too, and
I'm not sure how to reliably find them...

Jason
