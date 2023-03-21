Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC469440
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 20:56:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F1DC433EF;
	Tue, 21 Mar 2023 20:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1679432215;
	bh=qgNHCadAkebh8+XwXNyHvRzBICpIGss89/yZYgR7dic=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=nzP6F7edJAjZYbEwQbVQWLCYc3HyMeXECVqqzGdpbVHOVXMSIX9PYlwTWai4WhkAr
	 XvCuEhBF/PbBTetnSx9AAQ1gUj426mcEGb+aTek9q7g4ORAZxQ0mJTUrLO+PO686Lp
	 IhED1ev9cMw7wFHQUbTb/WL+BydQhJE4Un6AIVMNEQG3i0+XKeH0jHKW4kLuORi7Wc
	 SFsQG2xeopUpkboBNDdQt3Y03W2MTPI7c04JibwbUrU+PSlAwH6yhuXqeyubp3jSz8
	 G+54EW3RIxX2W7H5CPzzyAKwP4gKdKyAYYcAqvWGH/sNUds8xu7Z4dJBMayhaqRfqw
	 aAszR0TbIeBsA==
Message-ID: <ffd2d079db17d6756a72ae711d6fdafb.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CABVgOSk9gqRe_5yQZweBA2Qg2aGx8rUJtOHywGeT4x7TEyBH0A@mail.gmail.com>
References: <20230302013822.1808711-1-sboyd@kernel.org> <20230302013822.1808711-3-sboyd@kernel.org> <CABVgOSkomwwgKZ9N0_0YMDL--QaZiTV7ONgSRABU2Ph1Z0CG-g@mail.gmail.com> <a97c9bb3a5addfb34af8ccabaa513026.sboyd@kernel.org> <CABVgOSkJ4mw_DtFzn5EwcsuYixWY_j13YotxEYqWhO+ZCL1KPg@mail.gmail.com> <d64a086ddcb7c5ca5abecab0ca654259.sboyd@kernel.org> <CABVgOSk9gqRe_5yQZweBA2Qg2aGx8rUJtOHywGeT4x7TEyBH0A@mail.gmail.com>
Subject: Re: [PATCH 2/8] of: Enable DTB loading on UML for KUnit tests
From: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Brendan Higgins <brendan.higgins@linux.dev>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael J . Wysocki <rafael@kernel.org>, Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, Vincent Whitchurch <vincent.whitchurch@axis.com>, Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>, Christian Marangi <ansuelsmth@gmail.com>, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, linux-um@lists.infradead.org, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com
To: David Gow <davidgow@google.com>
Date: Tue, 21 Mar 2023 13:56:53 -0700
User-Agent: alot/0.10

Quoting David Gow (2023-03-10 22:42:24)
> Hmm... I'd've thought that shouldn't be a problem: kunit.py should
> ignore most messages during a test, unless it can't find a valid
> result line. What does the raw KTAP output look like? (You can get it
> from kunit.py by passing the --raw_output option).
>=20

I rebased and retried on v6.3-rc1 and it isn't a problem. Maybe there
was some problem on v6.2?
