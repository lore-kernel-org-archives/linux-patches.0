Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC44B34FF4F;
	Wed, 15 Apr 2026 16:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776270108; cv=fail; b=ZqtkRo5ExRRbSQbGMUYGokc67tufuy62OS+rF+yW7fBl+9YmtMSNn/cdLtNM0bvpxXZZK6pANQJIhu8PBb6vG2c0n/3I36W6StkuPNW/7sQuNRK5e1LDd9fw9qdklAYTjTqAGbNYN/9Uq6RQwmQeC/6EGJDH6kU2GJZc1y9jBEQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776270108; c=relaxed/simple;
	bh=eJ60ErJJYWrO0qX6zX6AJueLybJ4abm0X5h9QbCohZk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=h8WE2J2EF8tt/T9ttvvNMLk2OIkLp3WaBcE+3vGQ2s/Vp9KEYmO2HKrb4yQyq+QsK0NWPG1jzqLUROG4rDhk4KhBoZUzNlLPZbkIebtROuzK4LX59QzHJufodzU0OyMLN56SJ5ut9hHsgqtlThHZLGPf/tws3icIpaflxH8nhgI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=C2AR/dtf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fSi91OVW; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C2AR/dtf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fSi91OVW"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63FCjLTG645600;
	Wed, 15 Apr 2026 16:21:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Rkd7kygK/v04zOnujtK+o7lSzwCJ/gM2uyZScv4j+V0=; b=
	C2AR/dtf3owv0WOrq/MUEamRT8ZCm+5YlzaWjmCwKY+MP/K5PAVCDcge4DE4lfBU
	r2UE/BecmHHyVYB6w1uiGxopNuPSmgPwV2LC9FCwc7uyWSe6tiBGrF1E2Ec5b5WM
	ojv6OzMsaSGZNlnK851+PoWdf8i7MjA1CSY89YdiG9MEtd5j8+F42l6s9WbBcu9a
	zj4sLpPTM/Z/SXKHqLiPYswQOT8eiQmlJ+3jrXUQpsByPWoT/RtytzWjz/p4A8aX
	/mVOzKtoNnfHHWWsDYDjZTQ/iEqSD1zfpeT0Wyp/aTUYGXU1gVbtlNjxwBCFPMnC
	9WXtaK34JVPd5phUK0YUow==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh87h5f8x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Apr 2026 16:21:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63FGJOn5005365;
	Wed, 15 Apr 2026 16:21:36 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012013.outbound.protection.outlook.com [52.101.53.13])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7nmup3j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Apr 2026 16:21:36 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iZaHa3k8qLzwOCHjFW3ugvKA1NZb8zAYnuFdXVpKV+yndsl/LrMavhM01SfF6U9EhDZcZvH+5cwx2GR7X+APTLu9NV60/3Q4GqLoC+hVB3uU9r0KwptbAPwQ2X/1Go9jwkQLXO4LnSZGY1wJAOE50JmgGW4BTkTH5BVjW8wX5XxXwkRh+9WDxvishg8Q9nLD6J8TVGhHdHREQ+512jZZ6e86R4RkRVpJSoykOsXWPf+IA1Id62lIsdGZ9zIa8e/k2a7uxZnqkkvJyQuOA2rRhJXzWos7trT7HtjAmNrIUaaBsY3lA3ClWjib5waln8Smnf1JMm+rQjao8jfR+uatdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rkd7kygK/v04zOnujtK+o7lSzwCJ/gM2uyZScv4j+V0=;
 b=Uly5U0zUB0LOWscSV8gZ4iplXYHhs7v9mGviUDl1EapSxBHRpdpaEVVBAuVllZFpoBAyFCoe/vcrrYEB2OOpk0AeKIGHVCVlTxmIfcdjkgr/EI8FyJ3wSHYB6bbUDnWF0cwUz9r5snBPfPmASQKOp3YxTWf38bQEVHYKuvtCD2Fp8ATAXm4VClgM6RYJL8mxwY7VjMEgCE7DMQ8fFoqUzBps+ErgL4vMtDo7HlgSKH1hoC4i3eMWL/iHnOHrw2zM+S+/5f1/FACG/4MiajVZYxcAz+oiA+uVCN4NRiBBFlAW3eauM5+3thD4HW2okiP/r6ugXd/LyTp7Ylgf0YBVOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rkd7kygK/v04zOnujtK+o7lSzwCJ/gM2uyZScv4j+V0=;
 b=fSi91OVWXIR7x8+OLkt3gPvmaPHXEhGBbPmmTu+ylCZ9VgT9pNa/YmwTL3fE1YGBC9KPoND6OdZzKZApf2nKepaXk+98C7j70go1Nqe4RPSC4WlNbIzQRvArTFrtZ3tK4i0h3RhDAXNIhvnhQuQScWg3z9jKZWYHl+y2QlmJ9/Q=
