Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF051277800
	for <patches@lists.linux.dev>; Sat,  9 Aug 2025 15:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754751889; cv=fail; b=istyuJeVBzKrocEMpz3r0KrDPd2iv/zEwQ2UKhm4wZzSOl2dikcKN++/CL7tiOj3Ki69D11avb/aAT0CQeGalBBsMFwYq6FJ/BfRfSC52ehSV1ow6b2RkxZrxdLdqH5qHAJMHmZkb0tP8xre86E+cuhcbTNAhTVZ28UnLPOxSSY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754751889; c=relaxed/simple;
	bh=MsaqUpuFGNjmNaHzcyH6Cct7q3wuXN2lv/jK/cSKBUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KgjMb43U3nrdzmN0Cfok5NRDMmDYq7gx5eTa8zQq68bEhfLRsDFs0GwYBGVNTDtSob/P8pU3q8Mc0XpkneMiWtxX8qlC5VIBLWyxD0F/4Ui+mzJyjqltTAf7sLoQvZaFz59NJt0Z3RrHIhIwXAT3Lp2tUpzRtL4u8R3nwtustCM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hfbLohdq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=k8QsZKRw; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hfbLohdq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="k8QsZKRw"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 579EifEL022992;
	Sat, 9 Aug 2025 15:04:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=yDv+kDRuHsBlgJ2vu6YW1M9jGCmS8ZxGwsCqinff5Ys=; b=
	hfbLohdqwwLlMCtYNjJWWc6dBgak2A9vMWwgaRJ0mGf0Oyfg1TfJKAstqd48g3cT
	uflgpzGAhfhN196LZcAFWx0TJPPvsgymA3wW7ELt4NerM2P8Je9RSF09gteGUThL
	qvt9NrnVVnrSvrxChEuwSUvZ0dCHTYZ9QTuqSb8BIwvkCXttAf1CSk060/r+21RX
	2GwBxXLjz7UkQTWap8H56e3fOZGHrwNkZHhusEWr8VuMqzJxwaCl9UNly3ofIh7d
	d3mn5q8dFITtJT6QngHDVJqbaAAyGe+5qremlbArpIfi0io2ReLTOC+P0T+LpY9Z
	kfnx2icU3V53kO3tm1IpBA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dw44rbr7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 09 Aug 2025 15:04:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 579DtExd009694;
	Sat, 9 Aug 2025 15:04:43 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2057.outbound.protection.outlook.com [40.107.236.57])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsdcrxr-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 09 Aug 2025 15:04:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UAYDNUbeNgnZExg2Xog2eirwV/jttg/KSCU9FG80ezUUG6guCLIRTAxIQEIGs6ImjmvUWWoJMohNVeP3IRlyXR2gTVdo7HZFgvr3atck6Hz6/MZ+rYhscW5D7EDMVyG1/bvyT6EW4mvNOIiaO+5Mgkc1+WlQZS/mSCpjchD4ykMnxEkczjyB/KfTkLk5qihDPZps6+NA3cSv1/3821ZLvgXDk0ix7TKNZ5dZUUaYjC6o82u9K81MwUgHHjmHfldOFiVs1Udp1HhZgi4uEPvo/ZJZovh1/larHRkSif7Now6aIJP3gZzijTFWMhE01jtU+LhzAh9n2NfKnFBwXHiDwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yDv+kDRuHsBlgJ2vu6YW1M9jGCmS8ZxGwsCqinff5Ys=;
 b=wwVOGaB2hfgOfhIVpWvyKWrICIqY1GhrMp+FVXoNsVqTSr2WpVHGtYygt9DfH3ucjcqXf/QTL/Ape3gnamPJcQD8LzdgQewTy+RFe2cr2NNZNbQmd52mua56bmJI+sDTfuQWvUAXf6O0LI++0QBBb+7t841UToctml1fKB0cc/Ta/NjfVK7ifFAQewccCt3XC9/r51FXrHWxPqIoofhfa1Ytecd3rsOrvvsi74WlQ0QzBTkOf2m3VZ8RYuQFsx+QVS3Ts7WQnFKQttODjDKhSZq+0FpckcTGw4u9kK4jbA8Hy53338jODswtx9/886pKWwEN4C5zY2B4x0OpAmVKag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yDv+kDRuHsBlgJ2vu6YW1M9jGCmS8ZxGwsCqinff5Ys=;
 b=k8QsZKRwPIfJGDsVCeccrHM9IJHKMtKTRuq/0NSb2UvUb6XAz+u671B8H7CNvpkzmpi+ei1ZCVr4sJVm4qm9T+QxVhig5wC7ZekE+6tGKHnK9yVT/R18a2kH49nd8wslIidgyXBuZZh0SwabRgBDekSbn3iGUnMpObhA44fS1ks=
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 CO1PR10MB4724.namprd10.prod.outlook.com (2603:10b6:303:96::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.20; Sat, 9 Aug 2025 15:04:40 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::156d:21a:f8c6:ae17]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::156d:21a:f8c6:ae17%7]) with mapi id 15.20.9009.017; Sat, 9 Aug 2025
 15:04:40 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc: gerrard.tai@starlabs.sg, horms@kernel.org, jhs@mojatatu.com,
        pabeni@redhat.com, patches@lists.linux.dev, xiyou.wangcong@gmail.com
