Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8697463
	for <patches@lists.linux.dev>; Wed, 17 Aug 2022 21:00:36 +0000 (UTC)
Received: by mail-il1-f181.google.com with SMTP id j20so7511073ila.6
        for <patches@lists.linux.dev>; Wed, 17 Aug 2022 14:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=40iIAr8LYhq5AvW22C3hNEy4bzm1gOgGQLFh1Xg7rvI=;
        b=UzVVbziiojQv3LCsqLxQ/RkYiVAPOLMi+ecGqOGoVaUva1PaYPrdnN5Kor+wyv+doe
         oTcltujdLHKR9FH1b8i2IkoPcsgoSA7EH5wfIGX2GntI/IPVrLr6nVCSRVMVN7IlRjL5
         8tkCIFgNvhueXXmcaTok+gEBFkUmLIki7txlv8/l7GKHDBa0etfwuumZLwmAfl8qd0fB
         EAxbQFwZkFdoTaQfYHsh7FU5FbRyCHNU/OBBxIoh/tKonBmMAKr8IEs7H4Qd9wS4me1W
         XqvAgCsQ9nB2T6x++wkmAsOS0EoTMMbeycUNZ1H200y5AJxn493q1Jrb+EY4N2Wk2oVb
         FYcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=40iIAr8LYhq5AvW22C3hNEy4bzm1gOgGQLFh1Xg7rvI=;
        b=Dd+UId1tdxJIphy1PAeXcFftqIN7HerqhGBDcwWyRSMd9mLRStF2mWKlQXiNBOWaID
         ajF996HARQd1nspuJJ2Jmv4LDuPKUlV8pPmWndOX1BUIR7B3zcva/ojtRLmaZUEGnNX2
         VTuNck7W+54SA2NWA8x4oWaaVsZw1/bxee4j/xu/PfuSapnaml2r9WCip0GYfRBO6Ou9
         ytaRRk8y36ST++mj/qN3whFGTDYJ6PRsxXWyABgSswHl0fPma1XrZPdLTdjo+Tgw355t
         s7+DQWXOkFHlX18Qq8kChK75C/hHEDM905GwzNjrBLgBxvXLqusD9yFwaa5wod7o6IpI
         ht1w==
X-Gm-Message-State: ACgBeo2t7uxLm74uTF7dG/xQOOxGTw+m1M5abZy2JMPScKz1P5zECBwU
	Dzrof1b6QTNMqQsd1lXhoS1ShYG307tlN3SugiE=
X-Google-Smtp-Source: AA6agR6w3qxjJ9EAZgEhyHRkMEdSpaFT754F+1mteNpzDA698wU0APNIvqfrrwixCsek1yfY8Luu4BVO8zVdyBhJx2k=
X-Received: by 2002:a05:6e02:1ca9:b0:2e5:fa2a:6345 with SMTP id
 x9-20020a056e021ca900b002e5fa2a6345mr5042837ill.5.1660770035500; Wed, 17 Aug
 2022 14:00:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220805154231.31257-1-ojeda@kernel.org> <20220805154231.31257-8-ojeda@kernel.org>
 <202208171257.E256DAA@keescook>
In-Reply-To: <202208171257.E256DAA@keescook>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 17 Aug 2022 23:00:24 +0200
Message-ID: <CANiq72mOgDjp5eSJW6pkkNdF-YX0BSLofEwAm88oUzQFybQZGg@mail.gmail.com>
Subject: Re: [PATCH v9 07/27] rust: import upstream `alloc` crate
To: Kees Cook <keescook@chromium.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	patches@lists.linux.dev, Jarkko Sakkinen <jarkko@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@google.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Aug 17, 2022 at 10:07 PM Kees Cook <keescook@chromium.org> wrote:
>
> Can you include an easy script (in the commit log) for this kind of
> verification?

Of course, good idea!

> For this, I have done:
>
> $ git am 0001-rust-import-upstream-alloc-crate.patch
> $ for i in $(diffstat -lp3 0001-rust-import-upstream-alloc-crate.patch); do
>         wget --quiet -O check.rs \
>          https://github.com/rust-lang/rust/raw/1.62.0/library/alloc/src/$i
>         diff -up rust/alloc/$i check.rs && echo $i: ok
>         rm -f check.rs
> done

Thanks for providing the steps like in the other version. This one is
even fancier :)

Cheers,
Miguel
