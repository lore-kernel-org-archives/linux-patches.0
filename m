Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28C936999D
	for <patches@lists.linux.dev>; Fri, 17 Oct 2025 15:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715180; cv=fail; b=TI1wE4IDAHE3KwTxvrgWfqWjXIXpsGWONwFp8aikF7fWVz7xBn/ZBiKQUcgLvIbsTmx0tAjoWI3QrvAKpYJ+nL2z0WGqeyq62hP2aS5L+2KnGTBIvOLuhAC1ngUgZMtxrm1fofbWwRXRaq7XM9vgKoYzqltgMS2JiIpYm5mIB/Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715180; c=relaxed/simple;
	bh=OsnCaD0b+7pJ2mfGiShncbOan3g2layPVc9r+esLa4E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GvFq3hPq7p03qx+1PEL8DTH4Mx0Y8nogILIrku5WTM1X/d5jTffT+SchH09Pif3SiSOfgVsFwUyl7JAbJugUQVT3s3GMI1zIM8IJYBA26Zi0bErpl3RYWXeiDSr337pZ4ozhC1YpsnJyCUIW2RS6m55op+/HS+4doX+MzPzQoaQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pq0wTyZD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tgl0x5/4; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pq0wTyZD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tgl0x5/4"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59HCdYJB018843;
	Fri, 17 Oct 2025 15:32:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Ppdn4SjD2Vg01AE98DMqkgzmM6rU8LNBoTi/MIDFDZI=; b=
	pq0wTyZDg2ZHgefM7hQAO6JACCRXchiwC4HUgjFgwHU0bi31AdeIYHhui8J9IbMC
	6xf9xxqpuJQChXdFhjsRCxMJk/aZ2qYC8TGk+8q3bm5LVf7547h+9oIkxRhWCNUs
	OpLx8bXFjy3psYuUPt9Ph3puHOgCCRkR7K+HTrznZH8+CclEn0ahQagdPvomcd4V
	fFS7FPdtUgWQAEZU7WGYheULPm3KdNmAqlWUQJmUjZ8rBkUhu4fN2GudsCblrV3M
	56a5+6lnfWX23g6rizxWYvIqM8C7s4YxzzYF1VeD0VTPGxxLQDtXtDyUw2cok4iQ
	6PI0KXVkeVQThSYdfjE30Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qfss349k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 15:32:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59HEFfDv000914;
	Fri, 17 Oct 2025 15:32:56 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011026.outbound.protection.outlook.com [52.101.52.26])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpd7s1n-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 15:32:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gRejl/RloyPGVsxewkMiJ/XS/MXAIlGUxwAnrEn6VqNzgjFbYM3XdBROMFiHskAKCDHNj5ugvhlbT983m9rPiQC2w3/pnp7YYVg1e1tSguMBQmRwDgFBdSx3wDOiEq6U6MqnlL/lFXHSsN61T8R2X0G2rkodFop9gm8UV9lEhSiH/vKP48O2Eg4oChk4y7TPNY2gmV10lPdYhW3eTpwEiRt+dDQ1SKFhAoEr47X8GE2tXuBoKfbLBlS+EXT1b790+jcL2u4Nd5hjmXSI22XAln5adYKnULNG7OlsbOmPJCRUsmLPhht1/4rskT/wpoMx4KL18oV+RrudK49xGWrKkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ppdn4SjD2Vg01AE98DMqkgzmM6rU8LNBoTi/MIDFDZI=;
 b=nuGUKTbtpcRecnW02B0cCaRnnXvwr3+i4vaMx9gZ3aXJOY6v5n0w50xGoQDT0yGbfu+hLmg68DyGIJv3YlBoAj/Ia+8OFrgH3LZ4+VsqfolzP+OUCnjVqV/X6Rz+4voutd9amd8Ww7gaXoGQWD6+mDb9zNuuLctsm/yEF73KUKj2Rk9SMwMOd3mAiJtmcZbH6fEM+11EPFJQIS7Xd6xLj6L7DwaL6bZLDOcpq4VP2Us1lk/SPUh45zIjONGJK7f9+1NJ2Wba/Nbj/by4teoo86RPkGIoq9W9GualdAweC9TJbJZvFpWsOIlOM0eFDWIOPnsOduVbJP2lrauRSD4+yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ppdn4SjD2Vg01AE98DMqkgzmM6rU8LNBoTi/MIDFDZI=;
 b=tgl0x5/4NsMycnGqox+XVbOZJHZMagtpUzc81VErw0zNwQWsDVE7qE3T8DnRjj1Es/qJpBuzOPiUxYEtiPn95izLZiMeL/ktum3ejRrDPMHrQpj6FHjZriXALFt3Mf0skOBGq2vYrsYcQ/d5tQ0D5qR+BuPtXFzTLaXDBBncfjw=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by BLAPR10MB5156.namprd10.prod.outlook.com (2603:10b6:208:321::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.12; Fri, 17 Oct
 2025 15:32:51 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90%4]) with mapi id 15.20.9228.012; Fri, 17 Oct 2025
 15:32:51 +0000
