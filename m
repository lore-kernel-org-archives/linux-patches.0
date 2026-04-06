Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B982D97A6;
	Mon,  6 Apr 2026 12:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775478515; cv=fail; b=aj/ePetkPi5XzFax+18Her08iWxXeYwkfAxYkrt+HcdHIeusNX8TZI1AamMXnaeZKXFNmXkLH2Ri6/L2aIYMvaox2HaP30irKFm2fg1ilL25/WUBjlo4jHvkruql1VmSa5IKf2rEwiQ5OQD7r00GwuFbPGAn7wmjX/YrX8By8TY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775478515; c=relaxed/simple;
	bh=ZOBCXXDbQXScmd9ZGjF0PcblXiZpyNN7rWAU+krSeRQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=c/ld/H75JByafSW5fCFmixzNIkoOs+rseKG34mpbnU0MWDvD0lvmQe+BP7p5YVJ29Nlte4v/HpRpSshjIWjsCuqTrCg4NCj9ZIemG9egsKlGoJLFifZ0gyQyIoF/XQxlzjyTSRJYPckCHuPN8n8yN4qTBakorspDpy5nJ1u6nHM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aR+7BghB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vW3JMdO5; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aR+7BghB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vW3JMdO5"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6360F15M1854119;
	Mon, 6 Apr 2026 12:27:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=u/MdhQlSRkd/2BLE1ob0UlbtiCZO6DY6cImdwfFf7Ho=; b=
	aR+7BghByWE243UADnIkkvEwKZWq1lLVsmhLfztnO0Lwqg/XXnFMsUOT1RvyQbL0
	zJ1csf4xd30FNPum5SC6QWKwujKIwQ6dZo+WBHgxvwimZ8UCJcSrdHlZALG836L6
	QI6FuBBI1E89mEqfwCrK1oWYYRKrKnXMwBo3A7eB2N1sEcmmzYu4z77rxKpwbQkP
	iqBexdEMtlxKfAfhFf4czcLVlZORkQ1E+rhwWupT37VlFLFGX0ciRA/Z4kbvW5X0
	aVS6k7jnjJ7fkwip7LCakk0+x5b96Y/JhKa+1350WEwbX6BjTy6tL3VW9EyImGOY
	5qVz/aaHl+ctghBrCaRKoA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dath5tjf9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Apr 2026 12:27:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 636CAqDL040287;
	Mon, 6 Apr 2026 12:27:54 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012003.outbound.protection.outlook.com [40.107.209.3])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4das38ewva-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Apr 2026 12:27:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cAEwhGvpS1F9pFMwXeTbs+OL1+P6nB6XINLR6OaeSqXd710yej/NGflLM9+anpPFVEb7ayByrHDKKvS5zeXSNu3gbM8K/XcNxfDWd0aI31gq4rMpepl7qED5yBXqAjY4VezfqlUEsnkGFdC/QXFamG/I0B8Mdugk4avnlmWg3pgdfPSy6KxYQQvV2YrP98+8q5czYFwo3xBemR4g7jmHN+Z+Q2BwjVub6hJ/48hI2jP9H8s0TxwR4WT7z4QdWSTV5D8njx9KGDdvaKc5xSm8MkzyLff2RuYI0+eyxMYDmQljWF+PqTDYcWJbc/PSf0NJk+856HuNo9kVZyefPe++IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u/MdhQlSRkd/2BLE1ob0UlbtiCZO6DY6cImdwfFf7Ho=;
 b=tupl5lSv/5J0PRn0/UM5IxUx/cx0DUyOQi4KQeBReNCnZVn6qdJwDmo1SgAuCOVB8PEJAuI46o3gKjUoTffPQXX0P2NUHFG74rIZ6zHX5ol48nl7HLeYhQkI45B2bYAnaiHA9n5vxZtQnpAJi2iYVC4icayRGD6iQnzKcPgi/PXtA7xMj5hMAT+fRGhHe770iny7gh3M/p00013vxQYOL23ZN9Ki+PpGWaGe/9XvH7wNukukjoZeVGQ1YThe3rX3J8NCpwdkZYhlh9ebr1Efd2xGb7pATVP+fFuwoO2kah6g18f7IglbJ2HPVLFqr5uPRYwoNTfNm24SILXRQRYnDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u/MdhQlSRkd/2BLE1ob0UlbtiCZO6DY6cImdwfFf7Ho=;
 b=vW3JMdO5iBln1DfaqRX7YOCKP0vYyCrJtVIPR+lqm0I+Cc+BNq6jdzvUy9lEyoXbrSD/gK8f9onS5DdGz03fgIY1DTNaboydmMjo4YMPDCXqgWlJ3J9Ve9EJ5Ysq4rYEVhLLBRsDeyuupVtROm8R5C7SJTP2tC0kcyoegBSb+N8=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by DM4PR10MB6813.namprd10.prod.outlook.com (2603:10b6:8:10b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.19; Mon, 6 Apr
 2026 12:27:46 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.20.9769.018; Mon, 6 Apr 2026
 12:27:46 +0000
Message-ID: <28a3e1fc-b6e7-4d92-b949-7218a74b7231@oracle.com>
Date: Mon, 6 Apr 2026 17:57:32 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 118/265] LoongArch/orc: Use RCU in all users of
 __module_address().
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, WANG Xuerui <kernel@xen0n.name>,
        loongarch@lists.linux.dev,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Petr Pavlu <petr.pavlu@suse.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260312201018.128816016@linuxfoundation.org>
 <20260312201022.504112831@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260312201022.504112831@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0073.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:26b::9) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|DM4PR10MB6813:EE_
