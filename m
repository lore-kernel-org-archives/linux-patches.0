Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD6F23A6
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 09:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA8DC433D2;
	Thu, 16 Mar 2023 09:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678958623;
	bh=yoSLZk3pSoNeYTGImZ7sWQR6VVLXyarTRCoh6XHI+y4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B9TZi4zI6l7b74p93zbNWY1feiGyj3GyFXuilmVOlsz+pBFuJn4iaDSuFeeFHuyyc
	 Bl5kBmby9WZTP0Jdgl2/DB11PNIaJxsl62PxmwYtcVTAMOrVdipTi3Pq5RYFXf64Cr
	 NYbkTv02fTFcuvBXEZyeLcx8vmjKq8IDVOCa/6PY=
Date: Thu, 16 Mar 2023 10:23:40 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@denx.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 00/20] 4.14.310-rc2 review
Message-ID: <ZBLgHPbbQaQly5UC@kroah.com>
References: <20230316083335.429724157@linuxfoundation.org>
 <ZBLaULVciUIN+b4P@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBLaULVciUIN+b4P@duo.ucw.cz>

On Thu, Mar 16, 2023 at 09:58:56AM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.14.310 release.
> > There are 20 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> > Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> >     clk: qcom: mmcc-apq8084: remove spdm clocks
> 
> This looks like a cleanup, we should not need it in stable.

Now removed.

> > Paul Elder <paul.elder@ideasonboard.com>
> >     media: ov5640: Fix analogue gain control
> 
> This is an API tweak, not a bugfix. This will have negative impact on
> users upgrading from 4.14.309 and 4.14.310, because you can be pretty
> sure someone out there uses the "old" interface in their
> application. I'm probably responsible for that sin in millipixels
> fork.

They would have the same "impact" when moving to a newer kernel anyway,
so this seems like a valid bugfix to me.

thanks,

greg k-h
