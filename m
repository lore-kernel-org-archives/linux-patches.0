Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FD633B6F9
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 06:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784701412; cv=pass; b=jYdW0thR/mAfD1Z40tMICQa9miWX7WaVUBtpJ/wScISzwKDepNRYCXT7fc5qPyExF9tG4Rglmkj6IqIug6uDhtIchAf4IMLHDwRCsMcUCnU0OS/4cUxE35xj2oMk/zw6kUy/P2EA4kVTF5wear1SHyUC8yi91uXDZ3Zvy8yjeRI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784701412; c=relaxed/simple;
	bh=Zi0TTWnVRjrxAgsXOkLUFjc66Q3O/SaTw7EJ09/k9t0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o/JgkwCyO3eytv44/v/3V7PljzlOqklhf2dBdUWE3RjPqhG0e+KHln5DYVUYGdIfm3qey0mC/WJTqwSokIEtr74hk9yj4HJYFNNkaNr/nXP0+Lz+7NX0x2NDCe+mWF7jVHuJ9kk/GMlT6fYjU8rHuor2b5tMkGvC8OiCPDgMljk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QUTj1f1+; arc=pass smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QUTj1f1+"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-47f7444576cso2206666f8f.0
        for <patches@lists.linux.dev>; Tue, 21 Jul 2026 23:23:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784701409; cv=none;
        d=google.com; s=arc-20260327;
        b=bCRpfkgVvd94HbG3Xx7Ka+csl1T5HUJjz1lhLrGcFgFU+SNZ6JUS1nZcoctaE0dcV5
         i2eTX81Jfscbq9V1CEcYPd5oJIZwyn8DW/JK43YnjDrTgN40fNDz1nYvNW9GaN6d1Quv
         v9izwvB76HqPLD+8N8Lyxt3hNqy6h7Mouhq3XZfv/2ohlgIVOwPljeauZEzNnA1DL/0C
         u79xVTwkDY6XLTpMM4Ccgi9mfIBqFEty5TdP57T4tz8YNGqjjnsDpwd3svyaX9qGoqct
         JpYTmQNPtH/RDT9QY21klMahm4mu4uQ45rzy3eevU3kMjLuCbPHzOQyIdCLzY/PE6gaR
         LlVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DYM9uk4RjTWm27MB5EyNDXkYKmnCgxdummGBOSonWTA=;
        fh=ZqMDoRIAsBXJwjqhNdsZkE/U1jw/o7dC956bBpTmD6U=;
        b=cS6106o0MdZN+IIU0BvikX+IQDmtraGMcJ1H2HtDzyHqxFMfEC5xI0eJEp2lWCcZVa
         GWOF40JgE5Hh5ZghJd0/euKwzmjcKsiBPOg3rNQ9P5s9tcCvhSshA1d3DPOdKY+z/PfW
         Qbu/aeARIvLTUq/SkZ4gmPQFv2vTMaNgPPwEOjmD6yIuWTUmpQ8eVnz+9CvrJPv6jvG8
         nXSx8XtP22lUlNMv1D866JBSOfyEJVccR7wlJ2HtnEKhaULCRH+/VV48JaHSGQyZhKms
         Iu86HE+e2SF62MZSvi+/Z9VzfLS/laeniTBRgcoEDUcR5aen+5gJzH+dANG81D5dRh2J
         jzNw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784701409; x=1785306209; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DYM9uk4RjTWm27MB5EyNDXkYKmnCgxdummGBOSonWTA=;
        b=QUTj1f1+McKO6HlhdngLZMxfhmqcFag41aUGlD7RmELD7ZT+gQVt5D7ZsQw28/rJqC
         tVFCZOD6Q3S0T97pKi7Nh7yeZ2QeVG2mA2Tujd8tGK3euhRzYvAePN8cOfSvWN8btDLl
         VOVUL5s6WC0yngbfHZsMY1osK29L1yB/ZOIahSRvltnxefq0Fe4Wo87oYS5UCwUcIVlc
         3I6rMpaSRUG5gbDHDUQlUznCgGXasP5xTRMucgt1VcI4sDxgze6wcYUMGF5PnsRn1+76
         P59e+JwlvVd0fuDAI8KETYKsieZuqLKaZ8HS4kEtUbtaxpLfueLAaSqLe6weWcj8+5Zx
         uotw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784701409; x=1785306209;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DYM9uk4RjTWm27MB5EyNDXkYKmnCgxdummGBOSonWTA=;
        b=iD5ZWzYPjMketAZXA5Pd3YmRHJcwxOLzN3MiCylgufy8vP2hwbBOR7BO2GajIq4LV/
         bvROa97JNtWVq6F3fIZRBAQUBzL0t0NsSmD8W3WpIOYI15Z6jb+UwJIISEX/wnZNhdLS
         QNTAyRxC8qHzlnLwuTyLJOWjJlvPc5CzHtJbOQgvESMksSRp+psWhDlA2QkTlelPnaMQ
         MqVbf8bCNg8iZhSmhMhdkg2z8R0WiaVN2+j/F65SVOUp2d1GFxRqxidZu9EHEfxb5Jmu
         nT97cPYZdMY+RbXBYYlJZlPI8aybyZQLR9Bo8OH130hjG6A80D+pGVI8/aZbtRX7bgni
         4pGA==
