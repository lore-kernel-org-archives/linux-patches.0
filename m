Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AA8272E56
	for <patches@lists.linux.dev>; Tue, 13 Jan 2026 21:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768338135; cv=none; b=CCDq1IQ24eTD52QbWb9PqntftaT6n/8luTn8hiAH+8n0kdpb7OgslMZU0TSkZ6mfxf3ZNJR4WtqVff+zIV/FrJLI7MxzH3bWfwrXWHC3MpgtsJVafE5BEGCTVN/H8+34a2hbmjEMGaCsx9hIfbD0XxR7KzPn2Z/F7mgGNUhE68Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768338135; c=relaxed/simple;
	bh=ApM7OzbIE/riLz+7TahvI8JWee0B6zvWNi/c8/Iho4g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NQtazGA5lv2XNSYyS09sS2L8UQ4ZaivJ6UtAYmxudt+UKFANnAynw2eiodbYeBgjzlj2nrWaSLaII2IS5rWISgTgX6ysBs42lR+TgPqmVW/xTO5uY4G2WGEOtrdssdPjtDEvKt5XDN8hbo11gFkMgmDaMSfkGoNcd31eURBBERk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=M+qWKaYj; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZpTTsQ4A; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="M+qWKaYj";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZpTTsQ4A"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60DHQBuM694577
	for <patches@lists.linux.dev>; Tue, 13 Jan 2026 21:02:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	PN/lkOtrYA2OT2ZpcMymY52CzXoyPIuxPKU48Dyzghs=; b=M+qWKaYjaEwGs7Xv
	1f0ZBNDgMy5taVSN17y1VlpHKIz3yinTD/VEQZMCRYUaE2DcUPd+JALbn2IOWlTe
	C5zbGPVBlFxdNbHlArgTGvZk9N00vfcXAhfhd1WNN6HapejiP2ok+FmMLvwN8IlA
	7HxHc0OVNZopGB7BjYxer4BjBHr4Jm2lY0Jax3wrEDOzo2QZqo+Rg5qbBP6vbsIs
	azoJn7eLlyYL0ngJDucVHxYUtsTYLKVMci05VaRJzDVaHcqLk+s1BrMtXNDt13kU
	ng4zgKl3pygNStskRIUSlSzqoQ3NSsLXDQDIwMjXaBLHXxBBtJ2ClqJSQ66dP2Ow
	/Ld6tQ==
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com [209.85.221.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bntet0pb0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Tue, 13 Jan 2026 21:02:12 +0000 (GMT)
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-5636df6aa41so9586058e0c.2
        for <patches@lists.linux.dev>; Tue, 13 Jan 2026 13:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1768338131; x=1768942931; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PN/lkOtrYA2OT2ZpcMymY52CzXoyPIuxPKU48Dyzghs=;
        b=ZpTTsQ4AKGDgMasUdTaGF2JSBCY/t6mhs/kNAb2sv9nRWW5QumUoSoAHe+bMWEc5aI
         MLeUD7OC8LTocBRKTNl6S/OAViqjWKUM5l/GE7TLjPvYZOz7og+UCUtdpLdLRZ/UJDiI
         /UGQf6cFwfYQnhJ/hI5POKrxy2dGbD1T5T/ToisUt/ZBlyqHgLWGQhwTmXLwARFgjCro
         QvWrmby0vK8I62RD2Sy/MvqJYtJRS9ZSRCKMiOOg16Vgfmu7viNMH6KHu5XudpqxEGsL
         0n3E5/LGy9cukaP0u9Um8454N/uAl4x3WHilWYCqPQxnk96a9AXH6zaG/eJ2Ixoh6U+2
         cDJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768338131; x=1768942931;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PN/lkOtrYA2OT2ZpcMymY52CzXoyPIuxPKU48Dyzghs=;
        b=bEVp4K7Qy/YWkt8MqOdvq/EobMIEZwFrxXm7DaH7F5cH5UtzQDDg6vw8N3C5TAB4bN
         XR65EkM1c1Dr7bh7kEM1YziF/GJwDB8XQ5uRIrWp8WTX1CaD7F/GseFmmjxfvmnS/jpZ
         X+a8iCYKDy2AoOrAG2l1fts/ZOqIM9YDG/ikjzsCO0zMCYuYUvwKueV6Fw+LHjVbGKFA
         HZRvZepL6nG1BzRxqQsWELDFh3yxcWa1jkcpWZyjWuLFnhHBF2wnIl7HtkJhZIvBw8Kj
         gliZn6xL8m4RJxvvtnasPKymLgmdeJ3vDbP/f5fI0jWoW3KRz6VdUC+SGD/huR6nqIf+
         IsVw==
X-Forwarded-Encrypted: i=1; AJvYcCWViVxMRblHORy26EZd01MoWeBgHp2fDCkSipUKYG2PTn/gZYZmXFGiJ83FFsUbVPQftyX6kO24@lists.linux.dev
X-Gm-Message-State: AOJu0YyToNz7NucIHpDfidomAz1QxX3qlylX6k53r8v141jpHsZBq4kj
	4RI1NLS2OLjm7QCEWsvxkemY8aungs6MC1AJuk/uiTBeTyP0t44KAM8P3wjzu9pYv49/icRbbtX
	jEZfHZRSypF+vgiEoc0v4G461GdJ3HBhtRSF6dWUWJqFU9DN/SjOnP+s1YPbsXco2vqPZ
X-Gm-Gg: AY/fxX6BvL96XtSksNGYd5R5urdMBjvY3N3r0kDmaM6jDygFMt2ENzq+dpoDyBfx2FT
	9fEOwJ/2omaMNlop1u41foXp1fn9IFH/AP8vuqk+FbbTiNurwF1coOpEcKPAfIXw57N67kUgQ2U
	aktQneG4++ejJObCqka7L3YKff4bc6n+UHqGuy/9kopWiP3KfViVaRoAsnYZMYAraBiFHHypmhv
	VBfyv5OrSY4l7JQ0yQ0tZ83YogRlb5dnmGn8XlwxHlrB9nqQYDGXDez7XROYWgbKuCDQcok1sby
	G9MC4fbEVFqUiqAvV6qlrAxYKenzSAUx/GCqSR2z91urVQQI5tfxmS7ha6NrmfuSQFdu2sPc9iu
	WMi5/bnXEXbuvAZw0V4t+JoQC7I8hGg+/O4a3jYZM6uU+ZnNTyvFMqMLoWjH85xJCCDNsKjKpOO
	OimXK4
X-Received: by 2002:a05:6122:46a2:b0:563:687f:360c with SMTP id 71dfb90a1353d-563a08080a7mr278133e0c.0.1768338131566;
        Tue, 13 Jan 2026 13:02:11 -0800 (PST)
X-Received: by 2002:a05:6122:46a2:b0:563:687f:360c with SMTP id 71dfb90a1353d-563a08080a7mr278104e0c.0.1768338131125;
        Tue, 13 Jan 2026 13:02:11 -0800 (PST)
Received: from [192.168.1.188] (87-92-245-163.rev.dnainternet.fi. [87.92.245.163])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b86ebfd007fsm1126590566b.31.2026.01.13.13.02.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jan 2026 13:02:10 -0800 (PST)
Message-ID: <0919844a-9246-4bdc-979c-115ccc3995c2@oss.qualcomm.com>
Date: Tue, 13 Jan 2026 23:02:07 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drm/msm/dp: Avoid division by zero in
 msm_dp_ctrl_config_msa()
To: Nathan Chancellor <nathan@kernel.org>
Cc: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Rob Clark <robin.clark@oss.qualcomm.com>,
        Dmitry Baryshkov
 <lumag@kernel.org>,
        Abhinav Kumar <abhinav.kumar@linux.dev>,
        Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org, llvm@lists.linux.dev,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>
References: <20260108-drm-msm-dp_ctrl-avoid-zero-div-v1-1-6a8debcb3033@kernel.org>
 <ca851614-2804-4029-9799-19e71dd73414@oss.qualcomm.com>
 <zmfgq5d2gwrxgvr4eh4th2gjef76gpbv54kz2myvfnqgpor4dn@7qjr262yryap>
 <20260113205955.GA2893481@ax162>
Content-Language: en-US
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
In-Reply-To: <20260113205955.GA2893481@ax162>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: DbCliR-7kKN_MEynE_BYBGfSI4wV5mVA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDE3MiBTYWx0ZWRfX+GTBJ1GJ/STa
 vY0hLdutbQbbKyzKFTdgPdijWaBHSW28k4mU8Z5GVqp60bJIGIHjxUQoMawfnrIjFwZ2H4g/3so
 4GTe+cc2DJz91tTTZBcVKQAKkPlH5zt0DN/v3r/jTJrsOfIvX6xb07VKCtUI8/PlqfRyawFx81K
 dbTsGhEqKB4lvnkfZNUUVVs16RH6gE40Cydjdw4xJZPNmGbYoPEo16/N25sJB6wAnpfIS9cGYGL
 BrDJywluSjfXmC85FLN5aRAALZba4aOdwuMj2Np6lHagKbMyvZNi9spaXX+1OPEnPJ0vNdfi2uV
 R9pZYN/ogZX0rLoDjRJjkHzKdi8V5V0IglJmERRcknjT22c1pid/TEKY6F8V9czmf2lhyOsdCsV
 C5O+yD9pDq6GMLxsuxap2xf3EGIH8aDyk7CiTJz7oTe+3+sFZ0/sG3LveXr8M8BgONZv1FF/HQB
 kUrNIgXbOyiUFfs7SDA==
X-Authority-Analysis: v=2.4 cv=TMlIilla c=1 sm=1 tr=0 ts=6966b2d4 cx=c_pps
 a=JIY1xp/sjQ9K5JH4t62bdg==:117 a=+WgfKLcscl3VAWRHYO56eA==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=LpQP-O61AAAA:8
 a=0--PztnLt7rTvDwXMSMA:9 a=QEXdDO2ut3YA:10 a=tNoRWFLymzeba-QzToBc:22
 a=pioyyrs4ZptJ924tMmac:22
X-Proofpoint-GUID: DbCliR-7kKN_MEynE_BYBGfSI4wV5mVA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_04,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0
 clxscore=1015 lowpriorityscore=0 spamscore=0 suspectscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2512120000
 definitions=main-2601130172



On 13/01/2026 22:59, Nathan Chancellor wrote:
> On Mon, Jan 12, 2026 at 04:37:46AM +0200, Dmitry Baryshkov wrote:
>> On Fri, Jan 09, 2026 at 10:06:29AM +0100, Konrad Dybcio wrote:
>>> Dmitry, would it be beneficial to throw an actual error when the rate is
>>> is mangled? i.e.
>>>
>>> diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
>>> index aa2303d0e148..4f710b8e6bc6 100644
>>> --- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
>>> +++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
>>> @@ -2404,9 +2404,9 @@ static int msm_dp_ctrl_link_retrain(struct msm_dp_ctrl_private *ctrl)
>>>          return msm_dp_ctrl_setup_main_link(ctrl, &training_step);
>>>   }
>>>   
>>> -static void msm_dp_ctrl_config_msa(struct msm_dp_ctrl_private *ctrl,
>>> -                              u32 rate, u32 stream_rate_khz,
>>> -                              bool is_ycbcr_420)
>>> +static int msm_dp_ctrl_config_msa(struct msm_dp_ctrl_private *ctrl,
>>> +                                 u32 rate, u32 stream_rate_khz,
>>> +                                 bool is_ycbcr_420)
>>>   {
>>>          u32 pixel_m, pixel_n;
>>>          u32 mvid, nvid, pixel_div = 0, dispcc_input_rate;
>>> @@ -2415,14 +2415,21 @@ static void msm_dp_ctrl_config_msa(struct msm_dp_ctrl_private *ctrl,
>>>          u32 const link_rate_hbr3 = 810000;
>>>          unsigned long den, num;
>>>   
>>> -       if (rate == link_rate_hbr3)
>>> +       switch (rate) {
>>> +       case link_rate_hbr3:
>>>                  pixel_div = 6;
>>> -       else if (rate == 162000 || rate == 270000)
>>> -               pixel_div = 2;
>>> -       else if (rate == link_rate_hbr2)
>>> +               break;
>>> +       case link_rate_hbr2:
>>>                  pixel_div = 4;
>>> -       else
>>> +               break;
>>> +       case 270000:
>>> +       case 162000:
>>> +               pixel_div = 2;
>>> +               break;
>>> +       default:
>>>                  DRM_ERROR("Invalid pixel mux divider\n");
>>> +               return -EINVAL;
>>
>> Well... In the ideal world, we can't end up here, PHY's
>> configure_dp_clocks (or qcom_edp_set_vco_div()) will fail if the link
>> rate is is invalid here. I think, we should return an error here, but
>> there is no need to propagate it further.
>>
>> See the discussion at https://lore.kernel.org/dri-devel/f2ce6ae51c50b0d2e57b905c63b43413@codeaurora.org/
> 
> I interpret that as approving of the above hunk but omitting the hunk
> that modifies msm_dp_ctrl_on_stream(). In that case, what is the point
> of changing the return type of msm_dp_ctrl_config_msa()? Wouldn't the
> below diff have the same exact effect as a smaller change? I don't mind
> rolling this up as a v2.
> 
> Cheers,
> Nathan
> 
> diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
> index aa2303d0e148..d8ea73b89f7c 100644
> --- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
> +++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
> @@ -2409,20 +2409,27 @@ static void msm_dp_ctrl_config_msa(struct msm_dp_ctrl_private *ctrl,
>   			       bool is_ycbcr_420)
>   {
>   	u32 pixel_m, pixel_n;
> -	u32 mvid, nvid, pixel_div = 0, dispcc_input_rate;
> +	u32 mvid, nvid, pixel_div, dispcc_input_rate;
>   	u32 const nvid_fixed = DP_LINK_CONSTANT_N_VALUE;
>   	u32 const link_rate_hbr2 = 540000;
>   	u32 const link_rate_hbr3 = 810000;
>   	unsigned long den, num;
>   
> -	if (rate == link_rate_hbr3)
> +	switch (rate) {
> +	case link_rate_hbr3:
>   		pixel_div = 6;
> -	else if (rate == 162000 || rate == 270000)
> -		pixel_div = 2;
> -	else if (rate == link_rate_hbr2)
> +		break;
> +	case link_rate_hbr2:
>   		pixel_div = 4;
> -	else
> +		break;
> +	case 162000:
> +	case 270000:
> +		pixel_div = 2;
> +		break;
> +	default:
>   		DRM_ERROR("Invalid pixel mux divider\n");
> +		return;

Please add a comment, stating that we can't actually reach it. LGTM 
otherwise.

> +	}
>   
>   	dispcc_input_rate = (rate * 10) / pixel_div;
>   

-- 
With best wishes
Dmitry

