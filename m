Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4E81A2C11
	for <patches@lists.linux.dev>; Thu, 15 Aug 2024 14:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731237; cv=fail; b=WRYGXPJ+leQUJtC22zDFycett81ljOOJehJRxaCnsUvm8BZG4DDCFwFY+loqzM+ud81fM/HJENqd0+hCbhpCZaXrjzDxrwbEduTKRuTh4rYM7ZIwySHLCeIG6T8+8utdh4hxNJuYSWj7kkzILLO77FfRwRnh2N/bcMWL4R+EPds=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731237; c=relaxed/simple;
	bh=CXnn1klMN7sV4dt5Wod2AZIO41Q5wYQ11sWxFoRPpgI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dJdWoCBaownmAb0BIj9COLP4v458gb6YpgPYOiQNUGc9rqHXP8Zha3dawbhhGphG2XJQ4lOqp+PU+PPvPP+xfIXJ1bXmh2S3845fGRCt7fXx4Sj2/frODiaPXsH1kXFICW83D4dGdrOlkXeTVh1kZebst+bKhbyO2r4L93uq/lQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=o3SzHfne; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=J3FbZ3OC; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o3SzHfne";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="J3FbZ3OC"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47FCtVQO024993;
	Thu, 15 Aug 2024 14:13:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=evM8Wk/v0rFKE5BGuJ8SDEyf+RChZ3MixweVsLZfMEg=; b=
	o3SzHfneOMusSUTvalsztwXoyKh8ll4jFjwBgXZkD6kYiac54CQVFhG4wRLlGzmw
	FPMdYp7Ci2HeY7IMM1UzGmtlq/RNayhV9CUAnqAjypq9aC8N7sbLmWlxaM90VXuv
	EDsPV28QuUWnkEruZFLAbNKH1wG8mKTBGuwBhzIpmBu5vXgIk6rd33+/fHiwcp+9
	CzCv4Zbn93i5kjPCyIVGZFwUjvThihQxx6yKXYos61U4ttfBb8pRiKqNYMicwkdt
	FXca8hF2zZmtw7Z3mCnkxfmjIV4liomGvpC1P0hXeP8H4/4/8YJpYBAfYNbyHS5F
	lqdS6ctEEE7oaXT32Y+yyA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wxt12jfe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Aug 2024 14:13:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47FCDa77003704;
	Thu, 15 Aug 2024 14:13:49 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40wxnc5w1e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Aug 2024 14:13:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pRCWcoIywgpuEuavpYd04NJgavtxfWFTuI0j8zm9ZK/X5Hp34/9jyDVMpcVw+WJo+3qwMlsNABMzrjBPy0rzgpep08/QimwDPmP2IIoMqNZsiQGURyzkmqpbP76rnKH44a1FKt/2N09SHZnGUvXxVEmbnToxk6Q42Fut155T43Fi3z/zb4lnUo7kNyEkaZR4ULbYIoC3JppXFmqoAl4ogtBi7qDc7UBZ8QZScn2Hx8FwQC195RAYgxzfI7968ArRLnTWShEdHZPAVIQONrD18anrBggBucYLvJu4NsMGiRvQ4BhC+Ac1k/BXMmAXMWc3hdth/nb3oBl+S3EpX2vzhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=evM8Wk/v0rFKE5BGuJ8SDEyf+RChZ3MixweVsLZfMEg=;
 b=XX1HUbMXslbdd8KmjPtrrJJ04zmrXZpeAvFjyKkBTyMatxEGKHVUjS+RbzzY3zCktZHAOdP7zwPXM7Haow2oebbyWuOX5HhJ7IpPVa72m9JKpXLkgGp82AsALnDVEmQCTICa9nTF1A5crgiZQm3yzXBC4Qz2WVo/O9rhQ5cENP+lI81t8Lh1vAs1EhHoMw0i36Dw0rrLJd6Udp/0u1SzMe68+lcgzasiYJnutg3Lg5FR8g9f+3xYVK+nphTwCumgK4fxuX7fVTGnjt/H9QSlD6eS8S2Y47lTlxGyaRs24s2EreuYoKf9LRepryGDnQV6uOXzAZSkKOhtk/ufSdDtmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=evM8Wk/v0rFKE5BGuJ8SDEyf+RChZ3MixweVsLZfMEg=;
 b=J3FbZ3OCrVZyFtXRSdPbY0GHrE0XyRph3rPrvxTiG6zz3Q5X2tlLjYpuPSFyHESoWcAeJPtgy9OXyepcWLNSqg+iIoUTaVD5LpTUmFpTyUIxMuQLZWZH8GG6itNOcfBRvtJubv4Ql/v01vIC2o1NzPRTdQXzEVpW2hiyA8vxTXU=
