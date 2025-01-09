Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FA318132A
	for <patches@lists.linux.dev>; Thu,  9 Jan 2025 23:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736466354; cv=none; b=DS4lAULKm29ZbxBqZZAy6jztOh9/9uPMBt/ndqgaMu1ahE9HBKn5ROuLFJMdriGj7YQf7QoEZdfmTn83Ywzy6Drv6NX/BL+WeDmwz6X2kfo0DKjr8RK2Fre2CfmlMNR/wrfVSV0gh/TAYlKIiEWTN1EQOaX/hWqf/HLroiTZsw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736466354; c=relaxed/simple;
	bh=8Fn5tpVxQQ8gfYVSYC9d+1uDg2CraF9og34DhkJKWIw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RRS1VTee0/REYcJ2De5ermAry4BQv+nq4GUZFWQBlKTP+13du/RcRtUBQ0VWbxtWJe7B5ZrmuoM5Ett0GnpG/QAUSvym2cLH1NjOg5BZh8xKLjcnfxLrkQ9vIrW+5G15Iu4VoGbelVXHODxXU4xLD5qAxeBzm9hWdMTLdDoAMYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TPAeRLTX; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TPAeRLTX"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-53df80eeeedso1417555e87.2
        for <patches@lists.linux.dev>; Thu, 09 Jan 2025 15:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736466351; x=1737071151; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ifd3ai3biKTaNdzvBUxlg/E6YILRTZjA+4tT653tYFI=;
        b=TPAeRLTXaUZplyGIZsw6vUR0aYmXJzwK7LydnJ43eHwzEi8eyaEj/nLm0h4Ors8GEK
         saQmbJeCLPBCRjn+Lo0jUHw/zWgFyBI37nBTvReY6w/cNtMcw3VnaXYHBiZ8V1C8xHFd
         UXjVJPCiVMqj3Ekv7S1LSVn/mq6mYKSjAFtVCvNoEH+SemoK2c4XsW8l76I7AOWcVbun
         ss8kHTCJl8U60gaGh9h9/9JgkBCAxfYzEsfpjrVBRbWaX/zLDaJ3wOIaViZj9JlHzi8G
         zVwkiVYw0MQJwg/BJ+01oqajCg+dzb41YDhcTkN+bILsak29+JBxVv0SrsHiPW/hufsq
         O62Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736466351; x=1737071151;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ifd3ai3biKTaNdzvBUxlg/E6YILRTZjA+4tT653tYFI=;
        b=dhmJ7rs0Ijh/sBRUJY6oqb8ufn7G+FmQJ7BYttGkZYJAwVPvzYQ83i+sJ4zvWxq3R2
         36mi1Ig3iWvHbftl3JOExx/kLjNJ11fXYkIvnlqZkWGGT8ztCBxIaPyXsYyvONOlMhbM
         MM5MNOzROJRfjUwuH5f2bSOjF4IpyUCkkEi+G+g9wWS2PfzKf1165tpL/UhqMZhLtFNr
         sr1Qh+H4vSuvCmHiQDULx4C4dRIC4gOA53+AEAQsCT7l9J1gmGBwlIooDSctXnyEXUhb
         Z7yIVkGYixwLWb6hFRV61XFcx7+bneHPtDkBln9bP/qSlQ2LoLB09zKb76xCQwVqtRN4
         BMBg==
X-Forwarded-Encrypted: i=1; AJvYcCVxQCqdlhSzMzwEZJvQmfLJ2cOtwS7q57m/NzgJQsBbhFAdZ0f0nlMUsmAOSG8IgeasI2SzWfxD@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0tUqp21eitGqA9SfJB3Nxsr++gqf4t3otfkGvgWq0hQRyb1jV
	kr+3r4phnAVadLrGzF4og6tlm3WwiSRwU58MAWz7YCFAH2gNZQe+Dcmjnx5mh3U=
