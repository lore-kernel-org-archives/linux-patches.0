Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.67
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793374753;
	b=mHL+ivBgVucD1LrxE+49q8l/oc34RhGuNRSy1OwSFjDmW60MgIV7TbmkiGZ62XVWfm/1
	 46+6ZE4YTsDNl5yjXGMm0ALJI5A5ZXF9H1nupypophEBQ4iEwiGWXdMkWvjkYohxdrNg+
	 AuLbYVCk643jY6+DN6JtH++l2vOJxrvkf5Zs69RmD+UApfTbB8qI14qLwH+2K6m+Jc51u
	 xrJL76DSBPv3Cr/N9/d7bNe3Lryo6E8sEmNQhGxthEJElqEOx3xh5Y7jYs18vdtjFkNOc
	 gekX3itNpGUI3rcMD7ZqD/euMZ7I/+zp+A8yt0OZFF8ulEQkpvgD8XWtlvrsNfF40VQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793374753;
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
	bh=WKEwG/TtJnM7Qc4MlrJJHfEHCJoRDM1rduMUnaiK0OU=;
	b=Jhm6igq1hQbudakl64m7PcmzWFptc6PI8We4TLRmYK/14+FpMMVMkBtJ0zs9BtoV0Cgo
	 E65vJm3bhGfDUXMf6Nm0l2mN60p2b29ISNaBWzSFM6hsrbOUVaKG/riO7TBkWEdPJog4Y
	 DbLWEue0icT6+MfhkQvufGyL0f7kGJlyZLYh4KlVfOvFsgsMgIq5Kg26+1mpvkuSfBKxZ
	 n74t5FOKgLdGKalsd1dT6pyAgaFZelzrNV6kgYZ8Cdby18iduOkiMSGV7h55fqXc8mJQD
	 Ddq7Q5a3GjE5UTmKp+7Ep1U2ocXH0S6lffSaHMcJ/8Tv2kOmEX+wjTCNWgTdykIzFeg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=gpOCqD5L;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.67
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012067.outbound.protection.outlook.com [40.107.209.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F907606A31C;
	Fri, 30 Oct 2026 15:39:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F907606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=gpOCqD5L
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bqF53znAGoBBHg5+UMLeDVQk4gAbNZKMrKkXAuAX1xwUuLPCZJGSDLNUrHfElwtFWLIFGIvXSWL8aOHhMhernG/gXyK+S2f3rJSvA4b8rdqE7hUu6W0j04we3pEHnk496frUYpi5Ma4SodMOXtoKFiFwcoLhwcRfnvEOaZB1ZH+btsrlY8gEq93MSVfjB2Z9TSZveHfyd0ArbbnKRrY4lFIG162MgSsU0hkah71VIJeyg4Fl2ttA33y7KDl+TgofAmiHqG/48pDMYMK27tA2JxTHojll5qYTcy218rDimt7G4+mVGQ1UklEBEwNG6lKdqKbNKcFtCOiSJqvHdmCjog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WKEwG/TtJnM7Qc4MlrJJHfEHCJoRDM1rduMUnaiK0OU=;
 b=E2vPvXDT2YFfJ0j/LwAwsT3cxGT1r3q083r7SmkSAudM+VerTFI/XhHEeA5s+WUziXRie/m7zQJp04Va8QLPhRNcKPFCY0hi7FDi2p4bLns2mOcZevmwJxu0UhGlIqO3KcsEQ7/wS974yxjKsTV9aaA1qcyyoTOhcS/IVWcIGV+XqZ+tRwhtYUPhHjqJ/n04MHZtunPV9zRyRvv/XsL0u/kgAzIo2OVsFNoexQqXovuH/7Z58xKyQm9gu7O9fN1gl1K5sKnRCnZHIFpEbtQ+TIbouji5Xn9lBrTTF83+B9bFDGjTDp8djmP1qWA0546+lR6aguxNc5IDtQyY3D52pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WKEwG/TtJnM7Qc4MlrJJHfEHCJoRDM1rduMUnaiK0OU=;
 b=gpOCqD5L0DlsLPdVG2hR7AOnoh+x9UHPUhw4+mnARlj+fofmnpvTUGTpCvjUbPMoxvfw+uGygLtBjSL86+XPeikZPbK/LtDd3FOA0U98UHYSVmvzdTqMLvLQ5EJwEIFjojNo5D+/QnjmtPWP1SrGoePLQzH++NEyStVYTqhIB9JGaDiQhuWkK8cMB8fSWUwtDIbPL3WbuOrzCjFePQ9jFRH6xGJsTt5VMkLeWFYsy8pSy+DilAiK4SMl5eoXzrQ5qEtlypG/Tix2WhArGfMabxdJVH4SG3BP2Y5KQEueHxUSSVUx5CvsAWUX2Yb3CmmMBrcbojtoCEW9w8XZCNgpFg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH0PR12MB8007.namprd12.prod.outlook.com
 (2603:10b6:510:28e::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Fri, 30 Oct
 2026 15:39:01 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0569.009; Fri, 30 Oct 2026
 15:39:01 +0000
Date: Fri, 30 Oct 2026 12:39:00 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, patches@lists.linux.dev
Subject: Re: [RFC PATCH v1 08/11] PCI/TSM: Bind CTLV attestation to connected
 and locked contexts
Message-ID: <20261030153900.GM3734323@nvidia.com>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-9-aneesh.kumar@kernel.org>
 <auSkHORl2mg_FiOf@FV6GYCPJ69>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auSkHORl2mg_FiOf@FV6GYCPJ69>
X-ClientProxiedBy: YT4PR01CA0365.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fd::16) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH0PR12MB8007:EE_
X-MS-Office365-Filtering-Correlation-Id: f58abddb-33e7-403d-93a5-08df369bebb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|11063799006|4143699003|56012099006|261009223027099003|261026140227099003|261026121527099003|261028144727099003|261021121427099003|261022105027099003|261022075727099003|261022115727099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	r0DXW5yhLyT3BSM7n8kzt0xWp7rZ55xeBSUjiRREumjSc17W5JSO1OoLSP1XzFp5Aix5AM2CIVhlxCbpSx92Lcuumjkak/Bfi4ERrUs2vjyqfK7/9ngn5VKFfumZq7dHvcOu5ouDEZ5UBaFgaY6SgRpe1iWOUWYgLuflXpfiLw8o3SsbaA7w9ZZRncKQAlkrKXTDJcUW4lX0cIP5NJHb196NYLLD6tK3ziszC+yT1FMYPe/UrQgLFBsUdDyeYJnfpG/NvwglcIG2NYylTcJDJggByzssc+O5X7NA2TVJaW8fTWEQdOv3Ope6t/LeoH44nWmY6LKSS+CD3FGisHP9q47n33TY5LLU5UmCaEP3rhcnY5zRrpCUMBvac9zrPOz+7HE4Ks6elh2B5A+TeAmwYz91aJiFU6LX3/3zpfdP205anrRTUZbrKzyJZBlzsX08F58imiI0UEq0zx56u0dVxvPyFwfdZa9WK8vgjAsSpm53NNZUs3VU1ZtUIFyO8qGYCV84jloDmtw1FVz+HsQTNqtrBq2QAE/8NypCJmkQKhFX5MvmwtGqTfjv+ucrqmdmdtI7gaehl60g3e821ZMWGCAndL9wAs4X8OXXmVSrbjbojEruIpaHXW2a7ZkC2y9D51tCEgepnssI/CrTLTJmx+yZtLY6vN6jf8OiUBiBATg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(11063799006)(4143699003)(56012099006)(261009223027099003)(261026140227099003)(261026121527099003)(261028144727099003)(261021121427099003)(261022105027099003)(261022075727099003)(261022115727099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vkq7RrLAdquO/PhCEJLkGu5mmcUoO04uZhFEtie7iU8wvak8OPGL2J95k4OG?=
 =?us-ascii?Q?Ixfay/Y4bTTQWDU98/axz0c5upMZ9kKTQBcOAk4wtgQWOLXkAUwd4CudRZgO?=
 =?us-ascii?Q?tUdouCXmRtAWmpUXhxppLUG0H94aBgDYkKg7Tu/Y4ArZc8VQZ35kiCOTyilx?=
 =?us-ascii?Q?JcjwbRA5t9BxFK2j1SiBURIp9HP8y+OWluD7Ec0AwnUM0HztKErMC5eTq1dP?=
 =?us-ascii?Q?jwcNvXSjbiURGQG2nGzKFG4hmVYNmt8BiCRIk/SKJ75gItz96jYP8XTe3GYk?=
 =?us-ascii?Q?8YhEqNWWrG6to+TQlgIQk1F9AouW/1s90ZR96ZAh1J7hVqHBYaRY6M+EX5mU?=
 =?us-ascii?Q?LJu/pX+I8h1e2wW983LTfEsrNMe9b+EIS6J6L3PTiPUv0K+AhEG39Hatm1s2?=
 =?us-ascii?Q?m29njnxLpNwKffDYGG7MCFQFfaPsYQyO2dBLf/FJdy4SvtQgOgdpUmwR5jBB?=
 =?us-ascii?Q?ZSaW8H+F0aFTO6LtaQIy5X4tx5ynV9T2o2LU71XoygjsUUvuzEv4NLqqoUXX?=
 =?us-ascii?Q?LcALdzWRAJJQLPVAZ6OQ9ESVZ6GWxsi1GbdF0iAJQcyPu6AAHPJpbdvPCUQI?=
 =?us-ascii?Q?btMfKkBNzfPlV60btB7Sq3uWKYgc6Fy5ugidzmq3rw+QlaYjnJyAQa/5uYD9?=
 =?us-ascii?Q?sJG/4Wmsb3e5Wxf/J0MLVld12dDcqV/kmYqFuENV8Ecw8DuLqkP3li7gkYOt?=
 =?us-ascii?Q?pMfGT2+bT10NYwhshCQ69dYN77tCwfHePszyHSZSZG92tzuT3gh0RTEb6kAG?=
 =?us-ascii?Q?ys3gMT9+oueu4VAH4sTJEkr+aHEYR5U9dy1CoLkcBy4RH9Pd7XEHrJLaT0XM?=
 =?us-ascii?Q?i2ZZDqqERo+PJLhIW/VP0ydYkDmu5QVSOzOPFlCdR3BTGNBdSueB5dcdGf41?=
 =?us-ascii?Q?krWwZNyhR9IfmmJe6R5J26wfe7WaeMggo5e9Cev01Jahb6cMMU0b/wcDEmt5?=
 =?us-ascii?Q?OYN9vrnNenMMQkOaw6OGRzD3ufApbu6wZtzycRtWVe0gPhGhixqNEK3DvVBS?=
 =?us-ascii?Q?jueOAan/dVWvB9u3WERZ98dHgIUh/2MBZL1M1CCvzgi3jHqiWEQl7aD9nmxn?=
 =?us-ascii?Q?UE+YtLKxGK2k2ebhZU0Xvm8kIF7Bug+yvR2wekf9uqTf1ASoOdu3zm6cvocl?=
 =?us-ascii?Q?BfPDj5Gr4V/TzQAwOdjf5hFM3u4j+ag3ARtc2wPmcH3ZrDODfDMN3CTW6u2K?=
 =?us-ascii?Q?dH8Ps8E6FAJ3qiY0f1dKj2hDO+y6TUgKcaet+PIk4pI5KgY8RwRMuJ5pk8ob?=
 =?us-ascii?Q?CIgpkoRPfezGWOsa9tySNfCRWvkYonOHxF+3ig8MoJZ5dXH1Zil5BzIizo6v?=
 =?us-ascii?Q?9JOWJpWOerdFusJ9ZH0MPdienrwv9k+mIK675gqt/Y9P3c7ZW70ifgnleAR6?=
 =?us-ascii?Q?++lk8IfTqxKt/aXgR3Iet+eDpHJlydwXtuuWGDqaRFY7XdcJ14upZjcJeeji?=
 =?us-ascii?Q?+fmcxPz8jBHxwE6Fwt4B9NeuPaVa4dFkFDMy7EkIZBnkgXGWHrsLmXMFaQ7F?=
 =?us-ascii?Q?a7zQpZ5PsfboIo6ci7CTtxPJnFA7JW624szbv1tHEI/dT0apQyZ42dtc302p?=
 =?us-ascii?Q?YYoZ5nj982d/c1zQj8tR2t+9opto+NbF2Ka8kPDSAVZ3TBO5L5UQ1YTxxJHM?=
 =?us-ascii?Q?S2h1YP1KZIfLm60POODsiwmS4Dh+dBTAi0YW52Q3yQN6quaIrOTKP2cOgar4?=
 =?us-ascii?Q?aSLr/S0pelEUqjOS2OQ2VJRFHF/v6rrKjzYQTaIT/oNkXkoe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f58abddb-33e7-403d-93a5-08df369bebb8
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2026 15:39:01.3174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0J3kq/MjrxCmyz/deJVUU7IHp7ikFuQcTG2R/ScS6ArTGQobVxjo+23OQ3ys3l1D
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8007

On Fri, Oct 30, 2026 at 03:08:52PM +0100, Jiri Pirko wrote:
> Wed, Oct 28, 2026 at 04:26:15PM +0100, aneesh.kumar@kernel.org wrote:
> 
> [..]
> 
> > 		available authentication methods for the device.
> > 
> > 		When present and the tsm/ attribute directory is present, the
> >-		authenticated attribute is an alias for the device 'connect'
> >-		state. See the 'tsm/connect' attribute for more details.
> >+		authenticated attribute reports the TSM name only after secure
> >+		session and stream setup succeed, otherwise an empty string.
> >+		Connection control uses tsm/connect and tsm/disconnect.
> > 		This is a "link" TSM attribute, see
> > 		Documentation/ABI/testing/sysfs-class-tsm.
> 
> [..]
> 
> > static ssize_t authenticated_show(struct device *dev,
> > 				  struct device_attribute *attr, char *buf)
> > {
> >-	/*
> >-	 * When the SPDM session established via TSM the 'authenticated' state
> >-	 * of the device is identical to the connect state.
> >-	 */
> >-	return connect_show(dev, attr, buf);
> >+	struct pci_dev *pdev = to_pci_dev(dev);
> >+	struct pci_tsm_pf0 *pf0;
> >+	int rc;
> >+
> >+	ACQUIRE(rwsem_read_intr, lock)(&pci_tsm_rwsem);
> >+	rc = ACQUIRE_ERR(rwsem_read_intr, &lock);
> >+	if (rc)
> >+		return rc;
> >+
> >+	if (!pdev->tsm || !pdev->tsm->dsm_dev)
> >+		return sysfs_emit(buf, "\n");
> >+
> >+	pf0 = to_pci_tsm_pf0(pdev->tsm);
> >+	if (!pf0 || !pf0->stream_connected || pf0->base_tsm.error)
> >+		return sysfs_emit(buf, "\n");
> >+
> >+	return sysfs_emit(buf, "%s\n", dev_name(&pdev->tsm->tsm_dev->dev));
> > }
> > static DEVICE_ATTR_RO(authenticated);
> 
> I had in mind removing this attribute alongside the staged connect
> change and reporting authentication state through SPDM_GET.
> 
> This instead retains the attribute and changes when it reports the TSM
> name. Could we settle that together with the SPDM_GET interface rather
> than maintaining parallel authentication-state queries?
> 
> Jason, what do you think?

I'm not keen on any of the sysfs, I'd like to understand who is
expected to use this.

If we imagine a systemd-device-accept-d kind of flow I don't see any
need to duplicate things in attestation subsystem in sysfs..

I'm not sure 'stream connected' is even right, as in my last note we
should not consider the thing authenticated until we actually pass
userspace EVIDENCE_ACCEPT, even if the TSM has established a SPDM
session.

Jason
