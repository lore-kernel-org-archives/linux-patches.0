Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27EF82DECDF
	for <patches@lists.linux.dev>; Thu,  4 Jun 2026 14:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780583512; cv=none; b=PfvEJSPiT3xgkGpe+CrUEOyB6fEcCOSsBdCTxEsVeWYLFwK14+i9XaplsM6j9btyFhF4W0VtL4t1SRYrv+a7HQUfaxmI+HFI80BSHMNZ0Lu1uNNGO4z+Suq6yM87eN0niMcNhSB75vI1A5PxLGUKQjnU8M8o0kKvPTK9Sq3x0kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780583512; c=relaxed/simple;
	bh=+HiAUq8B9doNx03/+UK5dzZU592ZQOyFYQ50hXTQNq4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rKjNeTagwKu8ywGt+a42/UWY8UsitnPVrEXJ/v8XL4YfSdRt/S53r+Y0g3/+im0rXw0xnjiu3cVv1Ye5oGzTRprbDXyM4MVil0H7PptJ/yK/oepWwK+oPnVYESSOYBLCA0oEw0Ygm4zNFU9DN8oJYXav4Btg3j6zPdP8hO6H/zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N+0ZBQOJ; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N+0ZBQOJ"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-bec3ffb95dbso126182266b.0
        for <patches@lists.linux.dev>; Thu, 04 Jun 2026 07:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780583509; x=1781188309; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jHCD/usXrKJEgEC7iBTBFv6T3P+9p6Aw20cG/HazQio=;
        b=N+0ZBQOJWtNXOl1441bt7BtHg9MIuObVQfiUdWcuQoXwwmsaz5JzaAqFB5+ktlTkpA
         5DKfnmOLBheXy+z8aYhYisyYs6fjwBYAuDDrBBX5Qvv/dmkIMbRn3mjt8jdy0i+k0zTz
         IhlQId69KPWXMTVDZFqJdYmBBRcwAUtlvHK88=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780583509; x=1781188309;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jHCD/usXrKJEgEC7iBTBFv6T3P+9p6Aw20cG/HazQio=;
        b=gYz6F06+q33xnMgUALEehFV65YZdzMACnYs4MQ/GMtZms63pmk9CJC1WhhCnu8H7LZ
         Q8hqIxalwyIUDDw04Fqbqs5c3WbZyLNsemB72hbF0RRm8ud9pbNeYt8LdEJIy6Owvrha
         SIOxXAMJCO6rckIBEHdNxCkSkUt9Cmrba90NTwrRJ5+sfFYb3map47fwcGJDCcuZ5beW
         zx6DJtMjG/0Ae/fgQpqQ1aQX9dWS1+wjbwpPbb1ISNDwtrwyyDk1DiqJKJvX9wGdGQa4
         PuP745YA4Sm0TebPbm/vHR8jVD+i2ndoerlOQ0l0TrZ+3Pq+PETQPI7F2otpKUJssZ5e
         PGcQ==
X-Forwarded-Encrypted: i=1; AFNElJ9B55FC4eANyofQTV/jFa1vaqqtfr921XtUIijZq0++MVtU5oStbqOJElmrSuPE5J9Z+FKeSJWf@lists.linux.dev
X-Gm-Message-State: AOJu0YyCHJW/TWrySzvdmupTSOU9Ra4gKDaA4In/3bZ8oVD0P7M1wbL9
	y6hleLGRh8kLeI/jrwUEX7vBLkBL7dq3dZjiJU4hsg/F07sUZfVmfqdO5lC6I1MdKMxEACgySrm
	tZjXSnR5fgA==
X-Gm-Gg: Acq92OH9WqDrCm7YnNtKdyEfgRyW3++gxOq3A+lnvwLtiF6wZ9T98GMYVvdJnXLfZ6q
	vut/MSWYVAYoi/FXKz7BN+PWb7mOxcP+9WfJ7JG/xhGxDoDza03k4pamvZmDYrfhMq4vUS5wCDU
	fYo7zJT2jogmeW7SCAlSTr0aRSNJSsDi52ZBSqaCyXYfK4QyacXp9Sbl9m3rI72RQVxG8+46T9q
	9JzL9lkbWPiA3UpATqCxZdoIN5UcgapDS7BejNnShKeMjiX3BZAz7708owPT3uvdz9RUy3K2jeY
	KTEcuVTi7KWfxlBhVK4iq4d2HPXsO6vYQEAu+hpQ/cY5jdBCH23/KFKoXuQ2gEeU1z99BXWovZ5
	65+3cbHzC7TVn5ZHVSmpJwE2XtJE7TP0uNpKsRA4/XhwR0qO1kvt4KcPnc+4guizO0P59ibq3Yh
	tdCQ1//dNl+dLRqAE55dTBjEpCWxE3oBcHQlYVP/JrpcGkvIBS4+Ri/CFew5iaE8ScXkwTe1rDu
	UWtehMwEUs=
