Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD733D6B
	for <patches@lists.linux.dev>; Fri, 14 Oct 2022 18:05:12 +0000 (UTC)
Received: by mail-il1-f176.google.com with SMTP id a17so2930294ilq.1
        for <patches@lists.linux.dev>; Fri, 14 Oct 2022 11:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=heX+Vf4ClPZWziY9bX1NMfoFhQNF692mEmPkdTluBtI=;
        b=BZ0YQm3TM80LUGEu/I6xjj9baWntOotGI3JZbxq9/KPD5bc8vmQyk3V3by2cnlzVp6
         KEprpwCXOhFSo7hEfWVuCzK5oiz0jCA6J2lW6AkLmB7FZJ7tVFf+amf1HrGESND5g/x1
         yrJxmk0G0W8KXUTIIM4hOf6YVaDOaQFnSiffMjF1FoYP/cNaXSDKXrO0rjLX2ihh5YNb
         nbuhzOgisGmpmpE9iF9K3/ySYvH+GJfskpiZi60nXSUuq7f9C7Bm5QUEf3rG1bE71njV
         6mKDa2jmT9kjw+QVy566pI8teS4G7grRKZxO1zd24zlxM2p073KMWqH+DpTgN6pn4Fha
         wlTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=heX+Vf4ClPZWziY9bX1NMfoFhQNF692mEmPkdTluBtI=;
        b=eL7y1SQjBNoUjgWYksTvA7SN3Ts55PHZucpyvWD4LJlqMrDszmqWrHepRSfTXA4YIl
         9ZVL2G1n4jfvSJgL7l/bnYor96MIgVby/wypyNQ9D87NwquZrtbwZdOQKmFZ1cPdH/C1
         RGAVHZQo7/MifcV4rzp9xCHHe1YcP+lk4tHqESLgAmKvzhe5Rh1+bSg2dqQ6DfGDfdi9
         nmNtfwDxdLRiS8g7o+FG9S6aUMb4X9KcXzXDHfVwv/HUQIQoQs7wOMHd0kqm/YZOiDx8
         ld4ye27ndgFcF06gq8vgEukEjj7cYp193IY0hG7IbZ+HfklrUq4V+6czR9JBRf5yEfl2
         O7BA==
X-Gm-Message-State: ACrzQf1L3ksBeO2g6SGNPGKYDr81/uBTHT8Sv/0UVqxrIyBqR+6O4P8U
	zCEZSZaPRwW5Sprvsu47d3wBdYpqLHUgkmVu3P0=
X-Google-Smtp-Source: AMsMyM6s5Rfx2u7/NNT10bG8hjnLthUnRVBOBP4MJcv/JcaVp/vUIfqY38iYUZHZwKjUZcMueSSsRlZ5c2s9/Rfgu1A=
X-Received: by 2002:a05:6e02:1b0a:b0:2fa:1435:a0fa with SMTP id
 i10-20020a056e021b0a00b002fa1435a0famr2920474ilv.321.1665770712014; Fri, 14
 Oct 2022 11:05:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220927131518.30000-1-ojeda@kernel.org> <20220927131518.30000-26-ojeda@kernel.org>
 <Y0BfN1BdVCWssvEu@hirez.programming.kicks-ass.net> <CABCJKuenkHXtbWOLZ0_isGewxd19qkM7OcLeE2NzM6dSkXS4mQ@mail.gmail.com>
In-Reply-To: <CABCJKuenkHXtbWOLZ0_isGewxd19qkM7OcLeE2NzM6dSkXS4mQ@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 14 Oct 2022 20:05:00 +0200
Message-ID: <CANiq72k6s4=0E_AHv7FPsCQhkyxf7c-b+wUtzfjf+Spehe9Fmg@mail.gmail.com>
Subject: Re: [PATCH v10 25/27] x86: enable initial Rust support
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	patches@lists.linux.dev, Jarkko Sakkinen <jarkko@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@google.com>, David Gow <davidgow@google.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Oct 11, 2022 at 1:16 AM Sami Tolvanen <samitolvanen@google.com> wrote:
>
> Rust supports IBT with -Z cf-protection=branch, but I don't see this
> option being enabled in the kernel yet. Cross-language CFI is going to
> require a lot more work though because the type systems are not quite
> compatible:
>
> https://github.com/rust-lang/rfcs/pull/3296

I have pinged Ramon de C Valle as he is the author of the RFC above
and implementation work too; since a month or so ago he also leads the
Exploit Mitigations Project Group in Rust.

Cheers,
Miguel
