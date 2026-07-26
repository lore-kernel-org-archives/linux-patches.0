Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53246266B72;
	Sun, 26 Jul 2026 15:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785079661; cv=fail; b=AqU9Q1dww3cIDnA7wAtw/FNlCESb1n4cQgilsuJ8mo1VQbVNlfs1KpvUI8Q9iCHdcBdlxE7NH75BT7w2HiFdJtC9OeUR9G3xkYLc/qr9MBpop6WZAQx+S+JWiWf8DBK60KHDgLpimp5CwyD3g2r3xWoCNlOdXKrZRat8aUwrejE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785079661; c=relaxed/simple;
	bh=Xzx1p/8lJUiE8i73WztHv9RfVuqXvIOcJNbPTuGmdno=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UwmwQFigreFJefvk0IDKT9TYjXtIayCJ69LkMkAC1mbzog6tG5Tt+C3M/zCU5u1gJsnkAXTLhCt0BmMCUUa56Rm+pRBgN6Ou+2Ir3RUXXTnDdtFbvC94l5knMWc3Or0dOeBtMY7+SXOSkAYASb11N5/N3zLSEDI3aQky7/s712c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PMHOmXO7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Gf+PADLa; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PMHOmXO7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Gf+PADLa"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66QEcCg3156071;
	Sun, 26 Jul 2026 15:27:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=GES0Z3suB6dRERFoGS8Tt5uxmTsoEB81QlqYA/iyRUU=; b=
	PMHOmXO7b+w00GetG6XzYyktk4fTOJFYFiyGloEGDmID9s5cKbeYnFEKkqJSVQbk
	zCdrfLJWS+WKFbbYdST4dXRHmsxFOnHxGdcfxpdyVGjBbUQiF3aVLWQNhYINSgeZ
	WW8TfG7lHBoJXRJroDInH8UXqKVFJp9H9TpGiv5+HNXPmj2MbTXnoj1Dkyn9x9Xr
	okhfy8RYwA2vSZykhS3OKIICunIYfbd4qmqoBfcam1lRUQ1OVkUtxAd30ygVaLE/
	aODsd5CZsMhJIPnyPl8jeGImfYenIGG0tKl/sib7ye6NdzwF7AZDVxMsKluf1tG6
	Q8nCmHYS73u/CaLLnuepow==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr010v05-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 26 Jul 2026 15:27:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66QFK1bg024701;
	Sun, 26 Jul 2026 15:27:34 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010057.outbound.protection.outlook.com [52.101.193.57])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhegb6hd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 26 Jul 2026 15:27:34 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GYlJ3P32ZwjnL3VxLgaJs1eldkNQF5ZCc2KJ/ukV9crXwnXake1FzccOqjjeC2o+ImFq5+x7eaCjd3oF/6YCGGAUcd2YX8Idnh7KvJnAUKuGisVLuwzYBqH55fuAv2sflwEjUnXymv9gvBhryajMlP+iTvFRc7MJEloJinwSw1le6QyUPYmkJ/E9+YMQ52qg1VqeIkB7L1DQay7fqRlqITvLGxNmThcL6dtfZo0WfxD47k9ywr2TycsoxHcNLw6UiLgLVmEswXB5YFCQUkxxerd3p3rB/xSDO16zKPcIr5OBonDYHPwJCpvWf/cEfZZZGjD9HGQOPW94kR2IGecA8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GES0Z3suB6dRERFoGS8Tt5uxmTsoEB81QlqYA/iyRUU=;
 b=OD1kzfvYtifw1P5qUn636iN/qAnfZMwb7FW+Xyz76ndu4Ve62ERjjC59r/j5YUIKa9s/gSiJw0VbolSpexOKWE4tslMswilsbdi4hjUPrUKPIU5g6NuMt8UNsVHcKGd32JhfsMbkKlMgi1QNs5agn0Nx3i9WDPhxTc9xn9zD/wkzik/dGwqYmPhuSufof4d3Lzt9aetwasmuIQtPeKCorQ2q+ikOdIIf7vi9i2HwyJPGGsH5hGnm9Ngi4rsvRcyi6Dy0qL222yRyBv9YuUV8sZ/WzTPT5j2MaahX42NWGLvODPnCj/DND7EexC/wOMy3GgNZLgOr6xq3JI3dZtWPZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GES0Z3suB6dRERFoGS8Tt5uxmTsoEB81QlqYA/iyRUU=;
 b=Gf+PADLaCZFqqYyK0zatre2LAdou9Tko6SaAafmNAVX5uXbcbCTqIeHBa6KEj1kfKw2d8cr4/2dDAs14kToFmI0R+EyJnz9CC0t3fzCFQlQQgSSbcbsI+KC4B2pPcS5zeNmYe0w0NKriyoP54UYWGRngWUM6TLEQmyQu1gtw6Sw=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by CH2PR10MB4360.namprd10.prod.outlook.com (2603:10b6:610:ac::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Sun, 26 Jul
 2026 15:27:31 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0245.009; Sun, 26 Jul 2026
 15:27:30 +0000
Message-ID: <b7e82885-cb8c-4caf-ae0e-1494ad94ac9e@oracle.com>
Date: Sun, 26 Jul 2026 20:57:22 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0454/1276] drm/amd/display: Add missing kdoc for ALLM
 parameters
