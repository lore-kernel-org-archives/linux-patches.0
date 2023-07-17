Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B03B1878
	for <patches@lists.linux.dev>; Mon, 17 Jul 2023 17:56:03 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36HEwrsK007889;
	Mon, 17 Jul 2023 17:55:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=DIVJPyqxxEpozWaJrvS1qb5ZAabWmzYFEsAkDz9I82s=;
 b=04QsI2y4AsnitBVewNGdxsRni235p7uNtYywdY5Dhr5Z95dSKsYRgLt56ZCwXwWFLroF
 LA6YV4SkyjlXk6qJETYUIrFV/XLsdjtHqWuEDxg6ZJjK+gnp7RiGVXgob3zbEV4ZIMoW
 SsEg+ryWWy3WO2d4DKxVBHr2rdp5nxVI6rS8T/yF1xqKmhirLo2GcgnOjYaTDTowIMrP
 zuv8wCT2xoUFKiCUoBddNjV/RziTJ1wp9xMmW0RHlftqvx71KuBmR6vWTjLVrD2cW2sc
 +lKbkZICCDT3rjLvcSN7kVng6qC1DWUK+4a0m23aUtFSysGqLm5G0AvFzhJgyfCE9BGA jg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run8a3act-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Jul 2023 17:55:50 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36HHjp43000867;
	Mon, 17 Jul 2023 17:55:49 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw40gae-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Jul 2023 17:55:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UIFuNRcRMO3/OL6WT9wexs7pnjlgd84phh6O8GRWJ3QjB8DicHbmsUI9/4/WzVUm81mZz0pZDAQx6h82MtI0dy2r/+ge8dy317pz2qASTzRvq2jX/uMg4YcPm8WCu4n/iYXHbZlAwv6OGWwVX588KnwyD7R8qtTtl7N/ZHfaCtdEAW+HSb8gSFQHUbLJ0xdfX50iksskFRLMXyaO6aSZZLMkMOFh8vbYC6i9Wb9607nl9s2lCXaT/SBRg7qN15wpdBOQcqp5PupKY7f4cC/ZKuUPN+528E7ghOvaXItXSV+JlHLqYCyCNEZDzsm4d6ZE76QrqyBc1SI5+xn5fVdbXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DIVJPyqxxEpozWaJrvS1qb5ZAabWmzYFEsAkDz9I82s=;
 b=msjxBe5JzVkwVDUwTLE16sUumLPrwxnvbxCNGsrvFCi20Uwly53rGijlF4w+sDbMzzz9tBk0rcwc2xxUOjYgmnN1v7kyPr0HUXj3pUYQTHp9huaVjeZFaI/Oy+ZsNIPA4xfj44usqdUQXfju2/yJcoYjXq/eIJBhlmFox/uSt+/FiW7m1kjtoQB7y1dlPEtsRo4a9YhPe16nylmLPA/UZLPq0F7U4kevE86ZqpCLBi91DA0xa8NgdyPTv28qOVgiRILpnYLuWyNJJYYUPnOypv15cx1E0AOY50UoDmZp/ycLYz2Jiryp7OznX50WfgJk9X66QeCyRUKiJEmW3LODPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DIVJPyqxxEpozWaJrvS1qb5ZAabWmzYFEsAkDz9I82s=;
 b=I19FWa2uECHco7DNHySFcR0ebi3M+dKvK1l614a6qIO5l83TDAILDJMlCymr04+YpfhVJyUdQFSIWZ4yKxNW3EnYB9JxigCA3+agbEQUb1CTHiL8ReNv75sbEgC+PjP5BxnxTFsuphn7NH/H7Sgaj8mqvRA4DQ6PMG5K9WTj4Fw=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by PH7PR10MB7840.namprd10.prod.outlook.com (2603:10b6:510:2fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.31; Mon, 17 Jul
 2023 17:55:47 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::2990:c166:9436:40e]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::2990:c166:9436:40e%6]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 17:55:46 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Sasha Levin <sashal@kernel.org>, linux-stable <stable@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        Jakub Kacinski
	<kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 6.4 118/800] net/handshake: Unpin sock->file if a
 handshake is cancelled
