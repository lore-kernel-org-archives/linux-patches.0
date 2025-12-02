Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352881F936
	for <patches@lists.linux.dev>; Tue,  2 Dec 2025 13:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764681066; cv=fail; b=i4e41dUR+UJolrGkISIW8jXuCLC237IBA1cCqktpLWiU2390ORtX7xWXQqkvwveNCkOTdr+UVkbK0bC4FADAWbdX2cJa+KZVaF8sI/iIPxLTuJN/HIIO4Hnuzm5A0WLDQhvz3XAkEuKZTHSy2sUM8sjj4bhJ34iYz32/cdsG9kU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764681066; c=relaxed/simple;
	bh=z8g9/VMzRYZcI0iURw8NQ1b7lee+/eNESMVC9a1CZVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pmwGCL2U8saXHwrqYi6Zwyug/+SRJfT7CAbmvbGD7h4D7r31Xas8kOsSIe5Ja5h3mK/NHlD/UAtJvdCoa2Gtfw5Qzk+ExxxsM3ULPWmzjKRpjdmZnNeuWNfnFrQ1YvUkHLf2aEhjI11udUC4mAgTA0bIJQ7s4mMwFjI3VHfFyUk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BBEF1PUt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JBMxP+Ia; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BBEF1PUt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JBMxP+Ia"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B2BvFps304898;
	Tue, 2 Dec 2025 13:10:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=pxrtdJu4JwTvN7WuGn
	iPLIT2l+YXywXZV5q0gPEmOAQ=; b=BBEF1PUtxXMQ6OPmEiYgAawSJgxVI/H8dI
	Kl0Ru0qJTJe6gNq8vDpd5A7aBRXRBWf9UaKH+dkhebkc6eg6ngJ/oxtZwLjLRgKM
	E5Lt+m5teTI9oYAdshbIB6bkADG7ObeB0mk9xOL/2PtWHOgAt+Tz6VvMxVYn2pYi
	b7Nq0nBJuRHmj5ResslIhS+Us2ReXOMKMJgso1+vcrL08W6W44T3FI9Wkd5MttBr
	5Hp3xL3umvrjxix49zrW0vbRa1oECG1ou0+bAN/A1hfrKQqBgIm3E/GrM8sJvDSa
	VXpzFKKF01T1OX+NC57ENFYU3eNHWEKt/GuZ0l8ZrpfvyGvRDsxg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aqrvc50qc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Dec 2025 13:10:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B2BAsHD012040;
	Tue, 2 Dec 2025 13:10:39 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013034.outbound.protection.outlook.com [40.93.196.34])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq9kb8e7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Dec 2025 13:10:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cGvGwNyildyZ24I+hycCqItCC/kKfXgICSHSCM95BHctbvPxXqKcA95Xp7hQCWto72X/ToNkgZbbCkNT43ag5BTg+qnvpnPUvuwxGywpWCgrYRHSoQfqKznIGnNzEM1M0DSdXf4IGNWbSDEOoRr5BMcWcqbfdc+VxTq+obk7tdwokf6WRejCT9ZeSzQzElJPmF84qz6vjWol2gjpsqkd59trXishmysPijSczd6GQMQgECW8nRMxWS6U5jjo+XcDpDMR49u5HiVeJbAVnIPKgDJASqm05vMrjcJKhni+ce4EGz/rg/ryswjvGuoA/2JcIKwAFZR3tEHA58sa+cFHhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pxrtdJu4JwTvN7WuGniPLIT2l+YXywXZV5q0gPEmOAQ=;
 b=O1WDnv1At0U1KKBjoTgHMDC324bXmi/14atA1sxPyho8S1g1RA4IwQoCXtNdAE5I0IANs4+JwcNE1eruWhdB+6LKja7EQ4kWwIZDqpF3ShWn7shtMzzk1UhPxchcYa+u7ZWPBFsnX+mcs8eLbw634cFhzzOt45cCJUoEXumJm6wFl1Lr3iRMN68OyLJWc2naSdtyeZxoT3hlOqUCQjzPrOMS4ht8Mb5pNEZLmC8dUZU0DRPTz9joeWzHjr6pXV1efVmUkdKL1cpsnAa26zEm856stYoTXjiX2h/vjvhRDaB+hHbNfpFzs5qlA7g5XiU+7vyQldDOlk9CQzd8GeSvgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pxrtdJu4JwTvN7WuGniPLIT2l+YXywXZV5q0gPEmOAQ=;
 b=JBMxP+Ia9Bzsw+tFtuwIL2hydJ23aSQ5FPVKcquAml63VI5BPqs7gsvCZPELUma4FobokIqlQSL4GmkqquSgWk51ZngqjPW3lm8GLY8UWz51MZq5SIDAIsiL5ouEO8TQHZMpKApSYiIe373JmG6sWo1Um2vVtn5aTPHSdSc++Tg=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB4614.namprd10.prod.outlook.com (2603:10b6:510:42::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 13:10:35 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%6]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 13:10:35 +0000
