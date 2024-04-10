Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF3B286AC
	for <patches@lists.linux.dev>; Wed, 10 Apr 2024 06:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712731418; cv=none; b=t6HyyAmRcZSLebaSTeUhApKAEX2quSgjja4qqEhDcUxOgEAiwzeJmPSzUIHPi7zkuzaEAtu+SjJx1h4Y7JZXFkik80ffbmeh1kLoLJ2OQTy6mh+qL7cwnnlOYm9OaOz0jYjshdmuoEOhzxyEX3cPGqAtopauRiJjISdVUnY3DA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712731418; c=relaxed/simple;
	bh=dhHbpmgc3JUDzyyFb2aoXg55O4vGVhMfgTx5wz5yHaQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B2rDasHl2YievV97xSM8A4W11hkgQmSksW/xAmh9nugBgDt7CLVZxcPZaYKAWVm473nG7YRU6KpS+HTWX11q4uneTVD7LTUIyuXrE0zrCqbjOQ39ss1H3D0qhsYCIazi7g77klYUorLQY1PNk35jY2A/9lCIk4NZuOuu0wanags=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G014bcAf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G014bcAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC63C43394
	for <patches@lists.linux.dev>; Wed, 10 Apr 2024 06:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712731417;
	bh=dhHbpmgc3JUDzyyFb2aoXg55O4vGVhMfgTx5wz5yHaQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=G014bcAf83vw0lmK+MSOyATvUjZONCyVvcQsESC/h178yqfgGFsgOyCwSr5+kH08K
	 XPv0UyGszP77ms85xFmi0S1yK0vlxxCsZCc1iM6cOO96zPkUUUDLvie/Y/ooHLCfnR
	 uOJDhen/A6vpHnGkuOQ+0r+PhfNPBkDiUp0qtSbyEmxWZ2YCrgT1Deryzro1KFwtqx
	 +yXq3psVjE3TmVWGlrBY8CiGCACqV7noTCrr+FoUdJHmJxBsbIKL/b4pWEt6Rmw+Yn
	 y7a41JWjKZqHL00NZryaz/BiYetc6V7lZDDj+ifwB/0FE7KMgKKAaA2R98YmFtL46k
	 gBcL7HdrT/vTA==
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2d4a8bddc21so89078421fa.0
        for <patches@lists.linux.dev>; Tue, 09 Apr 2024 23:43:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWHeMlbsU6picvd/unarOzbnNMR6nUccJYXq4yAGrNOrp0uhJnRkaMBJDlupZeARinxEWbmBAyB1MG8+ZMMUQKIoyNWbDBCkA==
X-Gm-Message-State: AOJu0Yx4LlgDo0AmVhXdQv3uJH7b/ZLx7/JBRQ6QBEDpyumIPqFbbdYq
	ddhfmaoJjVgwxjDtOtyTeCQW/gJffAWeHkNSO0E4qk7T7JLY++uOmFYGGi31uu8STYz7ov5qhZU
	aQUS7aGEECmELlOJRj/qAKxW7MHU=
X-Google-Smtp-Source: AGHT+IGObL6Jz501iwORXWUCGgG6FtYSOhF/mL9CGp2/IdBE6aJH6P8esUJRzyH4KBeuVfNovX+v/1DQePdXHAbmvZM=
X-Received: by 2002:a2e:a712:0:b0:2d8:681:dc9e with SMTP id
 s18-20020a2ea712000000b002d80681dc9emr1041020lje.41.1712731415880; Tue, 09
 Apr 2024 23:43:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240408125309.280181634@linuxfoundation.org> <20240408125317.917032769@linuxfoundation.org>
 <76489f58-6b60-4afd-9585-9f56960f7759@hardfalcon.net> <20240410053433.GAZhYk6Q8Ybk_DyGbi@fat_crate.local>
 <2024041024-boney-sputter-6b71@gregkh>
In-Reply-To: <2024041024-boney-sputter-6b71@gregkh>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 10 Apr 2024 08:43:24 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHjwJnfjVgm=cOaJtJ=mF-mTLaoDM0wQyvvjL3ps9JEog@mail.gmail.com>
Message-ID: <CAMj1kXHjwJnfjVgm=cOaJtJ=mF-mTLaoDM0wQyvvjL3ps9JEog@mail.gmail.com>
Subject: Re: [PATCH 6.8 271/273] x86/sme: Move early SME kernel encryption
 handling into .head.text
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Pascal Ernster <git@hardfalcon.net>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 10 Apr 2024 at 07:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Apr 10, 2024 at 07:34:33AM +0200, Borislav Petkov wrote:
> > On Tue, Apr 09, 2024 at 06:38:53PM +0200, Pascal Ernster wrote:
> > > Just to make sure this doesn't get lost: This patch causes the kernel to not
> > > boot on several x86_64 VMs of mine (I haven't tested it on a bare metal
> > > machine). For details and a kernel config to reproduce the issue, see https://lore.kernel.org/stable/fd186a2b-0c62-4942-bed3-a27d72930310@hardfalcon.net/
> >
> > I see your .config there. How are you booting the VMs? qemu cmdline?
> >
> > Ard, anything missing in the backport?
> >
> > I'm busy and won't be able to look in the next couple of days...
>
> As reverting seems to resolve this, I'll go do that after my morning
> coffee kicks in...

Fair enough. I'll look into this today, but I guess you're on a tight
schedule with this release.

Please drop the subsequent patch as well:

x86/efistub: Remap kernel text read-only before dropping NX attribute

as it assumes that all code reachable from the startup entrypoint is
in .head.text and this will no longer be the case.
