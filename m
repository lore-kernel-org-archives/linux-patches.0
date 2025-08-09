Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6581277800
	for <patches@lists.linux.dev>; Sat,  9 Aug 2025 15:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754751895; cv=fail; b=jM9ft959TmBK3Jk/UUoKp+uvocUsPXNBFILXE7xSQ1IKcZkkJtntc4FQplTzhVykD21t/WtKZjb+42jliXFDVoioc61XZ9t6th2ddevNIDbd50yQvIcxxwt+DCiI6A6xZse0B7B16d3Ez208PenV6BZDoHl7WS8wYK2aePPWCNU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754751895; c=relaxed/simple;
	bh=s7Bca73Yv2rk3QIH1adcfltmPe/JeyA1HT8dQGUKS6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=g8OLUHW2DWgZWC3oynqSWtDJWB72Umohek08151jeuLvHVpEM82X2PCuU80H15CRT99cr8mkdxB2sx/0fZ5cOWBkLbWzB4ib7SsTHwBfnhS6jDlbRMkMSgeZ5oTKIyHrnSWuVd3RvpiE3dD4W39y2KE8+zE3SKemjrw/qbB+QPA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YO6ir4gh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fUqs3ruL; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YO6ir4gh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fUqs3ruL"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 579Cw3bK006867;
	Sat, 9 Aug 2025 15:04:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=KRZrGkLGx2tAsXE30Rqj9m27RM3vc0VoSxhI8K279c0=; b=
	YO6ir4ghTCUXJH0vJeZTTqhqSSLDzdXAth5pQqSd//Fhf5v903EU+OjCq3rb0bzr
	28LczzmmNkKq6jIEKHGLNNfJsUIhZadtBvIVUmJ/7NL7ItfmwHrGHyYnVNlw8lYN
	21qTI63bz9xb6EJkFBC47L4XO7iJjIO2Zjmqp5rtoE4tuq3EnOpQC8OxY40GhE8m
	JqztFPolpTLT0MNVp43c2d9BdjH/ks4Eh4ZVRknLAdgdpJz5NCILnPc3ydQBH3yd
	UcseA4DZ2FCLAsdM7jlxFIm8DxEL5xRQFNDgbk4dsJykGoDe9V5hG2HwHrj9cby/
	RhAekIK8fSQF5fsElZ+ppQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dx7dga6a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 09 Aug 2025 15:04:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 579DQ6JD030087;
	Sat, 9 Aug 2025 15:04:48 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2061.outbound.protection.outlook.com [40.107.236.61])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvs74ku0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 09 Aug 2025 15:04:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GOqXp/4dPHvE2vfRQ/lbbE+ouecOUY2B/hMuLmNZhV1/Ekbht3hApHDx3QSJo7daZkIduU8q04CGtJawYhH8+Y+BbUbY4D+lg7rSEJvOEIprEQhndbOEQGL1iDIVpNMqJsNW4q874Lsva3XZOG/NmLYrTXfzATEJiyapMyn1acIH61//+6DwaTxMh7OHdxeJtwzrnE2SMMW+F7I/gopA5hHCp9BYeMIQxuf95HxWv3Cgp11gSejRuyATncrQQkiODSodunZLR84KI4zcAHdMFgUSxTsKTLtAHjMA/MiwOFhkmmP7axJfKLjjYbclm2ph51DMpvWT9tmDHl0FWPHhCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KRZrGkLGx2tAsXE30Rqj9m27RM3vc0VoSxhI8K279c0=;
 b=qzrF4xaJmMXi3nwfaVEvK506WW0IqxO9GlfCQ0uhSjvd0Aqy4MoPwjOB05v8q/bj43kDQGFg+p6dOjL2BwrdF4epBR6KWyROcI/0o3p/CUFMbxq8+CrVwfyaMCVykz59WcFAPa/ZsbLakI1m1P6B3qK/ycKDyFSunT3rzmvjoByxJx8impWIgXRzgXpKAm52AilAf2E9cbjs3Wmsk/3YGY9AG+wQVSxtUfXk0UnCFupzsBUUjFwsopSpUWH50mrSGl8qU0uM6WhSIbgrzgmwes1acMTpfcWU/ZxdZEFUNrcII7hiMU6DH0MYuaax5yDXl/A1QGnSa9rZoykeXzyDlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KRZrGkLGx2tAsXE30Rqj9m27RM3vc0VoSxhI8K279c0=;
 b=fUqs3ruLzs47rcxmU0OxKrLIuKLB0VWEOdR20XMl7ZmaUw+OokWc1Uv/Y1d/PT+C6JrTzGVwa5/y/S/Yk9i/ofmcBzLujJv7HN/RWbpfHtCBwuql+KKlasYTfKP3HVvmd3+kr7hwbw5QuF4Cy/mgxKzAow821gp8rFYa7CTKMS4=
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 CO1PR10MB4724.namprd10.prod.outlook.com (2603:10b6:303:96::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.20; Sat, 9 Aug 2025 15:04:46 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::156d:21a:f8c6:ae17]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::156d:21a:f8c6:ae17%7]) with mapi id 15.20.9009.017; Sat, 9 Aug 2025
 15:04:46 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc: gerrard.tai@starlabs.sg, horms@kernel.org, jhs@mojatatu.com,
        pabeni@redhat.com, patches@lists.linux.dev, xiyou.wangcong@gmail.com,
        "Alan J. Wylie" <alan@wylie.me.uk>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15, 5.10 6/6] sch_htb: make htb_deactivate() idempotent
