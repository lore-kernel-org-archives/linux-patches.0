Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2046.outbound.protection.outlook.com [40.107.102.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D6B302758
	for <patches@lists.linux.dev>; Wed, 27 Aug 2025 20:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756327647; cv=fail; b=UqCaX+U2K8VY5aE4ZKpkmcbzEEt5tMG/Diae4qZTwaHfgyMHiKoDnhMtkL4WYg+LDwy15CgP3LYjOIME6Vy0+tvN3Eu1rN2VaOrA8qUpwYHCE0UmyRmNmLiKJkFy2j1Wls9pvS2UxGpxzqNXOcC19hhxkTn+AkbTyKzdjHeEDDg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756327647; c=relaxed/simple;
	bh=GbpmwCxinyE/UETDVLQDHPAVJikG+8LMryLP1Q1/JOI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nZgcTK2aibXD5bzrlEE20yPo7k2OHTNPBETl5378DRUq/xR8EbP1gMnymYJy5ZuLdiD5XA22wbbVOc4tctYN6psHGXpdzXn/rIGNX287LdmVHHVEYOEkuWbnqrxHSYVLuHTNpWFQxiN+tjJimavXdc06+sziM7cibKegQg/ejmE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Xh5Xkv+8; arc=fail smtp.client-ip=40.107.102.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Xh5Xkv+8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GZEwmileSUSbcBUalafh6bcUXosmEwYZIddaGDzZF/hmu2mHVW9GF6VDf5nLsp1bIY+b9zCCdPb0IkTPYL1h/xknElioRninJ9JBEPiSuRjflKazxrUROLCfMmKg5HUxGfQT+pLE7Hm6C9zg4wJ9ulwGydAKNFnIBlhWtDp2UkoomNyfm5TAXkuxqbHAifoy5IHKHSH4uT9C4qeUjdrrar+OLFFn1lScoL7XYEoAdK5BwyFxya6Ui/q8WXuEdQc/Dug3bJ+djMawupk1VfuMLbC3YYYHSIwl//OAZBeumYIMbizytKRrj9JOg7lDb0+JGaf/6nc5e+8rvJ130A0ssQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mBQyFkvfjNggcIqwkNjlUci7YAETtj49TTCU25Amjg4=;
 b=R04J+9otUaYv35kFF9u3FG+lPpvQOXAjBnlfSXKlQLUnuOhIPchJCt7Z2r+B6dfYlPjJcNiFWDIY8r9SBQRhQa+rLsYDNxIo+41wK/rdbtNDXds6mqJy3Hs/eCkGbfzx/iBcwV1x+WcxAerXGdxs0aFrkooSw4yqa3xvVOi0Q5W6OJLaWIqrLE5J0wkPBNviqi7/99A9wbWFpqW7buy3E/BZNTlWQOvv3H+TIAjMpt8PlmsQpcPa0vdwG0CD8sV5NADR5P4U7Qa1OO3NQavC9QUknQCyuUHWuOH3xtktZvXoijgCO9b9rGVDpClju+hfmyGk3/Kcb2gHB75Qh7Xxew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mBQyFkvfjNggcIqwkNjlUci7YAETtj49TTCU25Amjg4=;
 b=Xh5Xkv+8/VaJT1tuYTLVkqKAclX3siCijemOysM5WXQQO9VBpXXajyOx/uzpZcb0hgU/0aAESCl+aFfI1Wj4dVgIGQJubdN/YZyPGZ1lNs3iU3JntZdqdouPCzsn6XnHtMDftpdwid31yqtCutSo4NashOMsx2zq0I9WGdHPCMc=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by SA1PR12MB6800.namprd12.prod.outlook.com (2603:10b6:806:25c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.13; Wed, 27 Aug
 2025 20:47:22 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42%4]) with mapi id 15.20.9009.018; Wed, 27 Aug 2025
 20:47:22 +0000
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "Xiao, Jack"
	<Jack.Xiao@amd.com>, "Gao, Likun" <Likun.Gao@amd.com>, Sasha Levin
	<sashal@kernel.org>
Subject: RE: [PATCH 6.16 482/570] drm/amdgpu: fix incorrect vm flags to map bo
Thread-Topic: [PATCH 6.16 482/570] drm/amdgpu: fix incorrect vm flags to map
 bo
