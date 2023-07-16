Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C611E8F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:44:21 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36GKLDoo013361;
	Sun, 16 Jul 2023 20:44:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=2ODRRmyNnFFvBz912Kp+Vat65YPQXk3PW04IcDPBJk8=;
 b=vD62QqrEzpifDEnAlqnAAL7TqED62sveI28SaArAk2oLWFgLte3WBxHVvGF6i9F4z9Cr
 9tHQ0Am/RHXBY6MEhwsthbW3Xu4ABpBSvTMAOGRdr7+JWVdbXj7Q5zoVO1v69MI8TJVh
 2E6Drb3csUhbKZLtGuxJnaJB4XdwAIoC2tJD+10ViqLQyfBbl0H861s6B/BqNwT58peo
 xlPFIH1krsv8oILt5ewj4SVJp3Y38rlj3YbTv0b9Ov5MzfFBIaT6gwW920udOvis7X+j
 JbOm3hXqRj14QxipCqxnINSUAxwD764JMCPJAHHKPyh4Os++U2tLxOyihE3evXJhHn+m fw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run8a1h2e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 16 Jul 2023 20:44:04 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36GJlCYh007769;
	Sun, 16 Jul 2023 20:44:02 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw2hjx9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 16 Jul 2023 20:44:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YCwi444q5odvwGafUEKZGk6JwolGD3LUsBq6QCuR52ADusi+LnnaMKqlAxLGjWK/SGmBtjeRGUU2UfddeAoTWGh7HTjyfXQabNyWPwTtb1X9xskUm4JO83c93gYbEBaiaglbthjX+iXM3j8Cg2wTBtV9ShtrQsck/48LDwCm2NM9tQ7aIY+8gFIGJIVEK1XxAJaeIZQx5LMbGlLwRN/DzyUKHMQfSLOBDXJm17JcBsA7v0SpRzFhrdSd4aWlZdHeHH6P9046w7JYq5ECM0r7GybZAGTvuKBetewXoiK0E45h9j4DGIzJ/GAI3ZEJcKiH+II/hJcfStBLSDGjDTd3Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ODRRmyNnFFvBz912Kp+Vat65YPQXk3PW04IcDPBJk8=;
 b=fxTmQwHMatA/Io0RW0F8L7JQlZOAQuWFpfsT4jDAQ0CE2iNQsnQ4dez46l0mjVMmEI79gH/cM78nnlE60jEkeg6WQJLN349eRPbPFTTYRErJeUnvdi/30aHPLzF/UaCzqjj9a0ohg21+pnxUOxr25NSDKvS3lA3WlZBEYt20/BMOxmNy6H77L9enMq3fMp2Oe8E0mrZOtH8M+CvcyqcBxsyCrC7gx+E2a/FUqiSRcljdzTL3c3JKugLIXE3mmidqsedD0D5Fb3vOJyK4D9/515f/diUESKvKLb4B0qSdFw4HDfuwix2vprU9Vs2xVN8tOFS+21O1eHvFxvTcGwW6Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ODRRmyNnFFvBz912Kp+Vat65YPQXk3PW04IcDPBJk8=;
 b=b7hpTdoMQxXyhHkrXclPzLXCsyDonQpuBKtg3Kjhtr+CN+miIzMVfNjap4s4sw1Xs/F6/BuYlH57L1RQKyyws3BxK6/lbpGtGi1XIYFvlIyQ2wSQOnSUUs1xPv+9ZwD5lesY+Da+bpHUbEDMUmaIe4AjvlVYkd9edwnvjuV+dSg=
