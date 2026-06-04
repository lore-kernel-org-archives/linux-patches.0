Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716D72F7EF4
	for <patches@lists.linux.dev>; Thu,  4 Jun 2026 15:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780588734; cv=none; b=cZMho7W5QbJHSBWC89a/ZWCDlqs3H39dZh/LMufaGQC0ERGdmOIxK7tgymOU/bqs+P72GshhqlgCdP1eW7/9+x4Au/9f85JAR+5HL5W1ferRv1s/7XjIZdGn/QqHzEs46h9hjb2Tc+xKk34ODARwPFSZ6D66xlw8H5vpRthP6UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780588734; c=relaxed/simple;
	bh=7s0rKR9scvgD84QvTOBiJiUg2JjvF9nGtFbIGJxaif4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t5VAZou9/cfVQnrG4OfRoAxTA+JvHxqM8n3RBX0aRu/4NonOIkEZvTmitqDSWJV7y4iA9wkkc4G78dwjFLLtgtmAFdGJ/lF3B7m8GQcUCYxurWVpJqbxq7hTEjrQPkkAYtppsKcoEUPes6yapKUVbKxaOsrUGxUmtZdJsuZewqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=beThAK+p; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="beThAK+p"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-68be16c61d1so1767654a12.2
        for <patches@lists.linux.dev>; Thu, 04 Jun 2026 08:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780588732; x=1781193532; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7+wqPGUkYgYLzLpNrBl5F+HLbRSqQcg4ZruoWvmFRPs=;
        b=beThAK+pDJzY8GdVDfWc6cXqz1pK6vlUWRrWLNG0vN7X8ij2YzItLqQqFDun8om+fW
         l8iUMYwN/MpSYF68AZaWVDbdBcxsOeooYCu15QDc6UzH8pv7QFA6qImF+8J64N+16GEk
         aDxXwOYmn8F/bHpf7qvWYg7ARDxa1ybyjht1Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780588732; x=1781193532;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7+wqPGUkYgYLzLpNrBl5F+HLbRSqQcg4ZruoWvmFRPs=;
        b=XK08DXZ0vS/ymzUp3o5SYb53zP25rpELnWFDS73ZW5B5rkUeqs59cWYu0IoalZwAJe
         xwW+FnMCIlr7bEuyiGrOrjsH+TUANVkA43k2CfltFSxO15HqqCTaRss2zj0aHFCQ7Em3
         q/t4c1RT30mpM8pdvtI4dXfMpuqafPJZc8IkO+DCDuInzXZKKFMd+7SetJJngp7+KgzW
         urGXdH4iYIb3HdCzaHd9tnjq3xbZb58lR/Yhi65uuCd19teRgs+buKXEdn+6fNZTCVyM
         eecBdvjxjSlZQzOJahfZVQytj4Fq6Gpa7GWOfFDvS3HiUJ4oiWZbEcSaIFdEBgGVjzrU
         KSUQ==
X-Forwarded-Encrypted: i=1; AFNElJ8u2KxWpxdiAMnuJL4qVZ9JeeK8wuqEFidAIp6FNX7XAo2HvRtaNo+uo0Y5h5VhgRaGuOiYewYj@lists.linux.dev
X-Gm-Message-State: AOJu0Yw6JaSf6vA5xRHKEHP83qRCqJdByY88cks7LHTzjo0GRAlueNPk
	nIWnY3nXPCpnyo+sROQf4JbtAbsJJP9Px2SAOwcHM3luyCMdgB2ZZBYG+/XmnoPTaKIPaOcUsCu
	0enhUFfh0Iw==
