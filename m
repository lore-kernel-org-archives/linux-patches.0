Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF498195FC4
	for <patches@lists.linux.dev>; Thu,  6 Jun 2024 14:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717684369; cv=fail; b=trkBuAPiPz0QXoGTJjaeWE4E3wRfVAu4GwpBkKotFoWjEylysB9MB6djwaaVPwrlE4JBzIuz/ePLJzKeyJZbpMuww7hgzOsX9D+rotXS/JNJdzFs6dlgFB7UaXy5vSV0R6he6oiv7IeaitF+TEB6rdORMQPCy3oUCgAt/Lf5vjM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717684369; c=relaxed/simple;
	bh=W5XR++Z4xX2okXuiG9jmRKjd4zphcalv8Q6CR0ZwWek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dye8TMpjSGZuZN0yK3lhx0yrp2G3d8U7sIr6ZIP5gmVjJ207YZ6O1cKbbI2xbTLwp8auQI2gAYCtIZ/YhAZlooVCMoo2C5kBro7L0MRxcmX0pFvVqW/nR5RVRf/wBDGgl1juzZ2BZWuCFvpBL6BHZzKSufZAgYjSjurIYvcgppc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WMgrEAQG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oohx1JRG; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WMgrEAQG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oohx1JRG"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4568i1EO032513;
	Thu, 6 Jun 2024 14:32:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc : content-type :
 date : from : in-reply-to : message-id : mime-version : references :
 subject : to; s=corp-2023-11-20;
 bh=94euvAIJ6bausA9qS9Yh2FYrYp5+kxsCvzhjv9wBYiM=;
 b=WMgrEAQGx2Tck8iQx0//9icPH/mTb3/y9zi/k8Hau2SYmCqmdadwq/bA37HDtHrWkL3w
 6kxGyRmJ6dSkVjNxJupEqsulyu2bHsuwKKpm4ORSDz8ayop1Mz2dk4xGIQ1ZeydnKTZW
 FeVzW96Aqgq8fbVD8lz6/IIxLc8+E+URBST4fMrZFK9vkNJJKlm0kve4U8ql1mqUvITj
 b5QbDv3mAaw6cqImdHVMfLF3Y0KWc7BjHujIn3xpMs1+PtsX5UNitJTf9bVcNpCLRkLS
 4hZdOv16aitpoYLrL4a/NHf57gsMCS6yj48q5fQbxVb5EZpCVcw3geXh6l6St7+69maA VA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yjbusupta-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Jun 2024 14:32:16 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 456DhHvY015579;
	Thu, 6 Jun 2024 14:32:15 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrjfbpes-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Jun 2024 14:32:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P9wGveYcR9jLwihBjdA1aUdCt/dL0/GP2e8fvUUn8ZP1iu+X4PPKUYDpgzlQW3apHZm6YVliBPN1gP2T8HwmyMvTR7xd8GT2JzbUrC88myNQSbc7ZOlu1eAqP5HY2Q9xYTGmn0cUNoR3vovILSbVBrStD1zQ15BGpJCtOosrtXICcKRfSdO5IfBjXg6dZlqX4fpuehyFeZdBx67y6FfSfjKdrf3Ru988EQ8nzCHmGSGVYCLXL2PfDpSndxhmzM4YvsHjrNzqeulkYgfDX2IE8mYV9BJfc9O52pMiX4RSFOeLMmI68GAD//50S/js3szsLwhgOeJ4LdKNIc2/k0ptOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=94euvAIJ6bausA9qS9Yh2FYrYp5+kxsCvzhjv9wBYiM=;
 b=h51jpobQJuecUD/ZLKIppI4AtKfkTrSoOzCpC/5cGeJdkd+G4ad814Qj3udImDt3H7Tk9LRPXwjDDglxfXWEq8gLD8tcMMT7BH3WgN9/twL9XWE8jD4A30vnxxxErfdKICwyYKrh051mGlJjqENDjxruvrTMoTPqTn4cmyUq3szCEOcvQWbE/qJzdbIFAhAMF4/TyKpf8w6PCpa9XLJkElHaqLVPEDt4mjINFLjSjCnDqpi8CUGDAP+XFV+X0aAxpQa2B3SCdpIUfxHYsrIeZ5rOSwGLTi2fw8S+grFGUPpgsoIvKjxpLJOScQyM2NGQfqTEDZbNYIL4qDh8WDLe2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=94euvAIJ6bausA9qS9Yh2FYrYp5+kxsCvzhjv9wBYiM=;
 b=oohx1JRGq+C2UQVHWeFLPwN21NwaElozumVX+eGbit+ggGac9hEdYy8FUwGCcxXoaVu+f0lAuNzugTlpJX8VAaEsAQM/E+MoTtG7iam46wXY7PksHWsYFkzenX2o9Ays1F4XFXhVgfP6nrlcjyM6EVX+ggGmSSP3soIDVSMhw7E=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by IA1PR10MB7360.namprd10.prod.outlook.com (2603:10b6:208:3d8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.34; Thu, 6 Jun
 2024 14:32:07 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90%4]) with mapi id 15.20.7633.033; Thu, 6 Jun 2024
 14:32:07 +0000
