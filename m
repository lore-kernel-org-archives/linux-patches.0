Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5919815A2
	for <patches@lists.linux.dev>; Fri, 20 May 2022 00:17:30 +0000 (UTC)
Received: by mail-oi1-f173.google.com with SMTP id y66so2282359oia.1
        for <patches@lists.linux.dev>; Thu, 19 May 2022 17:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=g5XiutTaPMay4BnFO9HfDcF8oQ/jkp6cQRv3bNCI4Wk=;
        b=ZbXX/m2bMNzaPjDqUcHkf28qmML3E+inml+E4xWFcG6dWRG+iyU0G+nYA0hHqe8msV
         C3bKASpniuAGaIIK/TMUbijx1V+sTDrUTHjffZQzMaZzcVTldTK3Z8ckPpdTB6cypJ6b
         AavISvju5ob6s267fr3mtH5wFeSQhAuQ7bg48=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=g5XiutTaPMay4BnFO9HfDcF8oQ/jkp6cQRv3bNCI4Wk=;
        b=fGill1Od0+mdJ6gFb9qeDMxDtwSkedm5Vpx5hU0VOUEcepPqUPIlkS5AhkQSHLA6dv
         AMG6LZLHvkeSViw5P1Y9cmPGgMENpJjEoYpbMPhJAe+RAzMdBdhwz74UdcIEAy+7Yrf6
         l0iBWe0DbvWkaoGlXUWVFyZVQ/f1Huksj4trdZ1BkveX0k89fSuk3POEz87k6hCrsari
         1AMtXTq/TociFVVQ6b89K7TACPEzWMufTEzktIh+DWLfzb4Vxzi9wmZ3aYJLkXFA5EXI
         ObfnU6zGwgKAm/TY68iHt/jad0B2MhFE7oPA/xF4I4RSLi632duQAZI+JD+TehX4heUC
         9aSg==
X-Gm-Message-State: AOAM5304mTUqKFKC2M1eahAQA21H61qd6Fo/ilTGbEfuVOt1tQPNWsdh
	q7Mqm9IhDAVGh8kiqbbUkootTmo08Z2+LAGrlEg/yw==
X-Google-Smtp-Source: ABdhPJyd13g7t+WPRnOquoFOd12gHlNQp38Z6Pf/XC3ZP6Ibo0ugtzK1MsJaWRsxBjjPvfeDyKXwrkCZvHva8m8e/r8=
X-Received: by 2002:a05:6808:14c2:b0:326:c129:d308 with SMTP id
 f2-20020a05680814c200b00326c129d308mr3784257oiw.193.1653005849460; Thu, 19
 May 2022 17:17:29 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 19 May 2022 17:17:29 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20220519164914.v3.1.I71e42c6174f1cec17da3024c9f73ba373263b9b6@changeid>
References: <20220519164914.v3.1.I71e42c6174f1cec17da3024c9f73ba373263b9b6@changeid>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Thu, 19 May 2022 17:17:29 -0700
Message-ID: <CAE-0n51g-G=ZoJmrvm3PeL3hk4CaBoo123MHa=yq251-yAsbQA@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] dt-bindings: Document how Chromebooks with
 depthcharge boot
To: Bjorn Andersson <bjorn.andersson@linaro.org>, Douglas Anderson <dianders@chromium.org>, 
	Rob Herring <robh+dt@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>, 
	Andy Gross <agross@kernel.org>, Alexandru M Stan <amstan@chromium.org>, 
	"Joseph S . Barrera III" <joebar@chromium.org>, patches@lists.linux.dev, devicetree@vger.kernel.org, 
	Rajendra Nayak <quic_rjendra@quicinc.com>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Julius Werner <jwerner@chromium.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Quoting Douglas Anderson (2022-05-19 16:51:05)