Received: from MW5PR10MB5738.namprd10.prod.outlook.com (2603:10b6:303:19b::14)
 by SJ2PR10MB7083.namprd10.prod.outlook.com (2603:10b6:a03:4c9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.10; Thu, 15 Aug
 2024 14:13:46 +0000
Received: from MW5PR10MB5738.namprd10.prod.outlook.com
 ([fe80::187b:b241:398b:50eb]) by MW5PR10MB5738.namprd10.prod.outlook.com
 ([fe80::187b:b241:398b:50eb%4]) with mapi id 15.20.7875.016; Thu, 15 Aug 2024
 14:13:45 +0000
Message-ID: <36b8c214-3039-4fce-b27e-3558a78cfda2@oracle.com>
Date: Thu, 15 Aug 2024 09:13:42 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 29/67] jfs: fix shift-out-of-bounds in dbJoin
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
        syzbot+411debe54d318eaed386@syzkaller.appspotmail.com,
        Manas Ghandat <ghandatmanas@gmail.com>,
        Sasha Levin <sashal@kernel.org>
References: <20240815131838.311442229@linuxfoundation.org>
 <20240815131839.446390501@linuxfoundation.org>
Content-Language: en-US
From: Dave Kleikamp <dave.kleikamp@oracle.com>
In-Reply-To: <20240815131839.446390501@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR15CA0010.namprd15.prod.outlook.com
 (2603:10b6:610:51::20) To MW5PR10MB5738.namprd10.prod.outlook.com
 (2603:10b6:303:19b::14)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR10MB5738:EE_|SJ2PR10MB7083:EE_
