Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D207EB
	for <patches@lists.linux.dev>; Wed, 29 Jun 2022 07:29:36 +0000 (UTC)
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-101ec2d6087so20330285fac.3
        for <patches@lists.linux.dev>; Wed, 29 Jun 2022 00:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=QZQW7+X7qAeWQ0JA11J+Y8+6HrDMvj4CxUzkjuBhZk4=;
        b=cVHuYXoUBBcO77yyhDnn9dRsLS4jjH7jJT7wBlYKn1PkKTKNe3bZHOH6+8Iz3fG+1s
         6qvW56SRXka8ShlfNVZhhy9EhuAwPIQBwY0aS6tcz4GMKflhio6xYYKNoesvFk6SOqqu
         U91f8Mzs5sZidos4K4DovB9CapAukJ/QfoGS8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=QZQW7+X7qAeWQ0JA11J+Y8+6HrDMvj4CxUzkjuBhZk4=;
        b=iMk7rdUEHadIQhNwgfL1+F6EwM2Kc4heZ+F5ZlDhHpIUTrkZvmuxgLxn3BDqhKxjea
         jVY1d35Zn7peKLXR71Y6c5HQSKG5z9xwKC5xK/PQ8pXySr9T+FxWHkzDcGxX0+0+ByEg
         lKPiH0/tNd3btawBwsNJIt3VFm17N00++1fP4rEaGQvaVNa4Fym66KwbBglcRd7B2Xrm
         +f8BBD9Aq+Jt96JCo22arBf5rYl37oy9BrGveFY8EoDxK4nwG0TRtVHBVDR1yn0U25Mi
         L2p5HRmLvn/K45bNS2a6379vOQGou9aPvWn9hSRrwFywoX3oijjRo2B9LBVyUgF6j4Ke
         SziQ==
X-Gm-Message-State: AJIora9hEWo/k4iXnNHM9RwYyIgCaXYxJV4JCcq1RIPftYOR8jPo6r4g
	JlJ03yN1OSCuGRwfFrX9UMc4e+vlh+QNeeDdFvcqDA==
X-Google-Smtp-Source: AGRyM1vaywAXGT5aAjMk6AmlxtgNGPiL57UiTFsOz2mBPdyZOB/WeFYD1oj5i+TmFEv+OrgHcLCr65PRFFZJmJ+4AQU=
X-Received: by 2002:a05:6870:b381:b0:fe:2004:b3b5 with SMTP id
 w1-20020a056870b38100b000fe2004b3b5mr1151175oap.63.1656487775750; Wed, 29 Jun
 2022 00:29:35 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 29 Jun 2022 02:29:35 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20220627215720.GA3004792-robh@kernel.org>
References: <20220614195144.2794796-1-swboyd@chromium.org> <20220614195144.2794796-3-swboyd@chromium.org>
 <CAD=FV=UU-AENyChCvVAKH709E4hFtgo4Txa8zFDY=JM1UifA0g@mail.gmail.com> <20220627215720.GA3004792-robh@kernel.org>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Wed, 29 Jun 2022 02:29:35 -0500
Message-ID: <CAE-0n53SJbnvyCXhgVWATSs0pKwGqNj9AeVLfNfUUvzR-UxRuA@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] dt-bindings: cros-ec: Add ChromeOS fingerprint binding
To: Doug Anderson <dianders@chromium.org>, Rob Herring <robh@kernel.org>
Cc: Benson Leung <bleung@chromium.org>, LKML <linux-kernel@vger.kernel.org>, 
	patches@lists.linux.dev, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, 
	chrome-platform@lists.linux.dev, Guenter Roeck <groeck@chromium.org>, 
	Craig Hesling <hesling@chromium.org>, Tom Hughes <tomhughes@chromium.org>, 
	Alexandru M Stan <amstan@chromium.org>, Tzung-Bi Shih <tzungbi@kernel.org>, 
	Matthias Kaehlcke <mka@chromium.org>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Rob Herring (2022-06-27 14:57:20)
>
> If we were starting from scratch, I would say you should just drop
> 'google,cros-ec-spi' from this binding. But I guess you want to preserve
> compatibility here. In that case, I think all this should be added to
> the existing doc with an if/then schema for conditional parts. That also
> avoids defining the common properties twice or moving them to a common,
> shared schema.
>

I had it all combined in a previous version. Let me see if I can merge
the two together (again) and fix the bugs.
