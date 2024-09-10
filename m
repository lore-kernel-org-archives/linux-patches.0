Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7C5187FFF;
	Tue, 10 Sep 2024 15:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725983102; cv=fail; b=EF/WCHh81IY37e4tA/60GmIKr437NTUSRvYHSrfZLqjNYCju9iFvfp0mr7Us+eyqtKNl2/duIrI9rei93l366wBmxk66CkI7mJAQ05/p2qbHOSG+sXgSxc+c8F9C97A0D7ECdlAcWUF5Dpm4zWWoPAV6yYTOZlSFArU/4jwdQS0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725983102; c=relaxed/simple;
	bh=ivSa0zqL6KggeTyZO6tXe04wvGJE3QvwcqTFMCBvgwg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pDZoLEQtOB5OpAtRX5IQ69DK2p7KjHYoZpHb/pAqkJFAecsQphj6mn1SbjsylYNeHZfbqKyDwN4dPmgB6oCQadGPtaHVxwHCbzGSgUJP50N8U9QoXP9CLsxBmy8u5uSOHv7ereJ52PrtFWk6LGYwSfEE0DXK7B7eMcIjkdUV0OM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Sg6d44+g; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dhZrgVLx; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Sg6d44+g";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dhZrgVLx"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48AFfU7Z031448;
	Tue, 10 Sep 2024 15:44:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	date:from:to:cc:subject:message-id:references:content-type
	:content-transfer-encoding:in-reply-to:mime-version; s=
	corp-2023-11-20; bh=QsB85aDdWlC7Xtku5WDJu4SerdMApUzdWQ9qY3Gg46Q=; b=
	Sg6d44+g8YwcnKbrH20HwsMhFyF9zr6xqOXqMCWXCMgvCjoeARe8qVroUINhSVVE
	1xyM5DOpZOoSFl1PQaif0FaRyyAtJxOLX1L7fth3FdsLwgXnsnfxRtuQy3ADLXK1
	YokdoCQWTmxmqGQIKAS89Ky9AC96mkJ123peTI8qFLzEM/5redgsN1/5yRiUze4v
	RSfUS/6aZjbkQyBRoqz9z6NEmT8u3jXl+b/qyoXBjs8K+jD1s7Tk0US89umBQbBU
	JLSveEvHyMaLga9cMxEopp82IsRs5dcZJfVd/j4MBODg1Q9U9MpRj5CaKeyltQOj
	0LzcJMJb2EHcT+43cBos+w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gjbunr13-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Sep 2024 15:44:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48AFU22j040958;
	Tue, 10 Sep 2024 15:44:38 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9a710y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Sep 2024 15:44:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p+3eXL1iPHckmVQpZ1XKW1kBHzSVqeoosQt/0CQth7vR5fjld1MH2CWdiosIzGXnHV1oClt2TsSNDu1Hf9ekzN4ODAV5QqiizW5sQ5Us+IEyYYtBgBhW2LHeNOXiQc1tYrc11YhbTGVaMeSH30aVM+BDFGHdeZhgO6zHlHG1p+mKtaFPVqX43JXufMg4Co3aDCtfMT16mvCorvl7+L3t4rcF1tc2gMrUArgH8TcakFskAJLn+YOE0XeEk0gDGExo026wj/ocWLYIPgsC+JxqSSCgWpzq7VIrUHyahPh5Ur3EvJSBTcIUhNpZIusgqO+eCd2WBqqYO5YoDWjSTa+ctQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QsB85aDdWlC7Xtku5WDJu4SerdMApUzdWQ9qY3Gg46Q=;
 b=zWl2TGSzF1eAKrxeDNPsxO8O289PSP+M/KU+30tiDA0CNMGwj1Gc/0UsSW6iVvxod295kXp+NzE3J7YNzl9CXg1Lpj7ptPeST6TfUOmON2o7lwjj+IwZR8O6J54NpqYQPHeYX/6JGqXAUi/4gb50LAnPt3VHEOrpc887d6Yr2Azlrqvs7LxPTewBqbaJYUvU8worWAbUyas64Ql29MX+B/Xzd/m91g3RLv8XaYccBYAfobmiwszLBIPoP/Vox5thmyh/3jNRWamfUX2mVoZcm5iSpn7D9DHwNfEFoGViXlofmk+qwWXcsiAdf1Ur9HM8WCuu+VzDNDyPHaZYtW2jcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QsB85aDdWlC7Xtku5WDJu4SerdMApUzdWQ9qY3Gg46Q=;
 b=dhZrgVLxzSEkgxDGgqxEehvL4tErfyFDWd73HYKl1XYh+4bzTF4AIokHRfAevGbp9Xdk/h67WWO/C676cDhQLKztlHtICCVVlMaKwcFgVS4CpJc+ztQ9RLLMmNVtRM0l1VR5XmAagNQeJezZdJUgrutaudRhABoYvxNfDTuCx1E=
