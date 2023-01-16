Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55ADF79DC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 23:35:50 +0000 (UTC)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-4e9adf3673aso63929707b3.10
        for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:35:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VYNmtX4azwAKTTUMwpvjnaBuUMcH5MIveEe0DLHOIPE=;
        b=pCgDnb4O2N7vuYuZO0mjE15/XR1bujf9K/A8e9YAZJDyYoQiAu07W60TgurF1eOP3A
         GOSQoG58mX7qUn8YuoliGj+XfsuZ6IcUa9TX635w2hvBczwJ7PxHnxLrK7cBC3owljKD
         l5xW1YDssHJu3n1KMvnYur8HT7XchSU9ZI+TDPCYFdPbJtsDNIp35ITS9jz6bfDAV8wg
         t2HU/wa0ZcgSq2a+sBMZZe+NIGWTpZU1krA3LLuQszR2OMEuye7WYyRTsSBd0vTo8ujM
         BD82tkQEh2y0EEBCpqmFNZznvUIRYEi06Wb4E9ahF4JEARccyMx877Sh8k0SHqY2tEb5
         +7/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VYNmtX4azwAKTTUMwpvjnaBuUMcH5MIveEe0DLHOIPE=;
        b=jg4LiNfyAVQd0XfiRs4kHOsruKTsH/pQKV8zSf5M8UjSRiodDDAScm3C2NFcFp4p6J
         y7UNrz4h+5GoGD8mQMDY6r02dEK+hvTAtsn1Up0kiPl25sBkm2liwnAvcojHHuZ6WUge
         yC7MOM5Fs2wmcVgAaoU1Vsa5ugdF2Kx9Rq61Z+5ziumD9qx//u5DOsmB6okDEL9zCk3c
         pmU7KkiWurND794hOzbfx46aex/slkx2YNUs8aYlq+202KBRjOCKF4zEpHdwfTUvpaug
         YThllN8fI/ZH36EeGuyvpWYd6yMTHlZd8jOcIf4FaKH54l6QLAg0NV/RId94rJJcwzrY
         MCsA==
X-Gm-Message-State: AFqh2kqlxAUU4K/mwv8iMdy0FsLGur3/LhlCHOZC7nwt1WPSsGLnBxLU
	7JjDw0qDpz4lQNn2sLMubH2LhpybvpCASRHvPEX4lUx/mn3MmO9k
X-Google-Smtp-Source: AMrXdXs00Nhyckfn9ZEhPQkqTyttOZOCcHV6qurBaGtB/aKPrcgDuwtgjRgbWgA51ajcI3FqM8eEmOwAhJWynA9RM20=
X-Received: by 2002:a0d:fc86:0:b0:4db:3ac0:78a3 with SMTP id
 m128-20020a0dfc86000000b004db3ac078a3mr129399ywf.266.1673912149301; Mon, 16
 Jan 2023 15:35:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221214093451.zdyhmdyxwz73n6pe@imap.mailbox.org>
In-Reply-To: <20221214093451.zdyhmdyxwz73n6pe@imap.mailbox.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 17 Jan 2023 00:35:38 +0100
Message-ID: <CANiq72kB6=hYUhgEv03zORAN9-aAi6UNwD5jcbh5vM6nUknL2A@mail.gmail.com>
Subject: Re: [PATCH] rust: prelude: prevent doc inline of external imports
To: Finn Behrens <fin@nyantec.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Wed, Dec 14, 2022 at 10:35 AM Finn Behrens <fin@nyantec.com> wrote:
>
> This shows exactly where the items are from, previously the items from
> macros, alloc and core where shown as a decleration from the kernel crate,
> this shows the correct path.

Applied to rust-next, thanks all! (as discussed, I added the Link on
my side, plus fixed a couple typos and the comment style).

Cheers,
Miguel
