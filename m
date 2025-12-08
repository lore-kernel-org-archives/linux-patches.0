Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013037.outbound.protection.outlook.com [40.93.196.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F3818DB35
	for <patches@lists.linux.dev>; Mon,  8 Dec 2025 15:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765207875; cv=fail; b=fcxksOMvCRTcFenNEdYWVP97/j9O2KtS6V2yajpsnUZgxFFSbTci2/sVQ7QmVkaXYzJVqusOq9HGsM0eu6cfLAI5IPPZVNQgux/OoQr4jw++XJ5aCCOPenvlGI6jOCXhFHY8D9uXcYuE4Pjx7AhoxzJ8B7VVxkLuKaeQBOAGlMw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765207875; c=relaxed/simple;
	bh=IqThwLQZgZILsdKNGT/gXprq/zqb15EVQ/f50OLUtUA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gop4L6DNzTZhvsAGfkysHCUKt0M45kQvFxh46bSRPTdN9pO7CfeLvYUcrYpYKCNU8O5dYVJJggMpS2qRuaQBc98LGyopUGDTP+D6DKZNVafbXN8pFqOODlUYO60QhBtDow+ZG8bk1ksb8HOJTSAcsnWWkHYLUgd1NCsUoP1hY9A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uG6IcVij; arc=fail smtp.client-ip=40.93.196.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uG6IcVij"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W63Tmw65zdDGDcJS2aOn5+bXM/q9w2fn4hncaVdJxO8PCq7SLg4P/9TidYjbEULn7awG69cv226S7rhsldNx7XtuF1FNm9KvobyEjlYShCtDdts7jGPzdz+XC3kIhr6KFcwSyMeSjd5LsUJ3bd47xnJrl0W6BjWP1BO/+FfyG/DCg5GVztiIwhtHJ7wtVhVWXeMotL+9yL46Wbr5hpPYNvWqwvDNAXWsRIpWSbFYzlIzLex4w8CtMrUG9v9WaCGaXBdYUNbvErUHhHWaVnUvKRT5NQTIsFspWTn0iZQArZgaIS/FMieOO7j6YRnQAKvjKIaz5QhJi52aZXn2oOyNiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IqThwLQZgZILsdKNGT/gXprq/zqb15EVQ/f50OLUtUA=;
 b=Wtjg4GKPw67eD7l+YvcvONk8AfoGP3YPAa1Fpl5ld4+/JtdoZjEMaXZiVWnEecBOUsvIPaZhoelfU8L7sFrwo1ig1Oie7oWK8iFV9YGlVqBQnc8Bja7OWFNY7fkWugmR9/AaQ3ssJloRHyrGAK7YcKMg4b97iFrReLKK6iVvZj9tSBalxec0FkH1/fDBW0AAgQAMVxKBUlge8n0byt1r6z1/euLunmC0oQJwpQLVdAGbeKnBbr1/YLm7gSFEQhBbrr/PER/hlI4PnHcSRKMRiPgTKFw0j7xUBICOS9cAs9YcYqqKX7neW25rdT73Drqf5vvUI6OE0siodNioAH4riA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IqThwLQZgZILsdKNGT/gXprq/zqb15EVQ/f50OLUtUA=;
 b=uG6IcVij6hA4xbIYQqBVYfFT+MJQtP4VrZfAAy9KDREsWRTHhevGqrW40alxFIrSf8MRwmhKJ2iU03DK3oVogDGqaUXT4kHOzNp484FJ6z4nf7cfJ+7TB7xMnZO9ajsamLe4t74ctX3dbzfgFj/sjXKAE4Di6MXyv8lsjCLFL4w=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by DS0PR12MB8070.namprd12.prod.outlook.com (2603:10b6:8:dc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Mon, 8 Dec
 2025 15:31:05 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42%4]) with mapi id 15.20.9388.013; Mon, 8 Dec 2025
 15:31:05 +0000
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: "Koenig, Christian" <Christian.Koenig@amd.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "Liang, Prike"
	<Prike.Liang@amd.com>
Subject: RE: [PATCH 6.17 129/146] drm/amdgpu: attach tlb fence to the PTs
 update
Thread-Topic: [PATCH 6.17 129/146] drm/amdgpu: attach tlb fence to the PTs
 update
