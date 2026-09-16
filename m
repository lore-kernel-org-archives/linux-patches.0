Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A016445AF2
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 20:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789591067; cv=fail; b=VD2C4WZbO7cwuPSXdF9eQ5p0leqAfIzTUpKm0lgeF3/32i60KndHqPUZLc1q1GVg7/j1VqXIj8dJF96KmsSjc2ItoyxrJCLckwTB/EKymtJ0gjiKXTnYcgMk0ROiiExo2sdZuOYc851jJizC71JIpLSJhmS4XwsIU6EFDiZx5cI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789591067; c=relaxed/simple;
	bh=oABGxnxsq43HGMvc49pqdZ8U9pQfJd8wyZfFwyR2IZg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ciEZ5GKN2N0NiA6IoNBEoahZ8bJE8Z60Rmmf2vRhgE0hZBUbPvfBnG82GVhPgXztlFqtNe80Js1kW5CjVOQT3BR1bOD88Bk75TEcLjWlsqMgW25VKVmMF3/xJH8OXX2aHN8lXp9hsj/+NKLQLvBMG20qG8nvtaQiCWyjucdhzHo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SOzL9BBH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hE9gABCl; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SOzL9BBH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hE9gABCl"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GEBdge2983594;
	Wed, 16 Sep 2026 20:37:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0ItrS3qyMEsd4aEz1L66mAGTB/yiYPzNdc96DtM9sno=; b=
	SOzL9BBH6wRj0WaFQBZR1ArsH8QKJ7hnFr0jVFY1yHN7pDlX4y4dx9iei7hZA9jX
	gd2mVgKNJH85zm4UjIlPQRKN/Er0dJXndzkcjRbsdIP7FRYWbmgoCLEB7oFPLwCD
	Gd9XqUdCi1NQpS0P42bWoVW2/1XEen5emBfUOu8vICx76mbS/keUczhwytW2S8nV
	3dOyjrDXdO3niR1/QrV65U6CCW78STkZ8O4asAHOCzzKI0pk5dfoaayrfjUf2kmM
	0ICET5IrVlsU2/yOPEJRMNzGOyasl/JEwzUGoxHUPyw1Kie6429xRLqL2Dm9e+VW
	YcWa0iji2b1zOGtnX1xteg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmwn96eq8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 20:37:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68GKYpoG039620;
	Wed, 16 Sep 2026 20:37:35 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010021.outbound.protection.outlook.com [52.101.46.21])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6e22u1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 20:37:35 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W/hgdk6GGSvUP/62E1eF4ngpWhNTC/XdlcGoRT6LInMqMuUJCaauR5FBuATxUcPnAkgFnJ7wxeRobFEQOxNIJpmSiWbvOQfnJACa/m2MRjPJ8GzZP2/OG1HBg8Ol/apUASrzpr0waaRZbYLgE/KTr9ec9mlPhh+UNAz8rtCVP51k5tR4bO6VJZqACYED8ztbtmjhYtxRkm6b9dPQxxh9LSPb2bAKsz3IxJub44Gsyyr65Mo7sJ/R4S5KINweDy+xKU7CNmrWxs4mtE+uqyw01IpRuJA6XNKHh2xyugIi2MERE1QSTBd9m6UukOY/8+p4GiBv4pBEJdQP0c5IPc2/xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ItrS3qyMEsd4aEz1L66mAGTB/yiYPzNdc96DtM9sno=;
 b=D7rsEIpIOV4PtD3Jr65PHsKj5u6hWhJulhQ+WsFDdUg2LkqomjlKU1SJX6wPLCPzT2UIVX4j/e8YtDBqGrqWkNxuLvlQ+0lfNqi7NjaUGGHzZAok2/QETcmOZ1LW+o/KsVM/TnsGHpqUXq4KpyLlqxRfM1FSkJahPKgttkFnOg81+fWsKKGChGBKY1FBRmv7xnHxwqSEZ8cw7/HTVcELitVV0Kj3Im2Utqr+H0FfAWZateSx75SmCgof4ugdt18n27C+oP9Kd20sjpWtfoLq3++fAxZ8BfYiZutZ9stdo+zxQDM/SQ7h0W0nZMxxHSCjMNZY1Rikbtfh0V2lBsTwnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ItrS3qyMEsd4aEz1L66mAGTB/yiYPzNdc96DtM9sno=;
 b=hE9gABCl+KCRiF+A0DUlc1/fyBDevUTNJ/hmwGOnTJCRXmEuOqVNwekLEt6Gs8kOVx1HFxZY9WJZggVAy60moKkTfmj7/O/wEc70vgaTM+jQ6eMWGkrwuWZh9k69j0IMdz20K2g9vIdpZTFISS2X0l8noU7ZpuZ6RYpF5Fhpi/k=
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com (2603:10b6:a03:3ee::16)
 by IA3PR10MB8707.namprd10.prod.outlook.com (2603:10b6:208:571::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.7; Wed, 16 Sep
 2026 20:37:27 +0000
Received: from SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a]) by SJ0PR10MB5834.namprd10.prod.outlook.com
 ([fe80::2444:1d33:3ce:d83a%7]) with mapi id 15.21.0406.005; Wed, 16 Sep 2026
 20:37:25 +0000