Date: Thu, 6 Jun 2024 10:32:03 -0400
From: Chuck Lever <chuck.lever@oracle.com>
To: Jon Hunter <jonathanh@nvidia.com>, Neil Brown <neilb@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chris Packham <Chris.Packham@alliedtelesis.co.nz>,
        linux-stable <stable@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "pavel@denx.de" <pavel@denx.de>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>,
        "srw@sladewatkins.net" <srw@sladewatkins.net>,
        "rwarsow@gmx.de" <rwarsow@gmx.de>,
        "conor@kernel.org" <conor@kernel.org>,
        "allen.lkml@gmail.com" <allen.lkml@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.15 00/23] 5.15.160-rc1 review
Message-ID: <ZmHIYz3Imd7HWYiO@tissot.1015granger.net>
References: <>
 <58fa929b-1713-472e-953f-7944be428049@nvidia.com>
 <171701638769.14261.14189708664797323773@noble.neil.brown.name>
 <b2dc17ff-faa6-4ada-a807-ce2a64c9fa29@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2dc17ff-faa6-4ada-a807-ce2a64c9fa29@nvidia.com>
X-ClientProxiedBy: CH0PR03CA0290.namprd03.prod.outlook.com
 (2603:10b6:610:e6::25) To BN0PR10MB5128.namprd10.prod.outlook.com
 (2603:10b6:408:117::24)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5128:EE_|IA1PR10MB7360:EE_
