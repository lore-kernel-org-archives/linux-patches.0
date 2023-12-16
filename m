Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1348E2C689
	for <patches@lists.linux.dev>; Sat, 16 Dec 2023 13:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c5BKjgdH"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6cea2a38b48so1519394b3a.3
        for <patches@lists.linux.dev>; Sat, 16 Dec 2023 05:56:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702734991; x=1703339791; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d+QKSwtAIEuecoULCNbymDGc4MmnFHIZxwHr8KNV/bw=;
        b=c5BKjgdHB3M6WLwm1E+6XEmNAXODqOqZR7O0JG+tRbNcvxeMikYLEqeSN7PN/PSitz
         bckf1mE/AYLleHMQgDNU4MpYv6hoh7wqOAyeTrnUS9CzfY3+M0K4C1H76SsDgRWr9Dgh
         dFyG4JblxNZOsJwQElMmRBkbahjRe8pXawSgU2kdgLP8riPfRwmx78JwLSTzVesgMYTS
         SpqC+ahosMOnkk8P568O6cMh13cJ1mIc195LocAqLNkxjE7E2q2/RMg+XAtnfg7Un9an
         feF69IJtrvigojE2uIh9Tjsu/pCkTGyemEgDtrM5qqPtHiM6tixyRCpQ7deWqrkRWIXo
         pNWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702734991; x=1703339791;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d+QKSwtAIEuecoULCNbymDGc4MmnFHIZxwHr8KNV/bw=;
        b=ezJbBu0tlVdPO5Tu53zS75l1WHC1RwcwEbfnHDudNJ6injakQad2k4IAPS3KJk6WZ8
         tQ668w0enOTOYjgJlZyhYiVNkg/yjsCNHho81/MoaHV0iBgYN/phXBK3p8aSqm57WSoQ
         rnlJd0YDoZN9KuvyE0DhPIDnaDf5RdFNBHh7ZSrAuspOraZHQfeIs2gJXIJsKedPuQOW
         H5lQ4KB3ToyJ8mBZMks/ILB9S0hhyL5K3g+rMP3KpZS8tBdWGFy6phvyH216uSuV+RIH
         j8OxQf+JFLkSAg7Tmv4wdhziRUrUop6NZ9gzctjC5ZWG4+ROXU5YLrZ0hGwq8Qh16cQY
         J3ug==
X-Gm-Message-State: AOJu0YxE1XaBzFVQfj6nP/hWPJcXAUAki679QYgLFxd+U50UdfQWuLNE
	OSdnIVQHhmLTJegDdrujiiY=
X-Google-Smtp-Source: AGHT+IEvyd9u/4I3Ib/Kj8Ccrn9JnHOTcgSpSuZTPny6sk8cJ2XeXf+zI8WOCSUg/vamTGy38bBXqw==
X-Received: by 2002:a05:6a20:54a9:b0:190:1c0:1c25 with SMTP id i41-20020a056a2054a900b0019001c01c25mr17329292pzk.91.1702734991213;
        Sat, 16 Dec 2023 05:56:31 -0800 (PST)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id kb1-20020a17090ae7c100b00286e9bec1efsm18039549pjb.33.2023.12.16.05.56.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Dec 2023 05:56:30 -0800 (PST)
Message-ID: <08b3f964-a66e-483d-81dd-4f6f8f61bdbd@gmail.com>
Date: Sat, 16 Dec 2023 10:56:25 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] rust: support `srctree`-relative links
Content-Language: en-US
To: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl
 <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 FUJITA Tomonori <fujita.tomonori@gmail.com>
References: <20231215235428.243211-1-ojeda@kernel.org>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20231215235428.243211-1-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/15/23 20:54, Miguel Ojeda wrote:
> Some of our links use relative paths in order to point to files in the
> source tree, e.g.:
> 
>      //! C header: [`include/linux/printk.h`](../../../../include/linux/printk.h)
>      /// [`struct mutex`]: ../../../../include/linux/mutex.h
> 
> These are problematic because they are hard to maintain and do not support
> `O=` builds.
> 
> Instead, provide support for `srctree`-relative links, e.g.:
> 
>      //! C header: [`include/linux/printk.h`](srctree/include/linux/printk.h)
>      /// [`struct mutex`]: srctree/include/linux/mutex.h
> 
> The links are fixed after `rustdoc` generation to be based on the absolute
> path to the source tree.
> 
> Essentially, this is the automatic version of Tomonori's fix [1],
> suggested by Gary [2].
> 
> Suggested-by: Gary Guo <gary@garyguo.net>
> Reported-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
> Closes: https://lore.kernel.org/r/20231026.204058.2167744626131849993.fujita.tomonori@gmail.com [1]
> Fixes: 48fadf440075 ("docs: Move rustdoc output, cross-reference it")
> Link: https://lore.kernel.org/rust-for-linux/20231026154525.6d14b495@eugeo/ [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>   Documentation/rust/coding-guidelines.rst | 13 +++++++++++++
>   rust/Makefile                            |  3 ++-
>   rust/kernel/error.rs                     |  2 +-
>   rust/kernel/ioctl.rs                     |  2 +-
>   rust/kernel/kunit.rs                     |  2 +-
>   rust/kernel/print.rs                     |  8 ++++----
>   rust/kernel/sync/condvar.rs              |  2 +-
>   rust/kernel/sync/lock/mutex.rs           |  2 +-
>   rust/kernel/sync/lock/spinlock.rs        |  2 +-
>   rust/kernel/task.rs                      |  2 +-
>   rust/kernel/workqueue.rs                 |  2 +-
>   rust/macros/lib.rs                       |  2 +-
>   12 files changed, 28 insertions(+), 14 deletions(-)
> 
> diff --git a/Documentation/rust/coding-guidelines.rst b/Documentation/rust/coding-guidelines.rst
> index aa8ed082613e..05542840b16c 100644
> [...]
> diff --git a/rust/Makefile b/rust/Makefile
> index 543b37f6c77f..73ea24117f07 100644
> --- a/rust/Makefile
> +++ b/rust/Makefile
> @@ -98,7 +98,8 @@ rustdoc: rustdoc-core rustdoc-macros rustdoc-compiler_builtins \
>   	$(Q)find $(rustdoc_output) -name '*.html' -type f -print0 | xargs -0 sed -Ei \
>   		-e 's:rust-logo-[0-9a-f]+\.svg:logo.svg:g' \
>   		-e 's:favicon-[0-9a-f]+\.svg:logo.svg:g' \
> -		-e 's:<link rel="alternate icon" type="image/png" href="[/.]+/static\.files/favicon-(16x16|32x32)-[0-9a-f]+\.png">::g'
> +		-e 's:<link rel="alternate icon" type="image/png" href="[/.]+/static\.files/favicon-(16x16|32x32)-[0-9a-f]+\.png">::g' \
> +		-e 's:<a href="srctree/([^"]+)">:<a href="$(abs_srctree)/\1">:g'

Another way would be to not put `srctree` in the link and add
`abs_srctree` here to directories that are in `srctree`. But that might
be too wonky to rely on so this will be the way to go.

>   	$(Q)for f in $(rustdoc_output)/static.files/rustdoc-*.css; do \
>   		echo ".logo-container > img { object-fit: contain; }" >> $$f; done
>   
> [...]

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
