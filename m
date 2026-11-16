Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.57
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794839608;
	b=bRx2AsmWA12SXa6/hWcfxIMB03gxb6uSwWDtUrVmztJVlMpTbqddLBLcBzwqW2L9jlxq
	 W1msGodg7WVoORLMkrvkl8+hFcBaSYU4MKA+0n6iZv0u8U08skGITLjjtoE899SIzG4Wv
	 K3NA39B/dFuL5vjV355X5i8BUuUC4J2Q3zlY1TdBPJcm0BmB6Qa6fk9QYCiZZm2fV4+FW
	 qBIpLhQFa6OiF8pdTVGI0wL9yWq7KQap2YcrEchxRB8eCcztRr4lyO1ThzSmtjjPsCU7b
	 15jqQ3l5+6wGvWQ6WzLj942245WWHcA139aEUWbw59zrF4EsOLrQPoPYkGehOM0JT6g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794839608;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=ajbW26Tty/k9dE1nYgjshZ8cwLjO2mGiiaL/GDEyd84=;
	b=Qc/73obwlXeGetIRqf+P8+2Pb0oHRzvwbtxhW+Ng1k8bJXoPLhGs00rfF+BrllBLe6/S
	 qqU1aJ2Pq8FirdUoYbqpM+NrBMp/jdmbsbxazsYjovAY0+DTJXEo0dZ2LiXtH/bbOQ6y3
	 B+rMy4UzI5ZpNtGbz5OoDa9vVZxxCZMRm1a6vX7O66z06qCHKINfrgvGI0UAMcCs0A/cQ
	 Ol3v9sqRqV42MtDPplsGxs11K71l3SUUodiFYivq8pHjPH9xUydYOTq1HFKsxDjzG1jiJ
	 Acfj5gFpCxOSRqjqxeEkjiDHLFfr8yh+DWMVzCcKTETBR/MEf5MtmyPIq6f+CPOS32Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ndZCisgK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.57
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013057.outbound.protection.outlook.com [40.93.201.57])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E62606A330;
	Mon, 16 Nov 2026 14:33:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79E62606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ndZCisgK
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v7qiy9TDwQTGQ5QVXJTq0dSQwFVjW0urp6rmLTe/X7x8OxLubXVIz4ZEBFuDc5GUvBVtW7aaKwvAFgneWmilhjjKxP9PtSzaoOEub7MMxK2PaWf74bfbTpFNElkDYttqCCaA/r/+/Z1e+Gv5YqZ5VJfIwY5tBjRonRwe1R0M3at3D4bsDM5jCUXbsDhQF91kyDVEPCbdbZ1NjNi5M5Li6wO6rDJFYU5opAyqAbK2JAFUqgKGTsJbK79o2BsJGgvQoYmMaYUeSYZmFoVyNsPp+dUZjlMkcMGiyTS4UwvOjoKTtQiNbC8+ePCYWXGm3TYPij7I4je3xDX4TTXZyLjZ6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ajbW26Tty/k9dE1nYgjshZ8cwLjO2mGiiaL/GDEyd84=;
 b=EQUFXlMYB9IGsBrv3rTm9vnc5sBV1OG6rIgKrApiSgiy/zqMYO9uxBZ2HvTv555n05J/vZnGUojw88tjh6eZHSfc2RCg1hGZa2DSDMA9Zr6hYI7qL7KwKdyiGP0x/EQuH64g8W9uLI9qDS/KBrWG9Hmnl+Sirw9vqsecgBVx/jRVaiHxRlYJcezceOoYigTebWTHtK0q4PghB5vIEOqv5Ka/1NFXoW2ffAN6YYRD8XEnJtMepVvZ3wV9EE8Km1NHy8rdOmfN16AprLegjjidv3xD1McEXpMNMiqTrtfO71Lx5uS7xtpZyTUQxE1NAneH86DbweffFdZvhIA9n9FnLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ajbW26Tty/k9dE1nYgjshZ8cwLjO2mGiiaL/GDEyd84=;
 b=ndZCisgKmzsttwWBV6OXVtHHlTsyGr0/TyC0cqbMmTbW9bzUijwajyBDVyUEdRG6UydR+C2ApOgTMxFGJ2Lr3q5Qo/kf7Nv10qDNLqijvKH7M5szSZI9DW+75u1apT+QKAU1sKGRj10olSfFX7fJUITOH+GsYyQkCoYP8zZtskNLEuf4Y2IHE+KaRgs+Ce5eBD4nIuDDlVjcBtF90NBzbHztaDUswjNugEddzV9IfLPRm92o+F7PHFgCTGlHKkhR6SbubMm71OPEz8WFt7py5K7BLC/7NF7FSnIxMKvn2dHj6DoWKUtr4XPUGCix2IQtyQq46GKQzpLDOMLdylFPog==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS6PR12MB754991.namprd12.prod.outlook.com
 (2603:10b6:8:4d2::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 14:33:21 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 14:33:21 +0000
Date: Mon, 16 Nov 2026 10:33:19 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	"Jiang, Dave" <dave.jiang@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	Jiri Pirko <jiri@resnulli.us>, "Tian, Kevin" <kevin.tian@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Alistair <alistair23@gmail.com>
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Message-ID: <20261116143319.GA2245175@nvidia.com>
References: <20261103151643.GI274202@nvidia.com>
 <aurmtTe4ObBQhC4S@yilunxu-OptiPlex-7050>
 <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com>
 <yq5a5wy2qtjs.fsf@kernel.org>
 <20261112145254.GL738765@nvidia.com>
 <DS4PPFA84FA90FC465DE2D4A57521CEB991E77C2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DS4PPFA84FA90FC465DE2D4A57521CEB991E77C2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
X-ClientProxiedBy: BLAPR03CA0076.namprd03.prod.outlook.com
 (2603:10b6:208:329::21) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS6PR12MB754991:EE_
X-MS-Office365-Filtering-Correlation-Id: e5a1e597-8b4d-4b67-d746-08df43ee9016
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|18002099003|22082099003|6133799003|261009223027099003|3023799007|4143699003|56012099006|11063799006|261102123227099003|261102130727099003|261028144727099003|261026140227099003|261026121527099003|261026130827099003|261022105027099003|261021123027099003|261022113327099003|261022075727099003|261021121427099003|261021130227099003|261022115727099003|261021135927099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	ScYmKemE+uxOOD1SezcX7is7S0F9qzMsc1odKP3rLpoPF6G4wGMntk+EXm6/zNylCye1SMOHtcFMcmfja8AAOcjtNnjVgvbdhdi6bXpqLZ2bl/MW0OAib2XhxY7zkD+ZpZW4ih9juWVC52V8o/qWhKu9GqqxmUK1HUDvuPGTgW2bny14nAxwce5QiLCoAStQG+NANLF29+l8xP9a8waq3pHTiAtmJZAntUYe8AfQyIEnJw+a+SSI/f6GSBfH5IdTuBmeZ9AyPmgXEqB+COrDVeUs3dBYnha0b330z7KzpS8KbNE9vP4fROaxFYmaPp+KvCjhspqAvqBVAqW4t1VZBd/A3cVHlpNuFue/BzKr4Y0ynWIOa5ADleVpyKEDPDEZOBm9yWta7nOsIIpyxWi9F/5VS/Bi5d7jx/LGPGFFlOe6z0mh0lo/AyxD39DpV33fidAkF9lDPUtuwxvcdqVoQCWUmV373DaP4Xdjzepi0Y4u46i4sJLYlHPRmGBiROSKmWu45QjulPqCOcB+aYyO8IFcLRnjuMBCKyd/XpMr4VOPcrz6aapmZBZzHureTUy6vBA4bNExShDFFTFhTm5DAFHLZ+FP+gEPxNQCbmx2D8pXB+XSV8cuy43kf+fXBQcrfX2E4ESfWKhKJedx1W7ji5yv2ESDWY6wwv5H+3TJdKM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(18002099003)(22082099003)(6133799003)(261009223027099003)(3023799007)(4143699003)(56012099006)(11063799006)(261102123227099003)(261102130727099003)(261028144727099003)(261026140227099003)(261026121527099003)(261026130827099003)(261022105027099003)(261021123027099003)(261022113327099003)(261022075727099003)(261021121427099003)(261021130227099003)(261022115727099003)(261021135927099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Smg3dE84cXhNS2lDbEdPSXBBRGZDVks0aTFRR3BISUZOZG1ycXF4NjV3Ym84?=
 =?utf-8?B?Qk95ZW9BUjNkQms3aXlJeURJMXFLK3lTbkY5aCtjbXZkVkMyM1VyQmtUOVZu?=
 =?utf-8?B?cm1WdE5nbWtiWXFEV0V0MEd6anRMYjR3TjdJazZUUjN3bGxObGFwbmdyVk1W?=
 =?utf-8?B?Z1lobnRLQU5KbUx3QVd2bnY4SnBDaGNBQWxVeklvT2xLWHg0dnVpSWM3RGZx?=
 =?utf-8?B?VURyUFRBdFpUMk92MVpSU0UzdzBZdmMvcmxHQW9HTkszZ0tGVk9rWFFPT05V?=
 =?utf-8?B?MW1DTFdHR0g3dWxOOUF2STBYREJVckdxUlpvYjlXamJKWENIV0ZRTFpHU3c1?=
 =?utf-8?B?TllFQ2Z4UVpUbGRDRGFRcDhaRVpweDVEWDgvcFBmODVqL2tZYUdMRS9LWE9F?=
 =?utf-8?B?TE9rOC8wQTN5MXl0aG1rYUZEcTBpaVg0VElWMVNFZDVjYWpSOUM5ZWFtR0FZ?=
 =?utf-8?B?Rm5abk02R2Nxd3FzaUgwd2NpSFZDK1UweFVabzNOS0RxbkVTOEkrNk9OdTh1?=
 =?utf-8?B?RXMvRk5rRVpQRXZVNVhqTVV6dTk4a1N0VTJQN0V5VXFHaXk4RHI5UFdBWkZy?=
 =?utf-8?B?ZmFaNEgySkxOR3hSUm1tRUQrQ2RldTB1OGoySlpiMkhPWk8yS0lKckZxYmM1?=
 =?utf-8?B?OTRnVlVMQlVwSmpZVVR0SnBhZU9QU1puejVZTlR1RHJlS2RQcVI1cXY4dnBt?=
 =?utf-8?B?Z2I0SDRITHNvejJJWmlPMk1veGQ2YXAzWmR1NFV5MnBhYUpzTUJsdCsxTXlE?=
 =?utf-8?B?ZzlYcUVwcEJnT3l5S3lFUXNjWkpLN3BYYzJGMzRidmIzRzh0ckZzRHhvMDRM?=
 =?utf-8?B?dTdrM3VmY0pKdW84Rk40UVNJNG51SFg4QS80cCtYK3phZ2d6NWdPZ3BKNito?=
 =?utf-8?B?SkoveWFNTkxOWVQwR21NTFRkYi9remVONzVLK1NMVFFCRUhlcXFLNGlSanJq?=
 =?utf-8?B?RE5tQUZtTExPWnZpNGhxL255ck1TOVg0T2dzUy94K013TnVPVWJCUzZYSnNZ?=
 =?utf-8?B?NnNteFowUFZxaVI5U2NhQnowNGN3YitHQlNCVzF3Q2lGK1dRZzY4azd5QW9r?=
 =?utf-8?B?ZG5HWDlySnRGQUdha0lhOEFHRXlCQjBobjV4cVFhWTZka2hDWEpDN0I3c2RV?=
 =?utf-8?B?NVBuNWlyY01RQThGRDNSeWlwR0RRekw1OWxQaGVOeXBRSmdXQVc1VDNqMGJ0?=
 =?utf-8?B?Z0RWZkRHYnJ5OWMxQ0lBTUZ4NDd2cEtVdVUzMG1lbVR3TTl2Rko0UXNtcENF?=
 =?utf-8?B?ZUtUZVNFWXZ2ZFpVbEtvS1VnMjVFVkgrMkxiQmZaUDA3UDB4ak1EeGtxMUQ5?=
 =?utf-8?B?N3Y1M1RJRU01SjFRRkJQenZlRnNaQkVzWTlkczAwcXN0MENvWlN5Z3htaHFv?=
 =?utf-8?B?K1RrY0FmYmN3L05WL2tuR3JzWDlHcXlpUi83aDk5OHl2SmM4aHRJMWpJNHRp?=
 =?utf-8?B?R2tmMkg2aVVMemgxMTl3SE40cjRESE1JbzJ1ZmxLZ3BGZGhLSHRVRE5GcG8x?=
 =?utf-8?B?dWhQMUllOXUwSXE0VmF6MkxKZ1RXYnFZWFNHUWwvWDRmWWtjeExnZXJvMUZp?=
 =?utf-8?B?ckNBRE5oelN0RHVPOVM2ZzkzS3lrRGdIWDFZcy9XYkZWNnlLSFlUbVFuaXJG?=
 =?utf-8?B?aWJoYklOS0tpTmdRVm9DMUVPZGJ1UW1qNXJGRmxFUmttdFEyUVNLclUxajFG?=
 =?utf-8?B?NXVCM1BrWXArQjZsdXNLZGlaQVZDNmJkRG5VTUVoRmUxK0o5L1JVMm1LUFRw?=
 =?utf-8?B?TWFndmZaMFB5YWpSQkR4UmExWEN6VFNWclh4SzlsUzEzS0VkclY0MjVjeWgx?=
 =?utf-8?B?c0JBMWcvRzJmVXEzcG01NldRS0NtWWlRSXF5emU4Vm5VdXB4a0Y2Smd3dnRj?=
 =?utf-8?B?c1EvbjdQZW9vYlRHQUNHb2pIOXhLRUxERlQxUzhpenQ0ME9HNzV6ZXNvKzVF?=
 =?utf-8?B?UG9FTkJ6c2xzQ0MzUE1BUW9pbGZqeHBMNm1zZlBnS0orSnI3MFVDN0Zwd08x?=
 =?utf-8?B?VzZvWnV1LzBFL3JNSWluUld2OWFjTGpJdFQwY3RmSTdjNjZDVmxxYTVmZnNH?=
 =?utf-8?B?VXQwSDIzMGR1WHZzMXFPYytNeGVkbTdGMC9xNVhIakRFNlRMNjVZUEM4OC84?=
 =?utf-8?B?ajBFeTZvOXQyelY5Rk1LamtmTHU0TXZvK0JyUUhucDFHRFdKUjdvQ2ZwQ2Nu?=
 =?utf-8?B?SnVPeG5lWlNwVTVQQm1JN3hFRFAxRE50V1cvSFFYYlVta3E5NzM3cnFyVlFQ?=
 =?utf-8?B?dkJ0OGRXOGxRZGJWeVVScXhVMDJSSWcwRHhhSWdoZmUwUVhmem1WMEF3RXAz?=
 =?utf-8?B?T1VZRjZRVnRNRWYxUjExL3pZS2FXQTNLNlFNcEFsYnJrN2lCTjhXQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5a1e597-8b4d-4b67-d746-08df43ee9016
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 14:33:21.0739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ewjTzOYitay7eXQmGyW7MvUGqduMfdcfQ26KTbO1m+xTH8jrEuVLIgRcfIszjLVC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR12MB754991

On Mon, Nov 16, 2026 at 01:38:50PM +0000, Reshetova, Elena wrote:

> >  1) No easy way to get the VCA, no easy way to do capture
> 
> My understanding is that VCA must have been included into
> SPDM_DEVICE_ATTESTATION_INFO_T from the beginning, it was omitted
> by mistake and we asked to fix it as Dave already pointed out. 

That makes some sense, but it just makes this struct bigger and
worser. As I explained ot Aneesh I'd rather not have a VCA at all but
the transcript that includes VCA (or is maybe only VCA) with preserved
message boundary markers. Userspace can compute VCA for the purposes
of the signature hash.

> >  2) Wrong digests design for the guest. SPDM_DEVICE_ATTESTATION_INFO_T
> >     is a terrible idea since it is not grounded in any spec. The other
> >     two have multiple guest digests computed directly over spec
> >     defined objects.
> > 
> >  3) Even if you like SPDM_DEVICE_ATTESTATION_INFO_T it includes
> >     TDISP_CAPABILITIES for some bad reason. Nobody else even
> >     exports this info from their TSM or digests it. Thus Intel would
> >     need unique API for the VMM to even build
> >     SPDM_DEVICE_ATTESTATION_INFO_T. Not nice.
> 
> I dont think there is an expectation that there needs to be unique API
> to build this structure (I think we can hide it in the tdx-specific code), but
> your point below is valid: this SPDM_DEVICE_ATTESTATION_INFO_T blob
> needs to end up on the guest side because only using this blob the guest
> can currently verify the evidence of the SPDM connection establishment. 

