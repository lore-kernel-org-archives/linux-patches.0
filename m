Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2F32868A1
	for <patches@lists.linux.dev>; Sat,  9 Aug 2025 15:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754751882; cv=fail; b=O0HiQS2CbKtboRW4AFGPsv5hKLhirga0fLuOam0Co/W+pAmtVj+pY6FtV9PFtjlCRYWXglposoyRFuyUevtj/LT81mNAIrj2IL0DYQL/DsMcfYLBhk2aNnubE7aLUx+vesSRnGANIurShSJUozTp+bce6OXtnTNdNKDTFFI0fDw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754751882; c=relaxed/simple;
	bh=qKOHsRdHDkQuKqkSzHpdWqSPoOcKuSzjvVEZ78Lw49Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kiJ0bL7fGlRsJSTLicoFudTAkgqLvJnp6CQvnLZblw+tvjpO/gPHA+ivlqMKX8iukPu1DmdOxGeDuNYymIt/BZP8u+zRTgHv0DVMfGon0uDZGzTNJ8SibqVhiHKGhhqEehzC4NTcNIroWQ7YZxJO3ByfyH9/Jim86XA8YX7XJtQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=icOtHf2U; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XbC3CopF; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="icOtHf2U";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XbC3CopF"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 579AnpKE008341;
	Sat, 9 Aug 2025 15:04:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Xw5h8s0OvCoVdsfsyrb69+qFMl4ZTOKrdVtpEO0YmHA=; b=
	icOtHf2UrYQe2UWOMZPJps+CRGUO6QkErgLxyCE/oIoN+bjn9tqPXtouhFShic9f
	UdVej2+nx4pRo2h4XsvXSjUrtXJDy6eFpw7jDVkGhmOzc8Y8bQBi3cD2HTWwVP3R
	W6WVn5yaFjSAsQrseefdKhQcxcWJP0B6jgNwrzU6VV4LDyAgcpDWeOrj04xom6DU
	TRITysASFpZFkO4Sjb7s/4u/bAMFKNe3W1Y5m2JQMEFhBPpKmEs3KdEgvlWxlNX0
	2+XNUvV0IggT6ElEmNVgRbCeBkns5LYewonXJTwS8wq1aT+6zn5ELWHuPplCRjuU
	BqwxhOzVIx6FlFNY8pXv2A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dxcf0a96-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 09 Aug 2025 15:04:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 579DLBFX006559;
	Sat, 9 Aug 2025 15:04:36 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2055.outbound.protection.outlook.com [40.107.236.55])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvs6vtbq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 09 Aug 2025 15:04:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dv0iuD+tL25Ol2cIIleg39oRpqs6f348QVeEI16wquqt6XTl1ldf9MIPcyJ1gVmwU+l8ji6oBt7RVfhlYC9sjfRod6aXttZsBTuCWwe666kX/SfxYdUPHy2t7fxm2E8gos8ABSEMShdaW+l/SFBm4RvV3Q6EtnG6pydjHkC4HTIUuC76wsgDVI449BcS8INOiTYG3JaruvAJoAvBujvEFavKAuDBMksXOi6qcBa4tlJ9F67q9LryWyjVs+kYwTtuFMVb0NzCvFNG7XPx24Tcfxw852x2uML+WSBuqFu3gCSTU45XR5by4Z21oHXZtzRQ61ZgqclQwcOcmGx6ZntBew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xw5h8s0OvCoVdsfsyrb69+qFMl4ZTOKrdVtpEO0YmHA=;
 b=TnJdHZ8/OUEFXkZrT5kS/5GpTeymJ9ih4NPg7tAOuS1HetStcbDpObFu7iA6jvwkNqXyhRBctv7tC0XUiiQ2nYuHTYdzk5Lwc/aeh+YAoWZ1rJ44ycBZlC69ya7EtQE7xDgUqLFoHyPhSmaqikrS2bY/QAcWLc3ZgWnHxWR6B9aO42b4Q3JuWF2BW8bzpdVzGem8T8aO2AgQ389VmioGAbeqmhgoBlUM58Fbn3j75ni7nEzmCQ8t+2262Dkotu1ACS77ZEAgiQmYlgdCrfPN6QrY4xfyaKCYACoHbhul8yiYl+vN8NiQbG8qnRXQ/Pe3SAxD/wmzIhuQVBpKWGO6Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xw5h8s0OvCoVdsfsyrb69+qFMl4ZTOKrdVtpEO0YmHA=;
 b=XbC3CopF7C9PczuYn+7u4ZMUsdzFLmTDaRtLuyPb4tDK6m/2UW66zT9HFXQB/yiRipoMC4xTm7Ge/0Qh2rCVpirU2KDFOcRSPOcGZWUeDfBLhmsxS5cv4eE2aKk+lD7KeL1TxOXPazbAuR1O6LB9u9MZ+Qtm5M66OMyLMVA5VKg=
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 CO1PR10MB4724.namprd10.prod.outlook.com (2603:10b6:303:96::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.20; Sat, 9 Aug 2025 15:04:29 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::156d:21a:f8c6:ae17]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::156d:21a:f8c6:ae17%7]) with mapi id 15.20.9009.017; Sat, 9 Aug 2025
 15:04:29 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc: gerrard.tai@starlabs.sg, horms@kernel.org, jhs@mojatatu.com,
        pabeni@redhat.com, patches@lists.linux.dev, xiyou.wangcong@gmail.com
