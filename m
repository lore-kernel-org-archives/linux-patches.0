Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86A43F413E;
	Fri, 24 Jul 2026 13:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784899732; cv=fail; b=PaadlfJuPyF+Hk4XYAPGhTqjHQH0Y/AQrEz/AWeGFEbNiOuFvKIhdt9DYzdVPmF+0ZWX+vsub+GhELwWzh/k15NbhS8ZxRJOUSVxuaWdX4FhR97C1DCA3cgl4pbn9CEv1XAop4hVtiapoYnJYvJJN1uS7oj/uIl6AknYNL0F7BY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784899732; c=relaxed/simple;
	bh=BMYyYxpCIMpNvh3uXruBfYyY0dYnoJYpJz40tFDNrMU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Kf6mS6e+NTL6TcFcsCmAHS4QhH9Dcs1XXLnkiWxS9effe7NwgMXmWPCchzsAUhtuxGRG7dyqod19+ZwnahYnZxwJ9QI//d1SsoggaU1JVA9x7G3/V1PPsAdVRQBJDPQdYMpH3WEPvRaTFhdPqtaQZ5BB3cBh8MFAzJ6D2h/DMvk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=isQ2oYkC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=e0gRmSBt; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="isQ2oYkC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="e0gRmSBt"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66OCtmKq3340138;
	Fri, 24 Jul 2026 13:28:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=XzWsSEvRoYNcKg9fKCBSME68gcIea+6x4WdqBg4kZGM=; b=
	isQ2oYkCftNWMU6GqiKEgiNNIHGF8jIcT/ipHfw/ZocNYfoSMFDjypyvyLJDbDkK
	e51b5DCUayLilwqMuf4LaopoOOQLd3J2ThCnbQ9sIjo6hUZrN737ritnKLq8BZlu
	mvwjYrUfrh/rbBnBBf+6gKVKZD7VmpLMUOInqfQeyq2QrF0iZGAz+H3V95SbWbVN
	eld3QVY7yPP3EPjuizLVKXtgM4q43kdqRy432Guqy4ZFPu+b4D0cT5JW+cRzzS9s
	8mt0kmS4a26IGTPIP9/27gy0L6rVOksj73pIZpnH7qLbr0VP/RpSU8N2AT8r9HRJ
	WSKSRPjPGCqOJUM1URucug==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg21q8jtj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Jul 2026 13:28:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66ODSbZ0019449;
	Fri, 24 Jul 2026 13:28:42 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012009.outbound.protection.outlook.com [52.101.43.9])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxt81th-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 24 Jul 2026 13:28:40 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lqy/OaOBxjCkPt/80r0xerO1+3u4W4Af32a+lEzxacQPEPf/tf5vqltSXTEFCH7BPzFHDPXY/FfFJiKNe+mxESzsD4qKSQ62SgXyufta+d5Dk5I+qUl6gevlxG2LtL3aQd3zsV6Skx4y4cQ/+3Rq62nvlcQQeC1jhp1ebHRAI2X8fqRDDmae1GlADBJ6G7bodlTll4dnBhqe9RzUBcceKcq4fQAVM85GnTiCRaUiuJ/1FknhasaxzrjVc6cwFrDuE+bhgD07/hNVGjkxEH+FTV3utgYMSWKVIjkl4rbFHXC4K1FvYgn1A0WU6lgp5xbeJwN0jHIAlgLQz0KPDpmUQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XzWsSEvRoYNcKg9fKCBSME68gcIea+6x4WdqBg4kZGM=;
 b=t92BE966DaEv468fwcaGkzoJPys8JJBdlcASndxSr1Bgt9bgoJxXv2ijYpLUiUesS6ugkiSNuKveonz4MtBcYp67Qt2IU+aEMbPs0OJHwmdzgfEVXUNy67vyKcYNDTOILSHwThr7hQtORN1w6QKZX7AkvSm4IXM7d5QR0T6dXz0yLvjFWG3VsdLfAPA7wklS/dUTWh6dPcPKosoW2mnWAEWMOME5Dv/pSJuST301tcxK4WLJtDQ4gBg3n9pNKyszEXPlFvPbqqXE6xTIsqcT4GqZ3zAVL8C+GeY3EHUEX6oTPnrOS4e89OS6e9LU+gsBEZXHVTETD9l5lR9USp5bFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XzWsSEvRoYNcKg9fKCBSME68gcIea+6x4WdqBg4kZGM=;
 b=e0gRmSBt3f0Nt8BHYcdnJtyfczLzQurMP3DLjfXsA6h+feFvQkMx+2tdncprZPqiLh9DS56O7yKHD2vYM8RUL3/FF1QncrKwATtSc6unmfDalE/OnvOo+V1iQkSQbSVEbn+Khf/2Ux7HI5EZLPlkH6LVZ2LL0IwopGGkqEAJfko=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by DM4PR10MB7474.namprd10.prod.outlook.com (2603:10b6:8:18b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.12; Fri, 24 Jul
 2026 13:27:49 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 13:27:49 +0000
Message-ID: <d2f4dd54-6741-416c-ac81-62f99833490a@oracle.com>
Date: Fri, 24 Jul 2026 18:57:43 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0508/1276] xprtrdma: Document and assert
 reply-handler invariants
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <anna.schumaker@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, vegard.nossum@oracle.com
References: <20260721152446.065700225@linuxfoundation.org>
 <20260721152457.476636108@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260721152457.476636108@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0122.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:2b2::11) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|DM4PR10MB7474:EE_
