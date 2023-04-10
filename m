Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B53D5254
	for <patches@lists.linux.dev>; Mon, 10 Apr 2023 19:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37DF0C433D2;
	Mon, 10 Apr 2023 19:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1681156268;
	bh=7UdyKJoDo/kvthIXLRm/ILu+Lr9BlKPvI3mhdbfAnZE=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=SKfLS+hKuNaI3wSUAC1b0odjcBilrAp+ARUuBaK45dym1Jt/cTLfn/IQquPE5hglj
	 xoryaxcF2hoityjpBRjA7yXYgQ6rcqcV9Ie1/QskC4UFHY1VtTwwJ6XQQNnwHwaCqH
	 WabraTRfijJUK43eZzssH0XZ0YiM9h03s3BvBL84MkZ1ziX71MprRhNPtGfjU/oMSQ
	 Iv/8yxIFR+exQhCvHi0n3auqmcoEJG3QLvj9pOQ/5VoZoULZPaoh2Iy9hDgvrhGH2K
	 YZ23pxwGxCP2LiYZTgnCkxBD48eDGsE2yM7WNN0mtY+CVLueudErafcq6dJZy/BfOb
	 djBWBBJWwmBpw==
Message-ID: <b975ea0742459609ce43e54af3e0da31.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230406143514.GA3036886-robh@kernel.org>
References: <20230327222159.3509818-1-sboyd@kernel.org> <20230327222159.3509818-3-sboyd@kernel.org> <20230406143514.GA3036886-robh@kernel.org>
Subject: Re: [PATCH v3 02/11] of: Add test managed wrappers for of_overlay_apply()/of_node_put()
From: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Brendan Higgins <brendan.higgins@linux.dev>, David Gow <davidgow@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael J . Wysocki <rafael@kernel.org>, Frank Rowand <frowand.list@gmail.com>, Christian Marangi <ansuelsmth@gmail.com>, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, Maxime Ripard <maxime@cerno.tech>
To: Rob Herring <robh@kernel.org>
Date: Mon, 10 Apr 2023 12:51:04 -0700
User-Agent: alot/0.10

Quoting Rob Herring (2023-04-06 07:35:14)
> On Mon, Mar 27, 2023 at 03:21:50PM -0700, Stephen Boyd wrote:
> > Add test managed wrappers for of_overlay_apply() that automatically
> > removes the overlay when the test is finished. This API is intended for
> > use by KUnit tests that test code which relies on 'struct device_node's
> > and of_*() APIs.
> >=20
> > KUnit tests will call of_overlay_apply_kunit() to load an overlay that's
> > been built into the kernel image. When the test is complete, the overlay
> > will be removed.
>=20
> What if one wants to test the removal part itself?
>=20

We can add an of_overlay_remove_kunit() wrapper API that searches the
KUnit resource list for an 'ovcs_id'. I don't have a need for that API
currently so I didn't add it. As you found out, I used kunit_cleanup()
instead.
