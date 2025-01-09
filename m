Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D65219A79
	for <patches@lists.linux.dev>; Thu,  9 Jan 2025 14:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736431612; cv=none; b=tRvPuRmyjdesMaPY0UL1keYFSEBH7AvFbYb/C0nr+kcA1TYZ3iHuKANmWuMdAGShYAcb2mQK5RtZFOMjvzOdJklLrf3yLmjigcogJTwwgmwCvR4DBsmgxrINpS5Bqkm6wpWMUUXYMhsa+69mxtEbcR+Ycv25DNEq2rm/ZpM29Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736431612; c=relaxed/simple;
	bh=WwNHlWij6cUWaLoQi9J3IlfvCXoefxscyY8IJL/7GE4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BHxt0ihmdIFZpKRqT2vBTw5uxreykvpDilI4cMMKhyr/SXuXoaOrBhPAAv9ygoY4Ncw0rIEPmg4c0sA0DRnHQx9a2zQIGYBaCjAv34RR2ATGxF6pKedwaesS7dksxM2NWT9m2RTnPENe2ClFi6Nrk7e27UFEisJXlkX4VPXwjkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YP8Kfpq2; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YP8Kfpq2"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 509D7cl5009927
	for <patches@lists.linux.dev>; Thu, 9 Jan 2025 14:06:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	mbArVg6/eRJ5CBY3wlWkBQa8h4VvimPAbHJu1V1shmY=; b=YP8Kfpq2GiAcqEuu
	4uw9kQUSA199doBDfgyDTaI0jtv1L5zH8Xob4H96CzcFs7qsjjdxizFqfkbw6NjL
	vI67GCbr+XTjxVdHXh9uaIbFq30dJCo+Ts9S1HLk47Gyv1bBcpYr9ZFWoweSxSP5
	rdJX8T8ANC2Wl7WWLlWtpm7waEKPzw94i8OjtLZtr7NhXzkHl7HZaVvhqQf96pbL
	thh0GdRTHJFWdTbVwxNCXVuipcJ63EgyR0yIh2IvRTeyqQ/SLTjq+3g+DtIyH51m
	Wmj2wm1+p3qcw6BoaBKZt8c0zZm5z2OgH4tVMv2k8V2rLHYR2DePUSddXSR+/JpS
	KhNR2A==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 442f2kr4dj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Thu, 09 Jan 2025 14:06:50 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4679fb949e8so2301071cf.1
        for <patches@lists.linux.dev>; Thu, 09 Jan 2025 06:06:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736431609; x=1737036409;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mbArVg6/eRJ5CBY3wlWkBQa8h4VvimPAbHJu1V1shmY=;
        b=qAWnGZvUKk8yKPTCUICxiEIlg+Bzc+awg5gqN3Rrm7xMa3xH4brplKvPFUya7bl782
         H6C7VBfEu/Y7ReJgG+3n2h0phygyw1XMQ9AXp9K6y6QHLDZMwnGHyRupnCVlFcsbPR3M
         JRdN9nov4fCEN2lip3ciFPnGpkKiRzMrInCOItMPeZZ6TjlIa6HmohQon6nki3lV2mwi
         XGMHDAqCfs5w8unY9VeQigwi5hE8ikbz4/OK4nSDSfq+al3Pz2NSxD+3Qoq6GGar/kvy
         bhJOsKvLBeAnzIC4qW37xJfUNv1ahLWBeCSHp+hFZxIusOjEwIsL1RO3ErzqCXXNF8Vr
         AOYw==
X-Forwarded-Encrypted: i=1; AJvYcCWvjpUeXjkdtUA4d2/OovljLzbTn6fjFKB9uxFx/MZVH+J2yL1fDe3lJ8h8d0YPd4TnewxFg3OQ@lists.linux.dev
X-Gm-Message-State: AOJu0Yy7PxspNORz0gxB4FtksJ7aEw41ecoY6aXCGGORhVw+9UK1Nrw9
	Gs3fOCVmK5RAeZgiRxDZJTb9QjWEvpDSXbw730XLUXhrgGBUxZsK63E120uvl4EwpEhLhHBFaT4
	mspRx5/IQTS95CSDhSXl6EENerxynN3FlwnwBxqqzYkhGveQJsayHEJEi
