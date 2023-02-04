Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D451C3E
	for <patches@lists.linux.dev>; Sat,  4 Feb 2023 08:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F378C433EF;
	Sat,  4 Feb 2023 08:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675497968;
	bh=lXQHT06I5mTNfgp8q9WY+J4pUSAmYpAlWQE4vglFmrk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BLnUQpmPZ3fzySxyeKk3pOBGfYRJMWg09IvMX1QXYgKYaKF/JA+KV/wQHi2mPqyOz
	 T9UsRg13Re5Vkp75aibSeZIOubIgTkOdY/aVAtlGAymIZsQoAUac+Ib4RIJPxVYvw1
	 utT9z3WNsW04A50cyBR/uZ+rT5KE3pWlWI4aow4A=
Date: Sat, 4 Feb 2023 09:06:03 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Shaoying Xu <shaoyi@amazon.com>
Cc: dsahern@kernel.org, idosch@nvidia.com, kuba@kernel.org,
	patches@lists.linux.dev, sashal@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 60/67] ipv4: Fix incorrect route flushing when source
 address is deleted
Message-ID: <Y94R65pvDM9d1v/I@kroah.com>
References: <20221212130920.482075438@linuxfoundation.org>
 <20230203184729.30269-1-shaoyi@amazon.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203184729.30269-1-shaoyi@amazon.com>

On Fri, Feb 03, 2023 at 06:47:29PM +0000, Shaoying Xu wrote:
> Hi Greg, 
> 
> It seems this patch deletes the whole fib_tests.sh that causes new
> failure in kselftests run. Looking at the upstream patch [1] and given the
> context that ipv4_del_addr test is not available to kernel 5.4, I
> updated the patch like attached below to resolve the potentail mistake.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=f96a3d74554df537b6db5c99c27c80e7afadc8d1

I'm sorry, but what commit exactly are you referring to here?  There is
no context at all in this email message :(

And if something is already in a release, I need a fix-up patch to
resolve it, your patch was whitespace damaged and could not be applied
to anything, sorry.

thanks,

greg k-h
