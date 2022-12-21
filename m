Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA701FD2
	for <patches@lists.linux.dev>; Wed, 21 Dec 2022 09:33:33 +0000 (UTC)
Received: by mail-ej1-f48.google.com with SMTP id vv4so35475270ejc.2
        for <patches@lists.linux.dev>; Wed, 21 Dec 2022 01:33:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p2wTCoyTJaDCRjunrGuPfOkSYxMJiO9N+F5ytEjxjC0=;
        b=AVymxci6DMlmWcqzSA/HySpUActoeJdazdUJs2ylU7trPnJOpLtZiN7qw/JAUggDIv
         RIFz0q+9QlvSukHOte/86rI2YZXSwL3pf11vXp0dc+ODoIGAqVfRlTzJvcOPVrnZnDF4
         dRQ0VXABvqEF8Evwt+E+Ljz376UkdSI4yI/crxzrH/XpR3/Qf9W32kvBvVw8AYO6n6BN
         Q7TFLiQSYvARG/vGq8uMyymxMH0rW7hR/Mxl6vEBOOJCD/Vi7nzPFggoRn8gQxvTgkQi
         HJM/Z8api0d63MOvo3l1xgnrByKLFmHLYzLmLj6+g67FxVYt9tKpMx7x4jzbTZERvVGw
         FkKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=p2wTCoyTJaDCRjunrGuPfOkSYxMJiO9N+F5ytEjxjC0=;
        b=bCuhMxjFg22nayk13fcInQsuCY2QHTazDMaoo3P9UNdVXNv0tzmdb5YAQVQMqatmCR
         ZPo9CSYF4k9ClXKuYltRJBGlCzF7RhUVKBtJ+7ulbs8BGmmVY83Nyze/LKx0fDp4Ebnw
         fp8m5lVUQIk2U8C++P2XB2YowBqkFsRPsZPLcJvUFfCIjTAfpg4oO0S9kc3ah4EHj3Et
         wkcJkAYGOl/sAmAjPP3gSy8zx2T5xo43F/O5knLfb/Uh5C+KbKFpwkbX5NvZKS6mRSfb
         qka0X1OuPUDztJiOmpGLT2Bt7Q41UXDkcNNjeZ5Tm3P7XFObccQtejTyuKzmJrW4w5IA
         0NVA==
X-Gm-Message-State: AFqh2kocExAdK2Zr8LLtn2+YB7GtsWmCPeuiXW9e5CT8cg8qO1WZ5L/k
	goDi7sIcha0r6dXLMYUt+0U=
X-Google-Smtp-Source: AMrXdXuuVGFxSQPhSdFdgvC+a3PAlomjPBhTVyLlWwGx4lM13Ee0IJuK+eCYVsNOSxPmiyIlAvnevw==
X-Received: by 2002:a17:907:d109:b0:818:3f54:8df7 with SMTP id uy9-20020a170907d10900b008183f548df7mr983561ejc.2.1671615211783;
        Wed, 21 Dec 2022 01:33:31 -0800 (PST)
Received: from localhost (host-80-180-197-38.pool80180.interbusiness.it. [80.180.197.38])
        by smtp.gmail.com with ESMTPSA id b9-20020a1709063ca900b0081d2d9a0b45sm4124964ejh.186.2022.12.21.01.33.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Dec 2022 01:33:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 21 Dec 2022 10:33:29 +0100
Message-Id: <CP7E4XY0O87Z.1JFRPGL7BMGZ3@vincent>
Cc: <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <patches@lists.linux.dev>
Subject: Re: [PATCH] rust: prelude: prevent doc inline of external imports
From: "Vincenzo" <vincenzopalazzodev@gmail.com>
To: "Finn Behrens" <fin@nyantec.com>, "Miguel Ojeda" <ojeda@kernel.org>,
 "Wedson Almeida Filho" <wedsonaf@gmail.com>, "Alex Gaynor"
 <alex.gaynor@gmail.com>, "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo"
 <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>
X-Mailer: aerc 0.8.2
References: <20221214093451.zdyhmdyxwz73n6pe@imap.mailbox.org>
In-Reply-To: <20221214093451.zdyhmdyxwz73n6pe@imap.mailbox.org>

IMOHO this make sense.

Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>=20

On Wed Dec 14, 2022 at 10:34 AM CET, Finn Behrens wrote:
> This shows exactly where the items are from, previously the items from
> macros, alloc and core where shown as a decleration from the kernel crate=
,
> this shows the correct path.
>
> Signed-off-by: Finn Behrens <fin@nyantec.com>
> ---
>  rust/kernel/prelude.rs | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/rust/kernel/prelude.rs b/rust/kernel/prelude.rs
> index 7a90249ee9b9..917721e791b6 100644
> --- a/rust/kernel/prelude.rs
> +++ b/rust/kernel/prelude.rs
> @@ -11,15 +11,21 @@
>  //! use kernel::prelude::*;
>  //! ```
> =20
> +#[doc(no_inline)]
>  pub use core::pin::Pin;
> =20
> +#[doc(no_inline)]
>  pub use alloc::{boxed::Box, vec::Vec};
> =20
> +#[doc(no_inline)]
>  pub use macros::{module, vtable};
> =20
>  pub use super::build_assert;
> =20
> -pub use super::{dbg, pr_alert, pr_crit, pr_debug, pr_emerg, pr_err, pr_i=
nfo, pr_notice, pr_warn};
> +// super::std_vendor is hidden, which makes the macro inline for some re=
ason
> +#[doc(no_inline)]
> +pub use super::dbg;
> +pub use super::{pr_alert, pr_crit, pr_debug, pr_emerg, pr_err, pr_info, =
pr_notice, pr_warn};
> =20
>  pub use super::static_assert;
> =20
> --=20
> 2.31.1

