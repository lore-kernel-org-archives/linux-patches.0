Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8897E
	for <patches@lists.linux.dev>; Sat,  4 Mar 2023 15:33:50 +0000 (UTC)
Received: by mail-qv1-f54.google.com with SMTP id jo29so3811399qvb.0
        for <patches@lists.linux.dev>; Sat, 04 Mar 2023 07:33:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677944029;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xPOaMM4z/o/74PWOB79M+Z3qoHNCo5CnO+zcqkcRKQo=;
        b=FvXAAn2o1qSeFTpmCvjX35ic+nx2wrMTtgs5IZUCRmYfH/jWs3Utbv1hSN31qk0BqT
         +SVXT3xIva4p3q+b3tBWSHE6tttaDu/M9zkxFMZciSiaX/2OsJ+z0Mghg+IWrWQfB0MI
         FaT+EEsdfcuduxbAzdz9HPSxNDhzsRaxqvd9Nft6HmohCCZXGU5dJAYnqyzLPI9Ouv2J
         i8YlTqRA2zBX1YVidCx33Di1NiWLVNRluX0D5yjFepOjMGBOZBKRVDWoeXeHBU4jWNRr
         yCXZeQGyx7yZj2hDijcjUWbPQfcPpgX7NGtqNsEiBNhazvOfh45Fs6qSEFcXshfW/Nty
         2JjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677944029;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xPOaMM4z/o/74PWOB79M+Z3qoHNCo5CnO+zcqkcRKQo=;
        b=0VqQihcepfgwQV9WCsTVIhL89GQx/GKC8c3hQ8U0DmSDeW6lJGT0YxSrHin0LQK4l3
         WDLMU4QkcRRP9ipTMzJaE7HW2O6diupUPvmmLO/oCBjblmjJskG++kTPFsmZKJjKM5Ca
         41s1dExvihG9JtKAHuqI3PGtAf77H4tZIZWZNW42vM5BTCqmTnS3cfNWhQPmcSZs9cYy
         l4ZWcDLdsLX44ljMnOVyuReumfCzhryMdjAd2eiUl3OCp9oulmIXWPBeAG510sP2kwRp
         VD8V/DIrXdSbW5mKtjmcG2shN6piyQWRdIZr/rnnzDNN3oWsa0YIaXfKPuPPxLpLRiTM
         KPdw==
X-Gm-Message-State: AO0yUKU98OSOQEpGsRUO7/FdTdCXj71rOxtTXRVzW+OQWwYebggmsTbB
	KSUVdwQxES3Z+KJYUP0cHYo=
X-Google-Smtp-Source: AK7set/T7IN44aotHKkdLQvQ0WoRv5q5jtuBgNAw15hXHEf80xrX+2vcxqYGR9yqGE61Tg2YbRjKbw==
X-Received: by 2002:a05:6214:d05:b0:56f:154:2517 with SMTP id 5-20020a0562140d0500b0056f01542517mr9775900qvh.10.1677944029257;
        Sat, 04 Mar 2023 07:33:49 -0800 (PST)
Received: from ?IPV6:2600:1700:2442:6db0:99e6:eec3:1daa:f163? ([2600:1700:2442:6db0:99e6:eec3:1daa:f163])
        by smtp.gmail.com with ESMTPSA id c134-20020ae9ed8c000000b0073d873df3fesm2859393qkg.30.2023.03.04.07.33.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Mar 2023 07:33:48 -0800 (PST)
Message-ID: <1f56d371-9344-5c45-0024-ede99c551148@gmail.com>
Date: Sat, 4 Mar 2023 09:33:48 -0600
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
To: Rob Herring <robh+dt@kernel.org>, Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>,
 linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
 patches@lists.linux.dev, Brendan Higgins <brendan.higgins@linux.dev>,
 David Gow <davidgow@google.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Richard Weinberger
 <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Vincent Whitchurch <vincent.whitchurch@axis.com>,
 Christian Marangi <ansuelsmth@gmail.com>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 devicetree@vger.kernel.org, linux-um@lists.infradead.org,
 linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com
References: <20230302013822.1808711-1-sboyd@kernel.org>
 <CAL_JsqLVQVZhYTSZgrvA-V-xOUbiBdyDxqPOZk=89YS33EahBQ@mail.gmail.com>
