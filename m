Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB961A8F97
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 07:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759302223; cv=none; b=Wxk6LsMtXPfclJ/F6Gy7DtM8Z+wwZzZOF0VSXQs2p7EA5zAG89zqB8tCO/vxGghzqAlel+LqOsYVGqUeb4lSDYTCm5aAutcZpGwuF9PSTvAXS5ct9631nb1SYLDjTFtr3SFsFFu43Ji6zosm4fYzJ3zZdw60YYNopsMbWm1d3eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759302223; c=relaxed/simple;
	bh=4bLqWv0MA1lGdWx51FlMH1Tx6y0z0yBtkAGpBUXY+LE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C3VRXIvyFmEsEoTS7R+MnB/iEWN8pwfqAyyKjCUTI4Bu5/bLGLOGBgt1Y/erxrwmrCMe6emaNTG3tqFyWXuIpRXGhiohsSJ97fJubaFqlrkxTihpPyXiqBFGx9+Udt924aQEgg6VyZh0B8VayHE6bbGPNDp5rqJNuPmpV54sXzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JXFWvd3d; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JXFWvd3d"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58ULj7Pj015464
	for <patches@lists.linux.dev>; Wed, 1 Oct 2025 07:03:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+XxcaZX2taq9qV4nbICxRulbIsspEUNYK0zzuhWUhKI=; b=JXFWvd3d+3uTuOmA
	4a6s4Cs/hDMd0qUUjLAsWeOf2W6m5mmWJgFGTrqPXZmrZ0wQCOkwLRDh2Pt2RPsv
	E1dUL6YbLqk84VSGhpEU0tvfQVrQfNVw1e78H+R70W94RQwtb5Y9wxvv1xi9a0v5
	QOQecuHZZxoHpw+DlzfR0Pd2heuPRB9zBySSZBB94wZ/kYgdjgIycGwCba+vopJw
	cWgXPCQU5WuVl/e6n6bYW4Guqq3T83X00eAS5N22b7lEqle2NeGCaVT6fygMShU3
	eGE7dl3iP0lH0rRxQDrm3LrF0SoPNuOsik8ZQ7baCcWWx32jBzcSI+7hmiWq4Lhx
	889oRA==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49e6vr3n06-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Wed, 01 Oct 2025 07:03:41 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-77f2466eeb5so6133764b3a.2
        for <patches@lists.linux.dev>; Wed, 01 Oct 2025 00:03:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759302221; x=1759907021;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+XxcaZX2taq9qV4nbICxRulbIsspEUNYK0zzuhWUhKI=;
        b=X5OwGdlGnopcAeUqwIVZ/GhYs4wR6XKvIo6FP/wQYQapPJ6arPo+nYm9TvEDpBwNvg
         d8dkZyp16v4qhFkRVsJRHIcQOJf297FRlne/QoRu6yK4+8opL9/0IThzCXBPS1xsJEsw
         NH8edvdYopLz3GHCSISIbbKXRVdB64LnNjwC4qlFNI6owf6KFnBzuKl5RX7uqa/tH/gL
         QEFZR2w5WnydB2+aJZJHuAoKMgABuszIpgvnMA70rA/B+lKcktvioCm4aQGHvHz6I0i9
         jHGiVi5FN5kYw3K3Vic9gGBywY8aKB/Js8sUtNc8pW7HEYJAh61WSZ6WSHXa73z4S3tD
         Q1Hg==
X-Forwarded-Encrypted: i=1; AJvYcCVQfK/u/NeqmnhmL82P4FZlG0yGpsSOyQ9RaIPXljOyVVeaqkTT+IxmU9jB6Cj5up40ZUUhAlPW@lists.linux.dev
X-Gm-Message-State: AOJu0Yx6W5TWIj9ekApXNUkLrxcC8LPWIOFFxh5vbmTMXqYOWOQmlbhA
	Qjx5donbLYbOBqZ74Gx+tiepmvG98ZwuiBY2zU23AkWa6T+P9GrAoksUbDSIx7AEzGfLR411Yer
	FJFJffscSzC+nwVLGEfaU3egLGMGcM29c9OhvMwTgyLpBkG07GhNsYQfFy8bX
X-Gm-Gg: ASbGncsjPmAnEEwSDtorBlqDa9kpFBZkMdKc6n4Tpp4RW39bQVzf2Gqo0QtjPGhq/6E
	oZD58koiPk3A8hOA/H580ccgnHzSMpcUiDCk7O8DdmJHDf2MYGxu5dL1/8vUY5jhEmPdCCO0Ykx
	lOKdGRgbLRnZssSaq7zs7gprb/LElvNFiWEuBsZHwXKcywPJJx74WoED++zdCyQwxeiQj7Tjnrh
	GMj+Hw/yiU24tD5w+7BJIMzZEM8ACK1Ib9GQ78EoN1OXy7kkioeq8YY9AxE5wDtT1naZjIF0V3K
	Pn8ymTdVKrtmuZOHPFE4AP5elIIZlmGIJO32qGAVXcemksTGRxjv+GZsxjB/Ad4VmsKzC9hx
