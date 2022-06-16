Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB1215AC
	for <patches@lists.linux.dev>; Thu, 16 Jun 2022 00:39:40 +0000 (UTC)
Received: by mail-oi1-f174.google.com with SMTP id k24so133158oij.2
        for <patches@lists.linux.dev>; Wed, 15 Jun 2022 17:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=eff061+pS6rbXt8rSNzlzMwnyl96vs/JESRYuRC9zAc=;
        b=dn8H+JTUuJz+iF0dToielJli7907LM2Dg9jaVlylAQJazM5Rof0bZvY0gKuOCfmhLM
         8obWGQlY1iHK1zqZKhykiif72nMZcXM5otioRbvNoJZhZcOZAXdCHOVQ7DBGcq1yJ2vS
         9mu16X01qRe8giGb59Dp+2dXpb6VbboM0ak6s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=eff061+pS6rbXt8rSNzlzMwnyl96vs/JESRYuRC9zAc=;
        b=PfHjVIW+QRaervkYQMLwfvJgjvCrucgs3zDUiLU/NfbwZhFrTOWOy5GskZOHjqOfN9
         050J5ySztbPDLH7v+ig4eoLK4/byGjEq70E1NyRybEW1L+LBVOJif0aafLsLcosxOcx/
         ydL/nOVFIzmnVFKg8HOti9DwqBBQNNguv2/DyxG9p0S1YrCjExOKdIPFoZdGQiUn/2Lb
         YHSLoh2Ac93eg+ABDPGkUncEP2A845p+dJMScvMRq5IJvCTGrX3/jWx3OaJLiKFjF+Wr
         FMOwf5rteddPmFw9FGjGDOeO80EOaPgSWzGXOrGjoO6KOKtlIjr8Ad1zaMxIoaG0HDR1
         Nuuw==
X-Gm-Message-State: AJIora/VmtCm1uRKgoPNOQ3PEALHjOCwAMYwlLgYRm4BhK92azpRlwQY
	13ODs/f3NnyUyfvYuZeL7cg6glccIUJZtdmcm8+d7g==
X-Google-Smtp-Source: AGRyM1v7Uz0S6jwuzJCnGgullxONrD1USGVC55RFaiF+uuA/dewOLFVTR69OYuoBeIDgm3yYHnssSsMqpsinlOjSrTE=
X-Received: by 2002:a05:6808:1703:b0:32e:851e:7f81 with SMTP id
 bc3-20020a056808170300b0032e851e7f81mr1313122oib.63.1655339979844; Wed, 15
 Jun 2022 17:39:39 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 15 Jun 2022 17:39:39 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAD=FV=WUnMCj2GmMy2xRG8WOba1O4jzkXeUrrUic71eEA0aZrw@mail.gmail.com>
References: <20220614195144.2794796-1-swboyd@chromium.org> <20220614195144.2794796-2-swboyd@chromium.org>
 <CAD=FV=WUnMCj2GmMy2xRG8WOba1O4jzkXeUrrUic71eEA0aZrw@mail.gmail.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Wed, 15 Jun 2022 17:39:39 -0700
Message-ID: <CAE-0n511u+EPsWYuWnw+mdAavyecJoaw_OLQoCE2YGeDgPO9xw@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] dt-bindings: cros-ec: Reorganize property availability
To: Doug Anderson <dianders@chromium.org>
Cc: Benson Leung <bleung@chromium.org>, LKML <linux-kernel@vger.kernel.org>, 
	patches@lists.linux.dev, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, 
	chrome-platform@lists.linux.dev, Guenter Roeck <groeck@chromium.org>, 
	Craig Hesling <hesling@chromium.org>, Tom Hughes <tomhughes@chromium.org>, 
	Alexandru M Stan <amstan@chromium.org>, Tzung-Bi Shih <tzungbi@kernel.org>, 
	Matthias Kaehlcke <mka@chromium.org>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Doug Anderson (2022-06-14 15:41:38)
>
> slight nit that from reading the subject of this patch I'd expect that
> it was a no-op. Just a reorganization / cleanup. In fact, it actually
> is more than a no-op. It enforces restrictions that should probably
> have always been enforced. I think it'd be better if the subject was
> something like "tighten property requirements" or something like that.

Sure. It sort of got out of control but I didn't update the commit
text to explain that we're enforcing reg and interrupts for i2c/spi
devices.

>
> slight nit that think it would be easier to understand this bottom
> section if you made the "SPI" and "RPMSG" sections more symmetric to
> each other. I think it would be easy to just change the SPI one to say
> "not SPI" instead of explicitly listing "i2c" and "rpmsg".

I had done that earlier but now it has an 'else' condition after commit
f412fe11c1a9 ("mfd: dt-bindings: google,cros-ec: Reference Samsung SPI
bindings"), so this kept the diff smaller.

>
> In any case, this overall looks pretty nice to me. My two requests are
> both pretty small nits, so either with or without fixing them:
>
> Reviewed-by: Douglas Anderson <dianders@chromium.org>

But if it gets a reviewed-by tag with more diff then I'll do it ;-)
