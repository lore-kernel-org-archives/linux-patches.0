Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0B345DF65
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 08:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789546163; cv=fail; b=JHCt1wxNGpCKtV6LmSR5pD1q0z5cHyD5e0tfKbcL+wfVJA9ief7yel65h8cYaLJ6OnFlWiVxJrNsT9ZN2VsyaYAusaj0RlrXMx4m/HOHIzERk92gznk78+d37YQpq9aA4mIM2VRsVZU6jkoFNHE4IxBnoW+d/ZkH+aXxYWckbb4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789546163; c=relaxed/simple;
	bh=nFEwDN19Kmy1GcrOTx+4OIoXhhfl33YKaRf9y21SSlo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=msn5XK8lrm/n/39MSvx7aq4DAUlBaW9/K76zvlLl3SR/BMtoTQVkSnvxv+7Q8sW+BY1MXEbIM0dDsYgmmWgYAWLs9uOAd7sxvskvctlD1bao8yyZDgcltBGBROZlikYOvSPmBnS2zeAQH6OjL68wH7uS86BYJtwbRtI8hiD6eQM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CLGOj3iT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=a1ZESXn3; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CLGOj3iT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="a1ZESXn3"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLXmxL700394;
	Wed, 16 Sep 2026 08:09:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IxQChEdZ/ZFyOntjUSggglkonUyBUF405+VOWIs/+2c=; b=
	CLGOj3iTc83idt7CSBFVg1BiCcitx5qB+aMa7KREBEo+H8zifMnb1S9k9+fDiJlV
	PQ+e9THysnUrQZ8Migft+uI2b4aiLrsngp/tUxrrmhFPH9opLioyMBMa+zYQKPKt
	tDwiqjfsoHoDv5sbyHJfKzWz7iqMtidfVZ+wPU0JxouJs8B8vCDTpLmZBgJ2dmzU
	vjwXPiczZRkl1Kq2RI8w/B/AyYgzFun3TYCOXtt5lhdabTuQE1uesa9x9339e2EI
	MI3hRkNE775OJ3TEyG9X5JBIi7VGnGl1ZHOBRTFVJtbhvhHoA1PTJgqepeE/m+Sg
	nlAKb/Dsu/MmVTmbFjobvA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmxm7d4rg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 08:09:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68G80NAf007010;
	Wed, 16 Sep 2026 08:09:06 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012071.outbound.protection.outlook.com [40.107.209.71])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6q2nuu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 08:09:06 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t1eaPpIIWu6/zydnemVgqMWsgG+XEi91eLsMXKI5PgZL0TY0XfcFVwVyk0HlT3anYMnXBW3EFb4RC0hhmLQeakHkiBwhcbowjW5rhp4vXjuBxBrmb/+vrUcu4klw/ylF2gLnRLWIY9R0DmfxfsjBXsNbbDuXNwmmW4UmuYkyWzYAfyNkkhdgFQ0mIbNCIw3ZSiZyiY0MJg03Wxxd+aYU/4MnI95MOiiEjDEM3NC4eUON3+FPK/rICreRsAiG6V7lUEPws/Vxs5RuVhw2lUUc+8lLkrPGQwYH8vbezTvmQOOBg2+F0G+lVfb+Jvh67Uj0WXqENm0JbzKY7wAJ5nhHUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IxQChEdZ/ZFyOntjUSggglkonUyBUF405+VOWIs/+2c=;
 b=haboDvkjkbBayDdHzLiAPYMa4LHEIFPRDIYC/4a2jDtFX/+JXhQmisIa/HvPCZpX3N7rNztLnDMofumQImdhVFnghB1d23T51+oG0ouV0zmbL9gJw4GhBhh6ItmrbAnzsgZOQhoFTSGh5de7C30/kaJbx7FQrfFw4YpBw8f0m7YSS+40fSAwyTIpWdnh475AAFB7CQU+fbg4V5NRYF4R6hp4RpRcGt+3o0+aHM0S9jT6DaUn2Mi1f63sO+GRZZs+CyUVwrUXs5TQBvMoUND7wUaxO3EJ3s1XrEgBw25M/ZPaMQulbpJ7dJmWT3aAqYwc0J3xdiEBYP7BvwI6lbrzRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IxQChEdZ/ZFyOntjUSggglkonUyBUF405+VOWIs/+2c=;
 b=a1ZESXn3vzKkY3t5kf59I6+H5hDukWMpVNqlOsX1BUwlnm8MqtUk4cAarNNs7Izceo7Kky6luSeytNIScbU5ij19+NM9ZH2ab0e/FuYH+86RubAC06tbaxOdXAPbXpWLXspJY2OM+c/UicmraUx04VoTTFPtGgz7gdBu6BxJ2iI=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by EAYPR10MB997903.namprd10.prod.outlook.com (2603:10b6:303:2d9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 08:09:02 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 08:09:01 +0000
Message-ID: <a5153eb7-6047-4034-80a1-fb3c0b70c9ca@oracle.com>
Date: Wed, 16 Sep 2026 13:38:54 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0951/1376] phy: qcom: sgmii-eth: vote for both
 voltage rails with correct current loads
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065628.756028552@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <20260912065628.756028552@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P265CA0006.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::11) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|EAYPR10MB997903:EE_
X-MS-Office365-Filtering-Correlation-Id: 863c4f20-ac1b-4453-5e9b-08df13c9c456
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|10067099003|5023799004|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	7THqp580LiQnSl06RN/3U/4p3m3LSqVAqeI+ujVTkioBtSq4cuI1ZC56GXU8j859DsV3I84m65WYBWACCZStqWWqwkUY5iYruHsD0wBTX+jlPbANgsBS6yHqOW78FsqRa5nI9DVB0HfQ9pm71DvPZtLRSFVsLEe7Yg31oUUdLFIlPqAjDEqrUuNqut/u1fKxxLQPn9qn3hU1f79AMY6Ak6iZdtFTeAHSn/Fh9uLTIyAqWSXYerqMZ2GCFoxjeUspCbBvW2E5LQnQACOsLRqpR9GBlPSmj+jAD5vcUaOROv9+6joAKDyR11bTKwFdEGqiQ0WJl3SdsfrTcm3894ySIVKxD3n3jmsmaPGukCnRkwP9LwSLw/yzSnNnV2bRkumgN9NQeQBwQ59dUYEsP27PQe7EuIvnJ0ZCphGV2fuLRnBNXVEIpQGfJLg9aDt3DF3/vfd3WL6lSXb3hycazpXnFD5RymjBJhr8/mxMa8rTTehexkXVq+v/JZrCVLbelyySVY1q/WkKOSBDpwxDsjdp8p7ppRxxgpj7P1/CXmunzqPUWUkji6WpoRgHukorI0GhK4Bq/TAdN9ZfwtemPWxZOzftu3LWf8iBxZY/2Uk2WqrQBSOynWSjw5JZeiJSutzy
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(10067099003)(5023799004)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eGhoakZ3Rm15LzUvbW5JdkVNaHlGaHZXSlk3bml6RGhrWCtDK2U2dGRodGZq?=
 =?utf-8?B?NldMU1hqVW5aZzFTU0tBL3JnWjZGeW1OQXpmaUIzdUlTWEM3UHNvd2dKMXRy?=
 =?utf-8?B?WTQyVUJxL09MakgycTBDZnRCbm5hQWtQelVlK08xMFhQbE1JNC9peExkd2FQ?=
 =?utf-8?B?UXpqWmRPbS9QVVlKZVg0YVBXUS9saVdTWkZRaTdqb093Wm9nOWJZV3BVQ01K?=
 =?utf-8?B?dXdvN0l1UGFkY1lIU0wvYkIzS3dYcE8wbkJOV0ZHeXVXQWM1VDNSWFRwckpa?=
 =?utf-8?B?WjlobDVmWEJFUnlkSHlVQ05MVXlhU0gyRFJ3cGJZeU5XcFkrYnRZck1PRlcv?=
 =?utf-8?B?Vml0MmF2bDI3Z1lUZmdRSkRNUStzMndDMlAwa1ltSTc5ZFRwRkhvVEZDYThP?=
 =?utf-8?B?b1R4bDlBR2l1WFY4SzFlcndwdklCemprQWIzOWQxeTREbmlERzJMU2Vvd0xE?=
 =?utf-8?B?QzYvei9uMlJEamxLSHRRM1JyeWVERXQwZUlyYW5mMEQ0N2dqQzJxbmVBR2RQ?=
 =?utf-8?B?bmFoWHM1K25GRFY3TmFUTzhGVmUxQTJ3Z1FxcEJVU20yVFNUSUxUT04wV1VV?=
 =?utf-8?B?TGJvZ1dLaUxFVlFzM3NhVlU1OTV6b3kvc1Y0S1p3WExkOStBSW9ibXRpRFFX?=
 =?utf-8?B?S2N4UzRuZEFsMUsyWnJpdFhPRnhjK1BjTEowL3JkWHJMWEdVTWNlSS80VFFM?=
 =?utf-8?B?ekhjdDdnOGtzSXYrb1h3TXlFTnBUNWRPZENVTW11YlArWFJRajRLb1l3M0lS?=
 =?utf-8?B?NU50K3Z2SjM5Rll4MEQvRGRZRFRuajJlRThXdjZZTk94eVNUdktuMWwrQlhD?=
 =?utf-8?B?cVl1VFZuUG1rd0daUDBIK0g5Y0JCZGlQandZOHlTU0k1TXM2dm11THh0bS9j?=
 =?utf-8?B?TE9Yc01EeVhqUENxMVVBekw1VnRlb3BZak5pb0hSUm81UCtiTDMzVGY0a1lI?=
 =?utf-8?B?MEU1Y0gvaFpWWmkzNWdHUVJmbzRXQ2RaQjZYcDF2MklGa1NzaDJoUG0rOFlj?=
 =?utf-8?B?Rlo0b3VZQlMrZzRoakhoZ1VBdWcrdFpIMnUrc2wramp0RG5KQzNDTlFzQ2U2?=
 =?utf-8?B?UlNEL3JWQ1FpY3Z5NnloaHNTY0JCTE1GWFlDSXJTOFRJVG54enloVjc2bkk5?=
 =?utf-8?B?eFpaQ3Q2azQ1S3RiNzR5ZjhoWXZ6R1JiVTMvY0hyQ2JkekNXR0pjWjZjSWY0?=
 =?utf-8?B?K3RVc055YzRKNDYyaW83a29qTUwwakRsajVWaFRaSlpPZElPdVVZd3FrZ2cw?=
 =?utf-8?B?dllOVWVORTBaNFlUSkZPODFxZ1dpYUlla2xFNXJiMnh4NlpZK2JNK2NGRGVD?=
 =?utf-8?B?cEtEaHk3MTgxME9VQ0RxeCtwSzducE5MVWpCWitxalF6cURTNXBMUmFkYkQz?=
 =?utf-8?B?Q2RXejFWUStjYlNmSTRwWmFGdERVQ2dBTk1sd01NMTI0cnBJL1dEdVc2OUdN?=
 =?utf-8?B?aHk3NnIwN3NVaXZsRVJ4Y0FkRGpUTC81V3ltdDdZOHIwM1NzTjB4VEE3b0Zj?=
 =?utf-8?B?bmsxUERXNElpbFl2Q0hrSUdSQmgrZGw5ZkdxWUYva2JjbzFwenQ3VFZPTGds?=
 =?utf-8?B?b003bkVpckM3Wm9yZnpwYVhZYk0rUlI5ZWQyaWdONUxTbTB3S2o2NS8rdVVE?=
 =?utf-8?B?SnNaWHRmcXVYRGl4cDgrYUZFQUV0TzI0YkltNTUvR3QwSTI5V1NCTjVaTnpE?=
 =?utf-8?B?cGxmRzhGUkJZZ3ZlZkdmNnJhSFdVZkZEUWtVVnc1UHdTNmhwSE5QZTVZampj?=
 =?utf-8?B?YkFQandHYmo3eW9JeXBiOGJ1dGhHTCt6N2lVaTlUQ09zY2RiWEM5NWdBQU5h?=
 =?utf-8?B?cTVJY3VRVDVQZVY1dGtNN1gxTGRuZk5NWmZWTi9zR21KVWJtakthalEwSXBI?=
 =?utf-8?B?RklCTGd5elhLWEorY0xMSHh4MUJUd1JsKy90RStIZTZCWEQ4bUhrVUpPL2xU?=
 =?utf-8?B?ZWg0bVY4c3p5eVg2aUFub0Zhc0RxbmVISkxSRWpVMWttUTdSQlpiWklybVp5?=
 =?utf-8?B?eEcvcTFSaWNQR3hUejVFZFFtaGs2QURjOVl6M243aDYzY2dpa1BQTkRwd0hh?=
 =?utf-8?B?aG00V3RObERYU1JCV0xLSklreWpDb0hlU3FPcE16dERFRUJjbHV0NDBFdEJ4?=
 =?utf-8?B?N0FsS2lUaDg5QzNIY2dXbWRFRkhMTkxjMmplK3g1V1ZBQ3YzWW5QY3grdFBS?=
 =?utf-8?B?cFYrMVM4b3JlV1NSL1RUSDFUcENpU0l6OSthUDdUT25kL2lPWHd1R1JRYmRr?=
 =?utf-8?B?Q2NFRWZ3WVVla3RTck1ENVozSHY4MEY1ZTJSa1k4dWQvYURiTDVwMkNGbXpY?=
 =?utf-8?B?Q2xwQlE4dmx1VjVXN2lOaEFGUlp6eHdDVWFvQ3BWQW1hOFMxQm0yMDFGTWFM?=
 =?utf-8?Q?7mSRNntKMiwQ5GjHVxGts/4bIS0Q/pSxviusu?=
