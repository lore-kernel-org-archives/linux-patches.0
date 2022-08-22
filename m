Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364644C6C
	for <patches@lists.linux.dev>; Mon, 22 Aug 2022 22:35:20 +0000 (UTC)
Received: by mail-lj1-f182.google.com with SMTP id l23so901671lji.1
        for <patches@lists.linux.dev>; Mon, 22 Aug 2022 15:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=/3Qz2I07qNsEqmUXX8sV18RiE73NXZbJtJL/a6pTzOM=;
        b=oWPtAluKai50SM+qKue2D41Qzws4/k+V5RWd5eefNxz1X9aicH59ZvpfnjRJXMaLQs
         oqxP/yJYA/pA0XUC3IAQ2pMsUZC5KWJCBsJB87xXEHpXJYh3UsodLH0bSrdVTyW8PqVU
         fl7bU/ZoUTjyKr6lYqkht34lemnsdk4xtG++3RabmhF1f8ccW1cPhtNqTlSyiEEcsLzu
         YmlkZJbQ8uLeYszYrnjAf1BiPDqMYPF7w2OYYQuBY8Qlu0DW1tannUkwgTEalQVTDxVO
         5e5PuucVBSjpt4Fd7T9Y4gljaVUNRJApsbm1Vq6Mzh8cdPFYHKbekz+4ISdZpBbhyJKO
         Yejw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=/3Qz2I07qNsEqmUXX8sV18RiE73NXZbJtJL/a6pTzOM=;
        b=Xm31ZQyYAcGrlrQycpbImgAcjuQeBqEBMhdqw8qIgSKtYQg+5LMe2agbPLOEcLHUod
         rYd2TVMoVLy+Zb/cNoupSvSz7ND13L7zovKwBmAOH6BUsq6rPs+h6mkPTgxZTDUngIRp
         PUZYu8gUWq0Y0oLFkrGCxS4ygPmyN9ZuQ0pfvn+Iclwo6EmxMcJFEdSkMK0TGbt8M8pI
         t4WwtIwkNmiaECKgJ/v2jiSVi+pci96YRCHRiIfdYflNVo0H4zFIHsw1cm9VHhZsW6TT
         iexo4/PRnBFazBHW4mHuHTCP3xSYVup+Hs8zmhNcSXJ3OGi6TPRcJnSr9+T/tA1OzeVc
         WQWQ==
X-Gm-Message-State: ACgBeo0pTHSNvXigE1wgU9QklUikufNjoKEix5lAN3P9Py4IQtTapSt1
	cTs/8pIohoMSkc6q4Sfqa2fNBYfuqjEI8eaOI3exyg==
X-Google-Smtp-Source: AA6agR7Tldikzvhh2Bk23FXDw9lViwJukpyd5ZjJCRNzpjlVddMHxOB5z715HFFouGcVhLUk2TreqJEweh3FvxQ/Ygg=
X-Received: by 2002:a2e:9dc5:0:b0:25e:6fa0:1243 with SMTP id
 x5-20020a2e9dc5000000b0025e6fa01243mr6684227ljj.513.1661207718102; Mon, 22
 Aug 2022 15:35:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220805154231.31257-1-ojeda@kernel.org> <20220805154231.31257-24-ojeda@kernel.org>
In-Reply-To: <20220805154231.31257-24-ojeda@kernel.org>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 22 Aug 2022 15:35:05 -0700
Message-ID: <CAKwvOd=y5T9bh4398K+5=82q=vVbkjQQ76KyXLy-qoM2Tph08A@mail.gmail.com>
Subject: Re: [PATCH v9 23/27] Kbuild: add Rust support
To: Miguel Ojeda <ojeda@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Masahiro Yamada <masahiroy@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	patches@lists.linux.dev, Jarkko Sakkinen <jarkko@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Finn Behrens <me@kloenk.de>, 
	Adam Bratschi-Kaye <ark.email@gmail.com>, Wedson Almeida Filho <wedsonaf@google.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Sven Van Asbroeck <thesven73@gmail.com>, Gary Guo <gary@garyguo.net>, 
	Boris-Chengbiao Zhou <bobo1239@web.de>, Boqun Feng <boqun.feng@gmail.com>, Douglas Su <d0u9.su@outlook.com>, 
	Dariusz Sosnowski <dsosnowski@dsosnowski.pl>, Antonio Terceiro <antonio.terceiro@linaro.org>, 
	Daniel Xu <dxu@dxuuu.xyz>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>, Michal Marek <michal.lkml@markovi.net>, 
	linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

 On Fri, Aug 5, 2022 at 8:44 AM Miguel Ojeda <ojeda@kernel.org> wrote:
>
> Having most of the new files in place, we now enable Rust support
> in the build system, including `Kconfig` entries related to Rust,
> the Rust configuration printer and a few other bits.

Cool, I'm finally happy with this patch.

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>

I built and boot tested with CONFIG_RUST enabled, played with
CLIPPY=3D1, and built all of the new make targets for rust.

Thanks for all of the work that went into these series from all of the
authors and Miguel for your determination. Keep it up!

I've left comments on other patches (and I will leave one on
rust/compiler_builtins.rs because I still don't like that approach)
and there may be small cleanups we can do here or there, but I think
we're in good shape to land something and start iterating on it
upstream.  I'll file bugs in your issue tracker for small nits I come
across, but so far, it's been more-so questions.

---

LWN recently demonstrated that most fixes are in relatively younger
code: https://lwn.net/Articles/902854/

An analysis of 0day exploits found in the wild in 2021 showed that for
Android, researchers are attacking drivers:
https://googleprojectzero.blogspot.com/2022/04/the-more-you-know-more-you-k=
now-you.html

Multiple independent reports cite high numbers (70% or more) of memory
safety issues in native code:
https://www.memorysafety.org/docs/memory-safety/

I have colleagues that are developing a microkernel (they then use a
memory unsafe language for their kernel as well :^P ) to move as much
functionality as possible into lower levels of privilege.  It's
interesting and I wish them well, but I also prefer more incremental
approaches to existing solutions, and suspect the way of the monolith
to still give us the best performance.

I learned an interesting word the other day: Corten Steel
from the YouTube channel Practical Engineering (it's a great channel
on Civil Engineering):
https://www.youtube.com/watch?v=3D2RbiCOFffRs&t=3D523s
transcript:

>> I should also note that there are even steel alloys whose rust is protec=
tive! Weathering steel (sometimes known by its trade name of Corten Steel) =
is a group of alloys that are naturally resilient against rust because of p=
assivation. A special blend of elements, including manganese, nickel, silic=
on, and chromium don=E2=80=99t keep the steel from rusting, but they allow =
the layer of rust to stay attached, forming a protective layer that signifi=
cantly slows corrosion.

My hope is that Rust may provide a layer of Corten Steel to the Linux
kernel to help us protect newly written driver code from memory safety
related issues, so that Linux remains the best option for developing
products for the next 30 years. I also suspect it may bring in a whole
new generation of hackers to the kernel ecosystem.  That is my
blessing for Rust in the Linux kernel.
--
Thanks,
~Nick Desaulniers
