Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3A221884B
	for <patches@lists.linux.dev>; Thu,  9 Jan 2025 14:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736431523; cv=none; b=oeKXhxPNVHwVSBnTnnPeg9rKNG0/oqY3+oOUhQHOMY3UcIahWHm70xlEZsxYB9LJlzRAB8RZcQSl+inq98glZG2Df/sBKxPubXEkG2TjPQ4gdphqEaMb4/5F1nQj/8eMek7KWmj2i6gertiDUrH9UvL/2MAjsrmlvioavTsN++U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736431523; c=relaxed/simple;
	bh=JqG7kRysNprvoPeO0aN/2csBAovEByp65OYigykf1NA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GAj/eW953dI5HFRRZ6Hx+0IBmBwLcBGI2oSxwQEuNaAnGD98jg7kWUaukcEdVN56MkE1ZwK/8dHTHF+BMLNwucvdjuKW4l7sYcOlc4psc9jw25nQJ5XCT0BbdlhwYDA8BWrnvkgaU6CoXRjDPzgo/hQgyAvFIjDB5gSZUk7rTVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MTg0GmYc; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MTg0GmYc"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 509Bd4if001550
	for <patches@lists.linux.dev>; Thu, 9 Jan 2025 14:05:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jmyRoYoXdFm3t1ZvxCEQdfjo2p7lHvFyXfwqsSYXeSo=; b=MTg0GmYchnsOejg/
	uEzwshHY1V54wPpOSWyAYR66okd2iQxP31pQyKyKfHYgg+B25zhz3Si5oWUTNJmZ
	gj2SNZ6Ac7iu1K8AU+RtIlp7DPXIWi7M8Di2hy+nCvPJLUCY1VDplVaLeQr9G+io
	lEzIM75G/w5K1ywG4s7V9QiXR8MGHKSu+yS0pVChb90HK7MRBnnHXfmaJ6YP4rjf
	Ek58ul3tTaa4i5G745NRJJcu0zEeyhnVlhHUC0mBP7J9bchZYS3fQdbiLhhjlSJt
	lhPRy44V5SFXGiL0qHZBrlW2egDtnP5YN5SvkNSK8T/ewZTBjVdEynrsetIeH/5w
	0wr1Jg==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 442drwrb6v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Thu, 09 Jan 2025 14:05:20 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-467922cf961so749151cf.0
        for <patches@lists.linux.dev>; Thu, 09 Jan 2025 06:05:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736431519; x=1737036319;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jmyRoYoXdFm3t1ZvxCEQdfjo2p7lHvFyXfwqsSYXeSo=;
        b=UPJR4dnfu+V6fdKg6kTvAFcKT/NF4/6xumixr1sfCtQIRwhr5P5J9TzbM0BL9B0Lkv
         sJkYlVVacAGi7u+6HBXWEkDXhaZ6PD2YVEAjNK+ujsLt2GoaIrRSgpbZN+JqVYg2l98v
         l/9wJLjbnZsl/F/tW0OrHHfoD0OW3uot5GuI91avcPBlgkUwCanqjXp43dErUKQNKs0J
         JVuKIDSRMcXPPQwanItZVM44N9KylNHeU5mmGbZ4b95K0G7XGQ1mUuqa3rJPYKoRxzYM
         8oN75GnMGiMXX5HhSdiO5kqLI2fnMQJ4kQK5ag/uKmpWYioiLLdh5J8zcsfzMfI1eXtq
         1ISA==
X-Forwarded-Encrypted: i=1; AJvYcCVTQnhk4KSLVkV5Zn2JxJh5nEAzafHKQgx1YzOXcM9v2dJTEC455ITF7hN0F5Ul4pKXAC2u0+4X@lists.linux.dev
X-Gm-Message-State: AOJu0YxH3WoTJanBosefPy4HhW182+ALbslO853XAR8n5dVDfan0u+l4
	f3jyRCDaSKQ4zx285xxHxXmvUFLKlcE+JIJt9QoYrZPYRJk80jmQc/mMtyYylHoGcwUHDZhs5iU
	Udw1qbpRCFBc168klfQQjzBhPgsS7yoUP5+IzmzKAWHzKI+y5pdlnvlFg
