Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B440EAF9
	for <patches@lists.linux.dev>; Fri,  8 Aug 2025 13:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754660809; cv=fail; b=dGkm9hTVTvXHlEGQHd1/wEmfnZFjWWFwmPO3esrf1FLCfJrCKhLk4KDv+7hnB2cOkak/CyEbuFIOO50xkZBJ6X1eIBKv2wP5i6CtssrFiodpmbmrRXfV26DW+WHzDPqxdOgV1dNlZnlewkMoZc5l7+iuF2IjLnzju/AvgXEfMzY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754660809; c=relaxed/simple;
	bh=4yygywmQAzbj1jvX9qDl6sJwk2vytGaVq5ZRQ4LVN7k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:Content-Type:
	 MIME-Version; b=hNHuDrXEkdYutEP6GjOoY6pheevPz7Te3aJCglQV8ILFCZl3EZEoH+C9sCEHDIyRZWLp52FEzLcd3/Mz1Q7JmJ6RlJFUuv5UxfnERJC/5uviX8+bVmRRRUqIWgIuiiix4qO/BG0qCsr6T53fsz5CDaFyrGBVZL685jh8gegl6VY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=g1j8+upE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=crs/g14F; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g1j8+upE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="crs/g14F"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 578DNTof001302;
	Fri, 8 Aug 2025 13:46:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=5jkBvml+SF4eHnVOGgKr/XyhwpxGw
	0iUMl0uhLqccWo=; b=g1j8+upEWnhtJizGnXnlP1BI5W5ck01IeV39CqYmnDNUR
	x66MA01kXFXdYaEvGqWOa+dLfj4VNtOpT0We63SrCnvpgu6Bgn1U4bTEfNgiTGRC
	JynYzOGn1Mv6hlqtWk7eQscdta3KtBuVXu+SgKGC8aAW2xMKRnl6/7XR4ArtyN7q
	SBdHHl4nJs8pBg0PL5E7a9nPpjTOv5H0ZdlgYhBjN28amDvlkwfu+j8LzI5+AYW0
	4mv24eR6EFza7hsCmNKBn9RGRITdabiAujrS2KrGubj5yk6EUq5IiLc9Wog1eRXB
	babK0C/EujXNfGNkpyxZIDymVWxGZKaQdTxJAaplQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvgx8aj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Aug 2025 13:46:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 578CCvBl005633;
	Fri, 8 Aug 2025 13:46:41 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2064.outbound.protection.outlook.com [40.107.92.64])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48bpx0t9ja-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Aug 2025 13:46:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jnMciSwzSq+MHOeEqMny1rDF+IJR4Yjy7l/JVmYpi5DX0NHUG9lFLSsm72dQUmJsypcmb8yPqjkeWdyUZ37Vxi9a3E/5ZKp8akk969Swfx/6SjcSOS0Ulvy9T6NichzvQToDIFYc1xL2ruo8EOfeoRJqF/8/9Q/T5YV/0tBtGoszQY+aCWwdEUy9FGGYvCLUmfXuMRxfPjXIBWf7JP+DLjSkgF5Mo08r/8ET/ZNiNEPERP6lqu8qreCJHrCeQjyvrageiogg99fjroG46dAeq8TrPn7/Kb4VTWvvNs/KnAHhmf5j0kfVX4DqEYrpgEgWGNVhlP7q7gfwr5QeZzYcRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5jkBvml+SF4eHnVOGgKr/XyhwpxGw0iUMl0uhLqccWo=;
 b=hFv7kmfmII8Tn+ywV2pCkKmiz91NLLc/ISCpgFAEdFA+4e87bQM+8RjzKHvZO8XpNClGWf8Y6RoZj0M8Hd6fRC3VHOYbqvsHP9Wsf2HgZVVyBWXPuMwDN5XPRyRJ4k7KAYjQXJBsyWMBgUTNs7+vNan8uuUQIchG3RCi8IKHZF5+5/0RSjFSauUScnCMFTJsbGiwSyzzUO2s7YutbnDbSRnmP5cjlcvzIAAxKADNXSHS8hclYww0qTom7eFdRGkZlof/JcwAACgxPq7EDkBJiJpxSFPh3Kz0V+pjtinjlCDY6S8M+ZutBJpH9VCtWZht16xvPWe8W8IiVl7u228LMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5jkBvml+SF4eHnVOGgKr/XyhwpxGw0iUMl0uhLqccWo=;
 b=crs/g14FyUR2bBVUSDUSU/+zJ5HBez31jQKgMFiaVvJBLO5UZQLpm/SIY+AWIlRly4/Omt6apIdnR2t73NJZFeCMpJV0igDt2iyKIRjrnVmDQZ+a7r8wivZgZBXzWptkPOEdRAO1+W2Y9Ig9JSsAGbSzYsEVuAOk6xQV1AKQb/8=
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 CH3PR10MB7576.namprd10.prod.outlook.com (2603:10b6:610:17d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Fri, 8 Aug
 2025 13:46:37 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::156d:21a:f8c6:ae17]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::156d:21a:f8c6:ae17%7]) with mapi id 15.20.9009.016; Fri, 8 Aug 2025
 13:46:37 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "horms@kernel.org"
	<horms@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "gerrard.tai@starlabs.sg" <gerrard.tai@starlabs.sg>,
        "pabeni@redhat.com"
	<pabeni@redhat.com>
