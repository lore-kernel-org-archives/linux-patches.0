Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6830879FB
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 18:22:14 +0000 (UTC)
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-382f0906929so23280917b3.10
        for <patches@lists.linux.dev>; Mon, 14 Nov 2022 10:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dJhdvZIL4dk79Y3gG/NcL+fwogDMvYUZLhwwyEHygOE=;
        b=Ghk/bDvtvykckld0AKbfuQzvD+2Rlsr0agjZxZ6786dart7MCb+IoxAaz28aIKu0r5
         jU97rIgPPMsw6Xh0uI5w5qZ92ZLTVqjNaIi7cJWzQl/I2e+gAGjwPHzJ7RsGpj0DvxM8
         XJHgreVIm1xQeI9KLSWdPnka/7A+NFJOVBhXLVlNFCAy5VLSr3pg/2l+fxeF+hZc8FAH
         NIGBtwWBwrc6ZKE4gkCKz3o5zebil7r6zm4f7mR24MurTdNhOmDEAvLJce4GU5aQI3WO
         hEn8oEo5kfR+AMZ8hE1FYEFlm63aAsld6rL57UYGH6zL0eAbmZRgM6aDGbHcXIGJjx4j
         pDnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dJhdvZIL4dk79Y3gG/NcL+fwogDMvYUZLhwwyEHygOE=;
        b=6KFcMtvsvOIdWqWx6/7ljtu8dTxhmsi3tOJgB/btiRJi5UUKgVfWmzvnaRTKrPdXd7
         rmCy+o/hvHcaov6fYUyc6b8y0/xlwP8NxOFqAJ6ufObY2CN0O5V1rjylC4DEmUe/KARE
         kHCWMCsMlM5smD7LUjuLsogCK3nOteZTNlHXO7Pwby2jYdi9bQeRrBFnD1QpCXyOMvbP
         Ztc04sgP3UDdnHyeE6RexhhxlAChD5EFnMZQLZ+WAhEEyefyqKLBrD+WBN129sijch5m
         r/SA2rj81+8ZHq9RgBjI0KBK6Jb18l+CZ3ZrvvgSJudp0TTxvzHcEILpZ02q8k1nqQUh
         MvQA==
X-Gm-Message-State: ANoB5pkh/9A4ptgXyMqRK88mHCpR+xw+8ksS5kO3HlydTZu6LOAtj+2e
	ykGQ+fnafBdryr9tsuQnTOfOtmMPbi3ehNWEXq0=
X-Google-Smtp-Source: AA0mqf5pgXx9393AjH3cG63sp/dEA3pT6uJPHn4NX8ei4qCoMqb/LVkaMds9N2NrFEeR1h/+POHFoFhG8AHgfc9Gv6o=
X-Received: by 2002:a81:7912:0:b0:342:4d19:c7b with SMTP id
 u18-20020a817912000000b003424d190c7bmr13767068ywc.67.1668450133388; Mon, 14
 Nov 2022 10:22:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221110164152.26136-1-ojeda@kernel.org> <20221110164152.26136-26-ojeda@kernel.org>
 <Y3JQ8qsaV/DN3OJ7@liuwe-devbox-debian-v2>
In-Reply-To: <Y3JQ8qsaV/DN3OJ7@liuwe-devbox-debian-v2>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 14 Nov 2022 19:22:02 +0100
Message-ID: <CANiq72ktW2=JCi3YzyrAd=_RioaWGZSyDusMU2f92_aL3tgvUA@mail.gmail.com>
Subject: Re: [PATCH v1 25/28] rust: add `build_error` crate
To: Wei Liu <wei.liu@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Mon, Nov 14, 2022 at 3:30 PM Wei Liu <wei.liu@kernel.org> wrote:
>
> a const function `build_error`
>
> Without this I read it as a "normal non-const function".

Sounds good to me, especially given the sentence that goes after that.

(I think "function" does not imply one or the other in principle. To
me, `const` ones are normal too, in the sense that they can be used as
any other function.)

> I can work out what the code does, but I also happen to know what Rust's
> const means and its behaviour in non-const context. Other kernel
> developers may not. Even so the description is a bit difficult for me to
> parse.
>
> Maybe a few sentences about const and its behaviours can help?

Not sure if we should explain language details in the documentation of
particular functions. But I agree this case is a bit special.

What about linking the Rust reference/book/... (so that those terms
are clickable when rendered)?

Thanks a lot for the reviews, Wei!

Cheers,
Miguel