Subject: [PATCH 5.15, 5.10 5/6] codel: remove sch->q.qlen check before qdisc_tree_reduce_backlog()
Date: Sat,  9 Aug 2025 20:34:00 +0530
Message-ID: <6dfef48374451b97f3a7c63230862b0ee15fdc3f.1754751592.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1754751592.git.siddh.raman.pant@oracle.com>
References: <cover.1754751592.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA0PR01CA0031.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:b8::18) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|CO1PR10MB4724:EE_
X-MS-Office365-Filtering-Correlation-Id: 276d7c2f-106b-4517-11d7-08ddd7561085
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?R98z1+t3vmuAYSyt0uOYBxnAjd1nHPN+NYVfjMp0SHVQ/11vzP+PQKPxljGd?=
 =?us-ascii?Q?wiTbENifhTse7TtHIG4BnahCKdsTijgAH5kfqBp7DfdhCGaJ+QtJJ+gS5vTi?=
 =?us-ascii?Q?fICnb03ZPKzxUfKCBj7q/oPcMcbcn+42yBbA0k4UOSx6iRRu6m0rs4yuMomm?=
 =?us-ascii?Q?vuOejuiCjdGvQcflLvl/WWcjj5mva7GItp3qmf0h8seJXDS7ObQI8YmGi6yl?=
 =?us-ascii?Q?uKXFJrELpGV31ifOR44UjCliCQ373sRXtFifgS0R0iCrlA5PBoteTnGYUYPD?=
 =?us-ascii?Q?6TmqxASoUktVbH1rFzbsDX0USFOtmRQcphyWjitqAYJZoRheQS8EmQtiarl/?=
 =?us-ascii?Q?AY0MtYcWtdc1Sf0oUE/zQ/MhVxLWrs3TF3EYTx/zA2l9ypmS8jNySc7mFiLX?=
 =?us-ascii?Q?JJok8hpS8W9JIsx6DEUn9F/kmOwpR0c14Rnj3ADFjq2/9noVwEicixAyn5Kw?=
 =?us-ascii?Q?/ajxGJTx3xV7ijddPOee76ygpIBg/x8A/1ez+BtvlTtU/t12TvudYgyunYn7?=
 =?us-ascii?Q?0jn614ZMQtEu7ZUnyxYvE+iRCAhmjRx1qWlTTyITiDWXFXoJAmPq7tbAxCtN?=
 =?us-ascii?Q?vs2h7NgnzYCuRdUwhPd7liHmBxpAGhFoDYrOs8+p3YkMwk8Zd3kQALBe3JIR?=
 =?us-ascii?Q?tF8ejqvblyXURxNNilvlSWMMrZjjlBuV+KKzYHxH1VHc2LPiY10qm7tHpId8?=
 =?us-ascii?Q?vzeazKz0RjBqLPGOrGGOvHfTuB2kKJ6switzymcgz6t4+sBI31YvmvNw/qqx?=
 =?us-ascii?Q?UUfLhP8gKTnPgv26XqzyGdNVTWW11JDOUdFaotxffStx3Gc55lxRWS6gGsjc?=
 =?us-ascii?Q?AwzoafXkr1Ppxz9H99BTt+0n4SkDC6Q7Rlqg2s2YEacUHfCJeI04bp9aSyPN?=
 =?us-ascii?Q?ji/9+EmV8HUlPPZ2sHaeZDuAJcI6Mnqnw2UrMYao7/tTNCKZm5CDW3+kAizg?=
 =?us-ascii?Q?p0Vj7ck20/g2nDTh8ZdO9vKjMcd5ehUWmgzeshzA1ZnXXFRoUlavFxmeOOrs?=
 =?us-ascii?Q?UklztYBkXLU0rLlS57nap6cDEK6rwabu8iT/Mj+knx2p9uRpfraaaqdx94yG?=
 =?us-ascii?Q?WI6wP4Ja3YwsB/yYBobb1mXHAD7NN/lNVTnPjp7hnGxgDJ7De15nX8jcY3nU?=
 =?us-ascii?Q?abcilLZ3Xs9Ro/r4/Qz5hZEmPu8sese/hij9oSk8iVQ8LVuDSxQD8cYHjCCb?=
 =?us-ascii?Q?nd6dOOgT/uLLdEH9YTo4+hbj7Yr+c8dcyXK6cyKV45ctuBD/1dpODSYQAzlM?=
 =?us-ascii?Q?AjbKtfwh7NQsXuahjZowENDozi3A5lDElGghC0XRO77DJLGMTx7WoGAznBEu?=
 =?us-ascii?Q?6M8VNhuJm54Mu4O/iFh5MuAun4IzP4LxXb/M58g8tHdRhsujDEn5znqaEpdj?=
 =?us-ascii?Q?musk8Tc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?m1+RrRQ6SI+uUZ3Bv2y4yCafmVoU/T2QXpH0FmdDqZ2aw665kAcrDPyirn3/?=
 =?us-ascii?Q?TLIsdS6QFYm1urjxzyMxJcW1JTHh1MRYhNpSVcktEJDtfIphOsF1Bg47HmQJ?=
 =?us-ascii?Q?dNlCocvy95i8v/WVfY+bAGaY45o4tBqosB+D3z56s03/RsG/04RDP8xJF5fl?=
 =?us-ascii?Q?SGtKFA305jtVpaD6Aysd+rGOJ525x6/RMMO+/ypPovsIh41y7B/dIvai7uIl?=
 =?us-ascii?Q?GVMqsxn16uE/SdvxvuuzQfvjWhfq39YYH/4gjaxZ2uuRtubNrL0gWcK+yurc?=
 =?us-ascii?Q?wmvV3IyznRRGxGaFro+9MbL1PZJKXtWG16UTMHqXVn/h77SOk8Zfh9SIspku?=
 =?us-ascii?Q?ZEeIo8xrs1tllRg/u/xvqhNvpetOv5FnUbFzV3AKHdzCjHBhXOiqJ78/WeZH?=
 =?us-ascii?Q?OlCXTUOhY2Lf8qres9yZx0yphvxH5A/EN177utSbVKOC6yf1HxYe+yNysoYi?=
 =?us-ascii?Q?b0Og/K2vZ4nKxpDi3IKB90k/dYijsCocJGAuoucHr2+E5iSX53WFjn4sh+tv?=
 =?us-ascii?Q?sSwka4TV9/Z78I2BaKqjS0m3MwboP5dKK2kM6n3eSBaH+9JLlL0IRNwtzvoN?=
 =?us-ascii?Q?eEvn4DUJTWKY+Id5e6dCaVAJsQPzzwo3fxBaOYBWkU7llHkm/g/v46vL5Woy?=
 =?us-ascii?Q?r4s4MgmXtYfINgmphUoCkbryG1J3wC7gDTKlICInjo7ELExKnHq34mt9WiWn?=
 =?us-ascii?Q?doitYMv3v+eiXk1ZoCmu81knR8nlHFWKuWh4d7k6oLTdU5TR5ciU23Q0HFSl?=
 =?us-ascii?Q?lZ4ANvmDEPsOlxmZmYS0/zx+hJVIqwQVybTpjbOFnZ5eI2RPg8RwKrHTRATQ?=
 =?us-ascii?Q?kKDx/CBrmmc7zBIpdVVnLlyn70HbvLHfhy8j9iIHwR8vhX07h6Rg2rju59wV?=
 =?us-ascii?Q?Dfr0FPpvD0WZpdqx2TzzAXgM3+3w3yLHQtY/woIqABxLLVgaVb8I4hMEqkNn?=
 =?us-ascii?Q?jWaKWLJ6ZTg9ayC4V8N2nMqPZbeGKHh1NCmCVKGJIo9Pt9KXqi0GmYbqV7Cj?=
 =?us-ascii?Q?mIUtvK+Sgnxn11PRf7kkZhsE+mWNiEzo3u07vec5Yj3NIrdjImP8kizJZJGl?=
 =?us-ascii?Q?R0Mf66WZZeiBcM67xue7/XtLru9DGqtYpoqr8oiogWuhQW7leM3SST9zPVLe?=
 =?us-ascii?Q?CrsRRcu/SLDFFlx5pegT7Cwhw0nKdNJyg5WwsnZiumoA710UKW2pK1MlaTEi?=
 =?us-ascii?Q?PuL2nLpX2ecnSmQD2rQ1ByefWW7bKbgXEeXWAu80OXWKG9/9s4mUE06w3IRc?=
 =?us-ascii?Q?0vCGhB53RZXtemdXN2EUYtzetOU11BeKuRtnJuqI+OGr+VQ5GvC2T+YsxiAd?=
 =?us-ascii?Q?YqRDLIxkCNM7qHpYd/osFvBuF5/reufbKZqWdPrjoEBAUsSp40f4BTw5ijSy?=
 =?us-ascii?Q?ZCDAeGFiSBbppSFFvOIRvhuvJaqm2LLyXNlmc4C5OuPIBalQjxerOGQh5svA?=
 =?us-ascii?Q?fjkATswZNTj5fkNnsxrUSQ87dOvom0/LZA5MSBF+a1/75oxD7pLInx5fN1a7?=
 =?us-ascii?Q?urDLu1RN6uMH6pSiJpUtUOxK9DYIhXjo+cloMheJXB6p8sukPeUC/gtl8O5R?=
 =?us-ascii?Q?ZWDxMsBhLAgqsYY6zC0hiccQgHNPyPJX6/XLLRCKmzvBET+5dehp4xcFb3Zp?=
 =?us-ascii?Q?7ON5ZVQ8mnENELL40cFOgeAAvX11X0kt6jtPuOH54snt4QW5VihvBQFiQYC3?=
 =?us-ascii?Q?iKmBkQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UnKE0+nEcyMEdXabm0YB6cofx0zDpa9T3lNmaCd7xnIuQEJJqkwaCCJIFfVZplTSv2fufQs/6qcGuJPF+uR05jOafUmxqtaDO67N23Ouo8VYZBCn+DxI5jK4ZDIuTKKywHZ4lTNIvyfHhtohUU2E/1+WzzIZRk+ngO/tuePjZ+bWm1od5MTgeRvIVDCeZx0S/gPvAlFg+KopvCcZrKiwE6z74204EIQzsUcA1+fz3CGnzvLqxdn0xPwo1+ZxZVKdmmLfVZBhWqKvLQpYarNOxOb2/amGIi6PvoFniQhGAUHpo6u9sHmkAoIHRidhJN0+190Sx8sbaYLvFAFFCxOwXbGjeQPrakfLv1Qw2qODfMyV2qr80VfpnowQPm3u+DL67l9lOmPG9E3Qb1493ISL5XY+rONV6OeZSdfD3bdslZaGqN5qd46j98FCVqA5jsz/0Lta47b1MiN3bSvuZoRJ5FZ+vzvza0qGSawYsdqvCb7k+Qz5mq30bZAr2Cm+d5hYgAbQuQTB+pXpVb5IONFA6f7jW1f1zZgMRHhv+Vv217L+dObYYzCrIg+0W+d41sgAVMQJ8DlnQZj7k4BMWm05moxUNNQlU+JBmlRhX1FKnhs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 276d7c2f-106b-4517-11d7-08ddd7561085
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2025 15:04:40.4290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WOv/ErxOOEq6aNQmJvq9VrMapo0d6zAxUKLGyR/aIwXdED5bCRiqp8mbBhUngm1GS4ROMZ3gP5baQnTuvfxMzCw+e2Ewu1n5kTWVtjnmN6M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-09_05,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=970 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508090122
X-Proofpoint-ORIG-GUID: bTVUUq_G9NxlirVtCO3iFmv0n5XQK8gt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA5MDEyMSBTYWx0ZWRfX59Ge2DWNlEi5
 SJ0SZlXqEWi6+PJ3dpgIUthDoO+8WuTl8SodgSoyexhDz68lsv31xrXIl8RMi2OCESDDtScVhVI
 wQHwH1pXio8klMEaNxliK8BDD+z1XREc7+suMbtSkhO3sQzQ77FX+foJLTnPnuDQTVgzJVtJ28c
 h27AeMfRe11eSZXiquj7GHx8HD+U6U+uCwLXJbzzOoSbewFvgHNMJvv4gW+AVHD6eyCHSsX/eLK
 9IFuvMtOK6Hoo43S2PKR6EXCxkByIFK0Mf3kBDdX8BK4U141N67sT8bSmsgBFa3Dne1nr3KK0bR
 iYzktwrTbntoZnlAOegQfhusVDTkbierxC5pmE1c99tw2wdUp8sHil6QCBKAf3NToKUYPYwohfA
 wXIZ3Ox2yvIjav3APttu3GEl5D7pjHVspy+YTQKWUeffwtEAIuLuRk0OosvvlCxDR6GUAsIg
