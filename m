Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2071.outbound.protection.outlook.com [40.107.102.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582F81E3DE7
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 12:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739969949; cv=fail; b=Ldp1UORs6YeQ7vXYkBjxVDdUboPjl4kAl6vJDNPwSJr+RPw9ULc8TgjU/Fmp/UtPaMMDHctR7VTdGAKVf0CXE5T1GYwg9Bke3c6Wwvl6p9HZJHpGGNz//23KzpocTzc5pB2UkLPNmxWad+KTa7h5QTKFuwVIxROYQ6FpyR+Ozc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739969949; c=relaxed/simple;
	bh=456h8zrwcpLnihKrHwHVpO2Uk1ROMM96SQFgwQ8sxko=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RYC5rDtioHctatGQ1B5nkQdyXrn4hdwocAFNadAQoxnworUaW15BqidU2x4X1YR8SF3t99Vqnx0cCCjszDBUdvn1s0B6kliY2kqaPiRtlSmVho9rqzjap91rpb/OlxgAWRdgAfhmjP+AMQKc3lInToUzb5CSOqRou43gwOnXLZ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2x0sNzKC; arc=fail smtp.client-ip=40.107.102.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2x0sNzKC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vUdYVwTdwJWnCmtfg4zeFqzFbfG+n4VSeWDUPLrkU07XsO94cWZpdr3l6ffkY+nYnTNQFedrvrEt83a92GTZ+WCmklSkVSZkSnStyfaY/GZx02zcoGLW4FT0u8F7nH8GMXCGfPW7NbKergN02oBj2eh8cyuqz4kKcJa/NxEy3WdKX/HCnZcFsl7rgNYIOijMRxpv/sWVOqR+MVhIhnGwOqZESDdyCa0tHTscyKuhuMfmx+S2+dqwbGkCln4lCAc/mTtbnlD0LLjR5huXmjscJyRXk+GPLvfJELXgR/6t6Vgugvbd4+5tRohWk8SHmbaNAUzwe5EQoHh6nBcc1Zz/xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=456h8zrwcpLnihKrHwHVpO2Uk1ROMM96SQFgwQ8sxko=;
 b=t35WeIzfFEMdiepDSHuXBHH2OzZfk/W96+f+apD2LaS/CWli3pdr7e7lBX1xadZIqkJj67INlBGbXtiRqIeeyyqBpE8HYQ8m+DTOcmM0TtfnLhY/5YDHRb/Kyd0n0ZGNz9OuXnaRKo7ccMQZLZz7WKYaQkzXTp7F/rqTrHmJF/+FXLOz7vqMRz/xth++sVCuBthNw9S4b39hGLoWmCv4zOHfg0+hmEMiauWrsVVyfykhIdowVMZu/dpPgUD7LZv8Owo5Q+qmJb2t61UH8dLa2NeZBaf3rjpaOFTDc+/1nv/HojBDbJsoV/JqbjHi7wLl5ow6QGSceY63uCBH3QaUUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=456h8zrwcpLnihKrHwHVpO2Uk1ROMM96SQFgwQ8sxko=;
 b=2x0sNzKCyelpz7sTK/zKBF3oCCrCs+MJnIgIi9W67Rm+x01OwhBDYQgOLYom+TNspdJN/HEIuzrCOakMCNGWywrvjSF/Q9a8MoKoncSjf09ivQ0QBW8jREKTfHrdjlr72HBUhLHEe43btBoigkbKCraO0sOKBuNWnRmWdb+hM2U=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by SA1PR12MB8859.namprd12.prod.outlook.com (2603:10b6:806:37c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.15; Wed, 19 Feb
 2025 12:59:04 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42%4]) with mapi id 15.20.8466.013; Wed, 19 Feb 2025
 12:59:04 +0000
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	=?utf-8?B?QsWCYcW8ZWogU3pjenlnaWXFgg==?= <mumei6102@gmail.com>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "Lazar, Lijo"
	<Lijo.Lazar@amd.com>, Sergey Kovalenko <seryoga.engineering@gmail.com>
Subject: RE: [PATCH 6.13 116/274] drm/amdgpu/gfx9: manually control gfxoff for
 CS on RV
