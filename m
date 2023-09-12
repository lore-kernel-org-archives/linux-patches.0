Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FF11640C
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 16:06:05 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TywJ4k2VLKrUsfkipVbRgJugx20PRrS2Gv2nItMRBcDZreP8v5PGDXu7a7bRqnUAsBk1sut2cIAEqyaR1PO4cl/q8EjQNY+Fjx5pX2YjvAGCA5Ozf7ae8oyUoQI7fJDwGwf63Kp+Mm7w3GWcTrIGEBhjkqyAM1HBYM4fOhnt3n9wfVxdtPkSU92mghNygxg8r28N5Ud83UA/5PAy3aiD5PusLg6sgn/2gEtwJWJ67XGgHTLcKGWvsETTlhMKCaArjtp1Z/hZRhzV8dEwuiUdtSM1jPLnRC6A+hM88Gk2e0ndrSLwP3/70s+mogLTM8nKTj+gsr5KQfyKQv7TBhcu6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R7ID6Suona3/YUOpkUamV17A+ddL82NYIJN8g3yJz7c=;
 b=Vr6NnQV+ept4NooefvG+mAFgfx3qAa8YsDM2RCEczYozGFLvi1W5CGaZVle9bcIl1P/PW+riz4sL034RpfPg9RRTeBpH3lGbMdr3HizQK8yMkWBTeoJBI7geEXP76cARQaXdziHNK4X3jtXA1d1DQnWMgz0TUkn0nTDIguvhTtLDAU3FW4NPRRv2F2F/DzBC1HQk0FI90Id/y0X9HrGILfqpQp3zr9tGp06CdKVDbYG6G1lPyX616MwQNUjC3/zCAomPyQHdHCsSU9LIw7Rx8NfMMQ4g46EayAYuq71oysa3zwWGnkOp1MHGgWoLLItzj3WC8ukTuSxVE7YO0ibxfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R7ID6Suona3/YUOpkUamV17A+ddL82NYIJN8g3yJz7c=;
 b=uDJPX2boHKfHzKS+L19cB9uFH+5+CVAr0NrGC2+ivvKxurD0PGvU9TdKRA7krKfpZJpsr0QLbaVdQreaxQvuV69t2O2pm4p1IFfTcToehD9Ft7tM2c7dVcaom/AWGtSixnLws04TBIMFK0FGDXqPM0MFxrCCPt9Pkl2rNNZY1Fc=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by MW4PR12MB7484.namprd12.prod.outlook.com (2603:10b6:303:212::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.19; Tue, 12 Sep
 2023 16:06:02 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::629e:e981:228d:3822]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::629e:e981:228d:3822%4]) with mapi id 15.20.6768.036; Tue, 12 Sep 2023
 16:06:02 +0000
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Pillai, Aurabindo"
	<Aurabindo.Pillai@amd.com>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	=?iso-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	=?iso-8859-1?Q?Michel_D=E4nzer?= <mdaenzer@redhat.com>, "Mahfooz, Hamza"
	<Hamza.Mahfooz@amd.com>
Subject: RE: [PATCH 6.4 737/737] Revert "drm/amd/display: Do not set drr on
 pipe commit"
Thread-Topic: [PATCH 6.4 737/737] Revert "drm/amd/display: Do not set drr on
 pipe commit"
Thread-Index: AQHZ5MDWv/AdJ94H8E2UM36G2ArlgrAXTRoAgAADAYCAAAK6AIAAAjiAgAAGQRA=
Date: Tue, 12 Sep 2023 16:06:02 +0000
Message-ID:
 <BL1PR12MB5144F6C91696C30A3E7AA121F7F1A@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20230911134650.286315610@linuxfoundation.org>
 <20230911134711.107793802@linuxfoundation.org>
 <CH0PR12MB5284A97461111A04912017798BF1A@CH0PR12MB5284.namprd12.prod.outlook.com>
 <2023091212-simplify-underfoot-a4d6@gregkh>
 <CH0PR12MB528496066990E49D4F93CD208BF1A@CH0PR12MB5284.namprd12.prod.outlook.com>
 <2023091211-contact-limping-4fe0@gregkh>
In-Reply-To: <2023091211-contact-limping-4fe0@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=b9b78dfd-05d7-48f6-b71d-0a481ed475e2;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=0;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP
 2.0;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-09-12T16:01:44Z;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5144:EE_|MW4PR12MB7484:EE_
