Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F811F8929
	for <patches@lists.linux.dev>; Thu, 14 Nov 2024 10:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731580300; cv=none; b=rYjSLsMgxaec3otPnHKOocUhGDU2d/EudosExbh8bshPj9O5aPfqs/bdTv2mxxd2jK3NYBtTOTB+PTaJeClXoc8nn0YtY+lQBnA+ujByFecmBYjJpT8MUX69eRyYK7OwDwWVk58uaRCdkiVFI5nLkLs53RbvwpTtGNrp/tEohh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731580300; c=relaxed/simple;
	bh=1HMteR7GeWi+aLLIBziHVSG/j/GJwhJ4tatT18md6O8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZH6DCc/4Hwe42wlKgOTyHZU9FVvdF9k3VACSYh/Eb/77O6lCpFJWJvN5nzoKJ9sN0VeUGgRR5qkJzXGcOSRLtolO4NpVzqAfCaQnnT/Goik9n+g9bxD7zv9sKJhKcwzVHbxLJLh1XCCW2+PTzwcAgQzztqNU8K3sosaonzxInnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=omIi9qip; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="omIi9qip"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5c9404c0d50so510936a12.3
        for <patches@lists.linux.dev>; Thu, 14 Nov 2024 02:31:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731580296; x=1732185096; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=330+bk+cS3icGrLIMivP9QZx02A0SNk2s2BiDL/dZNI=;
        b=omIi9qipRa+r/2unssEHphq3uVyrldCf/x1Zbo9nT/UpMKZmo/dULlx3JN0+5hr8+G
         4rw1HvlBfuaY0Xtuubq52A/WIczEcqYCLIhHjOj3NOvqT+h+QXAIZJKrzZWWe8h1oYaS
         5ua9Uy8UofbK7+w6eiX2RVjVnna+kYzlqCfEynqvtnw2Tp2CQQRCfaBiHtjUuWAJGm5a
         raKWuNrLTazyC5V3YlzQIa6WO4svELStd98bjXvHmL4tzxjDxoEPMkIQnrap56ftaTrI
         BCc7WnraOP544qAiMMqsUR4mKr0xPD4MJMOf8u6jEmsWTJbpDEk7n8LsTcG32uCMiE3r
         i+Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731580296; x=1732185096;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=330+bk+cS3icGrLIMivP9QZx02A0SNk2s2BiDL/dZNI=;
        b=uMky+RbCKaORlFSQO5enQEpapSBX3vzP2tCMZSmm/5FdUB96zcqNFHirJsno8QnYIb
         CJ9y98muwD9CbxBjl0ZkPe156V6w7Gomg0hCadHdill2Ht0uc3wc/3DMcAp58gYjAgD/
         pEuCS7U4fJmCE/Xv++8w3WpH7Y4m11bRl2qwzwC9iVVTWgAeRYSSPk6YHUqZLyIQ+Gax
         T6cT2Lf663ei7VU0rpKbOYPavjOWoOemJYrqNA/8OIA7w2rOqRYYbbhaSspC7Wq4FUXq
         6d26+bXxrUlH0C65AaiCuZPYHSS0StSDwvlreXv32majvz41YNsfFnDGbPRJjPgXYXQp
         bLVw==
X-Forwarded-Encrypted: i=1; AJvYcCVOo4JLZA8xLCnkAU9dWajLusUwq3T+3KeYoG7PgejKMUJ3AVPEPQY3Ung9yw2Nvs0HTHLyEMkH@lists.linux.dev
X-Gm-Message-State: AOJu0YxMudi8m/LJqrAhwi5fSELDlS4EOXiQ1T9C9TE/IoYD3NL/UK/H
	OzYVgCyckUeYJmc/reJxPtboNhmvlcLynkkjOizGanYbkgv9NxRon8fIdc8vDFxb6ZeWuJJuM9Q
	cEVMphyvfUVrExkBPjZ0XwoP4a+IkT2zabiRD
X-Google-Smtp-Source: AGHT+IFqjZNothSKY3NQ7z6Ssb06hcvdumgEbAL12tHf57bGbqlxiboD7hH6ovHLn0T5dGBaodALGFZhMKIIJi3hdzo=
X-Received: by 2002:a17:907:3e1d:b0:a99:4aa7:4d6f with SMTP id
 a640c23a62f3a-a9eefebc409mr2436865566b.12.1731580295828; Thu, 14 Nov 2024
 02:31:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241029172832.93963-1-tony.luck@intel.com> <20241029172832.93963-4-tony.luck@intel.com>
 <f4845fee-3f91-4e78-a186-a7bdc58f7873@intel.com> <ZzUvA2XE01U25A38@agluck-desk3>
