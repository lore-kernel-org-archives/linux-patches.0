Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFC31CEAC2
	for <patches@lists.linux.dev>; Wed,  3 Jun 2026 04:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780460795; cv=none; b=W9g64/UJFKvhfVW1cgDimHLzaWH06KXAGmPzw0eazj2IfaDnEkKl6ixPUxpM1N7mvLQuxwkl6EzKiff4gmLIKjyi1Q/Mihk5soBExjUcd27/VA55z3YdnnvmEvygocBneNTbb95lHjY+sgzuJDFTcCZQeSDCmi4GdV7oMjmH9Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780460795; c=relaxed/simple;
	bh=9tQqNP43n5romnaq4BfFL2SfXA5Di4eDVrUHKrBpUCo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UktB0sFkEnfHbwWJuHHeOypvLWC1+MQEkQG1RhL5JKErQHXA1TDkEaDMFgn6cMgJA9zS1eiZfmpAx7MronYQ2tLCcu8L3WHIBecDFziGtRj/AJneEJBqNml5ajFPDDBdf1k+TWOJlJUdgGQlQW20PmZ4JWffl4ftxL1g+2CFO8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W/7K9Kll; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W/7K9Kll"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-bec49f7e35eso427759666b.2
        for <patches@lists.linux.dev>; Tue, 02 Jun 2026 21:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780460792; x=1781065592; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3SJtr+8Mfjo1TPz3VKjCaH7CMP6KY0W4WXb69Cl5TnE=;
        b=W/7K9KllJLm6d4sranLUzVC9FRBAxXCV0bTbMexZ5a+ZN2+5CXSQcbJ7KAyK9PTqU2
         T5EAZg+HDA16j3B1PFkhdNZjhCO063S80pVqH4pRdUhJ1dJGCn8xveNtb2knj1Az55i/
         +rKAOIVG02WL3oZOvGVU+Eqn5aRQZ6Oc9bBnI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780460792; x=1781065592;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3SJtr+8Mfjo1TPz3VKjCaH7CMP6KY0W4WXb69Cl5TnE=;
        b=N9qQa+roUN2S4JoMasVGqIQmQ3NXlGyeuyMYLjMStjcavnrW6fe8cmV0Q6mNzh6NoS
         T6fPV/9nofNDjIpO03R95R8QjN39VNSrMEvbuFLJbp8byTKWGtHTzDCmGQ89f6zID7hH
         I0SH7Xe79GbnPoweuX/QKd01agzH0PR+LYQNIuai4JuppLN7QxBCAaL2uaXz4rCT4RZx
         x0Ej1V2HPRIupUodEPfd6tQ/JTisJ0tbGGoz+aHktBGAfx/gMaX/ebP5uv1XtWzpQKMA
         82XJxCOMIzCAhg4OH/F/qLTlSHToLT0nNJTaKu25mdzaFg+t7gFnLbCz3yzS/ZMjDQEh
         gxfg==
X-Forwarded-Encrypted: i=1; AFNElJ+lyf4t5HSOvG8HsL/pQv0rlji1kx1ukJQYFiZc0Duj7UDdYJ8X2pm7DagtpWKL9wLNIPwyt16e@lists.linux.dev
X-Gm-Message-State: AOJu0YxyRFzSpD9nqqnhYlmHKTU5EfzqI9aEG8l0lbIb7UvOeiflCsgh
	Dx7NMJoTZPYA0jqBVJUBW1K/8EEgh6Ofwh/l4iJrMhudKjrECBHv1JpRNUAmkjfvPtdEDUYgcUf
	ysaZvbQIUmA==
