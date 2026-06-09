Received: from refb.tmes.trendmicro.com (refb.tmes.trendmicro.com [18.208.22.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152424A13BE
	for <patches@lists.linux.dev>; Tue,  9 Jun 2026 16:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=18.208.22.186
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781024286; cv=fail; b=Wb9nPx3v8rDIgOe9BOcr2di03UPtFXlEJRcYAwBVe/I1Megdb6TlkeMYNTjGU4rMiwe9wvs2tip64otvqjEmK7XXQUa0bu3lxBka7aafW83sGuyKSAMeN6Qekeq9tzjNZMGLCMiX8cFsEUSvsdIkDDizPj7262OPkJlFgqKZu/s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781024286; c=relaxed/simple;
	bh=2HfiT7L95EaM15kV/+t1NVHqVkVMIXqI2jTeH0Iy2aE=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=K0fTEY0A3a4/9d/Ctp5PLUkJnC5u53TnE7QHKt9KXmEC2r23sHxaBF3C9aX/3AzxCAlX/6y646xCXnEeH9rH4wFXTPv8uNjeNugfX24mtSfNz2ubfnRssf5Nq+EE+tcno5BMmQQUIUm34iNfnlsQHPC9RIL89sNw3cLfLSmmDxo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trendmicro.com; spf=pass smtp.mailfrom=trendmicro.com; dkim=pass (2048-bit key) header.d=trendmicro.com header.i=@trendmicro.com header.b=JGuSPSG1; arc=fail smtp.client-ip=18.208.22.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trendmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trendmicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trendmicro.com header.i=@trendmicro.com header.b="JGuSPSG1"
Received: from 52.101.57.13_.trendmicro.com (unknown [192.168.19.66])
	by refb.tmes.trendmicro.com (Postfix) with ESMTPS id F324C1049DF93
	for <patches@lists.linux.dev>; Tue, 09 Jun 2026 16:05:57 +0000 (UTC)
Received: from 52.101.57.13_.trendmicro.com (unknown [192.168.195.221])
	by repost01.tmes.trendmicro.com (Postfix) with SMTP id 80C7B100006C5;
	Tue, 09 Jun 2026 16:05:51 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1781021144.370000
X-TM-MAIL-UUID: 30252ea4-a980-4ef2-a97a-6db7b8ad2543
Received: from BN8PR05CU002.outbound.protection.outlook.com (unknown [52.101.57.13])
	by repre01.tmes.trendmicro.com (Trend Micro Email Security) with ESMTPS id 5A7CF1000030D;
	Tue, 09 Jun 2026 16:05:44 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F494LyUmsEZ884qV6dPgrX449lB3Zm/wbCId04x/98LVZ0+txEDRJLXWscEqeZL5x8EdOil9EjUZrGVhPKMFxNkwzgmKWpVmc+7a2y0E11zzezX/o7XsGqiB9syZ0OCHob629CDVd8sYgw7XbZfrfHnEWoS1ffoZe1F+anOZv0/CNuCLJy7rJ7V3NgJ4q7QydoWqNat+gHPSBu1Qxu4uLJpSPXeZ22IbI49AswFtaLvBiI7MApq1b8dHKhaP+LfVIiw52bJDkU2KFGuykT0PvuAFln2eLDj/EscwJQw+Xz+oxP3DOj+G4eAbvWYaNO7KRd91GKQCPCce1aNI+3k3Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v7wYQbLmvrd7EUOXD3ayni/c3EfAcUELUT4+r32bzZc=;
 b=SLyiWWfIPThNoJVSY2SIC49yYi2JjjlNo9JN3a0BtqK+/KdCzKWzojUE4eg/q6ZaQp7FeuTA7iALDe5opshrFE00I6aCIe9ro2DDOmNk/grrDRuhf8bcX61tEdH/jQbzA1TF2LvM7pnyQzar7Z3HfCX1YgLHTRfP56zDrIcP2LEoLKwA7h2HBPq7BgKAGPBev/vnsE3hg+5KYFyOPMdUomTCed7Q7lgW5UaTvxiZL6NCfyRYrc9m2qBpCDHhH4y8Xf5C38U6SNoRQjyPlUshh88AlLJMOVsMZnFIW36utnmLSh2GAhcrOZPKnHgKhFmB5dloQoDIkAX1BMpmvjKgiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=trendmicro.com; dmarc=pass action=none
 header.from=trendmicro.com; dkim=pass header.d=trendmicro.com; arc=none
Received: from BYAPR01MB3830.prod.exchangelabs.com (2603:10b6:a02:83::21) by
 LV2PR01MB7549.prod.exchangelabs.com (2603:10b6:408:17f::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.92.13; Tue, 9 Jun 2026 16:05:40 +0000
Received: from BYAPR01MB3830.prod.exchangelabs.com
 ([fe80::29c9:1f31:48fd:8ccf]) by BYAPR01MB3830.prod.exchangelabs.com
 ([fe80::29c9:1f31:48fd:8ccf%3]) with mapi id 15.21.0092.011; Tue, 9 Jun 2026
 16:05:40 +0000
From: "zdi-disclosures@trendmicro.com" <zdi-disclosures@trendmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, Victor Nogueira <victor@mojatatu.com>, Jamal Hadi
 Salim <jhs@mojatatu.com>, Jakub Kicinski <kuba@kernel.org>, Sasha Levin
	<sashal@kernel.org>, "mchehab@kernel.org" <mchehab@kernel.org>
Subject: ZDI Vulnerability Reporting Issue
Thread-Topic: ZDI Vulnerability Reporting Issue
Thread-Index: Adz4KTxfzLoTs9+TSUiXQPmT20nvIw==
Content-Class:
Date: Tue, 9 Jun 2026 16:05:34 +0000
Deferred-Delivery: Tue, 9 Jun 2026 16:05:11 +0000
Message-ID:
 <BYAPR01MB3830E81BEC422B76C4A8699C801D2@BYAPR01MB3830.prod.exchangelabs.com>
Accept-Language: en-US, es-ES
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_fb50d67e-2428-41a1-85f0-bee73fd61572_ActionId=05daadba-7a1a-4e7a-a75c-c15a4967c4fc;MSIP_Label_fb50d67e-2428-41a1-85f0-bee73fd61572_ContentBits=0;MSIP_Label_fb50d67e-2428-41a1-85f0-bee73fd61572_Enabled=true;MSIP_Label_fb50d67e-2428-41a1-85f0-bee73fd61572_Method=Privileged;MSIP_Label_fb50d67e-2428-41a1-85f0-bee73fd61572_Name=Public
 Information - no
 protection;MSIP_Label_fb50d67e-2428-41a1-85f0-bee73fd61572_SetDate=2026-06-09T16:03:59Z;MSIP_Label_fb50d67e-2428-41a1-85f0-bee73fd61572_SiteId=3e04753a-ae5b-42d4-a86d-d6f05460f9e4;MSIP_Label_fb50d67e-2428-41a1-85f0-bee73fd61572_Tag=10,
 0, 1, 1;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR01MB3830:EE_|LV2PR01MB7549:EE_
x-ms-office365-filtering-correlation-id: 77f39b1d-64d3-4fbb-c58b-08dec640f3a5
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|18002099003|38070700021|55112099003|11063799006|56012099006;
x-microsoft-antispam-message-info:
 oclJFRDHgQ5V+b5oPlMCHnF6xUNnJC71bHnDshSttNzdyHFqEKlyI1Rp/hRve7g2JFZAj7eBnNouUUp05sqisyV0NBQK8R8mxKc0yd9jzksUBw0UCPlCRdOoMKToXo5AH62qNEvkVQBpOEDQioeaPdpPUZ8i00/CqJCi9K1aG0YwASvacInyBRyRLB0sTTu0cViMKXejhKAhgae9/vq6hHaYLggu3gZBhhqf1msQGNxSVlTnkgTANvEeQUCNAqC9n8Y6zY0O6OAWhPqg+yOQtDG9WLntxRMQ83GTyTJXRk1hyJGfptA7DeCiCjoMP8ahekXAE33d3l/dDfCdpycWICDY8OKIY/lctAZKRZuu7XnFh6P0RuyVpxr0h4N3K/fzVCGUQvgoRbiLFspJqNc0j376TT9JooTIQ2nb32SWEAbAYVI1QdfKRP6c0kKLweVZhmQrUIwSkzbyz8G5boQYIejMmA8YVxN7LOXD4Vz9ftn1LiWr6v1WMFJZ/pmEnKrHiC4PhG7oJnxPLKaj2MaJJwYH+fpQtLMYFsmtvY2z9eE9QkEDTJL6djoJMmVK/AVkd/2mzg+C+bivQDFbc1ZKMzjjbusvrfDiW1rBUlaDPI5dERggLQcOLyiGyK8PTlQpH2DNMevgFqRTxC98rxoZSfns18yxvcfalQnMzFrshV95pWWjfxEHTJzW2q+XRpOjTeq7+6Z8v7ZeiUcUVoINQskTR78G6L+g/aeI4B+3NkqxO8xy1Fqi+bF5XT5KNtK6
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR01MB3830.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(18002099003)(38070700021)(55112099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?iorzNHmiTTe6Q7LBo4lvL97cqPkHPEt8gS7Tvp9zuMr/pXjA0b2ntZRJf2Dn?=
 =?us-ascii?Q?jM5DikEnFvZM894KMEahlIqLVgldjhHQz6iCla0bDHyazstWI4LFpaqWdu9U?=
 =?us-ascii?Q?s/egz08mVM4GU0vpmhKYn1k/1OrcdWpWthnfKB7BD6IIznML6kkvXyS4ZZPS?=
 =?us-ascii?Q?2Vb/uLCHals8njdRPS0c9yn//Wg0FTF50Bp9XygcB2NP6l82djAxsoPKlKSa?=
 =?us-ascii?Q?yN1LYRmk9qewKgFquDR8Xrt1Uf/VPuRG7WrQxt0h47SmpWstM+uykFBh2Kvt?=
 =?us-ascii?Q?QKTiQDncSvW67Z0natrW5zueOvHnLaTLZNkatWuTSWA97/yjlYSeePn+vhuU?=
 =?us-ascii?Q?SYo8t81Zxw5ylXtu7Uc4frohaNw5hL0ZSmhWGoM14yLvdrwzQaV/VxNmYugC?=
 =?us-ascii?Q?2+z9wOIun5iBKfOuFpl2lgvlJSYndM79D+cusNqfEB6jnOXGENQYzHuNeYNk?=
 =?us-ascii?Q?Xjk2B+CnebsvXZH3XYlVdLFvAt/rtQkJL6VJ9Jz5zmkHDjt/0wsLhrbCLTqV?=
 =?us-ascii?Q?U+amxF3CcAlpQmCsS+OsjnObR/l3pCsUtOhdUIOuuDz2VGxvh+Cs2lQRNEII?=
 =?us-ascii?Q?VxwLDPigRy6zqTeu7Tnsa/CnlmU54eibGIBaordZIIxcZh0R9IsJNvsBHk6R?=
 =?us-ascii?Q?VAVPkOAa/UpjRsxLcQDFoM3livQhfNe0AlJ/PAWVgLvb20ogLPxx4FHBCZyz?=
 =?us-ascii?Q?+McIYRHD1E5uanJHt5ukXK4/2n57onIiKNONcGpAADKJb8vDbXVAbofBdhui?=
 =?us-ascii?Q?dn5ec8tL1LqgQ+hwFkN/TqJNjHcXoTStyL8e+t/7Z9u3QViQuU+mgYrYiTg3?=
 =?us-ascii?Q?YoFlE1QEO8nSxGe4ukba3+8xRVwVBLle4A98k1gWQwZE75GxTn1x1Q55ieTu?=
 =?us-ascii?Q?JVWEmb0uHgftBkmSIO8vdK/WdvkZhiEa3zNZI6jH8m0qoQ1BTAj1MGxAj6QQ?=
 =?us-ascii?Q?BOh6vrm2S9tH39nlbFwxIlFXRv+FqEArOMMN773M2z3W9U3LuKZxtIx101Ym?=
 =?us-ascii?Q?6anUpbvqGwXSeVwA1pglTPr6zIV+Q7MsOkEyyuJQ3+clcCCKcyH0KMaw2xGT?=
 =?us-ascii?Q?Sh1oixzEd0ElryOV8ZZrECuy1mq0GxTN8+70sPZ3CB/IplcY0n7hZTKG1atU?=
 =?us-ascii?Q?440ipkhJ9sgMzNckF+z6hlGr1EdcO/p7JJ9y7OTHUPlPL4TufZpDCK4FLoHL?=
 =?us-ascii?Q?iYcZqwi77Vb0FbJvX/WUSCXn4tuETogcs1Ga4Eu3j9M6MjaQzBPuestfH8ED?=
 =?us-ascii?Q?tCrZOPlTu19nIf6OlzX0R1TlCWg91k3VkrHFXIBhL3ph8ycM91NWUnJz/CVs?=
 =?us-ascii?Q?jYW++RJCYJACMZPE2XNXytWvd/CPImSfcI4HskBSh+NAebRFoY/jmOV6GkvN?=
 =?us-ascii?Q?d0dIR8iY8svZJ2QTQhmH9fY9oOoL7Aw9YH+UAwlh+TyqFOGcynhryf1CCE9V?=
 =?us-ascii?Q?/yq14xXYxrGah+15ReNdxOHxVgU89KyfEfH2kkJd2Bg4asuwuHoXC9unMcS/?=
 =?us-ascii?Q?XnHBrXQPEVRB4q5Dml9dGdwhK3+o5ZQvCLQcyiCC4AKnqICthePuQaoh6DcF?=
 =?us-ascii?Q?b1OPosI2NUaCNxNQQX8vvfRnNHJZJ5vawin3H+FItznYZg4Ml9+nz2itJdPq?=
 =?us-ascii?Q?kKWbNQupuLs7Llkr3AZiurl9AXsT1cADx/Bl57DMujWrXZY2KWabMH9yXwQo?=
 =?us-ascii?Q?3VmZEw+vyciEcab2uUEyKPfIvRzGwqeNSHiVs4qmeBPpVk5s8Uc63jsdO8oT?=
 =?us-ascii?Q?OW3E6XxGHuwuibJqJ2oYCbUH1nHAWS0=3D?=
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	gExqk5pKNvLoxY+0RJWtp76PoRfVo7N8wTJcmVhBwauABvA73GkqT2t+NAnOumNRzCkxGCpD56iX3hSRv+Nj3fnC/7aHzue3UmNw7Us1xMIM1A1OUMTQv63TQpPHLcCMnhbHXEIFfqdScGX4eApYGPEHrdx9u4628sy/tLQyjQnk+kBwOs0IXWFm8NfqLYCfDP0QTRoW0eSkdbSfy91JGrnp8xx3dzBBK6DEOpjLMGxJMjemJDNt69sRcR57K0w4T8sWGfZPhETeInspz7eEbrIs2cpfJvdA4Zv/1V5a73/ADIZBGbP64FaJhRDa+q0ppjFfRBqJZ2q59x8Ia5orew==
X-OriginatorOrg: trendmicro.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR01MB3830.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77f39b1d-64d3-4fbb-c58b-08dec640f3a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2026 16:05:40.0458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3e04753a-ae5b-42d4-a86d-d6f05460f9e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZF9EaHVZgIkZcgc/fKdY1E1QOUEgYzbZKPo+FpOUTZfeOFsGoXpDtFwbroLIs+qIPqFo5NT0ms/S1vqE9cN8UUduijR3t/GG5wGW3laQd4Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR01MB7549
X-TM-AS-ERS: 52.101.57.13-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.2.1014-29996.007
X-TMASE-Result: 10--10.363400-4.000000
X-TMASE-MatchedRID: BWuXnswNqSQ9AUcVR4lIKRFMO+gC2WCpXiGiRlIav8nlNADTSrHglXao
	MnyWHIS/CHmbB3HY98Dk7pNGkEatyX+nBCJJBAhlpJgUXPcinGTJ+MXwxLqnFUFGZQj4DiD813j
	orcAcgVPYeXOEzfM22WeluFFVwfPOKiMPzmN80hl8WXazDEa9tZGzew1Tw8ZI0x3XNchZstCiWL
	hmiI4dPxF13aifoiBPzVUR6EUskvth/eihfOU9251L0hw+BeWKqO3UCvymJq13CVCJyxA79gg1E
	EshzuUS
X-TMASE-XGENCLOUD: 4fc0b145-c0d3-4f04-9bbf-676b9ad1af7e-0-0-200-0
X-TM-Deliver-Signature: 4CBD0C0C2D8BABFDDBEE87BF2F454295
X-TM-Addin-Auth: W8G8k15301pxMJJAEINSfXpHj8ZpWM18C0jkiGy8oYCvmnhUhzhReGDJ+Cf
	jGiw8K8b52AUOVdu7QTq+TqhKEe1Rw2gMNlk2DrtBZpaoCc5GhJo33q6HYPbIOWb6rHynX5zVvm
	l7TijeAIOwiRu/KZm84QC09tw5kaHgzS8FIy1K5TSPxa8XzOIX79sepKW7ppEUGj8tLkaThhDue
	yJejZg8grXvCnY5skWIdNLXV/ZeryZ3D/eqKd+2PoRrZRbZlqf1LqbR0bViTfRzb8wjdmK7fl+u
	fFQ9UqmkALPHVLlTmO0LsBuYkIDh2PUvDb++AmWvNLWW3SGMjwyd5weAow==.l0e7wfDRYZ1Pay
	EUlu3mDI6oEtmg800voZJOmjmlotfnc06sF2+1erx11PO8pTGy7rWaNJHTu33Yb39V2Qn7m5TrQ
	hOl8i22bTE1aTMQNEIzK0OKvu5UbuSln8UBmN2MVr+krSa7GL1stf1ataEMRgye2KnOBCbm4d3/
	Ga1G8HffFpow9rM6NgPo9sZrvu+CCoT5jGKRHcnCYTHSbM5Gw9qRMSJPO32AA/ikbPxBCL75N/r
	iCUUP8jCIZxe2fXFNS6jN4gRejmE0qfpBEkTyEK85oaUESk3+8qBn9ISBAEdm1xRHKY6fkoVYcP
	PQ2aTL5qJJPsZ+Tkd1Zoz4UXukAQ==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=trendmicro.com;
	s=TM-DKIM-202604108455; t=1781021151; x=1781193951;
	bh=2HfiT7L95EaM15kV/+t1NVHqVkVMIXqI2jTeH0Iy2aE=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version:From:To:
	 Date:Message-ID:Subject:Content-Type:Reply-To:List-Unsubscribe:
	 MIME-Version;
	b=JGuSPSG1BudSwe2WAOp6auQVXn36XOvL7TMk9YVAq4OIyXzGsuBFG3/DHeu9h/z6u
	 lsTkzkEKlDIigSbyDQuDQvswgm3Zu5EQG3OXua4FcintefLPVKSRnzkUZhTq70ma/I
	 UpY1lnRRWrgiYj94J6fw76gutMKDLMoDSIpKdw3kPiqoY2OdY0c8tZh+foamTne1wC
	 R6X4wZyo1mXjeQB/mLUW9zWZNgK/QXPGGlXIM8yn+jAeVH4f3EvrmkE8t19kYiL8Tu
	 2ATLRhYghGrkntLhm6NDuSZDS6ou85AJ6AV6gQ3kg0jlfW0HJ87UWkz59tQxhrGh/d
	 9v11FTYnOwSfA==

Hello,
We are currently experiencing issues sending emails to security@kernel.or=
g. Can we send vulnerability reports directly to the folks on this email =
thread for the time being?

Thanks,
ZDI
TREND MICRO EMAIL NOTICE
The information contained in this email and any attachments is confidenti=
al
and may be subject to copyright or other intellectual property protection=
.
If you are not the intended recipient, you are not authorized to use or
disclose this information, and we request that you notify us by reply mai=
l or
telephone and delete the original message from your mail system.
For details about what personal information we collect and why, please se=
e our Privacy Notice on our website at: [ https://www.trendmicro.com/priv=
acy]

