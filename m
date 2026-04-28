Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC75C313277
	for <patches@lists.linux.dev>; Tue, 28 Apr 2026 20:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777407385; cv=none; b=uswhmpfniISdKeIsaP9rDJGaCoTa864GyjdQNTH2K9IDUVyEMw/9mE0A+GoCJyAw1PCacSjHQwZx7eyj9EYMWvlD2AmxDWVfO1ISQ5CrWtLQMHGeywuhYkhc1ZxtljWWYwruguevdcD3OmPOfkhJ0ucNMabH0FsA1ZwzvFhkqiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777407385; c=relaxed/simple;
	bh=UtQfTFcQQz26sVGJfaPAfwXb/6VrfQbxAomGRCM0hPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aitdU5jl+aMTOSUMbuQl3idfwdX4kt2dcS+U0kOGso6xBuwsYYJpUIe5kG8wV6UwmZ8Xi8ZqEsFd3e+/rfL6JF27xy24FQ+6YxnkkKAgPO60NvLr8mnANH0uQea/DwfZjvjZQgCn6vxDS465wFNEJb9jdjYvp9k1Z9JdrVhVC1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mgxR2IPq; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mgxR2IPq"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-82cebbdbdccso130056b3a.1
        for <patches@lists.linux.dev>; Tue, 28 Apr 2026 13:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777407383; x=1778012183; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=98FH8HYWYd41s3fr9Etidq2Y/SsuKUn0hQ9/Ra3GrCM=;
        b=mgxR2IPq9AYKYPy7l/AV3J6ABI7xRRefERGRD0OgEG7rIDs6vJCTG5VXISqzPG933w
         0u+NUGhh7BcvtSwpuMpUCJj782oCbpjrwy4A1/vwNJKUnZFlIXz2rq+p9vnZt7NBCv5M
         NQki9c63XV/AQFhmDxqajn0Nev/77GUl79Ca6iuax1kAb0kXWnKbEeGXNR9oPNm70VFN
         nn849XBNZoFK9BHgSYFEge6JsydWQOr6B1xhea/cYBRRNQ87ukpK7isbWdZuscc12y+I
         5D2om7q0yY+T42J1GWf95M8kl+ucDRObKfQPGoXiUepxe0AvLe5Xwu5/6JDfiCup5CMz
         OpIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777407383; x=1778012183;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=98FH8HYWYd41s3fr9Etidq2Y/SsuKUn0hQ9/Ra3GrCM=;
        b=EfndnjG1MTp9J9vHl2x+YiUxLwb+b56KURMu0dShUz2Kbbc1Ps99aYd+zqQlHuJbEp
         KY22KgLY/HHdeWlwceLVZgNxMQIHbddx171mcQ3wUIZaSRxP59EOuhZoefV8JDo1Qp17
         8pwSorcFN58WSJcrx4tNNQxntKfeDQrVtcM1bipFKbep+MuOpTNPx90GeSvaGicMCIoK
         khDoP6Er476GskVC8Ii/ypJj6Wy3Qp9r9G1qBPsxlt42zJ6w3nOntad9Q/0TK4Ioclsx
         /mNGm6+niIqoe1PDN1Ysva27vBgpizufmtFaQHh2qQnPHS7mPMLhYBfIYgHBWQQZjgel
         3XWA==
X-Forwarded-Encrypted: i=1; AFNElJ+p+iN5Dmrms6P9CIeST5Jj0VS2c6d4d18KJO5Xv8NclNf5APdncav37eiQQ192QsE7szpuOQwe@lists.linux.dev
X-Gm-Message-State: AOJu0YzZPP502RGTbFtSqGzPPR9XjMQP6MFWuMMJxaY+r43YJN7ZoKKN
	4fVMHdMC5PKVCm5RWIlS5q/cEU3h+EkgRXcy+1xyhWthzBxyoH1DlDhXIMV3PgiBkA==
X-Gm-Gg: AeBDievHetyJRs8EuUw9eNdAgJOhQsIBvW3n7VO6DtxHPpBQBFOFQj1kUfB5JxLJt1w
	0MQEIssu50676wF2psr0sF+lsqf++ua5KB5aU0cZ7A/4ZH0jbcLARL0Fn++VqoLaDUZDYmfWjRZ
	H57PVz1zLF5t2z70VVzKaoV1rOcV0nLPo82mGVPdzI7fD+0KJ2Jb449SY4vcxWaOrUwgvwomSBd
	CCMvmEdZtzg3wEgg78s2RT07UHgdm39hD3h9864TBCd++gRb9rQfTwnb5AxkQU1SzhOK7urBWhI
	yp/xcJGxZqx/WLHQCg0Ot+Tko3LANNi86I5xA8z8DlN71rP5QZ95pRrRQ/vDeDVL2o4DRYGs3Bk
	fUFeB75Eq0/Ku7qRkV72eJvtSZ4rSR+tXU3+PLcqbAulnWblrJ7MSntBTpEhqZUxqyCoSQi9tfh
	UEhKLooNs7Zz1fsWnWJKPG4H9WxFNDsvGI1TAaDHhRkE0vQbkB5NhsOvdK/FhYRRoQXQporcb2T
	AIg/A9uPlif/0ps