Subject: Re: [PATCH 5.4 022/204] sch_htb: make htb_qlen_notify() idempotent
Thread-Topic: [PATCH 5.4 022/204] sch_htb: make htb_qlen_notify() idempotent
Thread-Index: AQHcCGrcLtPHxO0YHEuL3Szvh2o6IQ==
Date: Fri, 8 Aug 2025 13:46:37 +0000
Message-ID: <e9d1d65ce802b4c8190ad4e5944e5be1cab38eac.camel@oracle.com>
In-Reply-To: <20250602134256.555884083@linuxfoundation.org>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR10MB7505:EE_|CH3PR10MB7576:EE_
x-ms-office365-filtering-correlation-id: 73157afe-260e-4da8-c2af-08ddd681ff20
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|10070799003|366016|376014|4053099003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?c3IzWXEvYU1BYzE4SWR0VzFob3gwb1g1ZnJJdlNFRE5nQzhsb0l0VkUzdmFj?=
 =?utf-8?B?TnlYelRhYmRjT3ZpLzRSV1lpVmtMZGtxZllwa3Z6L1NYUlk4TXVhRFE0V01v?=
 =?utf-8?B?Z1o4MmpVS1VLSkNaeVJRcnhNVUtZeFZYNmNWSVczSUNvMU5Na0hHUElVU25u?=
 =?utf-8?B?dlQrMnhsRnUydlg3bWl3TGxSeW9lTUJSQnFiUWwySk9EODJUaUJ1YkhTZ245?=
 =?utf-8?B?TkpvaGVXYkpKT2FyMy81czVIOFBHdUtreWV2WmNRY0x1SU40bldSTWg2aDdx?=
 =?utf-8?B?QXVMNUZVSVBlMllDaVhHdHU2Q3krcWFMeVdCSmpzZ0hZM3RXR2RCYVZPekta?=
 =?utf-8?B?djJvTU5UMTQ0UndjekR2cW9vTEdjWVNOR3h2OUZmanB5SWQwSVV6RWlqR2Jl?=
 =?utf-8?B?UHUzNkdvSUJoQjFZZzhpcHgzc1hUTXlQZFgybTMzVjc4ZENnRmJiekRvZnd1?=
 =?utf-8?B?K21jcUFLcHE0UFVHc1J2U3YzQ0djeSsvL0Y2eHEyeWlYekVMRG5lNE01Rldx?=
 =?utf-8?B?V0loZzhudDZxVDcrVTFGbEdJZ2pqd1R1RlNNZkNZd2llY00wMHBRbTlKS1Fq?=
 =?utf-8?B?SWwrd2g0RFFRSGlrOUNqTXM2MGRwcENIaE1rOTFXR2lBVWtVUEp6NDJNV0lK?=
 =?utf-8?B?Lyt1RGpmMGl0K2svL3hwR2xDUEtBcWV4cnFEcUlDcS9JNHFGWXJGYndZWkF5?=
 =?utf-8?B?VkErempqaG93K29GN1VDRUlJTWlWQUU4N1VOODlyUENDR3kyRkZ0bE5DY1FJ?=
 =?utf-8?B?UzV6emZYZVQwT002L0l1L3RTbzFyMGd0Ymg1SDJlVjZWckRLQTEyVTZoMVlq?=
 =?utf-8?B?T2FCcVE4Qmhsdk14NERCZnVsM1NtVENmcWJudjFzZ2FOVHVUcGdsV3ZCSW1n?=
 =?utf-8?B?TXVoREJJeThINm10UzdmMTNqdlExS3FwYUhMS1cyNEJHNm1vWlFHT291RERx?=
 =?utf-8?B?dzFudmorWGZsWFRCdkpFMHNsT0MxYkZHSkpGeWdRdGxRdkY3WXlnUEZCNEZR?=
 =?utf-8?B?Mzd2N1VDZ1JiRHhTQVVBL2dvOFZ6OXpXb1NEVGZzN21FeE9kTDBhck93RXJ3?=
 =?utf-8?B?bmFBZVpKdi9heUs3Tnh2a0FKZGM2eXhYaFVMckRDWWpIdXplY1BuUExrYzBW?=
 =?utf-8?B?Y3ErcjZFakdzUXBocjdnV251S0VrV2ZEOSs2MkZ0UVQxUFIwSjh2UFdWS1Zo?=
 =?utf-8?B?T3JqK0ZmNStkOEUxMGVtN0lDWTVoby91STFlREZvYTlxSEZDNXRFUm53YU5L?=
 =?utf-8?B?UUdZU09ibHlqbm5yVHpKOWk1Yjdyb3lUaU02eFQ4M2h1YjR3MDFpYkRCbjNP?=
 =?utf-8?B?YXp6UDFVMEdPTm5vWklZUEJZN1o1bmJ0QkNKUmtyMWFYOEF2RnRvVGVuQVZN?=
 =?utf-8?B?Yi9FSDlqb3NXT0hJT0J0TkFjVG5SZ0pWZTFucU8vdG1jaEx3U2RmeTZYOC9Y?=
 =?utf-8?B?aUNPWGF1VXhFOVBmWVVwNUYzbHJnK0d2YjEvTUtsTGJFVVZjeUh3WWZWd2xH?=
 =?utf-8?B?RHVJek0rRGxnOVdkNGV2N2d3MG40eWEwcmMwMmx6MTZhWUZTd285UjVJNndD?=
 =?utf-8?B?ZDluVUE2VFhFRlJka1NMWXNEM1BKK0U5S3lWdGpJKytpT3JycXluZ2VQbU1i?=
 =?utf-8?B?bmNpN21CdE52YzJNZFNSQVN5UUhHQUNtY0gvRWgyV2tiOEJ0WUpDTWpXeEUr?=
 =?utf-8?B?aER5VGR6L3V0ZWJ4c3VMZEtNYXhJc0xyM1NjeVVyeGwxUW9sSHQ1dUFQajhZ?=
 =?utf-8?B?Tm1iVFNvNnBnOHVqb1V5YSt2Q3FVMWFGdHZiUFdqd3ozeFpVWE8zNzRVVit6?=
 =?utf-8?B?aFY4RVJnekZlZ2NvME80NnZ3aHNHZW0wd0FUT2xJMThFaXJVTDF1OEJTQ0I1?=
 =?utf-8?B?cHYyTHlZQWhBdzlCOUE3WHRYQnZkdWlqSTRiNFozT0V2RjlkRURtZGQxRU1E?=
 =?utf-8?B?NVJ6Qkk0ZGMvbnQwVC9xb2I4WVNlZnRhQkl4NjVzQzRJN0tnMWVPWFN2ZmhO?=
 =?utf-8?Q?iBfSn2LCBOAxc1a5aqlozkHRzYRlAU=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(366016)(376014)(4053099003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SXVLTi92c2R0ZFppQXdQaHFabjlTeElRQXFrRnkzS2RXa0lRWHR2Wk1vN0FT?=
 =?utf-8?B?cWY4ZlhkUFB3UFI2ektBc1VsZDY5MHBkcXNJcjdVSVNNbi92azh2bEVROFhm?=
 =?utf-8?B?aXRsZTYvWUJDMzE5TW9vNDZyNGdDUC92Z2RzVjNINmdjZkNxRFhram94bHgv?=
 =?utf-8?B?VGZDalc4K1d3KzNEUUN0MGxLM1MvR2QycUplVWJNaXBjQ0dGNHVEKzA3MjdZ?=
 =?utf-8?B?NDZQOUhXeklDZkQ5NDlFcUFzS2pxWTRoUjRRNHBON20vOGliRlhqQ0JyVnox?=
 =?utf-8?B?YVdEVEt1WnpnQXd6S29yR0FvU0t4TWUrNFc5UDNsL29aWjdFWW5nZFFqYmRY?=
 =?utf-8?B?MGVPT3dTOUIvTTNqYUFHekZ3bXZGbHVqckZRVGlOLzdISFVxK3A0SG1waGd2?=
 =?utf-8?B?WnNpNHYxWHR1OXVvTVlNdEtSM3RUeDBxL2UwaU5jV1lwVk4vMWcwNHRndXpu?=
 =?utf-8?B?OGRSbkJkTW01dUR4ZzVHMDBBdzk5UGplSFBPYU5BK0UrRnIxZ0t2NUppSlh0?=
 =?utf-8?B?TTNaR1BjKzNGU2NXT0dZTlhxL1ZJUUZVVXY1MjBGU0FFcjNSUDZxTXRRaDZS?=
 =?utf-8?B?dW9hbDhxWGx1WTBRZWZmeUM5Y0JhUkhuc0U0dFBtWWsvT1RSQjJjM250eUVY?=
 =?utf-8?B?K3FXcmx4b3hGeEEwSkMrQjlTMnF6RCsrbG1GT1FlYm5RTDlYaXU4WlB0NHRN?=
 =?utf-8?B?YW5IMnk3ck53Y3lLeENJQ1RJdWpXMzVGR0dlL1BkVDd4aHRUWldtN1hqZk9t?=
 =?utf-8?B?Y09GN1RHdUhERjd0Kyszcy9KS2sreSt2ZGp5OHV1eUljNUozRWhZSnNDZ2RE?=
 =?utf-8?B?YWxDTjhOSmZ2dk5LdmRZZmh2eDYxUytwdmU1bmJQM1Zia2dpNnViN3FyQlFy?=
 =?utf-8?B?dmV1dDJVNzBHazk4eWxnUTZscGJIblpXWFRjTFN6Q2RqMHZLekRuNjdYaTZk?=
 =?utf-8?B?S2Rac2hDNXU2TmZBMHBGZmx4ZldpQ0oxb2xHdmx2bzJ2WExCNU93OE1menJj?=
 =?utf-8?B?MDN5RFhBQ3Mwd3hPSEZrV3hXdlpDRks4YlcraWVwUzE2QUQ5MDVFeEJONXU3?=
 =?utf-8?B?ejh5akl5QUdWQUlONStYclNVT2JOUHp1MjZqY3FUSE9BMEJDbHFXWUhzUmNx?=
 =?utf-8?B?WU10N2FmaFJ4RCtmckRDc1ptT3dRQ1UvY0Q3L1BrUHBBOXhYRWxVNld4Zk1R?=
 =?utf-8?B?cWQ2eU9kRWV2ZUowTmdTaXpyeDNWdWE2bVM1U2ZxOHk4ekxCQUNjWThmWWF6?=
 =?utf-8?B?ZDB0Nk9YVFRQNDBDUjZJZTFaOEo5R2J2T0pOeG9VS0NGTlJCVTNBcWJzYkNI?=
 =?utf-8?B?MDFtWkpZQ2h1cFJNNThKMld1Vk5mTzBEeVNOR2c4eWdVcUFiajE1QnA1Q1Nr?=
 =?utf-8?B?UVpGWEVPNnQwRElpZENpU0hyRTY4TUhiOWZqS2RaS1k1bk5BV3J2VlFUQVJS?=
 =?utf-8?B?UWRLb1M4eU1iVUhaYU1oWDByRXhxNnNqNktlNktJVUcxTEZKNkpwaklwRmJM?=
 =?utf-8?B?bklBMWR4bm5JOVgrK3RPRWZmVHIwR0FkQ01ZZ1g5NVoyZ2d2TUZleXQyT0R5?=
 =?utf-8?B?STFrUGYrdEY0L1paVyszQ2FRYkUrTkhXc09YYjhqSUNCTEh4SFk3STZjbERw?=
 =?utf-8?B?RUhXcnNYSHd3RVdTZ2JWV2ZBSmIxKzh1djRRNmZ1SVRRZUdkcGREanhRT3ZH?=
 =?utf-8?B?ZngwVWQrK3BvUFlXU1NWa1hNajF3ZFgwRkJFcEdhQmd5aHBNZDRxZ2dnOGV3?=
 =?utf-8?B?c3VPNXJDelhPWGNmQnI3QW1hQlVISGU1eThmK2dWVDRPUjRVVEtoQ0NFc3Vz?=
 =?utf-8?B?aTdrVnE0TkN1R0VwRXhJSjdyaE1ybGpBLzlBVUJZOEd0N2dtZ3MrbUpiNU5G?=
 =?utf-8?B?aG9hNEFSUU44a3lnN3pRSFFxNzA0YzVrMng0WFZRNjlDME1ad1laQ3A1TGNE?=
 =?utf-8?B?aHhVaWV0dVV6bURLejF4a0RQWi9ZWGd1ZzIrY3hSZXFITGRnaVpNVS9VRE9q?=
 =?utf-8?B?RE5yYUV1VkVlbktrY0VMWmZHbXNSaU9xQmR6QUMxVFdWN0Q0eVJWc0R0UTdL?=
 =?utf-8?B?blhMUyt6V2UwZ2hVcWhRTmgrRXY2Wm1BRG5Bb1JZcWdrTjNMblZvaDZIdDNS?=
 =?utf-8?B?OFY3LzNrdFQvMlZvNHhvTWh3VmZlWm9Ic3FZTlpRZm84cU8zdWZwd1JIZHhJ?=
 =?utf-8?B?VVdEaUNwRzZGaFFZazhXdEJDZTRkTTJDcTNjc2Z3L2Q0MGFYWVZ4dEoyTWNz?=
 =?utf-8?Q?1d/XN6giP8vW+MSt4U8yxT7ZRwEHEr4dAASU5YVfcc=3D?=
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="=-u3sPtqwBX77iiA/CktJ9"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tDGRQ2yvPoOSgxLBfZZOXgsT7gZPkfFdie+c9uMtN06ZmE3w3ZPsUCF3rChK82iYSlxXY/3CdLszj/hEqM68oLG+XtxEwwT79hP7hi2qNNddGMXgojLIsBc6QVhLgJUB8CzV1v8+l7NFwCMLJusFkwLKpumtyCHtUrHV5uql1AGVkXEXZMCWg5tByEGfMdiE5hfF9oUmQE8wkWZrFBduyywayzfS9NDAlTojU5dj+rIFtXyhbru/q4KHBLEA/fB/o1lj/Db9Fy0hXhOZfPYZuiYofZ3I9wJSHDwNZUFtiJsAPk7WF7IfeRmxzr0wGE85UManQbShCyTMZNoyrgRfcOmqsnhvpRhi1fMc93NdqIexqd2GTC6ytZoNUWu5rlNdF2gD634QneuZn4YeHj2EUEBqklSy6qNW7Sx8iinLwMf/tliq7a3kHTwbrZbOUGFVqr0lxM5uOuQA8CFAnsx1i56aSIrfjs0kOtzE5NdEzhcJ7p0U1cAcbd7OmGafrRdmCF2GmHQsg7Wgmpwlmmbxfx7QkjMvLmFEk8xDQxKjYMxd1ockVOcfYtkr5BlDkmnfX9ZJ1dlu0eacijAguyDnRKlvAQI5aE+f7izIRRXCirQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73157afe-260e-4da8-c2af-08ddd681ff20
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2025 13:46:37.5384
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zDvWmICanWKDYVxWLosJoVtBDAMfq6YUI9v4jz0XGOJFPl+DHffY/C54ArI9/dYPNDchXfvL5BuywDFcp2gWRyoiVRdTPTGDcW/O4QtpMHc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7576
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-08_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=876 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508080112
X-Authority-Analysis: v=2.4 cv=WMp/XmsR c=1 sm=1 tr=0 ts=6895ffc4 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=7KmDp8X2oIQ_-ZL3bpoA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=eTQNIeQiDB6fuzGVvW0A:9 a=FfaGCDsud1wA:10 cc=ntf awl=host:12069
X-Proofpoint-GUID: EQgBefR9DBCeYMCe7FaojSLcS2fbDLsT
X-Proofpoint-ORIG-GUID: EQgBefR9DBCeYMCe7FaojSLcS2fbDLsT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA4MDExMiBTYWx0ZWRfX3fBd/sMkk+AY
 WcM8Kz27DJ10/DUmKHAHPQPyIiZoFpn/yn3Ajfe7U5cvQpxyeR7LwFzIlfN6m09qHkosVmYHCQA
 r46JHgyIymerDn3swJ45czMk6QQbkltFqsrAK0LxC8M0jLG9onZ7+IIpP9HmnOmTTM32burPHC4
 ereeZ2zwiuE9vymbzmYtrE4UHK9Z14IdaEQy0WsvHtH/1e/XevPWJfLm7ceW62py/lpOqnldnRd
 jRBM1tz2juG4RVsWkco/755vZzIhTYP9W2okalkCTQHf73Kl4jfqzdYSOXhntgwhQ7fYHvxRaVW
 z2K6JAHB/UgI7rPnuhZC5kdMvdYS0QvYJbCYCC+AIus1OU37PNbMqkuaocLdbaGy2MQJrk/7tri
 fwL/CVNwL0Qlg03t8Dt3GHFQZIO6LUkqLENOkHpzxSMrx1n6DfsA4Oym2PThYeFBz4pIXRri

--=-u3sPtqwBX77iiA/CktJ9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2 Jun 2025 15:45:55 +0200, Greg Kroah-Hartman wrote:
> 5.4-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Cong Wang <xiyou.wangcong@gmail.com>
>=20
> commit 5ba8b837b522d7051ef81bacf3d95383ff8edce5 upstream.
>=20
> htb_qlen_notify() always deactivates the HTB class and in fact could
> trigger a warning if it is already deactivated. Therefore, it is not
> idempotent and not friendly to its callers, like fq_codel_dequeue().

Any reason=C2=A0why the entire patch series wasn't backported?

https://lore.kernel.org/netdev/20250403211033.166059-1-xiyou.wangcong@gmail=
.com/

Only one file in the patch series isn't present:

$ ls net/sched/sch_{codel,drr,ets,fq_codel,hfsc,htb,qfq}.c > /dev/null
ls: cannot access 'net/sched/sch_ets.c': No such file or directory

This commit is a part of a larger fix so it alone doesn't make sense.

There is a CVE identifier for this commit, but it's a partial fix for
the overall issue.

Thanks,
Siddh

--=-u3sPtqwBX77iiA/CktJ9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEQ4+7hHLv3y1dvdaRBwq/MEwk8ioFAmiV/30ACgkQBwq/MEwk
8ioEpg//WiPuAu1f9v6//hsac6mG+LMZwT+PPLh7qtM9AT3oHqBrB76bQgHu9PJV
Q7K7k8fBLf8MFdsbYEbljbz4kffUn2xf8KzwEYVQKpwYk3wf2Wt94S27G56VQcZX
g2DcBPIHxHlYgeh0rJKR2uOevFQR3652mAFvRVZwFeY42IwzCGrwBpPRoNUtsdS8
QVsmPzHQjYzK60SuCh44QqcVHS2dRC8S8Ebj5/Dj+4U/DJeKqplsH1wa4JTVhFiL
VzVpkvmfBpFPNpy5QnqWkUtfSy1fQxwfbNcWMaNKmdExNDWGJbJyJLyHHZy3Hcc0
zzhApHEQgjHhsEW5yBVKBHuWoxdcAPkXADfm0yONiQ532JorJNTVVQ90xGlBnxaU
fKP59QXeRPSEkozb5e3p2aMe02vy+kEcIEFlw5nhXbZdad/gD8uRfiUj75xWt6D3
IT1LezIq83HxGUh+2EI4jSjAF7PusX7aGdHoHWzCapL7hdGOYjeXOV4cr0MNPJGC
WVslN0xooa2PnTkmPqKUeXz2Os9JHfUotc2EZtSuwhZpxk9sXvaMS07tsGOUbx5J
zV0ntxb0GMx7gilM84z9hVI/uffbZQ6NMc1nVy8p9zkfy//O9vocnmZeLtimYRWC
9KOAhu1YJG3VLHvfxZwGzpd9Nwd1TpsqQEkBm2w8Sgsb4l9CxpY=
=bqOp
-----END PGP SIGNATURE-----

--=-u3sPtqwBX77iiA/CktJ9--
