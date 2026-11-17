Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.71
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794925235;
	b=1q7G+EPUi25Mr55fAPt2iDiYsibKcXnVlZDTM+ye2XkHL/VnUN9ACHltJA+sJ+27Gmfe
	 XLGm8STwBjmXp9rfNK9SMvhPDaw4iyBYIGVQXpcZyH/WGnT1l60CDyXBaJL0fCbYZ4wMf
	 qlZ0MHjNHiRUninJPUTMZ0DkhEjXXbMNPqNniZuLZmIFHryLRX6rm85kZr3Ry0W4MuoT0
	 UXP8gXqkcl/xJ8exklQ+/tYXtlcyUDGTZhqg7I8ARCUC14PkGmLowraGAMMPAXgrfFfy5
	 a0YzVJnjTwYcPm/ushDllmbqE8aMosI0Oqbn1OQ4ZvvLG9dEfDHxGkHEWgjW2fUrl3g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794925235;
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
	bh=jcaBsuHtCy9NzW852TQGGPETuRG9kQ06yN2snWy34b8=;
	b=inMxe5/yFFeU7aGK9QSWy4ykHhLJoZb3uqHfRc5l29HI6rCGcjn0MlbQ1Cve/SLY60ri
	 Ffz+2dybAJ7/F/nVdMdsH/JI+mFYoHOPumCkgoLD69OPI0wnCyYxeJ1mAHqlfRYtIaAGB
	 BX1sz82nTbwI6HSKW3p86K4LE+VDEPrc4J+eglV9WEHJHw6PPDfUTUVMwkm5IhXJLqP4P
	 t4rnE6TZXMUJUBw8SfOfvSWdPSbVp3xfHPhDoUpEUuyzaTc5ZzeJZ1r/QrzO3ev6CxUAz
	 4LQo8nF+Y1fxt1p0HQeD9VN7klmMx5kiIx76kzXkIJsR9hu6pfglZ3zbkv8DaXmHLRA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=VkXitjOt;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.71
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010071.outbound.protection.outlook.com [52.101.46.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F64E606A31C;
	Tue, 17 Nov 2026 14:20:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F64E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=VkXitjOt
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jDUTcbm8G2FEHDdRzSfizQwE7PExUsG0NHdSyz2AVASox5PLsiq5PiVwPbmL9X9LO/v889YnlShwhjVk5YGUMcwsR9bvnZYack3n4l6O0rFaZvgqRez3TZUmQ47IKzKopB3wSgSv9AkISwv5a422xXqMiuM/kxrMOA3VjinX85zrvEjb0AluwaUwlz8ErgHW4xhdTYliZfvFgQEkcV8Bs0EJiH0Bc8Ilo/4XxCUi7WDwe35JWYAX3+3cfVfTGgT2VaUo8jImn14Z1o6y82YdlkVTnOn3KW7GC+2XGxez1sf1ckA0gkw4vVpDxpYUbpCi1iyleTVKJUPLDwWu6IrZjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jcaBsuHtCy9NzW852TQGGPETuRG9kQ06yN2snWy34b8=;
 b=RFBkcA1/DYaUXUcC4cHXriWLM10Ci92ATT9yQIaY9j5u+S9/gY76hLd9nyTkOAkZ0a5HsfLmcPZRJUrKFCws9loXzX80HQMcEmuDtJRzTOwgKv8G1pz5bBi3Uf6jauZoZZ3+tQRcoBYqQSbL4qqIMAdKaFPPjJXWxzL9TI54oMcE+tN8NWXwFdOSuNVEMZ23ZmIo68jcPLgP2wYwAk949vbb9D8L5BwZvVJMjWHh5YjD0UCQU4pYRxtKZF5MBD9xE2vgJG6fyYGmhhvi/HTSBy+qz0Ge7afyyHithXCfJpBnatLLS80zEVCocQcSfEiBByC0rtpxjxVC3+wbxNeuOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jcaBsuHtCy9NzW852TQGGPETuRG9kQ06yN2snWy34b8=;
 b=VkXitjOtuQmmX4fxTupguV62tlBf/AYq14RJMCB/+klOxkRvm8Ac/J/ZC8mqFeQ1MjO/jB+YczUaZeqgDFtIS+DUIj6kwhMxk8HMh0ex+xECDiPAB0nLJz5Rsqw4BHkbFKWVe/f3f0hJzjA2kmVwJtQ22lB+7n7XA8QLttMPvauDlYc0nFaNKwHHH95xE9MzQrK9m/IrHjOzAJLdJsNAIVyF7uMizHzbPjJyVNAi60xOVhREI97YAgWjkyagzYTZQxwPbnnz6ZePil894KtfqEHxzKK8F5M/MflWHoCjb87WOIQ1v9NnKsVfPS/xMcxSuRdIWWghg7daYPQv3Z0r/g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS0PR12MB9038.namprd12.prod.outlook.com
 (2603:10b6:8:f2::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 14:20:28 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 14:20:28 +0000
Date: Tue, 17 Nov 2026 10:20:27 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	"Jiang, Dave" <dave.jiang@intel.com>,
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
Message-ID: <20261117142027.GI2245175@nvidia.com>
References: <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com>
 <yq5a5wy2qtjs.fsf@kernel.org>
 <20261112145254.GL738765@nvidia.com>
 <DS4PPFA84FA90FC465DE2D4A57521CEB991E77C2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261116143319.GA2245175@nvidia.com>
 <DS4PPFA84FA90FC9031C253514720694AFBE77B2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS4PPFA84FA90FC9031C253514720694AFBE77B2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
X-ClientProxiedBy: CH0P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::13) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS0PR12MB9038:EE_
X-MS-Office365-Filtering-Correlation-Id: 691ad710-75e8-45cb-a9aa-08df44b5ee3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|22082099003|18002099003|6133799003|3023799007|5023799004|11063799006|4143699003|56012099006|261022075727099003|261022115727099003|261026121527099003|261022113327099003|261028144727099003|261021121427099003|10067099003|261021123027099003|261026140227099003|261009223027099003|261102130727099003|261021130227099003|261102123227099003|261021135927099003|261026130827099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	yaCnaB+UUOnqlvqTDnANaMcIjvi2z+qYdIF3aVASdORfaFh8ru7BDqdS+gcKq+MEvkuc0KwWk7TGaVGMuFBM6AIowKvjS7QmAFWEzlEeNYBGrqRHGju36kkUP1KjHVloWirDZT6qM9FibQhNPCXFoFxjBluKPr4xItar9e0SBK8BJDLTAOkzPlJ8jyxXRqEsKj6FsdjFDOepRXIlxEutdczpQfk8uPFed/OJtpW4CqL7k9nO3hl6OgogKT4R13GbhUD3U5K/pX8hCQJorRB9CgrqIG3t2QV6KW7xnDxDdah7N7Qm+FHGxK+dTV15P3cSpxbpm7Pu4nfGSPO1qimmveoDpj0FXubHrGHpzBOLgVtoZQxhAji4OR5gwVGjXhJdmNgKNxAcv8DDPtijHdo/4gZ4pZg+npXUJ2L3p4FUT8uSd4LB/kzR7gwGHH+QelnqS3IHltF9RCt7738qHVTeWUrNcHJnuIDKytwBJcmZBX1idDLo5WQaxZn6PZu4vmOMY5zSF/E8PrOuDmFIlE7YerAHjo0ni8G9ojnUaVsb22nP1AmsBWNv9PBy1r+2Ki6XC/aQpqn0b+j2fYNXdov+DTVZ3VzDZ+rL/ti6ZmY7slJPeH/YT7FoIPtT9KIeRyeAnDjmbwsm9ce2uMmL4Zr16ChT+wd8MKqMbd1HqDz4u/E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(22082099003)(18002099003)(6133799003)(3023799007)(5023799004)(11063799006)(4143699003)(56012099006)(261022075727099003)(261022115727099003)(261026121527099003)(261022113327099003)(261028144727099003)(261021121427099003)(10067099003)(261021123027099003)(261026140227099003)(261009223027099003)(261102130727099003)(261021130227099003)(261102123227099003)(261021135927099003)(261026130827099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sh/edrSQsRMTP2JPniRIu6+45eaqIne2wJBNjNc+dMU+nfCyyAOddoOWzx1R?=
 =?us-ascii?Q?q0OYAs0Syvj2eE1POWrpyqPG6GPnluzw1i8Tma3QBUjphojFut3UO3BSmDf/?=
 =?us-ascii?Q?mAa/MsE4A40L3x2xUN8oFKFtWkJU6igvW84B2ETJ7Rah5GYDLkqOpWiPvpfs?=
 =?us-ascii?Q?6fQ36uV+1gWBjFTc4H/fn9Aj/utK1HwAtk16EncaCM5F1I8Ao9SvXVibp/QJ?=
 =?us-ascii?Q?FcxcEIrzOdyD+rFxvJlRPIbMgkBmWzMBCJuApJDaRoI0YuQjDVNoM6mYzffw?=
 =?us-ascii?Q?MfcNQGr+n214AeIg8wn6VmndbDkcWphNIUOT/e5NJ9YV2oIrb1e2J9ciJCF+?=
 =?us-ascii?Q?oyDWTXdzHOd9ol0GI2Jv7o9SnANhOmxW+T1md8odvYUpKhKl+5Qqh7yS4GjL?=
 =?us-ascii?Q?0xKOYbLec+x6acdSu0epWWs3Da9EvuwcO/z09DE/WmFZszQCi0J1Ppne36JQ?=
 =?us-ascii?Q?cPYmFOpwSGvWIZYpMpDcQwLT/5qTea8/YiGsbu4RVQ2w+GKgNyzuvNH5pZUw?=
 =?us-ascii?Q?0nmiCvoVFWvhh/4EnPdP3XuuVWzHzVa71hyVHQ+bE6Ixtc5w/4LuKrnXT6P7?=
 =?us-ascii?Q?uNs0dT59fMUJtYcUapo0gjC+NCjg+fcxLboxib9UNJarKg1Wj6zckWStO5G2?=
 =?us-ascii?Q?ufN9JJKxyrh2KqtdZwfC1Ig8OK2aASUKU1ys3dGR+Iy+hi1Taed+0Jf/slNE?=
 =?us-ascii?Q?rat+cI7iDsFkAeLLBVm7tDZGWBsx2XwW6DpXuuKbRkCmXEGIThybt5YUmqVo?=
 =?us-ascii?Q?niArHZOnLhT1Ez0GDXUuPihkuiPkCvt0n6SKjumpJhxJT/zsMeVvZ4iwnURn?=
 =?us-ascii?Q?HJVwXVBtoQMNU0yXYNHzaUSe5tU+mswHEIN3iE4izD44wE9yBN4Lpk6eRtKE?=
 =?us-ascii?Q?hmeCJhFjsRYovIXc4a7Aqn7l9A+B4B1LxrA7+mC21GP6kZtxlIfkP1EIHA1p?=
 =?us-ascii?Q?dXyJRBxfpGWduCXyojATdU5JO0gSHiDdJqrYIcq11Xv8dxWovWHHTQOBNxog?=
 =?us-ascii?Q?ZM1GKi7A6XELiHHZZXF7ObdQWzkkI/DpM1WZ0P7P4xFyzK5wynp6IM7VQ9vB?=
 =?us-ascii?Q?jwXXSa8ThrXrab+9cLX+SaMl3FQl9Lc5xAGMPRWC8VjthDzcpk1l0XN/STZd?=
 =?us-ascii?Q?9ssUaiSzuZeYCPUu4OkuWFEFNYyUhz7J4pkrvUbiz6ja44VzVjckKHJ4RTOj?=
 =?us-ascii?Q?07yRT2qUE22mxs1UU8XZbVxctlRi+VCWeA8xygyhFk4qN4uLIB4WW6BUAtBi?=
 =?us-ascii?Q?tnKIwPNR5yUuqNWgso0d7VOKTtKJAbH7yYWWgvVOOOyQXrLsqhFjNpwgdtc+?=
 =?us-ascii?Q?o3eWUDry8dJ/4B8/zler0yxcfkIS51iAZElksD4b92Hrp/z0JdsmJuMEVnK7?=
 =?us-ascii?Q?TZ1eO2d4x+uIgwxMwRY0CLvWpcceiyj5wAm664rdNcpWSMkh1JAHOPn/N1tN?=
 =?us-ascii?Q?PJnf8ytDFolVXFtidm/Q6JNhYMo/f+UowUDF+rFgawZm7f54Ttg6EyS65XlV?=
 =?us-ascii?Q?xptL0uzPPCpmp4DTldB03yEMjotcj4qrSCzDYq4eQWMHXiVORHv3AD7DvbLq?=
 =?us-ascii?Q?0pCTz7x6ShRC+B77y+Mn4+Fx4iRFTjtpGjich240RBMfnC7IvEd3gB5flk6u?=
 =?us-ascii?Q?pqxCpZCRrTDJEoB878/60p/seC8t7OB9+xNyKIEeKEQdF4wUk/fA9JGzgwHq?=
 =?us-ascii?Q?DRcAqT5Z2/VxfUJLBLDEjqZ39IjrEIVGwC2KHMJMi2Sz+XcQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 691ad710-75e8-45cb-a9aa-08df44b5ee3b
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 14:20:28.8076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zZ5EiYvmUi3/9nH+3c0MuVBzl4USEHpgsr0qko7C6lbDrAUxGeZPYxg1MueVh/Mh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9038

On Tue, Nov 17, 2026 at 01:00:03PM +0000, Reshetova, Elena wrote:
> > On Mon, Nov 16, 2026 at 01:38:50PM +0000, Reshetova, Elena wrote:
> > 
> > > >  1) No easy way to get the VCA, no easy way to do capture
> > >
> > > My understanding is that VCA must have been included into
> > > SPDM_DEVICE_ATTESTATION_INFO_T from the beginning, it was omitted
> > > by mistake and we asked to fix it as Dave already pointed out.
> > 
> > That makes some sense, but it just makes this struct bigger and
> > worser. As I explained ot Aneesh I'd rather not have a VCA at all but
> > the transcript that includes VCA (or is maybe only VCA) with preserved
> > message boundary markers. Userspace can compute VCA for the purposes
> > of the signature hash.
> > 
> > > >  2) Wrong digests design for the guest.
> > SPDM_DEVICE_ATTESTATION_INFO_T
> > > >     is a terrible idea since it is not grounded in any spec. The other
> > > >     two have multiple guest digests computed directly over spec
> > > >     defined objects.
> > > >
> > > >  3) Even if you like SPDM_DEVICE_ATTESTATION_INFO_T it includes
> > > >     TDISP_CAPABILITIES for some bad reason. Nobody else even
> > > >     exports this info from their TSM or digests it. Thus Intel would
> > > >     need unique API for the VMM to even build
> > > >     SPDM_DEVICE_ATTESTATION_INFO_T. Not nice.
> > >
> > > I dont think there is an expectation that there needs to be unique API
> > > to build this structure (I think we can hide it in the tdx-specific code), but
> > > your point below is valid: this SPDM_DEVICE_ATTESTATION_INFO_T blob
> > > needs to end up on the guest side because only using this blob the guest
> > > can currently verify the evidence of the SPDM connection establishment.
> > 
> > Right.
> > 
> > Any every other arch can build their digested data in the VMM using
> > the standard APIs because all their digests are over standard things.
> 
> So, yes, if we dissect this structure, then the unique fields that Intel has
> are:
> HEARTBEAT_PERIOD, TDISP_CAPABILITIES, TDISP_VERSION
> (I am not listing SPDM_CAPABILITIES, this must be part of VCA)

