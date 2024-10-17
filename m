Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2077.outbound.protection.outlook.com [40.107.21.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5261D416B
	for <patches@lists.linux.dev>; Thu, 17 Oct 2024 08:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729155434; cv=fail; b=hD7Cz0gXMuhh5cIy1Q4UfmYKVxFoCtwBdRQwLyV1spYij8L3krxUyukdLxnXAygDf0bsljs4n6voALQXEhXcI197sMds8ZoL/ocW82j5WYZzXvM0a4qBqclcrldDZxTu7dxlViubYThyaTXNrjBbc2dCFHzOFGCjjwv1DTSdc40=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729155434; c=relaxed/simple;
	bh=Xm5iMd2Thm1/dZMrxLP+onGaQM6WHYB/IeQWQCXa40c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=O8lfEvbYwHMYPeDqO//+FiP3lrvxuQIl3r9z9kcHJZ8nsAzTVjmojFCgK02U1KRNrcQhglFUu5sG6CzwWLgQpnIJXJmMQDFZ+1tpzyncoz4y6ro1yQFHHeEx76P8xZjV6LLHbM6pdHL9pYkxys0tx63QrTo6bNW3RdBPDG5HD8M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b=Fr/AW8Cz; arc=fail smtp.client-ip=40.107.21.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=siemens.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b="Fr/AW8Cz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LRAnQLXNwbe3yGE+ygmExYCoEjY0l5SkwSnrA5AcGd0vd629APHVOULgzkvr746GaKnQk6fhD+czuHA+ANIjvGvKSj1VEnrnS7Af+a+AJo9SdS3bKicYxv9oVQJuCzXKkkRfJXthZ5WmWXd8dMJhGsmGPipnRbF6pZRqshvpDRmVTVyzxKc3hoyQ9xHnfQMJAhc72EogZlRqzqVZuot0EftMpfZkA7/TlZl4hFcyCGuww/1Mfo7oiFixEDWZ9mJltIAI061r2yqDo/l5z0f4CD048UtAoZg0Oz1kLdZwfYL62UMsdavw3Zv8nFvP0cN6cYOza5RPHw44fep9yYJtRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xm5iMd2Thm1/dZMrxLP+onGaQM6WHYB/IeQWQCXa40c=;
 b=PWZjeHu2HuL7AGJDMCevLvvxXMsTxJ7E4LHW2w8K8PW6gJ15HSDT3HF2ZPaCwHjNH9ClGWK+9opx1bW1WZ/IKgFPYOeLB4SMxh/RkDoTk/FwNM6mONecns9xqOwuozupKxyNhSlAzccNsw+0/zBECzl5SJmY2hPyHc1QhMHDMSmiVz2txefQuVyypAuCiGsiM3NjVq6nrREJ+vtCM/t2Pt9TOaqtBS8th3ietlA4Q9yXIfo6HBS4yMUNuFR9QXoMQ0Pgv/y9qX8/oBRz27PoYIyiqiHHJqUcVhecHpOaja/l4XkAdg9kRNcClmOqGIm9X2Oi/iDkxsJqFfMOVLhh6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xm5iMd2Thm1/dZMrxLP+onGaQM6WHYB/IeQWQCXa40c=;
 b=Fr/AW8CzgidSkTsSAB26fpxxIC4XIurhJGl1qMQceGthPB9a43VVXGq1RIVzae4Oj4JH1HUbODrB4jQNEpawg5sZ3GLspDC4MhJ7WQg6SvHTfOsQ/YyQ06URP/FVrNFSAFIjhYLM3/aI4+oROAswHePTdVHMey5GNA/KUj25kg1WAAkWNN7L7EK5jvsnZ4zHPanvnNxbbc43OrjPewdJsD2R5K+UmCuZiHbjSzLRQo5e3JVBA0J9RHzFu1ApxsvJa0ySgNqzPQQ+kBB1dAuEe+4t9HlUv1RoN0Vimu3cgPtBheAkT9fg+6zWBfKcCVUJaDndfn74EQn0/BEdbbJAzQ==
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:47f::13)
 by PR3PR10MB3914.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:43::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.8; Thu, 17 Oct
 2024 08:57:08 +0000
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe]) by DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe%5]) with mapi id 15.20.8093.000; Thu, 17 Oct 2024
 08:57:08 +0000
