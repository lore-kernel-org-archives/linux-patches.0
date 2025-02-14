Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFF225A632
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 11:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739531187; cv=fail; b=n1IHdYJujT6BwNmgS4MAb4nn7QGUJ/03EEncx9cD/6ssyPpEX3/mI3DGBz0MUfs5awc922Crs9O6EFg3eQgR+iKjyld7zTiXjjFedAZzIaaiWchXn6jDLucoXOSJ78ukWcAA65JxQ30+FGs9sqWWzufK3byygBu8CucdKKAxXC8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739531187; c=relaxed/simple;
	bh=IENB72Jk0JWnnGoj+XBFPFpsYYfNAL96iXxL4133Kmw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Vmg8ydC8excHzodT6sps3BMuZFemMYX6EfapklqNJ9kROctNLlG9CKl09cOggPihLmWMrqa5IyXnp0x06uy3DlD46r+z6jcCSTwfL3FCeA1VaFyb7hdXWnHShgmNfvwXAUHb23oOQUlhXCa24QydAOMTeI10bQjdsEsEfp5b3xM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=rgLvrPy7; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=LiGZgu5r; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="rgLvrPy7";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="LiGZgu5r"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1739531186; x=1771067186;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=IENB72Jk0JWnnGoj+XBFPFpsYYfNAL96iXxL4133Kmw=;
  b=rgLvrPy7McwRqllVej+cgyPCQAbNPHEJuhv5NVTjb3XRYtCnB64JQyiQ
   AYTcmAkoXmyy9vWYxgGSXQW0jA2/dVBVQe75nTfxdNRBGBjsgpHxEs1C2
   KMYGYfPhmFXP/E3wuo2lqDHU16kzmfNWLMjXIrqNzO14OhTHYkOOCFQK7
   pVR73N5aN06BfJ7j3mq/aA5nq/rryE5BeKPzpQzi3K+vPryH8UsQlfzjv
   ynxRdsSDrAX8HHHHjPBUEG3HuPkrhZwxf+gWU00eZgte6e4BSQtpoidWQ
   uuuTPRI6aCSdJ7hKdGIgXsqdFLg2QqXBr5waEKAnqqp/Kae1qyZgI46Nv
   Q==;
X-CSE-ConnectionGUID: iwAAHmv5T7quoL6TBpvjsQ==
X-CSE-MsgGUID: SM7UcLZzSvyDSDf2YuoFrg==
X-IronPort-AV: E=Sophos;i="6.13,285,1732550400"; 
   d="scan'208";a="38459960"