Thread-Index: AQHcZG0WrCpRNVEwLEqyDCFmLKzAt7UQE8uAgAALkaCAB8VdQA==
Date: Mon, 8 Dec 2025 15:31:05 +0000
Message-ID:
 <BL1PR12MB51448F71631710E788BEB1F8F7A2A@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20251203152346.456176474@linuxfoundation.org>
 <20251203152351.182356193@linuxfoundation.org>
 <725a5847-9653-454e-a6f6-5e689825d64c@amd.com>
 <BL1PR12MB514484FA812346EB147CDE9FF7D9A@BL1PR12MB5144.namprd12.prod.outlook.com>
In-Reply-To:
 <BL1PR12MB514484FA812346EB147CDE9FF7D9A@BL1PR12MB5144.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Enabled=True;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_SetDate=2025-12-03T16:44:42.0000000Z;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Name=Open
 Source;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_ContentBits=3;MSIP_Label_f265efc6-e181-49d6-80f4-fae95cf838a0_Method=Privileged
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5144:EE_|DS0PR12MB8070:EE_
x-ms-office365-filtering-correlation-id: 13dcb9cd-23bc-44bc-e692-08de366ecd89
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?MU1UTG1YM1RxNFdnc0FoUVBzaFk4QVNjRWFuN291YW13MUNuZ3dMTmNVL1lX?=
 =?utf-8?B?SW5KTjV4U2VuUnM3MVlWcWhrdEJuTjBFTTNzODhSTXRRenlFK1hoVkRyZlUw?=
 =?utf-8?B?M0VjRm1iK2J4eDEyanF6d0dlQy80WHByTk1Db0llS2tBbEdaY3VraWZXU210?=
 =?utf-8?B?Y2ZxNGdOTzJrc2ZXL1ZzUWdGSkozNVFUZjJTYkkyTjFESnNUVTlyL2h1V0Ex?=
 =?utf-8?B?NXZFTTJIclJKcWN6eFJ1Sy9xZE1Xb2dIdnF4d3FQUTFJandFOW1manUwcW9S?=
 =?utf-8?B?QzVCNEYrQ2ZLNjFhcENxQ0VpeFdLRzhCUm5ERVlQRGIyNDdENTRWZTVzblF1?=
 =?utf-8?B?dXd4M3huZ24ra2Q2T2FucmFhenZLeHFRek5vNlViRHk2bDFRR1cza2YvbFVZ?=
 =?utf-8?B?RGxaaGNVL2k1bUJob0UyTkFOMU0yUXBZdzVqZE8xcGUxWk41L2N2eGFXbkk2?=
 =?utf-8?B?NXpWVzZJbHpNVVVOQno3VmJxc1N3VGQxejdrNy8vZEZlLy95SzJvcUFhUDA3?=
 =?utf-8?B?VGVSSDd5d0tIckQ1cFdoUTJxR1BEWkI5VUxHUU5QMzVxcEp0TGgyNUtnMHFM?=
 =?utf-8?B?SkYwcHM0TjdkUThVYnB1MmdJRDgvZWlMSjN0VjVuLzJqenllQWE5UVQzeXEr?=
 =?utf-8?B?MmdVbDFGTWkrWWZMZmtzaG1paWlMWTFJeUxneGRyays2U3JueFhTQWpVeWlH?=
 =?utf-8?B?eHBjRjVqMk5GaW5MQ3FheGE1RGZTbVZ1dUVqWXZyWDJGMlh4eE83MCtUd0hM?=
 =?utf-8?B?bm5IcHphR0w3dGI3L1RzdE9zbEQ2Rm40dVNqTStsTG12SUxPWStnQUJxWHk5?=
 =?utf-8?B?SmIxQ2FDbmY1NlJaaVFjNUVnK1ZnRVJBVEZiRmx4eUs0VE0rUS94THdnMzZD?=
 =?utf-8?B?d2phZ0pWaWR4dUE1dlpIeGEvYWxGZDNQM05PNXQzV0ZzZ2U0YzVjRGtwMVlD?=
 =?utf-8?B?dEhHcEQyRVE5NmlsMktEVDlaTG95VXVZZmVOSnFSR1RxajhLNHJvMHJCVStT?=
 =?utf-8?B?YjRzTEU1bVAwaHBtVlYrMkRGTjdQU1hLbjBYcG1pQlYzQUFSUllNY1hWanNX?=
 =?utf-8?B?Z05BOTNReFBrUWQ1V3ozcHZjbGJVQWV5eDJzb1YrK1JwOWxIanRIT2V0MXor?=
 =?utf-8?B?Uncyd25jcDBDUExHK0FTQTREc0xvdGIydTlBZnZjQ1Z0aVM4TjZlRjZvbHd6?=
 =?utf-8?B?aFFrdVRZZnVmTitaelc2aXNwRjJiRXlMazk0aldlTDdzMGJwYmI0TlJVWG1Z?=
 =?utf-8?B?aTM2VXk5dzNxbWphN04vMXdqOCt0SmJURjA3OUxtbWh6TGVTbGN4OTN3YVp4?=
 =?utf-8?B?cGwxcHk0UHYyN3VaV0E5S0ZGaGx4L0VLdnVWMmZJTWRrKzFVWHg2VUVYZ0Zw?=
 =?utf-8?B?Qlh0a3R1Zmt3QzVGSkwybi9FT2RDTDRCZlB5dy90b2dpZVNZc0U5bW1LQkZs?=
 =?utf-8?B?dG5IM1Q1Qm1UY3NJY0NqVjZYK0ZmT2NwTGVraFEzdGQ1MndHTERZMXRCOWZU?=
 =?utf-8?B?L2h1bjVMS2EwbjFSQmw2QlJhd2FlUGJMb3cvZTMySGtZQVRqSmNnOEVkMWFV?=
 =?utf-8?B?ejh3S2h3QWxJcEo1Qk5HT2NyeUEreCs1SzJHK1FrREFOM0NmSmtjSFlWTzRI?=
 =?utf-8?B?T1g2azUxK0h6VkpnNGFkZ1hoSTRnM3Q0a1hXOExPRUo1R1o5a1g0SjkrajNi?=
 =?utf-8?B?eC8xV0NCYkJjdmR3MUdPMW4zZXBvb3pWb2xmd1hqM2N3aXpYc3RuaWVVTTgz?=
 =?utf-8?B?RDVDMndlQlAzaytpcHM2SmlNT0s4VzBqeTRTK3ZFV1djRVFLbjNuK1gwWWdl?=
 =?utf-8?B?bWVSME90YmF3RVhaTGVTYmNpbG5ZUDg4THNHNHZWUXgvT3NtWkFHVzJ5dUJV?=
 =?utf-8?B?UUlaYlVuNDArZFR2Q2dtRGVjK0Zmb1FTc2VqNW9tcWszdmFaTmNONUhnbGY1?=
 =?utf-8?B?cFhYc3crOFRtaHFQM3Q0SWxYditXR25qZGFGbW90eEVlUEtWaW15d3lHWUV6?=
 =?utf-8?B?elpGVDJGemlCRGVkRzN2cjN2K1d6aEZqTXAySHZKTmRCVjBQT2gzUFlTY0RL?=
 =?utf-8?Q?I7nCJ5?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QXorQU9PZlV1WGpyOHltRjcvUjVJUHV3NHRuNkU2ZEwzRUlTM2dhVUNuR25l?=
 =?utf-8?B?cjk1SmZlWTloNzc0QnVmN2FqbVQrTFk4UVRtNml1YSs4cW5RMTN1YkJYZm92?=
 =?utf-8?B?Q0FCdjVNYmMzM2YyYjlld2pDZS9MZGFZZWtBcWU2L21wYVVGSVFudElaelUx?=
 =?utf-8?B?ZW5tL3pTQkxvdzV5NjBIVHF4OHR4R25hNHh5OW9HMXI2UTNZVjBKZ1dOWVBW?=
 =?utf-8?B?YURKb0JmdkJqTjJyaEovMmlKZmRCQTRFZEtQakNRSWtudHRXeWZyaTd4d0lR?=
 =?utf-8?B?bWsvVm1hdEh1V0NYaFRCa2pReDdNUTNpNTlBM0Q5a2ZOOXNBV2FxUnpJbWgz?=
 =?utf-8?B?cHNLVFgreG5WNXlWZ0FqNnA5MXZwVExTWThvVWpDbTY4c2VhZEQ2YVY0cXRu?=
 =?utf-8?B?aURBcVh0SExVVjZPWFdzRnByOUYvVzJpMFR5SWFoTEg2YlRVNHYrRGxKWlg4?=
 =?utf-8?B?UTZwclZRRWhxN2Z3OTlXU1lYT0pXSmFTN0RWNzR1ekxyV3EvNjVkckdsaWQ1?=
 =?utf-8?B?OFB3L1lsNUFTczZ1bGtxTTN3eFQ0QWhlRUt0TWFOVlFNNDU1Rjl3N0pKVFYx?=
 =?utf-8?B?bXNVNzhDZ0c2R3hTV1daRGV0TzhvZFlkZ0dMblhXUXd3dmJCQ3RCamJ6ZkJU?=
 =?utf-8?B?NG12NkdGWlhORVV6TDdaYXpYY085Ukh2QzRoVEVGa093d3R3ZDM3TExGRjNJ?=
 =?utf-8?B?aUdiNitjVDhuMEFDdkZwZmQ0NW80SW9NU05sWjdDYk9lMWhMcU9HT09VeHBi?=
 =?utf-8?B?ejRXNGZjYW1SOUtnc2dKZ3JaMEVERHQ1UHBTZjA2b1RYR2svOXNLemg2VUxo?=
 =?utf-8?B?QXQ1K0Q4dTdPN3h6NC9nOU5OenpVUWJSZVZkc0o3Um1COHpvVjFPTDlxQXdz?=
 =?utf-8?B?alBKTmlBK2xqUXQ5OVAwSCtIbDJTMlY4OVRZSFZLUGxmbWFCaVVMclF4LytN?=
 =?utf-8?B?Ry9hM1M4MFF3R0pCQ1U3QzBwV2lNRHkxaGZlQThuVDFLUGc5Skp2ZTdtenY5?=
 =?utf-8?B?d1hXWUNJOEVWUUhoYXN1LytBR1V6TGNFSUxTakt2TWpmN1NxaGJKWXVYZTJy?=
 =?utf-8?B?N2d5a2lrRGdBUDZyaXZnUFI2Q0RzMHFBN293bUVZTW1ySG9Icy80aFBXQ2x5?=
 =?utf-8?B?WDM5QzVVeSs5OXNQWVNlcW5IdURaaU1aZkpFMjdPcndsaHNQdGhEak1mOTIr?=
 =?utf-8?B?Tnp2WnBWK1JPdWljWXJ2TlJzUGZzOWJweUVFOTVzR0FRSm1HSW1wcDlXYkVC?=
 =?utf-8?B?RmRRUzNjWUxFZWthYW5RVWhuNHVmWTc3UXdkMUZNd05Ydm1OenVESW5xTUtJ?=
 =?utf-8?B?MThsaTBtSGxIMmZjR1p0bVpVSDVaRnlHNVpUcFQrdUFRbE9jRkJiTnB4UVBS?=
 =?utf-8?B?d3lLWko0MlEySVQ2c1VTOC9pdis3L0M2aUM1aVMwbTlYQjh2VFdQYUVVY0xj?=
 =?utf-8?B?WXlpSnYzaTlkMnhMWEhrVmY4Ly84WHRRTGpNc0paSHpGeG1MamFmeUJjYlVY?=
 =?utf-8?B?S09ZSkN2ZWVLQ2xtM0ZoRVB2c3NVUWpUQUQvU0IvMXFPdE9scjFvamxzb0ly?=
 =?utf-8?B?cWZRNlFhakNpZERmV1lxMllmUC9tN1FRMjdOSVlZZm9NOENGQ0xuZU1qaTFt?=
 =?utf-8?B?cnZNTkNBQ0FvMkdIeGMzUnpCSDlKTVlPSHdOQnpvVmpCdUlLNVd0dE92OEtj?=
 =?utf-8?B?Rm4wMEwzOFpiNlBxVytiZll4dFc2cUdWSWRvVDJLdDB4RnZ6S2VsRDZHbGVX?=
 =?utf-8?B?ZUhjRndiWTZLRVJqRHlqVXVJL2JsSlhJMEhmRzRoM0pQZ21CNC9rU2xaZGoz?=
 =?utf-8?B?R0c5VmJNMXZxcjQ3QnZXbk9zeldKRHlES3UyWmdtY3g1K3F0ZHllZjJ1NEpn?=
 =?utf-8?B?SXZUbW15d3EzYUVIaXhMN2VqL3ZKYVM1OWYyN2NsWDd2TDlic1VMS0hVY3NF?=
 =?utf-8?B?aFZ3MHBmWjBJbWIyS210RkE3anpDZUhSVmZPNDJoYzMxelIzNzVPU2J1Q2ZD?=
 =?utf-8?B?N1RvVU90S3lESENmem5BWXIvaG5qa2FXUHZrVjdNTUJzeHdPR3ozN0gxUTVh?=
 =?utf-8?B?ZUhLUkFCVGwyTUlOUmk1VXZmM0NKbEZoRklUSlRCOXZJWXRrNldxK2piT245?=
 =?utf-8?Q?/Lh8=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 13dcb9cd-23bc-44bc-e692-08de366ecd89
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2025 15:31:05.5660
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1RlAz2hGWl0m9STW/O3tj+wZ5ce2QV0ejLXIABP4MFehz4EipCysomvl5hT3Nu3hvLweKKDPIJXr5YZAkEfOBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8070

