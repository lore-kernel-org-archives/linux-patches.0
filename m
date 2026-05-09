Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11020107.outbound.protection.outlook.com [52.101.84.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C377032AAB5;
	Sat,  9 May 2026 20:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.107
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778358364; cv=fail; b=SvtSufC6GMS51KEsH5b2eaqb11EWTr5Bwy2IV4zq2BI+b4eq9w5bsEVVMWv4z7eWWqFmrcfDTSEq1SPBba0GH26kPKx+pY0BnptvGMwuG52P5XDY5OO0yWhKZKbzSZlXqy+7RYa3RyZhSDQDsoYO0leZzuilBpoReK9egIxPK/A=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778358364; c=relaxed/simple;
	bh=C5Km24IcKg+Ymu5ZOjKzf96dV0vSJ/aB/WYvIwA6uhI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=P+nqSEJDwynEwQlwZNYdhXpGjrJUzO2A9lUM61l+DajbhfHwg8eqq/EIAP81QF5ObLV+Zw3b3aQMFpLcZKJByq/BfZ3RUUJZST7qFbxUnLhOvr+AtSmkjt5G4L0s6yXnChvfO+aJhmzj7Fs9N1Woik7n5mZJeXfoGoZWBVpdo9Q=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=solid-run.com; spf=pass smtp.mailfrom=solid-run.com; dkim=pass (2048-bit key) header.d=solid-run.com header.i=@solid-run.com header.b=isXxdlMt; dkim=pass (2048-bit key) header.d=solid-run.com header.i=@solid-run.com header.b=isXxdlMt; arc=fail smtp.client-ip=52.101.84.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=solid-run.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=solid-run.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=solid-run.com header.i=@solid-run.com header.b="isXxdlMt";
	dkim=pass (2048-bit key) header.d=solid-run.com header.i=@solid-run.com header.b="isXxdlMt"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=isFr7/Twkw8Z/8rVrqGu+euCePZWCrvb0lYUBA5YZaPd3pg9B8FNzMkHTFQenvefcOapUqhwGzVOT0RE1+09Q1L1yZF09f3F6wiYsE+HpFOT+87qhDKLWS5Pjn2WX7+UPzpJi75RxYsFBwUKJkRqZyTnnpHp9fJM0+IjrnJrbVScKiLInTYOj7JlMKoqPNArRB9TnF1at1CcntcZo7kCRx19JA/xHS9+dkj4Yyuc9psSxOUNte209hVXKUyT1kILzNZfDsZPwwicuTTGNzgDhun4WsC2OiL3BORqoi3f/JOi2H/Leqz1cl40becmlWCGbdxyBQWr4JJLhhCaZ5OmBw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C5Km24IcKg+Ymu5ZOjKzf96dV0vSJ/aB/WYvIwA6uhI=;
 b=gCoWK0/mbdGKhlWORf78fBJMKBm4dBCrdRRNmIFXEkmzOMjahXBtq1Nx2GSQBxpbPqEa2aTPBMf63SL/EAHPU23M8r6zUdGnt9sS5knxIydvid6XEuL2K83S96E++Zoa38747nM0UUjqthwgkprrpwSLjq8ORF8jAGdI2Ok/fOhE0jTVtlVY75wbxqzHyT7gg7hbRFW2tGbV8FAXtHu4opaSexuZtMJmiq+l+wnR00pj9e7+6pwuLQzGNhjMW0avi0NtmXILBQKqED8cm87oM1i8y/Yka644BXB4sg+vVGjMh5quh9Pwdji3RZrY+1NNSvQv3gK7Rftup3Rljr3vAQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=fail (sender ip is
 52.17.62.50) smtp.rcpttodomain=8bytes.org smtp.mailfrom=solid-run.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=solid-run.com; dkim=pass (signature was verified)
 header.d=solid-run.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=solid-run.com] dkim=[1,1,header.d=solid-run.com]
 dmarc=[1,1,header.from=solid-run.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=solid-run.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C5Km24IcKg+Ymu5ZOjKzf96dV0vSJ/aB/WYvIwA6uhI=;
 b=isXxdlMtHp0G/PY2nF1SDxOPCODlJjipcWKN///KYRgDOBgV41Z/baXuZlX7fqZh1YlXCognKFe5TWQQNJ4tevtL9+HdfHRRfZ03UIVpjgittrT0iOkfgHP9GQ3r9YxEfBhDYyKEaaRjAi57b4gHKejbhYDDOg98hy5VpJldNBkYvl6ox7eIdVt5Qq8Wr631AnM3SS9EtBJ1Tc2Fl1VOD4q0wqAJ2Qen7bhpFAK1R6vroo7Sipgl4cv9zeiXfCMegxQpFtq6GowRheURmv+DuThl93tnLGFd8rugNO2A93jtJSgg1MwftiWyo1WJRRh0V7OtZgKRTiZg3YuyTW2D7w==
Received: from DU7PR01CA0001.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50f::16) by VE1PR04MB7343.eurprd04.prod.outlook.com
 (2603:10a6:800:1a2::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.32; Sat, 9 May
 2026 20:25:46 +0000
Received: from DB1PEPF000509F1.eurprd03.prod.outlook.com
 (2603:10a6:10:50f:cafe::7d) by DU7PR01CA0001.outlook.office365.com
 (2603:10a6:10:50f::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.21 via Frontend Transport; Sat,
 9 May 2026 20:25:46 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 52.17.62.50)
 smtp.mailfrom=solid-run.com; dkim=pass (signature was verified)
 header.d=solid-run.com;dmarc=pass action=none header.from=solid-run.com;
Received-SPF: Fail (protection.outlook.com: domain of solid-run.com does not
 designate 52.17.62.50 as permitted sender) receiver=protection.outlook.com;
 client-ip=52.17.62.50; helo=eu-dlp.cloud-sec-av.com;
Received: from eu-dlp.cloud-sec-av.com (52.17.62.50) by
 DB1PEPF000509F1.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9913.8
 via Frontend Transport; Sat, 9 May 2026 20:25:45 +0000
Received: from emails-9651952-12-mt-prod-cp-eu-2.checkpointcloudsec.com (ip-10-20-5-220.eu-west-1.compute.internal [10.20.5.220])
	by mta-outgoing-dlp-588-mt-prod-cp-eu-2.checkpointcloudsec.com (Postfix) with ESMTPS id C73707FEC6;
	Sat,  9 May 2026 20:25:45 +0000 (UTC)
X-Mailbox-Line: From b'josua@solid-run.com' Sat May  9 20:25:40 2026
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IlYzKrmgDrkHwoxLR8Bi41XRdrWBy4ss6gIAa9EXW9XZejmmds7I5yPZs1tscoefixCECvPvcJb4VeD5wXAFkhw5ag5qdmWH0nsl6DSsivIW33I0rM2KOYselOfY4GEaOVDOOirNKe4Q5ouk1W7uILDALutC0JIT7vzxH7wGck8s4CU1R+JSXdPt5C/kQ1GJjunIUUGT09f4hF/q485/0NgIgGGYXTA1J9XW5kQwJedZc9kOXvYd9MJajlJYiKcS6SXtMz454T9KTF4J6TMjArtDVRKMkldEmvKuhbmG4/6pbTL0n9cIH+ZvtgyFEof0hJ9tx00tqNEJYOMpPL4F3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C5Km24IcKg+Ymu5ZOjKzf96dV0vSJ/aB/WYvIwA6uhI=;
 b=SSpmR5lD+wEUzlesXsJ9xuLSkRj4Wc/Lvb0VMov4zbFMXnPnYh7SCtzNS05WwMrFwjheSpzqD/U0ME4mgARoohHXLrspiXq1gr9hA/j3FaQe9v5yaohAcIQugbx55o3Ne6/puaRFc1TciPe2akcGyCOdq+isvMLXt4USEVfEPl83+5VyFJH4Ye/akA8KTeDECcTE2I6T22qqTEjTI1r9GTtm0ZC79YcN1f0xAwuvO8NB2T83NQx7nMKZ2DjjVvWvaY/6wv9e9jXWh7WVM1hfPLkfCgQV0/S3Y14a5Vq6mwMmWagF6nbc2yvFLR+TWMhX7hbd/Sp1q+OUEqRoAsAI+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=solid-run.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C5Km24IcKg+Ymu5ZOjKzf96dV0vSJ/aB/WYvIwA6uhI=;
 b=isXxdlMtHp0G/PY2nF1SDxOPCODlJjipcWKN///KYRgDOBgV41Z/baXuZlX7fqZh1YlXCognKFe5TWQQNJ4tevtL9+HdfHRRfZ03UIVpjgittrT0iOkfgHP9GQ3r9YxEfBhDYyKEaaRjAi57b4gHKejbhYDDOg98hy5VpJldNBkYvl6ox7eIdVt5Qq8Wr631AnM3SS9EtBJ1Tc2Fl1VOD4q0wqAJ2Qen7bhpFAK1R6vroo7Sipgl4cv9zeiXfCMegxQpFtq6GowRheURmv+DuThl93tnLGFd8rugNO2A93jtJSgg1MwftiWyo1WJRRh0V7OtZgKRTiZg3YuyTW2D7w==
Received: from GVXPR04MB12057.eurprd04.prod.outlook.com
 (2603:10a6:150:313::24) by GV1PR04MB10895.eurprd04.prod.outlook.com
 (2603:10a6:150:20b::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.21; Sat, 9 May
 2026 20:25:36 +0000
Received: from GVXPR04MB12057.eurprd04.prod.outlook.com
 ([fe80::14f1:a127:2988:de5b]) by GVXPR04MB12057.eurprd04.prod.outlook.com
 ([fe80::14f1:a127:2988:de5b%7]) with mapi id 15.20.9891.019; Sat, 9 May 2026
 20:25:36 +0000
From: Josua Mayer <josua@solid-run.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "iommu@lists.linux.dev" <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>, Will Deacon
	<will@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Samiullah Khawaja
	<skhawaja@google.com>, Rabeeh Khoury <rabeeh@solid-run.com>, Yazan Shhady
	<yazan.shhady@solid-run.com>, Jon Nettleton <jon@solid-run.com>, Mikhail
 Anikin <mikhail.anikin@solid-run.com>
Subject: Re: [PATCH v3 2/2] iommupt: Avoid rewalking during map
Thread-Topic: [PATCH v3 2/2] iommupt: Avoid rewalking during map
Thread-Index: AQHc39sACvHk4VMZZ0WALRRWUdEbBbYGF8iAgAAMfYA=
Date: Sat, 9 May 2026 20:25:36 +0000
Message-ID: <ac1aae2d-9b5a-488b-aad7-7be542ec8102@solid-run.com>
References: <2-v3-a1777ea76519+370f-iommpt_map_direct_jgg@nvidia.com>
 <321c2e57-6a17-4aef-ba42-d2ebd577e472@solid-run.com>
 <20260509194053.GM9254@nvidia.com>
In-Reply-To: <20260509194053.GM9254@nvidia.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solid-run.com;
x-ms-traffictypediagnostic:
	GVXPR04MB12057:EE_|GV1PR04MB10895:EE_|DB1PEPF000509F1:EE_|VE1PR04MB7343:EE_
X-MS-Office365-Filtering-Correlation-Id: eb0552a1-d21e-42ad-33d1-08deae09269f
x-cloud-sec-av-info: solidrun,office365_emails,sent,inline
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 9E5c0mvAGilN0sPkaks/147KwE3pEZ7pfQYN8PvIspTm1IVchXDBNLV1Yo8TzWs8kfFW/3NgWfC/TYu2MQrS/rMpD1GyuR70rTc4yPfY6jjXcfaUJ3MlnCUWzvAJXsoAl9el4oFuIKwQnrhujq635P8wX673MWtHts63BI0K2iuh5HvWDbZgUUDNVI7l8mFa2rpFdycYcAqeedpF4z7PVYxkt/byBUKqAIKqyToMJdbc8NbGyeXqTSTQCWtRjINGV18t/q8tS/IFsckz0EKQvqTELk5R+BuVj3gl30ubnqYmy5dhCe+8mHu3ULlNczEvui6QxLLMwDFWMcEitqb9kutfceHq7JWW9KUjbEZumTj/jySjIGK98VrpuzOaRQ9WJkyZlcLr96gY0YLr5iweuEhQuNVtU5j1MqrtwuP7kdn8q5fc72lHw8MArzm///K4ejGblwVWzmiDE+/GSYcM4KiwrDUkxNhchjcSJjJ+qMOtcKmbuNITRY6lysXZSyxHxzIHTuhIhs5s3fTijX4U9MHUiFfYZORIKo4WOlMZX+ieyvzkTsWOyxhfWllt3Lc4mfzDryhDr0iGt7RYXsAZZ2XpPnUGxzm36/8I1XnhJttlvIeSAIGnMW803WOvnEWOu4RmjB3udcndRvAQLaKN8GJXZeBW6JGWNiSTVEbfZ9cWRT/Z2DatciyOEwEe73PkLDXxItBc1vZa5TiVepAncTD0ay6a4elDNzWNsHeT2KyjALYlGyvvoaM8bodlA6R1
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR04MB12057.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1102;
Content-Type: text/plain; charset="utf-8"
Content-ID: <75CE7A0EDAC85A49BEF45E7D1D830FEB@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 tTAgDOXI/lCjGESxPy2RlYENVGNzUpYFeWfVZF2sQZesya+lr6nI/HAf6T+NEZyOzSMzKunlrL+mDCnUNkeCqhiz6xxAjOVIoE4flqfEb28QsMRlEIvvjLG5ACoBGnu4oVu01WKGSaU4bfCt7UVu1L/E6VI3eYfQsxBAhXMh42SVz+iBOIciNkdOqybcBwzcAHLJmX356v67gADXVtppyZpm+Q6m22+Dvq06G4CDPXsNHeTvpNLz2DmXpDHW5MeZLybdlha1MjT1rTV6yFbUMyPj8udcyha0ZfdG4M3VXRJqUmz/v8CKnPV+dK6Nc0JJVFupuhosXA2TCfvYBHvumg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB10895
X-CLOUD-SEC-AV-INT-Relay: sent<mta-outgoing-dlp-mt-prod-cp-eu-2-7.checkpointcloudsec.com>
X-CLOUD-SEC-AV-UUID: 779dc0553a0c4ed086841bf10e38bd75:solidrun,office365_emails,sent,inline:8210ec7cf95fec90986a7578c9e696c2
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F1.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	dac64a17-dac4-452b-5e4e-08deae0920d5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|376014|1800799024|36860700016|35042699022|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	liAQzkB/fC/KRkSnuQY5F7tNwIKo34eD/QVAxC9O1hqb3hTFBj+Xl5KJTFrB7oc2xYQRUU6VTppEHcT1Cdy7gKnpDPSu8hVplDrfpkIB+qsQSzDJ5ISnd9eJF+so68clsk6/GPPOHOGZAm4r+i4YRpUBofx2xigxXWjgGqfjoXSfCn9AT2a/02QIB+IAzuIt1FBvJ7De+RCK5hQIhelQrXgMAQDpAOJPffycat1fx8l/YFiqEvNpMF6YIa10WlgcRtjpwbJhju0DqT9BS6kS8yTLEHCUtAp73aXMZ+ahZ0o3vkin/y3vGpO8D0LIOdDXZhe02rWQNHB6XE15Ad7kb0113un72xzXVb/RDDbSMRTbR1ibRSI1l9Pk7m3eBlOspxvoCT/CH0/inZhbal3Wk6xoWmC7dBdHbl4kfobVPD6GC5zevBgqV0vbGuTNF5Pxlk9+Tgs4nhDNvlanRMpJq8nt3h7bDRpbO5RbKc0tmOc0pfv0aDw99mGJD5VHZIkfcGG81doUBDMoXH818g5TlLzRETPsogDivh8C9OrnzdrWSU0oYusnpfFLafok9oQF1ffVMDHZRrvixKY4lrb4QSvlW5BaqVBc9ePOBwWqsRanCeMHIUla77qeR2BvkvDnVhRtbfBofpSZKHvc/obBjbcU3VwdTYJAAuRR3bwWkGgAVeduSnPYZabgAGSpbarVxnuxzct+oya+M2H16zgc0EI29qqsKC0qxrAE5BzX9ws=
X-Forefront-Antispam-Report:
	CIP:52.17.62.50;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:eu-dlp.cloud-sec-av.com;PTR:eu-dlp.cloud-sec-av.com;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(376014)(1800799024)(36860700016)(35042699022)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	f3nGMIr8XRTZXA1gzUIQ9Yxist2F0SH4HN+idY6Yv5VLESRao/faVY24yoJvmjiRnXIYLbftgC5idp9HcS+2dlqvnNinTg0x4dWDZmzuhZRFAotse7NuWGRINUv0jyu6Phfh//p+0YL9bOYbd2ojZOzxMnRY0+jVfZ8MFeNV/tWkSVrEg490hbk3EK/a/vLtZsMZmppJFI1jpTvP/rqJzzqi801ttnl/CmGMbFVuIhfXfnwqK/N+41uX4N/kq9f5j88AOn2XPQQXYjQ2aU98S0Lejz7Cy4vM2FsiR2QoQblisYK3q/ZuFFKZtUJoYe8pRAL77a7kuIj/UOG4htaz09vrxizDs0X3IuvNiuxQxY2+ubAwtfgvgAPc1PuKgj46tcv9UCfXDlWpI/3SDSGllNVPNvXRRe8YqYJTaO5Rz3OKSKBR3hjxHx98n6lpcU5o
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2026 20:25:45.8679
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb0552a1-d21e-42ad-33d1-08deae09269f
X-MS-Exchange-CrossTenant-Id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=a4a8aaf3-fd27-4e27-add2-604707ce5b82;Ip=[52.17.62.50];Helo=[eu-dlp.cloud-sec-av.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F1.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7343

SGkgSmFzb24sDQoNClRoYW5rIHlvdSBmb3IgdGhlIHF1aWNrIHJlc3BvbnNlIQ0KDQpBbSAwOS4w
NS4yNiB1bSAyMTo0MCBzY2hyaWViIEphc29uIEd1bnRob3JwZToNCj4gT24gU2F0LCBNYXkgMDks
IDIwMjYgYXQgMDU6NDE6MDJQTSArMDAwMCwgSm9zdWEgTWF5ZXIgd3JvdGU6DQo+PiBUaGlzIHBh
dGNoIGhhcyBsYW5kZWQgaW4gdjcuMS1yYzEgYW5kIGludHJvZHVjZWQgYSByZWdyZXNzaW9uIG9u
IHRoZQ0KPj4gYXJtNjQgU29saWRSdW4gTFgyMTYwQSBDbGVhcmZvZy1DWCBib2FyZC4NCj4+DQo+
PiBTaW5jZSBkNmM2NWIwZmQ2MjEgKCJpb21tdXB0OiBBdm9pZCByZXdhbGtpbmcgZHVyaW5nIG1h
cCIpLA0KPj4gYm9vdCBub3cgc3RhbGxzIC0gcHJpbnRpbmcgbWFueSBzbW11IGVycm9ycy4NCj4+
DQo+PiBQbGVhc2UgZmluZCBhdHRhY2hlZCBmdWxsIGJvb3QgbG9ncyBmb3IgcmVmZXJlbmNlOg0K
Pj4NCj4+IC0gZ29vZC50eHQgQCA5OWZiOGFmYTE2YWQNCj4+IC0gYmFkLnR4dCBAIGQ2YzY1YjBm
ZDYyMQ0KPj4gLSBjb25maWcudHh0OiAuY29uZmlnIGZyb20gdGhlIGJ1aWxkDQo+Pg0KPj4gSXMg
dGhlcmUgYW55IGFkdmljZSBob3cgdG8gZGVhbCB3aXRoIHRoaXM/DQo+IERvZXMgdGhpcyBoZWxw
Pw0KPg0KPiAtLS0gYS9kcml2ZXJzL2lvbW11L2lvbW11LmMNCj4gKysrIGIvZHJpdmVycy9pb21t
dS9pb21tdS5jDQo+IEBAIC0yNjY5LDcgKzI2NjksNyBAQCBpbnQgaW9tbXVfbWFwX25vc3luYyhz
dHJ1Y3QgaW9tbXVfZG9tYWluICpkb21haW4sIHVuc2lnbmVkIGxvbmcgaW92YSwNCj4gICAgICAg
ICAgICAgICAgIHJldHVybiAwOw0KPiAgICAgICAgIH0NCj4gICAgICAgICByZXQgPSBfX2lvbW11
X21hcF9kb21haW5fcGd0YmwoZG9tYWluLCBpb3ZhLCBwYWRkciwgc2l6ZSwgcHJvdCwgZ2ZwKTsN
Cj4gLSAgICAgICBpZiAoIXJldCkNCj4gKyAgICAgICBpZiAocmV0KQ0KPiAgICAgICAgICAgICAg
ICAgcmV0dXJuIHJldDsNCj4gIA0KPiAgICAgICAgIHRyYWNlX21hcChpb3ZhLCBwYWRkciwgc2l6
ZSk7DQoNCkkgYXBwbGllZCB0aGlzIG9uIHRvcCBvZiB0aGUgcHJvYmxlbWF0aWMgY29tbWl0LCBh
bmQgbXkgc3lzdGVtIGJvb3RzIGZpbmUgbm93IQ0KDQpXaGVuIEkgY29tcGFyZSB0aGUgYmFkIGJv
b3QgbG9nLCB0aGUgZ29vZCBvbmUsIGFuZCB0aGUgY3VycmVudCBvbmUgd2l0aCBhYm92ZSBjaGFu
Z2UsDQpvbmx5IHRoZSBiYWQgb25lIGlzIG1pc3NpbmcgdGhlIGZvbGxvd2luZyBsaW5lIGZyb20g
Ym9vdCBsb2c6DQoNCmlvbW11c21tdS4weDAwMDAwMDAwMDUwMDAwMDA6IElPTU1VIGRyaXZlciB3
YXMgbm90IGFibGUgdG8gZXN0YWJsaXNoIEZXIHJlcXVlc3RlZCBkaXJlY3QgbWFwcGluZy4NCg0K
Pg0KPiBBbHRob3VnaCBpdCB3b3VsZCBiZSBzdXJwcmlzaW5nIHlvdXIgc3lzdGVtIHRyaWdnZXJz
IGEgcmV0IT0wIHdoaWxlDQo+IGJvb3Rpbmcgc3VjY2Vzc2Z1bGx5LCB0aGF0IGNvdWxkIGJ5IHdo
eSBpdCB3YXNuJ3Qgbm90aWNlZCBpbiBhbnkNCj4gdGVzdGluZyBzbyBmYXIuLg0KSSBjYW4ndCBz
YXkgSSB1bmRlcnN0YW5kIElPTU1VLCBidXQgbm90ZSB0aGF0IHRoaXMgc3lzdGVtIGhhcyBhwqAN
Cm5ldHdvcmtpbmcgY28tcHJvY2Vzc29yIHJ1bm5pbmcgaXRzIG93biBzb2Z0d2FyZS4NCg0KTGlu
dXggY29tbXVuaWNhdGVzIHdpdGggaXQgdGhyb3VnaCBSUEMsIGFuZCBhYm91dCAyR0Igb2Ygc3lz
dGVtIFJBTQ0KYXJlIHJlc2VydmVkIGFuZCBhc3NpbmVkIGJ5IHRoZSBib290bG9hZGVyLg0KDQoN
CnNpbmNlcmVseQ0KSm9zdWEgTWF5ZXINCg==
