Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FA53B8D43
	for <patches@lists.linux.dev>; Mon,  8 Dec 2025 04:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765169192; cv=none; b=tmci5iEIO2jCpa5phMcB5W/5lOJrSvtzBA4FmFUXCJLuW8iapjqxeJCo4Dx6fxh2AWUbg/R3ZX0/vE8RtlDM7qJ2TVisl3WeQa9RJLxYkJNZcMjY+XtWYXNA9RUd20RNkcyUGgK3xYV0/moYoC0GZjqR97J87EgxdUZS+zg+qoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765169192; c=relaxed/simple;
	bh=JzqyOmm9VLmUUGX3VI8ZodBAS9jZGkwsN+pnXgKJ77g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oQY6qzB1VMYf4J6ntgYS8S+NoM1zcSlgPPKI8xdc6a3bxqrKYr87dClgcj27OpzszoA/tdTAoRuzse/h+pQL/jw0CbVl6YKcngyUe9yT/85NV5hallbPIPcfK+rKvGk2uTtyY/mcj+o6Dl96LFHvXtzqyfRXY6MB0b2F1v/M6ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PodwijK6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=h4z2ZVDX; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PodwijK6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="h4z2ZVDX"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B7Ns7FC3171627
	for <patches@lists.linux.dev>; Mon, 8 Dec 2025 04:46:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	p4KkJpMgIhYUsI7fBn0bWqJ3IS1cOfKstxEaPVskBgg=; b=PodwijK6PbXkrjMl
	xhkWm8YmygrdCXau39R5eVFeC3AR+1icMv+TvHeJ9tZzlaxjEVGOQhyxIZa4CGJc
	/EhhEyyE0dyDOQYPiBg4XdwEmRT12CyHTOFOjb0tF0/7aqrG3AEwtqTt0nrf4s4Z
	oVKgoZlnxJ3WKmT7PFMpAxmeBPaLIH1ocRkuf1OW1jh7SET+MWZEKvgDGzzRMQZe
	fR2r8kI7Y3GogNwPlAVIWcdLBavTweP1omzgnm9Nb7/LrO/wiVPcV069SYODNteC
	4KUcfr41UW/JdmboOvRI/Vk9m4+Qk5zJFz6vO0XaxZE+3PuxtHSRmyX5v/pt4MXw
	6amhpQ==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4avbesbr6d-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Mon, 08 Dec 2025 04:46:29 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-7b9090d9f2eso7682322b3a.0
        for <patches@lists.linux.dev>; Sun, 07 Dec 2025 20:46:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1765169189; x=1765773989; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p4KkJpMgIhYUsI7fBn0bWqJ3IS1cOfKstxEaPVskBgg=;
        b=h4z2ZVDXa81MfTB0gbIBdLK2E5HJubNjIxqsgE/6WwHT0U3L/zNJmHscWJZm6uGk65
         RK48nczuO72bvUW/sNQX1z7Su2RIFshm7t6Hq4x1ZIs2J/zRBXoOcraxIuFQVKk9gVpK
         qcYeq9UPezn+58M2YgoB0yVApgmmjJP/f1iCbcu+xbbbBi91mOe4u3ntxNftv72M0iQM
         AsoerxqjqfdxhXX+pk6y/uQwTSl/7Zu8y9VaRDzlXPBi151+RANlUEp0ox5a19xzjqFl
         JEECSoKf7NWI/3fPmHT66snM4zO4uHnVRZUgSTY41Gx9dftGSoRt9my09sElDYlVrH9q
         obcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765169189; x=1765773989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=p4KkJpMgIhYUsI7fBn0bWqJ3IS1cOfKstxEaPVskBgg=;
        b=u8CyhZk5nnvcFlZyV1mSozaueviQeWOAYYKajzDkCTBmaxaIFUn9P9+l9FYczfDEGj
         g4FvEjjkz54GRukHmdIdmRGNv3/6PhxVFgWOkFf7AzkqdeeSyJzGCJ10FH40uNh3w06J
         kJB1Uta4FASSx+56+oDpjNBbU38y5i/RPI0AGWG/Ke7vQ6YXoBGh1GFkRGKflnpFTu91
         0MoKrYQcAsUZ9VZ/luuWixR/Cj6r6Hqx5+2l4fNPi+AaWSggsmLLehtRsbsj7CvNcDvi
         faVoMFpiM55RVXgOH5ylvAgYuomjJjMtLaiHI8J9j1zU7t1L7gEV4EsshlmK64wgGR1Q
         6Trg==
X-Forwarded-Encrypted: i=1; AJvYcCXgI8lAyPc6dyCJzW2FuwadhZqho1AdTI2Cha2Jwjl9xWC9qQ9TXakyWmItTfKgqHoWePHMFC+E@lists.linux.dev
X-Gm-Message-State: AOJu0YwqfFkLoroj8+FxyV6bl0kv445CPRAShx+liIfQJqIvB0JA9uND
	yHPlq/nRFmAT3Sm/VzuUVTGLZ1iaunDqtQh1M9zw3Z8rSw47b420SZHyPNmCktorCzLO1mmGuHU
	qTb4BH8NvphKNerDdi9eB5dfTJ8tQkRybVWJCmMXT07MVtcCHdnCOxwhYacMq