From: Frank Rowand <frowand.list@gmail.com>
In-Reply-To: <CAL_JsqLVQVZhYTSZgrvA-V-xOUbiBdyDxqPOZk=89YS33EahBQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 3/2/23 11:13, Rob Herring wrote:
> On Wed, Mar 1, 2023 at 7:38 PM Stephen Boyd <sboyd@kernel.org> wrote:
>>
>> This patch series adds unit tests for the clk fixed rate basic type and
>> the clk registration functions that use struct clk_parent_data. To get
>> there, we add support for loading a DTB into the UML kernel that's
>> running the unit tests along with probing platform drivers to bind to
>> device nodes specified in DT.
>>
>> With this series, we're able to exercise some of the code in the common
>> clk framework that uses devicetree lookups to find parents and the fixed
>> rate clk code that scans devicetree directly and creates clks. Please
>> review.
>>
>> I Cced everyone to all the patches so they get the full context. I'm
>> hoping I can take the whole pile through the clk tree as they almost all
>> depend on each other. In the future I imagine it will be easy to add
>> more test nodes to the clk.dtsi file and not need to go across various
>> maintainer trees like this series does.
>>
>> Stephen Boyd (8):
>>   dt-bindings: Add linux,kunit binding
>>   of: Enable DTB loading on UML for KUnit tests
>>   kunit: Add test managed platform_device/driver APIs
>>   clk: Add test managed clk provider/consumer APIs
>>   dt-bindings: kunit: Add fixed rate clk consumer test
>>   clk: Add KUnit tests for clk fixed rate basic type
>>   dt-bindings: clk: Add KUnit clk_parent_data test
>>   clk: Add KUnit tests for clks registered with struct clk_parent_data
> 
> Good to see bindings for this. I've been meaning to do something about
> the DT unittest ones being undocumented, but I hadn't really decided
> whether it was worth writing schemas for them. The compatibles at
> least show up with 'make dt_compatible_check'. Perhaps we want to just
> define some vendor (not 'linux') that's an exception rather than
> requiring schemas (actually, that already works for 'foo'). It's
> likely that we want test DTs that fail normal checks and schemas get
> in the way of that as we don't have a way to turn off checks.
> 
> We already have GPIO tests in the DT unittests, so why is clocks
> different? Or should the GPIO tests be moved out (yes, please!)?
> 
> What happens when/if the DT unittest is converted to kunit? I think

My current plan is to update the DT unittest output to be compatible
with the kunit output, so test harnesses can use the same framework
to process test output, and detect and report results.

kunit moved to the KTAP format a while ago.  I am working (more slowly
than I would like) to get the next version of the KTAP specification
agreed to, which has some features that will be needed to move DT
unittests to the KTAP output format.

Whether it is possible to subsequently move DT unittests into the
kunit framework is a different question, which could be addressed
as a possible next step of DT unittest transformation (but see my
opinion below).

> that would look confusing from the naming. My initial thought is
> 'kunit' should be dropped from the naming of a lot of this. Note that
> the original kunit submission converted the DT unittests. I would
> still like to see that happen. Frank disagreed over what's a unit test
> or not, then agreed, then didn't... I don't really care. If there's a
> framework to use, then we should use it IMO.

I don't think I ever agreed that the kunit framework was suitable to
implement DT unittest.

At a conceptual level, kunit and DT unittest differ architecturally
(the following is not what kunit looks like - the procedural flow is
hidden away in macros and the source looks more like data declarations).

  kunit
  -----
  test_1_initialization();
  test_1();
     test_1_a();
     test_1_b();
     ...
     test_1_N();
  test_1_cleanup();

  ## Each of test_1_*() reports pass / fail / skip
  ## I'm not sure if this is just one pass / fail / skip, or
  ## if multiple are supported.
  ##
  ## Each of test_1_*() are independent and could be reordered.


  DT unittest
  -----------
  some_initialization_in_early_boot()
  of_unittest()
     a_lot_of_initialization();
     subsystem_or_area_1_test();
        test_area_initialization();
        test_1_a();
        ## test_1_a() may or may not impact the devicetree data
        ## in a manner that is pre-requisite for test_1_b()
        test_1_b();
        ...
        ## At any point in test_1_a() .. test_1_N() may goto
        ##   out_ERROR_xxx: if a test fails in a way that
        ##   impacts subsequent test dependencies
        ##
        ## Possible clean up between or after each test_1_*()
        ## Possible validation that the devicetreee data is correct
        ##   after test activity
        test_1_c();
        ...
        test_1_N();
     subsystem_or_area_2_test();
        ...
     ## At arbitrary points, full tree or sub-tree validation to
     ## confirm tree integrity after completing the previous tests
     ...

   ## Much of test_1_*() are dependent on previously executed
   ## test_1_*() and can _not_ be reordered.

-Frank



> 
>>
>>  .../clock/linux,clk-kunit-parent-data.yaml    |  47 ++
>>  .../kunit/linux,clk-kunit-fixed-rate.yaml     |  35 ++
>>  .../bindings/kunit/linux,kunit.yaml           |  24 +
>>  arch/um/kernel/dtb.c                          |  29 +-
>>  drivers/clk/.kunitconfig                      |   3 +
>>  drivers/clk/Kconfig                           |   7 +
>>  drivers/clk/Makefile                          |   6 +
>>  drivers/clk/clk-fixed-rate_test.c             | 296 ++++++++++++
>>  drivers/clk/clk-kunit.c                       | 204 ++++++++
>>  drivers/clk/clk-kunit.h                       |  28 ++
>>  drivers/clk/clk_test.c                        | 456 +++++++++++++++++-
>>  drivers/of/Kconfig                            |  26 +
>>  drivers/of/Makefile                           |   1 +
>>  drivers/of/kunit/.kunitconfig                 |   4 +
>>  drivers/of/kunit/Makefile                     |   4 +
>>  drivers/of/kunit/clk.dtsi                     |  30 ++
>>  drivers/of/kunit/kunit.dtsi                   |   9 +
>>  drivers/of/kunit/kunit.dtso                   |   4 +
>>  drivers/of/kunit/uml_dtb_test.c               |  55 +++
>>  include/kunit/platform_driver.h               |  15 +
>>  lib/kunit/Makefile                            |   6 +
>>  lib/kunit/platform_driver-test.c              | 107 ++++
>>  lib/kunit/platform_driver.c                   | 207 ++++++++
> 
> Humm, we have DT platform driver unittests too. What's the difference?
> 
> Anyways, that's all just my initial reaction from only halfway looking
> at this. :)
> 
> Rob

