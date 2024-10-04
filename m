Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6759915535B;
	Fri,  4 Oct 2024 17:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728062587; cv=fail; b=c7d15dZqEVI2BB1n1WlRX0F4S5zuiHDQt/yzyr5p0t99FjQNvwTekJZkIGN7fX7jfiKcGvubDu54CslmBr/13Tba6/ANjgMvqOYXk+SX94i9/oNCgvCuY5Ugh7r9D+9OmhValLIzR2JJmBo++97UDjOLTCEG5E9NMHhB7Z0t6Zc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728062587; c=relaxed/simple;
	bh=Z1JzMvXgI3NXhbRpIjbjF5XUywBF77AQuIy+TNL9tU0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lI5pNhrZSIJkxkC5HyE8MvRZ8EAgXDq6iikPIi9c+VRKfExLKhcrgcUgIvc/SpmG9iaDHLs0o+r138SQMFINVdwa4iD4APIVPMsBLV07cgVKQ1Ubs6leCes16cIBDsqfGtdrwj2P360DBXg3sxINkxmCRBlD+Hd4Nh1AY2LIzoE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YlIpogu2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jgJdwz9G; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YlIpogu2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jgJdwz9G"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 494GfngD025828;
	Fri, 4 Oct 2024 17:23:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=corp-2023-11-20; bh=Z1JzMvXgI3NXhbRpIjbjF5XUywBF77AQuIy+TNL9t
	U0=; b=YlIpogu21NJ/2ldM8RqmsAkAqIgGXa9IHHByVOAbk4nFOTMfNPYIKh7V1
	DGi2+GMONpfWaO1c13ZJJUKdsUomirLPmcE37k9ilpOB+YQ3PxWVPf35AkOt9hYK
	lLyIb/gf7cin2MCT0gV+zaUCGRi30jFC1H3x+N4ZEHr6BmsDJp1+Rz/oA5JyVDyT
	gW4cCyIC5oMQTEJuAz8kRQEYf1kDYIV+1iOTnKh9jR2Gpez6V2ALo61kQzmCnDjY
	+OUnVmqwngqErRyGDdU2G4OLmPXSm5Fggzv55DEQM7XeVYW+HW/FHFXfHuMqA0vS
	GKpqpT4xUh0RCH968nMJkz4/PRwfA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42204ft56x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Oct 2024 17:23:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 494GqsWb037276;
	Fri, 4 Oct 2024 17:23:00 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 422055bxk7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Oct 2024 17:23:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ClX8Kg0y/ejuDJb9boUiBVrAeQ8YKC5XxqRCHw+hdgSE95dIf3ZUJ6WppPbyfCOefG7B9l6nnMTNALmPPVcH9m+js5xc9SayqDWNv2pmAwsM8Znra9Z/TBNUgV0fE3ClTAU/0E5wnPT1bVfgDJIx2e0BjCJQawW1xKqVXqpPh5s21jpIWJ+bgoyyUPPBHZlpdXNXi3+BaV5J/RZeg5U/lS5R+xMbgJQUXTL9AGEiQ44FjWM57OBiwG0za36mAyUWf62TlJdIuX06eS9UPprTQDZ02ct3HBBo489Km8T1EbceRHb6vY7CvOFHKDxzHpareV645uJzCeuOeK1UNAcbOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z1JzMvXgI3NXhbRpIjbjF5XUywBF77AQuIy+TNL9tU0=;
 b=rOem/QYRt93ra5+WagmZe5KOKc/ny0xZss//HWNylb+RG4F8+eW5N9AJoO9F7Ki+9oppaDEVsUvxX925UnzLwtApT2BvsP3FEsjunkvXZ6QMobis8yHxTToZZBJCC6y/3nPOEEd3OtSRVpfEYtyETmr5MXx2wTfAbIrPRDOqrmzpeq0cMEPJN3O6lzrHmM6zC6bWjOtz5zpkO8WiyzwWTpCFisOGz+qvQowLZY2qN1XsvytQXzhB2eV6+7pfm/WAKo9a0z93VPbxYsNEdiS5HtGF7V1TrAvEo0QfHRwCG8OQwcF7/tK6HFqOE7fFFH04bnBnW0rm+iqVE8yINPNkOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z1JzMvXgI3NXhbRpIjbjF5XUywBF77AQuIy+TNL9tU0=;
 b=jgJdwz9GafPbr7Iqd3eWhfgmkYmVlUQc7slevWCuCsyLYeQSi4amL1CJyuOIAgKpILjnFPjVLH+6TAOQT7W+ukuHj19cIQM8Fv+Zdn8wzGjdBXPG8Zj0nSVayyFuphjoM1igiBDqwdrDjrCzgaF2kTbXyNw2Mt35vLS07nH6xFY=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SA6PR10MB8183.namprd10.prod.outlook.com (2603:10b6:806:444::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.18; Fri, 4 Oct
 2024 17:22:58 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90%6]) with mapi id 15.20.8026.019; Fri, 4 Oct 2024
 17:22:58 +0000
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
Thread-Index:
 AQHbFNBh+el4ZjAI5UiZoizZfWmvE7JzgJ0AgAEe04CAAG5DAIABlJIAgAACgICAAAHqAIAAAomAgAAChQCAAC6xgA==
