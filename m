Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13940306483
	for <patches@lists.linux.dev>; Wed, 21 Jan 2026 01:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768958427; cv=none; b=L/U+MRPZnwn/g/9zufOrv7lcHLO3fpmmn6mNPesQkILsCMGRjeFzxozS8DIBWO/iI3Io0qRhGZneE2SQwTWlKdp5yEIjITKFeVrpD+zvsqq+2ksDZF4Pg9GYEkBlYZpufnHPR0ioPYf3mjKcnek/mg851vblaTIhF9OVAxZiNZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768958427; c=relaxed/simple;
	bh=yyFHdN2gpeMVaZ0MZNtfhX4nPoKWXRKlkTFArxKR9Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eO2AkJtHAbICNJ4sENG6IsgYCDD6ORozotE8KyZM/c5OAu5x85C6UoaoZVmMm8+ZfbMEdA9pbqs6qxDojwCnwkEXO4t/seLjAWZXxAb9BhoSrngmg6lTZQZcttlKcs0Ag8ddTGGTaH3TNf5pM39dCMuSuivg7TzU5neh72bwt4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JjhQVJon; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YRYL2VVb; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JjhQVJon";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YRYL2VVb"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60KMSelu428709
	for <patches@lists.linux.dev>; Wed, 21 Jan 2026 01:20:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	31X3HJXmE+ewsNzBKQHcu2ys5oB4OdT178S5VcUsReU=; b=JjhQVJonIPs7teeB
	ksba57MU7kAC7XFnHE9s6f8gtNHJIOMBivHGAhk4VAEqtFPY3DQF4lTvGnL2e4Ec
	/14EPROD5LweJovoDRwNc+q+RxVlTV65u6bxWxoPn8ZWktwvidpfxWXlkJV8J1po
	U2A6H6lI+HTE5i41B8w1GVXXcGUFkQA5S6asXwHE4D+vmy7Gth+Hi/trxOEY4Pu3
	7UpRKznhwprap3xyWLv5zIa8q2dV8hv+YbwNS3YO2mukxrqM3WHOLoPGYyJU9j1e
	S7Je3YUF/0UegLjdXUWFUGDqfFgdXD/jh8Gnh6GI75TQ1ZkElWrG8C/aaOvCG9st
	sF86dQ==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bt4ps3e8h-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Wed, 21 Jan 2026 01:20:24 +0000 (GMT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-89471437f64so9100226d6.3
        for <patches@lists.linux.dev>; Tue, 20 Jan 2026 17:20:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1768958424; x=1769563224; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=31X3HJXmE+ewsNzBKQHcu2ys5oB4OdT178S5VcUsReU=;
        b=YRYL2VVbv/hJUHn9FjFTv1bSy9mD/a00rDGzAkiGhRC0Fw26VuHwyq4smgCFQ78CWL
         QahK3NtzpIj6S8bvqI5alVFqi4Kdf53NFwVdgrwmyWbA3/PSLSUZBHKrOxVxLuTZR5yF
         Ieg0afrrA269gxJOFcCeaxWo91ez8fEXSfXjKoG8iq4ekqJ6qKcY5fo1xXbVbkXIlBxc
         9nBFKFigpsdXepOlUcVusutH5Z/t8TvkAXSjQnjKohdIbKznV1gqKs2Bp8G5jkm8dLoJ
         qWflF3bq2NQ/civDbnpQROeVHKuWrS53+MX69naU8d+kK4HK+qPj4K/s6PFAvL0T1dmU
         LB2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768958424; x=1769563224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=31X3HJXmE+ewsNzBKQHcu2ys5oB4OdT178S5VcUsReU=;
        b=MjUSuh5TQU/74yyPOmAQr4g2JaAKIBv7we80DZONqx1qrVkoa2Q6JOv6FfJjB9uD+6
         yb5OwNH8OnNDRLtacVsx6YBicIV1Xs3kK6ex4saLPTFOgT5+XlJr8qucV7c8c8STXb0v
         6+a761b3zjVU2CfTt86t7JBLuf6h2dXGM3uZ+0CFGvUBJ3Y0jw7SW+66yjnwdGRnoZet
         Kv3RVkL4NZV9+aebmjGTdM6jxFQPGH41z3UTx5+wwc/FrJ/IW4KpkeyjzkCkA/WHWtMm
         OSHTsrLJI/BphLiktLPYKdHz0dUJGiXWwaXy3d4ByReovOaeKo1C8LWMzx7bIzT2iCoO
         hVXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVOto+n9sStqSSKOERsLPqujkQ7ewpHEQ6ylvnGdxr/AHvy2xyMmRjMcOJLlMVxhN7CerNDwp66@lists.linux.dev
X-Gm-Message-State: AOJu0YylccLLCIC1xcTvElj5kjgK1fs1JJb+TH6hoJ52cSbp+l5C/f0S
	0TbcJ/yvhF+YN0dpSHAEVOWh1OUVOu7amXQIWucoQsk8E0kCIDufzB+QuhXkGfC8mwEQkklUK+D
	w9mRh8nBnPCPTHMb5JHunNdL5/X+PcSmslSU/rc6iqidgalmc+oWFUYadi5VA
X-Gm-Gg: AZuq6aKPm5rHBKPWRd+Uk8hS2Ww2iGadFpnChLNOsDYeXPzuhNDxdN0SyVQvPMBpIRa
	nwf7IexkOpubhWtR3VHmnIE37axzHXJwM7uz5rrTZpIelamyjRmbwEbUv3DFEoUXDfdHozn+Co9
	fHi6NUvApBuNtW/ztGjkdlnC6CGjbpAU0sZg2y30YdvqA6QBNKYbNBnveC3+0HQvW5wHMrdRCRJ
	bJqkRY4wqwgxFbEtmnCuj/M4k/jvgx5AX/mtus9vcOmsGrGiYRNSJkb3twucKPeKCfOky2iqHos
	BAJmrMP0jOLDfFEWGDHDOwGTvMWZxzPPVJ2rGrTYdj/Wrd/l0XB52z1yD1G+uK/zEM1MjyqOTgM
	MZxY8MzceMVzPh/UjlvZ8IvALjrcV3tQJS4N19xwmGdpB+FSReshQTQdh7y3bBavhBj01/RsXbI
	KbfQmxYTKUmoTOERcZrfNTFF0=
X-Received: by 2002:a05:620a:1a10:b0:8b2:ec00:784f with SMTP id af79cd13be357-8c6cce503bcmr456075785a.82.1768958424130;
        Tue, 20 Jan 2026 17:20:24 -0800 (PST)
X-Received: by 2002:a05:620a:1a10:b0:8b2:ec00:784f with SMTP id af79cd13be357-8c6cce503bcmr456073085a.82.1768958423695;
        Tue, 20 Jan 2026 17:20:23 -0800 (PST)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59baf3543d2sm4383110e87.43.2026.01.20.17.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 17:20:23 -0800 (PST)
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Rob Clark <robin.clark@oss.qualcomm.com>,
        Dmitry Baryshkov <lumag@kernel.org>,
        Abhinav Kumar <abhinav.kumar@linux.dev>,
        Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Nathan Chancellor <nathan@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org, llvm@lists.linux.dev,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v2] drm/msm/dp: Avoid division by zero in msm_dp_ctrl_config_msa()
