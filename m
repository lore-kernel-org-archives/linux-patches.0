Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1C9EAE7
	for <patches@lists.linux.dev>; Thu, 17 Apr 2025 03:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744859438; cv=none; b=d+cfbaQE94Nhv4a4LrnyQM1Q1zKtNREYxDsSh1kqmYin+RAMMyoE3gesjskRBstn4i7g6v2f8DAP4Q3N8xu+w15voxCU9V2cO29b3owYVMPqFyHHRWwNMPATvw8W0Q8fx3gjmT4V6MelE2OivYFFCfIC81TSjARVdD+MeiWXR08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744859438; c=relaxed/simple;
	bh=o9y4FA3aNLZbyWWDp7aV1XEs6zzKYLSHjLT7Bv4PQUU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q5DEYHBuJctF9KwtTueIeOGyo8RVkcGnvD8HoUgy5QWOI3ziRLxZeJViNC67pSJZH9dEeYly0EJiHEpddpZikdAddXK3kP0xn0uUEGc26YvsgOm2atqLeiIHSvzPbeCrXc555ZPxsHckBQ7r1JADj4xuxZ8WKTBmb1VOhODOsgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UTfdMA9g; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UTfdMA9g"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53GMCWZC007028
	for <patches@lists.linux.dev>; Thu, 17 Apr 2025 03:10:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	B06cmnmKQ/e4lBuzsfgMOX3tkGNEqZOKRqnJxUEVdDQ=; b=UTfdMA9gYYxNVvnp
	j+VtBxs1trH5eaLlmwBM+bUo93KQ+UuA2hvlz94sf4jKlYyDxg7Mu0C/P2JBe/8w
	XfLrm7tYJ5PAqdHuOtJ7Jse5DVij6Bpe0/ag/G+pCs6rtQw31QP87ZXF3hPpHSkw
	fd3CQ0a0qAXmKIiP9Jo/XlSskr1e61bkY4NdNGuvj/Z2YpUuOjAPn+v/cKKPsHBM
	RozflIWv9DAeH3sITiZf7oGOjnuxe/x/1OC9HyS+VlEmc/kThbc6teX+R1QN8/xH
	fy5ND06gNXH1mOUZPbbPgJb7ShL/cfO0YuLTay/cE2eOhKsXDH+pnyxNcwDlAYpB
	qLah4w==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 45yfgjndxe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Thu, 17 Apr 2025 03:10:35 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-73c09e99069so373000b3a.0
        for <patches@lists.linux.dev>; Wed, 16 Apr 2025 20:10:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744859434; x=1745464234;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B06cmnmKQ/e4lBuzsfgMOX3tkGNEqZOKRqnJxUEVdDQ=;
        b=cH7gdNp5bBhPx6kdxt7iqTQalpnAa3KLdA3KuOkmVLEnlc3QDHiDGVq91HSwzexmL1
         ot5yzjHSIQ2skN9hxoHsNOnjMa0mg6/tw7kQ46hJypng3JuksDSaVAnKW487x+j7jc5i
         Dlsk9Ewk0ijgb1+VnNJf7zodxP19rqj/ovgFoabQPTOq661G+lldigXG6l+ybPstwyPg
         pDjJGBwebFsgpOACfex2qeCMMYdSPcBW/68SUXZjT0plJyzZZZEcu7tzDX2wrjSsAvH/
         fRW61fDh7NbIING/7e5QREVrPo+dES9R0PLrs+HJANOZ6AO+ZWasOkI1RCbxeDyKYEK5
         TkyQ==
X-Gm-Message-State: AOJu0YyK6auTfhB9fHl6rZ8tCwvQMWoSyJugjkczm0NKNvf1YxZ58itD
	kilHiBnsmiOBUjQYwlcbgeUK0D+qyGyi0fOdyJMXZIqP+zFg5m7cdah270QDjdtfh2a10Rqs1Zh
	OPbwQKjCSVfwZQHjmDTEJuyR5MPdYiIpnHFhGhQh8tEUnopu10wOP0Ftd
