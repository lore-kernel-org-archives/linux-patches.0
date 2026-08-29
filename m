Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6043F106C
	for <patches@lists.linux.dev>; Sat, 29 Aug 2026 20:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788034104; cv=fail; b=Ep2WzEq3kZPhIJxBZljdeso5ljtjVIZpT6ESVTHSWs12U84pAcvarUZg1HsYi4JKKONWcq5lSoKrcqRPFRsY91IWohsZ3C5SkD5RYaTrh7Fevj7OflaL4RiNJWmCuUVxOuEgYz6T1iIhNTfiOZKSwG5mOgKQO5yJABZd2aZojXI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788034104; c=relaxed/simple;
	bh=hgAaooE/khwz5NZaMyjZuILPZr0Q75h/7MYgwFHWLeQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Jyad4uiPPa3qAsmgL3UhUFDMggT1JLGoJQZ5NP8Rc28N4ehngUDwe7wOoFqd18SAZte9AqqOWPj8mDGn+YnrPrLWbDDmQrx3AvWksj1wzA9Z7QJn/jnGOUZNsaSUQeHmL5n6P4EUfy4GCDmuL+WUOaAVVdv6PogzVLiH3peEB2A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ig7yUG9Q; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=obQE2f5J; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ig7yUG9Q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="obQE2f5J"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67TJ7gQp1503726;
	Sat, 29 Aug 2026 20:08:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Rr2LyrtwAqGTildy5uvbelWGSwkZQrBk/gNw9wKHOGY=; b=
	ig7yUG9QIjc3eSKh/EXsgX0/HSyE1PhbsxYCrU9ZzLKu54R/WkFEhkF3QQ4gUkEn
	6MXL00+Whehgevcp7fGpzkAq5Yww6vCDRgmGK6uR7v3uxBwGFTHFkpZReTTgdCzt
	mUBfnvPjVMWc1QWRQ0SP72pyoSgfzYows90WaW4psnOK1RAtmhb4ZzEwzR6Xqu4A
	UDNIajXA3+pemtBwQABXmGAOqfNKLOCt3aGRoL0i+ThmzLFjIroqmo2llDQhTT1w
	4WVzhaKDuY0mcNz9N6qyba8m2uziyxDPSDKZH6C4NivS5TbKEPukafIw/TmizQF/
	PDUagQM6ofJFXWuDyl52qg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbp0xrkw8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Aug 2026 20:08:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67TK5Xs8028051;
	Sat, 29 Aug 2026 20:08:14 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010066.outbound.protection.outlook.com [52.101.46.66])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvmx35m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 29 Aug 2026 20:08:14 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LaLZRz9oZX4/UEapIG8JLG/13fDqzPz2RkoOcUKpgcU1deH7HHTE5Il3QL1QkgFjX3INp6itbdId1UYZuIRNbuIy32Y3POcLyKfpJYYNAJAhxH7odWEHLk5jbZ3ducJkU97jZktoHWg0Rlymf+Wkv7dgC56DPYTdj4V2ijexYUWV386UTKX5kNRpeN/W1IntkgwmAuQkZEZB8u+qkO9+u2TF//SjPzU/Xbvlbxg7+sZGP5zqT8c5XDWwmtu1Ab/fPjigW1F1kA3jTtwD7FtpwiMyZ6JL/SnqN+1SOlGlZXx9P1ro7aYhiiM28FRGXqSKA7/D4R/Axqp77+JrIpyjog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rr2LyrtwAqGTildy5uvbelWGSwkZQrBk/gNw9wKHOGY=;
 b=PHYC2SKVTk1xzJR1SX+E6PtYDuhgjGULy2TeNpiUrb/Z4sGs6hDFlokxS9UxSrnPPWZ8lN7O1lQxh3pOjcT97HnuiLVSIZCgu1rgkDS2dvRUr/yXj5cvuU/w0rUuJl2dOsZZKEuh07/pTQodi+PUAQRvSxWvoqdiAIKcpxVgz5+jzDRRtQis/7/mBrbQLSuFs635F0XSscR0gptQpp+SJZToBbuki3R0eSa5g9lHtTGoOCCJyhCWnrlyuBdmBrvzVfoda2DQIgbDhNNI5Y/86lZ+Gf88pH0K7aMQTDNyAA8M0Qu2b4ojtpbHZUThs9ZBeOQyy1gfjndWbIlPf2J5Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rr2LyrtwAqGTildy5uvbelWGSwkZQrBk/gNw9wKHOGY=;
 b=obQE2f5J/JnpcUICAPzO+NJCc/d9x1ZbiERrs4r6LrcTBYs+lkTGEEmrXYDxazfz5Q2nQx+/rJS4jBxtyIESODAXbp0jTZEjaMQpEQVBydC3n/6IjxllYDgLqbgwkD6mZQ8CKlaruYdMVAjxe7vpaUZhK2fxj5yDNlHOTdd1AqE=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by CO6PR10MB5587.namprd10.prod.outlook.com (2603:10b6:303:146::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.11; Sat, 29 Aug
 2026 20:08:11 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0382.007; Sat, 29 Aug 2026
 20:08:11 +0000
Message-ID: <8734a305-5f47-49fc-9bc0-3fde57ab23f2@oracle.com>
Date: Sun, 30 Aug 2026 01:38:04 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 134/220] smb/server: fix minimum SMB1 PDU size
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, David Howells <dhowells@redhat.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        ChenXiaoSong <chenxiaosong@kylinos.cn>,
        Steve French <stfrench@microsoft.com>, Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260820145223.480031205@linuxfoundation.org>
 <20260820145227.494758057@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260820145227.494758057@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P123CA0018.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:ba::23) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|CO6PR10MB5587:EE_
