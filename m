Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D61E2B9B9
	for <patches@lists.linux.dev>; Tue, 30 Sep 2025 19:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759259674; cv=none; b=JT2p/8NEuJmfS7vVFgqqWSzHrL9+Hdxv3agjvpkWUDXL2cqAHWxAx5qrrlDIXOq9pF00pG9quklIpD29jkIW7vWF3rs6A5rgBIor7UGteKawhubNgAU4ESNny2cw/q7F3TPetNYYJdE/yBqEp9gB+FIrMhvoyMqJoqtkfhcPRWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759259674; c=relaxed/simple;
	bh=RFw7rgPy/P4Y4yF7T5QMyWKKqbgPJOvm9kCEWIoxQTw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OlwRLdmyA8iSedqRMIjZBn2Iitwiw1TONMoD0iE65sWRYYboYxfxilWTSnCfbSZc/Tty7Oc3MqM9vt3rQ/OyeNUWGJirqmahHJOeRKjZDLNgdZR10bQkcT64dU487wGgWfOhPGdeoTsP7JSvnVaWt5qp1dRsqZtV3VdkLVfz2rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hkBZ3nWj; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hkBZ3nWj"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58UC72PY026871
	for <patches@lists.linux.dev>; Tue, 30 Sep 2025 19:14:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=aPq1GrPwVVO+Dr1J6r/OVSsY
	OTBdmX3Nsu5MO3vxHZw=; b=hkBZ3nWjZL29Rv1MU2IlMtR/QQYsKIBbq57Wyz3T
	p12csA79Qt8gY0YpzfXNb1YIDzJs/0C6U7KtPxgXTUumhXkkmJHb0+DY1VjLIjdQ
	QyCVr7D1Cv/EYSZVTGvlZP0ch+TzYCODstwQCBdUj2i7nOL8GOmiBkqcVBtSqwTt
	dG89zeFJzxOMxCe7DMUlriVwnWdxdcL6IUW8jwbJn4IIfcKX2ntIIgr599ew+X/z
	6k9LqXcpSAz57WOgJZeuLCOnh9Ktm+nTs1BkbNgdEUu3HTpIH26reOq7/3N7Mf1c
	n/NniQ34Zti9YCLkE35/kGjj6tfJJBRjUqmwCM68YkLUtQ==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49fyrf3s0w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Tue, 30 Sep 2025 19:14:32 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4de801c1446so101996531cf.3
        for <patches@lists.linux.dev>; Tue, 30 Sep 2025 12:14:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759259671; x=1759864471;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aPq1GrPwVVO+Dr1J6r/OVSsYOTBdmX3Nsu5MO3vxHZw=;
        b=txlE7AuiH4M/SZT4QGVgnzAj/xBwyxvY1EPjqzkqHF9FTodD5tzKHdaP90ek4vO27G
         qPsmmY6tMcovgal/vD+PzjjdNmwXJLFjb8PqBTjsf6Bj9umZx81Jv57tpatIsu9ObOCI
         n4j0tLlrhg3QoA9kJGnHvxLeeRr17UhbxDU4ottKd2fgyQ01Q4tqNzMD0n7yRqNHl9ev
         1m7+egDGcwdLTmHW9BZragtkSNhUiSqAKrdd6vfOe9tH+GdgdeYf6twidscrYOQInR6s
         hEf56vMim5NZfk3hi5Jzl4WtcDNNc4GF/7kyImnIvB+N3VYELejzt8LnnpFelYRcqOzq
         a9qg==
X-Forwarded-Encrypted: i=1; AJvYcCUeBceRynL5fBIKNfF/zzp6QZ1mhzogqBVSfw/YGAH1TzU2oqR5GjXMLv1NLcmNemAGMODxpz7j@lists.linux.dev
X-Gm-Message-State: AOJu0Yy9Wm3cng2RsiP43lGKHrEUBlcENEKNRLFgnmUO35akHjoYp4ui
	gEwoCyxu9KqHqPCAJ/O7eGENACSm8o2BnYYzzN4lC3U8ZdL4+pANn4akJP8t99N1mjwTk+y/b0k
	7POEU79ZZI9CuW75+BOT3qWCRlgeBR591IiLnp+TfbPpvzb3sMFCfbQlzLz+V
