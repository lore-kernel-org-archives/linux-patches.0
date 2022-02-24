Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DC57B;
	Thu, 24 Feb 2022 17:40:43 +0000 (UTC)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OFa5le016953;
	Thu, 24 Feb 2022 17:40:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=i8MpQJthAOh1RcyYgKuaw3Ye+FDmlE0tE6Q6N2FMOCU=;
 b=KiUzpkYYh67F1QIeEDKrCPwOsAPX+P9Cf1lyXACc08tYAzRy2ccdB63JBxQvFLJrlmyP
 rvUbiFoEyxIdPP1+O/bJlzpi+kFVvy10RtvafMOj7gRD+5+Eo1XvfmwIlpOLiNqYXSWT
 WbS0DYj5QA5CfoQ6b+rzhRf7fELHTZfNu+V/rZyw9Caz+59CQlkth/HFXCpc4crSoAUL
 rcttyY46jUFK6t11k4SdXE8fsCSBRurFHJzSgDw8tHrIkCw5z3dDGsHjYx38jArra32U
 yLzbqd8QxPjLmX5G9t82N5GgYXVSqv7lc6FS4q+2fx1fEzC6AfQA3Rb/V1CBtGkNf+2a cA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ect3cqw2d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Feb 2022 17:40:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OHeZes120243;
	Thu, 24 Feb 2022 17:40:36 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2049.outbound.protection.outlook.com [104.47.74.49])
	by aserp3020.oracle.com with ESMTP id 3eb483wgy9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Feb 2022 17:40:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cYU8C1BQ+RXPgnsZyfLES1Mriw2NLHgtYeVljHGZgAn5sHwAjKRIz+l2UsWvhfrKVoFD9PCTU4U4liN9w155CaByiNr7svbcaMP//2CpIKRYKx+2l0Vb/S+9UkH0v2TI8On3V8Q+Y8wdm4EY6OKv60g85sjgWINwKLCuvvmW2A4equ8M8mfLp/xu4rfKEUxZMdtpwDG1NOtGE6bLG6xzb7g3/N/Rri8Inq5eDQ4N8ceu5lDVySpzmoW4OjlFma623h4HWiF0J04dsMEJ3nMwggufUIzuw9UefV/JNsyYrsjEcWQI0GKF/PzFWk04CtOpj2Zw5e3zZh+LuzOLQHOJqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i8MpQJthAOh1RcyYgKuaw3Ye+FDmlE0tE6Q6N2FMOCU=;
 b=jauuxfSMp/dL8wYtDKzyVov3sVZpWsYjr9x5qnnGpF9kXoxtJur12mLRopiVET7YO37Sbd26fCsg3AADfXY7RyBQzywqGJ2k8tUrgpfoxblMQ7I6mPwT/ZrZncGQ8mZVuk2Z+Wn1sDzOyKv1LEsLpNS5OCaXUIsQAjCH7SXs98fA/2AHweTtopmS2EP28ZujRty0pt3zjfYyOZVkJWBDeS1lQWhBShdFyXrSp5DONaTfdJgF3w1mEtOSa8zlp1j0i+9ldfoNeLWm0tIKKg/IQStZUhE6edaETB0pbwAj+aQ/c8IKlty6UOHj5z07a9ajp4ujEzc0yAqYslCyMrSKbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i8MpQJthAOh1RcyYgKuaw3Ye+FDmlE0tE6Q6N2FMOCU=;
 b=qKNqO+u6n4NO37vCde6bjLtMK82HxpncnNF4JRGvedjE6HTm/Z/cm7kseizk3gCPdpBCbJL4xzhAltKYqKJuXqcI0dFy5UvSI7HWqiRXH87UBslKqSXe9MNDjP2Rm9uthY7DBC4gTdEzly6IApLSsUwQndeKGlJwEeX+nCDdIaA=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by MN2PR10MB4383.namprd10.prod.outlook.com (2603:10b6:208:1d4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Thu, 24 Feb
 2022 17:40:32 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8df4:1db9:57f2:a96a]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8df4:1db9:57f2:a96a%3]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 17:40:32 +0000
From: Liam Howlett <liam.howlett@oracle.com>
To: Nathan Chancellor <nathan@kernel.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "llvm@lists.linux.dev"
	<llvm@lists.linux.dev>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH] lib/maple_tree: Fix clang -Wimplicit-fallthrough in
 mte_set_pivot()
Thread-Topic: [PATCH] lib/maple_tree: Fix clang -Wimplicit-fallthrough in
 mte_set_pivot()
