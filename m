Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C039625A632
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 11:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739530961; cv=fail; b=OyL3FqHUPihkR5aS+et+PuZ3R53xt2H19kKMUPbfJmoGbeY/FOzszIH1l5hR7x7dHPdQEDaCAnyr6G5ecNpGUAL6eorrlCK7pM1yl++y/SW+Bs15ArRWqfTsUgZOek6H9HG5DIOrnD8ACsmBUFpP2uGPFnEvqRvHdKSi99aQnVU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739530961; c=relaxed/simple;
	bh=ptoAXWyoad6nQnVmYhR29Snas3yKbTvWjTIILd5TMMc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Srx+XqMOO9pXQvepBJ61vw/l+OJ4b/yoxLPhX2WDjEMee/xF9PdOzkxzWVeyP4lFKxHGJJC8wXtNiJAUF3GDl72KJdMX4vntZqP6iPGidxC6T2vOZrMNRjGAOAL5BVOFNdiEQnJceNqlTQKvK4sR/EbcMWIAMAYd4MEYiFQ1/9o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=hkQntfws; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=vvT4xZBK; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hkQntfws";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="vvT4xZBK"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1739530959; x=1771066959;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ptoAXWyoad6nQnVmYhR29Snas3yKbTvWjTIILd5TMMc=;
  b=hkQntfwsZvnnoopPI9g8wINDvGI8IsMh/EL9t4eL2W5dgsmUoxUunXG7
   C1+wB0fA/o7a8UBNWfhZhv45sPpiYJLLaKGcphYWxYHDnNt0J5k5QtW0K
   BYeo0mX0KLMuq8xH8t6eACdzihe1SbIAAjVoYL8An6Tggj4wzTyPWwkNh
   4tJzf36a2Q/ydslFUdC61Gfy150nHiUPo+O2ogTO9Wv1DpkQY2kvYWrME
   GMe4ZXb+MHgLmhfAL7/kUsZtLDFBWLIufGFfegMNA8ShItVk+J7hyBEYi
   izILjF/hmYoG8tjssBVMPFvZFpXZamqBLbfOxCCPyeJbxbb2aH/AwkENh
   g==;
X-CSE-ConnectionGUID: DYDJ14FaQriVvkWVrFRm/g==
X-CSE-MsgGUID: p8Yx1OEvR+iTaqN6XiecUA==
X-IronPort-AV: E=Sophos;i="6.13,285,1732550400"; 
   d="scan'208";a="39100115"
Received: from mail-westcentralusazlp17011030.outbound.protection.outlook.com (HELO CY4PR02CU008.outbound.protection.outlook.com) ([40.93.6.30])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2025 19:02:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zbc4Ta8GS7EWSsLan64V0LDce2C2I2ACiUa2OXkuv0A439hwkChMYwNvFw0NAZyjAE8Ic9iPx/PBMy2mZJCBuhvIKxXSf5PHnJ4jj3FZLftXIVQMuobLifcPnl+V6IAF1wtdJlRWa8ziN0+nz4bRE6GpfvXrUaphPK9diyfltG6wW+8TT24MbNFF3vKccy3Q5Vhib+nI21ha+jjc9WIGrsV5vpapi43oS5BP4xgTQ3k2hbDkpnrL5oJ7LoLl2e2xt8BypVozrxkCs9PBSnUuenCkZXmJIHmYDRS3/tftAO/tvWlkVh0VT/O0CdqXat2KkSeVUYo2Z2G7JuK4PZeVGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eNr8+BdrQqjk/NrZQ1sf993GMHlsGNvrJJ89Utb/ufs=;
 b=j0xmBi+IOtZTFTfwKlW83IP57Fif9dtXOumE8BOM0wEY9ttZmmeg18sMVtcOYZlRSR9XgDA7fIjCTv3OvUz3HhXEuSHBoIP9BanP0P7OuZ7SiyWkFAptAz5Ypc4JMp0Imv8LsAw2kmmuKXftxn3huqXDDfWdvPyNwymWW5MdLcszo8MyhRX4p5h69EgS30S23ZIqE1rAJnCIvdlxm3EMY/SFfi7gi+MI3ph+w7G5GjBU59xNPGh2THART0QPyqozY+B+eiGTUpjaatW2yxc18HXwc7FfKROyD6Wu5FLc7zU2NFrjvCv7BuUzeQ1dXL2iyvEIlQrOjLAtU+el/uXkpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eNr8+BdrQqjk/NrZQ1sf993GMHlsGNvrJJ89Utb/ufs=;
 b=vvT4xZBKsbE9BPvLEb8oOcp9qnJYDbPc3NhRgiiMpuhvKrrLiw26GXfxYyXWO2+pwsOiOra+gLsSyi23b7rJ670ZdcCKT+1SA6pBbn7tii+H3n6Ykdp6E+hO8e+4hwY19JFoI9NNLzsIJWa9JLfcA14kchAF9T98SPpEkF8a3C4=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 CO6PR04MB7811.namprd04.prod.outlook.com (2603:10b6:5:35e::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.13; Fri, 14 Feb 2025 11:02:30 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%7]) with mapi id 15.20.8445.016; Fri, 14 Feb 2025
 11:02:30 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Luis Chamberlain <mcgrof@kernel.org>
