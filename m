Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8261FD3
	for <patches@lists.linux.dev>; Sun,  5 Mar 2023 09:26:56 +0000 (UTC)
Received: by mail-qv1-f47.google.com with SMTP id nf5so4698550qvb.5
        for <patches@lists.linux.dev>; Sun, 05 Mar 2023 01:26:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678008415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mqH/fUNw1v+IeKE/kiXgUEg5Js8jhAM4t/LI9qQb7pQ=;
        b=0/+1fH7K1cQikAm22+gd4H6SThAy3XyaOFRT/jHR8cjM2iJLFOOtvhX3es6yLOQb6w
         taH3pGqUYbrlwFPV3WZm7MDxIAi7lGjN0p5Z89r/zyQBYcBqqMzCpjd2UINCsCMT1zsM
         CE8VvKms/47BiBaIRtzv4ZpK2UrHEHe5K2xHb18wx/PpEgzuT0wWF9X3vP/iUqjwL7v8
         MrwYQwVHv+QXqgrFVNOpPDCjjfb175QVWxEmCTXFUirEOdDnP1H0JHbTkm1A6tqTDxRf
         GbGkUhht/BzxS6zbNYDriK2/YV45yy1mC9NOartdyvquLhj7qcCsHbCzn3w8xCl7cI1J
         J3nQ==
X-Gm-Message-State: AO0yUKUITh/xtu4ti0JR1hQdsT9J45pMue4VuIRSzoLc4waMKxGgUejE
	Cn/+jAZkDWLCyp6dYzYnUgARefcEoB34kA==
X-Google-Smtp-Source: AK7set/vubFSCtBkS6cQ1jdi4GqDkvtBMivQVHk9ztLBAqEHmNqTB0OUKpPErupQb7rW6zlwbfpjyQ==
X-Received: by 2002:a05:6214:410:b0:56e:98a1:fff1 with SMTP id z16-20020a056214041000b0056e98a1fff1mr12059540qvx.7.1678008415292;
        Sun, 05 Mar 2023 01:26:55 -0800 (PST)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com. [209.85.219.174])
        by smtp.gmail.com with ESMTPSA id i3-20020a378603000000b007068b49b8absm5162650qkd.62.2023.03.05.01.26.53
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Mar 2023 01:26:54 -0800 (PST)
Received: by mail-yb1-f174.google.com with SMTP id i6so5440579ybu.8
        for <patches@lists.linux.dev>; Sun, 05 Mar 2023 01:26:53 -0800 (PST)
X-Received: by 2002:a5b:c42:0:b0:a43:52fe:c36f with SMTP id
 d2-20020a5b0c42000000b00a4352fec36fmr3381016ybr.7.1678008413630; Sun, 05 Mar
 2023 01:26:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230302013822.1808711-1-sboyd@kernel.org> <CABVgOSnpMNCtEEsJV28OzUoxdDuiT4a2T0avP0AYf9xFW1jxrw@mail.gmail.com>
 <CAL_JsqJMd3Fi0ZBObdyE1VDKTH1_+smuGDymHnKOkVH2HB3jJQ@mail.gmail.com>
 <3759b28cca7ab751296d4dd83f2dcc51.sboyd@kernel.org> <CAMuHMdXDx6ChRj4xvWbQgcdJd0CGFi-RXySXr=M8QhBkA7YiGw@mail.gmail.com>
 <a2fdbd70-ca44-0d13-5b6f-4177761ecc18@gmail.com>
In-Reply-To: <a2fdbd70-ca44-0d13-5b6f-4177761ecc18@gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sun, 5 Mar 2023 10:26:41 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUMrG9yuXDhDRd+mAUGo5_A6ONjAXXZkJTPXQsO_0C41A@mail.gmail.com>
Message-ID: <CAMuHMdUMrG9yuXDhDRd+mAUGo5_A6ONjAXXZkJTPXQsO_0C41A@mail.gmail.com>
Subject: Re: [PATCH 0/8] clk: Add kunit tests for fixed rate and parent data
To: Frank Rowand <frowand.list@gmail.com>
Cc: Stephen Boyd <sboyd@kernel.org>, David Gow <davidgow@google.com>, 
	Rob Herring <robh+dt@kernel.org>, Michael Turquette <mturquette@baylibre.com>, 
	linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, 
	patches@lists.linux.dev, Brendan Higgins <brendan.higgins@linux.dev>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, 
	Vincent Whitchurch <vincent.whitchurch@axis.com>, Christian Marangi <ansuelsmth@gmail.com>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	kunit-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Frank,

On Sun, Mar 5, 2023 at 4:33=E2=80=AFAM Frank Rowand <frowand.list@gmail.com=
> wrote:
> On 3/2/23 13:47, Geert Uytterhoeven wrote:
> > On Thu, Mar 2, 2023 at 8:28=E2=80=AFPM Stephen Boyd <sboyd@kernel.org> =
wrote:
> >> Quoting Rob Herring (2023-03-02 09:32:09)
> >>> On Thu, Mar 2, 2023 at 2:14=E2=80=AFAM David Gow <davidgow@google.com=
> wrote:
> >>>> On Thu, 2 Mar 2023 at 09:38, Stephen Boyd <sboyd@kernel.org> wrote:
> >>>>> This patch series adds unit tests for the clk fixed rate basic type=
 and
