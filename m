Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A265641
	for <patches@lists.linux.dev>; Fri, 17 Mar 2023 04:46:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869B4C433EF;
	Fri, 17 Mar 2023 04:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679028381;
	bh=5yNWvQgLeD+W3TatQwurqoEHcZNBbmWYCS4gwWkQqRQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ctHhz266/vA9IBD/uqQDLslLpdKys6D4Y6BGhe6S3UjAa2tEsn5V5rsMx/YIZ6PI3
	 ZGY7Vx9RI9qJwmwf+efl3lZHanEerNwtRcswPG6rvtmVyzs7qMlg9NzH7a3xrDipOD
	 WkBO6QWnWIJbVnRnvvF59UI3tgjJV3GRzCXoi5IE=
Date: Fri, 17 Mar 2023 05:46:18 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tom Saeger <tom.saeger@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/137] 5.15.103-rc2 review
Message-ID: <ZBPwmsMpxISpRw+G@kroah.com>
References: <20230316083443.411936182@linuxfoundation.org>
 <20230316193711.s4cwpbcayg24zv5l@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316193711.s4cwpbcayg24zv5l@oracle.com>

On Thu, Mar 16, 2023 at 01:37:11PM -0600, Tom Saeger wrote:
> On Thu, Mar 16, 2023 at 09:50:12AM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.103 release.
> > There are 137 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.103-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Build ID for arm64 is back with CONFIG_MODVERSIONS=y
> Hooray!
> 
> Tested-by: Tom Saeger <tom.saeger@oracle.com>

Yeah!  Thanks for sticking with that, sorry it took so long to get
merged.

greg k-h
