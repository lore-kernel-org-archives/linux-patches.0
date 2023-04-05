Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A22B63AE
	for <patches@lists.linux.dev>; Wed,  5 Apr 2023 15:33:12 +0000 (UTC)
Received: by mail-ed1-f44.google.com with SMTP id h8so142113604ede.8
        for <patches@lists.linux.dev>; Wed, 05 Apr 2023 08:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1680708791; x=1683300791;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SiNSMmn4P5V1jwJhNPZuiJRsbJQ57AhnJVTBbX8pgZo=;
        b=UzCI7Vm7G7qwwMWEyfqBZqmho2af7qG7W5q6MNXNH4h9drKkur5x25YgpxlNEMgRJY
         UzfQg/HiriI+5Wq4ZFz+3otXp4n45FnNfjuW7PM7EC4eY9D/ehfZjZfXNO+o0aZXavQV
         +fNmDag49HNiz/AicejkZvHplgZOsYgAd06hE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680708791; x=1683300791;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SiNSMmn4P5V1jwJhNPZuiJRsbJQ57AhnJVTBbX8pgZo=;
        b=hvDWBFaoKUM0Ww/ZhDTu+gds5yyM76+CqmIxyfJkSgJdXNKXV6pY1XY1w8TvIJGmr+
         X1EJaizZV2SgmlX2RZnfyL3bYBnVhqr1IT7RmQkIIg88nrgddUwhj2ZxSHn8uEv7YQL2
         /PyQ154V/OmeVmbLaKQiAB5y3npk5rdlkK8P14fKbcHeDUnR2BqLiGajs1EgGD7u+6xl
         fsytHPItIujiG/Cu+LcBI/0TlGdxfU/UY7XazMlDJ6DJ6RO7HZqblKTgeqmHWg/mHleo
         tkUD2mp5NMpa/K7LtjLZ39M5xvqwK6BHVDqlSH0Hq5t5NWskEPO6kjEMNNMYvWIWf3nF
         1s+w==
X-Gm-Message-State: AAQBX9dxHksv0ghheFA9W+v7nPDtvkkFYRyn4w1lbJEVxCnP3YOO9Zxu
	hTfH5jXPRzZaY9m5ssZPHc8HLoBPpsGW9EzTrJUbTQ==
X-Google-Smtp-Source: AKy350blVFmMBscnED3a05buTLau3U6CTxNhFaqpoShphwjE47obkP545ADQIXmCo9YgrcrQ+bNQJw==
X-Received: by 2002:a17:906:7f98:b0:92b:eca6:43fc with SMTP id f24-20020a1709067f9800b0092beca643fcmr3652422ejr.64.1680708791007;
        Wed, 05 Apr 2023 08:33:11 -0700 (PDT)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id gv19-20020a1709072bd300b00931db712768sm7507547ejc.4.2023.04.05.08.33.10
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 08:33:10 -0700 (PDT)
Received: by mail-ed1-f47.google.com with SMTP id eg48so141974821edb.13
        for <patches@lists.linux.dev>; Wed, 05 Apr 2023 08:33:10 -0700 (PDT)
X-Received: by 2002:a17:907:2075:b0:947:72cd:9325 with SMTP id
 qp21-20020a170907207500b0094772cd9325mr1890350ejb.15.1680708395703; Wed, 05
 Apr 2023 08:26:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230405022702.753323-1-mcgrof@kernel.org> <20230405022702.753323-6-mcgrof@kernel.org>
In-Reply-To: <20230405022702.753323-6-mcgrof@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 5 Apr 2023 08:26:18 -0700
X-Gmail-Original-Message-ID: <CAHk-=whH+OsAY+9qLc9Hz+-W8u=dvD3NLWHemOQpZPcgZa52fA@mail.gmail.com>
Message-ID: <CAHk-=whH+OsAY+9qLc9Hz+-W8u=dvD3NLWHemOQpZPcgZa52fA@mail.gmail.com>
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

On Tue, Apr 4, 2023 at 7:27=E2=80=AFPM Luis Chamberlain <mcgrof@kernel.org>=
 wrote:
>
> Sometimes you want to add debugfs entries for atomic counters which
> can be pretty large using atomic64_t. Add support for these.

So I realize why you use atomic64, but I really suspect you'd be
better off with just the regular "atomic_long".

This is not some debug stat that we care deeply about on 32-bit, and
"atomic64" is often really really nasty on 32-bit architectures.

For example, on x86, instead of being a single instruction, it ends up
being a cmpxchg loop. In fact, even a single atomic read is a cmpxchg
(admittedly without the need for looping).

And yeah, I realize that we don't have a "atomic_long" debugfs
interface either. But I think we could just use atomic_long for the
module code (avoiding all the horrors of 64-bit atomics on 32-bit
architectures), and then using just 'var->counter' for the value. It's
not like the debugfs stuff actually does any truly atomic updates.

So something like

        debugfs_create_ulong(... &val->counter ..);

instead of

        debugfs_create_atomic64(... &val ..);

Hmm?

I dunno. I just think this is not something that may be worth
introducing a new thing for, when it is *so* painful on 32-bit, and
doesn't seem worth it.

                   Linus
