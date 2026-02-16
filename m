Received: from OS0P286CU010.outbound.protection.outlook.com (mail-japanwestazon11021077.outbound.protection.outlook.com [40.107.74.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8D7212566
	for <patches@lists.linux.dev>; Mon, 16 Feb 2026 01:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.74.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771204559; cv=fail; b=TfSW+bOQIoD6u2cuSU9SzQ+3pXiTMwsLTeCldaFPkXJ4/O7k0q0Pj22Xe5PDF+P/BdD0p+AziDQk2yBWDHnPKx54pcBFmgsNdOm/1lWNUKrx5QEurpIDMIQfkRDWF0i6z+pTyctGrNDzJ0Tf675UsBTGkpKDpI9oGyR/cO7ThEA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771204559; c=relaxed/simple;
	bh=mzZE+sEW9kuQjrlFoGTYPxUnHPKT1DvgFRPYh1ZwqWE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TRoz2NjrRdnklvC6hpCsS3sd+RQBs+UdCIcrlKutPTWTP9DfNyxrjfNgj6k48X40bzvzF71ydfHIf3vlb6uuTXDVWRaGOF1EfQexgJ6kYMEmiQESmBXee9KkAtbM81aq+TBMjRBOZ+ujTgsfX+bNJjZEFNrv0GuuXKXhf3QV7r0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=valinux.co.jp; spf=pass smtp.mailfrom=valinux.co.jp; dkim=pass (1024-bit key) header.d=valinux.co.jp header.i=@valinux.co.jp header.b=c7biDVNS; arc=fail smtp.client-ip=40.107.74.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=valinux.co.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=valinux.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=valinux.co.jp header.i=@valinux.co.jp header.b="c7biDVNS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SSp+3eKaXatCIWE0PmkNwoJ/Mj+l2wMoHVoYvnn5Ch7IALfrvh840FQuQ4B18s1ym/QCcj/iX+tqVd7G5R52nUQrF4Oh0AgIwy2uuJwqqqY4hCf63djJ8YYyexauHpCXXyCPkraZkux3yYAI7B6T11AnvKSUv9rINNXpYJ/wsfzEd4HP81F1NgNofudAtZRTslrAbv8utQ5XqVQ/xwBbqw9Fsx/B32yM1EiMal8Pbd4223QZyOonWB1sJ4FecOQBpTAWS0TOBdObaX4zYeXAa/Z3z1kbjXPVucsY8NpxVQkhY3H8WI5aJ1e6qSGySqoTmZj6R+1LPGFMLVerxCx71A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VuQdlJP7iE/4gjxLUvqkyOCdebFpnRR/7SjK4z0/TEo=;
 b=sSvOxu+KeejhtG4ILTlcNouF8+K1Wxcc3tEy4hJIjEY1qoaq46ALfGZCgjG/OSx8g6wps/Mup3msYBQRL9ptkVmyqB38WZn4dyYKszFJ5Y2DNHzT+1EdryHnHgH7XFDCwv0rBG3ZprA+UEyWWE9KTC18EDwd/A6WVDl8mVeogjxXAOUvaJT538SHbYz+YlWJ5/Y9rxbUN2l2qMdGzUodE9++IC8SX34bZNCs81HiJs2zZax99LjNi6+wxQ7JCVK1x89jlXPP+pSuuoVTB0Gx9FwGU/EPHDWMNi5A0mcot9vY7D7/sg9obONmyppppTOvMze4fHzWZntYL14ED0gsOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=valinux.co.jp; dmarc=pass action=none
 header.from=valinux.co.jp; dkim=pass header.d=valinux.co.jp; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=valinux.co.jp;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VuQdlJP7iE/4gjxLUvqkyOCdebFpnRR/7SjK4z0/TEo=;
 b=c7biDVNSVINa/UcEWLN41jHISJxVB4L0ZQg5HFN0AGHqmr7PYPNzoUXfLodAM6yLW/LM18HfXO3JeMlHfB293XqVho6eOtxN6WILICQJ9vayXds6vVkD4ecOYHJ+ju0jdint4x3KOX/gV4DWmk6ydAX/glGXPFtl5wN2HYc2x2A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=valinux.co.jp;
Received: from TY7P286MB7722.JPNP286.PROD.OUTLOOK.COM (2603:1096:405:38f::10)
 by OS9P286MB4566.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:2fb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Mon, 16 Feb
 2026 01:15:54 +0000
Received: from TY7P286MB7722.JPNP286.PROD.OUTLOOK.COM
 ([fe80::2305:327c:28ec:9b32]) by TY7P286MB7722.JPNP286.PROD.OUTLOOK.COM
 ([fe80::2305:327c:28ec:9b32%5]) with mapi id 15.20.9611.013; Mon, 16 Feb 2026
 01:15:54 +0000
Date: Mon, 16 Feb 2026 10:15:52 +0900
From: Koichiro Den <den@valinux.co.jp>
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org, 
	Niklas Cassel <cassel@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, jingoohan1@gmail.com, 
	linux-pci@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.19-6.18] PCI: dwc: ep: Cache MSI outbound iATU
 mapping
Message-ID: <oxgnleyoexgrpii4qz3ikcyktmjojckn2ln7zlpkxfyqojnk4u@pgkrkefmudkv>
References: <20260214212452.782265-1-sashal@kernel.org>
 <20260214212452.782265-50-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260214212452.782265-50-sashal@kernel.org>
X-ClientProxiedBy: TYWPR01CA0006.jpnprd01.prod.outlook.com
 (2603:1096:400:a9::11) To TY7P286MB7722.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:405:38f::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TY7P286MB7722:EE_|OS9P286MB4566:EE_
X-MS-Office365-Filtering-Correlation-Id: aac557b5-2b3f-4203-0a11-08de6cf8ee61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|376014|366016|27256017;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VUdKU1VxZ2lseGpHMDZ5N2NUSjVGdnlzV0ExakJhM2p5MEZLdC9EVU1kMWg1?=
 =?utf-8?B?QjhaZ0pnbGZ3S29veVpBZ3FWclBISTRibmtYL0dIcDB1b2UvS1ZWUmNhaERG?=
 =?utf-8?B?TER3d25YcnhSeENkaHEvMC9QRG5PcFpYZytyVlR5SkdVTmdIT3FGUDVHaEZD?=
 =?utf-8?B?SkRhd3QwVlpQSDZvbXhaZ3RKcHNLeGx1Um05Yk9Udi9wNktRWCtObldYUGhX?=
 =?utf-8?B?Q05RL2l1aFZkY0xmTzdQakczVm94b0hudlhsMEdGbEwyczVyMUhaZzBnZ1hs?=
 =?utf-8?B?MUgxWkNBWmFFTmsvdGE3SC9VRG9wOTRZR0hIWmNrTmhpNmE5RllJSStsaGZK?=
 =?utf-8?B?Sm1rQ09RVFBXdFd1YVJGVFpraWM2NUkzeWRsV3ZGcDRCSEJtUXhlcUtzUWgv?=
 =?utf-8?B?UnNBeWtqK1BJS0xzcjVLMFVORFQwZTZ4U21YdlEwYTVPNDd5TlZvR0d6clFs?=
 =?utf-8?B?b3U1NUVJVnZDd01NdXpkdStLZnJXYXJXeUdCWkF6eUVRZnJ3NjlxVDYyMVVx?=
 =?utf-8?B?SS9Vd1lOaC8wOVBKNEJUT1JDclUzS3NyTlVmTzRVeVhiK1lvUE1xeUROSTg5?=
 =?utf-8?B?anRCakNwNVpsSlh2OFZyOEd5a002enljWlBrOFF4RUVla2xZY0NJYnpQQm5w?=
 =?utf-8?B?Ui9xeEdUU0FqcytvU1p1K1JDSzhaVUJNU05FejdhWXFQdlB5ZGhMTjhEQllH?=
 =?utf-8?B?aG9RNkoxY3NXVEowcVVIOTlzWjBmRXZmbGJpcVQ0dDI3TExTZGdxV1h0eVZj?=
 =?utf-8?B?TWlQQXo0Q2NSVDF0NW1JK08rMytWNjJMMjRIYlgwL1pacGVSTWgwQlNpOVpz?=
 =?utf-8?B?N20xM3dTVTdmb1FhVWNuTEZXbVByYmlVMytaWHZnaGJEbis0blZtRW0rcDV6?=
 =?utf-8?B?QWxwY0FENjlSamFVaDcwa2EzZi9mNEZ3a3hSd003cDRBRklIYUFUMm91bUls?=
 =?utf-8?B?MG5URUtJNFBJM3RkTmFQK1VOYm5aMFh3ZjBoZDF2S2o0QXowYzFnR3ZTd1pV?=
 =?utf-8?B?NlY5OHgwSjNtOGRzeThNKy96cTRoNnpHeUhWVGticE8xQldXdThJa1d6eGd1?=
 =?utf-8?B?UldXelhkRWpLM2c3NXk1M0xOTmVaNmtocUs4MVFHbmZEaC9OMDRHakZhK3M4?=
 =?utf-8?B?TkdoWHRtVW9RdGNjbHppbGgxTVRTeklleEZ4OGo2SklyZDV2LzRzTTF2N1Nx?=
 =?utf-8?B?ODJXUDdHYkdobGNrM3VRN1hkYkFjNW4wMXpVSUJzSFlsTG8zN1QwNFd4bm1a?=
 =?utf-8?B?UW0xaSt0YXJIY2htZWdwMlFjTy81cytSSVlkNC8vdGFoOHZ0NTd5Q3QzRDY0?=
 =?utf-8?B?Vll6MDRQTXU1RFVPRUJVNGZ3UG1lck42dmR6TEI2MEFaUzdYZGRSZE00a2dm?=
 =?utf-8?B?d0dTV0hkVHZKWExZODZxSSs4VmFVb0xHRkNEamNhZmRiMFo5RkpVZE1YaG81?=
 =?utf-8?B?UHo1SFZiTi9URktRajZxcDhMa2lEUDlKTEcrbnNOeFJkSGxvSWh2Z2JVSmdo?=
 =?utf-8?B?NWlDM1JyanBzbVp5aXh1QnBHTElpWmNBT05SOS9DWGFidnR4WWFKemFGMTVo?=
 =?utf-8?B?Z0Z6TkM0VjliVXB5SUFpM2NodFkrQkdXejE5dU5XR05TVjBSMmY3WWduQk5L?=
 =?utf-8?B?MkJHbHJteWtvb1dCLzU2TFJIWnBZVitFK0Z6WDM3Mld5U3lqU3FITkQwd1Fm?=
 =?utf-8?B?eWxMNzUySm5OOURHakdLYWN6SDJuSHZUc3RkcWF5NEFRSWROV01VSXV5K0dW?=
 =?utf-8?B?anF0R0Y5NEJ4dFIvKzZVVFFBZVEvVEU2Q1pQamhuMXd6LzdRVTdwK0hZZ0RT?=
 =?utf-8?B?WGQ4UlJ0Y21DdThEMjZmVFBTd1RIU0orUDc5QmdPUWpJVXl6ZWxYNGhFTnpF?=
 =?utf-8?B?RlRhdGxyK3Uwc21hbXhuVVNhYjJLOXpRZ0htLzk2cHVzUFdBWTRRNnExSSts?=
 =?utf-8?B?b0pkcVUvSmZRemdXSTNxYUFMQ1NyYzZwdjlSZ3E4c1FDdVBadERVR2VjVk5u?=
 =?utf-8?B?eko3Y2VsbTlzNU9VZW5meElid3R0dTc0dWdIUkhOVWNyT08xTGp0WGlXVldm?=
 =?utf-8?B?RGZhN1FvUU15YjdObmF4bkZ2aEtrRGhsM05LcU5FZEtlQmpDSDdoV3pNQTlv?=
 =?utf-8?Q?HQR0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY7P286MB7722.JPNP286.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016)(27256017);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bGRZQzBBSUYxNHRsT1JJWTlLanNpUXVtZ1lwSGF6c0ZVY0lLZ0ltV3RtOGVz?=
 =?utf-8?B?Y1VNdE9UUE5scXF5Z2o1RHhidTlSdG04S1VYZTdEQzRmQ3FCYWpnblhJSDdJ?=
 =?utf-8?B?MjhqMjlXNCthMnBzRnhPU3I3akhtS1FnSFFBUkpjS3FBY09SQm9CMVgrcVVN?=
 =?utf-8?B?OE5PSmNNalhZYkJJY0ZVN2ZXWDFUYlhCSllzTUU4YjBVZXRJL3lFVzRBNkJQ?=
 =?utf-8?B?WndESXZEeVJFWWhheE5IQlhtbC9PTFRpaDV4TWJPekF6U2lKVTRySmFNMUNW?=
 =?utf-8?B?VXdPN1VMVW5uQkp1N0tZU3N6azNEMGk0MzZaT0tPZkFrQWZSdDMyTVpsY0hZ?=
 =?utf-8?B?ZXVnbENCSHBVTklrK1pRalBDc3ZkQnB4NEw1Zm9NNnZnUk1yY2xlaEtDZmlZ?=
 =?utf-8?B?N0JxbjFpZXUxSnRPendXTnYzaCtPZHdFQzQrcnBpWFdpdjA5TFMwN1k3eHU1?=
 =?utf-8?B?Yk9QblpQVi8rR1VOak8vNHl2M0t3ZEtnWnhWcnZ6YUJHN01zdTl3dzNUT0N6?=
 =?utf-8?B?Z1NpU1Q1Z240YXNmNGNwYWt4YktseTNJRm0xcGhVbWtrem1GQTFjYWNzY2tz?=
 =?utf-8?B?Z0pISE5tTDZjOStaaSt5RjRrUXlvcVJRbTJvOFJwZXNCYW5sQkpBMzlLcGtv?=
 =?utf-8?B?MHAxQlhuT0tCUWRhSHo4SmZnU2hEL0JKdlp3UFJXUVlQc2J5YTdiSWZBc204?=
 =?utf-8?B?eUsvVHNrNEZTOFI4UzZBZGlGR2h1ZHQ3WHNxRitpVERiWC9Lblk2MXFjNG5v?=
 =?utf-8?B?dTVQYU5rSEdBV1pEM0NSdGh4YTZsY3JZbjk2TXNNOHg2WVFRL25SU09idFFh?=
 =?utf-8?B?VVMwNEZCcmZIWlZISFhKbEZyT0k3cThIZmF5eXVCRXNrTW1sWW9hTEJVai9v?=
 =?utf-8?B?bkxtTjJVdmhHeTVPc1kyOXZIUGxDUzBWNEJVT0dBMlF2ajBKZnZCaWc2dk4z?=
 =?utf-8?B?STZkVm0zeXZHUXJuTHdhajJZeElmTE1SOHV3SlZVQWxkV25jZVdCUUw3bGdl?=
 =?utf-8?B?WHRvSjBVS3hiNzllT0pYcGEvMHZ4c2F3UnFRRkVsL3c0UEU1VGw5elp6cUhR?=
 =?utf-8?B?amR3OVdKSzVqVHBobURYdHhjMHpMMk9DZDhZVXZGL1VVMCtDUVZhSTBOVnNL?=
 =?utf-8?B?OU5kM1JPb2N5WVR2WS84Y1hUMjM0NVBlNy8rbTNLMVFCSGU4MEdZQlZMQWJW?=
 =?utf-8?B?bnIyazYybmdDVXZ4ZUk2TXVwODQ2MUIrQzV5SzJSaVRhQUtmQWZNYUxiR0J3?=
 =?utf-8?B?Y0J0Z3kydFVCVXIxeUJjQ0xWNjVCbzVZUUNDeHAwVXA4QWxySDlKSHFOcFA3?=
 =?utf-8?B?TXNjWTRiR1NwMkxDbEh2UHNjVG9TeUVlS29Tb0lraDd2a25GdTM4dUlOa1ZJ?=
 =?utf-8?B?bW83K3JBcFFrcEtjYkxEbkl6bmxSTDdqa0xveUhMQ1JMVEl3Rk5mZitidC8x?=
 =?utf-8?B?YzFGckNhSDB1MHFacHU5ajFBRmtCUVJTdFpCcFBlTURSYVdPeUd2aVJ3NnIz?=
 =?utf-8?B?Vi9qNk5oaTFiTXJ5YmJJa3ZNUzJtTVFBREhUc2I2dTlVSmtsdWZkdHEvcTQv?=
 =?utf-8?B?SVVKak8zK09sMnhYblQ4TDJrYlNWK3lxTW55OUhUa0plL01uNVd6cWdLT084?=
 =?utf-8?B?MVBWN0JVcTdZNW1TWnN1emtQZjIvTGRwdU9uMCtwa1FRVGVsdmhKWW9XbE9r?=
 =?utf-8?B?c0RyOVFWZUlISkRhREFCSWRHNENSMFROTXFtRndCMU9CUjd3NVVxa2oxU29M?=
 =?utf-8?B?WitzREQ2WnUrYmg2SU9Qcm9UU1kvY3hWUnlsT1dialVpUW9jOHdFa0JqVURU?=
 =?utf-8?B?TXZyWllkVi9lZzdBY3pXVmE4NlNWMlNSYUt1dERVc1NsaERZdEVJckhKdFFE?=
 =?utf-8?B?VTlPWmlGdUpuZ09NY2pRZjMwZVp3TUdpSlUwcFFTaXRPWkJUR0Nzc0FtQWF6?=
 =?utf-8?B?L2VaaHBBRmJidUNtU1R4dG1NY3dIdGduZ0pzdXVWZVE5MzZwcnNObFZzYXly?=
 =?utf-8?B?SlU5SWdmRnhRUHU3Sm41QUdZWWYrTXlYZ1NJdU44Ym5vOTduenhHODNtd3RN?=
 =?utf-8?B?U1V4RjRLczUxcFRDdGZYTWtRYmlFakpTWEZObXZPMEw2UE04RjNacXNmdXIy?=
 =?utf-8?B?VUpvc2FXRFpjZU5TaTJGdlFwUEZ5alRtdmxYV3QvN1RLRW1XNHFWUEcwVUxr?=
 =?utf-8?B?VjhrcHpEalhMQ3YrMU9XWVlKNjRNK0NzUTN2NnU0NmM0VnFoL1ZXNGFOWTJM?=
 =?utf-8?B?dTdEbFJYSWltZUd6NnYyRDFKVGRJQURkQ2RhaGlyRUVFQkxMNlgzRWliTG10?=
 =?utf-8?B?Yko5NzJhNGVETXovY1RoOHpuN0RnTkNBaG8xenV5MjZJK3Y3SUVXdzZ5VTNa?=
 =?utf-8?Q?hLhCsrFBIVCrRyaOZSkZUremtrGcXqOBxZnpT?=
