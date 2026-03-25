Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC56238C3B;
	Wed, 25 Mar 2026 13:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774445512; cv=none; b=dAzJJ5s8mbqINTHJq7ooGBuP7IAnqE3CaPlZXt9QMXCnts0azBblHS0yeg7+EcmdX3GvVToIWQu9YzZqJ9PNUA7DLwsgzRQmepI7lQNoNyibBEaEQlLN/Uj9MBgFIuFkSFvkGmli/tAOJT/31ft1+/Ig7nZoH17jMksJVYhzR88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774445512; c=relaxed/simple;
	bh=uTUQBOCC/KBJgpZSREu4yYx7YWRXCtbxquPPa2PpGkA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AS+NBOLWQZp9YrYxrZRt+2H054W8F0ZIehFZe3H+unvwdf+XbbnhHSL4xtERIE/1JEr8hZkr/MFuLPh+zuoNguEILkoJgf93PXWp3TKa/qmryq8sjjlHCia9luoz8tn6mqJb8V3h5Z3pdSppkEpDcHo5rd9bleAY7OoAav93+8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zBflX+cE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zBflX+cE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B05C2BCB0;
	Wed, 25 Mar 2026 13:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774445511;
	bh=uTUQBOCC/KBJgpZSREu4yYx7YWRXCtbxquPPa2PpGkA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zBflX+cE3+whyEdjBCgadMGWY/POxqdurO7EcmERS6ZjO3Ssf2kCu2xM4qnMbU68B
	 wS0KDa6Tx38kyr+lIQs3K2ZWRJZ2oUHM2crw7bsjWFx4lvGlC08+iu53q0Hk7czU3S
	 mlIIElH5e8Zylyqnje57eSQ4qBdI8nL8E/4n7yfw=
Date: Wed, 25 Mar 2026 14:31:28 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Mark Brown <broonie@kernel.org>, Jan Kara <jack@suse.cz>,
	Francesco Dolcini <francesco@dolcini.it>,
	Brian Foster <bfoster@redhat.com>,
	Yongjian Sun <sunyongjian1@huawei.com>,
	Matthew Wilcox <willy@infradead.org>,
	Gou Hao <gouhao@uniontech.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Zhang Yi <yi.zhang@huawei.com>, Baokun Li <libaokun1@huawei.com>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.1 000/481] 6.1.167-rc1 review
Message-ID: <2026032547-spleen-mortify-1cf9@gregkh>
References: <20260323134525.256603107@linuxfoundation.org>
 <20260324073447.GA5062@francesco-nb>
 <mhqesgj3u7dr33zit6iwjhykw2zpuallru4qvoloyyqzdqgvki@bpwwmihh357r>
 <d8080343-20cd-4a4a-b726-b9e3c6a5c5eb@sirena.org.uk>
 <20260325035931.GC61656@mac.lan>
 <2026032535-casino-cable-e039@gregkh>
 <20260325131110.GC2107@macsyma.local>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325131110.GC2107@macsyma.local>

On Wed, Mar 25, 2026 at 08:11:10AM -0500, Theodore Tso wrote:
> On Wed, Mar 25, 2026 at 10:49:43AM +0100, Greg Kroah-Hartman wrote:
> > > I don't have time to investigate further, but Greg, if you could drop
> > > these three patches, that should address this issue.
> > 
> > All now dropped, thanks!
> 
> Thanks!  Just as another heads up, I decided to run a full regression
> test suite on 6.1.167-rc1 with those three reverts, and there ar still
> some crashes with generic/051 and ext4/039:
> 
> ext4/4k: 711 tests, 1 errors, 83 skipped, 4645 seconds
>   Errors: generic/051
> ext4/1k: 636 tests, 7 failures, 1 errors, 78 skipped, 5612 seconds
>   Errors: ext4/039
> ext4/encrypt: 679 tests, 1 errors, 215 skipped, 3343 seconds
>   Errors: generic/051
> ext4/ext3conv: 706 tests, 1 errors, 85 skipped, 5282 seconds
>   Errors: generic/051
> ext4/adv: 713 tests, 13 failures, 1 errors, 91 skipped, 4944 seconds
>   Errors: generic/051
> ext4/dioread_nolock: 711 tests, 1 failures, 1 errors, 83 skipped, 5518 seconds
>   Errors: generic/051
> ext4/data_journal: 635 tests, 6 failures, 1 errors, 151 skipped, 4105 seconds
>   Errors: ext4/039
> ext4/bigalloc_4k: 604 tests, 1 errors, 79 skipped, 4876 seconds
>   Errors: ext4/039
> ext4/bigalloc_1k: 682 tests, 6 failures, 1 errors, 106 skipped, 5454 seconds
>   Errors: generic/051
> ext4/dax: 705 tests, 10 failures, 1 errors, 207 skipped, 3249 seconds
>   Errors: generic/051
> 
> I'll start trying to bisect this as I have time today.  Are you going
> to put out another rc and restart the 48 hour testing clock?

No, I've already done a release, I dropped more than just those 3, I
dropped all the dependent ext4 patches.

If you could test the last release and if I should do any reverts there,
please let me know.

thanks,

greg k-h
