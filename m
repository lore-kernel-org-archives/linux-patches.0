Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4F740DB36
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 07:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789544912; cv=fail; b=nygxKiHBam5gfi33RuKWEts8Ztklk4iW+9aoAiXTz9tjw7g8hFCvsy5CnoNCYdsvE1Gd58SEg/ZeQXS1DbHLX5dmygAq52vM6ceGQFVQOICOx8zRDsMuFZ9cex2GDg4MTClK7b1NMpBHN7XtfwizDmBOEVqnHl7udwHkl6VGkXk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789544912; c=relaxed/simple;
	bh=grhOod9dGh2a2UcvYuEVfxage8Ivo2IhNdW526X+T6g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YaoBnaRjxfMnc0C2miRXSpdxPjl+gnKwhmejsB1lTeyeTmY04v8tUSYRvxeTjyyJIcDoJImWfb+0b/kOWD/zUGVwtl9BDOYebJBP0Itv7Q40Ja2CzHWcrH+Ab8v1qi3J7Q5dpi3ITCi1SS/UjSjSfjvH2NyStHAL5xtXMJ5iZRY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E2+HPG1U; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=c7I8Ey5a; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E2+HPG1U";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="c7I8Ey5a"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLWT4F554455;
	Wed, 16 Sep 2026 07:48:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=XEXQT6uTqZjrkUzpCZC75zPZcykzZY9tPWfjLnKO62M=; b=
	E2+HPG1UWA62ycSSku7RhOfQhsAIlEqvNoVk58wsrWurBLpgRw/3p6oB8u4zCTgB
	mX0vGJ9/xrJefXVPLhAKhXZB7Pyj4V3kLD3puFfnMY/GwmXF8GdqIMmlCG4L1PxI
	IjTytj7hcvKMSJfVrMzlgo2qHyOglli8EtjRD0Nyev/aA937sTNrOz8LaUF58+01
	UAe5KkZfnO56L5UhE7+n7MAxTD9RHCcldoqG6t/ahG/cYfhL5rg3eHsba1fEvzCX
	YuYfTEhESFrB2sAcw/K1zX60IL+wCzYcmCCUS/roAXbRJ4EQq2qDzwSIQHW4y+Uw
	v69LbVkp0+qjeR7UK2FQCQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmw5b545j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 07:48:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68G7jOWJ017823;
	Wed, 16 Sep 2026 07:48:16 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013003.outbound.protection.outlook.com [40.107.201.3])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6q8uq9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 07:48:16 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fA/KDMM2yiOYXdbaCqRg2DmZctbx9GM5vnhlPI7jPR/qjXrI6B7mmiIXPsla+JEIASiP1hMk1542GQrRHnBrKl8HZDRiKghotGHtizO0cJuRrG83+GbtWIgGuYNq+u6if8nx/xrFrSSDQ3dGNXnYHqH9uQUEmQDxJfRyF2ijm+ng06sQfIbgGowVVsQKHmGzg2U2ohebNAB0UzCUJb0OEzUkcwGehVuf3C9jFE18kA1kNi8eR08DePsDVUOa1asZku3384nabXUP6PsBBuHr8i/XiXeee8dU4eT/sdz0H1y7dFEzFsdFordIrRqdiCeMTE0S7nDVBgtt2gPBWQUiaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XEXQT6uTqZjrkUzpCZC75zPZcykzZY9tPWfjLnKO62M=;
 b=lXyfm9uo4ywY736UZPLc970H7o8dn+VjDbbMsguqYt2JQQD/Ff1lEXGyqZsa+QfaZDAB83es+Ew0wvdOnzd4pvgewDsOVW3XvL4rDPzFBMY6pYeSzGZA2McvtWICi3TntarfXlmxGcJSozxcVbGH7ILdmKf773Wg8k206PMAXqyy1kUo/hu4nL6rhRVSxAu9mLVMEQQy7D44Mbq8VjhrsERIp8AdM9lxMPPFv/jgTkJNiPreaSh2a2bK1kULyPxiNFdM1j1LwdW21LQJxvPxzOTvhGY/ktbGdudDh2PUbsn5zxpc3DhawIzkgON3EONhdcyAQN38AnRBa2N6H8PFag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XEXQT6uTqZjrkUzpCZC75zPZcykzZY9tPWfjLnKO62M=;
 b=c7I8Ey5aTgcVW9MwSfUgNT2sXrFOovlm4SchqcnETsUP8EO+BdyX6/szSfmFbeYIEjzaZj66etjwya87307WtXwrn5LvU7kFlMoe3KcvMXzfRirJSynw06pXe/lRY0vq0Pwy+2mvKV6jLHyxJahJCGV79/0tFzNrwf2up4SYWNI=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by CH0PR10MB7533.namprd10.prod.outlook.com (2603:10b6:610:183::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 07:48:14 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 07:48:14 +0000
Message-ID: <c1a65e57-b895-4f19-8acf-9de96ca743ae@oracle.com>
Date: Wed, 16 Sep 2026 13:18:06 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0771/1376] arm64: dts: qcom: sm8450: Fix the PCIe
 iommu-map entries
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065624.722793852@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065624.722793852@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0073.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ce::13) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|CH0PR10MB7533:EE_
X-MS-Office365-Filtering-Correlation-Id: fc1635fd-9c83-4ffc-c4db-08df13c6dcd2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|18002099003|22082099003|3023799007|4143699003|10067099003|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	A3CrWo0lh2pk/Jde1gW5kX0hC4XJsPbn2ScJGpOxcpaoc+YaHsbk/56hNzdbTgDjQc5y4/BtfzOyUbPLOG484TRkwGRaVkU9ZutiwCntTi+eO1ma9yBfmcV+FEXVNGxuDt2+PUDY9xLi/21Ksi5AYacekzUddfOC4eQ1fduIvTVXAHitOFXSHl/UWoJZfGWgXH8evrlcclKFuuNCO8Gq9nFvAGKOzWTTQDLhPtKf33Cuo/kqNoV8e2Xv0ubXVYmCYqk50psTc+WiUVXYLn0NhJPRk8wnjM5bxCbkvsbev8AHQmfi45M6QQEx1JHRFlKFarskhv4Gdsbpxp7CFtWVc/iPbQ8+0dOJ9y8eWTM5MuyfPxrLnD3eVJ4pFSsKgRwWeKUBsarKzGg72Ux0q+t8sG9tI00fzXAHKfwzF1GLQAXT7cvbFQr4BBCSodcbzJLEn4qhjFd3goSn/n1EOYeTUOA1x1zxunZVf4HE7EmhJqzFDsWF8wOhr4s67PtnYFR/FEqRY8Q0UaBxCzfROs7G7LhOIFT5x7Gewsgeal7MqhRbTPKcVIVTkTexmZUO78VRWzw14gHP6ryFt9lPsHLVs7KtMfskta9TzmnPhfM22rgtveMI8PbMdWBN9pw2ix/q/1UxnC6Tv8/vxw1fHEdiMRr6/aDfJnfD40JBX90ENSc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(18002099003)(22082099003)(3023799007)(4143699003)(10067099003)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RjlzL2lVSUNnc3ZyUTlVUHJ3U3d0R0tZVy9jZG05VE4zS3Z6RDhIQ2JQUnlE?=
 =?utf-8?B?YkhHSmdJdFBtN1hkTU1DRHNLTEZBMWJyaXViZnFQWEUzRE9jWWx3blZFZG9R?=
 =?utf-8?B?aFJTWW92L3hHdG9XVGNyaXRldjR1OTBVcVpBcTFPK0JzcnpsMDVFOC9sU0Zr?=
 =?utf-8?B?MThQQlhhdlQrWmZWdS9jTnRiNTlXV0JpQklmaGdHQzBpaWNCU01nQmpXUWtN?=
 =?utf-8?B?L0hVMlZQTEZrQXhzbUJhSVdFRTFQdERIVy9NVWo0d1BvWFZqbFBjWGZMOWU0?=
 =?utf-8?B?cEhRNWp4RHpIeFZucXBzS0lZcHlFYlpaa2k3TXVRY0wxSFZBWFVINXFVa0xQ?=
 =?utf-8?B?QmRiT3NIekFLMUhMVzRpQzllTyt6N0x5eHdzZzNEci80czBBN3lGT09vMjFY?=
 =?utf-8?B?KzhBd05sVjA1QnUzZUpGdUYyc0ZVMjNhRjE0UWdvVXpPQStmRlYxS2M3Sm83?=
 =?utf-8?B?citKWk9pQUtRNUYrY3RBTUZoUG1CK3N2VXp6UVZnTUpLNlRoMUNPbVY1bHJS?=
 =?utf-8?B?VndTSUU4WHMvbUhtL2RwSXI1dmp6WFhMSllCcStmRWp0eDZ2SU5HTHhXWTNW?=
 =?utf-8?B?R1VOWWxWMFllOVIrNzNrd0Q5ZEJxalFZZnc1cmxoWHVNUjVFMWYyakZIR1Nw?=
 =?utf-8?B?VE4wdHd2YUEzOGR2azhNWnEwMkYyVUM2VHZCeU5BZVNCc2N4M2s1eHNLM00y?=
 =?utf-8?B?U2dkZ1lhOWUrSzlIai9vclk5THJkVXkwUU9BK05CWmdxYkxQcUlURXdqd2I5?=
 =?utf-8?B?dDJFMEdkNlpCVUVjSmtuWExvVEVLcWQrVHBVZTI1N0dHZXg1Rkg2RFlrVTYy?=
 =?utf-8?B?TnVhL3ExR2I2VnhPZktiNnp1VjlWTmhJL1NSMVAxb08yQ1RGWTZBdkdvZzNX?=
 =?utf-8?B?ck9mQmhNbG8xSjFDd3AzakVYS2xMTkpwUVByUFdieTFGUitJUUZrOGxOMUhj?=
 =?utf-8?B?OFhpNnh6RENaQlJUajl5SStrNzBJNXhDUkp5SGVWS1pMcnBCUk0velNVb1Fh?=
 =?utf-8?B?UzJaSUFyRFc1WDVmd3RwNEJSOGlLNUdSeWswRlRlWVFpK2pWUnFWWFd5UTZS?=
 =?utf-8?B?emk3VmJiVGN0WjJuRzlFV2tnL2lWUlhlZzhKVGlEd3FhR1lTL0NrbDR6Y2JE?=
 =?utf-8?B?QzJYRzRJWTBvbTZwVi8zRkhkdVdvV0c4bDdSYnRBclh3dkxodmhOYXo1RDdK?=
 =?utf-8?B?TVluQmtmM09FdnMxd25SbTZWeExZRWRXWG1BYmpYbmdlY3g5QXZrQVIvdWJp?=
 =?utf-8?B?MnJUZENkblJEaFpzeWRna1grbm54REpvbzUvTkpUN2c2SmNzRm9wVVdsYnhm?=
 =?utf-8?B?VmVnNVJuQ0srR25YN2NGazU2MTNhMWVDZUJSR2dZOWJtU2F1VkJjN2JwZGE5?=
 =?utf-8?B?R2lFeGpnSkdsc1hqZFFONEdod3BGZElCTHdxek5LRVlkT3lodlhzZkZKblZ2?=
 =?utf-8?B?c3N1ZDQ1OWQ5Y0RrYUZWc2Nzek1iS3MwQlhvV1UvSWFMNUtFR2JoSU5mMG1T?=
 =?utf-8?B?SXdMbzFuSkljM0JSTWdUWDJEb2czNWY0SUROcXRNSXRBVi9raUhHVnBzSms1?=
 =?utf-8?B?ckFBWS9jTGYyNUZjeHFMTFRWa01OTlpOSnBEcUxGdGxxTzI0OXNYSHZqZnVF?=
 =?utf-8?B?SmhoSnRJN1o4bmtJQ0puUUJkbHNHZFBnWitVeE0vZzJwVnVtTzlJT0VkZGdx?=
 =?utf-8?B?QThtcWdHRHVwRVdFejdleWVYTCt2alp0MUNWWHZOMmN0Umh2UHkxK21BOHZD?=
 =?utf-8?B?eDNrZDZhcEx5RHRIQ2ozYkF5MWd0VHBzL1R2T3NVSG1qb3g1Z1NLei9aOC9P?=
 =?utf-8?B?SFNBbi9lNGk4blYwU0lUNUhoekpiUkYwRmd0Y1Vjdmk5QWhHWGhZekdnNVBT?=
 =?utf-8?B?Q2dGVlBnQ0dtOStGVHVYdm00cStiaFhTemlka1BnNGhWSjl1N01iTk1xd1pv?=
 =?utf-8?B?a2ZtaEtabm8wbHlwZEMzUlZJZExmdFU1QWlYUkNIcDJxZ2tPWW02NURQellj?=
 =?utf-8?B?YWEvYzN0QTkwbktSV1ROUXFmZTZUaytwb1dwZ202OG9CUy9aU2ZZUEpPRzhh?=
 =?utf-8?B?YWpjcVFaZXF0MURwT3lxMVg2b3BvQUUwaFg1WU11cVNLSEJRQVk4Mk1Ma29q?=
 =?utf-8?B?SlVhV1QwSTdYWTdDMWtqM3B3NWZNMzZKWWJ3ZVU2OGd5UmEya2hSV080L0Jw?=
 =?utf-8?B?Vm94QXVicmRaQkhsR1hWMDVTa1JpWGpXR0tEMTJZOWNGODNlemFlMkQ5WmZE?=
 =?utf-8?B?bmdzemJ2emZ2ZmpiQ3Ric3kxaXNkUDdOT2Y5ZjZ0b3dQVGFKaytNYnJUb0lB?=
 =?utf-8?B?cTZVSVpQWkJYRmg4TEZHN0F1c0M5VTM2MUxZNytlYmtjbElWLzZKRHJ0ekVY?=
 =?utf-8?Q?68dfZbGlwOCuN4t+OKtd5YzKF4y0eoeOLWMYl?=