Message-ID: <dbed118e-fbb1-4fed-adf2-cc6213aa93a9@oracle.com>
Date: Fri, 17 Oct 2025 11:32:49 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 276/277] nfsd: fix access checking for NLM under
 XPRTSEC policies
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Olga Kornievskaia <okorniev@redhat.com>,
        NeilBrown <neil@brown.name>, Jeff Layton <jlayton@kernel.org>
References: <20251017145147.138822285@linuxfoundation.org>
 <20251017145157.237029632@linuxfoundation.org>
Content-Language: en-US
From: Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <20251017145157.237029632@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0P223CA0025.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:116::23) To BN0PR10MB5128.namprd10.prod.outlook.com
 (2603:10b6:408:117::24)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5128:EE_|BLAPR10MB5156:EE_
X-MS-Office365-Filtering-Correlation-Id: 1128eb83-f89d-4140-14f0-08de0d926f07
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?RS9JVmRzbFFXdC9kempkaGZxcFRmdXdXYUtDOWZFdnBRbjRrQXhDcWZGRXlS?=
 =?utf-8?B?U2FOcm9ScmNXTWwzRzQ5VmtrbUFZd0NRdjA0WmhVUDI3Y0MxWU1jaDMxNDYv?=
 =?utf-8?B?TG1UeVhhN0ZwQWRGNHJTUHdkM0c3dWtsSVpuOElFWlpMQTdBeDRGRU81YjZW?=
 =?utf-8?B?RlBMWlA5bzNpcmFEdGpqbnIvT3NBTVRrbHQ2V1I5RFoyR1dMbjFQL2kyanBa?=
 =?utf-8?B?VmxkOVE0d0UrRDZWcGlJNndXNFBpcHZJRkRFdXRRbFNXaTlRSFVPb0JBVnNn?=
 =?utf-8?B?cVJqa0xKd1A2Qjhrd2k2c0xnU2o0dFFZV05OSW1YU1g4V3RtRlYrRnFXbThF?=
 =?utf-8?B?SmNKV2gyQ003VjlwNTlQZzVKK0N6NW5UQ3lLaTJyL1Z1aFZZSDFlNXVSdEpx?=
 =?utf-8?B?U2o2OHV0UjdlWHFjaTg2QitsL2hzS0FwWG1oNmZLYVV4dm9uTitFSUZHSUhN?=
 =?utf-8?B?TVBLcXlabmpxU0YwblRPRnlMeXlMc0l2Kzh3MExQTnhwK2lpRDlEVzlyb3NQ?=
 =?utf-8?B?OW9ZOUUxN0VVRzM5ZUpiRUh3U2JOMEtqRmZob08wRGViNk92dkdLbTNJaVNl?=
 =?utf-8?B?THBoY25BUFVtQjV0ZDhPQzZBVTJnU2tDWDVKaVRmdmtxTEFMNnpHQ2QrL3Q1?=
 =?utf-8?B?V2ZFK0JFN2dOdDdiZ2pkeG5FenVHY0IrQ1VhQUNEVzNzS0ZVV2FRRUV0NWRw?=
 =?utf-8?B?dTRzVVM4aVlSVjgyU1BlN0JxaGRtQzlPUkVmN0ZWVGdQMGdTbnRub0UrYTlX?=
 =?utf-8?B?ZE9vNDNIVC8yVjdoYjc2cHJUVGc4dUx2emsxMm9vWm1iZExzTitnVmhRSURi?=
 =?utf-8?B?TmtoK3hRdFdNbk5tTUZ6YlRXRmsrQjhLcjVkcC8zN0I0bDFnaGtRWWNUYUNm?=
 =?utf-8?B?UDBGbFFtRFQ5WjBGRjBRVTVPZTF6QnA4aHRIVDFLVk5EQ1EvaE9QL1FxdldM?=
 =?utf-8?B?RnVIeGhwUFhHa1hEdm5nWXRGVVE2dkFQNXRWZ1h6WXpYamFvSWQ4WGJBclEy?=
 =?utf-8?B?OTNIQmwvRDdYcVczcWlJbDhPeXZpRkFiT2VmVTlPWjVRV0NvUVFqT2l2bGlx?=
 =?utf-8?B?d2tseDJuWVc5QlM1VGxublgvb0tZSStWK0QyYXZiSzBQR0JwckxuVERoT2Jt?=
 =?utf-8?B?aTlOTUVvZExlRlRMREZqeWdkdWQ0cmRUb2NRU1BRd3EvblZPdVhoUkZ0RG1a?=
 =?utf-8?B?VS80YkNXaldIMFA1ZWdXSml4TW1ZZ3J3TnhFdWF3L095WWQzR0NScmdhY0oz?=
 =?utf-8?B?YnY1MjdYVW1IbWRBN2FCUjNranpRR3RaTlVTOUJTeUMvZlBvd2xpejVjK01S?=
 =?utf-8?B?dUtPNlhMOVdhMnRLckZOVWRXNTM1b1E5M2pHdko2VkFJU3VWUmxaZkRid1lo?=
 =?utf-8?B?K0dBTzhCbCtoNWVUaTFWb2hvNU5IaXpYZE14WjZGVTJxcFpMN21jMmJIeGla?=
 =?utf-8?B?cE1IVnZ0MmFkWXFJKzVsUXpFMXJsU1llNVExZ3R6NGNSNU5KN1ZneGE2N2Ru?=
 =?utf-8?B?YlI2cnNlaXRiaU1ZOWxVc3lublFrUWQwZDQ3T0IvR0dERVZXWEpkb3ByMmRT?=
 =?utf-8?B?VE9xTFF3RU5GRFR4TTdpK0xrWkNLRENhMndqKzd6Uk9uRWNqYVlaNXFGOWRH?=
 =?utf-8?B?dURpUGw4YzBiWTlJNTNtemNhSHFNdHlka0ZJOGFKUENlWWNPM2x0cWJqVWlS?=
 =?utf-8?B?ZytQcEhPeGJmVjJ6MjlqUkI4VTMzK095Y05QYzNTZDR4VVZ4ZWF6b1ZzQW9y?=
 =?utf-8?B?YzBaV1dhZVdvcXhNcmpLTDRjekc3RVBCVkUrQ1liNHFGZVVNRk9PWFR0YmM1?=
 =?utf-8?B?ZEV4dmZubTdaRVc3R0V2SUoySVdxYnhNaWUxeXRGK01hRnBXbWI2RlFvNC9I?=
 =?utf-8?B?RXZ6WkNKclVhaHgxQXlGM1N1U1pPZDNrL2lHaWNyempWalRNK1E2b295aEpq?=
 =?utf-8?Q?wH0Xo55sGZv3UL3Y3lLRIMe8/VSuO8OW?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?UVQ0ek5URzZUbHRQNHc2QUNDanFucDhWVFVtMm5YRkRNcjhFUWdzVkNVM2Q0?=
 =?utf-8?B?UUx1NXZrTFhIV1p5dXRCZS8zUllocDUxQjY5R3o5S2hhbVM2bm5nWVVYQ3Rx?=
 =?utf-8?B?NHZmUXNNZ245YlBMRmhuSHNhNEE4cGFmSkJSOTkxaUJXY3ZyeTBEZjhnVG44?=
 =?utf-8?B?emJWNzFZT2FJVEgvZUdsMythU1hmRHZpSkFabU9xY2tNbHNReVZNYXpCcGhP?=
 =?utf-8?B?V0MxT1N3anV4ajMzb3ZqVXBQK1RqTUEvY1pzaGZYR3E3cC9idFRKVlhxUGZv?=
 =?utf-8?B?L1lrQXU4NmloV3hVZWtHNnBqVEZmRE02ZVdrcDZZYjJwUFMxUngwRGpvZ0hV?=
 =?utf-8?B?TlRFc3pJQ2xweGJEWUNaVGFHbDVwU2YyNENVSndaSDcrQzdVME5rc1hNT1Rr?=
 =?utf-8?B?WndoWmVKbTg2UzVTRi9xM3UyM05McnpiZUJxZ1kwUzVGMS80dkNFam5mQ0FB?=
 =?utf-8?B?WFlrWE5ZUDZHczA0KzZ2dlg3eDFRVFFldm9LQVdNT1NUOVNacU5lUkYrdUdr?=
 =?utf-8?B?K2Q5RFJiYi84d3lzYUpHb1h2eGJRbTRmbVRXOXpoVTNxR3JQQy9ubkduTjFp?=
 =?utf-8?B?SGpBTWgzOEJlOXY3NWFjdk92bGUybk9tcEVLK3VEQlZiK0JlZFA1NnBHa0VC?=
 =?utf-8?B?VXJJUGRHRWVJaUxvbEsrQ0pHc2JyNUUwWUx6SHZ4eHNTVzdxV29VZ3hVOHo0?=
 =?utf-8?B?MmxzUWhiT1FDNzJNK2RRSWxucVNaRkNlVWVQMXZhRHJ5QWtoNGU1aWxFQnJY?=
 =?utf-8?B?WkJKbHVWZFVkdytmNXlZOTBoTEFwQmhidXl1ZmtUQmVFVUNtMkJJNDdpY2Yy?=
 =?utf-8?B?d1dDWkJWMTFhNUdTNGcxa2k1b0Z1eStodGlXTE4wN3lLSEl4eitBUlFmdFVX?=
 =?utf-8?B?TG51MDZ3SEY5L0hBVmpseGRWTWZRMmN0WnlLZ0VJTTkvaE0rbklQWmxmWm9U?=
 =?utf-8?B?bm53TFYxOGtpdGZndDFCcm9YSThGMEVYNE9SUm1QZUppYXFDSDhCWXhqKzYv?=
 =?utf-8?B?OFNEZkcvY21zQ3pOZzRuZDR6ZTdWZkRzbEJabm5zam82eTI3ZUxEVUl1eDdB?=
 =?utf-8?B?Y2xIZ1FwYnpkWEFhVDI3ZXJ5R1lVcXJHYXdlU0NpRzJEMVpTN0M0bFJuZGlT?=
 =?utf-8?B?M2x2SWJMa3dPK2xKVlpiWklmN3dnSWJsditPV0gxalZzTWpUZjZGRjNPaUEw?=
 =?utf-8?B?YVVPR0s4SGZJby9LMldOQ2FCeEhoNEZpMGVJZllYalZGR1BYd25sdHpRdFM5?=
 =?utf-8?B?M0ZyclZtTWIzKzk5L052QmlWR0hvRi9STi9BVXBsckcwbkx4RFFDNG1zOHFB?=
 =?utf-8?B?V2x6RW1OMHhYTFRSVWovWkVvUnE4REVjY3ZvbkptcksyQjQ5THZxZXVXMmxU?=
 =?utf-8?B?QXQraSswOXFWYXNtZ1RGdWplUEoxaVloSXpNUGNvY3pZWDNoSjZlRHZkWjR0?=
 =?utf-8?B?MjZBT0k3Qzdncm1OZjdrdlhxN1dFeCsrbFFiVHl5UzAvZC9qMDVBQ2tQLzhR?=
 =?utf-8?B?TkdaYVR6d1d6Vk9rd2VZcCsxS3J2R01BTFYvSTQwd1R2VGE3TGFFOHVSbEtY?=
 =?utf-8?B?eEhMK3hPcEpSZlZ6K2VZNnYrODV6S3J5ZE9JaTh1Y1VIMWZFN0hBdFNoVWpR?=
 =?utf-8?B?MDg3dXM0cXBZMFI1ZHhHNHpRckEyNG11anBKMFRNRnJ4OWNCTU9pTUVXMStC?=
 =?utf-8?B?NGlLUExhR0c1ckFLZ0NBTm5VV3JiVktvbU9QaHhOYk4yV1ZGNXBxV2hHdXFa?=
 =?utf-8?B?YUREaU16ZHVWTjlhN1g4MFZ2RTYxRWplb0I2WWRJOVZRTHgvaFNpSFZRNlU3?=
 =?utf-8?B?c2VMSzNuT1NGTFVrb0drZGNVR2E4d1ZQWTdzNjJ5MXVIVlIzVWRyK01majgx?=
 =?utf-8?B?MHB3VS8xY0t1WW9XZ0RGSnlhWGQreHdSQlJnUmM1MzI1OVl5dE8zUk5HQUg5?=
 =?utf-8?B?UFoxQTdLVHZtZktJU0lNSmxDMTRIeXphT01LKzgzUnpreDNmc2VxWVhwbXJT?=
 =?utf-8?B?djd6OVZQNFovVkpGOG12N3pUU3p1TGpkeDVTRWE3YWpubGU3L1ppRUpReXhr?=
 =?utf-8?B?NlBtY3NqdWtvalhTeWk0ZmF0dUk4K2NqT3NTR2dxUDhxRGpheWR2bVRCYSs0?=
 =?utf-8?Q?dkJJeH9y47h4A702TPz21INv2?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sURuVcCVJcHh3vi/5n1KK6P0Uh+1Y/3PssY5ydl+2SCCjjTpjTHF+qbNzO4rr/O2xY/8GpF21enTkQRrqQBwZdF1D4h0keh1mIokLX8CU+ZiXluj0casA9VFJ1wwhYFidSQGNeA7VS1vlBaKjQ7SBUJfbyRwy/Ex0Q2Jo/e6yJ7vz9CEGu7IPfos/sl5PVNa7KxTfzdE7oDUXZu/UK7T1yJaOUytoeImvNZI7rKxJf+ZitYZKx8SA2qT82tyTQ4vlbaKgMirMo6Svoaa8K+9+Q82ZvXLjH7/7htOO8QCORjASkBkJdkhaz0aRAhuJtETqV25m8bPVh6RFwPvj8OTE7DypXVM40X0QXEezt0NspC0ztzdgVb0TbH3AjWSlzi0D0/akoU/a2I62D3WRFFz46WaftJXCTEzShdfxYFqslLPwkhlfQt+TP4AUhsvCeGuQdNo1lC8ldrssb4XQoW+W4gD/7g4nXzU26S0w/J1u2BJp3ckoDODiVEjeACUsNkyXKMbzUq8aIEOPLiOUFMSI31NHB99HYsvKjiGTeUV79UFd7EYApmXV1ro0vgNAJiRx88f3UimM2COPwmloAClFcA1+7nRMB8YfYPPLnY3ZUM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1128eb83-f89d-4140-14f0-08de0d926f07
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 15:32:51.3750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qRAZOCuV/yqXa5SjRhk/CzRr6DqjfF7QkjOSQNdrcxWZpoQ43eJ8rGchsA3v31lsszK6Ia9gEoplhx2/ppBQGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5156
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-17_05,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510170115
X-Proofpoint-GUID: xXb28N_N56p69K2_xDRQqUteMmUjmhTK
X-Authority-Analysis: v=2.4 cv=APfYzRIR c=1 sm=1 tr=0 ts=68f261a8 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=ag1SF4gXAAAA:8
 a=vICrMM_3YePmwVakAdkA:9 a=QEXdDO2ut3YA:10 a=Yupwre4RP9_Eg_Bd0iYG:22
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAyMSBTYWx0ZWRfX3QDQ14brXYir
 jSwnFOwtzTyXYCKgcdDS4v3g8YTaQpAo37SzeBmY7vuTdUQ818D1q8qKwOSPo0RbfmUahPngw+o
 UNkGc+6Q6Qpr8jjIOegg7dbkezG/245g6qdqNr2F1K6T7DxQajyGSEK71SDAvzQTFQFi1O/nB/G
 Lv+MaUOlgWMUGWQLJt/G8pXHVQuEC0rc8DC8QJlYNtueaRDYDbTCdCsmSLpGVKTgQNm2MS7k8uT
 PkolZNM5Wj4x5oscoN0RyZhRd5xNQGAEUXL4mHTB5j5sDCfDefWxjFTiYdNZzekvdRrKjR+jduO
 TKCCVWX+xX5tmb9qkBxcir7cBonJwpsRONYYWCQyskWm48lyxG6SMdZRfBdX4lFTJ30b6Rxfyj2
 X0qgiqpUaxwz8GCFdmm657i6egzETQ==