X-Gm-Gg: ASbGncvdqVhlvlMz5jlSsgC24+LfGqtJd458l6lzyX50IomgzwOMNb5WVMdLVGwnHw5
	ZvgcxGP8rOdaAWgMaGfAHzETznWUirm/ZtM7gY0KURFG93XB80Fa7/iXHmAzAVrK5HLmOsmrhj+
	9FlCUO4HU5ghGPBIZg3XCx0AAr9qgHIDwK9+ZdB1Vr/nOYT6yLpPVJdofBFgBff/t+re0+1A1kw
	DkmLpfQ84kb+ckYei/tEjFLCZhd+mdDnLh4nZUXZ2uG+Uw6euuAIyqd1x+hkBvl1kzZy6Ifrpiw
	VSzPnR9OwSWVtzNawlnYt55Am7l7p0xtcIOfCMU8h+Qd4apJw3KbpBNcuoM2USYbCTjPzl0yyeM
	=
X-Received: by 2002:a05:6a00:aa8d:b0:736:5dc6:a14f with SMTP id d2e1a72fcca58-73c267f5570mr6280116b3a.23.1744859434522;
        Wed, 16 Apr 2025 20:10:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH+DXP8JMSvGrHZjJsmoeGenB3qJ6DAEmao0itPYYQeugkAmnDao/XushMt4kTACYRmrh9dMw==
X-Received: by 2002:a05:6a00:aa8d:b0:736:5dc6:a14f with SMTP id d2e1a72fcca58-73c267f5570mr6280079b3a.23.1744859434064;
        Wed, 16 Apr 2025 20:10:34 -0700 (PDT)
Received: from [10.133.33.156] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73bd230ea65sm11240920b3a.154.2025.04.16.20.10.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Apr 2025 20:10:33 -0700 (PDT)
Message-ID: <bb3248f1-3a7d-4a60-8e3a-68c0595ea50a@oss.qualcomm.com>
Date: Thu, 17 Apr 2025 11:10:30 +0800
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev, Aditya Kumar Singh <quic_adisi@quicinc.com>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Sasha Levin
 <sashal@kernel.org>, quic_bqiang@quicinc.com
References: <20250408104914.247897328@linuxfoundation.org>
 <20250408104916.224926328@linuxfoundation.org>
 <5cd9db3f-4abf-4b66-b401-633508e905ac@kernel.org>
 <49b98882-6a69-48b8-af0c-01f78373d0ef@quicinc.com>
 <4c5f9d38-ae5d-4599-bd9d-785f6eff48f9@oss.qualcomm.com>
 <ff6d7143-33e3-4df5-ada2-df8c99d1993d@kernel.org>
Content-Language: en-US
From: Kang Yang <kang.yang@oss.qualcomm.com>
In-Reply-To: <ff6d7143-33e3-4df5-ada2-df8c99d1993d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: bCECExzkpqAwI25iVVpr_8K2M8HiAOT2
X-Proofpoint-ORIG-GUID: bCECExzkpqAwI25iVVpr_8K2M8HiAOT2
X-Authority-Analysis: v=2.4 cv=Cve/cm4D c=1 sm=1 tr=0 ts=6800712c cx=c_pps a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=COk6AnOGAAAA:8 a=71oygjJcY_BwH7B_oqQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-17_01,2025-04-15_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 malwarescore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
 priorityscore=1501 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2504170023


On 4/16/2025 4:03 PM, Jiri Slaby wrote:
> On 16. 04. 25, 9:31, Kang Yang wrote:
>>>> Ah, what about:
>>>> commit 02aae8e2f957adc1b15b6b8055316f8a154ac3f5
>>>> Author: Wen Gong <quic_wgong@quicinc.com>
>>>> Date:   Fri Jan 17 14:17:37 2025 +0800
>>>>
>>>>      wifi: ath11k: update channel list in worker when wait flag is set
>>>>
>>>> ?
>>>
>>>
>>> Yes, please add this patch. It will minimize the occupation time of 
>>> rtnl_lock.
>>>
>>> You can retry and check if this warning will show again.
>>>
>>>
>>
>> Hi, Jiri, Greg:
>>
>>      Have you added this patch and verified it?
>
> Yes, it works for me for a couple of days already.


Got it. So do you know when they will backport this patch into 6.14?

Do we need to do something?




