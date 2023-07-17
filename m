Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E91253BE
	for <patches@lists.linux.dev>; Mon, 17 Jul 2023 19:06:48 +0000 (UTC)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36HIwr0U027210;
	Mon, 17 Jul 2023 19:06:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=a/OGwuYKOiGgRqO1oy3CxnZdBiBXVhfnhh1Sud9lBv0=;
 b=OUB++4gtWj9i/z7Rm8dOx9KpaWlE8LeRLVqqughA4uSX6WFBkEWItT7AXmO4EjiA0m2V
 CEJHgVLf6Q0nog4xz6pH2YJkobQT2QmUOsz4qG2uqVO4IRoCnyHNG5sglEiaOtxUE0XD
 BrrL4fktwOoi2IcZuH8LOx0yPiBlbOn14n2ttgv4ASHFm4LVaxKdj8LOuD3hR/91EH+p
 jgXDnUeczA6+wfAhw0bJ+xhdL8fqS7Tgly6hNwkSO2f4UlKuYcVfOCNgMml2cn0NbgSJ
 h9okJxvGL5FoOb6Ocn7s/JPY59rRp091uRC5STeTyCto/jDwxOZsAYhLVXRLoojm3VNI Mw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run88kf4m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Jul 2023 19:06:40 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36HHUtTF007749;
	Mon, 17 Jul 2023 19:06:40 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2044.outbound.protection.outlook.com [104.47.56.44])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw3um0x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Jul 2023 19:06:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YsAQ2i/091iV8ZFtErXACe8fqhSkuKqpNW/tXZpPio3DJ2K0I9w0lieoXccE34oYO6oUjguWJUQssrVsB4SwWBcbNNvOc3HeqsuGhen5Jss6eLjiU0zyDbDKVbMMVpolNZ5aEoY0SuPJypk7sPKhBuV5+j8e9oawlJ3+OVtyNb0m41YLAGofqCy6olVXUu9KDsyNC0Dx5k/O6T6mckMEI0+WA4Esp2/iQu8c/psDW/8llu2S1JoJkW0a1ydtWCSQk0q7kRit6ox3aqFes9yR3ivR/mq7tZShfLzpHe9u2CrJStRgA+8+JUedey5C8/k++pyP9wQayKifjbV6PSB0fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a/OGwuYKOiGgRqO1oy3CxnZdBiBXVhfnhh1Sud9lBv0=;
 b=g+o7fqWQLwFiLstp+VkHDHxDMtSsjNHLVykjJgrs8eZTziON1D69FUThmghxpyygR0MwiUj0fv97p2EwzV7hri0ynF64B7ZOtUxiax4ZDD9NnSHVqlaBaNi2iJxkODpBG8UlJ4qeRLwI4/zvWREdsBeQqHHAYFcpNyaTmibkzExafJP+Bt2XzP8b4XEukriumopNHRDokJ/4pw1OfX6GkxhYC5a2AkYLkbEpnfzdDAxMqWQrUEeqt2tEAHmq5xApF5L898HVrwmVGtXe4FGmcwVg8ORtFghh5cVRb/zqOLBkDm61nzn7Sk8arJYsm1vpvv2+Xy5QjuL12ahmu6UdGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a/OGwuYKOiGgRqO1oy3CxnZdBiBXVhfnhh1Sud9lBv0=;
 b=UXoPwrkNgtCQaDecCWMhhQMDM2fuXmt4+WoR0ESpCS0DTthw4qoSk9QDLmlOvmHFvgnAMUFoCafEdR98awyKVW2AXCEdqxVGrxKjxEmSYtNvPFkeMWd8lXcIDei1F8b1/479KL7oiyRyBIWT27HH29eN5PhN2OULSUpo62ULiLU=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SJ0PR10MB4639.namprd10.prod.outlook.com (2603:10b6:a03:2db::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.32; Mon, 17 Jul
 2023 19:06:37 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::2990:c166:9436:40e]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::2990:c166:9436:40e%6]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 19:06:37 +0000
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
Thread-Index: AQHZuCAUESYeNYUHhkWWUPulsbS6Oa+83DAAgAFWrACAAAyrAIAAEBAAgAADugA=
Date: Mon, 17 Jul 2023 19:06:37 +0000
Message-ID: <FFF06800-6943-4EE4-ACB8-DDA20EE0339A@oracle.com>
References: <20230716194949.099592437@linuxfoundation.org>
 <20230716194951.848894569@linuxfoundation.org>
 <6B82BD28-1891-499A-8721-1567612EF553@oracle.com>
 <2023071733-eligibly-altitude-4050@gregkh>
 <1043C933-AE94-4B30-A4BD-4174AA9FCC33@oracle.com>
 <2023071713-composer-consensus-7283@gregkh>
