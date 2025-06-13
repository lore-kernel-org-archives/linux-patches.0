Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2048.outbound.protection.outlook.com [40.107.101.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAF0111BF;
	Fri, 13 Jun 2025 13:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749821768; cv=fail; b=ou+BY+ipA5f5psi4SPwd8d+5ndVRRPyg77T7Hf5SjJsM2wxM7wyRrvLLvum8BKQhAL8jXOljUV5Y0toT1bxXKtDYShEU2nEG8+BywtAiAfwvRntZTCcY/oDUj8XRggwccJrAmgEVfIQEahgkMsoCrHVfw+6W2ifB5AY3h8I5AgY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749821768; c=relaxed/simple;
	bh=DmZ+o4du1o0mHYO4AJDjvD7rrGCsFbmaDejwMy7RySs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mbVKxdy46+o4g1mZ/cdlbwPCUlAxoD3qsltCzNzjIxUciIItt3U+xPFDsuqVNG1522qSkus7lauyZnKXIbKQbHmJ9X0r9vxzH1zp/76JIlOznC5TrXSKlksdZRPn2KWSDryPoz+tgPQXk4js6sReb5YZ7q67fpXeqHR+QZcOV+M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CuQAorHq; arc=fail smtp.client-ip=40.107.101.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CuQAorHq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=if+zDrbmrBKKzELDSFx1uIK5H0ve5I5HZQWYTtvgJu8l1gebmKtevZ1VOLSpUA5jqqF4pjC4wF9HXeooZ/tyqYijJiSZ+08EoIxmb8mgXs5hmecUNLITN2HKSAD1fplt3gVE4GbYxl04wTXHflnTePThg9d6yNEO4ilfWb4LOnZdspmgfsnrhb1nmSottS+E1rPOlaqn8/0YkI8/kOuUwSTB3iAfBf3z002tNcp0AG/pODuGnXfr3ge5EXPgVXvX79svu+513uS7b/rcMTg0DX+IlJI609Qi+6hdNQ0bIz1MGS6JNtF05o+W01XJCF7EpbRSA04423Yi/70Y2Yc7pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n84P7t4w7SrPq091QkqwSkMTAM+ncYQZcUa5qo8H8Rc=;
 b=WVuq0ih7TpFiLU3Au2RtaiAAybS9Dm0YwxYKAqhiTY5nrDp2cLKPRy+SBuxIeTRC8triFny+j1/REA/kkfZLeD5kK9FU3TMCBiK3MO/ZiAVVYZZfaest15KU673qUXKC+6P449Lfy1u+1kxIwfiBLRxGIFnUDyehkgdIUxssfCllUVfv3QX+uoV6LVYepOJCgeDBaTFUhszDqvgajVcvPomSNnV/x4fdWGogSAoIIH1B81H8IglLxT85erulwUGdVGSgo1An63EOw9fxKH/UQNi81/MSELmkzyIqJh282QNmpvu0nCo2lkI2xMT0l9m8TPLcIHqq+7YUVnWF7a40/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n84P7t4w7SrPq091QkqwSkMTAM+ncYQZcUa5qo8H8Rc=;
 b=CuQAorHq2aQXR2uiluyieLk8clvtq0PSgXfcpRePaiX8MitXKNtPwOam7R+Oi8qTd2G8lTkfhxiRyrlilTEpywxy0CiA/p41xXg1V0KWB0W1HbbfeE7orRsqiTArHOIauKw3Tc976FTj8whpqkMyY8fiq0K9+EaVzCECyobLw/KIFvgZ8dk3yKYvvp4/jepCE2nQCi0LgODtommkHNu++i1uMBGfNiMu9wY7MBFkH5jdbDzzjDxGO0E93Ocfa9if73hLthlL+ocvUlsi8He1Z1UUubz7hW4rg+CTGeoY3jwd9ju01P2HztRpv0WCcOa6XVQmtBVFQMGnAD3iQw3CaQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA1PR12MB6701.namprd12.prod.outlook.com (2603:10b6:806:251::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Fri, 13 Jun
 2025 13:36:02 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.023; Fri, 13 Jun 2025
 13:36:01 +0000
Date: Fri, 13 Jun 2025 10:36:00 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: kevin.tian@intel.com, will@kernel.org, robin.murphy@arm.com,
	joro@8bytes.org, ddutile@redhat.com, yi.l.liu@intel.com,
	peterz@infradead.org, jsnitsel@redhat.com, praan@google.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	baolu.lu@linux.intel.com
Subject: Re: [PATCH v1 02/12] iommufd: Drop unused ictx in struct
 iommufd_vdevice
Message-ID: <20250613133600.GA1174925@nvidia.com>
References: <cover.1749488870.git.nicolinc@nvidia.com>
 <4c85d75d630d37df6e7140b7d396678046324975.1749488870.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c85d75d630d37df6e7140b7d396678046324975.1749488870.git.nicolinc@nvidia.com>
X-ClientProxiedBy: YT4PR01CA0277.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::10) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA1PR12MB6701:EE_
X-MS-Office365-Filtering-Correlation-Id: 1dd81da6-4059-44f4-1d1f-08ddaa7f3cdc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cQbgHew2AOFBoOdVFi/KsAk4YZetlL5+T9KY7KPoT05+UuPdvWcRdXWozZwd?=
 =?us-ascii?Q?Iz32KRmC/fTXCymQw7Q6kveVhqq5qnBiUBoWtfGBaUSvKnNYntfP/+Z8ift8?=
 =?us-ascii?Q?VpWds5jDowF2rDCV891Pl4OAZgX9/7098kWj/RXPo+zL73aqMku3NmJyUblR?=
 =?us-ascii?Q?rRJfIip4lRRz9OmdqDb2Tci1jiGYUg8UCyjOkv38PsctmBrgDi0Pdn1Sbf5s?=
 =?us-ascii?Q?qkH6KKWCFjK7WV0UHfuNoaw0QGoZMCaCwwEhX9VfYODxgsvLd4M4blt/Nuk6?=
 =?us-ascii?Q?yxKUzDRRW/KMFy+Y8OaxRC+XUbkKcMoMmP0d76tKAAs9BR+kzD5l5WM8DgHV?=
 =?us-ascii?Q?HL2KVjQvPMos+WRSS93q0tFVlns85agrxvXNNgLmmXF0SRbUShylOwXOu0df?=
 =?us-ascii?Q?n+bdTeSAJX/NE/3rVUYfijMFTNCao4jZ+WJxbW0f6XLw7/B80NUAk2eFtl8f?=
 =?us-ascii?Q?TETd+PxQwt0zHTJiIvt3W8oFrd+H3Z0xh7ju8Oic5WO0Zj4+de8IoVSSOe6P?=
 =?us-ascii?Q?ANh5c3fPefVBczeLJq/CwjQBA13e+3iMv6EckrNo6CmneYFqbGnUwWU7WBQf?=
 =?us-ascii?Q?AWwBOFVgHZPuSQfn5ZTnKElcpwZiSCm/cEhI4YcgzwoKx7IHSa/R0iQN0nr+?=
 =?us-ascii?Q?k1KSYJeLsX1e8CHJSIlV7Tz6HVoBfs7Y02kqCCweIsQK3Y45/EekEIYj7q5I?=
 =?us-ascii?Q?ltl9UB1wMQRO9Sd48topE38cwuCyQ3wjSnojrrnm1kespMSd1HhHdMMJt5sm?=
 =?us-ascii?Q?wsdvXdZNlWnpzJtGKyE2W726aRU5vGMok/3VVaQtZDDFy0wm2lKi11Fxy5p6?=
 =?us-ascii?Q?QsDMiBBQur69027/BwUu1lNWxp6Uw/qshlW+lDT1gOcB9oM5loLnGSFKAWq4?=
 =?us-ascii?Q?qUMa34TpradoBQLYF2kmNSPy+mGgfD0lVdIwDF5qYxmRs1+7T6k4+x7MZ11i?=
 =?us-ascii?Q?feumQ1ieBFARWDqtNmvIo8gClo/6/GCYof1Jpkor7LqW3asdCdvddxJVK/B2?=
 =?us-ascii?Q?FbtdRsnIB5/iMlvjFbW38+zpHZlzhvMLNWPBPu8LuVRx4KJYXxB7vYpFP1RQ?=
 =?us-ascii?Q?3zDeCFIDP3k5quVL9qIWGsO287utQ+0vgv4zW/RJuUjoTRSrZ2EMnIehyjbm?=
 =?us-ascii?Q?ae8+3ER4Z8gpxwCRuQnHoZE/mXC9drCaoseuHm0Oi3OlA35aLuM31quZjuuA?=
 =?us-ascii?Q?vqYFOv9yQxPpmJxaiNOhS2N6nrq0ofWYLu3sKscS20V6VcLhvdodbx4g7hAz?=
 =?us-ascii?Q?MlZu6oK0E8WCAJtWYoHL0O2cqjazhdE9Xtmi0W5zfjyouqvxyWGckeS7P8yH?=
 =?us-ascii?Q?MDBhFWujls1drudkdwO/jbeUosscD2ZVmotv8xTyOSCdzvEjXR2+t8CrwXp1?=
 =?us-ascii?Q?CWJ6RpzV4MCJrB7xamKqr+0coEAMe6gQpDzu1NnnyoEsozt/iQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wHFHPR4l4EfOu7SACFanPNSh7jE9B/F8BiG6NXH/IyHK+CAJRcYEQrx0GaFA?=
 =?us-ascii?Q?VeIl0UMVV3FnEnL+kyb63wrUhE18LrMFYJ8TNvYyTcbLeUI5tM+MaPxvvrKs?=
 =?us-ascii?Q?hxTfVZaOph7B3+W15Gw+SYVCqJeTp3GcRJ2yk3wmdNL0aIK70yH9KJvlFGFB?=
 =?us-ascii?Q?PAPd48zSMssnWtSMk0A/xk/HDkEwjJocEWg05pZ+OHpHeBMJsBbaMZIOXZr0?=
 =?us-ascii?Q?DjQU15AtyvAIcBNbB8JmFWtKZ2YqhG0RJDfjSy6TNeqLzAzRjPbIWM1eSfS8?=
 =?us-ascii?Q?baJGyQyl9yIu3E8W6IJq2zkrX3R61FwmhAYiOgqFAZBUalHB+17CTP4WbM/G?=
 =?us-ascii?Q?4jdIfrvgSpOtykihgWBgYm2qlAwMu98KDTQv/nQvZx47Hv69Ms7EANSDaAuj?=
 =?us-ascii?Q?lrTOMQIgzMz1PHfBmyf8z293PfHM3AWLjPNpqNhDntV8OcqBmHYvtXRxwCdP?=
 =?us-ascii?Q?apr/AGUCr36pnoCV0Ezccy0VGOr2TVGPP8ZPV2m5Afl+irCZxpcYEnrQ2eR3?=
 =?us-ascii?Q?OjO7VBwrhv5sSMQ5vsDRKmH+BP6f/zyK/wifHDDqumWwHiQ/2DbG+dSxhmGJ?=
 =?us-ascii?Q?MGrprFXzVA8ITGx/MHIMmMMFVDPRGRaBj/TYMswk7w3l9N8nc4ZD8WpT6IFH?=
 =?us-ascii?Q?pYzHEQAxjESBD6axChT5Bq5zIha9MA6fo4F3iAkxmkEx9lx5fsbyaEgkOrrc?=
 =?us-ascii?Q?ojen2i4Is4HXLA4Vo/dNADRa6n7FU8toXgob+P5gy62OW5LYadCyi/nLFLoA?=
 =?us-ascii?Q?sfgVhBn68AUE2CuxbPsA/Mn9m4wzZmUt8ZmpFdzoBZfey2b8dGGRX+XDa8lb?=
 =?us-ascii?Q?0VCPFRdxgs3n9obSuFJ8MRbN1JLcPjYXLhmxS/HNf802r2IdTcQjguybBikT?=
 =?us-ascii?Q?eT0XdMN+Bgz02gt+xuULxI3ji9JdTjX66K5zY5Aihr+XA7aEQFFfaEFmxNkf?=
 =?us-ascii?Q?2E013lFTMUVlOJFqzcHd4Wk7owMsAsL/03byDE/kOF92m/vREBEFjGciwny8?=
 =?us-ascii?Q?opf5fjVWwH8xjOqyD0qIy4lPkK9eMgeOhtjqToGJraV7WnQhaX78zlVHXXY5?=
 =?us-ascii?Q?ycA/WoBU3ZauqEefu5AWwBzEeDB4Kk0Q7I34rW0Pu2nZFv8yjEvRwdQSRlVA?=
 =?us-ascii?Q?pmEwVTEfRIezQEzkUmbOe3G0lZuPHjHqhh2vKpwdaxOln1A52UYjGtobX5TB?=
 =?us-ascii?Q?UD4V/yA2CCD9USpMCFl84PqVZKeWKTzEQWa/e5MohXOuNoTkj68T/jENr3YV?=
 =?us-ascii?Q?B96Jb4lon4jXaaQWfLKKFQmpydKpF7V5kKkLaN1/r2DNNgBcsjmT++pyQlrE?=
 =?us-ascii?Q?CqVOqgXDv71WLNpbGV0n/cilTIzZkR8nOn/vSacTHUhAesoNHnmDC3sreVJm?=
 =?us-ascii?Q?FJJn92RpqKOfc1cYEpAqIEtA4Z6XkGzAx3PI4KL0zMIRJu7NH/t6AQDWb4Xj?=
 =?us-ascii?Q?kmTkJbVG0dZ8y4WG1/N4nZBUqiTUSZc8AcMY9Sx0ohnYSvhVCS1TcrYFzqSX?=
 =?us-ascii?Q?xFHizvGDzVV8AGz59rDn3bganjxbFjijYg2T5YzuOIMYwvp7u5dfItTCGOk9?=
 =?us-ascii?Q?skXHuOX+zS89KzcYtaEaV6NedoGOJn5yHHx5tjqX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dd81da6-4059-44f4-1d1f-08ddaa7f3cdc
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 13:36:01.8565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cIgXL3BkUTOB5VYhBGGim4aBccr28RWYZ2b85gOZ5RzLuekuawmb8e5itDf4FYoA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6701

On Mon, Jun 09, 2025 at 10:13:25AM -0700, Nicolin Chen wrote:
> The core code can always get the ictx pointer via vdev->viommu->ictx, thus
> drop this unused one.
> 
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/iommufd/iommufd_private.h | 1 -
>  1 file changed, 1 deletion(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
