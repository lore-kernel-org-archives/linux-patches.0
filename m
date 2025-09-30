Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013034.outbound.protection.outlook.com [40.107.201.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AFA2F7AD4;
	Tue, 30 Sep 2025 12:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759234417; cv=fail; b=h7JFJbz2Keg8EzS7UJ0wqsgqsFWEqtJhb4htVatynkqYtJdAHJgdOBCk2O++2knA4/soxGthkf+uC4fzFE0YKlYCwdFLAwPCyTuaaeSenazdPmkExd63L9k9pJ7E1vTwukKfvKTyYoJyGblsWST0VV5rr0DiSqg1IS/ttW3wb10=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759234417; c=relaxed/simple;
	bh=SwAPxpJy3MNIzeshDlHs4VZyQwPYhWtgMl1n4RucoqU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TjKlHziNNTnIYXbxIDD7DNw9XJ71HaYOAdmhEHptcKVcHTxQi9Yf7nNO37PUAbfDQG1yJh4/fvM6s5yUGvqddlw6O4MDXzv7n9VwjwXBUZhc9B2E+yqyfeBEs2JG9Os0d9Utu7UbOUBWTesOIe874laLAMqHlm4CmydYOUrGf/Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=twzY4Qp3; arc=fail smtp.client-ip=40.107.201.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="twzY4Qp3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XUKU1L777SuiJElqb7MoMH1aWPqIpAWi3rPjkBOqLeOjSmtGxZIZy0au9Gt3kzTSZKVb2J1gGA4LxgrrAlDoX2NOFeqU+oacM067vXXvW3Bb8TmeMTRWg91V4dCHNKw+yQJxOIr+5bpRzN1flHVnqnoWcW+F+Fcic0uYwqCjJ3xMPxb4OCxvAjOI3VZzXlfhHF4NMy13cl4CruRxaE1GSd/R7q+CFaoXvA0HFGXttYO3CIku4OPAIcjB1z1zCN8hoh0jY7lbMD46HpiZNKpFxAi3+7Tv6dmgWJSkiTIoAgR2NOukxCL7IGCjsrOi8CTFXFsQCONJkaY23oAXaeZ6tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MbxZy7RewsYgzE2ciivJXpX1SJO2drVIjYO5yoF7ZMc=;
 b=ytdR0UNeqClVHfrMGteL/1WWEwJkJaZHWwhneeTBsVzl2sgEVG7Q1TAXSMcU+l98JJ35UucVNCOIv6Zer/7moCBNJ9OOAqOdGBi9F2aYGLzBVwPcjIG9oHrRyXv42wORdxckarx167sQ7IyS+Ah7OBtXOx/Wvde4Mb6m+Scv4WkBtty+GjK0Z70xma6HOh2CacivH6lm4Nj7adukXhCej0WasBOY+3n6F0jCfXjXEzUudUG7yr49HqwB+eq5s7fN3SF1oEEQ9jKX/AMA9e131nDCNDZn7UnJBVfADreHQzHyYgmN3KZaDeeaPYInZBJKNZwk66OUihD0bKOhjfYb8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MbxZy7RewsYgzE2ciivJXpX1SJO2drVIjYO5yoF7ZMc=;
 b=twzY4Qp36jNi9EWtSz6CC+PblyZqtvRycBCpRhAdBIRikaQPl2/fDRu+leQqBc8xVHcO35R+wT9BT6t1WyBbHyfAiXMVvc7u9A0UqTuIXYjZTsotfJ2zxyRA2/5JzOtSmYHJJTaRJt/BThD1pWWcRekNTDvzJSTXGaJqyH9WwBbwUwHBJfWEHTmCDfFnsUedNdPk0yoDJoIcvRXrUiIpvo0gAnK9g7EN6clUq05lEsilZfnCptvj/81OxdL1csbKaaKJZBGYHx2HjDDZM30mBHTNPZpE+r9O9eiRtip2E9MavhC4sds/5amzH1j4INa3eNkio1S+0Eoerk/7KHL41w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by MN2PR12MB4045.namprd12.prod.outlook.com (2603:10b6:208:1d6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Tue, 30 Sep
 2025 12:13:31 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9160.014; Tue, 30 Sep 2025
 12:13:31 +0000
Date: Tue, 30 Sep 2025 09:13:29 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
	jean-philippe@linaro.org, miko.lenczewski@arm.com,
	balbirs@nvidia.com, peterz@infradead.org, smostafa@google.com,
	kevin.tian@intel.com, praan@google.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH rfcv2 4/8] iommu/arm-smmu-v3: Introduce a per-domain
 arm_smmu_invs array
Message-ID: <20250930121329.GH2942991@nvidia.com>
References: <cover.1757373449.git.nicolinc@nvidia.com>
 <80310b98efa4bd7e95d7b3ca302f40d4d69e59c5.1757373449.git.nicolinc@nvidia.com>
 <20250924212912.GP2617119@nvidia.com>
 <aNrVWfF69EU1xvBB@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aNrVWfF69EU1xvBB@Asurada-Nvidia>
X-ClientProxiedBy: SJ0PR05CA0061.namprd05.prod.outlook.com
 (2603:10b6:a03:332::6) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|MN2PR12MB4045:EE_
X-MS-Office365-Filtering-Correlation-Id: b9774283-0bba-420e-aa5f-08de001ac51c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KbFTPoDshY7fXLWkim7CU9uip/AGKtAMiWClXIewOxJ5kTXYWMZeLEpymizZ?=
 =?us-ascii?Q?20TKpm2enpF4bF0CBJPN7RMtlEUnHMqthTBdg2Xlztw7eYEJlaWDCXM/cxbR?=
 =?us-ascii?Q?0k1V7oOjomeUVe/322ns611LeiB8eiyfw3l9EfkMgyvcTYj8xOq8mfSQyuV3?=
 =?us-ascii?Q?3OG0t6Mvlz7lHDnIODYgW1vo1GrL6Cx7rwgGfwQlBrublhrJl9a7kbvcwVBV?=
 =?us-ascii?Q?mRC3Z53Os/waLVSE4nPYTRmO3ip8hffayOoGl2GpL7MD4agi41x8EI1ECnpC?=
 =?us-ascii?Q?fBDGIClsCrDwmRi9aj+678blxIb6pnoUB/PvxoPx0TfkuJngihUyGGzQh3h0?=
 =?us-ascii?Q?97Do1Pkp92dze2tBIPzPU8JDAn6DrJ3+3CyDHHrpIenIKxnd+9xrraphIWW6?=
 =?us-ascii?Q?XRjCTBXIo3WgfhItDoqzvIDFqFFbdG/qH5ce6M3+BywincNT1g3IV4hgBjTb?=
 =?us-ascii?Q?1LUQPf5T9GxpTwbDwUYJfs5CKm7Ts1u5NV7m3/by2bcjkQppoUA3uh1RyNdn?=
 =?us-ascii?Q?n2WmBrHWcTDn5OQgAwJeMMgZOaaRCcCr/Hcj2gwkNr3fU1hrE7pUAwZXWfi7?=
 =?us-ascii?Q?hx7MFEJglAjQqJM+CZBbP+mZubbAh4oxXUmHuP6S8g1OUxX6aE6wA9l0y7ga?=
 =?us-ascii?Q?DHFf3EDSs/qPeVg+Y2j0LrrdsgeNyNmlkYnaEUdMWI8Evl07lDC1szTKsYOe?=
 =?us-ascii?Q?QyQA3IJKd2wt3+obDZkirCKlCDlZqMJ7MUJkw/afUR1XoXuwckw2szQMFjfu?=
 =?us-ascii?Q?0oxTbTHKuHTQclcv9ivq/+ZiBsbgfQgAOsvPRCzWs876cFtDYy735gT7vsE4?=
 =?us-ascii?Q?7VTJO2HU4lQ4s6K9FfbUI+SYa+LfEwmih16aEo8dhOxJldr5EWbbIgzjWGTJ?=
 =?us-ascii?Q?aVDtpnj2tf/CycohVwbD4KOBBJ1vCWr6AwqnrwNPm07NobImR7luIiFP2PIN?=
 =?us-ascii?Q?CHO7ZFh/ph4Qf4pnw1o1r+KVhkPFJb1EBLxBM2HUkiKE1BXMO0BEiWmx3wo5?=
 =?us-ascii?Q?tdUzYNfx3jCva3vdQWgTg0PW8qxTn4lORSCvv5HgdcPw94UhgN2dAMdpWGop?=
 =?us-ascii?Q?21YdsdMBVp+dxAlKnC21zYqiHHEqrcKeqXnIhpW/UipWOIJVCoD43HGpNVRG?=
 =?us-ascii?Q?mHx2S/oFlJXNbxta21SMfaupslqQrI3kKR0Rgc/MXcqHFeVkvFwVcKQv8Cfg?=
 =?us-ascii?Q?mAxyNR7tawLuHLeFn2Bn7+fT6NOD9vifzrSUn6uTI+KAtDOjhP20L0fSP3AL?=
 =?us-ascii?Q?qAPb52suUzZDhrCSg8MKzIfhFR+aSYSCCd1jJ6MpD4Z6Q4AUYbTwx2cIqqGi?=
 =?us-ascii?Q?6NHAci00KepvoFMRwffPQpNvcQS4eLoEKBpUtVfnS9wjiWC5jNiKwSdblmsG?=
 =?us-ascii?Q?FE+hdmV8ximhxznRQ37RreCs3ztcdvK3N4z9tfJ0wMSuC7/42qN8Qb5z8BjV?=
 =?us-ascii?Q?pp9Sgwky6Y6ho8XX8bnhNwZuv0mPele1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Qbeb3vtDasNci9bqtZs3nhb7g/EFiEkAtdWVs3jnntQn727ckVnT2m3T4CXt?=
 =?us-ascii?Q?rbOtx88HHYYKOcS/kFeGBCgwHyPQkgBOmzFStuUxSK611xdZQXchle99mmvq?=
 =?us-ascii?Q?13g2DM9QSpFXwB+B0MK00cRF+g0GoVbXAFcjPOaCr5fxxaNaEuYR/jr6OzFc?=
 =?us-ascii?Q?ltfu35XONDYb00UxdE48EI58oUbAx97e5+t5N7H7T6+kzd+4zVg9pZUkRSHX?=
 =?us-ascii?Q?Sid1lEbCzrXnSkCpj7cL6NTpk+9+JhYjQt5h7NK9Ukny+Yjhf5VAN/BjmI++?=
 =?us-ascii?Q?KCUdYSGYV/SDK+KKdeNt+YcKzRgSjK8LqpBaLcOTqUwocbzzVWENlZW7JLji?=
 =?us-ascii?Q?BtZtE47rJ9QWVyLtnxBFKqm8Sm0pVTvO1N0PgLl4YxUnwYWxKbdO0jWBEO4G?=
 =?us-ascii?Q?vrSO92SbcCnKgXFswByQfXCQxtA8/pBmRaU+CLArDTUJLwDut8VH65ceUaYS?=
 =?us-ascii?Q?6kl91tV+e8dVlRrqYDbOILQIh06OgGGihB5djIucnOrVnlsavrSdc/WdjerO?=
 =?us-ascii?Q?ZKFncwfAFAuKdPF3utp3dor/Dc4LLqRMGD73kOGxC5z1NMB1PiajoW/9c7eA?=
 =?us-ascii?Q?Uh862iHwRVD4/z9fEDglmBupzrDiZ/SxukyRUND9A9CexB7Po6Rpaw4SBvYP?=
 =?us-ascii?Q?gpANMkzUG5dr2K7pjUHxlipmKqmxBc0x7WSX1lXNxsRpchP3w2IzUwfhgOEe?=
 =?us-ascii?Q?hExu5D7ckHcvs/MVUp+7iCBThWPieTbE0LdyxlKLPGAW4cO7cqC5hP4BPGLQ?=
 =?us-ascii?Q?00VkDlbe0zFUrcyfYoYNvMIHcGmvjzIsf/SzK+zi3L/s6zSWW/KB1/CZJ7zB?=
 =?us-ascii?Q?IbOxvpsZmmYBEB0azSdV46nkO08NHQtycIGb33bVT6hSd/3GPDHTFUyuwdfn?=
 =?us-ascii?Q?RvVHkjbJLnUHSFUXQYoi5+OoxVs9SZIUA3nxoAgHc+KRLYhzCovZJ7vtJd/U?=
 =?us-ascii?Q?YqMNWJNWcpt1Xt51LonKT+TzjzTnk/6gXJ8y1ku95iLL6LU4Jj08+Mg1YP6Z?=
 =?us-ascii?Q?FftpWAhPsPSDx9N8EDdp7eOkod3xKYoY6AYWcaQwSOtG94IYQdfOv//QpL7z?=
 =?us-ascii?Q?v4NmU5O0pztf1mHuFIxD/nqB58SanOxn2ax8prnEZngq8GO2h2AHplM8R8Z5?=
 =?us-ascii?Q?fgWhawyRmqKh6jxSSjm6kQreB8PKO8tQE37OWNUQz3n/ewCrWTUfvKI3FL57?=
 =?us-ascii?Q?CHMslRerSO6TdcICWIZ76FK9xHydDIgYzODBoOwnU5wVlH+9mlBgP/E2ZEXI?=
 =?us-ascii?Q?ytvxVxLkmzBw1WWkF+yPMRyDhryzLlbJGQeTvYJ48+pPdj/xfwocQ6O6JZro?=
 =?us-ascii?Q?keOn2ceaevpfnoPUd2fZDh9b6tNh9VvwMWnwzEgkxN/0v0P/ondDDC/UV03s?=
 =?us-ascii?Q?FZ/WEUke9x2vkcH+a9tjnSjOEf17L066b6tEPQ8rvonRk88N3RS+XkrJWYPY?=
 =?us-ascii?Q?8w3KzKEWMqv4JovvfHhpgLCGyX1o7i25qA7Q4KSFzJder8j4RFsdycZxpxXU?=
 =?us-ascii?Q?8qvKERMklZRfUp6v+4IJwonqHhcn43160opBN8/XY2lNw33iJncuzsaFlOVd?=
 =?us-ascii?Q?MsJoXAwtlRecyfkYn50ECco03ytQ0LxDJxixCyXw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9774283-0bba-420e-aa5f-08de001ac51c
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 12:13:31.1042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nu1RBpov+gF6oafrsjL39xoH1w7XYBFtz68yVYzF+7Tr3KjpF2mUANTj7w0nR+aa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4045

On Mon, Sep 29, 2025 at 11:52:09AM -0700, Nicolin Chen wrote:
> > I've been thinking about generalizing it to core code and I think it
> > would hold up well there as well?
> 
> How would you like it to be written in the core: a generalized
> structure or a general macro that generates driver structures?

I'm thinking to leave this here for now and revisit it with another
driver someday.

Jason
