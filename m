Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C571B7F4
	for <patches@lists.linux.dev>; Fri,  8 Aug 2025 14:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754661732; cv=fail; b=SA4039SWfCjD21Q6AUJfKcpBIwQidfBVEoxS8PsN5yHOgmZXmW4yNiWkMYsQ79phC8UF4xo64G0k0GM8bulQfzybKHdCGi75WLFOLtzByIPZopPKH2Bms+IROUauLM5PG8PFtMSZM/Z853Xe7O47Q3UjOXOcP8Gt5xY0cd2ImCI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754661732; c=relaxed/simple;
	bh=ZS7ab+bQSiYNHc3HH+mVmPtvhsO8kDojeBf3y+blT9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WShm139CWj96AgI5hKRqQyhxwHCEQ29D3OxBpKbkISFZ7wlJU+CLH2/3/1U6rcMkKHKQR+a6vc0y/D/LaLXUQomx34fG/vCgC4nxIW2zBfMXMnBrdprt7pqniYGJwpET/P/hx8HXQIrY3CLG97qG6Mv9XBttfo/zgVfP3KP+oJM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=l96IMhe6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=A7F5Lb1p; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l96IMhe6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="A7F5Lb1p"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 578DNQ9Q003275;
	Fri, 8 Aug 2025 14:02:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=tT7HvnLt2aBJZnkmUZSe8X9PjWphYYJ2cnMwEGIGLbM=; b=
	l96IMhe6RneW4uHePw7OfDFxludhYcN0hozWoUWX0gh06PPzEZowTlNwlPJAyA2i
	1PVjbE/prpzCpgI7Y8B2XNHRao5icU0yPGxrj65Kztp0gc5+IZwE8KMxYBOu8rH5
	GANhWAgPm8eY5XE98iLPBdsBA85eaVBarSEIghE3p23MW6V7dFDfYfhzRFi1wySx
	6KYdmgWpeUBp6Y1dobyw1mT2qGHiuhWO3IJpBcmgEDYxFCOuQ3TTrrG7Ghg7BTav
	h8QK53zXU9pOQdXkEpqAQx+URI1tNWmcTF5rB+70eQl1zjE5IhIvoonriJ+93WZT
	5/olO+j6lTm+GIihKO44SQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvjx7y9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Aug 2025 14:02:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 578Ck5UY005767;
	Fri, 8 Aug 2025 14:02:04 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48bpx0ttjt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Aug 2025 14:02:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pKR5oJ/wmY1DJT9VqDER+VXSNzmgWgNN3K3OSV8kVcI5sgnn6w3swWbHYb2qY8/JFW0LMjtHf86XMjKCZK2/5wib5EF1FRVgwlBc2cozKTerxeSpbVmoocF7n98Rsp91ECMDVkVH00YdjzjXTE3/I+aWOZlCrBYLabs495FaBiLcF737ZaMFXFY8vCjntdAaRFAvzW/BXoOhBswUPSBtm1Ku0goZ7iu+TpuUsrrUsZbF7YXCXU2E+hfOOSkswgtktbw0eijs/jfTXo1f7AfVbWli5VIA6N9+lTnnRHtWNxCVRO2Fj/hZdH7K3MV6xaI+4NgJiRTCqhHnd7M8cE+D2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tT7HvnLt2aBJZnkmUZSe8X9PjWphYYJ2cnMwEGIGLbM=;
 b=tr+CQmOs0vsYk+QMPKRfijQ6cdzagL4wUraqAsTItJRyo1afMqECoLW5wzl8bNYq5tKnEgpmp1lo4ZlB9xXD6kElXU95sNg4ZRT/FqJ9f//2mOiNaf5+cL2S7AIVRZoxPUvedKAGeLJAp0CC0OMiZeehr9MGU1nznUxvY7WMvQCQw6LcHXtWBX11MEZAeYkt2BB3JHPLdkhERwa+6PyqrZjFm673+nzCnxMFnSWf2Uxh2LX71ycSBhR3ONA8vbWGjszKtwFlDB4l8ZAulD8qkSJ1GbyIGtaQ3BQO9eS7yrpEvXfrXRstD1EifCCoun5Q9apre3hWj/Foa8PVAYPjYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tT7HvnLt2aBJZnkmUZSe8X9PjWphYYJ2cnMwEGIGLbM=;
 b=A7F5Lb1p9TdpGSSzbwwk47id/muAVdmOVb+kjH0PM4RncvvPET1Op1XQ5ZEVm2QvlRs22tIxrUngsl3opW/mJMqTS8xGPUHQDIjB/FwV5QC3U7qXoWxZ69a0W9FAFQrHLjCVDktz9gPWQ4bZFqMk7uKzPdRcQngao3tXuoRVglw=
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DS0PR10MB8149.namprd10.prod.outlook.com (2603:10b6:8:1ff::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.14; Fri, 8 Aug 2025 14:02:02 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::156d:21a:f8c6:ae17]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::156d:21a:f8c6:ae17%7]) with mapi id 15.20.9009.016; Fri, 8 Aug 2025
 14:02:02 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc: gerrard.tai@starlabs.sg, horms@kernel.org, jhs@mojatatu.com,
        pabeni@redhat.com, patches@lists.linux.dev, xiyou.wangcong@gmail.com