Thread-Index: AQHcEEnoeq/66jWdO0Wo0/qavEppfrRzcRIwgABpUICAAyxCsA==
Date: Wed, 27 Aug 2025 20:47:22 +0000
Message-ID:
 <BL1PR12MB514415ED612349A8F1F955C0F738A@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20250818124505.781598737@linuxfoundation.org>
 <20250818124524.452481295@linuxfoundation.org>
 <BL1PR12MB5144F2E3EB31673E0B78B8B7F73EA@BL1PR12MB5144.namprd12.prod.outlook.com>
 <2025082530-gory-outsmart-d4eb@gregkh>
In-Reply-To: <2025082530-gory-outsmart-d4eb@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Enabled=True;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SetDate=2025-08-27T20:46:16.0000000Z;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Name=Open
 Source;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_ContentBits=3;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Method=Privileged
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5144:EE_|SA1PR12MB6800:EE_
x-ms-office365-filtering-correlation-id: d4567fee-b8f0-4c6f-083f-08dde5aaebe4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?Yg/WsggEoV6LBvBtOcTmL1D1WZagk2/WCD75Vs0zzjZeu7weBcVPiBM9ZdC7?=
 =?us-ascii?Q?SPr4JleTur62oNIimWu/enBw5UxBYCxV/2qv3CPfsu9ea3+x/J0d5tsu0wzX?=
 =?us-ascii?Q?MktwkWxBZjauxgICOsC1tQKJ3WXAeFeKUX7Hbr+tSfRzpSFm6XIlbK748Cn7?=
 =?us-ascii?Q?OzdRLskbxFk0lGJqpDT2Y84lkNSryv/qmEHmD2uvM0zxQr6quouPkczTbKxS?=
 =?us-ascii?Q?5ajf73FUGlx5d4p15NoKOfjGUJxi8aIIXIMNvrANkA+w+WlbVyLgtflnO3Jr?=
 =?us-ascii?Q?JWnv3WJpTBSmrMXnsGBEhFJL+TC7Bwn4vmVEdPRZHNJpoaRuJ4GQRRa0lmnQ?=
 =?us-ascii?Q?waSDJ+RP7iIeXHCeiIGCo9dqj0VG1IdT7dy1b5RqLrmQsp3w1DRetM7QgDMS?=
 =?us-ascii?Q?vD0/ZLSHxSx7l23JdfyoIhqmW7U/+ytuPmgxuVlP6qFdezvEeKL48/Vy5QA/?=
 =?us-ascii?Q?31iGrr5szO2UO8tE+0RBuDfyFtNU04fWZVAvbW4sK7wA882riP7qLguwu8ve?=
 =?us-ascii?Q?8LmMYFKDczU1LJ5C3fLQnMu4S8pa/Ys7ugyhQ+reV/jsT/irZDnEe8zXu5kI?=
 =?us-ascii?Q?d+ykRWUV+mRkqalb5En2dtlZsmJeqN55BSORSfddt2diaDYF382wqubWLVPA?=
 =?us-ascii?Q?r++GK6WTgFfQjs9Ev/r33zFtmYSYwWk8/YFYSo1H3hfJGdBwa11OeDqJoiUW?=
 =?us-ascii?Q?KqlDNW+bCoRqoiB9wb7jk+lXWL89cRfQ1g//8exmGQfVvFBXq78TuiUDo2Zq?=
 =?us-ascii?Q?7Pt80hHa1V4/fXRqiSNMqPRllo4psVA2LnifUjN1UQGmG+XzWPiv0aHSEkJR?=
 =?us-ascii?Q?JwH+fhb5HfPo1YooL2/hrAcUEclYva5DKaRvFTFlnaH+aAEHAferf5qmiHRm?=
 =?us-ascii?Q?N1JpGhOl0HueHUXohLUW7bPOV3Ezlm6czML5qcyQcYfhBWN6WNOKTOcMgfql?=
 =?us-ascii?Q?wnfk86K9xv8qKd+Qtza5Y7KLM3RNlI5/mzsVCB9lDZmIEJjtYjyjwpTe5UWA?=
 =?us-ascii?Q?iWeTOyZogOAqrgDrEO26k+HN6YbJB0M1FzXr+06UDi5LfepUtYc0xGln3/12?=
 =?us-ascii?Q?JWBxyQsMC/KaT6wI6HCQRfxh8s96Nuva2Z6gWzH+fM2OHR2c58gkxofuSwnv?=
 =?us-ascii?Q?qkm3FWozYM+Lq0G4hjOhrlNn5tHiZRszEYjPN5MzInVvVjV7YG4l0lezfOEy?=
 =?us-ascii?Q?kU4RHWg5GofsoqTDZXYrQjqSvd1NyuukeAV+28HUX2LFlvGhvOVfJw2+L4dt?=
 =?us-ascii?Q?HreLMwsBMyfIWra3xzEFwUdeM4FeYQRM5EQP41SHgh9JB1K4qV+qu6SChJ1x?=
 =?us-ascii?Q?VFfk//8Oj4QyKRhqsVvY9NnIbT3n/eYV1tnRnc5JDXukM3eRybW/iEyngxeO?=
 =?us-ascii?Q?TYX3Iuu2o8rxsO3kNZCA2d7OR4cEFDhwfuiGTBqIZrkhniOJ86zvZbp94i6F?=
 =?us-ascii?Q?GrdbLJT7i/fqUK0LQNxx4H2O8LExEeI7Cx72BJD/aU0qap9qb+MzPA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?ob2nirgOPmQegYDbQudyTriJTab9w+eV4bAalxBmFKxoj919XD/kuZaACCj6?=
 =?us-ascii?Q?G6y6xB8Qaw5UFhwx2OmWHFP+BHxpdGTxvqNs7OImwej6sUvpHzAmaAy7Vt9d?=
 =?us-ascii?Q?lnbVyIJiVwifGfw4hB1oeM51mmKf6tBGwXxqAthCSm/clwKhSDZYIliYb4q3?=
 =?us-ascii?Q?gLp9D8nlsPz3d+ZZ5yuKfGkTKypvSnlKLIg+DlOvpUVUaAEiQB3nW6erEjH3?=
 =?us-ascii?Q?EnuzRMmy5j/jh5gFGWQa1mpOqE5lkjqBXWvFkwRLYmlYactXTq+txK29jUI6?=
 =?us-ascii?Q?FyzRpCXH+C1IWYyIbKVAmzOCybq4SiPSOcz6VQ4RtamFNv+CAa3H1gYM/xwf?=
 =?us-ascii?Q?h/hTwMOjEvK7W0hLsIkzmuQOMljblrRp8dNt33OZPyg/FRMAA5rwST2Z/11c?=
 =?us-ascii?Q?MvqbrHwq8VjRYU321tMK036lZ1cZyPx+at1HlYBIRu2crGZQhZyH76sVomUc?=
 =?us-ascii?Q?fa/tru6DWlublskZozNiUzAQdCQ/4GvIHbKqEmrNAORFgvnzTMbFFo4io9Kq?=
 =?us-ascii?Q?tg4+1KQeMnsa/n6WZufx4Ble9++pVgJ9gulustPEftd3SZtvX7JKGHFdT3bc?=
 =?us-ascii?Q?dREEFFqKAjUJBXwBOCRotHO34DNCuMOUCjIvIuauzKB4UkPwYA+bndjUfwUD?=
 =?us-ascii?Q?/1X1z/AwUSeQn1D64UL9p8hw78+R6O+YtWkyPoE2feRSkFutfc3QFeAqvg6U?=
 =?us-ascii?Q?BIkTXbaDO7TZBkOMaUfOWcjRxA7AnOaCCyrCD2wExlMTefcuQhDOtQ2hP8p1?=
 =?us-ascii?Q?FMm3O8YngCWWZb2Q1Cs6THcPXF+TsZaj7WV4DOs4H0XoAxtXIx4MPIkoTzV4?=
 =?us-ascii?Q?qG7gJENPNU15PpBag2XGQxrk+f/jw+qhdHhc4XFKKOPsI5JAnQDanlsiSGJN?=
 =?us-ascii?Q?dfXUEZDaL9NHkxbKMYqnK4AJH9OaWo5oMtarE1Ln4hvjMEcXxeo12KmvJGCw?=
 =?us-ascii?Q?BpDEAUUbvblrXHgryqGOi6pjjBltKFXMNMyy8K3dVYkHJXl4Jbqy8IwbkOWe?=
 =?us-ascii?Q?AaDDqWkC4obJUPvlJex0k05QHXCHBLw7sb96IZSd9FJ+3SGX+Ae9eQsw+lep?=
 =?us-ascii?Q?D/oSIy6pVk1JjfCdID0kJ+oouF9PHPu9ACIGRSxxZ3Nh8Lz1+LgVbWLjpNHQ?=
 =?us-ascii?Q?06HjcE1Sl3zVlFw9V6/UeO08Wv3sv43bFOyOuLhUOX9R7+3kSugF6V79xZ3J?=
 =?us-ascii?Q?oy4qFlRYgKeN5qt9xVRwofsVAwrDvsb0ttN2+kalNXfW6f8lzoDbq48lcz46?=
 =?us-ascii?Q?NxzxrgfQFJ+AmL1zJPuWQge8eKITCjxcp5hqJMFIag+p0kx6SgM3YTQ+Knai?=
 =?us-ascii?Q?mSUNkRPEGikAJtiJge1VGkG9sL2PgMhmLXAoFkW7HILEtc2Fulbwxxit3bqH?=
 =?us-ascii?Q?KkqUbgUoXHlsmazg0Ts7RCeo0iiTEKukz6R2RWQzMcBO7MsKB0owjp9pU+El?=
 =?us-ascii?Q?i7xdJOBuHU4q84x+qAL0byK4UJE6W5mG4M8OYOXiz7JodgHxCsm6U0voYuUx?=
 =?us-ascii?Q?HV2um/uY+hCsXSQUQp5XNFCzA5Cb8kQQG152WqgF2FiJtMuTY2pvmuXXWjIe?=
 =?us-ascii?Q?ncQA4nyvnk61+mabEFQ=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4567fee-b8f0-4c6f-083f-08dde5aaebe4
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2025 20:47:22.0644
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xnBppBFym/PZzzk2V7zN5nI8VuZ6+GEhnGQNNfCEmJFbYjoTzhE9EEtsxuOREdJ7R2eK2A/Ic6iJozoIIumAPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6800

