Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4FC2135D0
	for <patches@lists.linux.dev>; Tue, 14 Jan 2025 23:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736896977; cv=none; b=iiIjGJWvwuiC8HmOl+Jv3QyoVbqMxxr+fsYjVLkqQ8AJ6XjPrhiCMQy3fJkrFOGxrEYgpvSxzdTP38CkK6knC+Ly3VsxUtm6V19G4mhEAou/sLnbuvomlhbf9boPQ2AQKrPADuZ+4xJ+ZEWSUtG24aqj1XN4Ma9FiSdEWgZ+SCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736896977; c=relaxed/simple;
	bh=190YAZ2XHY6FkkWUewXL+8WRF2p39IlXVfSiWtRHOMs=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tnpUjmX9Io/Zz/qcFKP1NwsTAMrksghKL05WwmWxvfw+vU0/nuGFrUK+31YVpVWd7RCehsmfbFEYl8uCJJaV2przkpPc+hrYazK+VXVlMyRPdykVgx1PEeTWQvEZfYNsRW9MlPRgl/EAk0lp6DrH4A7OvZDQqHaMd1YIXJrT7OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=RIweNIVN; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="RIweNIVN"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7b6e9586b82so514269485a.1
        for <patches@lists.linux.dev>; Tue, 14 Jan 2025 15:22:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1736896975; x=1737501775; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C7Lgxko9uVGZsuMx2gafWthQbaIDbF0yPzFdPsX8fXI=;
        b=RIweNIVNGJhNzeZ3HP7mBDHD7uY6grr4CGVL6l6hcftwHx6+34aCA1E3y5nIc48b3W
         iQGVlp50uxt5DX/Tzz5qAN5jVIm74HZr/uOvPsvPJDCkW8eZhaEQh1Wn7/KaS1GNhded
         qiY6wwpWEMQz2NatcjAHGlvKY8kiVEPGHHjVE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736896975; x=1737501775;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C7Lgxko9uVGZsuMx2gafWthQbaIDbF0yPzFdPsX8fXI=;
        b=qNLKRjzehdEdiIztOQQ0iAJOcKtlwcEvUOumkrWbf2Ko8tcHnhf/nzFL/PKZ4J8Stl
         /iimi2UN4EpFAoxCNdjoZuaCRhWNr8bX0Y5B8WbXLjqhaFI9ZUkQK3a/YgypAOU7koc1
         Vsz8b4hlyZ/P2q0+q68fjyqJ5sW51LtNp8QmkOFQqDShAIw0SrUys1u3q4zQlXyz7yOW
         NM1djnZgiLYGS+9mnn+Vv1pMUkhARYSG3HxCpMG110QBxLvlHg6T30OPqcwN1eLn3Alp
         JFU0UWjYH1mH5IKj+hDNnCsj3x6rxmR9HQoJX4qu04ayv9FYAaZcsggwWAsl0w2SAD66
         kn4g==
X-Forwarded-Encrypted: i=1; AJvYcCUwnKLc2WBHfnn5tH2/cLf5m3oNADPUzuORA08/tw9Bo7akWgimllCZCsn7utBHRpBOpJBcwSWA@lists.linux.dev
X-Gm-Message-State: AOJu0Yzkg0+V5w6sgs1QcGOilqQZGNF3oYPMoxW9x3F8GgZnDMtdVfgR
	tapfITHdmXQZN7Qgw8ga9uDYtS2aTazPQBD40CSbOLvKbpcVbIpF3HPBFVbG9mR83im6wVCxsGK
	z3K/ZfRUvxPDiSyU0up4TrFUp/1BaR3zNIicm
X-Gm-Gg: ASbGncufkoPKT02VN1vRixgLejrjCC4bU84j1ol9MtT0IdB4xdBzenr9E5+BX6QDfCa
	j9WbMaJU1V72zeXXdTbc8C162z501stgHUTBuj89WV1+vRtJyotItYjnD5KHgRrNlXg==
X-Google-Smtp-Source: AGHT+IH1kgTUMPnbtiGBciMBLmycdZKmyXxo9rET57i4jmCQr51jzLWHtQ8uJQmtzyihKUb4hk4pgWE1ZPT8zcHMCVw=
X-Received: by 2002:ad4:5c68:0:b0:6dd:4c5f:b3d1 with SMTP id
 6a1803df08f44-6df9b1f6e3amr412156276d6.3.1736896975019; Tue, 14 Jan 2025
 15:22:55 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 14 Jan 2025 15:22:54 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250110135843.GA2630182-robh@kernel.org>
