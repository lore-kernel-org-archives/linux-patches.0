Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1649C39769B;
	Sat,  8 Aug 2026 17:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786208915; cv=fail; b=tZ8RZHF6bizFgZtBYADJOZEANwoT2bIW6jabEp+Y2mQPz+kS4zxuWLvHb+Yi3RS+MzEpjFxD9aARMBVrpIfdPAt8TqkOoRdTbtL00JoaYS/Xpf/8Dop/yG/4rxVrlDw8HCu7y6SYgGvuQd9CJn9QdAz7FRRFbSTDYiQKduMYZwI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786208915; c=relaxed/simple;
	bh=kRem63i0WNqikvCdr77AH4Ga/4xJPX1yYr+1f7jfH24=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XvVG1BiyosMPuJNVM7Ox/IAORv3xT3bydlSlJgeF8N9gVX1YBH2R0qrLpD8YomJ3XidsSwYk1kSWZMV/7JnSV6pIIVp1HbmqdwRZYoXnubnY/spC2BMvZdzW3ih+x9rkF44DBYDvaX0AFK5EuHZHPOAg3rSMHtcwL8AS8h06z6M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ML/dkJNo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GmiZVjfs; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ML/dkJNo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GmiZVjfs"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 678GfWqW3863201;
	Sat, 8 Aug 2026 17:08:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=MHiIbN7gEnblgvDshhgyKvmnSNLBpZsg4kTWG/9Pzgs=; b=
	ML/dkJNoT2NfGeFa/psUQwv/YX8rtqrlqYU2MQR2dCKDXVUzxGUiPMyk8z0TCBEO
	jEbAgyAEDf2qGuNsJnJizYlhwO9opkQRHrc4EJeASMB6XVbvWSgEa6qkPfSIz4tr
	vTU9rWVtIjt4v1G/S1pE0GIlrA5DxyHx4BuN/4vp0bCOdiDr+FxsvuvUzPEMl9Jt
	PGmOP51DX3/1FWiV16gnD68MheHlLoBBb0iOTZmU8IWbGyKivg22T3YgariA/JNI
	+EFuDz/a6z2X3dDmwiNbx+FLImG2XfxHz2bWjgmNRpxwO/IYfKrE4qMzcddwyQYB
	9d3FPCHyJoU/JQRsm2G74w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fwvh28smd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Aug 2026 17:08:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 678H05E6028524;
	Sat, 8 Aug 2026 17:08:10 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010070.outbound.protection.outlook.com [52.101.193.70])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fwtwb55hc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 08 Aug 2026 17:08:10 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nkl8xbYvZR6JrzqdpWXNfkR3EDxNTtLV19+kYctbWH8ehYaR7mFld6eBk7C9rdrmIDuanCOq3Lc1w7kIWvE+8YSv4OBaJbBcv+7Ho+sBZ6lPoTvqDWHY7acSD2apDsUlJniyfqxz90L2EJRIJNzKD5QYauOqrCE+v0HCGUnbDdetf8Be//PcB41g7E+yOGyLjG9028kj9Cf+Ruhyrt8JLJlsWBAuPLOnKUGIfuIjsNe2ji0y6G2oKHWCoNVeoQM4Phrh3QVN9wvg/4quiMIOWaaZzLHnooJslbERdDUmZAALEhJwyIoQ/+TNQpE2Ncj0hgk56LWDVKr1ThaEp4lkfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MHiIbN7gEnblgvDshhgyKvmnSNLBpZsg4kTWG/9Pzgs=;
 b=LLl8km8oX2SGEr39QYpi2+XIKbBq/RyxDmWhWxa8jyzKbPx/HTGOHiMqm2BMlaLrkqvoeN9KYx9jbc0wA40jaD0vI5xhb72zyg8hwbKqHV1nqQrD552/DAGuFTCtoI389pLVGj6mImjBiW90MQK7yLnnO5urXW2M3sQCssByutJJETA4lqZTjjtDhDzFVinZbRDdSs7smg2L6IFkmg428woglcHggsjbOXdoA4WUsSeK+5cxFJMRsSpOtF6ahsZWrxa525Zq1T+YkSfyfeCkwKVFhf78g287NBCfv9nU+t7h/gRkB6Jh4GDKKEZbPDSqV0zAQa65tVkDgxFBzSU1Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MHiIbN7gEnblgvDshhgyKvmnSNLBpZsg4kTWG/9Pzgs=;
 b=GmiZVjfsyXUz39QwHdPVyxmvBCygbRsBRa4wbK6sBTG+2/IgYuxE+OTxNaEPEl6FXowpGLgpL1sBLGGYYnvmKD4/diNeOuq5bSR0jRYpRr076KN3+LGaSGRmuSLTQnjVN+GWgZAwkqPpijLlTK+qW63TGgx7N/bGABTGDdcnGk0=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by PH7PR10MB6355.namprd10.prod.outlook.com (2603:10b6:510:1b6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Sat, 8 Aug
 2026 17:08:06 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0292.022; Sat, 8 Aug 2026
 17:08:06 +0000
Message-ID: <5fcf1911-1284-4791-a678-c54c544aba27@oracle.com>
Date: Sat, 8 Aug 2026 22:38:00 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 106/337] Bluetooth: hci_sync: remove unnecessary
 hci_conn_get in create_conn_sync
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Pauli Virtanen <pav@iki.fi>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>, vegard.nossum@oracle.com
References: <20260807143418.516897842@linuxfoundation.org>
 <20260807143420.836222269@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260807143420.836222269@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0138.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::7) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|PH7PR10MB6355:EE_
