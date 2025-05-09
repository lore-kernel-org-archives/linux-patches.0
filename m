Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA4D13C3CD
	for <patches@lists.linux.dev>; Fri,  9 May 2025 14:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746802005; cv=none; b=UJHE/Fxndm746KQz/vzN9mp5+psJmSRCVU128n68NyhFNd75SwAHco/l6ATDtswosq49xSYFxfQJ7UInlvuJGxhDYbpwBevfpI/LXqVQrHM9MhlpW2Na7wwR51poNeIavKoJC1S/4j5kOctDzMxF6x458FQXY5WmHKuSSbWg+zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746802005; c=relaxed/simple;
	bh=tPVZPWNCOYoPgGgXeIIn2UbDqXC7SXYegkzLCHglCNk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SxkZr9KrozBDw+hocj1mxwmgtmfbRzc6g/t53M4oE7JOh2SGGvkCSsfcW4ZDVsEaoala8nRftxvx4e14IYsQML2Ek/ueIvj/0Z/QxqYoWIDzJqh6bSCzA8MxoaafFNZBf7d7Uy4JlpFML8wQJ5topc8Aawnj0KV3LQ4FgW7i9jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BVV9v3me; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BVV9v3me"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-acb5ec407b1so386626066b.1
        for <patches@lists.linux.dev>; Fri, 09 May 2025 07:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746802002; x=1747406802; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RqPDd473ZQWcooUPNpRz+CKqf4hWlXZOHvbt8YRzn4w=;
        b=BVV9v3meKlhUT7OTkn0yykhYkt2BQ3xq5cHxxCrL+Oc8CcxuQ34kFZA6Rgh39k2wxW
         EwT3TFppRjXzmc8S+WEuchohHuqcjTamQFUm6eZPtmcapA6pEtU97P5wJx9WdRFpKx2c
         b/H9R7Ry6gILzbpG1G1iw+hXErH/jstQsp8YwduOaKC5K2QiQQKU+mPU1Li8eC3o/4g6
         +bxn9mQ+L7U6Alpp7wwg1lAoOcf9XShIJaww6QaX3W7aQlDzsDjwbSbTeMW2+AU5BhDV
         f66miViDk6pVF6X0HcxpCJwnxm1alzxqzOfs/aGEOMM26k3OO40rN+AWyLYFWsWos1wn
         aLjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746802002; x=1747406802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RqPDd473ZQWcooUPNpRz+CKqf4hWlXZOHvbt8YRzn4w=;
        b=remYyW9e/QznZ4LmbQ/FlHEm7s/Jm34jTzNDoP2NaerBS3TufBbydrGITGKwd6SGoU
         vaGVTyvVrYbioTopd+IpPlV/sXhNpVHgRzTboBmR/Hjj4h7WI9AaDMp4QJ1p4eZKbaW7
         Hmi8NyJ0IrVE6WhzJ1z9wxdASouErpK44Z1h0z2EvCCfKfY9GkpXJfuvfGqOGxWGGI9x
         K8ls9brK9dg/xjd+8blHNpkFbVGbDWQYx58Op9kaMTSaHyocSYvgj0o/MdDZ1HykQClK
         aUBtiHlQTL3LQJYaDR7W2XTxqntO2nDaGoQXiP0poNI249tHOenQxLLQcw0RkMO2kgKk
         E/uQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgfoiVYCsZ3i/4pTlXU8A6e6vkrO9yWreStY0Caqutcz5Dl/sAoCCzazygpP7bzuJXyFFr9dm8@lists.linux.dev
X-Gm-Message-State: AOJu0YyyUtp5HPbyC0De8/C2JpfbnHvMLAgmI2uKRBOp9CHst+roM+6i
	RGpegc3gj9RgyAmQaXJ+MLxQdHMo89M3B7lUHxmfve+ESQahjjJIuJ1jqjugopn+ELdtp5KCiNs
	SFpDs04HitIVfkzi0AY/+EgE+HT97nIn5wIdt