X-Forwarded-Encrypted: i=1; AHgh+RrYoVNEptHLiMaWnLuGsoiNpAQaiLjAg5u+R2QnCKKPjIOHBzkxcCAnDucH1wM/daJJcprOIGwI@lists.linux.dev
X-Gm-Message-State: AOJu0YzAhtILOedhnqCJDouJyh9g065QKzfYGOth9UGVdv40yLdbCC8g
	0qIbYh04r6u2cgsUKqpfDlggydwZSOZbZB2KL+NCCZ5V2lGN2/De33MowAizoQe0cMN8PkyfLOP
	ofFYJS8zeMqNRYlHD93+344LlloYt3k1ezwGZpo5q
X-Gm-Gg: AR+sD13F6smGmW7YJeyPq2pkEMY7T9ffj9cOkPD1IUA+yxNNnzS1JJ8YhGh4LTk5FUm
	2fGCNu97HcRk7Niyb/dHWaSyec2e0oodHF5a5iriaKxS0eh8FrMGtU7VdpBiiudDYiMZIeDofHU
	WJZPNq6y6TvMYBc4Hi9oFHi5b3p/cTZHEzGmzGGuyYuJTfPUEXT5uN0zJ3mk/DHx+Rl04sYDwLh
	RnnpeBBl24sQMp3kPW/6Z5MSnHMf7PMwxoeI62H//RL3jwISUWjh/FL3yWV4bUplOGHcupU+h3/
	/y/eK3ZrnPQlSSU4
X-Received: by 2002:a05:6000:41c2:b0:475:f100:360c with SMTP id
 ffacd0b85a97d-47f6234003dmr25443546f8f.59.1784701408647; Tue, 21 Jul 2026
 23:23:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260721152424.521567757@linuxfoundation.org> <20260721152425.635542881@linuxfoundation.org>
In-Reply-To: <20260721152425.635542881@linuxfoundation.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Wed, 22 Jul 2026 08:23:16 +0200
X-Gm-Features: AUfX_mxsrSdDyl3_7tKTy7_aH7RAMmHRJQ1nNTAE4JfYa1EUInn7tOh6qeIXNRE
Message-ID: <CAH5fLgjeGuBf3DBSwRDXbWCCc1__ZmkZ4W+5F1iwhAFCc2A25A@mail.gmail.com>
Subject: Re: [PATCH 6.1 0048/1067] rust: Kbuild: set frame-pointer llvm module
 flag for CONFIG_FRAME_POINTER
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Miguel Ojeda <ojeda@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 21, 2026 at 11:08=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.1-stable review patch.  If anyone has any objections, please let me kno=
w.
>
> ------------------
>
> From: Alice Ryhl <aliceryhl@google.com>
>
> commit 191f49f1e38b1c10eb44b0f967c6175c884ef7db upstream.
>
> Due to a rustc bug, the -Cforce-frame-pointers=3Dy flag only emits the
> frame-pointer annotation for functions, but not for the module. This
> means that functions generated by the LLVM backend such as
> 'asan.module_ctor' do not receive the frame-pointer annotation.
>
> This is likely to lead to broken backtraces and may also cause issues
> with ftrace if these features are used with functions generated by the
> LLVM backend.
>
> Thus, use -Zllvm_module_flag to work around this rustc bug if using a
> rustc without the fix.
>
> [ The fix [1] has landed for Rust 1.98.0 (expected release on
>   2026-08-20). - Miguel ]
>
> Cc: stable@vger.kernel.org # 6.12.y and later (flag not available in pinn=
ed Rust in older LTSs).
> Fixes: 2f7ab1267dc9 ("Kbuild: add Rust support")
> Link: https://github.com/rust-lang/rust/pull/156980 [1]
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> Link: https://patch.msgid.link/20260616-frame-ptr-fix-v1-1-dc6b29a631d9@g=
oogle.com
> [ - Adjusted Cc: stable@ as discussed.
>   - Added comment with link to the PR, similar to what we did in commit
>     ac35b5580ace ("rust: arm64: set uwtable llvm module flag for
>     CONFIG_UNWIND_TABLES").
>     - Miguel ]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  Makefile |    3 +++
>  1 file changed, 3 insertions(+)
>
> --- a/Makefile
> +++ b/Makefile
> @@ -904,6 +904,9 @@ KBUILD_CFLAGS +=3D $(call cc-disable-warni
>  ifdef CONFIG_FRAME_POINTER
>  KBUILD_CFLAGS  +=3D -fno-omit-frame-pointer -fno-optimize-sibling-calls
>  KBUILD_RUSTFLAGS +=3D -Cforce-frame-pointers=3Dy
> +# Work around rustc bug on compilers without
> +# https://github.com/rust-lang/rust/pull/156980.
> +KBUILD_RUSTFLAGS +=3D $(if $(call rustc-min-version,109800),,-Zllvm_modu=
le_flag=3Dframe-pointer:u32:2:max)

We shouldn't backport this to 6.1 because -Zllvm_module_flag does not
exist on the rustc version used by the 6.1 kernel.

Alice