X-MS-Office365-Filtering-Correlation-Id: 6969eb43-09ca-432c-91de-08def56f9d3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|5023799004|4143699003|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	+aife48pGjn8Seb2KFvzLMqOIN0CuUxdcSUHS7Qt78J8Y7iXbO5e3qk7WPTfCSxlmMo2/qSIQlC+3xQVNQ42uVcSqtTp++44lZ7GVi7Fu8lxhfVuxfilXRWAwYGP2g2FEy3J3DYrL3bD/6kyAeqgUcr3ToTR/XkWlgDUYMAh0cIwKJLNrVf9PkiREhAXnlzQbSw336FTozxjZNz4eG46IisV7vGaUNAfhWE91IRoZJKZYrBo7sNG3DDqM38kGBlyuhz1dqbbaQ7flrqVGWgJgq8kZLdkE0cjfpNPiM2yugI1KmTE+VUBl0DQSWY9quxyreJcLKCELKRWhL798Jh7rEQRxkxmjPsz0UpWCnKPngL1o3m+5ow126gwOZIquoJXhEl1+hVlC+h6CElQnvHd0cUC1Mw1sNAKra8oUhDxV3+N22/VAFDf+Xv/I/Dh7hE2jjnQDsX7Eg02oj0G7SZlCvXbgziDL92CmNVjB1Vypr2G3YEdSou+M5iGqlSvACAo8VukMekHuA8TbESbRx+35wvVBJVfBkK0SLTe220uMXFV7OXxSJf5EVkZYTqq9i9kFtTLnNerQ24ajrorJnuSj0GSTiDS1UI+EcA9hLO7btTuPJDTNC9hjhX3LcB7Q0F5EeV0y0Lhg9PrID+Jikk3AFAjrpCJ6Elf+PY9/pQKW6U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(5023799004)(4143699003)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L1g5aXBzbnRoMGFVWGI0OUE2U0FCeE0vd2NjaDBSYzBycWpxSnJCdS90a25u?=
 =?utf-8?B?QkRnNGJkS2c3VFZZMXhCTS9ZSnV2UzBScExaQ0ZzN25MTWVSWG5IV2Y3VXhK?=
 =?utf-8?B?QXQ3cmY2M29SalZqUWIwNkc2elVwWXpzeFB3blI0YkdtSmZGMFlEaTVhUFZF?=
 =?utf-8?B?ZHBhYm5WVnhPOVNjeHh3MmhqTzl2K0xxcm55ZmRSRm5LV01xTmtlRm5HRTlC?=
 =?utf-8?B?blFkUnloUXVmZ2lZNUVrK1BUMEpDWkpUYWNVcEl6M2JqVGtZMUFIcXZ0dzVD?=
 =?utf-8?B?R0ZUQWo3RnY4NjhvNC8rMXd6Mitzcml0Q3J5b1B6NHJ3cTh3Z2NUaVBid29L?=
 =?utf-8?B?MkJmVEo5d2ZtaEFyR0tkQjB5L2dRT1ZwMXZmZjVGYWdsemVSU3BuTVJmRDE0?=
 =?utf-8?B?UEdTejNhYi9sK2VqWVR5M2hUVDFlbm4yS2JQSDlEZzU4Mi9JbnA2djh0MHVB?=
 =?utf-8?B?LzZNWDVIdW9FSk9HWTRhODJmME1tcUd5RTllenJOL3VuTGNoZE5GaTB5R1ZY?=
 =?utf-8?B?WjRDZCtXN0RIQUowd3BXWUVzSEloVTJEQnA0UWVPVWJWTnJZcDFHYVVGL1I3?=
 =?utf-8?B?VGJuYThjZlNmUTlMeENRbktJRnU4blh6K3M2eFRrZS9PZHlwTTh1cWZvdWd0?=
 =?utf-8?B?OC9Nb0J4V0pUZWxuL2tYdnBaRTlET01CMHpZVmZmckRHZGY4SE4vNUxyNHJk?=
 =?utf-8?B?d2k2ZzVpeGZ4aTBiRmt6NWUzOW96czBvb3JmbmFuY2hjOFRsSDZOUlRNQnFE?=
 =?utf-8?B?UFJUVG5HRGQ4RVhMQmxHaVF2aHJDK2hTZ1cvSlc4T21EWWdidFpBY0c1V3gv?=
 =?utf-8?B?OUxadHFQczdCeDdSckZMU3l4VTg1aVljbkI1dWRzWi9MTFFWUCtFdW9EWElH?=
 =?utf-8?B?bFdlK0pJY01abHQxbDI1L2ZPM0tlcFVJNjdjTENuUUJnYnV2Z1NHYlFjcGYr?=
 =?utf-8?B?emt4NmU5S0NQaGdQRDVPUlppb1pvQjZpdk5ObCt3ck1mQ0tnNXRjWmp2QjI5?=
 =?utf-8?B?Tjd6ZlNlZmdiNXZ6dXBJSUUwUC9RMFg1VDh3VkdveG5KTU82VnMyZVRVc0N3?=
 =?utf-8?B?SHRNd3daZDJzQ1p2RXN5UFZIK2NGcmJXclB3dmNaN2VtUVdNYXhjT1I3ZTYw?=
 =?utf-8?B?ZW1CS0ZyVWM2bXRlY29ZeU9WZnVpcEZ3NWVSb0dxTW40QnFzanNITjRWNCts?=
 =?utf-8?B?MFZLRGZrbmNIeDU5ak9nY0FXRmlVUlFmdFVhRHFnQStwdzE2YlZYTC9yQmVS?=
 =?utf-8?B?YWc1bnh4dVJEZjYwaEtlTUlHU0lTeGNqNmJ4UUx6TWZJMXlac2l1TDJCYXp0?=
 =?utf-8?B?U2toRXg5a3M0ckdOSTlFc0RuOEhUMlBhbmlIc0o2c2VSNE1NdTAwbmc5Y2sr?=
 =?utf-8?B?Yy9IbFdRYjEwVld2SHNCZnppZTZnd3VUbGxQb01JZHR5OEI3R0FFSnpBWk9S?=
 =?utf-8?B?aEJzM25nUmpZVVppVG5oWk9VTzZLa2Zyc2NCV0lCUlZJa0dEdGRRMVA3RGlw?=
 =?utf-8?B?MlRTOElDRVdDQXA4SDlVTXNjck12ZjNVR2NkeVlybExPZ3JDMEwzYUdlMUhG?=
 =?utf-8?B?WFg2eEU1QXpxZ08va0ZiaWtFSEp0d0lwTkcrZ2FYajIvV0U1V2x2eXJtWGNs?=
 =?utf-8?B?aUhWYmtiWmtpTU9YWVB5WmZ6UUFYQklYaU04SEx0Vkc0Yy9iSkQyVkJ4ODBp?=
 =?utf-8?B?bGpHQTFXclZQdDlkUkxzY0dTOGlFU2ZkY3p1Zno0N1l5Y1VsT3h4dGg5S0Z2?=
 =?utf-8?B?RWZhNU1NWjBHdmUrYTBxcUptZzF4RmpFeUk5b2RPQ2JUNnlycDJmWHZMTklp?=
 =?utf-8?B?OHFjY3F5RjB3T3BPQ09NWWErREFUaEYvN3FGbGFXRVlMQTRPeStkUVFDSUNC?=
 =?utf-8?B?ZmU0UFJrLzdjTFZLNmFMZHA0QVh0OTg0R1BNeERuS3h6RjI4MnlUaHljMFpK?=
 =?utf-8?B?NW1IaFZCS1dIblZXeVQ4dHlYZ2NWV012VThuK01QT1VzN2hoOTRpRCt1WnNr?=
 =?utf-8?B?MHFLalUwOWcxN2lSVEhnRXdISkVnOUE5ZVhPWExrS1ZsS0k4VHh4ajB4NHlq?=
 =?utf-8?B?S1BjT0hNNXVpNEJEL2lFU1dNbUlKZ2ZYWllleWdGQzZFWW5mQ0xGb3VrVUox?=
 =?utf-8?B?KzU1VlJvR3p1VzZlSjVZeGRoV3RLalpJb0ZvQWYrby93MkNGVWM1MnFWQ1Jz?=
 =?utf-8?B?MFcxb3U5bUZtOGxaeGxtVXFCRXlPK2lNU1RFcUcvLzgvQnBDKzVvdy95MlQv?=
 =?utf-8?B?bXdYTzRXbjZaZ29uNk9HTEU5SExkdG9jbXA4aWZXTEd4KzRvaXFwZXhaL1Fo?=
 =?utf-8?B?UlBVSTBXVUw3QVVxcTUwankzZEM3aC81eDJ1Y2ZlSkx4di9UN1dLS3pUbE44?=
 =?utf-8?Q?aBF6qq9tD8IhYZGvS9aM9W5cbu84+LLGjMuS0?=