Thread-Index: AQHYKZoU4i6bgjXbzUq6iVD6h1xXnKyi+AAA
Date: Thu, 24 Feb 2022 17:40:32 +0000
Message-ID: <20220224174024.6eftrvlixehvw2of@revolver>
References: <20220224161705.1937458-1-nathan@kernel.org>
In-Reply-To: <20220224161705.1937458-1-nathan@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0f8b2e54-56c2-4f88-7662-08d9f7bcc1ad
x-ms-traffictypediagnostic: MN2PR10MB4383:EE_
x-microsoft-antispam-prvs: 
 <MN2PR10MB438303915D7F57169B0ABDA8FD3D9@MN2PR10MB4383.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 +fObiuK848CF5fN7k+E1DupOlnyfTsI6SyrDYipD9ZiCyYIg+kgjznYxg4wmjkAo+ITrplqLfe1cO13sjtiNlX/ioXKhLAw1iwny8T3RrmBZRIznCOH6qoVrbg26yw2WQN3Z9tp99MW4IRDZwAt9iRJabUahYyb2iP8zrg54s9OklxDylHKzYm3T1iFJxUYD+KiwOnzL3E77OoyGFDdCgu+5pfa6jr+T/LtIDbZ+rHdGV0N5+d1D+94ZhH4kNqm6Wy+uxe87efRxkAPCYwguMh9ZkfJIwyhSC9870HDceLTf8Ooa9V+ZTLGFhlSiGLEdgWUVowJen487txadWPm5lTYP5FHVkEa8LUPkH6q77zyFqbUN0gs4EcllrJ06195zX5CA4nCAlF9yxPHeVjyzimG0eniqgkS4/EETjuPMCRwvn702DZH70G/23j0BHa7EsQXKBYVYQD3I/Kz12Spe8c4HFTgeiI3YgudcAGYc5ohvl4iZr1WSYqFGJRtkxOYlVA9c4hjSC8DPYSHf55/IVRxNeINQHgPkqVF9P4TzaDpYklI40VqzdVYcg4ji4FHq9q3Ebberl/JqhVX7/MXVZaPwiQV8ga4EN5gCmWWFfpnAehzVmPzkfKIiN9/zHDnQAijmpaFofU+QYzs6nNgZPUinx1yZR9l9Lgg/aEi9e4gER2jpi3BXRyJVyWRx/gigcluno2WQlQKPZgXGUF0ZJUmzR+Va8TFQcUpqox84CryVb/EQwPKXB7TSEqdNl7CFkfkNi3k6J2Jrb2FK1SxT0Sy8afU089EujB1QMacECxE=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(33716001)(8936002)(6486002)(966005)(26005)(1076003)(86362001)(2906002)(38100700002)(6512007)(9686003)(5660300002)(6916009)(54906003)(44832011)(76116006)(38070700005)(508600001)(316002)(71200400001)(186003)(4326008)(122000001)(8676002)(66946007)(66446008)(64756008)(66556008)(66476007)(6506007)(91956017)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?PFLMqZIwD9k/2Nlr70bkpVl2cFwLpBTzjSX5RyIeYhNXCw2/Uf/uJ72G/+2O?=
 =?us-ascii?Q?YskNvWEZU5lwGfzMjl0jIqsfLvhl5YpRrpnl6JLoTzzc6wkp8jlGGWSZpHfM?=
 =?us-ascii?Q?EUhO4nINURSyitADBnsJQpPREtsKFu+tBYxdCHN5TCOHGRgT24BnRETb/H8l?=
 =?us-ascii?Q?dNy4QDxoU5P5q94Tk2/0Cy8THvWBymN+yV9vKvNxRjigvOG1WmXlk+wMCBnp?=
 =?us-ascii?Q?8jtY/vyg61mHexRB5IoRt3WLfEoIhl3xo0Yv/8aLksSVlW6aCKfmMonCmkZD?=
 =?us-ascii?Q?/R8XsS7d3M0kKaFgGR8mTX7b9AvDaXprP89BUh88V9YUpxmm4+jCgh9eBVVS?=
 =?us-ascii?Q?bW8sPLwMivgF/vdd5rHfbuZl2X5JXkDUeUpvyMVvy4fFt1jiWuomcKCR4ioc?=
 =?us-ascii?Q?D7/Ct9iDTT3KOjxg+aIUZoXIN31wTO3htHiDgd21R8zcUqqRV2XUzwWM5Ozw?=
 =?us-ascii?Q?YDSV4d3qDD6/gYgN6yvwQFd1ZhBXB1IOaL4lZg3bj5NC9aNyfRNWtIGq8KRn?=
 =?us-ascii?Q?fG37/R/yv3dQ2xV0zBIx3ySFQVt5oJB5Rp6Y5TcjOhOin+YWNaRXNaJMd3Ia?=
 =?us-ascii?Q?NKxNVohfN43Po3Fw+Cl4dxohkWrAnd2XXmtj2c4fZmvzL6oUN7k3JzbmoNVY?=
 =?us-ascii?Q?1s1dvkyGeT/skZ0Hm8wSTLXBqVfTj0bIbM5WtZZ/7aCeb4LtAlsoRNmAspDp?=
 =?us-ascii?Q?BEy6iskhWA5k0ZEpsfYgJqAACl4M9QrulYuxOrRv8js8GTYii5oZ/sVaC8QS?=
 =?us-ascii?Q?mU5awYxuPhD5XJHwdMbrWBIvYTC/fCREXaqB16kz+ifeZA6mdwPMh9DYNtQa?=
 =?us-ascii?Q?Tw/ogeMdWDYDHyJtQQJuBpqec9O7rYTpF0Yzuosqvm6n3zC/CCbb5haCtQpH?=
 =?us-ascii?Q?3p/mlhqEU4Kl7227wevbCGnPCN/UouOdbxP8MkqBf3LfPwSfbUND+D5xRI/X?=
 =?us-ascii?Q?nrYAuzCoVePXtjXJBB5szH14EMVqz4dD9711pEV2xVhrUm5IJ0C1Ewi2miZJ?=
 =?us-ascii?Q?sPjaZgMwt5sVvqbr3OYAZv153HfSIU+NLCO7/qNBuftmoVAEHxYBJK1y6ols?=
 =?us-ascii?Q?dTrSJ/oCm5r3TKvgphAqZkX/nNyX8gdTsHlRlYGcQ7V7glGOH0tGh1qVcQUR?=
 =?us-ascii?Q?4RvMZKSeWK3jy8sacw/l2lZxdl3i7FRmq+oOTfV52JSDkh1yqTUT4C3O47ww?=
 =?us-ascii?Q?utdR/zrrMkjRh9c8kezdJvV4e2V8VzpCWVJIXlNAqnSFYGcRcwVFXR76fajY?=
 =?us-ascii?Q?aMQJE0C3s98uUvrtslsNmuR5VX5YvenxqPEFEX5dRrtYt2zDuzq8fv9zwhiy?=
 =?us-ascii?Q?ZkObOLRmkPa6+EwQP3pVrLNqxF7zo/Z4bclr+AVqaSPuDowefOkSXfVTPny6?=
 =?us-ascii?Q?xi52GOdSj4d9ssyZ8Cu9hgdYf2qOya8ecPtVdrVtyrfU/oEvSVjE9PCsXJv5?=
 =?us-ascii?Q?A/j7qNIcjlsdaaocxZaW7P8nesAUCGy9V+vRj+7pFeM9bwAdAtnb9bLqebI0?=
 =?us-ascii?Q?1lKBSVD7IE0Kk0LDSLTtsF5LssLSpLGZOeIZCN9HrplD/6iMYl+1iFgOwoWQ?=
 =?us-ascii?Q?poIKJRsa8hzN7gwS5hAy7gJ2xOD9HIJEkvnYxLYC26kaP5lK0Iq2DddEuZ+x?=
 =?us-ascii?Q?rHWtn/EGUbkbMP0tbCV983Q=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <566B3F69A5760940B29C842CB418BC80@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f8b2e54-56c2-4f88-7662-08d9f7bcc1ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2022 17:40:32.4137
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KofEQqGWcEDXsPkgmcsmLAJPLlk/XS9ThHW7W1I4fCliHnF3KpSDue1Gk8/6/uJtQ9vO+TGI+9YJQkObPUXi+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4383
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10268 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202240099
X-Proofpoint-ORIG-GUID: wGgTs5En0NlZm5R3dYyMDm3UOMN-YPDS
X-Proofpoint-GUID: wGgTs5En0NlZm5R3dYyMDm3UOMN-YPDS

