Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C145719C56A;
	Thu,  3 Oct 2024 13:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727963651; cv=fail; b=BrLlllUM+X881PGTkyHfBfOpf4ixxkaKr+/2TCmr5o+vZGUqH5+uCJr0pDoWPvtaWY9sGTTtin+JCbjPCa5qB8ntibvHGZwS6S+Bclnr+uS6oB43Xp8Kq4MiszbbS5p/KRc0GaNYgO5LBb6NpJEwA+16VdlEtHjyQfMr/R9fRDw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727963651; c=relaxed/simple;
	bh=WZ9BtFmvyxhnjytinAQ6TwZYz4HQ+8q4V1JwNxW387o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=t4kvt+/nZsBzl60g/DTVqUI82K+hax1OQmQuIxeophPx0Rmvc3VgrM3IIgv99YoZi10wd3d7VvyNi/iYmGsdjLqY8TqvhmyE2bkQJSfELs08nHkxkBNcBqap3xVYmoupuoIfFEZC9ZwZa3FZHfhYrvxW+1sh3RT3OfATAyuuw8o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WCQgERh1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BguOvaHJ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WCQgERh1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BguOvaHJ"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 493DfciF013495;
	Thu, 3 Oct 2024 13:54:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=corp-2023-11-20; bh=WZ9BtFmvyxhnjytinAQ6TwZYz4HQ+8q4V1JwNxW38
	7o=; b=WCQgERh1GmEZCfQBOFh5HkGVwdGG6S9xD8ZUXyeM9zjjyyQ6MBQIfv50c
	7LhL3+Qh4YVtWnongHDeLjO9atEHWyqVFZP5Km4/9krpUuhbSh3jedcgz7sslYWa
	dquDln85SHOvs04wGJhNfMQbxK5FU/PW62yWy1B+v+znJsT49hrHJkeDozKzy1fh
	V/rXPdzgO4KzSR/mF1bJvWQ9JEfup//KvfjE4wMAsEhxBltjgwIq/21CUW3W/N47
	XdagQVDMcEY7N93SBinaVE+r4EiHXxL5kV/G40cWE5A80R4GuiJFzfGE/dWGY+be
	XgVvvICG7sdCdBGvuTb0AVM+muzMQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41x8d1m68n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Oct 2024 13:54:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 493D9Nv3028439;
	Thu, 3 Oct 2024 13:54:04 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41x88af3b6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Oct 2024 13:54:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b8q9EJweYqElyo0DSL4Qzncwn37guZCGaFZ/5U905hlYtyoEhDWa00P8RhKChD4kXVagvQlgHGdx5P0kAE/7XRJG0IzTAZhKH1a//938D87aTn1qQ6Ax4PcKgjKOFHKLBoDafSzeg7+zZQs1ZnntqvS93exc3e73H0HdSiG+rsusOHMr1RWxeTsNQgl3BWlrQGH963PnJD0251PSl8ap2a9yddhOvYCDxfoBDFodGOMEkRk5eQ9M7Twxx1pb5xjpPSqguuJWjpjCoMv8saXEpTH/sOVtPjVXDkI9HCBCk0otkpxskF+2r6uKD3YImV4S/aEBlIuYB0u801sRpofJCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WZ9BtFmvyxhnjytinAQ6TwZYz4HQ+8q4V1JwNxW387o=;
 b=r99onaEQ0AraeuT607pSevs0wyZSeZT5J2N9ysSnG5YbTE8sxntBUB+h+JeGRmVDAkrKP1fBN7/9qW4aKIQuDPNxeA0x27N5WyT3LwCnLSOulVgGigViW1idjitJ0XrhiutBFMcgE6ltGHyBgGG4grHdmzVXdJ9apmg5PfsucwqEsucKK31t9Uz6r0K/Jv8JPt/fqTFoesmNbQ2pRJ/Gx2hPSf0WSwLzkPBuNqFESj9Ty9DTXyG1QSk7E4HRlvxQ/RHYhLMH0kLnBOhWMmkwKhuHxyAn+9bVpw03t0CXkypvYQAofg3fj50Y20aNApq7JBiwKX6JXWc2Fo8Oq3aRSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZ9BtFmvyxhnjytinAQ6TwZYz4HQ+8q4V1JwNxW387o=;
 b=BguOvaHJyA5s/CR3luZX/3cW4FKaETL3jQBIIQ88lC1hUTfnkABhtlOKPnVcVJyujmvMiJg+4CHg2eZpwhhwDqF+I+3Cx7RkTA3PylVmKq0/YaEQwQssoKJKAvRPJN0lI2RySNrlMomS3iVptgSUtiDRw3xC3NK9dyWy9ZITzFg=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by LV3PR10MB7721.namprd10.prod.outlook.com (2603:10b6:408:1b7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Thu, 3 Oct
 2024 13:53:57 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90%6]) with mapi id 15.20.8026.017; Thu, 3 Oct 2024
 13:53:57 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Youzhong Yang
	<youzhong@gmail.com>