X-Exchange-RoutingPolicyChecked:
	llMmXloznVg0vevNHu+VI/2IGAJEDYPiFc3pSG4dEvCs2nKX0lK8ccxokZHkbvYWeD6hoYbrtXSiVkO7JERY/SWfd4y4xnsYNAySqO0KHqnQ1rYTB5tBlct6qYCc3sPu8Ip4uVnYCQBL8X6Hvdq8hBbp7EDGW4G+MVadzcGG5at2x2x7JGKI4IVxdIS9bMUy1bWe018BAHZSvU2gpe7oQa3GWPlax1SVkfLyrEAziUQnTZQqt37wwm8vG/cvwSWYJfBY7lqAM0NnfYq63RfzvjnxxB9xsnb7CTqDb8mxyYEc4RHtMFsB2dmAEdyi9K/qpSWHegohlbtGpBjKm+w1FA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/czcokW0+UxNdOfVoupfDWsiE1l4u5jLFAmTag9kJ87g0guRGGo1jty+3pKSWw+0HjThVrPHr7SZKoSGefDL2e+3rs3L12sOz2xJI8lsCJtXgqY7abv0nVir1ee8C85NltGs+qUHvdDTp7AhdUimjB9c4L0bbbMWtSVya6e62cJcHMVXe6LB0EiNiLaFQi/lbU+FdnYmbwug0my0R+BTV50XO6mPlxvSbBWsPAydcas8E6J4nhlayshZ+4KLkuL1PuHsWyQR0PEUwOp1eGvKqaIYgJ2uOID6cq99T3aJVCHkvQNuCH6Dy/2asxsiOF9eUG8LUfc8p2YeIe9Mavt5Nn7kmwbra1it1qM+pKtAt2mzx1eRCCj1CIPXZka5lW5BAwCh4+zdin1RpL8Zc70w95MoUoPCXZRzPKXfHhlNuuANuAUWgLxa9v9tDembS/Pggt55r149TzB8r1A0ek1uCZ3YW9rbNPx9UbyQ9eR4Uu8Ys75MO4Usxatk0vWW4bebZxhJcnjuggD35NWqfHSRjLYkf19/XkQ39qHHZjmwNzAT7tKyN+tZvOkvTYOn9jMVn+XbSdoD2JpPsVKbed9eQGpt6PUAcYt4x8RXY+gZcBQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc1635fd-9c83-4ffc-c4db-08df13c6dcd2
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 07:48:14.0245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iclNMPkzz4ZK0vrM0xGsENoHGicr3Pvj/JEl42M3wJd07bA2H872Awc6+zwIA1sCZ3iLeuBbEmqBV7PZ8jv6hG3qR38IuFrooeTujrHl07xXM5R4oMVlQvNqvZWpW0LI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7533
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609160100
X-Proofpoint-ORIG-GUID: 3WpPdYna5eLKTMkvgIDQ-PVAk1kaRVyR
X-Authority-Analysis: v=2.4 cv=Ev9HPicA c=1 sm=1 tr=0 ts=6aaa49c1 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=f9xKEXB5QgJ7SJK1MQQA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13532
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDEwMSBTYWx0ZWRfX9nTpfp2Y68iB
 e4Ioer9cRgwmsY4okBg2qqFe/EWpTX4iiCA+H/ltJS0cKjYi7i/3kUOJy6a6dd6FM5czEp5cAR0
 7zUa+G1IDyOQzZGz3vCFqOC7E5VaLXnotBn4ZS4ikn7Fc3X5izjT