X-Gm-Gg: ASbGncuNuzb+XVcpXbfFRp+jeNsIeHB2JCrjgQAnwE4q1wW/uZwU1X/fFctgyRvxbWn
	TcyAFFihREZayupiX4RgvY0ziSwXtY5PePCAPjXzQCrD3jwP7rgxdFBradJM5NkB6vPEROiOeN2
	xyhIk/pVHNYug/fAhJAJic31JQCCKRTAbKlH5ziT6VI2bVrrqX3Kp6aaZw20sw6dsMCfWCLkpfK
	k1EXriyBQ5dI+/QDF55ilsb0wuFZvN9MWWLBE7C6AmrroOIBP0s6U7jXMTC0ieVzKHWNoJEayRr
	RvUGK1aDQNK4thyrlgjqr1Fh7C+IpdukTDa9L+PQ6PB1T1aW5Bx319Sglww/lZq330tRSUL5qug
	idvHo2GxtrhhMBSSjQTbljjPbANRVHCBI3+B9yajphsvC88X2miWcOw2bPA==
X-Received: by 2002:a05:622a:1cca:b0:4b5:e871:2402 with SMTP id d75a77b69052e-4e41cb1502emr12326401cf.18.1759259671418;
        Tue, 30 Sep 2025 12:14:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGLNJlxjerynVd1dTh9zDT0y9I+Z5SHJ6Y4L40ldD5RmBgpMxLSvRCK4B+vCuq5/baX+cnaLw==
X-Received: by 2002:a05:622a:1cca:b0:4b5:e871:2402 with SMTP id d75a77b69052e-4e41cb1502emr12325961cf.18.1759259670924;
        Tue, 30 Sep 2025 12:14:30 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a0c3-3a00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a0c3:3a00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-36fb4e39107sm36070581fa.17.2025.09.30.12.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 12:14:28 -0700 (PDT)
Date: Tue, 30 Sep 2025 22:14:25 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, Taniya Das <quic_tdas@quicinc.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        patches@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] clk: qcom: Fix dependencies of
 QCS_{DISP,GPU,VIDEO}CC_615
Message-ID: <t3rzsvmepjoyhlmyldvttn3dopxfgoqcz63os44by7iu4r4cgr@crkpcwpaetgo>
References: <20250930-clk-qcom-kconfig-fixes-arm-v1-0-15ae1ae9ec9f@kernel.org>
 <20250930-clk-qcom-kconfig-fixes-arm-v1-2-15ae1ae9ec9f@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250930-clk-qcom-kconfig-fixes-arm-v1-2-15ae1ae9ec9f@kernel.org>
X-Proofpoint-ORIG-GUID: YQ592W1gujQe9njwTbba9nmdKszM6Vfn
X-Proofpoint-GUID: YQ592W1gujQe9njwTbba9nmdKszM6Vfn
X-Authority-Analysis: v=2.4 cv=etzSD4pX c=1 sm=1 tr=0 ts=68dc2c18 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=zds2va5xP088SW_5QeoA:9
 a=CjuIK1q_8ugA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI5MDE3NSBTYWx0ZWRfX4socx+5LG3Ws
 ORkq1vH7P+P62t5uJJvzdr1Ljc6U6Vmes2cN64aj3aOo1XwIzLhZeq2yW752+0w2/fYeiSLznYK
 uFkU2eYP+DSmx2VdWQhHXV32GH9zUmZjhCDZJ0k5rSWejKcqqBveMT0gxqpCz+MkYh2so0i/Oj5
 EbBrs1rZgMrPJm66fyHqEsVhr7JXZUCVhlh45+94CFDO3jd3t3vuGgC3KXUCYpEd5ddvNSA5Zmv
 Gatw4XtryGqgq5dHsdeWbJjnXZMOqEVYeFGrKrOF4vIetDWM2GXrcDKDIka99gVt9DOjWtvX3Eu
 xAFsD2Qpsvevag0iTtJm5lWa2h7d2ux3h1DsZDpmb3aSt3rJMOk+Zp1lH+Ho1IHB+r+TRxCYESC
 6CmWGEyuQZlyBThA995Ro2XHO98kBw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-30_04,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509290175

On Tue, Sep 30, 2025 at 11:56:09AM -0700, Nathan Chancellor wrote:
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

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>


-- 
With best wishes
Dmitry
