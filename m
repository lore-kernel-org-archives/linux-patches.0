Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36C51FB8;
	Tue, 21 Mar 2023 07:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03E2C433EF;
	Tue, 21 Mar 2023 07:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679384900;
	bh=YsRomgHu98oQV4g6Q5/iQRj/o0GYfbUtrYkz2JQb4YA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j6w5nQhXo7VqIUJMh/CF5qRzifcULCHyFl6FcfeKr1cZ3VjClvy5PE9qTKifi/PmO
	 iecXm/5seIJDxO+HBaIU3vKzbebvjenUfD9Usj9Gxw2IVz7iOr5DSHPmg4YoU4kFaj
	 25wJBh3ls2SCY2ZXb9Xwj63/teWrPI5FXLsXCg6s=
Date: Tue, 21 Mar 2023 08:48:18 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de,
	Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>,
	llvm@lists.linux.dev
Subject: Re: [PATCH 6.2 000/211] 6.2.8-rc1 review
Message-ID: <ZBlhQjcEfoISYutj@kroah.com>
References: <20230320145513.305686421@linuxfoundation.org>
 <CA+G9fYvNEThYX-c204_knup5G_1vA27j+HouS-n=HMUsdJpC_g@mail.gmail.com>
 <CAKwvOdnmwkoeToovShcmfpSAmBmKDTzZNv4R2jFA37hi=+ynaQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKwvOdnmwkoeToovShcmfpSAmBmKDTzZNv4R2jFA37hi=+ynaQ@mail.gmail.com>

On Mon, Mar 20, 2023 at 11:49:49AM -0700, Nick Desaulniers wrote:
> On Mon, Mar 20, 2023 at 11:40 AM Naresh Kamboju
> <naresh.kamboju@linaro.org> wrote:
> 
> Thanks for the report!
> 
> > The bisection pointed to this commit,
> >   45f7091aac35 ("powerpc/64: Set default CPU in Kconfig")
> >
> >
> > Follow up fix patch is here as per Christophe Leroy comments,
> >  powerpc: Disable CPU unknown by CLANG when CC_IS_CLANG
> 
> Greg, Sasha,
> Can you please also pick up
> commit 4b10306e9845 ("powerpc: Disable CPU unknown by CLANG when CC_IS_CLANG")
> 
> 4b10306e9845 is missing a fixes tag.  I've filed
> https://github.com/ClangBuiltLinux/linux/issues/1820 to track getting
> these -mcpu= values for ppc added to clang.

Now queued up, thanks.

greg k-h
