Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA87847C
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 20:09:11 +0000 (UTC)
Received: by mail-ej1-f47.google.com with SMTP id i10so22404929ejg.6
        for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:09:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MdJG0hGFUyyCI91ddj8JC9nYTc4V0N35yzoPYsarpcg=;
        b=if1cvVB7kZ3p6IsI1icI+itclbcxzY0WdmaPbBN6tPazOVZ0CokbOi0SnbOn+6ucyX
         H6Pl5xHiYQC+3gPfhOpXVpfLkA6nT5EDTnGLGfk/KBaN1UDYP1rrfSYg9QPKptNWXVFv
         rGD05TfqEBYD9YEP6d+PtNxbQQmn0kfcF6yLzRRKl53NDrXSiACfYUbvh/KpfFODdcDN
         NWnOTeo9J971LsIQ/6pRldSAfhN/UWaQD9nqk0mTxmf0BpJR7eUCQbY/bU1g1u5pZfYu
         +ZEoBhPqHeLiHny5rnMRQedlXDVrTnt/u7kPaSy+ArQQfw8PxPpzS5vjVDdZD6lcR76k
         IHfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MdJG0hGFUyyCI91ddj8JC9nYTc4V0N35yzoPYsarpcg=;
        b=UL8PJ9MmS/6CpL/QUU0SMGnyRX4U9mUXRfc+QWbPHSJRQxeMH5vOoDMvh1/GmHeCws
         O4rqlGeIdETJmrniZsPMZ7IOs7JDCVQ7zml0oPjaFU5h8FncKj+Jgj8qb7CHaLSRkXk3
         Hsr8l4J4Kia9BztYHivojr7V7dFrpvlG3YqSn4xWDzqjlRtirByqs4DT1chT6ZAbrpON
         ggC+LqrrL4yaj/Pa4xeQRnBzGQZkexqL3t/fe92XxR8asvq6QCoHpv54LfW2Q45JkFxU
         Q8SNueypGkf6uC8wA3aVKBv8OpLnZxsNIohZlQfZHYg0U53/kS6aqggNykTV0PU1dfBl
         6oOw==
X-Gm-Message-State: ANoB5pkAKPWrYRydQ0BiLrpMV9F21dRxGvGZX6sM7zlCZP3JqQLMc5aV
	1HA+UEJj3IFJneTKSW5dba8Pyjbgb53WUZb0GvI=
X-Google-Smtp-Source: AA0mqf74TSAkf0yvcI1luyzDEnm65fgkWY2yGou5WVEL5BlFJ1qVXKE6gBq540y26pPNkjIbC5NztZ+6bYP+FGRr3j8=
X-Received: by 2002:a17:906:3ac3:b0:7af:da0:aebe with SMTP id
 z3-20020a1709063ac300b007af0da0aebemr2727739ejd.723.1668456549600; Mon, 14
 Nov 2022 12:09:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221110164152.26136-1-ojeda@kernel.org> <20221110164152.26136-3-ojeda@kernel.org>
 <Y3JTZ5sle+/A/CdD@liuwe-devbox-debian-v2>
In-Reply-To: <Y3JTZ5sle+/A/CdD@liuwe-devbox-debian-v2>
From: =?UTF-8?Q?Sergio_Gonz=C3=A1lez_Collado?= <sergio.collado@gmail.com>
Date: Mon, 14 Nov 2022 10:01:20 -0500
Message-ID: <CAA76j92+X=GvnPq_MaX3qDiQ1vthoEKa9EZLb0gaRSNHVhWiUQ@mail.gmail.com>
Subject: Re: [PATCH v1 02/28] rust: print: add more `pr_*!` levels
To: Wei Liu <wei.liu@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Adam Bratschi-Kaye <ark.email@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 14 Nov 2022 at 09:43, Wei Liu <wei.liu@kernel.org> wrote:
>
> On Thu, Nov 10, 2022 at 05:41:14PM +0100, Miguel Ojeda wrote:
> > Currently, only `pr_info!` (for the minimal sample) and
> > `pr_emerg!` (for the panic handler) are there.
> >
> > Add the other levels as new macros, i.e. `pr_alert!`, `pr_crit!`,
> > `pr_err!`, `pr_warn!`, `pr_notice!` and `pr_debug!`.
> >
> > Co-developed-by: Adam Bratschi-Kaye <ark.email@gmail.com>
> > Signed-off-by: Adam Bratschi-Kaye <ark.email@gmail.com>
> > Co-developed-by: Wedson Almeida Filho <wedsonaf@gmail.com>
> > Signed-off-by: Wedson Almeida Filho <wedsonaf@gmail.com>
> > Co-developed-by: Gary Guo <gary@garyguo.net>
> > Signed-off-by: Gary Guo <gary@garyguo.net>
> > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
>
> Reviewed-by: Wei Liu <wei.liu@kernel.org>

Reviewed-by: Sergio Gonzalez Collado <sergio.collado@gmail.com>
