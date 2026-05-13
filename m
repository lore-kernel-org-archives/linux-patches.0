Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B423FF8AF;
	Wed, 13 May 2026 12:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778674247; cv=fail; b=YLTtbBhzbF9XkM/+gqhQ2yRqe6DBRUgLx8QB0ceCF8hKAtlDyRAzaFs1WV/xChPEyai8h/TK9x2jcFjsreN+GqKWuSd6qNRfY+3ziX2xE9CjrUv7jWDN9CQPCh4Hyn7o0L4LDgplXHR/ERiuzlrDBBzYHopzHsfF6FjO7G2P8ag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778674247; c=relaxed/simple;
	bh=E3pWHBnDNgGzjf4ftvzWR8YsBdic1mdkq3jNStlWxeA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VpWHJfrorIRsFcl2qRkFtVssu7SodsZXO7FQqYYygDNweAroQC1/3tvRfEJSSH8/u7719/f+Y6I8xQfHzR4VO5SWB/Ed36l+19qk2CkmMm8WsXqE0ARqbtYFW/HqzPvphL1i+xFjBm7MPQwqxsJHxFID2CiBKzkPl1z8SPwj1O8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CJD2UkKr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vSoAsNo8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CJD2UkKr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vSoAsNo8"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64D7N1XM1433750;
	Wed, 13 May 2026 11:36:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=L78OsmOtLDsmfmXaFeGWOaBd9mSgDwpUBe3QwH0A6ME=; b=
	CJD2UkKrlwgXbgmhrKZYrrarK+uTl5NFr3oqfZ3tnf3EY5EwDV6b8FE2gIkOH9v4
	DF921mxxkDR48hJVeVkdPt7PbtprpUTzRKcos+8JEnd/N2Yv3k7NyXnryeKjZD3P
	EK0NIn6QerUixm3o05KLYUtOrIDQVGHERQk/Tpks2SEUjh5J3bMNeRFM1zRuDAtC
	01fvQjso2kbY6h5XfLYgVUNXCxOc7pCpYFLGr9JA8I8sdNv5+CZ0Rh14doJpU0CX
	NT1akF7n9KJU19W4ZayNH8ZjHWXMI2oUdi9N/+wFJDUntQP9iuU80MzLyNAPOCvs
	orvx/m+FeXtD5jPCPSOXng==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e4c97h0e1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 May 2026 11:36:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64DBYwPo008805;
	Wed, 13 May 2026 11:36:02 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012044.outbound.protection.outlook.com [40.93.195.44])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4e3necjm81-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 May 2026 11:36:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KU+1pcvZSPcdHQj2cWqhHV0HbO9zoAXa9eRNYnQmoXY5tan/vza/K3sz201m63S7bJ83S9gin3R9XO8kbWhbnE6Gb2h3UAg3vuV9SoyR2Dh1yFq7mOHGxWx27s/sPTIqya/Skwdx+xJgN+i2HlU63qtVmcGShA4S31fbzyVwd9ImORFlDTZjYEYgFw33U38T2K0Lol94C/R3C39JUIRQHNUf7xF0/nZpQl5lZb5zTdwPQTPEHS1vvpkX80QfDq+lBIt+/nZxZU/LF4a0kN6BOiFDerAqYFfGHBjUB1ZnMSyXDzwjCuCNCS8y8DQfGR4dyK/JDQK6+LIUrg0ghxtYBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L78OsmOtLDsmfmXaFeGWOaBd9mSgDwpUBe3QwH0A6ME=;
 b=vZH4NSSkZPqrbyMxWVdDExOgY9GFzHwH8Fhmte638X51yMcFujVCGwvwDJ9E/sX9oqDycVQct1CVlON4ZQKyZyMzT1j8FFM7jQmf20BCJRrE0hjJDd06K0Px/XP+10Ew4dmHHjvLqd2/x5vDGk66Rr7Sk1zVg9SUDQVPsP02DeFSiw4RPutrlBHWQcrpbb8LAkS026f4y6b/C0f5OTx2FTZuaNFEmu2OGYDr+my/Ml3hsfhjvpdl2zEO35J++s4KZ1dv1n0xqX96foXizdVuZepI9xBtghtObwwFySIOlCPFThnC0yCis4tLemHsWPP8akwhHeYxvAsgUssADVoAlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L78OsmOtLDsmfmXaFeGWOaBd9mSgDwpUBe3QwH0A6ME=;
 b=vSoAsNo8fpXsMoNeMvPX5i9KRCvvv+ILUM3eJ4POwpIJl4gw+7gHJx+2peRmmvJDQl+etHQn9WOGPULGwT8cwiCjZjW3xVz9QENxhhxgz0/RipqY4cucXG4tOB7TEQ3XddjUIWhVqtxGQoqB8HbtQKP89kyMnPV7SEsYZ2SN+O8=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SJ5PPF7A7588508.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7aa) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 11:35:58 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.20.9913.009; Wed, 13 May 2026
 11:35:58 +0000
