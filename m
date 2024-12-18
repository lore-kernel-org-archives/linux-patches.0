Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6B879C4;
	Wed, 18 Dec 2024 02:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.180.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734487886; cv=fail; b=ebJOY5Jx3qNqstBXJkhQKbuAS8I9WdXMdVK1NsZlGshvfs85OSBm3VOEmhIuHq9tcyfvVvLqLb+tOlOqOe+ve0Gg3LwZGXsY+VdX9NzrbLAb21as3aZkWkeRItpb2rVyxGofK1vOjizjlb5v7hnm2VUpYBKvzhac4FX4ewd1dX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734487886; c=relaxed/simple;
	bh=oT2pK/7bZi17xIT2UCgWw9uQgkgzgjQczk9IYZRpwJg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=e7P/bmoqg/B+eFj5U/VNguFC7tmbrlKTp+T9A0KyI7gSJkw27fmjYBbPh2u6H5pWBF/MDuFtfMsHYfGnxko0ameLZ/R4pBraHvy+BXiJ3demQkSL8fdjAQVLLUwKf0D/hDuhwa4/QnefxCZzfak7uO/ol3ktvLdpwQAAi8a85i8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=oqf+/tQa; arc=fail smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="oqf+/tQa"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BHFemEB026331;
	Wed, 18 Dec 2024 02:11:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	INKBdaCQF6+CCpfjKX9NmfreGSpoF9sjaQz2mTmkliQ=; b=oqf+/tQaCjpvCTgk
	985w3TfkksyUw/fs8wGZnsizaMlg/9ZSe0xOqe2t8auGjB0dWtea5WCkYrSsW+LB
	vHt4RgIDtOqyuNr8Pzt558QF3Pnpcyf9Jpxp8zMF4PI1KeQEYv8jPH86AVA377hL
	aLZpjib19PYDRcXhr67f7It8QzxuALQ1ZRkgFMj7ml+u8CmKHhgBSSvwzbFkmW/V
	9Ttk7HjoMCSXwK6BYPGlzK2g5ZrnLrk/7h61TcSS8iG0bp2uh+MT8hcO6masNYpg
	mSZJjv30qSx5EmPLyZzBHoZlo+4AmmIfw5RCPXsvdRaOvzaLe5ASk/sJrCBM/pNY
	SQS6bQ==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazlp17010000.outbound.protection.outlook.com [40.93.20.0])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 43kc5bsb15-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Dec 2024 02:11:19 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GqamBk2gOGdrmogc9WqS1owW7czvNvtIYbqGR53FDUXyYnGcA3EF+E4wBjw6oxxpf+CjZF6otUHA9d+Y4CXIeUzMwqJtdRFOiYfhvv3NMwZ1R6dcCv+DL7BsgFJvO6ajnm5iVjVLtvdirqLpUcwHIaJ1xSy+Zxm9sJzhtYMcX9KowikfTCv2e7UW6CASQdsW02zA0DYYbM9trGDwaIkXVxer2s+sF9jDFiIihAEO6ZtpxiBXKpMoCfGu6+lRfyqK6RTuwuTmOgxja4+g3r+pIr3uKVnNfN6bBnkaJUXJbv1wqLM6n2aO5CmS/AFmPWDJ1SM+GZ67CtCy/L36/3UM8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=INKBdaCQF6+CCpfjKX9NmfreGSpoF9sjaQz2mTmkliQ=;
 b=qG/kEQivzoOPVY9CZzn0So2AbsZGzuQzLsW6hX7+o66MSo+XC4R6YRyHxKPH/cXq0XqW/r8KzgTZAAqYeAXSIz/RljrUIOx6DYefmHYGePB1iLxcHd9Q1yVxHeLFOd6iieW8ujtyqPRIdXqpieOcNkUwt47NIIqzjHp6Uc8oKLqwO36zueVqVaeonsAtJNcKqFXXZsLVv7tdbnvAEzEwfp4cYOVZOULm1epB4Fdh/SaC9h81+v9KBpEHgJlZ+kIzpWnMKkcgmc1FAITEgNJw6INbN6i1wl4Py2dMvtUMLzR9JSP0HoEdF9UGkM5T6DlSaT3nRR8UcMOE1aWTvNIeAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quicinc.com; dmarc=pass action=none header.from=quicinc.com;
 dkim=pass header.d=quicinc.com; arc=none