HEARTBEAT_PERIOD will come out of the transcript as a field in
KEY_EXCHANGE_RSP

SPDM_CAPABILITIES is in the VCA

TDISP_VERSION is in the data from GET_INTERFACE_REPORT which needs to
be a common API. Though this is probably the selected version not the
offered version.

Only TDSIP_CAPABILITIES is unknown to userspace. I don't know why
anyone needs this or why it needs to be digested. Nobody else did
this.

> Here I also have a generic question: does Linux plan for the host to
> implement heartbeat (can be very useful to understand whenever
> the device is still alive and didnt silently terminated session) or not? 
> And if needed, how do other coco arches expose this info?

I don't know. I haven't investigated this question..

> TDISP_VERSION is more interesting. 
> It may be security sensitive, i.e. assuming some
> problems later on found in existing version of TDSIP, new version is
> released, etc. So, downgrade attack is possible from the host
> side and the guest wont know, if vulnerable version is in use. 

Huh? TDX module is trusted to negotiate the TDSIP_VERSION, host has
nothing to do with this? The selected vesion is reported in
GET_INTERFACE_REPORT and that must be digested.

AFAICT we don't need to double check the TDX modules work by seeing
the TDISP_VERSION from earlier in the exchange.

> TDISP_CAPABILITIES are harder for me to judge, but I can imagine
> a scenario where a guest without this info can be led to believe
> that a reason that a given TDI is not locked with certain flags is 
> because a device does not support such TDSIP capability (while
> it does in practice). But I think it is still guest decision to either
> accept such configuration or not regardless of what device supports. 
> I will ask around more for potential problematic scenarios.

