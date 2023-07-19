Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AC814AA8
	for <patches@lists.linux.dev>; Wed, 19 Jul 2023 13:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA56C433C8;
	Wed, 19 Jul 2023 13:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689775103;
	bh=qF9T+TxmPhvIREK/PC887MsMJ3U1Z1uIdylm0SBg8iQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=miJ/Oo0xB/FKAML6+AS97e1XsJhMdo7UHCwdFjRA8e96LgCp+UPu0kInH3OAV0JPV
	 uk6t0Nx2Qu9dLnOuphtGnFLlX8l4PoTUsVp/U/ps6cW65ZTBZufEP2dndzFU0BlrBt
	 oiRrYpeDPhNgNx1AJV9+e7HaojA+QuKOa2jDNQHc=
Date: Wed, 19 Jul 2023 15:58:19 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@denx.de>
Cc: bchihi@baylibre.com, stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.1 000/589] 6.1.39-rc3 review
Message-ID: <2023071956-sequel-chitchat-3f86@gregkh>
References: <20230717201547.359923764@linuxfoundation.org>
 <ZLevLou0rjhSJkZb@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZLevLou0rjhSJkZb@duo.ucw.cz>

On Wed, Jul 19, 2023 at 11:38:54AM +0200, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 6.1.39 release.
> > There are 589 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 19 Jul 2023 20:14:46 +0000.
> > Anything received after that time might be too late.
> 
> 
> > Balsam CHIHI <bchihi@baylibre.com>
> >     thermal/drivers/mediatek: Relocate driver to mediatek folder
> 
> This is big rename in preparation for patch that is not queued for
> 6.1.

Good catch, I dropped the patch it was needed for but missed this
dependency.

greg k-h
