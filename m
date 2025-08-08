Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0252438DEC
	for <patches@lists.linux.dev>; Fri,  8 Aug 2025 14:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754661723; cv=fail; b=kO0vTyuM01i59FtLr4zmfRgAj3i2luIbznUdA4TdXd7ANKY35Xsv4FVOhLEiNtX+E4jtHmHa2MJaeoh0EMWHisWOFlqcZmTUk8z8kUsjhlBUaBLdkQDX4hbCg42my0k34TrEC0iO0TM6aDANe4EvTo9YXrWxdsGvARHgC5revZ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754661723; c=relaxed/simple;
	bh=sAHfFb+tqyr+BYfm4I/H5f02GNW+5KfUj1ma6DffqzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=V5SD+t4XgyU9xUm5d9ShfsxuBO/JIP5hxAf09z3CWPanhIuVGjC5OQBuAU9C2WsLljcoWmj+A+BPKStIqLUe3FF3kVjlkU4/0wL8MmtDWm+aqzS2XYX1Iqwo7zhyV8YUV/BlniiZ/Pn1OsR1/itoufgMm/PGaeCvgHSZVemqdts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JPgqpKdK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EoqsB98b; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JPgqpKdK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EoqsB98b"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 578DNSCK007038;
	Fri, 8 Aug 2025 14:01:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3lG9npG4PozKInNzFHIpWSgmyt3ZGbpS0vUnfzP/NR0=; b=
	JPgqpKdKWizmI9pd4fci7YJzVkv5IuOdbVMAXrrFwzdxAAQC2a7EKgGEtjyJUaDt
	oUl94/D+ppYJyARpW/YzgSvuH5cDAA+GUI2VUcUnVnJR1GdxdSxUC6h/2vuXiGmc
	ez1zHjIEKdVIPEuk2vNV7JjIE8xHPw1JAFRwAtMgP1fxAUSgRctSO37zqJgJW46e
	mB5rm3wHyhutVHvoMMmqCbowuNDAom072XOQDlI3TXw7j+SSBZt+jGV/jKDyPxQO
	5bBi7Fj4FVP0x+OLFUiV6HWH9qm35FpXZK+mcO/DQyS1QJirodjgOSgDbzxSrdK5
	SoyDbI7St/JUmpcuppCqkQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvg6bum-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Aug 2025 14:01:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 578CJNQm032127;
	Fri, 8 Aug 2025 14:01:53 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2052.outbound.protection.outlook.com [40.107.237.52])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwtb281-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Aug 2025 14:01:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L6JRdYOXpbT7TyY6ASUA1z4JoAUBRb9lSuc1e9UMOf0Tx3jKeb4/Vt68fskgyfUoDlP65jwELajzbYNZufo7cCtkFkE6o5o4caY0vF4LsJH92KmHIVeGaXuZU7TILUX0m5PD/cJsMW2s2EPx4OZYuh5iFIjAPXKL7LOF4KVVDVR1GfENmWouM5mC07Q81oeiOfgf2BtVojU/tfvR/JY/e/NlzLUzC9H7RvrkDcZXsB8v7e4hMnoBfwXBQMBMKeWe4u7nq09FalwHaf/7HeLv4XXTXUH9Jip77iWaKY5Z9xPINfgs/h6Up9s2tPeo33w6Zgpw35wX9l+OfhoaH1TRjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3lG9npG4PozKInNzFHIpWSgmyt3ZGbpS0vUnfzP/NR0=;
 b=MP/zAbyE9vtc4bmSx9PF+954dhEwosShmA+DEW+XRKkUR7WnqBMiqabdmScG2+uRe8p3hV3WTIqSv4g3e51xTsPsTyfNPGzd3axShDgvYaSfmlKaDtFZYJynf1fBa3U5aKSmvLpZsYpIdF5Nk2zA4zHAeb7FHB/FD8cwuVvRVOHvxlMlFyjDdt3evh7Hk1M7Fgr2vvpgGKWT3Tc9XAIMqwDxyOEOBqHt49fR1mVT5X4iMj9rAyiLLmosJYGNytClXZX4oh/yFWJiNbRvOoUWmAPuPePe2zQYVEQsF8rn0qq1MORXI4Mf8BBbwhjZy47etHZlQe5wtMd38qEVBCxiHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3lG9npG4PozKInNzFHIpWSgmyt3ZGbpS0vUnfzP/NR0=;
 b=EoqsB98bfYbFxwZj+tlOgk4jKjEfFTQMKsBnPRlEdvV5YnIIxdVicvCbcOm/e9Xv4TCDNqo7AexAOGZpgquAEHFRnnHuIXM5EHzD/RTZPRbbxEnRdifJ8kv9tQ7v9vcHXxwjrbHQ4OgfeFNCHJMlRwHTuKNBcYTaXR1Of/RDUpc=
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DS0PR10MB8149.namprd10.prod.outlook.com (2603:10b6:8:1ff::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.14; Fri, 8 Aug 2025 14:01:51 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::156d:21a:f8c6:ae17]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::156d:21a:f8c6:ae17%7]) with mapi id 15.20.9009.016; Fri, 8 Aug 2025
 14:01:51 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc: gerrard.tai@starlabs.sg, horms@kernel.org, jhs@mojatatu.com,
        pabeni@redhat.com, patches@lists.linux.dev, xiyou.wangcong@gmail.com
