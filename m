Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B233245021
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 11:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739532852; cv=fail; b=uVCaZgJBUCyzadWood1dpp9jKZYReD7jVeEsBPDUC4dBoesztzEuh7/3cTaYD+bPtU/WEIn4blA9PnUFkWekNrHu6UrkUyAMfRUxvKSaJx7aDKPICEqMg0OC0THDCluRinCZ+FC7QeuX6nCFYc6DqF3GZXMBm3mbcM0PtreCuCA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739532852; c=relaxed/simple;
	bh=+UDu/Lopz8GOZYdrlVVgKmOkPmAr4PcTwRa+/DNzUWU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qnG6BYqOBvCWD52bfi5LmDjy7ex8ilQs3vU8HBaIDqVrUcG8O/EeS+yNnF053+ksAvQ5dOZpS2TNvP3bxeNWJkpsvrRS1/K39SUxLjrAkyON8HKFiubCW9kZbPrO1sgsvhSjjr0J1wMtXJdUjVDQlHHoQD2QbGOY4MFSJ54Vsgs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=BtLgeIrC; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=O3w90a9H; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BtLgeIrC";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="O3w90a9H"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1739532850; x=1771068850;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+UDu/Lopz8GOZYdrlVVgKmOkPmAr4PcTwRa+/DNzUWU=;
  b=BtLgeIrCQI4E50ol3qjaaZbiQ5dWG4AHV5cNEBSdvyABjsHwW7X2Gsmf
   RBwJZk/VbWqsphxVfbZb1MBwwY7oaNzKXRsPWy8te1ilUIjl2k6DmZ2B8
   SQfUTUEDvn0b6HjoqPXSv0A+ujBtfKC//3gY17Vpixsjz9wwXuxYgNH/D
   Os0TNmVkSDm5kNyEddbXQq5VQsKGIMId4Kk6iHeW1X6OGmd6XUduczb7B
   Cm4p4Dd3jkJbZTP1Jm3V8DZlU5M1DA+ArDWbCguUob1QaNscaXYblRJ28
   mSiiDBeI2N53HHfHpXTnYaCXKvwMXczzn+l80BCdq870FZIa0BauK2GXA
   A==;
X-CSE-ConnectionGUID: hqBe3QQ+SPWsvbPU0LWJPw==
X-CSE-MsgGUID: s018D3sWSrmDigW/c+lNlw==
X-IronPort-AV: E=Sophos;i="6.13,285,1732550400"; 
   d="scan'208";a="39728884"
Received: from mail-bl0pr05cu006.outbound1701.protection.outlook.com (HELO BL0PR05CU006.outbound.protection.outlook.com) ([40.93.2.10])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2025 19:34:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hcl7fTZz0LN6+MVkl2aXOy7vzRtt/n25ymw80/rHNI7mlo2DHIvdXLMdbGp5YhX9Yki7Y8bmR9xNQWfNRIk88r6HZSkEc3nH7pJsqwlOhlVsxVPQEHJUaQTXnK6tU6yDBJ6N1wDQSWGysaRfHEkVGhTJPOrAtfXycDlBQxPN4Ws5Z1BdX5SfB2jol5s7q2XWVdQsh4lmDGs2vHsgIc0jaoEuud8blI2a4cS/HS2VRTfwquy2WQetHAK7dHQNs3xkxffiiC+KAUwzjLBc5Zd6XM+OSZ6lUBgnuJuCJxNtKVMffwBel+OWxNMHPVvSLaVAKik5P5rLwPzjE/6hh4X31Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mSaL79pud9iKktCAztXyP6VQ6PHNURYZ07uvtVc1Mqs=;
 b=CDMUDfUMRB8gCZip1F3qvhSqKafpM7zQiuIdSVnW56N7XFf2FlUDyACHXBMB0PmoOkGViduiXUM2Axf7sNc2dYr8RWBbeq48ayl6RruNWleb4dux1Ct8teSGmtgYNjKeGTUw8seGpCfSSfF17/lbzllbMeqtgB7l2//FjUIGsuFcOBeKKKwJj0PLnc08JnqRRLvRhrit6FrvGSSExI/ELAl5YVEmsnOWljUab/unViXX2ANywSN5Moe05JMEM1ZRnqafstFEly3iUEDewpbMilSxmQ+5D3HWechpyh6fhfX0Sf6xD+bH3jlr1LnwdVypqsN7HJQKCDqtmXNnX+fSVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mSaL79pud9iKktCAztXyP6VQ6PHNURYZ07uvtVc1Mqs=;
 b=O3w90a9HsbPsN1WpUFdzI9Ipkh29LpP29Oo8PPdtPm4pvN1T+KNHvDwmzgv9Pqa8Uzp+MEUqBZmRX1TaxDnlKywZBIAvkYZkdzt1MKzKsamcy3SrdcFub1UipTha2BBvQxrW0gK+WvEo1MYwX5GO3BbJMu6UbWoLmRR+wGJILQk=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BY5PR04MB6676.namprd04.prod.outlook.com (2603:10b6:a03:22d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.17; Fri, 14 Feb
 2025 11:34:07 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::b27f:cdfa:851:e89a%7]) with mapi id 15.20.8445.016; Fri, 14 Feb 2025
 11:34:07 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Luis Chamberlain <mcgrof@kernel.org>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"hare@suse.de" <hare@suse.de>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "gost.dev@samsung.com" <gost.dev@samsung.com>
