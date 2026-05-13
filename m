Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11021139.outbound.protection.outlook.com [40.107.130.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7243FBEA3;
	Wed, 13 May 2026 11:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.139
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778670563; cv=fail; b=CYFWvg8EqJuEJqyAnvR19QKO5SlPdfM5lRfoCckt9k5QgNDJ0CKM9bjSvDf0ja4en1s2QKwkRwbv77/r0MHfyP+V3OAWKvlVUguhw0X3DBuHtheD1Zm84KWSS+jEhyTj6bOAyEEZg1DNzIPHIXMdV/HW+Mb1Y1ccW9TxQuByNO8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778670563; c=relaxed/simple;
	bh=ZU/P8jWcuDT1FQ8uWLb7iKmGJcZmRdytmXGJ0n/8g68=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lHRGvWfBU184Br3UOfD2aK0LrOzYAb7w7VEr9PU1p8f43r8GX/A6KneKJ+MXqgEqh7yyUkMkdmXotIxnGp/d0iYkA3m5Ya1j1M+lGZl89MRYva/czSyPedqBOKE5W3KRJ2qmRZJVoQDWSet8rk5Vsd6FRadQd1WlChZF1mrbMyA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=solid-run.com; spf=pass smtp.mailfrom=solid-run.com; dkim=pass (2048-bit key) header.d=solid-run.com header.i=@solid-run.com header.b=Dw3HrXkP; dkim=pass (2048-bit key) header.d=solid-run.com header.i=@solid-run.com header.b=Dw3HrXkP; arc=fail smtp.client-ip=40.107.130.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=solid-run.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=solid-run.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=solid-run.com header.i=@solid-run.com header.b="Dw3HrXkP";
	dkim=pass (2048-bit key) header.d=solid-run.com header.i=@solid-run.com header.b="Dw3HrXkP"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Vmr/aomD7NJh/ZG2MnyVepjDk0zbi0Z4EeIgWKAHLQGdOo2n7b4myQH1nVZK7v+QWjbljaXcYWlsuduJ92oYoGlpIGZOEzmL19aJBw05vyK1BVckOX8xQy86pN9CJJghQ4XOFHM2oSE36j6Yf6uJI7lf6TIyt3E5rQftMm/mPifFZYL9puns75LXweUwsVBEeFwGSOWGNmabgzltD7/yXg8ou6PWFEw/5qrGNsAuPXraC5Md4aDBjdKJwQEqxDf6s1mzS+U1XaPTGMDGGBffnXVzlHg2kRqFS3oaFBwwnCXMPFrQx1vVq7TVWQnbE6jLJlGh8A+qPs2UneFzOJVp/A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZU/P8jWcuDT1FQ8uWLb7iKmGJcZmRdytmXGJ0n/8g68=;
 b=IVy4RGTQRCZZnebHqnB+311fRisQ534JGHSAIH9k7Dhl1mXLdkwV4kM24z39PH02Wi5Y+607FOvTVVBM23Hbfj7jJLOgbIow53A6CEeGZ1URMBsmLhr91swPXCQe+o8lppky1rQZNCBJblBdTyR0rBFVAeSxSQuFPDxRm+eR6jtV/a6VUx5OxZfUCmml6e3e4Wu76BspSw/hvOkZA0p0RBU0wBjyaKDzDOVK1xusTXSa0JjxzvZMOGw+kokkl1UTkWX+TRtGgJ8fmoaqtvZSiiMuUesdHV65cLVh6xJ4peH3fnuTPO0AW4piQaxYZt720VN3yPplof8A6ur9EvdXmA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=fail (sender ip is
 52.17.62.50) smtp.rcpttodomain=8bytes.org smtp.mailfrom=solid-run.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=solid-run.com; dkim=pass (signature was verified)
 header.d=solid-run.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=solid-run.com] dkim=[1,1,header.d=solid-run.com]
 dmarc=[1,1,header.from=solid-run.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=solid-run.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZU/P8jWcuDT1FQ8uWLb7iKmGJcZmRdytmXGJ0n/8g68=;
 b=Dw3HrXkPaYz4XEVawjVEKf2A8Cyw4g3eK4YbKZSodJgwmsDMIHfLI23jB/otN+S3tRrUPpkC7X1PdCVt0EXfhgLFdOXNjCMYkBUd73xDce9qYwYzg+r24J9HMgy6qFaiktiTuEQ8gv6yth2z1IMIDddiiowSOY7c4hlVVfGOO9zrMxlaDWNAi0k9wN8+t3XLKDqSI9R6v6hPGzDp2b2iFhgY0eT7ojUPM3IbrbT4GtrSYLx/icWAfj9Dix3H45TR+3nLVsqHBaE6/CMgafZ+zhjnUbgheUStzPzyK91BqpBst94R3u6PYAyvgcHur7S6b9NxoxbFc7zI5EpSmSSqOg==
Received: from AS4PR10CA0024.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5d8::16)
 by DB9PR04MB11598.eurprd04.prod.outlook.com (2603:10a6:10:60f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.23; Wed, 13 May
 2026 11:09:12 +0000
Received: from AMS0EPF000001A4.eurprd05.prod.outlook.com
 (2603:10a6:20b:5d8:cafe::1a) by AS4PR10CA0024.outlook.office365.com
 (2603:10a6:20b:5d8::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.25.17 via Frontend Transport; Wed, 13
 May 2026 11:09:12 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 52.17.62.50)
 smtp.mailfrom=solid-run.com; dkim=pass (signature was verified)
 header.d=solid-run.com;dmarc=pass action=none header.from=solid-run.com;
Received-SPF: Fail (protection.outlook.com: domain of solid-run.com does not
 designate 52.17.62.50 as permitted sender) receiver=protection.outlook.com;
 client-ip=52.17.62.50; helo=eu-dlp.cloud-sec-av.com;
Received: from eu-dlp.cloud-sec-av.com (52.17.62.50) by
 AMS0EPF000001A4.mail.protection.outlook.com (10.167.16.229) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.25.13
 via Frontend Transport; Wed, 13 May 2026 11:09:12 +0000
Received: from emails-4184520-12-mt-prod-cp-eu-2.checkpointcloudsec.com (ip-10-20-6-103.eu-west-1.compute.internal [10.20.6.103])
	by mta-outgoing-dlp-305-mt-prod-cp-eu-2.checkpointcloudsec.com (Postfix) with ESMTPS id B888F7FFE0;
	Wed, 13 May 2026 11:09:11 +0000 (UTC)
X-Mailbox-Line: From b'josua@solid-run.com' Wed May 13 11:08:59 2026
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y4RsGyPPYn4eEYwr9SDh0D62JLTE1Ppdm1MiSLNI6JsAh/9OmZbvgewlhlloIw9SS/WlT/ToUf9pogVi0aMnuqCYPZmg0lSS5ETEUWZcgNbgi1ogC8PSY8GXpk0MYtbZDkjcBS1muCB+KCh1WhLaP71vjzinELeWnuUF03usPXBu2G+fSG6ckZwd3e4WguyE4wDwf+OG4BLqKIgVwKCGyawiihtDknGUG8Mf7L04jAx95E8mpxMWY/3HGCagjQRLLs5XMlIDp1RUhHmyj41ehno3t90nLUDbImavg9yEZuCTYv8hXHCDT4jXTBltBL7LcC53FXvJXR3Ax12Eo/42zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZU/P8jWcuDT1FQ8uWLb7iKmGJcZmRdytmXGJ0n/8g68=;
 b=aM+8aACXHj5DSisp6EjROXrjlsHfhfdt5B7yiQvCsfGbYSz5NA98e08PwG7s4tabv0utSa80bJHkK7LP2cgIOHQCbnxkjltjNbB+B2Xp3/iRDz4RICt9tf3Y3g8v6foWAXg+UrBZD1lN+VmFzZDPYxadXZiUFfLcr3+Bxg1NzggCrBWOrdbnGZjCS+fR9IdHGqTtl+TFDUKxWyPkcU5JB8AfxbqzjINb3n7EmzFudXl58bqkGrtERO6W91ZM0VQyuewho7H1a/4F4MO5OPLKyAzJEWt2YFAdno+RP4+Vek6EaTsZ8mIT6SLiXMdKtXTau4WDJZIPXASNiUHbf3BisA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=solid-run.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZU/P8jWcuDT1FQ8uWLb7iKmGJcZmRdytmXGJ0n/8g68=;
 b=Dw3HrXkPaYz4XEVawjVEKf2A8Cyw4g3eK4YbKZSodJgwmsDMIHfLI23jB/otN+S3tRrUPpkC7X1PdCVt0EXfhgLFdOXNjCMYkBUd73xDce9qYwYzg+r24J9HMgy6qFaiktiTuEQ8gv6yth2z1IMIDddiiowSOY7c4hlVVfGOO9zrMxlaDWNAi0k9wN8+t3XLKDqSI9R6v6hPGzDp2b2iFhgY0eT7ojUPM3IbrbT4GtrSYLx/icWAfj9Dix3H45TR+3nLVsqHBaE6/CMgafZ+zhjnUbgheUStzPzyK91BqpBst94R3u6PYAyvgcHur7S6b9NxoxbFc7zI5EpSmSSqOg==
Received: from GVXPR04MB12057.eurprd04.prod.outlook.com
 (2603:10a6:150:313::24) by DB8PR04MB7065.eurprd04.prod.outlook.com
 (2603:10a6:10:127::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 11:08:57 +0000
Received: from GVXPR04MB12057.eurprd04.prod.outlook.com
 ([fe80::14f1:a127:2988:de5b]) by GVXPR04MB12057.eurprd04.prod.outlook.com
 ([fe80::14f1:a127:2988:de5b%7]) with mapi id 15.20.9913.009; Wed, 13 May 2026
 11:08:57 +0000
From: Josua Mayer <josua@solid-run.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Lu Baolu
	<baolu.lu@linux.intel.com>, Joerg Roedel <joerg.roedel@amd.com>, Kevin Tian
	<kevin.tian@intel.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Pranjal Shrivastava
	<praan@google.com>, Samiullah Khawaja <skhawaja@google.com>, Mostafa Saleh
	<smostafa@google.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH rc 0/5] Fix some iommupt mistakes from Sashiko
Thread-Topic: [PATCH rc 0/5] Fix some iommupt mistakes from Sashiko
Thread-Index: AQHc4i7mfgN+BivNHEOMcDPCZikby7YLzWoA
Date: Wed, 13 May 2026 11:08:57 +0000
Message-ID: <94ff8f34-040b-49a9-8b69-9a6bcb5850ad@solid-run.com>
References: <0-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
In-Reply-To: <0-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solid-run.com;
x-ms-traffictypediagnostic:
	GVXPR04MB12057:EE_|DB8PR04MB7065:EE_|AMS0EPF000001A4:EE_|DB9PR04MB11598:EE_
X-MS-Office365-Filtering-Correlation-Id: 81e513f7-8089-4676-f2a8-08deb0e01003
x-cloud-sec-av-info: solidrun,office365_emails,sent,inline
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|366016|376014|1800799024|18002099003|22082099003|38070700021|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 XyEOL8Z4j1x2cmS5VFaFTGkw2NoNc+0QvcUC12NzN3twHvaGFFJhGcOc7gNY5GuE0t3Ig1liZbzPJHgh4LT+a6Dd+Ec801HbfAby5sIVrwi+S+vZf8QTK851Ei5ORlvzKjCh8d2mDLs9zbYB5zoUvwNjyGxF3TQG8oXTX4abdTruPbTy81sTOWb7IYSJURzPrefXz+Ve0DoR/AfXNZaA6g0Fhtvf3LwW6lWAMHTJYZxiS9kSrFFLXMM97ej0n/4JUfQfuiqy9RGLLxwtTkURt4XbfAo3fB8QusQ9psBysFxo0xvFtLhau7GlAbdNQ5Gssdoo0FSqKXoJ0frUN+aJOHBUP6nguESjmBA7sCiDSQR15PWbOhQkavvyf3Zlkhlapv4l9Kmpawn+RAwhA0GxKO2cSmAJgvaCeBkNYtTIwx+meIpc7KmD0hcVc1EUb4gQDCdW5k3/Mnv8bOrurnsqMVy5VAyDrWLO8Ik1Az79nAF8d3Dp5I8zyZaiNQ/rxDzYhMe86i/pdQgWHM+mPl9Yw0O0W6YQ3X7mxnIJuUpQ/821KMZX86pBd9FbnK/T5It7u+S5egHycgP+ZSEo+d8w0PB86Xr3Hp7pAuwM+c73UD1r22rDWmpoy3tf+0GCeC3ytBozdeTTkYa3SXcafgEOhdwNAWPz/Vd8/fq5aIIx051wsebUB/FvryIIwIHqQ02zfskUlcwYoA2tfYH6dIJNkL34mwukI0Qo9YPILMaAdJ8kRaOqjeQKZkyK6ls5M2sR
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR04MB12057.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(18002099003)(22082099003)(38070700021)(56012099003);DIR:OUT;SFP:1102;
Content-Type: text/plain; charset="utf-8"
Content-ID: <A02005917AA8124DBB0320FF369D511A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 seFmHFKLKugBYMFGwWUK2lH5U9c3YyIrC+lkpl1oG2HmH4UkQH5JMtI0mCJcOsEqRdigaFqQR9tJCHUDyD9zFoL6JCCCuX+rpzG+4ZoSy7/0x//BDwcHI+dMFlravO1WrzxxXm42Vmhv8o0Yv3Fu2U4xXymMqA1MhQBu/NfC6s4ONbatHkreeJWx+vl33cg37iuKS2YOoi80FngrYYs5Ck2O/aFZQzbdFiKBCgE/Rh+Kv906nlXPybvWaNbkgyuw0rG9ikqazGTZDbBaYqUW6cahAFCCOWsAEfYr6DuGXNbyOGM+fI4d1H4qtiweR2Mc6A9MDzS1wxjtTUTJczFI5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7065
X-CLOUD-SEC-AV-INT-Relay: sent<mta-outgoing-dlp-mt-prod-cp-eu-2-7.checkpointcloudsec.com>
X-CLOUD-SEC-AV-UUID: 00657762f0dc43489aa67fb380818b30:solidrun,office365_emails,sent,inline:4478fc6e9c83597bc2a6b1698828c4ef
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A4.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	fd80d6dd-0082-4e73-8f9c-08deb0e00707
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|35042699022|7416014|14060799003|36860700016|376014|82310400026|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	DyPU4Rya373j59Mn7xx+tCocTAPXzCwKtDroFqyUO/F7fkD+oLEv3OuoGLtDdIiU0r5A5bt+IuSsxSFx88DEbRd029o+39hmz3PeT/emUiVbJ37R3f/c6XBqXBa7R85ZPH6cwaYB5nGPF2VK0/DNyCtNogYJ+I79iooJ8IjkRRkUm5cyaPV1DKx+aA661EdVVLvP+nx79IqrvdcqvQ5LRIj5nAwxmwDJcsBjFSl4ldAhAOC9rAE7K7BaCFDshzZD8R7VZ4UIP9kk/loIHXiUQtzKEfMSYsZiDqmG26PAZ8sNM8TvEKLiHj47PbopeS7LyEu4WCiXnDnyOE7aAyqMrdrYyS7vN70vLL0GGO7To1g0+2WLUAsj/v+kwkMFnPrdQ6y2cB6fimHF9XrqUuEGamov5vZPb2vGCVrW7K1vIVKhEFVT1kvfVDI7N2IQxz6ChzvgBDCep7oGYFCNF65FrWJ2HZCpAqcHPLUvAVo924bhoGA+XO6Qah9l95DNFnXOIIk3ZbDfCh0ojDpufn9rPb3UvsjoM4dsntMFZEWM59AVtskIeYaVOIv+r39FnNHz/LFuc+8NeL+Rs/PhH4eBOsdPjOGi7pJJpls6CrYbwTLtqjo4LgsbEQijiigv4byHANxkBLhfENafqxb7QxUXvYH8BUjQKkQG+DegKDRMoxKW3RvYvW/4oE3WgynK81fav0lhg7FpvCP5GWAU6/O742uAiVIDJSj7STq1N3+kwDg=
X-Forefront-Antispam-Report:
	CIP:52.17.62.50;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:eu-dlp.cloud-sec-av.com;PTR:eu-dlp.cloud-sec-av.com;CAT:NONE;SFS:(13230040)(1800799024)(35042699022)(7416014)(14060799003)(36860700016)(376014)(82310400026)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+WtnKzSWb3FOXNu/G7XLT9yVTXaUR5nzgyEI/rln+K/BhEu4q27bpxe2foMNS/lNMGF/JbTdOfV+OW1tlXPiYpcwo7874BNuTEUoLUc46Eth8QIYGWWIyG/jRCikEAjTjfLsEXhTPZ2fhP6hVNjkyjhxivnzBipP/WMqg7lmWtSYf4orl0LspJPpWA13hNVLQMkCAfbVj+qtPanqsFPvOvIbLTlWNS+4S3nVKISfaBBc/Ox3R8FIGN4rzG3KEHImjN+cEmf7zyCvxmXc9PTP8GKIqGAxcLgdBE49+xm0aJQDhLKIXMTDpFL1Rq5cYAvEeK8kpQIKF6L5Gq/7y4otONrT0G3U7VJ+1dFcuX3nwQQyfPpDUM5vESzJAPMEjxX7PulYOcBq5VH0SiYq6Rk3qZ+PNgjgjLrs8MtvoOGCB1Jg6rzFaAgVgPySegOQLr9W
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 11:09:12.0055
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 81e513f7-8089-4676-f2a8-08deb0e01003
X-MS-Exchange-CrossTenant-Id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=a4a8aaf3-fd27-4e27-add2-604707ce5b82;Ip=[52.17.62.50];Helo=[eu-dlp.cloud-sec-av.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A4.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB11598

QW0gMTIuMDUuMjYgdW0gMTg6NDYgc2NocmllYiBKYXNvbiBHdW50aG9ycGU6DQo+IEpvc3VhIGZv
dW5kIHRoZXJlIHdhcyBhbiBlcnJhbnQgIXJldCwgc28gSSByYW4gdGhlIG9yaWdpbmFsIHNlcmll
cyB0aHJvdWdoDQo+IFNhc2hpa28sIHdoaWNoIGZvdW5kIHNvbWUgb3RoZXIgaW50ZXJlc3Rpbmcg
dGhpbmdzLCBhIGZldyBtaXNrYXRlcyB3ZXJlDQo+IG1hZGUgd2hpbGUgcmViYXNpbmcgYWNyb3Nz
IHRoZSBpb21tdV9kZWJ1Z19tYXAoKSBzZXJpZXMsIGFuZCBhIGZldyBvdGhlcg0KPiBpbnRlcmVz
dGluZyByZW1hcmtzLg0KPg0KPiBKYXNvbiBHdW50aG9ycGUgKDUpOg0KPiAgIGlvbW11OiBGaXgg
bG9zcyBvZiBlcnJubyBvbiBtYXAgZmFpbHVyZSBmb3IgY2xhc3NpYyBvcHMNCj4gICBpb21tdTog
Rml4IHVwIG1hcC91bm1hcCBkZWJ1Z2dpbmcgZm9yIGlvbW11cHQgZG9tYWlucw0KPiAgIGlvbW11
OiBIYW5kbGUgdW5tYXAgZXJyb3Igd2hlbiBpb21tdV9kZWJ1ZyBpcyBlbmFibGVkDQo+ICAgaW9t
bXVwdDogQ2hlY2sgZm9yIG1pc3NpbmcgUEFHRV9TSVpFIGluIHRoZSBwZ3NpemVfYml0bWFwDQo+
ICAgaW9tbXVwdDogRml4IHRoZSBlbmRfaW5kZXggY2FsY3VsYXRpb24gaW4gX19tYXBfcmFuZ2Vf
bGVhZigpDQo+DQo+ICBkcml2ZXJzL2lvbW11L2dlbmVyaWNfcHQvaW9tbXVfcHQuaCB8IDI0ICsr
KysrLS0tLQ0KPiAgZHJpdmVycy9pb21tdS9pb21tdS5jICAgICAgICAgICAgICAgfCA4MiArKysr
KysrKysrKysrLS0tLS0tLS0tLS0tLS0tLQ0KPiAgMiBmaWxlcyBjaGFuZ2VkLCA1MSBpbnNlcnRp
b25zKCspLCA1NSBkZWxldGlvbnMoLSkNCj4NCj4NCj4gYmFzZS1jb21taXQ6IGJlOTNkMTg2YWU4
OGE5MmU3YWE3N2UxMjJkNGU2NjFmYTU3YjFlMzkNCg0KVGVzdGVkIG9uIHRvcCBvZiB2Ny4xLXJj
MiB3aXRoIExYMjE2MEEgQ2xlYXJmb2ctQ1guDQoNClRlc3RlZC1ieTogSm9zdWEgTWF5ZXIgPGpv
c3VhQHNvbGlkLXJ1bi5jb20+DQo=