To: Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev, Roman Li <roman.li@amd.com>,
        Alex Hung <alex.hung@amd.com>, Tom Chung <chiahsuan.chung@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Wayne Lin <Wayne.Lin@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>, vegard.nossum@oracle.com
References: <f3983301-c8db-4071-839c-d153b7e0efbc@oracle.com>
 <20260725192000.stable-0012@kernel.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260725192000.stable-0012@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX0P273CA0083.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:5d::14) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|CH2PR10MB4360:EE_
X-MS-Office365-Filtering-Correlation-Id: dbf51c85-158d-435e-ab6f-08deeb2a6844
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|3023799007|10067099003|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	kxmQVAFheLmfOmLh0vg81S6Pzpe4ecdXesr9ZxlcfJcoT3uoH524oInVM8Oqq2kLADn5Y+FCdqAf54q7WmwOHNn/tx0mQ+DPgOrROQ85uLbGeI589n3Pj/vGlseHoBx1SUzGNjLrx3cN8GoakO52vNI8j4vxFWgda3KBYXG6LhlavlXUBBsjFPMzKQ4vQWfiWv/hzPC+2KikmhfIiX2rENO5f9XpWz7ZSBAIwv1XTPm/mBBsiu1AtvXEYY3fWfxnz0xXkHQjgUiDLb+jmO6pgED/jafweYxGvHMtCV/+CGp92ZuuMdYqEuh93I4RBejbl5nRS2BOZCBN/Kj7Vux39uQAht0ySue199kFFh3zSWHoQ+w6BwG46cwUNqNncrXQ997ThSn/9WDYme2QS0hqVUfhXAPqhieg/JSzSqNpv/nqnQ+dhHAdg1epGOWuPumrEQc6yCgk2/sXvpKp0TM+NY3QKKM/0kq296qCJQL4L8IGRbxRUahD5OMeIs4uIw8/bAWvGbj20M+/fCmA50ZyXFZzfM6jv3Kt18Qx9OKIH+VH7Z7PiZYmS1OTPnCj8UIFLvclEnFdwz1YMXUhXko2fC6r7wNu8n1pWyxThig0GII/YVaxHwFKxTXQwoaIaa0IXNeUuO8AQ9dnDQUinjuP//zOCT7ST/peI7bOMo+3KsA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(3023799007)(10067099003)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bUFNQkQvb3hPWHVsWVZSN2JnNmVwMXVEZHc4OVRzZm9CK3ZCTDBVbDlnNDdW?=
 =?utf-8?B?MjFzdVVVK3NtMWdncTZqVE1LZFBFdDhIcnZiZ3BSckNTc21zcUpmb0RoMEY0?=
 =?utf-8?B?bDNLQ21MclptS2poZ1F3U0pCcmdTK1ZVM2VJcm4zR3FyWURod0JSeFgxaTlj?=
 =?utf-8?B?TVFNNjJndmJ4SDRGWDZQMEMwSDNwTGRNYm5sOVBiNi9HbjhiUXM2eDVWaWMz?=
 =?utf-8?B?SFk1YVBTSUo1cWxUYnVWR0hrVFlNbUxIa2VFR3V3NGFaL3QxY3pwNjVtZlFY?=
 =?utf-8?B?UGlZYXd6Q0JnZjg1dHhnVHRtVnIvVUpqT3hHejZ2Tk5aUWJGb3ZFV1M3ZHF0?=
 =?utf-8?B?TWtGTy93bklpRVIzSzhueTBESFQ4c0xwSGhoL1NldC93OWFvUkphNzB6Yk5F?=
 =?utf-8?B?bUdCQXBBSEtXVHNkL0FWdCtlaW9EZzh5dkI1aG1rWjVzTERFVUhhUWlseVVD?=
 =?utf-8?B?elBOL1p6OThXNTJFcUpnZ1FNZE5ONlhGd1hiSVM5Y3RDUVdFZkZPRlVGWkxG?=
 =?utf-8?B?YjQ0SHRKdC9DQ1ZFTWloQ0NvaFA5MHp4TFJzRHBLWHE1MkZaeEdZblVia3Y5?=
 =?utf-8?B?cXplU0VDU3VzZGNmQzNWUXJpV21KUE9tcDV5ZlN4dXNUejMxZFRCdU05MG5o?=
 =?utf-8?B?ODAyRWJXRm56dVhDVWtCMExndjZmUHhQU2FMcitDZ1pRQ1BYd1JwaktYNFY1?=
 =?utf-8?B?UGJ4UE9ZQmwyNTlHaTlhQjhTVFJ6aGdZYnNVd1p2M1JSdlU0NmtCWVJ0N0V6?=
 =?utf-8?B?aG9tS3ZselgzZlhIT0RYNmFDSERLNWRHVHNUTXRnYzAwNjk2VngwQ3M0L1VJ?=
 =?utf-8?B?blpmR3Y4RE9lVUtQNTRpczdmN29mUENBbkx1WDhENTdOeXgwcmpXZkV6Q1Z3?=
 =?utf-8?B?RmJPdDV0QmFhVklXTFo0bC83QzlsWnExRmE1a2tpekZyRkpuUjM3b2kyR3dO?=
 =?utf-8?B?bkJmRnVRelh6aTVRcUNKUmxUM0pMbzhoWE5uRGZPV2FIR2lYYkJNUDlZaHNu?=
 =?utf-8?B?eXVobTFuYmNlb0ROQVlFUTFRVWVjNVZldytESmFvRkZ5Uno0c1NZbHlxRTRO?=
 =?utf-8?B?WXI3aExKTXJIY21BcXBpMVJqVGdUM3NMZEI5eVBHeWZZa09qZVJjWkU2WEFP?=
 =?utf-8?B?YkdMdlhVYWhxbWV1MmF3RWxXUGo1SEgrOURHWm12NHgvRmVBOXNEMTNEaFM5?=
 =?utf-8?B?QU9vYUQyN3dEamxPY3d3d2Y4TS9WZlJOd1hJOGRFbGZtWXN0dVNKRHFadDZH?=
 =?utf-8?B?Vk5OaTVwaFlzVm8vQTM5eDRjV1VwZGNxaExlYTZmUzl3L3g0ejRlQ0Nyc2RH?=
 =?utf-8?B?djlXVjBFL05TQWxaUmthejFzVk12dUo1UXo4N3l4VEg0bERiWnRnZFl6S2NP?=
 =?utf-8?B?OEVKMmtIdUJEcnluR2hSWDdQQ2dnMG1DaTVsU3RpTGRhdklGaHBIQldKSk5J?=
 =?utf-8?B?ZGdNdElwSUtNb0xJeUFjUDlFNVZTT3VoR1k1UUd5b21sa1k5Um44VEVBUThU?=
 =?utf-8?B?czlrelZnTEFuZ0Z1cWozbkVDQWFnYmYyVW02SDY5ZTRSMXJDdjJPVnZHRG95?=
 =?utf-8?B?MHBxSVNmZkltNUJGNkhTVEptSXBGakVHQWpMb2hUbkRwTjgxVW5hZU1LUlk4?=
 =?utf-8?B?akdyeHAvUWRhYkpQTUZlYmczS2hpVi9KWHpHMzdmR24zblZUY3dhY2EvdFFk?=
 =?utf-8?B?ZXNJS2tHMVlLcWNKa2ZLSXRxQkZkNFc0U3ZWU21pZTZCV3VxOXZBZ3FUK1hT?=
 =?utf-8?B?TE1jNG8wRGVQOWR1Nk1CVTRQQ0hTbTE4dFRTeHJWVEJac3U4M3ZiRG04d3Yw?=
 =?utf-8?B?Y01MZnZESS9pTzQxZUxGazhwYzNhWGs4dldDUjB3SzVpMGdMdFJhTGQ2NS9E?=
 =?utf-8?B?Qk9KSmZrcE55UG1tZzhBMkFQclo3aURjQmlsYnV0Z3REam0rNmZCUzJwbUlO?=
 =?utf-8?B?Z1JyUDJVUGdrcG9MUWMwU3FsK01kc3MxSHFLMFVMWWhwcnA4bkdONzVhQVBG?=
 =?utf-8?B?TDhCYnlwSS9oczdkcVNhdTN2Q2RHNis4cjZtS1J1UU5NU1FRVjhQdnoxKzVX?=
 =?utf-8?B?cnh1cVh0K0VoVitzbndLYlhQdG5Na0pUeWJHSHFlSERyT0VwSFNNRHlWNDM1?=
 =?utf-8?B?bWZ3ejR3RHhnUlBVOE1ycURhVnI1T3BuaUlkOEEyMGI2NUh0NEpvNGJ5QTNi?=
 =?utf-8?B?Nm11d1NvQUFuYUtmWEJQaHR0eHB2UlBMWVI0bHVGMmhucG1YTUJ0MXc5TlhT?=
 =?utf-8?B?UlZBclBaNUhndUtmM2ZQWnRqRVJtNWN3TWMrUkk5VjBmVkUyVk82R3o0emFa?=
 =?utf-8?B?Z0M4Qm9OTGpEVlBVTDlzTmphSnVIQU9YMVl0T1RYL3FZbVVoeWtHOGpDRTU3?=
 =?utf-8?Q?h9ZT8k00qq/D+nmXm5Uywblbza5uJ/Uj6zqvd?=
