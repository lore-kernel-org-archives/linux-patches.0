Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72CF13BC35;
	Wed, 27 Nov 2024 22:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732746938; cv=none; b=RuCzJcLkCiLuiKTrx8PotJjMxJOfui8M8GIFS7UzHZeAoFPAT0ZDzOJmBQI2bpQwlU87wxbYsTZyLec+TJWRr4zHgX+FrMiHuYyb5xl0UbuTjWLuLiTjXaVbj/pZRCkRwo01SIgMlVKfm4lpW1+7SK75FlU3sb6fwIMyHQjQDbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732746938; c=relaxed/simple;
	bh=YcX+yTcM31Rkj1jlQtmsm0pbDi0izqzHJsRa9S2jLQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nAi0L09Y9qzbmNeF9cDWF7yWbbVlx+Vaw9pFINrp/1RLXTA1X9q2+5FpJgTzCxsXaUOnKEUXVZGzpfkiGGDJztihADTc5+9Ry1Wq4RqM5iQAgmv1dJxXPpU09QpecZ9FT++qwIjD92AS8Qb9G+2UjxxASxKcKmqqGWxMldVS8lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=esNQkP0Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="esNQkP0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8934C4CECC;
	Wed, 27 Nov 2024 22:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732746938;
	bh=YcX+yTcM31Rkj1jlQtmsm0pbDi0izqzHJsRa9S2jLQI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=esNQkP0QUKXOmvaMH4kg+oLMcIAi68MRVvDdo6eeY0k7y7PZA6ue3qkn7XEAvWfTE
	 h+7pOBLnONikAtKmNn69s5GI1nev+pFGXWzDObMQVvxJONygx5VKZb0ctKku5vJeAi
	 kVwCp/lt/yfkldWkuUUOPOU+SpdTh35Mc8FQ2USsNGx8JNjxLff1WPQ/VA9//ale8+
	 DEod2tO0BLyGTJB1YoNppW7x0ifpNjQtH4ulfH/aTZCFV5b6p3pWfocWbgfce6/m9F
	 gLK6n/AGmdyd3I2YJvq83kuG3KLLYh1ADw17X9QyRc55Qpv/ckjCR/Eq5K6rAEwZKM
	 W2PO4NhAQ/Xeg==
Date: Wed, 27 Nov 2024 14:35:36 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: samitolvanen@google.com, petr.pavlu@suse.com, da.gomez@samsung.com,
	linux-modules@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, masahiroy@kernel.org,
	mmaurer@google.com, arnd@arndb.de, deller@gmx.de, song@kernel.org
Subject: Re: [GIT PULL] Modules changes for v6.13-rc1
Message-ID: <Z0eeuCyUGcKgsc5h@bombadil.infradead.org>
References: <Z0ZxiLw9hauUynTS@bombadil.infradead.org>
 <CAHk-=wjCkJsdLageTx6C4n--aYFoO6gSRe0Rwcbk1jQdOdiPfg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjCkJsdLageTx6C4n--aYFoO6gSRe0Rwcbk1jQdOdiPfg@mail.gmail.com>

On Wed, Nov 27, 2024 at 01:22:37PM -0800, Linus Torvalds wrote:
> On Tue, 26 Nov 2024 at 17:10, Luis Chamberlain <mcgrof@kernel.org> wrote:
> >
> > Highlights for this merge window:
> 
> Lowlights:
> 
> >   * Adds a new modules selftests: kallsyms which helps us tests find_symbol()
> >     and the limits of kallsyms on Linux today.
> 
> This is completely broken.
> 
> Try doing "make allmodconfig" and then do "make" twice in a row.
> 
> It re-generates the tests, so you see this:
> 
>   GEN     lib/tests/module/test_kallsyms_a.c
>   GEN     lib/tests/module/test_kallsyms_b.c
>   GEN     lib/tests/module/test_kallsyms_c.c
>   GEN     lib/tests/module/test_kallsyms_d.c
>   CC [M]  lib/tests/module/test_kallsyms_a.o
>   CC [M]  lib/tests/module/test_kallsyms_b.o
>   CC [M]  lib/tests/module/test_kallsyms_c.o
>   CC [M]  lib/tests/module/test_kallsyms_d.o
>   LD [M]  lib/tests/module/test_kallsyms_a.ko
>   LD [M]  lib/tests/module/test_kallsyms_b.ko
>   LD [M]  lib/tests/module/test_kallsyms_c.ko
>   LD [M]  lib/tests/module/test_kallsyms_d.ko
> 
> both times, and this has made the empty build slow down by about a
> factor of two.
> 
> Which is a big deal, because the "empty build" is actually fairly
> important for me. It's the baseline build test performance, and with
> small pulls it actually dominates.
> 
> So this isn't ok. Please fix asap, because otherwise I will just
> revert it - it really does affect my workflow that much.

Sorry about that, I'm on it.

  Luis
