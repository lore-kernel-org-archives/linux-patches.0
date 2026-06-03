Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24EF4921AA
	for <patches@lists.linux.dev>; Wed,  3 Jun 2026 21:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780522637; cv=none; b=uEWbKZdPjcvIIw37uOH10hQ7fatdH5c2c4pa/ox8M/trNuNrIeShdI3mD8mPfDQtIBBFBmX7cPe6YPyi7yXvUir0sXCF0ZugvUMa3r/meem7repKT7UlBBCtn6ZaxmM0yjHYDAgVyzhcTzU/M+1wdePi67ZiMoNwknRJM28kGUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780522637; c=relaxed/simple;
	bh=G8aqlWT5bLZQV/uLuybjUVkjg96V4exbndaKeusMIxw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JpN1sfJEgiVuKvg/Oq/5atnnr7xi/tYRAhMkh/cNmyXs1/iQ22wAAIMlIHxSmGtXuj91R2rB/e21FO2+kiuScqyziTdyUqolsGGlAXPp/MAw4IS3N7fkANiCrbdOQ1XnhLdrKXx4fLHgs36t1At9A6b33lsEsuZH13a/ZMkbVHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G5x3b0kB; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G5x3b0kB"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-84226d0f1d2so6479b3a.1
        for <patches@lists.linux.dev>; Wed, 03 Jun 2026 14:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780522635; x=1781127435; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Jlzwef06CJIrE3LIQnd2Z4dg96b07Ks4mMmqsV33wA0=;
        b=G5x3b0kBovvSXXS02Um9BIayOaguSuzhp0F56nCyWygaG2qkkX/5v6y4pf0UWSQVSi
         sFVyI2UtEHkEAKJfvhYz1QKyHp+TGxr501I8kVpUTG/JJtZ0EC5g68VfwjYNHGwQVFv9
         bZAdf7RNhveH9tDiFtOI7+EsrQ623jkBg+78k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780522635; x=1781127435;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jlzwef06CJIrE3LIQnd2Z4dg96b07Ks4mMmqsV33wA0=;
        b=q6hGkqxLCx2sJ/P5x6HaeOVZWtREMuoVsirVSQ54+T0tJ83xqcAltpheE8VmBLXNrZ
         QAPoFZA2RXDaXpGLudiONYkpaN10tVrTsx59qGCV5/M+nhTfJu7ATP/9IBsUNeEVQnOf
         j5DUH16yA9gQYcHQxNczpYnkQ/Gry/lRYuAuza0amytk7gvC8YhMMFcyPAsko3wtr4JI
         Xgh2w6DnwXlH3RSUxCTEZdOl9yEsWsqjg6mhJqMtNCLd722u8M5sR3qxeQ5bGgI0w4kO
         +QkdREwpbcSzpjYCaWMYWYXE47irwG/gtJpWmSj+CjIGwpJ2JqZ40vtVZsMznHX4BWjd
         nzZA==
X-Forwarded-Encrypted: i=1; AFNElJ+t6p+CzmrShLjXaiTX3VIXFf0HZwrJYzSV0KTkCFWh/X8rEdR0CsMMHxtjQlm5+AQWGCCfNPxf@lists.linux.dev
X-Gm-Message-State: AOJu0Yz9BGpGCmaWfCl9z6kvi89Ynamh56OI1dRYyvxNLUw27RcVqEFU
	WOhP3IFJ8sFBWocujjm1ZVyxYFuayW1C3MxQLAAsXgz+Pkz8yy+P6evyjwy0xNBVeI13f9s+Ja4
	NPTRqKCcNuw==
