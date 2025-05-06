Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF6C1DDA2D
	for <patches@lists.linux.dev>; Tue,  6 May 2025 14:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746541925; cv=fail; b=hf2MCAaCcYA3cJ0mMFfNmqz9ovVkgPVPURtkcSyRbNy12i9b0M3DQAC0TJRfOQGPSwbGr3i6EKFWEvmr+6YjrZ7IBwPNwtj0hHaYMPNXFlIcFJyDtLwjooLLSN6nB8F67LhDr3uStvbk3BhnXKG/IP1SAvqIFpBwQVuj1mic1/8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746541925; c=relaxed/simple;
	bh=VAdsZSoNmEMz2gG+Tn2slEI1el/W869FMV7RVuG4sJU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=V7t6PBUycS9Jifo5+/ZOd0nckevVdxHYgtXCzz1qZMUEvQdsp/5exq3Zy4O07DKgmM93VnKpW/4lJLSYsiT+c9TtIUM3ShxBoGm/jf5aj9DR3RlzQLG3V91Dks5D7iihWM4sXlffXfNR1zeRZ48kyDKOyk1Vslk7YmKaKNEC9rc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QazAhy5V; arc=fail smtp.client-ip=40.107.220.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QazAhy5V"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lU5WY3rwK/YjRMHglf2oXRgxnbnwz9gZYsmvsGxsZtuczBdKuOhepl48tOGlcF4+l9Dhnr7DxmG3Gm24J10PwrK1z/Oivv60mcGnQun+vCvVzQfffvM6eeQ5DFn7JRkSu1BfOSPmaNCcjysbj9tcufs1eeaXwYHxOHg59MxTDBgMfHGxSYHWICSr/Ml3OZ72vecGpcGBGA01rwx4OybtGcir+OEcJl7SVkEFu0BQNgoMO6yI4PCF+tkj2bwDMnbyexy+9INpf7sYvE66I/f2auvgihcPddeHhmBQwljvHGBKGx0LvBLHiQku6caQ6bFjfvxttqZFx4Oq34grHBwgaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZwtsvRg4O8TwiBD4LBIhYm91LXDio2IJo6EuiO2+apY=;
 b=XMpLV/GjN8P+A2z6KlVwABS7ydKwHGMV2FOcMpfzILCgyg1ahgwH+/JNWH2WBhilC2wj6TBrRRo462bjOiMfNdtUrNO9CheviGm1EzvsjLhxbGNp7LP+E28fngyuWShYCh0HP7r67ehNMUjoXf6Zym5n2Vtt3IXosZI5qoqpEZLm9vub2IEg/CfnPVtDBZSpEbtrP3MeTnZnL1Q4vLsJqsquKqdDaRJnSQsC5hqZXdtycn/oZ62mqLpeSf0wc9bpAJztHPkC4e75cU9gPks2jRJ5MCaJvLeF6i++7tPooKdljjt389to8WbriQa0UUQWere1C4MMY8HeXEnrKXhDvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZwtsvRg4O8TwiBD4LBIhYm91LXDio2IJo6EuiO2+apY=;
 b=QazAhy5VS2Gqv5/fKCfJpeFRYXX1+91nj47pTN0AudZqCBtBkENM1pOeUuVSSo3LSiH2C73Urx0nJoMHWKcD/LI1aZXXJ3tUOpnwiXXL+mxKFdMOn2bnQ7ZWmMSf1KNMyAQXDV0MBKCxcFv8VOlpzo7xBMTCSEgBPy3/509xz8VHPj/SFaIkQRrJh+YOlInbCs+73wf/ErsmkyEaVSETQ1F5mrT+GzLPcZhUb81JUf7LC5ewOMw4OPvqguTX9IuLkkarbxS/FNJ5tQ8PajUP/SAkzCACGR2RIhIrMss4qtHbDgFf2t8UwNpi5nDSkHULi1M7jY03DTyeqFCve9qlRg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6363.namprd12.prod.outlook.com (2603:10b6:a03:453::9)
 by LV8PR12MB9083.namprd12.prod.outlook.com (2603:10b6:408:18c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.23; Tue, 6 May
 2025 14:31:56 +0000
Received: from SJ1PR12MB6363.namprd12.prod.outlook.com
 ([fe80::bec3:4521:c231:d03b]) by SJ1PR12MB6363.namprd12.prod.outlook.com
 ([fe80::bec3:4521:c231:d03b%5]) with mapi id 15.20.8699.026; Tue, 6 May 2025
 14:31:56 +0000
Message-ID: <922ba351-2b17-4b92-94d2-8a1fef390cd5@nvidia.com>
Date: Tue, 6 May 2025 17:31:50 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 092/311] ublk: call ublk_dispatch_req() for handling
 UBLK_U_IO_NEED_GET_DATA
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 Sasha Levin <sashal@kernel.org>
References: <20250429161121.011111832@linuxfoundation.org>
 <20250429161124.815951989@linuxfoundation.org>
 <830759ad-243a-4fd5-9fa1-a106e6e6bb0d@nvidia.com>
 <2025050455-reconvene-denial-e291@gregkh>
 <744b4d9b-24f3-487c-805f-5aa02eaa093b@nvidia.com>
 <2025050509-impending-uranium-ccba@gregkh>
 <c5022682-52e7-4340-995c-7d3d84bb77aa@nvidia.com>
 <2025050537-flaring-wolverine-c3fd@gregkh>
 <843866f8-059a-4e5d-8316-19c92ae25a82@nvidia.com>
 <2025050524-turmoil-garden-66b3@gregkh>
