Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16E31DA53
	for <patches@lists.linux.dev>; Tue, 21 May 2024 04:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716264851; cv=none; b=mNqVXrwIsOBppRfwD2+McfKrbuhTwSsDI9wirEyRIFoPrWsMoaWTLKnJV4JrsgBtN1ojKnBLTCKgbmrBK7jo3TRg/lpMPdlYrXf2Cwb/u/YHpAX2Jv9kjZ1d5gx3n5wQJtl1sYNc6SR8/TCJgSjbe0tE5kAx92M1tv8rOyvvT8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716264851; c=relaxed/simple;
	bh=CIfsby2oPpYY3kXs4oddKQZp1v5fbpImVUNDZjOnRlQ=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fUhCF/dpJWnUTl9jGuoAzTNDuJxo+kiXsxpJ61aw6oGjwV+k1daH8DeiYJntImMH0s07GdEds2UMmGqYxAR9mDMDZuFwLj0qaeDiO8a3cfRKmsDZSKNjjtYDZN2+hwDps7iQlKaeoGYCW6XWcPgVFayIA5PXp4IhqOrs63Gix40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=ah4r5v0y; arc=none smtp.client-ip=209.85.221.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ah4r5v0y"
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-4e1459a13fdso1685408e0c.3
        for <patches@lists.linux.dev>; Mon, 20 May 2024 21:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1716264849; x=1716869649; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LQAMz+e0g3nZFFrVh6fJZF5RVSqH/2InZskkKfH8zyQ=;
        b=ah4r5v0y/SgomNZ6Q8gvU9cmLL3klAgbBxyCAZgc9IaNXvJMr8TJTACZnzRxb7ZUyL
         KEIjwVOwftST+y+EX+7nlejCuz4MWmaoO6R+oEijKwh+bCKzytGmtyjnrq7itH0Lu8KP
         GEMbU9xyCo2G6S/rINp3i/6YitS34UxTVeblE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716264849; x=1716869649;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LQAMz+e0g3nZFFrVh6fJZF5RVSqH/2InZskkKfH8zyQ=;
        b=fhVl1gPQIV6B5RbIt0tko9vI6vSgdkUQgP7SVp4qrkKnMtQ4/4ksGUxafeiQHM06Gg
         3B1pSdPituuYdCqSB54Y9vUn0/6I0E8c3P6RVB+05pohmNJb2N15PYiqYvX1N11eMLhc
         R2HyMVw0GLMASFb7YMp/JXgdCnk4sZ2mr33et4mfF1QQvG2vU0UrOmANgaKSOcAp9x90
         +3uBts4uBvonUkKEcArQeFI9XlZXNJJ9md02jy1MEVIf1gWN8lBtGVCa4OUvs3guQykm
         FWUYSRg4fTVedifs8yVsEFP11yNirs1lzatk3ilcvuSzsu66fnCNjudQHCM7F2Z39Zox
         OPXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXq8T0a1AhHSmoAloNWdHXx4MvN2WLm+QY+cehOGW5arRT0IUDiJ0MduHeyTkaLeujWrdtB3DwgmZK63GDoivH/4T59Bim14A==
X-Gm-Message-State: AOJu0Yze/tv37jfYlXHnC+WhLmc3UgXSD2C/zycL17OckFMwQA1ztUjv
	Au5HDcPp+x6YBTa40kH7JwkOBJEUsgOEDS5qagKs4kjM9DKUuuWt5RQYcG6DVMZI8q1MEiZcAmt
	FWSgd4+b9Tw3jiXxmcucUfBsLv6Gprft/bXtq
X-Google-Smtp-Source: AGHT+IErt01awAAr7IkOBO0CcMyBfFJYFdKpLSMo+GZEaQYY7nAl+Dw2FgYvqdFb3fdaEaa/X8kAqIyrlEk7mqPwHt4=
X-Received: by 2002:a05:6122:a19:b0:4d3:4ac2:29f4 with SMTP id
 71dfb90a1353d-4df88286136mr27403633e0c.2.1716264848783; Mon, 20 May 2024
 21:14:08 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 21 May 2024 00:14:08 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <202405181346.901048F98@keescook>
References: <20240514224839.2526112-1-swboyd@chromium.org> <202405181346.901048F98@keescook>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Tue, 21 May 2024 00:14:08 -0400
Message-ID: <CAE-0n50TuoSEaWmAcUoX3KDtp2ivdHmqWpaYn+dVdo4_L1H2NA@mail.gmail.com>
Subject: Re: [PATCH] loadpin: Prevent SECURITY_LOADPIN_ENFORCE=y without
 module decompression
To: Kees Cook <keescook@chromium.org>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E . Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	linux-security-module@vger.kernel.org, 
	Dmitry Torokhov <dmitry.torokhov@gmail.com>, Douglas Anderson <dianders@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Kees Cook (2024-05-18 13:47:14)
> On Tue, May 14, 2024 at 03:48:38PM -0700, Stephen Boyd wrote:
> > If modules are built compressed, and LoadPin is enforcing by default, we
> > must have in-kernel module decompression enabled (MODULE_DECOMPRESS).
> > Modules will fail to load without decompression built into the kernel
> > because they'll be blocked by LoadPin. Add a depends on clause to
> > prevent this combination.
> >
> > Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > Cc: Douglas Anderson <dianders@chromium.org>
> > Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> > ---
> >  security/loadpin/Kconfig | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/security/loadpin/Kconfig b/security/loadpin/Kconfig
> > index 6724eaba3d36..8c22171088a7 100644
> > --- a/security/loadpin/Kconfig
> > +++ b/security/loadpin/Kconfig
> > @@ -14,6 +14,9 @@ config SECURITY_LOADPIN
> >  config SECURITY_LOADPIN_ENFORCE
> >       bool "Enforce LoadPin at boot"
> >       depends on SECURITY_LOADPIN
> > +     # Module compression breaks LoadPin unless modules are decompressed in
> > +     # the kernel.
> > +     depends on MODULE_COMPRESS_NONE || MODULE_DECOMPRESS
> >       help
> >         If selected, LoadPin will enforce pinning at boot. If not
> >         selected, it can be enabled at boot with the kernel parameter
> >
>
> I've folded this change in, since loadpin also works in non-module
> situations:

Thanks for fixing my thinko.
