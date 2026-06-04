Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42FC3E9F61
	for <patches@lists.linux.dev>; Thu,  4 Jun 2026 21:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780608742; cv=none; b=EbuJvI2N5VnM776Chc4V5ejo/wij1rV9ABKz6w+Vyxn9QIjBKaB840g9AYHp9NalZPIux+VKeDxEQwpDkyxLCXfxwHX3Z2GgjY6kkNcRWY3w+EwCeZ5cVVvI2awhThga4Ol6dLjDmizXrmhQ36Lwi4M2y3qWBNGcMKQXHkc5+bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780608742; c=relaxed/simple;
	bh=SgWKOY85N4QXHw6DJquJOy0hqfu11eB/INo5oQyQqiw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=suf9qjP33xHCjjCdksMrXGqrFXpiUwwIkzP8Vv/HR2VUlzDNEbYI8x29Esd7mnVaFlYv4SLWxPqII0NTFZvqXB/b9rdUi83zLvlabOBwXy+Z9c5VyCz3eHUvEpNAG6QeDJBJmwIeT90W3EBuOVVK17h3rzABlSWaUdiJ1fOCwsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PcJdgKVV; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PcJdgKVV"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490b8ac62baso15811415e9.0
        for <patches@lists.linux.dev>; Thu, 04 Jun 2026 14:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780608739; x=1781213539; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IQN7agybo6gzy0fVoImTNH+8qqV3opcO9FSCB/3Heuk=;
        b=PcJdgKVVBwlRWbK6tvrazkCft4OISWnYqj3sgGmunVKnlPATzhcuQ6lMJwR+g8Akw2
         ZWn5NjcOtwe2+3d8mK8TeVtJp1acbuGnFdEz5op+E0zqILwFxNCl3+4ilFPzkYd3Ukg6
         ob9aUe/sU/PwreMHsHn73lxCndz82/prOakspzdA2eBdq5sQl+xrciNwTMCFalDoN+fH
         BWfWdXlHloDD0AisENiybhBsSOjrOlXpX6wAnTsztsqjNRQLL415HBB/U0xscdf9gS2S
         iiRIYab3eQ8rlDWfHn2FMfuMCttk6Og3i7+r69ZRRz8tcpD+ZoXUWSkBMzyBkT2Q7Vkn
         jNNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780608739; x=1781213539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IQN7agybo6gzy0fVoImTNH+8qqV3opcO9FSCB/3Heuk=;
        b=SaUicFbRNbSBizGjD1ZJzeDhRXX9fpsnWg6k1IkBc3A8DhqxiCAChTFL6AdDKw+dcn
         ugVUD9EYQe++fDe47sSqiqtoZI4942mDYdui++w+q2Q66VyOvZFiwCfTWtghBtOWBH/f
         JtAIYLAF+RS7zpVGnzQu2PV9qPjhNM+T5zb8WsUhGS1kT5EVILb7ZPCMD6BuRqrWH7Pq
         LlXNtov0+DAT7t8GfF1ZfaK/0ldKrEsCOw4GbLp9Sk4lPHjLrsf3W2jpN0qhUbpg75QS
         FwXteeD88nYNQImgb/8UA1hVf0WNotFJNze4sZ8ysz9RnRRIqBn2dEi7LfP6AJkpU1Yv
         PaWA==
X-Forwarded-Encrypted: i=1; AFNElJ+0Y0fcQbTiRVyV2cMHkGNkJtjwYZ//8ptACVLXn/ySC1Cz//IkZHCSVWjSk4gfVvfhhb4uwxSe@lists.linux.dev
X-Gm-Message-State: AOJu0YwNPUimwKxRZHYw1txAVSVmY7VggGpSteZt3+j0Tp4W3IWBps0T
	0nEozBCSwm0q+Drw9wF4YMx2iJbVuC0B6kkEhduNooGBXNNC6QND5cJu