Right now I don't see a reason to even expose TDSIP_CAPABILITIES
through the UAPI since no other arch will implement it and it isn't
clear what it should be even used for.

Again the TSM is trusted to do the TDISP negotiation, we know this was
done right because we will attest the TSM.

I don't see that we need to double check its work. None of this is
even signed so a malfunctioning TSM or OS can simply lie in the
report.

> > So if you keep this then you have to get a uAPI 'give me the intel
> > blob' to build your VMM with. It is not impossible but it seems
> > unnecessary if you'd just digest the right stuff instead of a giant
> > struct.
> > 
> > ARM keeps several digests:
> > 
> > protocol_data_digest = H_rmm(VCA)
> > identity_digest      = H_rmm(cert_1 || ... || cert_n)
> > pubkey_digest        = H_rmm(<public key>)
> > meas_digest          = H_rmm(GET_MEASUREMENTS || MEASUREMENTS)
> > report_digest        = H_rmm(interface_report)
> > 
> > I'm not sure VCA is strictly necessary. pubkey_digest is because RMM
> > does not parse x509, since TDX does it also isn't necessary.
> 
> Per SPDM the signed GET_MEASURMENTS || MEASUREMENTS transcript
> actually includes VCA.

This is the hash of the message bodies, which don't include VCA.

