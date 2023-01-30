Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109C56AA3
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 18:14:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323A6C433EF;
	Mon, 30 Jan 2023 18:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675102476;
	bh=21jkaeox/IaE/j91iGqPRujdRRemIKiKw5zjR/dW7y4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jpo+LVlV6BXWVmuj1CrnFn4N6Vk4KmNT1smO4ro3TNnPJ3kinJSusBJj5MNZOl7GX
	 004h8kpetyP7Z5CV1n90K/QFVGx7z7fqiYPc2UyzsnzoqXgi7lPQpLUS0dlC53n2ed
	 a0jHspuDARZ4GG8wagy4ESsnk1rgDZ6jUgDkJhuM=
Date: Mon, 30 Jan 2023 19:14:33 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/313] 6.1.9-rc1 review
Message-ID: <Y9gJCaPhWGnffClH@kroah.com>
References: <20230130134336.532886729@linuxfoundation.org>
 <01cb274a-1adb-1a46-0260-fbaee94feb8a@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01cb274a-1adb-1a46-0260-fbaee94feb8a@roeck-us.net>

On Mon, Jan 30, 2023 at 08:41:48AM -0800, Guenter Roeck wrote:
> On 1/30/23 05:47, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.9 release.
> > There are 313 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Building csky:allmodconfig ... failed
> --------------
> Error log:
> drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c: In function 'amdgpu_dm_atomic_check':
> drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:9397:43: error: unused variable 'mst_state' [-Werror=unused-variable]
>  9397 |         struct drm_dp_mst_topology_state *mst_state;
>       |                                           ^~~~~~~~~
> drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:9396:41: error: unused variable 'mgr' [-Werror=unused-variable]
>  9396 |         struct drm_dp_mst_topology_mgr *mgr;
>       |                                         ^~~
> 
> and other similar errors.
> 
> AFAICS it is missing upstream commit f439a959dcfb ("amdgpu: fix build on
> non-DCN platforms.").

Ah, good catch, I'll go apply this and push out a -rc2 now.

thanks!

greg k-h