X-Proofpoint-GUID: 3WpPdYna5eLKTMkvgIDQ-PVAk1kaRVyR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDEwMSBTYWx0ZWRfXxS4Tnm5O4xj4
 vJdyQMyaoyLhPvdgaSFYuL9VDZXvoULKTOQPsULu/pYigWf1NlkNJfuyl2qDpR07WxPz+gXgp/4
 1R71yP+tQmI9t5MvEDY5gS12ZEAVHBHCSIqUnlDXz0zQ1YJG0REVnvdADX0gxLg1J7KshA9FlEe
 TNYfYSCjW31EAupUxR3LQiuDJmahvgt8IOlBogQ8N9VSSYLOmLdlZztUkyd4BGJ1/p9nB5CbJie
 R66MI3d2Dfty5tnlFKAL0318KhmvdLbI/SdRDJIcPxzmP0gueq8CeCX+zgee8zdopegunmvrO0c
 m7rZCyVxO73YwdCj6v2YDiRGLDXJbuNd192CSkMvj1kBGhfVGaA4Q6YABdARJoEwci/B2TIt97a
 jqRy/dP2Axts2D3NTgYeF/4zR7UWHVa5yksHJpxpkpj8bxpP+c69MS/Ju2qeDvpOIJOJhFmCg0g
 N+V2EOuQmxYQ+BTYTucww+IY1cUwdiSlyzZuKCvQ=