CC: linux-stable <stable@vger.kernel.org>,
        "patches@lists.linux.dev"
	<patches@lists.linux.dev>,
        Jeff Layton <jlayton@kernel.org>, Sasha Levin
	<sashal@kernel.org>
Subject: Re: [PATCH 6.11 397/695] nfsd: fix refcount leak when file is
 unhashed after being found
Thread-Topic: [PATCH 6.11 397/695] nfsd: fix refcount leak when file is
 unhashed after being found
Thread-Index: AQHbFNBh+el4ZjAI5UiZoizZfWmvE7JzgJ0AgAEe04CAAG5DAA==
Date: Thu, 3 Oct 2024 13:53:56 +0000
Message-ID: <A8D6C21F-ACAD-4083-900F-528EB3EB5410@oracle.com>
References: <20241002125822.467776898@linuxfoundation.org>
 <20241002125838.303136061@linuxfoundation.org>
 <CADpNCvbW+ntip0fWis6zYvQ0btiP6RqQBLFZeKrAwdS8U2N=rw@mail.gmail.com>
 <2024100330-drew-clothing-79c1@gregkh>
In-Reply-To: <2024100330-drew-clothing-79c1@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3776.700.51)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|LV3PR10MB7721:EE_
x-ms-office365-filtering-correlation-id: 637720e6-0524-4829-38e2-08dce3b2d36c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?MDVSV1dOdUZrSnlKMmJZdDFzWFo1VGgwMkRTM2VDa2Q1RHNuMTR5NWFHZDJr?=
 =?utf-8?B?NGtQVk9NYW5DM2FDSERXRUs3bkpOZU5PUy9GYVdXSWs2ZmJyazdkVVFndE1X?=
 =?utf-8?B?dkp2emUzZmRBQTF6dmRzWnM2RGpVRFdncFJwSlRnKzVNdHZhdVYzOS96MDl6?=
 =?utf-8?B?YzQwV3VZVExqbzRsKzRUV1phZDhmSW02ZXlPaDFxL1JTcEJzb0RSeG1vVlVo?=
 =?utf-8?B?bEFwd3F1UUJkR3JCN3plcWt0VHpUbGxhaHBjclcrZ0VxbTF2TndrdXVOUVpq?=
 =?utf-8?B?QTJpWDNEZVp2NHQ5L3dkNzl2clh0Q2VQK1YvUEVubXBrbkZZZ05ldXBuK0Fx?=
 =?utf-8?B?TzJocWlDNWdRam10bXBhM2dDbE1XTE4xamhIQ3A1cWJsL3FNMmpqTVdtNjRx?=
 =?utf-8?B?WlA5V3IvVmJrS2F1NFUybG9teFVvOCtESWdDSk1rbUVjRENlUElhRWZTOVhG?=
 =?utf-8?B?TkMrZmdsY2tZMzQ2RVlCTmtMZkJ2clBvWHpGbjBDL3lZNEVFTzIvZTJ0NUVq?=
 =?utf-8?B?Wkk1aUJRUGE0dFBMWnVySUVYd0RNM0tXRWNjU0thWjZRMzUydldrVDYvR2FR?=
 =?utf-8?B?NWk0SVdMRlhRWW9CWnZKRHRPUUZLUFFBUUsrTWppeXY4d25yeDM5V3NBS3Jl?=
 =?utf-8?B?YXJtZWcwR0pWRkdJMlQ3YTRvczZKbDl2UVdRRVJvdmNNZ0l1a1A5U25RZWNo?=
 =?utf-8?B?RGNQQ1JPUndGODlQYThjZGRpeTV4Y0tseXNUbU5Dd0Q4bkVTdmNqTEtXeDh2?=
 =?utf-8?B?NUhybTh4N055S2pQWEhFamg5YmlnM2l6d1pBam9MMWdhTWlvNVRRVWxvWkZH?=
 =?utf-8?B?a2dOZVJ4Sy8zWDNpdXBaNFNSMVJMZGN1TUxJb2hrT3pVUzdLMWFHMFZPNFVy?=
 =?utf-8?B?eFI2UktQK3FEc0pqMlk5T1JTSjl6SlI4UDJ6cjVBTjcwWXB4VXRUelYva3Fj?=
 =?utf-8?B?dG9oT3dmb1NkMkQwTmZKUlptVzNnVUlGYnk1eWlxN3dMVndXRDFja0x5bGdS?=
 =?utf-8?B?T0tPOWVSaHdtaEx6bGgwVWJyN1lpaGhNZXRHMVdBbUZET2drSzN4QmpLUDNM?=
 =?utf-8?B?QmsybWlCNmNCY1MwdjdZbU5CUmVpVnNYaElhcndrUUlPMVNYMWdjT0hHQk1o?=
 =?utf-8?B?aGJTbTA4ak1xTnZDL3crWHR1eEs3ZjEvL2ZzeTdFUnlIeVVWTWZ1bHVjaUtZ?=
 =?utf-8?B?ZXJtSU9SS09tWGdQYTNBang3d2hZWUhMOEo5aWI1MGt0TU1QV3Jsb2RlRnBO?=
 =?utf-8?B?OGRYZkJMWTl4bUxacVVMMDREM3RtWUhCWjNOTGRKSW9Ea3hiUXJJOThlbWda?=
 =?utf-8?B?eWhFRVZ2MEkzeWNyS25UYWlIOFBvQS9FNEJqcVgvdVo5ZzNiYmVUbldEQTk5?=
 =?utf-8?B?eVJRMVVGMVVnNzlkZzFlNlpOalpxUzQ0Q0FUSnRqWHY0UmZKdFZPZWE5cFBa?=
 =?utf-8?B?Yy83eGFMV0tPVDhtZ3RqR2NrT1NDcWdCajlmeWQ2TGxOZmYxWUNJTGZHT2c3?=
 =?utf-8?B?UUxEVVdVQm9DeDdvQkl6aEFXMC81S29XRlR5R1FmczBFaW83djV2bXpqU3cw?=
 =?utf-8?B?Mzk0SEY4NjZleE9va29LQXZJektYR1gwQ1MxK0RjY3Y1T1VaK1RwZ0pXMmFq?=
 =?utf-8?B?RzR1cjJvQTlVVElhMEN4citOdWZ3WlFQOGVnY1FVVllydkovY2w0RFFvTVZO?=
 =?utf-8?B?V2p4ampIa3paWTNOS2gydGRyMG41Y3luQUxBSmg5Z1ArYW1Ra0orMFdLN1ll?=
 =?utf-8?B?bzA4L3pwZk5oSTM2UU9sV3ZTSGFOcUU1WU9FNTlPdGQzZ3ZUV0V6S0tnd2RJ?=
 =?utf-8?Q?UhX9cDFLxRMimdDG2qgC2h1Cw0Btj4EaeSig0=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SEZYZzVOMVFCaTJ6eDBnSUc0NkprUXdmdmFHeGF3Ni9meHVPMjBhWGV0eWpJ?=
 =?utf-8?B?ajQ0YzNrZi9zZldxUkJxK1VOT1V2U1pQZDkwZ2dKOHBiVllCU3JwaUJWMVN3?=
 =?utf-8?B?MnpHTTJVT29wWDNDdXBhNDhvRjFrKzhhd25WMUIyZklsNUF6Z0laMm1oRms2?=
 =?utf-8?B?ZmRDTFY2dWxELytDZGdiamJIaVBid1dFVVE5M1YxS2hEN1o0VTZGSjMySGk0?=
 =?utf-8?B?R2tNK0cvdEZOWUR1ZWZ4L2o0Uk5ldERTbXdYaWZDTHMyT3lTcWpmTHN4QmJx?=
 =?utf-8?B?ODhTWXVxbVNKemZYanMrYzA3ak9VK0cyUmR2UHl4OEh5NjRiNEp0Z3ZtYW42?=
 =?utf-8?B?Szk5SlpzUzA5eE5RcWFucjI3SWcrY2JkbDVEY0RPMVYyMXhDYnB3dnJNZlpt?=
 =?utf-8?B?bDhldzBKZitFUDh0OFVwd0NPcGVLUUFONTh4VEY2cEV3SFR4UUNneWRGb2lp?=
 =?utf-8?B?U0hFejhVN1B4OC9qMDQrSDVCV0xid1VrdEVFNHF1Q2NNQlFSL1JuMTVzTWZs?=
 =?utf-8?B?TmhHV3o2bUtEc0FrUktJSy9weEYza3U3MGFYMEEzeTVyYnc5TFMycW0yV0M0?=
 =?utf-8?B?UWJTMjNTQzZ4OThFRFJWSUl0TTdtNEtNajNWU1d6SWMyQ3BKSjVzbFJ0b0Jh?=
 =?utf-8?B?QTdnQ0RINVBtUkJKMzV2empMMFZ5ZXBuS0h2TmJYc3VnbFd1dGtFUE1RTnFI?=
 =?utf-8?B?T1RXQkdyZSt1YXNyZE81QU8wRklwK20rc0MxV1JjUUJzTzhmcVBSWnlyeTRS?=
 =?utf-8?B?UFdNd08zWk1DK1ZwTUtBTFB2WE1vcXRXbVR0WWhxMEhGWGZ0Wml5bzRtM0dO?=
 =?utf-8?B?ZTRXWlF4SUhnWno1OUF0TkdtbGJ5dHYvR1g3NzVwZ3N0RitMNVhVT2JTUnNK?=
 =?utf-8?B?R0E3eVNCT2JrT21mWDlaZUtaeXArVmNRdzJKamtwSHRaRzNMQ0dRSmdLcXVW?=
 =?utf-8?B?ajJ5QzNiaFJnbVBtQUF1NUhKc09BNHpUQVRMVzZFSmFSbG1pVzhzUVNUdG4x?=
 =?utf-8?B?bTZkN2U5c2JUUUxxM3d5eXl6WGtxSndNTU9OTUcwa05pZ1pUS1EwL3VleDNF?=
 =?utf-8?B?bmN1WEQ1TVJuWXNtZ1VsdWx5R3A4OGx6Z2hKbHFCRURTQThNT2w0alBDaGRC?=
 =?utf-8?B?akRFZzBKYWpEVmo5dmJ2N3VDRzFBMW9PMHpobmU3cm5uN3Y0bzVabUZiRkRr?=
 =?utf-8?B?eXhGd0duOEVINm9iVDlmVEY2R0FGRm1OK3JRNG1adVVaVUNKV1RFWG9kT1BJ?=
 =?utf-8?B?amk5a093a3cvM3A0TldwZzU0cFRZTnhPR3dtTzdWSHZPMzJBZWJiTUNheUg4?=
 =?utf-8?B?SHozRFFWQ2JzUFNqcjJTN0xWdzYxSlpsOXlqZzVzQzg1VnFpeGdra3hTSVcy?=
 =?utf-8?B?bkNQTjV5ZmhCWk0yNEFWMkxoWnN5emduU1VqQ2dCQlRGTVNScGV0Qjk2YnYx?=
 =?utf-8?B?K05kdHB4ZEwrT0ZrSUdybWo2KytXL3RxeTlzSEhpY2p2dU42ZkljcXVKUVNp?=
 =?utf-8?B?U25qQ1JUMGppb2ZRdFlxcjhzTVRadDRoWmdzQWpKbDNlVEhvMWJWZEFjOFhS?=
 =?utf-8?B?U21WcUhvY2swUXZ1VmE3OThuaURLcUR3amw4SjJnNXZZM1dwdjRCNUE0ZTN6?=
 =?utf-8?B?V1dhbEZOWkdNcFphWmhpd2NtVnFKampNeXRCbzhpT0RnU0Vod0c0SDBoekM4?=
 =?utf-8?B?S0w5RUNVQ01uUENFc3VnaUxqQmNZM3lNOURwVTZCa1RnNHdjS0FEcTBPcHNZ?=
 =?utf-8?B?cGtrYXU5VFFpSzhHWUhzZy9IbytHaDJPSXdORk1TRGpwbXlhVHhxU3MxZEZU?=
 =?utf-8?B?cWJpRUR4LzhtN0M3ZXlRUnVoejlDa3JvMitzWGhBbFVlNEkvNW1yTE9wMUh2?=
 =?utf-8?B?RGFubERlcys0ck1YbUF1ZWw1RXpmTndneDBCUEIxUitpalhJd082WEd3c0tN?=
 =?utf-8?B?ejJtVFJPS3BMdDVtb3hmWkdNek9mUXNWMVAzaGRaNVRGSFIwU1QxZTQ3V0ZZ?=
 =?utf-8?B?anZFZVNlUCtrejBLdmJmRVB1MUJmdVMyQThsOWpaMWgxTmNMYXB5aEdRc0k1?=
 =?utf-8?B?RHV1d2lmSE1iaEkrU1Q2LzBsU2RaN2xVdlRVdGVJOGd0Si9td3R3RW5EdVVr?=
 =?utf-8?B?dVkwV1BKZWpjQzFSKzdhbnV4VnBEVnRHbEtKOHBSZHdkdWc4NTlDM1dyZllO?=
 =?utf-8?B?OUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1C7B624800528E41B0B09C20080FDDAF@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Z5J4kH6e+ILjC/TDgkqLIAtz+XuLMXBkbG7vBXWXAZFwBZMOcEOtiMTcbMchRdSMSdiA1ey67i89yTWcH1XfVbORo9BlHq4I/vq4MjWeQkNem4KdoJ0+quy32DD2aX0+LKoFSWilS8AlRC60b16XdgFu4PfngPCV/4KCOXCsT0fgOIhejg11MEQOgNMqEmKWhf90A48oYRMWWFoZ9DoIw2h4LnZN8UN7DVaY3MTnFr76b1XcHsJtNYiJFvIWQH1KpD+5aylAw+6SIH5vBOpr2nJewIVDW+zELOps9xLnZnZwsA3lJ8N8lIWAkXVjt+wR40tnjKPwwtcq93grjCK47xr6uZeJ/FQ1fn31wVt3A0Ij0U49Xvcrxhnb3hlR9zsGEyi+rsnK33KsKxHOkIkzvtZLho9CzcHt+JCurmjkvOu4Juvux2KNWBA9je198e7o9BF+IBnAp4LAWZjW0HH5scPY0AdIT/ON0h+Msetfe3G/5En3gZ/QToRIa7cSRkKRf8MnFBLbXqUsHsJOi3QgQAEBPBMMc6ODL9YUI/3qxBU3V26gdlKoHq4vBJvlcYNOYBI5uCOAoDzAp039bDA2U5i7iZqYlZPQo+McVvtahVg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 637720e6-0524-4829-38e2-08dce3b2d36c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2024 13:53:57.0007
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZjwLqfgYf+ajrMrclpFf65GZgT4O0zA7uEQ/OB172k1pGSJAdEQgFRmCV2cQZ2QGElilDJriaOSo534eKbTMEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7721
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-03_06,2024-10-03_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2410030101
X-Proofpoint-ORIG-GUID: AyJWhCRl4PDsp-GVvykgJb59Ka1dISt4
X-Proofpoint-GUID: AyJWhCRl4PDsp-GVvykgJb59Ka1dISt4

