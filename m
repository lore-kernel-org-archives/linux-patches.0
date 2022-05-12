Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3463FF4
	for <patches@lists.linux.dev>; Thu, 12 May 2022 23:53:14 +0000 (UTC)
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-e2fa360f6dso8684679fac.2
        for <patches@lists.linux.dev>; Thu, 12 May 2022 16:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=3Mucfvbm1V3fRO+SKrXZyQ232nLZLnjitHwpAR/NYAE=;
        b=knoF6NchK/QDemm3cpAqgru1YYu+JGMGJvh+a+STmaxzwFiGPkJjtdfVuIV1b4nFSi
         1ev6IRB8rk5lo9OVZx/KYM6rmnwhbItGoBy8s4z0530OrYdzWmDOi3FWFuFMmxFuykz7
         m/YkvvDI+jA08LrluR3vUEvS/5K/gBKmRMzwk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=3Mucfvbm1V3fRO+SKrXZyQ232nLZLnjitHwpAR/NYAE=;
        b=S8SxkpCCDMDp5JGFbGGncfBfv0cfncc0dyOV/urjUtD3LxxSgYfzXIpWjwR7WFXB7Y
         c4Zp/Pd05h3ZIsy1Mt5kDTIRhTLoovNdFPnHEzrEBxaJFKt58FqP/xRWHP5cYcENsDUO
         0gaO7Ih8iegctBrXVHvoT2p42Bc/7ob3kTNoRTrSz6re5sYWJ7OAyPG+34np1Y7Yi0ta
         HSaTd6MEZIFiPZPrbtfdqmQqB3WU8+t8NZW45znC/7hAxBeeE3jdKR3sedCd4/7BS/6p
         L4xnd1yCU59JIBhbGNewNYRtR3i2vGE6JCB/+F6HhTykvpXh6xZTfBJ1sNRa/pshS5wk
         I4hQ==
X-Gm-Message-State: AOAM531KZQXkTlWo9zFMELmJkIUySo1ZEBru1A0iOLzKNaf0+dsDtdvQ
	gaclD1RjldYZCj1diNbKfuHxsjxTgt17Nz+MJfk80A==
X-Google-Smtp-Source: ABdhPJzTg8GVf5QngZ6Zz4JABMcWUgh0cOJ/BWALzUdo1IIWvQ7IqsBmZ1A5SSCGK3vFGZxr/06n/9No2ow8oyH1Ka0=
X-Received: by 2002:a05:6870:40c1:b0:ed:9a12:3f95 with SMTP id
 l1-20020a05687040c100b000ed9a123f95mr1216198oal.193.1652399593631; Thu, 12
 May 2022 16:53:13 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 12 May 2022 16:53:13 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAE-0n52ofANUWOY5h=Jjy5SYv=bnxO3xyN4cm3qGVRYmDtkNBQ@mail.gmail.com>
References: <20220429233112.2851665-1-swboyd@chromium.org> <20220429233112.2851665-2-swboyd@chromium.org>
 <CAD=FV=VX8EEgkeLgKwyKvjztcjbA8UhKOUpTr-sS1_Ec=QcWbA@mail.gmail.com>
 <CAKdAkRSOtAD6u_cwKhHeMLgz5dC2hfPvVvqmj+17b4i-nspfgg@mail.gmail.com>
 <CAE-0n50Y8tZD9Djn9TVaAiHxehFJ2cZKZ1Z09piDk47uw3nK+Q@mail.gmail.com>
 <Ynzf5jEIECLmELK7@google.com> <CAE-0n50+obQ5qgPNPtUY=OmTgU9bZQ3hNw+MaG9Wi3SQSc-i4A@mail.gmail.com>
 <CAE-0n52WVNru5fnyaB_7wcBOk4twL0Q92YpRbd40-o6ZBmbXWQ@mail.gmail.com>
 <Yn2YvIFNhaz5GmfI@google.com> <CAE-0n52ofANUWOY5h=Jjy5SYv=bnxO3xyN4cm3qGVRYmDtkNBQ@mail.gmail.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Thu, 12 May 2022 16:53:13 -0700
Message-ID: <CAE-0n53VqYBP1Pq14ju5GWZ6VcKNS-DwLnM-1J_4Z3HExpMU1g@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] dt-bindings: google,cros-ec-keyb: Introduce
 switches only compatible
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Doug Anderson <dianders@chromium.org>, LKML <linux-kernel@vger.kernel.org>, 
	patches@lists.linux.dev, chrome-platform@lists.linux.dev, 
	Krzysztof Kozlowski <krzk@kernel.org>, Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org, 
	Benson Leung <bleung@chromium.org>, Guenter Roeck <groeck@chromium.org>, 
	Hsin-Yi Wang <hsinyi@chromium.org>, "Joseph S. Barrera III" <joebar@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Stephen Boyd (2022-05-12 16:46:22)
>
> I think I covered that in v3 of this series[1].

Even better, see v4

https://lore.kernel.org/all/20220503204212.3907925-1-swboyd@chromium.org/
