Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2067.outbound.protection.outlook.com [40.107.236.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1926626AE8
	for <patches@lists.linux.dev>; Tue, 13 Aug 2024 14:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723560100; cv=fail; b=KC/CbbgMqOma7VwsnbFrXr14m6mr7JAiKBVybQLNRSEGsIrlkUiYh0U8d9G8X7/J0QT81YgYVA2eJHcq+8e/SiKjDSrswhYhuveuLW7D5rWkPISLF9JR+Eav1r7kOwd/bHCWkD6QNybZNHFytNzztYSgxane3+XsLe2Pcxt3WyI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723560100; c=relaxed/simple;
	bh=Pqo25cWeQVe+ZkGUSse7rYcnGVKq5NXe2aeVt4OkfM0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=h29+CRE5wDTonDSHb3fDnmgw3NHXGXH6eu0GqykU3cesbOgio+0cJcy71lyexexcei5jkS6vdfsBY0qI2akooniR0cDgqA6LKFvIGhUwGSFbkHyLfdzHhC4wsHlDbooZwq4T6NJniGjzw5AAR1LNM53t+79VXFVlJy5S5yjMsWc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ofUQ0CL4; arc=fail smtp.client-ip=40.107.236.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ofUQ0CL4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KO5FG88cph1qog+hxGy4ni8jt7Oo355j3b5k2u3HoUrsRbKFwMrdrJXMc4tNxtvTbMWSBkal+T9xUjKLsv5mjQEZVMBLClNHX+1olePVMYzF25W6JK0SL3plepdO5KVQMTGtzF9L1W5MgIF2154DTwOsGAVDIgjo4GUsJBBKgkS2Ga0dm9a1nnVLy1gJX9heOl54DsZFoBTXU/ZViT+4p4cMOc6b7uNuGyCrQVvlNXdo7FlK2sGvRQ7p5Dxv5A81fT+VrVqqfy+TULQGtc3sNcVLqYuzSn9p57Rp4gOo5eVEbHNK77dtFb+wa+xeZtMdn36fhra/BvVymcYCI1/bdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AV3lG1sGiUmhNWPeBxHOSFzkzSAiXhaRF22BG7Kjrh0=;
 b=FWO6bYelsi1f/G+RGUIIbgDpmPhIWAFVDNJjWy7LesN0sAI6mgUHgDgreot+7ktygeqFgjBnnkAQhbmvZ1GTggO7ezGMn5YUmWzN7L67KuMHjYeDxEG7oOvR/lW5SDnc3vdgu1R25Gdz/5BUGG2TDyD38BBhfmpW0tvTmIY/PKgc/myRzrHvVxAGTDgX7C3VLx8cKTMddARCFH/0CVBvCBpy+6UNkwGp3OS+0PYQmynvo6zAjcPA5h/K4JUVL0smtkIsC41+9nSnlFSwW7mwUprqHtuG5+iK0bJ4s/TPyWBeArGKXOWRO6xACq0dDVMiS4Wer1PO7zD4SjTLwuL3IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AV3lG1sGiUmhNWPeBxHOSFzkzSAiXhaRF22BG7Kjrh0=;
 b=ofUQ0CL4HmQ0HLdtHDvaYq1dgQF9yAP1B4KdA/0KV5TyaUgSZxewpcf/+C3RKxm53xIwoL+LSTtjVXTxIb1irJI5RSr8MSbRoaHLYmA7cuqCrtSL6hVS+gNB+3uwyWp722sZ4xIc1hAX3SokeGla5TFSBgLA5ler7ldBOT9BBzg=
Received: from CO6PR12MB5489.namprd12.prod.outlook.com (2603:10b6:303:139::18)
 by IA1PR12MB6090.namprd12.prod.outlook.com (2603:10b6:208:3ee::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.23; Tue, 13 Aug
 2024 14:41:34 +0000
Received: from CO6PR12MB5489.namprd12.prod.outlook.com
 ([fe80::5f4:a2a9:3d28:3282]) by CO6PR12MB5489.namprd12.prod.outlook.com
 ([fe80::5f4:a2a9:3d28:3282%4]) with mapi id 15.20.7849.023; Tue, 13 Aug 2024
 14:41:34 +0000
From: "Lin, Wayne" <Wayne.Lin@amd.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kevin Holm
	<kevin@holm.dev>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "Limonciello, Mario"
	<Mario.Limonciello@amd.com>, "Deucher, Alexander"
	<Alexander.Deucher@amd.com>, "Wu, Hersen" <hersenxs.wu@amd.com>, "Wheeler,
 Daniel" <Daniel.Wheeler@amd.com>
Subject: RE: [PATCH 6.10 257/263] drm/amd/display: Defer handling mst up
 request in resume
Thread-Topic: [PATCH 6.10 257/263] drm/amd/display: Defer handling mst up
 request in resume
Thread-Index: AQHa7NX/g7R4aKYVR0O8DBBXNlU0BbIlJrQAgAAXrACAAANjsA==
Date: Tue, 13 Aug 2024 14:41:34 +0000
Message-ID:
 <CO6PR12MB5489A767C7E0B1CFAEB069A0FC862@CO6PR12MB5489.namprd12.prod.outlook.com>
References: <20240812160146.517184156@linuxfoundation.org>
 <20240812160156.489958533@linuxfoundation.org>
 <235aa62e-271e-4e2b-b308-e29b561d6419@holm.dev>
 <2024081345-eggnog-unease-7b3c@gregkh>
In-Reply-To: <2024081345-eggnog-unease-7b3c@gregkh>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ActionId=20eeae5b-bb83-4c97-9cac-400d86b3df2b;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ContentBits=0;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Enabled=true;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Method=Standard;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Name=AMD
 Internal Distribution
 Only;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SetDate=2024-08-13T14:33:08Z;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR12MB5489:EE_|IA1PR12MB6090:EE_
x-ms-office365-filtering-correlation-id: ca57fc82-b641-48f0-9c58-08dcbba6077e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?BMt6aEtbPSMID23gBIT8WsHjn+Vkc7VIq2VjxEIZIT0yRA1MWKMlwVpbG9pc?=
 =?us-ascii?Q?vpGrCX595NkTRuClUqgID7ijj2xBVcliZ4t8E4kRC5cWJb9apMa/jObBlwJT?=
 =?us-ascii?Q?D2Tfu8D/USk9sioDIeDqNO9M/3wwOpIB9u2vEDWXuehV8Eph2nNgV7dFsGVP?=
 =?us-ascii?Q?HiMxSwWATh4n4ca7pWlrIihcRPVz9arroE2KagKE33E9+TGTMw11yZQHE+wF?=
 =?us-ascii?Q?mBqP8UfPYtPEmCo5vBq+w+OUKvIy5bJcA1W0zTjPBbdCP2SOXLmaDUhoxdYi?=
 =?us-ascii?Q?QImdA87Xx31gOvdmfoAizMV5xvpm67nfZazj6ByY6Ta3Rq8QdM9VBoDLprsX?=
 =?us-ascii?Q?w/8KWpXnHGO+tQ4MkgkjCfi7raif4IpkwB/cVubmKhTRkA3d9fjEbKkyRDAl?=
 =?us-ascii?Q?lZtZzEqZUculpBO4vUjjvAiinkWsqkQeVYEyVI2qUengqqlyEmZE3vU7dbrY?=
 =?us-ascii?Q?5Tk2RmHhBQrO6nEP7WGfu9R+/LSn6eyEx8M1MagfTq6zhxsw66u9G01S31bK?=
 =?us-ascii?Q?r/nZ7/3D1OecdGvmrZgC+r6oB6qIzXFphsBM1Yk+0Yr/FvrZ3mORPHIbwXbD?=
 =?us-ascii?Q?kDZ9ZEbqyn3HvXIjZNOFPdatzVwH++5ysbjJs3HwSOS5ewCqL7tYcnJ+HdAK?=
 =?us-ascii?Q?uH0BvMolvOhNfg+0UH29iVxlrn3/WhMQ231lSvrisT0yFikl4HUC0gupzmcz?=
 =?us-ascii?Q?YWxmAEal0V/+k/cbYwG6J9mdi6OxfMGxjEw0PesSXGf2m8xeDVHV+LboY9B7?=
 =?us-ascii?Q?ftQAyK85kVzuVNrYFUJeNEzi6TbXnidgT9ouvdGITpuINgqKuufcGuEofW5g?=
 =?us-ascii?Q?tvRsHTp2McdqO+g5TPoFH+9gSULhLDxPl06uQxkR/c/16Uo5evEzaJXtiYjc?=
 =?us-ascii?Q?311TBvzRB4wNG7Qcz1bJwwRxf1X21jNeg0oX7YbcM7Bu5e/R2xCmybe5Mwyj?=
 =?us-ascii?Q?MWbc7puTctwIhjl8EVOPv7GHvzLAudgWi6tDkRpYMj97f2OWvCztE+IXTi3c?=
 =?us-ascii?Q?kpQCm97SMJWxF2WqF5gizmjmLZ1ZwzPvy87egMoSUfUR9VPp4vmt2hIlIGC4?=
 =?us-ascii?Q?jcy3WIQl7QjV2goxSG9shTlu65OCs3LSO7KrRFxV0DLLvH0uyV92/IpeqYPm?=
 =?us-ascii?Q?V8Ia+rk+NYS2y7YH5GAsgatzw64j+B8/Eq+V3lMX6kMGT//7xtCbyMkbHNuY?=
 =?us-ascii?Q?xHr7O2dY03jRXb6NaaizOjvjsg87/Cd1SBe5Zzh4inenxuyU3pljZL8Fz22C?=
 =?us-ascii?Q?swX4b+xZDzabGHDC7CBROacV5/oUhG148XIcsmACWO9iUcShd2hn2eWjuVAc?=
 =?us-ascii?Q?kNP3p1BIR6rW2p6qLZRzNKChUfi307sU30U/IVZ5Cv1jb5ORefZtvUWVDF4k?=
 =?us-ascii?Q?Y9hCWBpt9a4SMMqk63CHDM18q4vvLqkIWAakiWU5c1yZf1VFfA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5489.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?1z9BDE6X3n6Y0yvAVgkmK8TXEVnhgfUN12aicPMKcquQcQn/5Ndu81Dr7YkB?=
 =?us-ascii?Q?ozkQ/ungRqybuqQESjzrEuqaoXCeQXY6ZdIRzBcOvv0s3WVjvKdEwQV+UMsH?=
 =?us-ascii?Q?fR08SH4cyf6b0APMgH4ubqEfvwvLxqUDCHbXmAqICQJD0o0esEU3819PM/QR?=
 =?us-ascii?Q?YyULPGREXdxlkCJkGU/Nu6l6sa9atg9DthKqe40jDwc10lQVRdWCtinpRzEj?=
 =?us-ascii?Q?iSlwF3paYgUEKSx0PXM46PafhnBhGDarMiOxHEAX8hNbPMX83CxygYrUl9Lv?=
 =?us-ascii?Q?VbWndo1EJ3JLkUbGQphfW44SiJymLzsSD3XtX3BMv+LG8cV3Vg2ZI826o16N?=
 =?us-ascii?Q?L4DBJl5I+uIcUsoDmVqgDeY3fZTu37PBk+JeWND8WqFi8ySLDZ9PkK/y3gsW?=
 =?us-ascii?Q?L6a7uX/hSiBn4LiAROrJQmU66O7ytO2EyfJgfL6RRgWY9JQMO6q1hoMBl0mQ?=
 =?us-ascii?Q?WrBRQSS5icmgUyQyX1RfR5vDQOvlYTwWk/C8JPIAxKwW4KgSzqgi/j36LeFO?=
 =?us-ascii?Q?KylfkR73zhLScrt/0d/XV7OYJklX/fy4Yaa7+yktJsa8JVzskjWcbAcC503W?=
 =?us-ascii?Q?8SS8GDOTam//3pBdaaNZooxLAOSae7GaRqwQJb4Ok9mqXXVIJGIUa2Rc+gzs?=
 =?us-ascii?Q?bEW+00t+paeN859k4rvKcoRMd3dVP3JOf35hgNrVu5LoBMXWbc3jllyHJnu3?=
 =?us-ascii?Q?k9ysaIqcdN7gSuu1+MGlI6aIhG9Bm5S51TRpdiXgvNkyYMN6BUajeexiy0xW?=
 =?us-ascii?Q?KaXFxej8kC8OstpSLg4XLN6ilm9gghWdDgEJhfFoZEGMyNhuqaS31YIoS5P3?=
 =?us-ascii?Q?dMkIMT29OfUszkDk5nt2recFPJt2n0rve9gpTvDAAN0lai5k9PI+siiHt7gR?=
 =?us-ascii?Q?i51IzyWqb7xDvONkxKCSCMBIG0fVeUWfB+xXuxYPFVPDgLjdn1M3soCUziqN?=
 =?us-ascii?Q?E2chnt6O2+aqLWzjZ/A7oJiFLwVUZms8IDVFqya19g9Lta0gQ52nP2g1axwL?=
 =?us-ascii?Q?MKZ5UUpbT+e/edAHj8QrSAX9cvx1h3F//lKrjWa0rv464zyRTygsmUqnKwtF?=
 =?us-ascii?Q?9a4q8y6wIMLpizpOq8XCnJLlxWzPACn90myCgbEtZ0AFsaA5wCbeE54SIAh6?=
 =?us-ascii?Q?441wGpGKktsFaIHMi4HgZzTNtEovDG9QSCwWeUfYit94OPp1nEnbYYzFXcqG?=
 =?us-ascii?Q?JzaqzsAQRZzpstVLKloFnskbP7Nf4dN2JTF5VNpjmYecePgoCieVzoHTVHeM?=
 =?us-ascii?Q?x/ThabIvHDJUqWNAoJynU4iRTQwQF7945RLfuuKst9/BuSyjWBCGE2oSFM+V?=
 =?us-ascii?Q?bvlGh6J4gOCUW6OHZIoiHm5/kpR4l7uvpG+SY1uCNcAGdsbGqiOscz0pM882?=
 =?us-ascii?Q?W/bt4mT191m9jPSVc1ukSy6AfAPoNbSLAYFgQTVlhJlIKvqID1J1zeur/IkQ?=
 =?us-ascii?Q?PETgvZDV/Jygxk9zMwVPEkIHeviP1eMbeaQBUAPOZW8zMy7dVYVUYKRzJr0b?=
 =?us-ascii?Q?CNhna4HD9DZMCBSc8NWdKHpsJrcamSK2/Zlnj2VertMorxvRG1mhZLLryOXp?=
 =?us-ascii?Q?J9V3RJ0xe1VCo8F/k6s=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5489.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca57fc82-b641-48f0-9c58-08dcbba6077e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2024 14:41:34.4292
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jufvd2W9u1QqW4w00w5pGNSq8a5IlIAZqMZwBAk/Y2+f6XdhT7IOfVnMzzK+WcxL29God3EdbG14fMxDGFGT8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6090

[AMD Official Use Only - AMD Internal Distribution Only]

Hi Greg and Kevin,

Sorry for inconvenience, but this one should be reverted by another backpor=
t patch:
"drm/amd/display: Solve mst monitors blank out problem after resume"

Thanks,
Wayne Lin
> -----Original Message-----
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Tuesday, August 13, 2024 10:21 PM
> To: Kevin Holm <kevin@holm.dev>
> Cc: stable@vger.kernel.org; patches@lists.linux.dev; Limonciello, Mario
> <Mario.Limonciello@amd.com>; Deucher, Alexander
> <Alexander.Deucher@amd.com>; Wu, Hersen <hersenxs.wu@amd.com>; Lin,
> Wayne <Wayne.Lin@amd.com>; Wheeler, Daniel <Daniel.Wheeler@amd.com>
> Subject: Re: [PATCH 6.10 257/263] drm/amd/display: Defer handling mst up
> request in resume
>
> On Tue, Aug 13, 2024 at 02:56:18PM +0200, Kevin Holm wrote:
> >
> > On 8/12/24 18:04, Greg Kroah-Hartman wrote:
> > > 6.10-stable review patch.  If anyone has any objections, please let m=
e
> know.
> > This patch seems to cause problems with my external screens not
> > getting a signal after my laptop wakes up from sleep.
> >
> > The problem occurs on my Lenovo P14s Gen 2 (type 21A0) connected to a
> > lenovo usb-c dock (type 40AS) with two 4k display port screens
> > connected. My Laptop screen wakes up normally, the two external
> > displays are still detected by my system and shown in the kde system
> settings, but they show no image.
> >
> > The problem only occurs after putting my system to sleep, not on first =
boot.
> >
> > I didn't do a full git bisect, I only tested the full rc and then a
> > build a kernel with this patch reverted, reverting only this patch solv=
ed the
> problem.
>
> Is this also an issue in 6.11-rc3?
>
> thanks,
>
> greg k-h
