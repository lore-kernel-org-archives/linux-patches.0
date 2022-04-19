Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82181374
	for <patches@lists.linux.dev>; Tue, 19 Apr 2022 16:42:04 +0000 (UTC)
Received: by mail-lj1-f182.google.com with SMTP id n17so16330364ljc.11
        for <patches@lists.linux.dev>; Tue, 19 Apr 2022 09:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6P1qWvF3V5GecgjWCwMHmxXvgO8LhvNSrvaeOrIx0no=;
        b=bOi7JrsKqW6RMlRYZ9yUMtpdFOoida/a9exETF7P4zUXYy8YfeeMmKRQoxSP+cBkH6
         o6mLBuE//QNcdO3jlJqz53BsfpGwllgT4Tgv3ikKYQ6nO5XfIxIcZHWoBpkfZxheIysG
         An/Fl3+TnkBLB8svtmOlHuNDaqXA1rMz+XTXE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6P1qWvF3V5GecgjWCwMHmxXvgO8LhvNSrvaeOrIx0no=;
        b=geFwiC8cT5ckpe+xH7s4RWS3VjbkWSLqNw3oDKdcu80nxkmcv+Vxee0oJFbMd9O4dn
         yMgvkGYDdgEybWLpfa9P/wal72AkDDYji3jEHaKMTJtVtuUtrrejYdAZ+hY7GuM7IUGc
         FH0iIvFfpFjB2YNyh9oXFsEPtR+oYXenKG90ItTbtSfWsvdmq+hLwGhPGyiZdrwqeFU0
         JVe5GM8mTXhl/PBh7XJ+BVCq52FmYVx0w0djwpRcLO1BflTittDU0zgKZCQPWEXT/o/f
         nuFc/f6AjYRpGrbFIOuKzJwfnZqNdtXLuEB7+gzTOiYwiI60l7Udk5YCpJ9C2Z/6llC9
         QjWQ==
X-Gm-Message-State: AOAM531CO+3EICLiW0W1Lr02gElJui1JyzyrUVyC4I2bgr0OrEqbe3Sq
	Ddfy5lTYCcje9v0THtOUc4ZSiPwcR/o0GOBHmtk=
X-Google-Smtp-Source: ABdhPJx9j74iEpSTMWslY7uW6YvfWfCNQIjGHT3OFuYHQOSckOrdFxeNm96/sePz08dqujtzl0/IpA==
X-Received: by 2002:a05:651c:1994:b0:24d:d4b9:516c with SMTP id bx20-20020a05651c199400b0024dd4b9516cmr402711ljb.278.1650386522445;
        Tue, 19 Apr 2022 09:42:02 -0700 (PDT)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id a31-20020a05651c211f00b0024b6d5b5fcbsm1488153ljq.3.2022.04.19.09.41.59
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 09:42:00 -0700 (PDT)
Received: by mail-lf1-f44.google.com with SMTP id bu29so30479642lfb.0
        for <patches@lists.linux.dev>; Tue, 19 Apr 2022 09:41:59 -0700 (PDT)
X-Received: by 2002:ac2:4203:0:b0:448:8053:d402 with SMTP id
 y3-20020ac24203000000b004488053d402mr11323216lfh.687.1650386519338; Tue, 19
 Apr 2022 09:41:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAHk-=wh=Mu_EYhtOmPn6AxoQZyEh-4fo2Zx3G7rBv1g7vwoKiw@mail.gmail.com>
 <Ylpj9of+CP4ipDtm@zn.tnic> <29b9ef95-1226-73b4-b4d1-6e8d164fb17d@gmail.com>
 <Ylr8rR+LHQ1uGL47@zn.tnic> <CAHk-=wgt=H-LXpXpsqS+nYQU4p+jW4izGs5RVS6k9uj0g_J2VQ@mail.gmail.com>
 <Ylsx5PwyUPOainHa@zn.tnic> <YlxtTNFP58TcUHZQ@zn.tnic> <CAHk-=wiB8GXu84rChFvUZoZDfp6LnTuLruc0xoxj=mStmK-b1Q@mail.gmail.com>
 <Yl06PWVgeZplboXV@zn.tnic> <CAHk-=wh3ZFnUs+k0w3yTth8Kiy8xK45jo2VaT7x_-VFFMBVZiw@mail.gmail.com>
 <Yl5+DCfQmG5C3BHf@zn.tnic>
In-Reply-To: <Yl5+DCfQmG5C3BHf@zn.tnic>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 19 Apr 2022 09:41:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi1iQXd3SSoyWZebdxdK3gFCVGq9q=4pwq3rON3BYZJkA@mail.gmail.com>
Message-ID: <CAHk-=wi1iQXd3SSoyWZebdxdK3gFCVGq9q=4pwq3rON3BYZJkA@mail.gmail.com>
Subject: Re: [patch 02/14] tmpfs: fix regressions from wider use of ZERO_PAGE
To: Borislav Petkov <bp@alien8.de>
Cc: Mark Hemment <markhemm@googlemail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>, patrice.chotard@foss.st.com, 
	Mikulas Patocka <mpatocka@redhat.com>, Lukas Czerner <lczerner@redhat.com>, 
	Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, 
	Hugh Dickins <hughd@google.com>, patches@lists.linux.dev, Linux-MM <linux-mm@kvack.org>, 
	mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Apr 19, 2022 at 2:17 AM Borislav Petkov <bp@alien8.de> wrote:
>
> Yap, and I reused your text and expanded it. You made me look at that
> crazy DEFINE_EXTABLE_TYPE_REG macro finally so that I know what it does
> in detail.
>
> So I have the below now, it boots in the guest so it must be perfect.

This looks fine to me.

Although honestly, I'd be even happier without those fancy exception
table tricks. I actually think things would be more legible if we had
explicit error return points that did the

err8:
        shrq $3,%rcx
        addq %rax,%rcx
err1:
        xorl %eax,%eax
        RET

things explicitly.

That's perhaps especially true since this whole thing now added a new
- and even more complex - error case with that _ASM_EXTABLE_TYPE_REG.

But I'm ok with the complex version too, I guess.

                   Linus
