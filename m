Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010041.outbound.protection.outlook.com [52.101.85.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DEF383336;
	Tue, 12 May 2026 16:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778604385; cv=fail; b=uOTPlllLNq5qsLQKK/a86R0PzB85B8KQXfJIwowOL5VELzsfMME80AFXJzwzAMuhqBF+s60+61flHt1O3J5ShZtW9U06mDK0eaforO38AFRL/+LR0Dnjm+rX05/g9H6/TqbFdgznZxDU8Jqn3I4DphpRIn3X8sZUET9P5y/0XNs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778604385; c=relaxed/simple;
	bh=/a6JYo+5gnPdV0056ZK55BaQ865o28yvADYwxeOnOgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=XPxWjsfqdMfoRSv/g2ABzh2K1lnyrq8UPL2732yVgxs0N+b1sqYmumBY5E3D1nHt96hO5LLqgkIQH5e0XsIW49vRlaDe7pb6fQaX5TPbIb1JQYIvYXR1Ir7VcXDSUtl0RG+hjK18OQfyv380wLjt7PgCjSWMye0f3fO4RE8HOUg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mc8xxAhZ; arc=fail smtp.client-ip=52.101.85.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mc8xxAhZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UNH15q4bhb7YzMO7DdhrRlXMru/NXVRsOE7LcrdB2HEmfeG2NGwW4SLJzR4Ep/W8qrztI0ZyPBzKmWdH8Fha46vf50Wi/stEkS3NQWOWOd3e2cMe3gvyLCyHp02hqY3Fqpsbe+WngR5qcH51rK2uHZdNUbgiZoJMSBK/R0Q62HDkNbm8qXcJxcx69A9axrYl0WJaY/anFi2EHZXV8L9Giim4K2l2PqzK1RfGId/kN6EHVInbqauBKPCUNzRvJ047kGHRYM4BzJvxwePAOSQWjzHGKYpel80smqMt8V+npcFOYqaSpyxrTfxbTIV/6iWTgGlu5of9qzMs5lhr1ySOVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BtwQtfx1enuxlL8rZM+iG/+/Cx1JXyoprALYOVBlHsY=;
 b=axk8gSQUJp+8Gz4vsKYlNSNcYkTU8j86BVik0ajjIH0REyyTNTXslYVsp8i+xVeqAaRpdVlnHXDq9ccJY4YDWuAEJYjTXolpP7b0gip/Z/ll59Dd+wDnTVeI4bkxplyYmv4JIRofOrfWuQMXuGUHK8AfVVnOAKEqHlZEOHYRkpx+7yPyw0OdWJ71pq+5b7a3qvtnmGX1yu3r0QhiDit70HyyQui8NAMVBBSKxBMG+xxJ5SVSawP9vfR7WrTBBicnZZhzQiqzGeub3NjPbKhjJa4EQJWCP7werfxR2huzxB0mhCES8yBVEXbtNqh/iEJKXlEXoYKfPPptJD7JcpiBEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BtwQtfx1enuxlL8rZM+iG/+/Cx1JXyoprALYOVBlHsY=;
 b=mc8xxAhZCvzK/0D8VshySuk1He0HiI5UJVnvehm/S8v5db4b08qNKjhaUHwk/gJhga5widpPtjwEz1wHHgS0KpYOeIy/rWYqK1BGDinIXFt6o0wRR/xFRpUucTOlMrfREH6XgYf6wjf5NFqElCEobxQK7/wuKWBwxT+GTtBwcFSglGiRGnqz+Mj9EZ2hv4nsqZWc/FtwNYMsnzcQRHEu45mxNsifQix0T02RpCzERcZohYBXaHPYAzASU+bZTim4Y/o9FEFRqfoQVxpLkpulGPtjVHaTIzwADd9lU6ZK10bqkPAfCX9SrXOczFkz2h8Oaw0Nj9zNJjMQ0SxYZI59lQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by PH7PR12MB9173.namprd12.prod.outlook.com (2603:10b6:510:2ee::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Tue, 12 May
 2026 16:46:20 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%5]) with mapi id 15.20.9913.009; Tue, 12 May 2026
 16:46:19 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Josua Mayer <josua@solid-run.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	stable@vger.kernel.org
