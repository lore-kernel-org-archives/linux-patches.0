Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A1D34D93C;
	Sat,  3 Oct 2026 17:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791049295; cv=fail; b=nxO0kEonKjr3tIkUdNJVmK5ISiQ84mcaOmSYC/oaOUkbnf3Z7EgH/M2OdMQMer6tciOfE9XnIj9o/FZLHirkH8Im2lJMDNidkb1QM2O1Jo35fKB5yzqyFjSz2M6trjGTSlR0VrGNJsuAZmDNAmWP4vJtA4ezql4mkMJHM3Q7UOE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791049295; c=relaxed/simple;
	bh=4viZ0T/xCK4zYxmxJO9UmDv5ZNMxFQIVmGAAaM3JOYA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=f4QkFSAFPh5zxppgLvOGaxmGGIR5n2wmB9pysHKqecdA7iYVYn7rAEq9zk2HN9fCF63/cO20X2UL9wojF7dzUF4BbKJoZE8nDl3CLbE2OJjYfKmUyHUGPmEeBKECd5jNycpJ6QVJ/iPZXoyihXpQHudDM+PLHbR+L2+ln3uS92Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hGf4SYHA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ncwicz3M; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hGf4SYHA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ncwicz3M"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 693GUGQf4081105;
	Sat, 3 Oct 2026 17:41:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=AqrHT6t2dTUQVi+jFuWez8hQG/YUH1DWIOJa1k1p+nQ=; b=
	hGf4SYHASSwQ95l0wmwBDlYh7cq8sU/oJdH7OUzAAXvpUzQl6zy7p4r25fq+O+FN
	LjhXfSmX3k3qam6TtD1fEkm3+iC1Rr3k0bQZZx0GsINS9vrsZ2IDyyBkqcGgBYlk
	b327f8qcGPcbjbaZXS/d5PSiduSQspHzhfDWaxYWBS2FE1LTikFbfZAg7PapxfS6
	93Cc9Bw4G1rmfTFzV7xirzsR5jNKdY2Gr0lVPvati+hOUavkOPquciGL5hcGgUbi
	v5PJst4GAh4QQBNQPg+QkzWFNd5DAGgDV3gJ0Ts9JJFI/ZPZ09xf0qwS5G+Nk+DQ
	QAp+UMEH4PESztaMnR4GcA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h2r9xrdgx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Oct 2026 17:41:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 693HYovl015562;
	Sat, 3 Oct 2026 17:41:24 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011044.outbound.protection.outlook.com [40.107.208.44])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h2r58xb8p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 03 Oct 2026 17:41:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vDRkEEIG9RkcHpoWbtrAsSuRalBwXwmWv8hcP4z3tssmq3jdzfEyCJPNIfx9+8nN2bVJcjDLahuCJiSBWe086svEvPa4VOcIiZojrW0zfPfHIldxTyHlAYZOeNgjOIRTX5rIVjONwd9128W33BcBfKG8uh/CUBA0KQlT7Kf2DjZZPHzWf1ag59TIFlJkzJSI/iLhnlbcjTqfDcnmNE/iGnp9Bt9i/r2FFd0l0QszibOA8NM2T8omM0iEkI8YqbfFNx6KFcevLjuQgrX03K3K2dIjrbfRJ4r583j7wRfwPdHHe/vWG55nJ+kJOXi9UtMZ3eWfOh9mv0VlgqwftlcrOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AqrHT6t2dTUQVi+jFuWez8hQG/YUH1DWIOJa1k1p+nQ=;
 b=Tfq5wsANxFhgu9bexPRRQfCf9+541TTxP0YezNyvt/qcmOqGdnFeL22MjXhMLUse1TShCflmitv70ZKlPueb1lPtd8OnIrx8WswCfw/yHVbSAsbldryxSNizCHvV+7APMH+polnYI/V5odRW9oLXj5g7dCi/nbQqyXPDfg0rU/Q1PsfP3xQvYxyKf/eNofBPUdjHsujD1Z142zxpfirTomzeXDgRsEHpxaQfUT3K49mlNF96Uc6a5kGsLukkWouxVQNLV+gmpIGj4yg9PttL15w97oCAVdTlqeeQEy9IBAWwaaKUO6o1kC8xecBGkPy/v5GbWzof8FlaTon1tsfZjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AqrHT6t2dTUQVi+jFuWez8hQG/YUH1DWIOJa1k1p+nQ=;
 b=ncwicz3MQHa3hz0uTygZveMqN99FDZkPDKDmnQp5DlvVHxHyQmTrSP/ToGX7M3is8XFnC5rVQJCm4eNFPmdOz9AqFFWSZYUkzz4hA7xhRkKcNOOjmt5CVKMonmzJ2Ja3cdDxoDyUMv7Mu+hpJ7VFp+iU6NIj1uDUYAJQOZXTqrU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by BLAPR10MB5171.namprd10.prod.outlook.com (2603:10b6:208:325::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.12; Sat, 3 Oct
 2026 17:41:22 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0496.008; Sat, 3 Oct 2026
 17:41:22 +0000
Message-ID: <c19cca5d-699c-4999-a569-bb1bb4d225c9@oracle.com>
Date: Sat, 3 Oct 2026 23:11:14 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 064/752] rds: filter RDS_INFO_* getsockopt by callers
 netns