DQoNCj4gT24gT2N0IDMsIDIwMjQsIGF0IDM6MTnigK9BTSwgR3JlZyBLcm9haC1IYXJ0bWFuIDxn
cmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBXZWQsIE9jdCAwMiwg
MjAyNCBhdCAxMDoxMjozMkFNIC0wNDAwLCBZb3V6aG9uZyBZYW5nIHdyb3RlOg0KPj4gTXkgdW5k
ZXJzdGFuZGluZyBpcyB0aGF0IHRoZSBmb2xsb3dpbmcgNCBjb21taXRzIHRvZ2V0aGVyIGZpeCB0
aGUgbGVha2luZyBpc3N1ZToNCj4+IA0KPj4gbmZzZDogYWRkIGxpc3RfaGVhZCBuZl9nYyB0byBz
dHJ1Y3QgbmZzZF9maWxlDQo+PiBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgv
a2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQvY29tbWl0Lz9pZD04ZTZlMmZmYTY1NjlhMjA1
ZjE4MDVjYmFlY2ExNDNiNTU2NTgxZGE2DQo+PiANCj4+IG5mc2Q6IGZpeCByZWZjb3VudCBsZWFr
IHdoZW4gZmlsZSBpcyB1bmhhc2hlZCBhZnRlciBiZWluZyBmb3VuZA0KPj4gaHR0cHM6Ly9naXQu
a2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdG9ydmFsZHMvbGludXguZ2l0L2Nv
bW1pdC8/aWQ9OGE3OTI2MTc2Mzc4NDYwZTBkOTFlMDJiMDNmMGZmMjBhODcwOWE2MA0KPj4gDQo+
PiBuZnNkOiByZW1vdmUgdW5uZWVkZWQgRUVYSVNUIGVycm9yIGNoZWNrIGluIG5mc2RfZG9fZmls
ZV9hY3F1aXJlDQo+PiBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVs
L2dpdC90b3J2YWxkcy9saW51eC5naXQvY29tbWl0Lz9pZD04MWE5NWMyYjFkNjA1NzQzMjIwZjI4
ZGIwNGI4ZGExM2E2NWM0MDU5DQo+PiANCj4+IG5mc2Q6IGNvdW50IG5mc2RfZmlsZSBhbGxvY2F0
aW9ucw0KPj4gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQv
dG9ydmFsZHMvbGludXguZ2l0L2NvbW1pdC8/aWQ9NzAwYmI0ZmY5MTJmOTU0MzQ1Mjg2ZTA2NWZm
MTQ1NzUzYTFkNWJiZQ0KPj4gDQo+PiBUaGUgZmlyc3QgdHdvIGFyZSBlc3NlbnRpYWwgYnV0IGl0
J3MgYmV0dGVyIHRvIGhhdmUgdGhlIGxhc3QgdHdvIGNvbW1pdHMgdG9vLg0KPiANCj4gU28gcmln
aHQgbm93IG9ubHkgdGhlIDJuZCBhbmQgM3JkIGFyZSBpbiB0aGUgdHJlZSwgZG8gd2UgcmVhbGx5
IG5lZWQgdGhlDQo+IG90aGVycyBhcyB3ZWxsPyAgQW5kIGlmIHNvLCB3aHkgd2VyZSBub25lIG9m
IHRoZXNlIG1hcmtlZCBmb3IgYSBzdGFibGUNCj4gaW5jbHVzaW9uPw0KDQpJTU8gMS80IGFuZCA0
LzQgYXJlIG5vdCBuZWVkZWQgaW4gc3RhYmxlLCBhbmQgdGhhdCdzDQp3aHkgd2UgbWFya2VkIHRo
ZW0gdGhhdCB3YXkuDQoNCg0KLS0NCkNodWNrIExldmVyDQoNCg0K
