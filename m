Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18C33A1CD;
	Mon,  2 Sep 2024 05:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725256409; cv=fail; b=MM6I7oYo6dtsJKxFQcJFKWQtaeSEV9Eu486H3fpsiwD+wg9GHVTD3MXKccxNlzb6somRC9lOw6ylXhqbVxKcyGT5w8nWd6Evh1JCSWNKmnBrlCn3dr2XbUvXujJtspyMwl7SKRtATqLcopi6esH8do/DtnE0bCxonVhPLs38DDY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725256409; c=relaxed/simple;
	bh=ljSjQjQF4qrrdq0IE9VNrNekTsJPTpPI2eKSTNBRTCI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=m12yTzm7vjZsE9ucCmruRCcTAMR86Fs3xuGQdDVMFHXl8jk1FrE4l2mLyCT3eBuHhsDSDFp/VbB3mZMS7TgWh9yvlZNFmVd7bBxjaJTttPWaZJmjf8EsgyQWGL7C0EU8gKMZG01sav+R6eDduR5tvZniqP6monSocE2QkZYjqcA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mjTrZlYp; arc=fail smtp.client-ip=40.107.93.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mjTrZlYp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XVVhlogkz9qdzx42ShtMagIG/25cC1mJIqX2aW2+rdd1bF/D4bwSQtfya/miWYUOpmMy/D0rXjufaCSHR8FTdLF77s3ATQk0lJCIjG46btFKaiGZaGagpOynKsfPeGk+1EAK/8YvYbLgXAG3B0luTzLB9YUB+GwNSJzW5biM36up6PG4MdrhAe7egfgCtjC4negTRizfD4wfS6WgslBrMZiMPdM8ok9Xy8DMpX32Mf8EKQPpnpL8RvTuHDfA7Uff9JwxcR/N2vd9WSX1K1hDygvW9mbZaG6vxpelorvH35gNYOi2piojuEHaHDX7K5sBz2YLF5HUtS0ytmO0IGbrQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zb75j7xxd6xVpH4LixsbOq2EVZFUOMzS11xpPEJlltk=;
 b=EcRD4umrSAB4bjq1JH33qSEE/9o9RRfH7xb1x2cQg55YTE9UQ7osZnRJaAjZ/ZaGqLD3T/ZX19U3lmsp4LIEMfaUORd9MdEk0gQZDV2WTXgwx91APHLKQIsWiTJlA01yEyk0e9Zi55gzx51V4JHcjJcx+Wr00je7lbICJdTNB/QLR0RaeRegPrAfBGc8exIHn8e2Dx5xBWsbeY03fCjWwaLTSK02gXZ7bSRksZ1B7HtCcgywMausorWCSpWokQlZG0x+LHWqTjCYmoy9QqgkGyORirfJGVspShm+qvdAIb0EvDS754uIW7aSQssJ2PlayAiIhVnk/PVPlVHdB6DDTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zb75j7xxd6xVpH4LixsbOq2EVZFUOMzS11xpPEJlltk=;
 b=mjTrZlYpZbfCn3jhwZnYSoIXTfVZmeBb+tGHo7Eopt+MW/n6Kqi1x7ov7Y1kE1AQBtfKaJzLOTWbHc9/b0nd6MOXyBv2tfLasAUR/6VU6cEzxPeh5Hr4oLcl6KVqirEeIue+Zg3f72aKmdVc51MDWmuD3U9RklHmB+NKdIupV7c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 CY8PR12MB8268.namprd12.prod.outlook.com (2603:10b6:930:6c::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.24; Mon, 2 Sep 2024 05:53:23 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.7918.024; Mon, 2 Sep 2024
 05:53:23 +0000
Message-ID: <a25aadc5-8daf-4ffc-93a3-221edbcf83e8@amd.com>
Date: Mon, 2 Sep 2024 11:23:15 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/14] iommu/amd: Narrow the use of struct
 protection_domain to invalidation
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Joao Martins <joao.m.martins@oracle.com>, Joerg Roedel <jroedel@suse.de>,
 patches@lists.linux.dev
