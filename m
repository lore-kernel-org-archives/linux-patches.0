Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2067.outbound.protection.outlook.com [40.107.212.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5482D139D00;
	Wed,  5 Jun 2024 21:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717622582; cv=fail; b=nKjzpx0AuZR3IJO0/ICsquq2lq74jBAzgf2Eq8BBSzlPEbld6OukNEm4/mDbmqg7rP6WN3HCYyoUfoWTynQ1CNNbILZ/E4zlFKFD8caI9aOGGNc7+YnrQxms7H8G75xHXysgHZrvv87ROMm56F+iNTc1d6dx5n9fX/EBxNaqVVs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717622582; c=relaxed/simple;
	bh=oVAjUqW4SV1W2eBBhCqQV3mMZ2aRJZFoguYRT4GIIfQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cdWWx506T500eND8KpBYofFgjKJjZgS9tQo4O2GjD0e+TWv5hJd35zjJHUCbTBCEsAoZLfa8Za05uFmJyeFa+uC4VRtkbLlRUq2bBEgNJmXl+va0gNmwSqRh7ujZRezD/2tf6mPnw3AY2y5wiPhsSpDmhIIvc0ySuMxlM77tWNM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kEqghvW7; arc=fail smtp.client-ip=40.107.212.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kEqghvW7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FZNHDYinY2Sg8DKRjaV+ZvnEC6wBsKO94i7urYHHrCK6NWSweP7k1XJwGFPXAntMzLqeqU/ReGcyNdUwhwIYOiPXAWhNIdohJImEYdm1v+9PbO9EvMo6wiIaNjs7z0g8J59wkTRFREHwBLf3NktIwwy9N3QVzsDRJjs1Z7AZarufLEd1wx5Ectxo4SGZNk/pj/0BYseeGdfXi/8DKfgrbvVVIITpXchTGxTBqytpTF1UAOLbo1C1cy6ajL8SQS7zmZarOD6sIcxMvHzqL+xXBHx0arc5nPUJPNbgBOnmfTQlw0jsrOcKEA+JuBDQxTl0yaFVBFQ3BwdbORbMoRVZAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JxXE8L6Y7pB0SEu5a+nEk7PTsw+huSPD4SrdBpEd7lk=;
 b=Xj3edDCtB/s8366QF5Xym2hcCtXD07jCPzhoOlQvBzfKSHGY66gK1LkQtKTyutcy7JiLouq5Tkg+xt0hP+IBGysgP9YnLz6xVpIW/ppk3AGpjNsHK0zqXHDP3LzwOerhz2zBd0LSTkXiITsPOdC7sD13dwSZAHjtNE+niOajFgLyuhW+dxa/N2Me1aHFXbJay3my4Qfn9Af0zR1Mu/DHUNgSX8bo+w9BEVW4qlZ7Jqa5aiRKDJIzVmfghbn43HLSgIJ4CpRz++c3LVFbZ4+vM05vasDp6UMg4tnki5CXFhR7iJthin3jV6nOpsigKOpOHSImAJavxt0bGgi82wrJoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JxXE8L6Y7pB0SEu5a+nEk7PTsw+huSPD4SrdBpEd7lk=;
 b=kEqghvW7cdIWDsCWTf/6oJNq17UkPZODWQ2fv8yO/dLvCjTRJ3S/XH4V/uv/2jZLB2iYdU+17nadpw5tznWmRTuwF7O5gB+/C2ek1z3RQc2EGf4P55T4Jaiur2NSPMuKnq2xNmSJ4ODCwIRs3/RPG2gzckMPUP+1WCHo+jTTV17IpTD8ncPiqrahjZkQ3yKM6PlG6EhSqHemCk0vbcPy1P5oEweC6L24AqsmbqRvVGIaMKc9mPwcpGm1FfEmKSj7ZAwJEFIBOd5OWL7WpyL10xhMdsrF6Tr/Ww6mEIyBAopfdRHOEYmXsUE251mT9vgctasM82IeJqehWR9ZZ3IMpg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH3PR12MB8901.namprd12.prod.outlook.com (2603:10b6:610:180::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.31; Wed, 5 Jun
 2024 21:22:55 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Wed, 5 Jun 2024
 21:22:53 +0000
Date: Wed, 5 Jun 2024 18:22:52 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH 2/7] iommu/arm-smmu-v3: Do not zero the strtab twice
Message-ID: <20240605212252.GA2030792@nvidia.com>
References: <0-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
 <2-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
 <Zl85FOpIrQSeto4W@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zl85FOpIrQSeto4W@google.com>
X-ClientProxiedBy: MN2PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:208:23a::21) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH3PR12MB8901:EE_
X-MS-Office365-Filtering-Correlation-Id: 31ee0417-8001-4e90-59ed-08dc85a5a948
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SzBCUERXTlkyTDV6NGU2TGdMejVuYXJrZEpzU2RrT1ZlVStXcXA4OW50QlVt?=
 =?utf-8?B?Unk1YVZzYWxTTDMvY0E4cjl3V0ViNjB5NmgreFQ5dkZHbjBkTlBlajBmeGVY?=
 =?utf-8?B?Yk1yd2tnaXpReTRySStsdm1YQjhLb1kzT2lVZ09EUGlDMWhnVW5PZTFPVUxp?=
 =?utf-8?B?SEVjTityMWFMS2J0Y1dzN2R4dG10R0dJRE5YVitFeXJrZ1hrcmF3QW95YkpJ?=
 =?utf-8?B?M3pYTmRoWXlYZWFDUFJQaG1jOUZwcjAwc2ZHR3l0cmVHNkhNdnVVS0h4d0tU?=
 =?utf-8?B?VHA0S0l3L2xMVGd4YzMyeHA4MjFSeFdvMlA0OUdVMzZWWDgxZDFaN0IvQTZO?=
 =?utf-8?B?QnBLQlZXV0J4OTJoblVWUmo4U2ttNVVyeDlHRUEzbG92SURBUUtvY01lRkFL?=
 =?utf-8?B?QlBpWGR2S0xGRnBvKzd5RXQ5Y05CQ2dlOERsN29SaEphWDZDN3dnQ0JxS1dY?=
 =?utf-8?B?RW9CdGExQlhHRDJraVl5Q2t4YkJDL1F4SlRzT3FIejgxbHlyM1NibHZnNzF5?=
 =?utf-8?B?Qk5ySXNxb0h4OWlHTXF5KytoWDE5aVNDYXZLajcwK3pIeCtTRmpiajZoNEdp?=
 =?utf-8?B?ZlEyZldpUkhBTGh1YmtvZVFFUEI4NkQ3Z1VXSHpiNjcyOHJhTVB6b1FVRER3?=
 =?utf-8?B?NHhYRE0zeHVkS3RSSnpNNTd4NG9paUxuYk8xdUY4dnNCMkJ1QVpjejF5cnZ3?=
 =?utf-8?B?TkdWTFk4OUU3UkJXdXFFWTJOQmpxaGlIbzM1bmtUWU84ZTg1L21iQko0VHRi?=
 =?utf-8?B?WGIrZ0pJZDFKaXYzMm9nTHByWW5sSUUxblVrSHQxZk5aYjRocVV5YUUzNnlK?=
 =?utf-8?B?bDIreFdjMHA4MUdFRGxQOHRyT2JsRGthcUFhdkdnU3M5ZnlXZVpRN1RVdHJo?=
 =?utf-8?B?WWJxVkZsRHBBcmNCL09JZTJ2WHN2QXRoMjBobWFoeDh3bDNieXZPWlpTS0Yx?=
 =?utf-8?B?Q082dWkxTVQ5Z2s1czlhcHYrY2luVVN4em02b3h6QXNHL1doT05jRm5Qekl2?=
 =?utf-8?B?ZEdhQnYxVUJmNmVUNzFRK2pZczFoYmRjZjdSTkx1U1RsRm0wL3A0b3ZBajVr?=
 =?utf-8?B?RjdQNHV1YlllbkJPTFRsZG5aT0F3MnBNK0YwcmMxdW9FWC8rbjBZSFRNTzFm?=
 =?utf-8?B?cGQxeEI4OHFVYmF0dUR2cUZwWTRnWlJWU1hkdis0eWtjWFlrTzhFSnFhZFJ1?=
 =?utf-8?B?TVhqTWZqdWZXN2NYRWFzcituS0VMeStEU1hhZDZTdE44TUtpaDZWT2JBbVU4?=
 =?utf-8?B?TTFrVkMwSzlsMStQalFnQWpRdGllU2NzeVBsQ2xHMHRMQWl6dVpEdW1Rb3RO?=
 =?utf-8?B?VlNFNDI3clBZcXV3c24xYkhlNTBVc1RLWDhZT0pIdndvLytmcXVMT1ZWK044?=
 =?utf-8?B?TGkwbTJ2LzBMTFZpV3lQWTVmWVJ3OXBrVXloTHVpaVlxaHdZYUpBV3dTYVRH?=
 =?utf-8?B?SHhqSU1adHV4TnZlZ0ZmbmxnMTNUSG5ZRllTSS9YaWNZMnJaK2pGT2x6SFNQ?=
 =?utf-8?B?V1l3WXB5bVpDMXhNbk5wclJxVmpsODJjQ1I5UFR1WEgwVlZxZlMvaEdxT255?=
 =?utf-8?B?YUZRYTc5dS9RTDV3N1FkakZhck5CMVdnYW45OThGcmpyaERDeTZSa2hTSEFE?=
 =?utf-8?B?SzVoU2Y4Tkp6dkZJUW5XN1hKRXZRY3dvUkMzaWpmaWkvUDRzaU9XbmRSUVU4?=
 =?utf-8?B?Qm1FVWdwUjloUWwvUTN4Vm1hcUpZOWx2YVVKckRuSXcvOW9FMU15a1Z3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?elNqNUEzelZjZ1NObVRTdmYrbnMyMWoyWjhnQStZTG00Ky9rQkc1TVJxT2Vo?=
 =?utf-8?B?R0ZPSGpqK1dmNThnQWExSG1BMmtHQ0padjB5REQ5VS9WUlZFZnRHdjdzRy9n?=
 =?utf-8?B?M1l2bVdyRVpESmVBeG1ZSFdSOFFmdTlETjhyc3Jsd0VZbHdHWS9GZm1pc2dw?=
 =?utf-8?B?WEhzT2I5ZHlFSjZlQlM2MkljVjVMTFVTa1hQYUt4MGdQMm5jTEc2andVbTNG?=
 =?utf-8?B?THRwdEp6YTM4RUNuRDRFV1p4bUoxMXNlQlRuY0pxMENmbWtrNVNET1BMR0F0?=
 =?utf-8?B?eEJBUWl2WElrU3R3dS9DaGlKWStMb3g3Nk9GVWQyRWRQemx4U2hRL3NTQjlz?=
 =?utf-8?B?OGZNTmlOQmtOeUZuRVBIZWI4VWRvdnM1NmV4R2ZNMGNKZWsvemlHaStuRGlo?=
 =?utf-8?B?L0hUQ2sxN3dJckxoa2YrSGlBNUdSaE1VbDZkSm9HSXM4VW5RQ2VHQkFScEhB?=
 =?utf-8?B?b0tFWUpIVGw4U2VoK1NuZTdKQ0l2SXFxaXZGZjJGZ2RqMFZ2OHBkajgrclJV?=
 =?utf-8?B?ajBwMnNpZ0lTTzg4aVFVamI2VjdLVTNHbHFNMkhJRE8wOStpYTRKOXFsYW9W?=
 =?utf-8?B?RDVTSnErTlJDTitPeitDa3RHb1kzMlZVRnZ3UzRvSHpEa1UxNHdjVWNNbk1n?=
 =?utf-8?B?TTJOVEVjdGt1MjdLTWRINjB4enhiVU56dnRaZ09IUzIvQm9WTTNOd3o4d3pS?=
 =?utf-8?B?clM5dExNaW9FSXhCQVB2R1NzcjdaUFJEalExakd6MnFFWFpyQ09KaUh4UVNK?=
 =?utf-8?B?MjdpOXVLVTVId2VYYnp4TGRISmRXVDhKQy8rcG44cXRNMEtobGRSWG9HQVZE?=
 =?utf-8?B?dmlUblRRWlZpc1hBaEtYNms3R3JuNUpFRTh0QmJpdEp4dWlsZ1NIZFg2K25y?=
 =?utf-8?B?ODB1NmdvM1JvbW4vbUo2TVdGYnR2OUswZlFFVEtQdkZBTHVrL24rN0RsNDRy?=
 =?utf-8?B?ODlTQ3R3SHQwVHdub1dGSDdrZFVQQ3Y1TFFLVVpwckpJdEVTVGhNb1Fhd0Iy?=
 =?utf-8?B?ZkRvNFRVSitrME1nLzZyQU53Y0xSdjV3YTdvS2ZIY3ZPbmJ2Si9IYTZLNlRu?=
 =?utf-8?B?dlA0S0I3YnBrMGpGU2d2QzI5NnFiSldueE1LdEdlZGRVZ3VYOXltQ3JWU2xo?=
 =?utf-8?B?ZW0wREs4NHVDNFEzY250SENMNDZHSjAvcjdCMWRxRnk5K2l4eGk3cDl2UjFl?=
 =?utf-8?B?ZnNYaWkzK2lTcVBoN25mL0F2YUtmbVhTUyt6VlZHUDZRSUg5eDdXRVE0VTFL?=
 =?utf-8?B?ZXhZUU1sUkUwZTcwR0FxTW4vYzN5eGNBb2hmcDlzb3FLRlJpWS9oTzFIS2VM?=
 =?utf-8?B?SUsrYWhuUlpzQWJTQUhvcGh6Y3BXV0NRc0NiQWg5Yk9GNG4xd2hzeTlyWTJh?=
 =?utf-8?B?TS81dENoNnRxdHpuR09FNjhRQ1dxN2Iva2oxRmt5QzljZm5WeWhubFpCMzlL?=
 =?utf-8?B?Y2tGNjY3YVYvMTB3aFJ0dVpLZFRyVWYxSGFIanpNRXV4OFFYRWVUdXlMOXN3?=
 =?utf-8?B?OGVwR0VXWUtDQ2NhaGNzaERUSitDRFBBQngrSHVaS3UyeFZUSW1DM2RnL0c4?=
 =?utf-8?B?dVpRZ3I5YnNLd3hrY0tKaXpvUXE5SUdkTE9BQVFpQ0piYm8rbTczWjlGV3U5?=
 =?utf-8?B?ZHpaNFhscSs5WFM4eTUzclM0d1laZlhUNzYvWTFWamNhQlREVXd4RWVETzJI?=
 =?utf-8?B?WlBMdjhCdEpPUWtoRmNCY2ZxZkRpTDFMSkp1M2N4bU9HOXdXZW5lckNnVkNS?=
 =?utf-8?B?V1ZFMmdmalNFMHVPTitoVGZSbFhXRGZjTTJYNzM4VUlRdnVsSzBXTk5MSWRK?=
 =?utf-8?B?azkxSDVxZjdnSk5DL2RnRWMvb1JzSmZHMXExU2lzbFp6dWxuK1ZCNU1lMVdL?=
 =?utf-8?B?NjhSTDBFTHVJTDdOMVhiSENUQm9Gc2piY0Z6YU40OVNxeWRDN0tuY0xYc2Z1?=
 =?utf-8?B?UklHNlQ4MTMyR1VFdlRkcUZTRWVFNytZcGM2NHAyQzhkWlhBKy85V2dWNHJT?=
 =?utf-8?B?ODM4VkhSbTNlSHZQOGwxZ2lDdnFWYkx5YTJkSXp5T250aElJRHI1NlhaNXRy?=
 =?utf-8?B?KzdrS2FDaUxsOCtsVlFVWTRGTUVNdWVEQVdMZks3bFBNQ2d5dFQ5Tnk3Q2hm?=
 =?utf-8?Q?k6AOaN6B+Pbjolej7+4fHvccf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31ee0417-8001-4e90-59ed-08dc85a5a948
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2024 21:22:53.7095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j4EZ+CSEEBUCEahJu6mr3fjO0zxFdf4Pse+8uwb8ujqNzGQHfewhsIANP/wAjKOz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8901

On Tue, Jun 04, 2024 at 03:56:04PM +0000, Mostafa Saleh wrote:

> > arm_smmu_init_l1_strtab() goes through and calls
> > arm_smmu_write_strtab_l1_desc() on the newly allocated (and zero'd) struct
> > arm_smmu_strtab_l1_desc, which ends up computing 'val = 0' and zeroing it
> > again.
> > 
> > Remove arm_smmu_init_l1_strtab() and just call devm_kcalloc() from
> > arm_smmu_init_strtab_2lvl to allocate the companion struct.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Looking at the code for dmam_alloc_coherent(basically dma_alloc_coherent)
> I see that the memory is zeroed for both DMA direct and IOMMU, however
> I don’t see that documented (in DMA-API.txt).

> Assuming that’s guaranteed to be zeroed (maybe we should update the docs
> if I am not missing something)

Yeah, people have been sending clean ups removing zeroing and GFP_ZERO's
in this space for a bit now. There are many places that rely on it.

Thanks,
Jason
