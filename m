Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788307460
	for <patches@lists.linux.dev>; Wed, 17 Aug 2022 20:22:49 +0000 (UTC)
Received: by mail-il1-f176.google.com with SMTP id j20so7463737ila.6
        for <patches@lists.linux.dev>; Wed, 17 Aug 2022 13:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=95u8lNlnSqCf3nFt5kKj92QXYH3MSbflseNXxb5Fn00=;
        b=OYcQUlqsxAJgqISQCgV3vtZHXpalxDTEAE8J09DLHSEXI4qtBF+wzVSvouAELH+k9w
         L8Jjk3X4U8OPV+0FQDBGxAsiOH/g4GzoQtIO9LrExv8Z7oo0tjeZl0c8+670S9iv9xIG
         3VHN/FP/kUrxQATYNnyMcnJzuQ9HRb/7JMaD8CnA6C3SC0izg6+nZ3Y8yF1T0wBzkG1S
         yk6lDQ9XAsaMI4Ou2XPGIcz5AMTh3h+H4b7w6X0q5TEzfmVVPL5Thz4gggWBJPx0mTeY
         ZrbXvnYp0VFg8erHdWD3GA8WgQLvK/uExgsosHBf9+lxmgnybC590tnbLz5kykLynGLJ
         jkKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=95u8lNlnSqCf3nFt5kKj92QXYH3MSbflseNXxb5Fn00=;
        b=qT5NBJgu1PYKMa/dqtFclb8Nr8WkKKDJoHA0ytizxCD70UvJB1KbKumKraLVQh3DPU
         ztIKHmIbli5oNyR0e1JHG7A6AUIh7Snz4rcRYPoetN9ZT+OZaS9zBfMcMeI3TuxJLboN
         WIRhGWS2K1REhBi1kRbRqR+pYP+IqAQXa3+rLFXO4A7CDmWbQDdLmGluDNJ+uR1ZSrm4
         63m48ZInofU6T5o5YPd563nQz9MU5Z8k6Ou17HJvqLm9gi85g/ZUuBJHC5+gA5qQLrG0
         yofVdyIYRRDzy/RtbJp2Skv+H4BwzpJ9Nn5b3E2aJuLUNFuI/rAQv3ShPkoALtTb5vlo
         AlZg==
X-Gm-Message-State: ACgBeo3z6khY/nvm7WXVYSxFetnFVBcgcYFRAEFRkkMGrO6CXo5NVgUL
	0p85BjHTh2FokwjD0vDGr7xYMLQuYIuVXnQ9b28=
X-Google-Smtp-Source: AA6agR6srAwQfsZZ9SbamGt91jriBGl4JS80mCTykIHOHWKu4a1YmyuaMej5D630lBaYsdWmc87I+yEYpkFHIpL2+ug=
X-Received: by 2002:a05:6e02:1522:b0:2e5:9e3c:a7c8 with SMTP id
 i2-20020a056e02152200b002e59e3ca7c8mr8623597ilu.237.1660767768527; Wed, 17
 Aug 2022 13:22:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220805154231.31257-1-ojeda@kernel.org> <20220805154231.31257-7-ojeda@kernel.org>
 <202208171240.8B10053B9D@keescook>
In-Reply-To: <202208171240.8B10053B9D@keescook>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 17 Aug 2022 22:22:37 +0200
Message-ID: <CANiq72nR2eAeKrY6v=hnjUjvwfecMsSC6eXTwaei6ecnHjia8g@mail.gmail.com>
Subject: Re: [PATCH v9 06/27] rust: add C helpers
To: Kees Cook <keescook@chromium.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	patches@lists.linux.dev, Jarkko Sakkinen <jarkko@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Geoffrey Thomas <geofft@ldpreload.com>, 
	Wedson Almeida Filho <wedsonaf@google.com>, Sven Van Asbroeck <thesven73@gmail.com>, Gary Guo <gary@garyguo.net>, 
	Boqun Feng <boqun.feng@gmail.com>, Maciej Falkowski <m.falkowski@samsung.com>, 
	Wei Liu <wei.liu@kernel.org>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Aug 17, 2022 at 9:44 PM Kees Cook <keescook@chromium.org> wrote:
>
> "Introduce the source file that will contain forwarders to common C
> macros as inlined Rust functions. Initially this only contains type
> size asserts, but will gain more helpers in subsequent patches."

Yeah, I will reword it, it doesn't make as much sense now that it is trimmed.

> Given the distaste for ever using BUG()[1], why does this helper exist?

We use it exclusively for the Rust panic handler, which does not
return (we use fallible operations as much as possible, of course, but
we need to provide a panic handler nevertheless).

Killing the entire machine is definitely too aggressive for some
setups/situations, so at some point last year we discussed potential
alternatives (e.g. `make_task_dead()` or similar) with, if I recall
correctly, Greg. Maybe we want to make it configurable too. We are
open to suggestions!

Cheers,
Miguel
