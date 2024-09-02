Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2048.outbound.protection.outlook.com [40.107.220.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C654D9FB;
	Mon,  2 Sep 2024 12:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725278645; cv=fail; b=j9hBJNH+ShF5Rl9WxLXab1Bbezv/qNEtEmIgwfkNaqcukGS8+Hwyjsp1TvesTOBkUCGfM/5OCJBk3CUAggRwe3xFNcwwShxkccnuBpoDBsYm9AwnFhc9DJQ7ml0+IupncobWYg08b/khy3IQ9SrIlrtfqRl3yLgi+OWf0/7iCh8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725278645; c=relaxed/simple;
	bh=XGS0Oyf23H24iiTh3zczKp10QfFrb/mDwg0ULz2W88s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=P7GoyJpKN47TWaXsDvsylcXhqpdkngbhDTTkR8y/GK7ixVVrxniDt3lJVi/ebiG0JoQo3h6DjUwQzwUPoRNoQbQ8JbehLG9x49Qzk2TQzWombHBt0Spna4Nq1Os0DCIGUy2b/FXX8zMIxzdvV0EWMFS8F/d1FCcvDDzMZfbKMOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DqPB2gk1; arc=fail smtp.client-ip=40.107.220.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DqPB2gk1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nfSYvoaL/8YbvAz6tK8kYZvdLfu2qdONJPFS66KDljhxYkj9Hyth2YKaNYTB3rjVeWj8AHbV1rCda4JY+Ni8iG6o9ovB6iq91XJBoMFWF00XKmM3KDkHpM33BSgdiXh5TMay8zBbG/t1u7TnzBGGCjgRGL2qX7AjhN+P6LZaQ/IOZI6fAkQOjH84R16nckhlE9Fj5/KzyWBSDtzSx8FJmWoM0KJjbFA3ZrlykR3F8y350vJwyb3qGYuu+AgYodwxjZKVbutTzrolbGoY6lfkgi4lW6uU0d68cA+Xe+vbFfv6HT4RTSpXphSYYlPx6e81gzsS0BE6zbERIOGkT+PcPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CUxIrar9GBQFQmtWGxggoqdcpJMFYH0Zz28nI1JMYDo=;
 b=qKcsonm4tlf0N1LWVFu/Za2lNyjcJfrpGbeEP08X5tPwcOoM3lTgaHeK61TphnZwPyk68C5M6fXLNcvbvKWB4nOHof1ir6O8zselcBp5LRWvEy652F0/hiiAYvLPFrdvY1AqVvkRcBfMp6m5BJIglYl5uqk1Xojb01A32kJl7atWBV0OAbZyE4J5vuYFr3U/KjjiIgZhfN7el6YTx0TjKBvDB0IpSKQpksdrWIaHxMyl/IDOlBucbQB8xV4MPmJiBh/F4+FMGwPWg4p0x7gSLXB7wKCqHnm9WXuDkOP5dgkrw5gYW+Xwq0H5SZv/4Y0n59/XUZIV5gyqBDJiRj7cSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CUxIrar9GBQFQmtWGxggoqdcpJMFYH0Zz28nI1JMYDo=;
 b=DqPB2gk1XCAjvhnF7AF689c6NPYQ+Vq5HVVShSIo3UzBeN61OWYyNBjN2m6Rpo4lW666fg9zwHvEMrOWiMEJaPE1u4JMZ0vGLdedaJIGw/xPPWasUnfL3wK68lLN+MdD4YpmI9dG/S/DepATHLITD9wRJbPlejaVoadtkv9c9/s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 SJ2PR12MB8182.namprd12.prod.outlook.com (2603:10b6:a03:4fd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Mon, 2 Sep
 2024 12:03:59 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.7918.024; Mon, 2 Sep 2024
 12:03:59 +0000
Message-ID: <ff5cd6f8-4338-4174-81e0-9cd31442aa21@amd.com>
Date: Mon, 2 Sep 2024 17:33:50 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/14] iommu/amd: Remove conditions from domain free
 paths
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Joao Martins <joao.m.martins@oracle.com>, Joerg Roedel <jroedel@suse.de>,
 patches@lists.linux.dev
References: <10-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <10-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0198.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e9::7) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|SJ2PR12MB8182:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a9731ed-c963-4cb0-4c8e-08dccb4753d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MEN0ajUzZHZQM2tYcjNVVTNHazRnWG9SQTgwVUxheWk2dWQzb0huUVJueHZk?=
 =?utf-8?B?OUtaVEhxK2txZWtRQjNPcyt1TjBrNzFkYXRRYVk4TS91OG5FS091NDZONHVy?=
 =?utf-8?B?aFpYcllEaWx5OERwajFOQTBMSXRFam9LOHIyY1BkWTZFNHVJSVVydTVGTmRP?=
 =?utf-8?B?NEJTeE9KZGFrRXpncWpjQXI4Q0tJaWdjQ04rQUxueHpOd20vVmJ6YldpeHVv?=
 =?utf-8?B?ZWJURnpnbk05SFowK1oxRS9CMmRUTkxZSDVMR0NuL2lJVlBKZU1tbndtRk5L?=
 =?utf-8?B?UXliaFdGMGlmaXJjV0l6ajJMV0VBMDNMaGxEVTZUVVJiWFZYaHdMTnhhNTVQ?=
 =?utf-8?B?ZmhYYWhoT09zVHJabDNIQ1gxVmo0NlE0am1pOHpUcTJ3amNkNHNORVZmT0lr?=
 =?utf-8?B?UVVoeEl4VW02MU1saThzSUtnN2huNTJ0OFZtNEkrZi9EemdkU2dGUS9vVFVG?=
 =?utf-8?B?eDdJcWZDVk1zbUxGVzJXQ3lpRzJXUms3RDFCN2UzN0o4KzVjdHJFU1UyZEdk?=
 =?utf-8?B?Z0t4elFlUm1Dd1oxYXZJUmdxZzZHRXhaSURPSmJacmR3ck5lZ3lHM1RMaGxn?=
 =?utf-8?B?eXVBWFlRZk9WVkx6MTRNc0Qya01GdElYK1grZUJ3L0JpNEQrVFZuTHlSYWds?=
 =?utf-8?B?UkVwT2pkY3FLVnJHYkJhQmVKbUI0Tk1xRStQWjlYRFl2WTgwYXYyK1VycHJI?=
 =?utf-8?B?aytXWlVBZjIwL0VsYzJnQ3liaWNrUUcvR0VFK3FCNE1TL0RxdjRmSDBXZnVV?=
 =?utf-8?B?SGM3VlE3YlRhbTdrVU9EUHB0bHlPVWhLZ0VEbG80ZnYrL1ZoSW9JSCtXaWtK?=
 =?utf-8?B?Qk1lWHlpT2hvelpwWW5PbWNib1BHcml0cVNEa1l4Snd5T3RZMzIrMGpMTDVL?=
 =?utf-8?B?aU9rWWlsamp5N2J5bjZZUnR0TWorcGlKcEVIaHBGQWRDRkVibCt2RjA3RjhT?=
 =?utf-8?B?OEZuaWJOYm8vb3N1S3RBN3RqMGZubDhLQkl2aS9FWUtabE53d1p5MFRGMWFz?=
 =?utf-8?B?OXdPSWVJSTNRTUNVK2d2cmpsR3VDWGttYVdDVmVvR0JiWFFFUW9wMm9pNC9z?=
 =?utf-8?B?UUZBTXJkbk5qU0NpeFJPRXNkU1JkWmcrUHY4eWdkZVRFRmVuc2sxRmxGUFJ2?=
 =?utf-8?B?ZXFXcU12NXN6MUlucXZVMmxnUHBjNmJyVnNENGxRVTE2U1NRbU9jd1BPN3B0?=
 =?utf-8?B?QW0vNURsZE9ZZHFmVEFSdGVTMGNSL2IrRFc0cDNkVXROdldRVGtRVmdkTXNE?=
 =?utf-8?B?SmVVZXg4UW9lSEFLUUNlcTZ2VmV6czhlNXREcGdFTVBsRHlQUmludGJZYlFI?=
 =?utf-8?B?UFR1b2pJVEMzWmdZRldlV1BteGM0dTNxYlQzcE5JT2xreFpvWjlJZWVPOXox?=
 =?utf-8?B?Q1RvNEpMcSsvWnE2TlRxbFFvUXBHYVF1VFRqa0psdXJSSlpZVjU5ZG5IQmhP?=
 =?utf-8?B?ZjkyZzZWZVhCakRld1lidmJPN2xYTHMvMzU3ZW4yTiszL2g5K25tOVd0MSto?=
 =?utf-8?B?dWg2MGFFR25CT09jODIya0pPdWlMVGVONkdTYUMvcXVrTlNaN2U1VGpwZEI4?=
 =?utf-8?B?T0l2UjVGZFNYMFJ1K1Q5My9xTUpXVVBoV0N1RDhpcUU3em5ydmNKd3BIdEtI?=
 =?utf-8?B?aXRRM1JXZks4RmNPMWlkREMzaFZCTE1RdWQyT01ZZ2lRbkdzcHlaRWVUYTFH?=
 =?utf-8?B?OVd3S0o4SzZBVGlTYkdaNU0yMXlCVVZ5elRuMzIzTmhBcUE0THUwSU96RmZH?=
 =?utf-8?B?dHIwWEZoRm8vWEREYk5JdjJwTk5HTUx3WkpsQ2EwN3diZEs1MmYyeTZRR2pp?=
 =?utf-8?B?RVRQN1ZPZHN5dENrTmhUZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UjhFUjk5ZTRIdDhiMDVjdzFqVFdCazNnVDM3Y08yNlFhRkJEY3h0SWhYMWdP?=
 =?utf-8?B?cEZwQVd2L296MmZ1cXdWUmVKR1pJYnBhOVdmVmNISGdpL0hkNTR3WjcrVkg1?=
 =?utf-8?B?U1gzNnJrZ3ZKekUwc2VoV0RBOFJUbkVMZHlZUlltMEszZ2RiZGlabG05SXpB?=
 =?utf-8?B?OHdVWnJEM0lZWHR5ZXZJaExWaGVqaFl6dm53R2xYRytZSFlZb0t0T0o5d1Rt?=
 =?utf-8?B?TTlaaGV3WWI2ZUdTVWVOSElDWG03c3RJS2Y1bVZTRzFBb2RXTXNmMUN1VXFF?=
 =?utf-8?B?eHN2dk1JeGhYU21MNzlzaDZzd3NVaGM4MnNUMUkySUErY1hSUzZzeUcyNEM2?=
 =?utf-8?B?N2ZSUnc0TytzdE02eDVuTm5ldTdLOXZHSTJvNnc4Z3hQODBIc01sbmVLZ0ds?=
 =?utf-8?B?T2tQK3pMUkJkUERXOHQ0V3JyRUxSdGdXZVJMMmFmeGpLUUZsZFovWnMvUFBu?=
 =?utf-8?B?UDNwNmdORllVVm9BQXhOdkRmWEVrRTBUTzVVVldhZXR6OW1YSlBTc2w2bGV2?=
 =?utf-8?B?M3ExekRsMEw5YkJWdEI2UGtjaDRBdUdZd3EwNjdkVm5Va1pjVDc5ekhObkt0?=
 =?utf-8?B?c1NUVCtpZldCa2FBR08xR1NkT2pLQ0FCVWtRYjVQYW1nOXNya0FEVU9xUVV1?=
 =?utf-8?B?OVRGWnBjamErbnNiOGU1YWh2U2N4UHQxK0ZtaDhuYWlqVzlNbU1PT0FmUmky?=
 =?utf-8?B?WW9XeWpxUEpPYlo3aWpjMi8velpXbTU4QmpCckVNR1pIa3JmNjRCSFJITGFB?=
 =?utf-8?B?QVllV0dEZi9JeGtKeHE0amxDNFBIcGpWOWIrY1ptd1dyTGRCYzhMYm9xYjI0?=
 =?utf-8?B?YkxsUnJWUXpEU2ZEWjBjYTh2UXFHRDU0OC8yTFFKQXNHVUF0T2hnUFVaWUdr?=
 =?utf-8?B?SFAvWEpNQWtVV3hoTWdjaitYUkR5YW1iSzBneUlPaGFXS1o1WTQySGVlSEJL?=
 =?utf-8?B?TEhNQlZjVm5SdWxqVG1rRW5jSjl4OFE0OHBEVmFUd3ZNc2dXK3M5eFZ6OVFk?=
 =?utf-8?B?L1JGMnY5VVpyVTlFenF1UDc1UTNPeTZuMW4yRGdxajdyN2RoNHFFKzZOMTFo?=
 =?utf-8?B?Tmd2MHJaZWM4amtUTUhlNHVBTEN3UlVXa3IrNUVVNWY2VEIvelQraTZsbVhr?=
 =?utf-8?B?M1NDeHh1STF4VXBVWnhzUzFwY1h4clFjVzBaM1c5aFQ2SWprblBySHZMSXdD?=
 =?utf-8?B?VHhIVW1TY1dBOUN4dzdGV2pWNjNnbGs0dUp3ellBdTN2L3hDY05WMUh5RUd1?=
 =?utf-8?B?VzFYOVV3TU9qeDBBanlENGtza0p2WHc1REx3bXZVZHVCMTBDVkRsSmFreTBX?=
 =?utf-8?B?a3U1Tko1WDZrYUQrVGtpQU1Bek9janF6TTQ0SnlXVVlDcUV2M2h1ME1DRnU5?=
 =?utf-8?B?MjE0Y3JWVlZIQVE4Q2R1RExLRFdWRVZnU0ZnWk5SMGhhUHBYL2p3UU9QOGth?=
 =?utf-8?B?dUxObmc5RHZtVU1nWHN2S0NPdDc0V0t5UHBJMWpGS0puaUJzME1hSU03NVpH?=
 =?utf-8?B?NCtzcEFKQ2xEcW5zT3k2Y0JhYXlkMUxGRWluSWdRMHVMVGhpeTQ1VTNCb29X?=
 =?utf-8?B?cVIxUlJ1ejdvRW4vRXJ0dWdnRTFnK1NZYUVCcWdUZEwwbk5Pdkhka2NEM2J5?=
 =?utf-8?B?SDVodnI4ZU5aS3p4SlN3UTdaa3djZk1vNWtpL2VZbmFtZzdKMnYzRnJvL1RC?=
 =?utf-8?B?MU5sSWNxSWdSS3hCMlZRbDBobHRVakRJWlF2TGZLOGNodklmUURPR0thaFhv?=
 =?utf-8?B?YVRHZ3RUZ25lQWd2bW0rcFQ5Q2F5aDl3KzRwOXVJSEVIMmVOZ1BYd2d2NGtN?=
 =?utf-8?B?ZDByWDNIdG5CTzRMSHJrcjV0TDlzMi9XMHZyZmZQaExuSmdOSUU3VUlkRkxi?=
 =?utf-8?B?d1RmOTBSNy9ZTkRsNG5Oc05YU25UYUJoTy94Q25NM3V5TG8razVSTWVkZ2lL?=
 =?utf-8?B?dkF4a3ovUmVEak5yM2hGVmhTdWptd0RoeXpPOTBOT1BpODR5S3FWd2U0ODU1?=
 =?utf-8?B?SG9PUEJoN0QxZEMzeTNXdGw2c1FkL250bjJMMVR5K3NTODFYL1NtV3E3ZFd3?=
 =?utf-8?B?UkoyV3NqK1Z6em14TEN2U1k0azY4UjUxVFNRVVhyM3Zzb09GWXJOTFhYeUNq?=
 =?utf-8?Q?zr8e5nKPeZA3WjcZnldZkbiUT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a9731ed-c963-4cb0-4c8e-08dccb4753d8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2024 12:03:59.2829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ux4ZEG/8dHFI0oGp6InveDPzUeeHeyJaPDUqYemHsFjG17VwuOpuu9Qu497oMwIydlqV1thjBKBZS9G0W1zaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8182

