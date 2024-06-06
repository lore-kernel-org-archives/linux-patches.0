Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DA2197A75
	for <patches@lists.linux.dev>; Thu,  6 Jun 2024 15:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717689101; cv=none; b=ryHRpwxByezdE99H2RTUj3h0IjNs1j2mJMOV2NJfXeax+3vFzVVP6mzgcvvyiSbfq8Wmk+e5runOUxyFaz+zLBJoQGU/ccJyYNKznsvx7KFZRgD9uu8GSmj9mF+QHuTiImgJ9Qe45LO0Iz+z7mpmyluDolI8g+/mpiCFJ7U4CqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717689101; c=relaxed/simple;
	bh=vbFi6Ir0YQXvJY5W+Cjh8wTHOqNP+0lx+B5Yq8nTAaY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XoGg3pWvU55nGNEbTW6iBDKMOaW3jAHjs5KyNiaMnKxHOxnRT4IDZVNg687g2p9CDSg1mG49SxfKRjhviSgFmU1D/T58NES9SsiD/DsQT+a96mHSLzAg3brpPMR7EE6I01tscZdVnoVm3XbfMYk+KK3i0cXybn7I8EeYsT1qK7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=n6GBj90x; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="n6GBj90x"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-79532ec4306so53726585a.1
        for <patches@lists.linux.dev>; Thu, 06 Jun 2024 08:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1717689097; x=1718293897; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YTfArhgeqr5paLlpWgE1fa5MPN4uTVnEfjUxQhkMxkY=;
        b=n6GBj90xjU7PkH6AlS/MNIN1o3WaBY1qW2lDlzjt3RsqLpr/sVr1kapILmPTDFSnn9
         eARLtt/6D9Rz7hm6H8OIlfp74CKl0e/OAI52NgZpnPYYfpjuQU5/h4IMIQmsk/GgN1/l
         +sRh0rwLOpuo6UXbca68ia2EqnygOpa/tNCXA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717689097; x=1718293897;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YTfArhgeqr5paLlpWgE1fa5MPN4uTVnEfjUxQhkMxkY=;
        b=VGQwxzLGxnP8ZJwKmIdDukEmeUF5OGWlwwX6RZqZ71bgusIGBHStlESN+eYzcDcFke
         U39Qwo79/DRUz1hAl0v00W93RXUex8Xy9YmsNFKziZaCkdKAv+Fhufy/AZs+ZKtejJ9z
         P+xZOY2UqdOhNVtTXLc4IKbsqDVdDdqGwK39UrogZJKK7hsIhC2VdXQun3qF8bdoij3V
         /gw26KsxKCHsxg0ZV7iWPeoO3phUuLq5/kP5O2/MLZVMoKDglspg3uFgTLx4tbC5NSz8
         BSvcNnkWRDEqshYAV1Cvw+oZdQ1KBwf3avEiQMn0L5Csqn+snOIAiY7iMPG4a+ugjgLX
         6l3w==
X-Forwarded-Encrypted: i=1; AJvYcCURyx22LrVCplHfcNvdznIpYeg375/hztGXc9sWpGN+py5fR89+RSVeqX0fim6XaL7AODjl7n7ud5IZr2Auj92CPjJ/8kMg1Q==
X-Gm-Message-State: AOJu0Yz+fgkWXFNggPxOvPVvPXi9Nf4/QQC/mbrTDxy3NRQ+CIsQ2ber
	KvKpNQcXP2h9owFmUDIJ8+VcSKoxTQfcrl2r3jK6WY6ULB19hA9ttNcUVVdBk6DdfydVippuAGY
	=
X-Google-Smtp-Source: AGHT+IEvLH3pU5WW8+4iDEmowfAjM54+DGZyF3z/mOSyFzbP1KV91sUrTfJlaUgrdqVBhxqsf8AcfA==
X-Received: by 2002:ae9:f81a:0:b0:795:393f:cd46 with SMTP id af79cd13be357-795393fcef1mr83128585a.23.1717689096757;
        Thu, 06 Jun 2024 08:51:36 -0700 (PDT)
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com. [209.85.160.175])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-795328464bdsm71959185a.30.2024.06.06.08.51.35
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jun 2024 08:51:36 -0700 (PDT)
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-44036ce0adaso379241cf.0
        for <patches@lists.linux.dev>; Thu, 06 Jun 2024 08:51:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXdXJ2MV8UEujGxgLKU+FYYMdazZq5uaye11hHwVhBzYxpZpXO+BknG2RXAezc1p2Qy0fCJV0xq78xwTK9MYR3+EtwcLVWiOg==