x-ms-office365-filtering-correlation-id: 54d8be07-25ff-4f49-472c-08dbb3aa295d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 Rp3Kf286fI1xlmQ6wz5ifKJ6ryDEFg+NxKdq4gF2Uv7Zbl9bsH09A5Yrvg0uCh45xFLD/+ZVpFz0rJ2CZOtoBjUAY+itj17+gy2yQJlLqD4aDrwIETkr4CPae5ZSX/w9PBQ8KZcYOKoh2ytuV2FL1J/pzNO9O6+IV8eLndD60noLaKlKSykhJ0i/YjFf7/aOS5Kf1u/bBiYz0wY58ZWym0zd8utHmOoW+KSlEas2MRcZc80Nwuphc1Ng7zSsTiUrCUn6vOUGSuQxuPwmkzoMS8ndnelx35LgZ7C9psS1R8urdEXakImea2jjkLE7uN11JcJ8LWKRnmCPkSOMriC+Jaiz4s9hYa1R7YhHgi027iVK4C6VQR60TmYrnbtjVXBm2y9wzSeExhA0awDIBPE9tI+Pdl5dBnX0o4Ch+ottsEz++xKkJ2feG3jtvw99ESXjMmratu2736E9NmpQbuYcLniVNcHdWADelhnd8wSsj9mVEnsFKQgWdohx6QAJxZXmzeFmqznQNgNWagVPus5jCQ7PNrvTAW8K9xGlCtNYw4FDh9wUx0Dgg8yUkDuJvEviD+x/au+nK/9CWZKMxn085kRttd2idXPouLyd3JbhrKL99tUB41TfJ7+TJxl/j2PMPNpmNhyeAR5/HgehrHc7mg==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(366004)(396003)(136003)(346002)(1800799009)(186009)(451199024)(966005)(53546011)(9686003)(6506007)(7696005)(71200400001)(38070700005)(38100700002)(83380400001)(41300700001)(26005)(122000001)(478600001)(66446008)(66476007)(54906003)(66556008)(64756008)(76116006)(66946007)(110136005)(316002)(6636002)(5660300002)(52536014)(86362001)(4326008)(8676002)(8936002)(55016003)(33656002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?apnHUA92UtiFoWUINwGEPvasx3p+Q6ElDr1pIDk0u9S5Jy7syUTTDtKgU1?=
 =?iso-8859-1?Q?hYgZvXEZPjVJcAEV35GxkWn19P42DdM85MGbRflYT+cxODSp8mmk7Mg0Rl?=
 =?iso-8859-1?Q?Swmly25kINZO8VlvkMzlhF/LaSz5For0Sov0Mu72Ed9j8RhwppHofCBhhC?=
 =?iso-8859-1?Q?9ULToT6Gd7B4NZ74ba7HScSf5t+AYRs5hh+TteYEl9jmSNbTtJ4MiIb+HM?=
 =?iso-8859-1?Q?WKAhe5oVFgvpQUEmIUcXwM8oPd8GFKN7UbqFAce2U9gz/sswpTgDlzPOIE?=
 =?iso-8859-1?Q?O/z4JaDVSXUc7fyYxnmPGp89ZpQGRZauj+GhD0m0dnGKfoCKuk8Xh4bFsP?=
 =?iso-8859-1?Q?QbBHPvmRvYvt9+aaqD/sVcNTGyTRHAAUgTqv5cMC+I4aCNmfevQA7c5scY?=
 =?iso-8859-1?Q?FywQ/w7BVTLlhhvFD0fUAqXlsSP+KlHOkZhXyCyvqaqb6fk/i3TpAemg9G?=
 =?iso-8859-1?Q?aO4/VtM7zncvPJ/GHQBSsxpoMvA0FtjBNBgaB5+EE81/Vuphg1cYacyVDP?=
 =?iso-8859-1?Q?DNj20Viy9s47ZhNoWI20KRmeJYPXtZ4hBVcLDz7BkLSN90h2P90k7cr6Qg?=
 =?iso-8859-1?Q?Zq4ayh3Jm/gS0Rm+uBCm3oSfuTd8qLjvam5fKEtS+HUTj3v4tyDzjs16PP?=
 =?iso-8859-1?Q?SZUfoQ92ENmRA8x3K1J9W3rtz63Otx5+Om6KRELnDfht6P5n2CnZrbRsqa?=
 =?iso-8859-1?Q?y+nwmDqzhIdZzbg8wYzH/yjcEC3Ol3QKoMiFgOSuQGm6j9/IkF99TtF/wK?=
 =?iso-8859-1?Q?7IIgN6U+lt4HSzOXIRP5ieMkVMs59qdvUkSI5zUddjSFClQB0i/Kx2MJcF?=
 =?iso-8859-1?Q?3PRQnM+aGSRA2veDc5JcS8esFCOD2s744jxc3bMiPOfxXzZv/e/kbTzRaR?=
 =?iso-8859-1?Q?Wfty1r43Sn9WiG3j4KvynzJef2tjdRi+uOPHfwVtIz742Mg0fDHs2MkBQq?=
 =?iso-8859-1?Q?gpgk/3GzEyObBqUjPk+/RqkV24kkrpV+f2qCBo5mpgZFznA60TtAl5DwHM?=
 =?iso-8859-1?Q?RZFxCcslrRv/5sRxHuueWhC8XPnj0dt9NF9R9u/sk8Is0daYMiARzkNqaG?=
 =?iso-8859-1?Q?5OyZyU/9ipb6vyhoGeRrrTk8IxHyfGVa4OilVC2o2KeoDbBoQA4MhNCAKv?=
 =?iso-8859-1?Q?Cha7RrZTi0Pmw9J/s+83Klp722WV0QJBvZHahE+6BoL5nvneDLVP/8voks?=
 =?iso-8859-1?Q?mf+pVcqJQFgYeyEiigoPU6053/4D4lWEAj/DUvwCd0dVmwD98Hk/azpjLP?=
 =?iso-8859-1?Q?tyd4eIpUIPD91MG8JBFTf9tS6huqJH0442DyFMUyogNHo+n617D8U4ce9/?=
 =?iso-8859-1?Q?6eUjDvSkG1I7jTeip//ZEJgUZQJLmTbSE2kAckAsZtbE8/Pr3bcE4LNeBV?=
 =?iso-8859-1?Q?6CZ5c61Zy30NRogHk8MDK/N8+GNpx0IKo9msc8uyq87STbMxb7YknOQlTS?=
 =?iso-8859-1?Q?+ghwJq//pGnm+UND96hjAvYM+AO2OL+Nviz9eDRspNKcycac0fRE7Ttski?=
 =?iso-8859-1?Q?NLhu6P4FjaxsF3eg3mjks+7ZRbu+YubEI0qiJ1SyeR+FZRUeRuxlXoc35q?=
 =?iso-8859-1?Q?wIpv+vutKanTyTtNxhalVz0TPmQBVDd0FvtU22S2PM6/A2VCkFp9GSLwZB?=
 =?iso-8859-1?Q?0KUb0bSLA+zo0=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 54d8be07-25ff-4f49-472c-08dbb3aa295d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2023 16:06:02.2424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FWtW+SIotJw0uFhdRefpSoJr68MoSoJGLWquU5DIoVgsPRjF5vS5rF3zdHqqc+6uhFShLAkDQ1qaBiSIixSguQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7484

[Public]

> -----Original Message-----
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Tuesday, September 12, 2023 11:39 AM
> To: Pillai, Aurabindo <Aurabindo.Pillai@amd.com>
> Cc: stable@vger.kernel.org; Michel D=E4nzer <michel@daenzer.net>;
> patches@lists.linux.dev; Deucher, Alexander <Alexander.Deucher@amd.com>;
> Michel D=E4nzer <mdaenzer@redhat.com>; Mahfooz, Hamza
> <Hamza.Mahfooz@amd.com>
> Subject: Re: [PATCH 6.4 737/737] Revert "drm/amd/display: Do not set drr =
on
> pipe commit"
>
> On Tue, Sep 12, 2023 at 03:31:16PM +0000, Pillai, Aurabindo wrote:
> > [AMD Official Use Only - General]
> >
> > Hi Greg,
> >
> > It was reverted but has been re-applied.
> >
> > Here is a chronological summary of what happened:
> >
> >
> >   1.  Michel bisected some major issues to "drm/amd/display: Do not set=
 drr
> on pipe commit" and was revered in upstream. ". Along with that patch,
> "drm/amd/display: Block optimize on consecutive FAMS enables" was also
> reverted due to dependency.
> >   2.  We found that reverting these patches caused some multi monitor
> configurations to hang on RDNA3.
> >   3.  We debugged Michel's issue and merged a workaround
> (https://gitlab.freedesktop.org/agd5f/linux/-
> /commit/cc225c8af276396c3379885b38d2a9e28af19aa9
> >   4.  Subsequently, the two patches were reapplied
> (https://gitlab.freedesktop.org/agd5f/linux/-
> /commit/bfe1b43c1acee1251ddb09159442b9d782800aef and
> https://gitlab.freedesktop.org/agd5f/linux/-
> /commit/f3c2a89c5103b4ffdd88f09caa36488e0d0cf79d)
> >
> > Hence, the stable kernel should have all 3 patches - the workaround and=
 2
> others. Hope that clarifies the situation.
>
> Great, what are the ids of those in Linus's tree?

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D613a7956deb3b1ffa2810c6d4c90ee9c3d743dbb
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D09c8cbedba5fa85f15ac91ed74848aceff69f8e5
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D3b6df06f01cdbff3b610b492ad4879691afdc70d

Thanks,

Alex


>
> thanks,
>
> greg k-h