X-Exchange-RoutingPolicyChecked:
	r2NBKWpyOSASzrdMg5zFKam+CDbGHX/Ayx48riKHp3fnS1zrPXq65EGer0GZoL0Ir1rdn7+bodcAJUuY/2JE817rmCZgDGKhYKB2elPVRqTfCDGiNZgalIs2sS1O8R3w8f4qY7YXSTAuRUqAqnEhzVk3wQ3jPJa6JuBEg+II4nfyBKJ1Ru1LaIjzGi4g2J35ryNdsDcXu+r/6I2GVoAXJ40bBbBGcxp0TGUrqAJteA/QrCMe/UlB9cuEzgzJs7vEW3QLUPDWma5letTEUT9+R0LFXSIzymUt5k8ERUV4X9GGdw5xv06B1DSGjowObGszY64RuWSlDf4zS7uVvEI2FA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+nIvVWfweJgQ1jbm1rsMr89H2JJG39wIAFHO9Q1Q8yKtoUnVWJ2isUcIwmRJ1kTFg/dRrEu39yAZDUpEF90VXZ7Zik9Ls3wjQM5RAS/Pbend+sQLbEY/aVhRCQn8+gsSdmK+kTYiIQOmquc/mEcYF5Y/+f66Mogg5D9m4wD4J2G7SSC3+upFYPsW3R2lmeeRyrhdzWSGygGqPy4U9sI39Y6ASza9pDhP8GErX+xyto5nmWAYlLU5ixbUIxdBg5Zp9YsfCSByAS6SrSqLNTONG7yKGKwXNMj2wRWADxy0nGOxWQo3gjdHO2Rvm4t54KiYPEkwfCG+npuLItLibQFGAOJOL9NRNS4TNcCk4oisUste80UvnXC8rm5cNC0Yg8KR63OeKXbjQczfC8SxCqwNc+L0FgQYSM7g3llUT2P7aBCQC8bkKEicuSr3ekLmyap7Z6B8VVwWhHbd6vcKtrFPezPGqydonrMoNUGKZzMkRZt3utQBrThvbGFgh2RMhJBdZH7x/dtTqFVJMRTNNT9UsXLsgiXKstogRZzUb7N9K2NJnUrUza9yUimsFZFWZlYS+zoMuNaksWrG1bx+NCiOkj//j9Ms7RLaWlb6ykYZ0fY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6969eb43-09ca-432c-91de-08def56f9d3e
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2026 17:08:06.3568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q9Uhe8dXOTNGxiGQypgGTGb542Xh12Lcz7wLNvGvuqxr1WKAP7n4VIGZsQ/i2Aj/YGrh3Ims5KgWYE9WiPC5RUfAyQrZ+U9sgU4kB9v8G6mfWdSfCWuFoylN4VM7JU0f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6355
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-08_06,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0 spamscore=0
 phishscore=0 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608080146
