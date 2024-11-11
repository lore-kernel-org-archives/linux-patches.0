Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2050.outbound.protection.outlook.com [40.107.95.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D757D1411DE
	for <patches@lists.linux.dev>; Mon, 11 Nov 2024 11:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731323181; cv=fail; b=ACowDcZgx2i1v+YNI+w2YGgl8/dd4FspUwFq729LzJ5o+s05myNS57rCPWKKA09RIN+Ir2s2TSP6BfqTcev9F/iwvL43rKyh1ANrDCGqF1oy5bVR5Zga2Z3KH0m0K6sS3Fx2bcHdmWtfJz1PmsrAOiPCKbJYanIIMx+V+gCw7/U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731323181; c=relaxed/simple;
	bh=7zy/Fdr35zHSZ1tEGVaBfEDV3Heev/YARa0UtjR2tp0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EXxVi4j2rvYs32fXSuFPX9z2/GE+QpkdmD8/+OC7e3qoVNcuikuq5zrQbPOu0ibPwPxX8VcJJUB2XxFsejk8JzygyZ4ldTseqUpERDI1ONwcFFF+myYzJTQexUvsizen35SNQ66hvukDBmaZGCZKZdzwSEettDzQPpxurDne8QA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dKdXXPAV; arc=fail smtp.client-ip=40.107.95.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dKdXXPAV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bbgpro+yVffs23t4wk//H3yZw15w5GayW8hAVF56aZ/lcLLgntu1pBIt3SDNmY5txm2PJEzkBOphXTD/iStx8BlLh1brOuc/iW6+azMApV19E/nQTEzINrHnEgiXqzVqmOtK2zOcW3LtnCz/+w5dJWnk14jYj50sXDfPKYxicPZEv3I9fLBFIwAn2N+wx8p04YwlwE081kgHcH7yeBeHVmXjNVPP7aG1WKL/InNOna6xcvzrEFuCQk0WMWuqWU9Z74rQCcJZ80geNvvJrtdlTvlQnwlpEsFB/VIeWyAcb+GVYrENB9RRFWR0ImUrasmCpXQFVS1cRyykIfeJWYtcgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7zy/Fdr35zHSZ1tEGVaBfEDV3Heev/YARa0UtjR2tp0=;
 b=KskxIv1i57eDUCuKXU7MpepOgFd5rv0pJ/5EuGLGvYkgRuBlUmFBDQryxmZPxsZzexpWjrHxgqruwLbqzBHtL2D36x7yXrz26Ian0nyvavRRWQFKaQeg8YIIrYdnYFnRj9ctYGSO5s4JKW4zROV2QU3NiEAZFCzIYndKjt4cWYwq2GPqD2sPjPpduq8g8dmR+cQN8DEcix8aGUuDfgi8VCp82hmjw+U/Gqenbs9ie+no3+8AydYUUkTKD4gNqZ+gA+BZl4cR3hs9vx5uLeG/kS0QrVlFZ/GK1fNmTItLTsDhUcFS1+QAD8pEjlfmvZ4aLbVehUMN8xMKbkuPSGH15Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7zy/Fdr35zHSZ1tEGVaBfEDV3Heev/YARa0UtjR2tp0=;
 b=dKdXXPAVf/Z3lrcAwj6ps9vJusiaqO/ibxuBsnRiJYNrw4uEgNSSOq2KVy5o7wkuvW/uu1idUxVdRCFXlCWinvllcT5OyQ25L+pV/hokV1fbRcn9cyeKOhB+A2FMY98IOzksLPaHddtQ4QPafVa8xf8mXrwBNACA2X7dCOzHbnU=
Received: from BL1PR12MB5333.namprd12.prod.outlook.com (2603:10b6:208:31f::11)
 by SA0PR12MB4461.namprd12.prod.outlook.com (2603:10b6:806:9c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.26; Mon, 11 Nov
 2024 11:06:16 +0000
Received: from BL1PR12MB5333.namprd12.prod.outlook.com
 ([fe80::d4a:9dd1:afd9:1c70]) by BL1PR12MB5333.namprd12.prod.outlook.com
 ([fe80::d4a:9dd1:afd9:1c70%4]) with mapi id 15.20.8137.027; Mon, 11 Nov 2024
 11:06:15 +0000
From: "Agarwal, Nikhil" <nikhil.agarwal@amd.com>
To: Nathan Chancellor <nathan@kernel.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>
CC: =?utf-8?B?VGhvbWFzIFdlacOfc2NodWg=?= <linux@weissschuh.net>, "Gupta,
 Nipun" <Nipun.Gupta@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH] cdx: Fix cdx_mmap_resource() after constifying attr in
 ->mmap()
Thread-Topic: [PATCH] cdx: Fix cdx_mmap_resource() after constifying attr in
 ->mmap()
Thread-Index: AQHbMTeXHC+6KhMdIkaClOrhKbgK3bKx8FWw
Date: Mon, 11 Nov 2024 11:06:15 +0000
Message-ID:
 <BL1PR12MB5333396F89AC0F08DEB947CE9D582@BL1PR12MB5333.namprd12.prod.outlook.com>
References: <20241107-sysfs-const-mmap-fix-cdx-v1-1-2ed9b7cd5f8b@kernel.org>
In-Reply-To: <20241107-sysfs-const-mmap-fix-cdx-v1-1-2ed9b7cd5f8b@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_94523dde-f9d1-4aa7-80a9-c0900420d3c3_ActionId=4a707f05-2afb-4ea6-b2e0-7ae40a462797;MSIP_Label_94523dde-f9d1-4aa7-80a9-c0900420d3c3_ContentBits=0;MSIP_Label_94523dde-f9d1-4aa7-80a9-c0900420d3c3_Enabled=true;MSIP_Label_94523dde-f9d1-4aa7-80a9-c0900420d3c3_Method=Privileged;MSIP_Label_94523dde-f9d1-4aa7-80a9-c0900420d3c3_Name=Non-Business_New;MSIP_Label_94523dde-f9d1-4aa7-80a9-c0900420d3c3_SetDate=2024-11-11T11:04:08Z;MSIP_Label_94523dde-f9d1-4aa7-80a9-c0900420d3c3_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5333:EE_|SA0PR12MB4461:EE_
x-ms-office365-filtering-correlation-id: 58ff4490-834e-4f42-bbd2-08dd0240dc8d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?L2U0amVMWFBTdUpUOGVhWVBVbkZyaExqWEtNcVU4ck8xYkhKVDJUc0JtZS9v?=
 =?utf-8?B?dEdnK0NjMDN5emhsWlFCRk1oV0NYZjZLMGpyR25UY2lGU09XeTBydDlOeWd4?=
 =?utf-8?B?NzU2ajdiNnc3S2g1aFFNcXh6dUxSQXpQZk14aTlJSVdMR3VDeEVkOEUrZlpY?=
 =?utf-8?B?M2pQdEtxVHROUGxnQk0zbmhldXpGVDVWMnM1TmVqaEt2cWhPT3NidUJ3Rm1z?=
 =?utf-8?B?YVdwdmRnL2pMQ2FUS3FKVUxseU9NWVBtNEFTNXNleG83M2lPUHlKMDFscStp?=
 =?utf-8?B?TGJjUy96ZFNaejhqS0hoeXMzYVU2ZkN5U3FLOXRNUlZNWnlCRmF2MEowN2g4?=
 =?utf-8?B?SWpDUlpuNXpNMXRZMkxPdnhNVFA0VUM4QkEwK2k1SXlVYS9UMUpIc1JyS3F1?=
 =?utf-8?B?dU93ZndKVEpmRWpwdnNpUTFMNXV3WlZPRFRvS3BlRDY3MS8xdDJPa0NYN2o0?=
 =?utf-8?B?VFZkWnRaam5UeUpKSlhlc3luSG1rK2MrOEFIcXJMM2tlTE00WFplSzJtbi9P?=
 =?utf-8?B?U2o5ZWtDa2RDbFVQTUNxN1VYNmVxWU5henRGYTNmb1JpeFNDc1dyU3c4V2ow?=
 =?utf-8?B?MmhneStkM0haU3pSamJGNVJlaXhWVjd0ZTVpYUdtTUxRYmtqOXkwNFZmRk5H?=
 =?utf-8?B?em9ZWVhiUC9QRFRoeXdxNUdUcm9EVVpsSi9NZE9pUU5aZWdxL2doS2lneFlm?=
 =?utf-8?B?YzkrSHZ2Nzg0ZTArTVg0eTFFTzNRaHV6K1draGdqYllzVCtFN0hLQ1NPVFdl?=
 =?utf-8?B?SGVBcVlJVk5BTDRXazdNSHp0S1VwOGFuV1JXMWttUUR6MW9XZHpBMnMwOGhu?=
 =?utf-8?B?T244T29LMFVnaloveDJ3NDhnMVd0Y1BMNGMrUFFqR1Exenh6R2dqZlM2Y0JN?=
 =?utf-8?B?dGJWR09jSVN6Vm92VmNUczQ5QWN5RkhrRXJMdTBHb1JBTGpxSEJzUlR4L2k5?=
 =?utf-8?B?NDRqS28wSmdHemFDc3hNTG1Xc0xTb3ArYXpjb2RwdHVjR1UvaXNBajRMRVlV?=
 =?utf-8?B?djY4azg2aGxjNW42TnJ0ODRpWXFlOThHTWVTNDEwMGlMQUN0YlFTb2h6cGpi?=
 =?utf-8?B?VmZiUjJkdXJLdURFa1NRSG5uR01jc3FESiswYlZtOEZFbjQ2UE4yZzA0Um13?=
 =?utf-8?B?V2FtM1dHLzVIa2cxOGhrRlVlUE9LTDAxRW9TcHplaUtOVnE3UUxheHBqZ09t?=
 =?utf-8?B?czd4QXhTR21qVkF5SUtBT2pMKzdMQi9KNjdoUS9jaTlJQ0xnTUtBcGtSUHEw?=
 =?utf-8?B?bm9yZG1mL2VaSmxJSS9hMGF0MDNhWGJqeW9CaFBQTEV0OXE2U1FrbzdZVnRL?=
 =?utf-8?B?RnBDR1pQZWdxNnZYTGE2Z1dlM0NmUmpDSk1lUWNRNHZPSmJITTRMU3dMK2VC?=
 =?utf-8?B?c1lsLzE0TEZ2Mlh3Y00rOXZmRkJ6anpJRGkzSm41M3l6ZDZocjFOVUdkcnFp?=
 =?utf-8?B?bXJPcG4yVzdOTkN6WFAxOWlHNnBvaVRwQUxPSVZIOFlsZXFhb2F1VTVwcVhK?=
 =?utf-8?B?MzNqcEU2U2k4V2p2WTBieWROMFpDekhOSyt1OXpTUDFMTXZ1NVIyQUhPQUhq?=
 =?utf-8?B?VXZOWkFKNFVOa3dBYitkb2psZ2dSOW5ZdnJ3TmVhN0hRdGczUHNnMDlPMUpp?=
 =?utf-8?B?N0ZnL3NNbHhySmFIL2ZKd2ROMUpNYWp1dWJrQmlJMWVwNmIzVTBjMFR3QjVN?=
 =?utf-8?B?Mm5QamdOM0QwNHJxVDVKcDc1YW1XV2xLcitMaDJCcU1lTHFKZnJNc1ErRFQ0?=
 =?utf-8?B?OFV3TEozYmp5dkRaM2thbDVrQWF3VXFUN3poNUpZMmtYOUtmcnZlb1ZIdnpO?=
 =?utf-8?Q?qGwPiBeBaMD4KkTcdyG9lcd8vIH5fqMmjaqV4=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5333.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eW0vVW80VkZYMnZ0OWQ3NktzdmRuR3hyWURqRjEyOGlEeEZ1dWgvbTFhVWFV?=
 =?utf-8?B?YnYxRjJVQ0ZTUitQK3dGc2psaWVoSERTK0E4OGc4ajBsNS9Cb0hHQmtyZnRn?=
 =?utf-8?B?dDBJSG9MV2NhSWF5dUR5N2piNWpRbFhRSkFBUHIvSXlnZ21LQXVTSS9xN0tn?=
 =?utf-8?B?cU45YnJhdEtuQTdlUW1BY1VkYWxxVmlWaFgwaHlaSmJuTWRGMU9iUDcvb0I0?=
 =?utf-8?B?aGNKallMc2hvb2x1bTRIdkRWdFNRWFBKbXhaRis1REJoNzdhMDRwY3BGOGhP?=
 =?utf-8?B?amhuRTNjWHdQNkliNU9nbkhBbnJ1QUlLZDQwVWpTaDdIeXdEWW5yVG11VU9H?=
 =?utf-8?B?RE5iRGVrT0pxMkdoMys4aEc1alRwdE1ZK3p0S2p5WFg4VS8vY3hUQVdFOGRI?=
 =?utf-8?B?OGlXc201ZWE5VlZaT0xHQjR4NHFnTEJPU0ZFb1JTWHhBRHJHNHJFNmlTZk1z?=
 =?utf-8?B?TFZFNnhvcWdzZ0huNUVJSy9kWElxUVExTnY1OGZocHBvZFBFbFFSTmlOeEth?=
 =?utf-8?B?TCtXTGxtL0tlN2Q1Rlhlcnh3dzJmUVBIYlFCckNxZCt2Mk5ic0VKaTY5UlZ1?=
 =?utf-8?B?dThWOTJDQ3l6SzN4MkJTbDh4aFV4QWpWRUxhSzlhYkFaeWN6cUg4cy9uZjZY?=
 =?utf-8?B?ZFI0ZitjZDFJT0Evbjl2QWZzRFpnaVM3ay9PSmMxUTN3K2FhTEJuS2U2anlB?=
 =?utf-8?B?a3ZDUm95Y3FXS3hpR1U3WGwwd0FXU3dxTkF2TGxiSTMzTVJaeU9YOE1UUVl6?=
 =?utf-8?B?eXBic2xZZ3lvYjMvZmRyV01STFA5Y211TnhHRTdWVkZha0YxQ0tac29BdWZT?=
 =?utf-8?B?YU1ZTXptMjhobnd2enZCTW1xSjV5VW9EeUplWUlCL2QwcGJvWGorTTNCMksz?=
 =?utf-8?B?d2N2YTB0bFVPb2VObXpyRkJ4ZlpOemFxUGE5VlFrNFJiOFp1eDhNaDY5VGQy?=
 =?utf-8?B?WUZCRFp2Rmh3RktOK0F1YkNMUTFZVzdvUkdnWXVqOEpNMWtYd2ZhSHMrRVQ2?=
 =?utf-8?B?WGRYNkYwT1B4K3R4ZEdJSHFFU3dVZGVGSnpsdEoyNmFHZXFXQXZiRlhhSFNC?=
 =?utf-8?B?SVhrd01jNmNuSjJsZm1JME8yWkFubCtSTkZuVDk5OUtNdkhYdUpZS3ptc05j?=
 =?utf-8?B?dittNzJwM2lSNnpsR1pxVEltQWNzUyttRUF3V0JoVUpWUWcwckdPN0JFM1NR?=
 =?utf-8?B?OERkNStabHdNaWQ5U3RMMzhqWUtqTkVlK2g5eGtvUFd2K2lvd043Nm0vOGd5?=
 =?utf-8?B?eEpVcHBVd0U3T3Fyb3YvSy9Wa3ZEMTRaM0tuR25RV3g1TDVqNTFXdmcxdEw0?=
 =?utf-8?B?VVo4bDZyM1N0SFhMeDdrck5lZTNNaFcwRno3TmdrT0gwbk1IaElyRi9uQVFh?=
 =?utf-8?B?aEpva0xRcHE3aWMrV3NMeEFIcTJPVkJiWWpsY0hRSWRSVSs0Vit4K1ZJTng3?=
 =?utf-8?B?aHRjNlhmSGZia2k1SWdWRWp5MlowazZKbG9nMktyK0EzanpoK3pXQlpRNFdw?=
 =?utf-8?B?aWRLTE1MeGZ2RCtBYmN1czJiR3VkUklvV3pOYWU1NHdEQk1nVk81Tk9LbFU1?=
 =?utf-8?B?Zzl4TlZkVDdYU21ORW1sZzFsRmNucHY0YUZpZkVHbmFZU1czZTgzU0VFYTNy?=
 =?utf-8?B?VkRJdXQvTkdPYUQ4ZnB5a2VWOEtTQi9OZi9GZGRNeFZlRGVBTFlSK0gzL1RI?=
 =?utf-8?B?bzJDb0NINi9KMEJ4clpNb0VNdUlyU3Rqem1rNVl0Vm9yNEdpaFNOa1RjQk9V?=
 =?utf-8?B?cUs3MTZCNmVFamhMNE9tRGZqYTF6NGZCaDBhYkdjN3FERk1WdWxuMVRCQzR6?=
 =?utf-8?B?V2piWmJrSjFIb1hIQ28yNUdaeGRtbEtGc1VGNmRRMTMzbkdPSklCN0c3S3Ar?=
 =?utf-8?B?TXhrMkJacGl6U0N4emJvNmEvT1ZIR3hxeHIwZk42SjJCa05GN0xoMW1WM2ZP?=
 =?utf-8?B?V2xZQ2FtSFFUOXgraGoyNE1nQldkYzNUSlY1Ym8xWGcrTEorU2JjekdkR2Fk?=
 =?utf-8?B?L1NvZC9PUzRHNVJrc01hQktJRE1ENEMwY3RDRmpIVDdJdHcwbmxlMFhaQ1hQ?=
 =?utf-8?B?eElUNWw5RHpBMXAyRnJodjhWSjlESlFCa3hkVFRFeUFNT2I2eHNaSVZZekFM?=
 =?utf-8?Q?F10M=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5333.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58ff4490-834e-4f42-bbd2-08dd0240dc8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2024 11:06:15.7733
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RiKR2/Lrmevxof48L3c2bomgJKJHelg9wqfN6FpTB/JyLDCGKIHRAPAo3xvKklzu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4461

DQo+IA0KPiBDb21taXQgOTRhMjBmYjlhZjE2ICgic3lzZnM6IHRyZWV3aWRlOiBjb25zdGlmeSBh
dHRyaWJ1dGUgY2FsbGJhY2sgb2YNCj4gYmluX2F0dHJpYnV0ZTo6bW1hcCgpIikgbWlzc2VkIHVw
ZGF0aW5nIHRoZSBhdHRyIHBhcmFtZXRlciBvZg0KPiBjZHhfbW1hcF9yZXNvdXJjZSgpLCByZXN1
bHRpbmcgaW4gYSBidWlsZCBmYWlsdXJlLg0KPiANCj4gICBkcml2ZXJzL2NkeC9jZHguYzogSW4g
ZnVuY3Rpb24gJ2NkeF9jcmVhdGVfcmVzX2F0dHInOg0KPiAgIGRyaXZlcnMvY2R4L2NkeC5jOjc3
MzoyNDogZXJyb3I6IGFzc2lnbm1lbnQgdG8gJ2ludCAoKikoc3RydWN0IGZpbGUgKiwgc3RydWN0
IGtvYmplY3QgKiwNCj4gY29uc3Qgc3RydWN0IGJpbl9hdHRyaWJ1dGUgKiwgc3RydWN0IHZtX2Fy
ZWFfc3RydWN0ICopJyBmcm9tIGluY29tcGF0aWJsZSBwb2ludGVyIHR5cGUNCj4gJ2ludCAoKiko
c3RydWN0IGZpbGUgKiwgc3RydWN0IGtvYmplY3QgKiwgc3RydWN0IGJpbl9hdHRyaWJ1dGUgKiwg
c3RydWN0IHZtX2FyZWFfc3RydWN0ICopJyBbLQ0KPiBXaW5jb21wYXRpYmxlLXBvaW50ZXItdHlw
ZXNdDQo+ICAgICA3NzMgfCAgICAgICAgIHJlc19hdHRyLT5tbWFwID0gY2R4X21tYXBfcmVzb3Vy
Y2U7DQo+ICAgICAgICAgfCAgICAgICAgICAgICAgICAgICAgICAgIF4NCj4gDQo+IFVwZGF0ZSBj
ZHhfbW1hcF9yZXNvdXJjZSgpIHRvIG1hdGNoLCByZXNvbHZpbmcgdGhlIGJ1aWxkIGZhaWx1cmUu
DQo+IA0KPiBGaXhlczogOTRhMjBmYjlhZjE2ICgic3lzZnM6IHRyZWV3aWRlOiBjb25zdGlmeSBh
dHRyaWJ1dGUgY2FsbGJhY2sgb2YNCj4gYmluX2F0dHJpYnV0ZTo6bW1hcCgpIikNCj4gU2lnbmVk
LW9mZi1ieTogTmF0aGFuIENoYW5jZWxsb3IgPG5hdGhhbkBrZXJuZWwub3JnPg0KQWNrZWQtYnk6
IE5pa2hpbCBBZ2Fyd2FsIDxuaWtoaWwuYWdhcndhbEBhbWQuY29tPg0KDQo=
