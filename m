Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012014.outbound.protection.outlook.com [40.93.195.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0DF261B97
	for <patches@lists.linux.dev>; Wed, 17 Sep 2025 19:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758138958; cv=fail; b=NEIg/YINaGSp6kUVs5H7BypZuDVDAzUvQBgF8sWCt0ikHtNlppFeXZXW7C9L5EFTRt923Gh4g1eD+sWHpzk/1gbnRB4j9Ey1lq2DL3zJLcO4EL1qz4cIG7ru8B/KBIWVKE0dJJyQCiwx3wNdYTZDFRMYSrfjzF8q21vPoWa48jc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758138958; c=relaxed/simple;
	bh=hBvXvyzGEGB4mo+dPElaQrR5QrWvmxQ6lrpuyZfV7rE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lALcFp+/6gcnmXgzJMpiZiAXEe2KYigZC8XdTmX+9fTVykbk1EV4s4CRTEC0jqMVEnj03q41rd7dLdTTwOrrPF8pG+7bTPwVnN86a52I+N/1VaUvMnySoleJlBb/Vn/1l8W4B/Kd2bSe/MDPKLcSxEynadV8OD+m1vqqJkKSEMI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AsGHP81Z; arc=fail smtp.client-ip=40.93.195.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AsGHP81Z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=le+IRVu/i3IT8UGrNq6dHJsZf7TMqIsmY0HbM0ug8nGL1RnqtYYzkuUqnHMk/jkxhq+yaQx1pcdso2PPMQlGAWb5F6hYZGLVTY+0vlSqTi5U5dC1zCCLJAJ+HSBTUAdi/PtuopB5xZXKaB2S4GUQbo1HpbEE/zHU43nlVZ3WZkVsJQwtpVVFi6Nr0hYJkciX3pqR+58OnjqOxGYdiPjreuk3TNpFdn/BNIeA/FWZd5iz9GIJT60YUgX/2ZVsNwAWjysExcVvtcteHQI2NRd/5BZbuHJZUQPmVoYYGypU9VUR9VR+igynUU3nPmSK9hgXwjuWICUKORccuj4RlZ/u4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WwrSVQbOHPMzZ2+yHvMLCKHYlYJg2SGG4FvRu1Aw1Js=;
 b=TeNkHLT+yhbmqmZp1/0XfoXFDmi+PzyA5qyv8bCJm3eWWeG5eRRyaslCGkdnmcw3YskbCEjwvsthXjGkHA1YVhbKDkCPFr4RaEBuz3QBkhJBuGth5oi8SCtudIJvLNplPLHdNkyJDJBKwONGlDVWS3d0VwjiIQPHvX4T/P+dc8JixzGYPqig+B/VwZchrDI9MPVlrWLxSBS1aI4zoskJ9il6SJWK1RJlTkFSCOyQZ1p1ztCjInzm/2f9hAloLvFlSFWSEOzBAMQsi9JOLzMTEhVyujWi8/zSQvYd0VZr0VnmKMbkWWo9t0P06uDlQIk5ZslslzQI6N9c5YH+LIEx0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WwrSVQbOHPMzZ2+yHvMLCKHYlYJg2SGG4FvRu1Aw1Js=;
 b=AsGHP81ZQUjlObgTeFap0daY1fiSZYORIrN0kSRygze73bFHyP539J63eE9xloUxPBzOYx1IcpN7FWkDuxbowXpSWUA783I3dYxO9lxkufXPKmZ1TS2Y6Nb3H134HLkaM9GstiW72VG8ERRyHI7fTyeNZlPxEGEDK5o/rJ59ias=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Wed, 17 Sep
 2025 19:55:53 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42%7]) with mapi id 15.20.9115.022; Wed, 17 Sep 2025
 19:55:52 +0000
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "cao, lin"
	<lin.cao@amd.com>, "Prosyak, Vitaly" <Vitaly.Prosyak@amd.com>, "Koenig,
 Christian" <Christian.Koenig@amd.com>, Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 6.1 75/78] drm/amdgpu: fix a memory leak in fence cleanup
 when unloading
Thread-Topic: [PATCH 6.1 75/78] drm/amdgpu: fix a memory leak in fence cleanup
 when unloading
