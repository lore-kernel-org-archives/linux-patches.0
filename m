Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795547361;
	b=pM9CxTmUjHUOveGWh+hqk5OgATQXoGDisbEJsdI5tGEFsKcO165ib/5qJZtPRPPHcaYb
	 9zNt2Aj5FemtHEyoSuQ3GNxgJeZe6nAal122t92iKnUSNpnN88YjnCHGMx5WykIhL4Jt4
	 9KiBWNDetVGK/OTdywi5dto9MJjfZrdmY9K+4ghBiUlLiYIH91cJ/jkKuInuxjOx/nyzF
	 XRjt1XnOD+GV3Q1gi2cNXVR6GMx2pevFFdH0ygsZ7Ltqi6X3qpn/Nm2O3gS9/XY0nFn3K
	 MVp975+LsnLis/HpjcwOlwU+ch9JInil9/WKixRtaWLi8HqvtTP2qcEvteDa9sxloxA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795547361;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:Date:From:To:CC:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-NV-OnPremToCloud:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=7A4T0Eyzg6Kcfbuj1hioukrhwGcSeqR+pvEasQ+qb4o=;
	b=dlqtneNZR/2D6hk0ZjrSGPHYLarDQFK9+SksLyK93TBM3IoGGFrnGgcpG1KfEV6V/F9F
	 wSUUKed+E/3w3qe2VjlPfLkvjx4RFOZf14FR+2qay3nLdn9104f/NbMr9xCBv2zGhC2wa
	 cuExDlFnVq+5rEAefc6yns1I6m+JzovuTtVNmMa1HBcRHWIXFq3XPvEgd3/qa2reCshOj
	 epTPJJK93Y84iXJSJhzI4Q+F9xZe0QXmAd4I6FHHSuACjHNkyNrbBV4Sz2aXwQi/ld+7O
	 wCmnPkmcBL82jG+jdpyFIU9RO4Ogroh63fY2kg9JUMYqJDZ47XCmWM3LWMsWmwfYKNA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qYB8UCUC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.15
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013015.outbound.protection.outlook.com [40.93.196.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48534606A31E;
	Tue, 24 Nov 2026 19:09:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48534606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qYB8UCUC
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TrChWbZ5NqX7YBJuORtr5eud5WFy7ADakGOj+iix7IL5l9cNZeuDZfg+ipmbDzeIK9pXJA+6SZrOzU9N1/frlLsM43iLlfOPIXZBIRDL/Wzu4XHuAnfoZXqYr16KQxA8Ts2CKj2xtn7t0UhG0wP3nE8Jlf+Z3+nMMuDPsBvoOeR8gdth4V7BBRyXOIqFfJ3RdYW7gVBLa40SKmmRShlGQEKyB0CW4oDNpQN+YCBJnu7tK7VbFFGsJAqC5HQd4sm+tmC2lNPb9v6D+om1b02C++T22osERr4KnUWbCAAVj1WqXcj0TAkmzd3AGYsgO51gNS6neESNmJMVfG97UKJD2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7A4T0Eyzg6Kcfbuj1hioukrhwGcSeqR+pvEasQ+qb4o=;
 b=Tonc6NqXzkU9+EwB7ezktLWVpKzL+My5GoHnJvByFn1Hc/mLQj7V9u1XUKq9ZHCMdlMiq5T7muUqDzwBZUEphnBZMxS5t2sZSNsW3qcUDXYntZGLhJ30dyzC88C/e5G8K6ylwFomVi1EeTJA3bTulwMJJt3cFxJTOyqZWR8+TUoXFhB1fHcGF4jm6fP5ghYpbdiKF9+rC0ZKlocQuMLp6qIt8AfxL402nUwCyUzj0ntjihOBmzrvMT7hfvyf63jy4m5kSKWmYAlwpHlTqle+tFLRzbqVkmqU6NT/xQl5WgG4GTByy8gnwrOJgHWNdWWk5ISrH88Ge4Sj5SXRjaxezA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7A4T0Eyzg6Kcfbuj1hioukrhwGcSeqR+pvEasQ+qb4o=;
 b=qYB8UCUCwh1zrOuD5/VFZefQRHYCbBCN4xZqH+2LHnggkoNk6vqw3h7jbSdEZczpjTjmajlW1osK1q4f97/3JXFwr/jlKXX1zQYaESnxVajRDPtxPsPwfUmNqrSesUu59yYDerZoM6ms33V0x8ApYCIqJXIPFFbf3sG13OvsJl5CmtE+W0NJ266BCFfzlvpjUYt6pDYnG9oaTQYT/O3Morc07+sqlfaPXXNlhchJArVNq+cMe0mp6pb5OvWdTOYJtT48L6Ba3P9pRXMMkdEi1czVyoDxjIbf8wWo/rXgze4xBi0UI6feN/pken3mz+ykwMDy4V+KnCZhxglG/fuSgA==
Received: from SJ0PR03CA0161.namprd03.prod.outlook.com (2603:10b6:a03:338::16)
 by IA4PR12MB338606.namprd12.prod.outlook.com (2603:10b6:207:128::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 19:09:16 +0000
Received: from SJ5PEPF0000020A.namprd05.prod.outlook.com
 (2603:10b6:a03:338:cafe::2b) by SJ0PR03CA0161.outlook.office365.com
 (2603:10b6:a03:338::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.17 via Frontend Transport; Tue,
 24 Nov 2026 19:09:15 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF0000020A.mail.protection.outlook.com (10.167.244.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Tue, 24 Nov 2026 19:09:15 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 24 Nov
 2026 11:08:57 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 24 Nov
 2026 11:08:57 -0800
Received: from nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57 via Frontend
 Transport; Tue, 24 Nov 2026 11:08:56 -0800
Date: Tue, 24 Nov 2026 11:08:52 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>, "John
 Garry" <john.garry@arm.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
	<patches@lists.linux.dev>, Pranjal Shrivastava <praan@google.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v3 05/13] iommupt/kunit: Skip test configs without
 supported features
Message-ID: <awXgxBCNDzh/32cm@nvidia.com>
References: <0-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
 <5-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
 <awUg0O0WQUBcuUvC@nvidia.com>
 <20261124150843.GC8680@nvidia.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261124150843.GC8680@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF0000020A:EE_|IA4PR12MB338606:EE_
X-MS-Office365-Filtering-Correlation-Id: 80091437-8351-439e-e939-08df4a5e6efc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|23010399003|36860700016|18002099003|6133799003|22082099003|260925021911599003|260925021311599003|261009223027099003|260925022911599003|261021135927099003|261021123027099003|261021121427099003|261022105027099003|261026140227099003|261026121527099003|261028144727099003|10067099003|4143699003|261102123227099003|5023799004|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	zZJxTO1pAhAH6LaGlNGofr2AGljC1moLP04DGDzTq+RijqCRhZ671alVIu6erbQocgQUiR/kUamru9/K/APNzjDEzAGs7C8iTrLI9N0eXWfHvsQf2qEymYILfVvlP7HY86vK6KCNcanggvuLuhx4SeJbT/c+24wwVoOXH3TfhMX0iL3f1U8i1MdPLKfOWGefKdWnqrazVPTV0PBXmTU6DHsEjUnOi9upaur0r0UNVmYSZg4STRlKzYE8ENvjdMdn+nLQXTX6TWKseGFLURDpnGlPx+IES7fP70IniWgDeI0sjvu1F+aeKb+kppnGiEt+usVG7Q3Uqoas7FkRtOaVyEl4rXuqQ+gqqfTewlAUqh9MTfmv2AzSjZFvdC1VK7WLkwn69m8r6WiH7bxn3i2KbOwzuoedZicqUXQ7QtuTPWc5phKrTN4sVZLAnwEBipcGwn9KrYdIZFH6knDdcoT9ehZpmfwQ/HOszhsjRgaiQg4GlILAlixsU4TwPTDysKqVe2vk9/u4pbUhvXkEKN/SPkFA8PzkEIkW3dZg05BVwWuWcoMqH2/2wPllqAqRW5WwMDNJTZJd2dz3lFUvvip73KxWuFTkiMidqE4ebWQ/jdn17ytNwQrObiH3F27djDYkPVi9RPsOlR2YwogUgjp809Tvg9ZjziMIIm4+kqrKTTS+PDYga77vxqjDRdHW8Nl0+3WYV0YWQ+37+G2sIy+5Sg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(23010399003)(36860700016)(18002099003)(6133799003)(22082099003)(260925021911599003)(260925021311599003)(261009223027099003)(260925022911599003)(261021135927099003)(261021123027099003)(261021121427099003)(261022105027099003)(261026140227099003)(261026121527099003)(261028144727099003)(10067099003)(4143699003)(261102123227099003)(5023799004)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Zi1fjQekSJxI/628uxmnlNnWULSBziaStAgcpaRdjL5uOAjI4zte6mNgJq3PGoXbxobDfpgAexnwddv558qvbJsqybpMiOczCSRtDgPPLHYN8wLr0LXRiemTt5ZcGXrRc/4qzGYCqncPD4CrEwODtZ4+5c3dgvsdQmVWwZPbrYo9qFe7J8KObpwGNfRT9biM2qZwcpEVRoXaYyxr2A+kDdwzg8KEr8t7xSR7AjmSkWaH1mJcKPgowudU5X+ZFrSDyRhsi9WbrbTP3T+pZ2plUbjtsrJSWbGY84wZe26YJKPAp2MTzHXtLP66JP/cen00jtGd2HsGFa6QjRqBFMZ1zEnA/GMD5hB9YyLldYru+zpqxU6tP3cwgd+xMU8cJ0FBYjbYZI+diNI/KZb4wT9uoyJsoUeaPZFWlb4Y2fz+rOlWiBs+SgXh9z2ifh27i6vl
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 19:09:15.9099
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 80091437-8351-439e-e939-08df4a5e6efc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF0000020A.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB338606

On Tue, Nov 24, 2026 at 11:08:43AM -0400, Jason Gunthorpe wrote:
> On Mon, Nov 23, 2026 at 09:29:52PM -0800, Nicolin Chen wrote:
> 
> > The leak check reads NR_SECONDARY_PAGETABLE with global_node_page_state().
> > That only returns the global counter. Each CPU also keeps a small delta of
> > page updates that is folded into the global counter only after it exceeds
> > a threshold. So the value can be off by a few pages without any leak.
> 
> There is a patch already in my tree to deal with this, this test only
> works when you use the kunit runner

6e8127719449e kunit: tool: catch warnings generated by the kernel

You mean this one? It doesn't fix the leak-check failure though.

The test can pass with a UML runner but fails running with arm64:

  $ ./tools/testing/kunit/kunit.py run \
        --kunitconfig=drivers/iommu/generic_pt
  Testing complete. Ran 482 tests: passed: 426, skipped: 56

  $ ./tools/testing/kunit/kunit.py run --arch=arm64 \
        --kunitconfig=drivers/iommu/generic_pt
  Testing complete. Ran 482 tests: passed: 3, failed: 478, skipped: 1

It's likely because UML has CONFIG_SMP=n, so global_node_page_state()
is good enough.

If the test is supposed to run with the UML only, let's ignore the
other case then.

Nicolin