X-Proofpoint-ORIG-GUID: xXb28N_N56p69K2_xDRQqUteMmUjmhTK

On 10/17/25 10:54 AM, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.

No objection, but a question:

This set of patches seems to be a pre-requisite for  "nfsd: decouple the
xprtsec policy check from check_nfsd_access()", which FAILED to apply to
v6.12 yesterday. Are you planning to apply that one next to v6.12?


> ------------------
> 
> From: Olga Kornievskaia <okorniev@redhat.com>
> 
> commit 0813c5f01249dbc32ccbc68d27a24fde5bf2901c upstream.
> 
> When an export policy with xprtsec policy is set with "tls"
> and/or "mtls", but an NFS client is doing a v3 xprtsec=tls
> mount, then NLM locking calls fail with an error because
> there is currently no support for NLM with TLS.
> 
> Until such support is added, allow NLM calls under TLS-secured
> policy.
> 
> Fixes: 4cc9b9f2bf4d ("nfsd: refine and rename NFSD_MAY_LOCK")
> Cc: stable@vger.kernel.org
> Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
> Reviewed-by: NeilBrown <neil@brown.name>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  fs/nfsd/export.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- a/fs/nfsd/export.c
> +++ b/fs/nfsd/export.c
> @@ -1115,7 +1115,8 @@ __be32 check_nfsd_access(struct svc_expo
>  		    test_bit(XPT_PEER_AUTH, &xprt->xpt_flags))
>  			goto ok;
>  	}
> -	goto denied;
> +	if (!may_bypass_gss)
> +		goto denied;
>  
>  ok:
>  	/* legacy gss-only clients are always OK: */
> 
> 


-- 
Chuck Lever