Content-Language: en-US
From: Jared Holzman <jholzman@nvidia.com>
Organization: NVIDIA
In-Reply-To: <2025050524-turmoil-garden-66b3@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR5P281CA0051.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f0::20) To SJ1PR12MB6363.namprd12.prod.outlook.com
 (2603:10b6:a03:453::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6363:EE_|LV8PR12MB9083:EE_
X-MS-Office365-Filtering-Correlation-Id: b5492245-3a5d-4a0f-3cda-08dd8caac090
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UTE1ckJFdXFFdCtMNlBKZklMcHRQUUppeThhMkdnOG1aNGEzeGdxbEgwZ2VF?=
 =?utf-8?B?QzdQUkJzRXhZdEYyandLcVVmaW9Za0tlbnduMHZSTXB5alBWcTRidHgrT3Y4?=
 =?utf-8?B?elgyUXV0M1pIWlV5aVBoL1ZGbGtVYXNnYXRnSDdPRWx5MkJKTW5HUllnaSt5?=
 =?utf-8?B?dDE5MWQ2V3JVTHZFOWFIdXRReXIxM2ZPcEtpMzZTRlpEQk5adFUzNzl2Y1hR?=
 =?utf-8?B?K0I3T3hEY0VhM1RaN0VKQVlRWUFxZEpON0ZsMWdnZk9MNVVDQWF5Vm1pNHN0?=
 =?utf-8?B?U1NsWUtIRVlLMGFiTGEzd2hCZUtmMTljVnA0WUV2UHVNdFhlTW5Bem1PMlVr?=
 =?utf-8?B?dmRtRCtDYW5RMXQyb3ZkUHhWOTBGdlBLTklITC9ObGNYMWZrVzRDRjBwL2Fo?=
 =?utf-8?B?S05qZUFFbm9pRjRISXNHTGhPNCtiTFlVY29xWnl1WFRGUWhhQlFvZnlVTkpn?=
 =?utf-8?B?OHQ2VVdwS1NPM1BuOENxNGVCWk15Y1JHTFNGQU1oUmR3Y1IvbzhPQkR0b1Br?=
 =?utf-8?B?RzNTZnJnMHIvVVkvRGk5S2dtdzg5Ukc5bjVGbkpYSDBoSS92N3F4SGFQZWVz?=
 =?utf-8?B?ZHBFcldQRUd5QlhOWU1wWjlXbnJNM1E3RWRJSWt5WDFBeU9vTXBjZW16SFBP?=
 =?utf-8?B?UENjVWlZN3p2MGE5TkZBdFM2NGJYcjU2ZCtTbzlDN2hnR1liTm84VG04dXRi?=
 =?utf-8?B?Q3o5OVkzUEllTnFuYmFzT0VEZkwwMm11Q3doZG9wMWUycVQvdFVDaWI4dWJX?=
 =?utf-8?B?WnBVY09EejE5aE5SVzZ4a0VkQU1lQ01vQlYzZDEyb2wvd3hISmk2dGVxbWh5?=
 =?utf-8?B?bVdmVDE3aGtENDgzTUFJc0pIbWRVMDdQdFVNZkplV3ovRTg1SThwdXZ1WTVV?=
 =?utf-8?B?L3ZjWnVJc1dHazNOTHFuK016MHQvVlFkNDFLNkVLSFBsTytDcy93ckRDUlZF?=
 =?utf-8?B?MnFYdzl3My9Dd2xzS2t2amMwQlM4M01FNENnOHhRS1BqZFhQKzRPemJHUTNX?=
 =?utf-8?B?ZFFIZndsUkk4NkdQbUJtand5NHc2TE1WdENXZm4vMEMxN2Iza3JSL3Bub0Iz?=
 =?utf-8?B?Q2FsK3NUbHNGbGxhNGxEZE03cXNpUStVT25JZ3pNOFFrMHFKQkgzM3VGd3Bh?=
 =?utf-8?B?T1NCWGRxMTgvK0ZoUGRqaWZmL3AwZkNyRUY5Tjh4K0d2MnlUempFR1kzVlU4?=
 =?utf-8?B?cEJ6NUtyQXB5c0g2R2ZVcDdXTzcrN0VtZlJPRDZLV0w1cHJZNzFBMU9PVWVQ?=
 =?utf-8?B?QXNRd1R0ZHR5QU1uWHNYd1dPd2Z2NG14Yjh3bGQwaGxaek9sTXh0dEd2ZTVB?=
 =?utf-8?B?MEJPYzUrZFMxYm5ZZTNlaVZPZVVmYlZEMHpKUmJMeDl5TFFJcWlTd1pSUlVq?=
 =?utf-8?B?THhXS0FnaEVWNmljd1VLaGZaZU1Ua1VZK3BhRWFLWmt5U0VsTFAzWFkxcm9m?=
 =?utf-8?B?WmlaWnA3cWZBeHI3N2pyMnZLVEdCNlZQbHlhOXNtY2NZUlRjNlRGcGNSeWdy?=
 =?utf-8?B?a09Cc2hLU0RITE5mUGxIbVoza29MZlNPOVNRRDlLTWdSZ2Zlby9qMGJqR05R?=
 =?utf-8?B?ck44U1ZNZUYwZW1jQWh5VlgvVGE0eDVWNHhpK25jNVB4cGJKbldlTlpqMERu?=
 =?utf-8?B?VjR4VUdENXpSMTdCUy9iaDFCbnE0VE9ka0Z6S01wVmdOQzdrQlljajVpcGNs?=
 =?utf-8?B?M21SVFNYUkEwaU9FdnZndEZkbzNwcUV2a2hBSFhTTXpUSmI1cHV6cHIraHVU?=
 =?utf-8?B?VFBLd0dBZEJxNG1mNU1ESGFMaDJwU1YrUHdvWFdGSkNBeU9tQ2dEeVd0cmlh?=
 =?utf-8?B?dW95OVFtZEVzM1l2VU4wajBKQUtJVnBHb25HNk4yMmtMUGZJRGtUTENRMWpW?=
 =?utf-8?B?K2lZbFJsV2lxakdmMzhua0VNWm9qamNaV1dXOGJ3SkZGbUVGNGdRaVhSQzU5?=
 =?utf-8?Q?mpmnYd7W/10=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6363.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z2hsUUE0S0dJOVZzM3dZQ3U4Q2xpY2pnNkEyMGVha0hjalUzRnZxYTB2aXU4?=
 =?utf-8?B?Tk5oTEVJcUFVNFZlSjgwSlJHRVBxSlhORmhWT1VDbFgzc0QvaGVlYjZoajNi?=
 =?utf-8?B?U25BWGtnM1FkWlkyZHQ4OVpLeWh1K0NscDR6dmNnYmpMWmV2TGovN1RoVitY?=
 =?utf-8?B?RFpYUHQ0Y0ZtTjJJZ1hFelJjMlRJTFhldERqckovQzEvMWppbmpxWGtIRFJM?=
 =?utf-8?B?YXViekw2MUdsQ1QrUWtuQnlLMUF0aGFWa2JLL0FpSDJhL2toZFhDcklSNzQv?=
 =?utf-8?B?RDlJV2NvMkdIZEJXbUFNcGlreXloaWZ0b3FkTzZMYkR1Wjk0UjNna2NGS2ZI?=
 =?utf-8?B?MGRPUWMzeFlaeEI0SXJ1V0Yrd2habVFIUlhEeENjczZkTFJ0WHlvT3BXTjl4?=
 =?utf-8?B?VWQxUW1uYmVHcFdHVG9aem9kUUpmeWI5c29PTkorNFhrbTN1Zm8wemE2UVNi?=
 =?utf-8?B?YTRaWEdxL21UT1hGd2hEalMzd1UrT25uNzdxNVFPb1JRUFE4V2ozY1l5bzJy?=
 =?utf-8?B?UndWdjB3S0l5MUZNa2FMOS80RnMyNElBOTQwbzlKR0F4bGR3OThmc09pYUVL?=
 =?utf-8?B?WGIyc1FQU1dBRDhNeTJjaldCOWZXTzljcGI1UFJQRWZuRG9oRFJLcWc5THZI?=
 =?utf-8?B?VHJTU3FWMXpkMHlIaEtBT09OMGZJV3lrRnpuZFI3ZDFtbVREbVRGTnc3aURk?=
 =?utf-8?B?MDBwVXVXdk5xdWpCalZxeXhGQllSR3BvTzFMOTFZNzdKSVlkLzdKcXp3ZkQx?=
 =?utf-8?B?d01EdXJjME95bnBIY0twOUMxMGRpb2FtQjZZVEppcGR0b3o0aE1MSkNuT1Fp?=
 =?utf-8?B?clRuVHduUFlvb0EwM0ZGSEpnQ3hBTXAzOHE2ckNoYXdDcEZZajk0ZzZEeUFv?=
 =?utf-8?B?RXVrVFV6S3JPV1FVTFBNRVljM1JHN2JQcHdnZ0lhYTh3amVkM2VTMTBnUHBK?=
 =?utf-8?B?dWpEUkE3aU5xdS9YdkFITGR0dXRwYnJtblhiUUJEcDJvUUhsY3Z1c1FkNFlM?=
 =?utf-8?B?djFsY2Vrbm9QQjdGeW1Qc2pxVDYwcG9HZS8wWmcvQ3RKcWNCcUdsNllyWS9o?=
 =?utf-8?B?Ymx3eCtNWW1jYy94ZGNFTU12Rjl1cERHUkxhNTZrZ2hUNUcxWWFDM3Bra2Vy?=
 =?utf-8?B?QTRBWWltZWtKVWtUN29XbmlpMlBmSktvYUhzNXFOR0NmdmJKNGc3b3F4WG5v?=
 =?utf-8?B?WUwrTkFpdUFlVGxzTzBSRS84YlMzSXBvMmxRelJNTEhrbnRKMGliOCtnSHVC?=
 =?utf-8?B?UG5lZG1wS05IaTFzUCtYV2hvZzVBNk9hdVIxZ2xDWXMzK1NqVzdNTCthVUxq?=
 =?utf-8?B?Vmo3T0dwa2IzUktFT2plOUt6eFF1UGVoblBFSjNDbDVjYlpveEY1c3pUYk9X?=
 =?utf-8?B?Q2k3YndBMGpOUXZmTjVYZG5PMW1IbDVhS2NodmZjMTNnOFB5TU5jcis2SlZo?=
 =?utf-8?B?QjkwbnJranh3Y3RnRU5Dek9xTTBnUjB4ZUwrSjJiUVpjS0JyTDVJV25ZUUMr?=
 =?utf-8?B?WEt3aktrNkZzL2s5eVoyVS9YWmdZMFlaZ0tPUEFzazBSM21HczJ1ZDdZekFy?=
 =?utf-8?B?dmlUUExkU3gzZzVCK29rSmxWTFJRcm1yZTZGUUpUV2MvY2orOE1EWnNHQlFx?=
 =?utf-8?B?UnVLRHZJeUNNbnJBenNMdVV1cEdOWERNcGlXeDI4S3A0KzFBbk4yWXhwYmtt?=
 =?utf-8?B?dHR1SHp0WW1oSFVwbURtYkREaTBpRGU1NEJWYjhicVhEdGNLN1ZwaWdzQmwr?=
 =?utf-8?B?anNxVlpwbDB6R2E0NkltUGVTL3RQVEZmS2Z5VGtGaXFhM2w5ek9VMEkrODlU?=
 =?utf-8?B?WWpDaTVtc2JWbzJjOXpnL3RTS3VzdmExcnA3cGtWcGtHSGZndWo0ZU10a2xp?=
 =?utf-8?B?UEZORVBKRWN2WE9sUDhTdGZzUVVIQWoxc1EzL1hlTlRXWnlPVG8xRG1KZUFh?=
 =?utf-8?B?bnp2Z3lBT3hqVGV5VXlsUmZOWVBoZVFhdm44c0VWZkVnM1lmYTFNTE54M3Z0?=
 =?utf-8?B?MVQyOE43NGtmK0sxZ3ZCd0dBV0FhYVlCZjFnTEl4d2R5M1NHM1A2TXFWS0Jn?=
 =?utf-8?B?S2JlWWRXanV5QWZKdlBLZUdFMWFGVHJHKzd1M1dvL2pLM0JjMWdYdUtibTF3?=
 =?utf-8?Q?Lr1gIKAEF9dCHlctfDrSmzDUa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5492245-3a5d-4a0f-3cda-08dd8caac090
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6363.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2025 14:31:56.1180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LIbqgBdcoIp/trpiZZJk71/2RFUq3xkpNwVNdu74aFvz0kOUfWaCjqrYsYpZDJcJQclS2FNzh7WMwlJkkmDppA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9083

On 05/05/2025 11:50, Greg Kroah-Hartman wrote:
> On Mon, May 05, 2025 at 11:25:24AM +0300, Jared Holzman wrote:
>> On 05/05/2025 10:54, Greg Kroah-Hartman wrote:
>>> On Mon, May 05, 2025 at 10:47:03AM +0300, Jared Holzman wrote:
>>>> On 05/05/2025 8:51, Greg Kroah-Hartman wrote:
>>>>> On Sun, May 04, 2025 at 04:47:20PM +0300, Jared Holzman wrote:
>>>>>> On 04/05/2025 15:39, Greg Kroah-Hartman wrote:
>>>>>>> On Sun, May 04, 2025 at 02:55:00PM +0300, Jared Holzman wrote:
>>>>>>>> On 29/04/2025 19:38, Greg Kroah-Hartman wrote:
>>>>>>>>> 6.14-stable review patch.  If anyone has any objections, please let me know.
>>>>>>>>>
>>>>>>>>> ------------------
>>>>>>>>>
>>>>>>>>> From: Ming Lei <ming.lei@redhat.com>
>>>>>>>>>
>>>>>>>>> [ Upstream commit d6aa0c178bf81f30ae4a780b2bca653daa2eb633 ]
>>>>>>>>>
>>>>>>>>> We call io_uring_cmd_complete_in_task() to schedule task_work for handling
>>>>>>>>> UBLK_U_IO_NEED_GET_DATA.
>>>>>>>>>
>>>>>>>>> This way is really not necessary because the current context is exactly
>>>>>>>>> the ublk queue context, so call ublk_dispatch_req() directly for handling
>>>>>>>>> UBLK_U_IO_NEED_GET_DATA.
>>>>>>>>>
>>>>>>>>> Fixes: 216c8f5ef0f2 ("ublk: replace monitor with cancelable uring_cmd")
>>>>>>>>> Tested-by: Jared Holzman <jholzman@nvidia.com>
>>>>>>>>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>>>>>>>>> Link: https://lore.kernel.org/r/20250425013742.1079549-2-ming.lei@redhat.com
>>>>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>>>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>>>>>>>> ---
>>>>>>>>>  drivers/block/ublk_drv.c | 14 +++-----------
>>>>>>>>>  1 file changed, 3 insertions(+), 11 deletions(-)
>>>>>>>>>
>>>>>>>>> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
>>>>>>>>> index 437297022dcfa..c7761a5cfeec0 100644
>>>>>>>>> --- a/drivers/block/ublk_drv.c
>>>>>>>>> +++ b/drivers/block/ublk_drv.c
>>>>>>>>> @@ -1812,15 +1812,6 @@ static void ublk_mark_io_ready(struct ublk_device *ub, struct ublk_queue *ubq)
>>>>>>>>>  	mutex_unlock(&ub->mutex);
>>>>>>>>>  }
>>>>>>>>>  
>>>>>>>>> -static void ublk_handle_need_get_data(struct ublk_device *ub, int q_id,
>>>>>>>>> -		int tag)
>>>>>>>>> -{
>>>>>>>>> -	struct ublk_queue *ubq = ublk_get_queue(ub, q_id);
>>>>>>>>> -	struct request *req = blk_mq_tag_to_rq(ub->tag_set.tags[q_id], tag);
>>>>>>>>> -
>>>>>>>>> -	ublk_queue_cmd(ubq, req);
>>>>>>>>> -}
>>>>>>>>> -
>>>>>>>>>  static inline int ublk_check_cmd_op(u32 cmd_op)
>>>>>>>>>  {
>>>>>>>>>  	u32 ioc_type = _IOC_TYPE(cmd_op);
>>>>>>>>> @@ -1967,8 +1958,9 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
>>>>>>>>>  		if (!(io->flags & UBLK_IO_FLAG_OWNED_BY_SRV))
>>>>>>>>>  			goto out;
>>>>>>>>>  		ublk_fill_io_cmd(io, cmd, ub_cmd->addr);
>>>>>>>>> -		ublk_handle_need_get_data(ub, ub_cmd->q_id, ub_cmd->tag);
>>>>>>>>> -		break;
>>>>>>>>> +		req = blk_mq_tag_to_rq(ub->tag_set.tags[ub_cmd->q_id], tag);
>>>>>>>>> +		ublk_dispatch_req(ubq, req, issue_flags);
>>>>>>>>> +		return -EIOCBQUEUED;
>>>>>>>>>  	default:
>>>>>>>>>  		goto out;
>>>>>>>>>  	}
>>>>>>>>
>>>>>>>> Hi Greg,
>>>>>>>>
>>>>>>>> Will you also be backporting "ublk: fix race between io_uring_cmd_complete_in_task and ublk_cancel_cmd" to 6.14-stable?
>>>>>>>
>>>>>>> What is the git commit id you are referring to?  And was it asked to be
>>>>>>> included in a stable release?
>>>>>>>
>>>>>>> thanks,
>>>>>>>
>>>>>>> greg k-h
>>>>>>
>>>>>> Hi Greg,
>>>>>>
>>>>>> The commit is: f40139fde527
>>>>>>
>>>>>> It is Part 2 of the same patch series.
>>>>>
>>>>> It does not apply to the stable tree at all, so no, we will not be
>>>>> adding it unless someone provides a working version of it.
>>>>>
>>>>> thanks,
>>>>>
>>>>> greg k-h
>>>>
>>>> Hi Greg,
>>>>
>>>> Happy to provide a version that will apply. I just need to know where to get your working branch to base it on.
>>>
>>> The latest stable release tree.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> Hi Greg,
>>
>> I tried branch linux-6.14.y of repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/
>>
>> But I can't apply any of the previous patches in the series [PATCH 6.14 000/311] to get to the point
>> where I can create my version of the patch.
> 
> All of those changes are already in that branch, right?  So no need to
> apply them again :)
> 
> thanks,
> 
> greg k-h

Hi Greg,

Thanks, I figured it out finally. Sorry for the noise.

I needed some help with the patch, so I consulted with the maintainer (Ming Lei).

He has provided me with a branch based stable/linux-6.14.y, containing several commits that are needed to get to the point where the patch can be applied.

I've tested it and it works and he has given me the go-ahead to send you a pull request.

I've never done that before so I'd prefer to just send a patch series to the mailing-list.

Let me know if that's okay.

Regards,

Jared