X-Exchange-RoutingPolicyChecked:
	uqgup/CGre7/7IQxv+6Yx/nj9sx8sNGQRLY1Kvkfer1agebtata/8D4VsLJ0/rE5aV8oczDrOoXqVCfOAmQ/G88/MbQpQffsfJ+H6lgzdoOTL8U2tqaWjyyQPXW1g5MtDMIKEZjr/O3NiW7Wt90oGH9gonWLazI1/mWyX7kB8Z5R88QMJs/jWHyC9W/dgC+6XPf5f/pmjjyaA1NXuAcj7JOWiq6v9aWlgFCMIrsG8GkeeC+s3302SkzDSCngccsh2iptKXKil57TumBagAXVCPk4BxnqtCdN9rvZcMGboKpR3vJ7yQcE/05ledHJzu3cwmBuG4JPM6YgHj/pryTB9Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Fps0TM87bm2gR6TuDDBj5cWzQsxgJG32rMelgSeNgYVg/8AzZPXJ27l9ooIDSkoOsvbdj5JCKnIl1y6/FHYzzp/Am506NCNp9uvPvsiiF+mE2hSQr/PQ5Xn6558uMkpryzRV77O8p87KTFFHz88s5G0XQuRTJWB2cUqj6qfY2vPSQAM8Wv6Fnvhr2tXY+fbVQMcsvUY0+9fhozCITCrJpSDJVijOYhnjIqmIRMEuHO1byLgluWv2uLdba/L6PUXSzwIO9vEIx6a6Udxl56ZLxeEO9ftKeEbwPHao14f4qVSpk2NS8jXhsONwPvzQQPDnKLLZmWTdTzZCL1hi96+JePqLOXmMfyA3cCKqzvaEbvPN1kPagS0VFWNnZcTZSPWGCLbotkfY0g675fDOAwb8SOMJBFjYeXiSD49r2OHbFgFtqB8aG/u6NBuHptx7j+3ZM12bfWWPKNbIkrqc1y8NzPllRZo/7XjI7Xj71VxFBqj8b/qWjcF4sNBCW9jifLAz0dJfGbLJs3aQ3Hbr2y/FDpCVQ/2QyqCCBlDwQ9pahMP4FjqFlsa0GtRLgRnqLeEp0LJd4M57wegEnemIl+v+X0jw77wOcTsIf68L/lN6Aig=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 863c4f20-ac1b-4453-5e9b-08df13c9c456
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 08:09:01.4572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CAjeSv6d4tmUELg2+wG5GgMZydBdCoaPSvc9Wf+3jqz1ITye1t8LYj/awNtckQPQCOZPIJzXpHpkUttFKZ6kM5IF1GLMPY0Zch6w3QbpMtkkfgrkhNNMBWce59qgvJmn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: EAYPR10MB997903
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxscore=0 mlxlogscore=999 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2609040000
 definitions=main-2609160103
