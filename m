Received: from mx0b-001ae601.pphosted.com (mx0b-001ae601.pphosted.com [67.231.152.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF42B3905F8
	for <patches@lists.linux.dev>; Fri,  2 Oct 2026 13:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.152.168
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790946593; cv=fail; b=U2hta1GP/m9xLOSiaf7QCgplnAsZ70mgG+VCBNJ+IuVMIgv6QAzpN3Wqz0WSP5Nqu+S1z06mWgteNe2YFuuSq8JyCVLiK/hQMXfnwMONHewpScEGXW32IJ438W9R4R0LfjzxQI15NPiM9UQ3MCxbR7oDkLwq7dLvu0CBSwO887s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790946593; c=relaxed/simple;
	bh=s4fT2VCXYB4bg8V5/ac6REspwDydE7idTzoZUI920+Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d+de9vgOfSend+mH5FrN5g2uAJszKEJV+BwLT+AFBX6TSOfSl3aMFtIM+1ihuXL4Gpzt3P5qqaXPXkcCX1DLXZOch6zhPTalDk10Mn4Eclf3k4285Ios6z/y9ZIsVScinE04myppRDr4G+YN6o5xeVdaEfebtMG4sS62ruXiyOA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensource.cirrus.com; spf=pass smtp.mailfrom=opensource.cirrus.com; dkim=pass (2048-bit key) header.d=cirrus.com header.i=@cirrus.com header.b=Mxr/RGM5; dkim=pass (1024-bit key) header.d=cirrus4.onmicrosoft.com header.i=@cirrus4.onmicrosoft.com header.b=ZvTNpU1Z; arc=fail smtp.client-ip=67.231.152.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensource.cirrus.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensource.cirrus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cirrus.com header.i=@cirrus.com header.b="Mxr/RGM5";
	dkim=pass (1024-bit key) header.d=cirrus4.onmicrosoft.com header.i=@cirrus4.onmicrosoft.com header.b="ZvTNpU1Z"
Received: from pps.filterd (m0077474.ppops.net [127.0.0.1])
	by mx0b-001ae601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 692CpJmf2892003;
	Fri, 2 Oct 2026 08:09:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	PODMain02222019; bh=Sri9Kzc/DizQKz3AzYDnrLnoPiSsxA3IiJgvHSMrZYU=; b=
	Mxr/RGM5hGcf3Dfs8FUV99YxbSvbF7SVZ7+CN1RI3S49gyPV7CEVi+1WlTKtOpDk
	HUJP8KVqs9Jbr291uFh0Zql4RCHCjWrOUX1Zm1pyb6iJa/QGBtbIeG05k5kN+qxJ
	/3BFvE1vUMqgD2Q0TTitJjY7VAOfcpgop4Gxrr0VUv3TRlSkPSth3BDI82afcP9X
	fxtcGRDS+D0cD/VwlpAlvLlfMGHqQazqLqze5lXNJ+zpgZTUWT3CNQu8YSCIR8ZG
	MbCUuBzu92p+oUkHPlUcFK7FkSVlH429Ofi7t9LgHf7mgl7aqHdaTLyTknainTPW
	DOLQ9i6nDN4a/GxXhMpNNw==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11020101.outbound.protection.outlook.com [52.101.201.101])
	by mx0b-001ae601.pphosted.com (PPS) with ESMTPS id 4h1ry3seq2-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 02 Oct 2026 08:09:29 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yFecbfea22rAun5jhNXfywJ4BdbtATB3EtsS6rAo6Do/g5f/8MSBPhjBcFlDK9tUQahSTQ/EK9uvrm5FIPBoZTpKDVfamfJScqp7lxviG/KeCd0Av5/qP7Wn2uV7kchPSmwQiQAbhoOcj5a6ZBWbyFPlVpNmGh5bixfByCLG/o6ZjbT7JwT5be25ndi6C+x3A0tDDpetsEiEJ3JFNzuezJYt3k1wigB3GIo3sUVOp2UW7IwXTgWc3ino9Q7/G8QOGmEStL59OPkCwMoXti5XZOohjeinE4so2CiuaLunkyHT7svSxEAdeEMfo8Q4Pk6KsPO56FRno8O/qkM4SIfSFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sri9Kzc/DizQKz3AzYDnrLnoPiSsxA3IiJgvHSMrZYU=;
 b=i0Wpcppq5+aKAxBKIOxcs9IymyQXGycmEdNlNn50xbAZlmqI1mMxnpJtFYcvQIDBnnc4aJCob/ZVZ6scRdGKRXWupNiIzf0jIRySyR/dAgzAdq8LuX0bqb/ugdtMcwuCvUnvsoFBiVtW7PgC9xTeF9q21aMJIjg2UdtfPzCUwwDeDKM7NVYERmAakP8xw5WwXfmzgiJwIpHoJ+vpTlDiSZidKDNxPP/GZqFRVzr5PMF3DVRDREw6OsvcA9++tH2bNHxcpCgKRcF0R7mUZnS0WuQ5D32mO/XXw9zZtV9sAnFG2PbzxumwLTYPCNjGLW+bULFHNFF0QeXPEepjVXGgsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 84.19.233.75) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=opensource.cirrus.com; dmarc=fail (p=reject sp=reject pct=100)
 action=oreject header.from=opensource.cirrus.com; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cirrus4.onmicrosoft.com; s=selector2-cirrus4-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sri9Kzc/DizQKz3AzYDnrLnoPiSsxA3IiJgvHSMrZYU=;
 b=ZvTNpU1Z2mVV+NC2slnGDC8nuFhe3IZc+HMm3HCDO6/z0j2hLcJ7gktuk/DTS2Nrd+wJXUiKP6noxrXEssD6mA+ZgVDApjuwqv1g76UOkf+MQ4w/WQ9+8+wzZTjxA+Xmqj18/drJhL3jducQOD4B3pKy1H71ipQ+FNcQ3GCOvTI=