Message-ID: <95aa6c6a-6ebe-4ae0-9376-63aa9fb8872c@oracle.com>
Date: Wed, 13 May 2026 17:05:50 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 046/206] usb: typec: tcpm: reset internal port states
 on soft reset AMS
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Amit Sunil Dhamne <amitsd@google.com>,
        stable <stable@kernel.org>, Badhri Jagan Sridharan <badhri@google.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sherry Yang <sherry.yang@oracle.com>,
        Vijayendra Suman <vijayendra.suman@oracle.com>
References: <20260512173932.810559588@linuxfoundation.org>
 <20260512173933.811124271@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260512173933.811124271@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN5P287CA0025.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:263::7) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SJ5PPF7A7588508:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b5f4984-0879-47e3-f1f3-08deb0e3cd86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	+9uhWq8FNNE8IYcZpjcVJt168xJN/aoE07UoT4xPsK1cHeRH9nn0SyFDgOw2bLTW5K4AzlLJEFBshgkfWHDvfV4PFhr3HUG05I+QuElZiVwBVdXiv7Y4AqExtxYuaN3K0hRpMuM/whkb4lfmrRvNmS39gwuyhBGv0QCW/qnd/7OM2UMnsbMuWFDbt+DiBCo3geibTjQJS6l55d84/DeLWC4ctrdhEx8RFlgE888RrEARH/VMff0t8L4+/5jXIZiyUsDVGOO7qfHj9nrCbgAPbqGRd3b+N+aJUfYRR2hbvOnfnqsmSvYgMk+8tAQvvaX+xEOT/FfIPUoWU5xtmoq5PrGbj8qkCZD7SSf8LzSj45QZGEGDi4KSn0LkivUvaW2XXeioYp2xqbERA5IodsGnCZokDBUmLQMagohQPBZz4o3jlIWV4Igs479RFdncjRSFc37xogC6P9zEpx6FbruluI70Xg/CaOIfTGdEiBsuj/GIx8BYpix1jpRh9keKy0p3D9OvRzUAPhL2ilBEkYhrE1m2KFM+LbGdzhhQ4pf9jEZ/19wsWrBvKOvXiBIlrsQP/prWPnMvQoWqnqCQigvgXutR6JEhsQzm9kUB7ZTYqv/Mnvx4ybTt+eZlf6szfwNeMeEuFYVmuAsRkCOJ35wnZw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZHpjSTdZL3ZHakM2amtQL21rQ1V1SDdqZ3ZvZi9HTmpJelFMMjE0S3hQdE9G?=
 =?utf-8?B?MjdCOEhpWlAyc1NLQ1pQb0FlVHhNMXZidWovMHF2VEh3dnRZWEROSUJhRith?=
 =?utf-8?B?WUNob0FuNzNtVXV6QkhXTGxxV3NzS21QRVh6Uko5Vkt2bU83S0JNRXI3aFE0?=
 =?utf-8?B?ekwzdGpIOHdxQlNoNFo2WkI1aDhubTh2RllONUZDOXl6akMvdTNOQzdsbDhX?=
 =?utf-8?B?cHRDbS9NQnl2SHRyelJUK2ZBd0hWQTFYbFJIWmRRS2IyYnVBMm11Ymd6YW44?=
 =?utf-8?B?Y1F1Y2gvTzUzYXdhN1gvWm8ydExhVlUzMEhQV0RBWW80ckExWTNNQWt5cjdV?=
 =?utf-8?B?Z3pQa3ZwYlNWZFF5RG1zZFduK1dHUnI1OVVpQVdmQWwzQ2tKU3QvRjFkdG1t?=
 =?utf-8?B?cW1nelJNUkNUaGJxemdQRjZlbVhOUHk0ZUZteXBISXVWV1ZQT2xHSVNVUFpT?=
 =?utf-8?B?VUVsaFhxazNzNjNyblQ5UFVWM2I5WU0vcWRwdC94WnRFRkpNZzlESU1PSzBV?=
 =?utf-8?B?TytCRFFTbFFjeHhtVHlOSXRVSmFhMkhCbHAwamVXVVlhSjdaRExjNlJualBD?=
 =?utf-8?B?cDA0TXdFOVQxWE8vSENQMUJZZnFSYURWZjN5bFY5SFZSZGNxeFhQY1dmbHN4?=
 =?utf-8?B?ZGNIb2hrVHlWQjVqcWZEWlRIdXliZ0w2SFRTVXN2cEtKblVhblVIQlZTZGVE?=
 =?utf-8?B?TkxkdFVFaUdzMmNBTlZnRTZ3dERSbEpMblFVbXNwNlFFRG5UenRkWEVPMTJV?=
 =?utf-8?B?VmtPYnVHbVhJN3dJWjZYUVZLSklrL3g3ZkNYckVHMTlzaGhVTjFmbkVrOGpL?=
 =?utf-8?B?R2ZobEx1Z3NOMWtSRnZscGtJTDBpT2VEbm9lWDNaS1FvKzFlVTJIZGV6VGdp?=
 =?utf-8?B?TXBvUGNtZXpTdFBhMFBPWXVBVzhhdjRjRHpsSm5yQ0s3RmRwWHV5YmJjVEM0?=
 =?utf-8?B?N1l3UmNsbDRSSHl6Z2JjSllWWmtsNDdyZ2NFSEN5aFRHTjZBUGxPTDJMNFZu?=
 =?utf-8?B?dTFBYTNvNEljK3BkdGVZdFhGOU1MQ2R5cWJ2K0VVVTlSVkxKd09SbERZdWky?=
 =?utf-8?B?N3hBbWZHcTN4cFQrVjVzOFRRay9GQm5ZTW1PczlBVlVVVlpNK0NUYjdTUTZ3?=
 =?utf-8?B?VXVuU0twckR6eUUwYkNIN29XS0ZKelE5SHRXUDd2N1JCak5XOThTOEZSUE8w?=
 =?utf-8?B?MGJyWGxxZ21uUFFJcE82OUxQT2J2dU5uREhOajZCei9qVGF5QjM2dlY1QmdF?=
 =?utf-8?B?c05WbEhRcVErRjZEc2ZnY2pvMHdtcTdQS3JVeVMvZUpDTWU5V0lQblRYaGpJ?=
 =?utf-8?B?T2IrMlpxd2ltTjVnVFZqRVgzT1d4RUVZWUZzR25lMFdTYlMwRUVjb0NTSnpx?=
 =?utf-8?B?emlNVGVhZVh0d1JpbllkcUJiS1lPNWh2VXZhZXJDRzdmMzd5d2VEMGFZcCtP?=
 =?utf-8?B?U3RzODA5Nk5UV3NxL28valJFbXQ2MDE3ZEFlTHdLUnpOdHdsenkzT3FzYlFS?=
 =?utf-8?B?RExzR1gvbmRPRE05YWVPOUVBUnl3Yi8rd3RjTVlTZGVtcnhOSTRVVmtVMnQr?=
 =?utf-8?B?ZVdQN2JUeGlxcFJRUWVyK2pYMFdwWUl0MmZSMHRWc3ZSeEYwanVTN0lTclkw?=
 =?utf-8?B?Y2R3alBpR05MMmJRTGw1QVN4Vm12aGNEOGxtMkE5b3hFV25DQ25xeEtyQzEy?=
 =?utf-8?B?c210OStpWE5RQ2pRWmxpUEhDaDRXMTZoak5NUWRCRituNGhZOWhwWU42djFX?=
 =?utf-8?B?RzJKeEdPVmQ1cmVmTlNJbUYyckZORDVrZEFJRUR2TGVZajlvS2UxWWhzc2xV?=
 =?utf-8?B?RzU4Nnc4ZCtoT09XRStuYlZYRnNvVVk1S3VIRk1WemRuZ0xONmJGb3RGTlQ0?=
 =?utf-8?B?VXJTMS9GOC9DL3NiN1hsQm16RUsvZFZ1U1RBZm1VMkF5ZGdYT2w4RXcxTWJR?=
 =?utf-8?B?dmxGcTRvaDlaMW5KVUpCMFpaMmlnZ1FSN3d0MHcvQzJrSFRZUWxheG5iOVhl?=
 =?utf-8?B?Vit1ZmswTXlUclNxajNBWUN1VnljZXRtd2NPOThoNW10NGhKbmZWMnU5eGlG?=
 =?utf-8?B?cGhTeVJwVkgySDZrOVBUQlhqNlFGaXBFYmFXQ011Mnc4SGdzckZTamMraHAw?=
 =?utf-8?B?QWtOelM1WkxvRWpWNTRZSmFpWmFNVXBpQ1d1QitJSlBnNmY2M3JMem1CcnZG?=
 =?utf-8?B?WUdVU3Z0YW9LMEV1ZnFESTFLalNVY29JYkdla2s3VkJnSVR6T1FIdnpLMEo0?=
 =?utf-8?B?QlZkYzR4VWRwbFhPeHRPM3NNMlkzenFlNHRPZG1kYWl6cFQ4d3d3UGJ4OGE2?=
 =?utf-8?B?cVh2YUJwQnJ1OVNNN1JUbGNZc2JwcE10Nm9YcW9ib29TMHZEdmpyWFBrMlBD?=
 =?utf-8?Q?WKkGfH21CqgbCxHt8jqFx9VSyJG5OrXhgpyXq?=