To: Allison Henderson <achender@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev, Simon Horman <horms@kernel.org>,
        Praveen Kakkolangara <praveen.kakkolangara@aumovio.com>,
        Maoyi Xie <maoyixie.tju@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20260930152358.131179731@linuxfoundation.org>
 <20260930152359.544074072@linuxfoundation.org>
 <051245f8-42ee-4046-bff9-5fd2dbeaf807@oracle.com>
 <1ac115b1c242dfd76302189df13752367247b159.camel@kernel.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <1ac115b1c242dfd76302189df13752367247b159.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0471.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::8) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|BLAPR10MB5171:EE_
X-MS-Office365-Filtering-Correlation-Id: f02ce33d-44b5-4b46-7ba9-08df21758a0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10067099003|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	otKPITkQh0xOe98Z4KRzQpK5iM1ZHNPat0ZL8Bbg2WRLs2zGjc1c3WX1tlBx7vAEl91TL+22+iCpYIQkh0Knl3ZUV7WnOCqH8le6rpq/Xx7aA8wcwiwog3Cu3g4pAb9IfQCCb9QC4ZY7IeCLuH0i0D4eOKmooRkIn8kAhGIS76ubSUGt844r/Y+ju6cJwBYDSMUWUuWxkZ8DB4C1k2XozlnzW8epc3wiRAAVYN97owW6IhC4BYETqPwmZnohKLiFqpO7gLHRMuWgnDbQ0qc4lLWurzKn25bSPArpeqwfmmW4uCXyDKja5sWYwLwxt3G/Mkib+QSEhw9fr5A1QmLCx9U8vXOTghNGCHDfABfvGDa640x8GE0MQTO6bH6UETy+HkSeNmfUxwXPN93bWxk5WQwIuKwb7CILOucAWBFeaWDVsBy8vhyr2yx/Z0jeihp1sd5QkQVQgaqqMPMmQ+HGB6C6R3mTAhbyNTaSZ+WDv0EMDy/po+owYbwXMyS4gCiEhzxwuYeldLSs3ZIFUwP9NnQw6IfSg+E9Kb/4UgHWaHb2o6NxhQbLF3WINFMC0ObjlLh6SURJOQ0g3yBNLqyni9d1m3rJRr34Dza9odiotqHLyCRpTwBcq6eSCpj/BDfJnqfTXqdTBx+ExjBgKLq9XX4JmbV/pYD93xlewLYmoNE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10067099003)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NnQrZ2k1ak1mOGlhNFl1R2RhTUJDWUI1TWthTTVxY2xOaDArblRISHlyTmhE?=
 =?utf-8?B?bU1FbFF3OWhiSDV4UWNNRFNRaGx2MkM0MVYxZSsvWGZYamVuLzRXQWxmcTZT?=
 =?utf-8?B?cnBlai9pSm1peGZPV0lKajBvU3RhY0dnVFd3UllUQ21PZ0lPcVNiOUxOY1h4?=
 =?utf-8?B?bis1L0hpdW5tTFlwazhSNm1wYSt3eDVZbU9NdnFaTmNXSG00cldIdHlMNlNp?=
 =?utf-8?B?RnlSd2FTQ29wWFowdGF6QzBURE01ZkhLWFk0UmxVWmpWcjdtd09iaE5ndC94?=
 =?utf-8?B?TTFoNmV3b01sclljTDM1d3ZaR3NEaUFpUmZRMjZLcnNOYXFaV2RiWXNLNWFL?=
 =?utf-8?B?STkvT2h6SXJRd0grMzFBMUlDNEN6OEpqWVZVclpoQjFTd1NTNHI2aTNqZXVP?=
 =?utf-8?B?R0MzbHhxdkM5dmJidGkwU1NTVC9vbjBUUHN2cTVtVS9RVWxSRGkvbWhpUkZx?=
 =?utf-8?B?Ry96RUdiUEdXU1VOY1JGR1M4dnpKNlhlR3ZWdHVZSTdIM1pNaGdnYnc3RlNT?=
 =?utf-8?B?MU5jMXhrMDkwKzIzTE1EUU1FR3hURWFJa1cvUjNySG5KanQ1Nk5leGEyd25M?=
 =?utf-8?B?MGRrMjdzQ1k5ZnJiZ09RS05SWTU0ZDM5ZzBoWFF6dURHVzFRMGRkdVZuZGd4?=
 =?utf-8?B?TXh3QlVWOVRTNCtYa3owRVVPQ2FnbDE4VnBTdXlVek1FTkVjRnBYNm5pOUlV?=
 =?utf-8?B?Z3hnaXJLWE91ZmZZdkh6Zm91dEptbEwwNzI3UlJncVRNOG9QaVgwTmVoRjVK?=
 =?utf-8?B?L2xrY1YxNkdTL0c3cUQ2NUxlc3pVMGJDVGFWcmNVT0VWanlBNUk3L0twazBH?=
 =?utf-8?B?Um1Ndnd5TkNMak5CUURNOEhKeVdEVXNwTjdQdTdIcTBVNUdKbkZYOVdnTW1w?=
 =?utf-8?B?YWFmWTArWVNNaXhJMGVTVkxTRFRyVkZwaGZhNzZtZWkvdUhCemhCNHc2Qmkw?=
 =?utf-8?B?cTNMbUlCS0FlVU1XRU12V3V3TkxsakJ3S1RpZWF5MTUwZ3lOYmVoVFptTjhZ?=
 =?utf-8?B?Unh5U0g3eXhqN3Q3SDVzekpWTUxBb0VhQ1dXS0Zjajk4czB6YWtDbXlmbStE?=
 =?utf-8?B?NldObWFkTG5ZaTdVNXZEVUdtTUE1Wm9yTTUveWRuKzFTODZyTWFCaFc2eTNZ?=
 =?utf-8?B?V1dTTGtCblB3OUxXMXZyNWd0YXBwSUplbTlVR3p3dUplN21mdm9YaEw4MXlL?=
 =?utf-8?B?cTZQUFcrNUZyY214YmUvZzF5TmxJU2tub3hnZnZBNHZoRWloRXBuQ3BRbklH?=
 =?utf-8?B?VmFrN1dlZ0dPV3pkQnUvU3AxbXhzQ2RGaFViZXlnRU02OUhwR0FITjhxR2o5?=
 =?utf-8?B?c0lTa0ZKbE1wWHEzZTdOQ2ZEQ0RVUnVPYmJQejc1VGw5U0xQSEQvQk51akFE?=
 =?utf-8?B?WDhZektralpTU3liOXlqQ2NhalhaREZJZXI5aTl5MzRmemZTUHVPcEJwTXNW?=
 =?utf-8?B?WnJnelVmWFJlUXMxT0lsUFhlNnI5alJGZEhZczlXSW1ycWRtbWRaMEEvSGxF?=
 =?utf-8?B?dFRxYnBLZGh1Q1dvWWhzbERSTFgyUGFqdmJxZDAwbHIyYUd3dVcvUWkvcURD?=
 =?utf-8?B?RGY0U1VOVXk2UXEwbnY3bFVidWpSU2QxVVczZHZDaGNQWUM4QThwdnU2WVRj?=
 =?utf-8?B?NnVvMStYaHFGL1lyaUNlUnY0MWM5UEZuUGUxcnNuM0JKZ0dSbjVrNjZOa2dK?=
 =?utf-8?B?M1paQnNTZ2J3UzU1WkVFcjJBQkF4dXNZSzhhMGtmemQzVkZOdlVlQTY1Qnhz?=
 =?utf-8?B?RkwyTEx3YVBhRWNBSXJYWHp5RGdBYWJVYUxlWE5yQlA2QitVcGMwTzZYR09Z?=
 =?utf-8?B?NXpqN1h6MUJoOXg5UEJCNnRDMlg5NTVhQjRVY1VhM2dVVCtLTjk5TnFZcWtD?=
 =?utf-8?B?RWdqMW5jb3RqWHVqNHNWN0RmY2N3N28vVDRDTmpjaXdUWStka1ZYVzhrZFVC?=
 =?utf-8?B?eFF1SEs0Mm1JVEcyWDJOUTNCcVo2RzdVbFdib01maUxUd0lYQ2h5T3ZUd0tr?=
 =?utf-8?B?b1JmaVZjNXJldTFEYkVLNU0yL0p0RDdYMlBLQ0U3YWg3MEs3cnJ4c0dKcFJj?=
 =?utf-8?B?UW5hSm9HQllRYWlKeEpCUCtrcFVPenBMM1pRazZDWUNGd25QbVdMcmFsNisx?=
 =?utf-8?B?VDhjbm5DcHdQL3FBdFU3VW1kYjFGRHF5SkVqUnRZMW9uelFPL1F0UEhCSzNG?=
 =?utf-8?B?UzJsSFJ0eWREc3ppVk9nTEVsR0VkdkJXNEVIT0VTTkw3RlpsYWZtaEhzU2xv?=
 =?utf-8?B?TVpzNW1GaDhzSkFQejVnV1ViYW9UMjlqMFlVQ2t4N3VkVFc1cmREaERSeStz?=
 =?utf-8?B?NnJVMnJVTXZYM2ttMUZNcCtNdytFWmFGUzFKWGtyd1pkNVdhSWZVMUpwbnV4?=
 =?utf-8?Q?BxwpniTttAQoJ0Afd/rqx3NFa54DSquTrmSkp?=