On 12/09/26 12:23 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> 
> [ Upstream commit 9b10e56647fa8f7ab62c7e45ebf4b168f7befa7f ]
> 
> The IOMMU provider apps_smmu uses '#iommu-cells = <2>', but the PCIe
> iommu-map entries specify only one cell for the SID, omitting the SID
> mask. This went unnoticed until the OF core started warning with commit
> ccb2fd725d41 ("of: Respect #{iommu,msi}-cells in maps"):
> 
>    iommu-map has 1-cell entries targeting 2-cell #iommu-cells, treating as 1-cell output
> 
> So fix the entries to match the provider's '#iommu-cells' property.
> 
> Fixes: 7b09b1b47335 ("arm64: dts: qcom: sm8450: add PCIe0 RC device")
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> Link: https://lore.kernel.org/r/20260730-iommu-map-fix-v1-9-83405d37ba41@oss.qualcomm.com
> Signed-off-by: Bjorn Andersson <andersson@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Hi Greg/Sasha,

I ran an AI-assisted backport review, and I have verified the report. It
looks valid to me.

The SM8450 DTS now supplies two five-cell iommu-map entries per
controller, but the 6.12 parser supports only fixed four-cell entries.
The resulting 40-byte properties are rejected before requester-ID
lookup, and device setup can continue without the intended IOMMU
association.

