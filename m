Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B388F55
	for <patches@lists.linux.dev>; Thu, 21 Sep 2023 08:52:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42584C16ABD;
	Thu, 21 Sep 2023 08:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695286356;
	bh=QGQ8UZdnGHm0xTOTGBK6kD7Sr0s+cgqVFS+jXeuxmvw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=olxHUFCVyLJBzODuGfbl2XTEWhtSlD7Sau6qt46dUEuci6WddIF5DY/4994WpK9f6
	 i30pdkDOavInfDKWpZ2vsBqNnss0uWueUbvy3ese+UW5aIlK0aqbtSL5rETNUOglz0
	 FKw/YMo73Ffy6lQFjeBWwoWaRyZBagXkIHoQjW4Y=
Date: Thu, 21 Sep 2023 10:52:34 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.14 055/186] ARM: dts: BCM53573: Use updated "spi-gpio"
 binding properties
Message-ID: <2023092124-pessimism-trading-3842@gregkh>
References: <20230920112836.799946261@linuxfoundation.org>
 <20230920112838.896837720@linuxfoundation.org>
 <b7cea4f70cefbff3fac4f4ca1d42e78f@milecki.pl>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b7cea4f70cefbff3fac4f4ca1d42e78f@milecki.pl>

On Wed, Sep 20, 2023 at 02:49:15PM +0200, Rafał Miłecki wrote:
> On 2023-09-20 13:29, Greg Kroah-Hartman wrote:
> > 4.14-stable review patch.  If anyone has any objections, please let me
> > know.
> 
> I already replied to the queuing e-mail but it was missed I guess. This
> patch should not get backported to the 4.14 due its dependencies. See
> below for more details.
> 
> -------- Original Message --------
> Subject: Re: Patch "ARM: dts: BCM53573: Use updated "spi-gpio" binding
> properties" has been added to the 4.14-stable tree
> Date: 2023-09-11 09:04
> From: Rafał Miłecki <rafal@milecki.pl>
> To: Sasha Levin <sashal@kernel.org>
> Cc: stable-commits@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
> Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley
> <conor+dt@kernel.org>
> 
> On 2023-09-09 01:47, Sasha Levin wrote:
> > This is a note to let you know that I've just added the patch titled
> > 
> >     ARM: dts: BCM53573: Use updated "spi-gpio" binding properties
> > 
> > to the 4.14-stable tree which can be found at:
> > 
> > http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >      arm-dts-bcm53573-use-updated-spi-gpio-binding-proper.patch
> > and it can be found in the queue-4.14 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> 
> The new binding became part of Linux release 4.17-rc1 as a result of
> commits:
> 77a060533c04 ("spi: spi-gpio: Augment device tree bindings")
> 9b00bc7b901f ("spi: spi-gpio: Rewrite to use GPIO descriptors")
> 
> Kernels older than 4.17-rc1 don't support new binding.
> 
> This patch should NOT be backported to the 4.14.

Thanks for letting me know, now dropped.

greg k-h