Received: from mail-dm6nam12lp2170.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.170])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2025 19:06:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r6+0bLgL1Sm1nzJI7vXL7zmGrjLPTS3f/cYnlEN4mmwzNeNHNMjGLytuFPW3E4oBs4Az2iBfWVs4IpYejPljVNMfqF3Pif83TIeYW5ZAyOXE/rF5F5dG3gH+GmAwU1J0oecMu/yhkbm5NeGE6KQTkOc4iNP6akWtuu8dXYJWUC+2bIlK0B+tcr0PEefSENaHGMXBAFbsw+5D8wphK1UFN3WCqLBIvnKSnRO8otlqlKwmkOXBELqGtxOvznDWIxYRDb+Ln+ZUJnsr/VFmULMlw7FIIg9jO3fcTUfO+ud0mpuBEhj8h4EeNIFziJVQKbvTj/lZYsq7wUq7C6c/pab3tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iKuCob8f12IeE6mBBt0HP7UfAtGzWI3KYYn5GZlIVUA=;
 b=iY14OuvIGWjuU3xahfDmgAI6kH/U4VdP0TzW4kEmm1YeezlKYvZ4mz/9oPI+8niMAUAlXPb7ZwG0tMWnYzhT2suLVFX7kj9APixBtpjWZ3ApUtHVbsZSTus/68SslMyo+zwbeL9ipuisbYJXzaU/HMEXmyIUiwm0yZmGNmpZgg4mpS2dMDIOeZjQRArf74Yxh9XBBNMnNpYwQjrxqeR5pRjsg6eln2Aec3Hty59/36cdwLrS7VkLd/y8DoG2VsIspAArMvemzTgAwrgkEb2AaZJpjw04Iv19yqplXrFzZVlgU+ES7onpaTdFopYwjgUs3RBnTmIhmcgNAIMsCFfLxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iKuCob8f12IeE6mBBt0HP7UfAtGzWI3KYYn5GZlIVUA=;
 b=LiGZgu5rsyJ89QURAWHAjLh5lG6QI9TfDMk4iKJZUpNpNfjN9SjcTJF+qS/3pxMIdoOcZ9eMvbBUCTxK74YlsuCV8hPvaTZbsJbvj0ZGU7PvQ3swnQ+s9GzDmDKrzD+1JzTAMTxjbR8/HSvPsD4kVnDaCnQ3MZCoN/OTeiqUIns=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 DM6PR04MB6745.namprd04.prod.outlook.com (2603:10b6:5:22a::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.17; Fri, 14 Feb 2025 11:06:24 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%7]) with mapi id 15.20.8445.016; Fri, 14 Feb 2025
 11:06:24 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Luis Chamberlain <mcgrof@kernel.org>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"hare@suse.de" <hare@suse.de>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "gost.dev@samsung.com" <gost.dev@samsung.com>
Subject: Re: [PATCH blktests v3 2/6] block/032: make error messages clearer if
 mkfs or mount fails
Thread-Topic: [PATCH blktests v3 2/6] block/032: make error messages clearer
 if mkfs or mount fails
Thread-Index: AQHbfZBfpRD9PqJ/gUugB1ejFWD/0LNGpdaA
Date: Fri, 14 Feb 2025 11:06:23 +0000
Message-ID: <o2jjul5rypmz6cf3eattvgk3axua576t3he6uprcesabmpnsvs@fp5s3z6yia7e>
References: <20250212205448.2107005-1-mcgrof@kernel.org>
 <20250212205448.2107005-3-mcgrof@kernel.org>
