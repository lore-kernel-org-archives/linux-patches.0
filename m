Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7558F57
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 20:16:17 +0000 (UTC)
Received: by mail-qt1-f178.google.com with SMTP id v14so22681353qtq.3
        for <patches@lists.linux.dev>; Tue, 03 Jan 2023 12:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HTnuIAJdCSnqOgUCfI1VegmgFYxeW1ngR0BDNyHkGf0=;
        b=DokQ/BEIgEpL/ia17Z2x8+os3L6Iix7X3VYwgY2oWHbqXrXltMNtHkuxWFNC0TiQoL
         cBgZVKREYRgoskXuojqZ3A1XLXXW46nqyABZQqesu1jY6qAYwaNx5oLjtODVhfjUliU3
         eVndN+o81O0zIOd96+Ti2/uGI99RMfL7MdUR0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HTnuIAJdCSnqOgUCfI1VegmgFYxeW1ngR0BDNyHkGf0=;
        b=dPaDHVtkpxLDdCd4f8Rskp1LIthXXbqOt0c7qd5tRb2jin65qyFs83yHfVuin5l6md
         aarJL9BTv4KkhaIvgXV72UP+Gg32xhxomCIr/o6s+iJyFNvbuLZyZ5RsxXNeXEN5XVkc
         /Q9bhh12h4lQqtcUZFC9786xcrywyBfBsyKqKUsH8hV7HW8caEEOz4YFvvuLOy9YzIdZ
         t+fN1GIdRwSnKRxkyK0viSd1BizNgfGInwQR4xFya/Q5xFFsSW1SHtoihkgMkuiVyAbx
         hzGvXSLqbgGLvy/SrmdvPoUh5aaE36F7DR1Guai3KLoFafEkCm23gkGxs18S/4F+NBg9
         c+/Q==
X-Gm-Message-State: AFqh2krCIGMTRmNJiwnh5YXWp2yKndXbGbZsqxW56+uUpF85J+cokVVx
	POk/CPemh9x4Jld1+3oUUTu/80RKIHKxlbHS
X-Google-Smtp-Source: AMrXdXsjGgkAJcoiv5jPM/RGTMpjgNdIfRjDRXQeAkdJdtBjmOu1XmgIBM8JKnIhIldiMVvfo7fwPw==
X-Received: by 2002:a05:622a:229f:b0:3a9:861d:a6a6 with SMTP id ay31-20020a05622a229f00b003a9861da6a6mr63792387qtb.36.1672776976247;
        Tue, 03 Jan 2023 12:16:16 -0800 (PST)
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com. [209.85.222.176])
        by smtp.gmail.com with ESMTPSA id h17-20020a05620a401100b006fa9d101775sm23461957qko.33.2023.01.03.12.16.13
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 12:16:13 -0800 (PST)
Received: by mail-qk1-f176.google.com with SMTP id pe2so15351733qkn.1
        for <patches@lists.linux.dev>; Tue, 03 Jan 2023 12:16:13 -0800 (PST)
X-Received: by 2002:ae9:ef49:0:b0:6fe:d4a6:dcef with SMTP id
 d70-20020ae9ef49000000b006fed4a6dcefmr2045085qkg.594.1672776973189; Tue, 03
 Jan 2023 12:16:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230101162910.710293-1-Jason@zx2c4.com> <20230101162910.710293-3-Jason@zx2c4.com>
 <Y7QIg/hAIk7eZE42@gmail.com> <CALCETrWdw5kxrtr4M7AkKYDOJEE1cU1wENWgmgOxn0rEJz4y3w@mail.gmail.com>
 <CAHk-=wg_6Uhkjy12Vq_hN6rQqGRP2nE15rkgiAo6Qay5aOeigg@mail.gmail.com>
 <Y7SDgtXayQCy6xT6@zx2c4.com> <CAHk-=whQdWFw+0eGttxsWBHZg1+uh=0MhxXYtvJGX4t9P1MgNw@mail.gmail.com>
 <Y7SJ+/axonTK0Fir@zx2c4.com>
In-Reply-To: <Y7SJ+/axonTK0Fir@zx2c4.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 Jan 2023 12:15:57 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi4gshfKjbhEO_xZdVb9ztXf0iuv5kKhxtvAHf2HzTmng@mail.gmail.com>
Message-ID: <CAHk-=wi4gshfKjbhEO_xZdVb9ztXf0iuv5kKhxtvAHf2HzTmng@mail.gmail.com>
Subject: Re: [PATCH v14 2/7] mm: add VM_DROPPABLE for designating always
 lazily freeable mappings
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, tglx@linutronix.de, linux-crypto@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, 
	Christian Brauner <brauner@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Jan 3, 2023 at 12:03 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> That buffering cannot be done safely currently

.. again, this is "your semantics" (the (b) in my humbug list), not
necessarily reality for anybody else.

I'm NAK'ing making invasive changes to the VM for something this
specialized. I really believe that the people who have this issue are
*so* few and far between that they can deal with the VM forking and
reseeding issues quite well on their own.

            Linus
