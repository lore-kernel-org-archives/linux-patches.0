Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EC03C3439
	for <patches@lists.linux.dev>; Thu,  4 Jun 2026 19:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780601452; cv=none; b=DVy2gtJVqgqZp2u/Oy28anCtTRsnr2iYqzIJVS9b9swJMQMKzZ9dyE268jYwiMh64PZsousIAA0R7OesjIRgoOOIloZcdAUyx15IERakgWPxgHqiHPx6MD0ArHnh/n+XKpVYAlX6IwUQMjxJYKAllMrzeNFIwBo1ggcT3traFyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780601452; c=relaxed/simple;
	bh=d97FFwmE32XoeNnLtg7CNSRYTgucvS3+TBVC4MKcTx0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LEikVtwotu1jAUn6elb+WszkAFnZ6VGkd2tAs4LIv5+G1hBqIAIjiHMc5i4m6rwPOWAWHkV2NqeFpb7b8Gao3jpj0Kx2PRVgWGoOFuIB1qZwDq2l4mR6MfdgbIJf1pU24TMW8+xQvVxF6WTS7NJWKaNCkhRyODvxTfHk8FGskJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OsNJN4SU; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OsNJN4SU"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-bef47b1ac01so177885066b.2
        for <patches@lists.linux.dev>; Thu, 04 Jun 2026 12:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780601449; x=1781206249; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/vRjXw0GxoiIE6driNbyJfpHo79+KlSJNRDFpalZAbE=;
        b=OsNJN4SUujNxCXzrLGPht4QRj75VthB/IXFEA3kzaJLEEh62fG/l5z4FVBkq0mltjX
         ZhcUnkM5hR0qUsyckycqOrdFTaquNUb63iKyK2d/ERsmGebEvS7RYDb5FqoymXJEDmTi
         jk9nJjq7YqcHuIP43wiS1NlAhysEYVNVOh1so=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780601449; x=1781206249;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/vRjXw0GxoiIE6driNbyJfpHo79+KlSJNRDFpalZAbE=;
        b=WVRxdPksPxuHMkma4/f2ys+FtKrpXBKMMSoN5Uw+JThBkYB5oue26tV4lOfIKwKVrc
         TEjmfYFtVL3p9r4ftzp2vNBefmUV5+SPEa23JKyekTAIsTac8Vw99UgMNhKjEPIKEbh5
         UiZRbjEjgWlx5Ing6PCUS8YG5KYlkWtcztZRVEXwAuG5Oo0N4PC/Wi+ZRmUacQJFzREU
         DNhgwTnRkN07M81/JTUn9Mm8SJLoebCXvHIY15SAuwEoqE/w8m2PRri0hzd37kpcztQw
         JgPWcidY/FPwL+Uxsd79D0DTZdxvNdHvHhLryRcKBK0j8SjgGIUz/AuK8TUVwclfnv4k
         KYaQ==
X-Forwarded-Encrypted: i=1; AFNElJ8J0BDbZxiRH1p67n9abR6xqTAP22B9j5Y5PZrs1iUJ9wq3OY0f2eqgDg8EzfWu96b8GV5mbWe7@lists.linux.dev
X-Gm-Message-State: AOJu0YyUYkGLNU63bpV1FAWZvoyo0jJX4aj/EOqQsTowcLumagCT6Xby
	3GVD3EDEcj5j06NgoUaUsSUQQfthZNaMBb2TXZbOldbnS0MdBos8PPxB0VIhZ5XlLljijcvq5TS
	NfmfDYo9TdQ==
