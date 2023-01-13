Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3582115
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 19:53:47 +0000 (UTC)
Received: by mail-lj1-f179.google.com with SMTP id s25so23559917lji.2
        for <patches@lists.linux.dev>; Fri, 13 Jan 2023 11:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yxJoOeJeLXuoA2xLIDUsuFLs7ZqEd/yD5fE3qlFqk7A=;
        b=Rn1YZS2w7L3nZ8Sb7Ng6rbdcbE7pzQCTm+HI1VdJOFiBKz1gQk/5vq2IkEfp/r4i9Z
         1jKK1lUJ0SjoNPb+Y5P2VvTmWKAcNkGOc0jrRONz5A860SrcC6J8dKeZG+U1iFGIgjkB
         3l+Tb08gbsYT08e3F6TMrj4JqE0/4fh/prky8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yxJoOeJeLXuoA2xLIDUsuFLs7ZqEd/yD5fE3qlFqk7A=;
        b=qhhd5SccYTF+q5c6TiokxFWGeIrkZOExfujZ31jW29y34SQxZv34poY2vEsRLuxRDZ
         MMWXZ9F2RbcVfF8RnAOpUqXM6Nf1DrL3oe+4eufHGbnn4iFK61+kpohVlS2at8ngH4rU
         QZfZG0P8kEQvqryjeqT3QDskMt7M6F4JDxMLy8Qw4bRyPhzbNq+FqoqwnnxfgN6Oxki/
         eSqPOm+1oC8iXjWUMtJo84yo1QGne6Fs+fmzduFTcw60LWeSEc9r57p8ClQq9C+vDxtY
         xpQtrptJlDmiIyLbe4Y5GIN3EtFL0UBnliKXb1gr3I09ju2I+dEbFXng/DN/zHTRFs1n
         mwfg==
X-Gm-Message-State: AFqh2ko6eNRxn28BCIAhmtTGO4usT/e0ZYeJ12cU2g6Ji6eq5ahVRD4e
	X+ZBfy+dHlpjR3HbvObVPYcBs5+bEfWb5nwHaTmmDw==
X-Google-Smtp-Source: AMrXdXtIP5DEa3Zgi51YDgDbmJhKbc57SuJt0SLQKb1Q8s8fsroNJOyivDPMX0662NXb/zobe6OaHrS84aCoVTRebHg=
X-Received: by 2002:a2e:9a8c:0:b0:287:dd66:81f0 with SMTP id
 p12-20020a2e9a8c000000b00287dd6681f0mr1080397lji.4.1673639625718; Fri, 13 Jan
 2023 11:53:45 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 13 Jan 2023 13:53:44 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Y8EO8w9Smn4NAox6@hovoldconsulting.com>
References: <20230113005405.3992011-1-swboyd@chromium.org> <20230113005405.3992011-3-swboyd@chromium.org>
 <Y8EO8w9Smn4NAox6@hovoldconsulting.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Fri, 13 Jan 2023 13:53:44 -0600
Message-ID: <CAE-0n52LkayyRwV0tDk2LAciAfOmYU056L53f8Ma1QLiQCHfoQ@mail.gmail.com>
Subject: Re: [PATCH 5.15.y 2/4] phy: qcom-qmp-combo: fix memleak on probe deferral
To: Johan Hovold <johan@kernel.org>
Cc: stable@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Vinod Koul <vkoul@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Johan Hovold (2023-01-12 23:57:39)
> On Thu, Jan 12, 2023 at 04:54:03PM -0800, Stephen Boyd wrote:
> > From: Johan Hovold <johan+linaro@kernel.org>
> >
> > commit 2de8a325b1084330ae500380cc27edc39f488c30 upstream.
> >
> > Switch to using the device-managed of_iomap helper to avoid leaking
> > memory on probe deferral and driver unbind.
> >
> > Note that this helper checks for already reserved regions and may fail
> > if there are multiple devices claiming the same memory.
>
> This bit turned out to catch some buggy bindings and dts, so if you want
> to backport this one then the corresponding fixes for that would be
> needed as well.
>
> That includes
>
>         a5d6b1ac56cb ("phy: qcom-qmp-usb: fix memleak on probe deferral")
>
> and some dts fixes which likely already have been backported.
>
> It may even be preferred to keep to just skip this patch and keep those
> small memory leaks on probe deferral to not risk any regressions in
> stable.

I only see qcom,sm8350-qmp-usb3-uni-phy in the stable tree and that
hasn't been changed since the node was introduced. I'll try to port the
exclusive logic from a5d6b1ac56cb into this patch. I don't think it's
preferable to keep the memory leak.