Subject: [PATCH v5.4 1/4] sch_drr: make drr_qlen_notify() idempotent
Date: Fri,  8 Aug 2025 19:31:34 +0530
Message-ID: <128b6759dd8c93a79e0c7fadd1ec75a9d666b7e9.1754661108.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1754661108.git.siddh.raman.pant@oracle.com>
References: <cover.1754661108.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0063.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::13) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DS0PR10MB8149:EE_
X-MS-Office365-Filtering-Correlation-Id: cd1a8ae2-929d-4620-eaa7-08ddd6841f6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PH0maI5Fu8F6kldLt8KUD1brSjsOL65JbnZTtOYFIaa0Qx3jv/4vjWygNxOV?=
 =?us-ascii?Q?zVoYPE7D4od0QfUsdlfcbN50tbr8lmOTGhFdGgpF+SBjBnmApOZcph8uu/nW?=
 =?us-ascii?Q?3JGHqN6YjKEsPzQX8T3F+L9l4wREn1p0EUYE3oa2Pt90THZBlKvHPqGncKZE?=
 =?us-ascii?Q?lYa6GPcsMFdki76XIw7kZVEzszo1DAgzjhPb+9HuMUS5V175x40LvOblpXXt?=
 =?us-ascii?Q?1+dGWclf318dlCGBd9P4PcjBVW2wRGqADYYbw+FY05vb2HeEBRx6RYSjKOmv?=
 =?us-ascii?Q?jMGXitVbngprrWXvrtCOoM/xp+TQ0Tour0LxM4ASYkHnfs+BBPtXuP0pJkvw?=
 =?us-ascii?Q?1IqVFmvMwodPoHQ0JzxpAUG1zd7Gag8lxz0XsYv/HqE5cVmzrFt89fdTKnef?=
 =?us-ascii?Q?IC3GvKDWrEazzW069XAmlwWoTDNLjjduEb+UxsKvZ/WEkibB2w8hpcYIz/SF?=
 =?us-ascii?Q?hbT8EmfYCn4NjgyrtQcCtvsGm5zCQwZSNsOez2p7h5A8/P1pKFMkfSI0WyGv?=
 =?us-ascii?Q?UdFL4xES5/c7/OUZSeHUH+G2bkQsngOKy6r++mzvWfEb0jKPFpXuSexrP1lJ?=
 =?us-ascii?Q?vm1rk0cEvmYE830UQ/txFqPn2OTRffdf7Yu/KzogB4vXKPZs1zlpBXWi1jcb?=
 =?us-ascii?Q?KPSBoVRjbzOXG3amup1nFCYgDEjzdE5YDdqYSUnzqBt+xyCQk67uaXzk4Jlu?=
 =?us-ascii?Q?gsXj/NLjJBkccRte4xYWZgoK42boW48AI+jThKn74L66332nd+Y/kS5dxUrM?=
 =?us-ascii?Q?SovXTa8zFghaOEY11OLGp++55HowQYy/n/19qzleb1zWNfhzzmk1eIlC9E5U?=
 =?us-ascii?Q?5Uq+47C0HVG5ny+C0k3h0/1zDD3msa5WEwyzz+f6rZgWvS/iGPCUKgXxUwh5?=
 =?us-ascii?Q?BNtErD6hqBD+z1qOXjW8xncKnaJSq4e9t3elgNcFzqGCY1HwH3S1mwvzJxxw?=
 =?us-ascii?Q?fn+ufnxYufVS3aJG8M7qK0qA5/HPQSWDn2AYuQAUD0RZqmI3WEdTNWBEIEfy?=
 =?us-ascii?Q?hWVKA1NQAg75ARO0ENGb/nOXAznx9zo1NhGigGUc2IGPGMSESiDxeqj7Deiq?=
 =?us-ascii?Q?Y2o+QV7v+rjn9T29BIOQxhyCrahub1P5I3VhpZtfgWgrU2gFFhdO4Q/5yA49?=
 =?us-ascii?Q?0tQkvMw2qW6A/FmaSjCDoQtgnKCdWokos0etjVEQ2yGNpwNCoqNJYSMMYioa?=
 =?us-ascii?Q?i7gjE207azFdFCcXXjiZx9q9FcvZbUaSg0yP0akR4+mIrTBELB/Lfbu+1BSf?=
 =?us-ascii?Q?kHnU0DQmx1mvW7n3G8wqXONJhaMh1AYr/4/Ul066KR5yheu0tC9tzOKytII2?=
 =?us-ascii?Q?SToqYTVkbOFtepq+qrTN2a09aKgXaQIZMaV0BGSIFvLzGhPUuUhFs/fW4toN?=
 =?us-ascii?Q?bBB1MFI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ytR7LruzClHGoTkAM4dEJxD40Xx5/jyXhVxorNSwtPDy65L4j7AyvPXBL52Q?=
 =?us-ascii?Q?Hn6BQEb02ZlwrEKrYcgXmSCFqwPZu0rnAgl3qZolaFzX6v/zmW2eTi52mp/1?=
 =?us-ascii?Q?dO24iXAJqbymQZsLYAJ8qaVwFBt420aEgz723yd49eiPg7O2srxnmSKrfanC?=
 =?us-ascii?Q?IYz2nV9ENALXmGwWrsVJaOZOWg7aq0zid6woMBBGBGjf7WwqqahpJrWJDRWj?=
 =?us-ascii?Q?w8dJiYxkWe6zu8x3Wn15vQYMoGGaw9FAOM6U5SoN+VbW2f9ZoDbjO0AqN4CO?=
 =?us-ascii?Q?zeIs5LCc3ZxigHKP72saJoHsusTX9mmEMP0jv2RkGX6RVBgecccGd62MiJkp?=
 =?us-ascii?Q?vozvxAZgDRMRiSPaWFvBGHO+Naok1OyR0tF7cE1RcC0Q89WTr6CLBGghttLM?=
 =?us-ascii?Q?s87OqIUFeCqu8ay1x9B5dbkCD4qcmZZFpVMoqDIEaplFJeXZEW43A9QMUVqA?=
 =?us-ascii?Q?eHrww2EP/R9HG4+x+h06Oav4ub+ncC2MdIpjZUUOqsxt/AgO4xJ8G3yzlWxP?=
 =?us-ascii?Q?NKpczAUiqHIpspO8TbVA0A0pVtdVKw4YZUVHpiUkBht8ofTn95JEG68NXjOI?=
 =?us-ascii?Q?M1/flfUPNycHuUHZa69hDih1GHifk0Z9gsKA3d7+sVqXNbXfC1B24+KtuxOk?=
 =?us-ascii?Q?lS2S3g2nFq6nIseZQZkW6S3xxHe3PbaWhsit2m2cxikfjePdfKgxhFm6n+Sl?=
 =?us-ascii?Q?/U1dUrDO7wndpDnNEwPUOSOkbrmf1bjLZYs519mfF1acjAhHEebGP3MZH5RC?=
 =?us-ascii?Q?rAxCcyfFcVA26QCV7UDfnzSbS6b4QwEsgK44yIoC5T8sBIoOH9iw+PNrJ2+Q?=
 =?us-ascii?Q?dXHkoGJfvuhUYM5zu/LX8576eSFBDmUaXnNsLSxf/Y9uBRcrgz6uzZqx7VFv?=
 =?us-ascii?Q?oC8GbDBw+iWWCYCTXTwTik3CuYInQ7eAnd11wQUyKcC0bD0e1IGGX5YRqVFG?=
 =?us-ascii?Q?KWkTGn5XA5wMBYB35Gzw/cge89KJmCIulzTo1Is7H/RWLfak799Iv/0jxDvA?=
 =?us-ascii?Q?UQ349eN6cabYQMHVAj9pFYIW9W6AMnXyRq+LKqH3j5AOVlz8zfhgHCARhsbt?=
 =?us-ascii?Q?Wl/abw/5RM/lgeZ3IqOXIR5EoU0N0GBuONJcc+ydCsMeKEAYzQWpe0PmLhNp?=
 =?us-ascii?Q?rMIcIQGMgSgm1pFUemtfT+fRsCnzH9qA6r6Rmit/yZ0ToO2VMq5gjAT4LMBf?=
 =?us-ascii?Q?1wW3peb+uxz5VJL+L//pBe9bNGGrwlVbgbLplWF6oBeQzPB6vBPvInFMgmcJ?=
 =?us-ascii?Q?fj5iBD/nNhWSzZ8VWJIIFU0mi58VT1kuy4GDlqEfESQXi9zVcugF3/YpQy6G?=
 =?us-ascii?Q?DsGBSQNdCgdhi/v9GrEOjtS/uaNN2zMWmjRUKd7UCZuC0w1K1rZwAqzhtaFO?=
 =?us-ascii?Q?IYFhN2NAi5ZvBROsggMvzEYu2aiP6y73Qt7aL9xr6fSno4lYMX0HMkmsrNZQ?=
 =?us-ascii?Q?4smf5XTW80i8ILwjJWM5Or1XZVWOO48/Zz7nCGwgMJNxSGvSFOdFiCTQmQEP?=
 =?us-ascii?Q?ttvl3kJMCfmKp5TOuULxqq+QbYSHrFQmZbi5HCNhebTQkkonM7EMrQxU99dV?=
 =?us-ascii?Q?BqcSSi9Obtd2nWzL2osw9NRmxywaJ/istvmE7OqJ+8ohXHScmZIV0WGLwA1D?=
 =?us-ascii?Q?Lw7DIN3Xmv+txbdGJTKvLd6QDXQTyxfhbk1ri71hidkO4jjr8y3m1rEns01l?=
 =?us-ascii?Q?VQlitg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RJP3d8M2XeQ1t1tf/g94Q+57kb589/tPerFVSuW3Hgsjmo9ng2IZz65QgAFl2usSZmej4WLn09icupiVZKaStd62EF8anoF3z2CooXPhwMOiqiwGCQvATjmqz4jVCWb+Kzz0atF0RNO3foEv0kMWl51ic94gPE3ELzTvI327OjIyXVzK2Vpo7KnwYAFdV72lcnGm+bQRzO3giiyVxbb1Nd0CLTsgASIy/WN79EgZBdW8Q2OCd7yWbfull0y70iQF2GlR7ow8P9MIqyoia9kUNui8deHzOj6VYxk5kVLuM3YFsSMQ1qi3WuxffWXqBFq+G0Qaj0VR2CqzuTe0WpqekVCDV3wD/CQRST0IhIhkgEQWPlIvVVqjOlcx7MB9DPAgFSVgsxxWMhi6/OeALBA0O84Fz3aKTQ1hYHnkiZK/kCWzGsx/SEzBVAxzTVmnvpvwO2Q9OLQ9ZsdcFofGguGWFrRkMVhgI6/kO/odDoe5x8a+uJxWXSqyIAmgEIoqcgJh6r5a5q/rMbbU6djP4c/OJWisKvkVHbTUq/kt2OeBGwzX3RT8s8lP7cg0ynIyRIrAS8yHwyXpzQcYhtF9imOgdq+dPwCMWwdhWeG6Uh8z99o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd1a8ae2-929d-4620-eaa7-08ddd6841f6f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 14:01:51.0780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gMYdEi83ORpuvvAlo0Rjiuh5pzkeF4Wt/1yfPtXyRssIB7exlEDMReov16Vtjv4nfeAAIpGHYgVAQecGaDAdTSbGaydy3sOWkP2l5pU1HTk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8149
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-08_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508080113
X-Proofpoint-ORIG-GUID: NtdrLy10V0JOS7vy2TLEd7olu6FZJ89d
X-Proofpoint-GUID: NtdrLy10V0JOS7vy2TLEd7olu6FZJ89d
X-Authority-Analysis: v=2.4 cv=QORoRhLL c=1 sm=1 tr=0 ts=68960353 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=bC-a23v3AAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
 a=A7XncKjpAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=hcMAcP5njn971MHogS0A:9
 a=FO4_E8m0qiDe52t0p3_H:22 a=R9rPLQDAdC6-Ub70kJmZ:22 cc=ntf awl=host:13600
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA4MDExMyBTYWx0ZWRfX6CIjlAOo2lLs
 /hTXREAmM8EoVIDHl4k+Ju3N1oTWyLqjjVSnhHnWoFlWftaQZHnUReszWjuQWQnJHhOKNge9/ZP
 28+HEbjw8nc5moucdvfWe0T83hO1H2tWQLUahWLWQcNmazBHRhx5Gz6y+oJbYUN7PV8L7wXIqts
 pP2FYVIJRNqed0a7DnFN+b0sHkQYA4/JtpSJczXyD36asCxohUniXGkqiIjqv7TzDLFID3k2tci
 3Tb8kAOC2LBM8DnlSEUTKaqMAwh9iE8SDFXy2Ue8Q14btJce2siZ1MwVYn5+bkAZy4k3r54UkCk
 6htr0nLicEYjfZpAEFrvqDzFNTbmi7acQ9Tkt5AiQNXFvysu/wprPz+Z59qoo983L/S4SYwgJ9n
 CHzPrny31kTBQcAuYCR/HRI+LrEyeg2n1X9a5M9fJmLlZcI8ZC9BcVFfbmUUI1Hs8dYSdjc9