Received: from LV8PR10MB7943.namprd10.prod.outlook.com (2603:10b6:408:1f9::22)
 by BL3PR10MB6089.namprd10.prod.outlook.com (2603:10b6:208:3b5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.14; Tue, 10 Sep
 2024 15:44:35 +0000
Received: from LV8PR10MB7943.namprd10.prod.outlook.com
 ([fe80::a8ec:6b6b:e1a:782d]) by LV8PR10MB7943.namprd10.prod.outlook.com
 ([fe80::a8ec:6b6b:e1a:782d%7]) with mapi id 15.20.7918.020; Tue, 10 Sep 2024
 15:44:35 +0000
Date: Tue, 10 Sep 2024 11:44:33 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Jeff Xu <jeffxu@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        patches@lists.linux.dev,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Kees Cook <kees@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6.10 032/375] selftests: mm: fix build errors on armhf
Message-ID: <s663e6vb3dgxnedvugt65t6cao55lofznpq4fnkejh227myxxp@6ppza2y4tj2t>
References: <20240910092622.245959861@linuxfoundation.org>
 <20240910092623.314101083@linuxfoundation.org>
 <CABi2SkV-FdDQy2bjDkpgpqz7hX7ybeTjCrUgUf6WcYqGkuxWMQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CABi2SkV-FdDQy2bjDkpgpqz7hX7ybeTjCrUgUf6WcYqGkuxWMQ@mail.gmail.com>
User-Agent: NeoMutt/20240425
X-ClientProxiedBy: YT4PR01CA0306.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10e::9) To LV8PR10MB7943.namprd10.prod.outlook.com
 (2603:10b6:408:1f9::22)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR10MB7943:EE_|BL3PR10MB6089:EE_
