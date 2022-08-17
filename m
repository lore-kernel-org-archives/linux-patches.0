Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BCE7463
	for <patches@lists.linux.dev>; Wed, 17 Aug 2022 20:40:50 +0000 (UTC)
Received: by mail-il1-f178.google.com with SMTP id i18so6325697ila.12
        for <patches@lists.linux.dev>; Wed, 17 Aug 2022 13:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=D7+PP+1VFVB5t/XZKXqn6MijouyQ2RbiiwpNQ7fWOz0=;
        b=GxR10IqzvjdBL/BaxMHXfPFWlt/83Q820CnMlzfL/hSA6gIjg68H5JxBTAxm/lIQ9V
         0i7QhTrDa78ijLCS/8IiS1qk+BXnh1u3ZfTWADKknLCpzJTkMTnshCMrM8bbU6lICwwb
         RCQuKPTUOu0D8Cgy371UL8SU/k/ojDGxNm5xleYWISXyMRA0ftmiHl/vFGUl4fMwVUiE
         z1H1UPyZeJQ9Tlv2v8NclqCye8Gg2GUrr30eChzEFN/qUfvS5j+sg9zCz0e1pgLG8XrE
         +2vNeyK8ULLM29Av+5YMtJVAXSvHFvwfYwHRC1ylSLIReEpCYtUq4ABsIR3S2vaqOt6g
         34cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=D7+PP+1VFVB5t/XZKXqn6MijouyQ2RbiiwpNQ7fWOz0=;
        b=UJK4eNiu5wLFa7k0b1N135pNjB/o0HGxR611nYMbFJjP2AkQzbxskZi7mdG5HovjGZ
         o9kLfuZIv5mkTDFRlBhfO34sJqjp3Veqf+5oaMdtlHRIDvgRusZEdtDBW5pEugrekSRN
         J554Fygwsw8vvzAqav6gTie8RZf7LaycruJoB8TAl/Gx/i4FxZqzt/I/xVo7nTm0KGBy
         DAjpYgnU2NMgxgcyri2vd1UMGaj2vw5lG22aj1hkVycZ/+dyf2CCoFngCgNuSXubePyB
         ShEan3/jEDFJhqSVp3L3ir9X6J2LVicOtCd8AajFWDQ7AjX60UPv+GmqqKzqAKzNjf/3
         gSaw==
X-Gm-Message-State: ACgBeo3BHqpfizH4Su4aidv2NZtWkL6BMnlDmvzEdF7gWSAzMFzjs+RO
	JiwucmzrdAPzspV7qMgzcFyEwFwtuqej8VbVCgw=
X-Google-Smtp-Source: AA6agR6Pkl8a8I0NGhaSmqIm0OjcWxsxxYn1fA+Kt0gIAQtc7Bo4Uukr+9wWczkLepZwrG+Tt2qdF9cNf7ysNCWyoII=
X-Received: by 2002:a92:cd8f:0:b0:2df:ff82:2e5f with SMTP id
 r15-20020a92cd8f000000b002dfff822e5fmr12835073ilb.72.1660768849569; Wed, 17
 Aug 2022 13:40:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220805154231.31257-1-ojeda@kernel.org> <20220805154231.31257-21-ojeda@kernel.org>
 <202208171317.F5D57135@keescook>
In-Reply-To: <202208171317.F5D57135@keescook>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 17 Aug 2022 22:40:38 +0200
Message-ID: <CANiq72nzOQSd2vsh2_=0YpGNpY=7agokbgi_vBc5_GF4-02rsA@mail.gmail.com>
Subject: Re: [PATCH v9 20/27] scripts: add `rust_is_available.sh`
To: Kees Cook <keescook@chromium.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	patches@lists.linux.dev, Jarkko Sakkinen <jarkko@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@google.com>, Finn Behrens <me@kloenk.de>, 
	Miguel Cano <macanroj@gmail.com>, Tiago Lam <tiagolam@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Aug 17, 2022 at 10:18 PM Kees Cook <keescook@chromium.org> wrote:
>
> I think the min-tool-version.sh changes from patch 23 should be moved
> into this patch.

Yeah, it calls into that script with a "rustc" argument, which doesn't
work if somebody happened to run it by hand, so this makes sense.

However, the intention was to move each "big" new file into their own
patch to make a smaller Kbuild one (and only do that "new file"
additions in each patch), and then finally do all the modifications
and enable the Rust support in the Kbuild patch (which has the callers
into this script). Also the script is not intended to be called
directly anyway (since you need the Make environment, but you
definitely can), there is a Make target to help with that.

Hopefully that explains the logic behind the arrangement of the
patches, which was to make the patches as simple as possible. I am
happy to rearrange if you think it is more understandable that way.

Cheers,
Miguel