Thread-Topic: [PATCH 6.13 116/274] drm/amdgpu/gfx9: manually control gfxoff
 for CS on RV
Thread-Index: AQHbgqlQHEBZS8MDhEa7+e5/oNua3bNOU7uAgAAChICAAEAsEA==
Date: Wed, 19 Feb 2025 12:59:03 +0000
Message-ID:
 <BL1PR12MB5144E9154076E6EF0549170EF7C52@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20250219082609.533585153@linuxfoundation.org>
 <20250219082614.161530240@linuxfoundation.org>
 <96738386-9155-4eea-b91d-8590ef3b4562@gmail.com>
 <2025021944-imaginary-demote-31d1@gregkh>
In-Reply-To: <2025021944-imaginary-demote-31d1@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_ActionId=5e3ea703-879a-44f3-84cf-d6988adc97a9;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_ContentBits=0;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Enabled=true;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Method=Privileged;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Name=Open
 Source;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SetDate=2025-02-19T12:58:02Z;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Tag=10,
 0, 1, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5144:EE_|SA1PR12MB8859:EE_
x-ms-office365-filtering-correlation-id: 11c5dbf1-c111-41d9-03fe-08dd50e53008
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?T25QT3Q3czBsTWlvWVlIN045S3U3ek5FMWR5aThDSFJsRXpSUkRTWGdIZFRN?=
 =?utf-8?B?WWUvck9KOFBMaUp4aWQwTGtoV0w5ZU9JTVQ1VDVNVWxQeGVQYlVCM0oxSTNX?=
 =?utf-8?B?ZVAvakhsK3p2ejlObHNrcHkrVWh6VndnTmN3UmdHc216WkN4NTNzQkJiNWE5?=
 =?utf-8?B?OFkvWUN0VnhiOS9ZVWhHVTlsZG5tUEd0TzlwWlpaSXRwWXA2RmZwYVV1YytF?=
 =?utf-8?B?dko0Z1BnWDJDcnJEUThlcExKMmVDajRQUnc3bUVSb1krWVgxMlE2Z3RLV2lC?=
 =?utf-8?B?QmRYaUNLaHNiL0F6akdXNlUxQ3owZzJoUDJlSm51M0VIai85SkR2NnpMaTA3?=
 =?utf-8?B?Y0w0Z05JK3V1eFIzTStUSmN2SUV3cU1BRlg2Zkh6c0ZWczJlcmZyNTgyVjFj?=
 =?utf-8?B?Q1JNRzNGM1ZxUGtudnpsZ1B2QWhjaEttbHpHaHhBVHZRWFduSCtYdXZ5T204?=
 =?utf-8?B?aTNOOE9oVUR1WHpVakpUVmwvSlR6UU0zZVliOWxPK0ZtWm5tQVllMk84Vlpn?=
 =?utf-8?B?eXJHb2RWdGE0UzNmYjR1bEhHVDRkc3dHV3FIZ3kyMmM5dDVrelBsM0kwME4w?=
 =?utf-8?B?MHVPbmdPWW9YVStjZU8zcncxUzQ5WE9DNjlEUUxiMUZnY0hhaUtOQ0VIUFNZ?=
 =?utf-8?B?aHo5ZW0zWGhabDBhSjV1Sk8zMlZNU0tXRjkrUkhIT25CWm1WMTBQYWNZQ3Nv?=
 =?utf-8?B?RldwUTk0TkdZZFdOSEY3T2xFVzhFSlpUZUZxZ0pjSzgzYU5Xa1YzbGdrV3M1?=
 =?utf-8?B?RUhwam5JV3B2Q21uSk5jVkVwMkY3SWxTMXFvS1dMSVIyT0dqNFlEYnB3OEsr?=
 =?utf-8?B?Smx4Z0VJVWJlYzA3T2Z1cHZoVlZWSjVJeGRvdTdzamNVWXFLN2pMRjhHUEZs?=
 =?utf-8?B?NFp4K1ZwM3NHeXlPTlR4Q0NGMG1jWEN3aVZYdmZWRFVrUUpiNzhkVnhhdEFp?=
 =?utf-8?B?c29QNGEyYzFvRXZOVS9TUHJQdmluZnJ2NHhORTFYejZ3M1F0aW5jSGF0Uk41?=
 =?utf-8?B?bGxGZXZ4UHdTcFU2MlhpaHJ6dHpjS2FHVlNhTEYrZ25LbUorNEJ3Z0dqOEwy?=
 =?utf-8?B?NnJkbEFIMmFoWXdxcXdUb2IvWkVYRkVJNXFZaWNsSGJoRU9OelJWbURiOHM4?=
 =?utf-8?B?MnkrUnRGNHNjSXpDc1o0a2ljSUxtN0F3eURVUUV1bmE2VDBNdDlQR1hQeGdP?=
 =?utf-8?B?ZmFFR05sNHY1dFBCUVRtdWxSTjN0MHZaTDlRUUsvVlZIVm5Eak5qOGVNSTVt?=
 =?utf-8?B?aFVZQW51MVp2cERwTThoWnZ5VmFoWklDSTZlTUNSYU40U3dnWTBsOUFBTDVj?=
 =?utf-8?B?YTVqWFpvQkJHWHk5ditIWi85WXJXRDR4TzdyNmxqQmRzbVdLaVJYTC9YeXBp?=
 =?utf-8?B?MDJlL2FwU3BVdlBiZjlXLzVyMzZaVDN0R29uaFB1RXJobUkvZzJhSGVWZ3Vj?=
 =?utf-8?B?bkdhL3VRTGMvQ2IrZjZwV3lDNXVRWFNWSkUzR3FOT1VTVnpOcHdCZU91ckJ6?=
 =?utf-8?B?WGNKVzdoMnFkeGIzQzdrZUF1MGozVGtnRzMrMFBMM3ZFYk5RYld4U3lTNklu?=
 =?utf-8?B?bFMxV1JNVGRaY0JLaG45azRQWU1XNG96cC91MVJSbzRVWVV2djhvMzlPVVdn?=
 =?utf-8?B?S1R3ZlBIclFRK1MyU2RqZTBKSU9oaDFKRCtia3dObVRjaFUweTNxZndnR2oz?=
 =?utf-8?B?bWFPdXFZbzBGcndJQXFicUtacnVuZWpJZnptZ1FnQWxQN0ROMHczcitqTjNE?=
 =?utf-8?B?blMzQk82SWE2V0FQeGRVSnAxb3N0UWEwSGFXbytOckNqQnR3NFc3QjVRYXRq?=
 =?utf-8?B?cVdtbHFqbjRVVnRrYStmcENKVnNKK25ST0ZVZjcvQUNGWEdUZm5hWHdnTHcx?=
 =?utf-8?B?U0h5REZDK2dtaU8zeXNvRXVwY3NZSGZPZmlDdWV4d0lidWNIbGhMQjZIeVFY?=
 =?utf-8?Q?/E1Q5a69/BCAQseFW5ayJzdi37st6exu?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UjJLSHp2cVkwUGhkYVYvVzZSbXJHTE5XNzBrSFhPdngwY3ZUVXRSTjhkQlIz?=
 =?utf-8?B?QWJneEV0Z29ITkNMbzlNd2tYVFNNYlBmbFEzRktmNUY0UGwvR3B6SzNVbkhy?=
 =?utf-8?B?NzdqWDhwaEoyamtSVi80N0svWFJpM2FQVkxPSDI2UUtQRUh2Z2M2bjBFVTZL?=
 =?utf-8?B?ZWpVVWV0UzdBVHJOSGxzbmhuZStyRkZmWDlPNW4vZTN5USs2NWVBL0RTWUhw?=
 =?utf-8?B?Rkhzc0Roc2tubS9KdFJVb1J2QU5JOFFOSmtRYkp5VzRHWktuUkxjcDY2NDRS?=
 =?utf-8?B?b2xhbzZ2aU9jOWF6ZFFLM1ZZaUl2RlJsYk14bzh1ZlFpb0VWbmZ1cjJRTnYr?=
 =?utf-8?B?bGpzM0Q5b0wwK2FVcDM5a2FJdDRWbVFrVjE2Y3FHbWp2MFpyOVVmc3FyZ0RG?=
 =?utf-8?B?MmQ0S29BR1FhOVNOOFpvOW9BdVNId0cwRjZVVllXK3EyT0FDbjRmSURFMlpx?=
 =?utf-8?B?akQrNkJxTzVpTm1ybHJBYVV3Y2xXWVRnc1RrOXFFVFNWQ3N5TWQ1MFFSRFRo?=
 =?utf-8?B?c2ZwQzduRXNVdUVYV1Q0cWVOU1dXNU1NMEJNVFRnbmVIQTdDaTFEbDE0VFUr?=
 =?utf-8?B?NWQ1UnNNTVJGaEZnekhBNUVrMGRNL1VnNk5OcUw3ZlEzNmJHYWVLSEUwOFNC?=
 =?utf-8?B?bTNFUmZWZXBLdzc1dSszZGNjeUdTQW1aUVRQRURhaUp6bWJvaFQ1eW1Bdkxr?=
 =?utf-8?B?cWF6bG1FRUZxa2dBQXVUckZJbXZzbS9SYVJvTGJTazlTYTA1WFRJNk9wL0Y1?=
 =?utf-8?B?b0phRHpvTTdaZTFHZFVQT05JYUJsZDR6WFREOXhBZEkvelhDRnl0VngxZS9B?=
 =?utf-8?B?N2tLdXdveTUxQkFQYS83Q3NYT2JkakNsZWlBRmozNmlTeVhVU0xJS0hRdWx1?=
 =?utf-8?B?V0pFRHR3bkI3eFZVVzdMa1Z6NmwwV0RkajVoaFBsUXBDUDB3VUVNQmtlSmx1?=
 =?utf-8?B?b3VWM0hNTjEzeEJFMVA3bDBlMGo3d1hzNTg1ajF5MG1aT3c1eGFVMTBDQWd1?=
 =?utf-8?B?S3F3cTRDRnJUd1ZhSElaMyt0aUppcUV3eDdiYUVOY0NMT2Z4VXExeW1HQUtV?=
 =?utf-8?B?dStvc0MyUElvWkV3MzJRa3hpaStrS1ZwWXNFdStoVUlMS1haTVVYYXFMTDR3?=
 =?utf-8?B?dUVYZ0Q0eWZYYS9OQXY2VHlpWmgyM0lDYkZjTmNhcU9HSDh5MHNQVlo0aUUv?=
 =?utf-8?B?MXNwZFVLSGFnMGVjb3FpRjJ6QStCejBONnZTdkFUeHpOYkFlT2NUN21ZMTdE?=
 =?utf-8?B?WXN1M0x2eVkrL0NiY0tvd3k1YmNNZTV0aFc2VnF4L0ZBZkZ4L292dXM5NGIz?=
 =?utf-8?B?NkxzUjhzUEhtSEV3YVNQNFd1SnJOaE1YMG83UjlhR0dibzgySjE0Z2tVdGw5?=
 =?utf-8?B?cmdUdzBPcldIeVhlZ0E0YXNLQm9qZUZoNWtpYzk2YXpGeEpUOVhDdlQxUmZX?=
 =?utf-8?B?OThvK0lGT0EyZERrR3VMTmx0eXJyc1VBT3JGNUh3cDZpOWhXN0poYVVHNk5x?=
 =?utf-8?B?aEdNRlhoRkpHMmtNTXBJaThneTRXMTRhYlJhRHBiWGZTKzFFMGlLUEdLY2JZ?=
 =?utf-8?B?c1pYNGxvWjBRM2pBWGlXMDhWcGJtQkhsdEwzaUV2bEdpeFI5M2ZqdlR0VkEw?=
 =?utf-8?B?SzQ3cHJFUFBmNmZQdVduMTlQVE8wQWhaWnk0L1AwblRTR1hicnVKZWp2V2F2?=
 =?utf-8?B?dmdFOGFUT21hUm9jVWowekhwWVdSOFI0OS9FYnlKZk9VVFIyOGNucFhrMXc2?=
 =?utf-8?B?Mm9mWnNtMStMZVRTYktLdzJEWExYeGNacFlsUTRMSGhjbzF2bmNWeXE3RFQ5?=
 =?utf-8?B?cEd5Y0FLdUZSZXdjVVQ4dW1wWHl4MEFoN0w4dHR3amlvNzNPTEZBZU1zWWN1?=
 =?utf-8?B?YUs0aGJtL2hKNDVrTGFMZ3owU0RwaHRmWTdGOUNacDZRaXJxL2xaUUwyZEpr?=
 =?utf-8?B?N0ZRY2tITzVOU0xiWnh0MzJXcGFkWkp5dkhpa0NoYzd0VzhZSFBZeEZGR1lR?=
 =?utf-8?B?NlJjcHBjWTliSjdrM1VLVkRrMko1S3owNWMwMlloYzd5REtkUENBUkRnOWdu?=
 =?utf-8?B?azNzdHN0NGVEdkNueFVlT1IzN05RT25IaGEwMStDdTdTTDZaWkUvVW1lU0pH?=
 =?utf-8?Q?urKg=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 11c5dbf1-c111-41d9-03fe-08dd50e53008
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2025 12:59:03.9377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Py+/U7QZLqfUGuuTpaxhxEUwo353abN31SKdwuX59+GVPSK45LK4Lb1HEEjs0sMCYEY/s5HZjewPZLf3ueeXRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8859