Received: from CH0PR03CA0114.namprd03.prod.outlook.com (2603:10b6:610:cd::29)
 by IA4PR19MB9043.namprd19.prod.outlook.com (2603:10b6:208:556::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.18; Fri, 2 Oct
 2026 13:09:26 +0000
Received: from CH1PEPF0000AD74.namprd04.prod.outlook.com
 (2603:10b6:610:cd:cafe::53) by CH0PR03CA0114.outlook.office365.com
 (2603:10b6:610:cd::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.19 via Frontend Transport; Fri, 2
 Oct 2026 13:09:26 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=softfail (sender
 IP is 84.19.233.75) smtp.mailfrom=opensource.cirrus.com; dkim=none (message
 not signed) header.d=none;dmarc=fail action=oreject
 header.from=opensource.cirrus.com;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 opensource.cirrus.com discourages use of 84.19.233.75 as permitted sender)
Received: from edirelay1.ad.cirrus.com (84.19.233.75) by
 CH1PEPF0000AD74.mail.protection.outlook.com (10.167.244.52) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.14
 via Frontend Transport; Fri, 2 Oct 2026 13:09:25 +0000
Received: from ediswmail9.ad.cirrus.com (ediswmail9.ad.cirrus.com [198.61.86.93])
	by edirelay1.ad.cirrus.com (Postfix) with ESMTPS id 52B77406544;
	Fri,  2 Oct 2026 13:09:24 +0000 (UTC)
Received: from [198.90.208.11] (ediswws06.ad.cirrus.com [198.90.208.11])
	by ediswmail9.ad.cirrus.com (Postfix) with ESMTPSA id 485B882254F;
	Fri,  2 Oct 2026 13:09:24 +0000 (UTC)
Message-ID: <f5ab21c6-4705-4c61-8aff-43f73443dc40@opensource.cirrus.com>
Date: Fri, 2 Oct 2026 14:09:23 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 107/877] ASoC: soc-pcm: Apply
 snd_soc_dai_link_ch_map.codec_ch_mask to codec params
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
        Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20260930152414.738996857@linuxfoundation.org>
 <20260930152417.048647943@linuxfoundation.org>
 <73b99ddb-996b-4978-a801-69a825da9954@oracle.com>
 <2026100224-statutory-embolism-2b0f@gregkh>