X-Gm-Gg: Acq92OHG+yeGH2Jtasr7eYgi2yu/S5FmhJkgw9lHEtLEXCayz1+ocFFrmlrpAAQ0gJh
	m5KYYBOU84yE2EZ2mryy73g5FJWaInhj6mqs0ZgCEb/aO9UOJ/yHjTlZ5Sk6I6bvMhJ7W799jXx
	oruDsP1z3kZb356skUiaYcT3tT3Jir8lfcwAXuj5xmuXRyJCEtaHsnWBiFO6n6p9S8oGJYGlwbC
	pz6aUnKpJklxDXOP/KzJeIjiF8rxZhztBU0jc2RgttuLo51inl5Tw1o6SQcmqTT09CIjiFbUNnq
	nEg4XnIP3UBn7TB3ov3uSQV9ri8fOj5h/fSwPX7Ro//b9omIcSJla5M3jPKqwlNh0QufCXkD/uz
	KmQM7sTCA5s+E0SYZl9tAF6hHI/2EOSXIdtR7BZx97B5VquJ0YvKhym3sJEbpVmu4SuuuKE/dt2
	9KewGPrcq+K1BrO6zyoFN19+QCZWyECyE2/pdS8KqsdmpioTJ98U9vR2+uS61vGWZedD0Y9nNXk
	eHKCZfdVszo4Mk=
X-Received: by 2002:a05:6a00:a257:b0:842:4fdd:502e with SMTP id d2e1a72fcca58-84284f2ab82mr4987813b3a.48.1780522635171;
        Wed, 03 Jun 2026 14:37:15 -0700 (PDT)
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com. [209.85.215.176])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84282494285sm3739391b3a.25.2026.06.03.14.37.13
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 14:37:13 -0700 (PDT)
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c85825bbc4fso15370a12.2
        for <patches@lists.linux.dev>; Wed, 03 Jun 2026 14:37:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/eeqAMTil07+zsim5eSKeYr2Wn6pHb+138FeuXu27zeCVL6pSwHbiGdZ1psWMA4ScJAgcRkg75@lists.linux.dev
X-Received: by 2002:a05:6a20:e196:b0:398:90e5:a9b9 with SMTP id
 adf61e73a8af0-3b4978a0b2amr4845639637.27.1780522633187; Wed, 03 Jun 2026
 14:37:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
 <20260602225426.122258-1-safinaskar@gmail.com> <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
 <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
 <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
 <CALCETrXzxubt4eWue3+wv7Fq9C2m7uu6bWPstqFh6Mo57bPwQQ@mail.gmail.com>
 <CAHk-=wiEwSjfbjfO74xu=UmkkdHXkJg5QNQ8pP-3iYmunmeV9g@mail.gmail.com> <CALCETrW3XcNLuB1Y6PSkxQDSK2o+=EB2AAd25SjWQqcJemwnbw@mail.gmail.com>
In-Reply-To: <CALCETrW3XcNLuB1Y6PSkxQDSK2o+=EB2AAd25SjWQqcJemwnbw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Jun 2026 14:36:52 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgn3QTLj+F+XccE10dXY-UGWN8+fNLEvhsLw+tik9rOmg@mail.gmail.com>
X-Gm-Features: AVHnY4JdHVy7zfm3YSY570fWNlTEBH8JxW4P9TvGYREa7sUrzYx92vQNA-k2Zxc
Message-ID: <CAHk-=wgn3QTLj+F+XccE10dXY-UGWN8+fNLEvhsLw+tik9rOmg@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Andy Lutomirski <luto@amacapital.net>
Cc: Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org, axboe@kernel.dk, 
	brauner@kernel.org, david@kernel.org, dhowells@redhat.com, hch@infradead.org, 
	jack@suse.cz, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 3 Jun 2026 at 14:31, Andy Lutomirski <luto@amacapital.net> wrote:
>
> I think I buried the lede too much and you're arguing against what I
> was trying not to say.
>
> Maybe we should keep an API that does an optimized copy, from one fd
> to another, that can send from a file to the network with at most ONE
> cpu-side copy.  Not aiming for zero like sendfile / splice.  Aiming
> for one.

Oh, absolutely - that's what my completely untested test patch  basically did.

The user space interface was still there.

And the networking side still continued to use the ->splice_write()
thing for writing to the socket.

It was just the filesystem side that basically now instead of exposing
the page cache directly (with filemap_splice_read) now only exposed a
*copy* of the page cache (with copy_splice_read).

                  Linus