Subject: Re: [PATCH blktests v3 0/6] enable bs > ps device testing
Thread-Topic: [PATCH blktests v3 0/6] enable bs > ps device testing
Thread-Index: AQHbfZBg9oNACjqY9keVnQxp0RlPu7NGrZQA
Date: Fri, 14 Feb 2025 11:34:07 +0000
Message-ID: <shkzvixvm26ojvvergul7orla45jsmgw5fcozm7en55sh7zen5@63udt7eqtvf5>
References: <20250212205448.2107005-1-mcgrof@kernel.org>
In-Reply-To: <20250212205448.2107005-1-mcgrof@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|BY5PR04MB6676:EE_
x-ms-office365-filtering-correlation-id: cdfe46ed-1469-4d2f-eb4d-08dd4ceb7e04
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|7053199007|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?ArHKFAVJRSH/aE/jFuXQy+/WomoNxWsHUzk1Eiu2hcirR/ybZQztqSwpyawp?=
 =?us-ascii?Q?RJz9uVwwPOayqnHHovSiV9Qdk2hR+d1IQ9tvvu58VTC9oHh9qfZHNt6yzNn4?=
 =?us-ascii?Q?QMCFaMg0x7c0FejDNwf6Vf+J6oKu+adFaBqzpmatLivFnBdNJvYpBH1Nnzjm?=
 =?us-ascii?Q?TAqG+NJPUkLnf+5S4lY2r95T5l3kjOZJxj05yxvWuLn6sNP/F82c8RqVgeqa?=
 =?us-ascii?Q?SYqjDuzfKgvdmzZ3UUPqlVmhUE5BpUkfM3c5CYYi43MVqD+wW+kzizXC9JZu?=
 =?us-ascii?Q?IHHLUoa+ZvdtizLX2276mzBSzBXnBAg1MvMSMal9kceplMWBoiKO1b60lgS6?=
 =?us-ascii?Q?HfLho5wDTltyqP+HWrRFqVHstjLLVu3pu4BqXaHdrkUXb/yMwVK6SBx/QWpb?=
 =?us-ascii?Q?9kpVd5goBMsKC7dAWki5Gq65VSLtKKb/kQy3ujn6ZZ8cU5Ps462oS4GM5Z0Q?=
 =?us-ascii?Q?aDbDMUBMkMzTVGA0to2PGO9lXwBCytlBLhvTjZdCgCwfXjF/SqdaEIBzkbLw?=
 =?us-ascii?Q?MJzP5hmj/TYRprDV0+pUhbjcmMLx+JcFFwdLP6cbGWXpBTgSPPtjCuRTKs4c?=
 =?us-ascii?Q?1FKI5TE1q4vZW2rmPlRhgyGpSPKxo62XC0AUaDzPiqM9y18+6KO8/M/YybaK?=
 =?us-ascii?Q?Uc0anBf8DPyAJkyXW3lHwrbNHZ7Yr0A9dsJqmLlfGsllpxT9bx5MRg8V9uv0?=
 =?us-ascii?Q?UA6PKgc8u/zRMqmpEynyY2HcWXFr1q8tNUn2J2t1hNZzmdKr/fptYRffAUvt?=
 =?us-ascii?Q?sOUhqHSGFlTtAzCxih1AfWTr1R7e2BtWUutu+fjZ3QM7QauVDtWjwBGQLr1m?=
 =?us-ascii?Q?YwcquYgtUfvZ/eUcPd559bzdL1kANxd/xIs3kJfkwEa88ENhZ3zcHWZlO0E4?=
 =?us-ascii?Q?mPUqQJLWdjCAjBiwemnh7vF5dWrU779hkNsiKbvtAX3tKeRgsdDouo0Xf1Ax?=
 =?us-ascii?Q?KVEfHUBKecMzCB8mFSFlsb587eBHoito9QT62ah7Igb9KIudxy6iglA0+HK1?=
 =?us-ascii?Q?rcv8nN88e2A2LHWU3qDL0ukxkcUZhvkxJvhNNFwHgt0bktIlfLl/KNCmzVlB?=
 =?us-ascii?Q?UwnEs/XEMQAEkYvi+bKkAj1tBpju3AkY5XYfxXTkiCySL8/KcTT4CCsWSbzZ?=
 =?us-ascii?Q?o8VQ5Zp29/b8rylxOMHRepOmyN2f74KkrUWF+ri2PMIJp6kkdplLTSGwJpq4?=
 =?us-ascii?Q?F0noy5WJH64dryfqY0vSwU08eOiIvnoR1wWGJJvdhmebuD8NVeDJB33Cbbvy?=
 =?us-ascii?Q?HYVi63j4ZcGhD691+krO0dAB6UUO4EWZYt+xV652CUNBx4amUkbKnPxeeLVk?=
 =?us-ascii?Q?TELgYkUziucbJpoGSJCJ0Kxeu8CAwQzI6zPwqotXHksaDtKR7ot278JAVSq1?=
 =?us-ascii?Q?t5c1b7k9Iyqwrr0HusDKKjP3eazZFMnemHAmeJFngxFnP/hTgk75WAh6S94Q?=
 =?us-ascii?Q?zfxW5vxY9ZDodT/J830kMM/AUIlbfc9NJtcHyMv+DCYQTQk7XhgSCQ=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?YgyeNytONpA+9Abd9LPdCmAaZaflNSmUxvQ1cr+rgx71f6k6iJkJ32+n4OOl?=
 =?us-ascii?Q?NVxbknkgxMmTSAQzM9qglsPg1Dzk6YsE1g1wexTzHGcl7iaD4+PrJ8sHe5Vz?=
 =?us-ascii?Q?GGOXKnb4XQcNhPP/ZSDzK7qSpTfnQvtovOuyQ0V+fV3irZ/TUqG3hlknBOz3?=
 =?us-ascii?Q?5wk1IJJbN/X3fK9UmAhpyGuYzrrEp6kBtf6BmpYJ895uUDGXToY3NK6gHVl7?=
 =?us-ascii?Q?NfBOY8LoierO2hfQVFYTbU5ca/cemKWKrriip4mPsvpmaz+o/hezqzCYzR/g?=
 =?us-ascii?Q?VQAhlmlg1vxjYlOqZ5pcUt5C4EKfDkTyLH9VJXBnnGOtcldwyYRIQNCzGN7V?=
 =?us-ascii?Q?x609rd2UsuJOUHn3J6GyUaZ89Y1sOYspol0uuJBv0apXoE89J4i+M5UyTDlO?=
 =?us-ascii?Q?PR68dK34kNQkVMszLOMIkfjIml9maTw9cR0zIAF8qyQgk2whjaKhpWNkEks8?=
 =?us-ascii?Q?enDKb5VIyxmPlutmouKqofVrLGzkRRC3arWPkot4rEyPiuwfX67QzcJ9CtFu?=
 =?us-ascii?Q?GgDJRJ5JRIc/Mlb/zFKTlZpyCgAKYwJv9KksmQt0nD2SBCt06ZNhx3H16Pmj?=
 =?us-ascii?Q?MnsUDFMWXX86mR1Xy42WEOpX8ksmdlHatAswjubuJ5PVpbH+CE5rn6ALzxn5?=
 =?us-ascii?Q?cHUBEmdwWo+Hkk8A+WVmgBQKRqjyXURqxoYWlc4oTBGAwIyjoafxLv4qg4nf?=
 =?us-ascii?Q?zj2uezBzQFcOyrMYr+kK51uWvRjaVkwKKNJ5P7DwzOwR8OvouZxizVMNj363?=
 =?us-ascii?Q?mI2mwbI4MW/AVfr0rZF0p9rqTqs52xmtOPQbW0YoLQGprAuIrHkQIvwjgcyw?=
 =?us-ascii?Q?6ps8fX0ShoRW/I7Q4q+7hIHuW8nz2MXxu+30TWcdQhqvtzE9wNQgFeTETz4K?=
 =?us-ascii?Q?czaOoThBCKQw1myk92VlqkpuC0k4+Ru9yuFrD6/kcTOxSFFssspWrisb2wES?=
 =?us-ascii?Q?Fm7MdkdwArEXcG61lFX8qVZg1SRGoM2KekYwpG3AUHX8Q3S+Pm/iFysBmT6J?=
 =?us-ascii?Q?ooJlaebk1h1LTEBZ9XT5pozOuGapyL+pBsAMZ/OYnAK49FQ/8I6vCTM6qX/4?=
 =?us-ascii?Q?FyeS8ZsusqH/nc2Ob5yfts4swlsg+YUdfyEKvCcEtiztjNX1gFd5It5u8uCf?=
 =?us-ascii?Q?jvdPXFPep1nOGSu732JAclNWqBtthpHKqzYOtPSNGOWbbAIFjmAG8E7wmrhy?=
 =?us-ascii?Q?vG/8OGElyI1VQrjWjlgazAHMPQquSEiwi0i2E8WL/0mgZ3l9ALh8T/8Vlrg8?=
 =?us-ascii?Q?CpkKBKFKbZ6jUpvd1r+BcUSixCWOEvnHs/90UnW+fliRyA2apdb+pRu8noYy?=
 =?us-ascii?Q?DeiRUvF1SWcSkx6kEljRG9ExbIiKI+WWGR6TLT4AgqpcbRSCnl/Chpx7/z0Z?=
 =?us-ascii?Q?ePlYEH5JDFNkfR9twIeptOU3mMfoRj/UVOF8Yn7rsCjseR/IoEkNIhTCtGaY?=
 =?us-ascii?Q?7VY0ow1edIYtZOgyUC9tOVEOt9KkkU5/HKp/Y+uQNWmPK1eAQ4CWah6a75jL?=
 =?us-ascii?Q?iTHmbBdxIG8rBGnl1oueAz0Fy415UMga0GVewhqUDNGfnBEXyJBlmcJOLgPE?=
 =?us-ascii?Q?kHbcJ3DGOJm8NVT5a1RSHBMKPTixyfAGrrqOu1vkERsHxrcopfNguGaMzYWP?=
 =?us-ascii?Q?Wc+PNnPbhov3Yn6fDG0h+4A=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <605847C7AB810B419D9E347875C361C5@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	d5LgAltf0pggBCdK7nq0PyvrcF8KM9nfha1doCXqR8Ap47vwf7W80aUh+e58bpzMEuAeEciCrf+8b1v69S0NsbVGLntS1jMkmUnLEI0sdi/14y0CNHh7mf3R1KIL8/IWwkDpjZj8QjgkYQ8z9aQkgRqrPLBXRT3VGPia5N1daW+Cll5CiSLHTLoWquCiy/zO2Z2g3rBcacDmwMD20k90/HkjdLJNDbRojdFapi1jrLgHZ0Sx4xnEXzZ0VyZ/0wQb/OS1/pAg4i+iPfDzNK66emFfZ9evsuMchT9d3VEWn+RgFAqsMbd+jh3WlKAD79dkK1TU5+YUMFysZCiS3Z/HjLg2sabVV6SM7K1IjjrSxyWJItGmcce12IIAV9GnGPRV4ncwBq8xyC8r0lRBYog3bN/J8m1MHEtO7SS2dpLVsKPA+yB7j1h/rC+IgVujqhjxCRb4nXD/OR7bvn7lTzoSXIC7TJPmB+f+3NfAM8LyDjhbvDhXxI8yhKSRzypq7dlDlo4Z+v1uils6G2ffull8MjXYagsAgC3BbK2gu/Pxr45BZgQsBIxVfN0D3c9NwYqHZyP8PvyOoyn2A+aU2lRecg7zxqkVIgaOx7uEWnStVU+WzQvCiOCBECpqVx/I2RUy
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdfe46ed-1469-4d2f-eb4d-08dd4ceb7e04
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2025 11:34:07.1316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ++9J+hPcbkkSjkRX/eiH1KXIjBWDiHnSRhyhGVwmMRhdRAck4Mhd8+Uh4Atoqz3obB8Envnfhwo8zgMXILBQD/90IhZvZ9k7r5dSt/8/c1Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6676

On Feb 12, 2025 / 12:54, Luis Chamberlain wrote:
> This v3 series addresses the feedback from the v2 series [0] and
> makes some minor new changes, the change are:
>=20
>   - Fixes all shellcheck complaints
>   - Addresses spacing / tabs fixes
>   - Adds _test_dev_suits_xfs() as suggested by Shinichiro and makes
>     tests which require this depend on it
>   - Clamps _min_io() to 4k as well for backward compatibility
>   - Few minor enhancements to help capture up error messages from
>     mkfs from block/032
>=20
> This goes tested against a 64k sector size NVMe drive, and also
> using ./check so regular loopback devices are used. This helps
> test 64k sector devices, patches for which have been posted [1].
>                                                                          =
                                                                           =
                                         =20
> [0] https://lkml.kernel.org/r/20250204225729.422949-1-mcgrof@kernel.org
> [1] https://lkml.kernel.org/r/20250204231209.429356-1-mcgrof@kernel.org

Luis, thank you very much for the improvements. I made comments on some of
the patches. FYI, I reflected my comments on your patches, and pushed them =
to a
github repo branch [2]. Please take a look in them and see if my comments m=
ake
sense or not.

[2] https://github.com/kawasaki/blktests/commits/bs_ps/
