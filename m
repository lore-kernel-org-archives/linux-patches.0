Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C7C1D63E8
	for <patches@lists.linux.dev>; Thu, 20 Feb 2025 12:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740053753; cv=fail; b=IlToqz7s53TY4z8pCCS6VoaTvRIK3exHJKx4DE2FvWKALzmeMAZwKrf02eX/ST9p11hBxfPia9fZSZgd9lI1NqjmE9onyGucG4+Z6JOqXawkIhJBbQAdqTm/cTsTtpgYKXCgYWnkLwKuaLEcLCfA2gchX7JNAMdIADn0y1FIXEM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740053753; c=relaxed/simple;
	bh=2xVBmpjnm5RlgSQP5qcpoFYH0vqpq7tjJ/gCW/3ROVw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gRHtHgk6b2B7ViM2Q9cCHVJ/RjR+oIdjQtTcZ000Pqt/s60AnGOxVZhtLal3x/A7p2lksSwx6k+s5f48j/nzANvxVGscFCjjTaVUHSIiJFtu70xVcYAUsRq3V7J+ldTEv0ZDvQNkMXZnvP3EbequPwfILcj47H2KvBW7umWfDqU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Oid4gOB/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YVLN+eta; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Oid4gOB/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YVLN+eta"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51K9fa07028052;
	Thu, 20 Feb 2025 12:15:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=u1VRxU8WjWisc33ZdBc3rolHKVwaX4sWhaH0XnkuuoY=; b=
	Oid4gOB/wOu0Rxz0CMcrxuxZPIVrwFysJoTad0dYr6yeUJCvlodW6XUfkylHjTpx
	0CYkbn8trDtBGuB6BgPfYeQ/TxV4+xJxX7dSkBzj4DO8xmasy0dik5hzBRvPVchn
	/uT9Gtgi5vRjRf8M4bR+XOmLq2RgGQ+Tra14cZ1UCi4pR0uRQd+obrSIAuMwG/Sy
	+zO48S6f3rsdAq97Z7Y8tKVuorZAYozez+AiF5n8wziBRGYwtK8P7mTlburU33Td
	y/5uJsVikDZOs0iBQNzsy0+iXCpuqoE/11ahsFACDlBd4vvgaclAxvkqQrSjjl3+
	VXW7Slkf9GMIFupVgVfyDg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00m436q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Feb 2025 12:15:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51KBxoVO012028;
	Thu, 20 Feb 2025 12:15:36 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2043.outbound.protection.outlook.com [104.47.73.43])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44w0b3t1w0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Feb 2025 12:15:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k/UlYioh+mWV7DWLgiQ5korhQkvbkuTQ0TIyea8ViWqCjZAdSmqsC8VLYMDA01DcUbzmGCkqlWqboBbwJ3hr6wSDrsG5LHon2KzkPfH2sN47dMyzYMjSRcoDN/jAtwzGLcaLWWtvdFAklrOQx9Hmza4y2b1LEyfaPnRswB0iKM9WYYJVnnXCKsv2pbeQpgN5KW1tpm+NyDvXVuOoxZPyqIxc2o8KbwlYpyN4ib9l3siMVy+N6VbnV8hChmEDLGCJxjM/dndiQmw3uNQoXISxcMHDqguT474FExs/enGhLl7tKqGosdfGOQeN31sOxKd3QDBU7x309dXAulNlXEz59w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u1VRxU8WjWisc33ZdBc3rolHKVwaX4sWhaH0XnkuuoY=;
 b=jkDFiWFMWqaNNeNRcF03dygfojPAm52Sj6Tdg1rxRWup92quvqB5gVbosBGB8/L5sxDcFI0/vdD58Pz9Ez2qQcx36OpJI/w7DCXN5fg9B7d7Wl5nt/A1cfpQmeGnO4qpySW/LPFvEzFmP4K00rJqsNGBkrgwEDdA2VlnMx0mSaGRx/4bmjUCswXsPRyITLZ9zNOw8/V9cB2ZMbeLuZOfUhISAwL9wx/pDp+uKW7rgGNnSy4G/nEC6MmyDJgbMLDUqNj8CORwpXZwWwcjYF6Il+nVOsB68yo+u5AineO6zQDeFZlR/RKIPef4Bc6fLjiT5j/wWpOoMWvYZPGdd+nAJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u1VRxU8WjWisc33ZdBc3rolHKVwaX4sWhaH0XnkuuoY=;
 b=YVLN+etamkfOOL9/UrQNKQb1uz8WD6+hsLbJ1v208Enxq4SGkpCIWuv7xNAsGgeKFryxPekC+csoiQJTqEXi/iv+BGsbeW98RL8tWxF5+QNXyaI650oN1pilCqN50CQNpFVWPgxFBVLCLb6WW2JwIB3rsxVbNByD2VWevO8MgWg=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by IA0PR10MB7372.namprd10.prod.outlook.com (2603:10b6:208:40f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.15; Thu, 20 Feb
 2025 12:15:34 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%5]) with mapi id 15.20.8466.013; Thu, 20 Feb 2025
 12:15:34 +0000
