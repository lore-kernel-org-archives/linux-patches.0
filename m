Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2754638B133
	for <patches@lists.linux.dev>; Wed,  3 Jun 2026 18:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780510225; cv=pass; b=PRFuK2B+dV83gCdlIFoRgwMpvSNLtu1Kr5ULvnmZHECpdMLT2cQFmOcd3uK1N3atgrkPM8UxvCKQh7pE84dMyeA0IA4vtIIe6Mbo6UqLbKoDSl1AZraPNmdjmNgrnhy56esMo+XjGiS10Tbqv+1GpxUaUeAxdflC5Pf69VZ9Kp4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780510225; c=relaxed/simple;
	bh=QI5X4GxUbtQqHSEMGf2m2zt26rBr9KAW94estlSgOxQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MmBEbdEGE/LyUF15/wbsEtENVKTV78MKdFmKWE5/4CCscvNoitqpL+GXIxn3XYIFc2PIQqMJyUQgZRXTMO5Ru+HVcwbIRk5Fr/DDiwOD2S0b6p6MkIzAHl+q5zDZKEhlHa71HwGH/WRi78caMc7n10Js79FHQkJIPwNwbMozaFQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b=B+mFkXDy; arc=pass smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b="B+mFkXDy"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5aa7a7ad475so1658066e87.1
        for <patches@lists.linux.dev>; Wed, 03 Jun 2026 11:10:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780510220; cv=none;
        d=google.com; s=arc-20240605;
        b=N5ZzMRQgfY0xGqRg/Z3FgrmFgc2mntcuDYkslzwoy3DCLebu//1hWmqvc1mAnYGxyu
         JGPRAn6lLiFnrrim1zTReh3Aq84ldOQgMPdqueAu6fMl8O0ePiWQOg3IoFZPUJ98oPie
         c5bM7vpCqyK1Jp+vqfS1f6yyqNRcYniPju0pmGubPYTPXKjV+KELUyE/pQhVwHKLHpXV
         9Vkt9WqhihYAh1uQusIpXLGBiYq9zftGpsOCQqbbBp8FVoyYg3q0Zg4HzYKSfb34DhQZ
         5U5+/LGejrSWjyS/VUEU+0VATJP1LHDURlb91bfhK+gCkafdHf24HTYtsPeVHWOUScYh
         joog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QI5X4GxUbtQqHSEMGf2m2zt26rBr9KAW94estlSgOxQ=;
        fh=btweCOfyalh0NliZisN6qqmZxlphLgx7Go6ybPutXnw=;
        b=C1Bv5FOOYmuUrspMh0m2mz6ZWxQih3GwyED2dO+CxFBzsvbDaHtliMb4iyktJGeB6K
         TEhmuqZM6sUmJIEa6BpBIOFxYGu28Pi8rPHiArC4MaYSaux2taAIIsY13MidsWm9AOh3
         oEkQjzG7nfoErUG8U5THjYqZqfSHg9EHv/dm6nIutAsBbYgr0vTg7IbJVI1ljA8TRGF8
         L+iVpuA1Q/c2wg0FQZm7v9sVnMbj/K1iFLkY7vB5MevTeb06CDUgB/tocg9dw38qlDPl
         5ggMcEzJtdQtxppZQ1iohhWpFqnlZ8pct2lLWa49R8pt0ap55//6hrk9vulNaeq0TUAE
         z5Pg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1780510220; x=1781115020; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QI5X4GxUbtQqHSEMGf2m2zt26rBr9KAW94estlSgOxQ=;
        b=B+mFkXDyfylV+VNJYhPfenXW9G7P0gZ08eDFhcNWhSKPpPH+o4UeDGmoIMj7Ia7+54
         T3dMaOiWd3YqRteW+Y0myavanaAt6moc+EZv+ZMPNrGyety/mQzlDsEaxupYfvwc4lez
         8iJ6B0Iwu5gnrMJMZQA2uaBh99UTgU8l1DuBJahDu216eE6LD1iu6UxVowcISQKBsCdG
         ntwD2a7GMc3KV+0uOGBY5qDcFKyUuJaSDTpzr4RMPH9oGKHMgpmUUmHk5QhUp/bH/Mje
         7aAc9JSEjjk0HAcRqrxnb+jct0BUjk/t1p7Hl/To5qkmCS9eg6eV1+owI9pI2cAtD9lD
         b8ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780510220; x=1781115020;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QI5X4GxUbtQqHSEMGf2m2zt26rBr9KAW94estlSgOxQ=;
        b=K/QNoKMs3kuxr7CPSU+xxZv6iIlw5u/rfkQQE2gvrSJrWWZPXCC9a7qLcsae4mQb9L
         6ZZNoD1fLxtKmi2KMnUup34lNZGehYvyYli8L+Di2whPYwGBpnIBMGxKRa17WP9cvmO6
         GKy9leXjXTEtc/KvCS2dWToZ7lXCYCFrtNp8QAS78upLuxOyFuM/0gh/3vZCcnPB00gi
         hFbyBt2r+rXMBIyj1sQsKQONx6YqPwBYSCHxrtgDS9JqpyZkutryt8ZJSh4rPFjuLYgy
         zIuZyzs5kJzKAhMu2zfDzyvb/T90AZC5FxbeYIkec7UQmuZ6opqI4Je7nszSNahombta
         b3ag==