X-Received: by 2002:a05:622a:4d04:b0:43e:cb4:1d10 with SMTP id
 d75a77b69052e-44037247b8fmr3980461cf.14.1717689094600; Thu, 06 Jun 2024
 08:51:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240604214233.3551692-1-swboyd@chromium.org> <20240604214233.3551692-4-swboyd@chromium.org>
In-Reply-To: <20240604214233.3551692-4-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Thu, 6 Jun 2024 08:51:23 -0700
X-Gmail-Original-Message-ID: <CAD=FV=U9SX20Ckaa2VqwXk=jqjYZvdMMqzXd1jwucPuPXpKkSw@mail.gmail.com>
Message-ID: <CAD=FV=U9SX20Ckaa2VqwXk=jqjYZvdMMqzXd1jwucPuPXpKkSw@mail.gmail.com>
Subject: Re: [PATCH 3/3] arm64: dts: qcom: sc7180-trogdor: Make
 clamshell/detachable fragments
To: Stephen Boyd <swboyd@chromium.org>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>, Bjorn Andersson <andersson@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	patches@lists.linux.dev, cros-qcom-dts-watchers@chromium.org, 
	Rob Herring <robh+dt@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>, 
	devicetree@vger.kernel.org, Pin-yen Lin <treapking@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 4, 2024 at 2:42=E2=80=AFPM Stephen Boyd <swboyd@chromium.org> w=
rote:
>
> At a high-level, detachable Trogdors (sometimes known as Strongbads)
> don't have a cros_ec keyboard, while all clamshell Trogdors (only known
> as Trogdors) always have a cros_ec keyboard. Looking closer though, all
> clamshells have a USB type-A connector and a hardwired USB camera. And
> all detachables replace the USB camera with a MIPI based one and swap
> the USB type-a connector for the detachable keyboard pogo pins.
>
> Split the detachable and clamshell bits into different files so we can
> describe these differences in one place instead of in each board that
> includes sc7180-trogdor.dtsi. For now this is just the keyboard part,
> but eventually this will include the type-a port and the pogo pins.
>
> Cc: <cros-qcom-dts-watchers@chromium.org>
> Cc: Bjorn Andersson <andersson@kernel.org>
> Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
> Cc: Conor Dooley <conor+dt@kernel.org>
> Cc: <linux-arm-msm@vger.kernel.org>
> Cc: <devicetree@vger.kernel.org>
> Cc: Pin-yen Lin <treapking@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  .../boot/dts/qcom/sc7180-trogdor-clamshell.dtsi     |  9 +++++++++
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi |  5 +----
>  .../boot/dts/qcom/sc7180-trogdor-detachable.dtsi    | 13 +++++++++++++
>  .../boot/dts/qcom/sc7180-trogdor-homestar.dtsi      |  9 +--------
>  .../boot/dts/qcom/sc7180-trogdor-kingoftown.dts     |  2 +-
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi  |  3 +--
>  .../arm64/boot/dts/qcom/sc7180-trogdor-pazquel.dtsi |  3 +--
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi |  3 +--
>  .../boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi |  7 +------
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-r1.dts      |  3 +--
>  .../boot/dts/qcom/sc7180-trogdor-wormdingler.dtsi   |  5 +----
>  11 files changed, 31 insertions(+), 31 deletions(-)
>  create mode 100644 arch/arm64/boot/dts/qcom/sc7180-trogdor-clamshell.dts=
i
>  create mode 100644 arch/arm64/boot/dts/qcom/sc7180-trogdor-detachable.dt=
si

Reviewed-by: Douglas Anderson <dianders@chromium.org>