Content-Language: en-GB
From: Richard Fitzgerald <rf@opensource.cirrus.com>
In-Reply-To: <2026100224-statutory-embolism-2b0f@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD74:EE_|IA4PR19MB9043:EE_
X-MS-Office365-Filtering-Correlation-Id: 3da7f8fb-e2aa-482c-3f01-08df20866234
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|61400799027|82310400026|376014|23010399003|10067099003|56012099006|260925021911599003|260925021311599003|260925022911599003|4143699003|5023799004|11063799006|18002099003|13003099007|22082099003|16102099003;
X-Microsoft-Antispam-Message-Info:
	iSkgCoOyi9sl+UApOthe9J5NuK0KxvR1y3+zq6qufqyw1FdwoelmPiYyoSthes9CC8WNXdNobj9sqa2X6KAL4fOuptQomp+y++oRlJyM4tN+cipex+jbkUgK/55s2kFG+BFhJ6385tohFBkh6vvQZXLto8uGtjJDk0BpOhkY74a8mrS0YOhBiYodfYVDRoYZM1XvVp8OHQILZoDvsDPBq8eePbOWARI86dPnoZnBX/5DGTIoh3p3S/nKUpV3ek1IhcRR/k35mFQVIHnQQcRg3dAVHRc702DQjEvi4q8kCo37TRu889PtIZ5oNcRpAo0iLvvPDcnH+HWnaOb1IVkdElPZWOZ2Inz8rotWGJJUIBH0xG3k0JDxccUq9u3U8OK2mEqFFeZhKgX40xdHmyAExYiXkVnY563artMHHKdh+NDu3bltNXakByWyynDfC9/QyPVg9XJ27qRy66aEMSLQSNfTzIkus/1+axMI1BwAYzbEywjTjsDPj9nYhYEbqPjoqKF2Uli/CAibQeXpLcIrlYwdliFJrkliKczD4xKqieDCXB4EE4IDAzgpUdbvct6pzaDEyRfaQ9MQvExOQRiqBL/yd+BtNl7hpD2MRu4jt8hqqYX1IO/TDP6UQTDWfZrjsUUVei3hd5k8PrrSrJtgvg==
