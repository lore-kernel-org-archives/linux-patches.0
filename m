Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988D63C13
	for <patches@lists.linux.dev>; Fri, 14 Oct 2022 17:23:30 +0000 (UTC)
Received: by mail-io1-f52.google.com with SMTP id e15so4429961iof.2
        for <patches@lists.linux.dev>; Fri, 14 Oct 2022 10:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eE5Ag7RBU3sseMTq/AOwS39S0M38TKiM5Cd+C4qDXCg=;
        b=SelnujiWPnwoqfZh8L8STKGUSxYsQvfporOrGfiFWq7bcOzL0QfdMmL40UKrA+beU+
         PC/2mJpZDykCD2AjqVjwdRgvdWQ7aogtAl+Hq/3RYfuMFqkmdwGX5x9i2EF1LURSEkWe
         UgEVvUzkNVE22tJqIQkviWHhunuxpOVT8D4lwYeRlBXIXcNhM2OyyZ7v+zgA/fL/CmbA
         9QEL0Tn6Z/ZtMi3pOJiB6isnrjoAKhSXEzcs6KLcsD7E9FEePJWKn1u9DAnNcvjIrx4G
         h4G0Z5ct9Vfi0V5ixBdkIMpgsvwCZsWMXka3IgbZiFUUFnJ+QBQQH6oNk4hLFjFvPokK
         5fwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eE5Ag7RBU3sseMTq/AOwS39S0M38TKiM5Cd+C4qDXCg=;
        b=h4LkVNxnBPtphwkIp6NcYOwPi63qo47SQ1qMyTCQDHYN41d1We6Giw50J930vlWgLg
         onDhM7xCgiMZXBb40v1va7ImjuQLMtPTHKiZQuXNv73qd26diklpZdSMe/5omsMAW52A
         /vIc+OLRg1CoMuA/HF8ikuLIGxquWl4mpRkOkM/k0VTTPSLMBgocARRKzjKr7noUpX+j
         zBWFEVnYtAmZ7Y03Lz1nq2Jo8Lgs9JBWSY8aPF85zl1inaYYUV9W7nPuuiYwi6iV9DbU
         rt9Fjs7wZK2Mb42sdyEfRM9Myc5IcFjZAos2GfTXSTEsSWg58/OnRolb6O9IFZVGGwMz
         kEBg==
X-Gm-Message-State: ACrzQf0Gq9NGgdNrDILRUZvWToNXknGPY23qaveOIyCDfu57YbpRMluS
	6xVWqgOD8u8yTb/q1Lb/v/86jufsZGRvJF+cNUo=
X-Google-Smtp-Source: AMsMyM6lT8RhqnU76Cr4PZZfqp6N8r8CcTFMjIHkYpaZhVOM7vxX6chpycRJ9uocxKR25P/3/Yeaz4H/VQ4EpfSIe7c=
X-Received: by 2002:a05:6602:134f:b0:6a4:cd04:7842 with SMTP id
 i15-20020a056602134f00b006a4cd047842mr2888358iov.172.1665768209701; Fri, 14
 Oct 2022 10:23:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220927131518.30000-1-ojeda@kernel.org> <20220927131518.30000-26-ojeda@kernel.org>
 <Y0BfN1BdVCWssvEu@hirez.programming.kicks-ass.net> <CABCJKuenkHXtbWOLZ0_isGewxd19qkM7OcLeE2NzM6dSkXS4mQ@mail.gmail.com>
 <Y0Ujm6a6bV3+FWM3@hirez.programming.kicks-ass.net>
In-Reply-To: <Y0Ujm6a6bV3+FWM3@hirez.programming.kicks-ass.net>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 14 Oct 2022 19:23:18 +0200
Message-ID: <CANiq72nggG_z28Pne7wD=CQfKX3bTUah9vMhvJoWB8Y=uA4j+w@mail.gmail.com>
Subject: Re: [PATCH v10 25/27] x86: enable initial Rust support
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, Miguel Ojeda <ojeda@kernel.org>, 
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

On Tue, Oct 11, 2022 at 10:04 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> Right; so where does that leave us? Are we going to force disable rust
> when kCFI is selected ?

Constraining it via `depends on !...` or similar as needed for the
moment is fine, we have a few others too.

Cheers,
Miguel
