Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43DF38A9DA
	for <patches@lists.linux.dev>; Thu, 22 Jan 2026 19:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769109316; cv=fail; b=FZl2ymhmr9WPEpUzInPTxpkGf3cog76Sbquo08PwOPDeSyKCjADYnpSeaDvjQtiCHy4rBsWKnImg0vnTJBsEa5uak9Y1TLzZk6kTDmRF+2EFP+oaaco4SE5kNK+epwIzi6Pglrfr3AsPr+UwMEN4v0oOYmNGPhJfgCrc493ZwOM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769109316; c=relaxed/simple;
	bh=jO2aNPUqZYSSDzgjmseOSScj//KOnCinpVIkU+oV8PM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pQZRsk191wHHJZvsfakH9LClsTum7N5Hy/2GL34Jzv9d6sMYrqEC4pK/95Gy5vPoaK2ro8iYft7Xz7BLGjQnUVNETTLJpjtmrrdOx6dfKNMV7cOcMkpyinVlFewVKBPKeDxHnhEPAgGwSc6m/ALvGzRQ4sH4RSnP+SKQsgSY4I4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Tx2DGCNz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nnUaQHKG; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Tx2DGCNz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nnUaQHKG"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60MDgJnX596107;
	Thu, 22 Jan 2026 19:14:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=AfB5lrVZ89AMfs4/82
	hv5arp1b2iOkMNFNcjBikjng8=; b=Tx2DGCNze8XZEzMaEEK90ZYNp4VR7u2t2O
	J8b5goaeMQ0ZZfQxaS+FtsasWg6/N6hrlO92Xh1NCl3nUCEsXB/uhG9+CqORa//O
	PUyUn3iSCEjLA7jYxpqKQDetopw8p9rZS9WafAqxoVYY3QLWW6t7LiUewYz7boiP
	Wl+os501kAYRg0CC1FnPkJsTaQ60r/H6m4H1DWzUhZ6be8OBjK/x3oZTNImPUPYM
	Z1FQgmsiJSRitGivoF7QqqnGKB3vSb5JmFwU/e3lwgCezvIkGat0exSUbR8v5fM4
	GqY8dN4iy80fSZIdTWU75/VJrH5QAlPCHZiqs4z8GKNHJKtTXVcA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2a5r8p6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 19:14:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60MHxnok015780;
	Thu, 22 Jan 2026 19:14:16 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012042.outbound.protection.outlook.com [40.107.200.42])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vdb9qp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 19:14:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wAznTWGIidKLPDaCrd57DaTWsstViOn9wC+M1FToO/hoooVHdoaBRX/42H4acObB04bCkfcVo73cNtyH6tXMlG1c4lQFYi7oMLuT4tNMM8K748WuUqQZAfi6kjQrYsUbz1mPb5EhBRl/rF4d4QroSnkxpNO3/tJXbzyJPirnAVYczK4YxFE4N5P/5215Ilkt7l/q7P2OTkcsIQ/pM+tlA8S/0OdBv95wrtUu8KJCe9SntjZoG0vRj7i4wauhZqLclBeRXCIGzhsyCMI779J/W0BOqjAYS/IzO/bsANSQbnuJZ8vupPUT1pzwZc7H/d7CYoNF8E5WqRmo+qpyrUVQuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AfB5lrVZ89AMfs4/82hv5arp1b2iOkMNFNcjBikjng8=;
 b=b4k4A4Dcb2zcQz/ii/RPsy3R/Jdume8IIHvgjMtYud8WPnhAk1as1i0BRtl5pw/3BWVUoM5lwmyWOL7apM1fpUDGAC6CcaLzLiER6hd8J0ZIOj0k6Ly/OIqEB+ak1tOnd90aRofazDQnYP8YOVGsOYsFVojLcu9H0dOqQcrvtAKw7ApM/dNgSGSzM1RVpSlvcfhtbV4zdLeu1rfsupbkKVK6loVmHNF24ZIBmL9tc5ZmrcgA5YZUuavVq4s1X7D9MFADL2YPOPmK6AGB2grKsIrPWAvObmAg0ZMaodJ1UOuAGrFfbiSikzUlGmVkR0r4IWYw4t8jmMIcEZhWF4mCKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AfB5lrVZ89AMfs4/82hv5arp1b2iOkMNFNcjBikjng8=;
 b=nnUaQHKG6FROjuaAoi284yjh9Yx9BA2BP/sRnkxulXzEh6l5r4M/TCAKejuujR+hmJ+Wj1ZkcGtuy35X6klwY/YKdl+T5yB7MsiFXV5UFGsD03KYFxd40yLQLHHhvhWDJw5QWek6A9Abdu0B3JQEORyVvjaMI9jdobmprHMRc74=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by LV3PR10MB7842.namprd10.prod.outlook.com (2603:10b6:408:1b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Thu, 22 Jan
 2026 19:14:10 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 22 Jan 2026
 19:14:10 +0000
Date: Thu, 22 Jan 2026 19:14:13 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Mark Brown <broonie@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, achill@achill.org,
        sr@sladewatkins.com, Ryan.Roberts@arm.com
Subject: Re: [PATCH 6.18 000/198] 6.18.7-rc1 review
Message-ID: <da982b61-c8b8-46f5-877e-d72a21ea031c@lucifer.local>
References: <20260121181418.537774329@linuxfoundation.org>
 <392ccce0-4042-47ac-abdd-d1ed830ea27d@sirena.org.uk>
 <930ac4d6-eb13-49d4-80a0-645c4cf19767@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <930ac4d6-eb13-49d4-80a0-645c4cf19767@lucifer.local>
X-ClientProxiedBy: LO4P265CA0323.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:390::11) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|LV3PR10MB7842:EE_
X-MS-Office365-Filtering-Correlation-Id: 2815e3d3-8ad2-4288-a5be-08de59ea6bd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?L2ww/7LArNFXplvFaycivh2D8Cx5dsw89BUv8N9tTo020n5INXzGoYnh/R0Z?=
 =?us-ascii?Q?xRFQQqydeL+FRreMtcdCLvWjakZBKRDuEXVkTRqBd7sM/vV4mVU756vGJD62?=
 =?us-ascii?Q?6nn4aN9yc6jBFUZwLDvEjohq7QMnz+YEN8Qlq8bgv4SVY452CBCG9Q2jfq2P?=
 =?us-ascii?Q?vZQqLsahatYHyQFEuwIo80V7R3b3JW8hfqNJJXdsAUvp1QYWr+Hv+cvKKn3K?=
 =?us-ascii?Q?NMBU2dxf3azqHyCsJqOlxjs/7JAh/81rdRqTrad2eZLRX7CXbT/EaBao2efH?=
 =?us-ascii?Q?TzezVEgeowdDkCEDqK9tIm5Kb1i9ncp/ct107kPYIZb89VH5yGrfOs1VvRhW?=
 =?us-ascii?Q?hpkigqMuZoDNLmptOmVxIeqcbHog/FvVBXUvki2GZIQ4zZmXae5Pkb7ylMNn?=
 =?us-ascii?Q?AuPQQhs+bCw7P7gayMpXgCxw+cOMOELvkXck2O0zu/g42NCGUb7X9d7stNbR?=
 =?us-ascii?Q?TGxJrlet9HX5TM5etv7XWVNFYC/QLsRm5sq+49fLjA6fQrt1nECj01WUjVH2?=
 =?us-ascii?Q?Vev0oYacM3d9FOKpPqWXtVvVppvA5nVy/ZO3CSdqwmDIuORLGKDyIAqNqjgf?=
 =?us-ascii?Q?N+EydIxEJB7ktCeayjVa2BNSuIkW3yZ3bIPLSoWLDquBrA0yvtDgfmPd6fpI?=
 =?us-ascii?Q?R3iKXhEgOJxbfwE8ftKSWHRA19+YUCO1jRv+ghTKdGJXy14FeczTrUPBIbs2?=
 =?us-ascii?Q?eghR1ZVmz/H5PvZ7f2PBVSizxJ76kMc39C5oskVWnstQYWEgFQKRvbInt+So?=
 =?us-ascii?Q?+ZrlDqyWRx1+zsWIszPP4noxwrTbo8MVP08K7av5/qCM6rMhFPV+JxwwWS+S?=
 =?us-ascii?Q?asZA1NAsYyyx1WQtnQj29kr3cUc3ak67ngUjsjhSo7aJrKwNH6U7f+VxZ0c0?=
 =?us-ascii?Q?oGBrBmEvdZDdBECS0NAizYeS8rwTbYnFG/QZDW4XzC9t3SIZiddh5u1Lt23y?=
 =?us-ascii?Q?YPFfSl2Y43J6ZI3R+xu54AimzEzGruD4NgRVd2VN502XvB+Y45djpIeO6zYm?=
 =?us-ascii?Q?CSFWo3244DQndbxe+uy+vR1QgVaHu32NLHX8aB3q0iGqFDe2hYtVSeUWcLQb?=
 =?us-ascii?Q?w1eCftgy11K67TRyHhVbGnDHNau8x35zjHWJQLDccnlw7i20LBhZRdEtWpwq?=
 =?us-ascii?Q?s/xTMbw2/4YmBeMKJehxfPg7SoZSYvLNUBOaSA3v9vamw3TBli+6VreG6bQW?=
 =?us-ascii?Q?Ms61Ep8o6hS6FSqYeB2Rvxf1lOnUyjx5MlsaSH5vpo8i3yLdbsEWXF6UhZh4?=
 =?us-ascii?Q?Tx9LUf7tBbkv1tiiKcULroGi5stIX/haibgN87/bzchWH6HQHHvuJiDwN5T4?=
 =?us-ascii?Q?UQ/Jiv9Rl5YT2oxlvziL4L5aWX//Vcjm7pGUW9ycFOFll0uL7+JxhGsz+HCE?=
 =?us-ascii?Q?0O9aWlhPXt4bf/z8gGwz/vnAgKW/oiP2Y3OYzCBuxcdSyBTOiTNvNs7zaKUc?=
 =?us-ascii?Q?rncNZh+rSajb0vFaa4/TuOu5KVpdIePTFrIbAbzvA2gjVahXq+dascutREPN?=
 =?us-ascii?Q?yi2SaU9ptbYFpHSwDw7eu+KcoRvgFa/g7wDa2NvJ1B62x7MXcGX+Vl0IL8OM?=
 =?us-ascii?Q?zI9RQZtoMg5Mgzvzxe0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9eq1LWlLCxz4HIuUgR9XtmKWWNSoIpRfs3ioENA2tWBD6ZmfRPsP+MLMv2dX?=
 =?us-ascii?Q?pRzOlmjY4HuDH+mRFFn/ba7C/nIR9AQXRbxdBgfYJ8g4hef4VtVy10bG9h/j?=
 =?us-ascii?Q?h8uENTNf1JhnMb4+O4FGpmD+fPivs9tKauuj7cU9tMloFnmAgCkWQ3GfFz5s?=
 =?us-ascii?Q?buUiDNZFw5A5FgGgnt+ZLfUCFL4E/3UXtJkv04HY7XfxoW9+zCfpr9NlgdHS?=
 =?us-ascii?Q?jUuW2o9m73VyU2OqbgZTEybsPGzMEzNptWOHsJo0RZt4SHsI1kjmuJDm1EFo?=
 =?us-ascii?Q?v+2KJdcKgCrBKyrbYBixea3tign8b6dZgPI1Sc+JnAsgxoAE0tvzawYETCh4?=
 =?us-ascii?Q?dq13PxpQ8qIQZd5hKtIefA2HIjVZ6YS2o69QEb1ysY4WENotQmeN3luGDi54?=
 =?us-ascii?Q?maQq4pmM8AuvXvQZAdxM+fWXMQyAm6u0Skq6Ia5BRGksA8aS4HyBlnSkYRpg?=
 =?us-ascii?Q?xAKNV4gadnjnyL9difmL5cU9lfft1abR6/8GsApOnDftE6WB8wGXt5HU8sZH?=
 =?us-ascii?Q?ik9wUVITkG1+dPL7Fsb+p9MS1lfyfxqXluZbXd4H7ARAkT/ZHUf/7taFcXRS?=
 =?us-ascii?Q?/C5H+0Aym2K38aOawR7yhKgAmLFvredQE4Kz/tdH+BrMaU0keT7GzFjErbHt?=
 =?us-ascii?Q?sjcFn2knp2+25nuKmW2oFa4LEhAxSXjwbM91MKsYu3PL3hGKkPQbkvIn6AT1?=
 =?us-ascii?Q?Pyb0DboOLjFMCZXgR07y6ujbI4MePRQy0kbQJGnTeYkfi+Zd0+r7D8l015Oa?=
 =?us-ascii?Q?22zB+1UBq2WryujHd4gUuMjfp0VEvsIL2fYBnxsRoKGxre8/xQ7O+NdJfpN4?=
 =?us-ascii?Q?58V3Db+hP9KNaNpKMlACIOUmt1EK+Dy8cpBZmuwfVG1772eLuhmYm6Rbiorc?=
 =?us-ascii?Q?3XjRTt3fDyZ7SHVcrnkO5FipZv/dBnte8603fzb2tMmU7jExVnipIT46vHLH?=
 =?us-ascii?Q?awYPW4cHAaA1G3j+HzyDrhB0542cy9+eaehd2w6xPgA2RmkKX4TE4gvr/ATD?=
 =?us-ascii?Q?YBnXPaICWW8ij0Q6o0qhcZO2OZvGRIm2NGBX/nEw2fNmgsZywR1ocetQPazP?=
 =?us-ascii?Q?3eOTKWI/mdYTQQppzFagMqbxMCbExTb5fuTdynPhxBmhWoltd4JMlIAnirPi?=
 =?us-ascii?Q?ZwjeirSm/SS8mUqxrX+gQ3mtq11/+kFkK/AZskExlY7KWBhop9aMe79NNqtn?=
 =?us-ascii?Q?H6nM1m3KlzAtaaCCUF0XnTiH2wZS3ZQrtn94zZw8ubSxEcI/Zsb9msMpI8rj?=
 =?us-ascii?Q?rPfoOLvFEdn/wMB8j5BRwq53AfHnECsHWa/4gjavZpjcaL/WtE38+WQW5yLg?=
 =?us-ascii?Q?gX2VVDghrUVyqQpFMl6Ck1iMRLNEY26HIIPvvIXXE5QjpdKO2IhbJBBlAdJq?=
 =?us-ascii?Q?umzAWTFYmuurJgTe/WIrnk0aCqyNeohrwRLUkTU37Loa+ygCY3dUq9OpRTTC?=
 =?us-ascii?Q?sytm4ZO0gMJihAC+iwwla6zdiuRHyoxrPe9OPlOjGfxMAwa/76w0OnNhQbgd?=
 =?us-ascii?Q?3lyS8ZU2aGVYsIJWg6Q0qmD/dKpXkCzfd7wmqwbGdEQZMox9d03W0wQsHUd/?=
 =?us-ascii?Q?J3DYMroUpnGZi2UkYxs7jHpmjpDA2xKRDLDFNYY2vbbkRbu144nmF+A7wQO0?=
 =?us-ascii?Q?GugfCi4zUuFqm4uQfpQEbp88Z/7H9TsHRPEjOrm8YrY8trSY72a9NpcbBOBr?=
 =?us-ascii?Q?FZF9EgfygxPBUJJOc3EUM9KSqPmYIBlsKVEG035fTice7ScXkelfgbjd/V/A?=
 =?us-ascii?Q?psy0sY5G2PaipbcWIeDqzbCubbA2LmE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5ppV0YqUFdJC2+bRswI3rVrhnw85mut0vlYnFx3rvM3aTikwryts40PWVbkh461IyamNUcATNtuN0F1cdakLgVN7uTo/jPNRcnB421ycMhZA6qxi8eVif25YJl2thzxyf0DJcsDZ1Wf523t8BRsMnrlry0oawA+s+lTiQv91m60OnUPlcXdsuk6Ho0rr3hSPTs6nk97zfnG0XvEw0Cflb+7m5k9huOvXHxyzLoZOjqffh4JaGtdWv66LHs8S9Aa/zq60Odc4LIGkxWigILlZvg9JGzKMTF+fL3QsjPREdDZgsR5Yq3pv8kVmYrOSHmsqd+t0UCxxmMXuzUH2/q3xofeqz7IVcFeRQjnCJvQX0b3eGaWIq++sO0WI8QGyiJkpJ6vC7vh1mKt8EwyXVc5d1pXXKXtDmtITl4PdAN/vp03CAHzmrLTY8pPZu+ltFWjzZTgVaazVTQHKVEkeXY9iijn10h1BKylwsZ5r0JVnzIettxik6O9vljcYdgSk0FGP8o3pdrA3/iBUAXj8LLHm7/E/UBd9evNaF/ReZIZZQ6Sr55yXCwDCPzz6iDf6dUS6sCggLvxXT+OdYr7GUXIuDy/umFNZZ6UzPFRynFVUelM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2815e3d3-8ad2-4288-a5be-08de59ea6bd6
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 19:14:10.0477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gv9KlNDhMPU0BPJamqO1kwznNm0gcZ4Xy4CRmjxquihIF0/YucpFCdwcG9gb0+UEjVLqBNUAcMEic2KzvfnQGuz7NR6/tZl8howqGGhB4n8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7842
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_03,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220147
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDE0NyBTYWx0ZWRfXzt++XePzMK7Z
 pbfIsyUikgwYTuRcfd+nd0K/nBx45zGrhRTsQKqvWqH+atyIv6ItOL0Qwb1BCCANHziMk1bPh/y
 J+amTpOFGiyTfw+gJjCEbdtQ9d0ybds5+T7v6BAv/52t4LBX7e1QAX3QBt0HZShhWQ0fQxajE+L
 vuzB6+SnW/paMG66NC+NnsZjywpDMLN3p9SYS+0oz3PZF+tTqhM4gtGkKUGr7mPnxkXd3X83KOL
 28gNHS/ggw2v3c2F3rziutRVsub/F+DVjS+2C+/eGkQSINRR1oVjNNaH9KX/YdkECoqLbYdtKLg
 0oUs7SuIKTR+az1vhFvaUOjMUqXRpwcFf9agambSu8xYypVD6hAtMCD/TIT4/hS9VHeWPBr93wt
 cgJxCax2hTGVQgAI925WtQcUrh3L5TQHk9nehsfA6xJ07ySNP40lhrkb3YEy/HqY9kk0e1NmQA1
 sZUQRYsuqu0hlzN/XCA==