Date: Sat,  9 Aug 2025 20:34:01 +0530
Message-ID: <69475adbed0c42b245793b211084905ecacfd524.1754751592.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1754751592.git.siddh.raman.pant@oracle.com>
References: <cover.1754751592.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXP287CA0024.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a00:49::32) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|CO1PR10MB4724:EE_
X-MS-Office365-Filtering-Correlation-Id: 441ae573-493b-4fe3-6a3b-08ddd75613e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WHsuhQg08/OVMmMooeTNOdNh+01UCi8cl2z7K0mEV+CWLE6ggZtfCvXQaoFW?=
 =?us-ascii?Q?VCvZu4AT3mQ7fKKiAuIqqLOLKu/lclHoDm7G8gFXJag+/v4WVmzIJvpSp78g?=
 =?us-ascii?Q?n3SjTIosoMbSmc2i0l9f1ek3qCEjbUuXd0ikMxnfCa9rf4SOfwqTfppgDO20?=
 =?us-ascii?Q?nSMJ8A0dShrIKlzzn/qJcB+M993Xi0mB3Sm35gzwzBTl1U5cX9gqisuIBY4O?=
 =?us-ascii?Q?lk+pRPRwmSdVg4CjQwaWg0oRoS8FDabZArMCd4B22RNxsPa4PxASTql0/d0L?=
 =?us-ascii?Q?SDuBUEGFiMot+Pm7dSniklhLTzDGVdcgcYvJPvSqkknjrqFbrX6kBRfhIDLL?=
 =?us-ascii?Q?3dKegiCANTDSq3oemqAUUDcUThFZsowbyg/cSzgNId3+zHOxgoU+dx6ZwS4s?=
 =?us-ascii?Q?zXseZ3cfUkO8E5StRrG3RRBRIzrvKCU2a8wAicozvcqtXBjnmyp0f9vjAN+8?=
 =?us-ascii?Q?vUx4fOttTTaN/gjKH4GUI7IZ2evSGVWI2abdnF7byqIaxq9mmdmUvzKvJxcH?=
 =?us-ascii?Q?M2AP8+7sLCDx1XGGP1he4HWfAB1ydTiNXvvPcvJdYnzJjZrbiM/NHuFZdKlc?=
 =?us-ascii?Q?oT/pCz/5AHN20S6T31g4U1OC3NuYSTmJgRLZKfdrcT+1Ho54JlB/4hluO+0f?=
 =?us-ascii?Q?BQa2lSuRBO69bqR0cyzm4yzVK45lroPvnJgwtquX+B06Q7U/Gxd/vEW3GNq1?=
 =?us-ascii?Q?Yf380UsNeRRTXgdulNsn/QD07iGHd2C7eSDkpdPxwCnJMtX786L4BQvqbwBD?=
 =?us-ascii?Q?lRBSeSzjMqdl5Fabah22A0unjLXAKMU3m76q/TqvpOX9y6xYwagkjDaqI5rn?=
 =?us-ascii?Q?g4xn8fDoOXmunJit49OSwaiEHAm+Enc5KZb8hsguiRYYlaNC0ncpyPCCAjq2?=
 =?us-ascii?Q?dZrso4k1SyYUd/swaziGx9n9f13pSU/0KDhA5ez7/2nqNkkrrBcn+5QHM9ue?=
 =?us-ascii?Q?mFpwxe1ONK9SJlJF+uG0ckx7hAkcSrFa++IytBw0hcbrMxbCcFRjPSNrlulI?=
 =?us-ascii?Q?zPj+8BOIUe7HD3hzPp3Rj6GBBP4OeNxBaHO0pHCTB4d3rPvy13z/mi7k1q7j?=
 =?us-ascii?Q?zEqAJHL1kADSihG/dImNkVyXvThWWNWXZcZvB/2AfxFRqjmMNMQylb/aQ/cC?=
 =?us-ascii?Q?HtyOUlzO1FDX4dKYkJSRgNy6Z2kboFJLxGDJcYlF8Zyd/QFd4/Tx2nuqFsjp?=
 =?us-ascii?Q?1vHTaJ8agYKCkFI0e8wpBuqZCDGWGQwo3xNGGZjeiIrVJBNpR2UWH/HzFhFs?=
 =?us-ascii?Q?PUpDgKeHfy8gc5Eu+L1iNtqAuJkkzOzaVmJt30lgFz2NLy54xkog23XDxmOU?=
 =?us-ascii?Q?+15u8lsGBx76ZWoquqS67urR2CQgve1T+JkHs01B/FYGjuJBKGKUB2mrdL98?=
 =?us-ascii?Q?U3j7QQ0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Lp45P3wWX1ow7b2IMyYfujhvgKyR/UTAf5NnoldGKrTxAsTGzIId29zjqr5N?=
 =?us-ascii?Q?IxSATFY88cETqRoJAz0XfIHDok73ZV9pJJsR9ZEwmHicfswSHfBxWvzK9rBN?=
 =?us-ascii?Q?h0i3gVYbcIekflEhx1G1qlf/jaskXHoxGF8sgsX1H8dwj7G4TC6YVU3z2Uxs?=
 =?us-ascii?Q?YW/xicEKDlThQAuga4/YOr7AFEd1Qy/DZu/dnafbX3bmGsNJFDJeqPk4SKrw?=
 =?us-ascii?Q?L2OlZl5n8Q5cqD7FbknJaWeDgcoyuRG3BDMYLCRwApryINHkrDQoI1nB5n5A?=
 =?us-ascii?Q?rdreeXmgtCOwhnwRMyq231GC3eOFsRKoMqv3JRWy51QxBXxqJze255kAcr12?=
 =?us-ascii?Q?W5m/1sayabWgnR/B2fie9hzPrKko45QBkE2xu/ULZNnhto3JXEu5E+plSu24?=
 =?us-ascii?Q?03GP8R7YZHbTH2OzPHgFw+8lLIeKYUTESSHQUJKKjUduTlvOV2Yi/faBDoXp?=
 =?us-ascii?Q?KJmKdYET8dDgBKgg1znLN82jePNlU2SpFx/omVIpitwDclqjcJb0+krFAJ8y?=
 =?us-ascii?Q?5Y/11iF6joGstujBeVeWrhKke66Y1z6YuoR5jMrYfzNueC8b6w7oIF/OuCYI?=
 =?us-ascii?Q?FHTnZ11vGKQwEeoaUDf8BhEwTIwVNVe1qg7MapMBiPCo2gMB8fspAfcBXePX?=
 =?us-ascii?Q?93O8X3DHk7e6O68BHJmaUrLfBKxZHCPqONp/We6KI8r2zsgyxGLp553eEF1h?=
 =?us-ascii?Q?vtzr1cjEiB1EWiuonaJzCnJf693+DTFf7RHz/Vimte+TQbzfc1lTr4vNkpbn?=
 =?us-ascii?Q?EQbOu7MHv3BY28ymTrpKbziapuNDMiEn2va0Rh0x3JwH+5b7tfNz/GxJ9OGF?=
 =?us-ascii?Q?z4y8PZXi+qDcjinjXofktrUdBR0HNIzMLoStbrVG7+JcMhS4OKE30NTtUiLY?=
 =?us-ascii?Q?M1LHOvV27ICiBr7T8KFV3FMYbF1vkW2HgksjUAaG0y/PkCbBfvtFRWu1VJPm?=
 =?us-ascii?Q?XwK/CJXVKuuiZO7ld0X9OH8hktpa5Wm80aQf6FYZbkqTlX1KAjEtKk8c511H?=
 =?us-ascii?Q?v5nHIqNhVwSmbNHqh1+J84xup+jL6rb+F0fLm+Ae9jAm0O71da4D0uGEQQC7?=
 =?us-ascii?Q?D4FtGexWHZ1UzwATFey++nZVZ5g/RwKJT9HFeh5yNfd0u3wcCnX0fLKQe9tk?=
 =?us-ascii?Q?+f62ztMUb8lJ/mwDjg3FMDvqyU4F7jbNOJOcDaQIMJccxeVr5dAIRytoVaze?=
 =?us-ascii?Q?/WlNVzSJAKBWW2euZbP0b7LtOvBAHRkuPTcLs0Q9k8v1TB/uflrzJapT9j2J?=
 =?us-ascii?Q?LfTM8JPlRGIfFMHstqdOZ2FbRu+EWWV3uu88CFVbg2q8lE+IgxlyuOTOViPA?=
 =?us-ascii?Q?k3zDNY+0iafnbQ4T8fi9WKB8GsIu47olMgB1KJ5KkyWS+LYVXsv/Al4QJmsi?=
 =?us-ascii?Q?XbcTgva4t8yCr2fcujFiHrcBlOyMRFmd08ddoPwblJc8LxFTv32x5z5H/2zB?=
 =?us-ascii?Q?ktNVIRq5QDDLRBbTLG58IxsJAjEJLLcAh3RYtT3K10RWwKQZRFyLwR3+L6Rm?=
 =?us-ascii?Q?ykeDivJDPvWSSfXhN8Gfl7Pqn7sOZB9QW90i7jpf6KossRsN3nCB2mzPl0sx?=
 =?us-ascii?Q?i3r+Ec5n55Iw4iZoiuxcIJG6sEpLS1H0o2Rr/HtwLQrHRtHPj4VabpP2lL3+?=
 =?us-ascii?Q?ShEM+EhmdtFl7KbYsmMVyBn9k+E0ut4jtzeGrgMMcf0yNmJbpYWPPTEbx3C4?=
 =?us-ascii?Q?vfNgMA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bEfdNEEXP253c8tFZeMs4agJ+/a7+dM6ruiT+Id6rP0sfOaFtwHhbgB5HfxRnonKkRuyNCLYGFql1z3vTfQAbV5NijSQVyDCkVovktud0K0Gwd0HBt6L2VD3mDxkxgQuuz4bB/snEmPQ7lxK6xfIBgoI6gvX/IsdGn79ycLvC1tHy3MSuujAZJHeI+sXQpHfqCCX0Sn0t1kXmqMzvGIgEaKBDbBcXKDFDlUgiKk/m4vaq10nhPFb/CwrxlnhhOR7H++lJPArME2fXjydjO5gZN44KcKuE5vo7l0YkSP+jSqMVuTc88CTQPWOhIekCmzyUlVHbIEHhv0xuT2B65SxOBRBSi0BK0Ewg97SjZ81HRh0sdla9qzmHG7djFgtzg9LUTQhSyvEdE/FoM+x2UEKpqBZoek3028kuMWVRb36MvFgv/edl4vF2OHBDzG671mmteXarvIN42ujgDGhIxAgpjS4oHlozGu8nqG+5lt8fL8N8P4c9AXvEETtDsOJHQMOF1lIDONzDNTMErANHW/hFrb5sYvPNPYupoaM4FKMukh13yl4U65Fq74M5zj6vOJXcJj+ZyiWvlIBwE207q5WUpqhPCy7SG66yaMQzbRXLzg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 441ae573-493b-4fe3-6a3b-08ddd75613e0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2025 15:04:46.0626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cq9xJ8dDS1clKeK5/PJCS8luN84d1MAjniWy9/zAd8RGSaXuDNkDhoyAj0F4OH20KoRgHxKAzOsBskrZpDedynLScLZBv5wU+ap0V3EvNr0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-09_05,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=666 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508090122