X-Exchange-RoutingPolicyChecked:
	JhneSTiOvtKL/cq/ASCFtfNkmu/EG6J65rPcKHzl55ZCQqgbwXvcBdXyW38VeL8dsZ2xZAq+87qbthH7+KAZIgs15IfHn5+OO23eEkiY7pJ0y2JkqN9ca88MyVIyV/4djGh4Pf6f6nbRK1TN2vFpV/WTU1sVukFiBqATOL8dPBKZHu1jh9sJKux6VEYkGjHj/UrT+jIup8zvsTwNaIPk/rKtXibpORAV/WK0judUOidc9zrYOoxWe6Zx01jGSmWbFDin8ardWxsP/X2mN3NyGAZ0rjks5sYUaLpdl0Hbw7auOo8l2HFd3CLFX+NXO9+jC4W2fKp44Z05kSDT27nTRw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	C9UDJujsdZqH3dv9wid9XzK/Ywxk1wR9vdwticncASICPw2IeMAYqLWwjGKYxVvh/f3eeHL+qEUC7RWPD6MU3spvbOZgpEvoKFiH5Z18E/ujAR0QD5FX2jc3tMaSbSejzH6vHYTTmk/xiemguQZaqxAKSC6HIPyPeDwnxzIDeYmFPI2bJ9reh4WrPPp3BuGefqtheckLcFP9cbns7N8a0QS/zkCcpuzUx9eBUbSfnulTw78mcinmuyK0clhF9BJGvDWJU0KnSF6i0v/IZAP51R3qYGPHWiOF2Prghwp4E+bC06Zn94ZjWwFISXtv5pBDXHLoT209hAuj8ORk4dASQan2pxR3XxR/X9Dhxs1ZDHM7xmbh54jto+rOMDPs85zuGteMGJh0KuusjgIyFuMU37o63MFOz/ezzyyjUxERCPcd72zLrx0M7OsYOQdItKeMOeRuv7E65QKNhzdKBbQBpLGohX+OmHozjo7XfGHKizrr4quLR1hJ2fmVf8E6z+Xfp/eQZKU0OYAWbe0s61Ctd89Q2aIEzTlefxjAR/3gM0XGAu6EUazt3BRAmU3f3aJXxVwCrlXG3DwI/lz9M+1j1BQIDtxishGeIzcrQ4W4WnM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbf51c85-158d-435e-ab6f-08deeb2a6844
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 15:27:30.6419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sTmlmmGDi6MgY/Aqc6oTLH6uljnl7nDWus/Be6a8fcRogbj4KTPGlaWXQc89opTY8S0jBGS/xREwakvb5OS98N/VyEsUKLedaI3Kg1flkUzvSCaJpDcv/BcOk5Hk7Oq0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4360
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-26_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=946
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607260156
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI2MDE1NiBTYWx0ZWRfXzjJoSvkhnWGe
 rHLzZXeOvHxMT5UVGMXd8CBSiBB4YuM4By8KR0HBHpmj0RpiQGPqcC/KJqe94SRHTY0AKKwnu3P
 heblKvx/agbgv4gMFpnci0rrUYZucexmSxzcmZyv8bcrx/IZ0dD8
