Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C9A15AD3
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1695213606; x=1726749606;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version;
  bh=p5oj3EZNAMvyw8KfQKIm2PiydFWZVBoWM2/kECtqgSs=;
  b=AcJanwO/iKtymMsx5kgIsQ7g2dpSQYDtDkc3hDH8W9qULkwk7g/FUD0O
   ZIfhM/bBY4+XYGYKLMAg3SWOfksm5kMOSRCL4SHSz9PfUSJaMCUugm4NJ
   j20uXcV7wBtXUsoDa5Dyuu8+oFnjsuYOetnsWYXu9IfJBjg2NOCMqGysy
   vs6+4GbsgwIBXxCG+Zbo7B36iqyILncLWMolhQOegzW0q086/iNe51Du7
   QzAr+XOmxjZx4CRUZH5Up8DegZIbA72KKtrSCUIjvK7L+18QA8iU2rSzy
   KKVmv6EvM6mgo2CLlkhV80nkNtWtAnSK0kAS2I/YuupucDJqzJIegDFwd
   w==;
X-CSE-ConnectionGUID: vboLeoqERWaEFCKfSC4JvA==
X-CSE-MsgGUID: qwLHtcupSVajgjP+VJT9Rg==
X-IronPort-AV: E=Sophos;i="6.03,162,1694707200"; 
   d="scan'208,223";a="349733594"
Received: from mail-bn7nam10lp2106.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.106])
  by ob1.hgst.iphmx.com with ESMTP; 20 Sep 2023 20:38:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SMzqdBeZ+2Jqgu+o348Jvydv6iVBlxfrOCk7OxZFreWbfh5xu7gGQI3WHQS0yntVC9mBqc23B8RqInhofZC5awK1rBk+Ho9mwCHJQlHsGYeeqhVeRf1Az8OrCm62WYBUdmTYMAB9kpMOEPojEXYIL1nEt+T6K5/EalzTwB7krOmkTHAwwicOH+QSJOrvDv9ykDAfMZ1ufV7tGGFNdLV1VSfE/XT1SsUUoEGs++fzztYCVklyTYIsiuJ/o7rcuPEV+MDV802x3JM6whfunBrPf9tVTTlQnrLqdU6xc1/b+AqIuiVGySQgV0Tie5qsbsu9MLCxL4fx6PZWLPgoWM+w4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4DPmDUSfdIpAo6dDfz1QDWF1FUMLg8+6T+5oMj7lZV4=;
 b=BIq3RTkgyOdUkc6GpKc/lcXb42oWkRIUq8PFjcMiR83wT0lywRp7KhS1tLG/sck08zsDkNy3lr5iUChbgygrknvSnKNo5QxJlMm5bUnGaujniSrTmqtoOugmhk0R5C/fGgnV7NgFujjVdpISkXQKnuLrIZJmysnj+R6D3W4B8ekvAzAxfmA2xYDGec6amtC9OKeHCWMuxtZ8WgDr+NUEM3HUVUXpqCmznsIscgBo2A8u6dB47Co42hfI3qFHGFohWzbsHYL3Q5YFLVFxkPlytagWbUCen8ZCzs3977el24134I3spB3+eYmkh5IiBKEcNpLhEuaKSEWlFDkeiL6WnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4DPmDUSfdIpAo6dDfz1QDWF1FUMLg8+6T+5oMj7lZV4=;
 b=r3uT+hcn0AUUSoNfGyjF6dQldOPNBx8SNeB8UnIRuECd+dzf8bjojK2Gx3E/TFrULSAXp47x6cqtWFohM2lujRXRkqDfwsVdAAYAOyjgG4SV6lKkL23sLDhCroOmJ47Zj25suYionIvnDzue+0Rf221folnbKrW5pf/sHvn7OdU=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by DM6PR04MB6313.namprd04.prod.outlook.com (2603:10b6:5:1e5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.13; Wed, 20 Sep
 2023 12:38:50 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::59a:f2ee:fcb1:4eca]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::59a:f2ee:fcb1:4eca%4]) with mapi id 15.20.6813.014; Wed, 20 Sep 2023
 12:38:50 +0000