X-Gm-Gg: ASbGncv9r64MsLJkDCozaNpgBcZhqC2nzOIXNc1fVGzO53rMmqQ0qkOCZgHk5IAfo0J
	yPznuOMSTdDCT5VA6qegGmG/bs3YYx1r31/C74llzdT74NKGoqn9hRz6KtiKB+sPbD0l+oiEdNe
	d0dZjJztqoM3acYJgKI7aXNfwsLPqMVlo5yl0kk8XCMNl5sAumH2hCPZ2YMR4YA7jlqQdbxp8nd
	QHWcd5CIP3gmlbdhnnt72fbw/Lgfic8BZXWydI9SdeDinNWyrakcDXlMNakntIUyapqHZ9OaAmK
	AZ9DUxdDkLKS5xFo+JhUcNYoQGthwldPyM4=
X-Received: by 2002:a05:622a:286:b0:467:61c1:df39 with SMTP id d75a77b69052e-46c7107d82cmr39750561cf.11.1736431519523;
        Thu, 09 Jan 2025 06:05:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFh0MWIoJ9XR87ldHHy6FP17ePLNmNh9w1tSS3oyRlv58o5iBDlj+igtuNpR/o9oeGMMDjgVQ==
X-Received: by 2002:a05:622a:286:b0:467:61c1:df39 with SMTP id d75a77b69052e-46c7107d82cmr39750441cf.11.1736431519066;
        Thu, 09 Jan 2025 06:05:19 -0800 (PST)
Received: from [192.168.65.90] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d9900c45aasm626251a12.28.2025.01.09.06.05.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2025 06:05:17 -0800 (PST)
Message-ID: <7a64e927-235b-4d63-af59-f2c80464a9a1@oss.qualcomm.com>
Date: Thu, 9 Jan 2025 15:05:14 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/6] dt-bindings: bus: Add qcom,soc-sc7180 SoC
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
        =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>
References: <20250108012846.3275443-1-swboyd@chromium.org>
 <20250108012846.3275443-3-swboyd@chromium.org>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20250108012846.3275443-3-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: cS98XwU78WmkBV9XEurNXNaKRBTumwDP
X-Proofpoint-GUID: cS98XwU78WmkBV9XEurNXNaKRBTumwDP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 impostorscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 clxscore=1015 phishscore=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501090113

On 8.01.2025 2:28 AM, Stephen Boyd wrote:
> Document the Qualcomm SC7180 System on a Chip (SoC). This SoC is made up
> of multiple devices that have their own bindings, therefore this binding
> is for a "bus" that is the SoC node.
> 
> TODO: Document all child nodes. This is woefully incomplete but at least
> shows what is involved with describing an SoC node in dt schema.

I'm not sure I'm a fan, because...

[...]

> +
> +properties:
> +  compatible:
> +    items:
> +      - const: qcom,soc-sc7180
> +      - const: simple-bus
> +
> +  '#address-cells':
> +    const: 2
> +
> +  '#size-cells':
> +    const: 2
> +
> +  clock-controller@100000:
> +    $ref: /schemas/clock/qcom,gcc-sc7180.yaml#
> +
> +  watchdog@17c10000:
> +    $ref: /schemas/watchdog/qcom-wdt.yaml#
> +
> +required:
> +  - compatible
> +  - '#address-cells'
> +  - '#size-cells'
> +  - clock-controller@100000
> +  - watchdog@17c10000
> +
> +additionalProperties: false

..this approach will make any dt node addition under /soc require
an additional bindings change, which sounds like absolute madness

I think additionalProperties: true would be sufficient here, like in
Documentation/devicetree/bindings/soc/imx/imx8m-soc.yaml

Konrad
