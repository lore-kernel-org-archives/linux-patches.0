Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C9DC26E
	for <patches@lists.linux.dev>; Thu,  9 Mar 2023 23:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831E8C433EF;
	Thu,  9 Mar 2023 23:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678403545;
	bh=f+qMFQyBJuGy7W7kgvaRQla+UTKn55+cGr82WqQnciU=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=b2++4c//Y55ZukR8/hTB2Y009ekLicBGFc1mqBFO4WOH+oyM5+NrQKdQPGUksC/m4
	 gKe6mfII8jgFrcHGdXYYlj2wJXUWY8M09dvExa8pPv2o2n3pNroC6O9+ohqvW5sIz0
	 4Tl3KOPN2THBScSXZ/jYdHyafdYUmi6QVZNR4ieT2DXclG66la4fAp6EDWvt5Ye07x
	 heUP0TlcA9ydJnRZeCxtpw3xxv3/1mkqwU9eZdYgQl8oaHiZREXByz2+60yuKvdxR6
	 dX+TaEUaufA3v4s8mW/tdMRL0B0jWjcA2rWDOUwcG8EdDJn76NJw5Bteb5ulwff3qw
	 JWDQA6Fnv2kxg==
Message-ID: <377046f369227a11fbf9e67c3c122d79.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CABVgOSkxOxpaHVtq1YpvNEshTZ3nic1p7NjV5DPdz066=tiS-A@mail.gmail.com>
References: <20230302013822.1808711-1-sboyd@kernel.org> <20230302013822.1808711-2-sboyd@kernel.org> <CABVgOSkxOxpaHVtq1YpvNEshTZ3nic1p7NjV5DPdz066=tiS-A@mail.gmail.com>
Subject: Re: [PATCH 1/8] dt-bindings: Add linux,kunit binding
From: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Brendan Higgins <brendan.higgins@linux.dev>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael J . Wysocki <rafael@kernel.org>, Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, Vincent Whitchurch <vincent.whitchurch@axis.com>, Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>, Christian Marangi <ansuelsmth@gmail.com>, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, linux-um@lists.infradead.org, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com
To: David Gow <davidgow@google.com>
Date: Thu, 09 Mar 2023 15:12:23 -0800
User-Agent: alot/0.10

Quoting David Gow (2023-03-02 23:14:55)
> On Thu, 2 Mar 2023 at 09:38, Stephen Boyd <sboyd@kernel.org> wrote:
> >
> > Document the linux,kunit board compatible string. This board is loaded
> > into the Linux kernel when KUnit is testing devicetree dependent code.
>=20
> As with the series as a whole, this might need to change a little bit
> if we want to either use devicetree overlays and/or other
> architectures.
>=20
> That being said, I'm okay with having this until then: the only real
> topic for bikeshedding is the name.
> - Is KUnit best as a board name, or part of the vendor name?
> - Do we want to include the architecture in the name?
> Should it be "linux,kunit", "linux-kunit,uml", "linux,kunit-uml", etc?

I think I will drop this patch. I have overlays working. I hijacked
of_core_init() to load the testcase data from drivers/of/unittest-data
and made a container node for kunit overlays to apply to.