Right.

Any every other arch can build their digested data in the VMM using
the standard APIs because all their digests are over standard things.

Intel cannot do this because you digested information that nobody else
even exports, and your forward compatability story rests on passing
this opaque blob from host kernel through VMM to guest kernel to
compute an opaque digest over. Again, nobody else is doing something
like this so we have an Intel specific uAPI. For no particularly good
reasons beyond someone decided on the wrong digests.

> >  4) How does future extension work? Oh you probably have to pass
> >     SPDM_DEVICE_ATTESTATION_INFO_T as an opaque blob through to the
> >     VMM. Lovely, so only Intel needs a special Intel specific blob
> >     uAPI? Bah. This is a very bad idea.
> 
> How does the evidence retrieval would be specified between the host and
> the guest? We actually haven’t discussed this part so far, but focused solely 
> on the host part. If you envision that Linux would standardize objects that
> guest can ask host to provide, i.e. "give me VCA", "give me all available cert
> chains", etc. 

This is what everyone else seems to have done, at least that is how
AMD constructed their digests, I couldn't find their guest to host
protocol. ARM has done it explicitly.

Even Intel could build the SPDM_DEVICE_ATTESTATION_INFO_T in userspace
from the common information if it wasn't for the TDISP_CAPABILITIES
and the forward compatibility issue.

