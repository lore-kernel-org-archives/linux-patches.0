Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8A73A382B
	for <patches@lists.linux.dev>; Wed,  3 Jun 2026 20:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780516802; cv=none; b=mfH6QHLsFxkZb0Xt8RTNmt0mshlBUlU+BGzN5nA3c1aCDeMcXhA2atGZLgFzCCPLTtKBmSQGgQGC8j1/2fA8YiwVv8haVR9mHvFawFQqXnFwWqiQeXth9oGSja2eXgcBOc0cilu2OUXpvbwQMU/YQ7cXn0BvRObyXaBoxvfdTzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780516802; c=relaxed/simple;
	bh=cJCdMggMBtlaRufFOzf56NF2SmvXVse1UnTO+KmUUY8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CqCf/O29C7PSAXW/5y4glOoIC7/95uZ9hj2HklAOKbomYHClprcqKL2mtim21vjcKttk3zFLtB8QOxr6H7KqByofzD6PYqoeylV/iYnTb3EPkNv0XMs4f+gFC5ma3mZUdubqz2JIDgacLrVzEi+8gapiFlFhaIX78wId/pPlRNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ctCSSxev; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ctCSSxev"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2bea7176c72so102669715ad.0
        for <patches@lists.linux.dev>; Wed, 03 Jun 2026 13:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780516800; x=1781121600; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rLwU6+VwyCgHprpb82bpoZ1vCU00viaTeQ4mjhQKQr0=;
        b=ctCSSxeveOgJYbPOn8qG4/71mTx62zBWrGRLocWurkwGVvmb8iSpX6DKzigetApnwt
         mADgv2yyJXiKQqQq481XGuDDDbkMwftLs4W5Z4HxP/QdWbZGsC7YnDT4s/pXnp0a2N77
         cRXegS0YpO6Et8nbjW1wtqBIO+DF1hISGcSeQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780516800; x=1781121600;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rLwU6+VwyCgHprpb82bpoZ1vCU00viaTeQ4mjhQKQr0=;
        b=CZ8alf67Ac29ffigW43PJbaglNX/beWvad3NwuriZ65x4eMX3kmJ+/KhuH4pH/3cql
         cCquVHDFDYoV2Hcosk5+PSmOwJ+NtiS2bseu0K76x4+rv6zRNZGTbIWQosgm2HQ35JsB
         /xlEu7hnujqWlvpMtr5d9RO1KeBwtRXFRXtPEnfSnBej+rEMRTZibxgzz/fDRtPeVMFL
         DyP4F9c06VWNBBWzJMph5n+Nvg2j1kZ271frOfO79fZ8zqwGn/2++68pefh3z7npbm5w
         QbwHzP2p+zQIoOYImT9e+MozvxJYRuNAGxCdP/OaE8UXdIbmxiQtBtzAVCcxYrZD1S7D
         13Ag==
X-Forwarded-Encrypted: i=1; AFNElJ97ZxckPaO1pISu9rYi9ni1B05iqiGnIv6Q8J24emlbJZM9e7vfV5s9JXLvN6NolzHfPPnNXmQc@lists.linux.dev
X-Gm-Message-State: AOJu0Yz7grqWoU56yz0X1FV83m2Xf2ag3KdIKMhWW6+3OqrgttdM/hqT
	1FWBCQpwZTHXlMdzhl3WeBdYu5x0VuwO4BsiaOXst+ToH80ZusBpfQs6ObghBQ0mFkGU40fbNwI
	QPS2d/Gql9w==
X-Gm-Gg: Acq92OFho/Ayt0vCmwoJ257NrCqtyERR2y5aN3mGdIYn+tZ1Nl7R4yhcceiaXIlldK7
	w5yPG1e+q1NoC+FW2kUuUFHdY3vubGI25htbObyI/gjzEaO5EmkhaxuYzah2yE61pbffDLxxUYV
	/F41PtpnHVpDzdcacrFOBnMO/eAcxOQ2e9jGd85iOm5zKIhY0gdO4kqQ+e3AkX66kfwETNpEh+E
	W/MmVFadpD6g64TxvLUKVRQO2DDDS5GlxiKfnObxUG6C1+aXbiwYGgw9cdl6ZeWWCkLGPLaLDfs
	xgT74h3KAuaGhV+qqUzQy6HkUEAXSH8BLjIIiLXiiff2gBm0ianx6CW4yenasgeupTsxZjM6WsV
	rYZ4uNl1iMFEkTat6rhluxtr55WOHkrPGLlgSG1AE1KG4FWRIMwcFfYFulQdhsv6f+tQmhEnPoz
	+pb/8eoGb8VzDvReELvsZSeSM0iHBav/IJ7zouQTjpjDlrI8cIz4yOwTVY2LcDH+KnZSTi038j2
	rvFdgaRAx8=
