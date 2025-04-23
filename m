Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7532A5028C
	for <patches@lists.linux.dev>; Wed, 23 Apr 2025 13:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745414836; cv=none; b=OQGZdfcyZaXAyMe2CUZuGYH1nZVsFl7Rl+2FNPLBhYU7eeIHH3URRCJeY/h+OAMyNp2GbZKrMmj1FohnM9Z6RkMfDh5qflgyxDSC1rYTELztUMSbJ/XqSzsFEEEuBn5t98G3Ne6IR0cjC47TAUCJ3xukpxXLIwBYUcMcbKK1N+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745414836; c=relaxed/simple;
	bh=r5VvZ+6H3OMMjfp7RddtCjFspc2yQo0NDN6hVetGZCU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X1J9nG4mcm9BKOU2vnh0hqyzjakNFM9aiMfhHWX19VxCd4X9wr1lmsUmEXs8kGeUe2O15BAH0fGAt170heZ+LBKnNg/wyUnEziZLzdSQuxuk09FQJ77Bt/6Zt4SmYKepF3KmM5h9fjZK2H1MU6EUWQf7VOdalYqqX/lcUBEyoj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v+Brh7+e; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v+Brh7+e"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5f4ca707e31so9636416a12.2
        for <patches@lists.linux.dev>; Wed, 23 Apr 2025 06:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745414833; x=1746019633; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dcncMv+nTyN7AX4p/6ZVtkA6cHW8pNX54c4aUzPSBxk=;
        b=v+Brh7+eZmDh2hRWVArhCHHHp7t8TWmFmsRt+NG3SKVzv82ooHiJUn9wDcHy6blP67
         fkQi0wMZhxwUiS+jwtHT0Jsq7Va18RNLzroB/k+DRQ4s5VBuyU8VWF3HFWXgrCgoWOrm
         FvIf5SUUApTXWCuLixBswhF+4eNI+1pHirrik43Sm4ExNadnhp6w6wbIJqqpoD0OVZ3x
         u7YN59R8QL5Q0RBV0F/5SnIiBKCASG3MbX0JujZaDXVePANCyZQXNNK27R3ms8J2PqoX
         VDtE9IHBomkXYXoNPSPXpIq2iiwfv5n9Xo7xP7sEll10kyj6W5/4TFRwcbRp4I4zmNuN
         kmTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745414833; x=1746019633;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dcncMv+nTyN7AX4p/6ZVtkA6cHW8pNX54c4aUzPSBxk=;
        b=cBcUmQC/pbVaR7g4CDwfivrZjrgSa7mlu7TATXjTAa+WYoKhjQKhpq58LTjaCPhgCF
         3svZ6PyEGX0BMKfZAt/F0JRVGBlIiLghrrZMd+4QKxkFWYNZcwsJl+uLw4Vu0K9h5rwq
         quWXSkjwXwdyZ4HHcghnsWI9aU0bOiE1jHd2Wak8ZaBsoxip5YDivoeq6ojvXXynBljH
         i/XDisOP8lWiIlo0leDFK/O0GRc41T3teAG3K08YS47UEVVop0w8ymt0l1sTRn9UZTYX
         IXeaS+usD07P7QuvYQ3Q6EbjXGfntoBYdGA6ozBkp0PJOvIPM/BSYVrvYzNyG/F8T39s
         st7A==
X-Forwarded-Encrypted: i=1; AJvYcCULJUU/edyRNoOrRDJjlwelmjSVbb0SRoAJ/qeaYLBYfrCQBPyhbtvdJQM0t0QSnjTXKeC4Ta6W@lists.linux.dev
X-Gm-Message-State: AOJu0YxJErqHn53Tfi/JJa8CbWhDKVNZb9ymJSvEkxowclMT+r+RxseB
	lG0cRCBixKOIO7rt+/DsAVEkWxn/8h4fs9zkAtB8zBc8rhLnPjmvYaSia6fN/aecu1WlReCjOzJ
	7n2bhfcmWd+dXKL8XoisH2hs4DU5r4wWMq6ea
X-Gm-Gg: ASbGncvZcLN4dbos8ZwgV/TIztmep7gMmT6E1+VgG2ZcZ85mQ0TuxprJi8SAifyy4yk
	0ibhndsIIN2skIDRIDqq79kwivjZ4DoY3IjgaGAD8QZso0wojTpC7l42x0mHWUpJOHGUIL+iVwv
	+/wJbpFIrboY78dYtDg7ntP5SPdB9VrsMW1rbL7gcUgS7hUOWqPtW7
X-Google-Smtp-Source: AGHT+IHqfjo5JSUQ+T2i4Czed2ZmkEBgksO5vdSXSTw5/zzbOdIf97zMyg27udiGbR0eiKA7E5k59J7edBc7MNFbbDY=
X-Received: by 2002:a05:6402:2695:b0:5e5:c847:1a56 with SMTP id
 4fb4d7f45d1cf-5f6285251eemr18242995a12.10.1745414832483; Wed, 23 Apr 2025
 06:27:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250407234032.241215-1-tony.luck@intel.com> <20250407234032.241215-11-tony.luck@intel.com>
 <da51ba61-4ff0-4db4-a55f-743f6a3ea7da@intel.com> <aAaqbUk3gZbCan13@agluck-desk3>
 <bda6d0a8-f621-4745-a578-a7f2c9784925@intel.com>
