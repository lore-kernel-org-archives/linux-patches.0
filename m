Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A9D23183A
	for <patches@lists.linux.dev>; Thu,  9 Oct 2025 16:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760026091; cv=none; b=BO4ihK1XQ4exVVlNdEXkeBGElp+1x/QyB3RKyeAsYe2lb2KDV3PSRe57vZlToR38hcTUhz/1sID5NZm74MKn+UZnnkTAe63ITo4nTHDBaW3UbTbW3cCpfZKZwHYJYGGGV7OmRHcJ5zI6lE+HvQpWO1cM6qtTKkHqQMO5RLUFDBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760026091; c=relaxed/simple;
	bh=wnjQVG+egmK2IXhzGH82IGBpeDw+1s4hu8UVsW7/sgo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oRUb+PiASa+19IclcCNadXCzR4mzahguyw44via0V4HvCOJ14Y6LNwDJGc1kFs6pJO+vqXS0v6sUGtMg+CKRn3Cr9ARCPukXfXMzX9Y0Qgb2HJB/uQQwLFbZdokuEwZm2d1PLOTU7Jtkgxu+eyq0gkI2SNmD6ilQl9c2oLYtEdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hv+H5D2O; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hv+H5D2O"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 599EfrVo005152
	for <patches@lists.linux.dev>; Thu, 9 Oct 2025 16:08:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jJ9LcKuZ6RaI0QjDWk+WPpGF97bOBxFsnMcVmm6o4g0=; b=hv+H5D2OfGlqf+y9
	/PSpdxaTYKMxoVN4k62FgqHz1rxKKD8aXMnTm/nVgPli+9kzdF44iNUMObioxUbj
	81cbqg9t+GtCxT/kARnXsIFKqQwGytBQHCZfqy0otpD5b+uoUX+uPbywnlDzmk5G
	vw0FOBA6ArmpQ0crQLT9aZnnNypjRA/Wd35s4/CnTjlHoRLMHRlhx3JcTikYmg6y
	DP6wonghk3cJ1loKcHTIWJDFYNHFakUtzQVKr1PTDn2rtQVXGxA3y3mbULJZP+xd
	X+aqo9oerBPPRCgRTORlwaNY9JKoOU0hexPP7SCdAOETGhicUqnfkvO8wPNkdDyS
	jNCbvw==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49nv4u3htc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Thu, 09 Oct 2025 16:08:08 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4dc37a99897so4320931cf.3
        for <patches@lists.linux.dev>; Thu, 09 Oct 2025 09:08:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760026088; x=1760630888;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jJ9LcKuZ6RaI0QjDWk+WPpGF97bOBxFsnMcVmm6o4g0=;
        b=SJBpvxT4mtkBeAeGNPb/qDOrgrX1Czy+PFCLIYSB5+Ruv5IrFFV17bn2b+tzm/2gIN
         e8wFdY3rF/qKPKLu7ochUjqnaDVyfmXbWkuSF6r9qwNxs/KaCg3RZiY9njWoOjY0u/yL
         w+5oCxsFhNMUnRhx0MceIJVvQ8ZjoNkGCXK6Wq5fGuWkLb4p4qKJITzR9GljpgPa9Eqd
         31TynC1Rl4vfUMVlJplD/4M3qeY1oUdBjIfwXVbGwEn6K1Fd3uCjygAnXdNXa0nfwGIz
         33KwZ0aZiWo2kUONUTScbjtWddjIpw6Uo4olPN4j/ApedK/EOJ+JOMh/77VjCY91c7Zw
         HepQ==
X-Forwarded-Encrypted: i=1; AJvYcCUb+320UyixApBqQCI5EeVf9yzIM6dXPmq6QKCT0Wqf/c4Fqmm5NMgH/v0zGxgmosuSFOYrS3Jq@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+wg5FFLRQf+KUtdXGRljE6da9wpceJhkwdJKegz1UHugzQiBy
	6yclAuds1wJfPDH058XpWOvN8vaHedWWnd1RHa3VhSG7ZMeq1Z/F84T4XsgbxKXwDGfq9Mi4T0N
	a7kcduuT1XK76qF/bKnMbRMDFXA6g91O2RViiy9i7LH6Mo7cUYNiFKKgC9gyX