Subject: [PATCH rc 0/5] Fix some iommupt mistakes from Sashiko
Date: Tue, 12 May 2026 13:46:12 -0300
Message-ID: <0-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR22CA0002.namprd22.prod.outlook.com
 (2603:10b6:208:238::7) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|PH7PR12MB9173:EE_
X-MS-Office365-Filtering-Correlation-Id: 70a7b465-cb34-4cf8-6127-08deb045fda4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|56012099003|18002099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	U2Z9v1PAhf+T+11ltEwFdYanR8v+0X+ZtptyC8eX1MV11i8UD9nDjffDoNRr+ozPe15VMVqN2ZrtNrMAlB541sfREknTTbQiqt8AZg9KNaxqZ4JoLaWtWm7L6xACJ6QqS1cyC0bvdCMbRdw959GmEP1Skr8Gr6t1aqutlOOoUAINEoyvLMBeDlp9HRhwecBAL0bb8dGMEqXj0gze+6CjifrVaruOKzxPEPQGmZ87Gm1TRafsMGYHZ7jILaVAzQBBsirSRERJejuUQh/BZ/6TGZw8kv3zX8s/zOgEr63Of6jdPgp0MoCRSo80xXRD+aSPG3g2rfCrgrqbkz6/E+vnfYPrcTnhVu7DQ+bJA8OXVT9K03VU2j9y5MMJ1lGrBBPMHaM/0lWcjIHokAtUaR4TQ4PbVnUDlLW5izg9nL/16zLaqRcpQCPoayndYiHhG5hWihKmCQDDFLEsGHz8OaJz0nN7we5PSXNkp3jWzNsvfjHqaDh1sd1xg88iuTMe9Lw2erpqqyrU7yivvt5KRoDVFm9W/uHlOzTgMVNa0vjfcQ3lh5/uDSldH43OgKUF/fQP2xO+D3SLRa0y7t48BLF6WbNwce1ERhs27h6LCRl6yEV687lJkRKcpG29RHYr2rhVLYBeCGgTXdaT4VCuzvw2AStiySQ5Q/nPWw4OdbxomWjd42aDhgwvO/OIw83aHLWd
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(56012099003)(18002099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?V7BfKCEQFcPp2sHD0S9/MYfzQsPgcP8RsMakVyXUssUgLLXbQO01sdJTLhpv?=
 =?us-ascii?Q?eqx8ppEC2uMC2lnu+7UWOxCAX2KNtf4b/uT+9EF54t3LBrdotmOEBOWc31bc?=
 =?us-ascii?Q?p1UiMpSvQlWK6ZBYRkYXDH0Ao9yDDeYUx0/1tNu82j53171STxPGyhG0XSSW?=
 =?us-ascii?Q?vVLtGrD8F5Bo/gsSfNoUFAnSpxPZBcoxejzBaDowDmk7Fx5zogZQgkYBzH+f?=
 =?us-ascii?Q?6PfI4fylJBT2N/TE/y55DD+GIPJCJ++Jtl1cHoRXn+QREUh3tgfbx5Rtge4t?=
 =?us-ascii?Q?ElpZkKmVyDs8gs8FVEwyvxPCe7QxmXDfx9C+otamCTlke01A/yekpj5rhYyR?=
 =?us-ascii?Q?yYeiEPdbbVrzvjProJVbGAU44Dm6g246IADeddy/M7zZaZ93dkT8SifjzmjK?=
 =?us-ascii?Q?TtPMcNfYFr2ISlAy/mz691igQ2U7X33rRYRYWzs+082pq7SURjnj6O/nujPw?=
 =?us-ascii?Q?IhDM8VcFhmME497zlsyRUKc9Y5YKrM9eZpnc2drP7BdcgSpLYDGgwGzaOq4S?=
 =?us-ascii?Q?KBSlmq0yOC4d82lvA9lDDpKEaZGAfbSd1bCZm5pXS6fEahyLL3NwzKPoD9pE?=
 =?us-ascii?Q?T//JSegN/NhPo/Tyj+k53lPJ8X08ObQ9c/dq/+39EextFV22fze4q20JcF3d?=
 =?us-ascii?Q?OkYcMlf4bnOqth5+hsqaAtaWj+NWLc6p5j1HazJ/RLVE3FrQCrlcM23G+xP+?=
 =?us-ascii?Q?fmIYswgaD+eUE0jjMnhwJfUcjbU/iW3Q/uZ9Wszd8xw8RWRn2t7WC0D8N1qk?=
 =?us-ascii?Q?Mt4LGK79IEOpdvLsqerRYqM00D009JgguOpbaYiayvteM4BUXlmw9LKPWd3x?=
 =?us-ascii?Q?Kx40XtUNPGf14e9hjUimeQzfkttNOa1TtML81Btqvr1JgUykpgZiaKSR2Dlh?=
 =?us-ascii?Q?qExEUkg2DnHPc89BSAtGR0iqaslHl9CzHc+gS3hqXgBjOqF/uPUM52SMhbN/?=
 =?us-ascii?Q?yphcbJFxujEmfJgtNEqTBTqOFpY1R/Nkn6PwgYLY1DB8x5m/g3/nxtpV9+K+?=
 =?us-ascii?Q?OeFoUnjsg2Fks/JxUjyFIJks8YVvS5/s1V4lpWPnJFLm+zPkSFJ6+6KaUDzo?=
 =?us-ascii?Q?c5zgS3XgSFrLQxYYRQ49aTpBX5z/Pf1jjxYWeM/0XxDHlNIuB6Tu9oYaWx20?=
 =?us-ascii?Q?dbK7Ys5oAZS/IkZlUhfJSdwC+EG5J2nPbysk/yE3VHmZ4iktBNDK3tJCtQeu?=
 =?us-ascii?Q?ThkrVT77nv5ZNyf7gXqIrHZrVuMwlh1m7DJhFZsMp6Fa9DucfCuArr3D24EE?=
 =?us-ascii?Q?m9pb2ipL6zKsAP35oFPcOaUg6dRRTIqvM2Jk7X1n6eIzEyXvVLWY5PZ0CbI1?=
 =?us-ascii?Q?AZjyLe9q3zG8KabltUO5OtS0Jmha7tlTThxB5pj83lFMrll9DSUYn8uqblPp?=
 =?us-ascii?Q?UDzdUa6ln2A0GiXrl9pl8pzXGU7h/864Twnyw52mv77jdjs0FjCkOCdyiLA1?=
 =?us-ascii?Q?AlDhPomCjOfNqKkpx8fksWCcpz84II6YfLXMWSuEAZpBnchJy2di5BM180C4?=
 =?us-ascii?Q?093OFKHnKZrCm0FF/fo9P2f2uvJbJ4PAq/cQxmwFJERbVuysvx78wThsdbo4?=
 =?us-ascii?Q?sxt+YRp1uZqsBzox3lfoHakPnIwMKay0jXdh2OcOBMRlXL9K8i1v7aWDcXhN?=
 =?us-ascii?Q?jBocc9pn8Ztp551q3QjZ3oLay2rZZ0rYwRosFSlpQaHdjQwbkj5dYvBANORd?=
 =?us-ascii?Q?hVh/09L5mbBckHGU9nEWQYSFPgjTuABb1SreqOih8NMi4wOx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70a7b465-cb34-4cf8-6127-08deb045fda4
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2026 16:46:19.0039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NV9tL02Df52f2tChBszcD8HeqZToCFPfBkjIsO/JxbHbF/asrV8CBh+jKLUxuGs3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9173

Josua found there was an errant !ret, so I ran the original series through
Sashiko, which found some other interesting things, a few miskates were
made while rebasing across the iommu_debug_map() series, and a few other
interesting remarks.

Jason Gunthorpe (5):
  iommu: Fix loss of errno on map failure for classic ops
  iommu: Fix up map/unmap debugging for iommupt domains
  iommu: Handle unmap error when iommu_debug is enabled
  iommupt: Check for missing PAGE_SIZE in the pgsize_bitmap
  iommupt: Fix the end_index calculation in __map_range_leaf()

 drivers/iommu/generic_pt/iommu_pt.h | 24 +++++----
 drivers/iommu/iommu.c               | 82 +++++++++++++----------------
 2 files changed, 51 insertions(+), 55 deletions(-)


base-commit: be93d186ae88a92e7aa77e122d4e661fa57b1e39
-- 
2.43.0

