Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D2C2BE020
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 08:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755075431; cv=none; b=fMeT0GVYxzVBduBbt+OurAiSPf5pszuum+5DuS0Cw4hQAZsTsYaDPZ1dX0rQ8Lg37jGGJ7fOX2qAofY5hX1Sr/e+F0IgsJ8HuLiDLB+u+53J2yfWSu78zcayHquZbvkH7JiS1HlkvCKBkKtPFepmuN2tY0qcylCSRZourQZbvvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755075431; c=relaxed/simple;
	bh=83w7pj4FfXqNxu+ZrGUToQWKRscr0yX0oGMlOlS6y20=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PBk2kaf8Gie5GjfKR9KlE+yyn+p3iR8+LkX2tuRfTBL/GpCdfXhhs08r70WLYf4peB11cZSxevyDmGLw3T0mOLtqvRlsC4N95Jloc2IYpqB1JjDgILpxNRRVpyIodK6lmnnSu0QJmgE9KJGvociIgbvUjrIWlJbaXk1vIxTFgTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LWWmUR0L; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LWWmUR0L"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57D6mKQi020490
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 08:57:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ZlgaL045z+2LDRggZ/H4bQjLQbfz/Os1B7uL1iTg22g=; b=LWWmUR0LFOGDFV3V
	cq7RT7HISdg21hlxzA8xfDyNuf97rsdLF+4CQmSNS6l/bvfTQVcOMx6JmFGpoFXq
	FFhCpOjXYGtLAwEvZ1rDxArR4zxqKU31iJ5aU5XvJtyfo+SYSU07uKill4WYyZNz
	kI0lexpWl9wzUZc12VsEB5U7nN138BBjYTu7I0I+repf6uXxszHsYSuYWlPPwwlo
	cb9LEl9SeohL1U/ePGEPv7cMlyZ8E1+gzkaRQmuyk1tW8IsV2uTDosaOpWI/hDgR
	h4hVBhoe1hzrrcIt48yHgrCkdgOyz2w0X0kadprXiuq1/M0x/cZYZFLnKHYpdBWr
	CclwJQ==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48eqhx99w3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 08:57:09 +0000 (GMT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-709de8eae4bso1733356d6.0
        for <patches@lists.linux.dev>; Wed, 13 Aug 2025 01:57:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755075428; x=1755680228;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZlgaL045z+2LDRggZ/H4bQjLQbfz/Os1B7uL1iTg22g=;
        b=gc8EYC5tYjrps1sXsS4LVGnib2cpdKk8bWm8t/ezccRy7kKSYxBfgJJDpKbgzOB9Vp
         q5905vXjDWoL3VeQ/EcMTozd55+rF43d5tDlWl6xtqgZG/YkxEOeE4ySzYdQKztXTsUy
         agEXDKDf5yYaj3xU89wr0u0MY6o+Bqwpq6x9t9PELAy9hAGAK/BuhFh1pz4NxcLrxwlC
         0Ftu7an3gb6LEAHabg+sUKQxR1UkeJZjKyOi2mO4+Rnhmetc84O1FgI8ABuNm0bfL5oa
         IighTBSB6kOMaaBbkrvrs9LaGrtbAuHUJbu3EqoQW6suNfbB9rqJQuezdUT/Xekd4Noi
         yJjQ==
X-Gm-Message-State: AOJu0YyoVFIJx2FVM1yrp7s/YjWRIIlyzyYMpaYrLBZkRL2hlUfz0iNI
	CxUTwki62I86QFDCHLel6ONEYYPX/yU3c+wrHoik7zarfX2x4Ja9r0PrZibU/CQ22ftfbzpvjwO
	/9XgGxxl8905z74svuqQABh4hYsni6D4rSibPzIneG/YINPXK4zJO8EQ6gLArOTuXDuG4
X-Gm-Gg: ASbGncvi8ZxchoOOdTTlsL8aXMDYJDhWkvIhPjmvqYOiXtH2Iu/9ai0KdrB4FbvOU2Q
	13h9BFhzXKCnlKgvX6mReC72D5U80YNjfO7W28ex5rm6P4GCUTme9dNJ28YdpvJRMywkPuqJay+
	DJtteMoHKxH3W+V4z/o7D3O+ru1r3qESHr7pFt2+KW++3s3MhFQVINY6Qn5+as77OAwGxTKLL4r
	uvPYOnRHCdWVXHm2/Y7nPz2qaY09wwhSm984NmVTNh1W81QY53llhPqVp4GRiWk455I7896Xyrh
	Tps7xgt7mLtan+ysJp/8JjGVTqS+hXE9lSIVyA/aFoBG4Y8BIe9DnOP7MCjOtWOKzsx23LcBzRN
	+mJXn4s+lao1RUzFWbA==
X-Received: by 2002:a05:6214:262d:b0:707:5f89:c024 with SMTP id 6a1803df08f44-709e89bbcf9mr11265536d6.8.1755075428074;
        Wed, 13 Aug 2025 01:57:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHQjApPYi0wKEKWmlApDg2/wrAZ/m5OBdcXLYtze/08Go6Liq7J6MIRjVz4X81xbMj0W96/1Q==
X-Received: by 2002:a05:6214:262d:b0:707:5f89:c024 with SMTP id 6a1803df08f44-709e89bbcf9mr11265446d6.8.1755075427501;
        Wed, 13 Aug 2025 01:57:07 -0700 (PDT)
Received: from [192.168.43.16] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615a8f00252sm21420703a12.8.2025.08.13.01.57.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Aug 2025 01:57:06 -0700 (PDT)
Message-ID: <debdb50b-1979-40ad-a135-c6f65d48b322@oss.qualcomm.com>
Date: Wed, 13 Aug 2025 10:57:04 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 093/480] interconnect: qcom: qcs615: Drop IP0
 interconnects
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Georgi Djakov <djakov@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20250812174357.281828096@linuxfoundation.org>
 <20250812174401.294534062@linuxfoundation.org>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20250812174401.294534062@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEwMDA1NyBTYWx0ZWRfX1PhiZ+4CP6b2
 DX4JEaz29mIIMG0G/gEvjNOLd+FU6SK9GtH54Qct7jljLNdxCcmQc7IElw8G5r9I1Y4Pafbgr2j
 JU+3P1TiJPYPOTETnJTE4KQ+Hq1rrXuMMOJuK0fI669MmYWFUeJO30sf8f1b4Q3JwyL1PyE9t+2
 ZFTPkaKTDGVvjr3ECn0PSJNE1DNlkfFuDmXl8u1yWBbcF7HFKDHeYgx78L1y3h5rhZogxGwjUwI
 M7H+cL0N1nbIB0ekkVHGlB3vnZibl5oZmbUixpusZLs6P3LOXLbw+deYpjUIBmrPDE8A7wJKjvQ
 RoiZUiaQESetmcxUG+sOO0H5jpKiG3jqSWo+2zEzDReF5zXalT+v+25YIfadXkDgdhn7ShZGFrj
 MeLLq/Hq
