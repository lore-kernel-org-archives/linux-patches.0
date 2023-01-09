Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2B05221
	for <patches@lists.linux.dev>; Mon,  9 Jan 2023 21:05:47 +0000 (UTC)
Received: by mail-yb1-f175.google.com with SMTP id 203so9784795yby.10
        for <patches@lists.linux.dev>; Mon, 09 Jan 2023 13:05:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=myEKGg+oMEzcSTRA/yCcbDAjuI7KfOMxWzLnkBmkC7Y=;
        b=KKh3FuuvOpr51yI0LDH/oIme2+Hs5Gwn0hqqM1Ytor7PzuInJ0En8ggSSspfJ30SaI
         kWVKD0FVS+Grls7waVZhg5695Mvi96LjJjrbcZai4x49BmdWU4H9kUraiAuvBCe/B6lC
         fQhAL2CxHFyXCrbxQVdG8bfiJR//TYsTQTIth+GWMygLeUigzr1CoUa+n1pN0r/j9rEi
         0W8czT3zajB6mmnbkM065wnrFZRbKZ1niJVlj9l3omMbz+FMbPftQR5xOcTssawRuVrn
         n7E+2d0zrcx3Gh4MS5tv62NBiv9hHdxxys1C+qekXlRWgOgdaC7n9CdU6eqLFigLJX8q
         VRRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=myEKGg+oMEzcSTRA/yCcbDAjuI7KfOMxWzLnkBmkC7Y=;
        b=w6Fx6OrAUVD4qshrFgXyKOCsUgBoNVlhuFg3n/EzO1gpz7UrbF13Qpbz9mU1hNY1Km
         W3YdV4O7o9Aaw5fJrhmfxTwBMBy+hNbjzQ1sn4gL93aziIcjxMwPLAYxyj811ixiNRch
         QDzBBKbSvKAQmjKCQVRk+4K6ClEM6ecQYPAQqYlvxYRubE6nUwvddho2JrHvP8S/DYR/
         3maxuI+zjlx7ISJpVQRtL8mhaPJ8HLVVPVS3MljxB0nhJyavikg9+XTg9u6stDf0DCZh
         WjfGvL0ZAIw/k2gLMKcALHhar5i/4L1eBCzBVcZVw+WeuAeHOAEZHKEyOGHBtU/f5qle
         sEDQ==
X-Gm-Message-State: AFqh2kqR95vhIlaTyULvXOvoJfVjl+FgUcpOTrIlnGrvZ8jP9/Q4gWQb
	Vfy44FKMJ2mtOfKsqBiK6aNdTQvK6NyJk6dXwzA=
X-Google-Smtp-Source: AMrXdXtxeAq1fcrp0b42A4VMYRMUWp0hLyrkry0m7xghpdIY2iK2OeCAvX/A8wipnJx6npW9eQA3IsQmGU8rhapiN+I=
X-Received: by 2002:a25:1004:0:b0:712:faac:e6b2 with SMTP id
 4-20020a251004000000b00712faace6b2mr6955908ybq.632.1673298346610; Mon, 09 Jan
 2023 13:05:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230109204520.539080-1-ojeda@kernel.org> <CAKwvOdkr6mAdNOkZqGdkosAN6JABHRU3bHg=K8ujjbw2GxEsKQ@mail.gmail.com>
In-Reply-To: <CAKwvOdkr6mAdNOkZqGdkosAN6JABHRU3bHg=K8ujjbw2GxEsKQ@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 9 Jan 2023 22:05:35 +0100
Message-ID: <CANiq72=RJ9NffqJOJLuN6B-DCQgjx1Yp7-sP58q2HchBNpYE=w@mail.gmail.com>
Subject: Re: [PATCH 1/6] docs: rust: add paragraph about finding a suitable `libclang`
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, linux-kbuild@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Jan 9, 2023 at 9:54 PM Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> This is super helpful for me, since I build clang from source and
> would like to use my libclang.so! Thanks for this documentation
> Miguel!
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

Thanks for the quick review Nick!

By the way, I didn't add your Reported-by here because apparently it
is only intended for bug fixes and not features.

Cheers,
Miguel