> diff --git a/Documentation/arm/google/chromebook-boot-flow.rst b/Documentation/arm/google/chromebook-boot-flow.rst
> new file mode 100644
> index 000000000000..92d8a658ceaa
> --- /dev/null
> +++ b/Documentation/arm/google/chromebook-boot-flow.rst
> @@ -0,0 +1,63 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +======================================
> +Chromebook Boot Flow
> +======================================
> +
> +Most recent Chromebooks that use device tree are using the opensource
> +depthcharge bootloader. Depthcharge expects the OS to be packaged as a "FIT

Is there a reference for depthcharge? I guess there's source browser[2] but
I was hoping for some README or something.

> +Image" which contains an OS image as well as a collection of device trees. It

Reference coreboot docs[1]?


> +is up to depthcharge to pick the right device tree from the FIT Image and
> +provide it to the OS.
> +
> +The scheme that depthcharge uses to pick the device tree takes into account
> +three variables:
> +- Board name, specified at compile time.

Which compile time? depthcharge compile time? Also mention "BOARD"
somehow so it corresponds to the list below.

> +- Board revision number, read from GPIO strappings at boot time.

Maybe just say "determined at runtime" as who knows if it may change
from GPIO to something else. Also mention "REV" somehow so it
corresponds to the list below.

> +- SKU number, read from GPIO strappings at boot time.
> +
> +For recent Chromebooks, depthcharge creates a match list that looks like this:
> +- google,$(BOARD)-rev$(REV)-sku$(SKU)
> +- google,$(BOARD)-rev$(REV)
> +- google,$(BOARD)-sku$(SKU)
> +- google,$(BOARD)
> +
> +Note that some older Chromebooks use a slightly different list that may
> +not include sku matching or may prioritize sku/rev differently.

s/sku/SKU/g

> +
> +Note that for some boards there may be extra board-specific logic to inject
> +extra compatibles into the list, but this is uncommon.
> +
> +Depthcharge will look through all device trees in the FIT image trying to
> +find one that matches the most specific compatible. It will then look
> +through all device trees in the FIT image trying to find the one that
> +matches the _second most_ specific compatible, etc.
> +
> +When searching for a device tree, depthcharge doesn't care where the
> +compatible falls within a given device tree. As an example, if we're on

where the compatible string falls within a device tree's root compatible
string array?

> +board "lazor", rev 4, sku 0 and we have two device trees:
> +- "google,lazor-rev5-sku0", "google,lazor-rev4-sku0", "qcom,sc7180"
> +- "google,lazor", "qcom,sc7180"
> +
> +Then depthcharge will pick the first device tree even though
> +"google,lazor-rev4-sku0" was the second compatible listed in that device tree.
> +This is because it is a more specific compatible than "google,lazor".
> +
> +It should be noted that depthcharge does not have any smarts to try to
> +match board or SKU revisions that are "close by". That is to say that
> +if depthcharge knows it's on "rev4" of a board but there is no "rev4"
> +device tree then depthcharge _won't_ look for a "rev3" device tree.
> +
> +In general when any significant changes are made to a board the board
> +revision number is increased even if none of those changes need to
> +be reflected in the device tree. Thus it's fairly common to see device
> +trees with multiple revisions.
> +
> +It should be noted that, taking into account the above system that
> +depthcharge has, the most flexibility is achieved if the device tree
> +supporting the newest revision(s) of a board omits the "-rev{REV}"
> +compatible strings. When this is done then if you get a new board
> +revision and try to run old software on it then we'll at pick the most

then we'll pick the most? These last two sentences confuse me.

> +reasonable device tree. If it turns out that the new revision actually
> +has no device-tree visible changes then we'll not only pick the most

There's 'device tree' and 'device-tree', please pick one, or use a new
one like 'devicetree'.

> +reasonable device tree, we'll pick the exact right one.

[1] https://doc.coreboot.org/lib/payloads/fit.html
[2] https://source.chromium.org/chromiumos/chromiumos/codesearch/+/main:src/platform/depthcharge/