X-Exchange-RoutingPolicyChecked:
	gzzRsDbmMz/YJOhJujcbG8e/AWdeqSWpoyKDPNjroqnu0hv0zCP00+n5/al3zDXu7QiEamYsLa2XMfjAuVtKuXkBKEL15frlnJ8kklnztjeuMGGkxKzOyGYOphQnPelItoALKd2owqrHNyhKsqua3RFyzB26R+8vFpJhDxR2GTkkTzq2oZOjc7WOo7UTeeOLFf9WvxtdHiUJ/5Wt04VafktRIT9McB4yci6XCvJhz2kLKAiGI1teom4qCWY+4+pP+42OCr8hd7jAVbT/bk/To+k2xzwTJqy+ESGI2AqNAI+gBS0CwlP+eJ+TGHhOHVrzuz2k8FXcTjJTTBcmDTt3FQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	V2MMcLT66m8IzoS2CH+k7SIgJNELelF7IvikwUvinBw4GJeoS6ev980Qq3GHN3RPfG4OhTR+Y5qgw18qL0PzDirSMwQQRN2zCr9nTKG6Cn9dPZer2P/Y056DaRrMoFIWkCpaXyo1Ubh+o0fYqZ2qGeSZ6LDMavtcV2VD0y1DAxPiYxWtqRS9pV6FygtwWw6k53x7o1NyJJpcMEo6tk3ZtccwxMT+KsjzEWgamlYmPVC+tNlachHP9HeB9OgJjRYPFLyuJ7VcGxlfZY+aoLpQZ2K28UoDBdbff3TQPZ0O2Fj0v7H7bZ0dtWpUFoP3E7DmXU9XkVOjRxo7TooCU6IYEjE+XTYpNSva9DiiHjHpRxEmUO85OSjSHfKYdYUAi8tXM+qhG8gQYSJHf/hqHREHsOGasD8xWf53ArFtxK00ZK0nHAIQAchn9PfAAvhiN972KzlTPjjdabu8Vqh5VYzYqgv4DYqQXqU5mI1MN45pec5s1KjG3E19q/x+D2TbzWnrPDfyKDLg+y6sobhqmiPBG8Tm4EPvP2cLhAlMyJarNxmFwXcGixug4aFffv6mtqmdnojgK12WGcHhMj3YtC9k5uI4E6SFy/tQso1Uk7bbOqM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f02ce33d-44b5-4b46-7ba9-08df21758a0e
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2026 17:41:22.2467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ov6a0kiWx5+oBhPajf9r9Wd3eBWu5kSflf6D5xjYzIMFwKQLQKXYitG5N/SvdjvgcxOQIqdHzKn87B9i582oyDdUP6fNZQhO5lFqCpXwNJQIa82Xe+tXE0U0C9sQ8QNY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5171
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-03_03,2026-10-02_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=691
 spamscore=0 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2610030070