From: Niklas Cassel <Niklas.Cassel@wdc.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Hannes Reinecke
	<hare@suse.de>, John Garry <john.g.garry@oracle.com>, Jason Yan
	<yanaijie@huawei.com>, "Martin K. Petersen" <martin.petersen@oracle.com>,
	Damien Le Moal <dlemoal@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.5 158/211] ata: libata: remove references to
 non-existing error_handler()
Thread-Topic: [PATCH 6.5 158/211] ata: libata: remove references to
 non-existing error_handler()
Thread-Index: AQHZ67jn+/fBSKNXPE2keXpYKNsjJLAjp1kA
Date: Wed, 20 Sep 2023 12:38:50 +0000
Message-ID: <ZQrn1rae3Y55/1DG@x1-carbon>
References: <20230920112845.859868994@linuxfoundation.org>
 <20230920112850.780030234@linuxfoundation.org>
In-Reply-To: <20230920112850.780030234@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|DM6PR04MB6313:EE_
x-ms-office365-filtering-correlation-id: d368fefd-aabd-4bc3-77b3-08dbb9d68a8b
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 xRpv0rWd9rNXrQVrsRGlpgFh9b1UzIZAf5OqNSdAaBn8W1YwFaIex0X5FILAyARGEWnSolETlXeYYJGuuZD/DPe/4u+ltxMIufzY41GuWZ/Y2GRUR7blVr0KOZu9t6JbDKUnku25tleJGbcmrimr0HtffjY9zNESdvW/3F0tlKXsQGNCqM/JKP6avrjm4Z3SR8LgF/ZdPQ2Z9G1AcAB5hUg2cxDYl4ESsaIo/5jPuOqRBim2udrzBqqC8tQ0765UOVLz7WT4l5ksbu1f6Q+h5iZPvdALHn0g5TP/wyEZTFJpR2M2YoXY+wnfzWbnI3c9qHLy9YRpwvIWt0QV5iK1KbmFhzE2HH9aMnIJ/66feV+nBK5KPQtqwp8TVxQnr6DHO64HzLsy8x8HGVTF3Xppu5z1z1KdvePnHhr0aulm11H0ywhRdSBw3KBqmgjUjh01qdfxKzslEuPzD0TYb92XFBNTQ3kqbg3TcRibe7OuzXETBFem4zZMT+jLMrBSkivIAtAQut3GNdo0Hxb3sfjoCjefhQhNptnZTUpw5X4likvCnI6eVhZiAtO+wXyIMxtsGNn+dXgrWC/DBAhSmZY3v4PdIa58CSNt+osHvM1cw59NfoOYJksqj9uOjkMjEIwl
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(376002)(396003)(39860400002)(366004)(346002)(136003)(451199024)(186009)(1800799009)(6486002)(6506007)(478600001)(6512007)(5660300002)(33716001)(9686003)(26005)(2906002)(71200400001)(8936002)(41300700001)(316002)(66446008)(66946007)(66556008)(54906003)(6916009)(76116006)(66476007)(91956017)(64756008)(4326008)(8676002)(82960400001)(86362001)(122000001)(38100700002)(38070700005)(99936003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?MBfE03EE1qIU2yaqQ/2PttO4NBrDd2nzYPFO5pDGO7982bPLalJIoxAYDdZM?=
 =?us-ascii?Q?uc/4JBLpid7oDb1sNOqFinX4WqUwIyzu9UOlykcpB6afPsD90Au4uzcjZl0F?=
 =?us-ascii?Q?OnGVRdIQ49syf6bOWktE4UID8NjfZ79OXpVZV4PmE5l54N4zmY72j/O7MqgN?=
 =?us-ascii?Q?t5XZKCSl5oFoPlvZJCaHj7HdcWnlSmc013iGeQua4H5ELW9J5Y+XcbvOcJTh?=
 =?us-ascii?Q?z+rfvrEWzbC5Q9iYFbRvSQFWppx86mFnmwY5GtOYhHI3DqsfAruQSag9D+2R?=
 =?us-ascii?Q?AxzEzB6EJ5JsUobGe9JK4CdPJrMGX56+fTXnvG2Y9bNi2r/F/aG/vNJiysan?=
 =?us-ascii?Q?b+Zn7fvvg2Cor5GqYlVclPcnf5oYIASPS3Pm5cSrmyR3cjK7O53qwLoXQPa7?=
 =?us-ascii?Q?89wGWDpWSAe10qelVX6Uw8SgpXwKw3JKSIddXsJ4UYCK6rNLhxnHsOBUMlku?=
 =?us-ascii?Q?e7ZAj2NCkY6WCpbvz+efWC6nNpY2STnGolYyFqJ7HHldUrhyIz92CBBk+i5r?=
 =?us-ascii?Q?I59dP2uTFVW/0LrZelwaVAumP59WJ+MYuxYR8/qMsc1BzLJLHFyCvCDa5em5?=
 =?us-ascii?Q?+Mu7KjfTuGl3MmpFU/15jLW9Z8RcnW7wI/iX5S2MhwkOApoS744fEO90vQr9?=
 =?us-ascii?Q?J0Vc4HYpfjHcHhR3T7rVj30nwOX9K7bZMXttrk25NuL+2u28SUdFQTWfegui?=
 =?us-ascii?Q?NvnpZuQcN2m+LeVdadLYZDu+AZIu8um2NESYGcqE5Yk5RiEbGZXGJGGA8PfD?=
 =?us-ascii?Q?/kMnnwNmY7L7pVnhILcPTT9vxmseuxml768FjWHfQzzDO4l/FEg9cIln/6Tr?=
 =?us-ascii?Q?zbjJZpzu437jl4+18S+FN00ANP7Zz36fedYwdLWVHWJ5Z9mkgNF1e74mbAx0?=
 =?us-ascii?Q?Np+f8rOfsowze84JgGwatujUt5ulhYFpFZil1Xc2lnVe4ptX2Fo0SKikBCnQ?=
 =?us-ascii?Q?xTG8C2xtDws0aiGD+5TsPEDJgbhAYmMei9V6XDZib62NrQLKgPsJVa6TcJJe?=
 =?us-ascii?Q?VWru1UFABLxKtCPvUl2dnsMiieIF93FLurHQ1J2Fw0wJFfMGy57fC/ADddBO?=
 =?us-ascii?Q?rnu34IgOFQnlVM/ETpp1YoMXBf4clsFtRF+rZeHEldR45g2hoBkgkgzTAztd?=
 =?us-ascii?Q?/cegwUjB7Pc6298hLidZuqF5tzAK3FMwe6QHscFqmIe4BtRyJoGfcjGr4SzP?=
 =?us-ascii?Q?lf+xp9PLgk6qaNyt53nRKLZQ/AlpXpGi/wop6+nTR/W26fhcowHLPi5cQMXF?=
 =?us-ascii?Q?uFhuoQW3vTa7WoeiFsPHGlcic3BB3c8E8GfDqqqDTvBvF1mfWCGIS/jZ5Yzx?=
 =?us-ascii?Q?vx1131Ym2E3dDS6rxV1XdCtu2c2UZZ1jrgCp1GyhavGyL43G7JfdUO+PY9x/?=
 =?us-ascii?Q?j1+6/yrFC3UVOYZZGVDAeyK3ttz80Qr4WEyIx/eYP3a16YmW2BQ9q1y9G8da?=
 =?us-ascii?Q?9U0UJ8TrKTb+92VuwJP6JC6EcSbYIxOCpjOQhxEyvfZhOPoLjZDErY19YAJD?=
 =?us-ascii?Q?Zko9CZd7XbV0JCDVeouhn5RR+A3i5WeMm2IGUhZwwlZrxid8w6PXygvpiyIP?=
 =?us-ascii?Q?O5MkC1h7Soft29QM8z8MJ0OlTKi5I3jZmepzaim/9mc9qk626XLcCir2CG97?=
 =?us-ascii?Q?eA=3D=3D?=
Content-Type: multipart/mixed; boundary="_002_ZQrn1rae3Y551DGx1carbon_"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	=?us-ascii?Q?9z4e6N0F4Rl13EPv9OChvRN5Tqz4pgN6Kpgcy0YIrRfGHm7mRBS+XkzZFhWX?=
 =?us-ascii?Q?aFyqLjuJAG178Pjb/2M6DJArpBoHSo0ZlraBLp5DkP1gLvDyYcbxnEdTGip3?=
 =?us-ascii?Q?2ioUD8hNKJT9t7ktQbY95yrGfVr44dlHM+2d3nxqIfm+Ti7a7e3lsxHyWRq6?=
 =?us-ascii?Q?hgnbhK4b7NQOO7fbQjel5/icPLHgQ39yYSBHXlUV55G4T4I5WfRvKqlMu6NT?=
 =?us-ascii?Q?YsebG3gJEbyKfLVrHm0ju4ovjBnUNrmrnaiebJBHSHEcq1dkv/GXPY5smTYC?=
 =?us-ascii?Q?NP3HKCQAOMRiBVx27urVyq5xmj44CuQFu9DNxdzQ5/STrexVRI+j13gl6OFu?=
 =?us-ascii?Q?z4gvG307Ka1kgIauEieUlVGn9gzhhz3qyQcoDzqwF2ttu1uUApjG9sdSp1aX?=
 =?us-ascii?Q?pGSsquEC9GEtfxLzTMjdKonqhYGHSTwuS3+mPBJWkmqQ92nCeS2tgLzqbnaW?=
 =?us-ascii?Q?WEWYgKEkbokrfTk/z1a7yxOd9qh4JInf3HrwwMhFeRUwpwZLLt9QHjtImtJ3?=
 =?us-ascii?Q?7TBawvFYcuWkUVhDYboDYtl/H3RUryYbr5l/iqS8GclFogcAssy4CEcm1Qy1?=
 =?us-ascii?Q?bSW78BkeuF+HzcMAGPedz117FgqzTAwM/PXOYZJBllYn/ha0UisXfX3lvsvY?=
 =?us-ascii?Q?H0yKQmFVFFCl3G7p4IaeCfNj+LdHegXGLyUAQcqrFlpcdDs9IdzS9PazX+iJ?=
 =?us-ascii?Q?Onn7t3lKnfnxFvAeSQG0piThOTmKtixMqHKVpW4V8/z6qyV3kW/6MMI9HbqE?=
 =?us-ascii?Q?eqEEoGo4H/VBNjtWtLxPzjq+vpyQenb+56iCF38DjTMCIQMz0OOyBJbliH5q?=
 =?us-ascii?Q?Na/ZJ0BN63/bFb7dDPvOdY/SipiHuZ38gYEqLOsAyzi76zA7FA8z5+nkKFSt?=
 =?us-ascii?Q?vP2fmu6BDkXo4oxVj+0vj1oTFafrf3dmvl8SBqFgEJaLs2rS2pZFpNTS4Kky?=
 =?us-ascii?Q?B/PYgiOUjSEi9oUSxoK1yy4SiYZBQYivFiXUqtKebms=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d368fefd-aabd-4bc3-77b3-08dbb9d68a8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2023 12:38:50.1029
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 77GpxtTHbgDDh3Pwf6D1YSiiWiIAvUcWreuKEvQbKSUanK7bopELgqZ1d+mlo67ESskI+TPMESXKd+QwLLGWQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6313

--_002_ZQrn1rae3Y551DGx1carbon_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2416DF8C680DE94D9714A7C0B5BAE9FB@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 20, 2023 at 01:30:02PM +0200, Greg Kroah-Hartman wrote:
> 6.5-stable review patch.  If anyone has any objections, please let me kno=
w.

Hello Greg,

I don't think that we should backport this commit.

While the patch did apply without conflicts, it was part of a series that
did a bunch of other cleanups as well.

I think that it is best to either have that whole series (and we don't want
to backport the whole series), or none of the patches in that series.

(So that at least we know that we have one or the other, not some half-way
cleanup that will only live in v6.5 stable.)


>=20
> ------------------
>=20
> From: Hannes Reinecke <hare@suse.de>
>=20
> [ Upstream commit ff8072d589dcff7c1f0345a6ec98b5fc1e9ee2a1 ]
>=20
> With commit 65a15d6560df ("scsi: ipr: Remove SATA support") all
> libata drivers now have the error_handler() callback provided,
> so we can stop checking for non-existing error_handler callback.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> [niklas: fixed review comments, rebased, solved conflicts during rebase,
> fixed bug that unconditionally dumped all QCs, removed the now unused
> function ata_dump_status(), removed the now unreachable failure paths in
> atapi_qc_complete(), removed the non-EH function to request ATAPI sense]
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> Reviewed-by: Jason Yan <yanaijie@huawei.com>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Stable-dep-of: 5e35a9ac3fe3 ("ata: libata-core: fetch sense data for succ=
essful commands iff CDL enabled")

Yes, it is true that
5e35a9ac3fe3 ("ata: libata-core: fetch sense data for successful commands i=
ff CDL enabled")
does not apply cleanly to v6.5 stable without this big commit.

I'm attaching a backported version of that patch (which is only 2 lines or =
so)
that can be applied to v6.5 stable instead.


Kind regards,
Niklas

--_002_ZQrn1rae3Y551DGx1carbon_
Content-Type: text/plain;
	name="v6-5-0001-ata-libata-core-fetch-sense-data-for-successful-comm.patch"
Content-Description:
 v6-5-0001-ata-libata-core-fetch-sense-data-for-successful-comm.patch
Content-Disposition: attachment;
	filename="v6-5-0001-ata-libata-core-fetch-sense-data-for-successful-comm.patch";
	size=2885; creation-date="Wed, 20 Sep 2023 12:38:49 GMT";
	modification-date="Wed, 20 Sep 2023 12:38:49 GMT"
Content-ID: <A200294FEBB55549AF29523017C334A0@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64

RnJvbSBlOGQzZTQ4MmZkMjg3MGZjNTZlMmFmN2ViMzgxMjI2M2U0NDY1NjRmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogTmlrbGFzIENhc3NlbCA8bmlrbGFzLmNhc3NlbEB3ZGMuY29t
Pg0KRGF0ZTogV2VkLCAxMyBTZXAgMjAyMyAxNzowNDo0MyArMDIwMA0KU3ViamVjdDogW1BBVENI
XSBhdGE6IGxpYmF0YS1jb3JlOiBmZXRjaCBzZW5zZSBkYXRhIGZvciBzdWNjZXNzZnVsIGNvbW1h
bmRzDQogaWZmIENETCBlbmFibGVkDQoNCkN1cnJlbnRseSwgd2UgZmV0Y2ggc2Vuc2UgZGF0YSBm
b3IgYSBfc3VjY2Vzc2Z1bF8gY29tbWFuZCBpZiBlaXRoZXI6DQoxKSBDb21tYW5kIHdhcyBOQ1Eg
YW5kIEFUQV9ERkxBR19DRExfRU5BQkxFRCBmbGFnIHNldCAoZmxhZw0KICAgQVRBX0RGTEFHX0NE
TF9FTkFCTEVEIHdpbGwgb25seSBiZSBzZXQgaWYgdGhlIFN1Y2Nlc3NmdWwgTkNRIGNvbW1hbmQN
CiAgIHNlbnNlIGRhdGEgc3VwcG9ydGVkIGJpdCBpcyBzZXQpOyBvcg0KMikgQ29tbWFuZCB3YXMg
bm9uLU5DUSBhbmQgcmVndWxhciBzZW5zZSBkYXRhIHJlcG9ydGluZyBpcyBlbmFibGVkLg0KDQpU
aGlzIG1lYW5zIHRoYXQgY2FzZSAyKSB3aWxsIHRyaWdnZXIgZm9yIGEgbm9uLU5DUSBjb21tYW5k
IHdoaWNoIGhhcw0KQVRBX1NFTlNFIGJpdCBzZXQsIHJlZ2FyZGxlc3MgaWYgQ0RMIGlzIGVuYWJs
ZWQgb3Igbm90Lg0KDQpUaGlzIGRlY2lzaW9uIHdhcyBieSBkZXNpZ24uIElmIHRoZSBkZXZpY2Ug
cmVwb3J0cyB0aGF0IGl0IGhhcyBzZW5zZSBkYXRhDQphdmFpbGFibGUsIGl0IG1ha2VzIHNlbnNl
IHRvIGZldGNoIHRoYXQgc2Vuc2UgZGF0YSwgc2luY2UgdGhlIHNrL2FzYy9hc2NxDQpjb3VsZCBi
ZSBpbXBvcnRhbnQgaW5mb3JtYXRpb24gcmVnYXJkbGVzcyBpZiBDREwgaXMgZW5hYmxlZCBvciBu
b3QuDQoNCkhvd2V2ZXIsIHRoZSBmZXRjaGluZyBvZiBzZW5zZSBkYXRhIGZvciBhIHN1Y2Nlc3Nm
dWwgY29tbWFuZCBpcyBkb25lIHZpYQ0KQVRBIEVILiBDb25zaWRlcmluZyBob3cgaW50cmljYXRl
IHRoZSBBVEEgRUggaXMsIHdlIHJlYWxseSBkbyBub3Qgd2FudCB0bw0KaW52b2tlIEFUQSBFSCB1
bmxlc3MgYWJzb2x1dGVseSBuZWVkZWQuDQoNCkJlZm9yZSBjb21taXQgMThiZDc3MThiNWM0ICgi
c2NzaTogYXRhOiBsaWJhdGE6IEhhbmRsZSBjb21wbGV0aW9uIG9mIENETA0KY29tbWFuZHMgdXNp
bmcgcG9saWN5IDB4RCIpIHdlIG5ldmVyIGZldGNoZWQgc2Vuc2UgZGF0YSBmb3Igc3VjY2Vzc2Z1
bA0KY29tbWFuZHMuDQoNCkluIG9yZGVyIHRvIG5vdCBpbnZva2UgdGhlIEFUQSBFSCB1bmxlc3Mg
YWJzb2x1dGVseSBuZWNlc3NhcnksIGV2ZW4gaWYgdGhlDQpkZXZpY2UgY2xhaW1zIHN1cHBvcnQg
Zm9yIHNlbnNlIGRhdGEgcmVwb3J0aW5nLCBvbmx5IGZldGNoIHNlbnNlIGRhdGEgZm9yDQpzdWNj
ZXNzZnVsIChOQ1EgYW5kIG5vbi1OQ1EgY29tbWFuZHMpIGNvbW1hbmRzIHRoYXQgYXJlIHVzaW5n
IENETC4NCg0KW0RhbWllbl0gTW9kaWZpZWQgdGhlIGNoZWNrIHRvIHRlc3QgdGhlIHFjIGZsYWcg
QVRBX1FDRkxBR19IQVNfQ0RMDQppbnN0ZWFkIG9mIHRoZSBkZXZpY2Ugc3VwcG9ydCBmb3IgQ0RM
LCB3aGljaCBpcyBpbXBsaWVkIGZvciBjb21tYW5kcw0KdXNpbmcgQ0RMLg0KDQpGaXhlczogM2Fj
ODczYzc2ZDc5ICgiYXRhOiBsaWJhdGEtY29yZTogZml4IHdoZW4gdG8gZmV0Y2ggc2Vuc2UgZGF0
YSBmb3Igc3VjY2Vzc2Z1bCBjb21tYW5kcyIpDQpTaWduZWQtb2ZmLWJ5OiBOaWtsYXMgQ2Fzc2Vs
IDxuaWtsYXMuY2Fzc2VsQHdkYy5jb20+DQpTaWduZWQtb2ZmLWJ5OiBEYW1pZW4gTGUgTW9hbCA8
ZGxlbW9hbEBrZXJuZWwub3JnPg0KKGNoZXJyeSBwaWNrZWQgZnJvbSBjb21taXQgNWUzNWE5YWMz
ZmUzYTBkNTcxYjg5OWExNmNhODQyNTNlNTNkYzcwYykNClNpZ25lZC1vZmYtYnk6IE5pa2xhcyBD
YXNzZWwgPG5pa2xhcy5jYXNzZWxAd2RjLmNvbT4NCi0tLQ0KIGRyaXZlcnMvYXRhL2xpYmF0YS1j
b3JlLmMgfCA3ICsrLS0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCA1IGRl
bGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9hdGEvbGliYXRhLWNvcmUuYyBiL2Ry
aXZlcnMvYXRhL2xpYmF0YS1jb3JlLmMNCmluZGV4IDA0ZGIwZjJjNjgzYS4uNzlkMDJlYjRlNDc5
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9hdGEvbGliYXRhLWNvcmUuYw0KKysrIGIvZHJpdmVycy9h
dGEvbGliYXRhLWNvcmUuYw0KQEAgLTQ5MzUsMTEgKzQ5MzUsOCBAQCB2b2lkIGF0YV9xY19jb21w
bGV0ZShzdHJ1Y3QgYXRhX3F1ZXVlZF9jbWQgKnFjKQ0KIAkJICogdGltZW91dCB1c2luZyB0aGUg
cG9saWN5IDB4RC4gRm9yIHRoZXNlIGNvbW1hbmRzLCBpbnZva2UgRUgNCiAJCSAqIHRvIGdldCB0
aGUgY29tbWFuZCBzZW5zZSBkYXRhLg0KIAkJICovDQotCQlpZiAocWMtPnJlc3VsdF90Zi5zdGF0
dXMgJiBBVEFfU0VOU0UgJiYNCi0JCSAgICAoKGF0YV9pc19uY3EocWMtPnRmLnByb3RvY29sKSAm
Jg0KLQkJICAgICAgZGV2LT5mbGFncyAmIEFUQV9ERkxBR19DRExfRU5BQkxFRCkgfHwNCi0JCSAg
ICAgKCFhdGFfaXNfbmNxKHFjLT50Zi5wcm90b2NvbCkgJiYNCi0JCSAgICAgIGF0YV9pZF9zZW5z
ZV9yZXBvcnRpbmdfZW5hYmxlZChkZXYtPmlkKSkpKSB7DQorCQlpZiAocWMtPmZsYWdzICYgQVRB
X1FDRkxBR19IQVNfQ0RMICYmDQorCQkgICAgcWMtPnJlc3VsdF90Zi5zdGF0dXMgJiBBVEFfU0VO
U0UpIHsNCiAJCQkvKg0KIAkJCSAqIFRlbGwgU0NTSSBFSCB0byBub3Qgb3ZlcndyaXRlIHNjbWQt
PnJlc3VsdCBldmVuIGlmDQogCQkJICogdGhpcyBjb21tYW5kIGlzIGZpbmlzaGVkIHdpdGggcmVz
dWx0IFNBTV9TVEFUX0dPT0QuDQotLSANCjIuNDEuMA0KDQo=

--_002_ZQrn1rae3Y551DGx1carbon_--