Date: Tue, 2 Dec 2025 22:10:21 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com,
        Ben Copeland <benjamin.copeland@linaro.org>,
        Dan Carpenter <dan.carpenter@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Hugh Dickins <hughd@google.com>,
        Sasha Levin <sashal@kernel.org>, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH 5.4 000/184] 5.4.302-rc2 review
Message-ID: <aS7lPZPYuChOTdXU@hyeyoo>
References: <20251202095448.089783651@linuxfoundation.org>
 <CA+G9fYvF3cGqi_McG1AtfkMgd5EB_=nmcwiJAGFjZReP8dGKxg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvF3cGqi_McG1AtfkMgd5EB_=nmcwiJAGFjZReP8dGKxg@mail.gmail.com>
X-ClientProxiedBy: SL2PR04CA0008.apcprd04.prod.outlook.com
 (2603:1096:100:2d::20) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB4614:EE_
X-MS-Office365-Filtering-Correlation-Id: f9d47ca1-3ce5-4c3d-0074-08de31a42de0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fGbWlXbk6uhhz8Kbyr3ev+8E3id3NO797WQyCkxGYyzyYg5ya+IlxTMDxDPf?=
 =?us-ascii?Q?eHXRCsPz8PQpgBjIvz4REOaUeRp084O3lreAPqnD0SEsFMpk4ev5x0geM+w/?=
 =?us-ascii?Q?7qaRJWoT5Xy1KNEtDazvQZ8VA5kddsEM69oLIPjK0ryUs8GsSIQeqGi75USv?=
 =?us-ascii?Q?MaFLWw134qZaHdUkGvnDnlVWNYFB+QtUq5dNmijnpHv5S5Q6LcnL0vR5b8Il?=
 =?us-ascii?Q?ip0B5uYACv6BVxjUCn1yaTfgpgxNEwM3WcNhiiY5vh/7votp/m+EmuHLfgdk?=
 =?us-ascii?Q?5qkVTRIigyDfDw4iNR+CJtBbjz74hJ2RFL6wiWUrLvvnthLhmoANOsRXbLaG?=
 =?us-ascii?Q?JgQtkU01DrR2qU1YHWVAJRvLM5niw+dtlAXwaLTD4Er+dr7WEdJUu6BIoc9J?=
 =?us-ascii?Q?JvhSnwNGn9hshvAyIM0H3KFYP9l/3XhKn6qUrYGAgAXwG/w/0K68Zl5m/3pE?=
 =?us-ascii?Q?IY+wDhPg4SUtkNs/BpVKStcoCWFne3m7Z8bkvb7eYZkwUzXBeufXZ4lNi0QI?=
 =?us-ascii?Q?W7lgNZLkS78ppKgyxtGSbMTGWyBfocu21IeYzUPgAGv486+nYuBnLZ3la+/4?=
 =?us-ascii?Q?dfRy8ehahJ+gq8dLV/GReP3Vw8k44GGA9UCM1e8Is1Qoozsiy7r3gux6qxMz?=
 =?us-ascii?Q?Q3yyLErxZWR3Zjo+YvU282zF/VIOmxUkOYu7b9KQx2ayKxOIvjK30F2k8dC3?=
 =?us-ascii?Q?T7cj/r9EQkibw3KMS/VrXxutrrKE3/L4P85ByN1fleNTCo+N9GqOmj71DN1I?=
 =?us-ascii?Q?mcTyKXsiPV5KhneqD4upSzp4WtxyL1J9OztlcMWwHqRw0o0VxJgAWFjx+HYW?=
 =?us-ascii?Q?4JBopg8JvM3c9RyMJq1JWHyG1GJMY5H6SdmpzE283AllyETDhs2vMkAl51yu?=
 =?us-ascii?Q?fIInX7IuwmTKgJkpX2GInq0J7RaC1R+kF6QsgR6Oc9mKRoe5NtBBsBw+SdTV?=
 =?us-ascii?Q?s2RvLwN0PIfsPmgUPs3sZkZWEYcPY4FR3rMpl3VlvSHPLV9ndS0xv1MCgnfi?=
 =?us-ascii?Q?8IqdhRioj6wO7qbgqGwNSSW8GU/jcun2SxbShLaqv1DSDdHVDFkcGZiVDvVl?=
 =?us-ascii?Q?KCtN3m+5dzKIRWQFBik00OcwPUoumTpJ7y4pYAwTY2J5p+rkvxRyZwXLd/Vk?=
 =?us-ascii?Q?CD6p3ybdMCYlwjbOON6WqBHKjdX14g130+BizNLP8Exy5fMI57oWyNlaF2W1?=
 =?us-ascii?Q?0R+ZNldol9hEZcLnw615xl5/Bs0AP6sIsZ/zfGA2THTWzvH75ipPAknBwJR9?=
 =?us-ascii?Q?Ug5MEbK9pOLMXcemEXMva2rUh2ErgaVy67HwD93XDZPlDYndrAZvhqOYoxdd?=
 =?us-ascii?Q?vp9fs9TUBscwDB98gnjIWD1LvKC0i+U9Sf8tWijbUEzJQZiuZLL1IUkIdwY8?=
 =?us-ascii?Q?w9r+vVAOEm7/R0xhCv9kO2RhYVya37jAfpFFROcJd1h7n3W3FA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hx9DJGFP9l9xO/8HDtrtv4QJ4tFbkTSCFHGDRC4jTn8YSr0VCYrjkxh9FzNX?=
 =?us-ascii?Q?20nuT76EdBqlKLMKMmvNR0XavNoq/ty4AYVOCj/2e2hdRW5pKAlVD7EfDH59?=
 =?us-ascii?Q?IvVVDW+pICIszlLUTZtc35GHQFD4+yroxaFvh/w65+16RwwVstUlpA6byi6s?=
 =?us-ascii?Q?f7SjF7AXo/o3CBS71aleaD75oXWng7GEx3NEfm/otzH7kTXg21dEh8bbCoIn?=
 =?us-ascii?Q?R8p/6/+NHjl++NmiRqmhzM/D9a7J82SqRgzMAKs1Y0o0FJa7PKHFgkop9nNV?=
 =?us-ascii?Q?/H9BujZllsl9y7UDPfr37vY4es1xdNziSZp9COUc2tzASjEPWNF65VvO8Gsf?=
 =?us-ascii?Q?3+OMdgOCJ4Tykqyj0s8ZtwrwIeq1fApzotPaTsPJqulvqDTBC3Hpkiij/BcY?=
 =?us-ascii?Q?XE6B0z5qqG+M+ri0DgMIi4PL8BS219FKJRnIU217nH3YZ0r2a5uQoQcAbmT1?=
 =?us-ascii?Q?dYLVLRd3Ccp+YtTVZ2XptYVj7EtU8jf0dq9r1V1/bzISPiS8b7uDqquAE/Q1?=
 =?us-ascii?Q?XExyfsleacVBoA6tTVTvEzpxlAfAZIwYeuoSx3drLx8MpS7olqfnKtyl7SYx?=
 =?us-ascii?Q?SzFjggnOJiJQio5J+b8CW1HrVK83GY1MTx3yrehfi6aJgmtM8Lo76It9o3Df?=
 =?us-ascii?Q?fiysKStfu1/dN6ZdClM//ZtUk1d9WKsUNbdR70XVDR4h+Aa7fVs3tkUgXIiX?=
 =?us-ascii?Q?Lo8zKEGCPZwb+aE6QJDEJSPcTdDggSdZg4L2mI6mrBBWWU0Jrln8TTRIqUTC?=
 =?us-ascii?Q?q0iCR7kL/byC4ZBCU16C4I/VBmezFoa0GTQD6jRsdQRb5hVWg0zYzeoQu6Gt?=
 =?us-ascii?Q?dvV0tBnDQj1gbDIuiU4oCDBzM5qfoL0z6Brs3J/HG0wYSIWIe4msDOrGfSvt?=
 =?us-ascii?Q?+hc+gpe1CKLBMXLZ6jgAsEA8bEBJwzuTsJ8igCuCkh2u6Tj9xxApojv/OBWV?=
 =?us-ascii?Q?qefquemALnRrK7aKb442ak7a4KGTZZcIrIJRop1DaKiEzztTlxKY4Oe4bfXn?=
 =?us-ascii?Q?C+uhW0MehcfPnczk8T1skZceCVPqLF3xxfOdWXl1Ag3R9pyckVmX5TUfgafr?=
 =?us-ascii?Q?MybKo7mij4xLNh3VH0HpPnPKG/qs6LoX4vzawHUg57Iqa9tApKqJrrdg9n74?=
 =?us-ascii?Q?OToqQ3dcL+tyZgQTKcnveyYsohdPItbxN63o2zo9Tkebr4xq1hZNbMME1a9l?=
 =?us-ascii?Q?iYFOO3kRaRjzt//TXMzWwqRKPdgKxnWBdXaMccUqWDr/KzTlvBgxMUOi4FGO?=
 =?us-ascii?Q?Ck2UcMfJgEwxG3RszTWwyWALJfbOBoCdQBhpg70wENZrRc/0/gTEQX8PmYjz?=
 =?us-ascii?Q?i6hyDeh3oIVv5dXu1MPyUSpSUNJJZ4+6MV2CFAFMCZiS9vnsLD9Tr/stFHI0?=
 =?us-ascii?Q?F58JqgW7PmD3jbO/LozYJRAJeXmAENPPpKeyBVXUC0zL3k1tDaHFb4OJaZSI?=
 =?us-ascii?Q?FEWh98+AsYQey1PEAlyJnyuPU2rtpaYuW0enxaznEMrWweVzVUhpmuOfoDGJ?=
 =?us-ascii?Q?RvNjK5swIr5xvjiwsN4cpx8rQxwdJBlyKwYEmTlYe64uNedgNV7OM3NWbZgQ?=
 =?us-ascii?Q?Aok0aiCq+eJjaAVf7zLxzw4lsn2G+sno2FLYu+pn?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rZ6Jc1zo2FHFrXIXMfCtZtW45di4QTuAxSUG9tCNWkYGR+xjZxdfCH1Rof+G+n23z8EUFnRh2TsWKP7FpMiDbd4v+jZHlz2Us3GCZsGMIyuEE783mKILc+SDP7RZax277SCHe9vXR70T3ZffOybDP/npNFOMMLC1cWs84P1brRTHmH7i1/laS3VsOYRp39iFFr+VBIFBP5nSeEo98LjUwMBjAV8tC+Yr+YGLFjbQQJYJ9XMmZDIPWgbuJjG0jr+uE8GpeEskhLRZJO6gvk781u4LjAv40n4UHEYBQMU4QpAxqkquTJqxU4PybgI081WAbW7G6xzrLkJTwcwkeU+k5M6hYZXLZ2z06aw3Zl6zC7xzBfLhancN5MtlbuBHdVJ5BAeuIAf6Wcn+qbCkDf134FM5FA6K02KPnWAf42x5JxqLEZPYCO+2TranVVkdjURMBgJafbTZEc18pKHjRBCJ2Q0OjZ+hUP8Bb9WrSdYaJ4Ry75fux5+vc5d1r4KoKsbf6wHkeJz4hKJHdhyaI0HVkp7nK+KpXTm8OyKbljZS6wvIEFOzpqYsV/a7E4X30I3UF8u+YVZgg8+TW1Y7btv7KJJJgN0orjDhSB4vzvt+2eA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9d47ca1-3ce5-4c3d-0074-08de31a42de0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 13:10:35.0333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ii8S6y/xmCFf3pUtQZeI4x1fIkBu4RSMu/fDhYqz/oRi7fbM0+X0STSEXdihhRIjvtsnq9Wz7YeLR6P7jBykyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4614
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-01_01,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2512020106
X-Authority-Analysis: v=2.4 cv=ZeYQ98VA c=1 sm=1 tr=0 ts=692ee550 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=21D8NHQQAAAA:8 a=ag1SF4gXAAAA:8
 a=kZbSFkK53iKZF3mR6t4A:9 a=CjuIK1q_8ugA:10 a=cvBusfyB2V15izCimMoJ:22
 a=aE7_2WBlPvBBVsBbSUWX:22 a=Yupwre4RP9_Eg_Bd0iYG:22 cc=ntf awl=host:12099
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAyMDEwNiBTYWx0ZWRfX6EFZbr/ALPnK
 Xfkad5H0ISH1AgvXhGB2TDXiABmYXgGBGOSiJKX7QPq6b9ZxVCCBYVagi9wJ7ucdLaJBXRl/crK
 eml6MRgBuBiUufy06nxoTEz3TDEuvHhXK62JyIcLMXGgkby8Fj7go68ijyYAKnDfMGaIIUJ5Ba4
 Kgrp0zVSxIxWeq8Enq0mjP2oe/we+3j37ZSYXlTfqYN4IOehxB1qITHN1eOgXX0o2JYAEVdacda
 DXW5x70i//KK9KrqIwEmCKaac0l4Yk1YjM69zdVXctdwg96uPK56em6DpeZQr79l5dknHFjZ8JH
 c/VOG9zgOVsXPN3i/kdTzdi3hfNWdhzRxNqc2sC6OX91Mffj7hnS2xHu7sX6o9hBe0bmwkBgnTE
 X4rwVR1BqVlxAFFV2JglKkg3ourDoXfs04tFC+/F7KLk7GZpetM=
