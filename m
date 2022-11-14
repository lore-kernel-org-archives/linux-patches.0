Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813B779E2
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 17:22:46 +0000 (UTC)
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-381662c78a9so32118237b3.7
        for <patches@lists.linux.dev>; Mon, 14 Nov 2022 09:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GVt/oFN+blh8k3TM/7jbMZ0qqobahGcF8Xv/SNk9ry8=;
        b=JxRsi2r8POhUZC2Jpt9hW8/vEhZqbOlsDBFVPHtJ+MqwwYJQynqIeZgMLiIS/3Qsj8
         fLza3JPx4tA3Lu5EvbWMONrZp0sdBBb408cH40SYnGzMBsFzTrsXi61airCZCdHP6SSe
         sr68V/3uEX+Zh0By77vVlPycMCu74NCMfxO3Bvf2+XxNnza5aoOlqI+RddGfC2RhMXN9
         lyQ9tyqtH0W8D0k2TX21qv7+J5lVZzz/Pav4K+eOHt83vtdura8Tukg7KwpfqVcqhtij
         czchqbxLt30dcm3CZe7E8PEB+6fGP+uVD5Ma2G09+/HnMlVQk5tCcY7aLk0bnomdyf6W
         4XNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GVt/oFN+blh8k3TM/7jbMZ0qqobahGcF8Xv/SNk9ry8=;
        b=zmuk5hn9BN+lZsvXM+VOUmb7aYbAEcklsLy/0iDAQcD3T4rzoaNWMq221xAC1uu2v9
         0OxLQQ3kgQk/wSkvPKFP8Vw2G+Q2vpH/Qb/HJ1Kenp4GT01yvJ7JOTBElarDGaajE7O+
         wUCYP5QBJACIR4e6+THPH9VjaInGEn3DdjIEwacXE4Q2gq07vDhMvNpO6F7IUeh740ae
         I1SakqWuExeHE4Iw9TZsqGjejJcfh0GeBCsEtoGczdHaw69yL6HexfWKBnE50TUCsTaL
         lxbu32jJXLbAD3Hz08bD7LfI61UHeD5/uPEITrsCvf77iGWE9ER3aP7aF4O1Ew0L9ZTm
         m4EQ==
X-Gm-Message-State: ANoB5pkdkgBibSdndZc8CJSn6s5qj6TuiMe5/n+pOBOcbaAl+DhB15L6
	XpO5tOnMPbPaodsnyoBcuZOD70Y70n2O1o2fQZUiYzLg9DQ=
X-Google-Smtp-Source: AA0mqf4c2cLC/QN9jBTixqIHgPnVn5eykA6zqD6gyzAo3/QKG3yVYltgm8C0uuAUZmYmQNdqG8amU6+xiEgsnFdyeHU=
X-Received: by 2002:a81:9c12:0:b0:352:4422:d530 with SMTP id
 m18-20020a819c12000000b003524422d530mr14111616ywa.256.1668446565529; Mon, 14
 Nov 2022 09:22:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221110164152.26136-1-ojeda@kernel.org> <20221110164152.26136-6-ojeda@kernel.org>
 <20221114142611.2a21d4e9@GaryWorkstation>
In-Reply-To: <20221114142611.2a21d4e9@GaryWorkstation>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 14 Nov 2022 18:22:34 +0100
Message-ID: <CANiq72naZ_dpgCo2VukXmoGNefXTzR-WUN_HywRrgJ+bUbeEPQ@mail.gmail.com>
Subject: Re: [PATCH v1 05/28] rust: macros: add `concat_idents!` proc macro
To: Gary Guo <gary@garyguo.net>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 14, 2022 at 3:26 PM Gary Guo <gary@garyguo.net> wrote:
>
> Probably clearer to write `Ident::new(&format!("{a}{b}"), b.span())`
> here?

Same as Bj=C3=B6rn, it also looks better to me. I will update it.

Cheers,
Miguel