X-Gm-Gg: ASbGncvvk2mDv2JYJCHoDqk8zlrKog7iTIOaNY4mDQZH4J/8aSQ9dKoWJHtwmifdH/9
	GR5MsDlJupnfkiruBDtwjHV8sA6mzA/LTKlE7X+kaGZBQZOiCjLNMag7mx1gjW7gF7mfE4aCyrL
	8c3HIoI07jdsEOP6TJmBiBKJjtXh+xbPdNweoUWWaHDfV6LXkOCQIYfkKAd3TNMXNA9PPXKheQI
	TlBclzd735vd9ctzIpLjXZuN/W/D+O0blx83Gr5dsydV/dbm6O1BvcYJWGpwvh6oeOCvWKXrIO5
	sR48LkyjbazE9KWij8zotGHQ/qxU9Qe39j2r
X-Google-Smtp-Source: AGHT+IFE0TD0xLOUiVIfjJiuGh9UVHHNy8CtrSGHCWyGYMHymyrvfqIdJCqZCoyf+hgFwIwzU5DqeQ==
X-Received: by 2002:a05:6512:2205:b0:540:2542:cba6 with SMTP id 2adb3069b0e04-54284527758mr2364630e87.21.1736466350748;
        Thu, 09 Jan 2025 15:45:50 -0800 (PST)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--b8c.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::b8c])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5428becaac3sm333191e87.229.2025.01.09.15.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2025 15:45:49 -0800 (PST)
Date: Fri, 10 Jan 2025 01:45:46 +0200
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: Stephen Boyd <swboyd@chromium.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, devicetree@vger.kernel.org, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Rob Herring <robh@kernel.org>, linux-arm-msm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>, 
	Conor Dooley <conor+dt@kernel.org>, Saravana Kannan <saravanak@google.com>, 
	Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
Subject: Re: [RFC PATCH 6/6] arm64: dts: qcom: sc7180: Add SoC specific
 compatible to soc node
Message-ID: <x6smfgtq2ojzl774jd6d6fsilxj5dte4jbfypbvxvdmaqd7pem@nnpcnyzz4l4i>
References: <20250108012846.3275443-1-swboyd@chromium.org>
 <20250108012846.3275443-7-swboyd@chromium.org>
 <n3fn5mnrrinrgrvadqgymv3cx355qpx5kk27nlrz2emoxfmjyt@ymwpfxf7lv4r>
 <0ab00013-0265-4336-bc30-f49492e96424@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ab00013-0265-4336-bc30-f49492e96424@oss.qualcomm.com>

On Thu, Jan 09, 2025 at 03:10:33PM +0100, Konrad Dybcio wrote:
> On 8.01.2025 2:02 PM, Dmitry Baryshkov wrote:
> > On Tue, Jan 07, 2025 at 05:28:43PM -0800, Stephen Boyd wrote:
> >> Allow an SoC driver to probe for these devices. Add the SoC specific
> >> compatible to the soc node. Leave the original simple-bus compatible in
> >> place so that everything keeps working.
> >>
> >> Cc: Rob Herring <robh@kernel.org>
> >> Cc: Bjorn Andersson <andersson@kernel.org>
> >> Cc: Konrad Dybcio <konradybcio@kernel.org>
> >> Cc: <linux-arm-msm@vger.kernel.org>
> >> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> >> ---
> >>  arch/arm64/boot/dts/qcom/sc7180.dtsi | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
> >> index 76fe314d2ad5..257890a193e6 100644
> >> --- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
> >> +++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
> >> @@ -782,7 +782,7 @@ soc: soc@0 {
> >>  		#size-cells = <2>;
> >>  		ranges = <0 0 0 0 0x10 0>;
> >>  		dma-ranges = <0 0 0 0 0x10 0>;
> >> -		compatible = "simple-bus";
> >> +		compatible = "qcom,soc-sc7180", "simple-bus";
> > 
> > If the new driver requires this compatible, it will break compatibility
> > with older DT files (and it should be avoided).
> 
> IIUC the intent here is to provide backwards compatibility through checking
> for sth like IS_SOCPM_MANAGED(), sorta like HAS_ACPI_COMPANION(). In that
> case, power sequencing would be done by the socpm driver, whereas if it
> doesn't hold, the resources would be toggled by the device driver

I think that this way we end up having PM code both in the device driver
and in the socpm. Ideally in my opinion we should be able to migrate all
pm code to socpm, keeping compat with old DT files. In the end, if this
is the only change to the SoC.dtsi, then we should be able to live
without this compat change.

-- 
With best wishes
Dmitry