X-Exchange-RoutingPolicyChecked:
	McRvQd9+CnK6Wup5fAFVujyeS+cqWEYpz7xI9NOECbYSItk3N0NtN8yDzrZ4DbZ6GP5RNcOmIyQlER8QSidWVK49k2tpIB1BMNm6refSDzCC+Dew0nPxK4TtN+g9ueOiLktPRTnkBRVPSSdSPlDyVuFC2RhE30VDrbQBIj0/IeXdvwgvOiguNE6S3uZMzUIg+Oei7TcatqOoCfjoS7tiqx1OoWHng43hgWfjLzHdtNenrIEOx0bVHzoP6IMOJhuRSjQCTpmFPfyWCWk38vqZZWrAk/h/axuFfgC5QOKto/M69XbLTn2tPQE57AbgglJaVLdVRd2np0Bj4vODrcVFPA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0Xp37lIerjBG0d2KDxdetqalzWnoMv13iB6tE9Ks645N6gHP+wR7gtywUOG5Q+mlAZLp2wYlmtR9aH3LC0+jpfWPkQvfRyyyEcpSBh4KP4WaPWglW6VT06NCmhTphdfJr3SfErkwLSNS5VHuKeYwJFPGmDS+6hDKJ15w8Co6g19gt7vtRCduKql/xb9CZDHwFIsjFlUJ7qrYkMCOg6m2LVJgy9uQSXAv50ZXkFPo+blRLY79rp2fy6fc1NztT2jU+47/+h6Z4haBJq8QUGi7Hvcr7FRYHfTdlQyQfepPPp44HsITbGhRNHOkAaYVmdidX1lhJkKs1Z80iP2jgJt/XL9Q6gGWpcCnFmmsdtSAatdcmgAdPS0iZVs0CuBAAInMBf9QG31nae2J+mMYjHwFCrlmictgwUSrkX2dxS+ngJ+v5WqNio14NxK/reNwtRVTxY4U93hHZBrqVw9Xn6pgWWarTR47iGE+V6CdAH9dN2cLG8H3cv5yg0UEToFWSCEQcwz3Hj56f2//y4Sp4LoLME5Tan1gq9nnRy5IE6SXxWgOT8I3ZSTDUk44GCX+RfuBw7y6TUdCUCv2CuLzYcucDvIOxqYDt8sc31SvsdbrkIg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b5f4984-0879-47e3-f1f3-08deb0e3cd86
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 11:35:58.6192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J5PdghziuetyZC5JAfADLRR76mN48Ag5rQxzdCVho/44ZmI2tnaBZzK6yq1m/225Aw/IUNEJ+iLWqYILEtFSd1gGITundmfWnMV6I/7+qRcNGiaUZHXcAto9bdd9Dv+S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF7A7588508
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-13_01,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605050000 definitions=main-2605130121
X-Proofpoint-GUID: rD7pObitqorW-eT9umOBcNMaixcEv86d
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDEyMSBTYWx0ZWRfX4ZIX76NWS/5Q
 /OfwQRPgegQc2tzNdz0w10Lpy+cGmZPJlWMckGnNcbnIeYxozhah04a4PpZwAcag2zgsOTfj+iW
 WzUaWweIHhLBAxFNrqRv+LLyaIvYgvKSsSJaerUbwYbUKvpcMrIyTfTGT3xbnbI6xRjLtEvB8cp
 QfTUD2PucuyujRPL0Cev8UIKU6P/XeyhsLbPskGzG7TZcllPEXXhxvpACrBHOZ09V7mEmMJCDe0
 TqRv8hvHO4bgm/NC3ksAlEnFsqC6H0IrAJA9oCw0GmnMTjHA/YLcPWZs5eVVtLWfJ2KZ3HRj1be
 JtbeeXcvUuYpwA95xho5VbeheYrGYHVOC44Ia5vR10P6zsr7BUjZ2eEXVFdJ3baLd1umxBgUzBI
 dOI8Re/9VJhL0MYZVlLh0yHR4CsAk+6WGI/i7GhCM66rODIOYrkAW87kWQNtjL1reyuLWunzdRl
 NO88O1Kb2M0Z2r00J4gWdPRe2iC64X1QfvhDnNi0=
