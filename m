Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54942F22
	for <patches@lists.linux.dev>; Wed, 28 Sep 2022 15:26:06 +0000 (UTC)
Received: by mail-il1-f172.google.com with SMTP id o2so553289ils.0
        for <patches@lists.linux.dev>; Wed, 28 Sep 2022 08:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=K+jbjc09DvdLJcy4Thzzh2ay02sErQC/GfQnNm8hrTg=;
        b=A6DnVDZE9AoTQrtk6g5BKxUQfRkdjGz/YL1tMBBRR8CgRRdjwxe14GLF+Hi3nx/hkR
         xAMPgcQUGisNxmIkdq0rSZNza7G4JBpG4HZrY8FYAWHP79G5jz+Ne4SpkIRgaN8tvOms
         L/sy8WzVAvfuB2mWWCkblqFYQdbo6DuK1W3dGP1Ib7KI5OPZYwXdTSHximEqs4p6Ki0O
         PGl5FDmZQ2tMHVOvkAv5mera/NMB0HsFAfve9Cm96FDCbamMQZPg7IELcKWb6sEw2J+N
         qRDTTKM3pDiJlUkZ0O3ifqC9vN+L1g9brWa4X/ftSTUnRnme2FDiUKu1hrJEPtpB0rLj
         7L9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=K+jbjc09DvdLJcy4Thzzh2ay02sErQC/GfQnNm8hrTg=;
        b=s3KRY9q+RIvkfPI7wva1CpcKGGOSujqS7TDFjDWiBa5u0ohTWCL3cukADxf42AQMVV
         mruvK4kWjyPvvD35lXedRx0hVKSQ2OXkVxS4OCM19hW4LrMdXLOFguAXFd3wSU0Sw0TI
         WK0iDDmUImLPf1F9d0VEH59+VbVi/5t8Vug7VrHgKF0ji3h55vA4gMXoWGdGX/P3hKdk
         o51kySrpkJ47MyhCc9yDXleh9Ou+yTwAhiMUI/m060H8TRZpVWIb7IR5Cacg3/6hioLk
         LqBtVOi3fzNiWMftoEcA8tPmmreEzWDONKrIGev8vRdFsSi8ck6rsu7WrHTrHFWscJw4
         it1w==
X-Gm-Message-State: ACrzQf3+19DQ6fMEr1HnA3ZoC6eNuqYy0oNFqa/xkmpVbOLTd4g07ysk
	/4o9lFMmcwDDLOUPH7Vy+IxF7ClnwAFPZLx+Lzg=
X-Google-Smtp-Source: AMsMyM4KDnYXvWAcGD1P9KclEAvPnSfV92FAdlD2MtWDYqQPJyaYgLFUoDd8cLzEFMqXiU74a5Cx2fKsbXFIMLmzWrI=
X-Received: by 2002:a92:c569:0:b0:2f5:927d:b61a with SMTP id
 b9-20020a92c569000000b002f5927db61amr15790847ilj.151.1664378765811; Wed, 28
 Sep 2022 08:26:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220927131518.30000-1-ojeda@kernel.org> <20220927131518.30000-9-ojeda@kernel.org>
 <YzRj+47LIz2G9omo@liuwe-devbox-debian-v2>
In-Reply-To: <YzRj+47LIz2G9omo@liuwe-devbox-debian-v2>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 28 Sep 2022 17:25:55 +0200
Message-ID: <CANiq72=qZPdcdPJzD0FMN13A34C9mXoMb18+uKaA7rdEGuZ0TA@mail.gmail.com>
Subject: Re: [PATCH v10 08/27] rust: adapt `alloc` crate to the kernel
To: Wei Liu <wei.liu@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	patches@lists.linux.dev, Jarkko Sakkinen <jarkko@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@google.com>, Gary Guo <gary@garyguo.net>, 
	Matthew Bakhtiari <dev@mtbk.me>, Boqun Feng <boqun.feng@gmail.com>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Sep 28, 2022 at 5:10 PM Wei Liu <wei.liu@kernel.org> wrote:
>
> Missing safety comment here?

The standard library does not provide safety comments for all blocks,
and these are essentially copies of the infallible variations in the
library, which I kept as close as possible to the original.

Thanks for taking a look!

Cheers,
Miguel
