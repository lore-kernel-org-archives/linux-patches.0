Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010002.outbound.protection.outlook.com [52.101.201.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9624F2F1FD9
	for <patches@lists.linux.dev>; Wed, 17 Sep 2025 14:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758119762; cv=fail; b=szyVPjEh4Bw4eoyCU5PVPXE9eFrQ46jAiEEgiUBquVtHYa/hqnwh91P80cGvwC20GDYDLih1v4f78fPcGeQ0N931qhiL5by6DngeFxc64pLsqI3iCxniEnx4KF7RALVOfYIT6fx1oUjhuC4uQ5p8uP6aeZ0Z2aCq9q7VwEwAVgs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758119762; c=relaxed/simple;
	bh=nCGPqIw0RcptQp3Spw2wh2SU6wW6l9Di+H3cLvqoeiI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PWkvhnXJxtGK/4hdn7zAnJ2rBZeG8MWTnLTOShh5A3UU7ZLDCbqGNPzW3yD29acpsNRn3+9n4DpAOEkuDTSh95aFfTXYfeqX70j7oOrXWBMt7zS8gHnP2KXy+auOJA5Tp6S0qvXTPZxHDrLGvkNxvC0R6q1YHKxoLFq2y+dviuw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5GTZZMeu; arc=fail smtp.client-ip=52.101.201.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5GTZZMeu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xWOB8IiOUOKwiE5g5skEQTKiC1Pfr7Bmo5I6H/UleSHNmwfF4k5RbP64eMyzIKbTPkc7EM9yDH+OIR2tLANTylP3AJ1uBuZxMAqcFyUYkuohA9472m/QW7TzE9QuBCzEGlIecU6++l2h/HKkE59TTAz3PnVm8clW/vxGvCi3HML8lY4+4NLblFf2kSRev8HL7ZsF4MTOS7e7WtU/cXuYnSxW1Q41MxPWg//0bPtl4NBCpd9RaAfmG6QJTeEgyeLAF/cQivBOyNR6y7cMbrFqaQ8uSoHc3FYNIVCFDl94Jas108SpVabJAVvOOSdn29k/0AvKpC3d2XqzF7aOZNj/6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nCGPqIw0RcptQp3Spw2wh2SU6wW6l9Di+H3cLvqoeiI=;
 b=SfENzkNGGiG6nrTiOz1NX+WMCBOZrIVnyEjx0SoBtRArtlpmulPyQ21Vb+LCrrxp09jM/3/LnAe3NsQ8pevwskbrv7ewBSTWt5avGnm0y4U1lEJFz0AIapVwpxAJPIAa8gDOFzvxf2BAHXH3eG/H9meM3kWWX0RYRzqTdP8ajTM0KSNrXHQkNK6E+TAdegPRdIiZHmn8VZoRDIwEbKvf3Jv7CeqVRez7t+4yfeeLsBt6VxvilKlN5o2v5qbi8mXDM+yATZHmnmRZImR3+JxICYVCO42xjrQmTDEX2y213/x7WYgj85/gVfeA+eH78ekBUQ06FJPBtJiaRy2diHEBwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nCGPqIw0RcptQp3Spw2wh2SU6wW6l9Di+H3cLvqoeiI=;
 b=5GTZZMeupBBsC8Z8FbFhLUgzCCYSFh9k6iMiojXDirWtdM7oXbirf+ltdWZpwONj9lfSz5I4klvjg2x+Fj3KrGSXbKMbE0V/8ld0ku//zo+ybZ7ZogRyRiKpgU1nq63chhgCwKpYhoMqcEyIQgHVXUhiUbU+yBo+NHLkwFtTPRg=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by PH7PR12MB6936.namprd12.prod.outlook.com (2603:10b6:510:1ba::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 17 Sep
 2025 14:35:56 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42%7]) with mapi id 15.20.9115.022; Wed, 17 Sep 2025
 14:35:56 +0000
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "cao, lin"
	<lin.cao@amd.com>, "Prosyak, Vitaly" <Vitaly.Prosyak@amd.com>, "Koenig,
 Christian" <Christian.Koenig@amd.com>, Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 6.6 100/101] drm/amdgpu: fix a memory leak in fence
 cleanup when unloading