X-Received: by 2002:a05:6a00:23cc:b0:76e:885a:c332 with SMTP id d2e1a72fcca58-78af41d3f6dmr2859544b3a.32.1759302220561;
        Wed, 01 Oct 2025 00:03:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGcl451PK1NkVZh3OLUUPJtnf8fNN5lOQqjF+yrOzMLlH+aNHUtU9sxDhsiuCyHZkM54X0sUg==
X-Received: by 2002:a05:6a00:23cc:b0:76e:885a:c332 with SMTP id d2e1a72fcca58-78af41d3f6dmr2859475b3a.32.1759302219829;
        Wed, 01 Oct 2025 00:03:39 -0700 (PDT)
Received: from [10.218.33.29] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7810238e9a9sm15587378b3a.15.2025.10.01.00.03.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 00:03:39 -0700 (PDT)
Message-ID: <9bfa3478-00b5-49f6-a808-7d60de5d2f39@oss.qualcomm.com>
Date: Wed, 1 Oct 2025 12:33:03 +0530
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] clk: qcom: Fix SM_VIDEOCC_6350 dependencies
To: Nathan Chancellor <nathan@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd
 <sboyd@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Taniya Das <quic_tdas@quicinc.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        patches@lists.linux.dev, stable@vger.kernel.org
References: <20250930-clk-qcom-kconfig-fixes-arm-v1-0-15ae1ae9ec9f@kernel.org>
 <20250930-clk-qcom-kconfig-fixes-arm-v1-1-15ae1ae9ec9f@kernel.org>
Content-Language: en-US
From: Imran Shaik <imran.shaik@oss.qualcomm.com>
In-Reply-To: <20250930-clk-qcom-kconfig-fixes-arm-v1-1-15ae1ae9ec9f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: vx2ncFEs3SwbG9NrEhOQw-bzRnqBpYJn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI3MDAxNyBTYWx0ZWRfX58dBsw5ONL9z
 Fmvv3AnQpu1ArpcDvEIYziaPridAU9+IWOIwLP6zHWj3FaZ1wNi2x5odBn1LvJm93EJ+384fE7B
 dZJk0E1bly/vZb1rQALiI7i9GsdP4ryNkRmc1umVBM5wrUnULYWH69eYEIgEEcc0R2hiCOMymMR
 GyanCS7Ovh66c0R04VPMVYUtY10erVueQRDWL9dyCiNIcROuF4hZXo4tACb7XQ3nrlkrPITqp+t
 lpwi29qWZBe4hNUqAMnEjQs2G75t7SuBGd07qLskW7Xs7sQLnjvL2yO6acogefAM/d5wgk46U3l
 hp8E7bXC6drG/S2uUJlE9Snwx9SwdXCUv3NWIcwWdXtMP8Ark6hNLFKzF3ousHO/Lf8wg5JzqX2
 qC5elTfkbvXMG4jRUendwZEQ+MMLUQ==
X-Authority-Analysis: v=2.4 cv=IeiKmGqa c=1 sm=1 tr=0 ts=68dcd24d cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=oRYDs8KJhtz7EUiVKSMA:9 a=QEXdDO2ut3YA:10 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-ORIG-GUID: vx2ncFEs3SwbG9NrEhOQw-bzRnqBpYJn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-01_01,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1011 priorityscore=1501 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 impostorscore=0 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2509150000
 definitions=main-2509270017



On 10/1/2025 12:26 AM, Nathan Chancellor wrote:
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
> Cc: stable@vger.kernel.org
> Fixes: 720b1e8f2004 ("clk: qcom: Add video clock controller driver for SM6350")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/clk/qcom/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/clk/qcom/Kconfig b/drivers/clk/qcom/Kconfig
> index 78a303842613..ec7d1a9b578e 100644
> --- a/drivers/clk/qcom/Kconfig
> +++ b/drivers/clk/qcom/Kconfig
> @@ -1448,6 +1448,7 @@ config SA_VIDEOCC_8775P
>  
>  config SM_VIDEOCC_6350
>  	tristate "SM6350 Video Clock Controller"
> +	depends on ARM64 || COMPILE_TEST
>  	select SM_GCC_6350
>  	select QCOM_GDSC
>  	help
> 

Reviewed-by: Imran Shaik <imran.shaik@oss.qualcomm.com>

Thanks,
Imran