Subject: [PATCH 5.15, 5.10 3/6] sch_hfsc: make hfsc_qlen_notify() idempotent
Date: Sat,  9 Aug 2025 20:33:58 +0530
Message-ID: <8f1d425178ad93064465e15c68b38890b10b5814.1754751592.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1754751592.git.siddh.raman.pant@oracle.com>
References: <cover.1754751592.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXP287CA0001.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a00:49::13) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|CO1PR10MB4724:EE_
X-MS-Office365-Filtering-Correlation-Id: c3e176f9-10f5-40bb-68d4-08ddd75609bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EKFs4i3iyxcdXxLu9/a58a7acSmeBxhl+nY0N+wjDY0Rqjfpz7/0AkJP6QcX?=
 =?us-ascii?Q?JmRwdC/ehAiACcaPRo1HwqlBHiESdOjyqFzm/KdplDWQ8vEpoQ28bESOR1pH?=
 =?us-ascii?Q?mpI87nCMBNzK1C8Ar3kRByg/GKUvPptj3CJtTknJiQrM7KJARioDyAUqQsey?=
 =?us-ascii?Q?hTsSYE7qTFAb7z17fpiOsBycWba59I1Ncixg+PSZKj6gIWc4ddqbnwKYpQJs?=
 =?us-ascii?Q?c+NrC2LWEWvTbbgqPww0B4HWiyR2sCBtd7wPiXnXLg/iCcgKnkdhVv0iZa14?=
 =?us-ascii?Q?jbnnvfsyp5EwQYV/bKLOi8feQQxZ7s942eSOm3I5Tmqt32+PX0FQwjb/l3p3?=
 =?us-ascii?Q?QX4kcWTqbVjOiqNEqXl+1CeqRvTrNfhYelVxa3ChOCzduly4dr1RECJCmpZT?=
 =?us-ascii?Q?KUOMGP18dinGtkArBQfIYCwhYA/kJG5+e1e4jO9iDcsEJe5ngmHpghKLU00Z?=
 =?us-ascii?Q?gtf7ElwZ8mxDJv5dU6SeV5nkbCJM7oTpQcGTYa6C98JkUay/w/MVRWukqcrr?=
 =?us-ascii?Q?fExJtTzrdLU1P6PU/OpITorGx3m/bHkhMLIc65vZ08a4FviTt8aBwSvE5jC0?=
 =?us-ascii?Q?YTO7K9vyRCoLp37yT1FmnO/pdlCfta1HSXfEG+gVals+CAp2pv5gdJFBOOBP?=
 =?us-ascii?Q?TeStUuCIsAEtP4sp3HDIRm48/ncC64ycVn4cfmAMohdq18Bhm9n1TifhHbsU?=
 =?us-ascii?Q?rVObNYhBU/mP0QbgY0Sf6NNy7O3cK1bYjX8/2UjPnUedLK6VesNVCaAh6T/A?=
 =?us-ascii?Q?YoJPCHECyoX/cSUD8fISkD+/fsekVOjfLPJmHdRLLmasanaRHiYWUCmdLOV4?=
 =?us-ascii?Q?lhOjck/SWFkg+9iJRRVK36l0czxe+586fdAoL6Rgnv3Bbv+j1LXI/ILxHdpP?=
 =?us-ascii?Q?dhce6UrllDqh1C2dkJ69MNd7j2/oUHrskysqIHoHoBpzRTdFuwPoQmVvNTsW?=
 =?us-ascii?Q?4V0XGtRZCs/pqSqp+2rxPK2+BMlIIbUYQj9qia1nehM4l3NY1wIsWUfyAWnp?=
 =?us-ascii?Q?avX19nPNm8kWnU/92gJTAMIAbwOcSjPaE38IbUQLNJ1u6golrCyD4EuasjE/?=
 =?us-ascii?Q?f9K/yvzzfePjZsf5dE4KCrZfL+Xh/0A8AeUAAVz40jTe7InN9j2LFYW6OmPq?=
 =?us-ascii?Q?7a83nszgkhXZcQ957hzN1DR7HgMZiXxQmwXVi8XYANqkqpQy+TpLZtT4gaB1?=
 =?us-ascii?Q?PB3rl0vQpbbYtsvuiwACHRO9pTYaKoEuItqG5SzKkSF4Z0JMTcNCHN49F5Ip?=
 =?us-ascii?Q?qxY5wWLjwAGS242wuS+FuaVvkijx5zKlKiC/ki4meZ6WSrALVoY1vuolYCdx?=
 =?us-ascii?Q?RWw/LQocilcLuERSqupVDG665qGVSILTPXrr9DfA0Xo/vCrgluk5Q6DxXDso?=
 =?us-ascii?Q?tSk/g9M=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kn91/u2B7CJFLe3z/6V3BxNLwbZ5JwVgQdPirdxPI741M2MjEDyw/p4jvRIv?=
 =?us-ascii?Q?JD9MRKZrRa/3eiTOMzQSklnAjd+2KlEOqTz10H6kvdPUmAgOnR9X/47fQm9k?=
 =?us-ascii?Q?EFlmZOl/kEkuk5DSAC5EEi8Y/NEfQv+AnBlZIp/9dQHL+tLZe7ezjwbvZg6Y?=
 =?us-ascii?Q?Bhavcq81xbn2497t9yIQ1DHfncSfGT8vHsan6//fOsVEySGY0gsOfxaWxzBC?=
 =?us-ascii?Q?9AK7Ht3MNTegIAQ4/NxwvJISqCfyrLYx/+QxpQLiI1ZdK6bQhtKucayag5et?=
 =?us-ascii?Q?OcLyIv6G00Qw0w9h8ZCvYWKauQv/J67dAKyT/4gDWP778dS9AqJ/fBI7Un3U?=
 =?us-ascii?Q?x24cezPwkhT25iT6/Yhxy9UlQJZgAgJ5ETpf1FUEhbqlqOdZpZxIW/zKrYfM?=
 =?us-ascii?Q?N62cZCIfn4RfvIy8CcHFZwUMP6pSq5RQPtp7bJVsl7eNe589IqKrKa47/x3i?=
 =?us-ascii?Q?b95GAV4zG5TfaGgESI9Jygo2GttDRtrkc+6GTVRbum1ZAha2GZ0DG3nf41TZ?=
 =?us-ascii?Q?S9WHpGfMoL098erVRMGWsfYuBB1fGAVVVle1EXuax2woBx/ROytvbaqi5zYF?=
 =?us-ascii?Q?8xGLKVmHGu86Z8yhovvRkrFsmJ3gtIiA3Iv8ugLtFkx+5CB2q5LCsdZv/8au?=
 =?us-ascii?Q?oTshJezzet+G9S6/2THQz84t9gWznt1iJm4nbD0vZf2poDsBjg7fmIaq4UOJ?=
 =?us-ascii?Q?Y/32Uacb9mruTC0fNA3DIOxPN1IhYpt+3d9VGCs7BOHrbisFNnCN5MFFE3I3?=
 =?us-ascii?Q?ce4AjXo1ABongOX3mTqdfacY6SIomSDEWqOZ+DpTuIVDIuCwXAPRXeRFwgLl?=
 =?us-ascii?Q?LVm/O2JIox+cYlvKaIBhYIQE1QlTdF6/5HDxcXxCJt8CHxQvp2QEvpx0vIsg?=
 =?us-ascii?Q?4pRDjztqyM8s0PduNFzndbVvWLEV+6kqK1jwUIo1cpBHyk1OPxefonuowbdl?=
 =?us-ascii?Q?gzdIbyIQ6JDWEV+OA8YhUARB6YNS/UFtJ1keJQ4xu3a2DR/GGSonqxijyk/0?=
 =?us-ascii?Q?OSJ22fmI83RFMowJ4vuRCDO7AURVzjR2VrgqbgBU7almYV7MWs16mq5HjdW8?=
 =?us-ascii?Q?Xi7IgI9vNkR8D4hx7zSdP8QF08ne9Vxo2TqP2KDZijRgt0xNcFVpQxfZClhw?=
 =?us-ascii?Q?k3ykYq/oJmHiyi05x2Padm+mBAoBpyfQevUf2sm2GF5PYHEk2FZh8wpAmRrY?=
 =?us-ascii?Q?19AWAN1F3+8ntjefLSKluHmGF9y9PKkRMqQqLaKDH984BI+rhWIcKYwHGOIv?=
 =?us-ascii?Q?XM6fU8Zqv52BgNscxhgm+pe5+v0uWQc1+2+XSAk3hiG7IDm0oZ+euEHRlfaH?=
 =?us-ascii?Q?vVlgX5256/9VA218xH+tCatm1T9pxdNpZmG21mM3jhIGZB0M8kZ+xyGP3l37?=
 =?us-ascii?Q?vBlBZ8pS1YDpI3N+eHqkj4NK7EW29KdsqVXCvAY4syFxWkvsLg+MKRfTgQK3?=
 =?us-ascii?Q?dM+2KBoD6aUZrK9xqFysJ5R5btyElt5cVI7wLOlpd8uoPTrCiLuF6Tsn35is?=
 =?us-ascii?Q?kVIIktVgr/j6jcp4KDHAtSFMZ63C7lN6r5U69Vt7KCn21edFZ/1xUuPpOu4d?=
 =?us-ascii?Q?iG+0LoxTYP4ypcVpHm88u1AzbKDWTBNp9QIoDid9hpf8wzXif7ZTcunMYh2u?=
 =?us-ascii?Q?MaNhjfWRQ082xH6bGTYzda9w9pUjka3npTn5g40JRVh0DAkC6A/Yj4AbDIYw?=
 =?us-ascii?Q?qLofNA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QMPvibznTE1Lj836IujEzZ6Zs6aok24OFBwFqEzA8TGq4stw/QufFumuMDI9w6hGdlgj63Z9lx4XCXPD4D9BhWdDdE40GvMxyFF8G5iGDaNRhei8mf4ruEWJtznQO/0kMcI2Zl9mQ7aOCDnY34vM5h3qKZxXiI+dHtk6ZGaX8pfvvMbq13SpBXO2pQnnp6Hx/4Kjt+at3ClDunnViRLrcqbhlVeCIsKWBWjsaZK/RovQ2Yd0T0TwirMzsWSL0Dwe4NePH5wsktgNz8NwBy6NEOURyDC0b72tpKTcYw4Qjy7n8bRO5kWStNXCFNMEv2MxaBS0Qv2oHQrX4fLAq+kavk6zpZuaDkGZs6cjlZizdUAJ0nAwgeTOjzMdnGwGGIhE/eexYnP33AAmcPEbtNF7Gkdn6/HNP9/xJW+QkM7mmuyIuWXgSGRIO7MioN4cw+j277LBWNosQhEvgwhpF3gtw89SqjJgyNQ2+vnGdN/LFgSEb4mwFF56DLRtEhnZnwPgqUL/UXXDAUYmIa7NZ59RBbpr/Prj5dKhzUnP9BC717SkiKxW5kE7S1v880VLT34Ubk/Aj3uWvhi9Y9B+aT5VZDGuHs7KPA6EhKE/I1iLohA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3e176f9-10f5-40bb-68d4-08ddd75609bd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2025 15:04:29.1158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NCTCLCm+Jan9IkusRGy6UVlWe4N4FVLkj4ui8WmtksYAYjUuvUNigdEQe0kEd8iz/JnGquqqJwTHoFPdZsRMyJvSA8/YfrjrcoIGslGbXXs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-09_05,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 bulkscore=0 suspectscore=0 mlxlogscore=818 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508090122
