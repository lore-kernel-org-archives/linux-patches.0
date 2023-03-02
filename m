Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AFD10780
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 23:57:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85E0C433EF;
	Thu,  2 Mar 2023 23:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1677801473;
	bh=rP97/gxcUgIzVw2/zflmEvcxaTNRmSxPr4nvJj5LxFc=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=VU4ED0833nbbikLiSfmCfXKKPc3yRM7uf0lPta6lzW85yw4lWn6Zl15oa4VALjSIh
	 b06mkplVYY8SBUQREkQCVvsmcqTRdSkEbw09VTYyC1vJWuY5AHI+l7JzI8tkpiUkoi
	 LgGE/ysSU5cv8HobDFRZMP6veq5LkFZKkCDWukP8hWIO5FLBMgegGFzNO4rSpUw+7v
	 V+FYvfMzAJa2N2gNY0cKVlJ8p7y+9YN0pLP9UdcpKHAQFwCWTsRvNzwGLSS9/q59tj
	 VDXNEImpMm9uw8x1jvRev8oGlHBUnKZe87YiUVjgWWRwD61eOzfujPEJfwCf9CkFHw
	 7cxPHmGrPcxZA==
Message-ID: <ecb5ede44d5bcc0430dad99e53d4477d.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAL_JsqLdPWRLu8TNqCG+dw9Pz2cS798QwGX=C5X18KKqAXwjSQ@mail.gmail.com>
References: <20230302013822.1808711-1-sboyd@kernel.org> <CAL_JsqLVQVZhYTSZgrvA-V-xOUbiBdyDxqPOZk=89YS33EahBQ@mail.gmail.com> <093867df6137ad9e964b7dd90fb58f1a.sboyd@kernel.org> <CAL_JsqLdPWRLu8TNqCG+dw9Pz2cS798QwGX=C5X18KKqAXwjSQ@mail.gmail.com>
Subject: Re: [PATCH 0/8] clk: Add kunit tests for fixed rate and parent data
From: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Brendan Higgins <brendan.higgins@linux.dev>, David Gow <davidgow@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael J . Wysocki <rafael@kernel.org>, Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, Vincent Whitchurch <vincent.whitchurch@axis.com>, Frank Rowand <frowand.list@gmail.com>, Christian Marangi <ansuelsmth@gmail.com>, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, linux-um@lists.infradead.org, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com
To: Rob Herring <robh+dt@kernel.org>
Date: Thu, 02 Mar 2023 15:57:50 -0800
User-Agent: alot/0.10

Quoting Rob Herring (2023-03-02 12:18:34)
> On Thu, Mar 2, 2023 at 1:44=E2=80=AFPM Stephen Boyd <sboyd@kernel.org> wr=
ote:
> >
> > Quoting Rob Herring (2023-03-02 09:13:59)
> > >
> > > Good to see bindings for this. I've been meaning to do something about
> > > the DT unittest ones being undocumented, but I hadn't really decided
> > > whether it was worth writing schemas for them. The compatibles at
> > > least show up with 'make dt_compatible_check'. Perhaps we want to just
> > > define some vendor (not 'linux') that's an exception rather than
> > > requiring schemas (actually, that already works for 'foo').
> >
> > Sure. Maybe "kunit" should be the vendor prefix? Or "dtbunit"?
>=20
> We'd want to use the same thing on the DT unittests or anything else
> potentially. How about just 'test'?

Sounds good.

>=20
> > > It's
> > > likely that we want test DTs that fail normal checks and schemas get
> > > in the way of that as we don't have a way to turn off checks.
> >
> > Having the schemas is nice to make sure tests that are expecting some
> > binding are actually getting that. But supporting broken bindings is
> > also important to test any error paths in functions that parse
> > properties. Maybe we keep the schema and have it enforce that incorrect
> > properties are being set?
>=20
> I wasn't suggesting throwing them out. More why I hadn't written any I gu=
ess.
>=20
> > Do we really need to test incorrect bindings? Doesn't the
> > dt_bindings_check catch these problems so we don't have to write DTB
> > verifiers in the kernel?
>=20
> Fair enough. Using my frequently stated position against me. :)
>=20
> I do have a secret plan to implement (debug) type checks into the
> of_property_* APIs by extracting the type information from schemas
> into C.
>=20

Ok. I suspect we may want to test error paths though so I don't know
what to do here. For now I'll just leave the bindings in place and
change the prefix to "test".

>=20
> > > We already have GPIO tests in the DT unittests, so why is clocks
> > > different? Or should the GPIO tests be moved out (yes, please!)?
> >
> > Ah I didn't notice the GPIO tests in there. There are i2c tests too,
> > right? All I can say is clks are using kunit, that's the difference ;-)
>=20
> Yeah, they should perhaps all move to the subsystems.

Got it.

>=20
> > > What happens when/if the DT unittest is converted to kunit? I think
> > > that would look confusing from the naming. My initial thought is
> > > 'kunit' should be dropped from the naming of a lot of this. Note that
> > > the original kunit submission converted the DT unittests. I would
> > > still like to see that happen. Frank disagreed over what's a unit test
> > > or not, then agreed, then didn't... I don't really care. If there's a
> > > framework to use, then we should use it IMO.
> >
> > Honestly I don't want to get involved in migrating the existing DT
> > unittest code to kunit. I'm aware that it was attempted years ago when
> > kunit was introduced. Maybe if the overlay route works well enough I can
> > completely sidestep introducing any code in drivers/of/ besides some
> > kunit wrappers for this. I'll cross my fingers!
>=20
> Yeah, I wasn't expecting you to. I just want to make sure this meshes
> with any future conversion to kunit.

Phew!

>=20
> There's also some plans to always populate the DT root node if not
> present. That may help here. Or not. There's been a few versions
> posted with Frank's in the last week or 2.
>=20

Ok. I think I have some time to try this overlay approach so let me see
what is needed.