X-MS-Office365-Filtering-Correlation-Id: 6809cb94-d139-49ce-cd5e-08dc86357111
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|7416005|1800799015|376005;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?qCfxBXDKBgReh/CJV2dWcm9yZACwhdld/knCiU05gYv286YMJUg6HaIBNJZr?=
 =?us-ascii?Q?Q1IlM7yUKuuWIk8LH6uIpnf/w/0hoGkUTQo0xWxSqGo79MkPU0Mp19IHWvqE?=
 =?us-ascii?Q?DWmwNkgF70ddjAZRh2pWbLV9HO33fB90XqLW11WPQT1NBCBgBBO7RxBJOk3/?=
 =?us-ascii?Q?T3Naclj6rWi9CafXlBXH0xqyu3dsKROWPK8BfppGVEOrACsK2vwB1mzSbRt9?=
 =?us-ascii?Q?xO5p1nmTeXr5DMDFBkw7Xm4idGqJz5qpkhj2vJGvaUvQu9xSw6uHAUYLqXGj?=
 =?us-ascii?Q?kTOOIP0r9svPqwRo8jEVxpOo2dQ/8eq4wI8QTVnfD2hmpZJ88OC6ob4oR2Pt?=
 =?us-ascii?Q?5EfHr5BJgAd5aY4aeoxm3utxq4n4YA5xPM7esvjRp83PdRdzH1YjKBqyWMID?=
 =?us-ascii?Q?9LDWesZ94dAc3Isy8qTktiqhxHuz6To1RMW2fHIhMuVLhmQTv6Fx4xBXnm2L?=
 =?us-ascii?Q?yAovdyd0BctcmqAbxcanEMqtIdsK4mTbzBFtefEN1CL7aB55OJHHGiEbyGSC?=
 =?us-ascii?Q?uxy5LNLbBq8pjblEK1Jxa8bBy6B3o+u/YqFAh88ZgROsDrYdlPbqAbJF/coR?=
 =?us-ascii?Q?RD8fY3+0wj1qhgicjhaT+kPEAMQfFzkBVodhYcrP96uXtltDW2LNPFCjMXAl?=
 =?us-ascii?Q?0ycuoQ4Dpz+VLqQrDPsDPzTj5k7a47M2OGlRa3JnnOxZhqhJvwYOgACpMF25?=
 =?us-ascii?Q?mEIeUZN+iNvRS9Oo3alvQCQIclfwsLEtgwdpKZV53vz9WgYmtRHF+a5BfTed?=
 =?us-ascii?Q?SC2GHcqEVraiYi5PTy88UkUVRL8LpQCj5rq0juFgVaVmpDT9JP+CoGx/38Wa?=
 =?us-ascii?Q?9HdjpTnCWVjH8zR8g5uzV2o9YcESb+vCVmTXTmDeVuOsQQ3tmLMZ63eIXw/8?=
 =?us-ascii?Q?e6ZKnJlNzufFLe4Wa9xFrjM/UUajQQb8jeMhqMxwe70PQ4xbsoo4kVv/wocC?=
 =?us-ascii?Q?stdBydDHNndIFl24PUtqBs5+xGr0cjoBGbGEMp9OOVcMts+4LNL/2AXgYCWg?=
 =?us-ascii?Q?Zve3VsPu8dogF3sdskURcuMpTBUiNBQQrcqmALabXUDTuAWCk7mO6YzU5FkA?=
 =?us-ascii?Q?NlOFtskEQb5xFlPPi1mTCLcfQoZOTD1jvTTbCTnyAsG1IBTZjvJ14cNZjj2n?=
 =?us-ascii?Q?7vcXji9tMeN5znehejaQ88Ups7d2Oc3XFUyeCnXUZF+YyselGIB7XlBSUH6e?=
 =?us-ascii?Q?rKcX7Ha3lKJ1cuxj6jCNSINJ245Nbyql5dPk5chyZsCYhTRpcH9ZkNzPvOIG?=
 =?us-ascii?Q?azjmfJgAaicw/7CI0Jh9zayfVdmUqrydN5rmydLxedQHz70karxv1r+xVwrz?=
 =?us-ascii?Q?5UM=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?XYdTVEmsgjJY8xvvQkXoqLq8l3A7XwS8juk+lHYD+Pzc/bLjV7XfPin07HLx?=
 =?us-ascii?Q?LhIz6qf5LPQIk5E99Dhk3WABPXRZE3BE8SkKoz8ae+IlQq2MlknWqLJaT/tg?=
 =?us-ascii?Q?1t7QNl+QNrVwYHdMTY2a4fYFRUwjUrDoAJ6oNHH/OwsBjaX9UFtH/NV7a0xQ?=
 =?us-ascii?Q?c+786Zf4TLOD29VZi/3rnHgnGJ3MZbUkd3VTnk5pMZZZ1vPe4OyS6Jgx9GqQ?=
 =?us-ascii?Q?y2ysbU/vgruG2z0sQ8W7aTp3PhUNHlepuJvgP7fcVrltrDRsHerbViGRvonm?=
 =?us-ascii?Q?ujUkavo27a27jC3+PHfTUTdsPyCh5BK2sLcOSJRmCQVduiMA+8WGrbb1prXn?=
 =?us-ascii?Q?wvcABt0dq1gC2EFgrMwJU+W8KV/ixPnS7MB+gyfA5OYZBDXRdb1WCPkeB2jQ?=
 =?us-ascii?Q?MrspDZOV1bgfA9Z3oiZPNEkiKyiDj3Y4tVlm32BOPUl8UFiVJP4PHPNsWvda?=
 =?us-ascii?Q?AWtrzZGO2t655KsA/XRu5CeLxb63P5jXWw+GvNP2/EUSoeXv5Z+vNy4Vxrpp?=
 =?us-ascii?Q?3o2LR8+NurFfM1+nxROq8BDzvLgSN2rlafLwju783rbPVfrYOAX2vYRHMT/X?=
 =?us-ascii?Q?09N3+Cip+oNMTXO8K44R21J8npVKTNK0/nR5LkwD7T36hL+sERXfACaKmW3z?=
 =?us-ascii?Q?M6WzP+Tu6X4KPE23u2A2PsFzd35OPP303ownsSXEyuaP510KI8AyV4t/Uy8v?=
 =?us-ascii?Q?x9DY4A72T/tJFWKfx44t9sBm+GDOsTDSp6Inp6NJpsXbpSMS0nm+Q8Hp9xOw?=
 =?us-ascii?Q?8J9kPmFpocIuU8CkTpEiYoFpNcNnEvNCtsrQv6rkKQlyRAM/paXvd9WkwQEm?=
 =?us-ascii?Q?0uZxvrX6hSwQb/+2v4EcQjhv8rV2jZ+n4aNHo/9GLAUne7zQmzZhASvS5Qqt?=
 =?us-ascii?Q?Zz3vkH5XY8mSE6Si/4SBg6E+l8OqjP1FU8jc5iPrZeei1zLFk9x8Bxf5ZD/X?=
 =?us-ascii?Q?CNfe7jkKfmoVuIl7vV9EuJU0z1pYK6r3sxqlUCS0ZxkbjebIeSGG2IbDs+dv?=
 =?us-ascii?Q?9fWoz+g6BLPUAxzADp1ZdIZoFbeWf4u4CgabPO3rUUE4UvCR3JRhy7YFsRJA?=
 =?us-ascii?Q?ksxrrSgTLyr/tdpxCyNE2mEDc5tsGzWuAqi0ZZPMBRUjI2iTq6T/AWd5K0t6?=
 =?us-ascii?Q?qYNLPjcJTqf04rn5rwaMCICDjlM46olXziyRFO8HEJTV0GEoLyzE/+TpEYpn?=
 =?us-ascii?Q?Z0n4f+KTMjdi/r7ztnGgNLqKIWD+H+xPZjzQFqDMcmCOWmFqMfYUNQBotAPo?=
 =?us-ascii?Q?rpvk/Yi6HGV2dfyv1yE2EnlncZXza8wJieX8JXYv+vW7KmlQ74XwZyNHd36U?=
 =?us-ascii?Q?7kRHG0MAHmoEAQelLGjan/JWTAo50JvAeooamNHUJgKu2tBgAZK+GKJzczVH?=
 =?us-ascii?Q?FQd92FghwgVzEpb78GrrZ+xxCMUvlxbEwOnVxJUe5x3ZznB2PWS02zB2JdUL?=
 =?us-ascii?Q?NO75N82mgJoOuUCbejWQ5BnPbBnUKxUzJqdopY+YYtAoJ2SxvWU6XckYVUVP?=
 =?us-ascii?Q?TfVLXC/w3vIuLfQf3034A/MQ2HgImIKK0IgHj//a1/NOZcq0fM2x8og8rLGl?=
 =?us-ascii?Q?TFVM8hQ+tBDWS/nFLt+21VlQ8GcjH/yQswuxiZK97Jbm5xz1SdCkjSiOjCYO?=
 =?us-ascii?Q?Iw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ZYikt1jGWPHZM6MlrDsBdDpdrLujfeIyRPv643i/mxpmD1GP3ZXim51W1dC5sOqRdP0kwez+I5wwFeS3BpWyB4WJOKVzCm2NQo29AuY+5PNqEAfiJHpuU/XAaW7I1xYpI2d60yGvr7CcSB0yct395qWhfTrC8OQbJX1v3algvGjP9Jxb/d4WXRQguFtfZmdO+zDsCSx67WfKOQDTCslcnQSWg3iGH8qsJ4aFXHvCxnnmfOEmwIl5ypnWrH0Yt7FwJMw++Kgm6sCWEL3QHG+w73/DDtz8RAzHghRSxvbgkVXvYmUUlAJ2kcsmBGXr28gcpkblgaNck11bBtEqpiFBbQDyLRIpXlQH4rsHZMNk+u+olRdKWH+nyXBV+cUVqggAHDjxKCyZBx+2bDwk1e/tWT5hIa4IEistfQtWmFkFoE1UVsWZL698gglUw4Y9aV/79mUGUe2Pt21R2Eazhcs0gLoVPRct+QnSD06AdtFR9kPw1zp4d/cAWpq4DcMS/4nk3JRbFdSBep/tNOMYIewf9rYVOubLFzIXDayT7C33v1ioHz9l4euPLbE04v/ig5xeMwWmstjbseLRxargndXzDg73ykErmO3+LJUCPyMnH2g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6809cb94-d139-49ce-cd5e-08dc86357111
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2024 14:32:06.9659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1YmKLGctz+F+51e3gSti4wmcPZA0hEjjyS8P6M1M9mLULGBGZwRh0NX1EAf57cI3NzzOyH977liKb1pxMB6lDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7360
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-06_01,2024-06-06_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406060105
X-Proofpoint-ORIG-GUID: 1gX_fMd_0YEdBs1kVkSHZzIegJNPx56M
X-Proofpoint-GUID: 1gX_fMd_0YEdBs1kVkSHZzIegJNPx56M

