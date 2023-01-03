Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7008F57
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 19:19:55 +0000 (UTC)
Received: by mail-vs1-f51.google.com with SMTP id o63so27962540vsc.10
        for <patches@lists.linux.dev>; Tue, 03 Jan 2023 11:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ia/lu5+B5CRXWa8CF3j1BLcFKSU3j2P6kHuicKKTwhM=;
        b=ZqWN8gFUfoVI5wnLUXnodqgP701dqeLd5CSt/RsefZ5Qkl5jGfXYOorD034HuIvB5D
         Ht8gtKf8KI4dn/azdfqIH5esBFN2+qILBHpfWUbepKnmZuifWK677ycRTg3al4Q+XtGT
         msE8MlX8P1FMZr6Yemo2KVXiq2CyfjHgRvf5A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ia/lu5+B5CRXWa8CF3j1BLcFKSU3j2P6kHuicKKTwhM=;
        b=K//zT6mQCbLIZ0GolBKaN9zFWesB4lnGFZKhcWgINe2twU1ByD/RLIbT0hMHu5ibsm
         kheIARFwKYna8d8euKUedmjYy3Y4V5hNMK2ivoycPa+Fml3E9EstlOelwjHwSYXaDDXO
         6hpF9XUul6aXlpzPfSdwmbOInIwnL5IJpyT8wsWY66q6h+z4WipgTtrlFWZv8PPU2H4z
         wEWOCj4YqVODF22+YEunJmrsJfJMD9BB4P0OJHL+VkP/NRw8sUtldMhlDxaUH1zNlrnA
         UUgm3MIvXt6r3duD12s0ApCs5mfLn5nFDWR4tPN29oRdeE8Oee0bzN4bIfMUtxGvEvkF
         nwTw==
X-Gm-Message-State: AFqh2kqHnkvOsVGVYkT523ubXeOtW/Va2sC3l4lwUvdQKGAkfi5P2b0w
	pQUN0ItNnuBXvyetMhQq5dmPrIypknW3s6OK
X-Google-Smtp-Source: AMrXdXv6WQRWEae/nky1ztPFhf6iuAWpxRUDDpWzvRdubBRWq+7bcxZC53Q0YLeDOV7WzQJFDBupNg==
X-Received: by 2002:a67:f1d6:0:b0:3cb:54f1:d813 with SMTP id v22-20020a67f1d6000000b003cb54f1d813mr9239578vsm.15.1672773593949;
        Tue, 03 Jan 2023 11:19:53 -0800 (PST)
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com. [209.85.160.180])
        by smtp.gmail.com with ESMTPSA id m16-20020a05620a291000b007056237b41bsm2538234qkp.67.2023.01.03.11.19.53
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 11:19:53 -0800 (PST)
Received: by mail-qt1-f180.google.com with SMTP id v14so22547824qtq.3
        for <patches@lists.linux.dev>; Tue, 03 Jan 2023 11:19:53 -0800 (PST)
X-Received: by 2002:ac8:67da:0:b0:3a5:122:fb79 with SMTP id
 r26-20020ac867da000000b003a50122fb79mr1194253qtp.452.1672773592726; Tue, 03
 Jan 2023 11:19:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230101162910.710293-1-Jason@zx2c4.com> <20230101162910.710293-3-Jason@zx2c4.com>
 <Y7QIg/hAIk7eZE42@gmail.com> <CALCETrWdw5kxrtr4M7AkKYDOJEE1cU1wENWgmgOxn0rEJz4y3w@mail.gmail.com>
In-Reply-To: <CALCETrWdw5kxrtr4M7AkKYDOJEE1cU1wENWgmgOxn0rEJz4y3w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 Jan 2023 11:19:36 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg_6Uhkjy12Vq_hN6rQqGRP2nE15rkgiAo6Qay5aOeigg@mail.gmail.com>
Message-ID: <CAHk-=wg_6Uhkjy12Vq_hN6rQqGRP2nE15rkgiAo6Qay5aOeigg@mail.gmail.com>
Subject: Re: [PATCH v14 2/7] mm: add VM_DROPPABLE for designating always
 lazily freeable mappings
To: Andy Lutomirski <luto@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, tglx@linutronix.de, linux-crypto@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, 
	Christian Brauner <brauner@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Jan 3, 2023 at 10:36 AM Andy Lutomirski <luto@kernel.org> wrote:
>
> I have a rather different suggestion: make a special mapping.  Jason,
> you're trying to shoehorn all kinds of bizarre behavior into the core
> mm, and none of that seems to me to belong to the core mm.  Instead,
> have an actual special mapping with callbacks that does the right
> thing.  No fancy VM flags.

I don't disagree, but honestly, my deeper reaction is "this is not worth it".

I think the real issue here is that Jason has to prove that this is
such a big deal that the VM has to be modified *at*all* for this.

Honestly, "getrandom()" performance simply is not important enough to
design VM changes for.

Do some people care? Debatable. Jason cares, sure. But people have
gotten used to doing their own random number implementations if they
*really* care, and yes, they've gotten them wrong, or they've not
performed as well as they could, but on the whole this is still a
really tiny thing, and Jason is trying to micro-optimize something
that THE KERNEL SHOULD NOT CARE ABOUT.

This should all be in libc. Not in the kernel with special magic vdso
support and special buffer allocations. The kernel should give good
enough support that libc can do a good job, but the kernel should
simply *not* take the approach of "libc will get this wrong, so let's
just do all the work for it".

Let user space do their own percpu areas if they really care. And most
(as in 99.9%) of all user space won't care at all, and is perfectly
happy just doing a read() from /dev/urandom or using our existing
"getrandom()" without any super-clever vdso support with magic
temporary buffer handling.

Now, if the magic buffers were something cool that were a generic
concept that a lot of *other* cases would also kill for, that's one
thing. But this is such a small special case that absolutely *nobody*
has asked for, and that nothing else wants.

             Linus