Message-ID: <5f10ccee-f431-4eff-ba4d-8dbf4a3eab29@oracle.com>
Date: Thu, 17 Sep 2026 02:07:19 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 1141/1376] perf dso: Use stored fd error instead of
 stale errno in file_read() and file_size()
To: Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev, sashiko-bot <sashiko-bot@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
References: <c0d91f0b-f392-42d1-b96e-86b5bacced74@oracle.com>
 <daily-reply-20260916-0018-re-perf-dso-errno@kernel.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Content-Language: en-US
In-Reply-To: <daily-reply-20260916-0018-re-perf-dso-errno@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0006.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::16) To SJ0PR10MB5834.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5834:EE_|IA3PR10MB8707:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dfcb521-c95c-468c-3792-08df14325164
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|18002099003|10067099003|4143699003|6133799003|22082099003|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	tTL8GgcPGwkTr7DDQ3erzXh91EEE3Das+wR0++blwR5JTBt/nGQC2JAPvTRfWNqUUDnOBr5+OeJ7611eipDZKn+C0hz7uF2lj/wE2/n9GZNrfqQslJze3lcOE46flnzfkzsyA1DJvk/dvupIsdUNpkLYEcKi+SfOamC8Ngurr9E2hjhelFoyaQ+WXP3xOnboUyi7N9lOIR/vTJasTB7mC0hBPtbN40/qGMKJkVIPQ1VAepoV0YUohK7GGczh4SKivCcCn3A+zlxfnj/5RGoHOmS+xT8chMSovVFDSO0e+CbCZcLINRb17slwzd3dy+UdHMyKepl7+reUFprVQvJNpP3r8bKUyu2Os831cbFz7Zf4khnziQPjqb0A+FK5bvzPgBsmEW6iRi++/0NPyH+5r7t9x3n5fbE4OxGm+c0h6f7J5O0laSrTtGzWdxY/g7lAXAY2MGWp1vDuzerc88X+Rhy6oJYdxPiKLCZ2xtnhLkv/3nYqVOTjBNwNH51S6h3v3laTvexnLq+XHoM3sH7xJ+1kazJXi3t04FOuuGpamvqwSKmqAMex6FVjZTqJktxMoBq6CCTfu6d+B1VaB6wYW+5lFoPEFZr+SJkX1EDqSiGh4OPp0Jnj7uUJ34AScFt7HZCkx30JYCZyZPfxXop+lIOnEX+QkKC/niYLOD+rheA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5834.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(18002099003)(10067099003)(4143699003)(6133799003)(22082099003)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eThOUXlObTd1c2Y0QXk5elp4bGhtbkdBMUxVeEVEai9PQjIyRUFZTGJuN1VX?=
 =?utf-8?B?MDdlNVlmdE5OdUVwNE00VndrMkJPQmxQejZYT0dBRDhlSHl0aFJFZ1dHQ3Zi?=
 =?utf-8?B?bGRXdG4xeHcveVoxZGJqbHcyTm1Ed1pYdWlCejZSK2YvaEpFaVNjN0R6SU5a?=
 =?utf-8?B?L3RPeHNmdDhRSDRiTk9PZEpuV3NaWDVWOXdUaTFXaVAvRmw1N2Y1YytFc1p2?=
 =?utf-8?B?UVpNeG1FdjFGaTlCSDQyS0pCM2tYYXBHcVRBS0xKWXZiV0VJbTVxbEZEVmJG?=
 =?utf-8?B?aHVQSUpUOGFMeGpsSGdoVWxJbzVxaXJmR3RuRUIxZU5UNUsvcjJmT0JmcXZE?=
 =?utf-8?B?Qyt2NVh6NjduSXFtWWxRb1ZVRHJzc09LTXFGbHpWZHNua09wejZqWDVQSHFo?=
 =?utf-8?B?dTNwdTdHUVdPUm42RUVQbVA3cmpURjhrSEkvaVdvNjBkQXViaHpZdUY5MWZl?=
 =?utf-8?B?RURiaDBtNXNBT3NOS29pRzdyY2hRM0lGbGlleThDMEc1cnhuNjhGanVSVmlI?=
 =?utf-8?B?WWU3Sm5IOE1qL2ZveCthYmhUQk5aQmRvaVpBRU1ERHRvTElPMG5NaWp0emtV?=
 =?utf-8?B?bmJnQ3BqL3N0b0lmZXEzNzJmTXZFRlhoVUVleGVQaENIN0dOVGR5Y0xSYmd0?=
 =?utf-8?B?VWhuOHQ0bjhTOEJVS1BBc3V3Y3ZTOG1UTVJuSWxjdzA3Qjk0blVkYWpXTDRH?=
 =?utf-8?B?WDNBNENuSDhhWmxYbFk2R2NqWHRrZDZWdUVyRCs1eXpWZjZzUGc4L3lWN1FS?=
 =?utf-8?B?a2dJeWpnbUJ5enlNVGZGcHVqUytYdzdUN0N1TGZnTVNaOEhZWHlySTBMeEgy?=
 =?utf-8?B?d2piZlAxZStBMTJ2MUFSKy9ZQnp6R3Z3T1IvVW1TQ2Iwb0syaXRjS2taa1Rl?=
 =?utf-8?B?Skh2cGp5cGtNeUZEZmp5S2hzZCtVWW9OVnUwYTRrMDFleHJmR2ljVHlEV0FY?=
 =?utf-8?B?SGtyT0p3VDVnWkZxdGN1U001SE4rZm1lLzF1M0Jzdmk3dW5LUVk3dnlnT0dz?=
 =?utf-8?B?ZjRRbDFqRFk3YTc1TTFQNFZ1T3JzU1Y0cjBNd3NIMTVsRjRrYTZHOUJBV29G?=
 =?utf-8?B?OHc5U0xkL1lZcTExY0FIcm5HU0x1MDdZY005S1BDalk0NVNMN1hwOHVCNXdN?=
 =?utf-8?B?c3d2ZDc2UkVhOE9jd2FOS2E2NFJSU3NDYTk3RzNKNUlnZGhDYW1YdlgzRjJ0?=
 =?utf-8?B?Ly85VXd5d0JPblRtNXgwdjJ3RlpOZy9hWTR3NDJrRUJYc3RLWXF3MFZ0UDRN?=
 =?utf-8?B?djd1clcwZlpQVDliTjJiNTl3OW9Ua04wdHFlc0czTjBGeGVqb3lkZnlKVVNU?=
 =?utf-8?B?RjVkVm4yOGFMTWZBbzNNMkRJVldrcEZtbGwwZjRsMXR0NFdMTUtSd1A2OWZP?=
 =?utf-8?B?TGgveVIxa3Y3WElnUzNJd0RSamtzdHU5akR3S0JBQnZkQ2poRldiQkQrWFly?=
 =?utf-8?B?cXlLVmRpb0lkRjkyT3hGRVQwYVBOeFdjUHFOMmswdUh3MVNNS1hNUUZ2TlFP?=
 =?utf-8?B?UE5WdjBCSWVhcHFyZXo1cnNsWmphMlYrV0ViYjNaTE1ydllmekhQaFdFMWo4?=
 =?utf-8?B?c3Q0cVlpeHJxMzl6VnhwMU9vMS9VSlRCNzRsc2tBZi90R293TjZncFI0ZWNL?=
 =?utf-8?B?RFhuc2ZhTHhZQnJ1NDgrcVIwS3gwbC9lZHgwejRyemVPbVFlSUxyTWVHeFBq?=
 =?utf-8?B?V2NCOE00RGNCTUtPSDJnTnJCc2RnVEFrUFlxajNsTFNVOE5BWUpDVThKT3dG?=
 =?utf-8?B?bGtxaTVPMi9QdkcweHJLM0lwYS9lU1NXZysxcU1rWlhnVXQ4SThOcmZheWtW?=
 =?utf-8?B?ZkpWZmtiR0xYa1pnd0JRRlB3SUg1NmJaelZqbVd0bTBJYTZHSUNEdkJVUlEv?=
 =?utf-8?B?ekFlbFRPVFZFYm11WTdsNW44V2dkUFRhZlNnQ29wRjNvS0VHTk82WXV6MzJz?=
 =?utf-8?B?eFhYa3J6OEEwdjhMcS9Nejg5TTJGa0JIRllRNElFaURqWE9lK0Fhb21mZDlh?=
 =?utf-8?B?S0NOMzFaTFFIbTVYYjcyWUE4QW9ZUTEzQjJhSEpHZG5MSkdBYXJTVE1qbit1?=
 =?utf-8?B?Ry84T3lwT3NVaEhQbXd6WEpvemwxdjNVK20rc0p5czFzellrWlRpRTU5RTkx?=
 =?utf-8?B?T1FUbVBBQXdKaFlzL0UxL3pWRjUzQjhEdUFqYllYU0RaSUI5M2luby9XMGlK?=
 =?utf-8?B?S0cvYUZxOUtoOE84NXdGbGVDSk9WbnRiWHFRYldDUU43Y1FXTFdCZnUvVnBn?=
 =?utf-8?B?U2NhL3VFNGN6Y0Y1aGE3U0YxUithNjFFYmdNZUQxb1ViT0F5UWdaczRYdUZ1?=
 =?utf-8?B?TVFjdU1nblRpU211TDlwL1F1QnEycFhHNDBNaTFacS9TUW90M0lRejJMa1Ir?=
 =?utf-8?Q?Sk5OpjYL4+Npn7YmEZXPOBqiWN/oORfurCldZ?=
