Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E16155A2F;
	Wed,  4 Dec 2024 16:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733330937; cv=none; b=iCmNNuzruD9InW6ByNW6xMF7CIniM+JeVK0SZJXe3TxcDIvNtUqvV2McRUGEH1/KwM/367GCAfgFal7CVuT/YcWMn8/aKq3IL7q2RM89W+846Gv+JZGES3yv7ERtY4t2Fp+waq4JSW/3rpm21lNbvjO/Ok78EcwksqQFjrykLgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733330937; c=relaxed/simple;
	bh=stKYzQ0R9UHlbunEwTrubh6TmczNsMqKLnm63iCclNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NRKd4UFiQXV0IyYt/cFwF/Ck22RQrydFBGOIirt5pyVmARqlsC0o3XlbzQlo8I7py7mAxhmg4i/pq1AIPzzJYEeV6n4Wcc/MxB1eS2JaD23RrH9oPmQQ4aS/Gf86ckGuCbirRG4oMM7gQaBL8dIBA48fhPEQz3dd8YuhyXNqT0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RODX1vKl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RODX1vKl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3C1C4CECD;
	Wed,  4 Dec 2024 16:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733330936;
	bh=stKYzQ0R9UHlbunEwTrubh6TmczNsMqKLnm63iCclNw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RODX1vKlkCvETpQ5NpIm2OdX8o7qCEhp3Dmj1sPZkL/EWT6FiiYq7nV5/Vui3Ybsv
	 jdgQQCBg1SM+GGVAdBFXbE/TqEYOPpaihjEYnrfBxpbGNdnQRWEMcik6wdKI2qCJwi
	 hhX4jKWmpNSQhlumBc+AmYI4I7axb3IVP7Z7mkxuFRO46JYmskULr/mDbFqQvhLb80
	 HCZFXsecssdLy+glJY28q5jk3YO+TFwK6js17ZpmeyJgjIjTjpT0cJKSirUh3XcLFu
	 jrXJenR91EyCP+xzhO9pCjt9qSDT1AFcO9Yo7xsuU580vMXXYI8rA3nUXEimUYuqL6
	 UAMF69blJoEVw==
Date: Wed, 4 Dec 2024 09:48:53 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Anders Roxell <anders.roxell@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Michal Suchanek <msuchanek@suse.de>,
	Nicolai Stange <nstange@suse.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 6.12 000/826] 6.12.2-rc1 review
Message-ID: <20241204164853.GA3356373@thelio-3990X>
References: <20241203144743.428732212@linuxfoundation.org>
 <CA+G9fYu21yqTvL428TFueMJ1uU1H_u8Vc470dER2CTrNK=Js0g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYu21yqTvL428TFueMJ1uU1H_u8Vc470dER2CTrNK=Js0g@mail.gmail.com>

On Wed, Dec 04, 2024 at 06:30:47PM +0530, Naresh Kamboju wrote:
> On Tue, 3 Dec 2024 at 21:06, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.2-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> > and the diffstat can be found below
...
> 1) The allmodconfig builds failed on arm64, arm, riscv and x86_64
>      due to following build warnings / errors.
> 
> Build errors for allmodconfig:
> --------------
> drivers/gpu/drm/imx/ipuv3/parallel-display.c:75:3: error: variable
> 'num_modes' is uninitialized when used here [-Werror,-Wuninitialized]
>    75 |                 num_modes++;
>       |                 ^~~~~~~~~
> drivers/gpu/drm/imx/ipuv3/parallel-display.c:55:15: note: initialize
> the variable 'num_modes' to silence this warning
>    55 |         int num_modes;
>       |                      ^
>       |                       = 0
> 1 error generated.
> make[8]: *** [scripts/Makefile.build:229:
> drivers/gpu/drm/imx/ipuv3/parallel-display.o] Error 1

Introduced by backporting commit 5f6e56d3319d ("drm/imx:
parallel-display: switch to drm_panel_bridge") without
commit f94b9707a1c9 ("drm/imx: parallel-display: switch to
imx_legacy_bridge / drm_bridge_connector"). The latter change also had a
follow up fix in commit ef214002e6b3 ("drm/imx: parallel-display: add
legacy bridge Kconfig dependency").

> drivers/gpu/drm/imx/ipuv3/imx-ldb.c:143:3: error: variable 'num_modes'
> is uninitialized when used here [-Werror,-Wuninitialized]
>   143 |                 num_modes++;
>       |                 ^~~~~~~~~
> drivers/gpu/drm/imx/ipuv3/imx-ldb.c:133:15: note: initialize the
> variable 'num_modes' to silence this warning
>   133 |         int num_modes;
>       |                      ^
>       |                       = 0
> 1 error generated.

Introduced by backporting commit 5c5843b20bbb ("drm/imx: ldb: switch to
drm_panel_bridge") without commit 4c3d525f6573 ("drm/imx: ldb: switch to
imx_legacy_bridge / drm_bridge_connector").

These are both upstream patch series bisectability issues, not anything
that stable specifically did, as the num_nodes initialization was
removed by the first change but the entire function containing num_nodes
was removed by the second change so when the series was taken atomically
upstream, nobody notices. However, I do wonder why these patches are
being picked up, as they don't really read like fixes to me and the
cover letter of the original series does not really make it seem like it
either.

Cheers,
Nathan
