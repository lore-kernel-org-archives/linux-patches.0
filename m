Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E947494
	for <patches@lists.linux.dev>; Fri, 17 Mar 2023 18:13:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9641BC433D2;
	Fri, 17 Mar 2023 18:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1679076785;
	bh=pezB65uNoMFI+1yoWavs7bX/rlsFwVd9xoiaFcZ2Mug=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=f2Gqqto9cZAFA0aKT4pmi4EAwSPBpNzZO13fONlCOfWBXkxWaSsD+9i/5e7NhyCw8
	 pU29xa5fiET3KhneSRS0J23/KzpsG9A/JxcmdYywx63MO6XCUTRYFMoqSSzwrfmi/x
	 OGW/EzHMfQ/+LCDMGTxQxBQThNyNuvFw+qhTnHhyWG9orVo5HLM6N/ydxJp2u7kD/3
	 Xs6Q+jvx4EJy2WH8QwfhK3BK4xMjkAgQyJU3cVbS73rAOQgwpWQkKq1iuGSBg2g6Tz
	 pwFNIHuzq8fkfpMAzslttpTU9gw5dcvOk35OllHXiEbRf+vhC1NsJYEsSoc9lTb9FM
	 qfmlPwuNLWZbQ==
Message-ID: <6a4c0758f773c648282dd9ab39fdf59b.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230317083951.oaupqybf7llrpmeo@houat>
References: <20230315183729.2376178-1-sboyd@kernel.org> <20230317083951.oaupqybf7llrpmeo@houat>
Subject: Re: [PATCH v2 00/11] clk: Add kunit tests for fixed rate and parent data
From: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Brendan Higgins <brendan.higgins@linux.dev>, David Gow <davidgow@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael J . Wysocki <rafael@kernel.org>, Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>, Christian Marangi <ansuelsmth@gmail.com>, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com
To: Maxime Ripard <maxime@cerno.tech>
Date: Fri, 17 Mar 2023 11:13:03 -0700
User-Agent: alot/0.10

Quoting Maxime Ripard (2023-03-17 01:39:51)
> Hi,
>=20
> On Wed, Mar 15, 2023 at 11:37:17AM -0700, Stephen Boyd wrote:
> > This patch series adds unit tests for the clk fixed rate basic type and
> > the clk registration functions that use struct clk_parent_data. To get
> > there, we add support for loading device tree overlays onto the live DTB
> > along with probing platform drivers to bind to device nodes in the
> > overlays. With this series, we're able to exercise some of the code in
> > the common clk framework that uses devicetree lookups to find parents
> > and the fixed rate clk code that scans device tree directly and creates
> > clks. Please review.
> >=20
> > I Cced everyone to all the patches so they get the full context. I'm
> > hoping I can take the whole pile through the clk tree as they almost all
> > depend on each other.
> >=20
> > Changes from v1 (https://lore.kernel.org/r/20230302013822.1808711-1-sbo=
yd@kernel.org):
> >  * Don't depend on UML, use unittest data approach to attach nodes
> >  * Introduce overlay loading API for KUnit
> >  * Move platform_device KUnit code to drivers/base/test
> >  * Use #define macros for constants shared between unit tests and
> >    overlays
> >  * Settle on "test" as a vendor prefix
> >  * Make KUnit wrappers have "_kunit" postfix
>=20
> Maybe I'm overthinking this, but wouldn't it make more sense to have a
> kunit *prefix* to those functions? Any other function in the kernel
> taking a kunit test pointer as a parameter starts with kunit (like
> kunit_kzalloc), so it would make more sense to me that kunit-related clk
> functions follow the same pattern.
>=20

See this thread on v1

 https://lore.kernel.org/all/CABVgOSk4gEob3rokKF_p2Bcd_Sj3ikUN4R-HPHyTR0Eoo=
=3D=3D85g@mail.gmail.com/
