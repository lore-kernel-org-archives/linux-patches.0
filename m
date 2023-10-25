Received: from rcdn-iport-7.cisco.com (rcdn-iport-7.cisco.com [173.37.86.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3431CF95
	for <patches@lists.linux.dev>; Wed, 25 Oct 2023 12:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="Q4YOfqIV";
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="NyKlMwLh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1609; q=dns/txt; s=iport;
  t=1698236628; x=1699446228;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yrGFiJ2i9qGPlB8AIELsnRStI5mcR2G3k1BgNu8j2gQ=;
  b=Q4YOfqIV9l6rpJkBiALkJmpRrQ4XvPBxUEwBjJLfIKctyTJ6QemWt3OD
   Kh683d0dzZuGRNJN++LKEK2PER7Whsa3EEeESvXlxLPBv7zi82nSiZM/s
   zverc0GUvUaGZjjTUB2ZgbgIDkgAZ13RVKTh0+OQDgzkL1/YsRdsaEUVa
   I=;
X-CSE-ConnectionGUID: tZImDt9aQ7WaWUUXfTpUzw==
X-CSE-MsgGUID: JB8sOq9ITOy6vtp016AqsA==
X-IPAS-Result: =?us-ascii?q?A0BbAwC5BzllmIQNJK1aHgEBCxIMQCWBHwuBZ1J4WyoSS?=
 =?us-ascii?q?IgeA4UtiGWSWIslgSUDVg8BAQENAQFEBAEBhQYChxgCJjQJDgECAgIBAQEBA?=
 =?us-ascii?q?wIDAQEBAQEBAQIBAQUBAQECAQcEFAEBAQEBAQEBHhkFDhAnhWgNhk0BAQEDE?=
 =?us-ascii?q?igGAQE3AQ8CAQgYHhAyJQIEDgUIGoJcgl8DAacsAYFAAoooeIE0gQGCCQEBB?=
 =?us-ascii?q?gQFsmwJgUiICgGKBicbgUlEhD8+gmECgWCGQ4N1hTwHMoIigy8pi35eI0dwG?=
 =?us-ascii?q?wMHA4EDECsHBC0bBwYJFhgVJQZRBC0kCRMSPgSBZ4FRCoEDPw8OEYJCIgIHN?=
 =?us-ascii?q?jYZS4JbCRUMNU12ECoEFBeBEQRqHxUeEiUREhcNAwh2HQIRIzwDBQMENAoVD?=
 =?us-ascii?q?QshBRRDA0QGSgsDAhoFAwMEgTYFDR4CEBoGDScDAxlNAhAUAx4dAwMGAwsxA?=
 =?us-ascii?q?zCBHgxZA2wfNgk8DwwfAjkNMgNEHUADeD01FBttnh+GASl0lWMBrnkKhAyhI?=
 =?us-ascii?q?EkDqWQumA6iXoVKAgQCBAUCDgEBBoFjOoFbcBU7gmdSGQ+OIBmDX495djsCB?=
 =?us-ascii?q?wsBAQMJi0oBAQ?=
IronPort-PHdr: A9a23:IU3B7h+gbteENP9uWO3oyV9kXcBvk7zwOghQ7YIolPcXNK+i5J/le
 kfY4KYlgFzIWNDD4ulfw6rNsq/mUHAd+5vJrn0YcZJNWhNEwcUblgAtGoiEXGXwLeXhaGoxG
 8ERHER98SSDOFNOUN37e0WUp3Sz6TAIHRCqPA90LfnxE5X6hMWs3Of08JrWME1EgTOnauZqJ
 Q6t5UXJ49ALiJFrLLowzBaBrnpTLuJRw24pbV7GlBfn7cD295lmmxk=
IronPort-Data: A9a23:b7byZqyKr8UeundsO1x6t+cCxirEfRIJ4+MujC+fZmUNrF6WrkUCy
 WpMD2mPPqmCMDTyKdpwad63oUMCvcPSy9I1SwZk+VhgHilAwSbn6Xt1DatR0we6dJCroJdPt
 p1GAjX4BJlpCCea/lH0auSJQUBUjcmgXqD7BPPPJhd/TAplTDZJoR94kobVuKYw6TSCK13L4
 YiaT/H3Ygf/gGcsaD9MsspvlTs21BjMkGJA1rABTagjUG/2zxE9EJ8ZLKetGHr0KqE88jmSH
 rurIBmRpws1zj91Yj+Xuu+Tnn4iHtY+CTOzZk9+AMBOtPTtShsaic7XPNJEAateZq7gc9pZk
 L2hvrToIesl0zGldOk1C3Fl/y9C0aJu5I3mJFSj4MWqkHLPTEbR8/tSFHwkIthNkgp3KTkmG
 f0wITQJaFWIgPi7hevjDOJtnc8kasLsOevzuFk5kmqfVqhgGMuFGv6QjTNb9G9YasRmFPPfb
 NcdYCFHZxXbaBoJMVASYH47tL7y2SemL2UD9Tp5o4IVyTjI6xUg8YTKIYTLZsTSHJt8h12x8
 zeuE2PRW0FGa4P3JSC+2mqlmuTPkDjTXIMJCKb+8v9snU3VymENYCD6TnOypf2/z0W5Qd8ac
 hRS8Ss1pq90/0uuJjXgY/GmiGK2nxswR4tZKrIF4T6w95ra3x6kFHdRG1atd+canMMxQDUr0
 HqAkNXoGSFjvdWppZS1q+b8QdSaZHd9EIMSWcMXZVBeuoW++enfmjqKH4k7Tv/k5jHgMWyoq
 w1muhTSkFn6YSQj+6i94VfB695HjseXFFdtjuk7s57M0++UTIehY4rt4l/B4LMZdMCST0KKu
 z4PnM32AAEy4XOlynXlrAYlRezBCxO53Nv02g4H834JrGnFxpJbVdoMiAyS3W8wWir+RRfnY
 VXIpSRa74JJMX2hYMdfOtzgW511l/K8SYS1DJg4i+aihLAvLWdrGwkzNCatM5zFyyDAbIlmY
 87AKJbwZZrkIf07lWTeqxghPU8Dn3Bimjy7qWHTxBW82r3Wf2+OVboAKzOzghMRssu5TPHu2
 48HbaOikkwHOMWnO3W/2dBIdzgicyNkba0aXuQKLIZv1CI8RjF4YxIQqJt8E7FYc1N9z7mSp
 irtAhQBkzISRxTvcG23V5yqU5u2Nb5XpnMgNitqNlGts0XPq671hEvDX/PbpYUaydE=
IronPort-HdrOrdr: A9a23:e0J9B6O9fcRd28BcT73255DYdb4zR+YMi2TDiHoBKiC9I/b5qy
 nxppUmPEfP+UcssREb9expOMG7MArhHQYc2/heAV7QZniXhILOFvAi0WKC+UyuJ8SazJ8+6U
 4OSdkCNDSdNykcsS++2njHLz9C+qjGzEnLv5aj854Fd2gDAM8QinYcNu/YKDwIeOAsP+tAKH
 Po3Ls8m9PWQwVtUi3UPAhiY8Hz4/fwuNbNZxkACxQ76A+Iow+JxdfBeSSw71M1aR8K5a0t31
 TkvmXCi5lLtcvV9jbsk0voq7hGktrozdVOQOaWjNIOFznqggG0IKx8RryrplkO0aOSwWdvtO
 OJjwYrPsx15X+UVHqyuwHR1w7p1ytrw2P+yGWfnWDoraXCNXcH4ot69MZkmynimgwdVeJHof
 t2NqWixsJq5Cb77WPADh7zJkpXfwSP0CAfeKUo/g9iuMMlGc1sRMokjQBo+FNqJlOn1Gjhe9
 MeUf309bJYd0iXYGveuXQqyNuwXm4rFhPDWUQavNeJugIm1kyR4nFojPD3pE1wv64VWt1B/a
 DJI65onLZBQosfar98Hv4IRY+yBnbWSRzBPWqOKRC/fZt3d07lutry+vE49euqcJsHwN87n4
 nASkpRsSo3d1j1AcOD0ZVX+lTGQXm7Xz7q1sZCjqIJ94HUVf7uK2mOWVoum8yvr7EWBdDaQe
 +6PNZMD/rqPQLVaM90Ns3FKu9vwFUlIbooU4wAKiezS+rwW/nXitA=
X-Talos-CUID: 9a23:ZpDz4272QDhXYC77Bdss6Hw1H+w5I3Tkk0jZHHKFOWhVUICHVgrF
X-Talos-MUID: 9a23:J7TLiQtu9mna+tEHIs2nphsyL+BxsoWSL1FTj4ke45DaHDVrEmLI
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-core-10.cisco.com ([173.36.13.132])
  by rcdn-iport-7.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 12:22:38 +0000
Received: from alln-opgw-1.cisco.com (alln-opgw-1.cisco.com [173.37.147.229])
	by alln-core-10.cisco.com (8.15.2/8.15.2) with ESMTPS id 39PCMcre003932
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <patches@lists.linux.dev>; Wed, 25 Oct 2023 12:22:38 GMT
X-CSE-ConnectionGUID: PXJom90bS/6Gi6njmz6EDA==
X-CSE-MsgGUID: 6Fl3gcpWTYinEXGMBY2e2g==
Authentication-Results: alln-opgw-1.cisco.com; dkim=pass (signature verified) header.i=@cisco.com; spf=Pass smtp.mailfrom=amiculas@cisco.com; dmarc=pass (p=quarantine dis=none) d=cisco.com
X-IronPort-AV: E=Sophos;i="6.03,250,1694736000"; 
   d="scan'208";a="5764767"
Received: from mail-bn1nam02lp2040.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.40])
  by alln-opgw-1.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 12:22:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IYN9whCxJBwgVIY0+1RicwuAzliE3b4groQ3T0XVozk6poQAuvqYEMH/3i5YORMmWb29DZCK9pkMbIZme820YtAvXQ32qIx2XtmJXB3mHO3GVRmCtZ4Fma5cjLiUn47OUFxgXXfs07Th8EDt2u5y5YtN1cF2sr8FMT0ksDReMtRfTwVsZ+2ruCQiE0jniQpEOM8BfhMAtJqdluitxfrXdMZYNFRts7JFsoTD5YSAsR3nIhIg3Mh5BpV4KGCrGERwjJd+KaRRdwxMgaZFOOaVogfUnvCNsZa+TLRtusi/Rd12tqvE3FG2nsXFHzNRnTZJRd5VbNGrPY5bSwPM/MH8Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wLq1lrQjjSgisOx0Nma5/xhsj2/a5xDb/oBYo6/pBDo=;
 b=cuh9kT+PBE5Jm/MOISTv12Ef4CzSw1psV5OsyVG/wfofBkxSA9fEjWn/KsY5mPwYlY9L+i2NVIPm6EUWpQ/MIvfFZ5YMdv1FECidJ2eo2Ul/8WOaxQDivRqhhWr4T6LIlgjg82ph2juzzusfgEIeXnT0c6pOaalt2HcBMEOud2nO1bCY+86cydo2RHneixVZR0OPV5kGdRA3drGbYIAjCDbpoT5s6gIPN1/IDQvq9AibnZk/2rbqpXXh2vgz9eaZUSZEff/pxPZbvKnqh1VILsV0UEt9o+S2qEw04S+HoMO6NxnTlJq8TfFYsBOv4bFvo46J2mMNS3+5FN7J53O3HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wLq1lrQjjSgisOx0Nma5/xhsj2/a5xDb/oBYo6/pBDo=;
 b=NyKlMwLhMo1ZLDIwol39/wCjUxkl/7VRTvSoxfou7cttw0d7wXGSXX0YXjK5WPPv9VZLsn4FRZmK3slycC10zrdwi9qR6aYRZjhQygTpaw8l+Ptx40F0r4YwKTosiELEnb+C17B4SN2BqmrnKCLVzwnXVfVdLUofEenVPmJIRwE=
