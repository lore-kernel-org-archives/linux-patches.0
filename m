Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EEB4F21D;
	Thu, 28 Nov 2024 03:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732762978; cv=none; b=HS0kqM6Mt3nL7HXm3hDI2H8SlJj0Z98ZdYu0Mp+xq5SVbs386Z9sqL/4q7+Bh6Gi4Kju0j2KAvvTEejr0mBshtR8Vr7QRMHIb0yNy++bauQRquan9+PuF0RrcFitvD6X1yg1UBdzBPaRB19tEAfluExakn1M6jNUW2X4sQAl5oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732762978; c=relaxed/simple;
	bh=h8ETCd0Hu5iLwPl0E3b+Tj9oR9uuIZJ+v35teXIlElA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UBd0axbdn3vEbkiw6yVhkaf2B4/lxaMckYwuRi/bgRNmIU73/7PfgqaHno27eWkT9YQc6ZkG3jTBpGd1t+yVUDxulv7DvYFp+3gLlBxz+YScDylRVMzcc2L/tCeHY8qt6vtxj5Lc+CJ051rmWEW952ipahnuZ0Hnzj6GgTtiRS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I5m3KfJ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I5m3KfJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A89C4CECC;
	Thu, 28 Nov 2024 03:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732762977;
	bh=h8ETCd0Hu5iLwPl0E3b+Tj9oR9uuIZJ+v35teXIlElA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I5m3KfJ+cvhkLemf1AoO+fuL0V91GeSZtIu1/GxpcBa+vzbcwfZo1l5lr/f65sJWf
	 f4ioCwKb1SBkhGloltKdg3P6qpkRY+J/xZ/GDZH1WOu8gtYnYCp20CwoBbBPKLOZaA
	 hSv7/CkpGIWJwRSv4A+vBvs80Ye1KXJGfRzBpOxsolgicbadFx5FbGZI0G15FOE6na
	 hOYd7ZiIxNoC/Tfs1eFYLun2vhVMBkLrcfiP0eRS4zK6hD1Ozdm2py6QSnxA+QEKtt
	 NvAjhKxujxr5t8B0RtCiE9hD85Q5MaRbAKgKgRtcJwMjvEUESkO2UBK5b/9/1EsC1C
	 ZKsGEcx+9uyxA==
Date: Wed, 27 Nov 2024 19:02:55 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, samitolvanen@google.com,
	petr.pavlu@suse.com, da.gomez@samsung.com,
	linux-modules@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, mmaurer@google.com, arnd@arndb.de,
	deller@gmx.de, song@kernel.org
Subject: Re: [GIT PULL] Modules changes for v6.13-rc1
Message-ID: <Z0fdX6i3inNVJf-e@bombadil.infradead.org>
References: <Z0ZxiLw9hauUynTS@bombadil.infradead.org>
 <CAHk-=wjCkJsdLageTx6C4n--aYFoO6gSRe0Rwcbk1jQdOdiPfg@mail.gmail.com>
 <Z0eeuCyUGcKgsc5h@bombadil.infradead.org>
 <Z0eqiayuv1w4a_dc@bombadil.infradead.org>
 <CAHk-=wj+imfGvW73XoYn60bAMzRtPfXFqwFTUqBoEq4=u5_oUg@mail.gmail.com>
 <Z0fT4hC30NISjmi_@bombadil.infradead.org>
 <Z0fYqZutUzDdxTGf@bombadil.infradead.org>
 <CAK7LNARDwBmvKY4fDmr5K=WLEvWLhFgg50ibu7etJykiRxohOA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK7LNARDwBmvKY4fDmr5K=WLEvWLhFgg50ibu7etJykiRxohOA@mail.gmail.com>

On Thu, Nov 28, 2024 at 11:56:44AM +0900, Masahiro Yamada wrote:
> On Thu, Nov 28, 2024 at 11:42 AM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >
> > Now with Masahiro's cleanups, in my testing we don't need the FORCE anymore.
> >
> >
> > From 83497e0e83d81950df54d82461b1dae629842147 Mon Sep 17 00:00:00 2001
> > From: Luis Chamberlain <mcgrof@kernel.org>
> > Date: Wed, 27 Nov 2024 14:10:57 -0800
> > Subject: [PATCH v3] selftests: kallsyms: fix double build stupidity
> >
> > Fix the stupid FORCE so that re-builds will only trigger
> > when really needed. While at it, document the sensible ranges
> > supported and fix the script to accept these alternatives.
> >
> > Also adopt Masahiro Yamada's suggested cleanups on the Makefile.
> >
> > Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> 
> 
> Did you run any compile-test before submitting this?

I did. Multiple times.

> if_changed requires FORCE.
> Your patch introduces new warnings.
> mkdir -p /home/masahiro/ref/linux/tools/objtool && make
> O=/home/masahiro/ref/linux subdir=tools/objtool --no-print-directory
> -C objtool
>   INSTALL libsubcmd_headers
>   CALL    scripts/checksyscalls.sh
> lib/tests/module/Makefile:12: FORCE prerequisite is missing
>   GEN     lib/tests/module/test_kallsyms_a.c
> lib/tests/module/Makefile:12: FORCE prerequisite is missing
> lib/tests/module/Makefile:12: FORCE prerequisite is missing
>   GEN     lib/tests/module/test_kallsyms_b.c
> lib/tests/module/Makefile:12: FORCE prerequisite is missing
>   GEN     lib/tests/module/test_kallsyms_c.c
>   GEN     lib/tests/module/test_kallsyms_d.c
>   CC [M]  lib/tests/module/test_kallsyms_a.o
>   CC [M]  lib/tests/module/test_kallsyms_b.o
>   CC [M]  lib/tests/module/test_kallsyms_c.o
>   CC [M]  lib/tests/module/test_kallsyms_d.o

Odd, I didn't see them. Anyway, I'll just take your Makefile fixes,
thanks.

  Luis