References: <9-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <9-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0092.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9b::10) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|CY8PR12MB8268:EE_
X-MS-Office365-Filtering-Correlation-Id: 7baa6f7c-a0e1-4b27-a2af-08dccb138e7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NmtYSXgxZ2d2ZmpzeFlBR0FCTnZ3MWlnbnRuUmRYdG0rSjl3L3JjL3BLVXpC?=
 =?utf-8?B?YWk4VlJCUzdsay9mMUk5WTdYS0Rrb093SVN1SXZ6NVJQc0ZIcDNBQ0crTzFt?=
 =?utf-8?B?aUJwL3NmazRNdzkrcytIS243ekJZd2NuT3JzMUtHN0NYVVlaQ3RVSHVGVnJu?=
 =?utf-8?B?ZVd1bmJjYzZobit6dDI4bVd1OFcrQkptQ2p1U1FVN0ttYklucmRianZ4WUxv?=
 =?utf-8?B?OFMzTmk1WnVabm5wc3YveUZQdERnL0w3d1NYd1lINDlaMHBhOUh6QU54aDFF?=
 =?utf-8?B?VUh4UHBnK0VFUzQvOXZ2M2tKOExEbWo2N2ZSRThYUC9qZVRkNDdMNWZQaTlt?=
 =?utf-8?B?TUNUMEJ2dkFEYWtTWVUrcEhSN242RllNbUw2SVNvUndicFM2VG1IT2w3R0pT?=
 =?utf-8?B?V3JBbXczQ0krVWMyTm5EMUwzemVKM3Q2a0phajUrekRIMStqc1U3a3lrMmVV?=
 =?utf-8?B?R2FjcHhoU3ZSeXdUOGNDS1dla2I5VnZhTHJaM2tiOG1wOU0rdEJqeEp2NGFD?=
 =?utf-8?B?TVpYZXBMY1VHaTlTcjNCRGl4R0p3NGp4Zlo0SUVyM0FYRnZsQ3p5dFJFbDlz?=
 =?utf-8?B?RmJ4c1kza09kNzZhWVIzdXlpamtFb2FXZkR2Y0pHVWdGNnVpUVRucUlFVHlJ?=
 =?utf-8?B?WjdLZGp1N1dTVmxOcnRDeThtM2V2akV0bmtPZzAycUIzSnJqbXF0TFNkUnY0?=
 =?utf-8?B?NUFNSHptSUN5eXhPcEtVZ1pXTCtxQjhCem93S3RiZjJnY1lrbHJDSzlVNncv?=
 =?utf-8?B?MGwvTjJsS0NSVXd0aGZwMWFWZnJ1RlpsNkZmNmJFRmtFbE9wUW91VXNFMVlV?=
 =?utf-8?B?UGJybTFTU3MyNzRtL2ZvT3JFWlY1S2RnYm02eFd5MXlHaGhhM2NCMW4vS0wr?=
 =?utf-8?B?TlJSNjR4Zml1QzAwKzVXN1JXU2FhWHh2UFNXdmJvRGw5YXRtdTZsQzlremtr?=
 =?utf-8?B?QmJjV0Y1d2lnczQrby9mVHdtY0dhUmlqaXBGbWpYSVhyOVZaYlN4RVRVRU1q?=
 =?utf-8?B?VjVQY3Qrb20vNnpONEZJUlQxYjlUWkpxV29aZk05ZzJMbUZJdmVnZFphcTlp?=
 =?utf-8?B?bzZCMjdBc0hEdTc0ZVFGRDAvYlFVV3d2ZzFKOVNpaHRUQ3k0TjN4b0J5ME01?=
 =?utf-8?B?QjNGN1crbmF6eXhsU0VvQnA2ak02d0JMT0ZGcFlFWldwb0dJV1hJYTFuZEpq?=
 =?utf-8?B?cXlYU3NEUnJ4MFNVeG9NQVJaaDNNSHo0VzdSSXhyK2t5bXJkb0lUcSs4YXkz?=
 =?utf-8?B?K3JqZC96N0lyTWFUeEVUekhGdDNnT2hvcVhBbWlNSE1tSGdmZmNsQ0dUcGpx?=
 =?utf-8?B?RDdIMERGMFZ5MDMwOGVDRFlDaWJmSGZlVEJ4cXlUdXduSnFZVUYyT2p0SVpu?=
 =?utf-8?B?dy9wRXdKVXFOcFJkbklEdzBjT3JNaVBRb3BYQkNYMzBlZ2U3eDlQdGljSjQ0?=
 =?utf-8?B?S2pvQmZIT2VEQ2RydXJoc2M3eHNVN3YyL081K0x5Um42ek9vbk4xTHhpNjRL?=
 =?utf-8?B?WVhJcGxiTTdkWmYwa21OaGNZcHlhRjdmaXRiRWV1UmNhS280b28xeFI1dHVT?=
 =?utf-8?B?ek9RNU56ZTA5VGliWGVlR2JkcjVZWlB2YWdHcUZkVU0yTUdhMXNQdWxkVXVS?=
 =?utf-8?B?bitGV2VyQmpmRVJBd2ZJTDdKbSs3L003cHZpbk40NUNDMGZWUGppQlFuWGc0?=
 =?utf-8?B?eHcvL0tSRXpvU1RnZGZGYzYzclZBUU55TkZFaU1QbWpaSVBlU25xdzdLN3NB?=
 =?utf-8?B?aUozZS9Ua29zL2hGU1JLZEo1a3RJZ1ZMd0NmMGRQM2czeTFJa2NQOTZoczJz?=
 =?utf-8?B?dXdzY2FVbTcxTll3bDhhUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q3lHdERpblBzdk5hTHIzK0xOZzNIVVExQ0ZsWTZLMGpZRTA1NGR2TXlSTE5y?=
 =?utf-8?B?eVNTaXpkRUFraGtLNjYrVkxWZllHdXdMN2JUL1VqS0tZNFhDZmdOVDhWQjBz?=
 =?utf-8?B?VWZ4TmJzR0VjckozMmlIMXVycXZLajZTc0hqNzFRQXpHQU9MUit0UTQ3MFRC?=
 =?utf-8?B?QWVxSU9nSWxteDJ0Sk80ZHlBdENiTXM4TmNCelZ3dWp6dXJZZ1VoYkcxaURp?=
 =?utf-8?B?MzFWNkpjS1FYM2hLZjRpbjR0Slo5QVkzd1JNV1F5UUNVVjhOQ1lXTG8zWGtS?=
 =?utf-8?B?Unk2YjAvTy8xNE1WMGJTT0RrN1NVODVnOVdjT3JHalU3YnczU3pEdUhCL0hG?=
 =?utf-8?B?RTk2K0xsazNiUThDWkMyTG1uZUFwa3puUG5MeGwvVC9PeXdwV0ozUExkQXpQ?=
 =?utf-8?B?MTk0dXdwOG1CenNyNDVDNlI1VWU0SG5HZ1ZFMHc4cURhcUJYZ0xza2FuZFN4?=
 =?utf-8?B?eSs4STUxN25UNkpzOUpLeFVQQWo4V25nMTZrOTRxTmN2bTM1QkVBUlhLeU1K?=
 =?utf-8?B?czdDUitHdno1NEU1dEQwK0U2VVQvNFdiUG9TaDhkYWdEeWg5UVQ5a3psQWdT?=
 =?utf-8?B?QXlsYmhBMHdTRzdpc0dWY2FGajY0L3JlWnpsZy9mc05sK1VJaFpZeEJGdzl3?=
 =?utf-8?B?MzJXZk1PZjBjVWNrMXZZNWExU29VY3dSL2VFTFgxS3Z5U3g3RTBuN2prN3h5?=
 =?utf-8?B?ZWpRWVB0Z0NqT3hYRnhUMGh2TTdwckVtbEE3eGlPL0F6T3Mya1o3NTBJUzVy?=
 =?utf-8?B?SGEzNjlYSVJBSThuTEZXMXc1VkZqV1pDdlp3TkVmSzdNNHJNb29IOXRDVVh6?=
 =?utf-8?B?bzNPdEMzVGtUMzVnbHJJc3YwR3orc2hjNVE2T3JCUlFWWFdRelFsRmxhZmhZ?=
 =?utf-8?B?eGppazhIRkRGRkNUNjlqcjY4ck4wRFN6V2JIVXo3ZHZ1NTFzS1k4dytCWXgv?=
 =?utf-8?B?M1ppclJ5YTJOWkVaQ3EreHhlN05tTnN2NXlQYTlGR1hvWmFTT3FjeHpUd0xn?=
 =?utf-8?B?UHpUd3lQaWdlTHMrUmhVVEU2RU5YazJqZGp3cm5NUWxaMGs5d0dDNjM4L0Iz?=
 =?utf-8?B?eEtGYVJLMTZsZWNHaDliRitwRlU4SHRGdkl6cFlEeXhBaHN5TmRHcFJQcXpx?=
 =?utf-8?B?Rm5HMWtiSjFqS3F1amdWYlh0VUlQYURsT0FQTTE3clJORmo5NUl4eDdiSmNr?=
 =?utf-8?B?U2x1MHR5ZXl0bDVZcExtb0VhdEFkQWZpSWw1OEptN0NpMXBBV0N6bDVhbmNt?=
 =?utf-8?B?NUk5dVRnVHZTbGY0SDdCcEVSaWxKbEF5SUhXVFhxRHZ2WkxFUXJwY0YzQWY0?=
 =?utf-8?B?aTV1WmhsU3ZEa2lzYVFaWTVPQVFITlRUbnN1dzJHTlFFOWk5OHplNTI5WXJN?=
 =?utf-8?B?VWl1Vk5VMTZvclZxQkpuSDJGTzIyaDNwemlXRHlXUXBiTHVQTCsvMy9MWDhQ?=
 =?utf-8?B?bzdqUktlT0lsOXAvRXNOc1VIRU9Ua1JGVi9mckxiMG4zbEhiaXBxczlDK3BO?=
 =?utf-8?B?SHdyc0YvSjFyS3luOVlqNFZCUGtkSGVkelNjY1N2TDljeFBKaHFvZ3RsSlli?=
 =?utf-8?B?cjEwS0pPaXN4RGRlYmN2cHlGR3NQTmxZM25EVHhCV3cxWitwTnprNkxlWnVh?=
 =?utf-8?B?WmV4c1B6cG8yRVNzVzRwQU1NL2JDMXI1R0JVemRGRXRBajluRTFROElLVTY0?=
 =?utf-8?B?cTJSUTg3UGE2bXRoU3N2WXN0OGhkKzc3NmVBcXdLRmVCczJWYUk0dnVnbWZ3?=
 =?utf-8?B?aVBxenZjTHR2VVkwMUpIckR2TXJ0WnV3UHlhQ1l5RzlGamZCZzIyNFZsUmdO?=
 =?utf-8?B?aER1OFZ3ZHhtOTlqT0Q2RXFaQ3FaZW4xaEVWOVAwTzQ3TTZPajJKdUsyeXRB?=
 =?utf-8?B?QnNUY3lBbDBCY09GMzZVZDdVT3NpS2UrcE8wMU42QWI0VUJhTWdaRXNncEx6?=
 =?utf-8?B?NU5OV2dhb283MDZNT1lpVXZkVDBkbUhUMWxObGlsVUwrL2JMWGxYZWRWZExH?=
 =?utf-8?B?Y3QxSkdNandqR2IxN3hwbGhTVUNRVEFZUXVjOWVGVG40aGRId3N1Sy90ditC?=
 =?utf-8?B?MUlkelMyUU5aSmM1L2lUVERMbThXbE1TTEp6R2FKeFhtbXRBeGFLSWo0YkFE?=
 =?utf-8?Q?HA6eOD9RW2OickhXRZ1m9mfvf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7baa6f7c-a0e1-4b27-a2af-08dccb138e7c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2024 05:53:23.8008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CzjxKqAsK2+WvvNf6VBin3wY8uY3bVZk1z1CspF4Ytt7KYtFAPPi46tr1Yz8d5WF7Xg6ChIxvfMJ4j3DDKx9Dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8268



On 8/30/2024 5:36 AM, Jason Gunthorpe wrote:
> The AMD io_pgtable stuff doesn't implement the tlb ops callbacks, instead
> it invokes the invalidation ops directly on the struct protection_domain.
> 
> Narrow the use of struct protection_domain to only those few code paths.
> Make everything else properly use struct amd_io_pgtable through the call
> chains, which is the correct modular type for an io-pgtable module.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant

