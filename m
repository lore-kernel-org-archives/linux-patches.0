Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6385336E
	for <patches@lists.linux.dev>; Thu,  9 Jan 2025 14:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736431346; cv=none; b=M/n7hpzGZayK78zH8OP2ynmPXcckDUTfhosOlwO07th291p4xDfw9T6YFYSswIJ/JU8uHu5Lf8zJGiCzEV9Rn6oaihMz6foOCB3wDJnkGW6JHpbNxb+Rn8aNqgOUFb3/D1bQKs5nn2zmDxyXONuLImmm6x7R6XSL0GoSBjYkjU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736431346; c=relaxed/simple;
	bh=eAyJ5LDtoXr+1R+ZVuoLrayqlcUgbaIUJIcBcCwtzkw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZQXZDr3LmRDGUQOcgGxKLXxPQS4jKoBO1ypLca4T8AQZiY6dO+GT7WgtXJhU2gGhAeoW/jQSvPjw700YIZjsgPrEuk9uXoqNOcyu7TUMp0uvvmT19b6bS92BRrEu6JbI8FrMJnigmd6CV3x1vbEMZMyobS8w+lUTBAXQP0SuzOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FdUmjlZv; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FdUmjlZv"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 509D7XJH009333
	for <patches@lists.linux.dev>; Thu, 9 Jan 2025 14:02:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	eAyJ5LDtoXr+1R+ZVuoLrayqlcUgbaIUJIcBcCwtzkw=; b=FdUmjlZvggS7Oe2u
	eWeHYu9/JhXbWVdJrxFflobcKBIO3dcM0qWBLc8q+Vv+XLw1dwLf4hsA/XpkxOpb
	vzZOCYx6HqekF8re+AN/ZqLyzgHTWJastHp9eP1ot5W2jXDA4HgkpqNZOblNYava
	X2W7K7GVNsKvZkvmmwKA9S7NK6vlCDCkIqL39JAmR56WMxpPW2u+JJq6PfwTVxbf
	Ah7R1lJU/xAD1nWZWhkgR91SyQhVm7KEv8VhpthSK9I5ENfDnZReJW4gku6NMFgg
	4/jSRyHHToLYOadscWo6bG73Y92cqTcMsBvSFGL2e/gZkDLIDAA+gISTWTq8tke0
	nFkbJw==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 442f2kr40s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Thu, 09 Jan 2025 14:02:22 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-46b3359e6deso1953791cf.2
        for <patches@lists.linux.dev>; Thu, 09 Jan 2025 06:02:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736431341; x=1737036141;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eAyJ5LDtoXr+1R+ZVuoLrayqlcUgbaIUJIcBcCwtzkw=;
        b=e3D7V2JYThGHhTJP2a0wWNt2QNEf4O/jdP2Wy0bFQqrpR0XJXWqbmS/+P14pftKVk6
         9M6h2ELsabMGWCXwwfmsJ/zO4BeqnQpN9Gr4Ri1UqfqVz/b7Io1FyzyYIImmr17R3aBP
         t7Y79ZX65IvRBpCqOBdYiPOmOj37amRoJN/UUN2/81x5Gw4wA6LDmK8TCxIivQ4hE8wy
         axb2relNltJaxC63MEut9My9SJS2yayDNFJs/+HwKKnsp+R+gxvsWt+w1znVro2+8D37
         6H2D7A9g/CMq+2gVb2VnZLgGwaIEWA1VYTmCdGokCDwtHv6xncjognXO6GrjkShZP+Rc
         exBA==
X-Forwarded-Encrypted: i=1; AJvYcCVPwaaXaHOefM/NZP7c+bc5X/x3C21Q5VI4syt23FBBIL6cBt8KCzMq/NgAA3+C6WkZ0nXw+U/I@lists.linux.dev
X-Gm-Message-State: AOJu0YzBmw3E15RoBGNsRLOj6PcueA8o6gtWLTwjIKGbdB4GQ6IXlr2z
	e2DR3ouU0CnWFFL985u6cnPGBdKYM1c3iW+cn0KJgDpKth+6//c6AHeUneaWaN7qp6dvxWRsQWN
	Nz3ZOSbndjwkxvTKeCB/O//C/GlZnbPX8jJnRP7HueEDM+8ayDSRPG7k9
