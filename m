Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57F8613D
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 12:45:19 +0000 (UTC)
Received: by mail-yb1-f177.google.com with SMTP id k199so11236020ybf.4
        for <patches@lists.linux.dev>; Tue, 07 Mar 2023 04:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678193118;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6fe876EcuA+jdmCESHMii/7cG2YSZKquEdS/vIty4+A=;
        b=ODIJueFdMNGe95gTEbyF5NczLJmY23TtUj51PPOLopdCMmLFgcThOhcAVkvfDnoWal
         kGcukFh7EtTc0RW08h2lwJk9aOVAolceIRIuOJKABA+/zAdgaUpAp0J6WXyT61J/a/ft
         tMygDnofeR6ck4paPkOSPfFEJuAPyTXIDnzWEuv74MGISTIw5i3wp84FjjkivYkMTQNV
         FU0w7dBuB3gmGh574Vs6I2bg7ztdeRTZAVPhfzpAy8Wm7v0N0ZXCBkDy2WwAsC0hnMsQ
         Jq33qja3vVL9a+IU3LhBjW8TtcIMuTPXr7vEKx28eD2rp6bXV+a/1SMLI9FZ3Nb60QUo
         VT9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678193118;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6fe876EcuA+jdmCESHMii/7cG2YSZKquEdS/vIty4+A=;
        b=3GnIjlsewq1bcOF3Jlp6zAfNN8hhe3KC7FoIqirJhl1YWLD3ntRK4+IhpLcMKddcg6
         L6ghZaG5qXoZ5rQeLrhPJyQ9tf4pIHEBiAepTIOIsPzoYMpe8NbMa8IsN/YOjzH2XAX5
         Racr/2kwZWz66ITDDJbVfgCYdByOd5cA3p0bkNDCwVWoApepAPPx8ZKVKbBBtR96kLnm
         i7kHbyI46BJVT7/QYjFsrQXE8MWnEBc+aH7lKIqRix5azKPdzzek3Rh8qU8K41KjvYUk
         ZAZeLOj5T67jynooWtB7oikKo3sIgPwOaHFRItaLBDqLTUZVANU+DzEXzxQcmzyI6Y2g
         sJgw==
X-Gm-Message-State: AO0yUKWVXiPS9AM9nj5Dy/eASiLv0bow8nfj0JUu26o+R6iGiDaY6E8P
	DMzf89NhzBaq4rQ/ofhvdHGhvu+gvGkwpmFgELk=
X-Google-Smtp-Source: AK7set+4i6X4+McENdJYEtkgtVMIkW1tvDFHTItHQ5/EcD88Yp6L91Q8oXnhMttrnbcAi9OAVXl2NClL+dgdZd9VEek=
X-Received: by 2002:a25:656:0:b0:a27:3ecc:ffe7 with SMTP id
 83-20020a250656000000b00a273eccffe7mr11410509ybg.3.1678193118746; Tue, 07 Mar
 2023 04:45:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230306220959.240235-1-ojeda@kernel.org> <87ilfcivzf.fsf@metaspace.dk>
In-Reply-To: <87ilfcivzf.fsf@metaspace.dk>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 7 Mar 2023 13:45:07 +0100
Message-ID: <CANiq72m_y=eCsJLxRP+bFvhmR5yAVK7=W6Hijb_CozWnL__dQw@mail.gmail.com>
Subject: Re: [PATCH] docs: rust: point directly to the standalone installers
To: Andreas Hindborg <nmi@metaspace.dk>
Cc: Miguel Ojeda <ojeda@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	linux-doc@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 7, 2023 at 1:31=E2=80=AFPM Andreas Hindborg <nmi@metaspace.dk> =
wrote:
>
> I guess we should remove "or install ``rustup``" from this sentence?

Good point -- the page contains installers for `rustup` itself too
above the URL fragment, but we are pointing directly to the fragment,
so it can be confusing.

I think I will split the sentence and add an extra link to the other
fragment, since there is one for that too (`#rustup`).

Cheers,
Miguel