* Nathan Chancellor <nathan@kernel.org> [220224 11:17]:
> Clang warns:
>=20
>   lib/maple_tree.c:764:2: error: unannotated fall-through between switch =
labels [-Werror,-Wimplicit-fallthrough]
>           case maple_dense:
>           ^
>   lib/maple_tree.c:764:2: note: insert 'break;' to avoid fall-through
>           case maple_dense:
>           ^
>           break;
>   1 error generated.
>=20
> Clang is a little more pedantic than GCC, which does not warn when
> falling through to a case that is just break or return. Clang's version
> is more in line with the kernel's own stance in deprecated.rst, which
> states that all switch/case blocks must end in either break,
> fallthrough, continue, goto, or return. Add the missing break to silence
> the warning.
>=20
> Link: https://github.com/ClangBuiltLinux/linux/issues/1604
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  lib/maple_tree.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index 5132495f86a6..5d8c39cbd517 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -761,6 +761,7 @@ static inline void mte_set_pivot(struct maple_enode *=
mn, unsigned char piv,
>  		break;
>  	case maple_arange_64:
>  		(&node->ma64)->pivot[piv] =3D val;
> +		break;

I will add this to linux-next and clean up the line above while I'm at
it.

>  	case maple_dense:
>  		break;
>  	}
>=20
> base-commit: 7ec16b08f9e0b656c96d20424b1cbbff4c78329c
> --=20
> 2.35.1
> =
