Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07F820ADEC;
	Tue, 12 Nov 2024 19:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731441050; cv=none; b=MyMbzHvaxw4lBvm1YFOm6BhbUkI4KeKTxfmnsdRiw1BASUnGlAquK2AmAKK6POjpayhDtDpUkIc5r217Cfz4H8hjAjTNVMhz9IFyHUVq3jKREYShLO2DHZZThXt27kotv1n/Q1jRy2gh8YutrojYFvhe05MxH5lfmkO1PWpH6K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731441050; c=relaxed/simple;
	bh=rJgZSYSkG7dh0RVAe8u1Z+Bh6JGYOaaERx2tsZG25kA=;
	h=Message-ID:Content-Type:MIME-Version:In-Reply-To:References:
	 Subject:From:Cc:To:Date; b=MTWvQ4CQd8xojLMniB4aUQvGvcAFX8uf6mjLL2OVEApMDjvfDy+lUBuKksgaKKKwlziJvwPTgTI/5qsybXqLqdEVlNC8YhGdsUfqayBToYP9dUwWJg8X7rGI+wkgynXa1WobMtdLhPUixhQ04Fncm7MBuIRKnYWUCBQlIwURx60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CQhkcw8t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CQhkcw8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2444AC4CECD;
	Tue, 12 Nov 2024 19:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731441050;
	bh=rJgZSYSkG7dh0RVAe8u1Z+Bh6JGYOaaERx2tsZG25kA=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=CQhkcw8trB32nAcmYqrDVMDPLyRF3dlktwJv7EIWXgCKJcdl+uXS77b9/GjrHLqaR
	 DtvcbsUd8YvfQbg0sNv5tFIZM/jIK+Vhq3iR+bXWkkGIRw4pvHvhTWbov39X1TNVKA
	 QtlXVar3nCOB8r/xX2hw9CWiGCmbSUyjqG1ykocYH1H2lBDQFZ16MxAw93As4jz3We
	 5j4Mf4zmBupGR1OmV2wayYjrtUis2GKcDw8Qm0D6p20ScK/vHQWBC7iev9K3FdrxHe
	 x9acF+29ILhb6WGm5cxw2t4jUOZ4hVFk3dgJ2O0BRgXMDiJPCzM7/8ZIhrLBwBY1Vn
	 vZ+s61S29QBZA==
Message-ID: <8b6d74e31161c8fadad926fe1c20ce1d.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20241108165532.GA2411452-robh@kernel.org>
References: <20241016212016.887552-1-sboyd@kernel.org> <20241017203810.GA814469-robh@kernel.org> <38153cbf2616a4a6706412952778eec1.sboyd@kernel.org> <CAMuHMdWp84u66Y-ELtbbRmySYwQch_=2qQiXzWJzrSkGeLZYBA@mail.gmail.com> <20241108165532.GA2411452-robh@kernel.org>
Subject: Re: [PATCH] of: Allow overlay kunit tests to run CONFIG_OF_OVERLAY=n
From: Stephen Boyd <sboyd@kernel.org>
Cc: Saravana Kannan <saravanak@google.com>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, devicetree@vger.kernel.org, kunit-dev@googlegroups.com
To: Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh@kernel.org>
Date: Tue, 12 Nov 2024 11:50:48 -0800
User-Agent: alot/0.12.dev1+gaa8c22fdeedb

Quoting Rob Herring (2024-11-08 08:55:32)
> On Fri, Nov 08, 2024 at 09:56:15AM +0100, Geert Uytterhoeven wrote:
> > > > > Fixes: 5c9dd72d8385 ("of: Add a KUnit test for overlays and test =
managed APIs")
> > > >
> > > > Doesn't really seem like a fix.
> > >
> > > Ok. Feel free to drop the tag.
> > >
> > > > Does this need to go into 6.12?
> > >
> > > It's only important for 6.12 if kernel configurators want to build the
> > > kernel with OF_OVERLAY_KUNIT_TEST enabled and not be forced to enable
> > > CONFIG_OF_OVERLAY. I don't mind if it waits a while.
> >=20
> > I'd say it's a fix, so please keep at last the Fixes tag. Merely
> > enabling kunit tests (which can be modular) should not increase the
> > possible attack vector on a product by enabling extra unneeded code.
>=20
> Not sure I buy that that is an actual problem. However, not worth=20
> arguing over. I only really care because if there's a Fixes, then this=20
> really should go to Linus for 6.12 rather than eventually get=20
> auto-selected from 6.13 to go to stable. So I moved it to send to Linus, =

> but I found that CONFIG_OF_OVERLAY is still selected with this patch.=20
> That's because the clock kunit tests also select CONFIG_OF_OVERLAY.=20
> That's fixed in next, but it's not queued up for 6.12.
>=20

I was planning to send the clk patch in the next merge window. Are you
sending the fix now? If you want you can also send the clk side patch
and I can drop it from the clk tree.