X-Forwarded-Encrypted: i=1; AFNElJ8hAQHsepDmsfo6ngaq5fwSdaNIXcndSk8vCgLUSjg+yUf3ikQr8yrGaLfimqbkgkqc/PS9j8BA@lists.linux.dev
X-Gm-Message-State: AOJu0YzoRTGyD5NsnOx+aCMv2KVIKRvp8ndkxkS3y0CCTkcOTPXuisMX
	bbbi6tcrivt5XvfklXMokhdMm03eENnwatWc8nhUJV/PQgUnTS5SzbAthT4fANU2aq2K0p/j2xN
	+B1Z+9AJ4EH8PhEkhWQ8h0U2lWJAboJRYNOr8H5yV
X-Gm-Gg: Acq92OFGFq/K5dI+NYZHk3xK/lYBI6nW23O+V6AuCAU5JfbVLe1dTiKHQqNYY+fqr5Q
	F7/csv5nJcmqW3pjXgYg9ksrZYYPLRKBucjq/KHWc0BsrO6/Y+Pk2stLYQVEvSl/1dFJhizESzq
	n2OdvCYqw0p1suV+h0SowMhPImScNuwP0uDZ57iKLN6o146yIT9Hv52Z+ksnticg6Rl7CcuzinJ
	EWXqh71Wv+8vX9RFIIpHEQO4a6q5C0TQ42YnwN0dkUxFiBuF7+UEzDJnKEAj4yiVn6Y8SmKTx7A
	BUJAGPYo7cIurxckoO0=
X-Received: by 2002:a05:6512:1316:b0:5aa:6917:da62 with SMTP id
 2adb3069b0e04-5aa7c0feb48mr1695669e87.22.1780510220289; Wed, 03 Jun 2026
 11:10:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
 <20260602225426.122258-1-safinaskar@gmail.com> <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
 <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com> <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
In-Reply-To: <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 3 Jun 2026 11:10:07 -0700
X-Gm-Features: AVHnY4I8xlGMoYvHWadfAyp7JPxqtCaCokQuJfO8Z8xN2WDEFYt6TSKYy0-h7os
Message-ID: <CALCETrXzxubt4eWue3+wv7Fq9C2m7uu6bWPstqFh6Mo57bPwQQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org, axboe@kernel.dk, 
	brauner@kernel.org, david@kernel.org, dhowells@redhat.com, hch@infradead.org, 
	jack@suse.cz, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> On Jun 2, 2026, at 9:20=E2=80=AFPM, Linus Torvalds <torvalds@linux-founda=
tion.org> wrote:
>
> =EF=BB=BFOn Tue, 2 Jun 2026 at 20:51, Andy Lutomirski <luto@amacapital.ne=
t> wrote:
>>
>> Am I understanding correctly that this will completely break zerocopy
>> sendfile?
>
> Very much, yes.
>
> And it's worth making it very very clear that ABSOLUTELY NONE of the
> recent big security bugs were in splice.
>
> They were all in the networking and crypto code that just didn't deal
> with shared data correctly.
>
> So in that sense, it's a bit sad to discuss castrating splice.
>
> But it's probably still the right thing to at least try.
>
> I've seen very impressive benchmark numbers over the years, but
> they've often smelled more like benchmarketing than actual real work.
>
> There's also a real possibility that a lot of the sendfile / splice
> advantage has little to do with zero-copy, and more to do with the
> cost of mapping and maintaining buffers in user space.
>
> If you are sending file data using plain reads and writes, it's not
> just the "copy from user space to socket data structures".
>
> There's also the cost of populating user space in the first place:
> page faults for mmap made *that* historical copy avoidance basically a
> fairy tale.
>
> And not using mmap means that you have the cost of double caching in
> the kernel _and_ user space etc.
>
> So sendfile() as a concept (whether you use combinations of splice()
> system calls or the sendfile system call itsefl) isn't necessarily
> only about the zero-copy, it's really also about avoiding the user
> space memory management.

So maybe we should make sure that, if we go down the route of
disabling all the splice magic, that we leave an API, maybe the
existing sendfile or maybe something else, that does an optimized copy
from one fd to another and that is at least capable of sending from a
file to the network with at most one CPU-side copy.

Even if we=E2=80=99re just doing that, I continue to find it strange that w=
e
require that a pipe be involved. What=E2=80=99s so special about pipes that=
 we
allow splicing from file to pipe and then pipe to socket (this
requiring that the pipe retain a reference to the file=E2=80=99s page cache
structures to avoid *two* copies), but we can=E2=80=99t splice straight fro=
m
file to socket. Heck, even sendfile is implemented under the hood as a
pair of splices!
