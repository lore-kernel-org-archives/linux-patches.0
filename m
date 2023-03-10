Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAA123A1
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 08:10:01 +0000 (UTC)
Received: by mail-wr1-f47.google.com with SMTP id h14so4230782wru.4
        for <patches@lists.linux.dev>; Fri, 10 Mar 2023 00:10:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678435800;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wJVAKKHINtuSuDJu3EqDjp+q9iC1svWYPRp9peikZs8=;
        b=rrydp6AieROjsxXxzjQcjhFOtXm2HtCj7wFPfwDH6X6Dwr9hmufph/O5n5yoqpDtcX
         Q9rxhQtJ6Xoteqian3hzAPvqjJ5zI+GPGeG6QnPxBNEhHdIYiXCKmbTjphowwoPGs/BE
         h+y7vUuFtFmUbpLOcKbFXH0nZndQ4Vt+q4arQ2In0Dc0KcscRW2fEsPpNqXd/DZ0FwUo
         HCbr//Z1f5/BreIjLdVfHfHBjgC7TmXAcjbpSm0o+IgN1weY7pg1MxTLwcK44mf5Mg3W
         DaGM5DhCE9n4t1PSfowfsvUh9dgyfDKpSNFH5dRnkb02Urmc7Zf/ywCDIWdEAAMG9dq4
         mUwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678435800;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wJVAKKHINtuSuDJu3EqDjp+q9iC1svWYPRp9peikZs8=;
        b=xfXnqJXtMVA1KOkDQeS5E1iVHb5iecjspCIg6GmRtdC2iXjkQbL9Om+yT5xm7WOdKz
         ShD8dI12VFHW9hO4hoabHHgCERNlyelULqqwCk/J9bLA7Ow1MgNfn2hL6Mc+XxcLNv4n
         yibyp0uaDyecXuEWh8nqsqHMxsWJGH/+OnoJfcKed7xhU3koY+NXvmfElq2QNpg+9bzu
         Tj8ostP1WvXqtvxwI2xfm0lXBnmN6avgOVV/wJi6swNZD6fqciVG70YXaW1lO+ZROcVH
         NpFVkGRTR+edUWj9T887UWk7l+LH8ue6cH5l1zyEFQwrMEfXEGVKNMp+28rFS25fBCTA
         dAYA==
X-Gm-Message-State: AO0yUKUoSP3lazzwbZ4NEH3Ttq26z6fOJTAR3ru8TASHal2OKqCZLOCp
	IT6K1U5KRxn8DLDrRt5+NokhNPm/N7BZibWJTjF2msZF3/iGfSpsV75QMZTq
X-Google-Smtp-Source: AK7set/oX+Ou8MHsmEa5YUMjHQpxJqSO/uHVuTi9gb3Gx6kcmU5e2McI3sFT9YkqQ1MIxlwwDDsmoLE8DYvex/r7MOE=
X-Received: by 2002:a5d:4403:0:b0:2c6:ed0b:614e with SMTP id
 z3-20020a5d4403000000b002c6ed0b614emr5436803wrq.2.1678435800053; Fri, 10 Mar
 2023 00:10:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230302013822.1808711-1-sboyd@kernel.org> <20230302013822.1808711-3-sboyd@kernel.org>
 <CABVgOSkomwwgKZ9N0_0YMDL--QaZiTV7ONgSRABU2Ph1Z0CG-g@mail.gmail.com> <a97c9bb3a5addfb34af8ccabaa513026.sboyd@kernel.org>
In-Reply-To: <a97c9bb3a5addfb34af8ccabaa513026.sboyd@kernel.org>
From: David Gow <davidgow@google.com>
Date: Fri, 10 Mar 2023 16:09:48 +0800
Message-ID: <CABVgOSkJ4mw_DtFzn5EwcsuYixWY_j13YotxEYqWhO+ZCL1KPg@mail.gmail.com>
Subject: Re: [PATCH 2/8] of: Enable DTB loading on UML for KUnit tests
To: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, 
	linux-clk@vger.kernel.org, patches@lists.linux.dev, 
	Brendan Higgins <brendan.higgins@linux.dev>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Vincent Whitchurch <vincent.whitchurch@axis.com>, Rob Herring <robh+dt@kernel.org>, 
	Frank Rowand <frowand.list@gmail.com>, Christian Marangi <ansuelsmth@gmail.com>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	kunit-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 10 Mar 2023 at 07:19, Stephen Boyd <sboyd@kernel.org> wrote:
