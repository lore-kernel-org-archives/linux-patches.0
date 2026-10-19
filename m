Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD013F39D8
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 03:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792379548; cv=none; b=kJE77NT9Q7b0Vfi2Qh/l63Y7YOF2vLCYO2NjNAB1S6aPhPLvxMtwiBNiwL9UcoLy0WrlfSMA2eLxQzOcDr/8cw4/vA1QxUYiRhreIZlwtVp+r3eju74SfXOGCkAwE534ocR0AWiCHV9e5W1K3CNPTytf/ImM6czDO77xpv1GjKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792379548; c=relaxed/simple;
	bh=xBze/esHEQscI64YI8Mtq8qYBBjI+54M0i0crGIpxAs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hPAxMsLe1g8DMvIHaLr6xn5lFttmWiq1XP6eVbHcUta5irxXtv9ZHretFPPc+XcUhnrCXVR1EB93zH01cTKcMmJpgogQmx9+nz2EtiAxX0evBbfRA6PGx6P5zROswd0CxpfQqR5oMWCsMi+sYA3OA4KnmPkFXr8v0Vgm1ynH/HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LeUYhLv3; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JBtoiS1E; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LeUYhLv3";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JBtoiS1E"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69J1FZ2i1825688
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 03:12:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	aVH/TRFVmG8aC1ltItyAqGa5kdH8XTInh9Hqgv8rlAM=; b=LeUYhLv3Rsx70wBJ
	GgTCTd/rQjpc9kLEs0Bp1NBHo3BV33ywOIXUVhYMdxlV15t86PYae8iMImR/X1RD
	DkJTFmseTZQLfZoHEp5O79wHU0frPxiy5YSAD+h/nICbQ0FPkzqEA7UNpsuf3lqm
	Z6CG5xHrYwmr13SmCaYKiG19q2zA5KPIXVqir0GIzlctsA8uAxSPLXbKAE1Kdy5w
	34h8PG5eiuV0mnOXIuFfU5U1szV8B3El+oB14HhieePIyN9DaD+j2NKuQPFIlfCv
	h0Y00L0xdtQUnnZAVEj8fi670wL3+5mtKPlzv67mYBiOa4DWgnxvQ83Lz8Rq7SAl
	DY/5Kw==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hc0kxmpq9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 03:12:23 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cd60e4e8bc3so944981a12.1
        for <patches@lists.linux.dev>; Sun, 18 Oct 2026 20:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792379543; x=1792984343; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aVH/TRFVmG8aC1ltItyAqGa5kdH8XTInh9Hqgv8rlAM=;
        b=JBtoiS1EgryTsOGVR9eV8Ii+WTZNwvyskDBpe0J70aX89ZGswrxzl0yWabaIr7pses
         NKt1qDgTeQV9XxVM5hJR+zywnsYKYPSYUPxPXYPnW0Su/+zHesoLSrwEdGoWdgNuVill
         oVLNc+b6ljyjR0wuquPPlegztFBWSffPyPIpEpMTjwK3e3t9tn1IiWn50ON1s8dy/85r
         RdL6phVJA7UmYEq1COFoo546HqG0/3fYPGLL9uiOupvIliKwJC0GFcEfROaXEfJIrN/n
         Hc2T8v8YW4BVEVeAihUlM1BeM81HSd8EVyzqsGsP5pXXppUMSuKl5jjdNWMM7UOrPlpT
         odAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792379543; x=1792984343;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aVH/TRFVmG8aC1ltItyAqGa5kdH8XTInh9Hqgv8rlAM=;
        b=SBTnD+8sg5KSs5z8EovSHLvucJ5qPmU7ODUO6Dj1ySYA3h5Fwh/4vuSYJcCLr74/8z
         U7JyAC6W0UYazZ7Z5azfaqKR6bTJY/yYyn5LQPUVAv9FbVP1wUT4Ia/hPJ1a9WlwUCBl
         g0pKmZYmnBc6IZgMKP7DmeIdFtnPrulAy16sI9LytlrFBsZgx++3ffiVNpw7T7d3hFMp
         A4XqIluvg35y2L7ZoM8lyu06E0Ir7ZP8Jnm4TRe4sicW9zOVDg4RBifRDD+vcky3DI+u
         +pyF/5v15RwvDElvnr/USFPAipQe16CJzbMRF2rjN8lTAo+3KvPscCAswOgZX8iEDXjy
         8k6Q==
