Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A83528680
	for <patches@lists.linux.dev>; Wed, 25 Oct 2023 21:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xj9XPgah"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3575da42138so7595ab.1
        for <patches@lists.linux.dev>; Wed, 25 Oct 2023 14:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698267991; x=1698872791; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YfKUQfUVw2J0FwzBs8kRktoJX+okfytV+T+B1kRuBio=;
        b=Xj9XPgah8aYhMvuiSfzgyGtPLKtTtbFqkvGhw2KZL63Mbp6ER4n/6NUcst3vJH2LG+
         rTXNU70Be/R9WLJhGATqs56iiwCHXgyd+w90IEKccl7pSSW+4ZgI7/j/ztLeLbE+czsl
         +x9WjG/DO1nAY3mZ029oo3WMs0qlhOGBE0K4qCz+lSDijCVxuZ6enLdygxNHMabNtfxw
         wq6GTifazYTtsCxJU/0ceXggm4lpbtCO2KFdMEoJKPYFYa1//JuZOZET413jK7Gkqq5A
         JOTr/mDCk8HQxdYxFC/0BYbusI5CQN5D1qA0qeO/YnDJh5MN1cXJve0bF30miMVRv6lJ
         Z5YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698267991; x=1698872791;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YfKUQfUVw2J0FwzBs8kRktoJX+okfytV+T+B1kRuBio=;
        b=Ca6BYbdhR3dooNAkT25R1tGlcdXjoy+dmbFwe2N2JXioGSEzb5B3nDrezAMiBX8sTM
         j6GF9jccpRP7l/Qq9W23+qUHbr4uPGhK8sc8/IoNKO/4NUwE2PU0Rj0SxQZFaWmWRniK
         IEom9revNI09LsFQqc4IGqBHhlwe5THtSCG6HnS3Is6HDEgFgBkrtbfYLNAaWasUe5fj
         0sTrSE5xTXMSxuBprDJkHa8TiVxkPSNz8iaAjS2llq8yJR0xRGmg27NQewZ1YkOpul5B
         x3kMndKNBqK/azQ+75/WJNTXb+KF+78eQ/XfvctmCXiFAnlRGyfIqLJVIS13giyL49xm
         37Og==
X-Gm-Message-State: AOJu0YyNVoWLJ5Jp/2C0ewN8bYGtOMxgcI7DZ9nBx4xOfZbTXmMtKZIM
	J/PFclTEh/80yB1tyoFj1usVDOC4lLOkCe81skYuvQ==
X-Google-Smtp-Source: AGHT+IEH7+hN0UnU2m4b/Gl5oLvAf7k4M9Ve15jrFHBr/Sc2DlZfGnPuEjrzAsXX50m1rLP8WUI0gf8alcW5t9Zj81w=
X-Received: by 2002:a05:6e02:b24:b0:357:cb1a:9621 with SMTP id
 e4-20020a056e020b2400b00357cb1a9621mr375512ilu.10.1698267991544; Wed, 25 Oct
 2023 14:06:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231024181600.8270-1-tony.luck@intel.com> <CALPaoChftF-H6GauKq4-c_qBJP1GJbR3-ByE5krsaQF4y4y9oQ@mail.gmail.com>
 <ZTluypa9bCWv4k2n@agluck-desk3>
In-Reply-To: <ZTluypa9bCWv4k2n@agluck-desk3>
From: Peter Newman <peternewman@google.com>
Date: Wed, 25 Oct 2023 23:06:20 +0200
Message-ID: <CALPaoCj72V=o60tqsFMRzaeUw-1+rN7pyhsdCyVEV=0tN_CZ7A@mail.gmail.com>
Subject: Re: [PATCH] x86/resctrl: mba_MBps: Fall back to total b/w if local
 b/w unavailable
To: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, x86@kernel.org, 
	Shaopeng Tan <tan.shaopeng@fujitsu.com>, James Morse <james.morse@arm.com>, 
	Jamie Iles <quic_jiles@quicinc.com>, Babu Moger <babu.moger@amd.com>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi Tony,

On Wed, Oct 25, 2023, 21:38 Tony Luck <tony.luck@intel.com> wrote:
>
> On Wed, Oct 25, 2023 at 02:46:53PM +0200, Peter Newman wrote:
>
> > > +static struct mbm_state *get_mbm_data(struct rdt_domain *dom_mbm, int rmid)
> > > +{
> > > +       if (is_mbm_local_enabled())
> > > +               return &dom_mbm->mbm_local[rmid];
> > > +
> > > +       return &dom_mbm->mbm_total[rmid];
> > > +}
> >
> > That looks very similar to the get_mbm_state() function I added to
> > this same file recently:
> >
> > https://lore.kernel.org/all/20221220164132.443083-2-peternewman%40google.com
> >
> > I think the name you picked is misleadingly general. "local if
> > available, otherwise total" seems to be a choice specific to the mbps
> > controller. I think these functions should be reconciled a little
> > better.
> >
>
> Peter (and Babu, who made the same point about get_mbm_state().
>
> Do you want to see your function extended to do the "pick an MBM event?"

What I meant was I think it would be enough to just give the function
you added a name that's more specific to the Mbps controller use case.
For example, get_mba_sc_mbm_state().

It's only problematic that you added a function with an equivalent
name to an existing function that does something different.

-Peter
