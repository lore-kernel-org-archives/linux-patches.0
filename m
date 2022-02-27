Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6C97B;
	Sun, 27 Feb 2022 11:55:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FB3C340E9;
	Sun, 27 Feb 2022 11:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1645962913;
	bh=1D46LrvQDmcYzxzHk0RLMPYyM8EV3PHh9+WRVp5XWa0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NBJctDlFoWnJJmkLzv6gW9pBQk+6sWeFWhVjbpXdxCnosJ4Nsyc8oOMsbeTToQY7C
	 h/VMwSWVOtCnXbb2x8haTDsUuGuR8AqJsNuZ7n+HykVBLAik6YURlBvS1lk6a3mc9D
	 sw1Pnz5gyM3GGLGHBwuTxqfn9m8ZNksvgfiQqK5zqaqeMRAav68LALWc3sKVidNq9l
	 qaFFaU5tgKdEmcN8R+Ymv1LZCnZ6ugVDwb43rpB3t9g/5NWPlwT+5m3uKKR7Cb+9qR
	 +wb3GgGGxchBSJEAN9FerOJVz6i8jT36ExfEV/mY9SVg5muAd1Yzp3FKNZXvhEyH0y
	 /uEYbiGNsYuGw==
Date: Sun, 27 Feb 2022 12:02:15 +0000
From: Jonathan Cameron <jic23@kernel.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Nathan Chancellor <nathan@kernel.org>, Lars-Peter Clausen
 <lars@metafoo.de>, Michael Hennerich <Michael.Hennerich@analog.com>, Cosmin
 Tanislav <cosmin.tanislav@analog.com>, linux-iio
 <linux-iio@vger.kernel.org>, patches@lists.linux.dev, llvm@lists.linux.dev,
 kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] iio: accel: adxl367: Fix handled initialization in
 adxl367_irq_handler()
Message-ID: <20220227120215.4c112bc2@jic23-huawei>
In-Reply-To: <CAHp75VdW8g_bvPvvfWOW5SUkEm9PYu8UvO9Mf_wshLLB3u=zPw@mail.gmail.com>
References: <20220224211034.625130-1-nathan@kernel.org>
	<CAHp75VdW8g_bvPvvfWOW5SUkEm9PYu8UvO9Mf_wshLLB3u=zPw@mail.gmail.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 26 Feb 2022 21:49:16 +0200
Andy Shevchenko <andy.shevchenko@gmail.com> wrote:

> On Thu, Feb 24, 2022 at 11:25 PM Nathan Chancellor <nathan@kernel.org> wrote:
> 
> ...
> 
> >   drivers/iio/accel/adxl367.c:879:14: note: initialize the variable 'handled' to silence this warning
> >           bool handled;
> >                       ^  
> 
> >                        = 0  
> 
> Bad advice (at minimum it should be false, but in general it might
> hide a real issue)

True. Thankfully Nathan did the right thing and looked for the real
problem :)

Jonathan

> 
> >   1 error generated.  
> 