X-Gm-Message-State: AFq9FYLBwwN8MYct26zAjM8Y2GytDDLqQLze6VAAWwfat2hoB8HW2XBj
	OQ2iubgDzvdaFgCdyXGgD/qZ9uBJNJxlxrdDk2wAsZ+Dtk4lN94/qsontwKoHDMUHopBi6ZTIUB
	j/q9zH7I97Uyton/L9glUVaB7Gtvotsa1NJmdpm1w90GU7El4M/hX2sIfKKE2
X-Gm-Gg: AYBFou0kiic0DOrAUHF0q8RhZyYWa19rfgI37nMHF3p10E95w9Lx9nl5csgb5spmaZ4
	LCiU1RDnk6FLcqYvPUe/3ruJb+Ce0bySfkhvGjspm7baJwsFR0e2fGRWMOKlk4maB9G1si35lwe
	Vpgp9O0Cs+0vOzHdVDSxb3hi8ct86Cpr+gkAmWzrFP5fHTlXZkh50fSsKT2WOUhHMOdPmh/tH+w
	RR27bKPOcGnWSkdc7DOYtNZMHlOSAPb9C9Jl9veyc0E9ktrMiKNWv54fuRkz+j51n/S8td/HZ/c
	mHTC/GG7rQHf5n7156gAaVObHKT9xeo1DDfNWy81aq4w3iSomYb0IuMwtTG9WJNnNiVX58gerIF
	VSAHNOsu1BR1hvsTILmDKBS0zymD3XgBTRrXJt7jgeYwRGSvTlYYDVY8KmaGnwTcfxrQ=
X-Received: by 2002:a05:6a20:7f97:b0:3e1:c716:3a00 with SMTP id adf61e73a8af0-3e22600f6c1mr5161478637.53.1792379542594;
        Sun, 18 Oct 2026 20:12:22 -0700 (PDT)
X-Received: by 2002:a05:6a20:7f97:b0:3e1:c716:3a00 with SMTP id adf61e73a8af0-3e22600f6c1mr5161458637.53.1792379542005;
        Sun, 18 Oct 2026 20:12:22 -0700 (PDT)
Received: from [10.133.33.25] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd65497dfc8sm3383612a12.9.2026.10.18.20.12.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Oct 2026 20:12:21 -0700 (PDT)
Message-ID: <b79e28ed-f780-4179-bd60-2f1d3a3c800a@oss.qualcomm.com>
Date: Mon, 19 Oct 2026 11:12:18 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 0773/1674] wifi: ath10k: shutdown driver when hardware
 is unreliable
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Loic Poulain <loic.poulain@oss.qualcomm.com>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Sasha Levin <sashal@kernel.org>
References: <20261017160431.119607952@linuxfoundation.org>
 <20261017160450.945650442@linuxfoundation.org>
Content-Language: en-US
From: Kang Yang <kang.yang@oss.qualcomm.com>
In-Reply-To: <20261017160450.945650442@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE5MDAxMiBTYWx0ZWRfX7b7gTeAjC4lQ
 cEJmslaiwJF4L9mhjPpWD3V0jJxJy2hbZVpn3j1mjQzVuu+LZ0qQSRKpUzjeZI9gPM1xO5ZUvfT
 YunM2ETrkhmKJjw3hxf2yyjd/GHyvAw=
X-Authority-Analysis: v=2.4 cv=JpZkP84C c=1 sm=1 tr=0 ts=6ad58a97 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=bC-a23v3AAAA:8 a=EUspDBNiAAAA:8 a=gdJcGf8OW6ym4206rAoA:9
 a=QEXdDO2ut3YA:10 a=3WC7DwWrALyhR5TkjVHa:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE5MDAxMiBTYWx0ZWRfX7gXzVEzUXSKE
 tbfmouuTIDu5eLX5/ibbixEoocdfKRNlEwSb54XaxUKXX5A468CxKqlqnlLjKwaPA9xXuyJG0tJ
 //ZpjPSOGmS54xDban/rweT9jTxS8nVdbROQnPZlEaeHuf5azDxLgAsafM66dw3/x0Ugei79iKx
 lKS5Cac8oUYsIQVF8Pp/rNrc8Qttfp9yFMzF7apjJ3w/5V5NdrkobToRCKXqE8CXAkVd+m/x8+k
 VTotXNEZVH+qoiLAfod+8BgWAqI5ZTQ9H+1xRdgQnhLS7U8dqQZj4skC4vdZieQ3wYNczoCm/Te
 XzBO0ZvK+AEIpN4k0QED89/MxpFM6mtp+SVpXxWnubDeZ756GMNgpDPTHOnSpQ1ANEOwZUjvS9E
 z9Z5gnZwUY5JplFWxlZR7F6YgcWCWx2P9GoNqi/1NFM2/lI04ydmZiA3H+1XjMDfjSX1rkZqiO0
 hSHwB8tLHnvC+yHpApQ==