X-Proofpoint-GUID: 6e8qaEbnCnZGnWiuZjXr-dyBryxLoYWE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI2MDE1NiBTYWx0ZWRfXw+I+9ZWv3IAt
 cSlVsgw9g/BZ2JNCBvPfxYYHSbEIlJ34ShkN5DIooQBLG/A8t0BvoFNkBLelBwAb6/vpTzJUPmp
 GSKgAfJKWM5UHdbmwZTCTafT/73mf2FP+ZViOukjeYInvZqy94b2IG+GTJKUsEf8AN5UG3+dI6w
 NfL4Syq/77vMrtuA1fjxLET4M/BS6pex5isWkkFl1CUcn6NDFCz35E67g+PKbkZKIP8l1SkGMdb
 vqNVpnZMjOpJVNci530LqKG22SukRkgYsWM392M//aRa8Hh60b1uEewsr0U4+4+pf7/v4klcUeF
 +0+DJw3EvvEqbUCAOpeJXl2v2Q1dY64FbymBl24mb98WLyv3+aa9w/o0GJPc//NPmllnS/QlgBz
 0WlIDiK2h5kg/6ChcmGYe+HvRAwXfxgtwcJAGFqSvKuWiMmY2HjqEWvzGrdVGUYusDOl4SuPPkJ
 jW/9uQvHlivKy2Xwd2Q==
X-Authority-Analysis: v=2.4 cv=KL1qylFo c=1 sm=1 tr=0 ts=6a662767 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=duqn0EyUV6Zf-hCII8sA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 6e8qaEbnCnZGnWiuZjXr-dyBryxLoYWE

Hi Sasha,

On 26/07/26 5:34 pm, Sasha Levin wrote:
>> I would suggest dropping afefa5685cec from 6.12.y. Also this is a
>> documentation patch and not a stable-dep [...] so lets drop this.
> 
> You're right that on these trees mod_build_hf_vsif_infopacket() still
> takes only (stream, info_packet), so the added ALLMEnabled/ALLMValue
> kdoc documents two parameters that don't exist and trips W=1. That said,
> it's a documentation-only change with no functional effect, and the same
> backport is queued on 7.1/6.18/6.6/6.1/5.15 too. I'd rather leave it in
> place and accept the cosmetic W=1 note than churn a doc patch across six
> trees. Thanks for flagging it.

But this is also a documentation patch which is not really adding a 
functional value and with this being incorrectly backported, should we 
just revert this ? Particularly asking this because it is a doc-only 
patch and not really a prerequisite that would help other patches.

thoughts ?

thanks,
harshit
> 

