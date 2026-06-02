Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461023806C8
	for <patches@lists.linux.dev>; Tue,  2 Jun 2026 22:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780437987; cv=none; b=NmsgYozZ4PqIbN3594Bn0yJinS+L0m/DoHyRL3qO8xLd4i1seAZIUbhk2aoklxzKYqxdmdb/zsoA38Yrsp8UAXzy0T5XKcTBbLKAHq0Te9XFzgFy8SW4VrSTArg3kT0pRkqqY11XFFyogwFY3GctfhypE9cDwMC2JK86zK/HJT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780437987; c=relaxed/simple;
	bh=ggdn1Kxplzazv5OLdinIKnlry9LYLtLaNuo30kwvE0w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qsiPFDnLGkVrDmDuN5kiuaXkH/xQaoX5HKrzv8kWOUPOb4qZy/28u/Nvw6D2TMqsYli7egdTdgaEY9x0IP6jfziZyfqQDxEoKvU+r33aL0a3BY4MrvPSC+nXs1Jey23w56k74QgNqmhJ2/9VxlFjvu5beuB88EKA82uJ6tibcq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MR+geuTz; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MR+geuTz"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-bec450b950dso409049666b.2
        for <patches@lists.linux.dev>; Tue, 02 Jun 2026 15:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780437985; x=1781042785; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Qw8RVcymrwPdvtyZ+lyACgxH7IqaYDBeV32TfvS6Ats=;
        b=MR+geuTz6utXkcnQcEPBW+fcQCNTA3by9ddjsXORcmjqG2N5cxA398NhkbMr77q1gm
         3G/wgFRy3X38ptLnMwP/tplXojD84XkgrvFcLBTxm8dBtuDPTc6TB1eH7HdlusoB7HKI
         SBYnHpIiQTyR+xwfGADlfu3nflaLGXHAvy6/E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780437985; x=1781042785;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qw8RVcymrwPdvtyZ+lyACgxH7IqaYDBeV32TfvS6Ats=;
        b=dF9/2OxFSw0mLHgkzRFIg5tOUqigT8J6hDXi+F0dKIqU30IM4fKt5NC3jG5DsUNluF
         ZW468hxwWaaNch/9EkL/Pzzn4QTfNENgVehCxeKe81rGVd7ruy9acI3TD13tY/NuIHrb
         WsLWdNGq9mYxRkZwW331MxzARk9WUJHIA3ItpzD1tEPiEsjzRMuudMJ5aWUNT1RcE9Vh
         AmXzFEa7aMCapA+bYJLZhbGkx3VCWob498nlLx0/VQSrplH63YPVoTRZ2NrlLiVCX0m7
         3hwdhSKL0mISCBpy0X96ov+cPRHkszSCYcjKADHvPUYR/ft8O0mF5QkxIvy1yVYNHZXU
         Z6PQ==
X-Forwarded-Encrypted: i=1; AFNElJ8nm0ykslnD7AZP5FMS0IrpJfdxVAKXCyeg36hTQqDIbeJCqyHMaNMVKZN3I9hWLrSHmeMkw5pB@lists.linux.dev
X-Gm-Message-State: AOJu0YyJrZuZiHjUSd90ykq7wZzZILl/+RJgCN+iZxd+BpLP+L+RtuK5
	GLWcdsKt/atj+c1PmiS6oLw5BiVakupQjDd6bY0Ty+ILMy0Qsxfcl3T3v07O3exUrYIHZkHrgmn
	iAxI9Um4=
