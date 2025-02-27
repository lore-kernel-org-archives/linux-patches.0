Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A184A1C
	for <patches@lists.linux.dev>; Thu, 27 Feb 2025 04:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740630794; cv=none; b=XhV7X8VYy57URAVNpVMGaue7o24KIidZbWMh3jSEokeQut5W4klNLInjMzcS0cRLehnTZBXsg8IswbYd68N7QvLQPXeeY0CYhM+5hJUCpntzzQIyocEUIbU70sfEpe9ml/MzdSdhixPiscTjhPXhL76yMBLddopiJm0r1Z6RFr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740630794; c=relaxed/simple;
	bh=YtZ5CKgC1l5YAr+QgfvUWGH0Dop2tg9dyuK7ovDLanU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bx99vQQ1PTYr3xM55s4lo8QF5eFHrGgabh/fNT5gdNyUIKb8OaV39h5h0bcQbvSagX5jV0cfgjNXuLdXSSf8n08IwkY/Y8ACNl70iWrEf3I7+OI3iz6lUmMMt1xGUFS3bNrBfE23K/LrsXzzZgy8DGvN9oYwQrNMtwuexs8ivw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KG3Eqhiq; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KG3Eqhiq"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-307c13298eeso6980541fa.0
        for <patches@lists.linux.dev>; Wed, 26 Feb 2025 20:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1740630790; x=1741235590; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=obscijDO91Mt88inTL4A7vtLGjjQitrqKYoQVkgXUGk=;
        b=KG3EqhiqjoOuexv+/Whi4lWuUryMY4lwPtp5raCw7NrgTZle3IHptUMOAk2bCxpItk
         kGTP5vY4IrXnN74fWy3lYlsKuiB9WkE5kZsfH14pru5lc8hNu/GLfcYFVk8Icz2A2SRy
         NOtcTqU9qCXjVyx6eN4aeBDnrMLfniJZBsmM99ejZHDt3JVcHZXkqR8Q5JtzfisJregF
         bHodkiuIG1PsX3KKG9fyMjqUL2/65duKswMiswISfzo9DMn5rol1yLLuRMaEEhnEMfxQ
         EXi11XCG+5yLDCD8U9tJOEiVN+dTjHCkcPjL9fTjyd1O7eYMsZl1dFs80b0i9AAtw/v2
         JPrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740630790; x=1741235590;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=obscijDO91Mt88inTL4A7vtLGjjQitrqKYoQVkgXUGk=;
        b=ltVLGgdDVOVpSBNSnCbygRHqmH4xtUlupuLS67bnaym7uzd808Fj7QjsUC0v/qe+86
         tm3L3k2W9PWHYziJxttVs0qD8LKPIUvPRrEtE1t6nGb8fmRtDGrHLVheri2tdR3I1jFH
         Grap5lXTvZGvThUPO55JD7Z08SNt2ZoGKXoHRHJTzlN4+WzFkVQevm6aUGVsHeXM2b5l
         KQ2PMGfzBrATwpP+xf69pLHEkX56iPKdF6G6o5fmRDFFjMnADw9LpRz5BTLEQ52ORacP
         3e8c6mRcJSa9+ySkJYPDExy+rbsQ0hds4+yktWUfR40+rbvzb3ZOkKkIZkgv6fHGq3x3
         PbQA==
X-Forwarded-Encrypted: i=1; AJvYcCX3glmZLDJkLPw/5HevHHHi3DJ6lxScrSzFxs7+lEnrF8WAIlGMalyy2828Q9usmvNdT0KnZ+tp@lists.linux.dev
X-Gm-Message-State: AOJu0YzGrsCs/Vpj5L7pEA2njdtFVMRdD1VTjA2P+e79kyZy8nmtmQc0
	dd3XiUzau72wrvizcLUS6pgApa1IT2EPttwXim39p0M8q32zDrFOqgSQTyaNQcQ=