Received: from CH0PR11MB5299.namprd11.prod.outlook.com (2603:10b6:610:be::21)
 by PH8PR11MB6564.namprd11.prod.outlook.com (2603:10b6:510:1c3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.19; Wed, 25 Oct
 2023 12:22:35 +0000
Received: from CH0PR11MB5299.namprd11.prod.outlook.com
 ([fe80::dbd8:84b0:9c4:d12b]) by CH0PR11MB5299.namprd11.prod.outlook.com
 ([fe80::dbd8:84b0:9c4:d12b%5]) with mapi id 15.20.6907.032; Wed, 25 Oct 2023
 12:22:35 +0000
From: "Ariel Miculas (amiculas)" <amiculas@cisco.com>
To: Alice Ryhl <aliceryhl@google.com>
CC: "nmi@metaspace.dk" <nmi@metaspace.dk>,
        "alex.gaynor@gmail.com"
	<alex.gaynor@gmail.com>,
        "benno.lossin@proton.me" <benno.lossin@proton.me>,
        "bjorn3_gh@protonmail.com" <bjorn3_gh@protonmail.com>,
        "boqun.feng@gmail.com"
	<boqun.feng@gmail.com>,
        "gary@garyguo.net" <gary@garyguo.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ojeda@kernel.org" <ojeda@kernel.org>,
        "patches@lists.linux.dev"
	<patches@lists.linux.dev>,
        "rust-for-linux@vger.kernel.org"
	<rust-for-linux@vger.kernel.org>,
        "wedsonaf@gmail.com" <wedsonaf@gmail.com>
Subject: Re: [PATCH v1] rust: add improved version of
 `ForeignOwnable::borrow_mut`
Thread-Topic: [PATCH v1] rust: add improved version of
 `ForeignOwnable::borrow_mut`
Thread-Index: AQHaBz3vws48uhIkVEW6DeRCSD9Ktg==
Date: Wed, 25 Oct 2023 12:22:35 +0000
Message-ID: <rfx55e62g3uvdwunxtfkhheyhgnfgladthezuig2gk4uaaksat@pd4pttamfff2>
References: <87msyi406u.fsf@metaspace.dk>
 <20230823103458.243871-1-aliceryhl@google.com>
In-Reply-To: <20230823103458.243871-1-aliceryhl@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR11MB5299:EE_|PH8PR11MB6564:EE_
x-ms-office365-filtering-correlation-id: 31272f94-4a15-43a2-5e32-08dbd5551201
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 xfAmr/+WUkgtzkGgOUcW8zIyQCxTnlSkXBY0NVEUfOQiqhqE4ybr47vUBpnrHtdTfQ0ZmX1awOQl7INuVLzS8ufqH4IqB8Q9dKxTDUqRqzppKoPbwz0F2Yz/D0byaEP6Na1Hgv0pmvYe9R9Qjuv/7FJg0bxAEH/VIp+4AAmVVG7c6crGPUjLkrUjKqBQc7d6+pJ+bTPSUagS1p98IkUWWGBnLQKCPvc9kNVt6Gsgxz90QdK6RBUPU4M+6VU6sUQtz5Zpg7PpSBZW4iePOUBY3RWAS+397CFKqPQPRWXzs9YejudM0rn+BWVxlNq4r9I0/+WpwNTiLKpF5/I3jg6fPmu65xIBhVZvdsQAt7Jep+lDYv9J9pU+rMzZls0QbgXvg0TunB55MpA34GdXWWtrIZrm3IVEs+prg6dn0qSmfDjQRh3buPJAAtEVEEjwRyw5tiq1GTEtelavP93j0zVXJZ5Jf1ctRxYxyYAQSk01QOUbQZj5nSiOkzYPCfnSLTMk/ssPO+9n/0l8D1CIy0OMLgAF0vYCV+tlpj0hPphvsxo/PavxPvMRO7Iqa40bv002Cu2z9jGWffovG0fidjTZ2YNCTrfTYMP+MVxy0aM0hclUjoC8wgd8nUg7sj+DK7Z54cUMeCUyCxYDnDlz8uLwDQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5299.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(39860400002)(376002)(346002)(136003)(396003)(366004)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(41300700001)(6506007)(71200400001)(478600001)(122000001)(9686003)(6512007)(76116006)(66556008)(66476007)(66446008)(66946007)(91956017)(64756008)(54906003)(316002)(6916009)(6486002)(86362001)(33716001)(26005)(83380400001)(38100700002)(8676002)(8936002)(38070700009)(4326008)(7416002)(5660300002)(2906002)(81973001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?KraWPzDnRkNh1kWPCI2yh1omwwRJwkvL7MtrmAOkbSGnZqfkKDT2r6aA0DnC?=
 =?us-ascii?Q?yPM6W2uyDz8K8wgT2eSD5SXYAfqB7TeUsTusxcfVPCQzUpzBLN25k87WQAWh?=
 =?us-ascii?Q?FFLleYCEJ6fhpuJ9HR4vzKLjjErgrZIgsj46lF0lCzlswCQs1yP83tpJeV4d?=
 =?us-ascii?Q?pUUHGodkX3S28gxC3nsPn8EWcls0HhgiOxZ165Rwg1/VsNNEsRQuDL3aTkud?=
 =?us-ascii?Q?ePKDKuOcujXvbCg0srXhKSZAbMK6gn9hBkxpqnOvR6bOqzlexjB9u5afyLfB?=
 =?us-ascii?Q?8GaktSmXNa7M3cEElsRsfDkIlOlpa7UHCC5/RcVPlovXlaNZSmzmnND/lPNN?=
 =?us-ascii?Q?503dAojePNs53WQzQXyf9c/7LNWn+7MLu1sbxNi4A0aSyn1gBk2g0y5ELIi0?=
 =?us-ascii?Q?UPDauTFEM0jZPj5xsUwALXdMzXy1HqjyrLO4cNdZf5NqogckKUd4X9Xc1XVy?=
 =?us-ascii?Q?vsw6myRjP45ZySVQ5vz78E+AyS62ThLaGvvqNC3GIyqR0D5Agid12hO5bukE?=
 =?us-ascii?Q?LZblspE6a0Yeu4Vr+M4E/OqMeoGa4dzaWgU8hTqSCvyp/EGQap2sCIXG2y4n?=
 =?us-ascii?Q?fcymuuj6ZyAUfYDuSNte+XGgMusBPUyX/wQgLD6BhwWc/WHGHlNFS63D2OyQ?=
 =?us-ascii?Q?rTtQDZgVntJEWJQ1nfaHhMwLQA5RN2hOa4EUu/niA4GmAwclKOrnPBAFK46i?=
 =?us-ascii?Q?RijhXLZ/1fqFHUpT4MTevPgKTo/He34LPJKEWvOB+ttuTnzP/4q61JX05Oeh?=
 =?us-ascii?Q?uln5UaKBaFFYPrU8M4nnupKHDTWr0JaLPpTv/fAGr6nxRMFsQzIBCzZ+YIsl?=
 =?us-ascii?Q?PBp15aj9doL0DMMHleR01zxlVVGsn2961O+ypYKVbShCATRgl5/VGq8kcRFw?=
 =?us-ascii?Q?DOHZ29AOFe/1mXrxaBLug5TdATb1BCIOR4Hlj01R++JTJ4aO5ZT2hQLmNVUv?=
 =?us-ascii?Q?7iwPa9+vlCUnreUMCcxQpkZniFj5hxC0VQ3B4rVJChrNtHusnxzPp1Sdq2M8?=
 =?us-ascii?Q?bMGs9vPsK1E9KywK9eRj7jnVuXAwPDKRxRcr6fB3f7LwImONAKmBDDk2umzd?=
 =?us-ascii?Q?o+tUkjLEd/fu5/psOo1frTbJvd3PMN+XXPtHECuAyM/g/YpMbw0OSidWd2o5?=
 =?us-ascii?Q?ajGMfxnMaJl8nXJFutdMG28JdFjFN2InUQaroKJt4s7Gxg8OwPPrmefbrZgb?=
 =?us-ascii?Q?9D/KAh4aEXR4hO4lCYeOBKAfjL5mpHbZA5Xnin6OrsqC2hj+6I84FpX5Euyc?=
 =?us-ascii?Q?bhP6wTC7pANt3XFHZ++BMJtPCvYK2GpLVVXFyu3+N+O3F9DdeTfLXkqJ8YGS?=
 =?us-ascii?Q?TSxZvJ42M+GgBK65eWK/eFlmvd76Yvmp9dKrLUQw/VyrdelISgv6dMeA4tyO?=
 =?us-ascii?Q?idDpT+zEHBbXv1W9nHKN+OAxqNnpOaR3OmN2Y0i/Q+EIiGLODF6gTWprBz+a?=
 =?us-ascii?Q?Xj+Smg7Z40WF8AwsgL0IhFNOu2oD8Iy+vYKLfBvVkoNOdUv+z2t30+YA5rqi?=
 =?us-ascii?Q?Iox7PqV19NAtvlNqU+uComTmriq997okZUfdLn6VI0NyI93FU5eoqBpxgf+g?=
 =?us-ascii?Q?wSiki/ryXxrelx537H4cKXH2myUdBqBDw5uOVX1Z?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6223BDEE8BAC0A44B7276CEAF1A5C695@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5299.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31272f94-4a15-43a2-5e32-08dbd5551201
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2023 12:22:35.3535
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mYcj5o0W5NB2tQ9cC+ypTHSa7tIwVkEu70lY2vVw1qLBmIiirNoz2OHJHe3ddfPf3pfGAtGr0bNNmJdIps1xCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6564
X-Outbound-SMTP-Client: 173.37.147.229, alln-opgw-1.cisco.com
X-Outbound-Node: alln-core-10.cisco.com

On 23/08/23 10:34AM, Alice Ryhl wrote:
> Andreas Hindborg <nmi@metaspace.dk> writes:
> >>> I am not sure this makes sense. How about splitting the trait in two,
> >>> immutable and mutable and only implementing the immutable one or Arc?
> >>
> >> I used this design based on what would make sense for a linked list. T=
he
> >> idea is that we can have two different types of cursors for a linked
> >> list: immutable and mutable. The immutable cursor lets you:
> >>
> >>  * move around the linked list
> >>  * access the values using `borrow`
> >>
> >> The mutable cursor lets you:
> >>
> >>  * move around the linked list
> >>  * delete or add items to the list
> >>  * access the values using `borrow_mut`
> >>
> >> The mutable cursor gives you extra abilities beyond the `borrow` vs
> >> `borrow_mut` distinction, so we want to provide both types of cursors
> >> even if the pointer type is Arc. To do that, we need a trait that
> >> defines what it means to have mutable access to an Arc.
> >=20
> > I don't see how that prevents this trait from being split in two?
>=20
> Well, you could split the trait, but if you make the mutable iterator
> require the `borrow_mut` trait, then you have to implement the mutable
> trait for `Arc` too if you want the mutable iterator to work with `Arc`.
>=20
> And if you're always going to implement both traits, then maybe it
> makes more sense to not split the traits?
>=20
> Alice

I see this patch present in the rust-dev branch, but not in rust-next.
Are there plans for including this patch in rust-next?

Cheers,
Ariel=
