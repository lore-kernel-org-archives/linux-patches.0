Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678A31CBE8B
	for <patches@lists.linux.dev>; Tue,  1 Oct 2024 17:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727803690; cv=none; b=eKhq0u9LI8nnGyvZ/SIRSCT0Ty7fkRgiC/UDGQlXfpZCczh5AdhVj91KIpjJT5V0cSQDqNkD2VNvIpTXx57FhT37zjPiVIOdY/fHu+t2y3WLu0smo8Dj9iJxemBr39wXvvfWiff8jDrobMuyR0gxbszngYs37renSaQtj8nsUmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727803690; c=relaxed/simple;
	bh=XbgmZwyb1H1QKAtJCYiTNrZ6tZzvq/vwTc/xyKudu7o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=suGJn5xnWpGRENDAuMDMsCsLpcqwe2u2jaLY2GafYGMHjNPN2wuxCqDJemyRrLUFzJ6vXm8M+UgYzY9K4AvaW+JlUcKnYrC1xSBkklLYWvDvrTdkWxQ2HdZKMSwr3ZZmi3WT+0meF3M/6jyQjQdyJYORzyL668kNXLxxosZeQ4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HLfXrgro; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HLfXrgro"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a8a7903cb7dso512511266b.3
        for <patches@lists.linux.dev>; Tue, 01 Oct 2024 10:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1727803687; x=1728408487; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TsUX7CM10TaWxwkWgkusEjk7ICdS5H0gqcjn5rK2sCw=;
        b=HLfXrgroJwi4fK34JNkboXLw3o5HbIWM/MWU6Zg2KgyHT2adcWgprMpQxJQzd2OcAm
         mwC8yqLW9KIRBcSDUnJ390+zKrBxVi+/tqkM30CfrDcolOg7jjw5V4Vpqhy4AncvEusm
         P/hUrp5KyJkfLubGrK0Tz+Uy4u/L5dWIwl4YkP4ALnjw4/G+ntWiH0CSqEl6aDDBmToZ
         gCyXoDtmNVwd28B7lQ/gsYOvXXnQqHgLgGi0BipsyIUaJuh178XnrMSx8Ztg8S6s6wyO
         Hzi4Qld6PCw7ZxzsB1RELsRLrIQCQQjLRx0nonPyMGxo5cBBM4yi5nl33okKqOAIwiLj
         F4gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727803687; x=1728408487;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TsUX7CM10TaWxwkWgkusEjk7ICdS5H0gqcjn5rK2sCw=;
        b=ieV2eqWZl8N2GnHqAvJUybwX7coYD63WuXDiO40y0QmM9H1+pQ1IID9d1o8rrgxH1c
         Rwj8libxy4zWWwL24C9mlIssWjPAowbR5j/yeGvRc8b4LeOBTW4dAWuX2RLUUoY+dkWd
         X8n08WlCDEpA9dRHoPYH0Vlne7VhKku/O2jJcjN6Qp5phiAvNaDjlm9Y8qwhQCzfE+el
         MFzKsjUj8BEB4RWixwqbLogsu21mGISkFs3Bcy2rs1u5oRYQE54PY8OhkXdHct0rN0Yw
         Tszv+45ZBe2Gcj9bNCUqRDiWMHGu1+gscaZ+zj2UhAxdz5rYa4AKwjbb0IpLmKtvpJuc
         oCsw==
X-Forwarded-Encrypted: i=1; AJvYcCUJ+2AGaJW5TIqVYeEohjpMs/zpi5pyJZNl+eq6YHbEzT/oMvm9xsUbSp6tglBopollTvSV7n+6@lists.linux.dev
X-Gm-Message-State: AOJu0YwWC6pOM3uAdOUiTRPQ0QM5OT8JbiyYpRfCPgracJuUAwBY8cK/
	zK9uIonEhIbVznuZV64YpGwXNYD5KqGHc/xuoWVpAf1U6+aZVY8b+DgDouC/WgtqCNggRmo/gTP
	iRJjwHvRKe68qMqrEvXkxR8wl6U/M/HhWEI9NYg==