X-MS-Office365-Filtering-Correlation-Id: 91e750cd-33ac-4228-ff1a-08df06094058
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|10067099003|56012099006|4143699003|5023799004|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	8B/t+vMj3kBSLmIdRM7ZQelR/9rxxCb58t+2KK2fTQ1QTlK5y8Tn6nZZV6cleNlA+1MO/3+XZOFOo3Ln2KTCReyai3LhoTyjxfnseoKVVAomsRod6Auyya7RJXjUbJRoFR8hpvMPp+wWvxAYEeLNOtMoMtlGd/5ECCXacd4NDyaLFYzHv4LlyO+l26jf+HDD/QW/h6QnjBub6fFJJwC8qS528d4kXvRtOYEIrJrMAutGayf94wpkQkFGnmIGeC2Wx7XxHR6erfIfyPt/z8xBKEL29+SOxAzYA59S5TDjqYrWeBs7YoUkJy1mzSPGFGomJ3tMC0uftuxNsioURy1hj8SNlUgGiqDh7PlUX8Oj/mwGaK2r0s7pA0MFekfpVyLvsB3vVnSbakVMIqOclkUxHAmRBkMx43LgNh83N01mNjx6VWsLV0+mGGN0pkp9hFeY/ed7wS+9YPJXAIPnkJR3ex3WhIS1UAru6HKqZHeVqhzVsIcgat/2TZtvRyjKmTWHPkfm4CnSbcnepL3Ar3BRGXCq4i7Ilbyr+xaUDE+JiqykRymCemT2gacBy9Fl6FH/RUwAc+THL3lmauJA8ZxWUVcbwRST3kCLmB9ToC7anzTghFeTLREngFEKt6ds9jNGX9y9tT+YUEt83QtUopUUKhLYFKFxaH+9/D1KgRY2F3c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(10067099003)(56012099006)(4143699003)(5023799004)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dEZZYWtMb3hsSFYwR0h2U3pVQmhOalVqM1lidmlQams5TTdzUDI1ZnFEdkJ4?=
 =?utf-8?B?a0ROWEFFWE82c1pFRjJ4NHozbzVjajhpVWJTWnIxNmZKSTBjVzlxZHdVbHlB?=
 =?utf-8?B?T2FnV0FOTUpoQW9tY05JUmZWTml2M1RKcUpPb2lyVXNFbVpYTjNMQjZ1RkFF?=
 =?utf-8?B?NUd2ZXcrTTJWVGVpTkxuaXEvNGFIMGNHOEROam9vZU5sOSs3bFVtaTgxTTNV?=
 =?utf-8?B?SWJtS0dJZnNpUkdGZTdxUGthS0lzR3Y4emFhV08vYnpVdG4xTHRxOUREcCtZ?=
 =?utf-8?B?R0VPT1J4OUdrblc4OWJDcXRNWVM5Q2JTNzE4L21uSGJzY05kSFRYQU9URk0w?=
 =?utf-8?B?NmFBajR0V0FXYnl5bGNET1U1a1NGbXJHUExqVmZsdXFqN0F5SDY1eEJUL3VV?=
 =?utf-8?B?b2srRngrdllRbXN0RUZCNk5zYkZsVUhYRk5oaTBESjBOcUVZRSttVWI3Lzdp?=
 =?utf-8?B?d1BqeU4zOU9XdTVybWpSczRtamVuOHV4QVI2ZDZUaEhqandlR0p2amhZcjRL?=
 =?utf-8?B?OXQ2NVloNjNMSk1aeFNBbVRtUlRpQkVJWE5QQUNuL0NaRkxjZTI1TDBJTWtE?=
 =?utf-8?B?djN4OHhwL3h0eklRekZmVU85N21BejE3NFY1QVZUcG1YTmFWbzc3b2tKdDl1?=
 =?utf-8?B?ZWxMa21ZTEZIR2NxNTkwUFFiSmZLR0V1K3N0L205cFVCbVk3T1ZRbkhUQk81?=
 =?utf-8?B?UE5GZ2d0S0MwU3llR000MEtWeUpWVnVJMFlMMTJQakxFM01aejBOdm13QTNC?=
 =?utf-8?B?Qk9BTmNtY2hEMG5zajUxYTdHbDBuT2MybWpYcktMaTlTV3Z1d0dETndXcXVw?=
 =?utf-8?B?eVh2Qnp4TXc4THRrYUdLYmVDMGZKcVN4SFFIVU9jcE52dDZGS1hySmdWbkhv?=
 =?utf-8?B?SG1EUGM0bTd5QWJkQVR1WVhYZ0k1ajd5c29nYmtrM09XUkRpUHBQTXd1L2J6?=
 =?utf-8?B?WU4xWWpxaENPamJZTkRsSm1RZkJ0ekxJWHpnOHFDWUtsaHRNVnNOSTJJL0xG?=
 =?utf-8?B?THgzWEtOZnJraVpRMFgwdGVSNEY2ZnJ0ZEx3WU5tWXJGRzQrTzZBV2RsZG1a?=
 =?utf-8?B?VktxZVR4WWRwR1Yrcm5KdTVhQ1RFWGEwcHRhdVZoVXQvd1VOZ0o4alBPQXpp?=
 =?utf-8?B?dXN0SkxGckpBOGJxZStEU2dJVDVLL25hZFhxMXpZL0svSlcybUx4cGlxL3NZ?=
 =?utf-8?B?ZGxOQ1NBL3BxZE5kUVg3NWxNVHdWZ1FCeVJIYWlCWjE5RWdzWWJ5Uzl2d3Ri?=
 =?utf-8?B?eE5wMWIxVjdUWGoxdHF1eEU2SytNSzIyUWV2Qm1UUCtOMUpYMGFNNzZOR3pS?=
 =?utf-8?B?ZTJmZjByWHpEbjZKWHZjNmlvMXpSZ2Q2N3MrT0lUd2owSmlOVFl5TFdyR2xn?=
 =?utf-8?B?L1FobUtTb053UWYzRlVqY3BlMUFDR0hrWHE5eWEydGZ6a2VlQzBGUGtYaFB2?=
 =?utf-8?B?OXdVQ0hqbC94d1hFcWp5QU53Y3pKcTlrVkwrZy9jQlF0eStnK1JKK3ZOcmVG?=
 =?utf-8?B?cmxpOEZIbFlOMnE2NFNIUHF4QjFNME9sWHE1ODdBaEE5bGU0TzdPYVdTS0Nt?=
 =?utf-8?B?VXpXa3hPS1NhbW1jbThoV3ZxWWhwV0g3eHc3MkhScGZJWFJuTWdOV245aTJn?=
 =?utf-8?B?cGhoNU8vTUUzeXRCdnlrNjE3MmtkRnZpNVVJVHE4d0k0ajVaUkI5ckVoUUlD?=
 =?utf-8?B?V0tvbENlbDlPTjBJbnc5bGtjSlpFcDZ5WHZ5TUlIRFJPVnNtV3gvNEYyb0Rp?=
 =?utf-8?B?bC95R3dSTjBSTnU2T2ZtZHJSMTlCME5BeHYzRERoZEFDdE8vSG5hanBMOGt6?=
 =?utf-8?B?anlWZjREUWVlSUhFdGZablpiVi83RTJic3NBbGRFUHNkL04vYjB0ZExIbFRy?=
 =?utf-8?B?NFZPbEl3K0txZW9vNy9COXVhNERSaXFqY0l0T2gxWW5jdlg5NTd2cnhhWG9L?=
 =?utf-8?B?LzkvdjlldG1zZFNFRmRyamFwaXZuZkZTS3FZU2Zpb1NWQURsa3dNdjFZQjd5?=
 =?utf-8?B?T2RTYmxCVGNKM0ZONmFkTnhRa3FCQjZNUnNYaUxvdER1Tlc4cFR2SEU1cHhk?=
 =?utf-8?B?Q2RLVTg5VGo5bGtvTFp1WFlOSURtVnI2bHhjOUVRLyt1c1FCN3ZORjRQS1RD?=
 =?utf-8?B?WFJNKzFZZTg1WXpFVDBQT25PbVQ4T3NVWGZsU2pBQXlySHE4TXFNR3NpYUVU?=
 =?utf-8?B?dnJFYUtLSlB4Z2dqSWVCYVhzeS9meldVSWhEQzJqOTZQNlJ1VmNobkE3YTRO?=
 =?utf-8?B?ZUNIV2p3ZVFoYmtId3lVZERZM3NGZVZrVDdTeXFzd2RIeXluaXJwd3BBTTNr?=
 =?utf-8?B?VTY4cHVhd2JCTE1LbkUyaVF2NjVoRS9YYkRuc2wzdTltb0dRNXVBRURRUWll?=
 =?utf-8?Q?iVvlchh1NbefYY/FdgtGI20MHwjjmoB/BcCx2?=