From: "MOESSBAUER, Felix" <felix.moessbauer@siemens.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>, "axboe@kernel.dk"
	<axboe@kernel.dk>
Subject: Re: [PATCH 5.10 259/518] io_uring/sqpoll: do not allow pinning
 outside of cpuset
Thread-Topic: [PATCH 5.10 259/518] io_uring/sqpoll: do not allow pinning
 outside of cpuset
Thread-Index: AQHbHwNQCu/NIhc1hUivG6TF+06L9rKHzBiAgALYHwCAAALYgA==
Date: Thu, 17 Oct 2024 08:57:08 +0000
Message-ID: <3aae3d2b63e47a6b4b473e8dffcac749ed2f2806.camel@siemens.com>
References: <20241015123916.821186887@linuxfoundation.org>
	 <20241015123926.983629881@linuxfoundation.org>
	 <be695585c466c53cf4192858fcebcfe15d19ee93.camel@siemens.com>
	 <2024101728-overdrawn-librarian-fa70@gregkh>
In-Reply-To: <2024101728-overdrawn-librarian-fa70@gregkh>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.4-2+intune 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR10MB6828:EE_|PR3PR10MB3914:EE_
x-ms-office365-filtering-correlation-id: f86f5bf0-4e23-4d75-ab63-08dcee89ae66
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?K3lRSzVFZmlOMjVyUGRqUFFrb3F5RndERUtyYTR2K0xuSXU3RVNzU2c2cjFr?=
 =?utf-8?B?SHVsLzRPQjNDTHRNZUhmT1grNFJaMGpMYlBxeUQ3ODV6QnJqU1VxV3BLdWt1?=
 =?utf-8?B?bFBUOXZzNkRnNUdZbWNJejV3bGVnaWd6NHQxM0VCZVovbmZkYjFXMlk4dzBk?=
 =?utf-8?B?L1dCTGNVK3JtT3ZkS2xVK2FFMEJ2bWlmYytUeXlCbDRIMk5hekNkSVdsQ3NP?=
 =?utf-8?B?czBTMTF2Vnkyc2ozUUE4N3BiakVIaHA5YXNjSk1jdGV5RERhTnQwN0V0RlVL?=
 =?utf-8?B?cDFTVzRQSUtWUUVzVUpQVFZEUDZTemF3bTJRdkNaT29lUUJ2YWZTUHVyQ3kx?=
 =?utf-8?B?SnVRc2FURTA1Nk14WjMrS2E4VTJqSk9kaDhyVXdBZ3A0ckhoaTZhdjhFU1Rv?=
 =?utf-8?B?Mm16Ym9xTG9YNFFrT2pycmdOeklKUk5pSHdtdllNWGRqMWp6RTZOT2ZEbDN2?=
 =?utf-8?B?RG9HTk12YjhCZFNDalorR2dTMUpkb0VTb0VVZHVKdWgrdWNMbWV0dHpjUmNv?=
 =?utf-8?B?czljTVpGbndUcVpySUp5YVBSdks3NjZQekQ4UE9Ic2h6ZDVWT2YrdmZuem8x?=
 =?utf-8?B?d2x0bzJrY01oNW1TNGRoV2dQZ3FXaFVod0djMnpsRHNTckJvM3Iwd3E3RFpU?=
 =?utf-8?B?dnFORjQyenF6SUlhYktrdi9SU3ZUR2pUT1FUNUpyVkE5Y3lzam5tclY4d0c1?=
 =?utf-8?B?UERsbmZXbHNtallpNXJhZnFpaHpZYVFud2pFYmVEdk83SVViNVk2RDd0MkNl?=
 =?utf-8?B?TW01YjBVZXMzdGE0U1NSRGI5L1J6UmI5c0xLc3V6TTNRR0dmZEsvazlvTEJN?=
 =?utf-8?B?Zng0Vk9YZjZpTkllLzZaMzJjaytzVjRSWkRoYUordUl4YnlkbHJzSUExZkpY?=
 =?utf-8?B?NEpsTHJnTWZoQnZnTzU3ZVArMTU2R2FsVy9xUTlBNUNFb05xUVp0anVLbVlK?=
 =?utf-8?B?SVFCTnVmWExYS0RYa0F3K01XK050NGhFelB6REgzU0VLQ1BoZUZ2OGdHK2hq?=
 =?utf-8?B?UVRxVmJ1V1F1bmFBWWVtOHp6YUZkY1RIdTFxVEtqT2wvKzRZMGRUS3VkYVJs?=
 =?utf-8?B?ZmloeHFDMEJXcHpFTER2Sm1tTXEvenh0cVR3T1dFemJrc2U0bGNsRkR5Smdl?=
 =?utf-8?B?and5UTRrMjZ2QWk4R0cyQlZzOGZ4MHdXNE9rT2x4dzRIeWg3d0dNUjV0b1k5?=
 =?utf-8?B?SmEvU0RJeEtGOUlaeDN0Q0QzTmh5STRrdkV3d3dUeE5HTGpDY1ZHZ0JaVjhi?=
 =?utf-8?B?Qy8wd3NJRHRQZC8zSCtHeDhaeTB5UXpjcUZwTFE0dElyUGV0TVJQQURyUUtR?=
 =?utf-8?B?UWpFS2libkh5TFNCUktzZ3VrQ1kvUExwSHNFcGxZMGtFVklTbWF3cUh3NGxp?=
 =?utf-8?B?ZWx2MXU0bzFsdERSRlc4c0h3NXpzYXM0WWR5RCtXYlErRm1Yc01ybUhnKzk0?=
 =?utf-8?B?SGdsQ3R3aFUwc0ZidVN1aVVWdmNBdi8vWjU5VDdkYktEdXNlOTkxbno1aDBR?=
 =?utf-8?B?eXNJY1pzR1VENC9CMEpReUxUcDBWN3JLV1dqeHo5ZnVPWHQyV0FwWkFDcEg0?=
 =?utf-8?B?QjJzVjMyOUVRUWo1U0xFZlQzUVE1cFlUSk8zZlltOXFjbUc5N0N4UXRiaHJI?=
 =?utf-8?B?R1JQVkRxSnI3N1ZtUHpHZHFwQ3liS25GYmhzcUZmQTBkOXY3czgweEVVUTZz?=
 =?utf-8?B?TnIxbFFmYmhEMFpsUG16eTc3N0laNEVsdkpEWTNtUDZiZktyM3BYaXdVdmN6?=
 =?utf-8?B?dkJCVXcvdVlLM2pnM3U5eFBrTWxRalNraC9PK2JrODNNRFhXNnBkaG9aR0ll?=
 =?utf-8?Q?KI7aCMYRUPOGEqMwchzoBeEDu7DPSfXTWxg0Q=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MHIrZkh0M2JvUFNiRncvWGx1d3p2enF2cnRBVDBTc2tkcTlqNnNoRUQ1UXh5?=
 =?utf-8?B?NnRKWDNrNjBYenlUUVkrSGQ4TVlMT0s4Nlo0Wjc3WEs4ekMyR0dSRHJVNS9p?=
 =?utf-8?B?cDZ6SStjYW9QdHYrQlc2RStVdUo0MzVHR2U5V0RENG42OTN2OU5DUlFFUGt5?=
 =?utf-8?B?Y3ZhaEk0SHhXTUpzR25WR2lyelFCbUxESXdKQWljRHpaUWpUSnNEdmNsWTk5?=
 =?utf-8?B?aDQxSEJnVlMrSlpiRjViVGlLV0FodmZsT3lXRUl0bE1TeHVqYnF1ZmNndm4x?=
 =?utf-8?B?M0svY3VsQWpELzNNZ1dzTnR3Wk1yWTM2Ukt4SW1WckpxazQyNDlweUR2L3hI?=
 =?utf-8?B?bDNPUlYySlhadWNkZ2tZb1JEZDl2bjh3NjZBWlI3aEY3cVRmRW5DVVRiUUZ2?=
 =?utf-8?B?MmJIQnZsMWxURTQxQTZTYVdnUCtYRExBV0JBVTJQK1FkWUc5WHoxN29mSDRJ?=
 =?utf-8?B?S0I2Q0M4WW45czZhM0orME1aTFhVWEZrOW15a1JkQlBGUlIvRUFIWDBOM29N?=
 =?utf-8?B?SE10SFBaK2Jva2JGVHpYNDU2NnNFY1VpV0N1OE9YQ2dDckZnSEkxVFVqb25l?=
 =?utf-8?B?Z3VTbndldmtQcUFqY2k0aWRvSE9INnNBN2w2VWlqYlluTzhZamhWc0JvWHpZ?=
 =?utf-8?B?S2xtclJRWXVFaEhYMzNYVE4yZWJpS3hPRERNcVgyclpCUmo0bnJTVFhIczMy?=
 =?utf-8?B?NUFSdHNiOFNBRjdmbmNJeGo1SHNndk1YZWhwckRNbzJwYzZwZVVDelBUODZJ?=
 =?utf-8?B?SWZ0UnJxN3F1ZEJhTFhHeGRDOWc2QTIvdHYwc2J5ZGJzdVozRWQ2cmR4QVNS?=
 =?utf-8?B?MlpZWEMzejB6OS9LVDgvOEo4Mk5WdzBqZkRMSEI1VHAwTGpIVVRDRG1uRnpo?=
 =?utf-8?B?blBQdVlvbUFSL2NMNWtHL3Q2RzVPbkwwTVEzaytjV2llck1QMUFCVThPaSs3?=
 =?utf-8?B?UUptWUlqRDBvV0V3cTJDU296UUhaM081bU9VRG8yUUppdVZtWXJPWTdWSG13?=
 =?utf-8?B?dW5PeU1wVi9xSldWRFFDVTliYXpuTjRPd1JLNDBXOG1iN0hKWjVCbEpoVmU1?=
 =?utf-8?B?QzZTNHYzdzkyUGx5RnlyZ0NBMjA2b2Y2SFdVdDVHQk5YUzNjQ1hRWHpjNitn?=
 =?utf-8?B?M1ZwMEJ3dG53K3RWYS90MDNYWkhHeWZzSXpRL0JNZEYzL0F3RXlHcUlwV041?=
 =?utf-8?B?c3Jmb0gxZEF3czBVV1VpOHFuNDQ5aTBuY3FtQ2dLbVF6SUFYd2ZGY1N6cVZw?=
 =?utf-8?B?RUlPVkNESWRoc3lGMnQvdnlERlI5RXVHYUxWNEhpeTJxRnhmV2k4dW1tcVpo?=
 =?utf-8?B?M1k5VXZZVFF1ZFdpbEE5VGVzMmVDOWZtaU5Fd1l0RmZETGZlOC9FcjNmWTBn?=
 =?utf-8?B?bHhvd1dXMkpFZDdmZUExeG00Y3c1OC9acXEwSnRqdkk5RXU2dGwrQlAwUGRl?=
 =?utf-8?B?b28zSWgrTVN3Z2hPYU1tSGVuNW9XZDk3QkdBM2kwT2pRbW1ZYTNHM0VPUmY5?=
 =?utf-8?B?NnZwQ0hQZXNUMXJHclRpSGM3MjJWZGZwU3hnUXdvQ0lKV2RXMm5PbmVkOHZY?=
 =?utf-8?B?UzY2NW5KSlQrRXZaVTJoWS9CaUJ2aUlEc05ESGNIRStUMHlxcTRqKytMVHVT?=
 =?utf-8?B?Wk43TElsMUNHSEVoWlpNb1ZybURSK3NGZDY5angvdDRwS09jd1FqbkRnZWdN?=
 =?utf-8?B?Q2lZaVZYWmFOSGNqWHNNWk1MOWxkaVZXcnhQQ0F0YXp4SVh0a0p6WlhzcFU3?=
 =?utf-8?B?ZUpjN04rWVRBd0JQdndCNndGekwxQWpKck50YjJSRlIxNmFMdVlaNUZyZzBr?=
 =?utf-8?B?R1o5TVRXUDFXVTZaL3UwelVEOUtGMkd1QzB5RUFZT0JpZmhydmErb2JMU3BT?=
 =?utf-8?B?cG5KNVZUdzQ2RXBxN2J2WDBtcWtHaEV6OW5BMFg4U0o0eTA4cTNhczIxeGor?=
 =?utf-8?B?dFdLeGwwZ0pMaENhL3phTlQ4RmhwNWdRa1VvRUR5ZzVTU2kwQmxKZ1FZYlg0?=
 =?utf-8?B?ejdseDRla2djVVNuWllRM2NvUmtYV1lyUTFsaDdqYmxjOXFhZzExRE1uZCtB?=
 =?utf-8?B?NnhVbXJoSzEzOEU0TXpXRzExQUNZRUxTWFVZWVBGb1lvWjB0V3Z0WTgxUW1J?=
 =?utf-8?B?eDdEbUxsWFBjR084VVc3V3JFSFMxN2FmbnpFV3grb3FkNjlaUWswT0svNW1p?=
 =?utf-8?B?U0NaSmRiM2toSWNza2Z2RnlaS0RQbVJwQ3NZTE41bktKSU80R2tyajNLbExi?=
 =?utf-8?B?WWJFckxxTHFhRnU0blBjT1NYUlZnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DE4926CE1CDD644396E9EE9BA49DB8C1@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: f86f5bf0-4e23-4d75-ab63-08dcee89ae66
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2024 08:57:08.3357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tILXpymDyWdvzBMUs58nMThyANUqL2rQAoBgOwl2s9OWGBhUFgUiCacgKp61SzOMyih6nj0X9xP/QyK9EAz4oH2lSCl1qAiszuy+Z4ZUE5U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR10MB3914

