Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010050.outbound.protection.outlook.com [52.101.85.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5EDB4BFE9F;
	Thu, 17 Sep 2026 13:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789652892; cv=fail; b=FXJ65qgYaJ1S+zaxHihU3zEL+p6RX6QqvYcjWcGp/zkI1Sr3BcBnOi9BHcS28xqmZyAWZ9QOxaCeScZKnDlGyN2/hKF2fC6ogolELI68SvI/4RHmOsBVre7J+kB0W1QyYgLeFLfLMXIbXThWnFh8jRANpl+dUZIWmrz5+3bFlQA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789652892; c=relaxed/simple;
	bh=5qTdMnnT4odmHTa7s1NB9bszrAIAI3NBu27zGyRQ7WE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=K65NW3oyF/z0SWl34OmeExL1yKojMSVZFQSF9GIzeTXt1UFgnYlpSajhbZR5B97H8plYaS8S9KvyC8n9GlB4rZ+Id1jvJbm0gFolXCc5/nG/uWf/O1E7xtIOIKFT2wZktDGRSIgNcdyv5EGVEPARqrjPUnH8bWW+V2/Y309543Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JZfD/ifm; arc=fail smtp.client-ip=52.101.85.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JZfD/ifm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K8JjNYrAb8ggXSnfsfdYUvysjK8UEPPEdz7gtoyQmRQmevVsbsfH2AdnXPGp80o8HO+u6dXEnQTMAgEiBpJeAUDa7m0V6paPsoRt2ChB0YXkaoMtZx2B3G2hWtguH767omgY08XdFNT2o3smhyLZn6s38QoT71RYW1ye1s2s7f9tp+dXumsfuh5qxKxh5m4ouUJPk8iY8Kgi/MNgA82agDGZWBcHQNE3CxHh+krvTuIMi76Pduq9m/xwzaxGCkdcRKy6nJWfgHX6k4JjhR+nwQyACa0WEwUDPCvhNVRoKhSTHJc9tt4JsIyDlS2RldVF7o0E/CS5cz4fe0SOqgXTGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5qTdMnnT4odmHTa7s1NB9bszrAIAI3NBu27zGyRQ7WE=;
 b=P5eVTHOz9HpL4MMxj1fWxMrJLoKH/MnPSGjlOOz9eOcJPXuFPV3SFJD753xQSMcf6g/PliUjpgDsesX4ktGcXg4fmuxOOqeQgwLSueBmUnZqxYjSXpsYi0dTqv4XkNUBnSaAsFd2i6/XM0E/V4JUqQeEZlU23sfh6klVXwIvI2cKrMnkJ0VP5puk2enixwIH1d46aSZXzzj3/LuadBFCPcm+daF6O9AB732zt+jYJba06y0vQZiPqkEsVrVYm3BKsvSYPlS1NXDfG9MGG019qth7SLKXAeKeLdqjmYp4wcjiuKHy5PGnOu/YIhyxp61ZXixaLuUUjwPwngE9OsDRWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5qTdMnnT4odmHTa7s1NB9bszrAIAI3NBu27zGyRQ7WE=;
 b=JZfD/ifmaXI9GuNS6YjVm5q/7TMTAuKZjDifj9m64e/WSVbgtqX4mzken5+YQwalek6SGP6FEGe46F+Ebmyu2mxZEanE6p5HqzmypymypF3qOEyq3STgflsPuiYCwWCZ5APjpa1Ni0j6ZVhLPIq0jdqVt6trJN1oH7gdWEoaTMYggrwd4gaprerk/XNORPwx0c4W9N37WQhjM20y9n6klssFIFKfS7R8DYtPlJTBLnGjq0poU9bVrvdz3Atg93ySX/TNUdFJsbZx+Xy39+u4b0QLhzc5e1SUZU37rQLUSRUSSY0KxlQ4GiNeYJbBVJfWJqo33XIObtXElzUGvKIAbg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA1PR12MB7760.namprd12.prod.outlook.com
 (2603:10b6:208:418::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.12; Thu, 17 Sep
 2026 13:47:56 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 13:47:54 +0000
Date: Thu, 17 Sep 2026 10:47:53 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	David Matlack <dmatlack@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>, stable@vger.kernel.org,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: Re: [PATCH v6 1/9] iommu/arm-smmu-v3: Handle ARM erratum for CONT
 under invalidation with SVA
Message-ID: <20260917134753.GD3968357@nvidia.com>
References: <0-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
 <1-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
 <aquxuBnh6pdxu4-8@J2N7QTR9R3>
 <20260917131601.GY3968357@nvidia.com>
 <aqvuyse0hmNCGJqt@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqvuyse0hmNCGJqt@willie-the-truck>
X-ClientProxiedBy: YT4PR01CA0211.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ad::14) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|IA1PR12MB7760:EE_
X-MS-Office365-Filtering-Correlation-Id: 516342e4-887a-4aab-2b8e-08df14c24629
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|18002099003|22082099003|10067099003|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	hkjCmdjI+13xUuPE95iZUPJRIIhYqoyzpqfbP+huMl+60927wkNbFW2/Pi1c/FRxBEmr1/eaEaMtpeYjVclWQGuG6QvAw+A6KAQIuepCgRsKbKa7obNOUzo5kTUMwrkk7xzjWtlsyilIXH6JOW6T19xNr1IOes6EV/acddsQAUkZQCx0CcHpMRJzOCYvXQB35R90QzoP4L/SpkfhkKYf8tJ7FADoJuOr6t0n79OmIgI/YZhCnBu4zxnaxvhTbboyG6E7jo4x5/eSWKjDsVZMvWqbEHjXAwTzaJRLIxgulURGDr4Lla9IWHiohgFob9xs/+1hlVgid2HHpultZrtG0nfk7wiPPuq+dRoQoAyD4SWqnr3y0QPe8YRKum21bWu1l6KsHsaESXyLzCgqqWkT3WfXHKKa9mpCAfSYvYFDD04WuBX/OGbBOI8Ok2i3ccSDMOvFE5gTtmv2L+YeoRJ32ZZWV/+2YhiKwJa53pL0gSMf/eEjtqOdQvbrWpxASj3UseLj5EloBIwoHS0gxCYxSwbMLkudgdc2+vDpQDXHRotOFoNtdEs+p0G8p61vdvd/zW6h4Zyxq4E1GqR2E8TTDiOg7qbw3qjauLApxSclDU+UaHS6KheH3BSIFTCUIUsqJIfZ4hNWgCfY4VaxUiftrNOatTH9Dm36w75lRwEwvT4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(18002099003)(22082099003)(10067099003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?miRbYCID019VSkR1+d0nxE7iLXWuR0o/jfLA61hqS7PQeptEcwIKAPyHYEiU?=
 =?us-ascii?Q?Iq0P81rnSAfXCCrhNIusPzmrwJ6cStJ5/XwUTxIPL1tJLAirTT5mQLW84WlM?=
 =?us-ascii?Q?aTgWja22bqGTw3QPf6x1xg5Enrfefjskn+5JRhpDRtGuHbkm5yFeCOJqO3c3?=
 =?us-ascii?Q?WAWrNVgX8dbB4CtcPtsH2jm+Px6cuQ/+m72r22c6hVrI9ytlm/YQaRyMQb6B?=
 =?us-ascii?Q?KTulRZe6mh6phfzmzj254q8MWP3dNFZOWEAiFifdrjuvgD2IDHUif460fAl/?=
 =?us-ascii?Q?74cYK7NKDw9NWtULpB+7vNde00UBjZV8OKAEDDMX16PFH7Oh/hSc3jjXAn0b?=
 =?us-ascii?Q?XU/REtXlm2hQmB98Pfpnb21t69Uv8JRyTUOFu3mhDP08HipJqOK0fiqnC/bD?=
 =?us-ascii?Q?ptHUVNSFlL1TmU+BnUdadpGW99jBibPlVCYEw/rjUSCKjTD2jOF6eSkBFXdB?=
 =?us-ascii?Q?PyUvpRnqcRnfZfu/NXkljvTAcEXIzSZsEN3xEV779mJrTa2CgC5wMZ2NO4s8?=
 =?us-ascii?Q?p8UOAyxbK7Dc8GA/seIAy9l76Gf/Hm4iFlHgg93g/3fEDzjeU0rG1hDZwvKL?=
 =?us-ascii?Q?Bu8YQVFsXya6hU0JqRS5gavX0T/MVhjQfVNyEC7scV+OUkrUVbFonV0TcPP3?=
 =?us-ascii?Q?ajkBuKNeJfjOHXlCdF++c8JZ/3eg7vn7AGrF+1+G8gLOcZXPfLUKaAHQRjHP?=
 =?us-ascii?Q?CaG92J0g4Jl1SOQNhCG/7IVFkifuH0wj15hHj4HOVSekJKi3BfAR3u0lVfHl?=
 =?us-ascii?Q?B+9Hq1fDURVFg9nV5Mclk+34yVXP8i3PVZhS65yGbJsh5cy5xkE09U6ENh09?=
 =?us-ascii?Q?tOS5dB6XcDVmKe2eGNXCfeCkeim7UIswguTOvMN1BtWiEc/0rjVmu3AJNr3U?=
 =?us-ascii?Q?C7rhPrcV/J6VyTmWCMX8xLuBs77EIQEtsvQHwy9bXkSKdRubkbi5CNqjOlcQ?=
 =?us-ascii?Q?+JpxopHZ6Rgj77lhJh+At/3IcLSN7rbKOn7Q28SUx1WdAwX8tOSTS1GZlk4o?=
 =?us-ascii?Q?eqZPFrAMOdHght8Rtf1Lysmai/lfwr7Psokm0W7OG6H0sF19fiwONLluSrii?=
 =?us-ascii?Q?UD49ipQZucIy0mujg0Dn+WMdmkykV9/SIgR1BG9ixvJTyPOqh3dftVERlP33?=
 =?us-ascii?Q?RXNJXFdKJe0ByZmPLBuMJsUHnmESCDrUgLEPobYaxj+I2lnKwrmXsaFItxiv?=
 =?us-ascii?Q?898xAVjwdWGiFmWmESjjjRyT0AHmaqf2wm8AtUDuAMaTCcq42Ta5BqHOxyeD?=
 =?us-ascii?Q?ogt2PD7biuCaSjh9Ts1I+A9y6r2xbZYwTRMtGIRjAfnwFfzIkWzsRoQLebxC?=
 =?us-ascii?Q?n+yAFLJaJVEK3e6BP3BDszz3YiXQ0ZueNuPH6Z/cfVUWrmXOPgRNeXrmOrJA?=
 =?us-ascii?Q?keOE2JAbwBKkBNIz61rbnYXJWENT9ivSSwy6vVga7n5Nihty8dWTgiv7OskJ?=
 =?us-ascii?Q?KHmNqhMiR4cgqABa8yPHhY2KXAJmf7pez/g6QYLryeXEfaTfYBsDES3ETGg5?=
 =?us-ascii?Q?R34cygQ8D16SLC0kVYR+soGO2kLio1Il8FBUuT/fvebV8gQQUql9hyVsMeCy?=
 =?us-ascii?Q?7g57uXqRFAXrSrxtFWg+WOe18AVYLIVYPPbxQzF18HepRy6a4J2R47PXhyIh?=
 =?us-ascii?Q?6wTMtcPICn1nVYuB/K91Y4QM7QP7SaULPk+Nh9S8lQZFjUX4/CLTc92oqKhO?=
 =?us-ascii?Q?W9G679sxcuyiRfi1QCd1S5cmUGguJZRiDuDWH+41i3jnuUef?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 516342e4-887a-4aab-2b8e-08df14c24629
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 13:47:54.4017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MfDkbzbcLAzXHTAfNUHiX9FewRHC+zT2/w04mJb4zkXn+f9rbeETd2wOqGSsvL3B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7760

On Thu, Sep 17, 2026 at 02:44:42PM +0100, Will Deacon wrote:

> If we can do that without churning the driver (looks like we can), then
> it's probably worth it, but I wouldn't be keen on churning existing code
> for things like this.

Okay, I will churn this series then..

Jason
