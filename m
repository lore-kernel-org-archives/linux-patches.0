Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6E17E4
	for <patches@lists.linux.dev>; Sun, 15 Jan 2023 02:40:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055ADC433F2
	for <patches@lists.linux.dev>; Sun, 15 Jan 2023 02:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1673750400;
	bh=0TIlpXUyLjXgCWJoz/frRR9jRP9rDDMVSVFqtR3tMeA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=u3QZQEsTqOENmtWwRPaMnAqKojLu2ZcEpTbuaJn5T7141w0ECFE67bSBG/MhHITmQ
	 su607huar2CJEEYnnvyDc4t+pmLIrTajd+ugnd3td9218542nDk2t7AjbaKeH5f4y+
	 aK4OcTvgltK3zRD0uKBns0lF68tb0+BDk+MezEjM1Q+ROIzrnv/rAquczd04gnhJTl
	 QCkAV4ThOvNGdpDsCLVyZQtX5BBTUA11CbrGjEWrVDVLXerAQhYulwzDVTdTHgsD4S
	 1W3t/qnoSj674g9xGSa/tdji22kBu26q/CHuNbgqE9LyDfjYaaSpE4mSScGRot43OZ
	 qDYiQ5XJYLhjw==
Received: by mail-ot1-f42.google.com with SMTP id d2-20020a056830044200b00684cc404c8aso3826976otc.0
        for <patches@lists.linux.dev>; Sat, 14 Jan 2023 18:39:59 -0800 (PST)
X-Gm-Message-State: AFqh2krZ97bZXJL8MdJXZ+bB9GOOc3Ufv40OHdoZdLZneD+1SJBIDgRk
	8e0zzz/FotfevIBn9+1AyNvqKJRbBP/O5wASduY=
X-Google-Smtp-Source: AMrXdXtoyZNoBhCTlW2oVmTW6Au80Bu7uDXtz+FY9yhcsQaPhStbX/RPkg215wnou5HpVqBqN5lA8VUlPXTllDvcaFI=
X-Received: by 2002:a05:6830:14c7:b0:684:a3ad:87e8 with SMTP id
 t7-20020a05683014c700b00684a3ad87e8mr1046643otq.225.1673750399222; Sat, 14
 Jan 2023 18:39:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230109204520.539080-1-ojeda@kernel.org> <20230109204520.539080-5-ojeda@kernel.org>
 <CAK7LNAQj_WykFWcrj=L3wJYxDhOCGs+JHPB4E2vzWcx8y_at0w@mail.gmail.com> <CANiq72=MsV8EXV9cib+GJd0AXbpF8YSGdDd723m7=ON4jhjXxQ@mail.gmail.com>
In-Reply-To: <CANiq72=MsV8EXV9cib+GJd0AXbpF8YSGdDd723m7=ON4jhjXxQ@mail.gmail.com>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Sun, 15 Jan 2023 11:39:22 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQo=w3F=VXNGYyo6-A4c8Sees6yVHrsaFXLknCrO0ET3Q@mail.gmail.com>
Message-ID: <CAK7LNAQo=w3F=VXNGYyo6-A4c8Sees6yVHrsaFXLknCrO0ET3Q@mail.gmail.com>
Subject: Re: [PATCH 5/6] kbuild: rust_is_available: fix confusion when a
 version appears in the path
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, linux-kbuild@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Nicolas Schier <nicolas@fjasle.eu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, Jan 14, 2023 at 8:13 AM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Thu, Jan 12, 2023 at 6:32 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
> >
> > +set -- ${bindgen_libclang_output#**clang version}
> > +bindgen_libclang_cversion=$(get_canonical_version $1)
> >  bindgen_libclang_min_version=$($min_tool_version llvm)
> > -bindgen_libclang_cversion=$(get_canonical_version $bindgen_libclang_version)
>
> Nice trick :) To be honest, I am not really fond of `set`, and in this
> case it means the command is not symmetric (we remove the prefix using
> parameter expansion, and the suffix via positional argument
> selection), but if you prefer it that way, I think it would be fine.


I just tend to write efficient code.
(scripts/{cc,ld,as}-version.sh do not use sed or grep at all.)

Especially, I avoid unneeded process forks
in the process forks.






> However, why the double asterisk? One already matches any string,
> including spaces, no?


Sorry, it is my mistake.

I meant double pound.


  set -- ${bindgen_libclang_output##*clang version}



The double pound strips "the longest matching pattern",
just in case "clang version" is contained in the file path.
(but if a space is contained in the directory path,
it would have failed earlier.






>
> Cheers,
> Miguel




--
Best Regards
Masahiro Yamada