X-Authority-Analysis: v=2.4 cv=X9FSKHTe c=1 sm=1 tr=0 ts=6897638c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=bC-a23v3AAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
 a=A7XncKjpAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=PIUe620fHybt-iPp2eMA:9
 a=FO4_E8m0qiDe52t0p3_H:22 a=R9rPLQDAdC6-Ub70kJmZ:22 cc=ntf awl=host:12069
X-Proofpoint-GUID: bTVUUq_G9NxlirVtCO3iFmv0n5XQK8gt

From: Cong Wang <xiyou.wangcong@gmail.com>

After making all ->qlen_notify() callbacks idempotent, now it is safe to
remove the check of qlen!=0 from both fq_codel_dequeue() and
codel_qdisc_dequeue().

Reported-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Fixes: 4b549a2ef4be ("fq_codel: Fair Queue Codel AQM")
Fixes: 76e3cc126bb2 ("codel: Controlled Delay AQM")
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250403211636.166257-1-xiyou.wangcong@gmail.com
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
(cherry picked from commit 342debc12183b51773b3345ba267e9263bdfaaef)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 net/sched/sch_codel.c    | 5 +----
 net/sched/sch_fq_codel.c | 6 ++----
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/sched/sch_codel.c b/net/sched/sch_codel.c
index d99c7386e24e..0d4228bfd1a0 100644
--- a/net/sched/sch_codel.c
+++ b/net/sched/sch_codel.c
@@ -95,10 +95,7 @@ static struct sk_buff *codel_qdisc_dequeue(struct Qdisc *sch)
 			    &q->stats, qdisc_pkt_len, codel_get_enqueue_time,
 			    drop_func, dequeue_func);
 
-	/* We cant call qdisc_tree_reduce_backlog() if our qlen is 0,
-	 * or HTB crashes. Defer it for next round.
-	 */
-	if (q->stats.drop_count && sch->q.qlen) {
+	if (q->stats.drop_count) {
 		qdisc_tree_reduce_backlog(sch, q->stats.drop_count, q->stats.drop_len);
 		q->stats.drop_count = 0;
 		q->stats.drop_len = 0;
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index f954969ea8fe..e56f80b8fefe 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -314,10 +314,8 @@ static struct sk_buff *fq_codel_dequeue(struct Qdisc *sch)
 	}
 	qdisc_bstats_update(sch, skb);
 	flow->deficit -= qdisc_pkt_len(skb);
-	/* We cant call qdisc_tree_reduce_backlog() if our qlen is 0,
-	 * or HTB crashes. Defer it for next round.
-	 */
-	if (q->cstats.drop_count && sch->q.qlen) {
+
+	if (q->cstats.drop_count) {
 		qdisc_tree_reduce_backlog(sch, q->cstats.drop_count,
 					  q->cstats.drop_len);
 		q->cstats.drop_count = 0;
-- 
2.47.2