X-Proofpoint-ORIG-GUID: lNM0QfZHB-qwODb9WX3fT79waziA_geo
X-Proofpoint-GUID: lNM0QfZHB-qwODb9WX3fT79waziA_geo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-19_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0
 clxscore=1011 impostorscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610190012



On 10/17/2026 11:50 PM, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me know.


Should add below patches too:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f35a07a4842a88801d9182b1a76d178bfa616978

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=54a5b38e4396530e5b2f12b54d3844e860ab6784



> 
> ------------------
> 
> From: Kang Yang <kang.yang@oss.qualcomm.com>
> 
> [ Upstream commit c256a94d1b1b15109740306f7f2a7c2173e12072 ]
> 
> In rare cases, ath10k may lose connection with the PCIe bus due to
> some unknown reasons, which could further lead to system crashes during
> resuming due to watchdog timeout:
> 
> ath10k_pci 0000:01:00.0: wmi command 20486 timeout, restarting hardware
> ath10k_pci 0000:01:00.0: already restarting
> ath10k_pci 0000:01:00.0: failed to stop WMI vdev 0: -11
> ath10k_pci 0000:01:00.0: failed to stop vdev 0: -11
> ieee80211 phy0: PM: **** DPM device timeout ****
> Call Trace:
>   panic+0x125/0x315
>   dpm_watchdog_set+0x54/0x54
>   dpm_watchdog_handler+0x57/0x57
>   call_timer_fn+0x31/0x13c
> 
> At this point, all WMI commands will timeout and attempt to restart
> device. So set a threshold for consecutive restart failures. If the
> threshold is exceeded, consider the hardware is unreliable and all
> ath10k operations should be skipped to avoid system crash.
> 
> fail_cont_count and pending_recovery are atomic variables, and
> do not involve complex conditional logic. Therefore, even if recovery
> check and reconfig complete are executed concurrently, the recovery
> mechanism will not be broken.
> 
> Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1
> 
> Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
> Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
> Link: https://patch.msgid.link/20250623022731.509-1-kang.yang@oss.qualcomm.com
> Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/net/wireless/ath/ath10k/core.c | 48 +++++++++++++++++++++++---
>   drivers/net/wireless/ath/ath10k/core.h | 11 ++++--
>   drivers/net/wireless/ath/ath10k/mac.c  |  7 +++-
>   drivers/net/wireless/ath/ath10k/wmi.c  |  6 ++++
>   4 files changed, 63 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index 83e0efe0e3d90..0fb56246d4624 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -2469,12 +2469,50 @@ static int ath10k_init_hw_params(struct ath10k *ar)
>   	return 0;
>   }
>   
> +static bool ath10k_core_needs_recovery(struct ath10k *ar)
> +{
> +	long time_left;
> +
> +	/* Sometimes the recovery will fail and then the next all recovery fail,
> +	 * so avoid infinite recovery.
> +	 */
> +	if (atomic_read(&ar->fail_cont_count) >= ATH10K_RECOVERY_MAX_FAIL_COUNT) {
> +		ath10k_err(ar, "consecutive fail %d times, will shutdown driver!",
> +			   atomic_read(&ar->fail_cont_count));
> +		ar->state = ATH10K_STATE_WEDGED;
> +		return false;
> +	}
> +
> +	ath10k_dbg(ar, ATH10K_DBG_BOOT, "total recovery count: %d", ++ar->recovery_count);
> +
> +	if (atomic_read(&ar->pending_recovery)) {
> +		/* Sometimes it happened another recovery work before the previous one
> +		 * completed, then the second recovery work will destroy the previous
> +		 * one, thus below is to avoid that.
> +		 */
> +		time_left = wait_for_completion_timeout(&ar->driver_recovery,
> +							ATH10K_RECOVERY_TIMEOUT_HZ);
> +		if (time_left) {
> +			ath10k_warn(ar, "previous recovery succeeded, skip this!\n");
> +			return false;
> +		}
> +
> +		/* Record the continuous recovery fail count when recovery failed. */
> +		atomic_inc(&ar->fail_cont_count);
> +
> +		/* Avoid having multiple recoveries at the same time. */
> +		return false;
> +	}
> +
> +	atomic_inc(&ar->pending_recovery);
> +
> +	return true;
> +}
> +
>   void ath10k_core_start_recovery(struct ath10k *ar)
>   {
> -	if (test_and_set_bit(ATH10K_FLAG_RESTARTING, &ar->dev_flags)) {
> -		ath10k_warn(ar, "already restarting\n");
> +	if (!ath10k_core_needs_recovery(ar))
>   		return;
> -	}
>   
>   	queue_work(ar->workqueue, &ar->restart_work);
>   }
> @@ -2510,6 +2548,8 @@ static void ath10k_core_restart(struct work_struct *work)
>   	struct ath10k *ar = container_of(work, struct ath10k, restart_work);
>   	int ret;
>   
> +	reinit_completion(&ar->driver_recovery);
> +
>   	set_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags);
>   
>   	/* Place a barrier to make sure the compiler doesn't reorder
> @@ -2574,8 +2614,6 @@ static void ath10k_core_restart(struct work_struct *work)
>   	if (ret)
>   		ath10k_warn(ar, "failed to send firmware crash dump via devcoredump: %d",
>   			    ret);
> -
> -	complete(&ar->driver_recovery);
>   }
>   
>   static void ath10k_core_set_coverage_class_work(struct work_struct *work)
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
> index cb2359d2ee0b0..91f3466f9ccba 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -4,6 +4,7 @@
>    * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
>    * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
>    * Copyright (c) 2022 Qualcomm Innovation Center, Inc. All rights reserved.
> + * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
>    */
>   
>   #ifndef _CORE_H_
> @@ -86,6 +87,8 @@
>   				  IEEE80211_IFACE_SKIP_SDATA_NOT_IN_DRIVER)
>   #define ATH10K_ITER_RESUME_FLAGS (IEEE80211_IFACE_ITER_RESUME_ALL |\
>   				  IEEE80211_IFACE_SKIP_SDATA_NOT_IN_DRIVER)
> +#define ATH10K_RECOVERY_TIMEOUT_HZ			(5 * HZ)
> +#define ATH10K_RECOVERY_MAX_FAIL_COUNT			4
>   
>   struct ath10k;
>   
> @@ -864,9 +867,6 @@ enum ath10k_dev_flags {
>   	/* Per Station statistics service */
>   	ATH10K_FLAG_PEER_STATS,
>   
> -	/* Indicates that ath10k device is during recovery process and not complete */
> -	ATH10K_FLAG_RESTARTING,
> -
>   	/* protected by conf_mutex */
>   	ATH10K_FLAG_NAPI_ENABLED,
>   };
> @@ -1208,6 +1208,11 @@ struct ath10k {
>   	struct work_struct bundle_tx_work;
>   	struct work_struct tx_complete_work;
>   
> +	atomic_t pending_recovery;
> +	unsigned int recovery_count;
> +	/* continuous recovery fail count */
> +	atomic_t fail_cont_count;
> +
>   	/* cycle count is reported twice for each visited channel during scan.
>   	 * access protected by data_lock
>   	 */
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 842edfcfef262..27f6cc05bf9aa 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -8132,7 +8132,12 @@ static void ath10k_reconfig_complete(struct ieee80211_hw *hw,
>   		ath10k_info(ar, "device successfully recovered\n");
>   		ar->state = ATH10K_STATE_ON;
>   		ieee80211_wake_queues(ar->hw);
> -		clear_bit(ATH10K_FLAG_RESTARTING, &ar->dev_flags);
> +
> +		/* Clear recovery state. */
> +		complete(&ar->driver_recovery);
> +		atomic_set(&ar->fail_cont_count, 0);
> +		atomic_set(&ar->pending_recovery, 0);
> +
>   		if (ar->hw_params.hw_restart_disconnect) {
>   			list_for_each_entry(arvif, &ar->arvifs, list) {
>   				if (arvif->is_up && arvif->vdev_type == WMI_VDEV_TYPE_STA)
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> index 3c4bf7e78818d..172dc55375552 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -4,6 +4,7 @@
>    * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
>    * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
>    * Copyright (c) 2021-2024 Qualcomm Innovation Center, Inc. All rights reserved.
> + * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
>    */
>   
>   #include <linux/skbuff.h>
> @@ -1942,6 +1943,11 @@ int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id)
>   	}
>   
>   	wait_event_timeout(ar->wmi.tx_credits_wq, ({
> +		if (ar->state == ATH10K_STATE_WEDGED) {
> +			ret = -ESHUTDOWN;
> +			ath10k_dbg(ar, ATH10K_DBG_WMI,
> +				   "drop wmi command %d, hardware is wedged\n", cmd_id);
> +		}
>   		/* try to send pending beacons first. they take priority */
>   		ath10k_wmi_tx_beacons_nowait(ar);
>   