X-MS-Office365-Filtering-Correlation-Id: e956972a-496b-40ad-30c4-08de93d7e8a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	UvkGxPSsVe2rk3ZwFUnq2MXoBYDDBCN62A0BM3aJ8Xr1xpQkZd0pQ0jouOfM7ppIyz/IiOPcJh8GeBlgIhpKP5yGLIXWIJwU1bFqsj6j+a1fo6GSeIPxLXPqm2RD3aOa+dtFiVjqIZujR31a9vP8VYeZFIjQjZUaz28SuaZ7q6tWGUkU1JzK4pE9/HnPMcdnC3C1iNPrMn3BB4ZdtDm7dLPZWDKC+cModMND9x77Wr9fZ/nRWWvPybqX6z9b5jLg1xAQJBJ5tYnUl3p9i9B298r7m0GRtbnC9y8b7b6+AAf47P3UPP3LkGyT+JPWdVwwmBBgvLY/ALcwcYwuYRm/7rs95wcw81pzBOpsHeWg4rNY3sCl1pgGzsNFy8CaScQRoTm5O9HQA1a9juSVhFKt0LZc8oflLoURV469tTUcBG4sVM4NZxcNdzBK8P2Ue+WnCQpD+p8GT6QER8nBQM1NbpG9hZgopxnI8lrnh0UjJvo/PquY9Lde1GyVVrb1GuNL3FCWfOp8cwIWGZ/Q+aI9tmynnmjlkDxH8wngmKH3TEBfujBfRc8qit2P7KqQqeBfR1Jy8oGX8FSr1x3dwMfvLhlj+7seoH1B1gjnyGfBtlaVaV4SY1ZHJFoBunfpX1I0u6Au2HxdyX62zQJk2F3tUbE3KoV8bLKr10POL9ONzTw96fFgoEE8iuKsYKUnSMD2KWC30xlRLXOhYpu9/7gmJSDbqL/UkjiHoVFauBc5sx5JcIlRrBxNobW/xvauiho+
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SjY1NDVxWjJraVAveUtKUkhUSmxrQjI0LzB2YTI0YzJPYkIvVWZIRGxhRERR?=
 =?utf-8?B?L0dPOWt5SE5YaGkrOWNXRkp2eXBIUGN5SmU3WW5wNVhrOEcrWkREdFhyRG9t?=
 =?utf-8?B?Z3lWTXpWY09uN3dCUndqZUlpS1RDQlFNbEZXTXJyamhtaC95dXRVTEk3V09W?=
 =?utf-8?B?ZHJCbTg1M1QrL3hUZlFwbElwWDJHdU41Z202blV5MHFKcTdPVEtpY05IUGtV?=
 =?utf-8?B?NElrVDA0L09mOUN2QlN6ZDNuMHkzRHV6YmxCRmNSOEh5UWZvaHdZNVljdnh1?=
 =?utf-8?B?eVJpWk9DYVZ4TVF0ZU5MZ1VaYjNxTkQ4dFBvS2NvOTlCMzFqVzdqVC9kVHI1?=
 =?utf-8?B?eGZYekZJSXlxeGdldis0amoxVU5WMmt4V0RBamZvQWdnSzlaWTgyUWtiL3pH?=
 =?utf-8?B?OHZRcWlNWWNaU1RTcmVHNVJEcXpDaTBCVXJ2ZExlUEdNU21YK2hJYkR6UWVp?=
 =?utf-8?B?SmVuVlFHWUdhOHduNnhtYXd6Y1NRUjFTamFwTmFLVXFOWWJaVUs2UUl4dlM4?=
 =?utf-8?B?NklDa05FRUY2MStvT2Q5N1JTN1orbjZSQisrYVA4Y09raXpTcUxTM3JnQlI1?=
 =?utf-8?B?Qk5Nb3Q4dVRmZ1RYYkZWTjY5cHpHL3lSRDA5dExqL3hFTmZMc3l2UDhZWnBu?=
 =?utf-8?B?OWNlZE9vZkpibWlzTTJBYklMS0ZLNDVPWS9lazdqZ0J1YmZpcUlRTnBrSFJm?=
 =?utf-8?B?QW1BUlFrdFhUOXZ3b2ZVMDdRNHBtaWNFeXdNWFJHWjBwbG9hZllVdk1OMmtm?=
 =?utf-8?B?bWpMV0c0cHJJb2hReGlvVnVPMGVTeExYUkVkeTZnM08rVDV4NmQ5TWI1ZFNS?=
 =?utf-8?B?ODV2ZjB0ZjVGV3pzbVJVT01Gd3hucjZ4NE8reXZMeC9NRTFBalBmUFUzOEpk?=
 =?utf-8?B?N0J0Tm0rVThDQXcySkhBbXowVDhrNE9SbmtqUjFHS3VEQ2lDOWFaUURoM2Yz?=
 =?utf-8?B?ajl1c0Y3NStCb1QvNEJWQmdtcUZ5WDFWMHYrUlAvSmUxTkVPbE11cUgrZzl6?=
 =?utf-8?B?RzUvQzhnZmZEMW8vbUlnVG9md3gyd2hDcmZpcXBvNnJDVkM1MHNEd0Y1c09M?=
 =?utf-8?B?RTR6N0tPemQ1S2dPbmFTOFc3T3Y5VDM1d2dmUmRMYWl0MXp3WGxWckxqRFZE?=
 =?utf-8?B?bmxNVUlXQm5TMnNEMm5EQW9PL0lDRWp3OTFTdHZ1Tm9QbXlOWXZCNkU3RHV1?=
 =?utf-8?B?V2JNbGhEeW1WRXBLZGNjYjB1V0ZRNStIVzlsZWJqMTR5MUZicHEwTnpuY2JF?=
 =?utf-8?B?SHkzOXg0dmZzZjdOYWgrODZ4cHVZYmtYd1lUbDJ0alhWZnJJbVhubVRuL05x?=
 =?utf-8?B?UEdZZnhnWWE5SkpHN3JNaUVGVVhoSE52SDc3THdhMFZadERXTlBhdVdYQlRW?=
 =?utf-8?B?ZnJNNno0SUpwZno2TGtYaGxKWlJTN25hOVdpSmpZK2EyZ0llcXlpRnpmY1NK?=
 =?utf-8?B?dFh6TXM3ZXpGRFMyWWNVKzZ6WFM2VG9wMjlPclJvckFXeDE0UHdwdEJaNWVV?=
 =?utf-8?B?citSUDlmWlk1TldpTzR1MUVvdkpPb25UUVp6bDVvRjl1SDJneldCUFJoUis2?=
 =?utf-8?B?dDZzY0UyQTRhQW1lL1JBU3QybCt1WktwcjVZSzMrdDV6TWxPNnk3T1l1MStP?=
 =?utf-8?B?VkhWamMxaTFTZFBVYjdlRDJQSUNrU0tCM2xPOXlaVW9aUHRhQzlycmt2SnND?=
 =?utf-8?B?R0VwdElXdU45VEJwZExlUk9ZbjNhVUpmdmxGRTNzUHRXRDBlVEI3Tmc2NnEz?=
 =?utf-8?B?N0VSMkFnR1FPTVZTWVRIL3lTZnhiZDJ3VEVGZ1B2V2plcVBkczdTbGRjaGl6?=
 =?utf-8?B?MHlIOXZNRGQyemJGQk9HMVM1Q3JraVQ1UzQ2R2FCcGwwRDl6YjExbHB4TVN3?=
 =?utf-8?B?TDM5cHFmTzVqL2dOa1h4Ti9ZdVIyWjdKNDNjZkRCTHN1Qk9JMFNZZGFrWGJN?=
 =?utf-8?B?OUwyRzFIa3hhZG82NnpGZXRmZGVXOUh3UzV6SUNsZWEzckZHMUM1ZFpVSm9t?=
 =?utf-8?B?LysxWGR3T1lHZ1ovN0tOREhVdnFoSVU1MXI1YzhhbEQyNUhrTzJJOGJxWFN1?=
 =?utf-8?B?Wmc4RWd5bW5xdDJzNTlBNGFHUzVtbWNib3NIUmdBbU51QnJsTStmSVl2OXFu?=
 =?utf-8?B?NEY2RUZMWjNwamVQazFjSE5HV0tKZXp6ZTN1NUptblZrRXJXVlZIS3hsNDUz?=
 =?utf-8?B?S3lSdHV6ckt1ZDJJQ1NVOHRBSHFuNFVoY3hRM0poZXNsR1ZRNnRMaitsTlFz?=
 =?utf-8?B?TWpGeDdPanlRWkpWU3p0SE1OVHhnNFNtVm5iNkt3djN6SkpkYlhYSzNPVGsz?=
 =?utf-8?B?dmVYZElMV01UbDBpZWhKRGkySXZDWjd1YW1WOTNFT3k3ZzVOWE14aFlxMzBK?=
 =?utf-8?Q?OP5i8YeYc+sqNRbDIMvO4oFIpiPoOE0PWjDUm?=