X-Gm-Gg: ASbGncuEheM7Ih0N1E3fQ2QPwNZFFDOyhA63JLKjX77TGcjAuUNKB7OryXH2XGK+uw8
	sDuhIGMjIu8LYMvJDlb5z88xNQkQ+IguDo8LSxkRiNcP70do9UxIdl5r6ScGKhp/mWqktnHNgAt
	Q5LXxBDTQMQ42s8C1zptiZZCDbnDvaeDmZ3m+qq+wNYqU8kmCLpdzk6AqOzGKZKTV58XCiBr0cc
	g4HG+TedpKpJaZ7i6FJvWgZjqHn+Rj/CMZ69TzHQJPE60yi+AsVno5ZhDSlYR1FICe4UaIm1Io4
	qj9g/cc6IdmPoGT5Punax7yutbQUYmCDYak=
X-Received: by 2002:a05:622a:1a9a:b0:467:5fd2:9963 with SMTP id d75a77b69052e-46c71003a8bmr36747531cf.6.1736431340955;
        Thu, 09 Jan 2025 06:02:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHfuF1eKAhLL/sLtGC/6H2TCc4VU3iM2KC7HOi1+w90X9G08zymapAYf8h3dlNECvaehc90FQ==
X-Received: by 2002:a05:622a:1a9a:b0:467:5fd2:9963 with SMTP id d75a77b69052e-46c71003a8bmr36747311cf.6.1736431340455;
        Thu, 09 Jan 2025 06:02:20 -0800 (PST)
Received: from [192.168.65.90] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c90dc0easm75037066b.74.2025.01.09.06.02.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2025 06:02:20 -0800 (PST)
Message-ID: <53b83a66-c0b3-4227-8dcd-022f70810ccf@oss.qualcomm.com>
Date: Thu, 9 Jan 2025 15:02:17 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/6] bus: Extract simple-bus into self-contained
 driver
To: Stephen Boyd <swboyd@chromium.org>, Rob Herring <robh@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, linux-kernel@vger.kernel.org,
        patches@lists.linux.dev, devicetree@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Conor Dooley <conor+dt@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
References: <20250108012846.3275443-1-swboyd@chromium.org>
 <20250108012846.3275443-2-swboyd@chromium.org>
 <CAL_JsqKMcHPhf8yzEZNC6280-k+aSmo3SQOBZLMjmfTR47BH=g@mail.gmail.com>
 <CAE-0n52k0Gg85Ry4KyjE7Ms_dJgj=aPA4aPB5gmC-VGWSNLZXA@mail.gmail.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <CAE-0n52k0Gg85Ry4KyjE7Ms_dJgj=aPA4aPB5gmC-VGWSNLZXA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: _-TKRsEkq3VE57WPHQwu7AWEkyZXe2HV
X-Proofpoint-ORIG-GUID: _-TKRsEkq3VE57WPHQwu7AWEkyZXe2HV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxlogscore=845 clxscore=1015 lowpriorityscore=0
 impostorscore=0 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501090113

On 8.01.2025 11:44 PM, Stephen Boyd wrote:
> Quoting Rob Herring (2025-01-08 06:11:28)
>> On Tue, Jan 7, 2025 at 7:28 PM Stephen Boyd <swboyd@chromium.org> wrote:
>>>
>>> Extract the simple bus into a self contained driver so that devices are
>>> still populated when a node has two (or more) compatibles with the least
>>> specific one being the generic "simple-bus". Allow the driver to be a
>>> module so that in a fully modular build a driver module for the more
>>> specific compatible will be loaded first before trying to match this
>>> driver.
>>>
>>> Cc: Rob Herring <robh@kernel.org>
>>> Cc: Saravana Kannan <saravanak@google.com>
>>> Cc: <devicetree@vger.kernel.org>
>>> Cc: Arnd Bergmann <arnd@arndb.de>
>>> Cc: "Uwe Kleine-König" <u.kleine-koenig@baylibre.com>
>>> Cc: Bjorn Andersson <andersson@kernel.org>
>>> Cc: Konrad Dybcio <konradybcio@kernel.org>
>>> Cc: <linux-arm-msm@vger.kernel.org>
>>> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
>>> ---

[...]

> Maybe the best approach is to simply avoid all of this and drop the
> "simple-bus" compatible from the soc node? It introduces an annoying
> hurdle where you have to enable the new driver that does exactly the
> same thing as "simple-bus" does so you continue to have a working
> system, but it avoids the headaches of trying to make the fallback to
> "simple-bus" work and it would match how new DTs would be written. We
> could make the driver 'default ARCH_<SOC_VENDOR>' so that it gets built
> for olddefconfig users too.

I think it even makes logical sense for the /soc node's compatible to
be.. you know.. the model of the SoC we're modeling

Konrad
