Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E1E7463
	for <patches@lists.linux.dev>; Wed, 17 Aug 2022 20:43:47 +0000 (UTC)
Received: by mail-io1-f44.google.com with SMTP id h78so6332087iof.13
        for <patches@lists.linux.dev>; Wed, 17 Aug 2022 13:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=flLMMg4lOTziu7pnj4Cz7kZJFJokj6zHiYI6/zZRrzU=;
        b=UktBwupl2oAOo+aFSE09VhcRhVk896RgC8L7XC9KPp/PQ6q0btqYt6fEPAQDeETP2J
         RCFAzKrb84LlswloBcCT+T0GJ1Bbnrz1VuPnoJnrbhG+aP3vVp/LGpMHr1jLxd9WlDNQ
         Np8VkFiFKmz0iNh+UFprCMxsoR3GBAF7XxY2UL8kLvymz+dstqpFWTfm/LqzQVbm4AKZ
         6g66lD8Li9H5QMHUjNnF8R+Lm326raJ4NvaSnTM65sBpIL3IdZhM6N37VRZIrZsTf+5u
         bXvN/rBbS6oHislsHY4q/obX5Hw++iVyFjK2Ry0tJE6dMkPH0lBOXbnXabSwFmAjWnfl
         BIEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=flLMMg4lOTziu7pnj4Cz7kZJFJokj6zHiYI6/zZRrzU=;
        b=to2GXnB5cAJm4RQ59gqPz04PDJ7vYL/yRCtcczoNgwPxIIYE1ultzWE13iehvnwruq
         ys70kIh3ogJDtncZ0XPrHIka2/NKzIwPc3O8U3x9y3YoXE+fX6a4IncDZsraLa+CDMP4
         wL1n+XpYkdcDlxp5dJH/8FtdKeMZb6Yiav+cWWgefbHu0GxGBuV4ThY6ejY+S0qLqNOM
         OYr7tluZyrAlGRhdeNXYp6Le21Gk4nIWwX0A204ilJjs1YN5tD4AOQ69K5++iz10CyGR
         mBEGJWZZoiY/EWoh0DQBBEyDdqt6PDDN2bmbCWowPuZ2yFDBkXnc0wsFCEy9BTal2fS5
         pYXQ==
X-Gm-Message-State: ACgBeo13xmONBd95uTXSpGKMqtQaAqZ4s0cevTf4YcAHJZ7TK0nXuQOl
	3J7glR8etsCa0TgoZgi8mR2AFJSJSRtzuAluDEU=
X-Google-Smtp-Source: AA6agR49EF/XbMYGpebUExo2BR0Oz46oUhF4XphalGp81w0rra22T0ilBDpuxcmwUdmlTlMczJECsE6m1Tg1wbrxSIo=
X-Received: by 2002:a05:6638:2194:b0:342:7ed1:66f with SMTP id
 s20-20020a056638219400b003427ed1066fmr9226jaj.186.1660769027186; Wed, 17 Aug
 2022 13:43:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220805154231.31257-1-ojeda@kernel.org> <20220805154231.31257-28-ojeda@kernel.org>
 <202208171328.8C3541A@keescook>
In-Reply-To: <202208171328.8C3541A@keescook>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 17 Aug 2022 22:43:35 +0200
Message-ID: <CANiq72ki+W_0EOUS3JR_EAFdqMdYHizguajDswmfMUwSC1QxaA@mail.gmail.com>
Subject: Re: [PATCH v9 27/27] MAINTAINERS: Rust
To: Kees Cook <keescook@chromium.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	patches@lists.linux.dev, Jarkko Sakkinen <jarkko@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@google.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Aug 17, 2022 at 10:28 PM Kees Cook <keescook@chromium.org> wrote:
>
> Reviewed-by: Kees Cook <keescook@chromium.org>

Thanks a lot for all the reviews Kees!

In case you are wondering, I removed your previous Review of this one
too since we got some new `R` lines. I guessed you would have been OK
either way given new names are trivial, but it did change a fair % of
the patch, so I played it safe... :-)

Cheers,
Miguel