X-Gm-Gg: ASbGncso9rvUluUPc7W2mJ8E0M1DCy5PwE25Hsz4xZnZ1/vw3r7BidbgDqLQc6h+6YC
	EXyiMMTLhO2HC9qx9QoGf1qlfDvdVwfMw8gLWjQ2+/jLOyRTHp2kpHjHn6McNkSACoksYqZBo+p
	h+frRxfbr/DR2Z11bu+bqx7WawymKF1dfVCAOUsuGhDSHVjGvZTO+Ujc4A8gVPRhQJgPjoDS52s
	ZypcbZmm7DfoijP976oj+dcZPVZBH6YgD4ztAetDDItTCQNFClk4LX8jyf/k8PrrYqfNOHxqVJj
	KMvaBk8yeYs/VzrZU3U95Ta+tkcHHyIW3tq2ZSBsDh9UH+3JBdNry+HRJSuebqzHoZZwC+XRplB
	bemP5RpAw52T8wav92xkswL+EdFY=
X-Received: by 2002:ac8:58d2:0:b0:4ab:6e68:1186 with SMTP id d75a77b69052e-4e6eacd4f8cmr74888191cf.2.1760026087638;
        Thu, 09 Oct 2025 09:08:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH2+Z2nuPl0CiMPeaV1ZrBJxe7W45K0/bsiPvQVl/aLb1IdSFCEiGmt6XM4B2I/2P+tfM8wiQ==
X-Received: by 2002:ac8:58d2:0:b0:4ab:6e68:1186 with SMTP id d75a77b69052e-4e6eacd4f8cmr74887731cf.2.1760026087092;
        Thu, 09 Oct 2025 09:08:07 -0700 (PDT)
Received: from [192.168.149.223] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63a52b71503sm86363a12.27.2025.10.09.09.08.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 09:08:06 -0700 (PDT)
Message-ID: <1cd57f5c-d829-4dbd-aac9-b07d0e155e4e@oss.qualcomm.com>
Date: Thu, 9 Oct 2025 18:08:03 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH AUTOSEL 6.17-5.4] pinctrl: qcom: make the pinmuxing strict
To: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
        stable@vger.kernel.org
Cc: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, andersson@kernel.org,
        linux-arm-msm@vger.kernel.org
References: <20251009155752.773732-1-sashal@kernel.org>
 <20251009155752.773732-60-sashal@kernel.org>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20251009155752.773732-60-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=Vrcuwu2n c=1 sm=1 tr=0 ts=68e7dde8 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8
 a=VwQbUJbxAAAA:8 a=FGwjZpymIQ_i5ujK4VkA:9 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: 6RIvTBZbeOy1r22lTlKhrP0wJgWhGlgq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfX0xJrGTxWZK+0
 pFiOeXcBfQcEpawV7AEjTgSeOsCKKC9ECajK5gFWAnVzRJ+utF9do/+Pwwjh5ROXerFBAEY2uml
 L8EQhvC3ChEzyrpSgxzYl4vW+uT95HRn5ev6rXYchhUNaGORvUVxWsNjByWv+ND49rq8CjTC7KF
 cVtYpa/yPpoT/vcaSwwgzCXVsUeKzpaW2ETLarMSnWId/k7oionXUfoFbIJAenGda8LQz3IorRt
 QMoxSVqxxuAn22ed6+e08oRfcrgOmIbqDeIAjhIipMttCBBNnUvTgGaoXUX0ofTr3D+PwnF9U5q
 oIUJLTT2jm0NPqPqAvFA4HDXrUeOPr492ttfaFit6no9p9q+ZeXqnPuGXSpnN0PGg+/r/GvJnRZ
 3D6GYnc8hEZvUBEQaqrpx1ezZospMA==
X-Proofpoint-ORIG-GUID: 6RIvTBZbeOy1r22lTlKhrP0wJgWhGlgq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-09_05,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 impostorscore=0 clxscore=1031 adultscore=0
 bulkscore=0 spamscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510080121

On 10/9/25 5:55 PM, Sasha Levin wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> [ Upstream commit cc85cb96e2e4489826e372cde645b7823c435de0 ]
> 
> The strict flag in struct pinmux_ops disallows the usage of the same pin
> as a GPIO and for another function. Without it, a rouge user-space
> process with enough privileges (or even a buggy driver) can request a
> used pin as GPIO and drive it, potentially confusing devices or even
> crashing the system. Set it globally for all pinctrl-msm users.
> 
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

I didn't receive more related patches, but this had quite some
dependencies (in pinctrl core and individual per-SoC drivers), which I'm
not sure are worth all digging up and resolving conflicts

Konrad