X-Proofpoint-ORIG-GUID: WvLgDEkZq-iTxuzdpeLXOPqcUTfE6Me7
X-Proofpoint-GUID: WvLgDEkZq-iTxuzdpeLXOPqcUTfE6Me7

On Tue, Dec 02, 2025 at 06:02:33PM +0530, Naresh Kamboju wrote:
> On Tue, 2 Dec 2025 at 15:41, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.302 release.
> > There are 184 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 04 Dec 2025 09:54:14 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.302-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> The powerpc builds failed on the stable-rc 5.4.302-rc1 and 5.4.302-rc2.
> 
> * powerpc, build
>   - clang-21-cell_defconfig
>   - clang-nightly-cell_defconfig
>   - gcc-12-cell_defconfig
>   - gcc-12-defconfig
>   - gcc-12-ppc64e_defconfig
>   - gcc-12-ppc6xx_defconfig
>   - gcc-8-cell_defconfig
>   - gcc-8-defconfig
>   - gcc-8-ppc64e_defconfig
>   - gcc-8-ppc6xx_defconfig
> 
> Build regressions: powerpc: mm/mprotect.c:: pgtable.h:971:38: error:
> called object 'pmd_val' is not a function or function pointer
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> The bisection is in progress,
> meanwhile this patch looks to be causing the build failure,
> 
> mm/mprotect: delete pmd_none_or_clear_bad_unless_trans_huge()
> commit 670ddd8cdcbd1d07a4571266ae3517f821728c3a upstream.
> 
> The sequence patch.
> mm/mprotect: use long for page accountings and retval
> commit a79390f5d6a78647fd70856bd42b22d994de0ba2 upstream.
> 
> ### Build error
> In file included from include/linux/bug.h:5,
>                  from include/linux/mmdebug.h:5,
>                  from include/linux/mm.h:9,
>                  from include/linux/pagewalk.h:5,
>                  from mm/mprotect.c:12:
> mm/mprotect.c: In function 'change_pte_range':
> arch/powerpc/include/asm/book3s/64/pgtable.h:971:38: error: called
> object 'pmd_val' is not a function or function pointer
>   971 | #define pmd_page_vaddr(pmd)     __va(pmd_val(pmd) & ~PMD_MASKED_BITS)
>       |                                      ^~~~~~~
> arch/powerpc/include/asm/bug.h:91:32: note: in definition of macro 'WARN_ON'
>    91 |         int __ret_warn_on = !!(x);                              \
>       |                                ^
> arch/powerpc/include/asm/page.h:229:9: note: in expansion of macro
> 'VIRTUAL_WARN_ON'
>   229 |         VIRTUAL_WARN_ON((unsigned long)(x) >= PAGE_OFFSET);
>          \
>       |         ^~~~~~~~~~~~~~~
> arch/powerpc/include/asm/book3s/64/pgtable.h:971:33: note: in
> expansion of macro '__va'
>   971 | #define pmd_page_vaddr(pmd)     __va(pmd_val(pmd) & ~PMD_MASKED_BITS)
>       |                                 ^~~~
> arch/powerpc/include/asm/book3s/64/pgtable.h:1007:21: note: in
> expansion of macro 'pmd_page_vaddr'
>  1007 |         (((pte_t *) pmd_page_vaddr(*(dir))) + pte_index(addr))
>       |                     ^~~~~~~~~~~~~~
> arch/powerpc/include/asm/book3s/64/pgtable.h:1009:41: note: in
> expansion of macro 'pte_offset_kernel'
>  1009 | #define pte_offset_map(dir,addr)        pte_offset_kernel((dir), (addr))
>       |                                         ^~~~~~~~~~~~~~~~~
> include/linux/mm.h:2010:24: note: in expansion of macro 'pte_offset_map'
>  2010 |         pte_t *__pte = pte_offset_map(pmd, address);    \
>       |                        ^~~~~~~~~~~~~~
> mm/mprotect.c:48:15: note: in expansion of macro 'pte_offset_map_lock'
>    48 |         pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
>       |               ^~~~~~~~~~~~~~~~~~~
> mm/mprotect.c:43:15: note: declared here
>    43 |         pmd_t pmd_val;
>       |               ^~~~~~~
> In file included from arch/powerpc/include/asm/mmu.h:132,
>                  from arch/powerpc/include/asm/lppaca.h:47,
>                  from arch/powerpc/include/asm/paca.h:17,
>                  from arch/powerpc/include/asm/current.h:13,
>                  from include/linux/thread_info.h:22,
>                  from include/asm-generic/preempt.h:5,
>                  from ./arch/powerpc/include/generated/asm/preempt.h:1,
>                  from include/linux/preempt.h:78,
>                  from include/linux/spinlock.h:51,
>                  from include/linux/mmzone.h:8,
>                  from include/linux/gfp.h:6,
>                  from include/linux/mm.h:10:
> arch/powerpc/include/asm/book3s/64/pgtable.h:971:38: error: called
> object 'pmd_val' is not a function or function pointer
>   971 | #define pmd_page_vaddr(pmd)     __va(pmd_val(pmd) & ~PMD_MASKED_BITS)
>       |                                      ^~~~~~~
> arch/powerpc/include/asm/page.h:230:47: note: in definition of macro '__va'
>   230 |         (void *)(unsigned long)((phys_addr_t)(x) |
> PAGE_OFFSET);        \
>       |                                               ^
> arch/powerpc/include/asm/book3s/64/pgtable.h:1007:21: note: in
> expansion of macro 'pmd_page_vaddr'
>  1007 |         (((pte_t *) pmd_page_vaddr(*(dir))) + pte_index(addr))
>       |                     ^~~~~~~~~~~~~~
> arch/powerpc/include/asm/book3s/64/pgtable.h:1009:41: note: in
> expansion of macro 'pte_offset_kernel'
>  1009 | #define pte_offset_map(dir,addr)        pte_offset_kernel((dir), (addr))
>       |                                         ^~~~~~~~~~~~~~~~~
> include/linux/mm.h:2010:24: note: in expansion of macro 'pte_offset_map'
>  2010 |         pte_t *__pte = pte_offset_map(pmd, address);    \
>       |                        ^~~~~~~~~~~~~~
> mm/mprotect.c:48:15: note: in expansion of macro 'pte_offset_map_lock'
>    48 |         pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
>       |               ^~~~~~~~~~~~~~~~~~~
> mm/mprotect.c:43:15: note: declared here
>    43 |         pmd_t pmd_val;
>       |               ^~~~~~~