Thread-Index: AQHcJ9OAiwMKfZn0FkSpN+IDyJZ6UbSXcAgAgAADxQCAAFZzUA==
Date: Wed, 17 Sep 2025 19:55:52 +0000
Message-ID:
 <BL1PR12MB51440B2B10CFF0A28AEBAE50F717A@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20250917123329.576087662@linuxfoundation.org>
 <20250917123331.416162682@linuxfoundation.org>
 <BL1PR12MB51449335D2432734B3C149DEF717A@BL1PR12MB5144.namprd12.prod.outlook.com>
 <2025091727-zit-unfasten-a64f@gregkh>
In-Reply-To: <2025091727-zit-unfasten-a64f@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Enabled=True;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SetDate=2025-09-17T19:55:07.0000000Z;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Name=Open
 Source;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_ContentBits=3;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Method=Privileged
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5144:EE_|CH3PR12MB9194:EE_
x-ms-office365-filtering-correlation-id: 2c25bbf3-29a0-4ac3-9c81-08ddf62434f6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?qI0LnjJ6LHzc5NPl7V5zoE4yuD6eR8u+DY0GaFzqqY0hKiIzHRG4RUUoPJ?=
 =?iso-8859-1?Q?PJOZwp9nyUpZJmVMjZjh541MhJyjuDHT8hBqxq6imiV8KUqD9KkcUcqFAt?=
 =?iso-8859-1?Q?ph8egoLIohUoCVzvIjXQaBzB/oRnXW4CkLv9lvhy8Qi7YbU0QNdMrPHsI+?=
 =?iso-8859-1?Q?ErYVxio/lxihT+hecdi+lIZVObXoJjXGoJN0TBRueUM++x93DTEUoFjgZ1?=
 =?iso-8859-1?Q?zpemR8q18BSIpLDIAbMqHcaIQVs8k5isS3spbkpZJDZRP+TPjNsVHNALS6?=
 =?iso-8859-1?Q?SUpdfu7cBnsoqWP7eaz32BW4zqd7uWlx/obcNe3YVtAS4Ye5v16i4EtTys?=
 =?iso-8859-1?Q?7urlKd4C6CE0RWMAkDu7INustY2r6MtiJbiWlW0PLp6/BkaurjhG2B84Fi?=
 =?iso-8859-1?Q?WPbxxnIVaS6a5NA4oiM72l9E/QikYJMCA7dPe+fDDqonRlJRRpKKKPb32w?=
 =?iso-8859-1?Q?QPQmsI91fa1nbzschPIZTHYomS0vBwQM/7Mrgf2ZYenFN6xqdpxV07tgv6?=
 =?iso-8859-1?Q?mfmeYRaVk3LtbERpaHw0d5wcPdRuDcKsKz/Q0ifU1MoEaotYkTkiGP1K6U?=
 =?iso-8859-1?Q?yJdU6p50xZixGvtPOSoBtyd7ywSfs8E7I2Z3JaEHIJK5ACFHBD9nMm9DEE?=
 =?iso-8859-1?Q?ZkRa3SvqTY0qqiEDXF/MtPLSS60XsosP6eogrpsGmuXHxS5/TrtySLF2T+?=
 =?iso-8859-1?Q?OcqAVhHJjjPUT9sCO1Lg0o4u2T4GmBnnx/dJUHZ3iSPgLfd656Hg5W8DSx?=
 =?iso-8859-1?Q?RTDJbkU+qCDdvKFTwdUgp/ZIbRHKN1l4xP2GOH4fEmRDy3A0MOyDvsKP5o?=
 =?iso-8859-1?Q?/CupVOesCZm2XUXgPqBO50pHeTtgkHYxKpEfWFJJ58YGCDvk8378JH0nY6?=
 =?iso-8859-1?Q?QwJ14VrYWtzAhEKHKZt1EW07QvXZWW8bTTk2NFRQR+lAw6WK5tclQg8OP3?=
 =?iso-8859-1?Q?OQmoeqJGK5jpgOi9k5CF8w1q+mxqO4s8ca1xDPn1wBVIws6IA7qLvlCrpt?=
 =?iso-8859-1?Q?Dr0A2l/Y/6nfbydHw1i/R5z/4S8X+lw7+9B4xOb8Qiw6Ox4AY5j1nJz5Va?=
 =?iso-8859-1?Q?w+RsLGyAHnPa3WMdo3kg1POyWR00lEAIi5DrbmxG8G52ohGcPBVRjfojML?=
 =?iso-8859-1?Q?WffmEcds2A6L4bqV9yE5Y1emQFA9CtKxGnUyXcMYiuj9JMZhJjrVF2mGjs?=
 =?iso-8859-1?Q?AXGxr66SocYALHRzsDpXd/3kY8ov7A4+ObioSwcZnQ4m08bPcwfs4Dn5kD?=
 =?iso-8859-1?Q?XBEpLAG7SJduzcECnkAmZEgojxalZKX7rq6k6cJcymFL4Cl7AFQWocAIcU?=
 =?iso-8859-1?Q?du3MTxiQCCNB/wuRtNXNugT2dq6vbIgsRz2Xb7Cd4ptIw6WfL+GB0CSD5a?=
 =?iso-8859-1?Q?ijrnuiDasHygJkLmVBMG6g2AO6f1tADRn+lp/JfON3Pc4G8gfger6wd9hD?=
 =?iso-8859-1?Q?gSdywcj8SQ6Kms1TGzwWZtICgYfAsVdLMcv1wrNCoMB/JZihRgL8qazVdX?=
 =?iso-8859-1?Q?fUw8fIIzLaIN2AHOH9oSs0bLpVDNrB3qAL0HQi7POnvg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?dOiSmEYyJmwLb7xEyCwmJulKuSzKeDnqm14nmVwlvRf744f6h0CZ+VIHOB?=
 =?iso-8859-1?Q?ELBmyIw5nBsL5t2m9O9K5hLc8Rh4wD1HaWBQAMUdxM7p+mma7TTCaNGvnB?=
 =?iso-8859-1?Q?C/Rlg+W6PBVVd6RpTtBRDSTV4kKuzE4MKGmrURC7VtuOXCTDkmH+FaiNd2?=
 =?iso-8859-1?Q?GyJGWwQoqZVYHKfCbn8tH5UXiOZIXinWK9Vv83fr26rIFRbXeEBgcgLZEE?=
 =?iso-8859-1?Q?/TKdUYYr5ukWYB45zSKyg3kG1pgXDgXPXIUT4pZNh7M0pybPfrdqqnCr41?=
 =?iso-8859-1?Q?M8XyRiK9LrZdNqiaLAwRUxOE6hd/5AUQM5/BHSaAB2S4aI78FpGnSx5jp6?=
 =?iso-8859-1?Q?2y/SllVOeOY55B/PvBlozQNSxm8tbFGhkZZl1BpDYxmzlW/Xsazbpmt6CZ?=
 =?iso-8859-1?Q?NlzWunIKeYfhyaGaq/fERWEr4P0vtedSmxsw1qHKjVjNMyCdXNmpkCm1yi?=
 =?iso-8859-1?Q?5I5HirYtKR7dOg/cGkJkt5CSI5YMKMRE7VLDOZouDaVQusO4f8I4eo7cs+?=
 =?iso-8859-1?Q?TyeEqVSPHg05x9AJQHeHLLPOcMsXkxEM4+qeKPa/R8RlqHFnFU7sk70U1j?=
 =?iso-8859-1?Q?zF2DTHVfGp1n0pDcRT0XmswPLtMeD9MeW02YuM1sDuPa89eWuo+t2Vi9zj?=
 =?iso-8859-1?Q?NkBn043ojtgp93/M78dqXurD0KkpWGpkcc5UQ1q35l5tL3j0su6KAaw+k6?=
 =?iso-8859-1?Q?651k46AnDUCbDmH4PJSEdBi/wlKZ8yF1C9xVJFxwlJJkhqh1FoMslb/RGt?=
 =?iso-8859-1?Q?P8+xiYteIFlyirRb/0CrsBLe1m+nQm1+HVvbam+28yUjzJ1P0AzYuZJEbU?=
 =?iso-8859-1?Q?tt2GzgH92HLtqYSJOfcmWi2iszF1dYYCy5TVLK2a1wHEhfeupD/m/XDhor?=
 =?iso-8859-1?Q?6xtakdVqQMQxgkbNr+TbdIb7CnGK7ihVsgTvitGYadbj32DTDrp2GjLOdy?=
 =?iso-8859-1?Q?Fu1APUlPc6UtFsqTcA/M77rofmufgyesAD/t1ysDhPbFRATFuOts31r9bm?=
 =?iso-8859-1?Q?He1yTVfYWrr1gip/KdltaP99JzlfVwLqVGU2i4lwoTXvcHykgfbv1NSd8L?=
 =?iso-8859-1?Q?DkRBI331ZHeVfDAMktSGXaI53mw3Oj/Q75DgWtAug1BsHOUl1OEbbjFaI3?=
 =?iso-8859-1?Q?LWGr6YG3Jm9LMBPOEPA98bBOsWCJyNvn1LDKmFqyLjf7cLY2UGmzHTDz2g?=
 =?iso-8859-1?Q?45HqsPmGrsK2wPN+kXh1mVQXqUKaJ0R+ZT1VbefR7mRm5HMKWUcokOA1TJ?=
 =?iso-8859-1?Q?kn767SOo8LW7ddhkvClzgrbZn5quGr5x8lAPCp+Pn92D5mkdiDqjOdXcCZ?=
 =?iso-8859-1?Q?2jOSlK17MMMv0WeEp27Kv8zcDirBO0vymTy2eCJjhm8e4cKJFl10CGMsfk?=
 =?iso-8859-1?Q?dc+66M/V2/1RnhncpaneBWww+ckRYIu472WnfYOpGrxrvirQr/nujxqr3L?=
 =?iso-8859-1?Q?rURegveTBL0PJMch3Atx4/XGPzdEJatx5DznvN/S7bKrcLxEeAaCEIiGZG?=
 =?iso-8859-1?Q?q/nHdez8l9n4LBYls2yJf1Xwjje/N3gSojsEsZwEr0ZtorWxZtwHPrhZdk?=
 =?iso-8859-1?Q?yNhCMX07+ZcljAnLcfc2wA1lLRjQGdyN+VpWfJgLjXMC5aQ5cWiHjYXaOS?=
 =?iso-8859-1?Q?x8apyCesrYAZ4=3D?=
