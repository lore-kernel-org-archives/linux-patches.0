Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2119.outbound.protection.outlook.com [40.107.114.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DEF1C2F
	for <patches@lists.linux.dev>; Thu,  8 Jun 2023 07:23:17 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V1nFG9EmuPxJNKogUm/68MCsl7LaxsIypAuwpBxH/0wf2ilsXh3fQ5zYqiMH/Vz8Vfaxz2zBBZFP9JD5SAIW3cLBYPkyjRVkaLA9fk5l4Nv67CGVrtQzJQ3u2sAuWYakvtw0ht/aTY1mxe2Lfa2UW62ORS3VvoZxK/5bqK4NkhIDrKffFu5NNERIbqKuIN7K5HNnZqqeyeD49b/wrMmRkv2KQyI/SyDA9BQtjnEQRchI59oD9+NMe76RrZzczgAFOLkr/vzsYV8chaDeKIppH7kSdvsJ/ihFUQEoztYZFFq0WjoGUnYm2TaDSJhNQJksZSMq2+VolnGDHjsNCvWXyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Le/Kw8CCPtHEzdckLX+h+CGdKNnMSW8ImqpUSlsybA4=;
 b=ZcPqhjDdtBXX8bCAWkondnSa8B3OokWfqfl7UXUOLy+3VUYOofXaDhO84grkJtCxUTPIkI3J6Ur73UkMcDlR6X78mnVvhaHv8FqejxesMbwCaqQEEgFeJCmb5P1FFvcGwsFJ+x0gR0ssJ+X0lkH1BOh5zBDnsWfxUJg8cmLObxpwJ/Peier6SP9UbBxAmA/KvG1jNd5wvuQygZyoTOM/SeFnfR7SQwqW15jllun8Icb1ELnBPfln5+a1BhAhE5gc58F9dJwgE/3e6pQL709UkdMi2kjZnYBHIRcQIYGHHo+vBsV2HGIXqionkhE62Wlzex6vPBE0LfV22CwjPdifAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Le/Kw8CCPtHEzdckLX+h+CGdKNnMSW8ImqpUSlsybA4=;
 b=JQ1XBbyhpvLlhiuIbKAVWZLxSyQY6l+I3fihk3BGe+y4CgtI4y7c+q/f8sYq8ZWz5i1aZ+7De8YaTCCTDwXQRgGdrtIYKWWJ3doJ9l13vsAQ1i4RexGjzomaulKeaa8oP7bO0AiLrdGEz13Wia9Q1xDRaTCG0n9MUUL0mQq0vWU=
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com (2603:1096:404:dd::14)
 by OS0PR01MB5907.jpnprd01.prod.outlook.com (2603:1096:604:bd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 8 Jun
 2023 07:23:14 +0000
Received: from TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::a4f8:4204:cbe6:6cb3]) by TY2PR01MB3788.jpnprd01.prod.outlook.com
 ([fe80::a4f8:4204:cbe6:6cb3%3]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 07:23:14 +0000
From: Chris Paterson <Chris.Paterson2@renesas.com>
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
	"rwarsow@gmx.de" <rwarsow@gmx.de>
Subject: RE: [PATCH 5.10 000/120] 5.10.183-rc1 review
Thread-Topic: [PATCH 5.10 000/120] 5.10.183-rc1 review
Thread-Index: AQHZmYGLzJ5UzQzMy0ysQiVfy6NUoK+Aacew
Date: Thu, 8 Jun 2023 07:23:13 +0000
Message-ID:
 <TY2PR01MB37884D003E48FD6BF9B3FE8AB750A@TY2PR01MB3788.jpnprd01.prod.outlook.com>
References: <20230607200900.915613242@linuxfoundation.org>
In-Reply-To: <20230607200900.915613242@linuxfoundation.org>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR01MB3788:EE_|OS0PR01MB5907:EE_
x-ms-office365-filtering-correlation-id: 15fffef1-5f5f-4860-406f-08db67f138c3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 KNhFG+Fb4B3XFebwDtGb0erbNRe+C6NGA8O1S3V6utOzSjzkROkl5nVVWb8/0Kn8D2q0vAqI46nNhTxz/kT0eKDvYdvwelr5/iUufPQ1IQO6npkpdFRPuN+LmknhaR2+dP44gUwzs5FSQPnH/J+e2+s5VpL3OHCStNCm1ri3jhizKSxyqxhDeHq3aNOau0ClUFq0gi7Bq8w8qvUQ1RMlz6whBdBl7uVRSBK5A8t5ffZLDV/dhX82w/PYLBb27HRtavJ7DjCSyTxIRe7KS57drkGFbmfl5MXjx85HZZQToNUQgG9DcTF3sn4bvh4xbALwP7hJ1nWS77DqtHXDm3Meycs1X7HQr6QyT0WMQUZ/z07GHxHR0NCmLZnP/3tk5iJwfGfBGkV1txK0HmTqhBjRdWhAH9VvUrjGG4VhcEedWDYzhc7qJmNela56XHbI6NyRY/RRoHDHftwZTbINwP64xc794sIJdS1JlN4roD38d/BeAQYJ/kBNxNNPby5Z4xeM6FJm6HDce41PFXSbo+PHKq0CqRHHd4hSvD1q6Pxx5o41kZEVCkPoxPyxGV0BzgxHFArzUrmY6HXP7+WoqmRs6in3M6/mcLTazNO9rEi2/0BO5ASL1vmTRxh+NuaiLvFf0Ib0tjJUvkRAHqWw9B8EBQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3788.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(136003)(396003)(366004)(376002)(451199021)(186003)(9686003)(6506007)(26005)(966005)(86362001)(7416002)(7696005)(4744005)(2906002)(71200400001)(8676002)(8936002)(478600001)(110136005)(55016003)(33656002)(316002)(38100700002)(5660300002)(66446008)(76116006)(122000001)(4326008)(64756008)(66476007)(41300700001)(38070700005)(66946007)(54906003)(52536014)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-2?Q?05+qXWkBSqi+izwhtZl+KiiigMnnkyjpHCD4XDTSOkmLdJpqflemLyW3jD?=
 =?iso-8859-2?Q?tEhdwJgRu8K2BlOceTITScxuPZmFvqF352y95Imc0c57RA6KuyPRFs/g2R?=
 =?iso-8859-2?Q?/TMblQa6wuGk3arVa8DGx3mQsE2MP/Q82B/puwsDmYvDZghy0L4z/x7XM2?=
 =?iso-8859-2?Q?3mZ/gw/zYXTbbSweGn+oOQE6myYYVMqfl06Awex0ZkZANp8Vxm5LCPXehb?=
 =?iso-8859-2?Q?agpJYqXrBtklPEltmx6csv7vMnWjQogGbHTGiTFuGEYAlF6N9PGKBXSEAI?=
 =?iso-8859-2?Q?G8w4Y2RBPa0Bqn2mBGZpn70Nhjz+yRjz99u4rb2QFQy3faDi5sHJ7K6VBH?=
 =?iso-8859-2?Q?zQ3cdJdtpOgLqzcMgDBuoWMhIviw4TYOd8D6oQQjFkLj0L+0ZDuUQhyi+b?=
 =?iso-8859-2?Q?wO8Oruy8r5nqgVl1hBr7pcgaMlCK1j0McJ3IY3F9Y8y7yRGofC74MpRvXg?=
 =?iso-8859-2?Q?KMstx4eWKvWPPpAxa79Gzz4Sb7zVKUdg4g3HUmvFy2FPmPWmwwK6OQpg7L?=
 =?iso-8859-2?Q?yWGzv7JI/NF60kOg4iGR9IoqJOOEDCbFgSflg14nDKghgrhLZXJI0Pi4Jq?=
 =?iso-8859-2?Q?vl42WAMpHXKmsTZtiGHAq0wC16g492vcJNIyOMLIFtfG7njRWAGHtuLRss?=
 =?iso-8859-2?Q?O1KBzqb+0pLgQEj56uxDCm5piDs2dTtu+aNDMGhUuVVhPErvDmlshzJ+6Z?=
 =?iso-8859-2?Q?SwSDZh7f8nrW2zkTWF1NxtcVV1qPFXt/u6YmxcKLwWb7ftGh2ZwsorTZd/?=
 =?iso-8859-2?Q?ulYzJZsksNPJTe10JkQtDMb9Cupz0Ie5asLiH4PlIAszOF6oVQ5UAX2M1K?=
 =?iso-8859-2?Q?G0tzZEX7ClcVOaGZTyQutanZ94Dh1s1WdN/qsSJBDtc86lyfOTkY+hDiBa?=
 =?iso-8859-2?Q?W9oO4EoiM3PchvnbCO6Gyn0uC+6JrRymAOmKMgNHbxqQsfCJvu6Oe2NC7q?=
 =?iso-8859-2?Q?W8/k7FgXfXjsx7kQrUVALkOxmzyeOjBMI4vlOqoFy7dRtn21Hy22fOWzTf?=
 =?iso-8859-2?Q?/H+78UriyuIPwMG8Kjcvyvmp7cCVGb2fdgR2cndI3JdEySd3AhXZt+ZGX5?=
 =?iso-8859-2?Q?sFhVNrJqxS+W+3S50Ntn0AksNozOYzcaRnO2PPthomEq5MqAhDOFKlNswM?=
 =?iso-8859-2?Q?S40rQbOyMsPEOziZWB4YUJrXs4FEPwLQkTGhH/hM40f3XIBWIpvFHRCYuq?=
 =?iso-8859-2?Q?DyCD+fMKR73hycYwapEMWNDa4Qr5oUvahafQmIlv+q8b7gJ8dWLr3TgXbL?=
 =?iso-8859-2?Q?whjVY2h/+N4kR867LPpRnQfeejA4OGxcIPN4u4GXlua9YzrfsN9GB23YaQ?=
 =?iso-8859-2?Q?IpxAG8Kc7Uvk7FXa2aiKjmNmc66m3OaA+Ze2di/e10jBH4BfaJQKNSU+0h?=
 =?iso-8859-2?Q?IaEB5Q2MwJ0qofwhDg9W6iYDkYm40skQFqRYqpbl/wiXl/Zh/8ZNJWqJW0?=
 =?iso-8859-2?Q?k7PDRx0uFJ4TYM/3TqyoxWyMlOKWMJZLZFY9nuMIU80CT4m7YYp5+EuoQB?=
 =?iso-8859-2?Q?2+4R9e4b6GzdGfHQNvXi0v+XEFcyoYvjXitqpGbxRp+cctUu9/dYLllLiF?=
 =?iso-8859-2?Q?8P7axOCsug2m2sJWA2I1UeegoQN17M/daFWT2RnDuwIcalmoMcbiPrcPoe?=
 =?iso-8859-2?Q?XLE88NoG8u8UK5stwBfAGKM2eeqCoAdhEJBngv5Vip5ybzFLYK1LGaQQ?=
 =?iso-8859-2?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3788.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15fffef1-5f5f-4860-406f-08db67f138c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2023 07:23:13.9865
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nT6yn298Z0WGqoUjyqt0s75lJZmvS0a+q1DOwJDNsNI6E4tqlepWp3yjU37vFoX5UxOVFccuy/x9OIWKL1Kw7CRfeIY6Hp7y8gaoTCC9Tc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB5907

Hello Greg,

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Wednesday, June 7, 2023 9:15 PM
>=20
> This is the start of the stable review cycle for the 5.10.183 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri, 09 Jun 2023 20:07:31 +0000.
> Anything received after that time might be too late.

CIP configurations built and booted okay with Linux 5.10.183-rc1 (ea69b726b=
972):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/8=
93073956
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/commits/lin=
ux-5.10.y

Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>

Kind regards, Chris
