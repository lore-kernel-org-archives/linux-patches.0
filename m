Received: from conssluserg-04.nifty.com (conssluserg-04.nifty.com [210.131.2.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3C41367;
	Fri,  1 Apr 2022 13:04:53 +0000 (UTC)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47]) (authenticated)
	by conssluserg-04.nifty.com with ESMTP id 231D4TkL023603;
	Fri, 1 Apr 2022 22:04:29 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com 231D4TkL023603
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
	s=dec2015msa; t=1648818270;
	bh=U4tivoNrq6M0EJH3DKmbmPRC4R9x9GkT3H+S8TbYLJc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=WTKWq2NMSHfTrxUlVjLN3HagkNdHTVcnma3lnxXTIWuMlfHyKX7bl2C6SQUqPKMg+
	 8U9B2hIUNGMOmvOMJqoP+Ao+/taWX00tI2T80zg4ctOGeb8uhplU7EB8/ytJkS7mzV
	 pnMfkWxF8QfxI1CG3NnaRILUXkHhYQ1pWBFXcx5BNq+/6VQnkNu3YQWoVNijAm9XIX
	 Jy/GxlkE0hA+PM+kI9ZSLrEvRMWwhWaavAtuoP2NNZ4ZdD6o5ovwLA+3VWHSVQrAvN
	 JapjV1G0Ajdgsc2YN1z/UfaNwVHaETa18v09n3Tj9Kd6EDJojx5HuHnimnAisD63nH
	 nOqDbjz8bTLjw==
X-Nifty-SrcIP: [209.85.216.47]
Received: by mail-pj1-f47.google.com with SMTP id p4-20020a17090ad30400b001c7ca87c05bso5285673pju.1;
        Fri, 01 Apr 2022 06:04:29 -0700 (PDT)
X-Gm-Message-State: AOAM530iZPEjDNFJqRIg2zh6TaLiDS8/0GooUo0MEl1dptuC71XTNuRr
	NpYql2Nqk7p5l9T+kNtpavA2+jBu5+IVdkyXgXU=
X-Google-Smtp-Source: ABdhPJz7VifLyQ80hcB1Aoh/UYgD01w32NA00IyMZnxMSO58Iq1X8IgsvauYHKLcjG96jZqsutGm4BwB9r9evHvT3GY=
X-Received: by 2002:a17:902:b183:b0:14f:c266:20d5 with SMTP id
 s3-20020a170902b18300b0014fc26620d5mr10504064plr.136.1648818269002; Fri, 01
 Apr 2022 06:04:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220330234528.1426991-1-nathan@kernel.org>
In-Reply-To: <20220330234528.1426991-1-nathan@kernel.org>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Fri, 1 Apr 2022 22:03:41 +0900
X-Gmail-Original-Message-ID: <CAK7LNAS6C6Uj9cCQ0o=bYF1F-EVD=VgdR8YYx-1PJc9toX_HZA@mail.gmail.com>
Message-ID: <CAK7LNAS6C6Uj9cCQ0o=bYF1F-EVD=VgdR8YYx-1PJc9toX_HZA@mail.gmail.com>
Subject: Re: [PATCH 0/2] Remove '-mno-global-merge' from KBUILD_CFLAGS
To: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kees Cook <keescook@chromium.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-um@lists.infradead.org, llvm@lists.linux.dev,
        patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Thu, Mar 31, 2022 at 8:46 AM Nathan Chancellor <nathan@kernel.org> wrote:
>
> As discussed at [1] and [2], this series removes '-mno-global-merge'
> from KBUILD_CFLAGS for clang, as it causes warnings for UML, and it
> no longer appears to be necessary, as I do not see any modpost warnings
> with LLVM 11 through 15 with several different ARCH=arm and ARCH=arm64
> configurations.
>
> [1] is currently in the UML tree, destined for 5.18, but it is buggy, as
> I note in [2]. This series is an alternative to [2], which has not been
> picked up yet, so it is based on the current UML tree. If [2] is picked
> up, I can rework the first patch to remove the '-mno-global-merge'
> filtering from arch/um/Makefile; otherwise, this should be picked up in
> place of [2].
>
> I intentionally kept the first patch vague around what fixed the modpost
> warnings, as I am not too sure. [3] seems somewhat likely, but I don't
> think that will revert cleanly on main to test. I think the testing is
> enough to show that the original issue is resolved but I do note that we
> can add this flag back in the architecture specific Makefiles if needed.
>
> Please review and ack as necessary.


Both applied to linux-kbuild/fixes.




> [1]: https://lore.kernel.org/r/20220303090643.241747-1-davidgow@google.com/
> [2]: https://lore.kernel.org/r/20220322173547.677760-1-nathan@kernel.org/
> [3]: https://github.com/llvm/llvm-project/commit/863bfdbfb446adaef767ff514d1f2ffb5d489562
>
> Nathan Chancellor (2):
>   kbuild: Remove '-mno-global-merge'
>   Revert "um: clang: Strip out -mno-global-merge from USER_CFLAGS"
>
>  Makefile         | 4 ----
>  arch/um/Makefile | 4 ----
>  2 files changed, 8 deletions(-)
>
>
> base-commit: 82017457957a550d7d00dde419435dd74a890887
> --
> 2.35.1
>


-- 
Best Regards
Masahiro Yamada