X-Gm-Gg: ASbGncttdPViW5GKjzLeh8bTvInJhI2vIMhUiEu7/ZYmcIZzQk1VbITGV9cH6LIyulf
	d/glt+LpPF+7R91dIioFbspJgO+eV3oTseD+GU3a8T2giv1+c4emp5jEvFUMDitAUoAnd8B3XRB
	RQ6IYojLYybFe8ulBxgL36NLXvzN/1MHqdUkDYrI2JWCnqC5PhOtK4ml/ah3pZd1A2iDz+oXBOQ
	S3NEs4UmzmQ8cEPWMj2DXrYaNrqTI+7N4P5YUzdUGMucJZUflDKl3tEZ2jqu8jYl+EZf70PV/kI
	m1yv345u6EK7e2PwYfRBlPi1ciQ3+FgGyOU=
X-Received: by 2002:a05:622a:110c:b0:464:9463:7475 with SMTP id d75a77b69052e-46c7107797emr38702551cf.2.1736431608978;
        Thu, 09 Jan 2025 06:06:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHie2b0u8nYDuEHN0u3Cf6+ivLeBSXYRoFjZINs6QXJq5w2Zszg8fYJRiSalrgy7pO1187gXg==
X-Received: by 2002:a05:622a:110c:b0:464:9463:7475 with SMTP id d75a77b69052e-46c7107797emr38702361cf.2.1736431608551;
        Thu, 09 Jan 2025 06:06:48 -0800 (PST)
Received: from [192.168.65.90] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c95aee31sm74856766b.133.2025.01.09.06.06.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2025 06:06:48 -0800 (PST)
Message-ID: <308cd9f5-109c-4530-94c4-dd32eecf9ec3@oss.qualcomm.com>
Date: Thu, 9 Jan 2025 15:06:45 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 4/6] of: Extract alloc/add functions from
 of_platform_device_create_pdata()
To: Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson
 <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        devicetree@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Conor Dooley <conor+dt@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
References: <20250108012846.3275443-1-swboyd@chromium.org>
 <20250108012846.3275443-5-swboyd@chromium.org>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20250108012846.3275443-5-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: -oZk5ehyKJ1MpSxD-lp41_wtMHCfmLH-
X-Proofpoint-ORIG-GUID: -oZk5ehyKJ1MpSxD-lp41_wtMHCfmLH-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 clxscore=1015 lowpriorityscore=0
 impostorscore=0 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501090113

On 8.01.2025 2:28 AM, Stephen Boyd wrote:
> Allow drivers to modify the 'struct device' for a device node by
> splitting of_platform_device_create_pdata() into two functions. The
> first function, of_platform_device_alloc(), allocates the platform
> device and the second function, of_platform_device_add(), adds the
> platform device to the platform bus. SoC power management drivers can
> use these APIs to allocate a platform device for a node underneath the
> soc node, attach pmdomains and/or set the device as runtime PM active,
> and finally add the platform device to the platform bus.
> 
> Cc: Rob Herring <robh@kernel.org>
> Cc: Saravana Kannan <saravanak@google.com>
> Cc: <devicetree@vger.kernel.org>
> Cc: Bjorn Andersson <andersson@kernel.org>
> Cc: Konrad Dybcio <konradybcio@kernel.org>
> Cc: <linux-arm-msm@vger.kernel.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---

[...]

> +/**
> + * of_platform_device_add - Add an of_device to the platform bus
> + * @ofdev: of_device to add
> + *
> + * Return: 0 on success, negative errno on failure.
> + */
> +int of_platform_device_add(struct platform_device *ofdev)
> +{
> +	struct device_node *np = ofdev->dev.of_node;
> +	int ret;
> +
> +	pr_debug("adding platform device: %pOF\n", np);
> +
> +	ret = of_device_add(ofdev);
> +	if (ret) {
> +		platform_device_put(ofdev);
> +		of_node_clear_flag(np, OF_POPULATED);
> +	}
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(of_platform_device_add);
> +
>  /**
>   * of_platform_device_create_pdata - Alloc, initialize and register an of_device
>   * @np: pointer to node to create device for
> @@ -154,29 +214,19 @@ static struct platform_device *of_platform_device_create_pdata(
>  					void *platform_data,
>  					struct device *parent)
>  {
> +	int ret;
>  	struct platform_device *dev;

ultranit: you kept the reverse order above, please keep ret last too

Konrad
