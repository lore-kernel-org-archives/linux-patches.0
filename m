Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845CE8C11
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 17:14:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C52CC433AA
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 17:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1677777252;
	bh=sxh36iZQRth6PcbEK8rBaNdhPJuIjt084P0tIKyNndg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=TAJj++imQypJWlswGfOoct5GpNWCJQsD7oCXqgQ+ZDG8uNTAaoEaYgHDCMmVXcK2X
	 jB2C7tAJYpWiuL6YafBBMtsMVUYOCQrRTkfpoH2WH0W3qjbUP53Vj0Fw8x928o5+H0
	 B3X0tkSkIQsoJKkhoOAQNwr3MaqnneespIRdTZKbtUtbpCq3wtLWfzBYaQCGuJznp5
	 +2+jmuUHw6CUofbdurXFfoqeC+3fpZ523uvG5P3p8jI8KoD8MZuo1DwBAtxlhXwW0M
	 i1AGLygTd9avSKC1IuYZNT7A91xL/Q075a1GwO/YFePebxenzP5rnDD7KFjGYoXuyQ
	 w+gk9vEAOiauQ==
Received: by mail-ua1-f46.google.com with SMTP id x40so6653092uaf.2
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 09:14:12 -0800 (PST)
X-Gm-Message-State: AO0yUKW+8hkbIziu5oA7BWy9zg3PBTzAjR1P+UAkl8J8TGsdtTx2qDuu
	1FZQ5AHeS7dcLGhESu99SI4VdAnCQh9RtWaMaA==
X-Google-Smtp-Source: AK7set/cWK8giFKY8fRLWeGOHTziXVw5azzC2FP84wrmvxubHnP5GVl40pOdsWrs8+z15dRYvJSehk78bGu43zZqZQU=
X-Received: by 2002:a05:6122:b55:b0:40f:2033:6994 with SMTP id
 21-20020a0561220b5500b0040f20336994mr6152564vko.2.1677777250943; Thu, 02 Mar
 2023 09:14:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230302013822.1808711-1-sboyd@kernel.org>
In-Reply-To: <20230302013822.1808711-1-sboyd@kernel.org>
From: Rob Herring <robh+dt@kernel.org>
Date: Thu, 2 Mar 2023 11:13:59 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLVQVZhYTSZgrvA-V-xOUbiBdyDxqPOZk=89YS33EahBQ@mail.gmail.com>
Message-ID: <CAL_JsqLVQVZhYTSZgrvA-V-xOUbiBdyDxqPOZk=89YS33EahBQ@mail.gmail.com>
Subject: Re: [PATCH 0/8] clk: Add kunit tests for fixed rate and parent data
To: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, 
	linux-clk@vger.kernel.org, patches@lists.linux.dev, 
	Brendan Higgins <brendan.higgins@linux.dev>, David Gow <davidgow@google.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, 
	Vincent Whitchurch <vincent.whitchurch@axis.com>, Frank Rowand <frowand.list@gmail.com>, 
	Christian Marangi <ansuelsmth@gmail.com>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	kunit-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 1, 2023 at 7:38=E2=80=AFPM Stephen Boyd <sboyd@kernel.org> wrot=
e:
>
> This patch series adds unit tests for the clk fixed rate basic type and
> the clk registration functions that use struct clk_parent_data. To get
> there, we add support for loading a DTB into the UML kernel that's
> running the unit tests along with probing platform drivers to bind to
> device nodes specified in DT.
>
> With this series, we're able to exercise some of the code in the common
> clk framework that uses devicetree lookups to find parents and the fixed
> rate clk code that scans devicetree directly and creates clks. Please
> review.
>
> I Cced everyone to all the patches so they get the full context. I'm
> hoping I can take the whole pile through the clk tree as they almost all
> depend on each other. In the future I imagine it will be easy to add
> more test nodes to the clk.dtsi file and not need to go across various
> maintainer trees like this series does.
>
> Stephen Boyd (8):
>   dt-bindings: Add linux,kunit binding
>   of: Enable DTB loading on UML for KUnit tests
>   kunit: Add test managed platform_device/driver APIs
>   clk: Add test managed clk provider/consumer APIs
>   dt-bindings: kunit: Add fixed rate clk consumer test
>   clk: Add KUnit tests for clk fixed rate basic type
>   dt-bindings: clk: Add KUnit clk_parent_data test
>   clk: Add KUnit tests for clks registered with struct clk_parent_data

Good to see bindings for this. I've been meaning to do something about
the DT unittest ones being undocumented, but I hadn't really decided
whether it was worth writing schemas for them. The compatibles at
least show up with 'make dt_compatible_check'. Perhaps we want to just
define some vendor (not 'linux') that's an exception rather than
requiring schemas (actually, that already works for 'foo'). It's
likely that we want test DTs that fail normal checks and schemas get
in the way of that as we don't have a way to turn off checks.

We already have GPIO tests in the DT unittests, so why is clocks
different? Or should the GPIO tests be moved out (yes, please!)?

What happens when/if the DT unittest is converted to kunit? I think
that would look confusing from the naming. My initial thought is
'kunit' should be dropped from the naming of a lot of this. Note that
the original kunit submission converted the DT unittests. I would
still like to see that happen. Frank disagreed over what's a unit test
or not, then agreed, then didn't... I don't really care. If there's a
framework to use, then we should use it IMO.

>
>  .../clock/linux,clk-kunit-parent-data.yaml    |  47 ++
>  .../kunit/linux,clk-kunit-fixed-rate.yaml     |  35 ++
>  .../bindings/kunit/linux,kunit.yaml           |  24 +
>  arch/um/kernel/dtb.c                          |  29 +-
>  drivers/clk/.kunitconfig                      |   3 +
>  drivers/clk/Kconfig                           |   7 +
>  drivers/clk/Makefile                          |   6 +
>  drivers/clk/clk-fixed-rate_test.c             | 296 ++++++++++++
>  drivers/clk/clk-kunit.c                       | 204 ++++++++
>  drivers/clk/clk-kunit.h                       |  28 ++
>  drivers/clk/clk_test.c                        | 456 +++++++++++++++++-
>  drivers/of/Kconfig                            |  26 +
>  drivers/of/Makefile                           |   1 +
>  drivers/of/kunit/.kunitconfig                 |   4 +
>  drivers/of/kunit/Makefile                     |   4 +
>  drivers/of/kunit/clk.dtsi                     |  30 ++
>  drivers/of/kunit/kunit.dtsi                   |   9 +
>  drivers/of/kunit/kunit.dtso                   |   4 +
>  drivers/of/kunit/uml_dtb_test.c               |  55 +++
>  include/kunit/platform_driver.h               |  15 +
>  lib/kunit/Makefile                            |   6 +
>  lib/kunit/platform_driver-test.c              | 107 ++++
>  lib/kunit/platform_driver.c                   | 207 ++++++++

Humm, we have DT platform driver unittests too. What's the difference?

Anyways, that's all just my initial reaction from only halfway looking
at this. :)

Rob
