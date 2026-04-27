Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010045.outbound.protection.outlook.com [52.101.61.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F56D21CA02
	for <patches@lists.linux.dev>; Mon, 27 Apr 2026 23:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777331723; cv=fail; b=osAl+ZzWVkvMt/Z2JYvn1aDoKoJqiBZg7m0MwvEKGl9QL1nwD5MMA3QxRS4rdTsQ3oolPcGgCeWef5alhh+OpYtD5BiX23hgWWgIW4tK4jpOUKuEdYDtdP/CG2zMn8yNZMyZZDfuahI8I1Uh34/5yFb9o1md+WWVV5izvQmBIQw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777331723; c=relaxed/simple;
	bh=qn6qvIUcCbGV4F5CJob9xOkhpXcDz/LrqGG+qjNAYbY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pAbrX5o/5fhgy3zwbr72XsxCTPOnJHfvl0HLQcJZ9y3L2JxI9/ScwBqeJqDFjVzoqOCtl7cogaN1HlDZwjLCYBOxMZxYNsyEujpKIsAUAMDbjRA8XX32C//uuLvupYWaK5Yqj5lLDKL4zgLpvPXQvxgL2tkq6G97YIc/G/SiOJU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=n4oeEcM4; arc=fail smtp.client-ip=52.101.61.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="n4oeEcM4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AH/wMJSk+QDvbdd3v2fEQVodQq61AaeIOEhO7SzkZ/OLRmjjeV58sSA5hSmtzJXHmHE7+eN106J6UT3/oF6vcHygS+JYAgTtsEBOzEMFtUhufYCUVxfDmU3Pg97K0EHJAirgaj4fDpSw/LnoUo7KwLLtFozXVVvfbrWhQh8uXS+rdHEdf5hp1vUhm2yYy0zstlx4ZpCmOmJMEu5eCgfGDX925Jx+lZueYnWbjd/1r5YtCAf2DFs3Bw9JXIGIMtR7zQPftqdJ+UccZZrvZkwHvSaKObFxa9qSc+Hja7whwMolvuUwC37fhp/DO/MGb667NtFzffXrvkXbOaUVGFhKhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RenowAqJFPR+yq24Bzl5sqWfaE2r5xr3Sv7yjy7JGYU=;
 b=AcuQJ/3UtcAIotJYrcyGULBnRn4J/2/a6IeMRmb915wQwAhfFEom79qxrpb+QOyzC0wuuefEhlrmK9NZS7gxXME7IXWP0UUGhozErlZ5odqKy7R3TOtEHdI+jnsdII2/EIOUnTOza92UpD7qzlhFrh/LYLHEfQH+eZdRz3KKT7UC2OxqPVFbn8pg8MDTkUM9LNBT2gGpOc+5b6OycJ4KCzMHH582uD96w69VsdhV6263EWvxZjAUFimbuUtkxgXo5mT2xfkN8C+RGH+U0Jxn/0ahTIldNGMYE9B5H9QT9Vjr3gYN9ivkktg037eCiNqP2dP7SyKSsGXdmytR/7gcVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RenowAqJFPR+yq24Bzl5sqWfaE2r5xr3Sv7yjy7JGYU=;
 b=n4oeEcM4y3OU/5JerFL57hihLNBHLU6zlpDKLkIcAaCDGtPIKrin/do9jNmyebJcuqMeHDmJZaY+df1/VAUBbWy8i5zPIqlmkezGUNMGkD/5w5yfHRkuGQwYmm1UqiFBcYz0c93gNpm2RIMrt32AJ11OTJCxz1vb44q0xK2aJ1g5v69zDpI4MGuB1fVwEAOkRNfKpUMnb1hDk8srglZ7LKyL4B7GhS7T8cMRdhPVcRwMC60wxSdS/qiUd3fXOoY2QXtTlUiWhEIgIfCD+pZHDuM7QNBtohMmkuCYO/FyFkSI7O2r/sd6mDkwopkU25y0pJ8CZacjqzYbtYPCli2chQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA3PR12MB9108.namprd12.prod.outlook.com (2603:10b6:806:37d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.22; Mon, 27 Apr
 2026 23:15:18 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9870.013; Mon, 27 Apr 2026
 23:15:18 +0000
Date: Mon, 27 Apr 2026 20:15:17 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Shuah Khan <shuah@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	David Matlack <dmatlack@google.com>, patches@lists.linux.dev,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH] vfio: selftests: Fix out-of-tree build with make O=
Message-ID: <20260427231517.GA1676350@nvidia.com>
References: <0-v1-79f29139180b+8e-vfio_st_make_o_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-79f29139180b+8e-vfio_st_make_o_jgg@nvidia.com>
X-ClientProxiedBy: YT4PR01CA0405.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:108::18) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA3PR12MB9108:EE_
X-MS-Office365-Filtering-Correlation-Id: f8c6b1a4-fe84-4ba3-d5e1-08dea4b2d8f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	a6zm+VVF8wyABFrccFTdSQdMTXBjdj21SUv/deD9ju+pL90bVZhV48xjSq27xY+83F7YOALZNLomtQym5jg65hqKvDJECEMR3r0R/vTWojzHkPhSy2PXgOzt8GBiNP5cxxeqDFmRreLJuSVudXDAGn+XdR63a9NWq/TPvTNxYKoJAqgFwpM1L7DuCXJVe/yzu9BYB+h5KbequpChfbQlRKArW/lMolufHinNBYs/6ofrxyhTMzIjgEr+SpW8VeGk6u0CdvF32qIQpAGhaD7MbwwVPc0pOD34zNauZYga4ef9hOnkRQcQp4t8wqrdgTxTzXlRXViHUdfIofmTSKKoLOB4Mc/PZfDqqtg77G9KviZa395Sut7D9kTuD96sBrAaSOexhhLxZvyKLR+jy0n0OYLRC4tBpcnTCodDgYcayJArcLrjGtOEoTWEIOYyhZJDwSBUAYB1D0h+fNvbzhSRQg5znq4Gphx4qIykmGm/ofMJBMNbkuWGOrZE45HJkC3KxsvIKiJKjmMv+aFadnNPMgE511rkGcLCWMscBtjq1READF3V/iWMoOxSzM8R4hoLqAHI2hIinsexNkjq2fTSElBiSfEArSfhw9YYA8CcK9u18oDziptC/BsxDwQXXpbuqnVoSpQTjQgm/VM70CpOWEm/vIFkaXltWe1kKLyVCVE3hJXqf3ef727SQdMJ98M1jq2S5/GckPdIjz+QrP/eI4B/t6VvcMJ4Pwb4Sn+nsVs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zMZPl1yREktuUG9ALg3B95wYL7PtLTA7BxLE1VhBbWC79CQGUHsp/uUTZcXb?=
 =?us-ascii?Q?U/g/IEDCiBIkZDPdy+ndCoYYhJo5VV7Ak+s/mb2l3b2zwIxb9zXQgP6t6+qU?=
 =?us-ascii?Q?FirgqKYeHDxVNME0xkchi3nMtZ2jVH9vwVxgPLIVmtgb9c+mksn1k+U98aO7?=
 =?us-ascii?Q?lJawySGe8b2pKTyh1kYxRs00yz/ljEWaTJyggipOKIIqLC1nZrlxfP7LZJdH?=
 =?us-ascii?Q?opmwQ1zSJWeR9VttDfFmcZJIepJHkyIjJEZGgM33xfdex4RKG+zlIPPBsIHS?=
 =?us-ascii?Q?tkHalKZ0A8j1PVs0lAbY1iZ9OKortHzSNHXEe8p1yfnXZxHapIk/bot6Nsdm?=
 =?us-ascii?Q?kp3V9gwaLIxJTOL06sc1QG57fYvh+LJKseVBN0q3ntGRlYjKsRi0gRxjDa3v?=
 =?us-ascii?Q?+awQfxHcmnqa5iwLoWpfRBIrIRkykeRXSuDmQrXrjy13/NdIQeUbC+5L1Wko?=
 =?us-ascii?Q?foxLmeVKBXC9YFwlB89JcBis+f+ezPArxiVhrwUABtzBFbQGctVLtvSoA9tN?=
 =?us-ascii?Q?b/ltBpYPJRx/2okDR68aYZkd22ImpaoQ7+olM2nvLA2+Lz1gimoMKR2yDCBg?=
 =?us-ascii?Q?wP0elo8jW0Y8hl1AaW2UY7kFNC9fQyvuTKNTcGDbwTnoSI9xuVO623Mv7vsI?=
 =?us-ascii?Q?+zTrBJKCZPWy5Iy2p5MK8x9CcFjcIYZXbndL8nZIY/pQP6qavYC1JCYALJgU?=
 =?us-ascii?Q?37hTftL2JUpbG39Udfube1jy98lV9qR/J/ZJ8qbYDiOGnS+hqWeJPoz2+ns6?=
 =?us-ascii?Q?mW7GZaf40JfiwBkOCj+5WTGFNP5GXJIUn6QwfVc5SL5WBl64gV56wZZtB2fk?=
 =?us-ascii?Q?Sq5mjLecyWdEUDlFS6NJZTxJspCRdwv4pyFpVX9YJ/GHejG78g6DE3/irfUW?=
 =?us-ascii?Q?AcflDkvQh96vcFcEPRPrOweuC9WPOM7ExhjBZonzzdrjrsBOjkaCqP5oiGQX?=
 =?us-ascii?Q?zm08NrCTsGvVvGscBbo/dGxFdL4texcsMvvx4Ec2eRDwahxz3MwiM/ORD88p?=
 =?us-ascii?Q?voH5H7xKA4dLvFlYkS7Abiher1pGt/vowDVOgDmtYi3/332yGZBMqX18rwuX?=
 =?us-ascii?Q?coLUJOhU61BAdfbWCPS9V/RmyszVkCrUQlUHVDQU+vPkJmqqY44L7M4qroW6?=
 =?us-ascii?Q?TlbfszfI68JdFin6R2ewNbTaoRDrxDZLhAjrTONX7E5aL6kiuRHQGXmEor/H?=
 =?us-ascii?Q?7NsQkSzFS3jYHF83KeTJNW3CpuC8acGZl59bDTmu5P5pDbmfRIjULZrJNpLT?=
 =?us-ascii?Q?voMZlNvXcROJrC88wXerurZWFghCWD+Xtmi4iSn6gU7gUg6ph+vxJk9jbkic?=
 =?us-ascii?Q?wXX5+jYOFXsq/gJTyR7h6EFr7szekeggYLn3tZe620z6Ro3HIusvAsZYPPcI?=
 =?us-ascii?Q?iIQX1ntCuTnSW22EH7y/PJgPUo4Qy3EKgVjGMgajeJT2me22CrUvqZm6F6iy?=
 =?us-ascii?Q?XlWVf4xYXa0lwjB8K+BEsbstJsAx7Igd7sSoez/mCSUDfG8bboS7SFrR3PPT?=
 =?us-ascii?Q?KZl0e1JV/pRSuYdj+ebb5iLA67o6DsPPSQpFUKloG9wbNXsxmLKWIskzzBmF?=
 =?us-ascii?Q?8mdCDN5b6vw1kEKRrEy1FhsnnVFY7ygOw0Bczs++SuHCCSJ6DzyVLhk8Tp3r?=
 =?us-ascii?Q?5atmEbrSkRNrRQryYv/7iBRvFtoos6KzIm/ToLbVxZGHSUeKDUlBOjhHJpfb?=
 =?us-ascii?Q?A3wvwUWCIpUD6x6JZWpa9GWJhAt/Cs4qEGeCvvCAlGUVV4sE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8c6b1a4-fe84-4ba3-d5e1-08dea4b2d8f3
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 23:15:18.5619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 28vdmKelzNbV4J/OJm2Ys40FR8Zlf30eyqIpWqimX1AAMHSGtbpUBGg7jFGN+d0/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9108

On Mon, Apr 27, 2026 at 08:07:37PM -0300, Jason Gunthorpe wrote:
> -$(TEST_GEN_PROGS): %: %.o $(LIBVFIO_O)
> +$(TEST_GEN_PROGS): $(OUTPUT)/%: %(OUTPUT)/%.o $(LIBVFIO_O)

I grabbed the wrong version of this, it should be:
                                  v
 +$(TEST_GEN_PROGS): $(OUTPUT)/%: $(OUTPUT)/%.o $(LIBVFIO_O)

Sorry,
Jason