X-Exchange-RoutingPolicyChecked:
	NpwgvT+PYYzgqv48/cyTwsu/1xPc8S4lMidbFZ70AdPQg32wPpzcfct3TkvLggvvx9kqB+DDb9caJJF+pvQqtru81wEsD9KOd7cq5reL3phW7eg3aeugHQv4kOUtOg071sdjoGJTZ7Mp5RjM/YIUuau469C88pSbUADA/6jk68t3EfcpeBzi98B8HCEtxQHtbWhzl5HvCTL7NqLOFsKpD3aHTmrWEbXoSy42AL+tnti98qeXrVH5Bdyt4ZM6LA8nJIF9e5ojbUlpU3dD7zbMF2JH+on4pKzmpdqWLtKmymQ36guuwbF3rpLj8FfRQQsDGf3nxPh4agtpQYHkefFCIg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OI1QkZGT0LBE3hHTKU6q+n90q85/XgdipjBdTIvyltEaU578HQnLHJlEpi80qqG8fbA0ors9wh6oVyT5/MxAEkFTrRfdgccQKs4bW91oNbWWhK+sjyLFNoYvuEDnPhLiFHv2n1BYHkZsJ5D6+CwCzRLKMkNngP2ajWc1DeZl4DbHJDWZ0etfXnwLAZ4Z8YIOaKEuGCZXJkZF8MsvUysD08gCNk0kiU+SdS9NPrz6JjrOmMcqiTnld2/jEiSHI+0gqBixBfjMvgo007mKntgYwQFQuMGSN7/Z5dqZEveKQXqyPFEgXcxWj31UnLL2Y67NbUNWTPK+gKg2CasAVhSuAcfFLUHxfZuK5Ci7WN6/X6VwFY4DPItr+zWXC8Qcxt5SAE4IaNow+HdiyBrQ1sWs2T+anCYwI2zaTafgqrRDe5D+sG5fBwV4VRMRTBqhkaO4CvsXsjO1syjgmRapKaUFE5IBayvGH6mWzbLsk1QovHL+dPT8DJYheZSG7zhl85wl+Ix1Gvyfj6sNimaTLr/3b3d85OK4JCcmklpZsL5yfDNX4PL7q4UHpFaWmkdAXoe3SVH9KvFdspdznvFi9nuXgE+dSuplkgXsNqssHDQteBY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91e750cd-33ac-4228-ff1a-08df06094058
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2026 20:08:11.4680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xiBf1jgGwof8/AgaLzk7abwuAda14ZcvHTs7yhVxhix6zksyniDOv8MJ/TwSJ4+TxiwAQS0xYGRsBHmHRG2RBvmMzniguwcBRi4OCHVMrWvfS1ZDBV5c4LF4SgmfVcKn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5587
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-29_06,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608290174
X-Proofpoint-ORIG-GUID: KUK-FL_XHi0wGsIlxNn0NbigGJqk3QOY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDE3NCBTYWx0ZWRfX5+lkE9dNVKpt
 fuE+WRLeh7NmJ4TIqxx/1k3hnp+EKA93zdRdKEEpwZ7X0PnpO78p+mDLBqqdNXBKQc+NN35avP+
 W7XL8VenhhUMlkwt7nwtWk/Ih5yXlNjuvQzaxopW6I5wNN80uvMV3lDYIb9ObZi2OcbZ1FChy/G
 R0kS+TJrpRTuNU98dA/LkcJkcxtTLSFdmHJ7bSeB16MAbtO/ZRkOzlhqP5VxmBaEE+4Upis64/g
 2kQi+yXUkrjhyf4SChLSNcQnHuLkIneQxAwEYbjwudIONs8fBQPayQVrZYbGb6PB8U3uc5GxLMH
 pZNsImr2Cf9ZiGzPQzXMnLbrllqy+WgEYpDg7z2dz0b2SNQrk+vIKoo+4nBj1PMDUsu+D81atxf
 FMl9L0g7rV3TKY1KdETr+sltG5qVi7b34d93XmBwXbhXTgjVpzJV8/duRypUm2bOwpzjCYENidT
 v2b/55wKZn6krwQStfuWXvmGsIe7jK7L7htJ+uks=