Subject: [PATCH v5.4 3/4] sch_qfq: make qfq_qlen_notify() idempotent
Date: Fri,  8 Aug 2025 19:31:36 +0530
Message-ID: <d37d657c588b265494ab8afe030cd72b1d7fbaf2.1754661108.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1754661108.git.siddh.raman.pant@oracle.com>
References: <cover.1754661108.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA5P287CA0045.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:175::11) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DS0PR10MB8149:EE_
X-MS-Office365-Filtering-Correlation-Id: d784a714-ff83-4d28-df36-08ddd6842624
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eumLFXWWmbIkMdHlYoFW2FLYyId+FuoZqn1w6elE5wUSqSg4Udl+oH+WGS3l?=
 =?us-ascii?Q?nqtBvz4NaRFnzdTjJLEg4RGwTCjrpbP6BnbcVilmI1KBl9r+vumVnHer2Ceu?=
 =?us-ascii?Q?cd0X/l9YLhJbxTzc83gxGBhwdG95u6mVV5OSql0aY+vO2s6TS+heI8P5CIBh?=
 =?us-ascii?Q?kAKjz4XP2wSuaAi9FNj6KpSr4MAgJw1Omu7poqmUBDCQCo/bUJBZwjhTOjPC?=
 =?us-ascii?Q?WmhV1cWI5C4qNBYqOMHX3k1Ooe7BxfbYLy0tfqoUD3VLsb+PCEzJPE46R6to?=
 =?us-ascii?Q?R9pBMFnhnVavwhdf8HmjwQhq4bbDwJbFL0BNLGzcALSPp+yH4SiGhY6VpXYP?=
 =?us-ascii?Q?DL0Eo3lS5Z/pT+Q5j9sgqnmsXMWI4fjCmMPPipsXceZHBtqG27cJwWHf17IX?=
 =?us-ascii?Q?oDkOYyASq/LhrbBjNz1ctTPlW0NezZmjo/63/wI2p0WFQXg6qZ1WzmZ6Jwvx?=
 =?us-ascii?Q?hYmn/13uC9rUoGCi2IUPpbzMxXRRVQtPBNLPzTItAp0xww5v+575oFDs9Wgn?=
 =?us-ascii?Q?VJoi5B10VN0U3OmBJmsmsWkN5h0X2xu+98hvRvO4A4Wr8v/T+6ceuJH6CLcm?=
 =?us-ascii?Q?X7zhkT7r4em/HtFJOMM23aJqOFvxyMQrMEy8htfW2riKs8Ng1tacrChrFmnK?=
 =?us-ascii?Q?aXtj2cUV05PowKZTZcSEMh1rkjl4v6Qi2SofeRIGsVgFfvsN5vgeOOE5HqNd?=
 =?us-ascii?Q?0HrA4e7XfvPfzy6ShlKUZrtiPzHWgaYNYk42TAd82ASW6N3T/ufvn06Wg3Dk?=
 =?us-ascii?Q?XOdaR99E9QxVT72tMdlUV86gU0idgGgwC5Q5zM0/jsC/2f9nKhUcBehM8Zw2?=
 =?us-ascii?Q?zNbvrd6ZjOPykxbklsp7wIWJzeFWtp2xN/sgelS5U3d3N2WCAbht+Y6uXzpE?=
 =?us-ascii?Q?tLQ/NcJPJiPalg7RkUkilFmhiy9HOB+tlXsFXZ6//xPZbOxkYS1mwmGumjs1?=
 =?us-ascii?Q?vx3HfFa/cIFmhUqXsIKaw/SG9Oy3B0+b3sGRTSSayx/Tse0SYTWC8Vv5seAh?=
 =?us-ascii?Q?J2A7X5cnIZ+oAAhGlQNl5quq+4SNxxB4XsN8bZ92Rgq0in79m9NQxt09yuij?=
 =?us-ascii?Q?DzpuzAaREPkGhdurdVkbegd+YVzuZu2a/yfC7CyHKkWuL0/nDYaM3fLEMAA2?=
 =?us-ascii?Q?bPU1U+DTwz3WB39IgDdGrygqtZ2FzqRPt/8COYaSm7mgWvz4ILexMfbDY6UH?=
 =?us-ascii?Q?92egYq/PlWK1w/qYa0s2chmvMzkN3P7+eQG4I/WTZ8Nt7nB7y1aiUfbTd9bb?=
 =?us-ascii?Q?9I47zYp6TmOBao5OqbCgPNJ5juYBFL8dtNBmy+fLIZxy2g4phNTTklTfWcLU?=
 =?us-ascii?Q?svkThVM0zUKjfc9o+HwTrRhXIS30cYelwQROGF1uxFBLYDq1dhwM0L9MOavC?=
 =?us-ascii?Q?tI4s2CI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+KKp1agdjMJeCT9hvNXRnR5N5MfhZhJT1GdcWfIglM8NDsASr+oBh2y+0d57?=
 =?us-ascii?Q?zUwHc5PRjabnvQpjy6vsi3m6ayWu3rqeaQrvUg/k9MqVu5FxKASik3rchXB8?=
 =?us-ascii?Q?2ZHred74bHBcMsj6aI1jdmbHxoLN/jF355iKAZ3PqV5jNSdUv+6xG3KM41GH?=
 =?us-ascii?Q?I02X1gqk2Fz+x8AS7nKbsDUSmXdy3wkUaQ9aRJezDKArL1CqSPsMZy8q0HZ7?=
 =?us-ascii?Q?KKSdsNn5x19Whvu+TksalN9FvV/KrlFq8Cz8qnaClvOI63T2X2DHj3URgOhD?=
 =?us-ascii?Q?KNX6tpJ5Lf7rav0pJH9fgD+9R3KpU3bOFt9wBdPb3Z8qNSBsaItF6eDEP8fH?=
 =?us-ascii?Q?Z2V6PGCwgb5SUlkNNd8mdEq5TqG9HKJqCJfwsj+vUBDEQbimDnc2KQvchrRY?=
 =?us-ascii?Q?jGURHCU4ZszsUkKeaEN9lIbuy4MAn9FQawXtNZw+S4SORIIPM5OSgLIU/ROg?=
 =?us-ascii?Q?dw9mjaOZ+1tOmxlTC0/rZk15Ex7IQsQa5v/g4UULzbvTb5pm687iX+o8Q+hb?=
 =?us-ascii?Q?HdeXzlTYCTMV46incDIp9A3/38/bj2hODdiqMYB4JNlqOZ3II0hUeau33jXl?=
 =?us-ascii?Q?9ISVZ6X2axWaH7JsOdtlAOd8v//v7IySgW6ak/ju6oRyjj0uyfnA00Mhv7Sz?=
 =?us-ascii?Q?/fAnLdC9UcFk7prGk379SBdsFm3vXw+oi9/JOKsHVUudSvGKNLmSzFnRZGin?=
 =?us-ascii?Q?Qg48wL8usFBBw/jkz3wLto77HXJOdYJ2gF3JBywGwvJBRzovmsq4GA+gqHb3?=
 =?us-ascii?Q?uuBu8C5SVjeXYOO1OTjmGu01QgSTwwc4be8yrZvMDVr58DnbDhG0uoKuL12A?=
 =?us-ascii?Q?rRI2xuvtkYUbu0sSKxtBlIP/i8sAhgB6Y4tGIVUCGjykVrg5/N07tFATK4pm?=
 =?us-ascii?Q?tiGjmMRhYxV1Gf9si0qxI/qNla6KvcKMAfOFVL2YxQCXzfA/R/LeGvO2eeSu?=
 =?us-ascii?Q?Q4ElaoIYl33RDxw1HWN8MKOY9svAtK4nmKVtJ4Tizk+pSvsaWELAh4J4BO2n?=
 =?us-ascii?Q?NomdBleB2UouHbqn4QlyzYC/4vryHFgvPMHs8P+q03qO3A+Oq7WBas/lPYV9?=
 =?us-ascii?Q?GWok50o2u3h7bEBCUouTZxXBKQUqt0VE+M1ks6MjgU5IluPKIuDA3cptoYkr?=
 =?us-ascii?Q?jeYIBIt6IPP71wWueYDVdZVfLjXOj1GOFZY5kwDQs1ewD4CEhm7sgsqQ+O9A?=
 =?us-ascii?Q?KzGJG1f2OXw+7Ug6NamldjrgDAavgUW4r4rG4JlFh00T1qyWTV1hDx9F9A/R?=
 =?us-ascii?Q?FlXjfk2viOIp1Ro9FsIUhpUjnq+CgPjJ0rBOMjJMJUji7MjPsoQ0lTBDsCR3?=
 =?us-ascii?Q?o9mshnOF8ACwcej0sG8RtGxUAb9Uuqz/DGIJi9dug8D+xw6PwmEaVIhWv9Xw?=
 =?us-ascii?Q?BftYSOQFSlb/QB4w3+jC/JjQnhVZns1LM/DNKOyXZ5UThMsQkqk0ENglx/vQ?=
 =?us-ascii?Q?nsWE6RGSww/3SxeR6XCggmLv9W1Yjym8FAywc3HT3e7WtG8qIU69571E/Yjf?=
 =?us-ascii?Q?KBWbfK4TXIxW7dIHLbHBQDpmb872dxC61wknxh2vFJlhPaW2hzj6yq0XzHwG?=
 =?us-ascii?Q?YDKzJn9n43dDh4C+C4+cw0XDjryEw5ibRq6QSTqwjEjpVA6Bs7r81+1NVmCC?=
 =?us-ascii?Q?CxZiRvcFyVm5osNVEmJ6vzRb59rur1LbHE6hyy7IDSQ1eJpexwWJ2nvc8/zw?=
 =?us-ascii?Q?oC63+w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TpsFq5p1XzkeAWqNxJ7+Qylzm5Ghdm9GQQ/kycIZTlMXSVjadNhc8mQRTjeutqIJI1+/jrHh7ixWLqeRCDHCtaJ9as+6DmKPyyBUOgkwJ07DaUNKC3vX/tDKSxCrtLi1W7KRPCaJOcuQPkwoKEpiIaCZBS5kzRkkeckltU11TCRBUJKPOHrH879T3OLKUsufgJW5y/nWkVutonlH846pYia9M+6URhBllyzAoOWsCq4oeWO89bXFAcisC6/ziu9ZiKSW1EqgiPHFSMjijVomyhOR7m+5uu4C0c9R35ayHE6xOQpaY4Idwj+KIdE4R6FvR24O7HtP+3VEemO1rFESiJPO0/u9sLheUn1Eweb/wbcRpu0oSI/Lw0PUb3j9smSS24KaEkzIAFcs87SwrHEptUw37XuBsX5BimjnEBMyzgzwZ8quSaTH61BxXRzerSeZLcPkPbMZJl+SbzcuOc+5fq2XuvHhgZf0imUUCRsyN2JmtCNOwB10YIpS0mBVdzlalJQXLOb2vy5o4uPfQqCv6v8tiIYpH8MA8lc7HlIehCTKxtRiU4ZzmT6lelRAomvEc9bMFVMYzvhDGkTwUECstmrCnjFsAWQZcLc7D8+VFvI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d784a714-ff83-4d28-df36-08ddd6842624
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 14:02:02.1993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 31jPzR4w+Ig5oMsR/8fOS5hm7kkTGMZa4Ddy0BXnxjeVmuFM2mB0deA1vfsXo3RjNr2W1ZR+bz6knOUlkTg20zl++Et2X/g8yv6H8HOyMHk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8149
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-08_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508080113
X-Proofpoint-ORIG-GUID: jWxs-GFFK5NUwXQYu7sWhBs2EoBgWADS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA4MDExNCBTYWx0ZWRfX5oCOD+Os+nxt
 +MXzPvP7U7lQOnDXCm+I5sBEu0kgDH5+HgxUH4NBCi18wWa2H4MT4J7onh9eQ7RgHhVW70Xyc2F
 Z4h0fGLk9iCty+D8e31ockSCXIaDTDqqTKA16tJB26jwO61LAfv5PMp9AN741AgoI4x3KWJvy/r
 yX4SUIqXgZatevStWWAjRGM1B2wxfLNFWXPxJPjBL8OsFzv9s9w/LWOADJljONBGdmAIZ/ZH6x/
 neqAfKivfpr9uDMCPfMEt+CUezdMO6zBKfap+mRSdnlFHCdMWQxwQfr2b7Rhx/vvwLP4yRAjVjc
 IeZUpopOyEc3HflFwIv5kSPi6csoIdUVa6mBaf1GqLpBXWUEa8eVFfzpSMyO+wYN8dCrzA6d4lQ
 f9pwln/bdT6KsJRBb86HB8n18BhfaIzlhTu/7svhrKOzxfmdRmrsvwOOiXc+osskxX9fUezh
