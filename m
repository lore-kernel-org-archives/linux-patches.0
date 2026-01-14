Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0251A08AF
	for <patches@lists.linux.dev>; Wed, 14 Jan 2026 01:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768352553; cv=none; b=YtnD/Exgn8tPDx9KZbkPxF7fR6f9VB1BmNAiHBgoJk3zP2mwt5degFWJyf7GBfZ6Y8K/xyjXpCQXOYpxhH9cQ4CWh42uIhy43XSN/Edas4X7zskrA4AgaChmgkd0PG+nIkLVh0d+24E+H3BDlhOe/dot10sGcTPgjkuDuytBEZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768352553; c=relaxed/simple;
	bh=eqdnrf0xiCNvd5DPFiMQi8C1gxRwJUjfMbU2g7qs8Hk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lxslZC10vAaSMTQfk6zmKdoE9rC8wtdVkcGpOPXxp/z0nILeUwBrKFhgEOSQYWNeDiyu36yN0T9Oq92xd4+8wxm60yaRByYdnZjRpeesm1xN71QnjGlniHrCrBg6NWdeC9g6ulvMFKr7Jv60Lk1imF33B5ymtSfiyblFFquFaxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VD9yqTFR; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=j/uu0uYm; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VD9yqTFR";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="j/uu0uYm"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60DNHlVQ1286231
	for <patches@lists.linux.dev>; Wed, 14 Jan 2026 01:02:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=h18ZqtLLvGt/Pa+wG27Y9TqJ
	rGVZgx2iCCkSzGerT+0=; b=VD9yqTFR4gXnt3n/FZpIJQX4gpBL0ktXG9WZhk4I
	yY4RP+jB+88nfH8GbeMS3CYOmrUAGd6f5r6QDFSKo2QJYbxcAzDy2ncylVXPV5Ai
	Bi5HQfHbT4B2zCMSiD9oNI4P+c5fWJYNmHsgEAr7S2+a0c7vaom+JUfPR8YzKGm5
	HQiTvZaoRfw7JD0d/eXnVqh2iqtwxGqyXuxrhF4uyMZxtkxXiKFO43FHJ9eWLGiU
	AkNKR3aAdeux3ByK5/j4R1deWK9zdYewlq58tzEOHwMVkOSxFKtMZoYcORTJsws6
	ZVcSNJhWeNIr/jZJkmrAALiSwD0RyK5O7/6RQpgDtHNJAw==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bnm0dtnc8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Wed, 14 Jan 2026 01:02:31 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8c2a3a614b5so95602585a.0
        for <patches@lists.linux.dev>; Tue, 13 Jan 2026 17:02:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1768352550; x=1768957350; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=h18ZqtLLvGt/Pa+wG27Y9TqJrGVZgx2iCCkSzGerT+0=;
        b=j/uu0uYmBiYJ7rIo+rMzTCghoP8kAaUa1GisYMm7qATmFi9wPoCcEAEU4PuPZ5aMHa
         v2bUAByetbKvmGVpsimwTRm9SW63OJCdI5A27J4r8pvuj6NqKyc8QSnSE8t09eweHc9k
         1oRGDkPyfrRJlrqLpymcMK7jvm6r39ze383BYgUWGUePB8Es+1z2lBv6EZW3/bdE77yV
         kKutAJcZMQAIXbEl//fY0X1kEtLoLoQPh2isofIrT9j6epzN4NjPkId7AxuMoJzP4ujh
         44eO+X2jBDUcTUGlvlHQhcAqSeB6Z1Qm+gHoCbYday8+OMd65mhIXwOCtatG7OmfK8e0
         ElXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768352550; x=1768957350;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h18ZqtLLvGt/Pa+wG27Y9TqJrGVZgx2iCCkSzGerT+0=;
        b=CGNKoi6rWXPqjpxx3hS2ouFuJqIOH2+VF5pwSrbsVfovtbU+fxgOkkYvYezAxWpF9m
         LKG+9c/wbk08PhtbxaPs57ORPryNY5AlBbmcU1J4tJtNj/Zt0x/VOJQRJuLi15JVRQi0
         O8HseV5wyeIWFstPtXg/ObIFTWukTmcAm3Vrt2p5DSjYW3g9Ti1YoN2zVQ3JqpcfZQNA
         3UsGexoSVXIHLDeUcQKQdsw0/FTDqKw+79w2OMpBSj3jzXeZ938BkChibQrj3OtZbyuD
         T45PSusijS/tASqm16DzMGbkVbTXVjfK48SgJNhztsuhFdK35e3GkV/FpcA7T929BJpx
         9p/g==