X-Gm-Gg: ASbGncsrOMP+CFHyl/iqI5z66ZgJxzKgjnxFOu+AXXbeDyO5p9u1KaQgwPxVvCP8DhP
	3ZdOoOHAX76Dc6b+b/BpCd0wT0I8bdAzfgrl4/UlKILYTRT6qNY+NcGp+4MnUPM/aanTRXpFvHs
	fAU9YaSifHkTIwDdXIWMRKoA8RBodsrmSRkebA+OcPDq+wIJ+Zg3Se
X-Google-Smtp-Source: AGHT+IEA002KjzYuQN8mBsFnac//gQE6/nlAx3Qg4teok9k7rMWjTs5P9zd3QgSlRedEqT+71xQmXuZHnUh/98J3AIo=
X-Received: by 2002:a17:907:7e82:b0:ad2:1870:24d6 with SMTP id
 a640c23a62f3a-ad21915d80fmr422482966b.43.1746802001474; Fri, 09 May 2025
 07:46:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250429003359.375508-1-tony.luck@intel.com> <20250429003359.375508-14-tony.luck@intel.com>
 <4aa0904d-9332-4796-90d6-d858711fc611@intel.com> <aB0T_Ep2lJzfwjv5@agluck-desk3>
 <2a19f63a-f9b4-4632-bca2-2f64f6fed57b@intel.com> <aB3nGDzW6pNNkYTB@e133380.arm.com>
In-Reply-To: <aB3nGDzW6pNNkYTB@e133380.arm.com>
From: Peter Newman <peternewman@google.com>
Date: Fri, 9 May 2025 16:46:30 +0200
X-Gm-Features: AX0GCFuwcP3gG12CJJi6nR0VSEns8QAaD3COAOIHvOl4j9Xoi_yyM4CZSm_PzaA
Message-ID: <CALPaoCjzrGMTEYmTpH=9o_=N24apE0U057p6Mt6Knt9PoyFmzw@mail.gmail.com>
Subject: Re: [PATCH v4 13/31] fs/resctrl: Add support for additional monitor
 event display formats
To: Dave Martin <Dave.Martin@arm.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>, "Luck, Tony" <tony.luck@intel.com>, 
	Fenghua Yu <fenghuay@nvidia.com>, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, James Morse <james.morse@arm.com>, 
	Babu Moger <babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, 
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>, Chen Yu <yu.c.chen@intel.com>, x86@kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Fri, May 9, 2025 at 1:29=E2=80=AFPM Dave Martin <Dave.Martin@arm.com> wr=
ote:
>
> Hi,
>
> (Backtrace retained for context -- see my comment at the end.)
>
> Cheers
> ---Dave
>
> [...]
>
> On Thu, May 08, 2025 at 04:45:21PM -0700, Reinette Chatre wrote:
> > Hi Tony,
> >
> > On 5/8/25 1:28 PM, Luck, Tony wrote:
> > > On Thu, May 08, 2025 at 08:49:56AM -0700, Reinette Chatre wrote:
> > >> On 4/28/25 5:33 PM, Tony Luck wrote:
> > >>> Resctrl was written with the assumption that all monitor events
> > >>> can be displayed as unsigned decimal integers.
> > >>>
> > >>> Some telemetry events provide greater precision where architecture =
code
> > >>> uses a fixed point format with 18 binary places.
> > >>>
> > >>> Add a "display_format" field to struct mon_evt which can specify
> > >>> that the value for the event be displayed as an integer for legacy
> > >>> events, or as a floating point value with six decimal places conver=
ted
> > >>> from the fixed point format received from architecture code.
> > >>
> > >> There was no discussion on this during the previous version.
> > >> While this version addresses the issue of architecture changing the
> > >> format it does not address the issue of how to handle different
> > >> architecture formats. With this change any architecture that may
> > >> want to support any of these events will be required to translate
> > >> whatever format it uses into the one Intel uses to be translated
> > >> again into format for user space. Do you think this is reasonable?
> > >>
> > >> Alternatively, resctrl could add additional file that contains the
> > >> format so that if an architecture in the future needs to present dat=
a
> > >> differently, an interface will exist to guide userspace how to parse=
 it.