X-Authority-Analysis: v=2.4 cv=dobbC0g4 c=1 sm=1 tr=0 ts=6896035e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=bC-a23v3AAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
 a=A7XncKjpAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=ywO0XL3laA8Yjrm7ejMA:9
 a=FO4_E8m0qiDe52t0p3_H:22 a=R9rPLQDAdC6-Ub70kJmZ:22 cc=ntf awl=host:12069
X-Proofpoint-GUID: jWxs-GFFK5NUwXQYu7sWhBs2EoBgWADS

From: Cong Wang <xiyou.wangcong@gmail.com>

qfq_qlen_notify() always deletes its class from its active list
with list_del_init() _and_ calls qfq_deactivate_agg() when the whole list
becomes empty.

To make it idempotent, just skip everything when it is not in the active
list.

Also change other list_del()'s to list_del_init() just to be extra safe.

Reported-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250403211033.166059-5-xiyou.wangcong@gmail.com
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
(cherry picked from commit 55f9eca4bfe30a15d8656f915922e8c98b7f0728)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 net/sched/sch_qfq.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index c466d255f786..6ee07e5ff701 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -348,7 +348,7 @@ static void qfq_deactivate_class(struct qfq_sched *q, struct qfq_class *cl)
 	struct qfq_aggregate *agg = cl->agg;
 
 