X-Proofpoint-GUID: od9ScawMpUgzcYSgqGejJ7E2dwRq4oKl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDEwNCBTYWx0ZWRfX1l2f3pJ3Dk9T
 ZYKmB2nFseC3EwyZjoucF+mS5yes6+Yzmw4EjRv/kRTDIZdGOWBLvTMVRm8dAveBK6Qso9Y7DXm
 es4Vj8l8Hjio9z8PUrkpCCKx1fRaINkJhCEEqhuccFmqf8/bDlNRywumBvHknGXG0UTJCZLnwxN
 LnXQ/DHXpjRnNDZQcS8vA2hYkLVavVGt0p6xqilfqcqja0kjZdhn3HhR8GBmkuGs0lRZHzTfMdt
 tIldMllPSDc2maqkVCHWr3+7CSGJhchumO24HLFI9N+qWwlYyNWSoTLz83fqwVPk+Ho2ae6jYyV
 7W9gPb2QyHTWKAFHWCaPdzIE2X6QcVzVcQUp1IQkfyqP3yzriWW9F5D3n8EksHCxOrb52Vhecyp
 fYBZI0awBIzCO6agtyIxrAGu0N00opbQD0PrqyfUSGFeC5KN52E2kvd+bv6RDb5UCeqWj0M9mEP
 NEuc6lv/kLAymJ4yujD/7ho3L5R//kR7khXD2lCY=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDEwNCBTYWx0ZWRfX/KRNZ66Vjqrh
 a/doB2bIaYvmQn6qENB0jRVpAn5SfR0wSh0r35fsQyOny8pLkVURz2+CPuNzaDykMv9KzDz2BLq
 wCPTwlVLJCgYAe4TC5N/eMvgsHhvSV44iZs+2V8+zRhpyDLX3IAR