>
> Quoting David Gow (2023-03-02 23:15:04)
> > On Thu, 2 Mar 2023 at 09:38, Stephen Boyd <sboyd@kernel.org> wrote:
> > >
> > > To fully exercise common clk framework code in KUnit we need to
> > > associate 'struct device' pointers with 'struct device_node' pointers so
> > > that things like clk_get() can parse DT nodes for 'clocks' and so that
> > > clk providers can use DT to provide clks; the most common mode of
> > > operation for clk providers.
> > >
> > > Adding support to KUnit so that it loads a DTB is fairly simple after
> > > commit b31297f04e86 ("um: Add devicetree support"). We can simply pass a
> > > pre-compiled deviectree blob (DTB) on the kunit.py commandline and UML
> > > will load it. The problem is that tests won't know that the commandline
> > > has been modified, nor that a DTB has been loaded. Take a different
> > > approach so that tests can skip if a DTB hasn't been loaded.
> > >
> > > Reuse the Makefile logic from the OF unittests to build a DTB into the
> > > kernel. This DTB will be for the mythical machine "linux,kunit", i.e.
> > > the devicetree for the KUnit "board". In practice, it is a dtsi file
> > > that will gather includes for kunit tests that rely in part on a
> > > devicetree being loaded. The devicetree should only be loaded if
> > > CONFIG_OF_KUNIT=y. Make that a choice config parallel to the existing
> > > CONFIG_OF_UNITTEST so that only one devicetree can be loaded in the
> > > system at a time. Similarly, the kernel commandline option to load a
> > > DTB is ignored if CONFIG_OF_KUNIT is enabled so that only one DTB is
> > > loaded at a time.
> >
> > This feels a little bit like it's just papering over the real problem,
> > which is that there's no way tests can skip themselves if no DTB is
> > loaded.
>
> Hmm. I think you're suggesting that the unit test data be loaded
> whenever CONFIG_OF=y and CONFIG_KUNIT=y. Then tests can check for
> CONFIG_OF and skip if it isn't enabled?
>

More of the opposite: that we should have some way of supporting tests
which might want to use a DTB other than the built-in one. Mostly for
non-UML situations where an actual devicetree is needed to even boot
far enough to get test output (so we wouldn't be able to override it
with a compiled-in test one).

I think moving to overlays probably will render this idea obsolete:
but the thought was to give test code a way to check for the required
devicetree nodes at runtime, and skip the test if they weren't found.
That way, the failure mode for trying to boot this on something which
required another device tree for, e.g., serial, would be "these tests
are skipped because the wrong device tree is loaded", not "I get no
output because serial isn't working".

Again, though, it's only really needed for non-UML, and just loading
overlays as needed should be much more sensible anyway.

> >
> > That being said, I do think that there's probably some sense in
> > supporting the compiled-in DTB as well (it's definitely simpler than
> > patching kunit.py to always pass the extra command-line option in, for
> > example).
> > But maybe it'd be nice to have the command-line option override the
> > built-in one if present.
>
> Got it. I need to test loading another DTB on the commandline still, but
> I think this won't be a problem. We'll load the unittest-data DTB even
> with KUnit on UML, so assuming that works on UML right now it should be
> unchanged by this series once I resend.

Again, moving to overlays should render this mostly obsolete, no? Or
am I misunderstanding how the overlay stuff will work?

One possible future advantage of being able to test with custom DTs at
boot time would be for fuzzing (provide random DT properties, see what
happens in the test). We've got some vague plans to support a way of
passing custom data to tests to support this kind of case (though, if
we're using overlays, maybe the test could just patch those if we
wanted to do that).


Cheers,
-- David
