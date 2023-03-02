Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67DE10FA
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 19:27:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50ADDC433EF;
	Thu,  2 Mar 2023 19:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1677785270;
	bh=iyC6HQCgrOqOU/tJPSjqESyv0i0TAnEqDuPtF5qLScE=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=W9TNNc2hTd4FfQi8Ddf7VRg4q9X17FRXQ1898GO5FUvD2bd28NR27DJ1myYkTzBKN
	 9V2tyGYTRzxeOlswmx6LWYMbwER3XYJAAYj49fmRlpfgCD7WlZskD7Y9vu/U31T1zy
	 CnM8J8sfsNRH62Bap5KDqBKrwWy2jDa2Rh2C7gIOuD0aS1bSrvWVb+I74A2GFt81UY
	 yL4Ivqvg+NfgKDHjTLbWTZninZRMAi1VbMf/fzfScjB28WwnCgCnmm+8eDKcqAxz+4
	 w+CvbQaPcO6SCy+Ro7KByP5uVlCJtznjqBlSrs9Nb7ZMNxSFGWyzOYLaZbCts7Llba
	 h0u9TcCnz8zkw==
Message-ID: <3759b28cca7ab751296d4dd83f2dcc51.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAL_JsqJMd3Fi0ZBObdyE1VDKTH1_+smuGDymHnKOkVH2HB3jJQ@mail.gmail.com>
References: <20230302013822.1808711-1-sboyd@kernel.org> <CABVgOSnpMNCtEEsJV28OzUoxdDuiT4a2T0avP0AYf9xFW1jxrw@mail.gmail.com> <CAL_JsqJMd3Fi0ZBObdyE1VDKTH1_+smuGDymHnKOkVH2HB3jJQ@mail.gmail.com>
Subject: Re: [PATCH 0/8] clk: Add kunit tests for fixed rate and parent data
From: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Brendan Higgins <brendan.higgins@linux.dev>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael J . Wysocki <rafael@kernel.org>, Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, Vincent Whitchurch <vincent.whitchurch@axis.com>, Frank Rowand <frowand.list@gmail.com>, Christian Marangi <ansuelsmth@gmail.com>, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, linux-um@lists.infradead.org, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com
To: David Gow <davidgow@google.com>, Rob Herring <robh+dt@kernel.org>
Date: Thu, 02 Mar 2023 11:27:47 -0800
User-Agent: alot/0.10

Quoting Rob Herring (2023-03-02 09:32:09)
> On Thu, Mar 2, 2023 at 2:14=E2=80=AFAM David Gow <davidgow@google.com> wr=
ote:
> >
> > On Thu, 2 Mar 2023 at 09:38, Stephen Boyd <sboyd@kernel.org> wrote:
> > >
> > > This patch series adds unit tests for the clk fixed rate basic type a=
nd
> > > the clk registration functions that use struct clk_parent_data. To get
> > > there, we add support for loading a DTB into the UML kernel that's
> > > running the unit tests along with probing platform drivers to bind to
> > > device nodes specified in DT.
> > >
> > > With this series, we're able to exercise some of the code in the comm=
on
> > > clk framework that uses devicetree lookups to find parents and the fi=
xed
> > > rate clk code that scans devicetree directly and creates clks. Please
> > > review.
> > >
> >
> > Thanks Stephen -- this is really neat!
> >
> > This works well here, and I love all of the tests for the
> > KUnit/device-tree integration as well.
> >
> > I'm still looking through the details of it (alas, I've mostly lived
> > in x86-land, so my device-tree knowledge is, uh, spotty to say the
> > least), but apart from possibly renaming some things or similarly
> > minor tweaks, I've not got any real suggestions thus far.
> >
> > I do wonder whether we'll want, on the KUnit side, to have some way of
> > supporting KUnit device trees on non-UML architecctures (e.g., if we
> > need to test something architecture-specific, or on a big-endian
> > platform, etc), but I think that's a question for the future, rather
> > than something that affects this series.
>=20
> I'll say that's a requirement. We should be able to structure the
> tests to not interfere with the running system's DT. The DT unittest
> does that.

That could be another choice in the unit test choice menu.
CONFIG_OF_KUNIT_NOT_UML that injects some built-in DTB overlay on an
architecture that wants to run tests.

>=20
> As a side topic, Is anyone looking at getting UML to work on arm64?
> It's surprising how much x86 stuff there is which is I guess one
> reason it hasn't happened.

I've no idea but it would be nice indeed.

>=20
> > Similarly, I wonder if there's something we could do with device tree
> > overlays, in order to make it possible for tests to swap nodes in and
> > out for testing.
>=20
> Yes, that's how the DT unittest works. But it is pretty much one big
> overlay (ignoring the overlay tests). It could probably be more
> modular where it is apply overlay, test, remove overlay, repeat.
>=20

I didn't want to rely on the overlay code to inject DT nodes. Having
tests written for the fake KUnit machine is simple. It closely matches
how clk code probes the DTB and how nodes are created and populated on
the platform bus as devices. CLK_OF_DECLARE() would need the overlay to
be applied early too, which doesn't happen otherwise as far as I know.

But perhaps this design is too much of an end-to-end test and not a unit
test? In the spirit of unit testing we shouldn't care about how the node
is added to the live devicetree, just that there is a devicetree at all.

Supporting overlays to more easily test combinations sounds like a good
idea. Probably some kunit_*() prefixed functions could be used to
apply a test managed overlay and automatically remove it when the test
is over would work. The clk registration tests could use this API to
inject an overlay and then manually call the of_platform_populate()
function to create the platform device(s). The overlay could be built in
drivers/clk/ too and then probably some macroish function can find the
blob and apply it.

Is there some way to delete the platform devices that we populate from
the overlay? I'd like the tests to be hermetic.