On Thu, May 30, 2024 at 01:11:47PM +0100, Jon Hunter wrote:
> 
> On 29/05/2024 21:59, NeilBrown wrote:
> 
> ...
> 
> > Thanks for testing.
> > I can only guess that you had an active NFSv4.1 mount and that the
> > callback thread was causing problems.  Please try this.  I also changed
> > to use freezable_schedule* which seems like a better interface to do the
> > same thing.
> > 
> > If this doesn't fix it, we'll probably need to ask someone who remembers
> > the old freezer code.
> > 
> > Thanks,
> > NeilBrown
> > 
> >  From 518f0c1150f988b3fe8e5e0d053a25c3aa6c7d44 Mon Sep 17 00:00:00 2001
> > From: NeilBrown <neilb@suse.de>
> > Date: Wed, 29 May 2024 09:38:22 +1000
> > Subject: [PATCH] sunrpc: exclude from freezer when waiting for requests:
> > 
> > Prior to v6.1, the freezer will only wake a kernel thread from an
> > uninterruptible sleep.  Since we changed svc_get_next_xprt() to use and
> > IDLE sleep the freezer cannot wake it.  we need to tell the freezer to
> > ignore it instead.
> > 
> > To make this work with only upstream requests we would need
> >    Commit f5d39b020809 ("freezer,sched: Rewrite core freezer logic")
> > which allows non-interruptible sleeps to be woken by the freezer.
> > 
> > Fixes: 9b8a8e5e8129 ("nfsd: don't allow nfsd threads to be signalled.")
> > Signed-off-by: NeilBrown <neilb@suse.de>
> > ---
> >   fs/nfs/callback.c     | 2 +-
> >   fs/nfsd/nfs4proc.c    | 3 ++-
> >   net/sunrpc/svc_xprt.c | 4 ++--
> >   3 files changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/nfs/callback.c b/fs/nfs/callback.c
> > index 46a0a2d6962e..8fe143cad4a2 100644
> > --- a/fs/nfs/callback.c
> > +++ b/fs/nfs/callback.c
> > @@ -124,7 +124,7 @@ nfs41_callback_svc(void *vrqstp)
> >   		} else {
> >   			spin_unlock_bh(&serv->sv_cb_lock);
> >   			if (!kthread_should_stop())
> > -				schedule();
> > +				freezable_schedule();
> >   			finish_wait(&serv->sv_cb_waitq, &wq);
> >   		}
> >   	}
> > diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
> > index 6779291efca9..e0ff2212866a 100644
> > --- a/fs/nfsd/nfs4proc.c
> > +++ b/fs/nfsd/nfs4proc.c
> > @@ -38,6 +38,7 @@
> >   #include <linux/slab.h>
> >   #include <linux/kthread.h>
> >   #include <linux/namei.h>
> > +#include <linux/freezer.h>
> >   #include <linux/sunrpc/addr.h>
> >   #include <linux/nfs_ssc.h>
> > @@ -1322,7 +1323,7 @@ static __be32 nfsd4_ssc_setup_dul(struct nfsd_net *nn, char *ipaddr,
> >   			/* allow 20secs for mount/unmount for now - revisit */
> >   			if (kthread_should_stop() ||
> > -					(schedule_timeout(20*HZ) == 0)) {
> > +					(freezable_schedule_timeout(20*HZ) == 0)) {
> >   				finish_wait(&nn->nfsd_ssc_waitq, &wait);
> >   				kfree(work);
> >   				return nfserr_eagain;
> > diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
> > index b19592673eef..3cf53e3140a5 100644
> > --- a/net/sunrpc/svc_xprt.c
> > +++ b/net/sunrpc/svc_xprt.c
> > @@ -705,7 +705,7 @@ static int svc_alloc_arg(struct svc_rqst *rqstp)
> >   			set_current_state(TASK_RUNNING);
> >   			return -EINTR;
> >   		}
> > -		schedule_timeout(msecs_to_jiffies(500));
> > +		freezable_schedule_timeout(msecs_to_jiffies(500));
> >   	}
> >   	rqstp->rq_page_end = &rqstp->rq_pages[pages];
> >   	rqstp->rq_pages[pages] = NULL; /* this might be seen in nfsd_splice_actor() */
> > @@ -765,7 +765,7 @@ static struct svc_xprt *svc_get_next_xprt(struct svc_rqst *rqstp, long timeout)
> >   	smp_mb__after_atomic();
> >   	if (likely(rqst_should_sleep(rqstp)))
> > -		time_left = schedule_timeout(timeout);
> > +		time_left = freezable_schedule_timeout(timeout);
> >   	else
> >   		__set_current_state(TASK_RUNNING);
> 
> 
> That did the trick! Suspend is now working again on top of v5.15.160-rc1
> with this change.
> 
> Feel free to add my ...
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Since I've heard no objections, I've added this to nfsd-5.15.y for
testing. I plan to send it along to stable@ when testing completes.

-- 
Chuck Lever
