Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81B210FA
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 19:53:27 +0000 (UTC)
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-1720433ba75so637006fac.5
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 11:53:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f95O1774ZoBykD/usZaosY+efoKseNjJy4cpA8XSzCQ=;
        b=R4hqN0g0GE8Tbgy7f6JX/1kh3786XwE0oH7sRql2WaS6xgsl+Tef7tK2HMSKhcbN4i
         AeENneQ12ZKTSV/2tjicbm8GaoSawJjciMuaxdP/T1b35AIeLw9ItnZZP8F+5jKxdP5C
         w8oJ7g4A1G3aMgv+Zv4FUFP8cdsWkz44HS3UDPVPkImZ2F9YRKfDaInZNbGftSLluPmc
         UOWx4UZDK/VsUPLbxmfGe4oIepBiF5O1pYIGOpHh36rUxNBa6IQUEkdLMtX/3FbWOa6a
         IoHeFEGQVxqXppHzkeuy59G7F48jkD2monsN+1CySgHoPgLVyeSEcIoBe/YSu+ko5nDe
         s+Tw==
X-Gm-Message-State: AO0yUKU7c0X9bwt+MyRNXcICO8j8d+CRlNvqu39teDM3K+7GwiFl/q+J
	TIAU2GlyCO5H35ZGQDuHBJB/R8nbh6ihEA==
X-Google-Smtp-Source: AK7set8X20OhtL4WcIzo1V181NAtqZX72IK5quJBx4AOwHEcOnrneezyp9xtewok9g5ml4v2VpF5Pg==
X-Received: by 2002:a05:6870:3486:b0:176:308b:5398 with SMTP id n6-20020a056870348600b00176308b5398mr3096492oah.51.1677786806649;
        Thu, 02 Mar 2023 11:53:26 -0800 (PST)
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com. [209.85.161.41])
        by smtp.gmail.com with ESMTPSA id i17-20020a056870d41100b001723f29f6e2sm237119oag.37.2023.03.02.11.53.26
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Mar 2023 11:53:26 -0800 (PST)
Received: by mail-oo1-f41.google.com with SMTP id c184-20020a4a4fc1000000b005250b2dc0easo102386oob.2
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 11:53:26 -0800 (PST)
X-Received: by 2002:a81:ad1b:0:b0:52f:1c23:ef1 with SMTP id
 l27-20020a81ad1b000000b0052f1c230ef1mr7066170ywh.5.1677786463634; Thu, 02 Mar
 2023 11:47:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230302013822.1808711-1-sboyd@kernel.org> <CABVgOSnpMNCtEEsJV28OzUoxdDuiT4a2T0avP0AYf9xFW1jxrw@mail.gmail.com>
 <CAL_JsqJMd3Fi0ZBObdyE1VDKTH1_+smuGDymHnKOkVH2HB3jJQ@mail.gmail.com> <3759b28cca7ab751296d4dd83f2dcc51.sboyd@kernel.org>
In-Reply-To: <3759b28cca7ab751296d4dd83f2dcc51.sboyd@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 2 Mar 2023 20:47:32 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXDx6ChRj4xvWbQgcdJd0CGFi-RXySXr=M8QhBkA7YiGw@mail.gmail.com>
Message-ID: <CAMuHMdXDx6ChRj4xvWbQgcdJd0CGFi-RXySXr=M8QhBkA7YiGw@mail.gmail.com>
Subject: Re: [PATCH 0/8] clk: Add kunit tests for fixed rate and parent data
To: Stephen Boyd <sboyd@kernel.org>
Cc: David Gow <davidgow@google.com>, Rob Herring <robh+dt@kernel.org>, 
	Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, 
	linux-clk@vger.kernel.org, patches@lists.linux.dev, 
	Brendan Higgins <brendan.higgins@linux.dev>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Vincent Whitchurch <vincent.whitchurch@axis.com>, Frank Rowand <frowand.list@gmail.com>, 
	Christian Marangi <ansuelsmth@gmail.com>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	kunit-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

On Thu, Mar 2, 2023 at 8:28=E2=80=AFPM Stephen Boyd <sboyd@kernel.org> wrot=
e:
> Quoting Rob Herring (2023-03-02 09:32:09)
> > On Thu, Mar 2, 2023 at 2:14=E2=80=AFAM David Gow <davidgow@google.com> =
wrote:
> > > On Thu, 2 Mar 2023 at 09:38, Stephen Boyd <sboyd@kernel.org> wrote:
> > > > This patch series adds unit tests for the clk fixed rate basic type=
 and