Received: from DS0PR02MB10250.namprd02.prod.outlook.com (2603:10b6:8:192::5)
 by PH0PR02MB7798.namprd02.prod.outlook.com (2603:10b6:510:5f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.22; Wed, 18 Dec
 2024 02:11:07 +0000
Received: from DS0PR02MB10250.namprd02.prod.outlook.com
 ([fe80::3df9:2304:93de:72ea]) by DS0PR02MB10250.namprd02.prod.outlook.com
 ([fe80::3df9:2304:93de:72ea%5]) with mapi id 15.20.8251.015; Wed, 18 Dec 2024
 02:11:07 +0000
From: Brian Cain <bcain@quicinc.com>
To: Nathan Chancellor <nathan@kernel.org>,
        Andrew Morton
	<akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-hexagon@vger.kernel.org" <linux-hexagon@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        "llvm@lists.linux.dev"
	<llvm@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] hexagon: Disable constant extender optimization for
 LLVM prior to 19.1.0
Thread-Topic: [PATCH v2] hexagon: Disable constant extender optimization for
 LLVM prior to 19.1.0
Thread-Index: AQHbPEJbPIGnXNO6vkOUZZyiHFPe1LLq3huAgACMmFA=
Date: Wed, 18 Dec 2024 02:11:07 +0000
Message-ID:
 <DS0PR02MB102502302B8074AFA8BB1BAFEB8052@DS0PR02MB10250.namprd02.prod.outlook.com>
References:
 <20241121-hexagon-disable-constant-expander-pass-v2-1-1a92e9afb0f4@kernel.org>
 <20241217174425.GA2651946@ax162>