-	list_del(&cl->alist); /* remove from RR queue of the aggregate */
+	list_del_init(&cl->alist); /* remove from RR queue of the aggregate */
 	if (list_empty(&agg->active)) /* agg is now inactive */
 		qfq_deactivate_agg(q, agg);
 }
@@ -478,6 +478,7 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 
 	cl->common.classid = classid;
 	cl->deficit = lmax;
+	INIT_LIST_HEAD(&cl->alist);
 
 	cl->qdisc = qdisc_create_dflt(sch->dev_queue, &pfifo_qdisc_ops,
 				      classid, NULL);
@@ -991,7 +992,7 @@ static struct sk_buff *agg_dequeue(struct qfq_aggregate *agg,
 	cl->deficit -= (int) len;
 
 	if (cl->qdisc->q.qlen == 0) /* no more packets, remove from list */
-		list_del(&cl->alist);
+		list_del_init(&cl->alist);
 	else if (cl->deficit < qdisc_pkt_len(cl->qdisc->ops->peek(cl->qdisc))) {
 		cl->deficit += agg->lmax;
 		list_move_tail(&cl->alist, &agg->active);
@@ -1423,6 +1424,8 @@ static void qfq_qlen_notify(struct Qdisc *sch, unsigned long arg)
 	struct qfq_sched *q = qdisc_priv(sch);
 	struct qfq_class *cl = (struct qfq_class *)arg;
 
+	if (list_empty(&cl->alist))
+		return;
 	qfq_deactivate_class(q, cl);
 }
 
-- 
2.47.2