X-Authority-Analysis: v=2.4 cv=Ebb4hvmC c=1 sm=1 tr=0 ts=6a933c30 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=20KFwNOVAAAA:8
 a=VwQbUJbxAAAA:8 a=yMhMjlubAAAA:8 a=ag1SF4gXAAAA:8 a=g8cs7IJReAXlplDP4Y0A:9
 a=QEXdDO2ut3YA:10 a=Yupwre4RP9_Eg_Bd0iYG:22 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12102
X-Proofpoint-GUID: KUK-FL_XHi0wGsIlxNn0NbigGJqk3QOY
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDE3NCBTYWx0ZWRfX2iB88Cgaw/02
 eq2iwBvPiAU40yOXGimTxJ0T9spq8fd+DO3VrTWA9xW/xt/R0R/L2m2dkoRZuxkcFXu/MeCyUvQ
 xwAiZDu+CM2IAWCOTGn/tLa+ERgZZjtiYwUCcT959QtDJ6gy+8rS

Hi Greg/Sasha,

On 20/08/26 8:25 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> [ Upstream commit 3b9c30eb8f5aaad4a54cdfa470b74c0467cc71e8 ]
> 
> Since the RFC1002 header has been removed from `struct smb_hdr`,
> the minimum SMB1 PDU size should be updated as well.
> 
> Fixes: 83bfbd0bb902 ("cifs: Remove the RFC1002 header from smb_hdr")
> Suggested-by: David Howells <dhowells@redhat.com>
> Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Reviewed-by: David Howells <dhowells@redhat.com>
> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> Stable-dep-of: cfc0b8e5080a ("ksmbd: validate minimum PDU size for transform requests")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I ran an AI-assisted backport review and then checked 465e7e8a68af
("smb/server: fix minimum SMB1 PDU size") against the upstream and 
6.12.y receive paths. I do not think this patch belongs in 6.12.y.

