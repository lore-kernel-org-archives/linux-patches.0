Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2DE1DE4EF
	for <patches@lists.linux.dev>; Wed,  6 Nov 2024 17:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730913055; cv=none; b=lbGAUTjeTdlFbS5wWsxG6f+J+m0bqmrn6eLO8A/QzicNv1V7uUithw8Z5QDG9SFtI9DCUHCEvRoeJLfuZrFkVr4FeB/oUi5l1buJw+IpwaNqa7LX6SC2RDKr8cj2OdVVYkGraWDBJ/ETDOkkHa1EglX3fq7aJeFDgSs2qGzZuok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730913055; c=relaxed/simple;
	bh=FvukfTEL1bWKjDoJ5oZqdA2GnBijHiIPloa6eleGgNg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E+Kjxphjr2dbZBthzrQhyTvSExME7mJ+CIHgualMp+XquJALHkPsx17iTw2YC+eXA2uedZnx1TOubdNdFEgSgwUindS1kNympVapR/5O7dhdCnBJyOAy4yjDOsITvZVPcelNco/ILon7sxJcAmuHeJum9TibXT80KqYF4daMYEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NbwxtWEh; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NbwxtWEh"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4608dddaa35so365951cf.0
        for <patches@lists.linux.dev>; Wed, 06 Nov 2024 09:10:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730913053; x=1731517853; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NsE/7ZCffAQOi0z4JToWVEIJiFwRhc9hxIYYUSyZtO4=;
        b=NbwxtWEhF29Y3/omBWz+8gqWP7SCuHChwnPvgsWp5X0Pavg+pkiB0MrH7GwFADQv/d
         rvTSZNsKlV3FKSuq6hqm2PocBXOMRzQhlI6Ty870U7CAbAXexx+Nlnp8W+bAGEaJMlbz
         /jABP/M3eArPw1yM2cVCUrQHK7E4OeVDhH8wjoxP9ZjOktU5hKNhvP+j4VY7GnDGo/7+
         eNh1StK2K47jTD8tMYJQNtALo/+BLw2ZlabipYDYL4BkCXtx3KBJYspgmD9ur8hoYyIQ
         BTyu0vrWJ16Udp8LfS/5Ga9ho5N8TBGfzfVEdSKTGGnVIem/p+NRHKGt7daNWuxibJwp
         XodQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730913053; x=1731517853;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NsE/7ZCffAQOi0z4JToWVEIJiFwRhc9hxIYYUSyZtO4=;
        b=AXP2SG7H4KHI5XRda4xxgTzwDxpBQ8w3U7qw6UORApZw2C6vqPvllW7Q4LUQ5Zgvqm
         Q6+fjMDoKLv6nJbxo5+rXbTBnP/zBD30AqVNwV4IJEmlTQHZ0OEMElBXKc2ULNTp10gC
         qDu0f7KfNbF8IU502l9IQCyi4aAZEcQL/HiKIWdT0xqni6fmWZEbj3Rq32Wqi5ouiO2L
         KfPIS/phkcaKBnQt72eMv1a7m1187jPUkkS5fYOnjQYvnMAB2HwslMzmzJPmQHd31/ai
         D69c/tydckPgr8jBcsj97cVwAmz3GmGamA62sBCcjadam0OtesINKavldTdKAIdaqR/D
         XKmA==
X-Forwarded-Encrypted: i=1; AJvYcCUPozO4j5Ehf+uL5sSGrDzlHC8meHmpxBtVqjYc517kTaC7Ki7QTk3fM/dF4qL/GRb29bk3a/qp@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/1SQJP02bcAjQVTidLt33Bjj6N52OySQMDhrp6UsIOyIZ9ZEl
	SKKUVTPRkexyDOSHu9mocFFjcgY/IoQcYb3AWcBV9GVLeW8wvn3oI3aGhdN3qO5BhFNuAIc+HBJ
	RCUnhcdy5qe8G+rSQ7feeWcKucTeZKcvij25p
X-Gm-Gg: ASbGncsTytVgLlD1Gq82LqssPRusxQWK+etDEnRrIMsXpiBxexbpoq65Sav8ivNf1RA
	20Q891kw8hDKMT3pNeXo+fDb2/fFSmJo9oy5Lez3GkYokt1XWihq6PhaJGwsC
X-Google-Smtp-Source: AGHT+IG4NFWbvUtyY0oIvxTGrRJvSWSDUntbD/9G9q1gPP6/HGFidIeO+LQ7lnPUeNVHrPTR1fHDJnk7auifJQhCPjI=
X-Received: by 2002:a05:622a:528b:b0:461:3e03:738b with SMTP id
 d75a77b69052e-462fa619d72mr555381cf.19.1730913052708; Wed, 06 Nov 2024
 09:10:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241021171003.2907935-1-surenb@google.com> <2024110639-astute-smokiness-ea1d@gregkh>
 <CAJuCfpEAKAePqbB74j8iCQ1JXrvZQbELkAMzdT7dWtvdros-Eg@mail.gmail.com>
In-Reply-To: <CAJuCfpEAKAePqbB74j8iCQ1JXrvZQbELkAMzdT7dWtvdros-Eg@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 6 Nov 2024 09:10:41 -0800
Message-ID: <CAJuCfpGf8xz9Ohsh2mtbyWc7xEU1QSSQapoQ4ZTwFfiJLmPNMA@mail.gmail.com>
Subject: Re: [PATCH 6.11.y 1/2] rcu/kvfree: Add kvfree_rcu_barrier() API
To: Greg KH <gregkh@linuxfoundation.org>
Cc: akpm@linux-foundation.org, fw@strlen.de, urezki@gmail.com, vbabka@suse.cz, 
	greearb@candelatech.com, kent.overstreet@linux.dev, stable@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 6, 2024 at 12:20=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Tue, Nov 5, 2024 at 11:09=E2=80=AFPM Greg KH <gregkh@linuxfoundation.o=
rg> wrote:
> >
> > On Mon, Oct 21, 2024 at 10:10:02AM -0700, Suren Baghdasaryan wrote:
> > > From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
> > >
> > > From: Uladzislau Rezki <urezki@gmail.com>
> > >
> > > commit 3c5d61ae919cc377c71118ccc76fa6e8518023f8 upstream.
> > >
> > > Add a kvfree_rcu_barrier() function. It waits until all
> > > in-flight pointers are freed over RCU machinery. It does
> > > not wait any GP completion and it is within its right to
> > > return immediately if there are no outstanding pointers.
> > >
> > > This function is useful when there is a need to guarantee
> > > that a memory is fully freed before destroying memory caches.
> > > For example, during unloading a kernel module.
> > >
> > > Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> > > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> > > ---
> > >  include/linux/rcutiny.h |   5 ++
> > >  include/linux/rcutree.h |   1 +
> > >  kernel/rcu/tree.c       | 109 +++++++++++++++++++++++++++++++++++++-=
--
> > >  3 files changed, 107 insertions(+), 8 deletions(-)
> >
> > We need a signed-off-by line from you, as you did the backport here,
> > please fix that up and resend this series.
>
> Doh! Ok, I'll resend it tomorrow morning. Thanks!

Added SOB in the new series posted at:
https://lore.kernel.org/all/20241106170927.130996-1-surenb@google.com/

>
> >
> > thanks,
> >
> > greg k-h