X-MS-Office365-Filtering-Correlation-Id: ca9ae1d8-dcf3-4b91-af7b-08dcbd347965
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NUVwKy9RZ3hpeHJ2K2FpNTBlZENhTTNnWG52NnNyMndkdHJFWFc4Nlc5R1Y0?=
 =?utf-8?B?V2lqWGUwcjdKelZGRmpwbmNTU1cxMnpLcHdUeDhRRDRoZUFBcVAzUG1XMERl?=
 =?utf-8?B?eFpXUmwrdFlnMVdzbjJnZkY0azlvZkpueUtmUW9ZMG9jUTlBd0NHdUEyQ3Nq?=
 =?utf-8?B?K1hFOTZOS29TemFtWFJhaVZvTGM1T0lDc0xLMjN2SFB3bDRsZUpRR2pjdXU4?=
 =?utf-8?B?QWlvR0NDSlphY3c0ZklIMGJSZGJaM0V0dWhEWTI5MkJuNTBndzEyTWZOVW8r?=
 =?utf-8?B?KzN6dWEyTytMU25vOE8wU1I3S1RsbUF4QmRsVXRnWG5lMVZkQmlCLzlRdGJN?=
 =?utf-8?B?SXlJT3F3QmJtOTM3OTRlV2RCeUZVeStwM2l2WEQ5SDNRTGxhS0h6bUtIZW5R?=
 =?utf-8?B?TE0yeC8rZnNwWE00RVZXaW1LaDJvdDhZNXBzZi9Vd0syaGRpUzlkemN0aEFP?=
 =?utf-8?B?ZE5tWGFCdG1MajFnbHdpUFVPV2NMUlluYXFPUUlldHZaRkJzNzZoM1B0bHB6?=
 =?utf-8?B?U3NncmthYzZtM2cwaXF3U1lpT2MrWGZYVjQ0T2Z5OWMwL3B1R3ZuWktvSnd3?=
 =?utf-8?B?T1p3S2NDRVVTby9uSjZiYlc1NGlEQVVXRU4xd1dGVHpneG5uS3NhNEtQRC9P?=
 =?utf-8?B?V2YvT1NDOVVhNlpwU3gvMVIwbXZucXIwUEZ1NUtXUnc1NXcrNHVHUC9uMFRy?=
 =?utf-8?B?RndnaGp6SXdrMXY5RTZnR1p1VjJoM1cxQUFMWTYzU3l6bUFKYVZlR2NDczB0?=
 =?utf-8?B?ZDlJSGx3REk4cDVQcHJvbjdYdTlIZlp4L0hFSUJnblk1cm1jRk5teTl6VVRJ?=
 =?utf-8?B?YURpMXVXNHF3RXJ0STIrb3RSTjlLOVRwTjFyaUR5UHBqT2xMeDRacDBVeEp1?=
 =?utf-8?B?Q0JMdUtqTmtBNVZXcVBrVzRHbTh2a3lPMWYwY0hMaHMvYWlRRWNNTy9oZ1RV?=
 =?utf-8?B?N3JDeldiN3dQb2pDc1RoSVVIc210WWJYTTVUdHRZTXBzQnk2UzI0Y1hENGxu?=
 =?utf-8?B?L3ZWd1Fhejlqb3haL1NuTWRpM0VoUFpSWVFQTVpTdWRwQnFjNzZhY0FOdjY1?=
 =?utf-8?B?V2kxVXo5YkVEcjRmMTdRSFB5UWJLc0RmM3ptNWZmZ3Z4SzhwK2kyTEt4eFRr?=
 =?utf-8?B?VWI0VGVqSks4SHA2bHRSbEhKRHltRjZQMkplNlJuWHZFbUJZVGNyZG9reG50?=
 =?utf-8?B?dTJQUjBjQUM5N3lZNmY0YTVWZ3ZoeEFxQ09ndUdaekMrWmtwL1gyTnhFTTMy?=
 =?utf-8?B?TUgxck1SNGZwNHptYzEzNHhNRDZmRXhYR1R2V0VZYU1zci9GTzMrK2crdm44?=
 =?utf-8?B?SFpBUzdMYm85amtIdzZhdnlxZTU5YTAyajFxN1NGV0duQkE3eW1ZMXZ1MWVW?=
 =?utf-8?B?UWhGYWFralhpeXh6RGptWXNPNG9sUktvOUVDRGFObFRtMG1lMFFnZG0xcmZU?=
 =?utf-8?B?RGdGZXBoQlhNYUhOSDA2Q2IvSkpFV1BTWmh1ZERHaTBlK1FQT3NHa1k0NjJI?=
 =?utf-8?B?SXhhVFhTTjRhajgvQ1BnOHhlZm5xcFBPZWNvUjhaRGpvQXpQTXNIQ2dxNzQ5?=
 =?utf-8?B?NTAvclpxeGQydFFtQzgwMStuN21MdzIwRGU0TGxhRTJPKzh1UmFlNWlkdTAx?=
 =?utf-8?B?dWIyaVdkUGszeXpCRERTeEZxL2lCRjVMa3ZZRTR2aFJrcG9va01aYjN0dUxm?=
 =?utf-8?B?RWpZb2FBTUpXd2UzS290Qm9vaW5JdGt6TzlhQWFvblN6QVUxeElCOUVzOW5S?=
 =?utf-8?Q?QOi3+5WRZlPq37XEKc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR10MB5738.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bFlnYVRwV0JCVzZKZHRpanJZOHpYeGw4QjI0OWpSb1hJVDMyelNBdk5zTHpF?=
 =?utf-8?B?eUQwOU9EMVVHaUpRYUJRZHlGNGh0aXRDRHM5c1pzb0VrcExKQnFxanRmUHVh?=
 =?utf-8?B?U1JVcUtJSWg3Q2R6UjhzTFhKaEszYjEzbVk4TW5zVHNSN1hsUVlHeThsekM0?=
 =?utf-8?B?d2ZPR0dpYjFnTXlNbVp4MWdSYXFWc2cvcWpOd28wc1hlNjM4aWc4dDZ6U2tN?=
 =?utf-8?B?N2lhdnlyN2JmVlpYWnBsNjZ0RXpxcmYwRDBPTFEzdHVNMFh3SE1NUVVIRFI1?=
 =?utf-8?B?U2Q1RFVodWpwUWVHajZmU1ltOGc1QS9hRmYyUUNaRFhIL0p6ZElzUkZGN3VQ?=
 =?utf-8?B?bTBhUXU5YmpncWhkTFFWRFhwQXdleGY5T2x2bzJIeHpuSEtxWWE0d2lub2Rr?=
 =?utf-8?B?UjdCb29jSlV4aERiS0NYUXhXVlRZa3NsajBsclFiRXRqNHhsZGFjN25SMUNE?=
 =?utf-8?B?TnpZOG1iY3B3Wnh4Tmd3OGtmV3JlRFpQbG5RVS9waWtmZGlxZXFZMmJML3BV?=
 =?utf-8?B?N2ZoUEplaSs2c3RpRG5MMUlwb0x4WTJpSm4yaTV2dGlldGtqcjZEWmVGN25r?=
 =?utf-8?B?TUdvaTYrZDNQb1BROWxZaWhQMk1RbUZpdUV1OUFBc244UWQxUSswODBaTHRZ?=
 =?utf-8?B?djN6MTJxUDlGWVBXZ2xiZmk2bXRsSnBtTkE0QThzRzVPQTNBTWMwaVFSdVJu?=
 =?utf-8?B?dWMrMFd0TGdMMEd3dzlwcFF0UDNrMWE5S28vaURZK3pFdEEwQjVyTlhNKzNl?=
 =?utf-8?B?d2hBZkZ2TWJXeGEzWERDRHhrQktHODF1VVpWQTMvS0NWdmxjQXZ6eTlMQlFX?=
 =?utf-8?B?K1pNMFhIME5zLzBIeklOQmJOT1NKNkhkdmROSyt3Nk5wd283WldyR3pFOGIw?=
 =?utf-8?B?NjFpZHdHaUFQZXFKSDM5YmNMZUJTYmpveWdGMlZoYVdiNGRrYkhUS3cyM3lk?=
 =?utf-8?B?SWpKdnpTNVExc25XSSsrQzdXTUpqd1N3VHFLMmZjS0g3SkpzaUhUMitTbEx2?=
 =?utf-8?B?VjBrK2VzaW15cDFrZGJndXhVTmdZYkZtODVGWXk1WE81WkdDL3g2TGlHcXcv?=
 =?utf-8?B?R1haTFp4V211UERsMmpRTU5PaFRFMGRYSzgzbFVoNDFxWWwrYW9VQ003Wmdo?=
 =?utf-8?B?T2NvQUk3WkJmdnZxY28zakZuaUU3aE5JZ0d6V0pYelJZd3BsQW93WGxGT2lw?=
 =?utf-8?B?dVhpSngzTGdBL1lXVFhkdENTR3RMWHRIcXI4c3BVUzJvTkFMYzIzUXZBTzV6?=
 =?utf-8?B?YWlzRk45VXRoQnBoSnhxMGdWQjljcERBR2hYZW9rUEE1NFk0ZFdLSm52TjRE?=
 =?utf-8?B?bjF5Y05SUkdMSlByQlNIMDhPWFZDdnZRTW1rZDF5UDhVMUxsZ0ljSzRFclBv?=
 =?utf-8?B?dEx5VmVvUzIxK1hnaHBrM0NSMHVGVUtmN1RsK1NhMlJUMFdKNjM5dnNPd2lQ?=
 =?utf-8?B?NWREaHh5aWVPUXF6N0tPTVJseDdHdXM1NWREekZBSHVjd0FQd3pOOVZSeUFI?=
 =?utf-8?B?UjlwZSt2UUs2WDRycHpXUFRCSWdVaXpQRG9lMFpOWmpVa2t4dmduOE1VWnZT?=
 =?utf-8?B?UXlOcVNKTUltVXVxOTBLbW92a3JrWFdnZU1XTkNvSG1MUUM4TThUTXdaTXh5?=
 =?utf-8?B?aXVKazF0bUZXRkl6aEV0cHQ3WmwxY2JuUjVSUTk1Nzd2L1pKNlB2U1A3clox?=
 =?utf-8?B?UFhrZXNTQm1HRXVrUjQrMTNkb1Exb0Z1S1VURFM4b3NURzJvWnc4V2UwUjNR?=
 =?utf-8?B?Qm43Nmw3WjE5cG4vUy9nZkNVWFNZNlZkUExuVzFlTUJ0T0F1SFN6dVZ2dHpS?=
 =?utf-8?B?bTFwenZBZ1FPbFkzWWhYcWphZHRyVmY4TjV5U09mT2tQemtJUlBobkRqQzdN?=
 =?utf-8?B?SmV0WDkyRW53VXRvKzl3QkNHTFE0K0tYZkFYZGtLZlJ6czA1V3NzeW56OHUv?=
 =?utf-8?B?K0RuZUpLTWhQTWEwUjRMT2d4VUt2K01ydytrM1g1MEc1K1d3MHlMdWhpcEJz?=
 =?utf-8?B?WFVxVTFnWUNMVFc3WFZmODF2VjI1SkpBbnZMS1YzSmRmanh2NjJxQVhjaCtY?=
 =?utf-8?B?bTRrUG4zSnNMdFkrZTJWZlI2OVpmcWtCZHI0eGczZnZSQUJwakVKVU0rNFh5?=
 =?utf-8?B?YTBrNXRhdEhVMkFZOVBtNXU3bE02QlR6U0tEcG9mVlVBNjl0NEtnTDh3YWN3?=
 =?utf-8?B?ZHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vYcVVqNjRh6IFq5WcrOz9npmYob8ntaX+hkurugulpn3W7JWRtB+we49OFtBUxCFneXVz3kNDFac1w0TXUsv0Y2AJYV/z1XfB6zXz9Lm421GMhNotMUEXYobxtQz1KEYXzb2n3ErJIdVC46fOkrcaOXmDxulckqbDvzDg9eJqtMx381vX0yYtimQ9/7YNOu6xcbQmdFQgWeUFprTRjf2Fw1PnhmJXu3BFSeUFbC7oXF5XM731RyrAnV1QO7871MvYfMLJKQS3WaItU0g1pCftkiUUEthCE8PAialfK7ej7Q/NYfNeMtN9xQV2Go63JR5kgV2EgoJhjr21pPVRj96kvLVUTY8s0zR+Bv/jkMVKRmluXHa5ZXAyCZ5bSVGL8zRQJ8e2mkthg9AI1j5hY2DeGfxcHfdrUapnhgt4ajmPn7h7NSk4aDU+OF22oYCFH3ErSS2srifPiNkGjaPjvNwN/CTAy9YK9RH6lhuk9gg17k5Jfdee3mL9NEe62Tc0rJQpn2Kg8nt0wigt9d54qxSGUBM82k+IVgA1E2iTm3KVwRr6nMz0d4B8p4dwNpuirAblnbGw8U1hnlTEkzHab6a7WvwRr9kwNHS9dt7eOJuBrs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca9ae1d8-dcf3-4b91-af7b-08dcbd347965