X-MS-Office365-Filtering-Correlation-Id: 630809d7-9fe4-4d4d-1bca-08dcd1af7888
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YmZ1Z0E0SjNBakJQVXNZRGZjUTIvelFZWlhka2Vid2dJRzZvNmJNN1dLYktL?=
 =?utf-8?B?cXc3bUI4dTNMeGliR3B2MHR4ckhoSGRmQ3JnbGhNUWhXRnJxNUdkeHhHSncr?=
 =?utf-8?B?S1IxYlFKcDY2STkrQm5jUHMwaHdsMnViamtEU2Zpb0dNajFINDlFbVVrcVJZ?=
 =?utf-8?B?RnZJYWczNzlZYi9tY3VScUY2NmtIc2RhTXQwZFpxdzM2L1NnbjVFSWlwc3ZJ?=
 =?utf-8?B?SWV5dFZyTi9pelBrdU9GN1BlRTRjQ0VwaGVZaDZFbTlXZ1BnUytDVGdpZzNM?=
 =?utf-8?B?M05FWm5CMmZyTVdaV2YxYlB0QTZKNUdzY3RNeUt3aXlxRWpiZWh6ck9KVmN0?=
 =?utf-8?B?T1hXOFM4SUtKRElXcmhxWHNHZGlER1pPWkxhNXlHZFlOa3p0aUNYZUxZaHhY?=
 =?utf-8?B?Y0lFQUNmaVloS1JpV2hGZkxGSk52Z2gwV1dpTXZYbkZRa0t0eEZMOFRHd3Ju?=
 =?utf-8?B?VjNJdjJuSi9WSUxVWEVKeGRoa1lCRDVvWVd2dm1WVHVIbG51UnpNYnZFak9t?=
 =?utf-8?B?dHFBem9UZFlIa0NxMzdQbk5hUDRhS0pTZ1FldzhTYklsSXNQb0Y0RlR5b0Zk?=
 =?utf-8?B?TGdjZVIrejhuY1lDb1hoVGtkSDk2V0hUeVAyRlkrZEU0aFZjOVFsTGNQYmRy?=
 =?utf-8?B?SXNsMmpPdmFSQWFMOG5XSWVPMDYrcDdTbUZsZnM4MFpIOVdRMEhEVVU0TFRT?=
 =?utf-8?B?b2ZTOTYzZ1dNc2Q5ZGIzenlNdGdIYjl1THlGSTU4VnBOaC9vMThScXdGa2dZ?=
 =?utf-8?B?N1IrSXVwenJ4SGVqNVZrOW81TzZNVXI1eVp0RlRzaUtGQ2RDaVRyalltTkp3?=
 =?utf-8?B?YW9naXBOajc3b0E0UXpuOTFJR3BocWV2NExBWHBQNWVjYUNDaVZxbm1HTUFl?=
 =?utf-8?B?Zzh3c2dpa1I5UUl4cFUzM2xkcjNXMHlTQWdGRWpuYWZPT1IzMjBoZ1Vlem55?=
 =?utf-8?B?Z1VKVkVTM0dvODRCbVdERSt2Ukhxc2w0V0hGdXcvMWVwdWVRcHlUTGZpQ2lY?=
 =?utf-8?B?WTErV1FUbk9ROURjOFc5KzViODdxbmdNNUNFT01PbkdLRmJHa2d4Rkk1MU1u?=
 =?utf-8?B?bmlHYkZhODArUmZXcWZQaW9tbTNZZ0JsN2dTYy82UTk4a0ZSbVdlSE52bzhl?=
 =?utf-8?B?cmRFZ0hoblQyZzBuK01qdzRWNkVPUGhSQXFZNjZQNm1kTWI0bnp2dVNnbDg4?=
 =?utf-8?B?Z0hBNDdpYlYwcGpybGxOek1pT1dLOFBBdHdpTUszZGJjYko5NVc2ZUpOSUxx?=
 =?utf-8?B?ck9odjc5ay9NYk1HZWZnR2VDeHh4emF3dmVRdGsrUFh4bFNTQTgySklmSjF2?=
 =?utf-8?B?SjNqYXBVNW9iMzlXaFNwalJlRFN2a1o0Y0Yzak1POUs4QUtud0xDclVVTWNj?=
 =?utf-8?B?SXNZMTc5RFVxVmowQnVWNUdZaHF4dmNvSXQ3YnBkVnpGaWwvSHg5SCtOb3Zn?=
 =?utf-8?B?eHFwWml6YUQ0T2NTa2tlcng1dDYwWlMrcSsrQmxlVHNad1VzQjV3NTJ4Q3JD?=
 =?utf-8?B?clNBekE4Rm0zaWRIVUVocmhlK1pzdmNiTUQ1TERHeEcwNUU1SU9SeE9WTUZk?=
 =?utf-8?B?Z2lPZm93VDJ3aG1JcnJoVVdLS3dVQkJrbW1DQ0FxVUowWE9wOEhXU2s1cU93?=
 =?utf-8?B?cW92a0syMDZKekZBWlBGMFg4eTJnWWFUald5MVBsRkJYb0IyZG9nODNpcUM5?=
 =?utf-8?B?UnpGL0k0Z1lpSGtmNHNkdjY4eG9teER6WVZONEI2Zk9jR1hyY3lQcHRpVU9J?=
 =?utf-8?B?SkpUQWNlOGlyQmhoUHdWS3BTa0o4TUNiMkZiM29EZHlobVNQNkF6cTNDTlBs?=
 =?utf-8?B?d3Rsa2plNGxmVWNSRE1LZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR10MB7943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZFYyY21BcUltR3EvcHFjK1ZJZ1d2aHVjR3pPM3dyc0FkSDdjWnQvQmVJalFj?=
 =?utf-8?B?dU1xR1NwSDBYU1FFaVFSNjdVdmpDaGxyV2ozSEtlVVZlYnJVcEF4czVWZTBi?=
 =?utf-8?B?VzBHVzZwTXlvRmdWdWQzYWZjbUtlWkhaMVJwZHhnV3dEWXI2cGQyTWRXVEhl?=
 =?utf-8?B?MEYwd1hwSEdMTWlETDdaYW5ycTRXSUEySWtpd3M5MTVEZnZGRmY1QVl6Z0Uv?=
 =?utf-8?B?NnhFU2hZT0pTTWNLN3ZkSW94bkFsMXJEaVJzUEg3VVdmV3NLdWlpOHFoUGxl?=
 =?utf-8?B?dmFlTThhaDFQcDd3M1FhbjJlazJobXF1YnkzL1dzTGFwb1F4aGpLUUp6cjlR?=
 =?utf-8?B?S3diNEpXZkY0WjJ4TE44cDJDUTYxNWVWd1I2dW5BREJaN05qM1M0eVBMSEFF?=
 =?utf-8?B?NTBZVnVxUnoxQXFPQ3NHb25OR2x3UlRLVExYeU5GckM1eUl4d00wUThPQ0Vz?=
 =?utf-8?B?Z2RKaTRpM09Kd1lUTzhRSDBGQWh0Y0hJeUppZ2kyZkR4VG1qd3Y3VDRnS0dj?=
 =?utf-8?B?ekRldHZxbXhST1NVNCthdXFrMWRZalZsMUFWS3d2dTlVaFBaR1ZDeGZkUXJJ?=
 =?utf-8?B?VG9Eczk3UndMY1ppb1JXcHhQVWhWcXBMeE83Q0NQa05XbTNnRisvZlhZSWRL?=
 =?utf-8?B?L3pqenplNGVIVkU5Smp6RmwrcittNFBHb1ZpK3BjcE9ETVMrc3BxdXQxYmFP?=
 =?utf-8?B?Z1ZER2pQV25jMm1vVFRWeVVYaVNjM2c5ejlheFRaN1ltMzlsOHdna1c3WjhF?=
 =?utf-8?B?S3lrYkRvOTRQcHZvS3NJVXNIVmh2L0VvMkJOQ1Myd3RNODk3ek5GR2FpYUxz?=
 =?utf-8?B?Z3ZBejZ3c2poU1FCNGpGdjFHY1plSGFVeEFsZ3VxSEtFdk9uRlo1QmJoVmd4?=
 =?utf-8?B?MFFoZTJJeEdQZ0xUTU1QNGtyblBLOC91eFNHQzN2Wi9kQmp3ZDFTYS9Lei9M?=
 =?utf-8?B?TklMamNCcnZDaTBaMUlzYy82b2k3OWxRSGtBMzUwM2hUNTU0VkNNQ1AvTEVr?=
 =?utf-8?B?UGg1S3VOMHFmQ2ZJQ2J1TWQ0Um5TVjVuWW8wbGJRVDRSbisrRTh1VXlvZFJa?=
 =?utf-8?B?cWl5R3VOeGJ6Zm5qcWdPQXVMTXA5ZzFRQnE1empjT0h2L0g4YjJKZkN2ZVl3?=
 =?utf-8?B?L0hKOG9MdDRKSEJsWkxlVjRTQ21WWjZUZ2x1b29WdDZkNE1TdXh4UURydGFT?=
 =?utf-8?B?TTd1MTlNMXhaaGxsNmpaVUM3c3ZuZWs1ayt5UTJyRDFsMS9idnh1SnJ2eU92?=
 =?utf-8?B?K0dOb2EzejJ2WmIwdHB4L0EwaFcyN1FLaWoxSU9UUkV1WFNzeDBMbW5kU2hP?=
 =?utf-8?B?dWcwTUUyZWNSNXRqek0yNHVtYTYwcDlRUjcyeWRwM2JYb2VNSWZzZUFRYzEz?=
 =?utf-8?B?Zlg0ZXRvNEh6ejBXbDg3YjhwT1YxVlRnTzhCU0IxQzJoUjZxb0tONi9nZFZp?=
 =?utf-8?B?d1BucUF4alVWak9ud2xseEthbjg1Y3dMUXJldkVKQ1ByNldoa0wyZGVjL0Ru?=
 =?utf-8?B?WnlkUlBxVmQ1TFNDRitxYmVTeTRLZi96aFl4UmZCRXI3R2ZDL21XV2JJVGRR?=
 =?utf-8?B?QXZlV3RkTHViZzIvcUljM3pndWk0V3RsT0ZzekVteERhT29Ha2xsOUNBblZq?=
 =?utf-8?B?NitGRUozc2NsNlFrRHVUSm9BWkc3eU5ScDhsWTloYzgyWnRvdUZ0TTdzNURh?=
 =?utf-8?B?VXQxVERoSUcyN0duUWNMRGEwQnIyMTd0dCtEL0xQbHdndk1GSnlPVmlIcVFJ?=
 =?utf-8?B?THVnR1hTWlRoSUFycC9sWGdUZnpreHZaWGg2d1lpVXl6MWRKVXpNcmVrWG5t?=
 =?utf-8?B?alU5aWIzUW1BK0dxa0p1WXBUUmx1TDJqVnhmNzgzZnFSRHFWRzZOMnNYYUU1?=
 =?utf-8?B?cnkzbXRxdmVSd1pSV2dWYkZITStVY2w5TFAraFAvZTF5eXkrTUw5N0JsTFpQ?=
 =?utf-8?B?RzBoRG15TmxxRnZnMVgwYUZRWE5SSEFZNkUwd01vaVhhZjZ3M21zMXRXZjVB?=
 =?utf-8?B?UzJ1Zkh0akNKSFcvbGF3THRibFMvVExKaVJMSW1zQnRGWS9aUlk4dXRiMSts?=
 =?utf-8?B?YWxUWmM3ajMrZjFFVHZwT1NSUTJ2OGZqa0ZrYi9RbzV4US9jeDhKb2hKaHlp?=
 =?utf-8?Q?teRFD2NXANLDcteqml3212HFT?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mHO3MBcvtCprYbtK2ZXwOaOL2l53jEAvjyN1NlkDT8P+tO24jsoc/xXNeUfgKgGdlyqGpSwaLq8nNxVnawfftNr61PFwuVoddQ9dInNLmibS+pO3oxltiu1mwRl5BRCkd3+agekMRSDaD/3ebczhPY3ccaJQiQOGVaQ5eTHe+zrzbkC/2ABG6s18Tds60nKctFniWNw6g5VxA8E2+m3fNzYbzJPF3VHJOLmmGOdnwaIXC/GXzjNCS0+zKN7zgeg1EjkTGK9YN6eZNv3GTjM8LReqqx1IaN1RG6H+lv3t3otIQqTIWzxXcqGXHXWPL8LiMXgnmmDgvLCY9d/URZLko7VLyUkQgyxnjb4Ngfl7xl6frCWvQJR1MaFyOtX26K+Wz9r5Zuj9hLNr5D+0OlQuMBuPYXUSHIiJQAYFI/rZqd+ON9QKTCRvd9/73YZ3L7QP4J1Xa7MuVs8xPJyvfG0nGjcd65aZRsaPvkwZ2RvxH/pK46YTHj5I2pVQ1yNPIajKq8qOHO9r/8yGFehbN9b9ipAY394zIM39zfrV+E4v9+Ldk+0VXDaopeF6yxcN0FKBaKKi3MdSVFf0Q9X/MYK5qvo4YQiQMkg6raCO6wgrGWQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 630809d7-9fe4-4d4d-1bca-08dcd1af7888