X-Gm-Gg: Acq92OGkhzdLxirxAmhcLXxfro+NdCnPR19NmD+VSW2Zhd9JkRgh7FF8KEX4n2vPv6V
	KuEMP0By5BM1n+P+Kg17xCLJoE3/+yc7Rg/TrPAmOAXI4QUDOPfTopvioE4Wr6etHYNfG88hL2o
	P8W3CdinSFVog4KY83NxjC6d+68AfYVowIFIyNA6QROZTFplbuIf+xxkrVR/1y0nTZPtOrkRdYf
	GVFOdBGnGeAG4QoSZcBBmWQHcSSpE/Vo3hpnS7ECwrpskPxHbHTqFpc499mMa7raVhmXV47SZ12
	PcRLE1PSphvKwyY82fLWL6BPbPpVrEvHpwe93vRkZzDbtmGbXmszXcgV4VF7o7hE9W9k5eS09m7
	ekqlnsuPmhdmHbYiLKbfF1xgeZHLgpAFK4tN4eX/vmXHKuVJfDD1A/k68pUL4wxHVg5iHwliiG3
	TuQisV9OhDbc6iC4RSbq3fZCacvUNOzWy2f7p2zwyFCCW/mRgnyW+44zTn6okeDD0Log6nrg6nG
	YncFj+Wpfs=
X-Received: by 2002:a17:907:3d90:b0:bed:38b8:9b4b with SMTP id a640c23a62f3a-bf0ae3ff64dmr49750566b.27.1780460792504;
        Tue, 02 Jun 2026 21:26:32 -0700 (PDT)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com. [209.85.221.49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf055307a35sm75285666b.52.2026.06.02.21.26.32
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2026 21:26:32 -0700 (PDT)
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-45ef56d9b67so3714589f8f.2
        for <patches@lists.linux.dev>; Tue, 02 Jun 2026 21:26:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+KajjLdNrn40eADgh/3LOPeZ5+ktco0thD79Ix5Eis3QO8aGoXruWxb9cvJLHThl3roO/aBBAZ@lists.linux.dev
X-Received: by 2002:a17:906:8a48:b0:bea:4a9b:27e3 with SMTP id
 a640c23a62f3a-bf0ac20eef3mr38881066b.2.1780460431308; Tue, 02 Jun 2026
 21:20:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
 <20260602225426.122258-1-safinaskar@gmail.com> <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
 <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
In-Reply-To: <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 2 Jun 2026 21:20:13 -0700
X-Gmail-Original-Message-ID: <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
X-Gm-Features: AVHnY4IJxv2Bq-ytG67gbyDgK2Xm9CPUNF4PNLBHu-2R4s_ONl3Jl_5fsF1zxk4
Message-ID: <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Andy Lutomirski <luto@amacapital.net>
Cc: Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org, axboe@kernel.dk, 
	brauner@kernel.org, david@kernel.org, dhowells@redhat.com, hch@infradead.org, 
	jack@suse.cz, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 Jun 2026 at 20:51, Andy Lutomirski <luto@amacapital.net> wrote:
>
> Am I understanding correctly that this will completely break zerocopy
> sendfile?

Very much, yes.

And it's worth making it very very clear that ABSOLUTELY NONE of the
recent big security bugs were in splice.

They were all in the networking and crypto code that just didn't deal
with shared data correctly.

So in that sense, it's a bit sad to discuss castrating splice.

But it's probably still the right thing to at least try.

I've seen very impressive benchmark numbers over the years, but
they've often smelled more like benchmarketing than actual real work.

There's also a real possibility that a lot of the sendfile / splice
advantage has little to do with zero-copy, and more to do with the
cost of mapping and maintaining buffers in user space.

If you are sending file data using plain reads and writes, it's not
just the "copy from user space to socket data structures".

There's also the cost of populating user space in the first place:
page faults for mmap made *that* historical copy avoidance basically a
fairy tale.

And not using mmap means that you have the cost of double caching in
the kernel _and_ user space etc.

So sendfile() as a concept (whether you use combinations of splice()
system calls or the sendfile system call itsefl) isn't necessarily
only about the zero-copy, it's really also about avoiding the user
space memory management.

But yes, there's a very real question of performance.

I just suspect we'll never get real answers without going the "let's
just see what happens" route...

                Linus