X-OriginatorOrg: valinux.co.jp
X-MS-Exchange-CrossTenant-Network-Message-Id: aac557b5-2b3f-4203-0a11-08de6cf8ee61
X-MS-Exchange-CrossTenant-AuthSource: TY7P286MB7722.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2026 01:15:54.0839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 7a57bee8-f73d-4c5f-a4f7-d72c91c8c111
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: agyJRj1yNAiEoGwVJOsHbHw9BSVgOx9IVeDaJO07VswrWcYwQ3ecSv2IdVi5Z59EatLFI4Xr7nOpYgQgKL5CVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS9P286MB4566

On Sat, Feb 14, 2026 at 04:23:15PM -0500, Sasha Levin wrote:
> From: Koichiro Den <den@valinux.co.jp>
> 
> [ Upstream commit 8719c64e76bf258cc8f44109740c854f2e2ead2e ]
> 
> dw_pcie_ep_raise_msi_irq() currently programs an outbound iATU window
> for the MSI target address on every interrupt and tears it down again
> via dw_pcie_ep_unmap_addr().
> 
> On systems that heavily use the AXI bridge interface (for example when
> the integrated eDMA engine is active), this means the outbound iATU
> registers are updated while traffic is in flight. The DesignWare
> endpoint databook 5.40a - "3.10.6.1 iATU Outbound Programming Overview"
> warns that updating iATU registers in this situation is not supported,
> and the behavior is undefined.
> 
> Under high MSI and eDMA load this pattern results in occasional bogus
> outbound transactions and IOMMU faults, on the RC side, such as:
> 
>   ipmmu-vmsa eed40000.iommu: Unhandled fault: status 0x00001502 iova 0xfe000000
> 
> followed by the system becoming unresponsive. This is the actual output
> observed on Renesas R-Car S4, with its ipmmu_hc used with PCIe ch0.
> 
> There is no need to reprogram the iATU region used for MSI on every
> interrupt. The host-provided MSI address is stable while MSI is enabled,
> and the endpoint driver already dedicates a scratch buffer for MSI
> generation.
> 
> Cache the aligned MSI address and map size, program the outbound iATU
> once, and keep the window enabled. Subsequent interrupts only perform a
> write to the MSI scratch buffer, avoiding dynamic iATU reprogramming in
> the hot path and fixing the lockups seen under load.
> 
> dw_pcie_ep_raise_msix_irq() is not modified, as each vector can have a
> different msg_addr, and because the msg_addr is allowed to be changed
> while the vector is masked. Neither problem is easy to solve with the
> current design. Instead, the plan is for the DWC vendor drivers to
> transition to dw_pcie_ep_raise_msix_irq_doorbell(), which does not rely
> on the iATU.
> 
> Signed-off-by: Koichiro Den <den@valinux.co.jp>
> [cassel: improve commit message]
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
> Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
> Link: https://patch.msgid.link/20251222110144.3299523-2-cassel@kernel.org
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

