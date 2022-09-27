Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3FAA5D
	for <patches@lists.linux.dev>; Tue, 27 Sep 2022 14:01:13 +0000 (UTC)
Received: by mail-io1-f52.google.com with SMTP id i17so818566ioa.13
        for <patches@lists.linux.dev>; Tue, 27 Sep 2022 07:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=DyaVo3+lMzTcUfudleYugyX5eghJmiI4XJiWCxqbggY=;
        b=LHvf/mqnPOMJ9jL0cy3ik7mshxI0ktIgXgIZoGbE6+/5menga1hXjWEhRj3thykjNN
         sRWPJ1QHAGtJOAHY8uu3J1KEyWSoo5h/5Wfzh3VzCDHmwddRTwI/r+shjRPDZe63NXtz
         xOg9cMpBfPxLEM3CjTMDUZ+xL8OP6MJe8V0SPvic6/XvtQBRGHfzXXSvV8qRklW5DPjN
         /E6CZhL9ixRoUP+7fH0XSAU0Ur9A40X2dPhWAF0NvnpM6pLtlWYWVXbfJFD68kHAvHXf
         K57n4DCCeruRap/T2pjq2IvqrdBsPEcQAXBpo+W0sF/8xKkMtlQ/bKLv6l4kEey7ziTw
         WIQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=DyaVo3+lMzTcUfudleYugyX5eghJmiI4XJiWCxqbggY=;
        b=m1DLKuBXvlmxOuxJBEKxVGadF26gYo06FasT+XA+uxbSHbbD/mN7dnnd9Glx2YsdS1
         vJ9p1SAYDjXDDYxqEv2kJXtu79i3ndAKEQsm0/lC2lHWS3DlXwIfslofWjZ3T8bP6MDt
         05nBR0Kw68tjknSunFx7yZr6MMAm7ZnFYaUpzqfzZjLEWUJMdTOcfnnV8vU444rBl/kF
         UQgJ5Cr1QS5l4A1R3HUqkct/IqfGK3bSxk5IsBB3EKpYWboxoN3pKlZpnjNWlIWHSxmM
         hEGjeZZ3fSk/eY9AALeol9MZJ1Tp8p1RaP6RdBINg8Q4bwbVrfXqCNN9POoA3kf9/wNf
         xglA==
X-Gm-Message-State: ACrzQf3ZoH5RGvOZU2WPGaEltKmrXPjMZdl6s8ZIG2j3j6zpqkc0jzqZ
	7YwdpJvRn44OjaWEhDbHJKhUaZ0W/ftEBCv2UGg=
X-Google-Smtp-Source: AMsMyM7ih95kfEqXr/sO68fs24aizZEEsCMT/+AVTJKPYG7G7n20Q70D7m5R6BLcryt+9rRao44muZd3E5XhQMAGlcQ=
X-Received: by 2002:a6b:6f11:0:b0:69f:db1b:f4a7 with SMTP id
 k17-20020a6b6f11000000b0069fdb1bf4a7mr11582661ioc.177.1664287271842; Tue, 27
 Sep 2022 07:01:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220927131518.30000-1-ojeda@kernel.org> <20220927131518.30000-11-ojeda@kernel.org>
 <YzL/FfwKoL5eBiWS@yadro.com>
In-Reply-To: <YzL/FfwKoL5eBiWS@yadro.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 27 Sep 2022 16:01:00 +0200
Message-ID: <CANiq72kV_R-_SkFdNRTr75jvk-HOUZ07WH6gU+d-nXaY41Czdg@mail.gmail.com>
Subject: Re: [PATCH v10 10/27] rust: add `macros` crate
To: Konstantin Shelekhin <k.shelekhin@yadro.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	patches@lists.linux.dev, Jarkko Sakkinen <jarkko@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Finn Behrens <me@kloenk.de>, 
	Adam Bratschi-Kaye <ark.email@gmail.com>, Wedson Almeida Filho <wedsonaf@google.com>, 
	Sumera Priyadarsini <sylphrenadin@gmail.com>, Gary Guo <gary@garyguo.net>, 
	Matthew Bakhtiari <dev@mtbk.me>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Sep 27, 2022 at 3:48 PM Konstantin Shelekhin
<k.shelekhin@yadro.com> wrote:
>
> I remember that there was a switch from &u8 to &str on master branch a
> while ago. Why this patch was reverted? Strings are really better here.

It was not reverted; but it was merged right after v8. Then v9 was a
trimmed v8 and v10 is intended to resolve a few last nits from v9.

In other words, there are many changes (including the vast majority of
the `kernel` crate) that will come afterwards.

Please see the cover letter(s) for details.

Cheers,
Miguel