> > > > the clk registration functions that use struct clk_parent_data. To =
get
> > > > there, we add support for loading a DTB into the UML kernel that's
> > > > running the unit tests along with probing platform drivers to bind =
to
> > > > device nodes specified in DT.
> > > >
> > > > With this series, we're able to exercise some of the code in the co=
mmon
> > > > clk framework that uses devicetree lookups to find parents and the =
fixed
> > > > rate clk code that scans devicetree directly and creates clks. Plea=
se
> > > > review.
> > > >
> > >
> > > Thanks Stephen -- this is really neat!
> > >
> > > This works well here, and I love all of the tests for the
> > > KUnit/device-tree integration as well.
> > >
> > > I'm still looking through the details of it (alas, I've mostly lived
> > > in x86-land, so my device-tree knowledge is, uh, spotty to say the
> > > least), but apart from possibly renaming some things or similarly
> > > minor tweaks, I've not got any real suggestions thus far.
> > >
> > > I do wonder whether we'll want, on the KUnit side, to have some way o=
f
> > > supporting KUnit device trees on non-UML architecctures (e.g., if we
> > > need to test something architecture-specific, or on a big-endian
> > > platform, etc), but I think that's a question for the future, rather
> > > than something that affects this series.
> >
> > I'll say that's a requirement. We should be able to structure the
> > tests to not interfere with the running system's DT. The DT unittest
> > does that.
>
> That could be another choice in the unit test choice menu.
> CONFIG_OF_KUNIT_NOT_UML that injects some built-in DTB overlay on an
> architecture that wants to run tests.

As long as you use compatible values that don't exist elsewhere,
and don't overwrite anything, you can load your kunit test overlays
on any running system that has DT support.

> > As a side topic, Is anyone looking at getting UML to work on arm64?
> > It's surprising how much x86 stuff there is which is I guess one
> > reason it hasn't happened.
>
> I've no idea but it would be nice indeed.

I believe that's non-trivial. At least for arm32 (I didn't have any arm64
systems last time I asked the experts).

> > > Similarly, I wonder if there's something we could do with device tree
> > > overlays, in order to make it possible for tests to swap nodes in and
> > > out for testing.
> >
> > Yes, that's how the DT unittest works. But it is pretty much one big
> > overlay (ignoring the overlay tests). It could probably be more
> > modular where it is apply overlay, test, remove overlay, repeat.
>
> I didn't want to rely on the overlay code to inject DT nodes. Having
> tests written for the fake KUnit machine is simple. It closely matches
> how clk code probes the DTB and how nodes are created and populated on
> the platform bus as devices. CLK_OF_DECLARE() would need the overlay to
> be applied early too, which doesn't happen otherwise as far as I know.

Don't all generic clock drivers also create a platform driver?
At least drivers/clk/clk-fixed-factor.c does.

> But perhaps this design is too much of an end-to-end test and not a unit
> test? In the spirit of unit testing we shouldn't care about how the node
> is added to the live devicetree, just that there is a devicetree at all.
>
> Supporting overlays to more easily test combinations sounds like a good
> idea. Probably some kunit_*() prefixed functions could be used to
> apply a test managed overlay and automatically remove it when the test
> is over would work. The clk registration tests could use this API to
> inject an overlay and then manually call the of_platform_populate()
> function to create the platform device(s). The overlay could be built in
> drivers/clk/ too and then probably some macroish function can find the
> blob and apply it.

No need to manually call of_platform_populate() to create the
platform devices. That is taken care of automatically when applying
an overlay.

> Is there some way to delete the platform devices that we populate from
> the overlay? I'd like the tests to be hermetic.

Removing the overlay will delete the platform devices.

All of that works if you have your own code to apply a DT overlay.
The recent fw_devlinks patches did cause some regressions, cfr.
https://lore.kernel.org/all/CAMuHMdXEnSD4rRJ-o90x4OprUacN_rJgyo8x6=3D9F9rZ+=
-KzjOg@mail.gmail.com

P.S. Shameless plug: for loading overlays from userspace, there are
     my overlay branches, cfr. https://elinux.org/R-Car/DT-Overlays

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