References: <20250108012846.3275443-1-swboyd@chromium.org> <20250108012846.3275443-3-swboyd@chromium.org>
 <7a64e927-235b-4d63-af59-f2c80464a9a1@oss.qualcomm.com> <CAE-0n53wX99ry88zOOuq6SPVpraiENheJ1T+HZri82x4gqZJ_w@mail.gmail.com>
 <20250110135843.GA2630182-robh@kernel.org>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.12.dev1+gaa8c22fdeedb
Date: Tue, 14 Jan 2025 15:22:53 -0800
X-Gm-Features: AbW1kvZZEICi_ElffHdcdM5qCntX3rhUy_7MsF-zN--bVSuif1_AJXoaGEXBpfg
Message-ID: <CAE-0n50yP2qwvC6nWph4XT2bvDmd4rwrC-Omx33Q4z96r1bmoQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/6] dt-bindings: bus: Add qcom,soc-sc7180 SoC
To: Rob Herring <robh@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, 
	Konrad Dybcio <konradybcio@kernel.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, devicetree@vger.kernel.org, 
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, linux-arm-msm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>, 
	Conor Dooley <conor+dt@kernel.org>, Saravana Kannan <saravanak@google.com>, 
	=?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@baylibre.com>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Rob Herring (2025-01-10 05:58:43)
> On Thu, Jan 09, 2025 at 01:51:12PM -0800, Stephen Boyd wrote:
> > Quoting Konrad Dybcio (2025-01-09 06:05:14)
> > > On 8.01.2025 2:28 AM, Stephen Boyd wrote:
> > > > +
> > > > +  '#size-cells':
> > > > +    const: 2
> > > > +
> > > > +  clock-controller@100000:
> > > > +    $ref: /schemas/clock/qcom,gcc-sc7180.yaml#
>
> This makes the above schema be applied twice. Once here and then when
> the compatible matches. That can be avoided by just listing a
> compatible. The QCom display bindings follow that style.

Cool thanks!

>
> > > > +
> > > > +  watchdog@17c10000:
> > > > +    $ref: /schemas/watchdog/qcom-wdt.yaml#
> > > > +
> > > > +required:
> > > > +  - compatible
> > > > +  - '#address-cells'
> > > > +  - '#size-cells'
> > > > +  - clock-controller@100000
> > > > +  - watchdog@17c10000
> > > > +
> > > > +additionalProperties: false
> > >
> > > ..this approach will make any dt node addition under /soc require
> > > an additional bindings change, which sounds like absolute madness
> >
> > We should pretty much know what nodes go under here though, because it's
> > a chip that exists and doesn't change after the fact. I agree that it
> > will be annoying during early development when everyone is modifying the
> > same file to add their node, but that problem also exists with the dts
> > files today so it doesn't seem like total madness. It's also nice to be
> > able to look at one file and quickly find all the schemas for the SoC
> > used, like a table of contents almost or a memory map for the chip.
>
> I don't really care for listing everything either.
>
> We could just generate all the schemas used. Either "give me all the
> schemas matching some compatible patter" or "give me all the schemas
> used to validate the DTB". The latter was possible on a per node basis,
> but I think I dropped that when I changed how we select schemas to
> apply.

It is good enough to list compatible and properties like address-cells
and size-cells and then have patternProperties requiring '@' in the
name?

>
> Speaking of memory maps, I would like a tool which could dump memory map
> from .dts. My primary reason is to find overlapping regions.

Sounds cool. I don't have any need for that though so I'm not going to
jump at writing such a tool.

>
> > One thing that I find annoying is that you have to put the whole soc
> > node and child nodes in the example. Maybe we can omit the example
> > because there are so many child nodes.
> >
> > >
> > > I think additionalProperties: true would be sufficient here, like in
> > > Documentation/devicetree/bindings/soc/imx/imx8m-soc.yaml
> > >
>
> No. You can do:
>
> additionalProperties:
>   type: object
>
> Or a patternProperties entry requiring '@' in the name.

This is to make sure only child nodes can be added, right? I like
checking for '@' in the name so that random nodes can't be added that
don't have a reg property.
