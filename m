Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB211C07;
	Sat,  8 Apr 2023 13:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97985C4339C;
	Sat,  8 Apr 2023 13:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1680961786;
	bh=rpFTrTpcNVbSF0vqVoyh7L6giVIN41C6RAvl7FyFd6M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=uYTTzr+VaSdylukWPgMXvbabqMmFJFBelvAVKNtGkkIMZ1pFQpTdcJneODqdlGLIC
	 NMm7/KkuKUJWf9AVIqyZCJ2fIaa0JgZ/qXBwsUoT3Gj+H6WkbGwYTbAkhnSr9MWkn5
	 RNh7d3QhL0cDEaelZ72nYpNXOCt9XG318tFjcgIWryvfP1lII8xCWiSDjzsmXUxVjw
	 79qFqh7GdiF3LkqIAnY5nPV7i1tT09Gwn3OUlvyKP0/b4vbRrYfx2D8dYcdi0rjtgV
	 9eWLZa/L9fT/XjtG5jSzK+FIxrV0bOiWfAW1PoHI4q6Kvjy/KSaEJP5IyIkg1ebQ2h
	 sfoKlbVKZJgHQ==
Received: by mail-ot1-f53.google.com with SMTP id 6-20020a9d0106000000b006a177038dfeso14019221otu.7;
        Sat, 08 Apr 2023 06:49:46 -0700 (PDT)
X-Gm-Message-State: AAQBX9eDcWK8riojCJ5OFhf0KsIn8xrtzOWkuWNZMns6gBowWt+ERTPj
	btogSxOYsbw6Zu3UiIm376JqQ+JHYyMza81aY0Q=
X-Google-Smtp-Source: AKy350Yym8k/APtYBId7w0JsijjhyT7A4owCM9aPZto2PhafU7XfDKW9u3WGQU/uDgTbGtERYGu0UOkevabdF/37QBs=
X-Received: by 2002:a05:6830:130a:b0:69f:8da4:48d with SMTP id
 p10-20020a056830130a00b0069f8da4048dmr1361134otq.1.1680961785939; Sat, 08 Apr
 2023 06:49:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230405-korg-llvm-tc-docs-v2-1-98d2e4a96c41@kernel.org>
In-Reply-To: <20230405-korg-llvm-tc-docs-v2-1-98d2e4a96c41@kernel.org>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Sat, 8 Apr 2023 22:49:09 +0900
X-Gmail-Original-Message-ID: <CAK7LNAR9NjtgJip-ZuSrvFX6+zkF7XA7XewS7w+_hogB2F1x6A@mail.gmail.com>
Message-ID: <CAK7LNAR9NjtgJip-ZuSrvFX6+zkF7XA7XewS7w+_hogB2F1x6A@mail.gmail.com>
Subject: Re: [PATCH v2] Documentation/llvm: Add a note about prebuilt
 kernel.org toolchains
To: Nathan Chancellor <nathan@kernel.org>
Cc: corbet@lwn.net, arnd@arndb.de, keescook@chromium.org, 
	ndesaulniers@google.com, trix@redhat.com, nicolas@fjasle.eu, 
	llvm@lists.linux.dev, patches@lists.linux.dev, linux-kbuild@vger.kernel.org, 
	linux-doc@vger.kernel.org, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 8, 2023 at 6:43=E2=80=AFAM Nathan Chancellor <nathan@kernel.org=
> wrote:
>
> I recently started uploading prebuilt stable versions of LLVM to
> kernel.org, which should make building the kernel with LLVM more
> accessible to maintainers and developers. Link them in the LLVM
> documentation to make this more visible.
>
> Link: https://lore.kernel.org/20230319235619.GA18547@dev-arch.thelio-3990=
X/
> Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
> Reviewed-by: Bill Wendling <morbo@google.com>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>


Applied to linux-kbuild/fixes.
Thanks.






--=20
Best Regards
Masahiro Yamada