X-Proofpoint-GUID: dCH7rACAQpuz19xuYHX1Cx75_mrE4YKP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA5MDEyMSBTYWx0ZWRfX14/Kf9k45Dcd
 HUgrE4jtecQYMTjd+5iwB86sIYUU7K1CzwqCB4YO0Lbn4bsfwrxOSrh/iF1izLkGbdR4zscYT9c
 vqN7mu6ZzJTTujPmQGOkL8jfLRRuvLghLX3OoWHRhCNDQMif+rYcAQ+SiFmn4zQPC7AUeTJK+OA
 ya5lEHppFFDB23TPx94saGBMaCb5+WFTjIxRX78OJkHdSyg8lr3k7WjammmtTXkfwoap3LnRT9c
 KWZy279Og060jZGZ5xN2HI87NvZA7tRqv3aO3kKSV4fjbUClkemK/Mg3og3Pn+nr66PABq2iJjb
 yMO+8wwkKX6olyGTUZpAedXs6wa4JLqmCB5Bo+tSJ031eiZb+nJZSDUu4qs2BzHYa2wWyp1iF+/
 xPFs/RCjk5vjXtxgSVkaoC/l0yNLqbnSVXMEKGPLX4neBVgcg6lkxqSXfyGUg01SUDqQ0M3x
