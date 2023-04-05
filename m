Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137C16FDB
	for <patches@lists.linux.dev>; Wed,  5 Apr 2023 16:23:29 +0000 (UTC)
Received: by mail-ed1-f47.google.com with SMTP id b20so142472267edd.1
        for <patches@lists.linux.dev>; Wed, 05 Apr 2023 09:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1680711808; x=1683303808;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VQpmkrukxD+353BntikJkYNT/bA711Va7HsLI05KtRc=;
        b=FjnKWTDIOS2agZ2Zz69Oen4jctfF+GvAijQFtu/3M1OpICzDW9YS5ABpVSfKa4sjxg
         wjeW8F06X634Zbp+tIacEOlpbOZL7m7VZEfri9dJBI0YexD+ZfOfhLah4NrM0t6Brmnd
         3xbOZpRtilkDw/isIC8RJocwoeL4qZ8voDIc0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680711808; x=1683303808;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VQpmkrukxD+353BntikJkYNT/bA711Va7HsLI05KtRc=;
        b=PxXsnrbKL6zlySJrrLRRFX0xCc3pTAmss5T2N5ehb8YAqJpRZln9uHAtmfP6nWnFB3
         SljdMvQ+Ir5afKezE2rH+wZEsvzINIOBpMtTxVze74xahEJxTXjX2KzsjgXGeae1ntWj
         ry0jXbKnjqc6QPCWFZL9U9kCLJPQ3/5KOhOGksYLqJNtxkB+Nvt3KVfrtzJoMbIQxrfc
         hAi991W+x9HAdw0KUh/TT5M4tvtQ4k8XAVpyaATOAc4YLE77Kfea0Ns7tJKE8mOYZqWI
         1LarMBsokxsZ+qSf/57HiobVC1u7jQkcPidHmohL2T1s1ENcz74g8wg9tZ6XEYrt1DRM
         dGUA==
X-Gm-Message-State: AAQBX9dAXUFa0IFyZz3+iVztJJJDvRw6dvN+kqcuDX5bKmtxE8MvfZyg
	UxBufNuPnwJ6nKfTKBzvscHA6PyLiDtdjDaUuvEKfg==
X-Google-Smtp-Source: AKy350ZaYQpz1v9ArIrO6+lWyscWBW+BRRmifM74XahDU6Ry0iVVd+BsBE+vcjJAS0HjtvWJGkobnQ==
X-Received: by 2002:a17:906:d10c:b0:8b1:7b10:61d5 with SMTP id b12-20020a170906d10c00b008b17b1061d5mr3710713ejz.33.1680711807832;
        Wed, 05 Apr 2023 09:23:27 -0700 (PDT)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id j10-20020a17090643ca00b0092f38a6d082sm7486169ejn.209.2023.04.05.09.23.26
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 09:23:27 -0700 (PDT)
Received: by mail-ed1-f47.google.com with SMTP id eg48so142360320edb.13
        for <patches@lists.linux.dev>; Wed, 05 Apr 2023 09:23:26 -0700 (PDT)
X-Received: by 2002:a17:906:7e05:b0:932:da0d:9375 with SMTP id
 e5-20020a1709067e0500b00932da0d9375mr1892812ejr.4.1680711806400; Wed, 05 Apr
 2023 09:23:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230405022702.753323-1-mcgrof@kernel.org> <20230405022702.753323-6-mcgrof@kernel.org>
 <CAHk-=whH+OsAY+9qLc9Hz+-W8u=dvD3NLWHemOQpZPcgZa52fA@mail.gmail.com>
 <ZC2cC+I1KTyD8UcC@bombadil.infradead.org> <ZC2dtI02ZIbjte2l@bombadil.infradead.org>
In-Reply-To: <ZC2dtI02ZIbjte2l@bombadil.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 5 Apr 2023 09:23:09 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiGhHk4u2RRZmJinA4Apb47pXXJPW9cOZ_2-yUqOvaC7Q@mail.gmail.com>
Message-ID: <CAHk-=wiGhHk4u2RRZmJinA4Apb47pXXJPW9cOZ_2-yUqOvaC7Q@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] debugfs: add debugfs_create_atomic64_t for atomic64_t
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: david@redhat.com, patches@lists.linux.dev, linux-modules@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, pmladek@suse.com, 
	petr.pavlu@suse.com, prarit@redhat.com, gregkh@linuxfoundation.org, 
	rafael@kernel.org, christophe.leroy@csgroup.eu, tglx@linutronix.de, 
	peterz@infradead.org, song@kernel.org, rppt@kernel.org, dave@stgolabs.net, 
	willy@infradead.org, vbabka@suse.cz, mhocko@suse.com, 
	dave.hansen@linux.intel.com, colin.i.king@gmail.com, jim.cromie@gmail.com, 
	catalin.marinas@arm.com, jbaron@akamai.com, rick.p.edgecombe@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 5, 2023 at 9:11=E2=80=AFAM Luis Chamberlain <mcgrof@kernel.org>=
 wrote:
>
> Oh but I don't get the atomic incs, so we'd need debugfs_create_atomic_lo=
ng_t().

No, you misunderstand what I meant.

Just use "atomic_long_t" in the module code.

But then the debugfs code should do

        debugfs_create_ulong(... &val->counter ..);

to expose said atomic_long values.

No need for new debugfs interfaces.

Because "atomic_long" is just a regular "long" as far as plain
read/set operations are concerned - which is all that the debugfs code
does anyway.

So I think you can do something like

  atomic_long_t total_mod_size;

   ...

  debugfs_create_ulong("total_mod_size",
       0400, mod_debugfs_root,
       &total_mod_size.counter);

but I didn't actually try to compile that kind of version.

(I think "counter" is actually a _signed_ long, so maybe the types don't ma=
tch).

               Linus
