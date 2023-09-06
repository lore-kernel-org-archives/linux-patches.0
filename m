Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8036ADB
	for <patches@lists.linux.dev>; Wed,  6 Sep 2023 20:59:35 +0000 (UTC)
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5007c8308c3so361325e87.0
        for <patches@lists.linux.dev>; Wed, 06 Sep 2023 13:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1694033974; x=1694638774; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nEi+MWXrvIx8jzHRqj96TK8TejuRSgL7GuIT6Vvp9U0=;
        b=mX0BheP12tbiA7YFOG635PSRfI8ru/fq+hJsYb2y/wuqu8EXhMRIXgoozIexjrJt3r
         fT2ndTPusMDR44RDhh6iHZDWLGOptJCemE1OENIOuGp8Q5CUjhdm9GukLRYf1UzyGk50
         1HEy7d6WiM6waHKlRTUePI3NcPZtMoCWrzzlQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694033974; x=1694638774;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nEi+MWXrvIx8jzHRqj96TK8TejuRSgL7GuIT6Vvp9U0=;
        b=DMa3tU9SXTqLojZsPvOdy7bPVJXFP0WaCqneYzEXfZ8wPNdhx1JJSGfuJ7lDlsBqMx
         +ng1dRB+xGvHo6HI9JsrUmjyQ6IQpKOUeECqQCmNgwN0GgxuAEt23RueUZhoNf/puVWO
         ihdXj2jsvnFNZUHQgyv+EPK5tHRfQwcALWwlG90A4az9b4/LBmiWfuWNVi0Y6vnhJSDX
         w/TRsF/Y8ZzIv68gPzwvTjre/bPYDrt2M8d/hLWedDwkwzdhy5oFiMYwZCXeZSCb6OUJ
         axLnmh8PIPtIvwvxrVm+B1/AdpJC1/Az5AbDp5lhDS08jgvahzsDf1pBg7vd/0RCVuVs
         A7og==
X-Gm-Message-State: AOJu0YywDa5ihdtMWIsnsNeGg3+IZ6JTsJJEuDfurN+2X9eYTZAWwUy0
	E8CaD63fWCm+w8bwQ2MsB4qxTRP3j+PV+ST7fqPnWQ==
X-Google-Smtp-Source: AGHT+IExyQ6B5Nq4kK03+qra5dZ0VH65Eg+voPe+M/hd6T+GvGGoxMqejIJxTzOTvbr11ghTCOdd+KOwOCaSt4hl81w=
X-Received: by 2002:a05:6512:3703:b0:4fe:d0f:1f1e with SMTP id
 z3-20020a056512370300b004fe0d0f1f1emr2918944lfr.25.1694033973824; Wed, 06 Sep
 2023 13:59:33 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 6 Sep 2023 15:59:33 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ZPjlIhDykHd44YTz@smile.fi.intel.com>
References: <20230906180944.2197111-1-swboyd@chromium.org> <20230906180944.2197111-4-swboyd@chromium.org>
 <ZPjdZ3xNmBEBvNiS@smile.fi.intel.com> <CAE-0n53iGCL3q=CsDKZr28eMjx40miLNG6+-jf12JKMxuAKkKg@mail.gmail.com>
 <ZPjlIhDykHd44YTz@smile.fi.intel.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Wed, 6 Sep 2023 15:59:33 -0500
Message-ID: <CAE-0n500OCS0nh_7v_FL1rtTccAJxKhoD8vuBE7AER1fwWihsQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] platform/x86: intel_scu_ipc: Fail IPC send if
 still busy
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>, Hans de Goede <hdegoede@redhat.com>, 
	Mark Gross <markgross@kernel.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>, 
	Prashant Malani <pmalani@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Andy Shevchenko (2023-09-06 13:46:26)
> On Wed, Sep 06, 2023 at 03:22:43PM -0500, Stephen Boyd wrote:
> > Quoting Andy Shevchenko (2023-09-06 13:13:27)
> > > On Wed, Sep 06, 2023 at 11:09:43AM -0700, Stephen Boyd wrote:
>
> ...
>
> > > > @@ -450,6 +468,12 @@ int intel_scu_ipc_dev_simple_command(struct intel_scu_ipc_dev *scu, int cmd,
> > > >               return -ENODEV;
> > > >       }
> > >
> > > >       scu = ipcdev;
> > >
> > > Side observation: Isn't this a bug? We should not override the supplied parameter.
> >
> > If it is a bug that would be great to know. I wanted to make an API that
> > got the scu if it wasn't busy but then I ran across this code that
> > replaced the scu with ipcdev.
>
> To me this seems like a bug, because in other similar code we don't do that.
> And even reading this one, why do we have a parameter if it's always being
> rewritten?

Yes. From what I can tell looking at commit f57fa18583f5 ("platform/x86:
intel_scu_ipc: Introduce new SCU IPC API") it was an unintentional bug
to leave that line there.
