Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2076.outbound.protection.outlook.com [40.107.220.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954AC136988;
	Mon, 22 Apr 2024 14:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713795881; cv=fail; b=Tor9yTeWnKvf6lEyO3MbZ0jzcZdPUi85fRQpPtDqPwQQQLp4n/cZvALhoJSw2mLf6EEYUDMyyH/q/QEnRPgXnJKlKVdUJ0qO5r0uuFWNz3L17UD4J1NlpQUyqNW2YHOyoXUbItJcDcMQpsqvzhVX4OZE9m8KnIhvFA9Ti8BYhnU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713795881; c=relaxed/simple;
	bh=RWuG4ls7khZL0TJGw1erxKCc5qkGFXdzXyXLC9M2M/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OEgWcYqaT9vY6Dsya3sqnqqXqBvf05mVHYwQuIhi2Tf6w3aWAvREXFwd/FG/963CNj+DLro7eslWWnsI/1mUOWRjfb1Q1XXifQr6r3ohMu8jF7il+5Pl2u2McESWQTY2RkditQJGGimIMmww82Y/Eft/umBKfeE8eCDdBJ3RRw0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZzdZGI90; arc=fail smtp.client-ip=40.107.220.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZzdZGI90"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k4jCusG/gkG6pTPiwS1/PM+/FtKdZChqe4k9FW9osK9mOC9OGaXNpdrAYCrYN/UYdXMv/+XTpfE/YZ2O+d6sPJ4olPUqB0wGtMK7XiOMIiod4Nd0mJptjgJZiWmEG6jy/RmGRQWl5dgJSkL1gqvUkaLUoANoy3xVX32spTJFyd7hCQ+i6GVADzU38bsa7Jp2qKTw8iSrtqKNhMScFxHNTfJQiQxkWHwlEZkPx3KQ0XcsIrDGK0P1uWwUUTWdoytZaZW3+gmw7+/3ZjpzCVhll8QaUUb06mNBqQfiNpYToRLfOHvirNBeTCMucXJExyywDZ07xxv/7aKg0kPU21ermg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RgCCKpPiEpMWJcqWGdwwUdKMRo0vM0IutU1aoH1x41o=;
 b=gbf/IYO2rzVIsz+pTxg7T9gq0igXG5OQWzngEsw2oYpIbLurT/Z0BBlMncSn4juosKfu+WPCBUStw5d6S+tL8lPBB/yt8M0G6nh1IDkDPWi8IggQEsR4DdUqg7dVqj0kC16P+uMw2xOZF38kLts6bSPII5yX9vI4chyeDu94TQOXiqNgJHzzsMcM/ekuhev8MJeKbUhvV4l4ptKdiPCng4uUaYqtJOcD1lcsZnxYMK+/VE7mog5pDT3Dj4wuDi6XI6AvyChh5Z2LIi6apk/KnPW6TDJOe6S86pGE+WpUG8S17if2tPKHV2fzdjOYk+Q/+eNqKrBZ1zEuUTmNsqhi3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RgCCKpPiEpMWJcqWGdwwUdKMRo0vM0IutU1aoH1x41o=;
 b=ZzdZGI906i+1XEkgdXsGZwkpfnyZy75+TUnDIjIReqrwmEN2hGNdoxo0pwBnVL9/tZDCJSU73wwWt/6/fU8tjZhm+NulLyFbjZp0R3kgtl3d1v7Dncd/RTo6btecMr1ssZsoE3QdRngn5K2iZ2LP30Ow3H4NFS/pRwHxNA1Id5GMCTzd0ePtqsP0xSZk+LTwqucZ11wzBs6/g+HkDFUcRpg55OJwJ3E0psyqUAxlwrB0/hUwP76J06+BAFkNoZnfWFYf9bMb9RVWDOKT1Lv0aXNGslcFMSTPR6V0suEk1pv5h6jo1GMXcdvG58gfjlfJICJqcUPIz4DkJSCYsdSjzQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DS0PR12MB7803.namprd12.prod.outlook.com (2603:10b6:8:144::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Mon, 22 Apr
 2024 14:24:31 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7472.044; Mon, 22 Apr 2024
 14:24:31 +0000
Date: Mon, 22 Apr 2024 11:24:29 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 9/9] iommu/arm-smmu-v3: Add unit tests for
 arm_smmu_write_entry
Message-ID: <20240422142429.GE49823@nvidia.com>
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <9-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <ZiLhJKBLdr_YqL_y@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZiLhJKBLdr_YqL_y@google.com>
X-ClientProxiedBy: MN2PR02CA0016.namprd02.prod.outlook.com
 (2603:10b6:208:fc::29) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DS0PR12MB7803:EE_
X-MS-Office365-Filtering-Correlation-Id: a15a80f9-382c-4fb4-9f3e-08dc62d7ecbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U1lYa3Y0dEpjMGVtNXlqd2NYUmlaMWd0dFR1NE04a1ZTdVNZZElCWlF3cTNP?=
 =?utf-8?B?UnFYWlIvRWdRRlB6MFd5ZWU5dFZkTmtKTHh5ZmpKelpkbE9jUXZSNVZkcGp5?=
 =?utf-8?B?cHBiSjRNQkFUT2ZxN3lrSTF5NGR6NUxQYnRYd3JTZ0I5bUpOTnVxTFd0cmZw?=
 =?utf-8?B?SmJLSUo3OTZKcjArckVLeThzTUtmQnQrd1dUYzdHMFNPYnRkVWV3dzM4SFRI?=
 =?utf-8?B?TURBWUZ4cWJENTVoenh0WjZmeVg4RE9GNUthWVY0TE9rTFB5Y2Y1N1czNHFw?=
 =?utf-8?B?M0VZbkc5RU5HcEpJSk1KUUtTVXZHcU15NGFKWmFwNGVWYTRFbHl4RUJoZHZy?=
 =?utf-8?B?UFluSlNPRVdiR2RVa3pPV2hiMndGeGhHU3AzQkdQdUI0Sm82QlpET3NkZ2E0?=
 =?utf-8?B?RklFSEU0ajJIMGdiVXVWcW1tRkNIME9qMnVSakUzeHlOY096a1VqOWtZZWsx?=
 =?utf-8?B?Y1NuQUZvbVBEa3U3RWYvbkxzemh6Yk1yTXQrQWJTSjZCM3JlMXNxOGgwL3BI?=
 =?utf-8?B?NHcrN1Fsb3FsZ0RRU3ZBbFMrUHZUT21Udkx5bmlvNTNnWHhqN1NSajdFYjUy?=
 =?utf-8?B?MVovYW5IMGhkbEZONW5XWVNpZFRPRldZeERlMW0yT3pKU3BKK2dkQ0dTQno4?=
 =?utf-8?B?QjhaSnBFalRtUWsrb2JiQ3RHV1ZkNTYyeGZVSXhFazZSNk85cnZtc2tnTi85?=
 =?utf-8?B?MlVib0pwb2pyQUNwU2ZpTjRRSHB6RVZDMkRlSytPUHZZRkpWQ3loYXViWHFx?=
 =?utf-8?B?NjVad0RNSDFXT25GUndGeTBtUno4bTNTRzhuMzZ1SUR6TU1KTnBXajBQYzdm?=
 =?utf-8?B?Sm9zWEI5Ylp4VWhJMVBwdWdJaHNFandQUXpxRkpzU2dwUHZmaWdJUjZMMEFw?=
 =?utf-8?B?ejRUY0kzVDFFdHRjQWwvbldPNzl4eE85VWhSOHhFNGF3MjI5Q0JYQTB1K0dv?=
 =?utf-8?B?SGl0TmRRMFN1NjdLd1gxSVRwbU1DSjhNdUR4WjlvYXFIZnN1TzNyVnpGYjZq?=
 =?utf-8?B?bUFncEIxZnlnMDQvaVVpUnJLL3VNdG9DN1ZhQ2c3dW9hMzV3bG1aZXFXM2NZ?=
 =?utf-8?B?WEVXQ1NZNFV3QStwUWxCRUo1d0oyMVRSVUtrQmF1b2h1YWtXc2pjWWpGb1Rl?=
 =?utf-8?B?bEVpMlowOEVmVjB6MGt3OWFyMjhqaFZmVFFaQnNyVGRjYUdOeXVIMUM3RUtU?=
 =?utf-8?B?S2tMRWdHK3Z3OUIralNpbWJmRXpMNjJMc0F5bjU4QVFva1BEVXVOa2NtTGhH?=
 =?utf-8?B?ZFZqUDhYZ1NNS0NTQVVsUDU5WExyQllpU2poUURpVmQ2WndjTlZiazZhSGZy?=
 =?utf-8?B?VVFIcTNjWDRmMU5zNW02NW5Udjl2dkVpTTZhc2ttZitiaDJRNlR4R21xYUlQ?=
 =?utf-8?B?dDlnS1kxVUF5OFpzeGg3TDArcXRrRFMxbmY1VThFc1VZZUhiK1M3SzB1TEJj?=
 =?utf-8?B?eVhFRGdpOW1paWxGMm0xSUFyNXo4Vks1aDFEVzNVQXZDeXRVL2ZlUHYvdy9U?=
 =?utf-8?B?KzBkWjFzbExjR0puZzhRbUJ2dWVoUWRNaUxxeGZvMUhuU1lMSTh2MXNibHNx?=
 =?utf-8?B?RUZQSlNsVjkzaW14am4vaURickwrbjdFNTJIMzAxKzdtK0pGT25SUzRwekZy?=
 =?utf-8?B?eG5CcE81UlVKSUdsRFJJcVdqS0FQWkxKUmJCUE1obWNkdTU1aVdIMjBiYTJR?=
 =?utf-8?B?N3ZsbjYraHVyY2JLVUd4T3Z4bzVyTnJxd291Z1RvTGRBSC95SDNzQlZBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OERTVWZFcHR3M2JtUXhvdWVRbEVKNzkzWXRnN1pwRG83VWdJbElCcVhBNnFl?=
 =?utf-8?B?T21CQ2F1RDJIOHpBdENiLzdJRkEyL0NOUXk3K3VEZW9IZGNKY09JenRCVGdD?=
 =?utf-8?B?ZzAvWE1HcDIvNUVZRVB5MXBVdmxyd2k4S1dGYTNZNkZHRFFDMkNpejc3eDh2?=
 =?utf-8?B?d0xpNlVCc2xNajdHbnl2UHVEekQ1TGszWElXSE5VeHQ2RnUxWWI2RnM2UTJW?=
 =?utf-8?B?NENaK0hRYnlpWVZ6MEtjSTBvc0JsaGIrNzc1NmZxZDIwYVdaL0JXKy9YYndP?=
 =?utf-8?B?WHBEVzIrRDg3VSsrd0FwQ1NWc1phdmtTeHZNSHpJVi80bDg3d1BreUhxeWw5?=
 =?utf-8?B?OGZIb3l6ZnNORmtvRHZJZVc2bUkreDYxR3V6OVZueXJDbjVWUTlCWTZUbmR6?=
 =?utf-8?B?cTYyZTlFblRZMXBqNExPQlRWV2RaUnZYWXhiZ3NVZmMyRFBsSHpTRysvM3Ja?=
 =?utf-8?B?bUdabUJsMExWR1ZQVTFPd3pGeWNjT0ZQNUtEV0NpREw4NGVkMndXZGhoTDJl?=
 =?utf-8?B?NFJPNDFUTm9BRUE1SDE0bG5EODdHcHZhbUYrUXRldEJwUjYvaDRneXhGRFo1?=
 =?utf-8?B?ZGUwU0tzUjlsK2FWdnlZU0xocXhCd2h6WkY4NUZscFptTzVJUEN6cGtmZ1Fk?=
 =?utf-8?B?cGM2OVQvRkFnWjM5WkR0YlZWL2lYeTJDWFZYaFdFTGUwcVpWZU0wd3VEeDVQ?=
 =?utf-8?B?TllzUzVNNFBQcmhCU3ExNEVENkNrNFdCZWhxRjFRSmt5MWRQNTZDbkxjNzhS?=
 =?utf-8?B?YkhtZU9zOUc1VFQwVlNyMDg3aFF3ZGxVZ0VUZWRpWDlIUk5uNXBxUkE0NlJR?=
 =?utf-8?B?M2pFbkt3UEdqYWlYcU9SUC9MY1IvZVFnRWZlV3ptempReGhZTVBGMG5ROTNL?=
 =?utf-8?B?SndBTzlpU3JDc0lVc00wbmR5MTNCR2lPWTdudnNDRXVST2xZZGtvM2laRmJL?=
 =?utf-8?B?dU0vZ0F1NTkrQkRJa1hZc21qeCtvMUxWcnFFU2xBdHlvbmhiSFhFSUlROEVV?=
 =?utf-8?B?cE5TcGVGMFFBRXBZVjhFbXZub1dGZnlXNGZXZUUwZzlkRXRTQVN0VEJFUnRa?=
 =?utf-8?B?MWhCTjAwYkR0b1JwUis5Z3czcmRMZUhnYlI0dHB5WnprbmtQYU5CYUFoOGpG?=
 =?utf-8?B?TUxheE1GMXFnUlhHUWsyMFdKN0lZZ25sNmdTQ1NZWVZwbjUraVBDTitaNC9B?=
 =?utf-8?B?YVpsNTk3bXVnRG12ZndkSEFhOTFRNXJnYkcxeHR5d3FwNG1qV2V6bTA3RHF3?=
 =?utf-8?B?cGl2NzlGTVZBalVVaDNnNGptTU9INzhjWnpRbEQ2TjJTQjQrZ0tCNGJ4Mm1i?=
 =?utf-8?B?TFpyWVZ4RnBtNEhrVkVZVTdGZVRQQXhQdkMyMlpZZUxlUGZNalcrVWpHMG1M?=
 =?utf-8?B?UlRVaVFYRzFGUDJLQyt1eUpaNVM3aWNubmdtblZEZTlpczJoNWQyempqYzhJ?=
 =?utf-8?B?WmhHdmJjL2lXQjd3VGFEeitQcW11QU1PTG9YV2l4OXdXcGZSREhFdnJ0dVE3?=
 =?utf-8?B?aVNhOXpub1FMREZkZTJKYm5WUzRtSDJuWTlhQklOQTRHY0F1R0swenZycnFs?=
 =?utf-8?B?TFpMdkR4ZytCMVJGdHR6Vnc0cmRwS2xoazVpbk1xVUxjSWNaUzhpWDVKKy9Q?=
 =?utf-8?B?dUFCNmNGckhkRHQzKzFiTlRFUXpqVUdaUFRTbWJTalBRU1Zhb2plWnpqNmpj?=
 =?utf-8?B?MTB3NlFRUWpuSXBMTElhalV2M01JcTNaZWpsTVRCT01aOVA2eXJFbXRnQW8y?=
 =?utf-8?B?V21od05SNWIvd0dDS3pKYTdrSk1sd1AyNTNWTS8rOG1XTDVQaExlY3pFcUZL?=
 =?utf-8?B?YnZjN3ZDbWJLbVlKSDZ5b1JUdkJUc2dmZW5sWXo3UHpDbXYzNGxoaEYwL3JW?=
 =?utf-8?B?dU9pZk1VaXpOT0kyTTRwTnpPZXBrMDFPQldmd0hicjljL09HZDF2RUZCUzdp?=
 =?utf-8?B?WklNcUtZVWRyNjFaTXVCeGVHMldub2JEYm1RSjh4WTVQVUZzREdYSkVpbTgw?=
 =?utf-8?B?R09MT2cyU21KOHZBSVZHOEo5TkQ4Tks4ZU1DeWdFVEJXaHZ0NDZvODV3TmhD?=
 =?utf-8?B?MGJEWTFLcHBOZ2Z4RWdNOWhTUFJiSDlINXpub2x0UVR6YVJzZERNcW90MjdC?=
 =?utf-8?Q?LpW2dWOUwdsymAHJxuGF6SDRM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a15a80f9-382c-4fb4-9f3e-08dc62d7ecbb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2024 14:24:31.0429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mwVALhIY1rF675x07M01IdlFHi3XDHPcdsplveMKpm0k2tIDavLOdUcRO4nyCgRg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7803

On Fri, Apr 19, 2024 at 09:24:52PM +0000, Mostafa Saleh wrote:
> > +static void arm_smmu_test_make_sva_release_cd(struct arm_smmu_cd *cd,
> > +					      unsigned int asid)
> > +{
> > +	struct arm_smmu_master master = {
> > +		.smmu = &smmu,
> > +	};
> > +
> > +	arm_smmu_make_sva_cd(cd, &master, NULL, asid);
> > +}
> > +
> 
> The test doesn’t build with SVA disabled, it fails with:
> aarch64-linux-gnu-ld: Unexpected GOT/PLT entries detected!
> aarch64-linux-gnu-ld: Unexpected run-time procedure linkages detected!
> aarch64-linux-gnu-ld: drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.o: in function `arm_smmu_test_make_sva_release_cd':
> .../linux/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c:409:(.text+0x17c): undefined reference to `arm_smmu_make_sva_cd'
> aarch64-linux-gnu-ld: drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.o: in function `arm_smmu_test_make_sva_cd':
> .../linux/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c:399:(.text+0x230): undefined reference to `arm_smmu_make_sva_cd'
> 
> I belive this check should be guarded under SVA.

Ugh yes, 0-day just hit this too.

I'm just going to do this:

 config ARM_SMMU_V3_KUNIT_TEST
        bool "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
        depends on KUNIT
+       depends on ARM_SMMU_V3_SVA
        default KUNIT_ALL_TESTS
        help
          Enable this option to unit-test arm-smmu-v3 driver functions.


Instead of adding #ifdefs.  No reason not to test the whole driver?

> > @@ -980,7 +968,7 @@ void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid)
> >   * would be nice if this was complete according to the spec, but minimally it
> >   * has to capture the bits this driver uses.
> >   */
> > -static void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
> > +void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
> 
> IMO we should not export all these low level functions unconditionally.
> KUNIT already defines “VISIBLE_IF_KUNIT” which sets symbols to be static
> if CONFIG_KUNIT is not enabled. Or maybe even guard it for this test
> like what btrfs does with “EXPORT_FOR_TESTS”

Sure, that doesn't look like too much trouble long term.

Thanks,
Jason