In-Reply-To: <bda6d0a8-f621-4745-a578-a7f2c9784925@intel.com>
From: Peter Newman <peternewman@google.com>
Date: Wed, 23 Apr 2025 15:27:01 +0200
X-Gm-Features: ATxdqUGdmBOfwfQO8b3FDwUu9_DXlwEJu_azNuwXepNeHaoKgb0I4fhE4vFuSww
Message-ID: <CALPaoCimCmSyeejR9FCLcitquwenmOo0-0PVngUMtmSr_syy-A@mail.gmail.com>
Subject: Re: [PATCH v3 10/26] fs/resctrl: Improve handling for events that can
 be read from any CPU
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, James Morse <james.morse@arm.com>, 
	Babu Moger <babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, 
	Dave Martin <Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Reinette,

On Tue, Apr 22, 2025 at 8:20=E2=80=AFPM Reinette Chatre
<reinette.chatre@intel.com> wrote:
>
> Hi Tony,
>
> On 4/21/25 1:28 PM, Luck, Tony wrote:
> > On Fri, Apr 18, 2025 at 03:54:02PM -0700, Reinette Chatre wrote:
> >>> @@ -619,7 +622,8 @@ int rdtgroup_mondata_show(struct seq_file *m, voi=
d *arg)
> >>>                     goto out;
> >>>             }
> >>>             d =3D container_of(hdr, struct rdt_mon_domain, hdr);
> >>> -           mon_event_read(&rr, r, d, rdtgrp, &d->hdr.cpu_mask, evtid=
, false);
> >>> +           mask =3D md->any_cpu ? cpu_online_mask : &d->hdr.cpu_mask=
;
> >>> +           mon_event_read(&rr, r, d, rdtgrp, mask, evtid, false);
> >>
> >> I do not think this accomplishes the goal of this patch. Looking at mo=
n_event_read() it calls
> >> cpumask_any_housekeeping(cpumask, RESCTRL_PICK_ANY_CPU) before any of =
the smp_*() calls.
> >>
> >>      cpumask_any_housekeeping()
> >>      {
> >>              ...
> >>              if (exclude_cpu =3D=3D RESCTRL_PICK_ANY_CPU)
> >>                      cpu =3D cpumask_any(mask);
> >>              ...
> >>      }
> >>
> >> cpumask_any() is just cpumask_first() so it will pick the first CPU in=
 the
> >> online mask that may not be the current CPU.
> >>
> >> fwiw ... there are some optimizations planned in this area that I have=
 not yet studied:
> >> https://lore.kernel.org/lkml/20250407153856.133093-1-yury.norov@gmail.=
com/
> >
> > I remember Peter complaining[1] about extra context switches when
> > cpumask_any_housekeeping() was introduced, but it seems that the
> > discussion died with no fix applied.
>
> The initial complaint was indeed that reading individual events is slower=
.
>
> The issue is that the intended use case read from many files at frequent
> intervals and thus becomes vulnerable to any changes in this area that
> really is already a slow path (reading from a file ... taking a mutex ...=
).
>
> Instead of working on shaving cycles off this path the discussion transit=
ioned
> to resctrl providing better support for the underlying use case. I
> understood that this is being experimented with [2] and last I heard it
> looks promising.
>
> >
> > The blocking problem is that ARM may not be able to read a counter
> > on a tick_nohz CPU because it may need to sleep.

If I hadn't already turned my attention to optimizing bulk counter
reads, I might have mentioned that the change Tony referred to is
broken on MPAM implementations because the MPAM
resctrl_arch_rmid_read() cannot wait for its internal mutex with
preemption disabled.

> >
> > Do we need more options for events:
> >
> > 1) Must be read on a CPU in the right domain  // Legacy
> > 2) Can be read from any CPU                   // My addtion
> > 3) Must be read on a "housekeeping" CPU               // James' code in=
 upstream
> > 4) Cannot be read on a tick_nohz CPU          // Could be combined with=
 1 or 2?
>
> I do not see needing additional complexity here. I think it will be simpl=
er
> to just replace use of cpumask_any_housekeeping() in mon_event_read() wit=
h
> open code that supports the particular usage. As I understand it is prohi=
bited
> for all CPUs to be in tick_nohz_full_mask so it looks to me as though the
> existing "if (tick_nohz_full_cpu(cpu))" should never be true (since no CP=
U is being excluded).
> Also, since mon_event_read() has no need to exclude CPUs, just a cpumask_=
andnot()
> should suffice to determine what remains of given mask after accounting f=
or all the
> NO_HZ CPUs if tick_nohz_full_enabled().

Can you clarify what you mean by "all CPUs"? It's not difficult for
all CPUs in an L3 domain to be in tick_nohz_full_mask on AMD
implementations, where there are many small L3 domains (~8 CPUs each)
in a socket.

Google makes use of isolation along this domain boundary on AMD
platforms in some products and these users prefer to read counters
using IPIs because they are concerned about introducing context
switches to the isolated part of the system. In these configurations,
there is typically only one RMID in that domain, so few of these IPIs
are needed. (Note that these are different users from the ones I had
described before who spawn large numbers of containers not limited to
any domains and want to read the MBM counters for all the RMIDs on all
the domains frequently.)

Thanks,
-Peter
