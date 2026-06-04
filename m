Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB993A4523
	for <patches@lists.linux.dev>; Thu,  4 Jun 2026 15:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780588411; cv=pass; b=W20+U6Hg3sQ6mg2vO8wLzhCcgz70BxOvtG9QgjijwkwdnaHbs9Qb/n9Z3z0mmYE3tqqF5Nnvc5zvFwPugO1XOeoTfrv1/KnBu/fJ3BHpPyXn3XdAVyOTwPXnekUo7iJlwJAvPDCs3mLsS2CjB03SRrow0lkyUXjbBjhGUR3oN7I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780588411; c=relaxed/simple;
	bh=DHE3qIm1NUuqilEHDVEIKI0Gv9gNlT3AX89YAbcKkxE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ePOBgFihLf5GTixdZwIgovHAZ6dtvx8SjRTcUXwVFT+rpsPxePWvJpVZJISHRpI/H3lUG1z+qdAqkuzli3mYS3xS4p6ceTpdMpAi9BQsRQz8NUyWlnOE9bji5tXqtPfUPbFUqiy0xxkEvYc53kDGblriR6x5iEaIIf32nk25dnU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b=mKQLGRZf; arc=pass smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b="mKQLGRZf"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-39677c80386so9625411fa.3
        for <patches@lists.linux.dev>; Thu, 04 Jun 2026 08:53:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780588408; cv=none;
        d=google.com; s=arc-20240605;
        b=T40QqNvrAGrfhwR+wm3by2RW0mKQA1fJ+Nq1zNTNtibHC4UkJ9cVJFihmibfwWlIHy
         s9Q/Z+/kdNwDDuibMvmFHo5rUiS9UyogAnDO5joiAA2DoL8TQw/YVP0evfa8Ft9aVsWt
         IaL6PDFkSasX3AeFDHQTeuN7NZ1ZGMR5sCFpLVARITTawks7/CRBP/M9Ip5ofuubXfw+
         Yquv1lKlsI2a+ToOCFoOCNr8OuJw1jcJtk89cP3AcdYXR35irz8LmJhQVz4m0igvXA2d
         PCexwvZ7S9qz4xsN84OvDXwdFxWkVfeCzvZBB2fActJmgdnBwk2H/eWvP7Stf4+jwnK6
         ppIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=B6H/bsprACHYwfP1VnZci/atvKi9rC7jAoAwzWHNDIk=;
        fh=uP/MYxbA919mOQN1812U1QWavvdYSHYO+hPuLkP0JCc=;
        b=Y9hlbZXUb4upRemzfQYQD2yccNsuKWiaNIqFKBFpuAx6cRoo24tguWn9mCaIeJrTjX
         SHxVY8vra8e7Zs/dndLxWmAOdrtF+xsShEE9Lize6kluCTPjKsMusuWaDX2qlT3uekM6
         f84D7cEkBignwi6t5fHY7XYUyJSEwZPqaW36SF4g/47QwIJ78Yv2To3t6ePUH1ROmEiV
         t2f0BZpR79ZBrh5Wu7rRSII629DA98ZfS2tZPINnLjCf7WUyRR5hzf9r9EX5gX//hDyv
         Yw8GIo7hHyne9NU3VJj6mG1RUkEBhzrw0qaOoVn9pI/s+odttofQffyB+jJHb/o1MMum
         EKGw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1780588408; x=1781193208; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B6H/bsprACHYwfP1VnZci/atvKi9rC7jAoAwzWHNDIk=;
        b=mKQLGRZfIZ+Ih9FvrKxAvrNZuxu12UW7ASq+Q/Mgd8OVIKqGKGIn+DftQ/mAz4V9gC
         sLuVgLUwt3PB/8W+IiOhiOCgJ8y7/WFzQAmYRq7RApby3yaBqem9pl7hmRqjrArOHgQk
         vuoy2C6Lb7EY9AUldRNyTOUrLVsBSig8wZzo9r8VL7/yQBaZEXz8O2xNMkIdwnj8b4wD
         K2JGW7Sgco4y6+hHjuuSRV40AYLaoSa6KyB/IgD/7C+3bzRBkm8WA2bfCXmySqSa0+/x
         DoKXXGxw0BzdXJw9uBYVattPYVuP0YstKGOtG2+repRSKvhbm7ZXASBRVpKnf1mxCBSK
         H2tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780588408; x=1781193208;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=B6H/bsprACHYwfP1VnZci/atvKi9rC7jAoAwzWHNDIk=;
        b=OI+we6JT679N5G/uL4SNvS9dXgkUWFNYdOTjsSBs1+4FtQ2U/eT2ykdnjIcgqItc88
         CBBc9jvCDCZVSkWFiVQFdLsj/CCDAaIkfDVIaBn4WRVBkKIriw/xfgLoaYozmP5KkJpk
         KTz0A+N+dGMDKfP84+EbW+FSIRRpWN6WZkFQYRNQZSzHbMGC4cT4U8JhFhOHCMA4WW0Y
         yV/hhQ5Ti6gRHXRaNQX1AcsR67om8066bfIh9TIrhO7Dh9ys/X7D5QCdXWPb0yzNP2M9
         CVnHlBgXqYdFzzVVremZgo0wb4ue0pyukK3ejpD9tGZbHGd9YQjWlBP9jMZ6mcq5KwzB
         KFwg==
