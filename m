Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728A018132E
	for <patches@lists.linux.dev>; Thu,  2 May 2024 21:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714685050; cv=none; b=mK+WEqK7XfXgFP91xOvm+SZ2hwDGuqQccAYOmihShl+gKHU9g3+gjp0Hcnnto6rJHNzzeHqPS/tbs1JW+AKKJsRlkbq28zKJ7A9I/7ITAC5ZDUJE6rkACZgt2QmTe77TaY+AGodhN9nkusY2Dl0QENuKNZj7erSGPbjhxPdiwfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714685050; c=relaxed/simple;
	bh=e5MnDYpDbG4HN+rm3kIwAqZE0h1MjgBoqyIP17amCKU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FRhulY2vdxP2gR1CbW7BFtfIdGYEZK6K7681yLTQAvRqIRMW5v4GLHbEOtcjrYc/9pD6pPdFUGa80Il0E8uhcTkY80Fe3MEU8nU+Fw6jRushb+7rTQ8nooAe0Fwfsvd6tCadWgqtCO2NIzgDbDCxY1vmgfpq/mkmfUN0UEG5j2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x0QxrTp4; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x0QxrTp4"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-572aad902baso1919a12.0
        for <patches@lists.linux.dev>; Thu, 02 May 2024 14:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714685047; x=1715289847; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/DpXkrfXRsTHCLm8mx8p2ZuP05XHl7UCwnC21b1+Ido=;
        b=x0QxrTp4VMbTU1RFRC+ussHv3bRQ/FW32Dtv9TLC1GnMC2BgV2Vh+diM9y0/HuIvNf
         N5DLT9OnRn5H/ypwD75IzKeMW2Ya5NdLNU7a+Go49X5zMIkbcBDO27dWon0tZby6PFoR
         +9Apfroq3xMHWzEpMdQGvrtAgQvBzxRp1MADL20lxQ3ZwctuX4cCkKa5lMjp9nT42FVF
         d3KsMAROlnNvAVl/kxrUp+f/NjQG7afmoJbJ8x1CA4xrhw5TCD3erQKU1RqlQUf3RHMQ
         ulVKchKGR/QvhGwaCkuX0A5KR29ca7yPLLl/71ZHsGRqJrEB5LKAKGiSdZ11/TWPa3Ps
         p4Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714685047; x=1715289847;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/DpXkrfXRsTHCLm8mx8p2ZuP05XHl7UCwnC21b1+Ido=;
        b=J/J8qmBVX/1rJRd9C65ma0c9wVME787ZEZAJNVNcjZWn9nYF6qdu6sYsoMzFDg5/pq
         dZu21Aqeov19eUhjfUbsRe3RSNvDJUM6QLJv+MU8165t6vu+shvEmu15unJ7hpMmwIMS
         RckvjJETLbSDxlUWDNrSq6ithXQ/Uj8NCdgpfCz/SK3VfTYr3RhKK6ON7n1/NvDeZLW8
         DZT/YEcV1v+MRIO77N6lqrNLZsRVto2izeT+gftUQUJlj42axDCBPxu7OPt3Dze3Pmto
         ANAVhoZJ/EcivLG7AB21lN3XWpiODqk/4nqWu23wXiPaHfYhMkkAvRlnjlASPad4lhqG
         ZB0w==
X-Forwarded-Encrypted: i=1; AJvYcCUrMgbfZlhaGGv6jzyBZrD5bybl9aCX1gVOXTb9eRDSAg07EU75O8D14dVP3TFXh5OqrSmgyiRT9yUJNS79/oH/MCZLpClsoQ==
X-Gm-Message-State: AOJu0Yy1qlK/EYNhjEQK7AXVyxZKgAPR0Z65WWCxrtLXfD8Wauo+5EFv
	/E4A4t1Ly40chTFvI7bQDBpP/E4YLWyu4ls3Lffwp6apQUWCLKuIxLcJhzzH7uEEGq1VWNWm5yV
	P0RCjTIr65VZN/XSCQFucAmsyE5yfU4K9Ohkm
