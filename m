Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369F01CBE91
	for <patches@lists.linux.dev>; Tue,  1 Oct 2024 18:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727805678; cv=none; b=MpT0U60l/mjBETSO1cd2Skq2h6jTHdbynnu1x8O8MQNw4v7rAdf3fNzK75nVuU2G3AiZMkeLqcaRkmNcyvB8oyBqU4bh2Zf8+ITb8uJ9ZFSU4vBMf7Sa8lEKzcRpS3xHeaLgEO0r6ctAGECaN2kv9vj12MJQhn//Cs6SnkBRynQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727805678; c=relaxed/simple;
	bh=9opfw5OJisVf3HyMd+OR4HHKd7kdf6Gf9d54RuKdt0k=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=jmx8/QP5MOUC8DQ7Op4YlGkdQGMTeaZUQQj/N1aCEWh6aOqyJcQDEYT4zH6Pq2LM2gLVFx1U8TzN1xtJBehG7SyYYZW5gTZZwSRLIeck8iDZRMNVbk6ZG9tbvV1+4MAjKxP/G5NscB3Bpgz6eJev2FFtZ7kSdGtb977E3DzcN1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=w46qmzyT; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="w46qmzyT"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a8d2b24b7a8so10401866b.1
        for <patches@lists.linux.dev>; Tue, 01 Oct 2024 11:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1727805674; x=1728410474; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jptlZ50vNnkPMBXPAhGWdUP4XKEwnHdYTuJjE+Q5IPM=;
        b=w46qmzyTpnKKvouRLjyMep2xYVwc9YqlwxznJh58qppKLbwACaeeb6USDArrmQE5+8
         rqW4+FqdKAk7mDjyS5gnjheoBmNk1REeV1tugz6w7Nitw2suApv6vOETeIV1J7bFfY2e
         rirI5lE6WMCIisYJgPYVKpfANC38vKMMRSyD5v2MdbQpUIX5bBxfUi/mmisy7fmfzGTe
         xqCd+bKmbf/s/zoAHjJbqtizXeXjVsMCIHqqic0WH2HoGMYW6v/PMo789XpjjjZB4jrY
         tjCxUwQeA57pA7F1dvkQ2iLes7gozqcF2RlKk1NugunrAQTPxpS1rqJ0ihk5JEVnmMbt
         9PvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727805674; x=1728410474;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jptlZ50vNnkPMBXPAhGWdUP4XKEwnHdYTuJjE+Q5IPM=;
        b=Ep17c2ybRoht4tdZ7TaMZz33HBrj7SsX9yj4LYQ1Xpr4wdYr648BN0NBoV5v/kvsEU
         cfxKd8ZjZuhzIRbeOkdoXXhm7Lu4WI564DSnMdmCsCiSjNS0DPEpv+x8w9x9I9cxUNcS
         XZbi9TMLcBCVWa58iIIkGG3Mc8n8AKv78j7xkTS3rhEH3vJd/vrZ9ipttgpcBIwYrCf5
         VR4BdNwcHyfwqMRF00W3UYN1TsFNJ/gdXp29PHAkEjMn/czySlr54HxVZt8aNUL0qqsN
         lcSSC+q+woL2yUJuSQO0aoYxq+6b8CY/Nz7yYqebIhPB3EQGBHTuYS9hDIby9LEpAn+9
         vpxA==
X-Forwarded-Encrypted: i=1; AJvYcCVjoFVt34UvVRxghrTqPzYZzfGWxjLXHw/NNRwI33pTLurCFX9UmduWiG+G4YTMtqHuaAcZzbvw@lists.linux.dev
X-Gm-Message-State: AOJu0Yzdqgt2knwDR3LTskVGOYc57uw7zIrqV0M8jP9JYp9Urw+JAmW+
	3jVxsmQAh7Ipx9TQwZd0ivRd/0v+gTfRDHB3r0t7vwapMDKSSMU6Qg5dv2/Nzfs=
X-Google-Smtp-Source: AGHT+IGCr+0ApwlkapkpKYOKNPQiSoHfsxeAKoCUk5AOKVznJjFx8qEFLq+28yh+N27Q7W7VO79Cpw==
X-Received: by 2002:a17:907:f1df:b0:a86:9fac:6939 with SMTP id a640c23a62f3a-a98f8387b16mr45918466b.30.1727805674417;
        Tue, 01 Oct 2024 11:01:14 -0700 (PDT)
Received: from [127.0.0.1] ([37.155.79.147])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a93c27cafc8sm745435966b.84.2024.10.01.11.01.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Oct 2024 11:01:13 -0700 (PDT)
Date: Tue, 01 Oct 2024 21:01:09 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To: Sumit Semwal <sumit.semwal@linaro.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: stable@vger.kernel.org, patches@lists.linux.dev,
 Konrad Dybcio <konrad.dybcio@linaro.org>,
 Bjorn Andersson <andersson@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_6=2E1_033/440=5D_arm64=3A_dts=3A_qcom=3A_sm82?=
 =?US-ASCII?Q?50=3A_switch_UFS_QMP_PHY_to_new_style_of_bindings?=
