Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03303DF45
	for <patches@lists.linux.dev>; Wed,  3 May 2023 19:24:10 +0000 (UTC)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-50bd2d7ba74so10028493a12.1
        for <patches@lists.linux.dev>; Wed, 03 May 2023 12:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1683141849; x=1685733849;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lnk0azjKtvGmutcc0sPTCISsVHec16NyojRU9ojJrvg=;
        b=causNhxWqRQ7hQahP6eEUcGtbqXlmaI3YjTVxYJjY8hH6lBDVDv9aoY+LBEKZ72thM
         tLotGm4fqFDlI9ND1YgaeDbYcN3cKR8+ZPfh1D12xoBvGXZG+0gsqkWdabkdNVNUEFmH
         SkOps+0GJ9eIygVoq/Ds5a0iys+ZPPeDDGr4g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683141849; x=1685733849;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lnk0azjKtvGmutcc0sPTCISsVHec16NyojRU9ojJrvg=;
        b=Agfh+uGz2UigfSXD+etcp/prPZLU9/iXFN0Lwkwajv1T8/z2CPI8pksP3w+uUFgzF8
         kimAi9z2vqmhIoeeQCMVMjhYDFkkoo5cSeK/NTmIyO1sFQCYC80YXyRseBWXx6+/mVn1
         9DWqbTi80E+2sxengO1PKD3bWyYMcf6vMQkK3XCaBVp55/ct70NWlLPH+b/fPFSmzBiD
         QNvKuFSfjAlR3TE9dbJYMzgmW6VN4oLhoIPDt3tR344PZyXBmf3/JgCa7oIl08IJVU57
         7xYud1bFMg7iuzOaT3QyF6cg0HvJ8YatrNbL89GyDSOlorHW86qyd/tSfqGQBQxIZVIs
         v6RQ==
X-Gm-Message-State: AC+VfDwgHbO/woxe0qQ0vyBzu/hGRWUxrmbhFpNJDtLQxhMiwksK/YE+
	sE6kMCNzf1Z4yupS3u10GnX1VcsrziidgWQD/ADdeA==
X-Google-Smtp-Source: ACHHUZ5kus2hB8HWdYwwbBxXkg9HDpbE+jQqLQOnYpj3nrzpqRq3rlXc66pc2+eeJ6WL6VINL43j/A==
X-Received: by 2002:a17:907:d1f:b0:961:8fcd:53b2 with SMTP id gn31-20020a1709070d1f00b009618fcd53b2mr3266528ejc.33.1683141848904;
        Wed, 03 May 2023 12:24:08 -0700 (PDT)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id vv1-20020a170907a68100b00957278cfb2dsm16289336ejc.79.2023.05.03.12.24.07
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 May 2023 12:24:08 -0700 (PDT)
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-50bd37ca954so10171414a12.0
        for <patches@lists.linux.dev>; Wed, 03 May 2023 12:24:07 -0700 (PDT)
X-Received: by 2002:a17:907:98c:b0:95f:969e:dc5a with SMTP id
 bf12-20020a170907098c00b0095f969edc5amr2502183ejc.30.1683141846992; Wed, 03
 May 2023 12:24:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230503023329.752123-1-mcgrof@kernel.org> <ZFKKpQdx4nO8gWUT@bombadil.infradead.org>
 <CAHk-=whGT-jpLRH_W+k-WP=VghAVa7wRfULg=KWhpxiVofsn0Q@mail.gmail.com> <ZFKxl2d+kqYN0ohG@bombadil.infradead.org>
In-Reply-To: <ZFKxl2d+kqYN0ohG@bombadil.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 May 2023 12:23:50 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgUizDLEhvHdM=7yUmdGMB--CGV1ynMSQrd0r7C06ALUA@mail.gmail.com>
Message-ID: <CAHk-=wgUizDLEhvHdM=7yUmdGMB--CGV1ynMSQrd0r7C06ALUA@mail.gmail.com>
Subject: Re: [PATCH 0/2] sysctl: death to register_sysctl_paths()
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: ebiederm@xmission.com, keescook@chromium.org, yzaikin@google.com, 
	j.granados@samsung.com, patches@lists.linux.dev, ebiggers@kernel.org, 
	jeffxu@google.com, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 3, 2023 at 12:10=E2=80=AFPM Luis Chamberlain <mcgrof@kernel.org=
> wrote:
>
> Sorry thought you don't mind a few patches, so ditched the formalities
> for the pull.

So I don't mind patches per se, and when there's a reason for them I
have no problem at all taking them.

The reason is typically something like "let's short-circuit the normal
channels just to get this trivial thing sorted out and we can forget
about it", but it can also be just a practical thing like "I'm
traveling so it would be easier if you'd just pick up this patch
directly from the mailing list".

Or it could be "I don't have a git tree since I'm not a main
developer, so I just send patches".

All of those are situations where I'll happily take patches directly.

But on the whole, when there isn't any real reason to avoid a pull
request, I'd much rather have the full thing with signature and
everything...

               Linus
