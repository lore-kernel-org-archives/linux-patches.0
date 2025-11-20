Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011059.outbound.protection.outlook.com [52.101.52.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007E81DE8AE
	for <patches@lists.linux.dev>; Thu, 20 Nov 2025 01:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763603799; cv=fail; b=W165pAyZJh4Erzmsyi/e1vrh+rYbrfJnrBJcU+ojUwYGFb7b/s5QGC7aMed0QFSFRn/sWY1DpdUUX8R/twmGSqbllf1VKdV5AscXmJRmISWoA5nugXST8i0W6n3gV6cC0QneAwYkO1aZ8flaSrweGIJEHL7KOwrol/sJDK/AKEU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763603799; c=relaxed/simple;
	bh=QZWB95Tfnm6jkP2cnMLV4eWvYIu8cw+KiXIawKOm9V0=;
	h=Content-Type:Date:Message-Id:Cc:Subject:From:To:References:
	 In-Reply-To:MIME-Version; b=IvUbOCYmkHSLoJrh096fWj//ZmY4BN7YAn/D8nHm15ZTWgHsNF3/0KYst0CUYMDJd0jwQPfDgWGYPCPXnTyFRO+mJIyATgTq32azbUy6t0vkrjyfb5kPhdQU0/R4PZWm7GvroEvYFbDcfHq1xOddYvyUKrz/JBKulJmDeySXrt0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ufMguvQk; arc=fail smtp.client-ip=52.101.52.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ufMguvQk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lx2EugHpJECRtqlWloqCa0oMEgUXLRFkdXc2xfWozbMzuNDP67V3fvIjaUgP7rJcJJmt3VOVeBvS9ri2nt2N/fV7K+AOWYfl3Kq3mgbOaXupA7uo0/HLzjN3wKvuFHtMGw3QrXpFcUg6Fsu7xQjgy2GQu5M6UQz7yBRQ3A88KMmmdng6whj4KQoAun0t8DLS4Uw9thE/WWkmheSr3ATBnIVGq1XFDiB3U7BbBGdAQQATCJ8X8GFU97MubQlmb94OBj2GmG6daKRHeUG1XmzT2qI1G46AJuninbYO2YDsEea0Str1KCFlKKrK4P2V3J51levOPl6NjfCsuAMQ5v11PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/PfyDFy4loYzQgtYzh+9cziUFEVhbiu7L4lz2ddexBw=;
 b=ZfquZ9A9VnSOgmokSHlnMyNeZ6YvypZUCead6BM2b53MqEGXRaOLMiOPdeq5lSn5FEPtC6dueScba3r+hTBsE5kC5QmC4BKZSvGO36vJZKZMAx1pe/guwUVjOuZQGRxsoupw9+0N3i/vtAsKdOewDYfN3+YES2t8/lHXwEMKJvH96ZNaIC1iMu+ZQpwB21UY7pUZH/6WGwNrcz2zgUyDVPOUo22gucSEnOesbwxEoQ5aHPFztLSa1izb9fxvuPs5OkExvhGFVcacDzR9r7dTGfkPTXCr3wq8wp7IBNkOCbWqcOU/bs4Er+TvMD9PvuRuyjH9GwVB6q/hAyi/OT3F4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/PfyDFy4loYzQgtYzh+9cziUFEVhbiu7L4lz2ddexBw=;
 b=ufMguvQkBtbW7awHRiipnL6ZN79OJVnBaU235UwhCGsGquR/LuqcBdg/K3JK5TrmvloXq/eAv0uaKJcJM5DDKPGZZ0b+MW3hukrdHrFhiHzCVmgga9GnmowruttCDpAUJ0ioLPlnBNQq+0PyRELeiEANAvODs7BE1d6v3QDMqA/hz83gCe0SIB8QfjA+03O7DzFi7KrfYsN1JPFW0NKJSrjyEJA5b/Fyg0sX02eRNmw4T0mLrlXqZKrrQrERQslGf8QdAq5PWHnpYHCxdN5GlnJ01YrOeWc9fB5v0K9djoDeXW+HbmrDBanscUOJMzY7LZZ58NNXUwP6Iq8cEpX86w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB3990.namprd12.prod.outlook.com (2603:10b6:610:28::18)
 by BL3PR12MB6425.namprd12.prod.outlook.com (2603:10b6:208:3b4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Thu, 20 Nov
 2025 01:56:33 +0000
Received: from CH2PR12MB3990.namprd12.prod.outlook.com
 ([fe80::7de1:4fe5:8ead:5989]) by CH2PR12MB3990.namprd12.prod.outlook.com
 ([fe80::7de1:4fe5:8ead:5989%6]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 01:56:33 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 20 Nov 2025 10:56:29 +0900
Message-Id: <DED5D81TXPCO.3FK81IGE9KR0O@nvidia.com>
Cc: "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <lossin@kernel.org>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Trevor
 Gross" <tmgross@umich.edu>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH] rust: slice: fix broken intra-doc links
From: "Alexandre Courbot" <acourbot@nvidia.com>
To: "Miguel Ojeda" <ojeda@kernel.org>, "Alexandre Courbot"
 <acourbot@nvidia.com>, "Danilo Krummrich" <dakr@kernel.org>, "Alice Ryhl"
 <aliceryhl@google.com>, "Alex Gaynor" <alex.gaynor@gmail.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20251119185125.1411151-1-ojeda@kernel.org>
In-Reply-To: <20251119185125.1411151-1-ojeda@kernel.org>
X-ClientProxiedBy: TYCPR01CA0185.jpnprd01.prod.outlook.com
 (2603:1096:400:2b0::11) To CH2PR12MB3990.namprd12.prod.outlook.com
 (2603:10b6:610:28::18)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB3990:EE_|BL3PR12MB6425:EE_
X-MS-Office365-Filtering-Correlation-Id: 24c60f67-9f77-465e-2704-08de27d80775
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|10070799003|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bHlNaHpHTkgvOWNxaVhZYit1cnJudUVYSHgrc1daandYRW43aGk3L3MzMHFO?=
 =?utf-8?B?V2xURHRBSjg3am5BSlZXZUEzeDFpNG9UbjYzZlZXWWRvVWt0SUVySTJDaWZK?=
 =?utf-8?B?MW80OHlUcHgyc3A5VXo5a2NQSE1uKytGRmhWMVljRGxBRlRKTEc2eFFuK29R?=
 =?utf-8?B?QjF4TWRGUmxHM0hOS1FUMEZwb21kdEowZ3MxR21iM0g0dkJydUVqa1pZQ1Nq?=
 =?utf-8?B?U3NrbjZ3L2NlS00xcjNPdmI4TGtadkE4dTBzMXRxeG50bzJUUi9TZkd3WTNr?=
 =?utf-8?B?THNvOFZVVXNUZUJ1Qm1Pb0VHeHd2Q2QraHJZOG1vQThXTDIyY3Z4cFE3SFhq?=
 =?utf-8?B?ZTV4V29lL2cvNnRoa1BORk1YYVlyakozUUdNamIvM3RFWk5MWFhZU1I3MEpq?=
 =?utf-8?B?RHM2Y3QrSEdoTnF2MHcwM2cySGEzWmlveGQzOVFhNEZLa3NuaVNOU0p6ak03?=
 =?utf-8?B?SEY1d3BIdGg2bUZUQmo1bCs3OU03SFh0VktuTFBHMHZUR3RoUzR5ZzVpUS9y?=
 =?utf-8?B?S2JzVWVOcDROM2E5Y1F1eEZwcjJzODMzbEc4TzZ0QklFeG1QcndLUHJtSEZF?=
 =?utf-8?B?S0d5WFlNOUVCWEJYUERSeHJneU9OTXY1d0ovY2FUcEZBbUVEYXI1d0h6Z2Vo?=
 =?utf-8?B?RXEwN3VWQmhFcDFUM0lXL0oxd2s3WFBVNjI1dVlyTkRkelJZYWFGbE9ROGdT?=
 =?utf-8?B?clRDa242aGVwbGg3Z01kWW5FSFcvUTRQbW15NmUycWU5RklZS3JhQnRWZzN5?=
 =?utf-8?B?OTZ2RlcwMjBwT2Y1Tm1LNzB3NWl6aXcrK3UzRVgxUzBaM1cvSjBsN2xHSlQv?=
 =?utf-8?B?TXVwUk5xN1J5OElCSi9kOTZ2emdEVTVySlVtS1kxSVNSRzdVZEdLU2dqYWdx?=
 =?utf-8?B?NVIzYTdpY0R6aktwM2cxc3dvUmE1VkFmVjRvYUFUMTZFdzVTZlBYK1pYRkJh?=
 =?utf-8?B?U1Z0dFFOdjArUjRCQ3UzM0VoQzAvajF3N2xXYjMwZWVEWGJuQ3pWZnFFdFNX?=
 =?utf-8?B?bE5lQjNJcjlYL1JtZW5IR1pwbmVzUnlLcHViT1Q3QkFFWFhZNEY4TWNBaTQr?=
 =?utf-8?B?QkZCb1NJeUhJYVpzdTI4ZUZCVVN6ZzFnR252SHJoSnZHNkFnYWozYTZGem1u?=
 =?utf-8?B?V2ZvQU1xUXdIRytkanJvNThRSHlsWTJCcWp5cXhyOFhHVXRWWXRNQVlTVy96?=
 =?utf-8?B?UStaNmpYNHpQM0FNd1FNNlhzdW8xSWZnNURYbk44MS9lTkd3UU9vU2ZtUTJC?=
 =?utf-8?B?eGdrbE5YY2Y5WVZ5SG50VWl3YU5tNjRYdWU3Wnl4dlJHc2N1OGJUK0NtWDdJ?=
 =?utf-8?B?M0FsajZ2Wlp4UmVSaGE4RVd1TWxnaTVkZnc3NllMQVBCbWZyVGxtTHRFdEVr?=
 =?utf-8?B?dzRLYllheGY5bEVGOGN5VXBlQ2Z3cTBQckJQRUsrTEg2YStEYU5NMXVkWlQy?=
 =?utf-8?B?b0pmWHVBL1V2cTJxRlJIYkhnV2ZleWlxbFJkMEc5V1hHcG0yYnZEKzg5a01i?=
 =?utf-8?B?bnZRNnhRSGRqUTJHTVppTVNDaVhGeWxhcTh3eWliR2ZYcFNkU1ZmOTkwR09H?=
 =?utf-8?B?YXZxeGJGSjBlb3VyY1JnT2tEZzlPSUllNmhOQ0w0MGdpZUZWVTBobGhoTmtZ?=
 =?utf-8?B?dmV0d3BQVzJNQ1UrQkpuanBJL3F4QVVJT3lHN0V4djd4UFA2SFMzRmpPc1Y1?=
 =?utf-8?B?MFU1SW5mdlRPYWFLMG9MV25rdExkNmU4VXY4QVZYOS9WOEJyVzVHVTRDNmxV?=
 =?utf-8?B?dVkyQ1R5ZzRRM2JPNFppRVcyT0pLWjJUMVNKeG1BbTQyQy9IdUxTSHhhVmla?=
 =?utf-8?B?b3NYYXY4cTE2a1Vsb0lDTDIzbS8zTDBid0pyY3d2VE9uTU5lN2pGRTRQRURv?=
 =?utf-8?B?bmhTRTFzY1lxa0htdHJVNm1IenVkb1VvTGc2N0V0dHBkMlJKNXdhU0dZVFk2?=
 =?utf-8?Q?KTRM5UfGfgGo2kaUjJFag9TQcGOyslZT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3990.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(10070799003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bHBDSy9oYUgwMU5lUjJFUGxJZ1VOcEZIczNkNzVZdUpFaGVQZkJHNVVHUGJM?=
 =?utf-8?B?ZWdkQ0dmYmF5TFRzSHYvWGdVcnJIeGpJTTJoVWdYSlNMSWRRdFpoQlRXV1k3?=
 =?utf-8?B?SFRSdlNOM05oZ09kSnN0Z2lUVDY0djlaaGltWWE3WDQyWTJVSWNRdldsOXM0?=
 =?utf-8?B?OExOZXB0UE0wK29sVHNpK1BhT2NVWDRVeWp1cURmeFJod3UxQldXOE4vaytx?=
 =?utf-8?B?ZkVXdFFXZk1qaUxYMVFZMEErREhDSlNVRGlYQ2F2NEhibXQxRGlkb0NYclNl?=
 =?utf-8?B?bGtXbEJHa3BEYWE4TENIcWlBM21rYVBiSW1TY2ZMUWxMWmJIRUU4SjRDeGpj?=
 =?utf-8?B?bmI3ZFEyRmw2b09BQy9ONFRlSEh1T1pFQjhaS0tyTExDMkRxMGdNTzZSNVRk?=
 =?utf-8?B?MkNuWWZCVFZNcitOanZ1SXM3aDNWRnlyTUlwRDl3OFF0d2QxaTB5azhrTzB5?=
 =?utf-8?B?L0tkdzVsVVRiazhtRVNudlB0OW5sV2ZwNWtvZTNQb29SUVZYY1YzaTNkdUlJ?=
 =?utf-8?B?dlZIZC8wMFhVK2xDSll3YjQ2RWRRbDU2STMvQTUxZWxRZ0RneFdSOUJtWm1T?=
 =?utf-8?B?TUVpVzh4TzZFSFNzM2ZBRnhYYXVld2kwV0NDcUxaQ0tOQmZlbHNTS2d2dnJo?=
 =?utf-8?B?SkxhTDQ0VlErOTB5VW5JTTRobE1aZmpXWWZ2SXU4TzZVUjBxTUxwY2lXZ2Rz?=
 =?utf-8?B?YUowMHJKZzRpMTZGWERYbnlEQ2pMS3E1ZXJ0RHFWTStvWWFiakNleUU2dTRa?=
 =?utf-8?B?QTZrenFha1R6TjNSd2NZcDZIYUFyaDN2Q1Q2aC9sbklKbysyR3lWRzJXSkZj?=
 =?utf-8?B?Ny9MQ0ZkdGF3MkpTeFJPbVMxY3l2TXJEYlhyY2NENFlhZzVWL1pCbEpzM2Z3?=
 =?utf-8?B?M254NXQ2MWVzYmZocCsydGJ4YmQyWUpOU0FUTC9Gc0lEbm5FakVDSXhpS0du?=
 =?utf-8?B?eDFzU0VJQ3ZUbUJQMGs3TU05Rnc0dm1JWUVibTNiS0syMGovR3FESkxBcXBp?=
 =?utf-8?B?bks0dWVGeVBMeUlpSnZuWFdiRjloV0NyRzU4Q2tqWnM2THZERGtKRTNqSUox?=
 =?utf-8?B?Z3lkRGpReERUNWE0aXhwWDJ5aWxuVXRhc2M1QkpLNHJhSWhwMFVVZ2poWEJp?=
 =?utf-8?B?Rms4Um0ydUhzRGkrV3ZvREZmdXBDcFl0S2R4dkVrUWQ1N2Jna21hby94QUNL?=
 =?utf-8?B?S2pQa3hSdUwzQXF1THBhN0l6cE5mOXVnOURSOXFDd2lIVEJCWlFmRmRmL3Zk?=
 =?utf-8?B?eEpDRnN0eklURHJhTjhWTDEvbytUSGswbGhLdFZiOTlUZGgrcWI3R3NpcE15?=
 =?utf-8?B?K1czdkFlVGl1OCtHZmtxdnhmazlpM09IcnM3dXJQYWI4ZzlXQXJCaTVGTm5I?=
 =?utf-8?B?c2Q3TkZHcXA4c2FWeG5Bc0p2QWVVUGV6Ny9CMm1oMXdJVXhubzN4OW5iWXJj?=
 =?utf-8?B?NkRUcldEQ0I0OWc2Zm1xMTVxS1pmT3ZncHU5YVRDN1B6aEFRSE1BK1dJS080?=
 =?utf-8?B?dGk3TUpPbS9Qa0pBdlV6RktBWlJOUDFhVlRZeDJla0J4bkt6M2IrZWhDNDBF?=
 =?utf-8?B?SW1ROVFXNEkwTnpJbE8ycFErUGJUWlNOa0VtWEVwTDRyRk9BMXB0MUh2eDBx?=
 =?utf-8?B?cU9hTmwyckQ2WEpYQ1p4U2N6eHpwcHZhdllGNS9XUExYQjBqZTkrcDZSZzBV?=
 =?utf-8?B?ZGhxejRlR0YvRU5WMk5MY3RGL3loNkV5SFBwdlZHbTdCNzhlUFRKR0Y0Mkl6?=
 =?utf-8?B?SFZhNzlXUzJuS295QU4rNXFNL0dOZ3Z5WkpkeHRlWS9GV09yTTBUazdzTC9E?=
 =?utf-8?B?SkR1WU5xUTVzR0E2ZjhCVWp6V21YTXp5MGw2ajRVY0Zha2lRSEdnZUxJUTZS?=
 =?utf-8?B?cGFwcElPTVNobnJYMk5tYk1nZUVWRjdteGJVUDl5SE45cGE1QXNTcmtCRHE0?=
 =?utf-8?B?YUkxNVJsbEpXNlFKM3hiL2hTTXo0UHBzMWxLcEZ5WVZmbFVYL0F4UGhMZzlJ?=
 =?utf-8?B?b2FjY2hGemo0d2d5eS84SlM2V05HL1NCMk45QkN6UmJvZFREUWxLejJScG1m?=
 =?utf-8?B?em02ajgzSy85ejB2QkdpSHY0bXBIQjg4N1FVekNHaFlhaSt0ZHFQc2FGbXF4?=
 =?utf-8?B?Q243VGRVdW40OEFYckhPRHBsSkdiNktvRW1UN3grSE9ZRU4rQkFNdmxHdTNR?=
 =?utf-8?Q?I9dJIwXPLNPDBXrDlMAMCv46PqiFig8r2T5tudTvEEWr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24c60f67-9f77-465e-2704-08de27d80775
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3990.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 01:56:32.9432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dEk5NAsiU+CQ0accnCozn9ekK3lTdJuyK2ZnzIOzyAOi0ZdlUBzC/ySPk58tOjQTFy0HCdtHIVexwBbW/8NX0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6425

On Thu Nov 20, 2025 at 3:51 AM JST, Miguel Ojeda wrote:
> In older versions of Rust, the compiler doesn't know about the newer
> `as_flattened*` methods, thus `rustdoc` complains about the intra-doc
> links, e.g.
>
>      error: unresolved link to `slice::as_flattened`
>       --> rust/kernel/slice.rs:19:23
>        |
>     19 | /// [`as_flattened`]: slice::as_flattened
>        |                       ^^^^^^^^^^^^^^^^^^^ the primitive type `sl=
ice` has no associated item named `as_flattened`
>        |
>        =3D note: `-D rustdoc::broken-intra-doc-links` implied by `-D warn=
ings`
>        =3D help: to override `-D warnings` add `#[allow(rustdoc::broken_i=
ntra_doc_links)]`
>
> Thus fix them by using an URL instead.
>
> Fixes: 88622323dde3 ("rust: enable slice_flatten feature and provide it t=
hrough an extension trait")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> I have seen this in -next -- please feel free to take it or rebase if
> preferred etc., of course. Thanks!

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>

Alice, I guess we will want to take this into drm-rust-next or
drm-rust-fixes since that's where the patch introducing this originates
from?