In-Reply-To: <20250212205448.2107005-3-mcgrof@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|DM6PR04MB6745:EE_
x-ms-office365-filtering-correlation-id: 8cffb5d9-125f-445b-2b74-08dd4ce79e84
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?GruhJynEgdG33PNB7/j7zNh1HkQ/AKTFvH2UbmUogtJFROq+grye1XiIm7u5?=
 =?us-ascii?Q?1fE/pAnwNUjkIYYO/HQ607FwfdK2v1AKq9mgVW4KMhLljYHgVSGBXe/W10lk?=
 =?us-ascii?Q?fLLT+z4APtbaCSIz87pksuCEwNa1gPzOL54Qzxgnln5tNAwkEpJqn1Trwrzr?=
 =?us-ascii?Q?EvP6UAHMjT4f9GocDVPTqE22l1+Y81vIwy8IWvQ1PH1JCW3/fRY+fm+RXMFL?=
 =?us-ascii?Q?3I/PlXtQGi6uC36Ae47IqJ9sPIzlDPV3UzaMq278IUzaS2jCEXVxIUL6pfX4?=
 =?us-ascii?Q?2rpQCF7TSdabBUIMLHZ2nvYaxdFtYeRIlwHNBwC6A/mCqy/98dPKNL1hyKoS?=
 =?us-ascii?Q?XZ1nA+Hvg2EefW4J5w/CxWOwqSQEdhpxQYuf/LJxVCVs7jeTCcZUzvoY5brY?=
 =?us-ascii?Q?XEK/UJwtVbvaG6JPflLyMElfAzD6WrNboypo/9IbbeHH2lZsliB+ODQy5Gry?=
 =?us-ascii?Q?cQiBvdEgUoQjHghq1A3fRhQyNV0kVJIXYFyYrMkUejNpQczfu8KafMYUR+cr?=
 =?us-ascii?Q?vebq6YzxQ6B3p+BC05g+9tcaVp0VAVAWaKafJMl8Q/NSPm7ScYvAnJHG/F/2?=
 =?us-ascii?Q?BcZacZMZGJZjlxiHVDRENkcnOAGlmJR76OBzqcqERq1XbrVcldLpsNr48vrj?=
 =?us-ascii?Q?fRZuyJwsoG3T9DxhKsjF7lEdOnHa1hKc8INuWdDk1/eQk76YL3F9R8OCynLE?=
 =?us-ascii?Q?bV/BGMoB/CNDSWCwSQkRRtQW/J5BXvJfbtt3PbvHgycThRWBP/iKxcseRReA?=
 =?us-ascii?Q?zXX+KRhsc+gaeV60ba/M+SlWR64qs1/Qs5FN2xj7u82ZpM71Z/Bq7c4XyJCY?=
 =?us-ascii?Q?Xs4QvxKFoyBUkFrnmrEb+v54naQfZnP5YfIr6fy7h2DbscLt/2OAef9d/x6a?=
 =?us-ascii?Q?j1p6KSFaYHxeY9wZUVD3/+a0DLXEdhZvEoTDz2cozcBucnG8DojCwHAebwCH?=
 =?us-ascii?Q?PxacrauTY+mzWAc6JY2a/PbW3bO6zU1BIERJVuSQt+iDLnWuQRnfkFK9SWEx?=
 =?us-ascii?Q?nfEGqG4cb8A7a+dvAcFmE0MI2dOOx/GtP4zvTqEOI9WUe027bM4T+lFOJAQ2?=
 =?us-ascii?Q?BkE4L+J4h5PY5TI3JJHJpbowr1NPqqylA0Ucw/Y4nGA0Ovp/e7J3ZYFJLNli?=
 =?us-ascii?Q?Zn1ja09Scby4dF5aYmkZoRSt/f0NxdNK9seX+mP24b8AtjiL2uQQpcxSMy/1?=
 =?us-ascii?Q?WNGZjHriG84Rqy6whn/8oj5qOUXIAoSw6lOt17bOI6qtzQIVxLPGJyB/GXSa?=
 =?us-ascii?Q?+V8GONvzgKlnN5szY+8VFG7bvXMM9y7GpTopmzNcnl0tZHWmiXs0kZv98khn?=
 =?us-ascii?Q?RT+E92snM2mPyUPtFu+u0sBXRdvs/1pKuV3O9Ghlq7n1KooFwinEG1eWBzY3?=
 =?us-ascii?Q?Vw3NbSm5NEy6nT1KEWBozKPWhgYcMYFLvqKOAlbOgEshoeV8dgDAvbCdvQK5?=
 =?us-ascii?Q?+QzdD3IOH3Ug85RhBuA/QzsGTAPOj2Lu?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?KX8TRPd4fTk/W5KtK8HmoJ7yP8actmFGR0NhsLS5N3mdUUwDen2JkQRoR9jv?=
 =?us-ascii?Q?nIXw2uJCFaCNusgucS52WlzdfGfRU1AqjrdUmGG0uvsg4GZLniRTTduFTxKN?=
 =?us-ascii?Q?tIjg9cBjhAMYe1KLaa/e+QV/mlL6BNmhAlznQ2ZGYc+u2CCNYZMQGu9DKJVM?=
 =?us-ascii?Q?HBChPxqW2j6QvDsIhVj4rUTcJd4AR8vVbWMsGhONlIGUV/d9oWaVLckWsoFm?=
 =?us-ascii?Q?b1px4fhnqr5OycYSg/qV98umQ+PZydM5HYCTbGMorvD8q/ESV1ntG/VaSO1u?=
 =?us-ascii?Q?dzabZx6cn+Ds7d1pIBAYfQulvbY+5bg+57ToBn01E/RaCivxixJWv93WFOt7?=
 =?us-ascii?Q?s9uvGBfF+F2mJZhHe6O3RQ5BHTEbiC6rtGVsfzA97wLRbjyt1zPqkbhVP1Kn?=
 =?us-ascii?Q?dp0M9KY6Q0iohiJFidmu+mBIpqbNUTihM/LXBHpccWZLTF2Zomk1x3+JHsoA?=
 =?us-ascii?Q?SitjKpvM4UWZM1gcji3w6OB4K0IQjtx4fn94z03fK6MEyWJAAy/4IzxKJUNZ?=
 =?us-ascii?Q?v1m1E6825dLrX7fsKwKkERJioelM2gDHR/2Y28zRmVAWhmcMvfQePog54Hxw?=
 =?us-ascii?Q?/erKiWgdVR4sipe3Xh62D5bpjszB4BfVEW9/vSEO68e7fsalhuKdd86zVYPY?=
 =?us-ascii?Q?BnNSvxToSQnWdafQhxOkbAKHVJmpLEED77aZzHTz8n5WjtX+d23wTFyaktTu?=
 =?us-ascii?Q?gVYAu7nmLkd9and7+RaCFPkXijR8xA6F27vmR/Mhu9sVGIUfr3//L5KeHqB8?=
 =?us-ascii?Q?ATgH3isXcPg+uqZPwWBrDMXLYgGZRRqdU8inw2quLTr1jz54Pd2YZJoNgKAF?=
 =?us-ascii?Q?BuCsu7TrGY6VaBIRVTjtzE/z7SkY7qtKRIK8viVVUNwodx4P/cObjf1lvRMR?=
 =?us-ascii?Q?ISAM+hxmCCX6mryLMvHPfHAmlNRCrmXQrCMSxA8zwC/zOuU86OYvi7E3MavC?=
 =?us-ascii?Q?6oahHlDeiCU+pbCLjqw1MxeoSAQFLDlJpiRSlT6U82UEA7MlLl3GyQyBB7Fi?=
 =?us-ascii?Q?XittVtHf4Q40So2xkRxPmBDZC3FIl4Qz8l6qTvIChJT3jcx1DXHFYd5F9SI6?=
 =?us-ascii?Q?VIhaPGPOKZ4TaKnQ3r4hVWJcgnvJpCOrnqaZGcxakTV2V9Hmd3T91UWjT3hn?=
 =?us-ascii?Q?n5koy5mz8BwmezwaDxlnYMx3HaUf3DgHUvW93YyF3o755WnO5FfZdg0ASuyb?=
 =?us-ascii?Q?mmWYBql2HLi+j3pJ2AAjnq/9ZzhHg7P20HDYJ7LJAK0InycaV/vmOJEeMpnJ?=
 =?us-ascii?Q?TAPe2UqDZTc9/cqJebe4FzwbczGFmdlmm8lpymgLQDpmHwxw4weIm9a/uhPv?=
 =?us-ascii?Q?hHfkfYBeziChdfUgH1m8Q6GeHSsxmEt+1E/oRicz2N8wHIpaijOoW1KvTG7a?=
 =?us-ascii?Q?/A31RV/ULWMUK5t8X4vpk9ldXk5tdvilQ/zuYt3QIIACRGOcrE6OTBulmI7d?=
 =?us-ascii?Q?gWAOOs/Ow+zHs5fyls8GtaWAVyLmopJPvwY5pdDSFycvlR+gXw0PVpbbLUho?=
 =?us-ascii?Q?4gZjhXdtaPP91iM5OnXvLHsTM9loBTOnyKMq5RQtLGIlpAS2pRhWZoGGHo1g?=
 =?us-ascii?Q?qYxSAvrofXMxesQXP6y3K6JWFLOCXhchyPtscwGOwS166n9KuQMJbspEh0cp?=
 =?us-ascii?Q?DvOUa4bK07LrKaeYYfc0Mes=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2DFB484E02A8984BB1E0C8BC60CBE096@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cOuLIwgoHSYFBGc7OglDhMZ/d5H9d1oki/ORckiErNb2RlGx4i/hvaEVGBDidXv1ePHvbzyBmOTNcwhmyOLuGiBgrFRNfSDzkJSjWCWEMfWGOSsvxRd5bzjv48zYJw8Ji8+0LyLGCZu13qnwCoyLGuZS0Tho3ETsKa17wa+J4IMXTlkni6bbbkXHe3YzFoCAMo9ydQyUudNHdTR/zRKKTbA36WQyM0C8ToMJqr8Qn+w9/2+JhHvYl8qodPHQEboQJXVbZWFRGIxBVxwX+gRsQ04+HZL3+UGYi0iT4xE3BzduEa57q/T9ta7F0HTNNco8kltyJj/lEJk3cYSDZw6TCg10VkOBoMEvRqmmZToLK+Fg/edGLmO86uVGRB/8BCdZTY5Btr+Hil4iZOTq/mf4cEj8XaknIfBpXdokWGQPS+fqQOQl9Ajt35yjHRwg20IdjjO2EAY3u+oaJvwfyQHlkiqkZSTWpNjAIR6UpqJjoKnXNE9SSwZz96p7G4PvF4Xwm+NdSDfKbGqbo51FmekFgm8QzrMv9INNDI7Y4L0A/wtSwzUj/doMSmZIAtXNufSGIG6T1BweuTjCzL3+8mnFPQEzDddjTDwMsEKXEBmNNVp0m4cRHHIt6kyy2piv3aYT
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cffb5d9-125f-445b-2b74-08dd4ce79e84
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2025 11:06:23.6538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F97KHt1lCNTJZtDSzTvbxb2qeDLkf4D6RP8f2Q3fYE/hm+BY9VAWgTZcyihYmG2U1A1MoIEZrTaLr70IA9LLQW7UTsA9siNHLl2ieBqThKg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6745