Date: Fri, 4 Oct 2024 17:22:58 +0000
Message-ID: <8AC0ACC8-6A77-487E-B610-6A0777AFC08E@oracle.com>
References: <20241002125822.467776898@linuxfoundation.org>
 <20241002125838.303136061@linuxfoundation.org>
 <CADpNCvbW+ntip0fWis6zYvQ0btiP6RqQBLFZeKrAwdS8U2N=rw@mail.gmail.com>
 <2024100330-drew-clothing-79c1@gregkh>
 <A8D6C21F-ACAD-4083-900F-528EB3EB5410@oracle.com>
 <CADpNCvbKGAVcD9=m_YxA6qOF6e0kohOfVsKOqJeVmrYaq0Sd8w@mail.gmail.com>
 <2024100420-aflutter-setback-2482@gregkh>
 <CADpNCvYn9ACkumaMmq7xAj6EQuF6eYs174J+z81wv5WqzdWynA@mail.gmail.com>
 <2024100430-finalist-brutishly-a192@gregkh>
 <2024100416-dodgy-theme-ae43@gregkh>
In-Reply-To: <2024100416-dodgy-theme-ae43@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3776.700.51)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|SA6PR10MB8183:EE_
x-ms-office365-filtering-correlation-id: 87c7881c-1a37-4bd9-f0e9-08dce499312a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?V2lZNE02eHhDM25aODJXSWl4ZlI2UVJKdHNhblRQM3BKUUFibGpra3pnZzNU?=
 =?utf-8?B?V3dBS3dsdWpQNEF4clB2SC9paWFUd3dPbGk1ckpqMzlsbDZZVWdtcGdUV2h5?=
 =?utf-8?B?Qm5Kc3d0MllERjJ0blRsaC9jVWFtdWpaQmprQ0taNVJqTWVTYS93OTVMVEU5?=
 =?utf-8?B?WTBtMDhwWFk5Y2M0U2xJT3NpQzh5Qzl4UmtGQWE5cFdqaUdtVlJuUmtaZnpO?=
 =?utf-8?B?NFEzbTBoTWRwYmVZNGNUZC9CTXdwZ2VBZE5sZEUyc0ROanhPZGVLYmtJRGdJ?=
 =?utf-8?B?OVUrZHM5Rk5ub2tWV2JvSGovalRnSlF1Q20ybFd5cmg2SGFaYU1HT3BYa0F0?=
 =?utf-8?B?aDlPRkxXRHNQSktHS1QvS0JzbHdyNExYYW9HbVpSb3Y1MjluU091VzIxMHNo?=
 =?utf-8?B?VGw0bXMvb2YxMTJDODdLOVlicmlJS0tNTTQ1NWVlLzU0OEllMi9GQmZacDR0?=
 =?utf-8?B?Y2NyY2ZSU1VoVHIvQ2lrbTRjRVZ6cGFPdDZXcmpqS01PQWtzeDFuTjU1cjRt?=
 =?utf-8?B?SDRVOTJKa0haQUJRQ3k1S2FURGFiQ2tuZ3RIOWpxYnJqL0pnN1VwbzRWYk5y?=
 =?utf-8?B?TXZyaldSUmtsZ1o2ODFpSHpJSXQ2c2xtY3ZhSjNzcXBKNG5GQnU3aHBnSHI2?=
 =?utf-8?B?QVROdFU1STJ6dXRaZlhnRTRoVGZhcC9nWllHdDA1Rm1sblVCVDhIanFZaWVK?=
 =?utf-8?B?SUVURW1zZ0FQTHNPS3ByT1NMOHVzZUw0dHh4SU93bWh0Y2pIb1JMK3UrYmUy?=
 =?utf-8?B?cUlDb0doYkRBZTlCMUVmNmxpY3FBSU5TT3ZOSS8xK0dBUTR3ZCtSNVdFcHNU?=
 =?utf-8?B?OWZjYnQyZU53eWJYSkVOWkUyeEYrWHJoZS94RjhEdGxhcjBNUXRuS0ozc01L?=
 =?utf-8?B?QThoYm16T2lVcHBBM1JSMFhweEdmZGZyVVgzTFVvcjdBNmZzL3p5ZmQvSDht?=
 =?utf-8?B?cS96Y1ZoMVUxVTBmNXlSdFZJUit0T2N4Q1FMM0lPYVpYcVBROGRGUnQ4RGE3?=
 =?utf-8?B?eXl6cE9SKzdrRmRNeVN1NFlxbTlTZnR0bEtYQ3BQSmt5a3RRSEJqVEFiVzhj?=
 =?utf-8?B?RHVwVzUxaVVlRXkzeXNlV3ppUVNPOUw2bnZSM3E4eVlWYjFXRStxTzJvRG12?=
 =?utf-8?B?bzYyZ1cvOTNLQ1BoUFNRSDcwMkJWcy9QclB6R2ZQeDJxcXRrVElvMmxxUE1N?=
 =?utf-8?B?WTFEYU5keU42NVVlSVEwcDN4VXlXVkhyT1JZYWt0WTRnNWRVMUY3ZzdtaHJJ?=
 =?utf-8?B?R0NoNk9vTHZxVjlHaEY4RW5CeU05SnZSazZZYzVrZmFNbjloNm5KSkZuWXdF?=
 =?utf-8?B?OU1uVjVWRnRtZkxnSWpjWUJucjYvMTB1Y0tEK2NNaWgrOVZZbEZiM3FQTDFD?=
 =?utf-8?B?QTI1QkJVVVY5SkFEZkp5SndmYlpRMnVvTkxOdDE5ZTEyZlhyWXVLR2JMeGdY?=
 =?utf-8?B?VGN2OWkxV2ljZWc5SExvSU1WTzZSSWd2RHlGSHg5VTBiL2hwdEE5Qk9PWVpw?=
 =?utf-8?B?WlFqd0VZMEl0UndJUDNzMVFJUVp3SDh4V3hYUjRDdTl3YjZnYTdhczkxNzVK?=
 =?utf-8?B?MDRWMmJaMm9LUE1OSjlqZStIRngzUis0OFQ5ZFFNWmw2MkNFREFwbWM5ZEUr?=
 =?utf-8?B?N3dQMk9aaGxUcVR6OWx4Unk4YlFPKzFrQzBXZ0RMRk9lRnBoS0NJaldLVy9N?=
 =?utf-8?B?NzVBSUlvSm5EWGtTTUVYV2syWitDUUNPQmdqVm80VlhKaVhTdFl5VDFpVFdy?=
 =?utf-8?B?OEs5SjRRQzlMVWdhTUdmL3hmY21XQ05GY2ErQWYvS1U3bXJ3SzYzZHpwaWRN?=
 =?utf-8?B?RmJkZUV0Mjh0bmU3MFJZUT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cG4xUlFiMTZlVGlrUDNqOG8wdEZxajBwZkpWSTVNWFpPRnJpL3dXV1JCS1do?=
 =?utf-8?B?NDZoeEIxR09vWXNZUzl2a095aWVId1ZzV3ZQUVVVb0Zud2pmUUpQMThia2ZZ?=
 =?utf-8?B?QUZabjU3bzdRWGhJM2toZ3pFNU95NTUrdUNTbm9DY0k5T05Gb3RlaGNaVlRT?=
 =?utf-8?B?YlM2bTZmdjIrSEJTbXhac01WcWExSXBOcGdtazhETEpjV0dMY0RLWVp0dUp0?=
 =?utf-8?B?djd2MmlmdFpxVHMvdXl5WEdpSjZwRDBQeUVZMXhuczJueDRoZmlKWTU1QTlV?=
 =?utf-8?B?Nllva2dWYlZTYk0rTnR5MXVCVGRxSm9KWjMza2Vta01PaFY3NDd0Q25KUVJo?=
 =?utf-8?B?L01vM3NEUE14SFFVOTZ1Zy94OVAwWFdFc08xeGJwNVZWM1E4dXJzUzdVZjJX?=
 =?utf-8?B?TFNsYkZCSG9XWFMzZE5mMGZ6OUsydmJkbHY4b2RtcjNaYkkxdzFQK3dKMVVT?=
 =?utf-8?B?SjAvTzZCa1pqblhXdGRrQ3pvWjdYM1hhTkxZRExIZk82QUI0YlQ5RXdjOUhO?=
 =?utf-8?B?MDd5WkFaN0orbGJyTXd1SitnbVd1YXhuVXZ5SDJwOVN1d2dvdU9FVXU3RXpt?=
 =?utf-8?B?OU1qVmg0ZmtwZ3ZZcHdLRS80T1VhbVFWdXdDVzF1Q3NoUmtSRjNXdGw0VFRE?=
 =?utf-8?B?V2NZMG8rU3VvZVYwdjN6WFNIaFpMRHdkcTFWOEQ1N3BlUFRwcWJVMnJjbGsv?=
 =?utf-8?B?NjJ2WkV4TkRzdmRwSndSMENkSjlQQjhhR1pKV2M1VFRjbUx0REY5dzVpbmhU?=
 =?utf-8?B?RFlNV1hSNHgrYTdGRjlLUXZHZkY2TDZpMnYrTXdlQzkxcXF1akkrMlpWbFBE?=
 =?utf-8?B?dVRNNUZiVGw5YVppVGxuNkptbERHdWlxa0J2anlnVmRJVGRkODFaR0RPNTVY?=
 =?utf-8?B?NEZLSUlaNmxMRjdvQ0ZhZU9FMjZ3cWtVWE1IVTEzdGY0eWVkVkVLVndjcE9u?=
 =?utf-8?B?VlFjN1M4NjVENVJzS2QwS09QK0VYS051Z2dxVUVPdTRTQ1ZSb3pKTmlDODJi?=
 =?utf-8?B?Q1hzTm45cVk4YUMvS1lKdDM4ejAwQ3JXR1JjVEdPdFJCSHpDRnQzRGcxQWlM?=
 =?utf-8?B?SXVzUHBreWNnODBQZjlja3RoYWZJVDNoRHJrdXpkeHJyNXA4c1dNTWs0QUd3?=
 =?utf-8?B?Qi8yN3JPa3lwVU54amhXT1ZickhMdkdwaGp2MGU4bS9OaWQyaXpOaS9tUURy?=
 =?utf-8?B?TEhDOEJOYjZBdWw0Ny9HbHQxMk9qV09xLzVCaVZKWFNKdWxHT0NPdGJwVlJM?=
 =?utf-8?B?M2NtdUR2cUNNbmJGeG1TWHhKaVNpajI2YlZuTWRwSk5ySXV1VHdrWkQwUE1V?=
 =?utf-8?B?a0JKbTNudnFFSGlkdnNpZ3VnNFpoVk95SGNtOEthcHBnWlRtOUdnUnpUMjdC?=
 =?utf-8?B?cFhWOGFWTDNxb1FGV3lCdFpEMEp4SnQ2WTZDVEhmS2xhYXloc2lwV05lWFMv?=
 =?utf-8?B?TVVkRXRkWWhNQXlnWlM0WUZDYlZuS3JKR2JCdGxLSGo4NVp3VG81VnEydlpE?=
 =?utf-8?B?ZEJLZmdxRThtSWl5MURIbXZ2WURBNHNnY1FrYS84UGEybS9qejVqWkZFSXhY?=
 =?utf-8?B?bkJ5OFROMFVmR3RIQ21KT0lmNE5YdXJmUnQvMVZWV3dFWTg1cHJUYTF5Zld0?=
 =?utf-8?B?OG5UeTYrL281VVE0dWUyV3FZKzdVcTh6ZHRnY0hQcjhSTDh3d0Qxa0MwWVZ2?=
 =?utf-8?B?ZDQyNXJVMWdKMG02RzAyY1dkbzhmb2lZM1dIc3haYklndGFxZkZoai9nTDZq?=
 =?utf-8?B?TTkwUU9CQU1EUXNOcGZ6UVRIcXI3UDBFSFQ0OHhST0VoL3l2Nmx2Wis1aSs5?=
 =?utf-8?B?M3hhMWpBYW1ZZi8wL2JKUlFrTjg0TnREdzd1RHdoK2E4b3V3UHFTellzSzFS?=
 =?utf-8?B?U3BXalg4V09CVm9TcGJTcHNidGNGSHJaVUlPZVdsY2NPUGpWa0hWZXpyZ3kv?=
 =?utf-8?B?dUdleUVXN0Q4TytnWCtiRWYzWElPcWdvenI0Vlc5dDZraityaW16SjczaDhK?=
 =?utf-8?B?WVNPSkt5d3VZRXFPSEd2bm92OEMybmtwU1IwRUxsOVJwZ1RBb3RpQW1pUVVV?=
 =?utf-8?B?Ry85Q0NKNkwyWW5BRnNzbGNoOW4wYnNZUVJJQThSRFJ2ZXVoYmxmWkN1WGVV?=
 =?utf-8?B?VkxucVh3UUU4RzVyWFRQR2ljeEx5alZsWUhVZElSdk8yS29MMis3WkZJMGg4?=
 =?utf-8?B?NGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <654414726F127F44AA150DD5537B71A9@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jOmjJYjizsHeh0DYO7k5eGzezdm6kXlr4ZL0t0VfOt0KyuhKXUiN1F+TZ3shEBqE8ZrT1a9in7xeEsU0zpBfyEEowVN1CEZEFG+CivC8EHBqcTMkVuWk9wEBzUnFj1e18H/j3G/yxh82VXZ/Mu7/JE1BwA7MM/rXuo64Mx4JEjO0gGTep7y5laRoG9ryAPC75HWk+r8VRv5ONLZogPxLTFPOCyvDkEJrADIXALsr0sZY5dT4578be+enb4iC5ScfHzOhtijAWG85+ZwKyy6ZpQ5rlfizNeKZppJogxY4uC0yfiySCOZ01AIz7BEFfcZ8DH4x72hPLdyIcO0sEIGRRS/k1bukG7r2dEiQW6nOiRIMRMyeqLJbFNIiPm/291zlgJH8krxY+HoWyJGLG9NffBwY/LDIRIQqHWrm7sn1XQIMy8ZD5+S/iQnpBuJq+LqxPsN73i9N1HvYU5g37U173nAAExgmmiDTJwgcRmHnPePj5sKCR2rjqxRl1WkP/U1X4dm00aj9M8kSg6J+CUjcTcEJ3kVlxCbWhg3z3q7+RTh+4Z50EaCgkn+ic+uRjP5YIVL61hVF/YOpP5ppenI7mDiN0Ow/x+lTIjxrQtZlLLA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87c7881c-1a37-4bd9-f0e9-08dce499312a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2024 17:22:58.5150
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4XKQDGRH15lGUCzF4njCkFTDrPchQJ5JmFuWJFnOCJAmR+IOrObRzdrsME191AFubToJN9iEc1OR0o1NOKMrhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8183
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-04_14,2024-10-04_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 mlxscore=0
 bulkscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410040119