X-Forwarded-Encrypted: i=1; AJvYcCUXgTipiVjMN9qEwL7KwP3rXx9qv0kxWl1NC6FL1G2jwJCDT2WDweDxj2et2gr4kMnINbXE0uBP@lists.linux.dev
X-Gm-Message-State: AOJu0YyJqiwky8uWxD7TNJU1OYhv8m8iY9EsmG9B4S7jkEr4p+jFPKIs
	HqZI5OHwO6MgjiuEtp0huqu3T7EVy83pCW2fX4b4UraJX1JzbhbcSnkQKbu9v4wG0OPAM6Ou/0W
	GaKTqCKM1BsIeaMYKibwb2Q6zDz2R/zKra7F9y3/zzqQHAV4+5lbtpl6N2VSE
X-Gm-Gg: AY/fxX6WL1WLfv4c5UbTqrRCcu1T2t2/7p0XWFnCk7E0ZVyVLcTU+Ib7JLxANG8D5db
	pYQ3oTffaDKRCZ610lIdaHR5Gcv9XzNeo9uJmpxQK36f5vFtE4A/24qNutSAkZT7JMNx+tt5/Ze
	9nFs7rQnphgs8P9zfaL05KmZtYI9oWLt4bAmt1HNzvc0luQDsauh9KLpENcRtP+swLGfHo1/wx0
	L9j5gf5g2D/FtCyOTB5TVWpwiulooIV82bm7KVIYea6OPOgOQ6fsjjC16DAHVtCCsd+cKzkLjbT
	5G/YtmlIEz6UGJ7Y7XBbTjAWHmJu85y8nkMD2AjoMjE1/wHwKUflPHRwYEb+OtgzlWidjrnAcs0
	Z96XnehT/7MwrxpGxt/EYsxjosLA9FRjCkeUL+/dt7Ma3DqiLnqkrrBshpupH0Pj6xoRSI6Dw5g
	V03vlHhiPRugaCm5dt0YFgpnw=
X-Received: by 2002:a05:620a:31a6:b0:8a2:595f:657 with SMTP id af79cd13be357-8c5208a4cc6mr654200985a.21.1768352550522;
        Tue, 13 Jan 2026 17:02:30 -0800 (PST)
X-Received: by 2002:a05:620a:31a6:b0:8a2:595f:657 with SMTP id af79cd13be357-8c5208a4cc6mr654194785a.21.1768352549807;
        Tue, 13 Jan 2026 17:02:29 -0800 (PST)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-382eb7b464fsm48970681fa.20.2026.01.13.17.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 17:02:27 -0800 (PST)
Date: Wed, 14 Jan 2026 03:02:24 +0200
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Rob Clark <robin.clark@oss.qualcomm.com>,
        Dmitry Baryshkov <lumag@kernel.org>,
        Abhinav Kumar <abhinav.kumar@linux.dev>,
        Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org, llvm@lists.linux.dev,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v2] drm/msm/dp: Avoid division by zero in
 msm_dp_ctrl_config_msa()
Message-ID: <5e64ih6c4abydpjto2asvd2dev2bu3wlqp7rbryr75vzcf4ubo@ky6t7rkbf6wr>
References: <20260113-drm-msm-dp_ctrl-avoid-zero-div-v2-1-f1aa67bf6e8e@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113-drm-msm-dp_ctrl-avoid-zero-div-v2-1-f1aa67bf6e8e@kernel.org>
X-Authority-Analysis: v=2.4 cv=BYXVE7t2 c=1 sm=1 tr=0 ts=6966eb27 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=bC-a23v3AAAA:8
 a=EUspDBNiAAAA:8 a=oHda18c8P31K-R3mfaIA:9 a=CjuIK1q_8ugA:10
 a=IoWCM6iH3mJn3m4BftBB:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-ORIG-GUID: ur7c_kgmU-xc_QBndet1aBWtqqq7scr8