Thread-Topic: [PATCH 6.4 118/800] net/handshake: Unpin sock->file if a
 handshake is cancelled
Thread-Index: AQHZuCAUESYeNYUHhkWWUPulsbS6Oa+83DAAgAFWrACAAAyrAA==
Date: Mon, 17 Jul 2023 17:55:46 +0000
Message-ID: <1043C933-AE94-4B30-A4BD-4174AA9FCC33@oracle.com>
References: <20230716194949.099592437@linuxfoundation.org>
 <20230716194951.848894569@linuxfoundation.org>
 <6B82BD28-1891-499A-8721-1567612EF553@oracle.com>
 <2023071733-eligibly-altitude-4050@gregkh>
In-Reply-To: <2023071733-eligibly-altitude-4050@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|PH7PR10MB7840:EE_
x-ms-office365-filtering-correlation-id: d317f181-3eee-44ae-e9ba-08db86ef0c70
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 RjRNsI0govswPhxyIgLx3WlS34LP2op4FZpgK3POw6hVQjfUDHMZKdqtXXqg9Fmzeo3i36wDSvIYzVxte3Jr1j0q6ATbjqmgY3se2q0KLmRqbNnBw8i0mmyAllvyiyrd3zTmfPPdUCiYIB0uuQJbOFIuu5CbQGg/48VCQomZWFf3KEwN6J/20KX6Ul87jnNeTjeQ5sOvR0LZIb7+bNo1Fz6MIHEIFfsJ1Thdo0cDxUHNgXKOCruMdAyxuLj4Jhw0qx0iD1tBhI0ZeB6r2ZwRLcZIiuUlYX/YymqO3NQd+BUThE0zgc2KakmjSRzlaDfyVuZb+6yKorS54lixDZyi9uI8XvkA2kXohhqBj8ocykrOJpQANN+owj/pqj3z4quQTdNU+afCHrbjuaxBRzVrPGHSdFl2eoQgI/d0tn1dbWCflNfFpcYjbYv+wOB+yeP9pAqTT0r2kwuMkTqcie1lm4FPI0alaaAJdbjXg5X6V5ECGSuYVyC/4c+3GAxqpRNAiuUlPBoDnmew7sWyFG2gSb3zHFPjDn9ItM0GJ5ppz4WXPD+NxkHGpzRjlRTA+Lp+k+DGuOrgnJakaIfudxEzCLjsTP8s2VvgxZe9/sER4oGToV6nyTArOeHh9qCO/vuIWF3xPi5zeQ1oCy6vD5VvgA==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199021)(6486002)(54906003)(91956017)(71200400001)(478600001)(83380400001)(2616005)(33656002)(86362001)(38070700005)(76116006)(2906002)(26005)(186003)(6506007)(53546011)(6512007)(122000001)(38100700002)(6916009)(66476007)(64756008)(66446008)(66946007)(66556008)(41300700001)(4326008)(316002)(8676002)(36756003)(5660300002)(8936002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?eW6O1sun1Pf7XMfwN+goyNOrC/fU2TQwxLMxh3yjA4Yj/0FgnHm8tDapNCst?=
 =?us-ascii?Q?vxaaGmSJVk9inIwlorfaLIC0/py1eZ3QPAtnBGbk+QM8CwDCLmhN6sB1K/GW?=
 =?us-ascii?Q?Dsd2rIkLnSVnwnoIP/vu+hmE00f5MhPXu+gTGhHHoewlxaglYSMBGvQo6f3q?=
 =?us-ascii?Q?41CXilxfcr1CXOl6VMtUxzJDbpg0FzIOywHS7+2PtyS31Ol+wKsKcxl2EN0+?=
 =?us-ascii?Q?kmgk4zs72lrfIWiyQu6DImujp4ab6m+NC8WAqHGPwlO9aXcN3HTHTOwTxFqF?=
 =?us-ascii?Q?Wmb368QRogZ6bXEcTb52IFvfizME/XZhGwjm9upHnh/Wl7PtOWR11Ic2nLRQ?=
 =?us-ascii?Q?ek+0zvyarBY0NLw8wERgMsyP5pcbh9KN367rTUv6P3hsayD0tvQgg4Xz9uOI?=
 =?us-ascii?Q?x6dqu2xsSt4VMFZKrofbejU58omheaPb8BAEht5lc8l7HXk8a8kM8NadTGp+?=
 =?us-ascii?Q?+63w1nTp3HHF7QSP1Gn60ZHzfqK24Sc41cQ8Ehh+6EnPDrsxjosBa7tjMzg0?=
 =?us-ascii?Q?So/5XAssda5D2BCMoEkHdrs3PVnGqSeEJEKQzBOKpBVXqomQMHf+QMkWZLXd?=
 =?us-ascii?Q?0vUbr4Zhu5iCLlzwgsF8Z61yd6pBrRyk4T6x2P2SAUi5MGlWo5hxtgWp5cjT?=
 =?us-ascii?Q?6cUEgkhjuW+9E4gP5KySKBLV2n5pUHDrYUavaqL7gY1+A9f2b+s5ZoM4kYV7?=
 =?us-ascii?Q?fQ80jKyjV5uSXjLD+bDFomtobSulKaGsjs53utPUo5Jilf3NcCnq9SnOTFrE?=
 =?us-ascii?Q?HEEfuV+zpnmtVCoARud3pEwCrv4Q/8ICVyJPUhVFeydn/510Zkj9loGFAvSb?=
 =?us-ascii?Q?tSICVduMGnFynDyVdHHQ2Sljj0KUtfkWOnPE7HyHZdqM+lULY0Skj5HQ0ayd?=
 =?us-ascii?Q?ogbMqP14aOUzroU3/NgBeTOlv1sFDET1Lh+cqnz0fg6FeabTir9cv5wd8IgV?=
 =?us-ascii?Q?yeM+j2klhZA5p5D4l6CjCuuuxf4XQb/tuRlJmmmHrtu4vKEMK8XatIOFQorJ?=
 =?us-ascii?Q?6S9nS8k0YTycfbHN96vjDtF53YipjmZaxx+SiaBT3HlVTnlW++1gGzek6u4L?=
 =?us-ascii?Q?5kcxu/yOnxk1ENaLiWE2rgZrnAHrEIPKX1OYAqoMCYccnqo1jzigtOrOV07W?=
 =?us-ascii?Q?YxUQSGEpv2H/TEIdzfJKLEx0nm2L3dQGxyXBWzgzqPl4qXVmhCaHau/o9CR/?=
 =?us-ascii?Q?0eM3Kvkf34ZTntqziyTOYOdOk4Lnq/D3tFA4laaGLNzJvu0kkyXA9JzlVlTD?=
 =?us-ascii?Q?u5QGdC53XG1srTRP6VXUVo+zcIuGJ+dn0di7qYsIgA/ap3RcyoiWC3YpQZSc?=
 =?us-ascii?Q?XW3DEFN7fbbLHwMgfKF/ySXcsLk3fdayfOe/SqwnRMeO8wbeA1igdPD8lBns?=
 =?us-ascii?Q?K4+F+9oxSvfrTphMzLfH/Ih+ALv3uRdkDMfJvZvnkpdzZ5X42KMaJrYAhoBg?=
 =?us-ascii?Q?xOYn3dxUdKc6cDaQ9U1xOkuuQYkPn0EwTl5/2MhI4T3850v/h7Kl79Ppq4DS?=
 =?us-ascii?Q?mIkHDDhwcZWh77W243mVpNaWZwZRAkOHH0SAwJieQb0EAHK5gVn9W/NhaE0H?=
 =?us-ascii?Q?fL2S+sIrswSjiZfAtEU1RuW3BF3A2nDGao2JnkoAxPAI7NA7fyWNC3olT/dO?=
 =?us-ascii?Q?bQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <829976F272D86D4ABD3AB2862E6F6B46@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	QDQpBM5wSQ9QB9zn2vNs3UON7RGAm6vZ2CCBumugKBePlIGXEpcPk+mfY91g4PlrgZJAj1fBr8i4u+viWMJrcpryoaKjngyDihpE5Y9v3WkmmLqOOH2yNBxxD2cjPtKn6a4/3b3rjBRi74Vje2A0FOcHVpVVkItpMYKSx70vvairRPm/K9BxpkG7ex2XHzQphXoeUh4uLw79usJk2sZI8jI8z2dYefMybi1RX3cs4Yrw9goufnuq2+1VrP2H6DXIa0qEi8h0kVSxje8i16EUw+HFcUDutsqBGd5FIx3/yAZGlTcmXCk33t0YVYgLDmSV2lsw8YlAz4bW8x7JOKR01idK4RmkJC2XAotZp5xoJcoyk7BnzTnU3g10FMUbWEKIQyV2r+tc10wyUaMGOoJB65KAU3D3VVgXBWnpABV6blDSknajbEY1isHdeZjcGX8FlLwoHsOYJ0+h/DqyRJRvtqtWaKlZJD7Np2QNpotuI/6/sFAjFUXFYCcOnSH5w61H1i3iMSIEfEt7eMCjVrVNY44ooJcnjTB1dgEP45Ly6ZLfOWLwI+UvnoajA8oUeWAbt/VTLRcaZRHIiArXgqix/aVkiWDuUFpdCz8M64s6p/IME4MQS+rh6RIpf9OW8BCmtHoShECVf8u8uOOKodS+hOjU3QIKHIjjh+fKNdA7Y4BnG4g+KLk5UVSjEuaEXuY/IadaZy1URcJaZQsoponkBdJFsYuXs/RxYVnKusPVI1zgohoE64qE+Ux6813BtRfWdbGXyLvruG704EvwntclGWSpfVhJ3/XClSTg4VjY5mi8+RPTp0EkC4R/lJo2QJxhnBg+5NJtGWsEvXEMRdzVOPe1PREJbMZqj+yuYmuMQF3gENTIe8Gb6c3ZB9U43hr0I6ihSRlJ3Va3Xhmrgp7moell52IZ+1tRYDRn3LDKjNE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d317f181-3eee-44ae-e9ba-08db86ef0c70
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2023 17:55:46.6718
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4z7N1oErRt04ZICq64kreS1993y28mGFzF19Sy2GjNMD21cOne2JfxAYduMLvtApWHh6kqR2PXdk5qrJy0G5Vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7840
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-17_13,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307170163
X-Proofpoint-ORIG-GUID: 5KezGrKkJwdAjivQoi4q8x5mbF7sSfo9
X-Proofpoint-GUID: 5KezGrKkJwdAjivQoi4q8x5mbF7sSfo9



> On Jul 17, 2023, at 1:10 PM, Greg Kroah-Hartman <gregkh@linuxfoundation.o=
rg> wrote:
>=20
> On Sun, Jul 16, 2023 at 08:43:58PM +0000, Chuck Lever III wrote:
>>=20
>>=20
>>> On Jul 16, 2023, at 3:39 PM, Greg Kroah-Hartman <gregkh@linuxfoundation=
.org> wrote:
>>>=20
>>> From: Chuck Lever <chuck.lever@oracle.com>
>>>=20
>>> [ Upstream commit f921bd41001ccff2249f5f443f2917f7ef937daf ]
>>>=20
>>> If user space never calls DONE, sock->file's reference count remains
>>> elevated. Enable sock->file to be freed eventually in this case.
>>>=20
>>> Reported-by: Jakub Kacinski <kuba@kernel.org>
>>> Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handl=
ing handshake requests")
>>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>>> Signed-off-by: David S. Miller <davem@davemloft.net>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>> ---
>>> net/handshake/handshake.h | 1 +
>>> net/handshake/request.c   | 4 ++++
>>> 2 files changed, 5 insertions(+)
>>>=20
>>> diff --git a/net/handshake/handshake.h b/net/handshake/handshake.h
>>> index 4dac965c99df0..8aeaadca844fd 100644
>>> --- a/net/handshake/handshake.h
>>> +++ b/net/handshake/handshake.h
>>> @@ -31,6 +31,7 @@ struct handshake_req {
>>> struct list_head hr_list;
>>> struct rhash_head hr_rhash;
>>> unsigned long hr_flags;
>>> + struct file *hr_file;
>>> const struct handshake_proto *hr_proto;
>>> struct sock *hr_sk;
>>> void (*hr_odestruct)(struct sock *sk);
>>> diff --git a/net/handshake/request.c b/net/handshake/request.c
>>> index 94d5cef3e048b..d78d41abb3d99 100644
>>> --- a/net/handshake/request.c
>>> +++ b/net/handshake/request.c
>>> @@ -239,6 +239,7 @@ int handshake_req_submit(struct socket *sock, struc=
t handshake_req *req,
>>> }
>>> req->hr_odestruct =3D req->hr_sk->sk_destruct;
>>> req->hr_sk->sk_destruct =3D handshake_sk_destruct;
>>> + req->hr_file =3D sock->file;
>>>=20
>>> ret =3D -EOPNOTSUPP;
>>> net =3D sock_net(req->hr_sk);
>>> @@ -334,6 +335,9 @@ bool handshake_req_cancel(struct sock *sk)
>>> return false;
>>> }
>>>=20
>>> + /* Request accepted and waiting for DONE */
>>> + fput(req->hr_file);
>>> +
>>> out_true:
>>> trace_handshake_cancel(net, req, sk);
>>>=20
>>> --=20
>>> 2.39.2
>>>=20
>>>=20
>>>=20
>>=20
>> Don't take this one. It's fixed by a later commit:
>>=20
>> 361b6889ae636926cdff517add240c3c8e24593a
>>=20
>> that reverts it.
>=20
> How?  That commit is in 6.4 already, yet this commit, is from 6.5-rc1.

I do not see f921bd41001ccff2249f5f443f2917f7ef937daf in v6.5-rc2.
Whatever that is, it's not in upstream.

[cel@manet server-development]$ git log --pretty=3Doneline v6.5-rc2 -- net/=
handshake/
173780ff18a93298ca84224cc79df69f9cc198ce Merge git://git.kernel.org/pub/scm=
/linux/kernel/git/netdev/net
361b6889ae636926cdff517add240c3c8e24593a net/handshake: remove fput() that =
causes use-after-free
9b66ee06e5ca2698d0ba12a7ad7188cb724279e7 net: ynl: prefix uAPI header inclu=
de with uapi/
26fb5480a27d34975cc2b680b77af189620dd740 net/handshake: Enable the SNI exte=
nsion to work properly
1ce77c998f0415d7d9d91cb9bd7665e25c8f75f1 net/handshake: Unpin sock->file if=
 a handshake is cancelled
fc490880e39d86c65ab2bcbd357af1950fa55e48 net/handshake: handshake_genl_noti=
fy() shouldn't ignore @flags
7afc6d0a107ffbd448c96eb2458b9e64a5af7860 net/handshake: Fix uninitialized l=
ocal variable
7ea9c1ec66bc099b0bfba961a8a46dfe25d7d8e4 net/handshake: Fix handshake_dup()=
 ref counting
a095326e2c0f33743ce8e887d5b90edf3f36cced net/handshake: Remove unneeded che=
ck from handshake_dup()
18c40a1cc1d990c51381ef48cd93fdb31d5cd903 net/handshake: Fix sock->file allo=
cation
b21c7ba6d9a5532add3827a3b49f49cbc0cb9779 net/handshake: Squelch allocation =
warning during Kunit test
6aa445e39693bff9c98b12f960e66b4e18c7378b net/handshake: Fix section mismatc=
h in handshake_exit
88232ec1ec5ecf4aa5de439cff3d5e2b7adcac93 net/handshake: Add Kunit tests for=
 the handshake consumer API
2fd5532044a89d2403b543520b4902e196f7d165 net/handshake: Add a kernel API fo=
r requesting a TLSv1.3 handshake
3b3009ea8abb713b022d94fba95ec270cf6e7eae net/handshake: Create a NETLINK se=
rvice for handling handshake requests
[cel@manet server-development]$

But I do see 1ce77c998f0415d7d9d91cb9bd7665e25c8f75f1 and the
commit that reverts it, 361b6889ae636926cdff517add240c3c8e24593a.


--
Chuck Lever