X-Authority-Analysis: v=2.4 cv=W8M4VQWk c=1 sm=1 tr=0 ts=68976385 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=bC-a23v3AAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
 a=A7XncKjpAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=Kz4_hzx_z8gknMhM-a8A:9
 a=FO4_E8m0qiDe52t0p3_H:22 a=R9rPLQDAdC6-Ub70kJmZ:22 cc=ntf awl=host:13600
X-Proofpoint-ORIG-GUID: dCH7rACAQpuz19xuYHX1Cx75_mrE4YKP

From: Cong Wang <xiyou.wangcong@gmail.com>

hfsc_qlen_notify() is not idempotent either and not friendly
to its callers, like fq_codel_dequeue(). Let's make it idempotent
to ease qdisc_tree_reduce_backlog() callers' life:

1. update_vf() decreases cl->cl_nactive, so we can check whether it is
non-zero before calling it.

2. eltree_remove() always removes RB node cl->el_node, but we can use
   RB_EMPTY_NODE() + RB_CLEAR_NODE() to make it safe.

Reported-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250403211033.166059-4-xiyou.wangcong@gmail.com
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
(cherry picked from commit 51eb3b65544c9efd6a1026889ee5fb5aa62da3bb)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 net/sched/sch_hfsc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index ca17a5f98a92..4876d9145177 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -209,7 +209,10 @@ eltree_insert(struct hfsc_class *cl)
 static inline void
 eltree_remove(struct hfsc_class *cl)
 {
-	rb_erase(&cl->el_node, &cl->sched->eligible);
+	if (!RB_EMPTY_NODE(&cl->el_node)) {
+		rb_erase(&cl->el_node, &cl->sched->eligible);
+		RB_CLEAR_NODE(&cl->el_node);
+	}
 }
 
 static inline void
@@ -1231,7 +1234,8 @@ hfsc_qlen_notify(struct Qdisc *sch, unsigned long arg)
 	/* vttree is now handled in update_vf() so that update_vf(cl, 0, 0)
 	 * needs to be called explicitly to remove a class from vttree.
 	 */
-	update_vf(cl, 0, 0);
+	if (cl->cl_nactive)
+		update_vf(cl, 0, 0);
 	if (cl->cl_flags & HFSC_RSC)
 		eltree_remove(cl);
 }
-- 
2.47.2