In-Reply-To: <ZzUvA2XE01U25A38@agluck-desk3>
From: Peter Newman <peternewman@google.com>
Date: Thu, 14 Nov 2024 11:31:25 +0100
Message-ID: <CALPaoCi94amaO4ALGhLPn=zWEJ3STJWyYid4L+kMjXYf9wKqAQ@mail.gmail.com>
Subject: Re: [PATCH v8 3/7] x86/resctrl: Refactor mbm_update()
To: Tony Luck <tony.luck@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, x86@kernel.org, 
	James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>, 
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>, 
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Tony,

On Wed, Nov 13, 2024 at 11:58=E2=80=AFPM Tony Luck <tony.luck@intel.com> wr=
ote:
>
> On Wed, Nov 13, 2024 at 02:25:53PM -0800, Reinette Chatre wrote:
> > Hi Tony,
> >
> > On 10/29/24 10:28 AM, Tony Luck wrote:
> > > Computing memory bandwidth for all enabled events resulted in
> > > identical code blocks for total and local bandwidth in mbm_update().
> > >
> > > Refactor with a helper function to eliminate code duplication.
> > >
> > > No functional change.
> > >
> > > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > > ---
> > >  arch/x86/kernel/cpu/resctrl/monitor.c | 69 ++++++++++---------------=
--
> > >  1 file changed, 24 insertions(+), 45 deletions(-)
> > >
> > > diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/=
cpu/resctrl/monitor.c
> > > index 3ef339e405c2..1b6cb3bbc008 100644
> > > --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> > > +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> > > @@ -829,62 +829,41 @@ static void update_mba_bw(struct rdtgroup *rgrp=
, struct rdt_mon_domain *dom_mbm)
> > >     resctrl_arch_update_one(r_mba, dom_mba, closid, CDP_NONE, new_msr=
_val);
> > >  }
> > >
> > > -static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain=
 *d,
> > > -                  u32 closid, u32 rmid)
> > > +static void mbm_update_one_event(struct rdt_resource *r, struct rdt_=
mon_domain *d,
> > > +                            u32 closid, u32 rmid, enum resctrl_event=
_id evtid)
> > >  {
> > >     struct rmid_read rr =3D {0};
> > >
> > >     rr.r =3D r;
> > >     rr.d =3D d;
> > > +   rr.evtid =3D evtid;
> > > +   rr.arch_mon_ctx =3D resctrl_arch_mon_ctx_alloc(rr.r, rr.evtid);
> > > +   if (IS_ERR(rr.arch_mon_ctx)) {
> > > +           pr_warn_ratelimited("Failed to allocate monitor context: =
%ld",
> > > +                               PTR_ERR(rr.arch_mon_ctx));
> > > +           return;
> > > +   }
> > > +
> > > +   __mon_event_count(closid, rmid, &rr);
> > > +
> > > +   if (is_mba_sc(NULL))
> > > +           mbm_bw_count(closid, rmid, &rr);
> > > +
> >
> > As I am staring at this more there seems to be an existing issue here .=
.. note how
> > __mon_event_count()'s return value is not checked before mbm_bw_count()=
 is called.
> > This means that mbm_bw_count() may run with rr.val of 0 that results in=
 wraparound
> > inside it resulting in some unexpected bandwidth numbers. Since a count=
er read can fail
> > with a "Unavailable"/"Error" from hardware it is not deterministic how =
frequently this
> > issue can be encountered.
> >
> > Skipping mbm_bw_count() if rr.val is 0 is one option ... that would kee=
p the bandwidth
> > measurement static at whatever was the last successful read and thus no=
t cause dramatic
> > changes by the software controller ... setting bandwidth to 0 if rr.val=
 is 0 is another
> > option to reflect that bandwidth data is unavailable, but then the soft=
ware controller should
> > perhaps get signal to not make adjustments? I expect there are better o=
ptions? What do
> > you think?
>
> Skipping mbm_bw_count() is also undesirable. If some later
> __mon_event_count() does succeed the bandwidth will be computed
> based on the last and current values as if they were one second
> apart, when actually some longer interval elapsed.
>
> I don't think this is a big issue for current Intel CPU RDT
> implementations because I don't think they will return the
> bit 62 unavailable value in the IA32_QM_CTR MSR. I'll ask
> around to check.
>
> But it does mean that implementing the "summary bandwidth"
> file discussed in the other e-mail thread[1] may be more
> complex on systems that can return that a counter is
> unavailable. We'd have to keep track that two succesful
> counter reads occured, with a measure of the interval
> between them before reporting a value in the summary file.

At least for the purposes of reporting the mbps rate to userspace, my
users will record from the files one per second, so it would be fine
to just report Unavailable (or Unassigned when it's clear that the
error is because counter wasn't unassigned) whenever either the
current or previous reading was not successful. Then they can assume
the value or error reported always refers to the most
recently-completed one-second window.

-Peter