X-Gm-Gg: Acq92OH+2nnja9C5sB9uFB+wqo/pBkJjubV1Wia5AnMxQc1ABtyQ32D6sgCwEz4lpWD
	ZG9PCDjo6ylAPhNcCxd/k/LGW7ZGUZErSwa9SxRHb1U2jMIYjQI1lfPkdyww1S3BFu/PJ9UPh58
	T5lF1TbIxDCEnEcNyw2hxOtd8OhL+eAS+NFO4zZNQua4nTU6K1HQ3H6kdwUmj+jvOhumRu3GoeW
	9lidTDGpLAVq6IAfzriEY7qPBSM6u/yMDQ18PnfujdUJ9DO/H9EM7cVdAfm7nrgl3Qdylb9hPsd
	GILj0UpQUK79SANOKRtYHfUB7F7NBbaCDKDYkUSKxccxZs4bAKTxBaEC9cPR3tMfK+8G6ylJ9Fa
	/mAkMHSG4JChQ4TyHs1oRdgPJ96Fry03x9L4jO3MzzwU0Zy/s4GUT0s9iGRZzFHHqBF87jAeXoH
	0is6EYKLJ/fmwIXwOAANgtgIfYRsj4Hy+g8vd+h0tsNb2FG8vtdMPC8lRcdrU3jWDACPFVNutxG
	qQAaz+5jBE=
X-Received: by 2002:a05:6402:27cc:b0:68d:296d:9a24 with SMTP id 4fb4d7f45d1cf-68e6e447c73mr4377736a12.1.1780588731785;
        Thu, 04 Jun 2026 08:58:51 -0700 (PDT)
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com. [209.85.208.52])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-68e65851786sm2631110a12.17.2026.06.04.08.58.50
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2026 08:58:51 -0700 (PDT)
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-687ed9aabb3so1755953a12.1
        for <patches@lists.linux.dev>; Thu, 04 Jun 2026 08:58:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8rJ3C5brWtnOybCSGGDEDe9tFjwh9Tn3BgcAEq3LLEXujE3Pk6baBi0tRl1wXaZ22nPyZ8U7f0@lists.linux.dev
X-Received: by 2002:a05:6402:268d:b0:68d:235a:cdaf with SMTP id
 4fb4d7f45d1cf-68e6e447981mr4450863a12.5.1780588730255; Thu, 04 Jun 2026
 08:58:50 -0700 (PDT)
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
 <20260601172825.a51a588ec1c32617a0e12d78@linux-foundation.org>
 <aiEb8CTM-ovMIq7-@1wt.eu> <CAHk-=wiQB-j53cTs9kM4UeXoXPaFj78aJe3D6Yp1Fohg7i4tWA@mail.gmail.com>
 <aiGfgRch99l_5z11@1wt.eu>
In-Reply-To: <aiGfgRch99l_5z11@1wt.eu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 4 Jun 2026 08:58:33 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg0e8pP5haNW4qJP1=QwwUEctwjK5k07sv8bskitoMDgg@mail.gmail.com>
X-Gm-Features: AVVi8Cfm3XRgcYqAOfqktIkPjsqV4jnNlBPsed_wU8pvtWHjKA_FxUEOuJC1FXo
Message-ID: <CAHk-=wg0e8pP5haNW4qJP1=QwwUEctwjK5k07sv8bskitoMDgg@mail.gmail.com>
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

On Thu, 4 Jun 2026 at 08:53, Willy Tarreau <w@1wt.eu> wrote:
>
> > It looks like you're actually doing exactly the thing that I thought
> > was crazy and wouldn't even work reliably: you change the
> > common_response[] contents dynamically *after* the vmsplice, and
> > depend on the fact that changing it in user space changes the buffer
> > in the pipe too.
>
> No no, it's definitely not doing that (or it's a bug, but it's not
> supposed to happen). I'm perfectly aware that one must definitely not
> do that, and it's a guarantee the user of vmsplice() must provide.

Whew, good.

In that case, can you just try the vmsplice patch series (Christian
already found a bug, but I don't think it will necessarily matter in
practice - famous last words) and that test patch of mine, and see if
it all (a) works for you and (b) if you have any numbers for
performance that would be *great*.

There aren't many obvious splice users out there, and even if they
were to exist they are typically specialized enough that you have to
have a real use case to then tell if the patches make a difference in
real life or not.

So you testing that thing would seem to be a great first test of
whether any of this is realistic..

               Linus
