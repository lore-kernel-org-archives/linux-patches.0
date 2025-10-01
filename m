Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698DB1C861E
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 07:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759302276; cv=none; b=BsFZ4nLoJ/M7LENzXCdemozQfwCZW6i4vxKVLpioIV0MQb7C0Nc02I3EDYnuKF2P7G2t43R+oDv8iNZkH7kkex5HEjFzU9w4nwZeGmE/b8ZY7SvfBmheF7yuHfk77zXWme5gr4BR8teiO4B3Q5h5xcLYx2nlSYkfUdAcLL3DO04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759302276; c=relaxed/simple;
	bh=We2BKF/GHnXH5YX/6E9v5kprJ6brDvpihZaj/zsbNOk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QlzPNMKXfpbKCuA2jTjM5j2RzMmHIN7yWTRWOoYcfWZuBrjIRSzJAVT9CXYgsux+bHuWhGTUMoaRRubbjO3bT2XEe28pzEBIXrhqU6z3weDLZJN2n3LsjIgVe4qoxt82xCvlpRJZCiXKfde0Rw6ioA6XPlKz2m2b+5+PNtbrxHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NUL7WSz8; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NUL7WSz8"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58UMI7tm032518
	for <patches@lists.linux.dev>; Wed, 1 Oct 2025 07:04:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rajT27AwFunrMNV7n/DU+VYrepqPJvpfTRDT7Uk8rjA=; b=NUL7WSz8Lq0J2Yug
	iwphD+paud8YRd/GQRn/PNIrIY8X54TBs0eq29v9iHTUJkzpL04BQqWpRhZu/3wd
	py3S09QvkmwZQpuQE6vOI76HWMZrLKJdqEdrPKKvliTdlplwHppaTzNCsUCQtEMK
	NGKkKau+Oyc7jxRqU6b+U4OY/TvR2zVrpyuIabqyb9Q7UgodAQ3G0mad+zl32/TO
	IujM2q5oaGekfT1RUXPDf4ZL9wmNQKwsvRyx/wm3T6C3nv79fpMsR+Gqm3QnbALQ
	tb9+YNE00NRWCkdPtWLYIwW1+Wpb5pJOtzFn+CFp837ax8kCK0NSnxjxSOKmGPPE
	nNU2iQ==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49fppr74wm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Wed, 01 Oct 2025 07:04:33 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2711a55da20so54168755ad.1
        for <patches@lists.linux.dev>; Wed, 01 Oct 2025 00:04:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759302272; x=1759907072;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rajT27AwFunrMNV7n/DU+VYrepqPJvpfTRDT7Uk8rjA=;
        b=Ighrxys/0jgUF/jO4qArHB8NVoCQLM0P0KZXTjSkc2H4FUhqfdfWW0fpW8NYfIab8v
         jMa6L5kRy++HW4wAfGermaqm+Dr5Fi/PiaovaOoiKFzSdAvbiGkwH3xi39J3OgB85KA3
         qgSwK5qEpHFAVdzURYg1mVftLRvCgoNP8dgjPC5FmyYyvilIaNfbMVJf8OxS/QQCWEcO
         cNzpp5yBdCXWyHJYIQiLprcJ7yFYhHrpR17tKiPVIYdsigVzjYZGHP/rTyEqJtyvP4Wj
         DF5eJq3Gv6zUjSRMvFZx2GAZKnzY87dS4TtArSMpsYj5D5UjG/X1TAkj4xXukL7Z0/Y+
         0Fdw==
X-Forwarded-Encrypted: i=1; AJvYcCWPraiSd8tP3ezjdAA2vnv7zQCZo3gzWIUJbvqqNvSVEuTSZgfOfaYKoYKWh84VnQjLNVg8TkaU@lists.linux.dev
X-Gm-Message-State: AOJu0YztBlPs6RfWqJUdqmVishaBtZ+oRjxvD6dhZQ3GCnrJ1sV/vBpm
	KsjnnJ68lA1x0JtPCNhXaH3zwoo8LAlUv2kyv3CC+/WcvPxEy4BtzSjCOJtVk5nZbK3Ufnq32d7
	PBCTJA1+3lgb5RlzskbVcLu4LsN2WwyjHipZVdMxuxR/FuSzo38o02npOMw0J
X-Gm-Gg: ASbGncvO6J1zekK631L2MC7wfc879dlHTyG2FKqKYeEuuGDEJpB0XdqgdKMAuvqfPiQ
	m3CSXlenXGtpGAKjIGI5/OmwvC/1Va5iLgCgZJgtVNt9DBMr8kl2N6lM4jIbuASr7L+l9BK/OT6
	BdZbMNIDA2S0iZIEZ44Qza047ebnPBwawLyEM/5eaMf7d5KlRb+DHLsqFBP/wmoCG/9KWthBi8n
	OLYz6Pg93hzOjrTHbGg8mrz2UYKzknfhtsUMPl2yFyTtkh3/7ds8jPD+AL2DoafShtNFHkpbSL2
	6ZMywIdegn3Wpnh8q0nzbRmYzm3UmQw+G3ofLuaI3PwejoGgw+1cfz9CUImSWl36M7tcEXQ7