X-Google-Smtp-Source: AGHT+IHenDgfYzeJtdxZkt83AOPuWN3YnTpgSh/ORhX0cttRHbgCmSq7UM2L3p+I9VPp69r/CFp5dc8faU1Wtxkq2YY=
X-Received: by 2002:a05:6402:4002:b0:5c7:1f16:78e3 with SMTP id
 4fb4d7f45d1cf-5c8b1b65519mr158707a12.22.1727803686530; Tue, 01 Oct 2024
 10:28:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240730151615.753688326@linuxfoundation.org> <20240730151617.057892121@linuxfoundation.org>
In-Reply-To: <20240730151617.057892121@linuxfoundation.org>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Tue, 1 Oct 2024 22:57:55 +0530
Message-ID: <CAO_48GGH0J9z3NCq=jH5PKQewPdrhUiNk-Bu9yKvX8yhsTWDtQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 033/440] arm64: dts: qcom: sm8250: switch UFS QMP PHY
 to new style of bindings
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Konrad Dybcio <konrad.dybcio@linaro.org>, Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, 
	Bjorn Andersson <andersson@kernel.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hello Greg,

On Tue, 30 Jul 2024 at 21:25, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.1-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>
> [ Upstream commit ba865bdcc688932980b8e5ec2154eaa33cd4a981 ]
>
> Change the UFS QMP PHY to use newer style of QMP PHY bindings (single
> resource region, no per-PHY subnodes).

This patch breaks UFS on RB5 - it got caught on the merge with
android14-6.1-lts.

Could we please revert it? [Also on 5.15.165+ kernels].
>
> Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
> Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Link: https://lore.kernel.org/r/20231205032552.1583336-8-dmitry.baryshkov@linaro.org
> Signed-off-by: Bjorn Andersson <andersson@kernel.org>
> Stable-dep-of: 154ed5ea328d ("arm64: dts: qcom: sm8250: add power-domain to UFS PHY")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/arm64/boot/dts/qcom/sm8250.dtsi | 20 ++++++--------------
>  1 file changed, 6 insertions(+), 14 deletions(-)
>
> diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
> index 3d02adbc0b62f..194fb00051d66 100644
> --- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
> @@ -2125,7 +2125,7 @@ ufs_mem_hc: ufshc@1d84000 {
>                                      "jedec,ufs-2.0";
>                         reg = <0 0x01d84000 0 0x3000>;
>                         interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>;
> -                       phys = <&ufs_mem_phy_lanes>;
> +                       phys = <&ufs_mem_phy>;
>                         phy-names = "ufsphy";
>                         lanes-per-direction = <2>;
>                         #reset-cells = <1>;
> @@ -2169,10 +2169,8 @@ ufs_mem_hc: ufshc@1d84000 {
>
>                 ufs_mem_phy: phy@1d87000 {
>                         compatible = "qcom,sm8250-qmp-ufs-phy";
> -                       reg = <0 0x01d87000 0 0x1c0>;
> -                       #address-cells = <2>;
> -                       #size-cells = <2>;
> -                       ranges;
> +                       reg = <0 0x01d87000 0 0x1000>;
> +
>                         clock-names = "ref",
>                                       "ref_aux";
>                         clocks = <&rpmhcc RPMH_CXO_CLK>,
> @@ -2180,16 +2178,10 @@ ufs_mem_phy: phy@1d87000 {
>
>                         resets = <&ufs_mem_hc 0>;
>                         reset-names = "ufsphy";
> -                       status = "disabled";
>
> -                       ufs_mem_phy_lanes: phy@1d87400 {
> -                               reg = <0 0x01d87400 0 0x16c>,
> -                                     <0 0x01d87600 0 0x200>,
> -                                     <0 0x01d87c00 0 0x200>,
> -                                     <0 0x01d87800 0 0x16c>,
> -                                     <0 0x01d87a00 0 0x200>;
> -                               #phy-cells = <0>;
> -                       };
> +                       #phy-cells = <0>;
> +
> +                       status = "disabled";
>                 };
>
>                 ipa_virt: interconnect@1e00000 {
> --
> 2.43.0
>
>
>
>

Best,
Sumit.
