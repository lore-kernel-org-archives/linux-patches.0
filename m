Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AC6D530
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 20:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0894C433EF;
	Tue, 21 Mar 2023 20:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1679430218;
	bh=EDfXUG+E1EZk+5BCveQ844rTK7Bhe+UE1QVatYkNmAg=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=qXFxJuLZyWtwZ4LS0WrsEQSY1r/dx5Ib+d49jY/PHgmxHP8uBGZ/BX+gftM4VOLYy
	 VKyzOOd3f05DS3murzRd3o5PJeZRH8CWl5NY3wtPx0tG0KcojHPU4w1e/6sZbtRyQh
	 hbuPgtTI5F0ml0sEEm3Zwvm2oPQfSpewiNNY8ee0anOVRLZFhjll5M6WLziZ7JY15i
	 qU8BDNZ7LqcLrQLIP6XrFo+oNDkcoFfIYHpSWz56i2rtuqU+2Q4jVDiLs5WSsS0iM+
	 iRb9vtLac0hVrtOl1HgCrq5rFiUIc5WtSAZhMB92CrzUx15pXA71RWOfAXRoHeHUXR
	 O2lydpuk9gvIw==
Message-ID: <ebac292d86a91151037f67f6d8738c06.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230321201446.GA1401650-robh@kernel.org>
References: <20230315183729.2376178-1-sboyd@kernel.org> <20230315183729.2376178-8-sboyd@kernel.org> <20230321201446.GA1401650-robh@kernel.org>
Subject: Re: [PATCH v2 07/11] dt-bindings: kunit: Add fixed rate clk consumer test
From: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Brendan Higgins <brendan.higgins@linux.dev>, David Gow <davidgow@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael J . Wysocki <rafael@kernel.org>, Frank Rowand <frowand.list@gmail.com>, Christian Marangi <ansuelsmth@gmail.com>, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, Maxime Ripard <maxime@cerno.tech>
To: Rob Herring <robh@kernel.org>
Date: Tue, 21 Mar 2023 13:23:35 -0700
User-Agent: alot/0.10

Quoting Rob Herring (2023-03-21 13:14:46)
> On Wed, Mar 15, 2023 at 11:37:24AM -0700, Stephen Boyd wrote:
> > Describe a binding for a device that consumes a fixed rate clk in DT so
> > that a KUnit test can get the clk registered by of_fixed_clk_setup() and
> > test that it is setup properly.
> >=20
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
> > Cc: Brendan Higgins <brendan.higgins@linux.dev>
> > Cc: David Gow <davidgow@google.com>
> > Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> > ---
> >  .../kunit/test,clk-kunit-fixed-rate.yaml      | 35 +++++++++++++++++++
>=20
> Some stuff in test and some in kunit? I prefer 'test'.

So only a test directory? Ok.

>=20
> >  1 file changed, 35 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/kunit/test,clk-ku=
nit-fixed-rate.yaml
> >=20
> > diff --git a/Documentation/devicetree/bindings/kunit/test,clk-kunit-fix=
ed-rate.yaml b/Documentation/devicetree/bindings/kunit/test,clk-kunit-fixed=
-rate.yaml
> > new file mode 100644
> > index 000000000000..58d7826d9c14
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/kunit/test,clk-kunit-fixed-rate=
.yaml
> > @@ -0,0 +1,35 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/kunit/test,clk-kunit-fixed-rate.yam=
l#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: KUnit clk fixed rate test clk consumer
> > +
> > +maintainers:
> > +  - Stephen Boyd <sboyd@kernel.org>
> > +
> > +description: |
>=20
> Drop '|'
>=20
> > +  A clk consumer of a fixed rate clk used to test the fixed rate clk
> > +  implementation in the Linux kernel.
> > +
> > +properties:
> > +  compatible:
> > +    const: test,clk-kunit-fixed-rate
>=20
> I tend to think we should drop 'kunit' from these bindings. You could=20
> use this for different test frameworks.=20

Sure.