X-Gm-Gg: ASbGnct47QHrQN/CcWFGSJNFsua3xyr1WckU8iyMDhHn5pCt/cprf/u/uGoiqI2q5a2
	XdurPKVkrCB3SnF1SEjEF4/NevR2Xev5Tn2oTP6n0AU/ubacHEc2R94MU5SM09GxmsC6pPebA/f
	bcqwZvPXaYnfRZvByJFzXMxmVC6NuAiqDdnZB0M4DxEN/Hte1K7++7Rh5DDh+e7SQUdJX8D8WCZ
	foobmhgHukVWIB46m+ixdaZieNVf9h+Zp7Mf5KenvgHphBQF1fuxqx54/eXwHzTpyrE7iFPpJhC
	cCsO8wA3ZFu+04zwNYNRAOBmoXrXNA9SdYnDapNu54lU3O/jKlfLhnK3UCSpgi1Us5v5mTJnueZ
	BYwoQmQ==
X-Google-Smtp-Source: AGHT+IHn49HjynasOW0d3PE6ed9GscgrGPeAaHZGAfjQ6cYekzKg6vVVq5xB21jaMu9bNtfIFG8yJw==
X-Received: by 2002:a2e:9d0c:0:b0:308:eabd:297b with SMTP id 38308e7fff4ca-30b8464b31dmr7624621fa.4.1740630790326;
        Wed, 26 Feb 2025 20:33:10 -0800 (PST)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--7a1.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::7a1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-30b8685b31fsm610901fa.77.2025.02.26.20.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 20:33:09 -0800 (PST)
Date: Thu, 27 Feb 2025 06:33:06 +0200
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Konrad Dybcio <konradybcio@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	patches@lists.linux.dev, cros-qcom-dts-watchers@chromium.org, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, devicetree@vger.kernel.org, 
	Pin-yen Lin <treapking@chromium.org>
Subject: Re: [PATCH v5 2/2] arm64: dts: qcom: sc7180-trogdor: Wire up USB to
 usb-c-connectors
Message-ID: <nnklm22zfnjiabjsbo7fsdigwx6nbcqjidhzynjyr2aunmk5r2@6m4dj45ddfge>
References: <20250225223038.879614-1-swboyd@chromium.org>
 <20250225223038.879614-3-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250225223038.879614-3-swboyd@chromium.org>

On Tue, Feb 25, 2025 at 02:30:37PM -0800, Stephen Boyd wrote:
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
> Acked-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>
> Cc: Conor Dooley <conor+dt@kernel.org>
> Cc: <linux-arm-msm@vger.kernel.org>
> Cc: <devicetree@vger.kernel.org>
> Cc: Pin-yen Lin <treapking@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  .../dts/qcom/sc7180-trogdor-clamshell.dtsi    |  21 +++
>  .../boot/dts/qcom/sc7180-trogdor-coachz.dtsi  |  47 +++++++
>  .../dts/qcom/sc7180-trogdor-detachable.dtsi   |  16 +++
>  .../dts/qcom/sc7180-trogdor-homestar.dtsi     |  47 +++++++
>  .../dts/qcom/sc7180-trogdor-kingoftown.dts    |  55 ++++++++
>  .../boot/dts/qcom/sc7180-trogdor-lazor.dtsi   |  55 ++++++++
>  .../boot/dts/qcom/sc7180-trogdor-pazquel.dtsi |  55 ++++++++
>  .../boot/dts/qcom/sc7180-trogdor-pompom.dtsi  |  44 +++++++
>  .../qcom/sc7180-trogdor-quackingstick.dtsi    |  31 +++++
>  .../arm64/boot/dts/qcom/sc7180-trogdor-r1.dts |  57 ++++++++-
>  .../dts/qcom/sc7180-trogdor-wormdingler.dtsi  |  47 +++++++
>  arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi  | 121 ++++++++++++++++++
>  12 files changed, 594 insertions(+), 2 deletions(-)
> 

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

-- 
With best wishes
Dmitry
