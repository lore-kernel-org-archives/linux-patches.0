Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1369E1AD9FF;
	Tue, 18 Jun 2024 13:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716849; cv=none; b=f/ukV2sEcWQ2ngABzJlC9OFQT9UBySPub4Gu9VHAYx4kx0x/bU173+un/TCXVp7yXoAMGgwYt9HyQNEua+B/vlZp0n/R36Qtb8+QS5UG3EkmFddxjHS0IsrQUsymY9ieBoTdCN+vAxR7Bx0+sx8MH+RvwTfLTUjojv/CMc6zuCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716849; c=relaxed/simple;
	bh=eiEYRg7tb9Zm5L5qiyKdmcxA6sLOHm162FbH/EnNafk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ki6vZfrewwehav7HjAPGAgDVSepQ9Vrf0tiDbSjajyGB91RUFmZ2mKr7x3WLqknLheDGvXaSKn5n84dAmOOgxLM3rvRfsz3iETtz9lqky1WL1RJBhj8xd+CFOHjdxd7x+RjNRFLqzTZmKxZi3VgkpaWFg9pB4+EDMHv7cbDQWb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2SMaN9t+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2SMaN9t+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6069CC3277B;
	Tue, 18 Jun 2024 13:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716848;
	bh=eiEYRg7tb9Zm5L5qiyKdmcxA6sLOHm162FbH/EnNafk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=2SMaN9t+BDTOmgY5LngowGE8aP5d6hfv3J72xiUTJu17ASoBewEydNivyJFfkCEem
	 TT17iISo/QJVq6N7Cd/FW1yNTUuuvPIKBNkHG1O2oKoipHvgbhMtwPpl5mDBBbaefq
	 btR6MADVjHWoVYhasE9OLDXiJr6nn7k6hnSgIzE4=
Date: Tue, 18 Jun 2024 15:18:07 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/741] 6.6.33-rc2 review
Message-ID: <2024061855-rural-stoplight-1283@gregkh>
References: <20240609113903.732882729@linuxfoundation.org>
 <55b8c260-d8f0-4c05-bdf1-c20865fb13f7@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55b8c260-d8f0-4c05-bdf1-c20865fb13f7@roeck-us.net>

On Mon, Jun 17, 2024 at 10:38:29AM -0700, Guenter Roeck wrote:
> Hi,
> 
> On 6/9/24 04:41, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.6.33 release.
> > There are 741 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue, 11 Jun 2024 11:36:08 +0000.
> > Anything received after that time might be too late.
> > 
> [ ... ]
> > 
> > Duanqiang Wen <duanqiangwen@net-swift.com>
> >      Revert "net: txgbe: fix clk_name exceed MAX_DEV_ID limits"
> > 
> 
> This patch, in its commit message, explicitly states:
> 
>   This reverts commit e30cef001da259e8df354b813015d0e5acc08740.
>   commit 99f4570cfba1 ("clkdev: Update clkdev id usage to allow
>   for longer names") can fix clk_name exceed MAX_DEV_ID limits,
>   so this commit is meaningless.
> 
> However, commit 99f4570cfba1 has not been applied to v6.6.y,
> meaning the revert may impact the affected driver under some
> circumstances.

Ah, that was tricky, thanks, I've queued up 99f4570cfba1 now.

greg k-h
