Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36A323CB;
	Mon,  6 Jun 2022 11:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22506C385A9;
	Mon,  6 Jun 2022 11:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1654514549;
	bh=LQjv5O0rd1ERlthtaY7/M3iUV0w+tC6Poio1lFYxDbE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gb95uirI059eeP8HvUSi7QlLL5mI55Ia1s/QZuoT8Gm8GzFjK3+XfEnVvv32L+Yhl
	 23qm6Vl+VzE1NGrnQMZbbPcng5V7OcQ5GhDNLijtaHu8RCUjaENdC/d+0lHoJgHm67
	 KsOfuW0bf9JzLnUImToAzxpuzP7A61Ro2Zw0JVsc=
Date: Mon, 6 Jun 2022 13:22:26 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Nathan Chancellor <nathan@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Nick Desaulniers <ndesaulniers@google.com>,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev, Dan Carpenter <dan.carpenter@oracle.com>,
	kernel test robot <lkp@intel.com>, Tom Rix <trix@redhat.com>,
	Ricky WU <ricky_wu@realtek.com>
Subject: Re: [PATCH] misc: rtsx: Fix clang -Wsometimes-uninitialized in
 rts5261_init_from_hw()
Message-ID: <Yp3jci/YJFzMmgFK@kroah.com>
References: <20220523150521.2947108-1-nathan@kernel.org>
 <20220606105819.349320-1-alexandr.lobakin@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606105819.349320-1-alexandr.lobakin@intel.com>

On Mon, Jun 06, 2022 at 12:58:19PM +0200, Alexander Lobakin wrote:
> From: Nathan Chancellor <nathan@kernel.org>
> Date: Mon, 23 May 2022 08:05:22 -0700
> 
> > Clang warns:
> > 
> >   drivers/misc/cardreader/rts5261.c:406:13: error: variable 'setting_reg2' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
> >           } else if (efuse_valid == 0) {
> >                      ^~~~~~~~~~~~~~~~
> >   drivers/misc/cardreader/rts5261.c:412:30: note: uninitialized use occurs here
> >           pci_read_config_dword(pdev, setting_reg2, &lval2);
> >                                       ^~~~~~~~~~~~
> > 
> > efuse_valid == 1 is not a valid value so just return early from the
> > function to avoid using setting_reg2 uninitialized.
> > 
> > Fixes: b1c5f3085149 ("misc: rtsx: add rts5261 efuse function")
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Reported-by: kernel test robot <lkp@intel.com>
> > Reported-by: Tom Rix <trix@redhat.com>
> > Suggested-by: Ricky WU <ricky_wu@realtek.com>
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> 
> Ping? Mainline 5.19-rc1 is now broken due to this.

Perhaps use a different compiler?  :)

It's in my "to apply" queue, will get there hopefully this week, it came
in during the merge window which prevented me from touching it.  You
know this...

thanks,

greg k-h