X-Gm-Gg: Acq92OFd1cU+J+58z5ajDQ9z69SGee70fCGmtF+QfrIaI8WWFmCcKOhkRCYrDfgdGxH
	dZH5T0vkRT/x0WASnlxBZgS1tsLcwMDXv9q0CsZscWT4RLI1jKkm5nFhlNaUB737OE4JRVkTL1b
	Vw9zGu1RrgXC/Ez8vdEYOsM1lpW0lDYPRAGlNzlT9+2pifvLciaucr3ETUxF9joiwIG0zihO60e
	iUfdY8j67K91ayE2aTP+1Ws1674+qTQQwoPQ/Ns8BHK3hbVVTu78Hgkbq8oe0phRZG1RmsAeavq
	QNfGLf0Vn7buQZnVniLVmw5zHOe3zWTpXxgNdLrgh9TPh9HbXR3rkaGGQQ9KR6BHHyUrPOXvdne
	7EEBDy2YJcka/aIYRzSUG9nE4q3nnKhU6KQJi+iuHLXtB62L7O3e6VoNShCgKbsKd27tic1at4g
	yTdK/dASVNBXTOP1nJYZkF4KDLdJ0qocOCSYzgMFzoeZoX0WfGGKggJEekRFDI3sPzScAnWM8=
X-Received: by 2002:a05:600c:348f:b0:490:4b89:5372 with SMTP id 5b1f17b1804b1-490c25e2739mr4133095e9.11.1780608738825;
        Thu, 04 Jun 2026 14:32:18 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3918fcsm111713545e9.3.2026.06.04.14.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 14:32:18 -0700 (PDT)
Date: Thu, 4 Jun 2026 22:32:16 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Askar Safin <safinaskar@gmail.com>, metze@samba.org,
 akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org,
 david@kernel.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz,
 linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu,
 netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de,
 viro@zeniv.linux.org.uk, willy@infradead.org
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260604223216.73468830@pumpkin>
In-Reply-To: <CAHk-=wip3mwLOHOYJ9TtjDxOaq9YUXmuCg2AycyASGgeY6qqUw@mail.gmail.com>
References: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
	<20260603211736.755139-1-safinaskar@gmail.com>
	<20260604100609.6b37f500@pumpkin>
	<CAHk-=wjvb56qo27-axALOKCY-CjLsj9_294zeBovPVJaYm14dA@mail.gmail.com>
	<20260604183829.63c35fd9@pumpkin>
	<CAHk-=wip3mwLOHOYJ9TtjDxOaq9YUXmuCg2AycyASGgeY6qqUw@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 4 Jun 2026 12:30:30 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 4 Jun 2026 at 10:38, David Laight <david.laight.linux@gmail.com> wrote:
> >
> > Bool is another matter entirely, (IIRC from a couple of weeks ago)
> > gcc will assume that the low 8 bits of the parameter register are
> > either 0 or 1 and clang assumes that the low 32 bits are 0 or 1.
> > You can't even check with 'if ((u32)bool_param > 1) error()' because
> > the compiler 'knows' it can't be false.  
> 
> Nobody should ever use 'bool' as a system call argument. Anything that
> takes a boolean should take a 'flags' field with bits.

I was thinking of more generally, not syscall arguments.
In C you can't really guarantee that a 'bool' variable will always
contain 0 or 1.

Even if you write: https://godbolt.org/z/81P87vv7o
int f(char *p, _Bool b)
{
    return p[b ? 1 : 0];
}
you get *(p + b), neither (int)b, !!b or (b & 1) make any difference.

Talking of broken compilers, had you noticed that:
struct foo {
    int a;
    char c[32];
};

int b(struct foo *f)
{
    return __builtin_object_size(f->c, 1);
}
returns -1 (size unknown/indefinite).
You can't use __builtin_object_size() to stop code running off the end
of anything referenced by address - even when the size is constant.


> But this is basically what a lot of the SYSCALL_DEFINEx() macros are
> all about - sorting out ABI assumptions.
> 
> For example, on powerpc (iirc - maybe it was 390), a 32-bit argument
> is always sign-extended by the ABI, and the compiler *depends* on
> that.

I think riscv might sign extend 32bit values in 64bit registers.
x86 and arm both zero extend.
Zero extending is more friendly to the kernel where pretty much
all values are non-negative.
I think I've used signed variables slightly more often than fp in the
last 47+ years.

-- David

> But at system call boundaries we can't trust that the user side
> actually follows the ABI, so SYSCALL_DEFINEx() will actually take a
> 'unsigned long' and turn it into a 32-bit argument so that things like
> this are well-defined and you can't fool the kernel by not following
> the ABI rules.
> 
> The same would be the case if some system call actually takes bool
> (but I don't think such garbage exists). The SYSCALL_DEFINE() macro
> magic would take the full register content and *force* it to follow
> the ABI conventions, whatever they are on that platform.
> 
>               Linus

