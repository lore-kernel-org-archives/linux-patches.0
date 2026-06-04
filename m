Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FE02F7EF2
	for <patches@lists.linux.dev>; Thu,  4 Jun 2026 21:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780609392; cv=none; b=jUJtKIsx0YmkbwpsEEGTD3eHLFMJnoU4duBHu3/w+0v8YXZd+x3MjCV1ih/pvQB7A4cyjz+e5WwL/84jWZwGf9FW8SIkm5iDmCpojRojkMVRLE4IAvratTMFcfJL8AO57SP08BpPVPnq4C4TYCfFPKdBSeyltcFF9HzEu0ia32Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780609392; c=relaxed/simple;
	bh=ZWDSpacEFEQZGnIVBEbJF0VYYuNfWke7vLWrwwZT/Sc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KpQRXopmLz3XixnsclrF1xaqZhFJ5tM9gBe7fhMUXb8VTFBxLgpZ6Oo1IxzEZ51yZQFUZMRTk0Bsc6fpZUxVywMtClTtQBfAr7dPzxXzzgunyu3K+IVEREQCcLrku6EY4mTYdQdXf+og8LcO81wCsk9ALKycz5mnPwyGD7UZItM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z9XV4UlJ; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z9XV4UlJ"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-68d234218bcso2399589a12.2
        for <patches@lists.linux.dev>; Thu, 04 Jun 2026 14:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780609389; x=1781214189; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=C0rKRLQ7b0xQkDszK4kB86a8NKDdPGLBrBut9iuJxEs=;
        b=Z9XV4UlJmaU+9aPsfVhamExpokkeYVipDsGHXfPXGGj1We6KMp5iWoiGZoqkLaHNL/
         E1EDT0c7Zj+SuNghMns2fQllCDzbtTtHK9aDYnMhYa006iqkxeaYc/UOJgCwhEwJ1U9H
         yZVLngXxODWvyxWo6rxAhh5c3GehvmQW+gzXI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780609389; x=1781214189;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C0rKRLQ7b0xQkDszK4kB86a8NKDdPGLBrBut9iuJxEs=;
        b=kn4dUsFIC7kt79hdNQg+1rIuVUZm/oyQz/pD1RvLRZsw98cYPhIPt5QSLxXzIjJRii
         6AWTH5vq0dGxxoESqkg1UsqJUEmRlauHivjzspVdYBVBfEePbv2iLlYKZpjb7A/xEKST
         Vr1Rgaxg2DSg1OK0yZt99i1sYfN9Q1XXUxdbJV7kWjtDyMhZvevMAbJ/zsZP8GO/wbdX
         PiBdlmAYgmHFWWcUtE75EMGANhIlHNI2HiS6onxmUspwFv4JjGdE8Ilz1J6x5eQP7Tpw
         llmxhPzxx5Y9Ju20O/wa1QBKhlWFVsU4M4tjgNYlIxy9ADay4DP6BU/MeqO5RtOz1PHb
         6nFA==
X-Forwarded-Encrypted: i=1; AFNElJ8kZ95/ZRCmWRMZ7jLxRsp2H1a8T49uTNNbh25w5U5J3wOcF/8CkdDNTSjf7gsTBjEAMTm5fRlg@lists.linux.dev
X-Gm-Message-State: AOJu0YxO1znjGAt0hATS78Fk6dKPbzQw2gs4Q5K7i1aS6H9OZpdaBXvz
	MexOMIsiFOSLhcBXQ1l2CAODEryIDoQQchfgbhbQfnkBGdKTj3egmg8dl76nYOjsyfVMmRKY4lt
	azhUUsMFwfg==