T24gVGh1LCAyMDI0LTEwLTE3IGF0IDEwOjQ2ICswMjAwLCBncmVna2hAbGludXhmb3VuZGF0aW9u
Lm9yZyB3cm90ZToNCj4gT24gVHVlLCBPY3QgMTUsIDIwMjQgYXQgMDE6MjA6NTNQTSArMDAwMCwg
TU9FU1NCQVVFUiwgRmVsaXggd3JvdGU6DQo+ID4gT24gVHVlLCAyMDI0LTEwLTE1IGF0IDE0OjQy
ICswMjAwLCBHcmVnIEtyb2FoLUhhcnRtYW4gd3JvdGU6DQo+ID4gPiA1LjEwLXN0YWJsZSByZXZp
ZXcgcGF0Y2guwqAgSWYgYW55b25lIGhhcyBhbnkgb2JqZWN0aW9ucywgcGxlYXNlDQo+ID4gPiBs
ZXQNCj4gPiA+IG1lIGtub3cuDQo+ID4gDQo+ID4gVGhpcyBwYXRjaCBpcyBidWdneSBhbmQgbXVz
dCBub3QgYmUgY2hlcnJ5LXBpY2tlZCB3aXRob3V0IGFsc28NCj4gPiBoYXZpbmc6DQo+ID4gDQo+
ID4gYTA5YzE3MjQwYmQgKCJpb191cmluZy9zcXBvbGw6IHJldGFpbiB0ZXN0IGZvciB3aGV0aGVy
IHRoZSBDUFUgaXMNCj4gPiB2YWxpZCIpDQo+ID4gN2Y0NGJlYWRjYzEgKCJpb191cmluZy9zcXBv
bGw6IGRvIG5vdCBwdXQgY3B1bWFzayBvbiBzdGFjayIpDQo+IA0KPiBPaywgSSdsbCBkcm9wIHRo
aXMgZnJvbSA1LjE1IGFuZCA1LjEwIHF1ZXVlcywgY2FuIHNvbWVvbmUgcGxlYXNlIHNlbmQNCj4g
bWUNCj4gYSBzZXJpZXMgb2YgcGF0Y2hlcyBmb3IgYm90aCBvZiB0aG9zZSBrZXJuZWxzIHdpdGgg
YWxsIG9mIHRoZSBuZWVkZWQNCj4gaW9fdXJpbmcgcGF0Y2hlcyBpbiBpdD8NCg0KSSdsbCBzZW5k
IGl0IGJ5IGVuZCBvZiB0b2RheS4NCg0KRmVsaXgNCg0KPiANCj4gdGhhbmtzLA0KPiANCj4gZ3Jl
ZyBrLWgNCg0KLS0gDQpTaWVtZW5zIEFHLCBUZWNobm9sb2d5DQpMaW51eCBFeHBlcnQgQ2VudGVy
DQoNCg0K