X-Exchange-RoutingPolicyChecked:
	Wux+303sv2bS7NV9UQ2TS0Kg18s8z7Qz4nzmL7+PrS1v3V/x6hG5l9ngtEeDyIiLZE0keXMdbqvoeMUhVGbl5GBNGR27EgimkOYcx15Lyt/rnek0O2WUJ8wPZ3FhbGIUKg4r1q1jyznM8CaSsQC3NV4W56zwsJkNmDNEQh+fJKr/Cx+6lPg9U8ijOCo+auNk5CbDh4lK0pwVMF6kWAE1ZPm31cqrak+74gxSz6mD7zgIWkq+COcGfnyxcgPDndnlt3SIcWq1QGdJfcIB0zqpI3jNpdR/NMc64gJhPSg7Y+3kWORE80ObD6QNDFzdys3Us/PnddZ+5FKBseYMLxK/Lg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hZ4MQAd7LV4ytjf9RdnDHm2rcV0N0SBGN4YK8g91pnISY5MoNkUnkzP6w0qD4VUTq44GcNqTPKM/uWjE/CCvlxrzEvi8/vE5MX5/ycYnLUdl5hc8mfCaYocF5WFWbPeY4RI+tlBScFB6HT96dy3brVbM5w+ng2Osz+ooMOz7bw+kt40qhNC94+zC85e3DSby37eWM8oz/N790iSTu21RPLzuunCSD61FGttzZXUj4t1zTudsdGJmZDaWJSNlXYOf407SFLYy5FkKegS5qOlm26b1YsLUvkQewUEkkDsNnusnYCeOiW3UIrHY1GYFVUbz39+sa+mpBh1Eq/VKuf3Tz5Q3J0F9e46Uyk+5of5J9yyUXgeG2v4EO0tprHT+EjBy65HYPAWgfJhnCzg5SOuvR4zyOcYj4EvnIEpXJQgsCC0+vkjl8mcLj0ZFnZkZjgrMCTSer0KsBqmhDhsmjHfodIPvlVwbGKGtZxwPUaub4dSwpVyZ9mHg+7CcBOHMk6Q/QTnxfcDjmCUB09w/ZxFs5+kRefNJ5H4aKPmewpYWwZ9lXw80lqT8Dh8ftPsvD1ugmRHafQu7yfApdxnpvwa/JwlgMIV6mLSUjq4ftD/UCNM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dfcb521-c95c-468c-3792-08df14325164
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5834.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 20:37:25.8761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5LuRZP3PU2MF5KVrnqI39wUKVIVEJh20P89ch2kwVprrILgrHdj4/AXysJVm3kY4WMknIoYh5ATIHcrfp0oA/WgLU+n0WPn1NhYT01VYjoTj2CfFZLo7vIL4gj8cpp4e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8707
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0 malwarescore=0
 mlxscore=0 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609160286
