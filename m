Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9FB277017
	for <patches@lists.linux.dev>; Tue, 30 Sep 2025 19:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759259652; cv=none; b=nmSEYZ7ELuwgYLmqMdrfJ9d7McQrS8amMTDlQZRiXsh4oXDdHKZn9VpanXiS8AKQvqVuA5xj3a3f4l3ayh83LgFx6XLeXhAJoGER70lv6AAnAGm9ZNPQKXDS/nXFzKP0Fj6+c82wCf0XheH8RPZjaehO+bHNd2VO0zzw8ZLzovQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759259652; c=relaxed/simple;
	bh=PawSnYt8WmMj8SZdGcAwqC+TWH/Zc85+nywQIoFiozQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RdrAHubzZfWikts1foEIjskpLRpueZ+8Na+Yronr4LwLPT6wFAGnOdeUBZuK17fx5G6gaXxLb2aq5Keo/HRNDo2PtylOf+3yrZxqQUMdZcPE6dzUcNSNNqrA7fl7lrTsx+ECaq0RfHF9YQsXCGhZoTbuCISwR2RtdiAsDrHGKyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=lN1CLLIy; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="lN1CLLIy"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58UCQOX1027330
	for <patches@lists.linux.dev>; Tue, 30 Sep 2025 19:14:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=goYALe8rxnHCGdz+Re2W+Iqv
	KOXN11Rt4Lm5Gbd0TUY=; b=lN1CLLIyEBzJH2h//vLM/tnqcyL/ZTqyB8jJGtz+
	nKuSzGK8gPGsen3+t8npQOsros3KwkhLFekmnHgCT94weutkC3wlwz8Rn5zucHFK
	tvALcGzJ/YeuVG+8J5C6j7KttZb8iDMf06eW766+vFsSno5mL7z2cfOCCSrRK8gX
	uba+ufvKMHQbvb6elYfGG5vnRijU+GLrdzhuzKh1qmZf7ueCGTwNpBjR12UI0h9U
	Le9jNSfn2tInM6VTQ8o8w8vUenQwzfH8CW1dGOXIHSHiANiK6NDqBzmpgmTzl5IU
	lOu2lfdFfVFfQPlhJAC0gS3AJt1lXxJ7Jn9b/iFM/RsNfA==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49fyrf3ryp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Tue, 30 Sep 2025 19:14:09 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4db75c7fa8dso148700571cf.0
        for <patches@lists.linux.dev>; Tue, 30 Sep 2025 12:14:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759259649; x=1759864449;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=goYALe8rxnHCGdz+Re2W+IqvKOXN11Rt4Lm5Gbd0TUY=;
        b=V6FC67Zyhj7y56GFZOCsQj/vC1bT8SLsK7olmRxaSKH0FMD/PZu5tMuer6RtPvxY56
         gZ+5v6iEPYB8AM+le3QNbsHgNFXTvoUCurUxJpn800VlWOV6Xkl+2o3lqCgsW1PT0Qe2
         YCBAjvb9UzQMrdiNv3MP1rayfmN31czdukuq/MZlGz9tJt4+gtQj515BwVhdmid9x89N
         jZ87C0KC1rI5+KC4mAHitWX1TiLbjejks+8lQDRt516EOw2V476zJE9D6dNMGo0LReje
         E7AhcawTEaCUa9k0FfHPx3QodP4cJTnQli3EGbQLjM2PuTg1Htn++OW1endKrgz0Mzh8
         4BcA==
X-Forwarded-Encrypted: i=1; AJvYcCXtSujk7884ld1Dd/PleX0JpIWLaI5Su1CsF2OF2WpCM8mQ0u84hn52xfSeX7tVCKkWgIvf66f0@lists.linux.dev
X-Gm-Message-State: AOJu0YwnprvV5OfqA7xIxXAr02s92iuSWmUsypcxaueVQTh+d6FkeSwU
	32SFwLUeYo5P1LMe68pmqRGcn8i6+4X3kPo0P3pkj9oilOV6alDRO/Q5QrdkfHG3K1374FKOVK4
	FQ4CGqvjyM9cp/1WKyCb/5+J7lP2thTArlh+HH5Ul8yjnj90lJIozOIjiJU0Ph80jYMdbXAo=
