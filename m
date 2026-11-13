Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794581580;
	b=wvgSygGeshTclVaUraUf3rQLTfIoB6vQFu0wjhyR956t4UbHVb+59FgqMSv+BIKJaTSz
	 qBdfuuYDSsZQlkMfkl7QsTf9q3kUpRQ4OpNatUW3Qab5kjFPc9yQ1y5y9TjRtP5ZQBHz0
	 d6HswqLbPNZoHn7xCyyYOm68PeaWlIeSeooiTs86kDliiglJow5g//R7hKuciO+07+LCB
	 35ElXKbEgC4WkUc1dC+ercfQEUW6f/7WsAebIDsoY44JGuEuvC8YZlf3Zw47gFGBhehyo
	 M6u73eTvy0xZHVxcyEQavCnku1mxTmEKSWitqxNz3V42z8ogNktebPETuUWyH1GKpQQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794581580;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=jO9jNNlT0QbkwMhUiZk+RB2T7QTvoyuMQ9uyVuRaiDQ=;
	b=uEXI6Da/7Q1yam7axaB9KXD2qkovVZ8aHrs3dN7yYADBy0Rn/FMwY8qNH5BNDsYS+bRi
	 tWFtdEgE+hnmkrfIYQVljPUPdFymLDn7XKn7YIp9Vo1reM1tiw9iiFM9n/RvPImdWPwkH
	 2liyYF1kJCDY1EwsKuz1wh6bwTaC3rzRzUszvUuZZaiy/qEVpJuhTIb6mdQnogbNcd8sg
	 qZa99/CMQTneycDxQStvdOfwvUtx5w/KLocA1kQrw+P7XInmGqwVWmob1iGZXpUIgf+P9
	 FEK57jGRFPaFEC6VUNjDLCQ4oC6aVgbt61At0CI/w9v5gV3G96QJOieiUNy32Z7/ggQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=gU3ajPk0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.18
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011018.outbound.protection.outlook.com [52.101.57.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A26606A8AE;
	Fri, 13 Nov 2026 14:52:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73A26606A8AE
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=gU3ajPk0
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g0u0G+1bw3oZQF7Vm8FS/nO/J6quI8+O3T4LeOqU9fLhtzrqTgkUEDHIwoK0njZKFxCL+6fiRBetRP+jowZ8ajGS82NMO1WSYuI+KD74j7UE5uHXU/PI3xdPwKj8LvKtM/Tu3+ECSqv5MUue4h58OOtzyOjqDd7WwZ+4YYNWvxMimKTAtWX3mXx6UMuTt6/uAnt/YWSPaK+K4jmd4o9QZ6YuJlXVmbdSoRKpaOv3y7+bckhZsZut288iickPL8tLXXMGs9CScLWWIlMRTf6fdPCee0N/qz4G/LOyZm+QvVPcw+mP7LA8Vp4yY7IxKlyrx7F07NtC//KxsHllnxWsHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jO9jNNlT0QbkwMhUiZk+RB2T7QTvoyuMQ9uyVuRaiDQ=;
 b=i7yBj8+tDojvM05Je3yMiU5G0pupHfl4Y70pDXVnMU9NkHziecJvsMkPPnyWaEcuoRJtYHf1a44u94gBdTvlQOEq9sOkl1M/lFZC1Y3z4id72ZBquc69I72h4RT/EAYxZQHxKpSeNRSbytOtO0YslEJ+uhy/1uu2bQpcQvYjBkWuSglmfKqan/FI7FlkTtkYvfA1ly6ma3hLqiSDUlnXBMxHbRiPpZAOte1CmHNn5azEpmkDqMm2QpTot9uLx2CpA8br4VNdTNAw8i6uQCPY/0Z4KrrgCFhesEVKNJHJ85YhcfOH22o0ZCzMUya0/dsME2WLIyeHqqBTVNVJ0/4Zhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jO9jNNlT0QbkwMhUiZk+RB2T7QTvoyuMQ9uyVuRaiDQ=;
 b=gU3ajPk0N1/bXeRsFnizY1iqI899t3uHK7WHYM6njL7cKINqdZhfpLW10UdhehEpHtzf50GPL6bv9omxzqdrtqvkpgUivteGj8YA7faQHsmsITYwFuPHTnoetZrefHxHo14dXwJ1+ov97UHTFpLn153pOejVvUaAVqwSlXCN4BMHgjsNHz2NaX9M7AyzxcRvJElb0S5rkUq7V6LODCSTeDbM3bLtibVCg1LpMi29ve344bwnnZ2b6VxeBhc3V+CiYiFAZBvn+Hqo0DR849CsEGZtgEgiMgN1eE/6+4cVstmcxp2PDl7yj0pbNBrf6+kO9bkm4L0ntvvX5zJJ/lorVQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by BY1PR12MB8446.namprd12.prod.outlook.com
 (2603:10b6:a03:52d::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 13 Nov
 2026 14:52:51 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.009; Fri, 13 Nov 2026
 14:52:50 +0000
Date: Fri, 13 Nov 2026 10:52:49 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Dave Jiang <dave.jiang@intel.com>,
	"Reshetova, Elena" <elena.reshetova@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	Jiri Pirko <jiri@resnulli.us>, "Tian, Kevin" <kevin.tian@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Alistair <alistair23@gmail.com>
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Message-ID: <20261113145249.GA3706007@nvidia.com>
References: <20261103151643.GI274202@nvidia.com>
 <aurmtTe4ObBQhC4S@yilunxu-OptiPlex-7050>
 <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com>
 <yq5a5wy2qtjs.fsf@kernel.org>
 <20261112145254.GL738765@nvidia.com>
 <yq5abj7tm7q4.fsf@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5abj7tm7q4.fsf@kernel.org>
X-ClientProxiedBy: YT3PR01CA0087.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::29) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|BY1PR12MB8446:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fe54acf-e589-4193-dc25-08df4195ca09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|23010399003|366016|10067099003|4143699003|11063799006|56012099006|261021135927099003|261022115727099003|261026121527099003|261022105027099003|261021121427099003|261026140227099003|261028144727099003|261022075727099003|261102123227099003|261102130727099003|261009223027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	asLCwiaOzNa6hUszyK8O3AtLaO9aFuinT//8rysDN639PhsYM+XVuYsAlmJIfncjIbeD9MpiosyhspI46WGFBwQ+fUHu+Z3vraRg7pX2RNUdNRvqlNSNgb0f/UX0pe14TObN5k3Yk/DmWLjeqm4mDx/KkOhedLLVmIYLSsphjE/rT97KNHfryADN8BLXoBq1eaulv0uG+cQHyRV2XCdlEYmidm2WZMzwqO1xNwk1i4eIrH+EijZfwPL0pmwCHzkcMXG59sGWnV8jon+Fzl61fyVL1rg3++1Jx7c3pN8OxmAKtfEGlxwFGGW60Hlc7sONbcime8iDYnWjBzRcPItUUlT4TpsN8obD/0WE47ehTNP9enRbK7hDbGE35ON7a7E6Z21T0g9ebxfWUqChvVgOWa9hyMTk13zhD2owNG9RnnqFLBkp7QtFQhrudzVdBClSX712mz40Y6R6E8Lgo23YVNPD1vEDuOQDwLcyl5c4mpF9ScR0mAYIrxHdDWC7KkTIwgdxK3cMQr+uDU5TJM6nnmp3R11udAzUzZUjETWdkJUL4mav9lCRQNCY6GaUuOazdorTr8pElAoVMPFeOMqeFQlaUtN2cn3iOrQ8ub06plO1uJcVIJrwFPA/PdshfmJPxkyn5V0Cgfmaa/WPM/S+u8hs9Xcn5ttRez0Q4F+dbHQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(23010399003)(366016)(10067099003)(4143699003)(11063799006)(56012099006)(261021135927099003)(261022115727099003)(261026121527099003)(261022105027099003)(261021121427099003)(261026140227099003)(261028144727099003)(261022075727099003)(261102123227099003)(261102130727099003)(261009223027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eoit1OVT4RRSwN92gIx/fop1dajDoUV3nXxxrVBmAwWeLfcziB2HWRwiP3Oa?=
 =?us-ascii?Q?8RNrLfrypgdBVxajQ8c2uS420ShJz2UG55IJO8z8Y9fgAKHPu42Z/esw5wmj?=
 =?us-ascii?Q?L3Z51oFA67rxMIoxBJ1OsQJS+HXf5QLTIkkuo04j66LVolEqDVaPFBDbC4C4?=
 =?us-ascii?Q?c+pH2PgbZm+LonjkucYaKAFG/LHcF6ZYF8OO1k6/2S9bKEhG7VOxj+t0LDi3?=
 =?us-ascii?Q?EHrwm40eXW1ITCE1gCUf/X2pd3O9H2u33uvHh2SJiguvxkoOhmlv+uWEUCbt?=
 =?us-ascii?Q?8fviIMkcSJVqfRb73qEMaT/xTBGxjs/2AEG63MJrmONswmWnUbjJcLDJF8SR?=
 =?us-ascii?Q?azPoaw7O2XQeYZqSPvla5qHimsSRCuR4oCOAUGSp71zre5vPavgMbsymV4+g?=
 =?us-ascii?Q?MSyEoniiqGOHUpFI0/LcSyjHsqFYEyj+a7HAbKMX1J7sAA9HRA8RosWQ3Ex2?=
 =?us-ascii?Q?s62d6I3lj7gGrpC+1LVpO6gy1ITu2/dhd29lJoW6ILmMtoNLUDcwrMrZhEKC?=
 =?us-ascii?Q?Meme57zyqghzyWSqPmGo3Xy3rDg7rdFu66TlWf7UXmYq3J6vp7f6x5iBXjwV?=
 =?us-ascii?Q?kG6EwPK01P0g+nKOjGm3o2qcBCb0Df2iptC3gcVz4HT3YTpff53dNX9OK5GG?=
 =?us-ascii?Q?Tk/K9hgRg+r/Y3uLFsRnvW+AYa9vcgTi7dmfMdRkq/5UGILANo4JScxoPMVE?=
 =?us-ascii?Q?MJ/1PV1PY7y35hzQ/sJqLAr7gW0Ztj31I4a9HxYG8tAt1HKeLrIVVCD5RZcU?=
 =?us-ascii?Q?Stcfa+gOVZHPzTdgQ1UBQymJSut9zwtq5uMiwh/t1pZjZIVu9xxXL0NanLQR?=
 =?us-ascii?Q?fInHc+0/sGB3Bkb2rTnfMLk0pEAFGxyctgkkL4XNexOhya9g2qtEYm1NJn/u?=
 =?us-ascii?Q?JGwKxtgf6iboCiPWifuQtEBd1ml2eBUu9mkYIIs9ia7m/2Ebc01R69k3zABc?=
 =?us-ascii?Q?AFRdGQerAlbIlcjeuqXcNApiv/eSbJi4ouqfyhFH3ny5qqb1MMtqB/YvAjIb?=
 =?us-ascii?Q?xFGhcnfmUJvT7C0PbSkWyvcrNin84HVnOdUNK0pUrn20t2CSf82FIkByBoom?=
 =?us-ascii?Q?rK1LAFBO6AeuIGJ4FhpDO02A704V4VRQbiLdvY8et4j/NWCWh5GSHvhp8fvB?=
 =?us-ascii?Q?3Cse3G50dJh9ElyfWRII+uH70ZXfbPs5JCCSqBvA7yztVVeX015Lm+kykPgJ?=
 =?us-ascii?Q?6bMPUEPwLn/nAtQN3MRLa0x3m93z4sjs1JtrtHbbkql7ynrLWm+GpTxMjTxr?=
 =?us-ascii?Q?OoQLks1+5tpRSRTYggoDZYtixzUk+hMtjXpeL6Hni4QnV9TdoG/JwJNPktuS?=
 =?us-ascii?Q?8D8TcOdrjiSQJSjpnjTdGHNBmUTLLuEEa28fYkYBF+LVb6qPTGqs0ZJTO+dk?=
 =?us-ascii?Q?foC4byMuVC8vWCPK07ez6yLGiMLD+lMpWUq6N6EUA9DffIUAm8SPgsJ7YXEg?=
 =?us-ascii?Q?bPcjJE+RcW++FeSUWJWDYgwFwp/nAZacLJxE0P3nQEeuXW5nZP/LdCdK/9ap?=
 =?us-ascii?Q?FfatIKngNThiihDL+8mQJN2o9LMQSRqoaHFZPBUm3ixZrieov2NcEcE2aAYV?=
 =?us-ascii?Q?nRrnDNZwoG77h3ZbvC4XGrIuX/F6vHkke59os/7Qh57ek8KzcpeVnSlONs8b?=
 =?us-ascii?Q?iR6/qcwJM0twgxGfkFfXKGAIKd6Q3559ii2bpImC2ZsyUbeUAV6C8eetozrG?=
 =?us-ascii?Q?BNUdqmdSjY2Il12y92lrnJ8aPzpyGjIqYYGfms0NbidTvFLq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fe54acf-e589-4193-dc25-08df4195ca09
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 14:52:50.7382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UAyXn2dwUEGVl8Gfj7L0MCkGoRh7Kq8qxPNJKvlBOGcX/fOqCMdcfuEJ0RFARsMP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR12MB8446

On Fri, Nov 13, 2026 at 02:24:59PM +0530, Aneesh Kumar K.V wrote:
> Jason Gunthorpe <jgg@nvidia.com> writes:
> 
> > On Thu, Nov 12, 2026 at 03:07:43PM +0530, Aneesh Kumar K.V wrote:
> >> > Like a whole bunch of TSM FW API just to do this:
> 
>  [ ... 38 lines skipped ... ] 
> 
> >
> > Capturing the transcript makes everything 100% perfectly consistent
> > for everyone. Userspace sees *the transcript* as defined by SPDM not
> > some mangled, truncated or processed version that the TSM decides to
> > provide.
> >
> > Userspace gets to see KEY_EXCHANGE which means the verifier can prove
> > the certificate binding, this is the ONLY way to let the verifier do
> > this proof if it wants.
> >
> 
> To clarify, is this only needed if the verifier wants to perform an
> independent verification? The RMM already verifies KEY_EXCHANGE_RSP, and
> we trust the RMM.

Yeah, I'm not so sure how useful it is, but if you ever want this,
then the uABI has to be structured like this. I don't see any reason
to forbid it, people have asked for it before, and it is easier uABI
to maintain long term than the alternatives.

> > Further with capture we have a nice primitive to pause and do slot
> > selection before going to KEY_EXCHANGE. If we know the kernel has
> > capture then the ideal FW design for 1.3 multikey is much simpler and
> > clearer (more like ARM).
> >
> > Also, ARM decided to do capture already, but directed by the TSM.  I
> > think it is the right and best idea, they just made the implementation
> > too narrowly specific. eg it doesn't split up VCA, it doesn't capture
> > 100% of everything to get KEY_EXCHANGE, etc. Trivial to fix while
> > upgrading to support 1.3
> 
> So, not everyone needs DOE snooping? Architectures without a
> firmware-directed capture mechanism can use DOE snooping to collect the
> required data on the host. Would the flow for SPDM 1.2 look like the
> following?

IMHO ARM has it nearly right, and if you can do TSM directed capture
then you don't need kernel snooping. Kernel snooping has the drawback
that the kernel has to understand every message the TSM sends and
every option it negotiates. This is a troublesome coupling, so it
would be good to avoid it.

But breaking up a VCA blob has the same troublesome coupling as
snooping, so we need the TSM directed capture to work in a transcript
form, see blow.

Your diagram is basically what ARM does already, I don't see an issue
with ARM's implementation as-is for 1.2 support.

> |                                 | KEY_EXCHANGE_RSP                 |
> |                                 |<---------------------------------|
> |                                 | Verify response signature        |
> |                                 |                                  |
> | NEW: cache complete             |                                  |
> | KEY_EXCHANGE request and        |                                  |
> | KEY_EXCHANGE_RSP, with signature|                                  |

This is not the change I would suggest.

ARM has everything fine, the RmiDevCommExit tells the OS how to build
up the transcript.

The only issue is how the cache_object_id was layed out.

It should be a range of objects, one per transcript message. eg use
0x80 -> 0xff as
 0x80 - request #0
 0x81 - reply #0
 0x82 - request #1
 0x83 - reply #1
  ...

Then include every single message that is part of the signature. OS
reconstructs VCA from this. Trivial to include KEY_EXCHANGE in 1.2,
GET_DIGESTS in 1.3 and then whatever else 1.x brings down the
road. You have enough IDs to capture 64 transcript messages.

That ARM can capture encrypted messages this way is cool too, if that
becomes useful it can append to the transcript encrypted items as
well!

I imagine an ECN with a OS negotiated opt-in "Improved flow for 1.3"
that changes things like this, and below as a package.

> | NEW: request slot discovery     |                                  |
> |-------------------------------->| GET_DIGESTS / DIGESTS [secure]   |
> | Relay ciphertext                |<-------------------------------->|
> | Receive RMM-exported slot info  |                                  |
> |<--------------------------------|                                  |

Intel did this, IDK if we need to for RMM, at least not like this..

We really want the certificates to be loaded at the start before doing
key_exchange. That is when they are most useful.

So when we fix this for 1.3 the opt in should trigger a transcript'd
GET_DIGEST in plain text and certificate collection from all the slots
in plain text.

1.3 will sign GET_DIGESTS during KEY_EXCHANGE
1.2 RMM could issue CHALLENGE if the device supports it right before
    KEY_EXCHANGE and transcript it
1.2 RMM could issue GET_DIGESTS inside the session and fail if != to
    the plaintext

These approaches keep a consistent flow where we get the certificates
before doing KEY_EXCHANGE so we can set the slot.

The final 1.3 opt in change is to not use the slot passed to
RMI_PDEV_CREATE(), but instead change RMI_PDEV_SET_PUBKEY() to input
the slot, pubkey and certificate hash. Have a pause in the flow prior
to RMI_PDEV_SET_PUBKEY where userspace will read the certificates and
input the slot.

I view all of this as a new opt-in feature the OS can select to enable
all these new rules together. When the RMM supports it then we get a
more complete transcript, early slot selection, multikey, and early
visibility to all certificate chains.

In terms of change to RMM it is very minor.

> If GET_DIGESTS and GET_CERTIFICATE(selected slot) are issued after the
> secure session is established, DOE snooping cannot capture their
> plaintext responses. I am therefore still unclear how the DOE snooping
> design handles this data.

As above, the TSM needs to issue these in plaintext because we need
the information to do slot selection before doing KEY_EXCHANGE. This
is essential for 1.3 multikey..

> In the end, the host has the certificate chain for slot 0, which was
> used to establish the secure SPDM session, and the certificate chain for
> the selected slot, which was fetched over that trusted session. The RMM
> also returns the chain digests. The host can compare the leaf keys for
> slot 0 and the selected slot, 

This only works for 1.2 where all leaf keys have the same PUBKEY. In
1.3 that's not true anymore, so this logic falls apart. You need to
sign the GET_DIGESTS and present all the slot opts to userspace so it
selects a strong key as the signing key for KEY_EXCHANGE.

It is why I don't see value in fixing 1.2 like this, it only works for
1.2 and we need to fix it again for 1.3. It is better to make 1.2 look
like the 1.3 flow.

> BTW, this proposal does require RMM changes. I have also omitted SPDM
> 1.3 multi-key support from this diagram because it will be easier to
> follow once the SPDM 1.2 flow is clear.

IMHO, leave everything alone as is today. We can make it work well
enough as is.

Make a ECN for a 1.3 opt in broadly like the above that fits better
into how I sketched the kernel uAPI. Do this once we all agree to the
new uAPI. The kernel will always try to use this new mode if RMM
supports it and userspace gets a better 1.3 experiance.

There would a similar opt in change on the RHI side to transfer the
new object list.

Jason