It is not really the struct that it is the issue, it is the single
digest over the entire struct that covers something no spec defines in
aggregate.

> Then yes, having a structure like above that incorporates all these
> parts is a problem we must solve.  Could you please share your view
> on this one also? This is also important part of overall design.

So if you keep this then you have to get a uAPI 'give me the intel
blob' to build your VMM with. It is not impossible but it seems
unnecessary if you'd just digest the right stuff instead of a giant
struct.

ARM keeps several digests:

protocol_data_digest = H_rmm(VCA)
identity_digest      = H_rmm(cert_1 || ... || cert_n)
pubkey_digest        = H_rmm(<public key>)
meas_digest          = H_rmm(GET_MEASUREMENTS || MEASUREMENTS)
report_digest        = H_rmm(interface_report)

I'm not sure VCA is strictly necessary. pubkey_digest is because RMM
does not parse x509, since TDX does it also isn't necessary.

So you end up with three digests for TDX that are grounded in the
spec, instead of one digest covering some concatenation of stuff no
spec defines.

> >  7) Lack of an API to do evidence colllection for the host, the only
> >     provided API always changes the guest visible information.
> >     Not nice.
> 
> Could you please elaborate more on this one? If you mean initial
> evidence collection, then it doesnt change and must not change
> (we concluded this already). 

