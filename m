Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF3040BCDA
	for <patches@lists.linux.dev>; Tue,  9 Jun 2026 12:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781007263; cv=fail; b=hvX4oSWney5jrey7k8CPXHTXP3wcv4gFZ+YKXBvCiVas1F+TMVEnzicqRdBMwEEtMa/a4Mjwgpn2lzeSk7MvcHHU9ISOfdlLy6xuqmEzsaygEqDq4+i7+Am1YZNC0Y7bCHIX7C9zWdZSZjCOz+NTDrlpWb9STl+b2yq9Ud3HIYA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781007263; c=relaxed/simple;
	bh=fmGH3ZcxfHyCJHtHkfHWX8+vmTtfdJDWDa/QSW1CNOk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=huQnxriugThUOpMKMyDl0TVPDr4Dx4pqJsFCf3t/7+i96rqgjH7kGxvkKa6rBhMiOmLo4JZHv5/uZ5+JulneD2ITzko/NzLvCPmKVqVdtID7YGs5DtKjYI2XIETUxSssi3y+QnDfWtivJExuIG/qPMVXFyHrmkbGibW89RZb0Og=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gMIhXx+Q; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=q4yajaYm; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gMIhXx+Q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="q4yajaYm"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6598l4sP1242849;
	Tue, 9 Jun 2026 12:14:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=tVy9N96DIPbl7VZVKJZthu8z6/LQtl/KXNpjUUJHW40=; b=
	gMIhXx+QXCuC3YYP445pXYlmB6l2CLaOh0NO2ViBX6DyungA0ntTAyGDy9jugio/
	DV9BmL2J7s0ceGm2Z7osDj9iUf5U1qfocwC1b/8Kjna4HsdN7pQa5lmYMu+Xhqhj
	Ak7RD9uvj9RRNKl7fW7B3NtUl/PyYN+/6wkgqXPB2lbeBS36qOPXQX0kWsFOYOjA
	KEra5LdALWt6yuIXiJh6UMMljBkPuumfaCDsa2cUiV9/QpNH9FCyUdwL6OiB/sd6
	hf//Aag7q7LIDGt204Dt1Z5y9D4oDge+G+nrXU08hlEWw3CSpWkUVWlPvo7og5YD
	bxKJ1CHtQjGAJdNvmvt5kg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4em9ybc8u6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 12:14:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 659C8X8K039926;
	Tue, 9 Jun 2026 12:14:10 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012043.outbound.protection.outlook.com [40.93.195.43])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ema0q1x84-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 12:14:10 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xTsFgVzhY/ImVEo/p1mgweCQ3J1FJjS2mIhajA5Ma6A3VaPjzsQcEyxxIBGIDpCsKGyMfGw351Ej8qGeDEhKY2wJCm2iLBhruY7IVwYyTk3gNKMAIy6mbqsCG6hkyrXuKJERaZHhEuG05CBFnx8w5jNRyT5i3qOSJKDEWNUkWAOGIKF29Y1d/puSPN+vvceeitU4fRDm/wZCZLXrYoeC0JhYL7bfHPPbDZ3mvT94Pz++wGIqv8r84wWvauS76Hk9F8SlOB80Ky4dCXeypjacsDxj3ZInYZtnEXMvxUg1xTa3c4VkJArjYWkTKClBtA0YxBQi/Y1WJXhsdlFiVXWIoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tVy9N96DIPbl7VZVKJZthu8z6/LQtl/KXNpjUUJHW40=;
 b=bQLwn7S8RNhKFRwdCfAKU+D7luAdwrj7kztUFI3iv0ikfXb6e2Hd7SFLyFpu6Gv0U4m8MAu/ONOqYp09XpWpy8aaOg2ddesjlxrRFrC93fl6OBgzE2SEQWlEqwmtImSpQxDJQaQYs6tm5MAX7Nxcu/BmrSDn2M15s7En4mAKjsE8fLOhVb2bPFRbWdcYC/fcG3KKYpQNdDlddQvKs5OipJ+yCF5JXkr62M0P19qBrfrZNrkKxS3txTwy67qMQU2BZNXiGSVUQ4SZrMLMP2eWtBiRR0Cqf+Zte5RiYo79bqGFK36h07URuJzb5CWxI99FNz1cBt9bUnISZDNXQEsawA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tVy9N96DIPbl7VZVKJZthu8z6/LQtl/KXNpjUUJHW40=;
 b=q4yajaYmlf1DsEYc0LMO+k2gGX5C4W0fp3G286mZvpS8n+5R0QRA2Ny8oL9CTeC9EgGsBDyZNL+lIaamHY3T+6oK1uMKdHLG009PIfUBvF0TKnhwb8d0qlSRjRq6FiDxXJGQhF+lK7FbSvWBBqG3NQnbR8p9UEozCW9mFiitgLs=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SN7PR10MB7004.namprd10.prod.outlook.com (2603:10b6:806:328::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.12; Tue, 9 Jun 2026
 12:14:03 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0092.010; Tue, 9 Jun 2026
 12:14:03 +0000
Message-ID: <913814f5-e4d4-4ff8-a98b-8795e77b6784@oracle.com>
Date: Tue, 9 Jun 2026 17:43:52 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/307] 6.12.93-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org, sr@sladewatkins.com
References: <20260607095727.647295505@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1P287CA0021.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:40::24) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SN7PR10MB7004:EE_
X-MS-Office365-Filtering-Correlation-Id: 127a7f67-0a3b-4b6c-b499-08dec6209860
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	g1NkObOCCrTuf7Sk/Ui/UQ8TNlAZorghwvHykx2nqoBT72Q/PYI1lrzhpRiZ5Vx3Lc7xJ9epPoCZ5Mb2/SjahPIYKwDB06yXjTmQoboA6YWQlU0u6u72zTQzDGucF/RKFj5UidBdu4Wv1uel2QkxmuOg/CzU+N+TsnNU3RmpsPVAwJ2K6PugpI0xZgDlJcm92wscJWalXDxFHiCz9XFdZalZds5HshqLNcEFw/jRy2dQXWJzujWO80Cm/dRNQJHUNvS97qpUb09GmG8hHMOWCzCS7isD6mRtY8PMADmT/HVwOfMX0yO03Oi9SpLGy8vglYInIQ8yGpTl2G/SiI34SZSaLzfR4YAyNJUjkRReqwtg4yhZqZ190c+k9zVbw+dNSZDS7T3du+l9aR9LjzzBrn4UREQl3Yp/dBmo2GXFCfF8qoM5mr8MH7ceM63DCb3B8yzaY3RBtjk0r7daJFGWDFuSQLB8ZHQzayaOCy0ruPFpE3vRhVARe7ODxNdz9kGcd7HFOQ4zXYk6NaAMnOmm8Q1tAcLFB3OB3/04GOyQydDc7OZ1CFvn9EZZpuDHLnFlIE+AmlnVa5y8M4P+uiu7/5mVkJFsKw+AjoGLkQ9NSuzXUsbx0r9TtrIkR03qb46/Rz39sHAvVNd5aYRaqNWYAIDwcrf1dqNKoitVvz9cCssIyZqT5g86mEl1HkN6y3+h
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QjZUa09BVVFGM0Jqdm5sY3NHSjlFK3prUFBjNEY0ZXA3K0RiQ2xNMzIyc0NR?=
 =?utf-8?B?SmJEdGwvYmxZUitPTjZtaFJOQnJMNGR5OGxBVERlZmVFOElZSkFuN2xiY2Qx?=
 =?utf-8?B?OFlleXFySnlWaVRzUTAvVi8yM2ZjUmNEU3pBRElUZisyMTM5Q1BZelFsUC9w?=
 =?utf-8?B?bUJJTS8vdTB5WDRJVVlEajA2bHdBTkdhOUhsbUVBdzI2djlQK3EzS1BFQmpH?=
 =?utf-8?B?TkhQalRTRmVDYk0zOHp5eGpxK2NPT2JFUDdRUHRsdEVtemZYUEVpeHA2N1pZ?=
 =?utf-8?B?QnJEak52dHRpM2xzVmd4eW1BMGFuK3F3bytyYnBKK2hPUzF1WXM5NFh6SVVF?=
 =?utf-8?B?R2xtYjc2a3lGYnBYVzRFSm5JU1d0Ukt0cHB6RzE5bzdXeW9lNzJ0alg2Ni9O?=
 =?utf-8?B?M2FyaXp6Q0RsKzJQcFBNa240THlqMGE4eDFReWZjVThleFJicGJzR2ZRL1VW?=
 =?utf-8?B?QzJxMGZ0WERqY1p6Vm5QcU1BSUtEeWg1SVByUldiSVhDNlBnVDZvNThWd1dy?=
 =?utf-8?B?YkRld3RtVXFHbUlZMjkyeUppM2p4R0JiMHB3UzVVUExDcytZUXlQWWh5ekR2?=
 =?utf-8?B?MTd4UHY0cEJqbDkrR3RtZHpQaDRGeWVRVUt1KzFCL1lLZjVBcXhVVGpyekIr?=
 =?utf-8?B?OFNrM2xKazhrcmFrQ1l2a2JFYWZVZDd1U2hMbCtkeVJQTFJWK1ZQVUZrRUlH?=
 =?utf-8?B?ZXlnZkJuMnVZQnk3aXk1VEgzSHI4TUxrYUg5TmUzQ1BOSWh1UW43T1NwY1Fq?=
 =?utf-8?B?cU4vSFRlRUYyMGNLSTVycnJuQmRnOXhJSkdpbmVqMzUxWlEydGplQWkxZ0ZP?=
 =?utf-8?B?TWtib00zVlhNL3gyZUp3aHhwUFdFVFBaQ1JkdXlrSlpnV2lMRlR0MTlETGJo?=
 =?utf-8?B?ekdvbEVoWGpnSlg2dHIrSVRlU3FuMHVhWS9KRGdZejdNM01rSDV5ZUlFYnlt?=
 =?utf-8?B?dE53M2dnYjd1a21NZi8yazlwK0h6ajR5SEdVNkF1MWV3ZmVpb3V5K29mNmQ4?=
 =?utf-8?B?bDU3R2xPb2VrWXB6VEUwN0ZyVm5yVVJ5VllYZ2RIOVR5WUg4YUIxUTJ1MmZL?=
 =?utf-8?B?OEFKd1BWdWR5Mlc5dXF2bTRPUzI2WnFWR3gyZVYrdkZjTlBkQ3p3dlQ5MnFu?=
 =?utf-8?B?U2xOOWNiTm0vcTdvdTQ1T0FjNzdlN3o4RTRlUlNhd0NtTTdESmtXWTBiNnQy?=
 =?utf-8?B?U0pjWG1OWjh5TTN3ZDJpc2NsUTBjOGNsWEhRZk9ubHhnVFlSR2JkSUlrRnBj?=
 =?utf-8?B?eWF0Y0lLMnRWRUJtdStGSmFZdTRNUjJXZVhSVkxNMkVQRW1oRC9IZTl5MUl2?=
 =?utf-8?B?Q09FdXN2cEhPK29wcFAzWGNwQy85b0FsU21IUXBiZ2pidVVUMGxwUXMwcGVl?=
 =?utf-8?B?cTZUOHpsekVSTjU5RWxtNWw4NUc1TDNTaDZBbG5Wa0RLNmtZbU5tRHZpbmI3?=
 =?utf-8?B?dDVPWC9zWkYyZWNQdTFXb1JFcTl0eEhMZWFPSjBlY3RxbkFzLzZLcFdZcEk2?=
 =?utf-8?B?dW5ObnR0Y2J3dmM5ZkE4V2sxRzA0L0luWjNQdFdHbzB2elprTWtFZVkwUTB5?=
 =?utf-8?B?YkloRi9aSXdZaUw2dFpFVkZlajNZNlQ2c2Z2YUZYZGVPZ0VEeEdKbDE2cGMy?=
 =?utf-8?B?WFNFRTJXek9sUjhLeHdISEcwUUNsSWhPOUdDUlk4b2h5ZksydEowMHZYREFH?=
 =?utf-8?B?d0kxTGNTM0R0QTlUcHJKam5WS1lJbTdiV3RBaGhUOU0wU1AvM2pYNjkvTjJJ?=
 =?utf-8?B?WWZnUkljdENzazRSV1RxK1AwRVYwSURUYW5SWUdGYk1QV3Nhbmt0Qk9nUlBs?=
 =?utf-8?B?a1h3TWl2SFd4NUo0b0l5ei9BbEtod0hud25uRmNzNzI3dWtnZDZOTTl4MXI0?=
 =?utf-8?B?cFp3aTRoYWZqSyttT2gzUEJYaGRZeFdFcUVBVWJ1NXdJRS9BM0VSS3pqRkxE?=
 =?utf-8?B?YzRMQXU3THV1cmV6R3o0Lzg1MjNNbXlaTHJ3bHVrR0h2R2poZGNpam9acjV2?=
 =?utf-8?B?UThNS3BYL3VxUE5JUHNhOTJ2R2MvbS9CQ2l5bFpPN0dCaDVVYm1jenk4dm9m?=
 =?utf-8?B?YVJTb1hKeEZLMURkZnVVVEhLUEZEdHA3MnpMY205NWlrUXN4NGg0VmJuR0Z6?=
 =?utf-8?B?UFd6VWhEQ1N4eHBldFdwUkptMzNaaDIzdWJEcWpOUGVBNllTNVZxeUlZakF1?=
 =?utf-8?B?YXd3bVhsaDhkUjZkOXphaGs2cEFsckJCTW8rNXZTQ2wwcVppS2FrSFZOeTMz?=
 =?utf-8?B?Yzh2MGZUd085UTF3NmtLc09oK2J3Qm9uQWNyc2pJV3A0UUtETEhjWU05QUNK?=
 =?utf-8?B?MFNFL1pkREE2WE9mcCt3THFqZ2l6MUFMR0o1Zmp0c0R5aUQzRTNudjlUbWpG?=
 =?utf-8?Q?Rnmrp7sXw7fMv+meIpah2z0Yt2vBfPENpOKu4?=