Date: Wed, 21 Jan 2026 03:20:20 +0200
Message-ID: <176895840437.3580355.3757750367730207447.b4-ty@oss.qualcomm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260113-drm-msm-dp_ctrl-avoid-zero-div-v2-1-f1aa67bf6e8e@kernel.org>
References: <20260113-drm-msm-dp_ctrl-avoid-zero-div-v2-1-f1aa67bf6e8e@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 9gnysIzpAFP9Wh-UgwXYuJEFw_JP5-yA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDAwOSBTYWx0ZWRfX13RHnxiBUiiz
 7Wf2wfd10wSQy3BoNvQdhR7NNyvqhhRjmCLNA365wsQucIjtgpCVclq04p2h0z3ZgRMhW6ZlMEK
 fx7mkxuHBOM/lB5L/BjxUmmnwQ6WrdafOVzaiXGBhilOPTCL5nyHh225ceQYCNzyKnz1JXJuYuz
 OM0rqjEQoiKEWlGos4sj0X5i4BYzX9uUph8acKo5NSyJqTewadNHi8OoKrzy4T69JRJFgxn6qxB
 8Lc7cwHhg2RN6qqSwZW8t0llk8ofWPA1HvgIfmnokP+VvX0RBrJAhDODtI316V1ytppCHhPaa5D
 FVCorENpLf06dG7wD5qulxhCB0RxZa4SlPpVJiLvkgSFf2wxWG3ElBWrBhmksdOdEIPgLt0eAkO
 gv7Y5JURgkbm/u0v5RJ+fS320h1xr8MXR7HT5cR33W5eIIRQwPcIXDJ9Pg/5RFDNabcLgP45qmQ
 f1Uiy3k5h12EuKoA/ig==
X-Authority-Analysis: v=2.4 cv=PdfyRyhd c=1 sm=1 tr=0 ts=697029d8 cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=e5mUnYsNAAAA:8 a=OVJ8HEpvijlIqhD3_UYA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=OIgjcC2v60KrkQgK7BGD:22 a=Vxmtnl_E_bksehYqCbjh:22
X-Proofpoint-GUID: 9gnysIzpAFP9Wh-UgwXYuJEFw_JP5-yA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-20_06,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 adultscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2601210009

On Tue, 13 Jan 2026 17:00:31 -0700, Nathan Chancellor wrote:
> An (admittedly problematic) optimization change in LLVM 20 [1] turns
> known division by zero into the equivalent of __builtin_unreachable(),
> which invokes undefined behavior if it is encountered in a control flow
> graph, destroying code generation. When compile testing for x86_64,
> objtool flags an instance of this optimization triggering in
> msm_dp_ctrl_config_msa(), inlined into msm_dp_ctrl_on_stream():
> 
> [...]

Applied to msm-next, thanks!

[1/1] drm/msm/dp: Avoid division by zero in msm_dp_ctrl_config_msa()
      https://gitlab.freedesktop.org/lumag/msm/-/commit/f185076da44c

Best regards,
-- 
With best wishes
Dmitry