No, again, I don't see a use for initial collection and it should be
difficult/impossible to access in the uAPI. I'd rather you remove it
and stick to a 'tsm generated nonce' instead.

If someone wants one collection they can ask for one tsm generated
nonce from userspace. Having tdx module force a collection is not
nice. Of course you have to do this anyhow to get the basic
information out due to the SPDM_DEVICE_ATTESTATION_INFO_T which,
again, doesn't fit very well.

Also "tsm generated nonce" has to be a global set for the vdevice and
visible to the guest, and unchanging while the vdevice
exists. Otherwise it doesn't work. You can't mix guest provided nonce
and tsm provided nonce together under the same LOCKED session.

> If you mean collecting measurements only that guest can ask later on
> (with guest provided nonce), then didnt you say you want this to be
> always reflected via trusted digest exposed to the guest?

The guest and host can collect measurments independently, and without
synchronization. The CSP may run an audit daemon on the host that
collects the current state of the device to look for tampering,
confirm live update, etc.

If the CSP's audit action causes any guest visible data to change then
the API is broken. In Intel's case a recollection by the host triggers
the guest's digest over SPDM_DEVICE_ATTESTATION_INFO_T to change.

For TSMs that work this way they will have to disable host evidence
collection inside the driver once a vdevice is created and cannot
support host audit. It is not optimal.

What you want is an API to retrive measurements for a vdevice
triggered by the guest that updates the guest visisble information

And another one to retrive measurements for the host pci device that
doesn't change the vdevice at all.

Jason