Content-Type: text/plain; charset="iso-8859-1"
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c25bbf3-29a0-4ac3-9c81-08ddf62434f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2025 19:55:52.4011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j7EMp03tRVbtqM+faTiB9DjdrIWG61nCy80SF/GUenQbTj+/f+eNMYDGbdYHaqzmXTYba0rnC3KQrjmkxGyaSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9194

[Public]

> -----Original Message-----
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Wednesday, September 17, 2025 10:46 AM
> To: Deucher, Alexander <Alexander.Deucher@amd.com>
> Cc: stable@vger.kernel.org; patches@lists.linux.dev; cao, lin <lin.cao@am=
d.com>;
> Prosyak, Vitaly <Vitaly.Prosyak@amd.com>; Koenig, Christian
> <Christian.Koenig@amd.com>; Sasha Levin <sashal@kernel.org>
> Subject: Re: [PATCH 6.1 75/78] drm/amdgpu: fix a memory leak in fence cle=
anup
> when unloading
>
> On Wed, Sep 17, 2025 at 02:33:39PM +0000, Deucher, Alexander wrote:
> > [AMD Official Use Only - AMD Internal Distribution Only]
> >
> > > -----Original Message-----
> > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Sent: Wednesday, September 17, 2025 8:36 AM
> > > To: stable@vger.kernel.org
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>;
> > > patches@lists.linux.dev; cao, lin <lin.cao@amd.com>; Prosyak, Vitaly
> > > <Vitaly.Prosyak@amd.com>; Koenig, Christian
> > > <Christian.Koenig@amd.com>; Deucher, Alexander
> > > <Alexander.Deucher@amd.com>; Sasha Levin <sashal@kernel.org>
> > > Subject: [PATCH 6.1 75/78] drm/amdgpu: fix a memory leak in fence
> > > cleanup when unloading
> > >
> > > 6.1-stable review patch.  If anyone has any objections, please let me=
 know.
> > >
> > > ------------------
> > >
> > > From: Alex Deucher <alexander.deucher@amd.com>
> > >
> > > [ Upstream commit 7838fb5f119191403560eca2e23613380c0e425e ]
> > >
> > > Commit b61badd20b44 ("drm/amdgpu: fix usage slab after free")
> > > reordered when
> > > amdgpu_fence_driver_sw_fini() was called after that patch,
> > > amdgpu_fence_driver_sw_fini() effectively became a no-op as the
> > > sched entities we never freed because the ring pointers were already
> > > set to NULL.  Remove the NULL setting.
> > >
> > > Reported-by: Lin.Cao <lincao12@amd.com>
> > > Cc: Vitaly Prosyak <vitaly.prosyak@amd.com>
> > > Cc: Christian K=F6nig <christian.koenig@amd.com>
> > > Fixes: b61badd20b44 ("drm/amdgpu: fix usage slab after free")
> >
> > Does 6.1 contain b61badd20b44 or a backport of it?  If not, then this p=
atch is not
> applicable.
>
> Yes, it is in 6.1.127.

Thanks.  Carry on then.

Alex

>
> thanks,
>
> greg k-h