X-Gm-Gg: ASbGncuElvfnM8OAvV0ttwkcfFYjGmR+k3pTz/VQFBKyi63hBIkNBzLnEtxLNYM1Weu
	9muqqJi9urlVs9sucBzF01NPJ3t7fpywtwqQeI/EzYFPbtDxFqEuKdGRVomyswA59w1ZRIbEWYy
	P47nKZAEpOrNzAug6YKcEAxSwAQXiaEUAqaP+Z5QzsS+h4OtUaE2Zgiw6IKsOt4cjrmk+qpElFz
	F2ZRJ0KmvSPH5id72DrZ7VHkNY47HwvKQ+r/qjFUwiI49UcDfAWDwldqkbCJhf/UmjmwNpmy9fb
	CQ9ahjOrnEyei/kGcyMHN9ZXDcDYp7bJnjnxgoXtJXSfbGUQLsQCH0WQWW8GChJfy2yPcVnSguZ
	rQQIndqTY6SxwgRUUu+DC5Eh0WyasQYWXeWPgOe/X/ppi5EpL9Ko56y60qQ==
X-Received: by 2002:a05:622a:5a09:b0:4b7:9171:7b10 with SMTP id d75a77b69052e-4e41eef7075mr9963041cf.64.1759259648948;
        Tue, 30 Sep 2025 12:14:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHWaNA0ZDNYeL9wcUtcyeSgm1Kjom+qbg+3Fbj0RuE8VjgW7lsTtOWKRJ0PJ7Wa9FP7+7IEvQ==
X-Received: by 2002:a05:622a:5a09:b0:4b7:9171:7b10 with SMTP id d75a77b69052e-4e41eef7075mr9962581cf.64.1759259648498;
        Tue, 30 Sep 2025 12:14:08 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a0c3-3a00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a0c3:3a00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5879e9b81d7sm2043093e87.128.2025.09.30.12.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 12:14:07 -0700 (PDT)
Date: Tue, 30 Sep 2025 22:14:05 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, Taniya Das <quic_tdas@quicinc.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        patches@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] clk: qcom: Fix SM_VIDEOCC_6350 dependencies
Message-ID: <manv5cazdhashfkduondlikqn4ut6q53dhjhyepu34tszrdsfx@bmnjqsrtcf6n>
References: <20250930-clk-qcom-kconfig-fixes-arm-v1-0-15ae1ae9ec9f@kernel.org>
 <20250930-clk-qcom-kconfig-fixes-arm-v1-1-15ae1ae9ec9f@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250930-clk-qcom-kconfig-fixes-arm-v1-1-15ae1ae9ec9f@kernel.org>
X-Proofpoint-ORIG-GUID: SZcqeek4osLstCNhAzmC-UQ0T7wDN7hT
X-Proofpoint-GUID: SZcqeek4osLstCNhAzmC-UQ0T7wDN7hT
X-Authority-Analysis: v=2.4 cv=etzSD4pX c=1 sm=1 tr=0 ts=68dc2c01 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=EUspDBNiAAAA:8 a=YvO9g5Z2dZ-zDM10cScA:9 a=CjuIK1q_8ugA:10
 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI5MDE3NSBTYWx0ZWRfX07RqunySCxdu
 wJ4hfq74wFZChb1gWqXnnBAECg2TIqnLrTOCdR7i3Eq3K+sQubnyvHPu4fc9j8VyRZdv8dzH0gx
 6MEMH5ND9A49NOPQRcQfqwevfJT3ZO6CGmUDaFFWSOf7ydB23yb772FFRnFP3sIInMQ9WdcvMdd
 T95OJqBafKyvhZJaISxg/dkQhI9WesxMOYB+UtIwDkhtb3N+SAFqP4Pso1ipMRJlhuwSc/nREzm
 h19JMnWJpRqBwxLnC4BOSU/nirP767uxyCZJTYjWvV2AJY5CgOV5R2uTDvHZVJb7YIIt3juStKn
 SlqQX3RRwhH2IwMKzY8NOyvohmej/VFZa5IyIdR/dNuxIDOyzw19H/DpFvOvkx89BIrcfJ1Z4Ds
 9a+STkAxUFc8n/EasffVDu3FAmmlGA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-30_04,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509290175

On Tue, Sep 30, 2025 at 11:56:08AM -0700, Nathan Chancellor wrote:
> It is possible to select CONFIG_SM_GCC_6350 when targeting ARCH=arm,
> causing a Kconfig warning when selecting CONFIG_SM_GCC_6350 without
> its dependencies, CONFIG_ARM64 or CONFIG_COMPILE_TEST.
> 
>   WARNING: unmet direct dependencies detected for SM_GCC_6350
>     Depends on [n]: COMMON_CLK [=y] && COMMON_CLK_QCOM [=m] && (ARM64 || COMPILE_TEST [=n])
>     Selected by [m]:
>     - SM_VIDEOCC_6350 [=m] && COMMON_CLK [=y] && COMMON_CLK_QCOM [=m]
> 
> Add the same dependency to clear up the warning.
> 

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>


-- 
With best wishes
Dmitry