Thread-Topic: [PATCH 6.6 100/101] drm/amdgpu: fix a memory leak in fence
 cleanup when unloading
Thread-Index: AQHcJ9LdUtxY1hUQg0u/+qLQP6CoNrSXcOYQ
Date: Wed, 17 Sep 2025 14:35:55 +0000
Message-ID:
 <BL1PR12MB5144611EB7684A4E01F4350BF717A@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20250917123336.863698492@linuxfoundation.org>
 <20250917123339.245422525@linuxfoundation.org>
In-Reply-To: <20250917123339.245422525@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Enabled=True;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SetDate=2025-09-17T14:35:20.0000000Z;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Name=Open
 Source;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_ContentBits=3;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Method=Privileged
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5144:EE_|PH7PR12MB6936:EE_
x-ms-office365-filtering-correlation-id: 9ad463d1-12d5-49a3-c62d-08ddf5f782fa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?TVhKOEJIM3lVdVRlcHlETDh6NnpIVlRPZEIrRU9XMytRV1ZTam5GSHlzZTdU?=
 =?utf-8?B?cGpIaWtDd05wcEp3dExqT3NpUU9zNEJXOGN6VHM2QW1DalVZbUdFSzlob2Z2?=
 =?utf-8?B?RVozSzluKzUwemZvcEFreFk0bHUxektKV2x2STlSS1dMUVdTSnhXekNpK0p2?=
 =?utf-8?B?MjZaNlZDY3YrNDZhUUdlcWZ5ckJUeHVYS0ZNb2IycVJSTjZmRDlaQUQ5SW9Z?=
 =?utf-8?B?QmVmVUxnSGNWSW1sNlZuUkY1dWdjMER1WEtBL1BPUTk3WDZ4emF6Um0wRmhl?=
 =?utf-8?B?dmpYTzlvcGpvWU83WjRzWDUvRzA5VjNIRDZBZ2laelpaaEtKeHJpdTNGTjg0?=
 =?utf-8?B?aXhPV3E5SDk2SG51VlREK2pyeWFJYTFWMGc2MjIzREVzNUJZcmQvMGg2ZEh1?=
 =?utf-8?B?TE5zMkZBRitmSDZvRkx0N1FIdW9sWmFLYytPMjNQZTN5cEduL1JsbnRIaWZw?=
 =?utf-8?B?c1pnS2gwWWlZc243RmpWZ3NjbnoxcSszdUN0K1VFbmxvSkV5dFltMmdHajVw?=
 =?utf-8?B?ZmpDSjJQdndaUE5FSXVQUUcvMk9KN0VHcDhKRDRiZ3lmemhqVmRWRU1NS29W?=
 =?utf-8?B?VURmT0lLRFRmL2xBQ2V0SGk0WVUxZU54TmlzUU5OZXpVYWxxZEhHSjlRSWlp?=
 =?utf-8?B?bFF4NkNTUnRmVWQweDkvUXFEejFIYnhhdnNMNGZpUjdCRUVxVndCWHhQUWh3?=
 =?utf-8?B?aEE0Q2JLYXZ4eDhTQUZYdlJ6SXZZNDhwaFgybTRya0o4cUo5bjVLOFJ2OTNa?=
 =?utf-8?B?YmlnRUhldUVrWmpWdXVjZGFCaHFDMjdFNGFMWkxiRzc3TmZhditibGkzQUV2?=
 =?utf-8?B?bGhIbW5YK1FWZVIvbEVGSmxtMmlZbmQ1cit3c0hSd2hkejkrRzg0S0lVazZs?=
 =?utf-8?B?N1VLTE9SNUhEalB3OWI0TmtIazN2OGx5M1JWeE1Bc0JqbVZ0TERELzdid1Zz?=
 =?utf-8?B?L1p6L1RsNko2aVRpMCt3M3g4cVpwMU5Ma21uaFZZSk5OdnJ1NWFVVS85aEZn?=
 =?utf-8?B?RTVIZ3pmNjlwQXkyOUZOU2RPdGFpTS94Z3ZHbXNhRUVNOEhOdGdlSWwyaHZT?=
 =?utf-8?B?N3VTNEZYRy9PMHlkM3lxWXZJMERleW5YeVhxSDdBZWhVbWRobmxFYk9DUWw2?=
 =?utf-8?B?NUZsWXQ1WlNDeEFJdFozWE4wMnZPTzBTRXUyY21rNzczazR6UExwSkFkZWpH?=
 =?utf-8?B?ZFNwTS9LazhUeGh4ZlNlY2FUdVhoT3ZmRW1zYTdINFE5U2pjeDcyTENYSy8y?=
 =?utf-8?B?cURWZU0zelBFNkFQZkJ1ZjJ4dDAzNG4wTHlVNVJjc3pnK1pNRDI4NFhZajlm?=
 =?utf-8?B?aDJ2OUZSMmx6NkNUOFkxaWlkaVphb1oyc2ZveUw4ajVOUWU0alJpbEIxdGRS?=
 =?utf-8?B?bXpWbXJZbnAyZ0FXcVNEUGdsd3hONzhmeUlualhtVUpEdEVWR0tFbGdhK1cz?=
 =?utf-8?B?a01PZW84TU5VUDFKc1Mya0V5U1RsRE81QVVmajdVOTN2ZkJCdSsxSVVGa0lx?=
 =?utf-8?B?OW13Y0krVEN2TWN1RnB6NThZTFBQbGpxQS8vbTJJTkFNbUxsU1JTSVNXbFM5?=
 =?utf-8?B?Tm1rS2xFMzI3RGZZMXFnT3RXbnVRMGk5VTR2MUg4NWpsUHg4cUIrMmZsZGxw?=
 =?utf-8?B?TDNVcmxxNXNHWHJCeDlrVWZnMWpreit0dlRYeENETWhpOHRMZlF6cGhjTXNw?=
 =?utf-8?B?cUZaVnVFbHMyMGt5eGk0T0FKRmN1UC9xWnppT0E0d3M1aG15bVBxSVdJaGVP?=
 =?utf-8?B?aUhXR3g3OHRxVXpRblBqL3U1cGM2YmU4U0U1WjZxYmk4bkpFYzhKSzZuY2pB?=
 =?utf-8?B?SVFlTExtZ0FVakZmSEhSUmFVYk9OWHB6aU9XT3MxLzkrTFpnTTdtZDNLTjBp?=
 =?utf-8?B?OXIvRVFpMnVUQ1lRWTQ2ZlZLN21HbCtYcmxTQW5kZ2UxZzRSa05wb0psdCtK?=
 =?utf-8?B?TGRMNGFrNkVuVC9wbWlFRlVkS212aFVSdktqL1dNWUZqVndzMlZyZEpBV05F?=
 =?utf-8?Q?clH4rzX6hXd33uyi2EZmfqQ9ehG9GI=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZWhuYmN1eDBhNTR4RURnRk15VEZhalFXbUUwZSs2eXpHOWQ3RjB0Z2xrRlVP?=
 =?utf-8?B?VzkxLzIrZWNYcGI3SkszaUVsQjBMMmNzczlwdUZtclRhNFY2bFUyVzYweFE4?=
 =?utf-8?B?c0RNMGJBSTg3S1BIbjVWTzBmVHEvRnBlK0dISmpBNFZiS3NNY3FVMkIvNVJz?=
 =?utf-8?B?a2loM2M2WnBlZ0RCekliT2JkNURrWEtXbzlRbHVrR1NyM2pOcU5uMVIxbE5h?=
 =?utf-8?B?UGpaVmZ5VUloWmJJeGMvejFUdEdhazJZMkxFSlNNa0ZRbzNxZnE1YWRWeDlj?=
 =?utf-8?B?RjF1V09XaVdaSFBkb0ptNlFaMDArRFllNmMyTnREa0RaWlQ0YWpqYXFSVU1k?=
 =?utf-8?B?cVY5VHhCTFhiai9YU0VTNm1VeGVqUEY4M2RmcGQ3M1YrRGNzd2RVRWRXZjdv?=
 =?utf-8?B?SStIMUs4OUlBNk41NHVtOFQvbFhPaEdVZEV5TGpIMzY3b2dLYjN4bjUyT1B5?=
 =?utf-8?B?VUdIOGRIUzAvM2ZHZkUvK1FBTldJWHhoYzdUNHV3Y25pZ2dueXVoN1FVc0tB?=
 =?utf-8?B?VFZGTm51cUJqMi9VR084MnhsZk1sZU5ySTFvTjlNNjY5UGRmVE9maUFsZys0?=
 =?utf-8?B?SGlobEFKM3JnNnYwdS8xRE9LVmZzT3RkYTZaNHgwTHVNNkRsck1ZcGxybkhl?=
 =?utf-8?B?ajd4M2NoQzZtRm5VU0dBakNwODRpTVpjZitJUE5rWTl3ZFQ1TUFDaHZSNVRL?=
 =?utf-8?B?cWlGMkxMdjdVMFhJcjd1bDVBSkU3NEdpcXAxWG0yYjhVbHg1NW1iWFV3T1Bm?=
 =?utf-8?B?bWdvMWg2RGhJN294T3lmcDdWeWMrQTBFTEZVT0NBSE5pSXBhOWNDV2dhUmgr?=
 =?utf-8?B?eXhxNEI2dHlNdkhJOUxlaWVZcTJEc0MxcU44eDZxUkZzazdCVzBPTm1ab09K?=
 =?utf-8?B?ZGNXZmZsWjFsOU1kL1A5a2FLY0ZKa1hyTkdkRWVoeWRQMHRDN1VkUVprSlhB?=
 =?utf-8?B?T3diaXJ3eVAvNUVxbWdPTWpDempVZkpuLzZhZHJWWWN4dTB3K3Z4bWNhWTl2?=
 =?utf-8?B?MWhMVWR4cm8vUDRlLzQ1OHNpamtMM0Q3dlh5N1pQMHJLWXNobVVMTDdFRE0z?=
 =?utf-8?B?VGw3WUptSXFSWDRRcHFNNU02WUlGaGt6UkNBQjVwSmZmZ3d3TU1vcnlWd1h5?=
 =?utf-8?B?a2ZJcGNIZ0QvNDhLbzNBK01BWUQwUC9ld25ybEsrKzJROHBZV1VaMmxwRGpo?=
 =?utf-8?B?Y0NJRmVnM2pWQzdvU05vaHBtWkp1WTk1bHBiY3p2RUxBNG1YdzZYdEU1RDY4?=
 =?utf-8?B?L2NMT2JzNGhjS0ZGb1ZrazhiV0g5UkZaN1V0cDJKQTZIM201Syt2WHY0TVV5?=
 =?utf-8?B?RmFhM0QyVTlnVEJRejc0aUV2bkFMT01rNGRLdWJDUDJFWGI4ejFtYzJreCtD?=
 =?utf-8?B?OFl0a0xQNE1va3hvNXE3OXBOS0ZmTUxXQmx6UWhZOVJmZ0pvNi8xMks5VXJB?=
 =?utf-8?B?QnRaT1lNbS9kMFZEYlZEc1VqT252YkEyYzNmSW5TLzdBVDViNmRLM3ZtdVZy?=
 =?utf-8?B?eC9RcC9ZZUhFQlB1OVF3Y3BnTmVocmVNc0pqbXg3S0xzMFVVd0pDNHlLTGRN?=
 =?utf-8?B?MklqbklKZWNuTjgybVErRTN0ZUg2Tk1pUDlJNnNCQ3FPcXdPOFdQRnVyWnM3?=
 =?utf-8?B?NEN0c0pQOFdZWWlSMGg0Y0gveVFTTEJUYStFYXZsWk8ybFpSME9EcVBGTnFS?=
 =?utf-8?B?Njh0K3IyV05YOWFpZVptZWtWTFVqaVNZdE5kZUZNMXJ1bHJ3bVkwWTdDL0p6?=
 =?utf-8?B?QnIwU3VHRHVYQkxGbUxQSTRzY24zdFhLVFhtMWpBUURaYkMxckJ4dkVEb29j?=
 =?utf-8?B?bnJ2K3dGMkpCaHRqbEZRTTNTeHdrR0NBNWdjQ2N2bThQanJKVDZnbGFRaE5a?=
 =?utf-8?B?NXdzKzBOTWtleUpqQyt3aGpnbjBMZDJ3ZG5lKzF0K3hTUHZZY3VLZ296Ym95?=
 =?utf-8?B?bEdBUlBhSW4rY01wTSt1RjJ4cURNNXpUUHhLd3Q3czAxZ2I0dG9LcmM2SjhI?=
 =?utf-8?B?SmU2MVFQZGJhWGxnYnpkOFNrTjgrRkdtSDh5azQ3QWtzNE1iSEsxWFJRekds?=
 =?utf-8?B?QU5xalYwS0w1THZkb1R4WGpSQXF2MDE4K2hoWkZibUVOQnFITmU1MENzVDNY?=
 =?utf-8?Q?icMQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ad463d1-12d5-49a3-c62d-08ddf5f782fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2025 14:35:55.9285
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3lUhXiXXQP/lWUXfqiDUT6RrQlVDl7TvD19q/ic/fquoQm/x0zDGIEEB45mPiXlrWT4GPX0+S/4fdngTVuQ85Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6936