Upstream first took f71f07bee9b56b94f7828cf3082ea19ec590de36 and
ccb2fd725d411265df8f7ce12a66c226b16014e6. Since that wider OF/IOMMU
series is absent from 6.12.

Maybe we should be dropping this ?

thanks,
Harshit> ---
>   arch/arm64/boot/dts/qcom/sm8450.dtsi | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
> index 59172db1e3d9e..521b12a56e55d 100644
> --- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
> @@ -1834,8 +1834,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
>   				      "aggre0",
>   				      "aggre1";
>   
> -			iommu-map = <0x0   &apps_smmu 0x1c00 0x1>,
> -				    <0x100 &apps_smmu 0x1c01 0x1>;
> +			iommu-map = <0x0   &apps_smmu 0x1c00 0x0 0x1>,
> +				    <0x100 &apps_smmu 0x1c01 0x0 0x1>;
>   
>   			resets = <&gcc GCC_PCIE_0_BCR>;
>   			reset-names = "pci";
> @@ -1994,8 +1994,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
>   				      "ddrss_sf_tbu",
>   				      "aggre1";
>   
> -			iommu-map = <0x0   &apps_smmu 0x1c80 0x1>,
> -				    <0x100 &apps_smmu 0x1c81 0x1>;
> +			iommu-map = <0x0   &apps_smmu 0x1c80 0x0 0x1>,
> +				    <0x100 &apps_smmu 0x1c81 0x0 0x1>;
>   
>   			resets = <&gcc GCC_PCIE_1_BCR>;
>   			reset-names = "pci";