[Public]

> -----Original Message-----
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Monday, August 25, 2025 4:19 PM
> To: Deucher, Alexander <Alexander.Deucher@amd.com>
> Cc: stable@vger.kernel.org; patches@lists.linux.dev; Xiao, Jack
> <Jack.Xiao@amd.com>; Gao, Likun <Likun.Gao@amd.com>; Sasha Levin
> <sashal@kernel.org>
> Subject: Re: [PATCH 6.16 482/570] drm/amdgpu: fix incorrect vm flags to m=
ap bo
>
> On Mon, Aug 25, 2025 at 02:04:11PM +0000, Deucher, Alexander wrote:
> > [Public]
> >
> > > -----Original Message-----
> > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Sent: Monday, August 18, 2025 8:48 AM
> > > To: stable@vger.kernel.org
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>;
> > > patches@lists.linux.dev; Xiao, Jack <Jack.Xiao@amd.com>; Gao, Likun
> > > <Likun.Gao@amd.com>; Deucher, Alexander
> <Alexander.Deucher@amd.com>;
> > > Sasha Levin <sashal@kernel.org>
> > > Subject: [PATCH 6.16 482/570] drm/amdgpu: fix incorrect vm flags to
> > > map bo
> > >
> > > 6.16-stable review patch.  If anyone has any objections, please let m=
e know.
> > >
> > > ------------------
> > >
> > > From: Jack Xiao <Jack.Xiao@amd.com>
> > >
> > > [ Upstream commit 040bc6d0e0e9c814c9c663f6f1544ebaff6824a8 ]
> > >
> > > It should use vm flags instead of pte flags to specify bo vm attribut=
es.
> > >
> > > Fixes: 7946340fa389 ("drm/amdgpu: Move csa related code to separate
> > > file")
> >
> > I accidently tagged this with the wrong fixes tag.  This patch should n=
ot go to
> anything other than 6.17.  Sorry for the confusion.  Please revert for ol=
der kernels.
>
> So no stable releases at all?
>
> And can you send a revert, this is already in released kernels.

Turns out this was not supposed to go to 6.17 either.  I'll just send the r=
evert in my -fixes PR this week and let the revert flow back via the standa=
rd channels.  Sorry for the noise.

Alex

