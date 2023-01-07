Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E750B1842
	for <patches@lists.linux.dev>; Sat,  7 Jan 2023 10:27:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1591CC433EF;
	Sat,  7 Jan 2023 10:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673087271;
	bh=9aSwaVo2ASINUIF5kxH/VwbRD8ciZ/eswbsN74JDSOA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IFqULiuqPuR7caQBBJhPi0uCa02+SSlhQpb8HRgRRV32XmQABwjCsMyf90jSDtD6f
	 v9CxmAN42nEdBgUKed619kswN9VLOBSP4PRjaxNRlc349ixrLH9Pu0WqIQUEN5iR9i
	 /diqwXucno0TdkY5Pxvs38jSD/YjthrW2tHdTGag=
Date: Sat, 7 Jan 2023 11:27:48 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@denx.de>
Cc: nathan@kernel.org, marcus.folkesson@gmail.com, cuigaosheng1@huawei.com,
	andriy.shevchenko@linux.intel.com, m.szyprowski@samsung.com,
	jack@suse.cz, stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.9 000/251] 4.9.337-rc1 review
Message-ID: <Y7lJJEhK3W3joZv6@kroah.com>
References: <20230105125334.727282894@linuxfoundation.org>
 <Y7cpWKbQlNW5qEeO@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7cpWKbQlNW5qEeO@duo.ucw.cz>

On Thu, Jan 05, 2023 at 08:47:36PM +0100, Pavel Machek wrote:
> This one is okay in mainline, but contains wrong error handling in the
> 4.9 backport. 4.19 seems okay. It needs to "goto out_unlock", not
> return directly.
> 
> > Jan Kara <jack@suse.cz>
> >     ext4: initialize quota before expanding inode in setproject ioctl

I've fixed this up, good catch.  The rest I've left as they seem
reasonable to be in the tree as-is.

thanks,

greg k-h