X-Gm-Gg: Acq92OGSKoT+zoRKrLAUL0ULa/k4suAe6++Jpyr779yoIxQvEcsj/cdZV9bQEoLmMjj
	4W2tZiT2mosfIW3fQhhgkGYUqQvQPCDW0X+AwjxSkpaot6KAg0Cv62pDrK9B8dTPKxYB7EFNoCi
	DeFc0aSP8qsWbAGGIvTZQiBE+1gLKXTW7FGTThzD1fTSzpzduoSiXYscdBxgWifvEukZoVfSYnV
	2+65jdxE3lL5HHUZYWOjH9KJU1KwMe1CMjtyuaE9bqRSe71zJaCa2ozS8YCZhvCxm2s6ivWjxNV
	G5BsXna99i13INMYlIhWo0ctLSeGfxd9y24g3KFcUabY2oy1ReczCCChtWozgTIukjiWCQO3yxy
	kecCkUvU35cos5ulCItBVYLPDBZbwfCoOkywpNju2m1vGvEc0wWiTLJjJGIATG4LSDA+JrhUwCx
	UWje6U9m2ZUlBRkHLQbNCaRZWHpTp4EobZObd0SvxgloVzt4XqLP9iglx3v02IVOCJGIb1qIwtt
	XDG3Kdf4EE=
X-Received: by 2002:a17:907:3f07:b0:bdc:ac75:73b9 with SMTP id a640c23a62f3a-bf373a032a0mr22549166b.43.1780609389184;
        Thu, 04 Jun 2026 14:43:09 -0700 (PDT)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf0553fd86csm357548766b.46.2026.06.04.14.43.08
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2026 14:43:08 -0700 (PDT)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-bf1141c26ecso179340566b.0
        for <patches@lists.linux.dev>; Thu, 04 Jun 2026 14:43:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/j5Gw8edLr53STlZhi64I1IC+LyYogKMfg0l0+oWkyjppJkGWQZVQKicwQdiVJbjRSpQubRBur@lists.linux.dev
X-Received: by 2002:a17:907:a03:b0:be2:dd37:facd with SMTP id
 a640c23a62f3a-bf370e6211cmr21551966b.20.1780609388179; Thu, 04 Jun 2026
 14:43:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
 <20260603211736.755139-1-safinaskar@gmail.com> <20260604100609.6b37f500@pumpkin>
 <CAHk-=wjvb56qo27-axALOKCY-CjLsj9_294zeBovPVJaYm14dA@mail.gmail.com>
 <20260604183829.63c35fd9@pumpkin> <CAHk-=wip3mwLOHOYJ9TtjDxOaq9YUXmuCg2AycyASGgeY6qqUw@mail.gmail.com>
 <20260604223216.73468830@pumpkin>
In-Reply-To: <20260604223216.73468830@pumpkin>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 4 Jun 2026 14:42:51 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh1Avi8FGbWkt9k0Z-KXWB0spo5mQyowO8PB2sJ3unbkw@mail.gmail.com>
X-Gm-Features: AVVi8CfSQTIVkCCY1e0qHuDIqCVA2aM8un_0a9-AOfB95snGVQXFlgTgq5lonE8
Message-ID: <CAHk-=wh1Avi8FGbWkt9k0Z-KXWB0spo5mQyowO8PB2sJ3unbkw@mail.gmail.com>
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: David Laight <david.laight.linux@gmail.com>
Cc: Askar Safin <safinaskar@gmail.com>, metze@samba.org, akpm@linux-foundation.org, 
	axboe@kernel.dk, brauner@kernel.org, david@kernel.org, dhowells@redhat.com, 
	hch@infradead.org, jack@suse.cz, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org, 
	patches@lists.linux.dev, pfalcato@suse.de, viro@zeniv.linux.org.uk, 
	willy@infradead.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 4 Jun 2026 at 14:32, David Laight <david.laight.linux@gmail.com> wrote:
>
> I think riscv might sign extend 32bit values in 64bit registers.
> x86 and arm both zero extend.

That's different.

x86 really doesn't *care*. If the caller zero-extends or leaves high
bits set randomly, according to the x86 ABI that's perfectly fine: the
callee will only care about the low 32 bits. So the high bits are
simply not relevant for the ABI.

The Powerpc ABI makes the the sign extension part of the calling conventions.

So if a caller doesn't sign extend a 32-bit value, the result is
random behavior - if you pass some function an 'int' argument, the
function may end up looking at bit 63 to see if it's negative (except
IBM calls it "bit 0" because they have to be different from everybody
else)

            Linus