X-Proofpoint-GUID: xcHGyVqOFBt8x94q9yK14SSb74icbbg1
X-Authority-Analysis: v=2.4 cv=aYNhnQot c=1 sm=1 tr=0 ts=689c5365 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=Lh6LkGG3E_lky4PZl18A:9 a=QEXdDO2ut3YA:10 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-ORIG-GUID: xcHGyVqOFBt8x94q9yK14SSb74icbbg1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_08,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 priorityscore=1501 suspectscore=0 phishscore=0
 impostorscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508100057

On 8/12/25 7:45 PM, Greg Kroah-Hartman wrote:
> 6.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> 
> [ Upstream commit cbabc73e85be9e706a5051c9416de4a8d391cf57 ]
> 
> In the same spirit as e.g. Commit b136d257ee0b ("interconnect: qcom:
> sc8280xp: Drop IP0 interconnects"), drop the resources that should be
> taken care of through the clk-rpmh driver.
> 
> Fixes: 77d79677b04b ("interconnect: qcom: add QCS615 interconnect provider driver")
> Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> Link: https://lore.kernel.org/r/20250627-topic-qcs615_icc_ipa-v1-2-dc47596cde69@oss.qualcomm.com
> Signed-off-by: Georgi Djakov <djakov@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

Please drop, this has cross-dependencies and even if we applied
all of them, the series had no visible impact

Konrad