X-Exchange-RoutingPolicyChecked:
	XHgjQxshK92o7x/ae+O956UQaIHNMgihCZcFpoBBsSGO+5gJVCwj/BYPitqPTTN/QZfd7qIfBeMY48Qpvt/l3zrsFdIveJRpe2SK+fQM7Vx25+ZSVAW+E776dJ4xVHn2geSEB3BjbqjNCgheufiRLnS9VexAJ2gqcYPJTL8tDgiFzbkY2qjX9vPH54wZo2yXeyPU+mhpehXjHDSXACQAiLKQe2udJm2MXeJQfBxAFpQ4ZK6PdLkDhOu0yC7O9xqwhK30XKuzqtXAoZ93541WM7JkW7uzt2xNsksYzdGaqTOaz5eQLhddaRBOHYfcxmkamfVrd1s18pm8ZqS5QQmNGQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eBWV3X3xLueBr3tsXV53idq37IUv/pw5PB/dppIPxO436aWWNg7sRLF3pglqhpV8GDBh52i4w44n56x0x39aNmdoK5QHL5OWMtBSRhe6ijl5OqXxBlgdisrkxPMS52Sio6FjRBDFyAPxIz7q2YXhi+96v1pRuRYBCC/9rGZOZmxuxiTk4e3iR1gZNRKyV+P+hAe8++qLNc1Jle58aRmpZ3lNWuQSCXHMbv41hKLQiHEuCaZvy7cO9Aja/mkrAjpqfjZhaUDvEAI3apQ9wSb56nhW8GGGGD2PkuB1M/HakV9b/fv3mZinDl9wMABkPo34U9gsUL6SGiwtTEvIblM49cr04d3FP4D31PRFLq8p6paOMKspsueuL+e6FT13tr9E3vV+Tl9lzI99VGeRAmmP0P0lZIJ7Ela4DACy0OUmEK951dsjwsV259EawSHQHFMVfkJ5GNg3XSt+FcIUTyGcq/G5o79iu68cSi9s0sd3pbRJ2N6JfvGtTMrkRPlUKj9q2bd6AjgXuLpsPEn9N14ueTqrSKvk4M2bpk6DeHrTNFHTf6sQIymdw1Ta/J4P1T2gVO98vo/++1OGgvp2QIzxLLIh+C2/eMRkXGeTAUTA9zg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e956972a-496b-40ad-30c4-08de93d7e8a3
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2026 12:27:46.6892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sjrJnKBI8Hpw70qrhd5kwiT15a2/dh6gs+fcX7D5BcOgpmX52qOdQg4t8qJpufG20BdhcirfWO62qrAIFmh2R685S/LMlb0wGoJQWeT2LVgoYLyBBEuBd2K6XM6pfu/k
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6813
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-06_03,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 spamscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2604060122
X-Proofpoint-GUID: IZbgfBUmBwQFEwoxCA5Axy-cP-zw7Mt2
X-Proofpoint-ORIG-GUID: IZbgfBUmBwQFEwoxCA5Axy-cP-zw7Mt2
X-Authority-Analysis: v=2.4 cv=GvFPO01C c=1 sm=1 tr=0 ts=69d3a6ca cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=JfrnYn6hAAAA:8 a=iox4zFpeAAAA:8 a=IPEAgJOmAkQX9OS7OPIA:9 a=QEXdDO2ut3YA:10
 a=1CNFftbPRP8L7MoqJWF3:22 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA2MDEyMiBTYWx0ZWRfX0D9KwsF+/+iZ
 4IVUlx3MRmdGrBp4Kw3Q1RXypxTRoNWDoC+m5f5KhrRibKPjazG6T6Ptt8k2URhDy7q34GKffeL
 g7FrDDkpJJjxDJe6eSUxbmrmKB6rZGm8aju9TJQXSvlSHZHL/cSA/rpun8lUrWziU2fjt8PbSO3
 AjMrcni5+3qbkM0C3fbvJZoee/uuchMqeXXUcJGgQKl0pkU5eaVQMXHQoraQ5SxRU1ohtBbBRQh
 Qql8y89Yv+GA17HPYJ3QMcaSMm6/gYUg9ke4NkumUjInj8WjyJ2Kj0PvbQFBgsPWUamFuTOHPeh
 quiw3oVi0cPxBlx0gf1PrVKCzMGaWVBrJomkXV0khE6PhjdHbtBoCzO4tU+2r77Izy9FaijfaBA
 egMKZGIHyiY/0Y+7FSX21SqZVgqGQkqwPj5tbOU/9aKZ0W2Kzo5o07Ic7TdMWbx5eP9ARS8+RhD
 XF2rl1JaDEDx6Er5r0A==