X-Google-Smtp-Source: AGHT+IE6D0fEqWY7DDB8CwkPwGyVRibjt+oC+Eg4cUWkVc6Psi/KvL45XqFWzXhHNui+xz3wqXew4hVko87URKKdZHA=
X-Received: by 2002:a50:999a:0:b0:572:554b:ec66 with SMTP id
 4fb4d7f45d1cf-572d0f4be13mr12509a12.3.1714685046627; Thu, 02 May 2024
 14:24:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240422232404.213174-1-sboyd@kernel.org> <20240422232404.213174-4-sboyd@kernel.org>
 <CABVgOSnEQ0m_nG-dSA3e+5PSazh9uTB_A56zRrphh5vgPsYk3Q@mail.gmail.com>
In-Reply-To: <CABVgOSnEQ0m_nG-dSA3e+5PSazh9uTB_A56zRrphh5vgPsYk3Q@mail.gmail.com>
From: Brendan Higgins <brendanhiggins@google.com>
Date: Thu, 2 May 2024 17:23:52 -0400
Message-ID: <CAFd5g47jEkDvxkg4Kk066_RgN1w6AdjtCKSs3=shWG-kXynPKQ@mail.gmail.com>
Subject: Re: [PATCH v4 03/10] dt-bindings: test: Add KUnit empty node binding
To: David Gow <davidgow@google.com>
Cc: Stephen Boyd <sboyd@kernel.org>, Michael Turquette <mturquette@baylibre.com>, 
	linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, 
	patches@lists.linux.dev, kunit-dev@googlegroups.com, 
	linux-kselftest@vger.kernel.org, devicetree@vger.kernel.org, 
	Brendan Higgins <brendan.higgins@linux.dev>, Rae Moar <rmoar@google.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Rob Herring <robh@kernel.org>, Saravana Kannan <saravanak@google.com>, 
	Daniel Latypov <dlatypov@google.com>, Christian Marangi <ansuelsmth@gmail.com>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>, 
	Maxime Ripard <maxime@cerno.tech>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 1, 2024 at 3:55=E2=80=AFAM 'David Gow' via KUnit Development
<kunit-dev@googlegroups.com> wrote:
>
> On Tue, 23 Apr 2024 at 07:24, Stephen Boyd <sboyd@kernel.org> wrote:
> >
> > Describe a binding for an empty device node used by KUnit tests to
> > confirm overlays load properly.
> >
> > Reviewed-by: Rob Herring <robh@kernel.org>
> > Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
> > Cc: Conor Dooley <conor+dt@kernel.org>
> > Cc: Brendan Higgins <brendan.higgins@linux.dev>
> > Cc: David Gow <davidgow@google.com>
> > Cc: Rae Moar <rmoar@google.com>
> > Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> > ---
>
> Looks good to me.
>
> Reviewed-by: David Gow <davidgow@google.com>

Reviewed-by: Brendan Higgins <brendanhiggins@google.com>

>
> -- David
>
> >  .../devicetree/bindings/test/test,empty.yaml  | 30 +++++++++++++++++++
> >  1 file changed, 30 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/test/test,empty.y=
aml
> >
> > diff --git a/Documentation/devicetree/bindings/test/test,empty.yaml b/D=
ocumentation/devicetree/bindings/test/test,empty.yaml
> > new file mode 100644
> > index 000000000000..20dc83b15bbf
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/test/test,empty.yaml
> > @@ -0,0 +1,30 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/test/test,empty.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Empty node
> > +
> > +maintainers:
> > +  - David Gow <davidgow@google.com>
> > +  - Brendan Higgins <brendanhiggins@google.com>
>
> Brendan: Do you want to use your linux.dev address here?

Ah, thanks for pointing that out, David. Yes, please use "Brendan
Higgins <brendan.higgins@linux.dev>" here.

Otherwise it looks good to me.