X-Exchange-RoutingPolicyChecked:
	nNrEKa69xkfnTFvSe0tOH8pl0QKOt3k/8WLNLdQR+6by8WlQRAQSfWxSYlaAxjmntBT1twscetMls/gU/U+wVFNyTk5IEJoVav6eSOqa9rekpgW/Tv/DNU5wIpOxE77yKEAOE895/qPPCW9ur3D0Zpyshcjb5jRbI3U2XhyP63OCNACFzqYMUTi/lInMlpmLWfBcx9Kw2qe1ocIBdFoXkzYUQlardUJ/FdycbSfn7bAvR5nJBbwR9CjcBnuLPz/ocJ9sp8B2PE1gQCzGOa1Jerk+86tPEJZTsPuqS7fSU+A2mHwS0r73ASk6fedCSS5fd4wv/Lz5pWTbBQ0/LNWITw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DuYcXk7tppEY9842CuOaaLbgmAmk6d4n35VOqJckEyHRjbsU64OWbtnG5z+PkS0gAIJ/I79G5b91atGMaCl+9c69bIsK1LHLYyE8XEH71y8dbYiziMeWlXW8a6qPspDopNkCrMOT0HImOdJhOgWsMhEHcJMd8s9F4TWrEWjhTZZyHlOU/RxjJ1HGaFqcX11zV3n5pkBWLsEZltzwN1klALMXei+1Sn9IwvAurLibZL/UK+zGk95FeYrAPW0ZULGmmky/L2D9QfhVtYoMDlPaU+Hcz2pypQ7UHFzpW1oVWS6VFzVoYWBpN1vjTTUghurbNPzsXoDS1DB0vkOW5e5ZxmvqFV1OPb3u5VzgFT6ZdKkPZgIH0HlRdqD2wKgx+vkkezbnCYsTqUMAznlU1k9T4RdTojSjuMXL0BYZc14E1cNBf2HlL+uC9lgROC7ZSARIvJkmAkN63D5M5qbyyD3QRwv8IBA183yu3bVbjXbYTdty+7NMnn99V//c3DRIcZQTublLhZu2K0rcY+jzesESZG+6DjYRqa1uPHU6fEmPhSX9mQ3JiTektOln5l/FtnVTe+6A2xLzPsqdni/lV1Osatf+N1VcZ/CzxK+kz9AWyog=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 127a7f67-0a3b-4b6c-b499-08dec6209860
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2026 12:14:03.4489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Jp3ymWRNkfCgf6xTwBLNOziGjIsQs7mRtJSsFSGWiGZAGpY/v2G7HvyanCL9hIpJ4iL0wgjKbIiOa7zwW5DyUizy4I5lP7rI7hDFZc4Vfuj/+OOEm1iFjGO7TzG7UKb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7004
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-09_02,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 phishscore=0 spamscore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606090115
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDExNiBTYWx0ZWRfX7ri8XOaQOX5p
 k5PENGSlFCKiZEgUNuUHQ0kHNKu1bmbitU4ZyRAPmgI+2pvBA4JazYk9wHSsFmo0/f7qHkZ7ejp
 2v4K29rNRwrY3Np8PpKeg0UosgrjHsC9TFxGtwO/CD2YxjmtkN9LZFdgdP7RMmWltjYdu15Gzrm
 zaTNLJVgmhI8CH4FMrlQ0x74Ha8Uf51DqvKIReei0uA9M+PDcaauY8DBfucMPaVzFhhW5gtSaor
 NiNgi96RkH/r99K+X2Dv6P29rLwjzXSGcmxtbqkTqRAkhKhljpx0+Z/lUOjgqb+cgLlQ/k+Lk8E
 v1jWffY0s2IPW6RDW1QTqGLY3Y7I5rDxAdGoDLaw4/39XYy/RWi3RTGPAJ2dXJ6gg3O0cY9QT98
 7XOKJ6rkrAVlGYzHQ+oRGuqSE81YUBwc5cxv6YMO14eqz3+eNoL2P7ZyCMZAe4e2mOqWuqIW9B3
 fKl1i0vkMbAl19U/8h7GpqXQiThYAT3+sqbQ+lG8=
X-Authority-Analysis: v=2.4 cv=IYK3n2qa c=1 sm=1 tr=0 ts=6a280393 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8
 a=s4zE39ud9kHdVNT9uWIA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12313
X-Proofpoint-GUID: OidARP_1t-v8At7tjG_Qx8WNOPV2g8kH
X-Proofpoint-ORIG-GUID: OidARP_1t-v8At7tjG_Qx8WNOPV2g8kH

Hi Greg,


On 07/06/26 15:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.93 release.
> There are 307 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 09 Jun 2026 09:56:47 +0000.
> Anything received after that time might be too late.

Too late,

but yes, no problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