X-Gm-Gg: Acq92OFO883Hdy+wPVcCu/Cz0bLCo47rkPG4T3jaZJC4Npubl5gVmojF+7DNH/5P70H
	YvwI2FW0aTjYITlgJxiNzjmlqgueLleQgCDa/3zUU1BgrpbSf0EscIHe7Vid2LRccZsrBsjn8Rp
	DKN/zq6pM/EoCZb0QfwdDurEBgoq5WN5TQVFif3k0f+lNGJnbXfVVo/2NlD1wcqqMnJVloAMGUA
	LMTtTmvzMj5y73VVUDt2j5zUh1AwfzH3DRw5buRBDh6qEAPFsCsHTnvDvgE0XjD8y/CNjf5p/ir
	891instoO61PsoDVdgLej9I5psf804XY0bKJWijbJr2hCHX9NG64nwDJtOAfb4t9oYcHaiUHBjL
	4w1HxHVTbbAaO+gpcUVhtvOt4GuAtt/+Wl46OQ/L8juAlwewUesSww3O55hu8b4bYvyvEKGButC
	pcf5+2Q5XHPIZ2AdJ6yiv02EbVFlUx6TYjQ0u8en2D/vEUP8XpSgxKP/JchiVa7GzzYTDOnjcw0
	vqGqUYICpk=
X-Received: by 2002:a17:906:846a:b0:bed:19af:f8a7 with SMTP id a640c23a62f3a-bf36fd9c54fmr3214366b.9.1780601448908;
        Thu, 04 Jun 2026 12:30:48 -0700 (PDT)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf054e03716sm340158166b.34.2026.06.04.12.30.47
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2026 12:30:48 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-bdb3fd39045so142625366b.3
        for <patches@lists.linux.dev>; Thu, 04 Jun 2026 12:30:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8X0X1QxSZmZYQPgEPxNS8RjBOiNLc0iX6mSCBJ9Vr5wA+uiAiq4GWaRCIhknK+BaVXQPLS/wDT@lists.linux.dev
X-Received: by 2002:a17:907:3e20:b0:bf3:fe:1d5d with SMTP id
 a640c23a62f3a-bf373306d04mr3098066b.43.1780601447577; Thu, 04 Jun 2026
 12:30:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
 <20260603211736.755139-1-safinaskar@gmail.com> <20260604100609.6b37f500@pumpkin>
 <CAHk-=wjvb56qo27-axALOKCY-CjLsj9_294zeBovPVJaYm14dA@mail.gmail.com> <20260604183829.63c35fd9@pumpkin>
In-Reply-To: <20260604183829.63c35fd9@pumpkin>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 4 Jun 2026 12:30:30 -0700
X-Gmail-Original-Message-ID: <CAHk-=wip3mwLOHOYJ9TtjDxOaq9YUXmuCg2AycyASGgeY6qqUw@mail.gmail.com>
X-Gm-Features: AVVi8CdPQe90u6Sxnc7w9w1KvqakJpNEvGXvNsTMWUZWIferNC2FIUNZ3K7Amh0
Message-ID: <CAHk-=wip3mwLOHOYJ9TtjDxOaq9YUXmuCg2AycyASGgeY6qqUw@mail.gmail.com>
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

On Thu, 4 Jun 2026 at 10:38, David Laight <david.laight.linux@gmail.com> wrote:
>
> Bool is another matter entirely, (IIRC from a couple of weeks ago)
> gcc will assume that the low 8 bits of the parameter register are
> either 0 or 1 and clang assumes that the low 32 bits are 0 or 1.
> You can't even check with 'if ((u32)bool_param > 1) error()' because
> the compiler 'knows' it can't be false.

Nobody should ever use 'bool' as a system call argument. Anything that
takes a boolean should take a 'flags' field with bits.

But this is basically what a lot of the SYSCALL_DEFINEx() macros are
all about - sorting out ABI assumptions.

For example, on powerpc (iirc - maybe it was 390), a 32-bit argument
is always sign-extended by the ABI, and the compiler *depends* on
that. But at system call boundaries we can't trust that the user side
actually follows the ABI, so SYSCALL_DEFINEx() will actually take a
'unsigned long' and turn it into a 32-bit argument so that things like
this are well-defined and you can't fool the kernel by not following
the ABI rules.

The same would be the case if some system call actually takes bool
(but I don't think such garbage exists). The SYSCALL_DEFINE() macro
magic would take the full register content and *force* it to follow
the ABI conventions, whatever they are on that platform.

              Linus
