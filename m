Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1C8205E1B
	for <patches@lists.linux.dev>; Thu,  9 Jan 2025 21:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736459475; cv=none; b=Ib55tk82caAp87+f+QyOHada8ogreWfe6qoGdzzT7c07cmnukI7B4m2as/QWy7SPNKz17z9zCjQseqkXqE1PVfGaAsvGOs+tusvEh96oh3tuufdwvumKkbKyJUqx2z8pPtyytvOWIdkO7PPcg0NFcg2R7NXoEwQoaEdAUjNdfeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736459475; c=relaxed/simple;
	bh=CElMYEkewd0tVTEnVebZdRenNcR6Cp3fNthUabpeidA=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I7R4V1vlIfHF9QWk1YTDMSDNxnh8pAOnMU0cnYcAwyjyNSqMNkDtXh5UNjAN94BG8/Efb7rZZKd29JR3e8vEUZFcoqW4vfe6a0KdgMLk3p0zNdP5h71jTmtqQZs9jlPKR/XyU7P6Fza7CSMBnkqHw/1snMNKH/k9uTYoFiMRkP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=neTLlNZe; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="neTLlNZe"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-6dcdf23b4edso11789216d6.0
        for <patches@lists.linux.dev>; Thu, 09 Jan 2025 13:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1736459473; x=1737064273; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ij7chTR52mv9qNBFCE2hpAp3mYEyNOHKiG4EkXfOeAU=;
        b=neTLlNZeaSinXwU+oRlMEZTXFJUKZDm5yJ12FEuzvzgbwo9kqWlfNiKEFfY4INntRU
         d+bqf7ZCvikBO3C5u2mWqi4aXfPXKnn++mglxFLrrdiNgseCfsOQJjTN0I7rZVDekx3k
         t/KWvwIbX6wuqD+Nk21gfJV4Nc2SLRuX+Teyw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736459473; x=1737064273;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ij7chTR52mv9qNBFCE2hpAp3mYEyNOHKiG4EkXfOeAU=;
        b=CtZkdgP+N4DkNlCVc0llSHXtmbDLCMVYGKfKQRivQv7J7M+avZBIFu81EON8vVS4g9
         lGHp41insHa77lmANkJITdN9VZJ5MMFOr1RHdlZHLs8w54ALoh2oWHZt8HVwobNREchC
         TYon0/LxzuQ30rYb38t8aI97wS8eWDnykGJt0QMREQbuMNRqr9o2zucH3YyR4UUmB3+d
         92sRle03kI3BokeUYWPeLyheQ8EUBrKogxP0+0JwiopOEQaainaziJT5MxgLihPiC5Ou
         L9rO21+d8kqFJbXJUmWFx2XJ+Lka4R3e6quz3wT2OjjGjVbeZ/OR6rJNI/sXbmJWd3SI
         LNfQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5dk5ITiTNqNbG/mDuh8OWMeezGNuHGbPsRhO2bpIVJxqmU/ysZzPhBlRTlEDStoIclL1gBWzI@lists.linux.dev
X-Gm-Message-State: AOJu0Yx9KuxM0Oh8mlX5DxaU7JF5h4MeCu3SzlkT1GLvOWx+0LvR1qm0
	/XWD3DrTKmUWM5QQ4oFqvBpZhqmE6MEGL5l0NrrkU+BAN5TxMiqz5glzE1rNgTWtMzi7oNZfAQp
	INbjdAwiKxI4BV+g5jjuGrS69JkayZEt4/X0K
X-Gm-Gg: ASbGncsA5QkOI9g9wN8lP0pl59BubJ08Yng6RBSs5xfOLwPyOItNQuJr7eUPw3qu8PZ
	cdrXeNaQRG1VACcLci4kb3NpkLH1y96JXgNu5bGFtByOuwSsHU7mLDal2ao4+0f9f/w==