X-Received: by 2002:a17:907:398c:b0:bef:1df6:12de with SMTP id a640c23a62f3a-bf0a5a46991mr451069066b.0.1780583509262;
        Thu, 04 Jun 2026 07:31:49 -0700 (PDT)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf051d82a78sm310728866b.18.2026.06.04.07.31.47
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2026 07:31:48 -0700 (PDT)
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-68c32f3c6d6so814233a12.3
        for <patches@lists.linux.dev>; Thu, 04 Jun 2026 07:31:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+FEQ3RBrllvppoeZpW8dXRohud1O9Jd+70Eb8C2pTl1bE0NTSSV5WrKzA4hkqLB1ZeCvF09dbF@lists.linux.dev
X-Received: by 2002:a05:6402:43cf:b0:688:12fd:789c with SMTP id
 4fb4d7f45d1cf-68e70412737mr4177929a12.9.1780583507075; Thu, 04 Jun 2026
 07:31:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
 <20260601173325.GH2636677@ZenIV> <20260601160455.2c187574@gandalf.local.home>
 <20260601172825.a51a588ec1c32617a0e12d78@linux-foundation.org> <aiEb8CTM-ovMIq7-@1wt.eu>
In-Reply-To: <aiEb8CTM-ovMIq7-@1wt.eu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 4 Jun 2026 07:31:30 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiQB-j53cTs9kM4UeXoXPaFj78aJe3D6Yp1Fohg7i4tWA@mail.gmail.com>
X-Gm-Features: AVVi8CdMcH2Yi8zy-bOiW7jRaCCsKof-RnAg4JQ3nwUYFdve2Wu3l5Vz6H4KhIU
Message-ID: <CAHk-=wiQB-j53cTs9kM4UeXoXPaFj78aJe3D6Yp1Fohg7i4tWA@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Willy Tarreau <w@1wt.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Askar Safin <safinaskar@gmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	David Hildenbrand <david@kernel.org>, Pedro Falcato <pfalcato@suse.de>, Miklos Szeredi <miklos@szeredi.hu>, 
	patches@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"

On Wed, 3 Jun 2026 at 23:32, Willy Tarreau <w@1wt.eu> wrote:
>
> I'm using vmsplice() + tee() + splice() in high-performance applications,
> load generators to be precise, and soon a cache. This is super convenient
> and extremely efficient:
>
>   - vmsplice() is used to prepare a "master" pipe with data to be sent
>     over TCP or kTLS
>   - then for each request, we do tee() from this master pipe to per-request
>     pipes.
>   - the per-request pipes are those that are used to deliver the data to
>     the socket via splice().

So most of those would actually not be affected by any of the existing
patches: the pipe->socket splice would remain, the tee() code would
still just take a ref to the page count.

The vmsplice() would change, but looking at your haterm.c sources, it
looks like it's mostly a fairly small thing ("common_response[]" being
16kB).

That is typically *faster* to just copy than look up pages.

HOWEVER.

It looks like you're actually doing exactly the thing that I thought
was crazy and wouldn't even work reliably: you change the
common_response[] contents dynamically *after* the vmsplice, and
depend on the fact that changing it in user space changes the buffer
in the pipe too.

So that would break *entirely* with the vmsplice() changes if I read
the code right (which I might not do) simply because that looks like
it really does require that "wrutably shared buffer after the fact".

Interesting.  Because the vmsplice() code uses get_user_pages_fast(),
and honestly, it never pinned the page reliably to the original source
- it breaks COW randomly in one direction or the other after fork()
(and I thouht even after a page-out, but thinking more about it the
swap cache may have made it work for that case).

Uhhuh. That does look like it makes the vmsplice() changes untenable.

But I may be reading your haproxy code entirely wrong.

               Linus
