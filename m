Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14AA960EDE
	for <patches@lists.linux.dev>; Fri,  2 Feb 2024 09:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706867467; cv=none; b=ss/NGrObwLqyto/MmWQyRRsdi8i6B5W9mLairJCoXfgywdCjG40pKAvD3YjY2aKJ/UFNW7F6yjVnVPTCRRTW0e+dDt4QArhhXI6ZogCns78DHqLN6pJ52deqEfYv+GWFQ2o4DtvxSxfcrC9LcmBKz0kxdcgpaoyGhdfEy9lgwnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706867467; c=relaxed/simple;
	bh=mWtUN8+wyq37EYaboIAsGSBhthdMYojzUMsBsurvNLg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZhtVeUvvh1oE14+qbOyx/7UDEiUbiube+NNeVHw7X/hvP15LSii6TIY77l2woscTl7mAXxqRxLx/k9J5FnGSFlGIL+AIgly3SPoKWPSXXYz7IFM6+lMSI5mdkoPiVOsovSHiDwkmZB2bFENjZ15nn5R8RGplce1H4pEjFYFdqz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zc0ysLYZ; arc=none smtp.client-ip=209.85.221.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zc0ysLYZ"
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-4bdc96cfe21so625799e0c.0
        for <patches@lists.linux.dev>; Fri, 02 Feb 2024 01:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706867465; x=1707472265; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q5O76Y5OEHyuJ5zbglzwN78Qq9NFvbF9mRabgoJIlFg=;
        b=Zc0ysLYZe5MPZrDZEZtj1to+bJ2OSAn8c7RiVZyXezApAxC6DlEEq/djKoSkHB4649
         zsGLCXA4ySrASCtF450i4EJT1zTJi6ZZkuc8lnTAnV947aYn5Qu01uKdpT5RSsPFLEL9
         HSTw6ZmAayY4fzkZSjUPNsEU2xJPajcSQQLNQJezqDqe9FaB2H3qXkiRh/YeNwSG4xI/
         y7TsvZijfy71RDRe9N3+8+WQvOcjtsZXu8wE8vHfBbsbZN6ODqcEg1pQVSVP4ljNm4w0
         Kdv5YlKw/pFTg/iDRO6iu2kMEbf81mLoBpngbBOcljk5Bh/ZQU/ReEI0svB3F+VAbNVI
         +6vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706867465; x=1707472265;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q5O76Y5OEHyuJ5zbglzwN78Qq9NFvbF9mRabgoJIlFg=;
        b=Sox9QBk57vypHhH91ekTYjN9/e0g+5/Pbi0VpNGANa28oU8q8IcHlJyP0fyvWRnSLf
         +5PMkcRJY+3KytYVSp5HC9WfsE8R433Ol5NgmAzKPQQAyPnj8BjKCEYlgE4oLNUMqxPc
         7w2CH+QAD7TSWBtoDaYdGwhFWKGH6P51BrnH4MVVMIk780CNLsXTHBqMuJ3bjo7AaM5n
         C0DzyrCkfxSJkE7NLQZNtXp/Bm9BnnPsZ/AJcN0tRrxMwnCU/YE7AxXbRynJKoZAXdD6
         BD3tiZn0yacugBFIpgMUHtasTs5M3nGoflmR85JraqEc2jRtMWTmHDfN0iLmgGJGn1Ve
         KVRw==
X-Gm-Message-State: AOJu0Yz9Xb0fq3u95oXxcHXZM4KRmGFMCA0Wzi+fQv1PCK/iFPj1AUEA
	0qGFl7y0dbH5z6DhjN6dfsWMBo7HMpeKleRlTn61Co7SyNOy7mFfd0Dc1/CXEWcUPXCHHLbqFrV
	+Gc8TU6G4cQ2EhQDrkTqzghCau4HLhNUPH6Ki
X-Google-Smtp-Source: AGHT+IEkvVp/7egcldbAsqYPdo1psTXXE0ba2s8MIkyNuWcUPbsousyYB2Td/Klh5jB/5oOxmTlqVmX91nXhIo/6oZc=
X-Received: by 2002:a1f:f84c:0:b0:4c0:1387:96df with SMTP id
 w73-20020a1ff84c000000b004c0138796dfmr1965vkh.5.1706867464732; Fri, 02 Feb
 2024 01:51:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240129170016.356158639@linuxfoundation.org> <20240129170020.057681007@linuxfoundation.org>
 <81752462-c6c7-4a65-b9f2-371573e15499@kernel.org> <2024013044-snowiness-abreast-2a47@gregkh>
 <7d963e3f-2677-4459-b60e-2590d6cddc79@suse.cz>
In-Reply-To: <7d963e3f-2677-4459-b60e-2590d6cddc79@suse.cz>
From: Marco Elver <elver@google.com>
Date: Fri, 2 Feb 2024 10:50:26 +0100
Message-ID: <CANpmjNOdRXcok7oyQ=-G7iYthy7f6zHMjJ+TZqGP+vzwRT4+pg@mail.gmail.com>
Subject: Re: [PATCH 6.7 125/346] mm/sparsemem: fix race in accessing memory_section->usage
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jirislaby@kernel.org>, 
	Alexander Potapenko <glider@google.com>, stable@vger.kernel.org, patches@lists.linux.dev, 
	Charan Teja Kalla <quic_charante@quicinc.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, 
	Dan Williams <dan.j.williams@intel.com>, David Hildenbrand <david@redhat.com>, 
	Mel Gorman <mgorman@techsingularity.net>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2 Feb 2024 at 10:44, Vlastimil Babka <vbabka@suse.cz> wrote:
>
>
>
> On 1/30/24 17:21, Greg Kroah-Hartman wrote:
> > On Tue, Jan 30, 2024 at 07:00:36AM +0100, Jiri Slaby wrote:
> >> On 29. 01. 24, 18:02, Greg Kroah-Hartman wrote:
> >>> 6.7-stable review patch.  If anyone has any objections, please let me=
 know.
> >>>
> >>> ------------------
> >>>
> >>> From: Charan Teja Kalla <quic_charante@quicinc.com>
> >>>
> >>> commit 5ec8e8ea8b7783fab150cf86404fc38cb4db8800 upstream.
> >>
> >> Hi,
> >>
> >> our machinery (git-fixes) says, this is needed as a fix:
> >> commit f6564fce256a3944aa1bc76cb3c40e792d97c1eb
> >> Author: Marco Elver <elver@google.com>
> >> Date:   Thu Jan 18 11:59:14 2024 +0100
> >>
> >>     mm, kmsan: fix infinite recursion due to RCU critical section
> >>
> >>
> >> Leaving up to the recipients to decide, as I have no idea=E2=80=A6
>
> Let's Cc the people involved in f6564fce256a394
>
> > That commit just got merged into Linus's tree, AND it is not marked for
> > stable, which is worrying as I have to get the developers's approval to
> > add any non-cc-stable mm patch to the tree because they said they would
> > always mark them properly :)
> >
> > So I can't take it just yet...

So 5ec8e8ea8b7783fab150cf86404fc38cb4db8800 is being backported to
stable, which means that the issue that f6564fce256a394 fixed will be
present in stable. I didn't mark f6564fce256a394 as stable as the
problem doesn't exist in stable (yet), but if the problem-introducing
commit is being backported, then yes, please also backport
f6564fce256a394 to stable.

Thanks,
-- Marco