X-Proofpoint-ORIG-GUID: h6BponC20dpNY98YYH6DJUxozzipsgBV
X-Proofpoint-GUID: h6BponC20dpNY98YYH6DJUxozzipsgBV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAzMDA3MCBTYWx0ZWRfX8l+k+QrxuVkZ
 8XdhqpuyK1WX2p3/zbVKc7cejX09qEGl2MGLMvKO39r/typcQFT5ZrIbyHpNhN3fXrUwowAZgEB
 EgF9THmfbFHYwBC6mlEFR4Sg+muLYZ/wDscj9FGvyPXcap63O9emzVIVteh66yx4AcjGlllIZQe
 wcDKYaLbgu1XbizRPi0R4CRtov8vSqfRDbaTfPTuA+InivL/Dj5UWL1YNh1rRYQNPlRVRT/s2Df
 jJwWYef9/WcU8Q4sgnl51JPQcSNaQjSMTLtWZUYZCLlzXjI8xtDmZFqG8GPJIsUQU3Jyuba1yML
 AxAM3vdpA90m8XaMXOHRc2pe71c6vbXMPbTMrz6Vv6+AWb4+pDonsxZAAJS1V9VjDTM6amlSFux
 OlFtleLX9LhzsWu9gyTs8llVpBcADlfU5vnLcGAvUcnDxHZwQDLtnz6r3hQPtI3GOy+DlXTZfX0
 JU0ZRBk/Fi7cU/aLJqg==