CC: Bart Van Assche <bvanassche@acm.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "hare@suse.de" <hare@suse.de>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "gost.dev@samsung.com"
	<gost.dev@samsung.com>
Subject: Re: [PATCH blktests v3 1/6] common/xfs: ignore first umount error on
 _xfs_mkfs_and_mount()
Thread-Topic: [PATCH blktests v3 1/6] common/xfs: ignore first umount error on
 _xfs_mkfs_and_mount()
Thread-Index: AQHbfZBhEdB9Vd0020eINTRCUTbnJrNEJqMAgAACdICAAnunAA==
Date: Fri, 14 Feb 2025 11:02:30 +0000
Message-ID: <74uvwvxalcaijkkcunwpw3cusvgmxen77x3x2moq7gkerwayci@b4sfnfe2gffd>
References: <20250212205448.2107005-1-mcgrof@kernel.org>
 <20250212205448.2107005-2-mcgrof@kernel.org>
 <2e6ea8bc-6e9a-4434-8ffb-ec16ead86df4@acm.org>
 <Z60Ni_d7nv9wHVXl@bombadil.infradead.org>
In-Reply-To: <Z60Ni_d7nv9wHVXl@bombadil.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|CO6PR04MB7811:EE_
x-ms-office365-filtering-correlation-id: 1a8d551b-1afb-4d0f-1f4c-08dd4ce7134d
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?cgOJxe/Zwn4THAhIUPUHfsaY9nB8IExo54uwr8/UvyFhBjNPOfwGbFIYVYFe?=
 =?us-ascii?Q?8gdShIzswzMf71uYUpwq9EJkLhg7QVODZCEjrny2/+A4v6+vOT1RwSfLxRQ9?=
 =?us-ascii?Q?6EcQqqVdR2p+iHJiBQcSW9Nkc4LaSp/qBmlg61n63FeDkGOKmY63s/hvJt8n?=
 =?us-ascii?Q?Nul9Lc+iRSNFaMYZx7FOCqaPdnlFuERPXc/Ya7msnUDeP3v8aH4M5+DPCmLl?=
 =?us-ascii?Q?UyVELqwWFRWX9IuKzpdJhNx1Lwc3vCBomdoA99U1MRSVvrQFZx1gUgJPl/h7?=
 =?us-ascii?Q?rEE+y2w0m4LsxS/arxpOf92J3HEt8JosCTOGs6DaXyCbghO9lox5e+iXsHez?=
 =?us-ascii?Q?k0gO0TSj4rivjbnt7fJlNOmK8zwEl7tTZpO07I5SXu2e9IoT65DPvlb6GDqF?=
 =?us-ascii?Q?jjlFFNT/1Qcc6buYqRmfaKdOyM8TtgF1RU7dBE8NGDu0rZsKgm1VlynYECMS?=
 =?us-ascii?Q?nlyf71i9qGGgqOav8ufiVWJQhB2v28T3WsL1Kz1B8+o0gTL4s0DNJE/TxKmt?=
 =?us-ascii?Q?fOb1KjFclQ5gGyeG+A/k3p9acX2umkhzVKpnt1hcumyDJN9VH2bzvc7WXTJh?=
 =?us-ascii?Q?MqB4R1I3oYbLh3qT2GJuoPcD8kkxeeQ9MetKnw8oWj3CMW2BiG9cJ5ZQydxW?=
 =?us-ascii?Q?rGG+wlfg603ks7+4sVtFDaeiaKGrY+iLeUxa8EGcGUe1AiINyS1ClhbKxOmB?=
 =?us-ascii?Q?glHS9L2/K0CKzTOha0zCwe0EenpMDE+OUxy1XqTKYqq9sdpGupV7jT18WmQ3?=
 =?us-ascii?Q?usQxcMH5OjJ5gULWzCGg3vjgjdwBbnUSkhm1LVa+Ggy04DxNztLXt2G5b8/0?=
 =?us-ascii?Q?Ib24VFPTC0skldK6fRFKzof2ewssZ/syK98Av/NjWggeTl7lGE2KEU/5/MUF?=
 =?us-ascii?Q?+HmuJMmxFTjGhc6uUZl9fkCUAAZNaD9G3IUF5FjLppzWZSa3+pZ/Lp9bhKHN?=
 =?us-ascii?Q?NQnOLhzCCR/7060L8rBgvHQnXBJvGYE656JOJkPx9aupffg5z0CmR9eZEDY/?=
 =?us-ascii?Q?LiRFkkpt2PeGzLutQgmDL0nUAiYDRHDSUJsFRCAVpFbCI29GHMfL1j7diyMh?=
 =?us-ascii?Q?VgKlckOM1OKN0njYqoHvuHC81kLn1ThxRARe1a+AG+IcaHNJ8oDZZv4ZslTL?=
 =?us-ascii?Q?7y5cQGtSSEO+pfpfwsGYnqu3MTpTzSFU691Ghz3FGoUMrm0lbwqThslLUfk0?=
 =?us-ascii?Q?Uy3Xh+3CqRh0hyfF3U4Cdd/3oFaRcjj1XSII7n/p1FO97YHhvxLwQA9ps1It?=
 =?us-ascii?Q?lDObV7uLMjZSRMnR1RuQ5l4xczQom8F4aspvxjQWOpsNRa/vltoqsLiq9p8M?=
 =?us-ascii?Q?tsPD5JjETekXCeHLPlmP1AYnnu2OSkecVIL4isGhg9hHelg9t0AH7ylfE97a?=
 =?us-ascii?Q?UdHRVSXtqS8X2rgB85lz4plc2SYUKDE2RsT0HYwdawpdxJOTo5xIQRQ+ZzTB?=
 =?us-ascii?Q?5WeuFASfM3PWcMMDy5R145OdUtnx8LUm?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?IFf0Kh+uveEnqm+fFZTkxmNphxvTN3VAfLouFSWRrDto8HqiIS9wtX+wD+Bh?=
 =?us-ascii?Q?vCmtjVHYIeloeaFTW5McUhsCNb12sU5d9rjFOb4ygDZmwakaGq3wuVeNcwcg?=
 =?us-ascii?Q?YGUQynAFMKNN9VmfDZADp2zqfNQlPY6RUuqrERJnbIenqlmHrv1j3uFokhu0?=
 =?us-ascii?Q?tgeLj5dil0SosfhKqJdgLvceRP0vgrIhwQXAKuWCH2aEbroVSU/S74g25Vmv?=
 =?us-ascii?Q?s4Mfgk+yLs6PYRDYp0u6h7BIQBrxaYI6hijjOMn9xTfVJifLyp+U5H+ycIu0?=
 =?us-ascii?Q?TqEMg28R4QsQpPbEWwR8oMyzmxnoajWQImQgy3KWrwitQQRzRCOQ0mU5Odu9?=
 =?us-ascii?Q?EybLIGGgczJOU1y5iloWWAKqUq5PZfivz6LWkNv3Bu8z6MAJpdZRn4mE97yr?=
 =?us-ascii?Q?M03Rb6CVtUe5BRxDzPIw+sF68/YjxT6HMjAhwapCT0pMtDR/7QRkiSYbBMqY?=
 =?us-ascii?Q?AI3jXzOa97B/1YX16v0GidVagJiMWR5w9qEA6QET4sxCbAbikQEQdk2lAxZr?=
 =?us-ascii?Q?DBYBKXyBZElYpn/l9t2zC8EL4qpsL9xXUDHCxGJEQXtjD5Nqdm22so+Tq6sR?=
 =?us-ascii?Q?L/vsb79sDJxF2Fk2mUeaP/cmWDAhSHKB3x90myyAIRnTVGVIVk++JQQk185X?=
 =?us-ascii?Q?EgoGeDhjHJaY5JH4Ep+40IptMftZzFmtYNHZSKmjcHk3V3njtiuM7nS6jBg+?=
 =?us-ascii?Q?EkRT0SI46aYCs6wWUaVQj263Y6AZk8tPw86J8pZ/esHtILFv31ypaye00LGj?=
 =?us-ascii?Q?kZh+gQb6YOJlg28YwT7uKOXfwjxkJ1pqrfgEekAaM0J1VsAL+V8lS4EsnNFN?=
 =?us-ascii?Q?WO7JXjUPbXurNapLl8VtdODQCWNSuo/Fb482VX92ZPlqDTJ0DKW9ta/Oo/eT?=
 =?us-ascii?Q?ASwAJh5cQlM4Se2Z9oZrMVhqnk4pxfNBgKcGFdECS3ZwUTBLQkZQZpj3B48c?=
 =?us-ascii?Q?MTTI6jiejPgr08LCb1hQlE64OQwX7tgCye+GVzp+hHsORNLB1UQsFT2b9uL1?=
 =?us-ascii?Q?ZHszaio06Go0xP20M9MZgRtISz6NvXdNh10Z7qB8bYxczVqfX8IeDkg+Z33e?=
 =?us-ascii?Q?35zShQnSl/BrlRhMdiIwGw6zP/BpR1Jdq7XhrDWd33DDVyFNLhI1oaWJtNWE?=
 =?us-ascii?Q?iFT1uPL0BWhCvMfYX+07Z0a6J4Fs268vldFnSgPHnCLmwoPw+5ACk5AFGp+R?=
 =?us-ascii?Q?IRlTNfQ/syi4IbqbgIeIfYnoobkEZphth69wWWZPBt67siVYf4kOw9+Kl7DH?=
 =?us-ascii?Q?6Aq3Lz5n6X1iovS26VEg8l95kQdvnLlVfZmEUyn0Upi1NUmPH1dz5YGptPx+?=
 =?us-ascii?Q?vt+LlO3sWBzmgYCyPgyfieKQ7B/SszZw7E14sEAXQXEy7ORYiWo5BZE3gOME?=
 =?us-ascii?Q?Kuu50ji9nzYIRjYXmjLNbsQKLhAwHLVS9Wsk5RSqhAbb2jaDoCGo/mHnzLCT?=
 =?us-ascii?Q?upA2jtLMgUl1dn7ePAQv2J8RZbdwB1i+ybik3kqvmjuCy15D+FqWoXpGCd+k?=
 =?us-ascii?Q?AittnpANBWyeVslqYCCz99eMm/U1HodWw4ryG9tVbwfW7tROUsmjtv5yKvog?=
 =?us-ascii?Q?4LJwV52aOizR+ke18++/wrpn3TxoCmOOPr8myIEML/Y/MFVs9rd0t1EuO3A8?=
 =?us-ascii?Q?Ti/tSpUc7Z0x2SPsB202Dqw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D4D0848386185F42978E23F9D32C0629@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	X+iWFeR/WhE7XpmTMhBdRKpW+RoXSSaPed6N64EYhV3Kgu44LTfnZahbAtzWUgcm7W5iHkbDkJLbDnVr/QQIMLwQ7ur1kgmcphVtjGZDUIcIGlffvpcrEr8baonnH7td685bQuvqYPD1hDgx0DjPQlM5L+evmsW3O4e5Efa8fpBLObQkS0KC9erRR8Oo7Ob5miIdFJbg1ZY8Tsq14w8Xsj9kAH2aZHxzaXVgcm4aThmVqpvvYdZJ1u7wOCmgCU50ozhS7Aws85a8qL3/mUoCTZYtijKp4vusokfJfpmPWSNvGUWfFqqS76g8tJuU1fcYD0UHQoksz/K4CEZSM5BSDSsCOmwqlI/w9qwHkY85d+nrz2ZkEzcMLgmy8pVbrOMIehR2F4oPN9SMouiF1ygTD1R4YJ2ff1WXrXI+8u81eFniZhujIRw1AD0M3HZJJn6PpolTH5A3Rkw9NZE+ip0j9TOy/7YdxPMntkPcM2NWZEKTqnriRN0GwZsHggAIRxmb/EgPrRIa6cz7ThnIkffn+9p7zc5mWMsC49fmzrgN95qrQbZzbeWcDk0c2/bhhbut/ZJe7TfbnU9eK9kpneee43fQ0yHae33J0/9AvSXE6/jXe9Fg8+cNOq6Ayeq6u5Jn
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a8d551b-1afb-4d0f-1f4c-08dd4ce7134d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2025 11:02:30.1287
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y72ESPIu+BKbAqgZtromZwcDZxpr5EDdwko1wk9EiHLYqIMaieyVuD7/kUFDyoX46tGL2etrSr+8Z4/yacMEJ12CB+brZrK8wPZlYVTlzQY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7811