X-Proofpoint-GUID: LsIi9xAG7OeDxYx3PXPJMs9dPjEy7S8L
X-Authority-Analysis: v=2.4 cv=XK49iAhE c=1 sm=1 tr=0 ts=69727709 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=vaMIbXvg1ei7AWf1-zsA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: LsIi9xAG7OeDxYx3PXPJMs9dPjEy7S8L

On Thu, Jan 22, 2026 at 06:23:25PM +0000, Lorenzo Stoakes wrote:
> On Thu, Jan 22, 2026 at 06:15:12PM +0000, Mark Brown wrote:
> > On Wed, Jan 21, 2026 at 07:13:48PM +0100, Greg Kroah-Hartman wrote:
> >
> > > This is the start of the stable review cycle for the 6.18.7 release.
> > > There are 198 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> >
> > Tested-by: Mark Brown <broonie@kernel.org>
> >
> > However:
> >
> > > Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > >     tools/testing/selftests: add forked (un)/faulted VMA merge tests
> >
> > These are failing for me on arm64 and I think arm (something literally
> > exploded in my lab so the arm bisect didn't complete yet due to the
> > half of the lab with that board being powered off until I get that
> > fixed), that in turn causes a new top level failure of the merge
> > selftest program but the actual failure is purely newly added tests not
> > working so I don't think the kernel itself is any worse than it was
> > before.  The tests are OK in Linus' tree so we are I guess missing a
> > backport?
>
> Yeah, I wouldn't recommend running these tests as they repro the the bug that
> the backport fixes :)
>
> You may experience instability as a result of that.
>
> I'm fixing the failed backport to 6.18.y literally right now, should have it out
> soon.
>
> I guess maybe I should have put a 'please do not take this until previous patch
> was taken' note in there, but ther we go.
>
> Cheers, Lorenzo

FYI the fixes are now sent to stable at
https://lore.kernel.org/stable/f1e305c89aaf15fc62c6160505eb6d19adf5d49b.1769108022.git.lorenzo.stoakes@oracle.com/

Cheers, Lorenzo
