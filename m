Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800DD370ADC;
	Sat, 29 Aug 2026 20:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788034367; cv=fail; b=n0Nly0md7vILxPE6iZGXvZKUWRkiksFRftP0Bjg/1JHzPCTgqVWYvgb8HKOgI1tLkhHQAQOqkl7zER+N1lRFyWqewDlcZCoKLOg0rjDGVweBXbVMc083blEOMY0jVnn+jS3vHw8qUFuIuBO61VUOniJUo0eAgxyGhFjzhJZn3No=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788034367; c=relaxed/simple;
	bh=xf5v9paGKBvPqfuBFtcRGDiYOVltiNOJtbH5IULdLCM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=khLtuEt0J8PD+v5EIfIvr6BHSSp7hNxts59GQ36rn22CMk8wjE/N5F1cwlZkrOo2q0T4NYKWor9TNsbL947d4bxz6HAITbfsMPjC87Rlqa8cxLEth8qu8laIvQ5BepuKUp/Q/sY1yoM/8QYopV+Y04ZHTv0H3SbD+gDUIogy8C0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XYk0KsjW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AEHXpJDG; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XYk0KsjW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AEHXpJDG"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67TJZ3s61547674;
	Sat, 29 Aug 2026 20:12:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=AiPb/IBFGfKJMFowFuBaRw7saQbbvYeHY92kKWgX7cU=; b=
	XYk0KsjWbywtR78JuOm4NuzRPVVRWHLgMDECfJX/eXcSsXbKWZ0BC4fanuS/EeAR
	hqzmMQjKxLghgB6YDWqGKYiyeWgSxXYZNCr5tVLbAtUG+R+jrBZvAqxd/CcgGVl1
	vwiGx+PWOZRu/LsH0/mXkMdOXaJpiUqTB0KgfEDLy7Qe3aiydho4GkxQVohluk1q
	RGK3JwiOATPYp5VOlOEIzn3Z5aToDtMHd+jVkxH/kGiIGJiw6QQIwWqaxd2KVrpW
	iro9a95SgQLyjLHoNQqsWEQqvjeETGqC0765YeLdR+gO7tzeQS2ZAOJGoGm/t8Os
	CnnozLPpOnOK4YqBN+u4Hg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbp0xrm06-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Aug 2026 20:12:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67TKA5kU037037;
	Sat, 29 Aug 2026 20:12:37 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013032.outbound.protection.outlook.com [40.93.196.32])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvbfk9f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 29 Aug 2026 20:12:37 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P9LQFa7DkLqyS4RHlLJRuYIBCQ/PVIHRsNv8eg4mM1X2sOhea0trv6KQXFxKfQVV4EBxvqQcs8146ZLf4mCnSTRw5vWQWM7lK/VWNxE9aPfCSmce+QoJEDcDLC/wYwCVO1itCk0LN8cSm+1WtcxWftsKSXPqKBpr7lEqXJrpfthVGfNV45Cn+opusZN2Tz6FvZRznRdQxTASJ4BMJgxbUsLtfpohU2zSua46cJh0UtlMLC2VNrYk9knXuAi/+yQt3urs96xysxwMD3MN7b9/AQieM6yYpE/ka1DYm/kLF0vMXTgzppNFSB7yHjUMNeFY2GmEcUvGLpcyouYFBKSE0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AiPb/IBFGfKJMFowFuBaRw7saQbbvYeHY92kKWgX7cU=;
 b=xvPyKMYspP/vAU0fYWrncXGbWC0E29yJhQ9y1nAUiLDxBeArrJed3XyRWo58/t6px7X4F1S+dR1niFkGtMctncoSg85d076UIZpwvZqhHlTuCgi2SSmjzQW80YBPFtW4s3kRdCbqt6XaGIdT/nmgOfYhJTPgTKWSqxNJlfs/KN+URrxW+N3smaxtUcXtbNwCo1WTGBg4RpLxk+r/mOJvI2W6d7F4zExrkvvjPG/cFAuTvDgpd7H2aspw227ZGNL1N++k9ZuP41Jgrb/ShTrjquq7VpdzYRyjgjAdL1wT/GIYA5jkaLJWAoWKmhFKKC3xs1IZu2/4t0HNWGuM/fLhjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AiPb/IBFGfKJMFowFuBaRw7saQbbvYeHY92kKWgX7cU=;
 b=AEHXpJDGg07vutltv6xegMPBaLj43PGEF/YUSlna5BaPgZtxxY/wN92foPvzurOKDRH5Fazur+wRVpXXN75R7ARICW1PfbyNLZuPWP2/QJduNIX3vnKnOYhg3yfpWO82C+7tLk76U54y/w+uzfkP090Wirmz4ntEiDr2mMpYKpU=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SN4PR10MB5606.namprd10.prod.outlook.com (2603:10b6:806:209::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.9; Sat, 29 Aug
 2026 20:12:34 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.21.0382.007; Sat, 29 Aug 2026
 20:12:34 +0000
Message-ID: <69d0d491-b9ef-4e85-93ba-d500de1ae6e9@oracle.com>
Date: Sun, 30 Aug 2026 01:42:28 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 184/220] ring-buffer: Make ring_buffer_{un}map()
 simpler with guard(mutex)
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260820145223.480031205@linuxfoundation.org>
 <20260820145229.026410329@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260820145229.026410329@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0467.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::22) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SN4PR10MB5606:EE_