Message-ID: <f2f31896-6cc0-4a45-8d7e-08a691945e45@oracle.com>
Date: Thu, 20 Feb 2025 17:45:23 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/152] 6.6.79-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Darren Kenny <darren.kenny@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20250219082550.014812078@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::18) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|IA0PR10MB7372:EE_
X-MS-Office365-Filtering-Correlation-Id: abcd120a-65de-4ad5-047f-08dd51a846a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bk4xRDBNZk1DZk1oMHZrSGNMVXF2ZlJSOG0zNVE5NEFYVHRDbjVTeWdvZ3p0?=
 =?utf-8?B?RERVbnN2bVV5Y1FWNE53M0U0TWo2eEcrSlpFSHBpb0xwSTc0K01RNnQzQVRE?=
 =?utf-8?B?Wit1QkZmODJYN2tpeG1xaGdGTU1qdWlENUVSQmRHSzV1RERDT0M3TnhGdHkr?=
 =?utf-8?B?TmU1cWhrck9vZzlrOVdWOCtuSEpxTkZhaEloTVovd2VkTjZXditWa2puaFNx?=
 =?utf-8?B?b2dDVG1IZCtDNjVyUnJkNGhreE9PeEZEQmJKTFV0dC9DR1ZvODdGMklKd0hU?=
 =?utf-8?B?N2NySU9sOFJPZlRGYnJLMmdWWkNUaUFKdkkraDk5WHlZUm5BMWthMlFqZno5?=
 =?utf-8?B?aFR2VldLeHVrTC9FVG1mTHVlbWdFUHJ5aFMreWZvRFpoQzVFTWNJOE43VTMz?=
 =?utf-8?B?UC9nMXF5OFJtd3VRZVVDZll6Ylc0dVZwV0I3aC95MW5HQXh3YUZ5NHQ1Ym5t?=
 =?utf-8?B?eU0wWW1OYm1hVi9Odyt0K0xOdEFnWndzQkkrdVZITVJwcFhZVFIwa0pRWktm?=
 =?utf-8?B?VzNQYTMrU2VFZVBRTGRpa2hQR3hTaVFDY2N2K1VvUy9jckluOEdZU2VpZFBs?=
 =?utf-8?B?OWNXdjE1SHoyVDVDVElYYlZ6YTNINDRPRkI1S3FPNWJBajFsYnhkdlVRMGg5?=
 =?utf-8?B?MVJIeFZCaU4vMlpZYmRGTENIanZ1TG1HWmE4dXk5YStFQjIzWkRjNmtFYkFq?=
 =?utf-8?B?NzVOUFY5aDZzRWkybTVaT25IcWNjRWZnRTZVUXA3S0JmVkZYRXZhWGxvZ2pp?=
 =?utf-8?B?c3lzQjZsQ0g3LzA0b0pYK1BKbXdZaExFc1VPVlhGL3dEaUpVTTJkTVhKVk1F?=
 =?utf-8?B?d29OMVpoYy9DQW5GVkRqakdvT0Q5eWtPWGpCNm5vR3FzOEpmd1RueFl1ZXAz?=
 =?utf-8?B?cmdkVVdtYVJFNDlXbWZ5R0J5SFVRa2xkZEtPTFlXaXNraThKWkJRYUx5V3JG?=
 =?utf-8?B?NDdUQlIzd1VhWG1IOFlIWnhKT2tkNm5pZW1OU1lGd2NxZlVDQjRGWVRzWWxz?=
 =?utf-8?B?TkkzQkt5bWF5WUVZbjZUS1c4K3ZWTndIMkUvRzRWYSt4ZWJSTXdvdjJCODlq?=
 =?utf-8?B?WmlCUXlaU1JvNEduaUlYczVvaDFJR0JSTkxaMVZOb0xxZTRoaHUrRWtLOTFu?=
 =?utf-8?B?RDZCdWR0dEMzbHViK2wwbzR0U2pibnd2VWo4cTZvVkkwYkZZUzQyeVcyK0FF?=
 =?utf-8?B?NlJhNlZVditCeWhCYlh4RFNxaEdpZ1daRXd4ajdXYjlabllhelorSThoS0Iz?=
 =?utf-8?B?VUxQMGJiTTJoWStFbjl5OS9JMDBGTmdVV3ZXZklEUjhIRWNuemovWjc1WXBh?=
 =?utf-8?B?VVNYRy9jenNVRWcvNDAwS3BHR0hSY3NmVExPUitOUUNFUGlON2l5Q3ZHQ0Zm?=
 =?utf-8?B?aC9veFM2VWR6bVVkUjI1MVpFdVFYV3h1cG1iU2swRVk2dGM4QXRtNHE2bzBW?=
 =?utf-8?B?Y2JPK3hKOEVNYmE2MXV4Mms1UDZsWDgvZUxjSHpiYjZ5NEt5eEwvM2lRcGZT?=
 =?utf-8?B?V2QwMFM4TXpKQUhrM3M3TzkrejEyN2VnTFVzKzhtb1VhNVNPclZjTk9aU2Fk?=
 =?utf-8?B?K3lIRUJVNWttV3pFWEtFQmhyTVlmeTNvdFBZMFNrNmh2R0RlZTkzRTc3RE5D?=
 =?utf-8?B?TnM4emRUbElWdXUzU0htYW9WTGlFL1dPcE5sSFBQOXFNaFpEL2N0VTVMdEJU?=
 =?utf-8?B?bXF6Vlg5c1UwbkE2SFhDeG8zUG5HSXM4WE9leWpzTXMyZU94dkxHOGZRUEVR?=
 =?utf-8?B?Y1F2YVh3Z0p6ZjdRelBvbHQ0TU5wRTJGdDVPSVF1OGxMR2E3YTloc24yazV2?=
 =?utf-8?B?dnl1eGpKcGZDUEVNWWtlUVJlaUovUFlBRkpuT3YrWmVYcHB5UkpxTndnUU5Y?=
 =?utf-8?Q?6b2YcjbgJWxHO?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cXpBMzNLWmtJQ3IvbmsvTERGNnd5MkNBVXlPZy9lUTBxMmhXR1lFbnlCRVJT?=
 =?utf-8?B?elM0RTU3WGFPMlNGb3NIR2cvSWdYeFZ0eFBiZjJObzlHNSt3cjkvRWhLZVlE?=
 =?utf-8?B?MlFBUk03bVhyWllzcUhQYnBIZ3VBUytvR1l3R0ZsM3RQdzBKb1dxZEhFUnlk?=
 =?utf-8?B?Z3dQL1BuU2tHWHE4Sk1UcDFHQkJRU0E4NmlldzRuWVB5a0I5UEcrcGxVTERu?=
 =?utf-8?B?L1k2WVZva3FrSmI0YXRPdVNwOWdjY3ROcjNwZjd3QjFZU0NML2JyMDVwTlZo?=
 =?utf-8?B?UkhKcW5vQWl2T3lMTUpDSmpqKzhXNXNsTUxrM3crTjIySTJ2S2tTTGJiVDJ2?=
 =?utf-8?B?aHZHNTcrL2IvczRmTG5OY2RCdkhPZ1R0b3pBbEM0eEdneS9MUHRUTjJsMzYr?=
 =?utf-8?B?L25SOWxYV3BCZ1daclJFZGRkRVdDb2FabjJ6N3ZmQW81UnQ0Wm92ZkdJZnNV?=
 =?utf-8?B?TVZNYXR5eUVTVk5JUXp3dmxIcjZtUkprZXFTalJXZjNONWRqbno1VVdpc09j?=
 =?utf-8?B?WUZqWmZ6OFc1SFZQLzhVVDd1aHJMODZUeVRFdkMvOTM4RW5ScG11WlUzeC9V?=
 =?utf-8?B?OHovOWVEdHQ0d2VwWnR1a1lEb05MY3dpNnp3WjM5OE92NGRTNDM5UGQ3RVJK?=
 =?utf-8?B?TXZiV0U4MzMvdmVZOFgwRkh5NDJ4ZnZLdWJaWjdscHZEZXJsdmEra2dNUW12?=
 =?utf-8?B?WUR6ZGlZTE52MUt5SE5zUGp6NnRoNHBuSDByWTZ4NWJiL0xhTHpDNlFpVmky?=
 =?utf-8?B?MGFYbnlUY1lKRlN3WjVnUHFSMzhyQ3kyVU5UbXZRUXJvSDJmb2tsNHp0bWRk?=
 =?utf-8?B?ZXk0VFRGNDgvTTlacHBoUzdlaGNzTC8rLzl1S0VHQ3pIZFBKMC9DTnJvYlgw?=
 =?utf-8?B?eEYvL2pmeGw1ai92Z1ZvTlRhOHoxL2wralRJSUJQdVI2aFRCblJNTXpKTTAw?=
 =?utf-8?B?bytUMWVCQTh1OEtVa2NPQkVTUkZ4QjE4RUxVVzNpVzFCWEwwUFFxa3ExUVVD?=
 =?utf-8?B?c2wyVDJlZWp6SzNpZTJMZ1RJcWV3Z3pNcm5jdXRUaC9aZ3oxWENEMWdmVFZQ?=
 =?utf-8?B?VjlHbXR0QzVDU0RrWTZ2UUxIVzlNN2FjSTZrd3hCZk5DcWIveU5JakZXcWdB?=
 =?utf-8?B?VWhzWmlkUlA0Y1l0YXZ3dEV0dUs3TGo5Zkd6ZWtsOHBRbllSSzF1WHljb2pZ?=
 =?utf-8?B?WFFGVDJhUWo0MTNHdktsckRNRHVyV3M4L0ZIZ1RHM2JZcmlWL3BTM25oNXF0?=
 =?utf-8?B?NkgxNXNlMmdSUzErWmdIMEE0N3Ixa044REt0NDFGcXR1WEllWll3MlBFOHgv?=
 =?utf-8?B?MjZ4V2lkODVxQ1JtMUZ5aHVydFZQQ1BMQkhYTnhLaTZhdlhEU0cvOEptQ1Z6?=
 =?utf-8?B?b25PTzBWaDRlMG1YT0l1RUdzQ0F0aXljejk5TE5tYzlVM3NvaUtpK2ExREQw?=
 =?utf-8?B?NCtSQ3kzMzROZHFTUVpvMUNzenhKR1NscXA1M2wwK0FtU2FBY2dSalFNY25Z?=
 =?utf-8?B?cFdCanFudTRxK1B5NTFjMEUyek16RXFybWt3ZlFnbTNSM1VyWjVneGNYak5k?=
 =?utf-8?B?YW45SkVVUVRFZUwxU1V2Q1NCRm5mYkQ3TElISi9HekZzMlNCdC9SbElXY2gr?=
 =?utf-8?B?cWdyelNXUDlkcmx0K0VucVdyeFA1bXp6U2g2N3pzU0g0dDZuNHdBek1sWE1a?=
 =?utf-8?B?Mk14QmszMW1Ia2hTbk9iTW9oQ3YwYzlHcVg5c1hyODlMSGE1RWxOKzJVbnI0?=
 =?utf-8?B?aDd0TXlXQzdSRFZzRWRJUEdNOVdiaHdYczdlZGI2RnVVUDRRb04veXRyZzE4?=
 =?utf-8?B?Mk8vNTg4NXU3SXhJbG9DK0FMQlI4RXVlcHY0c2V0WEJld1hjZUF2cHJYTE1j?=
 =?utf-8?B?dWNMNlNxenhxTXFUZzBabVQ2cXVENExITTFPQldPN3ovL1ZXbUdSM1FFaW1B?=
 =?utf-8?B?VHFoazhEOC85Y0p4WUFIY0pwU3RHSWEzOXBOdlArelBxQ2pzd1pUblJVR1RR?=
 =?utf-8?B?ZWdydndOZEJHY2EwSTF3TGQ5R0NkWkdZVGFaNGl0Y2ZoRHd6SzJaMkF4NVdz?=
 =?utf-8?B?dm1kSDdUZS9uOFFqSWZNVGU4Wkh5azJPTjBQbVBUTlhPZE8rcWlqRVRVVE9Q?=
 =?utf-8?B?cXVDcUE5dTZIQXF4U28yZG9OSXJvc3A5bXZJNjFSNUJqaTlHcUhac3A5bW9Q?=
 =?utf-8?Q?F3S8udfol1+kobUroLmw5w4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wqGG+jdWI/xHGa8hf7Y/Jpce13K9RyBkkJ8u9DVzICCZA6+mofWNbyMafPlai2tfh/XatX179GSgSs0ObJg+6qdITlCjouseKJzIX9Y0yarOSehodjNTrTTQCYqHFEpWL/v6KB/+Er73zxoU4W62NK6HuZTUWo8flNaLxQbEQ2ub0y9Cfgy1Xk7aQk1WxgpCQCQgF7rMv5Zwxfar9qomR+D8JXkCnjbFWQuOzadA8p774JZO4My4yLwokSsxCfY4hIzfwe6Pc4qZRAb7p7cB//kOLbDfjyOivgiqAeU22BuzdjsvcJ6J6WKisxk0F6Zw+QeV0AZhFzsstVvAzXgXkOf/S6TllaMGdPkA0tLjYCsNLjJhcsNntWuevja/kql+zz0VaocEahvirV8NOZXxRS1bhfQbcWkHBwLgm4y1neDk0ZNyiPavLJQFAnp9SDX2r/g7K0PG1j1t1taPrnCh3Mh5C3kfWXfBP1R3oB0c8eCZD1Di+S8nV2dAG5lTKF6iE5llXpGQshTX0C9pX2G/w0ATH3BDfJ4CajtYo5p3TofeB323NfmcNw1V5LR74astbewumuBYwYtYDp6poWtkIRtGOCWK4Gh2weui89PK0AI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abcd120a-65de-4ad5-047f-08dd51a846a7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2025 12:15:34.1356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 53OB+agYRCauUztY4dx4M/GQs4k0JJxSZWK7LAfsxQa+k3tDxTyYy2nmEfRzE+eaVeFXm8mSCyYcjTIxs/HP/D25uIIIA8RjtZjRdyTh5FwMWEWrccYFkEA4BRoLv0An
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7372
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-20_05,2025-02-20_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502200091
X-Proofpoint-ORIG-GUID: 9lIllHIyAxaOa7bGmKV5Y3k8sLof_wDQ
X-Proofpoint-GUID: 9lIllHIyAxaOa7bGmKV5Y3k8sLof_wDQ

Hi Greg,

On 19/02/25 13:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.79 release.
> There are 152 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