X-MS-Office365-Filtering-Correlation-Id: 0829179c-3327-450d-aff7-08dee9875b72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|22082099003|18002099003|4143699003|56012099006|5023799004|10067099003;
X-Microsoft-Antispam-Message-Info:
	m4+tPjr9opVtmvnDMAnd2BkVGBKTaGbdB9LftHeibg7JudRx9RXifsde3m/mBH8nm8ATr/R7FnfdBcKR9TlpNIzLwUy/gXOpUy5VGj9tLaxKzmBgXanuidaouDTlkbCZ5ZolS8Rg0SHsmMXUeslpKmh11yhZ1f3OuAUmeX27/wQCmqinfWBO8MoK7uD9/vuibw+RtHqZHzySkNj7KFeREP3wIR08NWVS5D4Ze9GlZ2egqGiIHb3qQo5K7bzY55VmKRSWlDgqwHdeIBjfPIixOYClktszY79ucDCz3m+1iJ7oHLaIIZVFn3f7LLzvNuXbm/FCakwSibR4uDvY+S6tDq0euqiJQIKkRoG5o2Nj43uGT6l+dkqe3Mgb0J53m96RLU2SvlAtw5z/flndHCYdeo7jBv7KoJGC/4AmdEgjDtJrdGM7I3td3SdfPBScrsM2bNuXmFxJb3VQLNTQX1O950nIOLbxBcS4KeFTW3qTHhIqpK7w9Kn2ISRW6HIv6oHZIiIXS6Sr/4gW5D/UMzY722uvlMSlnxWjHx0SCp9hHZRJiN6aIq4chD9KisPfhpENxDDdtykYofdoUaIHmQWbP3GpwntQruCgAYiB0DPaOVsgkeEJqKtJHDEnlA6yZ3KOQXYaxxPp71Q64s9mWjHkcC9cuVfIlFq62gGkF/bcyiU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(22082099003)(18002099003)(4143699003)(56012099006)(5023799004)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bzhiUmpNcldGbzNtdHU5b09aeDZSM2NreW9DaTZJaVZGTE1HWlEzZDdlV281?=
 =?utf-8?B?eENldVE3OFhmdGd1RjJPZ1FGTFZQWEIxOGp1NVUvQUZjOUVlSFc5MGovOWtM?=
 =?utf-8?B?K0VUbllJR2pJbS9Hc3puNGNtdWpTYkhmam1aOTBVRER0azVFWUw1NkRhUWxy?=
 =?utf-8?B?bEZGZTNCcWE1U3g5eGNhalZ6VEFYWDZoUkJ1R21PNmNRNm5VdW9zUVdyd3JC?=
 =?utf-8?B?czZjbHFrZWJkR21zN1J5TkRNZkQyOGZRNmYydngvSHNaNHJPNVdhUlBrOUE4?=
 =?utf-8?B?NVBaWVRJVmtLbEpUeE1iOTdIT3pHakRGNjlBcWcvQ09LdU12Sm0rSXh5K0k4?=
 =?utf-8?B?bnFCWEtWRkVDU0xDS2p5cWQrYTh3QjUwVEZGVjdMNkJSY1Y0VFVLS3Nsak9i?=
 =?utf-8?B?M0NtTUNkanZNVUt4b1RFZ0RUeU9oM3VaV0NldEszTFptWUxDd1J6WWhxTWpr?=
 =?utf-8?B?clhFOHRLV0Y4Y09FNk8yd2lYT29VV1IzYWFPUGpxUk44Uk5FZi9LQ21oL2hu?=
 =?utf-8?B?SFFLQzJycXE0RE02NUZtSldZcGxNNmx5Z2ZDUm4yRVRWWlpEdURrdVdBc1Ft?=
 =?utf-8?B?NUs1NnVSWEZTRloreitKNU52QUU5YkJjOGpsUnN5Z3VvNzRBa0xBS3BBVmtW?=
 =?utf-8?B?ZFJ1SHRtM2lWcGYzOTlhSUVMVjNWWDJQdUVKSWpTMHN2aXViTll0Wkx3WTFj?=
 =?utf-8?B?bTg4ajlqaE5lZHJjS1NpbmJpOSt1Tk5lNlVtSklGWXdLbkFTQ01LMzBNM25m?=
 =?utf-8?B?SWZXa0F4QXVOVkdDbUZ5QzBKTWkwc1pFeGE3dmpzS3ZZWnYrNXd3T3VlT2d6?=
 =?utf-8?B?RjROQ2hKWGV1dHJNc2c0QTVzNW50dXpqdEM5aWlXT2hWZlNCeWM5d2RnUEZ5?=
 =?utf-8?B?dEpqcmNyQWFiT0JRcEJKdy9hV25CaGg0d3NSTVhWdUdZL0VsUXNDdGJFak1o?=
 =?utf-8?B?TFdvd2JKaDJWbGFIaVcxQVRjcFBRenVNS0M5aU1NTk01cWZ5T3ZLaXB5aDBE?=
 =?utf-8?B?bHBHUWUrQ2xZVUdtQm1Jd2ZBQWowQ3hZZERIS0tKTld0bjYrTTVqbkRJVXRk?=
 =?utf-8?B?Z2pWSmhXL1U5YnA0ZkQ5Y0pSNW9Odm55YXhXTTN1ZjU2clRqbC9LcmoybGhT?=
 =?utf-8?B?bTkya0tiYS9BcWtnUm1lOTVuSXlQdlBHWjJQcG5KYVJxQUxodlNoMVJxbTVO?=
 =?utf-8?B?VkxpZ2VIelk5Tno4VWxtRndYZlZ3WlhDZ2ZjSFZ2d21EWitpeW5xaWoyT2ZT?=
 =?utf-8?B?aFYwbGxXWGIyd04zVVR6YjM1bmhnWmplMW1IMDBHdW5FeHdWWUJmRWpiWUFS?=
 =?utf-8?B?UldQTUMxdzF3RmpGSkVqOVMvdk5aZnZjMkhMRllRSGVUa0QvRkU5b0JBRFNO?=
 =?utf-8?B?aHdTUGVQT2pHbzMzYmo4S0Iva09OWWg4WFhvVGhEN2d1VTEyN3doVmtMUVVH?=
 =?utf-8?B?TWh3UlFyWnhHQUVOY2NpZE1zT1JReDc4TkFlbGY4RkpSZndma0NrR0tuZlpK?=
 =?utf-8?B?eUlmeVF2eThOOXkxY1orMVc4ZXNRM0hzYTZQVzd3L3BVZzRVeTl1SmMzazQx?=
 =?utf-8?B?NHBrMmRQdEh6Wkg2VVd3NWNLamxWUFZ2ZDYyV0hZOHVjS08xaTVKM3Bydm5I?=
 =?utf-8?B?U2crZm55b1MraUlSeGhUK1VUSEFTYUo3a21TUzVtaytkOGZpNnpaMHV0OU9s?=
 =?utf-8?B?WnNPckc4VHpLaFA4VmlRUFVxT3I3WGRXSEprZXc3VVR5d3lpWWN1OEpJQzla?=
 =?utf-8?B?ekpSeldUUnViNGlZa3lwM0FIaW1jNk9JbmFVaVE2dGhDQW1jMHFUUHVhYXFY?=
 =?utf-8?B?ZTR4SVo3TXpXT0F5UC90SEIwdm9mUi8zRk13NWdFTTRLcnFqUjVvUkxRTXRD?=
 =?utf-8?B?dCtTSm43U1RXRDFFK0J2QmxVeXFzMzdVKy9Gem1zZVk3M0pYNUlwRHl2eDk3?=
 =?utf-8?B?Yk5xSzNydGxZRGFVNkJuNHNyZUM5NUd4dXd0ZUJxMWNtNnl0QklodzdpMDQ0?=
 =?utf-8?B?VWU1NjBxYzBBRTIydld6THBMTmhrTjJhWm1UaE5QSkNMdWlIRFZIMzR3R3k5?=
 =?utf-8?B?ckJ2a3BDUmtjZkJkRDVDSFY0LzNVTmtSUG1TS211ZitYZkcwak5XeEZFRmVW?=
 =?utf-8?B?dk9hREM2SndaUjlkUERIZU43TTlneUVEYXVab3c1WGg3TjI2RU1sOXhBRTE2?=
 =?utf-8?B?SXRoWTJkdGR3VzFycHRRTjlSdENoWFhpcXZvRHZxT3owSi9LeVBOWnFTRnVB?=
 =?utf-8?B?SVg5U2xNQU9YdnlGV2ZwbGhEQnRYazM5QTRXa2tNd0VSZ2d0YzJxYmpoQ0Fa?=
 =?utf-8?B?bHcwOXhOUTVYMnJVcmZvRWVNWThmbllnVEJ0SFYrejZ5WmNnZzJ6ZUJtNk10?=
 =?utf-8?Q?n9Wlb3NNr9Cd6kbht5C40jvSkJTeQHPLHUq81?=
