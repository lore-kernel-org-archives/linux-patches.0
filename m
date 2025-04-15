Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58FA2DFA32;
	Tue, 15 Apr 2025 02:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744685728; cv=none; b=b/k1uEmCHmwAuCqEkLtmT/eGjc4Vq9866egsxi4pMlg7M+iWijIUOhKXtxqh71UhvxwEWrrxNqWfRC+A71Q36uUDa5kO738kkuWuXIyTBfz+2rFF50srUXdy2Mwsmfs4HgsDwsUbpTPm8CQtVSkyLi7yTSnYYUuDQT8s3wJNA00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744685728; c=relaxed/simple;
	bh=c/72eoNx7CELfAORprzQXHYer9nWl9b9iKcnpAMB/yg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=YjKYzm2jchkmwI4L2zIAuzNGNABzGYcWqO6gYT+e/nd51SJhtuW8s7uGhkZ+0vL8hiI4xCoDCEcZ3rDuWQTmmba4k5qRz4kg8qPTCjeRSzyW7c6YIZeew2qnPFfHPeOTpOH+9DAASmaUpj3o5OISo/qiEUMvFGXCB3gB0pbVf9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=CJwwOssi; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="CJwwOssi"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53F15Mor020225;
	Tue, 15 Apr 2025 02:55:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	39o2Uud3dvVPD6vAB2SUkPsExB4TNyRPHU2N8tihKIc=; b=CJwwOssivCI78QPE
	0iO3GJ6mGD6IdUxHTpW4a6OHbekAGmquvcyXwrZAsIoXZ7UIO5CKBMrc74HSDi4i
	K++cUp0GSLgdDYWRkk7lp+pGFK77jN9yHWHciBh9FgM+3Ar0Ugyz4lC730UKhrKU
	pF3sageAGP+o9BGx+u7s2RI/OBhnXxrQRXt00T+i6NNcdvgZqhny5eI6QTDgrk8Q
	6kXNhdngA4pkldpUqleieRunSc91TMQ2Oy7EGf8iC59Z7xsJgDox9HB85L64S6M2
	OJUT1nnjPQ0cHBgFB8cYwgexifIENpksbH/X2MZmU0ORmJL2BbRjV4cqMSHzJx7G
	9zgA+Q==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 45yfgjeejw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Apr 2025 02:55:21 +0000 (GMT)
Received: from nalasex01b.na.qualcomm.com (nalasex01b.na.qualcomm.com [10.47.209.197])
	by NALASPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 53F2tKKr027208
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Apr 2025 02:55:20 GMT
Received: from [10.133.33.156] (10.80.80.8) by nalasex01b.na.qualcomm.com
 (10.47.209.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Mon, 14 Apr
 2025 19:55:17 -0700
Message-ID: <49b98882-6a69-48b8-af0c-01f78373d0ef@quicinc.com>
Date: Tue, 15 Apr 2025 10:55:06 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 084/731] wifi: ath11k: update channel list in reg
 notifier instead reg worker
To: Jiri Slaby <jirislaby@kernel.org>,
        Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, Wen Gong <quic_wgong@quicinc.com>,
        "Aditya
 Kumar Singh" <quic_adisi@quicinc.com>,
        Jeff Johnson
	<jeff.johnson@oss.qualcomm.com>,
        Sasha Levin <sashal@kernel.org>
References: <20250408104914.247897328@linuxfoundation.org>
 <20250408104916.224926328@linuxfoundation.org>
 <5cd9db3f-4abf-4b66-b401-633508e905ac@kernel.org>
Content-Language: en-US
From: Kang Yang <quic_kangyang@quicinc.com>
In-Reply-To: <5cd9db3f-4abf-4b66-b401-633508e905ac@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: MEIBxeXhC_5SFRlxJxvyv7She13zuEEC
X-Proofpoint-ORIG-GUID: MEIBxeXhC_5SFRlxJxvyv7She13zuEEC
X-Authority-Analysis: v=2.4 cv=Cve/cm4D c=1 sm=1 tr=0 ts=67fdca99 cx=c_pps a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=VwQbUJbxAAAA:8 a=bC-a23v3AAAA:8 a=COk6AnOGAAAA:8
 a=EUspDBNiAAAA:8 a=cSPYK51DSqVN3GOQgIQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=-FEs8UIgK8oA:10 a=FO4_E8m0qiDe52t0p3_H:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-15_01,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1011
 malwarescore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
 priorityscore=1501 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2504150016