X-Received: by 2002:a17:902:e74a:b0:27f:1c1a:ee43 with SMTP id d9443c01a7336-28e7f32ff11mr31042325ad.29.1759302272016;
        Wed, 01 Oct 2025 00:04:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEv94nJISy/926rdHvVX5QYfH6D1YpTXMM4MBF8t63Ks9MFaXihh5qMTzyo0mDLv3bcRsz5VQ==
X-Received: by 2002:a17:902:e74a:b0:27f:1c1a:ee43 with SMTP id d9443c01a7336-28e7f32ff11mr31041995ad.29.1759302271554;
        Wed, 01 Oct 2025 00:04:31 -0700 (PDT)
Received: from [10.218.33.29] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed69bd869sm179517665ad.120.2025.10.01.00.04.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 00:04:31 -0700 (PDT)
Message-ID: <58d76b7f-843d-4439-a987-7895e0b52441@oss.qualcomm.com>
Date: Wed, 1 Oct 2025 12:34:26 +0530
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] clk: qcom: Fix dependencies of
 QCS_{DISP,GPU,VIDEO}CC_615
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
 <20250930-clk-qcom-kconfig-fixes-arm-v1-2-15ae1ae9ec9f@kernel.org>
Content-Language: en-US
From: Imran Shaik <imran.shaik@oss.qualcomm.com>
In-Reply-To: <20250930-clk-qcom-kconfig-fixes-arm-v1-2-15ae1ae9ec9f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI5MDA4MiBTYWx0ZWRfX4EvKsEIChSs/
 bVsOJG3T5WuNHRVHtmtVpCv9Pi+lRmCJSGjbnekppyxPr6UK4awVxyPLMKgjSR/fF14skdQJMch
 MgX1SA4paTNve/Zd6Fo39s1SeR4dJH37kwxxsDs9HCZH3v0SArUvyjDpDI3EzgNeLtVuxAksaxH
 1w1BZNMchqKXGsDtGkGytJsbjOGhrC+gTwKaJROY+9uJ/azV1Hu8BwyIGUpdgOL6zrVuyqBFHC2
 Z0XhEjHJ2iSCXNf3esfpgm+4gb1D/qZBxM3T0GwU8oMETcDrhefyNVsf+wTeo2II1aDshL67Zmb
 3ZKjsnb2YghpJvyn3PD3OxdNUleJsoK2Pv2ztDzdzK1FWqjbpG/ZNml7yknJCIMeqRjawLNSDjR
 SyY01bd2b8RJ+GoIvYRKVTLra1jMZw==
X-Proofpoint-ORIG-GUID: my1q8aPNDdL-2NE7Y69VPvQfa4C2gQna
X-Authority-Analysis: v=2.4 cv=GLoF0+NK c=1 sm=1 tr=0 ts=68dcd281 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=zds2va5xP088SW_5QeoA:9 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: my1q8aPNDdL-2NE7Y69VPvQfa4C2gQna
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-01_01,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 suspectscore=0
 impostorscore=0 spamscore=0 bulkscore=0 clxscore=1011 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2509150000
 definitions=main-2509290082



On 10/1/2025 12:26 AM, Nathan Chancellor wrote:
> It is possible to select CONFIG_QCS_{DISP,GPU,VIDEO}CC_615 when
> targeting ARCH=arm, causing a Kconfig warning when selecting
> CONFIG_QCS_GCC_615 without its dependencies, CONFIG_ARM64 or
> CONFIG_COMPILE_TEST.
> 
>   WARNING: unmet direct dependencies detected for QCS_GCC_615
>     Depends on [n]: COMMON_CLK [=y] && COMMON_CLK_QCOM [=m] && (ARM64 || COMPILE_TEST [=n])
>     Selected by [m]:
>     - QCS_DISPCC_615 [=m] && COMMON_CLK [=y] && COMMON_CLK_QCOM [=m]
>     - QCS_GPUCC_615 [=m] && COMMON_CLK [=y] && COMMON_CLK_QCOM [=m]
>     - QCS_VIDEOCC_615 [=m] && COMMON_CLK [=y] && COMMON_CLK_QCOM [=m]
> 
> Add the same dependency to these configurations to clear up the
> warnings.
> 
> Cc: stable@vger.kernel.org
> Fixes: 9b47105f5434 ("clk: qcom: dispcc-qcs615: Add QCS615 display clock controller driver")
> Fixes: f4b5b40805ab ("clk: qcom: gpucc-qcs615: Add QCS615 graphics clock controller driver")
> Fixes: f6a8abe0cc16 ("clk: qcom: videocc-qcs615: Add QCS615 video clock controller driver")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/clk/qcom/Kconfig | 3 +++
>  1 file changed, 3 insertions(+)
>

Reviewed-by: Imran Shaik <imran.shaik@oss.qualcomm.com>

Thanks,
Imran