W1B1YmxpY10NCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEZXVjaGVy
LCBBbGV4YW5kZXINCj4gU2VudDogV2VkbmVzZGF5LCBEZWNlbWJlciAzLCAyMDI1IDExOjQ4IEFN
DQo+IFRvOiBLb2VuaWcsIENocmlzdGlhbiA8Q2hyaXN0aWFuLktvZW5pZ0BhbWQuY29tPjsgR3Jl
ZyBLcm9haC1IYXJ0bWFuDQo+IDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz47IHN0YWJsZUB2
Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IHBhdGNoZXNAbGlzdHMubGludXguZGV2OyBMaWFuZywgUHJp
a2UgPFByaWtlLkxpYW5nQGFtZC5jb20+DQo+IFN1YmplY3Q6IFJFOiBbUEFUQ0ggNi4xNyAxMjkv
MTQ2XSBkcm0vYW1kZ3B1OiBhdHRhY2ggdGxiIGZlbmNlIHRvIHRoZSBQVHMNCj4gdXBkYXRlDQo+
DQo+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiBGcm9tOiBLb2VuaWcsIENocmlz
dGlhbiA8Q2hyaXN0aWFuLktvZW5pZ0BhbWQuY29tPg0KPiA+IFNlbnQ6IFdlZG5lc2RheSwgRGVj
ZW1iZXIgMywgMjAyNSAxMTowMyBBTQ0KPiA+IFRvOiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdr
aEBsaW51eGZvdW5kYXRpb24ub3JnPjsNCj4gPiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+ID4g
Q2M6IHBhdGNoZXNAbGlzdHMubGludXguZGV2OyBMaWFuZywgUHJpa2UgPFByaWtlLkxpYW5nQGFt
ZC5jb20+Ow0KPiA+IERldWNoZXIsIEFsZXhhbmRlciA8QWxleGFuZGVyLkRldWNoZXJAYW1kLmNv
bT4NCj4gPiBTdWJqZWN0OiBSZTogW1BBVENIIDYuMTcgMTI5LzE0Nl0gZHJtL2FtZGdwdTogYXR0
YWNoIHRsYiBmZW5jZSB0byB0aGUNCj4gPiBQVHMgdXBkYXRlDQo+ID4NCj4gPiBPaCwgd2FpdCBh
IHNlY29uZCwgdGhhdCBvbmUgc2hvdWxkIGNsZWFybHkgKm5vdCogYmUgYmFja3BvcnRlZCENCj4g
Pg0KPiA+IEBBbGV4IG9yIGRvIHdlIGhhdmUgdXNlcnF1ZXVlIHN1cHBvcnQgd29ya2luZyBvbiA2
LjE3PyBJIGRvbid0IHRoaW5rIHNvLg0KPiA+DQo+DQo+IFllcywgdXNlcnEgc3VwcG9ydCBpcyBh
dmFpbGFibGUgaW4gNi4xNy4gIFRoYXQgc2FpZCwgdGhpcyBwYXRjaCBkaWQgZW5kIHVwIGNhdXNp
bmcNCj4gYSByZWdyZXNzaW9uIG9uIFNJIHBhcnRzLiAgSSd2ZSBnb3QgYSBmaXggZm9yIHRoYXQg
d2hpY2ggd2lsbCBsYW5kIHNvb24uDQoNCkFmdGVyIGZ1cnRoZXIgaW52ZXN0aWdhdGlvbiB0aGlz
IHBhdGNoIGFuZCBpdCdzIHVwY29taW5nIGZpeCBzaG91bGQgb25seSBnbyB0byA2LjE3LiAgUGxl
YXNlIGRyb3AgZnJvbSBvbGRlciBzdGFibGUga2VybmVscyBpZiBpdCdzIGJlZW4gcXVldWVkIHVw
IG9uIHRob3NlLg0KDQpUaGFua3MsDQoNCkFsZXgNCg0KDQo+DQo+IEFsZXgNCj4NCj4gPiBSZWdh
cmRzLA0KPiA+IENocmlzdGlhbi4NCj4gPg0KPiA+IE9uIDEyLzMvMjUgMTY6MjgsIEdyZWcgS3Jv
YWgtSGFydG1hbiB3cm90ZToNCj4gPiA+IDYuMTctc3RhYmxlIHJldmlldyBwYXRjaC4gIElmIGFu
eW9uZSBoYXMgYW55IG9iamVjdGlvbnMsIHBsZWFzZSBsZXQgbWUNCj4ga25vdy4NCj4gPiA+DQo+
ID4gPiAtLS0tLS0tLS0tLS0tLS0tLS0NCj4gPiA+DQo+ID4gPiBGcm9tOiBQcmlrZSBMaWFuZyA8
UHJpa2UuTGlhbmdAYW1kLmNvbT4NCj4gPiA+DQo+ID4gPiBjb21taXQgYjRhN2Y0ZTdhZDJiMTIw
YTk0ZjMxMTFmOTJhMTE1MjAwNTJjNzYyZCB1cHN0cmVhbS4NCj4gPiA+DQo+ID4gPiBFbnN1cmUg
dGhlIHVzZXJxIFRMQiBmbHVzaCBpcyBlbWl0dGVkIG9ubHkgYWZ0ZXIgdGhlIFZNIHVwZGF0ZQ0K
PiA+ID4gZmluaXNoZXMgYW5kIHRoZSBQVCBCT3MgaGF2ZSBiZWVuIGFubm90YXRlZCB3aXRoIGJv
b2trZWVwaW5nIGZlbmNlcy4NCj4gPiA+DQo+ID4gPiBTdWdnZXN0ZWQtYnk6IENocmlzdGlhbiBL
w7ZuaWcgPGNocmlzdGlhbi5rb2VuaWdAYW1kLmNvbT4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IFBy
aWtlIExpYW5nIDxQcmlrZS5MaWFuZ0BhbWQuY29tPg0KPiA+ID4gUmV2aWV3ZWQtYnk6IENocmlz
dGlhbiBLw7ZuaWcgPGNocmlzdGlhbi5rb2VuaWdAYW1kLmNvbT4NCj4gPiA+IFNpZ25lZC1vZmYt
Ynk6IEFsZXggRGV1Y2hlciA8YWxleGFuZGVyLmRldWNoZXJAYW1kLmNvbT4gKGNoZXJyeQ0KPiA+
ID4gcGlja2VkIGZyb20gY29tbWl0IGYzODU0ZTA0YjcwOGQ3MzI3NmM0NDg4MjMxYThiZDY2ZDMw
YjQ2NzEpDQo+ID4gPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiA+ID4gU2lnbmVkLW9m
Zi1ieTogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4NCj4g
PiA+IC0tLQ0KPiA+ID4gIGRyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2FtZGdwdV92bS5jIHwg
ICAgMiArLQ0KPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlv
bigtKQ0KPiA+ID4NCj4gPiA+IC0tLSBhL2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2FtZGdw
dV92bS5jDQo+ID4gPiArKysgYi9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9hbWRncHVfdm0u
Yw0KPiA+ID4gQEAgLTEwNTYsNyArMTA1Niw3IEBAIGFtZGdwdV92bV90bGJfZmx1c2goc3RydWN0
IGFtZGdwdV92bV91cGQNCj4gPiA+ICAgfQ0KPiA+ID4NCj4gPiA+ICAgLyogUHJlcGFyZSBhIFRM
QiBmbHVzaCBmZW5jZSB0byBiZSBhdHRhY2hlZCB0byBQVHMgKi8NCj4gPiA+IC0gaWYgKCFwYXJh
bXMtPnVubG9ja2VkICYmIHZtLT5pc19jb21wdXRlX2NvbnRleHQpIHsNCj4gPiA+ICsgaWYgKCFw
YXJhbXMtPnVubG9ja2VkKSB7DQo+ID4gPiAgICAgICAgICAgYW1kZ3B1X3ZtX3RsYl9mZW5jZV9j
cmVhdGUocGFyYW1zLT5hZGV2LCB2bSwgZmVuY2UpOw0KPiA+ID4NCj4gPiA+ICAgICAgICAgICAv
KiBNYWtlcyBzdXJlIG5vIFBEL1BUIGlzIGZyZWVkIGJlZm9yZSB0aGUgZmx1c2ggKi8NCj4gPiA+
DQo+ID4gPg0KDQo=
