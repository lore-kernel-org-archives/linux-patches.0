Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE3D1CD20;
	Sat, 13 Apr 2024 05:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712986990; cv=none; b=bByOB/gNAXTqzAOwYZFIUbIT5jR0vceKPDlPSwpy5Q7aq9rGBDljFt0ytbo/svZOGqxMUWa3/Mgot42RqixrUBY3gS18gZP7pHk67SU+SNHKQwd1/IUnMj+vzHCL3knPBxqRSjYtqgFkKPn+CTj+sZhdt0CAUJTpLF6zrHne6jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712986990; c=relaxed/simple;
	bh=FH+hGPs2HI2WQNJ07vonU2cF5iI69INZQq3NU/GCQew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fRJVoMZGqADOZD2pvQDJj8jKBXCH+OXJnTR0THY+URsBM9PuXD9CYIDL2QcJMR3Bcb7uyoAV3IUi4ywHOxQX+ODYqtT1d23JHVCo0iVVGZTtxFO5XAZPpZOHF6klyFm+Rpi73bQAXRHd/2yqEeJLwM7Brf/en30VPobY+y7eFbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rSursLhW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSursLhW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C640C113CD;
	Sat, 13 Apr 2024 05:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712986990;
	bh=FH+hGPs2HI2WQNJ07vonU2cF5iI69INZQq3NU/GCQew=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rSursLhWOMWsQ9B7NEMPPmkREfpsmCHwILlfX4sMuooEqrSswQ1tRFZm8hQF+nAHC
	 VF9bolWEzsSdzqp/KvWoULpb/LLPjzDda1IslGX4ee3wsdBqfk/av38VXPeskKfrWQ
	 NKAkySGjimLUHQISG7GAyO601gx8UEd5vfofabPM=
Date: Sat, 13 Apr 2024 07:43:03 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Pavel Machek <pavel@denx.de>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org, maco@android.com,
	christophe.jaillet@wanadoo.fr, sean.anderson@linux.dev
Subject: Re: [PATCH 4.19 000/175] 4.19.312-rc1 review
Message-ID: <2024041357-scrounger-vitamins-0b9e@gregkh>
References: <20240411095419.532012976@linuxfoundation.org>
 <ZhmPpo+EI9Ce3bI1@duo.ucw.cz>
 <87edbaz6vs.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87edbaz6vs.ffs@tglx>

On Fri, Apr 12, 2024 at 10:02:47PM +0200, Thomas Gleixner wrote:
> On Fri, Apr 12 2024 at 21:46, Pavel Machek wrote:
> >> Thomas Gleixner <tglx@linutronix.de>
> >>     timers: Move clearing of base::timer_running under base:: Lock
> >
> > AFAICT, we don't have those NULL assignments in expire_timers in
> > 4.19. Can someone doublecheck this? We also don't support PREEMPT_RT
> > there.
> 
> This has nothing to do with RT.
> 
> But yes, 4.19 has the original bass::running_timer clearing which
> happens at the end of handling all expired timer callbacks and that
> actually happens with base->lock held.
> 
> So right, 4.19 is not affected by this.

Now dropped, thanks.

greg k-h