Received: from CY8PR10MB6874.namprd10.prod.outlook.com (2603:10b6:930:85::11)
 by DM3PPF2FC05F2F4.namprd10.prod.outlook.com (2603:10b6:f:fc00::c16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Wed, 15 Apr
 2026 16:21:27 +0000
Received: from CY8PR10MB6874.namprd10.prod.outlook.com
 ([fe80::6375:1659:6fb8:9660]) by CY8PR10MB6874.namprd10.prod.outlook.com
 ([fe80::6375:1659:6fb8:9660%3]) with mapi id 15.20.9769.046; Wed, 15 Apr 2026
 16:21:26 +0000
Message-ID: <0c9b5caf-131a-4f47-8d9c-0fac3029e59d@oracle.com>
Date: Wed, 15 Apr 2026 09:21:24 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 177/570] scsi: core: Fix error handling for
 scsi_alloc_sdev()
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev, John Garry <john.g.garry@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260413155830.386096114@linuxfoundation.org>
 <20260413155837.087422683@linuxfoundation.org>
 <ed7ab018-9a77-4e8f-8480-cdd92c4758c5@oracle.com>
Content-Language: en-US
From: junxiao.bi@oracle.com
In-Reply-To: <ed7ab018-9a77-4e8f-8480-cdd92c4758c5@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR17CA0032.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::45) To CY8PR10MB6874.namprd10.prod.outlook.com
 (2603:10b6:930:85::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB6874:EE_|DM3PPF2FC05F2F4:EE_
X-MS-Office365-Filtering-Correlation-Id: c82f610e-01ad-4070-7f1a-08de9b0b0b1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	HsO7URDnO+UiO8k3hXnUWxwx59n+RdgnzMjSVZZUgX9K8TkpklZPformZmKNOXU89QU8vyfUhL6GRGkFaiMAevW7iuAR8WdjteN7te881qTh0lAtkm4ZIQTvrrggPXB5RZ8idXVuWjlzvsMUj844KQ/PphfVVGfW2McbuNvo10U9rmhwRuyLccvUY70SYEoP7SfTzVSGwjaKjmOGc6etqNZKTVyh8ZfVkC0iq/l5+s7ZoNqtZ4SiMDw/NgNd/xdEjWnpcVuWIDjGu8QptuWhixglI4lW5LAONkfyx1x9oYtyCHMA8vKr2bjcGFSgP/AAKoeRIQguG2ocQVMTV9WGtfFjbC9J6Pr3gGxkqlpChyWH9+4PLgpzU2NDgey1bbplnWI7c6MZTmY5NGIVOmEomnQasmWhL2+6QxIEFUlWhxcWvmoPLXmR1OlHS04RVPSQ0lCDjoDurrPTER35P5pasVjEp4aAEbpQIPve81KRFX5AYoiLQboATirVuYJrZTRxszc7qdMzGyuizUguNGR+lXd1hcMcO2gwpRN2aJ+F2xLvzrb52LtxevnvyHumJV0s2amMhMvQCx3/PX73a1rtzpE2UgG3z/2NLrdgZFVBnfuv8wsoi7nukrxz42ME1WhoN4Y+NDNlEhZpL9z+EN5gqvwGr3h8VOayHATXKZaxXxyRJzOSBleMsT6j+0INNq6C
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB6874.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ditrRCtFTjVaNTN1ak5oSHY3RVlxQjhxQUhGOVRPelVFVkY1MFcydmxwQ1NW?=
 =?utf-8?B?YTd0R1FCaUZaQXYxNHd6dnBlaC8rQWEzOUFZSk5jVTNTY3M5ejdjTWllYnpQ?=
 =?utf-8?B?bzJUaEdEVVlPQWxhMHZGZWwwdWlQajZLM1FqajZpVVpRUElPRE9Bam1wa1VE?=
 =?utf-8?B?MnFDbFJBVHNMS3V0T0VjNkgySkt1QjlnV29JU2tRcUlaMS9jc2JnMGtkNEln?=
 =?utf-8?B?bVBhd3NuVEcrM3cxR2pYQ0NjaVIzU0JCeS8weGkxdWZFYzdLVzVSSC9vTUU1?=
 =?utf-8?B?S3ZGVW85dDZEOHBhMk1UUFNNd1dMc2tLSHRiTHV1MWd0UWN4VGVlYkRjbUgv?=
 =?utf-8?B?eDdaTXBFOERNeGord3NkNWdaNEJIUlVsRnVCNm9PR1gyRWc1SGo4dXdIRFpI?=
 =?utf-8?B?REtrQW94MlBqajRLV0ordWI2VHBJbCtHdXFTMGlIRGNaV2M4dnF4ZDZ6VWlK?=
 =?utf-8?B?VHh2dDRhOXJSRFV0VUFTZUpscDFHUzljYWE3d3FCazZIUC8rVlJ4dXNneUtC?=
 =?utf-8?B?K2taTVFHTmx4Uk1HZlRPWlNyN29UVld6SlZBd3JsR25tbjB3ZzVMaW0yZGRk?=
 =?utf-8?B?R2F5ZHVYQjlwK0R2dFowMURJOFMyL2kxRXdtVjNWTC9TSS9VNXJXV3JKOUxC?=
 =?utf-8?B?MDJIVDdFYTZRT3lHZGVJM0NKU2F5WGNxK2tFaG1CazFzc1JqbVdJemFES3Vy?=
 =?utf-8?B?QzkvWjNodTZxU2FDS2M5OXp4LzFNRjFpc0IzZVdaZlZDOGZvK1hvN0p2OVZ6?=
 =?utf-8?B?ODJCUDV6SHZ4Qm1LbW9SREI2K2Q4cjNtMzNkVExVYndDU3h5MVNCRmFZK1E0?=
 =?utf-8?B?NDYyelJMTStEMkRrU3gwN1JBcXhPMlY4QU9FbUJ3bzQrZCtpeU1qNzkzOWVE?=
 =?utf-8?B?ZEVaMEdSMy93YkJOMkpPZGk4d1h0dlhrU0lnSHRLK1NnSWw1UituSnlQWGdm?=
 =?utf-8?B?S1NaM1BzNlFqWWdjUUlmNzRTRHdGa3JOcXFLdStBZUlTbjFBSy9FQ0xEV2h6?=
 =?utf-8?B?TkRvSWlIc2daSVFiR09uMytEUVY4OFlGM0pFN1JFVjNPMDNFb01wNW1MVy9k?=
 =?utf-8?B?SCtRVTVkL0JhY2xhVngrYWwvUHhvMlpNUWM5ODYzaHU0Tm9meG1Cblk4dTF1?=
 =?utf-8?B?VkZid2pKR0pRVFhsWEx2VDlPTFdsSVFYbENnU0V6TGUxZ0w4aXZwR0lnWCtv?=
 =?utf-8?B?Y25MUnlBSWJrakJmNVZ3dUZkVmN2eFVndkhQMVJ4RUorUEJ6clNxNDRYTDlP?=
 =?utf-8?B?NEJkd1EyL1o4TnM3c0h0cVJzNkg3NmhLTG9vb3dXblBvd0EwSkhpUjE3KzNT?=
 =?utf-8?B?QUFUanROWXVMakhocGlGRDBmdXlmeHp4b09KbnhKdUoxY28raUd2eXQrU0t3?=
 =?utf-8?B?Mnp6NVdEMml6ZlB4VDY2Y3prUDZocExNbUdZa01ETk83SEEwWGRxWVI3VTRz?=
 =?utf-8?B?SEs3dEs0cmFyMUxBS1hVZjd6REU3TnBVNGlPTEVqVlN1NHVPN0FLcUdrM0Jp?=
 =?utf-8?B?TnhXQ0k1blZjTVFKeUY5eG5EdUJkUE55RVF0d2wyaThsWFhHSGNjMXZ5ZUFL?=
 =?utf-8?B?Qi9zaDhLbU1jYWNpSlVPdk9Yd2l4MW5FelZHcHhHSThYMUpRc0M1NGdvaUdl?=
 =?utf-8?B?SHRrbXRrcTQ0d0R4bXE0b1hLL2k0R3NGY205cEpRZEF4cG9yTFRtbmJSTjkr?=
 =?utf-8?B?VnBDb2tTRmkvYU5mN3ZMTDgzbmdiTkg2cXljSkJYMUh3VWxDMkk2aENTK052?=
 =?utf-8?B?TGx5SE9xbzlkSnIybVBLTnYvd09WN1NzVHpzb2U5YVdzbTVuM2sySEFwd0NW?=
 =?utf-8?B?aFdxVDhQRldVTmpvTUd1RWdaeTlWTTZOWUdwdHVRNkFTMExUbklDbDZTOHpp?=
 =?utf-8?B?NzVPdUNPV3oyellONUFWaXJ4cGx0QlEzNHByVUJGazJ5bUpnV2lvbktKcXI1?=
 =?utf-8?B?L0FlUTkwTTlOcFdFRlRFYTBwNWE4ZFFpcE1mRHE5ekl6TUJNeW9WdVRNTDc3?=
 =?utf-8?B?SmpyTjJ3ZldSbDljN29XMTcrbGovbm0zdTg1a3g2bm93Qi8rM3JFZ1AyblBx?=
 =?utf-8?B?RlBLQXJtdEtPUXl6Vkw3dEVhcDRKQTk0QTRWNXpoTTJZUTNXSktORkxaSC9x?=
 =?utf-8?B?UUxza0FFcVg5akI0UVBJV2dkaGtDZlY4VTU5VE9rdWFENVg5THI3WGJQWWMz?=
 =?utf-8?B?Rms5ZGFzSUJzMHJ1QWFZZy9zbysyL01CZlROVGkxek1CcmQ1VmpOOTlablkv?=
 =?utf-8?B?ZGRCUGt0WCtQc1p5bDRRano0YnlZd3NEOW5WcVB2Q2NkUmc2YjU3OWVUaXNJ?=
 =?utf-8?B?ZXdhUWd0VmhsaHhXdDZNZVkwVVJCS3lHa1ROQ3ZIVzk0WENSRTNkUT09?=
X-Exchange-RoutingPolicyChecked:
	oqLLY3rPR2PUtAKOuta2KxnUsggFXZPzXSyh3SZqHqbOJ0ByaldB0gVjxa9h0Xt/SnhLAffu/wPR5dFa1Nr97DV0mWeAsuBNsZZ1eKY5c9CH7UxpmK30T0rTAwGorxz21XxaPEbqDIPctOVvAwzSpHv85+dTV25vtPz9IqB5pxc95/9hr8Jc+cshffagH+fmsfS87gX+7r6ipI84dv2niPM7DLaQnCz9BW4Y3TpVAhd2XcV60BxA1q2jNmr/S7SE6HnEQJL+CSqfaUvHb3V5M8hLs5zc75GclSBsy0STtU6n/uLPHjSiu9g65XAC38dtAPI0+lBIG3gZChsw0VB+gg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XWjslc2z/hax3iYdxjs6cyF0ZIGaAXFxYXqrQbrsEBYJAZZduglJKZe139HE7CfcaYffPpRN7VfTvXHN1XV6/S0qDONUGUceulFoGHm2E2FCMOkGhnG48szhKfRaxsPW77ANWgdngeJYQ9c6anCgANZUF9tHgHD4SxFMb+QvMgSRE8hv4uoRQdRtuPhXW36mowcsUWzxm2GRFucTbBG+PsJtsNc1YWBRoSaYXUzfpnbDYbBdcktnGbM6DmvD+3cl66vUxlqmRC1I7mhkIt/f2xN9ONLCRa8YjwhNN37VKhGdYebBPQ2G6KQQiTrv6wA10kAyTC/86txk0iKHKv5uf7tuXsSD9gq+T+pznK/c2P0pHaEsGiRpwO0sk3EonsotAgKcV5F/10tmGgdpBy53rTLp67k808CLx4lk1MqXkYn4GNVz2CEtW9JxncobzEYuKFYfJUgqBiP0WObWi4afqSMiAa1udWaxX5EHX3dTD58ax5IzBbcqvy030m40vfdtjid/uYIKnlWcTn0ir28Zmv9qX/qSQ5taDsvSPwdBcJW2dpbQsjcFIveN8wk80274TMPp5yUZp88IoIpGIU/ake4UXkZu/m0GDufUBywV8SI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c82f610e-01ad-4070-7f1a-08de9b0b0b1e
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB6874.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2026 16:21:26.8394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xol5InUUxgOPiOl4Fp1t4D3upb9fdQwI1HL1+dbWiwdDCw3zGz8ZpjJyVBs03rNbf1TlTqlCp8UJax4ZRsJfhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF2FC05F2F4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-15_01,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 suspectscore=0 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604070000 definitions=main-2604150152
X-Authority-Analysis: v=2.4 cv=eJUjSnp1 c=1 sm=1 tr=0 ts=69dfbb10 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=bC-a23v3AAAA:8
 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=N54-gffFAAAA:8 a=ag1SF4gXAAAA:8
 a=HlUGFvfOPmyIh3X8J20A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE1MDE1MiBTYWx0ZWRfX8bnkJTBkufDH
 gn1oX+3QOd0iddGY8NpcZWffEEMyZzBuka2ctKygRtk+lc6C1ZtSafRRI9M3KgRfpjCyl50Yx3m
 rGDrLOqnkjEVlaj5ZXYItWFUdILqqXVx0EpZlyIrEWzB93WzUDRuqiTvXax3Tm6HSlpsLYnSwl3
 UhKRg5GRYmjBxXeBEuvoN3FkrvP1TWA1iURkLfYqjZ4QA6rTgopLukS06Dj8gLjg0s5QScYUuqS
 jjRLs6t9kIxCPMXq7RHxL3l082n0GbcxTCDZgMYAucC9vMXa1V8t/miqpEYOsMh5G7C3917g7Tx
 o2FHvn9XX3cQiY/MxIcb1tPyKzDDI+ZGaaaLBfFmiiNdcmdCvGIAeIYVBYmTERR4uQPThToCsvb
 lkvu+5mYixrrFXoPJBvBOGswlX3WbA3KHaAerMcPp0qe6y6rwKnSZTNNCrjCnzp0l3hVL/fnwMy
 FlRb3cmodx7mOS2OICA==
X-Proofpoint-ORIG-GUID: 1cZp3BS5enEbl66wVwhuQn31ntrPzDl9
X-Proofpoint-GUID: 1cZp3BS5enEbl66wVwhuQn31ntrPzDl9

On 4/14/26 9:07 AM, Harshit Mogalapalli wrote:

> Hi,
>
> On 13/04/26 21:25, Greg Kroah-Hartman wrote:
>> 5.15-stable review patch.  If anyone has any objections, please let 
>> me know.
>>
>> ------------------
>>
>> From: Junxiao Bi <junxiao.bi@oracle.com>
>>
>> commit 4ce7ada40c008fa21b7e52ab9d04e8746e2e9325 upstream.
>>
>> After scsi_sysfs_device_initialize() was called, error paths must call
>> __scsi_remove_device().
>>
>> Fixes: 1ac22c8eae81 ("scsi: core: Fix refcount leak for tagset_refcnt")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
>> Reviewed-by: John Garry <john.g.garry@oracle.com>
>> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
>> Link: 
>> https://patch.msgid.link/20260304164603.51528-1-junxiao.bi@oracle.com
>> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>   drivers/scsi/scsi_scan.c |    8 ++------
>>   1 file changed, 2 insertions(+), 6 deletions(-)
>>
>> --- a/drivers/scsi/scsi_scan.c
>> +++ b/drivers/scsi/scsi_scan.c
>> @@ -339,12 +339,8 @@ static struct scsi_device *scsi_alloc_sd
>>        * default device queue depth to figure out sbitmap shift
>>        * since we use this queue depth most of times.
>>        */
>> -    if (scsi_realloc_sdev_budget_map(sdev, depth)) {
>> -        kref_put(&sdev->host->tagset_refcnt, scsi_mq_free_tags);
>> -        put_device(&starget->dev);
>> -        kfree(sdev);
>> -        goto out;
>> -    }
>> +    if (scsi_realloc_sdev_budget_map(sdev, depth))
>> +        goto out_device_destroy;
>
> I have run an AI assisted backport review and it spotted an issue: I
> have taken a look and the issue is:
>
>
> 5.15.y doesn't have commit: 21008cabc5d9 ("scsi: core: Move two 
> statements") - v6.19-rc1 based so backporting this patch introduces 
> something like:
>
>   if (scsi_realloc_sdev_budget_map(sdev, depth))
>           goto out_device_destroy;
>
>   scsi_change_queue_depth(sdev, depth);
>   scsi_sysfs_device_initialize(sdev);
>
>   ...
>   out_device_destroy:
>           __scsi_remove_device(sdev);
>
>
> calling put_device() before  device_initialize(), so I think we should 
> drop this patch in stable branches which don't have commit: 
> 21008cabc5d9 ("scsi: core: Move two statements") in them. Upstream 
> moved scsi_sysfs_device_initialize() above the budget_map() call.
>
> Thoughts ?
>
Right, this commit should be backported as well. Otherwise we could see 
this warning.

"kobject: '%s' (%p): is not initialized, yet kobject_put() is being 
called.\n"

Thanks,

Junxiao.

> I see the same problem in other stable branches as well.
>
> Thanks,
> Harshit
>
>
>>       scsi_change_queue_depth(sdev, depth);
>>
>>
>>
>