X-MS-Office365-Filtering-Correlation-Id: e8a99024-18b4-4773-bd8d-08df0609dd4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|6133799003|10067099003|5023799004|18002099003|22082099003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	BIuF5Ei+xl3xza6dPW8iYor/BDzxVZQw97c9zRd2vbAOmvcY77Id3aTGsWyBli2pEU8qwVnuwlHFPbqojW11Ir7/fQ+AVc9b8glCmPZX42oVbS2Q8xx5woZ496t3e267rsm+jRY9ERFwf8qRV/bnGeMKxdW5EOOHDgu9c/kYWKrTihmDp4evIYlJBuMtRLLMgZ1uqc23f0UHdrawAQbWtkpCvyxp6PUl5TtBTpknTo2ZytPuLyC/ye+kJxWtu9XqYccjrEQGcaO1W4E0Sktr0+Q5Q6yQltWJQZMQ9rk5EL7GAd6jig9divSMvq0QLEMaeGd0CGSEb8aqASmV4dIGByxDWbLMb34IogYM2POhQ1X+6hUVVvQNrUsLpInrEAVFW8oKg/B0V+9A2VFTHiyC42l2gll5ArsCL2S3inpZ1qlHcFA6xcrq0qY1KO0tSbAN96hev6JLVZg1v5pwGdnAShBHUh8cpvUyikm0wQpaqv4SWbi5JAI2U8XQlwNlr6L5QZc0jR+Zvogb6hmWYmtX/iGhcwK7lxJUFTT1O9Tt9/yOyyBAQppSOTbi9oD7FSL5CaYKt0B9P75rCIsH3K91G55YjGh0jUqLN+wciGZvixS3sknFFl25o50AbGj0Skjh
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(6133799003)(10067099003)(5023799004)(18002099003)(22082099003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SU5iaWNTbFp6OUUwdnpwMjVROTZ0d0N4a2VpWjJ4Q1ZNYlVaNXBtTlJOajlS?=
 =?utf-8?B?bHl1TDl5L3NlTUE2ay9mQ1R4cmtuendtWTJvdzhJU2NoNmZXckdnQmhOWFB1?=
 =?utf-8?B?Z1ZkQlFqanFpSnpuanVzWFQ0b2NIbVVYeEdBNmZmQ1E4ZmVoaW5kNkFmRi8r?=
 =?utf-8?B?clFnb216Z3JkZGc2MXB2MFo2OTdEMi9Zc3QvaW1iQm9kTExCTzBOMitpN3VT?=
 =?utf-8?B?bUNWUDZFa3dwQjkzMTVqdU16TnVUVTFtdUxEeEt3b2ZqNTJPaEVZTlpQWEFw?=
 =?utf-8?B?cDJJRTF1amJhd25JNURKT1Z6Ryswa0t6aEFwdmxCK2hQNEVob1RXKzF5d2VJ?=
 =?utf-8?B?d1RReVIvOWxyUzJNRFFvTXB5cXprMUJybHpCTGFXZmZJUmJ0aDFWREpZeXEw?=
 =?utf-8?B?UytxbHhqUGVPcm1hQTJBWHdra0lQclB3NmtvQytGc2VGMkxsYWxWN2FwdW1X?=
 =?utf-8?B?SHJvbHpKamV6d0lvZVlaRG5CSU9PSUdmSzZWM3FST2FoTllFYll3OEwwZEUy?=
 =?utf-8?B?WmlneG1DaVBmdFhncjg4Qm9qSjhJQmEyUDVySzRsdnUwd2lseTlHcjBzellU?=
 =?utf-8?B?VXNQUHE3eEdMd2pvOXJPYjFuNFhzU3Z4WGJ6Ykw1NDRybU45eHdCc1JPNUNO?=
 =?utf-8?B?Vnh5NTlPLzAvYis5MmhnT3M5ZlhDUUwxYTI4dFhlMUJCbHVhUzhlRCs4UjNa?=
 =?utf-8?B?VDlneExuMlE2TnFpcEdqbStZbjVBWjRMMnc4a3YrUUU1QVl4dE56UjY1Slk2?=
 =?utf-8?B?cllUR0lHSy9KeGk4SDJEMUFlRXJYZUtqWXpHdVRNZExGc1FoYmNtbTZlekRT?=
 =?utf-8?B?a3YrbnlFZzM5YjZvNlYrMjgxdzVDQitpTklmZ1IyRG0xV05MQXFFS0U2dTRI?=
 =?utf-8?B?dEVzclQrWlUyTDZZSWRhMjVkNi8rcXdJQko2M3E5ZkxLR1l3M24vVm5FZVov?=
 =?utf-8?B?N3F2RS83dmw1VTFsWFo5eXZrc2NVbkVYMXBoeHlWa1dBSjJXaWFUK0tYOE41?=
 =?utf-8?B?U2d2M3l3dDN5UU0rWXFYYXM5VkwxbC9TK0wrK2xxSnNCTDFMa0ZLUG5sNitp?=
 =?utf-8?B?YXhVSmR3b2F2Z3d3RWJseTlwSDhuRkRGc1pJNTdPS1BqaVZucnR3L0YrS2Za?=
 =?utf-8?B?b2dEL1g1c1B1RWRjSFRHVlhMbm5CWm1VRjg0YVloNUVZbGl6VXJFYXc5Z0d6?=
 =?utf-8?B?dUJqdkZGazhqUDhlN0h4ZEFoUUZlL3h6NmVLL0t0RXlaREZVSU9KVE5ZUnpM?=
 =?utf-8?B?MXFhbXgzSUNDcXdqQ1NVUTR1bXhNM3R5eXoxcVZ4cWY4a1QvRmxQM2ZZN2hp?=
 =?utf-8?B?cmIrQUgvbHVJL1ZqTjJPT09QZzUyeWJEcWJ0VnRVdFJ3NTdpTXI3UEFSOXYx?=
 =?utf-8?B?eDVmYXovNUJwVGFjeDBkMlJOcnpWZnZSbWZDTGZhVnJsWTVqelVzNGhZSEs3?=
 =?utf-8?B?T0l5MEFUZzgySHB4c3RpMFhwU3k3NVRJMFRKTlpxQ29rRENmNmxHOVJpaWVD?=
 =?utf-8?B?c2lZSzVtZ2QyY3JEdXFFdGVuVG1sVkYyZlAwKzJ3U2xwSy93NDlFUUo5WmdN?=
 =?utf-8?B?OFV4eTJ0T251SFhCSlQxbm9iRFBmdFUxVXpVOVJkV3NUSGNQYWt2NHU4eHdU?=
 =?utf-8?B?UkE1TG9OT1ZBRml0WUN4Rll1enZzclhjUWQ1dFhUNyt6QWdkM0ViTWV1aGEx?=
 =?utf-8?B?RWNTV0tnQ3ovdU85bWFTN3UraUwxR1RycVRzUml6OHNsblVFaE5sQksxaEds?=
 =?utf-8?B?SUVnNDEweW5XYU5Va01QTkxobEhsOTEzM1BuQlpZLys1aVk2ZnlycmFSZDJR?=
 =?utf-8?B?ZGl4SmM4ZWF4dHU2LzNRKy9QS2FFb0xPeTVMQkFKa05qUUp3UmtUeFhnbXVO?=
 =?utf-8?B?REtmWkx0NEI3VVJuKzBiQmhiSFhpN0VLRUxaWTIxSzFOMmpFem5KVEFlWjhF?=
 =?utf-8?B?eXE0WXd6bU5xYUxYemlYWWFjR2tuSFY0THMveGpqMjEvekVUWm12TVdIdnV6?=
 =?utf-8?B?aXpQbm9WQ2JLT0poUEFnQ3BkR2VWb09uLzFRdG93bnlNZWJqZmFXMjBjOHpn?=
 =?utf-8?B?VzFTdkdZNWwxUEtVcjE4TWVJb0lmbGV0SDNJN0NFaEdPUzhqZEhDeW9lMHM3?=
 =?utf-8?B?OWVYTmFodnZXdWtXWDI5MzN0eEhwMVRpNkJlM1VWcTJxaUU0MmEwN2ZlVXgw?=
 =?utf-8?B?K1pRNnZSbmY1NnU0NFNTU1k2TEI5cy9xZFRJeFd0TVFMTEVkWmVzVWtTaTZF?=
 =?utf-8?B?YXAyaWtLYTk2TDZkWENFSXlPaHl1TTJtL2k1ZWo0eGFpSUQrRG4wN29GSyt0?=
 =?utf-8?B?OTBEMEZXN0tiVGc4R2JTUGV2ejFkRFdpY25iZGhwalNlV0VJVHR5dmZDTVFF?=
 =?utf-8?Q?xq/lezeaqAL0XDByTJY4fWbhZSzO1Ej1PHDo+?=
X-Exchange-RoutingPolicyChecked:
	Nwyoa1JweHhOuW6mFfL9HRlpKxQgFVTsSd1KCLv9/xgix0wI19F8QmO6DpNHgDc2eFVoWBO835hiaNxS2loSqqj/T0w507CYaZ0SFShCA4+RiuFckdUQH3/wtN1aS3tzug54Z3UfXo9dpKi31qEZMVq+71z7oekRyf//x3ch4X1lKu2hDidgwrDmz3fvg6VRZ8rtoLsMH5YWXNMd1Q5u+Nv+BEHS70Ks1wd3HwVscvTHEl7a3FMCmTzNk11RRK5BBT4XZsdZ4ug5wUjsegmC3HuQQIoic6fj3otYUexzZCFoOUvAd9L5+EBhnKBjxmeDBhLtg6jnphVz0jxwa+XXVw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9DLoUCvuPfybLoWfVLhiGB2LzP6U+bcgZXJrklW/iIAe2Ei3/WxTHu4sGEFYTAGmbGAPYmxdD9zvLVxb0PmSwiM0kGcgIyBoltLU+tN3XhlRNgie/GOh6f+s1Nk8YkcdZ9YmCw8q0xy9e+HZx3YVmtJtSkB2rjzl/E13WpnnX4NjuU06VhXSvz8wpkJGDptjthepJrJALd49pDzp2hbG+imBV9f4QrMK4qlSXi4T3ezf3Ezml7wRjQ2JpYYJrZzMiqKsJs1IAPm2Qt4g38NoaCHluT9qmKv4uiva9YCv+CInFhllpHE2/p2casOAJOlQEUATEwL2UFLQYM3mYLBhk5cBt3x70tUYVtT/sOe5smoqJcihYHPX8MHVptQmlaI2QqwB9PO5vO6mz5IswkxMSU3EVG/5N37JreFbdE35k6Z9X+WJGy/jdvy9XloLqnsBVaoPlGNGhWL9hxNw2EZm/XYZkiGEdg2/pMAH3N1IfSby2LY25s7s04dKAoBDwLqYmdBZpjZJqvnXCQ5Ur8p35Z54cgdgBXhpj7L1hDQMEi9rqUAQZ125cn/yEtC6ElHfzm5KLizhoSzxfpOAs7YQatA/dGLQ/DXVAvZziqsBjbI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8a99024-18b4-4773-bd8d-08df0609dd4d
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2026 20:12:34.7873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AUCReCu3Oa+DJcQDDOatS8IKsG23SrA3HX/peScmVZcuNiWPU423+owElICduThMOTR0yy9ZySGRGD4NF5c2klTQr9+np8jWKPnITChf6LmpNdLDpWWNA4BDUmzwr/3c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5606
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-29_06,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 mlxscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608290175
X-Proofpoint-ORIG-GUID: U_zF09Hf-pik51c5j7n4o3YQ0rp5qU0a
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDE3NSBTYWx0ZWRfX8c9OzoA0ztTu
 s6/U7JDRqLKVaCwQ/lYOh3qnnO0dT9Cfj3jiUKMP7FQ0wyFmxaRmhzr8tcv1fh43UlqjEtl4CO1
 ZSdt6unecLduXr0Rs0rzOBfLOT7HlmXkqYb6i2CzasEDNrfI6ndjS0dbqZeQSH5E1epcamkH//L
 gjDHDp1BOPkI3tCJVCYO1qdugnkijnLo2hJqRO9aJs5iEVGLM7LxCsm12avL6VESDY2XIu6DeiZ
 QuRPWMBP7a5fGl/mZF2lWExMmTNDDoTLUzgmOfQKCkq7t4zS3xwu7LFs7iu1JcWBpX2BiprQ8g2
 qF3pM9KLG72bqpIYYd+k8oZ9JB650j5Syh+l1icExLDkYzNpcGR1y+qFuiYY+7rzJ4HUHsPX6yZ
 46L069pMV5YYSsURgxbHh6+buVc9y8MXxGdYMjEuPSuhDEYG81SkvvNugJneczzdgHcyzhZ0Bj7
 eX4YFBw++qD8CwII2dw==
X-Authority-Analysis: v=2.4 cv=Ebb4hvmC c=1 sm=1 tr=0 ts=6a933d36 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=meVymXHHAAAA:8 a=7d_E57ReAAAA:8 a=1XWaLZrsAAAA:8 a=ag1SF4gXAAAA:8
 a=JNz1yhM4ZpmGGPs3_DoA:9 a=QEXdDO2ut3YA:10 a=2JgSa4NbpEOStq-L5dxp:22
 a=jhqOcbufqs7Y1TYCrUUU:22 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-GUID: U_zF09Hf-pik51c5j7n4o3YQ0rp5qU0a
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDE3NSBTYWx0ZWRfX28idCistMoET
 8EC9nPtqmb74/fs5XVQmK/p8ONjRNRdPeGdI8RqJoOya32QdpKIdRIVBOPIOFbB+bQ8XS2Q9/5y
 jDzVmxYA8WOzycCgjAl9gqgi06HLkgJ5JLXs3HKxPnlglQo9pEXg

Hi Greg/Sasha,

On 20/08/26 8:26 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Steven Rostedt <rostedt@goodmis.org>
> 
> [ Upstream commit 60bc720e10eac397b3adae975095df77bc368b88 ]
> 
> Convert the taking of the buffer->mutex and the cpu_buffer->mapping_lock
> over to guard(mutex) and simplify the ring_buffer_map() and
> ring_buffer_unmap() functions.
> 
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Vincent Donnefort <vdonnefort@google.com>
> Link: https://lore.kernel.org/20250527122009.267efb72@gandalf.local.home
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> Stable-dep-of: 7c727dfce6be ("ring-buffer: Prevent resizing of persistent ring buffer")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   kernel/trace/ring_buffer.c |   35 +++++++++++------------------------
>   1 file changed, 11 insertions(+), 24 deletions(-)
> 
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -7097,36 +7097,34 @@ int ring_buffer_map(struct trace_buffer
>   {
>   	struct ring_buffer_per_cpu *cpu_buffer;
>   	unsigned long flags, *subbuf_ids;
> -	int err = 0;
> +	int err;
>   
>   	if (!cpumask_test_cpu(cpu, buffer->cpumask))
>   		return -EINVAL;
>   
>   	cpu_buffer = buffer->buffers[cpu];
>   
> -	mutex_lock(&cpu_buffer->mapping_lock);
> +	guard(mutex)(&cpu_buffer->mapping_lock);
>   
>   	if (cpu_buffer->user_mapped) {
>   		err = __rb_map_vma(cpu_buffer, vma);
>   		if (!err)
>   			err = __rb_inc_dec_mapped(cpu_buffer, true);
> -		mutex_unlock(&cpu_buffer->mapping_lock);
>   		return err;
>   	}
>   
>   	/* prevent another thread from changing buffer/sub-buffer sizes */
> -	mutex_lock(&buffer->mutex);
> +	guard(mutex)(&buffer->mutex);
>   
>   	err = rb_alloc_meta_page(cpu_buffer);
>   	if (err)
> -		goto unlock;
> +		return err;
>   
>   	/* subbuf_ids include the reader while nr_pages does not */
>   	subbuf_ids = kcalloc(cpu_buffer->nr_pages + 1, sizeof(*subbuf_ids), GFP_KERNEL);
>   	if (!subbuf_ids) {
>   		rb_free_meta_page(cpu_buffer);
> -		err = -ENOMEM;
> -		goto unlock;
> +		return -ENOMEM;
>   	}
>   
>   	atomic_inc(&cpu_buffer->resize_disabled);
> @@ -7154,11 +7152,7 @@ int ring_buffer_map(struct trace_buffer
>   		atomic_dec(&cpu_buffer->resize_disabled);
>   	}
>   
> -unlock:
> -	mutex_unlock(&buffer->mutex);
> -	mutex_unlock(&cpu_buffer->mapping_lock);
> -
> -	return err;
> +	return 0;

^^^

I ran an AI-assisted backport review and then checked c7f40b670e5c 
against the 6.12.y code. The refactor changes the first-map exit in
ring_buffer_map() from:

         return err;

to:

         return 0;

That unconditional success remains in 6.12.y. If __rb_map_vma() rejects 
a writable, executable, private, wrongly sized, or otherwise invalid 
mapping, ring_buffer_map() rolls its setup back but masks the error. As 
a result, tracing_buffers_mmap() reports the rejected mapping as 
successful instead of taking its error-cleanup path.

Upstream fixes this with de4cbd704731 ("ring buffer: Propagate 
__rb_map_vma return value to caller"). I think we need to take this as well.


thanks,
Harshit
>   }