Hi all,

On 13/03/26 01:38, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> [ Upstream commit f99d27d9feb755aee9350fc89f57814d7e1b4880 ]
> 
> __module_address() can be invoked within a RCU section, there is no
> requirement to have preemption disabled.
> 
> Replace the preempt_disable() section around __module_address() with
> RCU.
> 
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: WANG Xuerui <kernel@xen0n.name>
> Cc: loongarch@lists.linux.dev
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Link: https://lore.kernel.org/r/20250108090457.512198-19-bigeasy@linutronix.de
> Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
> Stable-dep-of: 055c7e75190e ("LoongArch: Handle percpu handler address for ORC unwinder")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/loongarch/kernel/unwind_orc.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/loongarch/kernel/unwind_orc.c b/arch/loongarch/kernel/unwind_orc.c
> index 471652c0c8653..59809c3406c03 100644
> --- a/arch/loongarch/kernel/unwind_orc.c
> +++ b/arch/loongarch/kernel/unwind_orc.c
> @@ -399,7 +399,7 @@ bool unwind_next_frame(struct unwind_state *state)
>   		return false;
>   
>   	/* Don't let modules unload while we're reading their ORC data. */
> -	preempt_disable();
> +	guard(rcu)();
>   
>   	if (is_entry_func(state->pc))
>   		goto end;
> @@ -514,14 +514,12 @@ bool unwind_next_frame(struct unwind_state *state)
>   	if (!__kernel_text_address(state->pc))
>   		goto err;
>   
> -	preempt_enable();
>   	return true;
>  


Looks like this is dependent on commit: 7d9dda6f628f ("module: Allow 
__module_address() to be called from RCU section."), so I feel pulling 
in this patch without the mentioned missing prerequisite is wrong. Can 
you please help review this ?

This is also part of a feature series in 
https://lore.kernel.org/all/20250108090457.512198-13-bigeasy@linutronix.de/

Thanks,
Harshit

>   err:
>   	state->error = true;
>   
>   end:
> -	preempt_enable();
>   	state->stack_info.type = STACK_TYPE_UNKNOWN;
>   	return false;
>   }