User-Agent: K-9 Mail for Android
In-Reply-To: <CAO_48GGH0J9z3NCq=jH5PKQewPdrhUiNk-Bu9yKvX8yhsTWDtQ@mail.gmail.com>
References: <20240730151615.753688326@linuxfoundation.org> <20240730151617.057892121@linuxfoundation.org> <CAO_48GGH0J9z3NCq=jH5PKQewPdrhUiNk-Bu9yKvX8yhsTWDtQ@mail.gmail.com>
Message-ID: <F1136AC5-0860-4070-B4FA-86BAEFC070FB@linaro.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On October 1, 2024 8:27:55 PM GMT+03:00, Sumit Semwal <sumit=2Esemwal@linar=
o=2Eorg> wrote:
>Hello Greg,
>
>On Tue, 30 Jul 2024 at 21:25, Greg Kroah-Hartman
><gregkh@linuxfoundation=2Eorg> wrote:
>>
>> 6=2E1-stable review patch=2E  If anyone has any objections, please let =
me know=2E
>>
>> ------------------
>>
>> From: Dmitry Baryshkov <dmitry=2Ebaryshkov@linaro=2Eorg>
>>
>> [ Upstream commit ba865bdcc688932980b8e5ec2154eaa33cd4a981 ]
>>
>> Change the UFS QMP PHY to use newer style of QMP PHY bindings (single
>> resource region, no per-PHY subnodes)=2E
>
>This patch breaks UFS on RB5 - it got caught on the merge with
>android14-6=2E1-lts=2E
>
>Could we please revert it? [Also on 5=2E15=2E165+ kernels]=2E

Not just this one=2E All "UFS newer style is bindings" must be reverted fr=
om these kernels=2E


>>
>> Reviewed-by: Konrad Dybcio <konrad=2Edybcio@linaro=2Eorg>
>> Signed-off-by: Dmitry Baryshkov <dmitry=2Ebaryshkov@linaro=2Eorg>
>> Link: https://lore=2Ekernel=2Eorg/r/20231205032552=2E1583336-8-dmitry=
=2Ebaryshkov@linaro=2Eorg
>> Signed-off-by: Bjorn Andersson <andersson@kernel=2Eorg>
>> Stable-dep-of: 154ed5ea328d ("arm64: dts: qcom: sm8250: add power-domai=
n to UFS PHY")
>> Signed-off-by: Sasha Levin <sashal@kernel=2Eorg>
>> ---
>>  arch/arm64/boot/dts/qcom/sm8250=2Edtsi | 20 ++++++--------------
>>  1 file changed, 6 insertions(+), 14 deletions(-)
>>
>> diff --git a/arch/arm64/boot/dts/qcom/sm8250=2Edtsi b/arch/arm64/boot/d=
ts/qcom/sm8250=2Edtsi
>> index 3d02adbc0b62f=2E=2E194fb00051d66 100644
>> --- a/arch/arm64/boot/dts/qcom/sm8250=2Edtsi
>> +++ b/arch/arm64/boot/dts/qcom/sm8250=2Edtsi
>> @@ -2125,7 +2125,7 @@ ufs_mem_hc: ufshc@1d84000 {
>>                                      "jedec,ufs-2=2E0";
>>                         reg =3D <0 0x01d84000 0 0x3000>;
>>                         interrupts =3D <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH=
>;
>> -                       phys =3D <&ufs_mem_phy_lanes>;
>> +                       phys =3D <&ufs_mem_phy>;
>>                         phy-names =3D "ufsphy";
>>                         lanes-per-direction =3D <2>;
>>                         #reset-cells =3D <1>;
>> @@ -2169,10 +2169,8 @@ ufs_mem_hc: ufshc@1d84000 {
>>
>>                 ufs_mem_phy: phy@1d87000 {
>>                         compatible =3D "qcom,sm8250-qmp-ufs-phy";
>> -                       reg =3D <0 0x01d87000 0 0x1c0>;
>> -                       #address-cells =3D <2>;
>> -                       #size-cells =3D <2>;
>> -                       ranges;
>> +                       reg =3D <0 0x01d87000 0 0x1000>;
>> +
>>                         clock-names =3D "ref",
>>                                       "ref_aux";
>>                         clocks =3D <&rpmhcc RPMH_CXO_CLK>,
>> @@ -2180,16 +2178,10 @@ ufs_mem_phy: phy@1d87000 {
>>
>>                         resets =3D <&ufs_mem_hc 0>;
>>                         reset-names =3D "ufsphy";
>> -                       status =3D "disabled";
>>
>> -                       ufs_mem_phy_lanes: phy@1d87400 {
>> -                               reg =3D <0 0x01d87400 0 0x16c>,
>> -                                     <0 0x01d87600 0 0x200>,
>> -                                     <0 0x01d87c00 0 0x200>,
>> -                                     <0 0x01d87800 0 0x16c>,
>> -                                     <0 0x01d87a00 0 0x200>;
>> -                               #phy-cells =3D <0>;
>> -                       };
>> +                       #phy-cells =3D <0>;
>> +
>> +                       status =3D "disabled";
>>                 };
>>
>>                 ipa_virt: interconnect@1e00000 {
>> --
>> 2=2E43=2E0
>>
>>
>>
>>
>
>Best,
>Sumit=2E


--=20
With best wishes
Dmitry