In-Reply-To: <20241217174425.GA2651946@ax162>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR02MB10250:EE_|PH0PR02MB7798:EE_
x-ms-office365-filtering-correlation-id: 4a334fcc-a95b-4843-3e28-08dd1f093b99
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?+w2wd3+zGtHLEcWASl7UoKcSED/ZKJyWYHWO5ZA4DEKzj5X1BsM+LyWwg6VC?=
 =?us-ascii?Q?1aXDfRLu4iT1Bt+YMI1xur9Y1NXRBIEAQsPYcV2POXYF0h3XZ42vw9tDHQ+t?=
 =?us-ascii?Q?fQtkNnEzv1Zru19DCkId9PBoW8ouGcVxgY3wKnVAQ98oucmpmXGTKMl+a8qI?=
 =?us-ascii?Q?hp+1a7R290bv94CATl94oCAT6C6fwYjE+v8DhadAYeK2TX+eZOnxovu8tmak?=
 =?us-ascii?Q?vOO6OpM5gjqhBQVeJBlemvprK31JOp4uocCFWAkbLArodXIQYw+9g6iMKZjq?=
 =?us-ascii?Q?rD71gzXZBKlVmiM2mGLj+JWu66IG35wjzKAbt0vwUP4YE0LS0EBv9TYIyoMg?=
 =?us-ascii?Q?BIlMOtaVVKkIUDD1BEK/IRYyIMRcrEX9QlZmpRWsdOpEXeBxb5pkP+SE1r9p?=
 =?us-ascii?Q?ySvd193nO0JsyAnIxR8nYp4WyECYP7YJznSZpmjdGFbuB/BIAfY/pqjflOLc?=
 =?us-ascii?Q?N4cXa1LhDszKdUX3kH91jcrzqZA9GUKcCe2LaEn3FxFd7wzWansM+Jp6h06U?=
 =?us-ascii?Q?yVnGAkCOLS152PXWRgoy/dg/8kXOWpcixAVKVHAXYNOAHqyEoWyDmyGhmAJO?=
 =?us-ascii?Q?wFyH6sv20D9jEdxHOa6ymBpf/0Xe0mxlR8+3ufhO1RWFVVUjCj3MutAne+e/?=
 =?us-ascii?Q?1GUvSJ1hOLXsC/5dVogeTRHZgMGheQdB4PbJYg1RH3h3nVRA5OxgSulLlA6f?=
 =?us-ascii?Q?hVQO6FEMnJfzkcdhAbgrI1nSrgoYnJAumKHUdRrYhHKDF1jbhNKmx3GMNUWt?=
 =?us-ascii?Q?RaJR/llzJu2lK+oO8KrDi90KKbonhWQfc3P6XV00Qh7e0+qSoC9rmJZd6wdb?=
 =?us-ascii?Q?BCZlmqLX1ApVier8g5AigbbGX9m1wxG8tRNDTs1sba8LnKkwzcEW/61GqAo4?=
 =?us-ascii?Q?QJ5u9v5/gS0xoNipSkXHD5PIeVzIaZh58bGnY4iA+1VgrNhXjyghOcyWcl18?=
 =?us-ascii?Q?4/F/jxPsH+oO0I4aytgaxUWoUvQKAWg9DegYdNJX6Qy8Hvn5GnZmTMe7/nTh?=
 =?us-ascii?Q?M3NKPlLuvbCYTbKBPhivf47oSdOelJ2RGwdkURVp0ouUuJ0402EZraemmUW+?=
 =?us-ascii?Q?rzHkvFn0m6kdHGN4rxsU4Cbne3/KCbBqoLBl56wNO9Y9pRbOb6/fYLAV7I/l?=
 =?us-ascii?Q?977JmfpiPPJEdQvIc/v4Wct7Cv1PYlXP0MWR6vQs3b4pWEVdsvGLf/VFsP6d?=
 =?us-ascii?Q?61w9RJl/c3DvHYZbRAiMNEvHnHuWZYDHUOsLz2qwTxy6NSHBeJiynuu9OWVu?=
 =?us-ascii?Q?PiSuSJfEUOaQXAq3KZPN5Nt/KQGsbZsoc+wZmsjADOuBt4zANITSMS/GWoJC?=
 =?us-ascii?Q?ZGE7s1yb0w6TXs34JLjyRl6XnLdJznQN0/3JAA0LM+oBPKPinNEicorSpGf1?=
 =?us-ascii?Q?Z/mYE0aK8FtxhtrYUX6EpRU1/5GsTln+j1EsD+NBuMLRWsJowRVdi7XO12lS?=
 =?us-ascii?Q?ahFtJeqR4/96xkrvFy55bTDEskXQfI/G?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR02MB10250.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?8QfOe1OjfqESk7CM2wl3bUGvy+dRCAYj8qhSYtzSLgi0OKmG/pOB/7uVubP0?=
 =?us-ascii?Q?Wy+/LdaVWZdVgTEqilagY3N7H6CCpmUWfpYXQ1cIxZ3VRuwOHpmWNAZcgyOL?=
 =?us-ascii?Q?frtJW0sFyh/aVl/WigdlExCZVgawRTktOxNjN5pAVG68DDVyoxKEfGo7HRNs?=
 =?us-ascii?Q?wrbyxDHCtQ8XsgegjDtJ31btMZPlMwDLcWHQOoZk03fbhwa/8Au/274yZuL6?=
 =?us-ascii?Q?F0PUj3C1pB4RBjn8JThRtzrkQiSIcR+X3LhtA7WxcRDaoejSqXAWkhiVjmeT?=
 =?us-ascii?Q?TpYbcx44a5F4GHU0GxzaXdswo3EoT1YkrVM0/mMvYZ0zrGBdWZ8XxrmLNFBn?=
 =?us-ascii?Q?+hNwnWhqAzf/aXDkYy1axTcM8nrCndf0NIZpXpbh656OC64JsioowoUw2OFc?=
 =?us-ascii?Q?Oj2WVPN6Sdwkso1eqFG5J3jeXGOxPZKteXUZ/3I5j6yyNZh1cgzuduNSvGRN?=
 =?us-ascii?Q?pZu6U2DdoQybXZV+JKXW7MMwCZyRMF718AlJcOdHDFXG5Fd/Ww81DmnqUq5W?=
 =?us-ascii?Q?+dR8IQsav4V82K916cqENK82D8t0+mqhPOycRvdOpbBqhiMp/Rw98ClofEEI?=
 =?us-ascii?Q?mfXgX8ZSBB5SAynOKt4VS9lVzUATnCWFfmtuxWPu3EWmI4dGFDOmkLsDypQ1?=
 =?us-ascii?Q?h+aOa0jNcXm+Kge/+u9lCSpP4zggxxmvna7V/+N/4nf8fuxs0Z6RhAYQRSLw?=
 =?us-ascii?Q?rZ9cRrE+3/+xnH/1B64s+TZKLz8YoVLLBSmqfiwsoYtE9hLAgS6v+W1Jgjfz?=
 =?us-ascii?Q?IjDuHCXG8Jjy+ARalzOzc56qBVM18Pqiwc4REYikpnMDWLM7FCtWXZJatDbQ?=
 =?us-ascii?Q?ZdpdSfZ7hzOP127eU9BpnZ5sXV8qxeUMMnHXbix99xPGFxzsCnvD+RWzc2jL?=
 =?us-ascii?Q?cvTfC7NueaXPdFE5XJ1KNGEVHhK6WGt6tlBGjrWQpA1vj0/jsQWIGVdkr/yw?=
 =?us-ascii?Q?KBYIrynEmyo1rMzJZx9bk5qCYBNGDz/LJOynk+Nidy6F4Ss+M5h+7XC4TU2x?=
 =?us-ascii?Q?ZOZ+D5W6SNxIssVWHPaDjH6dOIm/Ox7FMd7RsrnqN3D7kAZGkKZp189I3oBY?=
 =?us-ascii?Q?8l3KZ0nQnO26u9lkYxVgoIQwOFIo/O4mb7IXKEayYnADsFHVDJf7aFQgZuhG?=
 =?us-ascii?Q?aqxdrxvkrqSUHZQHBFC0dPcbYkxBJrlPEKeXljIq30yWjDLMekQDOpvWao0O?=
 =?us-ascii?Q?PSZn10QXcPIprhrQzDmJ9bI6xDLvylxplb3qoMZ8xKj9Sdp/zKhXcXcqZdB8?=
 =?us-ascii?Q?fHy8fQ6JH4VqckyOrIMSh8TJYSbmS7fDjiISuSj/CfklhMJrHoUE3ZTr5Cu+?=
 =?us-ascii?Q?rGKNA4/g/+mcbZDRnjBlC1zY9b5p+OGkYAsatx5skk0+n7MytAmo+bfjNr0w?=
 =?us-ascii?Q?Oz6zlmLsnszxmv9U370O6PqRsF3Jk/IJ6AdMW4Ok5np1+irgqJKYveRYVMqX?=
 =?us-ascii?Q?OVdbibeRyjBdE4uFaSJDf5iesHBG3hbsDPzEA4sPqM9DUffik2Wz/8yt29IB?=
 =?us-ascii?Q?nVKhUXFGHGFnRRMPy+B+LIimSr+9B7l4aX15TCUnYsBgiaBNAOFwGQ2oJMyE?=
 =?us-ascii?Q?K+hdxEhNpppCtDAsvm9oIabHY1sYIafbWHD/NgW8?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xhSqst2IRNzFkP9+/qyy/CAgYMLu2s7Vy5MokZETf6YpK2+QvJOL+WmEVCcuz1n+r+6zw8SjfnIzOjC1oWGGJngmx0HzrL+Yqjr58wUdYhxk7NTeLOfJ5LzVme8HuITUas6uHXC7333wzCyX+yFZdkqv0PaFgTNrORqpjQX304GXygXF2UNnxAAJwnyTz8y2bZ1mn5lW40I7/qQ5yDHBCz+WglKYU6VkGPcxGxZgsJS3MaOLPN1oel3ro6z+nLEIgDihDvYuQl4Ej0vfSTbNkCduEBQTHnmLN1SCVwWiLgvUJShu2vOvnQey6RodZZLA1Ht4hGUNBivoza+qt1mQCF8iSpQz95PU8qi+S7GqMt5ME2hVnT79/eCHDBtM4Xy5p92AgaSTT6VfHcfo3us0cFwVboLdEQiO+oaBNrW+sts8psyABNErIDlAGWsLpFreJEseBxHv6o2VE0I87sPfG9ScCnZ8piNPpcobsOReIEM6XYOrSBhhWhL1igEtT48DaQqNexVwghbqiEa491u9Rlx45XWar/z7cLAx7Mq4al159Jq7G+DFHjtOCz31SgwzJQ1Nd4CJj0+pzWmioH8GWPh1GhIOMYANDFAzmz4cytXEzNd0IPVRRseV3UYLH8fX