X-MS-Exchange-CrossTenant-AuthSource: MW5PR10MB5738.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 14:13:45.3808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oJbF+WFU1BbdMRR8CjVAUKqneZ0SEojYr8Y6lCscbPcNI7E4bKPBV8vHEk21vovj/ocK9caF77UQl/LX6CTcvu2+W5UAoRLoKjSlth9M0Ys=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7083
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-15_06,2024-08-15_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408150102
X-Proofpoint-GUID: sA8QXS_yKwiovx_IHdRmrJR5fOnLw-Mk
X-Proofpoint-ORIG-GUID: sA8QXS_yKwiovx_IHdRmrJR5fOnLw-Mk

On 8/15/24 8:25AM, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me know.

Please do not include this patch and its revert (62/67). This was not a 
good fix.

Thanks,
Shaggy

> 
> ------------------
> 
> From: Manas Ghandat <ghandatmanas@gmail.com>
> 
> [ Upstream commit cca974daeb6c43ea971f8ceff5a7080d7d49ee30 ]
> 
> Currently while joining the leaf in a buddy system there is shift out
> of bound error in calculation of BUDSIZE. Added the required check
> to the BUDSIZE and fixed the documentation as well.
> 
> Reported-by: syzbot+411debe54d318eaed386@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=411debe54d318eaed386
> Signed-off-by: Manas Ghandat <ghandatmanas@gmail.com>
> Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   fs/jfs/jfs_dmap.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
> index cb3cda1390adb..8eec84c651bfb 100644
> --- a/fs/jfs/jfs_dmap.c
> +++ b/fs/jfs/jfs_dmap.c
> @@ -2763,7 +2763,9 @@ static int dbBackSplit(dmtree_t *tp, int leafno, bool is_ctl)
>    *	leafno	- the number of the leaf to be updated.
>    *	newval	- the new value for the leaf.
>    *
> - * RETURN VALUES: none
> + * RETURN VALUES:
> + *  0		- success
> + *	-EIO	- i/o error
>    */
>   static int dbJoin(dmtree_t *tp, int leafno, int newval, bool is_ctl)
>   {
> @@ -2790,6 +2792,10 @@ static int dbJoin(dmtree_t *tp, int leafno, int newval, bool is_ctl)
>   		 * get the buddy size (number of words covered) of
>   		 * the new value.
>   		 */
> +
> +		if ((newval - tp->dmt_budmin) > BUDMIN)
> +			return -EIO;
> +
>   		budsz = BUDSIZE(newval, tp->dmt_budmin);
>   
>   		/* try to join.