X-Authority-Analysis: v=2.4 cv=M6V97Sws c=1 sm=1 tr=0 ts=6a77627b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=QyXUC8HyAAAA:8 a=P3N8bA_3hBgfggziVe0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: CmCecHJ5R-YzLpgJL1kTya11q_x7t9r-
X-Proofpoint-ORIG-GUID: CmCecHJ5R-YzLpgJL1kTya11q_x7t9r-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA4MDE0NyBTYWx0ZWRfX7Obk82LeqD10
 d4XdRpqGJ5n93IoQC7vttcxUKm/aDZ364OAEIch4BM0DjKBkhM+hUuLM30Xvszpxf7+JyKRjk6E
 hJtjFwBnj4+A8X1x1FHFsKDgqxVpF/qEOgYc3Z11v4VlSx/iXHFarfxt/xjRVWc0DQeDr3teikn
 Ah7byuDaWL+o1kUhZnaNb6GnObeRnHp4B/KRybVU0NHoN6mhz9ufyBtIQj4tKoSk2eJqz3QE7CB
 yh4de2pjK6nHKnVqXf67OL7vY1ZtGXQJP03TL7nRdSRGyOcPQEjXMjFxXAjwfmsyFNbwjQ2nYGE
 blNOAzSE+kwek500mmRdEQti1Aayl7IIRG0KyA5bG3IaVdFPUj89zJ5AxZPPatQtQEM+4jCN/IM
 Bq/y+1iu8eC6zKuKf7ab9ffteqHu18oQfiaaUHxEXN+NCtdH57Z9yvkFvgzfFkpKgLy+mqFDJM6
 7ai8pAzMaDkRPFCokeQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA4MDE0NyBTYWx0ZWRfX8T7Sgy4uG6yl
 t+31sgmO8eN9wK9KXLZA2MkusIr3x1i5chFQhsUm9ozSHFDhW12adp9EgajXpnJKId7xN2VVkQx
 SRkY9MN2Cr+Kfyxwjk8ihilNoSnODEu7qO2mXdb/4ghkf7dz7bP9