Received: from DS7PR10MB5134.namprd10.prod.outlook.com (2603:10b6:5:3a1::23)
 by MW4PR10MB6461.namprd10.prod.outlook.com (2603:10b6:303:21a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.31; Sun, 16 Jul
 2023 20:43:59 +0000
Received: from DS7PR10MB5134.namprd10.prod.outlook.com
 ([fe80::926d:e528:98dd:7e69]) by DS7PR10MB5134.namprd10.prod.outlook.com
 ([fe80::926d:e528:98dd:7e69%6]) with mapi id 15.20.6588.031; Sun, 16 Jul 2023
 20:43:58 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin
	<sashal@kernel.org>
CC: linux-stable <stable@vger.kernel.org>,
        "patches@lists.linux.dev"
	<patches@lists.linux.dev>,
        Jakub Kacinski <kuba@kernel.org>,
        "David S.
 Miller" <davem@davemloft.net>
Subject: Re: [PATCH 6.4 118/800] net/handshake: Unpin sock->file if a
 handshake is cancelled
Thread-Topic: [PATCH 6.4 118/800] net/handshake: Unpin sock->file if a
 handshake is cancelled
Thread-Index: AQHZuCAUESYeNYUHhkWWUPulsbS6Oa+83DAA
Date: Sun, 16 Jul 2023 20:43:58 +0000
Message-ID: <6B82BD28-1891-499A-8721-1567612EF553@oracle.com>
References: <20230716194949.099592437@linuxfoundation.org>
 <20230716194951.848894569@linuxfoundation.org>
In-Reply-To: <20230716194951.848894569@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR10MB5134:EE_|MW4PR10MB6461:EE_
x-ms-office365-filtering-correlation-id: 566460ad-d075-4b80-47ec-08db863d6150
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 s44scOI88kSsdvBdCGAIIqEQobANSkUAskVgj8Jb8iELU2qMxiQUEv18lfMo+qM7QVDRZJ6I5T0xSYvifpUABuQAkqNtzJ9k85xRcLOV3ipbAfR3LoiB7WSEVBgZwyTKfH7G2WTsRPnlYZ9l9XU86JireS1H2WSgTUZFYerFSJ7+H8lWQQbWlApDlr4Rp5L0RLcj9Od6cjs/Hdq+ZVCxhMQ0KGq+sFonuUEvHkZIg18Q44dhbZWikQl8zc1CxD4doe1oigTgfdFzMlT6zzT7BLqCDRD7O3B/FLgeEbQ+YqMsexfWcN0OsDin++bvVSZ43O8W7Yw1l5t4IxR47Q9afzbk8IXq6RT9eKR3OksPzsnj2OuFskwORRP8j5IUGZEjX8o14ipbn7Hs8/k4fLBxNTE/utui0omZ2kiNY2gVe/spWsQDoEbSTDPnGdm4VMGyQTKULr9VEgdVZ5ziGKzoP7icLZAURSyUso5bmIatEA0BDAWcNVG4djZsg2EmmJ9cdCK+HLmDKCYBt69ZR4pq8tfM/gVuVuKb7eRDDSzh1X+EqNQ55Jvcj2Y5tfY57YDwLZNQRMcWRbuhpas3NDovg7K51fAPsLxEnXvxjwJItjXo11pHVv8y2BA3pWszxeBZxl2nZrHK5ZsJ4HKmTL+V7A==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5134.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(136003)(39860400002)(396003)(376002)(451199021)(478600001)(71200400001)(6486002)(91956017)(110136005)(54906003)(186003)(53546011)(6506007)(36756003)(26005)(6512007)(2906002)(76116006)(316002)(41300700001)(66446008)(64756008)(4326008)(66946007)(66476007)(5660300002)(8936002)(8676002)(66556008)(38100700002)(122000001)(86362001)(38070700005)(2616005)(83380400001)(33656002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?+spSuPmyKvWVdf6cicJHjFNeKqGgztHRn02NsNROR1Vx7W1jfdoUkSGailIR?=
 =?us-ascii?Q?zuML51EbDQ5cQw9NqsjRJFb2BOMMwt/knW7//CSRcOeNWKOeUrwZT4+VztqW?=
 =?us-ascii?Q?J9wdBijvJxufmPh1FrvBlbUoAYMXivty7AQumEdAnotiw3TGv8Cf/JWXprPQ?=
 =?us-ascii?Q?EpRJobdWvW9PciezXxSrx4ePP5pb49NznlciyEkc0ssRQk1MhzERB4N/Q3rg?=
 =?us-ascii?Q?x/2+LQAosejXV3ovI8B5DQOXXTobbO9tFiggl2JknFczSNJ5zXCXShyxF0nn?=
 =?us-ascii?Q?ZoD5zwlo4/K0A9bQxzkDDstUtj8vLMJO+JnxzWox5PIS8UZFI9ORoAryYC4s?=
 =?us-ascii?Q?oLWYjWcPnw0EXu5ocUgLE1XfdQFxZZUld2GDiKqWCVDI8/Q+ELUuitJd2guk?=
 =?us-ascii?Q?r6KXkFfNfRcxjPys3lTusv1v4GvwX6O8b6MjeKOxivKsf+UTaYB+TvPRFOKq?=
 =?us-ascii?Q?0nVhG8Sg/9xCSrIFiE1t8YAWhA5VxkrWD1JbRjm/jgJem3tv2qJnXVfqsjad?=
 =?us-ascii?Q?t72jdDMzUnVdwnzMqiYLC4RSwaoF7IHIWrLYVSc4/1Ev7MlDERm+v1avsoPk?=
 =?us-ascii?Q?Azi/efzjI3Hc/C9T5fI4zFjbj3lmUKLD2ytu3TdXL9b8N2O/eueDNbgzRw2o?=
 =?us-ascii?Q?SsQGSuGa3k1ilFVpt8UyaJjLx9Nd+PkSfL+RHvz5zZurpz1lTqtR/MezZ6kU?=
 =?us-ascii?Q?Qqs65CP1QkfzZ+C+X6KFd29jSgG+0b+6gRKfz0EIbe7C21SW2FedF64qBz+h?=
 =?us-ascii?Q?l0p01p7h4q+WuKESfPjeRsTO0JLD04mmX8CDKd3Csii+er8r/NVszLXqmvZE?=
 =?us-ascii?Q?wQ6jlGD4HX9GYH5jmk3MUExaRRoYBjlktUjqhn+VQvfMIJTUUuFOm4OiY43L?=
 =?us-ascii?Q?lw0HFTUfgE2GwYP1kOoGBbesrSnCxihOtFcvP7r2bpxsrcqABNH0ElP8iK1f?=
 =?us-ascii?Q?uWv782sNRVsl4C9lIN2lg0cRupIokuj1jrJJVsFHuvVXN+Xzbs+dYR09UVEf?=
 =?us-ascii?Q?RKz5E03M/d33/jUwHa7PwBGjvbfuUOFCWha9E50uL5cbchQFPNN6rIAeIpc1?=
 =?us-ascii?Q?+UsOh1giPbX6Y+KGX4nER/EkPT0P4Gd4IxdNOGwGsF3vcRqIN1cWRN53xEmk?=
 =?us-ascii?Q?XuZkv1lpgY7NRi5CxtsHJ7YCupzO+KaLiSAUJfkSE2ufihZfTn9iWPzxmyKz?=
 =?us-ascii?Q?ANlb2DsnnV6XhyVrpDgsr7tH4Sh2wmB9SMWlGeKliyYFErQoybCa95XqcXqC?=
 =?us-ascii?Q?E68SG8qHsT5iWAtEw51Ydi9vDtCodoGmXzJW++23iie8Mo3wd3EB0Q9c/MCa?=
 =?us-ascii?Q?XWwCHjjuWyrDdyHGWzlvzsj65XZlXBDWRJUFa1lvhFl5dV96yV1Ck5vRBDzK?=
 =?us-ascii?Q?PQsD2aPFWl8K21PjtlRSGRQquIlFTLTiCDveyeH0RLZpOyh6SbbmWjhtAKr+?=
 =?us-ascii?Q?47PSNgxZQxcsttpgrV+nIMv5dpDF+ftIXe3xJMcTkUcemJNF1gKxQvg0gsf9?=
 =?us-ascii?Q?suiEqmR2oX6KUteyp1+0V/RDBIwIyGWShoj5DqOWOTBgmB4EYWcDKPJ1zw88?=
 =?us-ascii?Q?2t3VtUrkoo9W8+fmy7leBpWH+aswfPDOwGrqLQzpnhTQPtzuooy/g6wYvM25?=
 =?us-ascii?Q?gg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <63791057D559F340B2B44F84A011F437@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	wgjJUcVf4TTJQUcJGLKVWfpdoDzdQi4Wa58e67Owhv/dkstba1Lj00bmKkYiZmRZbYZqQYnFzGmUy82efH+IFR+rjocFlA4i1elB+GWRdBxUBOIvN/I3yURZpLk9CvwCBs641QQKY1EoB8/n+Wo1WyCrok/JcrgmgV8IjVXLdbRI/OYZirdpKQkPklBZLLiadIleJfSpa2D9nxe1J8A5W/SrBu3r290yeZgBMX0N9mQg6M7TAxYq7PcIY4NIL8M1rGVNUqfxciXCE9bBAei5t9OMDSFXlE20Pe2KueWBlZc5pinI0v7+DwHOgrtq+iSaunbhBxNJQVoRI0U1lZ+f0AY9MXwe7yWrZMMZRyOrPW0OSulZrV20P3HU2in6JdqXEWHEuYCdRRrTtqHKJuhbG1HHQXuDcY6nNYOdJgxP+aqVdAUvvu8tyRj/gr9ron5EdUhvwvUCDvjNvPGmUCgvGMCH8OTUlzpfmFz2JJ8zZ4YCnms4vlVdZdYBmHJ5Tg4vSxGcD4sAetj7DjfAq5bwq06VZgrp+LNTy1pooB26Lxtg9K4CCDBB74fMrZMt939Qb/iOx1Zp8olEewFABgKfPthts0NkuB/FlU/w+e3IgCmBE2xPQ5rMswpewoIU5glmUfwixF6O/je4J76tbUkT+2T6QApyGGcl6kNBRyNaaap02/bIV1hf4fT9agBfC0vPzBcL4wEyLUoqfZbb6LCnqGXY0f5I2Y0Gs6FL0fUoimy0Ls/uz1/X0s4KpHs4Qnu58kzgCKwzH65XQbh+J8FqLmSy54UrAuJyMNCEokeTt+h6asBwp8AtxfWvCo1BA7Hj62RfPbA+Up8PfHlPbC2aPQc0CJPGyGlrx0dav4kDvpAhcdOK3MkImQ1dVQyIEi/8yeXOo9+gTmk/xIlc9dQnimkq31mrVWCNPCSLrdnOx6c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5134.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 566460ad-d075-4b80-47ec-08db863d6150
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2023 20:43:58.6500
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 13V2m0vO/AetKDGKkdNTZ19skli6OgmU4yKY/Sdu7Wx0jyEwE7w7GtMGs8+NfsH/Yw4lidAYIMGuMIC1fo6UIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6461
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-16_06,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307160198
X-Proofpoint-GUID: lB656NO8k4vxwlo3FGa_bCNd9Rr41F4K
X-Proofpoint-ORIG-GUID: lB656NO8k4vxwlo3FGa_bCNd9Rr41F4K



> On Jul 16, 2023, at 3:39 PM, Greg Kroah-Hartman <gregkh@linuxfoundation.o=
rg> wrote:
>=20
> From: Chuck Lever <chuck.lever@oracle.com>
>=20
> [ Upstream commit f921bd41001ccff2249f5f443f2917f7ef937daf ]
>=20
> If user space never calls DONE, sock->file's reference count remains
> elevated. Enable sock->file to be freed eventually in this case.
>=20
> Reported-by: Jakub Kacinski <kuba@kernel.org>
> Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handlin=
g handshake requests")
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> net/handshake/handshake.h | 1 +
> net/handshake/request.c   | 4 ++++
> 2 files changed, 5 insertions(+)
>=20
> diff --git a/net/handshake/handshake.h b/net/handshake/handshake.h
> index 4dac965c99df0..8aeaadca844fd 100644
> --- a/net/handshake/handshake.h
> +++ b/net/handshake/handshake.h
> @@ -31,6 +31,7 @@ struct handshake_req {
> struct list_head hr_list;
> struct rhash_head hr_rhash;
> unsigned long hr_flags;
> + struct file *hr_file;
> const struct handshake_proto *hr_proto;
> struct sock *hr_sk;
> void (*hr_odestruct)(struct sock *sk);
> diff --git a/net/handshake/request.c b/net/handshake/request.c
> index 94d5cef3e048b..d78d41abb3d99 100644
> --- a/net/handshake/request.c
> +++ b/net/handshake/request.c
> @@ -239,6 +239,7 @@ int handshake_req_submit(struct socket *sock, struct =
handshake_req *req,
> }
> req->hr_odestruct =3D req->hr_sk->sk_destruct;
> req->hr_sk->sk_destruct =3D handshake_sk_destruct;
> + req->hr_file =3D sock->file;
>=20
> ret =3D -EOPNOTSUPP;
> net =3D sock_net(req->hr_sk);
> @@ -334,6 +335,9 @@ bool handshake_req_cancel(struct sock *sk)
> return false;
> }
>=20
> + /* Request accepted and waiting for DONE */
> + fput(req->hr_file);
> +
> out_true:
> trace_handshake_cancel(net, req, sk);
>=20
> --=20
> 2.39.2
>=20
>=20
>=20

Don't take this one. It's fixed by a later commit:

361b6889ae636926cdff517add240c3c8e24593a

that reverts it.


--
Chuck Lever


