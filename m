Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2058.outbound.protection.outlook.com [40.107.212.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62216139;
	Sat, 16 Mar 2024 05:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710566400; cv=fail; b=HB9qps9K6G3wcDFPre9FpE/+cI0CYMlR+I5Irb+CN4R1R90MlOZRy+BRShWLMO9SauJSCrexl3Qep7h778aV+yBR9Ssy0t7YDaLcs8qK2488wnxXT4pYr3bDZWkMMg2v4YjIaskt9QH4ZSFkZJhEZwrTpIdm8P15VjzJQ7xMNpA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710566400; c=relaxed/simple;
	bh=NyGs+HQbUB2M1QfW4p4kTm7WkZ9Xs8gBDKlYtaYg53c=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oY+hHnu19tuwwBqMU0csd5/4s9XYNmMjBiOhrwoWVSL+0sEuP5bJSdu5013GgJ+3KXpa4RE4cfcxm+e82XFt1BIQm7YEikYO5/rHUL122ObnV00Fbgt+L1w+ie1YQn3XTywEf3olNEMmSkaaf0HqlQfKSVmkB//5IHcioZ8WbOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kgcw/2zu; arc=fail smtp.client-ip=40.107.212.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kgcw/2zu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ag+lkVDXwwsbkiSrDNRxiy88w8TKBmMu7yTAPLvNx6BPn0SJvIExIFzd8vVS/cSoq+XU6SMwCgxQ3jwnAy/UDJiL8jn4lrbpRfFOlHdfqP7wLu3mjaoM264FzlgH3Rje7OMqdCDx4sc5KcJnaXn537qXa50VWFSbC3EmpkWEe20fBTFZWEoho2/8zchH2F0rbK7LsA5KG+Ntk0JlHZ27PkOZzUHReHuOQZPVKbh5YsnzQ/rKkv/v3/AIZGRVakcA1glMoHIhTM6sD05zrjcNg+NN+HfbDyyhKjjW5pw6XOL1isQOV+9eYMNl6xdeqUZFKx+xqk6GQ1GhjM9tHe02xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TTdi7qRp1hWzTTxIudUE5shhWs1y4XC5nM0rT+td3Uw=;
 b=SdoRBBZl4PpZ5p+Gz/V5nvaJh6pWol606kjW8dlv7WUcNzS7hmQwL01RJ0OXgjm8D5cNWfTKq4RONNLCNnOyjiUWTuycoHkfWIuvPnqa6JD1zSlKl70RdXGERJ5pJgLSiEVf4dCV//2FskzZjtqgdRSEHT9TDW8JxzI37z+gR3jb0EMb2WIW/g3N6i17zrIAmHusgwAoO8VqIZQKj0s9sOdbXgeylgXvzK7FwB6Tvw+Hlb3BJpzy2XerZL0Xi9hOPEjTOvOqc5CMWwXta2fXPxHncvXHC8ItyMfuFnZoA2QSS4y4kcjnUKm9DQpFftd0oGxVKemgBxgNEEP5nF8f+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TTdi7qRp1hWzTTxIudUE5shhWs1y4XC5nM0rT+td3Uw=;
 b=kgcw/2zubfqtR0fAunzzt37TRa8jsd3tIy1LkUxB7O+jSkPsaW7EK5eqfLDsMVGmeHOcwSQ0pjBVvXi6rLWEq5HW2U68DlURLSgCbRrBXpeIYF11LXxynOfpJqsDtu+iN39yCYIe2pUdk7f3YwVEx5HKZnVrPlgz+NOrVFCUitG9hsrv2l4v6GU8BD6mmW0d9mfCknICdLisOIOAL4tAj8/DMGxEaPMoSZhh3fFso/YIPC8UgaB89yKYr2BoASM4xT/d6i2VpNzQz/kDYuXUcQaMDki9l7gS6SIwuAq15yG/HtkJibvdILCFjeNoyipk7mF3mVhzf5uIKdkPROymrA==
Received: from SA9PR13CA0084.namprd13.prod.outlook.com (2603:10b6:806:23::29)
 by IA1PR12MB6435.namprd12.prod.outlook.com (2603:10b6:208:3ad::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.23; Sat, 16 Mar
 2024 05:19:55 +0000
Received: from SA2PEPF00001508.namprd04.prod.outlook.com
 (2603:10b6:806:23:cafe::72) by SA9PR13CA0084.outlook.office365.com
 (2603:10b6:806:23::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.9 via Frontend
 Transport; Sat, 16 Mar 2024 05:19:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SA2PEPF00001508.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7386.12 via Frontend Transport; Sat, 16 Mar 2024 05:19:55 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 15 Mar
 2024 22:19:51 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Fri, 15 Mar
 2024 22:19:50 -0700
Received: from nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Fri, 15 Mar 2024 22:19:47 -0700
Date: Fri, 15 Mar 2024 22:19:45 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 10/27] iommu/arm-smmu-v3: Move the CD generation for
 SVA into a function
Message-ID: <ZfUr8aCCbdnEd3+E@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <10-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <10-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001508:EE_|IA1PR12MB6435:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b420398-733c-4d2e-2023-08dc4578b742
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	AcDwCIdvYDf0JomDEg6Yz63PCY/Gw0zndtGbkBXHPH+kEAavYjLG5/xH/jliGqAUZXJDwiBYK3jiVvQch3cScwnmA72k2/QdKJrHZ1g604r/TOoydEvgUPENZincRyD5w4/CpxJ5yhRzs4Jdvm4TUouWa3nXadeON/6Fsp4PdIu8DRx8p7lhEgxauND2k0HVxStPiVi8OF2twcPQYL/GfVV597SUuBk+El6nJxOUiuDrQHhYfwyjc+KVUPOtTADsY0aFGUQNm0000kwcdnZU1ayAqvacHAlEshEWNYmbxlMIws4onUEYOR9fmSEl+z95mfIgufDPSSNye7hUaXlui+QlCFUYOUWwFQ6G+HGlZ0gE50mU6tPQLDLNC/V/cUw7OuJiriNRtwI6dzQsx6r2EoE93afcDRuSSpwjsP/mHe0JYpPzPujv6PAa32YSk+zFOR2pCc4tEHra55XMK9O4Swat2533+eAzZSgoE1cCAe7GR+EF8KxBXU3EyOKemI/Hnm16l5h8TdzmSmuM97cfAoWiCvwSUIrLQ6SU8Ykpz+RRyG7EYOSwEIfRpoidwJlHlbpn0FbM0aAaRlEIYXC9HiUcDi6dTKm3GJwgwdAvYKETLJx/Npu228HiZIcpTe5I653kGQ3zeznmACdWM5gX2ye4EV95IMUNEIYVNNVJdTYuiwXOnMplFCIIVzFDLIrwtALPHzPIGOI67mqxzDLrrHbrjACt3yV9EBwc5nGtL1Famrxp7jVV65SxzVd0iLQv
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2024 05:19:55.1317
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b420398-733c-4d2e-2023-08dc4578b742
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001508.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6435

On Mon, Mar 04, 2024 at 07:43:58PM -0400, Jason Gunthorpe wrote:
> @@ -1070,8 +1062,7 @@ static u8 arm_smmu_entry_qword_diff(struct arm_smmu_entry_writer *writer,
>  		 * Each bit indicates that a used bit in a qword needs to be
>  		 * changed after unused_update is applied.
>  		 */
> -		if ((unused_update[i] & target_used[i]) !=
> -		    (target[i] & target_used[i]))
> +		if ((unused_update[i] & target_used[i]) != target[i])
>  			used_qword_diff |= 1 << i;

Would you mind elaborating why we drop this "& target_used[i]"
against the target[i] on the right?

Thanks
Nicolin