X-Exchange-RoutingPolicyChecked:
	Cxr13eiIObXtSUHspYcKax/tri0om1H56qQvN3bv1DVtuTjijYsBK4eG4lGOrTTP/Tqg0Q3YXzos80y5Lpmf7Ls7nfDP03A60at+c+1CCRELXDSnUszbPTeJzHD0Xfsiy8z76l9NFe7U8aHfE21Q69zTR4zlfqzSa0OEzlYrqg8lpiA4dlg5wf/TusAE2F3QJitKGK6QwWLXiObxNNUyVzmMnhwqaVIuyDJp9SIrx77be8AGYhmZEX2catznkEM5jPvIyl1gjeAqAW0n+lNKGj7MSGdbmb6in3/gSxdKsy3Lq86z8UhpMv8hrUwcCakz+2UdCg1ry/E3r7k/TDRwQg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SWuorFodtjeDseJEcxGG0NDVZ8lSxJnl7GBQDO5URE7nEfBVRkcf9DcLixD4N+9XDBQmRtplq5xlBUA7fJQuYiCIGj9lYlz5loxDgGyaao4/uyY1GcSTakOnD4gSKk+QkTnrZb7NS/YfInMCGby9svsCE2F7rqTL6N25/5/86p323wGwNI/Hdc9unjlpw+IVIoXLjC6uKqEIla9dpLu4wN3VMcQ3oMZFeIy0iQOous5FrzGK23IDjPazK9dmPUr021FG3qsIYP0TrWUH/37dTrGh/mOrkfs4dIMiy+LMUV91RLNuHuxLkwtnj3Exv7Clj4DwywJddfIe9LxMgMFFV3DzKest9RVSJPdIoFj6DtpfwayCB88tYx8wA10W8Zl2pCGY2iWRVM0QUoAdAentbboCH1SHT7Dj/fqnr8hT/25g6lfDICBlXWC3+rxQfzsXdgbwm7kWjAF6BGvZzhaHdgY3J4O7gcXV5v3lJ3BvlSVBSOJ8Y8txhl/J6oWhC4dHpE/6InIgu889smbsjFZydd3qiKqUy0DtdB2Vy7obYxBCv8wVWfdMPyR8tfBNE0VxTMchFNlgpHxubucnKzDCz5CIAk40SbOVtTH0tAzgv3w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0829179c-3327-450d-aff7-08dee9875b72
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 13:27:49.8306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6rJF+L7ZzCO5RBDo4fbvSLPyuCxRLpf5uKmrew3lOHAbx1vZRQoAHBuyZcibQ4sX8RPg0qH+zqtNAPlpIgHYYR80AXXiyiDYxppeLZ6YBEB8ggevVWSGW2blO+dSAUIA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7474
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_03,2026-07-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2606160000
 definitions=main-2607240122
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDEyMiBTYWx0ZWRfX2aSvz8G07Klz
 QcX2sD+rNTwpIJWB96ojifnzcioxXL0kYqEMLDEexhQyG3J/baeoBt3gjOe/ZcKiM5nFmcuKHCw
 KF4rJDjzLBbvPfVQt2+Vtcsnnmhc1UqjC28p7Zpmn98KTYqWVRdOGlw13bIu/li6TUaJN0OXGrE
 xpJaBuMJ8P8VNINjv0oNqxlPxiXzpPU/gD4I73/pZ42vlTaIZclb8FVArg08Ity5SNMsowSGQFA
 gBMQ3SPAQZvnjg2M/wfgPHWps2cKaa4nmM+Q78r/6zo6TnVGcVASJ95DUmC++F3eVe92XLpdQZn
 s//FEDmo1RMI2ku2rxL3jg6y8nAT+rH2WrT5fArkw5bccYFR5N/rCR28bGjEIaCC1LWsthkfJqM
 w8DPCUJaOCLPthoPU/sJRHpwqvOWHovneNfikDalIJxNvmAMVUWcNGcGMlwtjTHn5jGgWfQ8hef
 8A2t/yZnhJnG0cWw6iXiXl4xSHoNQlcycrVCD2W0=