X-Proofpoint-ORIG-GUID: od9ScawMpUgzcYSgqGejJ7E2dwRq4oKl
X-Authority-Analysis: v=2.4 cv=A/n5rKWG c=1 sm=1 tr=0 ts=6aaa4ea3 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=bC-a23v3AAAA:8
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=seAL3-kli0tCiXLZIlIA:9 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12107



On 12/09/26 12:26 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>
> 
> [ Upstream commit 4f81684a1d1018d7d0e5579f08d95e7701279358 ]
> 
> The SerDes PHY has two voltage supply rails, vdda-0p9 and vdda-1p2,
> that must both be enabled for calibration to succeed. Without them:
> 
>    qcom-dwmac-sgmii-phy 8909000.phy: QSERDES_COM_C_READY_STATUS timed-out
>    qcom-ethqos 23040000.ethernet eth0: __stmmac_open: Serdes powerup failed
> 
> The driver relied solely on the PHY framework's implicit enable of
> 'phy-supply', which only voted for a single rail and set no current
> load. Use devm_regulator_bulk_get_const() to acquire both supplies and
> set the peak current loads (46 mA for vdda-0p9, 15 mA for vdda-1p2)
> as required by the hardware.
> 
> Fixes: 601d06277007 ("phy: qcom: add the SGMII SerDes PHY driver")
> Signed-off-by: Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>
> Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> Link: https://patch.msgid.link/20260804-b4-sgmiieth_serdes_regulator-v2-2-c4bc688177dd@oss.qualcomm.com
> Signed-off-by: Vinod Koul <vkoul@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/phy/qualcomm/phy-qcom-sgmii-eth.c | 37 ++++++++++++++++++++---
>   1 file changed, 33 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/phy/qualcomm/phy-qcom-sgmii-eth.c b/drivers/phy/qualcomm/phy-qcom-sgmii-eth.c
> index d46a5e4df830a..8de0fba25ecff 100644
> --- a/drivers/phy/qualcomm/phy-qcom-sgmii-eth.c
> +++ b/drivers/phy/qualcomm/phy-qcom-sgmii-eth.c
> @@ -10,6 +10,7 @@
>   #include <linux/phy/phy.h>
>   #include <linux/platform_device.h>
>   #include <linux/regmap.h>
> +#include <linux/regulator/consumer.h>
>   
>   #include "phy-qcom-qmp-pcs-sgmii.h"
>   #include "phy-qcom-qmp-qserdes-com-v5.h"
> @@ -25,7 +26,15 @@
>   #define QSERDES_PCS_SGMIIPHY_READY			BIT(7)
>   #define QSERDES_COM_C_PLL_LOCKED			BIT(1)
>   
> +static const struct regulator_bulk_data qcom_dwmac_sgmii_phy_vregs[] = {
> +	{ .supply = "vdda-0p9", .init_load_uA = 46000 },
> +	{ .supply = "vdda-1p2", .init_load_uA = 15000 },


Hi Greg/Sasha,

I ran an AI-assisted backport review, and I have verified the report. It
looks valid to me.

Upstream driver code:

     { .supply = "vdda-0p9", .init_load_uA = 46000 },
     { .supply = "vdda-1p2", .init_load_uA = 15000 },

Downstream 6.12.y board code:

     phy-supply = <&vreg_l5a>;

The downstream property matches neither required upstream supply name.

The driver now requires vdda-0p9 and vdda-1p2 supplies, but the enabled
SA8775P SerDes nodes in 6.12 provide only phy-supply. Regulator lookup
uses the exact named properties, so probe either fails or receives dummy
supplies; it does not vote the physical rails which this fix requires.

Upstream companion 3719850f1b70dd adds that.

I suggest dropping the driver patch until that mapping is provided and 
validated. Thoughts?

thanks,
Harshit> +};
> +
> +#define QCOM_SGMII_NUM_SUPPLIES		ARRAY_SIZE(qcom_dwmac_sgmii_phy_vregs)
> +
>   struct qcom_dwmac_sgmii_phy_data {
> +	struct regulator_bulk_data *vregs;
>   	struct regmap *regmap;
>   	struct clk *refclk;
>   	int speed;
> @@ -269,13 +278,24 @@ static int qcom_dwmac_sgmii_phy_power_on(struct phy *phy)
>   	struct qcom_dwmac_sgmii_phy_data *data = phy_get_drvdata(phy);
>   	int ret;
>   
> -	ret = clk_prepare_enable(data->refclk);
> -	if (ret < 0)
> +	ret = regulator_bulk_enable(QCOM_SGMII_NUM_SUPPLIES, data->vregs);
> +	if (ret)
>   		return ret;
>   
> +	ret = clk_prepare_enable(data->refclk);
> +	if (ret)
> +		goto err_disable_regulators;
> +
>   	ret = qcom_dwmac_sgmii_phy_calibrate(phy);
> -	if (ret < 0)
> -		clk_disable_unprepare(data->refclk);
> +	if (ret)
> +		goto err_disable_clk;
> +
> +	return 0;
> +
> +err_disable_clk:
> +	clk_disable_unprepare(data->refclk);
> +err_disable_regulators:
> +	regulator_bulk_disable(QCOM_SGMII_NUM_SUPPLIES, data->vregs);
>   
>   	