X-Forwarded-Encrypted: i=1; AFNElJ8XXpBG2oqiDCLgvQaqjlAFpmNvImgQemCW86dHXIqmleIhxG/bN2QxIsSBSX8kZ0AKbEUs/tQH@lists.linux.dev
X-Gm-Message-State: AOJu0Yy4zrciK/m2+TohDl6YsSiAgpfvi1nOKlqpu+A/tVcU+NQe8JQF
	FtdwvorGeftj1qCUKSPEleH9M7NCZG4lhWJamQs78aPtYcNdV69hMmJWeEuKG8E4+9MvNtBia36
	T12YSr9lZi5jcMOAN0cZTkXVD+ZVnzqFeRicxmcld
X-Gm-Gg: Acq92OFkpfBt8Gg9I0ytK/zi4SO2rZ3Sa/sxwwCdhl1op68rC3IH4ijLjMdX9l5tVas
	yN6c8AC07F+8UfkP9oBGOZsEPqGl31Dx/jAobjquq5J2VrOTKo16z0hUtS5pNHBmjP4p4q22xBG
	CCFTZkSsz5STntoM8jVo2cVPmWBU2drBoTFpkeKi8KafLR7cNJpD7acB/bBQaAiiTVnE5gISnaN
	l5ji/54OsDHe7sMrmfhEJEMI6rfbY0NvGRREqNdSW/dkgYb3Y3eA6xrjv1zb9N/g+z0MMh3TtVK
	81dxenJHRGeJXGQldm8hwpeFKA==
X-Received: by 2002:a05:6512:3186:b0:5aa:7126:c63c with SMTP id
 2adb3069b0e04-5aa7c0888ccmr2415181e87.5.1780588407521; Thu, 04 Jun 2026
 08:53:27 -0700 (PDT)
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
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 4 Jun 2026 08:53:15 -0700
X-Gm-Features: AVVi8CcFmOEXliFqkwckAyyy2jg3Zlvf93FEoWWD2xBje7cN4CAoI605l5f9FiY
Message-ID: <CALCETrULMixRGJyGqAAujW7RN6PP2f_Orn2Y_0hpPMjRqQnY7Q@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Willy Tarreau <w@1wt.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Christian Brauner <brauner@kernel.org>, Askar Safin <safinaskar@gmail.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	David Hildenbrand <david@kernel.org>, Pedro Falcato <pfalcato@suse.de>, Miklos Szeredi <miklos@szeredi.hu>, 
	patches@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 3, 2026 at 11:32=E2=80=AFPM Willy Tarreau <w@1wt.eu> wrote:
>
> On Mon, Jun 01, 2026 at 05:28:25PM -0700, Andrew Morton wrote:
> > On Mon, 1 Jun 2026 16:04:55 -0400 Steven Rostedt <rostedt@goodmis.org> =
wrote:
> >
> > > On Mon, 1 Jun 2026 18:33:25 +0100
> > > Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > > On Mon, Jun 01, 2026 at 10:17:23AM -0700, Linus Torvalds wrote:
> > > >
> > > > > TLDR: maybe we could ghet rid of "f_op->splice_read". *That* woul=
d be
> > > > > a big simplification.
> > > >
> > > > FUSE might be interesting - fuse_dev_splice_read() and its ilk.
> > > > Communications between the kernel and fuse server at least used to
> > > > seriously want that, so that would be one place to look for unhappy
> > > > userland...
> > > >
> > > > splice-related logics in fs/fuse/dev.c is interesting; another plac=
e
> > > > like this is kernel/trace/, but I'm less familiar with that one.
> > > >
> > > > rostedt Cc'd (miklos already had been)
> > >
> > > Thanks for the Cc. The tracing ring buffer was specifically made to b=
e used
> > > by splice and the libtracefs has a lot of code to use it as well. As
> > > reading the ring buffer literally swaps out the write portion with a =
blank
> > > read portion, that portion (sub-buffer) is used to be directly fed in=
to
> > > splice, providing a zero-copy of the trace data from the write of the=
 event
> > > to going into a file.
> > >
> > > trace-cmd defaults to using splice to copy the tracing ring buffer di=
rectly
> > > into files to avoid as much copying during live recordings as possibl=
e.
> > >
> > > Whatever changes we make, I would like to make sure there's no regres=
sions
> > > in performance of trace-cmd record.
> >
> > Well yes, The patchset seems sensible from a quality POV.  But to make
> > a decision we should first have a decent understanding of its downside
> > impact.
> >
> > I haven't seen a description of that impact in the discussion thus far.
> > And that description is owed, please.
> >
> > I assume a small number of specialized applications are using
> > vmsplice() to great effect?  What are those applications?  What is the
> > impact of this change?
>
> > Once we are armed with that information, is there some middle ground in
> > which we de-feature vmsplice()?  Fall back to pread/pwrite in the
> > tricky cases and still permit vmsplicing if the application is
> > appropriately restrictive in it usage?
>
> I'm using vmsplice() + tee() + splice() in high-performance applications,
> load generators to be precise, and soon a cache. This is super convenient
> and extremely efficient:
>
>   - vmsplice() is used to prepare a "master" pipe with data to be sent
>     over TCP or kTLS
>   - then for each request, we do tee() from this master pipe to per-reque=
st
>     pipes.
>   - the per-request pipes are those that are used to deliver the data to
>     the socket via splice().
>
> So we effectively use vmsplice(), tee() and splice() here, and for exactl=
y
> the reasons they were designed: only play with page refcount and not copy
> data. The code is here for the curious:
>
>    https://git.haproxy.org/?p=3Dhaproxy.git;a=3Dblob;f=3Dsrc/haterm.c
>
> and its ancestor is here:
>
>    https://github.com/wtarreau/httpterm/blob/master/httpterm.c
>
> It simply doubles the network bandwidth compared to not using that.
> (62 Gbps per core vs 31). I would seriously miss it if I couldn't use
> this anymore.
>

Wait a moment.  This is neat, but it's literally just a benchmark,
right?  I skimmed the code, and it doesn't look like a production
workload, either.  And you manage to get around the awfulness of the
vmsplice API's complete failure to tell you when it's done with a
buffer by ... never actually changing the contents of the buffer.  Do
you have any idea how you would write correct code that uses vmsplice
for sends and then *ever* mutates the data without literally
munmapping (or madvise or something) the data do you can safely mutate
it?

> I also have mid-term plans for using vmsplice() to deliver contents from
> a cache to sockets as well via splice(). Right now our cache is split int=
o
> too small chunks (1kB) to make that useful, but as soon as we can move to
> 4kB pages, it will make sense. There the same gains are expected, and I
> would particularly dislike the idea of no longer being able to implement
> zero-copy!

If I'm understanding you correctly, you see (and measured!) a
performance improvement, and you would like to use it in production.

It seems to me that this is an excellent opportunity to remember that
vmsplice gets a performance boost in a highly synthetic situation that
sort of resembles a cache scenario and then to deprecate vmsplice and
build something better!  Or discover that we already have something
better, perhaps :)

https://man7.org/linux/man-pages/man3/io_uring_prep_send_zc.3.html

I see that this can submit a buffer without a syscall (tee + splice is
*two* syscalls!) and that it has directly addressed what I see as the
really big deficiency in vmsplice: "This second notification tells the
application that the memory associated with the send is safe to get
reused."  If I were writing the user code, I would very much want that
notification to be an explicit part of the API instead of making a
wild guess as I think I would need to do with vmsplice.

--Andy