X-Proofpoint-GUID: ftrUkpw6_khYZD83wtjgM_428-BhvPER
X-Proofpoint-ORIG-GUID: ftrUkpw6_khYZD83wtjgM_428-BhvPER

DQoNCj4gT24gT2N0IDQsIDIwMjQsIGF0IDEwOjM14oCvQU0sIEdyZWcgS3JvYWgtSGFydG1hbiA8
Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+IHdyb3RlOg0KPiANCj4gT24gRnJpLCBPY3QgMDQs
IDIwMjQgYXQgMDQ6MjY6MzlQTSArMDIwMCwgR3JlZyBLcm9haC1IYXJ0bWFuIHdyb3RlOg0KPj4g
T24gRnJpLCBPY3QgMDQsIDIwMjQgYXQgMTA6MTc6MzRBTSAtMDQwMCwgWW91emhvbmcgWWFuZyB3
cm90ZToNCj4+PiBIZXJlIGlzIDEvNCBpbiB0aGUgY29udGV4dCBvZiBDaHVjaydzIGUtbWFpbCBy
ZXBseToNCj4+PiANCj4+PiBuZnNkOiBhZGQgbGlzdF9oZWFkIG5mX2djIHRvIHN0cnVjdCBuZnNk
X2ZpbGUNCj4+PiBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dp
dC90b3J2YWxkcy9saW51eC5naXQvY29tbWl0Lz9pZD04ZTZlMmZmYTY1NjlhMjA1ZjE4MDVjYmFl
Y2ExNDNiNTU2NTgxZGE2DQo+PiANCj4+IFNvcnJ5LCBhZ2FpbiwgSSBkb24ndCBrbm93IHdoYXQg
dG8gZG8gaGVyZSA6KA0KDQpXaGVuIHdlIHRlc3RlZCAxLzQgb24gdXBzdHJlYW0sIGl0IHdhcyBu
ZWl0aGVyIHN1ZmZpY2llbnQNCm5vciBuZWNlc3NhcnkgdG8gYWRkcmVzcyB0aGUgbGVhaywgSUlS
Qy4gQW5kIEkgZG9uJ3QgcmVjYWxsDQpldmVyIHNlZWluZyBhIGNsZWFyIGV4cGxhbmF0aW9uIGFi
b3V0IHdoeSB0aGF0IGNoYW5nZSBpcw0KbmVjZXNzYXJ5LiBUaGF0J3Mgd2h5IHdlIGNvbnNpZGVy
IGl0IGEgZGVmZW5zaXZlIGNoYW5nZSwNCm5vdCBhIGJ1ZyBmaXguDQoNCkJ1dCBpdCBzaG91bGRu
J3QgYmUgaGFybWZ1bCB0byBiYWNrcG9ydCBpdCB0byBMVFMga2VybmVscy4NCkkgZG9uJ3Qgb2Jq
ZWN0IHRvIGEgYmFja3BvcnQuIFRvIG1lLCB0aG91Z2gsIGl0IHNlZW1zIHRvDQpiZSBsYWNraW5n
IGEgY29tcGxldGUgcmF0aW9uYWxlLg0KDQoNCj4gT2ssIGluIGRpZ2dpbmcgdGhyb3VnaCB0aGUg
dGhyZWFkLCBkbyB5b3UgZmVlbCB0aGlzIG9uZSBzaG91bGQgYWxzbyBiZQ0KPiBiYWNrcG9ydGVk
IHRvIHRoZSA2LjExLnkgdHJlZT8NCg0KSXQncyBub3QgY2xlYXIgdGhhdCBpdCBpcyBuZWVkZWQg
aW4gdjYuMTEgd2l0aG91dCB0ZXN0aW5nLg0KTmVpdGhlciBKZWZmIG5vciBJIGhhdmUgYSByZXBy
b2R1Y2VyIGZvciB0aGF0IGxlYWssIHRob3VnaC4NCg0KNC80IHNlZW1zIGxpa2UgYW4gQUJJIGNo
YW5nZSwgYW5kIGFnYWluLCB0ZXN0aW5nIGlzIG5lZWRlZA0KdG8gc2VlIHdoZXRoZXIgaXRzIGJh
Y2twb3J0IGlzIHRydWx5IG5lZWRlZC4gU28gZmFyIHdlIGtub3cNCm9ubHkgdGhhdCB3aGVuIGFs
bCA0IGFyZSBiYWNrcG9ydGVkLCB0aGUgbGVhayBnb2VzIGF3YXkuDQpUaGF0IGlzIG5vdCBwcm9v
ZiB0aGF0IDQvNCBieSBpdHNlbGYgaXMgcmVxdWlyZWQuDQoNCg0KPiBJZiBzbywgaG93IGZhciBi
YWNrPw0KDQpMVFMga2VybmVscyBhbGwgdGhlIHdheSBiYWNrIHRvIHY1LjEwLnkgYXJlIGxpa2Vs
eSB0byBoYXZlDQp0aGlzIGxlYWssIHNpbmNlIHRoZXkgaGF2ZSBhbGwgdGhlIE5GU0QgZmlsZWNh
Y2hlIGJhY2twb3J0cw0KYWxyZWFkeS4gNS40LnkgaXMgZ2VuZXJhbGx5IHRvbyBvbGQgdG8gYmUg
cmVwYXJhYmxlLg0KDQpJIHdvdWxkIHByZWZlciBtb3JlIHRlc3Rpbmcgb2YgdGhpcyBiYWNrcG9y
dCBvbiB0aGUgc3RhYmxlDQprZXJuZWxzLCBidXQgSSB1bmRlcnN0YW5kIGlmIHRoYXQgaXNuJ3Qg
cHJhY3RpY2FsLg0KDQoNCi0tDQpDaHVjayBMZXZlcg0KDQoNCg==