X-Proofpoint-GUID: TwuD02Q5Eglr9Wgy0TUU9KZmRrtNWHdK
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDEyMiBTYWx0ZWRfXzqf3j0bwSlJ0
 CU3iW4n8Slr1AxH+L+5CkxmCEbblawd4L41qOFbRw0AP01YKKrSu8bVOO4LZfHbl9OGFwDiuEQc
 CTC4zhvZkMvFsoA1HckjQIkyKpvrIcfBz9M09PfMCqMiqQOPyiW9
X-Authority-Analysis: v=2.4 cv=ALkdLnG8 c=1 sm=1 tr=0 ts=6a63688b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8
 a=SEtKQCMJAAAA:8 a=VwQbUJbxAAAA:8 a=VC4k8LZD4gXMPkRal4UA:9 a=QEXdDO2ut3YA:10
 a=kyTSok1ft720jgMXX5-3:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12114
X-Proofpoint-ORIG-GUID: TwuD02Q5Eglr9Wgy0TUU9KZmRrtNWHdK

Hi Greg, Sasha,

On 21/07/26 8:45 pm, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Chuck Lever <chuck.lever@oracle.com>
> 
> [ Upstream commit 797943e8bd1ffcc63bfe79d24faad9a77054ec40 ]
> 
> The xprtrdma reply path has been the subject of recurring
> LLM-driven review claims that 'an RPC can complete while
> receive buffers are still DMA-mapped' or that 'the req can be
> freed while the HCA still owns the send buffer.'  No runtime
> reproducer has surfaced, but the absence of a written-down
> invariant set lets each pass of automated review reach the
> same hypothetical conclusion.  Subsequent fixes against
> ce2f9a4d9ccc ('xprtrdma: Decouple req recycling from RPC
> completion') closed the underlying races but did not document
> the closure where future readers will look for it.
> 
> State the invariants explicitly in a comment above
> rpcrdma_reply_handler() and back four of them with
> WARN_ON_ONCE() probes positioned where each invariant is
> locally checkable on the previous patch's cleaned-up
> ownership state:
> 
> - I1 (Receive WR ownership): WARN at rpcrdma_post_recvs() that
>    a rep pulled from rb_free_reps carries rr_rqst == NULL.
> 
> - I2 (rep attachment): WARN at rpcrdma_reply_put() that
>    req->rl_reply was NULLed before the matching rep_put.
> 
> - I3 (Registered-MR fence): WARN at rpcrdma_complete_rqst()
>    that req->rl_registered is empty.  Strong send-queue
>    ordering of the LocalInv WR chain makes the last
>    completion observe the ib_dma_unmap_sg() of every earlier
>    MR, so 'list empty' implies 'all MRs unmapped'.
> 
> - I4 (Send-buffer release): WARN at rpcrdma_req_release()
>    that req->rl_sendctx is NULL.  Reaching the kref release
>    callback requires both the RPC-layer and Send-side
>    references to have dropped; the Send-side drop runs in
>    rpcrdma_sendctx_unmap(), which clears rl_sendctx
>    (previous patch).  A non-NULL rl_sendctx here would mean
>    the Send-side owner had not run -- a contradiction.
> 
> The XXX comment in xprt_rdma_free() about signal-driven
> release racing the Send completion described the pre-decouple
> state.  Replace it with a one-line note pointing at the
> invariant set, since the kref scheme now holds the req across
> the in-flight Send regardless of which path released the
> rpc_task.
> 
> I5 (req lifecycle) is stated in the comment but not probed:
> making it locally assertible would require moving kref_init
> out of rpcrdma_req_release(), which in turn requires adding
> kref_init to the bc_pa_list and backlog-wake reuse paths.
> That restructuring is deferred -- the invariant is unchanged
> either way.
> 
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
> Stable-dep-of: 234c0ff695ef ("xprtrdma: Resize reply buffers before reposting receives")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   net/sunrpc/xprtrdma/rpc_rdma.c  | 69 +++++++++++++++++++++++++++++++++
>   net/sunrpc/xprtrdma/transport.c | 13 +++++--
>   net/sunrpc/xprtrdma/verbs.c     |  6 +++
>   3 files changed, 84 insertions(+), 4 deletions(-)
> 
> diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
> index fbb78c61333132..0473d920f71c1b 100644
> --- a/net/sunrpc/xprtrdma/rpc_rdma.c
> +++ b/net/sunrpc/xprtrdma/rpc_rdma.c
> @@ -1381,6 +1381,11 @@ void rpcrdma_complete_rqst(struct rpcrdma_rep *rep)
>   	struct rpc_rqst *rqst = rep->rr_rqst;
>   	int status;
>   
> +	/* I3: every registered MR has been invalidated and
> +	 * ib_dma_unmap_sg()'d before complete_rqst runs.
> +	 */
> +	WARN_ON_ONCE(!list_empty(&rpcr_to_rdmar(rqst)->rl_registered));
> +
>   	switch (rep->rr_proc) {
>   	case rdma_msg:
>   		status = rpcrdma_decode_msg(r_xprt, rep, rqst);
> @@ -1412,6 +1417,70 @@ void rpcrdma_complete_rqst(struct rpcrdma_rep *rep)
>   	goto out;
>   }
>   
> +/* Reply-side ownership invariants
> + *
> + * I1 (Receive WR ownership).  A struct rpcrdma_rep is owned by the
> + *    HCA between ib_post_recv() and the matching Receive completion.
> + *    After ib_dma_sync_single_for_cpu() in rpcrdma_wc_receive() it is
> + *    owned by the CPU until rpcrdma_rep_put() returns it to
> + *    rb_free_reps; a rep on rb_free_reps is not re-posted until
> + *    rpcrdma_post_recvs() pulls it off.  Asserted: rpcrdma_post_recvs()
> + *    WARNs that a pulled rep has rr_rqst == NULL.
> + *
> + * I2 (rep attachment).  While req->rl_reply == rep, the rep cannot be
> + *    re-posted.  rpcrdma_reply_put() NULLs req->rl_reply before handing
> + *    the rep to rpcrdma_rep_put().  Asserted: rpcrdma_reply_put() WARNs
> + *    that rl_reply is NULL after the put.
> + *
> + * I3 (Registered-MR fence).  On entry to rpcrdma_complete_rqst() every
> + *    MR that was on req->rl_registered has had its rkey invalidated
> + *    (remotely via IB_WC_WITH_INVALIDATE or locally via IB_WR_LOCAL_INV)
> + *    and its pages ib_dma_unmap_sg()'d.  The LocalInv chain is posted
> + *    on a single QP; strong send-queue ordering makes the last
> + *    completion (frwr_wc_localinv_done) observe the
> + *    ib_dma_unmap_sg() that ran from each earlier completion's
> + *    frwr_mr_put() before complete_rqst is called.  The inline
> + *    frwr_reminv() path unmaps its one MR synchronously before
> + *    rpcrdma_reply_handler() reaches complete_rqst.  Asserted:
> + *    rpcrdma_complete_rqst() WARNs that rl_registered is empty.
> + *
> + * I4 (Send-buffer release).  req->rl_kref carries two unconditional
> + *    owners while a Send is outstanding: the RPC-layer reference (set
> + *    at xprt_rdma_alloc_slot / xprt_rdma_bc_rqst_get / rpcrdma_req_release
> + *    pool-entry) and the Send-side reference (kref_get() in
> + *    rpcrdma_prepare_send_sges()).  rpcrdma_req_release() runs only
> + *    after both have dropped, so the req does not return to its free
> + *    pool until rpcrdma_sendctx_unmap() has fired -- the HCA has
> + *    released the send buffer before the req can be reused.  Asserted:
> + *    rpcrdma_req_release() WARNs that rl_sendctx is NULL.
> + *
> + * I5 (req lifecycle).  A req is owned by the RPC layer between slot
> + *    acquisition and the matching xprt_rdma_free_slot() (or, for the
> + *    backchannel, xprt_rdma_bc_free_rqst()).  While owned, rl_kref >= 1.
> + *    The pools (rb_send_bufs, bc_pa_list, backlog wake target) never
> + *    contain a req with outstanding Send-side or Reply-side work.
> + *
...

> @@ -509,6 +509,11 @@ static void rpcrdma_req_release(struct kref *kref)
>   	struct rpc_xprt *xprt = rqst->rq_xprt;
>   	struct rpcrdma_xprt *r_xprt;
>   
> +	/* I4: both the RPC-layer and Send-side owners have dropped,
> +	 * so rpcrdma_sendctx_unmap() has cleared rl_sendctx.
> +	 */
> +	WARN_ON_ONCE(req->rl_sendctx);
> +
>   	kref_init(&req->rl_kref);
>   

I ran an AI-assisted review of d56dc36beef1 ("xprtrdma: Document and 
assert reply-handler invariants") on 6.12.y, and I do not think this 
backport is self-contained.

The new WARN_ON_ONCE() checks seem to assume the cleanup in upstream 
commit: 2ae8e7afbc63 ("xprtrdma: Clear receive-side ownership pointers 
on release"), but that cleanup is not in 6.12.y.

In 6.12.y, rpcrdma_rep_put() still puts reps on rb_free_reps without
clearing rep->rr_rqst:

void rpcrdma_rep_put(struct rpcrdma_buffer *buf, struct rpcrdma_rep *rep)
{
	llist_add(&rep->rr_node, &buf->rb_free_reps);
}

while the new code adds:

/* I1: a rep on rb_free_reps must carry no rqst pointer. */
WARN_ON_ONCE(rep->rr_rqst);

Also, rpcrdma_sendctx_unmap() still does not clear req->rl_sendctx :

	rpcrdma_sendctx_dma_unmap(sc);
	sc->sc_req = NULL;
	rpcrdma_req_put(req);

but the new assertion says:

         WARN_ON_ONCE(req->rl_sendctx);

So my read is that 6.12.y should take 2ae8e7afbc63 first before 
backporting this.


I see this is a stable-dep-of, so maybe we should drop these for now, 
and reowrk later ?

Thanks,
harshit


