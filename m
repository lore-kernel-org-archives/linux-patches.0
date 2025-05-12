Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABAF1E1DE0;
	Mon, 12 May 2025 14:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747058983; cv=none; b=sHSYIuPbN6Jzt2kJWTwNgs+yipHWdQ2XoIMwLKOlwiBPmXO6d1gMRSjvMdyWxc0Sox960Vk2ebh365GyNV8hECbVQtEbT6PijpPRwuQIjYeCvdzM5aBlhbh+n50tg16CBc937Anciw8i/R8nd8e8wnP//LCkA57710bgo4zA4zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747058983; c=relaxed/simple;
	bh=DQ+G+WQoup4z3SOs6raruRx6tFSXMqS++jESLl3NjfM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gsJjhWajUXYdqwlypGAHwnQiI3gjDwuBkyFL6nO74TUb6CpvavqhWHWoUA/m400DlJhUzidpU9UX1/OkEq4YJFUEEawxiTGyeHItVrYIs6UDX8Rokga4fHasQ2nFbo/zf1KIeYEgiXOTkZbVo4TzgWtx1+NNLP3NN/Y/U5LBY+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vPKMx6Eu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vPKMx6Eu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF21C4CEE7;
	Mon, 12 May 2025 14:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747058980;
	bh=DQ+G+WQoup4z3SOs6raruRx6tFSXMqS++jESLl3NjfM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vPKMx6Eu3uodEcaylzYfHAvmUYWcx99E+A+Y+hHP/K86M0tkn0ECJEMz/jFQbSwbH
	 tfSn6IBI7mFW392Z4Wpwau/2Xb3rA0UX9eA1LiVVg4ywQOYLkMp466CdP5OCoCDOAm
	 bBT/krs/A1gdrMnZxpTaPOwdiz4Uk0qGLehdzZn4=
Date: Mon, 12 May 2025 16:09:37 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: jianqi.ren.cn@windriver.com
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp,
	akpm@linux-foundation.org, daniel.starke@siemens.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 5.15.y] tty: add the option to have a tty reject a new
 ldisc
Message-ID: <2025051221-creature-refund-8fe0@gregkh>
References: <20250509091454.3241846-1-jianqi.ren.cn@windriver.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250509091454.3241846-1-jianqi.ren.cn@windriver.com>

On Fri, May 09, 2025 at 05:14:54PM +0800, jianqi.ren.cn@windriver.com wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> 
> [ Upstream commit 6bd23e0c2bb6c65d4f5754d1456bc9a4427fc59b ]
> 
> ... and use it to limit the virtual terminals to just N_TTY.  They are
> kind of special, and in particular, the "con_write()" routine violates
> the "writes cannot sleep" rule that some ldiscs rely on.
> 
> This avoids the
> 
>    BUG: sleeping function called from invalid context at kernel/printk/printk.c:2659
> 
> when N_GSM has been attached to a virtual console, and gsmld_write()
> calls con_write() while holding a spinlock, and con_write() then tries
> to get the console lock.

WHy do you want this in 5.15 and older kernels?  You have already
disabledf n_gsm from your kernels already so this isn't an issue, right?
Unless you have this hardware, and explicitly know what is talking to
it, that is the recommendation for this code.

And how was this and the 5.10.y backport tested?  Did you see the above
"BUG:" line without it?

thanks,

greg k-h
