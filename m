Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5521DEFEA
	for <patches@lists.linux.dev>; Fri,  8 Nov 2024 08:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731056191; cv=none; b=eREONKB8GLf9qOb/j2JDRmKo854VAMlnMv7n5hX3ooyXweT5lf8XoRdoZVbN/xDrdf31RpHFy6I22RxqPEIjjO3XzyvzjeEGn4YvoYTdkHwrgSwxaJCOXBhGxgwa9yYGLAgIBhetMKhUuzennuks5CGyCVpd+SlNfd8jBR4xmVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731056191; c=relaxed/simple;
	bh=rrmgunvTJ+LbeosaRNs9WFk6xpnbkpOpbqPD4AJK4s0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MfW9KPpNOa8of8r/nWIwpjycQs2XbGkIK2cN0PgFYpJOp2B6OFR34m4grlGHJMnTtYKRldDzrM63wC+FyEhqHOQaftciEI5OsDvTmwxofU5aea6uTqUiMEB7McUvXhQDwlBr9CoYGvuR6D5J9BwLmVBpagJdJrDlAYXqV+YV3sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.219.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-e3314fc5aacso1809085276.3
        for <patches@lists.linux.dev>; Fri, 08 Nov 2024 00:56:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731056188; x=1731660988;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/wpmVEsmuJB7pcIow0lnOOrf5v2idmphGsuBkI3kTvk=;
        b=h4bizmdelDhex3NLY5JNP/7ss2tiCvAQxe1hEHuM3ishWQ05oSqD1DucanvuZe0VbR
         1HbfGfE2rtkNcB6Pml6jjJPNQnZhQ+Za5B6Opz2BbASPIH73twkNJJ9ClNx2cPe23BRw
         yHvQbJd89D1v4AS8PgzL+Nh23xxZ+XQDArAHTvysnS4C7I2TdMsdJ6wFFOu7F1bmTgkF
         bGwqO9iQVuUyghy+VrKcuCrZ+UCd3SY6SoQuq92TZQsmR9JKx3xxs8otvDxiW39VImDO
         umfxQtHzXUGeIkVbLJE6rCjsz7xys3UC/H2Qndimrqai+1UCP9BEKHhL9i6ICgtTZPYs
         DykA==
X-Forwarded-Encrypted: i=1; AJvYcCUZVEAmVMxCEwyUzJm+XhGr7odbBSiLSbQnadwBvayQdMjiCP5jf+YZ5tTqhci0plMEW3izvYZf@lists.linux.dev
X-Gm-Message-State: AOJu0Yyyhiv08AUUXhDEzl3xgpi0h9+ibS11V+uB/ba1HmyhulLRKS1V
	VDZ9spaYIxrtDDdtHW5KI8vby7IVPa3KPkyhrSYvMqKwMpy4QFRWYezB5+GA
X-Google-Smtp-Source: AGHT+IHiNOXNxddqXdl2hVzVNfs2FJDt4x5+RutoOnwe4udBpvbXgE2/dYtEtR0paETXY8pxmO7S7g==
X-Received: by 2002:a05:6902:cc6:b0:e33:1c9e:5cf2 with SMTP id 3f1490d57ef6-e337f8beb36mr2098082276.39.1731056188285;
        Fri, 08 Nov 2024 00:56:28 -0800 (PST)
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com. [209.85.128.175])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e336f1ba572sm627693276.37.2024.11.08.00.56.27
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Nov 2024 00:56:27 -0800 (PST)
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-6ea8419a57eso21675387b3.1
        for <patches@lists.linux.dev>; Fri, 08 Nov 2024 00:56:27 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVnpvP06ipurqMgzAXrl+3f19XnTvjyxN6sU+baQFL3xTTVuGcg5OTonfZleDNgkZ+0eTA1IlRV@lists.linux.dev
X-Received: by 2002:a05:690c:4b90:b0:6ea:7198:fb64 with SMTP id
 00721157ae682-6eaddfa4910mr21644887b3.41.1731056187520; Fri, 08 Nov 2024
 00:56:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241016212016.887552-1-sboyd@kernel.org> <20241017203810.GA814469-robh@kernel.org>
 <38153cbf2616a4a6706412952778eec1.sboyd@kernel.org>
In-Reply-To: <38153cbf2616a4a6706412952778eec1.sboyd@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 8 Nov 2024 09:56:15 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWp84u66Y-ELtbbRmySYwQch_=2qQiXzWJzrSkGeLZYBA@mail.gmail.com>
Message-ID: <CAMuHMdWp84u66Y-ELtbbRmySYwQch_=2qQiXzWJzrSkGeLZYBA@mail.gmail.com>
Subject: Re: [PATCH] of: Allow overlay kunit tests to run CONFIG_OF_OVERLAY=n
To: Stephen Boyd <sboyd@kernel.org>
Cc: Rob Herring <robh@kernel.org>, Saravana Kannan <saravanak@google.com>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, devicetree@vger.kernel.org, 
	kunit-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

On Sat, Oct 19, 2024 at 12:21=E2=80=AFAM Stephen Boyd <sboyd@kernel.org> wr=
ote:
> Quoting Rob Herring (2024-10-17 13:38:10)
> > On Wed, Oct 16, 2024 at 02:20:15PM -0700, Stephen Boyd wrote:
> > > Some configurations want to enable CONFIG_KUNIT without enabling
> > > CONFIG_OF_OVERLAY. The kunit overlay code already skips if
> > > CONFIG_OF_OVERLAY isn't enabled, so this select here isn't really doi=
ng
> > > anything besides making it easier to run the tests without them
> > > skipping. Remove the select and move the config setting to the
> > > drivers/of/.kunitconfig file so that the overlay tests can be run wit=
h
> > > or without CONFIG_OF_OVERLAY set to test either behavior.

Thanks for your patch, which is now commit 027af8c26fdc0642 ("of: Allow
overlay kunit tests to run CONFIG_OF_OVERLAY=3Dn") in dt-rh/for-next.

> > > Fixes: 5c9dd72d8385 ("of: Add a KUnit test for overlays and test mana=
ged APIs")
> >
> > Doesn't really seem like a fix.
>
> Ok. Feel free to drop the tag.
>
> > Does this need to go into 6.12?
>
> It's only important for 6.12 if kernel configurators want to build the
> kernel with OF_OVERLAY_KUNIT_TEST enabled and not be forced to enable
> CONFIG_OF_OVERLAY. I don't mind if it waits a while.

I'd say it's a fix, so please keep at last the Fixes tag. Merely
enabling kunit tests (which can be modular) should not increase the
possible attack vector on a product by enabling extra unneeded code.

So
Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