On Feb 12, 2025 / 12:54, Luis Chamberlain wrote:
> If block/032 fails at mkfs we want to know why, so propagate
> error messages. While at it, enhance the test to also propagate
> the error return from mount and remove the odd sleep for a udevadm
> settle as that's the only thing I can think of we need to wait for
> here.
>=20
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  tests/block/032 | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/tests/block/032 b/tests/block/032
> index 8975879660d7..fc6d1a51dcad 100755
> --- a/tests/block/032
> +++ b/tests/block/032
> @@ -25,10 +25,10 @@ test() {
>  	fi
> =20
>  	mkdir -p "${TMPDIR}/mnt"
> -	_xfs_mkfs_and_mount "/dev/${SCSI_DEBUG_DEVICES[0]}" "${TMPDIR}/mnt" > /=
dev/null 2>&1
> +	_xfs_mkfs_and_mount "/dev/${SCSI_DEBUG_DEVICES[0]}" "${TMPDIR}/mnt" >> =
$FULL || return $?

The $FULL needs double quotations to avoid a shellcheck warning. That chang=
e was
in the 6th patch, but let's fix it here.

When _xfs_mkfs_and_mount() fails, I think it is the better to call
_exit_scsi_debug() before returning from test(). It will clean up the scsi_=
debug
device, then will reduce the impact on following test cases.

>  	echo 1 > "/sys/block/${SCSI_DEBUG_DEVICES[0]}/device/delete"
> -	sleep 2
> -	umount "${TMPDIR}/mnt"
> +	udevadm settle
> +	umount "${TMPDIR}/mnt" || return $?
> =20
>  	_exit_scsi_debug
> =20
> --=20
> 2.45.2
> =