Hi Sasha,

Could you please hold off on backporting this patch until the follow-up
regression fix:

  [PATCH] PCI: dwc: ep: Fix regression in dw_pcie_ep_raise_msi_irq()
  https://lore.kernel.org/all/20260210181225.3926165-2-cassel@kernel.org/

lands upstream, so the both commits can be taken together?

The original fix ("PCI: dwc: ep: Cache MSI outbound iATU mapping") addresses an
issue that is only observable under high load, and had existed for a long time
without being reported until I posted the original fix. However, it later turned
out to introduce a regression that can lead to a system hang on some platform.

Backporting the initial commit without the follow-up fix would therefore risk
introducing a more severe problem into stable trees, at least temporarily. I
think it would be more preferable to take both commits together.

Niklas, please let me know if you would like to add anything.

Thanks,
Koichiro

> 
> LLM Generated explanations, may be completely bogus:
> 
> This confirms the **current state of the code** (before the patch is
> applied) still has the map/unmap on every call pattern at lines 705-712.
> The patch hasn't been applied yet to this tree — this is the candidate
> being evaluated.
> 
> ### 8. STANDALONE ASSESSMENT
> 
> Looking at the dependency analysis more carefully: the agent found that
> in some stable tree, this commit was brought in as part of a 10-commit
> dependency chain for a different fix. However, **that doesn't change the
> standalone value of this commit**. The commit itself:
> 
> 1. **Is a standalone bug fix** — it fixes iATU reprogramming under load
>    causing IOMMU faults and system lockups on real hardware
> 2. **Has no prerequisite patches** — `dw_pcie_ep_align_addr`,
>    `dw_pcie_ep_map_addr`, and `dw_pcie_ep_unmap_addr` all exist in the
>    current tree
> 3. **Only adds internal fields to a struct** — no API changes needed
>    from other patches
> 4. **Applies cleanly** to the current code (the pre-patch code matches
>    lines 704-712)
> 
> ### RISK vs BENEFIT
> 
> **Benefit**: HIGH
> - Fixes real system lockups under load on DWC PCIe endpoint platforms
> - The bug is documented by the hardware vendor's databook as "undefined
>   behavior"
> - Concrete symptoms reported on Renesas R-Car S4
> - System becomes unresponsive — this is a critical stability issue
> 
> **Risk**: LOW-MEDIUM
> - The change is well-contained within 2 files, single subsystem
> - The caching logic is straightforward and defensive (WARN_ON_ONCE on
>   unexpected address change)
> - Proper cleanup on endpoint stop prevents resource leaks
> - Only affects DWC PCIe endpoint users
> 
> ### CONCERNS
> 
> 1. The change modifies `struct dw_pcie_ep` by adding 3 fields — this is
>    safe as long as no out-of-tree modules depend on this struct layout
>    (unlikely given it's a controller-specific struct).
> 2. The WARN_ON_ONCE path returns -EINVAL if MSI address changes — this
>    is a safe fallback since the databook says reprogramming under load
>    is undefined anyway.
> 3. The commit applies cleanly to the current tree based on code
>    inspection.
> 
> ### CONCLUSION
> 
> This commit fixes a **real, documented hardware bug** that causes
> **system lockups** on DesignWare PCIe endpoint platforms under load. The
> fix is:
> - **Obviously correct**: Caching an iATU mapping that the hardware
>   vendor's databook says should not be reprogrammed while traffic is in
>   flight
> - **Well-tested**: Verified on Renesas R-Car S4
> - **Contained**: 2 files, single subsystem, no API changes
> - **Defensive**: WARN_ON_ONCE + -EINVAL on unexpected conditions, proper
>   cleanup on stop
> 
> This clearly meets all stable kernel criteria for a backport.
> 
> **YES**
> 
>  .../pci/controller/dwc/pcie-designware-ep.c   | 48 ++++++++++++++++---
>  drivers/pci/controller/dwc/pcie-designware.h  |  5 ++
>  2 files changed, 47 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
> index 19571ac2b9617..18b20cc877d9e 100644
> --- a/drivers/pci/controller/dwc/pcie-designware-ep.c
> +++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
> @@ -601,6 +601,16 @@ static void dw_pcie_ep_stop(struct pci_epc *epc)
>  	struct dw_pcie_ep *ep = epc_get_drvdata(epc);
>  	struct dw_pcie *pci = to_dw_pcie_from_ep(ep);
>  
> +	/*
> +	 * Tear down the dedicated outbound window used for MSI
> +	 * generation. This avoids leaking an iATU window across
> +	 * endpoint stop/start cycles.
> +	 */
> +	if (ep->msi_iatu_mapped) {
> +		dw_pcie_ep_unmap_addr(epc, 0, 0, ep->msi_mem_phys);
> +		ep->msi_iatu_mapped = false;
> +	}
> +
>  	dw_pcie_stop_link(pci);
>  }
>  
> @@ -702,14 +712,37 @@ int dw_pcie_ep_raise_msi_irq(struct dw_pcie_ep *ep, u8 func_no,
>  	msg_addr = ((u64)msg_addr_upper) << 32 | msg_addr_lower;
>  
>  	msg_addr = dw_pcie_ep_align_addr(epc, msg_addr, &map_size, &offset);
> -	ret = dw_pcie_ep_map_addr(epc, func_no, 0, ep->msi_mem_phys, msg_addr,
> -				  map_size);
> -	if (ret)
> -		return ret;
>  
> -	writel(msg_data | (interrupt_num - 1), ep->msi_mem + offset);
> +	/*
> +	 * Program the outbound iATU once and keep it enabled.
> +	 *
> +	 * The spec warns that updating iATU registers while there are
> +	 * operations in flight on the AXI bridge interface is not
> +	 * supported, so we avoid reprogramming the region on every MSI,
> +	 * specifically unmapping immediately after writel().
> +	 */
> +	if (!ep->msi_iatu_mapped) {
> +		ret = dw_pcie_ep_map_addr(epc, func_no, 0,
> +					  ep->msi_mem_phys, msg_addr,
> +					  map_size);
> +		if (ret)
> +			return ret;
> +
> +		ep->msi_iatu_mapped = true;
> +		ep->msi_msg_addr = msg_addr;
> +		ep->msi_map_size = map_size;
> +	} else if (WARN_ON_ONCE(ep->msi_msg_addr != msg_addr ||
> +				ep->msi_map_size != map_size)) {
> +		/*
> +		 * The host changed the MSI target address or the required
> +		 * mapping size changed. Reprogramming the iATU at runtime is
> +		 * unsafe on this controller, so bail out instead of trying to
> +		 * update the existing region.
> +		 */
> +		return -EINVAL;
> +	}
>  
> -	dw_pcie_ep_unmap_addr(epc, func_no, 0, ep->msi_mem_phys);
> +	writel(msg_data | (interrupt_num - 1), ep->msi_mem + offset);
>  
>  	return 0;
>  }
> @@ -1087,6 +1120,9 @@ int dw_pcie_ep_init(struct dw_pcie_ep *ep)
>  	struct device *dev = pci->dev;
>  
>  	INIT_LIST_HEAD(&ep->func_list);
> +	ep->msi_iatu_mapped = false;
> +	ep->msi_msg_addr = 0;
> +	ep->msi_map_size = 0;
>  
>  	epc = devm_pci_epc_create(dev, &epc_ops);
>  	if (IS_ERR(epc)) {
> diff --git a/drivers/pci/controller/dwc/pcie-designware.h b/drivers/pci/controller/dwc/pcie-designware.h
> index 31685951a0804..f555926a526ea 100644
> --- a/drivers/pci/controller/dwc/pcie-designware.h
> +++ b/drivers/pci/controller/dwc/pcie-designware.h
> @@ -479,6 +479,11 @@ struct dw_pcie_ep {
>  	void __iomem		*msi_mem;
>  	phys_addr_t		msi_mem_phys;
>  	struct pci_epf_bar	*epf_bar[PCI_STD_NUM_BARS];
> +
> +	/* MSI outbound iATU state */
> +	bool			msi_iatu_mapped;
> +	u64			msi_msg_addr;
> +	size_t			msi_map_size;
>  };
>  
>  struct dw_pcie_ops {
> -- 
> 2.51.0
> 