X-Proofpoint-GUID: ur7c_kgmU-xc_QBndet1aBWtqqq7scr8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDAwNCBTYWx0ZWRfXx/PhRHKGXSXN
 6mvbsca4UILGLp+xa81e9uoiqBQxj5vBuBoXSZK2ntHbxQ3aeI94VaelrKF0KC82JsKinHB7JGd
 Gzl5xK6VUJF2xiEVlNRH6dFzjHAqA1btN9AAE+zHWf1vDwoq6ZePqHj1j/1J6fVj8BtfvfVOJi3
 Fb9YZaeaGvK7ewD+y88GodeGd5K63VvH+HForbZIOnc6KMkaPOrM00Ob3lKnJInpnUAWsJPKWzN
 xfNmBUG3p+RY0fEnjVGPNkw03/XaeMAXx18mdeDdRXZyV+T9mq9tKpLvABs2/BgiDXpP7VNxkvQ
 afpdGIJymkr+D5exq26BZl2mrJ+WvE2q5+jtOrB6xVi0n+cC6VAtE4JaN13Jwuukx5WGxZhABWz
 xcMCIhFB8QurcwW08Y+PsGASo/9DczRnP6HFvH0dZMOCVAaqbIwxWt/gFaYo0paJsoISp6h2bMl
 eRM/e1/QQfkXy1drBrw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_04,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 impostorscore=0
 spamscore=0 malwarescore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601140004

On Tue, Jan 13, 2026 at 05:00:31PM -0700, Nathan Chancellor wrote:
> An (admittedly problematic) optimization change in LLVM 20 [1] turns
> known division by zero into the equivalent of __builtin_unreachable(),
> which invokes undefined behavior if it is encountered in a control flow
> graph, destroying code generation. When compile testing for x86_64,
> objtool flags an instance of this optimization triggering in
> msm_dp_ctrl_config_msa(), inlined into msm_dp_ctrl_on_stream():
> 
>   drivers/gpu/drm/msm/msm.o: warning: objtool: msm_dp_ctrl_on_stream(): unexpected end of section .text.msm_dp_ctrl_on_stream
> 
> The zero division happens if the else branch in the first if statement
> in msm_dp_ctrl_config_msa() is taken because pixel_div is initialized to
> zero and it is not possible for LLVM to eliminate the else branch since
> rate is still not known after inlining into msm_dp_ctrl_on_stream().
> 
> Transform the if statements into a switch statement with a default case
> with the existing error print and an early return to avoid the invalid
> division. Add a comment to note this helps the compiler, even though the
> case is known to be unreachable. With this, pixel_dev's default zero
> initialization can be dropped, as it is dead with this change.
> 
> Fixes: c943b4948b58 ("drm/msm/dp: add displayPort driver support")
> Link: https://github.com/llvm/llvm-project/commit/37932643abab699e8bb1def08b7eb4eae7ff1448 [1]
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202601081959.9UVJEOfP-lkp@intel.com/
> Suggested-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> Changes in v2:
> - Transform existing if statement structure into a switch case with a
>   default case that early returns, avoiding the invalid division
>   (Konrad, Dmitry). Add a commment about the reachability of the default
>   case.
> - Drop the default zero initialization of pixel_div, as it is no longer
>   used due to the new switch statement.
> - Link to v1: https://patch.msgid.link/20260108-drm-msm-dp_ctrl-avoid-zero-div-v1-1-6a8debcb3033@kernel.org
> ---
>  drivers/gpu/drm/msm/dp/dp_ctrl.c | 24 ++++++++++++++++++------
>  1 file changed, 18 insertions(+), 6 deletions(-)
> 

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>


-- 
With best wishes
Dmitry
