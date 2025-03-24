Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1AD645
	for <patches@lists.linux.dev>; Mon, 24 Mar 2025 06:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742798967; cv=fail; b=lNDm2tCJJoNHPms/3vpZ5AUPympEaNA7q+wsH13IkjiSWIry9q0XjGdCOUg57xwVFcxh+ChOUKHkrZ2QVGYirEEBQEqKVxIKR9XHgdcobMdMWIr6rFiwHo46sNlMAQCGtGlHP//yCW/inbx7XztEymp5rymAu97C+UV78hDyHHM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742798967; c=relaxed/simple;
	bh=BOYZ8H7yuyNQxrLjaFvi7FCofnxQ0wBSag7n2g/1Kx0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QMPlwJ891Is4Wfub7S3XuQSbIR+26WK59V4MqQdiBs6s7WqFyJGK9PEN49qF1S5H2BLCqBnn27qlMMeIL8t4G+DsQIcpDh8p6C81QZCyFPRRFpkDuSaekh7CC7YQDCuMP8YiXcTm3A/vvwBpyFK/CGuVu0ndQRr33PlwtWsfh2w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52O6nF4A000869;
	Mon, 24 Mar 2025 06:49:16 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 45hje1hteu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Mar 2025 06:49:16 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WkHGIuWOGpGNWwa3lrhXXYgGfJwfG0ybEE5crDRbTycgUV5rSCG5yWzaIMeAwS/7OLE09WP/g3eyJwONJjR+NakJCP82Pl7R1HdTkS2mI/8DP9Fgs8uwH0pRW2TWIWbQEjiAnZz3q2PwcE0cg97g0Lbz5eH/3DbMTdWUYEui/lXEH4OCblCDHGVv9Oi3UrGS98UvmKrcEpkqBeDSrKJtvx1+4CaMHxV0ZPnrejVCUDC8fecUBO+iOHb7VNG0rBb1EgFs+1pYkyxBmZUWscFZjQ8hiRD0fg/oxFgv9twTCe3lMfS9oTfgFiKngLTYQRFk3RKaLEhGZcS4PAMSEflV6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DCJqaQ2FuGsXdZBNIYw+LmRpSQboDVzAT2iGRBV2eLQ=;
 b=wj44/JihLTO+5Fl3HDoO7RtuY3wEYV8mOTo1TWtzycRdQn4NoLQCGcaMLB2YhH2oyrCMJUOAwaDLb5nUU+MLZHMeZi/PFyNHLYGZTMQLf90t5WPosadytMnuH2L4OW7t4A6EnNAmUkrUXxfaWdNTF73ndU/MvNpdK1MwWQqldr83w5DePB4qsOeoDCTe+e04HF75WFQT9LPMkxs1g4AYQX6xghAOw25vBiReJMJUndeGSpRcDeSn9Nbr8mB+whM470z6yTqPQq3HgHbaSgzqC7jSaVT/qRF8xTQxCzUrGku+VBB3f1O8ACezI9Vlzn79m6j3/KDMH1h/PlIK0t9v3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from IA1PR11MB6170.namprd11.prod.outlook.com (2603:10b6:208:3ea::11)
 by PH0PR11MB5032.namprd11.prod.outlook.com (2603:10b6:510:3a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Mon, 24 Mar
 2025 06:49:14 +0000
Received: from IA1PR11MB6170.namprd11.prod.outlook.com
 ([fe80::f850:53da:e11b:1653]) by IA1PR11MB6170.namprd11.prod.outlook.com
 ([fe80::f850:53da:e11b:1653%3]) with mapi id 15.20.8534.040; Mon, 24 Mar 2025
 06:49:07 +0000
From: "Ren, Jianqi (Jacky) (CN)" <Jianqi.Ren.CN@windriver.com>
To: Simon Horman <horms@kernel.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com"
	<xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com"
	<edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>,
        "michal.swiatkowski@linux.intel.com"
	<michal.swiatkowski@linux.intel.com>
Subject: RE: [RFC PATCH 6.1.y] net/sched: act_mirred: don't override retval if
 we already lost the skb
Thread-Topic: [RFC PATCH 6.1.y] net/sched: act_mirred: don't override retval
 if we already lost the skb
Thread-Index: AQHbmos7N1a93zq/i0yxM2CKWqFX+rOB2rOA
Date: Mon, 24 Mar 2025 06:49:07 +0000
Message-ID:
 <IA1PR11MB6170DBF824EA5CD87D99258FBBA42@IA1PR11MB6170.namprd11.prod.outlook.com>
References: <20250319012225.821278-1-jianqi.ren.cn@windriver.com>
 <20250321180101.GP892515@horms.kernel.org>
In-Reply-To: <20250321180101.GP892515@horms.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR11MB6170:EE_|PH0PR11MB5032:EE_
x-ms-office365-filtering-correlation-id: 5104f10e-75b9-4dae-d402-08dd6a9ff9b2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?EEojLzmIrpEzdYjFFPWk/Q4OM9iY2Tuwu/xh43IUW/lptZVcNfb3orDT9cK/?=
 =?us-ascii?Q?1XLSzKVwOiF1yJm3RmP2rVjLIl7/lTeBTXVVMiaFCS2jvxp4+F2UuN4WnsIT?=
 =?us-ascii?Q?lF+FjJZbVHsyjJB0C9HojnxWg1cJnNJOIN6VLHOI3Ps+qXZ712MoPqqvhNyO?=
 =?us-ascii?Q?TO9uyBc6ksFB3tcaR9gJdCR/RK9iWgwF4lvF/74/ZuipRTBXTxuvay8u/5yl?=
 =?us-ascii?Q?MqDI6+dyGaMd0NKVnepMIKZeOTqP4LaUZ8nUuiV8gLgy1MtUQU7ifHYgSzKT?=
 =?us-ascii?Q?XXpwOoSBQsIPnxiqETFAUlFt7JihJpvJLrDXcta8r66KgQcQS9f5Y21Qe3i2?=
 =?us-ascii?Q?UFCNP4tPMJfo+ugyes8PTAo3Ktl5yu3q8Fi2SQ4KOfJGJI+/PJKjKIrHL/lO?=
 =?us-ascii?Q?nDKphCKmVoy2SEPo2XfI1Cf6+L89XrXjSIZH86xLtJlhl9oW5Mqgkw36u31A?=
 =?us-ascii?Q?RlomaCwLkHZ0Ovv2vB1aZLVTlUUN0Wt8VV2hxNh6zDpFcOs7l2bgkOKdkbeL?=
 =?us-ascii?Q?5+E8mmYEpllGQwXZWEDz6hEzoL/Y7/VOPYZNCJtJdEH7zXSNzjXkDc9JJE9G?=
 =?us-ascii?Q?I4IHkIhcN6ptYT/mryrSQwhACfPFdmtB4TJtY0mZmMzyn+1bVu/ntEuKehbh?=
 =?us-ascii?Q?9TVvJkjpdxU+HqPGtHVyGs2FdY1f/JlX8rv3m23EzKtkqjvdYjscGzxaRcA6?=
 =?us-ascii?Q?JUOe2CwGOuwugq49JZWZSsu4yRVDE8cptRFWUVSWQAJ8oHy91I6FfjPpCk5O?=
 =?us-ascii?Q?R/RrvDM/+M2M49Hk07O5RUNUdjF2IOkEF0nzbkKAmlP/x3J/XKLlqUEgk8/s?=
 =?us-ascii?Q?WAANHnJWAhiPjsJ08BYNeYfaWDDenKq/8KgmQuGyi7qsNtDRQfZ55lqJZYza?=
 =?us-ascii?Q?V/J0sMWcylUDRoecmXNOd0E9AZdysxBB1kQgr0ED2JwfViuajp2aUqEJDmQ4?=
 =?us-ascii?Q?b7iO3WYqunlrkBV4wZOXtnheNjZNXHaQsXPI3dGZAYX9y65SFqpEKjlwZVeG?=
 =?us-ascii?Q?Su0Qyuusu9EHiFLUHJ0Hovp45qFDzchHhkNqwPiBIlsc/bsIr2zgGtFvL5n0?=
 =?us-ascii?Q?boFumwLmizo1tdeCUOqB8sVr6ZhNnH3X4HFHE76LH59/oJlrH4qrBvvoZa9f?=
 =?us-ascii?Q?fzHvGq4EbyOWhWSnIdXNIsstsJtjKIi9JtqPFPHSHR6rgaBsamucUr4hSMf5?=
 =?us-ascii?Q?3r99S0ukkjFr4TpkPkVREH+g8/eLDNsrgxw02fzU6CMMqWo9MyGj/itc6Eh8?=
 =?us-ascii?Q?FQB7565to/p6kVZoqxOkNWAKNw2rSmyIWVcsakAhG+bnL1XEL4+2Sp9qD2Xp?=
 =?us-ascii?Q?n/voqLoCdtJdS8Lfcx3RB1B0v1vKD5R+somxo60ajksrf1msIgWsB1I5Eb9z?=
 =?us-ascii?Q?7YGhoDM2AgKJnWdp3tWBAWKRoU8wmEXjWxtesrK4TNysVKtttjlG+fne+kER?=
 =?us-ascii?Q?slQHSdyaYwA=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB6170.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?JjFoG6wm3Ffkr3Wi391CcB1Tf8DdWZayGn+BvyUICoEO73o27bPta8BwA2bz?=
 =?us-ascii?Q?bApOrULUA/cizvyHxWgwFl6n4PzvdV1zlz0sOcdo67eiKr4NChPvSYNANJYW?=
 =?us-ascii?Q?oWprGj22pBcNt7+EFOZ7ZxQZfHJOaWr13pGFb/hrENgV39KCTpBEg/AK6mnr?=
 =?us-ascii?Q?/RV8vtnNUOeTs/BrqD0jq37Cfwsfapfq/Av8RCXC3NYl/9YYacELVQh17fcW?=
 =?us-ascii?Q?BVC/E6TKHJm/zQW1HKd/D1b5IYPZlXMnP/EYUxI01OdrvD9HaIIyPPY6FhFG?=
 =?us-ascii?Q?OlNDtpapCZxuJ0LKKNzLabK0XyFxaruIOdfibQq/OQGerH1h1p1u5fSvqQt4?=
 =?us-ascii?Q?3VumA2QvhxHPRQj8Ihz8FW3iZfxMg43JGUN3mcORMC2ORdxhgTGfL7vDNZdj?=
 =?us-ascii?Q?LrVYUEnPoEYEyPazwO9WOLon2/m5KT0jAMFNQcOmfjqRF5a3P9bVN+69YINJ?=
 =?us-ascii?Q?8INjtJCnV1L2saAgubvMhFiMYbcMrHEkp88PU+sHkVLCY2ZN6C8ds1LVy1Uj?=
 =?us-ascii?Q?AKYbHmUZKI8oHrwpqe23clFFNxY5KRLsh08BaUNFkkgr55Z+t3qBM+yY/t49?=
 =?us-ascii?Q?W62I6jHCyAltC3jSAoct9zRaLZ6Xr9K6woe5z19C9gNwa5XbgykG81ohSff/?=
 =?us-ascii?Q?+AMvAeZ7BUN3BM/YXy1FyeC+cv3UxUeMIxskY+UvUfjEAgHg7iXlADkmoJh4?=
 =?us-ascii?Q?gIZU9Gdo4VBJtJceFRL57yD5QFtpH5blsQAaw+f8c2Ud+CaZN9rJwz7qHdRP?=
 =?us-ascii?Q?mM3Ne43O4UehY/4VAVFo0JeJQoorMJnzXKf0GBtOMOfo34zxAfnQglrHnaqg?=
 =?us-ascii?Q?WkENs6WNQXtOSzmmg9YU6baxjuo2q0Futuqqo1BU9x2XhIwF1mB5Ka/0aJmb?=
 =?us-ascii?Q?oIKICvtgpgZPo3D9muwz9tOLgOwQw0opeyw9jkrHQ3RDvb2AdEV7+Me+VKOf?=
 =?us-ascii?Q?aYAkN0i2UQ+07dYoJsL7NDJrTojkmV8Dgyov5Dhlme+eDQ8q6euI04PRFs2p?=
 =?us-ascii?Q?tzGi75HFdfrf0Ip26UY6a7b48EDwSh7YTAL7sySIOzHQnTRLQjluMb576Zpz?=
 =?us-ascii?Q?FRb2QYPeKWybajL+jt1TyYlNpEmKtI2Dc2M5I4MdNsLXuIY27dk8DeMzxgIw?=
 =?us-ascii?Q?ameUyZPxsXJW4iMxuV1V00jzPyKLRZ4vIy1epqoQpdubTip5dw9jAjT6/3Ao?=
 =?us-ascii?Q?zP5WQ1E+XmG6gfDUJJmY8wNMFpLCagPTNm0G05tY+8rN8y77AFyxCy1Vh27C?=
 =?us-ascii?Q?3xhx2Ug3i6bn1XZPP/byO9eQQklidrkVBexzJpQAXXDGumj7LqfQARj9A208?=
 =?us-ascii?Q?lORzburF/WwhJG/ql79+KWACyU6uAmiEJqyHW5jJ7auY0V5zrFijrLTevJ/q?=
 =?us-ascii?Q?Srwpm9tc/K3OvQGQn/kTadZjJR/Ca4F1DlS1WyuzQSJVjbKC22a7lXJldrmR?=
 =?us-ascii?Q?9PZD/uHVTJ3UTFGv9rAIIwMG6hIrG1SJCyP6hZlyfwyNaY4SMMze3OJE5Llk?=
 =?us-ascii?Q?GapEO2aTrArRo8jJOp2/ueknZ20QOmnG9olCyXT+cvkXO34gI4lZ/aOxPd1w?=
 =?us-ascii?Q?0jR4sMFNR7cpSOztouXCuX1hSg3kM9b+KqdeFLgL?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB6170.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5104f10e-75b9-4dae-d402-08dd6a9ff9b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2025 06:49:07.7697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lel6pYI0AsNfQISQB9W3KQQV05K51ez608EpYr56Kk3mh8KruQyjI885z5FawDHW0bPf/fUL+Co7GH8yO6RtXsbd9Pb/KrMPt8c6uGWRrGM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5032
X-Authority-Analysis: v=2.4 cv=KPVaDEFo c=1 sm=1 tr=0 ts=67e1006c cx=c_pps a=smr7v+wKk2SgYJk0SwJNKg==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Vs1iUdzkB0EA:10 a=H5OGdu5hBBwA:10 a=VwQbUJbxAAAA:8 a=t7CeM3EgAAAA:8 a=ag1SF4gXAAAA:8 a=A7XncKjpAAAA:8 a=pGLkceISAAAA:8 a=J1Y8HTJGAAAA:8 a=1XWaLZrsAAAA:8 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=yj-aMKAYKbz0kkd27lYA:9 a=CjuIK1q_8ugA:10
 a=FdTzh2GWekK77mhwV6Dw:22 a=Yupwre4RP9_Eg_Bd0iYG:22 a=R9rPLQDAdC6-Ub70kJmZ:22 a=y1Q9-5lHfBjTkpIzbSAN:22
X-Proofpoint-GUID: v4_tFZWjPRHk5BURKh-TSOPRtTZ8eH0F
X-Proofpoint-ORIG-GUID: v4_tFZWjPRHk5BURKh-TSOPRtTZ8eH0F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-24_03,2025-03-21_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 adultscore=0 impostorscore=0 mlxlogscore=999 malwarescore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 clxscore=1011 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.21.0-2502280000
 definitions=main-2503240048

The context of this patch is changed compared with the original fix.  Addin=
g RFC means that I want to let the author or other experts to make a possib=
le review to make sure the logic is right.

-----Original Message-----
From: Simon Horman <horms@kernel.org>=20
Sent: Saturday, March 22, 2025 02:01
To: Ren, Jianqi (Jacky) (CN) <Jianqi.Ren.CN@windriver.com>
Cc: stable@vger.kernel.org; patches@lists.linux.dev; gregkh@linuxfoundation=
.org; linux-kernel@vger.kernel.org; jhs@mojatatu.com; xiyou.wangcong@gmail.=
com; jiri@resnulli.us; davem@davemloft.net; edumazet@google.com; kuba@kerne=
l.org; pabeni@redhat.com; netdev@vger.kernel.org; michal.swiatkowski@linux.=
intel.com
Subject: Re: [RFC PATCH 6.1.y] net/sched: act_mirred: don't override retval=
 if we already lost the skb

CAUTION: This email comes from a non Wind River email account!
Do not click links or open attachments unless you recognize the sender and =
know the content is safe.

On Wed, Mar 19, 2025 at 09:22:25AM +0800, jianqi.ren.cn@windriver.com wrote=
:
> From: Jakub Kicinski <kuba@kernel.org>
>
> [ Upstream commit 166c2c8a6a4dc2e4ceba9e10cfe81c3e469e3210 ]
>
> If we're redirecting the skb, and haven't called tcf_mirred_forward(),=20
> yet, we need to tell the core to drop the skb by setting the retcode=20
> to SHOT. If we have called tcf_mirred_forward(), however, the skb is=20
> out of our hands and returning SHOT will lead to UaF.
>
> Move the retval override to the error path which actually need it.
>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Fixes: e5cf1baf92cb ("act_mirred: use TC_ACT_REINSERT when possible")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
> Signed-off-by: He Zhe <zhe.he@windriver.com>
> ---
> Verified the build test

Sorry if it is obvious, but I'm confused by the intention of posting an RFC=
 for stable. Are you asking for buy-in regarding backporting this patch to =
6.1.y because for some reason it hasn't already propagated there?

