Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11022136.outbound.protection.outlook.com [40.93.195.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B3019EEA1
	for <patches@lists.linux.dev>; Thu, 21 Nov 2024 16:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.136
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732208249; cv=fail; b=JiNqr2awKWKu1TzDahfgBjU32VWIKzG8RgH9KlW+ddpfPeVpMIPT+bc2ZzEkOFvbGd25JvzxnCpYD0C20DK7qVvWgz1htc4uxJrR+93tWteSRNm2iBdNN4TelFOqlwRNOXJJEmqq6ELjOAfcG0CSXD8Qr+7PpwwDKvr0vTws0ts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732208249; c=relaxed/simple;
	bh=2QeEMRi3XrKsR609ajjqVUSlImcIw5XgDR81ivfgbsA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ScfLdtIFilq/anycMfSuq/e+xW0R5TOWeLRCI9tDoBUGFV2m2CA1/ePBVhOwgc4T8Nbr6w6By1z9K52BuH7VNYNjlCkFgqHvjhOWFA1K6DYRyixX71nU3ekrXDwxmkEhftDGb3AJD3UXZaURq/DaNEDf9T4sI+mV8O5dt2L1ycU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=au0hzHBv; arc=fail smtp.client-ip=40.93.195.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="au0hzHBv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GLcI3cGLq7/N3/dyHJ/2lxsUDncInD4rs1oF/A5XGzc7OPtmxHBRACGkGRTpigKpie+CvGoxEYslGbpYqfZLfkH5AOfoscIa+ky1JnepRZXISmpGj5QYOWF5Bwibh+89qW6QVnVj5fZuvYT8hm0W3f4wLqz46Zn559rTa6hayjHk8uebZ0+8o76hxtmum784hrPcJbKM2IrnzEi60AlSuxrBQWhWmIS7I3siw2yVJkP52X8oyyqD90QU4U78zd+7E6l+mQANB0YxbsmTKjSYsoA3xZ9Ll0/HgTb1GCtZfyv68lP48s/UbOXTj3AFXBKvmGOyRAbXQt43cg34Wru8UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2QeEMRi3XrKsR609ajjqVUSlImcIw5XgDR81ivfgbsA=;
 b=NVrqzRy7SLx5aUIrvZCjMKlMolokafMXU9KgeyELWKrYXFz5ZhM8JzQJUmMSEV6llomlNthDg8mSPmOLhR+/2T4rlNP/j5TUegDZ5U4eYNh0fw9wqJyj6L6GjOqj/Sz9kwdqzcOGwym9uj798IwMai1YS/2YGrxuEpG9M0G32Ulhn2KjKZpzSunUPOr8mhsSth04KQpirbOXX2EG9Zl0zasO3YIdT8bCasIUxO8rfSx2YhbClYplEoRwK+d26B/K2kQxYiHabapRcgJZe0pZUu0VksFQGcUlGf9gSi24v6wERK1jrPkKYhzrA7X68+6O8LuMrACmuRyU8a47FeXtzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2QeEMRi3XrKsR609ajjqVUSlImcIw5XgDR81ivfgbsA=;
 b=au0hzHBv9LvWQkIm7RFMWBFRMC1qFR60jZrDew48U1jSij7i7jh3sCNt+40zPAHk75soQhvOsTzMpw4x+zd6ALDSoqVAwECtQIihrnT+lXxMuM9YmE8up+YuONrgS4bp+/2nrviVf2rcJlizQOK9ODGw3wWIaS4J1rE373fTx1s=
Received: from IA3PR21MB4269.namprd21.prod.outlook.com (2603:10b6:208:51f::13)
 by MN0PR21MB3145.namprd21.prod.outlook.com (2603:10b6:208:379::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.17; Thu, 21 Nov
 2024 16:57:24 +0000
Received: from IA3PR21MB4269.namprd21.prod.outlook.com
 ([fe80::2ad3:451a:7a41:c069]) by IA3PR21MB4269.namprd21.prod.outlook.com
 ([fe80::2ad3:451a:7a41:c069%5]) with mapi id 15.20.8182.014; Thu, 21 Nov 2024
 16:57:24 +0000
From: Hardik Garg <Hardik.Garg@microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux@roeck-us.net"
	<linux@roeck-us.net>, "shuah@kernel.org" <shuah@kernel.org>,
	"patches@kernelci.org" <patches@kernelci.org>, "lkft-triage@lists.linaro.org"
	<lkft-triage@lists.linaro.org>, "pavel@denx.de" <pavel@denx.de>,
	"jonathanh@nvidia.com" <jonathanh@nvidia.com>, "f.fainelli@gmail.com"
	<f.fainelli@gmail.com>, "sudipm.mukherjee@gmail.com"
	<sudipm.mukherjee@gmail.com>, "srw@sladewatkins.net" <srw@sladewatkins.net>,
	"rwarsow@gmx.de" <rwarsow@gmx.de>, "conor@kernel.org" <conor@kernel.org>,
	"broonie@kernel.org" <broonie@kernel.org>
Subject: Re: [PATCH 6.6 00/82] 6.6.63-rc1 review
Thread-Topic: [PATCH 6.6 00/82] 6.6.63-rc1 review
Thread-Index: AQHbPDZw/ocSU6EQo0GmPZVTicOUng==
Date: Thu, 21 Nov 2024 16:57:24 +0000
Message-ID:
 <IA3PR21MB4269055CB087A46C7AB887CFE1222@IA3PR21MB4269.namprd21.prod.outlook.com>
References: <20241120125629.623666563@linuxfoundation.org>
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2024-11-21T16:57:23.733Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR21MB4269:EE_|MN0PR21MB3145:EE_
x-ms-office365-filtering-correlation-id: 50472667-8430-4f6e-1c4c-08dd0a4d92b9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?WvX/Cudw/p7DjpHj13Mlo5hkl5HVDltffhQBaYTwC9qDXgBqBdC5mASqQ1?=
 =?iso-8859-1?Q?erzRfAfDLXsAlNrMDOpmWyT/BUlG6PNe2nni1gl5sp+UwpalFPXSmVnTEK?=
 =?iso-8859-1?Q?wcX15WB7QMMxAaScHtZeAyyv7oy/h1wy8K8kxLYNEei8Uudo9HPX3c4DrK?=
 =?iso-8859-1?Q?+z94MKSw6tQbWNGKOn95Ltr4xvNyXu9GEOejm9/Q9HaSXPXBFb0rMGwAJn?=
 =?iso-8859-1?Q?0LgbfuJaI0VPxlySkJaD8CcI5/glCBk+jGxVbgFAKvxLwYOmqYuP/CDnrm?=
 =?iso-8859-1?Q?jIZkxy2kLZvZL00W+zSW4C3GeMuB80JfslbYgwnp6zNVmJt+f2lP3BGfmh?=
 =?iso-8859-1?Q?61P8iInTRoTklqTUEZ5Y8ZU6y5IVwKoAN8Z2yvrbUEoLnlZ7huqAFNwBf4?=
 =?iso-8859-1?Q?RN12bQG5XABM/nnh8wJHEKecg51fOl8kHqVHF8pO2N73eIsrXXC8ji4iWh?=
 =?iso-8859-1?Q?lG+HPsStjOWW1LXUrWBf3a3McmnnuT+kwmXF9obqbglSbmT3jUhh0HHa2m?=
 =?iso-8859-1?Q?ZVLbGIZ+qYA/BNMxn+13kcnP5Dk6yan1r1OXyk1KvIijTKJDtlbBANE3jI?=
 =?iso-8859-1?Q?vc2Koey+iuO7ykHIP0sMlp6qmUwQJ+aClHTVuf0Q+Y17ottxmbHL7pjzYG?=
 =?iso-8859-1?Q?D/oRk+8DYXwEFZfpLacQ9cVI9ftD6vG51tRvayR1RDprjJXosYlDDMQABi?=
 =?iso-8859-1?Q?1trd4eHlmESnTJdckChlzfCOsYs2Lsyz22Mh1fx0nmhMPMm4fpowZJMePX?=
 =?iso-8859-1?Q?t6HEzLSK6UZJpsYD0taHxF8KiIexZwOBzeMObkNMfkObcGUfE2qo830v0+?=
 =?iso-8859-1?Q?Q3pR5mWtOU1ouFO9/n9+m2A1EXkFfj2HNHQwmffCpU8Jc6k1dnyUde9u1u?=
 =?iso-8859-1?Q?b0QWz2vgnAlsnIkKHAupfHsfIgLNm2+9qokWErNnIwXe7YZS/713HMaxc+?=
 =?iso-8859-1?Q?o7o0ndQ+t6v5+vb7x+UG0513F9JxocDH0L3LKVx9fERpHZvUzscTAx7hkL?=
 =?iso-8859-1?Q?rRc3TjL1z7mUSp7GGSx8V0FWmAwCjY8fx1Pc/LbY7Wy71qiiVq3qCZCCJX?=
 =?iso-8859-1?Q?Zwo7JRO6Wqd/3nTp66LpNnctrFZSzkkCX6jUalrv6rW0PzTY5dqYwwKDrE?=
 =?iso-8859-1?Q?fOveBWqqoHzRyFEanFnwolhg+JM0lkcywFMyvAhg15zlIyxzmh7A/qcrRP?=
 =?iso-8859-1?Q?HZQzui5oXyuDYaYO7EcvQ1sObUh3gRhm19+HVH2No6aQfh9WDY2Hy0ziT5?=
 =?iso-8859-1?Q?WGrow7SXXvQMFXuYA4RrqqE2U8QbahUX+4cUewHeV3hK6z91pCfi87ehUB?=
 =?iso-8859-1?Q?wMbtr5P5BWKLX9oVjksxoRTjEWhTHjsIR7/hIOJQntBtSvxuv+Qzgfu0aB?=
 =?iso-8859-1?Q?AOwzEz9B7R7Z43Z3wS4JA48VE6hOUZlKoj4slWDCkiK1j7ILJrOpM=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR21MB4269.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(10070799003)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?CEO11xOkfKjdakyWlRv0XqKkaLLk2Ucgs6bK+7RwcW9pb6tc38W/aJICAf?=
 =?iso-8859-1?Q?zctRCToa7BW7e9nXCgT76QOe7H7f605dDZIG5i9q5h+ctlurl+9D7Yk60U?=
 =?iso-8859-1?Q?i4sWREHMwL65+xge72tIkitlzVIXBqERQCjA/CCb8979cPk+zeJDQvH2zZ?=
 =?iso-8859-1?Q?NkxIpkgyrAHJKvcdZfxCb1xIgionjR/0KAsJE9scfnFnaUldmqUOLUhitg?=
 =?iso-8859-1?Q?H/3FZsUZ7sLYhw6wNVewqZu1/p1XcZFccv29ufaGFvJHlGp6UPMUsReOuv?=
 =?iso-8859-1?Q?2nlCjIm6W+kUe4CTq10ppuCJXT0MD0v88Ays8mU6iKe2IhZDy5STF3SUy8?=
 =?iso-8859-1?Q?qjrCZA4FKaUYIOm76uZi6C55xjLWcdWtu9gKjz5ZpPbxCzNhQKGYnrib29?=
 =?iso-8859-1?Q?N5HYMRFbQQs4EMmcFIa8gzsAWLduzBq1dlRYfJkxcJp60/ZT+QOv3iniox?=
 =?iso-8859-1?Q?HLwI+bvEjsIZRYzGs8EUbSuA83wlbBjuVn2rCeG65xI8AMTyZZHtMZkN90?=
 =?iso-8859-1?Q?hXKvoh6oi/U06VMGWO0uhgYJAAXF8PVOtZjrqJOhKaKSWLtx3QZo/WV+q4?=
 =?iso-8859-1?Q?r7gcZQMSRM/7ojPJwy7sls3eXdzE4tcvCG6q+ReWfIwfWDDk6eD/N50/NC?=
 =?iso-8859-1?Q?vc1PYcWqydBaXXQiT0WnhAAgXXHRK38VEhHAHmxGco/aTJkIYET6yJYzp4?=
 =?iso-8859-1?Q?qSniN1eSi87fk4PqIL7SY3KXow7IV74jvJmtGfyvUd9TICmArbGnMBMFol?=
 =?iso-8859-1?Q?yH+jWxgJFP/0YU56d7c5x22XKTKo8MC6S3euaLoxYwYyGr22L11hFDt6Iv?=
 =?iso-8859-1?Q?hOIDJ3q8xfSMaM4oxN1NLVoBk9bZfkTXE9T3U+Vgp2rh2naCBtEYcC/cQD?=
 =?iso-8859-1?Q?5o77wA2JpaknY/L0jd9pRcsuoe926eBRK7eiVRebXX/F5Tq5NA6z0OhnIw?=
 =?iso-8859-1?Q?9NhJXhlGUZ7Fa+PtzILpMcJtux2zuP6WfmL8VzOVfbjkFx07IkMm7LOS4T?=
 =?iso-8859-1?Q?rgoTmrfOi3OWBkb6BsGD3hLEe9TF3qXbpMoJOQeHS51ZE57ZAii83G9xZH?=
 =?iso-8859-1?Q?OGaFjVj1mwuSv73MsEuOdPz2HJw36nHjZ7RLalFqi7MBaNKlnxSdJKR/EY?=
 =?iso-8859-1?Q?610v1sC5h+tlBr7nINNA6iQziIYFjsUOXf+h71oiEZNJNFm+fxOOR4z8wQ?=
 =?iso-8859-1?Q?9/rPMbdrdYPVqjfChuiIKMD39f3y/XD9Jp4A3HU33hnebfsFv//xrWCeYE?=
 =?iso-8859-1?Q?wIfHPhOg96wEDPyde/ceKeakgVc6wwv9Zu79w4bJgnwi17C3OQTtyi91Dt?=
 =?iso-8859-1?Q?qKoc9jj4lG2f2yuuUKtCbmt4Mvf0WtGcxC8aubIou6BR6VVEe6VI2e646y?=
 =?iso-8859-1?Q?IW1ShOyKwNu6Y2NbZNvUlX5bSL4M9Hgkgs+M+DKrDe+vDeNwUtApp5624J?=
 =?iso-8859-1?Q?EDn9aF7lX2w8lwzYY7ENmMxSPlMhuC5xqiiOMCzIlskM429gXKvVOWSTxG?=
 =?iso-8859-1?Q?PhMVANFMFhf6ujoCRzdKQkAK6d4DR9y2Mgq81Dwy7lBIQjA/9kOAh60rUf?=
 =?iso-8859-1?Q?EhqNLd/vZDuUEzg2bwV6sKa5z91W0VMGADseVr+2HfhOU/C7XZIR0xwAIN?=
 =?iso-8859-1?Q?wF7n7/e+axAX6gqfWv/jQnzjaA+GTL+Zoe?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR21MB4269.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50472667-8430-4f6e-1c4c-08dd0a4d92b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2024 16:57:24.6448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9gdeyaPCDALtzZowA/1BQpAQAXueB7twXmjPbkRhDwj6xKSkOdnPFn0ncFvd9cCnh9iDBIRCk1FaCvCS4NDKcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3145

The kernel, modules, BPF tool, and kselftest tool for 6.6.63-rc1 builds suc=
cessfully on both amd64 and arm64 Azure Linux VMs.=0A=
=0A=
Tested-by: Hardik Garg hargar@linux.microsoft.com=0A=
=0A=
=0A=
=0A=
Thanks,=0A=
Hardik=
