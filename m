Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CCD8F40
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 17:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F34C433A4
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 17:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1677778341;
	bh=GTJ2aQ3riMffZdwM0TI7yU15Vojy5MM+NJ9vt/TT/F8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Xl/Kb/AiIzIGvNjcW8Mpe7/u31VvlNm0hQniH3f0qe/1BtDnJJQP+MWebtnBbn/bd
	 gy5xMHBVpioacbJsLxW6YKNfizW0exBkhXw0IlBODB/uue1wzkeZ0zUmPAU1uzGvMb
	 CCV/jsE+X4GFcS8sBnC1CWEbnFBkKYaur1xgdLLVBvtNd49AGpRJdREIh3S2h0/t4r
	 pS+Bs1Og6RR3jISL3snLEVZ1j1YeOs+LVpaQKepeCFUXq0/iET29fJO/XpMrbQfqnq
	 szfunjHE5lTWgLRhV5GmqnaUJGg5ocRvxw3VeQLqcfqOfqa4V6pMCsw7l5dmZA8pHO
	 VIAhPAzzKHfAg==
Received: by mail-ua1-f47.google.com with SMTP id f20so6688525uam.3
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 09:32:21 -0800 (PST)
X-Gm-Message-State: AO0yUKWXW4UgIC9//rY3Xh9IfsPo6ipD97PJJjPA22lv5GZz37Ro1Nvi
	/gasHDwatgCK8v5QITWpRf2p9UR4b9cAd2x2QA==
X-Google-Smtp-Source: AK7set9cJNTLFs7vnxVEO6Bi3x0FdUJU0jGThLV7OqyoaC6mAU8o5RUYHWKZMVbAQOB16m3naYT+V+2VGB6kWOMhcf4=
X-Received: by 2002:a1f:a3d7:0:b0:40d:526d:5633 with SMTP id
 m206-20020a1fa3d7000000b0040d526d5633mr6082295vke.2.1677778340294; Thu, 02
 Mar 2023 09:32:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230302013822.1808711-1-sboyd@kernel.org> <CABVgOSnpMNCtEEsJV28OzUoxdDuiT4a2T0avP0AYf9xFW1jxrw@mail.gmail.com>
In-Reply-To: <CABVgOSnpMNCtEEsJV28OzUoxdDuiT4a2T0avP0AYf9xFW1jxrw@mail.gmail.com>
From: Rob Herring <robh+dt@kernel.org>
Date: Thu, 2 Mar 2023 11:32:09 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJMd3Fi0ZBObdyE1VDKTH1_+smuGDymHnKOkVH2HB3jJQ@mail.gmail.com>
Message-ID: <CAL_JsqJMd3Fi0ZBObdyE1VDKTH1_+smuGDymHnKOkVH2HB3jJQ@mail.gmail.com>
Subject: Re: [PATCH 0/8] clk: Add kunit tests for fixed rate and parent data
To: David Gow <davidgow@google.com>, Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, 
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

On Thu, Mar 2, 2023 at 2:14=E2=80=AFAM David Gow <davidgow@google.com> wrot=
e:
>
> On Thu, 2 Mar 2023 at 09:38, Stephen Boyd <sboyd@kernel.org> wrote:
> >
> > This patch series adds unit tests for the clk fixed rate basic type and
> > the clk registration functions that use struct clk_parent_data. To get
> > there, we add support for loading a DTB into the UML kernel that's
> > running the unit tests along with probing platform drivers to bind to
> > device nodes specified in DT.
> >
> > With this series, we're able to exercise some of the code in the common
> > clk framework that uses devicetree lookups to find parents and the fixe=
d
> > rate clk code that scans devicetree directly and creates clks. Please
> > review.
> >
>
> Thanks Stephen -- this is really neat!
>
> This works well here, and I love all of the tests for the
> KUnit/device-tree integration as well.
>
> I'm still looking through the details of it (alas, I've mostly lived
> in x86-land, so my device-tree knowledge is, uh, spotty to say the
> least), but apart from possibly renaming some things or similarly
> minor tweaks, I've not got any real suggestions thus far.
>
> I do wonder whether we'll want, on the KUnit side, to have some way of
> supporting KUnit device trees on non-UML architecctures (e.g., if we
> need to test something architecture-specific, or on a big-endian
> platform, etc), but I think that's a question for the future, rather
> than something that affects this series.

I'll say that's a requirement. We should be able to structure the
tests to not interfere with the running system's DT. The DT unittest
does that.

As a side topic, Is anyone looking at getting UML to work on arm64?
It's surprising how much x86 stuff there is which is I guess one
reason it hasn't happened.

> Similarly, I wonder if there's something we could do with device tree
> overlays, in order to make it possible for tests to swap nodes in and
> out for testing.

Yes, that's how the DT unittest works. But it is pretty much one big
overlay (ignoring the overlay tests). It could probably be more
modular where it is apply overlay, test, remove overlay, repeat.

Rob