You need VCA to compute the signature hash which is why everyone ships
it around.

> And this is where in our original SPDM_DEVICE_ATTESTATION_INFO_T
> struct VCA should have lived instead of being a separate structure with digest. 
> Would that be acceptable? 

I'm not sure what you are proposing?

My concern is you have this digest over a struct that isn't a protocol
struct, so we have to make a special API to pass your special struct.

Unless we can get rid of that I don't know if I care what you put in
the struct, but the kernel will have to break it up and your driver
will be more complicated than it needed to be. 

VCA is immutable. It should be made available once and not repeated in
every single measurement fetch.

> And yes, in our case pubkey_digest is not needed. 

ARM's version of having the host parse the x509 is better, IMHO :)

> > What you want is an API to retrive measurements for a vdevice
> > triggered by the guest that updates the guest visisble information
> > 
> > And another one to retrive measurements for the host pci device that
> > doesn't change the vdevice at all.
> 
> Ok, so let me re-iterate to make sure I got it right. 
> You want these three things:
> 
> 1. No implicit TSM measurement collection at the time of SPDM.CONNECT
> (inside SPDM secure session) before or after LOCK

Yes. Host and VMM can manage evidence collection through the uAPI. We
don't need to slow things down by doing collections that many use
cases will simply discard.

> 2. Guest-requested (with a guest provided nonce) measurement collection
> that collects only SPDM signed measurement transcript (that includes VCA)
> and not certificates. 
> This collection refreshes the guest-visible digest of the SPDM signed measurement
> transcript.