X-Proofpoint-ORIG-GUID: rD7pObitqorW-eT9umOBcNMaixcEv86d
X-Authority-Analysis: v=2.4 cv=T8a8ifKQ c=1 sm=1 tr=0 ts=6a046223 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=bC-a23v3AAAA:8
 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=ag1SF4gXAAAA:8
 a=eDMlovH_pQf_qwTT83MA:9 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22
 a=Yupwre4RP9_Eg_Bd0iYG:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13839

Hi Greg,

On 12/05/26 23:08, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Amit Sunil Dhamne <amitsd@google.com>
> 
> commit 2909f0d4994fb4306bf116df5ccee797791fce2c upstream.
> 
> Reset internal port states (such as vdm_sm_running and
> explicit_contract) on soft reset AMS as the port needs to negotiate a
> new contract. The consequence of leaving the states in as-is cond are as
> follows:
>    * port is in SRC power role and an explicit contract is negotiated
>      with the port partner (in sink role)
>    * port partner sends a Soft Reset AMS while VDM State Machine is
>      running
>    * port accepts the Soft Reset request and the port advertises src caps
>    * port partner sends a Request message but since the explicit_contract
>      and vdm_sm_running are true from previous negotiation, the port ends
>      up sending Soft Reset instead of Accept msg.
> 
> Stub Log:
> [  203.653942] AMS DISCOVER_IDENTITY start
> [  203.653947] PD TX, header: 0x176f
> [  203.655901] PD TX complete, status: 0
> [  203.657470] PD RX, header: 0x124f [1]
> [  203.657477] Rx VDM cmd 0xff008081 type 2 cmd 1 len 1
> [  203.657482] AMS DISCOVER_IDENTITY finished
> [  203.657484] cc:=4
> [  204.155698] PD RX, header: 0x144f [1]
> [  204.155718] Rx VDM cmd 0xeeee8001 type 0 cmd 1 len 1
> [  204.155741] PD TX, header: 0x196f
> [  204.157622] PD TX complete, status: 0
> [  204.160060] PD RX, header: 0x4d [1]
> [  204.160066] state change SRC_READY -> SOFT_RESET [rev2 SOFT_RESET_AMS]
> [  204.160076] PD TX, header: 0x163
> [  204.162486] PD TX complete, status: 0
> [  204.162832] AMS SOFT_RESET_AMS finished
> [  204.162840] cc:=4
> [  204.162891] AMS POWER_NEGOTIATION start
> [  204.162896] state change SOFT_RESET -> AMS_START [rev2 POWER_NEGOTIATION]
> [  204.162908] state change AMS_START -> SRC_SEND_CAPABILITIES [rev2 POWER_NEGOTIATION]
> [  204.162913] PD TX, header: 0x1361
> [  204.165529] PD TX complete, status: 0
> [  204.165571] pending state change SRC_SEND_CAPABILITIES -> SRC_SEND_CAPABILITIES_TIMEOUT @ 60 ms [rev2 POWER_NEGOTIATION]
> [  204.166996] PD RX, header: 0x1242 [1]
> [  204.167009] state change SRC_SEND_CAPABILITIES -> SRC_SOFT_RESET_WAIT_SNK_TX [rev2 POWER_NEGOTIATION]
> [  204.167019] AMS POWER_NEGOTIATION finished
> [  204.167020] cc:=4
> [  204.167083] AMS SOFT_RESET_AMS start
> [  204.167086] state change SRC_SOFT_RESET_WAIT_SNK_TX -> SOFT_RESET_SEND [rev2 SOFT_RESET_AMS]
> [  204.167092] PD TX, header: 0x16d
> [  204.168824] PD TX complete, status: 0
> [  204.168854] pending state change SOFT_RESET_SEND -> HARD_RESET_SEND @ 60 ms [rev2 SOFT_RESET_AMS]
> [  204.171876] PD RX, header: 0x43 [1]
> [  204.171879] AMS SOFT_RESET_AMS finished
> 
> This causes COMMON.PROC.PD.11.2 check failure for
> TEST.PD.VDM.SRC.2_Rev2Src test on the PD compliance tester.
> 
> Signed-off-by: Amit Sunil Dhamne <amitsd@google.com>
> Fixes: 8d3a0578ad1a ("usb: typec: tcpm: Respond Wait if VDM state machine is running")
> Fixes: f0690a25a140 ("staging: typec: USB Type-C Port Manager (tcpm)")
> Cc: stable <stable@kernel.org>
> Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
> Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Link: https://patch.msgid.link/20260414-fix-soft-reset-v1-1-01d7cb9764e2@google.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/usb/typec/tcpm/tcpm.c |    2 ++
>   1 file changed, 2 insertions(+)
> 
> --- a/drivers/usb/typec/tcpm/tcpm.c
> +++ b/drivers/usb/typec/tcpm/tcpm.c
> @@ -5614,6 +5614,8 @@ static void run_state_machine(struct tcp
>   
>   	case VCONN_SWAP_ACCEPT:
>   		tcpm_pd_send_control(port, PD_CTRL_ACCEPT, TCPC_TX_SOP);
> +		port->vdm_sm_running = false;
> +		port->explicit_contract = false;


I have run an AI assisted backport review and it spotted an issue: I
have taken a look and the issues goes like:

Upstream commit adds it here:

         /* Soft_Reset states */
         case SOFT_RESET:
                 port->message_id = 0;
                 port->rx_msgid = -1;
                 /* remove existing capabilities */
                 tcpm_partner_source_caps_reset(port);
                 tcpm_pd_send_control(port, PD_CTRL_ACCEPT, TCPC_TX_SOP);
+               port->vdm_sm_running = false;
+               port->explicit_contract = false;
                 tcpm_ams_finish(port);
                 if (port->pwr_role == TYPEC_SOURCE) {
                         port->upcoming_state = SRC_SEND_CAPABILITIES;
                         tcpm_ams_start(port, POWER_NEGOTIATION);
                 } else {

downstream backport adds the reset in other case:


         case VCONN_SWAP_ACCEPT:
                 tcpm_pd_send_control(port, PD_CTRL_ACCEPT, TCPC_TX_SOP);
+               port->vdm_sm_running = false;
+               port->explicit_contract = false;
                 tcpm_ams_finish(port);
                 tcpm_set_state(port, VCONN_SWAP_START, 0);
                 break;

I think we need to rework on this backport, so I think for the time 
being we should drop this backport.

Thanks,
Harshit



>   		tcpm_ams_finish(port);
>   		tcpm_set_state(port, VCONN_SWAP_START, 0);
>   		break;
> 
> 
> 