X-OriginatorOrg: quicinc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR02MB10250.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a334fcc-a95b-4843-3e28-08dd1f093b99
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2024 02:11:07.1103
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vv6ZTv8Eo1NH+EUq3sJ2IE/8I4zbpVS3YNM7Qe6naWtq/kiVzNNZOf8lf2SNX27U0DE+7BzdoGPaZPH+YXI7mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB7798
X-Proofpoint-GUID: gSQJu2zmOHc4kSKy9Dsb9J5ekE13np-p
X-Proofpoint-ORIG-GUID: gSQJu2zmOHc4kSKy9Dsb9J5ekE13np-p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 suspectscore=0 impostorscore=0 mlxlogscore=999 clxscore=1011
 lowpriorityscore=0 priorityscore=1501 adultscore=0 mlxscore=0
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412180015

> -----Original Message-----
> From: Nathan Chancellor <nathan@kernel.org>
> Sent: Tuesday, December 17, 2024 11:44 AM
> To: Brian Cain <bcain@quicinc.com>; Andrew Morton <akpm@linux-
> foundation.org>; Linus Torvalds <torvalds@linux-foundation.org>
> Cc: linux-hexagon@vger.kernel.org; patches@lists.linux.dev;
> llvm@lists.linux.dev; stable@vger.kernel.org; linux-kernel@vger.kernel.or=
g
> Subject: Re: [PATCH v2] hexagon: Disable constant extender optimization f=
or
> LLVM prior to 19.1.0
>=20
>=20
> Hi Linus,
>=20
> Could you apply this change [1] directly? Brian has reviewed it and I hav=
e
> sent this patch twice plus another ping for application [2]. I would
> like to stop applying this in our CI and some other people have hit it
> as well.