In-Reply-To: <2023071713-composer-consensus-7283@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|SJ0PR10MB4639:EE_
x-ms-office365-filtering-correlation-id: 9c60bfcd-5283-4728-ead3-08db86f8f235
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 NgWeB7aV/CM/q9ruSWHd52oky4ZgWyqa5jtKNq7DRcXz+kLKLU+LzZJ5ZJrtVTXbuQg9YnaeWRHVsyF1CGmOZ4BGi3GPaxgZsMjFOgvlFYPUYZS69oColqr39f43nXtwZNv7E/ZE4Pv8a3lh9klIpMMWIGJmVXstcKDC/myoM4pRGRYalBrE1g3m5kSlhjBkkZ/HcD71E5Qh9SyZjVqJuiV0OOSNI7qtk4+2HwAGaF+KgQaTCUuwub+oVFT2uKxCjj7Assr0nxeak38VQBHcVxq2fFZe+dYrlPMRuvgVFXUKnWQO7IRxRu5NqVqDRomMozfvcdOFuDm6lFcdWcysDZmKOwnpJxcS6Qs3EZT7oDU8gz8uypTb0G5oyWpSlAd7hLgnWjbJXNeY5VQIRVr15jLLQJrJRVrz/WGpa77lHJKqqE1ugKVR2HT9cpEIV0xwWptiBFWIekHvfZ3D2ZS3fDQ/8+VulEBSymeVy35NhCEeHn1zqH6f44dMKfSzYKgmTsCqm6mWkH7MfD01oMiguyW9UScynpuAsxLMkHHIbpKL5M1FNarDUkcL4eyYbjbxo3WfMBlZvx05TbjYAQr79DFlqW+DIOEFMM9Z5YZuPKm5Vw3i9o0dBQP0E6GyV5Pc2+R2m0DJjgIp7BpOVcPEig==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(39860400002)(136003)(376002)(366004)(451199021)(54906003)(71200400001)(122000001)(6486002)(38100700002)(41300700001)(478600001)(8676002)(8936002)(91956017)(66476007)(76116006)(6916009)(66946007)(66556008)(64756008)(66446008)(316002)(5660300002)(4326008)(2616005)(186003)(83380400001)(6512007)(53546011)(6506007)(26005)(86362001)(36756003)(33656002)(38070700005)(2906002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?7cxMtujPaihGq228vWrYC+NnESm2a7v0hmO4+7rAzb1t31uCANNJdIRpbQch?=
 =?us-ascii?Q?9q2iV5j/rEgMiy5RoztfgtnwtgeZNCG2GOs6wTz5fZyx6SBX7i17x/Okd092?=
 =?us-ascii?Q?DWhFDtJQ0X7FAOZwPA1+Ut/1s2PqQzIx1MiKrs4ycIspj+jT+QtArVa/lAd8?=
 =?us-ascii?Q?ryV+fWPZwZdBO/M4rx0xYL/zofus+dB6IuHRrVBSZQBhFyaURIOlB9eKNftp?=
 =?us-ascii?Q?tnkDmzp+o3ZJvrwzQyMwxIzYcQG3GwJ7OSDgLJ9QQmLNFF6y8ph35QKjp113?=
 =?us-ascii?Q?y3fo/jz+5aeiSsUupxUSv4VJ0zIb2PbVew3wvwVaxRECuKRv0mwmZGPjCLRw?=
 =?us-ascii?Q?GCFNebsc9mADegyB6ig61I9/jvjAZVyq2srAvrJEDEfMGlLMHCFIfGCNw74L?=
 =?us-ascii?Q?mRaK0UDz1iGijHkuvys66t0PGuMnUCIzN7FTTspoKz41Djc3POK1/aWixhLC?=
 =?us-ascii?Q?QLVY3Ddt2i1i2iBAGWIyY68OGiEM4ZVmpSGkA6gt68QjnKkw6XkeMb0kdz1b?=
 =?us-ascii?Q?XVbnKsuaWNSyWzIYBVHwuq/LZi42CJbOPUUD7PuLmBqwrcrOaRVIks7f+pxF?=
 =?us-ascii?Q?XfHFF8slhcvqQIdeAqX926Z5MEr2+1pX+Zh4AcshaNhm2uVGzxQMuaNgIQtX?=
 =?us-ascii?Q?sCA+ykfo1Xm/Qm1UnpnMPcBz/hXb/DAb8tO+5GXAN8zewFKnCEneeCcl5K5E?=
 =?us-ascii?Q?dnoUO1EwfqKLDmVHmwm13JXUlDTw+UZz1xcCIK/htbUHEzzUmkid19jhxH9w?=
 =?us-ascii?Q?HLWPCdLIGhIsxRmbVcLaQnKbPOwwIxl1SND60l9GmBOcMXSlA5pM2Z8hgw0k?=
 =?us-ascii?Q?LSvsAdZysuev6uUi0aPsPlFaTnVVTzyQQXyMdRvbd3RRyLQsk/rbdTkGfFOG?=
 =?us-ascii?Q?IDG+Kw5WzzqAE2ArPeRl/3gE1Hk9lSIwFO1wQcUEoMy+8PpIs+20RTe38Gnr?=
 =?us-ascii?Q?5xZ5fXcWP8vpBL7rV12ywUSRAXVQfBbLILNgENyd/6kbtl+EZo7gPE1K45lS?=
 =?us-ascii?Q?PqKE+bQbJlCDwC9sbMIy/cTJKze53yLWFW3VFjF2TqQKmYBqCTWJPov0Mh8a?=
 =?us-ascii?Q?8gaQdJJK7eNXQsy8IO2vsg7g7SMEkENWpGqIo+mknG97e4DdE/5BdsyFkfpI?=
 =?us-ascii?Q?VlmRks8h3gRi36cV8y93Gqo49/ZMY84S0s5U597sOtjwJqQURZDkAVyazlrh?=
 =?us-ascii?Q?wHKMO5kX3oGQ2ioJZfYp+8+jfr/wV2PKW3wZK+kZ+X9b2lhmkCBqom3Y5WG0?=
 =?us-ascii?Q?6Jdu7XzR5GJTWjA5nWX7FaBj96Zh4+yoi7Z11YblaGdD8CWZzTg2AvRZjydT?=
 =?us-ascii?Q?5zs3z+wv4AJVMyy6ZmuLxENQuVb/KuBQdJbPr7oVmCCqn+t/0Ioj7ZhSI4em?=
 =?us-ascii?Q?DMr0MqfXWLskX/txmJeUJo7puxn3q8XcL2u2+F++h7gpe8aopPZD5XlliAPx?=
 =?us-ascii?Q?NUqnE7tARI+kltNabPaZ/5qlsBvB4RQPnBwnJljZN9XryY9g8ne//DeJb+FX?=
 =?us-ascii?Q?Tdi5JFzEETqs0QdCyjuQtkSvyhjP7tdFSv4VBQTb7SNyJsCY16fFiCeVZWEy?=
 =?us-ascii?Q?7c5M/9eh7twFi9+fyVNbWceF2YwikMNllmgyR4LCs3Y17AVfveQCr8hBJiZk?=
 =?us-ascii?Q?xw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <394C05D243CCEF49A2CE6E89D336C400@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	PBzldH4WyGsN48d1prqu3vLiJAj0Qz0rgPMtXTgOdAGIZbPNBUS6Z+el7Jye2AS/OAT9SoD4QVu2o9tTaHDfFt3fRcywI45wb9+gFxe8i4/Dm/IBIKFKY0jVfuRexwYGxgFKgkewizwEsfHYi+kk/MFFphSzGDbS+FA8Cxrk7VAJcAeitSoV5g4JH5PevX+pkndXnOab5zdnWV9RRyJY0ow1GyZi7rzF99w5D/rMMuSs2dba0z4rw1D4YvLxJmRBPkbPp3zvkBNPdO5vPECPbkQKLmlnlGqGF1BMUNeADnBExq5mgI90cw69yCNWuz1MI/JTnOUIyPTCQxUrywap3njvib4qtxJTtXpG/wkb6ag7UMgFmc8UArDzpeYTQow8ImQrmQP4wgUOMroY1pQyb53wKzakFJoRprqTj0A67y/sNGZdloByV0G3Wf/eo8MkTcCwZwoUOUGN7qOBsrNk/rgNPfDnvY0i4EzutzPOGhxwIjfNVWWuaNR5/eL5yUz4QRWJvRjrsFnt3nMuIN31/9YKR0Xhwh5ZahK0JcSwfjnknXchuWnmIrOODgNO1rYjaih5DXnpt3K4wgDOyTbe5pX3sY0RU1Gj/bTGkI1mTbtlROUJqD9HYPL0PXk7QJdBzbehrCXDhuKVkfG5FB2DzTXmYl/lKjpgDAUHZbVQPSXxVmZjANfa3S/LmUj9+yzzZpXb8ip0SfHNG3ZzR1qU5zEHhbZAYbug2wPBDXYP4LhIDeTTHGiXtnZPCk+d8SAMu+eUN+KVEi5TbZjS6qYa4g4CPA6YXaQ5K5E96gRBmwhZXpkc91dhwd7MqgGhSQecO8GH1N3y9G0xMFnpBS+yKLCV6Ned2p2lK7H1hiXDawEoVJC8Wm5w3aHfOqybzUqy7VOL47sbdCXUBt/6bzWZdIAlBMnHRyhEgiPm9qjsRnk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c60bfcd-5283-4728-ead3-08db86f8f235
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2023 19:06:37.6279
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8PBXLQyhxCkvD4Os0PP7z1rqbCbilg3u/Aml8xuG6/hHmARAeVDg7u9y/KDV1qM+C9nIqU+HuvKfCYIlvFWZTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4639
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-17_13,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307170175
X-Proofpoint-GUID: UAP7fJfomZFE0DEWCij9fkXcXbOgelmF
X-Proofpoint-ORIG-GUID: UAP7fJfomZFE0DEWCij9fkXcXbOgelmF



> On Jul 17, 2023, at 2:53 PM, Greg Kroah-Hartman <gregkh@linuxfoundation.o=
rg> wrote:
>=20
> On Mon, Jul 17, 2023 at 05:55:46PM +0000, Chuck Lever III wrote:
>>=20
>>=20
>>> On Jul 17, 2023, at 1:10 PM, Greg Kroah-Hartman <gregkh@linuxfoundation=
.org> wrote:
>>>=20
>>> On Sun, Jul 16, 2023 at 08:43:58PM +0000, Chuck Lever III wrote:
>>>>=20
>>>>=20
>>>>> On Jul 16, 2023, at 3:39 PM, Greg Kroah-Hartman <gregkh@linuxfoundati=
on.org> wrote:
>>>>>=20
>>>>> From: Chuck Lever <chuck.lever@oracle.com>
>>>>>=20
>>>>> [ Upstream commit f921bd41001ccff2249f5f443f2917f7ef937daf ]
>>>>>=20
>>>>> If user space never calls DONE, sock->file's reference count remains
>>>>> elevated. Enable sock->file to be freed eventually in this case.
>>>>>=20
>>>>> Reported-by: Jakub Kacinski <kuba@kernel.org>
>>>>> Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for han=
dling handshake requests")
>>>>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>>>>> Signed-off-by: David S. Miller <davem@davemloft.net>
>>>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>>>> ---
>>>>> net/handshake/handshake.h | 1 +
>>>>> net/handshake/request.c   | 4 ++++
>>>>> 2 files changed, 5 insertions(+)
>>>>>=20
>>>>> diff --git a/net/handshake/handshake.h b/net/handshake/handshake.h
>>>>> index 4dac965c99df0..8aeaadca844fd 100644
>>>>> --- a/net/handshake/handshake.h
>>>>> +++ b/net/handshake/handshake.h
>>>>> @@ -31,6 +31,7 @@ struct handshake_req {
>>>>> struct list_head hr_list;
>>>>> struct rhash_head hr_rhash;
>>>>> unsigned long hr_flags;
>>>>> + struct file *hr_file;
>>>>> const struct handshake_proto *hr_proto;
>>>>> struct sock *hr_sk;
>>>>> void (*hr_odestruct)(struct sock *sk);
>>>>> diff --git a/net/handshake/request.c b/net/handshake/request.c
>>>>> index 94d5cef3e048b..d78d41abb3d99 100644
>>>>> --- a/net/handshake/request.c
>>>>> +++ b/net/handshake/request.c
>>>>> @@ -239,6 +239,7 @@ int handshake_req_submit(struct socket *sock, str=
uct handshake_req *req,
>>>>> }
>>>>> req->hr_odestruct =3D req->hr_sk->sk_destruct;
>>>>> req->hr_sk->sk_destruct =3D handshake_sk_destruct;
>>>>> + req->hr_file =3D sock->file;
>>>>>=20
>>>>> ret =3D -EOPNOTSUPP;
>>>>> net =3D sock_net(req->hr_sk);
>>>>> @@ -334,6 +335,9 @@ bool handshake_req_cancel(struct sock *sk)
>>>>> return false;
>>>>> }
>>>>>=20
>>>>> + /* Request accepted and waiting for DONE */
>>>>> + fput(req->hr_file);
>>>>> +
>>>>> out_true:
>>>>> trace_handshake_cancel(net, req, sk);
>>>>>=20
>>>>> --=20
>>>>> 2.39.2
>>>>>=20
>>>>>=20
>>>>>=20
>>>>=20
>>>> Don't take this one. It's fixed by a later commit:
>>>>=20
>>>> 361b6889ae636926cdff517add240c3c8e24593a
>>>>=20
>>>> that reverts it.
>>>=20
>>> How?  That commit is in 6.4 already, yet this commit, is from 6.5-rc1.
>>=20
>> I do not see f921bd41001ccff2249f5f443f2917f7ef937daf in v6.5-rc2.
>> Whatever that is, it's not in upstream.
>=20
> I see it:
> $ git describe --contains f921bd41001ccff2249f5f443f2917f7ef937daf
> v6.5-rc1~163^2~292^2~1
> $ git show --oneline f921bd41001ccff2249f5f443f2917f7ef937daf | head -n 1
> f921bd41001c net/handshake: Unpin sock->file if a handshake is cancelled

Yes, I see it too, it's in the repo. But it's not in the commit
history of tag v6.5-rc2, and the source tree, as of v6.5-rc2,
does not have that change.


> $ git describe  --contains 361b6889ae636926cdff517add240c3c8e24593a
> v6.4-rc7~17^2~14
> $ git show --oneline 361b6889ae636926cdff517add240c3c8e24593a | head -n 1
> 361b6889ae63 net/handshake: remove fput() that causes use-after-free
>=20
> So commit 361b6889ae63 ("net/handshake: remove fput() that causes
> use-after-free") came into 6.4-rc7, and commit f921bd41001c
> ("net/handshake: Unpin sock->file if a handshake is cancelled") came
> into 6.5-rc1.

f921bd41001c isn't in 6.5-rc at all, according to the commit history.


>> [cel@manet server-development]$ git log --pretty=3Doneline v6.5-rc2 -- n=
et/handshake/
>> 173780ff18a93298ca84224cc79df69f9cc198ce Merge git://git.kernel.org/pub/=
scm/linux/kernel/git/netdev/net
>> 361b6889ae636926cdff517add240c3c8e24593a net/handshake: remove fput() th=
at causes use-after-free
>> 9b66ee06e5ca2698d0ba12a7ad7188cb724279e7 net: ynl: prefix uAPI header in=
clude with uapi/
>> 26fb5480a27d34975cc2b680b77af189620dd740 net/handshake: Enable the SNI e=
xtension to work properly
>> 1ce77c998f0415d7d9d91cb9bd7665e25c8f75f1 net/handshake: Unpin sock->file=
 if a handshake is cancelled
>> fc490880e39d86c65ab2bcbd357af1950fa55e48 net/handshake: handshake_genl_n=
otify() shouldn't ignore @flags
>> 7afc6d0a107ffbd448c96eb2458b9e64a5af7860 net/handshake: Fix uninitialize=
d local variable
>> 7ea9c1ec66bc099b0bfba961a8a46dfe25d7d8e4 net/handshake: Fix handshake_du=
p() ref counting
>> a095326e2c0f33743ce8e887d5b90edf3f36cced net/handshake: Remove unneeded =
check from handshake_dup()
>> 18c40a1cc1d990c51381ef48cd93fdb31d5cd903 net/handshake: Fix sock->file a=
llocation
>> b21c7ba6d9a5532add3827a3b49f49cbc0cb9779 net/handshake: Squelch allocati=
on warning during Kunit test
>> 6aa445e39693bff9c98b12f960e66b4e18c7378b net/handshake: Fix section mism=
atch in handshake_exit
>> 88232ec1ec5ecf4aa5de439cff3d5e2b7adcac93 net/handshake: Add Kunit tests =
for the handshake consumer API
>> 2fd5532044a89d2403b543520b4902e196f7d165 net/handshake: Add a kernel API=
 for requesting a TLSv1.3 handshake
>> 3b3009ea8abb713b022d94fba95ec270cf6e7eae net/handshake: Create a NETLINK=
 service for handling handshake requests
>> [cel@manet server-development]$
>>=20
>> But I do see 1ce77c998f0415d7d9d91cb9bd7665e25c8f75f1 and the
>> commit that reverts it, 361b6889ae636926cdff517add240c3c8e24593a.
>=20
> Very strange.  As this is confusing, I'll just drop it for now until
> someone can straighten it out :)

Thanks for dropping!


--
Chuck Lever