On 4/14/2025 1:59 PM, Jiri Slaby wrote:
> On 08. 04. 25, 12:39, Greg Kroah-Hartman wrote:
>> 6.14-stable review patch.  If anyone has any objections, please let me 
>> know.
>>
>> ------------------
>>
>> From: Wen Gong <quic_wgong@quicinc.com>
>>
>> [ Upstream commit 933ab187e679e6fbdeea1835ae39efcc59c022d2 ]
>>
>> Currently when ath11k gets a new channel list, it will be processed
>> according to the following steps:
>> 1. update new channel list to cfg80211 and queue reg_work.
>> 2. cfg80211 handles new channel list during reg_work.
>> 3. update cfg80211's handled channel list to firmware by
>> ath11k_reg_update_chan_list().
>>
>> But ath11k will immediately execute step 3 after reg_work is just
>> queued. Since step 2 is asynchronous, cfg80211 may not have completed
>> handling the new channel list, which may leading to an out-of-bounds
>> write error:
>> BUG: KASAN: slab-out-of-bounds in ath11k_reg_update_chan_list
>> Call Trace:
>>      ath11k_reg_update_chan_list+0xbfe/0xfe0 [ath11k]
>>      kfree+0x109/0x3a0
>>      ath11k_regd_update+0x1cf/0x350 [ath11k]
>>      ath11k_regd_update_work+0x14/0x20 [ath11k]
>>      process_one_work+0xe35/0x14c0
>>
>> Should ensure step 2 is completely done before executing step 3. Thus
>> Wen raised patch[1]. When flag NL80211_REGDOM_SET_BY_DRIVER is set,
>> cfg80211 will notify ath11k after step 2 is done.
>>
>> So enable the flag NL80211_REGDOM_SET_BY_DRIVER then cfg80211 will
>> notify ath11k after step 2 is done. At this time, there will be no
>> KASAN bug during the execution of the step 3.
>>
>> [1] https://patchwork.kernel.org/project/linux-wireless/ 
>> patch/20230201065313.27203-1-quic_wgong@quicinc.com/
>>
>> Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125- 
>> QCAHSPSWPL_V1_V2_SILICONZ_LITE-3
>>
>> Fixes: f45cb6b29cd3 ("wifi: ath11k: avoid deadlock during regulatory 
>> update in ath11k_regd_update()")
>> Signed-off-by: Wen Gong <quic_wgong@quicinc.com>
>> Signed-off-by: Kang Yang <quic_kangyang@quicinc.com>
>> Reviewed-by: Aditya Kumar Singh <quic_adisi@quicinc.com>
>> Link: https://patch.msgid.link/20250117061737.1921-2- 
>> quic_kangyang@quicinc.com
>> Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>   drivers/net/wireless/ath/ath11k/reg.c | 22 +++++++++++++++-------
>>   1 file changed, 15 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath11k/reg.c b/drivers/net/ 
>> wireless/ath/ath11k/reg.c
>> index b0f289784dd3a..7bfe47ad62a07 100644
>> --- a/drivers/net/wireless/ath/ath11k/reg.c
>> +++ b/drivers/net/wireless/ath/ath11k/reg.c
>> @@ -1,7 +1,7 @@
>>   // SPDX-License-Identifier: BSD-3-Clause-Clear
>>   /*
>>    * Copyright (c) 2018-2019 The Linux Foundation. All rights reserved.
>> - * Copyright (c) 2021-2024 Qualcomm Innovation Center, Inc. All 
>> rights reserved.
>> + * Copyright (c) 2021-2025 Qualcomm Innovation Center, Inc. All 
>> rights reserved.
>>    */
>>   #include <linux/rtnetlink.h>
>> @@ -55,6 +55,19 @@ ath11k_reg_notifier(struct wiphy *wiphy, struct 
>> regulatory_request *request)
>>       ath11k_dbg(ar->ab, ATH11K_DBG_REG,
>>              "Regulatory Notification received for %s\n", 
>> wiphy_name(wiphy));
>> +    if (request->initiator == NL80211_REGDOM_SET_BY_DRIVER) {
>> +        ath11k_dbg(ar->ab, ATH11K_DBG_REG,
>> +               "driver initiated regd update\n");
>> +        if (ar->state != ATH11K_STATE_ON)
>> +            return;
>> +
>> +        ret = ath11k_reg_update_chan_list(ar, true);
>> +        if (ret)
>> +            ath11k_warn(ar->ab, "failed to update channel list: 
>> %d\n", ret);
>> +
>> +        return;
>> +    }
> 
> I suspect this causes stalls for me.
> 
> Workqueues are waiting for rtnl_lock:
>> Showing busy workqueues and worker pools:
>> workqueue events_unbound: flags=0x2
>>   pwq 64: cpus=0-15 flags=0x4 nice=0 active=1 refcnt=2
>>     in-flight: 107692:linkwatch_event
>> workqueue netns: flags=0x6000a
>>   pwq 64: cpus=0-15 flags=0x4 nice=0 active=1 refcnt=18
>>     in-flight: 107676:cleanup_net workqueue pm: flags=0x4
>>   pwq 2: cpus=0 node=0 flags=0x0 nice=0 active=5 refcnt=6
>>     in-flight: 
>> 107843:pm_runtime_work ,100179:pm_runtime_work ,50846:pm_runtime_work ,107845:pm_runtime_work ,107652:pm_runtime_work
>> workqueue ipv6_addrconf: flags=0x6000a
>>   pwq 64: cpus=0-15 flags=0x4 nice=0 active=1 refcnt=18
>>     in-flight: 107705:addrconf_dad_work
> 
> While the above reg_notifier is stuck too:
> 
>  > workqueue events: flags=0x0
>  >   pwq 14: cpus=3 node=0 flags=0x0 nice=0 active=1 refcnt=2
>  >     in-flight: 107807:reg_todo [cfg80211]
> 
> waiting for:
>> Workqueue: events reg_todo [cfg80211]
>> Call Trace:
>>  <TASK>
>>  __schedule+0x437/0x1470
>>  schedule+0x27/0xf0
>>  schedule_timeout+0x73/0xe0
>>  __wait_for_common+0x8e/0x1c0
>>  ath11k_reg_update_chan_list+0x23c/0x290 [ath11k 
>> 30c4a145118dc3331f552d6275ec7d6272671444]
>>  ath11k_reg_notifier+0x5a/0x80 [ath11k 
>> 30c4a145118dc3331f552d6275ec7d6272671444]
>>  reg_process_self_managed_hint+0x170/0x1b0 [cfg80211 
>> 2571f504aa68d55c11440c869062c668de1a2dce]
>>  reg_process_self_managed_hints+0x47/0xf0 [cfg80211 
>> 2571f504aa68d55c11440c869062c668de1a2dce]
>>  reg_todo+0x207/0x290 [cfg80211 2571f504aa68d55c11440c869062c668de1a2dce]
>>  process_one_work+0x17b/0x330
>>  worker_thread+0x2ce/0x3f0
> 
> 
> Is stable missing some backport or is this a problem in 6.15-rc too?
> 
> /me looking...
> 
> Ah, what about:
> commit 02aae8e2f957adc1b15b6b8055316f8a154ac3f5
> Author: Wen Gong <quic_wgong@quicinc.com>
> Date:   Fri Jan 17 14:17:37 2025 +0800
> 
>      wifi: ath11k: update channel list in worker when wait flag is set
> 
> ?


Yes, please add this patch. It will minimize the occupation time of 
rtnl_lock.

You can retry and check if this warning will show again.



> 
> thanks,