Hi Greg/Sasha

On 07/08/26 8:05 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Pauli Virtanen <pav@iki.fi>
> 
> [ Upstream commit c0a9dcd2be398eee505d4b254ec3a845aa8ab189 ]
> 
> hci_conn_get() without already held reference is data race against
> concurrent deletion.
> 
> In previous patches, the refcount has been changed to be taken before
> starting the hci_sync task, so remove these extra get() + put() as they
> are not needed.
> 


I have run an AI assisted backport review and it spotted an issue; I 
checked 6.12.y tree and the prerequisite change is missing.

Upstream first changed the callers to queue a held reference:

err = hci_cmd_sync_queue_once(hdev, hci_acl_create_conn_sync,
			      hci_conn_get(conn),
			      hci_acl_create_conn_sync_complete);
if (err)
	hci_conn_put(conn);


The posted 6.12.y state still queues the raw pointer:

return hci_cmd_sync_queue_once(hdev, hci_acl_create_conn_sync, conn,
			       NULL);


This backport nevertheless removes the worker-side get/put pairs. That 
leaves the queued work without a reference if connection deletion races 
it. I think 6.12.y misses commit: 2f5d635ad5906 ("Bluetooth:
hci_sync: hold conn in hci_connect_acl/le_sync() callbacks"); I think we 
have to either queue this prerequisite or drop this, thoughts ?

Also this is part of the series: 
https://lore.kernel.org/all/178517880663.1372023.9123649060094265539.git-patchwork-notify@kernel.org/

thanks,
Harshit

> Fixes: 12917f591cea ("Bluetooth: hci_conn: Fix null ptr deref in hci_abort_conn()")
> Signed-off-by: Pauli Virtanen <pav@iki.fi>
> Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   net/bluetooth/hci_sync.c | 13 -------------
>   1 file changed, 13 deletions(-)
> 
> diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> index 8c48d459a5415..03bbf4c1d6e5a 100644
> --- a/net/bluetooth/hci_sync.c
> +++ b/net/bluetooth/hci_sync.c
> @@ -6577,11 +6577,6 @@ static int hci_le_create_conn_sync(struct hci_dev *hdev, void *data)
>   
>   	bt_dev_dbg(hdev, "conn %p", conn);
>   
> -	/* Hold a reference so conn stays valid for the HCI_CONN_CREATE
> -	 * clear_bit() at done.
> -	 */
> -	hci_conn_get(conn);
> -
>   	clear_bit(HCI_CONN_SCANNING, &conn->flags);
>   	conn->state = BT_CONNECT;
>   
> @@ -6596,7 +6591,6 @@ static int hci_le_create_conn_sync(struct hci_dev *hdev, void *data)
>   			conn->state = BT_OPEN;
>   			hci_abort_conn_sync(hdev, conn,