X-Forefront-Antispam-Report:
	CIP:84.19.233.75;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:edirelay1.ad.cirrus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(61400799027)(82310400026)(376014)(23010399003)(10067099003)(56012099006)(260925021911599003)(260925021311599003)(260925022911599003)(4143699003)(5023799004)(11063799006)(18002099003)(13003099007)(22082099003)(16102099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	j8OHzSbALvJpgNRvJ1e4xVspxcrE1PAei21Z5aEv2fqfTn5dsCP+a2abD9e5R8ERIJwmUfqyQ9RJh9ThfDXwwVRQz861dxAbl6dr/L/0zBNJxDjyoHVxvWfPQ87pWk1OY1VwSfTq3S60QGEcJuf0aMsN/XpqmQ8OhtYQrSj2w+AIidfk+m6fq4ZbPo+MfK2ZbzkuJ2jpZH3vZXfz/ct4PV/3be7g8hOujpwuS0CmTBufmdt8hF+vrQfJU3zjRWXC7PjY773AHTGtViiLSn6FCfVRqCF40tFbNX2kWnQ8fKMFy1VfhgM9qWcDeOdPv7CZ/frU32sMaBgBQv14b38Xut85sVOiVjtMlXlRDP1WYihfwmywi3qfbTRptg3RAJZ/J6JUSyGV/nFLnawCqAvdgp0XEl/+4xy1BmqxpQQHIaLT0xrvB+GpDiC6CMxuEtVE
X-Exchange-RoutingPolicyChecked:
	SXNBuSmA+HwA4U+4ZZPklrAi+BcKtqNK3qrr9X1b/tIVuVV5ieU7dTHYmlnmnW9KFvvtLfS5rj3e+cLqOYSdOiX2M8ugY+Wdw072yxTIskBtTQUQHKzTrIxTWP6BcbF2phweWcjlAw2UA+RHA85GTmPjqooYrdh9YsKGkCSlORs+9jazYE9FfcC9YvWqtztvmhPSPOF3jtXQnkkx/MCwm9rivhFlTos/Hhj+C3/GoBR4topKNITJQ9zSAPw5reCBQioQ8gttiTxVD5pJyVVjKj3Y355wQyuO549FVhIS6EApbVAbYqUjXRgqoarYY7MV9CI5hHymtr7kL0DHYUAtJg==
X-OriginatorOrg: opensource.cirrus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2026 13:09:25.2914
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3da7f8fb-e2aa-482c-3f01-08df20866234
X-MS-Exchange-CrossTenant-Id: bec09025-e5bc-40d1-a355-8e955c307de8
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bec09025-e5bc-40d1-a355-8e955c307de8;Ip=[84.19.233.75];Helo=[edirelay1.ad.cirrus.com]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-CH1PEPF0000AD74.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR19MB9043
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAyMDA1MiBTYWx0ZWRfX74UEsJyDhDmv
 FLX9cqA2PPr65tpDWU8E49UciWIjCRiqEzqvGL8xJK74t5+7c9lgPoWjOI8U8FAdd0P/ooV0/En
 IcmDPX7qdSHteIGMwlDSdvOwLgWILFI=
X-Proofpoint-GUID: mW6MWI3urHnTP6RWhO8daAKzAj5Aqw0N
X-Proofpoint-ORIG-GUID: mW6MWI3urHnTP6RWhO8daAKzAj5Aqw0N
X-Authority-Analysis: v=2.4 cv=d55gWhjE c=1 sm=1 tr=0 ts=6abfad09 cx=c_pps
 a=47SeNQKOTh9Xu+Vpzd/oYw==:117 a=h1hSm8JtM9GN1ddwPAif2w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10 a=RWc_ulEos4gA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=iX4cTi3TZMoOKdANLEfx:22 a=KfkQE9S9VqCBgivYGm0O:22
 a=bC-a23v3AAAA:8 a=w1d2syhTAAAA:8 a=VwQbUJbxAAAA:8 a=BWv5D30E3QYi0I1Ktu4A:9
 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAyMDA1MiBTYWx0ZWRfX5yB3itmRUZ67
 Ex6ovsrUtGAHv2qmVn3SOhs2dV5gG+tzgptEncjVsFFSZByHGnprIqRlKV0Fs3ljVqKEYw9AK9y
 1cdZbCPplhxsEKJ16NO7f0sgs2AUJKs8dSpddocaaRFBXvT7cKlDpxWVC2kwa5/S0/yjmq/tduX
 bWgfKsz1CMGWZfMPLF/UMQ9Q9tk17ExqYAdK96M1pm30tUwouICP6Tm803AJHXlh01pzXfZba7q
 4G0KIgpR2mp4N0ByBtpjzfE+zikaXSSrCCQvpP//u58DPTh8ertGx4ZDg/DMqHQp7b4TWBGpQIY
 PJP+3CUau/NoOcU9eWoA1m9obGplARXATX5bnWfvEGj5oeS5cId+PikCpWM0SJh3heGmRcYmuMb
 u1q6+2Jgl4S8yhrijyuuuYxMXomUTyAlr2o4cUOJMCijYUllBCI7flQX13Vba2MpSS3ME/dQrFw
 fu61YUlEkN068BswMqg==
X-Proofpoint-Spam-Reason: safe

On 02/10/2026 1:07 pm, Greg Kroah-Hartman wrote:
> On Fri, Oct 02, 2026 at 02:09:11AM +0530, Harshit Mogalapalli wrote:
>>
>>
>> On 30/09/26 8:46 pm, Greg Kroah-Hartman wrote:
>>> 6.12-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Richard Fitzgerald <rf@opensource.cirrus.com>
>>>
>>> [ Upstream commit 6b382bdfe26a2232091bf743e454e6794295783e ]
>>>
>>> In __soc_pcm_hw_params() if there is a snd_soc_dai_link_ch_map with
>>> non-zero codec_ch_mask, use that channel mask to restrict which channels
>>> are enabled on the codec. But only if there isn't a TDM mask.
>>>
>>> It is possible that a snd_soc_dai_link_ch_map could include the same codec
>>> multiple times on different CPUs so the for_each_rtd_ch_maps() loop
>>> accumulates the channel masks for all entries of that codec.
>>>
>>> If a TDM mask was also set, it takes priority and is used instead of any
>>> possible snd_soc_dai_link_ch_map entries. (They cannot be ANDed together
>>> because the bit positions are indicating different things: TDM is a bit
>>> for each TDM slot, codec_ch_mask is a bit for each codec channel.)
>>>
>>> This fixes a problem of incorrect TX channels enabled on the codec when
>>> multiple codecs are aggregated on a single capture link. For example:
>>>
>>> - Two CPUs with six 4-channel codecs.
>>> - The machine driver chooses to assign one channel from each codec to
>>>     one channel on the CPU
>>> - But the codec hw_params() would be passed a channel count of 6, which
>>>     (a) is more channels than the codec has and (b) allows enabling channels
>>>     that should not be driving the audio bus.
>>>
>>> Fixes: ac950278b087 ("ASoC: add N cpus to M codecs dai link support")
>>> Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
>>> Link: https://patch.msgid.link/20260910114500.1586637-4-rf@opensource.cirrus.com
>>> Signed-off-by: Mark Brown <broonie@kernel.org>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>
>> Hi Greg/Sasha,
>>
>> An AI-assisted review flagged a possible omission. I independently
>> checked the core and SoundWire producer at 6.12.y f4ffa8dc360b.
>>
>> The core backport correctly preserves TDM precedence and combines
>> codec_ch_mask entries for each codec. The question is its missing
>> SoundWire producer.
>>
>> Upstream's companion has: 290845e151cd4e307cc1f25319583aaceb4eeb30,
>> sound/soc/sdw_utils/soc_sdw_utils.c:
>>
>> for_each_link_ch_maps(rtd->dai_link, i, ch_maps) {
>>      ch_maps->cpu_ch_mask = cpu_ch_mask << (i * step);
>>      ch_maps->codec_ch_mask = codec_ch_mask;
>> }
>>
>> 6.12.y asoc_sdw_hw_params() at f4ffa8dc360bce834e6ea7b0148eab0118f4a42e,
>> sound/soc/sdw_utils/soc_sdw_utils.c:
>>
>> for_each_link_ch_maps(rtd->dai_link, i, ch_maps)
>>      ch_maps->cpu_ch_mask = ch_mask << (i * step);
>>
>> Only the declaration and core consumer use codec_ch_mask in include/ and
>> sound/. SoundWire leaves it zero, so without a TDM mask the codec keeps
>> the aggregate channel count and capture restriction stays inactive.
>> Hardware impact was not tested.
>>
>> Could the ASoC maintainer confirm whether
>> 290845e151cd4e307cc1f25319583aaceb4eeb30 ("ASoC: sdw_utils: Set
>> snd_soc_dai_link_ch_map.codec_ch_mask for capture") should accompany
>> this 6.12 series to complete the SoundWire capture fix?
> 
> If that is true, then that needs to be backported to all stable kernel
> trees.
> 
> thanks,
> 
> greg k-h
It's likely not a critical omission if nobody has noticed the bug before
now.

So I'd guess all currently shipping products just happen to work (either
it's a single codec so no aggregation, or 2 stereo amp so the incorrect
channel count of 2 is supported by the codec driver anyway).

However, I can only speak for Cirrus Logic amps, which aren't
_currently_ using this (but will in future). I can't say whether there
is other silicon that uses this and is in fact broken without anyone
having noticed.