W1B1YmxpY10NCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBHcmVnIEty
b2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0KPiBTZW50OiBXZWRuZXNk
YXksIFNlcHRlbWJlciAxNywgMjAyNSA4OjM1IEFNDQo+IFRvOiBzdGFibGVAdmdlci5rZXJuZWwu
b3JnDQo+IENjOiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3Jn
PjsgcGF0Y2hlc0BsaXN0cy5saW51eC5kZXY7DQo+IGNhbywgbGluIDxsaW4uY2FvQGFtZC5jb20+
OyBQcm9zeWFrLCBWaXRhbHkgPFZpdGFseS5Qcm9zeWFrQGFtZC5jb20+OyBLb2VuaWcsDQo+IENo
cmlzdGlhbiA8Q2hyaXN0aWFuLktvZW5pZ0BhbWQuY29tPjsgRGV1Y2hlciwgQWxleGFuZGVyDQo+
IDxBbGV4YW5kZXIuRGV1Y2hlckBhbWQuY29tPjsgU2FzaGEgTGV2aW4gPHNhc2hhbEBrZXJuZWwu
b3JnPg0KPiBTdWJqZWN0OiBbUEFUQ0ggNi42IDEwMC8xMDFdIGRybS9hbWRncHU6IGZpeCBhIG1l
bW9yeSBsZWFrIGluIGZlbmNlIGNsZWFudXANCj4gd2hlbiB1bmxvYWRpbmcNCj4NCj4gNi42LXN0
YWJsZSByZXZpZXcgcGF0Y2guICBJZiBhbnlvbmUgaGFzIGFueSBvYmplY3Rpb25zLCBwbGVhc2Ug
bGV0IG1lIGtub3cuDQo+DQo+IC0tLS0tLS0tLS0tLS0tLS0tLQ0KPg0KPiBGcm9tOiBBbGV4IERl
dWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5jb20+DQo+DQo+IFsgVXBzdHJlYW0gY29tbWl0
IDc4MzhmYjVmMTE5MTkxNDAzNTYwZWNhMmUyMzYxMzM4MGMwZTQyNWUgXQ0KPg0KPiBDb21taXQg
YjYxYmFkZDIwYjQ0ICgiZHJtL2FtZGdwdTogZml4IHVzYWdlIHNsYWIgYWZ0ZXIgZnJlZSIpIHJl
b3JkZXJlZCB3aGVuDQo+IGFtZGdwdV9mZW5jZV9kcml2ZXJfc3dfZmluaSgpIHdhcyBjYWxsZWQg
YWZ0ZXIgdGhhdCBwYXRjaCwNCj4gYW1kZ3B1X2ZlbmNlX2RyaXZlcl9zd19maW5pKCkgZWZmZWN0
aXZlbHkgYmVjYW1lIGEgbm8tb3AgYXMgdGhlIHNjaGVkIGVudGl0aWVzDQo+IHdlIG5ldmVyIGZy
ZWVkIGJlY2F1c2UgdGhlIHJpbmcgcG9pbnRlcnMgd2VyZSBhbHJlYWR5IHNldCB0byBOVUxMLiAg
UmVtb3ZlIHRoZQ0KPiBOVUxMIHNldHRpbmcuDQo+DQo+IFJlcG9ydGVkLWJ5OiBMaW4uQ2FvIDxs
aW5jYW8xMkBhbWQuY29tPg0KPiBDYzogVml0YWx5IFByb3N5YWsgPHZpdGFseS5wcm9zeWFrQGFt
ZC5jb20+DQo+IENjOiBDaHJpc3RpYW4gS8O2bmlnIDxjaHJpc3RpYW4ua29lbmlnQGFtZC5jb20+
DQo+IEZpeGVzOiBiNjFiYWRkMjBiNDQgKCJkcm0vYW1kZ3B1OiBmaXggdXNhZ2Ugc2xhYiBhZnRl
ciBmcmVlIikNCg0KRG9lcyA2LjYgY29udGFpbiBiNjFiYWRkMjBiNDQgb3IgYSBiYWNrcG9ydCBv
ZiBpdD8gIElmIG5vdCwgdGhlbiB0aGlzIHBhdGNoIGlzIG5vdCBhcHBsaWNhYmxlLg0KDQpBbGV4
DQoNCg0KPiBSZXZpZXdlZC1ieTogQ2hyaXN0aWFuIEvDtm5pZyA8Y2hyaXN0aWFuLmtvZW5pZ0Bh
bWQuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVy
QGFtZC5jb20+IChjaGVycnkgcGlja2VkIGZyb20NCj4gY29tbWl0IGE1MjVmYTM3YWFjMzZjNDU5
MWNjOGIwN2FlODk1Nzg2MjQxNWZiZDUpDQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+
IFsgQWRhcHQgdG8gY29uZGl0aW9uYWwgY2hlY2sgXQ0KPiBTaWduZWQtb2ZmLWJ5OiBTYXNoYSBM
ZXZpbiA8c2FzaGFsQGtlcm5lbC5vcmc+DQo+IFNpZ25lZC1vZmYtYnk6IEdyZWcgS3JvYWgtSGFy
dG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+DQo+IC0tLQ0KPiAgZHJpdmVycy9ncHUv
ZHJtL2FtZC9hbWRncHUvYW1kZ3B1X3JpbmcuYyB8ICAgIDMgLS0tDQo+ICAxIGZpbGUgY2hhbmdl
ZCwgMyBkZWxldGlvbnMoLSkNCj4NCj4gLS0tIGEvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUv
YW1kZ3B1X3JpbmcuYw0KPiArKysgYi9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9hbWRncHVf
cmluZy5jDQo+IEBAIC0zOTYsOSArMzk2LDYgQEAgdm9pZCBhbWRncHVfcmluZ19maW5pKHN0cnVj
dCBhbWRncHVfcmluZw0KPiAgICAgICBkbWFfZmVuY2VfcHV0KHJpbmctPnZtaWRfd2FpdCk7DQo+
ICAgICAgIHJpbmctPnZtaWRfd2FpdCA9IE5VTEw7DQo+ICAgICAgIHJpbmctPm1lID0gMDsNCj4g
LQ0KPiAtICAgICBpZiAoIXJpbmctPmlzX21lc19xdWV1ZSkNCj4gLSAgICAgICAgICAgICByaW5n
LT5hZGV2LT5yaW5nc1tyaW5nLT5pZHhdID0gTlVMTDsNCj4gIH0NCj4NCj4gIC8qKg0KPg0KDQo=
