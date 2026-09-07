Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011044.outbound.protection.outlook.com [52.101.57.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623433769E8;
	Mon,  7 Sep 2026 15:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788794401; cv=fail; b=rk4HdiJglcAaDxcMo/XjnkQPEVEKONNoquynGFcE21IQE7dx4SHtqyy2FY6SjMbt3MMP0WgDw1EZPkLQILJOUXbn2mU/StGGt+u3hb5JG4krXf4oTaw+ooAEiJ9SYHBiNd6Vl3JR9Iv8UMvr4xt6zS6ar8txgB9D02LhfqtpzJo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788794401; c=relaxed/simple;
	bh=M3Tp2joWn7zxJTidwJGEtJ4K3gXz4CpU02UQjUXseBE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hDkXQ0GP5TpKYrRgI0ogWd4bcuwskKeRmqST3jHd9+qML/ug3UWzECHG7a9LFzK1A872pO3WeS//PtTC5pbWH1x8aLFGT2v3DlGkxqfjwIBdMVZ/BS7cUf6OTJY0rjEwyYX33vdol91ZV4UaM8QkmRZJwsKsbtEGQF14VzZV3Q8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BDvcBnuJ; arc=fail smtp.client-ip=52.101.57.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BDvcBnuJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BuKWS8UeaIv2lYW1CaW+CoQSjd0PxFxiql3L1G2OMcRMs10ot/Yf5csWxHMq3W/d4d7uGSyyw9+b5A28x4LFN9VJ16mi/8fttng66mtpDbVcPTQ2AAC4yJvNmBvDofXuAunhzWBMi9ioBoPnvYlvNnj5tNB+IDmmWHJemH2wQQqNau1VMyHlfmz61m9rX/mv/YjeeRqn2bRtyhF6UFzz5/+9J7Ew+IwR/M/fv/EAITT+XpHNBl1wzv7GGWUTVBgl3sEd/KQ6Q9AmMitsjpdkL+LFkxdfhuiuImEBi64++sOZ7Pf0UzzRSCoo4mPaHUB1wsFm926tmnP0pJWDtBE92A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X5YNuC75U+FlPolMrP/brdaCuSDIPgFdGDaVoA/cGOk=;
 b=qkiMWXwu4S4rWjnN5cZIrTpxmF9YHpjjrvAagNbm9DXcPOYsCoR1qmwX5PRME4+iuSd9gzqn4+Hfe9eYVma4gfUHPoqmMh5di2DLSIbKq2I84EYlM8UWqtt98/dVMOLdgVlsr13gEKcws31K58Ivcj1eOJ4uaPTXpgmZ8pAjU6d2UIycn1Mkz0g9zOsGAWLAgutarvA43FhFiA2n19YsccvleYVP/jcO/KXE3JWrqAe6M2cczX0JDTpQS+pavXGuxpZHKmWEK0CADjDd1B1bX8TGuFWxKVkz660l6hkRpT5O3qlZKx9z1NNCnmO/M6s04SPe1mEqvbaJd4cqXslrRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X5YNuC75U+FlPolMrP/brdaCuSDIPgFdGDaVoA/cGOk=;
 b=BDvcBnuJ1C3SLdIezZtPdYL6j8nrcZORlBn4b17td3pKhNstZhJ2+xpyiU74CJPCV5K7xEO1SixEHbzeVkZRqhrdZgK+Qv2zzie4NtkLTYYb9c7ZKtI3uwT/pTNqRoRKtGdmW+HEQ5K3Dp6wt6Um4LoQR8DEGwI5jAqN3lJUXTsz+OlyMs4RAzlKhaBsOrJbzRQ4rSDc0vhg8utxx08Pa2plnjx6iLpG5jcowJyo8K12oMw4u6WmqgGv35F2B/nvewLeAmWwKOG7E66++YvyV/9lReJB9ephq0e4b/e52vJq+wc0fsqB+r8qf1YdOUWTs8GJwyFEXK5PfXSQs7ch6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH3PR12MB8660.namprd12.prod.outlook.com (2603:10b6:610:177::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 15:19:54 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 15:19:54 +0000
Date: Mon, 7 Sep 2026 12:19:53 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>, stable@vger.kernel.org,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: Re: [PATCH v5 6/9] iommu/arm-smmu-v3: Precompute the invalidation
 commands
Message-ID: <20260907151953.GZ4157646@nvidia.com>
References: <0-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
 <6-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
 <ap7J6NKXgWhiwXgL@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ap7J6NKXgWhiwXgL@google.com>
X-ClientProxiedBy: BL1PR13CA0361.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::6) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH3PR12MB8660:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a08a9be-6747-4710-def5-08df0cf37836
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|7416014|11063799006|56012099006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	wek8/XX0quxjxIIcKBSyMWjRfqkG1wgaJbQZxztoRWH1lOAgBTbxMTP6BfbJO7b1YYK+hn6IizIW5hpZ52N3a5iLFIntGmJEpNwekMlHl+qsmZR8DWIGK4o0eFdEkMov6SybK6NteNklEwFxWZaYwezofkaK5kNJ1dPfESKnj6fO9WAtcKoeEkrLsKHOWRLDwiQ3bDkUkL/9o6jaTlloNoTWQvRNH6PpLwqKvw+6pb1cRJU0dadMBuQAfiGLK7iiQE6D9fwZ48c4SzGeiVC7TqNkvYHVSgGpwqepIioXRC5Ay9mkY4rZzJtIlSC4GnMzOnA0yg5DQI43IrzQALBKKwaQLqh5UJ6BCbDWfOr6oEGNxOSgbGzATAp/Tb5lJ/+mcGioBdNLGrFPy/n+55LNF/Dmys7DRZe52MVoOHOCO4MvV5zxObkn5sncU+eaO6B+UfYps2dPuEDWBRkg8exwlOA1ps6ekZ3c3WpVMMaK9wVDPP02lB2I7++nss+fIB2SAb+hmZ3JGjuhREmSpQ9vV8Alkp8YtGwy98AW0b3THWPO2S22uMl81yChh7Zdeu0LBwdihJ6DRTW3BfEPoi1e+mbV1/r/fgsg2sKaxum7EjS20jim+g+V253tzem/pOy+iVtSZWRTu0HCm93o4AaxvcOMG5okNksAm7ooiYero7M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(7416014)(11063799006)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aGZxb0crS0pIVTlaV1lrcjZHMHVjRU5SVmowNWMvbFF1L2VBem9DMWtwbmhO?=
 =?utf-8?B?VjR4VzgxdFJubmRkd0IyUk91QnlYMlhIU0VJbFMvb1hldFRSbC9sd2F4Rzcx?=
 =?utf-8?B?cjZvTmszdnVtaEM1SGZET2diS3M0QVRSUXJsb3QySUp6c0tIWUhZRHFoR2Jq?=
 =?utf-8?B?ZlVhMDcrelNHTXBQRXgxSGIrL1lmazMwc1JhUkEvUjdWcTFadEF5QzBMN3FV?=
 =?utf-8?B?clJaMXRBSTZxb2FLZitPakNNT2syWEphVmp0aHVaZHB1R1E3cFQ2dVdSRmNa?=
 =?utf-8?B?SXBYS3FFd3Z2S0VJQ0EzbHVONGM3OE52dmpMMnJaa1F4NW1jMVJiUC82Q3RG?=
 =?utf-8?B?bFZYVFJxQkdUc1pCcUJZT0M4UFlDUnBaTEpkS09tWnFvejhYZWVESGxLUzQ5?=
 =?utf-8?B?WG5UT1hzQkRQTklROU9PVGhWS3I2NFBncHkvT3VYeW5UV2lNM3BFTFhkNlcy?=
 =?utf-8?B?NVRrem5Eb3dUT2pWNm93TWFBOU4wUWxXQUdKL2ZoS053bXRJbDlnUFdna3JY?=
 =?utf-8?B?OFprK2tLR3BEaTFTV2QrcTdYMlNhZ2lCMnJiZ2Zjc3dnaHpXK0NZMDRtOGdq?=
 =?utf-8?B?NVFnZkc3U2NUYklyOGVyYUIrUUhJclhzVE1hbFh3WEtscnhZMnBXYnRjZTF3?=
 =?utf-8?B?anVDVG1WODBwNlhRYjdLbEFCVVFjS0FTSno5SmtVSjVjUlRnQnJ0bDRyWWtC?=
 =?utf-8?B?N3ZJdmMzaGV2RzhPNXZYbkluTi9scWMrZFAxQ3NrUHI5QlAyODlDSGJ5MlZx?=
 =?utf-8?B?NnhvYUFHUE9rR2tUQmh0Zm9ZNm9hbjRtVnJvYkt0S0RMKzVTQzNUREVlL1NF?=
 =?utf-8?B?TldFakw2NTZpamcwQm9hTTZ5Smw1cFExQVE5RGFRTGdTODBCa2YxbkVwU1ZV?=
 =?utf-8?B?V3lyUTAvRnp6akN5NG5iVVIrcVhZNEFzREVyL0IxZGJHVFNYMFZ4bkhCNisw?=
 =?utf-8?B?WkF5SDU3aW9FbzEza01vOW1yclBkei9VODJQc0ZMeVk0SnhWWDNHVjJLOENl?=
 =?utf-8?B?d3Z0aTJyOVJOa2tYUEhtLzBZWXE0c1dkczBJS09KRm9mSVpRNlBHbUhTOXVQ?=
 =?utf-8?B?VjJ2WW9kdDgxcCswQ3pFaVoyVkZRdUQxV3Q2QWRFeVI1N3dQZnltbE8vZmVq?=
 =?utf-8?B?ODczNjFSMEdiWFltQmZMUU1lQkVsZWJJTTY4VjR4RlNTeml4TEd1WVB0QTdn?=
 =?utf-8?B?T3lMR3dNMERwUGplU3NFNjRzbE5hN1JRNnB0YWZZbTZHY3U0ZWRnWDVnTkxP?=
 =?utf-8?B?L09tME5qd1RUaVN0OGp0dGNKT0RUa0NaeDEyQU9vRkM5TUF0MXMwUUF5YTNU?=
 =?utf-8?B?MmlKcjFXUUkxd0VjdkltRlduZUxNWkNldVRwd2ltNU9FUDN6eWFFZ1UyNVdP?=
 =?utf-8?B?MkFxMlppUUpwMGVzdFVqc2krTDNMZjVIeU9kTW9HNk56K2EwTEszY1UyMUh0?=
 =?utf-8?B?d041bVk2bVRqeDVNaGhwemlVTUVwUEplQXpuSkxGcktZU2JYTWozazl3YzY0?=
 =?utf-8?B?VGtjbWovdlpjMm9sR0NIZExiSnNad3JyWlJXZ1I1dDRQNUFsQUZFblgyZDdu?=
 =?utf-8?B?ZUhSVy9MNEJFSUhoMkJuOUpZa3dZa1ZJUXVMUEZUSW90bytxMndiYXBPbDlO?=
 =?utf-8?B?UElHTXZMdjhGbk5zQmd5VWRGVjJlcVRTQzViVGVpTnYrZ3B5V1RNcCtLam1F?=
 =?utf-8?B?QmprWkFWODUzUUJMd0ZTdFpJY1JoOERLVUVGbTNVbzVSRytZUkZ5YytHRlNR?=
 =?utf-8?B?a0Z3OEM3c3JIYTFONG5XalB5LzZPTjBGQlZHZ0paQ1RIK0I4UDlnazRVb1J6?=
 =?utf-8?B?UGhOOStSQkMzZlEwZ0VWN2VvV0t6cmhnT3VmcWxpMVRYWkdNcDM5MndWQ2VF?=
 =?utf-8?B?bTJBWVpxT1RkZWhTV1JHZWV5SW1MWG9iOFNEUk0vWXlEcjl1S1Z6TlQ0M2hp?=
 =?utf-8?B?NnkyMU5XVGtxTmNNMGdBMzlpN2g5czNnTkpFS3I3ZzJLbjZKTzM1WTU5cXQy?=
 =?utf-8?B?ZkJNcEgvOHlKTTFJWVJCVG1FOUM2RThXSXQ3SDVvLzZXQllhQldORzd6R1lx?=
 =?utf-8?B?VHc0anljWlNvMExrN254M1NpZkExbG1uSWgvdVhhTXpISzdJcjJOQUg0SGFE?=
 =?utf-8?B?S01ERzlJVjRkMzZ1eFBrcmR6RGZyNTkwV0h4SnRhZE1JZDgvNHFrUmQ2MjR6?=
 =?utf-8?B?VG5UN1MySU9uS21hMFJDc08yWTJWa0lSa1pOb0hMZk9FajE2OERTWVRiRFph?=
 =?utf-8?B?Nnp4eDk5NHhsaXBiVXFzdWRCME42SzR1RVAvcThoZWc1RzRqcGhrOUpualRQ?=
 =?utf-8?Q?rAbPbx/SThKyAZZaV+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a08a9be-6747-4710-def5-08df0cf37836
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 15:19:54.4360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: etFZ0TZKDWKeJd85UnFCbcb9gaHAedCvAIdi+socJZVMTOVfUSLojXGFpPF0nREO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8660

On Mon, Sep 07, 2026 at 02:27:52PM +0000, Mostafa Saleh wrote:
> On Tue, Sep 01, 2026 at 02:49:55PM -0300, Jason Gunthorpe wrote:
> > Store the required cmd data in the tlbi and just copy it out when
> > processing each item in the invs list. The cmd form only depends on
> > if the instance supports RIL or not, otherwise it is always the same.
> > 
> > This avoids redundant calculations for each invs entry.
> 
> As I mentioned on v2, I don’t see a value for this without smmu
> sharing over the same domain, as this just adds extra complexity IMHO,
> but that's up to Robin and Will.

Nicolin already has a series that does exactly this, waiting for stuff
already on the list to get merged before posting it. I'd rather have
things organized in the way we know we need them..

Otherwise we need to go around and change this stuff again..

Jason