W1B1YmxpY10NCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBHcmVnIEty
b2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0KPiBTZW50OiBXZWRuZXNk
YXksIEZlYnJ1YXJ5IDE5LCAyMDI1IDQ6MDggQU0NCj4gVG86IELFgmHFvGVqIFN6Y3p5Z2llxYIg
PG11bWVpNjEwMkBnbWFpbC5jb20+DQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnOyBwYXRj
aGVzQGxpc3RzLmxpbnV4LmRldjsgTGF6YXIsIExpam8NCj4gPExpam8uTGF6YXJAYW1kLmNvbT47
IFNlcmdleSBLb3ZhbGVua28gPHNlcnlvZ2EuZW5naW5lZXJpbmdAZ21haWwuY29tPjsNCj4gRGV1
Y2hlciwgQWxleGFuZGVyIDxBbGV4YW5kZXIuRGV1Y2hlckBhbWQuY29tPg0KPiBTdWJqZWN0OiBS
ZTogW1BBVENIIDYuMTMgMTE2LzI3NF0gZHJtL2FtZGdwdS9nZng5OiBtYW51YWxseSBjb250cm9s
IGdmeG9mZiBmb3INCj4gQ1Mgb24gUlYNCj4NCj4gT24gV2VkLCBGZWIgMTksIDIwMjUgYXQgMDk6
NTk6MDVBTSArMDEwMCwgQsWCYcW8ZWogU3pjenlnaWXFgiB3cm90ZToNCj4gPiBUaGlzIHBhdGNo
IGhhcyB0byBiZSBjaGFuZ2VkIGZvciA2LjEzIC0NCj4gPiAiZ2Z4X3Y5XzBfc2V0X3Bvd2VyZ2F0
aW5nX3N0YXRlIiBoYXMgJ2FtZGdwdV9kZXZpY2UnIGFyZ3VtZW50IGluc3RlYWQgb2YNCj4gJ2Ft
ZGdwdV9pcF9ibG9jaycgYXJndW1lbnQgdGhlcmUuDQo+DQo+IFdoeSBkb2VzIGl0IGJ1aWxkIHRo
ZW4/DQo+DQo+IEFueXdheSwgY2FuIHlvdSBzZW5kIGEgd29ya2luZyB2ZXJzaW9uPyAgSSdsbCBn
byBkcm9wIHRoaXMgZnJvbSB0aGUgcXVldWVzIGZvciBub3cuDQoNCg0KVGhlIHByZXZpb3VzIGZ1
bmN0aW9uIHRvb2sgYSB2b2lkIHBvaW50ZXIuICBZZXMsIHNvcnJ5LCBwbGVhc2UgZHJvcCB0aGlz
IGZvciBhbGwgc3RhYmxlIHRyZWVzLiAgSSdsbCBzZW5kIGEgYmFja3BvcnRlZCBwYXRjaC4NCg0K
QWxleA0KDQo+DQo+IHRoYW5rcywNCj4NCj4gZ3JlZyBrLWgNCg==
