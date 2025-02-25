Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A7121ABC1
	for <patches@lists.linux.dev>; Tue, 25 Feb 2025 14:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740494960; cv=none; b=iMZusr60bBrFwZ07i2h/U9G4MAHxlOGtM+/J6U7AC+Fm+ad4M4f0Dwo+FLdOBBR1QThauY73qiHIeyD9pdiOYFvXG5WqtLRCbEMEEwGH/3vciY5/V+E/RDTEJzNu+SgxlnO2XT3QWTT82Qx5n9EyhebNApH10AOBq7yBM3QaBJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740494960; c=relaxed/simple;
	bh=jB2KNx2xiJKVw67d/M0TT8okvRHhKlz8iuO0X0oMk5o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MQ54DaNrrvxSW+V7aQWBMeHPOwO4HkhOZ0LQl6Jipiv3d4bYM14bH1mjJ+wH8/qW+Uehp7duFNaBknK+p4ENhal5vJnz7XpjKDoveNiCVFSt0vHPG5KotcD+OS8xLEpOCqKa+nTFWzXlRIM/v3w6EYRC7LIiGmg90HTCafTNj8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eMBACx/6; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eMBACx/6"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51P8Dm2A009109
	for <patches@lists.linux.dev>; Tue, 25 Feb 2025 14:49:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	MdZblCZrtqr5nSTII/rdTDMLLzlyRaA57jSGq74yb+Y=; b=eMBACx/628VwpC7D
	9lZ9O1PFLSPuTVS+tc53m1rF4B52Mdcqsa73TtHeh14XTNF7xVuHNInbVxviXI5c
	nUMgSrt0e1IwjROayup08XZGHjpuDJLR6Yh0Qv9NThGeqizuXjGgKPWlfeNn6g/5
	kIknF1gyMCgHn/3QPf80VXMP/L+tv3OeZ1qWPsGChjgewvTkFFtB8g6FjwqOo4Eh
	7V76ZVlFLvCPgw/oZHcTgdfC9isHIjrt4/zVitJZrrpleyixZOwylqsORPiWFT44
	2VzO+9meT7BbaaCLA2x6PaW6W1LsRvNUnaGNJserjXFoleIcqIGHVNtm+SmYBbdN
	RpL8Mw==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 44y6y6s6ag-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Tue, 25 Feb 2025 14:49:15 +0000 (GMT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6e665343a70so10133826d6.1
        for <patches@lists.linux.dev>; Tue, 25 Feb 2025 06:49:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740494955; x=1741099755;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MdZblCZrtqr5nSTII/rdTDMLLzlyRaA57jSGq74yb+Y=;
        b=rxyvpnYGgabQ5ujmpLA1UoZBVJnvumEK8zPvyNL9McWedRolM1EIdJer6S+6RhgZzM
         G/HDco/Y2mmxTBaQ7bydIG7I1m8+svYrfJ8yB4+CbNxGTj+GXhs8yM44hP0B5qwA2NNJ
         St+vvpH4PWZUUa9X6LoxuuEqcXTJc/2q4lg44lz5RD86zJKv8nkiN1yd9qIBsDEF1HGH
         GuJmGVIrNe3ub+/YuWfNjxu/Em5gvr5skrg11tLyKC3qMMZZIiPejbwnSm2hyIf4OCau
         RqJzR0Mr81uFHNVhWL6H7J0p0MrW5ISssEFPVw3FObkEQYkTSZA5tKJZPrzaSYntlZ0R
         hsew==
X-Forwarded-Encrypted: i=1; AJvYcCVjc8fuOIWHelPf4ieBTO8gUM6bA1w1bmzF5jX0abqNKt5yWy2oqQWiTRLLaQV31OAHwC/AdN39@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3Xlgnc2Dj3UMfphqOu7sKWV6Nnq/zWvP36izly8tQjo87hP7v
	T1OI7GPAp0X23xGTgPGQDZcwoeykLl26m9CiHLWI4gFAO70/5VlPow8KSacbqLP1PZqsPjU5NH8
	Ha3dG2hOqbz6tATvaxNzmiq2Ufi0psQvWlJLJzdzKv2ElF0w3scYOUivE
X-Gm-Gg: ASbGncuEnhxwl/hFb6TzxTzREfeY2VGawmXld/qA8yZNUjMDC5LrHQY8IURfRvWXWoq
	/cb2b+/xdpcKDS/8oalKnrA/ldtndWEaUpgMYh8qWYdfJNF/FAZ+cfYIrp7yEYWuYzWAahOXt0X
	RP6UJU9iLYjSUvU1fa4RsriyTX0ks2gn5r1HmX8sKwTATr8KYHuGhP5HZIDTZIGxMiHpfCgF1Sz
	G6P5wW0x/uLDBCUCs76o+wvNa9UtdyW97lKQyC5RJ4TS2TKJtaPcVTvua9xRfpTS7lhNj0lLWzo
	taOrgjo4A+KS5XD6LIDBU9tMYNWGCw6115rifU6F46nn2jSbHQBAkSjCIlm+L4el6spAMw==
X-Received: by 2002:a05:6214:e64:b0:6e6:60f6:56dd with SMTP id 6a1803df08f44-6e6ae9b4a82mr78584546d6.7.1740494955184;
        Tue, 25 Feb 2025 06:49:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE1Q6ox4nvENUzBFA4fILrABEqSIsQiZXCOTgUYTSKSMgYH+75qvmwIn5Zxz7zObrGAIRpFQw==
X-Received: by 2002:a05:6214:e64:b0:6e6:60f6:56dd with SMTP id 6a1803df08f44-6e6ae9b4a82mr78584296d6.7.1740494954729;
        Tue, 25 Feb 2025 06:49:14 -0800 (PST)
Received: from [192.168.65.90] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed2010df7sm153581666b.95.2025.02.25.06.49.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2025 06:49:14 -0800 (PST)
Message-ID: <051fdebf-baf0-4d67-b044-fdbb50d2f7fc@oss.qualcomm.com>
Date: Tue, 25 Feb 2025 15:49:11 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] arm64: dts: qcom: sc7180-trogdor: Wire up USB to
 usb-c-connectors