Yes, certificates should be fixed during the plaintext setup
sequence. We don't need to refresh them, or at least if we ever do
want to refresh them that is some other independent activity from
evidence collection.

IMHO devices that change their GET_DIGESTS output while a SPDM
connection is active are broken.

> The purpose of this collection is for guest to obtain fresh device measurements 
> after the lock in trusted way. 

Yes.

> 3. Host-requested (with a host provided nonce? I would rather not, because
> it feels we need a clear way to distinguish collection 2 and 3, so I would keep
> nonce fixed to zero in this case or any other fixed pattern)

No good, it must be a host provide nonce. This is a host evidence
collection and it must have a fresh nonce to have any security. If
everything uses the same nonce it can be replayed.

Collection 2 and 3 are the same action. Anyone who can make
measurements can provide the nonce and generate a replayed nonce. The
only difference is if the vdevice digests are changed.

I don't see a reason to tag them, the mechanisms we have in userspace
to ensure the nonce is legit and bound to the VM are sufficient.

>  measurement collection that collects only SPDM signed measurement
> transcript (that includes VCA) and not certificates.  This
> collection does not refresh the guest-visible digest of the SPDM
> signed measurement transcript.

Yes

> The purpose of this collection is to allow host to discover device measurements
> by itself and potentially make its own independent security decision like
> it would do for native SPDM case (without TEE-IO) where host is a decision
> maker. 

Yes
 
> Btw, does any other arch provide #3 today? I am not able to see this in ARM 
> spec at least. 

It is coming, currently ARM doesn't even allow the host to see the
measurements *at all* which is a really big miss on their part.

AMD is probably broken the same way as TDX is right now from what I
can tell.

You probably also want

4. TSM controlled nonce

A way to put the vdevice into "tsm controlled nonce" where the vdevice
evidence collection no longer accepts a guest nonce and the TSM
provides its own random one. This would be a permanent choice when the
vdevice is created.

You may also want a way for #3 to run as "tsm controlled nonce" and
set the initial digest for all future vdevices. I'm not really sure I
understand how this "single collection" flow is supposed to work
though to be sure.

Jason
