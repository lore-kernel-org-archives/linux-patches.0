Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA984A11
	for <patches@lists.linux.dev>; Wed, 28 Sep 2022 16:40:09 +0000 (UTC)
Received: by mail-io1-f51.google.com with SMTP id g8so10653597iob.0
        for <patches@lists.linux.dev>; Wed, 28 Sep 2022 09:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=urdLMOPMUq7F9WjH0EioiT8rQ4CBbbV9/KBUGHS9AVA=;
        b=jmU83kIJIkGdg1zmHRWqZ1AH0T8R5/6s10x9NxEdRjyCnS2eSN9C9gP7aC+llzT3ux
         ZSLawfFu0NqgpEknC1+PHq/2yeBOA7V8eYXdIFzfgCPljHDOkK4wr9pXrHl9W+CPNpGj
         ZaQFSCWLDsWLfi0cpSCBG5V64G/TnZWPw9JtQWL9oAHy83o8v2RxkagVWb6jh8HElpt8
         vGk3G+00+VVpw3H2OBlDafb4NP66XLve5mqy05Eas+lsRBhzhf57LWbLMgOxQFkpFINS
         FbU4iv5SpCc19biR5QbawCsg3UOjFkhO/WK8p9nkOPh7R4Z12R8H2VHtX42O38fLE0qm
         DQug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=urdLMOPMUq7F9WjH0EioiT8rQ4CBbbV9/KBUGHS9AVA=;
        b=43OYxZgxm7npPc/enAwcgHFZ8M7aqa64qRGTYaes99WsbjZagH4Wv7X6rbvcOHtfU6
         Ikj9E7d/G/o2prP87soKs1kTMWps7UYPRKhmps0iZ7MkaYDE8BnBP1P4anXTMbmHgMvp
         kzZedG80atbsyOHtptyubaQ7uV9Ogu0jxK8jYOcx0IACgYkgVZ2GGm4CA/aWYvm+mClM
         c85/aTV449OYEKFJtlmFNc2goMHOTXzwnVslgJR0jKlKpG4MmGcqXUjsaVpy00jtO0Wg
         tSxmJYauU8FlHlAF1uhfuxgmz7L2GySzdaLnGHo/VhUtNooa7dvhdTGcKqIw2s0qIbLC
         7+Zw==
X-Gm-Message-State: ACrzQf1F13q7UpO7V+5obm+/+ZbilGH9bCyuXOfaWinToneXXVhRnBKH
	qPHjDMJGLv943aYmzT+tcN4m4ECcPWKANA9GQwtn4HzeiLRxhg==
X-Google-Smtp-Source: AMsMyM64rUq1Pv1q6n0ivrz3KN1pFP1NrH3qpOx9cBqmktLgiYVrwusr5+CWkNW+CqcEo/peGe5WtBX3XIZFRvKNFOs=
X-Received: by 2002:a6b:6f11:0:b0:69f:db1b:f4a7 with SMTP id
 k17-20020a6b6f11000000b0069fdb1bf4a7mr14316958ioc.177.1664383208508; Wed, 28
 Sep 2022 09:40:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220927131518.30000-1-ojeda@kernel.org> <20220927131518.30000-26-ojeda@kernel.org>
 <YzRa4U9iFMm0FAVf@liuwe-devbox-debian-v2>
In-Reply-To: <YzRa4U9iFMm0FAVf@liuwe-devbox-debian-v2>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 28 Sep 2022 18:39:57 +0200
Message-ID: <CANiq72m+3gfo=L4T7WY5MeSxZckQKeV+kVdvRhEAVtxcz9cC7g@mail.gmail.com>
Subject: Re: [PATCH v10 25/27] x86: enable initial Rust support
To: Wei Liu <wei.liu@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
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

On Wed, Sep 28, 2022 at 4:32 PM Wei Liu <wei.liu@kernel.org> wrote:
>
> I do wonder how many more things you will need to list here. As far as
> I can tell there is also other avx512* flags for the x86_64 target.

Yeah, there are a lot of target features, but they are not getting enabled.

Eventually, a stable target spec alternative (e.g. all relevant target
feature flags) should be available, and then we can know what the
guaranteed behavior will be and thus decide better which flags to keep
or not depending on how explicit we want to be with respect to that.

For the moment I went for consistency with the line above, since that
was enough to disable everything we needed, though as you may have
noticed, 3dnow and mmx are not there, because I had to move them back
to the target spec [1].

[1] https://github.com/Rust-for-Linux/linux/commit/c5eae3a6e69c63dc8d69f51f74f74b853831ec71

Cheers,
Miguel