Hi Naresh, thanks for reporting!

Whoa, I really didn't expect this.

I named the variable pmd_val, and during the expansion of
pte_offset_map_lock(), we call pmd_val(), and the compiler is confused
because it's calling a variable rather than a function or macro.

And it didn't show up on my testing environment because on x86_64
implementation of pte_offset_map_lock() implementation we don't call
pmd_val(). The fix would be simply renaming the variable.

To Greg and Sasha; I guess these patches will be dropped for this cycle
and I'm supposed to send V2, right? These two patches are queued for
6.1, 5.15, 5.10 as well.

I tried my best to make sure these backports are properly tested, and
apologies for the inconvenience that I caused.

-- 
Cheers,
Harry / Hyeonggon

> make[2]: *** [scripts/Makefile.build:262: mm/mprotect.o] Error 1
> make[2]: Target '__build' not remade because of errors.
> make[1]: *** [Makefile:1769: mm] Error 2
> kernel/profile.c: In function 'profile_dead_cpu':
> kernel/profile.c:347:27: warning: the comparison will always evaluate
> as 'true' for the address of 'prof_cpu_mask' will never be NULL
> [-Waddress]
>   347 |         if (prof_cpu_mask != NULL)
>       |                           ^~
> kernel/profile.c:50:22: note: 'prof_cpu_mask' declared here
>    50 | static cpumask_var_t prof_cpu_mask;
>       |                      ^~~~~~~~~~~~~
> kernel/profile.c: In function 'profile_online_cpu':
> kernel/profile.c:384:27: warning: the comparison will always evaluate
> as 'true' for the address of 'prof_cpu_mask' will never be NULL
> [-Waddress]
>   384 |         if (prof_cpu_mask != NULL)
>       |                           ^~
> kernel/profile.c:50:22: note: 'prof_cpu_mask' declared here
>    50 | static cpumask_var_t prof_cpu_mask;
>       |                      ^~~~~~~~~~~~~
> kernel/profile.c: In function 'profile_tick':
> kernel/profile.c:414:47: warning: the comparison will always evaluate
> as 'true' for the address of 'prof_cpu_mask' will never be NULL
> [-Waddress]
>   414 |         if (!user_mode(regs) && prof_cpu_mask != NULL &&
>       |                                               ^~
> kernel/profile.c:50:22: note: 'prof_cpu_mask' declared here
>    50 | static cpumask_var_t prof_cpu_mask;
>       |                      ^~~~~~~~~~~~~
> In file included from include/linux/list.h:9,
>                  from include/net/tcp.h:19,
>                  from net/ipv4/tcp_output.c:40:
> net/ipv4/tcp_output.c: In function 'tcp_tso_should_defer':
> include/linux/kernel.h:843:43: warning: comparison of distinct pointer
> types lacks a cast
>   843 |                 (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
>       |                                           ^~
> include/linux/kernel.h:857:18: note: in expansion of macro '__typecheck'
>   857 |                 (__typecheck(x, y) && __no_side_effects(x, y))
>       |                  ^~~~~~~~~~~
> include/linux/kernel.h:867:31: note: in expansion of macro '__safe_cmp'
>   867 |         __builtin_choose_expr(__safe_cmp(x, y), \
>       |                               ^~~~~~~~~~
> include/linux/kernel.h:876:25: note: in expansion of macro '__careful_cmp'
>   876 | #define min(x, y)       __careful_cmp(x, y, <)
>       |                         ^~~~~~~~~~~~~
> net/ipv4/tcp_output.c:2028:21: note: in expansion of macro 'min'
>  2028 |         threshold = min(srtt_in_ns >> 1, NSEC_PER_MSEC);
>       |                     ^~~
> fs/xfs/libxfs/xfs_inode_fork.c: In function 'xfs_ifork_verify_attr':
> fs/xfs/libxfs/xfs_inode_fork.c:735:13: warning: the comparison will
> always evaluate as 'true' for the address of 'i_df' will never be NULL
> [-Waddress]
>   735 |         if (!XFS_IFORK_PTR(ip, XFS_ATTR_FORK))
>       |             ^
> In file included from fs/xfs/libxfs/xfs_inode_fork.c:14:
> fs/xfs/xfs_inode.h:38:33: note: 'i_df' declared here
>    38 |         struct xfs_ifork        i_df;           /* data fork */
>       |                                 ^~~~
> make[1]: Target '_all' not remade because of errors.
> make: *** [Makefile:186: sub-make] Error 2
> make: Target '_all' not remade because of errors.
> 
> ### Build logs
> Build details: https://regressions.linaro.org/lkft/linux-stable-rc-linux-5.4.y/v5.4.301-185-ga03757dc1d0b/build/gcc-12-defconfig/
> Build log: https://storage.tuxsuite.com/public/linaro/lkft/builds/36Hn1iZBZCBAXg2OuUdfdNEUFxK/
> Build config: https://storage.tuxsuite.com/public/linaro/lkft/builds/36Hn1iZBZCBAXg2OuUdfdNEUFxK/config
> 
> ### Steps to reproduce
>  - tuxmake --runtime podman --target-arch powerpc --toolchain gcc-12
> --kconfig defconfig
> 
> --
> Linaro LKFT
> https://lkft.linaro.org