Nathan,

I'm sorry.  You should not have to send these changes to Linus. I should ha=
ve carried it in my tree and proposed it to Linus.

I'll do that, if you don't mind.

> [1]: https://lore.kernel.org/all/20241121-hexagon-disable-constant-
> expander-pass-v2-1-1a92e9afb0f4@kernel.org/
> [2]: https://lore.kernel.org/all/20241001185848.GA562711@thelio-3990X/
>=20
> Cheers,
> Nathan
>=20
> On Thu, Nov 21, 2024 at 11:22:18AM -0700, Nathan Chancellor wrote:
> > The Hexagon-specific constant extender optimization in LLVM may crash o=
n
> > Linux kernel code [1], such as fs/bcache/btree_io.c after
> > commit 32ed4a620c54 ("bcachefs: Btree path tracepoints") in 6.12:
> >
> >   clang: llvm/lib/Target/Hexagon/HexagonConstExtenders.cpp:745: bool
> (anonymous namespace)::HexagonConstExtenders::ExtRoot::operator<(const
> HCE::ExtRoot &) const: Assertion `ThisB->getParent() =3D=3D OtherB->getPa=
rent()'
> failed.
> >   Stack dump:
> >   0.      Program arguments: clang --target=3Dhexagon-linux-musl ...
> fs/bcachefs/btree_io.c
> >   1.      <eof> parser at end of file
> >   2.      Code generation
> >   3.      Running pass 'Function Pass Manager' on module
> 'fs/bcachefs/btree_io.c'.
> >   4.      Running pass 'Hexagon constant-extender optimization' on func=
tion
> '@__btree_node_lock_nopath'
> >
> > Without assertions enabled, there is just a hang during compilation.
> >
> > This has been resolved in LLVM main (20.0.0) [2] and backported to LLVM
> > 19.1.0 but the kernel supports LLVM 13.0.1 and newer, so disable the
> > constant expander optimization using the '-mllvm' option when using a
> > toolchain that is not fixed.
> >
> > Cc: stable@vger.kernel.org
> > Link: https://github.com/llvm/llvm-project/issues/99714 [1]
> > Link: https://github.com/llvm/llvm-
> project/commit/68df06a0b2998765cb0a41353fcf0919bbf57ddb [2]
> > Link: https://github.com/llvm/llvm-
> project/commit/2ab8d93061581edad3501561722ebd5632d73892 [3]
> > Reviewed-by: Brian Cain <bcain@quicinc.com>
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> > Andrew, can you please take this for 6.13? Our CI continues to hit this=
.
> >
> > Changes in v2:
> > - Rebase on 6.12 to make sure it is still applicable
> > - Name exact bcachefs commit that introduces crash now that it is
> >   merged
> > - Add 'Cc: stable' as this is now visible in a stable release
> > - Carry forward Brian's reviewed-by
> > - Link to v1: https://lore.kernel.org/r/20240819-hexagon-disable-consta=
nt-
> expander-pass-v1-1-36a734e9527d@kernel.org
> > ---
> >  arch/hexagon/Makefile | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/arch/hexagon/Makefile b/arch/hexagon/Makefile
> > index
> 92d005958dfb232d48a4ca843b46262a84a08eb4..ff172cbe5881a074f9d94
> 30c37071992a4c8beac 100644
> > --- a/arch/hexagon/Makefile
> > +++ b/arch/hexagon/Makefile
> > @@ -32,3 +32,9 @@ KBUILD_LDFLAGS +=3D $(ldflags-y)
> >  TIR_NAME :=3D r19
> >  KBUILD_CFLAGS +=3D -ffixed-$(TIR_NAME) -
> DTHREADINFO_REG=3D$(TIR_NAME) -D__linux__
> >  KBUILD_AFLAGS +=3D -DTHREADINFO_REG=3D$(TIR_NAME)
> > +
> > +# Disable HexagonConstExtenders pass for LLVM versions prior to 19.1.0
> > +# https://github.com/llvm/llvm-project/issues/99714
> > +ifneq ($(call clang-min-version, 190100),y)
> > +KBUILD_CFLAGS +=3D -mllvm -hexagon-cext=3Dfalse
> > +endif
> >
> > ---
> > base-commit: adc218676eef25575469234709c2d87185ca223a
> > change-id: 20240802-hexagon-disable-constant-expander-pass-
> 8b6b61db6afc
> >
> > Best regards,
> > --
> > Nathan Chancellor <nathan@kernel.org>
> >