X-MS-Exchange-CrossTenant-AuthSource: LV8PR10MB7943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 15:44:35.2958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: plu1sZXMWxpome8p71uXkv+zb6TcLcrUyeVwMJS0Xyz2uh9Cz4AooHP7YfGPNXcV4SQQiD9bwaXsqHZScYzIVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6089
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-10_04,2024-09-09_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409100117
X-Proofpoint-GUID: 9B5NnXXjZwbjasprUIBhzLmlGg7ImN8j
X-Proofpoint-ORIG-GUID: 9B5NnXXjZwbjasprUIBhzLmlGg7ImN8j

* Jeff Xu <jeffxu@chromium.org> [240910 10:23]:
> Hi
>=20
> I'm not sure this is a correct fix.

This should be backported, mainly to help facilitate future backports.

...

> Although, I don't think we need to block this  getting into 6.10, we
> can backport  again when a future fix is available.

Please move this discussion to the mm mailing list.

Any changes to the area will depend on the stable and upstream kernel
being in sync for easier backporting.  Without the fix, armhf will fail
to build the selftest.  So our choices are to have a working selftest
that helps backporting in the future or broken selftest on certain archs
and potentially more work for the stable team.

Thanks,
Liam

>=20
> Thanks
> -Jeff
>=20
>=20
> On Tue, Sep 10, 2024 at 2:42=E2=80=AFAM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > 6.10-stable review patch.  If anyone has any objections, please let me =
know.
> >
> > ------------------
> >
> > From: Muhammad Usama Anjum <usama.anjum@collabora.com>
> >
> > commit b808f629215685c1941b1cd567c7b7ccb3c90278 upstream.
> >
> > The __NR_mmap isn't found on armhf.  The mmap() is commonly available
> > system call and its wrapper is present on all architectures.  So it sho=
uld
> > be used directly.  It solves problem for armhf and doesn't create probl=
em
> > for other architectures.
> >
> > Remove sys_mmap() functions as they aren't doing anything else other th=
an
> > calling mmap().  There is no need to set errno =3D 0 manually as glibc
> > always resets it.
> >
> > For reference errors are as following:
> >
> >   CC       seal_elf
> > seal_elf.c: In function 'sys_mmap':
> > seal_elf.c:39:33: error: '__NR_mmap' undeclared (first use in this func=
tion)
> >    39 |         sret =3D (void *) syscall(__NR_mmap, addr, len, prot,
> >       |                                 ^~~~~~~~~
> >
> > mseal_test.c: In function 'sys_mmap':
> > mseal_test.c:90:33: error: '__NR_mmap' undeclared (first use in this fu=
nction)
> >    90 |         sret =3D (void *) syscall(__NR_mmap, addr, len, prot,
> >       |                                 ^~~~~~~~~
> >
> > Link: https://lkml.kernel.org/r/20240809082511.497266-1-usama.anjum@col=
labora.com
> > Fixes: 4926c7a52de7 ("selftest mm/mseal memory sealing")
> > Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> > Cc: Jeff Xu <jeffxu@chromium.org>
> > Cc: Kees Cook <kees@kernel.org>
> > Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> > Cc: Shuah Khan <shuah@kernel.org>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  tools/testing/selftests/mm/mseal_test.c |   37 +++++++++++------------=
---------
> >  tools/testing/selftests/mm/seal_elf.c   |   13 -----------
> >  2 files changed, 14 insertions(+), 36 deletions(-)
> >
> > --- a/tools/testing/selftests/mm/mseal_test.c
> > +++ b/tools/testing/selftests/mm/mseal_test.c
> > @@ -128,17 +128,6 @@ static int sys_mprotect_pkey(void *ptr,
> >         return sret;
> >  }
> >
> > -static void *sys_mmap(void *addr, unsigned long len, unsigned long pro=
t,
> > -       unsigned long flags, unsigned long fd, unsigned long offset)
> > -{
> > -       void *sret;
> > -
> > -       errno =3D 0;
> > -       sret =3D (void *) syscall(__NR_mmap, addr, len, prot,
> > -               flags, fd, offset);
> > -       return sret;
> > -}
> > -
> >  static int sys_munmap(void *ptr, size_t size)
> >  {
> >         int sret;
> > @@ -219,7 +208,7 @@ static void setup_single_address(int siz
> >  {
> >         void *ptr;
> >
> > -       ptr =3D sys_mmap(NULL, size, PROT_READ, MAP_ANONYMOUS | MAP_PRI=
VATE, -1, 0);
> > +       ptr =3D mmap(NULL, size, PROT_READ, MAP_ANONYMOUS | MAP_PRIVATE=
, -1, 0);
> >         *ptrOut =3D ptr;
> >  }
> >
> > @@ -228,7 +217,7 @@ static void setup_single_address_rw(int
> >         void *ptr;
> >         unsigned long mapflags =3D MAP_ANONYMOUS | MAP_PRIVATE;
> >
> > -       ptr =3D sys_mmap(NULL, size, PROT_READ | PROT_WRITE, mapflags, =
-1, 0);
> > +       ptr =3D mmap(NULL, size, PROT_READ | PROT_WRITE, mapflags, -1, =
0);
> >         *ptrOut =3D ptr;
> >  }
> >
> > @@ -252,7 +241,7 @@ bool seal_support(void)
> >         void *ptr;
> >         unsigned long page_size =3D getpagesize();
> >
> > -       ptr =3D sys_mmap(NULL, page_size, PROT_READ, MAP_ANONYMOUS | MA=
P_PRIVATE, -1, 0);
> > +       ptr =3D mmap(NULL, page_size, PROT_READ, MAP_ANONYMOUS | MAP_PR=
IVATE, -1, 0);
> >         if (ptr =3D=3D (void *) -1)
> >                 return false;
> >
> > @@ -528,8 +517,8 @@ static void test_seal_zero_address(void)
> >         int prot;
> >
> >         /* use mmap to change protection. */
> > -       ptr =3D sys_mmap(0, size, PROT_NONE,
> > -                       MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0)=
;
> > +       ptr =3D mmap(0, size, PROT_NONE,
> > +                  MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
> >         FAIL_TEST_IF_FALSE(ptr =3D=3D 0);
> >
> >         size =3D get_vma_size(ptr, &prot);
> > @@ -1256,8 +1245,8 @@ static void test_seal_mmap_overwrite_pro
> >         }
> >
> >         /* use mmap to change protection. */
> > -       ret2 =3D sys_mmap(ptr, size, PROT_NONE,
> > -                       MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0)=
;
> > +       ret2 =3D mmap(ptr, size, PROT_NONE,
> > +                   MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
> >         if (seal) {
> >                 FAIL_TEST_IF_FALSE(ret2 =3D=3D MAP_FAILED);
> >                 FAIL_TEST_IF_FALSE(errno =3D=3D EPERM);
> > @@ -1287,8 +1276,8 @@ static void test_seal_mmap_expand(bool s
> >         }
> >
> >         /* use mmap to expand. */
> > -       ret2 =3D sys_mmap(ptr, size, PROT_READ,
> > -                       MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0)=
;
> > +       ret2 =3D mmap(ptr, size, PROT_READ,
> > +                   MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
> >         if (seal) {
> >                 FAIL_TEST_IF_FALSE(ret2 =3D=3D MAP_FAILED);
> >                 FAIL_TEST_IF_FALSE(errno =3D=3D EPERM);
> > @@ -1315,8 +1304,8 @@ static void test_seal_mmap_shrink(bool s
> >         }
> >
> >         /* use mmap to shrink. */
> > -       ret2 =3D sys_mmap(ptr, 8 * page_size, PROT_READ,
> > -                       MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0)=
;
> > +       ret2 =3D mmap(ptr, 8 * page_size, PROT_READ,
> > +                   MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
> >         if (seal) {
> >                 FAIL_TEST_IF_FALSE(ret2 =3D=3D MAP_FAILED);
> >                 FAIL_TEST_IF_FALSE(errno =3D=3D EPERM);
> > @@ -1697,7 +1686,7 @@ static void test_seal_discard_ro_anon_on
> >         ret =3D fallocate(fd, 0, 0, size);
> >         FAIL_TEST_IF_FALSE(!ret);
> >
> > -       ptr =3D sys_mmap(NULL, size, PROT_READ, mapflags, fd, 0);
> > +       ptr =3D mmap(NULL, size, PROT_READ, mapflags, fd, 0);
> >         FAIL_TEST_IF_FALSE(ptr !=3D MAP_FAILED);
> >
> >         if (seal) {
> > @@ -1727,7 +1716,7 @@ static void test_seal_discard_ro_anon_on
> >         int ret;
> >         unsigned long mapflags =3D MAP_ANONYMOUS | MAP_SHARED;
> >
> > -       ptr =3D sys_mmap(NULL, size, PROT_READ, mapflags, -1, 0);
> > +       ptr =3D mmap(NULL, size, PROT_READ, mapflags, -1, 0);
> >         FAIL_TEST_IF_FALSE(ptr !=3D (void *)-1);
> >
> >         if (seal) {
> > --- a/tools/testing/selftests/mm/seal_elf.c
> > +++ b/tools/testing/selftests/mm/seal_elf.c
> > @@ -61,17 +61,6 @@ static int sys_mseal(void *start, size_t
> >         return sret;
> >  }
> >
> > -static void *sys_mmap(void *addr, unsigned long len, unsigned long pro=
t,
> > -       unsigned long flags, unsigned long fd, unsigned long offset)
> > -{
> > -       void *sret;
> > -
> > -       errno =3D 0;
> > -       sret =3D (void *) syscall(__NR_mmap, addr, len, prot,
> > -               flags, fd, offset);
> > -       return sret;
> > -}
> > -
> >  static inline int sys_mprotect(void *ptr, size_t size, unsigned long p=
rot)
> >  {
> >         int sret;
> > @@ -87,7 +76,7 @@ static bool seal_support(void)
> >         void *ptr;
> >         unsigned long page_size =3D getpagesize();
> >
> > -       ptr =3D sys_mmap(NULL, page_size, PROT_READ, MAP_ANONYMOUS | MA=
P_PRIVATE, -1, 0);
> > +       ptr =3D mmap(NULL, page_size, PROT_READ, MAP_ANONYMOUS | MAP_PR=
IVATE, -1, 0);
> >         if (ptr =3D=3D (void *) -1)
> >                 return false;
> >
> >
> >
