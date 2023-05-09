Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A9B3D6A
	for <patches@lists.linux.dev>; Tue,  9 May 2023 08:07:04 +0000 (UTC)
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-50bcd24504eso6368636a12.3
        for <patches@lists.linux.dev>; Tue, 09 May 2023 01:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683619623; x=1686211623;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sefTIBuyPY1tklzs4eZt4f6X1hRT1gQo6nNE62cYqXw=;
        b=RAsdyPEVtcl1EExzGMYbQfdm5z+ZKoRFQ1f/kG7J4e8rJnMYer1P31mOW1C96Hc1MD
         xvQ1lBUrbVZjQPdDgWke++lW0s51PC8Cje+CBTwz+0lijAmKDThmd6z1F5M5LgNQwRQp
         Sa96nUO740TqCB6OsdVxs8z1J0i+i4/zfaKVNOv+w1i5qijNgN01QENvxjYt/5fDbIRu
         V65nwI1dm9D1w+oEf4GK03fMHS4d0uBm/ycFTMrsQGHJPlTL7HEfGIagMAcW5w9N8GKU
         +KTOmfAjngAqdrJw2J4uVvc4CtePTpu3Twnl/SdATYXPzGlg72rS3FfUmIkXXqawvBj+
         dszw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683619623; x=1686211623;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sefTIBuyPY1tklzs4eZt4f6X1hRT1gQo6nNE62cYqXw=;
        b=SrOSacU42SYiLscZcB8jijg+Z66a/+BtEyjGRK2vbTJp+mfXnhVR8ATN/Dy1vK0ctX
         2fDMOam3i0GHUtY/SPgpiSmTZWVjJXvdxdoTvGiLi70lEWJECNWmL77bYwdNKcMn40yN
         Hb3GWnlBNXT2lfOPpp+HEqiQfADEeI35wwFS5mO2Cf+5jShghxu8uctLbtm5h+Fx5+6u
         xkGKLcdSMrx4vz7UF8pUSjIojqB20IXQ5bK7N+luADy/V8iV+c3UNW5pAMmD23+Ddf9R
         PEghiVC09/2n6nfcY9YX/WA/VijEwFjjXJQIou8IQGsh3GAjzeCt4CdxrTuZGZv+fDZa
         pohQ==
X-Gm-Message-State: AC+VfDzABNzPbgIFCu8G8QkK8MXf6Ee33PxaGaQW52FBNAwso++oLwJ0
	TRFfqV831qmM9N5El7qqw38Q/TyxMbVAUgY=
X-Google-Smtp-Source: ACHHUZ5kqoAPjPokTiyAE943lxaftoydddV0k1qApv9fmVkqFVgkZfSBpWevHNlo7ES/Qb9HwMzmv+czd7rl34M=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a50:cd1a:0:b0:50b:c88a:f7cd with SMTP id
 z26-20020a50cd1a000000b0050bc88af7cdmr4762794edi.4.1683619623130; Tue, 09 May
 2023 01:07:03 -0700 (PDT)
Date: Tue,  9 May 2023 08:07:00 +0000
In-Reply-To: <20230508124701.443ba331.gary@garyguo.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230508124701.443ba331.gary@garyguo.net>
X-Mailer: git-send-email 2.40.1.521.gf1e218fcd8-goog
Message-ID: <20230509080700.1608146-1-aliceryhl@google.com>
Subject: Re: [PATCH v2] rust: error: add missing error codes
From: Alice Ryhl <aliceryhl@google.com>
To: gary@garyguo.net
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, linux-kernel@vger.kernel.org, 
	ojeda@kernel.org, patches@lists.linux.dev, rust-for-linux@vger.kernel.org, 
	wedsonaf@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 8 May 2023 12:47:01 +0100
Gary Guo <gary@garyguo.net> wrote:
> On Thu,  4 May 2023 06:48:54 +0000
> Alice Ryhl <aliceryhl@google.com> wrote:
> > This adds the error codes from `include/linux/errno.h` to the list of
> > Rust error constants. These errors were not included originally, because
> > they are not supposed to be visible from userspace. However, they are
> > still a perfectly valid error to use when writing a kernel driver. For
> > example, you might want to return ERESTARTSYS if you receive a signal
> > during a call to `schedule`.
> 
> `include/linux/errno.h` also includes all of `asm/errno.h`,
> which defines EDEADLK - EHWPOISON, which is not included in this patch.
> I feel like these error codes should be added first?

It seems like there are a lot of asm/errno.h files:

$ find . -name errno.h
./arch/powerpc/include/uapi/asm/errno.h
./arch/mips/include/asm/errno.h
./arch/mips/include/uapi/asm/errno.h
./arch/alpha/include/uapi/asm/errno.h
./arch/parisc/include/uapi/asm/errno.h
./arch/sparc/include/uapi/asm/errno.h
./arch/x86/include/generated/uapi/asm/errno.h
./tools/arch/powerpc/include/uapi/asm/errno.h
./tools/arch/mips/include/asm/errno.h
./tools/arch/mips/include/uapi/asm/errno.h
./tools/arch/alpha/include/uapi/asm/errno.h
./tools/arch/parisc/include/uapi/asm/errno.h
./tools/arch/sparc/include/uapi/asm/errno.h
./tools/arch/x86/include/uapi/asm/errno.h
./tools/include/nolibc/errno.h
./tools/include/uapi/asm/errno.h
./tools/include/uapi/asm-generic/errno.h
./include/uapi/asm-generic/errno.h
./include/uapi/linux/errno.h
./include/linux/errno.h

How should I proceed with this? You mention EDEADLK - EHWPOISON, but its
not clear to me which asm/errno.h file I should base this on.