X-Gm-Gg: Acq92OFZHk2Gt5HSlv9g2QmBFjLFwqnxs1Sj7luT8pPF1Lym43cmygXaLJWd3HUFntl
	6F1BIk6yL9ic4zfLnCArAOl0lhnvczv26R7FTsq7c5c4dOtaqGXWOOyMeCwICiNF5l9JfvzDu6d
	usOGJO2jAYk/V2d9FFR+0ZKvbGJGjB41PynPUozpwdMQ39EfumLT6bpRvdi6WDh+WKVCCf7eoPE
	enRbi9FdEhiJT9Nxe9UYbK8N7Tq91h2tz7Go7xng0vDMm+IqURMbqYPagmAKKAFzRWpxBwBRTbT
	8F3Wid2AHNZbIWdgP5u7+m72a1xZNAimyiizdbHBb8/dzFMNGgPISKLwUNdNUs4o73tFgr/q5Nc
	7LqbFDVrkYJf+2aJBZ+ExK7G5SpfK8bjuhvmDFAllYJl8ZG5iC3N1nJJ0KHFM+1MOElrTNAiSnf
	JIGRmd4QWZJaFqsURqxE0xxRrWZZ11Bh0f3BjBY0zV/dXwrL3eZfCqknrVwTKcExNa78VSkW1n1
	iOs00sfzZo=
X-Received: by 2002:a17:907:1608:b0:beb:9dc2:6f3f with SMTP id a640c23a62f3a-bf0aef03808mr14862766b.36.1780437984669;
        Tue, 02 Jun 2026 15:06:24 -0700 (PDT)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf0517712a7sm43794166b.4.2026.06.02.15.06.23
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2026 15:06:24 -0700 (PDT)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-bec405a6ea5so484580866b.0
        for <patches@lists.linux.dev>; Tue, 02 Jun 2026 15:06:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/R+FQBtv5JFganrramdjDmq4/lSNeNJrooLn0iX2lKdMG1cluOT+r7lox5tGCbw/CbgEJUC2ht@lists.linux.dev
X-Received: by 2002:a17:907:3f19:b0:bed:62c1:f7 with SMTP id
 a640c23a62f3a-bf0ad9ebf64mr15174966b.20.1780437983314; Tue, 02 Jun 2026
 15:06:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ahv16ogY8Zx3Rtox@pedro-suse.lan> <20260602211242.13870-1-safinaskar@gmail.com>
 <ah9LaPQayJ6tBE53@pedro-suse.lan>
In-Reply-To: <ah9LaPQayJ6tBE53@pedro-suse.lan>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 2 Jun 2026 15:06:07 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
X-Gm-Features: AVHnY4La_ZzADdnhLw7VXJvUOP1cc6TzuLIwNWiX_o8vXHDUu8ML9nZoEC5oxec
Message-ID: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Pedro Falcato <pfalcato@suse.de>
Cc: Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org, axboe@kernel.dk, 
	brauner@kernel.org, david@kernel.org, dhowells@redhat.com, hch@infradead.org, 
	jack@suse.cz, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, viro@zeniv.linux.org.uk, 
	willy@infradead.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 Jun 2026 at 14:37, Pedro Falcato <pfalcato@suse.de> wrote:
>
> Well, that's most definitely part of my patch. Also, you cannot outright
> remove splice() functionality

That isn't what Askar's patch ever did.

You apparently didn't even read it.

Honestly, I think you are the one out of line here.

Askar did something I suggested years ago, and didn't remove any functionality.

It just changes vmsplice to be a copying model (one of the directions
already was). It doesn't change regular splice at all.

And yes, it has the potential to be a visible behavior difference - if
some insane user uses vmsplice and then modifies the buffer
*afterwards*, then that would be semantically different between a
zero-copy and a normal copy.

But that would be insane behavior, and was never really reliable
anyway even with zero-copy (ie subsequent writes to user space buffers
would potentially do COW breaking based purely on timing and memory
pressure etc, so anybody who relied on it being visible wasn't goign
to get it realiably anyway)

Perhaps more importantly, it has the potential to change performance -
zero-copy *can* be a performance win, although typically it really
doesn't tend to be (looking up the page mapping is often slower than
copying).

I would expect it to be very clear in trivial benchmarks that aren't
actually real loads. And probably not visible anywhere else.

But your responses have been making it clear that you didn't seem to
actually look at the patch or the history of it.

Trying to make it look like Askar is the problem is only making you look worse.

Anyway, the vmsplice() thing is queued up in Christian's tree, and I
guess we'll see if anybody even notices anything.

              Linus
