Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E9722D7A7
	for <patches@lists.linux.dev>; Wed, 12 Mar 2025 07:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741766106; cv=none; b=D5Wsg0ES4WM26GhV4azdApTBQceMG3WBAZrYWjdWC/qcPr4S50nnjkq1HS8j7vIxcCKqgqKSs+rvTMx5BCAXPg8oZd2p2rIyLGaVfk7aNFZWs/AhZinYEAHM8BAJSp5hFIOdztlIC34b1cqteycafZje1xSZghkvcCmr26JMs4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741766106; c=relaxed/simple;
	bh=h2yszBlft9w0W0lfus/BAbnguOtEljz4K6kpAn+dE70=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZtvkDNTE8+fxDWSlGxOKnz4y+//2GN0NRtXjxPsZoixTAXjb97COsi9jFmdowEkoLY52aD1rWfG5dmD+hUOKnAScfiGSoCxjrcjjjCmQYep+HzB20ZOhnNvq/Dx+M1wiM5/mVfnOqwJmIXnCk+0YtxbBmbfqe0mmF5BoZrJ1/W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IxvOodqn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IxvOodqn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAAF4C4CEF1
	for <patches@lists.linux.dev>; Wed, 12 Mar 2025 07:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741766106;
	bh=h2yszBlft9w0W0lfus/BAbnguOtEljz4K6kpAn+dE70=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=IxvOodqnHAsI07nfxh275H33Z2nhbPAtQ23ag+Oy0WapCGGYijtKv2cb4Vhs7BIj0
	 WUUce8LiYARA0KNEvkK5yr4dsL3IIbKCbAZjtAcWJzzE6/yoHFNhUoQzrsz2UDoXNi
	 CUHOoLkM7Xo+IAam4DHc4uO3nrRDqFLNbsZs175Yrjw0Cvqt0Z6KkHzVmSsOyUAzOg
	 6tnJ9KSD9+rPyYqJaQayueNTiFltm40hqE8NdxCD7TdaQ0WMO1qFvtvZrhig59YaVV
	 1JeTePMq5MJFRRS30yvKGq2WmqzCvhEXYWjwtYqR4aFcvzcW1DXO53cWUd7rGqfzm1
	 /IZe/+Y+oTMFg==
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-307325f2436so64126271fa.0
        for <patches@lists.linux.dev>; Wed, 12 Mar 2025 00:55:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXuLnWOFQ282OU8Ft0VxjRWxKKiLmZi5H1P5ygu2pBqBWKA8u8LyXwCqHzpAiwV1AilM/OCTV9Q@lists.linux.dev
X-Gm-Message-State: AOJu0YzCnktwjAS51FwTxgqUhnH6t/O71bRafWb0xyZpUmyS2fWcMrYS
	utN96c8/VCbMIdsPOJmtcfTVGjYalLrv3wzJo4kLg3uvKNnZCAyKSpCXNr1mtCfICHD2atc4CfF
	av63MisGnMMCdTLyu+LpL8LsOZ3Y=
X-Google-Smtp-Source: AGHT+IFQ9XrHjp2gqV9ob8Y0l00i8VsXk764ENJISMUi1IJeoLCF6/rUtyL/LZti+kXAsAL+VHMhtP1EVbAQVf89W4w=
X-Received: by 2002:a2e:a78a:0:b0:30c:2e21:9958 with SMTP id
 38308e7fff4ca-30c2e219ca6mr10528511fa.32.1741766104260; Wed, 12 Mar 2025
 00:55:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250213142440.609878115@linuxfoundation.org> <20250213142444.044525855@linuxfoundation.org>
 <c4a1af46f7edcdf20274e384ec3b48781a350aaa.camel@infradead.org> <2025031203-scoring-overpass-0e1a@gregkh>
In-Reply-To: <2025031203-scoring-overpass-0e1a@gregkh>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 12 Mar 2025 08:54:52 +0100
X-Gmail-Original-Message-ID: <CAMj1kXH6oWVkUeU6+JYCuarzc5+AQxfyBzehfmLFRdKXg86qaA@mail.gmail.com>
X-Gm-Features: AQ5f1Jpdj6vU0gsVURehdCeS-elQRRDPafyIXk8k4SqEihBGm8ZJNnumXX6NTzQ
Message-ID: <CAMj1kXH6oWVkUeU6+JYCuarzc5+AQxfyBzehfmLFRdKXg86qaA@mail.gmail.com>
Subject: Re: [EXTERNAL] [PATCH 6.13 089/443] x86/kexec: Allocate PGD for
 x86_64 transition page tables separately
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, stable@vger.kernel.org, patches@lists.linux.dev, 
	Ingo Molnar <mingo@kernel.org>, Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, 
	Dave Young <dyoung@redhat.com>, Eric Biederman <ebiederm@xmission.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 12 Mar 2025 at 08:47, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Mar 11, 2025 at 04:45:26PM +0100, David Woodhouse wrote:
> > On Thu, 2025-02-13 at 15:24 +0100, Greg Kroah-Hartman wrote:
> > > 6.13-stable review patch.  If anyone has any objections, please let me know.
> > >
> > > ------------------
> > >
> > > From: David Woodhouse <dwmw@amazon.co.uk>
> > >
> > > [ Upstream commit 4b5bc2ec9a239bce261ffeafdd63571134102323 ]
> > >
> > > Now that the following fix:
> > >
> > >   d0ceea662d45 ("x86/mm: Add _PAGE_NOPTISHADOW bit to avoid updating userspace page tables")
> > >
> > > stops kernel_ident_mapping_init() from scribbling over the end of a
> > > 4KiB PGD by assuming the following 4KiB will be a userspace PGD,
> > > there's no good reason for the kexec PGD to be part of a single
> > > 8KiB allocation with the control_code_page.
> > >
> > > ( It's not clear that that was the reason for x86_64 kexec doing it that
> > >   way in the first place either; there were no comments to that effect and
> > >   it seems to have been the case even before PTI came along. It looks like
> > >   it was just a happy accident which prevented memory corruption on kexec. )
> > >
> > > Either way, it definitely isn't needed now. Just allocate the PGD
> > > separately on x86_64, like i386 already does.
> >
> > No objection (which is just as well given how late I am in replying)
> > but I'm just not sure *why*. This doesn't fix a real bug; it's just a
> > cleanup.
> >
> > Does this mean I should have written my original commit message better,
> > to make it clearer that this *isn't* a bugfix?
>
> Yes, that's why it was picked up.
>

The patch has no fixes: tag and no cc:stable. The burden shouldn't be
on the patch author to sprinkle enough of the right keywords over the
commit log to convince the bot that this is not a suitable stable
candidate, just because it happens to apply without conflicts.