> > >> Creation of such user interface cannot be delayed until the time
> > >> it is needed since then these formats would be ABI.
> > >
> > > What if resctrl filesystem allows architecture to supply the number
> > > of binary places for fixed point values when enabling an event?
> >
> > This sounds good. I do not think we are in a position to come up with
> > an ideal solution. That would require assumptions of what another
> > architecture may or may not do and thus we do not have complete informa=
tion.
> >
> > >
> > > That would allow h/w implementations to pick an appropriate precision
> > > for each new event. Different implementations of the same event
> > > (e.g. "core_energy") may pick different precision across architecture=
s
> > > or between generations of the same architecture.
> > >
> > > File system code can then do:
> > >
> > >     if (binary_places =3D=3D 0)
> > >             display as integer
> > >     else
> > >             convert to floating point (with one decimal place per
> > >             three binary places)
> >
> > I do not think this problem needs to be solved in this work but there n=
eeds
> > to be a plan for how other architectures can be supported. When similar
> > enabling needs to be done for that hypothetical architecture then it ca=
n
> > be implemented ... if it is still valid based on what that architecture=
 actually
> > supports.
> > It may be sufficient for the "plan" (as above) to be in comments.
> >
> > >
> > > Existing events are all integers and won't change (it would be weird
> > > for an architecture to report "mbm_local_bytes" with a fixed point
> > > rather than integer value).
> > >
> > > New events may report in either integer or floating point format
> > > with varying amounts of precision. But I'm not sure that would be
> >
> > Partly this will depend on the unit of measurement that should form par=
t of
> > the definition of the event. For example, events reporting cycles or ti=
cks
> > should only be integer, no?
> >
> > > a burden for writing tools that can run on different architectures.
> >
> > Maybe just a comment in the docs then ... and now I see that you did
> > so already. My apologies, I did not get to the last four patches.
> >
> > Reinette
>
> Just a thought, but I think that while it's not possible to be fully
> generic, a parameter model along the lines of
>
>         quantity =3D raw_value * ((double)multiplier / divisor) * BASE_UN=
IT
>
> would cover most things that we have or can reasonably foresee,
> including memory bandwidth control values.
> raw_value, multiplier and divisor would all be integers.
>
> Since raw_integer can be the value used by the hardware, its precision
> can probably be fixed at 1, though we could still report it explicitly.
>
> Fundamental base units would be things like "byte", "bytes per second"
> and "none" (i.e., dimensionless quantities).  (Are there others?)
>
>
> Since we cannot guess for certain what userspace wants to do with the
> values, it feels better to let userspace do any scaling calculations
> itself, rather than trying to prettify the interface.
>
> For example: scaling memory bandwidth percentages for MPAM is a
> nuisance because the hardware uses fixed-point values scaled by a power
> of 2, not by 100: the two scales can never match up anywhere except at
> multiples of 25%, leading to irregular increments when rounded to an
> integer percentage value and uncertainty about what the bandwidth_gran
> parameter means.  Round-trip conversions between the two
> representations become error-prone due to repeated rounding -- this
> proved quite fiddly to get right.  Precision beyond 1% increments may
> also be available in the hardware, but is not accessible through the
> resctrl interface.

Google users got annoyed with these rounding errors very quickly and
asked me to change the MBA interface to the raw, fixed-point value
used by the MPAM register interface. (but at least shifted down, since
the MBW_MIN/MAX fields are left-justified)

>
> For backwards compatibility we probably shouldn't change that
> particular interface, but if we can avoid new instances of the same
> kind of problem then that would be a benefit: i.e., explicitly tell
> userspace how to scale a given parameter.

MBA is not programmed by percentage on AMD, so I'm not sure why this
is considered necessary for backwards compatibility.

-Peter
