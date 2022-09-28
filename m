Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524093FE3
	for <patches@lists.linux.dev>; Wed, 28 Sep 2022 15:34:51 +0000 (UTC)
Received: by mail-il1-f176.google.com with SMTP id m16so6797111ili.9
        for <patches@lists.linux.dev>; Wed, 28 Sep 2022 08:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=7YMjbZ8J9tKgbU3lbB83+uhwQsHK55CjtoPPW43rcIs=;
        b=nNT6rlWUMZ0SnuEJDO14/3j3UbMTHEOYduj5E8ktaj4JO5Au5p8UggQZHYBM9s9GmC
         GPGoE10f0NsbRaD8tGugG3Lmnv8e6efNy4SAUsYAbFSGgKbXZJyRtmVuHhdsxWMtqSD6
         vFSZofQPWLVPySDWnU8vboBghzU4R82yvZwVX+nt+bSgQu9XrHFq1XEg0frnQPHw24Qs
         6FqPWpmk+NR10+DJu4YQN2hMVRaZ8hreQw/xR/1stVJHdElbahdC1o6/9sFtOYcZ3HFm
         ifyZxxNjnmLwvBXNDiqWHI8yYwuyMoklS7kVWGY+9QXmwsiKmJ1LncnkVZBxYd/l892C
         B+yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=7YMjbZ8J9tKgbU3lbB83+uhwQsHK55CjtoPPW43rcIs=;
        b=oCH5GykZFuLbDgAUwJvreRugClwEQ89X/XwnZgEsb/C8IsF8349vPIQWywx+Fk2Poe
         4cK1BgrsVYv3gRgiLc0Jnw9/RAN4JlzFJdDKxoThite8yQhO5uvHFG9Nu6TtjS1hZmGY
         LanMFrqyYv/tjDQCA6W+ZeC0YFNowl5/9a1BbnQJ2p6qF/pK1idSef8lXQOrc0qVl/Cg
         W+wWWYNwXW5gzEokwbDz+9xKmcacznRH6oohP1kae/veQIO+0ft0bsOgNhzDgc2fKKjG
         fbMb+LeJU4lShTnU7AO/hujnNiGVfKEenFbmK1G07ieqOQF86J3aE0beRsdYpTKfuBfc
         mGbA==
X-Gm-Message-State: ACrzQf0teIGuDS3Q4s9I5Uem0Ds4P5IFDGMmB8Vw+92s8Sw4MOCBlOcI
	Ztk0vnFHsQXibxwugA5KfAu09I3DBD+kxnbg8jo=
X-Google-Smtp-Source: AMsMyM5GmHEAKGvxhjbyKefQqMoHqYHsCmV0gzis+S9H+0AZni9Jyq1QNEECB5Z8RI13e4VdJP112o1DTRnVZBgEd6U=
X-Received: by 2002:a92:c569:0:b0:2f5:927d:b61a with SMTP id
 b9-20020a92c569000000b002f5927db61amr15812068ilj.151.1664379290391; Wed, 28
 Sep 2022 08:34:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220927131518.30000-1-ojeda@kernel.org> <YzRjEc9zQbHeWPFL@liuwe-devbox-debian-v2>
In-Reply-To: <YzRjEc9zQbHeWPFL@liuwe-devbox-debian-v2>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 28 Sep 2022 17:34:39 +0200
Message-ID: <CANiq72kq4RR4suFjGUZeg6ua8X=KU5aBPKPgjRH29hOVmDiNLQ@mail.gmail.com>
Subject: Re: [PATCH v10 00/27] Rust support
To: Wei Liu <wei.liu@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	patches@lists.linux.dev, Jarkko Sakkinen <jarkko@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, Sep 28, 2022 at 5:07 PM Wei Liu <wei.liu@kernel.org> wrote:
>
> I cannot find this patch in my inbox. That's probably filtered out by
> the mailing list since it is too big.

The patch reached lore in case you want to double-check:

    https://lore.kernel.org/lkml/20220927131518.30000-8-ojeda@kernel.org/

I am Cc'ing patches@lists.linux.dev as suggested by Konstantin to
reduce the chance of problems, though I wouldn't expect to have issues
now since it is fairly smaller than v8 where we hit the issue.

Cheers,
Miguel