Upstream has an RFC1002-free struct smb_hdr which is 33 bytes, so:

         #define SMB1_MIN_SUPPORTED_PDU_SIZE \
                 (sizeof(struct smb_hdr) + 2)

correctly includes the two-byte ByteCount and produces a 35-byte minimum.

In 6.12.y, struct smb_hdr still begins with the four-byte 
smb_buf_length, while the receive path does this:

         pdu_size = get_rfc1002_len(hdr_buf);
         size = t->ops->read(t, conn->request_buf + 4, pdu_size, 2);

Here sizeof(struct smb_hdr) is 37, but pdu_size excludes those four 
transport bytes.

The previous 6.12.y check was already large enough to avoid upstream's
too-short 33-byte bound. Copying upstream's +2 instead raises the 
branch's bound from 37 to 39 and rejects records that previously reached 
SMB1 validation. The later transform-request fix uses separate SMB2 and 
transform bounds, so it does not require this SMB1 arithmetic change.

Since the upstream bug is absent with the 6.12.y header layout, I would
suggest dropping 465e7e8a68af from 6.12.y. Now that we have merged it, 
we need to think about other ways of dealing with this. It is probably a 
functional issue, still looks like something to be fixed.


thanks,
Harshit


> ---
>   fs/smb/server/connection.c |    5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> --- a/fs/smb/server/connection.c
> +++ b/fs/smb/server/connection.c
> @@ -376,7 +376,8 @@ bool ksmbd_conn_alive(struct ksmbd_conn
>   	return true;
>   }
>   
> -#define SMB1_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb_hdr))
> +/* "+2" for BCC field (ByteCount, 2 bytes) */
> +#define SMB1_MIN_SUPPORTED_PDU_SIZE (sizeof(struct smb_hdr) + 2)
>   #define SMB2_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb2_hdr) + 4)
>   
>   /**
> @@ -444,7 +445,7 @@ recheck:
>   		if (pdu_size > MAX_STREAM_PROT_LEN)
>   			break;
>   
> -		if (pdu_size < SMB1_MIN_SUPPORTED_HEADER_SIZE)
> +		if (pdu_size < SMB1_MIN_SUPPORTED_PDU_SIZE)
>   			break;
>   
>   		/* 4 for rfc1002 length field */
> 
> 
> 

