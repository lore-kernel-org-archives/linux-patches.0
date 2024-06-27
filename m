Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AACB14AD10;
	Thu, 27 Jun 2024 11:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719487725; cv=none; b=moch5yoJ5ZSluTigEsNWhfF6aDvle6/229IqEb2S4Ba1jMoQOsv+n3UPFzgBdTrfriK5wi2KvMaeeQ+6XyxenWepPG95jigSgPmNNdvZqCWQ2YDPWauUfZAJuL4OFUnRG4gy7KT5rduly7YZ6QRpv1mRoPBgPbfv5baQDoZNTLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719487725; c=relaxed/simple;
	bh=KQbjQGX5zAl5/p5eRMiU6mnWze+fsZIcCgtOf9y2lSw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rSymV+/fhDKCI6yME6mkuNfzzN2bDlI4pUuWrZRU4dYfqTCWT/A6DcJ8QqHg/xKyUFexwu0yMtBi/EdPpWqFnRBpLmcGrQqDXu7TmyMwvuICTXXIULURvfO6oeMzK6k7cNFbsSJydAdZlDeHPh3ag2bWB0pGPKoUDgcTPeNFdl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C08pB1iK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C08pB1iK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C84C2BBFC;
	Thu, 27 Jun 2024 11:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719487724;
	bh=KQbjQGX5zAl5/p5eRMiU6mnWze+fsZIcCgtOf9y2lSw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C08pB1iKbIFo2XxcCO9PCQgM/OF/Upz1vxgxCR30E1NONxEOCfUOPBppmMKDvE0eK
	 8uuvU4ZqrxyF8kfdYrYN7b3o6z1qlGyONb60oN5A862kNfhfP6bvBR7TY+CoQLeaZj
	 iQYyFqI/7qaInZT89K9FUGPympR+TO7Y+fGRryfE=
Date: Thu, 27 Jun 2024 13:28:41 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Guenter Roeck <linux@roeck-us.net>, shuah <shuah@kernel.org>,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	Pavel Machek <pavel@denx.de>, Jon Hunter <jonathanh@nvidia.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>, srw@sladewatkins.net,
	rwarsow@gmx.de, Conor Dooley <conor@kernel.org>,
	Allen <allen.lkml@gmail.com>, Mark Brown <broonie@kernel.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH 6.6 000/192] 6.6.36-rc1 review
Message-ID: <2024062713-overbid-either-2f92@gregkh>
References: <20240625085537.150087723@linuxfoundation.org>
 <CA+G9fYuWjzLJmBy+ty8uOCkJSdGEziXs-UYuEQSC-XFb5n938g@mail.gmail.com>
 <CA+G9fYsn8r7V=6K1_a-mYAM4icHKt-amiisFMwBbfPeSPyqz-g@mail.gmail.com>
 <70d09795-5e70-4528-9811-d0bafe7ffe07@app.fastmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70d09795-5e70-4528-9811-d0bafe7ffe07@app.fastmail.com>

On Tue, Jun 25, 2024 at 05:08:19PM +0200, Arnd Bergmann wrote:
> On Tue, Jun 25, 2024, at 16:43, Naresh Kamboju wrote:
> > On Tue, 25 Jun 2024 at 16:39, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >> On Tue, 25 Jun 2024 at 15:18, Greg Kroah-Hartman
> >> <gregkh@linuxfoundation.org> wrote:
> >> arm-linux-gnueabihf-ld: drivers/firmware/efi/efi-init.o: in function
> >> `.LANCHOR1':
> >> efi-init.c:(.data+0x0): multiple definition of `screen_info';
> >> arch/arm/kernel/setup.o:setup.c:(.data+0x12c): first defined here
> >> make[3]: *** [scripts/Makefile.vmlinux_o:62: vmlinux.o] Error 1
> >
> > git bisect is pointing to this commit,
> > [13cfc04b25c30b9fea2c953b7ed1c61de4c56c1f] efi: move screen_info into
> > efi init code
> 
> I think we should drop this patch: it's not a bugfix but was only
> pulled in as a dependency for another patch. The series was rather
> complicated to stage correctly, so keeping my screen_info patch
> would require pulling in more stuff.

Now dropped.  I've fixed up the other patches that was pulled in here to
not need this one, it was a simple one-line loongarch-only fix that
should be fine now.

thanks,

greg k-h