> >>>>> the clk registration functions that use struct clk_parent_data. To =
get
> >>>>> there, we add support for loading a DTB into the UML kernel that's
> >>>>> running the unit tests along with probing platform drivers to bind =
to
> >>>>> device nodes specified in DT.
> >>>>>
> >>>>> With this series, we're able to exercise some of the code in the co=
mmon
> >>>>> clk framework that uses devicetree lookups to find parents and the =
fixed
> >>>>> rate clk code that scans devicetree directly and creates clks. Plea=
se
> >>>>> review.
> >>>>>
> >>>>
> >>>> Thanks Stephen -- this is really neat!
> >>>>
> >>>> This works well here, and I love all of the tests for the
> >>>> KUnit/device-tree integration as well.
> >>>>
> >>>> I'm still looking through the details of it (alas, I've mostly lived
> >>>> in x86-land, so my device-tree knowledge is, uh, spotty to say the
> >>>> least), but apart from possibly renaming some things or similarly
> >>>> minor tweaks, I've not got any real suggestions thus far.
> >>>>
> >>>> I do wonder whether we'll want, on the KUnit side, to have some way =
of
> >>>> supporting KUnit device trees on non-UML architecctures (e.g., if we
> >>>> need to test something architecture-specific, or on a big-endian
> >>>> platform, etc), but I think that's a question for the future, rather
> >>>> than something that affects this series.
> >>>
> >>> I'll say that's a requirement. We should be able to structure the
> >>> tests to not interfere with the running system's DT. The DT unittest
> >>> does that.
> >>
> >> That could be another choice in the unit test choice menu.
> >> CONFIG_OF_KUNIT_NOT_UML that injects some built-in DTB overlay on an
> >> architecture that wants to run tests.
> >
> > As long as you use compatible values that don't exist elsewhere,
> > and don't overwrite anything, you can load your kunit test overlays
> > on any running system that has DT support.
> >
> >>> As a side topic, Is anyone looking at getting UML to work on arm64?
> >>> It's surprising how much x86 stuff there is which is I guess one
> >>> reason it hasn't happened.
> >>
> >> I've no idea but it would be nice indeed.
> >
> > I believe that's non-trivial. At least for arm32 (I didn't have any arm=
64
> > systems last time I asked the experts).
> >
> >>>> Similarly, I wonder if there's something we could do with device tre=
e
> >>>> overlays, in order to make it possible for tests to swap nodes in an=
d
> >>>> out for testing.
> >>>
> >>> Yes, that's how the DT unittest works. But it is pretty much one big
> >>> overlay (ignoring the overlay tests). It could probably be more
> >>> modular where it is apply overlay, test, remove overlay, repeat.
> >>
> >> I didn't want to rely on the overlay code to inject DT nodes. Having
> >> tests written for the fake KUnit machine is simple. It closely matches
> >> how clk code probes the DTB and how nodes are created and populated on
> >> the platform bus as devices. CLK_OF_DECLARE() would need the overlay t=
o
> >> be applied early too, which doesn't happen otherwise as far as I know.
> >
> > Don't all generic clock drivers also create a platform driver?
> > At least drivers/clk/clk-fixed-factor.c does.
> >
> >> But perhaps this design is too much of an end-to-end test and not a un=
it
> >> test? In the spirit of unit testing we shouldn't care about how the no=
de
> >> is added to the live devicetree, just that there is a devicetree at al=
l.
> >>
> >> Supporting overlays to more easily test combinations sounds like a goo=
d
> >> idea. Probably some kunit_*() prefixed functions could be used to
> >> apply a test managed overlay and automatically remove it when the test
> >> is over would work. The clk registration tests could use this API to
> >> inject an overlay and then manually call the of_platform_populate()
> >> function to create the platform device(s). The overlay could be built =
in
> >> drivers/clk/ too and then probably some macroish function can find the
> >> blob and apply it.
> >
> > No need to manually call of_platform_populate() to create the
> > platform devices. That is taken care of automatically when applying
> > an overlay.
> >
> >> Is there some way to delete the platform devices that we populate from
> >> the overlay? I'd like the tests to be hermetic.
>
> > Removing the overlay will delete the platform devices.
>
> I _think_ that is incorrect.  Do you have a pointer to the overlay code t=
hat
> deletes the device?  (If I remember correctly, the overlay remove code do=
es not
> even check whether the device exists and whether a driver is bound to it =
-- but
> this is on my todo list to look into.)

https://elixir.bootlin.com/linux/latest/source/drivers/of/platform.c#L769

> > All of that works if you have your own code to apply a DT overlay.
> > The recent fw_devlinks patches did cause some regressions, cfr.
> > https://lore.kernel.org/all/CAMuHMdXEnSD4rRJ-o90x4OprUacN_rJgyo8x6=3D9F=
9rZ+-KzjOg@mail.gmail.com

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