X-Google-Smtp-Source: AGHT+IHwh/7TYBr+p1emG57nZgx8kct5B4lA8ljc62+a1rq3c+VxjnFrnfGmjZb2NxxSfqge856AwGpQPsgIVQ3q7a0=
X-Received: by 2002:ad4:5748:0:b0:6d8:850a:4d7d with SMTP id
 6a1803df08f44-6df9b1cc40fmr138466756d6.2.1736459472811; Thu, 09 Jan 2025
 13:51:12 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 9 Jan 2025 13:51:12 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <7a64e927-235b-4d63-af59-f2c80464a9a1@oss.qualcomm.com>
References: <20250108012846.3275443-1-swboyd@chromium.org> <20250108012846.3275443-3-swboyd@chromium.org>
 <7a64e927-235b-4d63-af59-f2c80464a9a1@oss.qualcomm.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.12.dev1+gaa8c22fdeedb
Date: Thu, 9 Jan 2025 13:51:12 -0800
X-Gm-Features: AbW1kvbQxCeGwgjzsKJ5KBUJJTsO-S_0RiV9cyqbOkGsomJiGfEijj-ht5JgDak
Message-ID: <CAE-0n53wX99ry88zOOuq6SPVpraiENheJ1T+HZri82x4gqZJ_w@mail.gmail.com>
Subject: Re: [RFC PATCH 2/6] dt-bindings: bus: Add qcom,soc-sc7180 SoC
To: Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, 
	Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	devicetree@vger.kernel.org, Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Rob Herring <robh@kernel.org>, 
	linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	Arnd Bergmann <arnd@arndb.de>, Conor Dooley <conor+dt@kernel.org>, 
	Saravana Kannan <saravanak@google.com>, =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@baylibre.com>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Konrad Dybcio (2025-01-09 06:05:14)
> On 8.01.2025 2:28 AM, Stephen Boyd wrote:
> > Document the Qualcomm SC7180 System on a Chip (SoC). This SoC is made up
> > of multiple devices that have their own bindings, therefore this binding
> > is for a "bus" that is the SoC node.
> >
> > TODO: Document all child nodes. This is woefully incomplete but at least
> > shows what is involved with describing an SoC node in dt schema.
>
> I'm not sure I'm a fan, because...
>
> [...]
>
> > +
> > +properties:
> > +  compatible:
> > +    items:
> > +      - const: qcom,soc-sc7180
> > +      - const: simple-bus
> > +
> > +  '#address-cells':
> > +    const: 2
> > +
> > +  '#size-cells':
> > +    const: 2
> > +
> > +  clock-controller@100000:
> > +    $ref: /schemas/clock/qcom,gcc-sc7180.yaml#
> > +
> > +  watchdog@17c10000:
> > +    $ref: /schemas/watchdog/qcom-wdt.yaml#
> > +
> > +required:
> > +  - compatible
> > +  - '#address-cells'
> > +  - '#size-cells'
> > +  - clock-controller@100000
> > +  - watchdog@17c10000
> > +
> > +additionalProperties: false
>
> ..this approach will make any dt node addition under /soc require
> an additional bindings change, which sounds like absolute madness

We should pretty much know what nodes go under here though, because it's
a chip that exists and doesn't change after the fact. I agree that it
will be annoying during early development when everyone is modifying the
same file to add their node, but that problem also exists with the dts
files today so it doesn't seem like total madness. It's also nice to be
able to look at one file and quickly find all the schemas for the SoC
used, like a table of contents almost or a memory map for the chip.

One thing that I find annoying is that you have to put the whole soc
node and child nodes in the example. Maybe we can omit the example
because there are so many child nodes.

>
> I think additionalProperties: true would be sufficient here, like in
> Documentation/devicetree/bindings/soc/imx/imx8m-soc.yaml
>

Ok. That binding looks to be for the efuse properties of the SoC node
itself? I was hoping to find another example of this "describe the whole
SoC" sort of binding but that doesn't match. Is there one already out
there? Should I move this binding to bindings/soc/qcom instead of
bindings/bus?