X-Proofpoint-ORIG-GUID: d42FzyWLC-GW_rGEkUzpRmTv4fVxoOg-
X-Authority-Analysis: v=2.4 cv=WecMa1hX c=1 sm=1 tr=0 ts=68976391 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=bC-a23v3AAAA:8 a=pGLkceISAAAA:8 a=SlwUlffVAAAA:8
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=0wO-4aZBrsXhLJnHXYoA:9
 a=FO4_E8m0qiDe52t0p3_H:22 a=aQPiSDAGX_ZXe9WlC8QC:22
X-Proofpoint-GUID: d42FzyWLC-GW_rGEkUzpRmTv4fVxoOg-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA5MDEyMSBTYWx0ZWRfX3aLj15hgzyeC
 2l678JcBKwrZzqBKCucOXqA/BQ0ZcmbwlDwR8j7RXKoTdSpEkZpSzh+rcnJvDlxiO1tfR0WyiFX
 JXjljZnX7Tu7Ll+IQ6i/P2KYeZeXgg7v61s5J3FvPNrYynjtjycOltzVLJ9VmLdYPlbUgbLKjq+
 7sJTbiHmpJ9ELlR2PULAgfaumchCn3m154FCMgEK3v3N+dX5j9CdB12rf6n9dmpshicRk4mWQ57
 d1ZNJJIgNxsntVzlv6IJiWUMdNYp8nnWXwboMrSZUFLWr/ZOuq0jExs/5mjX5Ci7i5/vp7Cu2JM
 6tYJl/aemHxB4sv6KOK/W7gml4R7GbPkQ8W153GNy69Y5pJkrIbDvkdHMOt+MdO3q7TEF3vHBfo
 LR50F1altisscVhbmbG0oa2Wo5SxiypcNlR8C+M0O+dK6HPWiBO9eEg2GDc5SG4sL1mg5Me0