Jason,

On 8/30/2024 5:36 AM, Jason Gunthorpe wrote:
> Don't use tlb as some flag to indicate if protection_domain_alloc()
> completed. Have protection_domain_alloc() unwind itself in the normal
> kernel style and require protection_domain_free() only be called on
> successful results of protection_domain_alloc().
> 
> Also, the amd_iommu_domain_free() op is never called by the core code with
> a NULL argument, so remove all the NULL tests as well.
> 
> Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/amd/iommu.c | 29 ++++++++++-------------------
>  1 file changed, 10 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index 806156632bf70a..e23b7f7bf5b65d 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -2258,17 +2258,9 @@ static void cleanup_domain(struct protection_domain *domain)
>  
>  void protection_domain_free(struct protection_domain *domain)
>  {
> -	if (!domain)
> -		return;
> -
>  	WARN_ON(!list_empty(&domain->dev_list));
> -
> -	if (domain->iop.pgtbl.cfg.tlb)
> -		free_io_pgtable_ops(&domain->iop.pgtbl.ops);
> -
> -	if (domain->id)
> -		domain_id_free(domain->id);
> -
> +	free_io_pgtable_ops(&domain->iop.pgtbl.ops);

This is common path gets for all domain type including passthrough, SVA.
Hence its not yet ready for unconditional call. This is causing NULL pointer
dereference when I try to change domain type.

For now, can you keep abvoe check -OR- add PAGING_DOMAIN check? I will revisit
after implementing global static identity domain and fixing SVA code.

-Vasant

