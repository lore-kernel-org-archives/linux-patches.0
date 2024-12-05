Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB791D3566;
	Thu,  5 Dec 2024 09:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733390636; cv=none; b=taer3pbsiCbjWW9SWTHRLaTX+Eqiocprg9uU/9H7z2SvxsMGgGxBZ1f4u5ma32AVrRlyesskP+tykRXijkqkVBLcfmFKCYFhe/plnjhSFrYyK+NU8dyI8pKfseCV8PjqaEtmieXbCk1GQG9QfvnX/GDT6z5tFUG4areyGo3hnRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733390636; c=relaxed/simple;
	bh=FeU74kM5djSKUVNu49yvDrxmNbLNHfa8te1RTZPrw3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iXxCD4lTXY43g58xYSdlfS5C9sQWib0ndBU39Mqr0fWgzIi23QQyUx2Uzth10L7laMUiMn/Eos5ohGucTV32I0D3Vye1mDY5TWFi0XiMeTgejquqxJXJyF69lfNor7XzRsS81Sj0tIZos2/wlgESuDdRI/eI335jcgqm8o3nE8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=169qeRzw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="169qeRzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12644C4CED6;
	Thu,  5 Dec 2024 09:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733390634;
	bh=FeU74kM5djSKUVNu49yvDrxmNbLNHfa8te1RTZPrw3c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=169qeRzwK9kvaClRWj3qEuj2uoF7rMB8dBGxPUQ6o3SoAKxtNqWaOobq1QCByRI7R
	 VMljJxyFdWRe6oOZ9F1Dbdzwt+QbCxaR6oF+zgNsmvGovF7Zm13nAc5uBOD3bTSLqk
	 cMl0qgr9unW86DRgz/ooQ4tUpH2KbmvcFO+70o6Y=
Date: Thu, 5 Dec 2024 10:23:51 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>,
	Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
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
Message-ID: <2024120504-verbose-hurried-eb52@gregkh>
References: <20241203144743.428732212@linuxfoundation.org>
 <CA+G9fYu21yqTvL428TFueMJ1uU1H_u8Vc470dER2CTrNK=Js0g@mail.gmail.com>
 <20241204164853.GA3356373@thelio-3990X>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241204164853.GA3356373@thelio-3990X>

On Wed, Dec 04, 2024 at 09:48:53AM -0700, Nathan Chancellor wrote:
> On Wed, Dec 04, 2024 at 06:30:47PM +0530, Naresh Kamboju wrote:
> > On Tue, 3 Dec 2024 at 21:06, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.2-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> > > and the diffstat can be found below
> ...
> > 1) The allmodconfig builds failed on arm64, arm, riscv and x86_64
> >      due to following build warnings / errors.
> > 
> > Build errors for allmodconfig:
> > --------------
> > drivers/gpu/drm/imx/ipuv3/parallel-display.c:75:3: error: variable
> > 'num_modes' is uninitialized when used here [-Werror,-Wuninitialized]
> >    75 |                 num_modes++;
> >       |                 ^~~~~~~~~
> > drivers/gpu/drm/imx/ipuv3/parallel-display.c:55:15: note: initialize
> > the variable 'num_modes' to silence this warning
> >    55 |         int num_modes;
> >       |                      ^
> >       |                       = 0
> > 1 error generated.
> > make[8]: *** [scripts/Makefile.build:229:
> > drivers/gpu/drm/imx/ipuv3/parallel-display.o] Error 1
> 
> Introduced by backporting commit 5f6e56d3319d ("drm/imx:
> parallel-display: switch to drm_panel_bridge") without
> commit f94b9707a1c9 ("drm/imx: parallel-display: switch to
> imx_legacy_bridge / drm_bridge_connector"). The latter change also had a
> follow up fix in commit ef214002e6b3 ("drm/imx: parallel-display: add
> legacy bridge Kconfig dependency").
> 
> > drivers/gpu/drm/imx/ipuv3/imx-ldb.c:143:3: error: variable 'num_modes'
> > is uninitialized when used here [-Werror,-Wuninitialized]
> >   143 |                 num_modes++;
> >       |                 ^~~~~~~~~
> > drivers/gpu/drm/imx/ipuv3/imx-ldb.c:133:15: note: initialize the
> > variable 'num_modes' to silence this warning
> >   133 |         int num_modes;
> >       |                      ^
> >       |                       = 0
> > 1 error generated.
> 
> Introduced by backporting commit 5c5843b20bbb ("drm/imx: ldb: switch to
> drm_panel_bridge") without commit 4c3d525f6573 ("drm/imx: ldb: switch to
> imx_legacy_bridge / drm_bridge_connector").
> 
> These are both upstream patch series bisectability issues, not anything
> that stable specifically did, as the num_nodes initialization was
> removed by the first change but the entire function containing num_nodes
> was removed by the second change so when the series was taken atomically
> upstream, nobody notices. However, I do wonder why these patches are
> being picked up, as they don't really read like fixes to me and the
> cover letter of the original series does not really make it seem like it
> either.

Thanks, I'll just rip them both out now.

greg k-h
