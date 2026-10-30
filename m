Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793375040;
	b=EBchKVWnHyJNydJII/bbXHMCwAAxCZQ6gBlTz5zvkDPq0zf2H4EpBMxxByXtk5br2A36
	 He29Uo+Kutc9gTyG03qVQFFUv8kI2NZ7EjKnT59n3pyPXxzlNTVV+pmx633VppPTGmHQt
	 v9Iycx2is4TXjS/4SDEARJ5ttGcq3Ok5ye1gn3hpFo85TKZRdx6EzbBtbiDXP6S8em2gQ
	 l77/yE9+/J3vVaWHd4Iph+JpeUvB8i7CU3+VYTtY80nBGkRGFqQ4rvTcVCXqCy5IrJQhW
	 O56Ti4F0TbZYJTDxK8GZkjogAIhLL5wZdZX7lvl3viA26oqKjEwnm9t44ovXySGgFQg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793375040;
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
	bh=lOBOQo/hnirY9ytpckvRzdGVTdDTp4PuY4spWbuCAoE=;
	b=vXn5PALd65BhZzES8TOuQlkpTHCBrVKdR7jMSw9llka9AZpMqCcajGzXhXPOpp27ASSt
	 F8ayabvB3SuZb/W5VYO3/En6LCGaTF4foCIKYY+QjNLRYRv07OalSD5dbYkq78iSWJe5J
	 nm5NxHWhrSvOffGgVBDvfFXDnOmGr1Imm85tShrav9M6ojR/LpsXkBwsUMCembISkvOhP
	 A7VxynWlTvELVu4ZyomgQyQ5kppk5jODvb8piPE0xz7+trLJVg6w7WzitQJLyae6ZSaIb
	 r3cux22xsu8etYoc/HC+h7BrpElVqUC8XDTC1JaS4iPq5vWsd+orH89nzdRoYcqh/nQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=mMD9Bkvd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.42
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013042.outbound.protection.outlook.com [40.93.196.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBE1606A322;
	Fri, 30 Oct 2026 15:43:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DFBE1606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=mMD9Bkvd
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yp4lBzNeA8M0pRlq1yWTe9qUVglIFD+1YQFe1WPKnLgTxxgpDkPiKRuKAV6g7nCoroNg5KIzKkh+ljeAm/NiDTSDLo00QSrn1ooqLySxcZV4Ji+zgY+VPHjP+CjGvnw9squ8uU7sLlU7fcXFm7HgUv9gW+HpyrpUcaoBHUFw/sBMHTwjIKw5DhuhmXs/ki1Oql5H4lWgggF0y+7TBmZsXQxtWb1Rgn2HA1dMVKdWddEOBlvAK2FmoPgQHkQpOfReAH0grknj9i7ZxjL6KFzabLELxLmYEbrEEFixCrNIzPNJeakRj2hkZ2DKvjqaz43HHIx2f7jiSt4WUXWketRbqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lOBOQo/hnirY9ytpckvRzdGVTdDTp4PuY4spWbuCAoE=;
 b=tHt7IGiiJCw3NiMQdQRMAJS6z5dr5MJiAwqOpeLDvTzzuW757/IliRE4p2j3gPolsMuon4pfy7KuluDiWACt+C09Dk0fNWiHPgsv3H2WMnqEns0z+i6k/HIIkDtSYlTzcI4IPHNgmwlTCRasG1E1neHXTj4QlsdFhD9uDKoaYR7SGjHrlPXBv/eRtoX55WKGxB2N3foOOzjIP6LbMw1QSbavURNZIWYGEmbJQigB5WbiOHxBS551etxloyD97kwD4FUTyn49dEMRLwOJxjKdMNn+Dbw7LB5hkWcarLFAstLcqOlBwGNqKJBHr0wBy8Xf540Lc5kh5BhwziI0tK0ySw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lOBOQo/hnirY9ytpckvRzdGVTdDTp4PuY4spWbuCAoE=;
 b=mMD9Bkvd6hkSlOhDpOllM7aJtdo0pAoN33P8KHUL0rMRTXNP83j+mePLJWlY7bZH7tHPi8tGVshKRwaj9N7iC61xx4aIzUpOvGesJiSqD2GCsg072OMkm7RCqgcFmiE8c4Dw7TLIv5YRoQZCK8mkD6hYlDlSVET3tdha8AExVRUKz7m+jyw5viVR5Rmeb7/t22Xm31bCVtaQTPgb08ipq5g9fGcewAZTsT3cCIi1pFh89qX7u3JmHqvExIguus8uae96jVEbTHNEsP2zdouQahK+c8ppAIcLd5iU+VTj1+nMfjO+8OeoiX+RspPmmtidLIMO3ZvKwZtD2mL+JD2IIg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CY5PR12MB6551.namprd12.prod.outlook.com
 (2603:10b6:930:41::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Fri, 30 Oct
 2026 15:43:54 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0569.009; Fri, 30 Oct 2026
 15:43:54 +0000
Date: Fri, 30 Oct 2026 12:43:53 -0300
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
	Mark Rutland <mark.rutland@arm.com>, patches@lists.linux.dev,
	Dan Williams <djbw@kernel.org>
Subject: Re: [RFC PATCH v1 06/11] PCI/TSM: Describe the PCI attestation
 control family
Message-ID: <20261030154353.GN3734323@nvidia.com>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-7-aneesh.kumar@kernel.org>
 <auShvL2m00S70H3d@FV6GYCPJ69>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auShvL2m00S70H3d@FV6GYCPJ69>
X-ClientProxiedBy: CH0PR03CA0239.namprd03.prod.outlook.com
 (2603:10b6:610:e7::34) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CY5PR12MB6551:EE_
X-MS-Office365-Filtering-Correlation-Id: d89e82b9-b91a-475c-471a-08df369c9a8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|7416014|261026140227099003|4143699003|11063799006|261028144727099003|56012099006|261026121527099003|261021121427099003|261022115727099003|10067099003|261022105027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	DJ08YWqAPgmPXb8bM1gTXTMi1Q9+Cf+zyqFWnuPsWtuZe2Rc+xWJ7ZjUlQnTbu2CfLix29C920FE6dr1MkQMhgMHuTW6R0ZwcAnEhcoLiH3cqVZK0ZsOGdaG0mV8cqDA70nQNiKgLuFfH02q4seLetsmYdUhpCKzKRvEPV09vDh7zZIG2GaabFt66ac1psx7XJRAm3g8wr6W26aKwYUgichLUZQCCZniG/tRxdLRmNYjh5XvTYUNgHXGwlYrYDjbDCpT/Y7Q/wBPJnk3DICGcyXS+hXL71BU4re4gzcfABcmquQtIDrPbcVQK4XVhmQYAt8Mx1QRavo2AxDFghcdA6UEtXhD3jkgnozqfFWOfvGD5FfuzdEF7l805oJR9fobmhvkoml6YxSJbhJqs+1X308TL+3da+xS+JIL3cljLY3RssuyOidBiSY9a8u6dCN6k0uOy3shGDJXcyalyfZSFkse3E8LLgdvuCr+2KmEe6qHx/XKhn5RuVto+V1iytPI39bDcfLdrQT6Fj9/3xwXd7ibewU/DQzMHMP+lMU39CPMvvaVn/iC2dBvUZZj6LFjluVC5HyizCRwQJDLBIARxY4Og9JE+aRybHArMLqCvb3tHECMYiYbvZ3czwu5fMU8yFk4JGWD9nkWD29/7vLuomwSBnymaQWPgTc9dKnHT3I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(7416014)(261026140227099003)(4143699003)(11063799006)(261028144727099003)(56012099006)(261026121527099003)(261021121427099003)(261022115727099003)(10067099003)(261022105027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aRduBhRSh7kGfswA+qfkLwHiAqm8KShTiVw39Wyg8vXbpEkXSiAtS1lmgQxk?=
 =?us-ascii?Q?PBTp8PdNcCFWhEwZJVTxlyHQ6lWcaIp0nIZGDIIyovSboxcLK7pdVLDEkQ3k?=
 =?us-ascii?Q?4A2tLEKhVUNsbJI12Y9ueplNq4l3bGx0wUYKiFdPk5KxvYpZmxQGwLQY2sA+?=
 =?us-ascii?Q?9FeVmSKeo6PymfXOr4fwLPU95vEGSefNQ5lZ5+rtle89S73DN20Okx8/AP/a?=
 =?us-ascii?Q?f0hKNjX4aWBf4CxtJI8cwtbMSuXshB+EKlwhQ7Hw1O98gyZx3+TJQ+thz6Ul?=
 =?us-ascii?Q?I2h2tQF6mE+BoZ9mvZFfio36zAYkxGjAnwBEV+MgiEZkRSk+EBmPUzHkwanp?=
 =?us-ascii?Q?dTLIDOO8r8wRUMDaCG3AsPJ0T6UYxgeY3zU+ATZBDkP6bFAaJWan9wi6SLQA?=
 =?us-ascii?Q?saLTVLSs51vtauRO+PZ22ukkxI4KbLyhTOEkHJox2bG8zysADqTywckCq0aZ?=
 =?us-ascii?Q?aymQpIX3n22nEAPa7g5qb6DisKayCecBeA4flM2OwPF8frfEHD+RlxVhTZ0A?=
 =?us-ascii?Q?N+olH15EP7Ft5BaWg2NrYLc+TjFTd//UGHZYT3kRTP8XrYjdATe3IOUopZug?=
 =?us-ascii?Q?9IogO7jzhWcv3KsvwoZD/8WeHy77t0coTcYGUurzlpgFr5l0NwrD6/achOgY?=
 =?us-ascii?Q?nEcMihkLoFGBQ+6PKxs28X9wzauYxe57nfHQLMR9wVpZt1qdzv/wnaeIRTrx?=
 =?us-ascii?Q?9X7ferc7RaJJQiN/SND4h98kaAdVuh85vjLYRy7DbrFH1LpG2VY/TIiJt3E/?=
 =?us-ascii?Q?ulojmAr4d0mmqHgB4QQjzVA9Hk6NG7C7e+6o72Dx/qmo9A6w/YNp6mzuoDAL?=
 =?us-ascii?Q?HbyW7tsHQyRU06nzBGKN9N91by5ku3iq32lX+XCJKeqbsAx++opyAc7Z60Z9?=
 =?us-ascii?Q?fOU9MWGppa2iutmZvAJlfNboXYcsWpiR7ivaG2mnjdvHluea2+4V8aB2QXgt?=
 =?us-ascii?Q?mlikelYjYXCSgCp9sFiPvEoCvxmIDLzWqG0D1LSP7nhkdvfO3NqonF3Dg2uq?=
 =?us-ascii?Q?cChANrccpJK0eK1lHgfiK2uk42IXyaYL21qZxqN2mIiFrt59UX9Mapmw52BB?=
 =?us-ascii?Q?OlVgl0xTvYNYr2GV14Dwqji2w27raf7Mtci/UhZDlbaFEXEdWsFWWKGKcMUA?=
 =?us-ascii?Q?nIQJSI0qv5Bwvd+7+Hk0lpCthjNJMNthz4NlxYiCNa19jisVICGCUxeBFEjj?=
 =?us-ascii?Q?TPDXIa1nyXPyUTuahsGzIzP7VttOM+5yk2z60Lgv4v7J5fFeWX73E0CRnHn9?=
 =?us-ascii?Q?qn1kresg+b+cdCGOcyOZXqWPcpGTmJkrAQhJnSwSa5jPgth3rBEcOLIeiScB?=
 =?us-ascii?Q?egR0ff57Ywx+dQdH/tr2o2rNx0UhhNtCnu1ZA1PhM/MkkJ9Hvz1bGFz3ZyGd?=
 =?us-ascii?Q?hDDPVRcCjrtcjW9Vg67wTU1bXP/oL2e7+FhpJ3DhgVWrpEjnwnljLfx9uWwY?=
 =?us-ascii?Q?mrEVQNDHeKnW+1CvUPqs8+9fxJDAXv+9aSnYnusfIdP0cC+hTfwKPtE+qBbi?=
 =?us-ascii?Q?gMl4kYjJ0qT6+Yz4fJJmcoPyf+h6+HqhAyN6utU5+jev4SGHwL6oeJWzQmZe?=
 =?us-ascii?Q?IrT1aNpTY7R+McDH/YR2MEQWRnk9bUaIB3mPfGm6ZqUJYhRkL50PbvcRBDX9?=
 =?us-ascii?Q?QBmJ59qFZemH5dPLsNP4YaydXIH4BhSJRuz1H6LLvO+YOHG3pkrAGzUzmUDp?=
 =?us-ascii?Q?iUXrn2cgNG4a94k80Fc2Ru+LTqKX3du+dGmzGUPaVWtajRLx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d89e82b9-b91a-475c-471a-08df369c9a8c
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2026 15:43:54.6305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lZUSAea94RR9ynCaDvtdepTO+FFSscNjZb98haWbrZoD4T5LuVuApn9NnDpcTUil
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6551

On Fri, Oct 30, 2026 at 03:01:29PM +0100, Jiri Pirko wrote:
> Wed, Oct 28, 2026 at 04:26:13PM +0100, aneesh.kumar@kernel.org wrote:
> >+    type: action
> >+    fd-access: read-write
> >+    availability: dynamic
> >+    optional: true
> >+    request:
> >+      attrs: refresh-request
> >+    reply:
> >+      attrs: change-reply
> 
> This differs from what I had in mind: a transport-neutral
> ctlv-attestation-spdm family with SPDM_GET and SPDM_AUTHENTICATE.

Yes, we should try very hard to keep all the SPDM stuff as transport
neutral as possible.

> SPDM_GET would report discovery BaseHash, discovered slots and their
> certificate digests, authentication state, and the effective
> authentication slot. SPDM_AUTHENTICATE would take device-generation and
> the selected slot. EVIDENCE_GET would retrieve CERT_CHAIN with
> blob-instance=slot without selecting the authentication slot.

Do you have a mapping to ARM RMM operations already you can share with
Aneesh?

Like I said in the other email I imagine a pre-discovery phase to
learn the slot number (with rustspdm), a connecting phase using the
slot number, then a post connect authentication to inspect the
certificate chain and evidence.

The certificate chain should be available at the first phase and the
subsequent stages should not allow it to change, ideally..

Jason