To: Stephen Boyd <swboyd@chromium.org>,
        Konrad Dybcio
 <konradybcio@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        patches@lists.linux.dev, cros-qcom-dts-watchers@chromium.org,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, devicetree@vger.kernel.org,
        Pin-yen Lin <treapking@chromium.org>
References: <20250221233120.3596158-1-swboyd@chromium.org>
 <20250221233120.3596158-3-swboyd@chromium.org>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20250221233120.3596158-3-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: ol_wef33QiTcpApIB3pnKeCgOphrQJa5
X-Proofpoint-GUID: ol_wef33QiTcpApIB3pnKeCgOphrQJa5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-25_04,2025-02-25_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=964 impostorscore=0 priorityscore=1501 bulkscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502250099

On 22.02.2025 12:31 AM, Stephen Boyd wrote:
> Fully describe the USB type-c on sc7180 Trogdor devices. Most Trogdor
> devices have two USB type-c ports (i.e. usb-c-connector nodes), but
> Quackingstick only has one. Also, clamshell devices such as Lazor have a
> USB webcam connected to the USB hub, while detachable devices such as
> Wormdingler don't have a webcam, or a USB type-a connector. Instead they
> have the pogo pins for the detachable keyboard.
> 
> Fully describing the topology like this will let us expose information
> about what devices are connected to which physical USB connector (type-A
> or type-C).
> 
> Cc: <cros-qcom-dts-watchers@chromium.org>
> Cc: Bjorn Andersson <andersson@kernel.org>
> Cc: Konrad Dybcio <konradybcio@kernel.org>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>
> Cc: Conor Dooley <conor+dt@kernel.org>
> Cc: <linux-arm-msm@vger.kernel.org>
> Cc: <devicetree@vger.kernel.org>
> Cc: Pin-yen Lin <treapking@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---

This is quite a patch, but it seems to do what it promises..

Please add newlines between defined properties and subnodes

With that: 

Acked-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