X-Proofpoint-GUID: T_-gER1PZqUEUjuGDeBGgz_ezmupxt9j
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDI4NiBTYWx0ZWRfX1e95e8YYtrnh
 qAWZcd6gWC4MYfWm7RAtfOdZWF5F9R18gnJ2qjmcNAZkHrYD1mNbnyK7LWvp3DyR1dBYKXbCyTb
 IDayIVR+M12WCkf62Fx64qlod3w+R6suq0Ezis2IoOSTrObCgyjD
X-Proofpoint-ORIG-GUID: T_-gER1PZqUEUjuGDeBGgz_ezmupxt9j
X-Authority-Analysis: v=2.4 cv=c9k+0h9l c=1 sm=1 tr=0 ts=6aaafe10 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=fp1FKX4UgyLWMPKHskgA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDI4NiBTYWx0ZWRfXxxXx/vrIdt6y
 wKjnl3OcW/3a+yGgQ9fScr5zMHq1RSHqIEret/NLeJCWl3uAxTrZbwWzufWFEt6HDsnvJYPPiC7
 sAc9caDAygwXuGi3N2+TyJMQVL+xWywieRCJpeMf5kRPeBcfXU30JlvAaF4eNC3pgJpRRQDzk6I
 uH7PZ6Q4v0IgV43M8tQS+Tx8/ZmuGBfnI054JeNfEubFu83PCWwhU9qx2SiAhLxumHnKM7AzY1r
 0VLTtPxwTVm1gkcd+WWr6GZiINZr8RfwC45XClL5Y3c+aj2VklaBiOavTNx5jy4dlpykFEMA50u
 ZZp17M3B4jxRxtystYmK3A0AR7TgQ7xS+Sju7h3sQ1ZCCweNM+WUG4Bfgfaryem8m32qJW8XmP2
 I1wHUAtQEzmp2ASf5OjjAlztQ/iI412kZiPOYTRZUMI84ikphMVQ2bUdknbGurjciXIIivWVgx0
 rjXfcK2tvO9PwiAZWVw==



On 17/09/26 12:58 am, Sasha Levin wrote:
>> Upstream prerequisite 1a5f9334a45a6b0c1cd7341cc72a3b87adad1d27
>> normalizes this failure to a standard negative errno. Maybe we should be
>>    adding the 6.12-equivalent fd = -EIO adaptation before retaining this
>> patch.
> 
> 1a5f9334a45a ("perf dso: Set standard errno on decompression failure")
> patches dso__get_filename(), which does not exist below v7.0. It arrives with
> 069e603d8248 ("perf tools: Get debug info of DSO properly"), so there is
> nothing to backport on 6.12, 6.6, 6.1, 5.15 or 5.10.
> 
> What is left is a hand written fd = -EIO per tree, which is not a backport of
> anything, so I am leaving the queued patch alone.

Thanks!

Any thoughts on skipping perf patches, I see perf build failures once in 
a while, but I was assuming perf from upstream could be used.

thanks,
Harshit

> 

