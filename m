Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D0AA464
	for <patches@lists.linux.dev>; Thu, 17 Nov 2022 22:51:49 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id d13-20020a17090a3b0d00b00213519dfe4aso3395505pjc.2
        for <patches@lists.linux.dev>; Thu, 17 Nov 2022 14:51:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VsJCHrbdA/8xBK+FwpkLQd0Vpot4PJyQ0+YuLOFb5ug=;
        b=pTjz7gNdBT8RN8+RtgT+xL5auev0FvBO9YOSaU3P9JChlH/BQwf5eeAUx8Gh5cZxfR
         48JPZw1PcZRczw33xA5iwcCyfd2dmgyCt0R0XH84aSGkd+rTJllIOnyLeXLFMzRHmXh0
         J4S7Hk5NCsCtUfHMamYLPy0hTzphxTpDv02auUqn7j/C6zWTXBK3dqeUEvBry6TX214/
         7jNtRRvSxJSkmvQI72pj38bIgZtyg+6kveSDejcZk5vbFIelQHCygf5GV60/9KMURAHI
         WMMViEpP1m3d5aPSjwxu+vHQk8qyBTkcFO7DxWYKVq+v1Z0Ily3QrigxC6OK2Kj4dLCD
         Jjng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VsJCHrbdA/8xBK+FwpkLQd0Vpot4PJyQ0+YuLOFb5ug=;
        b=4qw0DqNBmiXhpwCV8twNpljlZgdnNlH+G35u7mFpFPibkJjooa/6gUdfvZn2+LE534
         qfoJ2iycNQj09vg8gPQJw7Y3uAA3dXBJJ5vJfwLXh7wgiBPOFDUn6bC8Py2Dj2h5vMZr
         WB9DgIx856ZDauhzTV0B1iYKdWkbH5+bzosbUuoAPAeD++5+Ff9SUaMe+PlfTbRF4UeI
         JGH0xRazq5GOkm9oQtQjBM62lq0FVk3SfumYaiDzd+87slg6VDDkg3GdsszU33elGpe+
         RQWF2RDcBd/hT23ehHZLtYR0+H9Gy+bNdEgzTroXRlk92jcDwQKy8BRI5CYcCv5BxYvC
         nc+Q==
X-Gm-Message-State: ANoB5pkixT34+28Frs/mE1wN2OmA8f0pMDPbNqzouZk0HXcYXX4VNiUH
	uPLXRxbN2Uc26NckBc63GydhD6rrbgskVKTujjK/Mg==
X-Google-Smtp-Source: AA0mqf67vPPzluRI+XlzkgbR8xb3UntQ1E82cFrLyRnnBgAER6CWMYERHA+OL7EI9rQe7Fxda54moa8+K/I1TRjN1qQ=
X-Received: by 2002:a17:90a:ab84:b0:213:343:9873 with SMTP id
 n4-20020a17090aab8400b0021303439873mr10841158pjq.102.1668725509260; Thu, 17
 Nov 2022 14:51:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221114225719.1657174-1-nathan@kernel.org> <CAKwvOdn67r3ZYb5XZkae3i5797GGV3=8=nLC7kT2d4On3OEm5A@mail.gmail.com>
 <Y3aMxfhBw9YsWiKr@dev-arch.thelio-3990X>
In-Reply-To: <Y3aMxfhBw9YsWiKr@dev-arch.thelio-3990X>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Thu, 17 Nov 2022 14:51:37 -0800
Message-ID: <CAKwvOdmYO0_m3+uWHe_C=7y1zgePQzc27Kd6Pep7Ja_pgbNPZw@mail.gmail.com>
Subject: Re: [PATCH] ARM: Drop '-mthumb' from AFLAGS_ISA
To: Nathan Chancellor <nathan@kernel.org>, Sylvestre Ledru <sylvestre@debian.org>
Cc: Serge Guelton <sguelton@mozilla.com>, Russell King <linux@armlinux.org.uk>, 
	Arnd Bergmann <arnd@arndb.de>, Ard Biesheuvel <ardb@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
	"kernelci.org bot" <bot@kernelci.org>, Sylvestre Ledru <sylvestre@mozilla.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Nov 17, 2022 at 11:34 AM Nathan Chancellor <nathan@kernel.org> wrote:
>
> On Thu, Nov 17, 2022 at 11:15:09AM -0800, Nick Desaulniers wrote:
> > On Mon, Nov 14, 2022 at 2:58 PM Nathan Chancellor <nathan@kernel.org> wrote:
> > >
> > > Fixes: 1d2e9b67b001 ("ARM: 9265/1: pass -march= only to compiler")
> > > Link: htps://salsa.debian.org/pkg-llvm-team/llvm-toolchain/-/blob/17354b030ac4252ff6c5e9d01f4eba28bd406b2d/debian/patches/930008-arm.diff
> >
> > Would you mind using
> > https://salsa.debian.org/pkg-llvm-team/llvm-toolchain/-/blob/snapshot/debian/patches/930008-arm.diff
> > as the link instead? The link on this commit message is a diff against
> > llvm-14, not ToT which is currently llvm-16; the context is quite
> > different as the logic moved source files completely.  Though it does
> > look like Sylvestre has not yet cut a 16 branch for debian's patches.
>
> I would rather use an actual hash to reduce the risk of the link going
> stale from either a branch rename or file rename/removal. I can use a
> hash from the snapshot branch instead, if that would work for you?

It doesn't matter much to me; I trust your judgement; you pick.
Perhaps that depends if the snapshot branch has stable SHAs or whether
they change over time? Maybe Sylvestre can comment on that.
-- 
Thanks,
~Nick Desaulniers