X-Gm-Gg: ASbGnctEiqeFC57ESpoyPNZR3NWGcn/TJ76wL/5T9fBkmLp/rgC6YKQn4BK0FWoxM5W
	xhC9ba7uLCHwd/cJtoQW72QYFezWw8KSkXJ9qrgz55J6V6aXeeF+Qru8M6XX6i+x9U+fJdVphPN
	ib1FtvHXrnqWIEnNgkrW6OGfvtagSl1ZAeHeGuDqXe+OPMpR4GbpDvkjOLqvWTc48/G8Mfs0z7p
	VP8KMTyHIOXhaS76p1/PUQ6Szbewb6ObbUHHCq0RijbFdyu9ljmvEOffh7Xr6Zq86SX5D7+NUjo
	dnJos9mo3Da3RKmOzy+WFVICqRWTLlQtwyZWWrIkvF0dgtUch+N7F/vEVoai8i6/Mj1oGxqc+h5
	FAlRrq6s1lcNGGEM1D7Zd3VidMuTn5T2w4xbMdlXYZ/aYziUKG7n0qQIPAaxIipou
X-Received: by 2002:a05:6a00:4fcf:b0:7e8:4398:b361 with SMTP id d2e1a72fcca58-7e8c58083fcmr6185144b3a.52.1765169189017;
        Sun, 07 Dec 2025 20:46:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHWfbkpsiXtca8efRYKsZoQOahXUVnyACIWC1QXgJSv3ERx/JObvGwIdQQWJzPbodMInGvykA==
X-Received: by 2002:a05:6a00:4fcf:b0:7e8:4398:b361 with SMTP id d2e1a72fcca58-7e8c58083fcmr6185125b3a.52.1765169188547;
        Sun, 07 Dec 2025 20:46:28 -0800 (PST)
Received: from brgl-uxlite (fs98a57d9c.tkyc007.ap.nuro.jp. [152.165.125.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7e7ecb848c8sm6946363b3a.9.2025.12.07.20.46.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Dec 2025 20:46:28 -0800 (PST)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
To: Mika Westerberg <westeri@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@kernel.org>, linux-gpio@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Askar Safin <safinaskar@gmail.com>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        regressions@lists.linux.dev, Dell.Client.Kernel@dell.com,
        Mario Limonciello <superm1@kernel.org>, patches@lists.linux.dev
Subject: Re: [PATCH v2 0/1] gpiolib: acpi: Add quirk for Dell Precision 7780
Date: Mon,  8 Dec 2025 05:46:22 +0100
Message-ID: <176516917960.5997.17063555343335373771.b4-ty@oss.qualcomm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251206180414.3183334-1-safinaskar@gmail.com>
References: <20251206180414.3183334-1-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: YQXEFVYmQ54j_D098XanA9Q9rJIZd3SD
X-Authority-Analysis: v=2.4 cv=GulPO01C c=1 sm=1 tr=0 ts=69365825 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=Nf9rhHLrmwYAc+0rcD8p1Q==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=EUspDBNiAAAA:8
 a=hdBtpZ1KiD_UCRkxjxQA:9 a=QEXdDO2ut3YA:10 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA4MDAzOCBTYWx0ZWRfXyWETdSTe8upG
 82ID1UEk2PbTGKyG91OcvssTwmjEYXBJTy+DjgJL3mwAK+DGgz33Py7XVdOmTqk+NVTlXgqWCH4
 4cXSA0IeKtpPyhEloo84FyGAtlcqAHZgwPx+RAQHTd9B6Pi1iNhdpYx7TxX41oziKY/9W92y5Et
 An8vzCtN7G5QHRdoYx4edRRU7UQNGsuljvnK378rMyhFpCvR7KvT0F+UQInYiHm/HQfR4wKgh/V
 pIisHnyobH14Lug2ILZrNmIVnHvATiXNs02XdQxVJybVxjshs7udORfS50MWFmpjHc2vCbKP84Y
 WyJCTSWZikUX2+hPbcWB1obQC/PQGiKcORncLZJUcRany2ZDBSW5K70LZPj7n18DjSNSq9sJkQK
 JIHzefQQrtIb2VI9PwlPzook+bkRyA==
X-Proofpoint-GUID: YQXEFVYmQ54j_D098XanA9Q9rJIZd3SD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-06_02,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 suspectscore=0 clxscore=1011 spamscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2510240001
 definitions=main-2512080038


On Sat, 06 Dec 2025 18:04:12 +0000, Askar Safin wrote:
> v1: https://lore.kernel.org/linux-patches/20251205230724.2374682-1-safinaskar@gmail.com/
> 
> v1 -> v2 changes: changed tags
> 
> Askar Safin (1):
>   gpiolib: acpi: Add quirk for Dell Precision 7780
> 
> [...]

Applied, thanks!

[1/1] gpiolib: acpi: Add quirk for Dell Precision 7780
      https://git.kernel.org/brgl/linux/c/2d967310c49ed93ac11cef408a55ddf15c3dd52e

Best regards,
-- 
Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