X-Authority-Analysis: v=2.4 cv=QbrzLcbv c=1 sm=1 tr=0 ts=6ac13e45 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=Fdxh9tp8LBzM7gfOoykA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAzMDA3MCBTYWx0ZWRfX8aI9WWQJRtWD
 DrRbnVMagsBOOfRgdk0MQnLIJgXyuehu5vd5hdey8Ol/E4GUKrcNo1Kql3gue4voc9drCTBOS8+
 08F9fql2FjLSq6TpmE7HwQOcHncpBUe7ElFxlN8g/lGon8anaMK3

Hi Allison,

On 03/10/26 7:19 am, Allison Henderson wrote:
> Hi Harshit,
> 
> Thanks for catching this.  Yes, d2bfdbb69cf8 should come before
> c96a5209dda6. The netns filter was developed on top of it, so it's
> effectively a prerequisite even it the dependency isn't called out.
> 
> I also checked the other stable branches. c96a5209dda6 is in the
> current review round for 5.10.y, 5.15.y, 6.1.y, 6.6.y, but I dont
> see d2bfdbb69cf8 queued, and 6.12.y (6.12.111) and 6.18.y (6.18.54)
> already released without it.
> 
> d2bfdbb69cf8 doesn't cherry-pick cleanly to stable, but I'll follow
> up with a 6.18.y backport.  The same patch should apply to the other
> branches as well.


thanks a lot!

Regards,
Harshit