X-Received: by 2002:a17:903:3d05:b0:2c0:fa4e:91f5 with SMTP id d9443c01a7336-2c163a242cdmr52108745ad.15.1780516799789;
        Wed, 03 Jun 2026 12:59:59 -0700 (PDT)
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com. [209.85.216.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c16609e61csm33934415ad.43.2026.06.03.12.59.58
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 12:59:58 -0700 (PDT)
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-36dac5d5da0so1961182a91.2
        for <patches@lists.linux.dev>; Wed, 03 Jun 2026 12:59:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ97JoSQSQYOo4urJycwyzL6iVT3PzdetnL9RYr3PHlIXnU/Rieusk1q/OQ8G6DY+fM8LLhi8tWo@lists.linux.dev
X-Received: by 2002:a17:90b:2f86:b0:36b:77b9:5c8c with SMTP id
 98e67ed59e1d1-36e3237e125mr4484034a91.17.1780516797989; Wed, 03 Jun 2026
 12:59:57 -0700 (PDT)
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
 <CALCETrXzxubt4eWue3+wv7Fq9C2m7uu6bWPstqFh6Mo57bPwQQ@mail.gmail.com> <CAHk-=wiEwSjfbjfO74xu=UmkkdHXkJg5QNQ8pP-3iYmunmeV9g@mail.gmail.com>
In-Reply-To: <CAHk-=wiEwSjfbjfO74xu=UmkkdHXkJg5QNQ8pP-3iYmunmeV9g@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Jun 2026 12:59:36 -0700
X-Gmail-Original-Message-ID: <CAHk-=whkGbMoP-Dym8pAd3hV21=BZST+6sK++1X038+9Q-TgeA@mail.gmail.com>
X-Gm-Features: AVHnY4Jw9pwWVUIawcRWYEJbSOr_4eFJHRjDI61fxjs_qgnMfY70yBDODQXhxd4
Message-ID: <CAHk-=whkGbMoP-Dym8pAd3hV21=BZST+6sK++1X038+9Q-TgeA@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Andy Lutomirski <luto@amacapital.net>
Cc: Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org, axboe@kernel.dk, 
	brauner@kernel.org, david@kernel.org, dhowells@redhat.com, hch@infradead.org, 
	jack@suse.cz, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 3 Jun 2026 at 11:28, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> But even then you need to have a *handle* to the buffers for the
> general case, and that's what the pipe fd ends up then still
> effectively being.

Again: for sendfile, you don't need the handle, because you can just
"read the file data again".

But the the handle is needed for any buffering that can't do that -
iow pretty much *any* other case than a file-backed source.

So the original use-cases included things like copying media data from
a TV capture card to a GPU for outputting in a window.

There it's actually the intermediate buffer that is the important
thing, and it needs to have a lifetime that is independent of the
system call itself, because the system call may be interrupted by
signals etc, and you can't just "read the data again" when you
restart.

So the whole idea with splice() is that you have an input, an output,
and a stateful buffer between the two that has a lifetime.

Having just a iov_iter isn't enough - even with the current much more
capable iov_iter we have now (compared to when splice came to be: two
decades ago when the modern iov_iter didn't even exist). You have to
have that notion of a buffer with a lifetime.

(iov_iter came a couple of years later, but it then took many many
years for it to become the powerful thing it is today where you can
put almost arbitrary data into it - it started as purely a user space
iovec iterator, all the bvec/kvec etc stuff that you need for IO
buffering came a decade later)

So there's historical reasons for the use of pipes, but there really
is a very fundamental reason for it too: wanting to *generic* data
transfer between two points, not sendfile.

It's worth noticing that in the generic case, zero-copy isn't really
even an issue.

When you think operations like "splice TV capture input to a pipe",
you typically need to allocate the pages that you then DMA into
*anyway*, and you'd just put those pages into the pipe. And the facty
that you can then just take the data directly from those pages when
you splice from the pipe to whatever GPU engine that does the decoding
is kind of secondary.

So again: the big deal with splice() and the pipe isn't really about
zero-copy. It's the in-kernel buffers where the drivers control the
allocation and you don't have some "user space allocates memory, then
kernel looks that allocation up and uses it" model.

Having less copies is kind of incidental. It *might* happen just
because it's natural when some streaming device just gives it data
away and doesn't care after the fact.

The problem with splicing from a file has been exactly the fact that
it's *not* streaming data, and the filesystem zero-copy case gave
direct access to the long-term cache.

Which is undoubtedly good for performance. But it fundamentally
*requires* that the sink is trustworthy. Which has been problematic.

That's why sendfile() is bad. Not because splice itself is a bad
concept, but because you have to have that absolute trust across
components.

          Linus