X-Received: by 2002:a05:6a00:1404:b0:82f:47ec:944f with SMTP id d2e1a72fcca58-834ebb80fbemr309868b3a.16.1777407382525;
        Tue, 28 Apr 2026 13:16:22 -0700 (PDT)
Received: from google.com (76.9.127.34.bc.googleusercontent.com. [34.127.9.76])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-834daf6a1fesm3572011b3a.51.2026.04.28.13.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 13:16:21 -0700 (PDT)
Date: Tue, 28 Apr 2026 20:16:17 +0000
From: David Matlack <dmatlack@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	patches@lists.linux.dev, Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH] vfio: selftests: Fix out-of-tree build with make O=
Message-ID: <afEVkVaIjNev8Ukq@google.com>
References: <0-v1-79f29139180b+8e-vfio_st_make_o_jgg@nvidia.com>
 <afD7-rg58XvqRJpD@google.com>
 <20260428190437.GE718365@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428190437.GE718365@nvidia.com>

On 2026-04-28 04:04 PM, Jason Gunthorpe wrote:
> On Tue, Apr 28, 2026 at 06:27:06PM +0000, David Matlack wrote:
> > On 2026-04-27 08:07 PM, Jason Gunthorpe wrote:
> > > The test programs are compiled via a static pattern rule that requires
> > > intermediate .o files:
> > > 
> > >   $(TEST_GEN_PROGS): %: %.o $(LIBVFIO_O)
> > > 
> > > After lib.mk prefixes TEST_GEN_PROGS with $(OUTPUT), this creates
> > > dependencies on .o files in the output directory (e.g.
> > > $(OUTPUT)/vfio_dma_mapping_test.o). However, there is no rule to compile
> > > these .o files from the source directory .c files when OUTPUT differs
> > > from the source directory.
> > > 
> > > Add an explicit chain of pattern rules:
> > >   $(OUTPUT)/% -> $(OUTPUT)/%.o -> %.c
> > > 
> > > Following the same pattern already used in libvfio.mk for the library
> > > objects.
> > > 
> > > Fixes: 19faf6fd969c ("vfio: selftests: Add a helper library for VFIO selftests")
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

With the fix applied from your reply,

Reviewed-by: David Matlack <dmatlack@google.com>

> > > ---
> > >  tools/testing/selftests/vfio/Makefile | 5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
> > > index 40165d087a0bc4..81c3be8298fdc2 100644
> > > --- a/tools/testing/selftests/vfio/Makefile
> > > +++ b/tools/testing/selftests/vfio/Makefile
> > > @@ -27,10 +27,13 @@ CFLAGS += $(EXTRA_CFLAGS)
> > >  
> > >  LDFLAGS += -pthread
> > >  
> > > -$(TEST_GEN_PROGS): %: %.o $(LIBVFIO_O)
> > > +$(TEST_GEN_PROGS): $(OUTPUT)/%: %(OUTPUT)/%.o $(LIBVFIO_O)
> > 
> > Changing this line (with the fix you replied with) is not actually
> > needed right? I tried the following without it and was able to build:
> > 
> >   $ make OUTPUT=/tmp -C tools/testing/selftests/vfio
> > 
> > $(TEST_GEN_PROGS) has already been prefixed with $(OUTPUT), so %
> > in the original pattern already included $(OUTPUT).
> > 
> > Is this for readability?
> 
> Yes, it makes more sense to explicitly match the stems through the
> flow than to have the implicit $(TEST_GEN_PROGS) == XXX/$(OUTPUT)

Sounds good.

> 
> > >  	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $< $(LIBVFIO_O) $(LDLIBS) -o $@
> > >  
> > >  TEST_GEN_PROGS_O = $(patsubst %, %.o, $(TEST_GEN_PROGS))
> > > +$(TEST_GEN_PROGS_O): $(OUTPUT)/%.o: %.c
> > > +	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
> > 
> > Looking at this commit made me confused how this was even working before
> > and I learned that make has built-in rules to build .o files that
> > assumes the .c is in the same directory. 
> 
> Yes
> 
> > I see now that we were reying
> > on those built-in rules to build $(TEST_GEN_PROGS_O). It makes sense to
> > have an explicit rule to handle the directory mismatch between .c and
> > .o.
> 
> Hmm now that I think about it, I wonder if it used the right flags..

It looks like it used the same command that we will be using after this
patch, just with the wrong path to the .c file.

 $ make -p -f /dev/null
 ...
 COMPILE.c = $(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c
 ...
 OUTPUT_OPTION = -o $@
 ...
  %.o: %.c
  #  recipe to execute (built-in):
          $(COMPILE.c) $(OUTPUT_OPTION) $<
