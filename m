Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE957E
	for <patches@lists.linux.dev>; Sat,  4 Mar 2023 15:50:32 +0000 (UTC)
Received: by mail-qv1-f47.google.com with SMTP id bo10so3753746qvb.12
        for <patches@lists.linux.dev>; Sat, 04 Mar 2023 07:50:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677945031;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AK1Ix3KFP+QC/z8RDL7NPBBR7qAfQh0PbANacdVVkAg=;
        b=AgWIPqX8GI0REpRX0iAlNsH+yytrdoMJHBRBlgdtFx3qFKu4hHovYju5/o/A3a39JA
         XATqOn510nifr2JkL3bDql2hNKUQskAAG0obJ9eOg1mMzTgEwi+ULJI6c3TsmnyL6BPz
         uFEEH4QwS7Mslyh3ddIjeZDkCXKuJjCirOFLtR7HLO2ulubbyQ8WepG2n7/0R1k5cqwC
         PLPXM5WghSvKEQ76wUiRUpNVF2qkLTMXv5GepYiV7V2jbfLR1gR8hwXp3qQgix833o47
         G5gKYCgONn003UsTEqvLHPc+ekk4BK5uE4PVaigY44iKXxJECfQp/BJtwC4jCQmPPLBN
         aMlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677945031;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AK1Ix3KFP+QC/z8RDL7NPBBR7qAfQh0PbANacdVVkAg=;
        b=sMQ4cegqsg9RE/y/HXvdyK2ZJzd8GQNyJaOiO8XY1lCYbPNRi8kY2UvDF3W8KJ+xe1
         Uzsz1PMl3uhFrc9KkLxv0ODjdpUtgotMsco4cYoR7jkuGhEXQYyndgSa/qoHvfM5lS8o
         wxDy9RD9KOIKVKmRKYnwiLL9Oz8lSRqkTH8q+d3dNv+O/0thmxFKVF5oFZW+cxenBDK5
         LCl3nL2U5mmDYGj0jkymxa0NIQjQHcdcbBjEk9bybVcx87NW2R14xkJndLweJrDQrCG9
         IycA3g/+WdylGWZtRnAPQajYN+q36aY+ZalyH01wZe6IoIQZ7eftgr3N+Vc7WMTpY6IR
         rsSQ==
X-Gm-Message-State: AO0yUKUEaWHMWMqeOVi+fr/j8mXCSamy49syOGefyh6NgWsiZBfmSoxf
	l6YAAwkYDg7NreLa1CSQ/FA=
X-Google-Smtp-Source: AK7set/DyPEjifcHCKWhZ6dB/iXh6wfHCZu8KsRmq7nVeH5rlwaMIanC8LbXvpVGt9i3Klr7lRafZw==
X-Received: by 2002:a05:6214:21a2:b0:568:89e3:c5ca with SMTP id t2-20020a05621421a200b0056889e3c5camr9462185qvc.13.1677945031048;
        Sat, 04 Mar 2023 07:50:31 -0800 (PST)
Received: from ?IPV6:2600:1700:2442:6db0:99e6:eec3:1daa:f163? ([2600:1700:2442:6db0:99e6:eec3:1daa:f163])
        by smtp.gmail.com with ESMTPSA id z75-20020a37654e000000b007423c011937sm3924269qkb.91.2023.03.04.07.50.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Mar 2023 07:50:30 -0800 (PST)
Message-ID: <2ce31cd1-7a0e-18ac-8a5b-ed09d6539241@gmail.com>
Date: Sat, 4 Mar 2023 09:50:29 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 0/8] clk: Add kunit tests for fixed rate and parent data
Content-Language: en-US
To: Stephen Boyd <sboyd@kernel.org>,
 Michael Turquette <mturquette@baylibre.com>
Cc: linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
 patches@lists.linux.dev, Brendan Higgins <brendan.higgins@linux.dev>,
 David Gow <davidgow@google.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Richard Weinberger
 <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Vincent Whitchurch <vincent.whitchurch@axis.com>,
 Rob Herring <robh+dt@kernel.org>, Christian Marangi <ansuelsmth@gmail.com>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 devicetree@vger.kernel.org, linux-um@lists.infradead.org,
 linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com
References: <20230302013822.1808711-1-sboyd@kernel.org>
From: Frank Rowand <frowand.list@gmail.com>
In-Reply-To: <20230302013822.1808711-1-sboyd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/1/23 19:38, Stephen Boyd wrote:
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

I would _really_ like to _not_ have devicetree tests in two locations:
DT unittests and kunit tests.

For my testing, I already build and boot four times on real hardware:

  1) no DT unittests
  2) CONFIG_OF_UNITTEST
  3) CONFIG_OF_UNITTEST
     CONFIG_OF_DYNAMIC
  4) CONFIG_OF_UNITTEST
     CONFIG_OF_DYNAMIC
     CONFIG_OF_OVERLAY

I really should also be testing the four configurations on UML, but at
the moment I am not.

I also check for new compile warnings at various warn levels for all
four configurations.

If I recall correctly, the kunit framework encourages more (many more?)
kunit config options to select which test(s) are build for a test run.
Someone please correct this paragraph if I am mis-stating.

Adding devicetree tests to kunit adds additional build and boot cycles
and additional test output streams to verify.

Are there any issues with DT unittests that preclude adding clk tests
into the DT unittests?

-Frank

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
>  23 files changed, 1599 insertions(+), 4 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/clock/linux,clk-kunit-parent-data.yaml
>  create mode 100644 Documentation/devicetree/bindings/kunit/linux,clk-kunit-fixed-rate.yaml
>  create mode 100644 Documentation/devicetree/bindings/kunit/linux,kunit.yaml
>  create mode 100644 drivers/clk/clk-fixed-rate_test.c
>  create mode 100644 drivers/clk/clk-kunit.c
>  create mode 100644 drivers/clk/clk-kunit.h
>  create mode 100644 drivers/of/kunit/.kunitconfig
>  create mode 100644 drivers/of/kunit/Makefile
>  create mode 100644 drivers/of/kunit/clk.dtsi
>  create mode 100644 drivers/of/kunit/kunit.dtsi
>  create mode 100644 drivers/of/kunit/kunit.dtso
>  create mode 100644 drivers/of/kunit/uml_dtb_test.c
>  create mode 100644 include/kunit/platform_driver.h
>  create mode 100644 lib/kunit/platform_driver-test.c
>  create mode 100644 lib/kunit/platform_driver.c
> 
> 
> base-commit: c9c3395d5e3dcc6daee66c6908354d47bf98cb0c