From: Cong Wang <xiyou.wangcong@gmail.com>

drr_qlen_notify() always deletes the DRR class from its active list
with list_del(), therefore, it is not idempotent and not friendly
to its callers, like fq_codel_dequeue().

Let's make it idempotent to ease qdisc_tree_reduce_backlog() callers'
life. Also change other list_del()'s to list_del_init() just to be
extra safe.

Reported-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250403211033.166059-3-xiyou.wangcong@gmail.com
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
(cherry picked from commit df008598b3a00be02a8051fde89ca0fbc416bd55)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 net/sched/sch_drr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_drr.c b/net/sched/sch_drr.c
index 1a0571806342..088084eb393e 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -111,6 +111,7 @@ static int drr_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 	if (cl == NULL)
 		return -ENOBUFS;
 
+	INIT_LIST_HEAD(&cl->alist);
 	cl->common.classid = classid;
 	cl->quantum	   = quantum;
 	cl->qdisc	   = qdisc_create_dflt(sch->dev_queue,
@@ -234,7 +235,7 @@ static void drr_qlen_notify(struct Qdisc *csh, unsigned long arg)
 {
 	struct drr_class *cl = (struct drr_class *)arg;
 
-	list_del(&cl->alist);
+	list_del_init(&cl->alist);
 }
 
 static int drr_dump_class(struct Qdisc *sch, unsigned long arg,
@@ -401,7 +402,7 @@ static struct sk_buff *drr_dequeue(struct Qdisc *sch)
 			if (unlikely(skb == NULL))
 				goto out;
 			if (cl->qdisc->q.qlen == 0)
-				list_del(&cl->alist);
+				list_del_init(&cl->alist);
 
 			bstats_update(&cl->bstats, skb);
 			qdisc_bstats_update(sch, skb);
@@ -442,7 +443,7 @@ static void drr_reset_qdisc(struct Qdisc *sch)
 	for (i = 0; i < q->clhash.hashsize; i++) {
 		hlist_for_each_entry(cl, &q->clhash.hash[i], common.hnode) {
 			if (cl->qdisc->q.qlen)
-				list_del(&cl->alist);
+				list_del_init(&cl->alist);
 			qdisc_reset(cl->qdisc);
 		}
 	}
-- 
2.47.2

