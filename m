Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6901D386
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 22:37:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F1AC4339B;
	Tue,  7 Mar 2023 22:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678228629;
	bh=yV79Mc+v/FOShDjIEWDI434bJNFY5/ObJuF77GytpaE=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=WeeJ6fRxvuoPXWuThLtc3lz/XAnCkWIo6kOH9FgzeiJIEbbgekicuM0h80f7aWkaG
	 JyNa6ivjBtTMrtx7HgQm4i4+8B5YcszdpHBeZ/pdWcANJfi/eDvnPQz/sa4r7JzyEI
	 mOz1d4bhN7IkRq5OZPq00YJqnkFjRA9PNhMam2rO/T0ixEjQuHyMnIv+d50qgHpri8
	 j0tOX6fM8A/4VA5er2WociJwN80RV0r7VSZugesRxHpLj5fIPVMxs116xAck4wIrBR
	 HNgJanRuB5sfsWnZMSeTqNd9GCHmuL6eC8tBHUI/HOybZGT3EHU1KGysHQsDuDMwAc
	 7HMwqonU7WfMQ==
Message-ID: <aed13be6944e4ab9cc1f567aeb3df171.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230303143835.hxvkujrdxh7345ah@houat>
References: <20230302013822.1808711-1-sboyd@kernel.org> <20230303143835.hxvkujrdxh7345ah@houat>
Subject: Re: [PATCH 0/8] clk: Add kunit tests for fixed rate and parent data
From: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Brendan Higgins <brendan.higgins@linux.dev>, David Gow <davidgow@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael J . Wysocki <rafael@kernel.org>, Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, Vincent Whitchurch <vincent.whitchurch@axis.com>, Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>, Christian Marangi <ansuelsmth@gmail.com>, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, linux-um@lists.infradead.org, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com
To: Maxime Ripard <maxime@cerno.tech>
Date: Tue, 07 Mar 2023 14:37:06 -0800
User-Agent: alot/0.10

Quoting Maxime Ripard (2023-03-03 06:38:35)
> Hi,
>=20
> On Wed, Mar 01, 2023 at 05:38:13PM -0800, Stephen Boyd wrote:
> > This patch series adds unit tests for the clk fixed rate basic type and
> > the clk registration functions that use struct clk_parent_data. To get
> > there, we add support for loading a DTB into the UML kernel that's
> > running the unit tests along with probing platform drivers to bind to
> > device nodes specified in DT.
> >=20
> > With this series, we're able to exercise some of the code in the common
> > clk framework that uses devicetree lookups to find parents and the fixed
> > rate clk code that scans devicetree directly and creates clks. Please
> > review.
> >=20
> > I Cced everyone to all the patches so they get the full context. I'm
> > hoping I can take the whole pile through the clk tree as they almost all
> > depend on each other. In the future I imagine it will be easy to add
> > more test nodes to the clk.dtsi file and not need to go across various
> > maintainer trees like this series does.
>=20
> That's really great, thanks!
>=20
> I wanted to have a look at how we could possibly do this for DRM, I
> guess I have a starting point now :)
>=20

Cool, thanks. You're on Cc now.