On Feb 12, 2025 / 13:07, Luis Chamberlain wrote:
> On Wed, Feb 12, 2025 at 12:58:36PM -0800, Bart Van Assche wrote:
> > On 2/12/25 12:54 PM, Luis Chamberlain wrote:
> > > We want to help capture error messages with _xfs_mkfs_and_mount() on
> > > $FULL, to do that we should avoid spamming error messages for things
> > > which we know are not fatal. Such is the case of when we try to
> > > mkfs a filesystem but before that try to umount the target path.
> > > The first umount is just for sanity, so ignore the error messages fro=
m
> > > it.
> > >=20
> > > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > > ---
> > >   common/xfs | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > >=20
> > > diff --git a/common/xfs b/common/xfs
> > > index 569770fecd53..67a3b8a97391 100644
> > > --- a/common/xfs
> > > +++ b/common/xfs
> > > @@ -15,7 +15,7 @@ _xfs_mkfs_and_mount() {
> > >   	local mount_dir=3D$2
> > >   	mkdir -p "${mount_dir}"
> > > -	umount "${mount_dir}"
> > > +	umount "${mount_dir}" >/dev/null 2>&1
> > >   	mkfs.xfs -l size=3D64m -f "${bdev}" || return $?
> > >   	mount "${bdev}" "${mount_dir}"
> > >   }
> >=20
> > Shouldn't ">/dev/null 2>&1" be added to the _xfs_mkfs_and_mount()
> > caller rather than inside the _xfs_mkfs_and_mount() implementation?
> > The above patch makes it impossible for any caller to capture the
> > stdout output of umount.
>=20
> That is the point. In this case the umount *can* fail, we do it for
> sanity purposes. We don't care if umount failed.
>=20
>   Luis

IMO, umount --quiet option will help instead of redirect to /dev/null.

In most cases, the umount command just ensures that nothing is mounted at
${mount_dir}, and prints the "not mounted" error message. The --quiet optio=
n
will suppress it, and I guess it will address the problem Luis faces. With
this, still we can keep other error messages printed when anything unexpect=
ed
happens.=
