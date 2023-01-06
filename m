Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5076B95E4
	for <patches@lists.linux.dev>; Fri,  6 Jan 2023 22:07:10 +0000 (UTC)
Received: by mail-qt1-f180.google.com with SMTP id c7so3282354qtw.8
        for <patches@lists.linux.dev>; Fri, 06 Jan 2023 14:07:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=l9dqVddWwlNIkWBEkX2eMMbroRQSsxPmZhf5UK2bJx4=;
        b=O6fLaeMkOAI9qlrlbD9V9hqb0FRi+3fYwY656X3zqlxsNXYgmUCLgJYTFwJVKAjthE
         irUaeSLWBxwa416jiNkQxJky4pxbLUW3S/rzOYcjecUxbP1aO1xBadn5G83AJZJjM0GP
         8LNX+VfdzXkl4XSINWkZYmRr2ww9tgPFY2yho=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l9dqVddWwlNIkWBEkX2eMMbroRQSsxPmZhf5UK2bJx4=;
        b=rd0Zaj/5F22CUw+j728KVc80hxsXTpRw1I0wtBpxqWIKil6EN5IVGIAyTQ+OzEJXcC
         l1k7zDYgI3CDhm7COBNswtHBriUcJbv6AaHgZD6W3gbxoY/DakqvTnzh84CKfDQmdBpe
         GvTf7Hkd9OGwJUD5WUplY/cdCy0HjY8yJWfAVuilBMEAjboqEx/OktovSTZi6EAtm/9O
         KbaG3KmBkuBffh78zsSmWpk2rRKT/1GHTcUSALntn36DeTaZe0m6DEISWCPJowoWgtT+
         0akhOpjXQbzxnMI/NX1+717eFmMrGvchNiEkPvJnlDBLw9eeeOqr/XEpqsift1GExMyi
         387A==
X-Gm-Message-State: AFqh2kpiA0/6aK+UEpIYu2SLlQ6U3/Ur13oZK38sIoGnpp/QSVr0LZC7
	Z6m6VlhNkPd278F6Z1gRLfKa/yar+M28CTlR
X-Google-Smtp-Source: AMrXdXuid8SSmwqtk+6GzAtFjd6PdPqr49sdCvKpL5Fdfl0Em4z2EM9i0VRHblT8xl4PVnIDcKybng==
X-Received: by 2002:a05:622a:4c19:b0:3a7:e619:61a with SMTP id ey25-20020a05622a4c1900b003a7e619061amr87674317qtb.37.1673042828846;
        Fri, 06 Jan 2023 14:07:08 -0800 (PST)
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com. [209.85.219.49])
        by smtp.gmail.com with ESMTPSA id o24-20020a05620a229800b006fec1c0754csm1152551qkh.87.2023.01.06.14.07.07
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 14:07:07 -0800 (PST)
Received: by mail-qv1-f49.google.com with SMTP id o17so1912792qvn.4
        for <patches@lists.linux.dev>; Fri, 06 Jan 2023 14:07:07 -0800 (PST)
X-Received: by 2002:a05:6214:1185:b0:4c6:608c:6b2c with SMTP id
 t5-20020a056214118500b004c6608c6b2cmr2661817qvv.130.1673042827328; Fri, 06
 Jan 2023 14:07:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAHk-=wg_6Uhkjy12Vq_hN6rQqGRP2nE15rkgiAo6Qay5aOeigg@mail.gmail.com>
 <Y7SDgtXayQCy6xT6@zx2c4.com> <CAHk-=whQdWFw+0eGttxsWBHZg1+uh=0MhxXYtvJGX4t9P1MgNw@mail.gmail.com>
 <Y7SJ+/axonTK0Fir@zx2c4.com> <CAHk-=wi4gshfKjbhEO_xZdVb9ztXf0iuv5kKhxtvAHf2HzTmng@mail.gmail.com>
 <Y7STv9+p248zr+0a@zx2c4.com> <10302240-51ec-0854-2c86-16752d67a9be@opteya.com>
 <Y7dV1lVUYjqs8fh0@zx2c4.com> <CAHk-=wijEC_oDzfUajhmp=ZVnzMTXgjxHEcxAfaHiNQm4iAcqA@mail.gmail.com>
 <CAHk-=wiO4rp8oVmj6i6vvC97gNePLN-SxhSK=UozA88G6nxBGQ@mail.gmail.com> <Y7iV18CqKAa4gO9r@casper.infradead.org>
In-Reply-To: <Y7iV18CqKAa4gO9r@casper.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Jan 2023 14:06:51 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj7jenrb6UNjv--xLC4hrjJDsCFxuaHw1e67a4ihVEmUw@mail.gmail.com>
Message-ID: <CAHk-=wj7jenrb6UNjv--xLC4hrjJDsCFxuaHw1e67a4ihVEmUw@mail.gmail.com>
Subject: Re: [PATCH v14 2/7] mm: add VM_DROPPABLE for designating always
 lazily freeable mappings
To: Matthew Wilcox <willy@infradead.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Yann Droneaud <ydroneaud@opteya.com>, 
	Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, tglx@linutronix.de, linux-crypto@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, 
	Christian Brauner <brauner@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

On Fri, Jan 6, 2023 at 1:42 PM Matthew Wilcox <willy@infradead.org> wrote:
>
>
> I'd be more inclined to do:
>
> typedef unsigned int vm_flags_t[2];

No, that's entirely invalid.

Never *ever* use arrays in C for type safety. Arrays are not type
safe. They can't be assigned sanely, and they silently become pointers
(which also aren't type-safe, since they end up converting silently to
'void *').

If you want to use the type system to enforce things, and you don't
want to rely on sparse, you absolutely have to use a struct (or union)
type.

So something like

   typedef struct { u64 val; } vm_flags_t;

would be an option.

              Linus