From: Cong Wang <xiyou.wangcong@gmail.com>

Alan reported a NULL pointer dereference in htb_next_rb_node()
after we made htb_qlen_notify() idempotent.

It turns out in the following case it introduced some regression:

htb_dequeue_tree():
  |-> fq_codel_dequeue()
    |-> qdisc_tree_reduce_backlog()
      |-> htb_qlen_notify()
        |-> htb_deactivate()
  |-> htb_next_rb_node()
  |-> htb_deactivate()

For htb_next_rb_node(), after calling the 1st htb_deactivate(), the
clprio[prio]->ptr could be already set to  NULL, which means
htb_next_rb_node() is vulnerable here.

For htb_deactivate(), although we checked qlen before calling it, in
case of qlen==0 after qdisc_tree_reduce_backlog(), we may call it again
which triggers the warning inside.

To fix the issues here, we need to:

1) Make htb_deactivate() idempotent, that is, simply return if we
   already call it before.
2) Make htb_next_rb_node() safe against ptr==NULL.

Many thanks to Alan for testing and for the reproducer.

Fixes: 5ba8b837b522 ("sch_htb: make htb_qlen_notify() idempotent")
Reported-by: Alan J. Wylie <alan@wylie.me.uk>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Link: https://patch.msgid.link/20250428232955.1740419-2-xiyou.wangcong@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
(cherry picked from commit 3769478610135e82b262640252d90f6efb05be71)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 net/sched/sch_htb.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index f3a20a5ee306..e84325e29c5c 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -345,7 +345,8 @@ static void htb_add_to_wait_tree(struct htb_sched *q,
  */
 static inline void htb_next_rb_node(struct rb_node **n)
 {
-	*n = rb_next(*n);
+	if (*n)
+		*n = rb_next(*n);
 }
 
 /**
@@ -606,8 +607,8 @@ static inline void htb_activate(struct htb_sched *q, struct htb_class *cl)
  */
 static inline void htb_deactivate(struct htb_sched *q, struct htb_class *cl)
 {
-	WARN_ON(!cl->prio_activity);
-
+	if (!cl->prio_activity)
+		return;
 	htb_deactivate_prios(q, cl);
 	cl->prio_activity = 0;
 }
@@ -1504,8 +1505,6 @@ static void htb_qlen_notify(struct Qdisc *sch, unsigned long arg)
 {
 	struct htb_class *cl = (struct htb_class *)arg;
 
-	if (!cl->prio_activity)
-		return;
 	htb_deactivate(qdisc_priv(sch), cl);
 }
 
@@ -1760,8 +1759,7 @@ static int htb_delete(struct Qdisc *sch, unsigned long arg,
 	if (cl->parent)
 		cl->parent->children--;
 
-	if (cl->prio_activity)
-		htb_deactivate(q, cl);
+	htb_deactivate(q, cl);
 
 	if (cl->cmode != HTB_CAN_SEND)
 		htb_safe_rb_erase(&cl->pq_node,
@@ -1973,8 +1971,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 			/* turn parent into inner node */
 			qdisc_purge_queue(parent->leaf.q);
 			parent_qdisc = parent->leaf.q;
-			if (parent->prio_activity)
-				htb_deactivate(q, parent);
+			htb_deactivate(q, parent);
 
 			/* remove from evt list because of level change */
 			if (parent->cmode != HTB_CAN_SEND) {
-- 
2.47.2

